Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43D6F76E1BD
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 09:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234074AbjHCHhT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 03:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232135AbjHCHgI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 03:36:08 -0400
Received: from mgamail.intel.com (unknown [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2CED49DC;
        Thu,  3 Aug 2023 00:32:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691047939; x=1722583939;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OgSkvhBH4iL29jcbWkPSDYBp4zt8Yn9ghWhyMH+JnNE=;
  b=D7JBWkxJWfiHjzleKPkEXKfva5AytdY006lVXgY19cLJw3hWiot6V+s2
   3XPusnU8aLM9Ejsk2de3hd0Cz0HJ3oIRM/tuBEzPr6ZXrmhzN/9HYCxJt
   anKl7M02czcLjebQz+R8wC67OPH3QI0aysonOoRrGGqHl4SpocqWtuUs9
   NiLBuDRHiBos6tNeBObypjn0TGg1VoDR2lhDRbKLS4MRub2/wqV6u17hN
   RprRV81L6k69/mNqC5tVyMuGtXesPGLNuNnWvyWYgvppMohLcQBcrLZQR
   jUUo5G60jO939lAQOjn4YQ9vYaovsQV0ebq/j9bKt89o2FiNQHaL12+WC
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="354708132"
X-IronPort-AV: E=Sophos;i="6.01,251,1684825200"; 
   d="scan'208";a="354708132"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 00:32:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="794888499"
X-IronPort-AV: E=Sophos;i="6.01,251,1684825200"; 
   d="scan'208";a="794888499"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 00:32:17 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        john.allen@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rick.p.edgecombe@intel.com, chao.gao@intel.com,
        binbin.wu@linux.intel.com, weijiang.yang@intel.com
Subject: [PATCH v5 11/19] KVM:VMX: Emulate read and write to CET MSRs
Date:   Thu,  3 Aug 2023 00:27:24 -0400
Message-Id: <20230803042732.88515-12-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230803042732.88515-1-weijiang.yang@intel.com>
References: <20230803042732.88515-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add emulation interface for CET MSR read and write.
The emulation code is split into common part and vendor specific
part, the former resides in x86.c to benefic different x86 CPU
vendors, the latter for VMX is implemented in this patch.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/vmx/vmx.c |  27 +++++++++++
 arch/x86/kvm/x86.c     | 104 +++++++++++++++++++++++++++++++++++++----
 arch/x86/kvm/x86.h     |  18 +++++++
 3 files changed, 141 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6aa76124e81e..ccf750e79608 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2095,6 +2095,18 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		else
 			msr_info->data = vmx->pt_desc.guest.addr_a[index / 2];
 		break;
+	case MSR_IA32_S_CET:
+	case MSR_KVM_GUEST_SSP:
+	case MSR_IA32_INT_SSP_TAB:
+		if (kvm_get_msr_common(vcpu, msr_info))
+			return 1;
+		if (msr_info->index == MSR_KVM_GUEST_SSP)
+			msr_info->data = vmcs_readl(GUEST_SSP);
+		else if (msr_info->index == MSR_IA32_S_CET)
+			msr_info->data = vmcs_readl(GUEST_S_CET);
+		else if (msr_info->index == MSR_IA32_INT_SSP_TAB)
+			msr_info->data = vmcs_readl(GUEST_INTR_SSP_TABLE);
+		break;
 	case MSR_IA32_DEBUGCTLMSR:
 		msr_info->data = vmcs_read64(GUEST_IA32_DEBUGCTL);
 		break;
@@ -2404,6 +2416,18 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		else
 			vmx->pt_desc.guest.addr_a[index / 2] = data;
 		break;
+	case MSR_IA32_S_CET:
+	case MSR_KVM_GUEST_SSP:
+	case MSR_IA32_INT_SSP_TAB:
+		if (kvm_set_msr_common(vcpu, msr_info))
+			return 1;
+		if (msr_index == MSR_KVM_GUEST_SSP)
+			vmcs_writel(GUEST_SSP, data);
+		else if (msr_index == MSR_IA32_S_CET)
+			vmcs_writel(GUEST_S_CET, data);
+		else if (msr_index == MSR_IA32_INT_SSP_TAB)
+			vmcs_writel(GUEST_INTR_SSP_TABLE, data);
+		break;
 	case MSR_IA32_PERF_CAPABILITIES:
 		if (data && !vcpu_to_pmu(vcpu)->version)
 			return 1;
@@ -4864,6 +4888,9 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 		vmcs_write64(GUEST_BNDCFGS, 0);
 
 	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, 0);  /* 22.2.1 */
+	vmcs_writel(GUEST_SSP, 0);
+	vmcs_writel(GUEST_S_CET, 0);
+	vmcs_writel(GUEST_INTR_SSP_TABLE, 0);
 
 	kvm_make_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5b63441fd2d2..98f3ff6078e6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3627,6 +3627,39 @@ static bool kvm_is_msr_to_save(u32 msr_index)
 	return false;
 }
 
