Return-Path: <kvm+bounces-11017-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E8ADA8723BE
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 17:09:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A39B42887F8
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 16:09:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58D7E128835;
	Tue,  5 Mar 2024 16:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="hmazYmkH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A5B128374
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 16:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709654930; cv=none; b=UHlw60Rx3j9GMthgdZOqMFG/JbvGxRpK96BY0kLlaVxNyEW3eOFCvDIDRRywjnfs1LHLAV6yPxyVy+2sXe0s2gDOERn/uSJl3KzzIXSAHlqW6QqVlmmq/YKjqMcMkZfCZs3TUjEYDTJL8cVLzurSOKiwASePe2Zt6yaFx9/2ymE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709654930; c=relaxed/simple;
	bh=mIBe9C22FxWEWX02cGhRxqJ/jUNOmxYaoZIj+zD5bao=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i01C24A3+FgGu3Reox25kfJB+xiwouSfvrPmHmiLCihhKeYXcv42OQM2VqMaSOKFhmO6GWwLuclyV9syn+eFr2XBrQ0A3HqDXtxTfHIDMoDtctmxBPyC7nQFR7z9CDM1qZn3et0My7jfI52KkfHm4uVYz3CF0Odb65JB9QukpQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=hmazYmkH; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1db9cb6dcb5so17964755ad.1
        for <kvm@vger.kernel.org>; Tue, 05 Mar 2024 08:08:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1709654927; x=1710259727; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ySXwHaWnwWfuqJedGiV+eti2ui1J2NF0RPAqqwKPf6w=;
        b=hmazYmkH3PU97SiAUWQgGfr/d2lXJ0nay8shW5ZTghl0bVuqeGdhxSLhftkcCNMpGX
         2yLfxdQ7BIisIbtHJUCeWByMYRSZE1NPbd9JCvXlgKTEeyrkHnY6go8F5W+3hYlnNrL3
         KXI0uFQjdLf/bZiPZG5jwonjigRJNxDUy2FLUuH2Cb8+hf9L/EtHL8r8pKebaebvL/Ho
         S/PNIsvkB5y4GTT3Y9/PNARoambMRA53gyzpDku/oqtnsb2zQ29RsZS/pCbES7hzNJ8K
         bqMrfm7B1UQCfdkgofIfGr5iA/jCaTDjgT9AHV+vSPvLH3rYIlCoXDVnmpQkkkYTm8UK
         5doA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709654927; x=1710259727;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ySXwHaWnwWfuqJedGiV+eti2ui1J2NF0RPAqqwKPf6w=;
        b=TqdAgAiY7i0cHa7xn+pHgxAs7TfeghAQtReXEbbMatSocPgvqCEJnRBzDZWWCpTal1
         mc31ncHNyrDp3FoXEvNViYSU9EM0g1bwVwvinf/kNHiQJCmfbHJlEETFyA9spFH2hxJv
         TIIgIAK+W/UXqJWZY1tD9qBv9D99B8EHSl9fu3fU0VJLE3A3642/YiQ3U1i+vj1Z7y9U
         URSfAjUCw5Rb/1aMpr3UcPbeKvPTQnVgaItn0Fe5ENDsbdlgpTRl8IoYSy850uOU9lMM
         8RcJe4T4QS3aEysksD/SOkVRMcP5C1LRz6cXiEfOVtHhzQHxvdqgO0GMbsYEbhVBCwZI
         xd1A==
X-Forwarded-Encrypted: i=1; AJvYcCXy6F1V4vNF7zfN2MEwVguYdz1enelfkM1vuIsgzjsRG+w/zME4upKPeSgHEhEO1ZFy9UAeuIxA2ZItHprZEY+7vWNr
X-Gm-Message-State: AOJu0YxU4Dyyf+JaRYrk+GKWc+enUbc3CP+lSpWAN91ItHeL40g4lPHR
	Eb9bcBw4ow6uMwBTZed2JnNL3VDm3XoXWjUuqg8pgzsH8P8lUMApGTKiYBQbFkI=
X-Google-Smtp-Source: AGHT+IEQyMNsi91T5s32CUzK+ybKvXY5CY8IcxZgQ/czWV6ISp8aawkZe242UlnjfOr6MXQ5ygWb4g==
X-Received: by 2002:a17:902:b08b:b0:1dc:82bc:c072 with SMTP id p11-20020a170902b08b00b001dc82bcc072mr977677plr.1.1709654927270;
        Tue, 05 Mar 2024 08:08:47 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id b4-20020a170902d50400b001dcf93e90a0sm6901815plg.20.2024.03.05.08.08.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Mar 2024 08:08:46 -0800 (PST)
Message-ID: <06787e6a-4e78-4524-960d-ec24b9f38191@kernel.dk>
Date: Tue, 5 Mar 2024 09:08:43 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC RESEND 16/16] nvme-pci: use blk_rq_dma_map() for NVMe SGL
Content-Language: en-US
To: Keith Busch <kbusch@kernel.org>, Leon Romanovsky <leon@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Robin Murphy <robin.murphy@arm.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 Chaitanya Kulkarni <chaitanyak@nvidia.com>,
 Chaitanya Kulkarni <kch@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
 Sagi Grimberg <sagi@grimberg.me>, Yishai Hadas <yishaih@nvidia.com>,
 Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
 Kevin Tian <kevin.tian@intel.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 linux-rdma@vger.kernel.org, iommu@lists.linux.dev,
 linux-nvme@lists.infradead.org, kvm@vger.kernel.org, linux-mm@kvack.org,
 Bart Van Assche <bvanassche@acm.org>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 Amir Goldstein <amir73il@gmail.com>,
 "josef@toxicpanda.com" <josef@toxicpanda.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "daniel@iogearbox.net" <daniel@iogearbox.net>,
 Dan Williams <dan.j.williams@intel.com>, "jack@suse.com" <jack@suse.com>,
 Leon Romanovsky <leonro@nvidia.com>, Zhu Yanjun <zyjzyj2000@gmail.com>
References: <cover.1709635535.git.leon@kernel.org>
 <016fc02cbfa9be3c156a6f74df38def1e09c08f1.1709635535.git.leon@kernel.org>
 <Zec_nAQn1Ft_ZTHH@kbusch-mbp.dhcp.thefacebook.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Zec_nAQn1Ft_ZTHH@kbusch-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/5/24 8:51 AM, Keith Busch wrote:
> On Tue, Mar 05, 2024 at 01:18:47PM +0200, Leon Romanovsky wrote:
>> @@ -236,7 +236,9 @@ struct nvme_iod {
>>  	unsigned int dma_len;	/* length of single DMA segment mapping */
>>  	dma_addr_t first_dma;
>>  	dma_addr_t meta_dma;
>> -	struct sg_table sgt;
>> +	struct dma_iova_attrs iova;
>> +	dma_addr_t dma_link_address[128];
>> +	u16 nr_dma_link_address;
>>  	union nvme_descriptor list[NVME_MAX_NR_ALLOCATIONS];
>>  };
> 
> That's quite a lot of space to add to the iod. We preallocate one for
> every request, and there could be millions of them. 

Yeah, that's just a complete non-starter. As far as I can tell, this
ends up adding 1052 bytes per request. Doing the quick math on my test
box (24 drives), that's just a smidge over 3GB of extra memory. That's
not going to work, not even close.

-- 
Jens Axboe


