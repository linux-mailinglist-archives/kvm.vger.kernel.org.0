Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 088D165DB4F
	for <lists+kvm@lfdr.de>; Wed,  4 Jan 2023 18:35:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239617AbjADRfQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Jan 2023 12:35:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235030AbjADRfO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Jan 2023 12:35:14 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B63B1AA15
        for <kvm@vger.kernel.org>; Wed,  4 Jan 2023 09:35:13 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id c2so9007583plc.5
        for <kvm@vger.kernel.org>; Wed, 04 Jan 2023 09:35:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2x3i9yoK8Ve7zDEmFZxaqev/VsMhQn2z+kyQ6bTO25c=;
        b=pgQKvl1ugcR7KxVMbYL67ZktJ+iCWwOzKji+GnD1LyBQ6rqI/ugChYTgAI8wh4ACZm
         jk5jNqEYB+eaJb24GcKH8MMw5WAt2bAfIpxaoLee+lOMhSzw11b7J8mF6laSuIKw5bKx
         qke0r7PpYwag8uZKpbyy8mybv4YLNLNDuHrGqf6BvAhu1RCKVk2ISNPdEAX1oc7hwAoM
         kZxIwFLDDr4jlc2KtbuLSkUMODqzNGp/XL10FoeWjXg16v9WeVrKkaM4l6uVWR6XpcdQ
         1cXPJ621c/q4rWgwnsYR6IG/2GHVKeyGz55o206QqBaRMPRq6AmuTIqHTu0MWdZsY0EV
         fbYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2x3i9yoK8Ve7zDEmFZxaqev/VsMhQn2z+kyQ6bTO25c=;
        b=35VEgDv55T6Hqx/YBYrE2CggCiWsurSFEmnpZ7N3A1Nq49zDZSwigpo18q6I7rBxnS
         YnTlCKoNJIBAkxDNa08h9ufC1FsHZscSbNNwO9D1duyPBrEqrhbfHAbpFRFWMvdpfeKw
         EjjWFH7dHrfKD6HgLvpIZybWwJ+ASvqa9DD+dot5ltR8xrY4jiXrceKKhqyQ/YlzKXAV
         4U+zoedUJrxEitzzK6cgVylqukPHimMHZAV6y2H+2QnGWwWdJeDLiJEySgFGvzlAAaaA
         NkgLA8YzRAwRsgdRhcNrynG/cmaqtjPXPtByGkaL9++2FNfyxau225sjbZDDPgN3JDjo
         Sqtw==
X-Gm-Message-State: AFqh2kqixbO8Ktd/keR3CTEvL5WBJZvwX8e74AiDWLHLAwoEFmfQWZkl
        jLHrfLoWpXwY6PvBefFeAMMrNg==
X-Google-Smtp-Source: AMrXdXs8MBQeS+DrPsbH+JFTOLRyub8Qig9qWltEw+Z+cg9+zeToZs/0UPvlf7PrYZI3dfGlcTaFhQ==
X-Received: by 2002:a17:90a:f2d6:b0:225:e576:a577 with SMTP id gt22-20020a17090af2d600b00225e576a577mr2444355pjb.0.1672853712364;
        Wed, 04 Jan 2023 09:35:12 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id ms6-20020a17090b234600b00213c7cf21c0sm1539273pjb.5.2023.01.04.09.35.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 09:35:11 -0800 (PST)
Date:   Wed, 4 Jan 2023 17:35:08 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH 2/2] KVM: selftests: Test the PMU event "Instructions
 retired"
Message-ID: <Y7W4zNiKVblMj1BK@google.com>
References: <20221209194957.2774423-1-aaronlewis@google.com>
 <20221209194957.2774423-3-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221209194957.2774423-3-aaronlewis@google.com>
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

