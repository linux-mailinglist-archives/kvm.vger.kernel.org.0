Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48AC641E7C1
	for <lists+kvm@lfdr.de>; Fri,  1 Oct 2021 08:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352339AbhJAGtI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Oct 2021 02:49:08 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:52850 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352342AbhJAGtD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Oct 2021 02:49:03 -0400
Received: by mail-io1-f70.google.com with SMTP id w9-20020a05660201c900b005d68070ebc1so7977984iot.19
        for <kvm@vger.kernel.org>; Thu, 30 Sep 2021 23:47:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=9LQI85QZ4f6rHbym/A6v93PSpTYGIavu9AuB8xELSZg=;
        b=oYUAWHgcKP5q5p/UNI7I9KQhDJmHDbQY3WLZWVpwVDW5fcDABp5nLOQgOszmzUtTNZ
         zQA4xCKUBVK9aFAyvjccppd4fqcCf381x5zmP0/YHPRxAurI0N0J9GNmM/Y5PHOD1kk+
         wFJA0EmF6y5YeMQC0R09i/1gntXlKZS7y61aJ098uTh42/ouvRM6uNdcZXdjJR/3mXij
         NmKL/QPF1dGCqm1aCmSU/Kbx5PlhITi+6knzepJMB4plaIzSYBSaJlgyVT5vmNHG7kTi
         y9G3mxyHS182WYLHJdUCx8kU6UjA9iH3bkiKbx3zBOxXBnJENsSveslzxIkhaGSUI2s4
         AcqQ==
X-Gm-Message-State: AOAM530Oi3oJ9o7C9wB7xOEGJWghZug5Cr6rd/5JML7epxYf9ARtkJN1
        x/wzJTrv8Pj63t8TBJLUx4jjYg6YY1DRRQ+kUL1BU/YwrKXr
X-Google-Smtp-Source: ABdhPJwDvSWHzbTqg3ENq28OtxXRK1m4Wx50j2sg0sKrDW3FM1tQBo7axJfvOO0hKj9ifurRv9N/0toKJgh3WdNdQvJk2+5ldPdv
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:178d:: with SMTP id y13mr7705236ilu.266.1633070839499;
 Thu, 30 Sep 2021 23:47:19 -0700 (PDT)
Date:   Thu, 30 Sep 2021 23:47:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000048342f05cd44efc0@google.com>
Subject: [syzbot] KMSAN: uninit-value in kvm_cpuid
From:   syzbot <syzbot+d6d011bc17bb751d4aa2@syzkaller.appspotmail.com>
To:     bp@alien8.de, dave.hansen@linux.intel.com, glider@google.com,
        hpa@zytor.com, jarkko@kernel.org, jmattson@google.com,
        joro@8bytes.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sgx@vger.kernel.org, mingo@redhat.com, pbonzini@redhat.com,
        seanjc@google.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, vkuznets@redhat.com, wanpengli@tencent.com,
        x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    cd2c05533838 DO-NOT-SUBMIT: kmsan: suppress a report in ke..
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=11373b17300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=978f1b2d7a5aad3e
dashboard link: https://syzkaller.appspot.com/bug?extid=d6d011bc17bb751d4aa2
compiler:       clang version 14.0.0 (git@github.com:llvm/llvm-project.git 0996585c8e3b3d409494eb5f1cad714b9e1f7fb5), GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14b6c4cb300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10fdb00f300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d6d011bc17bb751d4aa2@syzkaller.appspotmail.com

L1TF CPU bug present and SMT on, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.
=====================================================
BUG: KMSAN: uninit-value in cpuid_entry2_find arch/x86/kvm/cpuid.c:68 [inline]
BUG: KMSAN: uninit-value in kvm_find_cpuid_entry arch/x86/kvm/cpuid.c:1103 [inline]
BUG: KMSAN: uninit-value in kvm_cpuid+0x456/0x28f0 arch/x86/kvm/cpuid.c:1183
 cpuid_entry2_find arch/x86/kvm/cpuid.c:68 [inline]
 kvm_find_cpuid_entry arch/x86/kvm/cpuid.c:1103 [inline]
 kvm_cpuid+0x456/0x28f0 arch/x86/kvm/cpuid.c:1183
 kvm_vcpu_reset+0x13fb/0x1c20 arch/x86/kvm/x86.c:10885
 kvm_apic_accept_events+0x58f/0x8c0 arch/x86/kvm/lapic.c:2923
 vcpu_enter_guest+0xfd2/0x6d80 arch/x86/kvm/x86.c:9534
 vcpu_run+0x7f5/0x18d0 arch/x86/kvm/x86.c:9788
 kvm_arch_vcpu_ioctl_run+0x245b/0x2d10 arch/x86/kvm/x86.c:10020
 kvm_vcpu_ioctl+0x1055/0x1e00 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3749
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:874 [inline]
 __se_sys_ioctl+0x2df/0x4a0 fs/ioctl.c:860
 __x64_sys_ioctl+0xd8/0x110 fs/ioctl.c:860
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x54/0xd0 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Local variable ----dummy@kvm_vcpu_reset created at:
 kvm_vcpu_reset+0x1fb/0x1c20 arch/x86/kvm/x86.c:10812
 kvm_apic_accept_events+0x58f/0x8c0 arch/x86/kvm/lapic.c:2923
=====================================================
Kernel panic - not syncing: panic_on_kmsan set ...
CPU: 1 PID: 6364 Comm: syz-executor072 Tainted: G    B             5.15.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x1ff/0x28e lib/dump_stack.c:106
 dump_stack+0x25/0x28 lib/dump_stack.c:113
 panic+0x44f/0xdeb kernel/panic.c:232
 kmsan_report+0x2ee/0x300 mm/kmsan/report.c:186
 __msan_warning+0xd7/0x150 mm/kmsan/instrumentation.c:208
 cpuid_entry2_find arch/x86/kvm/cpuid.c:68 [inline]
 kvm_find_cpuid_entry arch/x86/kvm/cpuid.c:1103 [inline]
 kvm_cpuid+0x456/0x28f0 arch/x86/kvm/cpuid.c:1183
 kvm_vcpu_reset+0x13fb/0x1c20 arch/x86/kvm/x86.c:10885
 kvm_apic_accept_events+0x58f/0x8c0 arch/x86/kvm/lapic.c:2923
 vcpu_enter_guest+0xfd2/0x6d80 arch/x86/kvm/x86.c:9534
 vcpu_run+0x7f5/0x18d0 arch/x86/kvm/x86.c:9788
 kvm_arch_vcpu_ioctl_run+0x245b/0x2d10 arch/x86/kvm/x86.c:10020
 kvm_vcpu_ioctl+0x1055/0x1e00 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3749
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:874 [inline]
 __se_sys_ioctl+0x2df/0x4a0 fs/ioctl.c:860
 __x64_sys_ioctl+0xd8/0x110 fs/ioctl.c:860
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x54/0xd0 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f51eb544a19
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 b1 14 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe2fe74dc8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f51eb544a19
RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000005
RBP: 0000000000000000 R08: 0000000000000000 R09: 00007ffe2fe74f68
R10: 0000000000009120 R11: 0000000000000246 R12: 00007f51eb507c80
R13: 431bde82d7b634db R14: 0000000000000000 R15: 0000000000000000
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
