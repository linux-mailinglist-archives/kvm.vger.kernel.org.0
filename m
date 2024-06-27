Return-Path: <kvm+bounces-20537-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B7702917D9F
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 12:18:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 717FE287795
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 10:18:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F45A17F399;
	Wed, 26 Jun 2024 10:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DEX7zWd5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 799A917DE1F;
	Wed, 26 Jun 2024 10:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719397024; cv=none; b=lpfahpboAomKsYrqGBnHGLjkLqHAwkyMGHUH5bFhGBCHOrYoqrOqzCNpCt4E8b5p4oSJcuqmnrM575ktmPLo1iC0QoXq5jGnsj53fc9chZB8KbLdE92sRoVi7B5+xJgQYeQdfAIQJBLGsKgBNqqC/MDAskOMkh9AFScMhZOSTAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719397024; c=relaxed/simple;
	bh=DBcS12dl2S8ZtDuio6vUh2j01kQAoIhLmL5EauDOA+k=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Kmk0Hqc/la/K+MvybA9tJYrfraLqOXN1cxQ9rghmRlOd0rUdEovsEN4xvV29x/rObzfrYNNgojaSMwd9NVOUXhdL8+i9WXmthrUNK+kqT+x52Qm6M2HDeEPgDnBnHeNVB6wdi3TTlJ2K4vlfch0gU0+dyh5x/kSy9r5SSsqXlgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DEX7zWd5; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719397022; x=1750933022;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=DBcS12dl2S8ZtDuio6vUh2j01kQAoIhLmL5EauDOA+k=;
  b=DEX7zWd5B72J3BUf7mkrfeTvQ10Ig6vX9lxMyAOhcK+gtBJ9f/d2kmYf
   6r+zEc9FIYhSD4p3PiFZ64c9f2ck7lKLxsKDOYIMmusKj7FuEmC1SG4H6
   W3/cuFRY5mIsjCdr+OD7/ep+uKAOXsGU5PQli5mXeoHRr/pWbNNe/ly74
   SFMSSqPg9UJdkkzmjNR6mhdhfUvT1DkxBSECUCTAvCjpgXAdWKXsWyKrK
   ZydOFiiv9jJ4UiX53EljNcIcnsY7xPPrGv9nM+TEp4Hp+FByTwlMcHGsS
   A/UrK+pntfn+0YuCbopx5XBc7Zh1HaDmNHCuZPb2mAQL6EwTXbCCTReo3
   w==;
X-CSE-ConnectionGUID: sxq6iWLLTviily+XUbJW2g==
X-CSE-MsgGUID: ud4jmGbOSziwWDNdmfi8Zw==
X-IronPort-AV: E=McAfee;i="6700,10204,11114"; a="16602452"
X-IronPort-AV: E=Sophos;i="6.08,266,1712646000"; 
   d="scan'208";a="16602452"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2024 03:17:01 -0700
X-CSE-ConnectionGUID: kPz4I1E/TfCRsUQcR8zqbw==
X-CSE-MsgGUID: RrxNP6DsRIqo1vfupmxuVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,266,1712646000"; 
   d="scan'208";a="43933191"
Received: from unknown (HELO dell-3650.sh.intel.com) ([10.239.159.147])
  by fmviesa008.fm.intel.com with ESMTP; 26 Jun 2024 03:17:00 -0700
From: Dapeng Mi <dapeng1.mi@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jim Mattson <jmattson@google.com>,
	Mingwei Zhang <mizhang@google.com>,
	Xiong Zhang <xiong.y.zhang@intel.com>,
	Zhenyu Wang <zhenyuw@linux.intel.com>,
	Like Xu <like.xu.linux@gmail.com>,
	Jinrong Liang <cloudliang@tencent.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [Patch v2 1/2] KVM: x86/pmu: Introduce distinct macros for GP/fixed counter max number
Date: Thu, 27 Jun 2024 10:17:55 +0800
Message-Id: <20240627021756.144815-1-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refine the macros which define maximum General Purpose (GP) and fixed
counter numbers.

Currently the macro KVM_INTEL_PMC_MAX_GENERIC is used to represent the
maximum supported General Purpose (GP) counter number ambiguously across
Intel and AMD platforms. This would cause issues if AMD begins to support
more GP counters than Intel.

Thus a bunch of new macros including vendor specific and vendor
independent are introduced to replace the old macros. The vendor
independent macros are used in x86 common code to hide vendor difference
and eliminate the ambiguity.

