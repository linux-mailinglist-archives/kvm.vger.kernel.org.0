Return-Path: <kvm+bounces-62585-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C1A88C493BC
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 21:29:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EFE8C1890382
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 20:29:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 230B22EDD6B;
	Mon, 10 Nov 2025 20:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VDR5NR5O"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22DE72ECD06;
	Mon, 10 Nov 2025 20:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762806530; cv=none; b=ub1kiYY4ZnYTgbvXf3vrvERj8H6wKAJFEhRQF3wY1kl/5Z0nsT8iF76BPzh28kEH+hl75zRMnEq64uuIHs1qNQQCY/Etlze9DC5ZeVN5k5d6yuvbytfwTzh91+i64icw4k2mbY/JRJvAlViOjJ8H3sdpX77suXrL42jm8Ng6AFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762806530; c=relaxed/simple;
	bh=2+oC81xV69bAibilHvu376ufSMAg5fmIkqZozg3DinU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oAXHIT2DqcO73d5W82hEw8U36joel0ehcpbzVEgB9xDRRmazyoo841QIkq1sTq+dMGwL4/DiyVOVomALA/4iYoa/SygrxYTlxwiq48uRGeSvNb/EXot88o/zn97VQ1GmKIPRwGF+mXyvulle47sWADnXPPxKgV76O+5RpFz6olY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VDR5NR5O; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DA4BC4CEF5;
	Mon, 10 Nov 2025 20:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762806529;
	bh=2+oC81xV69bAibilHvu376ufSMAg5fmIkqZozg3DinU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VDR5NR5O4p008RBxKau1oQ/sdWlbk31f0gH7CibVBxI2O26euYYItPd8xW5SsGwIf
	 BfyOjN/ef0UL06UM/C3cMVem79iIrZmXWSv4wZWSr2v3hzmZyhdVYJRiHc/Nu+yUF8
	 9iJeGQkgVYsrKA6/OXuRxy7pcx+XJQss+JBluppHjEB+L9jVPGPmZJuPlciZKxqZf+
	 xzXvLVrHLoFaUWXdO8cGN0TSE8B1fAo4BssyPzeiffuWrvNmUc8/Mgm/FjLgoQgQmp
	 E2+9VRHkM50gbCUNPShVcuzSzC5GNOuXLH1k7FYvnVqO5UUwveUcH1RL6Qm3MYu/Hn
	 zaEFUM0yu5v3w==
Date: Mon, 10 Nov 2025 22:28:44 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Alex Williamson <alex@shazbot.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Krishnakant Jaju <kjaju@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, iommu@lists.linux.dev,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, kvm@vger.kernel.org,
	linux-hardening@vger.kernel.org, Alex Mastro <amastro@fb.com>,
	Nicolin Chen <nicolinc@nvidia.com>
Subject: Re: [PATCH v7 11/11] vfio/nvgrace: Support get_dmabuf_phys
Message-ID: <20251110202844.GL15456@unreal>
References: <20251106-dmabuf-vfio-v7-0-2503bf390699@nvidia.com>
 <20251106-dmabuf-vfio-v7-11-2503bf390699@nvidia.com>
 <20251110130534.4d4b17ad.alex@shazbot.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251110130534.4d4b17ad.alex@shazbot.org>

