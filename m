Return-Path: <kvm+bounces-19300-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 08A85903448
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 09:49:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 897021F29251
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 07:49:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5562173328;
	Tue, 11 Jun 2024 07:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kqNWeP+2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B5C172BC1;
	Tue, 11 Jun 2024 07:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718092150; cv=none; b=ZTiLn66I+AUAb4OmWYB+Y1B6sxCkTfugnOpZfmzoaUrioyfA33IWSNtl4br9ksP1Kk7bAgNewxsy7Ag7QjV2hOET95iFbalCZlYAMOY+KsvnVyn2jj+zkcuOAxNxn+icDgi4L9ZQpks/G8fPiKlvddebkEsc9MWYMnz4+gsfnSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718092150; c=relaxed/simple;
	bh=hiTi2Z2kFvgoVOSPubuhZsugltW45Q0GMSzZrbstP/c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gmnSZtXIgyx9CLmVyACQWNB5zRBRkr8rbw2JbXpLMFGe6j2Ah1fqT7jnszwVzr0OtndwodQ9Ey5rnc47nvGxFPrhmFYYg/7drJwrcQLX1gfKViMD1Sc+/jS46u0SPkId2yOD9PB+ZpFJjODmRlvrXnR2/2GyZnJLjBeTuWhbaao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kqNWeP+2; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a68b41ef3f6so585001966b.1;
        Tue, 11 Jun 2024 00:49:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718092146; x=1718696946; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kecLidF3g75Y0M4dgmXIi2U7qv7nfX0gCWhXKA3lhlo=;
        b=kqNWeP+25IMcqBz/PPTvHXgNcexBiD0qWmKen69qLb0yyE0NErMIiuDNtPNGjHfo6s
         OVVjfE2NzYTWjqFtZUc0rja2vWHLSLKCNUBfHUPJG+ZoTDgc9cp0DTXb1qq7+CFsIWDH
         1EskANF9CgiWXHeQAZdT/+C4JKbfwYiPAsJiEK1AxRuzO6da3qEJS+pD6CJb+xIPy7CH
         jSzmwYRDyYGibhlMIUlgMqNOYV/nvX7PceMK8tI2dpDtxl3znFqt9LpoHU0RPfhjaUlL
         9r6kwFIhPNBfGWJEbv4wXkelI0cpN7hR7B+NW6IWYsccIPrkB246Ba8BP2LjFyd7wM0z
         5afg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718092146; x=1718696946;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kecLidF3g75Y0M4dgmXIi2U7qv7nfX0gCWhXKA3lhlo=;
        b=pEdjEGt/8iFuAYBM1FR9QELYNHivsRnSpvckMU+R2itFa7kkcPcq8AJOYBSswPgczG
         gKqI6cgsAP/dq1ESS4VD81IfUXAs8lipY52Qr0BJUiK5zC7+DVbSc03DE2whpG/1/v6o
         GYjADjreGHYKOYQvHw1oMa4tUR7CrL8Do+ZJJXfkGkr4kjDuyikIwb1LzKp2k5T6vsh8
         Q+sHPPSZjVf+l3ZF9yl3t4lB/N+gLP/pQpbapMiQyW1mNEWdPhJeIjfb7XgnaQ07CKpb
         43vGc8Ex5gSPGgGCqA+VROAEju8zjxhaqPPkYCSJps5rwR4zu0JmBoycxPbPgqVsrfyA
         o5kg==
X-Forwarded-Encrypted: i=1; AJvYcCWNGNFJj4EfjytCOvm7rju+YJzBlmOonL7ec0xLfAQssBh2hOB17EpcMuDAjSH+1HfGcuA+OO+a/5hnKoL22fRBcc5DU4at2bXBaVFHU0ton6cFjHHtMNwWchn/9RHbKoK0/G5mVIYebTxvCXAqjcJkZXOlLxZ6R0vFvkULjmWg4GOi9/njWo06SWCehsuxAPpZ6FntVRlB1JcxTlvslWgk+UdZuksOpyIvLA04Psih93sJa96U
X-Gm-Message-State: AOJu0YwXgCgbmqwNr11Ijs1S3o9R14BymHtIiakaMydN7yTbAaeXSewh
	9gp5GRHwNnv9qCrXVbFzm2GxFZFEMOi3+TCQfi6B0/iYWb1vZieX
