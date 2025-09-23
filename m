Return-Path: <kvm+bounces-58522-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6374CB955DE
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 12:02:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 207C93B0F1D
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 10:02:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56560317711;
	Tue, 23 Sep 2025 10:02:30 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2985928A3EF
	for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 10:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758621749; cv=none; b=PHWWzYJ0iFNkN/w88xAzdcnQUH2X1Pmp/esOkffVKduiczpb0LBh02WElwQjjif3rnm4m5HrjqOYFlhn3il7VCTDlEdxDoQ9Ply1jiZfvUQAazZYV5D+EDLYv5aSl9r0N+7ZvQy97I4fQbYBnQtyWG8wooUnEOBc/0XrVPuNE2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758621749; c=relaxed/simple;
	bh=vP2b43q8Otx+56Xc9ICtBn4KQK+JrDvcWePOlgxiTmM=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=tlPo5LbSsfRHG5QrZGanlgQKcOwCdS69BLw3lQ4lC5i8vk3CaVQTkaid58RpekWpzMDIt7s9HsTGkArT2x24YLzrZb4W6F9jjz2uiHssJZVJwitZ0YK54fHMomSr9xL3NaUUcwDiPv8ohhF+Idtxo7NZ4KC/cTroZqR3wltXweA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-425788b03a0so55083655ab.1
        for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 03:02:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758621747; x=1759226547;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BnoO0ABFH/orFP0p7AnbW6cVVX2ksnxroV/QSm6ULKw=;
        b=AWzYTNIHgDrh/CVAPq30b4dFFg8Zpl86wkb9Sx0RT++mCf/zt/UlvNBxO6Y4sVYvuV
         W5Y5qnXn2JwM590tMKMUds/e8Sg5YY3Kxidhj2bsa7pGzANw/Gn5txsTdybo5Z3zBE8d
         04fUAkRQVBP4LsCPoL6k+y4z/ngSo+UWV0nMfPITvzHuBBxK8rKVX4Me2ghzzM7/LkHr
         yeTstJiRem7icZRBKXC9wTexZuC16ZHNu0gbNzfuNt2IoMEP07ms4BanAt4oUwcQYEle
         Vg0FqlX0OpRUuIujK3eQmzW6wQbIULhDb5ob9ZUvAPMhfvnS9GJHkW4h3/gd9Nafduaz
         uTLQ==
X-Forwarded-Encrypted: i=1; AJvYcCVOwLGtXUyGb34G9bBWWYZaiME9oSRjPtbvdK2BGet8nB1N3+kmaoyK1tdMweBhAeUEL4c=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1b63Bp/DyQxBQF6CLjzH0P1GcMwCIxsYVoj4OCnqNgs54unvP
	449mxLOntpobPKo3zxp/3v97tAAivrc8wlVjeqTFaAQG37ehMt1yQxRbjiJaWywN+CYkhrMyrNc
	g56UXtOiZR1f6UvNapTLxBTK5S89sPMLrqdAVrXJC3iutkbBtCp7UUgnHAjY=
X-Google-Smtp-Source: AGHT+IGuoUl3Xj2OkVlUwzWqgcf7fqkwH0RKG/bkQUSoUKmCr93+V8TKQggY4e9jBWMrpmYd4VoycQI+RA3Ck6JtdJhPGExK6mOe
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3805:b0:3f0:f671:ac89 with SMTP id
 e9e14a558f8ab-42581ea3074mr31880795ab.23.1758621747336; Tue, 23 Sep 2025
 03:02:27 -0700 (PDT)
