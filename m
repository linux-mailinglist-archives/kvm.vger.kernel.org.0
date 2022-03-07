Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0687D4CF406
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 09:53:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233903AbiCGIyY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 03:54:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234149AbiCGIyV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 03:54:21 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6907B15A03;
        Mon,  7 Mar 2022 00:53:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646643205; x=1678179205;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=usTsLotS3IpAdfGPpvMJNzmulAHU4pEVranhDE3wmwA=;
  b=H8e/eyllzvW1EJap/hi2pUrR6Vr6u2Alf00n+QeA20YWB8eVwtuzxMIQ
   g0oZcswQ58h/eJjvsBqivsPOtUWL6ADHMfWsV+CH+1AdT7nWS40VR0j8O
   3+MnLfuUSClsEiEBh8lz5HhTCAAdQZv8B5e5Gx6b/xroWCbr797JwQiTk
   WXPnD8p6aWRZ4ScdafPwvy8Z4hWezVsMr9LKxpUUFv6HSa85jm4ESlk+m
   5V4Ar76iOHgroKy2y1N2BdlgZIIp4XR09Amqs6eOcJMf46V2auqUkt7EX
   rPLRekjjhsEAPQsI9+ZmdfFR44xQwrAbRo+of7NjhLMiPY3J/S0TmDaZq
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10278"; a="241771793"
X-IronPort-AV: E=Sophos;i="5.90,161,1643702400"; 
   d="scan'208";a="241771793"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 00:53:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,161,1643702400"; 
   d="scan'208";a="537033497"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.92])
  by orsmga007.jf.intel.com with ESMTP; 07 Mar 2022 00:53:21 -0800
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
Subject: [PATCH V3 02/10] perf/x86: Add support for TSC as a perf event clock
Date:   Mon,  7 Mar 2022 10:53:04 +0200
Message-Id: <20220307085312.1814506-3-adrian.hunter@intel.com>
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
 include/uapi/linux/time.h         | 11 +++++++++++
 kernel/events/core.c              |  7 +++++++
 4 files changed, 35 insertions(+)

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
index 8fc1b5003713..3c75459bdeaf 100644
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
diff --git a/include/uapi/linux/time.h b/include/uapi/linux/time.h
index 4f4b6e48e01c..95602420122e 100644
--- a/include/uapi/linux/time.h
+++ b/include/uapi/linux/time.h
@@ -67,6 +67,17 @@ struct timezone {
 #define CLOCKS_MASK			(CLOCK_REALTIME | CLOCK_MONOTONIC)
 #define CLOCKS_MONO			CLOCK_MONOTONIC
 
+/*
+ * If supported, clockid value for use in struct perf_event_attr to select an
+ * architecture dependent hardware clock. Note this means the unit of time is
+ * ticks not nanoseconds. WARNING: This clock may not be stable or well-behaved
+ * in any way, including varying across different CPUs.
+ *
+ * On x86, this is provided by the rdtsc instruction, and is not
+ * paravirtualized. Note the warning above can also apply to TSC.
+ */
+#define CLOCK_PERF_HW_CLOCK		0x10000000
+
 /*
  * The various flags for setting POSIX.1b interval timers:
  */
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 6859229497b1..e2f06384de50 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -12034,6 +12034,13 @@ static int perf_event_set_clock(struct perf_event *event, clockid_t clk_id)
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

