Return-Path: <kvm+bounces-44007-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9357EA99808
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 20:37:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C7F464A35D8
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 18:37:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2192E28F53D;
	Wed, 23 Apr 2025 18:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C9pzWgkH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C986728F518
	for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 18:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745433457; cv=none; b=rHWQYqVfJ5dLNCQnA+YUDv6bin6gXLP6Rg4MmVS1L2pKNqb3YCGnvM88S0eiN78Bc6QeyFn6SPkz18DBmv+YcK9VDI1dShLbf2UBvcjhKb9wN2aGlQHdZ3p+MCGxdXrINcn9r4D1vVJ4gV8Y6WB5FvclQEf4a7sGKGLhu8siNuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745433457; c=relaxed/simple;
	bh=gh76Cwi537UAiZiZzvQ7qO7K4eMJvXZ5GcYqQsv4qVM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GylJ05ouT8j5GHeP9GZyOXaghmqsHuSvbw6VIxuX7gvYwpdBCi6YebMZR/AAHRJ8iUBNFAttNcc42tl9CDJW7jojuFRb0PaVE8MNoQhFudIrOAxJUw/r8Z/Vwkethp1EXb4MOGaWZW2kpAAvdSmRSxcC6BRz4/QLA3SwUGWTxY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C9pzWgkH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745433455;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y6pwEnRnhkHgazDgVxPbcQpa5mERaCMyYK1dziw6UIo=;
	b=C9pzWgkH+BVXgbOVKjt7gluBlb6WXN7LQcHEINHIuzgfh9WZRdNRHVJBZoYKkX5BXYQ8Hl
	jgEkLkpYovCvCb6wsdTJ90DTKxE7C6yV5/Z6zOY+ghQrCz//6YJOm2pcUyygtGQ0A0cr8X
	8D5PEGPXKt1I1PYi0Qb+q7AIzghR8jA=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-226-BwzRUoVHPnuaQ0qsQIduRA-1; Wed, 23 Apr 2025 14:37:28 -0400
X-MC-Unique: BwzRUoVHPnuaQ0qsQIduRA-1
X-Mimecast-MFC-AGG-ID: BwzRUoVHPnuaQ0qsQIduRA_1745433447
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-30bf67adf33so6649351fa.0
        for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 11:37:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745433447; x=1746038247;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y6pwEnRnhkHgazDgVxPbcQpa5mERaCMyYK1dziw6UIo=;
        b=kr9EJBAB03V7mH6+bkcPnpRI534VXxDROloTvKe9KiUCOhy4/wjbQQrcQLql3PrdTr
         OdY81uep5d2V9U/P9qYJ8c8dj3b61EKEj+KMQFeRes0PZPXjS5zfAlLtvMBG6XPWT6RF
         1aSYn5sUaCW6FNzGg0EnOT/tLJmVKVhe5i1bqu0UZKoAD20UimxjgV6Tu8KOnwkUI0qT
         oeelvn7ndvCSCTLp4XRVP7R0zU/v0U5O3nlHzHalOP6me4rE6SP/ISaIIlxS6HB+GG7V
         mYUEjL+yHcT5YNpnEQIGJqAJt1miAn1R+SOxlRuKU4s9KDib9OU/KJJbtWaWhPAMDLnM
         ZTWQ==
X-Forwarded-Encrypted: i=1; AJvYcCXZV1rblcdn2QECCxHvwqpMmX8ah+FdnkAbyIa0Vh9DJ0ZOFuQKTBhEI9K5rZHYBKm/xAs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yylpqvvc+hX5zppr8hgdAQKzrQzhA7vRDKvIk5mJHo07FG5+LZv
	4OCKkPkAXiY8gr2s/s0Rtg2yPiP9FScuz1LgMLFsWkFnhCF05Q4sf+FUQ7EqVoDPzSdcQJUttWd
	C3XJ4XmGsXqOnIZxFv8yKXCCUSFrRCiQN7VysVbcyOb1nmsJR
X-Gm-Gg: ASbGncu/359Ih9GLFN2R5uCFMdNVWbWiWhzSiKtD1p7kQGOiYBiNDGcrtqGE0R/xYm0
	9igSWeULnSkAyyRZh4xOZrdh7F7cZ/96WRLphkQivR7K31I/ysTRi2fWtCtjjUSSOjkj0OrSWnH
	SBqD8N0guvQhq9OJZEeu8pjt3VeSOC9v86KQrt5mdkeS9SJZwF7GSClkZfdETgpWpLp07tR377b
	l8Lz93BFTKSaH0qNhKVGGTsSbfMXvt9hStF58GLLpZwAPOdwz1wwQdaBYg1xWiJymvfs5z6U1bG
	MWfnccWiXK+Lwy4A5TgQpmAG8ktjIYNx2lIuyQ==