Date: Tue, 23 Sep 2025 03:02:27 -0700
In-Reply-To: <20250923050317.205482-1-Neeraj.Upadhyay@amd.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68d27033.a70a0220.1b52b.02a8.GAE@google.com>
Subject: [syzbot ci] Re: AMD: Add Secure AVIC KVM Support
From: syzbot ci <syzbot+ci3162984bece220f0@syzkaller.appspotmail.com>
To: bp@alien8.de, david.kaplan@amd.com, huibo.wang@amd.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, naveen.rao@amd.com, 
	neeraj.upadhyay@amd.com, nikunj@amd.com, pbonzini@redhat.com, 
	santosh.shukla@amd.com, seanjc@google.com, suravee.suthikulpanit@amd.com, 
	thomas.lendacky@amd.com, tiala@microsoft.com, vasant.hegde@amd.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] AMD: Add Secure AVIC KVM Support
https://lore.kernel.org/all/20250923050317.205482-1-Neeraj.Upadhyay@amd.com
* [RFC PATCH v2 01/17] KVM: x86/lapic: Differentiate protected APIC interrupt mechanisms
* [RFC PATCH v2 02/17] x86/cpufeatures: Add Secure AVIC CPU feature
* [RFC PATCH v2 03/17] KVM: SVM: Add support for Secure AVIC capability in KVM
* [RFC PATCH v2 04/17] KVM: SVM: Set guest APIC protection flags for Secure AVIC
* [RFC PATCH v2 05/17] KVM: SVM: Do not intercept SECURE_AVIC_CONTROL MSR for SAVIC guests
* [RFC PATCH v2 06/17] KVM: SVM: Implement interrupt injection for Secure AVIC
* [RFC PATCH v2 07/17] KVM: SVM: Add IPI Delivery Support for Secure AVIC
* [RFC PATCH v2 08/17] KVM: SVM: Do not inject exception for Secure AVIC
* [RFC PATCH v2 09/17] KVM: SVM: Do not intercept exceptions for Secure AVIC guests
* [RFC PATCH v2 10/17] KVM: SVM: Set VGIF in VMSA area for Secure AVIC guests
* [RFC PATCH v2 11/17] KVM: SVM: Enable NMI support for Secure AVIC guests
* [RFC PATCH v2 12/17] KVM: SVM: Add VMGEXIT handler for Secure AVIC backing page
* [RFC PATCH v2 13/17] KVM: SVM: Add IOAPIC EOI support for Secure AVIC guests
* [RFC PATCH v2 14/17] KVM: x86/ioapic: Disable RTC EOI tracking for protected APIC guests
* [RFC PATCH v2 15/17] KVM: SVM: Check injected timers for Secure AVIC guests
* [RFC PATCH v2 16/17] KVM: x86/cpuid: Disable paravirt APIC features for protected APIC
* [RFC PATCH v2 17/17] KVM: SVM: Advertise Secure AVIC support for SNP guests

and found the following issue:
general protection fault in kvm_apply_cpuid_pv_features_quirk

Full report is available here:
https://ci.syzbot.org/series/887b895e-0315-498c-99e5-966704f16fb5

***

general protection fault in kvm_apply_cpuid_pv_features_quirk

