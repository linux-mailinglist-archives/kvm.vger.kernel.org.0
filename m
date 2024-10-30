Return-Path: <kvm+bounces-30099-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C30559B6CB4
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 20:09:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8277328103E
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 19:09:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC0AA2281F5;
	Wed, 30 Oct 2024 19:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dDp2zYFH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F1841D1506;
	Wed, 30 Oct 2024 19:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730314878; cv=none; b=LYIKknRITNTOoLttGsggRxSPJjucRWtiEbNnCfvD+DZaACxafA7wviLKfAQmymowPPZu+gmCpL1DgMkQrqmJtNf5FRSMPgvDODvde86nUcyfFZP/Cb0RuXMFddmNkiyPcKxJQx6MXVw+j0x+hOQwON9g5ZBaER9H3yfG3aUZu3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730314878; c=relaxed/simple;
	bh=BEDue/QNC2+Q1sz4S/Xu8rWd/5NHgqbk6JjIdzhTmPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XraKe6EntmCxwR547ooRUq1tnEMPqjUhaPCSV6QvMYTc8kDqCN053zJU4NymOtGzac7BYppWCUtJoPWHtrHEdrUaO1nOpentQK0vbalEIcjJagdICPSQA0p7ggpQHJ6K6BCFF4FuMqtEJyIOVEbLTAs1NMD6FzEvdzpueJi7TlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dDp2zYFH; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730314876; x=1761850876;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BEDue/QNC2+Q1sz4S/Xu8rWd/5NHgqbk6JjIdzhTmPg=;
  b=dDp2zYFHkloouEaY8XyWBpdS7QVn1DBHSc+lUHCbwGgepa2pxoRpI8K5
   SAfqhcz3OzWnMfCvLhdBA1AEV6pb4aIcUmK/XlNYbl6L2oAQZUEAPbUut
   Ak4zJKtIgg4iP3DGvL9lg7EQUgHsRXQKvewNZx3XqzWF+SdHsSQAc+uOq
   LXwAGYLq84sOA48o47RsDLU/efV9UxRUYbfPLgzqXHK6A8u7NjVS+N6HR
   8GhwEs0YQHjyY1a9mW+ifTEG0U6Zjq37c74ulonP86/SrOnkPuNIwpzjv
   7takc+6oqhw8AmgbF5U/MmtL3f2XEKInNE7jfeBv0eEbM1X9w1k69gnMU
   g==;
X-CSE-ConnectionGUID: TpiR/5PfRO+XR8PhTPFvDw==
X-CSE-MsgGUID: gdhpFwUCTH6+olAO1Vt1dQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11241"; a="17678829"
X-IronPort-AV: E=Sophos;i="6.11,245,1725346800"; 
   d="scan'208";a="17678829"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 12:01:06 -0700
X-CSE-ConnectionGUID: 3WPS5F1JQFCJxLJDoTKviA==
X-CSE-MsgGUID: dAb0XkRETi6SyJgRy5F9WQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,245,1725346800"; 
   d="scan'208";a="82499442"
Received: from sramkris-mobl1.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.223.186])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 12:01:05 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: rick.p.edgecombe@intel.com,
	yan.y.zhao@intel.com,
	isaku.yamahata@gmail.com,
	kai.huang@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	tony.lindgren@linux.intel.com,
	xiaoyao.li@intel.com,
	reinette.chatre@intel.com,
	Isaku Yamahata <isaku.yamahata@intel.com>
Subject: [PATCH v2 20/25] KVM: TDX: Make pmu_intel.c ignore guest TD case
Date: Wed, 30 Oct 2024 12:00:33 -0700
Message-ID: <20241030190039.77971-21-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDX KVM doesn't support PMU yet, it's future work of TDX KVM support as
another patch series. For now, handle TDX by updating vcpu_to_lbr_desc()
and vcpu_to_lbr_records() to return NULL.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Tony Lindgren <tony.lindgren@linux.intel.com>
Signed-off-by: Tony Lindgren <tony.lindgren@linux.intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
uAPI breakout v2:
 - Make vcpu_to_lbr_desc() to return NULL (Paolo)
 - Drop unecessary ifdefs around is_td_vcpu() (Tony)

uAPI breakout v1:
 - Fix bisectability issues in headers (Kai)
 - Fix rebase error from v19 (Chao Gao)
 - Make helpers static (Tony Lindgren)
 - Improve whitespace (Tony Lindgren)

v18:
 - Removed unnecessary change to vmx.c which caused kernel warning.
---
 arch/x86/kvm/vmx/pmu_intel.c | 50 +++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/pmu_intel.h | 28 ++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.h       | 34 +-----------------------
 3 files changed, 78 insertions(+), 34 deletions(-)
 create mode 100644 arch/x86/kvm/vmx/pmu_intel.h

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 83382a4d1d66..1cd92b43f463 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -19,6 +19,7 @@
 #include "lapic.h"
 #include "nested.h"
 #include "pmu.h"
