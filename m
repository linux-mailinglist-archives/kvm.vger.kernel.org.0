Return-Path: <kvm+bounces-11704-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CE30879FB3
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 00:34:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 924EB1F225B0
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 23:34:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A897F47F5D;
	Tue, 12 Mar 2024 23:34:20 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA1B26286
	for <kvm@vger.kernel.org>; Tue, 12 Mar 2024 23:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710286460; cv=none; b=Jbarmfdy/mTtLIgHQ/ewZSe3coAvuh6TmAWxibTPclqAu/SiYpIhIReyJ84aXeAlECIuklf+NHO6r5T6WxdDtqm2P3SrP57hbYQBPB14hh0KmITznquvr0Drc0UHxBitxXmcuSvSFPSnq/UW48MfqToqNAvPAY8DwX7TMPmYoJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710286460; c=relaxed/simple;
	bh=V7syQIGbhXqZa7yG7MS9Fg5zwZhxVP5/3Hh9+AgrMrw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=JVZriRf1L8dh8q8ROsm8ra6QNu41LTVxBzgJYaObHQO6b2q0GPuAfztGjdDyP506pvYGxDug2pNWr1eJ409eDxuP68oECdTr+sFmlSDrYmoHjHynrfsu3Ws041YX6XRQYIQFoZlY3XA7N928BQLnfZnKHl8Rp/QiA/i/BCZtoCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-7c8b8a6f712so225060839f.1
        for <kvm@vger.kernel.org>; Tue, 12 Mar 2024 16:34:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710286457; x=1710891257;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eEWH2f4pPeXnjbOWATLfxyixb6PBlvjcil5UWl1vltk=;
        b=AHYW1qz3sJY/sK+Strb2U0Lz8HZq3ZtUcSQm/nmuDYPEsK5tsH1G3s1FBNJtoTvnvJ
         JlOPTuxJAkfYCz2W7S5g/NkCc+/2ve50wprHX5b6WX2RoT1GmG1YTPjG7XOiXuaejw8X
         2zehTWhhIVaeQa8MJw1BdqL+8+v5rWc6xRSYpcF5e1eHBpNMLMBOyVbgtk/iUDrBBSoE
         V1I8fs2NWkaDprp+IJcP+8wbOetftn3f/TC0TJx+Mq/Xp9iLUmzBtOQAtf75NcgfXpPF
         DYVHIn/sdbPjp8x8BbXR3FBemJ/QJYdkRMSk1GnfcB+IpUFn7ix/XIo2rx965Byrsp1A
         Ijqw==
X-Forwarded-Encrypted: i=1; AJvYcCV9RI6V/S+IIaIv2K5MtWYrb2rMty8Xg7lh7LiTJ+daFlfeEi6iJPhfiqtSEvmjJyDG2/RnMqElEjndVK4zAaNB7/Az
X-Gm-Message-State: AOJu0Yw2HvJEgLwpfAyBlNQdqMPc/kxM3fc7X4osQYtXQN6OCYlyYerM
	ra38eOH1gmFZ20UsLX6mFI4edmR3QALN/Hu6yc6QKALIQPIQnatPZMfATwC+YRpdvHvx1bqTd48
	hCnnRB0YbxzFY6M9pK4s4ofkJRX4oZXXsHzO5D3aDrjaCG2PnhTMm1rM=
X-Google-Smtp-Source: AGHT+IEqGWfgtwFpTAfKiDt4Erh4fadFZ7nx728ouYTYhgElBrXaqg1LSv7ie0il63xWcclz5E5mIzkOOC89nVZPpFKMAvNw3s+u
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:1696:b0:7c8:afc3:3f70 with SMTP id
 s22-20020a056602169600b007c8afc33f70mr326799iow.4.1710286457683; Tue, 12 Mar
 2024 16:34:17 -0700 (PDT)
Date: Tue, 12 Mar 2024 16:34:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c6526f06137f18cc@google.com>
Subject: [syzbot] [kvm?] WARNING in clear_dirty_gfn_range
From: syzbot <syzbot+900d58a45dcaab9e4821@syzkaller.appspotmail.com>
To: bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com, 
	pbonzini@redhat.com, seanjc@google.com, syzkaller-bugs@googlegroups.com, 
	tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    855684c7d938 Merge tag 'x86_tdx_for_6.9' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11776f71180000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9b384ef2b2d70c33
