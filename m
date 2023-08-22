Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79DEE783906
	for <lists+kvm@lfdr.de>; Tue, 22 Aug 2023 07:06:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232620AbjHVFG2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Aug 2023 01:06:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232503AbjHVFGY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Aug 2023 01:06:24 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 569CA195;
        Mon, 21 Aug 2023 22:05:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692680755; x=1724216755;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NJpOTnRSj8qqZCbQHRVgYJuiVfbmVTUNUDYhP4Pi3xk=;
  b=XvmIeyiunH2pdxAh74oOtjYinMruF0uw9AODSM2Wgx/xLMnqaXKN4/Sj
   sur3gPrLbDY1+C5JNvMWV8u3mEwSoTqsvfxtV89UcshqVR3oGipWH0MiX
   y0iLcwrx/ztNkuFSzDL4kDMErNt8KnOb/SSixVABqg36pTyCULeXA6XcS
   gIsW5CrUfD1bWmWhylMQwbAH7GZAkmM38cA4VaQ+PLS154LJxFYp/YfO0
   N4GNAsdNQBMH++P4e00YBP4SS6LoIXpnC5zaFpmeyjYr84erRFmP2ZBmy
   GXkeqIkGYFqhntp/LCpqqKL+57ExjG9tw3OXWj0we3gjnH3fwzqDGskMS
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10809"; a="440146593"
X-IronPort-AV: E=Sophos;i="6.01,192,1684825200"; 
   d="scan'208";a="440146593"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2023 22:04:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10809"; a="982736790"
X-IronPort-AV: E=Sophos;i="6.01,192,1684825200"; 
   d="scan'208";a="982736790"
Received: from dmi-pnp-i7.sh.intel.com ([10.239.159.155])
  by fmsmga006.fm.intel.com with ESMTP; 21 Aug 2023 22:04:28 -0700
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
Subject: [PATCH RFC v3 07/13] perf/x86: Add constraint for guest perf metrics event
Date:   Tue, 22 Aug 2023 13:11:34 +0800
Message-Id: <20230822051140.512879-8-dapeng1.mi@linux.intel.com>
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

When guest wants to use PERF_METRICS MSR, a virtual metrics event needs
to be created in the perf subsystem so that the guest can have exclusive
ownership of the PERF_METRICS MSR.

We introduce the new vmetrics constraint, so that we can couple this
virtual metrics event with slots event as a events group to involves in
the host perf system scheduling. Since Guest metric events are always
recognized as vCPU process's events on host, they are time-sharing
multiplexed with other host metric events, so that we choose bit 48
(INTEL_PMC_IDX_METRIC_BASE) as the index of this virtual metrics event.

Co-developed-by: Yang Weijiang <weijiang.yang@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 arch/x86/events/intel/core.c      | 28 +++++++++++++++++++++-------
 arch/x86/events/perf_event.h      |  1 +
 arch/x86/include/asm/perf_event.h | 15 +++++++++++++++
 3 files changed, 37 insertions(+), 7 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 2a284ba951b7..60a2384cd936 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -3147,17 +3147,26 @@ intel_bts_constraints(struct perf_event *event)
 	return NULL;
 }
 
+static struct event_constraint *intel_virt_event_constraints[] __read_mostly = {
+	&vlbr_constraint,
+	&vmetrics_constraint,
+};
+
 /*
- * Note: matches a fake event, like Fixed2.
+ * Note: matches a virtual event, like vmetrics.
  */
 static struct event_constraint *
-intel_vlbr_constraints(struct perf_event *event)
+intel_virt_constraints(struct perf_event *event)
 {
-	struct event_constraint *c = &vlbr_constraint;
+	int i;
+	struct event_constraint *c;
 
-	if (unlikely(constraint_match(c, event->hw.config))) {
-		event->hw.flags |= c->flags;
-		return c;
+	for (i = 0; i < ARRAY_SIZE(intel_virt_event_constraints); i++) {
+		c = intel_virt_event_constraints[i];
+		if (unlikely(constraint_match(c, event->hw.config))) {
+			event->hw.flags |= c->flags;
+			return c;
+		}
 	}
 
 	return NULL;
@@ -3357,7 +3366,7 @@ __intel_get_event_constraints(struct cpu_hw_events *cpuc, int idx,
 {
 	struct event_constraint *c;
 
-	c = intel_vlbr_constraints(event);
+	c = intel_virt_constraints(event);
 	if (c)
 		return c;
 
@@ -5349,6 +5358,11 @@ static struct attribute *spr_tsx_events_attrs[] = {
 	NULL,
 };
 
+struct event_constraint vmetrics_constraint =
+	__EVENT_CONSTRAINT(INTEL_FIXED_VMETRICS_EVENT,
+			   (1ULL << INTEL_PMC_IDX_FIXED_VMETRICS),
+			   FIXED_EVENT_FLAGS, 1, 0, 0);
+
 static ssize_t freeze_on_smi_show(struct device *cdev,
 				  struct device_attribute *attr,
 				  char *buf)
diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index d6de4487348c..895c572f379c 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -1482,6 +1482,7 @@ void reserve_lbr_buffers(void);
 
 extern struct event_constraint bts_constraint;
 extern struct event_constraint vlbr_constraint;
+extern struct event_constraint vmetrics_constraint;
 
 void intel_pmu_enable_bts(u64 config);
 
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 63e1ce1f4b27..d767807aae91 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -390,6 +390,21 @@ static inline bool is_topdown_idx(int idx)
  */
 #define INTEL_PMC_IDX_FIXED_VLBR		(GLOBAL_STATUS_LBRS_FROZEN_BIT)
 
+/*
+ * We model guest TopDown metrics event tracing similarly.
+ *
+ * Guest metric events are recognized as vCPU process's events on host, they
+ * would be time-sharing multiplexed with other host metric events, so that
+ * we choose bit 48 (INTEL_PMC_IDX_METRIC_BASE) as the index of virtual
+ * metrics event.
+ */
+#define INTEL_PMC_IDX_FIXED_VMETRICS		(INTEL_PMC_IDX_METRIC_BASE)
+
+/*
+ * Pseudo-encoding the guest metrics event as event=0x00,umask=0x11,
+ * since it would claim bit 48 which is effectively Fixed16.
+ */
+#define INTEL_FIXED_VMETRICS_EVENT		0x1100
 /*
  * Pseudo-encoding the guest LBR event as event=0x00,umask=0x1b,
  * since it would claim bit 58 which is effectively Fixed26.
-- 
2.34.1

