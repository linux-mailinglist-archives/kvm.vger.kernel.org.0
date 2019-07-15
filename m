Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF6C68BC6
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2019 15:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730361AbfGONoo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jul 2019 09:44:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49958 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730012AbfGONoo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jul 2019 09:44:44 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2A75FC058CBA;
        Mon, 15 Jul 2019 13:44:43 +0000 (UTC)
Received: from redhat.com (ovpn-117-250.ams2.redhat.com [10.36.117.250])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 78D2060C64;
        Mon, 15 Jul 2019 13:44:42 +0000 (UTC)
From:   Juan Quintela <quintela@redhat.com>
To:     Peter Maydell <peter.maydell@linaro.org>
Cc:     QEMU Developers <qemu-devel@nongnu.org>,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [PULL 00/19] Migration patches
In-Reply-To: <CAFEAcA9ncjtGdc8CZOJBDBRtzEU8oL7YicVg5PtyiiO2O4z51w@mail.gmail.com>
        (Peter Maydell's message of "Mon, 15 Jul 2019 12:16:57 +0100")
References: <20190712143207.4214-1-quintela@redhat.com>
        <CAFEAcA-ydNS072OH7CyGNq2+sESgonW-8QSJdNYJq6zW-rYjUQ@mail.gmail.com>
        <CAFEAcA9ncjtGdc8CZOJBDBRtzEU8oL7YicVg5PtyiiO2O4z51w@mail.gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.2 (gnu/linux)
Reply-To: quintela@redhat.com
Date:   Mon, 15 Jul 2019 15:44:39 +0200
Message-ID: <87zhlf76pk.fsf@trasno.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Mon, 15 Jul 2019 13:44:43 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Peter Maydell <peter.maydell@linaro.org> wrote:
> On Fri, 12 Jul 2019 at 17:33, Peter Maydell <peter.maydell@linaro.org> wrote:
>> Still fails on aarch32 host, I'm afraid:

Hi

dropping the multifd test patch from now.  For "some" reason, having a
packed struct and 32bits is getting ugly, not sure yet _why_.

Resending the pull request.


>>
>> MALLOC_PERTURB_=${MALLOC_PERTURB_:-$(( ${RANDOM:-0} % 255 + 1))}
>> QTEST_QEMU_BINARY=aarch64-softmmu/qemu-system-aarch64
>> QTEST_QEMU_IMG=qemu-img tests/migration-test -m=quick -k --tap <
>> /dev/null | ./scripts/tap-driver.pl --test-name="migration-test"
>> PASS 1 migration-test /aarch64/migration/deprecated
>> PASS 2 migration-test /aarch64/migration/bad_dest
>> PASS 3 migration-test /aarch64/migration/fd_proto
>> PASS 4 migration-test /aarch64/migration/postcopy/unix
>> PASS 5 migration-test /aarch64/migration/postcopy/recovery
>> PASS 6 migration-test /aarch64/migration/precopy/unix
>> PASS 7 migration-test /aarch64/migration/precopy/tcp
>> PASS 8 migration-test /aarch64/migration/xbzrle/unix
>> malloc(): memory corruption
>> Broken pipe
>> qemu-system-aarch64: load of migration failed: Invalid argument
>> /home/peter.maydell/qemu/tests/libqtest.c:137: kill_qemu() tried to
>> terminate QEMU process but encountered exit status 1
>> Aborted
>> ERROR - too few tests run (expected 9, got 8)
>> /home/peter.maydell/qemu/tests/Makefile.include:899: recipe for target
>> 'check-qtest-aarch64' failed
>
> A run with valgrind:
>
> (armhf)pmaydell@mustang-maydell:~/qemu/build/all-a32$
> QTEST_QEMU_BINARY='valgrind aarch64-softmmu/qemu-system-aarch64'
> tests/migration-test -v -p '/aarch64/migration/multifd/tcp'
> /aarch64/migration/multifd/tcp: ==4034== Memcheck, a memory error detector
> ==4034== Copyright (C) 2002-2017, and GNU GPL'd, by Julian Seward et al.
> ==4034== Using Valgrind-3.13.0 and LibVEX; rerun with -h for copyright info
> ==4034== Command: aarch64-softmmu/qemu-system-aarch64 -qtest
> unix:/tmp/qtest-4033.sock -qtest-log /dev/null -chardev
> socket,path=/tmp/qtest-4033.qmp,id=char0 -mon
> chardev=char0,mode=control -machine accel=qtest -display none -machine
> virt,accel=kvm:tcg,gic-version=max -name vmsource,debug-threads=on
> -cpu max -m 150M -serial file:/tmp/migration-test-mSLr4A/src_serial
> -kernel /tmp/migration-test-mSLr4A/bootsect
> ==4034==
> ==4040== Memcheck, a memory error detector
> ==4040== Copyright (C) 2002-2017, and GNU GPL'd, by Julian Seward et al.
> ==4040== Using Valgrind-3.13.0 and LibVEX; rerun with -h for copyright info
> ==4040== Command: aarch64-softmmu/qemu-system-aarch64 -qtest
> unix:/tmp/qtest-4033.sock -qtest-log /dev/null -chardev
> socket,path=/tmp/qtest-4033.qmp,id=char0 -mon
> chardev=char0,mode=control -machine accel=qtest -display none -machine
> virt,accel=kvm:tcg,gic-version=max -name vmdest,debug-threads=on -cpu
> max -m 150M -serial file:/tmp/migration-test-mSLr4A/dest_serial
> -kernel /tmp/migration-test-mSLr4A/bootsect -incoming tcp:127.0.0.1:0
> ==4040==
> ==4034== Thread 5 multifdsend_0:
> ==4034== Syscall param sendmsg(msg.msg_iov[0]) points to uninitialised byte(s)
> ==4034==    at 0x5299F06: __libc_do_syscall (libc-do-syscall.S:47)
> ==4034==    by 0x5298FCB: sendmsg (sendmsg.c:28)
> ==4034==    by 0x60135D: qio_channel_socket_writev (channel-socket.c:544)
> ==4034==    by 0x5FF995: qio_channel_writev (channel.c:207)
> ==4034==    by 0x5FF995: qio_channel_writev_all (channel.c:171)
> ==4034==    by 0x5FFA0F: qio_channel_write_all (channel.c:257)
> ==4034==    by 0x26BA73: multifd_send_initial_packet (ram.c:711)
> ==4034==    by 0x26BA73: multifd_send_thread (ram.c:1085)
> ==4034==    by 0x63C0B1: qemu_thread_start (qemu-thread-posix.c:502)
> ==4034==    by 0x5290613: start_thread (pthread_create.c:463)
> ==4034==    by 0x53487FB: ??? (clone.S:73)
> ==4034==  Address 0x2320048d is on thread 5's stack
> ==4034==  in frame #5, created by multifd_send_thread (ram.c:1077)
> ==4034==
> ==4034== Thread 6 multifdsend_1:
> ==4034== Invalid write of size 4
> ==4034==    at 0x26BB7C: multifd_send_fill_packet (ram.c:806)
> ==4034==    by 0x26BB7C: multifd_send_thread (ram.c:1101)
> ==4034==    by 0x63C0B1: qemu_thread_start (qemu-thread-posix.c:502)
> ==4034==    by 0x5290613: start_thread (pthread_create.c:463)
> ==4034==    by 0x53487FB: ??? (clone.S:73)
> ==4034==  Address 0x224ed668 is 0 bytes after a block of size 832 alloc'd
> ==4034==    at 0x4841BC4: calloc (vg_replace_malloc.c:711)
> ==4034==    by 0x5018269: g_malloc0 (in
> /usr/lib/arm-linux-gnueabihf/libglib-2.0.so.0.5600.4)
> ==4034==
> ==4034== Invalid write of size 4
> ==4034==    at 0x26BB82: multifd_send_fill_packet (ram.c:806)
> ==4034==    by 0x26BB82: multifd_send_thread (ram.c:1101)
> ==4034==    by 0x63C0B1: qemu_thread_start (qemu-thread-posix.c:502)
> ==4034==    by 0x5290613: start_thread (pthread_create.c:463)
> ==4034==    by 0x53487FB: ??? (clone.S:73)
> ==4034==  Address 0x224ed66c is 4 bytes after a block of size 832 alloc'd
> ==4034==    at 0x4841BC4: calloc (vg_replace_malloc.c:711)
> ==4034==    by 0x5018269: g_malloc0 (in
> /usr/lib/arm-linux-gnueabihf/libglib-2.0.so.0.5600.4)
> ==4034==
> ==4034== Invalid read of size 4
> ==4034==    at 0x5FF1DA: qio_channel_writev_full (channel.c:86)
> ==4034==    by 0x5FF995: qio_channel_writev (channel.c:207)
> ==4034==    by 0x5FF995: qio_channel_writev_all (channel.c:171)
> ==4034==    by 0x5FFA0F: qio_channel_write_all (channel.c:257)
> ==4034==    by 0x26BBD9: multifd_send_thread (ram.c:1111)
> ==4034==    by 0x63C0B1: qemu_thread_start (qemu-thread-posix.c:502)
> ==4034==    by 0x5290613: start_thread (pthread_create.c:463)
> ==4034==    by 0x53487FB: ??? (clone.S:73)
> ==4034==  Address 0x30 is not stack'd, malloc'd or (recently) free'd
> ==4034==
> ==4034==
> ==4034== Process terminating with default action of signal 11 (SIGSEGV)
> ==4034==  Access not within mapped region at address 0x30
> ==4034==    at 0x5FF1DA: qio_channel_writev_full (channel.c:86)
> ==4034==    by 0x5FF995: qio_channel_writev (channel.c:207)
> ==4034==    by 0x5FF995: qio_channel_writev_all (channel.c:171)
> ==4034==    by 0x5FFA0F: qio_channel_write_all (channel.c:257)
> ==4034==    by 0x26BBD9: multifd_send_thread (ram.c:1111)
> ==4034==    by 0x63C0B1: qemu_thread_start (qemu-thread-posix.c:502)
> ==4034==    by 0x5290613: start_thread (pthread_create.c:463)
> ==4034==    by 0x53487FB: ??? (clone.S:73)
> ==4034==  If you believe this happened as a result of a stack
> ==4034==  overflow in your program's main thread (unlikely but
> ==4034==  possible), you can try to increase the size of the
> ==4034==  main thread stack using the --main-stacksize= flag.
> ==4034==  The main thread stack size used in this run was 8388608.
> ==4034==
> ==4034== HEAP SUMMARY:
> ==4034==     in use at exit: 5,994,911 bytes in 23,588 blocks
> ==4034==   total heap usage: 87,487 allocs, 63,899 frees, 17,732,188
> bytes allocated
> ==4034==
> ==4034== LEAK SUMMARY:
> ==4034==    definitely lost: 56 bytes in 1 blocks
> ==4034==    indirectly lost: 64 bytes in 2 blocks
> ==4034==      possibly lost: 1,620 bytes in 26 blocks
> ==4034==    still reachable: 5,993,171 bytes in 23,559 blocks
> ==4034==         suppressed: 0 bytes in 0 blocks
> ==4034== Rerun with --leak-check=full to see details of leaked memory
> ==4034==
> ==4034== For counts of detected and suppressed errors, rerun with: -v
> ==4034== Use --track-origins=yes to see where uninitialised values come from
> ==4034== ERROR SUMMARY: 66 errors from 4 contexts (suppressed: 6 from 3)
> Broken pipe
> qemu-system-aarch64: load of migration failed: Input/output error
> ==4040==
> ==4040== HEAP SUMMARY:
> ==4040==     in use at exit: 4,893,269 bytes in 19,702 blocks
> ==4040==   total heap usage: 86,196 allocs, 66,494 frees, 17,438,183
> bytes allocated
> ==4040==
> ==4040== LEAK SUMMARY:
> ==4040==    definitely lost: 0 bytes in 0 blocks
> ==4040==    indirectly lost: 0 bytes in 0 blocks
> ==4040==      possibly lost: 1,160 bytes in 5 blocks
> ==4040==    still reachable: 4,892,109 bytes in 19,697 blocks
> ==4040==         suppressed: 0 bytes in 0 blocks
> ==4040== Rerun with --leak-check=full to see details of leaked memory
> ==4040==
> ==4040== For counts of detected and suppressed errors, rerun with: -v
> ==4040== ERROR SUMMARY: 0 errors from 0 contexts (suppressed: 6 from 3)
> /home/peter.maydell/qemu/tests/libqtest.c:137: kill_qemu() tried to
> terminate QEMU process but encountered exit status 1
> Aborted
>
> thanks
> -- PMM
