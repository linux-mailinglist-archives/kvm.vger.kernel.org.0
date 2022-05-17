Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 617C352A727
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 17:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350447AbiEQPl4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 11:41:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350498AbiEQPli (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 11:41:38 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5575841315;
        Tue, 17 May 2022 08:41:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652802097; x=1684338097;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mfs6BufmMZPwxR3lnXnxoR7klxFLkQPmervP4SXgrmk=;
  b=fVVn+IndzL2HBVlJYJrrK/+Xn5NxHmLqaXkFPmeg+aRZ1cOBs6mivzVR
   0/5+9iIqhKEbQwPhn4upxGzYDuDQW7gQa03EbACJQ7M1C6yMfZYBBC5se
   RmsczL86udeHdsGG4C0IdWqy0zW2cabxTbbxioeHR70iU5M+amK5PAwCs
   38zD8wXtn6tA9LFWQStnnsQTr76eGp4Q2LkjoibAj4kDrUnCcumksRmzY
   ZzBvfMfVfK+/5U/WL3+DSCJCJRy6RuY+uTjYe5DECxiOlyf9B2Ea/P6Jc
   Wj5RBa9afaHF0bLZyFtdkJj3TvC2rvwPiAJ2SicqEP/HSKk/7H2xIZ5VQ
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10350"; a="357632107"
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="357632107"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 08:41:34 -0700
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="626533579"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 08:41:34 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        like.xu.linux@gmail.com, vkuznets@redhat.com,
        kan.liang@linux.intel.com, wei.w.wang@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>,
        Like Xu <like.xu@linux.intel.com>
Subject: [PATCH v12 08/16] KVM: x86/pmu: Refactor code to support guest Arch LBR
Date:   Tue, 17 May 2022 11:40:52 -0400
Message-Id: <20220517154100.29983-9-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220517154100.29983-1-weijiang.yang@intel.com>
References: <20220517154100.29983-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Take account of Arch LBR when do sanity checks before program
vPMU for guest. Pass through Arch LBR recording MSRs to guest
to gain better performance. Note, Arch LBR and Legacy LBR support
are mutually exclusive, i.e., they're not both available on one
platform.

Co-developed-by: Like Xu <like.xu@linux.intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 50 +++++++++++++++++++++++++-----------
 arch/x86/kvm/vmx/vmx.c       |  3 +++
 2 files changed, 38 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 0e882e97728e..41a9c7fbad45 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -178,25 +178,28 @@ bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu)
 static bool intel_pmu_is_valid_lbr_msr(struct kvm_vcpu *vcpu, u32 index)
 {
 	struct x86_pmu_lbr *records = vcpu_to_lbr_records(vcpu);
-	bool ret = false;
 
 	if (!intel_pmu_lbr_is_enabled(vcpu))
-		return ret;
+		return false;
 
 	if (index == MSR_ARCH_LBR_DEPTH || index == MSR_ARCH_LBR_CTL) {
-		if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
-			ret = guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR);
-		return ret;
+		return kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR) &&
+		       guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR);
 	}
 
-	ret = (index == MSR_LBR_SELECT) || (index == MSR_LBR_TOS) ||
-		(index >= records->from && index < records->from + records->nr) ||
-		(index >= records->to && index < records->to + records->nr);
+	if (!guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR) &&
+	    (index == MSR_LBR_SELECT || index == MSR_LBR_TOS))
+		return true;
 
-	if (!ret && records->info)
-		ret = (index >= records->info && index < records->info + records->nr);
+	if ((index >= records->from && index < records->from + records->nr) ||
+	    (index >= records->to && index < records->to + records->nr))
+		return true;
 
-	return ret;
+	if (records->info && index >= records->info &&
+	    index < records->info + records->nr)
+		return true;
+
+	return false;
 }
 
 static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
@@ -666,10 +669,15 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	nested_vmx_pmu_refresh(vcpu,
 			       intel_is_valid_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL));
 
-	if (cpuid_model_is_consistent(vcpu))
+	if (cpuid_model_is_consistent(vcpu)) {
 		x86_perf_get_lbr(&lbr_desc->records);
-	else
+
+		if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR) &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR))
+			lbr_desc->records.nr = 0;
+	} else {
 		lbr_desc->records.nr = 0;
+	}
 
 	if (lbr_desc->records.nr)
 		bitmap_set(pmu->all_valid_pmc_idx, INTEL_PMC_IDX_FIXED_VLBR, 1);
@@ -802,6 +810,9 @@ static void vmx_update_intercept_for_lbr_msrs(struct kvm_vcpu *vcpu, bool set)
 			vmx_set_intercept_for_msr(vcpu, lbr->info + i, MSR_TYPE_RW, set);
 	}
 
+	if (guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR))
+		return;
+
 	vmx_set_intercept_for_msr(vcpu, MSR_LBR_SELECT, MSR_TYPE_RW, set);
 	vmx_set_intercept_for_msr(vcpu, MSR_LBR_TOS, MSR_TYPE_RW, set);
 }
@@ -842,10 +853,13 @@ void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
+	bool lbr_enable = guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR) ?
+		(vmcs_read64(GUEST_IA32_LBR_CTL) & ARCH_LBR_CTL_LBREN) :
+		(vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR);
 
 	if (!lbr_desc->event) {
 		vmx_disable_lbr_msrs_passthrough(vcpu);
-		if (vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR)
+		if (lbr_enable)
 			goto warn;
 		if (test_bit(INTEL_PMC_IDX_FIXED_VLBR, pmu->pmc_in_use))
 			goto warn;
@@ -862,13 +876,19 @@ void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu)
 	return;
 
 warn:
+	if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
+		wrmsrl(MSR_ARCH_LBR_DEPTH, lbr_desc->records.nr);
 	pr_warn_ratelimited("kvm: vcpu-%d: fail to passthrough LBR.\n",
 		vcpu->vcpu_id);
 }
 
 static void intel_pmu_cleanup(struct kvm_vcpu *vcpu)
 {
-	if (!(vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR))
+	bool lbr_enable = guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR) ?
+		(vmcs_read64(GUEST_IA32_LBR_CTL) & ARCH_LBR_CTL_LBREN) :
+		(vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR);
+
+	if (!lbr_enable)
 		intel_pmu_release_guest_lbr_event(vcpu);
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 60f00598f3c9..fe4bb9b610ae 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -576,6 +576,9 @@ static bool is_valid_passthrough_msr(u32 msr)
 	case MSR_LBR_NHM_TO ... MSR_LBR_NHM_TO + 31:
 	case MSR_LBR_CORE_FROM ... MSR_LBR_CORE_FROM + 8:
 	case MSR_LBR_CORE_TO ... MSR_LBR_CORE_TO + 8:
+	case MSR_ARCH_LBR_FROM_0 ... MSR_ARCH_LBR_FROM_0 + 31:
+	case MSR_ARCH_LBR_TO_0 ... MSR_ARCH_LBR_TO_0 + 31:
+	case MSR_ARCH_LBR_INFO_0 ... MSR_ARCH_LBR_INFO_0 + 31:
 		/* LBR MSRs. These are handled in vmx_update_intercept_for_lbr_msrs() */
 		return true;
 	}
-- 
2.27.0

