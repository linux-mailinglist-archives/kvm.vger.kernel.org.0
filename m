Return-Path: <kvm+bounces-8134-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6408E84BD7E
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 19:53:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E3C031F27DB5
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 18:53:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E55C414AAD;
	Tue,  6 Feb 2024 18:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q+k1Rhli"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B6A13FF8;
	Tue,  6 Feb 2024 18:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707245568; cv=none; b=iA/mU9W6XoJio2f/TJjHOI8fKxOoSrrRtSdbwDQcqGWVTyM7immarXNKNURJG7Ea5mNMfIyE+pruxtGpyVygdLzPIgszw7OG6VLSB68vsebEMTCFxdf5ou6P3/t7OHUlFW6W9ExMpNh5J00Eead8eySNR4yvpi1KqlMTKl5Iiik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707245568; c=relaxed/simple;
	bh=qIgBkRCVP/SG4nF1pPvW7eVQzCM1kjgU4Qc1O+Jr6fs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LjVTNp/JyDydoqIzpTgdsvl54HRoxYN5eKH6g2/mPD8eCPHIYyy6jUTD7w8cmJdcBjrtYXMJ8Zbl2PVk6C55KfpYVnQs4L42NCxqdeMvFekbvvonNI5EVRJKjI60KQnczqiecDg1G/H8TWUHLxS/A42B35ZrHMP14b2fR0r6YsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q+k1Rhli; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707245566; x=1738781566;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qIgBkRCVP/SG4nF1pPvW7eVQzCM1kjgU4Qc1O+Jr6fs=;
  b=Q+k1RhlidO6B/MPuq5vRY3SqAUAmPKLMx89gi4r9BWtjWnaReRhZlUo3
   5JtJYaQLjQyWrdR7jniMHa5HvfMRq0iM8bZYYGQCBY35N74uTtP2WuhwA
   nnKNgQO17j6d8nOqlps780Qb5FSMYwzoh96mq321np7EysXIss48s+Fue
   GZNvEDUCHmyUkuwCLWDA/TaBNRxArQAB0lfPBPk7deJTAW4O57dKh+Rxv
   XLhE30iK5X/l6lxWVplBP0vWuBJe6B8Cd1vYAIzBkucZS9VXmL3PC7hg5
   eaP2rvwAPRXaxqdFLIi4QcwC1sIA5kAjVoMjxIYDtlQ4k8TEvQueRg+lx
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10976"; a="26265543"
X-IronPort-AV: E=Sophos;i="6.05,248,1701158400"; 
   d="scan'208";a="26265543"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2024 10:52:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,248,1701158400"; 
   d="scan'208";a="1448007"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by orviesa008.jf.intel.com with ESMTP; 06 Feb 2024 10:52:42 -0800
From: Xin Li <xin3.li@intel.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	weijiang.yang@intel.com,
	kai.huang@intel.com
Subject: [PATCH v5 2/2] KVM: VMX: Cleanup VMX misc information defines and usages
Date: Tue,  6 Feb 2024 10:20:32 -0800
Message-ID: <20240206182032.1596-2-xin3.li@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240206182032.1596-1-xin3.li@intel.com>
References: <20240206182032.1596-1-xin3.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Define VMX misc information fields with BIT_ULL()/GENMASK_ULL(), and move
VMX misc field macros to vmx.h if used in multiple files or where they are
used only once.

Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/include/asm/msr-index.h |  5 -----
 arch/x86/include/asm/vmx.h       | 12 +++++------
 arch/x86/kvm/vmx/capabilities.h  |  4 ++--
 arch/x86/kvm/vmx/nested.c        | 34 ++++++++++++++++++++++++--------
 arch/x86/kvm/vmx/nested.h        |  2 +-
 arch/x86/kvm/vmx/vmx.c           |  8 +++-----
 6 files changed, 37 insertions(+), 28 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 63cd50bfdc6d..5b0c6d184b4d 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -1118,11 +1118,6 @@
 #define MSR_IA32_SMBA_BW_BASE		0xc0000280
 #define MSR_IA32_EVT_CFG_BASE		0xc0000400
 
-/* MSR_IA32_VMX_MISC bits */
-#define MSR_IA32_VMX_MISC_INTEL_PT                 (1ULL << 14)
-#define MSR_IA32_VMX_MISC_VMWRITE_SHADOW_RO_FIELDS (1ULL << 29)
-#define MSR_IA32_VMX_MISC_PREEMPTION_TIMER_SCALE   0x1F
-
 /* AMD-V MSRs */
 #define MSR_VM_CR                       0xc0010114
 #define MSR_VM_IGNNE                    0xc0010115
diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 4fa8012980f6..0100731eaaab 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -131,12 +131,10 @@
 #define VMX_BASIC_TRUE_CTLS			BIT_ULL(55)
 
 
-#define VMX_MISC_PREEMPTION_TIMER_RATE_MASK	0x0000001f
-#define VMX_MISC_SAVE_EFER_LMA			0x00000020
-#define VMX_MISC_ACTIVITY_HLT			0x00000040
-#define VMX_MISC_ACTIVITY_WAIT_SIPI		0x00000100
-#define VMX_MISC_ZERO_LEN_INS			0x40000000
-#define VMX_MISC_MSR_LIST_MULTIPLIER		512
+/* VMX_MISC bits and bitmasks */
+#define VMX_MISC_INTEL_PT			BIT_ULL(14)
+#define VMX_MISC_VMWRITE_SHADOW_RO_FIELDS	BIT_ULL(29)
+#define VMX_MISC_ZERO_LEN_INS			BIT_ULL(30)
 
 /* VMFUNC functions */
 #define VMFUNC_CONTROL_BIT(x)	BIT((VMX_FEATURE_##x & 0x1f) - 28)
@@ -161,7 +159,7 @@ static inline u32 vmx_basic_vmcs_mem_type(u64 vmx_basic)
 
 static inline int vmx_misc_preemption_timer_rate(u64 vmx_misc)
 {
-	return vmx_misc & VMX_MISC_PREEMPTION_TIMER_RATE_MASK;
+	return vmx_misc & GENMASK_ULL(4, 0);
 }
 
 static inline int vmx_misc_cr3_count(u64 vmx_misc)
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 86ce8bb96bed..cb6588238f46 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -223,7 +223,7 @@ static inline bool cpu_has_vmx_vmfunc(void)
 static inline bool cpu_has_vmx_shadow_vmcs(void)
 {
 	/* check if the cpu supports writing r/o exit information fields */
-	if (!(vmcs_config.misc & MSR_IA32_VMX_MISC_VMWRITE_SHADOW_RO_FIELDS))
+	if (!(vmcs_config.misc & VMX_MISC_VMWRITE_SHADOW_RO_FIELDS))
 		return false;
 
 	return vmcs_config.cpu_based_2nd_exec_ctrl &
@@ -365,7 +365,7 @@ static inline bool cpu_has_vmx_invvpid_global(void)
 
 static inline bool cpu_has_vmx_intel_pt(void)
 {
-	return (vmcs_config.misc & MSR_IA32_VMX_MISC_INTEL_PT) &&
+	return (vmcs_config.misc & VMX_MISC_INTEL_PT) &&
 		(vmcs_config.cpu_based_2nd_exec_ctrl & SECONDARY_EXEC_PT_USE_GPA) &&
 		(vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_RTIT_CTL);
 }
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 80fea1875948..a9dfda2cbca3 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -917,6 +917,8 @@ static int nested_vmx_store_msr_check(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+#define VMX_MISC_MSR_LIST_MULTIPLIER	512
+
 static u32 nested_vmx_max_atomic_switch_msrs(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -1315,18 +1317,34 @@ vmx_restore_control_msr(struct vcpu_vmx *vmx, u32 msr_index, u64 data)
 	return 0;
 }
 
+#define VMX_MISC_SAVE_EFER_LMA		BIT_ULL(5)
+#define VMX_MISC_ACTIVITY_STATE_BITMAP	GENMASK_ULL(8, 6)
+#define VMX_MISC_ACTIVITY_HLT		BIT_ULL(6)
+#define VMX_MISC_ACTIVITY_WAIT_SIPI	BIT_ULL(8)
+#define VMX_MISC_RDMSR_IN_SMM		BIT_ULL(15)
+#define VMX_MISC_VMXOFF_BLOCK_SMI	BIT_ULL(28)
+
+#define VMX_MISC_FEATURES_MASK			\
+	(VMX_MISC_SAVE_EFER_LMA |		\
+	 VMX_MISC_ACTIVITY_STATE_BITMAP |	\
+	 VMX_MISC_INTEL_PT |			\
+	 VMX_MISC_RDMSR_IN_SMM |		\
+	 VMX_MISC_VMXOFF_BLOCK_SMI |		\
+	 VMX_MISC_VMWRITE_SHADOW_RO_FIELDS |	\
+	 VMX_MISC_ZERO_LEN_INS)
+
+#define VMX_MISC_RESERVED_BITS			\
+	(BIT_ULL(31) | GENMASK_ULL(13, 9))
+
 static int vmx_restore_vmx_misc(struct vcpu_vmx *vmx, u64 data)
 {
-	const u64 feature_and_reserved_bits =
-		/* feature */
-		BIT_ULL(5) | GENMASK_ULL(8, 6) | BIT_ULL(14) | BIT_ULL(15) |
-		BIT_ULL(28) | BIT_ULL(29) | BIT_ULL(30) |
-		/* reserved */
-		GENMASK_ULL(13, 9) | BIT_ULL(31);
 	u64 vmx_misc = vmx_control_msr(vmcs_config.nested.misc_low,
 				       vmcs_config.nested.misc_high);
 
-	if (!is_bitwise_subset(vmx_misc, data, feature_and_reserved_bits))
+	static_assert(!(VMX_MISC_FEATURES_MASK & VMX_MISC_RESERVED_BITS));
+
+	if (!is_bitwise_subset(vmx_misc, data,
+			       VMX_MISC_FEATURES_MASK | VMX_MISC_RESERVED_BITS))
 		return -EINVAL;
 
 	if ((vmx->nested.msrs.pinbased_ctls_high &
@@ -6993,7 +7011,7 @@ static void nested_vmx_setup_misc_data(struct vmcs_config *vmcs_conf,
 {
 	msrs->misc_low = (u32)vmcs_conf->misc & VMX_MISC_SAVE_EFER_LMA;
 	msrs->misc_low |=
-		MSR_IA32_VMX_MISC_VMWRITE_SHADOW_RO_FIELDS |
+		VMX_MISC_VMWRITE_SHADOW_RO_FIELDS |
 		VMX_MISC_EMULATED_PREEMPTION_TIMER_RATE |
 		VMX_MISC_ACTIVITY_HLT |
 		VMX_MISC_ACTIVITY_WAIT_SIPI;
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index cce4e2aa30fb..0782fe599757 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -109,7 +109,7 @@ static inline unsigned nested_cpu_vmx_misc_cr3_count(struct kvm_vcpu *vcpu)
 static inline bool nested_cpu_has_vmwrite_any_field(struct kvm_vcpu *vcpu)
 {
 	return to_vmx(vcpu)->nested.msrs.misc_low &
-		MSR_IA32_VMX_MISC_VMWRITE_SHADOW_RO_FIELDS;
+		VMX_MISC_VMWRITE_SHADOW_RO_FIELDS;
 }
 
 static inline bool nested_cpu_has_zero_length_injection(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index dc163a580f98..96f0d65dea45 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2570,7 +2570,6 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	u32 _vmexit_control = 0;
 	u32 _vmentry_control = 0;
 	u64 basic_msr;
-	u64 misc_msr;
 	int i;
 
 	/*
@@ -2704,8 +2703,6 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	if (vmx_basic_vmcs_mem_type(basic_msr) != MEM_TYPE_WB)
 		return -EIO;
 
-	rdmsrl(MSR_IA32_VMX_MISC, misc_msr);
-
 	vmcs_conf->basic = basic_msr;
 	vmcs_conf->pin_based_exec_ctrl = _pin_based_exec_control;
 	vmcs_conf->cpu_based_exec_ctrl = _cpu_based_exec_control;
@@ -2713,7 +2710,8 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	vmcs_conf->cpu_based_3rd_exec_ctrl = _cpu_based_3rd_exec_control;
 	vmcs_conf->vmexit_ctrl         = _vmexit_control;
 	vmcs_conf->vmentry_ctrl        = _vmentry_control;
-	vmcs_conf->misc	= misc_msr;
+
+	rdmsrl(MSR_IA32_VMX_MISC, vmcs_conf->misc);
 
 #if IS_ENABLED(CONFIG_HYPERV)
 	if (enlightened_vmcs)
@@ -8597,7 +8595,7 @@ static __init int hardware_setup(void)
 		u64 use_timer_freq = 5000ULL * 1000 * 1000;
 
 		cpu_preemption_timer_multi =
-			vmcs_config.misc & VMX_MISC_PREEMPTION_TIMER_RATE_MASK;
+			vmx_misc_preemption_timer_rate(vmcs_config.misc);
 
 		if (tsc_khz)
 			use_timer_freq = (u64)tsc_khz * 1000;
-- 
2.43.0


