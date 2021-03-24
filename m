Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1D56347281
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 08:25:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231552AbhCXHYx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 03:24:53 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:39066 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236074AbhCXHYP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 03:24:15 -0400
Received: by mail-io1-f70.google.com with SMTP id x6so778846ioj.6
        for <kvm@vger.kernel.org>; Wed, 24 Mar 2021 00:24:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=EYbKOx85TqkoSHlsdZ0pOMgsPP1FhYyvV9ZfYrYph80=;
        b=p2uAHS0se2byenfxck7tEmUGG6pOn5UIhO/F5f3Sw0+iovU200CUmSm6iFS2Dmcnyt
         YNElX0IFHRYVCYAyqM3hdmVcOvij19zIsLUqU1uW1+F8GIR70dm3D+w6DbX40TNTmcHE
         8k9KtgWgf/wOdoeNYhH/4ROSyQdyu/u5JKT2kiHYoLG1VYez+M4EPsfYxQQgekMFSLah
         oXLR4qPkGOX7H9aR1M0xuRWNOkwWhoSggVJRxdcJGZHAJQ4kry/Hl4qCDogN1eS0aTgy
         Ezk35wEttzIaCDpP41UTL3YO83xTm1DeKNcMUks36ONbg/IKj7k1ivxhdBD4PmFbV+54
         Ig6Q==
X-Gm-Message-State: AOAM530m6EykZpgw2lBYjmbkCSpSVNImLxIiZ1Xu6d6oeL5286LxVHRL
        kyW9NwNwrHvXUspVoYnYWmfF2VDZ+CcSJneK1HOKv0wgu5w7
X-Google-Smtp-Source: ABdhPJyPIMf6wmwfBH5uhTtOclcsa61ldt/kHEQlKfAn4NPg+WyIKHdyaO4CaJ/gfHNt6OwtliQ3PYf2iAH7fOvJu+NOki0j7z4j
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a68:: with SMTP id w8mr1641643ilv.129.1616570654237;
 Wed, 24 Mar 2021 00:24:14 -0700 (PDT)
Date:   Wed, 24 Mar 2021 00:24:14 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000099aa6805be432fce@google.com>
Subject: [syzbot] possible deadlock in kvm_synchronize_tsc
From:   syzbot <syzbot+9a89b866d3fc11acc3b6@syzkaller.appspotmail.com>
To:     bp@alien8.de, hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, pbonzini@redhat.com, seanjc@google.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    1c273e10 Merge tag 'zonefs-5.12-rc4' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1063d14ed00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6abda3336c698a07
dashboard link: https://syzkaller.appspot.com/bug?extid=9a89b866d3fc11acc3b6
userspace arch: i386
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10bf56f6d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=174e36dcd00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9a89b866d3fc11acc3b6@syzkaller.appspotmail.com

L1TF CPU bug present and SMT on, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.
========================================================
WARNING: possible irq lock inversion dependency detected
5.12.0-rc3-syzkaller #0 Not tainted
--------------------------------------------------------
syz-executor859/8381 just changed the state of lock:
ffffc9000162a230 (&kvm->arch.pvclock_gtod_sync_lock){+...}-{2:2}, at: spin_lock include/linux/spinlock.h:354 [inline]
ffffc9000162a230 (&kvm->arch.pvclock_gtod_sync_lock){+...}-{2:2}, at: kvm_synchronize_tsc+0x459/0x1230 arch/x86/kvm/x86.c:2332
but this lock was taken by another, HARDIRQ-safe lock in the past:
 (&rq->lock){-.-.}-{2:2}


and interrupts could create inverse lock ordering between them.


other info that might help us debug this:
 Possible interrupt unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&kvm->arch.pvclock_gtod_sync_lock);
                               local_irq_disable();
                               lock(&rq->lock);
                               lock(&kvm->arch.pvclock_gtod_sync_lock);
  <Interrupt>
    lock(&rq->lock);

 *** DEADLOCK ***

1 lock held by syz-executor859/8381:
 #0: ffff8880316e80c8 (&vcpu->mutex){+.+.}-{3:3}, at: kvm_arch_vcpu_postcreate+0x3e/0x180 arch/x86/kvm/x86.c:10180

