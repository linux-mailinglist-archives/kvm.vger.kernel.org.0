Return-Path: <kvm+bounces-65327-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id E0214CA75D7
	for <lists+kvm@lfdr.de>; Fri, 05 Dec 2025 12:25:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id F03F630DF313
	for <lists+kvm@lfdr.de>; Fri,  5 Dec 2025 08:20:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE96A257859;
	Fri,  5 Dec 2025 07:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="vZDJ1Oao";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="e3Zs77oe"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F6A2F12CC
	for <kvm@vger.kernel.org>; Fri,  5 Dec 2025 07:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764920837; cv=none; b=K6kQonZrqR1Dv09VkU4GNM7re2o43pikJ0gU8v1LRpPwEwpRVpa6CPD5q1Cu9OkZhlv53gB75axSu5bus/FuQN/D/51aoA9EK2GKEOsu/UjZTTk22i90U4/cc/+Di5mi3KdetjNgGlNgAIgbWT1oh9uw4rD/CsXodzzc9jveh6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764920837; c=relaxed/simple;
	bh=KZe8NVX7I9+4asOubIJD5SRiruW+b3W/PPA6BOYR7xQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M7Ik2a6Xgj5cLFkj/z2oPxUa+uz4VY4nhOrRUV8tD+qv7W6MuzsUf6Q+B+HyRoohUI97nuY8Xlc7fDzTQcObWiSuQ2CeE8nxMnzvWznKcGvEaiBYNBrHVXjTZZrWLJ0KeSHoCT5XwfxIAl2ozt3ihb+kCx/Li+70H9FYG+8pb5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=vZDJ1Oao; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=e3Zs77oe; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DC1FC5BD1C;
	Fri,  5 Dec 2025 07:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1764920788; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2hxCsfZJHPXYDLJrmflxcWgKrjVmvGDUAA6RttCGsvQ=;
	b=vZDJ1OaoAEQnuUg7hkX4siQdaJ4s3ZZHC+/FEiyx31bnF7T8qoMybfWeUEGe5Cuyh1fJd5
	qp6iQ3aq3cehz6hplB/adUSzaZfdzIwL3H2gIZ85ehNhoX1KILCYs1qt4IdvmZ9rzEfm5O
	YzhOft52+ID8jBMfdyJqU1j3iOft1yI=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1764920786; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2hxCsfZJHPXYDLJrmflxcWgKrjVmvGDUAA6RttCGsvQ=;
	b=e3Zs77oeS1QuFN4bhk5znMmQJXUfHCtsx4QfpS3b6znWzXXLPPDiOrSvPw9003YgLqvXd0
	25SZmo45E2bS2uC31r4k+kk2J9QItCoYp3I7+9QWmzV+Q0SVLWKJOQHf4auTGM5mmBTcCL
	N1qjYIihB7AQoA2hDN4OnzLEDxOlw70=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6CF403EA63;
	Fri,  5 Dec 2025 07:46:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MqP9GNKNMmmUEgAAD6G6ig
	(envelope-from <jgross@suse.com>); Fri, 05 Dec 2025 07:46:26 +0000
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	kvm@vger.kernel.org,
	linux-coco@lists.linux.dev
Cc: Juergen Gross <jgross@suse.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [PATCH 08/10] KVM/x86: Use defines for VMX related MSR emulation
Date: Fri,  5 Dec 2025 08:45:35 +0100
Message-ID: <20251205074537.17072-9-jgross@suse.com>
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
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.989];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLfdszjqhz8kzzb9uwpzdm8png)];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -2.80

Instead of "0" and "1" use the related KVM_MSR_RET_* defines in the
emulation code of VMX related MSR registers.

No change of functionality intended.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/kvm/vmx/nested.c    |  18 +++---
 arch/x86/kvm/vmx/pmu_intel.c |  20 +++----
 arch/x86/kvm/vmx/tdx.c       |  16 +++---
 arch/x86/kvm/vmx/vmx.c       | 104 +++++++++++++++++------------------
 4 files changed, 79 insertions(+), 79 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index bcea087b642f..76e8dc811bae 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1325,7 +1325,7 @@ static int vmx_restore_vmx_basic(struct vcpu_vmx *vmx, u64 data)
 		return -EINVAL;
 
 	vmx->nested.msrs.basic = data;
