Return-Path: <kvm+bounces-63822-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A7CB8C7332A
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 10:34:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id 95DD82FD61
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 09:33:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAFA432C31E;
	Thu, 20 Nov 2025 09:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uO5bvReP"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9241426C39B;
	Thu, 20 Nov 2025 09:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763630966; cv=none; b=Z9m6FpctkGHJbdVZozikaypp5SIBLztQGUdLnVqgfiM/i5/fvA475NlgaiHgM3XLbKwhPVlkNV89f4tQ53UUvJGSbiblQV7d9oBgFFOovdfZOgRt2ooAshTANdcqm7iTke9JzSdy9fGgJ0RiThIpHJu4Kf6qhOvmsBUlU1CfT10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763630966; c=relaxed/simple;
	bh=LFSaVFGXyqZ1Ymg7hrWHvuDYaezafYJR42/4yF3AC6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zq6ULG/GpgC6f0T+YQj/LggkpQxPySBxNSabOrAaa92JkQD7zxc8OtgtNGFfoviMnHsDf2jp4/d4jw6GviEjfcol3xrFImMh6jU0z7WcJG9vfnJrUeGlOcQSnfjwRQ6OIMhFTWNu7kV1IkkHsdDkoWRCLVKtMXZQilLdf1kBFNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uO5bvReP; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8EE2C116C6;
	Thu, 20 Nov 2025 09:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763630966;
	bh=LFSaVFGXyqZ1Ymg7hrWHvuDYaezafYJR42/4yF3AC6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uO5bvReP4vqmF17vp4umydSjwbMPlUEBwrr06wx2F06At0/D21mfaz/7x8ruRvX1v
	 3Uq6tUwzacon0WOtQFzpZGt0RcDpBSDOHYKNsLthJEbiBNaxV80Ir0z6pZR3p1qV7x
	 dYAq1ufKqD7WSUWjj2c+VaxFnLI5cuf1bYNHnTmdN6EBNBg1de5v+GG2XKWf9NcHYD
	 FAzZjictEB2q/huOTMy21YG403zsmAl6hCATZRJReXLB03B8swFxed7wkRnmWjPcT2
	 6mrCIzwnXTd2Cp6XwJSoeCi2stzNxUdFQ34bfMGdm8qh30x4qLAgam/sJ1wdVrEbvC
	 SupDOjG80fwmg==
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
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex@shazbot.org>
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
	Alex Mastro <amastro@fb.com>,
	Nicolin Chen <nicolinc@nvidia.com>
Subject: [PATCH v9 11/11] vfio/nvgrace: Support get_dmabuf_phys
Date: Thu, 20 Nov 2025 11:28:30 +0200
Message-ID: <20251120-dmabuf-vfio-v9-11-d7f71607f371@nvidia.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251120-dmabuf-vfio-v9-0-d7f71607f371@nvidia.com>
References: <20251120-dmabuf-vfio-v9-0-d7f71607f371@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-a6db3
Content-Transfer-Encoding: 8bit

From: Jason Gunthorpe <jgg@nvidia.com>

Call vfio_pci_core_fill_phys_vec() with the proper physical ranges for the
synthetic BAR 2 and BAR 4 regions. Otherwise use the normal flow based on
the PCI bar.

This demonstrates a DMABUF that follows the region info report to only
allow mapping parts of the region that are mmapable. Since the BAR is
power of two sized and the "CXL" region is just page aligned the there can
be a padding region at the end that is not mmaped or passed into the
DMABUF.

The "CXL" ranges that are remapped into BAR 2 and BAR 4 areas are not PCI
MMIO, they actually run over the CXL-like coherent interconnect and for
the purposes of DMA behave identically to DRAM. We don't try to model this
distinction between true PCI BAR memory that takes a real PCI path and the
"CXL" memory that takes a different path in the p2p framework for now.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Tested-by: Alex Mastro <amastro@fb.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/main.c | 52 +++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index e346392b72f6..691e56944882 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -7,6 +7,7 @@
 #include <linux/vfio_pci_core.h>
 #include <linux/delay.h>
 #include <linux/jiffies.h>
