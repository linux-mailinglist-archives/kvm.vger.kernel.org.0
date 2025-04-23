Return-Path: <kvm+bounces-43882-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E8363A98287
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 10:14:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3568617327D
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 08:14:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6D59270ED4;
	Wed, 23 Apr 2025 08:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iWRbBV32"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD4CA26FDA9;
	Wed, 23 Apr 2025 08:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745396041; cv=none; b=LF4+PKIC3MGdtsoQV5FaLbp3KJ/SyvEhvI3hHuSB0IYeHQGRqsfuolFtYoLo25+9/7xU8Xc1H3uKAJgPwKdDrgHZ3p9Ej1FP5kAE8s7vyamV3FzlQV3o+UZq3vTFHRJHpa6bJ1i1cRhVEbRIsCKMom9CJZ3Y9bBTMNdMeqask4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745396041; c=relaxed/simple;
	bh=ntyAEM4ivirILRCYAooDxCIgXhWM3OZDXa/hz/Q6s3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e8P5MCtSvxBhrpZjX7dLyCUpUuHAWbgifRMAk4Rb55KxWYYgWkM8lmQG2q4PRW1APwSfVgYnewcWU90SJtHcwfUeQ+/mz2yMGoxIRuK4XqR758tSS1ISbBUXdbW2p+ylij8Z49rsw7Dbehay/BQtagZ2nsnesbpK0Hw6mnTJEds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iWRbBV32; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 324F4C4AF09;
	Wed, 23 Apr 2025 08:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745396041;
	bh=ntyAEM4ivirILRCYAooDxCIgXhWM3OZDXa/hz/Q6s3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iWRbBV32dZZ/UP0AVVSi56h6eugDoKF8qNS6m/jZaAzDMfPfeebn0s1U2HsFGOCoD
	 U/E9tAlfuub44yG8kx59Kq15s2hJ5BwwrhPMB/JTJ546biCbuua4/H+lLuj5Zczkqj
	 Dgd37kJDP188KNQWPP4Q+FcX64FrWMliiQrmFXbRvzcRkW8Df51gxoOWhisvge2x1J
	 sDNzYAVRO/SRXF8aUH03r/owPqxSu1w5Bkb5elEzsvEB1YwgAA8AMhPvpU/mcDsxDV
	 gNm2Xpw0Whog/lQAcI09Ri+zG9uFdFkEy7JPOOXVwkvzTqaTUDySSrESKTsDga1iXK
	 S7gNWt+6A3OWw==
From: Leon Romanovsky <leon@kernel.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>
Cc: Jake Edge <jake@lwn.net>,
	Jonathan Corbet <corbet@lwn.net>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Zhu Yanjun <zyjzyj2000@gmail.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
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
	linux-pci@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-mm@kvack.org,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>
Subject: [PATCH v9 03/24] iommu: generalize the batched sync after map interface
Date: Wed, 23 Apr 2025 11:12:54 +0300
Message-ID: <2ce6a74ddf5e13a7fdb731984aa781a15f17749d.1745394536.git.leon@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1745394536.git.leon@kernel.org>
References: <cover.1745394536.git.leon@kernel.org>
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
Acked-by: Will Deacon <will@kernel.org>
Tested-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/iommu/iommu.c | 65 +++++++++++++++++++------------------------
 include/linux/iommu.h |  4 +++
 2 files changed, 33 insertions(+), 36 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index c8033ca66377..3dc47f62d9ff 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2440,8 +2440,8 @@ static size_t iommu_pgsize(struct iommu_domain *domain, unsigned long iova,
 	return pgsize;
 }
 
-static int __iommu_map(struct iommu_domain *domain, unsigned long iova,
-		       phys_addr_t paddr, size_t size, int prot, gfp_t gfp)
+int iommu_map_nosync(struct iommu_domain *domain, unsigned long iova,
+		phys_addr_t paddr, size_t size, int prot, gfp_t gfp)
 {
 	const struct iommu_domain_ops *ops = domain->ops;
 	unsigned long orig_iova = iova;
@@ -2450,12 +2450,19 @@ static int __iommu_map(struct iommu_domain *domain, unsigned long iova,
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
 
@@ -2503,31 +2510,27 @@ static int __iommu_map(struct iommu_domain *domain, unsigned long iova,
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
@@ -2627,26 +2630,17 @@ ssize_t iommu_map_sg(struct iommu_domain *domain, unsigned long iova,
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
 
@@ -2669,11 +2663,10 @@ ssize_t iommu_map_sg(struct iommu_domain *domain, unsigned long iova,
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
index ccce8a751e2a..ce472af8e9c3 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -872,6 +872,10 @@ extern struct iommu_domain *iommu_get_domain_for_dev(struct device *dev);
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
2.49.0


