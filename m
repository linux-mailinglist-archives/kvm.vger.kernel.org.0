Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BFD14AF058
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 12:58:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbiBIL5s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 06:57:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231393AbiBIL5O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 06:57:14 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91E57E03E22D;
        Wed,  9 Feb 2022 02:56:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644404201; x=1675940201;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hPtON+dDWCgD9fpDPWm80v7glxOinJzDbnNHVr6cmo0=;
  b=IZ1MlJpeORJ9YzOnPhdf+xSZmLa3+rGSWXvYgXHsyA5kkAExXEzzqmiQ
   r2WW8rStIBP+X9HdgBbRF4gkWArgEJ4UPxrcq2kNbZSQq0NfHki72q0qP
   c7NipfN+1Fu917ofuOn1TKHcP8wngwtQNsnM1/Lhxhs9ZGXPwmdgTVkuH
   POVRfAIw1A3srVecIWduNp5pqfgfCS9TodNfuOaPDKaGCTD7WTjXtt+fh
   XAbB3nnEvLFLaSJ1+qmiFWaGhyx9yVLeJ97CF7XZ9MgP8ZwtW4Y1bj/Np
   8YjEUMP27SOMZ3m25J8pjmsqJ/zXm2Eyl8pOjXNIyF6ZSj45Bfn0/Nd9Z
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10252"; a="229128607"
X-IronPort-AV: E=Sophos;i="5.88,355,1635231600"; 
   d="scan'208";a="229128607"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2022 00:49:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,355,1635231600"; 
   d="scan'208";a="568169243"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.92])
  by orsmga001.jf.intel.com with ESMTP; 09 Feb 2022 00:49:47 -0800
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
Subject: [PATCH 04/11] perf tools: Add new perf clock IDs
Date:   Wed,  9 Feb 2022 10:49:22 +0200
Message-Id: <20220209084929.54331-5-adrian.hunter@intel.com>
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

Add support for new clock IDs CLOCK_PERF_HW_CLOCK and
CLOCK_PERF_HW_CLOCK_NS.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/include/uapi/linux/perf_event.h    | 14 ++++++++++++++
 tools/perf/Documentation/perf-record.txt |  9 ++++++++-
 tools/perf/builtin-record.c              |  2 +-
 tools/perf/util/clockid.c                |  5 +++++
 4 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/tools/include/uapi/linux/perf_event.h b/tools/include/uapi/linux/perf_event.h
index 1b65042ab1db..9fbb2eddd2ca 100644
--- a/tools/include/uapi/linux/perf_event.h
+++ b/tools/include/uapi/linux/perf_event.h
@@ -290,6 +290,20 @@ enum {
 	PERF_TXN_ABORT_SHIFT = 32,
 };
 
+/*
+ * If supported, clockid value to select an architecture dependent hardware
+ * clock. Note this means the unit of time is ticks not nanoseconds.
+ * On x86, this is provided by the rdtsc instruction, and is not
+ * paravirtualized.
+ */
+#define CLOCK_PERF_HW_CLOCK		0x10000000
+/*
+ * Same as CLOCK_PERF_HW_CLOCK but in nanoseconds. Note support of
+ * CLOCK_PERF_HW_CLOCK_NS does not necesssarily imply support of
+ * CLOCK_PERF_HW_CLOCK or vice versa.
+ */
+#define CLOCK_PERF_HW_CLOCK_NS	0x10000001
+
 /*
  * The format of the data returned by read() on a perf event fd,
  * as specified by attr.read_format:
diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index 9ccc75935bc5..a5ef4813093a 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -444,7 +444,14 @@ Record running and enabled time for read events (:S)
 Sets the clock id to use for the various time fields in the perf_event_type
 records. See clock_gettime(). In particular CLOCK_MONOTONIC and
 CLOCK_MONOTONIC_RAW are supported, some events might also allow
-CLOCK_BOOTTIME, CLOCK_REALTIME and CLOCK_TAI.
+CLOCK_BOOTTIME, CLOCK_REALTIME and CLOCK_TAI. In addition, the kernel might
+support CLOCK_PERF_HW_CLOCK to select an architecture dependent hardware
+clock, for which the unit of time is ticks not nanoseconds. On x86,
+CLOCK_PERF_HW_CLOCK is provided by the rdtsc instruction, and is not
+paravirtualized. There is also CLOCK_PERF_HW_CLOCK_NS which is the same as
+CLOCK_PERF_HW_CLOCK, but converted to nanoseconds. Note support of
+CLOCK_PERF_HW_CLOCK_NS does not necessarily imply support of
+CLOCK_PERF_HW_CLOCK or vice versa.
 
 -S::
 --snapshot::
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index bb716c953d02..52eaffa0b77f 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -1553,7 +1553,7 @@ static int record__init_clock(struct record *rec)
 	struct timeval ref_tod;
 	u64 ref;
 
-	if (!rec->opts.use_clockid)
+	if (!rec->opts.use_clockid || rec->opts.clockid >= CLOCK_PERF_HW_CLOCK)
 		return 0;
 
 	if (rec->opts.use_clockid && rec->opts.clockid_res_ns)
diff --git a/tools/perf/util/clockid.c b/tools/perf/util/clockid.c
index 74365a5d99c1..380429725df1 100644
--- a/tools/perf/util/clockid.c
+++ b/tools/perf/util/clockid.c
@@ -49,6 +49,9 @@ static const struct clockid_map clockids[] = {
 	CLOCKID_MAP("real", CLOCK_REALTIME),
 	CLOCKID_MAP("boot", CLOCK_BOOTTIME),
 
+	CLOCKID_MAP("perf_hw_clock", CLOCK_PERF_HW_CLOCK),
+	CLOCKID_MAP("perf_hw_clock_ns", CLOCK_PERF_HW_CLOCK_NS),
+
 	CLOCKID_END,
 };
 
@@ -57,6 +60,8 @@ static int get_clockid_res(clockid_t clk_id, u64 *res_ns)
 	struct timespec res;
 
 	*res_ns = 0;
+	if (clk_id >= CLOCK_PERF_HW_CLOCK)
+		return 0;
 	if (!clock_getres(clk_id, &res))
 		*res_ns = res.tv_nsec + res.tv_sec * NSEC_PER_SEC;
 	else
-- 
2.25.1