+#include "tdx.h"
 
 /*
  * Perf's "BASE" is wildly misleading, architectural PMUs use bits 31:16 of ECX
@@ -34,6 +35,22 @@
 
 #define MSR_PMC_FULL_WIDTH_BIT      (MSR_IA32_PMC0 - MSR_IA32_PERFCTR0)
 
+static struct lbr_desc *vcpu_to_lbr_desc(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu))
+		return NULL;
+
+	return &to_vmx(vcpu)->lbr_desc;
+}
+
+static struct x86_pmu_lbr *vcpu_to_lbr_records(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu))
+		return NULL;
+
+	return &to_vmx(vcpu)->lbr_desc.records;
+}
+
 static void reprogram_fixed_counters(struct kvm_pmu *pmu, u64 data)
 {
 	struct kvm_pmc *pmc;
@@ -129,6 +146,22 @@ static inline struct kvm_pmc *get_fw_gp_pmc(struct kvm_pmu *pmu, u32 msr)
 	return get_gp_pmc(pmu, msr, MSR_IA32_PMC0);
 }
 
+static bool intel_pmu_lbr_is_compatible(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu))
+		return false;
+
+	return cpuid_model_is_consistent(vcpu);
+}
+
+bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu))
+		return false;
+
+	return !!vcpu_to_lbr_records(vcpu)->nr;
+}
+
 static bool intel_pmu_is_valid_lbr_msr(struct kvm_vcpu *vcpu, u32 index)
 {
 	struct x86_pmu_lbr *records = vcpu_to_lbr_records(vcpu);
@@ -194,6 +227,9 @@ static inline void intel_pmu_release_guest_lbr_event(struct kvm_vcpu *vcpu)
 {
 	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
 
+	if (!lbr_desc)
+		return;
+
 	if (lbr_desc->event) {
 		perf_event_release_kernel(lbr_desc->event);
 		lbr_desc->event = NULL;
@@ -235,6 +271,9 @@ int intel_pmu_create_guest_lbr_event(struct kvm_vcpu *vcpu)
 					PERF_SAMPLE_BRANCH_USER,
 	};
 
+	if (WARN_ON_ONCE(!lbr_desc))
+		return 0;
+
 	if (unlikely(lbr_desc->event)) {
 		__set_bit(INTEL_PMC_IDX_FIXED_VLBR, pmu->pmc_in_use);
 		return 0;
@@ -466,6 +505,9 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	u64 perf_capabilities;
 	u64 counter_rsvd;
 
+	if (!lbr_desc)
+		return;
+
 	memset(&lbr_desc->records, 0, sizeof(lbr_desc->records));
 
 	/*
@@ -542,7 +584,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		INTEL_PMC_MAX_GENERIC, pmu->nr_arch_fixed_counters);
 
 	perf_capabilities = vcpu_get_perf_capabilities(vcpu);
-	if (cpuid_model_is_consistent(vcpu) &&
+	if (intel_pmu_lbr_is_compatible(vcpu) &&
 	    (perf_capabilities & PMU_CAP_LBR_FMT))
 		memcpy(&lbr_desc->records, &vmx_lbr_caps, sizeof(vmx_lbr_caps));
 	else
@@ -570,6 +612,9 @@ static void intel_pmu_init(struct kvm_vcpu *vcpu)
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
 
+	if (!lbr_desc)
+		return;
+
 	for (i = 0; i < KVM_MAX_NR_INTEL_GP_COUNTERS; i++) {
 		pmu->gp_counters[i].type = KVM_PMC_GP;
 		pmu->gp_counters[i].vcpu = vcpu;
@@ -677,6 +722,9 @@ void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu)
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
 
+	if (WARN_ON_ONCE(!lbr_desc))
+		return;
+
 	if (!lbr_desc->event) {
 		vmx_disable_lbr_msrs_passthrough(vcpu);
 		if (vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR)
diff --git a/arch/x86/kvm/vmx/pmu_intel.h b/arch/x86/kvm/vmx/pmu_intel.h
new file mode 100644
index 000000000000..5620d0882cdc
--- /dev/null
+++ b/arch/x86/kvm/vmx/pmu_intel.h
@@ -0,0 +1,28 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __KVM_X86_VMX_PMU_INTEL_H
+#define  __KVM_X86_VMX_PMU_INTEL_H
+
+#include <linux/kvm_host.h>
+
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
+extern struct x86_pmu_lbr vmx_lbr_caps;
+
+#endif /* __KVM_X86_VMX_PMU_INTEL_H */
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index ad9efe41e691..37a555c6dfbf 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -11,6 +11,7 @@
 
 #include "capabilities.h"
 #include "../kvm_cache_regs.h"
+#include "pmu_intel.h"
 #include "vmcs.h"
 #include "vmx_ops.h"
 #include "../cpuid.h"
@@ -90,24 +91,6 @@ union vmx_exit_reason {
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
-extern struct x86_pmu_lbr vmx_lbr_caps;
-
 /*
  * The nested_vmx structure is part of vcpu_vmx, and holds information we need
  * for correct emulation of VMX (i.e., nested VMX) on this vcpu.
@@ -659,21 +642,6 @@ static __always_inline struct vcpu_vmx *to_vmx(struct kvm_vcpu *vcpu)
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
2.47.0