+static inline bool is_shadow_stack_msr(u32 msr)
+{
+	return msr == MSR_IA32_PL0_SSP ||
+		msr == MSR_IA32_PL1_SSP ||
+		msr == MSR_IA32_PL2_SSP ||
+		msr == MSR_IA32_PL3_SSP ||
+		msr == MSR_IA32_INT_SSP_TAB ||
+		msr == MSR_KVM_GUEST_SSP;
+}
+
+static bool kvm_cet_is_msr_accessible(struct kvm_vcpu *vcpu,
+				      struct msr_data *msr)
+{
+	if (is_shadow_stack_msr(msr->index)) {
+		if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK))
+			return false;
+
+		if (msr->index == MSR_KVM_GUEST_SSP)
+			return msr->host_initiated;
+
+		return msr->host_initiated ||
+			guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
+	}
+
+	if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
+	    !kvm_cpu_cap_has(X86_FEATURE_IBT))
+		return false;
+
+	return msr->host_initiated ||
+		guest_cpuid_has(vcpu, X86_FEATURE_IBT) ||
+		guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
+}
+
 int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	u32 msr = msr_info->index;
@@ -3981,6 +4014,45 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		vcpu->arch.guest_fpu.xfd_err = data;
 		break;
 #endif
+#define CET_EXCLUSIVE_BITS		(CET_SUPPRESS | CET_WAIT_ENDBR)
+#define CET_CTRL_RESERVED_BITS		GENMASK(9, 6)
+#define CET_SHSTK_MASK_BITS		GENMASK(1, 0)
+#define CET_IBT_MASK_BITS		(GENMASK_ULL(5, 2) | \
+					 GENMASK_ULL(63, 10))
+#define CET_LEG_BITMAP_BASE(data)	((data) >> 12)
+	case MSR_IA32_U_CET:
+	case MSR_IA32_S_CET:
+		if (!kvm_cet_is_msr_accessible(vcpu, msr_info))
+			return 1;
+		if (!!(data & CET_CTRL_RESERVED_BITS))
+			return 1;
+		if (!guest_can_use(vcpu, X86_FEATURE_SHSTK) &&
+		    (data & CET_SHSTK_MASK_BITS))
+			return 1;
+		if (!guest_can_use(vcpu, X86_FEATURE_IBT) &&
+		    (data & CET_IBT_MASK_BITS))
+			return 1;
+		if (!IS_ALIGNED(CET_LEG_BITMAP_BASE(data), 4) ||
+		    (data & CET_EXCLUSIVE_BITS) == CET_EXCLUSIVE_BITS)
+			return 1;
+		if (msr == MSR_IA32_U_CET)
+			kvm_set_xsave_msr(msr_info);
+		break;
+	case MSR_KVM_GUEST_SSP:
+	case MSR_IA32_PL0_SSP ... MSR_IA32_INT_SSP_TAB:
+		if (!kvm_cet_is_msr_accessible(vcpu, msr_info))
+			return 1;
+		if (is_noncanonical_address(data, vcpu))
+			return 1;
+		if (!IS_ALIGNED(data, 4))
+			return 1;
+		if (msr == MSR_IA32_PL0_SSP || msr == MSR_IA32_PL1_SSP ||
+		    msr == MSR_IA32_PL2_SSP) {
+			vcpu->arch.cet_s_ssp[msr - MSR_IA32_PL0_SSP] = data;
+		} else if (msr == MSR_IA32_PL3_SSP) {
+			kvm_set_xsave_msr(msr_info);
+		}
+		break;
 	default:
 		if (kvm_pmu_is_valid_msr(vcpu, msr))
 			return kvm_pmu_set_msr(vcpu, msr_info);
@@ -4051,7 +4123,9 @@ static int get_msr_mce(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host)
 
 int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
