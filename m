Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10DF16B66B2
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 14:29:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbjCLN3D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 09:29:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbjCLN27 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 09:28:59 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5B89421A;
        Sun, 12 Mar 2023 06:28:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678627702; x=1710163702;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hHhJwKh6tvUZwIf3ZmG+LxngCKEfOSKeEe77z6Pwph4=;
  b=kUy/9v6uqhd+cmcdXYheZ5OS37TRxzAruAiZYUhkllqu/w5oE3HolOCa
   NdTQXcrWsecfVsErSoqFlkb1mK3kW+jcQcINTqAn5L3InmtShe7U6NorJ
   dEclSJyWnl8H5aJPGaxJT9azZdccrEUVOAehjJhWzPvRcTtv+9f9Rgork
   FW0ntu1MjCRNO/jx8UhkgvC5d/7ko1kquY9wY93uKGvRGgmDATHVpIfA2
   dboRPAiq/p/xU9TzeIu6JHdu1Vc2F2t61ll3hDrtYzs+PIlNCGb+rplqE
   HqhT8dcZtUEi16OWIgRuwfXJZeN3+9ff5dEgdUPdYpqwxSdG+wOLW8D+d
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="316637575"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316637575"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 06:27:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="655700254"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="655700254"
Received: from debian-skl.sh.intel.com ([10.239.159.40])
  by orsmga006.jf.intel.com with ESMTP; 12 Mar 2023 06:27:41 -0700
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
Subject: [PATCH v2] perf/x86: use hexidecimal value for cpuid
Date:   Sun, 12 Mar 2023 21:26:33 +0800
Message-Id: <20230312132633.228006-1-zhenyuw@linux.intel.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230308031501.4688-1-zhenyuw@linux.intel.com>
References: <20230308031501.4688-1-zhenyuw@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It's easier to use hexidecimal value instead of decimal for reading
and following with SDM doc, also align with other cpuid calls. This
changes name for both cpuid data type and cpuid calls.

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
index 14f0a746257d..7a1ebe0dd5cc 100644
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
+	cpuid(0xA, &eax.full, &ebx.full, &fixed_mask, &edx.full);
 	if (eax.split.mask_length < ARCH_PERFMON_EVENTS_COUNT)
 		return -ENODEV;
 
diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
index c3b0d15a9841..2453a3a4c8bb 100644
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
+	cpuid(0x1C, &eax.full, &ebx.full, &ecx.full, &unused_edx);
 
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
index 3e9acdaeed1e..ed02f73ac02d 100644
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
+	cpuid(0xA, &eax.full, &ebx.full, &unused, &edx.full);
 
 	if (eax.split.mask_length < ARCH_PERFMON_EVENTS_COUNT - 1)
 		return -ENODEV;
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 6496bdbcac98..c3cd60c2e73b 100644
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
index 596061c1610e..76d9f49ffed3 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -936,8 +936,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
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
index e5cec07ca8d9..34b21e38e33d 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -507,8 +507,8 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
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

