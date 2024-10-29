Return-Path: <kvm+bounces-29939-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A1E569B47C0
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 12:05:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A8AAF1C23759
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 11:05:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1462320A5DA;
	Tue, 29 Oct 2024 10:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ipAiBBCL"
X-Original-To: kvm@vger.kernel.org
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A5BB205AA8
	for <kvm@vger.kernel.org>; Tue, 29 Oct 2024 10:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730199428; cv=none; b=qMTNpSapGjthamuMfVONwgd7TI20kEvXbemSGXEa58m4hI+lD3Swh32YJP71jyQXwpQaUOFM8NZEpNPixyxZyQPjU/NrgxCjc6v8sEzR4F7XDII6cxf5rb1WYfhqyhRMjNd5XxV4+TNma7ALaCpZ+hbZByJyolxEjxhXMUWADNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730199428; c=relaxed/simple;
	bh=DgaAktxhE+O3P6/FkW+aSFM/MjQiUgSejfnRJmd2IE0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AlMxIdFcLFPjAq37IFvtgXNf7oqpOgBO2Oryzgbx9dg9nxUIPZHMhVpfrHUXLnR0uCmIO/xY2wQg1GKSQrHCAWMVBfCTQfoNBqyxJSpI1mnPxkhUSNvgY+3QG2EvtK04l8gJE3IY7f1OaGrZN8qtYdYP8dDYnLrOew3+SWxO5GQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ipAiBBCL; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 29 Oct 2024 11:56:58 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730199421;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0FZL6UuQw+2z9SOgAGbgAmRX5zodSHMe5TtiwslRlu8=;
	b=ipAiBBCLPmioqdyuz2eYETIi1T8U0dQw6009g2QPFyaDptknOITNxNuF2EvY8TKDEZZYzn
	0oIoUA3CRQ/4JjsyJNPuHNy/hWNhXHPcF1mI5EhsTOktPHj74s34llagdrsYyIOz8a9tPp
	17usenXsO32vj1KnVyhklXXQhG/COuk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	kvmarm@lists.linux.dev, atishp@rivosinc.com, jamestiotio@gmail.com, 
	eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH 1/2] lib/on-cpus: Correct and simplify
 synchronization
Message-ID: <20241029-1d35ce0dbbea4d21b56209dc@orel>
References: <20241023131718.117452-4-andrew.jones@linux.dev>
 <20241023131718.117452-5-andrew.jones@linux.dev>
 <ZxuMzrEMxE/lnwtK@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZxuMzrEMxE/lnwtK@arm.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Oct 25, 2024 at 01:19:26PM +0100, Alexandru Elisei wrote:
> Hi Drew,
> 
> I've been paging in all the on_cpu* machinery, and it occurred to me that
> we have a chance to simplify the code and to remove a duplicate interface
> by not exposing smp_boot_secondary() to the tests, as the on_cpu* functions
> serve the same purpose. With this change, we can remove the entry argument
> to smp_boot_secondary(), and the assembly for secondary_entry can be made
> simpler by eliminating the branch to the entry function.

You're right that smp_boot_secondary() doesn't appear to getting use, but
a goal for the library code is to be useful and with defaults that will
satisfy nearly all unit tests, but to never restrict a unit test to
having to use it. Exposing calls like smp_boot_secondary() give unit tests
the ability to eliminate as much library code as possible from their paths
without having to duplicate the few lines needed to "boot" a secondary.

> 
> Do you think that would be something worth pursuing? I can have a look at
> it.
> 
> There are exactly two places where smp_boot_secondary() is used: in
> arm/psci.c and arm/gic.c, and from a quick glance it looks to me like those
> can be replaced with one of the on_cpu* functions.
> 
> On Wed, Oct 23, 2024 at 03:17:20PM +0200, Andrew Jones wrote:
> > get/put_on_cpu_info() were trying to provide per-cpu locking for
> > the per-cpu on_cpu info, but they were flawed since they would
> > always set the "lock" since they were treating test_and_set/clear
> > as cmpxchg (which they're not). Just revert to a normal spinlock
> 
> Would you mind expanding on that a bit more?
> 
> From my understanding of the code, on arm64, this is the call chain that I get
> for get_on_cpu_info(cpu):
> 
>   ->get_on_cpu_info(cpu):
>     ->!cpumask_test_and_set(cpu, on_cpu_info_lock)
>       ->!test_and_set_bit(cpu, on_cpu_info_lock->bits):
>          return (old & mask) != 0;
> 
> 'mask' always has the CPU bit set, which means that get_on_cpu_info() returns
> true if and only if 'old' has the bit clear. I think that prevents a thread
> getting the lock if it's already held, so from that point of view it does
> function as a per target cpu spinlock. Have I misunderstood something?

No, you're right, and thanks for reminding me of the thought process I
used when I wrote get/put_on_cpu_info() in the first place :-) While
trying to simplify things, I just got fed up with staring at it and
reasoning about it, so I threw my hands up and went back to a good ol'
lock. Now that you've convinced me [again] that the test-and-set isn't
flawed, we could keep it, but...

> 
> Regardless of the above, on_cpu_async() is used like this:
> 
> on_cpu_async()
> wait_for_synchronization()
> 
> so it doesn't make much sense to optimize for performance for the case were
> multiple threads call on_cpu_async() concurrently, as they would need to
> have to wait for synchronization anyway.

...even though on_cpu_async() has a wait part, it only waits (outside the
lock) for the target cpu to be idle. If all targets are idle already, and
we have more than one "launcher" cpu, then we could launch tests on all
the targets more-or-less simultaneously with percpu locks, but...

> 
> So yes, I'm totally in favour for replacing the per-cpu spinlock with a global
> spinlock, even if the only reason is simplifying the code.

...simplifying the code is probably the better choice since the critical
section is so small that sharing a lock really shouldn't matter much and
even some contention test which needs to run simultaneously on several
cpus should use looping rather than rely on a simultaneous launch.

> 
> > to correct it. Also simplify the break case for on_cpu_async() -
> > we don't care if func is NULL, we only care that the cpu is idle.
> 
> That makes sense.
> 
> > And, finally, add a missing barrier to on_cpu_async().
> 
> Might be worth explaining in the commit message why it was missing. Just in
> case someone is looking at the code and isn't exactly sure why it's there.

Sure. I think the reason it's missing is because when 018550041b38 changed
from spinlock to put_on_cpu_info(), the release was also moved below the
clearing of idle. Prior to that, the spin_unlock() was acting as barrier.
With the move of where the release was done a barrier should have been
added.

