Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8520C35E53C
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 19:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344378AbhDMRmM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 13:42:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:42988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232398AbhDMRmL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Apr 2021 13:42:11 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A423F6102A;
        Tue, 13 Apr 2021 17:41:49 +0000 (UTC)
Date:   Tue, 13 Apr 2021 13:41:47 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     syzbot <syzbot+61e04e51b7ac86930589@syzkaller.appspotmail.com>
Cc:     akpm@linux-foundation.org, axboe@kernel.dk, bp@alien8.de,
        hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, mark.rutland@arm.com,
        masahiroy@kernel.org, mingo@redhat.com, pbonzini@redhat.com,
        peterz@infradead.org, rafael.j.wysocki@intel.com,
        seanjc@google.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, vkuznets@redhat.com, wanpengli@tencent.com,
        will@kernel.org, x86@kernel.org
Subject: Re: [syzbot] possible deadlock in del_gendisk
Message-ID: <20210413134147.54556d9d@gandalf.local.home>
In-Reply-To: <000000000000ae236f05bfde0678@google.com>
References: <000000000000ae236f05bfde0678@google.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 13 Apr 2021 10:33:19 -0700
syzbot <syzbot+61e04e51b7ac86930589@syzkaller.appspotmail.com> wrote:

> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    e99d8a84 Add linux-next specific files for 20210409
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=13b01681d00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=7cd69574979bfeb7
> dashboard link: https://syzkaller.appspot.com/bug?extid=61e04e51b7ac86930589
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=148265d9d00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16a981a1d00000
> 
> The issue was bisected to:
> 
> commit 997acaf6b4b59c6a9c259740312a69ea549cc684
> Author: Mark Rutland <mark.rutland@arm.com>
> Date:   Mon Jan 11 15:37:07 2021 +0000
> 
>     lockdep: report broken irq restoration

As the below splats look like it has nothing to do with this patch, and
this patch will add a WARN() if there's broken logic somewhere, I bet the
bisect got confused (if it is automated and does a panic_on_warning),
because it will panic for broken code that his patch detects.

That is, the bisect was confused because it was triggering on two different
issues. One that triggered the reported splat below, and another that this
commit detects and warns on.

Hence, the bisect failed.

-- Steve


> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16a7e77ed00000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=15a7e77ed00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=11a7e77ed00000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+61e04e51b7ac86930589@syzkaller.appspotmail.com
> Fixes: 997acaf6b4b5 ("lockdep: report broken irq restoration")
> 
> ======================================================
> WARNING: possible circular locking dependency detected
> 5.12.0-rc6-next-20210409-syzkaller #0 Not tainted
> ------------------------------------------------------
> syz-executor104/8440 is trying to acquire lock:
> ffff888016e9dca0 (&bdev->bd_mutex){+.+.}-{3:3}, at: del_gendisk+0x250/0x9e0 block/genhd.c:618
> 
> but task is already holding lock:
> ffffffff8c7d9430 (bdev_lookup_sem){++++}-{3:3}, at: del_gendisk+0x222/0x9e0 block/genhd.c:616
> 
> which lock already depends on the new lock.
> 
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #2 (bdev_lookup_sem){++++}-{3:3}:  
>        down_write+0x92/0x150 kernel/locking/rwsem.c:1406
>        del_gendisk+0x222/0x9e0 block/genhd.c:616
>        loop_remove drivers/block/loop.c:2191 [inline]
>        loop_control_ioctl drivers/block/loop.c:2291 [inline]
>        loop_control_ioctl+0x40d/0x4f0 drivers/block/loop.c:2251
>        vfs_ioctl fs/ioctl.c:48 [inline]
>        __do_sys_ioctl fs/ioctl.c:753 [inline]
>        __se_sys_ioctl fs/ioctl.c:739 [inline]
>        __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:739
>        do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>        entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> -> #1 (loop_ctl_mutex){+.+.}-{3:3}:  
>        __mutex_lock_common kernel/locking/mutex.c:949 [inline]
>        __mutex_lock+0x139/0x1120 kernel/locking/mutex.c:1096
>        lo_open+0x1a/0x130 drivers/block/loop.c:1890
>        __blkdev_get+0x135/0xa30 fs/block_dev.c:1305
>        blkdev_get_by_dev fs/block_dev.c:1457 [inline]
>        blkdev_get_by_dev+0x26c/0x600 fs/block_dev.c:1425
>        blkdev_open+0x154/0x2b0 fs/block_dev.c:1554
>        do_dentry_open+0x4b9/0x11b0 fs/open.c:826
>        do_open fs/namei.c:3361 [inline]
>        path_openat+0x1c09/0x27d0 fs/namei.c:3494
>        do_filp_open+0x190/0x3d0 fs/namei.c:3521
>        do_sys_openat2+0x16d/0x420 fs/open.c:1187
>        do_sys_open fs/open.c:1203 [inline]
>        __do_sys_open fs/open.c:1211 [inline]
>        __se_sys_open fs/open.c:1207 [inline]
>        __x64_sys_open+0x119/0x1c0 fs/open.c:1207
>        do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>        entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> -> #0 (&bdev->bd_mutex){+.+.}-{3:3}:  
>        check_prev_add kernel/locking/lockdep.c:2938 [inline]
>        check_prevs_add kernel/locking/lockdep.c:3061 [inline]
>        validate_chain kernel/locking/lockdep.c:3676 [inline]
>        __lock_acquire+0x2a17/0x5230 kernel/locking/lockdep.c:4902
>        lock_acquire kernel/locking/lockdep.c:5512 [inline]
>        lock_acquire+0x1ab/0x740 kernel/locking/lockdep.c:5477
>        __mutex_lock_common kernel/locking/mutex.c:949 [inline]
>        __mutex_lock+0x139/0x1120 kernel/locking/mutex.c:1096
>        del_gendisk+0x250/0x9e0 block/genhd.c:618
>        loop_remove drivers/block/loop.c:2191 [inline]
>        loop_control_ioctl drivers/block/loop.c:2291 [inline]
>        loop_control_ioctl+0x40d/0x4f0 drivers/block/loop.c:2251
>        vfs_ioctl fs/ioctl.c:48 [inline]
>        __do_sys_ioctl fs/ioctl.c:753 [inline]
>        __se_sys_ioctl fs/ioctl.c:739 [inline]
>        __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:739
>        do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>        entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> other info that might help us debug this:
> 
> Chain exists of:
>   &bdev->bd_mutex --> loop_ctl_mutex --> bdev_lookup_sem
> 
>  Possible unsafe locking scenario:
> 
>        CPU0                    CPU1
>        ----                    ----
>   lock(bdev_lookup_sem);
>                                lock(loop_ctl_mutex);
>                                lock(bdev_lookup_sem);
>   lock(&bdev->bd_mutex);
> 
>  *** DEADLOCK ***
> 
> 2 locks held by syz-executor104/8440:
>  #0: ffffffff8ca5f148 (loop_ctl_mutex){+.+.}-{3:3}, at: loop_control_ioctl+0x7b/0x4f0 drivers/block/loop.c:2257
>  #1: ffffffff8c7d9430 (bdev_lookup_sem){++++}-{3:3}, at: del_gendisk+0x222/0x9e0 block/genhd.c:616
> 
> stack backtrace:
> CPU: 1 PID: 8440 Comm: syz-executor104 Not tainted 5.12.0-rc6-next-20210409-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:79 [inline]
>  dump_stack+0x141/0x1d7 lib/dump_stack.c:120
>  check_noncircular+0x25f/0x2e0 kernel/locking/lockdep.c:2129
>  check_prev_add kernel/locking/lockdep.c:2938 [inline]
>  check_prevs_add kernel/locking/lockdep.c:3061 [inline]
>  validate_chain kernel/locking/lockdep.c:3676 [inline]
>  __lock_acquire+0x2a17/0x5230 kernel/locking/lockdep.c:4902
>  lock_acquire kernel/locking/lockdep.c:5512 [inline]
>  lock_acquire+0x1ab/0x740 kernel/locking/lockdep.c:5477
>  __mutex_lock_common kernel/locking/mutex.c:949 [inline]
>  __mutex_lock+0x139/0x1120 kernel/locking/mutex.c:1096
>  del_gendisk+0x250/0x9e0 block/genhd.c:618
>  loop_remove drivers/block/loop.c:2191 [inline]
>  loop_control_ioctl drivers/block/loop.c:2291 [inline]
>  loop_control_ioctl+0x40d/0x4f0 drivers/block/loop.c:2251
>  vfs_ioctl fs/ioctl.c:48 [inline]
>  __do_sys_ioctl fs/ioctl.c:753 [inline]
>  __se_sys_ioctl fs/ioctl.c:739 [inline]
>  __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:739
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x43ee49
> Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fff4d86c238 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 000000000043ee49
> RDX: 0000000000000002 RSI: 0000000000004c81 RDI: 0000000000000003
> RBP: 0000000000402e30 R08: 0000000000000000 R09: 0000000000400488
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000402ec0
> R13: 0000000000000000 R14: 00000000004ac018 R15: 0000000000400488
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches

