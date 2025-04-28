Return-Path: <kvm+bounces-44531-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 10782A9EBBD
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 11:23:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3D2AA3BA060
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 09:22:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73F9125F97D;
	Mon, 28 Apr 2025 09:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L3HAKl3o"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797C71FECB4;
	Mon, 28 Apr 2025 09:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745832167; cv=none; b=WFk/DuUhv7GAJSFzlRpvDz4IhfFH392ZK1QHdqRGNA53JF8e5Jg0kjRVRyZnx6r/Cd3Dk1LC0CSiVU/ecwY34nnna+al0VVj9v21E4pRFH2E8gY80ukIm6zNtZ6vUjG5PAdmhMZqS8UGk6qVS3MmEUhq3hfMH0Th7cU40kR7k3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745832167; c=relaxed/simple;
	bh=+JZhbba6Y94p5DrBaAJ0+6gqrs2ChpJomt6vlounvho=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TXm1ub3OYgQXy6WsrT23q5KR0YQAmtxMF5zqSd4u6So0rPUgq0TNhI3VznkWaDBMT5WVv1bsRIBMhRlKgrHQvL39afzlF9r/tgo4kdg3fZwfYsLTsi3y6D1eJFfZek2+o8kvwpizgBBCeRuf3+cT7kEzXBbvXYnjIxYGjImZf6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L3HAKl3o; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB19FC4CEE9;
	Mon, 28 Apr 2025 09:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745832166;
	bh=+JZhbba6Y94p5DrBaAJ0+6gqrs2ChpJomt6vlounvho=;
	h=From:To:Cc:Subject:Date:From;
	b=L3HAKl3oxYp9ViZOT2gWLHXwJ+u36OWmAs8LS5VBGRfJxKvy5NC5yJr7YsNwlgGGS
	 MLBspboMpGjITWJIcTBNcp6LcPaEkm5XiPNilr+4gLacsrsWQ1MRW+eI5f1AsgWmNp
	 nvCqmAxpxtB25cHGYQbvnI/NFQQ8aMyCrpTUyW/L59P1JPrYmpwbN5iikoKaLHNQlC
	 6/c0N/dYulh+hxBW16Pz7WcPPnU9PVcgtWPElEoO8f4L965rNh3s7GOuUZ1Xv+Gzcb
	 nkYnWFrknpIV+0wlW3vXgylx9WDQ+mt12psyVlQ/1YP5AUSRb2Nxa+sHaFuzM8wiIm
	 xdZgUvlls6wUQ==
From: Leon Romanovsky <leon@kernel.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>
Cc: Jake Edge <jake@lwn.net>,
	Jonathan Corbet <corbet@lwn.net>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Zhu Yanjun <zyjzyj2000@gmail.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	linux-pci@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-mm@kvack.org,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Chaitanya Kulkarni <kch@nvidia.com>
Subject: [PATCH v10 00/24] Provide a new two step DMA mapping API
Date: Mon, 28 Apr 2025 12:22:06 +0300
Message-ID: <cover.1745831017.git.leon@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Following recent on site LSF/MM 2025 [1] discussion, the overall
response was extremely positive with many people expressed their
desire to see this series merged, so they can base their work on it.

It includes, but not limited:
 * Luis's "nvme-pci: breaking the 512 KiB max IO boundary":
   https://lore.kernel.org/all/20250320111328.2841690-1-mcgrof@kernel.org/
 * Chuck's NFS conversion to use one structure (bio_vec) for all types
   of RPC transports:
   https://lore.kernel.org/all/913df4b4-fc4a-409d-9007-088a3e2c8291@oracle.com
 * Matthew's vision for the world without struct page:
   https://lore.kernel.org/all/20250320111328.2841690-1-mcgrof@kernel.org/
 * Confidential computing roadmap from Dan:
   https://lore.kernel.org/all/6801a8e3968da_71fe29411@dwillia2-xfh.jf.intel.com.notmuch

This series is combination of effort of many people who contributed ideas,
code and testing and I'm gratefully thankful for them.

[1] https://lore.kernel.org/linux-rdma/20250122071600.GC10702@unreal/
-----------------------------------------------------------------------
Changelog:
v10:
 * Rebased on top v6.15-rc3
 * Added Luis's tags
 * Addressed review comments from Luis about DMA patches
 * Removed segment size check from single-segment SGL optimization code
 * Changed NVMe unmap data code as was suggested by Christoph
