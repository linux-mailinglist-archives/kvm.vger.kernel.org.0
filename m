Return-Path: <kvm+bounces-6139-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B7F0A82BE13
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 11:06:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1D892B22E43
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 10:06:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0A4D5D755;
	Fri, 12 Jan 2024 10:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i/AS8hZB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A690E57877;
	Fri, 12 Jan 2024 10:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705053987; x=1736589987;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=22XIiAOoXuioZQ/vLkULlEp+icB2/uQtV3+EwoPaODo=;
  b=i/AS8hZBlz0EYIzZJt+uUd6GvutRKv1JXAxeOe/wrJgPqxi4J3TBQHxw
   7DXcy+RRigaCYidlV7kSo4h3tUtaCmp4Wb8aYGrKAEaRJqhh9eDzeVmg3
   fp8Nd6VzChtZYW2QMq3yM82gOOs3KwDeiq/eO8QQmwFtRS0FKgBWJzSjK
   FT8twV5pqkLau3Dgln495Z9YTu4egn/oA7gDsDAKRGvEy5VJdmryJ6LBu
   39AwV+PJoOud37Ju1zxieMYiaZYf184tRtPoR6ORnhy+tfT+SOrkobgyw
   VhSWe3CtoRLGkfiOEgE7Z2lHXGglr0JuiEk/VQsu4GhTDPVg0MBxrjUbH
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10950"; a="463418046"
X-IronPort-AV: E=Sophos;i="6.04,189,1695711600"; 
   d="scan'208";a="463418046"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2024 02:06:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10950"; a="817025042"
X-IronPort-AV: E=Sophos;i="6.04,189,1695711600"; 
   d="scan'208";a="817025042"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by orsmga001.jf.intel.com with ESMTP; 12 Jan 2024 02:06:26 -0800
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
Subject: [PATCH v4 1/2] KVM: VMX: Cleanup VMX basic information defines and usages
Date: Fri, 12 Jan 2024 01:34:48 -0800
Message-ID: <20240112093449.88583-1-xin3.li@intel.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Define VMX basic information fields with BIT_ULL()/GENMASK_ULL(), and
replace hardcoded VMX basic numbers with these field macros.

Per Sean's ask, save the full/raw value of MSR_IA32_VMX_BASIC in the
global vmcs_config as type u64 to get rid of the hi/lo crud, and then
use VMX_BASIC helpers to extract info as needed.

Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---

Changes since v3:
* Remove vmx_basic_vmcs_basic_cap() (Kai Huang).
* Add 2 macros VMX_BASIC_VMCS12_SIZE and VMX_BASIC_MEM_TYPE_WB to
  avoid keeping 2 their bit shift macros (Kai Huang).

Changes since v2:
* Simply save the full/raw value of MSR_IA32_VMX_BASIC in the global
  vmcs_config, and then use the helpers to extract info from it as
  needed (Sean Christopherson).
* Move all VMX_MISC related changes to the second patch (Kai Huang).
* Commonize memory type definitions used in the VMX files, as memory
  types are architectural.

Changes since v1:
* Don't add field shift macros unless it's really needed, extra layer
  of indirect makes it harder to read (Sean Christopherson).
* Add a static_assert() to ensure that VMX_BASIC_FEATURES_MASK doesn't
  overlap with VMX_BASIC_RESERVED_BITS (Sean Christopherson).
* read MSR_IA32_VMX_BASIC into an u64 rather than 2 u32 (Sean
  Christopherson).
* Add 2 new functions for extracting fields from VMX basic (Sean
  Christopherson).
* Drop the tools header update (Sean Christopherson).
* Move VMX basic field macros to arch/x86/include/asm/vmx.h.
---
 arch/x86/include/asm/msr-index.h |  9 ---------
 arch/x86/include/asm/vmx.h       | 15 ++++++++++++--
 arch/x86/kvm/vmx/capabilities.h  |  6 ++----
 arch/x86/kvm/vmx/nested.c        | 34 +++++++++++++++++++++-----------
 arch/x86/kvm/vmx/vmx.c           | 24 ++++++++++------------
 5 files changed, 48 insertions(+), 40 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 1d51e1850ed0..9068cdd6f063 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -1094,15 +1094,6 @@
 #define MSR_IA32_VMX_VMFUNC             0x00000491
 #define MSR_IA32_VMX_PROCBASED_CTLS3	0x00000492
 
