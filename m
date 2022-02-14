Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29E054B4E82
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 12:34:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351576AbiBNLcQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 06:32:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:32854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351236AbiBNL3t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 06:29:49 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4306B1C91A;
        Mon, 14 Feb 2022 03:09:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644836984; x=1676372984;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4jmg151yDeRVjcnQYpGboO10DRS6jYizSfbjNlgT6NE=;
  b=bLRwq4CrU7R+EgJcs3rY+D1MmG2vZPgvuTrw+0D91S/roKSpzOMMg+tn
   IrzbiUB/dxd4bdoflrJDK3ul9uMvliPQNP16TzndNGm7hBakhacLCbOvr
   rs7dBbPtroHm+Xh4sXhF/smnU1jqDfm+8qp2OlRZJ1HTpjA3HZ+GNFLTh
   4ZpjKV9cWaWuiy95ScMFcUl7dG0dwpwnh1tvPCL4RQ2VN/8np9ZB8+2aG
   1J3hRbq+MzdTJVZr1WOp1d6+H1CMJJzuCyapS9s+p7NHaBTvKd2s0hbmZ
   jvD5hHX+3pQi4+A4Y1Q2CQv956Kv0zWuPORBOimm9x1fwnSmSxMSGm4dw
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10257"; a="274639385"
X-IronPort-AV: E=Sophos;i="5.88,367,1635231600"; 
   d="scan'208";a="274639385"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2022 03:09:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,367,1635231600"; 
   d="scan'208";a="635103413"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.92])
  by orsmga004.jf.intel.com with ESMTP; 14 Feb 2022 03:09:36 -0800
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
Subject: [PATCH V2 03/11] perf/x86: Add support for TSC in nanoseconds as a perf event clock
Date:   Mon, 14 Feb 2022 13:09:06 +0200
Message-Id: <20220214110914.268126-4-adrian.hunter@intel.com>
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

Currently, when Intel PT is used within a VM guest, it is not possible to
make use of TSC because perf clock is subject to paravirtualization.

If the hypervisor leaves rdtsc alone, the TSC value will be subject only to
the VMCS TSC Offset and Scaling, the same as the TSC packet from Intel PT.
The new clock is based on rdtsc and not subject to paravirtualization.

Hence it would be possible to use this new clock for Intel PT decoding
within a VM guest.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 arch/x86/events/core.c            | 41 ++++++++++++++++++++-----------
 arch/x86/include/asm/perf_event.h |  2 ++
 include/uapi/linux/perf_event.h   |  6 +++++
 kernel/events/core.c              |  6 +++++
 4 files changed, 40 insertions(+), 15 deletions(-)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 51d5345de30a..905975a7d475 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -41,6 +41,7 @@
 #include <asm/desc.h>
 #include <asm/ldt.h>
 #include <asm/unwind.h>
+#include <asm/tsc.h>
 
 #include "perf_event.h"
 
@@ -2728,18 +2729,26 @@ void arch_perf_update_userpage(struct perf_event *event,
 		!!(event->hw.flags & PERF_EVENT_FLAG_USER_READ_CNT);
 	userpg->pmc_width = x86_pmu.cntval_bits;
 
-	if (event->attr.use_clockid &&
-	    event->attr.ns_clockid &&
-	    event->attr.clockid == CLOCK_PERF_HW_CLOCK) {
-		userpg->cap_user_time_zero = 1;
-		userpg->time_mult = 1;
-		userpg->time_shift = 0;
-		userpg->time_offset = 0;
-		userpg->time_zero = 0;
-		return;
+	if (event->attr.use_clockid && event->attr.ns_clockid) {
+		if (event->attr.clockid == CLOCK_PERF_HW_CLOCK) {
+			userpg->cap_user_time_zero = 1;
+			userpg->time_mult = 1;
+			userpg->time_shift = 0;
+			userpg->time_offset = 0;
+			userpg->time_zero = 0;
+			return;
+		}
+		if (event->attr.clockid == CLOCK_PERF_HW_CLOCK_NS)
+			userpg->cap_user_time_zero = 1;
+	}
+
+	if (using_native_sched_clock() && sched_clock_stable()) {
+		userpg->cap_user_time = 1;
+		if (!event->attr.use_clockid)
+			userpg->cap_user_time_zero = 1;
 	}
 
-	if (!using_native_sched_clock() || !sched_clock_stable())
+	if (!userpg->cap_user_time && !userpg->cap_user_time_zero)
 		return;
 
 	cyc2ns_read_begin(&data);
@@ -2750,19 +2759,16 @@ void arch_perf_update_userpage(struct perf_event *event,
 	 * Internal timekeeping for enabled/running/stopped times
 	 * is always in the local_clock domain.
 	 */
-	userpg->cap_user_time = 1;
 	userpg->time_mult = data.cyc2ns_mul;
 	userpg->time_shift = data.cyc2ns_shift;
 	userpg->time_offset = offset - now;
 
 	/*
 	 * cap_user_time_zero doesn't make sense when we're using a different
-	 * time base for the records.
+	 * time base for the records, except for CLOCK_PERF_HW_CLOCK_NS.
 	 */
-	if (!event->attr.use_clockid) {
-		userpg->cap_user_time_zero = 1;
+	if (userpg->cap_user_time_zero)
 		userpg->time_zero = offset;
-	}
 
 	cyc2ns_read_end();
 }
@@ -2996,6 +3002,11 @@ u64 perf_hw_clock(void)
 	return rdtsc_ordered();
 }
 
+u64 perf_hw_clock_ns(void)
+{
+	return native_sched_clock_from_tsc(perf_hw_clock());
+}
+
 void perf_get_x86_pmu_capability(struct x86_pmu_capability *cap)
 {
 	cap->version		= x86_pmu.version;
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 5288ea1ae2ba..46cbca90cdd1 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -453,6 +453,8 @@ extern unsigned long perf_misc_flags(struct pt_regs *regs);
 
 extern u64 perf_hw_clock(void);
 #define perf_hw_clock		perf_hw_clock
+extern u64 perf_hw_clock_ns(void);
+#define perf_hw_clock_ns	perf_hw_clock_ns
 
 #include <asm/stacktrace.h>
 
diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index e8617efd552b..0edc005f8ddf 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -298,6 +298,12 @@ enum {
  * paravirtualized.
  */
 #define CLOCK_PERF_HW_CLOCK		0x10000000
+/*
+ * Same as CLOCK_PERF_HW_CLOCK but in nanoseconds. Note support of
+ * CLOCK_PERF_HW_CLOCK_NS does not necesssarily imply support of
+ * CLOCK_PERF_HW_CLOCK or vice versa.
+ */
+#define CLOCK_PERF_HW_CLOCK_NS	0x10000001
 
 /*
  * The format of the data returned by read() on a perf event fd,
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 15dee265a5b9..65e70fb669fd 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -12019,6 +12019,12 @@ static int perf_event_set_clock(struct perf_event *event, clockid_t clk_id, bool
 			event->clock = &perf_hw_clock;
 			nmi_safe = true;
 			break;
+#endif
+#ifdef perf_hw_clock_ns
+		case CLOCK_PERF_HW_CLOCK_NS:
+			event->clock = &perf_hw_clock_ns;
+			nmi_safe = true;
+			break;
 #endif
 		default:
 			return -EINVAL;
-- 
2.25.1

