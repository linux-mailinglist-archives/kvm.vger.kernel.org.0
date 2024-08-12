Return-Path: <kvm+bounces-23909-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DA1194F9EE
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 00:53:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 938C31C20C34
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 22:53:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17FD11A00F1;
	Mon, 12 Aug 2024 22:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hnp3OL4m"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9836F19E83E;
	Mon, 12 Aug 2024 22:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723502924; cv=none; b=s3MP8Uu/XttAaJC/HOBQha01X1VVOtl5YKz+krKiMls9FX+ti68k98Clh8WfpUjWx9xPOQaTPhYTIDpIxWv+plB0fTtXr0VP/baxcCX7+Ct0hny0AldStYIna7kbNLp34OaLbCvx+HTT3j+AGesdx/R3ZyVr7Q+KkZ9EW6DHkdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723502924; c=relaxed/simple;
	bh=bccW5CWtw/8alFuLFBB3Kt/y/VkostqPZ1hIk3f9fyU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RT++FfpeRlLuD7tIKSjWkR9J1aA+WVBLaElmXTsbMtEA0dP7ixfRRYcXqgsCuvW4Kjfu4Hcdfqi132ZFKerPxVcLD7QDeTcCaiuOa17TXsEtOOlGpmhN9skm6QeM0qGwbJONqgZMD78o0esKs6yXEQLd8i2RkNvcKoB6GCfgqyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hnp3OL4m; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723502921; x=1755038921;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bccW5CWtw/8alFuLFBB3Kt/y/VkostqPZ1hIk3f9fyU=;
  b=hnp3OL4mJbRbbu9wZWItWIDnSlevb1uCjA/2Q1P8GiVR/oXVk22Pfn6w
   kTcAPqdEC5rqfiPLn+UI+knIfTNpErte/XTK4eARKvLekmMMDAf8fnllJ
   XAmtJkDuBaK8Ymusw+pGxsfuKGF49fASB9KH0V9fcofR5ykh3Bz8PX0VM
   hdYo3JAoChz9iffrJiAQSPNhIkvwUOGanRudv9kctVRKXHigtkbvUtveZ
   dPXq5yEr0yJ66Qwqg3ZVu5eeXaIBbK1VUtSy1pTlqkhlrh4ZjFxECvwA7
   mZKKF5Sf0jbz/1SInp1YuXghoHzWblOCIK5LN7ZCYvIv4EbSdcyKfehzV
   A==;
X-CSE-ConnectionGUID: IbrtmWERTeSW5k0KI01kPQ==
X-CSE-MsgGUID: NtuizGEeQwWohOKZhqWnOA==
X-IronPort-AV: E=McAfee;i="6700,10204,11162"; a="33041426"
X-IronPort-AV: E=Sophos;i="6.09,284,1716274800"; 
   d="scan'208";a="33041426"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 15:48:36 -0700
X-CSE-ConnectionGUID: CgxBVwi0R7mYqYFA/oa8zw==
X-CSE-MsgGUID: yYjnmLgvS7GY5QwQSN7FWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,284,1716274800"; 
   d="scan'208";a="59008422"
Received: from jdoman-desk1.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.222.53])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 15:48:34 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	isaku.yamahata@gmail.com,
	tony.lindgren@linux.intel.com,
	xiaoyao.li@intel.com,
	linux-kernel@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	Isaku Yamahata <isaku.yamahata@intel.com>
Subject: [PATCH 15/25] KVM: TDX: Make pmu_intel.c ignore guest TD case
Date: Mon, 12 Aug 2024 15:48:10 -0700
Message-Id: <20240812224820.34826-16-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
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
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
uAPI breakout v1:
 - Fix bisectability issues in headers (Kai)
 - Fix rebase error from v19 (Chao Gao)
 - Make helpers static (Tony Lindgren)
 - Improve whitespace (Tony Lindgren)

v18:
 - Removed unnecessary change to vmx.c which caused kernel warning.
