Return-Path: <kvm+bounces-65330-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B21ACA6E3A
	for <lists+kvm@lfdr.de>; Fri, 05 Dec 2025 10:25:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D93FA37F6BC8
	for <lists+kvm@lfdr.de>; Fri,  5 Dec 2025 08:21:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EFD93557E3;
	Fri,  5 Dec 2025 07:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="eR6BnLvJ";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="eR6BnLvJ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B5E833A6F2
	for <kvm@vger.kernel.org>; Fri,  5 Dec 2025 07:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764920868; cv=none; b=KgMYkRlyJGhnNubFNapgID2Ll+T4c5ZQoo2+niANNnBJ1t69J7h3NAGKP4SjTFENbPwNlVlpyhKkTQ81YJgkPpaNWvSXHYPCWbY9q3TZVyl470s+X8d6jeCMoawiRqKrW6x0jB7nyCABGfiTb5OTtuonhaVu8h+qHx17zZ3AXLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764920868; c=relaxed/simple;
	bh=NwiX+ZQg9gJbuusYmUR7cZPd6vYzVTazUYgfNq67lFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OAh2k711eIfBSjKJjFFnFDULjfGeAjJMSig7jl+VB0eZTIHnuNvwVkrX844ZgLxxpNt42gTqLlzn/ySSks9rjFdKsH+fYKKFXvIOD23gM6fQE+TvvnjK7gzcMbngi/rAv4QL3NujBrjiKtIUn95600oumYVMC9OKZAJHDBvt2l8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=eR6BnLvJ; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=eR6BnLvJ; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BA73A336D9;
	Fri,  5 Dec 2025 07:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1764920792; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Knqe8SmxlIRac6xSSjl2afoYr8y/15Xf9OoZi/a4HLY=;
	b=eR6BnLvJoEyoE1pTueqBai9jS1rzz5JNjQBa14cPAADRiPPkdRsvzaaLmxoirWLG8oZONg
	ojtLh8biq/wj3FwrsJfEp9bhwuYgZ53lyPTk4pOXjXoAX7xXjbvjekDWN2UgBkEEeEgmWg
	0TIolkuzb+ZB40MPFB2FnMZ8YuIF2VU=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1764920792; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Knqe8SmxlIRac6xSSjl2afoYr8y/15Xf9OoZi/a4HLY=;
	b=eR6BnLvJoEyoE1pTueqBai9jS1rzz5JNjQBa14cPAADRiPPkdRsvzaaLmxoirWLG8oZONg
	ojtLh8biq/wj3FwrsJfEp9bhwuYgZ53lyPTk4pOXjXoAX7xXjbvjekDWN2UgBkEEeEgmWg
	0TIolkuzb+ZB40MPFB2FnMZ8YuIF2VU=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 59BBE3EA63;
	Fri,  5 Dec 2025 07:46:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id XjVIFNiNMmmaEgAAD6G6ig
	(envelope-from <jgross@suse.com>); Fri, 05 Dec 2025 07:46:32 +0000
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	kvm@vger.kernel.org
Cc: Juergen Gross <jgross@suse.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 09/10] KVM/x86: Use defines for SVM related MSR emulation
Date: Fri,  5 Dec 2025 08:45:36 +0100
Message-ID: <20251205074537.17072-10-jgross@suse.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251205074537.17072-1-jgross@suse.com>
References: <20251205074537.17072-1-jgross@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.988];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email,imap1.dmz-prg2.suse.org:helo];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	R_RATELIMIT(0.00)[to_ip_from(RLfdszjqhz8kzzb9uwpzdm8png)];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -2.80

Instead of "0" and "1" use the related KVM_MSR_RET_* defines in the
emulation code of SVM related MSR registers.

No change of functionality intended.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/kvm/svm/pmu.c | 12 ++++++------
 arch/x86/kvm/svm/svm.c | 44 +++++++++++++++++++++---------------------
 2 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index bc062285fbf5..c4b2fe77cc27 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -135,16 +135,16 @@ static int amd_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	pmc = get_gp_pmc_amd(pmu, msr, PMU_TYPE_COUNTER);
 	if (pmc) {
 		msr_info->data = pmc_read_counter(pmc);
-		return 0;
+		return KVM_MSR_RET_OK;
 	}
 	/* MSR_EVNTSELn */
 	pmc = get_gp_pmc_amd(pmu, msr, PMU_TYPE_EVNTSEL);
 	if (pmc) {
 		msr_info->data = pmc->eventsel;
-		return 0;
+		return KVM_MSR_RET_OK;
 	}
 
-	return 1;
+	return KVM_MSR_RET_ERR;
 }
 
 static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
@@ -158,7 +158,7 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	pmc = get_gp_pmc_amd(pmu, msr, PMU_TYPE_COUNTER);
 	if (pmc) {
 		pmc_write_counter(pmc, data);
-		return 0;
+		return KVM_MSR_RET_OK;
 	}
 	/* MSR_EVNTSELn */
 	pmc = get_gp_pmc_amd(pmu, msr, PMU_TYPE_EVNTSEL);
@@ -168,10 +168,10 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			pmc->eventsel = data;
 			kvm_pmu_request_counter_reprogram(pmc);
 		}
-		return 0;
+		return KVM_MSR_RET_OK;
 	}
 
-	return 1;
+	return KVM_MSR_RET_ERR;
 }
 
 static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7cbf4d686415..73ff38617311 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2638,7 +2638,7 @@ static int svm_get_feature_msr(u32 msr, u64 *data)
 		return KVM_MSR_RET_UNSUPPORTED;
 	}
 
