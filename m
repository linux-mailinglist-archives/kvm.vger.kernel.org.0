Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA987A9A13
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 20:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbjIUSgO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 14:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbjIUSfw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 14:35:52 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB6A359E
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:50:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695318600; x=1726854600;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=r7FXe3U772ouoKUthr/KM3EloIe2uzXLn1WRaiCQgMs=;
  b=dvW8U2g/I3wPjMbo+XYI/igAfU9GtrH7TmOGFAU6ir4z0TUIHzjzhMTa
   rVZr5F6kW/b23EJqfHx/G49wfzL028I9C9kPMBM7ojmRDl8NRcE0yJ/ld
   xcngTuh+T6zeu8fPz2E4pgSqiVRE7SemWatXOc3rUAdnN5P0Nmy+pgcT0
   mosaYaVGd37BAwcyryeqlGoaNX2I7MiquJhXkJXl3wwhrnr1xpH2h3XCy
   9CiBPYTW7OwhfCaCbONFbcim+7tR4PLhoQNTOR9WEB7wx7mkR7zzTcH1q
   kIq73wN35SIA6tUm00mCgZUNm7XgcKPmrnc3IvIh93Ofuuk1CrhNfQd2N
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10839"; a="359841360"
X-IronPort-AV: E=Sophos;i="6.03,164,1694761200"; 
   d="scan'208";a="359841360"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2023 01:31:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10839"; a="747001122"
X-IronPort-AV: E=Sophos;i="6.03,164,1694761200"; 
   d="scan'208";a="747001122"
Received: from dorasunx-mobl1.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.255.30.47])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2023 01:31:06 -0700
From:   Xiong Zhang <xiong.y.zhang@intel.com>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, like.xu.linux@gmail.com,
        dapeng1.mi@linux.intel.com, zhiyuan.lv@intel.com,
        zhenyu.z.wang@intel.com, kan.liang@intel.com,
        Xiong Zhang <xiong.y.zhang@intel.com>
Subject: [PATCH v2 5/9] KVM: x86/pmu: Add MSR_CORE_PERF_GLOBAL_INUSE emulation
Date:   Thu, 21 Sep 2023 16:29:53 +0800
Message-Id: <20230921082957.44628-6-xiong.y.zhang@intel.com>
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

Arch PMU v4 introduces a new MSR, MSR_CORE_PERF_GLOBAL_INUSE. It provides
as "InUse" bit for each GP counter and fixed counter in processor.
Additionally PMI InUse[bit 63] indicates if the PMI mechanism has been
configured.

Each bit's definition references Architectural Performance Monitoring
Version 4 section of SDM.

Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>

---
ChangeLog:
v1->v2: Check INUSE_PMI bit before writing, Add this new MSR into
msrs_to_save_pmu[]
---
 arch/x86/include/asm/msr-index.h |  4 ++
 arch/x86/kvm/vmx/pmu_intel.c     | 63 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c               |  2 +-
 3 files changed, 68 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 50d231f76003..1879046ad0cb 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -1049,6 +1049,7 @@
 #define MSR_CORE_PERF_GLOBAL_CTRL	0x0000038f
 #define MSR_CORE_PERF_GLOBAL_OVF_CTRL	0x00000390
 #define MSR_CORE_PERF_GLOBAL_STATUS_SET 0x00000391
+#define MSR_CORE_PERF_GLOBAL_INUSE	0x00000392
 
 #define MSR_PERF_METRICS		0x00000329
 
@@ -1061,6 +1062,9 @@
 #define MSR_CORE_PERF_GLOBAL_OVF_CTRL_COND_CHGD_BIT		63
 #define MSR_CORE_PERF_GLOBAL_OVF_CTRL_COND_CHGD			(1ULL << MSR_CORE_PERF_GLOBAL_OVF_CTRL_COND_CHGD_BIT)
 
+/* PERF_GLOBAL_INUSE bits */
+#define MSR_CORE_PERF_GLOBAL_INUSE_PMI				BIT_ULL(63)
+
 /* Geode defined MSRs */
 #define MSR_GEODE_BUSCONT_CONF0		0x00001900
 
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 957663b403f2..d19ccf85026b 100644
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
@@ -347,6 +348,61 @@ static bool intel_pmu_handle_lbr_msrs_access(struct kvm_vcpu *vcpu,
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
+		if ((pmc->eventsel & ARCH_PERFMON_EVENTSEL_INT) &&
+		    !(data & MSR_CORE_PERF_GLOBAL_INUSE_PMI))
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
+		if ((pmu->fixed_ctr_ctrl &
+		    intel_fixed_bits_by_idx(i, INTEL_FIXED_0_ENABLE_PMI)) &&
+		    !(data & MSR_CORE_PERF_GLOBAL_INUSE_PMI))
+			data |= MSR_CORE_PERF_GLOBAL_INUSE_PMI;
+	}
+
+	/*
+	 * IA32_PERF_GLOBAL_INUSE.PMI_InUse[bit 63]: This bit is set if
+	 * any IA32_PEBS_ENABLES bit is set, which enables PEBS for a GP or
+	 * fixed counter.
+	 */
+	if (pmu->pebs_enable &&
+	    !(data & MSR_CORE_PERF_GLOBAL_INUSE_PMI))
+		data |= MSR_CORE_PERF_GLOBAL_INUSE_PMI;
+
+	return data;
+}
+
 static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
@@ -360,6 +416,9 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_CORE_PERF_GLOBAL_STATUS_SET:
 		msr_info->data = 0;
 		break;
+	case MSR_CORE_PERF_GLOBAL_INUSE:
+		msr_info->data = intel_pmu_global_inuse_emulation(pmu);
+		break;
 	case MSR_IA32_PEBS_ENABLE:
 		msr_info->data = pmu->pebs_enable;
 		break;
@@ -409,6 +468,10 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (pmu->fixed_ctr_ctrl != data)
 			reprogram_fixed_counters(pmu, data);
 		break;
+	case MSR_CORE_PERF_GLOBAL_INUSE:
+		if (!msr_info->host_initiated)
+			return 1;   /* RO MSR */
+		break;
 	case MSR_IA32_PEBS_ENABLE:
 		if (data & pmu->pebs_enable_mask)
 			return 1;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index aae60461d0d9..4e70588e4355 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1471,7 +1471,7 @@ static const u32 msrs_to_save_pmu[] = {
 	MSR_ARCH_PERFMON_FIXED_CTR0 + 2,
 	MSR_CORE_PERF_FIXED_CTR_CTRL, MSR_CORE_PERF_GLOBAL_STATUS,
 	MSR_CORE_PERF_GLOBAL_CTRL, MSR_CORE_PERF_GLOBAL_OVF_CTRL,
-	MSR_CORE_PERF_GLOBAL_STATUS_SET,
+	MSR_CORE_PERF_GLOBAL_STATUS_SET, MSR_CORE_PERF_GLOBAL_INUSE,
 	MSR_IA32_PEBS_ENABLE, MSR_IA32_DS_AREA, MSR_PEBS_DATA_CFG,
 
 	/* This part of MSRs should match KVM_INTEL_PMC_MAX_GENERIC. */
-- 
2.34.1

