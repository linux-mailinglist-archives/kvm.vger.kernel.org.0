Return-Path: <kvm+bounces-64915-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id A89BCC90861
	for <lists+kvm@lfdr.de>; Fri, 28 Nov 2025 02:44:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 30B4E34F1B9
	for <lists+kvm@lfdr.de>; Fri, 28 Nov 2025 01:44:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6874825B30E;
	Fri, 28 Nov 2025 01:44:27 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38AA4248F72
	for <kvm@vger.kernel.org>; Fri, 28 Nov 2025 01:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764294266; cv=none; b=rK+xH4vr3UV6Wvej4IQMx1LZrtd0KETT0Qrq3irnCCIXEuZ0BDQWlwggFQI6RDFVpA5OFUQ7nu2n26UxJazS7ZoowiyTtUv2wqUS7Y10djE0+0RSIOll86NgGqtYaw2VA4NK4qfwASd+zuyFEfZuluaRpo6CS8Q+qWHMzUX1a3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764294266; c=relaxed/simple;
	bh=m56HVa8izRgipZSOdJjvIpy7h81Ckb2Ri5FLV/zI8TY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=al3IMYG3dqr57EQ5055HuPi7qysrXVF2HnON57b+v3mwc2Wq0Ssvj9enRW0cQnC5lRxEbKCKbI6bSrdVQPNtp+xt+563YzBc65l81kVIwRDPGFg4TI9QzY6XYWdNPjWJj7iwxsFxw506+WcRVamk9Sip3hFck7a4OdjuskWBdtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-43331ea8ed8so10234515ab.3
        for <kvm@vger.kernel.org>; Thu, 27 Nov 2025 17:44:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764294264; x=1764899064;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YGtxlxaVlJyvlWAEowoHTPy95LmRppeiT0GNgF9JGiA=;
        b=la/ZtkU0y10i8lkR3f088Fv66CQKbN5T+zobj5LcJW0lxVHFzjS0RbJ2qRVT7OPPfQ
         NRg9DJKie7zw5PX2gdQ6znwBKG6h977i6iIaXzHS6a6g9RoIKRrssWC1+dAoykej1Jm+
         pONJtD4Cqjf6jnArrijzJexViH3KHmu/VCOFykbXuNY92N3L9uZxQrJ5PDVCJET6L5SC
         3Is7xEdEIOZ9eUXMAMH0+rc93MLqLLNSzvVHnlQ99o0ZAHYHCrFGwVGNuwf6XCmsnPCk
         Fs15uqnEG3RWdDTXZZcIpzJ/skh2ws93QG8k+QR9+b6oLXAhhHw5fyzjDZPfgb1QWgS1
         56UA==
X-Forwarded-Encrypted: i=1; AJvYcCVH193V7nu4V/I0Z0xe0wlynbF0pKYa/OH3Xzl1zG/rd4ZV5bpPIhdZVlcDMkvcBamEz5I=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9S7Zfm/T4gc3KBPXgEqfRuvWCip40PcgWJjZl5LJv4cRGacq5
	O7IpKcAslONAzORgym7qLppTvtQdIG6ktrReyBs4UNU8Cp6scYLqfEccX+sgs+7z+R7Pe6TINwz
	ZNihbLXqwKWnaAK72cUAg3f6hL5I6q4BdbR+NSgk8l9TwPzDQPpw6nh2kRY8=
X-Google-Smtp-Source: AGHT+IFjliyc7o+9/9M8gBBNjRAqkbDhsdQ2w51FRpWCBUOel6GKu5SST4tshzg1ihuSxS3U9kT4JaJcoXhNT+jaj9+AOPhO03fX
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:7:b0:434:96ea:ff5f with SMTP id
 e9e14a558f8ab-435dd13e462mr107916675ab.40.1764294264424; Thu, 27 Nov 2025
 17:44:24 -0800 (PST)
