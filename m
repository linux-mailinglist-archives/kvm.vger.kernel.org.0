Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF027AA0E9
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 22:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232287AbjIUUuD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 16:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232018AbjIUUtJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 16:49:09 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8E844E5CB
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695318598; x=1726854598;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JxIQN4W0m34DpRad7XzCHfwbyOw8EJzcxV997kxjd20=;
  b=LVsCNRVEJDxLmWXwqVOAAsPA8e3mMzPrHf2C5SiauyQ71wsMIWdkcBs+
   fQtqYLFlwvM2Tm5jQNAMELHUAHRxskX15fhc5SkC01DLKQk1h4rEgoMUr
   zrV9itIevQqf68Ve04XQOOew0CwP97exTk1hThqa8bXByuvlEKugIYu1r
   ilY/3pC2fwVWRwdv7IY/0u5SD1ooAYdqTYTWSCrQPvB44L28hTKdy0mG0
   CAbVGgUSN4o9Q0/GlcEA+35hvhqVLwHxxi4Oi8QaoKH07U5C/xRfV2fM0
   q8NwV4x0uJylGNlqsNP8S8mPqfsLb0uHHc0qjVOTcehUf1mYcyUDvkdJG
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10839"; a="359841342"
X-IronPort-AV: E=Sophos;i="6.03,164,1694761200"; 
   d="scan'208";a="359841342"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2023 01:30:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10839"; a="747001078"
X-IronPort-AV: E=Sophos;i="6.03,164,1694761200"; 
   d="scan'208";a="747001078"
Received: from dorasunx-mobl1.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.255.30.47])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2023 01:30:57 -0700
From:   Xiong Zhang <xiong.y.zhang@intel.com>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, like.xu.linux@gmail.com,
        dapeng1.mi@linux.intel.com, zhiyuan.lv@intel.com,
        zhenyu.z.wang@intel.com, kan.liang@intel.com,
        Xiong Zhang <xiong.y.zhang@intel.com>
Subject: [PATCH v2 3/9] KVM: x85/pmu: Add Streamlined FREEZE_LBR_ON_PMI for vPMU v4
Date:   Thu, 21 Sep 2023 16:29:51 +0800
Message-Id: <20230921082957.44628-4-xiong.y.zhang@intel.com>
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

In order to emulate this behavior, LBR stack must be frozen on guest
vPMI. KVM has two choice to do this:
1. KVM stops vLBR event through perf_event_pause(), and put vLBR
event into off state, then vLBR lose LBR hw resource, finally guest
couldn't read LBR records in guest PMI handler. This choice couldn't
be used.
2. KVM clears guest DEBUGCTLMSR_LBR bit in VMCS on PMI, so when guest
is running, LBR HW stack is disabled, while vLBR event is still active
and own LBR HW, so guest could still read LBR records in guest PMI
handler. But the sequence of streamlined freeze LBR doesn't clear
DEBUGCTLMSR_LBR bit, so when guest read guest DEBUGCTL_MSR, KVM will
return a value with DEBUGCTLMSR_LBR bit set during LBR freezing. Once
guest clears IA32_PERF_GLOBAL_STATUS.LBR_FRZ in step 4, KVM will
re-enable guest LBR through setting guest DEBUGCTL_LBR bit in VMCS.

As KVM needs re-enable guest LBR when guest clears global status, the
handling of GLOBAL_OVF_CTRL MSR is moved from common pmu.c into
vmx/pmu_intel.c.

Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 arch/x86/include/asm/msr-index.h |  1 +
 arch/x86/kvm/pmu.c               |  8 ------
 arch/x86/kvm/vmx/pmu_intel.c     | 49 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c           |  7 +++++
 4 files changed, 57 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 1d111350197f..badc2f729a8e 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -1054,6 +1054,7 @@
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
index c8d46c3d1ab6..6e3bbe777bf5 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -426,6 +426,34 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 		pmu->pebs_data_cfg = data;
 		break;
+	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
+		/*
+		 * GLOBAL_OVF_CTRL, a.k.a. GLOBAL STATUS_RESET, clears bits in
+		 * GLOBAL_STATUS, and so the set of reserved bits is the same.
+		 */
+		if (data & pmu->global_status_mask)
+			return 1;
+
+		/*
+		 * Guest clears GLOBAL_STATUS_LBR_FREEZE bit, KVM re-enable
+		 * Guset LBR which is disabled at vPMI injection for streamlined
+		 * Freeze_LBR_On_PMI.
+		 */
+		if (pmu->version >= 4 && !msr_info->host_initiated &&
+		    (data & MSR_CORE_PERF_GLOBAL_OVF_CTRL_LBR_FREEZE) &&
+		    (pmu->global_status & MSR_CORE_PERF_GLOBAL_OVF_CTRL_LBR_FREEZE)) {
+			u64 debug_ctl = vmcs_read64(GUEST_IA32_DEBUGCTL);
+
+			if (!(debug_ctl & DEBUGCTLMSR_LBR)) {
+				debug_ctl |= DEBUGCTLMSR_LBR;
+				vmcs_write64(GUEST_IA32_DEBUGCTL, debug_ctl);
+			}
+			vcpu_to_lbr_desc(vcpu)->state = LBR_STATE_IN_USE;
+		}
+
+		if (!msr_info->host_initiated)
+			pmu->global_status &= ~data;
+		break;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
 		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
@@ -565,6 +593,9 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	if (vmx_pt_mode_is_host_guest())
 		pmu->global_status_mask &=
 				~MSR_CORE_PERF_GLOBAL_OVF_CTRL_TRACE_TOPA_PMI;
+	if (pmu->version >= 4)
+		pmu->global_status_mask &=
+				~MSR_CORE_PERF_GLOBAL_OVF_CTRL_LBR_FREEZE;
 
 	entry = kvm_find_cpuid_entry_index(vcpu, 7, 0);
 	if (entry &&
@@ -675,6 +706,22 @@ static void intel_pmu_legacy_freezing_lbrs_on_pmi(struct kvm_vcpu *vcpu)
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
@@ -684,6 +731,8 @@ static void intel_pmu_deliver_pmi(struct kvm_vcpu *vcpu)
 
 	if (version > 1 && version < 4)
 		intel_pmu_legacy_freezing_lbrs_on_pmi(vcpu);
+	else if (version >= 4)
+		intel_pmu_streamlined_freezing_lbrs_on_pmi(vcpu);
 }
 
 static void vmx_update_intercept_for_lbr_msrs(struct kvm_vcpu *vcpu, bool set)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 565df8eeb78b..66e4cf714dbd 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2113,6 +2113,13 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_IA32_DEBUGCTLMSR:
 		msr_info->data = vmcs_read64(GUEST_IA32_DEBUGCTL);
+		/*
+		 * In streamlined Freeze_LBR_On_PMI, guest should see LBR_EN.
+		 */
+		if ((vcpu_to_pmu(vcpu)->global_status &
+		     MSR_CORE_PERF_GLOBAL_OVF_CTRL_LBR_FREEZE) &&
+		    vcpu_to_pmu(vcpu)->version >= 4)
+			msr_info->data |= DEBUGCTLMSR_LBR;
 		break;
 	default:
 	find_uret_msr:
-- 
2.34.1

