Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 247C84B4E76
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 12:34:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351621AbiBNLaW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 06:30:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351608AbiBNLaF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 06:30:05 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF534403CD;
        Mon, 14 Feb 2022 03:10:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644837036; x=1676373036;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LMcqPNXnMe4ZfRX2pvOSR54SRmRLNEnmPESpB5J91po=;
  b=iaCW/6D1BVgoXIxxfl0YnafhWCEGR4dzpRErpcfNNsKCkSrt0QXFO/BX
   etIp04lnHoSeWjZ1FZo7hU1r9HebFZC6rAZH5L5nVldPKsmWggl2UrciA
   vRcgx0dViooz70P3Eye79jxR44hHEyh2lwLp1FYYmvJ8qj3yitOE7WVnG
   eQzmxUlHZVXw58pO8nWOTB4kXTMOh1nhTrzsLQcW0GSlPwfSRfgE80Ddt
   69Ly4B8VMn2tQF2a2yGcZzaQqNvYwwX4RpgiSJyQO3Ch/uqvMMQtAHgMC
   ZQjpUhlCD6YmTejPXn+9daV67RDaBJx/yjygi6HjauX1HNJDX8rSzNdKt
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10257"; a="233616257"
X-IronPort-AV: E=Sophos;i="5.88,367,1635231600"; 
   d="scan'208";a="233616257"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2022 03:10:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,367,1635231600"; 
   d="scan'208";a="635103897"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.92])
  by orsmga004.jf.intel.com with ESMTP; 14 Feb 2022 03:10:30 -0800
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
Subject: [PATCH V2 11/11] perf intel-pt: Add documentation for new clock IDs
Date:   Mon, 14 Feb 2022 13:09:14 +0200
Message-Id: <20220214110914.268126-12-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220214110914.268126-1-adrian.hunter@intel.com>
References: <20220214110914.268126-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add brief documentation for new clock IDs CLOCK_PERF_HW_CLOCK and
CLOCK_PERF_HW_CLOCK_NS, as well as new config variables
intel-pt.max_nonturbo_ratio and intel-pt.tsc_art_ratio.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/Documentation/perf-intel-pt.txt | 47 ++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/tools/perf/Documentation/perf-intel-pt.txt b/tools/perf/Documentation/perf-intel-pt.txt
index ff58bd4c381b..45f750024e3d 100644
--- a/tools/perf/Documentation/perf-intel-pt.txt
+++ b/tools/perf/Documentation/perf-intel-pt.txt
@@ -509,6 +509,31 @@ notnt		Disable TNT packets.  Without TNT packets, it is not possible to walk
 		"0" otherwise.
 
 
+perf event clock
+~~~~~~~~~~~~~~~~
+
+Newer kernel and tools support 2 special clocks: CLOCK_PERF_HW_CLOCK which is
+TSC and CLOCK_PERF_HW_CLOCK_NS which is TSC converted to nanoseconds.
+CLOCK_PERF_HW_CLOCK_NS is the same as the default perf event clock, but it is
+not subject to paravirtualization, so it still works with Intel PT in a VM
+guest.  CLOCK_PERF_HW_CLOCK_NS is used by default if it is supported.
+
+To use TSC instead of nanoseconds, use the option:
+
+	--clockid CLOCK_PERF_HW_CLOCK
+
+Beware forgetting that the time stamp of events will show TSC ticks
+(divided by 1,000,000,000) not seconds.
+
+To use the default perf event clock instead of CLOCK_PERF_HW_CLOCK_NS when
+CLOCK_PERF_HW_CLOCK_NS is supported, use the option:
+
+	--no-clockid
+
+Other clocks are not supported for use with Intel PT because they cannot be
+converted to/from TSC.
+
+
 AUX area sampling option
 ~~~~~~~~~~~~~~~~~~~~~~~~
 
@@ -1398,6 +1423,28 @@ There were none.
           :17006 17006 [001] 11500.262869216:  ffffffff8220116e error_entry+0xe ([guest.kernel.kallsyms])               pushq  %rax
 
 
+Tracing within a Virtual Machine
+--------------------------------
+
+When supported, using Intel PT within a virtual machine does not support TSC
+because the perf event clock is subject to paravirtualization.  That is
+overcome by the new CLOCK_PERF_HW_CLOCK_NS clock - refer 'perf event clock'
+above.  In addition, in a VM, the following might be zero:
+
+	/sys/bus/event_source/devices/intel_pt/max_nonturbo_ratio
+	/sys/bus/event_source/devices/intel_pt/tsc_art_ratio
+
+The decoder needs this information to correctly interpret timing packets,
+so the values can be provided by config variables in that case. Note in
+the absence of VMCS TSC Scaling, this is probably the same as the host values.
+The config variables are:
+
+	intel-pt.max_nonturbo_ratio
+	intel-pt.tsc_art_ratio
+
+For more information about perf config variables, refer linkperf:perf-config[1]
+
+
 Event Trace
 -----------
 
-- 
2.25.1

