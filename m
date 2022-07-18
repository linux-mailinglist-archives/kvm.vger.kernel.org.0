Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3E7257865F
	for <lists+kvm@lfdr.de>; Mon, 18 Jul 2022 17:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235480AbiGRP20 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 11:28:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235479AbiGRP2Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 11:28:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3F9929816;
        Mon, 18 Jul 2022 08:28:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98639B8163A;
        Mon, 18 Jul 2022 15:28:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00EADC341C0;
        Mon, 18 Jul 2022 15:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658158101;
        bh=LInT1b0D6eLji3eeV6BVtk7/rgUkp5JseHk+k9f7dCU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=C2Zll1xfIUfe9Bip+WMUitVt93uhO3NgSZfyEQFkCPkZ2fq1HqUPatAueqx6mIogU
         gWAbw7s+hN5KTtRSQMIf0+eCYStnzWxpKc5vcT7/Z2dZ8HsmS6B4mXRN7VqylP8qnS
         DgwX3/y/6hG/OwUZngVmcRqdkPvvppfncfvxIJeBtxzQyX1ZXahNEbYaC6TvJ779pl
         0ZpPrSgys3swDDtqABm8vxqraHkl0r1xG1zRhq9ql975i0YzxE6DxLzbUuNaFqw6RT
         O9r1G9ho05G2QR4R6d1784n0YzSDLmEK++QoVg/xcSzSMcDKsI6spue1DzCyrMYlTZ
         FL5IBMAlyAJZA==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id A012940374; Mon, 18 Jul 2022 12:28:18 -0300 (-03)
Date:   Mon, 18 Jul 2022 12:28:18 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 00/35] perf intel-pt: Add support for tracing virtual
 machine user space on the host
Message-ID: <YtV8EktcC7yUlYf1@kernel.org>
References: <20220711093218.10967-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220711093218.10967-1-adrian.hunter@intel.com>
X-Url:  http://acmel.wordpress.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Em Mon, Jul 11, 2022 at 12:31:43PM +0300, Adrian Hunter escreveu:
> Hi
> 
> Here are patches to support decoding an Intel PT trace that contains data
> from virtual machine userspace.
> 
> This is done by adding functionality to perf inject to be able to inject
> sideband events needed for decoding, into the perf.data file recorded on
> the host.  That is, inject events from a perf.data file recorded in a
> virtual machine into a perf.data file recorded on the host at the same
> time.
> 
> For more details, see the example in the documentation added in the last
> patch.
> 
> Note there was already support for tracing virtual machines kernel-only:
> 
>  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/tools/perf/Documentation/perf-intel-pt.txt?h=v5.19-rc1#n1221
>  
> or the special case of tracing KVM self tests:
> 
>  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/tools/perf/Documentation/perf-intel-pt.txt?h=v5.19-rc1#n1403
> 
> For general information about Intel PT also see the wiki page:
> 
>  https://perf.wiki.kernel.org/index.php/Perf_tools_support_for_Intel%C2%AE_Processor_Trace
> 
> The patches fall into 5 groups:
>  1. the first patch is a fix
>  2. the next 22 patches are preparation
>  3. the main patch is "perf inject: Add support for injecting guest
>  sideband events"
>  4. 3 more preparation patches
>  5. Intel PT decoding changes
> 
> The patches are mostly small except for "perf inject: Add support for
> injecting guest sideband events".  However the code there adds new
> functionality, does not affect existing functionality and is consequently
> pretty self-contained.

Applied locally, going thru tests.

- Arnaldo
 
