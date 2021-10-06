Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 463D64239A0
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 10:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237796AbhJFIWa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 04:22:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237749AbhJFIW3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Oct 2021 04:22:29 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA6B2C061749;
        Wed,  6 Oct 2021 01:20:37 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id g184so1817376pgc.6;
        Wed, 06 Oct 2021 01:20:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=PMQZqYTFpedDjLDvb+0GP8xs3oFcy5VZv4sNrMAu4zY=;
        b=d/MIp0fF0JQ5Lxb9nQMwVO7uTYP3kiARay+K4alzpXi/A5OqH5zGFkCwHGtrcgT7E3
         L6vKNUXdomWHJ0xkppDinSFuy4L2Uk639mZ74GDqow9fC9pMK2eg56akXeb2udNXarTD
         1+B6wlziMK5NNWedlv432et26D6vjo6IuUJLGNouaGqVxKSKt+TR3OhcWYOG1nsFM0ek
         CY/l7Wh0H/b1CuoolZNjnLFHg4tnI5lx6HSzY01A7prSzKDtgMIUpR6smGyuxFkqp6A7
         KZGlUGnKRSXzT4kpIYv8yvTk/u4MMolBm7xYNBzJ/mZi+6HSDIHXRy6iMeIF52sYqrKI
         9wBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=PMQZqYTFpedDjLDvb+0GP8xs3oFcy5VZv4sNrMAu4zY=;
        b=vr6QxKWyiFPO02QcdzeSwxxocAQ/Z1iF0yWmj1lodkLJ1fXmUkr0O2FudEv0a94KBN
         yILLbJ9HACSkQbIyjwVZDZ0cI0bb4IrcqnXyYcaAjsickuYrkCGRFZsty4ellCahNY+3
         VHy3W8gZ3Pdiym7QlY3h+4mYpQZ/BMFqj7SXRCRjQmMkXmhfkkKzrPMME5nyUNDmTRCN
         07rkam5wcD26/nd9UqfExkzwhTBTmmx5+VC4ZhR6OaCeXP3Gx3T3fVvww4cB5IFdY5WH
         JiKDBdUUcVDUk1f3lIFkH176wr8xSXVvORt6eXqiw0QHWgbFP0uzvZe1suzIjHcO/g8X
         3INA==
X-Gm-Message-State: AOAM533gVYcFp1bEL42xnbYwcJuUV3xAZ1VbwZ35DfwTigAPgzIu24Z1
        P68imE42fEFtbPAuKg6X3RWjW5kW/v+jtI+UVlgWuo3TtrNBqFg=
X-Google-Smtp-Source: ABdhPJzefWWp8QVUAcRTRkdeEvhbjjvOCrcaQoMTysIyHspvWE0laDRXi9BRJPFZOfh8ySGBrsKWHrcjgtkK5BBVKhM=
X-Received: by 2002:a05:6a00:16cb:b0:44b:bd38:e068 with SMTP id
 l11-20020a056a0016cb00b0044bbd38e068mr36609214pfc.34.1633508436852; Wed, 06
 Oct 2021 01:20:36 -0700 (PDT)
MIME-Version: 1.0
From:   Hao Sun <sunhao.th@gmail.com>
Date:   Wed, 6 Oct 2021 16:20:25 +0800
Message-ID: <CACkBjsbo_SESMFN5GxMZSTrw5qge=6W24ROkSsh058LOKK6nPg@mail.gmail.com>
Subject: INFO: rcu detected stall in ext4_file_write_iter
To:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc:     bp@alien8.de, hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, mingo@redhat.com, pbonzini@redhat.com,
        seanjc@google.com, tglx@linutronix.de, vkuznets@redhat.com,
        wanpengli@tencent.com, x86@kernel.org, linux-ext4@vger.kernel.org,
        tytso@mit.edu, adilger.kernel@dilger.ca
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

When using Healer to fuzz the latest Linux kernel, the following crash
was triggered.

