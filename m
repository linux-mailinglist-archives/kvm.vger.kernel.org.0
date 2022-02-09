Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D34104AED12
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 09:49:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231731AbiBIItm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 03:49:42 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:60132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbiBIItk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 03:49:40 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 530F0E01647F;
        Wed,  9 Feb 2022 00:49:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644396577; x=1675932577;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=jlouUnr12In+wfWxjcYG/0EnwZ1YwgpYLta7yRl7Qrg=;
  b=KR0OxDM2q4Lsam+3gbvMF5XBwEXEBdujSRUk80N+PnpZVLSAqxubCIJq
   NS3/6BlfKPM7rdHabkkc5+4hP9K/39QRcgtQtQJitA7CMXQg2PldJ0Eyt
   xEhK91KDPmtrcnabgy7lWxBO87/Eu4bB0gfqVI/SEAzBKvqiOHpim1Voe
   24LIKKbIhPauQL0B42AUYp4hmKvoaVmnJJNK3lt9F3HDZKMUyR8FEXEQw
   zFdBsxA3+OSlFkdG1taqO2WsH9+mCllP6qPab3PeKdl6YnagieFg+6Zkn
   lFCCmDtB7gOQvBWltC/OHkf2yuRDyerpYhWy1QNcpdhRRa1jX3j/LuspM
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10252"; a="247992169"
X-IronPort-AV: E=Sophos;i="5.88,355,1635231600"; 
   d="scan'208";a="247992169"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2022 00:49:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,355,1635231600"; 
   d="scan'208";a="568169164"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.92])
  by orsmga001.jf.intel.com with ESMTP; 09 Feb 2022 00:49:30 -0800
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
Subject: [PATCH 00/11] perf intel-pt: Add perf event clocks to better support VM tracing
Date:   Wed,  9 Feb 2022 10:49:18 +0200
Message-Id: <20220209084929.54331-1-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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

 arch/x86/events/core.c                     | 43 +++++++++++---
 arch/x86/include/asm/perf_event.h          |  5 ++
 arch/x86/kernel/tsc.c                      |  3 +-
 include/uapi/linux/perf_event.h            | 14 +++++
 kernel/events/core.c                       | 13 +++++
 tools/include/uapi/linux/perf_event.h      | 14 +++++
 tools/perf/Documentation/perf-config.txt   | 18 ++++++
 tools/perf/Documentation/perf-intel-pt.txt | 47 +++++++++++++++
 tools/perf/Documentation/perf-record.txt   |  9 ++-
 tools/perf/arch/x86/util/intel-pt.c        | 93 ++++++++++++++++++++++++++++--
 tools/perf/builtin-record.c                |  2 +-
 tools/perf/tests/perf-time-to-tsc.c        | 41 ++++++++++---
 tools/perf/util/clockid.c                  |  6 ++
 tools/perf/util/intel-pt.c                 | 27 +++++++--
 tools/perf/util/intel-pt.h                 |  7 ++-
 tools/perf/util/perf_api_probe.c           | 22 +++++++
 tools/perf/util/perf_api_probe.h           |  2 +
 tools/perf/util/record.h                   |  1 +
 tools/perf/util/tsc.c                      | 56 ++++++++++++++++++
 tools/perf/util/tsc.h                      |  1 +
 20 files changed, 395 insertions(+), 29 deletions(-)


Regards
Adrian