-/* VMX_BASIC bits and bitmasks */
-#define VMX_BASIC_VMCS_SIZE_SHIFT	32
-#define VMX_BASIC_TRUE_CTLS		(1ULL << 55)
-#define VMX_BASIC_64		0x0001000000000000LLU
-#define VMX_BASIC_MEM_TYPE_SHIFT	50
-#define VMX_BASIC_MEM_TYPE_MASK	0x003c000000000000LLU
-#define VMX_BASIC_MEM_TYPE_WB	6LLU
-#define VMX_BASIC_INOUT		0x0040000000000000LLU
-
 /* Resctrl MSRs: */
 /* - Intel: */
 #define MSR_IA32_L3_QOS_CFG		0xc81
diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 0e73616b82f3..b8a745ff8c06 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -120,6 +120,14 @@
 
 #define VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR	0x000011ff
 
+/* x86 memory types, explicitly used in VMX only */
+#define MEM_TYPE_WB				0x6ULL
+#define MEM_TYPE_UC				0x0ULL
+
+/* VMX_BASIC bits and bitmasks */
+#define VMX_BASIC_32BIT_PHYS_ADDR_ONLY		BIT_ULL(48)
+#define VMX_BASIC_INOUT				BIT_ULL(54)
+
 #define VMX_MISC_PREEMPTION_TIMER_RATE_MASK	0x0000001f
 #define VMX_MISC_SAVE_EFER_LMA			0x00000020
 #define VMX_MISC_ACTIVITY_HLT			0x00000040
@@ -143,6 +151,11 @@ static inline u32 vmx_basic_vmcs_size(u64 vmx_basic)
 	return (vmx_basic & GENMASK_ULL(44, 32)) >> 32;
 }
 
