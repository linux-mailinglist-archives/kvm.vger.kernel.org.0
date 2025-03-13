Return-Path: <kvm+bounces-41012-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 68E97A603C5
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 22:57:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 320AE19C32FB
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 21:57:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A93E01FBC85;
	Thu, 13 Mar 2025 21:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="N/iYxiqQ"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E151FA165
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 21:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741902969; cv=none; b=d2j2L+qLqeHFDj+BntX4T//8z9RdtEFiOSY4LmXhSkSBpb+HhSbb/1SFMCYuhL0V3bOpQk7qRVwdC5QyR+RhN3Kaz8eqeUA75s34EBck4MrSujR4PPpXdeovPjNHEUMKgMcC85oVEeb6fuUiMTlupW9W/pDq1j0BmNz6oq31Xy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741902969; c=relaxed/simple;
	bh=KZF6AG6C1NKjQm0Gj4rRLGWi5sL6P3Jw6TBX+kZmt9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tIWmsV6KKm3G7oEO7mFMf1yI4CRtiHZtTg8FAFTHpGfNHtTvhB2i1ONy10f+TeZKi//ytXntbiFZld2txgxyFi34yJt5zFjdnma00kQFefjijMDKk7ob3AdoSwLCyuXhoZKj7IyPMqRZpIPas/GH8dyBGo3xmgrRuu13yhyDtcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=N/iYxiqQ; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741902964;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SA+kqYv+of311iNb51ZDSMltMHcQFYpEsM71pONh+2A=;
	b=N/iYxiqQCVTsYE2qWVkMvlqeBDTErmMT/ZAZJvrRH1ioaHgxDxlmsc1wm4ynYAlr+JUEHF
	HFuZ/VbVFxZ27nnZoDdPdpj3NVRzPui4AJG97LNlv8epoDHClW+8w6R4ilB/KjKlGEprcX
	aXwUGmOBeQcZLDkePQzaWIfbmWWlWxg=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	x86@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH 6/7] KVM: SVM: Use a single ASID per VM
Date: Thu, 13 Mar 2025 21:55:39 +0000
Message-ID: <20250313215540.4171762-7-yosry.ahmed@linux.dev>
In-Reply-To: <20250313215540.4171762-1-yosry.ahmed@linux.dev>
References: <20250313215540.4171762-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The ASID generation and dynamic ASID allocation logic is now only used
by initialization the generation to 0 to trigger a new ASID allocation
per-vCPU on the first VMRUN, so the ASID is more-or-less static
per-vCPU.

Moreover, having a unique ASID per-vCPU is not required. ASIDs are local
to each physical CPU, and the ASID is flushed when a vCPU is migrated to
a new physical CPU anyway. SEV VMs have been using a single ASID per VM
already for other reasons.

Use a static ASID per VM and drop the dynamic ASID allocation logic. The
ASID is allocated during vCPU reset (SEV allocates its own ASID), and
the ASID is always flushed on first use in case it was used by another
VM previously.

On VMRUN, WARN if the ASID in the VMCB does not match the VM's ASID, and
update it accordingly. Also, flush the ASID on every VMRUN if the VM
failed to allocate a unique ASID. This would probably wreck performance
if it happens, but it should be an edge case as most AMD CPUs have over
32k ASIDs.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/nested.c |  2 ++
 arch/x86/kvm/svm/sev.c    |  7 +++--
 arch/x86/kvm/svm/svm.c    | 60 +++++++++++++++++++++------------------
 arch/x86/kvm/svm/svm.h    |  8 +-----
 4 files changed, 40 insertions(+), 37 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 3bff948bc5752..d6a07644c8734 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -643,6 +643,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 	struct vmcb *vmcb01 = svm->vmcb01.ptr;
 	struct vmcb *vmcb02 = svm->nested.vmcb02.ptr;
+	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
 	u32 pause_count12;
 	u32 pause_thresh12;
 
@@ -677,6 +678,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 	vmcb02->control.nested_ctl = vmcb01->control.nested_ctl;
 	vmcb02->control.iopm_base_pa = vmcb01->control.iopm_base_pa;
 	vmcb02->control.msrpm_base_pa = vmcb01->control.msrpm_base_pa;
+	vmcb02->control.asid = kvm_svm->asid;
 
 	/* Done at vmrun: asid.  */
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index b393674733969..1ee04d6b9356b 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3465,8 +3465,10 @@ int pre_sev_run(struct vcpu_svm *svm, int cpu)
 	if (sev_es_guest(kvm) && !VALID_PAGE(svm->vmcb->control.vmsa_pa))
 		return -EINVAL;
 
