Return-Path: <kvm+bounces-10928-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E636871B7F
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 11:36:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 819B31C21801
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 10:36:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 188735D900;
	Tue,  5 Mar 2024 10:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KKkfs5K6"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F3415D8E5;
	Tue,  5 Mar 2024 10:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709634160; cv=none; b=Yq4j1G09Qs4khksFQ2cVo8dtrWq5Gjp2jpC8JQGA+3UTscBCWkrARdUhlP3VQg17ENbgbz1czYtdMge11nH8+y08cmaR4pJHZgsyUNo7P/aPrKmsdd4MJioPzzoXMUFE/B4niCQ5bN0YTN6iomEH1OoMtyB14w3o1Ny4JX5LA0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709634160; c=relaxed/simple;
	bh=qAJEud8zSEtY+UaYfguXl0FuNLhyjwr4jvzS2H85FiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AlDJFn1G4GUJmalPD0kkvWA9lq5mUdyAitEV0jbAhq3AcNweDzkoZFnZ6ONaO4qUti2tvu3V3u4ctqNNgIV0krpW84wOYI0iIgOYBfV9OmsEFO2yA+1+q7dNbtn3DV6o9oX2iBRZR7unle81c1iT3fRh52WiulxBCc6UJs5huyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KKkfs5K6; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02FC0C43394;
	Tue,  5 Mar 2024 10:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709634159;
	bh=qAJEud8zSEtY+UaYfguXl0FuNLhyjwr4jvzS2H85FiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KKkfs5K6bbKu2QVdVHjPDjmXgHNBNCMOyLW0Y6jg4rVH1rLeeNs1fvf/qtvkpJFsl
	 emNFc5PsisGcGAdsQAmrneaf4WN6IZljPhm+EBmPmF7JdC8jYLF6mvaxwZXzgxUPWw
	 YE2Wrgnkji7uT1y4mek2atAgLLNV/tk/9x5KWRPwqJQxGACLGPgvvsFnapU9eIU+hm
	 4i5aXoDmIo/akYoP74kx20fjjwmkwcV2Bjf7Dk2nV9SUDMS/FkMXVtj4XkSp5Nf5bY
	 rqx0YxGea1dHuPCy0StUnXsQ5aIfjD7PbI41Rh2zj3nza69crWqmZ8qgBqbNIXZipP
	 SmSqxTbBq548g==
From: Leon Romanovsky <leon@kernel.org>
To: Christoph Hellwig <hch@lst.de>,
	Robin Murphy <robin.murphy@arm.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Chaitanya Kulkarni <chaitanyak@nvidia.com>
Cc: Leon Romanovsky <leonro@nvidia.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
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
	kvm@vger.kernel.org,
	linux-mm@kvack.org,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Amir Goldstein <amir73il@gmail.com>,
	"josef@toxicpanda.com" <josef@toxicpanda.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"daniel@iogearbox.net" <daniel@iogearbox.net>,
	Dan Williams <dan.j.williams@intel.com>,
	"jack@suse.com" <jack@suse.com>,
	Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: [RFC 03/16] dma-mapping: provide callbacks to link/unlink pages to specific IOVA
Date: Tue,  5 Mar 2024 12:22:04 +0200
Message-ID: <f1049f0fc280288ae2f0c1e02388cde91b0f7876.1709631413.git.leon@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1709631800.git.leon@kernel.org>
References: <cover.1709631800.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

Introduce new DMA link/unlink API to provide a way for advanced users
to directly map/unmap pages without ned to allocate IOVA on every map
call.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/linux/dma-map-ops.h | 10 +++++++
 include/linux/dma-mapping.h | 13 +++++++++
 kernel/dma/debug.h          |  2 ++
 kernel/dma/direct.h         |  3 ++
 kernel/dma/mapping.c        | 57 +++++++++++++++++++++++++++++++++++++
 5 files changed, 85 insertions(+)

diff --git a/include/linux/dma-map-ops.h b/include/linux/dma-map-ops.h
index bd605b44bb57..fd03a080df1e 100644
--- a/include/linux/dma-map-ops.h
+++ b/include/linux/dma-map-ops.h
@@ -86,6 +86,13 @@ struct dma_map_ops {
 
 	dma_addr_t (*alloc_iova)(struct device *dev, size_t size);
 	void (*free_iova)(struct device *dev, dma_addr_t dma_addr, size_t size);
+	dma_addr_t (*link_range)(struct device *dev, struct page *page,
+				 unsigned long offset, dma_addr_t addr,
+				 size_t size, enum dma_data_direction dir,
+				 unsigned long attrs);
+	void (*unlink_range)(struct device *dev, dma_addr_t dma_handle,
+			     size_t size, enum dma_data_direction dir,
+			     unsigned long attrs);
 };
 
 #ifdef CONFIG_DMA_OPS
