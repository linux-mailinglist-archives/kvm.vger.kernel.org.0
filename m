Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70BEB71010A
	for <lists+kvm@lfdr.de>; Thu, 25 May 2023 00:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238457AbjEXWgo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 18:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238327AbjEXWgl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 18:36:41 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C204E55
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 15:36:16 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-ba9d8b01f82so3237535276.0
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 15:36:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684967773; x=1687559773;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iwTndVYq1t6b9qeOkldCRAlHVQC8rU6fAi10eJnGMhY=;
        b=S9ACP77jUWIZBGBDJOUQdJpybmEb6sA22nRSGa9bZhQssdnPjuMRgeJI+B1kmVifgW
         2IRt4po11RHWP4h5g5HFNFjSgWFINJjidtXKmPlKISANbKSTrOGthVG9QFDotD/I/zbd
         TN7+1cQxG74QrKYoIhj/OYDGJnAfF+g4tNVg43fWjg0R5zWp9Ahw31noVjMVtrFTCpwY
         fB5IOC7tsIDoyF4MByKeQj0kj1k0isnlI0wc8FJ4V0HIqmzfxvz4UQRuQILYHyjlRG9A
         Q66UOgGJFKnOhtG+FKztkblHCrLTwy0c/Q+QiEzwQ44dqskMy1gpgrhPwf4pGEn76T2L
         fr6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684967773; x=1687559773;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iwTndVYq1t6b9qeOkldCRAlHVQC8rU6fAi10eJnGMhY=;
        b=VvODg8lWv+RI35ZRqgGGFAMm8GxaR3yUvHzDLMxWM6Zs6Czo+QkyDH2tomLqjftA2Q
         6R3jSU0yagdqs0+ejXqpaDdCftLYHrJ6DnXxXAhaVvICNPgThjopGD/4Db41gq+bI5N7
         EuEl7l2wpdq7EozLsEX8fPIxjWugulS6YrVHSjqZtBxggVaLAbvs2A3Ehzhrk/2Ow8Mu
         PgTL1yrO9VwazMYVfSBpcrmhEsBt4N3InE1f4d6cAjhb1H2o1s+j4Yu7nUJh5ASr7T6E
         YJCUOaKNol3/8nVP+3RFrcKAOB+dv8BKITRF72XSPGAFQqJBiOd8rbl63fwuFCG9k7sd
         cORQ==
X-Gm-Message-State: AC+VfDySFn+EQjJllZ3eCI0HEiPewjwzUAck7MtMxQlZYogF3bDp3E4w
        6hvp/MH3mzDidfGprmcJzpY1n3FNK8c=
X-Google-Smtp-Source: ACHHUZ6rfhhJk7Tf+97ZI8d7MguU8CMY3Qta23pVl/derDf1QpH1rs5Rs8eKZZnMfUc2basJYgKWkjLBSmY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a5b:38e:0:b0:ba8:797c:9bc7 with SMTP id
 k14-20020a5b038e000000b00ba8797c9bc7mr787216ybp.11.1684967773335; Wed, 24 May
 2023 15:36:13 -0700 (PDT)
Date:   Wed, 24 May 2023 15:36:11 -0700
In-Reply-To: <20230323072714.82289-3-likexu@tencent.com>
Mime-Version: 1.0
References: <20230323072714.82289-1-likexu@tencent.com> <20230323072714.82289-3-likexu@tencent.com>
Message-ID: <ZG6RW4AwayOdPTaZ@google.com>
Subject: Re: [PATCH 2/7] KVM: selftests: Test Intel PMU architectural events
 on fixed counters
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jinrong Liang <cloudliang@tencent.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 23, 2023, Like Xu wrote:
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
>  .../selftests/kvm/x86_64/pmu_cpuid_test.c     | 37 +++++++++++++++++--
>  1 file changed, 33 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/pmu_cpuid_test.c b/tools/testing/selftests/kvm/x86_64/pmu_cpuid_test.c
> index faab0a91e191..75434aa2a0ec 100644
> --- a/tools/testing/selftests/kvm/x86_64/pmu_cpuid_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/pmu_cpuid_test.c
> @@ -25,6 +25,9 @@
>  #define GP_CTR_NUM_MASK GENMASK_ULL(15, GP_CTR_NUM_OFS_BIT)
>  #define EVT_LEN_OFS_BIT 24
>  #define EVT_LEN_MASK GENMASK_ULL(31, EVT_LEN_OFS_BIT)
> +#define INTEL_PMC_IDX_FIXED 32
> +#define RDPMC_FIXED_BASE BIT_ULL(30)
> +#define FIXED_CTR_NUM_MASK GENMASK_ULL(4, 0)
>  
>  #define ARCH_EVENT(select, umask) (((select) & 0xff) | ((umask) & 0xff) << 8)
>  
> @@ -43,6 +46,14 @@ static const uint64_t arch_events[] = {
>  	[7] = ARCH_EVENT(0xa4, 0x1), /* Topdown Slots */
>  };
>  
> +/* Association of Fixed Counters with Architectural Performance Events */
> +static int fixed_events[] = {1, 0, 7};
> +
> +static uint64_t evt_code_for_fixed_ctr(uint8_t idx)
> +{
> +	return arch_events[fixed_events[idx]];
> +}

This appears to be more fodder for common code.

>  static struct kvm_vcpu *new_vcpu(void *guest_code)
>  {
>  	struct kvm_vm *vm;
> @@ -88,8 +99,8 @@ static bool first_uc_arg_non_zero(struct ucall *uc, void *data)
>  }
>  
>  static void intel_guest_run_arch_event(uint8_t version, uint8_t max_gp_num,
> -				       bool supported, uint32_t ctr_base_msr,
> -				       uint64_t evt_code)
> +				       uint8_t max_fixed_num, bool supported,
> +				       uint32_t ctr_base_msr, uint64_t evt_code)
>  {
>  	uint32_t global_msr = MSR_CORE_PERF_GLOBAL_CTRL;
>  	unsigned int i;
> @@ -108,6 +119,23 @@ static void intel_guest_run_arch_event(uint8_t version, uint8_t max_gp_num,
>  		GUEST_SYNC(supported == !!_rdpmc(i));
>  	}
>  
> +	/* No need to test independent arch events on fixed counters. */
> +	if (version > 1 && max_fixed_num > 1 &&
> +	    (evt_code == evt_code_for_fixed_ctr(0) ||
> +	     evt_code == evt_code_for_fixed_ctr(1))) {
> +		i = (evt_code == evt_code_for_fixed_ctr(0)) ? 0 : 1;

The ternary operator on top of a duplicate comparison isn't super intuitive.
Maybe use gotos?  Definitely just an idea, not a requirement.

	if (version <= 1 || max_fixed_num <= 1)
		goto done;

	if (evt_code == evt_code_for_fixed_ctr(0))
		i = 0;
	else if (evt_code == evt_code_for_fixed_ctr(1))
		i = 1;
	else
		goto done;

> +		wrmsr(MSR_CORE_PERF_FIXED_CTR0 + i, 0);
> +		wrmsr(MSR_CORE_PERF_FIXED_CTR_CTRL, BIT_ULL(4 * i));
> +		wrmsr(global_msr, BIT_ULL(INTEL_PMC_IDX_FIXED + i));
> +
> +		__asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES}));
> +
> +		wrmsr(global_msr, 0);
> +
> +		GUEST_SYNC(supported == !!_rdpmc(RDPMC_FIXED_BASE | i));
> +	}
> +
>  	GUEST_DONE();
>  }
