Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC721A4895
	for <lists+kvm@lfdr.de>; Fri, 10 Apr 2020 18:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbgDJQjP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Apr 2020 12:39:15 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:51236 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbgDJQjP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Apr 2020 12:39:15 -0400
Received: by mail-il1-f199.google.com with SMTP id i13so2972982ilq.18
        for <kvm@vger.kernel.org>; Fri, 10 Apr 2020 09:39:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=KSqAUwDwDyJQutzLSA5XTX0c1kkdHrDY0G35vjvsMeA=;
        b=WhfemYvOxBOE+tJe7yuYOjw/LGqtVo/UzlBBEzHudFjFgu7J1AVaQhPDITiVdha/M3
         +ZhFCtrxe1b6Oy7kEJytP2X6ud7CXpdtjq7RBKZZYu/ROV4LxV15SPboDHCdY4Lg/ccq
         PDaAXX5GLZjbFI9ryyK3QGSKyYAHgIZ9G1kjYQWuM/VO1Y1vTO+hrjJIrtW99u0kDac8
         diBcmKYlSwUGk5+A/lBzlFrQZhCixRbJx+VD99VDMNxKWl7Rk1WcryMGvR+fEV67K4K+
         RIZEY8sT/2MoRbwFKarS6gy4bddKK+npIbUBhUUHv8OOmHRbh3wCmLJ0ATxDWDbNaQ7L
         n8Qg==
X-Gm-Message-State: AGi0Pub7j7Ssm47i8Z6gSQLc0PVuUD9IMxmxiHgw0BrReK38zdZwKOB4
        py+Cj5SJwkWPYaxe5/XIfzK/A4d3bC6toCA6z1I7F86nMROt
X-Google-Smtp-Source: APiQypJV6nY/48AeVYjZEZxM1WJMw5xadw7/VU0fKgJRhtLtHTRfaz63+uAKp4C6Mwy+jvxwTtHhPyI6QuG3UqKZP5uxMB3Yxo6L
MIME-Version: 1.0
X-Received: by 2002:a92:6f02:: with SMTP id k2mr2590315ilc.155.1586536752967;
 Fri, 10 Apr 2020 09:39:12 -0700 (PDT)
Date:   Fri, 10 Apr 2020 09:39:12 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000095762005a2f25f4d@google.com>
Subject: KASAN: slab-out-of-bounds Read in gfn_to_hva
From:   syzbot <syzbot+e06e0f40470ee2de4dda@syzkaller.appspotmail.com>
To:     christoffer.dall@arm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        peterx@redhat.com, sean.j.christopherson@intel.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    5d30bcac Merge tag '9p-for-5.7-2' of git://github.com/mart..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17243a9fe00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2a7f60f3313b353e
dashboard link: https://syzkaller.appspot.com/bug?extid=e06e0f40470ee2de4dda
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12b059afe00000

The bug was bisected to:

commit 5c0b4f3d5ccc2ced94b01c3256db1cf79dc95b81
Author: Sean Christopherson <sean.j.christopherson@intel.com>
Date:   Tue Feb 18 21:07:26 2020 +0000

    KVM: Move memslot deletion to helper function

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13d14de7e00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=10314de7e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=17d14de7e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+e06e0f40470ee2de4dda@syzkaller.appspotmail.com
Fixes: 5c0b4f3d5ccc ("KVM: Move memslot deletion to helper function")

==================================================================
BUG: KASAN: slab-out-of-bounds in search_memslots include/linux/kvm_host.h:1051 [inline]
BUG: KASAN: slab-out-of-bounds in __gfn_to_memslot include/linux/kvm_host.h:1063 [inline]
BUG: KASAN: slab-out-of-bounds in gfn_to_memslot arch/x86/kvm/../../../virt/kvm/kvm_main.c:1597 [inline]
BUG: KASAN: slab-out-of-bounds in gfn_to_hva+0x4a0/0x4c0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:1677
Read of size 8 at addr ffff88809422f468 by task syz-executor.0/8228

