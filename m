Return-Path: <kvm+bounces-32395-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CCAA9D6C3E
	for <lists+kvm@lfdr.de>; Sun, 24 Nov 2024 00:36:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 330FF2817D2
	for <lists+kvm@lfdr.de>; Sat, 23 Nov 2024 23:36:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1335C1A01B9;
	Sat, 23 Nov 2024 23:36:22 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail78-36.sinamail.sina.com.cn (mail78-36.sinamail.sina.com.cn [219.142.78.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A297BA59
	for <kvm@vger.kernel.org>; Sat, 23 Nov 2024 23:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=219.142.78.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732404981; cv=none; b=QEgmkMlN+GlliX1O2U8kDPcRDOx+nF7N94QjpdPnN7+u3XNEqJsIIxrW7yFUIF8Lw2EC1S+ziBKZLc+i74DRFM1yjAvk5J7Jwtpi+vnhy3adnZlTvhmu80Grkq+cCw7+6fnMVy1kknHl0mghp9kfz422gevlRy9Z2YVCnZKi64o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732404981; c=relaxed/simple;
	bh=msBn8Fma/11yKn/GT2bR9nCdhGUiLq3CNcdDsndUZkU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Fb9rikmyzHerp8NEQ53RJtRf48t8Wogk9Rzl8VELTBP9gIac19KnTvAq9rbI1kd5zQutgzjj3gJvmuQp7DMcak91Ew2zPfeRNQyGRflALMny7kW1M1kz5gFt6Bf6opitoeB8Dvyvhuz+su4jo8sqPRXVIBn+ziOXlsvXknH6E4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sina.com; spf=pass smtp.mailfrom=sina.com; arc=none smtp.client-ip=219.142.78.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sina.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sina.com
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([116.24.9.183])
	by sina.com (10.185.250.24) with ESMTP
	id 6742661900007C83; Sat, 24 Nov 2024 07:32:45 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
Authentication-Results: sina.com;
	 spf=none smtp.mailfrom=hdanton@sina.com;
	 dkim=none header.i=none;
	 dmarc=none action=none header.from=hdanton@sina.com
X-SMAIL-MID: 88043310748239
X-SMAIL-UIID: CB53804FFDBC4BEEADD2E7583C19D992-20241124-073245-1
From: Hillf Danton <hdanton@sina.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Boqun Feng <boqun.feng@gmail.com>
Cc: syzbot <syzbot+919877893c9d28162dc2@syzkaller.appspotmail.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	pbonzini@redhat.com,
	seanjc@google.com,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [kvm?] WARNING: locking bug in kvm_xen_set_evtchn_fast
Date: Sun, 24 Nov 2024 07:32:32 +0800
Message-Id: <20241123233232.1437-1-hdanton@sina.com>
In-Reply-To: <6741d5df.050a0220.1cc393.0011.GAE@google.com>
References: 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Loop in lock people.

On Sat, 23 Nov 2024 05:17:19 -0800
> syzbot has found a reproducer for the following issue on:
> 
> HEAD commit:    06afb0f36106 Merge tag 'trace-v6.13' of git://git.kernel.o..
> git tree:       upstream
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=17ff7930580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=95b76860fd16c857
> dashboard link: https://syzkaller.appspot.com/bug?extid=919877893c9d28162dc2
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=142981c0580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1371975f980000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/49111529582a/disk-06afb0f3.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/f04577ad9add/vmlinux-06afb0f3.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/b352b4fae995/bzImage-06afb0f3.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+919877893c9d28162dc2@syzkaller.appspotmail.com
> 
> =============================
> [ BUG: Invalid wait context ]
> 6.12.0-syzkaller-07834-g06afb0f36106 #0 Not tainted
> -----------------------------
> kworker/0:1/9 is trying to lock:
> ffffc90003bca460 (&gpc->lock){....}-{3:3}, at: kvm_xen_set_evtchn_fast+0x1ee/0xa00 arch/x86/kvm/xen.c:1755
> other info that might help us debug this:
> context-{2:2}
> 6 locks held by kworker/0:1/9:
>  #0: ffff888144a92148 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3204 [inline]
>  #0: ffff888144a92148 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: process_scheduled_works+0x93b/0x1850 kernel/workqueue.c:3310
>  #1: ffffc900000e7d00 ((work_completion)(&hub->events)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3205 [inline]
>  #1: ffffc900000e7d00 ((work_completion)(&hub->events)){+.+.}-{0:0}, at: process_scheduled_works+0x976/0x1850 kernel/workqueue.c:3310
>  #2: ffff888145711190 (&dev->mutex){....}-{4:4}, at: device_lock include/linux/device.h:1014 [inline]
>  #2: ffff888145711190 (&dev->mutex){....}-{4:4}, at: hub_event+0x1fe/0x5150 drivers/usb/core/hub.c:5849
>  #3: ffffffff8e817de0 (console_lock){+.+.}-{0:0}, at: dev_vprintk_emit+0x2ae/0x330 drivers/base/core.c:4942
>  #4: ffffffff8e8179f0 (console_srcu){....}-{0:0}, at: rcu_try_lock_acquire include/linux/rcupdate.h:342 [inline]
>  #4: ffffffff8e8179f0 (console_srcu){....}-{0:0}, at: srcu_read_lock_nmisafe include/linux/srcu.h:297 [inline]
>  #4: ffffffff8e8179f0 (console_srcu){....}-{0:0}, at: console_srcu_read_lock kernel/printk/printk.c:288 [inline]
>  #4: ffffffff8e8179f0 (console_srcu){....}-{0:0}, at: console_flush_all+0x1a3/0xeb0 kernel/printk/printk.c:3187
>  #5: ffffc90003bca8c8 (&kvm->srcu){.?.+}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:158 [inline]
>  #5: ffffc90003bca8c8 (&kvm->srcu){.?.+}-{0:0}, at: srcu_read_lock include/linux/srcu.h:249 [inline]
>  #5: ffffc90003bca8c8 (&kvm->srcu){.?.+}-{0:0}, at: kvm_xen_set_evtchn_fast+0x1bb/0xa00 arch/x86/kvm/xen.c:1753
> stack backtrace:
> CPU: 0 UID: 0 PID: 9 Comm: kworker/0:1 Not tainted 6.12.0-syzkaller-07834-g06afb0f36106 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
> Workqueue: usb_hub_wq hub_event
> Call Trace:
>  <IRQ>
>  __dump_stack lib/dump_stack.c:94 [inline]
>  dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
>  print_lock_invalid_wait_context kernel/locking/lockdep.c:4826 [inline]
>  check_wait_context kernel/locking/lockdep.c:4898 [inline]
>  __lock_acquire+0x15a8/0x2100 kernel/locking/lockdep.c:5176
>  lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
>  __raw_read_lock_irqsave include/linux/rwlock_api_smp.h:160 [inline]
>  _raw_read_lock_irqsave+0xdd/0x130 kernel/locking/spinlock.c:236
>  kvm_xen_set_evtchn_fast+0x1ee/0xa00 arch/x86/kvm/xen.c:1755
>  xen_timer_callback+0x1a0/0x380 arch/x86/kvm/xen.c:140
>  __run_hrtimer kernel/time/hrtimer.c:1739 [inline]
>  __hrtimer_run_queues+0x551/0xd50 kernel/time/hrtimer.c:1803
>  hrtimer_interrupt+0x403/0xa40 kernel/time/hrtimer.c:1865
>  local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1038 [inline]
>  __sysvec_apic_timer_interrupt+0x110/0x420 arch/x86/kernel/apic/apic.c:1055
>  instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1049 [inline]
>  sysvec_apic_timer_interrupt+0xa1/0xc0 arch/x86/kernel/apic/apic.c:1049
>  </IRQ>

Another locking issue in irq context [1]

[1] https://lore.kernel.org/lkml/20241116232957.1223-1-hdanton@sina.com/

>  <TASK>
>  asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:702
> RIP: 0010:console_flush_all+0x996/0xeb0
> Code: 48 21 c3 0f 85 16 02 00 00 e8 66 aa 20 00 4c 8b 7c 24 10 4d 85 f6 75 07 e8 57 aa 20 00 eb 06 e8 50 aa 20 00 fb 48 8b 5c 24 18 <48> 8b 44 24 30 42 80 3c 28 00 74 08 48 89 df e8 76 61 8b 00 4c 8b
> RSP: 0018:ffffc900000e7000 EFLAGS: 00000293
> RAX: ffffffff8174a2e0 RBX: ffffffff8f17fa58 RCX: ffff88801bef8000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: ffffc900000e71b0 R08: ffffffff8174a2b7 R09: 1ffffffff285cb10
> R10: dffffc0000000000 R11: fffffbfff285cb11 R12: ffffffff8f17fa00
> R13: dffffc0000000000 R14: 0000000000000200 R15: ffffc900000e7200
>  __console_flush_and_unlock kernel/printk/printk.c:3269 [inline]
>  console_unlock+0x14f/0x3b0 kernel/printk/printk.c:3309
>  vprintk_emit+0x730/0xa10 kernel/printk/printk.c:2432
>  dev_vprintk_emit+0x2ae/0x330 drivers/base/core.c:4942
>  dev_printk_emit+0xdd/0x120 drivers/base/core.c:4953
>  _dev_info+0x122/0x170 drivers/base/core.c:5011
>  show_string drivers/usb/core/hub.c:2357 [inline]
>  announce_device drivers/usb/core/hub.c:2375 [inline]
>  usb_new_device+0xd02/0x19a0 drivers/usb/core/hub.c:2632
>  hub_port_connect drivers/usb/core/hub.c:5521 [inline]
>  hub_port_connect_change drivers/usb/core/hub.c:5661 [inline]
>  port_event drivers/usb/core/hub.c:5821 [inline]
>  hub_event+0x2d6d/0x5150 drivers/usb/core/hub.c:5903
>  process_one_work kernel/workqueue.c:3229 [inline]
>  process_scheduled_works+0xa63/0x1850 kernel/workqueue.c:3310
>  worker_thread+0x870/0xd30 kernel/workqueue.c:3391
>  kthread+0x2f0/0x390 kernel/kthread.c:389
>  ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
>  </TASK>

