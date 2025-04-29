Return-Path: <kvm+bounces-44687-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D089FAA0296
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 08:10:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ECB301B6378E
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 06:10:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44CEE2750FC;
	Tue, 29 Apr 2025 06:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uDWNet5k"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ABC62749C5;
	Tue, 29 Apr 2025 06:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745906964; cv=none; b=GMXQNt49RYwLCxCqIojbucNTRWZCxiYh7NfGTQYCbNLjC9Wmd/B9WCxRNMPcgyp7MoCUB5QxIyn0M6nx2Xi9dkjbj/D0oL2cYhEHr2Z/7eGRKfD9fTiX3sf/8KPh9JcV7ytLt1g0ztv3uR49RGXx58z/JulBkO+Wk0Hcga69R+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745906964; c=relaxed/simple;
	bh=PNH//cVkWbnB2fS1ezNe4WtvGXzhnSIV29jcs1sTleU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LC4Y9G9XatJ7cZNVmDIxZjM+RNMgb1Wdr4JOc7Wyd9snxmD7kbJaqsjyFMepN95YFmTiIgsZRsCoVx8xqdNxn5+rSP38hXLhhEpY4BMAQEMOT90SH81huMGNXtf6KSsHWS0Ewa6ea+LqJvm3vC5Y+ydJq9EObC5zZU68NM4XA+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uDWNet5k; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B524AC4CEE3;
	Tue, 29 Apr 2025 06:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745906963;
	bh=PNH//cVkWbnB2fS1ezNe4WtvGXzhnSIV29jcs1sTleU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uDWNet5k2IklSXyclsdy71tc6aXagAuOzOP5Z1vsPDPEw1xByvYmxH/7R8kedffmR
	 K3ASHl60pRtDMWg9p0JxFzxO/3aGKB98mGU3GQziALdCRkObg3CMNM8boWhkMNq5Fb
	 SoRi+onUpbh4+8C7egZp68jWH9bVq8JE2GNbbjKqgOv4PvtvgZAdPdF4XvW8+i2Vac
	 6q6ESVLxxn8p2qJcdlZLSSecESrOtQeA31phlOs3O0ew9tbbYj38i+QlIYTLHGum0F
	 nK+XngMnFMQRY8/5XFAQ7Xguljv3BaQDuFiBtITTOynS0B/PtXC5n3GH/3WSmM3hcr
	 NiVEF7HYK25Ng==
Date: Tue, 29 Apr 2025 09:09:18 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Baolu Lu <baolu.lu@linux.intel.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>, Jake Edge <jake@lwn.net>,
	Jonathan Corbet <corbet@lwn.net>, Jason Gunthorpe <jgg@ziepe.ca>,
	Zhu Yanjun <zyjzyj2000@gmail.com>,
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
	Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH v10 03/24] iommu: generalize the batched sync after map
 interface
Message-ID: <20250429060918.GK5848@unreal>
References: <cover.1745831017.git.leon@kernel.org>
 <69da19d2cc5df0be5112f0cf2365a0337b00d873.1745831017.git.leon@kernel.org>
 <f8d86cde-d485-4e5a-a693-e9323679474f@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f8d86cde-d485-4e5a-a693-e9323679474f@linux.intel.com>

