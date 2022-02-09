Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1558B4AF22A
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 13:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233726AbiBIMyt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 07:54:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbiBIMyp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 07:54:45 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB60C0613CA;
        Wed,  9 Feb 2022 04:54:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=7b9c8GzE9tZkc6eT+rdeNdrr/Q/IwhVZG6xv7vX09Oo=; b=AlUVTn5XlgNzFiPIF6CHIb2Xpb
        P2arMilZX7owI9BZYCtG1B4txJV2NTH/pQP/HmmGismw16bbx+EYnYYxZ+nV2Jfy5aD9uEY3/NSBx
        t3CQRDcAv6uuxb5HM/ws8TH9Uo4TsL0ayS15WJqj6JGmQUEqOOXkyPe1LHD4JCioJXA1BB2/M3KQ2
        3Rd4gHAsFj0e8P5PLhMwcvBNTyupgNKrvgT7ikqv4t2ElypFe1rtCl/dfO+5mcoflS8bff+5YBMrg
        zye1qdhoAzTZlLDY+1d5fpbzHAjXqaCogzHRBMpEIzbBTMsyU7VoObyrw+REPjF+KNz3D5Gg0PXhB
        xtneKLkg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nHmUK-008QQo-NT; Wed, 09 Feb 2022 12:54:25 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 0E749300478;
        Wed,  9 Feb 2022 13:54:24 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id EBCDE265018D6; Wed,  9 Feb 2022 13:54:23 +0100 (CET)
Date:   Wed, 9 Feb 2022 13:54:23 +0100
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
Subject: Re: [PATCH 01/11] perf/x86: Fix native_perf_sched_clock_from_tsc()
 with __sched_clock_offset
Message-ID: <YgO5f8DFd2onnTOE@hirez.programming.kicks-ass.net>
References: <20220209084929.54331-1-adrian.hunter@intel.com>
 <20220209084929.54331-2-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220209084929.54331-2-adrian.hunter@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 09, 2022 at 10:49:19AM +0200, Adrian Hunter wrote:
> native_perf_sched_clock_from_tsc() is used to produce a time value that can
> be consistent with perf_clock().  Consequently, it should be adjusted by
> __sched_clock_offset, the same as perf_clock() would be.
> 
> Fixes: 698eff6355f735 ("sched/clock, x86/perf: Fix perf test tsc")
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>  arch/x86/kernel/tsc.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> index a698196377be..c1c73fe324cd 100644
> --- a/arch/x86/kernel/tsc.c
> +++ b/arch/x86/kernel/tsc.c
> @@ -242,7 +242,8 @@ u64 native_sched_clock(void)
>   */
>  u64 native_sched_clock_from_tsc(u64 tsc)
>  {
> -	return cycles_2_ns(tsc);
> +	return cycles_2_ns(tsc) +
> +	       (sched_clock_stable() ? __sched_clock_offset : 0);
>  }

Why do we care about the !sched_clock_stable() case?
