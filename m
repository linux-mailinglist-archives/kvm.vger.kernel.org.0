Return-Path: <kvm+bounces-27012-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3936797A739
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 20:19:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A9F4B1F27C0B
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 18:19:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1002E165EFA;
	Mon, 16 Sep 2024 18:18:17 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB0315CD7A;
	Mon, 16 Sep 2024 18:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726510696; cv=none; b=X7QO/jEVHjfBcuCJain82Z4meQnDVFSYbYo+nefx288b8HQyeeL+rT1R5/23uZe6L8bUfrs34KgDbeXpt8VvF2N/rcPdck87oRT6ccSqp7SR6YM7/2WXn18yCNEXO9uxzh3oRcXoovUXVEepoBLoItmUD3aKPcgES/yyIbPQtlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726510696; c=relaxed/simple;
	bh=NXZtOR7R/mzaQTpWNwKoHUmF20fvOZtMqvuyxa1N1HU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K7zY0vLIAaCOobuOK9IhNMDAQS1VBqyTld6PfUUe5j5pTI57QBHtoEp6Q+u6Ag9/q6LzV8JNCYMNx5C0zvt9aUNVCNpW+fxjPvKlP4ACkp+ONzm2MylFecl9gupkLVQcB+KskmSrXZ21InUcbT5S8e/T729Lr7eIp76v9y9Cv1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 92B571F8C4;
	Mon, 16 Sep 2024 18:18:09 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F36E413A3A;
	Mon, 16 Sep 2024 18:18:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eKFrOWB26GbveAAAD6G6ig
	(envelope-from <roy.hopkins@suse.com>); Mon, 16 Sep 2024 18:18:08 +0000
From: Roy Hopkins <roy.hopkins@suse.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	linux-coco@lists.linux.dev
Cc: Roy Hopkins <roy.hopkins@suse.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Michael Roth <michael.roth@amd.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Joerg Roedel <jroedel@suse.de>,
	Tom Lendacky <thomas.lendacky@amd.com>
Subject: [RFC PATCH 3/5] kvm/sev: Update SEV VMPL handling to use multiple struct kvm_vcpus
Date: Mon, 16 Sep 2024 19:17:55 +0100
Message-ID: <918c29e916eff38e46090b01714e3d1d5df5cb32.1726506534.git.roy.hopkins@suse.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1726506534.git.roy.hopkins@suse.com>
References: <cover.1726506534.git.roy.hopkins@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Rspamd-Queue-Id: 92B571F8C4
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 

This commit builds on Tom Lendacky's SEV-SNP support RFC patch series
and reworks the handling of VMPL switching to use multiple struct
kvm_vcpus to store VMPL context.

Signed-off-by: Roy Hopkins <roy.hopkins@suse.com>
---
 arch/x86/kvm/svm/sev.c | 159 +++++++++++++++--------------------------
 arch/x86/kvm/svm/svm.c |  66 ++++++++++-------
 arch/x86/kvm/svm/svm.h |  36 +++-------
 3 files changed, 109 insertions(+), 152 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 2ad1b9b497e0..3fbb1ce5195d 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -147,7 +147,7 @@ static bool sev_vcpu_has_debug_swap(struct vcpu_svm *svm)
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 	struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
 
-	return sev->vmsa_features[cur_vmpl(svm)] & SVM_SEV_FEAT_DEBUG_SWAP;
+	return sev->vmsa_features[vcpu->vmpl] & SVM_SEV_FEAT_DEBUG_SWAP;
 }
 
 /* Must be called with the sev_bitmap_lock held */
