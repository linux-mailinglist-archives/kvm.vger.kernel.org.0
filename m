Return-Path: <kvm+bounces-61292-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 56D02C1481C
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 13:03:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 85AA01A6081F
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 12:03:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F92732B982;
	Tue, 28 Oct 2025 12:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SwZX30kq"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA80328617;
	Tue, 28 Oct 2025 12:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761652934; cv=none; b=tFlJd6m5qCI/+fVZ5nVK+91PnCj9ALCDNHW6jbOiBqyJI143p3x1ry2QzizxiFPFpmqVIEudp4AqavLaA3WhTD4VkbthhPdklyZ5EnnZPIdBJjwQvQ6HSxs3XzQ7PJPafNLMWVT53npdfBS1QQxggj2xGZqhIzmpv9vzzMXbHNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761652934; c=relaxed/simple;
	bh=mZf/YKmsAob1fECJczEmiCct9PI3ELB+8/2Zjo1x01o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DyShAmpB1sV1LVad2AisW335Gq33qdq7SEzXH5pLBPojMUQhZ75sk6z8gq0FAOSpBj9U6QfP6tKFR4cdGXq2J5E6ZKu53sxtjCphaYERhSG7Se5vYx9JTxTIEb/9LCTMNzifmvEMCd/4juNeiKG3C4Iuym8si4bIHZrE//oWKKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SwZX30kq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9F27C4CEE7;
	Tue, 28 Oct 2025 12:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761652933;
	bh=mZf/YKmsAob1fECJczEmiCct9PI3ELB+8/2Zjo1x01o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SwZX30kqTRxKywW3JAgQpZq9YEFkCs4mbYnsls8E10OCO8sCik7skaC6kTTCKlfog
	 IAGPeflZVG4EU9joGw/E4TiGl7RA8FEFNbJr5eZDvYRVR5AqDOAKiVBJ3RW9NglqMt
	 YrKtMpdU8ZM7ej9CU2ASIMTiUtmkgbi/4YlElhPAm8ukENsd2Q5yb9qGC57bQdTv87
	 kSyfTWb41F+rhshf2CL1q0957AOwBmoHWs/npuXlrXKWFgxS/IeSKCP1J/gK/MKvkJ
	 lcPBPR7SnFgSuuCKpUntaxB+uWX3d7haPhR2st8URjXBigR+NbHjYiQJL0WRxmtmiQ
	 /cOOFozsC/eiA==
Date: Tue, 28 Oct 2025 14:02:07 +0200
From: Leon Romanovsky <leon@kernel.org>
To: David Matlack <dmatlack@google.com>
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
Message-ID: <20251028120207.GQ12554@unreal>
References: <cover.1760368250.git.leon@kernel.org>
 <72ecaa13864ca346797e342d23a7929562788148.1760368250.git.leon@kernel.org>
 <CALzav=cj_g8ndvbWdm=dukW+37cDh04k1n7ssFrDG+dN3D+cbw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALzav=cj_g8ndvbWdm=dukW+37cDh04k1n7ssFrDG+dN3D+cbw@mail.gmail.com>

On Mon, Oct 27, 2025 at 04:13:05PM -0700, David Matlack wrote:
> On Mon, Oct 13, 2025 at 8:44 AM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > From: Leon Romanovsky <leonro@nvidia.com>
> >
> > Add support for exporting PCI device MMIO regions through dma-buf,
> > enabling safe sharing of non-struct page memory with controlled
> > lifetime management. This allows RDMA and other subsystems to import
> > dma-buf FDs and build them into memory regions for PCI P2P operations.
> 
> > +/**
> > + * Upon VFIO_DEVICE_FEATURE_GET create a dma_buf fd for the
> > + * regions selected.
> > + *
> > + * open_flags are the typical flags passed to open(2), eg O_RDWR, O_CLOEXEC,
> > + * etc. offset/length specify a slice of the region to create the dmabuf from.
> > + * nr_ranges is the total number of (P2P DMA) ranges that comprise the dmabuf.
> > + *
> > + * Return: The fd number on success, -1 and errno is set on failure.
> > + */
> > +#define VFIO_DEVICE_FEATURE_DMA_BUF 11
> > +
> > +struct vfio_region_dma_range {
> > +       __u64 offset;
> > +       __u64 length;
> > +};
> > +
> > +struct vfio_device_feature_dma_buf {
> > +       __u32   region_index;
> > +       __u32   open_flags;
> > +       __u32   flags;
> > +       __u32   nr_ranges;
> > +       struct vfio_region_dma_range dma_ranges[];
> > +};
> 
> This uAPI would be a good candidate for a VFIO selftest. You can test
> that it returns an error when it's supposed to, and a valid fd when
> it's supposed to. And once the iommufd importer side is ready, we can
> extend the test and verify that the fd can be mapped into iommufd.

No problem, I'll add such test, but let's focus on making sure that this
series is accepted first.

Thanks

