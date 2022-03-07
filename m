Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFFC84CF40D
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 09:53:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236221AbiCGIyh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 03:54:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236227AbiCGIyc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 03:54:32 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49FD91A39C;
        Mon,  7 Mar 2022 00:53:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646643218; x=1678179218;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NJf6gmZBiPlpFezwWwQIi57qinvlgQu7aMtORWhAzg4=;
  b=eqOSdDsjlqsZCMheXKKEcjMXsEPWse8Rd7cUqeM3x27L1a8xYD1Gwvpw
   T4rCkH99knyiY+0VuyKMDfGIVWxwimSMf6NSgLMVl0ySicc+Uxqt/+MqQ
   /fNNcVEYQTxzx/De9U874utzfvRrpGrXypSzou4EZUcPK/itBIjg7bNQs
   RnVVYwVTIShlATWXiyuuqe4P/0eMo+nDScRHoKfwx3zcyjOLHzOWAkqbe
   aneqjKjU6/xw7SW41FXxJx1GTAnKnmiRkDqYdpVxzhwcy9wVCIyZYL6yZ
   pk97sEBllLPyAAJ/l2adNfHmuz+reD+eNekcX07wptbpByRPMC9ukz2a7
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10278"; a="241771839"
X-IronPort-AV: E=Sophos;i="5.90,161,1643702400"; 
   d="scan'208";a="241771839"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 00:53:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,161,1643702400"; 
   d="scan'208";a="537033546"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.92])
  by orsmga007.jf.intel.com with ESMTP; 07 Mar 2022 00:53:33 -0800
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
Subject: [PATCH V3 05/10] perf tools: Add API probes for new clock IDs
Date:   Mon,  7 Mar 2022 10:53:07 +0200
Message-Id: <20220307085312.1814506-6-adrian.hunter@intel.com>
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

Add ability to check whether the kernel supports new clock IDs
CLOCK_PERF_HW_CLOCK and CLOCK_PERF_HW_CLOCK_NS.
They will be used in a subsequent patch.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/perf_api_probe.c | 23 +++++++++++++++++++++++
 tools/perf/util/perf_api_probe.h |  2 ++
 2 files changed, 25 insertions(+)

diff --git a/tools/perf/util/perf_api_probe.c b/tools/perf/util/perf_api_probe.c
index c28dd50bd571..e3004791d45c 100644
--- a/tools/perf/util/perf_api_probe.c
+++ b/tools/perf/util/perf_api_probe.c
@@ -5,6 +5,7 @@
 #include "util/evlist.h"
 #include "util/evsel.h"
 #include "util/parse-events.h"
+#include "util/clockid.h"
 #include "util/perf_api_probe.h"
 #include <perf/cpumap.h>
 #include <errno.h>
@@ -109,6 +110,18 @@ static void perf_probe_cgroup(struct evsel *evsel)
 	evsel->core.attr.cgroup = 1;
 }
 
+static void perf_probe_hw_clock(struct evsel *evsel)
+{
+	evsel->core.attr.use_clockid = 1;
+	evsel->core.attr.clockid = CLOCK_PERF_HW_CLOCK;
+}
+
+static void perf_probe_hw_clock_ns(struct evsel *evsel)
+{
+	evsel->core.attr.use_clockid = 1;
+	evsel->core.attr.clockid = CLOCK_PERF_HW_CLOCK_NS;
+}
+
 bool perf_can_sample_identifier(void)
 {
 	return perf_probe_api(perf_probe_sample_identifier);
@@ -195,3 +208,13 @@ bool perf_can_record_cgroup(void)
 {
 	return perf_probe_api(perf_probe_cgroup);
 }
+
+bool perf_can_perf_clock_hw_clock(void)
+{
+	return perf_probe_api(perf_probe_hw_clock);
+}
+
+bool perf_can_perf_clock_hw_clock_ns(void)
+{
+	return perf_probe_api(perf_probe_hw_clock_ns);
+}
diff --git a/tools/perf/util/perf_api_probe.h b/tools/perf/util/perf_api_probe.h
index b104168efb15..5b30cbd260cf 100644
--- a/tools/perf/util/perf_api_probe.h
+++ b/tools/perf/util/perf_api_probe.h
@@ -13,5 +13,7 @@ bool perf_can_record_text_poke_events(void);
 bool perf_can_sample_identifier(void);
 bool perf_can_record_build_id(void);
 bool perf_can_record_cgroup(void);
+bool perf_can_perf_clock_hw_clock(void);
+bool perf_can_perf_clock_hw_clock_ns(void);
 
 #endif // __PERF_API_PROBE_H
-- 
2.25.1

