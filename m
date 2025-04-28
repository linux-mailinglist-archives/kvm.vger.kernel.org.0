Return-Path: <kvm+bounces-44536-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 07AB4A9EBDF
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 11:25:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 23D6117BC36
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 09:25:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A0C7266F08;
	Mon, 28 Apr 2025 09:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PqmGfJdc"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E0E825F96B;
	Mon, 28 Apr 2025 09:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745832187; cv=none; b=NnYUc9WWkUM+e5dPgI0MPW1AWXLNKwFNmPGfOlM6W8X41KwFNmndeyL7eICUezpo9VYhVdHbhfPPHyoNgIGOnBo3yfgb04aXFWTQk+xU4m+jGZ3a4Mt16Gcx8cFKF10qaC3GAfEp/A5TT6RYeXSHfJfTjSzTPEhZ6W6BzTRF/VY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745832187; c=relaxed/simple;
	bh=0JHkJ3yc+gAWUe6Cn00MEeufheTpl4eLgTynVx9oj5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=az+WjG+QnC48y9rkkFq0Hn0o/Cw1WIEr3e4njZF4RQxKP0hO7w+vFLe8Qtw/BPrSeRHiRKdeqfEPVper13xkQDKG1oc/SAu7xH0DmQrxU+zOrvw4ecDE9urtbzBxomPHLLg0W2TbAQ0qowOjkq7HhWXhGp2kWhajgj55vmjnHkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PqmGfJdc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B7CFC4CEE4;
	Mon, 28 Apr 2025 09:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745832187;
	bh=0JHkJ3yc+gAWUe6Cn00MEeufheTpl4eLgTynVx9oj5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PqmGfJdcNXSWtK9ZUr/VZuQVATSjN4FCICu9QvOjQ5DFimCvpDJNBXHHRfXKE4d0f
	 JSfdtg+/yURTLqlGkkjWhIP/+bLkaey8ndkjjCWv7Pmda9drOgqolG5sO0/xK8phy1
	 M1bamGvI/HUYk59FrSxjJodLMEVZQAN0v0cnSkOGKPCsab0uBqMn4YH97NLy505u+y
	 NPLiCd86bDRwc6qTWqjtnq+cD0ihAbz1ZorWks4/3uOYAZsA5mAb9TFncOXGZM5Gnj
	 IOohfCcCDYKXmzfgsFUUlIffxZ68XVFQiK2Q4uEACJ73pihFUgrcFqu4MHI/n1tHxp
	 roqnmUkSZ/rbw==
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
Subject: [PATCH v10 06/24] iommu/dma: Factor out a iommu_dma_map_swiotlb helper
Date: Mon, 28 Apr 2025 12:22:12 +0300
Message-ID: <f9a6a7874760a2919bea1f255bb3c81c6369ed1c.1745831017.git.leon@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1745831017.git.leon@kernel.org>
References: <cover.1745831017.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

Split the iommu logic from iommu_dma_map_page into a separate helper.
This not only keeps the code neatly separated, but will also allow for
reuse in another caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Tested-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/iommu/dma-iommu.c | 73 ++++++++++++++++++++++-----------------
 1 file changed, 41 insertions(+), 32 deletions(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index d3211a8d755e..d7684024c439 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -1138,6 +1138,43 @@ void iommu_dma_sync_sg_for_device(struct device *dev, struct scatterlist *sgl,
 			arch_sync_dma_for_device(sg_phys(sg), sg->length, dir);
 }
 
+static phys_addr_t iommu_dma_map_swiotlb(struct device *dev, phys_addr_t phys,
+		size_t size, enum dma_data_direction dir, unsigned long attrs)
+{
+	struct iommu_domain *domain = iommu_get_dma_domain(dev);
+	struct iova_domain *iovad = &domain->iova_cookie->iovad;
+
+	if (!is_swiotlb_active(dev)) {
+		dev_warn_once(dev, "DMA bounce buffers are inactive, unable to map unaligned transaction.\n");
+		return (phys_addr_t)DMA_MAPPING_ERROR;
+	}
+
+	trace_swiotlb_bounced(dev, phys, size);
+
+	phys = swiotlb_tbl_map_single(dev, phys, size, iova_mask(iovad), dir,
+			attrs);
+
+	/*
+	 * Untrusted devices should not see padding areas with random leftover
+	 * kernel data, so zero the pre- and post-padding.
+	 * swiotlb_tbl_map_single() has initialized the bounce buffer proper to
+	 * the contents of the original memory buffer.
+	 */
+	if (phys != (phys_addr_t)DMA_MAPPING_ERROR && dev_is_untrusted(dev)) {
+		size_t start, virt = (size_t)phys_to_virt(phys);
+
+		/* Pre-padding */
+		start = iova_align_down(iovad, virt);
+		memset((void *)start, 0, virt - start);
+
+		/* Post-padding */
+		start = virt + size;
+		memset((void *)start, 0, iova_align(iovad, start) - start);
+	}
+
+	return phys;
+}
+
 dma_addr_t iommu_dma_map_page(struct device *dev, struct page *page,
 	      unsigned long offset, size_t size, enum dma_data_direction dir,
 	      unsigned long attrs)
@@ -1151,42 +1188,14 @@ dma_addr_t iommu_dma_map_page(struct device *dev, struct page *page,
 	dma_addr_t iova, dma_mask = dma_get_mask(dev);
 
 	/*
-	 * If both the physical buffer start address and size are
-	 * page aligned, we don't need to use a bounce page.
+	 * If both the physical buffer start address and size are page aligned,
+	 * we don't need to use a bounce page.
 	 */
 	if (dev_use_swiotlb(dev, size, dir) &&
 	    iova_offset(iovad, phys | size)) {
-		if (!is_swiotlb_active(dev)) {
-			dev_warn_once(dev, "DMA bounce buffers are inactive, unable to map unaligned transaction.\n");
-			return DMA_MAPPING_ERROR;
-		}
-
-		trace_swiotlb_bounced(dev, phys, size);
-
-		phys = swiotlb_tbl_map_single(dev, phys, size,
-					      iova_mask(iovad), dir, attrs);
-
-		if (phys == DMA_MAPPING_ERROR)
+		phys = iommu_dma_map_swiotlb(dev, phys, size, dir, attrs);
+		if (phys == (phys_addr_t)DMA_MAPPING_ERROR)
 			return DMA_MAPPING_ERROR;
-
-		/*
-		 * Untrusted devices should not see padding areas with random
-		 * leftover kernel data, so zero the pre- and post-padding.
-		 * swiotlb_tbl_map_single() has initialized the bounce buffer
-		 * proper to the contents of the original memory buffer.
-		 */
-		if (dev_is_untrusted(dev)) {
-			size_t start, virt = (size_t)phys_to_virt(phys);
-
-			/* Pre-padding */
-			start = iova_align_down(iovad, virt);
-			memset((void *)start, 0, virt - start);
-
-			/* Post-padding */
-			start = virt + size;
-			memset((void *)start, 0,
-			       iova_align(iovad, start) - start);
-		}
 	}
 
 	if (!coherent && !(attrs & DMA_ATTR_SKIP_CPU_SYNC))
-- 
2.49.0


