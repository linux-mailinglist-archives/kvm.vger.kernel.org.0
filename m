Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A531F4CF402
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 09:53:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233375AbiCGIyM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 03:54:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbiCGIyL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 03:54:11 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1268113DCB;
        Mon,  7 Mar 2022 00:53:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646643197; x=1678179197;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=J+6WHG/tzTC40q/wmvLqhi9qDMnhu0k9aa676Xc8LRg=;
  b=GK8i3prt9MZJjr5WDUGwNI1xoCqzp8nn/K6UT2PBXwCQeqeOMLeCaeHe
   DOKYWOzzMKpgfI8ufF8frK+mUGjOt21z1ScMGq+2XQFvFXN36P8gJuxIR
   1SJjZO2Cs2In/Yy02KAL9jUeQK3E7smWZBVXuwD++QrFGNPi1Huiw1Lzt
   a26hrk649WmgfJvhcquyxAdhtAzLsG3+23IAtlnAwx//wApk+6MtdzU2+
   Rm7QOtjcAdN0AKl9ZS178B42uvKqh5FTTDMrNSraqQFCKESgREFI3zUd1
   2XROZeRmpB5iK8i8n3AkqZvqjRVkBJk39Uo1QhzAyGlyAtbmySl+XNLcC
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10278"; a="241771761"
X-IronPort-AV: E=Sophos;i="5.90,161,1643702400"; 
   d="scan'208";a="241771761"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 00:53:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,161,1643702400"; 
   d="scan'208";a="537033472"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.92])
  by orsmga007.jf.intel.com with ESMTP; 07 Mar 2022 00:53:12 -0800
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
Subject: [PATCH V3 00/10] perf intel-pt: Add perf event clocks to better support VM tracing
Date:   Mon,  7 Mar 2022 10:53:02 +0200
Message-Id: <20220307085312.1814506-1-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
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

Hi

Here is V3.

These patches add 2 new perf event clocks based on TSC for use with VMs.

The first patch is a minor fix, the next 2 patches add each of the 2 new
clocks.  The remaining patches add minimal tools support and are based on
top of the Intel PT Event Trace tools' patches.

The future work, to add the ability to use perf inject to inject perf
events from a VM guest perf.data file into a VM host perf.data file,
has yet to be implemented.


Changes in V3:

      perf/x86: Add support for TSC as a perf event clock
      perf/x86: Add support for TSC in nanoseconds as a perf event clock
	Drop magic flag for non-standard clock ids
	Move new clockids into clock.h
	Adjust comments to warn about new clocks

      perf tools: Add new perf clock IDs
      perf tools: Add API probes for new clock IDs
      perf tools: Add new clock IDs to "perf time to TSC" test
      perf tools: Add perf_read_tsc_conv_for_clockid()
      perf intel-pt: Add support for new clock IDs
      perf intel-pt: Add config variables for timing parameters
      perf intel-pt: Add documentation for new clock IDs
	Drop magic flag for non-standard clock ids
	Adjust documentation to warn about new clocks

      perf intel-pt: Use CLOCK_PERF_HW_CLOCK_NS by default
	Dropped patch


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


Adrian Hunter (10):
      perf/x86: Fix native_perf_sched_clock_from_tsc() with __sched_clock_offset
      perf/x86: Add support for TSC as a perf event clock
      perf/x86: Add support for TSC in nanoseconds as a perf event clock
      perf tools: Add new perf clock IDs
      perf tools: Add API probes for new clock IDs
      perf tools: Add new clock IDs to "perf time to TSC" test
      perf tools: Add perf_read_tsc_conv_for_clockid()
      perf intel-pt: Add support for new clock IDs
      perf intel-pt: Add config variables for timing parameters
      perf intel-pt: Add documentation for new clock IDs

 arch/x86/events/core.c                     | 39 +++++++++++--
 arch/x86/include/asm/perf_event.h          |  5 ++
 arch/x86/kernel/tsc.c                      |  2 +-
 include/uapi/linux/time.h                  | 17 ++++++
 kernel/events/core.c                       | 13 +++++
 tools/perf/Documentation/perf-config.txt   | 18 ++++++
 tools/perf/Documentation/perf-intel-pt.txt | 45 +++++++++++++++
 tools/perf/Documentation/perf-record.txt   | 11 +++-
 tools/perf/arch/x86/util/intel-pt.c        | 89 ++++++++++++++++++++++++++++--
 tools/perf/builtin-record.c                |  2 +-
 tools/perf/tests/perf-time-to-tsc.c        | 42 +++++++++++---
 tools/perf/util/clockid.c                  |  5 ++
 tools/perf/util/clockid.h                  |  8 +++
 tools/perf/util/intel-pt.c                 | 30 ++++++++--
 tools/perf/util/intel-pt.h                 |  7 ++-
 tools/perf/util/perf_api_probe.c           | 23 ++++++++
 tools/perf/util/perf_api_probe.h           |  2 +
 tools/perf/util/tsc.c                      | 56 +++++++++++++++++++
 tools/perf/util/tsc.h                      |  1 +
 19 files changed, 387 insertions(+), 28 deletions(-)


Regards
Adrian
