Return-Path: <kvm+bounces-49692-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C608CADC710
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 11:51:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E5E9C189A733
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 09:51:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25C0B2DBF54;
	Tue, 17 Jun 2025 09:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J7hWUruJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C484C2135CE
	for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 09:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750153791; cv=none; b=WKKDeKY3jcfigubgiVSqTq8XxlOHP6KUIvD+Jac9nYigSgsoPGf06QkV1P2a4EyT20vBYKSFGUaPu8ZNnjZo8ffje7qEp9HJsucDQQmjg7ovJn8+5XwQZYcacP6+Tm9GHDST0kC2b4kQ6e70kKXIImZHFFMzuk2fzhmuGT7zUwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750153791; c=relaxed/simple;
	bh=dXw2koHc8UFjgXNHPwgDuWQ1C54kUQxtSSpnKFQknPI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pAzIyHUZOdssLE1FkU6cm+G5Kq5MMTIN9lKk9arN0Td6hSxXpLAVbRQlNZetNW+8yR/4PK+47aeVrRJcmwn3QHnaDdWXKCaIOiJSzKaYg+jETEqS/+9sPB0mCdhAZVGFppI0SuwA4Ji0QU09urwOCgPdOk4CakJXqVwgp5BjIXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J7hWUruJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750153789;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=DF2LSLjoIDZihiRcdf30WHksttB87jWZgxoeifw/8vs=;
	b=J7hWUruJ3xALoXI3D2P15r+qwicF39L4CxWE/cdQDWzKUqfsgaobblFCuw33JOUK/Tg9t7
	h/YjoNvylxIhi740t7SYT+ndiDl39Sgp7ssGgZO4Z9acsMf1JcroeC2jn2eZpUnmCgnGg5
	p+/ogbQkB3zrq179d7rSkQBVtpMf2PU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-311-UOUaCoNMO4aSUq8wUOKPVA-1; Tue, 17 Jun 2025 05:49:47 -0400
X-MC-Unique: UOUaCoNMO4aSUq8wUOKPVA-1
X-Mimecast-MFC-AGG-ID: UOUaCoNMO4aSUq8wUOKPVA_1750153786
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-43eea5a5d80so32308885e9.1
        for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 02:49:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750153786; x=1750758586;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DF2LSLjoIDZihiRcdf30WHksttB87jWZgxoeifw/8vs=;
        b=lvrYUPB8wXuK1YwVP945TS4LCadQdLva+sBQqlzNgW068VArQAzIvsbM7hbhrCTKVd
         AJmRLDnLmPytdhBryP3eRqgr/g+nChyNygLqSPyEENxrQ5aquNIgEwe3K0NSLjm/t4Y6
         oJFAbOqzmpsssO6luDRRgT6XI7Qzw2BBwDDmw3BeGFvoJ7C3AO9PTpoo0EsZMQmUwctG
         Hy11WxqEqZOaS8eoRkxUGoV2bTODJ6aLO4aEC2iQmfxGF34MsQd0PjOUz7wjqm+FOmLN
         JQkFX7LSC5tmm/VADdnbhNON7q/vyHlEwyOxZNKW7tikPRKinJTGkAgD5L1JleUXhblS
         M7sQ==
X-Forwarded-Encrypted: i=1; AJvYcCU2r5synPDDxUYK2/r9fkkMPd7hlm+f+VJTqw3nO0sD4W/FX4wVmgTUaYdcNFEUFy/zmT8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2yvpSAz3tQoHhJOWSqWdJdrVLjAw48yNsy4YElvc9i84NZQmp
	LnP7PArc3MkxoFOJQl6dULZCLDLcNN0PjeIqk/7AbFyqd58U3IY9eoE8z6sxmKzHshCLfOJS1b6
	2khFwAYMawQSGNcUTqrKep2CL/nBBepsLou7WgtriW+JC5zsj7BvY8Q==
X-Gm-Gg: ASbGncvLvlGl5NTRh7JbaN2Tn5GM0aEeBZ9lYvsLMwI6DYJ3pBdvM4t5/Sv/AO9A7ts
	/0vTyttUev8v2Fl/odksNKT+3LSsTAokoB649bqsduS3769hLyCs5R+bf2CIXEyrvcKhIMSCwX+
	y+x87YsmPxKhpC3lAw4Yb9bt1kwZGYnPPG6dUsVzhuRWWhIwM5iLgWDQJfc2r1PHrO2V3u+Psvw
	qfQyB96JHTDBQuLmvh/5UfGavh25xImu6oOIe5hjEjAZMIuLZl5+oKc0jzuCKbBHK7VQVY1Ttyh
	AtEnA91ALCUhYaM0J2Z7mpUE2BLFy4cjMIraJodTsQ9RfQOYQUWaX1iC0E/Pf8gOusHS/JgexGh
	P9Y+8TB4iNV5Q1b/drw66Vz2zvOV2gn/dIrRE/z0+VrxdzjE=
X-Received: by 2002:a05:600c:1e1a:b0:43c:f513:958a with SMTP id 5b1f17b1804b1-453501b41d8mr46951415e9.13.1750153785833;
        Tue, 17 Jun 2025 02:49:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEvM94fKFQqOi6f/UiYAlYA5Dbtm0BuNIi449CTJMM+YlZg/bJp3A8qBZE/OedzVBw3uw9beA==
X-Received: by 2002:a05:600c:1e1a:b0:43c:f513:958a with SMTP id 5b1f17b1804b1-453501b41d8mr46951115e9.13.1750153785434;
        Tue, 17 Jun 2025 02:49:45 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f31:700:3851:c66a:b6b9:3490? (p200300d82f3107003851c66ab6b93490.dip0.t-ipconnect.de. [2003:d8:2f31:700:3851:c66a:b6b9:3490])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4532e256d95sm169069565e9.31.2025.06.17.02.49.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jun 2025 02:49:44 -0700 (PDT)
Message-ID: <b88d58d2-59f8-4007-a6c5-d32ba4972bea@redhat.com>
Date: Tue, 17 Jun 2025 11:49:43 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/3] vfio/type1: optimize vfio_unpin_pages_remote() for
 large folio
To: lizhe.67@bytedance.com
Cc: akpm@linux-foundation.org, alex.williamson@redhat.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 peterx@redhat.com
References: <e0c741a0-450a-4512-8796-bd83a5618409@redhat.com>
 <20250617094713.12501-1-lizhe.67@bytedance.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250617094713.12501-1-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 17.06.25 11:47, lizhe.67@bytedance.com wrote:
> On Tue, 17 Jun 2025 09:43:56 +0200, david@redhat.com wrote:
>   
>>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>>> index e952bf8bdfab..d7653f4c10d5 100644
>>> --- a/drivers/vfio/vfio_iommu_type1.c
>>> +++ b/drivers/vfio/vfio_iommu_type1.c
>>> @@ -801,16 +801,43 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
>>>           return pinned;
>>>    }
>>>    
>>> +/* Returned number includes the provided current page. */
>>> +static inline unsigned long folio_remaining_pages(struct folio *folio,
>>> +               struct page *page, unsigned long max_pages)
>>> +{
>>> +       if (!folio_test_large(folio))
>>> +               return 1;
>>> +       return min_t(unsigned long, max_pages,
>>> +                    folio_nr_pages(folio) - folio_page_idx(folio, page));
>>> +}
>>
>> Note that I think that should go somewhere into mm.h, and also get used
>> by GUP. So factoring it out from GUP and then using it here.
> 
> I think I need to separate this out into a distinct patch within the
> patchset. Is that correct?

Yes, that's what I would do.

-- 
Cheers,

David / dhildenb


