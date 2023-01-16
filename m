Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F308A66D127
	for <lists+kvm@lfdr.de>; Mon, 16 Jan 2023 22:57:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234871AbjAPV5d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Jan 2023 16:57:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234156AbjAPV5a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Jan 2023 16:57:30 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BB5024491
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 13:56:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673906204;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eh4V/toS718E68IlYB64s6hGtbmtJ10ieSzmAkeBliY=;
        b=KfjDHDw/r+MbPvAcyNl5jLM+ORzd0kYyRIkA/E3P/Z43QGvceSI2AhihZfvee3cxXZ0+dj
        LPOLnkIVFtnm55DD56QyJeUtKL4tWNwx6mw3AwSXWbn7d3qVkxskf0mgiOShFNJdgziG8J
        MWNLxisHyivcp5f6ghnmCRrBXD0z+qM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-10-U40D2aN6NBmROTEJPDDCCg-1; Mon, 16 Jan 2023 16:56:39 -0500
X-MC-Unique: U40D2aN6NBmROTEJPDDCCg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3D27A29A9CA2;
        Mon, 16 Jan 2023 21:56:38 +0000 (UTC)
Received: from [10.22.18.0] (unknown [10.22.18.0])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 215C3C15BA0;
        Mon, 16 Jan 2023 21:56:37 +0000 (UTC)
Message-ID: <0f67aad4-45fb-c679-a11a-6046a1a74628@redhat.com>
Date:   Mon, 16 Jan 2023 16:56:36 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH 1/3] locking/lockdep: Introduce lock_sync()
Content-Language: en-US
To:     Boqun Feng <boqun.feng@gmail.com>, linux-kernel@vger.kernel.org,
        rcu@vger.kernel.org, kvm@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>, seanjc@google.com,
        Joel Fernandes <joel@joelfernandes.org>,
        Matthew Wilcox <willy@infradead.org>,
        Michal Luczaj <mhal@rbox.co>
References: <20230113065955.815667-1-boqun.feng@gmail.com>
 <20230113065955.815667-2-boqun.feng@gmail.com>
From:   Waiman Long <longman@redhat.com>
In-Reply-To: <20230113065955.815667-2-boqun.feng@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/13/23 01:59, Boqun Feng wrote:
> Currently, in order to annonate functions like synchronize_srcu() for
> lockdep, a trick as follow can be used:
>
> 	lock_acquire();
> 	lock_release();
>
> , which indicates synchronize_srcu() acts like an empty critical section
> that waits for other (read-side) critical sections to finish. This
> surely can catch some deadlock, but as discussion brought up by Paul
> Mckenney [1], this could introduce false positives because of
> irq-safe/unsafe detection. Extra tricks might help this:
>
> 	local_irq_disable(..);
> 	lock_acquire();
> 	lock_release();
> 	local_irq_enable(...);
>
> But it's better that lockdep could provide an annonation for
> synchronize_srcu() like functions, so that people won't need to repeat
> the ugly tricks above. Therefore introduce lock_sync(). It's simply an
> lock+unlock pair with no irq safe/unsafe deadlock check, since the
> to-be-annontated functions don't create real critical sections therefore
> there is no way that irq can create extra dependencies.
>
> [1]: https://lore.kernel.org/lkml/20180412021233.ewncg5jjuzjw3x62@tardis/
>
> Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
> ---
>   include/linux/lockdep.h  |  5 +++++
>   kernel/locking/lockdep.c | 34 ++++++++++++++++++++++++++++++++++
>   2 files changed, 39 insertions(+)
>
> diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
> index 1f1099dac3f0..ba09df6a0872 100644
> --- a/include/linux/lockdep.h
> +++ b/include/linux/lockdep.h
> @@ -268,6 +268,10 @@ extern void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
>   
>   extern void lock_release(struct lockdep_map *lock, unsigned long ip);
>   
> +extern void lock_sync(struct lockdep_map *lock, unsigned int subclass,
> +		      int read, int check, struct lockdep_map *nest_lock,
> +		      unsigned long ip);
> +
>   /* lock_is_held_type() returns */
>   #define LOCK_STATE_UNKNOWN	-1
>   #define LOCK_STATE_NOT_HELD	0
> @@ -555,6 +559,7 @@ do {									\
>   #define lock_map_acquire_read(l)		lock_acquire_shared_recursive(l, 0, 0, NULL, _THIS_IP_)
>   #define lock_map_acquire_tryread(l)		lock_acquire_shared_recursive(l, 0, 1, NULL, _THIS_IP_)
>   #define lock_map_release(l)			lock_release(l, _THIS_IP_)
> +#define lock_map_sync(l)			lock_sync(l, 0, 0, 1, NULL, _THIS_IP_)
>   
>   #ifdef CONFIG_PROVE_LOCKING
>   # define might_lock(lock)						\
> diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
> index e3375bc40dad..cffa026a765f 100644
> --- a/kernel/locking/lockdep.c
> +++ b/kernel/locking/lockdep.c
> @@ -5692,6 +5692,40 @@ void lock_release(struct lockdep_map *lock, unsigned long ip)
>   }
>   EXPORT_SYMBOL_GPL(lock_release);
>   
> +/*
> + * lock_sync() - A special annotation for synchronize_{s,}rcu()-like API.
> + *
> + * No actual critical section is created by the APIs annotated with this: these
> + * APIs are used to wait for one or multiple critical sections (on other CPUs
> + * or threads), and it means that calling these APIs inside these critical
> + * sections is potential deadlock.
> + *
> + * This annotation acts as an acqurie+release anontation pair with hardirqoff
> + * being 1. Since there's no critical section, no interrupt can create extra
> + * dependencies "inside" the annotation, hardirqoff == 1 allows us to avoid
> + * false positives.
> + */
> +void lock_sync(struct lockdep_map *lock, unsigned subclass, int read,
> +	       int check, struct lockdep_map *nest_lock, unsigned long ip)
> +{
> +	unsigned long flags;
> +
> +	if (unlikely(!lockdep_enabled()))
> +		return;
> +
> +	raw_local_irq_save(flags);
> +	check_flags(flags);
> +
> +	lockdep_recursion_inc();
> +	__lock_acquire(lock, subclass, 0, read, check, 1, nest_lock, ip, 0, 0);
> +
> +	if (__lock_release(lock, ip))
> +		check_chain_key(current);
> +	lockdep_recursion_finish();
> +	raw_local_irq_restore(flags);
> +}
> +EXPORT_SYMBOL_GPL(lock_sync);
> +
>   noinstr int lock_is_held_type(const struct lockdep_map *lock, int read)
>   {
>   	unsigned long flags;

This patch looks good to me.

Acked-by: Waiman Long <longman@redhat.com>

