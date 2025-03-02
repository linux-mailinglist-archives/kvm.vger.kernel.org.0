Return-Path: <kvm+bounces-39812-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BA773A4B0C3
	for <lists+kvm@lfdr.de>; Sun,  2 Mar 2025 09:57:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9617A3A9B65
	for <lists+kvm@lfdr.de>; Sun,  2 Mar 2025 08:57:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C51111DC074;
	Sun,  2 Mar 2025 08:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VIKIdi1E"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C58A617C210;
	Sun,  2 Mar 2025 08:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740905844; cv=none; b=m44ToQ2/ddzymfWQdbaIBiwRgBFFHkfdvW4h4ERaIKRoGZ4TvnqwbyASsDJX2khupsoCKz/reaUT9t60ZXAEslNwKfc4mfQaNZDUhRkNa6jXojl6QCK7wQeWOb7JJvFw5ZfncCy9QvPJsL6IrpCta0pJjldq8+b+HrUuMt8BMqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740905844; c=relaxed/simple;
	bh=u5JYFc4YftUMjJJM2wJNEZXoeeEaIau6bF605R+aFwg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uBzh94VV7ioyzF+YEDVe4++gotdDZ49NtDiFO0owvFr4LdKv2s+QibHsJr3SXyRl4A5vsC0PYq7nZMKimiytoAb365VYnNIhtW3+3rvn+bNkW/K1+oJ3iKkRE+bM6RbZuXysmKP8gSIwZ+FYqZkxa41121V7CUA5KLEurYdKSWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VIKIdi1E; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32951C4CED6;
	Sun,  2 Mar 2025 08:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740905843;
	bh=u5JYFc4YftUMjJJM2wJNEZXoeeEaIau6bF605R+aFwg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VIKIdi1EyC1UF4BWzoLUJbZam9xi3uIK8W2N0PXVxO6mVZsqAHqX/xxGb1scyaHEb
	 Jp8clkrcxHrLhb2bU1QlavJlNpJd/KtAXX7/s5yvLUUmPN8CfsYXGL42t5a+o/O4wi
	 0VzuN4CKCaDCzG12nSOaOB4jkb0xwB+UNDZ3Ga0HUbq0XAqYcoAr8JdqbDYMrx+tPz
	 wchzD8xI24OSxORMajnIN+2Zoa5pBcq9cYDfrsPgQdfp6sURJVLMe/XxAsI7bvkMsr
	 j8cUMPfH6Wcd8Llmu7zszAl9ExyG3CIQB78hRJLX5eUze8LYO5s4HGkUJ/KP3WbywR
	 /YJ3Sdkx9KSoA==
Date: Sun, 2 Mar 2025 10:57:17 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Robin Murphy <robin.murphy@arm.com>
Cc: Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@ziepe.ca>,
	Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
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
	kvm@vger.kernel.org, linux-mm@kvack.org,
	Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v7 00/17] Provide a new two step DMA mapping API
Message-ID: <20250302085717.GO53094@unreal>
References: <cover.1738765879.git.leonro@nvidia.com>
 <20250220124827.GR53094@unreal>
 <1166a5f5-23cc-4cce-ba40-5e10ad2606de@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1166a5f5-23cc-4cce-ba40-5e10ad2606de@arm.com>

