Return-Path: <kvm+bounces-43887-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7293AA982B0
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 10:17:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 704D618919E0
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 08:17:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C56F627933C;
	Wed, 23 Apr 2025 08:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ab3QxyUR"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1D2727932D;
	Wed, 23 Apr 2025 08:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745396063; cv=none; b=V5tMx0OiD/s3DSqMiWJ/bF/gOWeXKEj5jcS8tHGw7ycjWTJcPUYWH0TkIafRqH7JcfN9xl34UL6b5ApX7kh/Fhw660gDrCmCXcSwHAhse0cIYYFbh5DV/p7HS+5uYeMS8jpKrwTQajoXKQd9OxzwPG4ubQh4ER7+4PY8fWXKchs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745396063; c=relaxed/simple;
	bh=uAyqUew9YbHt6BqNCxqg/xSEI2KBPG3SEWmdj1qq/2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GfDPaln8Dlx9Nud2Zfm0c2uDuFFBRWTwmb6qkmbosmmd9slLDUK69pZugSHkHvaXsHdrFRRiHrFx8U7cSxyFGjb9pWaZV7uQOmQEROymNDgUj39od0nBoVixKtyII3WN6kZrxlTlXmZIyNKJBcalRiQ5RGogBjgioTEL9EUlBsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ab3QxyUR; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5478C4CEEA;
	Wed, 23 Apr 2025 08:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745396063;
	bh=uAyqUew9YbHt6BqNCxqg/xSEI2KBPG3SEWmdj1qq/2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ab3QxyUR3AxcfYmJpPAjvqg3xVX9ODRdOtP4JjD+gjlPYMs4aWD0v0tpV2XnmQsxA
	 0KPdYd02efI42gcXRsCWx2Kb+9opFXjZbR1HUjikV3RjBmXKsyXdtf26St3GlCyMQn
	 RmKtt/ojtBWdmNBJhgfOTqas5pc7ykEsC9TyqD6y0FRFzYkspoz7H9ae32vwWiNMuc
	 QpvU00rqe1EOIbCMApFKFU0rNMpJ+97Z50JxAWaJj8Wiq1a4ef6edn2PCfl4Lzy46m
	 RahxcFpKB5UGFzsNjUTKHQJ+S4Tfs0dgHIK0Sm96MOEKDhw2afVZOUZkuuu7gIWge0
	 aW83SgnSvz2Dw==
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
Subject: [PATCH v9 08/24] dma-mapping: add a dma_need_unmap helper
Date: Wed, 23 Apr 2025 11:12:59 +0300
Message-ID: <e55ceb86c6529a276484e13b0e6ea58764daf854.1745394536.git.leon@kernel.org>
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

Add helper that allows a driver to skip calling dma_unmap_*
if the DMA layer can guarantee that they are no-nops.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Tested-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/linux/dma-mapping.h |  5 +++++
 kernel/dma/mapping.c        | 18 ++++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index a71e110f1e9d..d2f358c5a25d 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -406,6 +406,7 @@ static inline bool dma_need_sync(struct device *dev, dma_addr_t dma_addr)
 {
 	return dma_dev_need_sync(dev) ? __dma_need_sync(dev, dma_addr) : false;
 }
+bool dma_need_unmap(struct device *dev);
 #else /* !CONFIG_HAS_DMA || !CONFIG_DMA_NEED_SYNC */
 static inline bool dma_dev_need_sync(const struct device *dev)
 {
@@ -431,6 +432,10 @@ static inline bool dma_need_sync(struct device *dev, dma_addr_t dma_addr)
 {
 	return false;
 }
+static inline bool dma_need_unmap(struct device *dev)
+{
+	return false;
+}
 #endif /* !CONFIG_HAS_DMA || !CONFIG_DMA_NEED_SYNC */
 
 struct page *dma_alloc_pages(struct device *dev, size_t size,
diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index cda127027e48..3c3204ad2839 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -443,6 +443,24 @@ bool __dma_need_sync(struct device *dev, dma_addr_t dma_addr)
 }
 EXPORT_SYMBOL_GPL(__dma_need_sync);
 
+/**
+ * dma_need_unmap - does this device need dma_unmap_* operations
+ * @dev: device to check
+ *
+ * If this function returns %false, drivers can skip calling dma_unmap_* after
+ * finishing an I/O.  This function must be called after all mappings that might
+ * need to be unmapped have been performed.
+ */
+bool dma_need_unmap(struct device *dev)
+{
+	if (!dma_map_direct(dev, get_dma_ops(dev)))
+		return true;
+	if (!dev->dma_skip_sync)
+		return true;
+	return IS_ENABLED(CONFIG_DMA_API_DEBUG);
+}
+EXPORT_SYMBOL_GPL(dma_need_unmap);
+
 static void dma_setup_need_sync(struct device *dev)
 {
 	const struct dma_map_ops *ops = get_dma_ops(dev);
-- 
2.49.0