On Tue, Apr 29, 2025 at 10:19:46AM +0800, Baolu Lu wrote:
> On 4/28/25 17:22, Leon Romanovsky wrote:
> > From: Christoph Hellwig<hch@lst.de>
> > 
> > For the upcoming IOVA-based DMA API we want to batch the
> > ops->iotlb_sync_map() call after mapping multiple IOVAs from
> > dma-iommu without having a scatterlist. Improve the API.
> > 
> > Add a wrapper for the map_sync as iommu_sync_map() so that callers
> > don't need to poke into the methods directly.
> > 
> > Formalize __iommu_map() into iommu_map_nosync() which requires the
> > caller to call iommu_sync_map() after all maps are completed.
> > 
> > Refactor the existing sanity checks from all the different layers
> > into iommu_map_nosync().
> > 
> > Signed-off-by: Christoph Hellwig<hch@lst.de>
> > Acked-by: Will Deacon<will@kernel.org>
> > Tested-by: Jens Axboe<axboe@kernel.dk>
> > Reviewed-by: Jason Gunthorpe<jgg@nvidia.com>
> > Reviewed-by: Luis Chamberlain<mcgrof@kernel.org>
> > Signed-off-by: Leon Romanovsky<leonro@nvidia.com>
> > ---
> >   drivers/iommu/iommu.c | 65 +++++++++++++++++++------------------------
> >   include/linux/iommu.h |  4 +++
> >   2 files changed, 33 insertions(+), 36 deletions(-)
> > 
> > diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> > index 4f91a740c15f..02960585b8d4 100644
> > --- a/drivers/iommu/iommu.c
> > +++ b/drivers/iommu/iommu.c
> > @@ -2443,8 +2443,8 @@ static size_t iommu_pgsize(struct iommu_domain *domain, unsigned long iova,
> >   	return pgsize;
> >   }
> > -static int __iommu_map(struct iommu_domain *domain, unsigned long iova,
> > -		       phys_addr_t paddr, size_t size, int prot, gfp_t gfp)
> > +int iommu_map_nosync(struct iommu_domain *domain, unsigned long iova,
> > +		phys_addr_t paddr, size_t size, int prot, gfp_t gfp)
> >   {
> >   	const struct iommu_domain_ops *ops = domain->ops;
> >   	unsigned long orig_iova = iova;
> > @@ -2453,12 +2453,19 @@ static int __iommu_map(struct iommu_domain *domain, unsigned long iova,
> >   	phys_addr_t orig_paddr = paddr;
> >   	int ret = 0;
> > +	might_sleep_if(gfpflags_allow_blocking(gfp));
> > +
> >   	if (unlikely(!(domain->type & __IOMMU_DOMAIN_PAGING)))
> >   		return -EINVAL;
> >   	if (WARN_ON(!ops->map_pages || domain->pgsize_bitmap == 0UL))
> >   		return -ENODEV;
> > +	/* Discourage passing strange GFP flags */
> > +	if (WARN_ON_ONCE(gfp & (__GFP_COMP | __GFP_DMA | __GFP_DMA32 |
> > +				__GFP_HIGHMEM)))
> > +		return -EINVAL;
> > +
> >   	/* find out the minimum page size supported */
> >   	min_pagesz = 1 << __ffs(domain->pgsize_bitmap);
> > @@ -2506,31 +2513,27 @@ static int __iommu_map(struct iommu_domain *domain, unsigned long iova,
> >   	return ret;
> >   }
> > -int iommu_map(struct iommu_domain *domain, unsigned long iova,
> > -	      phys_addr_t paddr, size_t size, int prot, gfp_t gfp)
> > +int iommu_sync_map(struct iommu_domain *domain, unsigned long iova, size_t size)
> >   {
> >   	const struct iommu_domain_ops *ops = domain->ops;
> > -	int ret;
> > -
> > -	might_sleep_if(gfpflags_allow_blocking(gfp));
> > -	/* Discourage passing strange GFP flags */
> > -	if (WARN_ON_ONCE(gfp & (__GFP_COMP | __GFP_DMA | __GFP_DMA32 |
> > -				__GFP_HIGHMEM)))
> > -		return -EINVAL;
> > +	if (!ops->iotlb_sync_map)
> > +		return 0;
> > +	return ops->iotlb_sync_map(domain, iova, size);
> > +}
> 
> I am wondering whether iommu_sync_map() needs a return value. The
> purpose of this callback is just to sync the TLB cache after new
> mappings are created, which should effectively be a no-fail operation.
> 
> The definition of iotlb_sync_map in struct iommu_domain_ops seems
> unnecessary:
> 
> struct iommu_domain_ops {
> ...
>         int (*iotlb_sync_map)(struct iommu_domain *domain, unsigned long
> iova,
>                               size_t size);
> ...
> };
> 
> Furthermore, currently no iommu driver implements this callback in a way
> that returns a failure. We could clean up the iommu definition in a
> subsequent patch series, but for this driver-facing interface, it's
> better to get it right from the beginning.

I see that s390 is relying on return values:

  569 static int s390_iommu_iotlb_sync_map(struct iommu_domain *domain,
  570                                      unsigned long iova, size_t size)
  571 {

<...>

  581                 ret = zpci_refresh_trans((u64)zdev->fh << 32,
  582                                          iova, size);
  583                 /*
  584                  * let the hypervisor discover invalidated entries
  585                  * allowing it to free IOVAs and unpin pages
  586                  */
  587                 if (ret == -ENOMEM) {
  588                         ret = zpci_refresh_all(zdev);
  589                         if (ret)
  590                                 break;
  591                 }

<...>

  595         return ret;
  596 }

> 
> Thanks,
> baolu

