Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC5314B85BA
	for <lists+kvm@lfdr.de>; Wed, 16 Feb 2022 11:31:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232995AbiBPK1T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Feb 2022 05:27:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232864AbiBPK1F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Feb 2022 05:27:05 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CADC2211D41;
        Wed, 16 Feb 2022 02:26:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645007213; x=1676543213;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DpnDIQIQ30yes2zliamdNZVZ2UnkFj3dAniS5yP9yT8=;
  b=WIX5lFadVgJmv5WPp13RLey/x4YkFohaimUivgzpW4cStAO+cmVdBcW6
   WCMEqpcn73lSXFcXbdn2alUNvnDJ2l9dqqCJjZA+bZbYNCGXpuiQQt6Px
   Zn/ln201BgvBK9jnFGhofowUX7UTVkLjhupAeS/CyxJRfLPwlfU3hpImz
   2hknLiy37aQCVyfYVkeO+3b2+qCNi5W3qK/D7lyqu23f3rQ8vOBnk3rpt
   IYjFeZl1KvRZBnqA9WY4xSi1orlPCPTvSdMhlBntC0oUnXxezl9m+J8lM
   Ephn1sVSfEYY0cuvBFJf/J+llpyHiKMJV9GycDc8geTjXV4Fy4+Sh66H/
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10259"; a="250312474"
X-IronPort-AV: E=Sophos;i="5.88,373,1635231600"; 
   d="scan'208";a="250312474"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2022 02:26:51 -0800
X-IronPort-AV: E=Sophos;i="5.88,373,1635231600"; 
   d="scan'208";a="498708591"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2022 02:26:50 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        like.xu.linux@gmail.com, vkuznets@redhat.com, wei.w.wang@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Like Xu <like.xu@linux.intel.com>,
        Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v9 07/17] KVM: vmx/pmu: Emulate MSR_ARCH_LBR_DEPTH for guest Arch LBR
Date:   Tue, 15 Feb 2022 16:25:34 -0500
Message-Id: <20220215212544.51666-8-weijiang.yang@intel.com>
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
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  3 +++
 arch/x86/kvm/vmx/pmu_intel.c    | 48 ++++++++++++++++++++++++++++++++-
 2 files changed, 50 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 0c3a6feb41eb..8e1547d4747c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -528,6 +528,9 @@ struct kvm_pmu {
 	 * redundant check before cleanup if guest don't use vPMU at all.
 	 */
 	u8 event_count;
+
+	/* Guest arch lbr depth supported by KVM. */
+	u64 kvm_arch_lbr_depth;
 };
 
 struct kvm_pmu_ops;
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 466d18fc0c5d..cbf00db5448a 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -205,7 +205,7 @@ static bool intel_pmu_is_valid_lbr_msr(struct kvm_vcpu *vcpu, u32 index)
 static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
-	int ret;
+	int ret = 0;
 
 	switch (msr) {
 	case MSR_CORE_PERF_FIXED_CTR_CTRL:
@@ -214,6 +214,10 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
 		ret = pmu->version > 1;
 		break;
+	case MSR_ARCH_LBR_DEPTH:
+		if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
+			ret = guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR);
+		break;
 	default:
 		ret = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0) ||
 			get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0) ||
@@ -342,10 +346,26 @@ static bool intel_pmu_handle_lbr_msrs_access(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+/*
+ * Check if the requested depth value the same as that of host.
+ * When guest/host depth are different, the handling would be tricky,
+ * so now only max depth is supported for both host and guest.
+ */
+static bool arch_lbr_depth_is_valid(struct kvm_vcpu *vcpu, u64 depth)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+
+	if (!kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
+		return false;
+
+	return (depth == pmu->kvm_arch_lbr_depth);
+}
+
 static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	struct kvm_pmc *pmc;
+	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
 	u32 msr = msr_info->index;
 
 	switch (msr) {
@@ -361,6 +381,9 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
 		msr_info->data = 0;
 		return 0;
+	case MSR_ARCH_LBR_DEPTH:
+		msr_info->data = lbr_desc->records.nr;
+		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
 		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
@@ -387,6 +410,7 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	struct kvm_pmc *pmc;
+	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
 	u32 msr = msr_info->index;
 	u64 data = msr_info->data;
 
@@ -420,6 +444,16 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 0;
 		}
 		break;
+	case MSR_ARCH_LBR_DEPTH:
+		if (!arch_lbr_depth_is_valid(vcpu, data))
+			return 1;
+		lbr_desc->records.nr = data;
+		/*
+		 * Writing depth MSR from guest could either setting the
+		 * MSR or resetting the LBR records with the side-effect.
+		 */
+		wrmsrl(MSR_ARCH_LBR_DEPTH, lbr_desc->records.nr);
+		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
 		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
@@ -550,6 +584,18 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 
 	if (lbr_desc->records.nr)
 		bitmap_set(pmu->all_valid_pmc_idx, INTEL_PMC_IDX_FIXED_VLBR, 1);
+
+	if (!kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
+		return;
+
+	entry = kvm_find_cpuid_entry(vcpu, 28, 0);
+	if (entry) {
+		/*
+		 * The depth mask in CPUID is fixed to host supported
+		 * value when userspace sets guest CPUID.
+		 */
+		pmu->kvm_arch_lbr_depth = fls(entry->eax & 0xff) * 8;
+	}
 }
 
 static void intel_pmu_init(struct kvm_vcpu *vcpu)
-- 
2.27.0