-	/* Assign the asid allocated with this SEV guest */
-	svm->asid = asid;
+	if (WARN_ON_ONCE(svm->vmcb->control.asid != asid)) {
+		svm->vmcb->control.asid = asid;
+		vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
+	}
 
 	/*
 	 * Flush guest TLB:
@@ -4509,6 +4511,7 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
 void sev_init_vmcb(struct vcpu_svm *svm)
 {
 	svm->vmcb->control.nested_ctl |= SVM_NESTED_CTL_SEV_ENABLE;
+	svm->vmcb->control.asid = sev_get_asid(svm->vcpu.kvm);
 	clr_exception_intercept(svm, UD_VECTOR);
 
 	/*
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b8a3fc81fc9c8..c5e2733fb856d 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -249,6 +249,8 @@ static unsigned long iopm_base;
 
 DEFINE_PER_CPU(struct svm_cpu_data, svm_data);
 
+static struct kvm_tlb_tags svm_asids;
+
 /*
  * Only MSR_TSC_AUX is switched via the user return hook.  EFER is switched via
  * the VMCB, and the SYSCALL/SYSENTER MSRs are handled by VMLOAD/VMSAVE.
@@ -621,10 +623,6 @@ static int svm_enable_virtualization_cpu(void)
 		return -EBUSY;
 
 	sd = per_cpu_ptr(&svm_data, me);
-	sd->asid_generation = 1;
-	sd->max_asid = cpuid_ebx(SVM_CPUID_FUNC) - 1;
-	sd->next_asid = sd->max_asid + 1;
-	sd->min_asid = max_sev_asid + 1;
 
 	wrmsrl(MSR_EFER, efer | EFER_SVME);
 
@@ -1126,6 +1124,7 @@ static void svm_hardware_unsetup(void)
 
 	__free_pages(__sme_pa_to_page(iopm_base), get_order(IOPM_SIZE));
 	iopm_base = 0;
+	kvm_tlb_tags_destroy(&svm_asids);
 }
 
 static void init_seg(struct vmcb_seg *seg)
@@ -1234,6 +1233,7 @@ static inline void init_vmcb_after_set_cpuid(struct kvm_vcpu *vcpu)
 
 static void init_vmcb(struct kvm_vcpu *vcpu)
 {
+	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct vmcb *vmcb = svm->vmcb01.ptr;
 	struct vmcb_control_area *control = &vmcb->control;
@@ -1339,8 +1339,6 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 		save->g_pat = vcpu->arch.pat;
 		save->cr3 = 0;
 	}
-	svm->current_vmcb->asid_generation = 0;
-	svm->asid = 0;
 
 	svm->nested.vmcb12_gpa = INVALID_GPA;
 	svm->nested.last_vmcb12_gpa = INVALID_GPA;
@@ -1375,8 +1373,14 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 		control->int_ctl |= V_GIF_ENABLE_MASK;
 	}
 
-	if (sev_guest(vcpu->kvm))
+	/* sev_init_vmcb() will assign its own ASID */
+	if (sev_guest(vcpu->kvm)) {
 		sev_init_vmcb(svm);
+		WARN_ON_ONCE(!control->asid);
+	} else {
+		control->asid = kvm_svm->asid;
+		svm_vmcb_set_flush_asid(svm->vmcb);
+	}
 
 	svm_hv_init_vmcb(vmcb);
 	init_vmcb_after_set_cpuid(vcpu);
@@ -1982,19 +1986,6 @@ static void svm_update_exception_bitmap(struct kvm_vcpu *vcpu)
 	}
 }
 
