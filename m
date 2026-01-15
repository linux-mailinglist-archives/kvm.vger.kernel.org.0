Return-Path: <kvm+bounces-68134-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DEFA1D2200E
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 02:22:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B453130A7DA9
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 01:16:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93FDA2FE56A;
	Thu, 15 Jan 2026 01:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NpEgjqGw"
X-Original-To: kvm@vger.kernel.org
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CBFF2741AC
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 01:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768439654; cv=none; b=Hi2MUhdrTZp5pYHV6UWvNY7SQXA9RadJMQ7YnIJPoKBIq57PNJD1QtQy6wbhsfIizhrqQF9VEQ3mayxxJspu/w7P0Bmlx8IiJ0DRod5ro3xYTzUj9r3mgxg0v5IguKKPye7JtfGBpH5fb4z1oW/pl8HP9fbrSIwzJ/fO6gk2xRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768439654; c=relaxed/simple;
	bh=SX8PTg3GL+3FSl26/mRXQfb4G986t8SrZiuXo4179qQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HKnF9CADByC//qFCQJ7uasQpEOQ4kCJIpalQVAXLsV2nXlPR71xzqn/wNmlChlgNX+BJ7ecpOanhq0BN8x/fJ+UmNyYqe75N6pmnWd+OoP0o19+evEP+9b+CJVJvw8G7hqvaBNBY2k6D96vC2wghWpF7cr38bb8ZchU4cLg01zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NpEgjqGw; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768439647;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eufh0w2C1eQss9bB4CCLnsr5HQFkBZLnaSZwpMvlgQg=;
	b=NpEgjqGwCl+FkUhvzDNuwXQhOuDRE6ZKJDNcd/TCXchP8B0m+BaapgF4Hpfkvl8rlkM+lO
	SfIIAINuV7SKjVQgbzLv4A9TMLezQihSue1ecs0vyu874HxdTA5iscE1RvB6Wt0mBtmuBv
	7LQxUopuTyCF3DSFKYjNi/7OqJGo2xQ=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v4 23/26] KVM: nSVM: Cache all used fields from VMCB12
Date: Thu, 15 Jan 2026 01:13:09 +0000
Message-ID: <20260115011312.3675857-24-yosry.ahmed@linux.dev>
In-Reply-To: <20260115011312.3675857-1-yosry.ahmed@linux.dev>
References: <20260115011312.3675857-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Currently, most fields used from VMCB12 are cached in
svm->nested.{ctl/save}. This is mainly to avoid TOC-TOU bugs. However,
for the save area, only the fields used in the consistency checks (i.e.
nested_vmcb_check_save()) were being cached. Other fields are read
directly from guest memory in nested_vmcb02_prepare_save().

While probably benign, this still makes it possible for TOC-TOU bugs to
happen. For example, RAX, RSP, and RIP are read twice, once to store in
VMCB02, and once to store in vcpu->arch.regs. It is possible for the
guest to modify the value between both reads, potentially causing nasty
bugs.

Harden against such bugs by caching everything in svm->nested.save.
Cache all the needed fields, and keep all accesses to the VMCB12
strictly in nested_svm_vmrun() for caching and early error injection.
Following changes will further limit the access to the VMCB12 in the
nested VMRUN path.

Introduce vmcb12_is_dirty() to use with the cached control fields
instead of vmcb_is_dirty(), similar to vmcb12_is_intercept().

