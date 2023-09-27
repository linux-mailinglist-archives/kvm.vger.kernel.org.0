Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B34347AF912
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 06:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbjI0ENj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 00:13:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbjI0EM2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 00:12:28 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 561FE1F05;
        Tue, 26 Sep 2023 20:25:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695785109; x=1727321109;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4eYYvngh2M8HCkytzEnEBzL4UPADCh50c6O5Q3CPDV8=;
  b=mtqXLLjbmJ9JxXaFfCPq+hPXq+GQJ0SZZW6FE0F9x9TMHfz5vspGpHJy
   4pQ25IcUkFs0eW4JDlq8zPkR0HsXG6ujMr/Ef8GD48vceUCcOqVWJPmOm
   njJPfgDrHixMPYHvs2fHGZUE9PenZ0EUBHEAdnWYxbjNkpUNvaFPHxiio
   B+PFK9+2YELTJJmQhrixbqg+FlJ0C5wqJ6vNrJ+7DyT945q21YxWnhzET
   H5z2m6/gAjTr1pBMUFRURbMPmHSjIgmg28ss3A/QuVf7zx/DGpF8f18La
   ehjFBIEahmkj3+SbcoRO/fQNCDZm9+b5foSNiZ9Sh8IX9d09L/Y5tl2nI
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10845"; a="366780849"
X-IronPort-AV: E=Sophos;i="6.03,179,1694761200"; 
   d="scan'208";a="366780849"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2023 20:24:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10845"; a="864637188"
X-IronPort-AV: E=Sophos;i="6.03,179,1694761200"; 
   d="scan'208";a="864637188"
Received: from dmi-pnp-i7.sh.intel.com ([10.239.159.155])
  by fmsmga002.fm.intel.com with ESMTP; 26 Sep 2023 20:24:53 -0700
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
Subject: [Patch v4 09/13] perf/x86/intel: Handle KVM virtual metrics event in perf system
Date:   Wed, 27 Sep 2023 11:31:20 +0800
Message-Id: <20230927033124.1226509-10-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230927033124.1226509-1-dapeng1.mi@linux.intel.com>
References: <20230927033124.1226509-1-dapeng1.mi@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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
index 1c349290677c..df56e091eb25 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -2546,7 +2546,7 @@ static int icl_set_topdown_event_period(struct perf_event *event)
 		hwc->saved_metric = 0;
 	}
 
-	if ((hwc->saved_slots) && is_slots_event(event)) {
+	if (is_slots_event(event)) {
 		wrmsrl(MSR_CORE_PERF_FIXED_CTR3, hwc->saved_slots);
 		wrmsrl(MSR_PERF_METRICS, hwc->saved_metric);
 	}
@@ -2619,6 +2619,15 @@ static void __icl_update_topdown_event(struct perf_event *event,
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
@@ -2638,6 +2647,17 @@ static void update_saved_topdown_regs(struct perf_event *event, u64 slots,
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
@@ -2665,9 +2685,9 @@ static u64 intel_update_topdown_event(struct perf_event *event, int metric_end)
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
@@ -2675,9 +2695,9 @@ static u64 intel_update_topdown_event(struct perf_event *event, int metric_end)
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
@@ -3858,8 +3878,9 @@ static int core_pmu_hw_config(struct perf_event *event)
 
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
index a0d12989a483..7238b7f871ce 100644
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