@@ -818,7 +818,7 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 {
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 	struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
-	struct sev_es_save_area *save = vmpl_vmsa(svm, SVM_SEV_VMPL0);
+	struct sev_es_save_area *save = vmpl_vmsa(svm);
 	struct xregs_state *xsave;
 	const u8 *s;
 	u8 *d;
@@ -931,11 +931,11 @@ static int __sev_launch_update_vmsa(struct kvm *kvm, struct kvm_vcpu *vcpu,
 	 * the VMSA memory content (i.e it will write the same memory region
 	 * with the guest's key), so invalidate it first.
 	 */
-	clflush_cache_range(vmpl_vmsa(svm, SVM_SEV_VMPL0), PAGE_SIZE);
+	clflush_cache_range(vmpl_vmsa(svm), PAGE_SIZE);
 
 	vmsa.reserved = 0;
 	vmsa.handle = to_kvm_sev_info(kvm)->handle;
-	vmsa.address = __sme_pa(vmpl_vmsa(svm, SVM_SEV_VMPL0));
+	vmsa.address = __sme_pa(vmpl_vmsa(svm));
 	vmsa.len = PAGE_SIZE;
 	ret = sev_issue_cmd(kvm, SEV_CMD_LAUNCH_UPDATE_VMSA, &vmsa, error);
 	if (ret)
@@ -2504,7 +2504,7 @@ static int snp_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		struct vcpu_svm *svm = to_svm(vcpu);
-		u64 pfn = __pa(vmpl_vmsa(svm, SVM_SEV_VMPL0)) >> PAGE_SHIFT;
+		u64 pfn = __pa(vmpl_vmsa(svm)) >> PAGE_SHIFT;
 
 		/* If SVSM support is requested, only measure the boot vCPU */
 		if ((sev->snp_init_flags & KVM_SEV_SNP_SVSM) && vcpu->vcpu_id != 0)
@@ -2520,7 +2520,7 @@ static int snp_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
 			return ret;
 
 		/* Issue the SNP command to encrypt the VMSA */
-		data.address = __sme_pa(vmpl_vmsa(svm, SVM_SEV_VMPL0));
+		data.address = __sme_pa(vmpl_vmsa(svm));
 		ret = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_UPDATE,
 				      &data, &argp->error);
 		if (ret) {
@@ -3242,16 +3242,16 @@ void sev_free_vcpu(struct kvm_vcpu *vcpu)
 	 * releasing it back to the system.
 	 */
 	if (sev_snp_guest(vcpu->kvm)) {
-		u64 pfn = __pa(vmpl_vmsa(svm, SVM_SEV_VMPL0)) >> PAGE_SHIFT;
+		u64 pfn = __pa(vmpl_vmsa(svm)) >> PAGE_SHIFT;
 
 		if (kvm_rmp_make_shared(vcpu->kvm, pfn, PG_LEVEL_4K))
 			goto skip_vmsa_free;
 	}
 
 	if (vcpu->arch.guest_state_protected)
-		sev_flush_encrypted_page(vcpu, vmpl_vmsa(svm, SVM_SEV_VMPL0));
+		sev_flush_encrypted_page(vcpu, vmpl_vmsa(svm));
 
-	__free_page(virt_to_page(vmpl_vmsa(svm, SVM_SEV_VMPL0)));
+	__free_page(virt_to_page(vmpl_vmsa(svm)));
 
 skip_vmsa_free:
 	if (svm->sev_es.ghcb_sa_free)
@@ -3924,13 +3924,18 @@ static int __sev_snp_update_protected_guest_state(struct kvm_vcpu *vcpu)
 
 	/* Clear use of the VMSA */
 	svm->vmcb->control.vmsa_pa = INVALID_PAGE;
-	tgt_vmpl_vmsa_hpa(svm) = INVALID_PAGE;
+	vmpl_vmsa_hpa(svm) = INVALID_PAGE;
 
-	if (VALID_PAGE(tgt_vmpl_vmsa_gpa(svm))) {
-		gfn_t gfn = gpa_to_gfn(tgt_vmpl_vmsa_gpa(svm));
+	if (VALID_PAGE(vmpl_vmsa_gpa(svm))) {
+		gfn_t gfn = gpa_to_gfn(vmpl_vmsa_gpa(svm));
 		struct kvm_memory_slot *slot;
 		kvm_pfn_t pfn;
 
+		if (vcpu->vmpl != 0) {
+			svm->vmcb->control.asid = to_svm(vcpu->vcpu_parent->vcpu_vmpl[0])->vmcb->control.asid;
+			svm->vmcb->control.nested_cr3 = to_svm(vcpu->vcpu_parent->vcpu_vmpl[0])->vmcb->control.nested_cr3;
+		}
+
 		slot = gfn_to_memslot(vcpu->kvm, gfn);
 		if (!slot)
 			return -EINVAL;
@@ -3952,11 +3957,11 @@ static int __sev_snp_update_protected_guest_state(struct kvm_vcpu *vcpu)
 		 * guest boot. Deferring that also allows the existing logic for
 		 * SEV-ES VMSAs to be re-used with minimal SNP-specific changes.
 		 */
-		tgt_vmpl_has_guest_vmsa(svm) = true;
+		vmpl_has_guest_vmsa(svm) = true;
 
 		/* Use the new VMSA */
 		svm->vmcb->control.vmsa_pa = pfn_to_hpa(pfn);
-		tgt_vmpl_vmsa_hpa(svm) = pfn_to_hpa(pfn);
+		vmpl_vmsa_hpa(svm) = pfn_to_hpa(pfn);
 
 		/*
 		 * Since the vCPU may not have gone through the LAUNCH_UPDATE_VMSA path,
@@ -3969,7 +3974,7 @@ static int __sev_snp_update_protected_guest_state(struct kvm_vcpu *vcpu)
 		vcpu->arch.pv.pv_unhalted = false;
 		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 
-		tgt_vmpl_vmsa_gpa(svm) = INVALID_PAGE;
+		vmpl_vmsa_gpa(svm) = INVALID_PAGE;
 
 		/*
 		 * gmem pages aren't currently migratable, but if this ever
@@ -3980,25 +3985,6 @@ static int __sev_snp_update_protected_guest_state(struct kvm_vcpu *vcpu)
 		kvm_release_pfn_clean(pfn);
 	}
 
-	if (cur_vmpl(svm) != tgt_vmpl(svm)) {
-		/* Unmap the current GHCB */
-		sev_es_unmap_ghcb(svm);
-
-		/* Save the GHCB GPA of the current VMPL */
-		svm->sev_es.ghcb_gpa[cur_vmpl(svm)] = svm->vmcb->control.ghcb_gpa;
-
-		/* Set the GHCB_GPA for the target VMPL and make it the current VMPL */
-		svm->vmcb->control.ghcb_gpa = svm->sev_es.ghcb_gpa[tgt_vmpl(svm)];
-
-		cur_vmpl(svm) = tgt_vmpl(svm);
-	}
-
-	/*
-	 * When replacing the VMSA during SEV-SNP AP creation,
-	 * mark the VMCB dirty so that full state is always reloaded.
-	 */
-	vmcb_mark_all_dirty(svm->vmcb);
-
 	return 0;
 }
 
@@ -4017,12 +4003,12 @@ bool sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu)
 
 	mutex_lock(&svm->sev_es.snp_vmsa_mutex);
 
-	if (!tgt_vmpl_ap_waiting_for_reset(svm))
+	if (!vmpl_ap_waiting_for_reset(svm))
 		goto unlock;
 
 	init = true;
 
-	tgt_vmpl_ap_waiting_for_reset(svm) = false;
+	vmpl_ap_waiting_for_reset(svm) = false;
 
 	ret = __sev_snp_update_protected_guest_state(vcpu);
 	if (ret)
@@ -4067,6 +4053,8 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
 			    apic_id);
 		return -EINVAL;
 	}
