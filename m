Return-Path: <kvm+bounces-33920-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2219D9F4B70
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 14:01:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F3EF5162BDC
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 13:01:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 393791F4709;
	Tue, 17 Dec 2024 13:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W2+t6vZC"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B8CCA29;
	Tue, 17 Dec 2024 13:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734440460; cv=none; b=T0i8pGvy9aSH6Z5h8rZBAud8bM8HIkUq/NNl79H5Uqzt/Tex+uu8Jrc2aX+g2SGHLlxaxItwCQqvIxXCInK9Be/UlR/Uyo678D0ojhITz+Ylftfxb3e+QRpc5XNDWALjfEHwkycg2AudyNiRxkTNXmtxkVfpt3MMuNKof3M8vWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734440460; c=relaxed/simple;
	bh=WUcPWFcOfeUf/sio4O36o8I8jrOpMF9pl2t7YRV1K7c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kcTmF/0zmtc5jZ7AU0mCs3x//4cIg/ucroYFKLpQ4S3z9U5MNDxZxlU4PR2jRWurhgviUWga87KOOnECbNO2g/lbzcLa+hZbZ58ZBILPvjLenLc9plBsb8igbNcTbDoZV5m2LisOAnW4jJWUua/jTL4E+fqLCh0PZdnwr56o55U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W2+t6vZC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4E42C4CED3;
	Tue, 17 Dec 2024 13:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734440459;
	bh=WUcPWFcOfeUf/sio4O36o8I8jrOpMF9pl2t7YRV1K7c=;
	h=From:To:Cc:Subject:Date:From;
	b=W2+t6vZC3dFZWGD+hxEMeEPE1EEKt40fCuWrdg3SEm/26SFd4QEg0tiIvT2/Wek19
	 ipbNsM3RLXl0RvFJrTnmhBFYT5MAx6OqnZ/oOKDrKGf32XUg477wAJn6V2jcBjZO/8
	 Ii8+JaZkyyMGebvolPyBm40JjRdZQhIhr9H3yf5kaiaiXVcPFmwe/C4LJJ4P6impvd
	 8/hR+n5YTMhKvuP9ew3PL2463hfk0ZudfO9HpYVaOpExaxG4v5E7GWf3f90dIP2oBV
	 GHJCkATLPfGc2ofcLdQ0kQuhsYKz0DBm7jEilkgCea7JLERhDeOtEVUaSSk2h/iHeZ
	 SwmUwQ1h0ckQQ==
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
Subject: [PATCH v5 00/17] Provide a new two step DMA mapping API
Date: Tue, 17 Dec 2024 15:00:18 +0200
Message-ID: <cover.1734436840.git.leon@kernel.org>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changelog:
v5:
 * Trimmed long lines in all patches.
 * Squashed "dma-mapping: Add check if IOVA can be used" into
   "dma: Provide an interface to allow allocate IOVA" patch.
 * Added tags from Christoph and Will.
 * Fixed spelling/grammar errors.
 * Change title from "dma: Provide an  ..." to be "dma-mapping: Provide an ...".
 * Slightly changed hmm patch to set sticky flags in one place.
v4: https://lore.kernel.org/all/cover.1733398913.git.leon@kernel.org
 * Added extra patch to add kernel-doc for iommu_unmap and
 * iommu_unmap_fast
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
 * Added extra check in dma_iova_destroy() if mapped size to make code
 * more clear
 * Fixed checkpatch warnings in p2p patch
 * Changed implementation of VFIO mlx5 mlx5vf_add_migration_pages() to
   be more general
 * Reduced the number of changes in VFIO patch
v0: https://lore.kernel.org/all/cover.1730037276.git.leon@kernel.org

----------------------------------------------------------------------------


Christoph Hellwig (6):
  PCI/P2PDMA: Refactor the p2pdma mapping helpers
  dma-mapping: move the PCI P2PDMA mapping helpers to pci-p2pdma.h
  iommu: generalize the batched sync after map interface
  iommu/dma: Factor out a iommu_dma_map_swiotlb helper
  dma-mapping: add a dma_need_unmap helper
  docs: core-api: document the IOVA-based API

Leon Romanovsky (11):
  iommu: add kernel-doc for iommu_unmap and iommu_unmap_fast
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

 Documentation/core-api/dma-api.rst   |  70 +++++
 drivers/infiniband/core/umem_odp.c   | 250 +++++----------
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  12 +-
 drivers/infiniband/hw/mlx5/odp.c     |  65 ++--
 drivers/infiniband/hw/mlx5/umr.c     |  12 +-
 drivers/iommu/dma-iommu.c            | 454 +++++++++++++++++++++++----
 drivers/iommu/iommu.c                |  84 ++---
 drivers/pci/p2pdma.c                 |  38 +--
 drivers/vfio/pci/mlx5/cmd.c          | 376 +++++++++++-----------
 drivers/vfio/pci/mlx5/cmd.h          |  35 ++-
 drivers/vfio/pci/mlx5/main.c         |  87 +++--
 include/linux/dma-map-ops.h          |  54 ----
 include/linux/dma-mapping.h          |  86 +++++
 include/linux/hmm-dma.h              |  33 ++
 include/linux/hmm.h                  |  21 ++
 include/linux/iommu.h                |   4 +
 include/linux/pci-p2pdma.h           |  84 +++++
 include/rdma/ib_umem_odp.h           |  25 +-
 kernel/dma/direct.c                  |  44 +--
 kernel/dma/mapping.c                 |  18 ++
 mm/hmm.c                             | 264 ++++++++++++++--
 21 files changed, 1423 insertions(+), 693 deletions(-)
 create mode 100644 include/linux/hmm-dma.h

-- 
2.47.0


