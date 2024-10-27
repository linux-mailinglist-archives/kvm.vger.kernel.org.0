Return-Path: <kvm+bounces-29774-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C2CA9B1E52
	for <lists+kvm@lfdr.de>; Sun, 27 Oct 2024 15:25:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B3F2FB216D9
	for <lists+kvm@lfdr.de>; Sun, 27 Oct 2024 14:25:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FE8418C92F;
	Sun, 27 Oct 2024 14:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vJ4SOP7g"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29EDF15FD01;
	Sun, 27 Oct 2024 14:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730038929; cv=none; b=OBBzNrM+halNZb9WJC+PqmSO/M3/aVaCBxdlnrWz0J0O37Zw6Zc07sCXypmknRYu3pGIq4N3XuYa77YXUjdQN9XXJRKCH6C0Eq3jVUSquAEp+2xG70IDEVUW7PaLIyI3qo0cb5g3OxQU+f4lRKss/Ush/SYbytIjlecr0dHVK4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730038929; c=relaxed/simple;
	bh=obFrC/8mEpgTohWqbSf2NYuferMlyIrijdEaJsyBjag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VlYfl3z3irhvGgt97F1LvBB1/v9YqAau5Ln2fKBLEsQXBOYad1rYF0Obl6CqxwXtCQD2q6HPgaL0hwmDiqO5G6prRPD2mVzZ5xdy0Ln8cNIt94Ny/AUSJnUcueOD1Mzs1S8oCFGqsKxi7FNZt7uTNshIB37vuJdOMWV471pYhrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vJ4SOP7g; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D842BC4CEC3;
	Sun, 27 Oct 2024 14:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730038928;
	bh=obFrC/8mEpgTohWqbSf2NYuferMlyIrijdEaJsyBjag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vJ4SOP7gvCOmSakM9GmH61r5dlq/Vh89T+kjFaLLN13hmZfQf1jhZ7VnJUvpO8RS4
	 Ot3h88WLGyBGodBhbgLFLO1oRjoH2dXt3/qea4ZIVujmyq7q3rs6aftzpdKbd7dkwe
	 iOFz72QAKcFESW/zKQLGKVCBDj6ce/d2SSag7jvmvjfIppKDQf2PdUc3aVWYQaKjX9
	 Ef5ORwF0V0m4xYd8ZkrUAFuAiBSVYhj9uTpCNLQOiwkzTg1y7CbjTrKVVGc/9UVgW5
	 JRPQ3E00Lla8siHhJD3YV2HS3Up33U/zketrX8P/VXaRAoQEMFgZ6k1BDQvsGyfH2E
	 tWdMh0n6h7Jkg==
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
Subject: [PATCH 05/18] dma: Provide an interface to allow allocate IOVA
Date: Sun, 27 Oct 2024 16:21:05 +0200
Message-ID: <844f3dcf9c341b8178bfbc90909ef13d11dd2193.1730037276.git.leon@kernel.org>
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

The existing .map_page() callback provides both allocating of IOVA
and linking DMA pages. That combination works great for most of the
callers who use it in control paths, but is less effective in fast
paths where there may be multiple calls to map_page().

These advanced callers already manage their data in some sort of
database and can perform IOVA allocation in advance, leaving range
linkage operation to be in fast path.

Provide an interface to allocate/deallocate IOVA and next patch
link/unlink DMA ranges to that specific IOVA.

The API is exported from dma-iommu as it is the only implementation
supported, the namespace is clearly different from iommu_* functions
which are not allowed to be used. This code layout allows us to save
function call per API call used in datapath as well as a lot of boilerplate
code.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/iommu/dma-iommu.c   | 79 +++++++++++++++++++++++++++++++++++++
 include/linux/dma-mapping.h | 15 +++++++
 2 files changed, 94 insertions(+)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index c422e36c0d66..0644152c5aad 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -1745,6 +1745,85 @@ size_t iommu_dma_max_mapping_size(struct device *dev)
 	return SIZE_MAX;
 }
 
+static bool iommu_dma_iova_alloc(struct device *dev,
+		struct dma_iova_state *state, phys_addr_t phys, size_t size)
+{
+	struct iommu_domain *domain = iommu_get_dma_domain(dev);
+	struct iommu_dma_cookie *cookie = domain->iova_cookie;
+	struct iova_domain *iovad = &cookie->iovad;
+	size_t iova_off = iova_offset(iovad, phys);
+	dma_addr_t addr;
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
+
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
+	memset(state, 0, sizeof(*state));
+	if (!use_dma_iommu(dev))
+		return false;
+	if (static_branch_unlikely(&iommu_deferred_attach_enabled) &&
+	    iommu_deferred_attach(dev, iommu_get_domain_for_dev(dev)))
+		return false;
+	return iommu_dma_iova_alloc(dev, state, phys, size);
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
index 6075e0708deb..817f11bce7bc 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -11,6 +11,7 @@
 #include <linux/scatterlist.h>
 #include <linux/bug.h>
 #include <linux/mem_encrypt.h>
+#include <linux/iommu.h>
 
 /**
  * List of possible attributes associated with a DMA mapping. The semantics
@@ -77,6 +78,7 @@
 #define DMA_BIT_MASK(n)	(((n) == 64) ? ~0ULL : ((1ULL<<(n))-1))
 
 struct dma_iova_state {
+	dma_addr_t addr;
 	size_t __size;
 };
 
@@ -307,11 +309,24 @@ static inline bool dma_use_iova(struct dma_iova_state *state)
 {
 	return state->__size != 0;
 }
+
+bool dma_iova_try_alloc(struct device *dev, struct dma_iova_state *state,
+		phys_addr_t phys, size_t size);
+void dma_iova_free(struct device *dev, struct dma_iova_state *state);
 #else /* CONFIG_IOMMU_DMA */
 static inline bool dma_use_iova(struct dma_iova_state *state)
 {
 	return false;
 }
+static inline bool dma_iova_try_alloc(struct device *dev,
+		struct dma_iova_state *state, phys_addr_t phys, size_t size)
+{
+	return false;
+}
+static inline void dma_iova_free(struct device *dev,
+		struct dma_iova_state *state)
+{
+}
 #endif /* CONFIG_IOMMU_DMA */
 
 #if defined(CONFIG_HAS_DMA) && defined(CONFIG_DMA_NEED_SYNC)
-- 
2.46.2


