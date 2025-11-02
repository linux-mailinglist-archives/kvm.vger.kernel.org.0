Return-Path: <kvm+bounces-61752-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D7071C28AEA
	for <lists+kvm@lfdr.de>; Sun, 02 Nov 2025 09:01:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 73E311885331
	for <lists+kvm@lfdr.de>; Sun,  2 Nov 2025 08:01:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D48CA2652A6;
	Sun,  2 Nov 2025 08:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hb8/mk9r"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD30B176FB1;
	Sun,  2 Nov 2025 08:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762070469; cv=none; b=Mr1J7nRerv6AaEpcMxv6dNHxps/wYqzthlz920wj/14nYal3Rg+bVqa0b1bp6RmLXuT+iRcOMucQ9jXfDIhT8IErzFyRjmjJieO1tYfWWToGV3bpX/t8jLqXxu3cdKWSOIgdcM00Wuxse8NYEP1Fs6Wzbh/u3hCbS4xAJH2f1vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762070469; c=relaxed/simple;
	bh=TGXI5JBx+oVZlZONEasHSGn6NUOxqfudhy+Oh9+QCm0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=LXZXeMCUrEObhdAb/qfUfxzEzNG9kyAHRo89dS+PXI3XHxL1z4OJ49gXxBT7tGCQeZoOx/EWLskZd1Fakh+JS13vdYPFd6TfDDeTmYfM4jwaVepSRReFHRQb9rQnu3rXWI87PCvPR27sTjeIDSh1KQ9sFE76EB5SIrSEuV4H9/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hb8/mk9r; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC85AC4CEF7;
	Sun,  2 Nov 2025 08:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762070468;
	bh=TGXI5JBx+oVZlZONEasHSGn6NUOxqfudhy+Oh9+QCm0=;
	h=From:To:Cc:Subject:Date:From;
	b=hb8/mk9rpQ569n2d+A/GsfQ0AT/PQr21FC5Xz7LbPIyExnOw6stk//zMbSfWGqsAb
	 LzkxolJayP0clXnqgF+sZb77eAup96fi72QftwaGCa0dYqm2+yzajLr05Jc32bPrVx
	 IIhrl1de61OKkjpKd54PeDjWapfMnXriM+H4ww51gqdSyMySP0HdsJ5T3n0MvmClRt
	 dKS0fwxFo/cGFEBL3dZbfBpMQWHkfsRKLlmagaTPLUv/r5t38AK3ijL7NxAKasKgGc
	 kfN/y6545m23Bkzw3+xkyRE8Tpkn5vJV303g051o+LbksSeBGsK2kz5SMCqUud77Lv
	 S5MV8jxiOblZw==
From: Leon Romanovsky <leon@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Jens Axboe <axboe@kernel.dk>,
	Robin Murphy <robin.murphy@arm.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	=?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>
Cc: Krishnakant Jaju <kjaju@nvidia.com>,
	Matt Ochs <mochs@nvidia.com>,
	linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	iommu@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	kvm@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	Vivek Kasireddy <vivek.kasireddy@intel.com>
Subject: [PATCH v6 00/11] vfio/pci: Allow MMIO regions to be exported through dma-buf
Date: Sun,  2 Nov 2025 10:00:48 +0200
Message-ID: <20251102-dmabuf-vfio-v6-0-d773cff0db9f@nvidia.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Change-ID: 20251016-dmabuf-vfio-6cef732adf5a
X-Mailer: b4 0.15-dev
Content-Transfer-Encoding: 8bit

Changelog:
v6:
 * Fixed wrong error check from pcim_p2pdma_init().
 * Documented pcim_p2pdma_provider() function.
 * Improved commit messages.
 * Added VFIO DMA-BUF selftest.
 * Added __counted_by(nr_ranges) annotation to struct vfio_device_feature_dma_buf.
 * Fixed error unwind when dma_buf_fd() fails.
 * Document latest changes to p2pmem.
 * Removed EXPORT_SYMBOL_GPL from pci_p2pdma_map_type.
 * Moved DMA mapping logic to DMA-BUF.
 * Removed types patch to avoid dependencies between subsystems.
 * Moved vfio_pci_dma_buf_move() in err_undo block.
 * Added nvgrace patch.
v5: https://lore.kernel.org/all/cover.1760368250.git.leon@kernel.org
 * Rebased on top of v6.18-rc1.
 * Added more validation logic to make sure that DMA-BUF length doesn't
   overflow in various scenarios.
 * Hide kernel config from the users.
 * Fixed type conversion issue. DMA ranges are exposed with u64 length,
   but DMA-BUF uses "unsigned int" as a length for SG entries.
 * Added check to prevent from VFIO drivers which reports BAR size
   different from PCI, do not use DMA-BUF functionality.
