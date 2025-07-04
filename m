Return-Path: <kvm+bounces-51589-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 26DC6AF8CF6
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 10:57:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 78A5F5A16E3
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 08:57:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AE662F5C50;
	Fri,  4 Jul 2025 08:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WOGtrJr+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E1C2F50A5;
	Fri,  4 Jul 2025 08:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751619055; cv=none; b=da+dCQnGrt9jTQw86faPJ3Xwaz+qFcgFzGqxY7OelFXmE6WrMiPWOLxmEWqWhPP9FXZWc6QCvE0zuYXwp0tX2TEQc6rjtzY7mZVxYWQvSuomBAfUcSlBNdHS09Z07xuFDWp1JpJyu4KjQ3mPH3GI10hY0A/9eokPuW6f8RPQIcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751619055; c=relaxed/simple;
	bh=E8DCAkUB4Y91e3GFgak3A4uNwkO+hifgYbr4vZaKB7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YROJnAYOiweUIjU/3W9WAxYsp9ypb1EEdwYdiM9yigHepH6M5Sw/eCRHnTisVpKfAJCLIOKsiEGWKuxctg+Al55ScedQZOfh8mPYlmCqbkISZJS9Irb3ec1HwX7Td2auxS/ALPdx3AQyBcWJutc2d6rC4uoc+sA/2RsjMcvhG9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WOGtrJr+; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751619053; x=1783155053;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=E8DCAkUB4Y91e3GFgak3A4uNwkO+hifgYbr4vZaKB7I=;
  b=WOGtrJr+WlBUPqoDf/sAeIUX0ot9k8GrrBR834zoA71CQJVprReipF5Q
   tZwFRJPgQt9TLb1b+zPCHbISf0oJ+qJOQQL0M1rveGLr2LZH6ayOKimoF
   zYwQrJpPfCEDDogZLr1b07GUa4JXGYCzhMVIgW6G8FN+H79SQvSy/Hqqi
   vCStjbFfp0Ur6MveIA5PaxudjwdU3SCZkRcWmcuKap3dN7FgrL/HR1pfX
   Iqb+SWSmaywe6nAcsdQteJj7w/lnvH3n6rYvjRPJ0nSIDk8kHRvpfX+i8
   1Pu3/3wMROTWR72No55W+RKGyoapjtjzfBW+6lvjvyhdAJ/3Uehz5URf4
   A==;
X-CSE-ConnectionGUID: cDx4UE64TJiIEZPyg2VL1g==
X-CSE-MsgGUID: 6O3W6tWSRvCEBpLEtALQDg==
X-IronPort-AV: E=McAfee;i="6800,10657,11483"; a="79391777"
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="79391777"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2025 01:50:46 -0700
X-CSE-ConnectionGUID: 9mxtooCxQP2pD5+nBOHkUA==
X-CSE-MsgGUID: kj4NGxHEQA2WyijZm8q1+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="154722022"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2025 01:50:46 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	dave.hansen@intel.com
Cc: rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	john.allen@amd.com,
	weijiang.yang@intel.com,
	minipli@grsecurity.net,
	xin@zytor.com,
	Chao Gao <chao.gao@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v11 21/23] KVM: nVMX: Enable CET support for nested guest
Date: Fri,  4 Jul 2025 01:49:52 -0700
Message-ID: <20250704085027.182163-22-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250704085027.182163-1-chao.gao@intel.com>
References: <20250704085027.182163-1-chao.gao@intel.com>
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

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>

---
v11:
Handle GUEST_S_CET as a common field for SHSTK and IBT.
---
 arch/x86/kvm/vmx/nested.c | 80 ++++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/vmcs12.c |  6 +++
 arch/x86/kvm/vmx/vmcs12.h | 14 ++++++-
 arch/x86/kvm/vmx/vmx.c    |  2 +
 arch/x86/kvm/vmx/vmx.h    |  3 ++
 5 files changed, 102 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 683a9cad04df..3e6f7b4fc374 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -715,6 +715,28 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
 					 MSR_IA32_FLUSH_CMD, MSR_TYPE_W);
 
