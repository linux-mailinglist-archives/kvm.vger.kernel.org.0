Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4060B3E2B95
	for <lists+kvm@lfdr.de>; Fri,  6 Aug 2021 15:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344192AbhHFNjP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Aug 2021 09:39:15 -0400
Received: from mga18.intel.com ([134.134.136.126]:16714 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344278AbhHFNjL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Aug 2021 09:39:11 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10068"; a="201553572"
X-IronPort-AV: E=Sophos;i="5.84,300,1620716400"; 
   d="scan'208";a="201553572"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2021 06:38:55 -0700
X-IronPort-AV: E=Sophos;i="5.84,300,1620716400"; 
   d="scan'208";a="523463468"
Received: from vmm_a4_icx.sh.intel.com (HELO localhost.localdomain) ([10.239.53.245])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2021 06:38:50 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     peterz@infradead.org, pbonzini@redhat.com
Cc:     bp@alien8.de, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        kan.liang@linux.intel.com, ak@linux.intel.com,
        wei.w.wang@intel.com, eranian@google.com, liuxiangdong5@huawei.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        like.xu.linux@gmail.com, boris.ostrvsky@oracle.com,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V10 07/18] x86/perf/core: Add pebs_capable to store valid PEBS_COUNTER_MASK value
Date:   Fri,  6 Aug 2021 21:37:51 +0800
Message-Id: <20210806133802.3528-8-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210806133802.3528-1-lingshan.zhu@intel.com>
References: <20210806133802.3528-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "Peter Zijlstra (Intel)" <peterz@infradead.org>

The value of pebs_counter_mask will be accessed frequently
for repeated use in the intel_guest_get_msrs(). So it can be
optimized instead of endlessly mucking about with branches.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 arch/x86/events/intel/core.c | 14 ++++++--------
 arch/x86/events/perf_event.h |  1 +
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index e09cc8901524..552a623dc886 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -2867,10 +2867,7 @@ static int handle_pmi_common(struct pt_regs *regs, u64 status)
 	 * counters from the GLOBAL_STATUS mask and we always process PEBS
 	 * events via drain_pebs().
 	 */
-	if (x86_pmu.flags & PMU_FL_PEBS_ALL)
-		status &= ~cpuc->pebs_enabled;
-	else
-		status &= ~(cpuc->pebs_enabled & PEBS_COUNTER_MASK);
+	status &= ~(cpuc->pebs_enabled & x86_pmu.pebs_capable);
 
 	/*
 	 * PEBS overflow sets bit 62 in the global status register
@@ -3908,10 +3905,7 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
 	arr[0].msr = MSR_CORE_PERF_GLOBAL_CTRL;
 	arr[0].host = intel_ctrl & ~cpuc->intel_ctrl_guest_mask;
 	arr[0].guest = intel_ctrl & ~cpuc->intel_ctrl_host_mask;
-	if (x86_pmu.flags & PMU_FL_PEBS_ALL)
-		arr[0].guest &= ~cpuc->pebs_enabled;
-	else
-		arr[0].guest &= ~(cpuc->pebs_enabled & PEBS_COUNTER_MASK);
+	arr[0].guest &= ~(cpuc->pebs_enabled & x86_pmu.pebs_capable);
 	*nr = 1;
 
 	if (x86_pmu.pebs && x86_pmu.pebs_no_isolation) {
@@ -5594,6 +5588,7 @@ __init int intel_pmu_init(void)
 	x86_pmu.events_mask_len		= eax.split.mask_length;
 
 	x86_pmu.max_pebs_events		= min_t(unsigned, MAX_PEBS_EVENTS, x86_pmu.num_counters);
+	x86_pmu.pebs_capable		= PEBS_COUNTER_MASK;
 
 	/*
 	 * Quirk: v2 perfmon does not report fixed-purpose events, so
@@ -5778,6 +5773,7 @@ __init int intel_pmu_init(void)
 		x86_pmu.pebs_aliases = NULL;
 		x86_pmu.pebs_prec_dist = true;
 		x86_pmu.lbr_pt_coexist = true;
+		x86_pmu.pebs_capable = ~0ULL;
 		x86_pmu.flags |= PMU_FL_HAS_RSP_1;
 		x86_pmu.flags |= PMU_FL_PEBS_ALL;
 		x86_pmu.get_event_constraints = glp_get_event_constraints;
@@ -6135,6 +6131,7 @@ __init int intel_pmu_init(void)
 		x86_pmu.pebs_aliases = NULL;
 		x86_pmu.pebs_prec_dist = true;
 		x86_pmu.pebs_block = true;
+		x86_pmu.pebs_capable = ~0ULL;
 		x86_pmu.flags |= PMU_FL_HAS_RSP_1;
 		x86_pmu.flags |= PMU_FL_NO_HT_SHARING;
 		x86_pmu.flags |= PMU_FL_PEBS_ALL;
@@ -6178,6 +6175,7 @@ __init int intel_pmu_init(void)
 		x86_pmu.pebs_aliases = NULL;
 		x86_pmu.pebs_prec_dist = true;
 		x86_pmu.pebs_block = true;
+		x86_pmu.pebs_capable = ~0ULL;
 		x86_pmu.flags |= PMU_FL_HAS_RSP_1;
 		x86_pmu.flags |= PMU_FL_NO_HT_SHARING;
 		x86_pmu.flags |= PMU_FL_PEBS_ALL;
diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index 1518f2754842..35d0a7ec5f20 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -807,6 +807,7 @@ struct x86_pmu {
 	void		(*pebs_aliases)(struct perf_event *event);
 	unsigned long	large_pebs_flags;
 	u64		rtm_abort_event;
+	u64		pebs_capable;
 
 	/*
 	 * Intel LBR
-- 
2.27.0

