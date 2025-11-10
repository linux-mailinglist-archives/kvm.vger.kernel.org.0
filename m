Return-Path: <kvm+bounces-62627-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 218D0C4997A
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 23:34:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 922B4188F0E5
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 22:33:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94AD3346FAB;
	Mon, 10 Nov 2025 22:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gAkH0EFa"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 712E3342C80
	for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 22:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762813799; cv=none; b=qKVHgiivdNaWUjvrgee6xWuFi/FZR1V4ymAeHIhY6OFLkt3dF4zrc6hyQQ1P5r1LWZhHmWCwBNR5cBhXRUQf+4SxYYdOuuzyk2CA4TYxRzDQOuxi0AWyaaUkC1jRLTC9CO2/noyEi7bZfw9HsosHE5uC1gv03Otr/X4gF2kmHJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762813799; c=relaxed/simple;
	bh=CTpWQljGo7SIhry3GJxSntCBsiNB6KyCQmBp87MfkfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H1LhPC/PNrv8wEwy5tgWMkiPubJicHrbQlOFhI8jjUBanF2SwW8nIjYp8Vl4aR0SSyLu0kg6WGwS4cRbC2PMloWDJI9rO/VzMRBLbPqEjqL39VBS40kyYG9DEwT8oHw3uF6Guix4siWN+x50s0kL+Byh4T0buVUXhO8jBd1RI1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gAkH0EFa; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762813795;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xHtrDPC89v7+CUaEieWClxIgYnDZlUoVlT/Iig2+OTQ=;
	b=gAkH0EFaP/dIEiCZyGQ4bGodwZ/t/x+YDmnTsjt7UuP9RkSRGn2MWCpb2H/ToyfxHS1463
	vfmJZdZw+pgDANcERyopR3Noqpkl6JzyYbNaD6c7rJjdVtMpheSAqG8uT6jA6KBNGXah9D
	UJCtQVwGOkYa4ojQj9cu/FHAcJyn38I=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v2 08/13] KVM: SVM: Rename vmcb->virt_ext to vmcb->misc_ctl2
Date: Mon, 10 Nov 2025 22:29:17 +0000
Message-ID: <20251110222922.613224-9-yosry.ahmed@linux.dev>
In-Reply-To: <20251110222922.613224-1-yosry.ahmed@linux.dev>
References: <20251110222922.613224-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

'virt' is confusing in the VMCB because it is relative and ambiguous.
The 'virt_ext' field includes bits for LBR virtualization and
VMSAVE/VMLOAD virtualization, so it's just another miscellaneous control
field. Name it as such.

While at it, move the definitions of the bits below those for
'misc_ctl' and rename them for consistency.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/include/asm/svm.h                    |  7 +++----
 arch/x86/kvm/svm/nested.c                     | 18 ++++++++---------
 arch/x86/kvm/svm/svm.c                        | 20 +++++++++----------
 arch/x86/kvm/svm/svm.h                        |  2 +-
 tools/testing/selftests/kvm/include/x86/svm.h |  8 ++++----
 .../selftests/kvm/x86/svm_lbr_nested_state.c  |  4 ++--
 6 files changed, 29 insertions(+), 30 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 76ec1d40e6461..a842018952d2c 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -148,7 +148,7 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 	u32 event_inj;
 	u32 event_inj_err;
 	u64 nested_cr3;
-	u64 virt_ext;
+	u64 misc_ctl2;
 	u32 clean;
 	u32 reserved_5;
 	u64 next_rip;
@@ -219,9 +219,6 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define X2APIC_MODE_SHIFT 30
 #define X2APIC_MODE_MASK (1 << X2APIC_MODE_SHIFT)
 
-#define LBR_CTL_ENABLE_MASK BIT_ULL(0)
-#define VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK BIT_ULL(1)
-
 #define SVM_INTERRUPT_SHADOW_MASK	BIT_ULL(0)
 #define SVM_GUEST_INTERRUPT_MASK	BIT_ULL(1)
 
@@ -240,6 +237,8 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define SVM_MISC_CTL_SEV_ENABLE		BIT(1)
 #define SVM_MISC_CTL_SEV_ES_ENABLE	BIT(2)
 
