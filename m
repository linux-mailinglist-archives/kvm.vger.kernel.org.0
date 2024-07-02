Return-Path: <kvm+bounces-20829-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E7AB923942
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 11:12:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B615D1C2180E
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 09:12:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D9B5158DD4;
	Tue,  2 Jul 2024 09:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B0P6xSie"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61D38152DF1;
	Tue,  2 Jul 2024 09:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719911421; cv=none; b=MZYtaARbHtyOVI5amA2tT1YQzIp/CTwztMSev+Ytrj/0Kx3osE4NadCBBzrrmEAOkag2iqcwbRud25a4no3qQCXVCgGSMjsfEVauxtYjdmFahCSntqB/v88KXYDmq8nfwCVKHKP+AmdZy3W1FnWCtjlgU3iK8xL5R6Qs01xfbbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719911421; c=relaxed/simple;
	bh=SqRJkswAXpWAsD53KsFAbDwitxXp1HHK8jZehp+jNVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=slqbCwC5qULopmY9+Jd6zuLTPZSxwA3s9BE0W+PLBGBS9h2B28nEUR7kXDv2F0s6UwoCyge40OnkO3yupoCkluMyJkAbksJI8yEh5W8rG/HovQRoLNkBDk8/zpY7/V1xnUdBQ8EpYXcN8BTGJ0ndVWbpz+EtGzP8WaustzYJTRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B0P6xSie; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26C0AC4AF0D;
	Tue,  2 Jul 2024 09:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719911420;
	bh=SqRJkswAXpWAsD53KsFAbDwitxXp1HHK8jZehp+jNVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B0P6xSien3K1c31vVmNKC6qS649bWpjI5mYxXWH8emcmDGg2eigH8FA2DdzWikUeV
	 OTGCsKzhgCxVn0yFExmtnvDeYvSdw03wWMH3YCkE0Is5H/+FrihVahL3vShxIXpt5H
	 ekIE/hI3wHawgVD7zRlm3769EJWxwN6cjJq9LjWDY8CwX07zGC8TIt4ox3kCloi44h
	 8tByePaihSYoAZbPDlvArG+KbAuvnYoS6wLwWd3uqYtGr/qXHBBtoAFke7v4CagF12
	 +Ba7rdX8nQKBDA4nkUOmts95lMSEr2/fvOG5MxU0r8Xs/bA45+3GA81F9bXChbQUkP
	 XrFGs/s9NsLMw==
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
Subject: [RFC PATCH v1 06/18] dma-mapping: provide callbacks to link/unlink HMM PFNs to specific IOVA
Date: Tue,  2 Jul 2024 12:09:36 +0300
Message-ID: <d0712e7733a64165d9c874d86720cde6aa88a3ba.1719909395.git.leon@kernel.org>
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

From: Leon Romanovsky <leonro@nvidia.com>

Introduce new DMA link/unlink API to provide a way for HMM users to link
pages to already preallocated IOVA.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/linux/dma-mapping.h |  15 +++++
 kernel/dma/mapping.c        | 108 ++++++++++++++++++++++++++++++++++++
 2 files changed, 123 insertions(+)

diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index c530095ff232..2578b6615a2f 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -135,6 +135,10 @@ static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 
 int dma_alloc_iova(struct dma_iova_attrs *iova);
 void dma_free_iova(struct dma_iova_attrs *iova);
