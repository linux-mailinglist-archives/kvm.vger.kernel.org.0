Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C39F646F17E
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 18:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242704AbhLIRYB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 12:24:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235879AbhLIRYA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 12:24:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A31E9C061746;
        Thu,  9 Dec 2021 09:20:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 592DCB825CB;
        Thu,  9 Dec 2021 17:20:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E648C004DD;
        Thu,  9 Dec 2021 17:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639070424;
        bh=dneNXQvoqpcTtOygF9rQY2ezYBD+tcFoer9GUop9wPs=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=FZWudXJL7H307kRFKHi2ZtVG64kRgcRdFX4h6ekrnwYO1WcEWwc+pOxFagRMRUk8V
         h/ij0UwGEfOUJ8ekKJUisbrLnb9PpPvTtvFzQijhnGjg7XhAyJqpZiyaTQ7Z/duohF
         hGj0fFwSlBj7zCsrmeQJBYTqrBfpFL/idY1dbF+c7dp5rW8+/BfgcJujQxTDeaUrDy
         5Vcx7nKle23uq+0D8Xxx31WqdEJ+ccGk0PkrqCt1x9oLYw/yGo0y9o2V8Q9ha+tdAy
         F+OXG/zXqapmAPujkvZrU77koGsNolwqlkWaKXdJDiL3slzQ+ragSSqodY/jlxMuQp
         oYCU/Fc/y6yuQ==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id E2ABB5C414D; Thu,  9 Dec 2021 09:20:23 -0800 (PST)
Date:   Thu, 9 Dec 2021 09:20:23 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        hushiyuan@huawei.com, luolongjun@huawei.com, hejingxian@huawei.com
Subject: Re: [PATCH 03/11] rcu: Add mutex for rcu boost kthread spawning and
 affinity setting
Message-ID: <20211209172023.GE641268@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20211209150938.3518-1-dwmw2@infradead.org>
 <20211209150938.3518-4-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211209150938.3518-4-dwmw2@infradead.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 09, 2021 at 03:09:30PM +0000, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> As we handle parallel CPU bringup, we will need to take care to avoid
> spawning multiple boost threads, or race conditions when setting their
> affinity. Spotted by Paul McKenney.

And again, if testing goes well and you don't get it there first, I
expect to push this during the v5.18 merge window.  In case you
would like to push this with the rest of this series:

Acked-by: Paul E. McKenney <paulmck@kernel.org>

> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>  kernel/rcu/tree.c        |  1 +
>  kernel/rcu/tree.h        |  3 +++
>  kernel/rcu/tree_plugin.h | 10 ++++++++--
>  3 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> index a1bb0b1229ed..809855474b39 100644
> --- a/kernel/rcu/tree.c
> +++ b/kernel/rcu/tree.c
> @@ -4527,6 +4527,7 @@ static void __init rcu_init_one(void)
>  			init_waitqueue_head(&rnp->exp_wq[2]);
>  			init_waitqueue_head(&rnp->exp_wq[3]);
>  			spin_lock_init(&rnp->exp_lock);
> +			mutex_init(&rnp->boost_kthread_mutex);
>  		}
>  	}
>  
> diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
> index aff4cc9303fb..055e30b3e5e0 100644
> --- a/kernel/rcu/tree.h
> +++ b/kernel/rcu/tree.h
> @@ -108,6 +108,9 @@ struct rcu_node {
>  				/*  side effect, not as a lock. */
>  	unsigned long boost_time;
>  				/* When to start boosting (jiffies). */
> +	struct mutex boost_kthread_mutex;
> +				/* Exclusion for thread spawning and affinity */
> +				/*  manipulation. */
>  	struct task_struct *boost_kthread_task;
>  				/* kthread that takes care of priority */
>  				/*  boosting for this rcu_node structure. */
> diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> index 5199559fbbf0..3b4ee0933710 100644
> --- a/kernel/rcu/tree_plugin.h
> +++ b/kernel/rcu/tree_plugin.h
> @@ -1162,15 +1162,16 @@ static void rcu_spawn_one_boost_kthread(struct rcu_node *rnp)
>  	struct sched_param sp;
>  	struct task_struct *t;
>  
> +	mutex_lock(&rnp->boost_kthread_mutex);
>  	if (rnp->boost_kthread_task || !rcu_scheduler_fully_active)
> -		return;
> +		goto out;
>  
>  	rcu_state.boost = 1;
>  
>  	t = kthread_create(rcu_boost_kthread, (void *)rnp,
>  			   "rcub/%d", rnp_index);
>  	if (WARN_ON_ONCE(IS_ERR(t)))
> -		return;
> +		goto out;
>  
>  	raw_spin_lock_irqsave_rcu_node(rnp, flags);
>  	rnp->boost_kthread_task = t;
> @@ -1178,6 +1179,9 @@ static void rcu_spawn_one_boost_kthread(struct rcu_node *rnp)
>  	sp.sched_priority = kthread_prio;
>  	sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
>  	wake_up_process(t); /* get to TASK_INTERRUPTIBLE quickly. */
> +
> + out:
> +	mutex_unlock(&rnp->boost_kthread_mutex);
>  }
>  
>  /*
> @@ -1200,6 +1204,7 @@ static void rcu_boost_kthread_setaffinity(struct rcu_node *rnp, int outgoingcpu)
>  		return;
>  	if (!zalloc_cpumask_var(&cm, GFP_KERNEL))
>  		return;
> +	mutex_lock(&rnp->boost_kthread_mutex);
>  	for_each_leaf_node_possible_cpu(rnp, cpu)
>  		if ((mask & leaf_node_cpu_bit(rnp, cpu)) &&
>  		    cpu != outgoingcpu)
> @@ -1207,6 +1212,7 @@ static void rcu_boost_kthread_setaffinity(struct rcu_node *rnp, int outgoingcpu)
>  	if (cpumask_weight(cm) == 0)
>  		cpumask_setall(cm);
>  	set_cpus_allowed_ptr(t, cm);
> +	mutex_unlock(&rnp->boost_kthread_mutex);
>  	free_cpumask_var(cm);
>  }
>  
> -- 
> 2.31.1
> 
