Return-Path: <kvm+bounces-69749-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GAkvHnoRfWmiQAIAu9opvQ
	(envelope-from <kvm+bounces-69749-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 21:15:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 177DABE59F
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 21:15:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DE530302E79C
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 20:15:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B52AD34FF59;
	Fri, 30 Jan 2026 20:15:25 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f78.google.com (mail-oa1-f78.google.com [209.85.160.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B29012ED16D
	for <kvm@vger.kernel.org>; Fri, 30 Jan 2026 20:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769804125; cv=none; b=Zkt609+ZTd3xe9/RtaWaTVGhvPMnqE0q9i49K5BeMMfWATWVPLHwd9wLATJphb3EsNen72dX08lCc3LlX941sZMThdLs71Kf5bp1rM33bQnDoQgTizaChYOdWQ9DE67vPwDPVqYj6w8k5GqUM8wmQeZQr0sxFXEEMhPhVgoDDlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769804125; c=relaxed/simple;
	bh=nCQpHolX2VVXRZ/6OcafXjN3xWnmFBsrueucrWMexOk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=N1sJn3M10I83wppsaB23lvG7UIjjBazwrkb3JeCakN8twSPAUUidN5Tq9HaK6ogtqv2LBclHdAP1gKof0JTT/48M7Kh+L9L10cUnYOrMM5ucJamxsrFAkIPuMCxne/iqySs7Ss8yNLrgXaxFarFu1wJNRhyMx1Bop0jchTzFlHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f78.google.com with SMTP id 586e51a60fabf-40450320b4fso5082707fac.0
        for <kvm@vger.kernel.org>; Fri, 30 Jan 2026 12:15:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769804122; x=1770408922;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QBOwVcVDIwDPCuFNjIKM4GdZe1vtv87d1N+gKHzASkY=;
        b=X4EpM+Zb790zltkmafdbnXAcEcg1F2DgniTUQhDGfls4tSa208HtXXZe+ej3HMxCRq
         c4pFeuOf/HAdERDlC2UUwLfRMu6z7GaXoknhH1i2ubydBP/tbgRSAeKCWZaCeqYKa5Ef
         +Tg+DBYWBEjh1M8c1S5s+PMVVL38flZm3pliY6JLwhUmYFX+IFQSKvadclXgFJLGHdIg
         gIXtR+6DRzyBXDVOx3VExftZz0SCBBOwAgiFO+nTgNaRX7M4qdLl9WcreP/5DPj9lh2+
         YqQCkCU+Ucw3910ql1xwbotHh7ESXyhfo3K1ITVHdajw24OnDRhzLblGi2KN7fiBtC2O
         mELg==
X-Gm-Message-State: AOJu0Yzohv3McmkWEmwCjiYQB9EMVeUAF7GvPcwu7c3NaU4Fwo3R+Lsm
	YCTnXfqIpwrfQDsK5nuJAeSCcAtWya+suR6ETAjBWJsRRiN1X9vqKM0qE7kfI/jkz0+2+mzVezv
	ROOhqqKV+uYPTUMKd6S+VnB2LUhTcj7lAzk9TM8yv0dop2VnYDZbvVdOtaxPKdw==
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:f015:b0:662:c9d0:c8fd with SMTP id
 006d021491bc7-6630f385496mr2067118eaf.57.1769804122595; Fri, 30 Jan 2026
 12:15:22 -0800 (PST)
Date: Fri, 30 Jan 2026 12:15:22 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <697d115a.050a0220.1d61ec.0004.GAE@google.com>
Subject: [syzbot] [kvm?] WARNING in kvm_gmem_fault_user_mapping
From: syzbot <syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	URI_HIDDEN_PATH(1.00)[https://syzkaller.appspot.com/x/.config?x=f1fac0919970b671];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[appspotmail.com : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-69749-lists,kvm=lfdr.de,33a04338019ac7e43a44];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	SUBJECT_HAS_QUESTION(0.00)[];
	REDIRECTOR_URL(0.00)[goo.gl];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[syzbot@syzkaller.appspotmail.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_NONE(0.00)[];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[syzkaller.appspot.com:url,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,storage.googleapis.com:url,goo.gl:url,appspotmail.com:email,googlegroups.com:email]
X-Rspamd-Queue-Id: 177DABE59F
X-Rspamd-Action: no action

Hello,

syzbot found the following issue on:

HEAD commit:    1f97d9dcf536 Merge tag 'vfio-v6.19-rc8' of https://github...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10b3e322580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f1fac0919970b671
dashboard link: https://syzkaller.appspot.com/bug?extid=33a04338019ac7e43a44
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15e5ebfa580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13eef85a580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/f898291c4b7b/disk-1f97d9dc.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/cac48e20323c/vmlinux-1f97d9dc.xz
kernel image: https://storage.googleapis.com/syzbot-assets/d2e60d34b7e7/bzImage-1f97d9dc.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com

------------[ cut here ]------------
folio_test_large(folio)
WARNING: arch/x86/kvm/../../../virt/kvm/guest_memfd.c:416 at kvm_gmem_fault_user_mapping+0x4b5/0x6e0 virt/kvm/guest_memfd.c:416, CPU#1: syz.3.124/6406
Modules linked in:
CPU: 1 UID: 0 PID: 6406 Comm: syz.3.124 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/13/2026
RIP: 0010:kvm_gmem_fault_user_mapping+0x4b5/0x6e0 virt/kvm/guest_memfd.c:416
Code: 00 e9 a1 fe ff ff bd 00 04 00 00 eb d9 e8 43 b8 83 00 48 c7 c6 e0 9f 82 8b 48 89 df e8 d4 f8 ce 00 90 0f 0b e8 2c b8 83 00 90 <0f> 0b 90 48 8d 6b 34 48 89 df e8 ec f6 bb 00 be 04 00 00 00 48 89
RSP: 0018:ffffc90004ab7848 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffffea00018a0000 RCX: ffffffff81834070
RDX: ffff888028b124c0 RSI: ffffffff81834334 RDI: ffff888028b124c0
RBP: ffffc90004ab79f8 R08: 0000000000000007 R09: 0000000000000000
R10: 0000000000000040 R11: 0000000000000000 R12: ffffea00018a0000
R13: ffffc90004ab7a08 R14: 0000000000000040 R15: ffffea00018a0008
FS:  00007fb8562ce6c0(0000) GS:ffff8881246db000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f89fb863d58 CR3: 000000006060a000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 __do_fault+0x10d/0x550 mm/memory.c:5323
 do_read_fault mm/memory.c:5758 [inline]
 do_fault+0xaf9/0x1990 mm/memory.c:5892
 do_pte_missing mm/memory.c:4404 [inline]
 handle_pte_fault mm/memory.c:6276 [inline]
 __handle_mm_fault+0x1807/0x2b50 mm/memory.c:6414
 handle_mm_fault+0x36d/0xa20 mm/memory.c:6583
 faultin_page mm/gup.c:1126 [inline]
 __get_user_pages+0xf9c/0x34d0 mm/gup.c:1428
 populate_vma_page_range+0x267/0x3f0 mm/gup.c:1860
 __mm_populate+0x107/0x3a0 mm/gup.c:1963
 do_mlock+0x3f0/0x7f0 mm/mlock.c:653
 __do_sys_mlock mm/mlock.c:661 [inline]
 __se_sys_mlock mm/mlock.c:659 [inline]
 __x64_sys_mlock+0x59/0x80 mm/mlock.c:659
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xc9/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb85539aeb9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fb8562ce028 EFLAGS: 00000246 ORIG_RAX: 0000000000000095
RAX: ffffffffffffffda RBX: 00007fb855615fa0 RCX: 00007fb85539aeb9
RDX: 0000000000000000 RSI: 0000000000800000 RDI: 0000200000000000
RBP: 00007fb855408c1f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fb855616038 R14: 00007fb855615fa0 R15: 00007ffcc1750088
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

