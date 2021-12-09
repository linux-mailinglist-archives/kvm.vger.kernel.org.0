Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F84046F178
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 18:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242685AbhLIRWO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 12:22:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242866AbhLIRWN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 12:22:13 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B417C061746;
        Thu,  9 Dec 2021 09:18:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6330DCE276D;
        Thu,  9 Dec 2021 17:18:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89E00C004DD;
        Thu,  9 Dec 2021 17:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639070315;
        bh=6T+elCby+cclVVOmwvR5v3IA3Q/+iZs9ml9nncRr+Gk=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=JRwkKn3KtZe/S+dT1F9q9QZ+EjZmQEDOUNwxorwKSPkxCmAVpl463VX5Z081g9ImN
         xOi92St25HtZa9ZraU4JPQwVTSlwWLq4WhM2c8kifrXR83v0dbk2333OJBCAp4vYl7
         b36wAVBBm5EmVUSIEQtCFLVvxLZpYwEkLZL673isolCsn6wLErCl443KEKpqUOTDmC
         u73UHkAZFVO6CaOsWhC5OVcMZA3hwVEyNItSXS/+YOqgCozO+uDgBLJdmrYfo83HZo
         h/mUL0yjq+/i4lU/fBLa6U2jkkAMgzGbx+2ZXe0P0u4Dj9TmTll59+IM21VQ3FPu38
         8oy3zzPy7InHg==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 4CFB75C414D; Thu,  9 Dec 2021 09:18:35 -0800 (PST)
Date:   Thu, 9 Dec 2021 09:18:35 -0800
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
Subject: Re: [PATCH 02/11] rcu: Kill rnp->ofl_seq and use only
 rcu_state.ofl_lock for exclusion
Message-ID: <20211209171835.GD641268@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20211209150938.3518-1-dwmw2@infradead.org>
 <20211209150938.3518-3-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211209150938.3518-3-dwmw2@infradead.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 09, 2021 at 03:09:29PM +0000, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> If we allow architectures to bring APs online in parallel, then we end
> up requiring rcu_cpu_starting() to be reentrant. But currently, the
> manipulation of rnp->ofl_seq is not thread-safe.
> 
> However, rnp->ofl_seq is also fairly much pointless anyway since both
> rcu_cpu_starting() and rcu_report_dead() hold rcu_state.ofl_lock for
> fairly much the whole time that rnp->ofl_seq is set to an odd number
> to indicate that an operation is in progress.
> 
> So drop rnp->ofl_seq completely, and use only rcu_state.ofl_lock.
> 
> This has a couple of minor complexities: lockdep will complain when we
> take rcu_state.ofl_lock, and currently accepts the 'excuse' of having
> an odd value in rnp->ofl_seq. So switch it to an arch_spinlock_t to
> avoid that false positive complaint. Since we're killing rnp->ofl_seq
> of course that 'excuse' has to be changed too, so make it check for
> arch_spin_is_locked(rcu_state.ofl_lock).
> 
> There's no arch_spin_lock_irqsave() so we have to manually save and
> restore local interrupts around the locking.
> 
> At Paul's request, make rcu_gp_init not just wait but *exclude* any
> CPU online/offline activity, which was fairly much true already by
> virtue of it holding rcu_state.ofl_lock.

Looks good!

Could you please also make the first clause read something like this?

	"At Paul's request based on Neeraj's analysis, ..."

I am going to pull this into -rcu for more intensive testing of this
code for non-concurrent CPU-online operations (making the above change
to the commit log).  At some point, rcutorture needs to learn how to
do concurrent CPU-online operations, but it would be good to bake the
RCU-specific patches for a bit beforehand.

Depending on timing, you might wish to send this patch with the
rest of this group, so:

Acked-by: Paul E. McKenney <paulmck@kernel.org>

If testing goes well and if you don't get it there first, I expect
to push this during the v5.18 merge window.

							Thanx, Paul

> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>  kernel/rcu/tree.c | 64 +++++++++++++++++++++++------------------------
>  kernel/rcu/tree.h |  4 +--
>  2 files changed, 32 insertions(+), 36 deletions(-)
> 
> diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> index ef8d36f580fc..a1bb0b1229ed 100644
> --- a/kernel/rcu/tree.c
> +++ b/kernel/rcu/tree.c
> @@ -91,7 +91,7 @@ static struct rcu_state rcu_state = {
>  	.abbr = RCU_ABBR,
>  	.exp_mutex = __MUTEX_INITIALIZER(rcu_state.exp_mutex),
>  	.exp_wake_mutex = __MUTEX_INITIALIZER(rcu_state.exp_wake_mutex),
> -	.ofl_lock = __RAW_SPIN_LOCK_UNLOCKED(rcu_state.ofl_lock),
> +	.ofl_lock = __ARCH_SPIN_LOCK_UNLOCKED,
>  };
>  
>  /* Dump rcu_node combining tree at boot to verify correct setup. */
> @@ -1168,7 +1168,15 @@ bool rcu_lockdep_current_cpu_online(void)
>  	preempt_disable_notrace();
>  	rdp = this_cpu_ptr(&rcu_data);
>  	rnp = rdp->mynode;
> -	if (rdp->grpmask & rcu_rnp_online_cpus(rnp) || READ_ONCE(rnp->ofl_seq) & 0x1)
> +	/*
> +	 * Strictly, we care here about the case where the current CPU is
> +	 * in rcu_cpu_starting() and thus has an excuse for rdp->grpmask
> +	 * not being up to date. So arch_spin_is_locked() might have a
> +	 * false positive if it's held by some *other* CPU, but that's
> +	 * OK because that just means a false *negative* on the warning.
> +	 */
> +	if (rdp->grpmask & rcu_rnp_online_cpus(rnp) ||
> +	    arch_spin_is_locked(&rcu_state.ofl_lock))
>  		ret = true;
>  	preempt_enable_notrace();
>  	return ret;
> @@ -1731,7 +1739,6 @@ static void rcu_strict_gp_boundary(void *unused)
>   */
>  static noinline_for_stack bool rcu_gp_init(void)
>  {
> -	unsigned long firstseq;
>  	unsigned long flags;
>  	unsigned long oldmask;
>  	unsigned long mask;
> @@ -1774,22 +1781,17 @@ static noinline_for_stack bool rcu_gp_init(void)
>  	 * of RCU's Requirements documentation.
>  	 */
>  	WRITE_ONCE(rcu_state.gp_state, RCU_GP_ONOFF);
> +	/* Exclude CPU hotplug operations. */
>  	rcu_for_each_leaf_node(rnp) {
> -		// Wait for CPU-hotplug operations that might have
> -		// started before this grace period did.
> -		smp_mb(); // Pair with barriers used when updating ->ofl_seq to odd values.
> -		firstseq = READ_ONCE(rnp->ofl_seq);
> -		if (firstseq & 0x1)
> -			while (firstseq == READ_ONCE(rnp->ofl_seq))
> -				schedule_timeout_idle(1);  // Can't wake unless RCU is watching.
> -		smp_mb(); // Pair with barriers used when updating ->ofl_seq to even values.
> -		raw_spin_lock(&rcu_state.ofl_lock);
> -		raw_spin_lock_irq_rcu_node(rnp);
> +		local_irq_save(flags);
> +		arch_spin_lock(&rcu_state.ofl_lock);
> +		raw_spin_lock_rcu_node(rnp);
>  		if (rnp->qsmaskinit == rnp->qsmaskinitnext &&
>  		    !rnp->wait_blkd_tasks) {
>  			/* Nothing to do on this leaf rcu_node structure. */
> -			raw_spin_unlock_irq_rcu_node(rnp);
> -			raw_spin_unlock(&rcu_state.ofl_lock);
> +			raw_spin_unlock_rcu_node(rnp);
> +			arch_spin_unlock(&rcu_state.ofl_lock);
> +			local_irq_restore(flags);
>  			continue;
>  		}
>  
> @@ -1824,8 +1826,9 @@ static noinline_for_stack bool rcu_gp_init(void)
>  				rcu_cleanup_dead_rnp(rnp);
>  		}
>  
> -		raw_spin_unlock_irq_rcu_node(rnp);
> -		raw_spin_unlock(&rcu_state.ofl_lock);
> +		raw_spin_unlock_rcu_node(rnp);
> +		arch_spin_unlock(&rcu_state.ofl_lock);
> +		local_irq_restore(flags);
>  	}
>  	rcu_gp_slow(gp_preinit_delay); /* Races with CPU hotplug. */
>  
> @@ -4233,7 +4236,7 @@ int rcutree_offline_cpu(unsigned int cpu)
>   */
>  void rcu_cpu_starting(unsigned int cpu)
>  {
> -	unsigned long flags;
> +	unsigned long flags, seq_flags;
>  	unsigned long mask;
>  	struct rcu_data *rdp;
>  	struct rcu_node *rnp;
> @@ -4246,11 +4249,11 @@ void rcu_cpu_starting(unsigned int cpu)
>  
>  	rnp = rdp->mynode;
>  	mask = rdp->grpmask;
> -	WRITE_ONCE(rnp->ofl_seq, rnp->ofl_seq + 1);
> -	WARN_ON_ONCE(!(rnp->ofl_seq & 0x1));
> +	local_irq_save(seq_flags);
> +	arch_spin_lock(&rcu_state.ofl_lock);
>  	rcu_dynticks_eqs_online();
>  	smp_mb(); // Pair with rcu_gp_cleanup()'s ->ofl_seq barrier().
> -	raw_spin_lock_irqsave_rcu_node(rnp, flags);
> +	raw_spin_lock_rcu_node(rnp);
>  	WRITE_ONCE(rnp->qsmaskinitnext, rnp->qsmaskinitnext | mask);
>  	newcpu = !(rnp->expmaskinitnext & mask);
>  	rnp->expmaskinitnext |= mask;
> @@ -4269,9 +4272,8 @@ void rcu_cpu_starting(unsigned int cpu)
>  	} else {
>  		raw_spin_unlock_irqrestore_rcu_node(rnp, flags);
>  	}
> -	smp_mb(); // Pair with rcu_gp_cleanup()'s ->ofl_seq barrier().
> -	WRITE_ONCE(rnp->ofl_seq, rnp->ofl_seq + 1);
> -	WARN_ON_ONCE(rnp->ofl_seq & 0x1);
> +	arch_spin_unlock(&rcu_state.ofl_lock);
> +	local_irq_restore(seq_flags);
>  	smp_mb(); /* Ensure RCU read-side usage follows above initialization. */
>  }
>  
> @@ -4285,7 +4287,7 @@ void rcu_cpu_starting(unsigned int cpu)
>   */
>  void rcu_report_dead(unsigned int cpu)
>  {
> -	unsigned long flags;
> +	unsigned long flags, seq_flags;
>  	unsigned long mask;
>  	struct rcu_data *rdp = per_cpu_ptr(&rcu_data, cpu);
>  	struct rcu_node *rnp = rdp->mynode;  /* Outgoing CPU's rdp & rnp. */
> @@ -4299,10 +4301,8 @@ void rcu_report_dead(unsigned int cpu)
>  
>  	/* Remove outgoing CPU from mask in the leaf rcu_node structure. */
>  	mask = rdp->grpmask;
> -	WRITE_ONCE(rnp->ofl_seq, rnp->ofl_seq + 1);
> -	WARN_ON_ONCE(!(rnp->ofl_seq & 0x1));
> -	smp_mb(); // Pair with rcu_gp_cleanup()'s ->ofl_seq barrier().
> -	raw_spin_lock(&rcu_state.ofl_lock);
> +	local_irq_save(seq_flags);
> +	arch_spin_lock(&rcu_state.ofl_lock);
>  	raw_spin_lock_irqsave_rcu_node(rnp, flags); /* Enforce GP memory-order guarantee. */
>  	rdp->rcu_ofl_gp_seq = READ_ONCE(rcu_state.gp_seq);
>  	rdp->rcu_ofl_gp_flags = READ_ONCE(rcu_state.gp_flags);
> @@ -4313,10 +4313,8 @@ void rcu_report_dead(unsigned int cpu)
>  	}
>  	WRITE_ONCE(rnp->qsmaskinitnext, rnp->qsmaskinitnext & ~mask);
>  	raw_spin_unlock_irqrestore_rcu_node(rnp, flags);
> -	raw_spin_unlock(&rcu_state.ofl_lock);
> -	smp_mb(); // Pair with rcu_gp_cleanup()'s ->ofl_seq barrier().
> -	WRITE_ONCE(rnp->ofl_seq, rnp->ofl_seq + 1);
> -	WARN_ON_ONCE(rnp->ofl_seq & 0x1);
> +	arch_spin_unlock(&rcu_state.ofl_lock);
> +	local_irq_restore(seq_flags);
>  
>  	rdp->cpu_started = false;
>  }
> diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
> index 305cf6aeb408..aff4cc9303fb 100644
> --- a/kernel/rcu/tree.h
> +++ b/kernel/rcu/tree.h
> @@ -56,8 +56,6 @@ struct rcu_node {
>  				/*  Initialized from ->qsmaskinitnext at the */
>  				/*  beginning of each grace period. */
>  	unsigned long qsmaskinitnext;
> -	unsigned long ofl_seq;	/* CPU-hotplug operation sequence count. */
> -				/* Online CPUs for next grace period. */
>  	unsigned long expmask;	/* CPUs or groups that need to check in */
>  				/*  to allow the current expedited GP */
>  				/*  to complete. */
> @@ -358,7 +356,7 @@ struct rcu_state {
>  	const char *name;			/* Name of structure. */
>  	char abbr;				/* Abbreviated name. */
>  
> -	raw_spinlock_t ofl_lock ____cacheline_internodealigned_in_smp;
> +	arch_spinlock_t ofl_lock ____cacheline_internodealigned_in_smp;
>  						/* Synchronize offline with */
>  						/*  GP pre-initialization. */
>  };
> -- 
> 2.31.1
> 
