Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43918267A2A
	for <lists+kvm@lfdr.de>; Sat, 12 Sep 2020 13:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725852AbgILLy3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Sep 2020 07:54:29 -0400
Received: from mail-io1-f77.google.com ([209.85.166.77]:43455 "EHLO
        mail-io1-f77.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725833AbgILLyY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Sep 2020 07:54:24 -0400
Received: by mail-io1-f77.google.com with SMTP id b73so8511655iof.10
        for <kvm@vger.kernel.org>; Sat, 12 Sep 2020 04:54:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=QzpUN7h/ywNYhAKS1AakFzoFJB4yM5eHT7ViEh1lJuw=;
        b=RHiZifHYEzp3nd/fR3VM7swgHLU6ykrzsNmUvegG/ZU5UqJaQnryGKF3oXWCSTfr4m
         zRqyks3XcVgSF19LHUudn3Fu+pWDuZgdeAacqPEnM7rXIvH0qaKdlWOXLCkYRrerJqdE
         V/S1RYXlt6785MeVoUvRhHN7WFLoPLyRHInrrcvqKrTaSp18wJj1/TPtFeHA1XKpUbw7
         bkjvfkwBEhLuaVNfUPKV7xsdXWr5D9280FuJaHHd6n3d0rYFgCcWu6qlKKnDSsKa5xHf
         iw2OrvuE0wndWdbKRuVcXQf5gGSIagPP+kscyG7f5Eg6+6PyX+HAIoV+QI37SNcTCQPm
         5XMw==
X-Gm-Message-State: AOAM531GfBDOBY8Lqe53fv2AZTld6z6XIcOZW1CRKtU3AwoNDwGOHa+J
        oZQFlmMfG5eGXmRmnJAz2TMnMvTfuZrOgtXQoCx/Npn4hwdc
X-Google-Smtp-Source: ABdhPJzQgz3XcsB/JIg0WAtPqSFzqVutJsOO6oRSsPtnG55+taEr2KDT19ZyPqtlkzydQep/CFWtR7QYJdaoVvpPhcpfZ3aTkpBu
MIME-Version: 1.0
X-Received: by 2002:a05:6602:26c1:: with SMTP id g1mr5105834ioo.10.1599911662612;
 Sat, 12 Sep 2020 04:54:22 -0700 (PDT)
Date:   Sat, 12 Sep 2020 04:54:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000052792305af1c7614@google.com>
Subject: BUG: unable to handle kernel paging request in pvclock_gtod_notify
From:   syzbot <syzbot+815c663e220da75b02b6@syzkaller.appspotmail.com>
To:     bp@alien8.de, hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, vkuznets@redhat.com, wanpengli@tencent.com,
        x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    e8878ab8 Merge tag 'spi-fix-v5.9-rc4' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=137c47a5900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c61610091f4ca8c4
dashboard link: https://syzkaller.appspot.com/bug?extid=815c663e220da75b02b6
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1737a8be900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16ff15ed900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+815c663e220da75b02b6@syzkaller.appspotmail.com

BUG: unable to handle page fault for address: fffffc0068936230
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 0 P4D 0 
Oops: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 6839 Comm: syz-executor947 Not tainted 5.9.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:update_pvclock_gtod arch/x86/kvm/x86.c:1741 [inline]
RIP: 0010:pvclock_gtod_notify+0xab/0x570 arch/x86/kvm/x86.c:7449
Code: ff 74 24 10 31 f6 41 b8 01 00 00 00 48 c7 c7 a8 20 eb 8b e8 f7 87 4e 00 48 89 da 58 48 b8 00 77 00 77 00 fc ff df 48 c1 ea 03 <80> 3c 02 00 0f 85 65 04 00 00 48 b8 00 00 00 00 00 fc ff df 48 8b
RSP: 0018:ffffc90000da8be8 EFLAGS: 00010806
RAX: dffffc0077007700 RBX: ffffffff8c975980 RCX: ffffffff815a184b
RDX: 1ffffffff192eb30 RSI: 0000000000000001 RDI: 0000000000000082
RBP: 0000000000010002 R08: 0000000000000000 R09: ffffffff8c5f5a1f
R10: fffffbfff18beb43 R11: 0000000000000001 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: ffffffff89ae98e0
FS:  00000000011af880(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffc0068936230 CR3: 0000000091e56000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 update_pvclock_gtod kernel/time/timekeeping.c:581 [inline]
 timekeeping_update+0x28a/0x4a0 kernel/time/timekeeping.c:675
 timekeeping_advance+0x6ad/0xa40 kernel/time/timekeeping.c:2122
 tick_do_update_jiffies64.part.0+0x1ec/0x330 kernel/time/tick-sched.c:101
 tick_do_update_jiffies64 kernel/time/tick-sched.c:64 [inline]
 tick_sched_do_timer kernel/time/tick-sched.c:147 [inline]
 tick_sched_timer+0x236/0x2a0 kernel/time/tick-sched.c:1321
 __run_hrtimer kernel/time/hrtimer.c:1524 [inline]
 __hrtimer_run_queues+0x1d5/0xfc0 kernel/time/hrtimer.c:1588
 hrtimer_interrupt+0x32a/0x930 kernel/time/hrtimer.c:1650
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1080 [inline]
 __sysvec_apic_timer_interrupt+0x142/0x5e0 arch/x86/kernel/apic/apic.c:1097
 asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:706
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:22 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:48 [inline]
 sysvec_apic_timer_interrupt+0xb2/0xf0 arch/x86/kernel/apic/apic.c:1091
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:581
RIP: 0010:get_current arch/x86/include/asm/current.h:15 [inline]
RIP: 0010:__sanitizer_cov_trace_pc+0x0/0x60 kernel/kcov.c:196
Code: 48 89 ef 5d e9 51 90 3f 00 5d be 03 00 00 00 e9 66 27 27 02 66 0f 1f 44 00 00 48 8b be b0 01 00 00 e8 b4 ff ff ff 31 c0 c3 90 <65> 48 8b 14 25 c0 fe 01 00 65 8b 05 f0 b0 8d 7e a9 00 01 ff 00 48
RSP: 0018:ffffc900016472c0 EFLAGS: 00000246
RAX: 0000000000000000 RBX: ffffc90001647600 RCX: ffffffff82082278
RDX: 0000000000000000 RSI: ffff8880945ae340 RDI: 0000000000000005
RBP: 00000000000026ac R08: 0000000000000000 R09: ffff8880930654d7
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
R13: 0000000000000000 R14: 00000000000026ad R15: 0000000000000000
 mb_mark_used+0xacb/0xd90 fs/ext4/mballoc.c:1645
 ext4_mb_use_best_found+0x207/0x8e0 fs/ext4/mballoc.c:1705
 ext4_mb_measure_extent fs/ext4/mballoc.c:1812 [inline]
 ext4_mb_complex_scan_group+0x6db/0x9e0 fs/ext4/mballoc.c:2051
 ext4_mb_regular_allocator+0xbef/0x2090 fs/ext4/mballoc.c:2444
 ext4_mb_new_blocks+0x1da1/0x4730 fs/ext4/mballoc.c:4920
 ext4_ext_map_blocks+0x2320/0x61b0 fs/ext4/extents.c:4238
 ext4_map_blocks+0x7b8/0x1650 fs/ext4/inode.c:625
 ext4_getblk+0xad/0x530 fs/ext4/inode.c:832
 ext4_bread+0x7c/0x380 fs/ext4/inode.c:882
 ext4_append+0x15d/0x370 fs/ext4/namei.c:67
 ext4_init_new_dir fs/ext4/namei.c:2765 [inline]
 ext4_mkdir+0x5e0/0xdf0 fs/ext4/namei.c:2810
 vfs_mkdir+0x507/0x770 fs/namei.c:3649
 do_mkdirat+0x262/0x2d0 fs/namei.c:3672
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x449787
Code: 1f 40 00 b8 5a 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 ad 11 fc ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 b8 53 00 00 00 0f 05 <48> 3d 01 f0 ff ff 0f 83 8d 11 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffe59231c88 EFLAGS: 00000206 ORIG_RAX: 0000000000000053
RAX: ffffffffffffffda RBX: 000000000016b209 RCX: 0000000000449787
RDX: 00007ffe59231cf5 RSI: 00000000000001ff RDI: 00007ffe59231cf0
RBP: 00000000000003f6 R08: 0000000000000000 R09: 0000000000000005
R10: 0000000000000064 R11: 0000000000000206 R12: 0000000000000152
R13: 000000000040ae30 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
CR2: fffffc0068936230
---[ end trace 4b95ae1173d358ef ]---
RIP: 0010:update_pvclock_gtod arch/x86/kvm/x86.c:1741 [inline]
RIP: 0010:pvclock_gtod_notify+0xab/0x570 arch/x86/kvm/x86.c:7449
Code: ff 74 24 10 31 f6 41 b8 01 00 00 00 48 c7 c7 a8 20 eb 8b e8 f7 87 4e 00 48 89 da 58 48 b8 00 77 00 77 00 fc ff df 48 c1 ea 03 <80> 3c 02 00 0f 85 65 04 00 00 48 b8 00 00 00 00 00 fc ff df 48 8b
RSP: 0018:ffffc90000da8be8 EFLAGS: 00010806
RAX: dffffc0077007700 RBX: ffffffff8c975980 RCX: ffffffff815a184b
RDX: 1ffffffff192eb30 RSI: 0000000000000001 RDI: 0000000000000082
RBP: 0000000000010002 R08: 0000000000000000 R09: ffffffff8c5f5a1f
R10: fffffbfff18beb43 R11: 0000000000000001 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: ffffffff89ae98e0
FS:  00000000011af880(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffc0068936230 CR3: 0000000091e56000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
