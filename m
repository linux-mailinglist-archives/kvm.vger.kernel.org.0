Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1559D670B80
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 23:14:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbjAQWOf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 17:14:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbjAQWOC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 17:14:02 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED4E247ED9
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 12:43:40 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id d9so34742670pll.9
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 12:43:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=G0p5tYXhYSLxtIPDRJH8NwfoKuO4FTadATNlTkpg1R0=;
        b=X8al8sYl95OrHmh4lq3bYRT3wioJ0cMOz69pGVemf9qvs5eGMWkATvVYEONUIhSNqK
         v45kvAs005FbhqmlCSEZRKitWGCtgHNoO3Y5m0kvtDJOBBiQE4N4p8F98c0fuUW1bVKE
         KK0QanhBAyabsq0CGWcX+w4t/yEaJtHGgrrDszICLY04HiOssMgJiDnn0gn1JNRQGwIK
         FIecSn14G/JzBariHtKHN+h7vBmrTRLt84Q5rF/+Vjus+9/pLv19klESxUAFHzSjjvUY
         p0J55puxupqIj+pJtDgWtpqllg3A5NFWYivucvgzO8vHL+tXG92NX2GoFjN4IOJWXKRp
         7KpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G0p5tYXhYSLxtIPDRJH8NwfoKuO4FTadATNlTkpg1R0=;
        b=FLjHkXD8oZFtBDPjiFOWXrcPoIOxdnWelpQj14dbwyr9oAXLeh6HIdTeeAEy0FpHiw
         mKd8s6OZZy+Mrt/rPTMAGx7n8578s0WOoXsIczO7uux7XxMYpvFKwd2mrfJwsKWlaHdg
         LrLRjU/bYCqoz1cLb34C+Q3cTr6NABfHyc32mffg77BM6yHpyXNc4KzW1+ILd5ilOGr9
         LYzW5xeKMhEbzEbYzV5VOoX+Q5CZmTv9DpGmAQRaUSsgMJlO6U7F2oAlQxaHak5Xu2WP
         61RlgKw1HWwIpgeO4Vs9jkrI0qKGTrKR/KyIthYAJeAfwHpePpNwLyd5hjU2psBtCG7X
         ZV4w==
X-Gm-Message-State: AFqh2krRXXxk7SbJrrMbeym0DAC7q/8fudT6d3jFgYK6F86QdxV0wg5O
        af+TF0j73qz+ocMiIzyIgc2hsw==
X-Google-Smtp-Source: AMrXdXvSzFoxX26S728cFKqYUWcTrxOpqcISFLk3ezBV9XhQi288snWt+UvU5s+8yNJEWltXIs92KA==
X-Received: by 2002:a17:90b:3941:b0:225:e761:6d2b with SMTP id oe1-20020a17090b394100b00225e7616d2bmr2730770pjb.1.1673988219719;
        Tue, 17 Jan 2023 12:43:39 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id fa21-20020a17090af0d500b00223f495dc28sm19200323pjb.14.2023.01.17.12.43.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 12:43:39 -0800 (PST)
Date:   Tue, 17 Jan 2023 12:43:35 -0800
From:   Ricardo Koller <ricarkol@google.com>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        dmatlack@google.com, seanjc@google.com, bgardon@google.com,
        oupton@google.com
Subject: Re: [PATCH 2/3] KVM: selftests: Collect memory access latency samples
Message-ID: <Y8cIdxp5k8HivVAe@google.com>
References: <20221115173258.2530923-1-coltonlewis@google.com>
 <20221115173258.2530923-3-coltonlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221115173258.2530923-3-coltonlewis@google.com>
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

On Tue, Nov 15, 2022 at 05:32:57PM +0000, Colton Lewis wrote:
> Collect memory access latency measured in clock cycles.
> 
> This introduces a dependency on the timers for ARM and x86. No other
> architectures are implemented and their samples will all be 0.
> 
> Because keeping all samples is impractical due to the space required
> in some cases (pooled memory w/ 64 vcpus would be 64 GB/vcpu * 64
> vcpus * 250,000 samples/GB * 8 bytes/sample ~ 8 Gb extra memory just
> for samples), resevior sampling is used to only keep a small number of

