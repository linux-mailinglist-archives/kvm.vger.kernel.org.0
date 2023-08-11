Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED417799F4
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 23:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237097AbjHKVwx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Aug 2023 17:52:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236990AbjHKVwu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Aug 2023 17:52:50 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E15B62712
        for <kvm@vger.kernel.org>; Fri, 11 Aug 2023 14:52:49 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-57320c10635so28952727b3.3
        for <kvm@vger.kernel.org>; Fri, 11 Aug 2023 14:52:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691790769; x=1692395569;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HlRYai3F2Tu40LTwPrwvOX+4PQU330kp+zCtQV1aE7I=;
        b=PkaIjBxHh4yDX4/f/hCYbS2//fPhZlvzF3I+LeVzbXmM9wzP44eASFAIS+/Z3JHD3V
         os7+UCFX443MVtvCt/dBTkWo+PI4C8reM+smjcN2tgvSqzE35ovs0gYVhuOnyLYEIneM
         Upgg5H683V+S7W2yU/fRn7wi9kB4Qa428abrAzkehxahyCreneQfnHsOzHjpMRG8fLai
         h4lJveHY5bSccokKpmYr7ElIj12rxN/HWRBog3XcPeQaOoSgFS+XGoaDSlNhcZZHdfG7
         Hmi1COPYN+5GMbW+MSKAWaUpsirAjtggdrQ20S33NEkbmxOFRoAdVs9E7DQH6/DS9yVL
         HEJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691790769; x=1692395569;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HlRYai3F2Tu40LTwPrwvOX+4PQU330kp+zCtQV1aE7I=;
        b=ESLC3sM770dXIq1h4dzEk67MvAF8RtF/2KxntkvQtG4moWcgTZe8yTIhVuihCiIpQ4
         AVGiavILhxxZD+hTeTz71iCtbHdZhpQrXRdfWajWF228Vo2cWnPYFlSCMgcuV7w+OA/b
         698pnitaUcVy58iVXb+zW94+TQzt8WEnoyPRmv0sstmE0ZheFMzP6+csw+FY3weXyxAp
         y/IXEddgMtkDF5V+PxjIBZQr7BK0hl0hMB1BrRiGv9NTHCMt6idPNLBpXzNXrrOB4Z7f
         N4WEghulZpjt8GAYmJjgjxw1l+31w1sCv78pSoXNgk8zSglg1ASRVYYFVBua6aJuBRrW
         GCKg==
X-Gm-Message-State: AOJu0YzF1+JY0MAo3BhwkFRcXA3Wh/TO9Pnyq1slSICMLdFM7x4a3VjN
        /qAkWFnSx9N/2Y2REDsybV6b0yBOXHw=
X-Google-Smtp-Source: AGHT+IH/hfQ/W5fZ1Tn5FlaTZueSHGzRdsEu0+rQlAtzN//RnCBorbXUGcfT0bd3BYZhkNMsH2w+0TkW/bs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:4312:0:b0:586:b332:8618 with SMTP id
 q18-20020a814312000000b00586b3328618mr57133ywa.7.1691790769157; Fri, 11 Aug
 2023 14:52:49 -0700 (PDT)
Date:   Fri, 11 Aug 2023 14:52:47 -0700
In-Reply-To: <20230808051502.1831199-1-dapeng1.mi@linux.intel.com>
Mime-Version: 1.0
References: <20230808051502.1831199-1-dapeng1.mi@linux.intel.com>
Message-ID: <ZNatr1M6xddAxaWG@google.com>
Subject: Re: [PATCH] KVM: x86/pmu: Manipulate FIXED_CTR_CTRL MSR with macros
From:   Sean Christopherson <seanjc@google.com>
To:     Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Like Xu <likexu@tencent.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhang Xiong <xiong.y.zhang@intel.com>,
        Lv Zhiyuan <zhiyuan.lv@intel.com>,
        Yang Weijiang <weijiang.yang@intel.com>,
        Dapeng Mi <dapeng1.mi@intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 08, 2023, Dapeng Mi wrote:
> Magic numbers are used to manipulate the bit fields of
> FIXED_CTR_CTRL MSR. This is not read-friendly and use macros to replace
> these magic numbers to increase the readability.
> 
> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> ---
>  arch/x86/include/asm/perf_event.h |  2 ++
>  arch/x86/kvm/pmu.c                | 16 +++++++---------
>  arch/x86/kvm/pmu.h                | 10 +++++++---
>  3 files changed, 16 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
> index 85a9fd5a3ec3..018441211af1 100644
> --- a/arch/x86/include/asm/perf_event.h
> +++ b/arch/x86/include/asm/perf_event.h
> @@ -38,6 +38,8 @@
>  #define INTEL_FIXED_0_USER				(1ULL << 1)
>  #define INTEL_FIXED_0_ANYTHREAD			(1ULL << 2)
>  #define INTEL_FIXED_0_ENABLE_PMI			(1ULL << 3)
> +#define INTEL_FIXED_0_ENABLE	\
> +	(INTEL_FIXED_0_KERNEL |	INTEL_FIXED_0_USER)

