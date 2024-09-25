Return-Path: <kvm+bounces-27422-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8104E9860C9
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 16:33:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 07A9F1F26FC6
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 14:33:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DD501B14F1;
	Wed, 25 Sep 2024 13:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=freebsd.org header.i=@freebsd.org header.b="mQ5QGde8"
X-Original-To: kvm@vger.kernel.org
Received: from mx2.freebsd.org (mx2.freebsd.org [96.47.72.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F7B1B0126;
	Wed, 25 Sep 2024 13:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=96.47.72.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727270737; cv=pass; b=ivm5RmsW7V1rKOAAymhsIxsFoai4w8V9y+DCuMBNie7Y02uuEx/V7EHEd7amjv8At/PzYZsM4y1Z3KQnHu4yeVtPNuUjkh8Qiz/zAkC1m3+oSRVYzwJUJA64DX45IKTUACkHwyC6QzCR5O2A930/xRBOioegfMQ/0KQHEdfM9bk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727270737; c=relaxed/simple;
	bh=Fe7FCm7RW03CVhyxUi/vygxJhyLwUh1g5pqIE6udzS0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kkFgVHjSsPs2GkmRZjSbBP7kBVtAmizWT1/VxOE6ad5J9hylOxM1b783kZFr5WKIgj8jK4bRQZzC6lkQxZQ+O8JwCSQDWF7MiUlgfe4H8puFSkT24EpbVz13Cgcu1d8GUI64PH0cVHJUHFJK+vgColZIgstzfy8nMHIPlvADGuE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=freebsd.org; spf=pass smtp.mailfrom=freebsd.org; dkim=pass (2048-bit key) header.d=freebsd.org header.i=@freebsd.org header.b=mQ5QGde8; arc=pass smtp.client-ip=96.47.72.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=freebsd.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=freebsd.org
Received: from mx1.freebsd.org (mx1.freebsd.org [96.47.72.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits)
	 client-signature RSA-PSS (4096 bits))
	(Client CN "mx1.freebsd.org", Issuer "R10" (verified OK))
	by mx2.freebsd.org (Postfix) with ESMTPS id 4XDHXs2xvHz3m0j;
	Wed, 25 Sep 2024 13:25:33 +0000 (UTC)
	(envelope-from ssouhlal@freebsd.org)
Received: from freefall.freebsd.org (freefall.freebsd.org [IPv6:2610:1c1:1:6074::16:84])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
	 client-signature RSA-PSS (4096 bits) client-digest SHA256)
	(Client CN "freefall.freebsd.org", Issuer "R11" (verified OK))
	by mx1.freebsd.org (Postfix) with ESMTPS id 4XDHXs26R4z42qN;
	Wed, 25 Sep 2024 13:25:33 +0000 (UTC)
	(envelope-from ssouhlal@freebsd.org)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=freebsd.org; s=dkim;
	t=1727270733;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZhUKa5mLtSQgeXQTIq8+FnMk1elUt4b5ryl5TJg4/Rc=;
	b=mQ5QGde8iA51w95D7ZqDFKGFXVJ97Zz7ovWyb+XGOzzGFjFOIMN+2fi+OWq8t4jIaGt+mL
	3lL67Vx4c8afcaIqYh5ejhBfNADtx3btYGQhh5yyC3bVz+tnZua4pB/Sm8krFrejsAas6D
	1H4MkCoxjWbnL5MuC4EvV0sbGGe4mcKz+LvcEUa0aRMY/ib6b15wda4NVYBnPvFrzURXfO
	SvdwRmsnYh3SS0/TOKOc+62Q/VTcRCA/+SYVw39ALcdf69OO9cx1zmFYIL1jkK13qBh8+2
	7DrkVJXi3AssEJi6wD9AsKn/JV3oX3PygGopPxVciWa5XNdBARz7YZB95keFQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=freebsd.org;
	s=dkim; t=1727270733;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZhUKa5mLtSQgeXQTIq8+FnMk1elUt4b5ryl5TJg4/Rc=;
	b=gpJRwOfPvRDG3vPXaLiLzc60JUfckld/jZFAiC6AB1nJbjwOW9L5k3dgvR/Tp0u8/Ynn/y
	HiBz7jG9xZdhkaYSpaGgzsFe9uat2F5U5BScy7j4PaU1M/QBEC8ENZy3wzQzio4oe/e9bS
	6iTBS6fSAna0Phv/vGNf/nDg/llc3RnVR4R50HR+vkZTENxdeBDX3YQ9ARxmj0wjIPLva2
	QOvn+Njn+1hf8wmGu0ueZw2MWxdjFZOKI7hvZsJmG5lmoCZVLWgA1rv6Q8UTyxp3PpSb0Q
	vD2sVp5IzHrs+BExHtIyJT5XkJRUb4A0mNROcNbA+dN4Tur1x7kmZA7xD6MAhg==
ARC-Authentication-Results: i=1;
	mx1.freebsd.org;
	none
ARC-Seal: i=1; s=dkim; d=freebsd.org; t=1727270733; a=rsa-sha256; cv=none;
	b=QDhDT0gZtiVagrzhbQMyPpvyRQdhYvQaF9JIcvH0sUPb7fUMxhLF3GgXJmMl9sXa3JjcBC
	P65F1RhVqaYOFVNP/GrdREfJS+DOxFkqoPeUBjPlvNTeO6XHiBWfZo9984fkvpSmTUOWuF
	hKwPcLnuySk7/q9dt4WxlXjcvjxaZM+AniOfrypNmUBkfsZWwLsDJUN8B/YgFhNG/7Hzez
	pgwLFgZbPFH04G2bv6Jytf7QBIEBgRLMuUjR5IlyzqcRyzv1IlFgD/jH+hggqDEA/xAmPc
	pRfqpNmHDnkxvrI5bthrOmfbylGIVACO3XRSoNUG50cw/qOkp1OziK+nks3aHQ==
Received: by freefall.freebsd.org (Postfix, from userid 1026)
	id 40EB0E158; Wed, 25 Sep 2024 13:25:33 +0000 (UTC)
Date: Wed, 25 Sep 2024 13:25:33 +0000
From: Suleiman Souhlal <ssouhlal@freebsd.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Suleiman Souhlal <suleiman@google.com>, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, joelaf@google.com,
	vineethrp@google.com, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, Srikar Dronamraju <srikar@linux.ibm.com>,
	Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v2] sched: Don't try to catch up excess steal time.
