Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 916694B4E6C
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 12:34:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351278AbiBNLaN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 06:30:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351493AbiBNLaE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 06:30:04 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBAB1387B1;
        Mon, 14 Feb 2022 03:10:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644837018; x=1676373018;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XWL8vsphxVJi5F0GgCBAwoViorx7hR1AqvpwHfj+rKg=;
  b=dsVioeNCdnM3fVzyPNs+TUj/ia+90UpoTr6pNZToDADsQyHUaleOqYRK
   3bYti+PdZ5X4ZnM/aCxnH898JDHiGBR6hX8a3nTDIH7yorJ4co60ROjgC
   J8aqvk48Fh7ghfu6d0XzQiNuDmSxdvmgsezBb1L/ffjgp8vpCQim/Feka
   yjUqhzdTk2+PzFresM6zBCbslm3sOIBcp1Uu/9a1QT/SHkIQjgqYfPBZI
   5IedWYPcLSRpWb118mkxoGm/RrSi2oZyBzaEdhurFQLcv+9BuAocKEYeX
   899u9L79bqDGgH654XspSUzb5BnIbtqQu4E0tSNEN17/RtQff83N7lv4M
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10257"; a="247662913"
X-IronPort-AV: E=Sophos;i="5.88,367,1635231600"; 
   d="scan'208";a="247662913"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2022 03:10:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,367,1635231600"; 
   d="scan'208";a="635103768"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.92])
  by orsmga004.jf.intel.com with ESMTP; 14 Feb 2022 03:10:12 -0800
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
Subject: [PATCH V2 08/11] perf intel-pt: Add support for new clock IDs
Date:   Mon, 14 Feb 2022 13:09:11 +0200
Message-Id: <20220214110914.268126-9-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220214110914.268126-1-adrian.hunter@intel.com>
References: <20220214110914.268126-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add support for new clock IDs CLOCK_PERF_HW_CLOCK and
CLOCK_PERF_HW_CLOCK_NS. Mainly this means also keeping TSC conversion
information for CLOCK_PERF_HW_CLOCK_NS when CLOCK_PERF_HW_CLOCK is
being used, so that conversions from nanoseconds can still be done when
the perf event clock is TSC.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/arch/x86/util/intel-pt.c | 37 ++++++++++++++++++++++++++---
 tools/perf/util/intel-pt.c          | 21 ++++++++++++----
 tools/perf/util/intel-pt.h          |  2 +-
 3 files changed, 52 insertions(+), 8 deletions(-)

diff --git a/tools/perf/arch/x86/util/intel-pt.c b/tools/perf/arch/x86/util/intel-pt.c
index 8c31578d6f4a..5424c42337e7 100644
--- a/tools/perf/arch/x86/util/intel-pt.c
+++ b/tools/perf/arch/x86/util/intel-pt.c
@@ -290,6 +290,21 @@ static const char *intel_pt_find_filter(struct evlist *evlist,
 	return NULL;
 }
 
+static bool intel_pt_clockid(struct evlist *evlist, struct perf_pmu *intel_pt_pmu, s32 clockid)
+{
+	struct evsel *evsel;
+
+	evlist__for_each_entry(evlist, evsel) {
+		if (evsel->core.attr.type == intel_pt_pmu->type &&
+		    evsel->core.attr.use_clockid &&
+		    evsel->core.attr.ns_clockid &&
+		    evsel->core.attr.clockid == clockid)
+			return true;
+	}
+
+	return false;
+}
+
 static size_t intel_pt_filter_bytes(const char *filter)
 {
 	size_t len = filter ? strlen(filter) : 0;
@@ -304,9 +319,11 @@ intel_pt_info_priv_size(struct auxtrace_record *itr, struct evlist *evlist)
 			container_of(itr, struct intel_pt_recording, itr);
 	const char *filter = intel_pt_find_filter(evlist, ptr->intel_pt_pmu);
 
-	ptr->priv_size = (INTEL_PT_AUXTRACE_PRIV_MAX * sizeof(u64)) +
+	ptr->priv_size = (INTEL_PT_AUXTRACE_PRIV_FIXED * sizeof(u64)) +
 			 intel_pt_filter_bytes(filter);
 	ptr->priv_size += sizeof(u64); /* Cap Event Trace */
+	ptr->priv_size += sizeof(u64); /* ns Time Shift */
+	ptr->priv_size += sizeof(u64); /* ns Time Multiplier */
 
 	return ptr->priv_size;
 }
