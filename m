Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 114159C949
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2019 08:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729744AbfHZGV5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 02:21:57 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:32965 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729345AbfHZGV4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 02:21:56 -0400
Received: by mail-pf1-f193.google.com with SMTP id g2so11123712pfq.0;
        Sun, 25 Aug 2019 23:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=qtEdnCpOZ70RJIft3u1CMIaVs4KO9kcBzg5gfhqx8OA=;
        b=t8X1kcmvap0Nk1XBO6j42QNQEOmEa6ru3YOApmFCk3HrpaUXT5SM1tYZpBoCGdzpSH
         mJpBwYAmK5sA2maiJTt2lSoX5kjlrQJR83zDbi3KWy/cZnk6yoCRRNP3YU0PhcZfYRqR
         J9d1943JdBmm9CQjbZFdU72NsJUrWoudowccIuqEIHUiylz9MqHg4Efea3/BQhDTac8N
         G1msbo7T4cd5rYyiZoluHpi/hca4iG0M2JPKK7P7G0klm4sYNQ02Ujh0gbHrkh80t7cK
         hDQQLw/SAKscTCOeo/+AMQ8ROshTtm4fR4QHOUEpjmu8p7R9uJcVJm6GXJLFqphmbQ2S
         AhbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=qtEdnCpOZ70RJIft3u1CMIaVs4KO9kcBzg5gfhqx8OA=;
        b=LtxkBpETrxxYNuNn5TaMoKYKH1bdsrsFbTtBiFfcGY2mpKMVVqw6uEo3L6PmRpWyxk
         ZBAM90qnmJsmkHURmKrKLu7pHA0u+UJfoCworJam41hJvcnGlZvQXyAKCi5hMxmNuY1s
         O2eA0+GVVYEknI7Kz0M612pHdKd9gTCu2CWSgdcw3Yc/wuxRhJh2cVYt2GxXyeh+xWh9
         H+cTLeQtvpRtfkQCB9IxncGwHKGBM2KhBMjNR+Jl23RRz+ahO9JOfmL9P8shI6AjQ1Hu
         3UruWHtf1B1rcgHUFWwGhVkl4k6Y+z8kzmd0+UJosctpAgiitAmaiA1s2/2M+bL0nFd7
         1CJw==
X-Gm-Message-State: APjAAAW9ERHuHw4Ca1U6I4Oeamw/XxyWyX91Gf4yn79Ky6RABqPs5vBm
        Kt45SrRTh+TK7ZZQTKTb8nYWEi40LBk=
X-Google-Smtp-Source: APXvYqz0e7PFOpGSOcWgWDWmQx8eIatHUihvxhSkKONIY7ijw6DTivHM16mqcBa2+Bp0QfaRcqDXxA==
X-Received: by 2002:a62:38d7:: with SMTP id f206mr18585921pfa.102.1566800515063;
        Sun, 25 Aug 2019 23:21:55 -0700 (PDT)
Received: from surajjs2.ozlabs.ibm.com.ozlabs.ibm.com ([122.99.82.10])
        by smtp.gmail.com with ESMTPSA id f7sm10030353pfd.43.2019.08.25.23.21.52
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 25 Aug 2019 23:21:54 -0700 (PDT)
From:   Suraj Jitindar Singh <sjitindarsingh@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     paulus@ozlabs.org, kvm@vger.kernel.org,
        Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Subject: [PATCH 16/23] KVM: PPC: Book3S HV: Nested: Make kvmppc_run_vcpu() entry path nested capable
Date:   Mon, 26 Aug 2019 16:21:02 +1000
Message-Id: <20190826062109.7573-17-sjitindarsingh@gmail.com>
X-Mailer: git-send-email 2.13.6
In-Reply-To: <20190826062109.7573-1-sjitindarsingh@gmail.com>
References: <20190826062109.7573-1-sjitindarsingh@gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to run a hpt (hash page table) guest the kvm entry path used must
enter real mode before loading up the guest mmu state. Currently the
only path which does this is calling kvmppc_run_vcpu() which then uses
the entry path in book3s_hv_rmhandlers.S and until now this path didn't
accomodate running a nested guest.

Have the nested hpt guest entry path call kvmppc_run_vcpu() and modify
the entry path in book3s_hv_rmhandlers.S to be able to run a nested
guest.

For the entry path this means loading the smaller of the guest
hypervisor decrementer and the host decrementer into the host
decrementer since we want control back when either expires. Additionally
the correct LPID and LPCR must be loaded, and the guest slb entries must
be restored. When checking if an interrupt can be injected to the guest
in kvmppc_guest_entry_inject_int() we return -1 if entering a nested
guest while there is something pending for the L1 guest to indicate that
the nested guest shouldn't be entered and control should be passed back
to the L1 guest.

On the exit path we must save the guest slb entries to be returned to
the L1 guest hypervisor. Additionally the correct vrma_slb_v entry must
be loaded for kvmppc_hpte_hv_fault() if the guest was in real mode. The
correct hpt must be used in kvmppc_hpte_hv_fault(). And the correct
handle_exit function must be called depending on whether a nested guest
was being run or not.

Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
---
 arch/powerpc/include/asm/kvm_asm.h      |   5 ++
 arch/powerpc/include/asm/kvm_book3s.h   |   3 +-
 arch/powerpc/include/asm/kvm_ppc.h      |   2 +-
 arch/powerpc/kernel/asm-offsets.c       |   5 ++
 arch/powerpc/kvm/book3s_64_mmu_hv.c     |   2 +-
 arch/powerpc/kvm/book3s_hv.c            |  55 +++++++-------
 arch/powerpc/kvm/book3s_hv_builtin.c    |  33 ++++++---
 arch/powerpc/kvm/book3s_hv_interrupts.S |  25 ++++++-
 arch/powerpc/kvm/book3s_hv_nested.c     |   2 +-
 arch/powerpc/kvm/book3s_hv_rm_mmu.c     |  80 +++++++++++++++------
 arch/powerpc/kvm/book3s_hv_rmhandlers.S | 124 ++++++++++++++++++++++----------
 arch/powerpc/kvm/book3s_xive.h          |  15 ++++
 12 files changed, 252 insertions(+), 99 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_asm.h b/arch/powerpc/include/asm/kvm_asm.h