the shortest dependencies between 2nd lock and 1st lock:
 -> (&rq->lock){-.-.}-{2:2} {
    IN-HARDIRQ-W at:
                      lock_acquire kernel/locking/lockdep.c:5510 [inline]
                      lock_acquire+0x1ab/0x740 kernel/locking/lockdep.c:5475
                      __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
                      _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
                      rq_lock kernel/sched/sched.h:1321 [inline]
                      scheduler_tick+0xa4/0x4b0 kernel/sched/core.c:4538
                      update_process_times+0x191/0x200 kernel/time/timer.c:1801
                      tick_periodic+0x79/0x230 kernel/time/tick-common.c:100
                      tick_handle_periodic+0x41/0x120 kernel/time/tick-common.c:112
                      timer_interrupt+0x3f/0x60 arch/x86/kernel/time.c:57
                      __handle_irq_event_percpu+0x303/0x8f0 kernel/irq/handle.c:156
                      handle_irq_event_percpu kernel/irq/handle.c:196 [inline]
                      handle_irq_event+0x102/0x290 kernel/irq/handle.c:213
                      handle_level_irq+0x256/0x6e0 kernel/irq/chip.c:650
                      generic_handle_irq_desc include/linux/irqdesc.h:158 [inline]
                      handle_irq arch/x86/kernel/irq.c:231 [inline]
                      __common_interrupt+0x9e/0x200 arch/x86/kernel/irq.c:250
                      common_interrupt+0x9f/0xd0 arch/x86/kernel/irq.c:240
                      asm_common_interrupt+0x1e/0x40 arch/x86/include/asm/idtentry.h:623
                      __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:161 [inline]
                      _raw_spin_unlock_irqrestore+0x38/0x70 kernel/locking/spinlock.c:191
                      __setup_irq+0xc72/0x1ce0 kernel/irq/manage.c:1737
                      request_threaded_irq+0x28a/0x3b0 kernel/irq/manage.c:2127
                      request_irq include/linux/interrupt.h:160 [inline]
                      setup_default_timer_irq arch/x86/kernel/time.c:70 [inline]
                      hpet_time_init+0x28/0x42 arch/x86/kernel/time.c:82
                      x86_late_time_init+0x58/0x94 arch/x86/kernel/time.c:94
                      start_kernel+0x3ee/0x496 init/main.c:1028
                      secondary_startup_64_no_verify+0xb0/0xbb
    IN-SOFTIRQ-W at:
                      lock_acquire kernel/locking/lockdep.c:5510 [inline]
                      lock_acquire+0x1ab/0x740 kernel/locking/lockdep.c:5475
                      __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
                      _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
                      rq_lock kernel/sched/sched.h:1321 [inline]
                      ttwu_queue kernel/sched/core.c:3184 [inline]
                      try_to_wake_up+0x5e6/0x14a0 kernel/sched/core.c:3464
                      call_timer_fn+0x1a5/0x6b0 kernel/time/timer.c:1431
                      expire_timers kernel/time/timer.c:1476 [inline]
                      __run_timers.part.0+0x67c/0xa50 kernel/time/timer.c:1745
                      __run_timers kernel/time/timer.c:1726 [inline]
                      run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1758
                      __do_softirq+0x29b/0x9f6 kernel/softirq.c:345
                      invoke_softirq kernel/softirq.c:221 [inline]
                      __irq_exit_rcu kernel/softirq.c:422 [inline]
                      irq_exit_rcu+0x134/0x200 kernel/softirq.c:434
                      sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1100
                      asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:632
                      rep_nop arch/x86/include/asm/vdso/processor.h:13 [inline]
                      delay_tsc+0x2e/0xb0 arch/x86/lib/delay.c:78
                      try_check_zero+0x223/0x430 kernel/rcu/srcutree.c:707
                      srcu_advance_state kernel/rcu/srcutree.c:1229 [inline]
                      process_srcu+0x2f2/0xe90 kernel/rcu/srcutree.c:1327
                      process_one_work+0x98d/0x1600 kernel/workqueue.c:2275
                      worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
                      kthread+0x3b1/0x4a0 kernel/kthread.c:292
                      ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
    INITIAL USE at:
                     lock_acquire kernel/locking/lockdep.c:5510 [inline]
                     lock_acquire+0x1ab/0x740 kernel/locking/lockdep.c:5475
                     __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
                     _raw_spin_lock_irqsave+0x39/0x50 kernel/locking/spinlock.c:159
                     rq_attach_root+0x20/0x2e0 kernel/sched/topology.c:470
                     sched_init+0x6e8/0xbf3 kernel/sched/core.c:8213
                     start_kernel+0x18e/0x496 init/main.c:920
                     secondary_startup_64_no_verify+0xb0/0xbb
  }
  ... key      at: [<ffffffff8f39a7c0>] __key.298+0x0/0x40
  ... acquired at:
   __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
   _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
   spin_lock include/linux/spinlock.h:354 [inline]
   get_kvmclock_ns+0x25/0x390 arch/x86/kvm/x86.c:2587
   kvm_xen_update_runstate+0x3d/0x2c0 arch/x86/kvm/xen.c:69
   kvm_xen_update_runstate_guest+0x74/0x320 arch/x86/kvm/xen.c:100
   kvm_xen_runstate_set_preempted arch/x86/kvm/xen.h:96 [inline]
   kvm_arch_vcpu_put+0x2d8/0x5a0 arch/x86/kvm/x86.c:4062
   kvm_sched_out+0xbf/0x100 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4876
   __fire_sched_out_preempt_notifiers kernel/sched/core.c:3922 [inline]
   fire_sched_out_preempt_notifiers kernel/sched/core.c:3930 [inline]
   prepare_task_switch kernel/sched/core.c:4126 [inline]
   context_switch kernel/sched/core.c:4274 [inline]
   __schedule+0xfd0/0x21b0 kernel/sched/core.c:5073
   preempt_schedule_common+0x45/0xc0 kernel/sched/core.c:5233
   preempt_schedule_thunk+0x16/0x18 arch/x86/entry/thunk_64.S:35
   __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:161 [inline]
   _raw_spin_unlock_irqrestore+0x57/0x70 kernel/locking/spinlock.c:191
   kvm_synchronize_tsc+0x451/0x1230 arch/x86/kvm/x86.c:2330
   kvm_arch_vcpu_postcreate+0x73/0x180 arch/x86/kvm/x86.c:10183
   kvm_vm_ioctl_create_vcpu arch/x86/kvm/../../../virt/kvm/kvm_main.c:3239 [inline]
   kvm_vm_ioctl+0x1b2d/0x2800 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3839
   kvm_vm_compat_ioctl+0x125/0x230 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4052
   __do_compat_sys_ioctl+0x1d3/0x230 fs/ioctl.c:842
   do_syscall_32_irqs_on arch/x86/entry/common.c:77 [inline]
   __do_fast_syscall_32+0x56/0x90 arch/x86/entry/common.c:140
   do_fast_syscall_32+0x2f/0x70 arch/x86/entry/common.c:165
   entry_SYSENTER_compat_after_hwframe+0x4d/0x5c

