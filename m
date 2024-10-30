Return-Path: <kvm+bounces-30040-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CC6B9B6748
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 16:17:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9612E1F21E40
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 15:17:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89432216439;
	Wed, 30 Oct 2024 15:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XWPRFrM5"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 890CF216447;
	Wed, 30 Oct 2024 15:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730301223; cv=none; b=gI6FJUbEc4GwLCOknesLpUg9fSsdqrXtMdLp8ngQ5uMQ8qGYdoRo9jPrkVcM0IFxtdCKg0bB00sjGlJDLM7tOExW71eo1EGIRJgz+N0HAPuM0TXg5fmDs9xO+0v83ojlg2bZNzOKVEwuQszz88K7Mqma1E1RqzYrNMy2BS5Hrc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730301223; c=relaxed/simple;
	bh=IXzQBF3c/yZPTe8x0QJ0JrgIemF2ruKzaY/aVUXUcCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mDEUVkaC8BgITEn8/LVtSX8aq/noIhawILpesJTx3Yg6/ldLPA+F14xK1rhdJ1k91ozURgodlWb4snoyqMH6jvHMc7m9ZiXdaoovU5EZvzwc0Lhxe4v0lHb7KWTe9aGHtxg8rk9cbgjCiMRRHHKGY0jgWzsupkqpkewJaUdTx5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XWPRFrM5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7139C4CECE;
	Wed, 30 Oct 2024 15:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730301223;
	bh=IXzQBF3c/yZPTe8x0QJ0JrgIemF2ruKzaY/aVUXUcCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XWPRFrM5Wl6m+dLBlaCdBj6Qm4Zw5gf7r4ikooFMjHGGjvlVhKOXmFsDVfXeGbn6a
	 V+3nbQe8i9e3XgDRmfznzRzRVpnD0wL4c7Sj4qSPKm9ojdRfK0fkNvfxSCseJIAIfV
	 2j9reoSJHsWHX7TVWg2oQfigJHAyw1RA+Z+ugbKqa5QHhvW9/wiHRkKnqausYhBAC4
	 y0j990xxc/JfxcAzjhZZE411BzuI4ay8OxofXouSEysYsqODetq3MW7XrtwkfPcRQ4
	 89IjaioXYahXzXXZigTjOuXF762f9Xkc9avbjlVSDIMBFvbJbEniIiLEeRG0NXSzoq
	 3bI0xzw9zptBA==
From: Leon Romanovsky <leon@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Robin Murphy <robin.murphy@arm.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>
Cc: Leon Romanovsky <leonro@nvidia.com>,
	Keith Busch <kbusch@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	linux-pci@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v1 07/17] dma-mapping: Implement link/unlink ranges API
Date: Wed, 30 Oct 2024 17:12:53 +0200
Message-ID: <f8c7f160c9ae97fef4ccd355f9979727552c7374.1730298502.git.leon@kernel.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <cover.1730298502.git.leon@kernel.org>
References: <cover.1730298502.git.leon@kernel.org>
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

In proposed API, the callers will perform the following steps.
In map path:
	if (dma_can_use_iova(...))
	    dma_iova_alloc()
	    for (page in range)
	       dma_iova_link_next(...)
	    dma_iova_sync(...)
	else
	     /* Fallback to legacy map pages */
             for (all pages)
	       dma_map_page(...)

In unmap path:
	if (dma_can_use_iova(...))
	     dma_iova_destroy()
	else
	     for (all pages)
		dma_unmap_page(...)

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/iommu/dma-iommu.c   | 259 ++++++++++++++++++++++++++++++++++++
 include/linux/dma-mapping.h |  32 +++++
 2 files changed, 291 insertions(+)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index e1eaad500d27..4a504a879cc0 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -1834,6 +1834,265 @@ void dma_iova_free(struct device *dev, struct dma_iova_state *state)
 }
 EXPORT_SYMBOL_GPL(dma_iova_free);
 
