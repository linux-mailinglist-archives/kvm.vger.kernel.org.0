Return-Path: <kvm+bounces-20824-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C662D923929
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 11:10:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4D57C1F227DE
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 09:10:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99FFA15279E;
	Tue,  2 Jul 2024 09:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dB26JZU5"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A052E15098E;
	Tue,  2 Jul 2024 09:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719911400; cv=none; b=qUyO8+v2wcmnFRUOhLkMb54/MlKMiqBgklfyV2TcU2PYJhFX6hvhaiaGP65PvJp15luWnZHgaBBOLz0ipGzLWc1deIi6iaIqNAIvi/DA2AQ1ObXWn3PL7LaYhRIG8xy4oKH94+1aa2pPSDvGVID0Remxe9VyA6fSEmpbJQW/XIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719911400; c=relaxed/simple;
	bh=7m7ycvlObOhwBqwXJ7IhCV0Ur0RnLzzL6LlvlBs9ibs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=DBgcPUw5JCgrtUIkqGj5+BDR7bFERFLdOqLK3sHe7up9y36piGamfBnoPqPvi8+SXFY3BJ9fyw/C67ZcJ9EIhUhKhskegDZaRbYa3pkAorzz6lWF4Yp9npNiBpmUu92xEY9858J2Kc4kes2wxHOKZJWwgNMLRb0HrYbgF3E2A8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dB26JZU5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59C57C116B1;
	Tue,  2 Jul 2024 09:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719911400;
	bh=7m7ycvlObOhwBqwXJ7IhCV0Ur0RnLzzL6LlvlBs9ibs=;
	h=From:To:Cc:Subject:Date:From;
	b=dB26JZU57ZuTptEMWya8/+cYOSUeS28qr3rsacGa7mLuFkZUzsp0HfG6iwE/JIY8+
	 h/aemJ8UY8V38FCQVV94L8/2jOq9R3HIrF1uMYG+rMnZFN1gJ+8+q7oLfpeasm4qB/
	 hwtmA9ZJB/OD/ZZsiA7h7seltQo1Kme/l05Jj42tp1Eq9z7YkXN6m1c+YrJmYdH8lp
	 x2qLTJo+oeJ/uCDts/Qw/p++qhVnpMHUAaTXGI+LottYuu7xm2xTwHF8cP6pt3RS++
	 seuTs2mmeKPkGl41ZNXo79+tJyKN5xRqqHBNfzwmSGPEe4RBb/iVVvpRXGvbaVZlbC
	 45eYBIY+Y+TlQ==
From: Leon Romanovsky <leon@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Robin Murphy <robin.murphy@arm.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	"Zeng, Oak" <oak.zeng@intel.com>,
	Chaitanya Kulkarni <kch@nvidia.com>
Cc: Sagi Grimberg <sagi@grimberg.me>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	linux-pci@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1 00/18] Provide a new two step DMA API mapping API
Date: Tue,  2 Jul 2024 12:09:30 +0300
Message-ID: <cover.1719909395.git.leon@kernel.org>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Changelog:
v1:
 * Rewrote cover letter
 * Changed to API as proposed
   https://lore.kernel.org/linux-rdma/20240322184330.GL66976@ziepe.ca/
 * Removed IB DMA wrappers and use DMA API directly
v0: https://lore.kernel.org/all/cover.1709635535.git.leon@kernel.org
-------------------------------------------------------------------------

Currently the only efficient way to map a complex memory description through
the DMA API is by using the scatterlist APIs. The SG APIs are unique in that
they efficiently combine the two fundamental operations of sizing and allocating
a large IOVA window from the IOMMU and processing all the per-address
swiotlb/flushing/p2p/map details.

This uniqueness has been a long standing pain point as the scatterlist API
is mandatory, but expensive to use. It prevents any kind of optimization or
feature improvement (such as avoiding struct page for P2P) due to the impossibility
of improving the scatterlist.

Several approaches have been explored to expand the DMA API with additional
scatterlist-like structures (BIO[1], rlist[2]), instead split up the DMA API
to allow callers to bring their own data structure.

