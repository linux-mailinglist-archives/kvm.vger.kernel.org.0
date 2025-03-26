Return-Path: <kvm+bounces-42055-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A8FF9A71F50
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 20:40:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F277417AC18
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 19:39:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0A47264F9E;
	Wed, 26 Mar 2025 19:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MYuIWsfT"
X-Original-To: kvm@vger.kernel.org
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA8A326463D
	for <kvm@vger.kernel.org>; Wed, 26 Mar 2025 19:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743017832; cv=none; b=tXUgObWZHsC87VqYPleURq49jf9Xia+GRBSakR7VzM4keJdKxbvsA/i7Lkks9V5jnQo/48f2MoAldiz3amdD40vWKjvy0UXoo/sviz38koTjaoZzmh5xmJar094xcY94OyZjtc0VmuCvQrS0nxdiD0f3t0U8n5MVBhJMOJwCqOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743017832; c=relaxed/simple;
	bh=07QhuqeNA9CJD62Y+nMX4jvn7vUJEesW/aZwULJ3kqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hd5PgPnL/4oEun1oy0l2jXkLuoKIPr4T9w3SqEN617yIjRvJtV1q6shOgyAOFXH0zjwMB+KWxf7ZIb1xYsVdJ00CO3wrwr110EbXRgzfnsm0Ai+QPhmk5SUCWj9lovVEKYITqJpq8grSwUWGcJMD+MaOVfzIdJXOMOjErQKZTms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MYuIWsfT; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743017828;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DWp8V6B+MtBpnYUkj3PF06YLrN5y+cuwzDwPbUJIa9I=;
	b=MYuIWsfT3UqRqeoMpj7hq1zw0XJKvHc/E+xJnlPwAIPKCxfKWfJdQMWqxEM2oO2H5IS2TE
	q1w/Ci3VekkhDTz1mxzU9014RxEDy/mc6mivus37e1xJxH3U/5rcHjnSNsQfYmSfEL2ItH
	3GVE0UV8DWTpg383VNJAslKTov45/S4=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Rik van Riel <riel@surriel.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	x86@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [RFC PATCH 10/24] KVM: SVM: Use a single ASID per VM
Date: Wed, 26 Mar 2025 19:36:05 +0000
Message-ID: <20250326193619.3714986-11-yosry.ahmed@linux.dev>
In-Reply-To: <20250326193619.3714986-1-yosry.ahmed@linux.dev>
References: <20250326193619.3714986-1-yosry.ahmed@linux.dev>
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

The existing check for whether the ASID in the VMCB matches the per-vCPU
ASID is turned into a WARN because it is not expected behavior anymore,
and is moved from svm_vcpu_run() to pre_svm_run() such that it's not
checked for SEV guests. The check does not apply as-is for SEV, and a
separate check is added in pre_sev_run() instead. These checks will be
consolidated (among other code) in a followup change.

As ASIDs cannot be disabled (like how VPIDs can be disabled on Intel),
handle ASID allocation failure by falling back to a single shared ASID
allocated during hardware setup. This ASID is flushed on every VMRUN if
it is in use to avoid sharing TLB entries between different guests. This
should be unlikely with modern AMD CPUs as they have over 32k ASIDs.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/nested.c |   3 +-
 arch/x86/kvm/svm/svm.c    | 129 ++++++++++++++++++++++----------------
 arch/x86/kvm/svm/svm.h    |  10 +--
 3 files changed, 80 insertions(+), 62 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 11b02a0340d9e..81184b2fb27fd 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -677,8 +677,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 	vmcb02->control.nested_ctl = vmcb01->control.nested_ctl;
 	vmcb02->control.iopm_base_pa = vmcb01->control.iopm_base_pa;
 	vmcb02->control.msrpm_base_pa = vmcb01->control.msrpm_base_pa;
-
-	/* Done at vmrun: asid.  */
+	vmcb02->control.asid = svm_asid(vcpu->kvm);
 
 	/* Also overwritten later if necessary.  */
 	vmcb_clr_flush_asid(vmcb02);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b740114a9d9bc..f028d006f69dc 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -249,6 +249,9 @@ static unsigned long iopm_base;
 
 DEFINE_PER_CPU(struct svm_cpu_data, svm_data);
 
