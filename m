Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C05D6655F6
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 09:24:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232256AbjAKIYB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 03:24:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236011AbjAKIXv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 03:23:51 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53DC25FB6
        for <kvm@vger.kernel.org>; Wed, 11 Jan 2023 00:23:48 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 9053516F09;
        Wed, 11 Jan 2023 08:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1673425425; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rYqNtp24dl3qk4QOlSlxTQyewGfRUwiZ3+moxRU6XFE=;
        b=Vn0W5J67bgbttl7xC2E000I58SaB3I2oCsWRUeyR7T3D7Etuaq/Nc5jl8Fs2YzVLU+Cp95
        2VeWUuIjXRpmrn0VZX5wp89ZMlgR4EvHyoLRAQ/M8wFACYUI3y74m30QQKOIA9WE4M118R
        QOxQc8hYyg75KCrdpcnhN9awcffMXfA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1673425425;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rYqNtp24dl3qk4QOlSlxTQyewGfRUwiZ3+moxRU6XFE=;
        b=sr/rIZ3qyYmQrHdhSQFqG425Vx424JOiLZkLTQ7HI1J/xcWJOIz6ovF+cQP3KP2ysc9GRs
        r1Qjj8Pys8Cn3TBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 61B8313591;
        Wed, 11 Jan 2023 08:23:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id oqcZFxFyvmNyQgAAMHmgww
        (envelope-from <vbabka@suse.cz>); Wed, 11 Jan 2023 08:23:45 +0000
Message-ID: <6e37387d-ca5c-c9a3-6882-7ecfa75453a8@suse.cz>
Date:   Wed, 11 Jan 2023 09:23:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: Stalls in qemu with host running 6.1 (everything stuck at
 mmap_read_lock())
To:     Jiri Slaby <jirislaby@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        mm <linux-mm@kvack.org>
Cc:     yuzhao@google.com, Michal Hocko <MHocko@suse.com>,
        shy828301@gmail.com, Matthew Wilcox <willy@infradead.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
References: <b8017e09-f336-3035-8344-c549086c2340@kernel.org>
Content-Language: en-US
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <b8017e09-f336-3035-8344-c549086c2340@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_SOFTFAIL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/11/23 09:00, Jiri Slaby wrote:
> Hi,
> 
> after I updated the host from 6.0 to 6.1 (being at 6.1.4 ATM), my qemu 
> VMs started stalling (and the host at the same point too). It doesn't 
> happen right after boot, maybe a suspend-resume cycle is needed (or 
> longer uptime, or a couple of qemu VM starts, or ...). But when it 
> happens, it happens all the time till the next reboot.
> 
> Older guest's kernels/distros are affected as well as Win10.
> 
> In guests, I see for example stalls in memset_orig or 
> smp_call_function_many_cond -- traces below.
> 
> qemu-kvm-7.1.0-13.34.x86_64 from openSUSE.
> 
> It's quite interesting that:
>    $ cat /proc/<PID_OF_QEMU>/cmdline
> is stuck at read:
> 
> openat(AT_FDCWD, "/proc/12239/cmdline", O_RDONLY) = 3
> newfstatat(3, "", {st_mode=S_IFREG|0444, st_size=0, ...}, AT_EMPTY_PATH) = 0
> fadvise64(3, 0, 0, POSIX_FADV_SEQUENTIAL) = 0
> mmap(NULL, 139264, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 
> 0) = 0x7f22f0487000
> read(3, ^C^C^C^\^C
> 
> too. So I dumped blocked tasks (sysrq-w) on _host_ (see below) and 
> everything seems to stall on mmap_read_lock() or 
> mmap_write_lock_killable(). I don't see the hog (the one actually 
> _having_ and sitting on the (presumably write) lock) in the dump though. 
> I will perhaps boot a LOCKDEP-enabled kernel, so that I can do sysrq-d 
> next time and see the holder.

How about setting up a kdump for the host, triggering a crash dump and
investigating that? If it's a write owner forgetting unlock, rw_semaphore
owner field could point to it. But it can also be that a down_write() is
pending, blocking further down_read()'s, while the current reader is missing
and not by design accurately tracked in the owner field.

Oh and it's also possible to enable the mmap_lock specific tracepoints and
analyze that.

