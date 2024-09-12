Return-Path: <kvm+bounces-26701-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EA539767B8
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 13:25:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5FF1B2816CB
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 11:25:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 113241BE249;
	Thu, 12 Sep 2024 11:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QFWaxyYp"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2960B1BDAAF;
	Thu, 12 Sep 2024 11:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726139838; cv=none; b=iRSQSxAe8pit+GvsSlL/wdaKsI91BUIJl4uO3SR4smYqvJxemPADJN1/2K6kekhuEOXfyoKhyRCgeTq3M42LjKOadurzWJ2iCuQRV3ffcRTm/7lKiqY/qiuLAprJqrd0HgkzdcMMjujU+aQdDpM8/QMJpAHJYpRfxbW38bdju28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726139838; c=relaxed/simple;
	bh=wkFj1cXNmX5ZlhYlYscU+J0rWGL2pg30iH0xC9v8VVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UPOwg7vM41VyNKl4GGMMrrvp/vu6He2klpQOfgk2QyzBq1gDljFaY+1Ne5xgFK0C2yoCsVP5/d4iTWBvr7XeOKc0AYUuWLiELvzQfEIeDbenlu27QQIz7TegK2FkE7gzyBgiZzS9tllJOOimfgMQZNlDJqwUxETSfB2SZU/TlxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QFWaxyYp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0BF2C4CEC3;
	Thu, 12 Sep 2024 11:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726139837;
	bh=wkFj1cXNmX5ZlhYlYscU+J0rWGL2pg30iH0xC9v8VVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QFWaxyYpYfe2FFX+K0p+Goy6dyaOFgOpyojuT6rJgqucu1wtXJ7Ko6B4Z9/VXe95S
	 2I3S4vrw+Ff5zb5nynL5Vh4Yw/g8+uv0ZNC87b03g7DhVrmV3YivYg7uBbwVNe/GZG
	 +MBvLijRXvMiwL3ZM84io5kv0P8Wbcp45n4DIbM7CtyDWAAQlTWkB20jUCGxLF406f
	 CPRu/FtyIHE0iWOhGGjqbS+ZeLgoViJvPDk3twLQyYGb5FUYjNquCd5o/JMVAX1ObX
	 p/Oa3w5s2HlnKu34VY+AD80OkZOKYp43R+53dQV6GuLtLI/rUJqwRY2wXjSwusplbM
	 Yvypy/0K4VPSA==
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
Subject: [RFC v2 13/21] RDMA/umem: Prevent UMEM ODP creation with SWIOTLB
Date: Thu, 12 Sep 2024 14:15:48 +0300
Message-ID: <aea35c71f773eb6925dd1fcd9a8f6ac5fd87a4c5.1726138681.git.leon@kernel.org>
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

RDMA UMEM never supported DMA addresses returned from SWIOTLB, as these
addresses should be programmed to the hardware which is not aware that
it is bounce buffers and not real ones.

Instead of silently leave broken system for the users who didn't
know it, let's be explicit and return an error to them.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/core/umem_odp.c | 78 +++++++++++++++---------------
 drivers/iommu/dma-iommu.c          |  1 +
 2 files changed, 40 insertions(+), 39 deletions(-)

diff --git a/drivers/infiniband/core/umem_odp.c b/drivers/infiniband/core/umem_odp.c
index 7bfa1e54454c..58fc3d4bfb73 100644
--- a/drivers/infiniband/core/umem_odp.c
+++ b/drivers/infiniband/core/umem_odp.c
@@ -42,7 +42,7 @@
 #include <linux/interval_tree.h>
 #include <linux/hmm.h>
 #include <linux/pagemap.h>
-
+#include <linux/iommu-dma.h>
 #include <rdma/ib_umem_odp.h>
 
 #include "uverbs.h"
@@ -51,49 +51,49 @@ static inline int ib_init_umem_odp(struct ib_umem_odp *umem_odp,
 				   const struct mmu_interval_notifier_ops *ops)
 {
 	struct ib_device *dev = umem_odp->umem.ibdev;
+	size_t page_size = 1UL << umem_odp->page_shift;
+	unsigned long start, end;
+	size_t ndmas, npfns;
 	int ret;
 
 	umem_odp->umem.is_odp = 1;
 	mutex_init(&umem_odp->umem_mutex);
+	if (umem_odp->is_implicit_odp)
+		return 0;
+
+	if (!iommu_can_use_iova(dev->dma_device, NULL, page_size,
+				DMA_BIDIRECTIONAL))
+		return -EOPNOTSUPP;
+
+	start = ALIGN_DOWN(umem_odp->umem.address, page_size);
+	if (check_add_overflow(umem_odp->umem.address,
+			       (unsigned long)umem_odp->umem.length, &end))
+		return -EOVERFLOW;
+	end = ALIGN(end, page_size);
+	if (unlikely(end < page_size))
+		return -EOVERFLOW;
+
+	ndmas = (end - start) >> umem_odp->page_shift;
+	if (!ndmas)
+		return -EINVAL;
+
+	npfns = (end - start) >> PAGE_SHIFT;
+	umem_odp->pfn_list =
+		kvcalloc(npfns, sizeof(*umem_odp->pfn_list), GFP_KERNEL);
+	if (!umem_odp->pfn_list)
+		return -ENOMEM;
+
+	dma_init_iova_state(&umem_odp->state, dev->dma_device,
+			    DMA_BIDIRECTIONAL);
+	ret = dma_alloc_iova(&umem_odp->state, end - start);
+	if (ret)
+		goto out_pfn_list;
 
-	if (!umem_odp->is_implicit_odp) {
-		size_t page_size = 1UL << umem_odp->page_shift;
-		unsigned long start;
-		unsigned long end;
-		size_t ndmas, npfns;
-
-		start = ALIGN_DOWN(umem_odp->umem.address, page_size);
-		if (check_add_overflow(umem_odp->umem.address,
-				       (unsigned long)umem_odp->umem.length,
-				       &end))
-			return -EOVERFLOW;
-		end = ALIGN(end, page_size);
-		if (unlikely(end < page_size))
-			return -EOVERFLOW;
-
-		ndmas = (end - start) >> umem_odp->page_shift;
-		if (!ndmas)
-			return -EINVAL;
-
-		npfns = (end - start) >> PAGE_SHIFT;
-		umem_odp->pfn_list = kvcalloc(
-			npfns, sizeof(*umem_odp->pfn_list), GFP_KERNEL);
-		if (!umem_odp->pfn_list)
-			return -ENOMEM;
-
-
-		dma_init_iova_state(&umem_odp->state, dev->dma_device,
-				    DMA_BIDIRECTIONAL);
-		ret = dma_alloc_iova(&umem_odp->state, end - start);
-		if (ret)
-			goto out_pfn_list;
-
-		ret = mmu_interval_notifier_insert(&umem_odp->notifier,
-						   umem_odp->umem.owning_mm,
-						   start, end - start, ops);
-		if (ret)
-			goto out_free_iova;
-	}
+	ret = mmu_interval_notifier_insert(&umem_odp->notifier,
+					   umem_odp->umem.owning_mm, start,
+					   end - start, ops);
+	if (ret)
+		goto out_free_iova;
 
 	return 0;
 
diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 3e2e382bb502..af3428ae150d 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -1849,6 +1849,7 @@ bool iommu_can_use_iova(struct device *dev, struct page *page, size_t size,
 
 	return true;
 }
+EXPORT_SYMBOL_GPL(iommu_can_use_iova);
 
 void iommu_setup_dma_ops(struct device *dev)
 {
-- 
2.46.0


