Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 035F0DE9A
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2019 11:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727271AbfD2JDF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Apr 2019 05:03:05 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:40017 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727200AbfD2JDF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Apr 2019 05:03:05 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 44szFy3qLkz9sCJ; Mon, 29 Apr 2019 19:03:02 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1556528582; bh=qf4761kTIePZBgJphDQX6ZIJc5NLwCPm2CD+O8zVfUE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZXtLwr+gPy0HVWqA2UswFu88QPngnd2Tg4u620Mu35RcVIUBsMC6mL43dx1EQhPXr
         SmlW5FcdkiUxLuguX4ae2MIUHAownL21PaBkAHk98Qmyh+jo61CCOYacDBDLf2H00g
         eCrQDhovGdNChMgdUBcN+r7W2kAq8Mpy2mS7V6oO7Hv59mYE8AG43268Kpvyp34CDj
         6fq8YBb2ir+lwcv6GRqDuRSb4zLKOHpKibdPMfm3THaj5j+2sqrjMB3Yf+1MNErV3a
         q5yo573m6vBhcj9YY2daxgrQR8M1iHuVx4LxmbWKHq2seacwR5HNe6uFIidY2GIqyH
         0f1rdwXwCdg5Q==
Date:   Mon, 29 Apr 2019 19:02:58 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org, Nick Piggin <npiggin@au1.ibm.com>
Subject: [PATCH 2/2] KVM: PPC: Book3S HV: Flush TLB on secondary radix threads
Message-ID: <20190429090258.GB18822@blackberry>
References: <20190429090040.GA18822@blackberry>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190429090040.GA18822@blackberry>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When running on POWER9 with kvm_hv.indep_threads_mode = N and the host
in SMT1 mode, KVM will run guest VCPUs on offline secondary threads.
If those guests are in radix mode, we fail to load the LPID and flush
the TLB if necessary, leading to the guest crashing with an
unsupported MMU fault.  This arises from commit 9a4506e11b97 ("KVM:
PPC: Book3S HV: Make radix handle process scoped LPID flush in C,
with relocation on", 2018-05-17), which didn't consider the case
where indep_threads_mode = N.

For simplicity, this makes the real-mode guest entry path flush the
TLB in the same place for both radix and hash guests, as we did before
9a4506e11b97, though the code is now C code rather than assembly code.
We also have the radix TLB flush open-coded rather than calling
radix__local_flush_tlb_lpid_guest(), because the TLB flush can be
called in real mode, and in real mode we don't want to invoke the
tracepoint code.

Fixes: 9a4506e11b97 ("KVM: PPC: Book3S HV: Make radix handle process scoped LPID flush in C, with relocation on")
Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
---
 arch/powerpc/include/asm/kvm_ppc.h      |  3 +-
 arch/powerpc/kvm/book3s_hv.c            | 55 +++++----------------------------
 arch/powerpc/kvm/book3s_hv_builtin.c    | 52 ++++++++++++++++++++++++-------
 arch/powerpc/kvm/book3s_hv_rmhandlers.S |  6 ++--
 4 files changed, 53 insertions(+), 63 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index f8f7d76..27e5478 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -481,7 +481,8 @@ extern void kvm_hv_vm_activated(void);
 extern void kvm_hv_vm_deactivated(void);
 extern bool kvm_hv_mode_active(void);
 
-extern void kvmppc_hpt_check_need_tlb_flush(struct kvm *kvm);
+extern void kvmppc_check_need_tlb_flush(struct kvm *kvm, int pcpu,
+					struct kvm_nested_guest *nested);
 
 #else
 static inline void __init kvm_cma_reserve(void)
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 0fab0a2..c26acbe 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -2505,37 +2505,6 @@ static void kvmppc_prepare_radix_vcpu(struct kvm_vcpu *vcpu, int pcpu)
 	}
 }
 