+dma_addr_t dma_hmm_link_page(unsigned long *pfn, struct dma_iova_attrs *iova,
+			     dma_addr_t dma_offset);
+void dma_hmm_unlink_page(unsigned long *pfn, struct dma_iova_attrs *iova,
+			 dma_addr_t dma_offset);
 
 dma_addr_t dma_map_page_attrs(struct device *dev, struct page *page,
 		size_t offset, size_t size, enum dma_data_direction dir,
@@ -199,6 +203,17 @@ static inline int dma_alloc_iova(struct dma_iova_attrs *iova)
 static inline void dma_free_iova(struct dma_iova_attrs *iova)
 {
 }
+static inline dma_addr_t dma_hmm_link_page(unsigned long *pfn,
+					   struct dma_iova_attrs *iova,
+					   dma_addr_t dma_offset)
+{
+	return DMA_MAPPING_ERROR;
+}
+static inline void dma_hmm_unlink_page(unsigned long *pfn,
+				       struct dma_iova_attrs *iova,
+				       dma_addr_t dma_offset)
+{
+}
 static inline dma_addr_t dma_map_page_attrs(struct device *dev,
 		struct page *page, size_t offset, size_t size,
 		enum dma_data_direction dir, unsigned long attrs)
diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index 089b4a977bab..69c431bd89e6 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -16,6 +16,7 @@
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <linux/cc_platform.h>
+#include <linux/hmm.h>
 #include "debug.h"
 #include "direct.h"
 
@@ -1076,3 +1077,110 @@ void dma_unlink_range(struct dma_iova_state *state)
 	ops->unlink_range(state, state->iova->addr, state->range_size);
 }
 EXPORT_SYMBOL_GPL(dma_unlink_range);
+
+/**
+ * dma_hmm_link_page - Link a physical HMM page to DMA address
+ * @pfn: HMM PFN
+ * @iova: Preallocated IOVA space
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
+dma_addr_t dma_hmm_link_page(unsigned long *pfn, struct dma_iova_attrs *iova,
+			     dma_addr_t dma_offset)
+{
+	struct device *dev = iova->dev;
+	struct page *page = hmm_pfn_to_page(*pfn);
+	phys_addr_t phys = page_to_phys(page);
+	bool coherent = dev_is_dma_coherent(dev);
+	struct dma_memory_type type = {};
+	struct dma_iova_state state = {};
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
+		return (iova->addr) ? iova->addr + dma_offset :
+				      phys_to_dma(dev, phys);
+
+	dma_get_memory_type(page, &type);
+
+	state.iova = iova;
+	state.type = &type;
+	state.range_size = dma_offset;
+
+	if (!dma_can_use_iova(&state, PAGE_SIZE)) {
+		if (!coherent && !(iova->attrs & DMA_ATTR_SKIP_CPU_SYNC))
+			arch_sync_dma_for_device(phys, PAGE_SIZE, iova->dir);
+
+		addr = phys_to_dma(dev, phys);
+		goto done;
+	}
+
+	ret = dma_start_range(&state);
+	if (ret)
+		return DMA_MAPPING_ERROR;
+
+	ret = dma_link_range(&state, page_to_phys(page), PAGE_SIZE);
+	dma_end_range(&state);
+	if (ret)
+		return DMA_MAPPING_ERROR;
+
+	addr = iova->addr + dma_offset;
+done:
+	kmsan_handle_dma(page, 0, PAGE_SIZE, iova->dir);
+	*pfn |= HMM_PFN_DMA_MAPPED;
+	return addr;
+}
+EXPORT_SYMBOL_GPL(dma_hmm_link_page);
+
+/**
+ * dma_hmm_unlink_page - Unlink a physical HMM page from DMA address
+ * @pfn: HMM PFN
+ * @iova: Preallocated IOVA space
+ * @dma_offset: DMA offset form which this page needs to be unlinked
+ *              from the IOVA space
+ */
+void dma_hmm_unlink_page(unsigned long *pfn, struct dma_iova_attrs *iova,
+			 dma_addr_t dma_offset)
+{
+	struct device *dev = iova->dev;
+	struct page *page = hmm_pfn_to_page(*pfn);
+	struct dma_memory_type type = {};
+	struct dma_iova_state state = {};
+	const struct dma_map_ops *ops = get_dma_ops(dev);
+
+	dma_get_memory_type(page, &type);
+
+	state.iova = iova;
+	state.type = &type;
+
+	*pfn &= ~HMM_PFN_DMA_MAPPED;
+
+	if (!dma_can_use_iova(&state, PAGE_SIZE)) {
+		if (!(iova->attrs & DMA_ATTR_SKIP_CPU_SYNC))
+			dma_direct_sync_single_for_cpu(dev, dma_offset,
+						       PAGE_SIZE, iova->dir);
+		return;
+	}
+
+	ops->unlink_range(&state, state.iova->addr + dma_offset, PAGE_SIZE);
+}
+EXPORT_SYMBOL_GPL(dma_hmm_unlink_page);
-- 
2.45.2