-	return 0;
+	return KVM_MSR_RET_OK;
 }
 
 static void vmx_get_control_msr(struct nested_vmx_msrs *msrs, u32 msr_index,
@@ -1378,7 +1378,7 @@ vmx_restore_control_msr(struct vcpu_vmx *vmx, u32 msr_index, u64 data)
 	vmx_get_control_msr(&vmx->nested.msrs, msr_index, &lowp, &highp);
 	*lowp = data;
 	*highp = data >> 32;
-	return 0;
+	return KVM_MSR_RET_OK;
 }
 
 static int vmx_restore_vmx_misc(struct vcpu_vmx *vmx, u64 data)
@@ -1426,7 +1426,7 @@ static int vmx_restore_vmx_misc(struct vcpu_vmx *vmx, u64 data)
 	vmx->nested.msrs.misc_low = data;
 	vmx->nested.msrs.misc_high = data >> 32;
 
-	return 0;
+	return KVM_MSR_RET_OK;
 }
 
 static int vmx_restore_vmx_ept_vpid_cap(struct vcpu_vmx *vmx, u64 data)
@@ -1440,7 +1440,7 @@ static int vmx_restore_vmx_ept_vpid_cap(struct vcpu_vmx *vmx, u64 data)
 
 	vmx->nested.msrs.ept_caps = data;
 	vmx->nested.msrs.vpid_caps = data >> 32;
-	return 0;
+	return KVM_MSR_RET_OK;
 }
 
 static u64 *vmx_get_fixed0_msr(struct nested_vmx_msrs *msrs, u32 msr_index)
@@ -1467,7 +1467,7 @@ static int vmx_restore_fixed0_msr(struct vcpu_vmx *vmx, u32 msr_index, u64 data)
 		return -EINVAL;
 
 	*vmx_get_fixed0_msr(&vmx->nested.msrs, msr_index) = data;
-	return 0;
+	return KVM_MSR_RET_OK;
 }
 
 /*
@@ -1525,12 +1525,12 @@ int vmx_set_vmx_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
 		return vmx_restore_vmx_ept_vpid_cap(vmx, data);
 	case MSR_IA32_VMX_VMCS_ENUM:
 		vmx->nested.msrs.vmcs_enum = data;
-		return 0;
+		return KVM_MSR_RET_OK;
 	case MSR_IA32_VMX_VMFUNC:
 		if (data & ~vmcs_config.nested.vmfunc_controls)
 			return -EINVAL;
 		vmx->nested.msrs.vmfunc_controls = data;
-		return 0;
+		return KVM_MSR_RET_OK;
 	default:
 		/*
 		 * The rest of the VMX capability MSRs do not support restore.
@@ -1611,10 +1611,10 @@ int vmx_get_vmx_msr(struct nested_vmx_msrs *msrs, u32 msr_index, u64 *pdata)
 		*pdata = msrs->vmfunc_controls;
 		break;
 	default:
-		return 1;
+		return KVM_MSR_RET_ERR;
 	}
 
-	return 0;
+	return KVM_MSR_RET_OK;
 }
 
 /*
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index de1d9785c01f..8bab64a748b8 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -374,10 +374,10 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		} else if (intel_pmu_handle_lbr_msrs_access(vcpu, msr_info, true)) {
 			break;
 		}
-		return 1;
+		return KVM_MSR_RET_ERR;
 	}
 
-	return 0;
+	return KVM_MSR_RET_OK;
 }
 
 static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
@@ -391,14 +391,14 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	switch (msr) {
 	case MSR_CORE_PERF_FIXED_CTR_CTRL:
 		if (data & pmu->fixed_ctr_ctrl_rsvd)
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		if (pmu->fixed_ctr_ctrl != data)
 			reprogram_fixed_counters(pmu, data);
 		break;
 	case MSR_IA32_PEBS_ENABLE:
 		if (data & pmu->pebs_enable_rsvd)
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		if (pmu->pebs_enable != data) {
 			diff = pmu->pebs_enable ^ data;
@@ -408,13 +408,13 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_IA32_DS_AREA:
 		if (is_noncanonical_msr_address(data, vcpu))
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		pmu->ds_area = data;
 		break;
 	case MSR_PEBS_DATA_CFG:
 		if (data & pmu->pebs_data_cfg_rsvd)
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		pmu->pebs_data_cfg = data;
 		break;
@@ -423,7 +423,7 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
 			if ((msr & MSR_PMC_FULL_WIDTH_BIT) &&
 			    (data & ~pmu->counter_bitmask[KVM_PMC_GP]))
-				return 1;
+				return KVM_MSR_RET_ERR;
 
 			if (!msr_info->host_initiated &&
 			    !(msr & MSR_PMC_FULL_WIDTH_BIT))
@@ -439,7 +439,7 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			    (pmu->raw_event_mask & HSW_IN_TX_CHECKPOINTED))
 				reserved_bits ^= HSW_IN_TX_CHECKPOINTED;
 			if (data & reserved_bits)
-				return 1;
+				return KVM_MSR_RET_ERR;
 
 			if (data != pmc->eventsel) {
 				pmc->eventsel = data;
@@ -450,10 +450,10 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			break;
 		}
 		/* Not a known PMU MSR. */
