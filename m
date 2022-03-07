Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3874CF409
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 09:53:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236173AbiCGIye (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 03:54:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235718AbiCGIy3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 03:54:29 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E0071A3BB;
        Mon,  7 Mar 2022 00:53:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646643214; x=1678179214;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=InEJUMEsvt88WaNNj0iD8NVomYggC4uoiXvwBLY4GOQ=;
  b=UlQh8kSSskaFDdk2x7Sx4vbSCLCt6s7idqqjuwGsv+wdFK+Rcl0sp165
   embURodDEoQapM8+QjoHW9BpUAy9NHaTcWDTN2mqmPEGAf98hAiZ1Y71z
   klux9DYywwV8dq9th+m3VuN9v4AeeQgxGxcPycmEvqZgsVa0oiswfB+3h
   Xn6xa49U3oCvE+3WFc24lBREhQV+IfRmfqdv87tm52OoSfC1p51ITXJb2
   JpTvoYzLWB2cLgsBR5hX83rqvE6vpuSYOEckiITyK2sjqgPw6WF6NePW8
   fSzR4NYbubai+V2yuAHWHe1ZhEgQ4uuaT01D7zi7AaS9pl2uLG/Q8k9OP
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10278"; a="241771811"
X-IronPort-AV: E=Sophos;i="5.90,161,1643702400"; 
   d="scan'208";a="241771811"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 00:53:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,161,1643702400"; 
   d="scan'208";a="537033532"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.92])
  by orsmga007.jf.intel.com with ESMTP; 07 Mar 2022 00:53:29 -0800
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
Subject: [PATCH V3 04/10] perf tools: Add new perf clock IDs
Date:   Mon,  7 Mar 2022 10:53:06 +0200
Message-Id: <20220307085312.1814506-5-adrian.hunter@intel.com>
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

Add support for new clock IDs CLOCK_PERF_HW_CLOCK and
CLOCK_PERF_HW_CLOCK_NS.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/Documentation/perf-record.txt | 11 ++++++++++-
 tools/perf/builtin-record.c              |  2 +-
 tools/perf/util/clockid.c                |  5 +++++
 tools/perf/util/clockid.h                |  8 ++++++++
 4 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index 465be4e62a17..d7e609a5f824 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -444,7 +444,16 @@ Record running and enabled time for read events (:S)
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
+CLOCK_PERF_HW_CLOCK or vice versa. Be warned, CLOCK_PERF_HW_CLOCK and
+CLOCK_PERF_HW_CLOCK_NS may not be stable or well-behaved in any way,
+including varying across different CPUs. That warning can also apply to TSC.
 
 -S::
 --snapshot::
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 0b4abed555d8..c17b13528469 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -1973,7 +1973,7 @@ static int record__init_clock(struct record *rec)
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
diff --git a/tools/perf/util/clockid.h b/tools/perf/util/clockid.h
index 9b49b4711c76..af396b14ae8b 100644
--- a/tools/perf/util/clockid.h
+++ b/tools/perf/util/clockid.h
@@ -8,4 +8,12 @@ int parse_clockid(const struct option *opt, const char *str, int unset);
 
 const char *clockid_name(clockid_t clk_id);
 
+#ifndef CLOCK_PERF_HW_CLOCK
+#define CLOCK_PERF_HW_CLOCK		0x10000000
+#endif
+
+#ifndef CLOCK_PERF_HW_CLOCK_NS
+#define CLOCK_PERF_HW_CLOCK_NS		0x10000001
+#endif
+
 #endif
-- 
2.25.1