v9: https://lore.kernel.org/all/cover.1745394536.git.leon@kernel.org/
 * Added tested-by from Jens.
 * Replaced is_pci_p2pdma_page(bv.bv_page) check with if
   "(IS_ENABLED(CONFIG_PCI_P2PDMA) && (req->cmd_flags & REQ_P2PDMA))"
   which is more aligned with the goal (do not access struct page) and
   more efficient. This is the one line only that was changed in Jens's
   performance testing flow, so I kept his tags as is.
 * Restored single-segment optimization for SGL path.
 * Added forgotten unmap of metdata SGL multi-segment flow.
 * Split and squashed optimization patch from Kanchan.
 * Converted "bool aborted" flag to use newly introduced flag variable.
v8: https://lore.kernel.org/all/cover.1744825142.git.leon@kernel.org/
 * Rebased to v6.15-rc1
 * Added NVMe patches which are now patches and not RFC. They were in
   RFC stage because block iterator caused to performance regression
   for very extreme case scenario (~100M IOPS), but after Kanchan fixed
   it, the code started to be ready for merging.
 * @Niklas, i didn't change naming in this series as it follows iommu
   naming format.
v7: https://lore.kernel.org/all/cover.1738765879.git.leonro@nvidia.com/
 * Rebased to v6.14-rc1
v6: https://lore.kernel.org/all/cover.1737106761.git.leon@kernel.org
 * Changed internal __size variable to u64 to properly set private flag
   in most significant bit.
 * Added comment about why we check DMA_IOVA_USE_SWIOTLB
 * Break unlink loop if phys is NULL, condition which we shouldn't get.
v5: https://lore.kernel.org/all/cover.1734436840.git.leon@kernel.org
 * Trimmed long lines in all patches.
 * Squashed "dma-mapping: Add check if IOVA can be used" into
   "dma: Provide an interface to allow allocate IOVA" patch.
 * Added tags from Christoph and Will.
 * Fixed spelling/grammar errors.
 * Change title from "dma: Provide an  ..." to be "dma-mapping: Provide
   an ...".
 * Slightly changed hmm patch to set sticky flags in one place.
v4: https://lore.kernel.org/all/cover.1733398913.git.leon@kernel.org
 * Added extra patch to add kernel-doc for iommu_unmap and iommu_unmap_fast
 * Rebased to v6.13-rc1
 * Added Will's tags
v3: https://lore.kernel.org/all/cover.1731244445.git.leon@kernel.org
 * Added DMA_ATTR_SKIP_CPU_SYNC to p2p pages in HMM.
 * Fixed error unwind if dma_iova_sync fails in HMM.
 * Clear all PFN flags which were set in map to make code.
   more clean, the callers anyway cleaned them.
 * Generalize sticky PFN flags logic in HMM.
 * Removed not-needed #ifdef-#endif section.
v2: https://lore.kernel.org/all/cover.1730892663.git.leon@kernel.org
 * Fixed docs file as Randy suggested
 * Fixed releases of memory in HMM path. It was allocated with kv..
   variants but released with kfree instead of kvfree.
 * Slightly changed commit message in VFIO patch.
v1: https://lore.kernel.org/all/cover.1730298502.git.leon@kernel.org
 * Squashed two VFIO patches into one
 * Added Acked-by/Reviewed-by tags
 * Fix docs spelling errors
 * Simplified dma_iova_sync() API
 * Added extra check in dma_iova_destroy() if mapped size to make code more clear
 * Fixed checkpatch warnings in p2p patch
 * Changed implementation of VFIO mlx5 mlx5vf_add_migration_pages() to
   be more general
 * Reduced the number of changes in VFIO patch
v0: https://lore.kernel.org/all/cover.1730037276.git.leon@kernel.org

----------------------------------------------------------------------------
 LWN coverage:
Dancing the DMA two-step - https://lwn.net/Articles/997563/
----------------------------------------------------------------------------

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
scatterlist-like structures (BIO, rlist), instead split up the DMA API
to allow callers to bring their own data structure.

