Return-Path: <kvm+bounces-41040-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C9497A60F57
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 11:53:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A96117AD923
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 10:52:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DA2F1FDA8D;
	Fri, 14 Mar 2025 10:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="MdOLMJHU"
X-Original-To: kvm@vger.kernel.org
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 783B01FCFC5
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 10:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741949594; cv=none; b=lfISOq9IvtbGC8GP/VpkdKfVZSDlg/kaYGWbv8wiRow8OIRzNvuHhrM6LKDWScEvHpj4WTABYzBgzZ0CaqzsUx23V5pPecJXUJgJid0Qc2OhXPfbTTakSAEVLQCX2aHqM1V40pRX15HY2PnU+VbVdVq206WZc3OkS9e3y+0D5Gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741949594; c=relaxed/simple;
	bh=/diLEnQGyox4m43R89ccR1VQLGWi1rjL6IMj1qEyYJk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=fGZw47gDbVBRp5+v4uGIRUCKbzO8lfHJrwaJp7SVJVv5FE7pvG73vuTx1e9BY+X2M5sTJCS/aplNsDrcAVbWDJ4o8jM6Kw6vitklClD1UXxN9E5olTUCLVgGtOZbBAvAioNCwldDWWTt95hEMGXBK8vMiPO1ga1MyJMpATXZVKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=MdOLMJHU; arc=none smtp.client-ip=210.118.77.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20250314105304euoutp02ed912d9b99790431fb3e4cb6c5c50af8~sper9PtTm0109401094euoutp021
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 10:53:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20250314105304euoutp02ed912d9b99790431fb3e4cb6c5c50af8~sper9PtTm0109401094euoutp021
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1741949584;
	bh=GDf7n0z9BWmBAuRh2vgU2+KaAQVjN1nhK84TViW1sYU=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=MdOLMJHUTJrYMmIgbHdkLHQa0BaipyVj9vZkqE3i711JoVrfW4o9DXKjSjzsr8dAb
	 3765vI0Ql8f3XeARsmAjNzYbAYy9o3oHk0ICfZvky3SOIvGEz5GgpsT+He9dahJlqz
	 5sQLqKJzcCXDJa8VgL+Ji4svN9PQK9fP+6peB5Kw=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTP id
	20250314105304eucas1p2f89c0fb6d3ceaa92ae0f0da9fa170bc2~sperhfC6B0385003850eucas1p26;
	Fri, 14 Mar 2025 10:53:04 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
	eusmges3new.samsung.com (EUCPMTA) with SMTP id A0.7B.20397.F8A04D76; Fri, 14
	Mar 2025 10:53:03 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20250314105303eucas1p1dcc67c3bc4c94d4a44b5aef03e5de21c~speqyQqt50374503745eucas1p1l;
	Fri, 14 Mar 2025 10:53:03 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
	eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20250314105303eusmtrp1590b805c70e1352e73549438ffaf406e~speqxS-3P2086620866eusmtrp1b;
	Fri, 14 Mar 2025 10:53:03 +0000 (GMT)
X-AuditID: cbfec7f5-e59c770000004fad-13-67d40a8f112c
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
	eusmgms2.samsung.com (EUCPMTA) with SMTP id 54.1B.19654.F8A04D76; Fri, 14
	Mar 2025 10:53:03 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250314105259eusmtip1ca4b7caf6e6d3445b47482f62192d308~spenscCDP0752407524eusmtip1b;
	Fri, 14 Mar 2025 10:52:59 +0000 (GMT)
