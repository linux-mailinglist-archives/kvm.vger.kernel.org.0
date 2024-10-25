Return-Path: <kvm+bounces-29706-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CDD39B020F
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 14:20:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 60B361C2113E
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 12:20:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3129920370E;
	Fri, 25 Oct 2024 12:19:37 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FED82036E6
	for <kvm@vger.kernel.org>; Fri, 25 Oct 2024 12:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729858776; cv=none; b=Y0uemLexeUkVOfFPhUuYg8WF/YgMOVJv9hO071TOXVRY4tDO3O3J0uVR9HzYflMR8rw2CGy51mwwBZKfbuj/z7vJNVoIW9yuq/NZAb/8Hc2wzHLzFY3JCtK3xBhWEkvHPdQGdap0kbpLd8LWgdJufqqfq+gZVegzqjh7tCnIEUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729858776; c=relaxed/simple;
	bh=aMBAw5dk/I+yeZfefEAkCNcH79TJ7FgjGU5fWouUI7Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RFdgWFxk7NV/Fjqu89uPUbXmqIDo/W32SFaJBMx502D42RYcqRffGeFKukIe4FhjilJWSmycFQ3J5D7KUmJbrBDhFm/y+2SwPggzowepllQfp9AEENftWpwtbsJjFiJA9uC67VIYORjWacLT2fQMDXLm3Y7WAg277Lcvr8yYBn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EEBC1339;
	Fri, 25 Oct 2024 05:20:01 -0700 (PDT)
