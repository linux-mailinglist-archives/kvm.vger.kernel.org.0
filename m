Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E26EB48E78F
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 10:33:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239618AbiANJcq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 04:32:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230141AbiANJcq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jan 2022 04:32:46 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25BBFC061574;
        Fri, 14 Jan 2022 01:32:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=rMcUu/K1sVGV/SWZES0Ey2qPe4iMY0WZ61fzFjW8Z3Q=; b=IDAmrVXzL/LxmcKSyBrPlQgbz6
        6aaGrIfS399/ajMDcn64iRN6xaBwNuCgA00UiZuWdwgPxT0qtgE93Qk8sOAwzHK2ZoQk6bqOvXNxw
        6zHptXyExgi2eEPvpB3Lp0bw7Bqnq6xMyjOoFr48etOfHS8IgVv2bPofPzZ2lo7s0FfQkEiv+ZB3l
        tleIUV1QVRU+yGF657jrdb5Mfhk+CLthBju+LnBgHDIdL5yUwefiOCa3YNhWGAt+ITbOCgClk4J+U
        c/sGgmAyUgd0saINUBOcO8/VScYvtRpIel/uJkEKE1jFzqYaUPNy/IqyaNigVqKr3ZIZQAOwpWFO2
        uRCdApUA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n8IwA-005gcN-Tb; Fri, 14 Jan 2022 09:31:59 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 41C903001C0;
        Fri, 14 Jan 2022 10:31:55 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 22952203C24E7; Fri, 14 Jan 2022 10:31:55 +0100 (CET)
Date:   Fri, 14 Jan 2022 10:31:55 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Daniel Jordan <daniel.m.jordan@oracle.com>
Cc:     Alexander Duyck <alexanderduyck@fb.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ben Segall <bsegall@google.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ingo Molnar <mingo@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Michal Hocko <mhocko@suse.com>, Nico Pache <npache@redhat.com>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Steve Sistare <steven.sistare@oracle.com>,
        Tejun Heo <tj@kernel.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-mm@kvack.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [RFC 15/16] sched/fair: Account kthread runtime debt for CFS
 bandwidth
Message-ID: <YeFDC0mV3yurUFbl@hirez.programming.kicks-ass.net>
References: <20220106004656.126790-1-daniel.m.jordan@oracle.com>
 <20220106004656.126790-16-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220106004656.126790-16-daniel.m.jordan@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 05, 2022 at 07:46:55PM -0500, Daniel Jordan wrote:
> As before, helpers in multithreaded jobs don't honor the main thread's
> CFS bandwidth limits, which could lead to the group exceeding its quota.
> 
> Fix it by having helpers remote charge their CPU time to the main
> thread's task group.  A helper calls a pair of new interfaces
> cpu_cgroup_remote_begin() and cpu_cgroup_remote_charge() (see function
> header comments) to achieve this.
> 
> This is just supposed to start a discussion, so it's pretty simple.
> Once a kthread has finished a remote charging period with
> cpu_cgroup_remote_charge(), its runtime is subtracted from the target
> task group's runtime (cfs_bandwidth::runtime) and any remainder is saved
> as debt (cfs_bandwidth::debt) to pay off in later periods.
> 
> Remote charging tasks aren't throttled when the group reaches its quota,
> and a task group doesn't run at all until its debt is completely paid,
> but these shortcomings can be addressed if the approach ends up being
> taken.

> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 44c452072a1b..3c2d7f245c68 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4655,10 +4655,19 @@ static inline u64 sched_cfs_bandwidth_slice(void)
>   */
>  void __refill_cfs_bandwidth_runtime(struct cfs_bandwidth *cfs_b)
>  {
> -	if (unlikely(cfs_b->quota == RUNTIME_INF))
> +	u64 quota = cfs_b->quota;
> +	u64 payment;
> +
> +	if (unlikely(quota == RUNTIME_INF))
>  		return;
>  
> -	cfs_b->runtime += cfs_b->quota;
> +	if (cfs_b->debt) {
> +		payment = min(quota, cfs_b->debt);
> +		cfs_b->debt -= payment;
> +		quota -= payment;
> +	}
> +
> +	cfs_b->runtime += quota;
>  	cfs_b->runtime = min(cfs_b->runtime, cfs_b->quota + cfs_b->burst);
>  }

It might be easier to make cfs_bandwidth::runtime an s64 and make it go
negative.

> @@ -5406,6 +5415,32 @@ static void __maybe_unused unthrottle_offline_cfs_rqs(struct rq *rq)
>  	rcu_read_unlock();
>  }
>  
> +static void incur_cfs_debt(struct rq *rq, struct sched_entity *se,
> +			   struct task_group *tg, u64 debt)
> +{
> +	if (!cfs_bandwidth_used())
> +		return;
> +
> +	while (tg != &root_task_group) {
> +		struct cfs_rq *cfs_rq = tg->cfs_rq[cpu_of(rq)];
> +
> +		if (cfs_rq->runtime_enabled) {
> +			struct cfs_bandwidth *cfs_b = &tg->cfs_bandwidth;
> +			u64 payment;
> +
> +			raw_spin_lock(&cfs_b->lock);
> +
> +			payment = min(cfs_b->runtime, debt);
> +			cfs_b->runtime -= payment;

At this point it might hit 0 (or go negative if/when you do the above)
and you'll need to throttle the group.

> +			cfs_b->debt += debt - payment;
> +
> +			raw_spin_unlock(&cfs_b->lock);
> +		}
> +
> +		tg = tg->parent;
> +	}
> +}

So part of the problem I have with this is that these external things
can consume all the bandwidth and basically indefinitely starve the
group.

This is doulby so if you're going to account things like softirq network
processing.

Also, why does the whole charging API have a task argument? It either is
current or NULL in case of things like softirq, neither really make
sense as an argument.

Also, by virtue of this being a start-stop annotation interface, the
accrued time might be arbitrarily large and arbitrarily delayed. I'm not
sure that's sensible.

For tasks it might be better to mark the task and have the tick DTRT
instead of later trying to 'migrate' the time.
