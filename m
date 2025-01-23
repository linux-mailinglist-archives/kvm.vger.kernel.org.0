Return-Path: <kvm+bounces-36386-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 67225A1A65D
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 15:57:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0E3FC188931A
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 14:57:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 894DA211A1F;
	Thu, 23 Jan 2025 14:57:28 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D7D72116F8
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 14:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737644248; cv=none; b=t14fJN2F5HUSe6mopY8b6diNgYv16aV5BNHk2rQ4eI0L0ihmPZ8EOtu/TzfKEI3L4/DjAApQjbbc5ntRH7BGb5eIfkE6NEULamY6fohm0HO3kxNz2fd3Lv6Mj0Ub/ejtQ6MrpGLhEPnlhsX+nL4YJTdEH7UkfDKnxy2Six6GMFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737644248; c=relaxed/simple;
	bh=fTZJUqNlLAPc9pkjyRGCHYO7ddQj8V2OMB2Uz4GvzRw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=oM9kWwb99JQHe/p+rlFiqxC5bBeWqN4zc4emVY1UdTeYS8eRzLMZCjOrZgi8ZiXmN6WQiFby5k/TubeR9hyffimaitsF6bXS5yGCCwVyb1K/zEDfLCNduvzyNu8ZBzv6k2mb/fvhqx8JmAt0PXWkG4WDZe/UkWeuIC33sbEyBjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3ce7a0ec1easo6042665ab.0
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 06:57:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737644245; x=1738249045;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sjuCHk3cPJJKbPfJoSuHlqOyDip86LFpntpwDG2Tqqs=;
        b=OdyHt/Ulp5TgzoP4v3AxRVoCRIpO+I4apg9Au8Q1anFIjjiMd0j2OA9GGHxZOvJ+Lf
         hZDh5bZCa0Hz07eDAxSm+P+gHwzWpoegHJL+27RmywzJGd+TgwMJbXTKaq6HeCmQW9fS
         VkGL3Ded9oTgwSQNe/fAKF/LvIh7RB8He5bIQZ1oEgFZ9k/voA42Shkxz294InIXQnwK
         gJmKgksxv8Pjq1c59PBVp3oaol+EWzAmT6McY5eignPUWjYFaVTxz5oUfydSpXUXzxEo
         LO3yB6Y0ipluZhwlg7ulC2oMV8t0Afof+scfFKfXe0vuPwVPvBPwP/B4wS+lxKoOLD98
         +e7A==
X-Gm-Message-State: AOJu0YyKjgxsu31eViFJkHw+VxP5IVyrtE8RFb6LyBft0oQxpsv7dEr7
	Kzu+XqhlXWATJIhX/FPhNpzmGvVT4W0KUYNtuCz/l+9NUDiQCrILlI1yOn5hdqmwx34MvcZgHEp
	nB76V2lav+5fSJCemLnYNOQa6OHM/c4fpHh/76MJ5ftjxzgK2vYHorh8UpA==
X-Google-Smtp-Source: AGHT+IHWLkyfFCQWskam3uUwmD2hoz5Qzs9kx9zV6bEZEIwvQxTB/p3y2+5Twyk/F7RLhst1A0/5xTGsslhJBR1XfKKxOPDkT+1v
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1fc1:b0:3cf:b7c0:8819 with SMTP id
 e9e14a558f8ab-3cfb7c08acfmr41500115ab.9.1737644244103; Thu, 23 Jan 2025
 06:57:24 -0800 (PST)
Date: Thu, 23 Jan 2025 06:57:24 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <679258d4.050a0220.2eae65.000a.GAE@google.com>
Subject: [syzbot] [kvm?] WARNING: suspicious RCU usage in kvm_vcpu_gfn_to_memslot
From: syzbot <syzbot+cdeaeec70992eca2d920@syzkaller.appspotmail.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    95ec54a420b8 Merge tag 'powerpc-6.14-1' of git://git.kerne..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15ff45df980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f27a9722e53abeaa
dashboard link: https://syzkaller.appspot.com/bug?extid=cdeaeec70992eca2d920
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=133ed618580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=110449f8580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-95ec54a4.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/06bc523d1d96/vmlinux-95ec54a4.xz
kernel image: https://storage.googleapis.com/syzbot-assets/c0b342c3e200/bzImage-95ec54a4.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cdeaeec70992eca2d920@syzkaller.appspotmail.com

=============================
WARNING: suspicious RCU usage
6.13.0-syzkaller-00918-g95ec54a420b8 #0 Not tainted
-----------------------------
./include/linux/kvm_host.h:1038 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 1
no locks held by syz-executor167/5303.

stack backtrace:
CPU: 0 UID: 0 PID: 5303 Comm: syz-executor167 Not tainted 6.13.0-syzkaller-00918-g95ec54a420b8 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 lockdep_rcu_suspicious+0x226/0x340 kernel/locking/lockdep.c:6845
 __kvm_memslots include/linux/kvm_host.h:1036 [inline]
 kvm_vcpu_memslots include/linux/kvm_host.h:1050 [inline]
 kvm_vcpu_gfn_to_memslot+0x429/0x4c0 virt/kvm/kvm_main.c:2554
 kvm_vcpu_write_guest_page virt/kvm/kvm_main.c:3238 [inline]
 kvm_vcpu_write_guest+0x7c/0x130 virt/kvm/kvm_main.c:3274
 kvm_xen_write_hypercall_page+0x2ff/0x5f0 arch/x86/kvm/xen.c:1299
 kvm_set_msr_common+0x150/0x3da0 arch/x86/kvm/x86.c:3751
 vmx_set_msr+0x15da/0x2790 arch/x86/kvm/vmx/vmx.c:2487
 __kvm_set_msr arch/x86/kvm/x86.c:1877 [inline]
 kvm_vcpu_reset+0xbea/0x1740 arch/x86/kvm/x86.c:12456
 kvm_arch_vcpu_create+0x8dc/0xa80 arch/x86/kvm/x86.c:12305
 kvm_vm_ioctl_create_vcpu+0x3d6/0xa00 virt/kvm/kvm_main.c:4106
 kvm_vm_ioctl+0x7e2/0xd30 virt/kvm/kvm_main.c:5019
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:906 [inline]
 __se_sys_ioctl+0xf5/0x170 fs/ioctl.c:892
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f9a62a26369
Code: 48 83 c4 28 c3 e8 37 17 00 00 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff83b20f38 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007fff83b21108 RCX: 00007f9a62a26369
RDX: 0000000000000000 RSI: 000000000000ae41 RDI: 0000000000000004
RBP: 00007f9a62a99610 R08: 00007fff83b21108 R09: 00007fff83b21108
R10: 00007fff83b21108 R11: 0000000000000246 R12: 0000000000000001
R13: 00007fff83b210f8 R14: 0000000000000001 R15: 0000000000000001
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

