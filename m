Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2D967D516
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 20:08:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232365AbjAZTIF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 14:08:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232440AbjAZTID (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 14:08:03 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7940C1E1D2
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 11:07:55 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id m7-20020a17090a71c700b0022c0c070f2eso5578515pjs.4
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 11:07:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/b2RpfD8fG8WLI9XPQ7eGkyQHXVPoq9gZZ4Kaejz9m8=;
        b=OBmf9imA7xG0lz+LQ5ZUKVSI+MiEnwzIC0YxUumGBRxC5lzURUkl4wg3pb2yJ2Ds+7
         UouY6hgEL8unP9KWKre6LXO97kqItFOogUvoRjCbppM5/8KEkHSBh/Y05SPoyrYLl/CR
         p/v4l9qNhSM3zeEmRikaxdBRgV9szniQr7NAsb90FTnAdJe3HL31Dynmrt69IDRRVvbp
         ZQwMDajNZV0fA2ZjGPmharTksixQFmXVc9P7gQjPWJiUYZZ6CWpJhWCas+fiUoge/p9x
         ZPiijLS4vQhIJabG0E0paBaLC773CdTDVhl7InI07a4pvI6ILaQvli2xgmH3U/92sDrK
         FH/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/b2RpfD8fG8WLI9XPQ7eGkyQHXVPoq9gZZ4Kaejz9m8=;
        b=MUAayF7NPMTFs1mNePaASflRJsGozHwobuxo534ZQpqQkwnUCTPl7wdmv6KHD3WNUP
         OBt4tjNVm2zED2lLC3Xn4tfFA9WJ3EnC28hzZZl7KA7V210+YMASB2sXctZqgoEQ/Q8x
         78BLMHlS1uxvVcijbmcU83Q9c7TyovNk57SqI+k3cWL0IF0CD/x/DicvjVRXVKY+PO3R
         d7kCdzWZ0bg6bwJssbgDcWAYJP9Lv++Kl11N24qjJSngEzK+wxXmK8gpAbspk+fRBWdf
         I5wKcjAKpG7K3G0VZZwm3jp0p1r39ge1QwrMCvGrPH4xEe98NvXYHt0knV4nVEnd0IRS
         lwzw==
X-Gm-Message-State: AO0yUKUZRkGjOawhVo+ciatqsi7UAi+WaaW/GcYJcKkhbQ3xWGwrT5lj
        eOBWTbZIy2eh+1gcmhfyw3FkkQ==
X-Google-Smtp-Source: AK7set8+SaSi03OewtlUQJqjc9hUZ+TvdXMZ4vUZdP+bnvvGCMM/ZZahhgaV/SoVJJtyTYrtBwCq2A==
X-Received: by 2002:a17:902:74c3:b0:194:6d3c:38a5 with SMTP id f3-20020a17090274c300b001946d3c38a5mr1017856plt.1.1674760074742;
        Thu, 26 Jan 2023 11:07:54 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id c9-20020a170903234900b00194ac38bc86sm1324337plh.131.2023.01.26.11.07.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jan 2023 11:07:54 -0800 (PST)
Date:   Thu, 26 Jan 2023 19:07:50 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     ricarkol@google.com, kvm@vger.kernel.org, pbonzini@redhat.com,
        maz@kernel.org, dmatlack@google.com, bgardon@google.com,
        oupton@google.com
Subject: Re: [PATCH 2/3] KVM: selftests: Collect memory access latency samples
Message-ID: <Y9LPhs1BgBA4+kBY@google.com>
References: <Y8gfOP5CMXK60AtH@google.com>
 <gsnta625qip4.fsf@coltonlewis-kvm.c.googlers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gsnta625qip4.fsf@coltonlewis-kvm.c.googlers.com>
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

On Thu, Jan 26, 2023, Colton Lewis wrote:
> Sean Christopherson <seanjc@google.com> writes:
> > Maybe s/count/time?  Yeah, it's technically wrong to call it "time", but
> > "count" is too generic.
> 
> I could say "cycles".

Works for me.

> > > > +	uint32_t maybe_sample;
> > > >
> > > >  	gva = vcpu_args->gva;
> > > >  	pages = vcpu_args->pages;
> > > > @@ -75,10 +94,21 @@ void perf_test_guest_code(uint32_t vcpu_idx)
> > > >
> > > >  			addr = gva + (page * pta->guest_page_size);
> > > >
> > > > -			if (guest_random_u32(&rand_state) % 100 < pta->write_percent)
> > > > +			if (guest_random_u32(&rand_state) % 100 < pta->write_percent) {
> > > > +				count_before = perf_test_timer_read();
> > > >  				*(uint64_t *)addr = 0x0123456789ABCDEF;
> > > > -			else
> > > > +				count_after = perf_test_timer_read();
> > > > +			} else {
> > > > +				count_before = perf_test_timer_read();
> > > >  				READ_ONCE(*(uint64_t *)addr);
> > > > +				count_after = perf_test_timer_read();
> 
> > > "count_before ... ACCESS count_after" could be moved to some macro,
> > > e.g.,:
> > > 	t = MEASURE(READ_ONCE(*(uint64_t *)addr));
> 
> > Even better, capture the read vs. write in a local variable to
> > self-document the
> > use of the RNG, then the motivation for reading the system counter
> > inside the
> > if/else-statements goes away.  That way we don't need to come up with a
> > name
> > that documents what MEASURE() measures.
> 
> > 			write = guest_random_u32(&rand_state) % 100 < args->write_percent;
> 
> > 			time_before = guest_system_counter_read();
> > 			if (write)
> > 				*(uint64_t *)addr = 0x0123456789ABCDEF;
> > 			else
> > 				READ_ONCE(*(uint64_t *)addr);
> > 			time_after = guest_system_counter_read();
> 
> Couldn't timing before and after the if statement produce bad
> measurements? We might be including a branch mispredict in our memory
> access latency and this could happen a lot because it's random so no way
> for the CPU to predict.

Hmm, I was assuming the latency due to a (mispredicted) branch would be in the
noise compared to the latency of a VM-Exit needed to handle the fault.

On the other hand, adding a common macro would be trivial, it's only the naming
that's hard.  What if we keep with the "cycles" theme and do as Ricardo suggested?
E.g. minus backslashes, this doesn't look awful.

#define MEASURE_CYCLES(x)
({
	uint64_t start;

	start = guest_system_counter_read();
	x;
	guest_system_counter_read() - start;
})



> > > > +			if (i < SAMPLES_PER_VCPU)
> 
> > Would it make sense to let the user configure the number of samples?
> > Seems easy enough and would let the user ultimately decide how much memory
> > to burn on samples.
> 
> Theoretically users may wish to tweak the accuracy vs memory use
> tradeoff. Seemed like a shakey value proposition to me because of
> diminishing returns to increased accuracy, but I will include an option
> if you insist.

It's not so much that I expect users to want better accuracy, it's that I dislike
I arbitrary magic numbers.  E.g. why 1000 and not 500 or 2000?  Especially since
the number of accesses _is_ controllable by the user.  Hmm, the other thing to
consider is that, as proposed, the vast majority of the capacity will go unused,
e.g. default is 4, max is 512 (and that should really be tied to KVM's max of 4096).

What if we invert the calculation and define the capacity in bytes, and derive
the number of samples based on capacity / nr_vcpus?  And then push the capacity
as high as possible, e.g. I assume there's a threshold where the test will fail
because of selftests poor page table management.  That way the sampling is as
efficient as possible, and the arbitrary capacity comes from limitations within
the framework, as opposed to a human defined magic number.
