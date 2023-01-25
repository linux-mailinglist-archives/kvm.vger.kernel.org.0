Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40AC367B153
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 12:33:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235349AbjAYLcj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Jan 2023 06:32:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235532AbjAYLcP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Jan 2023 06:32:15 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 35A932B291;
        Wed, 25 Jan 2023 03:32:13 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A8B784B3;
        Wed, 25 Jan 2023 03:32:54 -0800 (PST)
Received: from FVFF77S0Q05N (unknown [10.57.9.209])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C58083F71E;
        Wed, 25 Jan 2023 03:32:07 -0800 (PST)
Date:   Wed, 25 Jan 2023 11:32:04 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>, mingo@kernel.org,
        will@kernel.org, boqun.feng@gmail.com, tglx@linutronix.de,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, seanjc@google.com, pbonzini@redhat.com,
        jgross@suse.com, srivatsa@csail.mit.edu, amakhalov@vmware.com,
        pv-drivers@vmware.com, mhiramat@kernel.org, wanpengli@tencent.com,
        vkuznets@redhat.com, boris.ostrovsky@oracle.com, rafael@kernel.org,
        daniel.lezcano@linaro.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        bsegall@google.com, mgorman@suse.de, bristot@redhat.com,
        vschneid@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-trace-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Paul McKenney <paulmck@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 3/6] ftrace/x86: Warn and ignore graph tracing when RCU
 is disabled
Message-ID: <Y9ETNHyE2NgrPJJL@FVFF77S0Q05N>
References: <20230123205009.790550642@infradead.org>
 <20230123205515.059999893@infradead.org>
 <20230123165304.370121e7@gandalf.local.home>
 <20230123170753.7ac9419e@gandalf.local.home>
 <Y8/u00WHGElMDjoo@hirez.programming.kicks-ass.net>
 <Y9ARbgtYhxSuOIlZ@FVFF77S0Q05N>
 <Y9EI0Gn/NUJt6GEk@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9EI0Gn/NUJt6GEk@hirez.programming.kicks-ass.net>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 25, 2023 at 11:47:44AM +0100, Peter Zijlstra wrote:
> On Tue, Jan 24, 2023 at 05:12:14PM +0000, Mark Rutland wrote:
> > On Tue, Jan 24, 2023 at 03:44:35PM +0100, Peter Zijlstra wrote:
> > > On Mon, Jan 23, 2023 at 05:07:53PM -0500, Steven Rostedt wrote:
> > > 
> > > > Actually, perhaps we can just add this, and all you need to do is create
> > > > and set CONFIG_NO_RCU_TRACING (or some other name).
> > > 
> > > Elsewhere I've used CONFIG_ARCH_WANTS_NO_INSTR for this.
> > 
> > Yes please; if we use CONFIG_ARCH_WANTS_NO_INSTR then arm64 will get this "for
> > free" once we add the missing checks (which I assume we need) in our ftrace_prepare_return().
> > 
> > > Anyway, I took it for a spin and it .... doesn't seems to do the job.
> > > 
> > > With my patch the first splat is
> > > 
> > >   "RCU not on for: cpuidle_poll_time+0x0/0x70"
> > > 
> > > While with yours I seems to get the endless:
> > > 
> > >   "WARNING: suspicious RCU usage"
> > > 
> > > thing. Let me see if I can figure out where it goes side-ways.
> > 
> > Hmmm... for WARN_ONCE() don't we need to wake RCU first also? I thought we
> > needed that at least for the printk machinery?
> 
> OK, the below seems to work nice for me -- although I'm still on a
> hacked up printk, but the recursive RCU not watching fail seems to be
> tamed.

FWIW, I gave that a spin on arm64 with the ftrace selftests, and I see no
splats, so it looks good on that front.

Currently arm64's BUG/WARN exception handling does the usual
lockdep/rcu/whatever stuff before getting to report_bug(), so that bit should
be redundant (and any WARN() or BUG() early in the entry code is likely to lead
to a stack overflow and kill the kernel), but it shouldn't be harmful.

