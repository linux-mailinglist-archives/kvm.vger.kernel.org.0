Return-Path: <kvm+bounces-33926-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC86B9F4B9C
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 14:10:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C744B171600
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 13:04:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B698D1F7570;
	Tue, 17 Dec 2024 13:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T96v26ss"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D6D1F4290;
	Tue, 17 Dec 2024 13:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734440485; cv=none; b=sU6wjlio7KbcTKe0eHCy/AweWRadOqXNH5YwMiEwMHa/zv/NT22//JdR/eIoTbuAhUW7SwjVTAmiN1SloDRjg9Ft55CYZJvXbHvSbrJNMbZIynJWIv8jjDtMg3o1i/nxVJMIj7NCVtq/T2ph6FWEiAuOvl9RKzmyKVfo5J4ksQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734440485; c=relaxed/simple;
	bh=J/A4HIJwXBtFyEgwDdfKNSWvnCrjun5Y2JK84HYG/IQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aNun6ljd/4vQHRKAKmfK8fbxL1UIVBEKYi3VIOG5RvFJ9Lcl44BYrLRGxnuk5ds6NZEH00uIFVxInYGisOMFyZGqRDcTqUfb3m14XBi6VKNN341GgvlpmAjTbuUGXWqxF9kl5Wr3vsYiJNfKRqX1tQErx0grEEOUmUxAygcLQGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T96v26ss; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4818C4CED4;
	Tue, 17 Dec 2024 13:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734440485;
	bh=J/A4HIJwXBtFyEgwDdfKNSWvnCrjun5Y2JK84HYG/IQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T96v26ssGxaDgMWsqXoZz/4Ia8ezDlJwvzrQ350zku5TYH1OxFYU6UcEDYMOKY3mi
	 HMuhAhVYQ+mP2e6vkC22TozsMoLwgKmv/UHqr81I1mYKYriiknhrT49EGiU5adxX+N
	 95QC0OoKQxZbPq4d3GCCXuq6FTbC4Bg3PWOJaZn9T08nMZfFQ5SjJ9wkEWXGkyXzrk
	 aZSInLWFHlXKDVUVrqPdzXWHrBSlRrPYaBo39CUjOo2BTXw4g9fR47z9PdIH5vf79E
	 mVjswY47Mm0Jp2QZyaveqYs7tjfeADpUMdoHeZBIyI/mBbmVpdQez350W+NcPS++yV
	 nP94kHCqT7ZEw==
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
	linux-mm@kvack.org,
	Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH v5 07/17] dma-mapping: Implement link/unlink ranges API
Date: Tue, 17 Dec 2024 15:00:25 +0200
Message-ID: <fa43307222f263e65ae0a84c303150def15e2c77.1734436840.git.leon@kernel.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <cover.1734436840.git.leon@kernel.org>
References: <cover.1734436840.git.leon@kernel.org>
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

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/iommu/dma-iommu.c   | 259 ++++++++++++++++++++++++++++++++++++
 include/linux/dma-mapping.h |  32 +++++
 2 files changed, 291 insertions(+)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index d473ea4329ab..7972270e82b4 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -1829,6 +1829,265 @@ void dma_iova_free(struct device *dev, struct dma_iova_state *state)
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
index 55899d65668b..f4d717e17bde 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -310,6 +310,17 @@ static inline bool dma_use_iova(struct dma_iova_state *state)
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
@@ -324,6 +335,27 @@ static inline void dma_iova_free(struct device *dev,
 		struct dma_iova_state *state)
 {
 }
+static inline void dma_iova_destroy(struct device *dev,
+		struct dma_iova_state *state, size_t mapped_len,
+		enum dma_data_direction dir, unsigned long attrs)
+{
+}
+static inline int dma_iova_sync(struct device *dev,
+		struct dma_iova_state *state, size_t offset, size_t size)
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
2.47.0


