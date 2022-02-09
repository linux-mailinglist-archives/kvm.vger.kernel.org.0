Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7AA04AED38
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 09:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239608AbiBIIxD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 03:53:03 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:43812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238823AbiBIIxA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 03:53:00 -0500
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B33EEDF48F28;
        Wed,  9 Feb 2022 00:52:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644396775; x=1675932775;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sd2FUc95Y8Z/wafs1Ffg650oA/a+/88+ru79bgVwagI=;
  b=Sq+erksLmQ1jnn4El0i0afKLatLfREszbOZyTJPPZUuCQ/p7e/wu7xiV
   6E02RyAVBURQj5nhpEcDnkjQkakkm25BDdeJofm6zEoWbWte7fYMU0eJs
   KoyjTkw2qoHTpxHqiuB6839l80OX0iPD3Rz0z29kMCUDq612djRoLbBbC
   W7qt3qOayEePVHA4v77SiQSbwK/0FLQbV6B+sJweh5JjWCGSAZPk/A7pj
   pQRbDUtA38AFwrmRIbullrXi5EeP6sDUfL6vYe10A37N9mgVuAE6q6YxJ
   3y+DRyKC0+7nH/E6unkYQeGxKdCibIWFmBugp0ci1ukZR2Ffr/CWk66P4
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10252"; a="309903026"
X-IronPort-AV: E=Sophos;i="5.88,355,1635231600"; 
   d="scan'208";a="309903026"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2022 00:50:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,355,1635231600"; 
   d="scan'208";a="568169367"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.92])
  by orsmga001.jf.intel.com with ESMTP; 09 Feb 2022 00:50:05 -0800
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
Subject: [PATCH 08/11] perf intel-pt: Add support for new clock IDs
Date:   Wed,  9 Feb 2022 10:49:26 +0200
Message-Id: <20220209084929.54331-9-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220209084929.54331-1-adrian.hunter@intel.com>
References: <20220209084929.54331-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
 tools/perf/arch/x86/util/intel-pt.c | 36 ++++++++++++++++++++++++++---
 tools/perf/util/intel-pt.c          | 21 +++++++++++++----
 tools/perf/util/intel-pt.h          |  2 +-
 3 files changed, 51 insertions(+), 8 deletions(-)

diff --git a/tools/perf/arch/x86/util/intel-pt.c b/tools/perf/arch/x86/util/intel-pt.c
index 8c31578d6f4a..ce5dc70e392a 100644
--- a/tools/perf/arch/x86/util/intel-pt.c
+++ b/tools/perf/arch/x86/util/intel-pt.c
@@ -290,6 +290,20 @@ static const char *intel_pt_find_filter(struct evlist *evlist,
 	return NULL;
 }
 
+static bool intel_pt_clockid(struct evlist *evlist, struct perf_pmu *intel_pt_pmu, s32 clockid)
+{
+	struct evsel *evsel;
+
+	evlist__for_each_entry(evlist, evsel) {
+		if (evsel->core.attr.type == intel_pt_pmu->type &&
+		    evsel->core.attr.use_clockid &&
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
@@ -304,9 +318,11 @@ intel_pt_info_priv_size(struct auxtrace_record *itr, struct evlist *evlist)
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
@@ -414,6 +430,18 @@ static int intel_pt_info_fill(struct auxtrace_record *itr,
 
 	*info++ = event_trace;
 
+	if (intel_pt_clockid(session->evlist, ptr->intel_pt_pmu, CLOCK_PERF_HW_CLOCK)) {
+		struct perf_tsc_conversion ns_tc;
+
+		if (perf_read_tsc_conv_for_clockid(CLOCK_PERF_HW_CLOCK_NS, &ns_tc))
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
 
@@ -664,8 +692,10 @@ static int intel_pt_recording_options(struct auxtrace_record *itr,
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

