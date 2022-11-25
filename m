Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA0946383CB
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 07:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbiKYGKO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Nov 2022 01:10:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbiKYGKH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Nov 2022 01:10:07 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E31821817;
        Thu, 24 Nov 2022 22:10:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669356606; x=1700892606;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sRn8LM+gX2zunJO+2ncLhKelO3DkPaFu9w4V7AXAhmA=;
  b=NfCyRjja37H1QZvvDd6DR6YKRRtGeGU/a03Xmg6eu1NYwd0Bmj7Owv+S
   1Xcg4Dql/nMRnqTVPcr9nFE962CsLIjJWStbJGAh1Wwi0W26i+wHltw/v
   QkNAS37cQnmAFqF4/9gP9n7YeyRl1Vdc3FL+wn0fVk306lOOLsWCOYyJ8
   lpyWL/IT8IPTUXkibCKOJUJ1ziwX/dFm3ulUoYNHACGWh/tiEDcNoL9Aw
   TxC9s25sxc2a+kO0RVdrvH3rF9PRg9qZvcikp1EpdEAy/GT1adjDQ5/rA
   Cka+ifdvmNcGLFWvO/Ysma27kzQI3p+DWwaj+R3Iq005SpJRVfyn6j6PK
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="313116808"
X-IronPort-AV: E=Sophos;i="5.96,192,1665471600"; 
   d="scan'208";a="313116808"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 22:10:04 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="784838469"
X-IronPort-AV: E=Sophos;i="5.96,192,1665471600"; 
   d="scan'208";a="784838469"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 22:10:03 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, jmattson@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     like.xu.linux@gmail.com, kan.liang@linux.intel.com,
        wei.w.wang@intel.com, weijiang.yang@intel.com,
        Like Xu <like.xu@linux.intel.com>
Subject: [PATCH v2 05/15] KVM: vmx/pmu: Emulate MSR_ARCH_LBR_DEPTH for guest Arch LBR
Date:   Thu, 24 Nov 2022 23:05:54 -0500
Message-Id: <20221125040604.5051-6-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20221125040604.5051-1-weijiang.yang@intel.com>
References: <20221125040604.5051-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <like.xu@linux.intel.com>

The number of Arch LBR entries available is determined by the value
in host MSR_ARCH_LBR_DEPTH.DEPTH. The supported LBR depth values are
enumerated in CPUID.(EAX=01CH, ECX=0):EAX[7:0]. For each bit "n" set
in this field, the MSR_ARCH_LBR_DEPTH.DEPTH value of "8*(n+1)" is
supported. In the first generation of Arch LBR, max entry size is 32,
host configures the max size and guest always honors the setting.

Write to MSR_ARCH_LBR_DEPTH has side-effect, all LBR entries are reset
to 0. Kernel PMU driver can leverage this effect to do fask reset to
LBR record MSRs. KVM allows guest to achieve it when Arch LBR records
MSRs are passed through to the guest.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
Co-developed-by: Yang Weijiang <weijiang.yang@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  3 ++
 arch/x86/kvm/vmx/pmu_intel.c    | 58 +++++++++++++++++++++++++++++++--
 2 files changed, 58 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 70af7240a1d5..2dba2fdd9cdc 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -571,6 +571,9 @@ struct kvm_pmu {
 	 * redundant check before cleanup if guest don't use vPMU at all.
 	 */
 	u8 event_count;
+
+	/* Guest arch lbr depth supported by KVM. */
+	u64 kvm_arch_lbr_depth;
 };
 
 struct kvm_pmu_ops;
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 905673228932..0c78cb4b72be 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -178,6 +178,10 @@ static bool intel_pmu_is_valid_lbr_msr(struct kvm_vcpu *vcpu, u32 index)
 	    (index == MSR_LBR_SELECT || index == MSR_LBR_TOS))
 		return true;
 
+	if (index == MSR_ARCH_LBR_DEPTH)
+		return kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR) &&
+		       guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR);
+
 	if ((index >= records->from && index < records->from + records->nr) ||
 	    (index >= records->to && index < records->to + records->nr))
 		return true;
@@ -345,6 +349,7 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	struct kvm_pmc *pmc;
+	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
 	u32 msr = msr_info->index;
 
 	switch (msr) {
@@ -369,6 +374,9 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_PEBS_DATA_CFG:
 		msr_info->data = pmu->pebs_data_cfg;
 		return 0;
+	case MSR_ARCH_LBR_DEPTH:
+		msr_info->data = lbr_desc->records.nr;
+		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
 		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
@@ -395,6 +403,7 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	struct kvm_pmc *pmc;
+	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
 	u32 msr = msr_info->index;
 	u64 data = msr_info->data;
 	u64 reserved_bits, diff;
@@ -456,6 +465,24 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 0;
 		}
 		break;
+	case MSR_ARCH_LBR_DEPTH:
+		if (!pmu->kvm_arch_lbr_depth && !msr_info->host_initiated)
+			return 1;
+		/*
+		 * When guest/host depth are different, the handling would be tricky,
+		 * so only max depth is supported for both host and guest.
+		 */
+		if (data != pmu->kvm_arch_lbr_depth)
+			return 1;
+
+		lbr_desc->records.nr = data;
+		/*
+		 * Writing depth MSR from guest could either setting the
+		 * MSR or resetting the LBR records with the side-effect.
+		 */
+		if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
+			wrmsrl(MSR_ARCH_LBR_DEPTH, lbr_desc->records.nr);
+		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
 		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
@@ -506,6 +533,32 @@ static void setup_fixed_pmc_eventsel(struct kvm_pmu *pmu)
 	}
 }
 
+static bool cpuid_enable_lbr(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	struct kvm_cpuid_entry2 *entry;
+	int depth_bit;
+
+	if (!kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
+		return !static_cpu_has(X86_FEATURE_ARCH_LBR) &&
+			cpuid_model_is_consistent(vcpu);
+
+	pmu->kvm_arch_lbr_depth = 0;
+	if (!guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR))
+		return false;
+
+	entry = kvm_find_cpuid_entry(vcpu, 0x1C);
+	if (!entry)
+		return false;
+
+	depth_bit = fls(cpuid_eax(0x1C) & 0xff);
+	if ((entry->eax & 0xff) != (1 << (depth_bit - 1)))
+		return false;
+
+	pmu->kvm_arch_lbr_depth = depth_bit * 8;
+	return true;
+}
+
 static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
@@ -589,9 +642,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	bitmap_set(pmu->all_valid_pmc_idx,
 		INTEL_PMC_MAX_GENERIC, pmu->nr_arch_fixed_counters);
 
-	perf_capabilities = vcpu_get_perf_capabilities(vcpu);
-	if (cpuid_model_is_consistent(vcpu) &&
-	    (perf_capabilities & PMU_CAP_LBR_FMT))
+	if (cpuid_enable_lbr(vcpu))
 		x86_perf_get_lbr(&lbr_desc->records);
 	else
 		lbr_desc->records.nr = 0;
@@ -599,6 +650,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	if (lbr_desc->records.nr)
 		bitmap_set(pmu->all_valid_pmc_idx, INTEL_PMC_IDX_FIXED_VLBR, 1);
 
+	perf_capabilities = vcpu_get_perf_capabilities(vcpu);
 	if (perf_capabilities & PERF_CAP_PEBS_FORMAT) {
 		if (perf_capabilities & PERF_CAP_PEBS_BASELINE) {
 			pmu->pebs_enable_mask = counter_mask;
-- 
2.27.0

