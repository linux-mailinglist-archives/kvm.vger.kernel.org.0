Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12E0730DC31
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 15:07:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232486AbhBCOFi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 09:05:38 -0500
Received: from mga06.intel.com ([134.134.136.31]:50302 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232302AbhBCOFf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 09:05:35 -0500
IronPort-SDR: nKgPjW8WSVK43il7hU8YGM4/fohudX1V2RTcadFSaEa4cBfvxaySjesaMsfyAIEA+O62v90kWf
 Ir1W4DhqKTbQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9883"; a="242555104"
X-IronPort-AV: E=Sophos;i="5.79,398,1602572400"; 
   d="scan'208";a="242555104"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 06:03:48 -0800
IronPort-SDR: IdoAe0NWdoJtsMpMomGj4eKqv2iNsccsax1V1CVG3JDMYJ4VtIXTc3kgIckbg1KcWcYwS6zXDT
 yrQHMdtOAc2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,398,1602572400"; 
   d="scan'208";a="371490654"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by fmsmga008.fm.intel.com with ESMTP; 03 Feb 2021 06:03:45 -0800
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/4] KVM: vmx/pmu: Add MSR_ARCH_LBR_DEPTH emulation for Arch LBR
Date:   Wed,  3 Feb 2021 21:57:11 +0800
Message-Id: <20210203135714.318356-2-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210203135714.318356-1-like.xu@linux.intel.com>
References: <20210203135714.318356-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The number of Arch LBR entries available for recording operations
is dictated by the value in MSR_ARCH_LBR_DEPTH.DEPTH. The supported
LBR depth values can be found in CPUID.(EAX=01CH, ECX=0):EAX[7:0]
and for each bit n set in this field, the MSR_ARCH_LBR_DEPTH.DEPTH
value 8*(n+1) is supported.

On a software write to MSR_ARCH_LBR_DEPTH, all LBR entries are reset
to 0. Emulate the reset behavior by introducing lbr_desc->arch_lbr_reset
and sync it to the host MSR_ARCH_LBR_DEPTH msr when the guest LBR
event is ACTIVE and the LBR records msrs are pass-through to the guest.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 43 ++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.h       |  3 +++
 2 files changed, 46 insertions(+)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index d1df618cb7de..b550c4a6ce33 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -220,6 +220,9 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
 		ret = pmu->version > 1;
 		break;
+	case MSR_ARCH_LBR_DEPTH:
+		ret = guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR);
+		break;
 	default:
 		ret = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0) ||
 			get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0) ||
@@ -250,6 +253,7 @@ static inline void intel_pmu_release_guest_lbr_event(struct kvm_vcpu *vcpu)
 	if (lbr_desc->event) {
 		perf_event_release_kernel(lbr_desc->event);
 		lbr_desc->event = NULL;
+		lbr_desc->arch_lbr_reset = false;
 		vcpu_to_pmu(vcpu)->event_count--;
 	}
 }
@@ -348,10 +352,26 @@ static bool intel_pmu_handle_lbr_msrs_access(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+/*
+ * Check if the requested depth values is supported
+ * based on the bits [0:7] of the guest cpuid.1c.eax.
+ */
+static bool arch_lbr_depth_is_valid(struct kvm_vcpu *vcpu, u64 depth)
+{
+	struct kvm_cpuid_entry2 *best;
+
+	best = kvm_find_cpuid_entry(vcpu, 0x1c, 0);
+	if (depth && best)
+		return (best->eax & 0xff) & (1ULL << (depth / 8 - 1));
+
+	return false;
+}
+
 static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	struct kvm_pmc *pmc;
+	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
 	u32 msr = msr_info->index;
 
 	switch (msr) {
@@ -367,6 +387,9 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
 		msr_info->data = pmu->global_ovf_ctrl;
 		return 0;
+	case MSR_ARCH_LBR_DEPTH:
+		msr_info->data = lbr_desc->records.nr;
+		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
 		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
@@ -393,6 +416,7 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	struct kvm_pmc *pmc;
+	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
 	u32 msr = msr_info->index;
 	u64 data = msr_info->data;
 
@@ -427,6 +451,13 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 0;
 		}
 		break;
+	case MSR_ARCH_LBR_DEPTH:
+		if (!arch_lbr_depth_is_valid(vcpu, data))
+			return 1;
+		lbr_desc->records.nr = data;
+		lbr_desc->arch_lbr_reset = true;
+		__set_bit(INTEL_PMC_IDX_FIXED_VLBR, pmu->pmc_in_use);
+		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
 		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
@@ -566,6 +597,7 @@ static void intel_pmu_init(struct kvm_vcpu *vcpu)
 	lbr_desc->records.nr = 0;
 	lbr_desc->event = NULL;
 	lbr_desc->msr_passthrough = false;
+	lbr_desc->arch_lbr_reset = false;
 }
 
 static void intel_pmu_reset(struct kvm_vcpu *vcpu)
@@ -623,6 +655,14 @@ static void intel_pmu_deliver_pmi(struct kvm_vcpu *vcpu)
 		intel_pmu_legacy_freezing_lbrs_on_pmi(vcpu);
 }
 
+static void intel_pmu_arch_lbr_reset(struct kvm_vcpu *vcpu)
+{
+	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
+
+	wrmsrl(MSR_ARCH_LBR_DEPTH, lbr_desc->records.nr);
+	lbr_desc->arch_lbr_reset = false;
+}
+
 static void vmx_update_intercept_for_lbr_msrs(struct kvm_vcpu *vcpu, bool set)
 {
 	struct x86_pmu_lbr *lbr = vcpu_to_lbr_records(vcpu);
@@ -654,6 +694,9 @@ static inline void vmx_enable_lbr_msrs_passthrough(struct kvm_vcpu *vcpu)
 {
 	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
 
+	if (unlikely(lbr_desc->arch_lbr_reset))
+		intel_pmu_arch_lbr_reset(vcpu);
+
 	if (lbr_desc->msr_passthrough)
 		return;
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 12c53d05a902..ad8abe203ba5 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -116,6 +116,9 @@ struct lbr_desc {
 
 	/* True if LBRs are marked as not intercepted in the MSR bitmap */
 	bool msr_passthrough;
+
+	/* Reset all LBR entries on a guest write to MSR_ARCH_LBR_DEPTH */
+	bool arch_lbr_reset;
 };
 
 /*
-- 
2.29.2