+	/* Pass CET MSRs to nested VM if L0 and L1 are set to pass-through. */
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
+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
+					 MSR_IA32_INT_SSP_TAB, MSR_TYPE_RW);
+
 	kvm_vcpu_unmap(vcpu, &map);
 
 	vmx->nested.force_msr_bitmap_recalc = false;
@@ -2515,6 +2537,30 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct loaded_vmcs *vmcs0
 	}
 }
 
+static inline void cet_vmcs_fields_get(struct kvm_vcpu *vcpu, u64 *ssp,
+				       u64 *s_cet, u64 *ssp_tbl)
+{
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK)) {
+		*ssp = vmcs_readl(GUEST_SSP);
+		*ssp_tbl = vmcs_readl(GUEST_INTR_SSP_TABLE);
+	}
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_IBT) ||
+	    guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK))
+		*s_cet = vmcs_readl(GUEST_S_CET);
+}
+
+static inline void cet_vmcs_fields_set(struct kvm_vcpu *vcpu, u64 ssp,
+				       u64 s_cet, u64 ssp_tbl)
+{
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK)) {
+		vmcs_writel(GUEST_SSP, ssp);
+		vmcs_writel(GUEST_INTR_SSP_TABLE, ssp_tbl);
+	}
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_IBT) ||
+	    guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK))
+		vmcs_writel(GUEST_S_CET, s_cet);
+}
+
 static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 {
 	struct hv_enlightened_vmcs *hv_evmcs = nested_vmx_evmcs(vmx);
@@ -2631,6 +2677,11 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 	vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, vmx->msr_autoload.host.nr);
 	vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, vmx->msr_autoload.guest.nr);
 
+	if (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_CET_STATE)
+		cet_vmcs_fields_set(&vmx->vcpu, vmcs12->guest_ssp,
+				    vmcs12->guest_s_cet,
+				    vmcs12->guest_ssp_tbl);
+
 	set_cr4_guest_host_mask(vmx);
 }
 
@@ -2670,6 +2721,13 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 		kvm_set_dr(vcpu, 7, vcpu->arch.dr7);
 		vmx_guest_debugctl_write(vcpu, vmx->nested.pre_vmenter_debugctl);
 	}
+
+	if (!vmx->nested.nested_run_pending ||
+	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_CET_STATE))
+		cet_vmcs_fields_set(vcpu, vmx->nested.pre_vmenter_ssp,
+				    vmx->nested.pre_vmenter_s_cet,
+				    vmx->nested.pre_vmenter_ssp_tbl);
+
 	if (kvm_mpx_supported() && (!vmx->nested.nested_run_pending ||
 	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS)))
 		vmcs_write64(GUEST_BNDCFGS, vmx->nested.pre_vmenter_bndcfgs);
@@ -3546,6 +3604,12 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 	     !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS)))
 		vmx->nested.pre_vmenter_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
 
