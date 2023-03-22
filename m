Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 453366C4234
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 06:38:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbjCVFiD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 01:38:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjCVFiB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 01:38:01 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4236449A;
        Tue, 21 Mar 2023 22:37:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679463479; x=1710999479;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bc8Gp0YccWiyp85CLI6R3d+m+jckZdVWxQUsu4ffot4=;
  b=KJiSsorGN1Dq4HKbgXYEKhQZC0Avz/qP6R6Tuga8Cs/iOSuCY0D525GW
   w6MrnOaXXP+D+k+n9ykn0Y3AVhtZ4VUsifiqaUJAQSYGIb/UKWtzU9Zkh
   n75RnL+6hoZLXkHOg4pdIqMsM7jox8A68DF0uwe1T2vbwjsdKePjnDtQv
   v5IGB2dhbS5qCkGs4NgRXqEf8WW6tFiTkFKiQbF6bRd6ysS5HWTm9L8h1
   gc+z4ywqTNftKNVAT3stM/oDtLiMfzEMA1Bjc7y6iyCaOMIJURxF6b/XN
   cB7AeS+xsllgnSvYxcWxEjTF0kgB/w6BLRk0V+b/noVCPGJNWAmd0S246
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="318776590"
X-IronPort-AV: E=Sophos;i="5.98,280,1673942400"; 
   d="scan'208";a="318776590"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 22:37:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="714292258"
X-IronPort-AV: E=Sophos;i="5.98,280,1673942400"; 
   d="scan'208";a="714292258"
Received: from xiulinli-mobl2.ccr.corp.intel.com (HELO zwan2-desk1.ccr.corp.intel.com) ([10.254.210.248])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 22:37:56 -0700
From:   Zhenyu Wang <zhenyuw@linux.intel.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        CodyYao-oc <CodyYao-oc@zhaoxin.com>
Subject: [PATCH v3] perf/x86: use hexidecimal value for cpuid
Date:   Wed, 22 Mar 2023 13:37:46 +0800
Message-Id: <20230322053746.4888-1-zhenyuw@linux.intel.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230312132633.228006-1-zhenyuw@linux.intel.com>
References: <20230312132633.228006-1-zhenyuw@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It's easier to use hexidecimal value instead of decimal for reading
and following with SDM doc, also align with other cpuid calls. As new
cpuid leaf would be added in future, this tries to convert current
forms and would take it as convention for new leaf definition.

This changes name for both cpuid type and cpuid calls.

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: CodyYao-oc <CodyYao-oc@zhaoxin.com>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
---
v3:
- add more explanation in commit message for purpose of this
- use lowercase number in call to align with current code

