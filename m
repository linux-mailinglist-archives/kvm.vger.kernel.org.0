Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 399313F1DF4
	for <lists+kvm@lfdr.de>; Thu, 19 Aug 2021 18:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbhHSQiN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Aug 2021 12:38:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229465AbhHSQiM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Aug 2021 12:38:12 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5548EC061575
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 09:37:36 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id k19so6019041pfc.11
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 09:37:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=113bVJbsP9diowruwEeCAKf5QQDoYra/E0SzbMOGGlY=;
        b=RzLmC+/Cy/M7zc24FvWrozMC1HWaWjizmEelwunmGWserl9ZC+HiwQ0F6/FLz9tXIL
         waRQHBGrsUV0dQ4dtGUxmxVAewowYAdxlCnoAPJVrXQED02XxeeXn2Gj7VtTr6DIqpM1
         AtlAhjftCgk0UkHk6pnnwl61T0spE85LsZ+qmQAXIwy/Ns78N5eXRQzVngWfpo4tkK9t
         DdrTomYy3bSeR/f2iDDaUvhOn66sKjuyFzPcuklLdaGGArX1LuxX2BZMqZHi+Kr9Curg
         cYYyua2VwnNJLp78GQYZKQBxDUMhCFKd6Ph1CRc9em/GEOf3/61N27uy4Hwavwef3vFG
         ALIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=113bVJbsP9diowruwEeCAKf5QQDoYra/E0SzbMOGGlY=;
        b=cnlVOC4OuQvXdykalO0ARI7tbrU68XzMMnV7pfopXX6bPHv6+geXSwWv8PrfYDsFRz
         nQgRh/qdR55p8lbzPRnEVQRfp+sJ4ckAhNmJyy7C64tObMrOS+L4099JIVTw1t/X9CNI
         pOe2rD9kPNZNpv+Q9FpjRskCKkyUyhkZUopWbzsdLjBwlUFTANUgvcfIPFAv91/BxRAn
         kBhzt4sQ8vjqFuHENnG/W4/KFEpGjGPqoXeTUvUIFkG/TJu94oMGB1I45FjaWO5V0T14
         UuVvFW3SCEz3Tx7UGJL+hbFBw088rXzaERUcvQOgI1pluME8eLdqkb8htoEYGj4qFjrq
         yczw==
X-Gm-Message-State: AOAM533lL+xU+/V0PR2u7CSWp+ZgurHZOGlA80ZNx+lghuXbCNMOBRWe
        sxQ/NFBFFa2VnfPsGfgYJbxsIg==
X-Google-Smtp-Source: ABdhPJw94yPjz6lkpQeH4PMVXdutytK/se+SZVHyaKAXsf4M6GT/CAc6297WbxdZ5baSLbxGO3Hjdg==
X-Received: by 2002:a63:b59:: with SMTP id a25mr14635125pgl.373.1629391055651;
        Thu, 19 Aug 2021 09:37:35 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b12sm4074197pff.63.2021.08.19.09.37.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 09:37:34 -0700 (PDT)
Date:   Thu, 19 Aug 2021 16:37:29 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [RFC PATCH 3/6] KVM: x86/mmu: Pass the memslot around via struct
 kvm_page_fault
Message-ID: <YR6Iyc3PNqUey7LM@google.com>
References: <20210813203504.2742757-1-dmatlack@google.com>
 <20210813203504.2742757-4-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210813203504.2742757-4-dmatlack@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 13, 2021, David Matlack wrote:
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 3352312ab1c9..fb2c95e8df00 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2890,7 +2890,7 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm,
>  
>  void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  {
> -	struct kvm_memory_slot *slot;
> +	struct kvm_memory_slot *slot = fault->slot;
>  	kvm_pfn_t mask;
>  
>  	fault->huge_page_disallowed = fault->exec && fault->nx_huge_page_workaround_enabled;
> @@ -2901,8 +2901,7 @@ void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>  	if (is_error_noslot_pfn(fault->pfn) || kvm_is_reserved_pfn(fault->pfn))
>  		return;
>  
> -	slot = gfn_to_memslot_dirty_bitmap(vcpu, fault->gfn, true);
> -	if (!slot)
> +	if (kvm_slot_dirty_track_enabled(slot))

This is unnecessarily obfuscated.  It relies on the is_error_noslot_pfn() to
ensure fault->slot is valid, but the only reason that helper is used is because
it was the most efficient code when slot wasn't available.  IMO, this would be
better:

	if (!slot || kvm_slot_dirty_track_enabled(slot))
		return;

	if (kvm_is_reserved_pfn(fault->pfn))
		return;

On a related topic, a good follow-up to this series would be to pass @fault into
the prefetch helpers, and modify the prefetch logic to re-use fault->slot and
refuse to prefetch across memslot boundaries.  That would eliminate all users of
gfn_to_memslot_dirty_bitmap() and allow us to drop that abomination.
