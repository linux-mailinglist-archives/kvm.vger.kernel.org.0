Return-Path: <kvm+bounces-32030-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 10D379D18F5
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2024 20:32:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B3FE61F2223A
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2024 19:32:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9899A1E4937;
	Mon, 18 Nov 2024 19:32:43 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A44117BBF;
	Mon, 18 Nov 2024 19:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731958363; cv=none; b=QVPYv+BEjVOJ6EjoItbhwEx3UNFhj1F1drp85iIgSnCZwL6C/zDZ5ukxoSNIi7ZpXLyWd/qYwyJCa+WpXuQPOYmGZH+RHL4Wi4UQcpU5g9eLZGDfgpMHLWvp9L+EC7y83yKZsOlQxkwu9VXBhHGb6Oa/6wDBD4BwvMha4GHoR98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731958363; c=relaxed/simple;
	bh=jwf9mr6ZqGV+aRwYqQV3XDJze1+KZMmOLGtdZOcQrx8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sB3S0aOb0HSjhpLhzoYTB7Z8dYTpbthAwRoh+FArCWPvOEDzTa3dp0o3uFnrV3gvZh+ON2Rm/Ta5LUkDgZE6+JHBBW5n3f6cpQ+CNqXr3IJJMvRb4/LZ8APCClpPHnJl2FawJ+7G8OyYjfZueMTdza3V8I/BpUREehvwRFFtUzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4572C4CECC;
	Mon, 18 Nov 2024 19:32:40 +0000 (UTC)
Date: Mon, 18 Nov 2024 14:33:11 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Suleiman Souhlal <suleiman@google.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot
 <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Valentin
 Schneider <vschneid@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 seanjc@google.com, Srikar Dronamraju <srikar@linux.ibm.com>, David
 Woodhouse <dwmw2@infradead.org>, joelaf@google.com, vineethrp@google.com,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, ssouhlal@freebsd.org
Subject: Re: [PATCH v3] sched: Don't try to catch up excess steal time.
Message-ID: <20241118143311.3ca94405@gandalf.local.home>
In-Reply-To: <20241118043745.1857272-1-suleiman@google.com>
References: <20241118043745.1857272-1-suleiman@google.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 18 Nov 2024 13:37:45 +0900
Suleiman Souhlal <suleiman@google.com> wrote:

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
> ---
> v3:
> - Reword commit message.
> - Revert back to v1 code, since it's more understandable.
> 
> v2: https://lore.kernel.org/lkml/20240911111522.1110074-1-suleiman@google.com
> - Slightly changed to simply moving one line up instead of adding
>   new variable.
> 
> v1: https://lore.kernel.org/lkml/20240806111157.1336532-1-suleiman@google.com
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

So is the problem just the above if statement? That is, delta is already
calculated, but if we get interrupted by the host before steal is
calculated and the time then becomes greater than delta, the time
difference between delta and steal gets pushed off to the next task, right?

-- Steve



>  
> -		rq->prev_steal_time_rq += steal;
> +		rq->prev_steal_time_rq = prev_steal;
>  		delta -= steal;
>  	}
>  #endif


