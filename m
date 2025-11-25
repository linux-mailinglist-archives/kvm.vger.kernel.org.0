Return-Path: <kvm+bounces-64517-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3382BC85FCA
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 17:32:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 81C533A6247
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 16:32:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69068329391;
	Tue, 25 Nov 2025 16:32:30 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44B16328B70
	for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 16:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764088349; cv=none; b=e0JMepAygEzXNVoI46bb1ERbzeOY+Y0A+FkT1YsGZQp/p89EF86JylN3mWgAKj303b3tbS0PTXG+ZPRhzRX2TlPGHcNC2froGp4thy9OuxrtPNsK/Hkqhfmu0QAXDiFKYJl37k+EbT77YiSI1aQi2KuLaeKxOKktG//4xdP/+Qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764088349; c=relaxed/simple;
	bh=i+kTqcNHDt1fr/hn5qo1+7cvypf2a4JOHVlaHV1P80c=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Bo2gHJyp/Zbh2ozkRjOwu3faM0VKqsKMlahQ2R70qKiH666O5mQaUyhuw6tGBsYZ4orcqdFG3RvfMQuIoj64fjWqwJsD1mtNBm4G1p0u3oNFQYwCGqzIj5jxOaKiBrmf6/HloDc6aH0D3ROhvPCGPmgLhVe3R6qOxO8wtgVBtEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-94908fb82e0so47958239f.3
        for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 08:32:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764088347; x=1764693147;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ABCa2fnzsazLn4yF5RZ6eg1lVa/evbqqqpSFnQwZATo=;
        b=qxWBb9m+ylMqjViL6PKaN10PCedQxUaAvQm2hh54mOBMzHXlirT9hSKlDXNKaTM3wZ
         Da7KJuswYOZriBHj+6pKm5D0KGKhW5u4o8vAWDH8JCj9AC/GmnzYKeO6wR2th/dT3SAx
         jZqTbTCv9Ev0/l0vLQIOuDnVYWcnhf03vV5Bew/wi9kXy54KsfSArORW6z83em6eFVpu
         lCJo3dCp1xBEJBjixmutLbhQamxkHunbsB2UOvrc62h+gxeDC7i8pm1doj+C0ez0xFfx
         niVjxEQdir6lO4QF88q/lu6/VhkMCe7O682MwO9hNhbtx9AVC5i4he5Ba+EDErBUXfj5
         EWoQ==
X-Forwarded-Encrypted: i=1; AJvYcCVGQQ1jQrktG5a0pY5LeR4jozfEM9bHmcaXO7aqw5XRYNyGx6/J8nAPvc20L4IDOcYrFCE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzmce6QhglQnFrjPBUG+NMJYqTySQZdhzimZA2J/qRFSjTGhOy3
	I4TzJEN936xiMWc9XLK0fGt+wxkBap7DVDKiJ/Vvxmd5JdAMgoNQOe6DHjOEWkFcy5X6uLwDmyp
	TCx4F0ALi/PxOMqCRFG0YVhadLtvBt9vt2ks8JhpLwYurY3MGts5X0dn52Po=
X-Google-Smtp-Source: AGHT+IEPzX3/ELOrVIaNQv5Sp4CkfkT25DJFda9tWjY/x7c9nJQmp3MdT+7UWl4hXfTFV4bRfweKE9WwBI7b//Dr0KTkedtodiaj
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:12e2:b0:434:96ea:ff77 with SMTP id
 e9e14a558f8ab-435dd1252d8mr25836035ab.39.1764088347376; Tue, 25 Nov 2025
 08:32:27 -0800 (PST)
Date: Tue, 25 Nov 2025 08:32:27 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6925da1b.a70a0220.d98e3.00b0.GAE@google.com>
Subject: [syzbot] [kvm-x86?] WARNING in kvm_apic_accept_events (2)
From: syzbot <syzbot+59f2c3a3fc4f6c09b8cd@syzkaller.appspotmail.com>
To: bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com, 
	pbonzini@redhat.com, seanjc@google.com, syzkaller-bugs@googlegroups.com, 
	tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    ac3fd01e4c1e Linux 6.18-rc7
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17cdc57c580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a1db0fea040c2a9f
dashboard link: https://syzkaller.appspot.com/bug?extid=59f2c3a3fc4f6c09b8cd
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-ac3fd01e.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/b4f3c9fb005b/vmlinux-ac3fd01e.xz
kernel image: https://storage.googleapis.com/syzbot-assets/93777421b2a4/bzImage-ac3fd01e.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+59f2c3a3fc4f6c09b8cd@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 40427
F2FS-fs (loop0): Image doesn't support compression
F2FS-fs (loop0): build fault injection rate: 551
F2FS-fs (loop0): build fault injection type: 0x2
F2FS-fs (loop0): invalid crc value
F2FS-fs (loop0): f2fs_recover_fsync_data: recovery fsync data, check_only: 0
F2FS-fs (loop0): Mounted with checkpoint version = 48b305e5
------------[ cut here ]------------
WARNING: CPU: 0 PID: 5324 at arch/x86/kvm/lapic.c:3483 kvm_apic_accept_events+0x341/0x490 arch/x86/kvm/lapic.c:3483
Modules linked in:
CPU: 0 UID: 0 PID: 5324 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:kvm_apic_accept_events+0x341/0x490 arch/x86/kvm/lapic.c:3483
Code: eb 0c e8 32 da 71 00 eb 05 e8 2b da 71 00 45 31 ff 44 89 f8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc e8 10 da 71 00 90 <0f> 0b 90 e9 ec fd ff ff 44 89 f9 80 e1 07 80 c1 03 38 c1 0f 8c 4f
RSP: 0018:ffffc9000d4bfbf0 EFLAGS: 00010287
RAX: ffffffff814e3940 RBX: 0000000000000002 RCX: 0000000000100000
RDX: ffffc9000e20a000 RSI: 0000000000000341 RDI: 0000000000000342
RBP: 0000000000000000 R08: 0000000000000000 R09: ffffffff814689b6
R10: dffffc0000000000 R11: ffffed100818c008 R12: 0000000000000002
R13: dffffc0000000000 R14: ffff8880515c1e00 R15: ffff888040c602d8
FS:  00007f1fff0686c0(0000) GS:ffff88808d72f000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f8420d909c0 CR3: 0000000042c75000 CR4: 0000000000352ef0
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
RIP: 0033:0x7f1ffe18f749
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f1fff068038 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f1ffe3e5fa0 RCX: 00007f1ffe18f749
RDX: 00002000000000c0 RSI: 000000008004ae98 RDI: 0000000000000005
RBP: 00007f1ffe213f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f1ffe3e6038 R14: 00007f1ffe3e5fa0 R15: 00007fff6a9934c8
 </TASK>


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