nit: reservoir

> samples per vcpu (1000 samples in this patch).

Didn't see this before my previous comment. But, I guess it still
applies: isn't it possible to know the number of events to store?  to
avoid the "100" obtained via trial and error.

> 
> Resevoir sampling means despite keeping only a small number of
> samples, each sample has an equal chance of making it to the
> resevoir. Simple proofs of this can be found online. This makes the
> resevoir a good representation of the distribution of samples and

reservoir

> enables calculation of reasonably accurate percentiles.
> 
> All samples are stored in a statically allocated flat array for ease
> of combining them later. Samples are stored at an offset in this array
> calculated by the vcpu index (so vcpu 5 sample 10 would be stored at
> address sample_times + 5 * vcpu_idx + 10).
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---
>  .../selftests/kvm/lib/perf_test_util.c        | 34 +++++++++++++++++--
>  1 file changed, 32 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
> index a48904b64e19..0311da76bae0 100644
> --- a/tools/testing/selftests/kvm/lib/perf_test_util.c
> +++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
> @@ -4,6 +4,9 @@
>   */
>  #include <inttypes.h>
>  
> +#if defined(__aarch64__)
> +#include "aarch64/arch_timer.h"
> +#endif
>  #include "kvm_util.h"
>  #include "perf_test_util.h"
>  #include "processor.h"
> @@ -44,6 +47,18 @@ static struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
>  /* Store all samples in a flat array so they can be easily sorted later. */
>  uint64_t latency_samples[SAMPLE_CAPACITY];
>  
> +static uint64_t perf_test_timer_read(void)
> +{
> +#if defined(__aarch64__)
> +	return timer_get_cntct(VIRTUAL);
> +#elif defined(__x86_64__)
> +	return rdtsc();
> +#else
> +#warn __func__ " is not implemented for this architecture, will return 0"
> +	return 0;
> +#endif
> +}
> +
>  /*
>   * Continuously write to the first 8 bytes of each page in the
>   * specified region.
> @@ -59,6 +74,10 @@ void perf_test_guest_code(uint32_t vcpu_idx)
>  	int i;
>  	struct guest_random_state rand_state =
>  		new_guest_random_state(pta->random_seed + vcpu_idx);
> +	uint64_t *latency_samples_offset = latency_samples + SAMPLES_PER_VCPU * vcpu_idx;
> +	uint64_t count_before;
> +	uint64_t count_after;
> +	uint32_t maybe_sample;
>  
>  	gva = vcpu_args->gva;
>  	pages = vcpu_args->pages;
> @@ -75,10 +94,21 @@ void perf_test_guest_code(uint32_t vcpu_idx)
>  
>  			addr = gva + (page * pta->guest_page_size);
>  
> -			if (guest_random_u32(&rand_state) % 100 < pta->write_percent)
> +			if (guest_random_u32(&rand_state) % 100 < pta->write_percent) {
> +				count_before = perf_test_timer_read();
>  				*(uint64_t *)addr = 0x0123456789ABCDEF;
> -			else
> +				count_after = perf_test_timer_read();
> +			} else {
> +				count_before = perf_test_timer_read();
>  				READ_ONCE(*(uint64_t *)addr);
> +				count_after = perf_test_timer_read();

"count_before ... ACCESS count_after" could be moved to some macro,
e.g.,:
	t = MEASURE(READ_ONCE(*(uint64_t *)addr));

> +			}
> +
> +			maybe_sample = guest_random_u32(&rand_state) % (i + 1);
> +			if (i < SAMPLES_PER_VCPU)
> +				latency_samples_offset[i] = count_after - count_before;
> +			else if (maybe_sample < SAMPLES_PER_VCPU)
> +				latency_samples_offset[maybe_sample] = count_after - count_before;

I would prefer these reservoir sampling details to be in a helper, 
e.g.,:
	reservoir_sample_record(t, i);

>  		}
>  
>  		GUEST_SYNC(1);
> -- 
> 2.38.1.431.g37b22c650d-goog
> 
