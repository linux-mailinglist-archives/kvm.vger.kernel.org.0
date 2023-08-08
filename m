Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E34067746C5
	for <lists+kvm@lfdr.de>; Tue,  8 Aug 2023 21:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231931AbjHHTCk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 15:02:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbjHHTBz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 15:01:55 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04BF5187EB5;
        Tue,  8 Aug 2023 10:31:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691515901; x=1723051901;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=A2i155f/78hm+K7xs6LxpWipuowJCdKoFaCM1OoXNYw=;
  b=HtPqLcpfGuvbcMAslGqpQLeg+mGDhJnBmTO2G37SQkAVe6bMtZHvFViT
   JdtflhiWhTBY/NUWnXzGA5y7gAezhRRWLt30AX3UvW8XEvL38hRn5/KNE
   UpdvRXOugp8U4/KqZRlhiS4cfLCwsOZxIIPrpeHO4/ryZEbPq6wHurUsp
   QXI2KuVFV+DNLSJiMi6dgO9NJ1MkLfZSbsrDijiZgc+ceWvtTHVOdcN/C
   h6kY4SlVKP3VLMoDg1RRkBEOO5oTblGPB3uPP/9i7pIo/BUQgQtY1Y+e9
   li28f0R0kTjPonobx4MHhiFjRD4y+Q+KQVZQTJBiIT+Uh12NX9vd+/QvL
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="434582139"
X-IronPort-AV: E=Sophos;i="6.01,263,1684825200"; 
   d="scan'208";a="434582139"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2023 23:27:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="734377806"
X-IronPort-AV: E=Sophos;i="6.01,263,1684825200"; 
   d="scan'208";a="734377806"
Received: from dmi-pnp-i7.sh.intel.com ([10.239.159.155])
  by fmsmga007.fm.intel.com with ESMTP; 07 Aug 2023 23:27:19 -0700
From:   Dapeng Mi <dapeng1.mi@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Like Xu <likexu@tencent.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Cc:     kvm@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhang Xiong <xiong.y.zhang@intel.com>,
        Lv Zhiyuan <zhiyuan.lv@intel.com>,
        Yang Weijiang <weijiang.yang@intel.com>,
        Dapeng Mi <dapeng1.mi@intel.com>,
        Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [PATCH RFV v2 09/13] perf/x86/intel: Handle KVM virtual metrics event in perf system
Date:   Tue,  8 Aug 2023 14:31:07 +0800
Message-Id: <20230808063111.1870070-10-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230808063111.1870070-1-dapeng1.mi@linux.intel.com>
References: <20230808063111.1870070-1-dapeng1.mi@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM creates a virtual metrics event to claim the PERF_METRICS MSR, but
this virtual metrics event can't be recognized by perf system as it uses
a different event code with known metrics events. We need to modify perf
system code and make the KVM virtual metrics event can be recognized and
processed by perf system.

The counter of virtual metrics event doesn't save the real count value
like other normal events, instead it's used to store the raw data of
PERF_METRICS MSR, so KVM can obtain the raw data of PERF_METRICS after
the virtual metrics event is disabled.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 arch/x86/events/intel/core.c | 37 ++++++++++++++++++++++++++++--------
 arch/x86/events/perf_event.h |  9 ++++++++-
 2 files changed, 37 insertions(+), 9 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 60a2384cd936..564f602b81f1 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -2608,6 +2608,15 @@ static void __icl_update_topdown_event(struct perf_event *event,
 	}
 }
 
+static inline void __icl_update_vmetrics_event(struct perf_event *event, u64 metrics)
+{
+	/*
+	 * For the guest metrics event, the count would be used to save
+	 * the raw data of PERF_METRICS MSR.
+	 */
+	local64_set(&event->count, metrics);
+}
+
 static void update_saved_topdown_regs(struct perf_event *event, u64 slots,
 				      u64 metrics, int metric_end)
 {
@@ -2627,6 +2636,17 @@ static void update_saved_topdown_regs(struct perf_event *event, u64 slots,
 	}
 }
 
+static inline void _intel_update_topdown_event(struct perf_event *event,
+					       u64 slots, u64 metrics,
+					       u64 last_slots, u64 last_metrics)
+{
+	if (is_vmetrics_event(event))
+		__icl_update_vmetrics_event(event, metrics);
+	else
+		__icl_update_topdown_event(event, slots, metrics,
+					   last_slots, last_metrics);
+}
+
 /*
  * Update all active Topdown events.
  *
@@ -2654,9 +2674,9 @@ static u64 intel_update_topdown_event(struct perf_event *event, int metric_end)
 		if (!is_topdown_idx(idx))
 			continue;
 		other = cpuc->events[idx];
-		__icl_update_topdown_event(other, slots, metrics,
-					   event ? event->hw.saved_slots : 0,
-					   event ? event->hw.saved_metric : 0);
+		_intel_update_topdown_event(other, slots, metrics,
+					    event ? event->hw.saved_slots : 0,
+					    event ? event->hw.saved_metric : 0);
 	}
 
 	/*
@@ -2664,9 +2684,9 @@ static u64 intel_update_topdown_event(struct perf_event *event, int metric_end)
 	 * in active_mask e.g. x86_pmu_stop()
 	 */
 	if (event && !test_bit(event->hw.idx, cpuc->active_mask)) {
-		__icl_update_topdown_event(event, slots, metrics,
-					   event->hw.saved_slots,
-					   event->hw.saved_metric);
+		_intel_update_topdown_event(event, slots, metrics,
+					    event->hw.saved_slots,
+					    event->hw.saved_metric);
 
 		/*
 		 * In x86_pmu_stop(), the event is cleared in active_mask first,
@@ -3847,8 +3867,9 @@ static int core_pmu_hw_config(struct perf_event *event)
 
 static bool is_available_metric_event(struct perf_event *event)
 {
-	return is_metric_event(event) &&
-		event->attr.config <= INTEL_TD_METRIC_AVAILABLE_MAX;
+	return (is_metric_event(event) &&
+		event->attr.config <= INTEL_TD_METRIC_AVAILABLE_MAX) ||
+			is_vmetrics_event(event);
 }
 
 static inline bool is_mem_loads_event(struct perf_event *event)
diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index 895c572f379c..e0703f743713 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -105,9 +105,16 @@ static inline bool is_slots_event(struct perf_event *event)
 	return (event->attr.config & INTEL_ARCH_EVENT_MASK) == INTEL_TD_SLOTS;
 }
 
+static inline bool is_vmetrics_event(struct perf_event *event)
+{
+	return (event->attr.config & INTEL_ARCH_EVENT_MASK) ==
+			INTEL_FIXED_VMETRICS_EVENT;
+}
+
 static inline bool is_topdown_event(struct perf_event *event)
 {
-	return is_metric_event(event) || is_slots_event(event);
+	return is_metric_event(event) || is_slots_event(event) ||
+			is_vmetrics_event(event);
 }
 
 struct amd_nb {
-- 
2.34.1

