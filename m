Return-Path: <kvm+bounces-32270-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 517CC9D4F5B
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 16:03:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CAE581F23946
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 15:03:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B86D01DBB0C;
	Thu, 21 Nov 2024 15:03:27 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A8041D63DC
	for <kvm@vger.kernel.org>; Thu, 21 Nov 2024 15:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732201407; cv=none; b=ahCJVtX3PUr8iPZydcl2yplifoNFJs/oPRdTBE3OHe1FS88Pdp0q/DYxgdLhW+QmeDyv7QjQAGWxArHtseEn0QYaOCOXpLwg2PYXKLXeAp73W1vylSopBQbYot7Gfy7mIgtADkMPihFHkmj5OOiGb0tI7vUMLArZM9fO1zuHL7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732201407; c=relaxed/simple;
	bh=n8JMPzBy5biQgHgSNPwGSUix++KBUT5PDaBB7sFLVAk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=D/6Crf7YGnBJYylR+DrhCPAbfkrm7OOBL6Evmfc22N6bYy++AB3fLZwPynFxe71vealJb8S/oBiGkGpCJVowsUwPNCOPYTuXTPgQvFrEIidqdo4JjS13fIZMUiIAv++hdBAahVBlL9nIA2ao8kaAyDnrTfPk6p6l53cdn0HXGNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-83dff8bc954so100465639f.1
        for <kvm@vger.kernel.org>; Thu, 21 Nov 2024 07:03:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732201404; x=1732806204;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GEHQBx3R5MVs+IGTTjeVS5dq/RGKc660S5q/ISPuTqE=;
        b=gO6YPyeGEbxMvsmTJJcjWBZxVaHvWbhuqE0UmexG7FUkLxPHOY6Y0J2RGXend//8qk
         mZMRPH1Ctw6xjNoaV318iosDtm12yjYIwCMXUXwUf1veUN2hR7YjxShnREQHbX4GrUOj
         L0oiqkdnT4i9kSWOsmuXU6jfb3wNGoORb3CgtxjOzpFFnTO/oTtZCfOBH5VLSQtIavOS
         RIOQTNjTU1NavgVF16XsojsjEt4xmd+XX85WUfNsKB76t5BJRlYL1am7ls3FhEvH5ZY7
         fP7grwrgaKtt78CmqOKskGyyJFGiB0MRdTRXHEvHttWnHooD0uXLRhHUCfLDr2PlpkES
         PZ+w==
X-Forwarded-Encrypted: i=1; AJvYcCXdSF8197aYV1gfbIAvjwTjAB85Hb9DmdNXUzH9rTWHyWn7Ct8rDgFx1AYe0Oz/wudLgqQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxhHmnbdfyxpH3zQFu1MgniRzq8Gy4ewxbLOZWdUhamYf2Hyfxs
	NRVs2dT0feJHkBSJbWlSiaAVyCInoa0YqjevgzFZ0ASw5leUtpEK4T35iu0HmkCUQC8Akp6mcGa
	c6Ydyqw8KWhN/RaLD6UXArshsgoo9WCLpU9POjXC+7csO06KPcu4TaVs=
X-Google-Smtp-Source: AGHT+IFjdrLE5PgdR17FT+Rs7y3X5+wDvgL+ROtk4b883hLiSo6EDDtDYBUiKi3N+jUck/PdC8rfzemHac8TJ8l2T21prD0J/++1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1d0f:b0:3a7:9082:9be8 with SMTP id
 e9e14a558f8ab-3a790829e21mr44879085ab.1.1732201404354; Thu, 21 Nov 2024
 07:03:24 -0800 (PST)
Date: Thu, 21 Nov 2024 07:03:24 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <673f4bbc.050a0220.3c9d61.0174.GAE@google.com>
Subject: [syzbot] [kvm?] WARNING: locking bug in kvm_xen_set_evtchn_fast
From: syzbot <syzbot+919877893c9d28162dc2@syzkaller.appspotmail.com>
To: bp@alien8.de, dave.hansen@linux.intel.com, dwmw2@infradead.org, 
	hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	mingo@redhat.com, paul@xen.org, pbonzini@redhat.com, seanjc@google.com, 
	syzkaller-bugs@googlegroups.com, tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    8f7c8b88bda4 Merge tag 'sched_ext-for-6.13' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=103d275f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8b2ddebc25a60ddb
dashboard link: https://syzkaller.appspot.com/bug?extid=919877893c9d28162dc2
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-8f7c8b88.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/a91bdc4cdb5d/vmlinux-8f7c8b88.xz
kernel image: https://storage.googleapis.com/syzbot-assets/35264fa8c070/bzImage-8f7c8b88.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+919877893c9d28162dc2@syzkaller.appspotmail.com