-		return 1;
+		return KVM_MSR_RET_ERR;
 	}
 
-	return 0;
+	return KVM_MSR_RET_OK;
 }
 
 /*
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 6b99c8dbd8cc..9c798de48272 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2236,15 +2236,15 @@ int tdx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		msr->data = FEAT_CTL_LOCKED;
 		if (vcpu->arch.mcg_cap & MCG_LMCE_P)
 			msr->data |= FEAT_CTL_LMCE_ENABLED;
-		return 0;
+		return KVM_MSR_RET_OK;
 	case MSR_IA32_MCG_EXT_CTL:
 		if (!msr->host_initiated && !(vcpu->arch.mcg_cap & MCG_LMCE_P))
-			return 1;
+			return KVM_MSR_RET_ERR;
 		msr->data = vcpu->arch.mcg_ext_ctl;
-		return 0;
+		return KVM_MSR_RET_OK;
 	default:
 		if (!tdx_has_emulated_msr(msr->index))
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		return kvm_get_msr_common(vcpu, msr);
 	}
@@ -2256,15 +2256,15 @@ int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 	case MSR_IA32_MCG_EXT_CTL:
 		if ((!msr->host_initiated && !(vcpu->arch.mcg_cap & MCG_LMCE_P)) ||
 		    (msr->data & ~MCG_EXT_CTL_LMCE_EN))
-			return 1;
+			return KVM_MSR_RET_ERR;
 		vcpu->arch.mcg_ext_ctl = msr->data;
-		return 0;
+		return KVM_MSR_RET_OK;
 	default:
 		if (tdx_is_read_only_msr(msr->index))
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		if (!tdx_has_emulated_msr(msr->index))
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		return kvm_set_msr_common(vcpu, msr);
 	}
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 365c4ce283e5..a3282a5830ca 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -662,7 +662,7 @@ static int vmx_set_guest_uret_msr(struct vcpu_vmx *vmx,
 				  struct vmx_uret_msr *msr, u64 data)
 {
 	unsigned int slot = msr - vmx->guest_uret_msrs;
-	int ret = 0;
+	int ret = KVM_MSR_RET_OK;
 
 	if (msr->load_into_hardware) {
 		preempt_disable();
@@ -1958,7 +1958,7 @@ int vmx_get_feature_msr(u32 msr, u64 *data)
 	switch (msr) {
 	case KVM_FIRST_EMULATED_VMX_MSR ... KVM_LAST_EMULATED_VMX_MSR:
 		if (!nested)
-			return 1;
+			return KVM_MSR_RET_ERR;
 		return vmx_get_vmx_msr(&vmcs_config.nested, msr, data);
 	default:
 		return KVM_MSR_RET_UNSUPPORTED;
@@ -1993,18 +1993,18 @@ int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_TSX_CTRL:
 		if (!msr_info->host_initiated &&
 		    !(vcpu->arch.arch_capabilities & ARCH_CAP_TSX_CTRL_MSR))
-			return 1;
+			return KVM_MSR_RET_ERR;
 		goto find_uret_msr;
 	case MSR_IA32_UMWAIT_CONTROL:
 		if (!msr_info->host_initiated && !vmx_has_waitpkg(vmx))
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		msr_info->data = vmx->msr_ia32_umwait_control;
 		break;
 	case MSR_IA32_SPEC_CTRL:
 		if (!msr_info->host_initiated &&
 		    !guest_has_spec_ctrl_msr(vcpu))
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		msr_info->data = to_vmx(vcpu)->spec_ctrl;
 		break;
@@ -2021,14 +2021,14 @@ int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (!kvm_mpx_supported() ||
 		    (!msr_info->host_initiated &&
 		     !guest_cpu_cap_has(vcpu, X86_FEATURE_MPX)))
-			return 1;
+			return KVM_MSR_RET_ERR;
 		msr_info->data = vmcs_read64(GUEST_BNDCFGS);
 		break;
 	case MSR_IA32_MCG_EXT_CTL:
 		if (!msr_info->host_initiated &&
 		    !(vmx->msr_ia32_feature_control &
 		      FEAT_CTL_LMCE_ENABLED))
-			return 1;
+			return KVM_MSR_RET_ERR;
 		msr_info->data = vcpu->arch.mcg_ext_ctl;
 		break;
 	case MSR_IA32_FEAT_CTL:
@@ -2037,16 +2037,16 @@ int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_SGXLEPUBKEYHASH0 ... MSR_IA32_SGXLEPUBKEYHASH3:
 		if (!msr_info->host_initiated &&
 		    !guest_cpu_cap_has(vcpu, X86_FEATURE_SGX_LC))
-			return 1;
+			return KVM_MSR_RET_ERR;
 		msr_info->data = to_vmx(vcpu)->msr_ia32_sgxlepubkeyhash
 			[msr_info->index - MSR_IA32_SGXLEPUBKEYHASH0];
 		break;
 	case KVM_FIRST_EMULATED_VMX_MSR ... KVM_LAST_EMULATED_VMX_MSR:
 		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_VMX))
-			return 1;
+			return KVM_MSR_RET_ERR;
 		if (vmx_get_vmx_msr(&vmx->nested.msrs, msr_info->index,
 				    &msr_info->data))
-			return 1;
+			return KVM_MSR_RET_ERR;
 #ifdef CONFIG_KVM_HYPERV
 		/*
 		 * Enlightened VMCS v1 doesn't have certain VMCS fields but
@@ -2062,19 +2062,19 @@ int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_IA32_RTIT_CTL:
 		if (!vmx_pt_mode_is_host_guest())
-			return 1;
+			return KVM_MSR_RET_ERR;
 		msr_info->data = vmx->pt_desc.guest.ctl;
 		break;
 	case MSR_IA32_RTIT_STATUS:
 		if (!vmx_pt_mode_is_host_guest())
-			return 1;
+			return KVM_MSR_RET_ERR;
 		msr_info->data = vmx->pt_desc.guest.status;
 		break;
 	case MSR_IA32_RTIT_CR3_MATCH:
 		if (!vmx_pt_mode_is_host_guest() ||
 			!intel_pt_validate_cap(vmx->pt_desc.caps,
 						PT_CAP_cr3_filtering))
-			return 1;
+			return KVM_MSR_RET_ERR;
 		msr_info->data = vmx->pt_desc.guest.cr3_match;
 		break;
 	case MSR_IA32_RTIT_OUTPUT_BASE:
@@ -2083,7 +2083,7 @@ int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 					PT_CAP_topa_output) &&
 			 !intel_pt_validate_cap(vmx->pt_desc.caps,
 					PT_CAP_single_range_output)))
-			return 1;
+			return KVM_MSR_RET_ERR;
 		msr_info->data = vmx->pt_desc.guest.output_base;
 		break;
 	case MSR_IA32_RTIT_OUTPUT_MASK:
@@ -2092,14 +2092,14 @@ int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 					PT_CAP_topa_output) &&
 			 !intel_pt_validate_cap(vmx->pt_desc.caps,
 					PT_CAP_single_range_output)))
-			return 1;
+			return KVM_MSR_RET_ERR;
 		msr_info->data = vmx->pt_desc.guest.output_mask;
 		break;
 	case MSR_IA32_RTIT_ADDR0_A ... MSR_IA32_RTIT_ADDR3_B:
 		index = msr_info->index - MSR_IA32_RTIT_ADDR0_A;
 		if (!vmx_pt_mode_is_host_guest() ||
 		    (index >= 2 * vmx->pt_desc.num_address_ranges))
-			return 1;
+			return KVM_MSR_RET_ERR;
 		if (index % 2)
 			msr_info->data = vmx->pt_desc.guest.addr_b[index / 2];
 		else
@@ -2127,7 +2127,7 @@ int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		return kvm_get_msr_common(vcpu, msr_info);
 	}
 
-	return 0;
+	return KVM_MSR_RET_OK;
 }
 
 static u64 nested_vmx_truncate_sysenter_addr(struct kvm_vcpu *vcpu,
@@ -2180,7 +2180,7 @@ int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct vmx_uret_msr *msr;
-	int ret = 0;
+	int ret = KVM_MSR_RET_OK;
 	u32 msr_index = msr_info->index;
 	u64 data = msr_info->data;
 	u32 index;
@@ -2241,7 +2241,7 @@ int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_IA32_DEBUGCTLMSR:
 		if (!vmx_is_valid_debugctl(vcpu, data, msr_info->host_initiated))
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		data &= vmx_get_supported_debugctl(vcpu, msr_info->host_initiated);
 
@@ -2254,15 +2254,15 @@ int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (intel_pmu_lbr_is_enabled(vcpu) && !to_vmx(vcpu)->lbr_desc.event &&
 		    (data & DEBUGCTLMSR_LBR))
 			intel_pmu_create_guest_lbr_event(vcpu);
-		return 0;
+		return KVM_MSR_RET_OK;
 	case MSR_IA32_BNDCFGS:
 		if (!kvm_mpx_supported() ||
 		    (!msr_info->host_initiated &&
 		     !guest_cpu_cap_has(vcpu, X86_FEATURE_MPX)))
-			return 1;
+			return KVM_MSR_RET_ERR;
 		if (is_noncanonical_msr_address(data & PAGE_MASK, vcpu) ||
 		    (data & MSR_IA32_BNDCFGS_RSVD))
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		if (is_guest_mode(vcpu) &&
 		    ((vmx->nested.msrs.entry_ctls_high & VM_ENTRY_LOAD_BNDCFGS) ||
@@ -2273,21 +2273,21 @@ int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_IA32_UMWAIT_CONTROL:
 		if (!msr_info->host_initiated && !vmx_has_waitpkg(vmx))
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		/* The reserved bit 1 and non-32 bit [63:32] should be zero */
 		if (data & (BIT_ULL(1) | GENMASK_ULL(63, 32)))
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		vmx->msr_ia32_umwait_control = data;
 		break;
 	case MSR_IA32_SPEC_CTRL:
 		if (!msr_info->host_initiated &&
 		    !guest_has_spec_ctrl_msr(vcpu))
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		if (kvm_spec_ctrl_test_value(data))
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		vmx->spec_ctrl = data;
 		if (!data)
@@ -2312,9 +2312,9 @@ int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_TSX_CTRL:
 		if (!msr_info->host_initiated &&
 		    !(vcpu->arch.arch_capabilities & ARCH_CAP_TSX_CTRL_MSR))
-			return 1;
+			return KVM_MSR_RET_ERR;
 		if (data & ~(TSX_CTRL_RTM_DISABLE | TSX_CTRL_CPUID_CLEAR))
-			return 1;
+			return KVM_MSR_RET_ERR;
 		goto find_uret_msr;
 	case MSR_IA32_CR_PAT:
 		ret = kvm_set_msr_common(vcpu, msr_info);
@@ -2333,12 +2333,12 @@ int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		     !(to_vmx(vcpu)->msr_ia32_feature_control &
 		       FEAT_CTL_LMCE_ENABLED)) ||
 		    (data & ~MCG_EXT_CTL_LMCE_EN))
-			return 1;
+			return KVM_MSR_RET_ERR;
 		vcpu->arch.mcg_ext_ctl = data;
 		break;
 	case MSR_IA32_FEAT_CTL:
 		if (!is_vmx_feature_control_msr_valid(vmx, msr_info))
-			return 1;
+			return KVM_MSR_RET_ERR;
 
 		vmx->msr_ia32_feature_control = data;
 		if (msr_info->host_initiated && data == 0)
@@ -2363,70 +2363,70 @@ int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		    (!guest_cpu_cap_has(vcpu, X86_FEATURE_SGX_LC) ||
 		    ((vmx->msr_ia32_feature_control & FEAT_CTL_LOCKED) &&
 		    !(vmx->msr_ia32_feature_control & FEAT_CTL_SGX_LC_ENABLED))))
-			return 1;
+			return KVM_MSR_RET_ERR;
 		vmx->msr_ia32_sgxlepubkeyhash
 			[msr_index - MSR_IA32_SGXLEPUBKEYHASH0] = data;
 		break;
 	case KVM_FIRST_EMULATED_VMX_MSR ... KVM_LAST_EMULATED_VMX_MSR:
 		if (!msr_info->host_initiated)
-			return 1; /* they are read-only */
+			return KVM_MSR_RET_ERR; /* they are read-only */
 		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_VMX))
-			return 1;
+			return KVM_MSR_RET_ERR;
 		return vmx_set_vmx_msr(vcpu, msr_index, data);
 	case MSR_IA32_RTIT_CTL:
 		if (!vmx_pt_mode_is_host_guest() ||
 			vmx_rtit_ctl_check(vcpu, data) ||
 			vmx->nested.vmxon)
-			return 1;
+			return KVM_MSR_RET_ERR;
 		vmcs_write64(GUEST_IA32_RTIT_CTL, data);
 		vmx->pt_desc.guest.ctl = data;
 		pt_update_intercept_for_msr(vcpu);
 		break;
 	case MSR_IA32_RTIT_STATUS:
 		if (!pt_can_write_msr(vmx))
-			return 1;
+			return KVM_MSR_RET_ERR;
 		if (data & MSR_IA32_RTIT_STATUS_MASK)
-			return 1;
+			return KVM_MSR_RET_ERR;
 		vmx->pt_desc.guest.status = data;
 		break;
 	case MSR_IA32_RTIT_CR3_MATCH:
 		if (!pt_can_write_msr(vmx))
-			return 1;
+			return KVM_MSR_RET_ERR;
 		if (!intel_pt_validate_cap(vmx->pt_desc.caps,
 					   PT_CAP_cr3_filtering))
-			return 1;
+			return KVM_MSR_RET_ERR;
 		vmx->pt_desc.guest.cr3_match = data;
 		break;
 	case MSR_IA32_RTIT_OUTPUT_BASE:
 		if (!pt_can_write_msr(vmx))
-			return 1;
+			return KVM_MSR_RET_ERR;
 		if (!intel_pt_validate_cap(vmx->pt_desc.caps,
 					   PT_CAP_topa_output) &&
 		    !intel_pt_validate_cap(vmx->pt_desc.caps,
 					   PT_CAP_single_range_output))
-			return 1;
+			return KVM_MSR_RET_ERR;
 		if (!pt_output_base_valid(vcpu, data))
-			return 1;
+			return KVM_MSR_RET_ERR;
 		vmx->pt_desc.guest.output_base = data;
 		break;
 	case MSR_IA32_RTIT_OUTPUT_MASK:
 		if (!pt_can_write_msr(vmx))
-			return 1;
+			return KVM_MSR_RET_ERR;
 		if (!intel_pt_validate_cap(vmx->pt_desc.caps,
 					   PT_CAP_topa_output) &&
 		    !intel_pt_validate_cap(vmx->pt_desc.caps,
 					   PT_CAP_single_range_output))
-			return 1;
+			return KVM_MSR_RET_ERR;
 		vmx->pt_desc.guest.output_mask = data;
 		break;
 	case MSR_IA32_RTIT_ADDR0_A ... MSR_IA32_RTIT_ADDR3_B:
 		if (!pt_can_write_msr(vmx))
-			return 1;
+			return KVM_MSR_RET_ERR;
 		index = msr_info->index - MSR_IA32_RTIT_ADDR0_A;
 		if (index >= 2 * vmx->pt_desc.num_address_ranges)
-			return 1;
+			return KVM_MSR_RET_ERR;
 		if (is_noncanonical_msr_address(data, vcpu))
-			return 1;
+			return KVM_MSR_RET_ERR;
 		if (index % 2)
 			vmx->pt_desc.guest.addr_b[index / 2] = data;
 		else
@@ -2445,20 +2445,20 @@ int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (data & PERF_CAP_LBR_FMT) {
 			if ((data & PERF_CAP_LBR_FMT) !=
 			    (kvm_caps.supported_perf_cap & PERF_CAP_LBR_FMT))
-				return 1;
+				return KVM_MSR_RET_ERR;
 			if (!cpuid_model_is_consistent(vcpu))
-				return 1;
+				return KVM_MSR_RET_ERR;
 		}
 		if (data & PERF_CAP_PEBS_FORMAT) {
 			if ((data & PERF_CAP_PEBS_MASK) !=
 			    (kvm_caps.supported_perf_cap & PERF_CAP_PEBS_MASK))
-				return 1;
+				return KVM_MSR_RET_ERR;
 			if (!guest_cpu_cap_has(vcpu, X86_FEATURE_DS))
-				return 1;
+				return KVM_MSR_RET_ERR;
 			if (!guest_cpu_cap_has(vcpu, X86_FEATURE_DTES64))
-				return 1;
+				return KVM_MSR_RET_ERR;
 			if (!cpuid_model_is_consistent(vcpu))
-				return 1;
+				return KVM_MSR_RET_ERR;
 		}
 		ret = kvm_set_msr_common(vcpu, msr_info);
 		break;
-- 
2.51.0


