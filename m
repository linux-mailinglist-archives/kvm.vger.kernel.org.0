Return-Path: <kvm+bounces-64560-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 32A14C8709A
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 21:29:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 1DDBA4E9E21
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 20:29:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB46633BBA0;
	Tue, 25 Nov 2025 20:29:35 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B72BB2367D1
	for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 20:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764102575; cv=none; b=otpT80/uUAovbKrKP0W42Wzah3mOUIM5VoEAXL3ifu+EIboNzhjf0Cuyy4P2iusPmF7b0z+iLjC/5B9e8eez0fT49I+tWK0LypkRAQUEKqIoAqb8ehRPdJXsb51aw6dT9eAfYH1PwdGmo6g93/denlmC4FMoqMogwctXKpzJC+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764102575; c=relaxed/simple;
	bh=OUyUBXnAG9oYinRHzdxSWLiEg7I40n25FlLumq6F0FA=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=dwmB3jAMnzXFEKEwQBZZGbbbF1xNovbNagkMmDrzGUEOF7jlgpVvBsB0MHZWOXWEr1n4SLX9RKr243QM5TFp8VW+Am1PefXdK+7dGuUpHbshXB1/yBLFYsuCCChEVjd0CibSm87fDivx3BIU2GnhAL/yhTNYCXRlJ4tDb6Wlm4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-435a145a992so44554755ab.3
        for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 12:29:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764102573; x=1764707373;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EGRbFBGY+j4v+PO+24zcOmYHiPkvq5dreksnw2ehrhk=;
        b=tyMLMOC5Z+jbxWF3qBaDlp9fJ1O0rhEutRdgpdskStpofvLm/wmVpsetUS6Db5154r
         ZYWy+0WvT2A3xtjGHvfHrZfAHXyjyAUTjwOncfWRTWNQxdxMjN7k/noB6qefDidbF2qy
         nbUZVhG2vWjITVnc/osDRUOsfWQVvsJ7JlofVpERc0UPpcmmh/TzhHd99cEaKKyQme1k
         vorowzm7L0GOX6WPAyRdTD/kCbiQN0PA9B40HKbVoPa8bUuqRe0hrN/Ywuhcv9Gu7CXp
         PcQhuJz157TnnlPZik/XAXc05s4s7Z1eVGnUoWWA2kBQ/+3WSGhAL4mBhQvCuKI5l2sS
         +hXA==
X-Forwarded-Encrypted: i=1; AJvYcCWO2nGfIePCdEslFfGzZATmsVwzxleoSZS9nSeCPippcMuxZhqgV0r3Gz0ubey5WBVUbKw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyUB7sdr/BHCilu4TAsg9JxV+gmnuwRTdQWI3liUX1lUScBXQ2Y
	94F/Jcm+t1fr+U8QDCvuMomBAfV+b+Mk849Rhi+2HtMpo3iER/T8VHK4I6jWsC3Rx+fRPWtuAld
	DV96J81N+VWNS9pTuXqwzoRRsrrr5BvJMUQXuo50DtcpRVpWPP+E6LXiDgzQ=
X-Google-Smtp-Source: AGHT+IHzRbnmNJDYVGlbeFMimIOBG2/NLfXER7MzwyuSdhszWuuaI2hX7gA0l86Xx7MiOVQ/RlzUt1NXFoI/AYYSlI8+is1vumoT
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:19cc:b0:434:7cf6:6d20 with SMTP id
 e9e14a558f8ab-435b8c0991fmr145721565ab.11.1764102572730; Tue, 25 Nov 2025
 12:29:32 -0800 (PST)
Date: Tue, 25 Nov 2025 12:29:32 -0800
In-Reply-To: <6925da1b.a70a0220.d98e3.00b0.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <692611ac.a70a0220.2ea503.0091.GAE@google.com>
Subject: Re: [syzbot] [kvm-x86?] WARNING in kvm_apic_accept_events (2)
From: syzbot <syzbot+59f2c3a3fc4f6c09b8cd@syzkaller.appspotmail.com>
To: bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com, 
	pbonzini@redhat.com, seanjc@google.com, syzkaller-bugs@googlegroups.com, 
	tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    8a2bcda5e139 Merge tag 'for-6.18/dm-fixes' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1604f8b4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a1db0fea040c2a9f
dashboard link: https://syzkaller.appspot.com/bug?extid=59f2c3a3fc4f6c09b8cd
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13ecf612580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13d9cf42580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-8a2bcda5.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/fc3f96645396/vmlinux-8a2bcda5.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e20aa7be5d33/bzImage-8a2bcda5.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+59f2c3a3fc4f6c09b8cd@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 5495 at arch/x86/kvm/lapic.c:3483 kvm_apic_accept_events+0x341/0x490 arch/x86/kvm/lapic.c:3483
Modules linked in:
CPU: 0 UID: 0 PID: 5495 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:kvm_apic_accept_events+0x341/0x490 arch/x86/kvm/lapic.c:3483
Code: eb 0c e8 32 da 71 00 eb 05 e8 2b da 71 00 45 31 ff 44 89 f8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc e8 10 da 71 00 90 <0f> 0b 90 e9 ec fd ff ff 44 89 f9 80 e1 07 80 c1 03 38 c1 0f 8c 4f
RSP: 0018:ffffc90002b2fbf0 EFLAGS: 00010293
RAX: ffffffff814e3940 RBX: 0000000000000002 RCX: ffff88801f8ca480
RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000000002
RBP: 0000000000000000 R08: 0000000000000000 R09: ffffffff814689b6
R10: dffffc0000000000 R11: ffffed1002268008 R12: 0000000000000002
R13: dffffc0000000000 R14: ffff888042c95c00 R15: ffff8880113402d8
FS:  000055558ab60500(0000) GS:ffff88808d72f000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000002000 CR3: 0000000058d0b000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 kvm_arch_vcpu_ioctl_get_mpstate+0x128/0x480 arch/x86/kvm/x86.c:12147
 kvm_vcpu_ioctl+0x625/0xe90 virt/kvm/kvm_main.c:4539
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f918bd8f749
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc74a3c2a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f918bfe5fa0 RCX: 00007f918bd8f749
RDX: 0000000000000000 RSI: 000000008004ae98 RDI: 0000000000000005
RBP: 00007f918be13f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f918bfe5fa0 R14: 00007f918bfe5fa0 R15: 0000000000000003
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