+static struct kvm_tlb_tags svm_asids;
+static unsigned int fallback_asid;
+
 /*
  * Only MSR_TSC_AUX is switched via the user return hook.  EFER is switched via
  * the VMCB, and the SYSCALL/SYSENTER MSRs are handled by VMLOAD/VMSAVE.
@@ -621,10 +624,6 @@ static int svm_enable_virtualization_cpu(void)
 		return -EBUSY;
 
 	sd = per_cpu_ptr(&svm_data, me);
-	sd->asid_generation = 1;
-	sd->max_asid = cpuid_ebx(SVM_CPUID_FUNC) - 1;
-	sd->next_asid = sd->max_asid + 1;
-	sd->min_asid = max_sev_asid + 1;
 
 	wrmsrl(MSR_EFER, efer | EFER_SVME);
 
@@ -1119,6 +1118,7 @@ static void svm_hardware_unsetup(void)
 
 	__free_pages(__sme_pa_to_page(iopm_base), get_order(IOPM_SIZE));
 	iopm_base = 0;
+	kvm_tlb_tags_destroy(&svm_asids);
 }
 
 static void init_seg(struct vmcb_seg *seg)
@@ -1225,6 +1225,20 @@ static inline void init_vmcb_after_set_cpuid(struct kvm_vcpu *vcpu)
 	}
 }
 
+unsigned int svm_asid(struct kvm *kvm)
+{
+	return to_kvm_svm(kvm)->asid;
+}
+
+static unsigned int svm_get_current_asid(struct vcpu_svm *svm)
+{
+	struct kvm *kvm = svm->vcpu.kvm;
+
+	if (sev_guest(kvm))
+		return sev_get_asid(kvm);
+	return svm_asid(kvm);
+}
+
 static void init_vmcb(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -1300,6 +1314,8 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 	control->iopm_base_pa = iopm_base;
 	control->msrpm_base_pa = __sme_set(__pa(svm->msrpm));
 	control->int_ctl = V_INTR_MASKING_MASK;
+	control->asid = svm_asid(vcpu->kvm);
+	vmcb_set_flush_asid(svm->vmcb);
 
 	init_seg(&save->es);
 	init_seg(&save->ss);
@@ -1332,8 +1348,6 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 		save->g_pat = vcpu->arch.pat;
 		save->cr3 = 0;
 	}
-	svm->current_vmcb->asid_generation = 0;
-	svm->asid = 0;
 
 	svm->nested.vmcb12_gpa = INVALID_GPA;
 	svm->nested.last_vmcb12_gpa = INVALID_GPA;
@@ -1547,9 +1561,9 @@ static void svm_prepare_host_switch(struct kvm_vcpu *vcpu)
 
 static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
-	unsigned int asid;
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, cpu);
+	unsigned int asid = svm_get_current_asid(svm);
 	struct kvm_vcpu *prev;
 
 	if (vcpu->scheduled_out && !kvm_pause_in_guest(vcpu->kvm))
@@ -1564,17 +1578,14 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	if (kvm_vcpu_apicv_active(vcpu))
 		avic_vcpu_load(vcpu, cpu);
 
-	if (sev_guest(vcpu->kvm)) {
-		/*
-		 * Flush the TLB when a different vCPU using the same ASID is
-		 * run on the same CPU. xa_store() should always succeed because
-		 * the entry is reserved when the ASID is allocated.
-		 */
-		asid = sev_get_asid(vcpu->kvm);
-		prev = xa_store(&sd->asid_vcpu, asid, vcpu, GFP_ATOMIC);
-		if (prev != vcpu || WARN_ON_ONCE(xa_err(prev)))
-			kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
-	}
+	/*
+	 * Flush the TLB when a different vCPU using the same ASID is
+	 * run on the same CPU. xa_store() should always succeed because
+	 * the entry is reserved when the ASID is allocated.
+	 */
+	prev = xa_store(&sd->asid_vcpu, asid, vcpu, GFP_ATOMIC);
+	if (prev != vcpu || WARN_ON_ONCE(xa_err(prev)))
+		kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
 }
 
 static void svm_vcpu_put(struct kvm_vcpu *vcpu)
@@ -1989,19 +2000,6 @@ static void svm_update_exception_bitmap(struct kvm_vcpu *vcpu)
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
@@ -3629,8 +3627,16 @@ static int svm_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 
 static int pre_svm_run(struct kvm_vcpu *vcpu)
 {
-	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, vcpu->cpu);
 	struct vcpu_svm *svm = to_svm(vcpu);
+	unsigned int asid = svm_get_current_asid(svm);
+
+	/*
+	 * Reject KVM_RUN if userspace attempts to run the vCPU with an invalid
+	 * VMSA, e.g. if userspace forces the vCPU to be RUNNABLE after an SNP
+	 * AP Destroy event.
+	 */
+	if (sev_es_guest(vcpu->kvm) && !VALID_PAGE(svm->vmcb->control.vmsa_pa))
+		return -EINVAL;
 
 	/*
 	 * If the previous VMRUN of the VMCB occurred on a different physical
@@ -3643,25 +3649,20 @@ static int pre_svm_run(struct kvm_vcpu *vcpu)
 		svm->current_vmcb->cpu = vcpu->cpu;
         }
 
-	if (sev_guest(vcpu->kvm)) {
-		/* Assign the asid allocated with this SEV guest */
-		svm->asid = sev_get_asid(vcpu->kvm);
+	/*
+	 * If we run out of space and ASID allocation fails, we fallback to a
+	 * shared fallback ASID. For that ASID, we need to flush the TLB on
+	 * every VMRUN to avoid sharing TLB entries between different guests.
+	 */
+	if (unlikely(asid == fallback_asid))
+		vmcb_set_flush_asid(svm->vmcb);
 
