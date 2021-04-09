Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3822A35A51F
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 19:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234349AbhDIR73 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Apr 2021 13:59:29 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:47792 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234049AbhDIR72 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Apr 2021 13:59:28 -0400
Received: by mail-il1-f197.google.com with SMTP id h21so3973591ila.14
        for <kvm@vger.kernel.org>; Fri, 09 Apr 2021 10:59:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=0+Ew6rNNg3ztpKhQhG/z/BAPWHH+xWvZmjOvCb1fdu8=;
        b=TUwjWCilEs+eo5MhdsaGsL8G99HcjZtiFcdXldNddEEDPzaMivmqGfZT5szIgj6bdr
         x4jZG3nNCZZ67LK6mKwyXuxxU2MDvNhjkiy25zVeFL8vH0/5Kaq+1RCTshpO3EeQ6bJd
         jxojWt3i26SE7ydzAVKeGku34zLP6RSlW0Kxo2q4GjzO2DEPSZsHiFTRltQjfXIgcIi/
         LjOrQOVHOgiSuuXGCu7aAoKKClSyTpIwdEG25TjlF31Uni6nIM+FBk4oJcflvHRVnu9V
         BVy70Q4AQqv2bCUtFIwKyZQyUDvz6/QW9MGT0YZyHN5GBsLoTuPakgCRHMYfilPSRJo6
         AiGQ==
X-Gm-Message-State: AOAM533PK4xTvq6GrQ5dz1O/OGrGJK00pLmTpy/lnPhGmdhL5PpM51jY
        oKT3hlQ9wA2HlzYXNn0SY+YguK4+7jnh57DWsacXDvI6sshl
X-Google-Smtp-Source: ABdhPJzkQ8GpqnpBVrEegTqvzPxggMdUSz72bWw5uFKXrGcQBqAvYcvPw96M9nSuvyJIMq+fJ1pLRoxWv7LEAw2mn8I7p7x6vJjO
MIME-Version: 1.0
X-Received: by 2002:a02:c908:: with SMTP id t8mr15943562jao.78.1617991155447;
 Fri, 09 Apr 2021 10:59:15 -0700 (PDT)
Date:   Fri, 09 Apr 2021 10:59:15 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000012002d05bf8dec8d@google.com>
Subject: [syzbot] BUG: spinlock bad magic in erofs_pcpubuf_growsize
From:   syzbot <syzbot+d6a0e4b80bd39f54c2f6@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, bp@alien8.de, chao@kernel.org,
        hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-erofs@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, mark.rutland@arm.com,
        masahiroy@kernel.org, mingo@redhat.com, pbonzini@redhat.com,
        peterz@infradead.org, rafael.j.wysocki@intel.com,
        rostedt@goodmis.org, seanjc@google.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, will@kernel.org,
        x86@kernel.org, xiang@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    9c54130c Add linux-next specific files for 20210406
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1654617ed00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d125958c3995ddcd
dashboard link: https://syzkaller.appspot.com/bug?extid=d6a0e4b80bd39f54c2f6
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=101a5786d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1147dd0ed00000

The issue was bisected to:

commit 997acaf6b4b59c6a9c259740312a69ea549cc684
Author: Mark Rutland <mark.rutland@arm.com>
Date:   Mon Jan 11 15:37:07 2021 +0000

    lockdep: report broken irq restoration

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11d8d7aad00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=13d8d7aad00000
console output: https://syzkaller.appspot.com/x/log.txt?x=15d8d7aad00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d6a0e4b80bd39f54c2f6@syzkaller.appspotmail.com
Fixes: 997acaf6b4b5 ("lockdep: report broken irq restoration")

loop0: detected capacity change from 0 to 31
BUG: spinlock bad magic on CPU#1, syz-executor062/8434
 lock: 0xffff8880b9c31d60, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
CPU: 1 PID: 8434 Comm: syz-executor062 Not tainted 5.12.0-rc6-next-20210406-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 debug_spin_lock_before kernel/locking/spinlock_debug.c:83 [inline]
 do_raw_spin_lock+0x216/0x2b0 kernel/locking/spinlock_debug.c:112
 erofs_pcpubuf_growsize+0x36f/0x620 fs/erofs/pcpubuf.c:83
 z_erofs_load_lz4_config+0x1ef/0x3e0 fs/erofs/decompressor.c:64
 erofs_read_superblock fs/erofs/super.c:331 [inline]
 erofs_fc_fill_super+0xe84/0x1d10 fs/erofs/super.c:499
 get_tree_bdev+0x440/0x760 fs/super.c:1293
 vfs_get_tree+0x89/0x2f0 fs/super.c:1498
 do_new_mount fs/namespace.c:2905 [inline]
 path_mount+0x132a/0x1fa0 fs/namespace.c:3235
 do_mount fs/namespace.c:3248 [inline]
 __do_sys_mount fs/namespace.c:3456 [inline]
 __se_sys_mount fs/namespace.c:3433 [inline]
 __x64_sys_mount+0x27f/0x300 fs/namespace.c:3433
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x444f7a
Code: 83 c4 08 5b 5d c3 66 2e 0f 1f 84 00 00 00 00 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe1fa3c2a8 EFLAGS: 00000286 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffe1fa3c300 RCX: 0000000000444f7a
RDX: 0000000020000000 RSI: 0000000020000100 RDI: 00007ffe1fa3c2c0
RBP: 00007ffe1fa3c2c0 R08: 00007ffe1fa3c300 R09: 


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
