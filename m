Return-Path: <kvm+bounces-41638-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 582FEA6B1DC
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 00:53:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 340258880C6
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 23:52:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 137E921C9E7;
	Thu, 20 Mar 2025 23:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ut2npbg4"
X-Original-To: kvm@vger.kernel.org
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F57B1EDA05
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 23:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742514767; cv=none; b=V0CtgJY7ztJUUxP3hnispPM82NGoTM7pxof15N01ojvk4WrZn1cUlHJqvb1YykeMv9HxMPN9/CbA6n0JK4f4r9KTAw/YaH+mXl+pDaX/6lCTbu5cW9yROYOsZcdxVItimafOXg9cD3zAShOUF0Ow3f9Vi1imVMjb62hKkFuT8cE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742514767; c=relaxed/simple;
	bh=VKx7RH8Mg8DPC+U1B1C8czPF3VXsHpYGIbro1lkVn6s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=l9oeC7WTCGP+MsTyXQhyQMaosXlwqaMTy9+JVvzGCdry+9TihUHcrP8H6X3Iv3krtDLrd/dBJB9Umt6Rq6m55/Ih7doqvZxyThk0XusjqxOis/oEmDZp/dTRxkrokS3Tb1DuGNYGcq/vmC7a3GjRXvFYH91LwuplCcHk/gO41TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=ut2npbg4; arc=none smtp.client-ip=210.118.77.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20250320235237euoutp012a9bb9b98de7a63d3d78324f531d41a1~up-CtAv8O0702507025euoutp01T
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 23:52:37 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20250320235237euoutp012a9bb9b98de7a63d3d78324f531d41a1~up-CtAv8O0702507025euoutp01T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1742514758;
	bh=V40Yt8b5UQP5CQRebMaM4XT/r0qYRmMZ1DD0U7kvnK4=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=ut2npbg4/kdcP2bqSdFlfrUbOPb3A5+wIWFnP1CDcxcmTBdUP5JsoPTmaSPgllVtW
	 12v/xbNbkMJ8m2iNY9Y0f+LGHF28UMshTJ8v7BXonnoeHcoMfhc6dJCAR4w6RO+Biz
	 v0cL49lJyjsjlqArWlGlfnAFNqjgUfI3WAGoW4Jk=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTP id
	20250320235236eucas1p2d25a78b8b13dc4ab1b2ca298ada0dfd6~up-BT_ZSP1299312993eucas1p2O;
	Thu, 20 Mar 2025 23:52:36 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
	eusmges1new.samsung.com (EUCPMTA) with SMTP id 33.34.20821.44AACD76; Thu, 20
	Mar 2025 23:52:36 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20250320235235eucas1p20083fac3310cb507f47cd27594507feb~up-Ah0Xfl1299312993eucas1p2N;
	Thu, 20 Mar 2025 23:52:35 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
	eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20250320235235eusmtrp147af0699b5659e6df38f53ef4ac28c3e~up-AhBruB1931419314eusmtrp12;
	Thu, 20 Mar 2025 23:52:35 +0000 (GMT)
X-AuditID: cbfec7f2-b09c370000005155-97-67dcaa4406f9
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
	eusmgms1.samsung.com (EUCPMTA) with SMTP id 4F.88.19920.34AACD76; Thu, 20
	Mar 2025 23:52:35 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250320235231eusmtip12043beb3ef63386f7348b314310b8aad~up_9CwvKL2854028540eusmtip1R;
	Thu, 20 Mar 2025 23:52:31 +0000 (GMT)
