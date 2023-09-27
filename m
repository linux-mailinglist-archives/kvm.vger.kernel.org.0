Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A941D7AF975
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 06:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbjI0Eeb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 00:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbjI0Edc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 00:33:32 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEAA1A25C;
        Tue, 26 Sep 2023 20:25:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695785108; x=1727321108;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EVyOUvu4NYq1jHoEPfEs/Mja+P/Jl4r7p70hL7gDqDM=;
  b=Ur5/8pJGUaqMagM+98DJYJdk084Uv9bpllBYOqyZMnp0OExb7rFqhWAl
   f5623Vk8nh8I3dNnLaAiGOFAOMK4DNQPJtNnt9/8AJKSmKM+OdNPk3uW5
   EMtH16nWchTo89O9tdepBoYAVY6gat6VgwZZmxzizcTQZkBVKplO8KmnB
   gA0LuuHSN+/dSGewpEZ5N/9K67eU55AFSPKtHs0mMLom6Rp1xOWN/015z
   3htOgxj3m7GbXBjT9IZ4vZYRmOAAPTlBaL2cmJgRGx+Q4Ep34353Tuab+
   LqhtD2NpYcWJc9y2iGZw2LLOMvkMFHwWREIue+sAL3CybcZSeuo7Sz5vl
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10845"; a="366780832"
X-IronPort-AV: E=Sophos;i="6.03,179,1694761200"; 
   d="scan'208";a="366780832"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2023 20:24:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10845"; a="864637181"
X-IronPort-AV: E=Sophos;i="6.03,179,1694761200"; 
   d="scan'208";a="864637181"
Received: from dmi-pnp-i7.sh.intel.com ([10.239.159.155])
  by fmsmga002.fm.intel.com with ESMTP; 26 Sep 2023 20:24:48 -0700
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
Subject: [Patch v4 08/13] perf/core: Add new function perf_event_topdown_metrics()
Date:   Wed, 27 Sep 2023 11:31:19 +0800
Message-Id: <20230927033124.1226509-9-dapeng1.mi@linux.intel.com>
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
index 04e12a8e6584..10d737aab7fa 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1057,6 +1057,11 @@ perf_cgroup_from_task(struct task_struct *task, struct perf_event_context *ctx)
 }
 #endif /* CONFIG_CGROUP_PERF */
 
+struct td_metrics {
+	u64	slots;
+	u64	metric;
+};
+
 #ifdef CONFIG_PERF_EVENTS
 
 extern struct perf_event_context *perf_cpu_task_ctx(void);
@@ -1707,6 +1712,8 @@ extern void perf_event_task_tick(void);
 extern int perf_event_account_interrupt(struct perf_event *event);
 extern int perf_event_period(struct perf_event *event, u64 value);
 extern u64 perf_event_pause(struct perf_event *event, bool reset);
+extern int perf_event_topdown_metrics(struct perf_event *event,
+				      struct td_metrics *value);
 #else /* !CONFIG_PERF_EVENTS: */
 static inline void *
 perf_aux_output_begin(struct perf_output_handle *handle,
@@ -1793,6 +1800,12 @@ static inline u64 perf_event_pause(struct perf_event *event, bool reset)
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
index 3cc870d450c5..500ffcd2c621 100644
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