index 635fb154b33f..83bfd74ce67c 100644
--- a/arch/powerpc/include/asm/kvm_asm.h
+++ b/arch/powerpc/include/asm/kvm_asm.h
@@ -104,6 +104,11 @@
  * completely in the guest.
  */
 #define BOOK3S_INTERRUPT_HV_RM_HARD	0x5555
+/*
+ * Special trap used when running a nested guest to communicate that control
+ * should be passed back to the L1 guest. e.g. Because interrupt pending
+ */
+#define BOOK3S_INTERRUPT_HV_NEST_EXIT	0x5556
 
 #define BOOK3S_IRQPRIO_SYSTEM_RESET		0
 #define BOOK3S_IRQPRIO_DATA_SEGMENT		1
diff --git a/arch/powerpc/include/asm/kvm_book3s.h b/arch/powerpc/include/asm/kvm_book3s.h
index e1dc1872e453..f13dab096dad 100644
--- a/arch/powerpc/include/asm/kvm_book3s.h
+++ b/arch/powerpc/include/asm/kvm_book3s.h
@@ -158,7 +158,7 @@ extern void kvmppc_mmu_flush_segments(struct kvm_vcpu *vcpu);
 extern int kvmppc_book3s_hv_page_fault(struct kvm_run *run,
 			struct kvm_vcpu *vcpu, unsigned long addr,
 			unsigned long status);
-extern long kvmppc_hv_find_lock_hpte(struct kvm *kvm, gva_t eaddr,
+extern long kvmppc_hv_find_lock_hpte(struct kvm_hpt_info *hpt, gva_t eaddr,
 			unsigned long slb_v, unsigned long valid);
 extern int kvmppc_hv_emulate_mmio(struct kvm_run *run, struct kvm_vcpu *vcpu,
 			unsigned long gpa, gva_t ea, int is_store);
@@ -315,6 +315,7 @@ void kvmhv_release_all_nested(struct kvm *kvm);
 long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu);
 long kvmhv_do_nested_tlbie(struct kvm_vcpu *vcpu);
 int kvmhv_run_single_vcpu(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu);
+int kvmppc_run_vcpu(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu);
 void kvmhv_save_hv_regs(struct kvm_vcpu *vcpu, struct hv_guest_state *hr);
 void kvmhv_save_guest_slb(struct kvm_vcpu *vcpu, struct guest_slb *slbp);
 void kvmhv_restore_guest_slb(struct kvm_vcpu *vcpu, struct guest_slb *slbp);
diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index 2c4d659cf8bb..46bbdc38b2c5 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -697,7 +697,7 @@ int kvmppc_rm_h_ipi(struct kvm_vcpu *vcpu, unsigned long server,
                     unsigned long mfrr);
 int kvmppc_rm_h_cppr(struct kvm_vcpu *vcpu, unsigned long cppr);
 int kvmppc_rm_h_eoi(struct kvm_vcpu *vcpu, unsigned long xirr);
-void kvmppc_guest_entry_inject_int(struct kvm_vcpu *vcpu);
+int kvmppc_guest_entry_inject_int(struct kvm_vcpu *vcpu);
 
 /*
  * Host-side operations we want to set up while running in real
diff --git a/arch/powerpc/kernel/asm-offsets.c b/arch/powerpc/kernel/asm-offsets.c
index 4ccb6b3a7fbd..7652ad430aab 100644
--- a/arch/powerpc/kernel/asm-offsets.c
+++ b/arch/powerpc/kernel/asm-offsets.c
@@ -511,9 +511,14 @@ int main(void)
 	OFFSET(VCPU_VPA, kvm_vcpu, arch.vpa.pinned_addr);
 	OFFSET(VCPU_VPA_DIRTY, kvm_vcpu, arch.vpa.dirty);
 	OFFSET(VCPU_HEIR, kvm_vcpu, arch.emul_inst);
+	OFFSET(VCPU_LPCR, kvm_vcpu, arch.lpcr);
 	OFFSET(VCPU_NESTED, kvm_vcpu, arch.nested);
+	OFFSET(VCPU_NESTED_LPID, kvm_nested_guest, shadow_lpid);
+	OFFSET(VCPU_NESTED_RADIX, kvm_nested_guest, radix);
+	OFFSET(VCPU_NESTED_VRMA_SLB_V, kvm_nested_guest, vrma_slb_v);
 	OFFSET(VCPU_CPU, kvm_vcpu, cpu);
 	OFFSET(VCPU_THREAD_CPU, kvm_vcpu, arch.thread_cpu);
+	OFFSET(VCPU_HDEC_EXP, kvm_vcpu, arch.hdec_exp);
 #endif
 #ifdef CONFIG_PPC_BOOK3S
 	OFFSET(VCPU_PURR, kvm_vcpu, arch.purr);
diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
index bbb23b3f8bb9..2b30b48dce49 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -361,7 +361,7 @@ static int kvmppc_mmu_book3s_64_hv_xlate(struct kvm_vcpu *vcpu, gva_t eaddr,
 
 	preempt_disable();
 	/* Find the HPTE in the hash table */
