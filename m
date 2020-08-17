Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C785247021
	for <lists+kvm@lfdr.de>; Mon, 17 Aug 2020 20:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389926AbgHQSCi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Aug 2020 14:02:38 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:33341 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390219AbgHQSC0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Aug 2020 14:02:26 -0400
Received: by mail-io1-f71.google.com with SMTP id k4so4304779iop.0
        for <kvm@vger.kernel.org>; Mon, 17 Aug 2020 11:02:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=tdstDYSYTI5mx+wadHLvUsUrcY6mmO9LIjUm2tyK4JE=;
        b=Bad5JXCRXwgD+FQAyqAoq6b1zUoor95d8SaHqLQbfbaSL7zPo1DxHxQ42CBrwxIPze
         dk7wQlTpwe3ZiCIqrS5i8JwcrAYgXDwJU2fA/lbv0G/qZT7g2Bnlo2Mmw8/3LxhIfa/C
         5FRhCaq4uhah34M276Y+1C8yLDoS+vPP5SgVhk3hSoQd4QvjtFNJXr3suGLG6gfTXx3I
         5RwXMu8xlSr2S2rwdA8UPXdQD1h87b7yp/Mj3nc+vIxjF/cWB6EEYaHw784ceAgOisir
         XFUZDgkI6eNTILjYhwDG0yliUR5/s4tPEQxA9owGboKIMal57YAW3Y5Bu00NFEPd4x/f
         bXpQ==
X-Gm-Message-State: AOAM533jyRYqzSZWNMafJjLVeQYAq+Uj8AZdcFfB+xI6ShiwRGrivfJA
        swH8ur35xOad0j/qPRKyUFOqW/qbFn91yRkNA+hKmRsFpv3k
X-Google-Smtp-Source: ABdhPJxEPSlkDU5ympvihcaPeuAhl+IcY8niForAvT0ZObG4abivk7xeG5W9PV/609tegxGpfi5tPf/+UB4bOtBe6EMfUuuvw5Vq
MIME-Version: 1.0
X-Received: by 2002:a92:c709:: with SMTP id a9mr13434633ilp.183.1597687345200;
 Mon, 17 Aug 2020 11:02:25 -0700 (PDT)
Date:   Mon, 17 Aug 2020 11:02:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ac45c705ad169245@google.com>
Subject: KASAN: use-after-free Write in paging32_walk_addr_generic
From:   syzbot <syzbot+47665dbce263479409c8@syzkaller.appspotmail.com>
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

HEAD commit:    9123e3a7 Linux 5.9-rc1
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1355e34a900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3d400a47d1416652
dashboard link: https://syzkaller.appspot.com/bug?extid=47665dbce263479409c8
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11e059f6900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=170f8ab4900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+47665dbce263479409c8@syzkaller.appspotmail.com

L1TF CPU bug present and SMT on, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.
==================================================================
BUG: KASAN: use-after-free in instrument_atomic_write include/linux/instrumented.h:71 [inline]
BUG: KASAN: use-after-free in paging32_cmpxchg_gpte arch/x86/kvm/mmu/paging_tmpl.h:181 [inline]
BUG: KASAN: use-after-free in paging32_update_accessed_dirty_bits arch/x86/kvm/mmu/paging_tmpl.h:287 [inline]
BUG: KASAN: use-after-free in paging32_walk_addr_generic+0x155d/0x1980 arch/x86/kvm/mmu/paging_tmpl.h:457
Write of size 4 at addr ffff888000105000 by task syz-executor735/6849

CPU: 1 PID: 6849 Comm: syz-executor735 Not tainted 5.9.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x497 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 check_memory_region_inline mm/kasan/generic.c:186 [inline]
 check_memory_region+0x13d/0x180 mm/kasan/generic.c:192
 instrument_atomic_write include/linux/instrumented.h:71 [inline]
 paging32_cmpxchg_gpte arch/x86/kvm/mmu/paging_tmpl.h:181 [inline]
 paging32_update_accessed_dirty_bits arch/x86/kvm/mmu/paging_tmpl.h:287 [inline]
 paging32_walk_addr_generic+0x155d/0x1980 arch/x86/kvm/mmu/paging_tmpl.h:457
 paging32_walk_addr arch/x86/kvm/mmu/paging_tmpl.h:514 [inline]
 paging32_gva_to_gpa+0xb2/0x1d0 arch/x86/kvm/mmu/paging_tmpl.h:958
 vcpu_mmio_gva_to_gpa arch/x86/kvm/x86.c:5758 [inline]
 emulator_read_write_onepage+0x2f3/0xa70 arch/x86/kvm/x86.c:5874
 emulator_read_write+0x1c4/0x5a0 arch/x86/kvm/x86.c:5934
 emulator_write_emulated arch/x86/kvm/x86.c:5971 [inline]
 emulator_fix_hypercall+0x132/0x190 arch/x86/kvm/x86.c:7763
 em_hypercall+0x5d/0x130 arch/x86/kvm/emulate.c:3803
 x86_emulate_insn+0x5e8/0x3d20 arch/x86/kvm/emulate.c:5676
 x86_emulate_instruction+0x752/0x1e00 arch/x86/kvm/x86.c:7017
 kvm_emulate_instruction arch/x86/kvm/x86.c:7085 [inline]
 handle_ud+0xa8/0x240 arch/x86/kvm/x86.c:5718
 handle_exception_nmi+0xaf7/0x1270 arch/x86/kvm/vmx/vmx.c:4761
 vmx_handle_exit+0x293/0x14c0 arch/x86/kvm/vmx/vmx.c:6118
 vcpu_enter_guest+0x14d6/0x3b60 arch/x86/kvm/x86.c:8641
 vcpu_run arch/x86/kvm/x86.c:8706 [inline]
 kvm_arch_vcpu_ioctl_run+0x440/0x1780 arch/x86/kvm/x86.c:8923
 kvm_vcpu_ioctl+0x467/0xdf0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3229
 vfs_ioctl fs/ioctl.c:48 [inline]
 __do_sys_ioctl fs/ioctl.c:753 [inline]
 __se_sys_ioctl fs/ioctl.c:739 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:739
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x443639
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 9b 0b fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffcf07dea38 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007ffcf07dea40 RCX: 0000000000443639
RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000006
RBP: 0000000000000000 R08: 0000000000000000 R09: 00000000004011b0
R10: 0000000000000012 R11: 0000000000000246 R12: 0000000000404660
R13: 00000000004046f0 R14: 0000000000000000 R15: 0000000000000000

The buggy address belongs to the page:
page:000000000c451483 refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x105
flags: 0x7ffe0000000000()
raw: 007ffe0000000000 ffffea0000004148 ffffea0000004148 0000000000000000
raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888000104f00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff888000104f80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>ffff888000105000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                   ^
 ffff888000105080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff888000105100: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
