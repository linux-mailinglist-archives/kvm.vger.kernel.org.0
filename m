Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A758678F919
	for <lists+kvm@lfdr.de>; Fri,  1 Sep 2023 09:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232191AbjIAH3Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Sep 2023 03:29:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348491AbjIAH3X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Sep 2023 03:29:23 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3303910D5
        for <kvm@vger.kernel.org>; Fri,  1 Sep 2023 00:29:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693553360; x=1725089360;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=z0wVXXRYmruZ4sJE29Br4nwX5WxuWH1zxAHI0a7i0gI=;
  b=cUDwqa2neKR9965F99WqVZebGx5MiJpl7rvQCdAWjULKE5+F8LOUptn9
   KoVV4fKPQV+urnkpdlus7bDUNqYW8t1TTdBQzpTBZOCoHq+niUpergVuF
   7AuDWzkVCj7G79Cj7s6ifL+eRXgyxFHpyaa1ZXt2nbAg5an8ooEKAeWAX
   N0eEEMz9MmOaRtjR334Sv3vzhbh3syT13phF24hBVUXAlbuXJ7UzwurSv
   B8TXwawMmjgIPRlnFC457JiMJxtiGnpW4Zj7UigXuyy99wgXq3Ecz+V0n
   g5NX3wK+33SKVeoVwOmh3bsf37hDFgVEbEwZ4aBdo1ZyGcFOAQ1zaT0lL
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10819"; a="373550308"
X-IronPort-AV: E=Sophos;i="6.02,219,1688454000"; 
   d="scan'208";a="373550308"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2023 00:29:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10819"; a="716671257"
X-IronPort-AV: E=Sophos;i="6.02,219,1688454000"; 
   d="scan'208";a="716671257"
Received: from wangdere-mobl2.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.255.29.239])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2023 00:29:16 -0700
From:   Xiong Zhang <xiong.y.zhang@intel.com>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, like.xu.linux@gmail.com, zhiyuan.lv@intel.com,
        zhenyu.z.wang@intel.com, kan.liang@intel.com,
        dapeng1.mi@linux.intel.com, Xiong Zhang <xiong.y.zhang@intel.com>
Subject: [PATCH 2/9] KVM: x85/pmu: Add Streamlined FREEZE_LBR_ON_PMI for vPMU v4
Date:   Fri,  1 Sep 2023 15:28:02 +0800
Message-Id: <20230901072809.640175-3-xiong.y.zhang@intel.com>
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

Arch PMU version 4 adds a streamlined FREEZE_LBR_ON_PMI feature, this
feature adds LBR_FRZ[bit 58] into IA32_PERF_GLOBAL_STATUS, this bit is
set due to the following conditions:
-- IA32_DEBUGCTL.FREEZE_LBR_ON_PMI has been set
-- A performance counter, configured to generate PMI, has overflowed to
signal a PMI. Consequently the LBR stack is frozen.
Effectively, this bit also serves as a control to enabled capturing
data in the LBR stack. When this bit is set, LBR stack is frozen, and
new LBR records won't be filled.

The sequence of streamlined freeze LBR is:
1. Profiling agent set IA32_DEBUGCTL.FREEZE_LBR_ON_PMI, and enable
a performance counter to generate PMI on overflow.
2. Processor generates PMI and sets IA32_PERF_GLOBAL_STATUS.LBR_FRZ,
then LBR stack is forzen.
3. Profiling agent PMI handler handles overflow, and clears
IA32_PERF_GLOBAL_STATUS.
4. When IA32_PERF_GLOBAL_STATUS.LBR_FRZ is cleared in step 3,
processor resume LBR stack, and new LBR records can be filled
again.

In order to emulate this behavior, LBR stack must be frozen on PMI.
KVM has two choice to do this:
1. KVM stops vLBR event through perf_event_pause(), and put vLBR
event into off state, then vLBR lose LBR hw resource, finally guest
couldn't read LBR records in guest PMI handler. This choice couldn't
be used.
2. KVM clear guest DEBUGCTLMSR_LBR bit in VMCS on PMI, so when guest
is running, LBR HW stack is disabled, while vLBR event is still active
and own LBR HW, so guest could still read LBR records in guest PMI
handler. But the sequence of streamlined freeze LBR doesn't clear
DEBUGCTLMSR_LBR bit, so when guest read guest DEBUGCTL_MSR, KVM will
return a value with DEBUGCTLMSR_LBR bit set during LBR freezing. Once
guest clears IA32_PERF_GLOBAL_STATUS.LBR_FRZ in step 4, KVM will
re-enable guest LBR through setting guest DEBUGCTL_LBR bit in VMCS.

As KVM will re-enable guest LBR when guest clears global status, the
handling of GLOBAL_OVF_CTRL MSR is moved from common pmu.c into
vmx/pmu_intel.c.

Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
---
 arch/x86/include/asm/msr-index.h |  1 +
 arch/x86/kvm/pmu.c               |  8 ------
 arch/x86/kvm/vmx/pmu_intel.c     | 44 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c           |  3 +++
 4 files changed, 48 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 3aedae61af4f..4fce37ae5a90 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -1041,6 +1041,7 @@
 /* PERF_GLOBAL_OVF_CTL bits */
 #define MSR_CORE_PERF_GLOBAL_OVF_CTRL_TRACE_TOPA_PMI_BIT	55
 #define MSR_CORE_PERF_GLOBAL_OVF_CTRL_TRACE_TOPA_PMI		(1ULL << MSR_CORE_PERF_GLOBAL_OVF_CTRL_TRACE_TOPA_PMI_BIT)
