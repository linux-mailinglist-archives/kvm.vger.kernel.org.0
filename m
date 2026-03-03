Return-Path: <kvm+bounces-72475-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MLVYNR8upmkrLwAAu9opvQ
	(envelope-from <kvm+bounces-72475-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 01:41:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CF5761E7406
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 01:41:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 0A48F3042DE2
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 00:36:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA7612367D3;
	Tue,  3 Mar 2026 00:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="awMYoRgp"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B52366570;
	Tue,  3 Mar 2026 00:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772498079; cv=none; b=G37UgX1MfmARWwhCzRYm817U9wxdcUR9HgS5g03jsvUi1GRjl3kWhPymWhfr/zcV9+rI9sLQl4eZYHFKNF2JgPwlOqDttqJJI8IAxVw/ES0AZ9kU04Wjf2G6d3nEbM+9g+zWinDxKfU9q1e2/mqxgQo5gZWtVWJs2YCYGeNZyK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772498079; c=relaxed/simple;
	bh=iVkzc2Qb7bTJIvKcSCArEB8mpEt69UegMebDNgIwCYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bBEVKacY4ycHuJSYdnyPmtuw32Ym3OtBjhuYzfu2Ij2YCs6OPwaoWYKKWvsk4HeW1ehDHjbbqaeyuJHkRM34qXCbGi6IRqZ+2X1mTEy2wBP/LYSuUMHus2kamlK4bMoz52hVnu2fO3DQ+m0UzLrG8Z4IOx5Z8oPX3sXy3M6VJTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=awMYoRgp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7674EC2BC86;
	Tue,  3 Mar 2026 00:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772498079;
	bh=iVkzc2Qb7bTJIvKcSCArEB8mpEt69UegMebDNgIwCYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=awMYoRgpDF3eEds0iqiGlCTaw6WYmpAU6tAPKUgSUs0TkrjDFzpwo2nnMIdXIGJsu
	 nTdgR2cnCKmq7I7z9SyZWMVHsU4H4H4/IFq3PXMlZPdFeFWjpgcAYKe/IuUKVMAok3
	 fEy6MSDZ3W0Jbn7juz0nOX6vzgtM95UIwd4Iq4vuzW0JdQNqZQqOPn8VqDYCwIJB8b
	 gHIzOUhBM+0wcR3vcZB8TsfAzGhfJjTZWkbO6z28BAZwQUldUGObobEXIEdhviXp6p
	 6s8uU/4Ilyt+F2uME2oO2K5qryXF/SJDAB+LDIZA3gwbWJBjgEzR78Y0xtFsryi1Fq
	 8FhhW1Ht5n1bQ==
From: Yosry Ahmed <yosry@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry@kernel.org>
Subject: [PATCH v7 20/26] KVM: nSVM: Cache all used fields from VMCB12
Date: Tue,  3 Mar 2026 00:34:14 +0000
Message-ID: <20260303003421.2185681-21-yosry@kernel.org>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
In-Reply-To: <20260303003421.2185681-1-yosry@kernel.org>
References: <20260303003421.2185681-1-yosry@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CF5761E7406
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72475-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Action: no action

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

Signed-off-by: Yosry Ahmed <yosry@kernel.org>
---
 arch/x86/kvm/svm/nested.c | 118 ++++++++++++++++++++++----------------
 arch/x86/kvm/svm/svm.c    |   2 +-
 arch/x86/kvm/svm/svm.h    |  27 ++++++++-
 3 files changed, 94 insertions(+), 53 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 5994e309831d0..f89040a467d4a 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -518,11 +518,11 @@ void __nested_copy_vmcb_control_to_cache(struct kvm_vcpu *vcpu,
 	to->asid           = from->asid;
 	to->msrpm_base_pa &= ~0x0fffULL;
 	to->iopm_base_pa  &= ~0x0fffULL;
+	to->clean = from->clean;
 
 #ifdef CONFIG_KVM_HYPERV
 	/* Hyper-V extensions (Enlightened VMCB) */
 	if (kvm_hv_hypercall_enabled(vcpu)) {
-		to->clean = from->clean;
 		memcpy(&to->hv_enlightenments, &from->hv_enlightenments,
 		       sizeof(to->hv_enlightenments));
 	}
@@ -538,19 +538,34 @@ void nested_copy_vmcb_control_to_cache(struct vcpu_svm *svm,
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
@@ -692,8 +707,10 @@ static bool nested_vmcb12_has_lbrv(struct kvm_vcpu *vcpu)
 		(to_svm(vcpu)->nested.ctl.misc_ctl2 & SVM_MISC2_ENABLE_V_LBR);
 }
 
-static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12)
+static void nested_vmcb02_prepare_save(struct vcpu_svm *svm)
 {
+	struct vmcb_ctrl_area_cached *control = &svm->nested.ctl;
+	struct vmcb_save_area_cached *save = &svm->nested.save;
 	bool new_vmcb12 = false;
 	struct vmcb *vmcb01 = svm->vmcb01.ptr;
 	struct vmcb *vmcb02 = svm->nested.vmcb02.ptr;
@@ -709,48 +726,48 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
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
 
-	if (unlikely(new_vmcb12 || vmcb_is_dirty(vmcb12, VMCB_DR))) {
+	if (unlikely(new_vmcb12 || vmcb12_is_dirty(control, VMCB_DR))) {
 		vmcb02->save.dr7 = svm->nested.save.dr7 | DR7_FIXED_1;
 		svm->vcpu.arch.dr6  = svm->nested.save.dr6 | DR6_ACTIVE_LOW;
 		vmcb_mark_dirty(vmcb02, VMCB_DR);
@@ -761,7 +778,7 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
 		 * Reserved bits of DEBUGCTL are ignored.  Be consistent with
 		 * svm_set_msr's definition of reserved bits.
 		 */
-		svm_copy_lbrs(&vmcb02->save, &vmcb12->save);
+		svm_copy_lbrs(&vmcb02->save, save);
 		vmcb02->save.dbgctl &= ~DEBUGCTL_RESERVED_BITS;
 	} else {
 		svm_copy_lbrs(&vmcb02->save, &vmcb01->save);
@@ -984,28 +1001,29 @@ static void nested_svm_copy_common_state(struct vmcb *from_vmcb, struct vmcb *to
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
@@ -1015,8 +1033,8 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
 	nested_svm_copy_common_state(svm->vmcb01.ptr, svm->nested.vmcb02.ptr);
 
 	svm_switch_vmcb(svm, &svm->nested.vmcb02);
-	nested_vmcb02_prepare_control(svm, vmcb12->save.rip, vmcb12->save.cs.base);
-	nested_vmcb02_prepare_save(svm, vmcb12);
+	nested_vmcb02_prepare_control(svm, save->rip, save->cs.base);
+	nested_vmcb02_prepare_save(svm);
 
 	ret = nested_svm_load_cr3(&svm->vcpu, svm->nested.save.cr3,
 				  nested_npt_enabled(svm), from_vmrun);
@@ -1104,7 +1122,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 
 	svm->nested.nested_run_pending = 1;
 
-	if (enter_svm_guest_mode(vcpu, vmcb12_gpa, vmcb12, true))
+	if (enter_svm_guest_mode(vcpu, vmcb12_gpa, true))
 		goto out_exit_err;
 
 	if (nested_svm_merge_msrpm(vcpu))
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 94e14badddfa2..19112ec48c0f7 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4885,7 +4885,7 @@ static int svm_leave_smm(struct kvm_vcpu *vcpu, const union kvm_smram *smram)
 	vmcb12 = map.hva;
 	nested_copy_vmcb_control_to_cache(svm, &vmcb12->control);
 	nested_copy_vmcb_save_to_cache(svm, &vmcb12->save);
-	ret = enter_svm_guest_mode(vcpu, smram64->svm_guest_vmcb_gpa, vmcb12, false);
+	ret = enter_svm_guest_mode(vcpu, smram64->svm_guest_vmcb_gpa, false);
 
 	if (ret)
 		goto unmap_save;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 304328c33e960..388aaa5d63d29 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -140,13 +140,32 @@ struct kvm_vmcb_info {
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
@@ -785,8 +809,7 @@ static inline bool nested_exit_on_nmi(struct vcpu_svm *svm)
 
 int __init nested_svm_init_msrpm_merge_offsets(void);
 
-int enter_svm_guest_mode(struct kvm_vcpu *vcpu,
-			 u64 vmcb_gpa, struct vmcb *vmcb12, bool from_vmrun);
+int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb_gpa, bool from_vmrun);
 void svm_leave_nested(struct kvm_vcpu *vcpu);
 void svm_free_nested(struct vcpu_svm *svm);
 int svm_allocate_nested(struct vcpu_svm *svm);
-- 
2.53.0.473.g4a7958ca14-goog


