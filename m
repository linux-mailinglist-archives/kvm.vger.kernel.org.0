Return-Path: <kvm+bounces-29763-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 29D609B1DF5
	for <lists+kvm@lfdr.de>; Sun, 27 Oct 2024 14:55:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 87DF0B20F4D
	for <lists+kvm@lfdr.de>; Sun, 27 Oct 2024 13:55:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E028C156F45;
	Sun, 27 Oct 2024 13:55:36 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A585558BC
	for <kvm@vger.kernel.org>; Sun, 27 Oct 2024 13:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730037336; cv=none; b=s9LAPd80lfxiC33gmqx63qp7XlWIX9dK8CKnXCKytINBcaA6mvU6RcriFz1KAZzmfDmG/eHv+jpg4EuFZpj7MnwW1G/C7Oz3iaqoDpxIua9K0RyIP1hMLo0fe40STWdowCE5GtcQwKSQd0AsKSubpZl1zgLABnfcaTKhYUkkFM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730037336; c=relaxed/simple;
	bh=IagfQGZZSfpCbczPiCtVB7H5zIQnFPYsAAqk0fIFFNc=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=Pzdi2MtCxOgXMnKa1ZilEO8c2xiCYDlBsAgwdEECU8m+nhA93SwVKhH+IhXrv9d1M+ErVq18zmvRx9D9ph9+KkaD99bMZ6S5tkdzLUJyQRQDn/WpVwMEJWXIMuXB9P4cOiOvM7K2qgf6b3X/o8WLm1GlRW/rUo/exF8gnW8KWGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a4e52b6577so23736925ab.3
        for <kvm@vger.kernel.org>; Sun, 27 Oct 2024 06:55:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730037333; x=1730642133;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DvpTdNJAHMUYMjV0otN9rJrodmRbe5MNxe8dC8b5a+s=;
        b=TeifiGhCCXI11Eh2fi4HxFCSLJoZCEt2hPjCnsi6OPmn4X5v2uvJ29xnVr6dPRpWJI
         EZQ0CVeIevU8lN4nSujz9sEEj4n51ieh94K9QZjDoidmkkYLOnUJjTUtXexhNaamggEf
         zkBa88KaYaJXP093UENj1SfhwyXKBCopy7OVfIVMGCAeB1RbyFfgHmE2KJfbD1UAUSmE
         GUw1tEvaG9XRsGtHYGchcMJRf05cbWrPBxjEyNKvn44KQTFz/QcMwQs1UyOkazhi2tF1
         ZPZZ3PpMeqVc3wNxQ1wW626F1FbKKrIWWK7IFjhiy3T523hfklxI/OHTHkM9F7CJ8TlA
         xG0Q==
X-Forwarded-Encrypted: i=1; AJvYcCXvl31Dn9Gr3xjVRblrm+u7NLq0kSM5cAgSvqPAd8zBzIpZzktlX3BbYI+ZSYldDwPR2eM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxcJYQrx8WUk6hcHvBqEWYVvazynKzdTnGByAxiWudK43Epg0ul
	jv2CvUn8dz1a3wFAtnxrgrKJrdTHAwov+BH3vPSCuy1S5+1fw19eCUBOhNMc3TxrP2+fYvIj2NO
	UXOPh3jYhE4XJrYnqNLgVTi61Dd6zxiMMJ2Pb8pACgk5/NTqlbAsVNHg=
X-Google-Smtp-Source: AGHT+IFgVj5y7UcihmmcffRNSjAUAwJfopX6wPsav4ShCezh1Hg0VzDeEPFvjj/nI9gnNr1RM0lkZYrJahlIKMAz9BYGshq8ciZq
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1445:b0:3a3:b45b:a8cc with SMTP id
 e9e14a558f8ab-3a4ed2b5cb9mr42286565ab.15.1730037333549; Sun, 27 Oct 2024
 06:55:33 -0700 (PDT)
