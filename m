Return-Path: <kvm+bounces-33924-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FE5E9F4B82
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 14:05:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C530C7A547A
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 13:03:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07FA31F6686;
	Tue, 17 Dec 2024 13:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SFOnbcEP"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A631F3D2B;
	Tue, 17 Dec 2024 13:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734440478; cv=none; b=YDKGanvoUl58yum4lPWw7Mzlf4tA64HeYGfdjiCH+kqMsO0ACx/NqBc4DW74Istxsc59OQNvBEdABmCQQcroOQucxYvB+ahanzkuECu12OLigxTJUeES1pjV90MJ9L63nvkRX4ZM0oUXY3PH6EA6Bu7yTeXmQm6tBv+/VXNYBJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734440478; c=relaxed/simple;
	bh=Tuu9lLMPsbpojYflIa+4EI354ts2rpP2NDVkgczvrjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PdwNLqJO4WBK7IcSFF+CPlPBdHm/Mq3n7Z/KIbciaZsQxMEC2U4aub+n2ZWgNavL3my6rDoELKamfX5IrmyIVq65goLk4bvidbD8Fg3FYZ34VyYI9LCXJLxmJ4meRWcVHzTi/8Sd4/3poOZQ8QD6r3Bj+g2ffV5xSiIvMVpV3F8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SFOnbcEP; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEFE8C4CEDE;
	Tue, 17 Dec 2024 13:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734440476;
	bh=Tuu9lLMPsbpojYflIa+4EI354ts2rpP2NDVkgczvrjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SFOnbcEPmkX0bqeNVKeTuJ9cBxPcplTvHF/ZP/RmumhXklJ/tTjc0c0VXdSYZVvMH
	 XgMdlsyuwihuJS6JHkax0GmbjSuHcvcl0QebwyYZXN9k7cGCrGBH3zlAcqnBkoHabA
	 pEteBleG6IoonvfvtExGXNHiFvu87m3C1yRjLs3JFYY4OsT+lHfvkPzoLj52pdJhM/
	 89OSsvuxH83fr4T/XMBrFl1i+KOU1ditkP3Rb9net0w56GPUPJDStLeEvPfbJhRQ76
	 hQYKywSEIjcrDtwM3NSN77/BjJ7vzYHGMfaOWSRfu5Np/0DSJCQBJMIl2w7Zb/naze
	 c7TPx7J8ilqqg==
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
Subject: [PATCH v5 05/17] dma-mapping: Provide an interface to allow allocate IOVA
Date: Tue, 17 Dec 2024 15:00:23 +0200
Message-ID: <fac6bc6fdcf8e13bd5668386d36289ee38a8a95b.1734436840.git.leon@kernel.org>
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

The existing .map_page() callback provides both allocating of IOVA
and linking DMA pages. That combination works great for most of the
callers who use it in control paths, but is less effective in fast
paths where there may be multiple calls to map_page().

These advanced callers already manage their data in some sort of
database and can perform IOVA allocation in advance, leaving range
linkage operation to be in fast path.

Provide an interface to allocate/deallocate IOVA and next patch
link/unlink DMA ranges to that specific IOVA.

In the new API a DMA mapping transaction is identified by a
struct dma_iova_state, which holds some recomputed information
for the transaction which does not change for each page being
mapped, so add a check if IOVA can be used for the specific
transaction.

The API is exported from dma-iommu as it is the only implementation
supported, the namespace is clearly different from iommu_* functions
which are not allowed to be used. This code layout allows us to save
function call per API call used in datapath as well as a lot of boilerplate
code.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/iommu/dma-iommu.c   | 74 +++++++++++++++++++++++++++++++++++++
 include/linux/dma-mapping.h | 49 ++++++++++++++++++++++++
 2 files changed, 123 insertions(+)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 853247c42f7d..5906b47a300c 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -1746,6 +1746,80 @@ size_t iommu_dma_max_mapping_size(struct device *dev)
 	return SIZE_MAX;
 }
 
