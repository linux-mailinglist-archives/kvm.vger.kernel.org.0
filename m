Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 383E37746C9
	for <lists+kvm@lfdr.de>; Tue,  8 Aug 2023 21:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232624AbjHHTCn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 15:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbjHHTBz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 15:01:55 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF693187EB3;
        Tue,  8 Aug 2023 10:31:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691515901; x=1723051901;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QlboPx30hLAI4mLeYCjPSJRK7AOUQDBHz0Gu5Bov8K4=;
  b=YUBgdSENlP7XHM8csFYO+jgGIrYZUyCFDDLLeBEle+qmUCwabVWyHOT0
   t8zVbISwiX/3JtJh7kKxLpoTKEdFH8V2h2N9//5tL4rFir+f1P7wc1gLb
   kkV2+n7QPjuUO6cVs2w7L5p2H96gwdu6Olr2J3diKBCYC8oML6E7B+w1U
   EmgzS5GYlUwS3wC1xIVxXfbxQyVkCpuow1sHho5KMLkHRo4d8AYuYGx0a
   OpEYDOtuyMMQp6DyK4PN74wTHiucbgbX2cZ36FYXRw/Ixnq1YjCS+/0n2
   O5R0KId3CY9tglsPFuMWBWMt8h8vIt0TraB3GGtYUJGkFe9g9dUFkYTG2
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="434582123"
X-IronPort-AV: E=Sophos;i="6.01,263,1684825200"; 
   d="scan'208";a="434582123"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2023 23:27:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="734377784"
X-IronPort-AV: E=Sophos;i="6.01,263,1684825200"; 
   d="scan'208";a="734377784"
Received: from dmi-pnp-i7.sh.intel.com ([10.239.159.155])
  by fmsmga007.fm.intel.com with ESMTP; 07 Aug 2023 23:27:13 -0700
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
Subject: [PATCH RFV v2 08/13] perf/core: Add new function perf_event_topdown_metrics()
Date:   Tue,  8 Aug 2023 14:31:06 +0800
Message-Id: <20230808063111.1870070-9-dapeng1.mi@linux.intel.com>
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

Add a new function perf_event_topdown_metrics(). This new function is
quite familiar with function perf_event_period(), but it updates slots
count and metrics raw data instead of sample period into perf system.

When guest restores FIXED_CTR3 and PERF_METRICS MSRs in sched-in process,
KVM needs to capture the MSR writing trap and set the MSR values of guest
into corresponding perf events just like function perf_event_period()
does.

Initially we tried to reuse the function perf_event_period() to set the
slots/metrics value, but we found it was quite hard. The function
perf_event_period() only works on sampling events but unfortunately
slots event and metric events in topdown mode are all non-sampling
events. There are sampling event check and lots of sampling period
related check and setting in the function perf_event_period()
call-chain. If we want to reuse the function perf_event_period(), we
have to add lots of if-else changes on the entire function-chain and
even modify the function name. This would totally mess up the function
perf_event_period().

Thus, we select to create a new function perf_event_topdown_metrics() to
set the slots/metrics values. This makes logic and code both be clearer.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 include/linux/perf_event.h | 13 ++++++++
 kernel/events/core.c       | 62 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 75 insertions(+)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index e95152531f4c..fe12a2ea10d9 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1661,6 +1661,11 @@ perf_event_addr_filters(struct perf_event *event)
 	return ifh;
 }
 
+struct td_metrics {
+	u64	slots;
+	u64	metric;
+};
+
 extern void perf_event_addr_filters_sync(struct perf_event *event);
 extern void perf_report_aux_output_id(struct perf_event *event, u64 hw_id);
 
@@ -1695,6 +1700,8 @@ extern void perf_event_task_tick(void);
 extern int perf_event_account_interrupt(struct perf_event *event);
 extern int perf_event_period(struct perf_event *event, u64 value);
 extern u64 perf_event_pause(struct perf_event *event, bool reset);
+extern int perf_event_topdown_metrics(struct perf_event *event,
+				      struct td_metrics *value);
 #else /* !CONFIG_PERF_EVENTS: */
 static inline void *
 perf_aux_output_begin(struct perf_output_handle *handle,
@@ -1781,6 +1788,12 @@ static inline u64 perf_event_pause(struct perf_event *event, bool reset)
 {
 	return 0;
 }
+
+static inline int perf_event_topdown_metrics(struct perf_event *event,
+					     struct td_metrics *value)
+{
+	return 0;
+}
 #endif
 
 #if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_INTEL)
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 1877171e9590..6fa86e8bfb89 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5776,6 +5776,68 @@ int perf_event_period(struct perf_event *event, u64 value)
 }
 EXPORT_SYMBOL_GPL(perf_event_period);
 
+static void __perf_event_topdown_metrics(struct perf_event *event,
+					 struct perf_cpu_context *cpuctx,
+					 struct perf_event_context *ctx,
+					 void *info)
+{
+	struct td_metrics *td_metrics = (struct td_metrics *)info;
+	bool active;
+
+	active = (event->state == PERF_EVENT_STATE_ACTIVE);
+	if (active) {
+		perf_pmu_disable(event->pmu);
+		/*
+		 * We could be throttled; unthrottle now to avoid the tick
+		 * trying to unthrottle while we already re-started the event.
+		 */
+		if (event->hw.interrupts == MAX_INTERRUPTS) {
+			event->hw.interrupts = 0;
+			perf_log_throttle(event, 1);
+		}
+		event->pmu->stop(event, PERF_EF_UPDATE);
+	}
+
+	event->hw.saved_slots = td_metrics->slots;
+	event->hw.saved_metric = td_metrics->metric;
+
+	if (active) {
+		event->pmu->start(event, PERF_EF_RELOAD);
+		perf_pmu_enable(event->pmu);
+	}
+}
+
+static int _perf_event_topdown_metrics(struct perf_event *event,
+				       struct td_metrics *value)
+{
+	/*
+	 * Slots event in topdown metrics scenario
+	 * must be non-sampling event.
+	 */
+	if (is_sampling_event(event))
+		return -EINVAL;
+
+	if (!value)
+		return -EINVAL;
+
+	event_function_call(event, __perf_event_topdown_metrics, value);
+
+	return 0;
+}
+
+int perf_event_topdown_metrics(struct perf_event *event, struct td_metrics *value)
+{
+	struct perf_event_context *ctx;
+	int ret;
+
+	ctx = perf_event_ctx_lock(event);
+	ret = _perf_event_topdown_metrics(event, value);
+	perf_event_ctx_unlock(event, ctx);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(perf_event_topdown_metrics);
+
 static const struct file_operations perf_fops;
 
 static inline int perf_fget_light(int fd, struct fd *p)
-- 
2.34.1

