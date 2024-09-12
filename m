Return-Path: <kvm+bounces-26683-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CB0197674E
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 13:16:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 200CC283EA3
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 11:16:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 178D61A0BF9;
	Thu, 12 Sep 2024 11:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HnlDHW0a"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 226A6145B14;
	Thu, 12 Sep 2024 11:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726139764; cv=none; b=SSm11tKSJeXoX5CBBNgRTZ+Zr35SawmL/OGCOXDdv5EyqdkRmLdkG0of/YW1cvZXPS0w6FvsfpXoWW9M+56IwczwQCRRFxt/u09Y9Kt9BTWYdK7vM5sDgbQdJUDEPuPQTb+w5KKI0/wstQAz5OCBkAu1T2iQpqsvYA97V1GE87o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726139764; c=relaxed/simple;
	bh=xHiv+64ufjlfaZB+1birEmDSAEqJIKZbsr4qpKOqPrE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZSTTG7FeqLoE/F9bKBWu71KjO3PneOmmOp7IvGRgcz5u2OiU6Jg7OoDYQiIqvK+QlFMviVqfnyn18vzFAflommA7kOUB1/Lu6waiBB+7Rbwe4g6rUDOTGP8zeZ4TVyur8AYwGn3+1kZUnMHM/B+Fq9ZxrUlrvEGyz8hzPJxHE0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HnlDHW0a; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE95BC4CECC;
	Thu, 12 Sep 2024 11:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726139763;
	bh=xHiv+64ufjlfaZB+1birEmDSAEqJIKZbsr4qpKOqPrE=;
	h=From:To:Cc:Subject:Date:From;
	b=HnlDHW0aJOlZ/mQyNxg12Vfl1QyQgA+4ialoezfo+MkiMtzpo37W3A7XFZzNSS2gV
	 nCy6S4qzhyg3yiWGrpjkJ7XXOwsjJGLduW17gDQ2j01fra/JxTwTC8bIEzsO37Jy3O
	 tWtJI3x5KEzkYDPDEvpo4btQfTc/iM6jDN4b9cWi2x7dl8qZl6FekY1wFay7lNo6Ii
	 IJZ7rjlAzG15afy2OtWqIvnGmh3J6ojSrsIxH92HPrMct8haQWjgPUjLGLnJK+FdOA
	 egzwYBUFcoq09uv/i0x7cvVS0WkLeIYtdOhFJpeYR+kGOqMRlQvQJEwypNBVn2bnZB
	 jTk09N6hrZ0Fw==
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
Subject: [RFC v2 00/21] Provide a new two step DMA API mapping API
Date: Thu, 12 Sep 2024 14:15:35 +0300
Message-ID: <cover.1726138681.git.leon@kernel.org>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Instead of waiting and waiting when I finally fix NVMe patch which
doesn't work correctly in DMA direct mode (it causes to failures in
module reload), I decided to send the series as is to at least get
a feedback about API and the overall direction.

Thanks

-------------------------------------------------------------------------
Changelog:
v2:
 * Remove attr field from dma_iova_attrs
 * Added attr parameter to every new API call except alloc_iova
 * Embed use_iova boolean into struct dma_iova_state
 * Embed struct dma_memory_type into struct dma_iova_state
 * Changed function signatures and added new function to initialize state
 * Combined dma_set_memory_type() and dma_can_use_iova() to one function, they were used together anyway
 * Made dma_start_range/dma_end_range to be NOP for non-iommu case
 * Restructured the code to avoid inclusion of linux/pci.h in global header
 * Based on DMA static calls series
 * Changed iommu/dma functions to get parameters instead of dma_iova_state
 * Removed iommu domain pointer from dma_iova_state
 * dma_link_range now returns DMA address
 * Rewrote NVMe patch
v1: https://lore.kernel.org/all/cover.1719909395.git.leon@kernel.org
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
feature improvement (such as avoiding struct page for P2P) due to the
impossibility of improving the scatterlist.

Several approaches have been explored to expand the DMA API with additional
scatterlist-like structures (BIO[1], rlist[2]), instead split up the DMAAPI
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

This step is first along a path to provide alternatives to scatterlist
and solve some of the abuses and design mistakes, for instance in DMABUF's
P2P support.

The ODP and VFIO versions are complete and fully tested, they can be the
users of the new API to merge it. The NVMe requires more work.

[1] https://lore.kernel.org/all/169772852492.5232.17148564580779995849.stgit@klimt.1015granger.net/
[2] https://lore.kernel.org/all/ZD2lMvprVxu23BXZ@ziepe.ca/

Thanks

Leon Romanovsky (21):
  iommu/dma: Provide an interface to allow preallocate IOVA
  iommu/dma: Implement link/unlink ranges callbacks
  iommu/dma: Add check if IOVA can be used
  dma-mapping: initialize IOVA state struct
  dma-mapping: provide an interface to allocate IOVA
  dma-mapping: set and query DMA IOVA state
  dma-mapping: implement link range API
  mm/hmm: let users to tag specific PFN with DMA mapped bit
  dma-mapping: provide callbacks to link/unlink HMM PFNs to specific
    IOVA
  RDMA/umem: Preallocate and cache IOVA for UMEM ODP
  RDMA/umem: Store ODP access mask information in PFN
  RDMA/core: Separate DMA mapping to caching IOVA and page linkage
  RDMA/umem: Prevent UMEM ODP creation with SWIOTLB
  vfio/mlx5: Explicitly use number of pages instead of allocated length
  vfio/mlx5: Rewrite create mkey flow to allow better code reuse
  vfio/mlx5: Explicitly store page list
  vfio/mlx5: Convert vfio to use DMA link API
  nvme-pci: remove optimizations for single DMA entry
  nvme-pci: precalculate number of DMA entries for each command
  nvme-pci: use new dma API
  nvme-pci: don't allow mapping of bvecs with offset

 drivers/infiniband/core/umem_odp.c   | 216 +++++---------
 drivers/infiniband/hw/mlx5/mlx5_ib.h |   1 +
 drivers/infiniband/hw/mlx5/odp.c     |  44 +--
 drivers/iommu/dma-iommu.c            | 165 ++++++++++-
 drivers/nvme/host/pci.c              | 428 ++++++++++++++-------------
 drivers/pci/p2pdma.c                 |   4 +-
 drivers/vfio/pci/mlx5/cmd.c          | 312 ++++++++++---------
 drivers/vfio/pci/mlx5/cmd.h          |  23 +-
 drivers/vfio/pci/mlx5/main.c         |  89 +++---
 include/linux/dma-map-ops.h          |   7 +
 include/linux/dma-mapping.h          |  85 ++++++
 include/linux/hmm.h                  |   4 +
 include/linux/iommu-dma.h            |  43 +++
 include/rdma/ib_umem_odp.h           |  23 +-
 kernel/dma/mapping.c                 | 232 +++++++++++++++
 mm/hmm.c                             |  34 ++-
 16 files changed, 1096 insertions(+), 614 deletions(-)

-- 
2.46.0


