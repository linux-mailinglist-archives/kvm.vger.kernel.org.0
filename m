Return-Path: <kvm+bounces-21096-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F0DDD92A3F9
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 15:46:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 207CA1C21A1D
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 13:46:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 127CD13A407;
	Mon,  8 Jul 2024 13:46:30 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F252746D
	for <kvm@vger.kernel.org>; Mon,  8 Jul 2024 13:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720446389; cv=none; b=FBjyse5ppp/jeOC5cWgAxt9Mn7KfHiQ4IQ3rGmeY/NOqIHZwiBV79K3VGj4htn25mwvKlZB1OHb5hyYZaorfiWsibwS7KpX01K98uCcjuoZd50+jnCtsjCzlhVhKljON7Oq14pOxABeoyG+piSWBlWe0jZFw8beTl53b7aO+9fA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720446389; c=relaxed/simple;
	bh=+XGCrrE8am2COw2YeeRVhtWkcA5sL9oO5Smao7EHkhQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=otkXXGjLPQc6ZvRKr4j2yvI5FwWQsVxup3yDb9QJh1Ih+Qyc7c8L8pNDXihFSGmm5SgLZxzypZn5O1W0a+mY2yl33wV9Z3pkEGMQwOgx5mzTJyX5bpExwoqNEWGvIQHp0kALob/7yfOfrWPqHRJv3QXU2wDAnQodHWp6smj5evU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-7f639551768so499990639f.3
        for <kvm@vger.kernel.org>; Mon, 08 Jul 2024 06:46:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720446387; x=1721051187;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Vtvs1Mko5LsRU3Lb/N5jUYmX0w85N4zKIwVYsZktNRk=;
        b=wwdQ45w7CCaKdTLX6CRGP8Ly7bGOVYenYMxl51a6lPZMkxYAbpJXOSfHjtwSYv+I8Y
         kwohNgQKUK4J7hlhk0P05pZwwEpoWz3INgEAp4p/WpmrjEcz/X5J1JRSOoiOoNu6xALx
         3mtt6ZIo9d65DYkOkLktg/6u3wLgTN1G2clH5ibhySDLBuB9CekmtBpkTTGdjJYa+t05
         hfzvCrdbNRi+m1pwgjvreJF/dW8hEVtCn8ai+Ke9rkXFhfTbSXdauh/eOu7oJuQ3xmIN
         HalkG/X0rQij4iDmQzF8UympM0tYB4I5cJJFPH2Sp1nuV3gYFctIPQINlc42toMG9lCh
         lnJA==
X-Forwarded-Encrypted: i=1; AJvYcCUeOyciLo+GFbC1tX6onFrDY1/7C11L30zazLoCcqXh/Q63tv02GCJXtG0CpoDh99aCut2o1MqEOSpkVTC+rlToyLTK
X-Gm-Message-State: AOJu0YxYCBYnQlYwETdrcfnWxoiBOBm1qV0kwMWiAjmWyIhPNkxOlphE
	jtMDZH01WfigkkW6PcOutYZZjDhCfaeK24dv0hx5aPHS8rAYBI6T+gEDvmBlo6spegoxIBkKj9o
	TIdIp+VGHBV0mEUhdVKzbFiyUdpjEx33rRw0I+KbkIvUnw2+gHxcOsCM=
X-Google-Smtp-Source: AGHT+IEC1VWIswqFr0N8S6lXGHwqadgtjbzIcS/xTHB2cbva9SKYWhBdb+32fegttWHjH6IHlGJhovKdHEUYHr7hN7N9hkRPB6pq
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:1650:b0:4c0:8165:c391 with SMTP id
 8926c6da1cb9f-4c08165c540mr657027173.4.1720446387130; Mon, 08 Jul 2024
 06:46:27 -0700 (PDT)