+	/* Ensure we have the target CPU for the correct VMPL */
+	target_vcpu = target_vcpu->vcpu_parent->vcpu_vmpl[vmpl];
 
 	ret = 0;
 
@@ -4081,13 +4069,13 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
 
 	mutex_lock(&target_svm->sev_es.snp_vmsa_mutex);
 
-	vmpl_vmsa_gpa(target_svm, vmpl) = INVALID_PAGE;
-	vmpl_ap_waiting_for_reset(target_svm, vmpl) = true;
+	vmpl_vmsa_gpa(target_svm) = INVALID_PAGE;
+	vmpl_ap_waiting_for_reset(target_svm) = true;
 
 	/* VMPL0 can only be replaced by another vCPU running VMPL0 */
 	if (vmpl == SVM_SEV_VMPL0 &&
 	    (vcpu == target_vcpu ||
-	     vmpl_vmsa_hpa(svm, SVM_SEV_VMPL0) != svm->vmcb->control.vmsa_pa)) {
+	     vmpl_vmsa_hpa(svm) != svm->vmcb->control.vmsa_pa)) {
 		ret = -EINVAL;
 		goto out;
 	}
@@ -4145,9 +4133,7 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
 		kick = false;
 		fallthrough;
 	case SVM_VMGEXIT_AP_CREATE:
-		/* Switch to new VMSA on the next VMRUN */
-		target_svm->sev_es.snp_target_vmpl = vmpl;
-		vmpl_vmsa_gpa(target_svm, vmpl) = svm->vmcb->control.exit_info_2 & PAGE_MASK;
+		vmpl_vmsa_gpa(target_svm) = svm->vmcb->control.exit_info_2 & PAGE_MASK;
 		break;
 	case SVM_VMGEXIT_AP_DESTROY:
 		break;
