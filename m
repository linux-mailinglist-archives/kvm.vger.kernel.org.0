Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7470A48B0FA
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 16:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349561AbiAKPgm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 10:36:42 -0500
Received: from foss.arm.com ([217.140.110.172]:48400 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349601AbiAKPgk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jan 2022 10:36:40 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DC6231396;
        Tue, 11 Jan 2022 07:36:39 -0800 (PST)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 5DB993F774;
        Tue, 11 Jan 2022 07:36:35 -0800 (PST)
From:   Mark Rutland <mark.rutland@arm.com>
To:     linux-kernel@vger.kernel.org
Cc:     aleksandar.qemu.devel@gmail.com, alexandru.elisei@arm.com,
        anup.patel@wdc.com, aou@eecs.berkeley.edu, atish.patra@wdc.com,
        benh@kernel.crashing.org, borntraeger@linux.ibm.com, bp@alien8.de,
        catalin.marinas@arm.com, chenhuacai@kernel.org,
        dave.hansen@linux.intel.com, david@redhat.com,
        frankja@linux.ibm.com, frederic@kernel.org, gor@linux.ibm.com,
        hca@linux.ibm.com, imbrenda@linux.ibm.com, james.morse@arm.com,
        jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org,
        mark.rutland@arm.com, maz@kernel.org, mingo@redhat.com,
        mpe@ellerman.id.au, nsaenzju@redhat.com, palmer@dabbelt.com,
        paulmck@kernel.org, paulus@samba.org, paul.walmsley@sifive.com,
        pbonzini@redhat.com, seanjc@google.com, suzuki.poulose@arm.com,
        tglx@linutronix.de, tsbogend@alpha.franken.de, vkuznets@redhat.com,
        wanpengli@tencent.com, will@kernel.org
Subject: [PATCH 5/5] kvm/x86: rework guest entry logic
Date:   Tue, 11 Jan 2022 15:35:39 +0000
Message-Id: <20220111153539.2532246-6-mark.rutland@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220111153539.2532246-1-mark.rutland@arm.com>
References: <20220111153539.2532246-1-mark.rutland@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For consistency and clarity, migrate x86 over to the generic helpers for
guest timing and lockdep/RCU/tracing management, and remove the
x86-specific helpers.

Prior to this patch, the guest timing was entered in
kvm_guest_enter_irqoff() (called by svm_vcpu_enter_exit() and
svm_vcpu_enter_exit()), and was exited by the call to
vtime_account_guest_exit() within vcpu_enter_guest().

To minimize duplication and to more clearly balance entry and exit, both
entry and exit of guest timing are placed in vcpu_enter_guest(), using
the new guest_timing_{enter,exit}_irqoff() helpers. This may result in a
small amount of additional time being acounted towards guests.

Other than this, there should be no functional change as a result of
this patch.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jim Mattson <jmattson@google.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/svm/svm.c |  4 ++--
 arch/x86/kvm/vmx/vmx.c |  4 ++--
 arch/x86/kvm/x86.c     |  4 +++-
 arch/x86/kvm/x86.h     | 45 ------------------------------------------
 4 files changed, 7 insertions(+), 50 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 5151efa424ac..af5d90de243f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3814,7 +3814,7 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 	unsigned long vmcb_pa = svm->current_vmcb->pa;
 
-	kvm_guest_enter_irqoff();
+	exit_to_guest_mode();
 
 	if (sev_es_guest(vcpu->kvm)) {
 		__svm_sev_es_vcpu_run(vmcb_pa);
@@ -3834,7 +3834,7 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu)
 		vmload(__sme_page_pa(sd->save_area));
 	}
 
-	kvm_guest_exit_irqoff();
+	enter_from_guest_mode();
 }
 
 static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0dbf94eb954f..3dd240ef6414 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6593,7 +6593,7 @@ static fastpath_t vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
 static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 					struct vcpu_vmx *vmx)
 {
-	kvm_guest_enter_irqoff();
+	exit_to_guest_mode();
 
 	/* L1D Flush includes CPU buffer clear to mitigate MDS */
 	if (static_branch_unlikely(&vmx_l1d_should_flush))
@@ -6609,7 +6609,7 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 
 	vcpu->arch.cr2 = native_read_cr2();
 
-	kvm_guest_exit_irqoff();
+	enter_from_guest_mode();
 }
 
 static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e50e97ac4408..bd3873b90889 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9876,6 +9876,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		set_debugreg(0, 7);
 	}
 
+	guest_timing_enter_irqoff();
+
 	for (;;) {
 		/*
 		 * Assert that vCPU vs. VM APICv state is consistent.  An APICv
@@ -9949,7 +9951,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	 * of accounting via context tracking, but the loss of accuracy is
 	 * acceptable for all known use cases.
 	 */
-	vtime_account_guest_exit();
+	guest_timing_exit_irqoff();
 
 	if (lapic_in_kernel(vcpu)) {
 		s64 delta = vcpu->arch.apic->lapic_timer.advance_expire_delta;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 4abcd8d9836d..8e50645ac740 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -10,51 +10,6 @@
 
 void kvm_spurious_fault(void);
 
-static __always_inline void kvm_guest_enter_irqoff(void)
-{
-	/*
-	 * VMENTER enables interrupts (host state), but the kernel state is
-	 * interrupts disabled when this is invoked. Also tell RCU about
-	 * it. This is the same logic as for exit_to_user_mode().
-	 *
-	 * This ensures that e.g. latency analysis on the host observes
-	 * guest mode as interrupt enabled.
-	 *
-	 * guest_enter_irqoff() informs context tracking about the
-	 * transition to guest mode and if enabled adjusts RCU state
-	 * accordingly.
-	 */
-	instrumentation_begin();
-	trace_hardirqs_on_prepare();
-	lockdep_hardirqs_on_prepare(CALLER_ADDR0);
-	instrumentation_end();
-
-	guest_enter_irqoff();
-	lockdep_hardirqs_on(CALLER_ADDR0);
-}
-
-static __always_inline void kvm_guest_exit_irqoff(void)
-{
-	/*
-	 * VMEXIT disables interrupts (host state), but tracing and lockdep
-	 * have them in state 'on' as recorded before entering guest mode.
-	 * Same as enter_from_user_mode().
-	 *
-	 * context_tracking_guest_exit() restores host context and reinstates
-	 * RCU if enabled and required.
-	 *
-	 * This needs to be done immediately after VM-Exit, before any code
-	 * that might contain tracepoints or call out to the greater world,
-	 * e.g. before x86_spec_ctrl_restore_host().
-	 */
-	lockdep_hardirqs_off(CALLER_ADDR0);
-	context_tracking_guest_exit();
-
-	instrumentation_begin();
-	trace_hardirqs_off_finish();
-	instrumentation_end();
-}
-
 #define KVM_NESTED_VMENTER_CONSISTENCY_CHECK(consistency_check)		\
 ({									\
 	bool failed = (consistency_check);				\
-- 
2.30.2