> 
> Adrian Hunter (35):
>       perf tools: Fix dso_id inode generation comparison
>       perf tools: Export dsos__for_each_with_build_id()
>       perf ordered_events: Add ordered_events__last_flush_time()
>       perf tools: Export perf_event__process_finished_round()
>       perf tools: Factor out evsel__id_hdr_size()
>       perf tools: Add perf_event__synthesize_id_sample()
>       perf script: Add --dump-unsorted-raw-trace option
>       perf buildid-cache: Add guestmount'd files to the build ID cache
>       perf buildid-cache: Do not require purge files to also be in the file system
>       perf tools: Add machine_pid and vcpu to id_index
>       perf session: Create guest machines from id_index
>       perf tools: Add guest_cpu to hypervisor threads
>       perf tools: Add machine_pid and vcpu to perf_sample
>       perf tools: Use sample->machine_pid to find guest machine
>       perf script: Add machine_pid and vcpu
>       perf dlfilter: Add machine_pid and vcpu
>       perf auxtrace: Add machine_pid and vcpu to auxtrace_error
>       perf script python: Add machine_pid and vcpu
>       perf script python: intel-pt-events: Add machine_pid and vcpu
>       perf tools: Remove also guest kcore_dir with host kcore_dir
>       perf tools: Make has_kcore_dir() work also for guest kcore_dir
>       perf tools: Automatically use guest kcore_dir if present
>       perf tools: Add reallocarray_as_needed()
>       perf inject: Add support for injecting guest sideband events
>       perf machine: Use realloc_array_as_needed() in machine__set_current_tid()
>       perf tools: Handle injected guest kernel mmap event
>       perf tools: Add perf_event__is_guest()
>       perf intel-pt: Remove guest_machine_pid
>       perf intel-pt: Add some more logging to intel_pt_walk_next_insn()
>       perf intel-pt: Track guest context switches
>       perf intel-pt: pt disable sync switch
>       perf intel-pt: Determine guest thread from guest sideband
>       perf intel-pt: Add machine_pid and vcpu to auxtrace_error
>       perf intel-pt: Use guest pid/tid etc in guest samples
>       perf intel-pt: Add documentation for tracing guest machine user space
> 
>  tools/lib/perf/include/internal/evsel.h            |    4 +
>  tools/lib/perf/include/perf/event.h                |    7 +
>  tools/perf/Documentation/perf-dlfilter.txt         |   22 +
>  tools/perf/Documentation/perf-inject.txt           |   17 +
>  tools/perf/Documentation/perf-intel-pt.txt         |  181 +++-
>  tools/perf/Documentation/perf-script.txt           |   10 +-
>  tools/perf/builtin-inject.c                        | 1043 +++++++++++++++++++-
>  tools/perf/builtin-script.c                        |   19 +
>  tools/perf/include/perf/perf_dlfilter.h            |    8 +
>  tools/perf/scripts/python/intel-pt-events.py       |   32 +-
>  tools/perf/util/auxtrace.c                         |   30 +-
>  tools/perf/util/auxtrace.h                         |    4 +
>  tools/perf/util/build-id.c                         |   80 +-
>  tools/perf/util/build-id.h                         |   16 +-
>  tools/perf/util/data.c                             |   43 +-
>  tools/perf/util/data.h                             |    1 +
>  tools/perf/util/dlfilter.c                         |    2 +
>  tools/perf/util/dso.h                              |    6 +
>  tools/perf/util/dsos.c                             |   10 +-
>  tools/perf/util/event.h                            |   23 +
>  tools/perf/util/evlist.c                           |   42 +-
>  tools/perf/util/evsel.c                            |   27 +
>  tools/perf/util/evsel.h                            |    2 +
>  tools/perf/util/intel-pt.c                         |  183 +++-
>  tools/perf/util/machine.c                          |   41 +-
>  tools/perf/util/machine.h                          |    2 +
>  tools/perf/util/ordered-events.h                   |    6 +
>  .../util/scripting-engines/trace-event-python.c    |   15 +-
>  tools/perf/util/session.c                          |  111 ++-
>  tools/perf/util/session.h                          |    4 +
>  tools/perf/util/symbol.c                           |    6 +-
>  tools/perf/util/synthetic-events.c                 |   98 +-
>  tools/perf/util/synthetic-events.h                 |    2 +
>  tools/perf/util/thread.c                           |    1 +
>  tools/perf/util/thread.h                           |    1 +
>  tools/perf/util/util.c                             |   70 +-
>  tools/perf/util/util.h                             |   15 +
>  37 files changed, 2029 insertions(+), 155 deletions(-)
> 
> 
> Regards
> Adrian

-- 

- Arnaldo