v4: https://lore.kernel.org/all/cover.1759070796.git.leon@kernel.org
 * Split pcim_p2pdma_provider() to two functions, one that initializes
   array of providers and another to return right provider pointer.
v3: https://lore.kernel.org/all/cover.1758804980.git.leon@kernel.org
 * Changed pcim_p2pdma_enable() to be pcim_p2pdma_provider().
 * Cache provider in vfio_pci_dma_buf struct instead of BAR index.
 * Removed misleading comment from pcim_p2pdma_provider().
 * Moved MMIO check to be in pcim_p2pdma_provider().
v2: https://lore.kernel.org/all/cover.1757589589.git.leon@kernel.org/
 * Added extra patch which adds new CONFIG, so next patches can reuse
 * it.
 * Squashed "PCI/P2PDMA: Remove redundant bus_offset from map state"
   into the other patch.
 * Fixed revoke calls to be aligned with true->false semantics.
 * Extended p2pdma_providers to be per-BAR and not global to whole
 * device.
 * Fixed possible race between dmabuf states and revoke.
 * Moved revoke to PCI BAR zap block.
v1: https://lore.kernel.org/all/cover.1754311439.git.leon@kernel.org
 * Changed commit messages.
 * Reused DMA_ATTR_MMIO attribute.
 * Returned support for multiple DMA ranges per-dMABUF.
v0: https://lore.kernel.org/all/cover.1753274085.git.leonro@nvidia.com

---------------------------------------------------------------------------
Based on "[PATCH v6 00/16] dma-mapping: migrate to physical address-based API"
https://lore.kernel.org/all/cover.1757423202.git.leonro@nvidia.com/ series.
---------------------------------------------------------------------------

This series extends the VFIO PCI subsystem to support exporting MMIO
regions from PCI device BARs as dma-buf objects, enabling safe sharing of
non-struct page memory with controlled lifetime management. This allows RDMA
and other subsystems to import dma-buf FDs and build them into memory regions
for PCI P2P operations.

The series supports a use case for SPDK where a NVMe device will be
owned by SPDK through VFIO but interacting with a RDMA device. The RDMA
device may directly access the NVMe CMB or directly manipulate the NVMe
device's doorbell using PCI P2P.

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
https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/log/?h=dmabuf-vfio-v6

Thanks

---
Jason Gunthorpe (2):
      PCI/P2PDMA: Document DMABUF model
      vfio/nvgrace: Support get_dmabuf_phys

Leon Romanovsky (7):
      PCI/P2PDMA: Separate the mmap() support from the core logic
      PCI/P2PDMA: Simplify bus address mapping API
      PCI/P2PDMA: Refactor to separate core P2P functionality from memory allocation
      PCI/P2PDMA: Provide an access to pci_p2pdma_map_type() function
      dma-buf: provide phys_vec to scatter-gather mapping routine
      vfio/pci: Enable peer-to-peer DMA transactions by default
      vfio/pci: Add dma-buf export support for MMIO regions

Vivek Kasireddy (2):
      vfio: Export vfio device get and put registration helpers
      vfio/pci: Share the core device pointer while invoking feature functions

 Documentation/driver-api/pci/p2pdma.rst |  95 +++++++---
 block/blk-mq-dma.c                      |   2 +-
 drivers/dma-buf/dma-buf.c               | 235 ++++++++++++++++++++++++
 drivers/iommu/dma-iommu.c               |   4 +-
 drivers/pci/p2pdma.c                    | 182 +++++++++++++-----
 drivers/vfio/pci/Kconfig                |   3 +
 drivers/vfio/pci/Makefile               |   1 +
 drivers/vfio/pci/nvgrace-gpu/main.c     |  56 ++++++
 drivers/vfio/pci/vfio_pci.c             |   5 +
 drivers/vfio/pci/vfio_pci_config.c      |  22 ++-
 drivers/vfio/pci/vfio_pci_core.c        |  56 ++++--
 drivers/vfio/pci/vfio_pci_dmabuf.c      | 315 ++++++++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_priv.h        |  23 +++
 drivers/vfio/vfio_main.c                |   2 +
 include/linux/dma-buf.h                 |  18 ++
 include/linux/pci-p2pdma.h              | 120 +++++++-----
 include/linux/vfio.h                    |   2 +
 include/linux/vfio_pci_core.h           |  42 +++++
 include/uapi/linux/vfio.h               |  27 +++
 kernel/dma/direct.c                     |   4 +-
 mm/hmm.c                                |   2 +-
 21 files changed, 1077 insertions(+), 139 deletions(-)
---
base-commit: 3a8660878839faadb4f1a6dd72c3179c1df56787
change-id: 20251016-dmabuf-vfio-6cef732adf5a

Best regards,
--  
Leon Romanovsky <leonro@nvidia.com>


