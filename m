Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6324D37BCE5
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 14:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbhELMwm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 08:52:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:51810 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230472AbhELMwl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 08:52:41 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 51B38AE27;
        Wed, 12 May 2021 12:51:32 +0000 (UTC)
Date:   Wed, 12 May 2021 13:51:29 +0100
From:   Mel Gorman <mgorman@suse.de>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     tglx@linutronix.de, mingo@kernel.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, bristot@redhat.com,
        bsingharora@gmail.com, pbonzini@redhat.com, maz@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        riel@surriel.com, hannes@cmpxchg.org
Subject: Re: [PATCH 3/6] sched: Simplify sched_info_on()
Message-ID: <20210512125129.GI3672@suse.de>
References: <20210505105940.190490250@infradead.org>
 <20210505111525.121458839@infradead.org>
 <20210512111040.GC3672@suse.de>
 <YJu8s0f7Cc78GEWN@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <YJu8s0f7Cc78GEWN@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 12, 2021 at 01:32:03PM +0200, Peter Zijlstra wrote:
> On Wed, May 12, 2021 at 12:10:40PM +0100, Mel Gorman wrote:
> > As delta is !0 iff t->sched_info.last_queued, why not this?
> > 
> > diff --git a/kernel/sched/stats.h b/kernel/sched/stats.h
> > index 33ffd41935ba..37e33c0eeb7c 100644
> > --- a/kernel/sched/stats.h
> > +++ b/kernel/sched/stats.h
> > @@ -158,15 +158,14 @@ static inline void psi_sched_switch(struct task_struct *prev,
> >   */
> >  static inline void sched_info_dequeue(struct rq *rq, struct task_struct *t)
> >  {
> > -	unsigned long long delta = 0;
> > -
> >  	if (t->sched_info.last_queued) {
> > +		unsigned long long delta;
> > +
> >  		delta = rq_clock(rq) - t->sched_info.last_queued;
> >  		t->sched_info.last_queued = 0;
> > +		t->sched_info.run_delay += delta;
> > +		rq_sched_info_dequeue(rq, delta);
> >  	}
> > -	t->sched_info.run_delay += delta;
> > -
> > -	rq_sched_info_dequeue(rq, delta);
> >  }
> 
> Right.. clearly I missed the obvious there.. Lemme go add another patch
> on top of the lot.
> 
> Something like this I suppose.
> 

That works for me.

-- 
Mel Gorman
SUSE Labs