X-Received: by 2002:a2e:8818:0:b0:308:e956:66e with SMTP id 38308e7fff4ca-3179449456amr500191fa.0.1745433446938;
        Wed, 23 Apr 2025 11:37:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHeLX03zhP8nSlFHqNWBiKFBjf3MShxZQb8tc2EeW+8vLK6+b+87nnEoR+0vFre3XFcDl9w4g==
X-Received: by 2002:a2e:8818:0:b0:308:e956:66e with SMTP id 38308e7fff4ca-3179449456amr499761fa.0.1745433446435;
        Wed, 23 Apr 2025 11:37:26 -0700 (PDT)
Received: from [192.168.1.86] (85-23-48-6.bb.dnainternet.fi. [85.23.48.6])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3109075e8e9sm19833701fa.12.2025.04.23.11.37.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Apr 2025 11:37:26 -0700 (PDT)
Message-ID: <36891b0e-d5fa-4cf8-a181-599a20af1da3@redhat.com>
Date: Wed, 23 Apr 2025 21:37:24 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 10/24] mm/hmm: let users to tag specific PFN with DMA
 mapped bit
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>,
 Marek Szyprowski <m.szyprowski@samsung.com>, Jens Axboe <axboe@kernel.dk>,
 Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>,
 Leon Romanovsky <leonro@nvidia.com>, Jake Edge <jake@lwn.net>,
 Jonathan Corbet <corbet@lwn.net>, Zhu Yanjun <zyjzyj2000@gmail.com>,
 Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
 Bjorn Helgaas <bhelgaas@google.com>, Logan Gunthorpe <logang@deltatee.com>,
 Yishai Hadas <yishaih@nvidia.com>,
 Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
 Kevin Tian <kevin.tian@intel.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 linux-rdma@vger.kernel.org, iommu@lists.linux.dev,
 linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org,
 kvm@vger.kernel.org, linux-mm@kvack.org,
 Niklas Schnelle <schnelle@linux.ibm.com>,
 Chuck Lever <chuck.lever@oracle.com>, Luis Chamberlain <mcgrof@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Dan Williams
 <dan.j.williams@intel.com>, Kanchan Joshi <joshi.k@samsung.com>,
 Chaitanya Kulkarni <kch@nvidia.com>
References: <cover.1745394536.git.leon@kernel.org>
 <0a7c1e06269eee12ff8912fe0da4b7692081fcde.1745394536.git.leon@kernel.org>
 <7185c055-fc9e-4510-a9bf-6245673f2f92@redhat.com>
 <20250423181706.GT1213339@ziepe.ca>
Content-Language: en-US
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <20250423181706.GT1213339@ziepe.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 4/23/25 21:17, Jason Gunthorpe wrote:
> On Wed, Apr 23, 2025 at 08:54:05PM +0300, Mika Penttilä wrote:
>>> @@ -36,6 +38,13 @@ enum hmm_pfn_flags {
>>>  	HMM_PFN_VALID = 1UL << (BITS_PER_LONG - 1),
>>>  	HMM_PFN_WRITE = 1UL << (BITS_PER_LONG - 2),
>>>  	HMM_PFN_ERROR = 1UL << (BITS_PER_LONG - 3),
>>> +
>>> +	/*
>>> +	 * Sticky flags, carried from input to output,
>>> +	 * don't forget to update HMM_PFN_INOUT_FLAGS
>>> +	 */
>>> +	HMM_PFN_DMA_MAPPED = 1UL << (BITS_PER_LONG - 7),
>>> +
>> How is this playing together with the mapped order usage?
> Order shift starts at bit 8, DMA_MAPPED is at bit 7

hmm bits are the high bits, and order is 5 bits starting from
(BITS_PER_LONG - 8)


> The pfn array is linear and simply indexed. The order is intended for
> page table like HW to be able to build larger entries from the hmm
> data without having to scan for contiguity.
>
> Even if order is present the entry is still replicated across all the
> pfns that are inside the order.
>
> At least this series should replicate the dma_mapped flag as well as
> it doesn't pay attention to order.
>
> I suspect a page table implementation may need to make some small
> changes. Indeed with guarenteed contiguous IOVA there may be a
> significant optimization available to have the HW page table cover all
> the contiguous present pages in the iommu, which would be a higher
> order than the pages themselves. However this would require being able
> to punch non-present holes into contiguous mappings...
>
> Jason
>
--Mika



