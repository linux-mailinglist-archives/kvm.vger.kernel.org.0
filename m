Return-Path: <kvm+bounces-22059-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 18B2F939105
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 16:53:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8B3DE1F21FD2
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 14:53:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68D4016DC2E;
	Mon, 22 Jul 2024 14:53:30 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588D216D339
	for <kvm@vger.kernel.org>; Mon, 22 Jul 2024 14:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721660009; cv=none; b=n8i+lZPrlyHn9dRo++QayS5VOAEvzEFOTPOsLCTh9trK47hwUDpPYK/SyBAuKAQnaMzY8z95z9QOVu7bLjOFbKEtTWgucqSAwSfdTBjHpiObIFckVW6jbvUTYpv9dIiCMxvuQqmui4Q/aP3TrbOQ17xWTUZ25ZoxYlA0RRPCwYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721660009; c=relaxed/simple;
	bh=sXM+EnPkkwWT4eEFDw6EWeXxACgQrb2zOFY9i9EnJz4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=UsLbgf0ywC4YoCoDwqvTrYHCy8VHFlHHZR7wDJraiSrau1rw9u56Lq/jtx6EvzdSHRcCCfnNJl/IJ2DgFKUB2jOHZBhGFypP+a+xmjYPO4b0Lq6yeg7WvziVGRxucWmZ+VnEmUaz8OyoBjlbLuH0vSIlsjyUhyKRoD9IVKiy1rA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3983ed13f0bso47439175ab.2
        for <kvm@vger.kernel.org>; Mon, 22 Jul 2024 07:53:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721660007; x=1722264807;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=y17J8imGi7iRmB7lYAoQiD2t5PpJd8kzmiPCYBp0DhM=;
        b=RswarDyVHuDFmVtqIwkyixp7e3vzuQOyW8IqNCMiWSIC9YA3VGwRrYSRRRi01lzJ+v
         vuuyIxZ9aw0Cd9I8VQT+TWs3IJXdkQZvww99Esvw0LG4sxxzYLUNWEqm4m748z/ZBbXo
         i7C8kUKnsOkq6GoyhPvRh29zLA9m2S4AJRAnEDuIONsKksHPXdVyND5jesj6vnaG8BbZ
         ZRmXqhjI6EdvYddBD0VVrujQUivCEGzMDEbdHb8JFiKKrwpSRIdxcziD5Sb6CKDmKmm3
         ypn7W8lZXkoNfqUCCy7/kpA3EaVb+82DzDUsftow8DSCky+12Oho1uD9wu1t5S3Fu5u4
         5mwA==
X-Forwarded-Encrypted: i=1; AJvYcCX+wlP9s0hh000ra6NV5LZCi/p40j5glz9wCPvbbpVHQGL8tKad9/ZUnTl1Zj2xOptt9Q+27zuWjE+ca6zUDi1M1eCL
X-Gm-Message-State: AOJu0Yzj1h4zIPOevCSwzQakj7NdpioLtoeZ3zv3W6SwGg4UCUJ/JoG4
	QLncxP1ygYuCwok65C9a3ZhjA+hlyRkTVI9Z/El13bwKdOjncNu7wcyUBLIpPHzgBO7DYLRF5p8
	Ulef/kHQ/mJUw/JEqDMW/u6XeqS33nWcmRrmjBY9a9BaApP/jIBQMhH0=
X-Google-Smtp-Source: AGHT+IHnki3nytThvNNU63jQ2vC+LUBakJI8Te5h1stWnIzCQvWX1lb/U7nRUjxDYSLpGO6ESrhNZKVX9E1b+d7bfo/ThQp2S2v5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1d9d:b0:396:ec3b:df65 with SMTP id
 e9e14a558f8ab-398e753ce0bmr6675165ab.4.1721660007478; Mon, 22 Jul 2024
 07:53:27 -0700 (PDT)
Date: Mon, 22 Jul 2024 07:53:27 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002b84dc061dd73544@google.com>
Subject: [syzbot] [kvm?] general protection fault in is_page_fault_stale
From: syzbot <syzbot+23786faffb695f17edaa@syzkaller.appspotmail.com>
To: bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com, 
	pbonzini@redhat.com, seanjc@google.com, syzkaller-bugs@googlegroups.com, 
	tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    2c9b3512402e Merge tag 'for-linus' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17abcfe9980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e322acd9c27a6b84
dashboard link: https://syzkaller.appspot.com/bug?extid=23786faffb695f17edaa
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/c112a5c3b199/disk-2c9b3512.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/d0dae74e61d2/vmlinux-2c9b3512.xz
kernel image: https://storage.googleapis.com/syzbot-assets/54648874d89c/bzImage-2c9b3512.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+23786faffb695f17edaa@syzkaller.appspotmail.com

RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000206 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
Oops: general protection fault, probably for non-canonical address 0xe000013ffffffffd: 0000 [#1] PREEMPT SMP KASAN PTI
KASAN: maybe wild-memory-access in range [0x000029ffffffffe8-0x000029ffffffffef]
CPU: 0 PID: 11829 Comm: syz.1.1799 Not tainted 6.10.0-syzkaller-11185-g2c9b3512402e #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/27/2024
RIP: 0010:to_shadow_page arch/x86/kvm/mmu/spte.h:245 [inline]
RIP: 0010:spte_to_child_sp arch/x86/kvm/mmu/spte.h:250 [inline]
RIP: 0010:root_to_sp arch/x86/kvm/mmu/spte.h:267 [inline]
RIP: 0010:is_page_fault_stale+0xc4/0x530 arch/x86/kvm/mmu/mmu.c:4517
Code: e9 00 01 00 00 48 b8 ff ff ff ff ff 00 00 00 48 21 c3 48 c1 e3 06 49 bc 28 00 00 00 00 ea ff ff 49 01 dc 4c 89 e0 48 c1 e8 03 <42> 80 3c 28 00 74 08 4c 89 e7 e8 6d b7 d8 00 4d 8b 2c 24 31 ff 4c
RSP: 0018:ffffc9000fc6f6f0 EFLAGS: 00010202
RAX: 0000053ffffffffd RBX: 00003fffffffffc0 RCX: ffff88806a8bda00
RDX: 0000000000000000 RSI: 000fffffffffffff RDI: 00000000000129d3
RBP: 00000000000129d3 R08: ffffffff8120c8e0 R09: 1ffff920005e6c00
R10: dffffc0000000000 R11: fffff520005e6c01 R12: 000029ffffffffe8
R13: dffffc0000000000 R14: ffffc9000fc6f800 R15: ffff88807cbed000
FS:  0000000000000000(0000) GS:ffff8880b9400000(0063) knlGS:00000000f5d46b40
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 00000000576d24c0 CR3: 000000007d930000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 kvm_tdp_mmu_page_fault arch/x86/kvm/mmu/mmu.c:4662 [inline]
 kvm_tdp_page_fault+0x25c/0x320 arch/x86/kvm/mmu/mmu.c:4693
 kvm_mmu_do_page_fault+0x589/0xca0 arch/x86/kvm/mmu/mmu_internal.h:323
 kvm_tdp_map_page arch/x86/kvm/mmu/mmu.c:4715 [inline]
 kvm_arch_vcpu_pre_fault_memory+0x2db/0x5a0 arch/x86/kvm/mmu/mmu.c:4760
 kvm_vcpu_pre_fault_memory+0x24c/0x4b0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4418
 kvm_vcpu_ioctl+0xa47/0xea0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4648
 kvm_vcpu_compat_ioctl+0x242/0x450 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4700
 __do_compat_sys_ioctl fs/ioctl.c:1007 [inline]
 __se_compat_sys_ioctl+0x51c/0xca0 fs/ioctl.c:950
 do_syscall_32_irqs_on arch/x86/entry/common.c:165 [inline]
 __do_fast_syscall_32+0xb4/0x110 arch/x86/entry/common.c:386
 do_fast_syscall_32+0x34/0x80 arch/x86/entry/common.c:411
 entry_SYSENTER_compat_after_hwframe+0x84/0x8e
RIP: 0023:0xf7f92579
Code: b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 00 00 00 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 002b:00000000f5d4656c EFLAGS: 00000206 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 0000000000000006 RCX: 00000000c040aed5
RDX: 0000000020000040 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000206 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:to_shadow_page arch/x86/kvm/mmu/spte.h:245 [inline]
RIP: 0010:spte_to_child_sp arch/x86/kvm/mmu/spte.h:250 [inline]
RIP: 0010:root_to_sp arch/x86/kvm/mmu/spte.h:267 [inline]
RIP: 0010:is_page_fault_stale+0xc4/0x530 arch/x86/kvm/mmu/mmu.c:4517
Code: e9 00 01 00 00 48 b8 ff ff ff ff ff 00 00 00 48 21 c3 48 c1 e3 06 49 bc 28 00 00 00 00 ea ff ff 49 01 dc 4c 89 e0 48 c1 e8 03 <42> 80 3c 28 00 74 08 4c 89 e7 e8 6d b7 d8 00 4d 8b 2c 24 31 ff 4c
RSP: 0018:ffffc9000fc6f6f0 EFLAGS: 00010202
RAX: 0000053ffffffffd RBX: 00003fffffffffc0 RCX: ffff88806a8bda00
RDX: 0000000000000000 RSI: 000fffffffffffff RDI: 00000000000129d3
RBP: 00000000000129d3 R08: ffffffff8120c8e0 R09: 1ffff920005e6c00
R10: dffffc0000000000 R11: fffff520005e6c01 R12: 000029ffffffffe8
R13: dffffc0000000000 R14: ffffc9000fc6f800 R15: ffff88807cbed000
FS:  0000000000000000(0000) GS:ffff8880b9400000(0063) knlGS:00000000f5d46b40
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 00000000576d24c0 CR3: 000000007d930000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	e9 00 01 00 00       	jmp    0x105
   5:	48 b8 ff ff ff ff ff 	movabs $0xffffffffff,%rax
   c:	00 00 00
   f:	48 21 c3             	and    %rax,%rbx
  12:	48 c1 e3 06          	shl    $0x6,%rbx
  16:	49 bc 28 00 00 00 00 	movabs $0xffffea0000000028,%r12
  1d:	ea ff ff
  20:	49 01 dc             	add    %rbx,%r12
  23:	4c 89 e0             	mov    %r12,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 80 3c 28 00       	cmpb   $0x0,(%rax,%r13,1) <-- trapping instruction
  2f:	74 08                	je     0x39
  31:	4c 89 e7             	mov    %r12,%rdi
  34:	e8 6d b7 d8 00       	call   0xd8b7a6
  39:	4d 8b 2c 24          	mov    (%r12),%r13
  3d:	31 ff                	xor    %edi,%edi
  3f:	4c                   	rex.WR


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

