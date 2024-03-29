Return-Path: <kvm+bounces-13050-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C6F63891230
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 04:55:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F2E061C2397B
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 03:55:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C76813A1B7;
	Fri, 29 Mar 2024 03:55:19 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8D4239FDD
	for <kvm@vger.kernel.org>; Fri, 29 Mar 2024 03:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711684519; cv=none; b=iCyf6FoNBKX069Pn9CQjE3yXHFRpVyKbuST9o0bH0LWHKZ/BXysuKjS2E12CJS6i6xlrb8Q/PQfUp2ghG7QArxaJQZMAhuFakoUKDVXa6O9KOoWvQ8/9qrtJLZyu6f85SUB2fbQbOzecmErS7JqDoYAHAtIGKsL4LnSZ0ehtIYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711684519; c=relaxed/simple;
	bh=IPMmmlzrM7ZawDcqp92R57ZioyuqGmOw1ucEO4myUqA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=u/33PmmnnmngBdIIg1c8srpGwUUQHsT/9BjoYjDeGw6egzaygF+xN2xj/31yk3x+VVrMSOgOWZwDmY6r29qZQFXxpPyAQcTc+7mxuilqbgLhRpAVsFrIgkh8rApzDsH8a9xbSm5+RKyekWuk0m9qLCtuJjV70CpPutph5jmPMaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-7cef80a1e5bso153240339f.2
        for <kvm@vger.kernel.org>; Thu, 28 Mar 2024 20:55:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711684517; x=1712289317;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZfhCCWVY4HGV1iMz9lC4m+aLEXu+N03bJF+E2pYJJ5Y=;
        b=JFhY59Sl15npEYAwaqZHpvXUS3TcuOoOPizzHpVlZQgKhDkUVw3Yv6ebksoWdwFgkK
         L0IIEmsqiiuFoShiEARch9OvzMkqYDYwfHtMrg2x4+vjtGKJDWcB8Z2HIAs0iKg0Quca
         tiG9m1pdL8FHO4BwFoKgCHzAtLlz8roosc4Y0GOeY/PpVNn9mK6ToCb3kDyT3WjnVhbK
         m69mXrR9faLpxfBELa8kQI+rxLGebY/bjRN3mQa1z7XIc8L2HcLuXcjsqobG4iMpBxzM
         CUoIZlprlaPYsQXn5/YNXP2yX/bDIUckMhrWVaqG0AnHc9GUiSPSSValmA7SUJnsxgGC
         5Vfw==
X-Forwarded-Encrypted: i=1; AJvYcCUXe40TVdmdIm0OIlSeG2FO9n65ggnCqOwQlwHIHE4gTggVzeayr09nZqWaU/dLtp5LIdwGdu2BNQN1Q61qel0F4mTV
X-Gm-Message-State: AOJu0YxNyJbXy8uE+C5YqzceUmO5tznI8wLp7jUZQOce+r/clNNQMLLA
	xUlHZS4bqljMKEsoecUrEWZct15dYl1MOxqQXWL8p9qWoj16h3Nd4Gd3visRouhHdtFlvjQkkbG
	nFUJTE9l5J68Q3SWrrFEZGQZth3moCwVWmMaD5xsajS2yQBSmV5dQBdU=
X-Google-Smtp-Source: AGHT+IHb+N7h//zx+cgD9ghk4W2yHNz+bzLtDQnOLmqUZo+vFh+y80fr12zhebvNrmeVbpeoPHjl3nm1MIbR1vnkp6yRMDonI6EI
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1785:b0:368:c9e2:b372 with SMTP id
 y5-20020a056e02178500b00368c9e2b372mr65877ilu.0.1711684517044; Thu, 28 Mar
 2024 20:55:17 -0700 (PDT)
