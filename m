Return-Path: <kvm+bounces-10619-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CCE7A86DFA2
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 11:53:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F02941C2223D
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 10:53:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCA8F6BFC8;
	Fri,  1 Mar 2024 10:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ijtWP9sz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DFC56BB23
	for <kvm@vger.kernel.org>; Fri,  1 Mar 2024 10:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709290389; cv=none; b=D7rInKx9saTv8Q3OBD0U1eckzPdZtdkXQ6Ix1MIt35mU/seoWHwv39L3Q2gU4rg+7kOjh4G2PQSXNCdPWr+t4q73a0EZ+vL/9YBJ5B3x2uVM7uaAoHWLRc3+LMlg4GjJQhxyTJnP58oesSrHnXcQRWAYscZmWUucqkCdidcKtk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709290389; c=relaxed/simple;
	bh=ulCG6y3yhF79+Xq3bHfN/KGrRQdGsfrD6NUWWkpaDV0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lyOPPae182vRm3VQl04gcz7lu46/dEFLWeZnf+HmQII+vhOuteWpgSYIKKz2AnDe0eFQXnVCN7fw6UjIThgAQUeTmhJ0gaWAB7O4UuUrIBf4BdKbuYZa/FG6mzjLcihZ0YSuer0kCsA+a2w+Zz6mLDBGHHSSn0ZIdguEbqtnmoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ijtWP9sz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709290386;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=icNIdbNJLiHX8HLS/FchfvYxMBBdlKXDJTfhCxm4QoY=;
	b=ijtWP9sz+xkS+H+yidxSsRm63MCOSlMr+tuelLyRKGCvyC/RcIC2MaG+VZ1gweBRo9ZNlR
	aFm+vrXWKINM2e4aKuS2HZCl1kDkqDVab8xWJROyXMvs0Nu7aanJMITQhxgcwyDBNeEHJu
	pvbCRd/N5LG7ezyJhiXV3LS18I8XKS4=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-189-Z68r3K7VOGavM_MpN_RSzg-1; Fri, 01 Mar 2024 05:53:04 -0500
X-MC-Unique: Z68r3K7VOGavM_MpN_RSzg-1
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2d2b9aa4e35so11430211fa.3
        for <kvm@vger.kernel.org>; Fri, 01 Mar 2024 02:53:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709290383; x=1709895183;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=icNIdbNJLiHX8HLS/FchfvYxMBBdlKXDJTfhCxm4QoY=;
        b=J0FJEvHwbU7GN3dhq6UEd87X8Q0WorRsUAeu6w/lVWa0KlSDYeKp12O1y/0iUe1mY8
         EPBZL1j1sSVpQxzW9AsBt2n2x0y4kIp1ifanjKeCQw6pv8ZB5dLxUmAuf/qKfvsz4swu
         blOqgV/99okrKd9sokonBxgyi4enQHlDdKS/sBNjxH0VjwjgLjgvySe417s8R5YDxcGt
         YuXCwiKHJgo2/yilPmduCybWBLV9IbhS9MQ0OgiY3BH4GVPcGXSVIHb2fMAwNsCyEx8Y
         xs/rqZ02vxqiPdXxwzOQDHHjUE7Nlza54g2OZyj2JyUZPvIc9kLq7ujuK1ssBNW8B9fL
         6TIA==
X-Gm-Message-State: AOJu0YxyrDec16yI6+qLCGwjGXx1Bwqv9WvYAlToLQC5mC4+ODzveoap
	ImvktFAtOYVHUGpAjih3PzqDZNOqmWQ/Aat5A19YlAokBcfM5KGHJ9I4UYR69JIgfrsjLEcGOiI
	4CP9ngbKkkqaT8uZqJPR47YqXBTOkRNNlYbJBMbhIkGN1x6pw3g==
X-Received: by 2002:a05:6512:220c:b0:512:fc30:3ee4 with SMTP id h12-20020a056512220c00b00512fc303ee4mr1175711lfu.53.1709290383363;
        Fri, 01 Mar 2024 02:53:03 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHNpDwtSFklfuMEegHArxGPyTbqXrGAwFiEg9hbahTvFZRLRZ9NzWJ7cgl9SN8sgn9iO4Mbzw==
X-Received: by 2002:a05:6512:220c:b0:512:fc30:3ee4 with SMTP id h12-20020a056512220c00b00512fc303ee4mr1175693lfu.53.1709290382894;
        Fri, 01 Mar 2024 02:53:02 -0800 (PST)
Received: from ?IPV6:2003:cb:c713:3200:77d:8652:169f:b5f7? (p200300cbc7133200077d8652169fb5f7.dip0.t-ipconnect.de. [2003:cb:c713:3200:77d:8652:169f:b5f7])
        by smtp.gmail.com with ESMTPSA id q9-20020adf9dc9000000b0033e192a5852sm2146471wre.30.2024.03.01.02.53.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Mar 2024 02:53:02 -0800 (PST)
Message-ID: <33fb4546-df4e-4319-b498-69ddb5e2831f@redhat.com>
Date: Fri, 1 Mar 2024 11:53:01 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Revert "vfio/type1: Unpin zero pages"
Content-Language: en-US
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240229223544.257207-1-alex.williamson@redhat.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20240229223544.257207-1-alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 29.02.24 23:35, Alex Williamson wrote:
> This reverts commit 873aefb376bbc0ed1dd2381ea1d6ec88106fdbd4.
> 
> This was a heinous workaround and it turns out it's been fixed in mm
> twice since it was introduced.  Most recently, commit c8070b787519
> ("mm: Don't pin ZERO_PAGE in pin_user_pages()") would have prevented
> running up the zeropage refcount, but even before that commit
> 84209e87c696 ("mm/gup: reliable R/O long-term pinning in COW mappings")
> avoids the vfio use case from pinning the zeropage at all, instead
> replacing it with exclusive anonymous pages.
> 
> Remove this now useless overhead.
> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>   drivers/vfio/vfio_iommu_type1.c | 12 ------------
>   1 file changed, 12 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index b2854d7939ce..b5c15fe8f9fc 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -567,18 +567,6 @@ static int vaddr_get_pfns(struct mm_struct *mm, unsigned long vaddr,
>   	ret = pin_user_pages_remote(mm, vaddr, npages, flags | FOLL_LONGTERM,
>   				    pages, NULL);
>   	if (ret > 0) {
> -		int i;
> -
> -		/*
> -		 * The zero page is always resident, we don't need to pin it
> -		 * and it falls into our invalid/reserved test so we don't
> -		 * unpin in put_pfn().  Unpin all zero pages in the batch here.
> -		 */
> -		for (i = 0 ; i < ret; i++) {
> -			if (unlikely(is_zero_pfn(page_to_pfn(pages[i]))))
> -				unpin_user_page(pages[i]);
> -		}
> -
>   		*pfn = page_to_pfn(pages[0]);
>   		goto done;
>   	}

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