-> (&kvm->arch.pvclock_gtod_sync_lock){+...}-{2:2} {
   HARDIRQ-ON-W at:
                    lock_acquire kernel/locking/lockdep.c:5510 [inline]
                    lock_acquire+0x1ab/0x740 kernel/locking/lockdep.c:5475
                    __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
                    _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
                    spin_lock include/linux/spinlock.h:354 [inline]
                    kvm_synchronize_tsc+0x459/0x1230 arch/x86/kvm/x86.c:2332
                    kvm_arch_vcpu_postcreate+0x73/0x180 arch/x86/kvm/x86.c:10183
                    kvm_vm_ioctl_create_vcpu arch/x86/kvm/../../../virt/kvm/kvm_main.c:3239 [inline]
                    kvm_vm_ioctl+0x1b2d/0x2800 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3839
                    kvm_vm_compat_ioctl+0x125/0x230 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4052
                    __do_compat_sys_ioctl+0x1d3/0x230 fs/ioctl.c:842
                    do_syscall_32_irqs_on arch/x86/entry/common.c:77 [inline]
                    __do_fast_syscall_32+0x56/0x90 arch/x86/entry/common.c:140
                    do_fast_syscall_32+0x2f/0x70 arch/x86/entry/common.c:165
                    entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
   INITIAL USE at:
                   lock_acquire kernel/locking/lockdep.c:5510 [inline]
                   lock_acquire+0x1ab/0x740 kernel/locking/lockdep.c:5475
                   __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
                   _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
                   spin_lock include/linux/spinlock.h:354 [inline]
                   get_kvmclock_ns+0x25/0x390 arch/x86/kvm/x86.c:2587
                   kvm_xen_update_runstate+0x3d/0x2c0 arch/x86/kvm/xen.c:69
                   kvm_xen_update_runstate_guest+0x74/0x320 arch/x86/kvm/xen.c:100
                   kvm_xen_runstate_set_preempted arch/x86/kvm/xen.h:96 [inline]
                   kvm_arch_vcpu_put+0x2d8/0x5a0 arch/x86/kvm/x86.c:4062
                   kvm_sched_out+0xbf/0x100 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4876
                   __fire_sched_out_preempt_notifiers kernel/sched/core.c:3922 [inline]
                   fire_sched_out_preempt_notifiers kernel/sched/core.c:3930 [inline]
                   prepare_task_switch kernel/sched/core.c:4126 [inline]
                   context_switch kernel/sched/core.c:4274 [inline]
                   __schedule+0xfd0/0x21b0 kernel/sched/core.c:5073
                   preempt_schedule_common+0x45/0xc0 kernel/sched/core.c:5233
                   preempt_schedule_thunk+0x16/0x18 arch/x86/entry/thunk_64.S:35
                   __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:161 [inline]
                   _raw_spin_unlock_irqrestore+0x57/0x70 kernel/locking/spinlock.c:191
                   kvm_synchronize_tsc+0x451/0x1230 arch/x86/kvm/x86.c:2330
                   kvm_arch_vcpu_postcreate+0x73/0x180 arch/x86/kvm/x86.c:10183
                   kvm_vm_ioctl_create_vcpu arch/x86/kvm/../../../virt/kvm/kvm_main.c:3239 [inline]
                   kvm_vm_ioctl+0x1b2d/0x2800 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3839
                   kvm_vm_compat_ioctl+0x125/0x230 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4052
                   __do_compat_sys_ioctl+0x1d3/0x230 fs/ioctl.c:842
                   do_syscall_32_irqs_on arch/x86/entry/common.c:77 [inline]
                   __do_fast_syscall_32+0x56/0x90 arch/x86/entry/common.c:140
                   do_fast_syscall_32+0x2f/0x70 arch/x86/entry/common.c:165
                   entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
 }
 ... key      at: [<ffffffff8f371000>] __key.4+0x0/0x40
 ... acquired at:
   mark_usage kernel/locking/lockdep.c:4387 [inline]
   __lock_acquire+0x837/0x54c0 kernel/locking/lockdep.c:4854
   lock_acquire kernel/locking/lockdep.c:5510 [inline]
   lock_acquire+0x1ab/0x740 kernel/locking/lockdep.c:5475
   __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
   _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
   spin_lock include/linux/spinlock.h:354 [inline]
   kvm_synchronize_tsc+0x459/0x1230 arch/x86/kvm/x86.c:2332
   kvm_arch_vcpu_postcreate+0x73/0x180 arch/x86/kvm/x86.c:10183
   kvm_vm_ioctl_create_vcpu arch/x86/kvm/../../../virt/kvm/kvm_main.c:3239 [inline]
   kvm_vm_ioctl+0x1b2d/0x2800 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3839
   kvm_vm_compat_ioctl+0x125/0x230 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4052
   __do_compat_sys_ioctl+0x1d3/0x230 fs/ioctl.c:842
   do_syscall_32_irqs_on arch/x86/entry/common.c:77 [inline]
   __do_fast_syscall_32+0x56/0x90 arch/x86/entry/common.c:140
   do_fast_syscall_32+0x2f/0x70 arch/x86/entry/common.c:165
   entry_SYSENTER_compat_after_hwframe+0x4d/0x5c


