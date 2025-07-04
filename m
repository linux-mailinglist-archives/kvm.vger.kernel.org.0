Return-Path: <kvm+bounces-51554-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 91943AF8AF9
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 10:17:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F32101C80B82
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 08:16:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AA5D32277F;
	Fri,  4 Jul 2025 07:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AUYGBVSS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C160321E63
	for <kvm@vger.kernel.org>; Fri,  4 Jul 2025 07:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751615792; cv=none; b=GQqeDldQU22BMh5NG7Tvw34dTGCOxvlAVQMbVIBRNLYvNhshwErGUOVU4Y8uydu2098Wp+d4zbrajoY6sNLxvLyQwq4uDItfeJoFaZ8cGHNU0bTzqzlYyuahFjPgl+Mc3zRzJ6/js99GglcKCvnPRNbnFN9MyEEpY2ZJF7PLvfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751615792; c=relaxed/simple;
	bh=Cx8GCnQwlVs+0cZzdmyltfEszaQtvN1psdzaOH+jcGs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gymURv1fe/FiTCSjoYiRPX/GzfflMh10mSVvdpg7LSiPzeo4BGeFR3BYgYsGiaOUqindQb7TSpRx02U3LbzyhZ0St7Azd1Vi+pJZb6V6n5nXKouu1BtCG5fbRgIv0wNkpPPRDIZ692REUXrdsngZQkLt0sw3QcfOt3cEqad4zsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AUYGBVSS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751615788;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0uaRp4EpGhUSeziv02wWzTYB6IodAtLkWURM9ee31dI=;
	b=AUYGBVSSlziQ3qedj2OMu75BiUYtsJuSlBg8V+RbP90TUaFF37wP7S3avqDwr6P03805pS
	8NoDIGhDLpXKvlIFyC0MJQBhZPfOr3KQeXLZFdy1vis/hBkk5681wgyQIdFCAN1XrBJFIm
	DUcGEENJqKzbTKx+Q95U/4xzx80Xi94=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-600-4Vo-0_KaN26DDF86VKnE_w-1; Fri, 04 Jul 2025 03:56:26 -0400
X-MC-Unique: 4Vo-0_KaN26DDF86VKnE_w-1
X-Mimecast-MFC-AGG-ID: 4Vo-0_KaN26DDF86VKnE_w_1751615785
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45359bfe631so3144415e9.0
        for <kvm@vger.kernel.org>; Fri, 04 Jul 2025 00:56:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751615785; x=1752220585;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=0uaRp4EpGhUSeziv02wWzTYB6IodAtLkWURM9ee31dI=;
        b=ui1Gt5Z/67WVlExO2JhqfHsspc79gT0dqvgF7vjdTf9phe7kZoCaOJt9TEcDoHYoCn
         SUnCi44vBsa2T28N7hQx0igalyB5BhC428y5xxlKX+BjOn8Mt0DY6kxREyJgqlIhj6/A
         RSU++b19cUXfEumyW66ax98CqVIB/PD8uauXi4MxAoAIOK1cWXXByuVcgwz9I002dTTX
         IwSCw/DfvjDvB/viKHmosho2VxI7uoKjbFCrno/UdYD3Unoe3fGev8DiQHjmNJUOkYTq
         i1VV6b8Kjc9N0Zi5MYs/P1SBxmmWrb6atYIQyr78Mn/9s4T0OPBJhpw1T39Z9owu64tG
         mctA==
X-Gm-Message-State: AOJu0Yz9XTZGvhIbp8K88iKScRJamJkaAyM85UOBgnZZDMOVBjvIVLTm
	VN+dQHdlOTdjxW8QUpP2KH2luU+JU8koGovlY3TLktPALsAvpJHNXQaL8nHRRy9GmzLaQaL1s1Q
	QR9JsjiAHU2Xlwa09V+g0xuK5gkthkYcfQAV6LaCq2RjjT/qEfPAO7w==