Message-ID: <1034b694-2b25-4649-a004-19e601061b90@samsung.com>
Date: Fri, 21 Mar 2025 00:52:30 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 00/17] Provide a new two step DMA mapping API
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Joerg Roedel
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
In-Reply-To: <20250319175840.GG10600@ziepe.ca>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01SbUxTVxjOuff2tjQpuRQcB2UjK5MFNgrdNJ5kwMCw5U7/4H5sGcviGrkW
	t1K1tYgk2zrGl11RKLCWwko3y4eF8C1gFYQiK4QJDCNiBTsTZEztBsJ0fAxHe3Xj3/M+z/N+
	PCeHhws7yO28I4oTjFIhlYtIPtH508podLJtWhY71BiIqpobSfT4qY5EDTNnSWTNSUezfQUA
	nW8YxNDqMkIVxiGAKg3zGDpd2cJFesckQDWeC1xUVX4cla3W4KjH9Rr6Id9KoOv2KhLdaXzK
	QdW197jomtlJojlHEYGseZvIM20gUP/CLAc1PfiTQF03cjgod3o3qi3nJ4bSs/1mjG40NwJ6
	7sYcoC1tanrsTitB5171cOj2+ij63OXfMfr6NTXdZjtN0m2P9Fx6yLhG0O3Wr+j59gpAX7ql
	IelzZ0o5KUGp/Lg0Rn4kk1HGJHzKTz/v6CWPbYRkDRdWExowEKQFfjxI7YITXeOYFvB5Qqoe
	wG8vDZJeQUgtA6hxxbPCEoC3NXr8eUeBuxBnhToA6w1zBFssAqgtrfa1C6gEaC4x+DBB7YSa
	xRKc5QPgcMUs4cXbqDDodhm5XhxIJcO+TtYTRIlgr72E6x2KU51caJpfxLwCTgVD12y1D5OU
	BGo9Wt8CP0oMS8bmnnnCYJen6tmpPXzo7E7RAt4mToZVRRKWDoT3nR1cFofCkVKdLwCkCgC0
	rLkxtijezP+bC7Cut+D06CrpHYRTkbDZHsPSSXD8r7tcdr4/nPIEsCf4Q32nAWdpASzMF7Lu
	CGhyNv23tn98Ai8GItOWVzFtCWnaEsb0/14LIGwgmFGrMmSMSqJgTopV0gyVWiETHzqa0QY2
	P/bIhvNRN/j+/qLYATAecADIw0VBgqDC2zKhIE16KptRHj2oVMsZlQPs4BGiYMGPV/JkQkom
	PcF8zjDHGOVzFeP5bddgqbkxO+oK9yxULue/+apiwhhge6XBP+lJZsIv4nj9njMD+6s5kfbo
	vZaQfR91L67Y4tt7i12Wla+L392bvYTVt7uN6Ilj6hvzzNquy1+EvDEzaD8QR6jOmsqOl4X1
	JYa/3KLTW9HFn4u4bcHY+8v+fusvuK/8un7h1MmWOOvBT4bX/7l44O/3djo/nH67qzYl1uGp
	e5Bz8+qSOWUsemXI4Hp8C6xt8D+2CMOSbdnNqff+GI35kp7MGi6TK16aVC7dVH23sC8p0ZaZ
	Jw+u0EVQD2vsD/PQ67EfhN9NM4QuROoGWnts68ShEUVTXYdjqnX3O11Z5ZPWiM8U+qjD2yTp
	4bkvHhYRqnSpJApXqqT/ApX9M15HBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA02SfUxTZxTG8957e1uqXS61pi/oYDZxc+oqBVpflrZjH3HXLDMkhmRzG6zC
	tTRAi70tkS1mjWMCzZyrFoFKWrTFjNK5rY1CABvo1EoMQyCSwQAH1spYikgWEoXJKM0S/vvl
	nOc5z8nJ4eHCfk4qT6c3MUa9pkxC8om7L8KTb7zrndBmDNrTUPNPPhItrX5LovbJsyTynCpB
	kd4agNrab2Ho+T8INTXeAehiwyyG6i7+zEXnQqMAtcaucVFz/XFkf96Koxvje9Cl0x4CjXQ1
	k2jKt8pBriuPuGjAGSZRNHSGQJ5v1ig20UCgvoUIB139+wmBOu6f4qDqCTm6Us/P3U5H+pwY
	7XP6AB29HwV0i99MD079QtDVN2McOvDDbtrd8xdGjwyYab+3jqT9i+e49J3GZYIOeL6iZwNN
	gO4es5C0+7vznDzREanSaDCbmFdKDKxJJflEhjKlshwkzczOkcqy9n/2ZqZcsk+tLGbKdJWM
	cZ/6c2lJWyhIVrxIOdFf6yIs4FeRFSTxIJUNax7U4lbA5wmpVgB7Fn/EE43tsP+ChZPgLXBl
	1EomRE8A9J5d5MYbAkoNnbYGMs4EtRNantrwRD0Z9jdFiDhvpdLhg/HGdf0W6j3Yez2hEVES
	GOyyceNDcaqTC4e6wlgi4QwOH12eX4/GKTEcj7iwOJOUDFpj1vW0JEoKbYNRLKFRQOs1K0hw
	OuyINePfA6FjwyKODaMcGyyODZYWQHiBiDGz5dpyViZlNeWsWa+VFhnK/WDtp67ffhboBM65
	p9IQwHggBCAPl4gEoto/tEJBsabqC8ZoKDSayxg2BORr17DhqVuLDGtPqTcVyhQZclm2IidD
	nqPIkogFB0YGjwkprcbElDJMBWP834fxklItWOl0L9ItF7g+euwDqsX+HcaV9kO/hXVfpqpe
	L25r+1Q79afD61DOvR8eyh1Gy3vempoVpvk387pVWSbvRNrC2LG9p2fGYkdP7OrUFAqTu6Em
	N7Ksyg8etCuSH6fGQuik+8LDg/zjoV0dtfXBqzvu3VhoKSlYiKmml8r61GI3/m/KtqMVhw+3
	z/w+XjbQ6vmw+jw7D6O5Kfbp2qqu18YqOUpD3jv5O5eKOh7e4yuH82sCz3RzH0xs6t58+/K2
	7gGKSb/lLvDZxZbiHuPbwqG6m/MnZ1ZW1XLMtp8NCzqrXHurJ0eDw1/XZR3p0XNe8i+9vCk3
	cDfPKa50lr5a+XG9hGBLNLLduJHV/AehhEaR3AMAAA==
