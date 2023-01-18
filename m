Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60784672370
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 17:35:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbjARQfS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 11:35:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjARQet (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 11:34:49 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D430E42BF5
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 08:33:01 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id 200so20450781pfx.7
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 08:33:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Yd14vaBNEa2VdUUX04j7MB+x+aVbgeBsn031i62frpo=;
        b=MkJ1nRlQQc56TlQw/B8iyg0XuaJCEI+loMFojrHN9fb93nCKQp/Gx6XaofKwXphiMR
         RZcgonYkp76SLOeuLy49IKpSfhzH/FdqbOSJY1u66v8ohFPYynxlnM5Tim+2Vmv3piIO
         6xdutg3tiJ7a8+PCuYJ1WWOnkxzbGQqlDprpGZMxVJA+oVE1wCTdRZZgVSfkHXTPMigq
         Z2P4JVrEcAsk5T/9LdCGaRTneaj17BQOKv5hmV6/5kb+DleBTa6GKA+SPGHEqTYv3D4J
         oXEc9wloOH3kV3yPQ+4bB79j6xEmOc6nqDOhBZ9cFXzrmeit1Cibfd/edSxsqGT7foq9
         XUtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yd14vaBNEa2VdUUX04j7MB+x+aVbgeBsn031i62frpo=;
        b=qWyeCadcVZtbWbPtKmFroVWW8APDfdSI/S5wVITc4UVR0mGs4JA3Hms7h8fXbv/9UQ
         N5wF9O0ep9DOtAcicPp+J8Uf3BP20vVeisBGYIOZ2eUinxvTrkE/k59DZjMRd2FLvenD
         2cyJ+/1iNeFQT+ZVaJb436Y/aEOAs5GEJ/pZB1nxv0kwHOjupcq4VyOx8HJx5fg+uhtR
         +W/xYgO5CvWukgpUgv/x325aW92uaInd4AIaHphto/xdn0p3Ig7WL4RnG5S5UaybU1az
         fFrtJ8OcGWoAgPi0VgkhucDYojKpI9tiNWZwr6mNZljdY9NrbWvLwnxfl8QQuHQob90R
         yAaQ==
X-Gm-Message-State: AFqh2kr8/0uSK3LNsSbdwP6UOf/4UhydAkMoHSXcZv2HObaFvGkpy7r9
        Ve+j91Iaetu/MH2FO+6jKFQaXg==
X-Google-Smtp-Source: AMrXdXsg5r+DwGfdUsJJ0nWziK0avTzB5xuHBfANRrI2JaS9rdLq83+n477EJ5XOh+Rv/wjOE4zK8Q==
X-Received: by 2002:a05:6a00:368a:b0:581:bfac:7a52 with SMTP id dw10-20020a056a00368a00b00581bfac7a52mr2828384pfb.1.1674059581080;
        Wed, 18 Jan 2023 08:33:01 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 3-20020a620503000000b00582bdaab584sm13399073pff.81.2023.01.18.08.32.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 08:32:59 -0800 (PST)
Date:   Wed, 18 Jan 2023 16:32:56 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     Colton Lewis <coltonlewis@google.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, maz@kernel.org, dmatlack@google.com,
        bgardon@google.com, oupton@google.com
Subject: Re: [PATCH 2/3] KVM: selftests: Collect memory access latency samples
Message-ID: <Y8gfOP5CMXK60AtH@google.com>
References: <20221115173258.2530923-1-coltonlewis@google.com>
 <20221115173258.2530923-3-coltonlewis@google.com>
 <Y8cIdxp5k8HivVAe@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8cIdxp5k8HivVAe@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 17, 2023, Ricardo Koller wrote:
> On Tue, Nov 15, 2022 at 05:32:57PM +0000, Colton Lewis wrote:
> > @@ -44,6 +47,18 @@ static struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
> >  /* Store all samples in a flat array so they can be easily sorted later. */
> >  uint64_t latency_samples[SAMPLE_CAPACITY];
> >  
> > +static uint64_t perf_test_timer_read(void)
> > +{
> > +#if defined(__aarch64__)
> > +	return timer_get_cntct(VIRTUAL);
> > +#elif defined(__x86_64__)
> > +	return rdtsc();
> > +#else
> > +#warn __func__ " is not implemented for this architecture, will return 0"
> > +	return 0;
> > +#endif
> > +}

I would prefer to put the guest-side timer helpers into common code, e.g. as
guest_read_system_counter(), replacing system_counter_offset_test.c's one-off
version.

> >  /*
> >   * Continuously write to the first 8 bytes of each page in the
> >   * specified region.
> > @@ -59,6 +74,10 @@ void perf_test_guest_code(uint32_t vcpu_idx)
> >  	int i;
> >  	struct guest_random_state rand_state =
> >  		new_guest_random_state(pta->random_seed + vcpu_idx);
> > +	uint64_t *latency_samples_offset = latency_samples + SAMPLES_PER_VCPU * vcpu_idx;

"offset" is confusing because the system counter (TSC in x86) has an offset for
the guest-perceived value.  Maybe just "latencies"?

> > +	uint64_t count_before;
> > +	uint64_t count_after;

Maybe s/count/time?  Yeah, it's technically wrong to call it "time", but "count"
is too generic.

> > +	uint32_t maybe_sample;
> >  
> >  	gva = vcpu_args->gva;
> >  	pages = vcpu_args->pages;
> > @@ -75,10 +94,21 @@ void perf_test_guest_code(uint32_t vcpu_idx)
> >  
> >  			addr = gva + (page * pta->guest_page_size);
> >  
> > -			if (guest_random_u32(&rand_state) % 100 < pta->write_percent)
> > +			if (guest_random_u32(&rand_state) % 100 < pta->write_percent) {
> > +				count_before = perf_test_timer_read();
> >  				*(uint64_t *)addr = 0x0123456789ABCDEF;
> > -			else
> > +				count_after = perf_test_timer_read();
> > +			} else {
> > +				count_before = perf_test_timer_read();
> >  				READ_ONCE(*(uint64_t *)addr);
> > +				count_after = perf_test_timer_read();
> 
> "count_before ... ACCESS count_after" could be moved to some macro,
> e.g.,:
> 	t = MEASURE(READ_ONCE(*(uint64_t *)addr));

Even better, capture the read vs. write in a local variable to self-document the
use of the RNG, then the motivation for reading the system counter inside the
if/else-statements goes away.  That way we don't need to come up with a name
that documents what MEASURE() measures.

			write = guest_random_u32(&rand_state) % 100 < args->write_percent;

			time_before = guest_system_counter_read();
			if (write)
				*(uint64_t *)addr = 0x0123456789ABCDEF;
			else
				READ_ONCE(*(uint64_t *)addr);
			time_after = guest_system_counter_read();

> > +			}
> > +
> > +			maybe_sample = guest_random_u32(&rand_state) % (i + 1);

No need to generate a random number for iterations that always sample.  And I
think it will make the code easier to follow if there is a single write to the
array.  The derivation of the index is what's interesting and different, we should
use code to highlight that.

			/*
			 * Always sample early iterations to ensure at least the
			 * number of requested samples is collected.  Once the
			 * array has been filled, <here is a comment from Colton
			 * briefly explaining the math>.
			 * 
			if (i < SAMPLES_PER_VCPU)
				idx = i;
			else
				idx = guest_random_u32(&rand_state) % (i + 1);

			if (idx < SAMPLES_PER_VCPU)
				latencies[idx] = time_after - time_before;

> > +			if (i < SAMPLES_PER_VCPU)

Would it make sense to let the user configure the number of samples?  Seems easy
enough and would let the user ultimately decide how much memory to burn on samples.

> > +				latency_samples_offset[i] = count_after - count_before;
> > +			else if (maybe_sample < SAMPLES_PER_VCPU)
> > +				latency_samples_offset[maybe_sample] = count_after - count_before;
> 
> I would prefer these reservoir sampling details to be in a helper, 
> e.g.,:
> 	reservoir_sample_record(t, i);

Heh, I vote to open code the behavior.  I dislike fancy names that hide relatively
simple logic.  IMO, readers won't care how the modulo math provides even distribution,
just that it does and that the early iterations always samples to ensure ever bucket
is filled.

In this case, I can pretty much guarantee that I'd end up spending more time
digging into what "reservoir" means than I would to understand the basic flow.
