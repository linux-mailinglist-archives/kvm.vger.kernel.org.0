Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F033134777C
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 12:35:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231976AbhCXLfm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 07:35:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231979AbhCXLfI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 07:35:08 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E14CBC0613DE;
        Wed, 24 Mar 2021 04:35:07 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id w21-20020a9d63950000b02901ce7b8c45b4so22656753otk.5;
        Wed, 24 Mar 2021 04:35:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SzsXHsc2BvVc0u/GaUwaqbg9AzOZi9pyaEExQ+CbbqQ=;
        b=Aiu4NvyXiLkPmPr1tY2Ir/rXyeiuROA/YXOwBk6O2aOfPRLU4v0iBYSIpAelxCNg8D
         I1AMSLIpbGU/1/Z3ZiNppNnB18DJd+ri+2hQiH9moYg4bH/LCHG07hbLC3ympNrIg+ZK
         DLfOl5MgkJkT8dVSjhG7mplX1OJl1ollJi+zC/evqMHWq7y8LM6WXk89yURxk+CKQRef
         6q5rZn2OGVG0tyfPZ+812KdDlGwD5z8lqoKF3+j8Tt+FyRiNCHglcyRVEYRAGoz0viHj
         cz6xT+M7qIo0Q6eL9UzomMNulprwDKoEPWJN2g8ct8JRH/FKLgKZWtQhV9plBTFjaUUX
         ooSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SzsXHsc2BvVc0u/GaUwaqbg9AzOZi9pyaEExQ+CbbqQ=;
        b=IlkB4B2XmMMZo00WrY35bXnT98b5Xi9wcZ9FxDCxpYFB8Qcw6RKvY4n9zawdDzHdk8
         5W5NOMluB2O87IJz+ns2VOMfFbOWsz+6iOGImr7N0k4ZJwrdeP3paqwHcuC0SpR6MkHc
         L2YH9/8Tqh0Sbvkm8/HGqy1C5MZGKyCf2O9U9n7Wflfkj50JFoz77QXgZy2IP7gS3xDK
         4WuKAl3RA20GlegyRJYjQYPQg5q4/rMdxVspcSjrGxtA38PSTENR3I6p6b11KTPH8+vU
         IS8UOLwq9MWmdWaxCXr2JPZND4FG+002F/OYmc9BCyCX4yTpwFqjpAeJWybbV+mUpET1
         ALxA==
X-Gm-Message-State: AOAM5308+ITwNE63owZKsPjv073dyT9AySdN3u+wFc+TbwpwQSqKHo5K
        bayAAWxbUD6TYzD/DbeZNgG7Hg1ViMe5U/bHCVs=
X-Google-Smtp-Source: ABdhPJzq+WjlXZwyMdrm9dZjuV0dprgmUAeW2TyMVkfiCB7I30ZtVTpzlu6MJgzicL4y8WuzvYh+rJt6O26jR/3Bn3o=
X-Received: by 2002:a05:6830:22c3:: with SMTP id q3mr2838538otc.56.1616585707135;
 Wed, 24 Mar 2021 04:35:07 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000087f95b05be42a0c7@google.com>