Date: Mon, 08 Jul 2024 06:46:27 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c2a6b9061cbca3c3@google.com>
Subject: [syzbot] [kvm?] WARNING in kvm_recalculate_apic_map
From: syzbot <syzbot+545f1326f405db4e1c3e@syzkaller.appspotmail.com>
To: bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com, 
	mlevitsk@redhat.com, pbonzini@redhat.com, seanjc@google.com, 
	syzkaller-bugs@googlegroups.com, tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    f3a2439f20d9 Merge tag 'rproc-v6.3' of git://git.kernel.or..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=12e2d518c80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=81f5afa0c201c8de
dashboard link: https://syzkaller.appspot.com/bug?extid=545f1326f405db4e1c3e
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16b7be60c80000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11a380a8c80000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/0719d575f3ac/disk-f3a2439f.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/4176aabb67b5/vmlinux-f3a2439f.xz
kernel image: https://storage.googleapis.com/syzbot-assets/2b0e3c0ab205/bzImage-f3a2439f.xz

The issue was bisected to:

commit 76e527509d37a15ff1714ddd003384f5f25fd3fc
Author: Sean Christopherson <seanjc@google.com>
Date:   Fri Jan 6 01:12:52 2023 +0000

    KVM: x86: Skip redundant x2APIC logical mode optimized cluster setup

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=124fbe60c80000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=114fbe60c80000
console output: https://syzkaller.appspot.com/x/log.txt?x=164fbe60c80000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+545f1326f405db4e1c3e@syzkaller.appspotmail.com
Fixes: 76e527509d37 ("KVM: x86: Skip redundant x2APIC logical mode optimized cluster setup")

------------[ cut here ]------------
WARNING: CPU: 0 PID: 5078 at arch/x86/kvm/lapic.c:330 kvm_recalculate_logical_map arch/x86/kvm/lapic.c:330 [inline]
WARNING: CPU: 0 PID: 5078 at arch/x86/kvm/lapic.c:330 kvm_recalculate_apic_map+0x1267/0x14e0 arch/x86/kvm/lapic.c:413
Modules linked in:
CPU: 0 PID: 5078 Comm: syz-executor294 Not tainted 6.2.0-syzkaller-12485-gf3a2439f20d9 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/16/2023
RIP: 0010:kvm_recalculate_logical_map arch/x86/kvm/lapic.c:330 [inline]
RIP: 0010:kvm_recalculate_apic_map+0x1267/0x14e0 arch/x86/kvm/lapic.c:413
Code: 8f ae a2 00 48 8b 3c 24 ba 01 00 00 00 be 04 00 00 00 e8 ac 83 fb ff 48 c7 44 24 08 00 00 00 00 e9 9b f7 ff ff e8 49 f9 6c 00 <0f> 0b e9 d2 f6 ff ff e8 3d f9 6c 00 4c 89 23 e9 c5 f6 ff ff 48 8b
RSP: 0018:ffffc900034af800 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
RDX: ffff8880776f41c0 RSI: ffffffff811729b7 RDI: 0000000000000004
RBP: 0000000000000400 R08: 0000000000000004 R09: 0000000000000001
R10: 0000000000082000 R11: 0000000000000000 R12: ffff8880299f2000
R13: ffff88807d13c040 R14: dffffc0000000000 R15: 0000000000082000
FS:  0000555556467300(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000002004d008 CR3: 00000000760bd000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 kvm_apic_set_state+0x468/0xeb0 arch/x86/kvm/lapic.c:2951
 kvm_vcpu_ioctl_set_lapic arch/x86/kvm/x86.c:4858 [inline]
 kvm_arch_vcpu_ioctl+0x2862/0x3f90 arch/x86/kvm/x86.c:5593
 kvm_vcpu_ioctl+0x9ad/0xfe0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4255
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl fs/ioctl.c:856 [inline]
 __x64_sys_ioctl+0x197/0x210 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f5e46a52109
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffcdc080378 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f5e46a52109
RDX: 0000000020000880 RSI: 000000004400ae8f RDI: 0000000000000005
RBP: 00007f5e46a15b60 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f5e46a15bf0
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection

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

