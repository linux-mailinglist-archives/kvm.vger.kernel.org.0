Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C530F4AF05E
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 12:58:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231646AbiBIL57 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 06:57:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbiBIL5K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 06:57:10 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC13E03E22B;
        Wed,  9 Feb 2022 02:56:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644404200; x=1675940200;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UjE7mw19dKJDom0MhaIR0CBU7W0myMKVcMbKBeE/xDk=;
  b=LPHxBdeRsVsHIsNSq0c5Gh+z07PzXfK7N39AsS20LC1tjjEboHT68eRa
   pdr8uQoXr66uAjYZjunamBTgjgeAswTWxWWXKnIe/DmkddDbuTyh1bmAy
   YZqUGQAUv8t8Upon7UcSsNJj1oIAMuB0MorMiXTXsdf4Qz6o3M6+JlVV8
   /bHjQAPDoevn+oruEZmaWA955MAZbhJNjohS1cV8lZOUkoY42OX8qwa5k
   cF4UaaVay1x6NGg/RQ6VwPns39vdnjdTZlQqOuzH/18yqRlbJx1HYzGmf
   1LNjjkKsW0aTnGejfKv5w0X2eRVHYi/erlR7iKJYrxYH5Y5nmckqmy5ur
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10252"; a="229128582"
X-IronPort-AV: E=Sophos;i="5.88,355,1635231600"; 
   d="scan'208";a="229128582"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2022 00:49:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,355,1635231600"; 
   d="scan'208";a="568169205"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.92])
  by orsmga001.jf.intel.com with ESMTP; 09 Feb 2022 00:49:38 -0800
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
Subject: [PATCH 02/11] perf/x86: Add support for TSC as a perf event clock
Date:   Wed,  9 Feb 2022 10:49:20 +0200
Message-Id: <20220209084929.54331-3-adrian.hunter@intel.com>
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
 arch/x86/events/core.c            | 14 ++++++++++++++
 arch/x86/include/asm/perf_event.h |  3 +++
 include/uapi/linux/perf_event.h   |  8 ++++++++
 kernel/events/core.c              |  7 +++++++
 4 files changed, 32 insertions(+)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index e686c5e0537b..e2ad3f9cca93 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -2728,6 +2728,15 @@ void arch_perf_update_userpage(struct perf_event *event,
 		!!(event->hw.flags & PERF_EVENT_FLAG_USER_READ_CNT);
 	userpg->pmc_width = x86_pmu.cntval_bits;
 
+	if (event->attr.use_clockid && event->attr.clockid == CLOCK_PERF_HW_CLOCK) {
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
 
@@ -2980,6 +2989,11 @@ unsigned long perf_misc_flags(struct pt_regs *regs)
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
index 82858b697c05..150d2b70a41f 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -290,6 +290,14 @@ enum {
 	PERF_TXN_ABORT_SHIFT = 32,
 };
 
+/*
+ * If supported, clockid value to select an architecture dependent hardware
+ * clock. Note this means the unit of time is ticks not nanoseconds.
+ * On x86, this is provided by the rdtsc instruction, and is not
+ * paravirtualized.
+ */
+#define CLOCK_PERF_HW_CLOCK		0x10000000
+
 /*
  * The format of the data returned by read() on a perf event fd,
  * as specified by attr.read_format:
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 57249f37c37d..aab78f033711 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -12035,6 +12035,13 @@ static int perf_event_set_clock(struct perf_event *event, clockid_t clk_id)
 		event->clock = &ktime_get_clocktai_ns;
 		break;
 
+#ifdef perf_hw_clock
+	case CLOCK_PERF_HW_CLOCK:
+		event->clock = &perf_hw_clock;
+		nmi_safe = true;
+		break;
+#endif
+
 	default:
 		return -EINVAL;
 	}
-- 
2.25.1

