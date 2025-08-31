Return-Path: <kvm+bounces-56392-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 71047B3D0C6
	for <lists+kvm@lfdr.de>; Sun, 31 Aug 2025 04:21:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BA3051A820E6
	for <lists+kvm@lfdr.de>; Sun, 31 Aug 2025 02:22:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BA611F12E0;
	Sun, 31 Aug 2025 02:21:35 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05BEC19E97A
	for <kvm@vger.kernel.org>; Sun, 31 Aug 2025 02:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756606894; cv=none; b=LnsFbH5uykOKb0ZwUutlVbb5yZHzN0lJ5eXs9an+mbiQujq0LTDoE7Y7Q9MyWQJ1+SRJdxv3gxrL55/r81LN2BohJuSEEj+ZD2w9QjjdHqCaCsZpSubyzf+fBicy6A+jpfTjLxIza+3WoYeQUZ5ORV/hG0eeIAMXtUpUVI1c5Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756606894; c=relaxed/simple;
	bh=Imc/yaT1bwXvOai6Vk+5b+aubdlF0s89Kor4e2hKFN8=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=MK50xDx4vvMhR8vvEh7mOBDbvGSwmsV2geWtN+UMRxSgbHWlNbxDysfKS/YAXkd/R1XCkMgdw/gdNX7/ByxKGwXK46GpuKH5BKPIFZYuGB2agbsDyYRVopuoFLFYjfwB0rQ7KB0LYtYITJKu3kZP8DIrJSWfJVCuTU/rRehVROU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-3f1ebcf0863so37908165ab.2
        for <kvm@vger.kernel.org>; Sat, 30 Aug 2025 19:21:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756606892; x=1757211692;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ptI15CI03nyPbHDiAUmDlsUqdee/Ga3KVCdRZtkWHXI=;
        b=SDaRXv8WMIjQRkPud5CAsT+YH7r1d2dK+VivgN3HAPc448njDXfZxU71jiUhK0zOKi
         g2JxKEB5p3wjKEJVmk1dckuEoGhgcmD3ciTaxBYG3kipAgpoW+VzP2e9gmRcVUu6+riy
         58dNFh5bVVdxCrNxEzBTj+55IqV8lYVUUv9gK+llVI8je/McLv5APvRO4pU25K4gYim1
         9lA59aGyX2/0UHNzJN2ssNbkt7nrksfj4lL2riyI+28X1PSK4ZZXlHZNspRL/7UyKCgU
         VeI69zhJtiiAE68lXD+PAOfUem0+85s+gVjmjyokvFUazeB2BNFEiDnypLGEuOJt774+
         BiVg==
X-Forwarded-Encrypted: i=1; AJvYcCUr+qz8a/RgElIrcBJVt43giAopaAz/oXEZYm1U3soAFS2af4OQsiq4J/c4cGMZrZ2Oa/k=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/STiAF+pWHiMgoyLrsMZRMxEEDk/taSmwyKIjjcCb+Wj/pjRc
	ri26G2Bz/TVO3vZcp94+AUfi78QAJ5aWFZ+ugP4H5eEFU2JA52/Ba1xHkbH4ZAN68pBH5Iyz1st
	bKDwX6QaneIW3rNjvtSP7e34qkqsWXE7oYDcLvYaDTU6LJbcSMpQ6Ijnov3c=
X-Google-Smtp-Source: AGHT+IGemkqHrGBH1w7NAZA8hHIdcUNasSPYTIdUsWaqiHcJYWvw9V4eXxitGPhOs+Hw+GEBPfc+Ggey0zBHKIuIRK2JmiSR68Ol
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1c21:b0:3f3:82da:29f2 with SMTP id
 e9e14a558f8ab-3f4021c249bmr68947395ab.24.1756606892189; Sat, 30 Aug 2025
 19:21:32 -0700 (PDT)
Date: Sat, 30 Aug 2025 19:21:32 -0700
In-Reply-To: <00000000000074ff7b06199efd7b@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68b3b1ac.a70a0220.1c57d1.028b.GAE@google.com>
Subject: Re: [syzbot] [net] [virt] INFO: task hung in __vhost_worker_flush
From: syzbot <syzbot+7f3bbe59e8dd2328a990@syzkaller.appspotmail.com>
To: anna-maria@linutronix.de, brauner@kernel.org, ebiederm@xmission.com, 
	eperezma@redhat.com, frederic@kernel.org, jasowang@redhat.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	michael.christie@oracle.com, mst@redhat.com, netdev@vger.kernel.org, 
	oleg@redhat.com, seanjc@google.com, sgarzare@redhat.com, stefanha@redhat.com, 
	syzkaller-bugs@googlegroups.com, tglx@linutronix.de, 
	virtualization@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    11e7861d680c Merge tag 'for-linus' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17c5c242580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d4703ac89d9e185a
dashboard link: https://syzkaller.appspot.com/bug?extid=7f3bbe59e8dd2328a990
compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1671ba62580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1685aa62580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/aa8c34462d5d/disk-11e7861d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/f90079573556/vmlinux-11e7861d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/8571495e4fea/bzImage-11e7861d.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7f3bbe59e8dd2328a990@syzkaller.appspotmail.com