@@ -4161,6 +4147,17 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
 out:
 	if (kick) {
 		kvm_make_request(KVM_REQ_UPDATE_PROTECTED_GUEST_STATE, target_vcpu);
+
+		/*
+		 * SNP APs can be initially started using the APIC INIT/SIPI sequence or
+		 * via a GHCB call. In the case of the GHCB call the sequence is not moved
+		 * from KVM_MP_STATE_UNINITIALIZED to KVM_MP_STATE_RUNNABLE, so we need
+    	 * to unblock the VCPU.
+		 */
+		if (target_vcpu->vcpu_parent->vcpu_vmpl[0]->arch.mp_state == KVM_MP_STATE_UNINITIALIZED) {
+			target_vcpu->vcpu_parent->vcpu_vmpl[0]->arch.mp_state = KVM_MP_STATE_RUNNABLE;
+		}
+
 		kvm_vcpu_kick(target_vcpu);
 	}
 
@@ -4339,59 +4336,33 @@ static void sev_get_apic_ids(struct vcpu_svm *svm)
 
 static int __sev_run_vmpl_vmsa(struct vcpu_svm *svm, unsigned int new_vmpl)
 {
-	struct kvm_vcpu *vcpu = &svm->vcpu;
-	struct vmpl_switch_sa *old_vmpl_sa;
-	struct vmpl_switch_sa *new_vmpl_sa;
-	unsigned int old_vmpl;
+	struct kvm_vcpu_vmpl_state *vcpu_parent = svm->vcpu.vcpu_parent;
+	struct kvm_vcpu *vcpu_current = &svm->vcpu;
+	struct kvm_vcpu *vcpu_target = vcpu_parent->vcpu_vmpl[new_vmpl];
+	struct vcpu_svm *svm_current = svm;
+	struct vcpu_svm *svm_target = to_svm(vcpu_target);
 
 	if (new_vmpl >= SVM_SEV_VMPL_MAX)
 		return -EINVAL;
 	new_vmpl = array_index_nospec(new_vmpl, SVM_SEV_VMPL_MAX);
+	vcpu_current->vcpu_parent->target_vmpl = new_vmpl;
 
-	old_vmpl = svm->sev_es.snp_current_vmpl;
-	svm->sev_es.snp_target_vmpl = new_vmpl;
+	if (new_vmpl == vcpu_parent->current_vmpl) {
+		return 0;
+	}
 
-	if (svm->sev_es.snp_target_vmpl == svm->sev_es.snp_current_vmpl ||
-	    sev_snp_init_protected_guest_state(vcpu))
+	if (sev_snp_init_protected_guest_state(vcpu_target)) {
 		return 0;
+	}
 
 	/* If the VMSA is not valid, return an error */
-	if (!VALID_PAGE(vmpl_vmsa_hpa(svm, new_vmpl)))
+	if (!VALID_PAGE(vmpl_vmsa_hpa(svm_target)))
 		return -EINVAL;
 
 	/* Unmap the current GHCB */
-	sev_es_unmap_ghcb(svm);
-
-	/* Save some current VMCB values */
-	svm->sev_es.ghcb_gpa[old_vmpl]		= svm->vmcb->control.ghcb_gpa;
-
-	old_vmpl_sa = &svm->sev_es.vssa[old_vmpl];
-	old_vmpl_sa->int_state			= svm->vmcb->control.int_state;
-	old_vmpl_sa->exit_int_info		= svm->vmcb->control.exit_int_info;
-	old_vmpl_sa->exit_int_info_err		= svm->vmcb->control.exit_int_info_err;
-	old_vmpl_sa->cr0			= vcpu->arch.cr0;
-	old_vmpl_sa->cr2			= vcpu->arch.cr2;
-	old_vmpl_sa->cr4			= vcpu->arch.cr4;
-	old_vmpl_sa->cr8			= vcpu->arch.cr8;
-	old_vmpl_sa->efer			= vcpu->arch.efer;
-
-	/* Restore some previous VMCB values */
-	svm->vmcb->control.vmsa_pa		= vmpl_vmsa_hpa(svm, new_vmpl);
-	svm->vmcb->control.ghcb_gpa		= svm->sev_es.ghcb_gpa[new_vmpl];
-
-	new_vmpl_sa = &svm->sev_es.vssa[new_vmpl];
-	svm->vmcb->control.int_state		= new_vmpl_sa->int_state;
-	svm->vmcb->control.exit_int_info	= new_vmpl_sa->exit_int_info;
-	svm->vmcb->control.exit_int_info_err	= new_vmpl_sa->exit_int_info_err;
-	vcpu->arch.cr0				= new_vmpl_sa->cr0;
-	vcpu->arch.cr2				= new_vmpl_sa->cr2;
-	vcpu->arch.cr4				= new_vmpl_sa->cr4;
-	vcpu->arch.cr8				= new_vmpl_sa->cr8;
-	vcpu->arch.efer				= new_vmpl_sa->efer;
-
-	svm->sev_es.snp_current_vmpl = new_vmpl;
-
-	vmcb_mark_all_dirty(svm->vmcb);
+	sev_es_unmap_ghcb(svm_current);
+
+	vcpu_parent->target_vmpl = new_vmpl;
 
 	return 0;
 }