=============================
[ BUG: Invalid wait context ]
6.12.0-syzkaller-01892-g8f7c8b88bda4 #0 Not tainted
-----------------------------
kworker/u32:4/73 is trying to lock:
ffffc90003a90460 (&gpc->lock){....}-{3:3}, at: kvm_xen_set_evtchn_fast+0x248/0xe00 arch/x86/kvm/xen.c:1755
other info that might help us debug this:
context-{2:2}
7 locks held by kworker/u32:4/73:
 #0: ffff88810628e948 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: process_one_work+0x129b/0x1ba0 kernel/workqueue.c:3204
 #1: ffffc90000fbfd80 ((work_completion)(&(&ifa->dad_work)->work)){+.+.}-{0:0}, at: process_one_work+0x921/0x1ba0 kernel/workqueue.c:3205
 #2: ffffffff8feec868 (rtnl_mutex){+.+.}-{4:4}, at: addrconf_dad_work+0xcf/0x14d0 net/ipv6/addrconf.c:4196
 #3: ffffffff8e1bb1c0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:337 [inline]
 #3: ffffffff8e1bb1c0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #3: ffffffff8e1bb1c0 (rcu_read_lock){....}-{1:3}, at: ndisc_send_skb+0x864/0x1c30 net/ipv6/ndisc.c:507
 #4: ffffffff8e1bb1c0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:337 [inline]
 #4: ffffffff8e1bb1c0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #4: ffffffff8e1bb1c0 (rcu_read_lock){....}-{1:3}, at: ip6_finish_output2+0x3da/0x1a50 net/ipv6/ip6_output.c:126
 #5: ffffffff8e1bb1c0 (rcu_read_lock){....}-{1:3}, at: local_lock_release include/linux/local_lock_internal.h:38 [inline]
 #5: ffffffff8e1bb1c0 (rcu_read_lock){....}-{1:3}, at: process_backlog+0x3f1/0x15f0 net/core/dev.c:6113
 #6: ffffc90003a908c8 (&kvm->srcu){.?.?}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:158 [inline]
 #6: ffffc90003a908c8 (&kvm->srcu){.?.?}-{0:0}, at: srcu_read_lock include/linux/srcu.h:249 [inline]
 #6: ffffc90003a908c8 (&kvm->srcu){.?.?}-{0:0}, at: kvm_xen_set_evtchn_fast+0x22e/0xe00 arch/x86/kvm/xen.c:1753