+static inline u32 vmx_basic_vmcs_mem_type(u64 vmx_basic)
+{
+	return (vmx_basic & GENMASK_ULL(53, 50)) >> 50;
+}
+
 static inline int vmx_misc_preemption_timer_rate(u64 vmx_misc)
 {
 	return vmx_misc & VMX_MISC_PREEMPTION_TIMER_RATE_MASK;
@@ -505,8 +518,6 @@ enum vmcs_field {
 #define VMX_EPTP_PWL_5				0x20ull
 #define VMX_EPTP_AD_ENABLE_BIT			(1ull << 6)
 #define VMX_EPTP_MT_MASK			0x7ull
-#define VMX_EPTP_MT_WB				0x6ull
-#define VMX_EPTP_MT_UC				0x0ull
 #define VMX_EPT_READABLE_MASK			0x1ull
 #define VMX_EPT_WRITABLE_MASK			0x2ull
 #define VMX_EPT_EXECUTABLE_MASK			0x4ull
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 41a4533f9989..86ce8bb96bed 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -54,9 +54,7 @@ struct nested_vmx_msrs {
 };
 
 struct vmcs_config {
-	int size;
-	u32 basic_cap;
-	u32 revision_id;
+	u64 basic;
 	u32 pin_based_exec_ctrl;
 	u32 cpu_based_exec_ctrl;
 	u32 cpu_based_2nd_exec_ctrl;
@@ -76,7 +74,7 @@ extern struct vmx_capability vmx_capability __ro_after_init;
 
 static inline bool cpu_has_vmx_basic_inout(void)
 {
-	return	(((u64)vmcs_config.basic_cap << 32) & VMX_BASIC_INOUT);
+	return	vmcs_config.basic & VMX_BASIC_INOUT;
 }
 
 static inline bool cpu_has_virtual_nmis(void)
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index db0ad1e6ec4b..735f729a22f4 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1226,23 +1226,32 @@ static bool is_bitwise_subset(u64 superset, u64 subset, u64 mask)
 	return (superset | subset) == superset;
 }
 
+#define VMX_BASIC_DUAL_MONITOR_TREATMENT	BIT_ULL(49)
+#define VMX_BASIC_TRUE_CTLS			BIT_ULL(55)
+
+#define VMX_BASIC_FEATURES_MASK			\
+	(VMX_BASIC_DUAL_MONITOR_TREATMENT |	\
+	 VMX_BASIC_INOUT |			\
+	 VMX_BASIC_TRUE_CTLS)
+
+#define VMX_BASIC_RESERVED_BITS			\
+	(GENMASK_ULL(63, 56) | GENMASK_ULL(47, 45) | BIT_ULL(31))
+
 static int vmx_restore_vmx_basic(struct vcpu_vmx *vmx, u64 data)
 {
-	const u64 feature_and_reserved =
-		/* feature (except bit 48; see below) */
-		BIT_ULL(49) | BIT_ULL(54) | BIT_ULL(55) |
-		/* reserved */
-		BIT_ULL(31) | GENMASK_ULL(47, 45) | GENMASK_ULL(63, 56);
 	u64 vmx_basic = vmcs_config.nested.basic;
 
-	if (!is_bitwise_subset(vmx_basic, data, feature_and_reserved))
+	static_assert(!(VMX_BASIC_FEATURES_MASK & VMX_BASIC_RESERVED_BITS));
+
+	if (!is_bitwise_subset(vmx_basic, data,
+			       VMX_BASIC_FEATURES_MASK | VMX_BASIC_RESERVED_BITS))
 		return -EINVAL;
 
 	/*
 	 * KVM does not emulate a version of VMX that constrains physical
 	 * addresses of VMX structures (e.g. VMCS) to 32-bits.
 	 */
-	if (data & BIT_ULL(48))
+	if (data & VMX_BASIC_32BIT_PHYS_ADDR_ONLY)
 		return -EINVAL;
 
 	if (vmx_basic_vmcs_revision_id(vmx_basic) !=
@@ -2726,11 +2735,11 @@ static bool nested_vmx_check_eptp(struct kvm_vcpu *vcpu, u64 new_eptp)
 
 	/* Check for memory type validity */
 	switch (new_eptp & VMX_EPTP_MT_MASK) {
-	case VMX_EPTP_MT_UC:
+	case MEM_TYPE_UC:
 		if (CC(!(vmx->nested.msrs.ept_caps & VMX_EPTP_UC_BIT)))
 			return false;
 		break;
-	case VMX_EPTP_MT_WB:
+	case MEM_TYPE_WB:
 		if (CC(!(vmx->nested.msrs.ept_caps & VMX_EPTP_WB_BIT)))
 			return false;
 		break;
@@ -6994,6 +7003,9 @@ static void nested_vmx_setup_misc_data(struct vmcs_config *vmcs_conf,
 	msrs->misc_high = 0;
 }
 
+#define VMX_BSAIC_VMCS12_SIZE	((u64)VMCS12_SIZE << 32)
+#define VMX_BASIC_MEM_TYPE_WB	(MEM_TYPE_WB << 50);
+
 static void nested_vmx_setup_basic(struct nested_vmx_msrs *msrs)
 {
 	/*
@@ -7005,8 +7017,8 @@ static void nested_vmx_setup_basic(struct nested_vmx_msrs *msrs)
 	msrs->basic =
 		VMCS12_REVISION |
 		VMX_BASIC_TRUE_CTLS |
-		((u64)VMCS12_SIZE << VMX_BASIC_VMCS_SIZE_SHIFT) |
-		(VMX_BASIC_MEM_TYPE_WB << VMX_BASIC_MEM_TYPE_SHIFT);
+		VMX_BSAIC_VMCS12_SIZE |
+		VMX_BASIC_MEM_TYPE_WB;
 
 	if (cpu_has_vmx_basic_inout())
 		msrs->basic |= VMX_BASIC_INOUT;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d21f55f323ea..25d261b7ed74 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2563,13 +2563,13 @@ static u64 adjust_vmx_controls64(u64 ctl_opt, u32 msr)
 static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 			     struct vmx_capability *vmx_cap)
 {
-	u32 vmx_msr_low, vmx_msr_high;
 	u32 _pin_based_exec_control = 0;
 	u32 _cpu_based_exec_control = 0;
 	u32 _cpu_based_2nd_exec_control = 0;
 	u64 _cpu_based_3rd_exec_control = 0;
 	u32 _vmexit_control = 0;
 	u32 _vmentry_control = 0;
+	u64 basic_msr;
 	u64 misc_msr;
 	int i;
 
@@ -2688,29 +2688,25 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 		_vmexit_control &= ~x_ctrl;
 	}
 
-	rdmsr(MSR_IA32_VMX_BASIC, vmx_msr_low, vmx_msr_high);
+	rdmsrl(MSR_IA32_VMX_BASIC, basic_msr);
 
 	/* IA-32 SDM Vol 3B: VMCS size is never greater than 4kB. */
-	if ((vmx_msr_high & 0x1fff) > PAGE_SIZE)
+	if ((vmx_basic_vmcs_size(basic_msr) > PAGE_SIZE))
 		return -EIO;
 
 #ifdef CONFIG_X86_64
 	/* IA-32 SDM Vol 3B: 64-bit CPUs always have VMX_BASIC_MSR[48]==0. */
-	if (vmx_msr_high & (1u<<16))
+	if (basic_msr & VMX_BASIC_32BIT_PHYS_ADDR_ONLY)
 		return -EIO;
 #endif
 
 	/* Require Write-Back (WB) memory type for VMCS accesses. */
-	if (((vmx_msr_high >> 18) & 15) != 6)
+	if (vmx_basic_vmcs_mem_type(basic_msr) != MEM_TYPE_WB)
 		return -EIO;
 
 	rdmsrl(MSR_IA32_VMX_MISC, misc_msr);
 
-	vmcs_conf->size = vmx_msr_high & 0x1fff;
-	vmcs_conf->basic_cap = vmx_msr_high & ~0x1fff;
-
-	vmcs_conf->revision_id = vmx_msr_low;
-
+	vmcs_conf->basic = basic_msr;
 	vmcs_conf->pin_based_exec_ctrl = _pin_based_exec_control;
 	vmcs_conf->cpu_based_exec_ctrl = _cpu_based_exec_control;
 	vmcs_conf->cpu_based_2nd_exec_ctrl = _cpu_based_2nd_exec_control;
@@ -2860,13 +2856,13 @@ struct vmcs *alloc_vmcs_cpu(bool shadow, int cpu, gfp_t flags)
 	if (!pages)
 		return NULL;
 	vmcs = page_address(pages);
-	memset(vmcs, 0, vmcs_config.size);
+	memset(vmcs, 0, vmx_basic_vmcs_size(vmcs_config.basic));
 
 	/* KVM supports Enlightened VMCS v1 only */
 	if (kvm_is_using_evmcs())
 		vmcs->hdr.revision_id = KVM_EVMCS_VERSION;
 	else
-		vmcs->hdr.revision_id = vmcs_config.revision_id;
+		vmcs->hdr.revision_id = vmx_basic_vmcs_revision_id(vmcs_config.basic);
 
 	if (shadow)
 		vmcs->hdr.shadow_vmcs = 1;
@@ -2959,7 +2955,7 @@ static __init int alloc_kvm_area(void)
 		 * physical CPU.
 		 */
 		if (kvm_is_using_evmcs())
-			vmcs->hdr.revision_id = vmcs_config.revision_id;
+			vmcs->hdr.revision_id = vmx_basic_vmcs_revision_id(vmcs_config.basic);
 
 		per_cpu(vmxarea, cpu) = vmcs;
 	}
@@ -3361,7 +3357,7 @@ static int vmx_get_max_ept_level(void)
 
 u64 construct_eptp(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level)
 {
-	u64 eptp = VMX_EPTP_MT_WB;
+	u64 eptp = MEM_TYPE_WB;
 
 	eptp |= (root_level == 5) ? VMX_EPTP_PWL_5 : VMX_EPTP_PWL_4;
 

base-commit: 1c6d984f523f67ecfad1083bb04c55d91977bb15
-- 
2.43.0