> Ofc. Paul might have an opinion on this glorious bodge ;-)

I'll leave that to Paul. ;)

Thanks,
Mark.

> 
> ---
> 
> diff --git a/include/linux/trace_recursion.h b/include/linux/trace_recursion.h
> index c303f7a114e9..d48cd92d2364 100644
> --- a/include/linux/trace_recursion.h
> +++ b/include/linux/trace_recursion.h
> @@ -135,6 +135,21 @@ extern void ftrace_record_recursion(unsigned long ip, unsigned long parent_ip);
>  # define do_ftrace_record_recursion(ip, pip)	do { } while (0)
>  #endif
>  
> +#ifdef CONFIG_ARCH_WANTS_NO_INSTR
> +# define trace_warn_on_no_rcu(ip)					\
> +	({								\
> +		bool __ret = !rcu_is_watching();			\
> +		if (__ret && !trace_recursion_test(TRACE_RECORD_RECURSION_BIT)) { \
> +			trace_recursion_set(TRACE_RECORD_RECURSION_BIT); \
> +			WARN_ONCE(true, "RCU not on for: %pS\n", (void *)ip); \
> +			trace_recursion_clear(TRACE_RECORD_RECURSION_BIT); \
> +		}							\
> +		__ret;							\
> +	})
> +#else
> +# define trace_warn_on_no_rcu(ip)	false
> +#endif
> +
>  /*
>   * Preemption is promised to be disabled when return bit >= 0.
>   */
> @@ -144,6 +159,9 @@ static __always_inline int trace_test_and_set_recursion(unsigned long ip, unsign
>  	unsigned int val = READ_ONCE(current->trace_recursion);
>  	int bit;
>  
> +	if (trace_warn_on_no_rcu(ip))
> +		return -1;
> +
>  	bit = trace_get_context_bit() + start;
>  	if (unlikely(val & (1 << bit))) {
>  		/*
> diff --git a/lib/bug.c b/lib/bug.c
> index c223a2575b72..0a10643ea168 100644
> --- a/lib/bug.c
> +++ b/lib/bug.c
> @@ -47,6 +47,7 @@
>  #include <linux/sched.h>
>  #include <linux/rculist.h>
>  #include <linux/ftrace.h>
> +#include <linux/context_tracking.h>
>  
>  extern struct bug_entry __start___bug_table[], __stop___bug_table[];
>  
> @@ -153,7 +154,7 @@ struct bug_entry *find_bug(unsigned long bugaddr)
>  	return module_find_bug(bugaddr);
>  }
>  
> -enum bug_trap_type report_bug(unsigned long bugaddr, struct pt_regs *regs)
> +static enum bug_trap_type __report_bug(unsigned long bugaddr, struct pt_regs *regs)
>  {
>  	struct bug_entry *bug;
>  	const char *file;
> @@ -209,6 +210,30 @@ enum bug_trap_type report_bug(unsigned long bugaddr, struct pt_regs *regs)
>  	return BUG_TRAP_TYPE_BUG;
>  }
>  
> +enum bug_trap_type report_bug(unsigned long bugaddr, struct pt_regs *regs)
> +{
> +	enum bug_trap_type ret;
> +	bool rcu = false;
> +
> +#ifdef CONFIG_CONTEXT_TRACKING_IDLE
> +	/*
> +	 * Horrible hack to shut up recursive RCU isn't watching fail since
> +	 * lots of the actual reporting also relies on RCU.
> +	 */
> +	if (!rcu_is_watching()) {
> +		rcu = true;
> +		ct_state_inc(RCU_DYNTICKS_IDX);
> +	}
> +#endif
> +
> +	ret = __report_bug(bugaddr, regs);
> +
> +	if (rcu)
> +		ct_state_inc(RCU_DYNTICKS_IDX);
> +
> +	return ret;
> +}
> +
>  static void clear_once_table(struct bug_entry *start, struct bug_entry *end)
>  {
>  	struct bug_entry *bug;
