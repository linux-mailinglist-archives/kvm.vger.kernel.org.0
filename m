Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 999B13EC27E
	for <lists+kvm@lfdr.de>; Sat, 14 Aug 2021 13:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238286AbhHNL5q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Aug 2021 07:57:46 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:41520 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238185AbhHNL5q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 14 Aug 2021 07:57:46 -0400
Received: by mail-il1-f200.google.com with SMTP id l4-20020a92d8c40000b02902242b6ea4b3so6708359ilo.8
        for <kvm@vger.kernel.org>; Sat, 14 Aug 2021 04:57:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=tFwx9H+sTjbqXalUaqlUwVvV3lDLGUXGvavN83jop28=;
        b=ZcLeRUy0Tah102YXLzFlBegr2P4lZeC9ydoYnGN1LkoRp+3Ebi0dK7cYYtR9HRBamN
         AoEkA8YcX+YGpQpwWfiY+p0AuJLxxqXT1Eq3pNZEq2jtX8PLX7tBLoxMBcfL889OjUBp
         qykZ5HpVzBEDwKS6KHfMOqYJWq96t69bP+9OH75/zb1y6/b3ykZG7pQvx+6/J2ISmPIJ
         UHec4Dg4ZzsOrSjg5aJ+Omdz+4laMBb9OpFRWmJeJ3+j0Ae0J2WhU8j6UAuEPWNcZFT9
         kihw230W9pfRRcmBQL+85P+nZx9BG8PLwSaQIgD4zOp1NWF/HR4ydIlHlPovUwXNpLD5
         Q5gA==
X-Gm-Message-State: AOAM530YmIRJfmv2A2/49l0shClyneRKjodghtvRL+4TW4bF4N9CmgBv
        kDVDLmXcVMDk9W6R3z29V/hujmxuCrDQJPAEVl2YQkvjlZrd
X-Google-Smtp-Source: ABdhPJx2KYasBtFCquvNNnoSEfrJhdXzPJS2wgtVNcnJ0uRu/Bx/fyxDCdatYD6EOfAXSKMOiuIt7tEd4KPWzqTWYWyfaKGHjcId
MIME-Version: 1.0
X-Received: by 2002:a92:b312:: with SMTP id p18mr4924224ilh.233.1628942237883;
 Sat, 14 Aug 2021 04:57:17 -0700 (PDT)
Date:   Sat, 14 Aug 2021 04:57:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000072e53a05c983ab22@google.com>
Subject: [syzbot] general protection fault in wb_timer_fn
From:   syzbot <syzbot+aa0801b6b32dca9dda82@syzkaller.appspotmail.com>
To:     acme@kernel.org, alexander.shishkin@linux.intel.com,
        axboe@kernel.dk, bp@alien8.de, hpa@zytor.com, jmattson@google.com,
        jolsa@redhat.com, joro@8bytes.org, kvm@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, mingo@redhat.com, namhyung@kernel.org,
        pbonzini@redhat.com, peterz@infradead.org, seanjc@google.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    92d00774360d Add linux-next specific files for 20210810
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=127f1f79300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a6933fa6f9a86ca9
dashboard link: https://syzkaller.appspot.com/bug?extid=aa0801b6b32dca9dda82
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=145a8ff1300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1496e9fa300000

The issue was bisected to:

commit 9483409ab5067941860754e78a4a44a60311d276
Author: Namhyung Kim <namhyung@kernel.org>
Date:   Mon Mar 15 03:34:36 2021 +0000

    perf core: Allocate perf_buffer in the target node memory

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16fd40f9300000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=15fd40f9300000
console output: https://syzkaller.appspot.com/x/log.txt?x=11fd40f9300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+aa0801b6b32dca9dda82@syzkaller.appspotmail.com
Fixes: 9483409ab506 ("perf core: Allocate perf_buffer in the target node memory")

