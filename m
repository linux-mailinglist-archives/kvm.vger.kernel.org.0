Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFB8F6FEC94
	for <lists+kvm@lfdr.de>; Thu, 11 May 2023 09:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237680AbjEKHPu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 03:15:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237747AbjEKHO6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 03:14:58 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B76F8A26F;
        Thu, 11 May 2023 00:14:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683789259; x=1715325259;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7DRMQNweZsiYd8Xw21ykHz/E/apQV0kcIAhwFqTmNrE=;
  b=UhjyjWKx6oB3S4tj48IHjA1Nxces3KdKjnT3IeSTVS2NpD1WOAw/t2lo
   442OkGFTM0XzYPoh07iSwusOgf5769o6A0/VtrZc/J3eJJR83WPxbHlEn
   ELfB9QysaAlHT+oJMWVFVecdAmXcEPpu4XU5Kbe8pwBV+JVcht3Rj/TOM
   JoDYqGU4yLxLzmZkxAQXUvvk6qLD3ZUffq1VIpk51E+XD3XWs7X1+GHRu
   r/5WhXuMSqmfJuf0KaaR2dk7b0SgJ6ie7R0pa3yPJjQWlblPrMwwqC02H
   bXoJb6LiH+ALwSt2WKyBtuja+9sKVE3Nw82XBqbwHuXbJYMVO+WR2t4r6
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="334896700"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="334896700"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 00:13:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="1029512398"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="1029512398"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 00:13:28 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     peterz@infradead.org, rppt@kernel.org, binbin.wu@linux.intel.com,
        rick.p.edgecombe@intel.com, weijiang.yang@intel.com,
        john.allen@amd.com
Subject: [PATCH v3 21/21] KVM:x86: Support CET supervisor shadow stack MSR access
Date:   Thu, 11 May 2023 00:08:57 -0400
Message-Id: <20230511040857.6094-22-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230511040857.6094-1-weijiang.yang@intel.com>
References: <20230511040857.6094-1-weijiang.yang@intel.com>
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

Add MSR access interfaces for supervisor shadow stack, i.e.,
MSR_IA32_PL{0,1,2} and MSR_IA32_INT_SSP_TAB, meanwhile pass through
them to {L1,L2} guests when {L0,L1} KVM supports supervisor shadow
stack.

Note, currently supervisor shadow stack is not supported on Intel
platforms, i.e., VMX always clears CPUID(EAX=07H,ECX=1):EDX[bit 18].

The main purpose of this patch is to facilitate AMD folks to enable
supervisor shadow stack for their platforms.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/cpuid.h      |  6 ++++++
 arch/x86/kvm/vmx/nested.c | 12 ++++++++++++
 arch/x86/kvm/vmx/vmx.c    | 25 ++++++++++++++++++++++++-
 arch/x86/kvm/x86.c        | 21 ++++++++++++++++++---
 4 files changed, 60 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index b1658c0de847..019a16b25b88 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -232,4 +232,10 @@ static __always_inline bool guest_pv_has(struct kvm_vcpu *vcpu,
 	return vcpu->arch.pv_cpuid.features & (1u << kvm_feature);
 }
 
+static __always_inline bool kvm_cet_kernel_shstk_supported(void)
+{
+	return !IS_ENABLED(CONFIG_KVM_INTEL) &&
+	       kvm_cpu_cap_has(X86_FEATURE_SHSTK);
+}
+
 #endif
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index bf690827bfee..aaaae92dc9f6 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -670,6 +670,18 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
 					 MSR_IA32_PL3_SSP, MSR_TYPE_RW);
 
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
+					 MSR_IA32_INT_SSP_TAB, MSR_TYPE_RW);
+
 	kvm_vcpu_unmap(vcpu, &vmx->nested.msr_bitmap_map, false);
 
 	vmx->nested.force_msr_bitmap_recalc = false;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1d0151f9e575..d70f2e94b187 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -713,6 +713,9 @@ static bool is_valid_passthrough_msr(u32 msr)
 	case MSR_IA32_PL3_SSP:
 	case MSR_IA32_S_CET:
 		return true;
+	case MSR_IA32_PL0_SSP ... MSR_IA32_PL2_SSP:
+	case MSR_IA32_INT_SSP_TAB:
+		return true;
 	}
 
 	r = possible_passthrough_msr_slot(msr) != -ENOENT;
@@ -2101,12 +2104,16 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_S_CET:
 	case MSR_IA32_PL3_SSP:
 	case MSR_KVM_GUEST_SSP:
+	case MSR_IA32_PL0_SSP ... MSR_IA32_PL2_SSP:
+	case MSR_IA32_INT_SSP_TAB:
 		if (!kvm_cet_is_msr_accessible(vcpu, msr_info))
 			return 1;
 		if (msr_info->index == MSR_KVM_GUEST_SSP) {
 			msr_info->data = vmcs_readl(GUEST_SSP);
 		} else if (msr_info->index == MSR_IA32_S_CET) {
 			msr_info->data = vmcs_readl(GUEST_S_CET);
+		} else if (msr_info->index == MSR_IA32_INT_SSP_TAB) {
+			msr_info->data = vmcs_readl(GUEST_INTR_SSP_TABLE);
 		} else {
 			kvm_get_xsave_msr(msr_info);
 		}
