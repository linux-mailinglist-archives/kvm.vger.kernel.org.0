Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC3964BD65A
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 07:56:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345723AbiBUGzY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 01:55:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345719AbiBUGzT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 01:55:19 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F2D7638E;
        Sun, 20 Feb 2022 22:54:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645426497; x=1676962497;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=AL8BmXhjU5s6sW5E+QWTqTOkFKiCdsNwAMwznx0fOlM=;
  b=IDgkRYovu+yw3mrrOntLI1+dHKtB3NtILgC5LLnh/hv2Ttp/LJ+Upour
   OCXWZMUzjbi2ENG50iqzTFgZQX50GFZ41hNROis+H5OA72Z0005s4i+l4
   J17subS9YohStzdiYfO3CwJqBEThMbkNt1wcWqMcKQ32DW0v4C/evQTMe
   36F5sBCQp71xKCZZSQZ1eOrPIqNaWWLZPEc/HKSXZi5FRx1PShEXwj427
   WZM/q1M/gZq8XkqyEZCR6i/aZFNeju7hY9zwJqHHTeyx8zY7xp0lPCSGH
   S8djrDPPZxeN9zI4WUro+avQ5o//4fIuhFagGDPOYqb8YamadX32pDEIe
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10264"; a="251630698"
X-IronPort-AV: E=Sophos;i="5.88,385,1635231600"; 
   d="scan'208";a="251630698"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2022 22:54:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,385,1635231600"; 
   d="scan'208";a="507528697"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.92]) ([10.237.72.92])
  by orsmga006.jf.intel.com with ESMTP; 20 Feb 2022 22:54:50 -0800
Message-ID: <4eaf42fd-f30f-e8ac-03f5-a364f7e28461@intel.com>
Date:   Mon, 21 Feb 2022 08:54:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.5.0
Subject: Re: [PATCH V2 00/11] perf intel-pt: Add perf event clocks to better
 support VM tracing
Content-Language: en-US
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
References: <20220214110914.268126-1-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <20220214110914.268126-1-adrian.hunter@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/02/2022 13:09, Adrian Hunter wrote:
> Hi
> 
> These patches add 2 new perf event clocks based on TSC for use with VMs.
> 
> The first patch is a minor fix, the next 2 patches add each of the 2 new
> clocks.  The remaining patches add minimal tools support and are based on
> top of the Intel PT Event Trace tools' patches.
> 
> The future work, to add the ability to use perf inject to inject perf
> events from a VM guest perf.data file into a VM host perf.data file,
> has yet to be implemented.
> 
> 
> Changes in V2:
>       perf/x86: Fix native_perf_sched_clock_from_tsc() with __sched_clock_offset
> 	  Add __sched_clock_offset unconditionally
> 
>       perf/x86: Add support for TSC as a perf event clock
> 	  Use an attribute bit 'ns_clockid' to identify non-standard clockids
> 
>       perf/x86: Add support for TSC in nanoseconds as a perf event clock
> 	  Do not affect use of __sched_clock_offset
> 	  Adjust to use 'ns_clockid'

Any comments on version 2?

> 
>       perf tools: Add new perf clock IDs
>       perf tools: Add API probes for new clock IDs
>       perf tools: Add new clock IDs to "perf time to TSC" test
>       perf tools: Add perf_read_tsc_conv_for_clockid()
>       perf intel-pt: Add support for new clock IDs
>       perf intel-pt: Use CLOCK_PERF_HW_CLOCK_NS by default
>       perf intel-pt: Add config variables for timing parameters
>       perf intel-pt: Add documentation for new clock IDs
> 	  Adjust to use 'ns_clockid'
> 
> 
> Adrian Hunter (11):
>       perf/x86: Fix native_perf_sched_clock_from_tsc() with __sched_clock_offset
>       perf/x86: Add support for TSC as a perf event clock
>       perf/x86: Add support for TSC in nanoseconds as a perf event clock
>       perf tools: Add new perf clock IDs
>       perf tools: Add API probes for new clock IDs
>       perf tools: Add new clock IDs to "perf time to TSC" test
>       perf tools: Add perf_read_tsc_conv_for_clockid()
>       perf intel-pt: Add support for new clock IDs
>       perf intel-pt: Use CLOCK_PERF_HW_CLOCK_NS by default
>       perf intel-pt: Add config variables for timing parameters
>       perf intel-pt: Add documentation for new clock IDs
> 
>  arch/x86/events/core.c                     | 39 ++++++++++--
>  arch/x86/include/asm/perf_event.h          |  5 ++
>  arch/x86/kernel/tsc.c                      |  2 +-
>  include/uapi/linux/perf_event.h            | 18 +++++-
>  kernel/events/core.c                       | 63 +++++++++++++-------
>  tools/include/uapi/linux/perf_event.h      | 18 +++++-
>  tools/perf/Documentation/perf-config.txt   | 18 ++++++
>  tools/perf/Documentation/perf-intel-pt.txt | 47 +++++++++++++++
>  tools/perf/Documentation/perf-record.txt   |  9 ++-
>  tools/perf/arch/x86/util/intel-pt.c        | 95 ++++++++++++++++++++++++++++--
>  tools/perf/builtin-record.c                |  2 +-
>  tools/perf/tests/perf-time-to-tsc.c        | 42 ++++++++++---
>  tools/perf/util/clockid.c                  | 14 +++++
>  tools/perf/util/evsel.c                    |  1 +
>  tools/perf/util/intel-pt.c                 | 27 +++++++--
>  tools/perf/util/intel-pt.h                 |  7 ++-
>  tools/perf/util/perf_api_probe.c           | 24 ++++++++
>  tools/perf/util/perf_api_probe.h           |  2 +
>  tools/perf/util/perf_event_attr_fprintf.c  |  1 +
>  tools/perf/util/record.h                   |  2 +
>  tools/perf/util/tsc.c                      | 58 ++++++++++++++++++
>  tools/perf/util/tsc.h                      |  2 +
>  22 files changed, 444 insertions(+), 52 deletions(-)
> 
> 
> Regards
> Adrian

