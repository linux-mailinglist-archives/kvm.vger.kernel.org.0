Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2080E6EAFA8
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 18:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233268AbjDUQvg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 12:51:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233350AbjDUQvK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 12:51:10 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43C5715601;
        Fri, 21 Apr 2023 09:50:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682095856; x=1713631856;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=s9TExKj18DC/arpm4xWsdM/5QbQRmhV9FlvZ5+5DLbc=;
  b=ld3h8EZzPnDXSI2ifDwxtVeZSf81XHjim2vWhAq6YG+EAqCvkAGV5Mj2
   JUJcaLrlvXHhnrX1GmvQWUHh+6WX857FAcn2YdfxNFDUDViKTCfp5QNW8
   nJQu6O8jTUfoNFjcLIEHiN0QHGdxinbhuRNKXW/GqFrciREtHm4+RiMC1
   wYwJQ+MIsbJI0mYVpXz4XPsTbqN4RfFi9cP0/1anr0H1x+bAIjLMQxo69
   rn9IQPO8hTTIDV9953MiDF3lwP2uLAP1M/tmZrzy2Of3XmT6jbtciVI2o
   S2XAGoZUru/463Lm7PN0qMcp4pOqABrOoZgrGtV6XOP3l0MI0YB63NisG
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10687"; a="344787073"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="344787073"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 09:50:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10687"; a="722817427"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="722817427"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 09:50:44 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        john.allen@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rick.p.edgecombe@intel.com, weijiang.yang@intel.com
Subject: [PATCH v2 21/21] KVM:x86: Support CET supervisor shadow stack MSR access
Date:   Fri, 21 Apr 2023 09:46:15 -0400
Message-Id: <20230421134615.62539-22-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230421134615.62539-1-weijiang.yang@intel.com>
References: <20230421134615.62539-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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
platforms, i.e., VMX always clears CPUID(EAX=07H,ECX=1).EDX.[bit 18].

The main purpose of this patch is to facilitate AMD folks to enable
supervisor shadow stack for their platforms.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/cpuid.h      |  6 +++++
 arch/x86/kvm/vmx/nested.c | 12 +++++++++
 arch/x86/kvm/vmx/vmx.c    | 51 ++++++++++++++++++++++++++++++++++-----
 3 files changed, 63 insertions(+), 6 deletions(-)

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
index 6eab3e452bbb..074b618f1a07 100644
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
@@ -1962,8 +1965,11 @@ static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
 static bool cet_is_msr_accessible(struct kvm_vcpu *vcpu,
 				  struct msr_data *msr)
 {
+	u64 mask;
+
 	if (!kvm_cet_user_supported() &&
-	    !kvm_cpu_cap_has(X86_FEATURE_IBT))
+	    !(kvm_cpu_cap_has(X86_FEATURE_IBT) ||
+	      kvm_cpu_cap_has(X86_FEATURE_SHSTK)))
 		return false;
 
 	if (msr->host_initiated)
@@ -1973,15 +1979,27 @@ static bool cet_is_msr_accessible(struct kvm_vcpu *vcpu,
 	    !guest_cpuid_has(vcpu, X86_FEATURE_IBT))
 		return false;
 
+	if (msr->index == MSR_IA32_U_CET)
+		return true;
+
 	if (msr->index == MSR_IA32_S_CET)
-		return guest_cpuid_has(vcpu, X86_FEATURE_IBT);
+		return guest_cpuid_has(vcpu, X86_FEATURE_IBT) ||
+		       kvm_cet_kernel_shstk_supported();
 
-	if ((msr->index == MSR_IA32_PL3_SSP ||
-	     msr->index == MSR_KVM_GUEST_SSP) &&
+	if (msr->index == MSR_KVM_GUEST_SSP)
+		return guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
+
+	if (msr->index == MSR_IA32_INT_SSP_TAB)
+		return guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) &&
+		       kvm_cet_kernel_shstk_supported();
+
+	if (msr->index == MSR_IA32_PL3_SSP &&
 	    !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK))
 		return false;
 
-	return true;
+	mask = (msr->index == MSR_IA32_PL3_SSP) ? XFEATURE_MASK_CET_USER :
+						  XFEATURE_MASK_CET_KERNEL;
+	return !!(kvm_caps.supported_xss & mask);
 }
 
 /*
@@ -2135,6 +2153,12 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		else
 			kvm_get_xsave_msr(msr_info);
 		break;
+	case MSR_IA32_PL0_SSP ... MSR_IA32_PL2_SSP:
+	case MSR_IA32_INT_SSP_TAB:
+		if (!cet_is_msr_accessible(vcpu, msr_info))
+			return 1;
+		kvm_get_xsave_msr(msr_info);
+		break;
 	case MSR_IA32_DEBUGCTLMSR:
 		msr_info->data = vmcs_read64(GUEST_IA32_DEBUGCTL);
 		break;
@@ -2471,6 +2495,12 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		else
 			kvm_set_xsave_msr(msr_info);
 		break;
+	case MSR_IA32_PL0_SSP ... MSR_IA32_PL2_SSP:
+	case MSR_IA32_INT_SSP_TAB:
+		if (!cet_is_msr_accessible(vcpu, msr_info))
+			return 1;
+		kvm_set_xsave_msr(msr_info);
+		break;
 	case MSR_IA32_PERF_CAPABILITIES:
 		if (data && !vcpu_to_pmu(vcpu)->version)
 			return 1;
@@ -7774,6 +7804,14 @@ static void vmx_update_intercept_for_cet_msr(struct kvm_vcpu *vcpu)
 
 	incpt |= !guest_cpuid_has(vcpu, X86_FEATURE_IBT);
 	vmx_set_intercept_for_msr(vcpu, MSR_IA32_S_CET, MSR_TYPE_RW, incpt);
+
+	incpt = !is_cet_state_supported(vcpu, XFEATURE_MASK_CET_KERNEL);
+	incpt |= !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
+
+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_INT_SSP_TAB, MSR_TYPE_RW, incpt);
+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL0_SSP, MSR_TYPE_RW, incpt);
+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL1_SSP, MSR_TYPE_RW, incpt);
+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL2_SSP, MSR_TYPE_RW, incpt);
 }
 
 static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
@@ -7844,7 +7882,8 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	/* Refresh #PF interception to account for MAXPHYADDR changes. */
 	vmx_update_exception_bitmap(vcpu);
 
-	if (kvm_cet_user_supported() || kvm_cpu_cap_has(X86_FEATURE_IBT))
+	if (kvm_cet_user_supported() || kvm_cpu_cap_has(X86_FEATURE_IBT) ||
+	    kvm_cpu_cap_has(X86_FEATURE_SHSTK))
 		vmx_update_intercept_for_cet_msr(vcpu);
 }
 
-- 
2.27.0

