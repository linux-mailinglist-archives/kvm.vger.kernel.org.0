Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33917275E22
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 19:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbgIWRCy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 13:02:54 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:38144 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726381AbgIWRCx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 13:02:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600880571;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wh8ZSulQnN1Zj4DNTEW6JJd0xzaPcYkEfvdxXHeAev8=;
        b=CvIB/meMokjYBcwbtZoPgPl3kctoTZ7WbTjQYDGu+dRMPXJeWxqHJ6kIBgsG6vSd4XmfGv
        exbAGhJ0+5RBz53x+01Vux/cDcVYizdkqUclvwN5v91V1RG4xJZezZiN3VEfBgo2SwWSaw
        5n/iMCtpWTkbV7Ms4OP0x7dIo+o1iU4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-375-uRgESB4YMBWvuvjGq44uGg-1; Wed, 23 Sep 2020 13:02:49 -0400
X-MC-Unique: uRgESB4YMBWvuvjGq44uGg-1
Received: by mail-wr1-f71.google.com with SMTP id d9so77508wrv.16
        for <kvm@vger.kernel.org>; Wed, 23 Sep 2020 10:02:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wh8ZSulQnN1Zj4DNTEW6JJd0xzaPcYkEfvdxXHeAev8=;
        b=HXtTRZSS+MIo4mwd/5Tjpn4E3xk+so6wB5jGCAtKnXSBP9/tPrS2qM6fRn3LtFu1VB
         yig0vXf3HN19aw4cLYJLBuBLhLCryg75DbYBV7XrRfolQMNwkoqgyGd8PqOCW1VpOxBb
         3bXEnx8H4R/SKchZdMLELl1AjNECJ4EntRJBMPD5flYUIf+xztJuVcQo+X0QyaWl6fWa
         FwKwWgxFyhYc+eenc2KeLXZXVcgCmOIQLbh/zzkNMdo3Y+dT8+Z8yCNvDSg17qv4ucc4
         FX0UmcT8CY6fJZlqEPv4KmkUJilq5c4MuhbunpOlRTfHfKkOU9JWDrzorkgb7Sqv1kn2
         p0+g==
X-Gm-Message-State: AOAM533/bWatRAXkPaH9BTT2km/G7AotO4EFmjpAYwlYN8kvAqxAUcjc
        /39ELnN7Lw/l312Ig0Ou2kfIzd1HGTthCRKewlpANb2Cz9k7rcQY4ms8HLK6bdSw+brm97c+ElF
        u3b2doB2INaBA
X-Received: by 2002:a7b:c959:: with SMTP id i25mr532799wml.39.1600880567941;
        Wed, 23 Sep 2020 10:02:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzQEms+v2XPzjI+yTDNOtuowwjrFIgRvbOnHL8okDQ1x8MM4BVX6RRR+HIiTftDIxYMCyn7AA==
X-Received: by 2002:a7b:c959:: with SMTP id i25mr532778wml.39.1600880567699;
        Wed, 23 Sep 2020 10:02:47 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:15f1:648d:7de6:bad9? ([2001:b07:6468:f312:15f1:648d:7de6:bad9])
        by smtp.gmail.com with ESMTPSA id z19sm422712wmi.3.2020.09.23.10.02.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2020 10:02:47 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86/mmu: Move individual kvm_mmu initialization into
 common helper
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200923163314.8181-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <815dfaef-54e3-f0e8-9641-8a87f8910b74@redhat.com>
Date:   Wed, 23 Sep 2020 19:02:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200923163314.8181-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/09/20 18:33, Sean Christopherson wrote:
> Move initialization of 'struct kvm_mmu' fields into alloc_mmu_pages() to
> consolidate code, and rename the helper to __kvm_mmu_create().
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 25 +++++++++----------------
>  1 file changed, 9 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 76c5826e29a2..a2c4c71ce5f2 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5682,11 +5682,17 @@ static void free_mmu_pages(struct kvm_mmu *mmu)
>  	free_page((unsigned long)mmu->lm_root);
>  }
>  
> -static int alloc_mmu_pages(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
> +static int __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
>  {
>  	struct page *page;
>  	int i;
>  
> +	mmu->root_hpa = INVALID_PAGE;
> +	mmu->root_pgd = 0;
> +	mmu->translate_gpa = translate_gpa;
> +	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
> +		mmu->prev_roots[i] = KVM_MMU_ROOT_INFO_INVALID;
> +
>  	/*
>  	 * When using PAE paging, the four PDPTEs are treated as 'root' pages,
>  	 * while the PDP table is a per-vCPU construct that's allocated at MMU
> @@ -5712,7 +5718,6 @@ static int alloc_mmu_pages(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
>  
>  int kvm_mmu_create(struct kvm_vcpu *vcpu)
>  {
> -	uint i;
>  	int ret;
>  
>  	vcpu->arch.mmu_pte_list_desc_cache.kmem_cache = pte_list_desc_cache;
> @@ -5726,25 +5731,13 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
>  	vcpu->arch.mmu = &vcpu->arch.root_mmu;
>  	vcpu->arch.walk_mmu = &vcpu->arch.root_mmu;
>  
> -	vcpu->arch.root_mmu.root_hpa = INVALID_PAGE;
> -	vcpu->arch.root_mmu.root_pgd = 0;
> -	vcpu->arch.root_mmu.translate_gpa = translate_gpa;
> -	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
> -		vcpu->arch.root_mmu.prev_roots[i] = KVM_MMU_ROOT_INFO_INVALID;
> -
> -	vcpu->arch.guest_mmu.root_hpa = INVALID_PAGE;
> -	vcpu->arch.guest_mmu.root_pgd = 0;
> -	vcpu->arch.guest_mmu.translate_gpa = translate_gpa;
> -	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
> -		vcpu->arch.guest_mmu.prev_roots[i] = KVM_MMU_ROOT_INFO_INVALID;
> -
>  	vcpu->arch.nested_mmu.translate_gpa = translate_nested_gpa;
>  
> -	ret = alloc_mmu_pages(vcpu, &vcpu->arch.guest_mmu);
> +	ret = __kvm_mmu_create(vcpu, &vcpu->arch.guest_mmu);
>  	if (ret)
>  		return ret;
>  
> -	ret = alloc_mmu_pages(vcpu, &vcpu->arch.root_mmu);
> +	ret = __kvm_mmu_create(vcpu, &vcpu->arch.root_mmu);
>  	if (ret)
>  		goto fail_allocate_root;
>  
> 

Queued, thanks.

Paolo