HEAD commit: 0513e464f900 Merge tag 'perf-tools-fixes-for-v5.15-2021-09-27'
git tree: upstream
console output:
https://drive.google.com/file/d/1EUGmGiPEMh6IuR3fukiHWFlCBR8flhyB/view?usp=sharing
kernel config: https://drive.google.com/file/d/1Jqhc4DpCVE8X7d-XBdQnrMoQzifTG5ho/view?usp=sharing

Sorry, I don't have a reproducer for this crash, hope the symbolized
report can help.
If you fix this issue, please add the following tag to the commit:
Reported-by: Hao Sun <sunhao.th@gmail.com>

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 0-...0: (2 ticks this GP) idle=437/1/0x4000000000000000
softirq=7937/7937 fqs=2360
rcu: 2-...0: (123 ticks this GP) idle=e27/1/0x4000000000000000
softirq=8738/8738 fqs=2360
(detected by 1, t=10530 jiffies, g=9469, q=85)
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 9701 Comm: syz-executor Not tainted 5.15.0-rc3+ #21
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
RIP: 0010:kvm_wait+0x4a/0x70 arch/x86/kernel/kvm.c:893
Code: 5d c3 89 f3 48 89 fd 9c 58 fa f6 c4 02 75 30 0f b6 45 00 38 c3
74 16 e8 f4 81 25 00 fb 5b 5d c3 eb 07 0f 00 2d 15 c4 6d 03 f4 <5b> 5d
c3 e8 de 81 25 00 eb 07 0f 00 2d 03 c4 6d 03 fb f4 eb c0 e8
RSP: 0018:ffffc90000003e00 EFLAGS: 00000046
RAX: 0000000000000003 RBX: ffff8881019e0338 RCX: 0000000000000008
RDX: 0000000000000000 RSI: 0000000000000003 RDI: ffff8881019e0338
RBP: ffff88807dc2a600 R08: 0000000000000000 R09: 0000000000000001
R10: ffffc90000003d20 R11: 0000000000000005 R12: 0000000000000001
R13: 0000000000000100 R14: 0000000000000000 R15: 0000000000040000
FS:  00007fdb8fc96700(0000) GS:ffff88807dc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe208c8f010 CR3: 000000010b7ef000 CR4: 0000000000750ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 <IRQ>
 pv_wait arch/x86/include/asm/paravirt.h:597 [inline]
 pv_wait_head_or_lock kernel/locking/qspinlock_paravirt.h:470 [inline]
 __pv_queued_spin_lock_slowpath+0x262/0x330 kernel/locking/qspinlock.c:508
 pv_queued_spin_lock_slowpath arch/x86/include/asm/paravirt.h:585 [inline]
 queued_spin_lock_slowpath arch/x86/include/asm/qspinlock.h:51 [inline]
 queued_spin_lock include/asm-generic/qspinlock.h:85 [inline]
 do_raw_spin_lock+0xb6/0xc0 kernel/locking/spinlock_debug.c:115
 spin_lock include/linux/spinlock.h:363 [inline]
 drm_handle_vblank+0x86/0x530 drivers/gpu/drm/drm_vblank.c:1951
 vkms_vblank_simulate+0x5a/0x190 drivers/gpu/drm/vkms/vkms_crtc.c:29
 __run_hrtimer kernel/time/hrtimer.c:1685 [inline]
 __hrtimer_run_queues+0xb8/0x610 kernel/time/hrtimer.c:1749
 hrtimer_interrupt+0xfe/0x280 kernel/time/hrtimer.c:1811
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1086 [inline]
 __sysvec_apic_timer_interrupt+0x9c/0x2c0 arch/x86/kernel/apic/apic.c:1103
 sysvec_apic_timer_interrupt+0x99/0xc0 arch/x86/kernel/apic/apic.c:1097
 </IRQ>
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:638
RIP: 0010:clear_page_erms+0x7/0x10 arch/x86/lib/clear_page_64.S:49
Code: 48 89 47 18 48 89 47 20 48 89 47 28 48 89 47 30 48 89 47 38 48
8d 7f 40 75 d9 90 c3 0f 1f 80 00 00 00 00 b9 00 10 00 00 31 c0 <f3> aa
c3 cc cc cc cc cc cc 41 57 41 56 41 55 41 54 55 53 48 89 fb
RSP: 0018:ffffc9000358f4c8 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000241e80 RCX: 0000000000001000
RDX: ffff88800ed3a280 RSI: 0000000000000001 RDI: ffff88800907a000
RBP: 0000000000241ec0 R08: 0000000000001000 R09: 0000000000000001
R10: ffffc9000358f4a8 R11: 0000000000000003 R12: ffff888000000000
R13: 0000000000012c50 R14: 0000000000000000 R15: ffff88807fffb700
 clear_page arch/x86/include/asm/page_64.h:49 [inline]
 clear_highpage include/linux/highmem.h:181 [inline]
 kernel_init_free_pages.part.95+0x67/0xa0 mm/page_alloc.c:1278
 kernel_init_free_pages mm/page_alloc.c:1267 [inline]
 post_alloc_hook+0x70/0x110 mm/page_alloc.c:2414
 prep_new_page+0x16/0x50 mm/page_alloc.c:2424
 get_page_from_freelist+0x64d/0x29a0 mm/page_alloc.c:4153
 __alloc_pages+0xde/0x2a0 mm/page_alloc.c:5375
 alloc_pages+0x85/0x150 mm/mempolicy.c:2197
 alloc_slab_page mm/slub.c:1763 [inline]
 allocate_slab mm/slub.c:1900 [inline]
 new_slab+0x2ce/0x4f0 mm/slub.c:1963
 ___slab_alloc+0x90e/0xec0 mm/slub.c:2994
 __slab_alloc.isra.91+0x4f/0xb0 mm/slub.c:3081
 slab_alloc_node mm/slub.c:3172 [inline]
 slab_alloc mm/slub.c:3214 [inline]
 kmem_cache_alloc+0x25f/0x280 mm/slub.c:3219
 kmem_cache_zalloc include/linux/slab.h:711 [inline]
 alloc_buffer_head+0x1c/0xa0 fs/buffer.c:3309
 alloc_page_buffers+0x155/0x390 fs/buffer.c:832
 create_empty_buffers+0x24/0x310 fs/buffer.c:1560
 ext4_block_write_begin+0x6ec/0x980 fs/ext4/inode.c:1060
 ext4_da_write_begin+0x275/0x610 fs/ext4/inode.c:3021
 generic_perform_write+0xce/0x220 mm/filemap.c:3770
 ext4_buffered_write_iter+0xd6/0x190 fs/ext4/file.c:269
 ext4_file_write_iter+0x80/0x940 fs/ext4/file.c:680
 call_write_iter include/linux/fs.h:2163 [inline]
 do_iter_readv_writev+0x1e8/0x2b0 fs/read_write.c:729
 do_iter_write+0xaf/0x250 fs/read_write.c:855
 vfs_iter_write+0x38/0x60 fs/read_write.c:896
 iter_file_splice_write+0x2d8/0x450 fs/splice.c:689
 do_splice_from fs/splice.c:767 [inline]
 direct_splice_actor+0x4a/0x80 fs/splice.c:936
 splice_direct_to_actor+0x123/0x2d0 fs/splice.c:891
 do_splice_direct+0xc3/0x110 fs/splice.c:979
 do_sendfile+0x338/0x740 fs/read_write.c:1249
 __do_sys_sendfile64 fs/read_write.c:1314 [inline]
 __se_sys_sendfile64 fs/read_write.c:1300 [inline]
 __x64_sys_sendfile64+0xc7/0xe0 fs/read_write.c:1300
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x34/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x46ae99
Code: f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fdb8fc95c48 EFLAGS: 00000246 ORIG_RAX: 0000000000000028
RAX: ffffffffffffffda RBX: 000000000078c0a0 RCX: 000000000046ae99
RDX: 0000000000000000 RSI: 0000000000000008 RDI: 0000000000000003
RBP: 00000000004e4809 R08: 0000000000000000 R09: 0000000000000000
R10: 00008400fffffffb R11: 0000000000000246 R12: 000000000078c0a0
R13: 0000000000000000 R14: 000000000078c0a0 R15: 00007fffa528c490
Sending NMI from CPU 1 to CPUs 2:
NMI backtrace for cpu 2
CPU: 2 PID: 27 Comm: ksoftirqd/2 Not tainted 5.15.0-rc3+ #21
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
RIP: 0010:__lock_acquire+0x7de/0x1d60 kernel/locking/lockdep.c:5010
Code: f0 09 00 00 0f 8d 0e 03 00 00 49 63 c4 48 89 ee 48 8d 04 80 49
8d 3c c6 e8 1f 37 f9 02 85 c0 74 d8 4c 8b 34 24 44 8b 64 24 44 <44> 8b
05 d3 36 e2 04 45 85 c0 75 51 8b 7c 24 08 85 ff 0f 85 18 05
RSP: 0018:ffffc90000727b28 EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffff888009900a70 RCX: 000000000b087fe1
RDX: 0000000000000008 RSI: 0000000000000000 RDI: ffff888009900000
RBP: 0000000000000057 R08: ffffffff8816e4e0 R09: 0000000000000001
R10: ffffc90000727b28 R11: 0000000000000003 R12: 0000000000000000
R13: ffff888009900000 R14: ffff8880099009f8 R15: 10b087fec69640ce
FS:  0000000000000000(0000) GS:ffff88807dd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000736090 CR3: 000000000588a000 CR4: 0000000000750ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 lock_acquire+0x1f9/0x340 kernel/locking/lockdep.c:5625
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0x38/0x50 kernel/locking/spinlock.c:162
 lock_hrtimer_base+0x2f/0x70 kernel/time/hrtimer.c:173
 hrtimer_try_to_cancel+0x6d/0x270 kernel/time/hrtimer.c:1331
 hrtimer_cancel+0x12/0x30 kernel/time/hrtimer.c:1443
 __disable_vblank drivers/gpu/drm/drm_vblank.c:434 [inline]
 drm_vblank_disable_and_save+0xca/0x130 drivers/gpu/drm/drm_vblank.c:478
 vblank_disable_fn+0x83/0xa0 drivers/gpu/drm/drm_vblank.c:495
 call_timer_fn+0xcb/0x3f0 kernel/time/timer.c:1421
 expire_timers kernel/time/timer.c:1466 [inline]
 __run_timers kernel/time/timer.c:1734 [inline]
 run_timer_softirq+0x6bd/0x820 kernel/time/timer.c:1747
 __do_softirq+0xe9/0x561 kernel/softirq.c:558
 run_ksoftirqd+0x2d/0x60 kernel/softirq.c:920
 smpboot_thread_fn+0x225/0x320 kernel/smpboot.c:164
 kthread+0x178/0x1b0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
