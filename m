Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ADA8402735
	for <lists+kvm@lfdr.de>; Tue,  7 Sep 2021 12:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343493AbhIGK3k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Sep 2021 06:29:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343523AbhIGK3i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Sep 2021 06:29:38 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4989DC0613C1;
        Tue,  7 Sep 2021 03:28:32 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id v123so7786275pfb.11;
        Tue, 07 Sep 2021 03:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=vRBbwPHbmtfpgIVtQU9f4UNTrL9hQeaBXAYOYIggBaU=;
        b=k2dVwFQ3drLgLgSu0OvFPqRt3etXzw8YD4eNAHUHeY54P5exrUAR3PjCPmoo/WgK95
         aRRD4yUIy2xmbejYnXGoayfJK4NJrW/RUJT3SA77kUiAsxAJwydZUEGDMeXrbuYpw/8n
         XsHrhz325gOKTjv/+ha357Wt7VAP4JiQT2SexDk4HBEkzHhZzFeke7E3Ez+hWoucJ8xJ
         M59zED5nzmcZM7fqcICJRwCIXaflMNiizuJEFiaABVMYsGkXPTQMVunadsHOSK0VKPPk
         so/0yqfuTbqdUFmeteQ+JjqmRtBpbPhxliZOWdbMUzmI8bs9OphWB+jc1hDca/naRDpd
         zbTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=vRBbwPHbmtfpgIVtQU9f4UNTrL9hQeaBXAYOYIggBaU=;
        b=D+xAHpnaQMbSx9FRfJGbi1VlrywEl5Jja+CkDDHPinSYLUQoLSpYTZ8VNaBSAdyiP/
         sxeGOn+6MPKO0MbyQXzQskRCV8vvDjutQVYOIQpsmRXl3XJ18xyKACyV+KxaICfuS7bY
         EPqdouvN2GadXOsdoXyIKN/+F2Jd/fe4a+COtv69/EzrhaonPX4Ml6bLOj3DgbkhxLi/
         Q5Knu050Gk6N8+0WfXMwpVFxpSd4JhSmENe4gWyYwGFHrLQTBJKsMlvcBf2UZAsVZ3m7
         DJ6my0h2P8c9i61HMlsGCQBOp6eqpfQeil1FucJgPjHV7OSP4QC29ydl68zBbJoAdHUY
         L2hw==
X-Gm-Message-State: AOAM533dF8BodXsz6OhfAU5C/gJ1hwQbNZtnr9FqfEm7Fubn3gQZvQlB
        kEN0YtfZYJKTEqOq0dvb59DmAGzltd/4LcY0zYUXmH52VYz4
X-Google-Smtp-Source: ABdhPJyLASDHolzt4Yl0XnyYzXn0EdY8Iv19HG2XLCRKHzd5N4uP4CN7+KxzCO9OFUOQf5a/cKJRBg0cE1flxjRp2ZY=
X-Received: by 2002:a63:b60a:: with SMTP id j10mr16374299pgf.83.1631010511411;
 Tue, 07 Sep 2021 03:28:31 -0700 (PDT)
MIME-Version: 1.0
From:   Hao Sun <sunhao.th@gmail.com>
Date:   Tue, 7 Sep 2021 18:28:20 +0800
Message-ID: <CACkBjsZ55MKvOBGYJyQxwHBCQOTP=Lz=yfYwJtdOzNiT59E38g@mail.gmail.com>
Subject: BUG: spinlock bad magic in synchronize_srcu
To:     linux-kernel@vger.kernel.org
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

HEAD commit: 27151f177827 Merge tag 'perf-tools-for-v5.15-2021-09-04'
git tree: upstream
console output:
https://drive.google.com/file/d/1AauK3Op9WjrF8tZOM0r76XOGMrvgK65e/view?usp=sharing
kernel config: https://drive.google.com/file/d/1ZMVJ2vNe0EiIEeWNVyrGb7hBdOG5Uj3e/view?usp=sharing
Similar bug report:
https://groups.google.com/g/syzkaller-bugs/c/JMQALBa9wVE/m/_Wp1KGYzBwAJ

Sorry, I don't have a reproducer for this crash, hope the symbolized
report can help.
If you fix this issue, please add the following tag to the commit:
Reported-by: Hao Sun <sunhao.th@gmail.com>

BUG: spinlock bad magic on CPU#3, syz-executor/11945
 lock: 0xffff88813dd00040, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
