Return-Path: <kvm+bounces-54648-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 361D0B25C5F
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 08:59:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 62E057BFDD8
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 06:55:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16E2326E70C;
	Thu, 14 Aug 2025 06:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GyLLNvce"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A39AA26D4F6
	for <kvm@vger.kernel.org>; Thu, 14 Aug 2025 06:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755154492; cv=none; b=bxjA/nefk4kl+C4E1peWSmQf97OfT3uAKtbVUE5gAJvfHCsbGk8fTLqG9dVHlBoOvXFdJ31MjFqGpNYNMyJ3DOVGJFPQQ7wqupQ9vFHcjkONa+Ly0YEaZYs14osCmWVX30gtc4Pd3bFHaYLPg3DmR3g3UaGeHN4/o8wPaaznzmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755154492; c=relaxed/simple;
	bh=MMMvlBpVsZ+Gvc+dvaS473KEUbczMuRgjjTNGbmGwiQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B1OBWmIHI0/LaDF/4rvMZQK0C6pKwlAVLXzbg/DiP+10Al0zA4Sr52LSCd9yeRunMX+fZTUg31b2Nk9iekVV27Sjoz+gvAKzU1PSmo9KBiSL8duxduXxnpcxIMTy6EVdPF9vxeDd1hy7SSkLdqMa+SdFdJoCkMKc9zxb1ewfIB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GyLLNvce; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755154489;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=fvpvxhWPdoJkSDZ8MlphGYTdGzSm3/ja2JHmLogOOeo=;
	b=GyLLNvceDwgjh6G2Pb6Fn4KGxjVKHEpHd8NbFjBYo/koePORyyQTpX6Q8YMSQs0DuVaqmh
	3l+rdkx2+SUM79v9R+KAA/e1oYKf7qYkOl2j2vQHHyAErCEI1sCVGpniRX9CweIoUjSpIA
	EcJws1xcdSYVenh2MAPM9ugtgzfzrfk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-117-WD7vHFzOPrWPwZgCD7k4aA-1; Thu, 14 Aug 2025 02:54:47 -0400
X-MC-Unique: WD7vHFzOPrWPwZgCD7k4aA-1
X-Mimecast-MFC-AGG-ID: WD7vHFzOPrWPwZgCD7k4aA_1755154487
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3b9e4146902so220038f8f.2
        for <kvm@vger.kernel.org>; Wed, 13 Aug 2025 23:54:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755154486; x=1755759286;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fvpvxhWPdoJkSDZ8MlphGYTdGzSm3/ja2JHmLogOOeo=;
        b=o6BqYDLBQiFKuMe6RJcFQic8+aLNqFsu3oBpWyqKrqFXLabaX6tn/KxJbHmr1ZxRCM
         r+seP+Mi6GOUYr41jXb1VRFdzKDTu1F2WI7bRBHD5CPUEtuBwMsSC4HAL6yDO6UszEK4
         w39nX1fSw5Mk5s9B3GqkjQxgZ1tBKRzQnnvi+4JkgYCYFXLjCTTHQO+lmuAuTeSEtHAX
         OoK3YSpWkSTiA3nb/wImZQJ/ipH1U5hOkRUcIhjm4m53mthObVJsNLy+akvEdH3ySLtK
         TI/7QyZ55EZ8u0G5HSXtdDbU2Ia7t3ZsS+IcTu9EwnU84CFZb1uJZovy3YqRMKOc/IZK
         Kuaw==
X-Forwarded-Encrypted: i=1; AJvYcCWhIPPsplDl9E9hE//3/CyEKwqqu/idxfBVPUvZKEoU5j1e/V9+fC0pFoyh5ZsqNXk/080=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7jypcFsO3kGr4vaVhDtxRDcIQAGtf0qQu5TmBCiHOZaxo4wS0
	sM4cpsPfRvhUROqkg9gXOWk2IWkmyBcB8RzddYi5gfItr9pSo0Tq6cVWR0LLtYL5JoCKv9ef/Z/
	1e2YUOUjZa71uhakJ8dGomvdLG128xNQqvq2Gczhvmj92l+VuHDhM7T3Wa9+5rA==
X-Gm-Gg: ASbGncsjCDrocheWl0GgPR/Tno1mADJF0YmYvJ++9NrZ0bEVePm2lRLBGP3NXlqBLJk
	vOcYxYMmcQBGxjhcmd5k7Jlbt0/j07lgaDyWxiavFymU5eaSgfwRrUW6HosLUMBbkHx9rlWe219
	ioyf50m16JFfbBbRUSIQqNwY7MM7FqYoV1dNWVum4U/gHn7Yerm/mXbm7cCCz5HV+I3Qp40QU2W
	hm6pya1fRoxhG71HWYifnSc7xDJwAjm4xkPZRZeOybFWh74cr/SvwsKykd6WRUwkgd9VQzACQl4
	iZHJn5ak/AdmRLPoCx4WNlPSW3QaoBJOdBqCSDvFd+q5LRNvDlvG+iub7NwnAe6tLROyM2oHV6y
	afD0L4m2qeg5GD3oDer1lSKDPfM0FRnDyN6ogF03TjA8UhznGnAjzD4XWfU8Ntrduc8E=