stack backtrace:
CPU: 1 PID: 8381 Comm: syz-executor859 Not tainted 5.12.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 print_irq_inversion_bug kernel/locking/lockdep.c:202 [inline]
 check_usage_backwards kernel/locking/lockdep.c:3951 [inline]
 mark_lock_irq kernel/locking/lockdep.c:4041 [inline]
 mark_lock.cold+0x1d/0x8e kernel/locking/lockdep.c:4478
 mark_usage kernel/locking/lockdep.c:4387 [inline]
 __lock_acquire+0x837/0x54c0 kernel/locking/lockdep.c:4854
 lock_acquire kernel/locking/lockdep.c:5510 [inline]
 lock_acquire+0x1ab/0x740 kernel/locking/lockdep.c:5475
 __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
 _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
 spin_lock include/linux/spinlock.h:354 [inline]
 kvm_synchronize_tsc+0x459/0x1230 arch/x86/kvm/x86.c:2332
 kvm_arch_vcpu_postcreate+0x73/0x180 arch/x86/kvm/x86.c:10183
 kvm_vm_ioctl_create_vcpu arch/x86/kvm/../../../virt/kvm/kvm_main.c:3239 [inline]
 kvm_vm_ioctl+0x1b2d/0x2800 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3839
 kvm_vm_compat_ioctl+0x125/0x230 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4052
 __do_compat_sys_ioctl+0x1d3/0x230 fs/ioctl.c:842
 do_syscall_32_irqs_on arch/x86/entry/common.c:77 [inline]
 __do_fast_syscall_32+0x56/0x90 arch/x86/entry/common.c:140
 do_fast_syscall_32+0x2f/0x70 arch/x86/entry/common.c:165
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
RIP: 0023:0xf7fde549
Code: 03 74 c0 01 10 05 03 74 b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d b4 26 00 00 00 00 8d b4 26 00 00 00 00
RSP: 002b:00000000ff89f2ec EFLAGS: 00000217 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 000000000000ae41
RDX: 0000000000000000 RSI: 0000000000000036 RDI: 0000000000000004
RBP: 000000004038ae7a R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
