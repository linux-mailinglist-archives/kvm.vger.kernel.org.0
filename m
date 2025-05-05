Return-Path: <kvm+bounces-45400-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BE8BAA8CA5
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 09:03:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 133C718942C3
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 07:03:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C17A71E7640;
	Mon,  5 May 2025 07:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UBGiMsZh"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFD0A1D8E10;
	Mon,  5 May 2025 07:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746428533; cv=none; b=TyfTh1a3AMCIzLefXEOTc7pcRTB/6bG0tuvzAjduPzVIe6ee1xwFrjO9/ZJvDGan9ouh86NfS9rriJSofMex5hJzrOTIJ+60xSpzg6GGRMrY6aIKr75iSp8/eCsuXcIga5wB0SnwdwdkjfQYXj/KMQTjvNHCJzc6lYFk2yQWbuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746428533; c=relaxed/simple;
	bh=o2NB7hQ0vCeWU9CMSs4xzU9VH0loVcu8sfz5tFdLksQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VOSpL9O+dCV6JCKA9RyXQu3JnfEwlZRDyGEVn0Pu9cNWOlt40KqCa8eZCVl45RG5DL6FvqzwLG67B7czLH7Q1SmPfHNA/Z5cUmGKv2S1Yr80nGjCroq5iBLpMfJS97ejesbsoSGpmz1ecK45pE7jpn5A7NJyTDxbTbKAPuv1J7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UBGiMsZh; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3FFCC4CEE4;
	Mon,  5 May 2025 07:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746428532;
	bh=o2NB7hQ0vCeWU9CMSs4xzU9VH0loVcu8sfz5tFdLksQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UBGiMsZh02q0IoD7DcJfAn0JTe8JlE/bF1jWijDkcXehBGfgQlWXEfK2MGaYVCnkY
	 uIQvU/ZrvJxfwRR5xKU+wwFmUv6+snZL8RtB0jUjX3sR08O10SZGLqfU0JskElbLR2
	 AWNH2ZD0D2RbdOeK/004Ve1GIEUATFBa5dKFwrOtWGMieg3hofmZWduu8iNN1sWrW+
	 HY9XhMlDbNEBRFenHGtkXavdqEs/ojy9HvVxbqgtwoEp7gQcXVZgY31VOjyhA5Lh8X
	 JdYBapTiqH8tB/6LXgkwg10bbfjM+d6cV0JX1b952hhSsxW1g6GAxnkFsCMIFeIVWS
	 RtV7pZMkZGq9A==
From: Leon Romanovsky <leon@kernel.org>
To: 
Cc: Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>,
	Jake Edge <jake@lwn.net>,
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
	Chaitanya Kulkarni <kch@nvidia.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Leon Romanovsky <leonro@nvidia.com>
Subject: [PATCH v11 2/9] dma-mapping: move the PCI P2PDMA mapping helpers to pci-p2pdma.h
Date: Mon,  5 May 2025 10:01:39 +0300
Message-ID: <09b90e787d1bb16429642350515cf364cd92530f.1746424934.git.leon@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1746424934.git.leon@kernel.org>
References: <cover.1746424934.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

To support the upcoming non-scatterlist mapping helpers, we need to go
back to have them called outside of the DMA API.  Thus move them out of
dma-map-ops.h, which is only for DMA API implementations to pci-p2pdma.h,
which is for driver use.