-	return 0;
+	return KVM_MSR_RET_OK;
 }
 
 static bool sev_es_prevent_msr_access(struct kvm_vcpu *vcpu,
@@ -2655,14 +2655,14 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 	if (sev_es_prevent_msr_access(vcpu, msr_info)) {
 		msr_info->data = 0;
-		return vcpu->kvm->arch.has_protected_state ? -EINVAL : 0;
+		return vcpu->kvm->arch.has_protected_state ? -EINVAL : KVM_MSR_RET_OK;
 	}
 
 	switch (msr_info->index) {
 	case MSR_AMD64_TSC_RATIO:
 		if (!msr_info->host_initiated &&
 		    !guest_cpu_cap_has(vcpu, X86_FEATURE_TSCRATEMSR))
-			return 1;
+			return KVM_MSR_RET_ERR;
 		msr_info->data = svm->tsc_ratio_msr;
 		break;
 	case MSR_STAR:
@@ -2737,7 +2737,7 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_SPEC_CTRL:
 		if (!msr_info->host_initiated &&
 		    !guest_has_spec_ctrl_msr(vcpu))
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		if (boot_cpu_has(X86_FEATURE_V_SPEC_CTRL))
 			msr_info->data = svm->vmcb->save.spec_ctrl;
@@ -2747,7 +2747,7 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_AMD64_VIRT_SPEC_CTRL:
 		if (!msr_info->host_initiated &&
 		    !guest_cpu_cap_has(vcpu, X86_FEATURE_VIRT_SSBD))
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		msr_info->data = svm->virt_spec_ctrl;
 		break;
@@ -2774,7 +2774,7 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	default:
 		return kvm_get_msr_common(vcpu, msr_info);
 	}
-	return 0;
+	return KVM_MSR_RET_OK;
 }
 
 static int svm_complete_emulated_msr(struct kvm_vcpu *vcpu, bool err)
@@ -2793,7 +2793,7 @@ static int svm_set_vm_cr(struct kvm_vcpu *vcpu, u64 data)
 	int svm_dis, chg_mask;
 
 	if (data & ~SVM_VM_CR_VALID_MASK)
-		return 1;
+		return KVM_MSR_RET_ERR;
 
 	chg_mask = SVM_VM_CR_VALID_MASK;
 
@@ -2807,21 +2807,21 @@ static int svm_set_vm_cr(struct kvm_vcpu *vcpu, u64 data)
 
 	/* check for svm_disable while efer.svme is set */
 	if (svm_dis && (vcpu->arch.efer & EFER_SVME))
-		return 1;
+		return KVM_MSR_RET_ERR;
 
-	return 0;
+	return KVM_MSR_RET_OK;
 }
 
 static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	int ret = 0;
+	int ret = KVM_MSR_RET_OK;
 
 	u32 ecx = msr->index;
 	u64 data = msr->data;
 
 	if (sev_es_prevent_msr_access(vcpu, msr))
-		return vcpu->kvm->arch.has_protected_state ? -EINVAL : 0;
+		return vcpu->kvm->arch.has_protected_state ? -EINVAL : KVM_MSR_RET_OK;
 
 	switch (ecx) {
 	case MSR_AMD64_TSC_RATIO:
@@ -2829,7 +2829,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_TSCRATEMSR)) {
 
 			if (!msr->host_initiated)
-				return 1;
+				return KVM_MSR_RET_ERR;
 			/*
 			 * In case TSC scaling is not enabled, always
 			 * leave this MSR at the default value.
@@ -2839,12 +2839,12 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 			 * Ignore this value as well.
 			 */
 			if (data != 0 && data != svm->tsc_ratio_msr)
-				return 1;
+				return KVM_MSR_RET_ERR;
 			break;
 		}
 
 		if (data & SVM_TSC_RATIO_RSVD)
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		svm->tsc_ratio_msr = data;
 
@@ -2866,10 +2866,10 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 	case MSR_IA32_SPEC_CTRL:
 		if (!msr->host_initiated &&
 		    !guest_has_spec_ctrl_msr(vcpu))
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		if (kvm_spec_ctrl_test_value(data))
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		if (boot_cpu_has(X86_FEATURE_V_SPEC_CTRL))
 			svm->vmcb->save.spec_ctrl = data;
@@ -2894,10 +2894,10 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 	case MSR_AMD64_VIRT_SPEC_CTRL:
 		if (!msr->host_initiated &&
 		    !guest_cpu_cap_has(vcpu, X86_FEATURE_VIRT_SSBD))
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		if (data & ~SPEC_CTRL_SSBD)
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		svm->virt_spec_ctrl = data;
 		break;
@@ -2992,7 +2992,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		}
 
 		if (data & DEBUGCTL_RESERVED_BITS)
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		if (svm->vmcb->save.dbgctl == data)
 			break;
@@ -3009,7 +3009,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		 * originating from those kernels.
 		 */
 		if (!msr->host_initiated && !page_address_valid(vcpu, data))
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		svm->nested.hsave_msr = data & PAGE_MASK;
 		break;
@@ -3022,10 +3022,10 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		u64 supported_de_cfg;
 
 		if (svm_get_feature_msr(ecx, &supported_de_cfg))
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		if (data & ~supported_de_cfg)
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		svm->msr_decfg = data;
 		break;
-- 
2.51.0


