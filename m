Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEF8646F9D5
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 05:26:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234318AbhLJEaZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 23:30:25 -0500
Received: from alexa-out-sd-02.qualcomm.com ([199.106.114.39]:28890 "EHLO
        alexa-out-sd-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231805AbhLJEaY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Dec 2021 23:30:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1639110410; x=1670646410;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=g8Uqg5l40Sk/Jnd6qrQl6K9TwkNkMVjfkkyCjBuSqqU=;
  b=b/x5tX6w2HZooMx8Q2+1kwjtQCTl2D0WMZnURKjmef8/HRraEOknBNtc
   O15R/qS8to/yrtvTSV7OjxfumssMqv0Ba5Hh4yqF6xACuVKM14Azcd+Qf
   LY4dTzYTBh4/QTP6Ggex9CIxiEjieTAeEon27zK542jEoxAwn9pKJt+bV
   E=;
Received: from unknown (HELO ironmsg03-sd.qualcomm.com) ([10.53.140.143])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 09 Dec 2021 20:26:50 -0800
X-QCInternal: smtphost
Received: from nasanex01b.na.qualcomm.com ([10.46.141.250])
  by ironmsg03-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2021 20:26:50 -0800
Received: from [10.216.12.12] (10.80.80.8) by nasanex01b.na.qualcomm.com
 (10.46.141.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.922.19; Thu, 9 Dec 2021
 20:26:42 -0800
Message-ID: <b7f2bb55-4f0e-f52d-d41c-b591aa3927f2@quicinc.com>
Date:   Fri, 10 Dec 2021 09:56:38 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v1.1 02/11] rcu: Kill rnp->ofl_seq and use only
 rcu_state.ofl_lock for exclusion
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
CC:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <rcu@vger.kernel.org>, <mimoja@mimoja.de>,
        <hewenliang4@huawei.com>, <hushiyuan@huawei.com>,
        <luolongjun@huawei.com>, <hejingxian@huawei.com>
References: <20211209150938.3518-1-dwmw2@infradead.org>
 <20211209150938.3518-3-dwmw2@infradead.org>
 <dfa110f0-8fd0-0f37-2c37-89eccac1ad08@quicinc.com>
 <5b086c9e5a92bb91e6f4c086e6d01e380a7491af.camel@infradead.org>
From:   Neeraj Upadhyay <quic_neeraju@quicinc.com>
In-Reply-To: <5b086c9e5a92bb91e6f4c086e6d01e380a7491af.camel@infradead.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi David,

Few minor comments

On 12/10/2021 12:51 AM, David Woodhouse wrote:
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
> At Paul's request based on Neeraj's analysis, make rcu_gp_init not just
> wait but *exclude* any CPU online/offline activity, which was fairly
> much true already by virtue of it holding rcu_state.ofl_lock.
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
> If we're going to split the series up and let the various patches take
> their own paths to Linus, I'll just repost this one alone as 'v1.1'.
> 
>   kernel/rcu/tree.c | 71 ++++++++++++++++++++++++-----------------------
>   kernel/rcu/tree.h |  4 +--
>   2 files changed, 37 insertions(+), 38 deletions(-)
> 
> diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> index ef8d36f580fc..2e1ae611be98 100644
> --- a/kernel/rcu/tree.c
> +++ b/kernel/rcu/tree.c
> @@ -91,7 +91,7 @@ static struct rcu_state rcu_state = {
>   	.abbr = RCU_ABBR,
>   	.exp_mutex = __MUTEX_INITIALIZER(rcu_state.exp_mutex),
>   	.exp_wake_mutex = __MUTEX_INITIALIZER(rcu_state.exp_wake_mutex),
> -	.ofl_lock = __RAW_SPIN_LOCK_UNLOCKED(rcu_state.ofl_lock),
> +	.ofl_lock = __ARCH_SPIN_LOCK_UNLOCKED,
>   };
>   
>   /* Dump rcu_node combining tree at boot to verify correct setup. */
> @@ -1168,7 +1168,15 @@ bool rcu_lockdep_current_cpu_online(void)
>   	preempt_disable_notrace();
>   	rdp = this_cpu_ptr(&rcu_data);
>   	rnp = rdp->mynode;
> -	if (rdp->grpmask & rcu_rnp_online_cpus(rnp) || READ_ONCE(rnp->ofl_seq) & 0x1)
> +	/*
> +	 * Strictly, we care here about the case where the current CPU is
> +	 * in rcu_cpu_starting() and thus has an excuse for rdp->grpmask
> +	 * not being up to date. So arch_spin_is_locked() might have a

Minor:

Is this comment right - "thus has an excuse for rdp->grpmask not being 
up to date"; shouldn't it be "thus has an excuse for rnp->qsmaskinitnext 
not being up to date"?

Also, arch_spin_is_locked() also handles the rcu_report_dead() case,
where raw_spin_unlock_irqrestore_rcu_node() can have a rcu_read_lock 
from lockdep path with CPU bits already cleared from rnp->qsmaskinitnext?



> +	 * false positive if it's held by some *other* CPU, but that's
> +	 * OK because that just means a false *negative* on the warning.
> +	 */
> +	if (rdp->grpmask & rcu_rnp_online_cpus(rnp) ||
> +	    arch_spin_is_locked(&rcu_state.ofl_lock))
>   		ret = true;
>   	preempt_enable_notrace();
>   	return ret;
> @@ -1731,7 +1739,6 @@ static void rcu_strict_gp_boundary(void *unused)
>    */
>   static noinline_for_stack bool rcu_gp_init(void)
>   {
> -	unsigned long firstseq;
>   	unsigned long flags;
>   	unsigned long oldmask;
>   	unsigned long mask;
> @@ -1774,22 +1781,17 @@ static noinline_for_stack bool rcu_gp_init(void)
>   	 * of RCU's Requirements documentation.
>   	 */
>   	WRITE_ONCE(rcu_state.gp_state, RCU_GP_ONOFF);
> +	/* Exclude CPU hotplug operations. */
>   	rcu_for_each_leaf_node(rnp) {
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
>   		if (rnp->qsmaskinit == rnp->qsmaskinitnext &&
>   		    !rnp->wait_blkd_tasks) {
>   			/* Nothing to do on this leaf rcu_node structure. */
> -			raw_spin_unlock_irq_rcu_node(rnp);
> -			raw_spin_unlock(&rcu_state.ofl_lock);
> +			raw_spin_unlock_rcu_node(rnp);
> +			arch_spin_unlock(&rcu_state.ofl_lock);
> +			local_irq_restore(flags);
>   			continue;
>   		}
>   
> @@ -1824,8 +1826,9 @@ static noinline_for_stack bool rcu_gp_init(void)
>   				rcu_cleanup_dead_rnp(rnp);
>   		}
>   
> -		raw_spin_unlock_irq_rcu_node(rnp);
> -		raw_spin_unlock(&rcu_state.ofl_lock);
> +		raw_spin_unlock_rcu_node(rnp);
> +		arch_spin_unlock(&rcu_state.ofl_lock);
> +		local_irq_restore(flags);
>   	}
>   	rcu_gp_slow(gp_preinit_delay); /* Races with CPU hotplug. */
>   
> @@ -4246,11 +4249,10 @@ void rcu_cpu_starting(unsigned int cpu)
>   
>   	rnp = rdp->mynode;
>   	mask = rdp->grpmask;
> -	WRITE_ONCE(rnp->ofl_seq, rnp->ofl_seq + 1);
> -	WARN_ON_ONCE(!(rnp->ofl_seq & 0x1));
> +	local_irq_save(flags);
> +	arch_spin_lock(&rcu_state.ofl_lock);
>   	rcu_dynticks_eqs_online();
> -	smp_mb(); // Pair with rcu_gp_cleanup()'s ->ofl_seq barrier().
> -	raw_spin_lock_irqsave_rcu_node(rnp, flags);
> +	raw_spin_lock_rcu_node(rnp);
>   	WRITE_ONCE(rnp->qsmaskinitnext, rnp->qsmaskinitnext | mask);
>   	newcpu = !(rnp->expmaskinitnext & mask);
>   	rnp->expmaskinitnext |= mask;
> @@ -4263,15 +4265,18 @@ void rcu_cpu_starting(unsigned int cpu)
>   
>   	/* An incoming CPU should never be blocking a grace period. */
>   	if (WARN_ON_ONCE(rnp->qsmask & mask)) { /* RCU waiting on incoming CPU? */
> +		/* rcu_report_qs_rnp() *really* wants some flags to restore */
> +		unsigned long flags2;

Minor: checkpatch flags it "Missing a blank line after declarations"



Thanks
Neeraj

> +		local_irq_save(flags2);
> +
>   		rcu_disable_urgency_upon_qs(rdp);
>   		/* Report QS -after- changing ->qsmaskinitnext! */
> -		rcu_report_qs_rnp(mask, rnp, rnp->gp_seq, flags);
> +		rcu_report_qs_rnp(mask, rnp, rnp->gp_seq, flags2);
>   	} else {
> -		raw_spin_unlock_irqrestore_rcu_node(rnp, flags);
> +		raw_spin_unlock_rcu_node(rnp);
>   	}
> -	smp_mb(); // Pair with rcu_gp_cleanup()'s ->ofl_seq barrier().
> -	WRITE_ONCE(rnp->ofl_seq, rnp->ofl_seq + 1);
> -	WARN_ON_ONCE(rnp->ofl_seq & 0x1);
> +	arch_spin_unlock(&rcu_state.ofl_lock);
> +	local_irq_restore(flags);
>   	smp_mb(); /* Ensure RCU read-side usage follows above initialization. */
>   }
>   
> @@ -4285,7 +4290,7 @@ void rcu_cpu_starting(unsigned int cpu)
>    */
>   void rcu_report_dead(unsigned int cpu)
>   {
> -	unsigned long flags;
> +	unsigned long flags, seq_flags;
>   	unsigned long mask;
>   	struct rcu_data *rdp = per_cpu_ptr(&rcu_data, cpu);
>   	struct rcu_node *rnp = rdp->mynode;  /* Outgoing CPU's rdp & rnp. */
> @@ -4299,10 +4304,8 @@ void rcu_report_dead(unsigned int cpu)
>   
>   	/* Remove outgoing CPU from mask in the leaf rcu_node structure. */
>   	mask = rdp->grpmask;
> -	WRITE_ONCE(rnp->ofl_seq, rnp->ofl_seq + 1);
> -	WARN_ON_ONCE(!(rnp->ofl_seq & 0x1));
> -	smp_mb(); // Pair with rcu_gp_cleanup()'s ->ofl_seq barrier().
> -	raw_spin_lock(&rcu_state.ofl_lock);
> +	local_irq_save(seq_flags);
> +	arch_spin_lock(&rcu_state.ofl_lock);
>   	raw_spin_lock_irqsave_rcu_node(rnp, flags); /* Enforce GP memory-order guarantee. */
>   	rdp->rcu_ofl_gp_seq = READ_ONCE(rcu_state.gp_seq);
>   	rdp->rcu_ofl_gp_flags = READ_ONCE(rcu_state.gp_flags);
> @@ -4313,10 +4316,8 @@ void rcu_report_dead(unsigned int cpu)
>   	}
>   	WRITE_ONCE(rnp->qsmaskinitnext, rnp->qsmaskinitnext & ~mask);
>   	raw_spin_unlock_irqrestore_rcu_node(rnp, flags);
> -	raw_spin_unlock(&rcu_state.ofl_lock);
> -	smp_mb(); // Pair with rcu_gp_cleanup()'s ->ofl_seq barrier().
> -	WRITE_ONCE(rnp->ofl_seq, rnp->ofl_seq + 1);
> -	WARN_ON_ONCE(rnp->ofl_seq & 0x1);
> +	arch_spin_unlock(&rcu_state.ofl_lock);
> +	local_irq_restore(seq_flags);
>   
>   	rdp->cpu_started = false;
>   }
> diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
> index 305cf6aeb408..aff4cc9303fb 100644
> --- a/kernel/rcu/tree.h
> +++ b/kernel/rcu/tree.h
> @@ -56,8 +56,6 @@ struct rcu_node {
>   				/*  Initialized from ->qsmaskinitnext at the */
>   				/*  beginning of each grace period. */
>   	unsigned long qsmaskinitnext;
> -	unsigned long ofl_seq;	/* CPU-hotplug operation sequence count. */
> -				/* Online CPUs for next grace period. */
>   	unsigned long expmask;	/* CPUs or groups that need to check in */
>   				/*  to allow the current expedited GP */
>   				/*  to complete. */
> @@ -358,7 +356,7 @@ struct rcu_state {
>   	const char *name;			/* Name of structure. */
>   	char abbr;				/* Abbreviated name. */
>   
> -	raw_spinlock_t ofl_lock ____cacheline_internodealigned_in_smp;
> +	arch_spinlock_t ofl_lock ____cacheline_internodealigned_in_smp;
>   						/* Synchronize offline with */
>   						/*  GP pre-initialization. */
>   };
> 