Opportunistically order the copies in __nested_copy_vmcb_save_to_cache()
by the order in which the fields are defined in struct vmcb_save_area.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/nested.c | 116 ++++++++++++++++++++++----------------
 arch/x86/kvm/svm/svm.c    |   2 +-
 arch/x86/kvm/svm/svm.h    |  27 ++++++++-
 3 files changed, 93 insertions(+), 52 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 69bd926530b3..7209bbe19548 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -546,19 +546,34 @@ void nested_copy_vmcb_control_to_cache(struct vcpu_svm *svm,
 static void __nested_copy_vmcb_save_to_cache(struct vmcb_save_area_cached *to,
 					     struct vmcb_save_area *from)
 {
-	/*
-	 * Copy only fields that are validated, as we need them
-	 * to avoid TOC/TOU races.
-	 */
+	to->es = from->es;
 	to->cs = from->cs;
+	to->ss = from->ss;
+	to->ds = from->ds;
+	to->gdtr = from->gdtr;
+	to->idtr = from->idtr;
+
+	to->cpl = from->cpl;
 
 	to->efer = from->efer;
-	to->cr0 = from->cr0;
-	to->cr3 = from->cr3;
 	to->cr4 = from->cr4;
-
-	to->dr6 = from->dr6;
+	to->cr3 = from->cr3;
+	to->cr0 = from->cr0;
 	to->dr7 = from->dr7;
+	to->dr6 = from->dr6;
+
+	to->rflags = from->rflags;
+	to->rip = from->rip;
+	to->rsp = from->rsp;
+
+	to->s_cet = from->s_cet;
+	to->ssp = from->ssp;
+	to->isst_addr = from->isst_addr;
+
+	to->rax = from->rax;
+	to->cr2 = from->cr2;
+
+	svm_copy_lbrs(to, from);
 }
 
 void nested_copy_vmcb_save_to_cache(struct vcpu_svm *svm,
@@ -694,8 +709,10 @@ void nested_vmcb02_compute_g_pat(struct vcpu_svm *svm)
 	svm->nested.vmcb02.ptr->save.g_pat = svm->vmcb01.ptr->save.g_pat;
 }
 
-static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12)
+static void nested_vmcb02_prepare_save(struct vcpu_svm *svm)
 {
+	struct vmcb_ctrl_area_cached *control = &svm->nested.ctl;
+	struct vmcb_save_area_cached *save = &svm->nested.save;
 	bool new_vmcb12 = false;
 	struct vmcb *vmcb01 = svm->vmcb01.ptr;
 	struct vmcb *vmcb02 = svm->nested.vmcb02.ptr;
@@ -711,49 +728,49 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
 		svm->nested.force_msr_bitmap_recalc = true;
 	}
 