I vote to omit INTEL_FIXED_0_ENABLE and open code the "KERNEL | USER" logic in
the one place that uses it.  I dislike macros that sneakily cover multiple bits,
i.e. don't have a name that strongly suggests a multi-bit masks.  It's too easy
to misread the code, especially for readers that aren't familiar with PMCs, e.g.
in the usage below, it's not at all obvious that the "in use" check will evaluate
true if the PMC is enabled for the kernel *or* user.

>  #define HSW_IN_TX					(1ULL << 32)
>  #define HSW_IN_TX_CHECKPOINTED				(1ULL << 33)
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index edb89b51b383..03fb6b4bca2c 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -418,13 +418,12 @@ static void reprogram_counter(struct kvm_pmc *pmc)
>  		printk_once("kvm pmu: pin control bit is ignored\n");
>  
>  	if (pmc_is_fixed(pmc)) {
> -		fixed_ctr_ctrl = fixed_ctrl_field(pmu->fixed_ctr_ctrl,
> -						  pmc->idx - INTEL_PMC_IDX_FIXED);
> -		if (fixed_ctr_ctrl & 0x1)
> +		fixed_ctr_ctrl = pmu_fixed_ctrl_field(pmu, pmc->idx);
> +		if (fixed_ctr_ctrl & INTEL_FIXED_0_KERNEL)
>  			eventsel |= ARCH_PERFMON_EVENTSEL_OS;

Please split this into two patches, one to do a straight replacement of literals
with existing macros, and one to add pmu_fixed_ctrl_field().  Using existing
macros is a no-brainer, but I'm less convinced that pmu_fixed_ctrl_field() is
a good idea, e.g. both pmu_fixed_ctrl_field() and fixed_ctrl_field() take "idx",
but use a different base.  That is bound to cause problems.

> -		if (fixed_ctr_ctrl & 0x2)
> +		if (fixed_ctr_ctrl & INTEL_FIXED_0_USER)
>  			eventsel |= ARCH_PERFMON_EVENTSEL_USR;
> -		if (fixed_ctr_ctrl & 0x8)
> +		if (fixed_ctr_ctrl & INTEL_FIXED_0_ENABLE_PMI)
>  			eventsel |= ARCH_PERFMON_EVENTSEL_INT;
>  		new_config = (u64)fixed_ctr_ctrl;
>  	}
> @@ -747,10 +746,9 @@ static inline bool cpl_is_matched(struct kvm_pmc *pmc)
>  		select_os = config & ARCH_PERFMON_EVENTSEL_OS;
>  		select_user = config & ARCH_PERFMON_EVENTSEL_USR;
>  	} else {
> -		config = fixed_ctrl_field(pmc_to_pmu(pmc)->fixed_ctr_ctrl,
> -					  pmc->idx - INTEL_PMC_IDX_FIXED);
> -		select_os = config & 0x1;
> -		select_user = config & 0x2;
> +		config = pmu_fixed_ctrl_field(pmc_to_pmu(pmc), pmc->idx);
> +		select_os = config & INTEL_FIXED_0_KERNEL;
> +		select_user = config & INTEL_FIXED_0_USER;
>  	}
>  
>  	return (static_call(kvm_x86_get_cpl)(pmc->vcpu) == 0) ? select_os : select_user;
> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> index 7d9ba301c090..2d098aa2fcc6 100644
> --- a/arch/x86/kvm/pmu.h
> +++ b/arch/x86/kvm/pmu.h
> @@ -12,7 +12,11 @@
>  					  MSR_IA32_MISC_ENABLE_BTS_UNAVAIL)
>  
>  /* retrieve the 4 bits for EN and PMI out of IA32_FIXED_CTR_CTRL */
> -#define fixed_ctrl_field(ctrl_reg, idx) (((ctrl_reg) >> ((idx)*4)) & 0xf)
> +#define fixed_ctrl_field(ctrl_reg, idx) \
> +	(((ctrl_reg) >> ((idx) * INTEL_FIXED_BITS_STRIDE)) & INTEL_FIXED_BITS_MASK)
> +
> +#define pmu_fixed_ctrl_field(pmu, idx)	\
> +	fixed_ctrl_field((pmu)->fixed_ctr_ctrl, (idx) - INTEL_PMC_IDX_FIXED)
>  
>  #define VMWARE_BACKDOOR_PMC_HOST_TSC		0x10000
>  #define VMWARE_BACKDOOR_PMC_REAL_TIME		0x10001
> @@ -164,8 +168,8 @@ static inline bool pmc_speculative_in_use(struct kvm_pmc *pmc)
>  	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
>  
>  	if (pmc_is_fixed(pmc))
> -		return fixed_ctrl_field(pmu->fixed_ctr_ctrl,
> -					pmc->idx - INTEL_PMC_IDX_FIXED) & 0x3;
> +		return pmu_fixed_ctrl_field(pmu, pmc->idx) &
> +		       INTEL_FIXED_0_ENABLE;
>  
>  	return pmc->eventsel & ARCH_PERFMON_EVENTSEL_ENABLE;
>  }
> -- 
> 2.34.1
> 