+	if (!vmx->nested.nested_run_pending ||
+	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_CET_STATE))
+		cet_vmcs_fields_get(vcpu, &vmx->nested.pre_vmenter_ssp,
+				    &vmx->nested.pre_vmenter_s_cet,
+				    &vmx->nested.pre_vmenter_ssp_tbl);
+
 	/*
 	 * Overwrite vmcs01.GUEST_CR3 with L1's CR3 if EPT is disabled *and*
 	 * nested early checks are disabled.  In the event of a "late" VM-Fail,
@@ -4473,6 +4537,9 @@ static bool is_vmcs12_ext_field(unsigned long field)
 	case GUEST_IDTR_BASE:
 	case GUEST_PENDING_DBG_EXCEPTIONS:
 	case GUEST_BNDCFGS:
+	case GUEST_SSP:
+	case GUEST_S_CET:
+	case GUEST_INTR_SSP_TABLE:
 		return true;
 	default:
 		break;
@@ -4523,6 +4590,10 @@ static void sync_vmcs02_to_vmcs12_rare(struct kvm_vcpu *vcpu,
 	vmcs12->guest_pending_dbg_exceptions =
 		vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS);
 
+	cet_vmcs_fields_get(&vmx->vcpu, &vmcs12->guest_ssp,
+			    &vmcs12->guest_s_cet,
+			    &vmcs12->guest_ssp_tbl);
+
 	vmx->nested.need_sync_vmcs02_to_vmcs12_rare = false;
 }
 
@@ -4754,6 +4825,10 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 	if (vmcs12->vm_exit_controls & VM_EXIT_CLEAR_BNDCFGS)
 		vmcs_write64(GUEST_BNDCFGS, 0);
 
+	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_CET_STATE)
+		cet_vmcs_fields_set(vcpu, vmcs12->host_ssp, vmcs12->host_s_cet,
+				    vmcs12->host_ssp_tbl);
+
 	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PAT) {
 		vmcs_write64(GUEST_IA32_PAT, vmcs12->host_ia32_pat);
 		vcpu->arch.pat = vmcs12->host_ia32_pat;
@@ -7032,7 +7107,7 @@ static void nested_vmx_setup_exit_ctls(struct vmcs_config *vmcs_conf,
 		VM_EXIT_HOST_ADDR_SPACE_SIZE |
 #endif
 		VM_EXIT_LOAD_IA32_PAT | VM_EXIT_SAVE_IA32_PAT |
-		VM_EXIT_CLEAR_BNDCFGS;
+		VM_EXIT_CLEAR_BNDCFGS | VM_EXIT_LOAD_CET_STATE;
 	msrs->exit_ctls_high |=
 		VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR |
 		VM_EXIT_LOAD_IA32_EFER | VM_EXIT_SAVE_IA32_EFER |
@@ -7054,7 +7129,8 @@ static void nested_vmx_setup_entry_ctls(struct vmcs_config *vmcs_conf,
 #ifdef CONFIG_X86_64
 		VM_ENTRY_IA32E_MODE |
 #endif
-		VM_ENTRY_LOAD_IA32_PAT | VM_ENTRY_LOAD_BNDCFGS;
+		VM_ENTRY_LOAD_IA32_PAT | VM_ENTRY_LOAD_BNDCFGS |
+		VM_ENTRY_LOAD_CET_STATE;
 	msrs->entry_ctls_high |=
 		(VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR | VM_ENTRY_LOAD_IA32_EFER |
 		 VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL);
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
index d837876e3726..46188e1a01a7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7703,6 +7703,8 @@ static void nested_vmx_cr_fixed1_bits_update(struct kvm_vcpu *vcpu)
 	cr4_fixed1_update(X86_CR4_PKE,        ecx, feature_bit(PKU));
 	cr4_fixed1_update(X86_CR4_UMIP,       ecx, feature_bit(UMIP));
 	cr4_fixed1_update(X86_CR4_LA57,       ecx, feature_bit(LA57));
+	cr4_fixed1_update(X86_CR4_CET,	      ecx, feature_bit(SHSTK));
+	cr4_fixed1_update(X86_CR4_CET,	      edx, feature_bit(IBT));
 
 	entry = kvm_find_cpuid_entry_index(vcpu, 0x7, 1);
 	cr4_fixed1_update(X86_CR4_LAM_SUP,    eax, feature_bit(LAM));
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index f93062965a7a..c7b037ee1dce 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -181,6 +181,9 @@ struct nested_vmx {
 	 */
 	u64 pre_vmenter_debugctl;
 	u64 pre_vmenter_bndcfgs;
+	u64 pre_vmenter_ssp;
+	u64 pre_vmenter_s_cet;
+	u64 pre_vmenter_ssp_tbl;
 
 	/* to migrate it to L1 if L2 writes to L1's CR8 directly */
 	int l1_tpr_threshold;
-- 
2.47.1


