Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21884209B14
	for <lists+kvm@lfdr.de>; Thu, 25 Jun 2020 10:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390736AbgFYIEb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jun 2020 04:04:31 -0400
Received: from 8bytes.org ([81.169.241.247]:48824 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390482AbgFYIDc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jun 2020 04:03:32 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id C9519391; Thu, 25 Jun 2020 10:03:30 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 2/4] KVM: SVM: Add vmcb_ prefix to mark_*() functions
Date:   Thu, 25 Jun 2020 10:03:23 +0200
Message-Id: <20200625080325.28439-3-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200625080325.28439-1-joro@8bytes.org>
References: <20200625080325.28439-1-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Make it more clear what data structure these functions operate on.

No functional changes.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/kvm/svm/avic.c   |  2 +-
 arch/x86/kvm/svm/nested.c |  6 +++---
 arch/x86/kvm/svm/sev.c    |  2 +-
 arch/x86/kvm/svm/svm.c    | 44 +++++++++++++++++++--------------------
 arch/x86/kvm/svm/svm.h    |  8 +++----
 5 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index e80daa98682f..ac830cd50830 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -665,7 +665,7 @@ void svm_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 	} else {
 		vmcb->control.int_ctl &= ~AVIC_ENABLE_MASK;
 	}
-	mark_dirty(vmcb, VMCB_AVIC);
+	vmcb_mark_dirty(vmcb, VMCB_AVIC);
 
 	svm_set_pi_irte_mode(vcpu, activated);
 }
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 6bceafb19108..9845fab381bc 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -106,7 +106,7 @@ void recalc_intercepts(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *c, *h, *g;
 
-	mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
+	vmcb_mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
 
 	if (!is_guest_mode(&svm->vcpu))
 		return;
@@ -375,7 +375,7 @@ static void nested_prepare_vmcb_control(struct vcpu_svm *svm)
 	 */
 	recalc_intercepts(svm);
 
-	mark_all_dirty(svm->vmcb);
+	vmcb_mark_all_dirty(svm->vmcb);
 }
 
 void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
@@ -598,7 +598,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	svm->vmcb->save.cpl = 0;
 	svm->vmcb->control.exit_int_info = 0;
 
-	mark_all_dirty(svm->vmcb);
+	vmcb_mark_all_dirty(svm->vmcb);
 
 	trace_kvm_nested_vmexit_inject(nested_vmcb->control.exit_code,
 				       nested_vmcb->control.exit_info_1,
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 5573a97f1520..5eebfdcdbf4c 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1186,5 +1186,5 @@ void pre_sev_run(struct vcpu_svm *svm, int cpu)
 	svm->last_cpu = cpu;
 	sd->sev_vmcbs[asid] = svm->vmcb;
 	svm->vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ASID;
-	mark_dirty(svm->vmcb, VMCB_ASID);
+	vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
 }
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c0da4dd78ac5..4d9e19bb888f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -282,7 +282,7 @@ void svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 	}
 
 	svm->vmcb->save.efer = efer | EFER_SVME;
-	mark_dirty(svm->vmcb, VMCB_CR);
+	vmcb_mark_dirty(svm->vmcb, VMCB_CR);
 }
 
 static int is_external_interrupt(u32 info)
@@ -713,7 +713,7 @@ static void grow_ple_window(struct kvm_vcpu *vcpu)
 							pause_filter_count_max);
 
 	if (control->pause_filter_count != old) {
-		mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
+		vmcb_mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
 		trace_kvm_ple_window_update(vcpu->vcpu_id,
 					    control->pause_filter_count, old);
 	}
@@ -731,7 +731,7 @@ static void shrink_ple_window(struct kvm_vcpu *vcpu)
 						    pause_filter_count_shrink,
 						    pause_filter_count);
 	if (control->pause_filter_count != old) {
-		mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
+		vmcb_mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
 		trace_kvm_ple_window_update(vcpu->vcpu_id,
 					    control->pause_filter_count, old);
 	}
@@ -966,7 +966,7 @@ static u64 svm_write_l1_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
 
 	svm->vmcb->control.tsc_offset = offset + g_tsc_offset;
 
-	mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
+	vmcb_mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
 	return svm->vmcb->control.tsc_offset;
 }
 
@@ -1123,7 +1123,7 @@ static void init_vmcb(struct vcpu_svm *svm)
 		clr_exception_intercept(svm, UD_VECTOR);
 	}
 
