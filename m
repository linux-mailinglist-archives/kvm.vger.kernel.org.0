Return-Path: <kvm+bounces-29737-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E0EE99B09FE
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 18:30:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4D09D28536D
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 16:30:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 086BB1FB899;
	Fri, 25 Oct 2024 16:30:35 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6224A171E70
	for <kvm@vger.kernel.org>; Fri, 25 Oct 2024 16:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729873834; cv=none; b=njxaut970lvlr+6ETak/xG97Lv2MZgSzlrM2t4INOFBvV3bQRKkJ7kOOxgtLsSUDpSotR6rg5Z4iSh+zAHD20Jp8jvVguJGOsZwdN+8XGVLte/CC0W/uGhniqpq2SyuIP3MSjQsSRnQmKAneA7U+2P4wBwI2WPr+cRWCTP5NNDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729873834; c=relaxed/simple;
	bh=AOy+Nuh65up7r+OOoaiQVMV/zqFJfdW4WDO4wUNwVm4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=kYVCSbXeLug/Wcm3YXdX1l66KMx/PV9Ylyo2iVpzzbvFgm2hVMTnn5hpWuAW4XOQNDdH9TtjRUtJinS0c2kmoumWhMHDmsfvgb3+0NsA8IEyilwNKJbAQDzEgka0oMRFnnUzZZneSDIOB7yNbnD83ZeNXqtzA+ZiWzoyD+/4pWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a4e52b6577so10876185ab.3
        for <kvm@vger.kernel.org>; Fri, 25 Oct 2024 09:30:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729873831; x=1730478631;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qgINqnNGWBIMu/Gtg/B4QPV2E69iodd3y8eI2ioVRUs=;
        b=jOCsw+CARNe3yfTg02Pm3gSot8q3qDtKwq0n0DBfPIMJGqbQRAcFqusqH/M5uubYFO
         sOG7HbHetp7HaHSkP9uUMk4Y+Kk4ck3jsy7IQH7v/kplAKZJPFrT/vbqLCfP1OsA/qXL
         AECfF1z6Cbv4TpE2PsnHkb/mEqk0u2//xKGEBb5vhrMpGY4f20wHZt1mUndwbdzjmaf3
         DyDWj8S6ydmen3mKlqN77joTXW52baMUggspPiThu3xJXwO+tTUNu9lbdfMgDcX2cACo
         23K+zcyJqjutxB2aRR2hEma2hOsIyc4+2JfHRnAsj0wylsjynFEpI9FRxBPwdJzKWfe5
         w38Q==
X-Forwarded-Encrypted: i=1; AJvYcCU5gE+0n/lTOaONZfg8sRLNdjeSFEUP7ZTU9yDFRsPqYva7S7m0GQAa9Wsj94j7EBUwiAg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yww2BUl5kTGLJewhYnR6awZrieQKY8SXKp22HgnCilDNCUkIfHh
	Z+W6W1H3I6hv2RIp6sMczLwrrroeVZuvHan0Bt0dhvvH0qlb2nvKADsTg40L0Pgoq/UujyqdiV/
	QLzM9H62MxZNTS4Ayjf/R07CwiMMoiDE31x/M+KQi5F+Y8lPk+K3rQO0=
X-Google-Smtp-Source: AGHT+IGkWp8y8cjUg3u7AtdKAbDMDMlM2je89ks0wwEJXtfTY4KreOCJIY7/4xzzb1m6zwQ2LSgQDMRV8yuQDa4uFi+CWhy0b9NR
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a26:b0:3a3:449b:5989 with SMTP id
 e9e14a558f8ab-3a4de81e91bmr69216585ab.21.1729873831343; Fri, 25 Oct 2024
 09:30:31 -0700 (PDT)
Date: Fri, 25 Oct 2024 09:30:31 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <671bc7a7.050a0220.455e8.022a.GAE@google.com>
Subject: [syzbot] [kvm?] WARNING in vcpu_run
From: syzbot <syzbot+1522459a74d26b0ac33a@syzkaller.appspotmail.com>
To: bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com, 
	pbonzini@redhat.com, seanjc@google.com, syzkaller-bugs@googlegroups.com, 
	tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    ae90f6a6170d Merge tag 'bpf-fixes' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=168d0230580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=309bb816d40abc28
dashboard link: https://syzkaller.appspot.com/bug?extid=1522459a74d26b0ac33a
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=158d0230580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12f8de40580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/1fd044836856/disk-ae90f6a6.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/a01e01be8aa8/vmlinux-ae90f6a6.xz
kernel image: https://storage.googleapis.com/syzbot-assets/9b0e73e0cce7/bzImage-ae90f6a6.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1522459a74d26b0ac33a@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 5838 at arch/x86/kvm/x86.c:11215 vcpu_block arch/x86/kvm/x86.c:11215 [inline]
WARNING: CPU: 1 PID: 5838 at arch/x86/kvm/x86.c:11215 vcpu_run+0x872d/0x8900 arch/x86/kvm/x86.c:11259
Modules linked in:
CPU: 1 UID: 0 PID: 5838 Comm: syz-executor929 Not tainted 6.12.0-rc4-syzkaller-00161-gae90f6a6170d #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
RIP: 0010:vcpu_block arch/x86/kvm/x86.c:11215 [inline]
RIP: 0010:vcpu_run+0x872d/0x8900 arch/x86/kvm/x86.c:11259
Code: 48 3b 84 24 e0 04 00 00 0f 85 e5 01 00 00 44 89 f0 48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc e8 f4 12 81 00 90 <0f> 0b 90 e9 72 ff ff ff e8 e6 12 81 00 e9 68 ff ff ff e8 dc 12 81
RSP: 0018:ffffc90003c6f480 EFLAGS: 00010293
RAX: ffffffff8113c4cc RBX: 00000000fffffff0 RCX: ffff88802eae8000
RDX: 0000000000000000 RSI: 00000000fffffff0 RDI: 00000000fffffff0
RBP: ffffc90003c6f9b0 R08: ffffffff8113498c R09: 1ffff110069638dc
R10: dffffc0000000000 R11: ffffed10069638dd R12: 1ffff1100691305d
R13: ffff888034898000 R14: ffffffff8e72ae90 R15: ffff888034898038
FS:  00007f148304f6c0(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 00000000781b4000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 kvm_arch_vcpu_ioctl_run+0xa73/0x19d0 arch/x86/kvm/x86.c:11575
 kvm_vcpu_ioctl+0x91a/0xea0 virt/kvm/kvm_main.c:4475
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:907 [inline]
 __se_sys_ioctl+0xf9/0x170 fs/ioctl.c:893
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f14830f9049
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 c1 17 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f148304f228 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f1483183358 RCX: 00007f14830f9049
RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000005
RBP: 00007f1483183350 R08: 00007ffe514601c7 R09: 00007f148304f6c0
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f148318335c
R13: 00007f1483150038 R14: 6d766b2f7665642f R15: 00007ffe514601c8
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

