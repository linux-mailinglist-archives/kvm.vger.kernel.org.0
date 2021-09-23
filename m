Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55B9B416360
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 18:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242158AbhIWQcj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 12:32:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60080 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231518AbhIWQci (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Sep 2021 12:32:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632414666;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ReAUQEHsAwKoa1q6RysvsYhI2ACNzTPfF8Hdy5iXMw0=;
        b=YIiivgl1/bYasMmjsKsj44q/8oCLAyVON6aBNSkzFY9htDYEHMwlkAL0RO3U+USEAMu+JE
        /qm6fW0KkSQ0QbunXyIRueWng/zPDwbyUUz676cH44avKrF27YGfVRNV7h3RrjWKra5kMv
        NHseZcoNQH6Avw/uw6Z2FmZnoIxtgb0=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-199-Si3cy6loO9mRfLWXxHrPSA-1; Thu, 23 Sep 2021 12:31:05 -0400
X-MC-Unique: Si3cy6loO9mRfLWXxHrPSA-1
Received: by mail-ed1-f72.google.com with SMTP id w24-20020a056402071800b003cfc05329f8so7295087edx.19
        for <kvm@vger.kernel.org>; Thu, 23 Sep 2021 09:31:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ReAUQEHsAwKoa1q6RysvsYhI2ACNzTPfF8Hdy5iXMw0=;
        b=69lmQw/SZT2KtMCjrARWbHuQmAlLYw1V8CwQ6KMjmPomReUiS54mlIZ2j1T4PXSg/L
         M11mNF5WrYS7Kk1BvW+weQ3S59OGJbo+eFQwSjhxRIkJ2illjYOae9GNk2ZP4v54U0wH
         jb4ZKHO8LgpXW5Q/yKgy3b9nnm7410I+WirkhnIixiO6xWay6jMWFys5frdxCwqmNYf7
         gWqn3UOYeNUJ0iYBUZBMMw07coOso2R50E2WtUqNf1Pl696uVo59nFsvgtXL6QGZrQWL
         kHexpQCXK1/NsDN1ZoQwp8NPk7bRnUIXq0ZTE7rlc4fEC6uHTH7LdR4GV7cmFIpHHm4P
         ahWA==
X-Gm-Message-State: AOAM530jjTrfkVYukCBcS0xl3xU4ExnRNTddcVzJxNLNl7/9ngg/dKEd
        7M51niTqw3X2MT1R7AzK1EQDMgEQl9UTtQ+0NEGkzya0Cd+4iKEdvUvYC8gOSaf6KtYEtv3iUfw
        XL0CSyBvDqAjH
X-Received: by 2002:a17:906:b0c8:: with SMTP id bk8mr6075162ejb.412.1632414664133;
        Thu, 23 Sep 2021 09:31:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwInEIsJxSHkzX1MDiYbYOZkhAwP9PSkQ8WrzNvIgdL9T6O1HyCF8t8hj/Oj2Pf+4HO4t6zxg==
X-Received: by 2002:a17:906:b0c8:: with SMTP id bk8mr6075143ejb.412.1632414663949;
        Thu, 23 Sep 2021 09:31:03 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id bq4sm3385984ejb.43.2021.09.23.09.31.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Sep 2021 09:31:03 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86/mmu: Refactor slot null check in
 kvm_mmu_hugepage_adjust
To:     David Matlack <dmatlack@google.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <20210824233407.1845924-1-dmatlack@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5082d726-c54b-8f80-09d9-490ef7ace6ef@redhat.com>
Date:   Thu, 23 Sep 2021 18:31:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210824233407.1845924-1-dmatlack@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/08/21 01:34, David Matlack wrote:
> The current code is correct but relies on is_error_noslot_pfn() to
> ensure slot is not null. The only reason is_error_noslot_pfn() was
> checked instead is because we did not have the slot before
> commit 6574422f913e ("KVM: x86/mmu: Pass the memslot around via struct
> kvm_page_fault") and looking up the memslot is expensive.
> 
> Now that the slot is available, explicitly check if it's null and
> get rid of the redundant is_error_noslot_pfn() check.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>   arch/x86/kvm/mmu/mmu.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 4853c033e6ce..9b5424bcb173 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2925,10 +2925,10 @@ void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>   	if (unlikely(fault->max_level == PG_LEVEL_4K))
>   		return;
>   
> -	if (is_error_noslot_pfn(fault->pfn) || kvm_is_reserved_pfn(fault->pfn))
> +	if (!slot || kvm_slot_dirty_track_enabled(slot))
>   		return;
>   
> -	if (kvm_slot_dirty_track_enabled(slot))
> +	if (kvm_is_reserved_pfn(fault->pfn))
>   		return;
>   
>   	/*
> 

Squashed, thanks.

Paolo

