Return-Path: <kvm+bounces-24645-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 24D8E958A24
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 16:50:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9C1DEB2505D
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 14:50:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B1A0191F60;
	Tue, 20 Aug 2024 14:50:13 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA5C190477;
	Tue, 20 Aug 2024 14:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724165412; cv=none; b=caNI8UD4V4g08JdvkgLfhZH8kiRDTD1yeD/LtEseMtkpfQ57zaXKUrjrIrohNhQail5ysuV5xp8RgX4JJzso799fwXbpCaXN6+kk6FmcFp+tHEa7IoRLmdUTBm0HhJpHJoPB0OkFyu4sKYixBxgc9VT8l1fND2I2bHPs7LKLjfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724165412; c=relaxed/simple;
	bh=82LJkXlSbH+fHpgZIEvWlPvqHiGtoTbNnNyWI2Qavdc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YifdCaDXlTFEDoWWmBo6nEBdMI14k03nK9apJACZLAZ1zbN2d2fw/nQ+haOokqXdbyALI95Iex/cWEH5/WyKbOFR1/BhO8vh4JCCaoAFFa/kRCrZaPAsP5xS3fsavsMp0DA0DxwFzl8pN7pglOci8j6sYHgd4l+ZlLYpzxnFva4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15D34C4AF0C;
	Tue, 20 Aug 2024 14:50:09 +0000 (UTC)
Date: Tue, 20 Aug 2024 10:50:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Srikar Dronamraju <srikar@linux.ibm.com>
Cc: Suleiman Souhlal <suleiman@google.com>, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann
 <dietmar.eggemann@arm.com>, Ben Segall <bsegall@google.com>, Mel Gorman
 <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, Paolo Bonzini
 <pbonzini@redhat.com>, joelaf@google.com, vineethrp@google.com,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, ssouhlal@freebsd.org
Subject: Re: [PATCH] sched: Don't try to catch up excess steal time.
Message-ID: <20240820105036.39fb9bb7@gandalf.local.home>
In-Reply-To: <20240820094555.7gdb5ado35syu5me@linux.ibm.com>
References: <20240806111157.1336532-1-suleiman@google.com>
	<20240820094555.7gdb5ado35syu5me@linux.ibm.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 20 Aug 2024 15:15:55 +0530
Srikar Dronamraju <srikar@linux.ibm.com> wrote:

> * Suleiman Souhlal <suleiman@google.com> [2024-08-06 20:11:57]:
> 
> > When steal time exceeds the measured delta when updating clock_task, we
> > currently try to catch up the excess in future updates.
> > However, this results in inaccurate run times for the future clock_task
> > measurements, as they end up getting additional steal time that did not
> > actually happen, from the previous excess steal time being paid back.
> > 
> > For example, suppose a task in a VM runs for 10ms and had 15ms of steal
> > time reported while it ran. clock_task rightly doesn't advance. Then, a
> > different task runs on the same rq for 10ms without any time stolen.
> > Because of the current catch up mechanism, clock_sched inaccurately ends
> > up advancing by only 5ms instead of 10ms even though there wasn't any
> > actual time stolen. The second task is getting charged for less time
> > than it ran, even though it didn't deserve it.
> > In other words, tasks can end up getting more run time than they should
> > actually get.
> > 
> > So, we instead don't make future updates pay back past excess stolen time.

In other words, If one task had more time stolen from it than it had run,
the excess time is removed from the next task even though it ran for its
entire slot?

I'm curious, how does a task get queued on the run queue if 100% of it's
time was stolen? That is, how did it get queued if the vCPU wasn't running?


> > 
> > Signed-off-by: Suleiman Souhlal <suleiman@google.com>
> > ---
> >  kernel/sched/core.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> > index bcf2c4cc0522..42b37da2bda6 100644
> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
> > @@ -728,13 +728,15 @@ static void update_rq_clock_task(struct rq *rq, s64 delta)
> >  #endif
> >  #ifdef CONFIG_PARAVIRT_TIME_ACCOUNTING
> >  	if (static_key_false((&paravirt_steal_rq_enabled))) {
> > -		steal = paravirt_steal_clock(cpu_of(rq));
> > +		u64 prev_steal;
> > +
> > +		steal = prev_steal = paravirt_steal_clock(cpu_of(rq));
> >  		steal -= rq->prev_steal_time_rq;
> >  
> >  		if (unlikely(steal > delta))
> >  			steal = delta;
> >  
> > -		rq->prev_steal_time_rq += steal;
> > +		rq->prev_steal_time_rq = prev_steal;
> >  		delta -= steal;
> >  	}
> >  #endif  
> 
> 
> Agree with the change.
> 
> Probably, we could have achieved by just moving a line above
> Something like this?
> 
> #ifdef CONFIG_PARAVIRT_TIME_ACCOUNTING
> 	if (static_key_false((&paravirt_steal_rq_enabled))) {
> 		steal = paravirt_steal_clock(cpu_of(rq));
> 		steal -= rq->prev_steal_time_rq;
> 		rq->prev_steal_time_rq += steal;
> 
> 		if (unlikely(steal > delta))
> 			steal = delta;
> 
> 		delta -= steal;
> 	}
> #endif

Yeah, that is probably a nicer way of doing the same thing.

Suleiman, care to send a v2?

-- Steve