+#define SVM_MISC_CTL2_LBR_CTL_ENABLE		BIT_ULL(0)
+#define SVM_MISC_CTL2_V_VMLOAD_VMSAVE_ENABLE	BIT_ULL(1)
 
 #define SVM_TSC_RATIO_RSVD	0xffffff0000000000ULL
 #define SVM_TSC_RATIO_MIN	0x0000000000000001ULL
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 2a5c3788f954b..b8d65832c64de 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -117,7 +117,7 @@ static bool nested_vmcb_needs_vls_intercept(struct vcpu_svm *svm)
 	if (!nested_npt_enabled(svm))
 		return true;
 
-	if (!(svm->nested.ctl.virt_ext & VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK))
+	if (!(svm->nested.ctl.misc_ctl2 & SVM_MISC_CTL2_V_VMLOAD_VMSAVE_ENABLE))
 		return true;
 
 	return false;
@@ -180,7 +180,7 @@ void recalc_intercepts(struct vcpu_svm *svm)
 		vmcb_set_intercept(c, INTERCEPT_VMLOAD);
 		vmcb_set_intercept(c, INTERCEPT_VMSAVE);
 	} else {
-		WARN_ON(!(c->virt_ext & VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK));
+		WARN_ON(!(c->misc_ctl2 & SVM_MISC_CTL2_V_VMLOAD_VMSAVE_ENABLE));
 	}
 }
 