dashboard link: https://syzkaller.appspot.com/bug?extid=900d58a45dcaab9e4821
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1536da66180000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14c5078e180000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-855684c7.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/a13a9aaebd09/vmlinux-855684c7.xz
kernel image: https://storage.googleapis.com/syzbot-assets/acac43529544/bzImage-855684c7.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+900d58a45dcaab9e4821@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 5165 at arch/x86/kvm/mmu/tdp_mmu.c:1526 clear_dirty_gfn_range+0x3d6/0x540 arch/x86/kvm/mmu/tdp_mmu.c:1526
Modules linked in:
CPU: 1 PID: 5165 Comm: syz-executor417 Not tainted 6.8.0-syzkaller-01185-g855684c7d938 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:clear_dirty_gfn_range+0x3d6/0x540 arch/x86/kvm/mmu/tdp_mmu.c:1526
Code: 00 31 ff 48 b8 00 00 00 00 00 00 30 00 48 21 d8 49 89 c5 48 89 c6 e8 e9 9c 6c 00 4d 85 ed 0f 84 b8 fe ff ff e8 cb a1 6c 00 90 <0f> 0b 90 e9 aa fe ff ff e8 bd a1 6c 00 e8 a8 39 53 00 31 ff 89 c6
RSP: 0018:ffffc900039a7570 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 06200000310acb77 RCX: ffffffff81204937
RDX: ffff888022a8c880 RSI: ffffffff81204945 RDI: 0000000000000007
RBP: 0000000000000001 R08: 0000000000000007 R09: 0000000000000000
R10: 0020000000000000 R11: 0000000000000002 R12: ffffc900039a75c8
R13: 0020000000000000 R14: 0000000000000200 R15: 0000000000000001
FS:  000055556ed44380(0000) GS:ffff88806b300000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 0000000027762000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 kvm_tdp_mmu_clear_dirty_slot+0x24f/0x2e0 arch/x86/kvm/mmu/tdp_mmu.c:1557
 kvm_mmu_slot_leaf_clear_dirty+0x38b/0x490 arch/x86/kvm/mmu/mmu.c:6783
 kvm_mmu_slot_apply_flags arch/x86/kvm/x86.c:12962 [inline]
 kvm_arch_commit_memory_region+0x299/0x490 arch/x86/kvm/x86.c:13031
 kvm_commit_memory_region arch/x86/kvm/../../../virt/kvm/kvm_main.c:1751 [inline]
 kvm_set_memslot+0x4d3/0x13e0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:1994
 __kvm_set_memory_region arch/x86/kvm/../../../virt/kvm/kvm_main.c:2129 [inline]
 __kvm_set_memory_region+0xdbc/0x1520 arch/x86/kvm/../../../virt/kvm/kvm_main.c:2020
 kvm_set_memory_region arch/x86/kvm/../../../virt/kvm/kvm_main.c:2150 [inline]
 kvm_vm_ioctl_set_memory_region arch/x86/kvm/../../../virt/kvm/kvm_main.c:2162 [inline]
 kvm_vm_ioctl+0x151c/0x3e20 arch/x86/kvm/../../../virt/kvm/kvm_main.c:5152
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:904 [inline]
 __se_sys_ioctl fs/ioctl.c:890 [inline]
 __x64_sys_ioctl+0x193/0x220 fs/ioctl.c:890
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xd2/0x260 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x6d/0x75
RIP: 0033:0x7f4e1b1860f9
Code: 48 83 c4 28 c3 e8 37 17 00 00 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffdd21061f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007ffdd21063c8 RCX: 00007f4e1b1860f9
RDX: 0000000020000180 RSI: 000000004020ae46 RDI: 0000000000000004
RBP: 00007f4e1b1f9610 R08: 00007ffdd21063c8 R09: 00007ffdd21063c8
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
R13: 00007ffdd21063b8 R14: 0000000000000001 R15: 0000000000000001
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

