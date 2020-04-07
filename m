Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 393181A1672
	for <lists+kvm@lfdr.de>; Tue,  7 Apr 2020 22:06:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727009AbgDGUGM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Apr 2020 16:06:12 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:39842 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726712AbgDGUGM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Apr 2020 16:06:12 -0400
Received: by mail-il1-f199.google.com with SMTP id w76so4425134ila.6
        for <kvm@vger.kernel.org>; Tue, 07 Apr 2020 13:06:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=bgYEBWfmH0kA57XYSEf+AoBhSDVD5mph5XsDaoG/2ag=;
        b=BMSpOO11p0D3DbYKmV3Rk8YcS6iYGvDhdRfUxr/2Uq7b5AHc8YdffQrjvNOwZRYhUm
         dq/4RmAtzEvWwf5n7zMbCrK9IcjkhPzK6Y+U4M9zsnTCL23d31JJGU3Ps4jQYBGIPWT+
         sRNyTcwCtB7hTZ04ZL8PQFpgErpfybvfxxSOmuThNtExgYWCnPHs9ndx3615gdzPL/a9
         cl2IP8DmNXnifjpbUQq1G68t9AlEDhqHowaprkDOe6YF2tumRQSzchlFHAyXF7lC3XFm
         Pk/8OTAf9xxJrwt69IVeayWrdT571phLkLPt6Lhp29iFLJ7iF0IeuqWrAuU+TDDA5I6p
         4opQ==
X-Gm-Message-State: AGi0PuYzFIK/0xFNeusUUJ1OCHZPWThG+vzkFhq8kPQ7c9CYzeOOgsxw
        8lJoh30ekkkgXPDgjcyPfaiW3DhjqHtrVy0bDUiX0gTQDD+A
X-Google-Smtp-Source: APiQypLrPyHpHLeoiQVAu7FCQGkgnrsgtbq02ZLWew3J4VM6mLjbOANR9AVW1FvnMzzCkHaW3IBDpeKhYqlOxsKLswCoxHbKwYlz
MIME-Version: 1.0
X-Received: by 2002:a92:869b:: with SMTP id l27mr4172910ilh.184.1586289970974;
 Tue, 07 Apr 2020 13:06:10 -0700 (PDT)
Date:   Tue, 07 Apr 2020 13:06:10 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003b14e805a2b8eaca@google.com>
Subject: KASAN: slab-out-of-bounds Read in __kvm_gfn_to_hva_cache_init
From:   syzbot <syzbot+d889b59b2bb87d4047a2@syzkaller.appspotmail.com>
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
console output: https://syzkaller.appspot.com/x/log.txt?x=179dec43e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=91b674b8f0368e69
dashboard link: https://syzkaller.appspot.com/bug?extid=d889b59b2bb87d4047a2
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=105c8733e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1446a72fe00000

The bug was bisected to:

commit 36947254e5f981aeeedab1c7dfa35fc34d330e80
Author: Sean Christopherson <sean.j.christopherson@intel.com>
Date:   Tue Feb 18 21:07:32 2020 +0000

    KVM: Dynamically size memslot array based on number of used slots

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14972c5de00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=16972c5de00000
console output: https://syzkaller.appspot.com/x/log.txt?x=12972c5de00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+d889b59b2bb87d4047a2@syzkaller.appspotmail.com
Fixes: 36947254e5f9 ("KVM: Dynamically size memslot array based on number of used slots")

L1TF CPU bug present and SMT on, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.
==================================================================
BUG: KASAN: slab-out-of-bounds in search_memslots include/linux/kvm_host.h:1051 [inline]
BUG: KASAN: slab-out-of-bounds in __gfn_to_memslot include/linux/kvm_host.h:1063 [inline]
BUG: KASAN: slab-out-of-bounds in __kvm_gfn_to_hva_cache_init+0x5fb/0x670 arch/x86/kvm/../../../virt/kvm/kvm_main.c:2443
Read of size 8 at addr ffff8880a70b1468 by task syz-executor080/7028

CPU: 1 PID: 7028 Comm: syz-executor080 Not tainted 5.6.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xd3/0x315 mm/kasan/report.c:374
 __kasan_report.cold+0x35/0x4d mm/kasan/report.c:503
 kasan_report+0x33/0x50 mm/kasan/common.c:648
 search_memslots include/linux/kvm_host.h:1051 [inline]
 __gfn_to_memslot include/linux/kvm_host.h:1063 [inline]
 __kvm_gfn_to_hva_cache_init+0x5fb/0x670 arch/x86/kvm/../../../virt/kvm/kvm_main.c:2443
 kvm_lapic_set_vapic_addr+0x88/0x180 arch/x86/kvm/lapic.c:2665
 kvm_arch_vcpu_ioctl+0xf0d/0x2c20 arch/x86/kvm/x86.c:4385
 kvm_vcpu_ioctl+0x866/0xe60 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3291
 vfs_ioctl fs/ioctl.c:47 [inline]
 ksys_ioctl+0x11a/0x180 fs/ioctl.c:763
 __do_sys_ioctl fs/ioctl.c:772 [inline]
 __se_sys_ioctl fs/ioctl.c:770 [inline]
 __x64_sys_ioctl+0x6f/0xb0 fs/ioctl.c:770
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x4401c9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffc2295e068 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 00000000004401c9
RDX: 0000000020000000 RSI: 000000004008ae93 RDI: 0000000000000005
RBP: 00000000006ca018 R08: 00000000004002c8 R09: 00000000004002c8
R10: 00000000004002c8 R11: 0000000000000246 R12: 0000000000401a50
R13: 0000000000401ae0 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 7028:
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
 vfs_ioctl fs/ioctl.c:47 [inline]
 ksys_ioctl+0x11a/0x180 fs/ioctl.c:763
 __do_sys_ioctl fs/ioctl.c:772 [inline]
 __se_sys_ioctl fs/ioctl.c:770 [inline]
 __x64_sys_ioctl+0x6f/0xb0 fs/ioctl.c:770
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3

Freed by task 0:
(stack is not available)

The buggy address belongs to the object at ffff8880a70b1000
 which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 1128 bytes inside of
 2048-byte region [ffff8880a70b1000, ffff8880a70b1800)
The buggy address belongs to the page:
page:ffffea00029c2c40 refcount:1 mapcount:0 mapping:0000000069244dce index:0x0
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea00024d90c8 ffffea00027c0ec8 ffff8880aa000e00
raw: 0000000000000000 ffff8880a70b1000 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880a70b1300: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff8880a70b1380: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff8880a70b1400: 00 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc
                                                          ^
 ffff8880a70b1480: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8880a70b1500: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
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
