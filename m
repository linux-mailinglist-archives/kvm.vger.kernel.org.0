Return-Path: <kvm+bounces-20835-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DB2FD923963
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 11:15:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9641A1F238F0
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 09:15:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14FEC155A23;
	Tue,  2 Jul 2024 09:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KTz8NtUc"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2189B15574C;
	Tue,  2 Jul 2024 09:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719911446; cv=none; b=FOyAjPHCyMdFvv2SOrQPrF9am/Pj6AQ6Nc9sil4iahw1JIWQx6KLQtkSIIxaQlauGN8DeQRNWcFETD9Yxad3yygP3pHXBnaUzMAs3fROxCJg7b0JD6kBSd89IcDKX/ZXR2Q+tBpvQXRA9ShrOfkW8jD+3CVTH3H+k64f1lU2zrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719911446; c=relaxed/simple;
	bh=pdK7V9xHdNBFoHCz59AGR5WOTx5xl2Vj8twOHvengYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TTdreByZ+XQlCsYIvdOuU+FizXCcoaCsSUsuEtqqZHDOTuTa8EyymRCTxooNxE7L/qu04NSbzJ97d2oBk9p17iE9VXJdDwUs9OzipIU7Kg8nSfTTxrJjmXEkxoDHg4XveIAuuciFsd1gpSs1bPeoIff3DBjiO3mlJmjN14kklGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KTz8NtUc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB9F3C4AF0A;
	Tue,  2 Jul 2024 09:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719911445;
	bh=pdK7V9xHdNBFoHCz59AGR5WOTx5xl2Vj8twOHvengYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KTz8NtUcFIGsDCeQDH+Db9PamT6/nlViuegQcsznIc+DF9srj7x240NEr4il//Xc/
	 8i6luwPgO0yiJWdOnRcYYR5NL7yfawxlEKbv7drJYa8B4a339djv3OvkkqYT8c8H3F
	 2fawWfN+3TdW5300DYyGBMMir31FVKME3Mb0rFDkEafNNmyz4K9325deM1XSwCqvmZ
	 j68Pmkr7YplRS9KcdrYMe4vUV3x2d5CnPCIdbVmN1wj2l59g8sgHeEOk1PKw3gUGEO
	 sLuttA9bzZDdVviGMe/UOzCvZZ/jZMpHBqkeBTmM9HISPNn+o452NCrh1hoAqBSCYz
	 dRKD1bcV6Pa7w==
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
Subject: [RFC PATCH v1 12/18] RDMA/umem: Prevent UMEM ODP creation with SWIOTLB
Date: Tue,  2 Jul 2024 12:09:42 +0300
Message-ID: <d18c454636bf3cfdba9b66b7cc794d713eadc4a5.1719909395.git.leon@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1719909395.git.leon@kernel.org>
References: <cover.1719909395.git.leon@kernel.org>
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
 drivers/infiniband/core/umem_odp.c | 81 +++++++++++++++---------------
 1 file changed, 41 insertions(+), 40 deletions(-)

diff --git a/drivers/infiniband/core/umem_odp.c b/drivers/infiniband/core/umem_odp.c
index 6e170cb5110c..12186717a892 100644
--- a/drivers/infiniband/core/umem_odp.c
+++ b/drivers/infiniband/core/umem_odp.c
@@ -42,7 +42,8 @@
 #include <linux/interval_tree.h>
 #include <linux/hmm.h>
 #include <linux/pagemap.h>
-
+#include <linux/dma-map-ops.h>
+#include <linux/swiotlb.h>
 #include <rdma/ib_umem_odp.h>
 
 #include "uverbs.h"
@@ -51,50 +52,50 @@ static inline int ib_init_umem_odp(struct ib_umem_odp *umem_odp,
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
+	if (dev_use_swiotlb(dev->dma_device, page_size, DMA_BIDIRECTIONAL) ||
+	    is_swiotlb_force_bounce(dev->dma_device))
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
+	umem_odp->iova.dev = dev->dma_device;
+	umem_odp->iova.size = end - start;
+	umem_odp->iova.dir = DMA_BIDIRECTIONAL;
+	ret = dma_alloc_iova(&umem_odp->iova);
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
-		umem_odp->iova.dev = dev->dma_device;
-		umem_odp->iova.size = end - start;
-		umem_odp->iova.dir = DMA_BIDIRECTIONAL;
-		ret = dma_alloc_iova(&umem_odp->iova);
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
 
-- 
2.45.2