@@ -414,6 +431,18 @@ static int intel_pt_info_fill(struct auxtrace_record *itr,
 
 	*info++ = event_trace;
 
+	if (intel_pt_clockid(session->evlist, ptr->intel_pt_pmu, CLOCK_PERF_HW_CLOCK)) {
+		struct perf_tsc_conversion ns_tc;
+
+		if (perf_read_tsc_conv_for_clockid(CLOCK_PERF_HW_CLOCK_NS, true, &ns_tc))
+			return -EINVAL;
+		*info++ = ns_tc.time_shift;
+		*info++ = ns_tc.time_mult;
+	} else {
+		*info++ = tc.time_shift;
+		*info++ = tc.time_mult;
+	}
+
 	return 0;
 }
 
@@ -664,8 +693,10 @@ static int intel_pt_recording_options(struct auxtrace_record *itr,
 		return -EINVAL;
 	}
 
-	if (opts->use_clockid) {
-		pr_err("Cannot use clockid (-k option) with " INTEL_PT_PMU_NAME "\n");
+	if (opts->use_clockid && opts->clockid != CLOCK_PERF_HW_CLOCK_NS &&
+	    opts->clockid != CLOCK_PERF_HW_CLOCK) {
+		pr_err("Cannot use clockid (-k option) with " INTEL_PT_PMU_NAME
+		       " except CLOCK_PERF_HW_CLOCK_NS and CLOCK_PERF_HW_CLOCK\n");
 		return -EINVAL;
 	}
 
diff --git a/tools/perf/util/intel-pt.c b/tools/perf/util/intel-pt.c
index ec43d364d0de..10d47759a41e 100644
--- a/tools/perf/util/intel-pt.c
+++ b/tools/perf/util/intel-pt.c
@@ -89,6 +89,8 @@ struct intel_pt {
 
 	struct perf_tsc_conversion tc;
 	bool cap_user_time_zero;
+	u16 ns_time_shift;
+	u32 ns_time_mult;
 
 	struct itrace_synth_opts synth_opts;
 
@@ -1100,10 +1102,10 @@ static u64 intel_pt_ns_to_ticks(const struct intel_pt *pt, u64 ns)
 {
 	u64 quot, rem;
 
-	quot = ns / pt->tc.time_mult;
-	rem  = ns % pt->tc.time_mult;
-	return (quot << pt->tc.time_shift) + (rem << pt->tc.time_shift) /
-		pt->tc.time_mult;
+	quot = ns / pt->ns_time_mult;
+	rem  = ns % pt->ns_time_mult;
+	return (quot << pt->ns_time_shift) + (rem << pt->ns_time_shift) /
+		pt->ns_time_mult;
 }
 
 static struct ip_callchain *intel_pt_alloc_chain(struct intel_pt *pt)
@@ -3987,6 +3989,17 @@ int intel_pt_process_auxtrace_info(union perf_event *event,
 				pt->cap_event_trace);
 	}
 
+	if ((void *)info < info_end) {
+		pt->ns_time_shift = *info++;
+		pt->ns_time_mult = *info++;
+		if (dump_trace) {
+			fprintf(stdout, "  ns Time Shift       %d\n", pt->ns_time_shift);
+			fprintf(stdout, "  ns Time Multiplier  %d\n", pt->ns_time_mult);
+		}
+	}
+	if (!pt->ns_time_mult)
+		pt->ns_time_mult = 1;
+
 	pt->timeless_decoding = intel_pt_timeless_decoding(pt);
 	if (pt->timeless_decoding && !pt->tc.time_mult)
 		pt->tc.time_mult = 1;
diff --git a/tools/perf/util/intel-pt.h b/tools/perf/util/intel-pt.h
index c7d6068e3a6b..a2c4474641c0 100644
--- a/tools/perf/util/intel-pt.h
+++ b/tools/perf/util/intel-pt.h
@@ -27,7 +27,7 @@ enum {
 	INTEL_PT_CYC_BIT,
 	INTEL_PT_MAX_NONTURBO_RATIO,
 	INTEL_PT_FILTER_STR_LEN,
-	INTEL_PT_AUXTRACE_PRIV_MAX,
+	INTEL_PT_AUXTRACE_PRIV_FIXED,
 };
 
 struct auxtrace_record;
-- 
2.25.1

