Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 445994AF05D
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 12:58:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231577AbiBIL5w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 06:57:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231395AbiBIL5Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 06:57:16 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93F93E03E22E;
        Wed,  9 Feb 2022 02:56:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644404201; x=1675940201;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FR54Ul9wkB7B9HE0EPdcDIwgDv3R7OaEomUk2L58kKs=;
  b=SuCxVL6ARdvgevReo3mhA5gGUxuJrChPbJucIXADMbz+qhEm2BL+V6/L
   mrq5zS3Ymu1b77+oGyhlnrmX8BvlHnWjcElct36fGQPDt85PVBrRBuzro
   X7k2cejKvsU/n+yT7ApdWA+T0AMmCWwJMAjb37FL/B2xiTj1lroiy/zPw
   TiSoJXh/MgLgVSIezXojK07RBKaPNUGAZ3Ya413s/4BdBOXSF2+hsBkM3
   8ouLCKhKKdfFMVskoTEkEnRXCs/MtCnyp3ZnXV3sbSYPGcepsKQfYQd+P
   xlsLnEJZPn+vehed4TptaPDCyMfNVGUIMpI09/JjNMmr0WGYmJPBkka2B
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10252"; a="229128626"
X-IronPort-AV: E=Sophos;i="5.88,355,1635231600"; 
   d="scan'208";a="229128626"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2022 00:49:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,355,1635231600"; 
   d="scan'208";a="568169257"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.92])
  by orsmga001.jf.intel.com with ESMTP; 09 Feb 2022 00:49:51 -0800
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
Subject: [PATCH 05/11] perf tools: Add API probes for new clock IDs
Date:   Wed,  9 Feb 2022 10:49:23 +0200
Message-Id: <20220209084929.54331-6-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220209084929.54331-1-adrian.hunter@intel.com>
References: <20220209084929.54331-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
 tools/perf/util/perf_api_probe.c | 22 ++++++++++++++++++++++
 tools/perf/util/perf_api_probe.h |  2 ++
 2 files changed, 24 insertions(+)

diff --git a/tools/perf/util/perf_api_probe.c b/tools/perf/util/perf_api_probe.c
index c28dd50bd571..c70af544a08c 100644
--- a/tools/perf/util/perf_api_probe.c
+++ b/tools/perf/util/perf_api_probe.c
@@ -109,6 +109,18 @@ static void perf_probe_cgroup(struct evsel *evsel)
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
@@ -195,3 +207,13 @@ bool perf_can_record_cgroup(void)
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

