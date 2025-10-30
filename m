Return-Path: <kvm+bounces-61463-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B009C1E9F4
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 07:49:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2116B19C15D2
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 06:49:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6127832572A;
	Thu, 30 Oct 2025 06:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jvaq5XNT"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6939317B43F;
	Thu, 30 Oct 2025 06:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761806904; cv=none; b=ICD1nYZD23eoxUGKJ0n+lCSLz1EAaY2wIOJcTt2L5tilFKzmqN3iVhgxaflTlf99zdb92yGTe2mznHo2hFluMgPUfwzXe2pLkla6rHunfeS4wPHXhRF2405YjyC+kY/56i4WbYlkIbK3GwbvcN+wGFO9A1vjv6LPlmjw/dHVjp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761806904; c=relaxed/simple;
	bh=Hh7skkg065ylczpCr0Iv292nYGj50H++UlcoJlqnTFg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y/GKlT6ddPKELQvFv33SMVK1v8si1Q0LJ+7Xx+n8YOHxG2RI3t9jTWkmnlBUl0zRXZ9aYi6J/x5BaVe0hrgoP1PCHl+0Aeh7WGGgYbX1DboqVFTGGlWTzUNom4o9zNduORjvYNwUDf+lp5TWjvSOKN/bpcNPsuAHS3kTYczadvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jvaq5XNT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26554C4CEF1;
	Thu, 30 Oct 2025 06:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761806903;
	bh=Hh7skkg065ylczpCr0Iv292nYGj50H++UlcoJlqnTFg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Jvaq5XNTepDILhgg1JjU/RUVDN3aAiAJIkCA81z5TSuHPckkaF3X0SyKZTH4NiHLo
	 x+finAT9AqYTJiYKAczU3VWRnf+rm3VE20OrKWYI/Xxc5hFGsCXFzXGxlRgl84S3cn
	 1erdjEeAotdXzH15cDoYeVH+bTlS6vCEewWmlIP12FHqqmKW1wIhJVbVTWmVOPGJrX
	 RJ5aoNnkrAbFiXF+dpmpZF6tfJYJwn+YpHGgTwxQxqrtPlhVJhYtSdcxvt/ny5ubyp
	 08qX3boYwst6Z/pSklUkGal7BAeNf8rJyf2PuG4I88FPZtBaphc13e3GPPIzUbz0sz
	 yNDwwG6BUC0cA==
Date: Thu, 30 Oct 2025 08:48:18 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Samiullah Khawaja <skhawaja@google.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
	kvm@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org, Logan Gunthorpe <logang@deltatee.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v5 9/9] vfio/pci: Add dma-buf export support for MMIO
 regions
Message-ID: <20251030064818.GA60090@unreal>
References: <cover.1760368250.git.leon@kernel.org>
 <72ecaa13864ca346797e342d23a7929562788148.1760368250.git.leon@kernel.org>
 <CAAywjhRb6Nwmzy+QWFPH9Zkn-xvtvOktNjAZ8HMpM2wmVw2rjw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAywjhRb6Nwmzy+QWFPH9Zkn-xvtvOktNjAZ8HMpM2wmVw2rjw@mail.gmail.com>

On Wed, Oct 29, 2025 at 05:25:03PM -0700, Samiullah Khawaja wrote:
> On Mon, Oct 13, 2025 at 8:27 AM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > From: Leon Romanovsky <leonro@nvidia.com>
> >
> > Add support for exporting PCI device MMIO regions through dma-buf,
> > enabling safe sharing of non-struct page memory with controlled
> > lifetime management. This allows RDMA and other subsystems to import
> > dma-buf FDs and build them into memory regions for PCI P2P operations.
> >
> > The implementation provides a revocable attachment mechanism using
> > dma-buf move operations. MMIO regions are normally pinned as BARs
> > don't change physical addresses, but access is revoked when the VFIO
> > device is closed or a PCI reset is issued. This ensures kernel
> > self-defense against potentially hostile userspace.
> >
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  drivers/vfio/pci/Kconfig           |   3 +
> >  drivers/vfio/pci/Makefile          |   2 +
> >  drivers/vfio/pci/vfio_pci_config.c |  22 +-
> >  drivers/vfio/pci/vfio_pci_core.c   |  28 ++
> >  drivers/vfio/pci/vfio_pci_dmabuf.c | 446 +++++++++++++++++++++++++++++
> >  drivers/vfio/pci/vfio_pci_priv.h   |  23 ++
> >  include/linux/vfio_pci_core.h      |   1 +
> >  include/uapi/linux/vfio.h          |  25 ++
> >  8 files changed, 546 insertions(+), 4 deletions(-)
> >  create mode 100644 drivers/vfio/pci/vfio_pci_dmabuf.c

<...>

> > +void vfio_pci_dma_buf_move(struct vfio_pci_core_device *vdev, bool revoked)
> > +{
> > +       struct vfio_pci_dma_buf *priv;
> > +       struct vfio_pci_dma_buf *tmp;
> > +
> > +       lockdep_assert_held_write(&vdev->memory_lock);
> > +
> > +       list_for_each_entry_safe(priv, tmp, &vdev->dmabufs, dmabufs_elm) {
> > +               if (!get_file_active(&priv->dmabuf->file))
> > +                       continue;
> > +
> > +               if (priv->revoked != revoked) {
> > +                       dma_resv_lock(priv->dmabuf->resv, NULL);
> > +                       priv->revoked = revoked;
> > +                       dma_buf_move_notify(priv->dmabuf);
> 
> I think this should only be called when revoked is true, otherwise
> this will be calling move_notify on the already revoked dmabuf
> attachments.

This case is protected by "if (priv->revoked)" check both in vfio_pci_dma_buf_map
and vfio_pci_dma_buf_attach. They will prevent DMABUF recreation if revoked is false.

VTW, please trim your replies, it is time consuming to find your reply
among 600 lines of unrelated text.

Thanks

> > +                       dma_resv_unlock(priv->dmabuf->resv);
> > +               }
> > +               dma_buf_put(priv->dmabuf);
> > +       }
> > +}


