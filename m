Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 498FD4102B9
	for <lists+kvm@lfdr.de>; Sat, 18 Sep 2021 03:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235031AbhIRBi2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Sep 2021 21:38:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230393AbhIRBiY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Sep 2021 21:38:24 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AD9CC061574;
        Fri, 17 Sep 2021 18:37:02 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id bb10so7329749plb.2;
        Fri, 17 Sep 2021 18:37:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=oGhHOU+/gcGTeyUbIMMfpc4ORIcrYhZC2Z5o775DyuE=;
        b=OwCz/B0hrLbwnT35U5f2Y65iLVGCQzAKUyhhDqfDU/IUaW//VC08GmDptSSBDr6UhN
         F7Tnq4s+GVkIWNXek1dr/vkITUsjK10BXsZdrntUgB7jMNY2EJ6edwdEgw5X2n97/Ui4
         CfStkW+n+PAsogl2pCBBvDNSb49WQOt9CEX9RC1zy9FV5RYx1Hrrj6OaPeBtxopVtTgR
         y99CKiAI09d6TAhxTruhOgnZc6uuRtYqWii44NEzpWuiuvSEZq2Cz3cg54MHA2rSVAt/
         WGD3FXUCpb/k8q45+EgN+V6X0+WDayZDnH3wVuxNLGImS8K0uP2P+0kUuciMlTMdk5eM
         VySA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=oGhHOU+/gcGTeyUbIMMfpc4ORIcrYhZC2Z5o775DyuE=;
        b=Qs/H21aBgjkkRnS9oSfcjqaSi4S6j0bo6tqrMifbPK5SXW5HjInXvyEEfL0xpar0Ob
         KprwtEq71PArG8l1IFuxQZ7zlWiDbGNpz+KgFe4COQqF2hOl4JTRjcCbr0Wr1E8fYtUM
         Y5cJXy1OuujkHsa3JsIGG+XJvaae9NOTC3u124NleZztJHTJcdZ/PMqJ7ZQFPapILwLh
         QkOkcx04H2N+vOLBDiLN/dJ4ZqPr+EuibE9YQBC+yXzJ3JCI5AKAkrK1YEbrjJfapR3S
         KymrnrqiM/gWjosZB11zHu3vu26mGS27v5J/rFKzcCAqXPR2f3YEN/Seq+Rz/eJDh0XE
         t+Zw==
X-Gm-Message-State: AOAM530SZf7RO3aULlJ5ImvIf3NGJRTh87GN/Zzkgfb6klkv2slTH4Oe
        JmvbLttRz7uI6ih/UgsxVH7PZ8JO0agoieYARDkKJJ8yQXPf
X-Google-Smtp-Source: ABdhPJySZPvaRXVsuzf4kRKJi6Qd5j0+Q/bjK8JBJqDx5e2rNaN3pjt/+kQX99KmFwqt4Iw1jfa6W0oXFR9VMU4a0Ho=
X-Received: by 2002:a17:90a:b794:: with SMTP id m20mr16101536pjr.178.1631929021138;
 Fri, 17 Sep 2021 18:37:01 -0700 (PDT)
MIME-Version: 1.0
From:   Hao Sun <sunhao.th@gmail.com>
Date:   Sat, 18 Sep 2021 09:36:50 +0800
Message-ID: <CACkBjsbiT96KTK2Cjf0PxyOFRs8w0GPUWdR=97oVxSJMvDxNJQ@mail.gmail.com>
Subject: general protection fault in rcu_segcblist_enqueue
To:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc:     bp@alien8.de, hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, mingo@redhat.com, pbonzini@redhat.com,
        seanjc@google.com, tglx@linutronix.de, vkuznets@redhat.com,
        wanpengli@tencent.com, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

When using Healer to fuzz the latest Linux kernel, the following crash
was triggered.

HEAD commit: ff1ffd71d5f0 Merge tag 'hyperv-fixes-signed-20210915
git tree: upstream
console output:
https://drive.google.com/file/d/1I3q-rH7yJXxmr16cI418avyA_tHdoOVE/view?usp=sharing
kernel config: https://drive.google.com/file/d/1zXpDhs-IdE7tX17B7MhaYP0VGUfP6m9B/view?usp=sharing

Sorry, I don't have a reproducer for this crash, hope the symbolized
report can help.
If you fix this issue, please add the following tag to the commit:
Reported-by: Hao Sun <sunhao.th@gmail.com>