On Fri, Feb 28, 2025 at 07:54:11PM +0000, Robin Murphy wrote:
> On 20/02/2025 12:48 pm, Leon Romanovsky wrote:
> > On Wed, Feb 05, 2025 at 04:40:20PM +0200, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro@nvidia.com>
> > > 
> > > Changelog:
> > > v7:
> > >   * Rebased to v6.14-rc1
> > 
> > <...>
> > 
> > > Christoph Hellwig (6):
> > >    PCI/P2PDMA: Refactor the p2pdma mapping helpers
> > >    dma-mapping: move the PCI P2PDMA mapping helpers to pci-p2pdma.h
> > >    iommu: generalize the batched sync after map interface
> > >    iommu/dma: Factor out a iommu_dma_map_swiotlb helper
> > >    dma-mapping: add a dma_need_unmap helper
> > >    docs: core-api: document the IOVA-based API
> > > 
> > > Leon Romanovsky (11):
> > >    iommu: add kernel-doc for iommu_unmap and iommu_unmap_fast
> > >    dma-mapping: Provide an interface to allow allocate IOVA
> > >    dma-mapping: Implement link/unlink ranges API
> > >    mm/hmm: let users to tag specific PFN with DMA mapped bit
> > >    mm/hmm: provide generic DMA managing logic
> > >    RDMA/umem: Store ODP access mask information in PFN
> > >    RDMA/core: Convert UMEM ODP DMA mapping to caching IOVA and page
> > >      linkage
> > >    RDMA/umem: Separate implicit ODP initialization from explicit ODP
> > >    vfio/mlx5: Explicitly use number of pages instead of allocated length
> > >    vfio/mlx5: Rewrite create mkey flow to allow better code reuse
> > >    vfio/mlx5: Enable the DMA link API
> > > 
> > >   Documentation/core-api/dma-api.rst   |  70 ++++
> >   drivers/infiniband/core/umem_odp.c   | 250 +++++---------
> > >   drivers/infiniband/hw/mlx5/mlx5_ib.h |  12 +-
> > >   drivers/infiniband/hw/mlx5/odp.c     |  65 ++--
> > >   drivers/infiniband/hw/mlx5/umr.c     |  12 +-
> > >   drivers/iommu/dma-iommu.c            | 468 +++++++++++++++++++++++----
> > >   drivers/iommu/iommu.c                |  84 ++---
> > >   drivers/pci/p2pdma.c                 |  38 +--
> > >   drivers/vfio/pci/mlx5/cmd.c          | 375 +++++++++++----------
> > >   drivers/vfio/pci/mlx5/cmd.h          |  35 +-
> > >   drivers/vfio/pci/mlx5/main.c         |  87 +++--
> > >   include/linux/dma-map-ops.h          |  54 ----
> > >   include/linux/dma-mapping.h          |  85 +++++
> > >   include/linux/hmm-dma.h              |  33 ++
> > >   include/linux/hmm.h                  |  21 ++
> > >   include/linux/iommu.h                |   4 +
> > >   include/linux/pci-p2pdma.h           |  84 +++++
> > >   include/rdma/ib_umem_odp.h           |  25 +-
> > >   kernel/dma/direct.c                  |  44 +--
> > >   kernel/dma/mapping.c                 |  18 ++
> > >   mm/hmm.c                             | 264 +++++++++++++--
> > >   21 files changed, 1435 insertions(+), 693 deletions(-)
> > >   create mode 100644 include/linux/hmm-dma.h
> > 
> > Kind reminder.
> 
> ...that you've simply reposted the same thing again? Without doing anything
> to address the bugs, inconsistencies, fundamental design flaws in claiming
> to be something it cannot possibly be, the egregious abuse of
> DMA_ATTR_SKIP_CPU_SYNC proudly highlighting how unfit-for-purpose the most
> basic part of the whole idea is, nor *still* the complete lack of any
> demonstrable justification of how callers who supposedly can't use the IOMMU
> API actually benefit from adding all the complexity of using the IOMMU API
> in a hat but also still the streaming DMA API as well?

Can you please provide concrete list of "the bugs, inconsistencies, fundamental
design flaws", so we can address/fix them?

We are in v7 now and out of all postings you replied to v1 and v5 only with
followups from three of us (Christoph, Jason and me).

> 
> Yeah, consider me reminded.

Silence means agreement.

> 
> In case I need to make it any more explicit, NAK to this not-generic
> not-DMA-mapping API, until you can come up with either something which *can*
> actually work in any kind of vaguely generic manner as claimed, or instead
> settle on a reasonable special-case solution for justifiable special cases.
> Bikeshedding and rebasing through half a dozen versions, while ignoring
> fundamental issues I've been pointing out from the very beginning, has not
> somehow magically made this series mature and acceptable to merge.

You never responded to Christoph's answers, so please try your best and
be professional, write down the list of things you want to see handled
in next version and it will be done. It is impossible to guess what you
want if you are not saying it clearly.

The main issue which we are trying to solve "abuse of SG lists for
things without struct page", is not going to disappear by itself.

> 
> Honestly, given certain other scenarios we may also end up having to deal
> with, if by the time everything broken is taken away, it were to end up
> stripped all the way back to something well-reasoned like:
> 
> "Some drivers want more control of their DMA buffer layout than the
> general-purpose IOVA allocator is able to provide though the DMA mapping
> APIs, but also would rather not have to deal with managing an entire IOMMU
> domain and address space, making MSIs work, etc. Expose
> iommu_dma_alloc_iova() and some trivial IOMMU API wrappers to allow drivers
> of coherent devices to claim regions of the default domain wherein they can
> manage their own mappings directly."
> 
> ...I wouldn't necessarily disagree.

Something like that was done in first RFC version, but the overall
feeling was that it is layer violation with unclear path to support
swiotlb for NVMe.

Thanks

> 
> Thanks,
> Robin.

