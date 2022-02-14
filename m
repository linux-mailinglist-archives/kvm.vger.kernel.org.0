Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED6614B4E98
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 12:34:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351306AbiBNLah (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 06:30:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351543AbiBNL3v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 06:29:51 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 582991FA4C;
        Mon, 14 Feb 2022 03:09:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644836997; x=1676372997;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qzIFEcHTgjf/FESZQyf2nVcqovhWBlnCGxTHyI8aBPk=;
  b=dRBUiKP1UzjhZPWE3pX76P3MRjQLV8X8LRtBcxfuaNKXdS9oC/qoPOGT
   F8TRooj0zElaMrFFtlct6iJ4E1+SgUrLRxEKJXCQpXS7VISmX4ng/RNfv
   kMBsXFZP7ozFH1IF6UqG2LjLm4gwJMYpeE0Mp41MXEqFxF9zzFx9quxr5
   8dh3uX6h3tyX8jrjRyFNWgOC8WFG/4UJY8P9ItbkzVDvPa6LMlnWWRizY
   nRIPJ4KfRDdEzZTCNvqI3WUBZlSrB6iPTyIy+04oFOoczHAvuWdIhp+UO
   9lYNh9W5YD61UFBydoGBoKPpt1GUYcGO4NLr7cCDHSzVoS1qMDtVDQtcP
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10257"; a="233616169"
X-IronPort-AV: E=Sophos;i="5.88,367,1635231600"; 
   d="scan'208";a="233616169"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2022 03:09:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,367,1635231600"; 
   d="scan'208";a="635103545"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.92])
  by orsmga004.jf.intel.com with ESMTP; 14 Feb 2022 03:09:50 -0800
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
Subject: [PATCH V2 05/11] perf tools: Add API probes for new clock IDs
Date:   Mon, 14 Feb 2022 13:09:08 +0200
Message-Id: <20220214110914.268126-6-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220214110914.268126-1-adrian.hunter@intel.com>
References: <20220214110914.268126-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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
 tools/perf/util/perf_api_probe.c | 24 ++++++++++++++++++++++++
 tools/perf/util/perf_api_probe.h |  2 ++
 2 files changed, 26 insertions(+)

diff --git a/tools/perf/util/perf_api_probe.c b/tools/perf/util/perf_api_probe.c
index c28dd50bd571..33d3dd858ecc 100644
--- a/tools/perf/util/perf_api_probe.c
+++ b/tools/perf/util/perf_api_probe.c
@@ -109,6 +109,20 @@ static void perf_probe_cgroup(struct evsel *evsel)
 	evsel->core.attr.cgroup = 1;
 }
 
+static void perf_probe_hw_clock(struct evsel *evsel)
+{
+	evsel->core.attr.use_clockid = 1;
+	evsel->core.attr.ns_clockid = 1;
+	evsel->core.attr.clockid = CLOCK_PERF_HW_CLOCK;
+}
+
+static void perf_probe_hw_clock_ns(struct evsel *evsel)
+{
+	evsel->core.attr.use_clockid = 1;
+	evsel->core.attr.ns_clockid = 1;
+	evsel->core.attr.clockid = CLOCK_PERF_HW_CLOCK_NS;
+}
+
 bool perf_can_sample_identifier(void)
 {
 	return perf_probe_api(perf_probe_sample_identifier);
@@ -195,3 +209,13 @@ bool perf_can_record_cgroup(void)
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

