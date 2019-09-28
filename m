Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 083F4C1180
	for <lists+kvm@lfdr.de>; Sat, 28 Sep 2019 19:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728911AbfI1RXh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 Sep 2019 13:23:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39604 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728813AbfI1RX0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 28 Sep 2019 13:23:26 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 63F5F308FC23;
        Sat, 28 Sep 2019 17:23:26 +0000 (UTC)
Received: from mail (ovpn-125-159.rdu2.redhat.com [10.10.125.159])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2A5F3100033E;
        Sat, 28 Sep 2019 17:23:26 +0000 (UTC)
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 13/14] KVM: retpolines: x86: eliminate retpoline from svm.c exit handlers
Date:   Sat, 28 Sep 2019 13:23:22 -0400
Message-Id: <20190928172323.14663-14-aarcange@redhat.com>
In-Reply-To: <20190928172323.14663-1-aarcange@redhat.com>
References: <20190928172323.14663-1-aarcange@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Sat, 28 Sep 2019 17:23:26 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It's enough to check the exit value and issue a direct call to avoid
the retpoline for all the common vmexit reasons.

After this commit is applied, here the most common retpolines executed
under a high resolution timer workload in the guest on a SVM host:

[..]
@[
    trace_retpoline+1
    __trace_retpoline+30
    __x86_indirect_thunk_rax+33
    ktime_get_update_offsets_now+70
    hrtimer_interrupt+131
    smp_apic_timer_interrupt+106
    apic_timer_interrupt+15
    start_sw_timer+359
    restart_apic_timer+85
    kvm_set_msr_common+1497
    msr_interception+142
    vcpu_enter_guest+684
    kvm_arch_vcpu_ioctl_run+261
    kvm_vcpu_ioctl+559
    do_vfs_ioctl+164
    ksys_ioctl+96
    __x64_sys_ioctl+22
    do_syscall_64+89
    entry_SYSCALL_64_after_hwframe+68
]: 1940
@[
    trace_retpoline+1
    __trace_retpoline+30
    __x86_indirect_thunk_r12+33
    force_qs_rnp+217
    rcu_gp_kthread+1270
    kthread+268
    ret_from_fork+34
]: 4644
@[]: 25095
@[
    trace_retpoline+1
    __trace_retpoline+30
    __x86_indirect_thunk_rax+33
    lapic_next_event+28
    clockevents_program_event+148
    hrtimer_start_range_ns+528
    start_sw_timer+356
    restart_apic_timer+85
    kvm_set_msr_common+1497
    msr_interception+142
    vcpu_enter_guest+684
    kvm_arch_vcpu_ioctl_run+261
    kvm_vcpu_ioctl+559
    do_vfs_ioctl+164
    ksys_ioctl+96
    __x64_sys_ioctl+22
    do_syscall_64+89
    entry_SYSCALL_64_after_hwframe+68
]: 41474
@[
    trace_retpoline+1
    __trace_retpoline+30
    __x86_indirect_thunk_rax+33
    clockevents_program_event+148
    hrtimer_start_range_ns+528
    start_sw_timer+356
    restart_apic_timer+85
    kvm_set_msr_common+1497
    msr_interception+142
    vcpu_enter_guest+684
    kvm_arch_vcpu_ioctl_run+261
    kvm_vcpu_ioctl+559
    do_vfs_ioctl+164
    ksys_ioctl+96
    __x64_sys_ioctl+22
    do_syscall_64+89
    entry_SYSCALL_64_after_hwframe+68
]: 41474
@[
    trace_retpoline+1
    __trace_retpoline+30
    __x86_indirect_thunk_rax+33
    ktime_get+58
    clockevents_program_event+84
    hrtimer_start_range_ns+528
    start_sw_timer+356
    restart_apic_timer+85
    kvm_set_msr_common+1497
    msr_interception+142
    vcpu_enter_guest+684
    kvm_arch_vcpu_ioctl_run+261
    kvm_vcpu_ioctl+559
    do_vfs_ioctl+164
    ksys_ioctl+96
    __x64_sys_ioctl+22
    do_syscall_64+89
    entry_SYSCALL_64_after_hwframe+68
]: 41887
@[
    trace_retpoline+1
    __trace_retpoline+30
    __x86_indirect_thunk_rax+33
    lapic_next_event+28
    clockevents_program_event+148
    hrtimer_try_to_cancel+168
    hrtimer_cancel+21
    kvm_set_lapic_tscdeadline_msr+43
    kvm_set_msr_common+1497
    msr_interception+142
    vcpu_enter_guest+684
    kvm_arch_vcpu_ioctl_run+261
    kvm_vcpu_ioctl+559
    do_vfs_ioctl+164
    ksys_ioctl+96
    __x64_sys_ioctl+22
    do_syscall_64+89
    entry_SYSCALL_64_after_hwframe+68
]: 42723
@[
    trace_retpoline+1
    __trace_retpoline+30
    __x86_indirect_thunk_rax+33
    clockevents_program_event+148
    hrtimer_try_to_cancel+168
    hrtimer_cancel+21
    kvm_set_lapic_tscdeadline_msr+43
    kvm_set_msr_common+1497
    msr_interception+142
    vcpu_enter_guest+684
    kvm_arch_vcpu_ioctl_run+261
    kvm_vcpu_ioctl+559
    do_vfs_ioctl+164
    ksys_ioctl+96
    __x64_sys_ioctl+22
    do_syscall_64+89
    entry_SYSCALL_64_after_hwframe+68
]: 42766
@[
    trace_retpoline+1
    __trace_retpoline+30
    __x86_indirect_thunk_rax+33
    ktime_get+58
    clockevents_program_event+84
    hrtimer_try_to_cancel+168
    hrtimer_cancel+21
    kvm_set_lapic_tscdeadline_msr+43
    kvm_set_msr_common+1497
    msr_interception+142
    vcpu_enter_guest+684
    kvm_arch_vcpu_ioctl_run+261
    kvm_vcpu_ioctl+559
    do_vfs_ioctl+164
    ksys_ioctl+96
    __x64_sys_ioctl+22
    do_syscall_64+89
    entry_SYSCALL_64_after_hwframe+68
]: 42848
@[
    trace_retpoline+1
    __trace_retpoline+30
    __x86_indirect_thunk_rax+33
    ktime_get+58
    start_sw_timer+279
    restart_apic_timer+85
    kvm_set_msr_common+1497
    msr_interception+142
    vcpu_enter_guest+684
    kvm_arch_vcpu_ioctl_run+261
    kvm_vcpu_ioctl+559
    do_vfs_ioctl+164
    ksys_ioctl+96
    __x64_sys_ioctl+22
    do_syscall_64+89
    entry_SYSCALL_64_after_hwframe+68
]: 499845

@total: 1780243

SVM has no TSC based programmable preemption timer so it is invoking
ktime_get() frequently.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 arch/x86/kvm/svm.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 50c57112c0ce..4d8370fcd212 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -4989,6 +4989,20 @@ int kvm_x86_handle_exit(struct kvm_vcpu *vcpu)
 		return 0;
 	}
 
+#ifdef CONFIG_RETPOLINE
+	if (exit_code == SVM_EXIT_MSR)
+		return msr_interception(svm);
+	else if (exit_code == SVM_EXIT_VINTR)
+		return interrupt_window_interception(svm);
+	else if (exit_code == SVM_EXIT_INTR)
+		return intr_interception(svm);
+	else if (exit_code == SVM_EXIT_HLT)
+		return halt_interception(svm);
+	else if (exit_code == SVM_EXIT_NPF)
+		return npf_interception(svm);
+	else if (exit_code == SVM_EXIT_CPUID)
+		return cpuid_interception(svm);
+#endif
 	return svm_exit_handlers[exit_code](svm);
 }
 
