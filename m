Return-Path: <kvm+bounces-40822-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BFEBA5D973
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 10:29:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5F6D1173047
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 09:28:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10F5523A9A8;
	Wed, 12 Mar 2025 09:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Ze2jFdmu"
X-Original-To: kvm@vger.kernel.org
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBAEE230BF1
	for <kvm@vger.kernel.org>; Wed, 12 Mar 2025 09:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741771722; cv=none; b=j7KpK+Sxj7XpnlZgjRtneCQel/PMvHFcf2nqlpvLCqGMldxnHE7xHCcXLjuYFrkA1nz/IPtGj84y+GxTesN7VLDBHmsv37Q5dkivGtvB3BmoIOSaNtwEb1qjtJaw7dGKWu5SVJoORvu59rwm7Jcb8XtVhKP2fWT9YtAEDhnglJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741771722; c=relaxed/simple;
	bh=6KAeTydDNQmh9ejxV3lHGEocGPHDZC5ErvVvG5/OBoo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=pqI3yII++CVOGoZM/Ap91JfHiGxFFZQxtX0Xls2+gyzFMlAzWf9fRD8WfaBK7/vywtBe8Hqx5YQMXh7KpJiRwreFhd5LaIxDoVpP+escVM3rbec2iF0aiUKDFH+TK7AyZXij/yrRhvCUBrV9XVWS1DY23pCiRPIuo/F+E4KnX8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Ze2jFdmu; arc=none smtp.client-ip=210.118.77.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20250312092838euoutp017b9dace745e3736961f4ff40ee851d1d~sBCY7rv5a2538425384euoutp013
	for <kvm@vger.kernel.org>; Wed, 12 Mar 2025 09:28:38 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20250312092838euoutp017b9dace745e3736961f4ff40ee851d1d~sBCY7rv5a2538425384euoutp013
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1741771718;
	bh=jM2XikXEr0ikBo0oLtomrsxm7QlhoeG8uKeeSTS19yM=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=Ze2jFdmuO0cLLYqLIJd51/wQzBFKAzxgIHozoFZZoNuFZcFG485swGkdKMqUW/Zvp
	 cl2zr4/04Ndda/wzPd5iBES/LxTo9/80XTM5/yJ6P9bBGWVcJ9B29HLYT+lSWshREK
	 7AGTFVkE3KSlN6ONOEzzV8Pi8Yif9QuOagwPNUks=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTP id
	20250312092837eucas1p25b1b9a0eaeeeb28386900bd5799beff7~sBCYkpiud1062910629eucas1p2o;
	Wed, 12 Mar 2025 09:28:37 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
	eusmges2new.samsung.com (EUCPMTA) with SMTP id 6E.F9.20409.5C351D76; Wed, 12
	Mar 2025 09:28:37 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20250312092837eucas1p141720d6a0df85c410f2b2209e4cb4ae1~sBCYE1szl1182811828eucas1p1t;
	Wed, 12 Mar 2025 09:28:37 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
	eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20250312092837eusmtrp1bf90383d9f98004fe39bcc48be1d1fe1~sBCYCvohl2987729877eusmtrp1N;
	Wed, 12 Mar 2025 09:28:37 +0000 (GMT)
X-AuditID: cbfec7f4-c39fa70000004fb9-67-67d153c532b4
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
	eusmgms2.samsung.com (EUCPMTA) with SMTP id 8C.F0.19654.5C351D76; Wed, 12
	Mar 2025 09:28:37 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250312092833eusmtip25e36488a2aac248bc9b654fb690ddc66~sBCVArikT0743107431eusmtip2e;
	Wed, 12 Mar 2025 09:28:33 +0000 (GMT)
