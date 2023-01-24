Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3CA67A3B6
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 21:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbjAXURG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 15:17:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbjAXURE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 15:17:04 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2102421967
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 12:17:04 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id h5-20020a17090a9c0500b0022bb85eb35dso10761260pjp.3
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 12:17:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tnps9xVOfH3PPgr1zmMdnLEIT0DDz3WfUqZSEXwwr/o=;
        b=PpouaE7EQFpmqsL1Ig1tmZQ2vY/kUcmPs518HqRUfERC1WUr9/VrTyAAqx2b19/IOe
         jeLrXDTuNSo1K3fPhFzl4ObsptGiZxNHj82Dcp63npD6NRe3sAUdEj+1lLAeuYlQCAUx
         cdszV8gVi4Cd1dOGzsiwwF1ghOcyqkuJkVpWJ49/BYlbVqqmksdMMJcXno4VLpizhL0c
         6h8DZKy4euhH0OexghXa01BXsfj6tGkgSNxS6k2jx3rzmU+JRzUtVoCACWJiSXI4tb8x
         Ro+bEzJfRx3k7MVWkTqVolNK5Edh8LOoN+l6VU4mSfPWn/qVvDNQwEdVW5MOya5+oQUV
         AAlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tnps9xVOfH3PPgr1zmMdnLEIT0DDz3WfUqZSEXwwr/o=;
        b=HQw1O8IT4wMGzVGzBRnk9QsDassRcUlE8LKZcbNTDO/0xKDSKpOxwl+4fUgH5DRbJk
         Pz4U/JLsaKwDZ6+C5SEqEsklDTU1PghEbqZx3uCPV6j2J8BhxbmWZQ8eroDRAVYjaPsN
         SN4eMb/dLVcSUCyI2ZU5Wk2QN4b3RzZSRSuJgPjCshEFgURMbyIFCtKFPhcA62hkEq2d
         eGk94BS2wfmZOGKELH5DG+iO7aanbet0YKphwj7UStTOqloNCvWbHCIn7/kuRjDG9EJp
         LBsypA4Q2fqFxHgrZJ+424WtZGFj1PiAYGl6I4DrAzkxAPomEw56rIFXYI5MdifU5tPF
         LLZA==
X-Gm-Message-State: AO0yUKWFiW9AKbXDprNt5ZXzd+aQEKkd7/GNBSEaLLz7Dd00skyKQGia
        Ui9/rJJV3YvxDXvEN8RbtpFprw==
X-Google-Smtp-Source: AK7set9y7Vwacso7iTYoyGLt9NtJsrhqIV/kv0DQvGcm/i9oxewbjuP0k3okxbtp//izfppyEAaZqg==
X-Received: by 2002:a17:903:2644:b0:189:b910:c6d2 with SMTP id je4-20020a170903264400b00189b910c6d2mr272488plb.1.1674591423366;
        Tue, 24 Jan 2023 12:17:03 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 13-20020a170902c24d00b00192aa53a7d5sm2104936plg.8.2023.01.24.12.17.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 12:17:02 -0800 (PST)
Date:   Tue, 24 Jan 2023 20:16:59 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/8] KVM: x86/pmu: Rewrite reprogram_counters() to
 improve performance
Message-ID: <Y9A8u3AqvUWc7pwL@google.com>
References: <20221111102645.82001-1-likexu@tencent.com>
 <20221111102645.82001-4-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221111102645.82001-4-likexu@tencent.com>
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

On Fri, Nov 11, 2022, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> A valid pmc is always tested before using pmu->reprogram_pmi. Eliminate
> this part of the redundancy by setting the counter's bitmask directly,
> and in addition, trigger KVM_REQ_PMU only once to save more cpu cycles.

It's a little silly, but can you split this into two patches?  First optimize the
helper, then expose it in pmu.h.  The optimization stands on its own, whereas the
code movement is justified only by the incoming AMD PMU v2 support.

> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>  arch/x86/kvm/pmu.h           | 11 +++++++++++
>  arch/x86/kvm/vmx/pmu_intel.c | 12 ------------
>  2 files changed, 11 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> index 2b5376ba66ea..be552c8217a0 100644
> --- a/arch/x86/kvm/pmu.h
> +++ b/arch/x86/kvm/pmu.h
> @@ -189,6 +189,17 @@ static inline void kvm_pmu_request_counter_reprogam(struct kvm_pmc *pmc)
>  	kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
>  }
>  
> +static inline void reprogram_counters(struct kvm_pmu *pmu, u64 diff)
> +{
> +	int bit;
> +
> +	if (diff) {
> +		for_each_set_bit(bit, (unsigned long *)&diff, X86_PMC_IDX_MAX)
> +			__set_bit(bit, pmu->reprogram_pmi);
> +		kvm_make_request(KVM_REQ_PMU, pmu_to_vcpu(pmu));
> +	}
> +}
> +
>  void kvm_pmu_deliver_pmi(struct kvm_vcpu *vcpu);
>  void kvm_pmu_handle_event(struct kvm_vcpu *vcpu);
>  int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned pmc, u64 *data);
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 2f7cd388859c..db704eea2d7c 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -68,18 +68,6 @@ static struct kvm_pmc *intel_pmc_idx_to_pmc(struct kvm_pmu *pmu, int pmc_idx)
>  	}
>  }
>  
> -static void reprogram_counters(struct kvm_pmu *pmu, u64 diff)
> -{
> -	int bit;
> -	struct kvm_pmc *pmc;
> -
> -	for_each_set_bit(bit, (unsigned long *)&diff, X86_PMC_IDX_MAX) {
> -		pmc = intel_pmc_idx_to_pmc(pmu, bit);
> -		if (pmc)
> -			kvm_pmu_request_counter_reprogam(pmc);
> -	}
> -}
> -
>  static bool intel_hw_event_available(struct kvm_pmc *pmc)
>  {
>  	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
> -- 
> 2.38.1
> 