Message-ID: <adb63b87-d8f2-4ae6-90c4-125bde41dc29@samsung.com>
Date: Fri, 14 Mar 2025 11:52:58 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 00/17] Provide a new two step DMA mapping API
To: Leon Romanovsky <leon@kernel.org>
Cc: Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>,
	Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>, Joerg Roedel
	<joro@8bytes.org>, Will Deacon <will@kernel.org>, Sagi Grimberg
	<sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>, Bjorn Helgaas
	<bhelgaas@google.com>, Logan Gunthorpe <logang@deltatee.com>, Yishai Hadas
	<yishaih@nvidia.com>, Shameer Kolothum
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
In-Reply-To: <20250312193249.GI1322339@unreal>
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Se0xTVxzHc+69vbfUlF1KHUemc2tkA5SHUfCYiVHHH3fLtriZbZlLps28
	K2S81vLQZYsVoUh5CaKFUqAbpQJWcFSYoIa2jlcYA60SQB4yeSjKFKUk0M2OcnHjv8/5fX/f
	fL/n5PBxUQPpy4+OS2TlcdIYCSkgGtsWeoLyBLdloY904UhXZyLRvCubRBeG80hkSI1C45YM
	gKovtGJocQ6h4qIOgEo0DzCUWXKJQgW2PoAqZxoopDv7HSpcrMTR9cHN6CeVgUD2Zh2JRkwu
	Hio3TlCou6ydRJO2HAIZ0pdoZkhDIOvTcR6qffSEQL/eSeWhtKEwZDwr2LOeGbeWYYypzASY
	yTuTgNHXJzE9I78QTNpvMzzGXBXIVFx7iDH27iSmviaTZOqfFVBMR5GTYMyG48wDczFgrg4o
	SaYi9wxvv/igYNcRNiY6mZWH7D4siGq+P8VLyN5ydPDJIqkEWX5q4MGH9HY4WtuPqYGAL6Kr
	ACzPaSXdgoieA1DVQXPCcwA7W3PBS4fDYcE54TyAt+wuwDlmARwe47lZSO+GtfdGlpmg/WB/
	XQXBzb1gZ/H4Mq+lN8LRwSLKzd50JLQ05uNuFi/tV+uHee4AnDZTUHc7czkAp33g4Hg55maS
	3grVM+rlqh50MKxuzVjZ2QhPNpQst4N0kwAOOF0rtSOh01KLcewNp9svUxyvh11nsgnOkAGg
	3jmKcYfTACqnBlfc78ChPxaX4vhLEQGwrjmEG++FvY4xyj2GtCfsn/HiSnjCgkYNzo2F8JRK
	xG2/BbXttf/FWntv4aeBRLvqXbSrrqlddR3t/7l6QNQAHzZJEStjFdvi2JRghTRWkRQnC/46
	PrYeLP3srhftjiugano22AYwPrAByMclYiGy22Ui4RHpse9ZefwheVIMq7CB1/iExEf4c0u6
	TETLpInstyybwMpfqhjfw1eJleLNYe89rrnZpDbOhmft32RY6NmSvylqaOBc2q5Ca8nend2q
	yy2/88QGAd/17g9avcrb9FmoZV3XqzdfTBaiV7Z3lFxpO08TIUZLm9f0mgTf0AxqPmBs36GL
	Hzw9t02Tk+yv1w5f80/94kTi87o1/6QcrGyJVPqdKs0//MYxCjQduPfwU1AVkFwdMVvkrYn9
	pHfDnrvRYX/XYKXfUAeue32ZIvkrdeF4mMMYlJNz40al+k+DPSTiK0XQs4asfT9uFn+4oMt7
	c2TnyLr7J8u7LjnZibvp8Sfers+ae73z4gZ84uoOocxzrXOgMLzsox0p5sd9uUenAmP837fO
	K0zDffKICvzzjyWEIkq6NRCXK6T/Av6VCMRIBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJKsWRmVeSWpSXmKPExsVy+t/xu7r9XFfSDa6/4LGYs34Nm8W3/z1s
	Fqvv9rNZLGnKsHhyoJ3RYuXqo0wWv75YWMyccYLRYvb0F0wWnbM3sFtMOnSN0WLp263sFnOm
	FlpM+bWU2WLvLW2LhW1LWCwu75rDZnFvzX9Wi/nLnrJbnJ13nM3i2aFeFoslrUDW2zvTWSwO
	fnjCarHu9XsWi+1Xm1gtWu6YWiybyuUg4/Hk4DwmjzXz1jB6PLv6jNFjwaZSj/P3NrJ4tBx5
	y+qxeYWWx+I9L5k8Lp8t9di0qpPNY9OnSeweJ2b8ZvHYvKTe48XmmYweu282sHks7pvMGiAS
	pWdTlF9akqqQkV9cYqsUbWhhpGdoaaFnZGKpZ2hsHmtlZKqkb2eTkpqTWZZapG+XoJex6/Fz
	1oIenYpb73+xNTB2q3YxcnJICJhIfP16gLmLkYtDSGApo8Tdvs3MEAkZiZPTGlghbGGJP9e6
	2CCK3jNKPGt5zwiS4BWwk1j34B5YEYuAqsSN9YtZIOKCEidnPgGzRQXkJe7fmsEOYgsLuEgc
	2DYRbIEIUP3KBXdZQYYyC2xllzhyrA/qjC1MEmfvzgbrYBYQl7j1ZD4TiM0mYCjR9RbkDE4O
	TgE9iZVH2xkhaswkurZ2QdnyEs1bZzNPYBSaheSQWUhGzULSMgtJywJGllWMIqmlxbnpucVG
	esWJucWleel6yfm5mxiBaWrbsZ9bdjCufPVR7xAjEwfjIUYJDmYlEV6Ly5fThXhTEiurUovy
	44tKc1KLDzGaAkNjIrOUaHI+MFHmlcQbmhmYGpqYWRqYWpoZK4nzsl05nyYkkJ5YkpqdmlqQ
	WgTTx8TBKdXAVJLWldx/8Or3ySXH/GzqJkb4cYQ2HnjvIXdj4gqpT1Hx78Prui0/nDA3nNd4
	7OSm7y2nM+LkrRakvLRwrp/srKTYFn/moHTXj8LKH1r162Rn3C9b9U3dnClQ72Fs3U/FXzFv
	Tz4p+LxGPKOb2Ttl0XqHm+aX9eannXs6Z80W731BZbGh9x5oiR+8x3Ajid+xtq4qLd6hauET
	ge1dn17cVJdr3T5DUWfb3okfd3Kls5/T2WrQK79DQ/lCysLuCRX9sw8WOmvOVzx7+fkZK1v+
	gMVebh+K/nsbcR1xOsIv58j/Iccv1MjyUb28q+ajhetOqDCEpFzJbGVectHqzpyTr74rbzo0
	w3fGAn1Bhzl7lFiKMxINtZiLihMBoquq1twDAAA=
