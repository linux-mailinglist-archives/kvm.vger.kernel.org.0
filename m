Return-Path: <kvm+bounces-48520-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BED50ACEFFF
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 15:08:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 755553A6E1A
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 13:08:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24BB3227563;
	Thu,  5 Jun 2025 13:08:32 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f78.google.com (mail-io1-f78.google.com [209.85.166.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A810218E91
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 13:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749128911; cv=none; b=KJFWjhl996qgSf7Jc3QJItgStUQxs50iAPH6jYZZNnjox0tgoYOsOm8NS8UrhG1mtFeaFdfA+jNUXPRjGTkVB3EwDNti3DrjEjQTiA75mxfrBrC7Vo+fpMZU/2Gqm98yf4eomfFwFe/+9v0SAVIWYvqDENdB1AvY3n22tMSxlwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749128911; c=relaxed/simple;
	bh=vt9HhD43TrrOcK31e4IhhugzwN3SKC/96q43JrtkujQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=GkKPzDfBI14o14+xHwQKUDw9VElvLRhQqTxH3jEZlBUjSdxZ25HbkpaxZJEDU3aNMUQPEkYqr/bD+winVwqIR3+3JIzmua8Qudmb5LTnTS5dc+B7I3QaR+GlCWDO3iMTjRuPoDKv6PdGzlhxZATs+4Wo58iSmzCjpogYamj8cTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f78.google.com with SMTP id ca18e2360f4ac-86f4f032308so143016639f.1
        for <kvm@vger.kernel.org>; Thu, 05 Jun 2025 06:08:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749128909; x=1749733709;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=g6RBU6EjTXPAV/bqhmNiKKwd+vDIdIK7JFnpANuXQc8=;
        b=p16XFfAaLAZWjJBk18Bzy0r8LbTEru8SNM7qss/+pPT+Z9xokCSghWEsSXXG+v0Z7d
         m2PgJZAnQoG26zPefjSAwcq1mzix0MqcYceVDxcV/54Sfs1YlSAD7oEumOGSVctcniM3
         Z80BNdsAzd7139bQt0fZJvX2pgszCs15M0ZMj/dhFadQsYUUo9v9NdbF7YMIp9f98yOJ
         tT07VYXca7U67kM15qXnYvSrT+7+a9YLJxnZaJhI5a3+GQK1jNmybYVRAmFdkorWngJC
         4ycMUSZiwQk/JnTs0bBSp/Uk56TGr92ysIZAAha+hMGsKCtghHUXzL0NzAvWuYRRbL0N
         dKWQ==
X-Forwarded-Encrypted: i=1; AJvYcCXopVnNTGK2MkiMyeWWy2Wq9EeekgfuFiNQVnmGiOTNLZxt/RZriNXauw6SpH35XQTPFwU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwmgydFNUW/iivLLvgw6TX92UDWrQR262+Do+cpm5XmfKRm09qv
	dndDnksVKBlnl5YDa6f7owI6BK0zFYgz11UEUpfl5ofeso0O1oopSxWDR0kA27kLpdU77Oecofx
	6IgXmANsfKTCeDu2pzpGQIpqGVjgncq0Hxd3Hm7VtMNvhtvoW1sBTnQlPl+U=
X-Google-Smtp-Source: AGHT+IErwImocwbaaJWyMXwioOAP5AcAqUxG1yIp0kM0pK3D73BzcCoVNM83IqzmDwheA0GoHnWPdTIkzyA2UTysefMfvlGbfy8O
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2148:b0:3dd:babf:9b11 with SMTP id
 e9e14a558f8ab-3ddbedb37dcmr71257325ab.20.1749128909060; Thu, 05 Jun 2025
 06:08:29 -0700 (PDT)
Date: Thu, 05 Jun 2025 06:08:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <684196cd.050a0220.2461cf.001e.GAE@google.com>
Subject: [syzbot] [kvm-x86?] WARNING in kvm_apic_accept_events
From: syzbot <syzbot+b1784a9a955885da51cd@syzkaller.appspotmail.com>
To: bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com, 
	pbonzini@redhat.com, seanjc@google.com, syzkaller-bugs@googlegroups.com, 
	tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    64980441d269 Merge tag 'bpf-fixes' of git://git.kernel.org..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=145b31d4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=73696606574e3967
dashboard link: https://syzkaller.appspot.com/bug?extid=b1784a9a955885da51cd
compiler:       Debian clang version 20.1.6 (++20250514063057+1e4d39e07757-1~exp1~20250514183223.118), Debian LLD 20.1.6
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=110fcc0c580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16340c0c580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/b721c3fbaf59/disk-64980441.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/b28b1e530885/vmlinux-64980441.xz
kernel image: https://storage.googleapis.com/syzbot-assets/5aee07cc8b41/bzImage-64980441.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b1784a9a955885da51cd@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 5841 at arch/x86/kvm/lapic.c:3407 kvm_apic_accept_events+0x341/0x490 arch/x86/kvm/lapic.c:3407
Modules linked in:
CPU: 0 UID: 0 PID: 5841 Comm: syz-executor279 Not tainted 6.15.0-syzkaller-12058-g64980441d269 #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
RIP: 0010:kvm_apic_accept_events+0x341/0x490 arch/x86/kvm/lapic.c:3407
Code: eb 0c e8 62 7b 72 00 eb 05 e8 5b 7b 72 00 45 31 ff 44 89 f8 5b 41 5c 41 5d 41 5e 41 5f 5d e9 16 99 1a 0a cc e8 40 7b 72 00 90 <0f> 0b 90 e9 ec fd ff ff 44 89 f9 80 e1 07 80 c1 03 38 c1 0f 8c 4f
RSP: 0018:ffffc9000433f5c8 EFLAGS: 00010293
RAX: ffffffff814de090 RBX: 0000000000000002 RCX: ffff88802a735a00
RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000000002
RBP: 0000000000000000 R08: 0000000000000000 R09: ffffffff81463863
R10: dffffc0000000000 R11: fffffbfff1f4201f R12: 0000000000000002
R13: dffffc0000000000 R14: ffff888030df4600 R15: ffff888031a682d8
FS:  0000555566bb6380(0000) GS:ffff888125c55000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000002000 CR3: 0000000075360000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 vcpu_block arch/x86/kvm/x86.c:11298 [inline]
 vcpu_run+0x76f/0x6f70 arch/x86/kvm/x86.c:11335
 kvm_arch_vcpu_ioctl_run+0xfc9/0x1940 arch/x86/kvm/x86.c:11656
 kvm_vcpu_ioctl+0x95c/0xe90 virt/kvm/kvm_main.c:4461
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:907 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:893
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fc83ec5e2f9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 c1 17 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff37b1fa98 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 00007fc83ec5e2f9
RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000005
RBP: 0000200000bfe000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fff37b1fac0
R13: 0000200000bff000 R14: 0000000000000004 R15: 0000000000000001
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