CPU: 0 PID: 8228 Comm: syz-executor.0 Not tainted 5.6.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xd3/0x315 mm/kasan/report.c:382
 __kasan_report.cold+0x35/0x4d mm/kasan/report.c:511
 kasan_report+0x33/0x50 mm/kasan/common.c:625
 search_memslots include/linux/kvm_host.h:1051 [inline]
 __gfn_to_memslot include/linux/kvm_host.h:1063 [inline]
 gfn_to_memslot arch/x86/kvm/../../../virt/kvm/kvm_main.c:1597 [inline]
 gfn_to_hva+0x4a0/0x4c0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:1677
 kvm_arch_mmu_notifier_invalidate_range+0x21/0x80 arch/x86/kvm/x86.c:8132
 kvm_mmu_notifier_invalidate_range_start+0x1a1/0x280 arch/x86/kvm/../../../virt/kvm/kvm_main.c:421
 mn_hlist_invalidate_range_start mm/mmu_notifier.c:493 [inline]
 __mmu_notifier_invalidate_range_start+0x4bc/0x6b0 mm/mmu_notifier.c:525
 mmu_notifier_invalidate_range_start include/linux/mmu_notifier.h:446 [inline]
 change_pmd_range mm/mprotect.c:247 [inline]
 change_pud_range mm/mprotect.c:297 [inline]
 change_p4d_range mm/mprotect.c:317 [inline]
 change_protection_range mm/mprotect.c:342 [inline]
 change_protection+0x1ed0/0x2710 mm/mprotect.c:365
 mprotect_fixup+0x46c/0x940 mm/mprotect.c:487
 do_mprotect_pkey+0x542/0x950 mm/mprotect.c:613
 __do_sys_mprotect mm/mprotect.c:638 [inline]
 __se_sys_mprotect mm/mprotect.c:635 [inline]
 __x64_sys_mprotect+0x74/0xb0 mm/mprotect.c:635
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x45c987
Code: 00 00 00 b8 0b 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 9d b5 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 b8 0a 00 00 00 0f 05 <48> 3d 01 f0 ff ff 0f 83 7d b5 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fffeb2b1198 EFLAGS: 00000246 ORIG_RAX: 000000000000000a
RAX: ffffffffffffffda RBX: 0000000000020000 RCX: 000000000045c987
RDX: 0000000000000000 RSI: 0000000000001000 RDI: 00007fb6ab53b000
RBP: 00007fffeb2b1280 R08: 00000000007217e0 R09: 00000000007217e0
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fffeb2b1370
R13: 00007fb6ab55b700 R14: 00007fb6ab55b9c0 R15: 000000000076bfac

Allocated by task 8229:
 save_stack+0x1b/0x40 mm/kasan/common.c:49
 set_track mm/kasan/common.c:57 [inline]
 __kasan_kmalloc mm/kasan/common.c:495 [inline]
 __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:468
 kmalloc_node include/linux/slab.h:578 [inline]
 kvmalloc_node+0x61/0xf0 mm/util.c:574
 kvmalloc include/linux/mm.h:739 [inline]
 kvzalloc include/linux/mm.h:747 [inline]
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

Freed by task 7060:
 save_stack+0x1b/0x40 mm/kasan/common.c:49
 set_track mm/kasan/common.c:57 [inline]
 kasan_set_free_info mm/kasan/common.c:317 [inline]
 __kasan_slab_free+0xf7/0x140 mm/kasan/common.c:456
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x109/0x2b0 mm/slab.c:3757
 kvfree+0x42/0x50 mm/util.c:603
 __do_replace+0x6a3/0x8c0 net/ipv6/netfilter/ip6_tables.c:1104
 do_replace net/ipv6/netfilter/ip6_tables.c:1157 [inline]
 do_ip6t_set_ctl+0x2e8/0x457 net/ipv6/netfilter/ip6_tables.c:1681
 nf_sockopt net/netfilter/nf_sockopt.c:106 [inline]
 nf_setsockopt+0x6f/0xc0 net/netfilter/nf_sockopt.c:115
 ipv6_setsockopt net/ipv6/ipv6_sockglue.c:955 [inline]
 ipv6_setsockopt+0x145/0x180 net/ipv6/ipv6_sockglue.c:939
 tcp_setsockopt net/ipv4/tcp.c:3167 [inline]
 tcp_setsockopt+0x86/0xd0 net/ipv4/tcp.c:3161
 __sys_setsockopt+0x248/0x480 net/socket.c:2132
 __do_sys_setsockopt net/socket.c:2148 [inline]
 __se_sys_setsockopt net/socket.c:2145 [inline]
 __x64_sys_setsockopt+0xba/0x150 net/socket.c:2145
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3

The buggy address belongs to the object at ffff88809422f000
 which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 1128 bytes inside of
 2048-byte region [ffff88809422f000, ffff88809422f800)
The buggy address belongs to the page:
page:ffffea0002508bc0 refcount:1 mapcount:0 mapping:00000000fcfbb453 index:0x0
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea0002901648 ffffea00028c9d08 ffff8880aa000e00
raw: 0000000000000000 ffff88809422f000 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88809422f300: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff88809422f380: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff88809422f400: 00 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc
                                                          ^
 ffff88809422f480: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88809422f500: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
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
