Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E16548EB16
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 14:50:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241438AbiANNtU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 08:49:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241319AbiANNtS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jan 2022 08:49:18 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6A74C061574
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 05:49:17 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id h10so15741359wrb.1
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 05:49:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SplDRCa6NNrw+jmw+XcUlhx9ZxjilxrjFesGl7lzU8g=;
        b=a8+JP378o1HAvFjmRAXUOS92EqYOCCF88AwdX0/glSzNwYInZgQODDEMtel8YNg43L
         yYJWvN218zskoZeANgcb1mJ8YkIikwhMIQ/j/c2EwwWlx1AyTftWuWJLK/q4DO2x9KhF
         SX2Q17/rj7UDxp1MxMU5n5EyscAbo+Y6gBeBFRUUqZnOhohMNv3u0xHpRXG88P5rCodV
         J6ZzYoj2CCEzrG1fanC9jK06RN3WeAj2R91MreRQDcoTPbOu0SdKk3oOkZyPWai0cSxg
         Run8+wVv5fEmM8o7zcChBaWTpUjMXF7lpEXzUR8WOjnviB7ezlfmvN16E2LaKXWslsnM
         g8PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SplDRCa6NNrw+jmw+XcUlhx9ZxjilxrjFesGl7lzU8g=;
        b=p2kNRRFyDCrt8LJ945oNRTlREFK3Pkuh5Ur87fPvIntw5gJ80BEzF1dZDT77ot+Hjd
         +8eKFDAiYyDLpIybjKuNnJ887t91kZ6YL+YkJLWBZ1R6wRh3KrTEMHnIOvlQSKs0/Icv
         wEwEESc2iCcPTveYOf1sm46Wqk/ZXFM7msxc0lNwsoGPHZ847gf/5uJ8D8d8ZorSEhVT
         6UG/aGkMJdA6UM6oFKnddxC7uaKMczhWysnDdVCoRcbf0cr25aTFDYP0kk93i+Flz8MH
         1p0VSofBu+9URVwFMw2JAYFG97ztfY5MIR9594K5ro/uhs1xBhoTFJ2CDCrN91ydtFZd
         fR0w==
X-Gm-Message-State: AOAM532aBIuUYRhZcDwFW50AE6LnfJNh0fwNHxhrs+H1jl7BJeyX2dE2
        XNujPvI4huSZxoIrmpvUWZtPlyUU0R9EpA==
X-Google-Smtp-Source: ABdhPJwoUoCO5g9qpmclfYXylg3VPdHOz196vgmYaxgcYpAG6lUSt03T/h3hujcZM8T0T16gsvO79w==
X-Received: by 2002:a05:6000:18a5:: with SMTP id b5mr8486696wri.24.1642168156403;
        Fri, 14 Jan 2022 05:49:16 -0800 (PST)
Received: from google.com ([2a00:79e0:d:210:d47e:30f8:4fad:745b])
        by smtp.gmail.com with ESMTPSA id f15sm1858029wmq.38.2022.01.14.05.49.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 05:49:15 -0800 (PST)
Date:   Fri, 14 Jan 2022 13:49:12 +0000
From:   Quentin Perret <qperret@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH] KVM: arm64: pkvm: Use the mm_ops indirection for cache
 maintenance
Message-ID: <YeF/WMXe4HL/n8qw@google.com>
References: <20220114125038.1336965-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220114125038.1336965-1-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Friday 14 Jan 2022 at 12:50:38 (+0000), Marc Zyngier wrote:
> CMOs issued from EL2 cannot directly use the kernel helpers,
> as EL2 doesn't have a mapping of the guest pages. Oops.
> 
> Instead, use the mm_ops indirection to use helpers that will
> perform a mapping at EL2 and allow the CMO to be effective.

Right, we were clearly lucky not to use those paths at EL2 _yet_, but
that's going to change soon and this is better for consistency, so:

Reviewed-by: Quentin Perret <qperret@google.com>

> Fixes: 25aa28691bb9 ("KVM: arm64: Move guest CMOs to the fault handlers")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/pgtable.c | 18 ++++++------------
>  1 file changed, 6 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 844a6f003fd5..2cb3867eb7c2 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -983,13 +983,9 @@ static int stage2_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
>  	 */
>  	stage2_put_pte(ptep, mmu, addr, level, mm_ops);
>  
> -	if (need_flush) {
> -		kvm_pte_t *pte_follow = kvm_pte_follow(pte, mm_ops);
> -
> -		dcache_clean_inval_poc((unsigned long)pte_follow,
> -				    (unsigned long)pte_follow +
> -					    kvm_granule_size(level));
> -	}
> +	if (need_flush && mm_ops->dcache_clean_inval_poc)
> +		mm_ops->dcache_clean_inval_poc(kvm_pte_follow(pte, mm_ops),
> +					       kvm_granule_size(level));
>  
>  	if (childp)
>  		mm_ops->put_page(childp);
> @@ -1151,15 +1147,13 @@ static int stage2_flush_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
>  	struct kvm_pgtable *pgt = arg;
>  	struct kvm_pgtable_mm_ops *mm_ops = pgt->mm_ops;
>  	kvm_pte_t pte = *ptep;
> -	kvm_pte_t *pte_follow;
>  
>  	if (!kvm_pte_valid(pte) || !stage2_pte_cacheable(pgt, pte))
>  		return 0;
>  
> -	pte_follow = kvm_pte_follow(pte, mm_ops);
> -	dcache_clean_inval_poc((unsigned long)pte_follow,
> -			    (unsigned long)pte_follow +
> -				    kvm_granule_size(level));
> +	if (mm_ops->dcache_clean_inval_poc)
> +		mm_ops->dcache_clean_inval_poc(kvm_pte_follow(pte, mm_ops),
> +					       kvm_granule_size(level));
>  	return 0;
>  }
>  
> -- 
> 2.30.2
> 
