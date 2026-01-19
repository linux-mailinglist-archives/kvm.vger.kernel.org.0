Return-Path: <kvm+bounces-68506-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 80946D3A8F7
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 13:35:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DC01A30949D5
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 12:34:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D576D35A951;
	Mon, 19 Jan 2026 12:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aGRfcg9L"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ABAB314D26
	for <kvm@vger.kernel.org>; Mon, 19 Jan 2026 12:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768826053; cv=none; b=tMVNyDvYRRAhyr8nzO3GaQZlbvNqqPOfl1U3wh2LUBwycH5BPNsoyxTLBPWnca3PO3aDoa1aqWIr1eEHniO4Biy+rM+vMbR9LuQQvTMXSDQFJ9aXoQM5ecitTitBzwkNeBGbmhTh17y62Xf+8+9u7fVynVPcG4Xj/7FFEPjdckI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768826053; c=relaxed/simple;
	bh=pYAfipF2N3lSeZnWjsUTOBncQpMrZB1CykRBZPYQ5xI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZkwN9E+N1YUY8jkAAGUW8d3Z2hMDblLDGRzrOSRrk3EKR1jzwWFQ/1XD60N+y/xAYNOjEj8Itc+RCq4Y/kVhTWdNOfuN9jkRKJP5O44s03l7TaTuDTNo7FpCzeQqlR/VeFb5ypMswanJcFnqHHWiIBP79IVHz3vaSpjX9m9e/nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aGRfcg9L; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8DB3C19423;
	Mon, 19 Jan 2026 12:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768826052;
	bh=pYAfipF2N3lSeZnWjsUTOBncQpMrZB1CykRBZPYQ5xI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=aGRfcg9LIKTmNK6O6Tj/beTft+2gzpqEOFc7uboDAoG6SbYvr2jnscNOBmTO6OIgk
	 pZxoJy/nWZRtAqeYy3t/uvllodqBCkjlUWbh3mZEkkII6/NPkVDNLt3X1V/wp0ttb1
	 jiWaGpWdNssXQ9x5oLc5fF8dnCe3Ty+4cq8NXO1JKAd1/Jkcx97oBnUh3amUQ872i+
	 4TfpDA8HlOSQVVq4WTsAGqqRPObjI1x7V0X6Gqg/noy6MhwwYv1gfY9VDFsaRmk/ac
	 u6JHRhEOSdOUhNx4C+ZPtmFZ39dhaQlUB/Voilc2Le5ULRQatQp2XeTm22UBA2XNrG
	 xkuCfvPuQXP/Q==
Message-ID: <67b7e428-5ed3-4794-b8c4-dcebf724972d@kernel.org>
Date: Mon, 19 Jan 2026 13:34:07 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/2] KVM: pfncache: Use kvm_gmem_get_pfn() for
 guest_memfd-backed memslots
To: Takahiro Itazuri <itazur@amazon.com>, kvm@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Fuad Tabba <tabba@google.com>,
 Brendan Jackman <jackmanb@google.com>, David Woodhouse
 <dwmw2@infradead.org>, Paul Durrant <pdurrant@amazon.com>,
 Nikita Kalyazin <kalyazin@amazon.com>,
 Patrick Roy <patrick.roy@campus.lmu.de>,
 Takahiro Itazuri <zulinx86@gmail.com>
References: <20251203144159.6131-1-itazur@amazon.com>
 <20251203144159.6131-2-itazur@amazon.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20251203144159.6131-2-itazur@amazon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/3/25 15:41, Takahiro Itazuri wrote:
> gfn_to_pfn_cache currently relies on hva_to_pfn(), which resolves PFNs
> through GUP.  GUP assumes that the page has a valid direct-map PTE,
> which is not true for guest_memfd created with
> GUEST_MEMFD_FLAG_NO_DIRECT_MAP, because their direct-map PTEs are
> explicitly invalidated via set_direct_map_valid_noflush().
> 
> Introduce a helper function, gpc_to_pfn(), that routes PFN lookup to
> kvm_gmem_get_pfn() for guest_memfd-backed memslots (regardless of
> whether GUEST_MEMFD_FLAG_NO_DIRECT_MAP is set), and otherwise falls
> back to the existing hva_to_pfn() path. Rename hva_to_pfn_retry() to
> gpc_to_pfn_retry() accordingly.

Let's look into some details:

The pfncache looks up a page from the page tables through GUP.