-	if (unlikely(new_vmcb12 || vmcb_is_dirty(vmcb12, VMCB_SEG))) {
-		vmcb02->save.es = vmcb12->save.es;
-		vmcb02->save.cs = vmcb12->save.cs;
-		vmcb02->save.ss = vmcb12->save.ss;
-		vmcb02->save.ds = vmcb12->save.ds;
-		vmcb02->save.cpl = vmcb12->save.cpl;
+	if (unlikely(new_vmcb12 || vmcb12_is_dirty(control, VMCB_SEG))) {
+		vmcb02->save.es = save->es;
+		vmcb02->save.cs = save->cs;
+		vmcb02->save.ss = save->ss;
+		vmcb02->save.ds = save->ds;
+		vmcb02->save.cpl = save->cpl;
 		vmcb_mark_dirty(vmcb02, VMCB_SEG);
 	}
 
-	if (unlikely(new_vmcb12 || vmcb_is_dirty(vmcb12, VMCB_DT))) {
-		vmcb02->save.gdtr = vmcb12->save.gdtr;
-		vmcb02->save.idtr = vmcb12->save.idtr;
+	if (unlikely(new_vmcb12 || vmcb12_is_dirty(control, VMCB_DT))) {
+		vmcb02->save.gdtr = save->gdtr;
+		vmcb02->save.idtr = save->idtr;
 		vmcb_mark_dirty(vmcb02, VMCB_DT);
 	}
 
 	if (guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK) &&
-	    (unlikely(new_vmcb12 || vmcb_is_dirty(vmcb12, VMCB_CET)))) {
-		vmcb02->save.s_cet  = vmcb12->save.s_cet;
-		vmcb02->save.isst_addr = vmcb12->save.isst_addr;
-		vmcb02->save.ssp = vmcb12->save.ssp;
+	    (unlikely(new_vmcb12 || vmcb12_is_dirty(control, VMCB_CET)))) {
+		vmcb02->save.s_cet  = save->s_cet;
+		vmcb02->save.isst_addr = save->isst_addr;
+		vmcb02->save.ssp = save->ssp;
 		vmcb_mark_dirty(vmcb02, VMCB_CET);
 	}
 
-	kvm_set_rflags(vcpu, vmcb12->save.rflags | X86_EFLAGS_FIXED);
+	kvm_set_rflags(vcpu, save->rflags | X86_EFLAGS_FIXED);
 
 	svm_set_efer(vcpu, svm->nested.save.efer);
 
 	svm_set_cr0(vcpu, svm->nested.save.cr0);
 	svm_set_cr4(vcpu, svm->nested.save.cr4);
 
-	svm->vcpu.arch.cr2 = vmcb12->save.cr2;
+	svm->vcpu.arch.cr2 = save->cr2;
 
-	kvm_rax_write(vcpu, vmcb12->save.rax);
-	kvm_rsp_write(vcpu, vmcb12->save.rsp);
-	kvm_rip_write(vcpu, vmcb12->save.rip);
+	kvm_rax_write(vcpu, save->rax);
+	kvm_rsp_write(vcpu, save->rsp);
+	kvm_rip_write(vcpu, save->rip);
 
 	/* In case we don't even reach vcpu_run, the fields are not updated */
-	vmcb02->save.rax = vmcb12->save.rax;
-	vmcb02->save.rsp = vmcb12->save.rsp;
-	vmcb02->save.rip = vmcb12->save.rip;
+	vmcb02->save.rax = save->rax;
+	vmcb02->save.rsp = save->rsp;
+	vmcb02->save.rip = save->rip;
 
 	/* These bits will be set properly on the first execution when new_vmc12 is true */
-	if (unlikely(new_vmcb12 || vmcb_is_dirty(vmcb12, VMCB_DR))) {
+	if (unlikely(new_vmcb12 || vmcb12_is_dirty(control, VMCB_DR))) {
 		vmcb02->save.dr7 = svm->nested.save.dr7 | DR7_FIXED_1;
 		svm->vcpu.arch.dr6  = svm->nested.save.dr6 | DR6_ACTIVE_LOW;
 		vmcb_mark_dirty(vmcb02, VMCB_DR);
@@ -765,7 +782,7 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
 		 * Reserved bits of DEBUGCTL are ignored.  Be consistent with
 		 * svm_set_msr's definition of reserved bits.
 		 */
-		svm_copy_lbrs(&vmcb02->save, &vmcb12->save);
+		svm_copy_lbrs(&vmcb02->save, save);
 		vmcb_mark_dirty(vmcb02, VMCB_LBR);
 		vmcb02->save.dbgctl &= ~DEBUGCTL_RESERVED_BITS;
 	} else {
@@ -982,28 +999,29 @@ static void nested_svm_copy_common_state(struct vmcb *from_vmcb, struct vmcb *to
 	to_vmcb->save.spec_ctrl = from_vmcb->save.spec_ctrl;
 }
 
-int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
-			 struct vmcb *vmcb12, bool from_vmrun)
+int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa, bool from_vmrun)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
+	struct vmcb_ctrl_area_cached *control = &svm->nested.ctl;
+	struct vmcb_save_area_cached *save = &svm->nested.save;
 	int ret;
 
 	trace_kvm_nested_vmenter(svm->vmcb->save.rip,
 				 vmcb12_gpa,
-				 vmcb12->save.rip,
-				 vmcb12->control.int_ctl,
-				 vmcb12->control.event_inj,
-				 vmcb12->control.misc_ctl,
-				 vmcb12->control.nested_cr3,
-				 vmcb12->save.cr3,
+				 save->rip,
+				 control->int_ctl,
+				 control->event_inj,
+				 control->misc_ctl,
+				 control->nested_cr3,
+				 save->cr3,
 				 KVM_ISA_SVM);
 
-	trace_kvm_nested_intercepts(vmcb12->control.intercepts[INTERCEPT_CR] & 0xffff,
-				    vmcb12->control.intercepts[INTERCEPT_CR] >> 16,
-				    vmcb12->control.intercepts[INTERCEPT_EXCEPTION],
-				    vmcb12->control.intercepts[INTERCEPT_WORD3],
-				    vmcb12->control.intercepts[INTERCEPT_WORD4],
-				    vmcb12->control.intercepts[INTERCEPT_WORD5]);
+	trace_kvm_nested_intercepts(control->intercepts[INTERCEPT_CR] & 0xffff,
+				    control->intercepts[INTERCEPT_CR] >> 16,
+				    control->intercepts[INTERCEPT_EXCEPTION],
+				    control->intercepts[INTERCEPT_WORD3],
+				    control->intercepts[INTERCEPT_WORD4],
+				    control->intercepts[INTERCEPT_WORD5]);
 
 	svm->nested.vmcb12_gpa = vmcb12_gpa;
 
@@ -1038,8 +1056,8 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
 	nested_svm_copy_common_state(svm->vmcb01.ptr, svm->nested.vmcb02.ptr);
 
 	svm_switch_vmcb(svm, &svm->nested.vmcb02);
-	nested_vmcb02_prepare_control(svm, vmcb12->save.rip, vmcb12->save.cs.base);
-	nested_vmcb02_prepare_save(svm, vmcb12);
+	nested_vmcb02_prepare_control(svm, save->rip, save->cs.base);
+	nested_vmcb02_prepare_save(svm);
 
 	if (!from_vmrun)
 		kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
@@ -1158,7 +1176,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 
 	svm->nested.nested_run_pending = 1;
 
-	if (enter_svm_guest_mode(vcpu, vmcb12_gpa, vmcb12, true)) {
+	if (enter_svm_guest_mode(vcpu, vmcb12_gpa, true)) {
 		svm->nested.nested_run_pending = 0;
 		svm->nmi_l1_to_l2 = false;
 		svm->soft_int_injected = false;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d6a850c35225..25cca79abce6 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4867,7 +4867,7 @@ static int svm_leave_smm(struct kvm_vcpu *vcpu, const union kvm_smram *smram)
 	vmcb12 = map.hva;
 	nested_copy_vmcb_control_to_cache(svm, &vmcb12->control);
 	nested_copy_vmcb_save_to_cache(svm, &vmcb12->save);
-	ret = enter_svm_guest_mode(vcpu, smram64->svm_guest_vmcb_gpa, vmcb12, false);
+	ret = enter_svm_guest_mode(vcpu, smram64->svm_guest_vmcb_gpa, false);
 
 	if (ret)
 		goto unmap_save;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 7609a2e6df88..2fc25803d0c7 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -139,13 +139,32 @@ struct kvm_vmcb_info {
 };
 
 struct vmcb_save_area_cached {
+	struct vmcb_seg es;
 	struct vmcb_seg cs;
+	struct vmcb_seg ss;
+	struct vmcb_seg ds;
+	struct vmcb_seg gdtr;
+	struct vmcb_seg idtr;
+	u8 cpl;
 	u64 efer;
 	u64 cr4;
 	u64 cr3;
 	u64 cr0;
 	u64 dr7;
 	u64 dr6;
+	u64 rflags;
+	u64 rip;
+	u64 rsp;
+	u64 s_cet;
+	u64 ssp;
+	u64 isst_addr;
+	u64 rax;
+	u64 cr2;
+	u64 dbgctl;
+	u64 br_from;
+	u64 br_to;
+	u64 last_excp_from;
+	u64 last_excp_to;
 };
 
 struct vmcb_ctrl_area_cached {
@@ -421,6 +440,11 @@ static inline bool vmcb_is_dirty(struct vmcb *vmcb, int bit)
         return !test_bit(bit, (unsigned long *)&vmcb->control.clean);
 }
 
+static inline bool vmcb12_is_dirty(struct vmcb_ctrl_area_cached *control, int bit)
+{
+	return !test_bit(bit, (unsigned long *)&control->clean);
+}
+
 static __always_inline struct vcpu_svm *to_svm(struct kvm_vcpu *vcpu)
 {
 	return container_of(vcpu, struct vcpu_svm, vcpu);
@@ -777,8 +801,7 @@ static inline bool nested_exit_on_nmi(struct vcpu_svm *svm)
 
 int __init nested_svm_init_msrpm_merge_offsets(void);
 
-int enter_svm_guest_mode(struct kvm_vcpu *vcpu,
-			 u64 vmcb_gpa, struct vmcb *vmcb12, bool from_vmrun);
+int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb_gpa, bool from_vmrun);
 void svm_leave_nested(struct kvm_vcpu *vcpu);
 void svm_free_nested(struct vcpu_svm *svm);
 int svm_allocate_nested(struct vcpu_svm *svm);
-- 
2.52.0.457.g6b5491de43-goog


