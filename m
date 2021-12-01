Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29CD2465594
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 19:35:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352561AbhLASiU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 13:38:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352637AbhLAShg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 13:37:36 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03FB1C061757
        for <kvm@vger.kernel.org>; Wed,  1 Dec 2021 10:34:09 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id j11so14606244pgs.2
        for <kvm@vger.kernel.org>; Wed, 01 Dec 2021 10:34:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TNj8qTWJnxEXZLTokstR8Ijc0tNxSLtCCzB+7eLAPOI=;
        b=Tt/cO2YnoNUsM7DgujxoSABRUPgPKVoFJZUcwizlLNqmUEectLsAClP7h1xPwmUK+T
         a7a4m1usPQvj1RWHhNZSNsTNgiNbZtafVw4C3c6baL4JPo3t6JGKBj8aHHe/R1VH9Qqb
         7qgVwKv3qCY4TAXKXQcXZZvwvQt74zFUQDaobz8haTIeHvp+4IOHCU8TFPkiEEbP5Oan
         DH3Xf4re918yJwZVRDqOPuPQ3dUUICyZIzg7P8G17n2L/XpaM0+IgGKyEped88Q6tGdP
         x32I4R4+GyFkGeaJvCQ8rq6Pt3Nrmo8U5AqFtguZx6XwN+RqRwym39F6ZB0FOC3mbP3Z
         n4lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TNj8qTWJnxEXZLTokstR8Ijc0tNxSLtCCzB+7eLAPOI=;
        b=i2dIxHgP0oeyZDwFcjPQf6Mu0OykLIvh5WsCOmSzYz3Aez/wEPLtN4ZIg171Ka7CuT
         +uEbuoBUrdNqYRPK1QAzUKxK5XfuhsaAPmAMIGVBboIkSlF0S10EYJXp27kH8OirfLlk
         IoUOPH/B53+LKH/3PDdixmPhLMEi5i5Nchdq/Qwf/l0i2VD/3NmCwDUMCzZ5WuX2tdXp
         xCf87iiqa1fWhMPncwB3gVVT7dVy+Eey1sQoVlSrxHBDv/yJQBsmM67yko0TtzcvIyZI
         eY2i6DJETllRvdfb907wdd4L2Ko5P4+bJpbuSB9aUuBKvRpA1EIJhvbXOQ+lVwCyMTco
         vwrg==
X-Gm-Message-State: AOAM530MCzif67fzF4aCDD1RVzwMs78KSJy+B12l/cBsRUt9o+LxzpXn
        vW5SIWnmc3jI8u29IDEQDNw2Aw==
X-Google-Smtp-Source: ABdhPJzR7tCtEfGay7KNepfsKMjYsZj4fLw2QVqqBk/dLmdIkiBjtYpzU46FK3nmhlVW4gOyzAtHEQ==
X-Received: by 2002:a05:6a00:c95:b0:49f:c8de:9ae7 with SMTP id a21-20020a056a000c9500b0049fc8de9ae7mr7898377pfv.30.1638383649335;
        Wed, 01 Dec 2021 10:34:09 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 38sm308232pgl.73.2021.12.01.10.34.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 10:34:08 -0800 (PST)
Date:   Wed, 1 Dec 2021 18:34:05 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>
Subject: Re: [RFC PATCH 08/15] KVM: x86/mmu: Helper method to check for large
 and present sptes
Message-ID: <YafAHTRyFMZRNGKi@google.com>
References: <20211119235759.1304274-1-dmatlack@google.com>
 <20211119235759.1304274-9-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211119235759.1304274-9-dmatlack@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 19, 2021, David Matlack wrote:
> Consolidate is_large_pte and is_present_pte into a single helper. This
> will be used in a follow-up commit to check for present large-pages
> during Eager Page Splitting.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/kvm/mmu/spte.h    | 5 +++++
>  arch/x86/kvm/mmu/tdp_mmu.c | 3 +--
>  2 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> index cc432f9a966b..e73c41d31816 100644
> --- a/arch/x86/kvm/mmu/spte.h
> +++ b/arch/x86/kvm/mmu/spte.h
> @@ -257,6 +257,11 @@ static inline bool is_large_pte(u64 pte)
>  	return pte & PT_PAGE_SIZE_MASK;
>  }
>  
> +static inline bool is_large_present_pte(u64 pte)
> +{
> +	return is_shadow_present_pte(pte) && is_large_pte(pte);
> +}
> +
>  static inline bool is_last_spte(u64 pte, int level)
>  {
>  	return (level == PG_LEVEL_4K) || is_large_pte(pte);
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index ff4d83ad7580..f8c4337f1fcf 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1011,8 +1011,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  		 * than the target, that SPTE must be cleared and replaced
>  		 * with a non-leaf SPTE.
>  		 */
> -		if (is_shadow_present_pte(iter.old_spte) &&
> -		    is_large_pte(iter.old_spte)) {
> +		if (is_large_present_pte(iter.old_spte)) {

I strongly object to this helper.  PRESENT in hardware and shadow-present are two
very different things, the name is_large_present_pte() doesn't capture that detail.
Yeah, we could name it is_large_shadow_present_pte(), but for me at least that
requires more effort to read, and it's not like this is replacing 10s of instances.

>  			if (!tdp_mmu_zap_spte_atomic(vcpu->kvm, &iter))
>  				break;
>  		}
> -- 
> 2.34.0.rc2.393.gf8c9666880-goog
> 
