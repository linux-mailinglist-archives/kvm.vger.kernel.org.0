Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA1AD6695C9
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 12:39:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233010AbjAMLji (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 06:39:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241315AbjAMLir (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 06:38:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA09C321B2;
        Fri, 13 Jan 2023 03:29:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6FBB26131A;
        Fri, 13 Jan 2023 11:29:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1957C433EF;
        Fri, 13 Jan 2023 11:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673609389;
        bh=RcLypPTjpodGDxdLIzQTSCt6609W3IisxU9W/b2ABSw=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=X8EcHbsIdqTagdHrvxdglLJiqcl4iiiBGsG9Bl8Wb8ZBMPTj/R3tFCBmN7eOtQlva
         kAB6RUS6hOVLo3ab9Db6DZkZNhXysf0WzZ8c75Bs964iE5gURMg5OeL7y+/lDbWlmm
         sBbwn8QY4EwN+MTE9Qp++jE/0oOsODGowuXY2QdvySqzH9SoyPwVXR3YKNvWKrD59v
         JqA52+hYaiX7ykHcqEV6UK5jn0szqpwiXAne/zW39FMWCsebL4K1GHc7x9iNJLmYso
         ii0q0kwiCvCFVVg4RJt2iJa2Dsgu26AlkRb+RMGXCp5OXfP3AsKquGwhVkEdtPmcIM
         VN1m6+12qjuCg==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 73D9A5C1C8C; Fri, 13 Jan 2023 03:29:49 -0800 (PST)
Date:   Fri, 13 Jan 2023 03:29:49 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Boqun Feng <boqun.feng@gmail.com>
Cc:     linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
        kvm@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>, seanjc@google.com,
        Joel Fernandes <joel@joelfernandes.org>,
        Matthew Wilcox <willy@infradead.org>,
        Michal Luczaj <mhal@rbox.co>
Subject: Re: [PATCH 2/3] rcu: Equip sleepable RCU with lockdep dependency
 graph checks
Message-ID: <20230113112949.GX4028633@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20230113065955.815667-1-boqun.feng@gmail.com>
 <20230113065955.815667-3-boqun.feng@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230113065955.815667-3-boqun.feng@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 12, 2023 at 10:59:54PM -0800, Boqun Feng wrote:
> Although all flavors of RCU are annotated correctly with lockdep as
> recursive read locks, their 'check' parameter of lock_acquire() is
> unset. It means that RCU read locks are not added into the lockdep
> dependency graph therefore deadlock detection based on dependency graph
> won't catch deadlock caused by RCU. This is fine for "non-sleepable" RCU
> flavors since wait-context detection and other context based detection
> can catch these deadlocks. However for sleepable RCU, this is limited.
> 
> Actually we can detect the deadlocks caused by SRCU by 1) making
> srcu_read_lock() a 'check'ed recursive read lock and 2) making
> synchronize_srcu() a empty write lock critical section. Even better,
> with the newly introduced lock_sync(), we can avoid false positives
> about irq-unsafe/safe. So do it.
> 
> Note that NMI safe SRCU read side critical sections are currently not
> annonated, since step-by-step approach can help us deal with
> false-positives. These may be annotated in the future.
> 
> Signed-off-by: Boqun Feng <boqun.feng@gmail.com>

Nice, thank you!!!

Acked-by: Paul E. McKenney <paulmck@kernel.org>

Or if you would prefer that I take the series through -rcu, please just
let me know.

							Thanx, Paul

> ---
>  include/linux/srcu.h  | 23 +++++++++++++++++++++--
>  kernel/rcu/srcutiny.c |  2 ++
>  kernel/rcu/srcutree.c |  2 ++
>  3 files changed, 25 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/srcu.h b/include/linux/srcu.h
> index 9b9d0bbf1d3c..a1595f8c5155 100644
> --- a/include/linux/srcu.h
> +++ b/include/linux/srcu.h
> @@ -102,6 +102,21 @@ static inline int srcu_read_lock_held(const struct srcu_struct *ssp)
>  	return lock_is_held(&ssp->dep_map);
>  }
>  
> +static inline void srcu_lock_acquire(struct lockdep_map *map)
> +{
> +	lock_map_acquire_read(map);
> +}
> +
> +static inline void srcu_lock_release(struct lockdep_map *map)
> +{
> +	lock_map_release(map);
> +}
> +
> +static inline void srcu_lock_sync(struct lockdep_map *map)
> +{
> +	lock_map_sync(map);
> +}
> +
>  #else /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
>  
>  static inline int srcu_read_lock_held(const struct srcu_struct *ssp)
> @@ -109,6 +124,10 @@ static inline int srcu_read_lock_held(const struct srcu_struct *ssp)
>  	return 1;
>  }
>  
> +#define srcu_lock_acquire(m) do { } while (0)
> +#define srcu_lock_release(m) do { } while (0)
> +#define srcu_lock_sync(m) do { } while (0)
> +
>  #endif /* #else #ifdef CONFIG_DEBUG_LOCK_ALLOC */
>  
>  #define SRCU_NMI_UNKNOWN	0x0
> @@ -182,7 +201,7 @@ static inline int srcu_read_lock(struct srcu_struct *ssp) __acquires(ssp)
>  
>  	srcu_check_nmi_safety(ssp, false);
>  	retval = __srcu_read_lock(ssp);
> -	rcu_lock_acquire(&(ssp)->dep_map);
> +	srcu_lock_acquire(&(ssp)->dep_map);
>  	return retval;
>  }
>  
> @@ -226,7 +245,7 @@ static inline void srcu_read_unlock(struct srcu_struct *ssp, int idx)
>  {
>  	WARN_ON_ONCE(idx & ~0x1);
>  	srcu_check_nmi_safety(ssp, false);
> -	rcu_lock_release(&(ssp)->dep_map);
> +	srcu_lock_release(&(ssp)->dep_map);
>  	__srcu_read_unlock(ssp, idx);
>  }
>  
> diff --git a/kernel/rcu/srcutiny.c b/kernel/rcu/srcutiny.c
> index b12fb0cec44d..336af24e0fe3 100644
> --- a/kernel/rcu/srcutiny.c
> +++ b/kernel/rcu/srcutiny.c
> @@ -197,6 +197,8 @@ void synchronize_srcu(struct srcu_struct *ssp)
>  {
>  	struct rcu_synchronize rs;
>  
> +	srcu_lock_sync(&ssp->dep_map);
> +
>  	RCU_LOCKDEP_WARN(lockdep_is_held(ssp) ||
>  			lock_is_held(&rcu_bh_lock_map) ||
>  			lock_is_held(&rcu_lock_map) ||
> diff --git a/kernel/rcu/srcutree.c b/kernel/rcu/srcutree.c
> index ca4b5dcec675..408088c73e0e 100644
> --- a/kernel/rcu/srcutree.c
> +++ b/kernel/rcu/srcutree.c
> @@ -1267,6 +1267,8 @@ static void __synchronize_srcu(struct srcu_struct *ssp, bool do_norm)
>  {
>  	struct rcu_synchronize rcu;
>  
> +	srcu_lock_sync(&ssp->dep_map);
> +
>  	RCU_LOCKDEP_WARN(lockdep_is_held(ssp) ||
>  			 lock_is_held(&rcu_bh_lock_map) ||
>  			 lock_is_held(&rcu_lock_map) ||
> -- 
> 2.38.1
> 
