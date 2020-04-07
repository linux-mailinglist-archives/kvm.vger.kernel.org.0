Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65F5B1A169E
	for <lists+kvm@lfdr.de>; Tue,  7 Apr 2020 22:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbgDGUQM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Apr 2020 16:16:12 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:57075 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgDGUQM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Apr 2020 16:16:12 -0400
Received: by mail-il1-f198.google.com with SMTP id 191so2991112ilb.23
        for <kvm@vger.kernel.org>; Tue, 07 Apr 2020 13:16:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=MKixdO/LHO5zNOYw5CGRi3f5if9rTuAUi0pE9jjQgkU=;
        b=DecKOTPUrnm+gpgfONgH1Japk3irGWbfxSxnedrj7A4z5iqe4Gp5aukl/S9h8w8NES
         nyvDV73fHSQiC2xUsBHVBnAwG2UerP2AmvHpPby85q4f3zQejKFpKK+JZ/vbXmb9b8ZM
         3rL5Q4FHYm5/p/xK2sfiBU4H8NF94voY1T1AVUwrMLNwjUeleyXFPCUWv8ju24RO0XYO
         nOzAlJHjhuDsBpL/4bQqr4EhSB0l5ElAuer4KZkDe5N+Ai37RZLYbX3kCf3E8zvN77jP
         Q/aBactY7lNlqPWH4DtcnxdahApRaJLXE00m1lkedT+VGj/dyd7ku1tKjppb+RtXKquM
         TEAg==
X-Gm-Message-State: AGi0PuZMQq+DEwzXWG9K5w6loqY1y2I/Ft381gplbhiYETGXlu/5SkvQ
        Ej6h94wOL1vBT2Y/M/pTEJsQ5Hs0RO5MNa41RL0D3ktidnhn
X-Google-Smtp-Source: APiQypIHk1d9Stn7Tqm6QNH2eDillIRAMEjcqUtVcC0ImfKG6x7zlVLSgL9tZGJDpAimoeSleziCYVhYh+bXrZS48o60pcKeKTXC
MIME-Version: 1.0
X-Received: by 2002:a5d:9142:: with SMTP id y2mr3733690ioq.185.1586290570863;
 Tue, 07 Apr 2020 13:16:10 -0700 (PDT)
Date:   Tue, 07 Apr 2020 13:16:10 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fca9a205a2b90dd6@google.com>
Subject: KASAN: slab-out-of-bounds Read in kvm_vcpu_gfn_to_memslot
From:   syzbot <syzbot+89a42836ac72e6a02d35@syzkaller.appspotmail.com>
To:     christoffer.dall@arm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, maz@kernel.org, pbonzini@redhat.com,
        peterx@redhat.com, sean.j.christopherson@intel.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    bef7b2a7 Merge tag 'devicetree-for-5.7' of git://git.kerne..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15ce12cde00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=91b674b8f0368e69
dashboard link: https://syzkaller.appspot.com/bug?extid=89a42836ac72e6a02d35
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14c69db7e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17b8b02be00000

The bug was bisected to:

commit 36947254e5f981aeeedab1c7dfa35fc34d330e80
Author: Sean Christopherson <sean.j.christopherson@intel.com>
Date:   Tue Feb 18 21:07:32 2020 +0000

    KVM: Dynamically size memslot array based on number of used slots

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15f1b1fbe00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=17f1b1fbe00000
console output: https://syzkaller.appspot.com/x/log.txt?x=13f1b1fbe00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+89a42836ac72e6a02d35@syzkaller.appspotmail.com
Fixes: 36947254e5f9 ("KVM: Dynamically size memslot array based on number of used slots")

L1TF CPU bug present and SMT on, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.
==================================================================
BUG: KASAN: slab-out-of-bounds in search_memslots include/linux/kvm_host.h:1051 [inline]
BUG: KASAN: slab-out-of-bounds in __gfn_to_memslot include/linux/kvm_host.h:1063 [inline]
BUG: KASAN: slab-out-of-bounds in kvm_vcpu_gfn_to_memslot+0x50e/0x540 arch/x86/kvm/../../../virt/kvm/kvm_main.c:1603
Read of size 8 at addr ffff88809e3bb468 by task syz-executor088/7241

