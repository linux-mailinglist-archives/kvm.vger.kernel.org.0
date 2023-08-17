Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C23C78015C
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 00:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355924AbjHQW4f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 18:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355964AbjHQW4S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 18:56:18 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77A7A2722
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 15:56:17 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-58caf216c55so28067717b3.0
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 15:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692312976; x=1692917776;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fgScnn5RBzxO9f86ZExxXj39+cRNBheyMQjBFZXZY0Y=;
        b=On47IfnapOGhwFfk0/6Kss9+7tEiqiZCQiOn3f8es6AX1qD0JMTsEP9Hp5n2v04V56
         aYE0kWs62ynSN8fIWSBjuEyvfoPhDqmBihyPhkkn3g8CNhW26hLerBpVPO2hZN6Hy2qM
         nfObej3/Twjkb0frvCHIx+NSBl7ktrPimyqt8ZQrd+1NqZp1L5q0eq35Uuxo4ozmd2DL
         +PcvjRORHYAYSepqzXw8IC6TkFiNQ8tMQop2+aELmxOjHPm+S30NFNguK4oigLwwaMw/
         us9Z1q9Musygr77r2gGK1IEapDZmaBX7RMe7rBnDGHslqHsB6phl2NrCvcobMWTnEj9W
         yTcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692312976; x=1692917776;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fgScnn5RBzxO9f86ZExxXj39+cRNBheyMQjBFZXZY0Y=;
        b=YveBX2lw2Zw12/0R1gtGoE0UJyIsCb5KnmSAoYGsW+JZaBfzSTe9vmDuPNK0gvD2oT
         u6867hy63rUJnXryOUWOdeyvFS0RAMJdzV00k0HpDkjxEb9VFrv0e60mVlHNUo/ntOPX
         cUkTfdElyCH9TOaIjXZGwBcwerCQ6pRtEGZn9yqKZ49+Fm9XEf3e1u7WlLG7vA9C8Si5
         VEsnlxcnY4r7r2HlmrPEkN+unCFeOn6sbURnypkpuuTE6ta7SM3eB7oueqoZ82VOirxx
         h9kDWClzq/EqXW3w2HhjhXmM1aKdPMrPQrYiM6hntv62GP2QINqgu1EVepR9TeNxq3ZC
         Hhdg==
X-Gm-Message-State: AOJu0YwIxyO1nACkun8hhQDimUsBnHiJ3bjjwLK9oMltqVSrQEG3Ah42
        OJ8NyDrtwjTGqytwStGxd6VHtISMDgM=
X-Google-Smtp-Source: AGHT+IFGAClS+E0jaoY9X2vwDGwNnlIcNEDf2lmb+SVqULtQJ/1kRiNpVKHd8BnLqfP/Tt3b08GOJbpmW6o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:760f:0:b0:586:e2b5:f364 with SMTP id
 r15-20020a81760f000000b00586e2b5f364mr17239ywc.4.1692312976792; Thu, 17 Aug
 2023 15:56:16 -0700 (PDT)
Date:   Thu, 17 Aug 2023 15:56:15 -0700
In-Reply-To: <20230814115108.45741-5-cloudliang@tencent.com>
Mime-Version: 1.0
References: <20230814115108.45741-1-cloudliang@tencent.com> <20230814115108.45741-5-cloudliang@tencent.com>
Message-ID: <ZN6ljwWZPKc1vU6E@google.com>
Subject: Re: [PATCH v3 04/11] KVM: selftests: Test Intel PMU architectural
 events on fixed counters
From:   Sean Christopherson <seanjc@google.com>
To:     Jinrong Liang <ljr.kernel@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Like Xu <likexu@tencent.com>,
        David Matlack <dmatlack@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jinrong Liang <cloudliang@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 14, 2023, Jinrong Liang wrote:
> From: Jinrong Liang <cloudliang@tencent.com>
> 
> Update test to cover Intel PMU architectural events on fixed counters.
> Per Intel SDM, PMU users can also count architecture performance events
> on fixed counters (specifically, FIXED_CTR0 for the retired instructions
> and FIXED_CTR1 for cpu core cycles event). Therefore, if guest's CPUID
> indicates that an architecture event is not available, the corresponding
> fixed counter will also not count that event.
> 
> Co-developed-by: Like Xu <likexu@tencent.com>
> Signed-off-by: Like Xu <likexu@tencent.com>
> Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
> ---
>  .../kvm/x86_64/pmu_basic_functionality_test.c | 21 +++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c b/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c
> index c04eb0bdf69f..daa45aa285bb 100644
> --- a/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c
> @@ -47,6 +47,7 @@ static uint64_t run_vcpu(struct kvm_vcpu *vcpu, uint64_t *ucall_arg)
>  
>  static void guest_measure_loop(uint64_t event_code)
>  {
> +	uint32_t nr_fixed_counter = this_cpu_property(X86_PROPERTY_PMU_NR_FIXED_COUNTERS);

There's zero reason to cache this.

>  	uint32_t nr_gp_counters = this_cpu_property(X86_PROPERTY_PMU_NR_GP_COUNTERS);
>  	uint32_t pmu_version = this_cpu_property(X86_PROPERTY_PMU_VERSION);
>  	uint32_t counter_msr;
> @@ -73,6 +74,26 @@ static void guest_measure_loop(uint64_t event_code)
>  		}
>  	}
>  
> +	if (pmu_version < 2 || nr_fixed_counter < 1)

Because you can simply do:

	if (pmu_version < 2 ||
	    this_cpu_property(X86_PROPERTY_PMU_NR_FIXED_COUNTERS) < 1)
		goto done;
	
> +		goto done;
> +
> +	if (event_code == intel_arch_events[INTEL_ARCH_INSTRUCTIONS_RETIRED])
> +		i = 0;
> +	else if (event_code == intel_arch_events[INTEL_ARCH_CPU_CYCLES])
> +		i = 1;
> +	else
> +		goto done;
> +
> +	wrmsr(MSR_CORE_PERF_FIXED_CTR0 + i, 0);
> +	wrmsr(MSR_CORE_PERF_FIXED_CTR_CTRL, BIT_ULL(4 * i));
> +	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, BIT_ULL(INTEL_PMC_IDX_FIXED + i));
> +
> +	__asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES}));
> +
> +	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0);
> +	GUEST_SYNC(_rdpmc(RDPMC_FIXED_BASE | i));
> +
> +done:
>  	GUEST_DONE();
>  }
>  
> -- 
> 2.39.3
> 
