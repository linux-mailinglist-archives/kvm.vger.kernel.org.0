Return-Path: <kvm+bounces-53907-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 60DBBB1A280
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 15:01:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8BC737A3795
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 12:59:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3D6A25F79A;
	Mon,  4 Aug 2025 13:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="snB5SB/e"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B1F38D;
	Mon,  4 Aug 2025 13:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754312457; cv=none; b=ATmRuTRRCO/bWleB1HeFjNMFWke7i8ONGjGl8qPmRp5KPBTB4oqI/c7nyEap/fLFiytjUQ4tOolKJtrgM3zY1iN5dL3G0OvXpQwmtlWGO2+ubljAeEuYgIdIHvBXHm4lYrKNrNaaNWc2FJB6DtByUQ6SaVWhKsHbo09acvsW+CQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754312457; c=relaxed/simple;
	bh=L+bDZNrpRD6+NWnAqrJEaGTijfdyb7IbO9utRG6Adzo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fs3M7VRVuD7ssved1PbfzxszsrazZ1P2MVB3H7MF5zlQkMY47CvU+yKGmVUg/u8g2EMfWLhHhFgt6970qlE9ywxkIJSYPlRekurd2SnwauOIZURLZ2yUIgAixtp60l8jcOupbc0Syy/o959Kx0JDYuYUDtmwc9S+XEX1FGK4DFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=snB5SB/e; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D16C4CEE7;
	Mon,  4 Aug 2025 13:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754312456;
	bh=L+bDZNrpRD6+NWnAqrJEaGTijfdyb7IbO9utRG6Adzo=;
	h=From:To:Cc:Subject:Date:From;
	b=snB5SB/ehi27xLbb8aXhBb2ZiyhJ9e2m9WSnuYjDNUxyhSq9Re9sx8WnUosm/3yxL
	 SN+3fMWL37eSzIUuNZEpqvSRbpU4PmQ9ZQZ/z/4VzZJKU+kN7HvBN/F1h/BSrkWO4H
	 eehopP6+SZUepq07StYSJKXP/s6hK7iUlUNz/zLE1wzKs99j9fG2ZEivbECfeIUph9
	 mrTs+HP3dr/zmRQ7l+QB7kp63HpOLpvFMfwujRo8eiMA/fuNXqD90jHbTmSImsSBka
	 U9Vy29jyCkt6W0MVTKUgd+gmftF40ONXFbnqj01gMf7pyAukD8MzMoYkOvBk/LgfIf
	 0LjjJU3m+NNxQ==
From: Leon Romanovsky <leon@kernel.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Christoph Hellwig <hch@lst.de>,
	dri-devel@lists.freedesktop.org,
	iommu@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Joerg Roedel <joro@8bytes.org>,
	kvm@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	Logan Gunthorpe <logang@deltatee.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v1 00/10] vfio/pci: Allow MMIO regions to be exported through dma-buf
Date: Mon,  4 Aug 2025 16:00:35 +0300
Message-ID: <cover.1754311439.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changelog:
v1:
 * Changed commit messages.
 * Reused DMA_ATTR_MMIO attribute.
 * Returned support for multiple DMA ranges per-dMABUF.
v0: https://lore.kernel.org/all/cover.1753274085.git.leonro@nvidia.com

---------------------------------------------------------------------------
Based on "[PATCH v1 00/16] dma-mapping: migrate to physical address-based API"
https://lore.kernel.org/all/cover.1754292567.git.leon@kernel.org series.
---------------------------------------------------------------------------

This series extends the VFIO PCI subsystem to support exporting MMIO regions
from PCI device BARs as dma-buf objects, enabling safe sharing of non-struct
page memory with controlled lifetime management. This allows RDMA and other
subsystems to import dma-buf FDs and build them into memory regions for PCI
P2P operations.

The series supports a use case for SPDK where a NVMe device will be owned
by SPDK through VFIO but interacting with a RDMA device. The RDMA device
may directly access the NVMe CMB or directly manipulate the NVMe device's
doorbell using PCI P2P.

However, as a general mechanism, it can support many other scenarios with
VFIO. This dmabuf approach can be usable by iommufd as well for generic
and safe P2P mappings.

In addition to the SPDK use-case mentioned above, the capability added
in this patch series can also be useful when a buffer (located in device
memory such as VRAM) needs to be shared between any two dGPU devices or
instances (assuming one of them is bound to VFIO PCI) as long as they
are P2P DMA compatible.

The implementation provides a revocable attachment mechanism using dma-buf
move operations. MMIO regions are normally pinned as BARs don't change
physical addresses, but access is revoked when the VFIO device is closed
or a PCI reset is issued. This ensures kernel self-defense against
potentially hostile userspace.

The series includes significant refactoring of the PCI P2PDMA subsystem
to separate core P2P functionality from memory allocation features,
making it more modular and suitable for VFIO use cases that don't need
struct page support.

-----------------------------------------------------------------------
The series is based originally on
https://lore.kernel.org/all/20250307052248.405803-1-vivek.kasireddy@intel.com/
but heavily rewritten to be based on DMA physical API.
-----------------------------------------------------------------------
The WIP branch can be found here:
https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/log/?h=dmabuf-vfio-v1

Thanks

Leon Romanovsky (8):
  PCI/P2PDMA: Remove redundant bus_offset from map state
  PCI/P2PDMA: Separate the mmap() support from the core logic
  PCI/P2PDMA: Simplify bus address mapping API
  PCI/P2PDMA: Refactor to separate core P2P functionality from memory
    allocation
  PCI/P2PDMA: Export pci_p2pdma_map_type() function
  types: move phys_vec definition to common header
  vfio/pci: Enable peer-to-peer DMA transactions by default
  vfio/pci: Add dma-buf export support for MMIO regions

Vivek Kasireddy (2):
  vfio: Export vfio device get and put registration helpers
  vfio/pci: Share the core device pointer while invoking feature
    functions

 block/blk-mq-dma.c                 |   7 +-
 drivers/iommu/dma-iommu.c          |   4 +-
 drivers/pci/p2pdma.c               | 154 ++++++++----
 drivers/vfio/pci/Kconfig           |  20 ++
 drivers/vfio/pci/Makefile          |   2 +
 drivers/vfio/pci/vfio_pci_config.c |  22 +-
 drivers/vfio/pci/vfio_pci_core.c   |  59 +++--
 drivers/vfio/pci/vfio_pci_dmabuf.c | 390 +++++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_priv.h   |  23 ++
 drivers/vfio/vfio_main.c           |   2 +
 include/linux/dma-buf.h            |   1 +
 include/linux/pci-p2pdma.h         | 114 +++++----
 include/linux/types.h              |   5 +
 include/linux/vfio.h               |   2 +
 include/linux/vfio_pci_core.h      |   4 +
 include/uapi/linux/vfio.h          |  25 ++
 kernel/dma/direct.c                |   4 +-
 mm/hmm.c                           |   2 +-
 18 files changed, 715 insertions(+), 125 deletions(-)
 create mode 100644 drivers/vfio/pci/vfio_pci_dmabuf.c

-- 
2.50.1


