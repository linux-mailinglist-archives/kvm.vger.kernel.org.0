Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF3184B4E64
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 12:34:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351717AbiBNLaP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 06:30:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351591AbiBNLaE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 06:30:04 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC2053F330;
        Mon, 14 Feb 2022 03:10:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644837030; x=1676373030;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HZyKlivBJVracpXVtojvKyOOpvqQ92VuUPK768htRH0=;
  b=FFB8RGVNxxqrY160F2Eg4er/+PBNoihEC4BlWGCBkib9kt+PydinJhAX
   gUi2sufCVK4b0bEYy7+q14N6q/be+HEy36h2ayJU+M4iQFLznM7SCO7E/
   o6dvjQuRLn7BbAj1SFc8RmgMMx5hTQG7T8/WARQTW2ZloY0fgljtU+3u2
   QXuO6FL9zHN9PWC28jyW+AhbfLEtW77avIVE3rWOtVBNUgDGNt9IBIsNB
   5m6vb9rMRGDzKvEqTfJSOuIHNvJgj+cm/oVE8fQqHuHZYylsOO5bcmijY
   T+v0/j0I55bxQT67Ec90TDgUSwrm4ZOMtQ24Rh+zgToLvgktdsd5uQWoi
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10257"; a="247662934"
X-IronPort-AV: E=Sophos;i="5.88,367,1635231600"; 
   d="scan'208";a="247662934"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2022 03:10:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,367,1635231600"; 
   d="scan'208";a="635103855"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.92])
  by orsmga004.jf.intel.com with ESMTP; 14 Feb 2022 03:10:24 -0800
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
Subject: [PATCH V2 10/11] perf intel-pt: Add config variables for timing parameters
Date:   Mon, 14 Feb 2022 13:09:13 +0200
Message-Id: <20220214110914.268126-11-adrian.hunter@intel.com>
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

Parameters needed to correctly interpret timing packets might be missing
in a virtual machine because the CPUID leaf or MSR is not supported by the
hypervisor / KVM.

Add perf config variables to overcome that for max_nonturbo_ratio
(missing from MSR_PLATFORM_INFO) and tsc_art_ratio (missing from CPUID leaf
 0x15), which were seen to be missing from QEMU / KVM.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/Documentation/perf-config.txt | 18 ++++++++
 tools/perf/arch/x86/util/intel-pt.c      | 52 +++++++++++++++++++++++-
 tools/perf/util/intel-pt.c               |  6 +++
 tools/perf/util/intel-pt.h               |  5 +++
 4 files changed, 79 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-config.txt b/tools/perf/Documentation/perf-config.txt
index 0420e71698ee..3c4fc641fde7 100644
--- a/tools/perf/Documentation/perf-config.txt
+++ b/tools/perf/Documentation/perf-config.txt
@@ -709,7 +709,11 @@ stat.*::
 
 intel-pt.*::
 
+	Variables that affect Intel PT.
+
 	intel-pt.cache-divisor::
+		If set, the decoder instruction cache size is based on DSO size
+		divided by this number.
 
 	intel-pt.mispred-all::
 		If set, Intel PT decoder will set the mispred flag on all
@@ -721,6 +725,20 @@ intel-pt.*::
 		the maximum is exceeded there will be a "Never-ending loop"
 		error. The default is 100000.
 
+	intel-pt.max_nonturbo_ratio::
+		The kernel provides /sys/bus/event_source/devices/intel_pt/max_nonturbo_ratio
+		which can be zero in a virtual machine.  The decoder needs this
+		information to correctly interpret timing packets, so the value
+		can be provided by this variable in that case. Note in the absence
+		of VMCS TSC Scaling, this is probably the same as the host value.
+
+	intel-pt.tsc_art_ratio::
+		The kernel provides /sys/bus/event_source/devices/intel_pt/tsc_art_ratio
+		which can be 0:0 in a virtual machine.  The decoder needs this
+		information to correctly interpret timing packets, so the value
+		can be provided by this variable in that case. Note in the absence
+		of VMCS TSC Scaling, this is probably the same as the host value.
+
 auxtrace.*::
 
 	auxtrace.dumpdir::
diff --git a/tools/perf/arch/x86/util/intel-pt.c b/tools/perf/arch/x86/util/intel-pt.c
index bba55b6f75b6..d7f6a73095e3 100644
--- a/tools/perf/arch/x86/util/intel-pt.c
+++ b/tools/perf/arch/x86/util/intel-pt.c
@@ -24,6 +24,7 @@
 #include "../../../util/parse-events.h"
 #include "../../../util/pmu.h"
 #include "../../../util/debug.h"
+#include "../../../util/config.h"
 #include "../../../util/auxtrace.h"
 #include "../../../util/perf_api_probe.h"
 #include "../../../util/record.h"
@@ -328,15 +329,60 @@ intel_pt_info_priv_size(struct auxtrace_record *itr, struct evlist *evlist)
 	return ptr->priv_size;
 }
 