-	switch (msr_info->index) {
+	u32 msr = msr_info->index;
+
+	switch (msr) {
 	case MSR_IA32_PLATFORM_ID:
 	case MSR_IA32_EBL_CR_POWERON:
 	case MSR_IA32_LASTBRANCHFROMIP:
@@ -4086,7 +4160,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_K7_PERFCTR0 ... MSR_K7_PERFCTR3:
 	case MSR_P6_PERFCTR0 ... MSR_P6_PERFCTR1:
 	case MSR_P6_EVNTSEL0 ... MSR_P6_EVNTSEL1:
-		if (kvm_pmu_is_valid_msr(vcpu, msr_info->index))
+		if (kvm_pmu_is_valid_msr(vcpu, msr))
 			return kvm_pmu_get_msr(vcpu, msr_info);
 		msr_info->data = 0;
 		break;
@@ -4137,7 +4211,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_MTRRcap:
 	case MTRRphysBase_MSR(0) ... MSR_MTRRfix4K_F8000:
 	case MSR_MTRRdefType:
-		return kvm_mtrr_get_msr(vcpu, msr_info->index, &msr_info->data);
+		return kvm_mtrr_get_msr(vcpu, msr, &msr_info->data);
 	case 0xcd: /* fsb frequency */
 		msr_info->data = 3;
 		break;
@@ -4159,7 +4233,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		msr_info->data = kvm_get_apic_base(vcpu);
 		break;
 	case APIC_BASE_MSR ... APIC_BASE_MSR + 0xff:
-		return kvm_x2apic_msr_read(vcpu, msr_info->index, &msr_info->data);
+		return kvm_x2apic_msr_read(vcpu, msr, &msr_info->data);
 	case MSR_IA32_TSC_DEADLINE:
 		msr_info->data = kvm_get_lapic_tscdeadline_msr(vcpu);
 		break;
@@ -4253,7 +4327,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_MCG_STATUS:
 	case MSR_IA32_MC0_CTL ... MSR_IA32_MCx_CTL(KVM_MAX_MCE_BANKS) - 1:
 	case MSR_IA32_MC0_CTL2 ... MSR_IA32_MCx_CTL2(KVM_MAX_MCE_BANKS) - 1:
-		return get_msr_mce(vcpu, msr_info->index, &msr_info->data,
+		return get_msr_mce(vcpu, msr, &msr_info->data,
 				   msr_info->host_initiated);
 	case MSR_IA32_XSS:
 		if (!msr_info->host_initiated &&
@@ -4284,7 +4358,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case HV_X64_MSR_TSC_EMULATION_STATUS:
 	case HV_X64_MSR_TSC_INVARIANT_CONTROL:
 		return kvm_hv_get_msr_common(vcpu,
-					     msr_info->index, &msr_info->data,
+					     msr, &msr_info->data,
 					     msr_info->host_initiated);
 	case MSR_IA32_BBL_CR_CTL3:
 		/* This legacy MSR exists but isn't fully documented in current
@@ -4337,8 +4411,22 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		msr_info->data = vcpu->arch.guest_fpu.xfd_err;
 		break;
 #endif
+	case MSR_IA32_U_CET:
+	case MSR_IA32_S_CET:
+	case MSR_KVM_GUEST_SSP:
+	case MSR_IA32_PL0_SSP ... MSR_IA32_INT_SSP_TAB:
+		if (!kvm_cet_is_msr_accessible(vcpu, msr_info))
+			return 1;
+		if (msr == MSR_IA32_PL0_SSP || msr == MSR_IA32_PL1_SSP ||
+		    msr == MSR_IA32_PL2_SSP) {
+			msr_info->data =
+				vcpu->arch.cet_s_ssp[msr - MSR_IA32_PL0_SSP];
+		} else if (msr == MSR_IA32_U_CET || msr == MSR_IA32_PL3_SSP) {
+			kvm_get_xsave_msr(msr_info);
+		}
+		break;
 	default:
-		if (kvm_pmu_is_valid_msr(vcpu, msr_info->index))
+		if (kvm_pmu_is_valid_msr(vcpu, msr))
 			return kvm_pmu_get_msr(vcpu, msr_info);
 
 		/*
@@ -4346,7 +4434,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		 * to-be-saved, even if an MSR isn't fully supported.
 		 */
 		if (msr_info->host_initiated &&
-		    kvm_is_msr_to_save(msr_info->index)) {
+		    kvm_is_msr_to_save(msr)) {
 			msr_info->data = 0;
 			break;
 		}
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index c69fc027f5ec..3b79d6db2f83 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -552,4 +552,22 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
 			 unsigned int port, void *data,  unsigned int count,
 			 int in);
 
+/*
+ * Guest xstate MSRs have been loaded in __msr_io(), disable preemption before
+ * access the MSRs to avoid MSR content corruption.
+ */
+static inline void kvm_get_xsave_msr(struct msr_data *msr_info)
+{
+	kvm_fpu_get();
+	rdmsrl(msr_info->index, msr_info->data);
+	kvm_fpu_put();
+}
+
+static inline void kvm_set_xsave_msr(struct msr_data *msr_info)
+{
+	kvm_fpu_get();
+	wrmsrl(msr_info->index, msr_info->data);
+	kvm_fpu_put();
+}
+
 #endif
-- 
2.27.0