X-CMS-MailID: 20250314105303eucas1p1dcc67c3bc4c94d4a44b5aef03e5de21c
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
	<d408b1c7-eabf-4a1e-861c-b2ddf8bf9f0e@samsung.com>
	<20250312193249.GI1322339@unreal>

On 12.03.2025 20:32, Leon Romanovsky wrote:
> On Wed, Mar 12, 2025 at 10:28:32AM +0100, Marek Szyprowski wrote:
>> Hi Robin
>>
>> On 28.02.2025 20:54, Robin Murphy wrote:
>>> On 20/02/2025 12:48 pm, Leon Romanovsky wrote:
>>>> On Wed, Feb 05, 2025 at 04:40:20PM +0200, Leon Romanovsky wrote:
>>>>> From: Leon Romanovsky <leonro@nvidia.com>
>>>>>
>>>>> Changelog:
>>>>> v7:
>>>>>    * Rebased to v6.14-rc1
>>>> <...>
>>>>
>>>>> Christoph Hellwig (6):
>>>>>     PCI/P2PDMA: Refactor the p2pdma mapping helpers
>>>>>     dma-mapping: move the PCI P2PDMA mapping helpers to pci-p2pdma.h
>>>>>     iommu: generalize the batched sync after map interface
>>>>>     iommu/dma: Factor out a iommu_dma_map_swiotlb helper
>>>>>     dma-mapping: add a dma_need_unmap helper
>>>>>     docs: core-api: document the IOVA-based API
>>>>>
>>>>> Leon Romanovsky (11):
>>>>>     iommu: add kernel-doc for iommu_unmap and iommu_unmap_fast
>>>>>     dma-mapping: Provide an interface to allow allocate IOVA
>>>>>     dma-mapping: Implement link/unlink ranges API
>>>>>     mm/hmm: let users to tag specific PFN with DMA mapped bit
>>>>>     mm/hmm: provide generic DMA managing logic
>>>>>     RDMA/umem: Store ODP access mask information in PFN
>>>>>     RDMA/core: Convert UMEM ODP DMA mapping to caching IOVA and page
>>>>>       linkage
>>>>>     RDMA/umem: Separate implicit ODP initialization from explicit ODP
>>>>>     vfio/mlx5: Explicitly use number of pages instead of allocated
>>>>> length
>>>>>     vfio/mlx5: Rewrite create mkey flow to allow better code reuse
>>>>>     vfio/mlx5: Enable the DMA link API
>>>>>
>>>>>    Documentation/core-api/dma-api.rst   |  70 ++++
>>>>    drivers/infiniband/core/umem_odp.c   | 250 +++++---------
>>>>>    drivers/infiniband/hw/mlx5/mlx5_ib.h |  12 +-
>>>>>    drivers/infiniband/hw/mlx5/odp.c     |  65 ++--
>>>>>    drivers/infiniband/hw/mlx5/umr.c     |  12 +-
>>>>>    drivers/iommu/dma-iommu.c            | 468
>>>>> +++++++++++++++++++++++----
>>>>>    drivers/iommu/iommu.c                |  84 ++---
>>>>>    drivers/pci/p2pdma.c                 |  38 +--
>>>>>    drivers/vfio/pci/mlx5/cmd.c          | 375 +++++++++++----------
>>>>>    drivers/vfio/pci/mlx5/cmd.h          |  35 +-
>>>>>    drivers/vfio/pci/mlx5/main.c         |  87 +++--
>>>>>    include/linux/dma-map-ops.h          |  54 ----
>>>>>    include/linux/dma-mapping.h          |  85 +++++
>>>>>    include/linux/hmm-dma.h              |  33 ++
>>>>>    include/linux/hmm.h                  |  21 ++
>>>>>    include/linux/iommu.h                |   4 +
>>>>>    include/linux/pci-p2pdma.h           |  84 +++++
>>>>>    include/rdma/ib_umem_odp.h           |  25 +-
>>>>>    kernel/dma/direct.c                  |  44 +--
>>>>>    kernel/dma/mapping.c                 |  18 ++
>>>>>    mm/hmm.c                             | 264 +++++++++++++--
>>>>>    21 files changed, 1435 insertions(+), 693 deletions(-)
>>>>>    create mode 100644 include/linux/hmm-dma.h
>>>> Kind reminder.
> <...>
>
>> Removing the need for scatterlists was advertised as the main goal of
>> this new API, but it looks that similar effects can be achieved with
>> just iterating over the pages and calling page-based DMA API directly.
> Such iteration can't be enough because P2P pages don't have struct pages,
> so you can't use reliably and efficiently dma_map_page_attrs() call.
>
> The only way to do so is to use dma_map_sg_attrs(), which relies on SG
> (the one that we want to remove) to map P2P pages.