v2:
- rename in cpuid data type as well

 arch/x86/events/intel/core.c      | 10 +++++-----
 arch/x86/events/intel/lbr.c       |  8 ++++----
 arch/x86/events/intel/pt.c        |  2 +-
 arch/x86/events/zhaoxin/core.c    |  8 ++++----
 arch/x86/include/asm/perf_event.h | 12 ++++++------
 arch/x86/kvm/cpuid.c              |  4 ++--
 arch/x86/kvm/vmx/pmu_intel.c      |  4 ++--
 7 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index a3fb996a86a1..5487a39d4975 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -5170,7 +5170,7 @@ static __init void intel_arch_events_quirk(void)
 
 static __init void intel_nehalem_quirk(void)
 {
-	union cpuid10_ebx ebx;
+	union cpuid_0xa_ebx ebx;
 
 	ebx.full = x86_pmu.events_maskl;
 	if (ebx.split.no_branch_misses_retired) {
@@ -5878,9 +5878,9 @@ __init int intel_pmu_init(void)
 	struct attribute **td_attr    = &empty_attrs;
 	struct attribute **mem_attr   = &empty_attrs;
 	struct attribute **tsx_attr   = &empty_attrs;
-	union cpuid10_edx edx;
-	union cpuid10_eax eax;
-	union cpuid10_ebx ebx;
+	union cpuid_0xa_edx edx;
+	union cpuid_0xa_eax eax;
+	union cpuid_0xa_ebx ebx;
 	unsigned int fixed_mask;
 	bool pmem = false;
 	int version, i;
@@ -5903,7 +5903,7 @@ __init int intel_pmu_init(void)
 	 * Check whether the Architectural PerfMon supports
 	 * Branch Misses Retired hw_event or not.
 	 */
-	cpuid(10, &eax.full, &ebx.full, &fixed_mask, &edx.full);
+	cpuid(0xa, &eax.full, &ebx.full, &fixed_mask, &edx.full);
 	if (eax.split.mask_length < ARCH_PERFMON_EVENTS_COUNT)
 		return -ENODEV;
 
diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
index c3b0d15a9841..616a6904af03 100644
--- a/arch/x86/events/intel/lbr.c
+++ b/arch/x86/events/intel/lbr.c
@@ -1497,16 +1497,16 @@ static bool is_arch_lbr_xsave_available(void)
 void __init intel_pmu_arch_lbr_init(void)
 {
 	struct pmu *pmu = x86_get_pmu(smp_processor_id());
-	union cpuid28_eax eax;
-	union cpuid28_ebx ebx;
-	union cpuid28_ecx ecx;
+	union cpuid_0x1c_eax eax;
+	union cpuid_0x1c_ebx ebx;
+	union cpuid_0x1c_ecx ecx;
 	unsigned int unused_edx;
 	bool arch_lbr_xsave;
 	size_t size;
 	u64 lbr_nr;
 
 	/* Arch LBR Capabilities */
-	cpuid(28, &eax.full, &ebx.full, &ecx.full, &unused_edx);
+	cpuid(0x1c, &eax.full, &ebx.full, &ecx.full, &unused_edx);
 
 	lbr_nr = fls(eax.split.lbr_depth_mask) * 8;
 	if (!lbr_nr)
diff --git a/arch/x86/events/intel/pt.c b/arch/x86/events/intel/pt.c
index 42a55794004a..da3c5d748365 100644
--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -235,7 +235,7 @@ static int __init pt_pmu_hw_init(void)
 	}
 
 	for (i = 0; i < PT_CPUID_LEAVES; i++) {
-		cpuid_count(20, i,
+		cpuid_count(0x14, i,
 			    &pt_pmu.caps[CPUID_EAX + i*PT_CPUID_REGS_NUM],
 			    &pt_pmu.caps[CPUID_EBX + i*PT_CPUID_REGS_NUM],
 			    &pt_pmu.caps[CPUID_ECX + i*PT_CPUID_REGS_NUM],
diff --git a/arch/x86/events/zhaoxin/core.c b/arch/x86/events/zhaoxin/core.c
index 3e9acdaeed1e..1d071974f4db 100644
--- a/arch/x86/events/zhaoxin/core.c
+++ b/arch/x86/events/zhaoxin/core.c
@@ -504,9 +504,9 @@ static __init void zhaoxin_arch_events_quirk(void)
 
 __init int zhaoxin_pmu_init(void)
 {
-	union cpuid10_edx edx;
-	union cpuid10_eax eax;
-	union cpuid10_ebx ebx;
+	union cpuid_0xa_edx edx;
+	union cpuid_0xa_eax eax;
+	union cpuid_0xa_ebx ebx;
 	struct event_constraint *c;
 	unsigned int unused;
 	int version;
@@ -517,7 +517,7 @@ __init int zhaoxin_pmu_init(void)
 	 * Check whether the Architectural PerfMon supports
 	 * hw_event or not.
 	 */
-	cpuid(10, &eax.full, &ebx.full, &unused, &edx.full);
+	cpuid(0xa, &eax.full, &ebx.full, &unused, &edx.full);
 
 	if (eax.split.mask_length < ARCH_PERFMON_EVENTS_COUNT - 1)
 		return -ENODEV;
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 8fc15ed5e60b..0d2d735c8167 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -125,7 +125,7 @@
  * Intel "Architectural Performance Monitoring" CPUID
  * detection/enumeration details:
  */
-union cpuid10_eax {
+union cpuid_0xa_eax {
 	struct {
 		unsigned int version_id:8;
 		unsigned int num_counters:8;
@@ -135,7 +135,7 @@ union cpuid10_eax {
 	unsigned int full;
 };
 
-union cpuid10_ebx {
+union cpuid_0xa_ebx {
 	struct {
 		unsigned int no_unhalted_core_cycles:1;
 		unsigned int no_instructions_retired:1;
@@ -148,7 +148,7 @@ union cpuid10_ebx {
 	unsigned int full;
 };
 
-union cpuid10_edx {
+union cpuid_0xa_edx {
 	struct {
 		unsigned int num_counters_fixed:5;
 		unsigned int bit_width_fixed:8;
@@ -170,7 +170,7 @@ union cpuid10_edx {
 /*
  * Intel Architectural LBR CPUID detection/enumeration details:
  */
-union cpuid28_eax {
+union cpuid_0x1c_eax {
 	struct {
 		/* Supported LBR depth values */
 		unsigned int	lbr_depth_mask:8;
@@ -183,7 +183,7 @@ union cpuid28_eax {
 	unsigned int		full;
 };
 
-union cpuid28_ebx {
+union cpuid_0x1c_ebx {
 	struct {
 		/* CPL Filtering Supported */
 		unsigned int    lbr_cpl:1;
@@ -195,7 +195,7 @@ union cpuid28_ebx {
 	unsigned int            full;
 };
 
-union cpuid28_ecx {
+union cpuid_0x1c_ecx {
 	struct {
 		/* Mispredict Bit Supported */
 		unsigned int    lbr_mispred:1;
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 599aebec2d52..57f43dc87538 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -967,8 +967,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		}
 		break;
 	case 0xa: { /* Architectural Performance Monitoring */
-		union cpuid10_eax eax;
-		union cpuid10_edx edx;
+		union cpuid_0xa_eax eax;
+		union cpuid_0xa_edx edx;
 
 		if (!static_cpu_has(X86_FEATURE_ARCH_PERFMON)) {
 			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index e8a3be0b9df9..f4b165667ca9 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -512,8 +512,8 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
 	struct kvm_cpuid_entry2 *entry;
-	union cpuid10_eax eax;
-	union cpuid10_edx edx;
+	union cpuid_0xa_eax eax;
+	union cpuid_0xa_edx edx;
 	u64 perf_capabilities;
 	u64 counter_mask;
 	int i;
-- 
2.39.2

