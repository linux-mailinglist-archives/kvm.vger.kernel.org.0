Return-Path: <kvm+bounces-5906-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A4285828C5C
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 19:19:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 38FD828B032
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 18:19:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CB543C49B;
	Tue,  9 Jan 2024 18:18:36 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37B733C08F
	for <kvm@vger.kernel.org>; Tue,  9 Jan 2024 18:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-7bbb3de4dcbso471388839f.1
        for <kvm@vger.kernel.org>; Tue, 09 Jan 2024 10:18:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704824313; x=1705429113;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DncZn6c+GlUDS3Eow4E7Ee0E3U2sIs+h4+zjPxDgTfI=;
        b=hVPQWZldcpeWAlxG2iOlc/ktP+g2OU6N7PIPYYSb68O/Of1fvvuLkelQRciXv6/yh2
         MaAMA3DcSeH8G/kb5wZu4/U5x7/chg40b2Isz5dRXbHWknBA7YyKyUtmRRw7MvL4gUp+
         oiznHXP3TdScJ67T0vTTYHVLSSUqOzf3sFbG1LsmFXQJJqZd1qSNh5D1TmbOvIdh1shg
         UvedKPesIMtWLNNK/GMtxyEocAqDV6T+NLO5JzlnAi5aWv1VrmqAvIXOn5ue/cdGRIj6
         xdst2x3EiLTSz2emQgk+gPBHlj8FpaEUC7a/ARjO+/7/5GB2ed7hBYIjGRoMPlQAL1RG
         cN4g==
X-Gm-Message-State: AOJu0YwT23wotoi7lRWBXYk1U6X06DplXsfxCY5B41kYMFFXDJpwX43p
	D2ixLFglSDgOz7yjqEJGoDE+DN4WOZ+eeVWQGhZ9XlCNCWBr
X-Google-Smtp-Source: AGHT+IFlViT9UFojL/xBSsgtudTqUVqAd4XNZUn9f5XZtPcETMuDBkcLuv+ue5DhMTwhMGQUq+zXOUs9MzN9b7HMVZDR/Elja8Nm
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1c49:b0:35f:ece8:8e4d with SMTP id
 d9-20020a056e021c4900b0035fece88e4dmr820326ilg.1.1704824313514; Tue, 09 Jan
 2024 10:18:33 -0800 (PST)
Date: Tue, 09 Jan 2024 10:18:33 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009c91ce060e87575b@google.com>
Subject: [syzbot] [kvm?] KMSAN: uninit-value in em_ret_far
From: syzbot <syzbot+579eb95e588b48b4499c@syzkaller.appspotmail.com>
To: bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com, 
	pbonzini@redhat.com, seanjc@google.com, syzkaller-bugs@googlegroups.com, 
	tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    2cf4f94d8e86 Merge tag 'scsi-fixes' of git://git.kernel.or..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=144e8d01e80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4a65fa9f077ead01
dashboard link: https://syzkaller.appspot.com/bug?extid=579eb95e588b48b4499c
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/589557edbfd5/disk-2cf4f94d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/f2480533f00e/vmlinux-2cf4f94d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/9463e8eac2ed/bzImage-2cf4f94d.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+579eb95e588b48b4499c@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in em_ret_far+0x332/0x340 arch/x86/kvm/emulate.c:2258
 em_ret_far+0x332/0x340 arch/x86/kvm/emulate.c:2258
 x86_emulate_insn+0x1d81/0x5800 arch/x86/kvm/emulate.c:5289
 x86_emulate_instruction+0x13c5/0x3090 arch/x86/kvm/x86.c:9101
 kvm_mmu_page_fault+0x100a/0x1120 arch/x86/kvm/mmu/mmu.c:5778
 handle_ept_violation+0x4ef/0x7e0 arch/x86/kvm/vmx/vmx.c:5788
 __vmx_handle_exit arch/x86/kvm/vmx/vmx.c:6567 [inline]
 vmx_handle_exit+0x1b01/0x2130 arch/x86/kvm/vmx/vmx.c:6584
 vcpu_enter_guest arch/x86/kvm/x86.c:10992 [inline]
 vcpu_run arch/x86/kvm/x86.c:11095 [inline]
 kvm_arch_vcpu_ioctl_run+0x9d4f/0xc680 arch/x86/kvm/x86.c:11321
 kvm_vcpu_ioctl+0xbfc/0x1770 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4155
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:871 [inline]
 __se_sys_ioctl+0x225/0x410 fs/ioctl.c:857
 __x64_sys_ioctl+0x96/0xe0 fs/ioctl.c:857
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0x44/0x110 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x63/0x6b

Local variable eip created at:
 em_ret_far+0x3a/0x340 arch/x86/kvm/emulate.c:2243
 x86_emulate_insn+0x1d81/0x5800 arch/x86/kvm/emulate.c:5289

CPU: 0 PID: 5010 Comm: syz-executor207 Not tainted 6.7.0-rc6-syzkaller-00010-g2cf4f94d8e86 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 11/17/2023
=====================================================


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