The API is split up into parts:
 - dma_alloc_iova() / dma_free_iova()
   To do any pre-allocation required. This is done based on the caller
   supplying some details about how much IOMMU address space it would need
   in worst case.
 - dma_link_range() / dma_unlink_range()
   Perform the actual mapping into the pre-allocated IOVA. This is very
   similar to dma_map_page().

A driver will extent its mapping size using its own data structure, such as
BIO, to request the required IOVA. Then it will iterate directly over it's
data structure to DMA map each range. The result can then be stored directly
into the HW specific DMA list. No intermediate scatterlist is required.

In this series, examples of three users are converted to the new API to show
the benefits. Each user has a unique flow:
 1. RDMA ODP is an example of "SVA mirroring" using HMM that needs to
    dynamically map/unmap large numbers of single pages. This becomes
    significantly faster in the IOMMU case as the map/unmap is now just
    a page table walk, the IOVA allocation is pre-computed once. Significant
    amounts of memory are saved as there is no longer a need to store the
    dma_addr_t of each page.
 2. VFIO PCI live migration code is building a very large "page list"
    for the device. Instead of allocating a scatter list entry per allocated
    page it can just allocate an array of 'struct page *', saving a large
    amount of memory.
 3. NVMe PCI demonstrates how a BIO can be converted to a HW scatter
    list without having to allocate then populate an intermediate SG table.

This step is first along a path to provide alternatives to scatterlist and
solve some of the abuses and design mistakes, for instance in DMABUF's P2P
support.

The ODP and VFIO versions are complete and fully tested, they can be the users
of the new API to merge it. The NVMe requires more work.

[1] https://lore.kernel.org/all/169772852492.5232.17148564580779995849.stgit@klimt.1015granger.net/
[2] https://lore.kernel.org/all/ZD2lMvprVxu23BXZ@ziepe.ca/

Chaitanya Kulkarni (2):
  block: export helper to get segment max size
  nvme-pci: use new dma API

Leon Romanovsky (16):
  dma-mapping: query DMA memory type
  dma-mapping: provide an interface to allocate IOVA
  dma-mapping: check if IOVA can be used
  dma-mapping: implement link range API
  mm/hmm: let users to tag specific PFN with DMA mapped bit
  dma-mapping: provide callbacks to link/unlink HMM PFNs to specific
    IOVA
  iommu/dma: Provide an interface to allow preallocate IOVA
  iommu/dma: Implement link/unlink ranges callbacks
  RDMA/umem: Preallocate and cache IOVA for UMEM ODP
  RDMA/umem: Store ODP access mask information in PFN
  RDMA/core: Separate DMA mapping to caching IOVA and page linkage
  RDMA/umem: Prevent UMEM ODP creation with SWIOTLB
  vfio/mlx5: Explicitly use number of pages instead of allocated length
  vfio/mlx5: Rewrite create mkey flow to allow better code reuse
  vfio/mlx5: Explicitly store page list
  vfio/mlx5: Convert vfio to use DMA link API

 block/blk-merge.c                    |   3 +-
 drivers/infiniband/core/umem_odp.c   | 218 ++++++-----------
 drivers/infiniband/hw/mlx5/mlx5_ib.h |   1 +
 drivers/infiniband/hw/mlx5/odp.c     |  44 ++--
 drivers/iommu/dma-iommu.c            | 142 +++++++++--
 drivers/nvme/host/pci.c              | 283 ++++++++++++++++------
 drivers/pci/p2pdma.c                 |   4 +-
 drivers/vfio/pci/mlx5/cmd.c          | 344 +++++++++++++++------------
 drivers/vfio/pci/mlx5/cmd.h          |  25 +-
 drivers/vfio/pci/mlx5/main.c         |  86 +++----
 include/linux/blk-mq.h               |   3 +
 include/linux/dma-map-ops.h          |  30 +++
 include/linux/dma-mapping.h          |  87 +++++++
 include/linux/hmm.h                  |   4 +
 include/rdma/ib_umem_odp.h           |  23 +-
 kernel/dma/mapping.c                 | 290 ++++++++++++++++++++++
 mm/hmm.c                             |  34 ++-
 17 files changed, 1122 insertions(+), 499 deletions(-)

-- 
2.45.2


