# -*- coding: utf-8 -*-
require 'socket'

time = 0

count = Thread.new do
  loop do
    time += 1
    Thread.pass
    sleep 1
  end
end

sock = Thread.new do
  Socket.unix_server_loop('server.sock') do |sock, addr|
    p sock
    Thread.new do
      loop do
        begin
          sock.write("%s\n" % time)
        rescue Errno::EPIPE => e
          p e
          break
        end
        Thread.pass
        sleep 0.1
      end
    end
  end
end

puts "server launched!"

count.join


