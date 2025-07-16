Return-Path: <kvm+bounces-52563-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 02D0BB06CEC
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 07:05:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5BED91AA4523
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 05:06:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B9EE27586A;
	Wed, 16 Jul 2025 05:05:36 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5134211CA9
	for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 05:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752642335; cv=none; b=SEWM8YWKGQrslVGBpiMTclmO9/i0MXRM9SYKiTiJErlr64IjLlEjJrf7PuQaxh9GLZNB372oXu/bsSnolnr11VScXs2nKRBSU6mjIvYdW4J2ocHDI0luPqiuJ2A+ze9ntiuTPRUguSC6EDVpufx6rbEPWA/sPYUFK2H3KULhRbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752642335; c=relaxed/simple;
	bh=RZppmMPEfXQmDVmlSWuPtLb7KcNsqptZmrrxdRnJ4I0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=ew6bc77ovPLlZMqfpZfdGLHK5AzOA6+4suO6jMd6bM2x7x1VBFE6b77Ud8CsH4m25icqF15/wf+perQ6tHtgappg/1EtcVoQ2VpYIM8VdXwlaEbONOSUX0EenKNVtmqvY9tRILBE5sl2uzc5H2qMuQJGVIWt6jxx0GxT99ZAZVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-8760733a107so694230139f.3
        for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 22:05:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752642333; x=1753247133;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5eFVdrKUzF4tgti5L1f+mIb2kZ3seYnsyN1RJsW63Ho=;
        b=DklmeL1pyPnSA2uBBywenYQ3EntfftI03T+MZUPh4esLg8TeTev+yx0pH/9HrvvGRg
         DEBZskcWwhs1AuriHN+rBf5DVelDmRwjsNK4hO3k7bvrRHP/fKZuiSqBf1ACvsDrzh2h
         0ko+Y2CW5Qq+oY+/xejhieBUE/izZA9xenP+qKMfgvAm74uzQTg6QVdBZGJUF2Pxm2/h
         pFW9kJyJJ18h/5PumAw0VOLqBKXTvnll7ZzIvPvnTx114IfNMrnScAtaPmkgrYMVw6Sd
         yCNYdpaNnfVq2rIKH3QmC69lvwUARk0A6ID37So2aqaFERjS0mV8UZ3NO4RSnvb/P/SA
         Zt5g==
X-Gm-Message-State: AOJu0YzoFaaL/3DC1MbLrCII4/3ugOtzKq/hEXHTDkRHvBvKar/7WuQC
	x+bxKzqiQVCuFNzswvloPXM8e72R1CoXoDsX1NDH7Lu2waBLSUNlsM1TZ14W8heiS3J29KElKqw
	rznfRnvszEju8a093dT37jjSTLAGkRwvBJfyUf+vt2Z9jCL3oLC30riY7rRD1Qg==
X-Google-Smtp-Source: AGHT+IH0EEYUY/Tb5ji8Ieyc+IsrQ85tPM9QnGyJZFRrzWdnuGzDei5AVWwPMzJ1FRVormAI/CcibTEYxNGseNyR7HmGNQsw5xbz
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:19cc:b0:3dd:792d:ce42 with SMTP id
 e9e14a558f8ab-3e2821e9b4bmr14935695ab.0.1752642333479; Tue, 15 Jul 2025
 22:05:33 -0700 (PDT)
Date: Tue, 15 Jul 2025 22:05:33 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6877331d.a00a0220.3af5df.000c.GAE@google.com>
Subject: [syzbot] [kvm?] WARNING in kvm_read_guest_offset_cached
From: syzbot <syzbot+bc0e18379a290e5edfe4@syzkaller.appspotmail.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    155a3c003e55 Merge tag 'for-6.16/dm-fixes-2' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=103e858c580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8d5ef2da1e1c848
dashboard link: https://syzkaller.appspot.com/bug?extid=bc0e18379a290e5edfe4
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=153188f0580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16f6198c580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-155a3c00.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/725a320dfe66/vmlinux-155a3c00.xz
kernel image: https://storage.googleapis.com/syzbot-assets/9f06899bb6f3/bzImage-155a3c00.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+bc0e18379a290e5edfe4@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 6107 at arch/x86/kvm/../../../virt/kvm/kvm_main.c:3459 kvm_read_guest_offset_cached+0x3f5/0x4b0 virt/kvm/kvm_main.c:3459
Modules linked in:
CPU: 0 UID: 0 PID: 6107 Comm: syz.0.16 Not tainted 6.16.0-rc6-syzkaller-00002-g155a3c003e55 #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:kvm_read_guest_offset_cached+0x3f5/0x4b0 virt/kvm/kvm_main.c:3459
Code: 0f 01 e8 3e 6c 61 00 e9 9b fc ff ff e8 14 25 85 00 48 8b 3c 24 31 d2 48 89 ee e8 16 bf fa 00 e9 2e fe ff ff e8 fc 24 85 00 90 <0f> 0b 90 bb ea ff ff ff e9 4d fe ff ff e8 e9 24 85 00 48 8b 74 24
RSP: 0018:ffffc9000349f960 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff888050329898 RCX: ffffffff8136ca66
RDX: ffff88803cfa8000 RSI: ffffffff8136cd84 RDI: 0000000000000006
RBP: 0000000000000004 R08: 0000000000000006 R09: 0000000000000008
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000004
R13: ffffc90003921000 R14: 0000000000000000 R15: ffffc900039215a0
FS:  000055558378f500(0000) GS:ffff8880d6713000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 0000000025de6000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 apf_pageready_slot_free arch/x86/kvm/x86.c:13452 [inline]
 kvm_arch_can_dequeue_async_page_present+0x172/0x310 arch/x86/kvm/x86.c:13571
 kvm_check_async_pf_completion+0x61/0x440 virt/kvm/async_pf.c:158
 vcpu_enter_guest arch/x86/kvm/x86.c:10930 [inline]
 vcpu_run+0x48c2/0x5500 arch/x86/kvm/x86.c:11335
 kvm_arch_vcpu_ioctl_run+0x51e/0x18c0 arch/x86/kvm/x86.c:11658
 kvm_vcpu_ioctl+0x5eb/0x1690 virt/kvm/kvm_main.c:4464
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:907 [inline]
 __se_sys_ioctl fs/ioctl.c:893 [inline]
 __x64_sys_ioctl+0x18e/0x210 fs/ioctl.c:893
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xcd/0x4c0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fdb7658e929
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd25fe7d98 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007fdb767b5fa0 RCX: 00007fdb7658e929
RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000005
RBP: 00007fdb76610b39 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fdb767b5fa0 R14: 00007fdb767b5fa0 R15: 0000000000000003
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

