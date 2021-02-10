Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 815BE315DCD
	for <lists+kvm@lfdr.de>; Wed, 10 Feb 2021 04:34:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbhBJDeT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 22:34:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33075 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229581AbhBJDeI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Feb 2021 22:34:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612927959;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dIycg8TE3qvA5BDEadabLQSqpKyAlR7M5/0dpkVkaDg=;
        b=UquISDiJjH4Fuc2WhguJziewTKaIVxAFG8Brr7R31lt0nr1c/ZjSQs1SdNxMx5LjgrjjhA
        yw8c4NJ26YM4sOhH0a/Nu0w6axYSUSB8v4yESpYrLlGIKUmiQq8bdPyhKC4CVE9DQp1Hx7
        DX+B2XkqhUFrGJRQXSegYY+ElFI2FXk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-385-9TvoC1MnOGG9tUQID_yKmQ-1; Tue, 09 Feb 2021 22:32:36 -0500
X-MC-Unique: 9TvoC1MnOGG9tUQID_yKmQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D82851005501;
        Wed, 10 Feb 2021 03:32:33 +0000 (UTC)
Received: from llong.remote.csb (ovpn-119-222.rdu2.redhat.com [10.10.119.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F120A19CA8;
        Wed, 10 Feb 2021 03:32:28 +0000 (UTC)
Subject: Re: [PATCH v2 06/28] locking/rwlocks: Add contention detection for
 rwlocks
To:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Davidlohr Bueso <dbueso@suse.de>
References: <20210202185734.1680553-1-bgardon@google.com>
 <20210202185734.1680553-7-bgardon@google.com>
From:   Waiman Long <longman@redhat.com>
Organization: Red Hat
Message-ID: <6287ff89-d869-e5ed-3e64-11621cc4796a@redhat.com>
Date:   Tue, 9 Feb 2021 22:32:28 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210202185734.1680553-7-bgardon@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/2/21 1:57 PM, Ben Gardon wrote:
> rwlocks do not currently have any facility to detect contention
> like spinlocks do. In order to allow users of rwlocks to better manage
> latency, add contention detection for queued rwlocks.
>
> CC: Ingo Molnar <mingo@redhat.com>
> CC: Will Deacon <will@kernel.org>
> Acked-by: Peter Zijlstra <peterz@infradead.org>
> Acked-by: Davidlohr Bueso <dbueso@suse.de>
> Acked-by: Waiman Long <longman@redhat.com>
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>   include/asm-generic/qrwlock.h | 24 ++++++++++++++++++------
>   include/linux/rwlock.h        |  7 +++++++
>   2 files changed, 25 insertions(+), 6 deletions(-)
>
> diff --git a/include/asm-generic/qrwlock.h b/include/asm-generic/qrwlock.h
> index 84ce841ce735..0020d3b820a7 100644
> --- a/include/asm-generic/qrwlock.h
> +++ b/include/asm-generic/qrwlock.h
> @@ -14,6 +14,7 @@
>   #include <asm/processor.h>
>   
>   #include <asm-generic/qrwlock_types.h>
> +#include <asm-generic/qspinlock.h>

As said in another thread, qspinlock and qrwlock can be independently 
enabled for an architecture. So we shouldn't include qspinlock.h here. 
Instead, just include the regular linux/spinlock.h file to make sure 
that arch_spin_is_locked() is available.


>   
>   /*
>    * Writer states & reader shift and bias.
> @@ -116,15 +117,26 @@ static inline void queued_write_unlock(struct qrwlock *lock)
>   	smp_store_release(&lock->wlocked, 0);
>   }
>   
> +/**
> + * queued_rwlock_is_contended - check if the lock is contended
> + * @lock : Pointer to queue rwlock structure
> + * Return: 1 if lock contended, 0 otherwise
> + */
> +static inline int queued_rwlock_is_contended(struct qrwlock *lock)
> +{
> +	return arch_spin_is_locked(&lock->wait_lock);
> +}
> +
>   /*
>    * Remapping rwlock architecture specific functions to the corresponding
>    * queue rwlock functions.
>    */
> -#define arch_read_lock(l)	queued_read_lock(l)
> -#define arch_write_lock(l)	queued_write_lock(l)
> -#define arch_read_trylock(l)	queued_read_trylock(l)
> -#define arch_write_trylock(l)	queued_write_trylock(l)
> -#define arch_read_unlock(l)	queued_read_unlock(l)
> -#define arch_write_unlock(l)	queued_write_unlock(l)
> +#define arch_read_lock(l)		queued_read_lock(l)
> +#define arch_write_lock(l)		queued_write_lock(l)
> +#define arch_read_trylock(l)		queued_read_trylock(l)
> +#define arch_write_trylock(l)		queued_write_trylock(l)
> +#define arch_read_unlock(l)		queued_read_unlock(l)
> +#define arch_write_unlock(l)		queued_write_unlock(l)
> +#define arch_rwlock_is_contended(l)	queued_rwlock_is_contended(l)
>   
>   #endif /* __ASM_GENERIC_QRWLOCK_H */
> diff --git a/include/linux/rwlock.h b/include/linux/rwlock.h
> index 3dcd617e65ae..7ce9a51ae5c0 100644
> --- a/include/linux/rwlock.h
> +++ b/include/linux/rwlock.h
> @@ -128,4 +128,11 @@ do {								\
>   	1 : ({ local_irq_restore(flags); 0; }); \
>   })
>   
> +#ifdef arch_rwlock_is_contended
> +#define rwlock_is_contended(lock) \
> +	 arch_rwlock_is_contended(&(lock)->raw_lock)
> +#else
> +#define rwlock_is_contended(lock)	((void)(lock), 0)
> +#endif /* arch_rwlock_is_contended */
> +
>   #endif /* __LINUX_RWLOCK_H */

Cheers,
Longman

