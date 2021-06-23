Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 381863B1B0F
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 15:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbhFWN2z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 09:28:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24829 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230163AbhFWN2y (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Jun 2021 09:28:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624454797;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Jein3OgAGJf2ndq/BFeAbkmeJx56zKLxIWuxbrPBB4M=;
        b=AQfgYJd5hErQjZbJFMvCHfF1anIHEk5B+0Q99IkbetU6tHmq4E5iz4i14NOHwoukYkvOUm
        UFAIjd8olP0RqNHmjjTlssyjDweJFpapjrvVaoYHXKdJgVyWYJfj5v3hNK5uhHstlHh47d
        ykzj2JfUB4RlxG/sLfg05wq1c6IGq3M=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-587-vzNs22m1MHeBTNd40Fk1cQ-1; Wed, 23 Jun 2021 09:26:35 -0400
X-MC-Unique: vzNs22m1MHeBTNd40Fk1cQ-1
Received: by mail-ed1-f72.google.com with SMTP id w1-20020a0564022681b0290394cedd8a6aso1292606edd.14
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 06:26:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Jein3OgAGJf2ndq/BFeAbkmeJx56zKLxIWuxbrPBB4M=;
        b=CUB5z9clbKHL6ea8VxA+bUEk3BLu3p4R6y5PwL/h3w1Y/WlU7E16ejZsY7pL8va9Au
         zGGTWSqKeJS3MIUwrh2tMn3CqsY490pdbZALQmK30YpxLfPDBZGTJr2ch3O8Izf+V/U7
         TgtDbVX/2DEI3/9m2jxzQKKWRLsRaQWOhIuITKKq4Ag1KvHol8C3HGAqXgR8q1XIK5MT
         Uz7rbM638XoHfGRBZ++32QJF1tB/FPfh9o4m4HoMY6mOJaW5gpUKSQRRE5ra/QpGdypZ
         vhDqsG2KfZcqNEQbGw48e5hSsOBjAsNT0QrucwerNaZSnT6t/nloF/SBDPUEA4HwCeyI
         5wlw==
X-Gm-Message-State: AOAM533Y5hIY6FqHwcxpb5T0qoTx178sgVPDH7Nzc157kLHUGgWRtEZh
        ItxIZfAwbs8wAUWS9Pki+7hdHeuLJwX0h7tz7Stt3/Y+OJR8iWTU443DRt+6Kl6Lb5ZYAb/b/83
        sfJTiFDWMF7Z1
X-Received: by 2002:a05:6402:3487:: with SMTP id v7mr12194106edc.378.1624454794585;
        Wed, 23 Jun 2021 06:26:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzzlSOxb7lbpcotdS4uDG5xrI8FxTSTF/ULhHzfoh+poh7JEazeDY32Kvg1DyKRveBLBSH1ww==
X-Received: by 2002:a05:6402:3487:: with SMTP id v7mr12194086edc.378.1624454794437;
        Wed, 23 Jun 2021 06:26:34 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id mm27sm5462669ejb.67.2021.06.23.06.26.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 06:26:33 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86/mmu: Don't WARN on a NULL shadow page in TDP MMU
 check
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>
References: <20210622072454.3449146-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <acb21d4b-679c-69ee-584a-85a6723ace96@redhat.com>
Date:   Wed, 23 Jun 2021 15:26:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210622072454.3449146-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/06/21 09:24, Sean Christopherson wrote:
> Treat a NULL shadow page in the "is a TDP MMU" check as valid, non-TDP
> root.  KVM uses a "direct" PAE paging MMU when TDP is disabled and the
> guest is running with paging disabled.  In that case, root_hpa points at
> the pae_root page (of which only 32 bytes are used), not a standard
> shadow page, and the WARN fires (a lot).
> 
> Fixes: 0b873fd7fb53 ("KVM: x86/mmu: Remove redundant is_tdp_mmu_enabled check")
> Cc: David Matlack <dmatlack@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/mmu/tdp_mmu.h | 10 ++++++----
>   1 file changed, 6 insertions(+), 4 deletions(-)

Queued, thanks.

Paolo

> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> index b981a044ab55..1cae4485b3bc 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.h
> +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> @@ -94,11 +94,13 @@ static inline bool is_tdp_mmu(struct kvm_mmu *mmu)
>   	if (WARN_ON(!VALID_PAGE(hpa)))
>   		return false;
>   
> +	/*
> +	 * A NULL shadow page is legal when shadowing a non-paging guest with
> +	 * PAE paging, as the MMU will be direct with root_hpa pointing at the
> +	 * pae_root page, not a shadow page.
> +	 */
>   	sp = to_shadow_page(hpa);
> -	if (WARN_ON(!sp))
> -		return false;
> -
> -	return is_tdp_mmu_page(sp) && sp->root_count;
> +	return sp && is_tdp_mmu_page(sp) && sp->root_count;
>   }
>   #else
>   static inline bool kvm_mmu_init_tdp_mmu(struct kvm *kvm) { return false; }
> 

