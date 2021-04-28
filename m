Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37C0736D4C3
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 11:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238130AbhD1J27 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 05:28:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbhD1J26 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Apr 2021 05:28:58 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D174BC061574;
        Wed, 28 Apr 2021 02:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=y7ONP7hJrRnuCKAnDvxJuxgrmiIMotVAdN8SIVwNIn8=; b=P6uUb98fva69hTbe+PGpKi1ePy
        Gz316TWz9533QR18cIuzbrvuEVD4uv96CstbkjVW5vl1pt/lKfeSm9qV8xIvrl3yLJjHE/YWrp3O/
        ZGUYH9FGx1oOPlQS1fJvxpk32Gk4Uv/RHOtRJyruqIxYFJ1GLKvqTNGVsXpH8MK04/PQRQs7Bf4uL
        VCxJRDr8U/uq5CmipohO+TIUU93SnTDk+LNfLpvyVg+WU+rdT5AFbAAIJSPeYOV1pG4CkCqJbCr2M
        +yyL85w1Fmw8ItfalaHTnzwtmA3I2vmwAZVnYG+M6XJZw9pK5al9O/shkThtU4cJ0IfrC8zKHr+P5
        3zed6jKg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lbgRc-00861i-JC; Wed, 28 Apr 2021 09:26:03 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 780CE300094;
        Wed, 28 Apr 2021 11:25:19 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 56A212BF7B845; Wed, 28 Apr 2021 11:25:19 +0200 (CEST)
Date:   Wed, 28 Apr 2021 11:25:19 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     bristot@redhat.com, bsegall@google.com, dietmar.eggemann@arm.com,
        greg@kroah.com, gregkh@linuxfoundation.org, joshdon@google.com,
        juri.lelli@redhat.com, linux-kernel@vger.kernel.org,
        linux@rasmusvillemoes.dk, mgorman@suse.de, mingo@kernel.org,
        rostedt@goodmis.org, valentin.schneider@arm.com,
        vincent.guittot@linaro.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: sched: Move SCHED_DEBUG sysctl to debugfs
Message-ID: <YIkp/6/NDL7KsvpY@hirez.programming.kicks-ass.net>
References: <20210412102001.287610138@infradead.org>
 <20210427145925.5246-1-borntraeger@de.ibm.com>
 <YIkgzUWEPaXQTCOv@hirez.programming.kicks-ass.net>
 <cf2a6c6c-21ea-df7b-94d1-940a344b8d26@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf2a6c6c-21ea-df7b-94d1-940a344b8d26@de.ibm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 28, 2021 at 10:54:37AM +0200, Christian Borntraeger wrote:
> 
> 
> On 28.04.21 10:46, Peter Zijlstra wrote:
> > On Tue, Apr 27, 2021 at 04:59:25PM +0200, Christian Borntraeger wrote:
> > > Peter,
> > > 
> > > I just realized that we moved away sysctl tunabled to debugfs in next.
> > > We have seen several cases where it was benefitial to set
> > > sched_migration_cost_ns to a lower value. For example with KVM I can
> > > easily get 50% more transactions with 50000 instead of 500000.
> > > Until now it was possible to use tuned or /etc/sysctl.conf to set
> > > these things permanently.
> > > 
> > > Given that some people do not want to have debugfs mounted all the time
> > > I would consider this a regression. The sysctl tunable was always
> > > available.
> > > 
> > > I am ok with the "informational" things being in debugfs, but not
> > > the tunables. So how do we proceed here?
> > 
> > It's all SCHED_DEBUG; IOW you're relying on DEBUG infrastructure for
> > production performance, and that's your fail.
> 
> No its not. sched_migration_cost_ns was NEVER protected by CONFIG_SCHED_DEBUG.
> It was available on all kernels with CONFIG_SMP.

The relevant section from origin/master:kernel/sysctl.c:

#ifdef CONFIG_SCHED_DEBUG
	{
		.procname	= "sched_min_granularity_ns",
		.data		= &sysctl_sched_min_granularity,
		.maxlen		= sizeof(unsigned int),
		.mode		= 0644,
		.proc_handler	= sched_proc_update_handler,
		.extra1		= &min_sched_granularity_ns,
		.extra2		= &max_sched_granularity_ns,
	},
	{
		.procname	= "sched_latency_ns",
		.data		= &sysctl_sched_latency,
		.maxlen		= sizeof(unsigned int),
		.mode		= 0644,
		.proc_handler	= sched_proc_update_handler,
		.extra1		= &min_sched_granularity_ns,
		.extra2		= &max_sched_granularity_ns,
	},
	{
		.procname	= "sched_wakeup_granularity_ns",
		.data		= &sysctl_sched_wakeup_granularity,
		.maxlen		= sizeof(unsigned int),
		.mode		= 0644,
		.proc_handler	= sched_proc_update_handler,
		.extra1		= &min_wakeup_granularity_ns,
		.extra2		= &max_wakeup_granularity_ns,
	},
#ifdef CONFIG_SMP
	{
		.procname	= "sched_tunable_scaling",
		.data		= &sysctl_sched_tunable_scaling,
		.maxlen		= sizeof(enum sched_tunable_scaling),
		.mode		= 0644,
		.proc_handler	= sched_proc_update_handler,
		.extra1		= &min_sched_tunable_scaling,
		.extra2		= &max_sched_tunable_scaling,
	},
	{
		.procname	= "sched_migration_cost_ns",
		.data		= &sysctl_sched_migration_cost,
		.maxlen		= sizeof(unsigned int),
		.mode		= 0644,
		.proc_handler	= proc_dointvec,
	},
	{
		.procname	= "sched_nr_migrate",
		.data		= &sysctl_sched_nr_migrate,
		.maxlen		= sizeof(unsigned int),
		.mode		= 0644,
		.proc_handler	= proc_dointvec,
	},
#ifdef CONFIG_SCHEDSTATS
	{
		.procname	= "sched_schedstats",
		.data		= NULL,
		.maxlen		= sizeof(unsigned int),
		.mode		= 0644,
		.proc_handler	= sysctl_schedstats,
		.extra1		= SYSCTL_ZERO,
		.extra2		= SYSCTL_ONE,
	},
#endif /* CONFIG_SCHEDSTATS */
#endif /* CONFIG_SMP */
#ifdef CONFIG_NUMA_BALANCING
	{
		.procname	= "numa_balancing_scan_delay_ms",
		.data		= &sysctl_numa_balancing_scan_delay,
		.maxlen		= sizeof(unsigned int),
		.mode		= 0644,
		.proc_handler	= proc_dointvec,
	},
	{
		.procname	= "numa_balancing_scan_period_min_ms",
		.data		= &sysctl_numa_balancing_scan_period_min,
		.maxlen		= sizeof(unsigned int),
		.mode		= 0644,
		.proc_handler	= proc_dointvec,
	},
	{
		.procname	= "numa_balancing_scan_period_max_ms",
		.data		= &sysctl_numa_balancing_scan_period_max,
		.maxlen		= sizeof(unsigned int),
		.mode		= 0644,
		.proc_handler	= proc_dointvec,
	},
	{
		.procname	= "numa_balancing_scan_size_mb",
		.data		= &sysctl_numa_balancing_scan_size,
		.maxlen		= sizeof(unsigned int),
		.mode		= 0644,
		.proc_handler	= proc_dointvec_minmax,
		.extra1		= SYSCTL_ONE,
	},
	{
		.procname	= "numa_balancing",
		.data		= NULL, /* filled in by handler */
		.maxlen		= sizeof(unsigned int),
		.mode		= 0644,
		.proc_handler	= sysctl_numa_balancing,
		.extra1		= SYSCTL_ZERO,
		.extra2		= SYSCTL_ONE,
	},
#endif /* CONFIG_NUMA_BALANCING */
#endif /* CONFIG_SCHED_DEBUG */

How is migration_cost not under SCHED_DEBUG? The bigger problem is that
world+dog has SCHED_DEBUG=y in their .config.