The API is split up into parts:
 - Allocate IOVA space:
    To do any pre-allocation required. This is done based on the caller
    supplying some details about how much IOMMU address space it would need
    in worst case.
 - Map and unmap relevant structures to pre-allocated IOVA space:
    Perform the actual mapping into the pre-allocated IOVA. This is very
    similar to dma_map_page().

In this series, examples of three different users are converted to the new API
to show the benefits and its versatility. Each user has a unique
flow:
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

To make the use of the new API easier, HMM and block subsystems are extended
to hide the optimization details from the caller. Among these optimizations:
 * Memory reduction as in most real use cases there is no need to store mapped
   DMA addresses and unmap them.
 * Reducing the function call overhead by removing the need to call function
   pointers and use direct calls instead.

This step is first along a path to provide alternatives to scatterlist and
solve some of the abuses and design mistakes.

The whole series can be found here:
https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git dma-split-Apr-27

Thanks

Christoph Hellwig (12):
  PCI/P2PDMA: Refactor the p2pdma mapping helpers
  dma-mapping: move the PCI P2PDMA mapping helpers to pci-p2pdma.h
  iommu: generalize the batched sync after map interface
  iommu/dma: Factor out a iommu_dma_map_swiotlb helper
  dma-mapping: add a dma_need_unmap helper
  docs: core-api: document the IOVA-based API
  block: share more code for bio addition helper
  block: don't merge different kinds of P2P transfers in a single bio
  blk-mq: add scatterlist-less DMA mapping helpers
  nvme-pci: remove struct nvme_descriptor
  nvme-pci: use a better encoding for small prp pool allocations
  nvme-pci: convert to blk_rq_dma_map

Leon Romanovsky (12):
  iommu: add kernel-doc for iommu_unmap_fast
  dma-mapping: Provide an interface to allow allocate IOVA
  dma-mapping: Implement link/unlink ranges API
  mm/hmm: let users to tag specific PFN with DMA mapped bit
  mm/hmm: provide generic DMA managing logic
  RDMA/umem: Store ODP access mask information in PFN
  RDMA/core: Convert UMEM ODP DMA mapping to caching IOVA and page
    linkage
  RDMA/umem: Separate implicit ODP initialization from explicit ODP
  vfio/mlx5: Explicitly use number of pages instead of allocated length
  vfio/mlx5: Rewrite create mkey flow to allow better code reuse
  vfio/mlx5: Enable the DMA link API
  nvme-pci: store aborted state in flags variable

 Documentation/core-api/dma-api.rst   |  71 +++
 block/bio.c                          |  83 ++--
 block/blk-merge.c                    | 180 ++++++-
 drivers/infiniband/core/umem_odp.c   | 252 ++++------
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  12 +-
 drivers/infiniband/hw/mlx5/odp.c     |  65 ++-
 drivers/infiniband/hw/mlx5/umr.c     |  12 +-
 drivers/infiniband/sw/rxe/rxe_odp.c  |  18 +-
 drivers/iommu/dma-iommu.c            | 482 +++++++++++++++---
 drivers/iommu/iommu.c                |  84 ++--
 drivers/nvme/host/pci.c              | 699 +++++++++++++++------------
 drivers/pci/p2pdma.c                 |  38 +-
 drivers/vfio/pci/mlx5/cmd.c          | 375 +++++++-------
 drivers/vfio/pci/mlx5/cmd.h          |  35 +-
 drivers/vfio/pci/mlx5/main.c         |  87 ++--
 include/linux/blk-mq-dma.h           |  63 +++
 include/linux/blk_types.h            |   2 +
 include/linux/dma-map-ops.h          |  54 ---
 include/linux/dma-mapping.h          |  85 ++++
 include/linux/hmm-dma.h              |  33 ++
 include/linux/hmm.h                  |  24 +-
 include/linux/iommu.h                |   4 +
 include/linux/pci-p2pdma.h           |  85 ++++
 include/rdma/ib_umem_odp.h           |  25 +-
 kernel/dma/direct.c                  |  44 +-
 kernel/dma/mapping.c                 |  18 +
 mm/hmm.c                             | 263 +++++++++-
 27 files changed, 2115 insertions(+), 1078 deletions(-)
 create mode 100644 include/linux/blk-mq-dma.h
 create mode 100644 include/linux/hmm-dma.h

-- 
2.49.0