That's something I don't get yet. How P2P pages can be used with 
dma_map_sg_attrs(), but not with dma_map_page_attrs()? Both operate 
internally on struct page pointer.

>> Maybe I missed something. I still see some advantages in this DMA API
>> extension, but I would also like to see the clear benefits from
>> introducing it, like perf logs or other benchmark summary.
> We didn't focus yet on performance, however Christoph mentioned in his
> block RFC [1] that even simple conversion should improve performance as
> we are performing one P2P lookup per-bio and not per-SG entry as was
> before [2]. In addition it decreases memory [3] too.
>
> [1] https://lore.kernel.org/all/cover.1730037261.git.leon@kernel.org/
> [2] https://lore.kernel.org/all/34d44537a65aba6ede215a8ad882aeee028b423a.1730037261.git.leon@kernel.org/
> [3] https://lore.kernel.org/all/383557d0fa1aa393dbab4e1daec94b6cced384ab.1730037261.git.leon@kernel.org/
>
> So clear benefits are:
> 1. Ability to use native for subsystem structure, e.g. bio for block,
> umem for RDMA, dmabuf for DRM, e.t.c. It removes current wasteful
> conversions from and to SG in order to work with DMA API.
> 2. Batched request and iotlb sync optimizations (perform only once).
> 3. Avoid very expensive call to pgmap pointer.
> 4. Expose MMIO over VFIO without hacks (PCI BAR doesn't have struct pages).
> See this series for such a hack
> https://lore.kernel.org/all/20250307052248.405803-1-vivek.kasireddy@intel.com/

I see those benefits and I admit that for typical DMA-with-IOMMU case it 
would improve some things. I think that main concern from Robin was how 
to handle it for the cases without an IOMMU.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