-	index = kvmppc_hv_find_lock_hpte(kvm, eaddr, slb_v,
+	index = kvmppc_hv_find_lock_hpte(&kvm->arch.hpt, eaddr, slb_v,
 					 HPTE_V_VALID | HPTE_V_ABSENT);
 	if (index < 0) {
 		preempt_enable();
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 8407071d5e22..4020bb52fca7 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -74,6 +74,7 @@
 #include <asm/hw_breakpoint.h>
 
 #include "book3s.h"
+#include "book3s_xive.h"
 
 #define CREATE_TRACE_POINTS
 #include "trace_hv.h"
@@ -1520,7 +1521,11 @@ static int kvmppc_handle_nested_exit(struct kvm_run *run, struct kvm_vcpu *vcpu)
 	/* We're good on these - the host merely wanted to get our attention */
 	case BOOK3S_INTERRUPT_HV_DECREMENTER:
 		vcpu->stat.dec_exits++;
-		r = RESUME_GUEST;
+		/* if the guest hdec has expired then it wants control back */
+		if (mftb() >= vcpu->arch.hdec_exp)
+			r = RESUME_HOST;
+		else
+			r = RESUME_GUEST;
 		break;
 	case BOOK3S_INTERRUPT_EXTERNAL:
 		vcpu->stat.ext_intr_exits++;
@@ -1583,6 +1588,15 @@ static int kvmppc_handle_nested_exit(struct kvm_run *run, struct kvm_vcpu *vcpu)
 		if (!xics_on_xive())
 			kvmppc_xics_rm_complete(vcpu, 0);
 		break;
+	case BOOK3S_INTERRUPT_HV_NEST_EXIT:
+		/*
+		 * Occurs on nested guest entry path to indicate that control
+		 * should be passed back to l1 guest hypervisor.
+		 * e.g. because of pending interrupt
+		 */
+		vcpu->arch.trap = 0;
+		r = RESUME_HOST;
+		break;
 	default:
 		r = RESUME_HOST;
 		break;
@@ -2957,7 +2971,6 @@ static void post_guest_process(struct kvmppc_vcore *vc, bool is_master)
 {
 	int still_running = 0, i;
 	u64 now;
-	long ret;
 	struct kvm_vcpu *vcpu;
 
 	spin_lock(&vc->lock);
@@ -2978,13 +2991,16 @@ static void post_guest_process(struct kvmppc_vcore *vc, bool is_master)
 
 		trace_kvm_guest_exit(vcpu);
 
-		ret = RESUME_GUEST;
-		if (vcpu->arch.trap)
-			ret = kvmppc_handle_exit_hv(vcpu->arch.kvm_run, vcpu,
-						    vcpu->arch.run_task);
-
-		vcpu->arch.ret = ret;
-		vcpu->arch.trap = 0;
+		vcpu->arch.ret = RESUME_GUEST;
+		if (vcpu->arch.trap) {
+			if (vcpu->arch.nested)
+				vcpu->arch.ret = kvmppc_handle_nested_exit(
+						 vcpu->arch.kvm_run, vcpu);
+			else
+				vcpu->arch.ret = kvmppc_handle_exit_hv(
+						 vcpu->arch.kvm_run, vcpu,
+						 vcpu->arch.run_task);
+		}
 
 		spin_lock(&vc->lock);
 		if (is_kvmppc_resume_guest(vcpu->arch.ret)) {
@@ -3297,6 +3313,7 @@ static noinline void kvmppc_run_core(struct kvmppc_vcore *vc)
 			if (!vcpu->arch.ptid)
 				thr0_done = true;
 			active |= 1 << (thr + vcpu->arch.ptid);
+			vcpu->arch.trap = 0;
 		}
 		/*
 		 * We need to start the first thread of each subcore
@@ -3847,21 +3864,6 @@ static void shrink_halt_poll_ns(struct kvmppc_vcore *vc)
 		vc->halt_poll_ns /= halt_poll_ns_shrink;
 }
 
-#ifdef CONFIG_KVM_XICS
-static inline bool xive_interrupt_pending(struct kvm_vcpu *vcpu)
-{
-	if (!xics_on_xive())
-		return false;
-	return vcpu->arch.irq_pending || vcpu->arch.xive_saved_state.pipr <
-		vcpu->arch.xive_saved_state.cppr;
-}
-#else
-static inline bool xive_interrupt_pending(struct kvm_vcpu *vcpu)
-{
-	return false;
-}
-#endif /* CONFIG_KVM_XICS */
-
 static bool kvmppc_vcpu_woken(struct kvm_vcpu *vcpu)
 {
 	if (vcpu->arch.pending_exceptions || vcpu->arch.prodded ||
@@ -4013,7 +4015,7 @@ static int kvmhv_setup_mmu(struct kvm_vcpu *vcpu)
 	return r;
 }
 
-static int kvmppc_run_vcpu(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
+int kvmppc_run_vcpu(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
 {
 	int n_ceded, i, r;
 	struct kvmppc_vcore *vc;
@@ -4082,7 +4084,8 @@ static int kvmppc_run_vcpu(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
 			continue;
 		}
 		for_each_runnable_thread(i, v, vc) {
-			kvmppc_core_prepare_to_enter(v);
+			if (!vcpu->arch.nested)
+				kvmppc_core_prepare_to_enter(v);
 			if (signal_pending(v->arch.run_task)) {
 				kvmppc_remove_runnable(vc, v);
 				v->stat.signal_exits++;
diff --git a/arch/powerpc/kvm/book3s_hv_builtin.c b/arch/powerpc/kvm/book3s_hv_builtin.c
index 7c1909657b55..049c3111b530 100644
--- a/arch/powerpc/kvm/book3s_hv_builtin.c
+++ b/arch/powerpc/kvm/book3s_hv_builtin.c
@@ -759,26 +759,40 @@ void kvmhv_p9_restore_lpcr(struct kvm_split_mode *sip)
  * Is there a PRIV_DOORBELL pending for the guest (on POWER9)?
  * Can we inject a Decrementer or a External interrupt?
  */
-void kvmppc_guest_entry_inject_int(struct kvm_vcpu *vcpu)
+int kvmppc_guest_entry_inject_int(struct kvm_vcpu *vcpu)
 {
 	int ext;
 	unsigned long vec = 0;
-	unsigned long lpcr;
+	unsigned long old_lpcr, lpcr;
+
+#ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
+	/*
+	 * Don't enter a nested guest if there is something pending for this
+	 * vcpu for the l1 guest. Return -1 to indicate this.
+	 */
+	if (vcpu->arch.nested && (vcpu->arch.pending_exceptions ||
+				  vcpu->arch.prodded ||
+				  vcpu->arch.doorbell_request ||
+				  xive_interrupt_pending(vcpu)))
+		return -1;
+#endif
 
 	/* Insert EXTERNAL bit into LPCR at the MER bit position */
 	ext = (vcpu->arch.pending_exceptions >> BOOK3S_IRQPRIO_EXTERNAL) & 1;
-	lpcr = mfspr(SPRN_LPCR);
-	lpcr |= ext << LPCR_MER_SH;
-	mtspr(SPRN_LPCR, lpcr);
-	isync();
+	old_lpcr = mfspr(SPRN_LPCR);
+	lpcr = old_lpcr | (ext << LPCR_MER_SH);
+	if (lpcr != old_lpcr) {
+		mtspr(SPRN_LPCR, lpcr);
+		isync();
+	}
 
 	if (vcpu->arch.shregs.msr & MSR_EE) {
 		if (ext) {
 			vec = BOOK3S_INTERRUPT_EXTERNAL;
 		} else {
-			long int dec = mfspr(SPRN_DEC);
+			s64 dec = mfspr(SPRN_DEC);
 			if (!(lpcr & LPCR_LD))
-				dec = (int) dec;
+				dec = (s32) dec;
 			if (dec < 0)
 				vec = BOOK3S_INTERRUPT_DECREMENTER;
 		}
@@ -795,12 +809,13 @@ void kvmppc_guest_entry_inject_int(struct kvm_vcpu *vcpu)
 		vcpu->arch.shregs.msr = msr;
 	}
 
-	if (vcpu->arch.doorbell_request) {
+	if (cpu_has_feature(CPU_FTR_ARCH_300) && vcpu->arch.doorbell_request) {
 		mtspr(SPRN_DPDES, 1);
 		vcpu->arch.vcore->dpdes = 1;
 		smp_wmb();
 		vcpu->arch.doorbell_request = 0;
 	}
+	return 0;
 }
 
 static void flush_guest_tlb(struct kvm *kvm)
diff --git a/arch/powerpc/kvm/book3s_hv_interrupts.S b/arch/powerpc/kvm/book3s_hv_interrupts.S
index 63fd81f3039d..624f9951731d 100644
--- a/arch/powerpc/kvm/book3s_hv_interrupts.S
+++ b/arch/powerpc/kvm/book3s_hv_interrupts.S
@@ -58,10 +58,20 @@ END_FTR_SECTION_IFCLR(CPU_FTR_ARCH_207S)
 	/*
 	 * Put whatever is in the decrementer into the
 	 * hypervisor decrementer.
+	 * If running a nested guest then put the lower of the host decrementer
+	 * and the guest hypervisor decrementer into the hypervisor decrementer
+	 * since we want control back from the nested guest when either expires.
 	 */
 BEGIN_FTR_SECTION
 	ld	r5, HSTATE_KVM_VCORE(r13)
-	ld	r6, VCORE_KVM(r5)
+	ld	r6, HSTATE_KVM_VCPU(r13)
+	cmpdi   cr1, r6, 0              /* Do we actually have a vcpu? */
+	beq     cr1, 33f
+	ld      r7, VCPU_NESTED(r6)
+	cmpdi   cr1, r7, 0              /* Do we have a nested guest? */
+	beq     cr1, 33f
+	ld      r10, VCPU_HDEC_EXP(r6)  /* If so load the hdec expiry */
+33:	ld	r6, VCORE_KVM(r5)
 	ld	r9, KVM_HOST_LPCR(r6)
 	andis.	r9, r9, LPCR_LD@h
 END_FTR_SECTION_IFSET(CPU_FTR_ARCH_300)
@@ -72,8 +82,17 @@ BEGIN_FTR_SECTION
 	bne	32f
 END_FTR_SECTION_IFSET(CPU_FTR_ARCH_300)
 	extsw	r8,r8
-32:	mtspr	SPRN_HDEC,r8
-	add	r8,r8,r7
+BEGIN_FTR_SECTION
+32:	beq     cr1, 34f		/* did we load hdec expiry above? */
+	subf    r10, r7, r10		/* r10 = guest_hdec = hdec_exp - tb */
+	cmpd    r8, r10			/* host decrementer < hdec? */
+	ble     34f
+	mtspr   SPRN_HDEC, r10		/* put guest_hdec into the hv decr */
+	b       35f
+34:
+END_FTR_SECTION_IFSET(CPU_FTR_ARCH_300)
+	mtspr	SPRN_HDEC,r8		/* put host decr into hv decr */
+35:	add	r8,r8,r7
 	std	r8,HSTATE_DECEXP(r13)
 
 	/* Jump to partition switch code */
diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index f80491e9ff97..54d6ff0bee5b 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -386,7 +386,7 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
 		if (radix)
 			r = kvmhv_run_single_vcpu(vcpu->arch.kvm_run, vcpu);
 		else
-			r = RESUME_HOST; /* XXX TODO hpt entry path */
+			r = kvmppc_run_vcpu(vcpu->arch.kvm_run, vcpu);
 	} while (is_kvmppc_resume_guest(r));
 
 	/* save L2 state for return */
diff --git a/arch/powerpc/kvm/book3s_hv_rm_mmu.c b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
index 53fe51d04d78..a939782d8a5e 100644
--- a/arch/powerpc/kvm/book3s_hv_rm_mmu.c
+++ b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
@@ -1166,8 +1166,8 @@ static struct mmio_hpte_cache_entry *
  * preempt_disable(), otherwise, the holding of HPTE_V_HVLOCK
  * can trigger deadlock issue.
  */
-long kvmppc_hv_find_lock_hpte(struct kvm *kvm, gva_t eaddr, unsigned long slb_v,
-			      unsigned long valid)
+long kvmppc_hv_find_lock_hpte(struct kvm_hpt_info *hpt, gva_t eaddr,
+			     unsigned long slb_v, unsigned long valid)
 {
 	unsigned int i;
 	unsigned int pshift;
@@ -1195,7 +1195,7 @@ long kvmppc_hv_find_lock_hpte(struct kvm *kvm, gva_t eaddr, unsigned long slb_v,
 		somask = (1UL << 28) - 1;
 		vsid = (slb_v & ~SLB_VSID_B) >> SLB_VSID_SHIFT;
 	}
-	hash = (vsid ^ ((eaddr & somask) >> pshift)) & kvmppc_hpt_mask(&kvm->arch.hpt);
+	hash = (vsid ^ ((eaddr & somask) >> pshift)) & kvmppc_hpt_mask(hpt);
 	avpn = slb_v & ~(somask >> 16);	/* also includes B */
 	avpn |= (eaddr & somask) >> 16;
 
@@ -1206,7 +1206,7 @@ long kvmppc_hv_find_lock_hpte(struct kvm *kvm, gva_t eaddr, unsigned long slb_v,
 	val |= avpn;
 
 	for (;;) {
-		hpte = (__be64 *)(kvm->arch.hpt.virt + (hash << 7));
+		hpte = (__be64 *)(hpt->virt + (hash << 7));
 
 		for (i = 0; i < 16; i += 2) {
 			/* Read the PTE racily */
@@ -1242,7 +1242,7 @@ long kvmppc_hv_find_lock_hpte(struct kvm *kvm, gva_t eaddr, unsigned long slb_v,
 		if (val & HPTE_V_SECONDARY)
 			break;
 		val |= HPTE_V_SECONDARY;
-		hash = hash ^ kvmppc_hpt_mask(&kvm->arch.hpt);
+		hash = hash ^ kvmppc_hpt_mask(hpt);
 	}
 	return -1;
 }
@@ -1265,7 +1265,9 @@ long kvmppc_hpte_hv_fault(struct kvm_vcpu *vcpu, unsigned long addr,
 			  unsigned long slb_v, unsigned int status,
 			  bool data, bool is_realmode)
 {
+	struct kvm_nested_guest *nested;
 	struct kvm *kvm = vcpu->kvm;
+	struct kvm_hpt_info *hpt;
 	long int index;
 	unsigned long v, r, gr, orig_v;
 	__be64 *hpte;
@@ -1275,12 +1277,20 @@ long kvmppc_hpte_hv_fault(struct kvm_vcpu *vcpu, unsigned long addr,
 	struct mmio_hpte_cache_entry *cache_entry = NULL;
 	long mmio_update = 0;
 
+	hpt = &kvm->arch.hpt;
+	nested = vcpu->arch.nested;
+	if (nested)
+		hpt = &nested->shadow_hpt;
+
 	/* For protection fault, expect to find a valid HPTE */
 	valid = HPTE_V_VALID;
 	if (status & DSISR_NOHPTE) {
 		valid |= HPTE_V_ABSENT;
-		mmio_update = atomic64_read(&kvm->arch.mmio_update);
-		cache_entry = mmio_cache_search(vcpu, addr, slb_v, mmio_update);
+		if (!nested) {
+			mmio_update = atomic64_read(&kvm->arch.mmio_update);
+			cache_entry = mmio_cache_search(vcpu, addr, slb_v,
+							mmio_update);
+		}
 	}
 	if (cache_entry) {
 		index = cache_entry->pte_index;
@@ -1288,20 +1298,26 @@ long kvmppc_hpte_hv_fault(struct kvm_vcpu *vcpu, unsigned long addr,
 		r = cache_entry->hpte_r;
 		gr = cache_entry->rpte;
 	} else {
-		index = kvmppc_hv_find_lock_hpte(kvm, addr, slb_v, valid);
+		index = kvmppc_hv_find_lock_hpte(hpt, addr, slb_v, valid);
 		if (index < 0) {
-			if (status & DSISR_NOHPTE)
+			if (status & DSISR_NOHPTE) {
+				if (nested) {
+					/* have to look for HPTE in L1's HPT */
+					vcpu->arch.pgfault_index = index;
+					return -1;
+				}
 				return status;	/* there really was no HPTE */
+			}
 			return 0;	/* for prot fault, HPTE disappeared */
 		}
-		hpte = (__be64 *)(kvm->arch.hpt.virt + (index << 4));
+		hpte = (__be64 *)(hpt->virt + (index << 4));
 		v = orig_v = be64_to_cpu(hpte[0]) & ~HPTE_V_HVLOCK;
 		r = be64_to_cpu(hpte[1]);
 		if (cpu_has_feature(CPU_FTR_ARCH_300)) {
 			v = hpte_new_to_old_v(v, r);
 			r = hpte_new_to_old_r(r);
 		}
-		rev = &kvm->arch.hpt.rev[index];
+		rev = &hpt->rev[index];
 		if (is_realmode)
 			rev = real_vmalloc_addr(rev);
 		gr = rev->guest_rpte;
@@ -1318,17 +1334,25 @@ long kvmppc_hpte_hv_fault(struct kvm_vcpu *vcpu, unsigned long addr,
 	key = (vcpu->arch.shregs.msr & MSR_PR) ? SLB_VSID_KP : SLB_VSID_KS;
 	status &= ~DSISR_NOHPTE;	/* DSISR_NOHPTE == SRR1_ISI_NOPT */
 	if (!data) {
-		if (gr & (HPTE_R_N | HPTE_R_G))
-			return status | SRR1_ISI_N_OR_G;
-		if (!hpte_read_permission(pp, slb_v & key))
-			return status | SRR1_ISI_PROT;
+		if (gr & (HPTE_R_N | HPTE_R_G)) {
+			status |= SRR1_ISI_N_OR_G;
+			goto forward_to_guest;
+		}
+		if (!hpte_read_permission(pp, slb_v & key)) {
+			status |= SRR1_ISI_PROT;
+			goto forward_to_guest;
+		}
 	} else if (status & DSISR_ISSTORE) {
 		/* check write permission */
-		if (!hpte_write_permission(pp, slb_v & key))
-			return status | DSISR_PROTFAULT;
+		if (!hpte_write_permission(pp, slb_v & key)) {
+			status |= DSISR_PROTFAULT;
+			goto forward_to_guest;
+		}
 	} else {
-		if (!hpte_read_permission(pp, slb_v & key))
-			return status | DSISR_PROTFAULT;
+		if (!hpte_read_permission(pp, slb_v & key)) {
+			status |= DSISR_PROTFAULT;
+			goto forward_to_guest;
+		}
 	}
 
 	/* Check storage key, if applicable */
@@ -1343,13 +1367,14 @@ long kvmppc_hpte_hv_fault(struct kvm_vcpu *vcpu, unsigned long addr,
 	/* Save HPTE info for virtual-mode handler */
 	vcpu->arch.pgfault_addr = addr;
 	vcpu->arch.pgfault_index = index;
+
 	vcpu->arch.pgfault_hpte[0] = v;
 	vcpu->arch.pgfault_hpte[1] = r;
 	vcpu->arch.pgfault_cache = cache_entry;
 
 	/* Check the storage key to see if it is possibly emulated MMIO */
-	if ((r & (HPTE_R_KEY_HI | HPTE_R_KEY_LO)) ==
-	    (HPTE_R_KEY_HI | HPTE_R_KEY_LO)) {
+	if (!nested && (r & (HPTE_R_KEY_HI | HPTE_R_KEY_LO)) ==
+			    (HPTE_R_KEY_HI | HPTE_R_KEY_LO)) {
 		if (!cache_entry) {
 			unsigned int pshift = 12;
 			unsigned int pshift_index;
@@ -1373,5 +1398,18 @@ long kvmppc_hpte_hv_fault(struct kvm_vcpu *vcpu, unsigned long addr,
 	}
 
 	return -1;		/* send fault up to host kernel mode */
+
+forward_to_guest:
+	if (nested) {
+		/*
+		 * This was technically caused by missing permissions in the L1
+		 * pte, go up to the virtual mode handler so we can forward
+		 * this interrupt to L1.
+		 */
+		vcpu->arch.pgfault_index = -1;
+		vcpu->arch.fault_dsisr = status;
+		return -1;
+	}
+	return status;
 }
 EXPORT_SYMBOL_GPL(kvmppc_hpte_hv_fault);
diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
index 54e1864d4702..43cdd9f7fab5 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -606,15 +606,29 @@ kvmppc_hv_entry:
 	cmpwi	r6,0
 	bne	10f
 
-	lwz	r7,KVM_LPID(r9)
+	/* Load guest lpid (on P9 need to check if running a nested guest) */
 BEGIN_FTR_SECTION
+	cmpdi	r4, 0			/* do we have a vcpu? */
+	beq	19f
+	ld	r5, VCPU_NESTED(r4)	/* vcpu running nested guest? */
+	cmpdi	cr2, r5, 0		/* use cr2 as indication of nested */
+	/*
+	 * If we're using this entry path for a nested guest that nested guest
+	 * must be hash, otherwise we'd have used __kvmhv_vcpu_entry_p9.
+	 */
+	beq	cr2, 19f
+	ld	r7, VCPU_NESTED_LPID(r5)
+	b	20f
+19:
+FTR_SECTION_ELSE
 	ld	r6,KVM_SDR1(r9)
 	li	r0,LPID_RSVD		/* switch to reserved LPID */
 	mtspr	SPRN_LPID,r0
 	ptesync
 	mtspr	SPRN_SDR1,r6		/* switch to partition page table */
-END_FTR_SECTION_IFCLR(CPU_FTR_ARCH_300)
-	mtspr	SPRN_LPID,r7
+ALT_FTR_SECTION_END_IFSET(CPU_FTR_ARCH_300)
+	lwz	r7,KVM_LPID(r9)
+20:	mtspr	SPRN_LPID,r7
 	isync
 
 	/* See if we need to flush the TLB. */
@@ -892,7 +906,7 @@ ALT_FTR_SECTION_END_IFCLR(CPU_FTR_ARCH_300)
 	HMT_MEDIUM
 21:
 	/* Set LPCR. */
-	ld	r8,VCORE_LPCR(r5)
+	ld	r8,VCPU_LPCR(r4)
 	mtspr	SPRN_LPCR,r8
 	isync
 
@@ -915,10 +929,14 @@ ALT_FTR_SECTION_END_IFCLR(CPU_FTR_ARCH_300)
 	blt	hdec_soon
 
 	/* For hash guest, clear out and reload the SLB */
+BEGIN_FTR_SECTION
+	bne	cr2, 10f		/* cr2 indicates nested -> hash */
 	ld	r6, VCPU_KVM(r4)
 	lbz	r0, KVM_RADIX(r6)
 	cmpwi	r0, 0
 	bne	9f
+10:
+END_FTR_SECTION_IFSET(CPU_FTR_ARCH_300)
 	li	r6, 0
 	slbmte	r6, r6
 	slbia
@@ -1018,19 +1036,18 @@ no_xive:
 	stw	r0, STACK_SLOT_SHORT_PATH(r1)
 
 deliver_guest_interrupt:	/* r4 = vcpu, r13 = paca */
-	/* Check if we can deliver an external or decrementer interrupt now */
-	ld	r0, VCPU_PENDING_EXC(r4)
-BEGIN_FTR_SECTION
-	/* On POWER9, also check for emulated doorbell interrupt */
-	lbz	r3, VCPU_DBELL_REQ(r4)
-	or	r0, r0, r3
-END_FTR_SECTION_IFSET(CPU_FTR_ARCH_300)
-	cmpdi	r0, 0
-	beq	71f
+	/* Check if we can deliver external/decrementer/dbell interrupt now */
 	mr	r3, r4
 	bl	kvmppc_guest_entry_inject_int
-	ld	r4, HSTATE_KVM_VCPU(r13)
+	cmpdi	r3, 0
+	beq	71f
+	/* kvmppc_guest_entry_inject_int returned -1 don't enter nested guest */
+	ld	r9, HSTATE_KVM_VCPU(r13)
+	li	r12, BOOK3S_INTERRUPT_HV_NEST_EXIT
+	b	guest_exit_cont
+
 71:
+	ld	r4, HSTATE_KVM_VCPU(r13)
 	ld	r6, VCPU_SRR0(r4)
 	ld	r7, VCPU_SRR1(r4)
 	mtspr	SPRN_SRR0, r6
@@ -1462,11 +1479,17 @@ guest_exit_cont:		/* r9 = vcpu, r12 = trap, r13 = paca */
 	bne	guest_exit_short_path
 
 	/* For hash guest, read the guest SLB and save it away */
-	ld	r5, VCPU_KVM(r9)
-	lbz	r0, KVM_RADIX(r5)
 	li	r5, 0
+BEGIN_FTR_SECTION
+	ld	r6, VCPU_NESTED(r9)	/* vcpu running nested guest? */
+	cmpdi	r6, 0
+	bne	4f			/* must be hash if we're nested */
+	ld	r7, VCPU_KVM(r9)
+	lbz	r0, KVM_RADIX(r7)
 	cmpwi	r0, 0
 	bne	3f			/* for radix, save 0 entries */
+4:
+END_FTR_SECTION_IFSET(CPU_FTR_ARCH_300)
 	lwz	r0,VCPU_SLB_NR(r9)	/* number of entries in SLB */
 	mtctr	r0
 	li	r6,0
@@ -1517,7 +1540,7 @@ guest_bypass:
 	mftb	r6
 	/* On P9, if the guest has large decr enabled, don't sign extend */
 BEGIN_FTR_SECTION
-	ld	r4, VCORE_LPCR(r3)
+	ld	r4, VCPU_LPCR(r9)
 	andis.	r4, r4, LPCR_LD@h
 	bne	16f
 END_FTR_SECTION_IFSET(CPU_FTR_ARCH_300)
@@ -1749,6 +1772,9 @@ END_FTR_SECTION_IFSET(CPU_FTR_ARCH_300)
 	/*
 	 * Are we running hash or radix ?
 	 */
+	ld	r6, VCPU_NESTED(r9)	/* vcpu running nested guest? */
+	cmpdi	r6, 0
+	bne	2f			/* must be hash if we're nested */
 	ld	r5, VCPU_KVM(r9)
 	lbz	r0, KVM_RADIX(r5)
 	cmpwi	cr2, r0, 0
@@ -2036,22 +2062,38 @@ kvmppc_tm_emul:
  * reflect the HDSI to the guest as a DSI.
  */
 kvmppc_hdsi:
-	ld	r3, VCPU_KVM(r9)
-	lbz	r0, KVM_RADIX(r3)
 	mfspr	r4, SPRN_HDAR
 	mfspr	r6, SPRN_HDSISR
 BEGIN_FTR_SECTION
 	/* Look for DSISR canary. If we find it, retry instruction */
 	cmpdi	r6, 0x7fff
 	beq	6f
+	/* Are we hash or radix? */
+	ld	r3, VCPU_NESTED(r9)
+	cmpdi	cr2, r3, 0
+	beq	cr2, 10f
+	lbz	r0, VCPU_NESTED_RADIX(r3)	/* nested check nested->radix */
+	b	11f
+10:	ld      r5, VCPU_KVM(r9)
+	lbz     r0, KVM_RADIX(r5)	/* !nested check kvm->arch.radix */
+11:	cmpwi	r0, 0
+	bne	.Lradix_hdsi            /* on radix, just save DAR/DSISR/ASDR */
 END_FTR_SECTION_IFSET(CPU_FTR_ARCH_300)
-	cmpwi	r0, 0
-	bne	.Lradix_hdsi		/* on radix, just save DAR/DSISR/ASDR */
 	/* HPTE not found fault or protection fault? */
 	andis.	r0, r6, (DSISR_NOHPTE | DSISR_PROTFAULT)@h
 	beq	1f			/* if not, send it to the guest */
 	andi.	r0, r11, MSR_DR		/* data relocation enabled? */
-	beq	3f
+	bne	3f
+	/* not relocated, load the VRMA_SLB_V for kvmppc_hpte_hv_fault() */
+BEGIN_FTR_SECTION
+	beq	cr2, 12f			/* cr2 indicates nested */
+	ld	r5, VCPU_NESTED_VRMA_SLB_V(r3)	/* r3 = nested (loaded above) */
+	b	4f
+END_FTR_SECTION_IFSET(CPU_FTR_ARCH_300)
+	ld	r5, VCPU_KVM(r9)
+12:	ld	r5, KVM_VRMA_SLB_V(r5)
+	b	4f
+3:
 BEGIN_FTR_SECTION
 	mfspr	r5, SPRN_ASDR		/* on POWER9, use ASDR to get VSID */
 	b	4f
@@ -2097,10 +2139,6 @@ fast_interrupt_c_return:
 	mr	r4, r9
 	b	fast_guest_return
 
-3:	ld	r5, VCPU_KVM(r9)	/* not relocated, use VRMA */
-	ld	r5, KVM_VRMA_SLB_V(r5)
-	b	4b
-
 	/* If this is for emulated MMIO, load the instruction word */
 2:	li	r8, KVM_INST_FETCH_FAILED	/* In case lwz faults */
 
@@ -2137,14 +2175,32 @@ fast_interrupt_c_return:
  * it is an HPTE not found fault for a page that we have paged out.
  */
 kvmppc_hisi:
-	ld	r3, VCPU_KVM(r9)
-	lbz	r0, KVM_RADIX(r3)
-	cmpwi	r0, 0
+BEGIN_FTR_SECTION
+	/* Are we hash or radix? */
+	ld	r3, VCPU_NESTED(r9)
+	cmpdi	cr2, r3, 0
+	beq	cr2, 10f
+	lbz	r0, VCPU_NESTED_RADIX(r3)	/* nested check nested->radix */
+	b	11f
+10:	ld      r6, VCPU_KVM(r9)
+	lbz     r0, KVM_RADIX(r6)	/* !nested check kvm->arch.radix */
+11:	cmpwi	r0, 0
 	bne	.Lradix_hisi		/* for radix, just save ASDR */
+END_FTR_SECTION_IFSET(CPU_FTR_ARCH_300)
 	andis.	r0, r11, SRR1_ISI_NOPT@h
 	beq	1f
 	andi.	r0, r11, MSR_IR		/* instruction relocation enabled? */
-	beq	3f
+	bne	3f
+	/* not relocated, load the VRMA_SLB_V for kvmppc_hpte_hv_fault() */
+BEGIN_FTR_SECTION
+	beq	cr2, 12f			/* cr2 indicates nested */
+	ld	r5, VCPU_NESTED_VRMA_SLB_V(r3)	/* r3 = nested (loaded above) */
+	b	4f
+END_FTR_SECTION_IFSET(CPU_FTR_ARCH_300)
+	ld	r6, VCPU_KVM(r9)
+12:	ld	r5, KVM_VRMA_SLB_V(r6)
+	b	4f
+3:
 BEGIN_FTR_SECTION
 	mfspr	r5, SPRN_ASDR		/* on POWER9, use ASDR to get VSID */
 	b	4f
@@ -2179,10 +2235,6 @@ END_FTR_SECTION_IFSET(CPU_FTR_ARCH_300)
 	bl	kvmppc_msr_interrupt
 	b	fast_interrupt_c_return
 
-3:	ld	r6, VCPU_KVM(r9)	/* not relocated, use VRMA */
-	ld	r5, KVM_VRMA_SLB_V(r6)
-	b	4b
-
 /*
  * Try to handle an hcall in real mode.
  * Returns to the guest if we handle it, or continues on up to
@@ -2624,8 +2676,8 @@ END_FTR_SECTION(CPU_FTR_TM | CPU_FTR_P9_TM_HV_ASSIST, 0)
 	mftb	r5
 BEGIN_FTR_SECTION
 	/* On P9 check whether the guest has large decrementer mode enabled */
-	ld	r6, HSTATE_KVM_VCORE(r13)
-	ld	r6, VCORE_LPCR(r6)
+	ld	r6, HSTATE_KVM_VCPU(r13)
+	ld	r6, VCPU_LPCR(r6)
 	andis.	r6, r6, LPCR_LD@h
 	bne	68f
 END_FTR_SECTION_IFSET(CPU_FTR_ARCH_300)
diff --git a/arch/powerpc/kvm/book3s_xive.h b/arch/powerpc/kvm/book3s_xive.h
index 50494d0ee375..d6f10d7ec4d2 100644
--- a/arch/powerpc/kvm/book3s_xive.h
+++ b/arch/powerpc/kvm/book3s_xive.h
@@ -283,5 +283,20 @@ int kvmppc_xive_attach_escalation(struct kvm_vcpu *vcpu, u8 prio,
 				  bool single_escalation);
 struct kvmppc_xive *kvmppc_xive_get_device(struct kvm *kvm, u32 type);
 
+static inline bool xive_interrupt_pending(struct kvm_vcpu *vcpu)
+{
+        if (!xics_on_xive())
+                return false;
+        return vcpu->arch.irq_pending || vcpu->arch.xive_saved_state.pipr <
+                vcpu->arch.xive_saved_state.cppr;
+}
+
+#else /* !CONFIG_KVM_XICS */
+
+static inline bool xive_interrupt_pending(struct kvm_vcpu *vcpu)
+{
+        return false;
+}
+
 #endif /* CONFIG_KVM_XICS */
 #endif /* _KVM_PPC_BOOK3S_XICS_H */
-- 
2.13.6

