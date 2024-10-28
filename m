Return-Path: <kvm+bounces-29888-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CA0E9B3934
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 19:31:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 19E54281861
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 18:31:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C18D1DFD89;
	Mon, 28 Oct 2024 18:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QEmveI2N"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81DD91E48A;
	Mon, 28 Oct 2024 18:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730140288; cv=none; b=kC+C+Izf0+UtyHkAz7RXLpcFUMlzNbDpwE+p4CvjEjqjVFaT/UF8WJlspLg4hwGrSv6HmlOanvxTGAhR0xr0hha1O3mag/C0EUQJ6hUgdFq/2CePRzcI7zZ8ii8uWFWWOqtrVXDqq49I7OCjTPSAXLVcu7cKQK6AhrAPb+zrkd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730140288; c=relaxed/simple;
	bh=knJ6KgEn+HUVeZA2+uVjttGH6laUFuY55CtAHYmMtaY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vrn9l0OGa5cr0M4tNBtRG4VC9+9lujifXXAfwlTFjJvTdpUQHmzYXSNcYodbc68HXQs5FdCjV0kJW2qIbh0e5ZlB8dIMjPZoBltGBdJBSFJSP6pncKQEak6ACSjXZ9hZ0OC3hb5tVS8s4r5jm26oxhk6uGs+mP1SuB4vz3GHmlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QEmveI2N; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD61AC4CEC3;
	Mon, 28 Oct 2024 18:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730140288;
	bh=knJ6KgEn+HUVeZA2+uVjttGH6laUFuY55CtAHYmMtaY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QEmveI2NZTQJ8iB0oY/nED15Zobh8Lap9Ozk9y+25JoYHnQ/y87nbfEHvfKJTJ8Ex
	 sfPWjATkYROgOP3lU8RC5va+oGpgsEBlqrziNnUWdFDy9QJPuBQEtGgkMS4ZDGwukD
	 HALkgjvyTWxvfY+RmLi7pk4eZXuNROOLUMKiKyGsdmjv0qJF35J6VsGLjRWEChoQvS
	 i3INY+wUl2b2QhDxuL2Ya0G5XbUvzLJRJw99SXw+pzDZdqKZ4j52bQcoQZ3UGY9Ybd
	 QPfGwHv/EKf7hPKS8HZIe8cvC2khmqpcwfVdT7JN6XXNbHS2SFK78DFC6fHF1bbD1u
	 stakc0GvtjnfQ==
Date: Mon, 28 Oct 2024 20:31:21 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Baolu Lu <baolu.lu@linux.intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, Jason Gunthorpe <jgg@ziepe.ca>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	linux-rdma@vger.kernel.org, iommu@lists.linux.dev,
	linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org,
	kvm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 07/18] dma-mapping: Implement link/unlink ranges API
Message-ID: <20241028183121.GI1615717@unreal>
References: <cover.1730037276.git.leon@kernel.org>
 <b434f2f6d3c601649c9b6973a2ec3ec2149bba37.1730037276.git.leon@kernel.org>
 <6a9366a5-7c5b-449c-b259-8e2492aae2a1@linux.intel.com>
 <20241028062252.GC1615717@unreal>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241028062252.GC1615717@unreal>

On Mon, Oct 28, 2024 at 08:22:52AM +0200, Leon Romanovsky wrote:
> On Mon, Oct 28, 2024 at 10:00:25AM +0800, Baolu Lu wrote:
> > On 2024/10/27 22:21, Leon Romanovsky wrote:
> > > +/**
> > > + * dma_iova_sync - Sync IOTLB
> > > + * @dev: DMA device
> > > + * @state: IOVA state
> > > + * @offset: offset into the IOVA state to sync
> > > + * @size: size of the buffer
> > > + * @ret: return value from the last IOVA operation
> > > + *
> > > + * Sync IOTLB for the given IOVA state. This function should be called on
> > > + * the IOVA-contigous range created by one ore more dma_iova_link() calls
> > > + * to sync the IOTLB.
> > > + */
> > > +int dma_iova_sync(struct device *dev, struct dma_iova_state *state,
> > > +		size_t offset, size_t size, int ret)
> > > +{
> > > +	struct iommu_domain *domain = iommu_get_dma_domain(dev);
> > > +	struct iommu_dma_cookie *cookie = domain->iova_cookie;
> > > +	struct iova_domain *iovad = &cookie->iovad;
> > > +	dma_addr_t addr = state->addr + offset;
> > > +	size_t iova_start_pad = iova_offset(iovad, addr);
> > > +
> > > +	addr -= iova_start_pad;
> > > +	size = iova_align(iovad, size + iova_start_pad);
> > > +
> > > +	if (!ret)
> > > +		ret = iommu_sync_map(domain, addr, size);
> > > +	if (ret)
> > > +		iommu_unmap(domain, addr, size);
> > 
> > It appears strange that mapping is not done in this helper, but
> > unmapping is added in the failure path. Perhaps I overlooked anything?
> 
> Like iommu_sync_map() is performed on whole continuous range, the iommu_unmap()
> should be done on the same range. So, technically you can unmap only part of
> the range which called to dma_iova_link() and failed, but you will need
> to make sure that iommu_sync_map() is still called for "successful" part of
> iommu_map().
> 
> In that case, you will need to undo everything anyway and it means that
> you will call to iommu_unmap() on the successful part of the range
> anyway.
> 
> dma_iova_sync() is single operation for the whole range and
> iommu_unmap() too, so they are bound together.
> 
> > To my understanding, it should like below:
> > 
> > 	return iommu_sync_map(domain, addr, size);
> > 
> > In the drivers that make use of this interface should do something like
> > below:
> > 
> > 	ret = dma_iova_sync(...);
> > 	if (ret)
> > 		dma_iova_destroy(...)
> 
> It is actually what is happening in the code, but in less direct way due
> to unwinding of the code.

After more thoughts on the topic, I think that it will be better to make
this dma_iova_sync() less cryptic and more direct. I will change it to be
as below in my next version:

  1972 int dma_iova_sync(struct device *dev, struct dma_iova_state *state,
  1973                 size_t offset, size_t size)
  1974 {
  1975         struct iommu_domain *domain = iommu_get_dma_domain(dev);
  1976         struct iommu_dma_cookie *cookie = domain->iova_cookie;
  1977         struct iova_domain *iovad = &cookie->iovad;
  1978         dma_addr_t addr = state->addr + offset;
  1979         size_t iova_start_pad = iova_offset(iovad, addr);
  1980
  1981         return iommu_sync_map(domain, addr - iova_start_pad,
  1982                       iova_align(iovad, size + iova_start_pad));
  1983 }
  1984 EXPORT_SYMBOL_GPL(dma_iova_sync);

Thanks

