Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 492D929C4F1
	for <lists+kvm@lfdr.de>; Tue, 27 Oct 2020 19:08:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1823202AbgJ0SBC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 14:01:02 -0400
Received: from mga05.intel.com ([192.55.52.43]:34792 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1822989AbgJ0R4k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Oct 2020 13:56:40 -0400
IronPort-SDR: vjvgGDD0NGIX6UEjoszQzqOGx3E0qf1DChzA0NXw6cXKA8L51J6LTXqNKVzcsYaws5LVjayE5g
 5RAZLLZiorKg==
X-IronPort-AV: E=McAfee;i="6000,8403,9787"; a="252832121"
X-IronPort-AV: E=Sophos;i="5.77,424,1596524400"; 
   d="scan'208";a="252832121"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2020 10:56:37 -0700
IronPort-SDR: lhTXJjKMMe48W2fw2kvkLvMa4ud3oSkNemMMiUpDzw41G6iO737oAPFrG3kaxHY1ElO1pPQi2d
 Ogpi0hhlimQA==
X-IronPort-AV: E=Sophos;i="5.77,424,1596524400"; 
   d="scan'208";a="350682053"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2020 10:56:37 -0700
Date:   Tue, 27 Oct 2020 10:56:36 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Davidlohr Bueso <dave@stgolabs.net>
Subject: Re: [PATCH 3/3] sched: Add cond_resched_rwlock
Message-ID: <20201027175634.GI1021@linux.intel.com>
References: <20201027164950.1057601-1-bgardon@google.com>
 <20201027164950.1057601-3-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201027164950.1057601-3-bgardon@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 27, 2020 at 09:49:50AM -0700, Ben Gardon wrote:
> Rescheduling while holding a spin lock is essential for keeping long
> running kernel operations running smoothly. Add the facility to
> cond_resched rwlocks.

This adds two new exports and two new macros without any in-tree users, which
is generally frowned upon.  You and I know these will be used by KVM's new
TDP MMU, but the non-KVM folks, and more importantly the maintainers of this
code, are undoubtedly going to ask "why".  I.e. these patches probably belong
in the KVM series to switch to a rwlock for the TDP MMU.

Regarding the code, it's all copy-pasted from the spinlock code and darn near
identical.  It might be worth adding builder macros for these.

> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  include/linux/sched.h | 12 ++++++++++++
>  kernel/sched/core.c   | 40 ++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 52 insertions(+)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 77179160ec3ab..2eb0c53fce115 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1841,12 +1841,24 @@ static inline int _cond_resched(void) { return 0; }
>  })
>  
>  extern int __cond_resched_lock(spinlock_t *lock);
> +extern int __cond_resched_rwlock_read(rwlock_t *lock);
> +extern int __cond_resched_rwlock_write(rwlock_t *lock);
>  
>  #define cond_resched_lock(lock) ({				\
>  	___might_sleep(__FILE__, __LINE__, PREEMPT_LOCK_OFFSET);\
>  	__cond_resched_lock(lock);				\
>  })
>  
> +#define cond_resched_rwlock_read(lock) ({			\
> +	__might_sleep(__FILE__, __LINE__, PREEMPT_LOCK_OFFSET);	\
> +	__cond_resched_rwlock_read(lock);			\
> +})
> +
> +#define cond_resched_rwlock_write(lock) ({			\
> +	__might_sleep(__FILE__, __LINE__, PREEMPT_LOCK_OFFSET);	\
> +	__cond_resched_rwlock_write(lock);			\
> +})
> +
>  static inline void cond_resched_rcu(void)
>  {
>  #if defined(CONFIG_DEBUG_ATOMIC_SLEEP) || !defined(CONFIG_PREEMPT_RCU)
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
> +
> +	if (rwlock_needbreak(lock) || resched) {
> +		read_unlock(lock);
> +		if (resched)
> +			preempt_schedule_common();
> +		else
> +			cpu_relax();
> +		ret = 1;

AFAICT, this rather odd code flow from __cond_resched_lock() is an artifact of
code changes over the years and not intentionally weird.  IMO, it would be
cleaner and easier to read as:

	int resched = should_resched(PREEMPT_LOCK_OFFSET);

	lockdep_assert_held(lock);

	if (!rwlock_needbreak(lock) && !resched)
		return 0;

	read_unlock(lock);
	if (resched)
		preempt_schedule_common();
	else
		cpu_relax();
	read_lock(lock)
	return 1;


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

This shoulid be lockdep_assert_held_write.

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
> +
>  /**
>   * yield - yield the current processor to other threads.
>   *
> -- 
> 2.29.0.rc2.309.g374f81d7ae-goog
> 
