Return-Path: <kvm+bounces-29771-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DD9AC9B1E3F
	for <lists+kvm@lfdr.de>; Sun, 27 Oct 2024 15:24:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0EB2EB216F5
	for <lists+kvm@lfdr.de>; Sun, 27 Oct 2024 14:24:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BFFC1714B6;
	Sun, 27 Oct 2024 14:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pyhT2VpS"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A1371632CE;
	Sun, 27 Oct 2024 14:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730038917; cv=none; b=D+sp4cdnHdoX9c0ASzWIKlFCMy3SK+j2B9tM259T4e2j0BtF+aOmgPPW403JrSDNR7YQphiY/LQD1WFkYaQxsGF9vrJLUA769Mvyn12eJOm+tuOdWjf6Zh0J9r0Vx96cEsFh2PGetyjf+xMPJ4wAQgM+JSgJh532DWbQfXesEyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730038917; c=relaxed/simple;
	bh=PAw5hw13Z95vfq73SLbV0SEXjd0ocCP2MdgdT7qst9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GfPNhzJI32QZFJc1V0ZyeRF5E1slYEmb7rWJW9nX3LZOYZpfD3HtJD517YQFUaAtTBuWABrbMlwW0aCg8zAsJUZs5MUp95QIZwMSh4kJgURdmqHEGDB0y7s5x/7uiu/bFpTGxmDiVdv2Yxe0GGdzCVLHtqBauwywTm47GV45Lsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pyhT2VpS; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF229C4CEE7;
	Sun, 27 Oct 2024 14:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730038916;
	bh=PAw5hw13Z95vfq73SLbV0SEXjd0ocCP2MdgdT7qst9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pyhT2VpSHFFg+sggZU1U1x0Yd2yadtjGm6brk2JiJizkGlQh6O4THnpREhzM35TSQ
	 snmSykCmO9tDcYUqTZzxeQEGQXPIXNJmpRhpdfHRrDqWKE3ntHnQjmR0UYZTI6pn4F
	 Q/jRPZd+lz5NMus3TlpbGpy14+sOtFWz6sfWK2nU7m8ek1r3teoTBvWpWfBd0Vdrrg
	 kevnma7G5Ikx2Xkmz/qiDa9SZUbnNqGdYg3liGlRZIgV1zXAB7KAXbiWsMb5JuNn1i
	 o7WBB1Kc6bGKhHLClJltnGnx7N2V6VKDEpkLcoUYFGwOZJAZ31G27BxtKDLymMUpIT
	 247L+S/rMqtvQ==
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
Subject: [PATCH 07/18] dma-mapping: Implement link/unlink ranges API
Date: Sun, 27 Oct 2024 16:21:07 +0200
Message-ID: <b434f2f6d3c601649c9b6973a2ec3ec2149bba37.1730037276.git.leon@kernel.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <cover.1730037276.git.leon@kernel.org>
References: <cover.1730037276.git.leon@kernel.org>
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
 drivers/iommu/dma-iommu.c   | 256 ++++++++++++++++++++++++++++++++++++
 include/linux/dma-map-ops.h |   1 -
 include/linux/dma-mapping.h |  31 +++++
 3 files changed, 287 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index b859f93b1c17..f853762c2d54 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -1833,6 +1833,262 @@ void dma_iova_free(struct device *dev, struct dma_iova_state *state)
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
+ * @ret: return value from the last IOVA operation
+ *
+ * Sync IOTLB for the given IOVA state. This function should be called on
+ * the IOVA-contigous range created by one ore more dma_iova_link() calls
+ * to sync the IOTLB.
+ */
+int dma_iova_sync(struct device *dev, struct dma_iova_state *state,
+		size_t offset, size_t size, int ret)
+{
+	struct iommu_domain *domain = iommu_get_dma_domain(dev);
+	struct iommu_dma_cookie *cookie = domain->iova_cookie;
+	struct iova_domain *iovad = &cookie->iovad;
+	dma_addr_t addr = state->addr + offset;
+	size_t iova_start_pad = iova_offset(iovad, addr);
+
+	addr -= iova_start_pad;
+	size = iova_align(iovad, size + iova_start_pad);
+
+	if (!ret)
+		ret = iommu_sync_map(domain, addr, size);
+	if (ret)
+		iommu_unmap(domain, addr, size);
+	return ret;
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
+ * @dir: DMA direction
+ * @attrs: attributes of mapping properties
+ *
+ * Unlink whole IOVA range and free an IOVA space. The range of IOVA from
+ * dma_addr to size must all be linked, and be the only linked IOVA in state
+ */
+void dma_iova_destroy(struct device *dev, struct dma_iova_state *state,
+		enum dma_data_direction dir, unsigned long attrs)
+{
+	__iommu_dma_iova_unlink(dev, state, 0, dma_iova_size(state), dir, attrs,
+			true);
+}
+EXPORT_SYMBOL_GPL(dma_iova_destroy);
+
 void iommu_setup_dma_ops(struct device *dev)
 {
 	struct iommu_domain *domain = iommu_get_domain_for_dev(dev);
diff --git a/include/linux/dma-map-ops.h b/include/linux/dma-map-ops.h
index 6ee626e50708..dced37816ede 100644
--- a/include/linux/dma-map-ops.h
+++ b/include/linux/dma-map-ops.h
@@ -434,5 +434,4 @@ static inline void debug_dma_dump_mappings(struct device *dev)
 #endif /* CONFIG_DMA_API_DEBUG */
 
 extern const struct dma_map_ops dma_dummy_ops;
-
 #endif /* _LINUX_DMA_MAP_OPS_H */
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 817f11bce7bc..50f0edfe7350 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -313,6 +313,16 @@ static inline bool dma_use_iova(struct dma_iova_state *state)
 bool dma_iova_try_alloc(struct device *dev, struct dma_iova_state *state,
 		phys_addr_t phys, size_t size);
 void dma_iova_free(struct device *dev, struct dma_iova_state *state);
+void dma_iova_destroy(struct device *dev, struct dma_iova_state *state,
+		enum dma_data_direction dir, unsigned long attrs);
+int dma_iova_sync(struct device *dev, struct dma_iova_state *state,
+		size_t offset, size_t size, int ret);
+int dma_iova_link(struct device *dev, struct dma_iova_state *state,
+		phys_addr_t phys, size_t offset, size_t size,
+		enum dma_data_direction dir, unsigned long attrs);
+void dma_iova_unlink(struct device *dev, struct dma_iova_state *state,
+		size_t offset, size_t size, enum dma_data_direction dir,
+		unsigned long attrs);
 #else /* CONFIG_IOMMU_DMA */
 static inline bool dma_use_iova(struct dma_iova_state *state)
 {
@@ -327,6 +337,27 @@ static inline void dma_iova_free(struct device *dev,
 		struct dma_iova_state *state)
 {
 }
+static inline void dma_iova_destroy(struct device *dev,
+		struct dma_iova_state *state, enum dma_data_direction dir,
+		unsigned long attrs)
+{
+}
+static inline int dma_iova_sync(struct device *dev, struct dma_iova_state *state,
+		size_t offset, size_t size, int ret)
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