@@ -4520,7 +4491,7 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 		gfn = get_ghcb_msr_bits(svm, GHCB_MSR_GPA_VALUE_MASK,
 					GHCB_MSR_GPA_VALUE_POS);
 
-		svm->sev_es.ghcb_registered_gpa[cur_vmpl(svm)] = gfn_to_gpa(gfn);
+		svm->sev_es.ghcb_registered_gpa = gfn_to_gpa(gfn);
 
 		set_ghcb_msr_bits(svm, gfn, GHCB_MSR_GPA_VALUE_MASK,
 				  GHCB_MSR_GPA_VALUE_POS);
@@ -4825,8 +4796,8 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
 	 * the VMSA will be NULL if this vCPU is the destination for intrahost
 	 * migration, and will be copied later.
 	 */
-	if (cur_vmpl_vmsa(svm) && !cur_vmpl_has_guest_vmsa(svm))
-		svm->vmcb->control.vmsa_pa = __pa(cur_vmpl_vmsa(svm));
+	if (vmpl_vmsa(svm) && !vmpl_has_guest_vmsa(svm))
+		svm->vmcb->control.vmsa_pa = __pa(vmpl_vmsa(svm));
 
 	/* Can't intercept CR register access, HV can't modify CR registers */
 	svm_clr_intercept(svm, INTERCEPT_CR0_READ);
@@ -4889,7 +4860,6 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm)
 {
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 	struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
-	unsigned int i;
 	u64 sev_info;
 
 	/*
@@ -4899,20 +4869,9 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm)
 	sev_info = GHCB_MSR_SEV_INFO((__u64)sev->ghcb_version, GHCB_VERSION_MIN,
 				     sev_enc_bit);
 	set_ghcb_msr(svm, sev_info);
-	svm->sev_es.ghcb_gpa[SVM_SEV_VMPL0] = sev_info;
+	svm->sev_es.ghcb_gpa = sev_info;
 
 	mutex_init(&svm->sev_es.snp_vmsa_mutex);
-
-	/*
-	 * When not running under SNP, the "current VMPL" tracking for a guest
-	 * is always 0 and the base tracking of GPAs and SPAs will be as before
-	 * multiple VMPL support. However, under SNP, multiple VMPL levels can
-	 * be run, so initialize these values appropriately.
-	 */
-	for (i = 1; i < SVM_SEV_VMPL_MAX; i++) {
-		svm->sev_es.vmsa_info[i].hpa = INVALID_PAGE;
-		svm->sev_es.ghcb_gpa[i] = sev_info;
-	}
 }
 
 void sev_es_prepare_switch_to_guest(struct vcpu_svm *svm, struct sev_es_save_area *hostsa)
@@ -5301,7 +5260,7 @@ bool sev_snp_is_rinj_active(struct kvm_vcpu *vcpu)
 		return false;
 
 	sev = &to_kvm_svm(vcpu->kvm)->sev_info;
