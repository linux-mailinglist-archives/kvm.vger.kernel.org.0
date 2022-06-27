Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01A7B55DA25
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241588AbiF0Vzx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 17:55:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241363AbiF0Vy6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 17:54:58 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F31063A8;
        Mon, 27 Jun 2022 14:54:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656366895; x=1687902895;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XBjeuhR3U6xLy+gmxHiSh3kVvdVevxzt5UoVhGw2y4Y=;
  b=ZC/JbZuOH1C9SBvdQUTyBFqRaOpt17QuicCwgu7xhreyDZHI4e42L1GV
   F6gEfywdagg0L7Q5pp7Vyjz3zUXIwyAetyHdqW7fkih7kUUu0drlplMfC
   1JXE5Z6lanAhg5hOIZdHdq5HzvslzLznZuOw/b1hF2mVNgoOvTr+taEBd
   YSlYlbJzTl5KmE/zPUtCuqVMgtsj5HWy4EvPYiFa/sbLgTdXx3/Cd8cE0
   zvIHRdGm+m4syW1KVkj7RyamjZMYHIzJZQ9G1BmrB6A9VtYBVB+ROryBm
   I6ZB67397tBg5t1Ju0KkGunC6ZXl9olKf44kCTaHTfq8y9OfWdhnZ/lF+
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="281609524"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="281609524"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:54:51 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="657863517"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:54:51 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v7 026/102] KVM: TDX: Make pmu_intel.c ignore guest TD case
Date:   Mon, 27 Jun 2022 14:53:18 -0700
Message-Id: <d3dff71468be5aa25296fa46d4962c06d8911e57.1656366338.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1656366337.git.isaku.yamahata@intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Because TDX KVM doesn't support PMU yet (it's future work of TDX KVM
support as another patch series) and pmu_intel.c touches vmx specific
structure in vcpu initialization, as workaround add dummy structure to
struct vcpu_tdx and pmu_intel.c can ignore TDX case.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 39 +++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/pmu_intel.h | 28 ++++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.h       |  7 +++++++
 arch/x86/kvm/vmx/vmx.c       |  2 +-
 arch/x86/kvm/vmx/vmx.h       | 22 +-------------------
 5 files changed, 75 insertions(+), 23 deletions(-)
 create mode 100644 arch/x86/kvm/vmx/pmu_intel.h

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 422f0a6562ac..f8e8f32b8a3f 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -17,6 +17,7 @@
 #include "lapic.h"
 #include "nested.h"
 #include "pmu.h"
+#include "tdx.h"
 
 #define MSR_PMC_FULL_WIDTH_BIT      (MSR_IA32_PMC0 - MSR_IA32_PERFCTR0)
 
@@ -35,6 +36,26 @@ static struct kvm_event_hw_type_mapping intel_arch_events[] = {
 /* mapping between fixed pmc index and intel_arch_events array */
 static int fixed_pmc_events[] = {1, 0, 7};
 
+struct lbr_desc *vcpu_to_lbr_desc(struct kvm_vcpu *vcpu)
+{
+#ifdef CONFIG_INTEL_TDX_HOST
+	if (is_td_vcpu(vcpu))
+		return &to_tdx(vcpu)->lbr_desc;
+#endif
+
+	return &to_vmx(vcpu)->lbr_desc;
+}
+
+struct x86_pmu_lbr *vcpu_to_lbr_records(struct kvm_vcpu *vcpu)
+{
+#ifdef CONFIG_INTEL_TDX_HOST
+	if (is_td_vcpu(vcpu))
+		return &to_tdx(vcpu)->lbr_desc.records;
+#endif
+
+	return &to_vmx(vcpu)->lbr_desc.records;
+}
+
 static void reprogram_fixed_counters(struct kvm_pmu *pmu, u64 data)
 {
 	struct kvm_pmc *pmc;
@@ -171,10 +192,20 @@ static inline struct kvm_pmc *get_fw_gp_pmc(struct kvm_pmu *pmu, u32 msr)
 	return get_gp_pmc(pmu, msr, MSR_IA32_PMC0);
 }
 
+bool intel_pmu_lbr_is_compatible(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu))
+		return false;
+	return cpuid_model_is_consistent(vcpu);
+}
+
 bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu)
 {
 	struct x86_pmu_lbr *lbr = vcpu_to_lbr_records(vcpu);
 
+	if (is_td_vcpu(vcpu))
+		return false;
+
 	return lbr->nr && (vcpu_get_perf_capabilities(vcpu) & PMU_CAP_LBR_FMT);
 }
 
@@ -294,6 +325,9 @@ int intel_pmu_create_guest_lbr_event(struct kvm_vcpu *vcpu)
 					PERF_SAMPLE_BRANCH_USER,
 	};
 
+	if (WARN_ON(is_td_vcpu(vcpu)))
+		return 0;
+
 	if (unlikely(lbr_desc->event)) {
 		__set_bit(INTEL_PMC_IDX_FIXED_VLBR, pmu->pmc_in_use);
 		return 0;
@@ -602,7 +636,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	nested_vmx_pmu_refresh(vcpu,
 			       intel_is_valid_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL, false));
 
