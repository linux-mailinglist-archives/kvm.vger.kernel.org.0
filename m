Return-Path: <kvm+bounces-20826-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A434B923933
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 11:11:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5E8522844AB
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 09:11:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E62FF1514ED;
	Tue,  2 Jul 2024 09:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PqzjMLOj"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEB0115098E;
	Tue,  2 Jul 2024 09:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719911409; cv=none; b=P5SnoL6WtKPb8VbRWd/5Evjo52Rh1+xvkOFiCcTz5hLpkLgEZwbLezkVr2CGHCOUBM+4E6B5wuu4CPViU6Am4+9z3IvKwV6SrZTXzyn6cTrbxCnGEHJ+a0di8k0g7x3BQFEscI0cFNE/I7goago/FEK4eglg5eU6H63ocGhR264=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719911409; c=relaxed/simple;
	bh=I7mD3dENF4HZBNBumoLyPjANfOtz0e/DAq7U9sRqLk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F6HrbetSOL8cQw0MHFDrfLfzwtQj9Au19yHL3h/aDOL0fkTaOWVS7ckEjjUnmq0VIK0bMdz0rrGYjVawBx7+cG96agAHTTp3KILgVXy7iW8YSHQNC+NVgyxVoHO+eZibIMAjM0Anr9QM1jh5IPVZeeN8tu0bceqMZSpw/x06B9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PqzjMLOj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DCD7C4AF0C;
	Tue,  2 Jul 2024 09:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719911408;
	bh=I7mD3dENF4HZBNBumoLyPjANfOtz0e/DAq7U9sRqLk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PqzjMLOjXeye9zq/mHzTj6Cl4RxSudqszFKsPx54AmE/tJ+OHgWu5ivCnN1LbBRUN
	 1Yv5vxJ4cXclv2ETPV3ZWWpK913fTcXr7yVC/nJo7AtJ6rnu3SJBTnF9+JY89SOEvd
	 TYkrX534Vg7HQIcEHujxARKgvk/nUOly8dQEFeqHVLZriAax5EaH09H4nUGZ/y8Loi
	 vDIjzYbeVRyYivHIMQkPD/nstZnUBJhmQWQx2JPLSSZymUewhzPZooZ7yJC7ufM6es
	 ONXggsrnv88nbqTGWDYThjoAZxFxhMpavbb+IIZpeIVu2VNBfqxKFRLDEd3u7X+sYd
	 zohrHgWstJ+9w==
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
Cc: Leon Romanvosky <leonro@nvidia.com>,
	Sagi Grimberg <sagi@grimberg.me>,
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
Subject: [RFC PATCH v1 03/18] dma-mapping: check if IOVA can be used
Date: Tue,  2 Jul 2024 12:09:33 +0300
Message-ID: <4c479ac482c3bd123a5f999fdff46454a7faa905.1719909395.git.leon@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1719909395.git.leon@kernel.org>
References: <cover.1719909395.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Leon Romanvosky <leonro@nvidia.com>