To make sure that the looked up PFN can be safely used, it must we very 
careful: after it looked up the page through hva_to_pfn(), it marks the 
entry as "valid" and drops the folio reference obtained through 
hva_to_pfn().

At this point, nothing stops the page from getting unmapped from the 
page tables to be freed etc.

Of course, that sounds very dangerous.

That's why the pfncache uses the (KVM) mmu_notifier framework to get 
notified when the page was just unmapped from the KVM mmu while it 
prepared the cache entry (see mmu_notifier_retry_cache()).

But it also has to deal with the page getting removed (+possibly freed) 
from the KVM MMU later, after we already have a valid entry in the cache.

For this reason, gfn_to_pfn_cache_invalidate_start() is used to 
invalidate any entries as they get unmapped from page tables.

Now the big question: how is this supposed to work with gmem? I would 
have expected that we would need similar invalidations etc. from gmem code?

Imagine ftruncate() targets the gmem folio we just looked up, would be 
we get an appropriate invalidate notification?

> 
> Signed-off-by: Takahiro Itazuri <itazur@amazon.com>
> ---
>   virt/kvm/pfncache.c | 34 +++++++++++++++++++++++-----------
>   1 file changed, 23 insertions(+), 11 deletions(-)
> 
> diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
> index 728d2c1b488a..bf8d6090e283 100644
> --- a/virt/kvm/pfncache.c
> +++ b/virt/kvm/pfncache.c
> @@ -152,22 +152,34 @@ static inline bool mmu_notifier_retry_cache(struct kvm *kvm, unsigned long mmu_s
>   	return kvm->mmu_invalidate_seq != mmu_seq;
>   }
>   
> -static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
> +static kvm_pfn_t gpc_to_pfn(struct gfn_to_pfn_cache *gpc, struct page **page)
>   {
> -	/* Note, the new page offset may be different than the old! */
> -	void *old_khva = (void *)PAGE_ALIGN_DOWN((uintptr_t)gpc->khva);
> -	kvm_pfn_t new_pfn = KVM_PFN_ERR_FAULT;
> -	void *new_khva = NULL;
> -	unsigned long mmu_seq;
> -	struct page *page;
> +	if (kvm_slot_has_gmem(gpc->memslot)) {
> +		kvm_pfn_t pfn;
> +
> +		kvm_gmem_get_pfn(gpc->kvm, gpc->memslot, gpa_to_gfn(gpc->gpa),
> +				 &pfn, page, NULL);
> +		return pfn;
> +	}
>   
>   	struct kvm_follow_pfn kfp = {
>   		.slot = gpc->memslot,
>   		.gfn = gpa_to_gfn(gpc->gpa),
>   		.flags = FOLL_WRITE,
>   		.hva = gpc->uhva,
> -		.refcounted_page = &page,
> +		.refcounted_page = page,
>   	};
> +	return hva_to_pfn(&kfp);
> +}
> +
> +static kvm_pfn_t gpc_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
> +{
> +	/* Note, the new page offset may be different than the old! */
> +	void *old_khva = (void *)PAGE_ALIGN_DOWN((uintptr_t)gpc->khva);
> +	kvm_pfn_t new_pfn = KVM_PFN_ERR_FAULT;
> +	void *new_khva = NULL;
> +	unsigned long mmu_seq;
> +	struct page *page;
>   
>   	lockdep_assert_held(&gpc->refresh_lock);
>   
> @@ -206,7 +218,7 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
>   			cond_resched();
>   		}
>   
> -		new_pfn = hva_to_pfn(&kfp);
> +		new_pfn = gpc_to_pfn(gpc, &page);
>   		if (is_error_noslot_pfn(new_pfn))
>   			goto out_error;
>   
> @@ -319,7 +331,7 @@ static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned l
>   		}
>   	}
>   
> -	/* Note: the offset must be correct before calling hva_to_pfn_retry() */
> +	/* Note: the offset must be correct before calling gpc_to_pfn_retry() */
>   	gpc->uhva += page_offset;
>   
>   	/*
> @@ -327,7 +339,7 @@ static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned l
>   	 * drop the lock and do the HVA to PFN lookup again.
>   	 */
>   	if (!gpc->valid || hva_change) {
> -		ret = hva_to_pfn_retry(gpc);
> +		ret = gpc_to_pfn_retry(gpc);
>   	} else {
>   		/*
>   		 * If the HVA→PFN mapping was already valid, don't unmap it.


-- 
Cheers

David

