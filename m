Return-Path: <kvm+bounces-64432-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 03953C827E1
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 22:13:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 62EA73AEB5E
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 21:13:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B90232E69C;
	Mon, 24 Nov 2025 21:13:05 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDFF032E132
	for <kvm@vger.kernel.org>; Mon, 24 Nov 2025 21:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764018784; cv=none; b=ZypU+3OtI3InMmIEXcyqr85qRt9n+jrmgUyfC/0GRTVSRIZ7dD2LKO86V56JyoV0LdNPYQ8nh7ZU+kO14n8fi/QSymbS95Ydpv2hcnAcAaX86mqoXSRWZB45lVkBcMRVA0jEMDpsg2Uf/xHKyaFu+1L4k5T97xefuZzSrSOHQU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764018784; c=relaxed/simple;
	bh=o3Prwdr6CJSZzV4oAHxZF5SSX4CdVf6Py56MRzWcQmg=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=ttwR1E2f0c8q4XfMgK6VXrr4YW0rjzZGSUKVv3uYucl4T43Lt1l/vUdz7C0hN2d+VEThV0rUk8lCGtENmFCUnHSB18358a9oaMS7eJQnbTbv9hxW8Kba/F2/Z+JhJc76Mc2fWdXG7IdV/PcJtXfYpK0WwCYXDGTee2hYvW5NyDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-4331d49b5b3so45766095ab.0
        for <kvm@vger.kernel.org>; Mon, 24 Nov 2025 13:13:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764018782; x=1764623582;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e4b/dK952cVoi8jfB1llt0sbxapxqGgkq3I9Ukw2KnU=;
        b=ZmT/sHbixz5rX+HLbYIcsnYRgELn8s2i/9J9QrRoR4tU9sxN7bM/bbNeXHoJxAtbtp
         7xyKLYDO4tYYOuqXyJ68Rzcl0T8KQQXHZjxyCEVZyWmtSkqW7or3I/oBkRqcUOYl5CF1
         +85WVRC5c51JuJF/PllJXh3nxV1SH5o9D0z3ixYtVUBPjXJ87v7o2eUFM1/spW4gb1Lx
         AacJk5/sQY+vXkyZ6M9wmihDXneCyuWWSaeVHMaTG3+1R3xjrcxFpo4P/5s9vqCa5J59
         uitykG1g9w61rKkqnOUxBVS6NiGivlfAbySURg4QbohyaJhNyjaBVFTAov4DYYfLV5sJ
         HTQg==
X-Forwarded-Encrypted: i=1; AJvYcCUixDp2sp8yTUY+vG0psZGro/q/4zj0CgdbA2UxiuZ37ad3jVJ56d/fULrs4sVli6FmbA0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+h4suuHUG9Q2pyMn1Y7aRtQcELDO87ODsHAebKtzExkywn1RP
	feqIt9eojce9XNabA2j7Km1h5JDPlKkNH1fiRfnkZ22NTx0/YAlimUTnzNKFwFkWzxor1cdZJQx
	CAL61X5yNDEXj9NovDrcytYwz/UYxc1nbaEtk8ihqZWY4QY5rO9/3x9J0C+o=
X-Google-Smtp-Source: AGHT+IGzG4eRGlMCcoX7ceX+yMB+ODAazL+ErLb58Un1dvlfYjpdADzrOZlHBTSDQ2reKYk0qrS52Hu1xMksmiwN+qQkFq8GniHO
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:cda2:0:b0:433:7a0e:ef29 with SMTP id
 e9e14a558f8ab-435dd065293mr3604165ab.10.1764018782103; Mon, 24 Nov 2025
 13:13:02 -0800 (PST)
Date: Mon, 24 Nov 2025 13:13:02 -0800
In-Reply-To: <aSS-EO_QigXzRDCy@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6924ca5e.a70a0220.d98e3.0097.GAE@google.com>
Subject: Re: [syzbot] [kvm-x86?] WARNING in x86_emulate_insn (2)
From: syzbot <syzbot+fa52a184ebce1b30ad49@syzkaller.appspotmail.com>
To: bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com, 
	pbonzini@redhat.com, seanjc@google.com, syzkaller-bugs@googlegroups.com, 
	tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
WARNING in x86_emulate_insn

------------[ cut here ]------------
WARNING: arch/x86/kvm/emulate.c:5433 at x86_emulate_insn+0x265f/0x3bd0 arch/x86/kvm/emulate.c:5433, CPU#0: syz.2.670/9601
Modules linked in:
CPU: 0 UID: 0 PID: 9601 Comm: syz.2.670 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
RIP: 0010:x86_emulate_insn+0x265f/0x3bd0 arch/x86/kvm/emulate.c:5433
Code: 00 41 8b 2e 31 ff 89 ee e8 ee 83 77 00 85 ed 0f 84 f4 01 00 00 e8 a1 7f 77 00 bd 01 00 00 00 e9 9d f9 ff ff e8 92 7f 77 00 90 <0f> 0b 90 48 8b 44 24 28 42 80 3c 28 00 74 08 4c 89 e7 e8 7a 1b de
RSP: 0018:ffffc90003327748 EFLAGS: 00010293
RAX: ffffffff814a79de RBX: ffff888027c7e270 RCX: ffff88802f2abd00
RDX: 0000000000000000 RSI: 00000000000000ff RDI: 000000000000001f
RBP: 00000000000000ff R08: ffff88802f2abd00 R09: 0000000000000002
R10: 0000000000000006 R11: 0000000000000000 R12: ffff888027c7e278
R13: dffffc0000000000 R14: ffff888027c7e2a0 R15: 0000000000000000
FS:  00007fd173f646c0(0000) GS:ffff888125a6f000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000007741a000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 x86_emulate_instruction+0xea7/0x20b0 arch/x86/kvm/x86.c:9512
 kvm_arch_vcpu_ioctl_run+0x1404/0x1cd0 arch/x86/kvm/x86.c:11951
 kvm_vcpu_ioctl+0x99a/0xed0 virt/kvm/kvm_main.c:4477
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fd17318f749
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fd173f64038 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007fd1733e6090 RCX: 00007fd17318f749
RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000005
RBP: 00007fd173213f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fd1733e6128 R14: 00007fd1733e6090 R15: 00007ffe5ab25448
 </TASK>


Tested on:

commit:         380ecf40 Revert "KVM: x86: Add support for emulating M..
git tree:       https://github.com/sean-jc/linux.git x86/emulator_no_avx
console output: https://syzkaller.appspot.com/x/log.txt?x=155af97c580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=763fb984aa266726
dashboard link: https://syzkaller.appspot.com/bug?extid=fa52a184ebce1b30ad49
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8

Note: no patches were applied.