stack backtrace:
CPU: 1 UID: 0 PID: 73 Comm: kworker/u32:4 Not tainted 6.12.0-syzkaller-01892-g8f7c8b88bda4 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Workqueue: ipv6_addrconf addrconf_dad_work
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:120
 print_lock_invalid_wait_context kernel/locking/lockdep.c:4826 [inline]
 check_wait_context kernel/locking/lockdep.c:4898 [inline]
 __lock_acquire+0x878/0x3c40 kernel/locking/lockdep.c:5176
 lock_acquire.part.0+0x11b/0x380 kernel/locking/lockdep.c:5849
 __raw_read_lock_irqsave include/linux/rwlock_api_smp.h:160 [inline]
 _raw_read_lock_irqsave+0x46/0x90 kernel/locking/spinlock.c:236
 kvm_xen_set_evtchn_fast+0x248/0xe00 arch/x86/kvm/xen.c:1755
 xen_timer_callback+0x1dd/0x2a0 arch/x86/kvm/xen.c:140
 __run_hrtimer kernel/time/hrtimer.c:1739 [inline]
 __hrtimer_run_queues+0x5fb/0xae0 kernel/time/hrtimer.c:1803
 hrtimer_interrupt+0x392/0x8e0 kernel/time/hrtimer.c:1865
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1038 [inline]
 __sysvec_apic_timer_interrupt+0x10f/0x400 arch/x86/kernel/apic/apic.c:1055
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1049 [inline]
 sysvec_apic_timer_interrupt+0x52/0xc0 arch/x86/kernel/apic/apic.c:1049
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:702
RIP: 0010:__raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:152 [inline]
RIP: 0010:_raw_spin_unlock_irqrestore+0x31/0x80 kernel/locking/spinlock.c:194
Code: f5 53 48 8b 74 24 10 48 89 fb 48 83 c7 18 e8 26 dc 41 f6 48 89 df e8 9e 5b 42 f6 f7 c5 00 02 00 00 75 23 9c 58 f6 c4 02 75 37 <bf> 01 00 00 00 e8 35 52 33 f6 65 8b 05 36 f8 da 74 85 c0 74 16 5b
RSP: 0018:ffffc900008b0758 EFLAGS: 00000246
RAX: 0000000000000012 RBX: ffffffff9a9e1520 RCX: 1ffffffff2dc9676
RDX: 0000000000000000 RSI: ffffffff8b6cd740 RDI: ffffffff8bd1db00
RBP: 0000000000000286 R08: 0000000000000001 R09: fffffbfff2dc8999
R10: ffffffff96e44ccf R11: 0000000000000006 R12: ffffffff9a9e1518
R13: 0000000000000000 R14: 0000000000000000 R15: ffff88801eec3040
 __debug_check_no_obj_freed lib/debugobjects.c:1108 [inline]
 debug_check_no_obj_freed+0x327/0x600 lib/debugobjects.c:1129
 slab_free_hook mm/slub.c:2273 [inline]
 slab_free mm/slub.c:4579 [inline]
 kmem_cache_free+0x29c/0x4b0 mm/slub.c:4681
 kfree_skbmem+0x1a4/0x1f0 net/core/skbuff.c:1148
 __kfree_skb net/core/skbuff.c:1205 [inline]
 sk_skb_reason_drop+0x136/0x1a0 net/core/skbuff.c:1242
 kfree_skb_reason include/linux/skbuff.h:1262 [inline]
 __netif_receive_skb_core.constprop.0+0x592/0x4330 net/core/dev.c:5644
 __netif_receive_skb_one_core+0xb1/0x1e0 net/core/dev.c:5668
 __netif_receive_skb+0x1d/0x160 net/core/dev.c:5783
 process_backlog+0x443/0x15f0 net/core/dev.c:6115
 __napi_poll.constprop.0+0xb7/0x550 net/core/dev.c:6779
 napi_poll net/core/dev.c:6848 [inline]
 net_rx_action+0xa92/0x1010 net/core/dev.c:6970
 handle_softirqs+0x213/0x8f0 kernel/softirq.c:554
 do_softirq kernel/softirq.c:455 [inline]
 do_softirq+0xb2/0xf0 kernel/softirq.c:442
 </IRQ>
 <TASK>
 __local_bh_enable_ip+0x100/0x120 kernel/softirq.c:382
 local_bh_enable include/linux/bottom_half.h:33 [inline]
 rcu_read_unlock_bh include/linux/rcupdate.h:919 [inline]
 __dev_queue_xmit+0x887/0x4350 net/core/dev.c:4459
 dev_queue_xmit include/linux/netdevice.h:3094 [inline]
 neigh_connected_output+0x45c/0x630 net/core/neighbour.c:1594
 neigh_output include/net/neighbour.h:542 [inline]
 ip6_finish_output2+0x6a7/0x1a50 net/ipv6/ip6_output.c:141
 __ip6_finish_output net/ipv6/ip6_output.c:215 [inline]
 ip6_finish_output+0x3f9/0x1300 net/ipv6/ip6_output.c:226
 NF_HOOK_COND include/linux/netfilter.h:303 [inline]
 ip6_output+0x1f8/0x540 net/ipv6/ip6_output.c:247
 dst_output include/net/dst.h:450 [inline]
 NF_HOOK include/linux/netfilter.h:314 [inline]
 ndisc_send_skb+0xa2d/0x1c30 net/ipv6/ndisc.c:511
 ndisc_send_ns+0xc7/0x150 net/ipv6/ndisc.c:669
 addrconf_dad_work+0xc80/0x14d0 net/ipv6/addrconf.c:4284
 process_one_work+0x9c5/0x1ba0 kernel/workqueue.c:3229
 process_scheduled_works kernel/workqueue.c:3310 [inline]
 worker_thread+0x6c8/0xf00 kernel/workqueue.c:3391
 kthread+0x2c1/0x3a0 kernel/kthread.c:389
 ret_from_fork+0x45/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
----------------
Code disassembly (best guess):
   0:	f5                   	cmc
   1:	53                   	push   %rbx
   2:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
   7:	48 89 fb             	mov    %rdi,%rbx
   a:	48 83 c7 18          	add    $0x18,%rdi
   e:	e8 26 dc 41 f6       	call   0xf641dc39
  13:	48 89 df             	mov    %rbx,%rdi
  16:	e8 9e 5b 42 f6       	call   0xf6425bb9
  1b:	f7 c5 00 02 00 00    	test   $0x200,%ebp
  21:	75 23                	jne    0x46
  23:	9c                   	pushf
  24:	58                   	pop    %rax
  25:	f6 c4 02             	test   $0x2,%ah
  28:	75 37                	jne    0x61
* 2a:	bf 01 00 00 00       	mov    $0x1,%edi <-- trapping instruction
  2f:	e8 35 52 33 f6       	call   0xf6335269
  34:	65 8b 05 36 f8 da 74 	mov    %gs:0x74daf836(%rip),%eax        # 0x74daf871
  3b:	85 c0                	test   %eax,%eax
  3d:	74 16                	je     0x55
  3f:	5b                   	pop    %rbx


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

