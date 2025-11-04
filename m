Return-Path: <kvm+bounces-61947-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F85AC2F8B3
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 08:01:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 5E5EA4F0BD4
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 07:01:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A922301014;
	Tue,  4 Nov 2025 07:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I1UEY/F8"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7307E16DEB3;
	Tue,  4 Nov 2025 07:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762239630; cv=none; b=KcZzB1PrhujXRamZ4ExMUAF5RXN3SmYQJxqpihNqmqn+Megvz1TXD/RymTLoLMqtkZag33cLy9LG9Mbfjy6Sl35hpkwFdkeScUnGXPBHDJR3OcMujrCnGZ+XNC7UR1gunq1r2/R/hca36l9ci1s5MSpN4NH6dce6EK0E8bSzVdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762239630; c=relaxed/simple;
	bh=4X+6t70DXpoh2T+5EieuiIaGNQ+Nx/11qPV6DRFYJmY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HRoUpwqjxD2l/ralGuUgK5Qnj7LTdtIVFMwJw2up3J3s2N8DYb5928OZHp4eUUSTIiHghhlcm6hN+cDaT4NPTJulUsFD5PrCQehS+9WRQz/vJDhnj33YcMFcKmFuI3W/nSZ1N0WgZJOa5LWRC7IgBJhJbtOkk74ckVEIH5Ue/lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I1UEY/F8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C40EC4CEF7;
	Tue,  4 Nov 2025 07:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762239630;
	bh=4X+6t70DXpoh2T+5EieuiIaGNQ+Nx/11qPV6DRFYJmY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=I1UEY/F8kb6rmfO1N8znpDwknPo+zoeYokqXc5isZjuBzW2kwNIyURNneL551ILHq
	 xB1qlT1GwIRyPrqploIY1BSnrb/M+gayul0auOGaYIzVZ5ipDhkzhnPwCHrtS0f6BC
	 z5t1VvB9oLCq/rFMCgCk9VhSiEJuSXID8okNRaVWmbtPOK+n28WqZyhoHpfWmronvf
	 FcGjEPq4VK6Yo+LBMfOfTVdislK0QSciIeNRcwvKA5aNqAeghvNKt/yYcDiNo2g9fQ
	 ijAwMsISbHre8xNCfIwmhQpHnPPoDWGxgBNbI3zl0/Lwh8StDazLf/AgskMUfBm9kx
	 ZlGWIVygzFi3w==
Date: Tue, 4 Nov 2025 09:00:21 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Jens Axboe <axboe@kernel.dk>, Robin Murphy <robin.murphy@arm.com>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Alex Williamson <alex.williamson@redhat.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>
Cc: Krishnakant Jaju <kjaju@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, iommu@lists.linux.dev,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, kvm@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	Vivek Kasireddy <vivek.kasireddy@intel.com>
Subject: Re: [PATCH v6 00/11] vfio/pci: Allow MMIO regions to be exported
 through dma-buf
Message-ID: <20251104070021.GC50752@unreal>
References: <20251102-dmabuf-vfio-v6-0-d773cff0db9f@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251102-dmabuf-vfio-v6-0-d773cff0db9f@nvidia.com>

On Sun, Nov 02, 2025 at 10:00:48AM +0200, Leon Romanovsky wrote:

<...>

> ---
> Jason Gunthorpe (2):
>       PCI/P2PDMA: Document DMABUF model
>       vfio/nvgrace: Support get_dmabuf_phys
> 
> Leon Romanovsky (7):
>       PCI/P2PDMA: Separate the mmap() support from the core logic
>       PCI/P2PDMA: Simplify bus address mapping API
>       PCI/P2PDMA: Refactor to separate core P2P functionality from memory allocation
>       PCI/P2PDMA: Provide an access to pci_p2pdma_map_type() function
>       dma-buf: provide phys_vec to scatter-gather mapping routine
>       vfio/pci: Enable peer-to-peer DMA transactions by default
>       vfio/pci: Add dma-buf export support for MMIO regions
> 
> Vivek Kasireddy (2):
>       vfio: Export vfio device get and put registration helpers
>       vfio/pci: Share the core device pointer while invoking feature functions


Hi,

Can we get Acked-by for p2pdma and DMABUF parts?

Thanks

> 
>  Documentation/driver-api/pci/p2pdma.rst |  95 +++++++---
>  block/blk-mq-dma.c                      |   2 +-
>  drivers/dma-buf/dma-buf.c               | 235 ++++++++++++++++++++++++
>  drivers/iommu/dma-iommu.c               |   4 +-
>  drivers/pci/p2pdma.c                    | 182 +++++++++++++-----
>  drivers/vfio/pci/Kconfig                |   3 +
>  drivers/vfio/pci/Makefile               |   1 +
>  drivers/vfio/pci/nvgrace-gpu/main.c     |  56 ++++++
>  drivers/vfio/pci/vfio_pci.c             |   5 +
>  drivers/vfio/pci/vfio_pci_config.c      |  22 ++-
>  drivers/vfio/pci/vfio_pci_core.c        |  56 ++++--
>  drivers/vfio/pci/vfio_pci_dmabuf.c      | 315 ++++++++++++++++++++++++++++++++
>  drivers/vfio/pci/vfio_pci_priv.h        |  23 +++
>  drivers/vfio/vfio_main.c                |   2 +
>  include/linux/dma-buf.h                 |  18 ++
>  include/linux/pci-p2pdma.h              | 120 +++++++-----
>  include/linux/vfio.h                    |   2 +
>  include/linux/vfio_pci_core.h           |  42 +++++
>  include/uapi/linux/vfio.h               |  27 +++
>  kernel/dma/direct.c                     |   4 +-
>  mm/hmm.c                                |   2 +-
>  21 files changed, 1077 insertions(+), 139 deletions(-)
> ---
> base-commit: 3a8660878839faadb4f1a6dd72c3179c1df56787
> change-id: 20251016-dmabuf-vfio-6cef732adf5a
> 
> Best regards,
> --  
> Leon Romanovsky <leonro@nvidia.com>
> 
> 