X-Received: by 2002:a05:6000:1a87:b0:3b7:9564:29be with SMTP id ffacd0b85a97d-3b9edfbcbc4mr1265108f8f.49.1755154486535;
        Wed, 13 Aug 2025 23:54:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEuwbSd1hfoguf19DDqWvE/vkGc7hbRPXw59LAVpN/NURRA3qyTI3CteiBCp7opzPeFpODmtg==
X-Received: by 2002:a05:6000:1a87:b0:3b7:9564:29be with SMTP id ffacd0b85a97d-3b9edfbcbc4mr1265091f8f.49.1755154486121;
        Wed, 13 Aug 2025 23:54:46 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f44:3e00:9fca:7d89:a265:56f3? (p200300d82f443e009fca7d89a26556f3.dip0.t-ipconnect.de. [2003:d8:2f44:3e00:9fca:7d89:a265:56f3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1d200fe6sm6366685e9.10.2025.08.13.23.54.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Aug 2025 23:54:45 -0700 (PDT)
Message-ID: <b426d3b9-c674-436e-95c3-fcc7647a044b@redhat.com>
Date: Thu, 14 Aug 2025 08:54:44 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/5] mm: introduce num_pages_contiguous()
To: lizhe.67@bytedance.com, alex.williamson@redhat.com, jgg@nvidia.com
Cc: torvalds@linux-foundation.org, kvm@vger.kernel.org, linux-mm@kvack.org,
 farman@linux.ibm.com, Jason Gunthorpe <jgg@ziepe.ca>
References: <20250814064714.56485-1-lizhe.67@bytedance.com>
 <20250814064714.56485-2-lizhe.67@bytedance.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250814064714.56485-2-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 14.08.25 08:47, lizhe.67@bytedance.com wrote:
> From: Li Zhe <lizhe.67@bytedance.com>
> 
> Let's add a simple helper for determining the number of contiguous pages
> that represent contiguous PFNs.
> 
> In an ideal world, this helper would be simpler or not even required.
> Unfortunately, on some configs we still have to maintain (SPARSEMEM
> without VMEMMAP), the memmap is allocated per memory section, and we might
> run into weird corner cases of false positives when blindly testing for
> contiguous pages only.
> 
> One example of such false positives would be a memory section-sized hole
> that does not have a memmap. The surrounding memory sections might get
> "struct pages" that are contiguous, but the PFNs are actually not.
> 
> This helper will, for example, be useful for determining contiguous PFNs
> in a GUP result, to batch further operations across returned "struct
> page"s. VFIO will utilize this interface to accelerate the VFIO DMA map
> process.
> 
> Implementation based on Linus' suggestions to avoid new usage of
> nth_page() where avoidable.
> 
> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> Co-developed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>   include/linux/mm.h        |  7 ++++++-
>   include/linux/mm_inline.h | 35 +++++++++++++++++++++++++++++++++++
>   2 files changed, 41 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 1ae97a0b8ec7..ead6724972cf 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1763,7 +1763,12 @@ static inline unsigned long page_to_section(const struct page *page)
>   {
>   	return (page->flags >> SECTIONS_PGSHIFT) & SECTIONS_MASK;
>   }
> -#endif
> +#else /* !SECTION_IN_PAGE_FLAGS */
> +static inline unsigned long page_to_section(const struct page *page)
> +{
> +	return 0;
> +}
> +#endif /* SECTION_IN_PAGE_FLAGS */
>   
>   /**
>    * folio_pfn - Return the Page Frame Number of a folio.
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index 89b518ff097e..5ea23891fe4c 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -616,4 +616,39 @@ static inline bool vma_has_recency(struct vm_area_struct *vma)
>   	return true;
>   }
>   
> +/**
> + * num_pages_contiguous() - determine the number of contiguous pages
> + *			    that represent contiguous PFNs
> + * @pages: an array of page pointers
> + * @nr_pages: length of the array, at least 1
> + *
> + * Determine the number of contiguous pages that represent contiguous PFNs
> + * in @pages, starting from the first page.
> + *
> + * In kernel configs where contiguous pages might not imply contiguous PFNs
> + * over memory section boundaries, this function will stop at the memory
 > + * section boundary.

Jason suggested here instead:

"
In some kernel configs contiguous PFNs will not have contiguous struct
pages. In these configurations num_pages_contiguous() will return a
smaller than ideal number. The caller should continue to check for pfn
contiguity after each call to num_pages_contiguous().
"

-- 
Cheers

David / dhildenb