+static int __dma_iova_link(struct device *dev, dma_addr_t addr,
+		phys_addr_t phys, size_t size, enum dma_data_direction dir,
+		unsigned long attrs)
+{
+	bool coherent = dev_is_dma_coherent(dev);
+
+	if (!coherent && !(attrs & DMA_ATTR_SKIP_CPU_SYNC))
+		arch_sync_dma_for_device(phys, size, dir);
+
+	return iommu_map_nosync(iommu_get_dma_domain(dev), addr, phys, size,
+			dma_info_to_prot(dir, coherent, attrs), GFP_ATOMIC);
+}
+
+static int iommu_dma_iova_bounce_and_link(struct device *dev, dma_addr_t addr,
+		phys_addr_t phys, size_t bounce_len,
+		enum dma_data_direction dir, unsigned long attrs,
+		size_t iova_start_pad)
+{
+	struct iommu_domain *domain = iommu_get_dma_domain(dev);
+	struct iova_domain *iovad = &domain->iova_cookie->iovad;
+	phys_addr_t bounce_phys;
+	int error;
+
+	bounce_phys = iommu_dma_map_swiotlb(dev, phys, bounce_len, dir, attrs);
+	if (bounce_phys == DMA_MAPPING_ERROR)
+		return -ENOMEM;
+
+	error = __dma_iova_link(dev, addr - iova_start_pad,
+			bounce_phys - iova_start_pad,
+			iova_align(iovad, bounce_len), dir, attrs);
+	if (error)
+		swiotlb_tbl_unmap_single(dev, bounce_phys, bounce_len, dir,
+				attrs);
+	return error;
+}
+
+static int iommu_dma_iova_link_swiotlb(struct device *dev,
+		struct dma_iova_state *state, phys_addr_t phys, size_t offset,
+		size_t size, enum dma_data_direction dir, unsigned long attrs)
+{
+	struct iommu_domain *domain = iommu_get_dma_domain(dev);
+	struct iommu_dma_cookie *cookie = domain->iova_cookie;
+	struct iova_domain *iovad = &cookie->iovad;
+	size_t iova_start_pad = iova_offset(iovad, phys);
+	size_t iova_end_pad = iova_offset(iovad, phys + size);
+	dma_addr_t addr = state->addr + offset;
+	size_t mapped = 0;
+	int error;
+
+	if (iova_start_pad) {
+		size_t bounce_len = min(size, iovad->granule - iova_start_pad);
+
+		error = iommu_dma_iova_bounce_and_link(dev, addr, phys,
+				bounce_len, dir, attrs, iova_start_pad);
+		if (error)
+			return error;
+		state->__size |= DMA_IOVA_USE_SWIOTLB;
+
+		mapped += bounce_len;
+		size -= bounce_len;
+		if (!size)
+			return 0;
+	}
+
+	size -= iova_end_pad;
+	error = __dma_iova_link(dev, addr + mapped, phys + mapped, size, dir,
+			attrs);
+	if (error)
+		goto out_unmap;
+	mapped += size;
+
+	if (iova_end_pad) {
+		error = iommu_dma_iova_bounce_and_link(dev, addr + mapped,
+				phys + mapped, iova_end_pad, dir, attrs, 0);
+		if (error)
+			goto out_unmap;
+		state->__size |= DMA_IOVA_USE_SWIOTLB;
+	}
+
+	return 0;
+
+out_unmap:
+	dma_iova_unlink(dev, state, 0, mapped, dir, attrs);
+	return error;
+}
+
+/**
+ * dma_iova_link - Link a range of IOVA space
+ * @dev: DMA device
+ * @state: IOVA state
+ * @phys: physical address to link
+ * @offset: offset into the IOVA state to map into
+ * @size: size of the buffer
+ * @dir: DMA direction
+ * @attrs: attributes of mapping properties
+ *
+ * Link a range of IOVA space for the given IOVA state without IOTLB sync.
+ * This function is used to link multiple physical addresses in contigueous
+ * IOVA space without performing costly IOTLB sync.
+ *
+ * The caller is responsible to call to dma_iova_sync() to sync IOTLB at
+ * the end of linkage.
+ */
+int dma_iova_link(struct device *dev, struct dma_iova_state *state,
+		phys_addr_t phys, size_t offset, size_t size,
+		enum dma_data_direction dir, unsigned long attrs)
+{
+	struct iommu_domain *domain = iommu_get_dma_domain(dev);
+	struct iommu_dma_cookie *cookie = domain->iova_cookie;
+	struct iova_domain *iovad = &cookie->iovad;
+	size_t iova_start_pad = iova_offset(iovad, phys);
+
+	if (WARN_ON_ONCE(iova_start_pad && offset > 0))
+		return -EIO;
+
+	if (dev_use_swiotlb(dev, size, dir) && iova_offset(iovad, phys | size))
+		return iommu_dma_iova_link_swiotlb(dev, state, phys, offset,
+				size, dir, attrs);
+
+	return __dma_iova_link(dev, state->addr + offset - iova_start_pad,
+			phys - iova_start_pad,
+			iova_align(iovad, size + iova_start_pad), dir, attrs);
+}
+EXPORT_SYMBOL_GPL(dma_iova_link);
+
+/**
+ * dma_iova_sync - Sync IOTLB
+ * @dev: DMA device
+ * @state: IOVA state
+ * @offset: offset into the IOVA state to sync
+ * @size: size of the buffer
+ *
+ * Sync IOTLB for the given IOVA state. This function should be called on
+ * the IOVA-contigous range created by one ore more dma_iova_link() calls
+ * to sync the IOTLB.
+ */
+int dma_iova_sync(struct device *dev, struct dma_iova_state *state,
+		size_t offset, size_t size)
+{
+	struct iommu_domain *domain = iommu_get_dma_domain(dev);
+	struct iommu_dma_cookie *cookie = domain->iova_cookie;
+	struct iova_domain *iovad = &cookie->iovad;
+	dma_addr_t addr = state->addr + offset;
+	size_t iova_start_pad = iova_offset(iovad, addr);
+
+	return iommu_sync_map(domain, addr - iova_start_pad,
+		      iova_align(iovad, size + iova_start_pad));
+}
+EXPORT_SYMBOL_GPL(dma_iova_sync);
+
+static void iommu_dma_iova_unlink_range_slow(struct device *dev,
+		dma_addr_t addr, size_t size, enum dma_data_direction dir,
+		unsigned long attrs)
+{
+	struct iommu_domain *domain = iommu_get_dma_domain(dev);
+	struct iommu_dma_cookie *cookie = domain->iova_cookie;
+	struct iova_domain *iovad = &cookie->iovad;
+	size_t iova_start_pad = iova_offset(iovad, addr);
+	dma_addr_t end = addr + size;
+
+	do {
+		phys_addr_t phys;
+		size_t len;
+
+		phys = iommu_iova_to_phys(domain, addr);
+		if (WARN_ON(!phys))
+			continue;
+		len = min_t(size_t,
+			end - addr, iovad->granule - iova_start_pad);
+
+		if (!dev_is_dma_coherent(dev) &&
+		    !(attrs & DMA_ATTR_SKIP_CPU_SYNC))
+			arch_sync_dma_for_cpu(phys, len, dir);
+
+		swiotlb_tbl_unmap_single(dev, phys, len, dir, attrs);
+
+		addr += len;
+		iova_start_pad = 0;
+	} while (addr < end);
+}
+
+static void __iommu_dma_iova_unlink(struct device *dev,
+		struct dma_iova_state *state, size_t offset, size_t size,
+		enum dma_data_direction dir, unsigned long attrs,
+		bool free_iova)
+{
+	struct iommu_domain *domain = iommu_get_dma_domain(dev);
+	struct iommu_dma_cookie *cookie = domain->iova_cookie;
+	struct iova_domain *iovad = &cookie->iovad;
+	dma_addr_t addr = state->addr + offset;
+	size_t iova_start_pad = iova_offset(iovad, addr);
+	struct iommu_iotlb_gather iotlb_gather;
+	size_t unmapped;
+
+	if ((state->__size & DMA_IOVA_USE_SWIOTLB) ||
+	    (!dev_is_dma_coherent(dev) && !(attrs & DMA_ATTR_SKIP_CPU_SYNC)))
+		iommu_dma_iova_unlink_range_slow(dev, addr, size, dir, attrs);
+
+	iommu_iotlb_gather_init(&iotlb_gather);
+	iotlb_gather.queued = free_iova && READ_ONCE(cookie->fq_domain);
+
+	size = iova_align(iovad, size + iova_start_pad);
+	addr -= iova_start_pad;
+	unmapped = iommu_unmap_fast(domain, addr, size, &iotlb_gather);
+	WARN_ON(unmapped != size);
+
+	if (!iotlb_gather.queued)
+		iommu_iotlb_sync(domain, &iotlb_gather);
+	if (free_iova)
+		iommu_dma_free_iova(cookie, addr, size, &iotlb_gather);
+}
+
+/**
+ * dma_iova_unlink - Unlink a range of IOVA space
+ * @dev: DMA device
+ * @state: IOVA state
+ * @offset: offset into the IOVA state to unlink
+ * @size: size of the buffer
+ * @dir: DMA direction
+ * @attrs: attributes of mapping properties
+ *
+ * Unlink a range of IOVA space for the given IOVA state.
+ */
+void dma_iova_unlink(struct device *dev, struct dma_iova_state *state,
+		size_t offset, size_t size, enum dma_data_direction dir,
+		unsigned long attrs)
+{
+	 __iommu_dma_iova_unlink(dev, state, offset, size, dir, attrs, false);
+}
+EXPORT_SYMBOL_GPL(dma_iova_unlink);
+
+/**
+ * dma_iova_destroy - Finish a DMA mapping transaction
+ * @dev: DMA device
+ * @state: IOVA state
+ * @mapped_len: number of bytes to unmap
+ * @dir: DMA direction
+ * @attrs: attributes of mapping properties
+ *
+ * Unlink the IOVA range up to @mapped_len and free the entire IOVA space. The
+ * range of IOVA from dma_addr to @mapped_len must all be linked, and be the
+ * only linked IOVA in state.
+ */
+void dma_iova_destroy(struct device *dev, struct dma_iova_state *state,
+		size_t mapped_len, enum dma_data_direction dir,
+		unsigned long attrs)
+{
+	if (mapped_len)
+		__iommu_dma_iova_unlink(dev, state, 0, mapped_len, dir, attrs,
+				true);
+	else
+		/*
+		 * We can be here if first call to dma_iova_link() failed and
+		 * there is nothing to unlink, so let's be more clear.
+		 */
+		dma_iova_free(dev, state);
+}
+EXPORT_SYMBOL_GPL(dma_iova_destroy);
+
 void iommu_setup_dma_ops(struct device *dev)
 {
 	struct iommu_domain *domain = iommu_get_domain_for_dev(dev);
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 817f11bce7bc..8074a3b5c807 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -313,6 +313,17 @@ static inline bool dma_use_iova(struct dma_iova_state *state)
 bool dma_iova_try_alloc(struct device *dev, struct dma_iova_state *state,
 		phys_addr_t phys, size_t size);
 void dma_iova_free(struct device *dev, struct dma_iova_state *state);
+void dma_iova_destroy(struct device *dev, struct dma_iova_state *state,
+		size_t mapped_len, enum dma_data_direction dir,
+		unsigned long attrs);
+int dma_iova_sync(struct device *dev, struct dma_iova_state *state,
+		size_t offset, size_t size);
+int dma_iova_link(struct device *dev, struct dma_iova_state *state,
+		phys_addr_t phys, size_t offset, size_t size,
+		enum dma_data_direction dir, unsigned long attrs);
+void dma_iova_unlink(struct device *dev, struct dma_iova_state *state,
+		size_t offset, size_t size, enum dma_data_direction dir,
+		unsigned long attrs);
 #else /* CONFIG_IOMMU_DMA */
 static inline bool dma_use_iova(struct dma_iova_state *state)
 {
@@ -327,6 +338,27 @@ static inline void dma_iova_free(struct device *dev,
 		struct dma_iova_state *state)
 {
 }
+static inline void dma_iova_destroy(struct device *dev,
+		struct dma_iova_state *state, size_t mapped_len,
+		enum dma_data_direction dir, unsigned long attrs)
+{
+}
+static inline int dma_iova_sync(struct device *dev, struct dma_iova_state *state,
+		size_t offset, size_t size)
+{
+	return -EOPNOTSUPP;
+}
+static inline int dma_iova_link(struct device *dev,
+		struct dma_iova_state *state, phys_addr_t phys, size_t offset,
+		size_t size, enum dma_data_direction dir, unsigned long attrs)
+{
+	return -EOPNOTSUPP;
+}
+static inline void dma_iova_unlink(struct device *dev,
+		struct dma_iova_state *state, size_t offset, size_t size,
+		enum dma_data_direction dir, unsigned long attrs)
+{
+}
 #endif /* CONFIG_IOMMU_DMA */
 
 #if defined(CONFIG_HAS_DMA) && defined(CONFIG_DMA_NEED_SYNC)
-- 
2.46.2


