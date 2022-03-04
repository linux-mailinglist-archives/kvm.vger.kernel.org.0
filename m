Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4DC4CD44E
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 13:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239734AbiCDMdR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 07:33:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239727AbiCDMdO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 07:33:14 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0794217;
        Fri,  4 Mar 2022 04:32:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=S/Wid9BZ32eNtrtySnoTqocDyuzOkSt1iZ5S6hCXNEI=; b=LLlJExc+7/jrmAd2nod7DGvs1z
        uD2OCxrhWkGO5xgsWX17iu8RjQGj9IYmPKqYni6ih0uyAuN0oQeuGzFrIYvbwYoRBlJXTX0CPgqco
        W4lQCkO0r38tkLUeJOFrbQ32U4ruRLyL3SzmR/z2Q8y7lFVd2IIeJqprIpoiwBHLgxHnJMb246S+S
        WKX18kh78yoLvzDfUVZ3sbARTE8UCmeUIDWmVZ+J983VPgB/PvbDb7lG+peymGBUl5aMkauo/bbYx
        hRarMFzEa/xYEFMgpFzDLMkPONZKV8oT7cte4oI82TJcsg7gQTnViEBc/GsJ+7Hu7kLFtQfzDPWod
        tbuWUShA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nQ76K-00FBs1-Ai; Fri, 04 Mar 2022 12:32:04 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 49949300268;
        Fri,  4 Mar 2022 13:32:03 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 3A671201A4139; Fri,  4 Mar 2022 13:32:03 +0100 (CET)
Date:   Fri, 4 Mar 2022 13:32:03 +0100
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
Message-ID: <YiIGwyhOrYid5qyF@hirez.programming.kicks-ass.net>
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
> diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
> index 82858b697c05..e8617efd552b 100644
> --- a/include/uapi/linux/perf_event.h
> +++ b/include/uapi/linux/perf_event.h
> @@ -290,6 +290,15 @@ enum {
>  	PERF_TXN_ABORT_SHIFT = 32,
>  };
>  
> +/*
> + * If supported, clockid value to select an architecture dependent hardware
> + * clock. Note this means the unit of time is ticks not nanoseconds.
> + * Requires ns_clockid to be set in addition to use_clockid.
> + * On x86, this clock is provided by the rdtsc instruction, and is not
> + * paravirtualized.
> + */
> +#define CLOCK_PERF_HW_CLOCK		0x10000000
> +
>  /*
>   * The format of the data returned by read() on a perf event fd,
>   * as specified by attr.read_format:
> @@ -409,7 +418,8 @@ struct perf_event_attr {
>  				inherit_thread :  1, /* children only inherit if cloned with CLONE_THREAD */
>  				remove_on_exec :  1, /* event is removed from task on exec */
>  				sigtrap        :  1, /* send synchronous SIGTRAP on event */
> -				__reserved_1   : 26;
> +				ns_clockid     :  1, /* non-standard clockid */
> +				__reserved_1   : 25;
>  
>  	union {
>  		__u32		wakeup_events;	  /* wakeup every n events */

Thomas, do we want to gate this behind this magic flag, or can that
CLOCKID be granted unconditionally?
