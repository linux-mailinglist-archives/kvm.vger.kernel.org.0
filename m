Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 414AF5A8AE0
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 03:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232767AbiIABhR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 21:37:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232664AbiIABhJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 21:37:09 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 239DB15A211;
        Wed, 31 Aug 2022 18:37:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661996226; x=1693532226;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=e+rPDjPdMO16LGhjzBaBMNRpextHnpF2sf0SS8Fc08E=;
  b=EJX9PrSlCzrQY6cnW7VpYzmubeSxtDdccaEYhpq4LJJe+NQIGEBBUGHZ
   kgEC4BsCrXsBSaS8pclCIno4S34YEHcZi0w5A+ERfG2GvqXfpW6GiChFC
   3tVk+4uLLI2m54x7ap/d4up/Uzhx4LhLq9tp4In6dAuuZDj2yWRzlHq0G
   2VkGcgnBF93RKvWH7sK9+0kwbHg/OKB0C/MA0X/PBd2o+2RwcJI3PtTbC
   01M7ZQxn7qgQw7n59Y8DjP5cB+vaexUWAPIfqnCS84iq4k3ufwKHgjBi9
   2r96gwqwAWGby0ggF6XYm4qKaCBtSlYJ9mvnoEz3+ZI8ZhKZIZOiA7dbt
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10456"; a="321735081"
X-IronPort-AV: E=Sophos;i="5.93,279,1654585200"; 
   d="scan'208";a="321735081"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 18:37:01 -0700
X-IronPort-AV: E=Sophos;i="5.93,279,1654585200"; 
   d="scan'208";a="754625988"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 18:37:00 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org
Cc:     like.xu.linux@gmail.com, kan.liang@linux.intel.com,
        wei.w.wang@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH 05/15] KVM: vmx/pmu: Emulate MSR_ARCH_LBR_DEPTH for guest Arch LBR
Date:   Wed, 31 Aug 2022 18:34:28 -0400
Message-Id: <20220831223438.413090-6-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220831223438.413090-1-weijiang.yang@intel.com>
References: <20220831223438.413090-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
---
 arch/x86/include/asm/kvm_host.h |  3 ++
 arch/x86/kvm/vmx/pmu_intel.c    | 57 +++++++++++++++++++++++++++++++--
 2 files changed, 58 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2c96c43c313a..bcc1dca08a17 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -549,6 +549,9 @@ struct kvm_pmu {
 	 * redundant check before cleanup if guest don't use vPMU at all.
 	 */
 	u8 event_count;
+
+	/* Guest arch lbr depth supported by KVM. */
+	u64 kvm_arch_lbr_depth;
 };
 
 struct kvm_pmu_ops;
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 89cb75bb0280..eb35cf2845ca 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -182,6 +182,10 @@ static bool intel_pmu_is_valid_lbr_msr(struct kvm_vcpu *vcpu, u32 index)
 	    (index == MSR_LBR_SELECT || index == MSR_LBR_TOS))
 		return true;
 
+	if (index == MSR_ARCH_LBR_DEPTH)
+		return kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR) &&
+		       guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR);
+
 	if ((index >= records->from && index < records->from + records->nr) ||
 	    (index >= records->to && index < records->to + records->nr))
 		return true;
@@ -349,6 +353,7 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	struct kvm_pmc *pmc;
+	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
 	u32 msr = msr_info->index;
 
 	switch (msr) {
@@ -373,6 +378,9 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_PEBS_DATA_CFG:
 		msr_info->data = pmu->pebs_data_cfg;
 		return 0;
+	case MSR_ARCH_LBR_DEPTH:
+		msr_info->data = lbr_desc->records.nr;
+		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
 		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
@@ -399,6 +407,7 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	struct kvm_pmc *pmc;
+	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
 	u32 msr = msr_info->index;
 	u64 data = msr_info->data;
 	u64 reserved_bits;
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
@@ -590,8 +643,8 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		INTEL_PMC_MAX_GENERIC, pmu->nr_arch_fixed_counters);
 
 	perf_capabilities = vcpu_get_perf_capabilities(vcpu);
-	if (cpuid_model_is_consistent(vcpu) &&
-	    (perf_capabilities & PMU_CAP_LBR_FMT))
+	if ((perf_capabilities & PMU_CAP_LBR_FMT) &&
+	    cpuid_enable_lbr(vcpu))
 		x86_perf_get_lbr(&lbr_desc->records);
 	else
 		lbr_desc->records.nr = 0;
-- 
2.27.0

