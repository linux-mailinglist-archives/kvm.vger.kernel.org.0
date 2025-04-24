Return-Path: <kvm+bounces-44092-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BF5E0A9A4FB
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 09:55:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8C4BF3A5AAF
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 07:55:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BFA71F7075;
	Thu, 24 Apr 2025 07:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NosDI+x4"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53A0919CC3A;
	Thu, 24 Apr 2025 07:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745481338; cv=none; b=GNvhKm/6lITibq13hcBah+vuUrRE6Q4jBrHfzgyho4Ug72TIGYslbwHMIdrzG38DUuYRJWeSgi4ADN2caJyT/k29UKmlnrrXaB+X/89WtCk3ua84xyWPWNhebPIZwbaQS5gTDO3aLULUYP8BkSKYglCbAM/iUH+DhmoNLR2cHz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745481338; c=relaxed/simple;
	bh=eZB03wlWn20hlMjq44G4y2WHS0oF7M3JiBoS6ve+Nmc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t/Q519Efp2IMchBNsD9fdrZ8z+DLDR3ORuW50ZfVXxUhWriY9b5r1BJnFrB7ss/G7y9rjkPaDt4GiURleQF4zdhUF4cjFSVexElqUAgSaO8XDu94DFO6Zu1Y2OLgvW5bCqwfDtJ7Y1Ba8NXV8fHIcpCdZPQSsZL0YOQdQweHspg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NosDI+x4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7605C4CEE3;
	Thu, 24 Apr 2025 07:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745481337;
	bh=eZB03wlWn20hlMjq44G4y2WHS0oF7M3JiBoS6ve+Nmc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NosDI+x4cvbYgNU24M08GNHc6d7pJ4hl5/qxuZCxf+xwL2RBZRrJJUhOnFprAFHAp
	 uMXuNxDsAPF8h8GL3TMV0/p3zy00XpDJUj1Mc5rlsuJvcv+Nh4bTlPohNQGuUY4EuN
	 YdeQRGTfUzW8sL2ypAalBBGrL4iwWbiNeslamejqORQdHrhgX8L3E8sStLGQsqijej
	 pyQJVsd0fCj3iAMLYy/oXTlGqfTe/wKosof0Q4BTawzUGoCVJidUnxK+0FFEnz2fZ7
	 9cHCcUgloCY9p7vNTJA50fE41QpG2My1P6zfNwh4v++zjtZTJG0F4JLP9YIeCN29iU
	 73C7zFzzL2JzQ==
Date: Thu, 24 Apr 2025 10:55:32 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>, Jake Edge <jake@lwn.net>,
	Jonathan Corbet <corbet@lwn.net>, Zhu Yanjun <zyjzyj2000@gmail.com>,
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
	Chaitanya Kulkarni <kch@nvidia.com>
Subject: Re: [PATCH v9 17/24] vfio/mlx5: Enable the DMA link API
Message-ID: <20250424075532.GO48485@unreal>
References: <cover.1745394536.git.leon@kernel.org>
 <b7a11f0e93a4b244523e07b82475a7616ba739c9.1745394536.git.leon@kernel.org>
 <20250423180941.GS1213339@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250423180941.GS1213339@ziepe.ca>

On Wed, Apr 23, 2025 at 03:09:41PM -0300, Jason Gunthorpe wrote:
> On Wed, Apr 23, 2025 at 11:13:08AM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Remove intermediate scatter-gather table completely and
> > enable new DMA link API.
> > 
> > Tested-by: Jens Axboe <axboe@kernel.dk>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  drivers/vfio/pci/mlx5/cmd.c  | 298 ++++++++++++++++-------------------
> >  drivers/vfio/pci/mlx5/cmd.h  |  21 ++-
> >  drivers/vfio/pci/mlx5/main.c |  31 ----
> >  3 files changed, 147 insertions(+), 203 deletions(-)
> 
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> 
> > +static int register_dma_pages(struct mlx5_core_dev *mdev, u32 npages,
> > +			      struct page **page_list, u32 *mkey_in,
> > +			      struct dma_iova_state *state,
> > +			      enum dma_data_direction dir)
> > +{
> > +	dma_addr_t addr;
> > +	size_t mapped = 0;
> > +	__be64 *mtt;
> > +	int i, err;
> >  
> > -	return mlx5_core_create_mkey(mdev, mkey, mkey_in, inlen);
> > +	WARN_ON_ONCE(dir == DMA_NONE);
> > +
> > +	mtt = (__be64 *)MLX5_ADDR_OF(create_mkey_in, mkey_in, klm_pas_mtt);
> > +
> > +	if (dma_iova_try_alloc(mdev->device, state, 0, npages * PAGE_SIZE)) {
> > +		addr = state->addr;
> > +		for (i = 0; i < npages; i++) {
> > +			err = dma_iova_link(mdev->device, state,
> > +					    page_to_phys(page_list[i]), mapped,
> > +					    PAGE_SIZE, dir, 0);
> > +			if (err)
> > +				goto error;
> > +			*mtt++ = cpu_to_be64(addr);
> > +			addr += PAGE_SIZE;
> > +			mapped += PAGE_SIZE;
> > +		}
> 
> This is an area I'd like to see improvement on as a follow up.
> 
> Given we know we are allocating contiguous IOVA we should be able to
> request a certain alignment so we can know that it can be put into the
> mkey as single mtt. That would eliminate the double translation cost in
> the HW.
> 
> The RDMA mkey builder is able to do this from the scatterlist but the
> logic to do that was too complex to copy into vfio. This is close to
> being simple enough, just the alignment is the only problem.

I saw this improvement as well, but there is a need to generalize this 
"if (dma_iova_try_alloc) ... else ..." code first, as it will be used
by all vfio HW drivers.

So the plan is:
1. Merge the code as is.
2. Convert second vfio HW to the new API.
3. Propose something like dma_map_pages(..., struct page **page_list, ...)
   to map array of pages.
4. Optimize mlx5 vfio MTT creation.

Thanks

> 
> Jason
> 

