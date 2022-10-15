Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2CB65FFB11
	for <lists+kvm@lfdr.de>; Sat, 15 Oct 2022 17:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbiJOPna (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 15 Oct 2022 11:43:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiJOPn3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 15 Oct 2022 11:43:29 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 639D21E72C
        for <kvm@vger.kernel.org>; Sat, 15 Oct 2022 08:43:27 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id n12so11836631wrp.10
        for <kvm@vger.kernel.org>; Sat, 15 Oct 2022 08:43:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=67dFKpX63V4dSM/VLIq4bt1VvhtC/zkys2HHoW4p6YY=;
        b=NaiXymT3b5cjnpApjuo4a44FHhqM0oiiYEgkHGETYrhmhpY8Yrsj1KWDkmisBhsUO/
         +wuSZ2nG9FwE04oC2G/6ye9HHpMF2aAnarO2fAAA+KzacVmmOyZnwvjE+TFuH8rj1lxr
         i5yirhB5M65O0ULWj5SrSsr4ATUSO3GrF8DT9aJ0a6yvpFh4B8yC0vBEOKbG3aSLlbKz
         IigTZLMvo9SREqhIZChxXzm4478RT9MetnV2xA0gOMAROD+ZphMdpXWil2Uddp0+qVb3
         LbBSEqqaEGoYpFrwVcX2aewqvxu3kTZQBefWQ1Tb/DqX9R9tUzCYqTY/AJMC0hxwOvaK
         apqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=67dFKpX63V4dSM/VLIq4bt1VvhtC/zkys2HHoW4p6YY=;
        b=eR6rBLHNuK4KijcGsln7B2p9HZuwt6RIn4kvrCri8dfMm3swGPRcc0pVmONYvOLY3i
         mUtFrw7oMaD4EaIPm7V93QN0PDppuYJ8Hx9GBpeP0Jiug/k3DhQk2YHFxk+gkSP6R4de
         NrrYBU0RuTHMz1xv7FoTTkGqNRCm7LJHBcxPhZr+sgK1y0wglMO7JLGpNnkqQQryAKjg
         S0EUdUUIUsgeqVkSPRJAzmgSH7otVBEWNVxaEmzVGdfVacL6kydtTo/4b0LItI3Ymd7D
         alNBPLhnvZXT3g1WxSN6qOGSsPUvwC5C0nNouNMSjwYzNG86woLo5R2mLZEXQygZ74cB
         ROYg==
X-Gm-Message-State: ACrzQf0+BJvvOs8HQf+lGy1YumT1aCp9/++FYHzthpWhTFpDAwFtmzh6
        YMcUL1MNK/hRC3szHSNkqHZthN8ViGDyIHs0nZ4WOg==
X-Google-Smtp-Source: AMsMyM5Bfvs5xZ7Ra5Yg849KBqh3HhGJCgL2Wr7VX4L8xqNm3nOBMzxUblSJm+9Re3OTW5nWfCHLWHlko+OZmP8hzAM=
X-Received: by 2002:adf:edc3:0:b0:22c:dbe9:e3b6 with SMTP id
 v3-20020adfedc3000000b0022cdbe9e3b6mr1764549wro.282.1665848605833; Sat, 15
 Oct 2022 08:43:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220920174603.302510-1-aaronlewis@google.com>
 <20220920174603.302510-2-aaronlewis@google.com> <Y0C1c2bBNVF4qxJq@google.com>
In-Reply-To: <Y0C1c2bBNVF4qxJq@google.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Sat, 15 Oct 2022 08:43:14 -0700
Message-ID: <CAAAPnDEk_bckk0W5C2vKiL4HJVUHFGV3_NqfdbsqYFqpJvuXog@mail.gmail.com>
Subject: Re: [PATCH v5 1/7] kvm: x86/pmu: Correct the mask used in a pmu event
 filter lookup
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Content-Type: text/plain; charset="UTF-8"
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

> And the total patch is:
>
> ---
>  arch/x86/kvm/pmu.c           | 2 +-
>  arch/x86/kvm/pmu.h           | 2 ++
>  arch/x86/kvm/svm/pmu.c       | 2 ++
>  arch/x86/kvm/vmx/pmu_intel.c | 2 ++
>  4 files changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index d9b9a0f0db17..d0e2c7eda65b 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -273,7 +273,7 @@ static bool check_pmu_event_filter(struct kvm_pmc *pmc)
>                 goto out;
>
>         if (pmc_is_gp(pmc)) {
> -               key = pmc->eventsel & AMD64_RAW_EVENT_MASK_NB;
> +               key = pmc->eventsel & kvm_pmu_ops.EVENTSEL_MASK;
>                 if (bsearch(&key, filter->events, filter->nevents,
>                             sizeof(__u64), cmp_u64))
>                         allow_event = filter->action == KVM_PMU_EVENT_ALLOW;
> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> index 5cc5721f260b..45a7dd24125d 100644
> --- a/arch/x86/kvm/pmu.h
> +++ b/arch/x86/kvm/pmu.h
> @@ -40,6 +40,8 @@ struct kvm_pmu_ops {
>         void (*reset)(struct kvm_vcpu *vcpu);
>         void (*deliver_pmi)(struct kvm_vcpu *vcpu);
>         void (*cleanup)(struct kvm_vcpu *vcpu);
> +
> +       const u64 EVENTSEL_MASK;

Agreed, a constant is better.  Had I realized I could do that, that
would have been my first choice.

What about calling it EVENTSEL_RAW_MASK to make it more descriptive
though?  It's a little too generic given there is EVENTSEL_UMASK and
EVENTSEL_CMASK, also there is precedent for using the term 'raw event'
for (eventsel+umask), i.e.
https://man7.org/linux/man-pages/man1/perf-record.1.html.

>  };
>
>  void kvm_pmu_ops_update(const struct kvm_pmu_ops *pmu_ops);
> diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
> index b68956299fa8..6ef7d1fcdbc2 100644
> --- a/arch/x86/kvm/svm/pmu.c
> +++ b/arch/x86/kvm/svm/pmu.c
> @@ -228,4 +228,6 @@ struct kvm_pmu_ops amd_pmu_ops __initdata = {
>         .refresh = amd_pmu_refresh,
>         .init = amd_pmu_init,
>         .reset = amd_pmu_reset,
> +       .EVENTSEL_MASK = AMD64_EVENTSEL_EVENT |
> +                        ARCH_PERFMON_EVENTSEL_UMASK,
>  };
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 25b70a85bef5..0a1c95b64ef1 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -811,4 +811,6 @@ struct kvm_pmu_ops intel_pmu_ops __initdata = {
>         .reset = intel_pmu_reset,
>         .deliver_pmi = intel_pmu_deliver_pmi,
>         .cleanup = intel_pmu_cleanup,
> +       .EVENTSEL_MASK = ARCH_PERFMON_EVENTSEL_EVENT |
> +                        ARCH_PERFMON_EVENTSEL_UMASK,
>  };
>
> base-commit: e18d6152ff0f41b7f01f9817372022df04e0d354
> --
>
