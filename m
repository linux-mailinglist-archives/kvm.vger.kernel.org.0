Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B65A54AF056
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 12:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231623AbiBIL5z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 06:57:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231379AbiBIL5O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 06:57:14 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ED0FE03E22C;
        Wed,  9 Feb 2022 02:56:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644404200; x=1675940200;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=29bl/kV2j4h8E0ChTQ4IHW+W/ZMcObLTcVjx5zQdF58=;
  b=XgbQSWNLzQvn087joWXSrmyV9b/af5rSOO1tndZgV0OnhnG/ZHGmW4cx
   Emldo7VOiBVZUnoHeDN4Wkk/8I1HqbeB4nyYqK3RzgD58ZJECKUbCSe/Q
   Bcgz6A+3nRb9wmNjvosvrGg0yci20mXhbSMG6X2vTBVbFpLXubCc3SLTM
   m+MZWXW2I8TXtzY3r4v1wsKeXhsQZRSzcXsryaVZi17xHI4RLtDSmF8H4
   UeMTgTrh2QPuBwzecmxR5rIOdU3EpZnq2gcLdWKhTuW9sz16x2ViynZGC
   4P3kVpy04XwUhm4eEsznFjGu4ArhUumknjPAV5tWoEMNnLgXMJmkodkiV
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10252"; a="229128583"
X-IronPort-AV: E=Sophos;i="5.88,355,1635231600"; 
   d="scan'208";a="229128583"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2022 00:49:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,355,1635231600"; 
   d="scan'208";a="568169215"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.92])
  by orsmga001.jf.intel.com with ESMTP; 09 Feb 2022 00:49:43 -0800
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
Subject: [PATCH 03/11] perf/x86: Add support for TSC in nanoseconds as a perf event clock
Date:   Wed,  9 Feb 2022 10:49:21 +0200
Message-Id: <20220209084929.54331-4-adrian.hunter@intel.com>
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

Currently, when Intel PT is used within a VM guest, it is not possible to
make use of TSC because perf clock is subject to paravirtualization.

If the hypervisor leaves rdtsc alone, the TSC value will be subject only to
the VMCS TSC Offset and Scaling, the same as the TSC packet from Intel PT.
The new clock is based on rdtsc and not subject to paravirtualization.

Hence it would be possible to use this new clock for Intel PT decoding
within a VM guest.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 arch/x86/events/core.c            | 43 +++++++++++++++++++++----------
 arch/x86/include/asm/perf_event.h |  2 ++
 include/uapi/linux/perf_event.h   |  6 +++++
 kernel/events/core.c              |  6 +++++
 4 files changed, 43 insertions(+), 14 deletions(-)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index e2ad3f9cca93..e81374f0ccaa 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -41,6 +41,7 @@
 #include <asm/desc.h>
 #include <asm/ldt.h>
 #include <asm/unwind.h>
+#include <asm/tsc.h>
 
 #include "perf_event.h"
 
@@ -2728,39 +2729,48 @@ void arch_perf_update_userpage(struct perf_event *event,
 		!!(event->hw.flags & PERF_EVENT_FLAG_USER_READ_CNT);
 	userpg->pmc_width = x86_pmu.cntval_bits;
 
-	if (event->attr.use_clockid && event->attr.clockid == CLOCK_PERF_HW_CLOCK) {
-		userpg->cap_user_time_zero = 1;
-		userpg->time_mult = 1;
-		userpg->time_shift = 0;
-		userpg->time_offset = 0;
-		userpg->time_zero = 0;
-		return;
+	if (event->attr.use_clockid) {
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
+	userpg->cap_user_time = using_native_sched_clock();
+	if (sched_clock_stable()) {
+		offset = __sched_clock_offset;
+	} else {
+		offset = 0;
+		userpg->cap_user_time = 0;
 	}
 
-	if (!using_native_sched_clock() || !sched_clock_stable())
+	if (!userpg->cap_user_time && !userpg->cap_user_time_zero)
 		return;
 
 	cyc2ns_read_begin(&data);
 
-	offset = data.cyc2ns_offset + __sched_clock_offset;
+	offset += data.cyc2ns_offset;
 
 	/*
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
@@ -2994,6 +3004,11 @@ u64 perf_hw_clock(void)
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
index 150d2b70a41f..28d5d6a7d89f 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -297,6 +297,12 @@ enum {
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
index aab78f033711..d048f8aae0a6 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -12041,6 +12041,12 @@ static int perf_event_set_clock(struct perf_event *event, clockid_t clk_id)
 		nmi_safe = true;
 		break;
 #endif
+#ifdef perf_hw_clock_ns
+	case CLOCK_PERF_HW_CLOCK_NS:
+		event->clock = &perf_hw_clock_ns;
+		nmi_safe = true;
+		break;
+#endif
 
 	default:
 		return -EINVAL;
-- 
2.25.1

