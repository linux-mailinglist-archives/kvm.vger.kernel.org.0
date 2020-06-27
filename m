Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 707A820C3F3
	for <lists+kvm@lfdr.de>; Sat, 27 Jun 2020 22:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbgF0UBP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 Jun 2020 16:01:15 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:39322 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbgF0UBO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 27 Jun 2020 16:01:14 -0400
Received: by mail-il1-f199.google.com with SMTP id f66so3533590ilh.6
        for <kvm@vger.kernel.org>; Sat, 27 Jun 2020 13:01:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Mvxz2KaB3q5DOPBNFkkKBK9pRd2aubCwIdLOx3Y8RO4=;
        b=ajMghjLeTxu9nzuIoGuxLcQAPmq8IiWamQ933GQuxf+kJbat2faUM2uI02dJrzxOj2
         ZglCOMvj2dskfB0yiTo/EOqJApM66sDO+hiPO7/GdZ0A0++4GRVZHx5WocoB/16ZlZ+1
         nVxb7haXYnjkDv+wpI90NH22lpXM4gufY2aMMAGwpoIS0AENnw1g/88B62SteWeVSPN9
         PzHPEspTN2CgySz5ULXSNWuv16Y9PfCe2sXSnzx5pqrVxkKKEc+zMLTce9hfaiVaETAi
         ckmwQ6kooq3xAH/1VfQMl62j8OZIuCvwdV4X98d/kz4g63ij6w8boEfAq5Axe5ybGW6Y
         tYjg==
X-Gm-Message-State: AOAM5310CmRTfGHU13OsNKCYQGksyhdFD/1nvB6Z1OcjOTBAP+w2kPiQ
        o/SoosdXzPJKb8CJVnHpzwfG1ibwE2QSv/1ruYdU2zmIBWnP
X-Google-Smtp-Source: ABdhPJzUz9k0v2AcmLVOka0OuJvm7c8FJgmZAcfy7/t2BpZbuz9mS5cTrHmA6m5ohhrWENBHuIyNzDpdYgl52/ln+tdm7DPgu0MJ
MIME-Version: 1.0
X-Received: by 2002:a02:1443:: with SMTP id 64mr9868582jag.43.1593288073178;
 Sat, 27 Jun 2020 13:01:13 -0700 (PDT)
Date:   Sat, 27 Jun 2020 13:01:13 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a0784a05a916495e@google.com>
Subject: KASAN: out-of-bounds Read in kvm_arch_hardware_setup
From:   syzbot <syzbot+e0240f9c36530bda7130@syzkaller.appspotmail.com>
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

syzbot found the following crash on:

HEAD commit:    7ae77150 Merge tag 'powerpc-5.8-1' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1654e385100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=be4578b3f1083656
dashboard link: https://syzkaller.appspot.com/bug?extid=e0240f9c36530bda7130
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15f3abc9100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=131b7bb5100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+e0240f9c36530bda7130@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: out-of-bounds in kvm_cpu_cap_get arch/x86/kvm/cpuid.h:292 [inline]
BUG: KASAN: out-of-bounds in kvm_cpu_cap_has arch/x86/kvm/cpuid.h:297 [inline]
BUG: KASAN: out-of-bounds in kvm_init_msr_list arch/x86/kvm/x86.c:5362 [inline]
BUG: KASAN: out-of-bounds in kvm_arch_hardware_setup+0xb05/0xf40 arch/x86/kvm/x86.c:9802
Read of size 4 at addr ffffffff896c3134 by task syz-executor614/6786

CPU: 1 PID: 6786 Comm: syz-executor614 Not tainted 5.7.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1e9/0x30e lib/dump_stack.c:118
 print_address_description+0x66/0x5a0 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report+0x132/0x1d0 mm/kasan/report.c:530
 kvm_cpu_cap_get arch/x86/kvm/cpuid.h:292 [inline]
 kvm_cpu_cap_has arch/x86/kvm/cpuid.h:297 [inline]
 kvm_init_msr_list arch/x86/kvm/x86.c:5362 [inline]
 kvm_arch_hardware_setup+0xb05/0xf40 arch/x86/kvm/x86.c:9802
 </IRQ>

The buggy address belongs to the variable:
 kvm_cpu_caps+0x24/0x50

Memory state around the buggy address:
 ffffffff896c3000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffffffff896c3080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffffffff896c3100: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                                        ^
 ffffffff896c3180: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffffffff896c3200: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
