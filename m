Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C096B4B4E61
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 12:34:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351388AbiBNLcL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 06:32:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351479AbiBNL3s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 06:29:48 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 090261AF1A;
        Mon, 14 Feb 2022 03:09:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644836977; x=1676372977;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qHcNmmDcNOzFCPG3xh0TL+8mrKbFALsDkwhy3+agETA=;
  b=QgcadQSk8a74iPsYgOXxqsjh4xzyC3S2ZfTr4GJ00Gn6N79YCfYDeMGf
   h5gkOfZ3bRZUiSxJUf85W3CfwOg/s0UuxUDb7pSOqtCn0O0ZJmLKvB0EK
   ONmJhMSCBbTTHX4AA7kA2tW33JQ/dCQQ7JQYOLA9dMfI2bckmc1frBbzJ
   3Zr47sSsvw+H9C67vXhwxt1IqO6Tt+BR4pNeNmUea+rOvB6MeDDvJu1J1
   JAKbKbT1FU3SGKWUqqVcyj90BcB/xSAmcMLrM7fymDC0Ipc1JlDsMYelc
   W9Fldbun7JefGZ4SF14mWL0etTv7svdRVi746OcESjGKg5oS5KHgMOJOW
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10257"; a="336494884"
X-IronPort-AV: E=Sophos;i="5.88,367,1635231600"; 
   d="scan'208";a="336494884"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2022 03:09:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,367,1635231600"; 
   d="scan'208";a="635103294"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.92])
  by orsmga004.jf.intel.com with ESMTP; 14 Feb 2022 03:09:29 -0800
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
Subject: [PATCH V2 02/11] perf/x86: Add support for TSC as a perf event clock
Date:   Mon, 14 Feb 2022 13:09:05 +0200
Message-Id: <20220214110914.268126-3-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220214110914.268126-1-adrian.hunter@intel.com>
References: <20220214110914.268126-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, using Intel PT to trace a VM guest is limited to kernel space
because decoding requires side band events such as MMAP and CONTEXT_SWITCH.
While these events can be collected for the host, there is not a way to do
that yet for a guest. One approach, would be to collect them inside the
guest, but that would require being able to synchronize with host
timestamps.

The motivation for this patch is to provide a clock that can be used within
a VM guest, and that correlates to a VM host clock. In the case of TSC, if
the hypervisor leaves rdtsc alone, the TSC value will be subject only to
the VMCS TSC Offset and Scaling. Adjusting for that would make it possible
to inject events from a guest perf.data file, into a host perf.data file.

Thus making possible the collection of VM guest side band for Intel PT
decoding.

There are other potential benefits of TSC as a perf event clock:
	- ability to work directly with TSC
	- ability to inject non-Intel-PT-related events from a guest

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 arch/x86/events/core.c            | 16 +++++++++
 arch/x86/include/asm/perf_event.h |  3 ++
 include/uapi/linux/perf_event.h   | 12 ++++++-
 kernel/events/core.c              | 57 +++++++++++++++++++------------
 4 files changed, 65 insertions(+), 23 deletions(-)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index e686c5e0537b..51d5345de30a 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -2728,6 +2728,17 @@ void arch_perf_update_userpage(struct perf_event *event,
 		!!(event->hw.flags & PERF_EVENT_FLAG_USER_READ_CNT);
 	userpg->pmc_width = x86_pmu.cntval_bits;
 
+	if (event->attr.use_clockid &&
+	    event->attr.ns_clockid &&
+	    event->attr.clockid == CLOCK_PERF_HW_CLOCK) {
+		userpg->cap_user_time_zero = 1;
+		userpg->time_mult = 1;
+		userpg->time_shift = 0;
+		userpg->time_offset = 0;
+		userpg->time_zero = 0;
+		return;
+	}
+
 	if (!using_native_sched_clock() || !sched_clock_stable())
 		return;
 
@@ -2980,6 +2991,11 @@ unsigned long perf_misc_flags(struct pt_regs *regs)
 	return misc;
 }
 
