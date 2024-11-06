Return-Path: <kvm+bounces-30935-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 63FF39BE617
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 12:53:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E87431F21434
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 11:53:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1585B1E883B;
	Wed,  6 Nov 2024 11:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tUNFNNyn"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB881E377C;
	Wed,  6 Nov 2024 11:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730893823; cv=none; b=WpXDnOwUK2raHEn3L8TMjdphhTALtOPud96QUK0XeR3U4g2EVWXyj6QVTQfbQBNgRZOsMKolKmF995NMeUOTEIf0JbrgE6ZY2ar8K5VQnWkwsnA0po4OkDH/lTKqaZZPV88wXhBJxn8qLO3GUgNQZtWtTxrgbiVPZSViMEFkDu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730893823; c=relaxed/simple;
	bh=bZa/AznOguif5HsOvA16Z11mxfxUXbfMG8pYJ8SrELA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gBNR4ZX3UiXjnIv7B0+mhoVmJ7nFdCfiE9+XLmoy91gQejItaKlJzHoc4wfEUxNJfv182EOnKYTCNjn+319qVk6dvzKLAtDybLN58HvxCVR5pYajSq6Ai5JwV6VnVlglY4rpmO2jYTv7P6JKn//mPh4qoxLd2lvel3eJA8GIDzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tUNFNNyn; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7374C4CECD;
	Wed,  6 Nov 2024 11:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730893822;
	bh=bZa/AznOguif5HsOvA16Z11mxfxUXbfMG8pYJ8SrELA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tUNFNNynaJP85RgckeeSFTYXsrvjgAjMHiapU85Ya4oxCE8FogShDgB6mkqqilq81
	 SWTeS7iWEyyK+KSPKz6bi6zCB6oSQdJ+YDsZ4q5a6SxQh8ARCnqOxbKE3wx9t78ahO
	 i5ZVkWKM3JKbLVWX1kIYA3GxHEYvR8zbKsaCUuEsyJQPpeVScLxGphkEb+gpQz1yLo
	 j8MjzB/uiHB2SekvlRyrSirA/5XrgWx/oj89g433a/xrlavy99vhHW3PD0EMKtDXvZ
	 uWuz5HQ64a2FaPtpWjOg9A9JZFnhxqz/Aj74jJ8jDwYmqU2BSv3wMu6liqqLIZU3BQ
	 p1sL5LR9V6iWw==
From: Leon Romanovsky <leon@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Robin Murphy <robin.murphy@arm.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>
Cc: Keith Busch <kbusch@kernel.org>,
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
Subject: [PATCH v2 03/17] iommu: generalize the batched sync after map interface
Date: Wed,  6 Nov 2024 15:49:31 +0200
Message-ID: <589adb3a4b53121942e9a39051ae49a27f7a074c.1730892663.git.leon@kernel.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <cover.1730892663.git.leon@kernel.org>
References: <cover.1730892663.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

For the upcoming IOVA-based DMA API we want to use the interface batch the
sync after mapping multiple entries from dma-iommu without having a
scatterlist.

For that move more sanity checks from the callers into __iommu_map and
make that function available outside of iommu.c as iommu_map_nosync.

Add a wrapper for the map_sync as iommu_sync_map so that callers don't
need to poke into the methods directly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/iommu/iommu.c | 65 +++++++++++++++++++------------------------
 include/linux/iommu.h |  4 +++
 2 files changed, 33 insertions(+), 36 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 83c8e617a2c5..6b0943397e1e 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2439,8 +2439,8 @@ static size_t iommu_pgsize(struct iommu_domain *domain, unsigned long iova,
 	return pgsize;
 }
 
