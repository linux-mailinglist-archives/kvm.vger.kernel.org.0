Return-Path: <kvm+bounces-56596-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 602CDB401E1
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 15:04:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 06DB917A750
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 13:00:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18BB5301030;
	Tue,  2 Sep 2025 12:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y03rLipQ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D88828489B;
	Tue,  2 Sep 2025 12:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756817910; cv=none; b=qzloxYGUmMiiHaYeaJWNsu3ig1Ec05oigsIzgADFeb+jBUBKhQD/Zgf6mBhvXjmSpbHQeXp/h9VGru29rS+LbIHdurnftT1c3ihzcJuxOVASvvFckN53SFOzcmF7DyafjdP0Yb+nCNsxgLIMdX4UH9iPybw4M3aQeMHT16+Xgsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756817910; c=relaxed/simple;
	bh=CM1gzdTND9tJKwW5aJTGTYza7PZbOeFeI+0kiHDsfk0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mcxhFpLkqdxbffnSe2+k6Rp/RjCmb7g6RBpsBnlaZPlQUvoNuHoeK7CdIxosVt6a1j+LF6mV/UWTJ6s4dQnfihXzBQmZwIPcWrST1Txq2wWSk9JR8gU8ZXtzMuY5NENTFxgyvSpyfER4Ieb3HPjKhQTY3wsBZjkMCOZ0xruwyJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y03rLipQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08555C4CEED;
	Tue,  2 Sep 2025 12:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756817909;
	bh=CM1gzdTND9tJKwW5aJTGTYza7PZbOeFeI+0kiHDsfk0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y03rLipQ172HNCWdzae1SvWeUKEZCuyy4iT/sxqmRUG2Mk9XAm0JD2Cf43Q4ccXI4
	 vJ3zCW+7bhV2I/8W3AQ/zj+cPA9rZhBtVccOf2Syvu2xP3GZZOcRUzTwD1l9Dszm61
	 coTmrjtssASLghJ0YobZBbn3b5yvo1gmHUuMYKl3N+eOUDvW9dLkEd42uz6ExoscbL
	 AN9nGwSWGJAg2aXnrk/T8mIOnh8SJFTLZoRnFwoAw9p/ZVbj1um54ETkG1UmVJ0yaX
	 k1mi0ufFXvprbr0GmTrnZJZPMNtSonfXc/UWWvtDhkzWmzN/ZJ+J57M3aRwqpyvkrT
	 ePb8jIU/SceyA==
Date: Tue, 2 Sep 2025 15:58:24 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Christoph Hellwig <hch@lst.de>, dri-devel@lists.freedesktop.org,
	iommu@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
	Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	Logan Gunthorpe <logang@deltatee.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v1 08/10] vfio/pci: Enable peer-to-peer DMA transactions
 by default
Message-ID: <20250902125824.GH10073@unreal>
References: <cover.1754311439.git.leon@kernel.org>
 <edb2ec654fc27ba8f73695382ab0a029f18422b5.1754311439.git.leon@kernel.org>
 <20250806160201.2b72e7a0.alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250806160201.2b72e7a0.alex.williamson@redhat.com>

On Wed, Aug 06, 2025 at 04:02:01PM -0600, Alex Williamson wrote:
> On Mon,  4 Aug 2025 16:00:43 +0300
> Leon Romanovsky <leon@kernel.org> wrote:
> 
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Make sure that all VFIO PCI devices have peer-to-peer capabilities
> > enables, so we would be able to export their MMIO memory through DMABUF,
> > 
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  drivers/vfio/pci/vfio_pci_core.c | 4 ++++
> >  include/linux/vfio_pci_core.h    | 1 +
> >  2 files changed, 5 insertions(+)
> > 
> > diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> > index 31bdb9110cc0f..df9a32d3deac9 100644
> > --- a/drivers/vfio/pci/vfio_pci_core.c
> > +++ b/drivers/vfio/pci/vfio_pci_core.c
> > @@ -28,6 +28,7 @@
> >  #include <linux/nospec.h>
> >  #include <linux/sched/mm.h>
> >  #include <linux/iommufd.h>
> > +#include <linux/pci-p2pdma.h>
> >  #if IS_ENABLED(CONFIG_EEH)
> >  #include <asm/eeh.h>
> >  #endif
> > @@ -2088,6 +2089,9 @@ int vfio_pci_core_init_dev(struct vfio_device *core_vdev)
> >  	INIT_LIST_HEAD(&vdev->dummy_resources_list);
> >  	INIT_LIST_HEAD(&vdev->ioeventfds_list);
> >  	INIT_LIST_HEAD(&vdev->sriov_pfs_item);
> > +	vdev->provider = pci_p2pdma_enable(vdev->pdev);
> > +	if (IS_ERR(vdev->provider))
> > +		return PTR_ERR(vdev->provider);
> 
> I think this just made all vfio-pci drivers functionally dependent on
> CONFIG_PCI_P2PDMA.  Seems at best exporting a dma-buf should be
> restricted if this fails.  Thanks,

It is temporary solution in next patch "vfio/pci: Add dma-buf export
support for MMIO regions", the strict ifdef is added.

  2107 #ifdef CONFIG_VFIO_PCI_DMABUF
  2108         vdev->provider = pci_p2pdma_enable(vdev->pdev);
  2109         if (IS_ERR(vdev->provider))
  2110                 return PTR_ERR(vdev->provider);
  2111
  2112         INIT_LIST_HEAD(&vdev->dmabufs);
  2113 #endif

I will split "vfio/pci: Add dma-buf export ..." patch to introduce CONFIG_VFIO_PCI_DMABUF
before this "vfio/pci: Enable peer-to-peer ..." patch.

Thanks

> 
> Alex
> 
> >  	init_rwsem(&vdev->memory_lock);
> >  	xa_init(&vdev->ctx);
> >  
> > diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
> > index fbb472dd99b36..b017fae251811 100644
> > --- a/include/linux/vfio_pci_core.h
> > +++ b/include/linux/vfio_pci_core.h
> > @@ -94,6 +94,7 @@ struct vfio_pci_core_device {
> >  	struct vfio_pci_core_device	*sriov_pf_core_dev;
> >  	struct notifier_block	nb;
> >  	struct rw_semaphore	memory_lock;
> > +	struct p2pdma_provider  *provider;
> >  };
> >  
> >  /* Will be exported for vfio pci drivers usage */
> 

