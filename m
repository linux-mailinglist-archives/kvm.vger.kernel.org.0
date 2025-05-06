Return-Path: <kvm+bounces-45567-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2525DAABDF5
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 10:55:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 144DE3AF5FF
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 08:55:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6D42264A95;
	Tue,  6 May 2025 08:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="C21FMLvT"
X-Original-To: kvm@vger.kernel.org
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94CFC24C092;
	Tue,  6 May 2025 08:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746521737; cv=none; b=LwqjJoH68Tc1jq/Mh6cT5jZd1sHmcR5rLV7/qYYAfNsr6M878NeYOkGwOLQu3NrEWTTxMij5RfcIxO1Z4dUIMZfFRYYJUdtA7RBhtuJLyQ3Y6P03nS6aUD0PDS9BTNyxwTXbQiky90EtGvs6c5OoJ/gjCBPcMn28nXbPymTLJ7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746521737; c=relaxed/simple;
	bh=cMDuM3j7k5cTHN/7wO5B3vJg3iC+cUHTDsqOA5STSCA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=T2GuVZsc90OS8yY+yx4aUnj8zBLKF+G5VTCbShliRQuF2LzxSIoJTMZ8xVnJZd5+Y+/WPnuiVlAzJKY/56VZOrC+mHrO2g7NWfRAeUN5CAJhg3TBa5Ye3tCBERsfhlmZ8vJTyBjKKJdpR+13TmAnEInPTg8770S7Xj7d8sGrDfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=C21FMLvT; arc=none smtp.client-ip=210.118.77.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20250506085527euoutp015fca07206c784e5761f1f8a188abe8f5~85EHmujOw3188231882euoutp01i;
	Tue,  6 May 2025 08:55:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20250506085527euoutp015fca07206c784e5761f1f8a188abe8f5~85EHmujOw3188231882euoutp01i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1746521727;
	bh=a9nf+a3zOwcPKwqh9B0OLR/Jw+1OSvSECo9idk1FbTE=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=C21FMLvTm2rnAQxHrZ+XjlwShdIolbFmzs5OV92e64+XWXfkvyqlAqyB+SqMI8FWy
	 gzLOR6h8hKT7nwqPnqVkMOQLWo7Bynuo9GrjINMuxW5+0PVvkLxThRfZTzS3j9hgVr
	 q6wpBuza63nwFWaICKN2JQP8BsKq4m32MwuwlaaI=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20250506085526eucas1p1b3eca35ab5da96d65930d05e3de8871f~85EHQg5bx1239412394eucas1p1s;
	Tue,  6 May 2025 08:55:26 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250506085524eusmtip25604952270886300d2a204bfc62676fe~85EEuyRQL3058030580eusmtip2d;
	Tue,  6 May 2025 08:55:24 +0000 (GMT)
Message-ID: <2e89d7e2-9146-46c7-86b0-8023483e5e07@samsung.com>
Date: Tue, 6 May 2025 10:55:23 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 0/9] Provide a new two step DMA mapping API
To: Leon Romanovsky <leon@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Keith
	Busch <kbusch@kernel.org>, Jake Edge <jake@lwn.net>, Jonathan Corbet
	<corbet@lwn.net>, Jason Gunthorpe <jgg@ziepe.ca>, Zhu Yanjun
	<zyjzyj2000@gmail.com>, Robin Murphy <robin.murphy@arm.com>, Joerg Roedel
	<joro@8bytes.org>, Will Deacon <will@kernel.org>, Sagi Grimberg
	<sagi@grimberg.me>, Bjorn Helgaas <bhelgaas@google.com>, Logan Gunthorpe
	<logang@deltatee.com>, Yishai Hadas <yishaih@nvidia.com>, Shameer Kolothum
	<shameerali.kolothum.thodi@huawei.com>, Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	=?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Andrew Morton
	<akpm@linux-foundation.org>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	linux-rdma@vger.kernel.org, iommu@lists.linux.dev,
	linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org,
	kvm@vger.kernel.org, linux-mm@kvack.org, Niklas Schnelle
	<schnelle@linux.ibm.com>, Chuck Lever <chuck.lever@oracle.com>, Luis
	Chamberlain <mcgrof@kernel.org>, Matthew Wilcox <willy@infradead.org>, Dan
	Williams <dan.j.williams@intel.com>, Kanchan Joshi <joshi.k@samsung.com>,
	Chaitanya Kulkarni <kch@nvidia.com>
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <cover.1746424934.git.leon@kernel.org>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20250506085526eucas1p1b3eca35ab5da96d65930d05e3de8871f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20250505070202eucas1p19aa3caffab7176123323fe5462773c8e
X-EPHeader: CA
X-CMS-RootMailID: 20250505070202eucas1p19aa3caffab7176123323fe5462773c8e
References: <CGME20250505070202eucas1p19aa3caffab7176123323fe5462773c8e@eucas1p1.samsung.com>
	<cover.1746424934.git.leon@kernel.org>

On 05.05.2025 09:01, Leon Romanovsky wrote:
> Hi Marek,
>
> These are the DMA/IOMMU patches only, which have not seen functional
> changes for a while.  They are tested and reviewed and ready to merge.
>
> We will work with relevant subsystems to merge rest of the conversion
> patches. At least some of them will be done in next cycle to reduce
> merge conflicts.
>
> Thanks
>
> =========================================================================
> Following recent on site LSF/MM 2025 [1] discussion, the overall
> response was extremely positive with many people expressed their
> desire to see this series merged, so they can base their work on it.
>
> It includes, but not limited:
>   * Luis's "nvme-pci: breaking the 512 KiB max IO boundary":
>     https://lore.kernel.org/all/20250320111328.2841690-1-mcgrof@kernel.org/
>   * Chuck's NFS conversion to use one structure (bio_vec) for all types
>     of RPC transports:
>     https://lore.kernel.org/all/913df4b4-fc4a-409d-9007-088a3e2c8291@oracle.com
>   * Matthew's vision for the world without struct page:
>     https://lore.kernel.org/all/Z-WRQOYEvOWlI34w@casper.infradead.org/
>   * Confidential computing roadmap from Dan:
>     https://lore.kernel.org/all/6801a8e3968da_71fe29411@dwillia2-xfh.jf.intel.com.notmuch
>
> This series is combination of effort of many people who contributed ideas,
> code and testing and I'm gratefully thankful for them.


Thanks everyone involved in this contribution. I appreciate the effort 
of showing that such new API is really needed and will be used by other 
subsystems. I see benefits from this approach and I hope that any 
pending issues can be resolved incrementally.

I've applied this patchset to dma-mapping-next branch and it will be 
also available as dma-mapping-for-6.16-two-step-api [1] stable branch 
for those who wants to base their pending work on it.

[1] 
https://web.git.kernel.org/pub/scm/linux/kernel/git/mszyprowski/linux.git/log/?h=dma-mapping-for-6.16-two-step-api

> ...

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