----------------
Code disassembly (best guess):
   0: 5d                    pop    %rbp
   1: c3                    retq
   2: 89 f3                mov    %esi,%ebx
   4: 48 89 fd              mov    %rdi,%rbp
   7: 9c                    pushfq
   8: 58                    pop    %rax
   9: fa                    cli
   a: f6 c4 02              test   $0x2,%ah
   d: 75 30                jne    0x3f
   f: 0f b6 45 00          movzbl 0x0(%rbp),%eax
  13: 38 c3                cmp    %al,%bl
  15: 74 16                je     0x2d
  17: e8 f4 81 25 00        callq  0x258210
  1c: fb                    sti
  1d: 5b                    pop    %rbx
  1e: 5d                    pop    %rbp
  1f: c3                    retq
  20: eb 07                jmp    0x29
  22: 0f 00 2d 15 c4 6d 03 verw   0x36dc415(%rip)        # 0x36dc43e
  29: f4                    hlt
* 2a: 5b                    pop    %rbx <-- trapping instruction
  2b: 5d                    pop    %rbp
  2c: c3                    retq
  2d: e8 de 81 25 00        callq  0x258210
  32: eb 07                jmp    0x3b
  34: 0f 00 2d 03 c4 6d 03 verw   0x36dc403(%rip)        # 0x36dc43e
  3b: fb                    sti
  3c: f4                    hlt
  3d: eb c0                jmp    0xffffffff
  3f: e8                    .byte 0xe8
