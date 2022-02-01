Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DAFF4A63C4
	for <lists+kvm@lfdr.de>; Tue,  1 Feb 2022 19:26:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237152AbiBAS02 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 13:26:28 -0500
Received: from mga09.intel.com ([134.134.136.24]:60474 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236079AbiBAS01 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Feb 2022 13:26:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643739987; x=1675275987;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=dV2iXUGHBYz0+bDQ60uKmH98uz1po4B9Da1wpjks3iM=;
  b=H9g6s8jMnEeSNpIPHpKlt/eANydYZakhT8/CLX2JmlGCcISU3y1etcef
   l1cQhFUJxRFnX2pRsJJxRC+0irUq4A7Ucr874dy8LukX1QEdGmTaoGz6Z
   WuhvomZHqJFJ+eN6pgsPNaHqSQjgEnDle36xs88j5DksSLrWpkC2flqDD
   hzZQXl1Q3NEwAEw39RifCt5YHXgurJK1mdAT9HL9zekdpLNlGdki0wc7x
   AjP8PqMgHkxKBjei747FAHydyUme4o4p02ts/aRRAmec9qFQJ41BUdYaG
   veQuCV/Wa34OhvmuFaUZ2ldRitXZ5Q42K65jO0nB1mmwMBdcGtg2U6dw+
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10245"; a="247527586"
X-IronPort-AV: E=Sophos;i="5.88,334,1635231600"; 
   d="scan'208";a="247527586"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2022 10:26:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,334,1635231600"; 
   d="scan'208";a="565681651"
Received: from otc-lr-04.jf.intel.com ([10.54.39.41])
  by orsmga001.jf.intel.com with ESMTP; 01 Feb 2022 10:26:12 -0800
From:   kan.liang@linux.intel.com
To:     peterz@infradead.org, mingo@redhat.com, acme@kernel.org,
        linux-kernel@vger.kernel.org
Cc:     ak@linux.intel.com, Wei Wang <wei.w.wang@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH 2/3] KVM: x86: use the KVM side max supported fixed counter
Date:   Tue,  1 Feb 2022 13:23:22 -0800
Message-Id: <1643750603-100733-2-git-send-email-kan.liang@linux.intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1643750603-100733-1-git-send-email-kan.liang@linux.intel.com>
References: <1643750603-100733-1-git-send-email-kan.liang@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wei Wang <wei.w.wang@intel.com>

KVM vPMU doesn't support to emulate all the fixed counters that the
host PMU driver has supported, e.g. the fixed counter 3 used by
Topdown metrics hasn't been supported by KVM so far.

Rename MAX_FIXED_COUNTERS to KVM_PMC_MAX_FIXED to have a more
straightforward naming convention as INTEL_PMC_MAX_FIXED used by the
host PMU driver, and fix vPMU to use the KVM side KVM_PMC_MAX_FIXED
for the virtual fixed counter emulation, instead of the host side
INTEL_PMC_MAX_FIXED.

Signed-off-by: Wei Wang <wei.w.wang@intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
---
 arch/x86/include/asm/kvm_host.h | 3 ++-
 arch/x86/kvm/cpuid.c            | 3 ++-
 arch/x86/kvm/pmu.h              | 2 --
 arch/x86/kvm/vmx/pmu_intel.c    | 4 ++--
 arch/x86/kvm/x86.c              | 2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1384517..2ce8456 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -498,6 +498,7 @@ struct kvm_pmc {
 	bool intr;
 };
 
+#define KVM_PMC_MAX_FIXED	3
 struct kvm_pmu {
 	unsigned nr_arch_gp_counters;
 	unsigned nr_arch_fixed_counters;
@@ -511,7 +512,7 @@ struct kvm_pmu {
 	u64 reserved_bits;
 	u8 version;
 	struct kvm_pmc gp_counters[INTEL_PMC_MAX_GENERIC];
-	struct kvm_pmc fixed_counters[INTEL_PMC_MAX_FIXED];
+	struct kvm_pmc fixed_counters[KVM_PMC_MAX_FIXED];
 	struct irq_work irq_work;
 	DECLARE_BITMAP(reprogram_pmi, X86_PMC_IDX_MAX);
 	DECLARE_BITMAP(all_valid_pmc_idx, X86_PMC_IDX_MAX);
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 3902c28..28205ce 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -856,7 +856,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		eax.split.bit_width = cap.bit_width_gp;
 		eax.split.mask_length = cap.events_mask_len;
 
-		edx.split.num_counters_fixed = min(cap.num_counters_fixed, MAX_FIXED_COUNTERS);
+		edx.split.num_counters_fixed =
+			min(cap.num_counters_fixed, KVM_PMC_MAX_FIXED);
 		edx.split.bit_width_fixed = cap.bit_width_fixed;
 		if (cap.version)
 			edx.split.anythread_deprecated = 1;
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 7a7b8d5..9e66fba 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -15,8 +15,6 @@
 #define VMWARE_BACKDOOR_PMC_REAL_TIME		0x10001
 #define VMWARE_BACKDOOR_PMC_APPARENT_TIME	0x10002
 
-#define MAX_FIXED_COUNTERS	3
-
 struct kvm_event_hw_type_mapping {
 	u8 eventsel;
 	u8 unit_mask;
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 466d18f..9b26596 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -565,7 +565,7 @@ static void intel_pmu_init(struct kvm_vcpu *vcpu)
 		pmu->gp_counters[i].current_config = 0;
 	}
 
-	for (i = 0; i < INTEL_PMC_MAX_FIXED; i++) {
+	for (i = 0; i < KVM_PMC_MAX_FIXED; i++) {
 		pmu->fixed_counters[i].type = KVM_PMC_FIXED;
 		pmu->fixed_counters[i].vcpu = vcpu;
 		pmu->fixed_counters[i].idx = i + INTEL_PMC_IDX_FIXED;
@@ -591,7 +591,7 @@ static void intel_pmu_reset(struct kvm_vcpu *vcpu)
 		pmc->counter = pmc->eventsel = 0;
 	}
 
-	for (i = 0; i < INTEL_PMC_MAX_FIXED; i++) {
+	for (i = 0; i < KVM_PMC_MAX_FIXED; i++) {
 		pmc = &pmu->fixed_counters[i];
 
 		pmc_stop_counter(pmc);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9e43d75..b541a13 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6452,7 +6452,7 @@ static void kvm_init_msr_list(void)
 	u32 dummy[2];
 	unsigned i;
 
-	BUILD_BUG_ON_MSG(INTEL_PMC_MAX_FIXED != 4,
+	BUILD_BUG_ON_MSG(KVM_PMC_MAX_FIXED != 3,
 			 "Please update the fixed PMCs in msrs_to_saved_all[]");
 
 	perf_get_x86_pmu_capability(&x86_pmu);
-- 
2.7.4