@@ -2427,6 +2434,8 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_S_CET:
 	case MSR_IA32_PL3_SSP:
 	case MSR_KVM_GUEST_SSP:
+	case MSR_IA32_PL0_SSP ... MSR_IA32_PL2_SSP:
+	case MSR_IA32_INT_SSP_TAB:
 		if (!kvm_cet_is_msr_accessible(vcpu, msr_info))
 			return 1;
 		if (is_noncanonical_address(data, vcpu))
@@ -2440,6 +2449,8 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			vmcs_writel(GUEST_SSP, data);
 		} else if (msr_index == MSR_IA32_S_CET) {
 			vmcs_writel(GUEST_S_CET, data);
+		} else if (msr_index == MSR_IA32_INT_SSP_TAB) {
+			vmcs_writel(GUEST_INTR_SSP_TABLE, data);
 		} else {
 			kvm_set_xsave_msr(msr_info);
 		}
@@ -7764,6 +7775,17 @@ static void vmx_update_intercept_for_cet_msr(struct kvm_vcpu *vcpu)
 	 */
 	incpt = !guest_cpuid_has(vcpu, X86_FEATURE_IBT);
 	vmx_set_intercept_for_msr(vcpu, MSR_IA32_S_CET, MSR_TYPE_RW, incpt);
+
+	/*
+	 * Supervisor shadow stack is not supported in VMX now, intercept all
+	 * related MSRs.
+	 */
+	incpt = !kvm_cet_kernel_shstk_supported();
+
+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_INT_SSP_TAB, MSR_TYPE_RW, incpt);
+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL0_SSP, MSR_TYPE_RW, incpt);
+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL1_SSP, MSR_TYPE_RW, incpt);
+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL2_SSP, MSR_TYPE_RW, incpt);
 }
 
 static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
@@ -7834,7 +7856,8 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	/* Refresh #PF interception to account for MAXPHYADDR changes. */
 	vmx_update_exception_bitmap(vcpu);
 
-	if (kvm_cet_user_supported() || kvm_cpu_cap_has(X86_FEATURE_IBT))
+	if (kvm_cet_user_supported() || kvm_cpu_cap_has(X86_FEATURE_IBT) ||
+	    kvm_cpu_cap_has(X86_FEATURE_SHSTK))
 		vmx_update_intercept_for_cet_msr(vcpu);
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b450361b94ef..a9ab01293420 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1472,6 +1472,8 @@ static const u32 msrs_to_save_base[] = {
 	MSR_IA32_XSS,
 	MSR_IA32_U_CET, MSR_IA32_PL3_SSP, MSR_KVM_GUEST_SSP,
 	MSR_IA32_S_CET,
+	MSR_IA32_PL0_SSP, MSR_IA32_PL1_SSP, MSR_IA32_PL2_SSP,
+	MSR_IA32_INT_SSP_TAB,
 };
 
 static const u32 msrs_to_save_pmu[] = {
@@ -13653,8 +13655,11 @@ EXPORT_SYMBOL_GPL(kvm_sev_es_string_io);
 
 bool kvm_cet_is_msr_accessible(struct kvm_vcpu *vcpu, struct msr_data *msr)
 {
+	u64 mask;
+
 	if (!kvm_cet_user_supported() &&
-	    !kvm_cpu_cap_has(X86_FEATURE_IBT))
+	    !(kvm_cpu_cap_has(X86_FEATURE_IBT) ||
+	      kvm_cpu_cap_has(X86_FEATURE_SHSTK)))
 		return false;
 
 	if (msr->host_initiated)
@@ -13668,14 +13673,24 @@ bool kvm_cet_is_msr_accessible(struct kvm_vcpu *vcpu, struct msr_data *msr)
 	if (msr->index == MSR_KVM_GUEST_SSP)
 		return false;
 
+	if (msr->index == MSR_IA32_U_CET)
+		return true;
+
 	if (msr->index == MSR_IA32_S_CET)
-		return guest_cpuid_has(vcpu, X86_FEATURE_IBT);
+		return guest_cpuid_has(vcpu, X86_FEATURE_IBT) ||
+		       kvm_cet_kernel_shstk_supported();
+
+	if (msr->index == MSR_IA32_INT_SSP_TAB)
+		return guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) &&
+		       kvm_cet_kernel_shstk_supported();
 
 	if (msr->index == MSR_IA32_PL3_SSP &&
 	    !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK))
 		return false;
 
-	return true;
+	mask = (msr->index == MSR_IA32_PL3_SSP) ? XFEATURE_MASK_CET_USER :
+						  XFEATURE_MASK_CET_KERNEL;
+	return !!(kvm_caps.supported_xss & mask);
 }
 EXPORT_SYMBOL_GPL(kvm_cet_is_msr_accessible);
 
-- 
2.27.0

