Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F88C10B5E4
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2019 19:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbfK0Smi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Nov 2019 13:42:38 -0500
Received: from mga17.intel.com ([192.55.52.151]:43591 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726593AbfK0Smi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Nov 2019 13:42:38 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Nov 2019 10:42:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,250,1571727600"; 
   d="scan'208";a="199277686"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga007.jf.intel.com with ESMTP; 27 Nov 2019 10:42:37 -0800
Date:   Wed, 27 Nov 2019 10:42:37 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [RFC PATCH 05/28] sched: Add cond_resched_rwlock
Message-ID: <20191127184237.GE22227@linux.intel.com>
References: <20190926231824.149014-1-bgardon@google.com>
 <20190926231824.149014-6-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190926231824.149014-6-bgardon@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 26, 2019 at 04:18:01PM -0700, Ben Gardon wrote:
> Rescheduling while holding a spin lock is essential for keeping long
> running kernel operations running smoothly. Add the facility to
> cond_resched read/write spin locks.
> 
> RFC_NOTE: The current implementation of this patch set uses a read/write
> lock to replace the existing MMU spin lock. See the next patch in this
> series for more on why a read/write lock was chosen, and possible
> alternatives.

This definitely needs to be run by the sched/locking folks sooner rather
than later.

> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  include/linux/sched.h | 11 +++++++++++
>  kernel/sched/core.c   | 23 +++++++++++++++++++++++
>  2 files changed, 34 insertions(+)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 70db597d6fd4f..4d1fd96693d9b 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1767,12 +1767,23 @@ static inline int _cond_resched(void) { return 0; }
>  })
>  
>  extern int __cond_resched_lock(spinlock_t *lock);
> +extern int __cond_resched_rwlock(rwlock_t *lock, bool write_lock);
>  
>  #define cond_resched_lock(lock) ({				\
>  	___might_sleep(__FILE__, __LINE__, PREEMPT_LOCK_OFFSET);\
>  	__cond_resched_lock(lock);				\
>  })
>  
> +#define cond_resched_rwlock_read(lock) ({			\
> +	__might_sleep(__FILE__, __LINE__, PREEMPT_LOCK_OFFSET);	\
> +	__cond_resched_rwlock(lock, false);			\
> +})
> +
> +#define cond_resched_rwlock_write(lock) ({			\
> +	__might_sleep(__FILE__, __LINE__, PREEMPT_LOCK_OFFSET);	\
> +	__cond_resched_rwlock(lock, true);			\
> +})
> +
>  static inline void cond_resched_rcu(void)
>  {
>  #if defined(CONFIG_DEBUG_ATOMIC_SLEEP) || !defined(CONFIG_PREEMPT_RCU)
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index f9a1346a5fa95..ba7ed4bed5036 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -5663,6 +5663,29 @@ int __cond_resched_lock(spinlock_t *lock)
>  }
>  EXPORT_SYMBOL(__cond_resched_lock);
>  
> +int __cond_resched_rwlock(rwlock_t *lock, bool write_lock)
> +{
> +	int ret = 0;
> +
> +	lockdep_assert_held(lock);
> +	if (should_resched(PREEMPT_LOCK_OFFSET)) {
> +		if (write_lock) {

The existing __cond_resched_lock() checks for resched *or* lock
contention.  Is lock contention not something that needs (or can't?) be
considered?

> +			write_unlock(lock);
> +			preempt_schedule_common();
> +			write_lock(lock);
> +		} else {
> +			read_unlock(lock);
> +			preempt_schedule_common();
> +			read_lock(lock);
> +		}
> +
> +		ret = 1;
> +	}
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(__cond_resched_rwlock);
> +
>  /**
>   * yield - yield the current processor to other threads.
>   *
> -- 
> 2.23.0.444.g18eeb5a265-goog
> 
