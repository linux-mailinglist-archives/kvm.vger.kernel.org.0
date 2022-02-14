Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77ACE4B4E74
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 12:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351364AbiBNL3x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 06:29:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351358AbiBNL3q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 06:29:46 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CEF0140FC;
        Mon, 14 Feb 2022 03:09:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644836963; x=1676372963;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=6XFRgemTjKhuqga19VKEjHmq/qPjH7VzOzRQuzRYuNs=;
  b=LBfTA8w85r2wbP7RqNyZM10gk3ky0xLtowHkCBvZ3+EyHG3i84Sc7E7v
   K7Zf0qn8nl+/kl5kBQsqDWeLBPAR4o8DD79fTEdd1g7EUjakkf6MST53U
   7uc8bTBFKcxZ+QoS+vgtnV/kRHE8W9qdYAUxPI4J+zAT4aIucsyh8B9UN
   lipCkyaEq2YNW4I4x7wJvQ7WBEkwOFPqlgjTiQJ5Ep9CeRBHz3eSfw6VG
   HtV57pr+TPnbOF4lEotHjYFT5XEhcZK6l/FM0eDd7FcYUb2QKLvubiPsa
   4z/Gv1/rS2MzGptXqqFbLRm0T5oZHx5WXTUsZUcivEI3r36G+0rjREdpd
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10257"; a="237478553"
X-IronPort-AV: E=Sophos;i="5.88,367,1635231600"; 
   d="scan'208";a="237478553"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2022 03:09:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,367,1635231600"; 
   d="scan'208";a="635103112"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.92])
  by orsmga004.jf.intel.com with ESMTP; 14 Feb 2022 03:09:15 -0800
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
Subject: [PATCH V2 00/11] perf intel-pt: Add perf event clocks to better support VM tracing
Date:   Mon, 14 Feb 2022 13:09:03 +0200
Message-Id: <20220214110914.268126-1-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi

These patches add 2 new perf event clocks based on TSC for use with VMs.

The first patch is a minor fix, the next 2 patches add each of the 2 new
clocks.  The remaining patches add minimal tools support and are based on
top of the Intel PT Event Trace tools' patches.

The future work, to add the ability to use perf inject to inject perf
events from a VM guest perf.data file into a VM host perf.data file,
has yet to be implemented.


Changes in V2:
      perf/x86: Fix native_perf_sched_clock_from_tsc() with __sched_clock_offset
	  Add __sched_clock_offset unconditionally

      perf/x86: Add support for TSC as a perf event clock
	  Use an attribute bit 'ns_clockid' to identify non-standard clockids

      perf/x86: Add support for TSC in nanoseconds as a perf event clock
	  Do not affect use of __sched_clock_offset
	  Adjust to use 'ns_clockid'

      perf tools: Add new perf clock IDs
      perf tools: Add API probes for new clock IDs
      perf tools: Add new clock IDs to "perf time to TSC" test
      perf tools: Add perf_read_tsc_conv_for_clockid()
      perf intel-pt: Add support for new clock IDs
      perf intel-pt: Use CLOCK_PERF_HW_CLOCK_NS by default
      perf intel-pt: Add config variables for timing parameters
      perf intel-pt: Add documentation for new clock IDs
	  Adjust to use 'ns_clockid'


Adrian Hunter (11):
      perf/x86: Fix native_perf_sched_clock_from_tsc() with __sched_clock_offset
      perf/x86: Add support for TSC as a perf event clock
      perf/x86: Add support for TSC in nanoseconds as a perf event clock
      perf tools: Add new perf clock IDs
      perf tools: Add API probes for new clock IDs
      perf tools: Add new clock IDs to "perf time to TSC" test
      perf tools: Add perf_read_tsc_conv_for_clockid()
      perf intel-pt: Add support for new clock IDs
      perf intel-pt: Use CLOCK_PERF_HW_CLOCK_NS by default
      perf intel-pt: Add config variables for timing parameters
      perf intel-pt: Add documentation for new clock IDs

 arch/x86/events/core.c                     | 39 ++++++++++--
 arch/x86/include/asm/perf_event.h          |  5 ++
 arch/x86/kernel/tsc.c                      |  2 +-
 include/uapi/linux/perf_event.h            | 18 +++++-
 kernel/events/core.c                       | 63 +++++++++++++-------
 tools/include/uapi/linux/perf_event.h      | 18 +++++-
 tools/perf/Documentation/perf-config.txt   | 18 ++++++
 tools/perf/Documentation/perf-intel-pt.txt | 47 +++++++++++++++
 tools/perf/Documentation/perf-record.txt   |  9 ++-
 tools/perf/arch/x86/util/intel-pt.c        | 95 ++++++++++++++++++++++++++++--
 tools/perf/builtin-record.c                |  2 +-
 tools/perf/tests/perf-time-to-tsc.c        | 42 ++++++++++---
 tools/perf/util/clockid.c                  | 14 +++++
 tools/perf/util/evsel.c                    |  1 +
 tools/perf/util/intel-pt.c                 | 27 +++++++--
 tools/perf/util/intel-pt.h                 |  7 ++-
 tools/perf/util/perf_api_probe.c           | 24 ++++++++
 tools/perf/util/perf_api_probe.h           |  2 +
 tools/perf/util/perf_event_attr_fprintf.c  |  1 +
 tools/perf/util/record.h                   |  2 +
 tools/perf/util/tsc.c                      | 58 ++++++++++++++++++
 tools/perf/util/tsc.h                      |  2 +
 22 files changed, 444 insertions(+), 52 deletions(-)


Regards
Adrian
