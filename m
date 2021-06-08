Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06B0339FC74
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 18:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233848AbhFHQ0k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 12:26:40 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:44913 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233850AbhFHQ03 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 12:26:29 -0400
Received: by mail-il1-f198.google.com with SMTP id h6-20020a92c0860000b02901e0cde08c7fso15330696ile.11
        for <kvm@vger.kernel.org>; Tue, 08 Jun 2021 09:24:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=F8gbEAtIKH74oMo+imFQdqLcR6x0tXM3skYvyhbCelY=;
        b=UxQd6Ot4LtYe/MW67JCb5zZRvfg3+M3hx8UAKh/BK5FmoxGQj5JTBdVoyRIcK3LE9I
         4g2pfBQbx3ztmvX09gplF1jwloIKQQYoPHI71rdbsFJYuXfO+GNxKANOx/6OGnB/bHPs
         PGsxHTmZE4iHt9vMFVDTGJYFlj0nANlIPWPX05OtojYuf3/XrvU/u5RQ9kf6LrmxCUv7
         xpquHUj86YJUQjJ8frE7071euXsl+a7X2jmITdPkTgH4/0eHIQlKjGI3FIAlKTNq7mU7
         aw7xrtgTeH9vVrBLKLWabzKXFUYTicTBwOzUnaXvLdxcyBCJrXX1+Sm1WwPRxvVxbp8h
         bcGQ==
X-Gm-Message-State: AOAM531lj29VWX295ErPERamxdOEjctIxMLrQHQ/721jfV6I2PXHOKHu
        FGjQeGDvYNFzh0XW4Mshxk13QyJhZPwViWGGbGmESwzk0e0j
X-Google-Smtp-Source: ABdhPJyf3UTQ4+rSnPiWjycn/q+pLKnWFXkKnEPvh/QMU6FNTG+rE9qw2iw36m+2CwRTkWoUUWhaOuo9EPm+QsdwGw57VoDj7Gpz
MIME-Version: 1.0
X-Received: by 2002:a02:c987:: with SMTP id b7mr9582241jap.129.1623169465760;
 Tue, 08 Jun 2021 09:24:25 -0700 (PDT)
Date:   Tue, 08 Jun 2021 09:24:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006ac02a05c44397fb@google.com>
Subject: [syzbot] general protection fault in gfn_to_rmap (2)
From:   syzbot <syzbot+fb0b6a7e8713aeb0319c@syzkaller.appspotmail.com>
To:     bp@alien8.de, hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, seanjc@google.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    614124be Linux 5.13-rc5
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14a62298300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=547a5e42ca601229
dashboard link: https://syzkaller.appspot.com/bug?extid=fb0b6a7e8713aeb0319c
compiler:       Debian clang version 11.0.1-2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11395057d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12d2b797d00000

The issue was bisected to:

commit 9ec19493fb86d6d5fbf9286b94ff21e56ef66376
Author: Sean Christopherson <sean.j.christopherson@intel.com>
Date:   Tue Apr 2 15:03:11 2019 +0000

    KVM: x86: clear SMM flags before loading state while leaving SMM

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1437f9bbd00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1637f9bbd00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1237f9bbd00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+fb0b6a7e8713aeb0319c@syzkaller.appspotmail.com
Fixes: 9ec19493fb86 ("KVM: x86: clear SMM flags before loading state while leaving SMM")

L1TF CPU bug present and SMT on, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.
general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 1 PID: 8410 Comm: syz-executor382 Not tainted 5.13.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__gfn_to_rmap arch/x86/kvm/mmu/mmu.c:935 [inline]
RIP: 0010:gfn_to_rmap+0x2b0/0x4d0 arch/x86/kvm/mmu/mmu.c:947
Code: 00 00 00 00 00 fc ff df 48 8b 5c 24 10 48 8b 44 24 08 42 8a 04 20 84 c0 0f 85 a9 01 00 00 8b 2b 83 e5 0f 4c 89 f8 48 c1 e8 03 <42> 80 3c 20 00 74 08 4c 89 ff e8 f1 79 a9 00 4c 89 fb 4d 8b 37 44
RSP: 0018:ffffc90000ffef98 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff888015b9f414 RCX: ffff888019669c40
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000001
RBP: 0000000000000001 R08: ffffffff811d9cdb R09: ffffed10065a6002
R10: ffffed10065a6002 R11: 0000000000000000 R12: dffffc0000000000
R13: 0000000000000003 R14: 0000000000000001 R15: 0000000000000000
FS:  000000000124b300(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 0000000028e31000 CR4: 00000000001526e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 rmap_add arch/x86/kvm/mmu/mmu.c:965 [inline]
 mmu_set_spte+0x862/0xe60 arch/x86/kvm/mmu/mmu.c:2604
 __direct_map arch/x86/kvm/mmu/mmu.c:2862 [inline]
 direct_page_fault+0x1f74/0x2b70 arch/x86/kvm/mmu/mmu.c:3769
 kvm_mmu_do_page_fault arch/x86/kvm/mmu.h:124 [inline]
 kvm_mmu_page_fault+0x199/0x1440 arch/x86/kvm/mmu/mmu.c:5065
 vmx_handle_exit+0x26/0x160 arch/x86/kvm/vmx/vmx.c:6122
 vcpu_enter_guest+0x3bdd/0x9630 arch/x86/kvm/x86.c:9428
 vcpu_run+0x416/0xc20 arch/x86/kvm/x86.c:9494
 kvm_arch_vcpu_ioctl_run+0x4e8/0xa40 arch/x86/kvm/x86.c:9722
 kvm_vcpu_ioctl+0x70f/0xbb0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3460
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:1069 [inline]
 __se_sys_ioctl+0xfb/0x170 fs/ioctl.c:1055
 do_syscall_64+0x3f/0xb0 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x440ce9
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffeee792908 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 0000000000440ce9
RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000005
RBP: 00000000004047e0 R08: 0000000000400488 R09: 0000000000400488
R10: 0000000000400488 R11: 0000000000000246 R12: 0000000000404870
R13: 0000000000000000 R14: 00000000004b0018 R15: 0000000000400488
Modules linked in:
---[ end trace 41422839215ce938 ]---
RIP: 0010:__gfn_to_rmap arch/x86/kvm/mmu/mmu.c:935 [inline]
RIP: 0010:gfn_to_rmap+0x2b0/0x4d0 arch/x86/kvm/mmu/mmu.c:947
Code: 00 00 00 00 00 fc ff df 48 8b 5c 24 10 48 8b 44 24 08 42 8a 04 20 84 c0 0f 85 a9 01 00 00 8b 2b 83 e5 0f 4c 89 f8 48 c1 e8 03 <42> 80 3c 20 00 74 08 4c 89 ff e8 f1 79 a9 00 4c 89 fb 4d 8b 37 44
RSP: 0018:ffffc90000ffef98 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff888015b9f414 RCX: ffff888019669c40
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000001
RBP: 0000000000000001 R08: ffffffff811d9cdb R09: ffffed10065a6002
R10: ffffed10065a6002 R11: 0000000000000000 R12: dffffc0000000000
R13: 0000000000000003 R14: 0000000000000001 R15: 0000000000000000
FS:  000000000124b300(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 0000000028e31000 CR4: 00000000001526e0
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
