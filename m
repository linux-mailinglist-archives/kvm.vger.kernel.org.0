Return-Path: <kvm+bounces-26691-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1ED84976777
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 13:19:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3DF9A1C214AD
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 11:19:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA5731AC42B;
	Thu, 12 Sep 2024 11:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="utilRRP5"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D21291A2631;
	Thu, 12 Sep 2024 11:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726139798; cv=none; b=oRyZ0hOsYFT7Ny9R1+hOJ9LYLnYS0jgblJgikJFX7VERaxaYc/Ny3lc3JFqYVtgX0bJhmcNy+RSZsLhcJv4AufiYUQquQ+1Oy8SkvDtDvXSMfvM8WDAcNtuOeswsGb1TorM5HKYugnh67RsOcxcrXuwA8hC7pWrMKFZCDnMNI28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726139798; c=relaxed/simple;
	bh=HCbYGqX249833/tdiRDBvFBjeuSolO9rH8wFEsCHmuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YdKnbLxAeyLXcSNF88gJNauvqRfctOqXiDQIAn8xPTBIGDTijzq4lztCRLb38JmfdPyH9sXcrbOz5MCm0sbhqyM9ziSjnhkjzyXllDLUHrk8qPk9fzecsBjhy9U9spgeyrM+1c3jQpEzggquwKg8Hhtk1YVGr/LGpbuNlWgVO18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=utilRRP5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95168C4CEC5;
	Thu, 12 Sep 2024 11:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726139797;
	bh=HCbYGqX249833/tdiRDBvFBjeuSolO9rH8wFEsCHmuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=utilRRP5yDc5niZQdTcTGnzCnlrPS0S4L3Hb9vq/XwpoQFI0AVDbejOe0Qo42RRZR
	 KkYQDJw1ZBH1+GhREn9IO3Aft1IbL0WfEet5f0emPRe8iuqT8w2AFuYT9rawGzAivh
	 cQxvsrrXrX2aswijqPZVgD9EpT7cf20gG1iWYXmqsE07Ej+8c8FKOF4tQuWco24nd1
	 2lGYnudAW1yc+NprinXcSsQXcnqPmKubTJyZY5LKaiOnVKB5gOk1fdSCFyV62ullq/
	 IqZxh1M1CLXFDX8nzGm4+Sy2BP2yjU9370wTj3+xV+5K9S+8gyJXtfhxEhlqM50c+P
	 tzPreaeQDm/dA==
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
Cc: Leon Romanovsky <leonro@nvidia.com>,
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
Subject: [RFC v2 09/21] dma-mapping: provide callbacks to link/unlink HMM PFNs to specific IOVA
Date: Thu, 12 Sep 2024 14:15:44 +0300
Message-ID: <da109f6b14b969e9812f2dc92d43ba8e7273c60d.1726138681.git.leon@kernel.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1726138681.git.leon@kernel.org>
References: <cover.1726138681.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

Introduce new DMA link/unlink API to provide a way for HMM users to link
pages to already preallocated IOVA.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/linux/dma-mapping.h |  15 ++++++
 kernel/dma/mapping.c        | 102 ++++++++++++++++++++++++++++++++++++
 2 files changed, 117 insertions(+)

diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index bb541f8944e5..8c2a468c5420 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -123,6 +123,10 @@ static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 int dma_alloc_iova_unaligned(struct dma_iova_state *state, phys_addr_t phys,
 			     size_t size);
 void dma_free_iova(struct dma_iova_state *state);
+dma_addr_t dma_hmm_link_page(struct dma_iova_state *state, unsigned long *pfn,
+			     dma_addr_t dma_offset);
+void dma_hmm_unlink_page(struct dma_iova_state *state, unsigned long *pfn,
+			 dma_addr_t dma_offset);
 
 dma_addr_t dma_map_page_attrs(struct device *dev, struct page *page,
 		size_t offset, size_t size, enum dma_data_direction dir,
@@ -189,6 +193,17 @@ static inline int dma_alloc_iova_unaligned(struct dma_iova_state *state,
 static inline void dma_free_iova(struct dma_iova_state *state)
 {
 }
+static inline dma_addr_t dma_hmm_link_page(struct dma_iova_state *state,
+					   unsigned long *pfn,
+					   dma_addr_t dma_offset)
+{
+	return DMA_MAPPING_ERROR;
+}
+static inline void dma_hmm_unlink_page(struct dma_iova_state *state,
+				       unsigned long *pfn,
+				       dma_addr_t dma_offset)
+{
+}
 static inline dma_addr_t dma_map_page_attrs(struct device *dev,
 		struct page *page, size_t offset, size_t size,
 		enum dma_data_direction dir, unsigned long attrs)
diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index 39fac8c21643..5354ddc3ac03 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -17,6 +17,7 @@
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <linux/cc_platform.h>
+#include <linux/hmm.h>
 #include "debug.h"
 #include "direct.h"
 
@@ -1084,3 +1085,104 @@ void dma_unlink_range_attrs(struct dma_iova_state *state, unsigned long attrs)
 			       state->dir, attrs);
 }
 EXPORT_SYMBOL_GPL(dma_unlink_range_attrs);
