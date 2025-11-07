Return-Path: <kvm+bounces-62296-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id C49D0C408CB
	for <lists+kvm@lfdr.de>; Fri, 07 Nov 2025 16:10:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D1CD04EC7AC
	for <lists+kvm@lfdr.de>; Fri,  7 Nov 2025 15:10:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 281F832B9AE;
	Fri,  7 Nov 2025 15:10:32 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C3882D0C6C
	for <kvm@vger.kernel.org>; Fri,  7 Nov 2025 15:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762528231; cv=none; b=ISkBuS72f1tP8aXCduwt4QWIDWUZNxHM6nGKMnJ9s8NikLqek7BETUXKFuo/YhPsYz+yAkUQvoHWIAx0Xnge/oHM9DqMfFDwKSaxA3l3RMB6L76PbTUbffAD3WIoEyS0U0hTHqHmtpLybc2yYh7X01nwQZYq2E/e6Qu42o8sT6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762528231; c=relaxed/simple;
	bh=imYJgJK3yE89xgNM6WG9I3e7kgFWg66OAp278Y3nsw8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=H617OAXr3rl+/AK9N+eehcHm3E5aDQVv4w2z6zWXhDUPJNWjVKLsOShzJ2jAiFNp4DwCJeudgh5OqVPnH6DezXJ/np7NUvTs6lZYvgO7qFnUjrVEVZPOgwvgBLaCG3oJ/y3+asJAepLxRUaoz9Yj10M+HvkPAS7+Dy9SV8WnK9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-433316b78f4so9637295ab.3
        for <kvm@vger.kernel.org>; Fri, 07 Nov 2025 07:10:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762528228; x=1763133028;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=T1tqpolWM4ITEU43y70omU9y9wXcif44mofTVyALHkg=;
        b=fK1VlDfT5fMXjuG0mIR1xbDQsUCxeedYZEyl6wzkS+A84s4Gru0TesVdoqpXUjSfwT
         hcCDCsbAsi2r3Gc0UfHWxYFRGZ9Ey8zEjyejLmgg+PEMm5UAaq7mh5/Z3/vgMERKprdO
         jq/yAJA28YEbcURaDb/0rqiraCjT1MVehygrOvhLWPpBWUJRl+JAjVwE5ZX3LlKS9WYg
         JOx+rhbMhAQpE7yh+dtVKtKQjRk+OaILlvkWEExTZ7sGaTCvSq6r640z+Y+hk9L5mpm7
         9cJlAS7AFLZ1ZLylJyvRUSSffgtKao27DhQ4MU9rDXW8182pMpR+7FtVl1JwoHX2HU5I
         YAkw==
X-Forwarded-Encrypted: i=1; AJvYcCUs2CQuqLe2LRSi2Kz0HkU3OxGVSEVx+sB2lmLYuW5snWu8nX+AgSKvygCUFv5D9WqpJt8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzXkzHikVN8GUTCf4i0DrV1V2n7MZF1pjHDNsovcltB908h/U0u
	dyt2DF1k/70WGc4SqU4ztRvCTKRNxf5N8p1spQo/IsgBHQxJcsUbDC385rzfT0iF0dBOT+zo7oG
	y0mcV7SrYwzlaCyv/oUA8wyp3MQ8e+y6MvX0S2hLoeEaEqMsquP85hJCCiI4=
X-Google-Smtp-Source: AGHT+IGh26snMwvSnJmWwk3UfazZc7x9P3W22C3UgXg6p9/OcfnQ7Bp05FUYnQ2HQw7DGG+0g1vmjX82zZRCjJZqR+k1l87kYehD
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2304:b0:433:2aad:9869 with SMTP id
 e9e14a558f8ab-4335f4d7fcdmr52527915ab.30.1762528228583; Fri, 07 Nov 2025
 07:10:28 -0800 (PST)
Date: Fri, 07 Nov 2025 07:10:28 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <690e0be4.a70a0220.22f260.0050.GAE@google.com>
Subject: [syzbot] [kvm-x86?] WARNING in kvm_arch_can_dequeue_async_page_present
From: syzbot <syzbot+6bea72f0c8acbde47c55@syzkaller.appspotmail.com>
To: bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com, 
	pbonzini@redhat.com, seanjc@google.com, syzkaller-bugs@googlegroups.com, 
	tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    9c0826a5d9aa Add linux-next specific files for 20251107
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=13a67012580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4f8fcc6438a785e7
dashboard link: https://syzkaller.appspot.com/bug?extid=6bea72f0c8acbde47c55
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14e110b4580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14ab1114580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/6b76dc0ec17f/disk-9c0826a5.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/522b6d2a1d1d/vmlinux-9c0826a5.xz
kernel image: https://storage.googleapis.com/syzbot-assets/4a58225d70f3/bzImage-9c0826a5.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6bea72f0c8acbde47c55@syzkaller.appspotmail.com

kvm_intel: L1TF CPU bug present and SMT on, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.
------------[ cut here ]------------
WARNING: arch/x86/kvm/x86.c:13965 at kvm_arch_can_dequeue_async_page_present+0x1a9/0x2f0 arch/x86/kvm/x86.c:13965, CPU#0: syz.0.17/5998
Modules linked in:
CPU: 0 UID: 0 PID: 5998 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/02/2025
RIP: 0010:kvm_arch_can_dequeue_async_page_present+0x1a9/0x2f0 arch/x86/kvm/x86.c:13965
Code: 00 65 48 8b 0d 58 81 72 11 48 3b 4c 24 40 75 21 48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d e9 3e af 20 0a cc e8 48 e1 79 00 90 <0f> 0b 90 b0 01 eb c0 e8 4b c1 1d 0a f3 0f 1e fa 4c 8d b3 f8 02 00
RSP: 0018:ffffc90003167460 EFLAGS: 00010293
RAX: ffffffff8147eee8 RBX: ffff888030280000 RCX: ffff88807fda1e80
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000009
RBP: ffffc900031674e8 R08: ffff88803028003f R09: 1ffff11006050007
R10: dffffc0000000000 R11: ffffed1006050008 R12: 1ffff9200062ce8c
R13: dffffc0000000000 R14: 0000000000000000 R15: dffffc0000000000
FS:  000055556a8c3500(0000) GS:ffff888125a79000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 0000000072cc2000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 kvm_check_async_pf_completion+0x102/0x3c0 virt/kvm/async_pf.c:158
 vcpu_enter_guest arch/x86/kvm/x86.c:11209 [inline]
 vcpu_run+0x26be/0x7760 arch/x86/kvm/x86.c:11650
 kvm_arch_vcpu_ioctl_run+0x116c/0x1cb0 arch/x86/kvm/x86.c:11995
 kvm_vcpu_ioctl+0x99a/0xed0 virt/kvm/kvm_main.c:4477
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f1588b8f6c9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffdfcd816a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f1588de5fa0 RCX: 00007f1588b8f6c9
RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000006
RBP: 00007f1588c11f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f1588de5fa0 R14: 00007f1588de5fa0 R15: 0000000000000003
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