Date: Sun, 27 Oct 2024 06:55:33 -0700
In-Reply-To: <66f4164d.050a0220.211276.0032.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <671e4655.050a0220.2b8c0f.01d8.GAE@google.com>
Subject: Re: [syzbot] [bcachefs] WARNING in srcu_check_nmi_safety (2)
From: syzbot <syzbot+314c2cfd4071ad738810@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, kvm@vger.kernel.org, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	pbonzini@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    850925a8133c Merge tag '9p-for-6.12-rc5' of https://github..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1311ea87980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=309bb816d40abc28
dashboard link: https://syzkaller.appspot.com/bug?extid=314c2cfd4071ad738810
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14bf3e5f980000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-850925a8.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c831c931f29c/vmlinux-850925a8.xz
kernel image: https://storage.googleapis.com/syzbot-assets/85f584e52a7f/bzImage-850925a8.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/9ebb84247bd1/mount_5.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+314c2cfd4071ad738810@syzkaller.appspotmail.com

------------[ cut here ]------------
CPU 0 old state 2 new state 1
WARNING: CPU: 0 PID: 5631 at kernel/rcu/srcutree.c:708 srcu_check_nmi_safety+0xca/0x150 kernel/rcu/srcutree.c:708
Modules linked in:
CPU: 0 UID: 0 PID: 5631 Comm: syz.2.27 Not tainted 6.12.0-rc4-syzkaller-00261-g850925a8133c #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:srcu_check_nmi_safety+0xca/0x150 kernel/rcu/srcutree.c:708
Code: 81 c3 c8 01 00 00 48 89 d8 48 c1 e8 03 42 0f b6 04 20 84 c0 75 77 8b 33 48 c7 c7 80 0d 0c 8c 89 ea 44 89 f9 e8 87 81 db ff 90 <0f> 0b 90 90 eb 0c 42 0f b6 04 23 84 c0 75 3d 45 89 3e 48 83 c4 08
RSP: 0000:ffffc9000d1c7648 EFLAGS: 00010246
RAX: 84aa6098780aa300 RBX: ffffe8ffffc537c8 RCX: ffff88803ecb8000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000002 R08: ffffffff8155e452 R09: 1ffff11003f8519a
R10: dffffc0000000000 R11: ffffed1003f8519b R12: dffffc0000000000
R13: 0000607fe0053600 R14: ffffe8ffffc53620 R15: 0000000000000001
FS:  00007fe40acde6c0(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe409f7e719 CR3: 000000001f99c000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 srcu_read_lock include/linux/srcu.h:248 [inline]
 __kvm_handle_hva_range virt/kvm/kvm_main.c:612 [inline]
 kvm_mmu_notifier_invalidate_range_end+0x90/0x3e0 virt/kvm/kvm_main.c:843
 mn_hlist_invalidate_end mm/mmu_notifier.c:550 [inline]
 __mmu_notifier_invalidate_range_end+0x241/0x410 mm/mmu_notifier.c:569
 mmu_notifier_invalidate_range_end include/linux/mmu_notifier.h:472 [inline]
 wp_page_copy mm/memory.c:3460 [inline]
 do_wp_page+0x265a/0x52d0 mm/memory.c:3745
 handle_pte_fault+0x10e3/0x6800 mm/memory.c:5771
 __handle_mm_fault mm/memory.c:5898 [inline]
 handle_mm_fault+0x1106/0x1bb0 mm/memory.c:6066
 do_user_addr_fault arch/x86/mm/fault.c:1338 [inline]
 handle_page_fault arch/x86/mm/fault.c:1481 [inline]
 exc_page_fault+0x459/0x8c0 arch/x86/mm/fault.c:1539
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623
RIP: 0033:0x7fe409e418e0
Code: 39 4f 08 72 4c 8d 4d ff 85 ed 74 33 66 0f 1f 44 00 00 48 39 f0 72 1b 4d 8b 07 49 89 c1 49 29 f1 47 0f b6 0c 08 45 84 c9 74 08 <45> 88 0c 00 49 8b 47 10 48 83 c0 01 49 89 47 10 83 e9 01 73 d3 41
RSP: 002b:00007fe40acdd4a0 EFLAGS: 00010202
RAX: 0000000000147010 RBX: 00007fe40acdd540 RCX: 0000000000000007
RDX: 00000000000007ff RSI: 0000000000001000 RDI: 00007fe40acdd5e0
RBP: 0000000000000008 R08: 00007fe400c00000 R09: 0000000000000015
R10: 0000000020005982 R11: 00000000000058ad R12: 0000000000000c01
R13: 00007fe40a005ae0 R14: 0000000000000017 R15: 00007fe40acdd5e0
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