X-Gm-Gg: ASbGncv8JC/0feiiUdi4HHrRiPEzKiNgLy8FMhjPG+idmVowjCinzwvZ8OC64HW17Rz
	sNoDcXZlJUrcadgYriHp4GZPBKNCaN0XR2290JdoPl6QbxppY11C7hhoFjaCb/Aw4cJyuNQBikZ
	MmkR2TwNkV4HlRhTQrH3MGmAcKtZklfL3qbMKLT9ShYImjW7axnzb1u4OSCOqrVl2uKdxgDvPah
	PYA/SfQ340F2Wg84B7pnFvx6yWnkk6Vya67jnMclZ0VdOeX76DaXieM9fPYx/ctkKxsRk4duola
	UxOt+Nr1Z7O21v074ZWJkqbcA7y1jAXaXgO4Oa+trScwgb/SLiOXNupyoK+0rPIjw/9rVX142QA
	ShW17fZwWVIepw7EACFJdbqUtozZeMi5F8B1sUDQzbj25zS8=
X-Received: by 2002:a05:600c:3e1a:b0:454:aba2:c332 with SMTP id 5b1f17b1804b1-454b3187c22mr14015535e9.29.1751615785170;
        Fri, 04 Jul 2025 00:56:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE5QPrWj7L9jFsdKgPgTH8F2oFmdewm+dCoh4A6AxVtHkNOjPG73CwemCQhmtK/JCTNeSmafg==
X-Received: by 2002:a05:600c:3e1a:b0:454:aba2:c332 with SMTP id 5b1f17b1804b1-454b3187c22mr14015215e9.29.1751615784694;
        Fri, 04 Jul 2025 00:56:24 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f2c:5500:988:23f9:faa0:7232? (p200300d82f2c5500098823f9faa07232.dip0.t-ipconnect.de. [2003:d8:2f2c:5500:988:23f9:faa0:7232])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b47285c9f9sm1807879f8f.93.2025.07.04.00.56.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Jul 2025 00:56:24 -0700 (PDT)
Message-ID: <97d3993c-12aa-4917-9bbd-d9c94fbda788@redhat.com>
Date: Fri, 4 Jul 2025 09:56:23 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/5] mm: introduce num_pages_contiguous()
To: lizhe.67@bytedance.com, alex.williamson@redhat.com,
 akpm@linux-foundation.org, peterx@redhat.com, jgg@ziepe.ca
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20250704062602.33500-1-lizhe.67@bytedance.com>
 <20250704062602.33500-2-lizhe.67@bytedance.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250704062602.33500-2-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04.07.25 08:25, lizhe.67@bytedance.com wrote:
> From: Li Zhe <lizhe.67@bytedance.com>
> 
> Function num_pages_contiguous() determine the number of contiguous
> pages starting from the first page in the given array of page pointers.
> VFIO will utilize this interface to accelerate the VFIO DMA map process.
> 
> Suggested-by: David Hildenbrand <david@redhat.com>

I think Jason suggested having this as a helper as well.

> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> ---
>   include/linux/mm.h | 20 ++++++++++++++++++++
>   1 file changed, 20 insertions(+)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 0ef2ba0c667a..1d26203d1ced 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -205,6 +205,26 @@ extern unsigned long sysctl_admin_reserve_kbytes;
>   #define folio_page_idx(folio, p)	((p) - &(folio)->page)
>   #endif
>   
> +/*
> + * num_pages_contiguous() - determine the number of contiguous pages
> + * starting from the first page.


Maybe clarify here here:

"Pages are contiguous if they represent contiguous PFNs. Depending on 
the memory model, this can mean that the addresses of the "struct page"s 
are not contiguous."


> + *
> + * @pages: an array of page pointers
> + * @nr_pages: length of the array
> + */
> +static inline unsigned long num_pages_contiguous(struct page **pages,
> +						 unsigned long nr_pages)
> +{
> +	struct page *first_page = pages[0];
> +	unsigned long i;
> +
> +	for (i = 1; i < nr_pages; i++)
> +		if (pages[i] != nth_page(first_page, i))

if (pages[i] != nth_page(pages[0], i))

Should be clear as well, so no need for the temporary "first_page" variable.

Apart from that LGTM.

-- 
Cheers,

David / dhildenb


