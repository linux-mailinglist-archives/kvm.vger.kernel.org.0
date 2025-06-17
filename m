Return-Path: <kvm+bounces-49682-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D3A93ADC373
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 09:35:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A688F17147A
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 07:35:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1038B28F514;
	Tue, 17 Jun 2025 07:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UBI8ijCY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1954D28ECCB
	for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 07:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750145708; cv=none; b=XJXCLxKTetN7kQQXq6HQBWkZgtsd+emZCeQgn73gvtwCWvsaNjbV0xzhvPRbjh8KQSdUpp6cBrHgpk9+SlmPdK+rWLMno2prVL/9dol7pyWDn8svL1yKzfeGAA6wGnLzxDWpjZGfqYgC2ZpBayHw/XlDOnANwOo0MG6iV4dNN4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750145708; c=relaxed/simple;
	bh=WTQn1jvIcuYuUMmkktU+F6VAMUzXWNxHnSm8UZakJ78=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Yiibv36Zur/n3wU2V3FchxM0hnT4R+io0RQ6QWwUyB9jBl1fjBEpQud8rZBVxvxAs4CDO1rKLFbHpa4vo4F6l1FPYZyBu3y7YLq4Aw3i1euJ2NQWOuntSw5A9XG9dSLYm74sSBxOQFP2178NSWZSuSUAm30wQ1pfZTTaoTCKNgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UBI8ijCY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750145705;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Qr7YDLYZeKL5nI6aE6TfY01hQ51/nxfWCDQx9DxnXBs=;
	b=UBI8ijCYZKZJGAIGhdlq1aiJEuYWnbOiskq9US/BjwY5k6L3/v2BJv6W8zvCwt50wOVaRQ
	Zy2S6zJvI8DhPP7D53xovho31CfNHFfE2+luo3dJAkokyZMdl01k1JVjXQGPvDzdFUcR1d
	zJUzrQUCF7ktrE5o2aEqNMY9qZ77pys=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-38-pla8H9n6Nf6UOZOZFrMNuQ-1; Tue, 17 Jun 2025 03:35:03 -0400
X-MC-Unique: pla8H9n6Nf6UOZOZFrMNuQ-1
X-Mimecast-MFC-AGG-ID: pla8H9n6Nf6UOZOZFrMNuQ_1750145702
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3a4e9252ba0so2679716f8f.0
        for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 00:35:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750145702; x=1750750502;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Qr7YDLYZeKL5nI6aE6TfY01hQ51/nxfWCDQx9DxnXBs=;
        b=ftHeoY8h4OdJJ/7fQjLGiwStUp4vxt512LGIH04HkrhhW9SC8jIUXuFWYrFhsGUzS5
         83vcrxHXn3aAgQPwPUQdKWPij1Zz5ugvRTtqGSfq2ieeI38GGIvVXM8wRIXD0KZ8At3C
         sllfo2mGzVoHgb2pTiF7urngYWvLdvP+u3YxERN2AF/+c+ZrXPmuFbdNd/oodXxkjNUG
         Bgdhzei7O38lAgyGeD19BzIAIqiLg7UDB9bE59oGp9KJu4Lwc6RGa4kRrcl1+gNlk+EK
         kPEfPzKgPHMYC/eRueP4HPbhdBCAMZX3qco+8XTTSnqD/8mdJXU9+ZN61iiaJfv86mG3
         vbrQ==
X-Gm-Message-State: AOJu0Yw/zcrTqj5ORpN9RxjE5u40ldSWL0vxJqW3yFc23sFxDMZTHa2D
	B7I4lkjBoa2ikewSHK/TTEb4DqZq/s8O2lGPBqmy6YZLFrhWiyDfbN3yK2CYt7nXVH1BP60R+eH
	BA7qAjpT3iagfmVhXSZv6fWnRKfGi2weConiXoQ5PgB5Av/rmEmBUKg==
X-Gm-Gg: ASbGnctCa6dl3DYmxRQb0a+fpuMx11uu+d1s0vhgEsgRGva8MYeDudLREIyU3+cfjB5
	/YAtANAA2caJvhszscMzGuqDKWBnmLdWaRdor3+UOcx8GJKEfMu7ymMP1Dh8m0GExL2+Mj+hE0N
	jzmwTFqc91apmlECGhVGECxiFqHlWafYrGOtFl9237Uk5vhFuFT6ybHLFW3R4gscCYY7J5JbTNA
	iqDWGkTHbrTpSEiOjtYrZ/WrIvxZXHabX8JSzfxeqpLOZ9Fv97xhyQ018bpBfum5wr3hHZeJZLo
	drKqSBEFN1m/7OGtpPGFQ/GagOii4OcErwniroK5Agzscmej8/F4iduoO1t8p2ah9idu2lK6ppc
	HOeQtJx+AgTlrP/eODth1s+GFzorVu5ToflluHWk8O9UKrsA=