+/**
+ * dma_iova_try_alloc - Try to allocate an IOVA space
+ * @dev: Device to allocate the IOVA space for
+ * @state: IOVA state
+ * @phys: physical address
+ * @size: IOVA size
+ *
+ * Check if @dev supports the IOVA-based DMA API, and if yes allocate IOVA space
+ * for the given base address and size.
+ *
+ * Note: @phys is only used to calculate the IOVA alignment. Callers that always
+ * do PAGE_SIZE aligned transfers can safely pass 0 here.
+ *
+ * Returns %true if the IOVA-based DMA API can be used and IOVA space has been
+ * allocated, or %false if the regular DMA API should be used.
+ */
+bool dma_iova_try_alloc(struct device *dev, struct dma_iova_state *state,
+		phys_addr_t phys, size_t size)
+{
+	struct iommu_domain *domain = iommu_get_dma_domain(dev);
+	struct iommu_dma_cookie *cookie = domain->iova_cookie;
+	struct iova_domain *iovad = &cookie->iovad;
+	size_t iova_off = iova_offset(iovad, phys);
+	dma_addr_t addr;
+
+	memset(state, 0, sizeof(*state));
+	if (!use_dma_iommu(dev))
+		return false;
+	if (static_branch_unlikely(&iommu_deferred_attach_enabled) &&
+	    iommu_deferred_attach(dev, iommu_get_domain_for_dev(dev)))
+		return false;
+
+	if (WARN_ON_ONCE(!size))
+		return false;
+	if (WARN_ON_ONCE(size & DMA_IOVA_USE_SWIOTLB))
+		return false;
+
+	addr = iommu_dma_alloc_iova(domain,
+			iova_align(iovad, size + iova_off),
+			dma_get_mask(dev), dev);
+	if (!addr)
+		return false;
+
+	state->addr = addr + iova_off;
+	state->__size = size;
+	return true;
+}
+EXPORT_SYMBOL_GPL(dma_iova_try_alloc);
+
+/**
+ * dma_iova_free - Free an IOVA space
+ * @dev: Device to free the IOVA space for
+ * @state: IOVA state
+ *
+ * Undoes a successful dma_try_iova_alloc().
+ *
+ * Note that all dma_iova_link() calls need to be undone first.  For callers
+ * that never call dma_iova_unlink(), dma_iova_destroy() can be used instead
+ * which unlinks all ranges and frees the IOVA space in a single efficient
+ * operation.
+ */
+void dma_iova_free(struct device *dev, struct dma_iova_state *state)
+{
+	struct iommu_domain *domain = iommu_get_dma_domain(dev);
+	struct iommu_dma_cookie *cookie = domain->iova_cookie;
+	struct iova_domain *iovad = &cookie->iovad;
+	size_t iova_start_pad = iova_offset(iovad, state->addr);
+	size_t size = dma_iova_size(state);
+
+	iommu_dma_free_iova(cookie, state->addr - iova_start_pad,
+			iova_align(iovad, size + iova_start_pad), NULL);
+}
+EXPORT_SYMBOL_GPL(dma_iova_free);
+
 void iommu_setup_dma_ops(struct device *dev)
 {
 	struct iommu_domain *domain = iommu_get_domain_for_dev(dev);
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index b79925b1c433..55899d65668b 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -7,6 +7,8 @@
 #include <linux/dma-direction.h>
 #include <linux/scatterlist.h>
 #include <linux/bug.h>
+#include <linux/mem_encrypt.h>
+#include <linux/iommu.h>
 
 /**
  * List of possible attributes associated with a DMA mapping. The semantics
@@ -72,6 +74,21 @@
 
 #define DMA_BIT_MASK(n)	(((n) == 64) ? ~0ULL : ((1ULL<<(n))-1))
 
+struct dma_iova_state {
+	dma_addr_t addr;
+	size_t __size;
+};
+
+/*
+ * Use the high bit to mark if we used swiotlb for one or more ranges.
+ */
+#define DMA_IOVA_USE_SWIOTLB		(1ULL << 63)
+
+static inline size_t dma_iova_size(struct dma_iova_state *state)
+{
+	return state->__size & ~DMA_IOVA_USE_SWIOTLB;
+}
+
 #ifdef CONFIG_DMA_API_DEBUG
 void debug_dma_mapping_error(struct device *dev, dma_addr_t dma_addr);
 void debug_dma_map_single(struct device *dev, const void *addr,
@@ -277,6 +294,38 @@ static inline int dma_mmap_noncontiguous(struct device *dev,
 }
 #endif /* CONFIG_HAS_DMA */
 
+#ifdef CONFIG_IOMMU_DMA
+/**
+ * dma_use_iova - check if the IOVA API is used for this state
+ * @state: IOVA state
+ *
+ * Return %true if the DMA transfers uses the dma_iova_*() calls or %false if
+ * they can't be used.
+ */
+static inline bool dma_use_iova(struct dma_iova_state *state)
+{
+	return state->__size != 0;
+}
+
+bool dma_iova_try_alloc(struct device *dev, struct dma_iova_state *state,
+		phys_addr_t phys, size_t size);
+void dma_iova_free(struct device *dev, struct dma_iova_state *state);
+#else /* CONFIG_IOMMU_DMA */
+static inline bool dma_use_iova(struct dma_iova_state *state)
+{
+	return false;
+}
+static inline bool dma_iova_try_alloc(struct device *dev,
+		struct dma_iova_state *state, phys_addr_t phys, size_t size)
+{
+	return false;
+}
+static inline void dma_iova_free(struct device *dev,
+		struct dma_iova_state *state)
+{
+}
+#endif /* CONFIG_IOMMU_DMA */
+
 #if defined(CONFIG_HAS_DMA) && defined(CONFIG_DMA_NEED_SYNC)
 void __dma_sync_single_for_cpu(struct device *dev, dma_addr_t addr, size_t size,
 		enum dma_data_direction dir);
-- 
2.47.0


