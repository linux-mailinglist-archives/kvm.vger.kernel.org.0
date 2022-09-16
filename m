Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 216A15BA39F
	for <lists+kvm@lfdr.de>; Fri, 16 Sep 2022 02:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbiIPA4f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Sep 2022 20:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiIPA4e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Sep 2022 20:56:34 -0400
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [IPv6:2a0c:5a00:149::26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C0BF399F4
        for <kvm@vger.kernel.org>; Thu, 15 Sep 2022 17:56:31 -0700 (PDT)
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
        by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1oYzee-002MZx-9Z; Fri, 16 Sep 2022 02:56:28 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector2; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :Cc:To:From; bh=49J4uYjRuY4Q0suvxBomJDcMP4eg6stJ0Cp1naysTbk=; b=1Kaa8WqEp5ixY
        jUA8C9IUJ+2CD9OyAos+s7VXpdYHy0bkWZP31FwPEV/0rvrmycxrkVeR7TV39dTMTZFyTMB5MdpSb
        eVCnMNNR62Fi/pYUBb7sRMiRZdteDO7kxfco0Qz1UXN4EfAjB4H5+anND+mdeltDl7i2/rm+VOtlh
        u52WHFXnINtNT/T4c2nfwY4BMDQK2fsqbuyj5ce5NA0YjJCVyPzMVSvz6+9p3fsnDBNOkRa9FbNJV
        8xszopokylT0pfhXMOsiV2+lnyJDKcCMyqoxNPX+sanZrCmddJkfZnHM7IetXxvneEC8Mpk4u38Ba
        NjzqvPPAiaulWg0yGxEYQ==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1oYzed-00080w-Qq; Fri, 16 Sep 2022 02:56:28 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1oYzeJ-0000xy-HL; Fri, 16 Sep 2022 02:56:07 +0200
From:   Michal Luczaj <mhal@rbox.co>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, shuah@kernel.org,
        Michal Luczaj <mhal@rbox.co>
Subject: [RFC PATCH 0/4] KVM: x86/xen: shinfo cache lock corruption
Date:   Fri, 16 Sep 2022 02:54:01 +0200
Message-Id: <20220916005405.2362180-1-mhal@rbox.co>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There seem to be two problems with the way arch.xen.shinfo_cache
instance of gfn_to_pfn_cache is treated.

1. gpc->lock is taken without checking if it was actually initialized.
   e.g. kvm_xen_set_evtchn_fast():

	read_lock_irqsave(&gpc->lock, flags);
	if (!kvm_gfn_to_pfn_cache_check(kvm, gpc, gpc->gpa, PAGE_SIZE))
		goto out_rcu;

INFO: trying to register non-static key.
The code is fine but needs lockdep annotation, or maybe
you didn't initialize this object before use?
turning off the locking correctness validator.
CPU: 2 PID: 959 Comm: xenirq Not tainted 6.0.0-rc5 #12
Call Trace:
 dump_stack_lvl+0x5b/0x77
 register_lock_class+0x46d/0x480
 __lock_acquire+0x64/0x1fa0
 lock_acquire+0xbf/0x2b0
 ? kvm_xen_set_evtchn_fast+0xc7/0x400 [kvm]
 ? lock_acquire+0xcf/0x2b0
 ? _raw_read_lock_irqsave+0x99/0xa0
 _raw_read_lock_irqsave+0x81/0xa0
 ? kvm_xen_set_evtchn_fast+0xc7/0x400 [kvm]
 kvm_xen_set_evtchn_fast+0xc7/0x400 [kvm]
 ? kvm_xen_set_evtchn_fast+0x7e/0x400 [kvm]
 ? find_held_lock+0x2b/0x80
 kvm_xen_hvm_evtchn_send+0x4b/0x90 [kvm]
 kvm_arch_vm_ioctl+0x4de/0xca0 [kvm]
 ? vmx_vcpu_put+0x18/0x1e0 [kvm_intel]
 ? kvm_arch_vcpu_put+0x1db/0x250 [kvm]
 ? vcpu_put+0x46/0x70 [kvm]
 ? kvm_arch_vcpu_ioctl+0xd0/0x1710 [kvm]
 kvm_vm_ioctl+0x4e4/0xdd0 [kvm]
 ? lock_is_held_type+0xe3/0x140
 __x64_sys_ioctl+0x8d/0xd0
 do_syscall_64+0x58/0x80
 ? __do_fast_syscall_32+0xeb/0xf0
 ? lockdep_hardirqs_on+0x7d/0x100
 ? lock_is_held_type+0xe3/0x140
 ? do_syscall_64+0x67/0x80
 ? lockdep_hardirqs_on+0x7d/0x100
 ? do_syscall_64+0x67/0x80
 ? lockdep_hardirqs_on+0x7d/0x100
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

2. kvm_gfn_to_pfn_cache_init() allows for gpc->lock reinitialization.
   This can lead to situation where a lock that is already taken gets
   reinitialized in another thread (and becomes corrupted).

   For example: a race between ioctl(KVM_XEN_HVM_EVTCHN_SEND) and
   kvm_gfn_to_pfn_cache_init():

                  (thread 1)                |           (thread 2)
                                            |
   kvm_xen_set_evtchn_fast                  |
    read_lock_irqsave(&gpc->lock, ...)      |
                                            | kvm_gfn_to_pfn_cache_init
                                            |  rwlock_init(&gpc->lock)
    read_unlock_irqrestore(&gpc->lock, ...) |

Testing shinfo lock corruption (KVM_XEN_HVM_EVTCHN_SEND)
rcu: INFO: rcu_preempt detected expedited stalls on CPUs/tasks: { 1-...D
 } 26610 jiffies s: 265 root: 0x2/.
rcu: blocking rcu_node structures (internal RCU debug):
Task dump for CPU 1:
task:xen_shinfo_test state:R  running task     stack:    0 pid:  952
ppid:   867 flags:0x00000008
Call Trace:
 ? exc_page_fault+0x121/0x2b0
 ? rcu_read_lock_sched_held+0x10/0x80
 ? entry_SYSCALL_64_after_hwframe+0x63/0xcd
rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	1-...0: (5 ticks this GP) idle=6b94/1/0x4000000000000000
softirq=5929/5931 fqs=15261
	(detected by 0, t=65002 jiffies, g=5465, q=100 ncpus=4)
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 PID: 952 Comm: xen_shinfo_test Not tainted 6.0.0-rc5 #12
RIP: 0010:queued_write_lock_slowpath+0x68/0x90
Call Trace:
 do_raw_write_lock+0xad/0xb0
 kvm_gfn_to_pfn_cache_refresh+0x2a5/0x630 [kvm]
 kvm_xen_hvm_set_attr+0x19d/0x5e0 [kvm]
 kvm_arch_vm_ioctl+0x8ca/0xca0 [kvm]
 ? rcu_read_lock_sched_held+0x10/0x80
 kvm_vm_ioctl+0x4e4/0xdd0 [kvm]
 ? rcu_read_lock_sched_held+0x10/0x80
 ? do_raw_write_trylock+0x29/0x40
 ? rcu_read_lock_sched_held+0x10/0x80
 ? lock_release+0x1ef/0x2d0
 ? lock_release+0x1ef/0x2d0
 __x64_sys_ioctl+0x8d/0xd0
 do_syscall_64+0x58/0x80
 ? exc_page_fault+0x121/0x2b0
 ? rcu_read_lock_sched_held+0x10/0x80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Testing shinfo lock corruption (KVM_XEN_HVM_EVTCHN_SEND)
BUG: kernel NULL pointer dereference, address: 0000000000000800
#PF: supervisor write access in kernel mode
#PF: error_code(0x0002) - not-present page
PGD 1049cf067 P4D 1049cf067 PUD 104ba0067 PMD 0
Oops: 0002 [#1] PREEMPT SMP NOPTI
CPU: 0 PID: 955 Comm: xen_shinfo_test Not tainted 6.0.0-rc5 #12
RIP: 0010:kvm_xen_set_evtchn_fast+0x10f/0x400 [kvm]
Call Trace:
 kvm_xen_hvm_evtchn_send+0x4b/0x90 [kvm]
 kvm_arch_vm_ioctl+0x4de/0xca0 [kvm]
 ? kvm_xen_hvm_evtchn_send+0x6e/0x90 [kvm]
 ? kvm_arch_vm_ioctl+0x4de/0xca0 [kvm]
 kvm_vm_ioctl+0x4e4/0xdd0 [kvm]
 ? kvm_vm_ioctl+0x4e4/0xdd0 [kvm]
 ? rcu_read_lock_sched_held+0x10/0x80
 ? lock_release+0x1ef/0x2d0
 __x64_sys_ioctl+0x8d/0xd0
 do_syscall_64+0x58/0x80
 ? rcu_read_lock_sched_held+0x10/0x80
 ? trace_hardirqs_on_prepare+0x55/0xe0
 ? do_syscall_64+0x67/0x80
 ? rcu_read_lock_sched_held+0x10/0x80
 ? trace_hardirqs_on_prepare+0x55/0xe0
 ? do_syscall_64+0x67/0x80
 ? do_syscall_64+0x67/0x80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

   Similar story with the handling of hypercall SCHEDOP_poll in
   wait_pending_event():

Testing shinfo lock corruption (SCHEDOP_poll)
rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	1-...0: (12 ticks this GP) idle=0a5c/1/0x4000000000000000
softirq=6640/6640 fqs=12988
rcu: 	2-...0: (10 ticks this GP) idle=66e4/1/0x4000000000000000
softirq=5526/5527 fqs=12988
	(detected by 0, t=65003 jiffies, g=7437, q=732 ncpus=4)
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1 skipped: idling at native_halt+0xa/0x10
Sending NMI from CPU 0 to CPUs 2:
NMI backtrace for cpu 2
CPU: 2 PID: 970 Comm: xen_shinfo_test Not tainted 6.0.0-rc5 #12
RIP: 0010:queued_write_lock_slowpath+0x66/0x90
Call Trace:
 do_raw_write_lock+0xad/0xb0
 kvm_gfn_to_pfn_cache_refresh+0x8a/0x630 [kvm]
 ? kvm_gfn_to_pfn_cache_init+0x122/0x130 [kvm]
 kvm_xen_hvm_set_attr+0x19d/0x5e0 [kvm]
 kvm_arch_vm_ioctl+0x8ca/0xca0 [kvm]
 ? __lock_acquire+0x3a4/0x1fa0
 ? __lock_acquire+0x3a4/0x1fa0
 kvm_vm_ioctl+0x4e4/0xdd0 [kvm]
 ? lock_is_held_type+0xe3/0x140
 ? lock_release+0x135/0x2d0
 __x64_sys_ioctl+0x8d/0xd0
 do_syscall_64+0x58/0x80
 ? lockdep_hardirqs_on+0x7d/0x100
 ? do_syscall_64+0x67/0x80
 ? do_syscall_64+0x67/0x80
 ? do_syscall_64+0x67/0x80
 ? do_syscall_64+0x67/0x80
 ? do_syscall_64+0x67/0x80
 ? do_syscall_64+0x67/0x80
 ? do_syscall_64+0x67/0x80
 ? lockdep_hardirqs_on+0x7d/0x100
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Testing shinfo lock corruption (SCHEDOP_poll)
watchdog: BUG: soft lockup - CPU#1 stuck for 23s! [kworker/1:2:260]
irq event stamp: 6990
hardirqs last  enabled at (6989): [<ffffffff81e5c964>]
_raw_spin_unlock_irq+0x24/0x50
hardirqs last disabled at (6990): [<ffffffff81e53e51>]
__schedule+0xd41/0x1620
softirqs last  enabled at (5790): [<ffffffff81766e78>]
rht_deferred_worker+0x708/0xbe0
softirqs last disabled at (5788): [<ffffffff81766967>]
rht_deferred_worker+0x1f7/0xbe0
CPU: 1 PID: 260 Comm: kworker/1:2 Not tainted 6.0.0-rc5 #12
Workqueue: rcu_gp wait_rcu_exp_gp
RIP: 0010:smp_call_function_single+0x11a/0x160
Call Trace:
 ? trace_hardirqs_on+0x2b/0xd0
 __sync_rcu_exp_select_node_cpus+0x267/0x460
 sync_rcu_exp_select_cpus+0x1ec/0x3e0
 wait_rcu_exp_gp+0xf/0x20
 process_one_work+0x254/0x560
 worker_thread+0x4f/0x390
 ? _raw_spin_unlock_irqrestore+0x40/0x60
 ? process_one_work+0x560/0x560
 kthread+0xe6/0x110
 ? kthread_complete_and_exit+0x20/0x20
 ret_from_fork+0x1f/0x30

I'm providing a set of patches: check if shinfo lock was initialized,
disallow lock reinitialization.  Along with crudely made testcases.

Note: as I understand, kvm->lock mutex cannot be used to protect from
those races because of kvm_xen_set_evtchn_fast() being called from
kvm_arch_set_irq_inatomic()?

I'm sending this as a RFC as I have doubts if explicitly disallowing
reinitialization this way is the most elegant solution.  Especially as
the problem appears to affect only the shinfo gfn_to_pfn_cache.

Michal Luczaj (4):
  KVM: x86/xen: Ensure kvm_xen_set_evtchn_fast() can use shinfo_cache
  KVM: x86/xen: Ensure kvm_xen_schedop_poll() can use shinfo_cache
  KVM: x86/xen: Disallow gpc locks reinitialization
  KVM: x86/xen: Test shinfo_cache lock races

 arch/x86/kvm/xen.c                            |   5 +-
 include/linux/kvm_types.h                     |   1 +
 .../selftests/kvm/x86_64/xen_shinfo_test.c    | 100 ++++++++++++++++++
 virt/kvm/pfncache.c                           |   7 +-
 4 files changed, 110 insertions(+), 3 deletions(-)

-- 
2.37.2