X-CMS-MailID: 20250320235235eucas1p20083fac3310cb507f47cd27594507feb
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
	<adb63b87-d8f2-4ae6-90c4-125bde41dc29@samsung.com>
	<20250319175840.GG10600@ziepe.ca>

On 19.03.2025 18:58, Jason Gunthorpe wrote:
> On Fri, Mar 14, 2025 at 11:52:58AM +0100, Marek Szyprowski wrote:
>
>>> The only way to do so is to use dma_map_sg_attrs(), which relies on SG
>>> (the one that we want to remove) to map P2P pages.
>> That's something I don't get yet. How P2P pages can be used with
>> dma_map_sg_attrs(), but not with dma_map_page_attrs()? Both operate
>> internally on struct page pointer.
> It is a bit subtle, I ran in to this when exploring enabling proper
> P2P for dma_map_resource() too.
>
> The API signatures are:
>
> dma_addr_t dma_map_page_attrs(struct device *dev, struct page *page,
> 		size_t offset, size_t size, enum dma_data_direction dir,
> 		unsigned long attrs);
> void dma_unmap_page_attrs(struct device *dev, dma_addr_t addr, size_t size,
> 		enum dma_data_direction dir, unsigned long attrs);
>
> The thing to notice immediately is that the unmap path does not get
> passed a struct page.

I see, thanks for pointing this out. It looks that I've encountered this 
issue too long time ago when I was implementing first 
iommu-to-dma-mapping glue for ARM arch. The lack of some kind of 
'object' returned from dma_map* (and dma_alloc*) and passed back to 
dma_unmap* (and dma_free_*) required some non-trivial workarounds there 
and made the unmap/free path a bit more complicated.

> So, lets think about the flow when the iommu is turned on.
>
> For normal struct page memory:
>
>   - dma_map_page_attrs() allocates some IOVA and returns it in the
>     dma_addr_t and then maps the struct page to the iommu page table
>
>   - dma_unmap_page_attrs() frees the IOVA from the given dma_addr_t
>   
> If we think about P2P now:
>
>   - dma_map_page_attrs() can inspect the struct page and determine it
>     is P2P. It computes a bus address which is not an IOVA, and does
>     not transit through the IOMMU. No IOVA allocation is performed. the
>     bus address is returned as the dma_addr_t
>
>   - dma_unmap_page_attrs() ... is impossible. We just get this
>     dma_addr_t that doesn't have enough information to tell anymore if
>     the address is a P2P bus address or not, so we can't tell if we
>     should unmap an iova from the dma_addr_t :\
>
> The sg path fixes this because it introduced a new flag in the
> scatterlist, SG_DMA_BUS_ADDRESS, that allows the sg map path to record
> the information for the unmap path so it can do the right thing.
>
> Leon's approach fixes this by putting an overarching transaction state
> around the DMA operation so that map and unmap operations can look in
> the state and determine if this is a P2P or non P2P map and then know
> how to unmap.
>
> For some background here, Christoph gave me this idea back at LSF/MM
> in Vancouver (two years ago now). At the time I was looking at
> replacing scatterlist and giving new DMA API ops to operate on a
> "scatterlist v2" structure.
>
> Christoph's vision was to make a performance DMA API path that could
> be used to implement any scatterlist-like data structure very
> efficiently without having to teach the DMA API about all sorts of
> scatterlist-like things.

Thanks for explaining one more motivation behind this patchset!

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


