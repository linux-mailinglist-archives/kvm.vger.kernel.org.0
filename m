Return-Path: <kvm+bounces-2332-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 244C27F5195
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 21:26:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1D6821C20B66
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 20:26:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B8695C90A;
	Wed, 22 Nov 2023 20:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sTq6aXnX"
X-Original-To: kvm@vger.kernel.org
Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [IPv6:2001:41d0:1004:224b::af])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C021D41
	for <kvm@vger.kernel.org>; Wed, 22 Nov 2023 12:26:20 -0800 (PST)
Date: Wed, 22 Nov 2023 20:26:12 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1700684778;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Zh0OPysLT34Qi+7ar6jFP+jiRThxRaPTlUidMH1D4+8=;
	b=sTq6aXnXMMurq+s5wC5xXTEm4hsedQC652w2/KIRuAMvo3OPj4BvTC8XlelFBnRr8do+l0
	BidsZ7Hh+EqbMIJ9IG4nlapKMCmRre+waNYepLye0iAicxQg2A7/Aq62KSKL1Wx3ZrzqYp
	m0LtfDduf6pKOQsYjOo+m9iq997DBZ8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Colton Lewis <coltonlewis@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ricardo Koller <ricarkol@google.com>, kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 3/3] KVM: arm64: selftests: Add arch_timer_edge_cases
 selftest
Message-ID: <ZV5j5By1o6aFnrbV@linux.dev>
References: <20231103192915.2209393-1-coltonlewis@google.com>
 <20231103192915.2209393-4-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231103192915.2209393-4-coltonlewis@google.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Nov 03, 2023 at 07:29:15PM +0000, Colton Lewis wrote:
> +struct test_args {
> +	/* Virtual or physical timer and counter tests. */
> +	enum arch_timer timer;
> +	/* Delay used for most timer tests. */
> +	uint64_t wait_ms;
> +	/* Delay used in the test_long_timer_delays test. */
> +	uint64_t long_wait_ms;
> +	/* Number of iterations. */
> +	int iterations;
> +	/* Whether to test the physical timer. */
> +	bool test_physical;
> +	/* Whether to test the virtual timer. */
> +	bool test_virtual;
> +};
> +
> +struct test_args test_args = {
> +	.wait_ms = WAIT_TEST_MS,
> +	.long_wait_ms = LONG_WAIT_TEST_MS,
> +	.iterations = NR_TEST_ITERS_DEF,
> +	.test_physical = true,
> +	.test_virtual = true,
> +};
> +
> +static int vtimer_irq, ptimer_irq;
> +
> +enum sync_cmd {
> +	SET_REG_KVM_REG_ARM_TIMER_CNT = 100001,

nit: Why not call it SET_COUNTER_VALUE? Also, what's the reason for the
magic starting value here?

> +	USERSPACE_USLEEP,
> +	USERSPACE_SCHED_YIELD,
> +	USERSPACE_MIGRATE_SELF,
> +	NO_USERSPACE_CMD,
> +};
> +
> +typedef void (*sleep_method_t)(enum arch_timer timer, uint64_t usec);
> +
> +static void sleep_poll(enum arch_timer timer, uint64_t usec);
> +static void sleep_sched_poll(enum arch_timer timer, uint64_t usec);
> +static void sleep_in_userspace(enum arch_timer timer, uint64_t usec);
> +static void sleep_migrate(enum arch_timer timer, uint64_t usec);
> +
> +sleep_method_t sleep_method[] = {
> +	sleep_poll,
> +	sleep_sched_poll,
> +	sleep_migrate,
> +	sleep_in_userspace,
> +};
> +
> +typedef void (*wfi_method_t)(void);
> +
> +static void wait_for_non_spurious_irq(void);
> +static void wait_poll_for_irq(void);
> +static void wait_sched_poll_for_irq(void);
> +static void wait_migrate_poll_for_irq(void);
> +
> +wfi_method_t wfi_method[] = {
> +	wait_for_non_spurious_irq,
> +	wait_poll_for_irq,
> +	wait_sched_poll_for_irq,
> +	wait_migrate_poll_for_irq,
> +};
> +
> +#define for_each_wfi_method(i)							\
> +	for ((i) = 0; (i) < ARRAY_SIZE(wfi_method); (i)++)
> +
> +#define for_each_sleep_method(i)						\
> +	for ((i) = 0; (i) < ARRAY_SIZE(sleep_method); (i)++)

I don't see a tremendous amount of value in using iterators for these
arrays, especially since the caller is still directly referencing the
underlying arrays to get at the element anyway.

> +enum timer_view {
> +	TIMER_CVAL = 1,

Again, when I read an enumeration with an explicit starting value, I
assume that there is a functional reason for it.

> +	TIMER_TVAL,
> +};
> +
> +#define ASSERT_IRQS_HANDLED(_nr, _args...) do {				\
> +		int _h = atomic_read(&shared_data.handled);		\
> +		__GUEST_ASSERT(_h == (_nr), "Handled %d IRQS but expected %d", _h, _nr, ##_args); \
> +	} while (0)
> +
> +#define GUEST_SYNC_CLOCK(__cmd, __val)						\
> +	GUEST_SYNC_ARGS(__cmd, __val, 0, 0, 0)
> +
> +#define USERSPACE_CMD(__cmd)							\
> +	GUEST_SYNC_ARGS(__cmd, 0, 0, 0, 0)
> +
> +#define USERSPACE_SCHEDULE()							\
> +	USERSPACE_CMD(USERSPACE_SCHED_YIELD)
> +
> +#define USERSPACE_MIGRATE_VCPU()						\
> +	USERSPACE_CMD(USERSPACE_MIGRATE_SELF)
> +
> +#define SLEEP_IN_USERSPACE(__usecs)						\
> +	GUEST_SYNC_ARGS(USERSPACE_USLEEP, (__usecs), 0, 0, 0)
> +
> +#define IAR_SPURIOUS		1023
> +

Isn't this already defined in gic.h?

> +static void set_counter(enum arch_timer timer, uint64_t counter)
> +{
> +	GUEST_SYNC_ARGS(SET_REG_KVM_REG_ARM_TIMER_CNT, counter, timer, 0, 0);
> +}

Why do some of the ucall helpers use macros and this one is done as a
function? You should avoid using macros unless you're actually doing
something valuable with the preprocessor.

> +static uint32_t next_pcpu(void)
> +{
> +	uint32_t max = get_nprocs();
> +	uint32_t cur = sched_getcpu();
> +	uint32_t next = cur;
> +	cpu_set_t cpuset;
> +
> +	TEST_ASSERT(max > 1, "Need at least two physical cpus");
> +
> +	sched_getaffinity(getpid(), sizeof(cpuset), &cpuset);

Can you just pass 0 here for the pid? Forgive me if I'm getting my wires
crossed, but isn't this going to return the last cpuset you've written in
migrate_self()? In that case it would seem you'll always select the same
CPU.

Also, it would seem that the test isn't pinning to a particular CPU in
the beginning. In that case CPU migrations can happen _at any time_ and
are not being precisely controlled by the test. Is this intentional?

> +/*
> + * Should be called with IRQs masked.
> + *
> + * Note that this can theoretically hang forever, so we rely on having
> + * a timeout mechanism in the "runner", like:
> + * tools/testing/selftests/kselftest/runner.sh.
> + */
> +static void wait_for_non_spurious_irq(void)
> +{
> +	int h;
> +
> +	for (h = atomic_read(&shared_data.handled); h == atomic_read(&shared_data.handled);) {
> +		gic_wfi();
> +		local_irq_enable();
> +		isb();
> +		/* handle IRQ */
> +		local_irq_disable();

Same nitpick about comment placement here. The isb *is* the context
synchronization event that precipitates the imaginary window where
pending interrupts are taken.

> +	}
> +}
> +
> +/*
> + * Wait for an non-spurious IRQ by polling in the guest (userspace=0) or in
> + * userspace (e.g., userspace=1 and userspace_cmd=USERSPACE_SCHED_YIELD).
		       ^~~~~~~~~~~

More magic values. What is this?

> + * Should be called with IRQs masked. Not really needed like the wfi above, but
> + * it should match the others.
> + *
> + * Note that this can theoretically hang forever, so we rely on having
> + * a timeout mechanism in the "runner", like:
> + * tools/testing/selftests/kselftest/runner.sh.
> + */
> +static void poll_for_non_spurious_irq(enum sync_cmd userspace_cmd)
> +{
> +	int h;
> +
> +	h = atomic_read(&shared_data.handled);
> +
> +	local_irq_enable();
> +	while (h == atomic_read(&shared_data.handled)) {
> +		if (userspace_cmd == NO_USERSPACE_CMD)
> +			cpu_relax();
> +		else
> +			USERSPACE_CMD(userspace_cmd);
> +	}
> +	local_irq_disable();

cpu_relax(), or rather the yield instruction, is not a context
synchronization event.

> +/* Test masking/unmasking a timer using the timer mask (not the IRQ mask). */
> +static void test_timer_control_mask_then_unmask(enum arch_timer timer)
> +{
> +	reset_timer_state(timer, DEF_CNT);
> +	set_tval_irq(timer, -1, CTL_ENABLE | CTL_IMASK);
> +
> +	/* No IRQs because the timer is still masked. */
> +	ASSERT_IRQS_HANDLED(0);

This seems to assume both the timer hardware and GIC are capable of
getting the interrupt to the CPU in just a few cycles.

Oh wait, that's exactly what test_timer_control_masks() is doing...
What's the point of this then?

> +	/* Unmask the timer, and then get an IRQ. */
> +	local_irq_disable();
> +	timer_set_ctl(timer, CTL_ENABLE);
> +	wait_for_non_spurious_irq();
> +
> +	ASSERT_IRQS_HANDLED(1);
> +	local_irq_enable();
> +}
> +
> +/* Check that timer control masks actually mask a timer being fired. */
> +static void test_timer_control_masks(enum arch_timer timer)
> +{
> +	reset_timer_state(timer, DEF_CNT);
> +
> +	/* Local IRQs are not masked at this point. */
> +
> +	set_tval_irq(timer, -1, CTL_ENABLE | CTL_IMASK);
> +
> +	/* Assume no IRQ after waiting TIMEOUT_NO_IRQ_US microseconds */
> +	sleep_poll(timer, TIMEOUT_NO_IRQ_US);
> +
> +	ASSERT_IRQS_HANDLED(0);
> +	timer_set_ctl(timer, CTL_IMASK);
> +}
> +
> +static void test_fire_a_timer_multiple_times(enum arch_timer timer,
> +					     wfi_method_t wm, int num)
> +{
> +	int i;
> +
> +	local_irq_disable();
> +	reset_timer_state(timer, DEF_CNT);
> +
> +	set_tval_irq(timer, 0, CTL_ENABLE);
> +
> +	for (i = 1; i <= num; i++) {
> +		wm();

wfi_method_t is such a misnomer. Critically, it masks/unmasks IRQs which
is rather hard to remember once you're this deep into the test code. At
least having some comments on what wfi_method_t is expected to do would
help a bit.

> +		/* The IRQ handler masked and disabled the timer.
> +		 * Enable and unmmask it again.
> +		 */
> +		timer_set_ctl(timer, CTL_ENABLE);
> +
> +		ASSERT_IRQS_HANDLED(i);
> +	}
> +
> +	local_irq_enable();
> +}
> +
> +static void test_timers_fired_multiple_times(enum arch_timer timer)
> +{
> +	int i;
> +
> +	for_each_wfi_method(i)
> +		test_fire_a_timer_multiple_times(timer, wfi_method[i], 10);
> +}
> +
> +/*
> + * Set a timer for tval=d_1_ms then reprogram it to tval=d_2_ms. Check that we
> + * get the timer fired. There is no timeout for the wait: we use the wfi
> + * instruction.
> + */
> +static void test_reprogramming_timer(enum arch_timer timer, wfi_method_t wm,
> +				     int32_t d_1_ms, int32_t d_2_ms)
> +{
> +	local_irq_disable();
> +	reset_timer_state(timer, DEF_CNT);
> +
> +	/* Program the timer to DEF_CNT + d_1_ms. */
> +	set_tval_irq(timer, msec_to_cycles(d_1_ms), CTL_ENABLE);

This assumes that the program doesn't get preempted for @d_1_ms here,
right?

> +	/* Reprogram the timer to DEF_CNT + d_2_ms. */
> +	timer_set_tval(timer, msec_to_cycles(d_2_ms));
> +
> +	wm();
> +
> +	/* The IRQ should arrive at DEF_CNT + d_2_ms (or after). */
> +	GUEST_ASSERT(timer_get_cntct(timer) >=
> +		     DEF_CNT + msec_to_cycles(d_2_ms));
> +
> +	local_irq_enable();
> +	ASSERT_IRQS_HANDLED(1, wm);
> +};
> +
> +/*
> + * Set a timer for tval=d_1_ms then reprogram it to tval=d_2_ms. Check
> + * that we get the timer fired in d_2_ms.
> + */
> +static void test_reprogramming_timer_with_timeout(enum arch_timer timer,
> +						  sleep_method_t guest_sleep,
> +						  int32_t d_1_ms,
> +						  int32_t d_2_ms)
> +{
> +	local_irq_disable();
> +	reset_timer_state(timer, DEF_CNT);
> +
> +	set_tval_irq(timer, msec_to_cycles(d_1_ms), CTL_ENABLE);
> +
> +	/* Reprogram the timer. */
> +	timer_set_tval(timer, msec_to_cycles(d_2_ms));
> +
> +	guest_sleep(timer, msecs_to_usecs(d_2_ms) + TEST_MARGIN_US);

Even more magic values. What is the difference between TEST_MARGIN_US
and TIMEOUT_NO_IRQ_US?

> +	local_irq_enable();
> +	isb();
> +	ASSERT_IRQS_HANDLED(1);
> +};
> +
> +static void test_reprogram_timers(enum arch_timer timer)
> +{
> +	int i;
> +	uint64_t base_wait = test_args.wait_ms;
> +
> +	for_each_wfi_method(i) {
> +		test_reprogramming_timer(timer, wfi_method[i], 2 * base_wait,
> +					 base_wait);
> +		test_reprogramming_timer(timer, wfi_method[i], base_wait,
> +					 2 * base_wait);

What is the value of changing around the two timer deltas? It is
entirely unclear from reading this what potential edge case it is
detecting.

> +/*
> + * This test checks basic timer behavior without actually firing timers, things
> + * like: the relationship between cval and tval, tval down-counting.
> + */
> +static void timers_sanity_checks(enum arch_timer timer, bool use_sched)
> +{
> +	reset_timer_state(timer, DEF_CNT);
> +
> +	local_irq_disable();
> +
> +	/* cval in the past */
> +	timer_set_cval(timer,
> +		       timer_get_cntct(timer) -
> +		       msec_to_cycles(test_args.wait_ms));
> +	if (use_sched)
> +		USERSPACE_MIGRATE_VCPU();
> +	GUEST_ASSERT(timer_get_tval(timer) < 0);
> +
> +	/* tval in the past */
> +	timer_set_tval(timer, -1);
> +	if (use_sched)
> +		USERSPACE_MIGRATE_VCPU();
> +	GUEST_ASSERT(timer_get_cval(timer) < timer_get_cntct(timer));
> +
> +	/* tval larger than TVAL_MAX. */

Isn't this programming CVAL with a delta larger than what can be
expressed in TVAL?

> +	timer_set_cval(timer,
> +		       timer_get_cntct(timer) + TVAL_MAX +
> +		       msec_to_cycles(test_args.wait_ms));
> +	if (use_sched)
> +		USERSPACE_MIGRATE_VCPU();
> +	GUEST_ASSERT(timer_get_tval(timer) <= 0);
> +
> +	/*
> +	 * tval larger than 2 * TVAL_MAX.
> +	 * Twice the TVAL_MAX completely loops around the TVAL.
> +	 */

Same here. The comment calls it TVAL, but the test is programming CVAL.

> +	timer_set_cval(timer,
> +		       timer_get_cntct(timer) + 2ULL * TVAL_MAX +
> +		       msec_to_cycles(test_args.wait_ms));
> +	if (use_sched)
> +		USERSPACE_MIGRATE_VCPU();
> +	GUEST_ASSERT(timer_get_tval(timer) <=
> +		       msec_to_cycles(test_args.wait_ms));
> +
> +	/* negative tval that rollovers from 0. */
> +	set_counter(timer, msec_to_cycles(1));
> +	timer_set_tval(timer, -1 * msec_to_cycles(test_args.wait_ms));
> +	if (use_sched)
> +		USERSPACE_MIGRATE_VCPU();
> +	GUEST_ASSERT(timer_get_cval(timer) >= (CVAL_MAX - msec_to_cycles(9)));
					      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~

I'm lost. What is the significance of this expression?

I'm pretty sure the architecture allows implementers to size the CVAL
register according to the number of implemented bits in the counter. I
don't see how the case of hardware truncating the MSBs of the register
is handled here.

Looks like there's quite a lot more of this code I haven't gotten to,
but I've reached a stopping point and need to work on some other things.

-- 
Thanks,
Oliver

