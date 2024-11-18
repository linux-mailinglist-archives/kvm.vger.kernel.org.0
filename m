Return-Path: <kvm+bounces-31998-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A7F349D0BDF
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2024 10:35:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 553AD1F21336
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2024 09:35:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FA67192D95;
	Mon, 18 Nov 2024 09:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TmdBZjuF"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D821313DBBE;
	Mon, 18 Nov 2024 09:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731922512; cv=none; b=EQ3Vklpsmv7xsQe98L90h5uXDAYmaE4kFG9pAa9pY8mCIkYbZi1VfHY6eF1eQap5PYAwfKw412GXcUL9QTCxtvKerRd6jmTTX54U1HeVADeqTnvtDhhuUDhlfKSmZoARnky1WTL5Kjc+Gqti2S2YM1XDDVo9KoUjJiJi3yC1cN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731922512; c=relaxed/simple;
	bh=GWLvMV5hM5wkZSSpieUHtEaVl6/09Im/HosqM4lK/7Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IKfcs/1BedabA/zlcYObboKg0LC3UuuLQH8zgrTnP11bFTSHeeGeNIrrxbdEHiVvsGxnYFKKUnBwTsOV/sjmzvzr50RLuWE3tOxgIV9wazuLS4QrikMY3Liz6u96jdoPnIOi78YaCpam4yuXN8DTr4V0UhdFnmK7uJ5VV6IsM50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=TmdBZjuF; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=jDD8IsiPkkV/wTh7HXTNn897mhHGB5oo3yLF5ILnD64=; b=TmdBZjuFAlTcB6BUL/VZzzHMSp
	a0iNW1Sc6/BKhr2Vne6erIkwoP0nqcFF6yydtwJIWtTcdr9CzL1PmwpF6LcYVRIJ2OoHhR91YIX80
	3Zq1AxqcbZNTsQuZM9W3vAO44Nk1LBKNW/4HUsTc51BjmhYVjOW2EgrMcNYsxUIYzx74XbR7DyBNY
	Aji0rJCgzT9x/AVJ/XYLYCRpXHB0glezM9gIoysFp9NJv/MzaA63GC4/86urwR8vnT7dKlql6XevP
	RVh5kgceAMGRy3JhkaTC97Gk0GZpCSVXtb3zrbEot01aIkOm+nSA7fyEq5rSK/286Xdp5N69tyHfQ
	APcb8Y7Q==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tCy9m-00000002n26-2kaK;
	Mon, 18 Nov 2024 09:34:56 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id BBD12300446; Mon, 18 Nov 2024 10:34:54 +0100 (CET)
Date: Mon, 18 Nov 2024 10:34:54 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Suleiman Souhlal <suleiman@google.com>
Cc: Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, seanjc@google.com,
	Srikar Dronamraju <srikar@linux.ibm.com>,
	David Woodhouse <dwmw2@infradead.org>, joelaf@google.com,
	vineethrp@google.com, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, ssouhlal@freebsd.org
Subject: Re: [PATCH v3] sched: Don't try to catch up excess steal time.
Message-ID: <20241118093454.GF39245@noisy.programming.kicks-ass.net>
References: <20241118043745.1857272-1-suleiman@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241118043745.1857272-1-suleiman@google.com>

On Mon, Nov 18, 2024 at 01:37:45PM +0900, Suleiman Souhlal wrote:
> When steal time exceeds the measured delta when updating clock_task, we
> currently try to catch up the excess in future updates.
> However, this results in inaccurate run times for the future things using
> clock_task, in some situations, as they end up getting additional steal
> time that did not actually happen.
> This is because there is a window between reading the elapsed time in
> update_rq_clock() and sampling the steal time in update_rq_clock_task().
> If the VCPU gets preempted between those two points, any additional
> steal time is accounted to the outgoing task even though the calculated
> delta did not actually contain any of that "stolen" time.
> When this race happens, we can end up with steal time that exceeds the
> calculated delta, and the previous code would try to catch up that excess
> steal time in future clock updates, which is given to the next,
> incoming task, even though it did not actually have any time stolen.
> 
> This behavior is particularly bad when steal time can be very long,
> which we've seen when trying to extend steal time to contain the duration
> that the host was suspended [0]. When this happens, clock_task stays
> frozen, during which the running task stays running for the whole
> duration, since its run time doesn't increase.
> However the race can happen even under normal operation.
> 
> Ideally we would read the elapsed cpu time and the steal time atomically,
> to prevent this race from happening in the first place, but doing so
> is non-trivial.
> 
> Since the time between those two points isn't otherwise accounted anywhere,
> neither to the outgoing task nor the incoming task (because the "end of
> outgoing task" and "start of incoming task" timestamps are the same),
> I would argue that the right thing to do is to simply drop any excess steal
> time, in order to prevent these issues.
> 
> [0] https://lore.kernel.org/kvm/20240820043543.837914-1-suleiman@google.com/
> 
> Signed-off-by: Suleiman Souhlal <suleiman@google.com>

Right.. uhm.. I don't particularly care much either way. Are other
people with virt clue okay with this?

> ---
>  kernel/sched/core.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index a1c353a62c56..13f70316ef39 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -766,13 +766,15 @@ static void update_rq_clock_task(struct rq *rq, s64 delta)
>  #endif
>  #ifdef CONFIG_PARAVIRT_TIME_ACCOUNTING
>  	if (static_key_false((&paravirt_steal_rq_enabled))) {
> -		steal = paravirt_steal_clock(cpu_of(rq));
> +		u64 prev_steal;
> +
> +		steal = prev_steal = paravirt_steal_clock(cpu_of(rq));
>  		steal -= rq->prev_steal_time_rq;
>  
>  		if (unlikely(steal > delta))
>  			steal = delta;
>  
> -		rq->prev_steal_time_rq += steal;
> +		rq->prev_steal_time_rq = prev_steal;
>  		delta -= steal;
>  	}
>  #endif
> -- 
> 2.47.0.338.g60cca15819-goog
> 

