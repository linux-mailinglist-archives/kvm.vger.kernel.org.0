Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7F87A9DBE
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 21:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbjIUTqz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 15:46:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231276AbjIUTqp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 15:46:45 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 659849011
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:50:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695318600; x=1726854600;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FJjsN/0IeMFvugyIo3sBkjWr5M/Uc3Ntta/kt6prsRA=;
  b=kUNP1HBDrExTeXWpE7UVtKMxcMbM9dH8uKQ080S+NDuMSDxIverlTP0d
   3NYWL91LT2GO8Qm6fbSF8Ff78C+vsSNrFy/jmDGgjDqcMZb1es7JHa+1w
   UaEiesDeqN85llleCOJ3H18wo0ZhHhzJfsrchUVT0wPkr5KCM8XHKYERL
   OYp7MKlmUlvA267gbs3pfZP/A+gSFIVSnOBaos7DivIWq40BOwWb33KTO
   TJbh75MZAegDwkRWw8UISuni0c+aWD+0NvxHBWQChlvjd1DqZtr5EIHMn
   2T3LiW38FempPtMsqxd8NNnfr4UgIvjEUnH+7cnHmySH1Wdcoq37J0y1D
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10839"; a="359841372"
X-IronPort-AV: E=Sophos;i="6.03,164,1694761200"; 
   d="scan'208";a="359841372"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2023 01:31:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10839"; a="747001144"
X-IronPort-AV: E=Sophos;i="6.03,164,1694761200"; 
   d="scan'208";a="747001144"
Received: from dorasunx-mobl1.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.255.30.47])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2023 01:31:11 -0700
From:   Xiong Zhang <xiong.y.zhang@intel.com>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, like.xu.linux@gmail.com,
        dapeng1.mi@linux.intel.com, zhiyuan.lv@intel.com,
        zhenyu.z.wang@intel.com, kan.liang@intel.com,
        Like Xu <likexu@tencent.com>,
        Xiong Zhang <xiong.y.zhang@intel.com>
Subject: [PATCH v2 6/9] KVM: x86/pmu: Add Intel PMU supported fixed counters mask
Date:   Thu, 21 Sep 2023 16:29:54 +0800
Message-Id: <20230921082957.44628-7-xiong.y.zhang@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230921082957.44628-1-xiong.y.zhang@intel.com>
References: <20230921082957.44628-1-xiong.y.zhang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Per Intel SDM, fixed-function performance counter 'i' is supported:

	FxCtr[i]_is_supported := ECX[i] || (EDX[4:0] > i);
if pmu.version >=5, ECX is supported fixed counters bit mask.
if 1 < pmu.version < 5, EDX[4:0] is number of contiguous fixed-function
performance counters starting from 0.

which means that the KVM user space can use EDX to limit the number of
fixed counters starting from 0 and at the same time, using ECX to enable
part of other KVM supported fixed counters. i.e: pmu.version = 5,
ECX= 0x5, EDX[4:0]=1, FxCtrl[2, 0] are supported, FxCtrl[1] isn't
supported.

Add Fixed counter bit mask into all_valid_pmc_idx, and use it to perform
the semantic checks.

Since fixed counter may be non-continuous, nr_arch_fixed_counters can
not be used to enumerate fixed counters, for_each_set_bit_from() is
used to enumerate fixed counters, and nr_arch_fixed_counters is deleted.