Date: Thu, 27 Nov 2025 17:44:24 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6928fe78.a70a0220.d98e3.012a.GAE@google.com>
Subject: [syzbot] [kvm?] [net?] [virt?] WARNING in virtio_transport_send_pkt_info
 (2)
From: syzbot <syzbot+28e5f3d207b14bae122a@syzkaller.appspotmail.com>
To: davem@davemloft.net, edumazet@google.com, eperezma@redhat.com, 
	horms@kernel.org, jasowang@redhat.com, kuba@kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mst@redhat.com, netdev@vger.kernel.org, 
	pabeni@redhat.com, sgarzare@redhat.com, stefanha@redhat.com, 
	syzkaller-bugs@googlegroups.com, virtualization@lists.linux.dev, 
	xuanzhuo@linux.alibaba.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    d724c6f85e80 Add linux-next specific files for 20251121
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=12920f42580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=763fb984aa266726
dashboard link: https://syzkaller.appspot.com/bug?extid=28e5f3d207b14bae122a
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1458797c580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15afd612580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/b2f349c65e3c/disk-d724c6f8.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/aba40ae987ce/vmlinux-d724c6f8.xz
kernel image: https://storage.googleapis.com/syzbot-assets/0b98fbfe576f/bzImage-d724c6f8.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+28e5f3d207b14bae122a@syzkaller.appspotmail.com

------------[ cut here ]------------
'send_pkt()' returns 0, but 4096 expected
WARNING: net/vmw_vsock/virtio_transport_common.c:430 at virtio_transport_send_pkt_info+0xd1e/0xef0 net/vmw_vsock/virtio_transport_common.c:428, CPU#1: syz.0.17/5986
Modules linked in:
CPU: 1 UID: 0 PID: 5986 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
RIP: 0010:virtio_transport_send_pkt_info+0xd1e/0xef0 net/vmw_vsock/virtio_transport_common.c:428
Code: f6 90 0f 0b 90 e9 d7 f7 ff ff e8 5d cc 7c f6 c6 05 c6 5f 64 04 01 90 48 c7 c7 60 da b4 8c 44 89 f6 48 89 ea e8 13 eb 3e f6 90 <0f> 0b 90 90 eb 9e 89 d9 80 e1 07 80 c1 03 38 c1 0f 8c 0a f3 ff ff
RSP: 0018:ffffc900033a7508 EFLAGS: 00010246
RAX: 2383e4149a9d5400 RBX: 0000000000001000 RCX: ffff88807b361e80
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000002
RBP: 0000000000001000 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffffbfff1c3a720 R12: 0000000000040000
R13: dffffc0000000000 R14: 0000000000000000 R15: ffffc900033a7640
FS:  00005555677a5500(0000) GS:ffff888125b6f000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000030000 CR3: 0000000075f06000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 virtio_transport_stream_enqueue net/vmw_vsock/virtio_transport_common.c:1113 [inline]
 virtio_transport_seqpacket_enqueue+0x143/0x1c0 net/vmw_vsock/virtio_transport_common.c:841
 vsock_connectible_sendmsg+0xabf/0x1040 net/vmw_vsock/af_vsock.c:2158
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg+0x21c/0x270 net/socket.c:746
 ____sys_sendmsg+0x52d/0x870 net/socket.c:2634
 ___sys_sendmsg+0x21f/0x2a0 net/socket.c:2688
 __sys_sendmmsg+0x227/0x430 net/socket.c:2777
 __do_sys_sendmmsg net/socket.c:2804 [inline]
 __se_sys_sendmmsg net/socket.c:2801 [inline]
 __x64_sys_sendmmsg+0xa0/0xc0 net/socket.c:2801
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f1e5218f749
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fffbe398ef8 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 00007f1e523e5fa0 RCX: 00007f1e5218f749
RDX: 0000000000000001 RSI: 0000200000000100 RDI: 0000000000000004
RBP: 00007f1e52213f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000024008094 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f1e523e5fa0 R14: 00007f1e523e5fa0 R15: 0000000000000004
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

