Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 147D52A0C1F
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 18:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727179AbgJ3RJH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 13:09:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26659 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725808AbgJ3RJH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 30 Oct 2020 13:09:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604077745;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bJ1mTppI0IB1R7JLwvwRStzfx4lBSnTdOO6YlKS1jso=;
        b=i1ZUecsR0ML32+TM0h6mCwZDtk9iIaZOy29CTOw+IaTJwmvXdoYrUrtUb0tGqRomDgqjFi
        +4xfSWIXWNkvlF+0F3kLeIR7bUnNkLuqZ+k7HjRCI+cvrjg7mtcsSU4hEw6BsrcJfC//tL
        T3YiCncBBrPj+Cxj3mu/aHfe1jTVyDE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-357-3PwWS2F6PPC8jAX-FtL6eg-1; Fri, 30 Oct 2020 13:09:04 -0400
X-MC-Unique: 3PwWS2F6PPC8jAX-FtL6eg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6491D10866AD;
        Fri, 30 Oct 2020 17:09:02 +0000 (UTC)
Received: from llong.remote.csb (ovpn-119-148.rdu2.redhat.com [10.10.119.148])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 69D4D5B4D0;
        Fri, 30 Oct 2020 17:09:01 +0000 (UTC)
Subject: Re: [PATCH 3/3] sched: Add cond_resched_rwlock
To:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Davidlohr Bueso <dave@stgolabs.net>
References: <20201027164950.1057601-1-bgardon@google.com>
 <20201027164950.1057601-3-bgardon@google.com>
From:   Waiman Long <longman@redhat.com>
Organization: Red Hat
Message-ID: <5e1101b9-6568-ae91-d2a2-847af8d63660@redhat.com>
Date:   Fri, 30 Oct 2020 13:09:00 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20201027164950.1057601-3-bgardon@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/27/20 12:49 PM, Ben Gardon wrote:
> Rescheduling while holding a spin lock is essential for keeping long
> running kernel operations running smoothly. Add the facility to
> cond_resched rwlocks.
>
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>   include/linux/sched.h | 12 ++++++++++++
>   kernel/sched/core.c   | 40 ++++++++++++++++++++++++++++++++++++++++
>   2 files changed, 52 insertions(+)
>
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 77179160ec3ab..2eb0c53fce115 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1841,12 +1841,24 @@ static inline int _cond_resched(void) { return 0; }
>   })
>   
>   extern int __cond_resched_lock(spinlock_t *lock);
> +extern int __cond_resched_rwlock_read(rwlock_t *lock);
> +extern int __cond_resched_rwlock_write(rwlock_t *lock);
>   
>   #define cond_resched_lock(lock) ({				\
>   	___might_sleep(__FILE__, __LINE__, PREEMPT_LOCK_OFFSET);\
>   	__cond_resched_lock(lock);				\
>   })
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
>   static inline void cond_resched_rcu(void)
>   {
>   #if defined(CONFIG_DEBUG_ATOMIC_SLEEP) || !defined(CONFIG_PREEMPT_RCU)
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index d2003a7d5ab55..ac58e7829a063 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -6152,6 +6152,46 @@ int __cond_resched_lock(spinlock_t *lock)
>   }
>   EXPORT_SYMBOL(__cond_resched_lock);
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
>   /**
>    * yield - yield the current processor to other threads.
>    *

Other than the lockdep_assert_held() changes spotted by others, this 
patch looks good to me.

Acked-by: Waiman Long <longman@redhat.com>