> 
> > 
> > Fixes: 018550041b38 ("arm/arm64: Remove spinlocks from on_cpu_async")
> > Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> > ---
> >  lib/on-cpus.c | 36 +++++++++++-------------------------
> >  1 file changed, 11 insertions(+), 25 deletions(-)
> > 
> > diff --git a/lib/on-cpus.c b/lib/on-cpus.c
> > index 892149338419..f6072117fa1b 100644
> > --- a/lib/on-cpus.c
> > +++ b/lib/on-cpus.c
> > @@ -9,6 +9,7 @@
> >  #include <on-cpus.h>
> >  #include <asm/barrier.h>
> >  #include <asm/smp.h>
> > +#include <asm/spinlock.h>
> >  
> >  bool cpu0_calls_idle;
> >  
> > @@ -18,18 +19,7 @@ struct on_cpu_info {
> >  	cpumask_t waiters;
> >  };
> >  static struct on_cpu_info on_cpu_info[NR_CPUS];
> > -static cpumask_t on_cpu_info_lock;
> > -
> > -static bool get_on_cpu_info(int cpu)
> > -{
> > -	return !cpumask_test_and_set_cpu(cpu, &on_cpu_info_lock);
> > -}
> > -
> > -static void put_on_cpu_info(int cpu)
> > -{
> > -	int ret = cpumask_test_and_clear_cpu(cpu, &on_cpu_info_lock);
> > -	assert(ret);
> > -}
> > +static struct spinlock lock;
> >  
> >  static void __deadlock_check(int cpu, const cpumask_t *waiters, bool *found)
> >  {
> > @@ -81,18 +71,14 @@ void do_idle(void)
> >  	if (cpu == 0)
> >  		cpu0_calls_idle = true;
> >  
> > -	set_cpu_idle(cpu, true);
> > -	smp_send_event();
> > -
> >  	for (;;) {
> > +		set_cpu_idle(cpu, true);
> > +		smp_send_event();
> > +
> >  		while (cpu_idle(cpu))
> >  			smp_wait_for_event();
> >  		smp_rmb();
> >  		on_cpu_info[cpu].func(on_cpu_info[cpu].data);
> > -		on_cpu_info[cpu].func = NULL;
> > -		smp_wmb();
> 
> I think the barrier is still needed. The barrier orderered the now removed
> write func = NULL before the write set_cpu_idle(), but it also orderered
> whatever writes func(data) performed before set_cpu_idle(cpu, true). This
> matters for on_cpu(), where I think it's reasonable for the caller to
> expect to observe the writes made by 'func' after on_cpu() returns.
> 
> If you agree that this is the correct approach, I think it's worth adding a
> comment explaining it.

I think that's reasonable (along with adding smp_rmb()'s to the bottom of
on_cpu() and on_cpumask()). So the idea is we have

 cpu1                                         cpu2
 ----                                         ----
 func() /* store something */                 /* wait for cpu1 to be idle */
 smp_wmb();                                   smp_rmb();
 set_cpu_idle(smp_processor_id(), true);      /* load what func() stored */

> 
> > -		set_cpu_idle(cpu, true);
> > -		smp_send_event();
> >  	}
> >  }
> >  
> > @@ -110,17 +96,17 @@ void on_cpu_async(int cpu, void (*func)(void *data), void *data)
> >  
> >  	for (;;) {
> >  		cpu_wait(cpu);
> > -		if (get_on_cpu_info(cpu)) {
> > -			if ((volatile void *)on_cpu_info[cpu].func == NULL)
> > -				break;
> > -			put_on_cpu_info(cpu);
> > -		}
> > +		spin_lock(&lock);
> > +		if (cpu_idle(cpu))
> > +			break;
> > +		spin_unlock(&lock);
> >  	}
> >  
> >  	on_cpu_info[cpu].func = func;
> >  	on_cpu_info[cpu].data = data;
> > +	smp_wmb();
> 
> Without this smp_wmb(), it is possible for the target CPU to read an
> outdated on_cpu_info[cpu].data. So adding it is the right thing to do,
> since it orders the writes to on_cpu_info before set_cpu_idle().
> 
> >  	set_cpu_idle(cpu, false);
> > -	put_on_cpu_info(cpu);
> > +	spin_unlock(&lock);
> >  	smp_send_event();
> 
> I think a DSB is necessary before all the smp_send_event() calls in this
> file. The DSB ensures that the stores to cpu_idle_mask will be observed by
> the thread that is waiting on the WFE, otherwise it is theoretically
> possible to get a deadlock (in practice this will never happen, because KVM
> will be generating the events that cause WFE to complete):
> 
> CPU0: on_cpu_async():		CPU1: do_idle():
> 
> load CPU1_idle = true
> //do stuff
> store CPU1_idle=false
> SEV
> 				1: WFE
> 				   load CPU1_idle=true // old value, allowed
> 				   b 1b // deadlock

Good catch. Can you send a patch for that? The patch should be for the arm
implementations of smp_send_event() (and smp_wait_for_event()?) in
lib/arm/asm/smp.h.

> 
> Also, it looks unusual to have smp_send_event() unpaired from set_cpu_idle().
> Can't really point to anything being wrong about it though.

You mean due to the spin_unlock() separating the set_cpu_idle() and
smp_send_event()? We could put the spin_unlock() above the set_cpu_idle()
(as it was in 018550041b38, which also removes the need for the wmb), but
I think I like it the way it is now better for better readability. I
also can't think of why it would matter for them to be unpaired.

Thanks,
drew

