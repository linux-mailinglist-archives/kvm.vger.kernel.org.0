Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C837F3F592F
	for <lists+kvm@lfdr.de>; Tue, 24 Aug 2021 09:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235497AbhHXHmD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 03:42:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:33537 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235281AbhHXHls (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 03:41:48 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10085"; a="204453471"
X-IronPort-AV: E=Sophos;i="5.84,346,1620716400"; 
   d="scan'208";a="204453471"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 00:40:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,346,1620716400"; 
   d="scan'208";a="473402126"
Received: from michael-optiplex-9020.sh.intel.com ([10.239.159.182])
  by orsmga008.jf.intel.com with ESMTP; 24 Aug 2021 00:40:53 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        like.xu.linux@gmail.com, vkuznets@redhat.com, wei.w.wang@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v8 06/15] KVM: x86/pmu: Refactor code to support guest Arch LBR
Date:   Tue, 24 Aug 2021 15:56:08 +0800
Message-Id: <1629791777-16430-7-git-send-email-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1629791777-16430-1-git-send-email-weijiang.yang@intel.com>
References: <1629791777-16430-1-git-send-email-weijiang.yang@intel.com>
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
index db055b352de0..62cafe4ff9ad 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -176,12 +176,16 @@ static inline struct kvm_pmc *get_fw_gp_pmc(struct kvm_pmu *pmu, u32 msr)
 
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
@@ -199,12 +203,19 @@ static bool intel_pmu_is_valid_lbr_msr(struct kvm_vcpu *vcpu, u32 index)
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
@@ -743,6 +754,9 @@ static void vmx_update_intercept_for_lbr_msrs(struct kvm_vcpu *vcpu, bool set)
 			vmx_set_intercept_for_msr(vcpu, lbr->info + i, MSR_TYPE_RW, set);
 	}
 
+	if (guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR))
+		return;
+
 	vmx_set_intercept_for_msr(vcpu, MSR_LBR_SELECT, MSR_TYPE_RW, set);
 	vmx_set_intercept_for_msr(vcpu, MSR_LBR_TOS, MSR_TYPE_RW, set);
 }
@@ -783,10 +797,13 @@ void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu)
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
@@ -803,13 +820,19 @@ void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu)
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
index e8df44faf900..c15be89d6619 100644
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
2.25.1

