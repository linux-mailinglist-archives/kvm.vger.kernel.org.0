Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08BAA1A169F
	for <lists+kvm@lfdr.de>; Tue,  7 Apr 2020 22:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbgDGUQM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Apr 2020 16:16:12 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:34309 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726719AbgDGUQM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Apr 2020 16:16:12 -0400
Received: by mail-il1-f199.google.com with SMTP id b14so4487309ilb.1
        for <kvm@vger.kernel.org>; Tue, 07 Apr 2020 13:16:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Y1HsYdwbzzxLxaSNervbQ0xrzC6dYeEBfHnEhnfgEcI=;
        b=dcDvgg1zHy6yxmoKmeW7HG7KXS4p9AR5TH6LpdchkZeFMZ41CYu6CpOeqhZ54oZ6rY
         umCv8TR/UA5PrDlQ3dXKxlf2y/paCe8rY9pKGQnm/oXByubT1pz0KLq/phC5R+FmGgFl
         8SMKngsGNUKIsGekrv2qu00yIS7qKJP6AEs3FjtwVZkvXZFGDWAOOMK4S1Ex24U0NyRr
         WPrMFDvJD+iuUsML9z4pTPeZOZnKPKt5AvBy0mVwj6/P4SImqmG7VDwWNklVxGzMsPwI
         ArUsNUb0EHGHnJoZK8arCWRPKj2ENYpRZHrdpAUbWyAQyj0Czy2x6kdsDQAijPjz0XZe
         Bo7g==
X-Gm-Message-State: AGi0PuazJOWxzja7l3W8qrQhsf80vw8+RTRoIJqqCxc8j4jrzjXYvm6C
        QhfWJWyoGaSqZyO4Ypnr9XvcI2//Wex8HfuCi8PqNAwu3yxA
X-Google-Smtp-Source: APiQypLJX7+pIZCPl+4uCQYnCSc3m1SmiM5id1ljBPaFzs57HwMGr45n4HxEjX8rJ8HbcKAfoyz27tnZslh7n5bYcInGyolGEf65
MIME-Version: 1.0
X-Received: by 2002:a92:1d4b:: with SMTP id d72mr4373589ild.14.1586290571196;
 Tue, 07 Apr 2020 13:16:11 -0700 (PDT)
Date:   Tue, 07 Apr 2020 13:16:11 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000001be5205a2b90e71@google.com>
Subject: KASAN: slab-out-of-bounds Read in __kvm_map_gfn
From:   syzbot <syzbot+516667c144d77aa5ba3c@syzkaller.appspotmail.com>
To:     alex.shi@linux.alibaba.com, armijn@tjaldur.nl,
        gregkh@linuxfoundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        rfontana@redhat.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    bef7b2a7 Merge tag 'devicetree-for-5.7' of git://git.kerne..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12672c5de00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=91b674b8f0368e69
dashboard link: https://syzkaller.appspot.com/bug?extid=516667c144d77aa5ba3c
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
userspace arch: i386
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1217010be00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=106c8febe00000

The bug was bisected to:

commit 3a00e7c47c382b30524e78b36ab047c16b8fcfef
Author: Alex Shi <alex.shi@linux.alibaba.com>
Date:   Tue Jan 21 08:34:05 2020 +0000

    ida: remove abandoned macros

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11c1efdbe00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=13c1efdbe00000
console output: https://syzkaller.appspot.com/x/log.txt?x=15c1efdbe00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+516667c144d77aa5ba3c@syzkaller.appspotmail.com
Fixes: 3a00e7c47c38 ("ida: remove abandoned macros")

L1TF CPU bug present and SMT on, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.
==================================================================
BUG: KASAN: slab-out-of-bounds in search_memslots include/linux/kvm_host.h:1051 [inline]
BUG: KASAN: slab-out-of-bounds in __gfn_to_memslot include/linux/kvm_host.h:1063 [inline]
BUG: KASAN: slab-out-of-bounds in __kvm_map_gfn+0x933/0xa10 arch/x86/kvm/../../../virt/kvm/kvm_main.c:2060
Read of size 8 at addr ffff88808e20b468 by task syz-executor368/7090