tree:      kvm-next
URL:       https://kernel.googlesource.com/pub/scm/virt/kvm/kvm/
base:      a6ad54137af92535cfe32e19e5f3bc1bb7dbd383
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/a65d3de7-36d8-4181-8566-80e0f0719955/config
C repro:   https://ci.syzbot.org/findings/939a8c5a-41b2-4e9b-9129-80dff6d039c4/c_repro
syz repro: https://ci.syzbot.org/findings/939a8c5a-41b2-4e9b-9129-80dff6d039c4/syz_repro

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000013: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000098-0x000000000000009f]
CPU: 0 UID: 0 PID: 5992 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:kvm_apply_cpuid_pv_features_quirk+0x38c/0x4f0 arch/x86/kvm/cpuid.c:248
Code: c1 e8 03 80 3c 10 00 74 12 4c 89 ff e8 9d d8 d4 00 48 ba 00 00 00 00 00 fc ff df bb 9c 00 00 00 49 03 1f 48 89 d8 48 c1 e8 03 <0f> b6 04 10 84 c0 0f 85 c2 00 00 00 80 3b 00 74 2e e8 4e 6a 71 00
RSP: 0018:ffffc90004f871a0 EFLAGS: 00010203
RAX: 0000000000000013 RBX: 000000000000009c RCX: ffff888107562440
RDX: dffffc0000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc90004f87250 R08: 0000000000000005 R09: 000000008b838003
R10: ffffc90004f872e0 R11: fffff520009f0e61 R12: ffff888034f30970
R13: 1ffff110069e612e R14: ffff888020170528 R15: ffff888034f302f8
FS:  000055556af3f500(0000) GS:ffff8880b861b000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffff40f56c8 CR3: 0000000020cc0000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 kvm_vcpu_after_set_cpuid+0xc75/0x18a0 arch/x86/kvm/cpuid.c:432
 kvm_set_cpuid+0xea4/0x1110 arch/x86/kvm/cpuid.c:551
 kvm_vcpu_ioctl_set_cpuid2+0xbe/0x130 arch/x86/kvm/cpuid.c:626
 kvm_arch_vcpu_ioctl+0x13c5/0x2a80 arch/x86/kvm/x86.c:5975
 kvm_vcpu_ioctl+0x74d/0xe90 virt/kvm/kvm_main.c:4637
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:598 [inline]
 __se_sys_ioctl+0xf9/0x170 fs/ioctl.c:584
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f14f278e82b
Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0 ff ff 77 1c 48 8b 44 24 18 64 48 2b 04 25 28 00 00
RSP: 002b:00007ffff40f55f0 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007ffff40f5d40 RCX: 00007f14f278e82b
RDX: 00007ffff40f5d40 RSI: 000000004008ae90 RDI: 0000000000000005
RBP: 00002000008fc000 R08: 0000000000000000 R09: 0000000000000006
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000063 R14: 00002000008fb000 R15: 00002000008fc800
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:kvm_apply_cpuid_pv_features_quirk+0x38c/0x4f0 arch/x86/kvm/cpuid.c:248
Code: c1 e8 03 80 3c 10 00 74 12 4c 89 ff e8 9d d8 d4 00 48 ba 00 00 00 00 00 fc ff df bb 9c 00 00 00 49 03 1f 48 89 d8 48 c1 e8 03 <0f> b6 04 10 84 c0 0f 85 c2 00 00 00 80 3b 00 74 2e e8 4e 6a 71 00
RSP: 0018:ffffc90004f871a0 EFLAGS: 00010203
RAX: 0000000000000013 RBX: 000000000000009c RCX: ffff888107562440
RDX: dffffc0000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc90004f87250 R08: 0000000000000005 R09: 000000008b838003
R10: ffffc90004f872e0 R11: fffff520009f0e61 R12: ffff888034f30970
R13: 1ffff110069e612e R14: ffff888020170528 R15: ffff888034f302f8
FS:  000055556af3f500(0000) GS:ffff8881a3c1b000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055df3be04900 CR3: 0000000020cc0000 CR4: 0000000000352ef0
----------------
Code disassembly (best guess):
   0:	c1 e8 03             	shr    $0x3,%eax
   3:	80 3c 10 00          	cmpb   $0x0,(%rax,%rdx,1)
   7:	74 12                	je     0x1b
   9:	4c 89 ff             	mov    %r15,%rdi
   c:	e8 9d d8 d4 00       	call   0xd4d8ae
  11:	48 ba 00 00 00 00 00 	movabs $0xdffffc0000000000,%rdx
  18:	fc ff df
  1b:	bb 9c 00 00 00       	mov    $0x9c,%ebx
  20:	49 03 1f             	add    (%r15),%rbx
  23:	48 89 d8             	mov    %rbx,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax <-- trapping instruction
  2e:	84 c0                	test   %al,%al
  30:	0f 85 c2 00 00 00    	jne    0xf8
  36:	80 3b 00             	cmpb   $0x0,(%rbx)
  39:	74 2e                	je     0x69
  3b:	e8 4e 6a 71 00       	call   0x716a8e


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