Note that the core helper is still not exported as the mapping is
expected to be done only by very highlevel subsystem code at least for
now.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/iommu/dma-iommu.c   |  1 +
 include/linux/dma-map-ops.h | 85 -------------------------------------
 include/linux/pci-p2pdma.h  | 85 +++++++++++++++++++++++++++++++++++++
 kernel/dma/direct.c         |  1 +
 4 files changed, 87 insertions(+), 85 deletions(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 8a89e63c5973..9ba8d8bc0ce9 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -27,6 +27,7 @@
 #include <linux/msi.h>
 #include <linux/of_iommu.h>
 #include <linux/pci.h>
+#include <linux/pci-p2pdma.h>
 #include <linux/scatterlist.h>
 #include <linux/spinlock.h>
 #include <linux/swiotlb.h>
diff --git a/include/linux/dma-map-ops.h b/include/linux/dma-map-ops.h
index c3086edeccc6..f48e5fb88bd5 100644
--- a/include/linux/dma-map-ops.h
+++ b/include/linux/dma-map-ops.h
@@ -434,89 +434,4 @@ static inline void debug_dma_dump_mappings(struct device *dev)
 #endif /* CONFIG_DMA_API_DEBUG */
 
 extern const struct dma_map_ops dma_dummy_ops;
-
-enum pci_p2pdma_map_type {
-	/*
-	 * PCI_P2PDMA_MAP_UNKNOWN: Used internally for indicating the mapping
-	 * type hasn't been calculated yet. Functions that return this enum
-	 * never return this value.
-	 */
-	PCI_P2PDMA_MAP_UNKNOWN = 0,
-
-	/*
-	 * Not a PCI P2PDMA transfer.
-	 */
-	PCI_P2PDMA_MAP_NONE,
-
-	/*
-	 * PCI_P2PDMA_MAP_NOT_SUPPORTED: Indicates the transaction will
-	 * traverse the host bridge and the host bridge is not in the
-	 * allowlist. DMA Mapping routines should return an error when
-	 * this is returned.
-	 */
-	PCI_P2PDMA_MAP_NOT_SUPPORTED,
-
-	/*
-	 * PCI_P2PDMA_BUS_ADDR: Indicates that two devices can talk to
-	 * each other directly through a PCI switch and the transaction will
-	 * not traverse the host bridge. Such a mapping should program
-	 * the DMA engine with PCI bus addresses.
-	 */
-	PCI_P2PDMA_MAP_BUS_ADDR,
-
-	/*
-	 * PCI_P2PDMA_MAP_THRU_HOST_BRIDGE: Indicates two devices can talk
-	 * to each other, but the transaction traverses a host bridge on the
-	 * allowlist. In this case, a normal mapping either with CPU physical
-	 * addresses (in the case of dma-direct) or IOVA addresses (in the
-	 * case of IOMMUs) should be used to program the DMA engine.
-	 */
-	PCI_P2PDMA_MAP_THRU_HOST_BRIDGE,
-};
-
-struct pci_p2pdma_map_state {
-	struct dev_pagemap *pgmap;
-	enum pci_p2pdma_map_type map;
-	u64 bus_off;
-};
-
-/* helper for pci_p2pdma_state(), do not use directly */
-void __pci_p2pdma_update_state(struct pci_p2pdma_map_state *state,
-		struct device *dev, struct page *page);
-
-/**
- * pci_p2pdma_state - check the P2P transfer state of a page
- * @state:	P2P state structure
- * @dev:	device to transfer to/from
- * @page:	page to map
- *
- * Check if @page is a PCI P2PDMA page, and if yes of what kind.  Returns the
- * map type, and updates @state with all information needed for a P2P transfer.
- */
-static inline enum pci_p2pdma_map_type
-pci_p2pdma_state(struct pci_p2pdma_map_state *state, struct device *dev,
-		struct page *page)
-{
-	if (IS_ENABLED(CONFIG_PCI_P2PDMA) && is_pci_p2pdma_page(page)) {
-		if (state->pgmap != page_pgmap(page))
-			__pci_p2pdma_update_state(state, dev, page);
-		return state->map;
-	}
-	return PCI_P2PDMA_MAP_NONE;
-}
-
-/**
- * pci_p2pdma_bus_addr_map - map a PCI_P2PDMA_MAP_BUS_ADDR P2P transfer
- * @state:	P2P state structure
- * @paddr:	physical address to map
- *
- * Map a physically contiguous PCI_P2PDMA_MAP_BUS_ADDR transfer.
- */
-static inline dma_addr_t
-pci_p2pdma_bus_addr_map(struct pci_p2pdma_map_state *state, phys_addr_t paddr)
-{
-	WARN_ON_ONCE(state->map != PCI_P2PDMA_MAP_BUS_ADDR);
-	return paddr + state->bus_off;
-}
-
 #endif /* _LINUX_DMA_MAP_OPS_H */
diff --git a/include/linux/pci-p2pdma.h b/include/linux/pci-p2pdma.h
index 2c07aa6b7665..075c20b161d9 100644
--- a/include/linux/pci-p2pdma.h
+++ b/include/linux/pci-p2pdma.h
@@ -104,4 +104,89 @@ static inline struct pci_dev *pci_p2pmem_find(struct device *client)
 	return pci_p2pmem_find_many(&client, 1);
 }
 
