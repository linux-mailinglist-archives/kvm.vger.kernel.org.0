Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 217A578F91B
	for <lists+kvm@lfdr.de>; Fri,  1 Sep 2023 09:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348492AbjIAH3i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Sep 2023 03:29:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345348AbjIAH3h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Sep 2023 03:29:37 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A323510FF
        for <kvm@vger.kernel.org>; Fri,  1 Sep 2023 00:29:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693553368; x=1725089368;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=e9GBmb6MYZj2FZWMLl6IWpX0FvqtRaMTkPeuCa6J3RQ=;
  b=QBZrsKH2wLGO0GWpgZ00X4lG4wp7/7Ct8lFiA7/OtNk0wqooXUG+2SUA
   c2r8e1085+sLXypiKBAqT3ms+t5VBcMbExMwSUUzg43op+ewEyUdgNUlt
   TNItLWP/V/dRiEXWdFRHhGC4c5Bny+QpWgOaJHn7ym9ZvGS38kHCZ5rGf
   NxGuI2X9vkFaXg52doS0V9nvOt8IqqyJfjltQvkITJLYCcl7fBvZF/uHb
   SYVAN9imxAe31OW06NUnQ1L4Zo55qA8WmU7qniPQMrQ4GpFhj1DI+JmMT
   Q0DGqmOneW8PLXl+YzSGqFTmZy9P5zTMcxUn7JWqG/v6lHzr5YDVMGrA4
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10819"; a="373550324"
X-IronPort-AV: E=Sophos;i="6.02,219,1688454000"; 
   d="scan'208";a="373550324"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2023 00:29:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10819"; a="716671288"
X-IronPort-AV: E=Sophos;i="6.02,219,1688454000"; 
   d="scan'208";a="716671288"
Received: from wangdere-mobl2.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.255.29.239])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2023 00:29:25 -0700
From:   Xiong Zhang <xiong.y.zhang@intel.com>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, like.xu.linux@gmail.com, zhiyuan.lv@intel.com,
        zhenyu.z.wang@intel.com, kan.liang@intel.com,
        dapeng1.mi@linux.intel.com, Xiong Zhang <xiong.y.zhang@intel.com>
Subject: [PATCH 4/9] KVM: x86/pmu: Add MSR_PERF_GLOBAL_INUSE emulation
Date:   Fri,  1 Sep 2023 15:28:04 +0800
Message-Id: <20230901072809.640175-5-xiong.y.zhang@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230901072809.640175-1-xiong.y.zhang@intel.com>
References: <20230901072809.640175-1-xiong.y.zhang@intel.com>
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

Arch PMU v4 introduces a new MSR, IA32_PERF_GLOBAL_INUSE. It provides
as "InUse" bit for each GP counter and fixed counter in processor.
Additionally PMI InUse[bit 63] indicates if the PMI mechanism has been
configured.

Each bit's definition references Architectural Performance Monitoring
Version 4 section of SDM.

Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
---
 arch/x86/include/asm/msr-index.h |  4 +++
 arch/x86/kvm/vmx/pmu_intel.c     | 58 ++++++++++++++++++++++++++++++++
 2 files changed, 62 insertions(+)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 7c8cf6b53a76..31bb425899fb 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -1036,6 +1036,7 @@
 #define MSR_CORE_PERF_GLOBAL_CTRL	0x0000038f
 #define MSR_CORE_PERF_GLOBAL_OVF_CTRL	0x00000390
 #define MSR_CORE_PERF_GLOBAL_STATUS_SET 0x00000391
+#define MSR_CORE_PERF_GLOBAL_INUSE	0x00000392
 
 #define MSR_PERF_METRICS		0x00000329
 
@@ -1048,6 +1049,9 @@
 #define MSR_CORE_PERF_GLOBAL_OVF_CTRL_COND_CHGD_BIT		63
 #define MSR_CORE_PERF_GLOBAL_OVF_CTRL_COND_CHGD			(1ULL << MSR_CORE_PERF_GLOBAL_OVF_CTRL_COND_CHGD_BIT)
 
