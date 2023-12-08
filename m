Return-Path: <kvm+bounces-3970-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BC9180AE79
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 22:02:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 762BCB20BF7
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 21:01:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5ABFE5731B;
	Fri,  8 Dec 2023 21:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VL0f+g8/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-x249.google.com (mail-oi1-x249.google.com [IPv6:2607:f8b0:4864:20::249])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C73B1AD
	for <kvm@vger.kernel.org>; Fri,  8 Dec 2023 13:01:48 -0800 (PST)
Received: by mail-oi1-x249.google.com with SMTP id 5614622812f47-3b9e506f794so2510935b6e.0
        for <kvm@vger.kernel.org>; Fri, 08 Dec 2023 13:01:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702069308; x=1702674108; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ohHL4NM1dI6UZbQFn0jebt7/vn+02U2BOD5/z3Rzxz0=;
        b=VL0f+g8/SxDrMBwX/qWGXmNbrIs0vXOBrqzjpnr8nvWBfv+/Fvi/GoEGBpi3W9oKK6
         p/mNt3Doh3+fEOEDPXJg5WBKEfaOdlLS4F8zVIC5ldmaZPRi38b8jxknAy2t17kK/4DO
         7fV7eh9/oKf+cSFYQtwnDZqrJBG4bKtgpnpj4/cXKgIpr09t8z6AsSGwdmweJipKvxdA
         sBJS8SfLsgKdMTxScj8+LpwqsuhkUqur16hC/pRtvB8fx5cGKhok0QSAtT0FBcIBd1pQ
         uqm6CV02K9h131wjUzajVIYAcF5Z07G58j2Ah6pnWoNthfmikxvGE77HpmNTFkcE7pP7
         vizw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702069308; x=1702674108;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ohHL4NM1dI6UZbQFn0jebt7/vn+02U2BOD5/z3Rzxz0=;
        b=BSimtvkBVbeTUGJvEFRDNiPuIRuR6yQUfrij1EhL2YZMecIxg0UE3KdpUKyk7/OkVz
         ZVvkcbleDTJzvlqxX/IKUpvdvzSXdEUfs+OPVTLqkU1S1vzraGTwynkM73HyuC34rqfW
         80uoxlgn/dRyWi0o8oyk6E/6Pwsb5cMNUz/Asn7kVgYsNQ+vGYC3zftUCTQ7lbyxgNDH
         03g4Ql5CC/5Foq3m9WUfijbuZ/ndtcwi59g2HPBjM+xCIpAE5PvBXXSpuHoimtSZyYg/
         eQuJvloG6ciPufJcf/51zuN46jmT9pIfTcDLIeAHCGiRddJ0EjC6n80ucvmci8rxb271
         Tu5A==
X-Gm-Message-State: AOJu0YxLnGslR+vhQmBPAFN0Ey5ludRJ2/B5BSCEW+DbTjKLWW0JSrO2
	ySXFJ1g8rM1dRt6M6MfN5Du6d9jLIH+CRvykxQ==
X-Google-Smtp-Source: AGHT+IELZjT2Wb1/8dctSZAreeasawPBnDaNpQW+qkpJUycV+LVE0RilDB7Q/Mb5eCw0jV27bIHw5D3hDJBu8OFFng==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6808:17a6:b0:3b9:bcdd:c192 with
 SMTP id bg38-20020a05680817a600b003b9bcddc192mr594339oib.6.1702069307938;
 Fri, 08 Dec 2023 13:01:47 -0800 (PST)
Date: Fri, 08 Dec 2023 21:01:47 +0000
In-Reply-To: <ZV5j5By1o6aFnrbV@linux.dev> (message from Oliver Upton on Wed,
 22 Nov 2023 20:26:12 +0000)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <gsnt5y18v26c.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v3 3/3] KVM: arm64: selftests: Add arch_timer_edge_cases selftest
From: Colton Lewis <coltonlewis@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, maz@kernel.org, james.morse@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, ricarkol@google.com, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Oliver Upton <oliver.upton@linux.dev> writes:

> On Fri, Nov 03, 2023 at 07:29:15PM +0000, Colton Lewis wrote:
>> +enum sync_cmd {
>> +	SET_REG_KVM_REG_ARM_TIMER_CNT = 100001,

> nit: Why not call it SET_COUNTER_VALUE? Also, what's the reason for the
> magic starting value here?

No reason I'm aware of other than it was that way before I took over.

>> +#define for_each_wfi_method(i)							\
>> +	for ((i) = 0; (i) < ARRAY_SIZE(wfi_method); (i)++)
>> +
>> +#define for_each_sleep_method(i)						\
>> +	for ((i) = 0; (i) < ARRAY_SIZE(sleep_method); (i)++)

> I don't see a tremendous amount of value in using iterators for these
> arrays, especially since the caller is still directly referencing the
> underlying arrays to get at the element anyway.

Easy enough to change.

>> +enum timer_view {
>> +	TIMER_CVAL = 1,

> Again, when I read an enumeration with an explicit starting value, I
> assume that there is a functional reason for it.

Not this time. I'll change it.

>> +#define IAR_SPURIOUS		1023
>> +

> Isn't this already defined in gic.h?

It is.

>> +static void set_counter(enum arch_timer timer, uint64_t counter)
>> +{
>> +	GUEST_SYNC_ARGS(SET_REG_KVM_REG_ARM_TIMER_CNT, counter, timer, 0, 0);
>> +}

> Why do some of the ucall helpers use macros and this one is done as a
> function? You should avoid using macros unless you're actually doing
> something valuable with the preprocessor.

I agree that's an inconsistency and it would be better to make them all
functions.

>> +static uint32_t next_pcpu(void)
>> +{
>> +	uint32_t max = get_nprocs();
>> +	uint32_t cur = sched_getcpu();
>> +	uint32_t next = cur;
>> +	cpu_set_t cpuset;
>> +
>> +	TEST_ASSERT(max > 1, "Need at least two physical cpus");
>> +
>> +	sched_getaffinity(getpid(), sizeof(cpuset), &cpuset);

> Can you just pass 0 here for the pid? Forgive me if I'm getting my wires
> crossed, but isn't this going to return the last cpuset you've written in
> migrate_self()? In that case it would seem you'll always select the same
> CPU.

I checked and I can pass 0. You are right that it will select the last
cpuset written in migrate_self, but that is not always the
same. next_pcpu() uses the current cpuset to calculate the next cpu to
migrate to (current scheme just rotates through all cpus in ascending
order). To migrate, the test calls migrate_self(next_pcpu()), so it
should advance the cpuset to the next cpu every time migrate_self is
called.

> Also, it would seem that the test isn't pinning to a particular CPU in
> the beginning. In that case CPU migrations can happen _at any time_ and
> are not being precisely controlled by the test. Is this intentional?

This appears to be an oversight on my part. I did have a pin at the
beginning before but it must have been deleted when I shuffled some code
around.

>> +		gic_wfi();
>> +		local_irq_enable();
>> +		isb();
>> +		/* handle IRQ */
>> +		local_irq_disable();

> Same nitpick about comment placement here. The isb *is* the context
> synchronization event that precipitates the imaginary window where
> pending interrupts are taken.

Strictly speaking by ARM ref manual (DDI 0487J.a D1.3.6 table entry for
R_RBZYL), "interrupt is taken before the first instruction **after**
context synchronization event".

But I don't mind just putting the comment to the right of the isb.

>> + * Wait for an non-spurious IRQ by polling in the guest (userspace=0)  
>> or in
>> + * userspace (e.g., userspace=1 and  
>> userspace_cmd=USERSPACE_SCHED_YIELD).
> 		       ^~~~~~~~~~~

> More magic values. What is this?

In this case it's 1 and 0 representing true and false. Seems like a
standard Cism to me but I can make it more clear.

>> +	local_irq_enable();
>> +	while (h == atomic_read(&shared_data.handled)) {
>> +		if (userspace_cmd == NO_USERSPACE_CMD)
>> +			cpu_relax();
>> +		else
>> +			USERSPACE_CMD(userspace_cmd);
>> +	}
>> +	local_irq_disable();

> cpu_relax(), or rather the yield instruction, is not a context
> synchronization event.

I agree it's not, but I don't think it matters. We are just waiting for
an interrupt. Context will catch up eventually.

>> +/* Test masking/unmasking a timer using the timer mask (not the IRQ  
>> mask). */
>> +static void test_timer_control_mask_then_unmask(enum arch_timer timer)
>> +{
>> +	reset_timer_state(timer, DEF_CNT);
>> +	set_tval_irq(timer, -1, CTL_ENABLE | CTL_IMASK);
>> +
>> +	/* No IRQs because the timer is still masked. */
>> +	ASSERT_IRQS_HANDLED(0);

> This seems to assume both the timer hardware and GIC are capable of
> getting the interrupt to the CPU in just a few cycles.

> Oh wait, that's exactly what test_timer_control_masks() is doing...
> What's the point of this then?

I agree the point of this test is something else so the
ASSERT_IRQS_HANDLED(0) is duplicating test_timer_control_masks

>> +static void test_fire_a_timer_multiple_times(enum arch_timer timer,
>> +					     wfi_method_t wm, int num)
>> +{
>> +	int i;
>> +
>> +	local_irq_disable();
>> +	reset_timer_state(timer, DEF_CNT);
>> +
>> +	set_tval_irq(timer, 0, CTL_ENABLE);
>> +
>> +	for (i = 1; i <= num; i++) {
>> +		wm();

> wfi_method_t is such a misnomer. Critically, it masks/unmasks IRQs which
> is rather hard to remember once you're this deep into the test code. At
> least having some comments on what wfi_method_t is expected to do would
> help a bit.

I agree a better name is called for there. How about irq_wait_method_t?
That better hints what it is doing with irqs.

>> +/*
>> + * Set a timer for tval=d_1_ms then reprogram it to tval=d_2_ms. Check  
>> that we
>> + * get the timer fired. There is no timeout for the wait: we use the wfi
>> + * instruction.
>> + */
>> +static void test_reprogramming_timer(enum arch_timer timer,  
>> wfi_method_t wm,
>> +				     int32_t d_1_ms, int32_t d_2_ms)
>> +{
>> +	local_irq_disable();
>> +	reset_timer_state(timer, DEF_CNT);
>> +
>> +	/* Program the timer to DEF_CNT + d_1_ms. */
>> +	set_tval_irq(timer, msec_to_cycles(d_1_ms), CTL_ENABLE);

> This assumes that the program doesn't get preempted for @d_1_ms here,
> right?

No? Where are you getting that?

>> +	guest_sleep(timer, msecs_to_usecs(d_2_ms) + TEST_MARGIN_US);

> Even more magic values. What is the difference between TEST_MARGIN_US
> and TIMEOUT_NO_IRQ_US?

Seems like they serve the same purpose and should be unified.

>> +static void test_reprogram_timers(enum arch_timer timer)
>> +{
>> +	int i;
>> +	uint64_t base_wait = test_args.wait_ms;
>> +
>> +	for_each_wfi_method(i) {
>> +		test_reprogramming_timer(timer, wfi_method[i], 2 * base_wait,
>> +					 base_wait);
>> +		test_reprogramming_timer(timer, wfi_method[i], base_wait,
>> +					 2 * base_wait);

> What is the value of changing around the two timer deltas? It is
> entirely unclear from reading this what potential edge case it is
> detecting.

It's ensuring the timer is reprogrammed correctly whether going from a
longer to a shorter delta or shorter to longer. I can comment on that.

>> +/*
>> + * This test checks basic timer behavior without actually firing  
>> timers, things
>> + * like: the relationship between cval and tval, tval down-counting.
>> + */
>> +static void timers_sanity_checks(enum arch_timer timer, bool use_sched)
>> +{
>> +	reset_timer_state(timer, DEF_CNT);
>> +
>> +	local_irq_disable();
>> +
>> +	/* cval in the past */
>> +	timer_set_cval(timer,
>> +		       timer_get_cntct(timer) -
>> +		       msec_to_cycles(test_args.wait_ms));
>> +	if (use_sched)
>> +		USERSPACE_MIGRATE_VCPU();
>> +	GUEST_ASSERT(timer_get_tval(timer) < 0);
>> +
>> +	/* tval in the past */
>> +	timer_set_tval(timer, -1);
>> +	if (use_sched)
>> +		USERSPACE_MIGRATE_VCPU();
>> +	GUEST_ASSERT(timer_get_cval(timer) < timer_get_cntct(timer));
>> +
>> +	/* tval larger than TVAL_MAX. */

> Isn't this programming CVAL with a delta larger than what can be
> expressed in TVAL?

Yes. If the value is not expressible by TVAL (greater than INT_MAX),
then it won't work with the timer_set_tval function and has to be
programmed with timer_set_cval.

>> +	/*
>> +	 * tval larger than 2 * TVAL_MAX.
>> +	 * Twice the TVAL_MAX completely loops around the TVAL.
>> +	 */

> Same here. The comment calls it TVAL, but the test is programming CVAL.

Same response.

>> +	/* negative tval that rollovers from 0. */
>> +	set_counter(timer, msec_to_cycles(1));
>> +	timer_set_tval(timer, -1 * msec_to_cycles(test_args.wait_ms));
>> +	if (use_sched)
>> +		USERSPACE_MIGRATE_VCPU();
>> +	GUEST_ASSERT(timer_get_cval(timer) >= (CVAL_MAX - msec_to_cycles(9)));
> 					      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~

> I'm lost. What is the significance of this expression?

Good question. I'll have to think about that one some more.

> I'm pretty sure the architecture allows implementers to size the CVAL
> register according to the number of implemented bits in the counter. I
> don't see how the case of hardware truncating the MSBs of the register
> is handled here.

I'm pretty sure the CVAL register is always 64 bits regardless of the
number of implemented counter bits.

> Looks like there's quite a lot more of this code I haven't gotten to,
> but I've reached a stopping point and need to work on some other things.

Thanks. I can see you put a lot of time and effort into a thoughtful
critique and I realize there are some frustrating aspects of this code I
have not fully removed yet.