-static void kvmppc_radix_check_need_tlb_flush(struct kvm *kvm, int pcpu,
-					      struct kvm_nested_guest *nested)
-{
-	cpumask_t *need_tlb_flush;
-	int lpid;
-
-	if (!cpu_has_feature(CPU_FTR_HVMODE))
-		return;
-
-	if (cpu_has_feature(CPU_FTR_ARCH_300))
-		pcpu &= ~0x3UL;
-
-	if (nested) {
-		lpid = nested->shadow_lpid;
-		need_tlb_flush = &nested->need_tlb_flush;
-	} else {
-		lpid = kvm->arch.lpid;
-		need_tlb_flush = &kvm->arch.need_tlb_flush;
-	}
-
-	mtspr(SPRN_LPID, lpid);
-	isync();
-	smp_mb();
-
-	if (cpumask_test_cpu(pcpu, need_tlb_flush)) {
-		radix__local_flush_tlb_lpid_guest(lpid);
-		/* Clear the bit after the TLB flush */
-		cpumask_clear_cpu(pcpu, need_tlb_flush);
-	}
-}
-
 static void kvmppc_start_thread(struct kvm_vcpu *vcpu, struct kvmppc_vcore *vc)
 {
 	int cpu;
@@ -3229,20 +3198,6 @@ static noinline void kvmppc_run_core(struct kvmppc_vcore *vc)
 	for (sub = 0; sub < core_info.n_subcores; ++sub)
 		spin_unlock(&core_info.vc[sub]->lock);
 
-	if (kvm_is_radix(vc->kvm)) {
-		/*
-		 * Do we need to flush the process scoped TLB for the LPAR?
-		 *
-		 * On POWER9, individual threads can come in here, but the
-		 * TLB is shared between the 4 threads in a core, hence
-		 * invalidating on one thread invalidates for all.
-		 * Thus we make all 4 threads use the same bit here.
-		 *
-		 * Hash must be flushed in realmode in order to use tlbiel.
-		 */
-		kvmppc_radix_check_need_tlb_flush(vc->kvm, pcpu, NULL);
-	}
-
 	/*
 	 * Interrupts will be enabled once we get into the guest,
 	 * so tell lockdep that we're about to enable interrupts.
@@ -3968,7 +3923,7 @@ int kvmhv_run_single_vcpu(struct kvm_run *kvm_run,
 			  unsigned long lpcr)
 {
 	int trap, r, pcpu;
-	int srcu_idx;
+	int srcu_idx, lpid;
 	struct kvmppc_vcore *vc;
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_nested_guest *nested = vcpu->arch.nested;
@@ -4044,8 +3999,12 @@ int kvmhv_run_single_vcpu(struct kvm_run *kvm_run,
 	vc->vcore_state = VCORE_RUNNING;
 	trace_kvmppc_run_core(vc, 0);
 
-	if (cpu_has_feature(CPU_FTR_HVMODE))
-		kvmppc_radix_check_need_tlb_flush(kvm, pcpu, nested);
+	if (cpu_has_feature(CPU_FTR_HVMODE)) {
+		lpid = nested ? nested->shadow_lpid : kvm->arch.lpid;
+		mtspr(SPRN_LPID, lpid);
+		isync();
+		kvmppc_check_need_tlb_flush(kvm, pcpu, nested);
+	}
 
 	trace_hardirqs_on();
 	guest_enter_irqoff();
diff --git a/arch/powerpc/kvm/book3s_hv_builtin.c b/arch/powerpc/kvm/book3s_hv_builtin.c
index 489abe5..6035d24 100644
--- a/arch/powerpc/kvm/book3s_hv_builtin.c
+++ b/arch/powerpc/kvm/book3s_hv_builtin.c
@@ -806,11 +806,40 @@ void kvmppc_guest_entry_inject_int(struct kvm_vcpu *vcpu)
 	}
 }
 
-void kvmppc_hpt_check_need_tlb_flush(struct kvm *kvm)
+static void flush_guest_tlb(struct kvm *kvm)
 {
-	int pcpu = raw_smp_processor_id();
 	unsigned long rb, set;
 
+	rb = PPC_BIT(52);	/* IS = 2 */
+	if (kvm_is_radix(kvm)) {
+		/* R=1 PRS=1 RIC=2 */
+		asm volatile(PPC_TLBIEL(%0, %4, %3, %2, %1)
+			     : : "r" (rb), "i" (1), "i" (1), "i" (2),
+			       "r" (0) : "memory");
+		for (set = 1; set < kvm->arch.tlb_sets; ++set) {
+			rb += PPC_BIT(51);	/* increment set number */
+			/* R=1 PRS=1 RIC=0 */
+			asm volatile(PPC_TLBIEL(%0, %4, %3, %2, %1)
+				     : : "r" (rb), "i" (1), "i" (1), "i" (0),
+				       "r" (0) : "memory");
+		}
+	} else {
+		for (set = 0; set < kvm->arch.tlb_sets; ++set) {
+			/* R=0 PRS=0 RIC=0 */
+			asm volatile(PPC_TLBIEL(%0, %4, %3, %2, %1)
+				     : : "r" (rb), "i" (0), "i" (0), "i" (0),
+				       "r" (0) : "memory");
+			rb += PPC_BIT(51);	/* increment set number */
+		}
+	}
+	asm volatile("ptesync": : :"memory");
+}
+
+void kvmppc_check_need_tlb_flush(struct kvm *kvm, int pcpu,
+				 struct kvm_nested_guest *nested)
+{
+	cpumask_t *need_tlb_flush;
+
 	/*
 	 * On POWER9, individual threads can come in here, but the
 	 * TLB is shared between the 4 threads in a core, hence
@@ -820,17 +849,16 @@ void kvmppc_hpt_check_need_tlb_flush(struct kvm *kvm)
 	if (cpu_has_feature(CPU_FTR_ARCH_300))
 		pcpu = cpu_first_thread_sibling(pcpu);
 
-	if (cpumask_test_cpu(pcpu, &kvm->arch.need_tlb_flush)) {
-		rb = PPC_BIT(52);	/* IS = 2 */
-		for (set = 0; set < kvm->arch.tlb_sets; ++set) {
-			asm volatile(PPC_TLBIEL(%0, %4, %3, %2, %1)
-				     : : "r" (rb), "i" (0), "i" (0), "i" (0),
-				       "r" (0) : "memory");
-			rb += PPC_BIT(51);	/* increment set number */
-		}
-		asm volatile("ptesync": : :"memory");
+	if (nested)
+		need_tlb_flush = &nested->need_tlb_flush;
+	else
+		need_tlb_flush = &kvm->arch.need_tlb_flush;
+
+	if (cpumask_test_cpu(pcpu, need_tlb_flush)) {
+		flush_guest_tlb(kvm);
 
 		/* Clear the bit after the TLB flush */
-		cpumask_clear_cpu(pcpu, &kvm->arch.need_tlb_flush);
+		cpumask_clear_cpu(pcpu, need_tlb_flush);
 	}
 }
+EXPORT_SYMBOL_GPL(kvmppc_check_need_tlb_flush);
diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
index 6bfa0c1..5df137d 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -622,9 +622,11 @@ END_FTR_SECTION_IFCLR(CPU_FTR_ARCH_300)
 	mtspr	SPRN_LPID,r7
 	isync
 
-	/* See if we need to flush the TLB. Hash has to be done in RM */
+	/* See if we need to flush the TLB. */
 	mr	r3, r9			/* kvm pointer */
-	bl	kvmppc_hpt_check_need_tlb_flush
+	lhz	r4, PACAPACAINDEX(r13)	/* physical cpu number */
+	li	r5, 0			/* nested vcpu pointer */
+	bl	kvmppc_check_need_tlb_flush
 	nop
 	ld	r5, HSTATE_KVM_VCORE(r13)
 
-- 
2.7.4