CPU: 1 PID: 7241 Comm: syz-executor088 Not tainted 5.6.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xd3/0x315 mm/kasan/report.c:374
 __kasan_report.cold+0x35/0x4d mm/kasan/report.c:503
 kasan_report+0x33/0x50 mm/kasan/common.c:648
 search_memslots include/linux/kvm_host.h:1051 [inline]
 __gfn_to_memslot include/linux/kvm_host.h:1063 [inline]
 kvm_vcpu_gfn_to_memslot+0x50e/0x540 arch/x86/kvm/../../../virt/kvm/kvm_main.c:1603
 try_async_pf+0x12b/0xac0 arch/x86/kvm/mmu/mmu.c:4097
 direct_page_fault+0x27d/0x1d70 arch/x86/kvm/mmu/mmu.c:4146
 kvm_mmu_do_page_fault arch/x86/kvm/mmu.h:115 [inline]
 kvm_mmu_page_fault+0x187/0x15d0 arch/x86/kvm/mmu/mmu.c:5446
 vmx_handle_exit+0x2b8/0x1700 arch/x86/kvm/vmx/vmx.c:5953
 vcpu_enter_guest+0xfea/0x59d0 arch/x86/kvm/x86.c:8470
 vcpu_run arch/x86/kvm/x86.c:8533 [inline]
 kvm_arch_vcpu_ioctl_run+0x3fb/0x16a0 arch/x86/kvm/x86.c:8755
 kvm_vcpu_ioctl+0x493/0xe60 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3138
 vfs_ioctl fs/ioctl.c:47 [inline]
 ksys_ioctl+0x11a/0x180 fs/ioctl.c:763
 __do_sys_ioctl fs/ioctl.c:772 [inline]
 __se_sys_ioctl fs/ioctl.c:770 [inline]
 __x64_sys_ioctl+0x6f/0xb0 fs/ioctl.c:770
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x440209
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffd115ca0d8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440209
RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000005
RBP: 00000000006ca018 R08: 00000000004002c8 R09: 00000000004002c8
R10: 00000000004002c8 R11: 0000000000000246 R12: 0000000000401a90
R13: 0000000000401b20 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 7241:
 save_stack+0x1b/0x80 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 __kasan_kmalloc mm/kasan/common.c:518 [inline]
 __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:491
 kmalloc_node include/linux/slab.h:578 [inline]
 kvmalloc_node+0x61/0xf0 mm/util.c:574
 kvmalloc include/linux/mm.h:733 [inline]
 kvzalloc include/linux/mm.h:741 [inline]
 kvm_dup_memslots arch/x86/kvm/../../../virt/kvm/kvm_main.c:1101 [inline]
 kvm_set_memslot+0x115/0x1530 arch/x86/kvm/../../../virt/kvm/kvm_main.c:1118
 __kvm_set_memory_region+0xcf7/0x1320 arch/x86/kvm/../../../virt/kvm/kvm_main.c:1300
 kvm_set_memory_region+0x29/0x50 arch/x86/kvm/../../../virt/kvm/kvm_main.c:1321
 kvm_vm_ioctl_set_memory_region arch/x86/kvm/../../../virt/kvm/kvm_main.c:1333 [inline]
 kvm_vm_ioctl+0x678/0x23e0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3604
 vfs_ioctl fs/ioctl.c:47 [inline]
 ksys_ioctl+0x11a/0x180 fs/ioctl.c:763
 __do_sys_ioctl fs/ioctl.c:772 [inline]
 __se_sys_ioctl fs/ioctl.c:770 [inline]
 __x64_sys_ioctl+0x6f/0xb0 fs/ioctl.c:770
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3

Freed by task 0:
(stack is not available)

The buggy address belongs to the object at ffff88809e3bb000
 which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 1128 bytes inside of
 2048-byte region [ffff88809e3bb000, ffff88809e3bb800)
The buggy address belongs to the page:
page:ffffea000278eec0 refcount:1 mapcount:0 mapping:00000000c2601645 index:0x0
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea00027b1b08 ffff8880aa001950 ffff8880aa000e00
raw: 0000000000000000 ffff88809e3bb000 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88809e3bb300: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff88809e3bb380: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff88809e3bb400: 00 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc
                                                          ^
 ffff88809e3bb480: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88809e3bb500: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