CPU: 0 PID: 7090 Comm: syz-executor368 Not tainted 5.6.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xd3/0x315 mm/kasan/report.c:374
 __kasan_report.cold+0x35/0x4d mm/kasan/report.c:503
 kasan_report+0x33/0x50 mm/kasan/common.c:648
 search_memslots include/linux/kvm_host.h:1051 [inline]
 __gfn_to_memslot include/linux/kvm_host.h:1063 [inline]
 __kvm_map_gfn+0x933/0xa10 arch/x86/kvm/../../../virt/kvm/kvm_main.c:2060
 kvm_steal_time_set_preempted arch/x86/kvm/x86.c:3609 [inline]
 kvm_arch_vcpu_put+0x3b9/0x530 arch/x86/kvm/x86.c:3642
 vcpu_put+0x1b/0x70 arch/x86/kvm/../../../virt/kvm/kvm_main.c:220
 kvm_arch_vcpu_ioctl+0x1ae/0x2c20 arch/x86/kvm/x86.c:4620
 kvm_vcpu_ioctl+0x866/0xe60 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3291
 kvm_vcpu_compat_ioctl+0x1ab/0x350 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3334
 __do_compat_sys_ioctl fs/ioctl.c:857 [inline]
 __se_compat_sys_ioctl fs/ioctl.c:808 [inline]
 __ia32_compat_sys_ioctl+0x23d/0x2b0 fs/ioctl.c:808
 do_syscall_32_irqs_on arch/x86/entry/common.c:337 [inline]
 do_fast_syscall_32+0x270/0xe90 arch/x86/entry/common.c:396
 entry_SYSENTER_compat+0x70/0x7f arch/x86/entry/entry_64_compat.S:139

Allocated by task 7090:
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
 __x86_set_memory_region+0x2a3/0x5a0 arch/x86/kvm/x86.c:9845
 alloc_apic_access_page arch/x86/kvm/vmx/vmx.c:3544 [inline]
 vmx_create_vcpu+0x2107/0x2b40 arch/x86/kvm/vmx/vmx.c:6772
 kvm_arch_vcpu_create+0x6ef/0xb80 arch/x86/kvm/x86.c:9365
 kvm_vm_ioctl_create_vcpu arch/x86/kvm/../../../virt/kvm/kvm_main.c:3030 [inline]
 kvm_vm_ioctl+0x15f7/0x23e0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3585
 kvm_vm_compat_ioctl+0x125/0x240 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3798
 __do_compat_sys_ioctl fs/ioctl.c:857 [inline]
 __se_compat_sys_ioctl fs/ioctl.c:808 [inline]
 __ia32_compat_sys_ioctl+0x23d/0x2b0 fs/ioctl.c:808
 do_syscall_32_irqs_on arch/x86/entry/common.c:337 [inline]
 do_fast_syscall_32+0x270/0xe90 arch/x86/entry/common.c:396
 entry_SYSENTER_compat+0x70/0x7f arch/x86/entry/entry_64_compat.S:139

Freed by task 0:
(stack is not available)

The buggy address belongs to the object at ffff88808e20b000
 which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 1128 bytes inside of
 2048-byte region [ffff88808e20b000, ffff88808e20b800)
The buggy address belongs to the page:
page:ffffea00023882c0 refcount:1 mapcount:0 mapping:00000000044fe846 index:0x0
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea00027cbcc8 ffffea0002591e08 ffff8880aa000e00
raw: 0000000000000000 ffff88808e20b000 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88808e20b300: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff88808e20b380: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff88808e20b400: 00 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc
                                                          ^
 ffff88808e20b480: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88808e20b500: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
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
