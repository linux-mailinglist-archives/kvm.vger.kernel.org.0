Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75A906BA03
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2019 12:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbfGQKXb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jul 2019 06:23:31 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42477 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbfGQKXb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Jul 2019 06:23:31 -0400
Received: by mail-wr1-f68.google.com with SMTP id x1so9179520wrr.9
        for <kvm@vger.kernel.org>; Wed, 17 Jul 2019 03:23:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OgDJWdqKExQDn29jdefxbq2X4b+zlsDENGAuQ8C2S/0=;
        b=bdGn/9NVWSgeLIk/Fb6xalqH8ZlOdhnT4mOR4H0Tma6uXgQZ74LoDD7ve0uhINnoVE
         Bzb/OQy+eH+wc1Ad4squZ7lH9Q/+85HS2LanuEitekUzVWCClVw7OXhfr4YdsqK/GKJf
         Yq351MIIlke0AxavuErjEamEWqa4R+zlkVg3jJhvdT+cSRuLYkyJvgVvoTqgYb5xXHfi
         tlFkUyrFHBlp3Ke4tOAT9h5skr957GBhXa5knthKtgX+qvurlOTFi7kvWx+unIvmUp/P
         XvAgMlPwBn7em9bSaH4l6SE1XFYDSEJXZy8WvakUthaiAsy7t+rHUfqOn1vXe6hYs/KT
         4mxA==
X-Gm-Message-State: APjAAAVqpIFctKSajhuj8e/1+RqkFl1I5m4C/5SKb4VKoWnefK2FuLpr
        sh+13lh2GLlsIEdWW7IihEvSno5LpOT7Ww==
X-Google-Smtp-Source: APXvYqwr7wStccjcUL3kS2LjSeL9qna9HUuZyfa6OlP+sb0srZC6+du92eULywd0hzhEbzXZw6cr5g==
X-Received: by 2002:a05:6000:187:: with SMTP id p7mr39272926wrx.189.1563359008856;
        Wed, 17 Jul 2019 03:23:28 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e427:3beb:1110:dda2? ([2001:b07:6468:f312:e427:3beb:1110:dda2])
        by smtp.gmail.com with ESMTPSA id t24sm21805289wmj.14.2019.07.17.03.23.28
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 17 Jul 2019 03:23:28 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86/vPMU: reset pmc->counter to 0 for pmu
 fixed_counters
To:     Like Xu <like.xu@linux.intel.com>
Cc:     wehuang@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190717025118.16783-1-like.xu@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <20682ae6-5699-3963-318e-55a177ccd57f@redhat.com>
Date:   Wed, 17 Jul 2019 12:23:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190717025118.16783-1-like.xu@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/07/19 04:51, Like Xu wrote:
> To avoid semantic inconsistency, the fixed_counters in Intel vPMU
> need to be reset to 0 in intel_pmu_reset() as gp_counters does.
> 
> Signed-off-by: Like Xu <like.xu@linux.intel.com>
> ---
>  arch/x86/kvm/vmx/pmu_intel.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 68d231d49c7a..4dea0e0e7e39 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -337,17 +337,22 @@ static void intel_pmu_init(struct kvm_vcpu *vcpu)
>  static void intel_pmu_reset(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> +	struct kvm_pmc *pmc = NULL;
>  	int i;
>  
>  	for (i = 0; i < INTEL_PMC_MAX_GENERIC; i++) {
> -		struct kvm_pmc *pmc = &pmu->gp_counters[i];
> +		pmc = &pmu->gp_counters[i];
>  
>  		pmc_stop_counter(pmc);
>  		pmc->counter = pmc->eventsel = 0;
>  	}
>  
> -	for (i = 0; i < INTEL_PMC_MAX_FIXED; i++)
> -		pmc_stop_counter(&pmu->fixed_counters[i]);
> +	for (i = 0; i < INTEL_PMC_MAX_FIXED; i++) {
> +		pmc = &pmu->fixed_counters[i];
> +
> +		pmc_stop_counter(pmc);
> +		pmc->counter = 0;
> +	}
>  
>  	pmu->fixed_ctr_ctrl = pmu->global_ctrl = pmu->global_status =
>  		pmu->global_ovf_ctrl = 0;
> 

Queued, thanks.

Paolo