Date: Thu, 28 Mar 2024 20:55:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009b38080614c49bdb@google.com>
Subject: [syzbot] [kvm?] WARNING in mmu_free_root_page
From: syzbot <syzbot+dc308fcfcd53f987de73@syzkaller.appspotmail.com>
To: bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com, 
	pbonzini@redhat.com, seanjc@google.com, syzkaller-bugs@googlegroups.com, 
	tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    928a87efa423 Merge tag 'gfs2-v6.8-fix' of git://git.kernel..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=127c0546180000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f64ec427e98bccd7
dashboard link: https://syzkaller.appspot.com/bug?extid=dc308fcfcd53f987de73
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=110481f1180000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=177049a5180000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-928a87ef.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/7979568a5a16/vmlinux-928a87ef.xz
kernel image: https://storage.googleapis.com/syzbot-assets/1bc6e1d480e3/bzImage-928a87ef.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+dc308fcfcd53f987de73@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 5187 at arch/x86/kvm/mmu/mmu.c:3579 mmu_free_root_page+0x36c/0x3f0 arch/x86/kvm/mmu/mmu.c:3579
Modules linked in:
CPU: 0 PID: 5187 Comm: syz-executor400 Not tainted 6.9.0-rc1-syzkaller-00005-g928a87efa423 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:mmu_free_root_page+0x36c/0x3f0 arch/x86/kvm/mmu/mmu.c:3579
Code: 00 49 8d 7d 18 be 01 00 00 00 e8 8f 32 c0 09 31 ff 41 89 c6 89 c6 e8 13 e7 6f 00 45 85 f6 0f 85 5d fe ff ff e8 25 ec 6f 00 90 <0f> 0b 90 e9 4f fe ff ff e8 17 ec 6f 00 90 0f 0b 90 e9 79 fe ff ff
RSP: 0018:ffffc90002fb7700 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff88801e0186c8 RCX: ffffffff811d855d
RDX: ffff888022f9a440 RSI: ffffffff811d856b RDI: 0000000000000005
RBP: ffff888024c50370 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000000 R11: ffffffff938d6090 R12: 1ffff920005f6ee1
R13: ffffc90000fae000 R14: 0000000000000000 R15: 0000000000000001
FS:  00007fe2bd3e76c0(0000) GS:ffff88806b000000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055ccab488ee8 CR3: 000000002d4ee000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 kvm_mmu_free_roots+0x621/0x710 arch/x86/kvm/mmu/mmu.c:3631
 kvm_mmu_unload+0x42/0x150 arch/x86/kvm/mmu/mmu.c:5638
 kvm_mmu_reset_context arch/x86/kvm/mmu/mmu.c:5596 [inline]
 kvm_mmu_after_set_cpuid+0x14d/0x300 arch/x86/kvm/mmu/mmu.c:5585
 kvm_vcpu_after_set_cpuid arch/x86/kvm/cpuid.c:386 [inline]
 kvm_set_cpuid+0x1ff1/0x3570 arch/x86/kvm/cpuid.c:460
 kvm_vcpu_ioctl_set_cpuid2+0xe7/0x160 arch/x86/kvm/cpuid.c:527
 kvm_arch_vcpu_ioctl+0x26b7/0x4310 arch/x86/kvm/x86.c:5946
 kvm_vcpu_ioctl+0xa2c/0x1090 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4620
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:904 [inline]
 __se_sys_ioctl fs/ioctl.c:890 [inline]
 __x64_sys_ioctl+0x193/0x220 fs/ioctl.c:890
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xd2/0x260 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x6d/0x75
RIP: 0033:0x7fe2bd42e06b
Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0 ff ff 77 1c 48 8b 44 24 18 64 48 2b 04 25 28 00 00
RSP: 002b:00007fe2bd3e5710 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007fe2bd3e5de0 RCX: 00007fe2bd42e06b
RDX: 00007fe2bd3e5de0 RSI: 000000004008ae90 RDI: 0000000000000006
RBP: 0000000000000000 R08: 0000000000000007 R09: 00000000000000eb
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000080
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000006
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