+struct tsc_art_ratio {
+	u32 *n;
+	u32 *d;
+};
+
+static int intel_pt_tsc_art_ratio(const char *var, const char *value, void *data)
+{
+	if (!strcmp(var, "intel-pt.tsc_art_ratio")) {
+		struct tsc_art_ratio *r = data;
+
+		if (sscanf(value, "%u:%u", r->n, r->d) != 2)
+			return -EINVAL;
+	}
+	return 0;
+}
+
+void intel_pt_tsc_ctc_ratio_from_config(u32 *n, u32 *d)
+{
+	struct tsc_art_ratio data = { .n = n, .d = d };
+
+	*n = 0;
+	*d = 0;
+	perf_config(intel_pt_tsc_art_ratio, &data);
+}
+
 static void intel_pt_tsc_ctc_ratio(u32 *n, u32 *d)
 {
 	unsigned int eax = 0, ebx = 0, ecx = 0, edx = 0;
 
 	__get_cpuid(0x15, &eax, &ebx, &ecx, &edx);
+	if (!eax || !ebx) {
+		intel_pt_tsc_ctc_ratio_from_config(n, d);
+		return;
+	}
 	*n = ebx;
 	*d = eax;
 }
 
+static int intel_pt_max_nonturbo_ratio(const char *var, const char *value, void *data)
+{
+	if (!strcmp(var, "intel-pt.max_nonturbo_ratio")) {
+		unsigned int *max_nonturbo_ratio = data;
+
+		if (sscanf(value, "%u", max_nonturbo_ratio) != 1)
+			return -EINVAL;
+	}
+	return 0;
+}
+
+void intel_pt_max_nonturbo_ratio_from_config(unsigned int *max_non_turbo_ratio)
+{
+	perf_config(intel_pt_max_nonturbo_ratio, max_non_turbo_ratio);
+}
+
 static int intel_pt_info_fill(struct auxtrace_record *itr,
 			      struct perf_session *session,
 			      struct perf_record_auxtrace_info *auxtrace_info,
@@ -350,7 +396,7 @@ static int intel_pt_info_fill(struct auxtrace_record *itr,
 	bool cap_user_time_zero = false, per_cpu_mmaps;
 	u64 tsc_bit, mtc_bit, mtc_freq_bits, cyc_bit, noretcomp_bit;
 	u32 tsc_ctc_ratio_n, tsc_ctc_ratio_d;
-	unsigned long max_non_turbo_ratio;
+	unsigned int max_non_turbo_ratio;
 	size_t filter_str_len;
 	const char *filter;
 	int event_trace;
@@ -374,8 +420,10 @@ static int intel_pt_info_fill(struct auxtrace_record *itr,
 	intel_pt_tsc_ctc_ratio(&tsc_ctc_ratio_n, &tsc_ctc_ratio_d);
 
 	if (perf_pmu__scan_file(intel_pt_pmu, "max_nonturbo_ratio",
-				"%lu", &max_non_turbo_ratio) != 1)
+				"%u", &max_non_turbo_ratio) != 1)
 		max_non_turbo_ratio = 0;
+	if (!max_non_turbo_ratio)
+		intel_pt_max_nonturbo_ratio_from_config(&max_non_turbo_ratio);
 	if (perf_pmu__scan_file(intel_pt_pmu, "caps/event_trace",
 				"%d", &event_trace) != 1)
 		event_trace = 0;
diff --git a/tools/perf/util/intel-pt.c b/tools/perf/util/intel-pt.c
index 10d47759a41e..6fa76b584537 100644
--- a/tools/perf/util/intel-pt.c
+++ b/tools/perf/util/intel-pt.c
@@ -3934,6 +3934,9 @@ int intel_pt_process_auxtrace_info(union perf_event *event,
 				    INTEL_PT_CYC_BIT);
 	}
 
+	if (!pt->tsc_ctc_ratio_n || !pt->tsc_ctc_ratio_d)
+		intel_pt_tsc_ctc_ratio_from_config(&pt->tsc_ctc_ratio_n, &pt->tsc_ctc_ratio_d);
+
 	if (intel_pt_has(auxtrace_info, INTEL_PT_MAX_NONTURBO_RATIO)) {
 		pt->max_non_turbo_ratio =
 			auxtrace_info->priv[INTEL_PT_MAX_NONTURBO_RATIO];
@@ -3942,6 +3945,9 @@ int intel_pt_process_auxtrace_info(union perf_event *event,
 				    INTEL_PT_MAX_NONTURBO_RATIO);
 	}
 
+	if (!pt->max_non_turbo_ratio)
+		intel_pt_max_nonturbo_ratio_from_config(&pt->max_non_turbo_ratio);
+
 	info = &auxtrace_info->priv[INTEL_PT_FILTER_STR_LEN] + 1;
 	info_end = (void *)auxtrace_info + auxtrace_info->header.size;
 
diff --git a/tools/perf/util/intel-pt.h b/tools/perf/util/intel-pt.h
index a2c4474641c0..99ac73f4a648 100644
--- a/tools/perf/util/intel-pt.h
+++ b/tools/perf/util/intel-pt.h
@@ -7,6 +7,8 @@
 #ifndef INCLUDE__PERF_INTEL_PT_H__
 #define INCLUDE__PERF_INTEL_PT_H__
 
+#include <linux/types.h>
+
 #define INTEL_PT_PMU_NAME "intel_pt"
 
 enum {
@@ -44,4 +46,7 @@ int intel_pt_process_auxtrace_info(union perf_event *event,
 
 struct perf_event_attr *intel_pt_pmu_default_config(struct perf_pmu *pmu);
 
+void intel_pt_tsc_ctc_ratio_from_config(u32 *n, u32 *d);
+void intel_pt_max_nonturbo_ratio_from_config(unsigned int *max_non_turbo_ratio);
+
 #endif
-- 
2.25.1