---
 arch/x86/kvm/vmx/pmu_intel.c | 45 +++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/pmu_intel.h | 28 ++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.h       |  8 +++++++
 arch/x86/kvm/vmx/vmx.h       | 34 +--------------------------
 4 files changed, 81 insertions(+), 34 deletions(-)
 create mode 100644 arch/x86/kvm/vmx/pmu_intel.h

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 83382a4d1d66..e4ae76d5d424 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -19,6 +19,7 @@
 #include "lapic.h"
 #include "nested.h"
 #include "pmu.h"
+#include "tdx.h"
 
 /*
  * Perf's "BASE" is wildly misleading, architectural PMUs use bits 31:16 of ECX
@@ -34,6 +35,26 @@
 
 #define MSR_PMC_FULL_WIDTH_BIT      (MSR_IA32_PMC0 - MSR_IA32_PERFCTR0)
 
+static struct lbr_desc *vcpu_to_lbr_desc(struct kvm_vcpu *vcpu)
+{
+#ifdef CONFIG_INTEL_TDX_HOST
+	if (is_td_vcpu(vcpu))
+		return &to_tdx(vcpu)->lbr_desc;
+#endif
+
+	return &to_vmx(vcpu)->lbr_desc;
+}
+
+static struct x86_pmu_lbr *vcpu_to_lbr_records(struct kvm_vcpu *vcpu)
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
@@ -129,6 +150,22 @@ static inline struct kvm_pmc *get_fw_gp_pmc(struct kvm_pmu *pmu, u32 msr)
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
@@ -194,6 +231,9 @@ static inline void intel_pmu_release_guest_lbr_event(struct kvm_vcpu *vcpu)
 {
 	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
 
+	if (is_td_vcpu(vcpu))
+		return;
+
 	if (lbr_desc->event) {
 		perf_event_release_kernel(lbr_desc->event);
 		lbr_desc->event = NULL;
@@ -235,6 +275,9 @@ int intel_pmu_create_guest_lbr_event(struct kvm_vcpu *vcpu)
 					PERF_SAMPLE_BRANCH_USER,
 	};
 
+	if (WARN_ON_ONCE(is_td_vcpu(vcpu)))
+		return 0;
+
 	if (unlikely(lbr_desc->event)) {
 		__set_bit(INTEL_PMC_IDX_FIXED_VLBR, pmu->pmc_in_use);
 		return 0;
@@ -542,7 +585,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		INTEL_PMC_MAX_GENERIC, pmu->nr_arch_fixed_counters);
 
 	perf_capabilities = vcpu_get_perf_capabilities(vcpu);
-	if (cpuid_model_is_consistent(vcpu) &&
+	if (intel_pmu_lbr_is_compatible(vcpu) &&
 	    (perf_capabilities & PMU_CAP_LBR_FMT))
 		memcpy(&lbr_desc->records, &vmx_lbr_caps, sizeof(vmx_lbr_caps));
 	else
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
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 8912cb6d5bc2..ca948f26b755 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -10,6 +10,8 @@ void tdx_cleanup(void);
 
 extern bool enable_tdx;
 
+#include "pmu_intel.h"
+
 struct kvm_tdx {
 	struct kvm kvm;
 
@@ -27,6 +29,12 @@ struct vcpu_tdx {
 	struct kvm_vcpu	vcpu;
 
 	unsigned long tdvpr_pa;
+
+	/*
+	 * Dummy to make pmu_intel not corrupt memory.
+	 * TODO: Support PMU for TDX.  Future work.
+	 */
+	struct lbr_desc lbr_desc;
 };
 
 static inline bool is_td(struct kvm *kvm)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index d91c778affd4..07c64731eb37 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -11,6 +11,7 @@
 
 #include "capabilities.h"
 #include "../kvm_cache_regs.h"
+#include "pmu_intel.h"
 #include "vmcs.h"
 #include "vmx_ops.h"
 #include "../cpuid.h"
@@ -94,24 +95,6 @@ union vmx_exit_reason {
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
@@ -665,21 +648,6 @@ static __always_inline struct vcpu_vmx *to_vmx(struct kvm_vcpu *vcpu)
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
2.34.1


