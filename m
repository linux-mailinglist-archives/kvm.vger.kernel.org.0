Return-Path: <kvm+bounces-26685-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 841C8976759
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 13:17:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 48431283CEE
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 11:17:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49CF81A3052;
	Thu, 12 Sep 2024 11:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ElXcUbpH"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53616194AD7;
	Thu, 12 Sep 2024 11:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726139772; cv=none; b=CQ800Uy6J9Kwd11MJ5jbemniajt/PjeFSFBcFrYGg4tDS/MnNtJvBKClqX+PP4+21BayUQggMy7cqWDMJnlUonUzky+OVQBGiLGhBU819moZ61CCp8sfwEC/oL8qX6B4wc254Ug3b+reeS/ZooJwHU/jQwrfbHqTXGJkJdo99HA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726139772; c=relaxed/simple;
	bh=wScFwwk329QxKWfLLj8pz7NHQQe+VUBRN1u2NOeObGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D7oU1cqL2FiqlHO03oTeb3hbeaxzS/e7uxxc9CpvZ8CyBvPlGLxdtBM1wkDXkaOnLFffrw1WM0SGixiky5jkPTv31FL5o8EtJmudu6xT6zMhmwAqVhoje/3GJX4Z2nhB6o/xv1RbTx1I+wqfSmls0u2s2UWuOatkdseMmx5gggs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ElXcUbpH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 126DEC4CEC3;
	Thu, 12 Sep 2024 11:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726139771;
	bh=wScFwwk329QxKWfLLj8pz7NHQQe+VUBRN1u2NOeObGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ElXcUbpHs5KI2K+PlHKsjpKVaEdXIxDpLVBVHKF4mWEuE2E7Ocs9+wyk4s1iPJPZl
	 MksOnT4XNgcgbVxPfE2E5QYww/ITakbKdUQDYgbzYGmg/vX++ZK2D4Lanvdqp+YK95
	 ZXZcZyroMhH2X46lASJh3WD5m7PC3YPmecSgvvLBCwJeZ22yUP66AhIpUjdeWqJsPz
	 QrVBKcD5kMCzIh+oE7Oa4e8rYNzkrM0zuv78ko8JsMq1aKACqwkFXDOZsH3otwMUTy
	 p5EkgVVvI2x8IWEdGZtUfwuKhR+nBBCQZLf3AiKXGSgFqxAIegmk3Tdh282tqbQyGP
	 +ryDDdtJImP5A==
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
Subject: [RFC v2 01/21] iommu/dma: Provide an interface to allow preallocate IOVA
Date: Thu, 12 Sep 2024 14:15:36 +0300
Message-ID: <8ae3944565cd7b140625a71b8c7e74ca466bd3ec.1726138681.git.leon@kernel.org>
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

Separate IOVA allocation to dedicated callback so it will allow
cache of IOVA and reuse it in fast paths for devices which support
ODP (on-demand-paging) mechanism.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/iommu/dma-iommu.c | 57 ++++++++++++++++++++++++++++++---------
 include/linux/iommu-dma.h | 11 ++++++++
 2 files changed, 56 insertions(+), 12 deletions(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 65a38b5695f9..09deea2fc86b 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -358,7 +358,7 @@ int iommu_dma_init_fq(struct iommu_domain *domain)
 	atomic_set(&cookie->fq_timer_on, 0);
 	/*
 	 * Prevent incomplete fq state being observable. Pairs with path from
-	 * __iommu_dma_unmap() through iommu_dma_free_iova() to queue_iova()
+	 * __iommu_dma_unmap() through __iommu_dma_free_iova() to queue_iova()
 	 */
 	smp_wmb();
 	WRITE_ONCE(cookie->fq_domain, domain);
@@ -759,7 +759,7 @@ static int dma_info_to_prot(enum dma_data_direction dir, bool coherent,
 	}
 }
 