Message-ID: <ZvQPTYo2oCN-4YTM@freefall.freebsd.org>
References: <20240911111522.1110074-1-suleiman@google.com>
 <f0535c47ea81a311efd5cade70543cdf7b25b15c.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f0535c47ea81a311efd5cade70543cdf7b25b15c.camel@infradead.org>

On Wed, Sep 25, 2024 at 12:45:55PM +0100, David Woodhouse wrote:
> On Wed, 2024-09-11 at 20:15 +0900, Suleiman Souhlal wrote:
> > When steal time exceeds the measured delta when updating clock_task,
> > we
> > currently try to catch up the excess in future updates.
> > However, this results in inaccurate run times for the future things
> > using
> > clock_task, as they end up getting additional steal time that did not
> > actually happen.
> > 
> > For example, suppose a task in a VM runs for 10ms and had 15ms of
> > steal
> > time reported while it ran. clock_task rightly doesn't advance. Then,
> > a
> > different taks runs on the same rq for 10ms without any time stolen
> > in
> > the host.
> > Because of the current catch up mechanism, clock_sched inaccurately
> > ends
> > up advancing by only 5ms instead of 10ms even though there wasn't any
> > actual time stolen. The second task is getting charged for less time
> > than it ran, even though it didn't deserve it.
> > This can result in tasks getting more run time than they should
> > actually
> > get.
> > 
> > So, we instead don't make future updates pay back past excess stolen
> > time.
> > 
> > Signed-off-by: Suleiman Souhlal <suleiman@google.com>
> > ---
> > v2:
> > - Slightly changed to simply moving one line up instead of adding
> >   new variable.
> > 
> > v1:
> > https://lore.kernel.org/lkml/20240806111157.1336532-1-suleiman@google.com
> > ---
> >  kernel/sched/core.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> > index f3951e4a55e5..6c34de8b3fbb 100644
> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
> > @@ -730,11 +730,11 @@ static void update_rq_clock_task(struct rq *rq,
> > s64 delta)
> >         if (static_key_false((&paravirt_steal_rq_enabled))) {
> >                 steal = paravirt_steal_clock(cpu_of(rq));
> >                 steal -= rq->prev_steal_time_rq;
> > +               rq->prev_steal_time_rq += steal;
> 
> The above two lines are essentially:
> 
> 	steal -= prev;
> 	prev += steal;
> 
> It's like one of those clever ways of exchanging two variables with
> three XOR operations. I don't like it :)
> 
> Ultimately, you're just setting rq->prev_steal_time_rq to the latest
> value that you just read from paravirt_steal_clock(). And then setting
> 'steal' to the delta between the new reading and the previous one.
> 
> The code above is *far* from obvious. At the very least it wants a
> comment, but I'd rather see it refactored so that it doesn't need one. 
> 
>     u64 abs_steal_now = paravirt_steal_clock(cpu_of(rq));
>     steal = abs_steal_now - rq->prev_steal_time_rq;
>     rq->prev_steal_time_rq = abs_steal_now;

That is what v1 did:
https://lore.kernel.org/lkml/20240806111157.1336532-1-suleiman@google.com/

It is also more obvious to me, but the feedback I received was that
the way in the current iteration is better.

I don't feel strongly about it, and I'd be ok with either version applied. 

> 
> I'm still not utterly convinced this is the right thing to do, though.
> It means you will constantly undermeasure the accounting of steal time
> as you discard the excess each time.
> 
> The underlying bug here is that we are sampling the steal time and the
> time slice at *different* times. This update_rq_clock_task() function
> could be called with a calculated 'delta' argument... and then
> experience a large amount of steal time *before* calling
> paravirt_steal_clock(), which is how we end up in the situation where
> the calculated steal time exceeds the running time of the previous
> task.
> 
> Which task *should* that steal time be accounted to? At the moment it
> ends up being accounted to the next task to run — which seems to make
> sense to me. In the situation I just described, we can consider the
> time stolen in update_rq_clock_task() itself to have been stolen from
> the *incoming* task, not the *outgoing* one. But that seems to be what
> you're objecting to?

This is a good description of the problem, except that the time stolen
in update_rq_clock_task() itself is actually being stolen from the 
outgoing task. This is because we are still trying to calculate how long
it ran for (update_curr()), and time hasn't started ticking for the
incoming task yet. We haven't set the incoming task's exec_start with the
new clock_task time yet.

So, in my opinion, it's wrong to give that time to the incoming task.

> 
> In
> https://lore.kernel.org/all/20240522001817.619072-22-dwmw2@infradead.org/
> I put a limit on the amount of steal time carried forward from one
> timeslice to the next, as it was misbehaving when a bad hypervisor
> reported negative steal time. But I don't think the limit should be
> zero.
> 
> Of course, *ideally* we'd be able to sample the time and steal time
> *simultaneously*, with a single sched_clock_cpu_and_steal() function so
> that we don't have to deal with this slop between readings. Then none
> of this would be necessary. But that seems hard.

I agree that that would be ideal.

Thanks,
-- Suleiman


