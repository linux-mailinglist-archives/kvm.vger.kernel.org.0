Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 977FE29C882
	for <lists+kvm@lfdr.de>; Tue, 27 Oct 2020 20:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1829580AbgJ0TR2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 15:17:28 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55048 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1818516AbgJ0TRU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Oct 2020 15:17:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=p1hEPodUXDXuSQzasXYwrS2God+lcKGnVUZasxbSQxY=; b=cdxDu3oxrBK4H243uvi9iaApqN
        OHvlk6JIrx3YcHGxzINSmqLO7PVWeLJHMV3OtLPc2ojslPnjipWNQCWRMQQalw+icSFCM4pRO8uTg
        aOizBQcGY7focMzkxdS44gU+M8acA2ZcOmRH1P1WyEMjSQaJ3VleyvXRczD6iq7BXw5mDmXNBMn8+
        zFm1f48f56RhOKszhZ3Ubq1PIQU6a8j7vmFt+JCkBAfM+ekMIrn+Y4iCanRtmhtH7u0OyhzLI8VSi
        9JgcSpuMC4/GN+wL2sHd/HFguHZyJXkxrvrWZsUSL/XcJnTbVYpPIqvPnOlm/ICapBcfkMyJasbnB
        /0BZYQQA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kXUT2-0003P2-OC; Tue, 27 Oct 2020 19:17:12 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 4A92C307A7F;
        Tue, 27 Oct 2020 20:17:11 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 32968203C2679; Tue, 27 Oct 2020 20:17:11 +0100 (CET)
Date:   Tue, 27 Oct 2020 20:17:11 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Davidlohr Bueso <dave@stgolabs.net>
Subject: Re: [PATCH 3/3] sched: Add cond_resched_rwlock
Message-ID: <20201027191711.GP2628@hirez.programming.kicks-ass.net>
References: <20201027164950.1057601-1-bgardon@google.com>
 <20201027164950.1057601-3-bgardon@google.com>
 <20201027175634.GI1021@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201027175634.GI1021@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 27, 2020 at 10:56:36AM -0700, Sean Christopherson wrote:
> On Tue, Oct 27, 2020 at 09:49:50AM -0700, Ben Gardon wrote:
> > Rescheduling while holding a spin lock is essential for keeping long
> > running kernel operations running smoothly. Add the facility to
> > cond_resched rwlocks.
> 
> This adds two new exports and two new macros without any in-tree users, which
> is generally frowned upon.  You and I know these will be used by KVM's new
> TDP MMU, but the non-KVM folks, and more importantly the maintainers of this
> code, are undoubtedly going to ask "why".  I.e. these patches probably belong
> in the KVM series to switch to a rwlock for the TDP MMU.

I was informed about this ;-)

> Regarding the code, it's all copy-pasted from the spinlock code and darn near
> identical.  It might be worth adding builder macros for these.

I considered mentioning them; I'm typically a fan of them, but I'm not
quite sure it's worth the effort here.

> > +int __cond_resched_rwlock_read(rwlock_t *lock)
> > +{
> > +	int resched = should_resched(PREEMPT_LOCK_OFFSET);
> > +	int ret = 0;
> > +
> > +	lockdep_assert_held(lock);
> > +
> > +	if (rwlock_needbreak(lock) || resched) {
> > +		read_unlock(lock);
> > +		if (resched)
> > +			preempt_schedule_common();
> > +		else
> > +			cpu_relax();
> > +		ret = 1;
> 
> AFAICT, this rather odd code flow from __cond_resched_lock() is an artifact of
> code changes over the years and not intentionally weird.  IMO, it would be
> cleaner and easier to read as:
> 
> 	int resched = should_resched(PREEMPT_LOCK_OFFSET);
> 
> 	lockdep_assert_held(lock);

lockdep_assert_held_read() :-)

> 
> 	if (!rwlock_needbreak(lock) && !resched)
> 		return 0;
> 
> 	read_unlock(lock);
> 	if (resched)
> 		preempt_schedule_common();
> 	else
> 		cpu_relax();
> 	read_lock(lock)
> 	return 1;
> 

I suppose that works, but then also change the existing one.
