Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C812B6A3C71
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 09:24:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbjB0IYc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 03:24:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjB0IYM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 03:24:12 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95142EC50;
        Mon, 27 Feb 2023 00:24:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677486249; x=1709022249;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aUkxk0K+ujM2vXAltuKHLqNEsWK1nhlL3i5SZD9Eemg=;
  b=k8xV4BU8nj7T4b4gMDQlkzLq1nrvUBY7buCrApA6MMnWZ/2X+b8rBpNX
   eDih0Yiw/ACOCKNXfsgy1wHHlLIlygNq04bDzQf1Q6hL6wikApiDhzDgF
   A5YpUbPkL6fvjY0k4gh2ARXCIs4lEv0Ag1m4dWuTAqzhESTr06ovF9DsG
   GNMbZWQVcD/Gp3gF/GX/9k3HJmrOK4OjY1EW7lDMg/L2c+zvM7k+bXiNr
   3MgoOXtyl+yDDSEq4fInCxqKIJnkB3jxNIsxOo8lRbjWBBqDg4ASydmUv
   Pwe5he6lQetZPFDV7UtaydKIf+TY0pKAK0rP/seA163X8FbvBDog/0Nuu
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="317608719"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="317608719"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:03 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="783242060"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="783242060"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:03 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: [PATCH v12 015/106] KVM: TDX: Make pmu_intel.c ignore guest TD case
Date:   Mon, 27 Feb 2023 00:22:14 -0800
Message-Id: <0fbac4f1a4c25536cd53ad2194ee1b25d17d1702.1677484918.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1677484918.git.isaku.yamahata@intel.com>
References: <cover.1677484918.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
 arch/x86/kvm/vmx/pmu_intel.c | 46 +++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/pmu_intel.h | 28 ++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.h       |  8 ++++++-
 arch/x86/kvm/vmx/vmx.c       |  2 +-
 arch/x86/kvm/vmx/vmx.h       | 32 +------------------------
 5 files changed, 82 insertions(+), 34 deletions(-)
 create mode 100644 arch/x86/kvm/vmx/pmu_intel.h

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index efce9ad70e4e..39f43b0290c5 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -19,6 +19,7 @@
 #include "lapic.h"
 #include "nested.h"
 #include "pmu.h"
+#include "tdx.h"
 
 #define MSR_PMC_FULL_WIDTH_BIT      (MSR_IA32_PMC0 - MSR_IA32_PERFCTR0)
 
@@ -37,6 +38,26 @@ static struct kvm_event_hw_type_mapping intel_arch_events[] = {
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
@@ -169,6 +190,23 @@ static inline struct kvm_pmc *get_fw_gp_pmc(struct kvm_pmu *pmu, u32 msr)
 	return get_gp_pmc(pmu, msr, MSR_IA32_PMC0);
 }
 
+bool intel_pmu_lbr_is_compatible(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu))
+		return false;
+	return cpuid_model_is_consistent(vcpu);
+}
+
+bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu)
+{
+	struct x86_pmu_lbr *lbr = vcpu_to_lbr_records(vcpu);
+
+	if (is_td_vcpu(vcpu))
+		return false;
+
+	return lbr->nr && (vcpu_get_perf_capabilities(vcpu) & PMU_CAP_LBR_FMT);
+}
+
 static bool intel_pmu_is_valid_lbr_msr(struct kvm_vcpu *vcpu, u32 index)
 {
 	struct x86_pmu_lbr *records = vcpu_to_lbr_records(vcpu);
@@ -279,6 +317,9 @@ int intel_pmu_create_guest_lbr_event(struct kvm_vcpu *vcpu)
 					PERF_SAMPLE_BRANCH_USER,
 	};
 
+	if (WARN_ON_ONCE(is_td_vcpu(vcpu)))
+		return 0;
+
 	if (unlikely(lbr_desc->event)) {
 		__set_bit(INTEL_PMC_IDX_FIXED_VLBR, pmu->pmc_in_use);
 		return 0;
@@ -588,7 +629,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		INTEL_PMC_MAX_GENERIC, pmu->nr_arch_fixed_counters);
 
 	perf_capabilities = vcpu_get_perf_capabilities(vcpu);
-	if (cpuid_model_is_consistent(vcpu) &&
+	if (intel_pmu_lbr_is_compatible(vcpu) &&
 	    (perf_capabilities & PMU_CAP_LBR_FMT))
 		x86_perf_get_lbr(&lbr_desc->records);
 	else
@@ -644,6 +685,9 @@ static void intel_pmu_reset(struct kvm_vcpu *vcpu)
 	struct kvm_pmc *pmc = NULL;
 	int i;
 
+	if (is_td_vcpu(vcpu))
+		return;
+
 	for (i = 0; i < KVM_INTEL_PMC_MAX_GENERIC; i++) {
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
index 1e00e75b1c5e..5728820fed5e 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -4,6 +4,7 @@
 
 #ifdef CONFIG_INTEL_TDX_HOST
 
+#include "pmu_intel.h"
 #include "tdx_ops.h"
 
 struct kvm_tdx {
@@ -21,7 +22,12 @@ struct kvm_tdx {
 
 struct vcpu_tdx {
 	struct kvm_vcpu	vcpu;
-	/* TDX specific members follow. */
+
+	/*
+	 * Dummy to make pmu_intel not corrupt memory.
+	 * TODO: Support PMU for TDX.  Future work.
+	 */
+	struct lbr_desc lbr_desc;
 };
 
 static inline bool is_td(struct kvm *kvm)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index bddbdd2988f4..5d2ff4d964bd 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2434,7 +2434,7 @@ int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			if ((data & PMU_CAP_LBR_FMT) !=
 			    (kvm_caps.supported_perf_cap & PMU_CAP_LBR_FMT))
 				return 1;
-			if (!cpuid_model_is_consistent(vcpu))
+			if (!intel_pmu_lbr_is_compatible(vcpu))
 				return 1;
 		}
 		if (data & PERF_CAP_PEBS_FORMAT) {
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index a3da84f4ea45..d49d0ace9fb8 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -11,6 +11,7 @@
 #include "capabilities.h"
 #include "../kvm_cache_regs.h"
 #include "posted_intr.h"
+#include "pmu_intel.h"
 #include "vmcs.h"
 #include "vmx_ops.h"
 #include "../cpuid.h"
@@ -105,22 +106,6 @@ static inline bool intel_pmu_has_perf_global_ctrl(struct kvm_pmu *pmu)
 	return pmu->version > 1;
 }
 
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
@@ -650,21 +635,6 @@ static inline struct vcpu_vmx *to_vmx(struct kvm_vcpu *vcpu)
 	return container_of(vcpu, struct vcpu_vmx, vcpu);
 }
 
-static inline struct lbr_desc *vcpu_to_lbr_desc(struct kvm_vcpu *vcpu)
-{
-	return &to_vmx(vcpu)->lbr_desc;
-}
-
-static inline struct x86_pmu_lbr *vcpu_to_lbr_records(struct kvm_vcpu *vcpu)
-{
-	return &vcpu_to_lbr_desc(vcpu)->records;
-}
-
-static inline bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu)
-{
-	return !!vcpu_to_lbr_records(vcpu)->nr;
-}
-
 void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu);
 int intel_pmu_create_guest_lbr_event(struct kvm_vcpu *vcpu);
 void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu);
-- 
2.25.1

