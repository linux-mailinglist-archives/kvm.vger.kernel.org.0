Return-Path: <kvm+bounces-43984-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BE08A99618
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 19:11:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 34C775A26CB
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 17:11:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A43C28B4FC;
	Wed, 23 Apr 2025 17:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WKE+8APY"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C88933F9;
	Wed, 23 Apr 2025 17:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745428274; cv=none; b=rYPo5kWz3cGBX72Fdqjhtoca6WswVBUGq7yaSYTVGy5neLTx+6TWvTuDaNmvSw+UlkmKmUxl0LFbTV96WiGuqk0fn70KexPGia08WwDL14ljUf8tVHExe1mh+oOfoc43s73e3CHIB/Ia7jHzipMCa7Sg6/dqDt8x7IumUWam9HA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745428274; c=relaxed/simple;
	bh=wm5GF1+5ZhFui3p0uI/jDDATw03CDOZZzdN2e7V0TSU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BF5nzJ19mU3qXvupTsq4MR2rPkzVPLmtbiL9gvtVbKMMfyq9DghZHwhWNcvwXeLkG5goXzPEqE7Bi5ulcJdb/FuoDXEiMJpo+Nm0y4hIyMrkGSREKt0zCrIO/kbOnOJSEeiAOnY2EbcejCCYbaqi4+LJJ6+0BrjBM70qhajPcnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WKE+8APY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEA7BC4CEE2;
	Wed, 23 Apr 2025 17:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745428273;
	bh=wm5GF1+5ZhFui3p0uI/jDDATw03CDOZZzdN2e7V0TSU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WKE+8APYL7laFptOx5V5tlTW6vx8OhdD2WZd+VGxrXtV67FrKncs+kqu+pF5u2EGG
	 UOokgA7a2oH+932TcBKZF7az+Ped9NzAHFBaGnehVleJXvWIBUCJeL1sQ2Qmw7D00x
	 t3RQhR9MeIT9X6K4x10h4rIx8fAT5Xzfh4DWU3ruajS1BQDApG5h93OllIWbkN2aId
	 wdKj+YjyrKbqPlk1S3NqyKmfDMZw+PqaheehQ4VEM2e62rg2kfh4ZmgP8NXJJpagND
	 oUgY6vbnwDC/BH3tlAmiFa7bG+aa9E3K6tCMbaiT1v0F8o94QDy3SA0813/IgeDR3G
	 KIYJwJTivuM1w==
Date: Wed, 23 Apr 2025 20:11:08 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Keith Busch <kbusch@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
	Jake Edge <jake@lwn.net>, Jonathan Corbet <corbet@lwn.net>,
	Jason Gunthorpe <jgg@ziepe.ca>, Zhu Yanjun <zyjzyj2000@gmail.com>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev, linux-nvme@lists.infradead.org,
	linux-pci@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Nitesh Shetty <nj.shetty@samsung.com>
Subject: Re: [PATCH v9 23/24] nvme-pci: convert to blk_rq_dma_map
Message-ID: <20250423171108.GK48485@unreal>
References: <cover.1745394536.git.leon@kernel.org>
 <7c5c5267cba2c03f6650444d4879ba0d13004584.1745394536.git.leon@kernel.org>
 <aAkAKyr4fbd5sLCH@kbusch-mbp.dhcp.thefacebook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aAkAKyr4fbd5sLCH@kbusch-mbp.dhcp.thefacebook.com>

On Wed, Apr 23, 2025 at 08:58:51AM -0600, Keith Busch wrote:
> On Wed, Apr 23, 2025 at 11:13:14AM +0300, Leon Romanovsky wrote:
> > +static bool nvme_try_setup_sgl_simple(struct nvme_dev *dev, struct request *req,
> > +				      struct nvme_rw_command *cmnd,
> > +				      struct blk_dma_iter *iter)
> > +{
> > +	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
> > +	struct bio_vec bv = req_bvec(req);
> > +
> > +	if (IS_ENABLED(CONFIG_PCI_P2PDMA) && (req->cmd_flags & REQ_P2PDMA))
> > +		return false;
> > +
> > +	if ((bv.bv_offset & (NVME_CTRL_PAGE_SIZE - 1)) + bv.bv_len >
> > +			NVME_CTRL_PAGE_SIZE * 2)
> > +		return false;
> 
> We don't need this check for SGLs. If we have a single segment, we can
> put it in a single SG element no matter how large it is.

Absolutely, removed it and updated my dma-split-wip branch.

Thanks