X-Received: by 2002:adf:b64d:0:b0:3a5:75a6:73b9 with SMTP id ffacd0b85a97d-3a575a6776bmr5519733f8f.11.1750145701974;
        Tue, 17 Jun 2025 00:35:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHj5SVN8X/GgRvKQRhQLvWOYL4dcmdIN/phPnUQUy6L/lFKmUG1JqHAavYuw0IUsXgdRRaM+w==
X-Received: by 2002:adf:b64d:0:b0:3a5:75a6:73b9 with SMTP id ffacd0b85a97d-3a575a6776bmr5519713f8f.11.1750145701594;
        Tue, 17 Jun 2025 00:35:01 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f31:700:3851:c66a:b6b9:3490? (p200300d82f3107003851c66ab6b93490.dip0.t-ipconnect.de. [2003:d8:2f31:700:3851:c66a:b6b9:3490])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4532e241b70sm164337975e9.18.2025.06.17.00.35.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jun 2025 00:35:01 -0700 (PDT)
Message-ID: <e09ed520-6b52-4b53-b6bb-dfee8f34be5b@redhat.com>
Date: Tue, 17 Jun 2025 09:35:00 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/3] gup: introduce unpin_user_folio_dirty_locked()
To: lizhe.67@bytedance.com, alex.williamson@redhat.com,
 akpm@linux-foundation.org, peterx@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20250617041821.85555-1-lizhe.67@bytedance.com>
 <20250617041821.85555-3-lizhe.67@bytedance.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250617041821.85555-3-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 17.06.25 06:18, lizhe.67@bytedance.com wrote:
> From: Li Zhe <lizhe.67@bytedance.com>
> 
> Introduce a new interface, unpin_user_folio_dirty_locked(). This
> interface is similar to unpin_user_folio(), but it adds the
> capability to conditionally mark a folio as dirty. VFIO will utilize
> this interface to accelerate the VFIO DMA unmap process.
> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> ---
>   include/linux/mm.h |  2 ++
>   mm/gup.c           | 27 +++++++++++++++++++++------
>   2 files changed, 23 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index fdda6b16263b..242b05671502 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1689,6 +1689,8 @@ void unpin_user_page_range_dirty_lock(struct page *page, unsigned long npages,
>   				      bool make_dirty);
>   void unpin_user_pages(struct page **pages, unsigned long npages);
>   void unpin_user_folio(struct folio *folio, unsigned long npages);
> +void unpin_user_folio_dirty_locked(struct folio *folio,
> +		unsigned long npins, bool make_dirty);
>   void unpin_folios(struct folio **folios, unsigned long nfolios);
>   
>   static inline bool is_cow_mapping(vm_flags_t flags)
> diff --git a/mm/gup.c b/mm/gup.c
> index 84461d384ae2..15debead5f5b 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -360,12 +360,7 @@ void unpin_user_page_range_dirty_lock(struct page *page, unsigned long npages,
>   
>   	for (i = 0; i < npages; i += nr) {
>   		folio = gup_folio_range_next(page, npages, i, &nr);
> -		if (make_dirty && !folio_test_dirty(folio)) {
> -			folio_lock(folio);
> -			folio_mark_dirty(folio);
> -			folio_unlock(folio);
> -		}
> -		gup_put_folio(folio, nr, FOLL_PIN);
> +		unpin_user_folio_dirty_locked(folio, nr, make_dirty);
>   	}
>   }
>   EXPORT_SYMBOL(unpin_user_page_range_dirty_lock);
> @@ -435,6 +430,26 @@ void unpin_user_folio(struct folio *folio, unsigned long npages)
>   }
>   EXPORT_SYMBOL(unpin_user_folio);
>   
> +/**
> + * unpin_user_folio_dirty_locked() - conditionally mark a folio
> + * dirty and unpin it
> + *
> + * @folio:  pointer to folio to be released
> + * @npins:  number of pins
> + * @make_dirty: whether to mark the folio dirty
> + *
> + * Mark the folio as being modified if @make_dirty is true. Then
> + * release npins of the folio.
> + */
> +void unpin_user_folio_dirty_locked(struct folio *folio,
> +		unsigned long npins, bool make_dirty)
> +{
> +	if (make_dirty && !folio_test_dirty(folio))
> +		folio_mark_dirty_lock(folio);
> +	gup_put_folio(folio, npins, FOLL_PIN);
> +}
> +EXPORT_SYMBOL_GPL(unpin_user_folio_dirty_locked);
> +
>   /**
>    * unpin_folios() - release an array of gup-pinned folios.
>    * @folios:  array of folios to be marked dirty and released.

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