Message-ID: <d408b1c7-eabf-4a1e-861c-b2ddf8bf9f0e@samsung.com>
Date: Wed, 12 Mar 2025 10:28:32 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 00/17] Provide a new two step DMA mapping API
To: Robin Murphy <robin.murphy@arm.com>, Leon Romanovsky <leon@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>, Will
	Deacon <will@kernel.org>, Sagi Grimberg <sagi@grimberg.me>, Keith Busch
	<kbusch@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, Logan Gunthorpe
	<logang@deltatee.com>, Yishai Hadas <yishaih@nvidia.com>, Shameer Kolothum
	<shameerali.kolothum.thodi@huawei.com>, Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	=?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Andrew Morton
	<akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev, linux-nvme@lists.infradead.org,
	linux-pci@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org, Randy
	Dunlap <rdunlap@infradead.org>
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <1166a5f5-23cc-4cce-ba40-5e10ad2606de@arm.com>
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0xTZxjH97anp6VQdiwobxRH2l2o6KigZO+CdgyNOfpBXbbswz64NeNY
	CBehpWzMLDYMtHRctEiAgoDaCqNFsIxuVlHbgS0QBsiYchGDKZVLymgHTmGbkx628e33f97/
	c83LYfLb8c2clIxsSp4hTRPiXMxy93n/210fDsp23l+IRDUtJhw9fVGEI+PDUhzp85KR684Z
	gL4zdjHQ8iJCVZVOgKorphmosLqVjbT2XwEyeNrZqKY8C51fNjBRx+h2dPG0HkND1hocTZhe
	sFDdlSk26qt14MhtL8aQvuAlecYrMGRbcLHQ1bnfMPTDcB4L5Y/HoSvl3IRw0mWrZZCmWhMg
	3cNuQNablWT/xDWMzO/0sMi2xijy8s0ZBjnUpyTNTYU4afZp2aSzcgUj2/SnyOm2KkDeGFHh
	5OWSMtbR0E+4e5KotJQcSi6WfMZNHnFuybwt/rLQ7mCoQEOkBnA4kNgNB31JGsDl8IlGAN13
	F1i0WARw5vwyoMXvAHYUexkaEODPaLSq11wNAN6ssmO08ALou9eMrbp4hATeLzH5MzDiTVg8
	1bEW3wC7q1x+3khEwEejlexVDiH2wzuWc8zVQqFEEYC2oT/9JibRg8PnTw7QHAZHXXX+ojgR
	AzUeDb7KAUQ8nC/4hU17IuA37dX+QpCwceEDSyWLnns/tBuMaxwCZx3fs2kOh71lRRidcAbA
	+pVHDFqcBVD1ZBTQrng4/vMyvnozJrENtljFdPh9OLA0yaZPGQwfeDbQQwRDraWCSYd5UH2a
	T7vfgjrH1f/a2gbuMc8CoW7dXXTr1tStW0f3f996gDWBMEqpSJdRitgM6otohTRdocyQRX9+
	It0MXv7s3r8diz+ChllvtB0wOMAOIIcpDOUZ9w7I+Lwkae5XlPzEp3JlGqWwgy0cTBjGu3S7
	QMYnZNJsKpWiMin5v68MTsBmFePjg7uDJLceL73TCqhcgSZ3LKG6YW5raimP79tbJ7IOPhN9
	HSw0fNsaNBU73xqi8mZH5R3ftz0oueX68eFbG6mTzUWmngZkbntNqy4XRbD7+1KOxM2ee336
	5A1nwS4ROcuO73Ad3PNXafjAoLUvzM2aCzarX+lWR838NB75kbDp6OTY4WMRIx/scqDCkmvR
	mRZfzAF9iWfb4USxTLyvbjgywfB4x3sGZ41AkihauhCYmHr9VEp1z8oxmVv4blpvVhzPc8im
	FVyaP2T7Y6458NmwoF/wVCu52J3onUh/WLcjMKdr2rh10TDQOPZqIRmeuSmrPj9TH7up842y
	nCM7JztJIaZIlsZEMeUK6T9oYz5PSAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJKsWRmVeSWpSXmKPExsVy+t/xe7pHgy+mGxybwmoxZ/0aNotv/3vY
	LFbf7WezWNKUYfHkQDujxcrVR5ksfn2xsJg54wSjxezpL5gsOmdvYLeYdOgao8XSt1vZLeZM
	LbSY8msps8XeW9oWC9uWsFhc3jWHzeLemv+sFvOXPWW3ODvvOJvFs0O9LBZLWoGst3ems1gc
	/PCE1WLd6/csFtuvNrFatNwxtVg2lctBxuPJwXlMHmvmrWH0eHb1GaPHgk2lHufvbWTxaDny
	ltVj8wotj8V7XjJ5XD5b6rFpVSebx6ZPk9g9Tsz4zeKxeUm9x4vNMxk9dt9sYPNY3DeZNUAk
	Ss+mKL+0JFUhI7+4xFYp2tDCSM/Q0kLPyMRSz9DYPNbKyFRJ384mJTUnsyy1SN8uQS/j5gnp
	gv36FZ2HjjM1MC5X72Lk5JAQMJFYsauDtYuRi0NIYCmjxIS/p5ghEjISJ6c1sELYwhJ/rnWx
	QRS9Z5RY++UkO0iCV8BO4nrfGiYQm0VAVaL36V4WiLigxMmZT8BsUQF5ifu3ZoDVCwu4SBzY
	NpEZZJCIQA+jxLdTrxlBHGaBM2wSl08dZodYcZtR4u6OZ2DtzALiEreezAdbwSZgKNH1FuQO
	Tg5OAWuJd61X2CFqzCS6tnYxQtjyEs1bZzNPYBSaheSSWUhGzULSMgtJywJGllWMIqmlxbnp
	ucVGesWJucWleel6yfm5mxiBaWrbsZ9bdjCufPVR7xAjEwfjIUYJDmYlEd7VthfShXhTEiur
	Uovy44tKc1KLDzGaAoNjIrOUaHI+MFHmlcQbmhmYGpqYWRqYWpoZK4nzsl05nyYkkJ5Ykpqd
	mlqQWgTTx8TBKdXA5MXweTLfSoUt60qSqyf199psCJmzLOjbt8Dp+7jLF2+ZuEluf1nFmbOd
	l+qXd9/ft6TgwH4DreD/wnf1z2qZXhOetSktKnbvNVmG5GOnBBm31dzN+6q+VYDH/nXctaXM
	DRaGhnPUPZ5uLq/ju9p/c8Lyk3EfPjhwBL4XLv7acvXf23j5OaW87x66Vu0X7fJa8Thh2ccZ
	gsVbGVZfm5p4ViVl+65LbPukf8vc5kivmOKxdG+f8RpZ3sqDYcteLtZunVmxxVM+7JHComdz
	/OTe5AR/tP1X1fZmt+BTkYmPJr/2fLbOLX6/YIXdFHGLCU2v7nSZ83W9mB+3dPf3mvIjtrN5
	81IPXWh+2M93O+XnxA4lluKMREMt5qLiRABwmQ+33AMAAA==
