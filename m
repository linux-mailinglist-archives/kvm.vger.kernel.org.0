Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8EA4CD449
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 13:31:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239717AbiCDMbv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 07:31:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbiCDMbu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 07:31:50 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 318891B309A;
        Fri,  4 Mar 2022 04:31:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Udrf8X2s7m9wGFP9SouxiWxD1WDtWsSqid2Fk/v+Oz8=; b=avw+zgbkIFcAquu5wKjoMEJ9ea
        ajeqXut3IljafzXbWzXnb5wcqajJDkYxsaiAmCr6eoTC8FltPC1P/+u9QwOsRUJir4fBDkEe1rlQT
        Co2z5Wg6SEO2zOGW3E7i7GvoqfyDlzoW8OSkOozqBz6IctCm+0g2MK63vkoOwDFKZdhvhpxxx2qQ1
        lEWJDf4Gk6WRGg5jOc+bduXF/5GuZtlsmjLWwQbCF5SjEsfFGHojPNvkyYXVGZzqyAp1O+w1lnfhL
        TaTw5E6/TxPczryQXbDPDEhQijOpAVrFxPD3VR6OhbvB4B/7zM6flr3wZhT3FcG63uRFFdiBB3tkn
        loQ/TN7g==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nQ74w-00Cck3-Tb; Fri, 04 Mar 2022 12:30:39 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 1F091300230;
        Fri,  4 Mar 2022 13:30:37 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 07F9B2019A5EC; Fri,  4 Mar 2022 13:30:37 +0100 (CET)
Date:   Fri, 4 Mar 2022 13:30:37 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Adrian Hunter <adrian.hunter@intel.com>
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
Subject: Re: [PATCH V2 02/11] perf/x86: Add support for TSC as a perf event
 clock
Message-ID: <YiIGbbyx0uimsGN4@hirez.programming.kicks-ass.net>
References: <20220214110914.268126-1-adrian.hunter@intel.com>
 <20220214110914.268126-3-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220214110914.268126-3-adrian.hunter@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 14, 2022 at 01:09:05PM +0200, Adrian Hunter wrote:
> Currently, using Intel PT to trace a VM guest is limited to kernel space
> because decoding requires side band events such as MMAP and CONTEXT_SWITCH.
> While these events can be collected for the host, there is not a way to do
> that yet for a guest. One approach, would be to collect them inside the
> guest, but that would require being able to synchronize with host
> timestamps.
> 
> The motivation for this patch is to provide a clock that can be used within
> a VM guest, and that correlates to a VM host clock. In the case of TSC, if
> the hypervisor leaves rdtsc alone, the TSC value will be subject only to
> the VMCS TSC Offset and Scaling. Adjusting for that would make it possible
> to inject events from a guest perf.data file, into a host perf.data file.
> 
> Thus making possible the collection of VM guest side band for Intel PT
> decoding.
> 
> There are other potential benefits of TSC as a perf event clock:
> 	- ability to work directly with TSC
> 	- ability to inject non-Intel-PT-related events from a guest
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>  arch/x86/events/core.c            | 16 +++++++++
>  arch/x86/include/asm/perf_event.h |  3 ++
>  include/uapi/linux/perf_event.h   | 12 ++++++-
>  kernel/events/core.c              | 57 +++++++++++++++++++------------
>  4 files changed, 65 insertions(+), 23 deletions(-)
> 
> diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
> index e686c5e0537b..51d5345de30a 100644
> --- a/arch/x86/events/core.c
> +++ b/arch/x86/events/core.c
> @@ -2728,6 +2728,17 @@ void arch_perf_update_userpage(struct perf_event *event,
>  		!!(event->hw.flags & PERF_EVENT_FLAG_USER_READ_CNT);
>  	userpg->pmc_width = x86_pmu.cntval_bits;
>  
> +	if (event->attr.use_clockid &&
> +	    event->attr.ns_clockid &&
> +	    event->attr.clockid == CLOCK_PERF_HW_CLOCK) {
> +		userpg->cap_user_time_zero = 1;
> +		userpg->time_mult = 1;
> +		userpg->time_shift = 0;
> +		userpg->time_offset = 0;
> +		userpg->time_zero = 0;
> +		return;
> +	}
> +
>  	if (!using_native_sched_clock() || !sched_clock_stable())
>  		return;

This looks the wrong way around. If TSC is found unstable, we should
never expose it.

And I'm not at all sure about the whole virt thing. Last time I looked
at pvclock it made no sense at all.
