Return-Path: <kvm+bounces-19792-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CF5C90B554
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 17:54:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9D6191F2386B
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 15:54:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39E1E13A41A;
	Mon, 17 Jun 2024 15:39:26 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E9613A3F6
	for <kvm@vger.kernel.org>; Mon, 17 Jun 2024 15:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718638765; cv=none; b=cla3hexsPkM1HiKFomc+fK0lNn3OjTaStpo49iKBqe5nJRfxtZd5q6hU78jXcOZ1VdsqYxGr+XIX3/C988CJYIrUgGFTRzC+Nfb1qPFb1nmlktjArwohMNU6zW0wldhBfXGAj7oKV0AOOXgDvYZ0RJNlfqeEV0rmE6X8XRyBdWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718638765; c=relaxed/simple;
	bh=xvySwpVukXXPe5qw9oHSmepJLKb2O/omBh83xtb+c3U=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=XYP1wSmIs+VK8TG+bCtxCSHMteBf59goErv1guuaOSS+ZTEf3yp3Ax5hW2N/wX2FR0OmF5oTCpLqgwpBJP8gVJ54BjHdiU/FTo6268AHCpiKLxyOelggqty7r3/JThZeL0GL8/zdKTBtPzMOPYtHNcZuAr1X6medLGdr2SHEAxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-375a1820034so47615655ab.2
        for <kvm@vger.kernel.org>; Mon, 17 Jun 2024 08:39:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718638763; x=1719243563;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=N4JRjHCKYiu2+aW22GPWDWuq8gS1/iCWahwq61vCEfw=;
        b=U0HNE/UGS3vQG38Rkm27qyKng/YI82jj2fMo7jYymnl967+CGusMk4OuDywnGMsK06
         ecPFl4HnWkQ1Xlrbqp9S1ZFEXtvKQ3waEQVe99BNkJfwCrWCz8/rosVEfoxSj4K4mvUj
         iov3jj2ifH6isTDe+2DcDP5NFoe3SOwKO/WyJTf5vpKbk9u1bekcr+D2FSlNMukvRq2I
         xhTcSbe7I9JgAsbjJKmGNZWyK8uwTNDTQ7F6qySWfBJU0huHbY/hyOlpkROuiTBFHU/H
         lO1qS2Mkp35sRLqrLVm+asT3PcLUeCNK+3GPkai6sv0uzDqPmGm73oMo6W3qR7muABUs
         f8Gw==
X-Gm-Message-State: AOJu0YwJ0rIOKme3uhG68u5f48eIVzuxWE8xRUnKTA8F1F3/TEG9PA1T
	1vKDWYrHSb462oyt+2uBllZ+JDmAlsZGtGTGmQtD4A27PxCAQNgtJ+zfyE6uOAdpCnKQc84ql5f
	L8mTWqKAJmAdGou+Mpczf1bQi0Aqpr6muVS1Offpv0wL8+uOVQPGtv/iHJA==
X-Google-Smtp-Source: AGHT+IE7fNarLzhhMZoBxa8Ven0IveZbNXtHRCwFmmok1gouwKv+kZnz6ElGEIxA40FIgdY5w5ChvMwk5nk/t2KlNtA4WF0NO4Hl
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1d02:b0:375:e04f:55af with SMTP id
 e9e14a558f8ab-375e0e27eefmr5712615ab.1.1718638763389; Mon, 17 Jun 2024
 08:39:23 -0700 (PDT)
Date: Mon, 17 Jun 2024 08:39:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fd4bde061b17c4a0@google.com>
Subject: [syzbot] [kvm?] WARNING in kvm_put_kvm
From: syzbot <syzbot+d8775ae2dbebe5ab16fd@syzkaller.appspotmail.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    2ccbdf43d5e7 Merge tag 'for-linus' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1695b7ee980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b8786f381e62940f
dashboard link: https://syzkaller.appspot.com/bug?extid=d8775ae2dbebe5ab16fd
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/a4edf8b28d7f/disk-2ccbdf43.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/5f9b0fd6168d/vmlinux-2ccbdf43.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a2c5f918ca4f/bzImage-2ccbdf43.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d8775ae2dbebe5ab16fd@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 17017 at kernel/rcu/srcutree.c:653 cleanup_srcu_struct+0x37c/0x520 kernel/rcu/srcutree.c:653
Modules linked in:
CPU: 0 PID: 17017 Comm: syz-executor.4 Not tainted 6.10.0-rc3-syzkaller-00044-g2ccbdf43d5e7 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/07/2024
RIP: 0010:cleanup_srcu_struct+0x37c/0x520 kernel/rcu/srcutree.c:653
Code: 83 c4 20 5b 5d 41 5c 41 5d 41 5e 41 5f c3 cc cc cc cc 90 0f 0b 90 48 83 c4 20 5b 5d 41 5c 41 5d 41 5e 41 5f c3 cc cc cc cc 90 <0f> 0b 90 e9 35 ff ff ff 90 0f 0b 90 48 b8 00 00 00 00 00 fc ff df
RSP: 0018:ffffc90003567d20 EFLAGS: 00010202
RAX: 0000000000000001 RBX: ffffc90002d6e000 RCX: 0000000000000002
RDX: fffff91ffffab294 RSI: 0000000000000008 RDI: ffffe8ffffd59498
RBP: ffff88805b6c0000 R08: 0000000000000000 R09: fffff91ffffab293
R10: ffffe8ffffd5949f R11: 0000000000000000 R12: ffffc90002d778a8
R13: ffffc90002d77880 R14: ffffc90002d77868 R15: 0000000000000004
FS:  00007fa719dec6c0(0000) GS:ffff8880b9200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020078000 CR3: 000000006176a000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 kvm_destroy_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:1351 [inline]
 kvm_put_kvm+0x8df/0xb80 arch/x86/kvm/../../../virt/kvm/kvm_main.c:1380
 kvm_vm_release+0x42/0x60 arch/x86/kvm/../../../virt/kvm/kvm_main.c:1403
 __fput+0x408/0xbb0 fs/file_table.c:422
 task_work_run+0x14e/0x250 kernel/task_work.c:180
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:114 [inline]
 exit_to_user_mode_prepare include/linux/entry-common.h:328 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
 syscall_exit_to_user_mode+0x278/0x2a0 kernel/entry/common.c:218
 do_syscall_64+0xda/0x250 arch/x86/entry/common.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fa71907cea9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 e1 20 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fa719dec0c8 EFLAGS: 00000246 ORIG_RAX: 00000000000001b4
RAX: 0000000000000000 RBX: 00007fa7191b3f80 RCX: 00007fa71907cea9
RDX: 0000000000000000 RSI: ffffffffffffffff RDI: 0000000000000003
RBP: 00007fa7190ebff4 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 000000000000000b R14: 00007fa7191b3f80 R15: 00007ffdd8b78f38
 </TASK>


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

