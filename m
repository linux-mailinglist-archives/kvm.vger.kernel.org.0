Return-Path: <kvm+bounces-6599-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 10168837934
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:32:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7FC301F27ABB
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 00:32:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D58C55BAE3;
	Mon, 22 Jan 2024 23:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M8+WKLBP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B943B5A78D;
	Mon, 22 Jan 2024 23:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705967717; cv=none; b=E4AjmfC6/lg/6QFisbnbrd1cTCUdDsd4Zl2jwh/HgcKEGUx9KcwpO+HaBr1Xym/twwRjbb0N/JbApdMlBacOrNawqgCNJ6EOU34JEOB8IM9kuf2g6lis9UNgayIPLgRaXhNKjpE/eHVFq13DQENgrTSJp9W5HF0WDEhlnbocafQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705967717; c=relaxed/simple;
	bh=HhKTCaHo97zmDcj50ARDvFfaLEO64qzrVff5QTpaEDw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aEADoKYyXvmgigVArYDupLoRN9z3n3BJYJRGKwAlLI7neQoSmwSgkY05rnmLvcxHPCPiz3tS6KBM+q9eU1fbIS8JOJuBJ90GLFN7HXR4FNHAGxRKAEvYa/WmnoBSgrqJqbYHFD3zBmGbalNuZ9JYgOrttozsQmYorjdRm78C4bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M8+WKLBP; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705967713; x=1737503713;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HhKTCaHo97zmDcj50ARDvFfaLEO64qzrVff5QTpaEDw=;
  b=M8+WKLBPh/mL3QKsH6gzPyZf8MWytEcmJ4ArmMGyFM4PU3tXHRJG61gC
   xIClyuOWCr5hoOB/4ex8emhuJQed7NVdufvXTId7gq7bE0eaREMP9OQ3u
   7CwN9TUi9K0MRD1KEzgQV6eWQUsgDL5hk7Q3fsgTJ+6QiMb3Obh0m3ck/
   Tf80akfCYdCOQJRxZmIIv0FHDhcdI/tCOXINYn1ukRcfV1JNyvaADS8IB
   i3onnpeO4W144exnOsHqkY9Lwq+RhynSKT4EdCVfKQeyqAOi4MFvNq/rQ
   YEbN0+inlvAekcpNqBfP9ldc+9wzxPbApe7JIegL9BU0nJhC+k1+G4qtx
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="1243820"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="1243820"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="819888544"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="819888544"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:11 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com
Subject: [PATCH v18 026/121] KVM: TDX: Make pmu_intel.c ignore guest TD case
Date: Mon, 22 Jan 2024 15:53:02 -0800
Message-Id: <e544cf3ff0371e940b45e9e57e4568a41b0b4c87.1705965635.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1705965634.git.isaku.yamahata@intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Because TDX KVM doesn't support PMU yet (it's future work of TDX KVM
support as another patch series) and pmu_intel.c touches vmx specific
structure in vcpu initialization, as workaround add dummy structure to
struct vcpu_tdx and pmu_intel.c can ignore TDX case.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
v18:
- Removed unnecessary change to vmx.c which caused kernel warning.
---
 arch/x86/kvm/vmx/pmu_intel.c | 46 +++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/pmu_intel.h | 28 ++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.h       |  8 ++++++-
 arch/x86/kvm/vmx/vmx.h       | 32 +------------------------
 4 files changed, 81 insertions(+), 33 deletions(-)
 create mode 100644 arch/x86/kvm/vmx/pmu_intel.h

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index a6216c874729..13851b443916 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -19,6 +19,7 @@
 #include "lapic.h"
 #include "nested.h"
 #include "pmu.h"
+#include "tdx.h"
 
 #define MSR_PMC_FULL_WIDTH_BIT      (MSR_IA32_PMC0 - MSR_IA32_PERFCTR0)
 
@@ -68,6 +69,26 @@ static int fixed_pmc_events[] = {
 	[2] = PSEUDO_ARCH_REFERENCE_CYCLES,
 };
 
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
@@ -179,6 +200,23 @@ static inline struct kvm_pmc *get_fw_gp_pmc(struct kvm_pmu *pmu, u32 msr)
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
@@ -244,6 +282,9 @@ static inline void intel_pmu_release_guest_lbr_event(struct kvm_vcpu *vcpu)
 {
 	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
 
+	if (is_td_vcpu(vcpu))
+		return;
+
 	if (lbr_desc->event) {
 		perf_event_release_kernel(lbr_desc->event);
 		lbr_desc->event = NULL;
@@ -285,6 +326,9 @@ int intel_pmu_create_guest_lbr_event(struct kvm_vcpu *vcpu)
 					PERF_SAMPLE_BRANCH_USER,
 	};
 
+	if (WARN_ON_ONCE(is_td_vcpu(vcpu)))
+		return 0;
+
 	if (unlikely(lbr_desc->event)) {
 		__set_bit(INTEL_PMC_IDX_FIXED_VLBR, pmu->pmc_in_use);
 		return 0;
@@ -578,7 +622,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		INTEL_PMC_MAX_GENERIC, pmu->nr_arch_fixed_counters);
 
 	perf_capabilities = vcpu_get_perf_capabilities(vcpu);
-	if (cpuid_model_is_consistent(vcpu) &&
+	if (intel_pmu_lbr_is_compatible(vcpu) &&
 	    (perf_capabilities & PMU_CAP_LBR_FMT))
 		x86_perf_get_lbr(&lbr_desc->records);
 	else
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
index 184fe394da86..173ed19207fb 100644
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
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index e3b0985bb74a..04ed2a9eada1 100644
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
@@ -93,22 +94,6 @@ union vmx_exit_reason {
 	u32 full;
 };
 
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
@@ -659,21 +644,6 @@ static __always_inline struct vcpu_vmx *to_vmx(struct kvm_vcpu *vcpu)
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