@@ -497,7 +497,7 @@ void __nested_copy_vmcb_control_to_cache(struct kvm_vcpu *vcpu,
 	to->event_inj_err       = from->event_inj_err;
 	to->next_rip            = from->next_rip;
 	to->nested_cr3          = from->nested_cr3;
-	to->virt_ext            = from->virt_ext;
+	to->misc_ctl2            = from->misc_ctl2;
 	to->pause_filter_count  = from->pause_filter_count;
 	to->pause_filter_thresh = from->pause_filter_thresh;
 
@@ -738,7 +738,7 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
 	}
 
 	if (unlikely(guest_cpu_cap_has(vcpu, X86_FEATURE_LBRV) &&
-		     (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK))) {
+		     (svm->nested.ctl.misc_ctl2 & SVM_MISC_CTL2_LBR_CTL_ENABLE))) {
 		/*
 		 * Reserved bits of DEBUGCTL are ignored.  Be consistent with
 		 * svm_set_msr's definition of reserved bits.
@@ -902,10 +902,10 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 			svm->soft_int_next_rip = vmcb12_rip;
 	}
 
-	/* LBR_CTL_ENABLE_MASK is controlled by svm_update_lbrv() */
+	/* SVM_MISC_CTL2_LBR_CTL_ENABLE is controlled by svm_update_lbrv() */
 
 	if (!nested_vmcb_needs_vls_intercept(svm))
-		vmcb02->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
+		vmcb02->control.misc_ctl2 |= SVM_MISC_CTL2_V_VMLOAD_VMSAVE_ENABLE;
 
 	if (guest_cpu_cap_has(vcpu, X86_FEATURE_PAUSEFILTER))
 		pause_count12 = svm->nested.ctl.pause_filter_count;
@@ -1257,7 +1257,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 		kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
 
 	if (unlikely(guest_cpu_cap_has(vcpu, X86_FEATURE_LBRV) &&
-		     (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK))) {
+		     (svm->nested.ctl.misc_ctl2 & SVM_MISC_CTL2_LBR_CTL_ENABLE))) {
 		svm_copy_lbrs(&vmcb12->save, &vmcb02->save);
 	} else {
 		svm_copy_lbrs(&vmcb01->save, &vmcb02->save);
@@ -1763,8 +1763,8 @@ static void nested_copy_vmcb_cache_to_control(struct vmcb_control_area *dst,
 	dst->event_inj            = from->event_inj;
 	dst->event_inj_err        = from->event_inj_err;
 	dst->next_rip             = from->next_rip;
-	dst->nested_cr3           = from->nested_cr3;
-	dst->virt_ext              = from->virt_ext;
+	dst->nested_cr3		  = from->nested_cr3;
+	dst->misc_ctl2		  = from->misc_ctl2;
 	dst->pause_filter_count   = from->pause_filter_count;
 	dst->pause_filter_thresh  = from->pause_filter_thresh;
 	/* 'clean' and 'hv_enlightenments' are not changed by KVM */
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b5b4965e6bfdd..9789f7e72ae97 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -705,7 +705,7 @@ void *svm_alloc_permissions_map(unsigned long size, gfp_t gfp_mask)
 
 static void svm_recalc_lbr_msr_intercepts(struct kvm_vcpu *vcpu)
 {
-	bool intercept = !(to_svm(vcpu)->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK);
+	bool intercept = !(to_svm(vcpu)->vmcb->control.misc_ctl2 & SVM_MISC_CTL2_LBR_CTL_ENABLE);
 
 	svm_set_intercept_for_msr(vcpu, MSR_IA32_LASTBRANCHFROMIP, MSR_TYPE_RW, intercept);
 	svm_set_intercept_for_msr(vcpu, MSR_IA32_LASTBRANCHTOIP, MSR_TYPE_RW, intercept);
@@ -797,7 +797,7 @@ static void svm_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
 
 static void __svm_enable_lbrv(struct kvm_vcpu *vcpu)
 {
-	to_svm(vcpu)->vmcb->control.virt_ext |= LBR_CTL_ENABLE_MASK;
+	to_svm(vcpu)->vmcb->control.misc_ctl2 |= SVM_MISC_CTL2_LBR_CTL_ENABLE;
 }
 
 void svm_enable_lbrv(struct kvm_vcpu *vcpu)
@@ -809,16 +809,16 @@ void svm_enable_lbrv(struct kvm_vcpu *vcpu)
 static void __svm_disable_lbrv(struct kvm_vcpu *vcpu)
 {
 	KVM_BUG_ON(sev_es_guest(vcpu->kvm), vcpu->kvm);
-	to_svm(vcpu)->vmcb->control.virt_ext &= ~LBR_CTL_ENABLE_MASK;
+	to_svm(vcpu)->vmcb->control.misc_ctl2 &= ~SVM_MISC_CTL2_LBR_CTL_ENABLE;
 }
 
 void svm_update_lbrv(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	bool current_enable_lbrv = svm->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK;
+	bool current_enable_lbrv = svm->vmcb->control.misc_ctl2 & SVM_MISC_CTL2_LBR_CTL_ENABLE;
 	bool enable_lbrv = (svm->vmcb->save.dbgctl & DEBUGCTLMSR_LBR) ||
 			    (is_guest_mode(vcpu) && guest_cpu_cap_has(vcpu, X86_FEATURE_LBRV) &&
-			    (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK));
+			    (svm->nested.ctl.misc_ctl2 & SVM_MISC_CTL2_LBR_CTL_ENABLE));
 
 	if (enable_lbrv && !current_enable_lbrv)
 		__svm_enable_lbrv(vcpu);
@@ -979,7 +979,7 @@ static void svm_recalc_instruction_intercepts(struct kvm_vcpu *vcpu)
 	if (guest_cpuid_is_intel_compatible(vcpu)) {
 		svm_set_intercept(svm, INTERCEPT_VMLOAD);
 		svm_set_intercept(svm, INTERCEPT_VMSAVE);
-		svm->vmcb->control.virt_ext &= ~VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
+		svm->vmcb->control.misc_ctl2 &= ~SVM_MISC_CTL2_V_VMLOAD_VMSAVE_ENABLE;
 	} else {
 		/*
 		 * If hardware supports Virtual VMLOAD VMSAVE then enable it
@@ -988,7 +988,7 @@ static void svm_recalc_instruction_intercepts(struct kvm_vcpu *vcpu)
 		if (vls) {
 			svm_clr_intercept(svm, INTERCEPT_VMLOAD);
 			svm_clr_intercept(svm, INTERCEPT_VMSAVE);
-			svm->vmcb->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
+			svm->vmcb->control.misc_ctl2 |= SVM_MISC_CTL2_V_VMLOAD_VMSAVE_ENABLE;
 		}
 	}
 }
@@ -3279,7 +3279,7 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 	pr_err("%-20s%016llx\n", "ghcb:", control->ghcb_gpa);
 	pr_err("%-20s%08x\n", "event_inj:", control->event_inj);
 	pr_err("%-20s%08x\n", "event_inj_err:", control->event_inj_err);
-	pr_err("%-20s%lld\n", "virt_ext:", control->virt_ext);
+	pr_err("%-20s%lld\n", "misc_ctl2:", control->misc_ctl2);
 	pr_err("%-20s%016llx\n", "next_rip:", control->next_rip);
 	pr_err("%-20s%016llx\n", "avic_backing_page:", control->avic_backing_page);
 	pr_err("%-20s%016llx\n", "avic_logical_id:", control->avic_logical_id);
@@ -4261,7 +4261,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
 	 * VM-Exit), as running with the host's DEBUGCTL can negatively affect
 	 * guest state and can even be fatal, e.g. due to Bus Lock Detect.
 	 */
-	if (!(svm->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK) &&
+	if (!(svm->vmcb->control.misc_ctl2 & SVM_MISC_CTL2_LBR_CTL_ENABLE) &&
 	    vcpu->arch.host_debugctl != svm->vmcb->save.dbgctl)
 		update_debugctlmsr(svm->vmcb->save.dbgctl);
 
@@ -4292,7 +4292,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
 	if (unlikely(svm->vmcb->control.exit_code == SVM_EXIT_NMI))
 		kvm_before_interrupt(vcpu, KVM_HANDLING_NMI);
 
-	if (!(svm->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK) &&
+	if (!(svm->vmcb->control.misc_ctl2 & SVM_MISC_CTL2_LBR_CTL_ENABLE) &&
 	    vcpu->arch.host_debugctl != svm->vmcb->save.dbgctl)
 		update_debugctlmsr(vcpu->arch.host_debugctl);
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 861ed9c33977b..68be3a08e3e62 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -174,7 +174,7 @@ struct vmcb_ctrl_area_cached {
 	u32 event_inj_err;
 	u64 next_rip;
 	u64 nested_cr3;
-	u64 virt_ext;
+	u64 misc_ctl2;
 	u32 clean;
 	u64 bus_lock_rip;
 	union {
diff --git a/tools/testing/selftests/kvm/include/x86/svm.h b/tools/testing/selftests/kvm/include/x86/svm.h
index 5d2bcce34c019..a3f4eadffeb46 100644
--- a/tools/testing/selftests/kvm/include/x86/svm.h
+++ b/tools/testing/selftests/kvm/include/x86/svm.h
@@ -104,7 +104,7 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 	u32 event_inj;
 	u32 event_inj_err;
 	u64 nested_cr3;
-	u64 virt_ext;
+	u64 misc_ctl2;
 	u32 clean;
 	u32 reserved_5;
 	u64 next_rip;
@@ -156,9 +156,6 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define AVIC_ENABLE_SHIFT 31
 #define AVIC_ENABLE_MASK (1 << AVIC_ENABLE_SHIFT)
 
-#define LBR_CTL_ENABLE_MASK BIT_ULL(0)
-#define VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK BIT_ULL(1)
-
 #define SVM_INTERRUPT_SHADOW_MASK 1
 
 #define SVM_IOIO_STR_SHIFT 2
@@ -179,6 +176,9 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define SVM_MISC_CTL_CTL_NP_ENABLE	BIT(0)
 #define SVM_MISC_CTL_SEV_ENABLE		BIT(1)
 
+#define SVM_MISC_CTL2_LBR_CTL_ENABLE BIT_ULL(0)
+#define SVM_MISC_CTL2_V_VMLOAD_VMSAVE_ENABLE BIT_ULL(1)
+
 struct __attribute__ ((__packed__)) vmcb_seg {
 	u16 selector;
 	u16 attrib;
diff --git a/tools/testing/selftests/kvm/x86/svm_lbr_nested_state.c b/tools/testing/selftests/kvm/x86/svm_lbr_nested_state.c
index a343279546fd8..4a9e644b8931e 100644
--- a/tools/testing/selftests/kvm/x86/svm_lbr_nested_state.c
+++ b/tools/testing/selftests/kvm/x86/svm_lbr_nested_state.c
@@ -75,9 +75,9 @@ static void l1_guest_code(struct svm_test_data *svm, bool nested_lbrv)
 			  &l2_guest_stack[L2_GUEST_STACK_SIZE]);
 
 	if (nested_lbrv)
-		vmcb->control.virt_ext = LBR_CTL_ENABLE_MASK;
+		vmcb->control.misc_ctl2 = SVM_MISC_CTL2_LBR_CTL_ENABLE;
 	else
-		vmcb->control.virt_ext &= ~LBR_CTL_ENABLE_MASK;
+		vmcb->control.misc_ctl2 &= ~SVM_MISC_CTL2_LBR_CTL_ENABLE;
 
 	run_guest(vmcb, svm->vmcb_gpa);
 	GUEST_ASSERT(svm->vmcb->control.exit_code == SVM_EXIT_VMMCALL);
-- 
2.51.2.1041.gc1ab5b90ca-goog