X-CMS-MailID: 20250312092837eucas1p141720d6a0df85c410f2b2209e4cb4ae1
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20250228195423eucas1p221736d964e9aeb1b055d3ee93a4d2648
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20250228195423eucas1p221736d964e9aeb1b055d3ee93a4d2648
References: <cover.1738765879.git.leonro@nvidia.com>
	<20250220124827.GR53094@unreal>
	<CGME20250228195423eucas1p221736d964e9aeb1b055d3ee93a4d2648@eucas1p2.samsung.com>
	<1166a5f5-23cc-4cce-ba40-5e10ad2606de@arm.com>

Hi Robin

On 28.02.2025 20:54, Robin Murphy wrote:
> On 20/02/2025 12:48 pm, Leon Romanovsky wrote:
>> On Wed, Feb 05, 2025 at 04:40:20PM +0200, Leon Romanovsky wrote:
>>> From: Leon Romanovsky <leonro@nvidia.com>
>>>
>>> Changelog:
>>> v7:
>>>   * Rebased to v6.14-rc1
>>
>> <...>
>>
>>> Christoph Hellwig (6):
>>>    PCI/P2PDMA: Refactor the p2pdma mapping helpers
>>>    dma-mapping: move the PCI P2PDMA mapping helpers to pci-p2pdma.h
>>>    iommu: generalize the batched sync after map interface
>>>    iommu/dma: Factor out a iommu_dma_map_swiotlb helper
>>>    dma-mapping: add a dma_need_unmap helper
>>>    docs: core-api: document the IOVA-based API
>>>
>>> Leon Romanovsky (11):
>>>    iommu: add kernel-doc for iommu_unmap and iommu_unmap_fast
>>>    dma-mapping: Provide an interface to allow allocate IOVA
>>>    dma-mapping: Implement link/unlink ranges API
>>>    mm/hmm: let users to tag specific PFN with DMA mapped bit
>>>    mm/hmm: provide generic DMA managing logic
>>>    RDMA/umem: Store ODP access mask information in PFN
>>>    RDMA/core: Convert UMEM ODP DMA mapping to caching IOVA and page
>>>      linkage
>>>    RDMA/umem: Separate implicit ODP initialization from explicit ODP
>>>    vfio/mlx5: Explicitly use number of pages instead of allocated 
>>> length
>>>    vfio/mlx5: Rewrite create mkey flow to allow better code reuse
>>>    vfio/mlx5: Enable the DMA link API
>>>
>>>   Documentation/core-api/dma-api.rst   |  70 ++++
>>   drivers/infiniband/core/umem_odp.c   | 250 +++++---------
>>>   drivers/infiniband/hw/mlx5/mlx5_ib.h |  12 +-
>>>   drivers/infiniband/hw/mlx5/odp.c     |  65 ++--
>>>   drivers/infiniband/hw/mlx5/umr.c     |  12 +-
>>>   drivers/iommu/dma-iommu.c            | 468 
>>> +++++++++++++++++++++++----
>>>   drivers/iommu/iommu.c                |  84 ++---
>>>   drivers/pci/p2pdma.c                 |  38 +--
>>>   drivers/vfio/pci/mlx5/cmd.c          | 375 +++++++++++----------
>>>   drivers/vfio/pci/mlx5/cmd.h          |  35 +-
>>>   drivers/vfio/pci/mlx5/main.c         |  87 +++--
>>>   include/linux/dma-map-ops.h          |  54 ----
>>>   include/linux/dma-mapping.h          |  85 +++++
>>>   include/linux/hmm-dma.h              |  33 ++
>>>   include/linux/hmm.h                  |  21 ++
>>>   include/linux/iommu.h                |   4 +
>>>   include/linux/pci-p2pdma.h           |  84 +++++
>>>   include/rdma/ib_umem_odp.h           |  25 +-
>>>   kernel/dma/direct.c                  |  44 +--
>>>   kernel/dma/mapping.c                 |  18 ++
>>>   mm/hmm.c                             | 264 +++++++++++++--
>>>   21 files changed, 1435 insertions(+), 693 deletions(-)
>>>   create mode 100644 include/linux/hmm-dma.h
>>
>> Kind reminder.
>
> ...that you've simply reposted the same thing again? Without doing 
> anything to address the bugs, inconsistencies, fundamental design 
> flaws in claiming to be something it cannot possibly be, the egregious 
> abuse of DMA_ATTR_SKIP_CPU_SYNC proudly highlighting how 
> unfit-for-purpose the most basic part of the whole idea is, nor 
> *still* the complete lack of any demonstrable justification of how 
> callers who supposedly can't use the IOMMU API actually benefit from 
> adding all the complexity of using the IOMMU API in a hat but also 
> still the streaming DMA API as well?
>
> Yeah, consider me reminded.
>
>
>
> In case I need to make it any more explicit, NAK to this not-generic 
> not-DMA-mapping API, until you can come up with either something which 
> *can* actually work in any kind of vaguely generic manner as claimed, 
> or instead settle on a reasonable special-case solution for 
> justifiable special cases. Bikeshedding and rebasing through half a 
> dozen versions, while ignoring fundamental issues I've been pointing 
> out from the very beginning, has not somehow magically made this 
> series mature and acceptable to merge.
>
> Honestly, given certain other scenarios we may also end up having to 
> deal with, if by the time everything broken is taken away, it were to 
> end up stripped all the way back to something well-reasoned like:
>
> "Some drivers want more control of their DMA buffer layout than the 
> general-purpose IOVA allocator is able to provide though the DMA 
> mapping APIs, but also would rather not have to deal with managing an 
> entire IOMMU domain and address space, making MSIs work, etc. Expose 
> iommu_dma_alloc_iova() and some trivial IOMMU API wrappers to allow 
> drivers of coherent devices to claim regions of the default domain 
> wherein they can manage their own mappings directly."
>
> ...I wouldn't necessarily disagree.


Well, this is definitely not a review I've expected. I admit that I 
wasn't involved in this proposal nor the discussion about it and I 
wasn't able to devote enough time for keeping myself up to date. Now 
I've tried to read all the required backlog and I must admit that this 
was quite demanding.

If You didn't like this design from the beginning, then please state 
that early instead of pointing random minor issues in the code. There 
have been plenty of time to discuss the overall approach if You think it 
was wrong. What do to now?

Removing the need for scatterlists was advertised as the main goal of 
this new API, but it looks that similar effects can be achieved with 
just iterating over the pages and calling page-based DMA API directly. 
Maybe I missed something. I still see some advantages in this DMA API 
extension, but I would also like to see the clear benefits from 
introducing it, like perf logs or other benchmark summary.


Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


