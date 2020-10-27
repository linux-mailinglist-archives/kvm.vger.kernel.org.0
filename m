Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BDF229C7AD
	for <lists+kvm@lfdr.de>; Tue, 27 Oct 2020 19:46:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1829019AbgJ0SqG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 14:46:06 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35992 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1768326AbgJ0Sou (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Oct 2020 14:44:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5w2hfIMJV6eBuU1QS+EKGrZJ72mE5r3U8ZpMrDG2UF0=; b=xqxC59UC0fmHNYtLXexNuxFOYt
        khFJ/sVvpt13jCah+lP686aiE1j3Vtc6fXV36C34g2oc17EGvpV9wFehk4tTCP9FFw9P9EHENfyxe
        r63jlpiBJzqhSWKJwCzDwWP/xe6Ip9JSHS3vhptJup59iiLBgYnA6FAlBULbwM3bLowC6m029GPVh
        GdiHwii7o4R2/W3gbqZU7CPLc3ssH/8ygCG7ajfIenv5fxJyH89GA55PZjUdxri50eCecF+D2SmSz
        7B7iYiKtrR3+qIXtooy81nmK7Ci0LbP6rVWP5lt5Y62OzS7HfzO85Kuu3f6Ya2bEwZE9d+gz/uKG2
        9c5vC5IQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kXTxZ-0007Zy-TR; Tue, 27 Oct 2020 18:44:42 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 487E03079A3;
        Tue, 27 Oct 2020 19:44:40 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 3273D203CF3A3; Tue, 27 Oct 2020 19:44:40 +0100 (CET)
Date:   Tue, 27 Oct 2020 19:44:40 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Davidlohr Bueso <dave@stgolabs.net>
Subject: Re: [PATCH 3/3] sched: Add cond_resched_rwlock
Message-ID: <20201027184440.GN2628@hirez.programming.kicks-ass.net>
References: <20201027164950.1057601-1-bgardon@google.com>
 <20201027164950.1057601-3-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201027164950.1057601-3-bgardon@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 27, 2020 at 09:49:50AM -0700, Ben Gardon wrote:

> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index d2003a7d5ab55..ac58e7829a063 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -6152,6 +6152,46 @@ int __cond_resched_lock(spinlock_t *lock)
>  }
>  EXPORT_SYMBOL(__cond_resched_lock);
>  
> +int __cond_resched_rwlock_read(rwlock_t *lock)
> +{
> +	int resched = should_resched(PREEMPT_LOCK_OFFSET);
> +	int ret = 0;
> +
> +	lockdep_assert_held(lock);

	lockdep_assert_held_read(lock);

> +
> +	if (rwlock_needbreak(lock) || resched) {
> +		read_unlock(lock);
> +		if (resched)
> +			preempt_schedule_common();
> +		else
> +			cpu_relax();
> +		ret = 1;
> +		read_lock(lock);
> +	}
> +	return ret;
> +}
> +EXPORT_SYMBOL(__cond_resched_rwlock_read);
> +
> +int __cond_resched_rwlock_write(rwlock_t *lock)
> +{
> +	int resched = should_resched(PREEMPT_LOCK_OFFSET);
> +	int ret = 0;
> +
> +	lockdep_assert_held(lock);

	lockdep_assert_held_write(lock);

> +
> +	if (rwlock_needbreak(lock) || resched) {
> +		write_unlock(lock);
> +		if (resched)
> +			preempt_schedule_common();
> +		else
> +			cpu_relax();
> +		ret = 1;
> +		write_lock(lock);
> +	}
> +	return ret;
> +}
> +EXPORT_SYMBOL(__cond_resched_rwlock_write);

If this is the only feedback (the patches look fine to me), don't bother
resending, I'll edit them when applying.
