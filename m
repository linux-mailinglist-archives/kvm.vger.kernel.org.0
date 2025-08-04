Return-Path: <kvm+bounces-53927-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E3565B1A5FE
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 17:30:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C9DF718A44D2
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 15:29:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60152274651;
	Mon,  4 Aug 2025 15:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G8aHgZEn"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 625E721D3D4;
	Mon,  4 Aug 2025 15:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754321184; cv=none; b=WhcUTgjgQyRNuAbroy6GmTa4ygYT9WGIWwMROzZGO8jR/eSR0m3zLDmc7b7DAmFGs9poUOdB+t+LRhLca0WMbiWvMMvhY+NvaQs+LhH8pHydOPrmLGb/Bcrh7dGzMOeDKnMcsFaBg5EHYrL6ArygNf3dmO8KwrANE98ICsxIigE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754321184; c=relaxed/simple;
	bh=A7QWfqthNAE1vRjDCcZdbOxk67HAqqSO9Vh3esAKykw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bR2qKV8aTfiHKarR4h/eCJwFQ1JDq9andM7qLGlwga2fQDBpNX711bv3BdQqlyb4lx9eK82LceyHe1wYRRJNac0M1PHQafaV4t8NrZBJtu1B8unwuOkrERJZM0cHT+3v4ZQrfmKBKlDhfuy6Ywgs2imP0IQxnalxkXqVItVdebs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G8aHgZEn; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28538C4CEE7;
	Mon,  4 Aug 2025 15:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754321183;
	bh=A7QWfqthNAE1vRjDCcZdbOxk67HAqqSO9Vh3esAKykw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=G8aHgZEnu5iXvCP7Bs5tuWefE4ftgA8h8Cjl85Cwm5By9LieCOsjVqy3AdZGS2J2M
	 gWpzl+6EFBw/RcBqC5KpnG1ipGUhJpU+Zji4nx/hTyt4NrdEsiC2Yz2U1Wkzd/Ib2a
	 QqAw4VBqd0cclEUaixH0rs/7nLDQeEd4unvRQYUSQURTz7+jVwS/zV9otrzj3jp79N
	 yUvnvgyE3xRQ4zHvh0Mw/ECgF8Le7V8q2qdcMJT+F/84f2NxFe4MykBa4PKbCdIa1S
	 PCz7RUMVTUjwcVuJgGK+jMXUeWg1UaBDlwSS3wIOPEFwlaX7GvD5jEG30YanErScjg
	 iRFzDP1lYO0Lg==
Date: Mon, 4 Aug 2025 18:26:18 +0300
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
Subject: Re: [PATCH v1 10/10] vfio/pci: Add dma-buf export support for MMIO
 regions
Message-ID: <20250804152618.GU402218@unreal>
References: <cover.1754311439.git.leon@kernel.org>
 <5e043d8b95627441db6156e7f15e6e1658e9d537.1754311439.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e043d8b95627441db6156e7f15e6e1658e9d537.1754311439.git.leon@kernel.org>

On Mon, Aug 04, 2025 at 04:00:45PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Add support for exporting PCI device MMIO regions through dma-buf,
> enabling safe sharing of non-struct page memory with controlled
> lifetime management. This allows RDMA and other subsystems to import
> dma-buf FDs and build them into memory regions for PCI P2P operations.
> 
> The implementation provides a revocable attachment mechanism using
> dma-buf move operations. MMIO regions are normally pinned as BARs
> don't change physical addresses, but access is revoked when the VFIO
> device is closed or a PCI reset is issued. This ensures kernel
> self-defense against potentially hostile userspace.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/vfio/pci/Kconfig           |  20 ++
>  drivers/vfio/pci/Makefile          |   2 +
>  drivers/vfio/pci/vfio_pci_config.c |  22 +-
>  drivers/vfio/pci/vfio_pci_core.c   |  25 +-
>  drivers/vfio/pci/vfio_pci_dmabuf.c | 390 +++++++++++++++++++++++++++++
>  drivers/vfio/pci/vfio_pci_priv.h   |  23 ++
>  include/linux/dma-buf.h            |   1 +
>  include/linux/vfio_pci_core.h      |   3 +
>  include/uapi/linux/vfio.h          |  25 ++
>  9 files changed, 506 insertions(+), 5 deletions(-)
>  create mode 100644 drivers/vfio/pci/vfio_pci_dmabuf.c

<...>

> diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
> index d58e329ac0e71..f14b413aae48d 100644
> --- a/include/linux/dma-buf.h
> +++ b/include/linux/dma-buf.h
> @@ -483,6 +483,7 @@ struct dma_buf_attach_ops {
>   * @dev: device attached to the buffer.
>   * @node: list of dma_buf_attachment, protected by dma_resv lock of the dmabuf.
>   * @peer2peer: true if the importer can handle peer resources without pages.
> + * #state: DMA structure to provide support for physical addresses DMA interface

This is rebase error, there is no need in this hunk.

Thanks

