Return-Path: <kvm+bounces-19836-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B66390C1C4
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 04:22:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B3F4A1C21782
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 02:22:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F19C1CAB3;
	Tue, 18 Jun 2024 02:22:24 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F494689
	for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 02:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718677343; cv=none; b=PVMQQwcD4SgCTY2aUrsfSmKQ4W4Eb+Rnh2GihnSHJqccZr7mmPrbRhNBBfWpiUclf+Yj5dA47S00Scc10qLiNovAk3qZx/jZdgotjk1cGPogpNioWH2iKtm7m/jEthMHpEt4Ic9H+1FiVGBBswXvzydnbYa+VK2hFwAc0xE5VxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718677343; c=relaxed/simple;
	bh=Krx7BIGwbOfW7B/Nu86DGtNFQNHBINWH0kO1g6IQEno=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=b5S0uKyqKVXKWFag65V6HI4DMa2hRw8rkLR41/R9WlaOmYFZ/nSLVAfkr9ijOAF0xzzoSgPfMJ5wvLme97huHWQVEhADS5IVIDf2wfuo7fAj/r0rKXtZQc2ilYRbHYnUYhnZn7ustCE6uIG4AfcCr+vKh3u4VGSaKouvkyndtdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-7ebeebdc580so487171639f.2
        for <kvm@vger.kernel.org>; Mon, 17 Jun 2024 19:22:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718677341; x=1719282141;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1rsL/flw0v+H7gOqJ0rkLoiD+h7tAoEgg4SPt2R5InQ=;
        b=H9iUnLwZUrUCiNaL/vbH6AE4Hdz0SAshpwVhcSDSR9ZGs96HoVGdsvztJwW9EJIpST
         rEBpNY4wnrDoVA0/kGaCtcXZi8FDqeGx9BoB4mNe2HPgT3UYWaVjyVNPDZIWZ4iz4JDf
         ryWrtoa1XFufk7X/5NiskNzLtA5d0P/WRvoJz70BfPvIOVvB5eWzGJhJH7nsivbgiAT6
         YC2yVpikgmfdYS8PLJueAM3s0VZ6xG6z/UsOCJn4XB7oagtM7IHWjIpDWpJn6pZNCCPf
         +FEhBnDfH1V+n63nLA2H1vtRzLc4+2jwCGKFdkHR4NUZkHpHE3S+vcgdM/I6W9xhZ+9f
         LhpQ==
X-Forwarded-Encrypted: i=1; AJvYcCUfXLidT/Ns+vUumbHKhv8CBzA2W4TMJ1pZsZWNQlX8dIIcRTwj8YNY1+8Ixwb8ehVRsiBQ2ogRtSni3Dv7WjRekEnj
X-Gm-Message-State: AOJu0YxEBRdTysOgZ0IQGL28AV3k5zlaoxwiXi1XJO9WbuykjBK83kL4
	hPZDEqRsl60Nx2wfbx+ISCwVvh5bhZKpPj1GXnEKFPu4SuSTj/70jlKcVzeH1Pv9YJ7/1Ktpwa6
	JS+NDHFGq3vsueVnAG4Ju6Xb2Co+Ew2w0sdkyv7hqoBnvUrFKtaT3FVc=
X-Google-Smtp-Source: AGHT+IFjvgGDqwgzV3k/IEDTJWgutMnBsB0iUhHzpg1jjtijNwyQ/Zlg0dt4QOMKTNzE014IjwOc0bSeU8yCiRq9SukUTPP6xuGG
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:164e:b0:375:a40f:97d1 with SMTP id
 e9e14a558f8ab-375e0ec20dcmr9374315ab.4.1718677341642; Mon, 17 Jun 2024
 19:22:21 -0700 (PDT)
