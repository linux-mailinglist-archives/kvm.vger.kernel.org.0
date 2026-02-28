Return-Path: <kvm+bounces-72274-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iFlMIp3VomkY6AQAu9opvQ
	(envelope-from <kvm+bounces-72274-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 12:46:37 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 07A681C29BE
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 12:46:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id EEFC3303A486
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 11:46:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C32C143C04C;
	Sat, 28 Feb 2026 11:46:23 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15C53115B8
	for <kvm@vger.kernel.org>; Sat, 28 Feb 2026 11:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772279183; cv=none; b=TNzX/Xq3zIBpI2onNdZc5VZBqCPSSD77Ri8FL7/hhXcSQwJfhYV/nMVR3DugsWC97nkvTGD1h9NoasoS8sPlF5jEfeGmaMC1DoMOfbczNuxSqc3cYNicvf6ey8NxNUdmrwvVRPzco2RVsjzisufyXnmnt35YLXVWxnK7O5auajM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772279183; c=relaxed/simple;
	bh=V5nMKAigv3HCQsTyt/zrxEJeoGfpqosEiJVgKBWl6vc=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=PbT0pS3XtCbu+sd9O/KGT9zRAA/hmMN6R7yAr525NMhNRQ0ELuwFHtfM5vxGaAbj2MfiqJzoIDd4LXS0dfzlsTPO9I1pPlzr5VsnEaKrHuQd3fav5xb9ueJ8HHx/pesvH12mKqLxMktJBeRNFZD/uU6Ce/x69uJhlHkt4RG76VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-679943693c0so52353333eaf.3
        for <kvm@vger.kernel.org>; Sat, 28 Feb 2026 03:46:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772279181; x=1772883981;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Q8LuITVldGOlUNrpSliupPOmyqk5VihC4Ea6iAcEmgE=;
        b=IQBzVNtoYb6hpXvrUNtdhoae1WywO8zX7kyOvJmWoJkwJ7G/FfHzUMFmFGgwOrIfuM
         +++/yRRtIOp1NMre8or6bY0MHzEriHpXJS2ua+qAcmJibWe8YMY7aQRTC+y6/UOLvPJT
         b9OEbcZ3EmS4fbiIoAApIJYMeqAVKxFe52aAvjhY/a6LsnCllvE8b3EYQboqgHJe2XRr
         4ZYT3NxfrOgpgadTwFct40FvF+Dium3bA+4gTD+9KjB+hCUTGMGWYMEhbdNpJCeH/qhx
         ZCjLPcijWJSiX//nLiCXe+303iYBbrRYPAC1MhlFcO/Bdz+QX/JlJU0SswFEwBLlqSW0
         0UIg==
X-Forwarded-Encrypted: i=1; AJvYcCV+cy4xthUErTYhXERqI97BikLlm42lb3Q6OBhmbwfIGUZW4c7XWTvc52wFamz0Uzzbh0U=@vger.kernel.org
X-Gm-Message-State: AOJu0YxOazbOCeVF46PcMn5VmSGyNknvtMegoeXwudHrdLLVO/o5i5m+
	+i/J6npFZ6QoL8aFVUg1r6J08vRs2WhKiHkwLH+MU/VvmIvtXAd6BKLF/k7AZw93UusrbqLrpEc
	hiC/1HWi/btbnevz4x1e+vDfn88rMbrq/mtFk1cnwNgaOXHyUIkfKxLNhccc=
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2913:b0:679:e7b2:9fb8 with SMTP id
 006d021491bc7-679fadb8af6mr4205368eaf.14.1772279180960; Sat, 28 Feb 2026
 03:46:20 -0800 (PST)
Date: Sat, 28 Feb 2026 03:46:20 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69a2d58c.050a0220.3a55be.003b.GAE@google.com>
Subject: [syzbot] [kvmarm?] [kvm?] BUG: unable to handle kernel paging request
 in kvm_vgic_destroy
From: syzbot <syzbot+f6a46b038fc243ac0175@syzkaller.appspotmail.com>
To: catalin.marinas@arm.com, joey.gouly@arm.com, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, maz@kernel.org, oupton@kernel.org, 
	suzuki.poulose@arm.com, syzkaller-bugs@googlegroups.com, will@kernel.org, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	URI_HIDDEN_PATH(1.00)[https://syzkaller.appspot.com/x/.config?x=148fc9aa8e041d0a];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[appspotmail.com : SPF not aligned (relaxed), No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-72274-lists,kvm=lfdr.de,f6a46b038fc243ac0175];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	SUBJECT_HAS_QUESTION(0.00)[];
	REDIRECTOR_URL(0.00)[goo.gl];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[syzbot@syzkaller.appspotmail.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	TO_DN_NONE(0.00)[];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,appspotmail.com:email,syzkaller.appspot.com:url,storage.googleapis.com:url,googlegroups.com:email]
X-Rspamd-Queue-Id: 07A681C29BE
X-Rspamd-Action: no action

Hello,

syzbot found the following issue on:

HEAD commit:    6316366129d2 Merge branch kvm-arm64/misc-6.20 into kvmarm-..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git next
console output: https://syzkaller.appspot.com/x/log.txt?x=15e59c4a580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=148fc9aa8e041d0a
dashboard link: https://syzkaller.appspot.com/bug?extid=f6a46b038fc243ac0175
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13182006580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=173900ba580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/fa3fbcfdac58/non_bootable_disk-63163661.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/1018400deda3/vmlinux-63163661.xz
kernel image: https://storage.googleapis.com/syzbot-assets/fb8a8bb5d8a4/Image-63163661.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f6a46b038fc243ac0175@syzkaller.appspotmail.com

 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x90/0x230 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x120/0x2f4 arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x58/0x74 arch/arm64/kernel/syscall.c:151
 el0_svc+0x5c/0x238 arch/arm64/kernel/entry-common.c:724
 el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:743
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596
Unable to handle kernel paging request at virtual address ffef800000000000
KASAN: maybe wild-memory-access in range [0xff00000000000000-0xff0000000000000f]
Mem abort info:
  ESR = 0x0000000096000004
  EC = 0x25: DABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
  FSC = 0x04: level 0 translation fault
Data abort info:
  ISV = 0, ISS = 0x00000004, ISS2 = 0x00000000
  CM = 0, WnR = 0, TnD = 0, TagAccess = 0
  GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
[ffef800000000000] address between user and kernel address ranges
Internal error: Oops: 0000000096000004 [#1]  SMP
Modules linked in:
CPU: 0 UID: 0 PID: 3651 Comm: syz.2.17 Not tainted syzkaller #0 PREEMPT 
Hardware name: linux,dummy-virt (DT)
pstate: 01402009 (nzcv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
pc : kvm_vgic_dist_destroy arch/arm64/kvm/vgic/vgic-init.c:445 [inline]
pc : kvm_vgic_destroy+0x2d4/0x624 arch/arm64/kvm/vgic/vgic-init.c:518
lr : kvm_vgic_dist_destroy arch/arm64/kvm/vgic/vgic-init.c:444 [inline]
lr : kvm_vgic_destroy+0x290/0x624 arch/arm64/kvm/vgic/vgic-init.c:518
sp : ffff80008e647b90
x29: ffff80008e647ba0 x28: 0000000000000005 x27: cdf00000200a52d8
x26: cdf00000200a4db0 x25: 00000000000000cd x24: cdf00000200a4d8c
x23: 00000000000000cd x22: 00000000000000cd x21: cdf00000200a4ad0
x20: efff800000000000 x19: cdf00000200a4000 x18: 00000000030f4b63
x17: 0000000000000031 x16: 0000000000000000 x15: ffff800088209a68
x14: ffffffffffffffff x13: 0000000000000028 x12: 5df000001795c1f0
x11: ffff800088209a68 x10: 0000000000ff0100 x9 : 0ff0000000000000
x8 : 0000000000000000 x7 : ffff80008672f958 x6 : 0000000000000000
x5 : 0000000000000000 x4 : 0000000000000000 x3 : 0000000000000002
x2 : 0000000000000008 x1 : 0000000000000000 x0 : 0000000000000007
Call trace:
 kvm_vgic_dist_destroy arch/arm64/kvm/vgic/vgic-init.c:445 [inline] (P)
 kvm_vgic_destroy+0x2d4/0x624 arch/arm64/kvm/vgic/vgic-init.c:518 (P)
 kvm_arch_destroy_vm+0x88/0x138 arch/arm64/kvm/arm.c:299
 kvm_destroy_vm virt/kvm/kvm_main.c:1317 [inline]
 kvm_put_kvm+0x778/0xbe0 virt/kvm/kvm_main.c:1354
 kvm_vm_release+0x58/0x78 virt/kvm/kvm_main.c:1377
 __fput+0x4ac/0x978 fs/file_table.c:468
 ____fput+0x20/0x58 fs/file_table.c:496
 task_work_run+0x1b8/0x250 kernel/task_work.c:233
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 __exit_to_user_mode_loop kernel/entry/common.c:44 [inline]
 exit_to_user_mode_loop+0x110/0x188 kernel/entry/common.c:75
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline]
 exit_to_user_mode_prepare_legacy include/linux/irq-entry-common.h:242 [inline]
 arm64_exit_to_user_mode arch/arm64/kernel/entry-common.c:81 [inline]
 el0_svc+0x17c/0x238 arch/arm64/kernel/entry-common.c:725
 el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:743
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596
Code: 54000420 b2481c28 d344fd09 d378fc28 (38696a89) 
---[ end trace 0000000000000000 ]---
----------------
Code disassembly (best guess):
   0:	54000420 	b.eq	0x84  // b.none
   4:	b2481c28 	orr	x8, x1, #0xff00000000000000
   8:	d344fd09 	lsr	x9, x8, #4
   c:	d378fc28 	lsr	x8, x1, #56
* 10:	38696a89 	ldrb	w9, [x20, x9] <-- trapping instruction


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