Received: from arm.com (unknown [10.32.102.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 691633F71E;
	Fri, 25 Oct 2024 05:19:30 -0700 (PDT)
Date: Fri, 25 Oct 2024 13:19:26 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
	kvmarm@lists.linux.dev, atishp@rivosinc.com, jamestiotio@gmail.com,
	eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH 1/2] lib/on-cpus: Correct and simplify
 synchronization
Message-ID: <ZxuMzrEMxE/lnwtK@arm.com>
References: <20241023131718.117452-4-andrew.jones@linux.dev>
 <20241023131718.117452-5-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241023131718.117452-5-andrew.jones@linux.dev>

Hi Drew,

I've been paging in all the on_cpu* machinery, and it occurred to me that
we have a chance to simplify the code and to remove a duplicate interface
by not exposing smp_boot_secondary() to the tests, as the on_cpu* functions
serve the same purpose. With this change, we can remove the entry argument
to smp_boot_secondary(), and the assembly for secondary_entry can be made
simpler by eliminating the branch to the entry function.

Do you think that would be something worth pursuing? I can have a look at
it.

There are exactly two places where smp_boot_secondary() is used: in
arm/psci.c and arm/gic.c, and from a quick glance it looks to me like those
can be replaced with one of the on_cpu* functions.

On Wed, Oct 23, 2024 at 03:17:20PM +0200, Andrew Jones wrote:
> get/put_on_cpu_info() were trying to provide per-cpu locking for
> the per-cpu on_cpu info, but they were flawed since they would
> always set the "lock" since they were treating test_and_set/clear
> as cmpxchg (which they're not). Just revert to a normal spinlock

Would you mind expanding on that a bit more?

From my understanding of the code, on arm64, this is the call chain that I get
for get_on_cpu_info(cpu):

  ->get_on_cpu_info(cpu):
    ->!cpumask_test_and_set(cpu, on_cpu_info_lock)
      ->!test_and_set_bit(cpu, on_cpu_info_lock->bits):
         return (old & mask) != 0;

'mask' always has the CPU bit set, which means that get_on_cpu_info() returns
true if and only if 'old' has the bit clear. I think that prevents a thread
getting the lock if it's already held, so from that point of view it does
function as a per target cpu spinlock. Have I misunderstood something?

Regardless of the above, on_cpu_async() is used like this:

on_cpu_async()
wait_for_synchronization()

so it doesn't make much sense to optimize for performance for the case were
multiple threads call on_cpu_async() concurrently, as they would need to
have to wait for synchronization anyway.

So yes, I'm totally in favour for replacing the per-cpu spinlock with a global
spinlock, even if the only reason is simplifying the code.

> to correct it. Also simplify the break case for on_cpu_async() -
> we don't care if func is NULL, we only care that the cpu is idle.

That makes sense.

> And, finally, add a missing barrier to on_cpu_async().

Might be worth explaining in the commit message why it was missing. Just in
case someone is looking at the code and isn't exactly sure why it's there.

> 
> Fixes: 018550041b38 ("arm/arm64: Remove spinlocks from on_cpu_async")
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> ---
>  lib/on-cpus.c | 36 +++++++++++-------------------------
>  1 file changed, 11 insertions(+), 25 deletions(-)
> 
> diff --git a/lib/on-cpus.c b/lib/on-cpus.c
> index 892149338419..f6072117fa1b 100644
> --- a/lib/on-cpus.c
> +++ b/lib/on-cpus.c
> @@ -9,6 +9,7 @@
>  #include <on-cpus.h>
>  #include <asm/barrier.h>
>  #include <asm/smp.h>
> +#include <asm/spinlock.h>
>  
>  bool cpu0_calls_idle;
>  
> @@ -18,18 +19,7 @@ struct on_cpu_info {
>  	cpumask_t waiters;
>  };
>  static struct on_cpu_info on_cpu_info[NR_CPUS];
> -static cpumask_t on_cpu_info_lock;
> -
> -static bool get_on_cpu_info(int cpu)
> -{
> -	return !cpumask_test_and_set_cpu(cpu, &on_cpu_info_lock);
> -}
> -
> -static void put_on_cpu_info(int cpu)
> -{
> -	int ret = cpumask_test_and_clear_cpu(cpu, &on_cpu_info_lock);
> -	assert(ret);
> -}
> +static struct spinlock lock;
>  
>  static void __deadlock_check(int cpu, const cpumask_t *waiters, bool *found)
>  {
> @@ -81,18 +71,14 @@ void do_idle(void)
>  	if (cpu == 0)
>  		cpu0_calls_idle = true;
>  
> -	set_cpu_idle(cpu, true);
> -	smp_send_event();
> -
>  	for (;;) {
> +		set_cpu_idle(cpu, true);
> +		smp_send_event();
> +
>  		while (cpu_idle(cpu))
>  			smp_wait_for_event();
>  		smp_rmb();
>  		on_cpu_info[cpu].func(on_cpu_info[cpu].data);
> -		on_cpu_info[cpu].func = NULL;
> -		smp_wmb();

I think the barrier is still needed. The barrier orderered the now removed
write func = NULL before the write set_cpu_idle(), but it also orderered
whatever writes func(data) performed before set_cpu_idle(cpu, true). This
matters for on_cpu(), where I think it's reasonable for the caller to
expect to observe the writes made by 'func' after on_cpu() returns.

If you agree that this is the correct approach, I think it's worth adding a
comment explaining it.

> -		set_cpu_idle(cpu, true);
> -		smp_send_event();
>  	}
>  }
>  
> @@ -110,17 +96,17 @@ void on_cpu_async(int cpu, void (*func)(void *data), void *data)
>  
>  	for (;;) {
>  		cpu_wait(cpu);
> -		if (get_on_cpu_info(cpu)) {
> -			if ((volatile void *)on_cpu_info[cpu].func == NULL)
> -				break;
> -			put_on_cpu_info(cpu);
> -		}
> +		spin_lock(&lock);
> +		if (cpu_idle(cpu))
> +			break;
> +		spin_unlock(&lock);
>  	}
>  
>  	on_cpu_info[cpu].func = func;
>  	on_cpu_info[cpu].data = data;
> +	smp_wmb();

Without this smp_wmb(), it is possible for the target CPU to read an
outdated on_cpu_info[cpu].data. So adding it is the right thing to do,
since it orders the writes to on_cpu_info before set_cpu_idle().

>  	set_cpu_idle(cpu, false);
> -	put_on_cpu_info(cpu);
> +	spin_unlock(&lock);
>  	smp_send_event();

I think a DSB is necessary before all the smp_send_event() calls in this
file. The DSB ensures that the stores to cpu_idle_mask will be observed by
the thread that is waiting on the WFE, otherwise it is theoretically
possible to get a deadlock (in practice this will never happen, because KVM
will be generating the events that cause WFE to complete):

CPU0: on_cpu_async():		CPU1: do_idle():

load CPU1_idle = true
//do stuff
store CPU1_idle=false
SEV
				1: WFE
				   load CPU1_idle=true // old value, allowed
				   b 1b // deadlock

Also, it looks unusual to have smp_send_event() unpaired from set_cpu_idle().
Can't really point to anything being wrong about it though.

Thanks,
Alex

