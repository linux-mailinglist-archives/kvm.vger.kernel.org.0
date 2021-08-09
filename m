Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA5A3E4E36
	for <lists+kvm@lfdr.de>; Mon,  9 Aug 2021 23:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236244AbhHIVCq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 17:02:46 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:39551 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbhHIVCo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Aug 2021 17:02:44 -0400
Received: by mail-io1-f70.google.com with SMTP id u22-20020a5d9f560000b02905058dc6c376so13180394iot.6
        for <kvm@vger.kernel.org>; Mon, 09 Aug 2021 14:02:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=VGe3Z5M4JpJQGp07PVsxWzU3in6lwjZc9g6V+3kwV5s=;
        b=nyB2YjwGM1YpWgfRbrLC9WuLmygQgdh8v7UbFRYyTAkPFGGoIHgBFmqmQ+u6h+pRc7
         YcBYnTtis5qDCYkvgPqrCRNj38HlUfp9db1cfHmwRhA6Z3CZZ6WeaynzQGFfVq0Iphl6
         VhuBl+GEDbWKdV5AHaZzFqi7CzZaDamHiR9Y2ADL7mKfLuoV/8hO5Q6Jt9FhaTW4S+2i
         pl3x/uFaP7E/mNHLwGtlc7OFVv5YMrGgtz7usdzBLZvbdfh0sz83fSKLZYjINaGoRoVD
         X/dgBBE4jNE3JLGPjYAgIVhxTNq5ZAS5s/7OL6xW0mJfhfwlDvaN5ekLCGvIs7JyJwDF
         8PLQ==
X-Gm-Message-State: AOAM533hCXuydBy7pexgbAk78w2YHdEU/IrocijtBFOqRfwLYYz1HlPn
        VjwLnShFond+6wCzUwe0EMS5A2s1+o5EWX+1jW/AeuHHQ4Kv
X-Google-Smtp-Source: ABdhPJy2mpVy0vGDnE8XXuXP8CkA/Nh9fDV41Lbp9RhnbI9FunWT9fAkZM+tztzsVgB88xupeuMvpUr2T99kJLajF8mM70p0G3cm
MIME-Version: 1.0
X-Received: by 2002:a92:d3c7:: with SMTP id c7mr614438ilh.59.1628542942901;
 Mon, 09 Aug 2021 14:02:22 -0700 (PDT)
Date:   Mon, 09 Aug 2021 14:02:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009cfcda05c926b34b@google.com>
Subject: [syzbot] kernel BUG in find_lock_entries
From:   syzbot <syzbot+c87be4f669d920c76330@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, bp@alien8.de, frederic@kernel.org,
        hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, mark.rutland@arm.com, masahiroy@kernel.org,
        mingo@redhat.com, npiggin@gmail.com, pbonzini@redhat.com,
        peterz@infradead.org, rafael.j.wysocki@intel.com,
        rostedt@goodmis.org, seanjc@google.com, sedat.dilek@gmail.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vitor@massaru.org, vkuznets@redhat.com, wanpengli@tencent.com,
        will@kernel.org, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    902e7f373fff Merge tag 'net-5.14-rc5' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15337cd6300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=702bfdfbf389c324
dashboard link: https://syzkaller.appspot.com/bug?extid=c87be4f669d920c76330
compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=157afce9300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=152fc43a300000

The issue was bisected to:

commit 997acaf6b4b59c6a9c259740312a69ea549cc684
Author: Mark Rutland <mark.rutland@arm.com>
Date:   Mon Jan 11 15:37:07 2021 +0000

    lockdep: report broken irq restoration

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=137296e6300000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=10f296e6300000
console output: https://syzkaller.appspot.com/x/log.txt?x=177296e6300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c87be4f669d920c76330@syzkaller.appspotmail.com
Fixes: 997acaf6b4b5 ("lockdep: report broken irq restoration")

 __pagevec_release+0x7d/0xf0 mm/swap.c:992
 pagevec_release include/linux/pagevec.h:81 [inline]
 shmem_undo_range+0x5da/0x1a60 mm/shmem.c:931
 shmem_truncate_range mm/shmem.c:1030 [inline]
 shmem_setattr+0x4f0/0x890 mm/shmem.c:1091
 notify_change+0xbb8/0x1060 fs/attr.c:398
 do_truncate fs/open.c:64 [inline]
 vfs_truncate+0x6be/0x880 fs/open.c:112
 do_sys_truncate fs/open.c:135 [inline]
 __do_sys_truncate fs/open.c:147 [inline]
 __se_sys_truncate fs/open.c:145 [inline]
 __x64_sys_truncate+0x110/0x1b0 fs/open.c:145
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
------------[ cut here ]------------
kernel BUG at mm/filemap.c:2041!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 24786 Comm: syz-executor626 Not tainted 5.14.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:find_lock_entries+0x10d5/0x1110 mm/filemap.c:2041
Code: e8 00 3d d8 ff 4c 89 e7 48 c7 c6 20 70 39 8a e8 71 bf 0d 00 0f 0b e8 ea 3c d8 ff 4c 89 e7 48 c7 c6 40 62 39 8a e8 5b bf 0d 00 <0f> 0b e8 d4 3c d8 ff 4c 89 e7 48 c7 c6 80 6a 39 8a e8 45 bf 0d 00
RSP: 0018:ffffc9000a52f7e0 EFLAGS: 00010246
RAX: c75c992acedb0700 RBX: 0000000000000001 RCX: ffff8880161ab880
RDX: 0000000000000000 RSI: 000000000000ffff RDI: 000000000000ffff
RBP: ffffc9000a52f930 R08: ffffffff81d080d4 R09: ffffed1017383f24
R10: ffffed1017383f24 R11: 0000000000000000 R12: ffffea0000f40000
R13: 0000000000001000 R14: fffffffffffffffe R15: 0000000000001140
FS:  00007f1334d1f700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007faaa593a000 CR3: 00000000165b1000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 shmem_undo_range+0x1ea/0x1a60 mm/shmem.c:910
 shmem_truncate_range mm/shmem.c:1030 [inline]
 shmem_setattr+0x4f0/0x890 mm/shmem.c:1091
 notify_change+0xbb8/0x1060 fs/attr.c:398
 do_truncate fs/open.c:64 [inline]
 vfs_truncate+0x6be/0x880 fs/open.c:112
 do_sys_truncate fs/open.c:135 [inline]
 __do_sys_truncate fs/open.c:147 [inline]
 __se_sys_truncate fs/open.c:145 [inline]
 __x64_sys_truncate+0x110/0x1b0 fs/open.c:145
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x44a9a9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 71 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f1334d1f208 EFLAGS: 00000246 ORIG_RAX: 000000000000004c
RAX: ffffffffffffffda RBX: 00000000004cb4f8 RCX: 000000000044a9a9
RDX: 00007f1334d1f700 RSI: 0000000000000001 RDI: 0000000020000340
RBP: 00000000004cb4f0 R08: 00007f1334d1f700 R09: 0000000000000000
R10: 00007f1334d1f700 R11: 0000000000000246 R12: 00000000004cb4fc
R13: 00007ffdec06b36f R14: 00007f1334d1f300 R15: 0000000000022000
Modules linked in:
---[ end trace 4dcd0c81778c7d51 ]---
RIP: 0010:find_lock_entries+0x10d5/0x1110 mm/filemap.c:2041
Code: e8 00 3d d8 ff 4c 89 e7 48 c7 c6 20 70 39 8a e8 71 bf 0d 00 0f 0b e8 ea 3c d8 ff 4c 89 e7 48 c7 c6 40 62 39 8a e8 5b bf 0d 00 <0f> 0b e8 d4 3c d8 ff 4c 89 e7 48 c7 c6 80 6a 39 8a e8 45 bf 0d 00
RSP: 0018:ffffc9000a52f7e0 EFLAGS: 00010246
RAX: c75c992acedb0700 RBX: 0000000000000001 RCX: ffff8880161ab880
RDX: 0000000000000000 RSI: 000000000000ffff RDI: 000000000000ffff
RBP: ffffc9000a52f930 R08: ffffffff81d080d4 R09: ffffed1017383f24
R10: ffffed1017383f24 R11: 0000000000000000 R12: ffffea0000f40000
R13: 0000000000001000 R14: fffffffffffffffe R15: 0000000000001140
FS:  00007f1334d1f700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000557a29364160 CR3: 00000000165b1000 CR4: 00000000001506f0
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