On Mon, Nov 10, 2025 at 01:05:34PM -0700, Alex Williamson wrote:
> On Thu,  6 Nov 2025 16:16:56 +0200
> Leon Romanovsky <leon@kernel.org> wrote:
> 
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > 
> > Call vfio_pci_core_fill_phys_vec() with the proper physical ranges for the
> > synthetic BAR 2 and BAR 4 regions. Otherwise use the normal flow based on
> > the PCI bar.
> > 
> > This demonstrates a DMABUF that follows the region info report to only
> > allow mapping parts of the region that are mmapable. Since the BAR is
> > power of two sized and the "CXL" region is just page aligned the there can
> > be a padding region at the end that is not mmaped or passed into the
> > DMABUF.
> > 
> > The "CXL" ranges that are remapped into BAR 2 and BAR 4 areas are not PCI
> > MMIO, they actually run over the CXL-like coherent interconnect and for
> > the purposes of DMA behave identically to DRAM. We don't try to model this
> > distinction between true PCI BAR memory that takes a real PCI path and the
> > "CXL" memory that takes a different path in the p2p framework for now.
> > 
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > Tested-by: Alex Mastro <amastro@fb.com>
> > Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  drivers/vfio/pci/nvgrace-gpu/main.c | 56 +++++++++++++++++++++++++++++++++++++
> >  1 file changed, 56 insertions(+)
> > 
> > diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
> > index e346392b72f6..7d7ab2c84018 100644
> > --- a/drivers/vfio/pci/nvgrace-gpu/main.c
> > +++ b/drivers/vfio/pci/nvgrace-gpu/main.c
> > @@ -7,6 +7,7 @@
> >  #include <linux/vfio_pci_core.h>
> >  #include <linux/delay.h>
> >  #include <linux/jiffies.h>
> > +#include <linux/pci-p2pdma.h>
> >  
> >  /*
> >   * The device memory usable to the workloads running in the VM is cached
> > @@ -683,6 +684,54 @@ nvgrace_gpu_write(struct vfio_device *core_vdev,
> >  	return vfio_pci_core_write(core_vdev, buf, count, ppos);
> >  }
> >  
> > +static int nvgrace_get_dmabuf_phys(struct vfio_pci_core_device *core_vdev,
> > +				   struct p2pdma_provider **provider,
> > +				   unsigned int region_index,
> > +				   struct dma_buf_phys_vec *phys_vec,
> > +				   struct vfio_region_dma_range *dma_ranges,
> > +				   size_t nr_ranges)
> > +{
> > +	struct nvgrace_gpu_pci_core_device *nvdev = container_of(
> > +		core_vdev, struct nvgrace_gpu_pci_core_device, core_device);
> > +	struct pci_dev *pdev = core_vdev->pdev;
> > +
> > +	if (nvdev->resmem.memlength && region_index == RESMEM_REGION_INDEX) {
> > +		/*
> > +		 * The P2P properties of the non-BAR memory is the same as the
> > +		 * BAR memory, so just use the provider for index 0. Someday
> > +		 * when CXL gets P2P support we could create CXLish providers
> > +		 * for the non-BAR memory.
> > +		 */
> > +		*provider = pcim_p2pdma_provider(pdev, 0);
> > +		if (!*provider)
> > +			return -EINVAL;
> > +		return vfio_pci_core_fill_phys_vec(phys_vec, dma_ranges,
> > +						   nr_ranges,
> > +						   nvdev->resmem.memphys,
> > +						   nvdev->resmem.memlength);
> > +	} else if (region_index == USEMEM_REGION_INDEX) {
> > +		/*
> > +		 * This is actually cachable memory and isn't treated as P2P in
> > +		 * the chip. For now we have no way to push cachable memory
> > +		 * through everything and the Grace HW doesn't care what caching
> > +		 * attribute is programmed into the SMMU. So use BAR 0.
> > +		 */
> > +		*provider = pcim_p2pdma_provider(pdev, 0);
> > +		if (!*provider)
> > +			return -EINVAL;
> > +		return vfio_pci_core_fill_phys_vec(phys_vec, dma_ranges,
> > +						   nr_ranges,
> > +						   nvdev->usemem.memphys,
> > +						   nvdev->usemem.memlength);
> > +	}
> > +	return vfio_pci_core_get_dmabuf_phys(core_vdev, provider, region_index,
> > +					     phys_vec, dma_ranges, nr_ranges);
> > +}
> 
> 
> Unless my eyes deceive, we could reduce the redundancy a bit:
> 
> 	struct mem_region *mem_region = NULL;
> 
> 	if (nvdev->resmem.memlength && region_index == RESMEM_REGION_INDEX) {
> 		/*
> 		 * The P2P properties of the non-BAR memory is the same as the
> 		 * BAR memory, so just use the provider for index 0. Someday
> 		 * when CXL gets P2P support we could create CXLish providers
> 		 * for the non-BAR memory.
> 		 */
> 		mem_region = &nvdev->resmem;
> 	} else if (region_index == USEMEM_REGION_INDEX) {
> 		/*
> 		 * This is actually cachable memory and isn't treated as P2P in
> 		 * the chip. For now we have no way to push cachable memory
> 		 * through everything and the Grace HW doesn't care what caching
> 		 * attribute is programmed into the SMMU. So use BAR 0.
> 		 */
> 		mem_region = &nvdev->usemem;
> 	}
> 
> 	if (mem_region) {
> 		*provider = pcim_p2pdma_provider(pdev, 0);
> 		if (!*provider)
> 			return -EINVAL;
> 		return vfio_pci_core_fill_phys_vec(phys_vec, dma_ranges,
> 						   nr_ranges,
> 						   mem_region->memphys,
> 						   mem_region->memlength);
> 	}
> 
> 	return vfio_pci_core_get_dmabuf_phys(core_vdev, provider, region_index,
> 					     phys_vec, dma_ranges, nr_ranges);

Yes, this will work too.

Thanks

> 		
> Thanks,
> Alex