+#include <linux/pci-p2pdma.h>
 
 /*
  * The device memory usable to the workloads running in the VM is cached
@@ -683,6 +684,50 @@ nvgrace_gpu_write(struct vfio_device *core_vdev,
 	return vfio_pci_core_write(core_vdev, buf, count, ppos);
 }
 
+static int nvgrace_get_dmabuf_phys(struct vfio_pci_core_device *core_vdev,
+				   struct p2pdma_provider **provider,
+				   unsigned int region_index,
+				   struct dma_buf_phys_vec *phys_vec,
+				   struct vfio_region_dma_range *dma_ranges,
+				   size_t nr_ranges)
+{
+	struct nvgrace_gpu_pci_core_device *nvdev = container_of(
+		core_vdev, struct nvgrace_gpu_pci_core_device, core_device);
+	struct pci_dev *pdev = core_vdev->pdev;
+	struct mem_region *mem_region;
+
+	/* 
+	 * if (nvdev->resmem.memlength && region_index == RESMEM_REGION_INDEX) {
+	 * 	The P2P properties of the non-BAR memory is the same as the
+	 * 	BAR memory, so just use the provider for index 0. Someday
+	 * 	when CXL gets P2P support we could create CXLish providers
+	 * 	for the non-BAR memory.
+	 * } else if (region_index == USEMEM_REGION_INDEX) {
+	 * 	This is actually cachable memory and isn't treated as P2P in
+	 * 	the chip. For now we have no way to push cachable memory
+	 * 	through everything and the Grace HW doesn't care what caching
+	 * 	attribute is programmed into the SMMU. So use BAR 0.
+	 * }
+	 */
+	mem_region = nvgrace_gpu_memregion(region_index, nvdev);
+	if (mem_region) {
+		*provider = pcim_p2pdma_provider(pdev, 0);
+		if (!*provider)
+			return -EINVAL;
+		return vfio_pci_core_fill_phys_vec(phys_vec, dma_ranges,
+						   nr_ranges,
+						   mem_region->memphys,
+						   mem_region->memlength);
+	}
+
+	return vfio_pci_core_get_dmabuf_phys(core_vdev, provider, region_index,
+					     phys_vec, dma_ranges, nr_ranges);
+}
+
+static const struct vfio_pci_device_ops nvgrace_gpu_pci_dev_ops = {
+	.get_dmabuf_phys = nvgrace_get_dmabuf_phys,
+};
+
 static const struct vfio_device_ops nvgrace_gpu_pci_ops = {
 	.name		= "nvgrace-gpu-vfio-pci",
 	.init		= vfio_pci_core_init_dev,
@@ -703,6 +748,10 @@ static const struct vfio_device_ops nvgrace_gpu_pci_ops = {
 	.detach_ioas	= vfio_iommufd_physical_detach_ioas,
 };
 
+static const struct vfio_pci_device_ops nvgrace_gpu_pci_dev_core_ops = {
+	.get_dmabuf_phys = vfio_pci_core_get_dmabuf_phys,
+};
+
 static const struct vfio_device_ops nvgrace_gpu_pci_core_ops = {
 	.name		= "nvgrace-gpu-vfio-pci-core",
 	.init		= vfio_pci_core_init_dev,
@@ -965,6 +1014,9 @@ static int nvgrace_gpu_probe(struct pci_dev *pdev,
 						    memphys, memlength);
 		if (ret)
 			goto out_put_vdev;
+		nvdev->core_device.pci_ops = &nvgrace_gpu_pci_dev_ops;
+	} else {
+		nvdev->core_device.pci_ops = &nvgrace_gpu_pci_dev_core_ops;
 	}
 
 	ret = vfio_pci_core_register_device(&nvdev->core_device);

-- 
2.51.1