-static dma_addr_t iommu_dma_alloc_iova(struct iommu_domain *domain,
+static dma_addr_t __iommu_dma_alloc_iova(struct iommu_domain *domain,
 		size_t size, u64 dma_limit, struct device *dev)
 {
 	struct iommu_dma_cookie *cookie = domain->iova_cookie;
@@ -805,7 +805,7 @@ static dma_addr_t iommu_dma_alloc_iova(struct iommu_domain *domain,
 	return (dma_addr_t)iova << shift;
 }
 
-static void iommu_dma_free_iova(struct iommu_dma_cookie *cookie,
+static void __iommu_dma_free_iova(struct iommu_dma_cookie *cookie,
 		dma_addr_t iova, size_t size, struct iommu_iotlb_gather *gather)
 {
 	struct iova_domain *iovad = &cookie->iovad;
@@ -842,7 +842,7 @@ static void __iommu_dma_unmap(struct device *dev, dma_addr_t dma_addr,
 
 	if (!iotlb_gather.queued)
 		iommu_iotlb_sync(domain, &iotlb_gather);
-	iommu_dma_free_iova(cookie, dma_addr, size, &iotlb_gather);
+	__iommu_dma_free_iova(cookie, dma_addr, size, &iotlb_gather);
 }
 
 static dma_addr_t __iommu_dma_map(struct device *dev, phys_addr_t phys,
@@ -865,12 +865,12 @@ static dma_addr_t __iommu_dma_map(struct device *dev, phys_addr_t phys,
 
 	size = iova_align(iovad, size + iova_off);
 
-	iova = iommu_dma_alloc_iova(domain, size, dma_mask, dev);
+	iova = __iommu_dma_alloc_iova(domain, size, dma_mask, dev);
 	if (!iova)
 		return DMA_MAPPING_ERROR;
 
 	if (iommu_map(domain, iova, phys - iova_off, size, prot, GFP_ATOMIC)) {
-		iommu_dma_free_iova(cookie, iova, size, NULL);
+		__iommu_dma_free_iova(cookie, iova, size, NULL);
 		return DMA_MAPPING_ERROR;
 	}
 	return iova + iova_off;
@@ -973,7 +973,7 @@ static struct page **__iommu_dma_alloc_noncontiguous(struct device *dev,
 		return NULL;
 
 	size = iova_align(iovad, size);
-	iova = iommu_dma_alloc_iova(domain, size, dev->coherent_dma_mask, dev);
+	iova = __iommu_dma_alloc_iova(domain, size, dev->coherent_dma_mask, dev);
 	if (!iova)
 		goto out_free_pages;
 
@@ -1007,7 +1007,7 @@ static struct page **__iommu_dma_alloc_noncontiguous(struct device *dev,
 out_free_sg:
 	sg_free_table(sgt);
 out_free_iova:
-	iommu_dma_free_iova(cookie, iova, size, NULL);
+	__iommu_dma_free_iova(cookie, iova, size, NULL);
 out_free_pages:
 	__iommu_dma_free_pages(pages, count);
 	return NULL;
@@ -1434,7 +1434,7 @@ int iommu_dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 	if (!iova_len)
 		return __finalise_sg(dev, sg, nents, 0);
 
-	iova = iommu_dma_alloc_iova(domain, iova_len, dma_get_mask(dev), dev);
+	iova = __iommu_dma_alloc_iova(domain, iova_len, dma_get_mask(dev), dev);
 	if (!iova) {
 		ret = -ENOMEM;
 		goto out_restore_sg;
@@ -1451,7 +1451,7 @@ int iommu_dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 	return __finalise_sg(dev, sg, nents, iova);
 
 out_free_iova:
-	iommu_dma_free_iova(cookie, iova, iova_len, NULL);
+	__iommu_dma_free_iova(cookie, iova, iova_len, NULL);
 out_restore_sg:
 	__invalidate_sg(sg, nents);
 out:
@@ -1710,6 +1710,39 @@ size_t iommu_dma_max_mapping_size(struct device *dev)
 	return SIZE_MAX;
 }
 
+int iommu_dma_alloc_iova(struct dma_iova_state *state, phys_addr_t phys,
+			 size_t size)
+{
+	struct iommu_domain *domain = iommu_get_dma_domain(state->dev);
+	struct iommu_dma_cookie *cookie = domain->iova_cookie;
+	struct iova_domain *iovad = &cookie->iovad;
+	dma_addr_t addr;
+
+	size = iova_align(iovad, size + iova_offset(iovad, phys));
+	addr = __iommu_dma_alloc_iova(domain, size, dma_get_mask(state->dev),
+				      state->dev);
+	if (addr == DMA_MAPPING_ERROR)
+		return -EINVAL;
+
+	state->addr = addr;
+	state->size = size;
+	return 0;
+}
+
+void iommu_dma_free_iova(struct dma_iova_state *state)
+{
+	struct iommu_domain *domain = iommu_get_dma_domain(state->dev);
+	struct iommu_dma_cookie *cookie = domain->iova_cookie;
+	struct iova_domain *iovad = &cookie->iovad;
+	size_t iova_off = iova_offset(iovad, state->addr);
+	struct iommu_iotlb_gather iotlb_gather;
+
+	iommu_iotlb_gather_init(&iotlb_gather);
+	__iommu_dma_free_iova(cookie, state->addr - iova_off,
+			      iova_align(iovad, state->size + iova_off),
+			      &iotlb_gather);
+}
+
 void iommu_setup_dma_ops(struct device *dev)
 {
 	struct iommu_domain *domain = iommu_get_domain_for_dev(dev);
@@ -1746,7 +1779,7 @@ static struct iommu_dma_msi_page *iommu_dma_get_msi_page(struct device *dev,
 	if (!msi_page)
 		return NULL;
 
-	iova = iommu_dma_alloc_iova(domain, size, dma_get_mask(dev), dev);
+	iova = __iommu_dma_alloc_iova(domain, size, dma_get_mask(dev), dev);
 	if (!iova)
 		goto out_free_page;
 
@@ -1760,7 +1793,7 @@ static struct iommu_dma_msi_page *iommu_dma_get_msi_page(struct device *dev,
 	return msi_page;
 
 out_free_iova:
-	iommu_dma_free_iova(cookie, iova, size, NULL);
+	__iommu_dma_free_iova(cookie, iova, size, NULL);
 out_free_page:
 	kfree(msi_page);
 	return NULL;
diff --git a/include/linux/iommu-dma.h b/include/linux/iommu-dma.h
index 13874f95d77f..698df67b152a 100644
--- a/include/linux/iommu-dma.h
+++ b/include/linux/iommu-dma.h
@@ -57,6 +57,9 @@ void iommu_dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sgl,
 			       int nelems, enum dma_data_direction dir);
 void iommu_dma_sync_sg_for_device(struct device *dev, struct scatterlist *sgl,
 				  int nelems, enum dma_data_direction dir);
+int iommu_dma_alloc_iova(struct dma_iova_state *state, phys_addr_t phys,
+			 size_t size);
+void iommu_dma_free_iova(struct dma_iova_state *state);
 #else
 static inline bool use_dma_iommu(struct device *dev)
 {
@@ -173,5 +176,13 @@ static inline void iommu_dma_sync_sg_for_device(struct device *dev,
 						enum dma_data_direction dir)
 {
 }
+static inline int iommu_dma_alloc_iova(struct dma_iova_state *state,
+				       phys_addr_t phys, size_t size)
+{
+	return -EOPNOTSUPP;
+}
+static inline void iommu_dma_free_iova(struct dma_iova_state *state)
+{
+}
 #endif /* CONFIG_IOMMU_DMA */
 #endif /* _LINUX_IOMMU_DMA_H */
-- 
2.46.0