-	vmpl = to_svm(vcpu)->sev_es.snp_current_vmpl;
+	vmpl = vcpu->vcpu_parent->current_vmpl;
 
 	return sev->vmsa_features[vmpl] & SVM_SEV_FEAT_RESTRICTED_INJECTION;
 }
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 478cd15bb9f2..22a189910ba1 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -996,40 +996,54 @@ void svm_copy_lbrs(struct vmcb *to_vmcb, struct vmcb *from_vmcb)
 
 void svm_enable_lbrv(struct kvm_vcpu *vcpu)
 {
-	struct vcpu_svm *svm = to_svm(vcpu);
+	int vtl;
+	struct vcpu_svm *svm;
+	struct kvm_vcpu_vmpl_state *vcpu_parent = vcpu->vcpu_parent;
 
-	svm->vmcb->control.virt_ext |= LBR_CTL_ENABLE_MASK;
-	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHFROMIP, 1, 1);
-	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHTOIP, 1, 1);
-	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTFROMIP, 1, 1);
-	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTTOIP, 1, 1);
+	for (vtl = 0; vtl <= vcpu_parent->max_vmpl; ++vtl) {
+		vcpu = vcpu_parent->vcpu_vmpl[vtl];
+		svm = to_svm(vcpu);
 
-	if (sev_es_guest(vcpu->kvm))
-		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_DEBUGCTLMSR, 1, 1);
+		svm->vmcb->control.virt_ext |= LBR_CTL_ENABLE_MASK;
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHFROMIP, 1, 1);
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHTOIP, 1, 1);
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTFROMIP, 1, 1);
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTTOIP, 1, 1);
 
-	/* Move the LBR msrs to the vmcb02 so that the guest can see them. */
-	if (is_guest_mode(vcpu))
-		svm_copy_lbrs(svm->vmcb, svm->vmcb01.ptr);
+		if (sev_es_guest(vcpu->kvm))
+			set_msr_interception(vcpu, svm->msrpm, MSR_IA32_DEBUGCTLMSR, 1, 1);
+
+		/* Move the LBR msrs to the vmcb02 so that the guest can see them. */
+		if (is_guest_mode(vcpu))
+			svm_copy_lbrs(svm->vmcb, svm->vmcb01.ptr);
+	}
 }
 
 static void svm_disable_lbrv(struct kvm_vcpu *vcpu)
 {
-	struct vcpu_svm *svm = to_svm(vcpu);
+	int vtl;
+	struct vcpu_svm *svm;
+	struct kvm_vcpu_vmpl_state *vcpu_parent = vcpu->vcpu_parent;
 
-	KVM_BUG_ON(sev_es_guest(vcpu->kvm), vcpu->kvm);
+	for (vtl = 0; vtl <= vcpu_parent->max_vmpl; ++vtl) {
+		vcpu = vcpu_parent->vcpu_vmpl[vtl];
+		svm = to_svm(vcpu);
 
-	svm->vmcb->control.virt_ext &= ~LBR_CTL_ENABLE_MASK;
-	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHFROMIP, 0, 0);
-	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHTOIP, 0, 0);
-	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTFROMIP, 0, 0);
-	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTTOIP, 0, 0);
+		KVM_BUG_ON(sev_es_guest(vcpu->kvm), vcpu->kvm);
 
-	/*
-	 * Move the LBR msrs back to the vmcb01 to avoid copying them
-	 * on nested guest entries.
-	 */
-	if (is_guest_mode(vcpu))
-		svm_copy_lbrs(svm->vmcb01.ptr, svm->vmcb);
+		svm->vmcb->control.virt_ext &= ~LBR_CTL_ENABLE_MASK;
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHFROMIP, 0, 0);
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHTOIP, 0, 0);
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTFROMIP, 0, 0);
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTTOIP, 0, 0);
+
+		/*
+		* Move the LBR msrs back to the vmcb01 to avoid copying them
+		* on nested guest entries.
+		*/
+		if (is_guest_mode(vcpu))
+			svm_copy_lbrs(svm->vmcb01.ptr, svm->vmcb);
+	}
 }
 
 static struct vmcb *svm_get_lbr_vmcb(struct vcpu_svm *svm)
@@ -1464,8 +1478,8 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
 	svm_switch_vmcb(svm, &svm->vmcb01);
 
 	if (vmsa_page) {
-		vmpl_vmsa(svm, SVM_SEV_VMPL0) = page_address(vmsa_page);
-		vmpl_vmsa_hpa(svm, SVM_SEV_VMPL0) = __pa(page_address(vmsa_page));
+		vmpl_vmsa(svm) = page_address(vmsa_page);
+		vmpl_vmsa_hpa(svm) = __pa(page_address(vmsa_page));
 	}
 
 	svm->guest_state_loaded = false;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 97a1b1b4cb5f..de7f92ba55c3 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -211,25 +211,11 @@ struct vmpl_switch_sa {
 	u64 efer;
 };
 