-	mark_all_dirty(svm->vmcb);
+	vmcb_mark_all_dirty(svm->vmcb);
 
 	enable_gif(svm);
 
@@ -1257,7 +1257,7 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	if (unlikely(cpu != vcpu->cpu)) {
 		svm->asid_generation = 0;
-		mark_all_dirty(svm->vmcb);
+		vmcb_mark_all_dirty(svm->vmcb);
 	}
 
 #ifdef CONFIG_X86_64
@@ -1367,7 +1367,7 @@ static void svm_set_vintr(struct vcpu_svm *svm)
 	control->int_ctl &= ~V_INTR_PRIO_MASK;
 	control->int_ctl |= V_IRQ_MASK |
 		((/*control->int_vector >> 4*/ 0xf) << V_INTR_PRIO_SHIFT);
-	mark_dirty(svm->vmcb, VMCB_INTR);
+	vmcb_mark_dirty(svm->vmcb, VMCB_INTR);
 }
 
 static void svm_clear_vintr(struct vcpu_svm *svm)
@@ -1385,7 +1385,7 @@ static void svm_clear_vintr(struct vcpu_svm *svm)
 		svm->vmcb->control.int_ctl |= svm->nested.ctl.int_ctl & ~mask;
 	}
 
-	mark_dirty(svm->vmcb, VMCB_INTR);
+	vmcb_mark_dirty(svm->vmcb, VMCB_INTR);
 }
 
 static struct vmcb_seg *svm_seg(struct kvm_vcpu *vcpu, int seg)
@@ -1503,7 +1503,7 @@ static void svm_set_idt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
 
 	svm->vmcb->save.idtr.limit = dt->size;
 	svm->vmcb->save.idtr.base = dt->address ;
-	mark_dirty(svm->vmcb, VMCB_DT);
+	vmcb_mark_dirty(svm->vmcb, VMCB_DT);
 }
 
 static void svm_get_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
@@ -1520,7 +1520,7 @@ static void svm_set_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
 
 	svm->vmcb->save.gdtr.limit = dt->size;
 	svm->vmcb->save.gdtr.base = dt->address ;
-	mark_dirty(svm->vmcb, VMCB_DT);
+	vmcb_mark_dirty(svm->vmcb, VMCB_DT);
 }
 
 static void update_cr0_intercept(struct vcpu_svm *svm)
@@ -1531,7 +1531,7 @@ static void update_cr0_intercept(struct vcpu_svm *svm)
 	*hcr0 = (*hcr0 & ~SVM_CR0_SELECTIVE_MASK)
 		| (gcr0 & SVM_CR0_SELECTIVE_MASK);
 
-	mark_dirty(svm->vmcb, VMCB_CR);
+	vmcb_mark_dirty(svm->vmcb, VMCB_CR);
 
 	if (gcr0 == *hcr0) {
 		clr_cr_intercept(svm, INTERCEPT_CR0_READ);
@@ -1572,7 +1572,7 @@ void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
 		cr0 &= ~(X86_CR0_CD | X86_CR0_NW);
 	svm->vmcb->save.cr0 = cr0;
-	mark_dirty(svm->vmcb, VMCB_CR);
+	vmcb_mark_dirty(svm->vmcb, VMCB_CR);
 	update_cr0_intercept(svm);
 }
 
@@ -1592,7 +1592,7 @@ int svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 		cr4 |= X86_CR4_PAE;
 	cr4 |= host_cr4_mce;
 	to_svm(vcpu)->vmcb->save.cr4 = cr4;
-	mark_dirty(to_svm(vcpu)->vmcb, VMCB_CR);
+	vmcb_mark_dirty(to_svm(vcpu)->vmcb, VMCB_CR);
 	return 0;
 }
 
@@ -1624,7 +1624,7 @@ static void svm_set_segment(struct kvm_vcpu *vcpu,
 		/* This is symmetric with svm_get_segment() */
 		svm->vmcb->save.cpl = (var->dpl & 3);
 
-	mark_dirty(svm->vmcb, VMCB_SEG);
+	vmcb_mark_dirty(svm->vmcb, VMCB_SEG);
 }
 
 static void update_bp_intercept(struct kvm_vcpu *vcpu)
@@ -1651,7 +1651,7 @@ static void new_asid(struct vcpu_svm *svm, struct svm_cpu_data *sd)
 	svm->asid_generation = sd->asid_generation;
 	svm->vmcb->control.asid = sd->next_asid++;
 