+
+/**
+ * dma_hmm_link_page - Link a physical HMM page to DMA address
+ * @state: IOVA state
+ * @pfn: HMM PFN
+ * @dma_offset: DMA offset form which this page needs to be linked
+ *
+ * dma_alloc_iova() allocates IOVA based on the size specified by their use in
+ * iova->size. Call this function after IOVA allocation to link whole @page
+ * to get the DMA address. Note that very first call to this function
+ * will have @dma_offset set to 0 in the IOVA space allocated from
+ * dma_alloc_iova(). For subsequent calls to this function on same @iova,
+ * @dma_offset needs to be advanced by the caller with the size of previous
+ * page that was linked + DMA address returned for the previous page that was
+ * linked by this function.
+ */
+dma_addr_t dma_hmm_link_page(struct dma_iova_state *state, unsigned long *pfn,
+			     dma_addr_t dma_offset)
+{
+	struct device *dev = state->dev;
+	struct page *page = hmm_pfn_to_page(*pfn);
+	phys_addr_t phys = page_to_phys(page);
+	bool coherent = dev_is_dma_coherent(dev);
+	dma_addr_t addr;
+	int ret;
+
+	if (*pfn & HMM_PFN_DMA_MAPPED)
+		/*
+		 * We are in this flow when there is a need to resync flags,
+		 * for example when page was already linked in prefetch call
+		 * with READ flag and now we need to add WRITE flag
+		 *
+		 * This page was already programmed to HW and we don't want/need
+		 * to unlink and link it again just to resync flags.
+		 *
+		 * The DMA address calculation below is based on the fact that
+		 * HMM doesn't work with swiotlb.
+		 */
+		return (state->addr) ? state->addr + dma_offset :
+				       phys_to_dma(dev, phys);
+
+	state->range_size = dma_offset;
+
+	/*
+	 * The below check is based on assumption that HMM range users
+	 * don't work with swiotlb and hence can be or in direct mode
+	 * or in IOMMU mode.
+	 */
+	if (!use_dma_iommu(dev)) {
+		if (!coherent)
+			arch_sync_dma_for_device(phys, PAGE_SIZE, state->dir);
+
+		addr = phys_to_dma(dev, phys);
+		goto done;
+	}
+
+	ret = dma_start_range(state);
+	if (ret)
+		return DMA_MAPPING_ERROR;
+
+	addr = dma_link_range(state, phys, PAGE_SIZE);
+	dma_end_range(state);
+	if (dma_mapping_error(state->dev, addr))
+		return addr;
+
+done:
+	kmsan_handle_dma(page, 0, PAGE_SIZE, state->dir);
+	*pfn |= HMM_PFN_DMA_MAPPED;
+	return addr;
+}
+EXPORT_SYMBOL_GPL(dma_hmm_link_page);
+
+/**
+ * dma_hmm_unlink_page - Unlink a physical HMM page from DMA address
+ * @state: IOVA state
+ * @pfn: HMM PFN
+ * @dma_offset: DMA offset form which this page needs to be unlinked
+ *              from the IOVA space
+ */
+void dma_hmm_unlink_page(struct dma_iova_state *state, unsigned long *pfn,
+			 dma_addr_t dma_offset)
+{
+	struct device *dev = state->dev;
+	struct page *page;
+	phys_addr_t phys;
+
+	*pfn &= ~HMM_PFN_DMA_MAPPED;
+
+	if (!use_dma_iommu(dev)) {
+		page = hmm_pfn_to_page(*pfn);
+		phys = page_to_phys(page);
+
+		dma_direct_sync_single_for_cpu(dev, phys_to_dma(dev, phys),
+					       PAGE_SIZE, state->dir);
+		return;
+	}
+
+	iommu_dma_unlink_range(dev, state->addr + dma_offset, PAGE_SIZE,
+			       state->dir, 0);
+}
+EXPORT_SYMBOL_GPL(dma_hmm_unlink_page);
-- 
2.46.0