-static int __iommu_map(struct iommu_domain *domain, unsigned long iova,
-		       phys_addr_t paddr, size_t size, int prot, gfp_t gfp)
+int iommu_map_nosync(struct iommu_domain *domain, unsigned long iova,
+		phys_addr_t paddr, size_t size, int prot, gfp_t gfp)
 {
 	const struct iommu_domain_ops *ops = domain->ops;
 	unsigned long orig_iova = iova;
@@ -2449,12 +2449,19 @@ static int __iommu_map(struct iommu_domain *domain, unsigned long iova,
 	phys_addr_t orig_paddr = paddr;
 	int ret = 0;
 
+	might_sleep_if(gfpflags_allow_blocking(gfp));
+
 	if (unlikely(!(domain->type & __IOMMU_DOMAIN_PAGING)))
 		return -EINVAL;
 
 	if (WARN_ON(!ops->map_pages || domain->pgsize_bitmap == 0UL))
 		return -ENODEV;
 
+	/* Discourage passing strange GFP flags */
+	if (WARN_ON_ONCE(gfp & (__GFP_COMP | __GFP_DMA | __GFP_DMA32 |
+				__GFP_HIGHMEM)))
+		return -EINVAL;
+
 	/* find out the minimum page size supported */
 	min_pagesz = 1 << __ffs(domain->pgsize_bitmap);
 
@@ -2502,31 +2509,27 @@ static int __iommu_map(struct iommu_domain *domain, unsigned long iova,
 	return ret;
 }
 
-int iommu_map(struct iommu_domain *domain, unsigned long iova,
-	      phys_addr_t paddr, size_t size, int prot, gfp_t gfp)
+int iommu_sync_map(struct iommu_domain *domain, unsigned long iova, size_t size)
 {
 	const struct iommu_domain_ops *ops = domain->ops;
-	int ret;
-
-	might_sleep_if(gfpflags_allow_blocking(gfp));
 
-	/* Discourage passing strange GFP flags */
-	if (WARN_ON_ONCE(gfp & (__GFP_COMP | __GFP_DMA | __GFP_DMA32 |
-				__GFP_HIGHMEM)))
-		return -EINVAL;
+	if (!ops->iotlb_sync_map)
+		return 0;
+	return ops->iotlb_sync_map(domain, iova, size);
+}
 
-	ret = __iommu_map(domain, iova, paddr, size, prot, gfp);
-	if (ret == 0 && ops->iotlb_sync_map) {
-		ret = ops->iotlb_sync_map(domain, iova, size);
-		if (ret)
-			goto out_err;
-	}
+int iommu_map(struct iommu_domain *domain, unsigned long iova,
+	      phys_addr_t paddr, size_t size, int prot, gfp_t gfp)
+{
+	int ret;
 
-	return ret;
+	ret = iommu_map_nosync(domain, iova, paddr, size, prot, gfp);
+	if (ret)
+		return ret;
 
-out_err:
-	/* undo mappings already done */
-	iommu_unmap(domain, iova, size);
+	ret = iommu_sync_map(domain, iova, size);
+	if (ret)
+		iommu_unmap(domain, iova, size);
 
 	return ret;
 }
@@ -2612,26 +2615,17 @@ ssize_t iommu_map_sg(struct iommu_domain *domain, unsigned long iova,
 		     struct scatterlist *sg, unsigned int nents, int prot,
 		     gfp_t gfp)
 {
-	const struct iommu_domain_ops *ops = domain->ops;
 	size_t len = 0, mapped = 0;
 	phys_addr_t start;
 	unsigned int i = 0;
 	int ret;
 
-	might_sleep_if(gfpflags_allow_blocking(gfp));
-
-	/* Discourage passing strange GFP flags */
-	if (WARN_ON_ONCE(gfp & (__GFP_COMP | __GFP_DMA | __GFP_DMA32 |
-				__GFP_HIGHMEM)))
-		return -EINVAL;
-
 	while (i <= nents) {
 		phys_addr_t s_phys = sg_phys(sg);
 
 		if (len && s_phys != start + len) {
-			ret = __iommu_map(domain, iova + mapped, start,
+			ret = iommu_map_nosync(domain, iova + mapped, start,
 					len, prot, gfp);
-
 			if (ret)
 				goto out_err;
 
@@ -2654,11 +2648,10 @@ ssize_t iommu_map_sg(struct iommu_domain *domain, unsigned long iova,
 			sg = sg_next(sg);
 	}
 
-	if (ops->iotlb_sync_map) {
-		ret = ops->iotlb_sync_map(domain, iova, mapped);
-		if (ret)
-			goto out_err;
-	}
+	ret = iommu_sync_map(domain, iova, mapped);
+	if (ret)
+		goto out_err;
+
 	return mapped;
 
 out_err:
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index bd722f473635..8927e5f996c2 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -799,6 +799,10 @@ extern struct iommu_domain *iommu_get_domain_for_dev(struct device *dev);
 extern struct iommu_domain *iommu_get_dma_domain(struct device *dev);
 extern int iommu_map(struct iommu_domain *domain, unsigned long iova,
 		     phys_addr_t paddr, size_t size, int prot, gfp_t gfp);
+int iommu_map_nosync(struct iommu_domain *domain, unsigned long iova,
+		phys_addr_t paddr, size_t size, int prot, gfp_t gfp);
+int iommu_sync_map(struct iommu_domain *domain, unsigned long iova,
+		size_t size);
 extern size_t iommu_unmap(struct iommu_domain *domain, unsigned long iova,
 			  size_t size);
 extern size_t iommu_unmap_fast(struct iommu_domain *domain,
-- 
2.47.0


