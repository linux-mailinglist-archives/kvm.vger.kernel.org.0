Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5DC378390D
	for <lists+kvm@lfdr.de>; Tue, 22 Aug 2023 07:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232025AbjHVFHF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Aug 2023 01:07:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232619AbjHVFHD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Aug 2023 01:07:03 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2C3EE65;
        Mon, 21 Aug 2023 22:06:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692680800; x=1724216800;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Dand54oqp4FiREPx1naWdBqec6FGhz2PeEmIqanXIhg=;
  b=jm3MpAhEcdGAI8oBrXfBvaiF/J04jSqqN0GEJKMwuwydoFF3FQ91ygEr
   NnjW784jZi6trV6kT81KOyUiw6c5jAXGk4fE36EHROAD5xiaAz4JCp/E3
   1bmaqekaHQqnisi7u7RASOPkxdqutt50+hOSOmD3r95GIHFAAjVVzNncG
   EEpzg24Q1yL75dW0htB85zlrTjfTl6GE2r9RJTzmtoPhYVPxcAhOamTs1
   q1awikRh0KsaA2e6fsKCh5v8bHcOLllTTMoMZW9xNNIwB5I9XSfuGO3jL
   S36pOwvPJwPl5qIv8aXS9QchkvsCt2gFK8GMkWyl7tamT0m2eLYPLGfW5
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10809"; a="440146664"
X-IronPort-AV: E=Sophos;i="6.01,192,1684825200"; 
   d="scan'208";a="440146664"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2023 22:04:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10809"; a="982736871"
X-IronPort-AV: E=Sophos;i="6.01,192,1684825200"; 
   d="scan'208";a="982736871"
Received: from dmi-pnp-i7.sh.intel.com ([10.239.159.155])
  by fmsmga006.fm.intel.com with ESMTP; 21 Aug 2023 22:04:41 -0700
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
Subject: [PATCH RFC v3 09/13] perf/x86/intel: Handle KVM virtual metrics event in perf system
Date:   Tue, 22 Aug 2023 13:11:36 +0800
Message-Id: <20230822051140.512879-10-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230822051140.512879-1-dapeng1.mi@linux.intel.com>
References: <20230822051140.512879-1-dapeng1.mi@linux.intel.com>
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
 arch/x86/events/intel/core.c | 39 +++++++++++++++++++++++++++---------
 arch/x86/events/perf_event.h |  9 ++++++++-
 2 files changed, 38 insertions(+), 10 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 60a2384cd936..9d53b1c6ac86 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -2535,7 +2535,7 @@ static int icl_set_topdown_event_period(struct perf_event *event)
 		hwc->saved_metric = 0;
 	}
 
-	if ((hwc->saved_slots) && is_slots_event(event)) {
+	if (is_slots_event(event)) {
 		wrmsrl(MSR_CORE_PERF_FIXED_CTR3, hwc->saved_slots);
 		wrmsrl(MSR_PERF_METRICS, hwc->saved_metric);
 	}
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

