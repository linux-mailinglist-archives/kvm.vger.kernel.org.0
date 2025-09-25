Return-Path: <kvm+bounces-58750-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D208B9F811
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 15:19:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 581301C20676
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 13:19:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B789024BBEB;
	Thu, 25 Sep 2025 13:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dZ0bIaXN"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C027B2264CA;
	Thu, 25 Sep 2025 13:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758806312; cv=none; b=fwdbaq44EL90duYcTZql8ngi5EtS2Gzv/LOUwBl+DWZW8sDHN1uvKN/TqM/rB24MZLsqxuoFxgLk/DvlaEIwDBmsQr0gppcrkHKh9mOxnRsbM54/MwL2eplxyq5ptGwOjCQwnnYWYrqIVJIq/WiKgirw3Pu9AoinVQpSvAmc4yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758806312; c=relaxed/simple;
	bh=LldS4UL7ZlxQUaPAsaNZtO9N1rGFM0ivWFvFz+2VF14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nGxIfenchLs1/DGkAN7SvFEXkgiUg993FISdio96wyx9Yri/4xBEE6+Y4VaIpnIGhkVZxUvRw5k9nE7suueLG3d8rQSf4CMdgLAO4IVsDDL61CALLlQE9QF0mOCz8x0o2o3svOGOZ4ghh/bTe1c5Juk/+g3c8ofZgcnYSDYGmlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dZ0bIaXN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA7B1C4CEF5;
	Thu, 25 Sep 2025 13:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758806312;
	bh=LldS4UL7ZlxQUaPAsaNZtO9N1rGFM0ivWFvFz+2VF14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dZ0bIaXN1PNaTAD9Kjs2+Ss22c94ZLLAQ4uBkcOYx+4DrRfD8Ljbo+7DR4+/wrM70
	 p/8S1PqUZ8eIRnYejDIXO+xLr++iHb38s22BV20uCzd8BjS2yX6RYCu7uVD4Gk8Avh
	 lhVtk/aazGItiQgVbCSmrm8pXgCs8HUb3O5Hwq+DwbGW7LxonUFPF1IjyuMn/9spNB
	 WJXJIpN+U176dqfHLdBpIo1RFdmWFUuSRbnMAGrWO9p2UUXf/t+fEKnJCJPGWeEFHy
	 d6UwfMnq2MHRc1mozoUURZ0ev5Dkq8os7bPCApIuZ0ExOIXY2BFneibYTHrVqLpLMD
	 /ST1Js7q/4XLw==
From: Leon Romanovsky <leon@kernel.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
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
Subject: [PATCH v3 02/10] PCI/P2PDMA: Simplify bus address mapping API
Date: Thu, 25 Sep 2025 16:14:30 +0300
Message-ID: <ce571cf4ddad1f9d4876365fc3c6ffb9321558a4.1758804980.git.leon@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1758804980.git.leon@kernel.org>
References: <cover.1758804980.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

Update the pci_p2pdma_bus_addr_map() function to take a direct pointer
to the p2pdma_provider structure instead of the pci_p2pdma_map_state.
This simplifies the API by removing the need for callers to extract
the provider from the state structure.

The change updates all callers across the kernel (block layer, IOMMU,
DMA direct, and HMM) to pass the provider pointer directly, making
the code more explicit and reducing unnecessary indirection. This
also removes the runtime warning check since callers now have direct
control over which provider they use.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 block/blk-mq-dma.c         | 2 +-
 drivers/iommu/dma-iommu.c  | 4 ++--
 include/linux/pci-p2pdma.h | 7 +++----
 kernel/dma/direct.c        | 4 ++--
 mm/hmm.c                   | 2 +-
 5 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/block/blk-mq-dma.c b/block/blk-mq-dma.c
index d415088ed9fd2..430e51ec494a6 100644
--- a/block/blk-mq-dma.c
+++ b/block/blk-mq-dma.c
@@ -79,7 +79,7 @@ static inline bool blk_can_dma_map_iova(struct request *req,
 
 static bool blk_dma_map_bus(struct blk_dma_iter *iter, struct phys_vec *vec)
 {
-	iter->addr = pci_p2pdma_bus_addr_map(&iter->p2pdma, vec->paddr);
+	iter->addr = pci_p2pdma_bus_addr_map(iter->p2pdma.mem, vec->paddr);
 	iter->len = vec->len;
 	return true;
 }
diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 7944a3af4545e..e52d19d2e8334 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -1439,8 +1439,8 @@ int iommu_dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 			 * as a bus address, __finalise_sg() will copy the dma
 			 * address into the output segment.
 			 */
-			s->dma_address = pci_p2pdma_bus_addr_map(&p2pdma_state,
-						sg_phys(s));
+			s->dma_address = pci_p2pdma_bus_addr_map(
+				p2pdma_state.mem, sg_phys(s));
 			sg_dma_len(s) = sg->length;
 			sg_dma_mark_bus_address(s);
 			continue;
diff --git a/include/linux/pci-p2pdma.h b/include/linux/pci-p2pdma.h
index 27a2c399f47da..eef96636c67e6 100644
--- a/include/linux/pci-p2pdma.h
+++ b/include/linux/pci-p2pdma.h
@@ -186,16 +186,15 @@ pci_p2pdma_state(struct pci_p2pdma_map_state *state, struct device *dev,
 /**
  * pci_p2pdma_bus_addr_map - Translate a physical address to a bus address
  *			     for a PCI_P2PDMA_MAP_BUS_ADDR transfer.
- * @state:	P2P state structure
+ * @provider:	P2P provider structure
  * @paddr:	physical address to map
  *
  * Map a physically contiguous PCI_P2PDMA_MAP_BUS_ADDR transfer.
  */
 static inline dma_addr_t
-pci_p2pdma_bus_addr_map(struct pci_p2pdma_map_state *state, phys_addr_t paddr)
+pci_p2pdma_bus_addr_map(struct p2pdma_provider *provider, phys_addr_t paddr)
 {
-	WARN_ON_ONCE(state->map != PCI_P2PDMA_MAP_BUS_ADDR);
-	return paddr + state->mem->bus_offset;
+	return paddr + provider->bus_offset;
 }
 
 #endif /* _LINUX_PCI_P2P_H */
diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index 1062caac47e7b..3e058c99fe856 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -484,8 +484,8 @@ int dma_direct_map_sg(struct device *dev, struct scatterlist *sgl, int nents,
 			}
 			break;
 		case PCI_P2PDMA_MAP_BUS_ADDR:
-			sg->dma_address = pci_p2pdma_bus_addr_map(&p2pdma_state,
-					sg_phys(sg));
+			sg->dma_address = pci_p2pdma_bus_addr_map(
+				p2pdma_state.mem, sg_phys(sg));
 			sg_dma_mark_bus_address(sg);
 			continue;
 		default:
diff --git a/mm/hmm.c b/mm/hmm.c
index 6556c0e074ba8..012b78688fa18 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -751,7 +751,7 @@ dma_addr_t hmm_dma_map_pfn(struct device *dev, struct hmm_dma_map *map,
 		break;
 	case PCI_P2PDMA_MAP_BUS_ADDR:
 		pfns[idx] |= HMM_PFN_P2PDMA_BUS | HMM_PFN_DMA_MAPPED;
-		return pci_p2pdma_bus_addr_map(p2pdma_state, paddr);
+		return pci_p2pdma_bus_addr_map(p2pdma_state->mem, paddr);
 	default:
 		return DMA_MAPPING_ERROR;
 	}
-- 
2.51.0


