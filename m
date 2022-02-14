Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E9AF4B4E6B
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 12:34:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351324AbiBNLaJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 06:30:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351390AbiBNLaC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 06:30:02 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06B53201A5;
        Mon, 14 Feb 2022 03:10:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644837005; x=1676373005;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8iP4Es67XZjxIJccgk6MQp6J6gQXsBTv6oQZOxqfeyA=;
  b=Q9SQ8MP5Y1ERj8zucQYGY0hF9gZ+5bQU0evIbiPahbs3wX0hL8qcnuKf
   nQfpj82QduWZ+inO1qCzia50beHVq4vcqATUBsl6E7lV117hh7/DVCzsv
   BUN7dvF2jlNYvHoZ/s0WeUsUaAHtcxOciX5VngdwQEYkodPfEB8OwQ3gT
   n/ydhITkda3CTw5jZXfFq1tHOHJ+f03rHdsi8XSJQeHiQotyuOc1KmTBD
   oiRD4/Z6QjWKcA4ptfLqKe3+IOfTGaDOd6TTv/sbaYfaw3N1z85kifCAq
   vkBrKLi89IDMZy4ySUC6VsU3f8yK0ZnXssSXRWKraB50nd/0kHMNmwSAq
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10257"; a="249816883"
X-IronPort-AV: E=Sophos;i="5.88,367,1635231600"; 
   d="scan'208";a="249816883"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2022 03:10:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,367,1635231600"; 
   d="scan'208";a="635103637"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.92])
  by orsmga004.jf.intel.com with ESMTP; 14 Feb 2022 03:09:57 -0800
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, H Peter Anvin <hpa@zytor.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Leo Yan <leo.yan@linaro.org>
Subject: [PATCH V2 06/11] perf tools: Add new clock IDs to "perf time to TSC" test
Date:   Mon, 14 Feb 2022 13:09:09 +0200
Message-Id: <20220214110914.268126-7-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220214110914.268126-1-adrian.hunter@intel.com>
References: <20220214110914.268126-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The same "Convert perf time to TSC" test can be used with new clock IDs
CLOCK_PERF_HW_CLOCK and CLOCK_PERF_HW_CLOCK_NS.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/tests/perf-time-to-tsc.c | 42 ++++++++++++++++++++++-------
 1 file changed, 33 insertions(+), 9 deletions(-)

diff --git a/tools/perf/tests/perf-time-to-tsc.c b/tools/perf/tests/perf-time-to-tsc.c
index d12d0ad81801..9b75c029bb9d 100644
--- a/tools/perf/tests/perf-time-to-tsc.c
+++ b/tools/perf/tests/perf-time-to-tsc.c
@@ -22,6 +22,7 @@
 #include "tests.h"
 #include "pmu.h"
 #include "pmu-hybrid.h"
+#include "perf_api_probe.h"
 
 /*
  * Except x86_64/i386 and Arm64, other archs don't support TSC in perf.  Just
@@ -47,15 +48,7 @@
 	}					\
 }
 
-/**
- * test__perf_time_to_tsc - test converting perf time to TSC.
- *
- * This function implements a test that checks that the conversion of perf time
- * to and from TSC is consistent with the order of events.  If the test passes
- * %0 is returned, otherwise %-1 is returned.  If TSC conversion is not
- * supported then then the test passes but " (not supported)" is printed.
- */
-static int test__perf_time_to_tsc(struct test_suite *test __maybe_unused, int subtest __maybe_unused)
+static int perf_time_to_tsc_test(bool use_clockid, bool ns_clockid, s32 clockid)
 {
 	struct record_opts opts = {
 		.mmap_pages	     = UINT_MAX,
@@ -104,6 +97,9 @@ static int test__perf_time_to_tsc(struct test_suite *test __maybe_unused, int su
 	evsel->core.attr.comm = 1;
 	evsel->core.attr.disabled = 1;
 	evsel->core.attr.enable_on_exec = 0;
+	evsel->core.attr.use_clockid = use_clockid;
+	evsel->core.attr.ns_clockid = ns_clockid;
+	evsel->core.attr.clockid = clockid;
 
 	/*
 	 * For hybrid "cycles:u", it creates two events.
@@ -200,4 +196,32 @@ static int test__perf_time_to_tsc(struct test_suite *test __maybe_unused, int su
 	return err;
 }
 
+/**
+ * test__perf_time_to_tsc - test converting perf time to TSC.
+ *
+ * This function implements a test that checks that the conversion of perf time
+ * to and from TSC is consistent with the order of events.  If the test passes
+ * %0 is returned, otherwise %-1 is returned.  If TSC conversion is not
+ * supported then the test passes but " (not supported)" is printed.
+ */
+static int test__perf_time_to_tsc(struct test_suite *test __maybe_unused,
+				  int subtest __maybe_unused)
+{
+	int err;
+
+	err = perf_time_to_tsc_test(false, false, 0);
+
+	if (!err && perf_can_perf_clock_hw_clock()) {
+		pr_debug("Testing CLOCK_PERF_HW_CLOCK\n");
+		err = perf_time_to_tsc_test(true, true, CLOCK_PERF_HW_CLOCK);
+	}
+
+	if (!err && perf_can_perf_clock_hw_clock_ns()) {
+		pr_debug("Testing CLOCK_PERF_HW_CLOCK_NS\n");
+		err = perf_time_to_tsc_test(true, true, CLOCK_PERF_HW_CLOCK_NS);
+	}
+
+	return err;
+}
+
 DEFINE_SUITE("Convert perf time to TSC", perf_time_to_tsc);
-- 
2.25.1