-static void new_asid(struct vcpu_svm *svm, struct svm_cpu_data *sd)
-{
-	if (sd->next_asid > sd->max_asid) {
-		++sd->asid_generation;
-		sd->next_asid = sd->min_asid;
-		svm->vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ALL_ASID;
-		vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
-	}
-
-	svm->current_vmcb->asid_generation = sd->asid_generation;
-	svm->asid = sd->next_asid++;
-}
-
 static void svm_set_dr6(struct kvm_vcpu *vcpu, unsigned long value)
 {
 	struct vmcb *vmcb = to_svm(vcpu)->vmcb;
@@ -3622,7 +3613,7 @@ static int svm_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 
 static int pre_svm_run(struct kvm_vcpu *vcpu)
 {
-	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, vcpu->cpu);
+	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	/*
@@ -3639,9 +3630,15 @@ static int pre_svm_run(struct kvm_vcpu *vcpu)
 	if (sev_guest(vcpu->kvm))
 		return pre_sev_run(svm, vcpu->cpu);
 
-	/* FIXME: handle wraparound of asid_generation */
-	if (svm->current_vmcb->asid_generation != sd->asid_generation)
-		new_asid(svm, sd);
+	/* Flush the ASID on every VMRUN if kvm_svm->asid allocation failed */
+	if (unlikely(!kvm_svm->asid))
+		svm_vmcb_set_flush_asid(svm->vmcb);
+
+	if (WARN_ON_ONCE(svm->vmcb->control.asid != kvm_svm->asid)) {
+		svm_vmcb_set_flush_asid(svm->vmcb);
+		svm->vmcb->control.asid = kvm_svm->asid;
+		vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
+	}
 
 	return 0;
 }
@@ -4289,10 +4286,6 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu,
 
 	sync_lapic_to_cr8(vcpu);
 
-	if (unlikely(svm->asid != svm->vmcb->control.asid)) {
-		svm->vmcb->control.asid = svm->asid;
-		vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
-	}
 	svm->vmcb->save.cr2 = vcpu->arch.cr2;
 
 	svm_hv_update_vp_id(svm->vmcb, vcpu);
@@ -5024,12 +5017,16 @@ static void svm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 
 static void svm_vm_destroy(struct kvm *kvm)
 {
+	struct kvm_svm *kvm_svm = to_kvm_svm(kvm);
+
 	avic_vm_destroy(kvm);
 	sev_vm_destroy(kvm);
+	kvm_tlb_tags_free(&svm_asids, kvm_svm->asid);
 }
 
 static int svm_vm_init(struct kvm *kvm)
 {
+	struct kvm_svm *kvm_svm = to_kvm_svm(kvm);
 	int type = kvm->arch.vm_type;
 
 	if (type != KVM_X86_DEFAULT_VM &&
@@ -5051,6 +5048,7 @@ static int svm_vm_init(struct kvm *kvm)
 			return ret;
 	}
 
+	kvm_svm->asid = kvm_tlb_tags_alloc(&svm_asids);
 	return 0;
 }
 
@@ -5332,6 +5330,7 @@ static __init int svm_hardware_setup(void)
 	void *iopm_va;
 	int r;
 	unsigned int order = get_order(IOPM_SIZE);
+	unsigned int min_asid, max_asid;
 
 	/*
 	 * NX is required for shadow paging and for NPT if the NX huge pages
@@ -5424,6 +5423,11 @@ static __init int svm_hardware_setup(void)
 	 */
 	sev_hardware_setup();
 
+	/* Consumes max_sev_asid initialized by sev_hardware_setup() */
+	min_asid = max_sev_asid + 1;
+	max_asid = cpuid_ebx(SVM_CPUID_FUNC) - 1;
+	kvm_tlb_tags_init(&svm_asids, min_asid, max_asid);
+
 	svm_hv_hardware_setup();
 
 	for_each_possible_cpu(cpu) {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 0f6426809e1b9..4c6664ba4048d 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -119,6 +119,7 @@ struct kvm_svm {
 
 	/* Struct members for AVIC */
 	u32 avic_vm_id;
+	unsigned int asid;
 	struct page *avic_logical_id_table_page;
 	struct page *avic_physical_id_table_page;
 	struct hlist_node hnode;
@@ -132,7 +133,6 @@ struct kvm_vmcb_info {
 	struct vmcb *ptr;
 	unsigned long pa;
 	int cpu;
-	uint64_t asid_generation;
 };
 
 struct vmcb_save_area_cached {
@@ -247,7 +247,6 @@ struct vcpu_svm {
 	struct vmcb *vmcb;
 	struct kvm_vmcb_info vmcb01;
 	struct kvm_vmcb_info *current_vmcb;
-	u32 asid;
 	u32 sysenter_esp_hi;
 	u32 sysenter_eip_hi;
 	uint64_t tsc_aux;
@@ -330,11 +329,6 @@ struct vcpu_svm {
 };
 
 struct svm_cpu_data {
-	u64 asid_generation;
-	u32 max_asid;
-	u32 next_asid;
-	u32 min_asid;
-
 	struct vmcb *save_area;
 	unsigned long save_area_pa;
 
-- 
2.49.0.rc1.451.g8f38331e32-goog


