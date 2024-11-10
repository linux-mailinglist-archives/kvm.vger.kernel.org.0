Return-Path: <kvm+bounces-31365-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F26FC9C3240
	for <lists+kvm@lfdr.de>; Sun, 10 Nov 2024 14:47:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 80ED51F21389
	for <lists+kvm@lfdr.de>; Sun, 10 Nov 2024 13:47:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68261381BA;
	Sun, 10 Nov 2024 13:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aVljGmd+"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B63012B93;
	Sun, 10 Nov 2024 13:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731246437; cv=none; b=hghKsvdS/dyPQJDdEXF2wRhd1AKNvcbcaQOc5t4TMQobE20EBw287lrQ6dU/Yh2/Jah3Fd+qlayJVfK5FucxwKgLOrQsLJAD0ixJbrbDfyXR3MqFB6A+SEE781iae/+cCJnUJrUPgUi5agMZ9aBkgt+sx4qFe9qZiO/fIl+qy6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731246437; c=relaxed/simple;
	bh=mKF+zDGiwEoOQS4crAlVcAd69gyRm0sgIlfn6Dth5n4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=A+ztLAuhAqRE0e+jQHo1k0ExeHDqlt7uVhF1ThjCaloR+JPjSdiCYI8V5raMsg1k/jcyJHEpjGe12O3rrUJ4cfuxWYFmpspXPl+s60XrKkbF23Ekmd4ZvaIuILoIwL/rHoENCMK65o9lU0bWGI3WBljkBBjo3K9fPZoi/shDXdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aVljGmd+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2730CC4CECD;
	Sun, 10 Nov 2024 13:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731246436;
	bh=mKF+zDGiwEoOQS4crAlVcAd69gyRm0sgIlfn6Dth5n4=;
	h=From:To:Cc:Subject:Date:From;
	b=aVljGmd+xo/Yam9g672q7s4kk2hzX+gB5xzPmUCBsy/RV0av3qcSUwRVVnLmWjg4U
	 hbbKuhurzzrd5sDKDBruwSDRlLtgC9omQ9FzAOHUGUbOP/xjV3zZ+GmSmZ0d9epi3M
	 l4Jkur25JwrrzWW5mGxiCb9h2JpStfzbcEML1+6y85WaaAVI7IW2UKDnchW17Ob0ox
	 59soAzPSaW4XPEBcm8REZ1dDMomufybPDgR0gVjensd+jJZfqlK2DNQ6jm3u4pPctj
	 KHRqBuPGIRZ8Y2Y865jLeRbgo/C22Ik4ugFTleEyXz8Ca9GB97aPLMeIQFQvE8xEV2
	 KU3BkZDmC7tfA==
From: Leon Romanovsky <leon@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Robin Murphy <robin.murphy@arm.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>
Cc: Keith Busch <kbusch@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	linux-pci@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-mm@kvack.org,
	Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH v3 00/17] Provide a new two step DMA mapping API
Date: Sun, 10 Nov 2024 15:46:47 +0200
Message-ID: <cover.1731244445.git.leon@kernel.org>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changelog:
v3:
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
 * Added extra check in dma_iova_destroy() if mapped size to make code
 * more clear
 * Fixed checkpatch warnings in p2p patch
 * Changed implementation of VFIO mlx5 mlx5vf_add_migration_pages() to
   be more general
 * Reduced the number of changes in VFIO patch
v0: https://lore.kernel.org/all/cover.1730037276.git.leon@kernel.org

----------------------------------------------------------------------------
The code can be downloaded from:
https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git tag:dma-split-nov-09

Christoph,

Can you please take this series through your DMA mapping tree, so it
will soak enough time in linux-next before sending PR to Linus?

Thanks
----------------------------------------------------------------------------
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

In this and the next series [1], examples of three different users are converted
to the new API to show the benefits and its versatility. Each user has a unique
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
solve some of the abuses and design mistakes, for instance in DMABUF's P2P
support.

Thanks

[1] This still points to v0, as the change is just around handling dma_iova_sync()
and extra attribute flag provided to map/unmap:
https://lore.kernel.org/all/cover.1730037261.git.leon@kernel.org


Christoph Hellwig (6):
  PCI/P2PDMA: Refactor the p2pdma mapping helpers
  dma-mapping: move the PCI P2PDMA mapping helpers to pci-p2pdma.h
  iommu: generalize the batched sync after map interface
  iommu/dma: Factor out a iommu_dma_map_swiotlb helper
  dma-mapping: add a dma_need_unmap helper
  docs: core-api: document the IOVA-based API

Leon Romanovsky (11):
  dma-mapping: Add check if IOVA can be used
  dma: Provide an interface to allow allocate IOVA
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

 Documentation/core-api/dma-api.rst   |  70 ++++
 drivers/infiniband/core/umem_odp.c   | 250 +++++----------
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  12 +-
 drivers/infiniband/hw/mlx5/odp.c     |  65 ++--
 drivers/infiniband/hw/mlx5/umr.c     |  12 +-
 drivers/iommu/dma-iommu.c            | 459 +++++++++++++++++++++++----
 drivers/iommu/iommu.c                |  65 ++--
 drivers/pci/p2pdma.c                 |  38 +--
 drivers/vfio/pci/mlx5/cmd.c          | 373 +++++++++++-----------
 drivers/vfio/pci/mlx5/cmd.h          |  35 +-
 drivers/vfio/pci/mlx5/main.c         |  87 +++--
 include/linux/dma-map-ops.h          |  54 ----
 include/linux/dma-mapping.h          |  85 +++++
 include/linux/hmm-dma.h              |  32 ++
 include/linux/hmm.h                  |  21 ++
 include/linux/iommu.h                |   4 +
 include/linux/pci-p2pdma.h           |  84 +++++
 include/rdma/ib_umem_odp.h           |  25 +-
 kernel/dma/direct.c                  |  44 +--
 kernel/dma/mapping.c                 |  18 ++
 mm/hmm.c                             | 250 ++++++++++++++-
 21 files changed, 1399 insertions(+), 684 deletions(-)
 create mode 100644 include/linux/hmm-dma.h

-- 
2.47.0