+#define MSR_CORE_PERF_GLOBAL_OVF_CTRL_LBR_FREEZE		BIT_ULL(58)
 #define MSR_CORE_PERF_GLOBAL_OVF_CTRL_OVF_BUF_BIT		62
 #define MSR_CORE_PERF_GLOBAL_OVF_CTRL_OVF_BUF			(1ULL <<  MSR_CORE_PERF_GLOBAL_OVF_CTRL_OVF_BUF_BIT)
 #define MSR_CORE_PERF_GLOBAL_OVF_CTRL_COND_CHGD_BIT		63
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index edb89b51b383..4b6a508f3f0b 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -640,14 +640,6 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			reprogram_counters(pmu, diff);
 		}
 		break;
-	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
-		/*
-		 * GLOBAL_OVF_CTRL, a.k.a. GLOBAL STATUS_RESET, clears bits in
-		 * GLOBAL_STATUS, and so the set of reserved bits is the same.
-		 */
-		if (data & pmu->global_status_mask)
-			return 1;
-		fallthrough;
 	case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR:
 		if (!msr_info->host_initiated)
 			pmu->global_status &= ~data;
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 3a36a91638c6..ba7695a64ff1 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -426,6 +426,29 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 		pmu->pebs_data_cfg = data;
 		break;
+	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
+		/*
+		 * GLOBAL_OVF_CTRL, a.k.a. GLOBAL STATUS_RESET, clears bits in
+		 * GLOBAL_STATUS, and so the set of reserved bits is the same.
+		 */
+		if (data & pmu->global_status_mask)
+			return 1;
+		if (pmu->version >= 4 && !msr_info->host_initiated &&
+		    (data & MSR_CORE_PERF_GLOBAL_OVF_CTRL_LBR_FREEZE)) {
+			u64 debug_ctl = vmcs_read64(GUEST_IA32_DEBUGCTL);
+			struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
+
+			if (!(debug_ctl & DEBUGCTLMSR_LBR) &&
+			    lbr_desc->freeze_on_pmi) {
+				debug_ctl |= DEBUGCTLMSR_LBR;
+				vmcs_write64(GUEST_IA32_DEBUGCTL, debug_ctl);
+				lbr_desc->freeze_on_pmi = false;
+			}
+		}
+
+		if (!msr_info->host_initiated)
+			pmu->global_status &= ~data;
+		break;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
 		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
@@ -565,6 +588,9 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	if (vmx_pt_mode_is_host_guest())
 		pmu->global_status_mask &=
 				~MSR_CORE_PERF_GLOBAL_OVF_CTRL_TRACE_TOPA_PMI;
+	if (pmu->version >= 4)
+		pmu->global_status_mask &=
+				~MSR_CORE_PERF_GLOBAL_OVF_CTRL_LBR_FREEZE;
 
 	entry = kvm_find_cpuid_entry_index(vcpu, 7, 0);
 	if (entry &&
@@ -675,6 +701,22 @@ static void intel_pmu_legacy_freezing_lbrs_on_pmi(struct kvm_vcpu *vcpu)
 	}
 }
 
+static void intel_pmu_streamlined_freezing_lbrs_on_pmi(struct kvm_vcpu *vcpu)
+{
+	u64 data = vmcs_read64(GUEST_IA32_DEBUGCTL);
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+
+	/*
+	 * Even if streamlined freezing LBR won't clear LBR_EN like legacy
+	 * freezing LBR, here legacy freezing LBR is called to freeze LBR HW
+	 * for streamlined freezing LBR when guest run. But guest VM will
+	 * see a fake guest DEBUGCTL MSR with LBR_EN bit set.
+	 */
+	intel_pmu_legacy_freezing_lbrs_on_pmi(vcpu);
+	if ((data & DEBUGCTLMSR_FREEZE_LBRS_ON_PMI) && (data & DEBUGCTLMSR_LBR))
+		pmu->global_status |= MSR_CORE_PERF_GLOBAL_OVF_CTRL_LBR_FREEZE;
+}
+
 static void intel_pmu_deliver_pmi(struct kvm_vcpu *vcpu)
 {
 	u8 version = vcpu_to_pmu(vcpu)->version;
@@ -684,6 +726,8 @@ static void intel_pmu_deliver_pmi(struct kvm_vcpu *vcpu)
 
 	if (version > 1 && version < 4)
 		intel_pmu_legacy_freezing_lbrs_on_pmi(vcpu);
+	else if (version >= 4)
+		intel_pmu_streamlined_freezing_lbrs_on_pmi(vcpu);
 }
 
 static void vmx_update_intercept_for_lbr_msrs(struct kvm_vcpu *vcpu, bool set)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 199d0da1dbee..3bd64879aab3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2098,6 +2098,9 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_IA32_DEBUGCTLMSR:
 		msr_info->data = vmcs_read64(GUEST_IA32_DEBUGCTL);
+		if (vcpu_to_lbr_desc(vcpu)->freeze_on_pmi &&
+		    vcpu_to_pmu(vcpu)->version >= 4)
+			msr_info->data |= DEBUGCTLMSR_LBR;
 		break;
 	default:
 	find_uret_msr:
-- 
2.34.1