> There should be enough free memory (note caches at 8G):
>                 total        used        free      shared  buff/cache 
> available
> Mem:            15Gi        10Gi       400Mi       2,5Gi       8,0Gi 
>    5,0Gi
> Swap:             0B          0B          0B
> 
> 
> I rmmoded kvm-intel now, so:
>    qemu-kvm: failed to initialize kvm: No such file or directory
>    qemu-kvm: falling back to tcg
> and it behaves the same (more or less expected).
> 
> Is this known? Any idea how to debug this? Or maybe someone (I CCed a 
> couple of guys who Acked mmap_*_lock() shuffling patches in 6.1) has a 
> clue? Bisection is hard as it reproduces only under certain unknown 
> circumstances.
> 
> 
> 
> 
> Now the promised dumps:
> 
>  > sysrq: Show Blocked State
>  > task:plasmashell     state:D stack:0     pid:2064  ppid:1905 
> flags:0x00000002
>  > Call Trace:
>  >  <TASK>
>  >  __schedule+0x360/0x1350
>  >  schedule+0x5a/0xd0
>  >  rwsem_down_read_slowpath+0x272/0x4c0
>  >  down_read_killable+0x3d/0xa0
>  >  __access_remote_vm+0x4c/0x370
>  >  proc_pid_cmdline_read+0x17a/0x3c0
>  >  vfs_read+0xa2/0x2c0
>  >  ksys_read+0x63/0xe0
>  >  do_syscall_64+0x58/0x80
>  >  entry_SYSCALL_64_after_hwframe+0x63/0xcd
>  > RIP: 0033:0x7fda6b70795c
>  > RSP: 002b:00007ffdd7b108b0 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
>  > RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fda6b70795c
>  > RDX: 0000000000004000 RSI: 00007ffdd7b10a20 RDI: 0000000000000028
>  > RBP: 000056536a70f610 R08: 0000000000000000 R09: 0000000000004000
>  > R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000004000
>  > R13: 0000000000004000 R14: 00007ffdd7b10a20 R15: 00007ffdd7b10a20
>  >  </TASK>
>  > task:qemu-kvm        state:D stack:0     pid:12249 ppid:1905 
> flags:0x00000002
>  > Call Trace:
>  >  <TASK>
>  >  __schedule+0x360/0x1350
>  >  schedule+0x5a/0xd0
>  >  rwsem_down_read_slowpath+0x272/0x4c0
>  >  do_user_addr_fault+0x413/0x690
>  >  exc_page_fault+0x66/0x150
>  >  asm_exc_page_fault+0x22/0x30
>  > RIP: 0033:0x55fc42ea2e9e
>  > RSP: 002b:00007f054e5391c8 EFLAGS: 00010246
>  > RAX: 00007f052aa01041 RBX: 0000000000000005 RCX: 0000000000000000
>  > RDX: 00007f052aa01040 RSI: 000000000000008b RDI: 00007f0544000b70
>  > RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000005
>  > R10: 0000000000000003 R11: 0000000000000d60 R12: 00007f0544000b70
>  > R13: fffffffffffffff0 R14: 000000000000000c R15: 00007f054400a510
>  >  </TASK>
>  > task:qemu-kvm        state:D stack:0     pid:12251 ppid:1905 
> flags:0x00000002
>  > Call Trace:
>  >  <TASK>
>  >  __schedule+0x360/0x1350
>  >  schedule+0x5a/0xd0
>  >  rwsem_down_write_slowpath+0x358/0x6a0
>  >  down_write_killable+0x60/0x80
>  >  do_mprotect_pkey+0xe9/0x430
>  >  __x64_sys_mprotect+0x1b/0x30
>  >  do_syscall_64+0x58/0x80
>  >  entry_SYSCALL_64_after_hwframe+0x63/0xcd
>  > RIP: 0033:0x7f05514a8ccb
>  > RSP: 002b:00007f054d536fa8 EFLAGS: 00000206 ORIG_RAX: 000000000000000a
>  > RAX: ffffffffffffffda RBX: 00007f042c000030 RCX: 00007f05514a8ccb
>  > RDX: 0000000000000003 RSI: 0000000000001000 RDI: 00007f042d304000
>  > RBP: 0000000000000430 R08: 0000000001304000 R09: 0000000001305000
>  > R10: 00007f042d303bf0 R11: 0000000000000206 R12: 0000000000000410
>  > R13: 0000000000001000 R14: 0000000000000450 R15: 0000000000000000
>  >  </TASK>
>  > task:qemu-kvm        state:D stack:0     pid:12252 ppid:1905 
> flags:0x00000002
>  > Call Trace:
>  >  <TASK>
>  >  __schedule+0x360/0x1350
>  >  schedule+0x5a/0xd0
>  >  rwsem_down_read_slowpath+0x272/0x4c0
>  >  do_user_addr_fault+0x413/0x690
>  >  exc_page_fault+0x66/0x150
>  >  asm_exc_page_fault+0x22/0x30
>  > RIP: 0033:0x55fc42ea6217
>  > RSP: 002b:00007f054cd361d0 EFLAGS: 00010246
>  > RAX: 00007f052c593fff RBX: 00007f0500000018 RCX: 0000000000000000
>  > RDX: 00007f052c593ffe RSI: 00000000000000e9 RDI: 00007f0430000b70
>  > RBP: 00007f0430000b70 R08: 0000000000000000 R09: 0000000000000000
>  > R10: 0000000000000000 R11: ffffffffd3a6c015 R12: 000000000000000c
>  > R13: 0000000000000030 R14: 0000000000000080 R15: 00007f043000bad8
>  >  </TASK>
>  > task:qemu-kvm        state:D stack:0     pid:12299 ppid:1905 
> flags:0x00000002
>  > Call Trace:
>  >  <TASK>
>  >  __schedule+0x360/0x1350
>  >  schedule+0x5a/0xd0
>  >  rwsem_down_read_slowpath+0x272/0x4c0
>  >  do_madvise.part.0+0xe2/0x2a0
>  >  __x64_sys_madvise+0x5a/0x70
>  >  do_syscall_64+0x58/0x80
>  >  entry_SYSCALL_64_after_hwframe+0x63/0xcd
>  > RIP: 0033:0x7f05514a8dab
>  > RSP: 002b:00007f054f381758 EFLAGS: 00000206 ORIG_RAX: 000000000000001c
>  > RAX: ffffffffffffffda RBX: 00007f054eb82000 RCX: 00007f05514a8dab
>  > RDX: 0000000000000004 RSI: 00000000007fb000 RDI: 00007f054eb82000
>  > RBP: 0000000000801000 R08: 000055fc45749778 R09: 000055fc45749798
>  > R10: 0000000000000008 R11: 0000000000000206 R12: fffffffffffffb68
>  > R13: 000000000000000b R14: 00007fff19b2efe0 R15: 00007f054eb82000
>  >  </TASK>
>  > task:qemu-kvm        state:D stack:0     pid:12300 ppid:1905 
> flags:0x00000002
>  > Call Trace:
>  >  <TASK>
>  >  __schedule+0x360/0x1350
>  >  schedule+0x5a/0xd0
>  >  rwsem_down_read_slowpath+0x272/0x4c0
>  >  do_madvise.part.0+0xe2/0x2a0
>  >  __x64_sys_madvise+0x5a/0x70
>  >  do_syscall_64+0x58/0x80
>  >  entry_SYSCALL_64_after_hwframe+0x63/0xcd
>  > RIP: 0033:0x7f05514a8dab
>  > RSP: 002b:00007f041b4b7758 EFLAGS: 00000206 ORIG_RAX: 000000000000001c
>  > RAX: ffffffffffffffda RBX: 00007f041acb8000 RCX: 00007f05514a8dab
>  > RDX: 0000000000000004 RSI: 00000000007fb000 RDI: 00007f041acb8000
>  > RBP: 0000000000801000 R08: 000055fc45749778 R09: 000055fc45749798
>  > R10: 0000000000000008 R11: 0000000000000206 R12: fffffffffffffb68
>  > R13: 000000000000000b R14: 00007fff19b2efe0 R15: 00007f041acb8000
>  >  </TASK>
>  > task:qemu-kvm        state:D stack:0     pid:12301 ppid:1905 
> flags:0x00000002
>  > Call Trace:
>  >  <TASK>
>  >  __schedule+0x360/0x1350
>  >  schedule+0x5a/0xd0
>  >  rwsem_down_read_slowpath+0x272/0x4c0
>  >  do_madvise.part.0+0xe2/0x2a0
>  >  __x64_sys_madvise+0x5a/0x70
>  >  do_syscall_64+0x58/0x80
>  >  entry_SYSCALL_64_after_hwframe+0x63/0xcd
>  > RIP: 0033:0x7f05514a8dab
>  > RSP: 002b:00007f041acb6758 EFLAGS: 00000206 ORIG_RAX: 000000000000001c
>  > RAX: ffffffffffffffda RBX: 00007f041a4b7000 RCX: 00007f05514a8dab
>  > RDX: 0000000000000004 RSI: 00000000007fb000 RDI: 00007f041a4b7000
>  > RBP: 0000000000801000 R08: 0000000000000005 R09: 0000000000001d4c
>  > R10: 0000000000000008 R11: 0000000000000206 R12: fffffffffffffb68
>  > R13: 000000000000000b R14: 00007fff19b2efe0 R15: 00007f041a4b7000
>  >  </TASK>
>  > task:qemu-kvm        state:D stack:0     pid:12309 ppid:1905 
> flags:0x00000002
>  > Call Trace:
>  >  <TASK>
>  >  __schedule+0x360/0x1350
>  >  schedule+0x5a/0xd0
>  >  rwsem_down_read_slowpath+0x272/0x4c0
>  >  do_madvise.part.0+0xe2/0x2a0
>  >  __x64_sys_madvise+0x5a/0x70
>  >  do_syscall_64+0x58/0x80
>  >  entry_SYSCALL_64_after_hwframe+0x63/0xcd
>  > RIP: 0033:0x7f05514a8dab
>  > RSP: 002b:00007f041a4b5758 EFLAGS: 00000206 ORIG_RAX: 000000000000001c
>  > RAX: ffffffffffffffda RBX: 00007f0419cb6000 RCX: 00007f05514a8dab
>  > RDX: 0000000000000004 RSI: 00000000007fb000 RDI: 00007f0419cb6000
>  > RBP: 0000000000801000 R08: 000055fc45749778 R09: 000055fc45749798
>  > R10: 0000000000000008 R11: 0000000000000206 R12: fffffffffffffb68
>  > R13: 000000000000000b R14: 00007fff19b2efe0 R15: 00007f0419cb6000
>  >  </TASK>
>  > task:qemu-kvm        state:D stack:0     pid:12310 ppid:1905 
> flags:0x00000002
>  > Call Trace:
>  >  <TASK>
>  >  __schedule+0x360/0x1350
>  >  schedule+0x5a/0xd0
>  >  rwsem_down_read_slowpath+0x272/0x4c0
>  >  do_madvise.part.0+0xe2/0x2a0
>  >  __x64_sys_madvise+0x5a/0x70
>  >  do_syscall_64+0x58/0x80
>  >  entry_SYSCALL_64_after_hwframe+0x63/0xcd
>  > RIP: 0033:0x7f05514a8dab
>  > RSP: 002b:00007f04178b3758 EFLAGS: 00000206 ORIG_RAX: 000000000000001c
>  > RAX: ffffffffffffffda RBX: 00007f04170b4000 RCX: 00007f05514a8dab
>  > RDX: 0000000000000004 RSI: 00000000007fb000 RDI: 00007f04170b4000
>  > RBP: 0000000000801000 R08: 000055fc45749778 R09: 000055fc45749798
>  > R10: 0000000000000008 R11: 0000000000000206 R12: fffffffffffffb68
>  > R13: 0000000000000000 R14: 00007f041a4b5300 R15: 00007f04170b4000
>  >  </TASK>
>  > task:ps              state:D stack:0     pid:12395 ppid:5727 
> flags:0x00000002
>  > Call Trace:
>  >  <TASK>
>  >  __schedule+0x360/0x1350
>  >  schedule+0x5a/0xd0
>  >  rwsem_down_read_slowpath+0x272/0x4c0
>  >  down_read_killable+0x3d/0xa0
>  >  __access_remote_vm+0x4c/0x370
>  >  proc_pid_cmdline_read+0x17a/0x3c0
>  >  vfs_read+0xa2/0x2c0
>  >  ksys_read+0x63/0xe0
>  >  do_syscall_64+0x58/0x80
>  >  entry_SYSCALL_64_after_hwframe+0x63/0xcd
>  > RIP: 0033:0x7f02fa455921
>  > RSP: 002b:00007ffca71c5828 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
>  > RAX: ffffffffffffffda RBX: 00007f02f9f53010 RCX: 00007f02fa455921
>  > RDX: 0000000000020000 RSI: 00007f02f9f53010 RDI: 0000000000000006
>  > RBP: 0000000000000020 R08: 0000000000000000 R09: 0000000000000073
>  > R10: 0000000000000000 R11: 0000000000000246 R12: 00007f02f9f53010
>  > R13: 0000000000000006 R14: 0000000000000000 R15: 0000000000000000
>  >  </TASK>
>  > task:htop            state:D stack:0     pid:12400 ppid:4676 
> flags:0x00000002
>  > Call Trace:
>  >  <TASK>
>  >  __schedule+0x360/0x1350
>  >  schedule+0x5a/0xd0
>  >  rwsem_down_read_slowpath+0x272/0x4c0
>  >  down_read_killable+0x3d/0xa0
>  >  __access_remote_vm+0x4c/0x370
>  >  proc_pid_cmdline_read+0x17a/0x3c0
>  >  vfs_read+0xa2/0x2c0
>  >  ksys_read+0x63/0xe0
>  >  do_syscall_64+0x58/0x80
>  >  entry_SYSCALL_64_after_hwframe+0x63/0xcd
>  > RIP: 0033:0x7f4284748921
>  > RSP: 002b:00007ffc88c25398 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
>  > RAX: ffffffffffffffda RBX: 0000000000001000 RCX: 00007f4284748921
>  > RDX: 0000000000001000 RSI: 00007ffc88c25490 RDI: 0000000000000007
>  > RBP: 00007ffc88c25490 R08: 0000563dd4c68ab0 R09: 0000000000000000
>  > R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
>  > R13: 0000000000000007 R14: 00007ffc88c265a0 R15: 0000563dd4ca46c0
>  >  </TASK>
>  > task:htop            state:D stack:0     pid:12416 ppid:4595 
> flags:0x00000006
>  > Call Trace:
>  >  <TASK>
>  >  __schedule+0x360/0x1350
>  >  schedule+0x5a/0xd0
>  >  rwsem_down_read_slowpath+0x272/0x4c0
>  >  down_read_killable+0x3d/0xa0
>  >  __access_remote_vm+0x4c/0x370
>  >  proc_pid_cmdline_read+0x17a/0x3c0
>  >  vfs_read+0xa2/0x2c0
>  >  ksys_read+0x63/0xe0
>  >  do_syscall_64+0x58/0x80
>  >  entry_SYSCALL_64_after_hwframe+0x63/0xcd
>  > RIP: 0033:0x7fe4d1b7f921
>  > RSP: 002b:00007ffc8603e788 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
>  > RAX: ffffffffffffffda RBX: 0000000000001000 RCX: 00007fe4d1b7f921
>  > RDX: 0000000000001000 RSI: 00007ffc8603e880 RDI: 0000000000000007
>  > RBP: 00007ffc8603e880 R08: 00005602572e7a20 R09: 0000000000000000
>  > R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
>  > R13: 0000000000000007 R14: 00007ffc8603f990 R15: 000056025735d540
>  >  </TASK>
>  > task:htop            state:D stack:0     pid:12464 ppid:12441 
> flags:0x00000006
>  > Call Trace:
>  >  <TASK>
>  >  __schedule+0x360/0x1350
>  >  schedule+0x5a/0xd0
>  >  rwsem_down_read_slowpath+0x272/0x4c0
>  >  down_read_killable+0x3d/0xa0
>  >  __access_remote_vm+0x4c/0x370
>  >  proc_pid_cmdline_read+0x17a/0x3c0
>  >  vfs_read+0xa2/0x2c0
>  >  ksys_read+0x63/0xe0
>  >  do_syscall_64+0x58/0x80
>  >  entry_SYSCALL_64_after_hwframe+0x63/0xcd
>  > RIP: 0033:0x7fb1e298f921
>  > RSP: 002b:00007ffe419c8c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
>  > RAX: ffffffffffffffda RBX: 0000000000001000 RCX: 00007fb1e298f921
>  > RDX: 0000000000001000 RSI: 00007ffe419c8d70 RDI: 0000000000000007
>  > RBP: 00007ffe419c8d70 R08: 0000565345f95680 R09: 0000000000000000
>  > R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
>  > R13: 0000000000000007 R14: 00007ffe419c9e80 R15: 0000565345fd0470
>  >  </TASK>
> 
> 
> 
> 
> 
> 
> 
> 
> 
> Guest lockups:
> 
> 
> 
>  > BUG: workqueue lockup - pool cpus=3 node=0 flags=0x0 nice=0 stuck for 
> 49s!
>  > Showing busy workqueues and worker pools:
>  > workqueue mm_percpu_wq: flags=0x8
>  >   pwq 6: cpus=3 node=0 flags=0x0 nice=0 active=2/256 refcnt=4
>  >     pending: vmstat_update, lru_add_drain_per_cpu BAR(49)
>  > rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
>  > watchdog: BUG: soft lockup - CPU#2 stuck for 211s! [jbd2/sda1-8:373]
>  > Modules linked in: af_packet rfkill ...
>  > CPU: 2 PID: 373 Comm: jbd2/sda1-8 Kdump: loaded Not tainted 
> 6.1.4-rc1-1.gbc1c341-default #1 openSUSE Tumbleweed (unreleased) 
> 0c91ab593caf7d5045d7e3b6ff751ade7e57ec84
>  > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
>  > RIP: 0010:memset_orig+0x33/0xb0
>  > Code: 01 01 01 01 01 01 01 01 48 0f af c1 41 89 f9 41 83 e1 07 75 74 
> 48 89 d1 48 c1 e9 06 74 39 66 0f 1f 84 00 00 00 00 00 48 ff c9 <48> 89 
> 07 48 89 47 08 48 89 47 10 48 89 47 18 48 89 47 20 48 89 47
>  > RSP: 0018:ffffbd1fc0487d08 EFLAGS: 00010216
>  > RAX: 0000000000000000 RBX: ffff9fdb1b619138 RCX: 000000000000003f
>  > RDX: 0000000000001000 RSI: 0000000000000000 RDI: ffff9fdb39f19000
>  > RBP: ffff9fdb0054f000 R08: ffff9fdb0565cb00 R09: 0000000000000000
>  > R10: ffff9fdb39f19000 R11: ffff9fdb442d71c0 R12: 0000000001000000
>  > R13: ffff9fdb05079800 R14: ffff9fdb01658870 R15: ffff9fdb01658870
>  > FS:  0000000000000000(0000) GS:ffff9fdb40d00000(0000) 
> knlGS:0000000000000000
>  > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  > CR2: 00005635dbce3fb8 CR3: 0000000103d54000 CR4: 00000000000006e0
>  > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>  > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>  > Call Trace:
>  >  <TASK>
>  >  jbd2_journal_get_descriptor_buffer+0x88/0xf0 [jbd2 
> 3adb6041f8aa59fe471169b0e9945d8c67491cc7]
>  >  jbd2_journal_commit_transaction+0x9e0/0x18b0 [jbd2 
> 3adb6041f8aa59fe471169b0e9945d8c67491cc7]
>  >  kjournald2+0xa9/0x260 [jbd2 3adb6041f8aa59fe471169b0e9945d8c67491cc7]
>  >  kthread+0xda/0x100
>  >  ret_from_fork+0x22/0x30
>  >  </TASK>
> 
> 
> ========================================
> 
> 
>  > watchdog: BUG: soft lockup - CPU#2 stuck for 26s! [kworker/2:2:134]
>  > Modules linked in: af_packet rfkill ...
>  > Supported: No, Unreleased kernel
>  > CPU: 2 PID: 134 Comm: kworker/2:2 Not tainted 
> 5.14.21-150500.86.gca1fbb8-default #1 SLE15-SP5 (unreleased) 
> f54a3c78ee6447e20bc183538de8800cbe783c87
>  > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
>  > Workqueue: events drm_fb_helper_damage_work [drm_kms_helper]
>  > RIP: 0010:smp_call_function_many_cond+0x123/0x560
>  > Code: ef e8 71 22 42 00 3b 05 2f 2c bd 01 89 c5 73 24 48 63 c5 49 8b 
> 7d 00 48 03 3c c5 a0 bb 42 b1 66 90 8b 47 08 a8 01 74 0a f3 90 <8b> 57 
> 08 83 e2 01 75 f6 eb c7 48 83 c4 48 5b 5d 41 5c 41 5d 41 5e
>  > RSP: 0018:ffff9eff00227c68 EFLAGS: 00000202
>  > RAX: 0000000000000011 RBX: 0000000000000001 RCX: 0000000000000000
>  > RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff89a1c0dba8c0
>  > RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000000
>  > R10: 0000000000000003 R11: 0000000000000000 R12: ffff89a1c0d34b00
>  > R13: ffff89a1c0d34b00 R14: 0000000000000000 R15: 0000000000000003
>  > FS:  0000000000000000(0000) GS:ffff89a1c0d00000(0000) 
> knlGS:0000000000000000
>  > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  > CR2: 0000561f1be53000 CR3: 00000001024e6000 CR4: 00000000000006e0
>  > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>  > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>  > Call Trace:
>  >  <TASK>
>  >  on_each_cpu_cond_mask+0x25/0x40
>  >  __purge_vmap_area_lazy+0xba/0x6d0
>  >  free_vmap_area_noflush+0x214/0x2f0
>  >  remove_vm_area+0x80/0x90
>  >  __vunmap+0x5e/0x260
>  >  drm_gem_shmem_vunmap+0x6f/0x90 [drm_shmem_helper 
> b732157accb2fabb75791e2dc3d5d21a30cf33cb]
>  >  drm_gem_vunmap+0x24/0x50 [drm 14b5c4e21fb011b0159efe14dd82da3407d64716]
>  >  drm_fb_helper_damage_work+0x16f/0x2f0 [drm_kms_helper 
> b697aeb79f8910d3e952c8c60069f3e3382437ae]
>  >  process_one_work+0x267/0x440
>  >  worker_thread+0x2d/0x3d0
>  >  kthread+0x156/0x180
>  >  ret_from_fork+0x22/0x30
>  >  </TASK>
> 
> 
> ========================================
> 
> 
>  > watchdog: BUG: soft lockup - CPU#0 stuck for 319s! [watchdogd:57]
>  > watchdog: BUG: soft lockup - CPU#3 stuck for 348s! [repo2solv:1139]
>  > Modules linked in: af_packet rfkill nls_iso8859_1 nls_cp437 
> snd_hda_codec_generic ledtrig_audio snd_hda_intel snd_intel_dspcfg 
> snd_intel_sdw_acpi snd_hda_codec snd_hda_core snd_hwdep vfat snd_pcm fat 
> iTCO_wdt snd_timer ppdev virtio_net intel_pmc_bxt tiny_power_button 
> i2c_i801 iTCO_vend>
>  > CPU: 3 PID: 1139 Comm: repo2solv Kdump: loaded Not tainted 
> 6.1.4-rc1-1.gbc1c341-default #1 openSUSE Tumbleweed (unreleased) 
> 0c91ab593caf7d5045d7e3b6ff751ade7e57ec84
>  > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
>  > RIP: 0010:clear_page_orig+0x12/0x40
>  > Code: 5d c3 cc cc cc cc cc cc b9 00 02 00 00 31 c0 f3 48 ab c3 cc cc 
> cc cc 90 31 c0 b9 40 00 00 00 66 0f 1f 84 00 00 00 00 00 ff c9 <48> 89 
> 07 48 89 47 08 48 89 47 10 48 89 47 18 48 89 47 20 48 89 47
>  > RSP: 0000:ffffb644c0da3be8 EFLAGS: 00010216
>  > RAX: 0000000000000000 RBX: fffffccec4828000 RCX: 000000000000003f
>  > RDX: fffffccec4828000 RSI: fffffccec4828040 RDI: ffffa04a20a00000
>  > RBP: 0000000000000000 R08: ffffb644c0da3d10 R09: 0000000000028b29
>  > R10: 0000000000000010 R11: ffffa04a441d51c0 R12: 0000000000140dca
>  > R13: 0000000000000040 R14: 0000000000000001 R15: 0000000000000286
>  > FS:  00007f91de710f80(0000) GS:ffffa04a40d80000(0000) 
> knlGS:0000000000000000
>  > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  > CR2: 00007f91de3d3000 CR3: 0000000101f86000 CR4: 00000000000006e0
>  > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>  > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>  > Call Trace:
>  >  <TASK>
>  >  post_alloc_hook+0xa9/0xe0
>  >  get_page_from_freelist+0x4d9/0x1590
>  >  __alloc_pages+0xec/0x240
>  >  __folio_alloc+0x17/0x50
>  >  vma_alloc_folio+0x9c/0x370
>  >  __handle_mm_fault+0x942/0xfe0
>  >  handle_mm_fault+0xdb/0x2d0
>  >  do_user_addr_fault+0x1ba/0x690
>  >  exc_page_fault+0x66/0x150
>  >  asm_exc_page_fault+0x22/0x30
> 
> thanks,