-		/*
-		 * Reject KVM_RUN if userspace attempts to run the vCPU with an invalid
-		 * VMSA, e.g. if userspace forces the vCPU to be RUNNABLE after an SNP
-		 * AP Destroy event.
-		 */
-		if (sev_es_guest(vcpu->kvm) &&
-		    !VALID_PAGE(svm->vmcb->control.vmsa_pa))
-			return -EINVAL;
-		return 0;
+	if (WARN_ON_ONCE(svm->vmcb->control.asid != asid)) {
+		vmcb_set_flush_asid(svm->vmcb);
+		svm->vmcb->control.asid = asid;
+		vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
 	}
 
-	/* FIXME: handle wraparound of asid_generation */
-	if (svm->current_vmcb->asid_generation != sd->asid_generation)
-		new_asid(svm, sd);
-
 	return 0;
 }
 
@@ -4062,7 +4063,7 @@ static void svm_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t gva)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	invlpga(gva, svm->vmcb->control.asid);
+	invlpga(gva, svm_get_current_asid(svm));
 }
 
 static inline void sync_cr8_to_lapic(struct kvm_vcpu *vcpu)
@@ -4308,10 +4309,6 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu,
 
 	sync_lapic_to_cr8(vcpu);
 
-	if (unlikely(svm->asid != svm->vmcb->control.asid)) {
-		svm->vmcb->control.asid = svm->asid;
-		vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
-	}
 	svm->vmcb->save.cr2 = vcpu->arch.cr2;
 
 	svm_hv_update_vp_id(svm->vmcb, vcpu);
@@ -5073,13 +5070,18 @@ bool svm_register_asid(unsigned int asid)
 
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
+	unsigned int asid;
 
 	if (type != KVM_X86_DEFAULT_VM &&
 	    type != KVM_X86_SW_PROTECTED_VM) {
@@ -5100,6 +5102,13 @@ static int svm_vm_init(struct kvm *kvm)
 			return ret;
 	}
 
+	asid = kvm_tlb_tags_alloc(&svm_asids);
+	if (asid && !svm_register_asid(asid)) {
+		kvm_tlb_tags_free(&svm_asids, asid);
+		asid = 0;
+	}
+	kvm_svm->asid = asid ?: fallback_asid;
+
 	return 0;
 }
 
@@ -5381,6 +5390,7 @@ static __init int svm_hardware_setup(void)
 	void *iopm_va;
 	int r;
 	unsigned int order = get_order(IOPM_SIZE);
+	unsigned int min_asid, max_asid;
 
 	/*
 	 * NX is required for shadow paging and for NPT if the NX huge pages
@@ -5473,6 +5483,13 @@ static __init int svm_hardware_setup(void)
 	 */
 	sev_hardware_setup();
 
+	/* Consumes max_sev_asid initialized by sev_hardware_setup() */
+	min_asid = max_sev_asid + 1;
+	max_asid = cpuid_ebx(SVM_CPUID_FUNC) - 1;
+	r = kvm_tlb_tags_init(&svm_asids, min_asid, max_asid);
+	if (r)
+		goto err;
+
 	svm_hv_hardware_setup();
 
 	for_each_possible_cpu(cpu) {
@@ -5481,6 +5498,12 @@ static __init int svm_hardware_setup(void)
 			goto err;
 	}
 
+	fallback_asid = kvm_tlb_tags_alloc(&svm_asids);
+	WARN_ON_ONCE(!fallback_asid);
+
+	/* Needs to be after svm_cpu_init() initializes the per-CPU xarrays */
+	svm_register_asid(fallback_asid);
+
 	enable_apicv = avic = avic && avic_hardware_setup();
 
 	if (!enable_apicv) {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 4929b96d3d700..436b7e83141b9 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -117,6 +117,8 @@ struct kvm_sev_info {
 struct kvm_svm {
 	struct kvm kvm;
 
+	unsigned int asid;
+
 	/* Struct members for AVIC */
 	u32 avic_vm_id;
 	struct page *avic_logical_id_table_page;
@@ -132,7 +134,6 @@ struct kvm_vmcb_info {
 	struct vmcb *ptr;
 	unsigned long pa;
 	int cpu;
-	uint64_t asid_generation;
 };
 
 struct vmcb_save_area_cached {
@@ -247,7 +248,6 @@ struct vcpu_svm {
 	struct vmcb *vmcb;
 	struct kvm_vmcb_info vmcb01;
 	struct kvm_vmcb_info *current_vmcb;
-	u32 asid;
 	u32 sysenter_esp_hi;
 	u32 sysenter_eip_hi;
 	uint64_t tsc_aux;
@@ -330,11 +330,6 @@ struct vcpu_svm {
 };
 
 struct svm_cpu_data {
-	u64 asid_generation;
-	u32 max_asid;
-	u32 next_asid;
-	u32 min_asid;
-
 	struct vmcb *save_area;
 	unsigned long save_area_pa;
 
@@ -656,6 +651,7 @@ void svm_complete_interrupt_delivery(struct kvm_vcpu *vcpu, int delivery_mode,
 				     int trig_mode, int vec);
 bool svm_register_asid(unsigned int asid);
 void svm_unregister_asid(unsigned int asid);
+unsigned int svm_asid(struct kvm *kvm);
 
 /* nested.c */
 
-- 
2.49.0.395.g12beb8f557-goog