-	if (cpuid_model_is_consistent(vcpu))
+	if (intel_pmu_lbr_is_compatible(vcpu))
 		x86_perf_get_lbr(&lbr_desc->records);
 	else
 		lbr_desc->records.nr = 0;
@@ -661,6 +695,9 @@ static void intel_pmu_reset(struct kvm_vcpu *vcpu)
 	struct kvm_pmc *pmc = NULL;
 	int i;
 
+	if (is_td_vcpu(vcpu))
+		return;
+
 	for (i = 0; i < INTEL_PMC_MAX_GENERIC; i++) {
 		pmc = &pmu->gp_counters[i];
 
diff --git a/arch/x86/kvm/vmx/pmu_intel.h b/arch/x86/kvm/vmx/pmu_intel.h
new file mode 100644
index 000000000000..66bba47c1269
--- /dev/null
+++ b/arch/x86/kvm/vmx/pmu_intel.h
@@ -0,0 +1,28 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __KVM_X86_VMX_PMU_INTEL_H
+#define  __KVM_X86_VMX_PMU_INTEL_H
+
+struct lbr_desc *vcpu_to_lbr_desc(struct kvm_vcpu *vcpu);
+struct x86_pmu_lbr *vcpu_to_lbr_records(struct kvm_vcpu *vcpu);
+
+bool intel_pmu_lbr_is_compatible(struct kvm_vcpu *vcpu);
+bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu);
+int intel_pmu_create_guest_lbr_event(struct kvm_vcpu *vcpu);
+
+struct lbr_desc {
+	/* Basic info about guest LBR records. */
+	struct x86_pmu_lbr records;
+
+	/*
+	 * Emulate LBR feature via passthrough LBR registers when the
+	 * per-vcpu guest LBR event is scheduled on the current pcpu.
+	 *
+	 * The records may be inaccurate if the host reclaims the LBR.
+	 */
+	struct perf_event *event;
+
+	/* True if LBRs are marked as not intercepted in the MSR bitmap */
+	bool msr_passthrough;
+};
+
+#endif /* __KVM_X86_VMX_PMU_INTEL_H */
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 8a0793fcc3ab..892e7dc96e99 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -4,6 +4,7 @@
 
 #ifdef CONFIG_INTEL_TDX_HOST
 
+#include "pmu_intel.h"
 #include "tdx_ops.h"
 
 int tdx_module_setup(void);
@@ -33,6 +34,12 @@ struct vcpu_tdx {
 
 	struct tdx_td_page tdvpr;
 	struct tdx_td_page *tdvpx;
+
+	/*
+	 * Dummy to make pmu_intel not corrupt memory.
+	 * TODO: Support PMU for TDX.  Future work.
+	 */
+	struct lbr_desc lbr_desc;
 };
 
 static inline bool is_td(struct kvm *kvm)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b30d73d28e75..1d87885245cc 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2246,7 +2246,7 @@ int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			if ((data & PMU_CAP_LBR_FMT) !=
 			    (vmx_get_perf_capabilities() & PMU_CAP_LBR_FMT))
 				return 1;
-			if (!cpuid_model_is_consistent(vcpu))
+			if (!intel_pmu_lbr_is_compatible(vcpu))
 				return 1;
 		}
 		if (data & PERF_CAP_PEBS_FORMAT) {
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 71bcb486e73f..9feb994e5ea2 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -10,6 +10,7 @@
 #include "capabilities.h"
 #include "kvm_cache_regs.h"
 #include "posted_intr.h"
+#include "pmu_intel.h"
 #include "vmcs.h"
 #include "vmx_ops.h"
 #include "cpuid.h"
@@ -91,31 +92,10 @@ union vmx_exit_reason {
 	u32 full;
 };
 
-#define vcpu_to_lbr_desc(vcpu) (&to_vmx(vcpu)->lbr_desc)
-#define vcpu_to_lbr_records(vcpu) (&to_vmx(vcpu)->lbr_desc.records)
-
 void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu);
-bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu);
 
-int intel_pmu_create_guest_lbr_event(struct kvm_vcpu *vcpu);
 void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu);
 
-struct lbr_desc {
-	/* Basic info about guest LBR records. */
-	struct x86_pmu_lbr records;
-
-	/*
-	 * Emulate LBR feature via passthrough LBR registers when the
-	 * per-vcpu guest LBR event is scheduled on the current pcpu.
-	 *
-	 * The records may be inaccurate if the host reclaims the LBR.
-	 */
-	struct perf_event *event;
-
-	/* True if LBRs are marked as not intercepted in the MSR bitmap */
-	bool msr_passthrough;
-};
-
 /*
  * The nested_vmx structure is part of vcpu_vmx, and holds information we need
  * for correct emulation of VMX (i.e., nested VMX) on this vcpu.
-- 
2.25.1

