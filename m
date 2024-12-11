Return-Path: <kvm+bounces-33483-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E20239ECCEC
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 14:12:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6E0EB188AB8F
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 13:12:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AC97229142;
	Wed, 11 Dec 2024 13:12:28 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f78.google.com (mail-io1-f78.google.com [209.85.166.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E7C723FD23
	for <kvm@vger.kernel.org>; Wed, 11 Dec 2024 13:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733922747; cv=none; b=nuN5SUAgJlI5WofusOYM4+OC4o8So2FUdoHTOsBSWbTWBmbaxaCbZwz7rJBubgjfhY6I1UZMFC71LNIh8a4Xv5+Y2Qbm+gFMu8MZ1sEac8lgGj01m2Ak+jpZ5X9nlcAD2N2ekRfNuPmpPi/AVOk3TrS1twqzpB4LrPzSKW+LByg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733922747; c=relaxed/simple;
	bh=mguMlBcjhwqS366cATFtm5v705RYQobf8ix5KkB3jzM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=ZpA+aePk2TRh/M9tQN+JDGYIuVMtOWXN51XC6Ek0ck9TrHr9JkYWf94p2Q+pCLuFBvMDJUeCdzHk2iyTYZibHRXzcyq8qJnZOD/oxpMy3BYJ98ij1k8w/FhsX+vPfrOXP46Kt1ptRgB4WQEMKNuf2/gTcjZQh+D08orIL3fJGOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f78.google.com with SMTP id ca18e2360f4ac-83e5dd390bfso51962439f.1
        for <kvm@vger.kernel.org>; Wed, 11 Dec 2024 05:12:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733922745; x=1734527545;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pV1WSM0uR6QzWDu1etL273q+8hX2b1Hk5gb25+FrL+s=;
        b=H3Ij+L16rXIJYEHY5fPnGEqTu8jRSSEyfOI2BiY8Pae8//LBW5Pfd18imM3VCSR8hw
         n+xRgDql/boXrUNR4iqHDGax4uZ7Yet/8VS7qXZqLUG9ZG7y8j7Tj3GlyO62SE6jeMd6
         cXrvOY0bNyLvR0xQBG+H4gf7LJIfwqPwhKPlg1AkXWcew7cLxT1Q3DslXyzchEjr+njE
         WqQYuW4VVtN/7+/CCDzIV8bAgxWN1v4b/Z2PaWtS12nZiRlKstbXPSE4GFDSa9XOKdMc
         f3uA0WCcaqX/RPW9UtsPmsmbLMpwsHdDd4jvGF/YV67xU/gyE8pPx8SCRcRJXS7yH4AW
         J9QQ==
X-Forwarded-Encrypted: i=1; AJvYcCV1ZPVGK0pxmFhaDMzQQb9cs1tBIEnMESi1eZhPysBaudBSDsNei83J4ty/0CMB0m/eeCU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwTF430LGUlvs4E6wDOhr6OagRrMRMjwgw4QjA9xJfdHBqWp8Wr
	nFHQS0S5lEPSBht+Kpzi6cX30qiNulykmWZvQVV0qowljnTrhiA8gT13GCR7fb9d6RJZLQuVxMp
	oCWagxTUz8daThD29Dx8YZ9rey8YEzuBenM4roMRo8oQjSRJEmVZE01w=
X-Google-Smtp-Source: AGHT+IGze4MxPj5iGn6/ta7knzasPXvbPwh2ZLh3kmhikB1FeOCBsHilRPjeTfeMmiCyD/JJT/JcFEsDSbjoQzk6Z2Z5uB/rpOKF
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a6f:b0:3a7:d02b:f653 with SMTP id
 e9e14a558f8ab-3aa12be6b10mr28449535ab.0.1733922745221; Wed, 11 Dec 2024
 05:12:25 -0800 (PST)
Date: Wed, 11 Dec 2024 05:12:25 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67598fb9.050a0220.17f54a.003b.GAE@google.com>
Subject: [syzbot] [kvm?] WARNING in vmx_handle_exit (2)
From: syzbot <syzbot+ac0bc3a70282b4d586cc@syzkaller.appspotmail.com>
To: bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com, 
	pbonzini@redhat.com, seanjc@google.com, syzkaller-bugs@googlegroups.com, 
	tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    b5f217084ab3 Merge tag 'bpf-fixes' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1226b330580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9d99f0bff41614d0
dashboard link: https://syzkaller.appspot.com/bug?extid=ac0bc3a70282b4d586cc
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17d10820580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-b5f21708.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/4a2037d50b27/vmlinux-b5f21708.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e9e9c9c88191/bzImage-b5f21708.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ac0bc3a70282b4d586cc@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 3 PID: 6336 at arch/x86/kvm/vmx/vmx.c:6480 __vmx_handle_exit arch/x86/kvm/vmx/vmx.c:6480 [inline]
WARNING: CPU: 3 PID: 6336 at arch/x86/kvm/vmx/vmx.c:6480 vmx_handle_exit+0x40f/0x1f70 arch/x86/kvm/vmx/vmx.c:6637
Modules linked in:
CPU: 3 UID: 0 PID: 6336 Comm: syz.0.73 Not tainted 6.13.0-rc1-syzkaller-00316-gb5f217084ab3 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:__vmx_handle_exit arch/x86/kvm/vmx/vmx.c:6480 [inline]
RIP: 0010:vmx_handle_exit+0x40f/0x1f70 arch/x86/kvm/vmx/vmx.c:6637
Code: 07 38 d0 7f 08 84 c0 0f 85 b1 11 00 00 44 0f b6 a5 49 99 00 00 31 ff 44 89 e6 e8 8c 73 68 00 45 84 e4 75 52 e8 a2 71 68 00 90 <0f> 0b 90 48 8d bd 4a 99 00 00 c6 85 49 99 00 00 01 48 b8 00 00 00
RSP: 0018:ffffc90003a57a58 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff88803fa10000 RCX: ffffffff81319494
RDX: ffff888021152440 RSI: ffffffff8131949e RDI: 0000000000000001
RBP: ffffc900066bf000 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
R13: 0000000080000021 R14: ffff88803fa102d8 R15: dffffc0000000000
FS:  00007f5d3ac1e6c0(0000) GS:ffff88806a900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000001200e000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 vcpu_enter_guest arch/x86/kvm/x86.c:11081 [inline]
 vcpu_run+0x3047/0x4f50 arch/x86/kvm/x86.c:11242
 kvm_arch_vcpu_ioctl_run+0x44a/0x1740 arch/x86/kvm/x86.c:11560
 kvm_vcpu_ioctl+0x6ce/0x1520 virt/kvm/kvm_main.c:4340
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:906 [inline]
 __se_sys_ioctl fs/ioctl.c:892 [inline]
 __x64_sys_ioctl+0x190/0x200 fs/ioctl.c:892
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f5d39d7fed9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f5d3ac1e058 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f5d39f46080 RCX: 00007f5d39d7fed9
RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000005
RBP: 00007f5d39df3cc8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f5d39f46080 R15: 00007ffdd579bc48
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