-	mark_dirty(svm->vmcb, VMCB_ASID);
+	vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
 }
 
 static void svm_set_dr6(struct vcpu_svm *svm, unsigned long value)
@@ -1660,7 +1660,7 @@ static void svm_set_dr6(struct vcpu_svm *svm, unsigned long value)
 
 	if (unlikely(value != vmcb->save.dr6)) {
 		vmcb->save.dr6 = value;
-		mark_dirty(vmcb, VMCB_DR);
+		vmcb_mark_dirty(vmcb, VMCB_DR);
 	}
 }
 
@@ -1687,7 +1687,7 @@ static void svm_set_dr7(struct kvm_vcpu *vcpu, unsigned long value)
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	svm->vmcb->save.dr7 = value;
-	mark_dirty(svm->vmcb, VMCB_DR);
+	vmcb_mark_dirty(svm->vmcb, VMCB_DR);
 }
 
 static int pf_interception(struct vcpu_svm *svm)
@@ -2512,7 +2512,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 			return 1;
 		vcpu->arch.pat = data;
 		svm->vmcb->save.g_pat = data;
-		mark_dirty(svm->vmcb, VMCB_NPT);
+		vmcb_mark_dirty(svm->vmcb, VMCB_NPT);
 		break;
 	case MSR_IA32_SPEC_CTRL:
 		if (!msr->host_initiated &&
@@ -2617,7 +2617,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 			return 1;
 
 		svm->vmcb->save.dbgctl = data;
-		mark_dirty(svm->vmcb, VMCB_LBR);
+		vmcb_mark_dirty(svm->vmcb, VMCB_LBR);
 		if (data & (1ULL<<0))
 			svm_enable_lbrv(svm);
 		else
@@ -3477,7 +3477,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 		     SVM_EXIT_EXCP_BASE + MC_VECTOR))
 		svm_handle_mce(svm);
 
-	mark_all_clean(svm->vmcb);
+	vmcb_mark_all_clean(svm->vmcb);
 	return exit_fastpath;
 }
 
@@ -3489,7 +3489,7 @@ static void svm_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long root)
 	cr3 = __sme_set(root);
 	if (npt_enabled) {
 		svm->vmcb->control.nested_cr3 = cr3;
-		mark_dirty(svm->vmcb, VMCB_NPT);
+		vmcb_mark_dirty(svm->vmcb, VMCB_NPT);
 
 		/* Loading L2's CR3 is handled by enter_svm_guest_mode.  */
 		if (!test_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_avail))
@@ -3498,7 +3498,7 @@ static void svm_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long root)
 	}
 
 	svm->vmcb->save.cr3 = cr3;
-	mark_dirty(svm->vmcb, VMCB_CR);
+	vmcb_mark_dirty(svm->vmcb, VMCB_CR);
 }
 
 static int is_disabled(void)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 6a1864a1f029..76116f5b0d01 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -188,18 +188,18 @@ static inline struct kvm_svm *to_kvm_svm(struct kvm *kvm)
 	return container_of(kvm, struct kvm_svm, kvm);
 }
 
-static inline void mark_all_dirty(struct vmcb *vmcb)
+static inline void vmcb_mark_all_dirty(struct vmcb *vmcb)
 {
 	vmcb->control.clean = 0;
 }
 
-static inline void mark_all_clean(struct vmcb *vmcb)
+static inline void vmcb_mark_all_clean(struct vmcb *vmcb)
 {
 	vmcb->control.clean = ((1 << VMCB_DIRTY_MAX) - 1)
 			       & ~VMCB_ALWAYS_DIRTY_MASK;
 }
 
-static inline void mark_dirty(struct vmcb *vmcb, int bit)
+static inline void vmcb_mark_dirty(struct vmcb *vmcb, int bit)
 {
 	vmcb->control.clean &= ~(1 << bit);
 }
@@ -420,7 +420,7 @@ extern int avic;
 static inline void avic_update_vapic_bar(struct vcpu_svm *svm, u64 data)
 {
 	svm->vmcb->control.avic_vapic_bar = data & VMCB_AVIC_APIC_BAR_MASK;
-	mark_dirty(svm->vmcb, VMCB_AVIC);
+	vmcb_mark_dirty(svm->vmcb, VMCB_AVIC);
 }
 
 static inline bool avic_vcpu_is_running(struct kvm_vcpu *vcpu)
-- 
2.27.0

