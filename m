Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81ADF4B4E80
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 12:34:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351652AbiBNLaH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 06:30:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:32886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236996AbiBNL3v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 06:29:51 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 100DC1EEDA;
        Mon, 14 Feb 2022 03:09:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644836993; x=1676372993;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qfhyjNhEDmCvdp+3iUYcaBO40g5ag8bZdhxaEEeIDNk=;
  b=FQW9RW/qP43vRr2Tpi17QjCGOvcA/ddxcvohf89v1dnBAJ+S3TYdenmp
   rdcn3BJYjyiGshgPZMQZxn0jwywxd9iQab/JGMI/8FiL3HSjiM8Wu0P9L
   LHCufHXjPQ2yERWvQcDmTFKI4pb7VvNU5pTA7MG5avybpDNCq2dJ60G0J
   Il+ZKJVgdWfaa9vNGKYnayWHrV2yuf0jJIm2HCqFdW4b59naOKIhfvWE7
   s4Ss9KXDBSU+ov3ohzw4duKIS7+ofWmlozg3voGPaxcXAmSufZInFpv5l
   0uiBHAUhUrL2WamE0WeH5JQ6lASqnlf5CF4RqfrzLiAiqUy/PVP6Yh1M6
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10257"; a="274639396"
X-IronPort-AV: E=Sophos;i="5.88,367,1635231600"; 
   d="scan'208";a="274639396"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2022 03:09:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,367,1635231600"; 
   d="scan'208";a="635103488"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.92])
  by orsmga004.jf.intel.com with ESMTP; 14 Feb 2022 03:09:43 -0800
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
Subject: [PATCH V2 04/11] perf tools: Add new perf clock IDs
Date:   Mon, 14 Feb 2022 13:09:07 +0200
Message-Id: <20220214110914.268126-5-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220214110914.268126-1-adrian.hunter@intel.com>
References: <20220214110914.268126-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
 tools/include/uapi/linux/perf_event.h     | 18 +++++++++++++++++-
 tools/perf/Documentation/perf-record.txt  |  9 ++++++++-
 tools/perf/builtin-record.c               |  2 +-
 tools/perf/util/clockid.c                 | 13 +++++++++++++
 tools/perf/util/evsel.c                   |  1 +
 tools/perf/util/perf_event_attr_fprintf.c |  1 +
 tools/perf/util/record.h                  |  1 +
 7 files changed, 42 insertions(+), 3 deletions(-)

diff --git a/tools/include/uapi/linux/perf_event.h b/tools/include/uapi/linux/perf_event.h
index 1b65042ab1db..7b3455dfda23 100644
--- a/tools/include/uapi/linux/perf_event.h
+++ b/tools/include/uapi/linux/perf_event.h
@@ -290,6 +290,21 @@ enum {
 	PERF_TXN_ABORT_SHIFT = 32,
 };
 
+/*
+ * If supported, clockid value to select an architecture dependent hardware
+ * clock. Note this means the unit of time is ticks not nanoseconds.
+ * Requires ns_clockid to be set in addition to use_clockid.
+ * On x86, this clock is provided by the rdtsc instruction, and is not
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
@@ -409,7 +424,8 @@ struct perf_event_attr {
 				inherit_thread :  1, /* children only inherit if cloned with CLONE_THREAD */
 				remove_on_exec :  1, /* event is removed from task on exec */
 				sigtrap        :  1, /* send synchronous SIGTRAP on event */
-				__reserved_1   : 26;
+				ns_clockid     :  1, /* non-standard clockid */
+				__reserved_1   : 25;
 
 	union {
 		__u32		wakeup_events;	  /* wakeup every n events */
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
index bb716c953d02..febb51bac6ac 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -1553,7 +1553,7 @@ static int record__init_clock(struct record *rec)
 	struct timeval ref_tod;
 	u64 ref;
 
-	if (!rec->opts.use_clockid)
+	if (!rec->opts.use_clockid || rec->opts.ns_clockid)
 		return 0;
 
 	if (rec->opts.use_clockid && rec->opts.clockid_res_ns)
diff --git a/tools/perf/util/clockid.c b/tools/perf/util/clockid.c
index 74365a5d99c1..2fcffee690e1 100644
--- a/tools/perf/util/clockid.c
+++ b/tools/perf/util/clockid.c
@@ -12,11 +12,15 @@
 struct clockid_map {
 	const char *name;
 	int clockid;
+	bool non_standard;
 };
 
 #define CLOCKID_MAP(n, c)	\
 	{ .name = n, .clockid = (c), }
 
+#define CLOCKID_MAP_NS(n, c)	\
+	{ .name = n, .clockid = (c), .non_standard = true, }
+
 #define CLOCKID_END	{ .name = NULL, }
 
 
@@ -49,6 +53,10 @@ static const struct clockid_map clockids[] = {
 	CLOCKID_MAP("real", CLOCK_REALTIME),
 	CLOCKID_MAP("boot", CLOCK_BOOTTIME),
 
+	/* non-standard clocks */
+	CLOCKID_MAP_NS("perf_hw_clock", CLOCK_PERF_HW_CLOCK),
+	CLOCKID_MAP_NS("perf_hw_clock_ns", CLOCK_PERF_HW_CLOCK_NS),
+
 	CLOCKID_END,
 };
 
@@ -97,6 +105,11 @@ int parse_clockid(const struct option *opt, const char *str, int unset)
 	for (cm = clockids; cm->name; cm++) {
 		if (!strcasecmp(str, cm->name)) {
 			opts->clockid = cm->clockid;
+			if (cm->non_standard) {
+				opts->ns_clockid = true;
+				opts->clockid_res_ns = 0;
+				return 0;
+			}
 			return get_clockid_res(opts->clockid,
 					       &opts->clockid_res_ns);
 		}
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 22d3267ce294..be1d30490a43 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1294,6 +1294,7 @@ void evsel__config(struct evsel *evsel, struct record_opts *opts,
 	clockid = opts->clockid;
 	if (opts->use_clockid) {
 		attr->use_clockid = 1;
+		attr->ns_clockid = opts->ns_clockid;
 		attr->clockid = opts->clockid;
 	}
 
diff --git a/tools/perf/util/perf_event_attr_fprintf.c b/tools/perf/util/perf_event_attr_fprintf.c
index 98af3fa4ea35..398f05f2e5b3 100644
--- a/tools/perf/util/perf_event_attr_fprintf.c
+++ b/tools/perf/util/perf_event_attr_fprintf.c
@@ -128,6 +128,7 @@ int perf_event_attr__fprintf(FILE *fp, struct perf_event_attr *attr,
 	PRINT_ATTRf(mmap2, p_unsigned);
 	PRINT_ATTRf(comm_exec, p_unsigned);
 	PRINT_ATTRf(use_clockid, p_unsigned);
+	PRINT_ATTRf(ns_clockid, p_unsigned);
 	PRINT_ATTRf(context_switch, p_unsigned);
 	PRINT_ATTRf(write_backward, p_unsigned);
 	PRINT_ATTRf(namespaces, p_unsigned);
diff --git a/tools/perf/util/record.h b/tools/perf/util/record.h
index ef6c2715fdd9..1dbbf6b314dc 100644
--- a/tools/perf/util/record.h
+++ b/tools/perf/util/record.h
@@ -67,6 +67,7 @@ struct record_opts {
 	bool	      sample_transaction;
 	int	      initial_delay;
 	bool	      use_clockid;
+	bool	      ns_clockid;
 	clockid_t     clockid;
 	u64	      clockid_res_ns;
 	int	      nr_cblocks;
-- 
2.25.1