Provide a way to the callers to see if IOVA can be used for specific
DMA memory type.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/iommu/dma-iommu.c   | 13 -------------
 drivers/pci/p2pdma.c        |  4 ++--
 include/linux/dma-map-ops.h | 21 +++++++++++++++++++++
 include/linux/dma-mapping.h | 10 ++++++++++
 kernel/dma/mapping.c        | 32 ++++++++++++++++++++++++++++++++
 5 files changed, 65 insertions(+), 15 deletions(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 43520e7275cc..89e34503e0bb 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -597,19 +597,6 @@ static int iova_reserve_iommu_regions(struct device *dev,
 	return ret;
 }
 
-static bool dev_is_untrusted(struct device *dev)
-{
-	return dev_is_pci(dev) && to_pci_dev(dev)->untrusted;
-}
-
-static bool dev_use_swiotlb(struct device *dev, size_t size,
-			    enum dma_data_direction dir)
-{
-	return IS_ENABLED(CONFIG_SWIOTLB) &&
-		(dev_is_untrusted(dev) ||
-		 dma_kmalloc_needs_bounce(dev, size, dir));
-}
-
 static bool dev_use_sg_swiotlb(struct device *dev, struct scatterlist *sg,
 			       int nents, enum dma_data_direction dir)
 {
diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index 4f47a13cb500..6ceea32bb041 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -964,8 +964,8 @@ void pci_p2pmem_publish(struct pci_dev *pdev, bool publish)
 }
 EXPORT_SYMBOL_GPL(pci_p2pmem_publish);
 
-static enum pci_p2pdma_map_type pci_p2pdma_map_type(struct dev_pagemap *pgmap,
-						    struct device *dev)
+enum pci_p2pdma_map_type pci_p2pdma_map_type(struct dev_pagemap *pgmap,
+					     struct device *dev)
 {
 	enum pci_p2pdma_map_type type = PCI_P2PDMA_MAP_NOT_SUPPORTED;
 	struct pci_dev *provider = to_p2p_pgmap(pgmap)->provider;
diff --git a/include/linux/dma-map-ops.h b/include/linux/dma-map-ops.h
index 23e5e2f63a1c..b52e9c8db241 100644
--- a/include/linux/dma-map-ops.h
+++ b/include/linux/dma-map-ops.h
@@ -9,6 +9,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/pgtable.h>
 #include <linux/slab.h>
+#include <linux/pci.h>
 
 struct cma;
 struct iommu_ops;
@@ -348,6 +349,19 @@ static inline bool dma_kmalloc_needs_bounce(struct device *dev, size_t size,
 	return !dma_kmalloc_safe(dev, dir) && !dma_kmalloc_size_aligned(size);
 }
 
+static inline bool dev_is_untrusted(struct device *dev)
+{
+	return dev_is_pci(dev) && to_pci_dev(dev)->untrusted;
+}
+
+static inline bool dev_use_swiotlb(struct device *dev, size_t size,
+				   enum dma_data_direction dir)
+{
+	return IS_ENABLED(CONFIG_SWIOTLB) &&
+	       (dev_is_untrusted(dev) ||
+		dma_kmalloc_needs_bounce(dev, size, dir));
+}
+
 void *arch_dma_alloc(struct device *dev, size_t size, dma_addr_t *dma_handle,
 		gfp_t gfp, unsigned long attrs);
 void arch_dma_free(struct device *dev, size_t size, void *cpu_addr,
@@ -514,6 +528,8 @@ struct pci_p2pdma_map_state {
 enum pci_p2pdma_map_type
 pci_p2pdma_map_segment(struct pci_p2pdma_map_state *state, struct device *dev,
 		       struct scatterlist *sg);
+enum pci_p2pdma_map_type pci_p2pdma_map_type(struct dev_pagemap *pgmap,
+					     struct device *dev);
 #else /* CONFIG_PCI_P2PDMA */
 static inline enum pci_p2pdma_map_type
 pci_p2pdma_map_segment(struct pci_p2pdma_map_state *state, struct device *dev,
@@ -521,6 +537,11 @@ pci_p2pdma_map_segment(struct pci_p2pdma_map_state *state, struct device *dev,
 {
 	return PCI_P2PDMA_MAP_NOT_SUPPORTED;
 }
+static inline enum pci_p2pdma_map_type
+pci_p2pdma_map_type(struct dev_pagemap *pgmap, struct device *dev)
+{
+	return PCI_P2PDMA_MAP_NOT_SUPPORTED;
+}
 #endif /* CONFIG_PCI_P2PDMA */
 
 #endif /* _LINUX_DMA_MAP_OPS_H */
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 673ddcf140ff..9d1e020869a6 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -100,6 +100,11 @@ struct dma_iova_attrs {
 	unsigned long attrs;
 };
 
+struct dma_iova_state {
+	struct dma_iova_attrs *iova;
+	struct dma_memory_type *type;
+};
+
 #ifdef CONFIG_DMA_API_DEBUG
 void debug_dma_mapping_error(struct device *dev, dma_addr_t dma_addr);
 void debug_dma_map_single(struct device *dev, const void *addr,
@@ -178,6 +183,7 @@ int dma_mmap_noncontiguous(struct device *dev, struct vm_area_struct *vma,
 		size_t size, struct sg_table *sgt);
 
 void dma_get_memory_type(struct page *page, struct dma_memory_type *type);
+bool dma_can_use_iova(struct dma_iova_state *state, size_t size);
 #else /* CONFIG_HAS_DMA */
 static inline int dma_alloc_iova(struct dma_iova_attrs *iova)
 {
@@ -319,6 +325,10 @@ static inline void dma_get_memory_type(struct page *page,
 				       struct dma_memory_type *type)
 {
 }
+static inline bool dma_can_use_iova(struct dma_iova_state *state, size_t size)
+{
+	return false;
+}
 #endif /* CONFIG_HAS_DMA */
 
 #if defined(CONFIG_HAS_DMA) && defined(CONFIG_DMA_NEED_SYNC)
diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index 0c8f51010d08..9044ee525fdb 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -968,3 +968,35 @@ void dma_free_iova(struct dma_iova_attrs *iova)
 	ops->free_iova(dev, iova->addr, iova->size);
 }
 EXPORT_SYMBOL_GPL(dma_free_iova);
+
+/**
+ * dma_can_use_iova - check if the device type is valid
+ *                    and won't take SWIOTLB path
+ * @state: IOVA state
+ * @size: size of the buffer
+ *
+ * Return %true if the device should use swiotlb for the given buffer, else
+ * %false.
+ */
+bool dma_can_use_iova(struct dma_iova_state *state, size_t size)
+{
+	struct device *dev = state->iova->dev;
+	const struct dma_map_ops *ops = get_dma_ops(dev);
+	struct dma_memory_type *type = state->type;
+	enum pci_p2pdma_map_type map;
+
+	if (is_swiotlb_force_bounce(dev) ||
+	    dev_use_swiotlb(dev, size, state->iova->dir))
+		return false;
+
+	if (dma_map_direct(dev, ops) || !ops->alloc_iova)
+		return false;
+
+	if (type->type == DMA_MEMORY_TYPE_P2P) {
+		map = pci_p2pdma_map_type(type->p2p_pgmap, dev);
+		return map == PCI_P2PDMA_MAP_THRU_HOST_BRIDGE;
+	}
+
+	return type->type == DMA_MEMORY_TYPE_NORMAL;
+}
+EXPORT_SYMBOL_GPL(dma_can_use_iova);
-- 
2.45.2