X-Google-Smtp-Source: AGHT+IFzcNCL4DB7c7G7kLyb+7UFm4o2GGJXJ/lKj59bEb2GT+3Qy+R5dFmfo0Jxs1fqaAcSpOVYtA==
X-Received: by 2002:a17:906:6a0a:b0:a6f:1d19:c0b1 with SMTP id a640c23a62f3a-a6f1d19c496mr372629566b.18.1718092146075;
        Tue, 11 Jun 2024 00:49:06 -0700 (PDT)
Received: from [10.16.124.60] ([212.227.34.98])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f2942b02fsm145877166b.167.2024.06.11.00.49.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Jun 2024 00:49:05 -0700 (PDT)
Message-ID: <900d1d56-28ea-4c6d-b8c7-749a952e5f4b@gmail.com>
Date: Tue, 11 Jun 2024 09:49:03 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC RESEND 00/16] Split IOMMU DMA mapping operation to two steps
To: "Zeng, Oak" <oak.zeng@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Robin Murphy <robin.murphy@arm.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Chaitanya Kulkarni <chaitanyak@nvidia.com>,
 "Brost, Matthew" <matthew.brost@intel.com>,
 "Hellstrom, Thomas" <thomas.hellstrom@intel.com>,
 Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
 Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
 Yishai Hadas <yishaih@nvidia.com>,
 Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
 "Tian, Kevin" <kevin.tian@intel.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
 "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 Bart Van Assche <bvanassche@acm.org>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 Amir Goldstein <amir73il@gmail.com>,
 "josef@toxicpanda.com" <josef@toxicpanda.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "daniel@iogearbox.net" <daniel@iogearbox.net>,
 "Williams, Dan J" <dan.j.williams@intel.com>, "jack@suse.com"
 <jack@suse.com>, "Bommu, Krishnaiah" <krishnaiah.bommu@intel.com>,
 "Ghimiray, Himal Prasad" <himal.prasad.ghimiray@intel.com>
References: <cover.1709635535.git.leon@kernel.org>
 <SA1PR11MB6991CB2B1398948F4241E51992182@SA1PR11MB6991.namprd11.prod.outlook.com>
 <20240503164239.GB901876@ziepe.ca>
 <PH7PR11MB70047236290DC1CFF9150B8592C62@PH7PR11MB7004.namprd11.prod.outlook.com>
 <20240610161826.GA4966@unreal>
 <PH7PR11MB7004A071F27B4CF45740B87E92C62@PH7PR11MB7004.namprd11.prod.outlook.com>
 <20240610172501.GJ791043@ziepe.ca>
 <PH7PR11MB7004DDE9816D92F690A5C0B692C62@PH7PR11MB7004.namprd11.prod.outlook.com>
Content-Language: en-US
From: Zhu Yanjun <zyjzyj2000@gmail.com>
In-Reply-To: <PH7PR11MB7004DDE9816D92F690A5C0B692C62@PH7PR11MB7004.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 10.06.24 23:28, Zeng, Oak wrote:
> Hi Jason, Leon,
>
> I was able to fix the issue from my side. Things work fine now.

Can you enlarge the dma list, then make tests with fio? Not sure if the 
performance is better or not.

Thanks,

Zhu Yanjun

