Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3839E4FADC2
	for <lists+kvm@lfdr.de>; Sun, 10 Apr 2022 14:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238754AbiDJMQg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 10 Apr 2022 08:16:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232013AbiDJMQf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 10 Apr 2022 08:16:35 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E67FF3D1EF;
        Sun, 10 Apr 2022 05:14:23 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1649592860;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OFmRIgWsEfS1u8csltcfGL85/93nZMY90Oa0fL8OYn8=;
        b=iT0LHVcBBKaQRnyzmg4Y+pQ1Zje/qhPE8eV5XllPWuJ4R+iBHPdx9bCyQ9QdsjydL8HFvk
        1w0gYfwVe8VW8lKPFCmaDWBNh8ISxg3cRTHc7GVEmrmpCBQx3AiuVbn0LBkwJB1vOoL/tp
        G5//ftF7PNePvQAGZiqfIbJJxRm2MIYMzrUxHy86ge44t8xM3X4Cl7WSN59H3Cq6YzkbcI
        FzjQFrDr9PL0DJ98d09c3GnDHeGuSUQ21h1ZlqSlyPuztoLNeEgo9qJe3mnLB0zYgBKpBu
        Zl6CBbqroeK/y5EOHWcTkUXPHEjKjgfyppbAHZn3B6XT5mwPT2FSDXHvyDkvhA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1649592860;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OFmRIgWsEfS1u8csltcfGL85/93nZMY90Oa0fL8OYn8=;
        b=ZowN3hDL00e5KRJGyl0d0NcP84qDlITpO7vwsVPu9kvaRTv5XnipOOoo0K4Pv//bkRseYI
        YFGsrNPSqm8U+tAQ==
To:     Pete Swain <swine@google.com>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        John Stultz <john.stultz@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Johan Hovold <johan@kernel.org>,
        Feng Tang <feng.tang@intel.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Juergen Gross <jgross@suse.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Pete Swain <swine@google.com>
Subject: Re: [PATCH 2/2] timers: retpoline mitigation for time funcs
In-Reply-To: <20220218221820.950118-2-swine@google.com>
References: <20220218221820.950118-1-swine@google.com>
 <20220218221820.950118-2-swine@google.com>
Date:   Sun, 10 Apr 2022 14:14:20 +0200
Message-ID: <87r165gmoz.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 18 2022 at 14:18, Pete Swain wrote:
> Adds indirect call exports for clock reads from tsc, apic,
> hrtimer, via clock-event, timekeeper & posix interfaces.

Sure, but why?

> Signed-off-by: Pete Swain <swine@google.com>
> ---
>  arch/x86/kernel/apic/apic.c    |  8 +++++---
>  arch/x86/kernel/tsc.c          |  3 ++-
>  include/linux/hrtimer.h        | 19 ++++++++++++++++---
>  kernel/time/clockevents.c      |  9 ++++++---
>  kernel/time/hrtimer.c          |  3 ++-
>  kernel/time/posix-cpu-timers.c |  4 ++--
>  kernel/time/posix-timers.c     |  3 ++-
>  kernel/time/timekeeping.c      |  2 +-
>  8 files changed, 36 insertions(+), 15 deletions(-)

Can this please be split up properly? 

> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> index b70344bf6600..523a569dd35e 100644
> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -463,15 +463,17 @@ EXPORT_SYMBOL_GPL(setup_APIC_eilvt);
>  /*
>   * Program the next event, relative to now
>   */
> -static int lapic_next_event(unsigned long delta,
> +INDIRECT_CALLABLE_SCOPE
> +int lapic_next_event(unsigned long delta,
>  			    struct clock_event_device *evt)

So this was formatted properly:

static int lapic_next_event(unsigned long delta,
  			    struct clock_event_device *evt)

Now it turned into garbage:

INDIRECT_CALLABLE_SCOPE
int lapic_next_event(unsigned long delta,
  			    struct clock_event_device *evt)

while:

INDIRECT_CALLABLE_SCOPE int lapic_next_event(unsigned long delta,
					     struct clock_event_device *evt)
or

INDIRECT_CALLABLE_SCOPE
int lapic_next_event(unsigned long delta, struct clock_event_device *evt)

are both what a reader would expect.

Similar issues all over the place.

> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> index a698196377be..ff2868d5ddea 100644
> --- a/arch/x86/kernel/tsc.c
> +++ b/arch/x86/kernel/tsc.c
> @@ -1090,7 +1090,8 @@ static void tsc_resume(struct clocksource *cs)
>   * checking the result of read_tsc() - cycle_last for being negative.
>   * That works because CLOCKSOURCE_MASK(64) does not mask out any bit.
>   */
> -static u64 read_tsc(struct clocksource *cs)
> +INDIRECT_CALLABLE_SCOPE
> +u64 read_tsc(struct clocksource *cs)

What's the extra line for?

>  {
>  	return (u64)rdtsc_ordered();
>  }
> diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
> index 0ee140176f10..9d2d110f0b8c 100644
> --- a/include/linux/hrtimer.h
> +++ b/include/linux/hrtimer.h
> @@ -20,6 +20,7 @@
>  #include <linux/seqlock.h>
>  #include <linux/timer.h>
>  #include <linux/timerqueue.h>
> +#include <linux/indirect_call_wrapper.h>
>  
>  struct hrtimer_clock_base;
>  struct hrtimer_cpu_base;
> @@ -297,14 +298,17 @@ static inline s64 hrtimer_get_expires_ns(const struct hrtimer *timer)
>  	return ktime_to_ns(timer->node.expires);
>  }
>  
> +INDIRECT_CALLABLE_DECLARE(extern ktime_t ktime_get(void));
> +
>  static inline ktime_t hrtimer_expires_remaining(const struct hrtimer *timer)
>  {
> -	return ktime_sub(timer->node.expires, timer->base->get_time());
> +	return ktime_sub(timer->node.expires,
> +			INDIRECT_CALL_1(timer->base->get_time, ktime_get));

This wants a proper explanation in a changelog for the hrtimer check,
why this is optimized for ktime_get().

>  }
>  
>  static inline ktime_t hrtimer_cb_get_time(struct hrtimer *timer)
>  {
> -	return timer->base->get_time();
> +	return INDIRECT_CALL_1(timer->base->get_time, ktime_get);
>  }
>  
>  static inline int hrtimer_is_hres_active(struct hrtimer *timer)
> @@ -503,7 +507,9 @@ hrtimer_forward(struct hrtimer *timer, ktime_t now, ktime_t interval);
>  static inline u64 hrtimer_forward_now(struct hrtimer *timer,
>  				      ktime_t interval)
>  {
> -	return hrtimer_forward(timer, timer->base->get_time(), interval);
> +	return hrtimer_forward(timer,
> +			INDIRECT_CALL_1(timer->base->get_time, ktime_get),
> +			interval);
>  }
>  
>  /* Precise sleep: */
> @@ -536,4 +542,11 @@ int hrtimers_dead_cpu(unsigned int cpu);
>  #define hrtimers_dead_cpu	NULL
>  #endif
>  
> +struct clock_event_device;
> +INDIRECT_CALLABLE_DECLARE(extern __weak u64 read_tsc(struct clocksource *cs));
> +INDIRECT_CALLABLE_DECLARE(extern int thread_cpu_clock_get(
> +		const clockid_t which_clock, struct timespec64 *tp));
> +INDIRECT_CALLABLE_DECLARE(extern __weak int lapic_next_deadline(
> +		unsigned long delta, struct clock_event_device *evt));
> +

No. This is not how it works. This is a generic header and x86 specific
muck has no place here.

>  #endif
> diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
> index 003ccf338d20..ac15412e87c4 100644
> --- a/kernel/time/clockevents.c
> +++ b/kernel/time/clockevents.c
> @@ -245,7 +245,8 @@ static int clockevents_program_min_delta(struct clock_event_device *dev)
>  
>  		dev->retries++;
>  		clc = ((unsigned long long) delta * dev->mult) >> dev->shift;
> -		if (dev->set_next_event((unsigned long) clc, dev) == 0)
> +		if (INDIRECT_CALL_1(dev->set_next_event, lapic_next_deadline,
> +				  (unsigned long) clc, dev) == 0)

No. We are not sprinkling x86'isms into generic code.

> diff --git a/kernel/time/posix-cpu-timers.c b/kernel/time/posix-cpu-timers.c
> index 96b4e7810426..d8bf325fa84e 100644
> --- a/kernel/time/posix-cpu-timers.c
> +++ b/kernel/time/posix-cpu-timers.c
> @@ -1596,8 +1596,8 @@ static int thread_cpu_clock_getres(const clockid_t which_clock,
>  {
>  	return posix_cpu_clock_getres(THREAD_CLOCK, tp);
>  }
> -static int thread_cpu_clock_get(const clockid_t which_clock,
> -				struct timespec64 *tp)
> +INDIRECT_CALLABLE_SCOPE
> +int thread_cpu_clock_get(const clockid_t which_clock, struct timespec64 *tp)
>  {
>  	return posix_cpu_clock_get(THREAD_CLOCK, tp);
>  }
> diff --git a/kernel/time/posix-timers.c b/kernel/time/posix-timers.c
> index 1cd10b102c51..35eac10ee796 100644
> --- a/kernel/time/posix-timers.c
> +++ b/kernel/time/posix-timers.c
> @@ -1089,7 +1089,8 @@ SYSCALL_DEFINE2(clock_gettime, const clockid_t, which_clock,
>  	if (!kc)
>  		return -EINVAL;
>  
> -	error = kc->clock_get_timespec(which_clock, &kernel_tp);
> +	error = INDIRECT_CALL_1(kc->clock_get_timespec, thread_cpu_clock_get,
> +				which_clock, &kernel_tp);

The argument for selecting thread_cpu_clock_get() as optimization target
is?

>  
>  	if (!error && put_timespec64(&kernel_tp, tp))
>  		error = -EFAULT;
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index dcdcb85121e4..2b1a3b146614 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -190,7 +190,7 @@ static inline u64 tk_clock_read(const struct tk_read_base *tkr)
>  {
>  	struct clocksource *clock = READ_ONCE(tkr->clock);
>  
> -	return clock->read(clock);
> +	return INDIRECT_CALL_1(clock->read, read_tsc, clock);

Again. No X86 muck here.

Thanks,

        tglx