Date: Mon, 17 Jun 2024 19:22:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006eb03a061b20c079@google.com>
Subject: [syzbot] [kvm?] general protection fault in get_work_pool (2)
From: syzbot <syzbot+0dc211bc2adb944e1fd6@syzkaller.appspotmail.com>
To: Jason@zx2c4.com, davem@davemloft.net, edumazet@google.com, kuba@kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	pabeni@redhat.com, syzkaller-bugs@googlegroups.com, wireguard@lists.zx2c4.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    2ccbdf43d5e7 Merge tag 'for-linus' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16f23146980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=81c0d76ceef02b39
dashboard link: https://syzkaller.appspot.com/bug?extid=0dc211bc2adb944e1fd6
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-2ccbdf43.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/13cdb5bfbafa/vmlinux-2ccbdf43.xz
kernel image: https://storage.googleapis.com/syzbot-assets/7a14f5d07f81/bzImage-2ccbdf43.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+0dc211bc2adb944e1fd6@syzkaller.appspotmail.com

Oops: general protection fault, probably for non-canonical address 0xe003fbfffff80000: 0000 [#1] PREEMPT SMP KASAN NOPTI
KASAN: maybe wild-memory-access in range [0x001fffffffc00000-0x001fffffffc00007]
CPU: 1 PID: 5570 Comm: kworker/1:5 Not tainted 6.10.0-rc3-syzkaller-00044-g2ccbdf43d5e7 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Workqueue: wg-crypt-wg2 wg_packet_tx_worker
RIP: 0010:get_work_pool+0xcb/0x1c0 kernel/workqueue.c:887
Code: 0d 36 00 48 89 d8 5b 5d c3 cc cc cc cc e8 8d 0d 36 00 48 81 e3 00 fe ff ff 48 b8 00 00 00 00 00 fc ff df 48 89 da 48 c1 ea 03 <80> 3c 02 00 0f 85 da 00 00 00 48 8b 1b e8 63 0d 36 00 48 89 d8 5b
RSP: 0018:ffffc90000598738 EFLAGS: 00010006
RAX: dffffc0000000000 RBX: 001fffffffc00000 RCX: ffffffff815881f2
RDX: 0003fffffff80000 RSI: ffffffff81588243 RDI: 0000000000000007
RBP: 0000000000000004 R08: 0000000000000007 R09: 0000000000000000
R10: 0000000000000004 R11: 0000000000000005 R12: ffffe8ffad288cc0
R13: ffff888000596400 R14: dffffc0000000000 R15: ffff88805b626800
FS:  0000000000000000(0000) GS:ffff88802c100000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000f7f75598 CR3: 0000000056bd0000 CR4: 0000000000350ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 __queue_work+0x200/0x1020 kernel/workqueue.c:2301
 queue_work_on+0x11a/0x140 kernel/workqueue.c:2410
 wg_queue_enqueue_per_device_and_peer drivers/net/wireguard/queueing.h:176 [inline]
 wg_packet_consume_data drivers/net/wireguard/receive.c:526 [inline]
 wg_packet_receive+0xf65/0x2350 drivers/net/wireguard/receive.c:576
 wg_receive+0x74/0xc0 drivers/net/wireguard/socket.c:326
 udp_queue_rcv_one_skb+0xad1/0x18b0 net/ipv4/udp.c:2131
 udp_queue_rcv_skb+0x198/0xd10 net/ipv4/udp.c:2209
 udp_unicast_rcv_skb+0x165/0x3b0 net/ipv4/udp.c:2369
 __udp4_lib_rcv+0x2636/0x3550 net/ipv4/udp.c:2445
 ip_protocol_deliver_rcu+0x30c/0x4e0 net/ipv4/ip_input.c:205
 ip_local_deliver_finish+0x316/0x570 net/ipv4/ip_input.c:233
 NF_HOOK include/linux/netfilter.h:314 [inline]
 NF_HOOK include/linux/netfilter.h:308 [inline]
 ip_local_deliver+0x18e/0x1f0 net/ipv4/ip_input.c:254
 dst_input include/net/dst.h:460 [inline]
 ip_rcv_finish net/ipv4/ip_input.c:449 [inline]
 NF_HOOK include/linux/netfilter.h:314 [inline]
 NF_HOOK include/linux/netfilter.h:308 [inline]
 ip_rcv+0x2c5/0x5d0 net/ipv4/ip_input.c:569
 __netif_receive_skb_one_core+0x199/0x1e0 net/core/dev.c:5625
 __netif_receive_skb+0x1d/0x160 net/core/dev.c:5739
 process_backlog+0x133/0x760 net/core/dev.c:6068
 __napi_poll.constprop.0+0xb7/0x550 net/core/dev.c:6722
 napi_poll net/core/dev.c:6791 [inline]
 net_rx_action+0x9b6/0xf10 net/core/dev.c:6907
 handle_softirqs+0x216/0x8f0 kernel/softirq.c:554
 do_softirq kernel/softirq.c:455 [inline]
 do_softirq+0xb2/0xf0 kernel/softirq.c:442
 </IRQ>
 <TASK>
 __local_bh_enable_ip+0x100/0x120 kernel/softirq.c:382
 wg_socket_send_skb_to_peer+0x14c/0x220 drivers/net/wireguard/socket.c:184
 wg_packet_create_data_done drivers/net/wireguard/send.c:251 [inline]
 wg_packet_tx_worker+0x1aa/0x810 drivers/net/wireguard/send.c:276
 process_one_work+0x958/0x1ad0 kernel/workqueue.c:3231
 process_scheduled_works kernel/workqueue.c:3312 [inline]
 worker_thread+0x6c8/0xf70 kernel/workqueue.c:3393
 kthread+0x2c1/0x3a0 kernel/kthread.c:389
 ret_from_fork+0x45/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:get_work_pool+0xcb/0x1c0 kernel/workqueue.c:887
Code: 0d 36 00 48 89 d8 5b 5d c3 cc cc cc cc e8 8d 0d 36 00 48 81 e3 00 fe ff ff 48 b8 00 00 00 00 00 fc ff df 48 89 da 48 c1 ea 03 <80> 3c 02 00 0f 85 da 00 00 00 48 8b 1b e8 63 0d 36 00 48 89 d8 5b
RSP: 0018:ffffc90000598738 EFLAGS: 00010006
RAX: dffffc0000000000 RBX: 001fffffffc00000 RCX: ffffffff815881f2
RDX: 0003fffffff80000 RSI: ffffffff81588243 RDI: 0000000000000007
RBP: 0000000000000004 R08: 0000000000000007 R09: 0000000000000000
R10: 0000000000000004 R11: 0000000000000005 R12: ffffe8ffad288cc0
R13: ffff888000596400 R14: dffffc0000000000 R15: ffff88805b626800
FS:  0000000000000000(0000) GS:ffff88802c100000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000f7f75598 CR3: 0000000056bd0000 CR4: 0000000000350ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	0d 36 00 48 89       	or     $0x89480036,%eax
   5:	d8 5b 5d             	fcomps 0x5d(%rbx)
   8:	c3                   	ret
   9:	cc                   	int3
   a:	cc                   	int3
   b:	cc                   	int3
   c:	cc                   	int3
   d:	e8 8d 0d 36 00       	call   0x360d9f
  12:	48 81 e3 00 fe ff ff 	and    $0xfffffffffffffe00,%rbx
  19:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  20:	fc ff df
  23:	48 89 da             	mov    %rbx,%rdx
  26:	48 c1 ea 03          	shr    $0x3,%rdx
* 2a:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1) <-- trapping instruction
  2e:	0f 85 da 00 00 00    	jne    0x10e
  34:	48 8b 1b             	mov    (%rbx),%rbx
  37:	e8 63 0d 36 00       	call   0x360d9f
  3c:	48 89 d8             	mov    %rbx,%rax
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