In-Reply-To: <00000000000087f95b05be42a0c7@google.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 24 Mar 2021 19:34:54 +0800
Message-ID: <CANRm+CwLouTk7r_J=0OqJ80sXY+sCPTZKEr3FyLiXgGiS5304w@mail.gmail.com>
Subject: Re: [syzbot] possible deadlock in scheduler_tick
To:     syzbot <syzbot+b282b65c2c68492df769@syzkaller.appspotmail.com>
Cc:     Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        syzkaller-bugs@googlegroups.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        David Woodhouse <dwmw@amazon.co.uk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Cc David Woodhouse,
On Wed, 24 Mar 2021 at 18:11, syzbot
<syzbot+b282b65c2c68492df769@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    1c273e10 Merge tag 'zonefs-5.12-rc4' of git://git.kernel.o..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=13c0414ed00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=6abda3336c698a07
> dashboard link: https://syzkaller.appspot.com/bug?extid=b282b65c2c68492df769
> userspace arch: i386
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17d86ad6d00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17b8497cd00000
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+b282b65c2c68492df769@syzkaller.appspotmail.com
>
> =====================================================
> WARNING: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected
> 5.12.0-rc3-syzkaller #0 Not tainted
> -----------------------------------------------------
> syz-executor030/8435 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
> ffffc90001a2a230 (&kvm->arch.pvclock_gtod_sync_lock){+.+.}-{2:2}, at: spin_lock include/linux/spinlock.h:354 [inline]
> ffffc90001a2a230 (&kvm->arch.pvclock_gtod_sync_lock){+.+.}-{2:2}, at: get_kvmclock_ns+0x25/0x390 arch/x86/kvm/x86.c:2587
>
> and this task is already holding:
> ffff8880b9d35198 (&rq->lock){-.-.}-{2:2}, at: rq_lock kernel/sched/sched.h:1321 [inline]
> ffff8880b9d35198 (&rq->lock){-.-.}-{2:2}, at: __schedule+0x21c/0x21b0 kernel/sched/core.c:4990
> which would create a new lock dependency:
>  (&rq->lock){-.-.}-{2:2} -> (&kvm->arch.pvclock_gtod_sync_lock){+.+.}-{2:2}
>
> but this new dependency connects a HARDIRQ-irq-safe lock:
>  (&rq->lock){-.-.}-{2:2}
>
> ... which became HARDIRQ-irq-safe at:
>   lock_acquire kernel/locking/lockdep.c:5510 [inline]
>   lock_acquire+0x1ab/0x740 kernel/locking/lockdep.c:5475
>   __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
>   _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
>   rq_lock kernel/sched/sched.h:1321 [inline]
>   scheduler_tick+0xa4/0x4b0 kernel/sched/core.c:4538
>   update_process_times+0x191/0x200 kernel/time/timer.c:1801
>   tick_periodic+0x79/0x230 kernel/time/tick-common.c:100
>   tick_handle_periodic+0x41/0x120 kernel/time/tick-common.c:112
>   timer_interrupt+0x3f/0x60 arch/x86/kernel/time.c:57
>   __handle_irq_event_percpu+0x303/0x8f0 kernel/irq/handle.c:156
>   handle_irq_event_percpu kernel/irq/handle.c:196 [inline]
>   handle_irq_event+0x102/0x290 kernel/irq/handle.c:213
>   handle_level_irq+0x256/0x6e0 kernel/irq/chip.c:650
>   generic_handle_irq_desc include/linux/irqdesc.h:158 [inline]
>   handle_irq arch/x86/kernel/irq.c:231 [inline]
>   __common_interrupt+0x9e/0x200 arch/x86/kernel/irq.c:250
>   common_interrupt+0x9f/0xd0 arch/x86/kernel/irq.c:240
>   asm_common_interrupt+0x1e/0x40 arch/x86/include/asm/idtentry.h:623
>   __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:161 [inline]
>   _raw_spin_unlock_irqrestore+0x38/0x70 kernel/locking/spinlock.c:191
>   __setup_irq+0xc72/0x1ce0 kernel/irq/manage.c:1737
>   request_threaded_irq+0x28a/0x3b0 kernel/irq/manage.c:2127
>   request_irq include/linux/interrupt.h:160 [inline]
>   setup_default_timer_irq arch/x86/kernel/time.c:70 [inline]
>   hpet_time_init+0x28/0x42 arch/x86/kernel/time.c:82
>   x86_late_time_init+0x58/0x94 arch/x86/kernel/time.c:94
>   start_kernel+0x3ee/0x496 init/main.c:1028
>   secondary_startup_64_no_verify+0xb0/0xbb
>
> to a HARDIRQ-irq-unsafe lock:
>  (&kvm->arch.pvclock_gtod_sync_lock){+.+.}-{2:2}
>
> ... which became HARDIRQ-irq-unsafe at:
> ...
>   lock_acquire kernel/locking/lockdep.c:5510 [inline]
>   lock_acquire+0x1ab/0x740 kernel/locking/lockdep.c:5475
>   __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
>   _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
>   spin_lock include/linux/spinlock.h:354 [inline]
>   kvm_synchronize_tsc+0x459/0x1230 arch/x86/kvm/x86.c:2332
>   kvm_arch_vcpu_postcreate+0x73/0x180 arch/x86/kvm/x86.c:10183
>   kvm_vm_ioctl_create_vcpu arch/x86/kvm/../../../virt/kvm/kvm_main.c:3239 [inline]
>   kvm_vm_ioctl+0x1b2d/0x2800 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3839
>   kvm_vm_compat_ioctl+0x125/0x230 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4052
>   __do_compat_sys_ioctl+0x1d3/0x230 fs/ioctl.c:842
>   do_syscall_32_irqs_on arch/x86/entry/common.c:77 [inline]
>   __do_fast_syscall_32+0x56/0x90 arch/x86/entry/common.c:140
>   do_fast_syscall_32+0x2f/0x70 arch/x86/entry/common.c:165
>   entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
>
> other info that might help us debug this:
>
>  Possible interrupt unsafe locking scenario:
>
>        CPU0                    CPU1
>        ----                    ----
>   lock(&kvm->arch.pvclock_gtod_sync_lock);
>                                local_irq_disable();
>                                lock(&rq->lock);
>                                lock(&kvm->arch.pvclock_gtod_sync_lock);
>   <Interrupt>
>     lock(&rq->lock);
>

