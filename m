Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59C35670D85
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 00:31:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbjAQXbd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 18:31:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbjAQXaY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 18:30:24 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3473460B8
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 12:48:37 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id d3so34759030plr.10
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 12:48:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hZZXFGdIwADM32m9evq+QDZKvn8GDAia9rjafh1R0hg=;
        b=svTVmThJg6hpZh+k712R8tIAI87DgMvey/7izu8t99fem3DBPBEEq+hxo5OsxKQVFM
         bdXbeMiynlazoihR+yhSk86xL1XFKwrjMcELW9NGBKjxOj3+ak7+xJt0CA+hCG+gfdbG
         IMVA3WV2SjD0QhnKPP3hKKiANEFs9hrOihZFhwRVb3joJx4T5tbCQIfCD/ixkeTJW60i
         Hub0BaWHT3Y4r2vkqTI9P/0qgNFwwpFTt/Km1DT7yfISYpCxBDastxXqlhY4aEfeSe12
         k8sMUxgi4yaFRjTxN/GWbs49qWzDvEc9i8K7j6/eryxpq91cMtoSlGiutTd7G9U1wubS
         fEwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hZZXFGdIwADM32m9evq+QDZKvn8GDAia9rjafh1R0hg=;
        b=Ou/Nuppr2oSnHTIqW9GuBSRs4849tbZA6LVFtWn0KSQJw6TgEECCa8l6Pf4eOTQgiw
         H7hldiNwpwUg5cq93BTipBn2Tt4lemhS5dcOjLR8Yx85mfZIXKII8T2mS4Dbykr4qOt9
         KFoVap+yDk0ghtww/S5FVO7+i3yLlTEAyKXmezSC1LxhztJN+kEaMXy4ws7nfG/EodPq
         GqsPV0+pzbNMXZo0yLcp5LCivzp68/BpHrIClGphkdhHP8TzBLFQIooHUeiCfUzTzlLG
         4qb5DIcHiY8GWrQzxX4iyMdM9FIFLsQLwA6BjA9ELtaLpLj5QZSNVEiNgJolZRICANy1
         4ZUA==
X-Gm-Message-State: AFqh2krFqL8mNCiDb9j9pMc2MRca5x/2S40ArcxrZ24P7+Wkjxkpygh9
        cbCTgfrqLMRa5OKfziv/aOLBug==
X-Google-Smtp-Source: AMrXdXs9qepgXV3OE+KRLPKNSYDjhEGHcxFOelnwdwKn3vm1KAxPHIQqRya+B2uJdqZGkg8PIRFhfA==
X-Received: by 2002:a05:6a20:8f02:b0:b8:c646:b0e2 with SMTP id b2-20020a056a208f0200b000b8c646b0e2mr530645pzk.3.1673988486897;
        Tue, 17 Jan 2023 12:48:06 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id m18-20020a62a212000000b0058b540b7ffesm147205pff.29.2023.01.17.12.48.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 12:48:06 -0800 (PST)
Date:   Tue, 17 Jan 2023 12:48:03 -0800
From:   Ricardo Koller <ricarkol@google.com>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        dmatlack@google.com, seanjc@google.com, bgardon@google.com,
        oupton@google.com
Subject: Re: [PATCH 2/3] KVM: selftests: Collect memory access latency samples
Message-ID: <Y8cJg+RDLgAFrG+O@google.com>
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
> samples per vcpu (1000 samples in this patch).
> 
> Resevoir sampling means despite keeping only a small number of

Could you add a reference? I'm trying to understand the algorithm, but
I'm not even sure what's the version implemented ("Optimal: Algorithm
L"?). 

> samples, each sample has an equal chance of making it to the
> resevoir. Simple proofs of this can be found online. This makes the
> resevoir a good representation of the distribution of samples and
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
> +			}
> +
> +			maybe_sample = guest_random_u32(&rand_state) % (i + 1);
> +			if (i < SAMPLES_PER_VCPU)
> +				latency_samples_offset[i] = count_after - count_before;
> +			else if (maybe_sample < SAMPLES_PER_VCPU)
> +				latency_samples_offset[maybe_sample] = count_after - count_before;
>  		}
>  
>  		GUEST_SYNC(1);
> -- 
> 2.38.1.431.g37b22c650d-goog
> 