-#define vmpl_vmsa(s, v)				((s)->sev_es.vmsa_info[(v)].vmsa)
-#define vmpl_vmsa_gpa(s, v)			((s)->sev_es.vmsa_info[(v)].gpa)
-#define vmpl_vmsa_hpa(s, v)			((s)->sev_es.vmsa_info[(v)].hpa)
-#define vmpl_ap_waiting_for_reset(s, v)		((s)->sev_es.vmsa_info[(v)].ap_waiting_for_reset)
-#define vmpl_has_guest_vmsa(s, v)		((s)->sev_es.vmsa_info[(v)].has_guest_vmsa)
-
-#define cur_vmpl(s)				((s)->sev_es.snp_current_vmpl)
-#define cur_vmpl_vmsa(s)			vmpl_vmsa((s), cur_vmpl(s))
-#define cur_vmpl_vmsa_gpa(s)			vmpl_vmsa_gpa((s), cur_vmpl(s))
-#define cur_vmpl_vmsa_hpa(s)			vmpl_vmsa_hpa((s), cur_vmpl(s))
-#define cur_vmpl_ap_waiting_for_reset(s)	vmpl_ap_waiting_for_reset((s), cur_vmpl(s))
-#define cur_vmpl_has_guest_vmsa(s)		vmpl_has_guest_vmsa((s), cur_vmpl(s))
-
-#define tgt_vmpl(s)				((s)->sev_es.snp_target_vmpl)
-#define tgt_vmpl_vmsa(s)			vmpl_vmsa((s), tgt_vmpl(s))
-#define tgt_vmpl_vmsa_gpa(s)			vmpl_vmsa_gpa((s), tgt_vmpl(s))
-#define tgt_vmpl_vmsa_hpa(s)			vmpl_vmsa_hpa((s), tgt_vmpl(s))
-#define tgt_vmpl_ap_waiting_for_reset(s)	vmpl_ap_waiting_for_reset((s), tgt_vmpl(s))
-#define tgt_vmpl_has_guest_vmsa(s)		vmpl_has_guest_vmsa((s), tgt_vmpl(s))
+#define vmpl_vmsa(s)				((s)->sev_es.vmsa_info.vmsa)
+#define vmpl_vmsa_gpa(s)			((s)->sev_es.vmsa_info.gpa)
+#define vmpl_vmsa_hpa(s)			((s)->sev_es.vmsa_info.hpa)
+#define vmpl_ap_waiting_for_reset(s)	((s)->sev_es.vmsa_info.ap_waiting_for_reset)
+#define vmpl_has_guest_vmsa(s)		((s)->sev_es.vmsa_info.has_guest_vmsa)
 
 struct sev_vmsa_info {
 	/* SEV-ES and SEV-SNP */
@@ -262,15 +248,13 @@ struct vcpu_sev_es_state {
 	u16 psc_inflight;
 	bool psc_2m;
 
-	gpa_t ghcb_gpa[SVM_SEV_VMPL_MAX];
-	u64 ghcb_registered_gpa[SVM_SEV_VMPL_MAX];
-	struct sev_vmsa_info vmsa_info[SVM_SEV_VMPL_MAX];
+	gpa_t ghcb_gpa;
+	u64 ghcb_registered_gpa;
+	struct sev_vmsa_info vmsa_info;
 
 	struct mutex snp_vmsa_mutex; /* Used to handle concurrent updates of VMSA. */
-	unsigned int snp_current_vmpl;
-	unsigned int snp_target_vmpl;
 
-	struct vmpl_switch_sa vssa[SVM_SEV_VMPL_MAX];
+	struct vmpl_switch_sa vssa;
 };
 
 struct vcpu_svm {
@@ -426,7 +410,7 @@ static __always_inline bool sev_snp_guest(struct kvm *kvm)
 
 static inline bool ghcb_gpa_is_registered(struct vcpu_svm *svm, u64 val)
 {
-	return svm->sev_es.ghcb_registered_gpa[cur_vmpl(svm)] == val;
+	return svm->sev_es.ghcb_registered_gpa == val;
 }
 
 static inline void vmcb_mark_all_dirty(struct vmcb *vmcb)
-- 
2.43.0