Signed-off-by: Like Xu <likexu@tencent.com>
Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/kvm/pmu.h              | 12 +++++-
 arch/x86/kvm/svm/pmu.c          |  1 -
 arch/x86/kvm/vmx/pmu_intel.c    | 69 ++++++++++++++++++++-------------
 4 files changed, 52 insertions(+), 31 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1a4def36d5bb..50d2e51bd143 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -515,7 +515,6 @@ struct kvm_pmc {
 struct kvm_pmu {
 	u8 version;
 	unsigned nr_arch_gp_counters;
-	unsigned nr_arch_fixed_counters;
 	unsigned available_event_types;
 	u64 fixed_ctr_ctrl;
 	u64 fixed_ctr_ctrl_mask;
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 7d9ba301c090..4bab4819ea6c 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -125,14 +125,22 @@ static inline struct kvm_pmc *get_gp_pmc(struct kvm_pmu *pmu, u32 msr,
 	return NULL;
 }
 
+static inline bool fixed_ctr_is_supported(struct kvm_pmu *pmu, unsigned int idx)
+{
+	return test_bit(INTEL_PMC_IDX_FIXED + idx, pmu->all_valid_pmc_idx);
+}
+
 /* returns fixed PMC with the specified MSR */
 static inline struct kvm_pmc *get_fixed_pmc(struct kvm_pmu *pmu, u32 msr)
 {
 	int base = MSR_CORE_PERF_FIXED_CTR0;
 
-	if (msr >= base && msr < base + pmu->nr_arch_fixed_counters) {
+	if (msr >= base && msr < base + KVM_PMC_MAX_FIXED) {
 		u32 index = array_index_nospec(msr - base,
-					       pmu->nr_arch_fixed_counters);
+					       KVM_PMC_MAX_FIXED);
+
+		if (!fixed_ctr_is_supported(pmu, index))
+			return NULL;
 
 		return &pmu->fixed_counters[index];
 	}
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index cef5a3d0abd0..d0a12e739989 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -213,7 +213,6 @@ static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->raw_event_mask = AMD64_RAW_EVENT_MASK;
 	/* not applicable to AMD; but clean them to prevent any fall out */
 	pmu->counter_bitmask[KVM_PMC_FIXED] = 0;
-	pmu->nr_arch_fixed_counters = 0;
 	bitmap_set(pmu->all_valid_pmc_idx, 0, pmu->nr_arch_gp_counters);
 }
 
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index d19ccf85026b..8d7c4e34838f 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -72,10 +72,12 @@ static void reprogram_fixed_counters(struct kvm_pmu *pmu, u64 data)
 {
 	struct kvm_pmc *pmc;
 	u8 old_fixed_ctr_ctrl = pmu->fixed_ctr_ctrl;
-	int i;
+	int s = INTEL_PMC_IDX_FIXED;
 
 	pmu->fixed_ctr_ctrl = data;
-	for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
+	for_each_set_bit_from(s, pmu->all_valid_pmc_idx,
+			      INTEL_PMC_IDX_FIXED + INTEL_PMC_MAX_FIXED) {
+		int i = s - INTEL_PMC_IDX_FIXED;
 		u8 new_ctrl = fixed_ctrl_field(data, i);
 		u8 old_ctrl = fixed_ctrl_field(old_fixed_ctr_ctrl, i);
 
@@ -132,7 +134,7 @@ static bool intel_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
 
 	idx &= ~(3u << 30);
 
-	return fixed ? idx < pmu->nr_arch_fixed_counters
+	return fixed ? fixed_ctr_is_supported(pmu, idx)
 		     : idx < pmu->nr_arch_gp_counters;
 }
 
@@ -144,16 +146,17 @@ static struct kvm_pmc *intel_rdpmc_ecx_to_pmc(struct kvm_vcpu *vcpu,
 	struct kvm_pmc *counters;
 	unsigned int num_counters;
 
+	if (!intel_is_valid_rdpmc_ecx(vcpu, idx))
+		return NULL;
+
 	idx &= ~(3u << 30);
 	if (fixed) {
 		counters = pmu->fixed_counters;
-		num_counters = pmu->nr_arch_fixed_counters;
+		num_counters = KVM_PMC_MAX_FIXED;
 	} else {
 		counters = pmu->gp_counters;
 		num_counters = pmu->nr_arch_gp_counters;
 	}
-	if (idx >= num_counters)
-		return NULL;
 	*mask &= pmu->counter_bitmask[fixed ? KVM_PMC_FIXED : KVM_PMC_GP];
 	return &counters[array_index_nospec(idx, num_counters)];
 }
@@ -352,6 +355,7 @@ static u64 intel_pmu_global_inuse_emulation(struct kvm_pmu *pmu)
 {
 	u64 data = 0;
 	int i;
+	int s = INTEL_PMC_IDX_FIXED;
 
 	for (i = 0; i < pmu->nr_arch_gp_counters; i++) {
 		struct kvm_pmc *pmc = &pmu->gp_counters[i];
@@ -372,7 +376,10 @@ static u64 intel_pmu_global_inuse_emulation(struct kvm_pmu *pmu)
 			data |= MSR_CORE_PERF_GLOBAL_INUSE_PMI;
 	}
 
-	for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
+	for_each_set_bit_from(s, pmu->all_valid_pmc_idx,
+			      INTEL_PMC_IDX_FIXED + INTEL_PMC_MAX_FIXED) {
+		i = s - INTEL_PMC_IDX_FIXED;
+
 		/*
 		 * IA32_PERF_GLOBAL_INUSE.FCi_InUse[bit (i + 32)]: This bit
 		 * reflects the logical state of
@@ -380,7 +387,7 @@ static u64 intel_pmu_global_inuse_emulation(struct kvm_pmu *pmu)
 		 */
 		if (pmu->fixed_ctr_ctrl &
 		    intel_fixed_bits_by_idx(i, INTEL_FIXED_0_KERNEL | INTEL_FIXED_0_USER))
-			data |= 1ULL << (i + INTEL_PMC_IDX_FIXED);
+			data |= 1ULL << s;
 		/*
 		 * IA32_PERF_GLOBAL_INUSE.PMI_InUse[bit 63]: This bit is set if
 		 * IA32_FIXED_CTR_CTRL.ENi_PMI, i = 0, 1, 2 is set.
@@ -575,12 +582,14 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 static void setup_fixed_pmc_eventsel(struct kvm_pmu *pmu)
 {
-	int i;
+	int s = INTEL_PMC_IDX_FIXED;
 
 	BUILD_BUG_ON(ARRAY_SIZE(fixed_pmc_events) != KVM_PMC_MAX_FIXED);
 
-	for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
-		int index = array_index_nospec(i, KVM_PMC_MAX_FIXED);
+	for_each_set_bit_from(s, pmu->all_valid_pmc_idx,
+			      INTEL_PMC_IDX_FIXED + INTEL_PMC_MAX_FIXED) {
+		int index = array_index_nospec(s - INTEL_PMC_IDX_FIXED,
+					       KVM_PMC_MAX_FIXED);
 		struct kvm_pmc *pmc = &pmu->fixed_counters[index];
 		u32 event = fixed_pmc_events[index];
 
@@ -601,7 +610,6 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	int i;
 
 	pmu->nr_arch_gp_counters = 0;
-	pmu->nr_arch_fixed_counters = 0;
 	pmu->counter_bitmask[KVM_PMC_GP] = 0;
 	pmu->counter_bitmask[KVM_PMC_FIXED] = 0;
 	pmu->version = 0;
@@ -643,11 +651,22 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->available_event_types = ~entry->ebx &
 					((1ull << eax.split.mask_length) - 1);
 
-	if (pmu->version == 1) {
-		pmu->nr_arch_fixed_counters = 0;
-	} else {
-		pmu->nr_arch_fixed_counters = min_t(int, edx.split.num_counters_fixed,
-						    kvm_pmu_cap.num_counters_fixed);
+	counter_mask = ~(BIT_ULL(pmu->nr_arch_gp_counters) - 1);
+	bitmap_set(pmu->all_valid_pmc_idx, 0, pmu->nr_arch_gp_counters);
+
+	if (pmu->version > 1) {
+		for (i = 0; i < kvm_pmu_cap.num_counters_fixed; i++) {
+			/*
+			 * FxCtr[i]_is_supported :=
+			 *	CPUID.0xA.ECX[i] || EDX[4:0] > i
+			 */
+			if (!(entry->ecx & BIT_ULL(i) || edx.split.num_counters_fixed > i))
+				continue;
+
+			set_bit(INTEL_PMC_IDX_FIXED + i, pmu->all_valid_pmc_idx);
+			pmu->fixed_ctr_ctrl_mask &= ~(0xbull << (i * 4));
+			counter_mask &= ~BIT_ULL(INTEL_PMC_IDX_FIXED + i);
+		}
 		edx.split.bit_width_fixed = min_t(int, edx.split.bit_width_fixed,
 						  kvm_pmu_cap.bit_width_fixed);
 		pmu->counter_bitmask[KVM_PMC_FIXED] =
@@ -655,10 +674,6 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		setup_fixed_pmc_eventsel(pmu);
 	}
 
-	for (i = 0; i < pmu->nr_arch_fixed_counters; i++)
-		pmu->fixed_ctr_ctrl_mask &= ~(0xbull << (i * 4));
-	counter_mask = ~(((1ull << pmu->nr_arch_gp_counters) - 1) |
-		(((1ull << pmu->nr_arch_fixed_counters) - 1) << INTEL_PMC_IDX_FIXED));
 	pmu->global_ctrl_mask = counter_mask;
 
 	/*
@@ -684,11 +699,6 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		pmu->raw_event_mask |= (HSW_IN_TX|HSW_IN_TX_CHECKPOINTED);
 	}
 
-	bitmap_set(pmu->all_valid_pmc_idx,
-		0, pmu->nr_arch_gp_counters);
-	bitmap_set(pmu->all_valid_pmc_idx,
-		INTEL_PMC_MAX_GENERIC, pmu->nr_arch_fixed_counters);
-
 	perf_capabilities = vcpu_get_perf_capabilities(vcpu);
 	if (cpuid_model_is_consistent(vcpu) &&
 	    (perf_capabilities & PMU_CAP_LBR_FMT))
@@ -701,9 +711,14 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 
 	if (perf_capabilities & PERF_CAP_PEBS_FORMAT) {
 		if (perf_capabilities & PERF_CAP_PEBS_BASELINE) {
+			int s = INTEL_PMC_IDX_FIXED;
+			int e = INTEL_PMC_IDX_FIXED + INTEL_PMC_MAX_FIXED;
+
 			pmu->pebs_enable_mask = counter_mask;
 			pmu->reserved_bits &= ~ICL_EVENTSEL_ADAPTIVE;
-			for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
+
+			for_each_set_bit_from(s, pmu->all_valid_pmc_idx, e) {
+				i = s - INTEL_PMC_IDX_FIXED;
 				pmu->fixed_ctr_ctrl_mask &=
 					~(1ULL << (INTEL_PMC_IDX_FIXED + i * 4));
 			}
-- 
2.34.1

