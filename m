Return-Path: <kvm+bounces-68322-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DE2D5D331D4
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 16:15:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E37DB3165227
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 15:08:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AAE8339709;
	Fri, 16 Jan 2026 15:08:29 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f78.google.com (mail-oo1-f78.google.com [209.85.161.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59E5F2248A0
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 15:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768576108; cv=none; b=NWKJnz6sOzusHKL8eNAGAat+pkIdMRobPC5ZLvGdXgGHNfGLzQHsjSVACeX/yqxq2sc9HbvGG0HC/Ar5btZx8xOVIz2nTw9G5vuE+kDYjHIjvUmKldso4myEgHFGiDys0M9o49T3nk5sM5vGdxLhCkTuLDsu4Iq+Dj/RLMLopkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768576108; c=relaxed/simple;
	bh=QHCCmEOoBzte3q9XY4I1SFPAtCOcoe5X79AiBhfHCrI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=dVVDpXPbrB1UFGYeor4reQlJaRtNDMqmcbmIdz+nBpgoUAKLa/l0ZhfIh4Vj7EOMoZx0vI5VbvbPZkA+MOghdIZnu1L9r1QeEOJ2D6kv3+WPRJJzyhu2uJqQL3qBUbpkmrFMn7nDobqOpccvwc56kEmFhIyfm11DslTfD7VaHt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f78.google.com with SMTP id 006d021491bc7-661066bdfb9so5699933eaf.1
        for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 07:08:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768576106; x=1769180906;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X/LezpceeHMMjHuaLAScBWOUUdz81LThdVaEz3+rGqs=;
        b=U4XPj4fV1DUvNQ/b8+1AmSJ1WR2p41X9/75rw9DCaLJ24nqH/MOAEseNmcm5/Kf8l4
         byfZLFmfR8JoaLLnlIWBtyCow06HnU8RvJv7Y9QLSkGV2hqcFmaNq4wJZYJdCP7/O5UO
         QxUw9h8YHWIfG7soCzC9Cw/DE7h+Murlhyz2bDNkEAqqDNIXY1R/KYYSjDjgDpeZbHvb
         9mNOAzDDF4FFFyFlNQyOfuJerpQUbpIbfhfsj2UXZI+MioXXwFULDPoP+LlhR8owewa4
         j5GDMNuclukJxy1S97yfG3J068pBS51Z80mi4Z7F8DlGhr+xwUk1jdHP6azoOxVslxvL
         zIqA==
X-Gm-Message-State: AOJu0YwILYx/aJ+FQLjfCSoZRLPaAU2v6w/mp/jzWDijkLwQRMhC9mq7
	BY4GPtL4gk1dLYBVmwdBLZ4n4U4TA21/oMJNvlgPB7D7ix/EmwZ4OR2AgZvzj07L5l3dHVvEFJR
	MsxhQOQSSCpudJAABMo5XUGNMRiWoruQ83zHO40Gp/TKRLl5VUMKRUEdwFPi2nQ==
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4def:b0:65b:2a82:d700 with SMTP id
 006d021491bc7-661179b64e5mr1501129eaf.44.1768576106248; Fri, 16 Jan 2026
 07:08:26 -0800 (PST)
Date: Fri, 16 Jan 2026 07:08:26 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <696a546a.050a0220.58bed.0056.GAE@google.com>
Subject: [syzbot] [kvm?] BUG: unable to handle kernel paging request in kvm_gmem_get_folio
From: syzbot <syzbot+6f16df7b5a49f0e01b18@syzkaller.appspotmail.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    9b7977f9e39b Add linux-next specific files for 20260115
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=10585522580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9c0b39f55c418575
dashboard link: https://syzkaller.appspot.com/bug?extid=6f16df7b5a49f0e01b18
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/32edced7b806/disk-9b7977f9.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/dec5450e284a/vmlinux-9b7977f9.xz
kernel image: https://storage.googleapis.com/syzbot-assets/65783c99fb65/bzImage-9b7977f9.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6f16df7b5a49f0e01b18@syzkaller.appspotmail.com

BUG: unable to handle page fault for address: fffffffffffffffc
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD e143067 P4D e143067 PUD e145067 PMD 0 
Oops: Oops: 0000 [#1] SMP KASAN PTI
CPU: 0 UID: 0 PID: 10212 Comm: syz.7.1148 Tainted: G             L      syzkaller #0 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
RIP: 0010:const_folio_flags include/linux/page-flags.h:351 [inline]
RIP: 0010:folio_test_head include/linux/page-flags.h:844 [inline]
RIP: 0010:folio_test_large include/linux/page-flags.h:865 [inline]
RIP: 0010:folio_order include/linux/mm.h:1248 [inline]
RIP: 0010:kvm_gmem_get_folio+0x12e/0x240 virt/kvm/guest_memfd.c:147
Code: 00 eb 0d e8 a4 85 80 00 4c 89 f7 e8 6c bc e3 00 4c 8d 73 08 4c 89 f0 48 c1 e8 03 42 80 3c 28 00 74 08 4c 89 f7 e8 b2 5a e7 00 <4d> 8b 36 4c 89 f6 48 83 e6 01 31 ff e8 51 8a 80 00 49 83 e6 01 0f
RSP: 0018:ffffc900031a7cc8 EFLAGS: 00010246
RAX: 1fffffffffffffff RBX: fffffffffffffff4 RCX: 0000000000080000
RDX: ffffc90013fee000 RSI: 000000000007ffff RDI: 0000000000080000
RBP: 1ffff1100d33380f R08: ffff8880b8640dc3 R09: 1ffff110170c81b8
R10: dffffc0000000000 R11: ffffed10170c81b9 R12: ffff88806999c078
R13: dffffc0000000000 R14: fffffffffffffffc R15: 0000000000111e97
FS:  00007fc8a8bb26c0(0000) GS:ffff8881259ad000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffffffffffffc CR3: 000000007db00000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000001
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 kvm_gmem_allocate virt/kvm/guest_memfd.c:276 [inline]
 kvm_gmem_fallocate+0x396/0x840 virt/kvm/guest_memfd.c:316
 vfs_fallocate+0x669/0x7e0 fs/open.c:340
 ksys_fallocate fs/open.c:364 [inline]
 __do_sys_fallocate fs/open.c:369 [inline]
 __se_sys_fallocate fs/open.c:367 [inline]
 __x64_sys_fallocate+0xc0/0x110 fs/open.c:367
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xec/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fc8a7d8f749
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fc8a8bb2038 EFLAGS: 00000246 ORIG_RAX: 000000000000011d
RAX: ffffffffffffffda RBX: 00007fc8a7fe6090 RCX: 00007fc8a7d8f749
RDX: 0000000100000000 RSI: 0000000000000001 RDI: 0000000000000007
RBP: 00007fc8a7e13f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000080000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fc8a7fe6128 R14: 00007fc8a7fe6090 R15: 00007ffeb4d2dde8
 </TASK>
Modules linked in:
CR2: fffffffffffffffc
---[ end trace 0000000000000000 ]---
RIP: 0010:const_folio_flags include/linux/page-flags.h:351 [inline]
RIP: 0010:folio_test_head include/linux/page-flags.h:844 [inline]
RIP: 0010:folio_test_large include/linux/page-flags.h:865 [inline]
RIP: 0010:folio_order include/linux/mm.h:1248 [inline]
RIP: 0010:kvm_gmem_get_folio+0x12e/0x240 virt/kvm/guest_memfd.c:147
Code: 00 eb 0d e8 a4 85 80 00 4c 89 f7 e8 6c bc e3 00 4c 8d 73 08 4c 89 f0 48 c1 e8 03 42 80 3c 28 00 74 08 4c 89 f7 e8 b2 5a e7 00 <4d> 8b 36 4c 89 f6 48 83 e6 01 31 ff e8 51 8a 80 00 49 83 e6 01 0f
RSP: 0018:ffffc900031a7cc8 EFLAGS: 00010246
RAX: 1fffffffffffffff RBX: fffffffffffffff4 RCX: 0000000000080000
RDX: ffffc90013fee000 RSI: 000000000007ffff RDI: 0000000000080000
RBP: 1ffff1100d33380f R08: ffff8880b8640dc3 R09: 1ffff110170c81b8
R10: dffffc0000000000 R11: ffffed10170c81b9 R12: ffff88806999c078
R13: dffffc0000000000 R14: fffffffffffffffc R15: 0000000000111e97
FS:  00007fc8a8bb26c0(0000) GS:ffff8881259ad000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffffffffffffc CR3: 000000007db00000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000001
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	00 eb                	add    %ch,%bl
   2:	0d e8 a4 85 80       	or     $0x8085a4e8,%eax
   7:	00 4c 89 f7          	add    %cl,-0x9(%rcx,%rcx,4)
   b:	e8 6c bc e3 00       	call   0xe3bc7c
  10:	4c 8d 73 08          	lea    0x8(%rbx),%r14
  14:	4c 89 f0             	mov    %r14,%rax
  17:	48 c1 e8 03          	shr    $0x3,%rax
  1b:	42 80 3c 28 00       	cmpb   $0x0,(%rax,%r13,1)
  20:	74 08                	je     0x2a
  22:	4c 89 f7             	mov    %r14,%rdi
  25:	e8 b2 5a e7 00       	call   0xe75adc
* 2a:	4d 8b 36             	mov    (%r14),%r14 <-- trapping instruction
  2d:	4c 89 f6             	mov    %r14,%rsi
  30:	48 83 e6 01          	and    $0x1,%rsi
  34:	31 ff                	xor    %edi,%edi
  36:	e8 51 8a 80 00       	call   0x808a8c
  3b:	49 83 e6 01          	and    $0x1,%r14
  3f:	0f                   	.byte 0xf


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