> I got two questions though:
>
> 1) The value returned from dma_link_range function is not contiguous, see below print. The "linked pa" is the function return.
> I think dma_map_sgtable API would return some contiguous dma address. Is the dma-map_sgtable api is more efficient regarding the iommu page table? i.e., try to use bigger page size, such as use 2M page size when it is possible. With your new API, does it also have such consideration? I vaguely remembered Jason mentioned such thing, but my print below doesn't look like so. Maybe I need to test bigger range (only 16 pages range in the test of below printing). Comment?
>
> [17584.665126] drm_svm_hmmptr_map_dma_pages iova.dma_addr = 0x0, linked pa = 18ef3f000
> [17584.665146] drm_svm_hmmptr_map_dma_pages iova.dma_addr = 0x0, linked pa = 190d00000
> [17584.665150] drm_svm_hmmptr_map_dma_pages iova.dma_addr = 0x0, linked pa = 190024000
> [17584.665153] drm_svm_hmmptr_map_dma_pages iova.dma_addr = 0x0, linked pa = 178e89000
>
> 2) in the comment of dma_link_range function, it is said: " @dma_offset needs to be advanced by the caller with the size of previous page that was linked + DMA address returned for the previous page".
> Is this description correct? I don't understand the part "+ DMA address returned for the previous page ".
> In my codes, let's say I call this function to link 10 pages, the first dma_offset is 0, second is 4k, third 8k. This worked for me. I didn't add the previously returned dma address.
> Maybe I need more test. But any comment?
>
> Thanks,
> Oak
>
>> -----Original Message-----
>> From: Jason Gunthorpe <jgg@ziepe.ca>
>> Sent: Monday, June 10, 2024 1:25 PM
>> To: Zeng, Oak <oak.zeng@intel.com>
>> Cc: Leon Romanovsky <leon@kernel.org>; Christoph Hellwig <hch@lst.de>;
>> Robin Murphy <robin.murphy@arm.com>; Marek Szyprowski
>> <m.szyprowski@samsung.com>; Joerg Roedel <joro@8bytes.org>; Will
>> Deacon <will@kernel.org>; Chaitanya Kulkarni <chaitanyak@nvidia.com>;
>> Brost, Matthew <matthew.brost@intel.com>; Hellstrom, Thomas
>> <thomas.hellstrom@intel.com>; Jonathan Corbet <corbet@lwn.net>; Jens
>> Axboe <axboe@kernel.dk>; Keith Busch <kbusch@kernel.org>; Sagi
>> Grimberg <sagi@grimberg.me>; Yishai Hadas <yishaih@nvidia.com>;
>> Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>; Tian, Kevin
>> <kevin.tian@intel.com>; Alex Williamson <alex.williamson@redhat.com>;
>> Jérôme Glisse <jglisse@redhat.com>; Andrew Morton <akpm@linux-
>> foundation.org>; linux-doc@vger.kernel.org; linux-kernel@vger.kernel.org;
>> linux-block@vger.kernel.org; linux-rdma@vger.kernel.org;
>> iommu@lists.linux.dev; linux-nvme@lists.infradead.org;
>> kvm@vger.kernel.org; linux-mm@kvack.org; Bart Van Assche
>> <bvanassche@acm.org>; Damien Le Moal
>> <damien.lemoal@opensource.wdc.com>; Amir Goldstein
>> <amir73il@gmail.com>; josef@toxicpanda.com; Martin K. Petersen
>> <martin.petersen@oracle.com>; daniel@iogearbox.net; Williams, Dan J
>> <dan.j.williams@intel.com>; jack@suse.com; Zhu Yanjun
>> <zyjzyj2000@gmail.com>; Bommu, Krishnaiah
>> <krishnaiah.bommu@intel.com>; Ghimiray, Himal Prasad
>> <himal.prasad.ghimiray@intel.com>
>> Subject: Re: [RFC RESEND 00/16] Split IOMMU DMA mapping operation to
>> two steps
>>
>> On Mon, Jun 10, 2024 at 04:40:19PM +0000, Zeng, Oak wrote:
>>> Thanks Leon and Yanjun for the reply!
>>>
>>> Based on the reply, we will continue use the current version for
>>> test (as it is tested for vfio and rdma). We will switch to v1 once
>>> it is fully tested/reviewed.
>> I'm glad you are finding it useful, one of my interests with this work
>> is to improve all the HMM users.
>>
>> Jason

-- 
Best


