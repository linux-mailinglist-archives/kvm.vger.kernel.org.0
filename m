Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E90CA5A6BBF
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 20:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232193AbiH3SHY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 14:07:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231164AbiH3SHX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 14:07:23 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 810B5647E9
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 11:07:22 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id u9-20020a17090a1f0900b001fde6477464so5621028pja.4
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 11:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=HwoaPhoS6p05+6Q+y0C7EJbnrSAeSDJjW5DKVBz8mhg=;
        b=SdF5T+pT4uOyKFnCG1wz2UF9L14M0q5BWr9oA8ZC2cA+NiEDTLk9b/dExAULtx8Dim
         qDXstRuMxlIsQ7QW134sht0ZJQ1vJNjHOks/aM3Klo+PeW25oP2D5OsU/xh8bnMp+1/n
         lI9MUsc3zaGOio0HAHYfXedxEv/v0ZSoDNqLeafh/Wk9CmBdbLkSIVmW3gQ6I1L9PVn5
         j8CQEYXSyXqpiRVcrduU6g0vJLc7v2b4Lfcktg9DvWEJrYcRr60/RKyy87PNWfzldRZo
         +Hwb3TZkO+DLR+bQz92lwPby8MVb+I2XGM4jmBhmD0t4nEWJyuXK296vqYY9VKbtYQ2Y
         htdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=HwoaPhoS6p05+6Q+y0C7EJbnrSAeSDJjW5DKVBz8mhg=;
        b=xEKUMeOtod9ip018EODrT1ehs4eIDZf8buIHycTDvU2FctxyMQh0Ozgvfa2WIZ51HY
         5lOuFblyYpTZOibk4Iz0fbYTLY5LCZ/OtcNr2LIqI7xUTbI1MT34VuGu3EKrmnoWOskY
         VWmEgMVwoyGz4GxgqvlSB8FxePn+3/RLE0ZT9iLb9Z7/NumXB21PDCE+gvS7aAR8KTtM
         8wdq3jq4OYiGTuovtFJnFdbEMrn5IQ5oY41FUWot4TObOXBjplvzN4Y31HGgrvtbj8ST
         zWiJRUSGhvd9M9+typ8j7tNnPUSIdqM365tSBakjbxg6T9cFl06ZzAzq0ME99AN4X2cc
         1dSw==
X-Gm-Message-State: ACgBeo38W0Rldnho8chO6EqjSiPpxbaKNcDyryvMNl7mx1DpCkBAIpOl
        KCwyNXhkbEr+WjG4g28gSsSmaw==
X-Google-Smtp-Source: AA6agR5IkLNhQCq1BkUjRP0ujgvxI96gMiG8ejO8FeNgh2oc1noU34HT99172dmCfg+zpCRG+5WhWw==
X-Received: by 2002:a17:902:d589:b0:174:63e0:5a5c with SMTP id k9-20020a170902d58900b0017463e05a5cmr17210303plh.5.1661882841868;
        Tue, 30 Aug 2022 11:07:21 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 69-20020a630548000000b0042aca53b4cesm1919014pgf.70.2022.08.30.11.07.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 11:07:21 -0700 (PDT)
Date:   Tue, 30 Aug 2022 18:07:17 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH RESEND v2 7/8] KVM: x86/svm/pmu: Direct access
 pmu->gp_counter[] to implement amd_*_to_pmc()
Message-ID: <Yw5R1VUpFaG5cROP@google.com>
References: <20220823093221.38075-1-likexu@tencent.com>
 <20220823093221.38075-8-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220823093221.38075-8-likexu@tencent.com>
X-Spam-Status: No, score=-14.9 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 23, 2022, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> AMD only has gp counters, whose corresponding vPMCs are initialised
> and stored in pmu->gp_counter[] in order of idx, so we can access this

Avoid pronouns, and state what the patch is doing, not what it _can_ do.  IIUC:

  Access PMU counters on AMD by directly indexing the array of general
  purpose counters instead of translating the PMC index to an MSR index.
  AMD only supports gp counters, there's no need to translate a PMC index
  to an MSR index and back to a PMC index.

> array directly based on any valid pmc->idx, without any help from other
> interfaces at all. The amd_rdpmc_ecx_to_pmc() can now reuse this part
> of the code quite naturally.
> 
> Opportunistically apply array_index_nospec() to reduce the attack
> surface for speculative execution and remove the dead code.
> 
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>  arch/x86/kvm/svm/pmu.c | 41 +++++------------------------------------
>  1 file changed, 5 insertions(+), 36 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
> index e9c66dd659a6..e57eb0555a04 100644
> --- a/arch/x86/kvm/svm/pmu.c
> +++ b/arch/x86/kvm/svm/pmu.c
> @@ -33,23 +33,6 @@ enum index {
>  	INDEX_ERROR,
>  };
>  
> -static unsigned int get_msr_base(struct kvm_pmu *pmu, enum pmu_type type)
> -{
> -	struct kvm_vcpu *vcpu = pmu_to_vcpu(pmu);
> -
> -	if (guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE)) {
> -		if (type == PMU_TYPE_COUNTER)
> -			return MSR_F15H_PERF_CTR;
> -		else
> -			return MSR_F15H_PERF_CTL;
> -	} else {
> -		if (type == PMU_TYPE_COUNTER)
> -			return MSR_K7_PERFCTR0;
> -		else
> -			return MSR_K7_EVNTSEL0;
> -	}
> -}
> -
>  static enum index msr_to_index(u32 msr)
>  {
>  	switch (msr) {
> @@ -141,18 +124,12 @@ static bool amd_pmc_is_enabled(struct kvm_pmc *pmc)
>  
>  static struct kvm_pmc *amd_pmc_idx_to_pmc(struct kvm_pmu *pmu, int pmc_idx)
>  {
> -	unsigned int base = get_msr_base(pmu, PMU_TYPE_COUNTER);
> -	struct kvm_vcpu *vcpu = pmu_to_vcpu(pmu);
> +	unsigned int num_counters = pmu->nr_arch_gp_counters;
>  
> -	if (guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE)) {
> -		/*
> -		 * The idx is contiguous. The MSRs are not. The counter MSRs
> -		 * are interleaved with the event select MSRs.
> -		 */
> -		pmc_idx *= 2;
> -	}
> +	if (pmc_idx >= num_counters)
> +		return NULL;
>  
> -	return get_gp_pmc_amd(pmu, base + pmc_idx, PMU_TYPE_COUNTER);
> +	return &pmu->gp_counters[array_index_nospec(pmc_idx, num_counters)];
>  }
>  
>  static bool amd_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
> @@ -168,15 +145,7 @@ static bool amd_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
>  static struct kvm_pmc *amd_rdpmc_ecx_to_pmc(struct kvm_vcpu *vcpu,
>  	unsigned int idx, u64 *mask)
>  {
> -	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> -	struct kvm_pmc *counters;
> -
> -	idx &= ~(3u << 30);
> -	if (idx >= pmu->nr_arch_gp_counters)
> -		return NULL;
> -	counters = pmu->gp_counters;
> -
> -	return &counters[idx];
> +	return amd_pmc_idx_to_pmc(vcpu_to_pmu(vcpu), idx & ~(3u << 30));
>  }
>  
>  static bool amd_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
> -- 
> 2.37.2
> 
