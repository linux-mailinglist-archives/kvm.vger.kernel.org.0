Return-Path: <kvm+bounces-20832-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B2F5F923953
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 11:13:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6DC84284F93
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 09:13:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDF2815CD7D;
	Tue,  2 Jul 2024 09:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YYKS1Ot/"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D5615445D;
	Tue,  2 Jul 2024 09:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719911434; cv=none; b=p9Qj2HlUMhyxn1jUIkAf1hHAX5qOMYxSV6wbEaNv9wH2EgFaovaVMX4PspIKpSqQKLlXpvncArhJrsS6vU4Q3us30a4Xp4RPJzFV/6wtx0Hpu5sbQQulCXvLQ1AExb5WCgN4gy8GlfxQ6gGfVYEG8dTBgHegBYajR28cYSw7rnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719911434; c=relaxed/simple;
	bh=0ck5rd5jPLMOP1nHX+50lNZNnmmRrxabk/SQIbsa6U4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tSvHCDVfWf6h+pqyAmdGraPAF8MRBkUAcKDmUy1D+dUt8zo3OHtrJDZM7F+H5gIWlTjT7UrcLxBYfLBbKva5zilmoRDrfs2UmuqbCirVZ10puoSqg5/UNJAxY/WOIPcx9DbbMz7SIeZaiRS+XZ7SSgDpUClVd/IKA7Y8WT7YuGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YYKS1Ot/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD899C4AF0A;
	Tue,  2 Jul 2024 09:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719911433;
	bh=0ck5rd5jPLMOP1nHX+50lNZNnmmRrxabk/SQIbsa6U4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YYKS1Ot/toIO1bChF3hjNIXQnLRGAFZW60cYZGmLLcwlJGabkFTKyyB9S4UjzMRw4
	 OWdB+gcPZfiFupAaORoIq2eLPt1FH+wTYrENPy5qAeVHARSxgi1nIntNE+I24Dz9VP
	 HGwRhb2VAiNoV6XRMQ24UVg2ee/gd+HohgenhbH1Ffqm3bb0/puHq59LU7IGpEL/vk
	 sVPeLGHK/A9Eqt9VnWOf9HrTGNvjmQUyWmuLi3tGXthIBjVPGtIFwFF4zX749XQYhs
	 NGGEjZMQlBISbiHromVsoVz6nukh5hle9SkHC3Rj4ksdesgD1SzycXc0OVeUTNAhcG
	 ADXWSXiEd0N1A==
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
Subject: [RFC PATCH v1 04/18] dma-mapping: implement link range API
Date: Tue,  2 Jul 2024 12:09:34 +0300
Message-ID: <8944a1211b243fed1234a56bc8004a11dbf85a87.1719909395.git.leon@kernel.org>
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

Introduce new DMA APIs to perform DMA linkage of buffers
in layers higher than DMA.

In proposed API, the callers will perform the following steps:
dma_alloc_iova()
if (dma_can_use_iova(...))
  dma_start_range(...)
  for (page in range)
     dma_link_range(...)
  dma_end_range(...)
else
  /* Fallback to legacy map pages */
  dma_map_page(...)

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/linux/dma-map-ops.h |  6 +++
 include/linux/dma-mapping.h | 22 +++++++++++
 kernel/dma/mapping.c        | 78 ++++++++++++++++++++++++++++++++++++-
 3 files changed, 105 insertions(+), 1 deletion(-)

diff --git a/include/linux/dma-map-ops.h b/include/linux/dma-map-ops.h
index b52e9c8db241..4868586b015e 100644
--- a/include/linux/dma-map-ops.h
+++ b/include/linux/dma-map-ops.h
@@ -90,6 +90,12 @@ struct dma_map_ops {
 
 	dma_addr_t (*alloc_iova)(struct device *dev, size_t size);
 	void (*free_iova)(struct device *dev, dma_addr_t dma_addr, size_t size);
+	int (*link_range)(struct dma_iova_state *state, phys_addr_t phys,
+			  dma_addr_t addr, size_t size);
+	void (*unlink_range)(struct dma_iova_state *state,
+			     dma_addr_t dma_handle, size_t size);
+	int (*start_range)(struct dma_iova_state *state);
+	void (*end_range)(struct dma_iova_state *state);
 };
 
 #ifdef CONFIG_DMA_OPS
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 9d1e020869a6..c530095ff232 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -11,6 +11,7 @@
 #include <linux/scatterlist.h>
 #include <linux/bug.h>
 #include <linux/mem_encrypt.h>