No logic changes are introduced in this patch.

Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 arch/x86/include/asm/kvm_host.h | 20 ++++++++++++--------
 arch/x86/kvm/pmu.c              |  2 +-
 arch/x86/kvm/pmu.h              |  2 +-
 arch/x86/kvm/svm/pmu.c          |  7 +++----
 arch/x86/kvm/vmx/pmu_intel.c    | 10 +++++-----
 arch/x86/kvm/x86.c              | 15 +++++++++------
 6 files changed, 31 insertions(+), 25 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 57440bda4dc4..d565c6f11fdf 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -533,12 +533,16 @@ struct kvm_pmc {
 };
 
 /* More counters may conflict with other existing Architectural MSRs */
-#define KVM_INTEL_PMC_MAX_GENERIC	8
-#define MSR_ARCH_PERFMON_PERFCTR_MAX	(MSR_ARCH_PERFMON_PERFCTR0 + KVM_INTEL_PMC_MAX_GENERIC - 1)
-#define MSR_ARCH_PERFMON_EVENTSEL_MAX	(MSR_ARCH_PERFMON_EVENTSEL0 + KVM_INTEL_PMC_MAX_GENERIC - 1)
-#define KVM_PMC_MAX_FIXED	3
-#define MSR_ARCH_PERFMON_FIXED_CTR_MAX	(MSR_ARCH_PERFMON_FIXED_CTR0 + KVM_PMC_MAX_FIXED - 1)
-#define KVM_AMD_PMC_MAX_GENERIC	6
+#define KVM_MAX(a, b)	((a) >= (b) ? (a) : (b))
+#define KVM_MAX_NR_INTEL_GP_COUNTERS	8
+#define KVM_MAX_NR_AMD_GP_COUNTERS	6
+#define KVM_MAX_NR_GP_COUNTERS		KVM_MAX(KVM_MAX_NR_INTEL_GP_COUNTERS, \
+						KVM_MAX_NR_AMD_GP_COUNTERS)
+
+#define KVM_MAX_NR_INTEL_FIXED_COUTNERS	3
+#define KVM_MAX_NR_AMD_FIXED_COUTNERS	0
+#define KVM_MAX_NR_FIXED_COUNTERS	KVM_MAX(KVM_MAX_NR_INTEL_FIXED_COUTNERS, \
+						KVM_MAX_NR_AMD_FIXED_COUTNERS)
 
 struct kvm_pmu {
 	u8 version;
@@ -554,8 +558,8 @@ struct kvm_pmu {
 	u64 global_status_rsvd;
 	u64 reserved_bits;
 	u64 raw_event_mask;
-	struct kvm_pmc gp_counters[KVM_INTEL_PMC_MAX_GENERIC];
-	struct kvm_pmc fixed_counters[KVM_PMC_MAX_FIXED];
+	struct kvm_pmc gp_counters[KVM_MAX_NR_GP_COUNTERS];
+	struct kvm_pmc fixed_counters[KVM_MAX_NR_FIXED_COUNTERS];
 
 	/*
 	 * Overlay the bitmap with a 64-bit atomic so that all bits can be
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 42422a73a348..47a46283c866 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -69,7 +69,7 @@ static const struct x86_cpu_id vmx_pebs_pdist_cpu[] = {
  *        code. Each pmc, stored in kvm_pmc.idx field, is unique across
  *        all perf counters (both gp and fixed). The mapping relationship
  *        between pmc and perf counters is as the following:
- *        * Intel: [0 .. KVM_INTEL_PMC_MAX_GENERIC-1] <=> gp counters
+ *        * Intel: [0 .. KVM_MAX_NR_INTEL_GP_COUNTERS-1] <=> gp counters
  *                 [KVM_FIXED_PMC_BASE_IDX .. KVM_FIXED_PMC_BASE_IDX + 2] <=> fixed
  *        * AMD:   [0 .. AMD64_NUM_COUNTERS-1] and, for families 15H
  *          and later, [0 .. AMD64_NUM_COUNTERS_CORE-1] <=> gp counters
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index d54741fe4bdd..ad89d0bd6005 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -219,7 +219,7 @@ static inline void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops)
 	kvm_pmu_cap.num_counters_gp = min(kvm_pmu_cap.num_counters_gp,
 					  pmu_ops->MAX_NR_GP_COUNTERS);
 	kvm_pmu_cap.num_counters_fixed = min(kvm_pmu_cap.num_counters_fixed,
-					     KVM_PMC_MAX_FIXED);
+					     KVM_MAX_NR_FIXED_COUNTERS);
 
 	kvm_pmu_eventsel.INSTRUCTIONS_RETIRED =
 		perf_get_hw_event_config(PERF_COUNT_HW_INSTRUCTIONS);
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 6e908bdc3310..22d5a65b410c 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -217,10 +217,9 @@ static void amd_pmu_init(struct kvm_vcpu *vcpu)
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	int i;
 
-	BUILD_BUG_ON(KVM_AMD_PMC_MAX_GENERIC > AMD64_NUM_COUNTERS_CORE);
-	BUILD_BUG_ON(KVM_AMD_PMC_MAX_GENERIC > INTEL_PMC_MAX_GENERIC);
+	BUILD_BUG_ON(KVM_MAX_NR_AMD_GP_COUNTERS > AMD64_NUM_COUNTERS_CORE);
 
-	for (i = 0; i < KVM_AMD_PMC_MAX_GENERIC ; i++) {
+	for (i = 0; i < KVM_MAX_NR_AMD_GP_COUNTERS; i++) {
 		pmu->gp_counters[i].type = KVM_PMC_GP;
 		pmu->gp_counters[i].vcpu = vcpu;
 		pmu->gp_counters[i].idx = i;
@@ -238,6 +237,6 @@ struct kvm_pmu_ops amd_pmu_ops __initdata = {
 	.refresh = amd_pmu_refresh,
 	.init = amd_pmu_init,
 	.EVENTSEL_EVENT = AMD64_EVENTSEL_EVENT,
-	.MAX_NR_GP_COUNTERS = KVM_AMD_PMC_MAX_GENERIC,
+	.MAX_NR_GP_COUNTERS = KVM_MAX_NR_AMD_GP_COUNTERS,
 	.MIN_NR_GP_COUNTERS = AMD64_NUM_COUNTERS,
 };
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index fb5cbd6cbeff..83382a4d1d66 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -436,8 +436,8 @@ static __always_inline u64 intel_get_fixed_pmc_eventsel(unsigned int index)
 	};
 	u64 eventsel;
 
-	BUILD_BUG_ON(ARRAY_SIZE(fixed_pmc_perf_ids) != KVM_PMC_MAX_FIXED);
-	BUILD_BUG_ON(index >= KVM_PMC_MAX_FIXED);
+	BUILD_BUG_ON(ARRAY_SIZE(fixed_pmc_perf_ids) != KVM_MAX_NR_INTEL_FIXED_COUTNERS);
+	BUILD_BUG_ON(index >= KVM_MAX_NR_INTEL_FIXED_COUTNERS);
 
 	/*
 	 * Yell if perf reports support for a fixed counter but perf doesn't
@@ -570,14 +570,14 @@ static void intel_pmu_init(struct kvm_vcpu *vcpu)
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
 
-	for (i = 0; i < KVM_INTEL_PMC_MAX_GENERIC; i++) {
+	for (i = 0; i < KVM_MAX_NR_INTEL_GP_COUNTERS; i++) {
 		pmu->gp_counters[i].type = KVM_PMC_GP;
 		pmu->gp_counters[i].vcpu = vcpu;
 		pmu->gp_counters[i].idx = i;
 		pmu->gp_counters[i].current_config = 0;
 	}
 
-	for (i = 0; i < KVM_PMC_MAX_FIXED; i++) {
+	for (i = 0; i < KVM_MAX_NR_INTEL_FIXED_COUTNERS; i++) {
 		pmu->fixed_counters[i].type = KVM_PMC_FIXED;
 		pmu->fixed_counters[i].vcpu = vcpu;
 		pmu->fixed_counters[i].idx = i + KVM_FIXED_PMC_BASE_IDX;
@@ -737,6 +737,6 @@ struct kvm_pmu_ops intel_pmu_ops __initdata = {
 	.deliver_pmi = intel_pmu_deliver_pmi,
 	.cleanup = intel_pmu_cleanup,
 	.EVENTSEL_EVENT = ARCH_PERFMON_EVENTSEL_EVENT,
-	.MAX_NR_GP_COUNTERS = KVM_INTEL_PMC_MAX_GENERIC,
+	.MAX_NR_GP_COUNTERS = KVM_MAX_NR_INTEL_GP_COUNTERS,
 	.MIN_NR_GP_COUNTERS = 1,
 };
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6ad19d913d31..dea7058ebdd0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1451,7 +1451,7 @@ static const u32 msrs_to_save_pmu[] = {
 	MSR_CORE_PERF_GLOBAL_CTRL,
 	MSR_IA32_PEBS_ENABLE, MSR_IA32_DS_AREA, MSR_PEBS_DATA_CFG,
 
-	/* This part of MSRs should match KVM_INTEL_PMC_MAX_GENERIC. */
+	/* This part of MSRs should match KVM_MAX_NR_INTEL_GP_COUNTERS. */
 	MSR_ARCH_PERFMON_PERFCTR0, MSR_ARCH_PERFMON_PERFCTR1,
 	MSR_ARCH_PERFMON_PERFCTR0 + 2, MSR_ARCH_PERFMON_PERFCTR0 + 3,
 	MSR_ARCH_PERFMON_PERFCTR0 + 4, MSR_ARCH_PERFMON_PERFCTR0 + 5,
@@ -1464,7 +1464,7 @@ static const u32 msrs_to_save_pmu[] = {
 	MSR_K7_EVNTSEL0, MSR_K7_EVNTSEL1, MSR_K7_EVNTSEL2, MSR_K7_EVNTSEL3,
 	MSR_K7_PERFCTR0, MSR_K7_PERFCTR1, MSR_K7_PERFCTR2, MSR_K7_PERFCTR3,
 
-	/* This part of MSRs should match KVM_AMD_PMC_MAX_GENERIC. */
+	/* This part of MSRs should match KVM_MAX_NR_AMD_GP_COUNTERS. */
 	MSR_F15H_PERF_CTL0, MSR_F15H_PERF_CTL1, MSR_F15H_PERF_CTL2,
 	MSR_F15H_PERF_CTL3, MSR_F15H_PERF_CTL4, MSR_F15H_PERF_CTL5,
 	MSR_F15H_PERF_CTR0, MSR_F15H_PERF_CTR1, MSR_F15H_PERF_CTR2,
@@ -7432,17 +7432,20 @@ static void kvm_probe_msr_to_save(u32 msr_index)
 		     intel_pt_validate_hw_cap(PT_CAP_num_address_ranges) * 2))
 			return;
 		break;
-	case MSR_ARCH_PERFMON_PERFCTR0 ... MSR_ARCH_PERFMON_PERFCTR_MAX:
+	case MSR_ARCH_PERFMON_PERFCTR0 ...
+	     MSR_ARCH_PERFMON_PERFCTR0 + KVM_MAX_NR_GP_COUNTERS - 1:
 		if (msr_index - MSR_ARCH_PERFMON_PERFCTR0 >=
 		    kvm_pmu_cap.num_counters_gp)
 			return;
 		break;
-	case MSR_ARCH_PERFMON_EVENTSEL0 ... MSR_ARCH_PERFMON_EVENTSEL_MAX:
+	case MSR_ARCH_PERFMON_EVENTSEL0 ...
+	     MSR_ARCH_PERFMON_EVENTSEL0 + KVM_MAX_NR_GP_COUNTERS - 1:
 		if (msr_index - MSR_ARCH_PERFMON_EVENTSEL0 >=
 		    kvm_pmu_cap.num_counters_gp)
 			return;
 		break;
-	case MSR_ARCH_PERFMON_FIXED_CTR0 ... MSR_ARCH_PERFMON_FIXED_CTR_MAX:
+	case MSR_ARCH_PERFMON_FIXED_CTR0 ...
+	     MSR_ARCH_PERFMON_FIXED_CTR0 + KVM_MAX_NR_FIXED_COUNTERS - 1:
 		if (msr_index - MSR_ARCH_PERFMON_FIXED_CTR0 >=
 		    kvm_pmu_cap.num_counters_fixed)
 			return;
@@ -7473,7 +7476,7 @@ static void kvm_init_msr_lists(void)
 {
 	unsigned i;
 
-	BUILD_BUG_ON_MSG(KVM_PMC_MAX_FIXED != 3,
+	BUILD_BUG_ON_MSG(KVM_MAX_NR_FIXED_COUNTERS != 3,
 			 "Please update the fixed PMCs in msrs_to_save_pmu[]");
 
 	num_msrs_to_save = 0;

base-commit: 0ce958282e66b3d1882e2bb2f503a5e2cebcc3ef
-- 
2.34.1