+/* PERF_GLOBAL_INUSE bits */
+#define MSR_CORE_PERF_GLOBAL_INUSE_PMI				BIT_ULL(63)
+
 /* Geode defined MSRs */
 #define MSR_GEODE_BUSCONT_CONF0		0x00001900
 
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index b25df421cd75..46363ac82a79 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -207,6 +207,7 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 	case MSR_CORE_PERF_FIXED_CTR_CTRL:
 		return kvm_pmu_has_perf_global_ctrl(pmu);
 	case MSR_CORE_PERF_GLOBAL_STATUS_SET:
+	case MSR_CORE_PERF_GLOBAL_INUSE:
 		return vcpu_to_pmu(vcpu)->version >= 4;
 	case MSR_IA32_PEBS_ENABLE:
 		ret = vcpu_get_perf_capabilities(vcpu) & PERF_CAP_PEBS_FORMAT;
@@ -347,6 +348,58 @@ static bool intel_pmu_handle_lbr_msrs_access(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+static u64 intel_pmu_global_inuse_emulation(struct kvm_pmu *pmu)
+{
+	u64 data = 0;
+	int i;
+
+	for (i = 0; i < pmu->nr_arch_gp_counters; i++) {
+		struct kvm_pmc *pmc = &pmu->gp_counters[i];
+
+		/*
+		 * IA32_PERF_GLOBAL_INUSE.PERFEVTSELn_InUse[bit n]: This bit
+		 * reflects the logical state of (IA32_PERFEVTSELn[7:0]),
+		 * n < CPUID.0AH.EAX[15:8].
+		 */
+		if (pmc->eventsel & ARCH_PERFMON_EVENTSEL_EVENT)
+			data |= 1 << i;
+		/*
+		 * IA32_PERF_GLOBAL_INUSE.PMI_InUse[bit 63]: This bit is set if
+		 * IA32_PERFEVTSELn.INT[bit 20], n < CPUID.0AH.EAX[15:8] is set.
+		 */
+		if (pmc->eventsel & ARCH_PERFMON_EVENTSEL_INT)
+			data |= MSR_CORE_PERF_GLOBAL_INUSE_PMI;
+	}
+
+	for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
+		/*
+		 * IA32_PERF_GLOBAL_INUSE.FCi_InUse[bit (i + 32)]: This bit
+		 * reflects the logical state of
+		 * IA32_FIXED_CTR_CTRL[i * 4 + 1, i * 4] != 0
+		 */
+		if (pmu->fixed_ctr_ctrl &
+		    intel_fixed_bits_by_idx(i, INTEL_FIXED_0_KERNEL | INTEL_FIXED_0_USER))
+			data |= 1ULL << (i + INTEL_PMC_IDX_FIXED);
+		/*
+		 * IA32_PERF_GLOBAL_INUSE.PMI_InUse[bit 63]: This bit is set if
+		 * IA32_FIXED_CTR_CTRL.ENi_PMI, i = 0, 1, 2 is set.
+		 */
+		if (pmu->fixed_ctr_ctrl &
+		    intel_fixed_bits_by_idx(i, INTEL_FIXED_0_ENABLE_PMI))
+			data |= MSR_CORE_PERF_GLOBAL_INUSE_PMI;
+	}
+
+	/*
+	 * IA32_PERF_GLOBAL_INUSE.PMI_InUse[bit 63]: This bit is set if
+	 * any IA32_PEBS_ENABLES bit is set, which enables PEBS for a GP or
+	 * fixed counter.
+	 */
+	if (pmu->pebs_enable)
+		data |= MSR_CORE_PERF_GLOBAL_INUSE_PMI;
+
+	return data;
+}
+
 static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
@@ -360,6 +413,9 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_CORE_PERF_GLOBAL_STATUS_SET:
 		msr_info->data = 0;
 		break;
+	case MSR_CORE_PERF_GLOBAL_INUSE:
+		msr_info->data = intel_pmu_global_inuse_emulation(pmu);
+		break;
 	case MSR_IA32_PEBS_ENABLE:
 		msr_info->data = pmu->pebs_enable;
 		break;
@@ -409,6 +465,8 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (pmu->fixed_ctr_ctrl != data)
 			reprogram_fixed_counters(pmu, data);
 		break;
+	case MSR_CORE_PERF_GLOBAL_INUSE:
+		return 1;   /* RO MSR */
 	case MSR_IA32_PEBS_ENABLE:
 		if (data & pmu->pebs_enable_mask)
 			return 1;
-- 
2.34.1

