Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE3137AD6F
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 19:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbhEKR5V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 13:57:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231439AbhEKR5V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 May 2021 13:57:21 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFD8DC061574
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 10:56:14 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id md17so12093660pjb.0
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 10:56:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OE8q1BG05EipQ/1YaoTFUtsd5Q+5n/JYZoA2VhfSjZU=;
        b=JhS+rcoDkQIqCU/PlBh5dmly1teXaDDZ4NNTzngHUkSjOcqPmik2eavfBztQGJnkid
         ZAbGDaTNBSN6Z0MUh6JR41JQxlgcjP95pshxWy5nk0tqEeOoerqY6aMUO1cs9b7+WH4p
         w/ZQnVrUPbvyMGctuPzObY2GMvlMz8qV0pkSonqbBEl/sxYb+6QQ0kfjEoCEx5a+cg0R
         ZUjr/6aa0ENfZqLct5o1Ho8tlCg45fKr2wY9E6A4NgPgiiIqewt8NFEKkAdEA19hM8WC
         BoC9OVHlQyVccMpNu12is+nE768jLMvOD0X5k/kOANjJpFfVkSbO46fmq5y4B9JoLxBy
         4pzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OE8q1BG05EipQ/1YaoTFUtsd5Q+5n/JYZoA2VhfSjZU=;
        b=hOfYvTOrOxzVfkCROCcmWzEj3992n0jXpTzjfAA2/R/rWH5s9ktor+PTgzdQN51O2r
         bAZ7l+F7oqXsljkKHOXlPn6erqV7clW76VUoPTOmav6zci1V6hoOtX5D4FbCd8wi2uT/
         JEeCOCxXKZrh5hztjsa/nGwtIR6dAAvcPgbiCETsDryMBwsdR62qgGDR3y6EKkmIYjhd
         CitfpdLh9SZPq0HzUseIVAgeA96TLW2PyYFWeyB05UKM8XVoDk4h3NOpZId7WPsTePI2
         egKA2Xrk6CuerhIJCRVDpGrbjZxF1eHooYOKSnX7OeAT0mQBcZYFjHJCXY9apfHi4WYn
         7Rbw==
X-Gm-Message-State: AOAM532D5N9Jc2KxO4SHsYUARM6plsZWdZGBZ6baZR70gqHNkLzCjFaM
        cL3dapQZibz+v7vDDT8iUgni7Q==
X-Google-Smtp-Source: ABdhPJwKnqsuiVy53IbxV1xe7q0waugKjy+GJJddrAPrI/2uA8Um7W3MTpXxgXhaN+YY1xR3SPyT4w==
X-Received: by 2002:a17:902:70c2:b029:ee:b4e5:64d5 with SMTP id l2-20020a17090270c2b02900eeb4e564d5mr30266317plt.77.1620755774157;
        Tue, 11 May 2021 10:56:14 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id o12sm14138270pjr.43.2021.05.11.10.56.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 10:56:13 -0700 (PDT)
Date:   Tue, 11 May 2021 17:56:09 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH v4 2/7] KVM: x86/mmu: Factor out allocating memslot rmap
Message-ID: <YJrFOXW3mM3WjGT5@google.com>
References: <20210511171610.170160-1-bgardon@google.com>
 <20210511171610.170160-3-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210511171610.170160-3-bgardon@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 11, 2021, Ben Gardon wrote:
> Small refactor to facilitate allocating rmaps for all memslots at once.
> 
> No functional change expected.
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/x86/kvm/x86.c | 39 ++++++++++++++++++++++++++++++---------
>  1 file changed, 30 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 1e1f4f31e586..cc0440b5b35d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10911,10 +10911,35 @@ void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
>  	kvm_page_track_free_memslot(slot);
>  }
>  
> +static int memslot_rmap_alloc(struct kvm_memory_slot *slot,
> +			      unsigned long npages)
> +{
> +	int i;
> +
> +	for (i = 0; i < KVM_NR_PAGE_SIZES; ++i) {
> +		int lpages;
> +		int level = i + 1;
> +
> +		lpages = gfn_to_index(slot->base_gfn + npages - 1,
> +				      slot->base_gfn, level) + 1;

Might as well assign lpages at its declaration, i.e.

		int lpages = gfn_to_index(slot->base_gfn + npages - 1,
					  slot->base_gfn, level) + 1;
> +
> +		slot->arch.rmap[i] =
> +			kvcalloc(lpages, sizeof(*slot->arch.rmap[i]),
> +				 GFP_KERNEL_ACCOUNT);

Eh, I don't think avoiding a 3 char overrun is worth splitting across three lines.
E.g. this is perfectly readable

		slot->arch.rmap[i] = kvcalloc(lpages, sizeof(*slot->arch.rmap[i]),
					      GFP_KERNEL_ACCOUNT);

Alternatively, the rmap size could be captured in a local var, e.g.

	const int sz = sizeof(*slot->arch.rmap[0]);

	...

		slot->arch.rmap[i] = kvcalloc(lpages, sz, GFP_KERNEL_ACCOUNT);
		if (!slot->arch.rmap[i]) {
			memslot_rmap_free(slot);
			return -ENOMEM;
		}

> +		if (!slot->arch.rmap[i]) {
> +			memslot_rmap_free(slot);
> +			return -ENOMEM;

Reaaaally getting into nitpicks, what do you think about changing this to a goto
with the error handling at the bottom?  Obviously not necessary by any means,
but for me it makes it easier to see that all rmaps are freed on failure.  My
eyes skipped over that on the first read through.  E.g.

		if (!slot_arch.rmap[i])
			goto err;
	}

	return 0;

err:
	memslot_rmap_free(slot);
	return -ENOMEM;


> +		}
> +	}
> +
> +	return 0;
> +}
> +
>  static int kvm_alloc_memslot_metadata(struct kvm_memory_slot *slot,
>  				      unsigned long npages)
>  {
>  	int i;
> +	int r;

Personal preference, for short declarations like this I like putting 'em on a
single line.

>  	/*
>  	 * Clear out the previous array pointers for the KVM_MR_MOVE case.  The
> @@ -10923,7 +10948,11 @@ static int kvm_alloc_memslot_metadata(struct kvm_memory_slot *slot,
>  	 */
>  	memset(&slot->arch, 0, sizeof(slot->arch));
>  
> -	for (i = 0; i < KVM_NR_PAGE_SIZES; ++i) {
> +	r = memslot_rmap_alloc(slot, npages);
> +	if (r)
> +		return r;
> +
> +	for (i = 1; i < KVM_NR_PAGE_SIZES; ++i) {
>  		struct kvm_lpage_info *linfo;
>  		unsigned long ugfn;
>  		int lpages;
> @@ -10932,14 +10961,6 @@ static int kvm_alloc_memslot_metadata(struct kvm_memory_slot *slot,
>  		lpages = gfn_to_index(slot->base_gfn + npages - 1,
>  				      slot->base_gfn, level) + 1;
>  
> -		slot->arch.rmap[i] =
> -			kvcalloc(lpages, sizeof(*slot->arch.rmap[i]),
> -				 GFP_KERNEL_ACCOUNT);
> -		if (!slot->arch.rmap[i])
> -			goto out_free;
> -		if (i == 0)
> -			continue;
> -
>  		linfo = kvcalloc(lpages, sizeof(*linfo), GFP_KERNEL_ACCOUNT);
>  		if (!linfo)
>  			goto out_free;
> -- 
> 2.31.1.607.g51e8a6a459-goog
> 