@@ -428,6 +435,9 @@ bool arch_dma_unmap_sg_direct(struct device *dev, struct scatterlist *sg,
 #define arch_dma_unmap_sg_direct(d, s, n)	(false)
 #endif
 
+#define arch_dma_link_range_direct arch_dma_map_page_direct
+#define arch_dma_unlink_range_direct arch_dma_unmap_page_direct
+
 #ifdef CONFIG_ARCH_HAS_SETUP_DMA_OPS
 void arch_setup_dma_ops(struct device *dev, u64 dma_base, u64 size,
 		bool coherent);
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 176fb8a86d63..91cc084adb53 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -113,6 +113,9 @@ static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 
 int dma_alloc_iova(struct dma_iova_attrs *iova);
 void dma_free_iova(struct dma_iova_attrs *iova);
+dma_addr_t dma_link_range(struct page *page, unsigned long offset,
+			  struct dma_iova_attrs *iova, dma_addr_t dma_offset);
+void dma_unlink_range(struct dma_iova_attrs *iova, dma_addr_t dma_offset);
 
 dma_addr_t dma_map_page_attrs(struct device *dev, struct page *page,
 		size_t offset, size_t size, enum dma_data_direction dir,
@@ -179,6 +182,16 @@ static inline int dma_alloc_iova(struct dma_iova_attrs *iova)
 static inline void dma_free_iova(struct dma_iova_attrs *iova)
 {
 }
+static inline dma_addr_t dma_link_range(struct page *page, unsigned long offset,
+					struct dma_iova_attrs *iova,
+					dma_addr_t dma_offset)
+{
+	return DMA_MAPPING_ERROR;
+}
+static inline void dma_unlink_range(struct dma_iova_attrs *iova,
+				    dma_addr_t dma_offset)
+{
+}
 static inline dma_addr_t dma_map_page_attrs(struct device *dev,
 		struct page *page, size_t offset, size_t size,
 		enum dma_data_direction dir, unsigned long attrs)
diff --git a/kernel/dma/debug.h b/kernel/dma/debug.h
index f525197d3cae..3d529f355c6d 100644
--- a/kernel/dma/debug.h
+++ b/kernel/dma/debug.h
@@ -127,4 +127,6 @@ static inline void debug_dma_sync_sg_for_device(struct device *dev,
 {
 }
 #endif /* CONFIG_DMA_API_DEBUG */
+#define debug_dma_link_range debug_dma_map_page
+#define debug_dma_unlink_range debug_dma_unmap_page
 #endif /* _KERNEL_DMA_DEBUG_H */
diff --git a/kernel/dma/direct.h b/kernel/dma/direct.h
index 18d346118fe8..1c30e1cd607a 100644
--- a/kernel/dma/direct.h
+++ b/kernel/dma/direct.h
@@ -125,4 +125,7 @@ static inline void dma_direct_unmap_page(struct device *dev, dma_addr_t addr,
 		swiotlb_tbl_unmap_single(dev, phys, size, dir,
 					 attrs | DMA_ATTR_SKIP_CPU_SYNC);
 }
+
+#define dma_direct_link_range dma_direct_map_page
+#define dma_direct_unlink_range dma_direct_unmap_page
 #endif /* _KERNEL_DMA_DIRECT_H */
diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index b6b27bab90f3..f989c64622c2 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -213,6 +213,63 @@ void dma_free_iova(struct dma_iova_attrs *iova)
 }
 EXPORT_SYMBOL(dma_free_iova);
 
+/**
+ * dma_link_range - Link a physical page to DMA address
+ * @page: The page to be mapped
+ * @offset: The offset within the page
+ * @iova: Preallocated IOVA attributes
+ * @dma_offset: DMA offset form which this page needs to be linked
+ *
+ * dma_alloc_iova() allocates IOVA based on the size specified by ther user in
+ * iova->size. Call this function after IOVA allocation to link @page from
+ * @offset to get the DMA address. Note that very first call to this function
+ * will have @dma_offset set to 0 in the IOVA space allocated from
+ * dma_alloc_iova(). For subsequent calls to this function on same @iova,
+ * @dma_offset needs to be advanced by the caller with the size of previous
+ * page that was linked + DMA address returned for the previous page that was
+ * linked by this function.
+ */
+dma_addr_t dma_link_range(struct page *page, unsigned long offset,
+			  struct dma_iova_attrs *iova, dma_addr_t dma_offset)
+{
+	struct device *dev = iova->dev;
+	size_t size = iova->size;
+	enum dma_data_direction dir = iova->dir;
+	unsigned long attrs = iova->attrs;
+	dma_addr_t addr = iova->addr + dma_offset;
+	const struct dma_map_ops *ops = get_dma_ops(dev);
+
+	if (dma_map_direct(dev, ops) ||
+	    arch_dma_link_range_direct(dev, page_to_phys(page) + offset + size))
+		addr = dma_direct_link_range(dev, page, offset, size, dir, attrs);
+	else if (ops->link_range)
+		addr = ops->link_range(dev, page, offset, addr, size, dir, attrs);
+
+	kmsan_handle_dma(page, offset, size, dir);
+	debug_dma_link_range(dev, page, offset, size, dir, addr, attrs);
+	return addr;
+}
+EXPORT_SYMBOL(dma_link_range);
+
+void dma_unlink_range(struct dma_iova_attrs *iova, dma_addr_t dma_offset)
+{
+	struct device *dev = iova->dev;
+	size_t size = iova->size;
+	enum dma_data_direction dir = iova->dir;
+	unsigned long attrs = iova->attrs;
+	dma_addr_t addr = iova->addr + dma_offset;
+	const struct dma_map_ops *ops = get_dma_ops(dev);
+
+	if (dma_map_direct(dev, ops) ||
+	    arch_dma_unlink_range_direct(dev, addr + size))
+		dma_direct_unlink_range(dev, addr, size, dir, attrs);
+	else if (ops->unlink_range)
+		ops->unlink_range(dev, addr, size, dir, attrs);
+
+	debug_dma_unlink_range(dev, addr, size, dir);
+}
+EXPORT_SYMBOL(dma_unlink_range);
+
 static int __dma_map_sg_attrs(struct device *dev, struct scatterlist *sg,
 	 int nents, enum dma_data_direction dir, unsigned long attrs)
 {
-- 
2.44.0