The offender is get_kvmclock_ns() which is called in the context
switch process. The bad commit is 30b5c851af7991ad0 ("KVM: x86/xen:
Add support for vCPU runstate information").

>  *** DEADLOCK ***
>
> 1 lock held by syz-executor030/8435:
>  #0: ffff8880b9d35198 (&rq->lock){-.-.}-{2:2}, at: rq_lock kernel/sched/sched.h:1321 [inline]
>  #0: ffff8880b9d35198 (&rq->lock){-.-.}-{2:2}, at: __schedule+0x21c/0x21b0 kernel/sched/core.c:4990
>
> the dependencies between HARDIRQ-irq-safe lock and the holding lock:
> -> (&rq->lock){-.-.}-{2:2} {
>    IN-HARDIRQ-W at:
>                     lock_acquire kernel/locking/lockdep.c:5510 [inline]
>                     lock_acquire+0x1ab/0x740 kernel/locking/lockdep.c:5475
>                     __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
>                     _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
>                     rq_lock kernel/sched/sched.h:1321 [inline]
>                     scheduler_tick+0xa4/0x4b0 kernel/sched/core.c:4538
>                     update_process_times+0x191/0x200 kernel/time/timer.c:1801
>                     tick_periodic+0x79/0x230 kernel/time/tick-common.c:100
>                     tick_handle_periodic+0x41/0x120 kernel/time/tick-common.c:112
>                     timer_interrupt+0x3f/0x60 arch/x86/kernel/time.c:57
>                     __handle_irq_event_percpu+0x303/0x8f0 kernel/irq/handle.c:156
>                     handle_irq_event_percpu kernel/irq/handle.c:196 [inline]
>                     handle_irq_event+0x102/0x290 kernel/irq/handle.c:213
>                     handle_level_irq+0x256/0x6e0 kernel/irq/chip.c:650
>                     generic_handle_irq_desc include/linux/irqdesc.h:158 [inline]
>                     handle_irq arch/x86/kernel/irq.c:231 [inline]
>                     __common_interrupt+0x9e/0x200 arch/x86/kernel/irq.c:250
>                     common_interrupt+0x9f/0xd0 arch/x86/kernel/irq.c:240
>                     asm_common_interrupt+0x1e/0x40 arch/x86/include/asm/idtentry.h:623
>                     __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:161 [inline]
>                     _raw_spin_unlock_irqrestore+0x38/0x70 kernel/locking/spinlock.c:191
>                     __setup_irq+0xc72/0x1ce0 kernel/irq/manage.c:1737
>                     request_threaded_irq+0x28a/0x3b0 kernel/irq/manage.c:2127
>                     request_irq include/linux/interrupt.h:160 [inline]
>                     setup_default_timer_irq arch/x86/kernel/time.c:70 [inline]
>                     hpet_time_init+0x28/0x42 arch/x86/kernel/time.c:82
>                     x86_late_time_init+0x58/0x94 arch/x86/kernel/time.c:94
>                     start_kernel+0x3ee/0x496 init/main.c:1028
>                     secondary_startup_64_no_verify+0xb0/0xbb
>    IN-SOFTIRQ-W at:
>                     lock_acquire kernel/locking/lockdep.c:5510 [inline]
>                     lock_acquire+0x1ab/0x740 kernel/locking/lockdep.c:5475
>                     __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
>                     _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
>                     rq_lock kernel/sched/sched.h:1321 [inline]
>                     ttwu_queue kernel/sched/core.c:3184 [inline]
>                     try_to_wake_up+0x5e6/0x14a0 kernel/sched/core.c:3464
>                     call_timer_fn+0x1a5/0x6b0 kernel/time/timer.c:1431
>                     expire_timers kernel/time/timer.c:1476 [inline]
>                     __run_timers.part.0+0x67c/0xa50 kernel/time/timer.c:1745
>                     __run_timers kernel/time/timer.c:1726 [inline]
>                     run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1758
>                     __do_softirq+0x29b/0x9f6 kernel/softirq.c:345
>                     invoke_softirq kernel/softirq.c:221 [inline]
>                     __irq_exit_rcu kernel/softirq.c:422 [inline]
>                     irq_exit_rcu+0x134/0x200 kernel/softirq.c:434
>                     sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1100
>                     asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:632
>                     rdtsc_ordered arch/x86/include/asm/msr.h:234 [inline]
>                     delay_tsc+0x45/0xb0 arch/x86/lib/delay.c:72
>                     try_check_zero+0x223/0x430 kernel/rcu/srcutree.c:707
>                     srcu_advance_state kernel/rcu/srcutree.c:1229 [inline]
>                     process_srcu+0x2f2/0xe90 kernel/rcu/srcutree.c:1327
>                     process_one_work+0x98d/0x1600 kernel/workqueue.c:2275
>                     worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
>                     kthread+0x3b1/0x4a0 kernel/kthread.c:292
>                     ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
>    INITIAL USE at:
>                    lock_acquire kernel/locking/lockdep.c:5510 [inline]
>                    lock_acquire+0x1ab/0x740 kernel/locking/lockdep.c:5475
>                    __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
>                    _raw_spin_lock_irqsave+0x39/0x50 kernel/locking/spinlock.c:159
>                    rq_attach_root+0x20/0x2e0 kernel/sched/topology.c:470
>                    sched_init+0x6e8/0xbf3 kernel/sched/core.c:8213
>                    start_kernel+0x18e/0x496 init/main.c:920
>                    secondary_startup_64_no_verify+0xb0/0xbb
>  }
>  ... key      at: [<ffffffff8f39a7c0>] __key.298+0x0/0x40
>  ... acquired at:
>    lock_acquire kernel/locking/lockdep.c:5510 [inline]
>    lock_acquire+0x1ab/0x740 kernel/locking/lockdep.c:5475
>    __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
>    _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
>    spin_lock include/linux/spinlock.h:354 [inline]
>    get_kvmclock_ns+0x25/0x390 arch/x86/kvm/x86.c:2587
>    kvm_xen_update_runstate+0x3d/0x2c0 arch/x86/kvm/xen.c:69
>    kvm_xen_update_runstate_guest+0x74/0x320 arch/x86/kvm/xen.c:100
>    kvm_xen_runstate_set_preempted arch/x86/kvm/xen.h:96 [inline]
>    kvm_arch_vcpu_put+0x2d8/0x5a0 arch/x86/kvm/x86.c:4062
>    kvm_sched_out+0xbf/0x100 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4876
>    __fire_sched_out_preempt_notifiers kernel/sched/core.c:3922 [inline]
>    fire_sched_out_preempt_notifiers kernel/sched/core.c:3930 [inline]
>    prepare_task_switch kernel/sched/core.c:4126 [inline]
>    context_switch kernel/sched/core.c:4274 [inline]
>    __schedule+0xfd0/0x21b0 kernel/sched/core.c:5073
>    preempt_schedule_irq+0x4e/0x90 kernel/sched/core.c:5530
>    irqentry_exit_cond_resched kernel/entry/common.c:392 [inline]
>    irqentry_exit_cond_resched kernel/entry/common.c:384 [inline]
>    irqentry_exit+0x7a/0xa0 kernel/entry/common.c:428
>    asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:632
>    __vmcs_writel arch/x86/kvm/vmx/vmx_ops.h:176 [inline]
>    vmcs_write16 arch/x86/kvm/vmx/vmx_ops.h:185 [inline]
>    seg_setup+0x66/0x2a0 arch/x86/kvm/vmx/vmx.c:3633
>    vmx_vcpu_reset+0x20a/0xee0 arch/x86/kvm/vmx/vmx.c:4455
>    kvm_arch_vcpu_create+0x765/0xbb0 arch/x86/kvm/x86.c:10152
>    kvm_vm_ioctl_create_vcpu arch/x86/kvm/../../../virt/kvm/kvm_main.c:3201 [inline]
>    kvm_vm_ioctl+0x1702/0x2800 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3839
>    kvm_vm_compat_ioctl+0x125/0x230 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4052
>    __do_compat_sys_ioctl+0x1d3/0x230 fs/ioctl.c:842
>    do_syscall_32_irqs_on arch/x86/entry/common.c:77 [inline]
>    __do_fast_syscall_32+0x56/0x90 arch/x86/entry/common.c:140
>    do_fast_syscall_32+0x2f/0x70 arch/x86/entry/common.c:165
>    entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
>
>
> the dependencies between the lock to be acquired
>  and HARDIRQ-irq-unsafe lock:
> -> (&kvm->arch.pvclock_gtod_sync_lock){+.+.}-{2:2} {
>    HARDIRQ-ON-W at:
>                     lock_acquire kernel/locking/lockdep.c:5510 [inline]
>                     lock_acquire+0x1ab/0x740 kernel/locking/lockdep.c:5475
>                     __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
>                     _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
>                     spin_lock include/linux/spinlock.h:354 [inline]
>                     kvm_synchronize_tsc+0x459/0x1230 arch/x86/kvm/x86.c:2332
>                     kvm_arch_vcpu_postcreate+0x73/0x180 arch/x86/kvm/x86.c:10183
>                     kvm_vm_ioctl_create_vcpu arch/x86/kvm/../../../virt/kvm/kvm_main.c:3239 [inline]
>                     kvm_vm_ioctl+0x1b2d/0x2800 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3839
>                     kvm_vm_compat_ioctl+0x125/0x230 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4052
>                     __do_compat_sys_ioctl+0x1d3/0x230 fs/ioctl.c:842
>                     do_syscall_32_irqs_on arch/x86/entry/common.c:77 [inline]
>                     __do_fast_syscall_32+0x56/0x90 arch/x86/entry/common.c:140
>                     do_fast_syscall_32+0x2f/0x70 arch/x86/entry/common.c:165
>                     entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
>    SOFTIRQ-ON-W at:
>                     lock_acquire kernel/locking/lockdep.c:5510 [inline]
>                     lock_acquire+0x1ab/0x740 kernel/locking/lockdep.c:5475
>                     __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
>                     _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
>                     spin_lock include/linux/spinlock.h:354 [inline]
>                     kvm_synchronize_tsc+0x459/0x1230 arch/x86/kvm/x86.c:2332
>                     kvm_arch_vcpu_postcreate+0x73/0x180 arch/x86/kvm/x86.c:10183
>                     kvm_vm_ioctl_create_vcpu arch/x86/kvm/../../../virt/kvm/kvm_main.c:3239 [inline]
>                     kvm_vm_ioctl+0x1b2d/0x2800 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3839
>                     kvm_vm_compat_ioctl+0x125/0x230 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4052
>                     __do_compat_sys_ioctl+0x1d3/0x230 fs/ioctl.c:842
>                     do_syscall_32_irqs_on arch/x86/entry/common.c:77 [inline]
>                     __do_fast_syscall_32+0x56/0x90 arch/x86/entry/common.c:140
>                     do_fast_syscall_32+0x2f/0x70 arch/x86/entry/common.c:165
>                     entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
>    INITIAL USE at:
>                    lock_acquire kernel/locking/lockdep.c:5510 [inline]
>                    lock_acquire+0x1ab/0x740 kernel/locking/lockdep.c:5475
>                    __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
>                    _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
>                    spin_lock include/linux/spinlock.h:354 [inline]
>                    kvm_synchronize_tsc+0x459/0x1230 arch/x86/kvm/x86.c:2332
>                    kvm_arch_vcpu_postcreate+0x73/0x180 arch/x86/kvm/x86.c:10183
>                    kvm_vm_ioctl_create_vcpu arch/x86/kvm/../../../virt/kvm/kvm_main.c:3239 [inline]
>                    kvm_vm_ioctl+0x1b2d/0x2800 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3839
>                    kvm_vm_compat_ioctl+0x125/0x230 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4052
>                    __do_compat_sys_ioctl+0x1d3/0x230 fs/ioctl.c:842
>                    do_syscall_32_irqs_on arch/x86/entry/common.c:77 [inline]
>                    __do_fast_syscall_32+0x56/0x90 arch/x86/entry/common.c:140
>                    do_fast_syscall_32+0x2f/0x70 arch/x86/entry/common.c:165
>                    entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
>  }
>  ... key      at: [<ffffffff8f371000>] __key.4+0x0/0x40
>  ... acquired at:
>    lock_acquire kernel/locking/lockdep.c:5510 [inline]
>    lock_acquire+0x1ab/0x740 kernel/locking/lockdep.c:5475
>    __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
>    _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
>    spin_lock include/linux/spinlock.h:354 [inline]
>    get_kvmclock_ns+0x25/0x390 arch/x86/kvm/x86.c:2587
>    kvm_xen_update_runstate+0x3d/0x2c0 arch/x86/kvm/xen.c:69
>    kvm_xen_update_runstate_guest+0x74/0x320 arch/x86/kvm/xen.c:100
>    kvm_xen_runstate_set_preempted arch/x86/kvm/xen.h:96 [inline]
>    kvm_arch_vcpu_put+0x2d8/0x5a0 arch/x86/kvm/x86.c:4062
>    kvm_sched_out+0xbf/0x100 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4876
>    __fire_sched_out_preempt_notifiers kernel/sched/core.c:3922 [inline]
>    fire_sched_out_preempt_notifiers kernel/sched/core.c:3930 [inline]
>    prepare_task_switch kernel/sched/core.c:4126 [inline]
>    context_switch kernel/sched/core.c:4274 [inline]
>    __schedule+0xfd0/0x21b0 kernel/sched/core.c:5073
>    preempt_schedule_irq+0x4e/0x90 kernel/sched/core.c:5530
>    irqentry_exit_cond_resched kernel/entry/common.c:392 [inline]
>    irqentry_exit_cond_resched kernel/entry/common.c:384 [inline]
>    irqentry_exit+0x7a/0xa0 kernel/entry/common.c:428
>    asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:632
>    __vmcs_writel arch/x86/kvm/vmx/vmx_ops.h:176 [inline]
>    vmcs_write16 arch/x86/kvm/vmx/vmx_ops.h:185 [inline]
>    seg_setup+0x66/0x2a0 arch/x86/kvm/vmx/vmx.c:3633
>    vmx_vcpu_reset+0x20a/0xee0 arch/x86/kvm/vmx/vmx.c:4455
>    kvm_arch_vcpu_create+0x765/0xbb0 arch/x86/kvm/x86.c:10152
>    kvm_vm_ioctl_create_vcpu arch/x86/kvm/../../../virt/kvm/kvm_main.c:3201 [inline]
>    kvm_vm_ioctl+0x1702/0x2800 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3839
>    kvm_vm_compat_ioctl+0x125/0x230 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4052
>    __do_compat_sys_ioctl+0x1d3/0x230 fs/ioctl.c:842
>    do_syscall_32_irqs_on arch/x86/entry/common.c:77 [inline]
>    __do_fast_syscall_32+0x56/0x90 arch/x86/entry/common.c:140
>    do_fast_syscall_32+0x2f/0x70 arch/x86/entry/common.c:165
>    entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
>
>
> stack backtrace:
> CPU: 1 PID: 8435 Comm: syz-executor030 Not tainted 5.12.0-rc3-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:79 [inline]
>  dump_stack+0x141/0x1d7 lib/dump_stack.c:120
>  print_bad_irq_dependency kernel/locking/lockdep.c:2460 [inline]
>  check_irq_usage.cold+0x50d/0x744 kernel/locking/lockdep.c:2689
>  check_prev_add kernel/locking/lockdep.c:2940 [inline]
>  check_prevs_add kernel/locking/lockdep.c:3059 [inline]
>  validate_chain kernel/locking/lockdep.c:3674 [inline]
>  __lock_acquire+0x2b2c/0x54c0 kernel/locking/lockdep.c:4900
>  lock_acquire kernel/locking/lockdep.c:5510 [inline]
>  lock_acquire+0x1ab/0x740 kernel/locking/lockdep.c:5475
>  __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
>  _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
>  spin_lock include/linux/spinlock.h:354 [inline]
>  get_kvmclock_ns+0x25/0x390 arch/x86/kvm/x86.c:2587
>  kvm_xen_update_runstate+0x3d/0x2c0 arch/x86/kvm/xen.c:69
>  kvm_xen_update_runstate_guest+0x74/0x320 arch/x86/kvm/xen.c:100
>  kvm_xen_runstate_set_preempted arch/x86/kvm/xen.h:96 [inline]
>  kvm_arch_vcpu_put+0x2d8/0x5a0 arch/x86/kvm/x86.c:4062
>  kvm_sched_out+0xbf/0x100 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4876
>  __fire_sched_out_preempt_notifiers kernel/sched/core.c:3922 [inline]
>  fire_sched_out_preempt_notifiers kernel/sched/core.c:3930 [inline]
>  prepare_task_switch kernel/sched/core.c:4126 [inline]
>  context_switch kernel/sched/core.c:4274 [inline]
>  __schedule+0xfd0/0x21b0 kernel/sched/core.c:5073
>  preempt_schedule_irq+0x4e/0x90 kernel/sched/core.c:5530
>  irqentry_exit_cond_resched kernel/entry/common.c:392 [inline]
>  irqentry_exit_cond_resched kernel/entry/common.c:384 [inline]
>  irqentry_exit+0x7a/0xa0 kernel/entry/common.c:428
>  asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:632
> RIP: 0010:__vmcs_writel arch/x86/kvm/vmx/vmx_ops.h:176 [inline]
> RIP: 0010:vmcs_write16 arch/x86/kvm/vmx/vmx_ops.h:185 [inline]
> RIP: 0010:seg_setup+0x66/0x2a0 arch/x86/kvm/vmx/vmx.c:3633
> Code: 84 c0 74 08 3c 03 0f 8e 32 02 00 00 48 89 d8 48 c1 e0 04 44 8b a0 80 72 64 89 0f 1f 44 00 00 e8 d0 31 56 00 31 c0 44 0f 79 e0 <2e> 0f 86 db 01 00 00 e8 be 31 56 00 e8 b9 31 56 00 48 89 df 48 b8
> RSP: 0018:ffffc9000183f988 EFLAGS: 00000202
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: ffff88801ba39c40 RSI: ffffffff811db9b0 RDI: ffffffff89647280
> RBP: 0000000000000000 R08: 0000000000000001 R09: ffffc90001a2a16b
> R10: ffffffff811dba9b R11: 0000000000000000 R12: 0000000000000800
> R13: 1ffff92000307f35 R14: ffff88801755e170 R15: 0000000000000040
>  vmx_vcpu_reset+0x20a/0xee0 arch/x86/kvm/vmx/vmx.c:4455
>  kvm_arch_vcpu_create+0x765/0xbb0 arch/x86/kvm/x86.c:10152
>  kvm_vm_ioctl_create_vcpu arch/x86/kvm/../../../virt/kvm/kvm_main.c:3201 [inline]
>  kvm_vm_ioctl+0x1702/0x2800 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3839
>  kvm_vm_compat_ioctl+0x125/0x230 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4052
>  __do_compat_sys_ioctl+0x1d3/0x230 fs/ioctl.c:842
>  do_syscall_32_irqs_on arch/x86/entry/common.c:77 [inline]
>  __do_fast_syscall_32+0x56/0x90 arch/x86/entry/common.c:140
>  do_fast_syscall_32+0x2f/0x70 arch/x86/entry/common.c:165
>  entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
> RIP: 0023:0xf7f50549
> Code: 03 74 c0 01 10 05 03 74 b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d b4 26 00 00 00 00 8d b4 26 00 00 00 00
> RSP: 002b:00000000ffce641c EFLAGS: 00000217 ORIG_RAX: 0000000000000036
> RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 000000000000ae41
> RDX: 0000000000000000 RSI: 0000000000000036 RDI: 0000000000000004
> RBP: 000000004038ae7a R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches
