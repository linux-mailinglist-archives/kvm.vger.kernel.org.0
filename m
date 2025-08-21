Return-Path: <kvm+bounces-55297-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 02CFDB2FAD1
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 15:43:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 586FC189862C
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 13:39:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FA6B343D84;
	Thu, 21 Aug 2025 13:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cC0w0GEn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3C635085A;
	Thu, 21 Aug 2025 13:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755783135; cv=none; b=KNByNxOoBCas2vnrkLi3M+E6P9S5kOCAy6PcabnG5qlErQm8zJCrKqMDrKqhNqU1zw3GMSSGtl1wCLrSg2uGyqs49qvzFXWDsZIs5D1ge3I3k6YZ7fdW9uZHABA9uQR3d73dJ1yQBJ6V1KuTbCPlo4qfHWEWiUMrsadl5rHGYTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755783135; c=relaxed/simple;
	bh=xTaMTVaYM/xoWY6YVEAu9Uw1uwh9ZGOXLj74nM121IM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=im2shhiMIwuVrk2oEK3YwlD1WXPLjuk2LMPWhl8HwC8FeaoIOWBSZSagYJEMQKcjYtnOBrR5wWRJxy3jz79T8DroMIMx+COQ+AUyMcoRAkXj51qAYj0Qjaw0Ckbvk9ufgHBjAcQGFoSkJDSs5b9vxeU7bqvgexxmlwgu6TNZQZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cC0w0GEn; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755783134; x=1787319134;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xTaMTVaYM/xoWY6YVEAu9Uw1uwh9ZGOXLj74nM121IM=;
  b=cC0w0GEn40WpgU1XVOhHav2ygqAc+skxfijXinkb8TPQVCd14LdoThZ0
   8Lr23pVDBURvkI1mve1LDknobDgIB64emjBGnpJzajt5zD+v5At8z/5p6
   sHxm5BfS+Mi3z1v6gTwyu6imi5/m0qhpVnzD7dMB82g5uRte8O+1tPgCN
   unJvZQ92pNHgFo58h4zN6MlF3PslZ0jKgofre6hStHzCsohlP72Knx9P5
   YHnYFzRrPSBz5L3jk9oW9GntcsCyVsrvo6sTfRr4QzT6m/LmB7yO4UN4P
   i0TRSkXtbv2VFv1o2xx3StgnljZCARGiO5NuZTGUSPrWM0fFYsXJwMbJN
   w==;
X-CSE-ConnectionGUID: cbmbGnw2TNCTftDjtP6uiw==
X-CSE-MsgGUID: obZSF7heS5233duGrG494g==
X-IronPort-AV: E=McAfee;i="6800,10657,11529"; a="69446234"
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="69446234"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 06:32:02 -0700
X-CSE-ConnectionGUID: u3v5/HvaTqe4eEahZ6wH1A==
X-CSE-MsgGUID: xIBahJ4CQ2+IUMumVwi7Dg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="199285436"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 06:31:56 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: chao.gao@intel.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	john.allen@amd.com,
	mingo@redhat.com,
	minipli@grsecurity.net,
	mlevitsk@redhat.com,
	pbonzini@redhat.com,
	rick.p.edgecombe@intel.com,
	seanjc@google.com,
	tglx@linutronix.de,
	weijiang.yang@intel.com,
	x86@kernel.org,
	xin@zytor.com
Subject: [PATCH v13 17/21] KVM: nVMX: Prepare for enabling CET support for nested guest
Date: Thu, 21 Aug 2025 06:30:51 -0700
Message-ID: <20250821133132.72322-18-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250821133132.72322-1-chao.gao@intel.com>
References: <20250821133132.72322-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yang Weijiang <weijiang.yang@intel.com>

Set up CET MSRs, related VM_ENTRY/EXIT control bits and fixed CR4 setting
to enable CET for nested VM.

vmcs12 and vmcs02 needs to be synced when L2 exits to L1 or when L1 wants
to resume L2, that way correct CET states can be observed by one another.

Please note that consistency checks regarding CET state during VM-Entry
will be added later to prevent this patch from becoming too large.
Advertising the new CET VM_ENTRY/EXIT control bits are also be deferred
until after the consistency checks are added.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Tested-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: John Allen <john.allen@amd.com>
Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
---
v13:
 - retain CET state if L1 doesn't set VM_EXIT_LOAD_CET_STATE (Xin)
 - don't pass-thru MSR_IA32_INT_SSP_TAB
 - drop inline from local functions
 - rename cet_vmcs_fields_{get,set}() to vmcs_{read,write}_cet_state()
 - split out advertising new CET VM_ENTRY/EXIT control bits.
---
 arch/x86/kvm/vmx/nested.c | 77 +++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmcs12.c |  6 +++
 arch/x86/kvm/vmx/vmcs12.h | 14 ++++++-
 arch/x86/kvm/vmx/vmx.c    |  2 +
 arch/x86/kvm/vmx/vmx.h    |  3 ++
 5 files changed, 101 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 14f9822b611d..51d69f368689 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -721,6 +721,24 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
 					 MSR_IA32_MPERF, MSR_TYPE_R);
 
+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
+					 MSR_IA32_U_CET, MSR_TYPE_RW);
+
+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
+					 MSR_IA32_S_CET, MSR_TYPE_RW);
+
+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
+					 MSR_IA32_PL0_SSP, MSR_TYPE_RW);
+
+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
+					 MSR_IA32_PL1_SSP, MSR_TYPE_RW);
+
+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
+					 MSR_IA32_PL2_SSP, MSR_TYPE_RW);
+
+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
+					 MSR_IA32_PL3_SSP, MSR_TYPE_RW);
+
 	kvm_vcpu_unmap(vcpu, &map);
 
 	vmx->nested.force_msr_bitmap_recalc = false;
@@ -2521,6 +2539,32 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct loaded_vmcs *vmcs0
 	}
 }
 
+static void vmcs_read_cet_state(struct kvm_vcpu *vcpu, u64 *s_cet,
+				u64 *ssp, u64 *ssp_tbl)
+{
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_IBT) ||
+	    guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK))
+		*s_cet = vmcs_readl(GUEST_S_CET);
+
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK)) {
+		*ssp = vmcs_readl(GUEST_SSP);
+		*ssp_tbl = vmcs_readl(GUEST_INTR_SSP_TABLE);
+	}
+}
+
+static void vmcs_write_cet_state(struct kvm_vcpu *vcpu, u64 s_cet,
+				 u64 ssp, u64 ssp_tbl)
+{
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_IBT) ||
+	    guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK))
+		vmcs_writel(GUEST_S_CET, s_cet);
+
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK)) {
+		vmcs_writel(GUEST_SSP, ssp);
+		vmcs_writel(GUEST_INTR_SSP_TABLE, ssp_tbl);
+	}
+}
+
 static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 {
 	struct hv_enlightened_vmcs *hv_evmcs = nested_vmx_evmcs(vmx);
@@ -2637,6 +2681,10 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 	vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, vmx->msr_autoload.host.nr);
 	vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, vmx->msr_autoload.guest.nr);
 
+	if (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_CET_STATE)
+		vmcs_write_cet_state(&vmx->vcpu, vmcs12->guest_s_cet,
+				     vmcs12->guest_ssp, vmcs12->guest_ssp_tbl);
+
 	set_cr4_guest_host_mask(vmx);
 }
 
@@ -2676,6 +2724,13 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 		kvm_set_dr(vcpu, 7, vcpu->arch.dr7);
 		vmx_guest_debugctl_write(vcpu, vmx->nested.pre_vmenter_debugctl);
 	}
+
+	if (!vmx->nested.nested_run_pending ||
+	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_CET_STATE))
+		vmcs_write_cet_state(vcpu, vmx->nested.pre_vmenter_s_cet,
+				     vmx->nested.pre_vmenter_ssp,
+				     vmx->nested.pre_vmenter_ssp_tbl);
+
 	if (kvm_mpx_supported() && (!vmx->nested.nested_run_pending ||
 	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS)))
 		vmcs_write64(GUEST_BNDCFGS, vmx->nested.pre_vmenter_bndcfgs);
@@ -3552,6 +3607,12 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 	     !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS)))
 		vmx->nested.pre_vmenter_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
 
+	if (!vmx->nested.nested_run_pending ||
+	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_CET_STATE))
+		vmcs_read_cet_state(vcpu, &vmx->nested.pre_vmenter_s_cet,
+				    &vmx->nested.pre_vmenter_ssp,
+				    &vmx->nested.pre_vmenter_ssp_tbl);
+
 	/*
 	 * Overwrite vmcs01.GUEST_CR3 with L1's CR3 if EPT is disabled *and*
 	 * nested early checks are disabled.  In the event of a "late" VM-Fail,
@@ -4635,6 +4696,10 @@ static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
 
 	if (vmcs12->vm_exit_controls & VM_EXIT_SAVE_IA32_EFER)
 		vmcs12->guest_ia32_efer = vcpu->arch.efer;
+
+	vmcs_read_cet_state(&vmx->vcpu, &vmcs12->guest_s_cet,
+			    &vmcs12->guest_ssp,
+			    &vmcs12->guest_ssp_tbl);
 }
 
 /*
@@ -4760,6 +4825,18 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 	if (vmcs12->vm_exit_controls & VM_EXIT_CLEAR_BNDCFGS)
 		vmcs_write64(GUEST_BNDCFGS, 0);
 
+	/*
+	 * Load CET state from host state if VM_EXIT_LOAD_CET_STATE is set.
+	 * otherwise CET state should be retained across VM-exit, i.e.,
+	 * guest values should be propagated from vmcs12 to vmcs01.
+	 */
+	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_CET_STATE)
+		vmcs_write_cet_state(vcpu, vmcs12->host_s_cet, vmcs12->host_ssp,
+				     vmcs12->host_ssp_tbl);
+	else
+		vmcs_write_cet_state(vcpu, vmcs12->guest_s_cet, vmcs12->guest_ssp,
+				     vmcs12->guest_ssp_tbl);
+
 	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PAT) {
 		vmcs_write64(GUEST_IA32_PAT, vmcs12->host_ia32_pat);
 		vcpu->arch.pat = vmcs12->host_ia32_pat;
diff --git a/arch/x86/kvm/vmx/vmcs12.c b/arch/x86/kvm/vmx/vmcs12.c
index 106a72c923ca..4233b5ca9461 100644
--- a/arch/x86/kvm/vmx/vmcs12.c
+++ b/arch/x86/kvm/vmx/vmcs12.c
@@ -139,6 +139,9 @@ const unsigned short vmcs12_field_offsets[] = {
 	FIELD(GUEST_PENDING_DBG_EXCEPTIONS, guest_pending_dbg_exceptions),
 	FIELD(GUEST_SYSENTER_ESP, guest_sysenter_esp),
 	FIELD(GUEST_SYSENTER_EIP, guest_sysenter_eip),
+	FIELD(GUEST_S_CET, guest_s_cet),
+	FIELD(GUEST_SSP, guest_ssp),
+	FIELD(GUEST_INTR_SSP_TABLE, guest_ssp_tbl),
 	FIELD(HOST_CR0, host_cr0),
 	FIELD(HOST_CR3, host_cr3),
 	FIELD(HOST_CR4, host_cr4),
@@ -151,5 +154,8 @@ const unsigned short vmcs12_field_offsets[] = {
 	FIELD(HOST_IA32_SYSENTER_EIP, host_ia32_sysenter_eip),
 	FIELD(HOST_RSP, host_rsp),
 	FIELD(HOST_RIP, host_rip),
+	FIELD(HOST_S_CET, host_s_cet),
+	FIELD(HOST_SSP, host_ssp),
+	FIELD(HOST_INTR_SSP_TABLE, host_ssp_tbl),
 };
 const unsigned int nr_vmcs12_fields = ARRAY_SIZE(vmcs12_field_offsets);
diff --git a/arch/x86/kvm/vmx/vmcs12.h b/arch/x86/kvm/vmx/vmcs12.h
index 56fd150a6f24..4ad6b16525b9 100644
--- a/arch/x86/kvm/vmx/vmcs12.h
+++ b/arch/x86/kvm/vmx/vmcs12.h
@@ -117,7 +117,13 @@ struct __packed vmcs12 {
 	natural_width host_ia32_sysenter_eip;
 	natural_width host_rsp;
 	natural_width host_rip;
-	natural_width paddingl[8]; /* room for future expansion */
+	natural_width host_s_cet;
+	natural_width host_ssp;
+	natural_width host_ssp_tbl;
+	natural_width guest_s_cet;
+	natural_width guest_ssp;
+	natural_width guest_ssp_tbl;
+	natural_width paddingl[2]; /* room for future expansion */
 	u32 pin_based_vm_exec_control;
 	u32 cpu_based_vm_exec_control;
 	u32 exception_bitmap;
@@ -294,6 +300,12 @@ static inline void vmx_check_vmcs12_offsets(void)
 	CHECK_OFFSET(host_ia32_sysenter_eip, 656);
 	CHECK_OFFSET(host_rsp, 664);
 	CHECK_OFFSET(host_rip, 672);
+	CHECK_OFFSET(host_s_cet, 680);
+	CHECK_OFFSET(host_ssp, 688);
+	CHECK_OFFSET(host_ssp_tbl, 696);
+	CHECK_OFFSET(guest_s_cet, 704);
+	CHECK_OFFSET(guest_ssp, 712);
+	CHECK_OFFSET(guest_ssp_tbl, 720);
 	CHECK_OFFSET(pin_based_vm_exec_control, 744);
 	CHECK_OFFSET(cpu_based_vm_exec_control, 748);
 	CHECK_OFFSET(exception_bitmap, 752);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 8d2186d6549f..989008f5307e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7749,6 +7749,8 @@ static void nested_vmx_cr_fixed1_bits_update(struct kvm_vcpu *vcpu)
 	cr4_fixed1_update(X86_CR4_PKE,        ecx, feature_bit(PKU));
 	cr4_fixed1_update(X86_CR4_UMIP,       ecx, feature_bit(UMIP));
 	cr4_fixed1_update(X86_CR4_LA57,       ecx, feature_bit(LA57));
+	cr4_fixed1_update(X86_CR4_CET,	      ecx, feature_bit(SHSTK));
+	cr4_fixed1_update(X86_CR4_CET,	      edx, feature_bit(IBT));
 
 	entry = kvm_find_cpuid_entry_index(vcpu, 0x7, 1);
 	cr4_fixed1_update(X86_CR4_LAM_SUP,    eax, feature_bit(LAM));
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 08a9a0075404..ecfdba666465 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -181,6 +181,9 @@ struct nested_vmx {
 	 */
 	u64 pre_vmenter_debugctl;
 	u64 pre_vmenter_bndcfgs;
+	u64 pre_vmenter_s_cet;
+	u64 pre_vmenter_ssp;
+	u64 pre_vmenter_ssp_tbl;
 
 	/* to migrate it to L1 if L2 writes to L1's CR8 directly */
 	int l1_tpr_threshold;
-- 
2.47.3


