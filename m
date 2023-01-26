Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE9B67D3AD
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 19:01:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230455AbjAZSBA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 13:01:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbjAZSA6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 13:00:58 -0500
Received: from mail-oa1-x49.google.com (mail-oa1-x49.google.com [IPv6:2001:4860:4864:20::49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1A664B765
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 10:00:57 -0800 (PST)
Received: by mail-oa1-x49.google.com with SMTP id 586e51a60fabf-1631f1eb91aso828265fac.18
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 10:00:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=gltqiiCHiqHTiyoTnuQZd66WC1FXO8sWVT1wNpsgQ3U=;
        b=Zup1pPLsDMoJel8LOh50lybwtunuDvo4erYKoGrFn2mLQB5ufTbMv2+QzL1gsEv2F0
         la7XGNJ16BA9ndJmfzrHsfJW1OAR142jX98yuyq7XGHDDzx+Q+S6t4GH1vjBW0F6ej0P
         3YX3Qd0NAWl1rT7+58SsWbpSAxmzAfbVMLpgQrww62eEoa89zP4j4cCtue2QQy4Od7M1
         4GVd3tVj3snjq2eXf9Rs4/76GriH94XG+d5ByMzNqSduSzpsXVuBMfufBqoHrvKZxIng
         NfGnMf4+vSaZcqCMKEnCIDLu0VUiCd8ijX87eHSZ7wYfJXTK5qTQRMY9k/tH4Tqss25l
         PMQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gltqiiCHiqHTiyoTnuQZd66WC1FXO8sWVT1wNpsgQ3U=;
        b=IF2kRJ+GYNCzuDQ7EO4QyJDG4PSyucLJi5gE6AYMb9j+vvmXlKYUx05y1GZnNX3y4I
         A9+rC74nT23tt34ic5JaTcBsRcNXpY5MIlNRCRvqzARIq5x51y6qbkzfV+fs7+4SisHb
         Uhe+7Sb987aIiAKAfJri+VxDVRNtsSZ2NjXEFsOhOOWxDQ9rgrdJG4+6V6SGXXnqNmjo
         /zUyfp8KeCmRlNxwN5XuGcfkN8isplJqkudbE67I6EoOq74Vjaqiz2Z/4VpFdsU20kRx
         rOzKRTJl5pXbkuglAzAe8P1ygP1IPL9vAOEDd5dssweGb22+UzYkpARrcvLnBSsourg6
         jgNQ==
X-Gm-Message-State: AFqh2kozFhz47kVhSQntO6lM7MRoHCa1Aujxc6AfQJLMrbk5X5bw0Pij
        mwUaKMFN6xmUV7/pbOUNRZ9pYTYLTzJiMHOicA==
X-Google-Smtp-Source: AMrXdXuEr+OqYOKef3BkHUu+R1a9KM3AGxJHpApAX6xKQV7VbFCUmQDixkwxQ4oPSDMsHnUdCCJyoVXgjEMBl/gXnQ==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a9d:6385:0:b0:686:47e7:ab87 with SMTP
 id w5-20020a9d6385000000b0068647e7ab87mr2272922otk.53.1674756056144; Thu, 26
 Jan 2023 10:00:56 -0800 (PST)
Date:   Thu, 26 Jan 2023 18:00:55 +0000
In-Reply-To: <Y8gfOP5CMXK60AtH@google.com> (message from Sean Christopherson
 on Wed, 18 Jan 2023 16:32:56 +0000)
Mime-Version: 1.0
Message-ID: <gsnta625qip4.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH 2/3] KVM: selftests: Collect memory access latency samples
From:   Colton Lewis <coltonlewis@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     ricarkol@google.com, kvm@vger.kernel.org, pbonzini@redhat.com,
        maz@kernel.org, dmatlack@google.com, bgardon@google.com,
        oupton@google.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:
> On Tue, Jan 17, 2023, Ricardo Koller wrote:
>> On Tue, Nov 15, 2022 at 05:32:57PM +0000, Colton Lewis wrote:
>> > @@ -44,6 +47,18 @@ static struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
>> >  /* Store all samples in a flat array so they can be easily sorted  
>> later. */
>> >  uint64_t latency_samples[SAMPLE_CAPACITY];
>> >
>> > +static uint64_t perf_test_timer_read(void)
>> > +{
>> > +#if defined(__aarch64__)
>> > +	return timer_get_cntct(VIRTUAL);
>> > +#elif defined(__x86_64__)
>> > +	return rdtsc();
>> > +#else
>> > +#warn __func__ " is not implemented for this architecture, will  
>> return 0"
>> > +	return 0;
>> > +#endif
>> > +}

> I would prefer to put the guest-side timer helpers into common code, e.g.  
> as
> guest_read_system_counter(), replacing system_counter_offset_test.c's  
> one-off
> version.

Will do.

>> >  /*
>> >   * Continuously write to the first 8 bytes of each page in the
>> >   * specified region.
>> > @@ -59,6 +74,10 @@ void perf_test_guest_code(uint32_t vcpu_idx)
>> >  	int i;
>> >  	struct guest_random_state rand_state =
>> >  		new_guest_random_state(pta->random_seed + vcpu_idx);
>> > +	uint64_t *latency_samples_offset = latency_samples +  
>> SAMPLES_PER_VCPU * vcpu_idx;

> "offset" is confusing because the system counter (TSC in x86) has an  
> offset for
> the guest-perceived value.  Maybe just "latencies"?

Will do.

>> > +	uint64_t count_before;
>> > +	uint64_t count_after;

> Maybe s/count/time?  Yeah, it's technically wrong to call it "time",  
> but "count"
> is too generic.

I could say "cycles".

>> > +	uint32_t maybe_sample;
>> >
>> >  	gva = vcpu_args->gva;
>> >  	pages = vcpu_args->pages;
>> > @@ -75,10 +94,21 @@ void perf_test_guest_code(uint32_t vcpu_idx)
>> >
>> >  			addr = gva + (page * pta->guest_page_size);
>> >
>> > -			if (guest_random_u32(&rand_state) % 100 < pta->write_percent)
>> > +			if (guest_random_u32(&rand_state) % 100 < pta->write_percent) {
>> > +				count_before = perf_test_timer_read();
>> >  				*(uint64_t *)addr = 0x0123456789ABCDEF;
>> > -			else
>> > +				count_after = perf_test_timer_read();
>> > +			} else {
>> > +				count_before = perf_test_timer_read();
>> >  				READ_ONCE(*(uint64_t *)addr);
>> > +				count_after = perf_test_timer_read();

>> "count_before ... ACCESS count_after" could be moved to some macro,
>> e.g.,:
>> 	t = MEASURE(READ_ONCE(*(uint64_t *)addr));

> Even better, capture the read vs. write in a local variable to  
> self-document the
> use of the RNG, then the motivation for reading the system counter inside  
> the
> if/else-statements goes away.  That way we don't need to come up with a  
> name
> that documents what MEASURE() measures.

> 			write = guest_random_u32(&rand_state) % 100 < args->write_percent;

> 			time_before = guest_system_counter_read();
> 			if (write)
> 				*(uint64_t *)addr = 0x0123456789ABCDEF;
> 			else
> 				READ_ONCE(*(uint64_t *)addr);
> 			time_after = guest_system_counter_read();

Couldn't timing before and after the if statement produce bad
measurements? We might be including a branch mispredict in our memory
access latency and this could happen a lot because it's random so no way
for the CPU to predict.

>> > +			}
>> > +
>> > +			maybe_sample = guest_random_u32(&rand_state) % (i + 1);

> No need to generate a random number for iterations that always sample.   
> And I
> think it will make the code easier to follow if there is a single write  
> to the
> array.  The derivation of the index is what's interesting and different,  
> we should
> use code to highlight that.

> 			/*
> 			 * Always sample early iterations to ensure at least the
> 			 * number of requested samples is collected.  Once the
> 			 * array has been filled, <here is a comment from Colton
> 			 * briefly explaining the math>.
> 			 *
> 			if (i < SAMPLES_PER_VCPU)
> 				idx = i;
> 			else
> 				idx = guest_random_u32(&rand_state) % (i + 1);

> 			if (idx < SAMPLES_PER_VCPU)
> 				latencies[idx] = time_after - time_before;

Will do.

>> > +			if (i < SAMPLES_PER_VCPU)

> Would it make sense to let the user configure the number of samples?   
> Seems easy
> enough and would let the user ultimately decide how much memory to burn  
> on samples.

Theoretically users may wish to tweak the accuracy vs memory use
tradeoff. Seemed like a shakey value proposition to me because of
diminishing returns to increased accuracy, but I will include an option
if you insist.

>> > +				latency_samples_offset[i] = count_after - count_before;
>> > +			else if (maybe_sample < SAMPLES_PER_VCPU)
>> > +				latency_samples_offset[maybe_sample] = count_after - count_before;

>> I would prefer these reservoir sampling details to be in a helper,
>> e.g.,:
>> 	reservoir_sample_record(t, i);

> Heh, I vote to open code the behavior.  I dislike fancy names that hide  
> relatively
> simple logic.  IMO, readers won't care how the modulo math provides even  
> distribution,
> just that it does and that the early iterations always samples to ensure  
> ever bucket
> is filled.

> In this case, I can pretty much guarantee that I'd end up spending more  
> time
> digging into what "reservoir" means than I would to understand the basic  
> flow.
I agree. Logic is simple enough more names will confuse as to what's
really happening.
