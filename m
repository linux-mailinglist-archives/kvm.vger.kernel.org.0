Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B08464B85B1
	for <lists+kvm@lfdr.de>; Wed, 16 Feb 2022 11:31:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbiBPK1J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Feb 2022 05:27:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232849AbiBPK1E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Feb 2022 05:27:04 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8DF1210AFA;
        Wed, 16 Feb 2022 02:26:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645007212; x=1676543212;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bLG50OWlg8x+9sP9Tb1iADErNwTwvBlYlKoh5jCbzNY=;
  b=Xsccs67cDZsdXA1+xFhcetNEfIw5oAZQ4MEhz4D//5JqYSlj6k/bvLsf
   N6ATV9lkFg4cPw4EuAVEJ0N4sWhXBb/PpBczzI17C0nenFVV52fORAmse
   0EXRCEUbzXNRUF4U5fz+4NbfJwmhgu5h39cJ0i9c+r01vkYKw6VcpjSu0
   QUT0oZucv3bMPXZRz4On8xlPTgluQkBalJnmBjAk5FpcHfb6Ckwuophr0
   FvyYtFkLRDN1FAgKt1q7j90Yc2oUCOS1AVrVOv3Fl7DEN9Apbc+M26n55
   hoI5gdf5le5eKKBiGXAy/06VDi2UjaABSc46NJRK+u0MSyqwA1QNdplD2
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10259"; a="250312475"
X-IronPort-AV: E=Sophos;i="5.88,373,1635231600"; 
   d="scan'208";a="250312475"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2022 02:26:51 -0800
X-IronPort-AV: E=Sophos;i="5.88,373,1635231600"; 
   d="scan'208";a="498708601"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2022 02:26:50 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        like.xu.linux@gmail.com, vkuznets@redhat.com, wei.w.wang@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>,
        Like Xu <like.xu@linux.intel.com>
Subject: [PATCH v9 09/17] KVM: x86/pmu: Refactor code to support guest Arch LBR
Date:   Tue, 15 Feb 2022 16:25:36 -0500
Message-Id: <20220215212544.51666-10-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220215212544.51666-1-weijiang.yang@intel.com>
References: <20220215212544.51666-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DATE_IN_PAST_12_24,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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
---
 arch/x86/kvm/vmx/pmu_intel.c | 37 +++++++++++++++++++++++++++++-------
 arch/x86/kvm/vmx/vmx.c       |  3 +++
 2 files changed, 33 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index e419a8c1ad0d..3f1ffc928e36 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -170,12 +170,16 @@ static inline struct kvm_pmc *get_fw_gp_pmc(struct kvm_pmu *pmu, u32 msr)
 
 bool intel_pmu_lbr_is_compatible(struct kvm_vcpu *vcpu)
 {
+	if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
+		return guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR);
+
 	/*
 	 * As a first step, a guest could only enable LBR feature if its
 	 * cpu model is the same as the host because the LBR registers
 	 * would be pass-through to the guest and they're model specific.
 	 */
-	return boot_cpu_data.x86_model == guest_cpuid_model(vcpu);
+	return !boot_cpu_has(X86_FEATURE_ARCH_LBR) &&
+		boot_cpu_data.x86_model == guest_cpuid_model(vcpu);
 }
 
 bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu)
@@ -193,12 +197,19 @@ static bool intel_pmu_is_valid_lbr_msr(struct kvm_vcpu *vcpu, u32 index)
 	if (!intel_pmu_lbr_is_enabled(vcpu))
 		return ret;
 
-	ret = (index == MSR_LBR_SELECT) || (index == MSR_LBR_TOS) ||
-		(index >= records->from && index < records->from + records->nr) ||
-		(index >= records->to && index < records->to + records->nr);
+	if (!guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR))
+		ret = (index == MSR_LBR_SELECT) || (index == MSR_LBR_TOS);
+
+	if (!ret) {
+		ret = (index >= records->from &&
+		       index < records->from + records->nr) ||
+		      (index >= records->to &&
+		       index < records->to + records->nr);
+	}
 
 	if (!ret && records->info)
-		ret = (index >= records->info && index < records->info + records->nr);
+		ret = (index >= records->info &&
+		       index < records->info + records->nr);
 
 	return ret;
 }
@@ -738,6 +749,9 @@ static void vmx_update_intercept_for_lbr_msrs(struct kvm_vcpu *vcpu, bool set)
 			vmx_set_intercept_for_msr(vcpu, lbr->info + i, MSR_TYPE_RW, set);
 	}
 
+	if (guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR))
+		return;
+
 	vmx_set_intercept_for_msr(vcpu, MSR_LBR_SELECT, MSR_TYPE_RW, set);
 	vmx_set_intercept_for_msr(vcpu, MSR_LBR_TOS, MSR_TYPE_RW, set);
 }
@@ -778,10 +792,13 @@ void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu)
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
@@ -798,13 +815,19 @@ void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu)
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
index 7b6eb87ff6ad..62188f2ab2d4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -578,6 +578,9 @@ static bool is_valid_passthrough_msr(u32 msr)
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