INFO: task syz.0.17:6038 blocked for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.0.17        state:D stack:27224 pid:6038  tgid:6038  ppid:5979   task_flags:0x400040 flags:0x00004004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5357 [inline]
 __schedule+0x1190/0x5de0 kernel/sched/core.c:6961
 __schedule_loop kernel/sched/core.c:7043 [inline]
 schedule+0xe7/0x3a0 kernel/sched/core.c:7058
 schedule_timeout+0x257/0x290 kernel/time/sleep_timeout.c:75
 do_wait_for_common kernel/sched/completion.c:100 [inline]
 __wait_for_common+0x2fc/0x4e0 kernel/sched/completion.c:121
 __vhost_worker_flush+0x1a8/0x1d0 drivers/vhost/vhost.c:296
 vhost_worker_flush drivers/vhost/vhost.c:303 [inline]
 vhost_dev_flush+0xac/0x110 drivers/vhost/vhost.c:313
 vhost_vsock_flush drivers/vhost/vsock.c:698 [inline]
 vhost_vsock_dev_release+0x19f/0x400 drivers/vhost/vsock.c:750
 __fput+0x402/0xb70 fs/file_table.c:468
 task_work_run+0x14d/0x240 kernel/task_work.c:227
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 exit_to_user_mode_loop+0xeb/0x110 kernel/entry/common.c:43
 exit_to_user_mode_prepare include/linux/irq-entry-common.h:225 [inline]
 syscall_exit_to_user_mode_work include/linux/entry-common.h:175 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:210 [inline]
 do_syscall_64+0x3f6/0x4c0 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f1fdc78ebe9
RSP: 002b:00007ffcf43dcf28 EFLAGS: 00000246 ORIG_RAX: 00000000000001b4
RAX: 0000000000000000 RBX: 00007f1fdc9c7da0 RCX: 00007f1fdc78ebe9
RDX: 0000000000000000 RSI: 000000000000001e RDI: 0000000000000003
RBP: 00007f1fdc9c7da0 R08: 0000000000000000 R09: 00000008f43dd21f
R10: 00007f1fdc9c7cb0 R11: 0000000000000246 R12: 00000000000248b9
R13: 00007ffcf43dd020 R14: ffffffffffffffff R15: 00007ffcf43dd040
 </TASK>

Showing all locks held in the system:
1 lock held by khungtaskd/31:
 #0: ffffffff8e5c1220 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:331 [inline]
 #0: ffffffff8e5c1220 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:841 [inline]
 #0: ffffffff8e5c1220 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x36/0x1c0 kernel/locking/lockdep.c:6775
3 locks held by kworker/u9:1/5174:
 #0: ffff8880605ef148 ((wq_completion)hci2){+.+.}-{0:0}, at: process_one_work+0x12a2/0x1b70 kernel/workqueue.c:3211
 #1: ffffc9000f89fd10 ((work_completion)(&hdev->cmd_sync_work)){+.+.}-{0:0}, at: process_one_work+0x929/0x1b70 kernel/workqueue.c:3212
 #2: ffff8880256d4dc0 (&hdev->req_lock){+.+.}-{4:4}, at: hci_cmd_sync_work+0x175/0x430 net/bluetooth/hci_sync.c:331
2 locks held by getty/5615:
 #0: ffff88814d35e0a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x24/0x80 drivers/tty/tty_ldisc.c:243
 #1: ffffc9000332b2f0 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x41b/0x14f0 drivers/tty/n_tty.c:2222

=============================================

NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 31 Comm: khungtaskd Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:120
 nmi_cpu_backtrace+0x27b/0x390 lib/nmi_backtrace.c:113
 nmi_trigger_cpumask_backtrace+0x29c/0x300 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:160 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:328 [inline]
 watchdog+0xf0e/0x1260 kernel/hung_task.c:491
 kthread+0x3c5/0x780 kernel/kthread.c:463
 ret_from_fork+0x5d4/0x6f0 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 0 Comm: swapper/1 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
RIP: 0010:pv_native_safe_halt+0xf/0x20 arch/x86/kernel/paravirt.c:82
Code: 0c 62 02 c3 cc cc cc cc 0f 1f 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 66 90 0f 00 2d d3 12 16 00 fb f4 <e9> 4c 09 03 00 66 2e 0f 1f 84 00 00 00 00 00 66 90 90 90 90 90 90
RSP: 0018:ffffc90000197df8 EFLAGS: 000002c2
RAX: 000000000015fae9 RBX: 0000000000000001 RCX: ffffffff8b93fc29
RDX: 0000000000000000 RSI: ffffffff8de50a38 RDI: ffffffff8c162980
RBP: ffffed1003c5d488 R08: 0000000000000001 R09: ffffed10170a6655
R10: ffff8880b85332ab R11: 0000000000000000 R12: 0000000000000001
R13: ffff88801e2ea440 R14: ffffffff90ab5290 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8881247b8000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000555d26767660 CR3: 000000000e380000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 arch_safe_halt arch/x86/include/asm/paravirt.h:107 [inline]
 default_idle+0x13/0x20 arch/x86/kernel/process.c:757
 default_idle_call+0x6d/0xb0 kernel/sched/idle.c:122
 cpuidle_idle_call kernel/sched/idle.c:190 [inline]
 do_idle+0x391/0x510 kernel/sched/idle.c:330
 cpu_startup_entry+0x4f/0x60 kernel/sched/idle.c:428
 start_secondary+0x21d/0x2b0 arch/x86/kernel/smpboot.c:315
 common_startup_64+0x13e/0x148
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

