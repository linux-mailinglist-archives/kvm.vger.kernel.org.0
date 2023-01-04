Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4E565DB27
	for <lists+kvm@lfdr.de>; Wed,  4 Jan 2023 18:20:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239486AbjADRUR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Jan 2023 12:20:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjADRUP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Jan 2023 12:20:15 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E258FDFCF
        for <kvm@vger.kernel.org>; Wed,  4 Jan 2023 09:20:14 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id f3so22698310pgc.2
        for <kvm@vger.kernel.org>; Wed, 04 Jan 2023 09:20:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dGpKA8Xk12wRDNWFstofncZhL9cCm1jkH8YJ0dkRiD4=;
        b=eLeZRIPQdknokHsyK4aBUhCNgjgAUiYaHI+WcgwKwmR4tclFwQklEdzUZsJoDWmIdu
         WRZmEM5m9GhBDPykQytsj5pEAGvFida4jaKvBbH7CR2fspO9qGCqwEuMbC4auaze0YdO
         QuRFUCdVFar5sAW6Qd7N5xCksSgfD8il+2PxlhXickZHPXXQf3pOsv7amrhlw+E9gV6X
         ZcuSdHy+PXDJM1s3WjmnApyEoPutDIfbY2QJPvSeUi34Qi/JrZccF2OybhvR/evg6WTP
         Uyo1sAKY5XMurlUj5YvO8R3twp3t/B+PK7xrxl4ZoMGGD0PeIX1LXlrxk39XyXfw1vrU
         JGpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dGpKA8Xk12wRDNWFstofncZhL9cCm1jkH8YJ0dkRiD4=;
        b=qRQhn36/Rg/a2+Cv8S1rjz7r13XQjJ6XbZACyx29IPoj3YFQ7+S5v6Bgi9R4uh399C
         oOjgfDG2XXVw4uA/8WA7cAdjkhj+ZIIlWcPCMcfIdwtHr2t4yEAujNvn1sZfN9gK/zfZ
         uEIcHcZw7SRqigoHChUUp4KN8S191urNo2Tow8l3E820rIR2XFkHs672aG9FIpizfZ5w
         rIcDla3OXa7oeplH94kljzv8qpujxaMq8/IrwLq2dD203ngHr3UUApH6ygcTi8mRTiD4
         KqLW8sz7h9Y74tKaPR5VVeoUmwXQGbqyYH6S/o6GhyEN2OfG8WHpaa/3Pv5IyYjWDYqv
         CG1w==
X-Gm-Message-State: AFqh2kojBX0a6DU8GX7XRMJeRMHZwW/4qn/VqjK10sduLTM/Q3cUhkpq
        otuqGkFH9gd4XT6KbvTAuozyBg8sG09UtIk/
X-Google-Smtp-Source: AMrXdXvxmvYSvyk6KgZzZxbqX4Ohz6fjs4GaGKPlVeJAQiErE2HIVSD7IWCYy9lIv7v7igOKw38KQA==
X-Received: by 2002:a05:6a00:1c8e:b0:581:bfac:7a52 with SMTP id y14-20020a056a001c8e00b00581bfac7a52mr1753035pfw.1.1672852814284;
        Wed, 04 Jan 2023 09:20:14 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 9-20020a621709000000b00580e07cc338sm20479608pfx.175.2023.01.04.09.20.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 09:20:13 -0800 (PST)
Date:   Wed, 4 Jan 2023 17:20:10 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH 1/2] KVM: x86/pmu: Prevent the PMU from counting
 disallowed events
Message-ID: <Y7W1StyoN3f38xG8@google.com>
References: <20221209194957.2774423-1-aaronlewis@google.com>
 <20221209194957.2774423-2-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221209194957.2774423-2-aaronlewis@google.com>
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
> When counting "Instructions Retired" (0xc0) in a guest, KVM will
> occasionally increment the PMU counter regardless of if that event is
> being filtered. This is because some PMU events are incremented via
> kvm_pmu_trigger_event(), which doesn't know about the event filter. Add
> the event filter to kvm_pmu_trigger_event(), so events that are
> disallowed do not increment their counters.
> 
> Fixes: 9cd803d496e7 ("KVM: x86: Update vPMCs when retiring instructions")
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---
>  arch/x86/kvm/pmu.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 684393c22105..b87cf35a38b7 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -581,7 +581,9 @@ void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 perf_hw_id)
>  	for_each_set_bit(i, pmu->all_valid_pmc_idx, X86_PMC_IDX_MAX) {
>  		pmc = static_call(kvm_x86_pmu_pmc_idx_to_pmc)(pmu, i);
>  
> -		if (!pmc || !pmc_is_enabled(pmc) || !pmc_speculative_in_use(pmc))
> +		if (!pmc || !pmc_is_enabled(pmc) ||
> +		    !pmc_speculative_in_use(pmc) ||
> +		    !check_pmu_event_filter(pmc))

reprogram_counter() has the same three checks, seems like we should combine them
into a common helper.  No idea what to call it though.  Maybe?

		if (!pmc || !pmc_is_fully_enabled(pmc))

>  			continue;
>  
>  		/* Ignore checks for edge detect, pin control, invert and CMASK bits */
> -- 
> 2.39.0.rc1.256.g54fd8350bd-goog
> 