+#include <linux/iommu.h>
 
 /**
  * List of possible attributes associated with a DMA mapping. The semantics
@@ -103,6 +104,8 @@ struct dma_iova_attrs {
 struct dma_iova_state {
 	struct dma_iova_attrs *iova;
 	struct dma_memory_type *type;
+	struct iommu_domain *domain;
+	size_t range_size;
 };
 
 #ifdef CONFIG_DMA_API_DEBUG
@@ -184,6 +187,10 @@ int dma_mmap_noncontiguous(struct device *dev, struct vm_area_struct *vma,
 
 void dma_get_memory_type(struct page *page, struct dma_memory_type *type);
 bool dma_can_use_iova(struct dma_iova_state *state, size_t size);
+int dma_start_range(struct dma_iova_state *state);
+void dma_end_range(struct dma_iova_state *state);
+int dma_link_range(struct dma_iova_state *state, phys_addr_t phys, size_t size);
+void dma_unlink_range(struct dma_iova_state *state);
 #else /* CONFIG_HAS_DMA */
 static inline int dma_alloc_iova(struct dma_iova_attrs *iova)
 {
@@ -329,6 +336,21 @@ static inline bool dma_can_use_iova(struct dma_iova_state *state, size_t size)
 {
 	return false;
 }
+static inline int dma_start_range(struct dma_iova_state *state)
+{
+	return -EOPNOTSUPP;
+}
+static inline void dma_end_range(struct dma_iova_state *state)
+{
+}
+static inline int dma_link_range(struct dma_iova_state *state, phys_addr_t phys,
+				 size_t size)
+{
+	return -EOPNOTSUPP;
+}
+static inline void dma_unlink_range(struct dma_iova_state *state)
+{
+}
 #endif /* CONFIG_HAS_DMA */
 
 #if defined(CONFIG_HAS_DMA) && defined(CONFIG_DMA_NEED_SYNC)
diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index 9044ee525fdb..089b4a977bab 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -989,7 +989,8 @@ bool dma_can_use_iova(struct dma_iova_state *state, size_t size)
 	    dev_use_swiotlb(dev, size, state->iova->dir))
 		return false;
 
-	if (dma_map_direct(dev, ops) || !ops->alloc_iova)
+	if (dma_map_direct(dev, ops) || !ops->alloc_iova || !ops->link_range ||
+	    !ops->start_range)
 		return false;
 
 	if (type->type == DMA_MEMORY_TYPE_P2P) {
@@ -1000,3 +1001,78 @@ bool dma_can_use_iova(struct dma_iova_state *state, size_t size)
 	return type->type == DMA_MEMORY_TYPE_NORMAL;
 }
 EXPORT_SYMBOL_GPL(dma_can_use_iova);
+
+/**
+ * dma_start_range - Start a range of IOVA space
+ * @state: IOVA state
+ *
+ * Start a range of IOVA space for the given IOVA state.
+ */
+int dma_start_range(struct dma_iova_state *state)
+{
+	struct device *dev = state->iova->dev;
+	const struct dma_map_ops *ops = get_dma_ops(dev);
+
+	if (!ops->start_range)
+		return 0;
+
+	return ops->start_range(state);
+}
+EXPORT_SYMBOL_GPL(dma_start_range);
+
+/**
+ * dma_end_range - End a range of IOVA space
+ * @state: IOVA state
+ *
+ * End a range of IOVA space for the given IOVA state.
+ */
+void dma_end_range(struct dma_iova_state *state)
+{
+	struct device *dev = state->iova->dev;
+	const struct dma_map_ops *ops = get_dma_ops(dev);
+
+	if (!ops->end_range)
+		return;
+
+	ops->end_range(state);
+}
+EXPORT_SYMBOL_GPL(dma_end_range);
+
+/**
+ * dma_link_range - Link a range of IOVA space
+ * @state: IOVA state
+ * @phys: physical address to link
+ * @size: size of the buffer
+ *
+ * Link a range of IOVA space for the given IOVA state.
+ */
+int dma_link_range(struct dma_iova_state *state, phys_addr_t phys, size_t size)
+{
+	struct device *dev = state->iova->dev;
+	dma_addr_t addr = state->iova->addr + state->range_size;
+	const struct dma_map_ops *ops = get_dma_ops(dev);
+	int ret;
+
+	ret = ops->link_range(state, phys, addr, size);
+	if (ret)
+		return ret;
+
+	state->range_size += size;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dma_link_range);
+
+/**
+ * dma_unlink_range - Unlink a range of IOVA space
+ * @state: IOVA state
+ *
+ * Unlink a range of IOVA space for the given IOVA state.
+ */
+void dma_unlink_range(struct dma_iova_state *state)
+{
+	struct device *dev = state->iova->dev;
+	const struct dma_map_ops *ops = get_dma_ops(dev);
+
+	ops->unlink_range(state, state->iova->addr, state->range_size);
+}
+EXPORT_SYMBOL_GPL(dma_unlink_range);
-- 
2.45.2