+u64 perf_hw_clock(void)
+{
+	return rdtsc_ordered();
+}
+
 void perf_get_x86_pmu_capability(struct x86_pmu_capability *cap)
 {
 	cap->version		= x86_pmu.version;
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 58d9e4b1fa0a..5288ea1ae2ba 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -451,6 +451,9 @@ extern unsigned long perf_instruction_pointer(struct pt_regs *regs);
 extern unsigned long perf_misc_flags(struct pt_regs *regs);
 #define perf_misc_flags(regs)	perf_misc_flags(regs)
 
+extern u64 perf_hw_clock(void);
+#define perf_hw_clock		perf_hw_clock
+
 #include <asm/stacktrace.h>
 
 /*
diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 82858b697c05..e8617efd552b 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -290,6 +290,15 @@ enum {
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
+
 /*
  * The format of the data returned by read() on a perf event fd,
  * as specified by attr.read_format:
@@ -409,7 +418,8 @@ struct perf_event_attr {
 				inherit_thread :  1, /* children only inherit if cloned with CLONE_THREAD */
 				remove_on_exec :  1, /* event is removed from task on exec */
 				sigtrap        :  1, /* send synchronous SIGTRAP on event */
-				__reserved_1   : 26;
+				ns_clockid     :  1, /* non-standard clockid */
+				__reserved_1   : 25;
 
 	union {
 		__u32		wakeup_events;	  /* wakeup every n events */
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 57249f37c37d..15dee265a5b9 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -12008,35 +12008,48 @@ static void mutex_lock_double(struct mutex *a, struct mutex *b)
 	mutex_lock_nested(b, SINGLE_DEPTH_NESTING);
 }
 
-static int perf_event_set_clock(struct perf_event *event, clockid_t clk_id)
+static int perf_event_set_clock(struct perf_event *event, clockid_t clk_id, bool ns_clockid)
 {
 	bool nmi_safe = false;
 
-	switch (clk_id) {
-	case CLOCK_MONOTONIC:
-		event->clock = &ktime_get_mono_fast_ns;
-		nmi_safe = true;
-		break;
+	if (ns_clockid) {
+		switch (clk_id) {
+#ifdef perf_hw_clock
+		case CLOCK_PERF_HW_CLOCK:
+			event->clock = &perf_hw_clock;
+			nmi_safe = true;
+			break;
+#endif
+		default:
+			return -EINVAL;
+		}
+	} else {
+		switch (clk_id) {
+		case CLOCK_MONOTONIC:
+			event->clock = &ktime_get_mono_fast_ns;
+			nmi_safe = true;
+			break;
 
-	case CLOCK_MONOTONIC_RAW:
-		event->clock = &ktime_get_raw_fast_ns;
-		nmi_safe = true;
-		break;
+		case CLOCK_MONOTONIC_RAW:
+			event->clock = &ktime_get_raw_fast_ns;
+			nmi_safe = true;
+			break;
 
-	case CLOCK_REALTIME:
-		event->clock = &ktime_get_real_ns;
-		break;
+		case CLOCK_REALTIME:
+			event->clock = &ktime_get_real_ns;
+			break;
 
-	case CLOCK_BOOTTIME:
-		event->clock = &ktime_get_boottime_ns;
-		break;
+		case CLOCK_BOOTTIME:
+			event->clock = &ktime_get_boottime_ns;
+			break;
 
-	case CLOCK_TAI:
-		event->clock = &ktime_get_clocktai_ns;
-		break;
+		case CLOCK_TAI:
+			event->clock = &ktime_get_clocktai_ns;
+			break;
 
-	default:
-		return -EINVAL;
+		default:
+			return -EINVAL;
+		}
 	}
 
 	if (!nmi_safe && !(event->pmu->capabilities & PERF_PMU_CAP_NO_NMI))
@@ -12245,7 +12258,7 @@ SYSCALL_DEFINE5(perf_event_open,
 	pmu = event->pmu;
 
 	if (attr.use_clockid) {
-		err = perf_event_set_clock(event, attr.clockid);
+		err = perf_event_set_clock(event, attr.clockid, attr.ns_clockid);
 		if (err)
 			goto err_alloc;
 	}
-- 
2.25.1

