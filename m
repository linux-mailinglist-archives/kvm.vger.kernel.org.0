Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4573D97A5
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 23:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbhG1VjJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 17:39:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231126AbhG1VjJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jul 2021 17:39:09 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 156DBC061765
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 14:39:07 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id ca5so7138374pjb.5
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 14:39:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1pCBBANwP4lCEROvCIglnNy/B+CbZOUBRLt1GZJf6U4=;
        b=U3ZSEcMNZZa5frC7VPZvtq1I/O6wLdxNooyKXz8X92c9a+tebcMRUDAMYOIC+rbT1F
         H3/aJkSS91GQJHq2q8U3PFnvNZpG0Nfzd1MVVCONCKfZbhQ/JzMDp4v3IP839G1JfLxL
         mKnHkDRjtxkSfwNBK0N1kP8MluBl62wTH8x5BgTHwbtafsNZGUtd2Q0hqa4VO1pKj3Up
         XpbU1u9HZND6dCSj4ocwi2J0aa7mZeHMsDkwpW9npNZQ0IS6uV2EyMsXKJnzC7CMeyIn
         d+K1KOLHHhCTKcnLWi5jR/s2pwcg8wQyESqyZVi/CKQT4sOIYyGe+07d/GfjM5RqHesg
         lrfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1pCBBANwP4lCEROvCIglnNy/B+CbZOUBRLt1GZJf6U4=;
        b=jSHjRkDR1tcJmoleE5hZBobiln2vUJroBLxWLtTMB4qprzvhC2CO4YKMTmlQJitv4z
         9Sw1Mnk9tuHfFOyYXZkfTMg7YRcg6M452QYfHIgTj8IdTG5dYnum/eDNI+BzAX2fc9fe
         ubmEHZwmYPSXFO9BvbEUa2zkVhKNRu2E4IGLh9xb38+FrS7GBl+hsfc6vcq9T6AVZJDy
         A1HwP/2M9+dwQJ7pr8IXB+W46PN4APjgxyTtIU4so/vBgEiZSDRcCt5pHP+5PBgRxMPq
         4kpMla3RIe+aOHyExoNBnO4WLzl7DdltRPuRNlp/u5HIud2jGlyFh8QWdpKuWs+SyLNf
         KjDA==
X-Gm-Message-State: AOAM533KqDWwTGUkdH4CpWsahlXZzrhNIDljTplpwixKxbg6EWfCY9C7
        blCdMH3GaAWQEIPECkAHesJZKQ==
X-Google-Smtp-Source: ABdhPJxB2ycRY2M9KCVse9bpEuwUyGBIfWUCdkDU3uLL7JvY9I4LiJIFciuVE6EcVj7mBcCQItQuEw==
X-Received: by 2002:a17:902:e051:b029:12b:4f40:7c7c with SMTP id x17-20020a170902e051b029012b4f407c7cmr1624118plx.20.1627508346346;
        Wed, 28 Jul 2021 14:39:06 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p17sm7021082pjz.16.2021.07.28.14.39.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 14:39:05 -0700 (PDT)
Date:   Wed, 28 Jul 2021 21:39:02 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 9/9] KVM: X86: Optimize zapping rmap
Message-ID: <YQHOdhMoFW821HAu@google.com>
References: <20210625153214.43106-1-peterx@redhat.com>
 <20210625153419.43671-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210625153419.43671-1-peterx@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 25, 2021, Peter Xu wrote:
> Using rmap_get_first() and rmap_remove() for zapping a huge rmap list could be
> slow.  The easy way is to travers the rmap list, collecting the a/d bits and
> free the slots along the way.
> 
> Provide a pte_list_destroy() and do exactly that.
> 
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 45 +++++++++++++++++++++++++++++++-----------
>  1 file changed, 33 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index ba0258bdebc4..45aac78dcabc 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1014,6 +1014,38 @@ unsigned int pte_list_count(struct kvm_rmap_head *rmap_head)
>  	return count;
>  }
>  
> +/* Return true if rmap existed and callback called, false otherwise */
> +static bool pte_list_destroy(struct kvm_rmap_head *rmap_head,
> +			     int (*callback)(u64 *sptep))
> +{
> +	struct pte_list_desc *desc, *next;
> +	int i;
> +
> +	if (!rmap_head->val)
> +		return false;
> +
> +	if (!(rmap_head->val & 1)) {
> +		if (callback)
> +			callback((u64 *)rmap_head->val);
> +		goto out;
> +	}
> +
> +	desc = (struct pte_list_desc *)(rmap_head->val & ~1ul);
> +
> +	while (desc) {
> +		if (callback)
> +			for (i = 0; i < desc->spte_count; i++)
> +				callback(desc->sptes[i]);
> +		next = desc->more;
> +		mmu_free_pte_list_desc(desc);
> +		desc = next;

Alternatively, 

	desc = (struct pte_list_desc *)(rmap_head->val & ~1ul);
	for ( ; desc; desc = next) {
		for (i = 0; i < desc->spte_count; i++)
			mmu_spte_clear_track_bits((u64 *)rmap_head->val);
		next = desc->more;
		mmu_free_pte_list_desc(desc);
	}

> +	}
> +out:
> +	/* rmap_head is meaningless now, remember to reset it */
> +	rmap_head->val = 0;
> +	return true;

Why implement this as a generic method with a callback?  gcc is suprisingly
astute in optimizing callback(), but I don't see the point of adding a complex
helper that has a single caller, and is extremely unlikely to gain new callers.
Or is there another "zap everything" case I'm missing?

E.g. why not this?

static bool kvm_zap_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
			  const struct kvm_memory_slot *slot)
{
	struct pte_list_desc *desc, *next;
	int i;

	if (!rmap_head->val)
		return false;

	if (!(rmap_head->val & 1)) {
		mmu_spte_clear_track_bits((u64 *)rmap_head->val);
		goto out;
	}

	desc = (struct pte_list_desc *)(rmap_head->val & ~1ul);
	for ( ; desc; desc = next) {
		for (i = 0; i < desc->spte_count; i++)
			mmu_spte_clear_track_bits(desc->sptes[i]);
		next = desc->more;
		mmu_free_pte_list_desc(desc);
	}
out:
	/* rmap_head is meaningless now, remember to reset it */
	rmap_head->val = 0;
	return true;
}

> +}
> +
>  static struct kvm_rmap_head *__gfn_to_rmap(gfn_t gfn, int level,
>  					   struct kvm_memory_slot *slot)
>  {
> @@ -1403,18 +1435,7 @@ static bool rmap_write_protect(struct kvm_vcpu *vcpu, u64 gfn)
>  static bool kvm_zap_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
>  			  struct kvm_memory_slot *slot)
>  {
> -	u64 *sptep;
> -	struct rmap_iterator iter;
> -	bool flush = false;
> -
> -	while ((sptep = rmap_get_first(rmap_head, &iter))) {
> -		rmap_printk("spte %p %llx.\n", sptep, *sptep);
> -
> -		pte_list_remove(rmap_head, sptep);
> -		flush = true;
> -	}
> -
> -	return flush;
> +	return pte_list_destroy(rmap_head, mmu_spte_clear_track_bits);
>  }
>  
>  static bool kvm_unmap_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
> -- 
> 2.31.1
> 
