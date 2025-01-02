Return-Path: <kvm+bounces-34474-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 04CE69FF73B
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 10:06:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F237D3A2288
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 09:06:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 069E8199252;
	Thu,  2 Jan 2025 09:06:25 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1DBB1922F5
	for <kvm@vger.kernel.org>; Thu,  2 Jan 2025 09:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735808784; cv=none; b=eWQ2cufkVe7O/eeOryXLql2hYA5HEDOaEWCe/vzZ1rlTZM6tjgqtvHGeTBizs7bVh5ihoG2/exfiWk1WO9gGS31a7FTdP8FdF1cAUAZUBilzDI7CaNifZH1TQ73yOBSAGIhs7H4xRHpVaN690oTLtYdvi/64mkQazf9v8gFIBnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735808784; c=relaxed/simple;
	bh=I/JoeYyXBVKCP3w/rxwfQwl3KUFL5sqwbpnIswsaY28=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=KaXj6NQ4+u+iYeSw3s8pr9Jz0RqOJ2mSrKCDQm4BujzQNIrYUhrjlAmuI+ruS/WHMVaWf8NrEJG5T4MvI587FeOU/JDRVG5CcvsOSAgiddASgVXasXgEfP6tbaLu38g3W2mabsT2tlgaTHN9s9Y6cdPm61nXndruVlHzZzulX8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-3a91a13f63fso98151665ab.3
        for <kvm@vger.kernel.org>; Thu, 02 Jan 2025 01:06:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735808782; x=1736413582;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xpenbRfiSwIhVsA9wKxD4qefzrJoImezmd7/ycez2v0=;
        b=JsneDDf7KNm5brGXJfDCZ+b3LcIB0svrCvxVD6wrFWkOg0pAZttfiDQjg0I2T/GHGD
         bEAjX8+RmZOa8tejNuDvhY4WhdjsCdfavH89hsyyDe2AQqMeSkj4yOmggyBLOxm3G0lg
         +Xv0U+TWiL7l1UDPxy/4yjNmyklo8T5Rh1AnuFZHSOnhml0D5PSWaWe7orkf8oQ1qlGY
         +BFJXBbDTgeNRGRMdWKBDUwOrX9GiDY3hpbJzrl5nI5FYFTxn84iwEQ+0zCDQZxMaYTs
         vQipW5IHlrHfmxwC8tNyuPFIK2HgqqA+JrmOAkIQ4P1wtQdlva9VqYuofSxhxrzrygRn
         KwvQ==
X-Gm-Message-State: AOJu0YxNNxRnrKC5B7Fojp8mZFjabq6o4OxqO15/LDoqw13bfxQTD/0e
	DF4r2yWEV9uaKMnqIx7Gqu8sno5eKmiutsagQ7sidmu2Z3niga64SNX4bdPCy1zcSmQi68Jo7Og
	t3PWN11GOsY2RkhHmsngNl8OTwiVpAAfBnFX/WrQrfD8wnnFLirX1XEmeZg==
X-Google-Smtp-Source: AGHT+IGWIQoMRWBWviWDE6AWKiNAFtJd7K2A1ghbDs0iFYlAaOeoh0VKGgY4QnBnjd6NBooPg2sgXCrzsOVuvxtJkbRAmlEnjJor
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:194a:b0:3a7:7124:bd2b with SMTP id
 e9e14a558f8ab-3c2d514f8e4mr387723945ab.15.1735808782147; Thu, 02 Jan 2025
 01:06:22 -0800 (PST)
Date: Thu, 02 Jan 2025 01:06:22 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6776570e.050a0220.3a8527.0036.GAE@google.com>
Subject: [syzbot] [kvm?] WARNING in __kvm_gpc_refresh (3)
From: syzbot <syzbot+cde12433b6c56f55d9ed@syzkaller.appspotmail.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    059dd502b263 Merge tag 'block-6.13-20241228' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13c9b2c4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=aa8dc22aa6de51f5
dashboard link: https://syzkaller.appspot.com/bug?extid=cde12433b6c56f55d9ed
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-059dd502.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/2125981e6709/vmlinux-059dd502.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ffdf1326e5e4/bzImage-059dd502.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cde12433b6c56f55d9ed@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 3 PID: 6643 at arch/x86/kvm/../../../virt/kvm/pfncache.c:267 __kvm_gpc_refresh+0x174b/0x2390 virt/kvm/pfncache.c:267
Modules linked in:
CPU: 3 UID: 0 PID: 6643 Comm: syz.1.195 Not tainted 6.13.0-rc4-syzkaller-00078-g059dd502b263 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:__kvm_gpc_refresh+0x174b/0x2390 virt/kvm/pfncache.c:267
Code: c1 ea 03 80 3c 02 00 0f 85 dc 09 00 00 48 8b 3c 24 49 89 9f 08 01 00 00 31 db e8 30 20 14 0a e9 44 f4 ff ff e8 b6 e7 81 00 90 <0f> 0b 90 e9 31 f4 ff ff 4c 8b 7c 24 60 e8 a3 e7 81 00 31 db e9 e5
RSP: 0018:ffffc90004aa7230 EFLAGS: 00010283
RAX: 00000000000008c2 RBX: ffffffffffffffff RCX: ffffc90007221000
RDX: 0000000000080000 RSI: ffffffff81182dfa RDI: 0000000000000000
RBP: dffffc0000000000 R08: 0000000000000000 R09: 0000000000000001
R10: 0000000000000001 R11: ffffffff961eaed8 R12: ffff888000000000
R13: ffffc90005c4a401 R14: ffff887fffffff01 R15: ffffc90005c4a408
FS:  00007f0d642716c0(0000) GS:ffff88806a900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 0000000053494000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 kvm_gpc_refresh+0xc3/0x140 virt/kvm/pfncache.c:382
 kvm_xen_set_evtchn.part.0+0x19c/0x270 arch/x86/kvm/xen.c:1878
 kvm_xen_set_evtchn arch/x86/kvm/xen.c:1968 [inline]
 kvm_xen_hvm_evtchn_send+0x231/0x290 arch/x86/kvm/xen.c:1958
 kvm_arch_vm_ioctl+0x119b/0x1d10 arch/x86/kvm/x86.c:7256
 kvm_vm_ioctl+0x1a87/0x3df0 virt/kvm/kvm_main.c:5241
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:906 [inline]
 __se_sys_ioctl fs/ioctl.c:892 [inline]
 __x64_sys_ioctl+0x190/0x200 fs/ioctl.c:892
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f0d63385d29
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f0d64271038 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f0d63575fa0 RCX: 00007f0d63385d29
RDX: 0000000020000180 RSI: 00000000400caed0 RDI: 0000000000000006
RBP: 00007f0d63401b08 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f0d63575fa0 R15: 00007fff66828448
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

