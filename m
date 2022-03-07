Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 202144CF40E
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 09:54:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235443AbiCGIyv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 03:54:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236237AbiCGIyk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 03:54:40 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1068A1AF20;
        Mon,  7 Mar 2022 00:53:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646643224; x=1678179224;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=igIfzl614SJVVpOc/yOTouOngTlxdEUS35ptrQqkkbo=;
  b=diMuQybr8uaLWWhTqCE+p6W3eg0IU95bszFbqFYTX8sRauKYTly6IHlQ
   kPXx+kpHIe26IAP3fOwHXG2hbX3rhV4IJUMvymEsedeECh2HiH1jukYMy
   bkycV0ZNQQsQD33rHQpSDesT222mNSk/VQK1RcKIlPGLfAgOxtVvk3xK3
   fKHuJhHNNlJ4jSn2i/4WqatuQtLhIgYuNhn+yxnhL0qyhEJ1LK4uCZcs0
   zcVfIgSfuiUjk8VVWmYgOPfdrrO6wxeCRJXpabJtF2uCoOMi4SRoZ4JE2
   jQ3T7/JWwYrgY/xJrXRl3JPtwDAUdRtwfyt5zDHWZkJDDStTuNYCH+ULF
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10278"; a="241771854"
X-IronPort-AV: E=Sophos;i="5.90,161,1643702400"; 
   d="scan'208";a="241771854"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 00:53:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,161,1643702400"; 
   d="scan'208";a="537033567"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.92])
  by orsmga007.jf.intel.com with ESMTP; 07 Mar 2022 00:53:38 -0800
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
Subject: [PATCH V3 06/10] perf tools: Add new clock IDs to "perf time to TSC" test
Date:   Mon,  7 Mar 2022 10:53:08 +0200
Message-Id: <20220307085312.1814506-7-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220307085312.1814506-1-adrian.hunter@intel.com>
References: <20220307085312.1814506-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index d12d0ad81801..62840ec98cea 100644
--- a/tools/perf/tests/perf-time-to-tsc.c
+++ b/tools/perf/tests/perf-time-to-tsc.c
@@ -22,6 +22,8 @@
 #include "tests.h"
 #include "pmu.h"
 #include "pmu-hybrid.h"
+#include "clockid.h"
+#include "perf_api_probe.h"
 
 /*
  * Except x86_64/i386 and Arm64, other archs don't support TSC in perf.  Just
@@ -47,15 +49,7 @@
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
+static int perf_time_to_tsc_test(bool use_clockid, s32 clockid)
 {
 	struct record_opts opts = {
 		.mmap_pages	     = UINT_MAX,
@@ -104,6 +98,8 @@ static int test__perf_time_to_tsc(struct test_suite *test __maybe_unused, int su
 	evsel->core.attr.comm = 1;
 	evsel->core.attr.disabled = 1;
 	evsel->core.attr.enable_on_exec = 0;
+	evsel->core.attr.use_clockid = use_clockid;
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
+	err = perf_time_to_tsc_test(false, 0);
+
+	if (!err && perf_can_perf_clock_hw_clock()) {
+		pr_debug("Testing CLOCK_PERF_HW_CLOCK\n");
+		err = perf_time_to_tsc_test(true, CLOCK_PERF_HW_CLOCK);
+	}
+
+	if (!err && perf_can_perf_clock_hw_clock_ns()) {
+		pr_debug("Testing CLOCK_PERF_HW_CLOCK_NS\n");
+		err = perf_time_to_tsc_test(true, CLOCK_PERF_HW_CLOCK_NS);
+	}
+
+	return err;
+}
+
 DEFINE_SUITE("Convert perf time to TSC", perf_time_to_tsc);
-- 
2.25.1