CPU: 3 PID: 11945 Comm: syz-executor Not tainted 5.14.0+ #13
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x8d/0xcf lib/dump_stack.c:105
 spin_bug kernel/locking/spinlock_debug.c:77 [inline]
 debug_spin_lock_before kernel/locking/spinlock_debug.c:85 [inline]
 do_raw_spin_lock+0x6c/0xc0 kernel/locking/spinlock_debug.c:114
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:117 [inline]
 _raw_spin_lock_irqsave+0x40/0x50 kernel/locking/spinlock.c:162
 srcu_might_be_idle kernel/rcu/srcutree.c:767 [inline]
 synchronize_srcu+0x33/0xf0 kernel/rcu/srcutree.c:1008
 kvm_mmu_uninit_vm+0x18/0x30 arch/x86/kvm/mmu/mmu.c:5585
 kvm_arch_destroy_vm+0x225/0x2d0 arch/x86/kvm/x86.c:11277
 kvm_create_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:1060 [inline]
 kvm_dev_ioctl_create_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:4486 [inline]
 kvm_dev_ioctl+0x7c7/0xc00 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4541
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:874 [inline]
 __se_sys_ioctl fs/ioctl.c:860 [inline]
 __x64_sys_ioctl+0xb6/0x100 fs/ioctl.c:860
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x34/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x46a9a9
Code: f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f7df63cfc58 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 000000000078c0a0 RCX: 000000000046a9a9
RDX: 0000000000000000 RSI: 000000000000ae01 RDI: 0000000000000003
RBP: 00000000004e4042 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000078c0a0
R13: 0000000000000000 R14: 000000000078c0a0 R15: 00007fff67e58cd0
BUG: kernel NULL pointer dereference, address: 0000000000000000
#PF: supervisor write access in kernel mode
#PF: error_code(0x0002) - not-present page
PGD 104cb6067 P4D 104cb6067 PUD 10574c067 PMD 0
Oops: 0002 [#1] PREEMPT SMP
CPU: 3 PID: 11945 Comm: syz-executor Not tainted 5.14.0+ #13
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
RIP: 0010:rcu_segcblist_enqueue+0x2f/0x40 kernel/rcu/rcu_segcblist.c:348
Code: 00 48 8b 47 48 48 83 c0 01 48 89 47 48 f0 83 44 24 fc 00 48 8b
47 68 48 83 c0 01 48 89 47 68 48 c7 06 00 00 00 00 48 8b 47 20 <48> 89
30 48 89 77 20 c3 66 0f 1f 84 00 00 00 00 00 48 8b 57 48 48
RSP: 0018:ffffc90000a0bd48 EFLAGS: 00010002
RAX: 0000000000000000 RBX: ffffc90000a0bdb0 RCX: ffffc90000a5d000
RDX: 0000000000000001 RSI: ffffc90000a0bdb0 RDI: ffff88813dd00080
RBP: ffffc90000a0bda0 R08: 0000000000000001 R09: 0000000000000000
R10: ffffc90000a0bd80 R11: 3030303030302052 R12: ffffc90001681d10
R13: 0000000000000000 R14: 0000000000000000 R15: ffff88813dd00080
FS:  00007f7df63d0700(0000) GS:ffff88813dd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 0000000100f94000 CR4: 0000000000750ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 srcu_gp_start_if_needed+0xb4/0x480 kernel/rcu/srcutree.c:823
 __synchronize_srcu+0x13a/0x1a0 kernel/rcu/srcutree.c:929
 kvm_mmu_uninit_vm+0x18/0x30 arch/x86/kvm/mmu/mmu.c:5585
 kvm_arch_destroy_vm+0x225/0x2d0 arch/x86/kvm/x86.c:11277
 kvm_create_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:1060 [inline]
 kvm_dev_ioctl_create_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:4486 [inline]
 kvm_dev_ioctl+0x7c7/0xc00 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4541
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:874 [inline]
 __se_sys_ioctl fs/ioctl.c:860 [inline]
 __x64_sys_ioctl+0xb6/0x100 fs/ioctl.c:860
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x34/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x46a9a9
Code: f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f7df63cfc58 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 000000000078c0a0 RCX: 000000000046a9a9
RDX: 0000000000000000 RSI: 000000000000ae01 RDI: 0000000000000003
RBP: 00000000004e4042 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000078c0a0
R13: 0000000000000000 R14: 000000000078c0a0 R15: 00007fff67e58cd0
Modules linked in:
Dumping ftrace buffer:
   (ftrace buffer empty)
CR2: 0000000000000000
---[ end trace a7c9cbcbae2d6a4b ]---
RIP: 0010:rcu_segcblist_enqueue+0x2f/0x40 kernel/rcu/rcu_segcblist.c:348
Code: 00 48 8b 47 48 48 83 c0 01 48 89 47 48 f0 83 44 24 fc 00 48 8b
47 68 48 83 c0 01 48 89 47 68 48 c7 06 00 00 00 00 48 8b 47 20 <48> 89
30 48 89 77 20 c3 66 0f 1f 84 00 00 00 00 00 48 8b 57 48 48
RSP: 0018:ffffc90000a0bd48 EFLAGS: 00010002
RAX: 0000000000000000 RBX: ffffc90000a0bdb0 RCX: ffffc90000a5d000
RDX: 0000000000000001 RSI: ffffc90000a0bdb0 RDI: ffff88813dd00080
RBP: ffffc90000a0bda0 R08: 0000000000000001 R09: 0000000000000000
R10: ffffc90000a0bd80 R11: 3030303030302052 R12: ffffc90001681d10
R13: 0000000000000000 R14: 0000000000000000 R15: ffff88813dd00080
FS:  00007f7df63d0700(0000) GS:ffff88813dd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 0000000100f94000 CR4: 0000000000750ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
----------------
Code disassembly (best guess):
   0: 00 48 8b              add    %cl,-0x75(%rax)
   3: 47                    rex.RXB
   4: 48                    rex.W
   5: 48 83 c0 01          add    $0x1,%rax
   9: 48 89 47 48          mov    %rax,0x48(%rdi)
   d: f0 83 44 24 fc 00    lock addl $0x0,-0x4(%rsp)
  13: 48 8b 47 68          mov    0x68(%rdi),%rax
  17: 48 83 c0 01          add    $0x1,%rax
  1b: 48 89 47 68          mov    %rax,0x68(%rdi)
  1f: 48 c7 06 00 00 00 00 movq   $0x0,(%rsi)
  26: 48 8b 47 20          mov    0x20(%rdi),%rax
* 2a: 48 89 30              mov    %rsi,(%rax) <-- trapping instruction
  2d: 48 89 77 20          mov    %rsi,0x20(%rdi)
  31: c3                    retq
  32: 66 0f 1f 84 00 00 00 nopw   0x0(%rax,%rax,1)
  39: 00 00
  3b: 48 8b 57 48          mov    0x48(%rdi),%rdx
  3f: 48                    rex.W%