general protection fault, probably for non-canonical address 0xdffffc00000000aa: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000550-0x0000000000000557]
CPU: 0 PID: 6563 Comm: systemd-udevd Not tainted 5.14.0-rc5-next-20210810-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:latency_exceeded block/blk-wbt.c:237 [inline]
RIP: 0010:wb_timer_fn+0x149/0x1740 block/blk-wbt.c:360
Code: 03 80 3c 02 00 0f 85 68 13 00 00 48 8b 9b c8 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 8d bb 50 05 00 00 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 35 13 00 00 48 8b 9b 50 05 00 00 48 b8 00 00 00
RSP: 0018:ffffc90000007cd8 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000100
RDX: 00000000000000aa RSI: ffffffff83d107dd RDI: 0000000000000550
RBP: ffff88801ab3cc00 R08: 0000000000000003 R09: ffff88801ab3cd83
R10: ffffffff83d107d2 R11: 0000000000027e24 R12: 0000000000000003
R13: 0000000000000000 R14: ffff888146318000 R15: ffff88801ab3ccd0
FS:  00007fc1898e38c0(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055aed4a39410 CR3: 0000000025577000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 call_timer_fn+0x1a5/0x6b0 kernel/time/timer.c:1421
 expire_timers kernel/time/timer.c:1466 [inline]
 __run_timers.part.0+0x675/0xa20 kernel/time/timer.c:1734
 __run_timers kernel/time/timer.c:1715 [inline]
 run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1747
 __do_softirq+0x29b/0x9c2 kernel/softirq.c:558
 invoke_softirq kernel/softirq.c:432 [inline]
 __irq_exit_rcu+0x16e/0x1c0 kernel/softirq.c:636
 irq_exit_rcu+0x5/0x20 kernel/softirq.c:648
 sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1100
 </IRQ>
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:638
RIP: 0010:tomoyo_domain_quota_is_ok+0x105/0x550 security/tomoyo/util.c:1054
Code: 68 10 48 3b 2c 24 0f 84 f4 00 00 00 49 be 00 00 00 00 00 fc ff df eb 5f e8 f8 8b d7 fd 48 89 e8 48 89 ee 48 c1 e8 03 83 e6 07 <42> 0f b6 0c 30 48 8d 45 07 48 89 c2 48 c1 ea 03 42 0f b6 14 32 40
RSP: 0018:ffffc900011df908 EFLAGS: 00000246
RAX: 1ffff1100f264000 RBX: 0000000000000010 RCX: 0000000000000000
RDX: ffff888019120000 RSI: 0000000000000000 RDI: 0000000000000003
RBP: ffff888079320000 R08: 0000000000000000 R09: 0000000000000010
R10: ffffffff839e1c9a R11: 0000000000000010 R12: 0000000000000002
R13: 00000000000000e1 R14: dffffc0000000000 R15: 0000000000000000
 tomoyo_supervisor+0x2f2/0xf00 security/tomoyo/common.c:2089
 tomoyo_audit_path_log security/tomoyo/file.c:168 [inline]
 tomoyo_path_permission security/tomoyo/file.c:587 [inline]
 tomoyo_path_permission+0x270/0x3a0 security/tomoyo/file.c:573
 tomoyo_path_perm+0x2f0/0x400 security/tomoyo/file.c:838
 security_inode_getattr+0xcf/0x140 security/security.c:1332
 vfs_getattr fs/stat.c:157 [inline]
 vfs_fstat+0x43/0xb0 fs/stat.c:182
 __do_sys_newfstat+0x81/0x100 fs/stat.c:422
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fc1887552e2
Code: 48 8b 05 b9 db 2b 00 64 c7 00 16 00 00 00 b8 ff ff ff ff c3 0f 1f 40 00 83 ff 01 77 33 48 63 fe b8 05 00 00 00 48 89 d6 0f 05 <48> 3d 00 f0 ff ff 77 06 f3 c3 0f 1f 40 00 48 8b 15 81 db 2b 00 f7
RSP: 002b:00007ffed32f4de8 EFLAGS: 00000246 ORIG_RAX: 0000000000000005
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fc1887552e2
RDX: 00007ffed32f4e00 RSI: 00007ffed32f4e00 RDI: 0000000000000007
RBP: 00007ffed32f4f80 R08: 0000000000000000 R09: 0000000000000001
R10: 0000000000080000 R11: 0000000000000246 R12: 000055aed49f40e0
R13: 000055aed4a06f10 R14: 00007ffed32f4ee0 R15: 00007ffed32f4f40
Modules linked in:
---[ end trace 85971c24ea99db54 ]---
RIP: 0010:latency_exceeded block/blk-wbt.c:237 [inline]
RIP: 0010:wb_timer_fn+0x149/0x1740 block/blk-wbt.c:360
Code: 03 80 3c 02 00 0f 85 68 13 00 00 48 8b 9b c8 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 8d bb 50 05 00 00 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 35 13 00 00 48 8b 9b 50 05 00 00 48 b8 00 00 00
RSP: 0018:ffffc90000007cd8 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000100
RDX: 00000000000000aa RSI: ffffffff83d107dd RDI: 0000000000000550
RBP: ffff88801ab3cc00 R08: 0000000000000003 R09: ffff88801ab3cd83
R10: ffffffff83d107d2 R11: 0000000000027e24 R12: 0000000000000003
R13: 0000000000000000 R14: ffff888146318000 R15: ffff88801ab3ccd0
FS:  00007fc1898e38c0(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055aed4a39410 CR3: 0000000025577000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