On Fri, Dec 09, 2022, Aaron Lewis wrote:
> Add testing for the event "Instructions retired" (0xc0) in the PMU
> event filter on both Intel and AMD to ensure that the event doesn't
> count when it is disallowed.  Unlike most of the other events, the
> event "Instructions retired", will be incremented by KVM when an
> instruction is emulated.  Test that this case is being properly handled
> and that KVM doesn't increment the counter when that event is
> disallowed.
> 
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---
>  .../kvm/x86_64/pmu_event_filter_test.c        | 157 ++++++++++++------
>  1 file changed, 110 insertions(+), 47 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> index 2de98fce7edd..81311af9522a 100644
> --- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> @@ -54,6 +54,21 @@
>  
>  #define AMD_ZEN_BR_RETIRED EVENT(0xc2, 0)
>  
> +
> +/*
> + * "Retired instructions", from Processor Programming Reference
> + * (PPR) for AMD Family 17h Model 01h, Revision B1 Processors,
> + * Preliminary Processor Programming Reference (PPR) for AMD Family
> + * 17h Model 31h, Revision B0 Processors, and Preliminary Processor
> + * Programming Reference (PPR) for AMD Family 19h Model 01h, Revision
> + * B1 Processors Volume 1 of 2.
> + *    			--- and ---
> + * "Instructions retired", from the Intel SDM, volume 3,
> + * "Pre-defined Architectural Performance Events."
> + */
> +
> +#define INST_RETIRED EVENT(0xc0, 0)
> +
>  /*
>   * This event list comprises Intel's eight architectural events plus
>   * AMD's "retired branch instructions" for Zen[123] (and possibly
> @@ -61,7 +76,7 @@
>   */
>  static const uint64_t event_list[] = {
>  	EVENT(0x3c, 0),
> -	EVENT(0xc0, 0),
> +	INST_RETIRED,

There are multiple refactorings thrown into this single patch.  Please break them
out to their own prep patches, bundling everything together makes it way too hard
to identify the actual functional change.

>  	EVENT(0x3c, 1),
>  	EVENT(0x2e, 0x4f),
>  	EVENT(0x2e, 0x41),

...

> @@ -240,14 +285,39 @@ static struct kvm_pmu_event_filter *remove_event(struct kvm_pmu_event_filter *f,
>  	return f;
>  }
>  
> +#define expect_success(r) __expect_success(r, __func__)

I'm all for macros, but in this case I think it's better to just have the callers
pass in __func__ themselves.  There's going to be copy+paste anyways, the few
extra characters is a non-issue.

Alternatively, make the inner helpers macros, though that'll be annoying to read
and maintain.

And somewhat of a nit, instead of "success" vs. "failure", what about "counting"
vs. "not_counting"?  And s/expect/assert?  Without looking at the low level code,
it wasn't clear to me what "failure" meant.  E.g.

	assert_pmc_counting(r, __func__);

	assert_pmc_not_counting(r, __func__);

> +
> +static void __expect_success(struct perf_results r, const char *func) {

Curly brace on its own line for functions.

> +	if (r.br_count != NUM_BRANCHES)
> +		pr_info("%s: Branch instructions retired = %u (expected %u)\n",
> +			func, r.br_count, NUM_BRANCHES);
> +
> +	TEST_ASSERT(r.br_count,
> +		    "Allowed event, branch instructions retired, is not counting.");
> +	TEST_ASSERT(r.ir_count,
> +		    "Allowed event, instructions retired, is not counting.");	
> +} 
> +
> +#define expect_failure(r) __expect_failure(r, __func__)
> +
> +static void __expect_failure(struct perf_results r, const char *func) {
> +	if (r.br_count)
> +		pr_info("%s: Branch instructions retired = %u (expected 0)\n",
> +			func, r.br_count);

This pr_info() seems silly.  If br_count is non-zero, the assert below will fire, no?

> +
> +	TEST_ASSERT(!r.br_count,
> +		    "Disallowed PMU event, branch instructions retired, is counting");

Either make these inner helpers macros so that the assert is guaranteed unique,
or include the function name in the assert mesage.  If __expect_{failure,success}()
is NOT inlined, but the caller is, then it will be mildly annoying to determine
exactly what test failed.

> +	TEST_ASSERT(!r.ir_count,
> +		    "Disallowed PMU event, instructions retired, is counting");
> +}
> +