general protection fault, probably for non-canonical address
0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 3 PID: 18519 Comm: syz-executor Not tainted 5.15.0-rc1+ #6
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
RIP: 0010:rcu_segcblist_enqueue+0xf5/0x1d0 kernel/rcu/rcu_segcblist.c:348
Code: 00 00 00 00 00 fc ff df 48 89 ea 48 c1 ea 03 80 3c 02 00 75 7c
48 b8 00 00 00 00 00 fc ff df 4c 8b 63 20 4c 89 e2 48 c1 ea 03 <80> 3c
02 00 75 4f 48 89 ea 49 89 34 24 48 b8 00 00 00 00 00 fc ff
RSP: 0018:ffffc90001bafbd0 EFLAGS: 00010056
RAX: dffffc0000000000 RBX: ffff888135d00080 RCX: ffffffff815c1ca0
RDX: 0000000000000000 RSI: ffffc90001bafcd0 RDI: ffff888135d00080
RBP: ffff888135d000a0 R08: 0000000000000001 R09: fffff52000375f6e
R10: 0000000000000003 R11: fffff52000375f6d R12: 0000000000000000
R13: 0000000000000000 R14: ffff888135d00080 R15: ffff888135d00040
FS:  00007f2d96e17700(0000) GS:ffff888135d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f2d96df5db8 CR3: 000000010aedf000 CR4: 0000000000350ee0
Call Trace:
 srcu_gp_start_if_needed+0x145/0xbf0 kernel/rcu/srcutree.c:823
 __synchronize_srcu+0x1f4/0x270 kernel/rcu/srcutree.c:929
 kvm_mmu_uninit_vm+0x18/0x30 arch/x86/kvm/mmu/mmu.c:5711
 kvm_arch_destroy_vm+0x42b/0x5b0 arch/x86/kvm/x86.c:11331
 kvm_create_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:1094 [inline]
 kvm_dev_ioctl_create_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:4583 [inline]
 kvm_dev_ioctl+0x1508/0x1aa0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4638
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:874 [inline]
 __se_sys_ioctl fs/ioctl.c:860 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:860
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4739cd
Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f2d96e16c58 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 000000000059c0a0 RCX: 00000000004739cd
RDX: 0000000000000000 RSI: 000000000000ae01 RDI: 0000000000000003
RBP: 00000000004ebd80 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000059c0a0
R13: 00007ffd87419e4f R14: 00007ffd87419ff0 R15: 00007f2d96e16dc0
Modules linked in:
Dumping ftrace buffer:
   (ftrace buffer empty)
---[ end trace 786f845bf6575473 ]---
RIP: 0010:rcu_segcblist_enqueue+0xf5/0x1d0 kernel/rcu/rcu_segcblist.c:348
Code: 00 00 00 00 00 fc ff df 48 89 ea 48 c1 ea 03 80 3c 02 00 75 7c
48 b8 00 00 00 00 00 fc ff df 4c 8b 63 20 4c 89 e2 48 c1 ea 03 <80> 3c
02 00 75 4f 48 89 ea 49 89 34 24 48 b8 00 00 00 00 00 fc ff
RSP: 0018:ffffc90001bafbd0 EFLAGS: 00010056
RAX: dffffc0000000000 RBX: ffff888135d00080 RCX: ffffffff815c1ca0
RDX: 0000000000000000 RSI: ffffc90001bafcd0 RDI: ffff888135d00080
RBP: ffff888135d000a0 R08: 0000000000000001 R09: fffff52000375f6e
R10: 0000000000000003 R11: fffff52000375f6d R12: 0000000000000000
R13: 0000000000000000 R14: ffff888135d00080 R15: ffff888135d00040
FS:  00007f2d96e17700(0000) GS:ffff888135d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f2d96df5db8 CR3: 000000010aedf000 CR4: 0000000000350ee0
----------------
Code disassembly (best guess):
   0: 00 00                add    %al,(%rax)
   2: 00 00                add    %al,(%rax)
   4: 00 fc                add    %bh,%ah
   6: ff                    (bad)
   7: df 48 89              fisttps -0x77(%rax)
   a: ea                    (bad)
   b: 48 c1 ea 03          shr    $0x3,%rdx
   f: 80 3c 02 00          cmpb   $0x0,(%rdx,%rax,1)
  13: 75 7c                jne    0x91
  15: 48 b8 00 00 00 00 00 movabs $0xdffffc0000000000,%rax
  1c: fc ff df
  1f: 4c 8b 63 20          mov    0x20(%rbx),%r12
  23: 4c 89 e2              mov    %r12,%rdx
  26: 48 c1 ea 03          shr    $0x3,%rdx
* 2a: 80 3c 02 00          cmpb   $0x0,(%rdx,%rax,1) <-- trapping instruction
  2e: 75 4f                jne    0x7f
  30: 48 89 ea              mov    %rbp,%rdx
  33: 49 89 34 24          mov    %rsi,(%r12)
  37: 48                    rex.W
  38: b8 00 00 00 00        mov    $0x0,%eax
  3d: 00 fc                add    %bh,%ah
  3f: ff                    .byte 0xff
