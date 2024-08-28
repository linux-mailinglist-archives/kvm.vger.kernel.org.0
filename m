Return-Path: <kvm+bounces-25266-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CB28962C6C
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 17:32:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 05A12285876
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 15:32:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5F021A2572;
	Wed, 28 Aug 2024 15:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bZ1RG4pU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52C8719ADB6
	for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 15:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724859096; cv=none; b=o5sWNuAmtv/yfg9Mi8G5yhJQMQCJugQpCrtoc8a+KWg0hkeVykn7GCMFOV0vvI+t1iY2oHLHugRww0bzuVTFDf7fPqBM2DRGHdcImNTOTesVqbUQylL70jo7+MRJafP/jrjCA6vjbjh9alqvjYdIWjbd1+xLE7mt+amMFtWwlmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724859096; c=relaxed/simple;
	bh=HB83BpCSZwmFCFPQy1dp2nbaKNvjyY/GryE6N3K9Yn0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B7WiCeyBbkqHKda5/u8e9F7mkqJmG/7jZ/yqsz4+Nl/9riTsCfNAMOBpOj6SHH4nORkmC7FXk8Wl9q7TVGIrpLz9VZ12QRKAvLbq1PQ7r1R74gWBVM/pJvPq3ARWJFcdRwFkxJLz8vDtQfmNaWSOKeCZnI0Y7++KLomIxyCkZZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bZ1RG4pU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724859094;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=xOPKOsg5jv8jg6VD4xEjJRB23KAp6IEXnaWD2DP6S5o=;
	b=bZ1RG4pUum5frJHIO5eQ3TcQUreusdPuPhl/1meflPv7DZzXdEDGqpGKpmKWn0gc5y57dJ
	HNBhUWNcwI9ydJNdx1F8ibu5vLykUzhPvTWW2uqI96VV4lH98y08yKB2flrPw8YqBBGS9b
	5fcQrRNBiw/OAN8oKw3bGXz4e96Dl+E=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-226-_Lueu6u8Pu-_vX-yUwFu6g-1; Wed, 28 Aug 2024 11:31:32 -0400
X-MC-Unique: _Lueu6u8Pu-_vX-yUwFu6g-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-429e937ed39so63853195e9.1
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 08:31:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724859091; x=1725463891;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xOPKOsg5jv8jg6VD4xEjJRB23KAp6IEXnaWD2DP6S5o=;
        b=El2VRXYuwWpnkaI5LlVnRb7dcUAltPr8PyLenQdYit9zhPpLJlNHgO66pM4Ks8ZRMw
         zusFMu2Mo5J63vn8DW8r+yI3HrvRwZe0mBnl7zSSP0XFeddiXnxpHFLPA7mzP2eRGXVg
         6gwAldnV7L8W3akGu5jN1VW/QJJWN6YjoULdesgDPA+7Q0NkD5RDx+JbCI1ud7RrQUJt
         P3orBuDaAX1mj5RMCOtX8dKRgDhmw2dSPVjz/XP0jaQrwLRo1Ei0LYfrp0TjZ3/E53AA
         f5T0nqYgYRPByjTqjuslrDmNRUFasHSTlFmRd4eMr1Fl2hufxtlxsW91ivXPYGJ4+nDs
         gwqw==
X-Forwarded-Encrypted: i=1; AJvYcCVkK4RIGDovGgKmtJXc1u4VKjDtumZBDsTaqgmGdCGKm6fuKPXp4UgfZ2VKUtlAfS05jFM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyRi5Jqlu7Zp59nasoeFcyCyWouWN5qPBI29c5cJ+1m2HHzRX8o
	1jzibP6+htUv8PeKhHUoO3AyhU1pSl23u/T61ePRMLVqfP3XumZXVnepHttyVB9RVUVCvSNDfH4
	EhwzquNS/5QQ81zRDqMGe0b+Ck5Fs5CSvU0L5qLOmuMGutQhR7g==
X-Received: by 2002:a05:600c:3b97:b0:426:5c36:207c with SMTP id 5b1f17b1804b1-42bb27a9c77mr76465e9.25.1724859091173;
        Wed, 28 Aug 2024 08:31:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE6XqulJHuzc87ef1Sa38B+B4vXhV59jcrORNIKvdBRzM+hIg3NDU7pbYLM5WafNDZhZwqCXg==
X-Received: by 2002:a05:600c:3b97:b0:426:5c36:207c with SMTP id 5b1f17b1804b1-42bb27a9c77mr75985e9.25.1724859090191;
        Wed, 28 Aug 2024 08:31:30 -0700 (PDT)
Received: from ?IPV6:2003:cb:c706:1700:6b81:27cb:c9e2:a09a? (p200300cbc70617006b8127cbc9e2a09a.dip0.t-ipconnect.de. [2003:cb:c706:1700:6b81:27cb:c9e2:a09a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42bb01d3029sm772145e9.42.2024.08.28.08.31.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Aug 2024 08:31:29 -0700 (PDT)
Message-ID: <012789cd-90d0-4b3b-b48e-16990ee40fc4@redhat.com>
Date: Wed, 28 Aug 2024 17:31:28 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/19] mm: Mark special bits for huge pfn mappings when
 inject
To: Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: Gavin Shan <gshan@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>,
 x86@kernel.org, Ingo Molnar <mingo@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Thomas Gleixner <tglx@linutronix.de>, Alistair Popple <apopple@nvidia.com>,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Sean Christopherson <seanjc@google.com>, Oscar Salvador <osalvador@suse.de>,
 Jason Gunthorpe <jgg@nvidia.com>, Borislav Petkov <bp@alien8.de>,
 Zi Yan <ziy@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>,
 Yan Zhao <yan.y.zhao@intel.com>, Will Deacon <will@kernel.org>,
 Kefeng Wang <wangkefeng.wang@huawei.com>,
 Alex Williamson <alex.williamson@redhat.com>
References: <20240826204353.2228736-1-peterx@redhat.com>
 <20240826204353.2228736-4-peterx@redhat.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20240826204353.2228736-4-peterx@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 26.08.24 22:43, Peter Xu wrote:
> We need these special bits to be around on pfnmaps.  Mark properly for
> !devmap case, reflecting that there's no page struct backing the entry.
> 
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>   mm/huge_memory.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 3f74b09ada38..dec17d09390f 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1346,6 +1346,8 @@ static void insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
>   	entry = pmd_mkhuge(pfn_t_pmd(pfn, prot));
>   	if (pfn_t_devmap(pfn))
>   		entry = pmd_mkdevmap(entry);
> +	else
> +		entry = pmd_mkspecial(entry);
>   	if (write) {
>   		entry = pmd_mkyoung(pmd_mkdirty(entry));
>   		entry = maybe_pmd_mkwrite(entry, vma);
> @@ -1442,6 +1444,8 @@ static void insert_pfn_pud(struct vm_area_struct *vma, unsigned long addr,
>   	entry = pud_mkhuge(pfn_t_pud(pfn, prot));
>   	if (pfn_t_devmap(pfn))
>   		entry = pud_mkdevmap(entry);
> +	else
> +		entry = pud_mkspecial(entry);
>   	if (write) {
>   		entry = pud_mkyoung(pud_mkdirty(entry));
>   		entry = maybe_pud_mkwrite(entry, vma);

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


