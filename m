Return-Path: <kvm+bounces-54439-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 65342B21507
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 20:59:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6984846113D
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 18:59:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B900C2E2EE3;
	Mon, 11 Aug 2025 18:59:33 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f77.google.com (mail-io1-f77.google.com [209.85.166.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E0CD2E2DCB
	for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 18:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754938773; cv=none; b=ClB4AQ9lAdQjjq41FaX9GQkZAeoEp+bV9jVBTOUNqdvGSJNVC0FbxiU+//0s4ekHTbWoxe/j3UpJ/ah91uqgCuPM4WbiWH0h/QXXIqaTLOP4XkQAIGLypOkTAzrM7AHgVEwj2IuUeBEFa6a3NoYXCkuH4wfOM8lfArXPXdo3bfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754938773; c=relaxed/simple;
	bh=qpe99585nWcuMeUbtB6YFK49KQ+0dn0I5QuTMFCll9E=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=uLMVuC5M2F8tVBpCyLVlbJPZ2FuNXHhM7vqJx6sn/sjbFz8ATzVsHHHhdzhZcLDJuLYlCzPdxvkmhg5t/ZdtvUtbxusOiETLiG8akxfWc3+6V0JE1IkMH1MC/gzEAmISgiG+TtcnnRkalv7ZpKuISLrg9wKjY37jySm99oBXFL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f77.google.com with SMTP id ca18e2360f4ac-88193bc4b09so995602139f.2
        for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 11:59:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754938771; x=1755543571;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YGLjFsC/0fGo/wSRK/a7X0e+tUgJQSVfZBcPlbBveVE=;
        b=Pfvmmhd0VnrfBW2L0oYwcU9TtInRc9DT8QkPlQSrQD1g0XwI1zSamigwfiBL7Yr5Rf
         wDWs6a5ZyEjkFkqZx9p/3fahR8Pp3LUv80n3OGl2gT3teREx6aWaOb+8K/ZbyVu1HPrE
         4ZSzQs8bj79c3WFCHMS7HyzpFoguPvS6fPMFsVyjL4Xcjb7M2y5rV0lOph0j63iKcphu
         zw+NFtHs3f5gtrMfdwFeYX3LzGqtRK+yV6Xr2sZRaf0ImmsNrhjTlIhIH4jWjWVDSxQM
         TOMcq/lmYkXb5Eu5RgNPNTckFTqONd60hnRzQSkOg3EcdWF1Qd2c3KNiqdmP7NtFxUpY
         lwNQ==
X-Forwarded-Encrypted: i=1; AJvYcCUJU+pBK4wfDDk83VNVbiYlgxtJmsesUs9mlRI1APptTKOkJCiCJek+mKUyBxBLaxM+GkE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyVAqPt1IfOfAZn8Q+Jpz7IVLDU6NgMxbhIBk2o3cO3oR5LmRVk
	6ADe5vrfHvgMSvVPO4Fqn1kbW/WWueD+IszCiSQNubFaOIkQYaG+xiCNBCWl53f0H8FkuzyXjgp
	mOQ7M9qWAUdpr+a86/EqzHLbF9PU8VqnCpw4hXpT6+TX3KejVkDi7hPz0BSo=
X-Google-Smtp-Source: AGHT+IG4ZHYVn+hMo6CEbA6nZIH+gqK3ILvKIVQISqISbXrTS+Rq3aSBIzCvY1veBlYu5s5sTnN6aaEG+ZDJOqYrW3GZHOH1NC6+
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:7198:b0:87c:3d17:6608 with SMTP id
 ca18e2360f4ac-8841bcd5326mr154899039f.0.1754938770808; Mon, 11 Aug 2025
 11:59:30 -0700 (PDT)
Date: Mon, 11 Aug 2025 11:59:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <689a3d92.050a0220.7f033.00ff.GAE@google.com>
Subject: [syzbot] [kvm?] [net?] [virt?] WARNING in virtio_transport_send_pkt_info
From: syzbot <syzbot+b4d960daf7a3c7c2b7b1@syzkaller.appspotmail.com>
To: davem@davemloft.net, edumazet@google.com, eperezma@redhat.com, 
	horms@kernel.org, jasowang@redhat.com, kuba@kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mst@redhat.com, netdev@vger.kernel.org, 
	pabeni@redhat.com, sgarzare@redhat.com, stefanha@redhat.com, 
	syzkaller-bugs@googlegroups.com, virtualization@lists.linux.dev, 
	xuanzhuo@linux.alibaba.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    37816488247d Merge tag 'net-6.17-rc1' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10b3b2f0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e143c1cd9dadd720
dashboard link: https://syzkaller.appspot.com/bug?extid=b4d960daf7a3c7c2b7b1
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10f0f042580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14855434580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-37816488.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/74b3ac8946d4/vmlinux-37816488.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a2b391aacaec/bzImage-37816488.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b4d960daf7a3c7c2b7b1@syzkaller.appspotmail.com

------------[ cut here ]------------
'send_pkt()' returns 0, but 65536 expected
WARNING: CPU: 0 PID: 5503 at net/vmw_vsock/virtio_transport_common.c:428 virtio_transport_send_pkt_info+0xd11/0xf00 net/vmw_vsock/virtio_transport_common.c:426
Modules linked in:
CPU: 0 UID: 0 PID: 5503 Comm: syz.0.17 Not tainted 6.16.0-syzkaller-12063-g37816488247d #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:virtio_transport_send_pkt_info+0xd11/0xf00 net/vmw_vsock/virtio_transport_common.c:426
Code: 0f 0b 90 bd f2 ff ff ff eb bc e8 8a 20 65 f6 c6 05 94 cf 32 04 01 90 48 c7 c7 00 c3 b8 8c 44 89 f6 4c 89 ea e8 40 af 28 f6 90 <0f> 0b 90 90 e9 e1 fe ff ff e8 61 20 65 f6 90 0f 0b 90 e9 c5 f7 ff
RSP: 0018:ffffc900027ff530 EFLAGS: 00010246
RAX: d7fcdfc663889c00 RBX: 0000000000010000 RCX: ffff888000e1a440
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000002
RBP: ffffffff8f8764d0 R08: ffff88801fc24253 R09: 1ffff11003f8484a
R10: dffffc0000000000 R11: ffffed1003f8484b R12: dffffc0000000000
R13: 0000000000010000 R14: 0000000000000000 R15: ffff888058b48024
FS:  000055556bda1500(0000) GS:ffff88808d218000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000020000003f000 CR3: 000000003f6db000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 virtio_transport_stream_enqueue net/vmw_vsock/virtio_transport_common.c:1111 [inline]
 virtio_transport_seqpacket_enqueue+0x143/0x1c0 net/vmw_vsock/virtio_transport_common.c:839
 vsock_connectible_sendmsg+0xac7/0x1050 net/vmw_vsock/af_vsock.c:2140
 sock_sendmsg_nosec net/socket.c:714 [inline]
 __sock_sendmsg+0x21c/0x270 net/socket.c:729
 ____sys_sendmsg+0x52d/0x830 net/socket.c:2614
 ___sys_sendmsg+0x21f/0x2a0 net/socket.c:2668
 __sys_sendmmsg+0x227/0x430 net/socket.c:2757
 __do_sys_sendmmsg net/socket.c:2784 [inline]
 __se_sys_sendmmsg net/socket.c:2781 [inline]
 __x64_sys_sendmmsg+0xa0/0xc0 net/socket.c:2781
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fddc238ebe9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd48081028 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 00007fddc25b5fa0 RCX: 00007fddc238ebe9
RDX: 0000000000000001 RSI: 0000200000000100 RDI: 0000000000000004
RBP: 00007fddc2411e19 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000024008094 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fddc25b5fa0 R14: 00007fddc25b5fa0 R15: 0000000000000004
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

