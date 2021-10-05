Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 516224227B0
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 15:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235054AbhJENYM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 09:24:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42914 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234170AbhJENYK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Oct 2021 09:24:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633440139;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WIETha6aSNqE3UiAS7WZd4oRBcDL4c/PhFnZrRoUf/o=;
        b=gKlrp5f3oesfEK7cYA4FzMGOYT5RwGSKtUgfRpptAwsKIad6teMEK9pjpZ6uR/SOg8g4rg
        XL72c1zIvm5M/rNWzWrxCClrpqSBNMyaiLXxxrzx5IbIZFQMUgC+lvuB1c1VE+A3jxGkw2
        hkJrpsQJysQDJxQuZlHecPzrAv5icOY=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-346-35e3B37GPvqiG6CM5KbUVg-1; Tue, 05 Oct 2021 09:22:18 -0400
X-MC-Unique: 35e3B37GPvqiG6CM5KbUVg-1
Received: by mail-ed1-f69.google.com with SMTP id i7-20020a50d747000000b003db0225d219so3441466edj.0
        for <kvm@vger.kernel.org>; Tue, 05 Oct 2021 06:22:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WIETha6aSNqE3UiAS7WZd4oRBcDL4c/PhFnZrRoUf/o=;
        b=WTFrEiZttfVewHZZiOA7vGe9zkeasiF8kALukyIri7cVx5VXB3D5/frObF6peAml4C
         wTZFCvRdRx6OgfWAQpJXfXToXsw+rPcJExzMUNYL1XeI8TkfYj9ijKR6pvBpA23fj2NC
         bwiyOqhW1iz+0WgKVkqOtjaImcFzz+pg6krCZqvauISpWkKC/S35n+OQHj7CrrrpzJcY
         YkknHZ0LC1W9TdOtVZF1OY5P+weqjQPwoO9HMux9p8s3sCiwp3dg6qtQ4b27fGjxGmAL
         X+iRpNcTMrEqNCqULqm1UufwrQJpawiVoSw/NWj4yWqwqGoushcH7Rwf+BiNoO2Lg3VT
         bT0g==
X-Gm-Message-State: AOAM532EgOatDTEQTTe4gTQgjqCUzYxOW+hPvMOgH3JKv6B4AFgVpZxw
        Re2wJbnXvehDcTounZ/ZS87WJcko4ycguhH8Ukcs9Ja1KXm0z1GGwwx7rSybWswBbxz2SG4H70P
        i4+RESKj8BwWg
X-Received: by 2002:a05:6402:12c2:: with SMTP id k2mr40361edx.210.1633440136890;
        Tue, 05 Oct 2021 06:22:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx9pp/WOSkii/F5wDdwkrNtVlDY449U7XBNE0reOoicJr6VkeCprvTth5Y6zAJqwdtuYOl5lA==
X-Received: by 2002:a05:6402:12c2:: with SMTP id k2mr40335edx.210.1633440136723;
        Tue, 05 Oct 2021 06:22:16 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
        by smtp.gmail.com with ESMTPSA id t14sm7807111ejf.24.2021.10.05.06.22.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 06:22:16 -0700 (PDT)
Date:   Tue, 5 Oct 2021 15:22:14 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v2 01/11] KVM: arm64: Drop unused vcpu param to
 kvm_psci_valid_affinity()
Message-ID: <20211005132214.vcnvg7ckl6wpu3lq@gator.home>
References: <20210923191610.3814698-1-oupton@google.com>
 <20210923191610.3814698-2-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210923191610.3814698-2-oupton@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 23, 2021 at 07:16:00PM +0000, Oliver Upton wrote:
> The helper function does not need a pointer to the vCPU, as it only
> consults a constant mask; drop the unused vcpu parameter.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/arm64/kvm/psci.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
> index 74c47d420253..d46842f45b0a 100644
> --- a/arch/arm64/kvm/psci.c
> +++ b/arch/arm64/kvm/psci.c
> @@ -59,8 +59,7 @@ static void kvm_psci_vcpu_off(struct kvm_vcpu *vcpu)
>  	kvm_vcpu_kick(vcpu);
>  }
>  
> -static inline bool kvm_psci_valid_affinity(struct kvm_vcpu *vcpu,
> -					   unsigned long affinity)
> +static inline bool kvm_psci_valid_affinity(unsigned long affinity)
>  {
>  	return !(affinity & ~MPIDR_HWID_BITMASK);
>  }
> @@ -73,7 +72,7 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
>  	unsigned long cpu_id;
>  
>  	cpu_id = smccc_get_arg1(source_vcpu);
> -	if (!kvm_psci_valid_affinity(source_vcpu, cpu_id))
> +	if (!kvm_psci_valid_affinity(cpu_id))
>  		return PSCI_RET_INVALID_PARAMS;
>  
>  	vcpu = kvm_mpidr_to_vcpu(kvm, cpu_id);
> @@ -132,7 +131,7 @@ static unsigned long kvm_psci_vcpu_affinity_info(struct kvm_vcpu *vcpu)
>  	target_affinity = smccc_get_arg1(vcpu);
>  	lowest_affinity_level = smccc_get_arg2(vcpu);
>  
> -	if (!kvm_psci_valid_affinity(vcpu, target_affinity))
> +	if (!kvm_psci_valid_affinity(target_affinity))
>  		return PSCI_RET_INVALID_PARAMS;
>  
>  	/* Determine target affinity mask */
> -- 
> 2.33.0.685.g46640cef36-goog
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