+enum pci_p2pdma_map_type {
+	/*
+	 * PCI_P2PDMA_MAP_UNKNOWN: Used internally as an initial state before
+	 * the mapping type has been calculated. Exported routines for the API
+	 * will never return this value.
+	 */
+	PCI_P2PDMA_MAP_UNKNOWN = 0,
+
+	/*
+	 * Not a PCI P2PDMA transfer.
+	 */
+	PCI_P2PDMA_MAP_NONE,
+
+	/*
+	 * PCI_P2PDMA_MAP_NOT_SUPPORTED: Indicates the transaction will
+	 * traverse the host bridge and the host bridge is not in the
+	 * allowlist. DMA Mapping routines should return an error when
+	 * this is returned.
+	 */
+	PCI_P2PDMA_MAP_NOT_SUPPORTED,
+
+	/*
+	 * PCI_P2PDMA_MAP_BUS_ADDR: Indicates that two devices can talk to
+	 * each other directly through a PCI switch and the transaction will
+	 * not traverse the host bridge. Such a mapping should program
+	 * the DMA engine with PCI bus addresses.
+	 */
+	PCI_P2PDMA_MAP_BUS_ADDR,
+
+	/*
+	 * PCI_P2PDMA_MAP_THRU_HOST_BRIDGE: Indicates two devices can talk
+	 * to each other, but the transaction traverses a host bridge on the
+	 * allowlist. In this case, a normal mapping either with CPU physical
+	 * addresses (in the case of dma-direct) or IOVA addresses (in the
+	 * case of IOMMUs) should be used to program the DMA engine.
+	 */
+	PCI_P2PDMA_MAP_THRU_HOST_BRIDGE,
+};
+
+struct pci_p2pdma_map_state {
+	struct dev_pagemap *pgmap;
+	enum pci_p2pdma_map_type map;
+	u64 bus_off;
+};
+
+/* helper for pci_p2pdma_state(), do not use directly */
+void __pci_p2pdma_update_state(struct pci_p2pdma_map_state *state,
+		struct device *dev, struct page *page);
+
+/**
+ * pci_p2pdma_state - check the P2P transfer state of a page
+ * @state:	P2P state structure
+ * @dev:	device to transfer to/from
+ * @page:	page to map
+ *
+ * Check if @page is a PCI P2PDMA page, and if yes of what kind.  Returns the
+ * map type, and updates @state with all information needed for a P2P transfer.
+ */
+static inline enum pci_p2pdma_map_type
+pci_p2pdma_state(struct pci_p2pdma_map_state *state, struct device *dev,
+		struct page *page)
+{
+	if (IS_ENABLED(CONFIG_PCI_P2PDMA) && is_pci_p2pdma_page(page)) {
+		if (state->pgmap != page_pgmap(page))
+			__pci_p2pdma_update_state(state, dev, page);
+		return state->map;
+	}
+	return PCI_P2PDMA_MAP_NONE;
+}
+
+/**
+ * pci_p2pdma_bus_addr_map - Translate a physical address to a bus address
+ *			     for a PCI_P2PDMA_MAP_BUS_ADDR transfer.
+ * @state:	P2P state structure
+ * @paddr:	physical address to map
+ *
+ * Map a physically contiguous PCI_P2PDMA_MAP_BUS_ADDR transfer.
+ */
+static inline dma_addr_t
+pci_p2pdma_bus_addr_map(struct pci_p2pdma_map_state *state, phys_addr_t paddr)
+{
+	WARN_ON_ONCE(state->map != PCI_P2PDMA_MAP_BUS_ADDR);
+	return paddr + state->bus_off;
+}
+
 #endif /* _LINUX_PCI_P2P_H */
diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index cec43cd5ed62..24c359d9c879 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -13,6 +13,7 @@
 #include <linux/vmalloc.h>
 #include <linux/set_memory.h>
 #include <linux/slab.h>
+#include <linux/pci-p2pdma.h>
 #include "direct.h"
 
 /*
-- 
2.49.0


