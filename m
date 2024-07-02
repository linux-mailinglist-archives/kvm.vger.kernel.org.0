Return-Path: <kvm+bounces-20825-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 72DE792392E
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 11:10:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9BC461C21224
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 09:10:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B561155A23;
	Tue,  2 Jul 2024 09:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WdB+vVAS"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A69E915098E;
	Tue,  2 Jul 2024 09:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719911404; cv=none; b=IU944rl1mktqT9IjI1CrlHpz5q3HIvDViV3knKIHfWhwLGZOW/W/XuwsxJyiKHT1/RQQeHQhTYaHzRfzQXRRf0rn1MdhdY41eQMuiDHJGKbzyn0ZHrphKHJSHJ5tk2OpJId79i+6d2J57jqWWD6/wreLZBBQqFPlaoEmjuZuJxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719911404; c=relaxed/simple;
	bh=PsDcRtwRrZy3xcTFmq5V+v2aFvC1FX6fMcSIsPNIgJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jSM1700hKeyJbnlOYgEpF9OY0uo/XyUgWdxflTcMhDicoq9VJz+VkmsGwXdgzrwDVE7uJisaR5eM5MJRzRoUzLwaFwSTmJh9IfwL6O1JSWmgmm1JLeE1nGj5GJWDI1ebVxUwmQCf2IMJAiMVEg4nbcnG1kiY9UbqMT8uWykh1GE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WdB+vVAS; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97D44C116B1;
	Tue,  2 Jul 2024 09:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719911404;
	bh=PsDcRtwRrZy3xcTFmq5V+v2aFvC1FX6fMcSIsPNIgJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WdB+vVAS8uHPdPme4myJO22f4FbGRcG1dHDJHwEW7t+ki8CzsXtGbIJKrwNZzL+oN
	 HZhggaNWlUq2LDjYroZErlO93jF4y+zjRYe2QMVqmzz1MDxk1Rl8xeJex/5Q1jOGA8
	 kNM7rlYFNxKQypQjyLEv1W8ppPwmxff79s/KS7zpU97+5kGBVsrGR36Z/Ui8WyxfjN
	 +2WhW3GmeKGr7A5xpE0coC6WO/48R8aI2ccSdCQQ38AntHiLnCHjCF0ItXO1X8/fim
	 N1g17gLjq4qvdcY6NksGgFPtVrvn0kKJnJryFF33jW+ntCtDHOmI6RkHi12DWkTu0B
	 MTNXNHg+0HJIQ==
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
Subject: [RFC PATCH v1 01/18] dma-mapping: query DMA memory type
Date: Tue,  2 Jul 2024 12:09:31 +0300
Message-ID: <a7ec6658f74f1dfbe7bd0e96be5be2f1be945076.1719909395.git.leon@kernel.org>
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

Provide an option to query and set DMA memory type so callers who supply
range of pages can perform it only once as the whole range is supposed
to have same memory type.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/linux/dma-mapping.h | 20 ++++++++++++++++++++
 kernel/dma/mapping.c        | 30 ++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+)

diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index f693aafe221f..49b99c6e7ec5 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -76,6 +76,20 @@
 
 #define DMA_BIT_MASK(n)	(((n) == 64) ? ~0ULL : ((1ULL<<(n))-1))
 
+enum dma_memory_types {
+	/* Normal memory without any extra properties like P2P, e.t.c */
+	DMA_MEMORY_TYPE_NORMAL,
+	/* Memory which is p2p capable */
+	DMA_MEMORY_TYPE_P2P,
+	/* Encrypted memory (TDX) */
+	DMA_MEMORY_TYPE_ENCRYPTED,
+};
+
+struct dma_memory_type {
+	enum dma_memory_types type;
+	struct dev_pagemap *p2p_pgmap;
+};
+
 #ifdef CONFIG_DMA_API_DEBUG
 void debug_dma_mapping_error(struct device *dev, dma_addr_t dma_addr);
 void debug_dma_map_single(struct device *dev, const void *addr,
@@ -149,6 +163,8 @@ void *dma_vmap_noncontiguous(struct device *dev, size_t size,
 void dma_vunmap_noncontiguous(struct device *dev, void *vaddr);
 int dma_mmap_noncontiguous(struct device *dev, struct vm_area_struct *vma,
 		size_t size, struct sg_table *sgt);
+
+void dma_get_memory_type(struct page *page, struct dma_memory_type *type);
 #else /* CONFIG_HAS_DMA */
 static inline dma_addr_t dma_map_page_attrs(struct device *dev,
 		struct page *page, size_t offset, size_t size,
@@ -279,6 +295,10 @@ static inline int dma_mmap_noncontiguous(struct device *dev,
 {
 	return -EINVAL;
 }
+static inline void dma_get_memory_type(struct page *page,
+				       struct dma_memory_type *type)
+{
+}
 #endif /* CONFIG_HAS_DMA */
 
 #if defined(CONFIG_HAS_DMA) && defined(CONFIG_DMA_NEED_SYNC)
diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index 81de84318ccc..877e43b39c06 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -6,6 +6,7 @@
  * Copyright (c) 2006  Tejun Heo <teheo@suse.de>
  */
 #include <linux/memblock.h> /* for max_pfn */
+#include <linux/memremap.h>
 #include <linux/acpi.h>
 #include <linux/dma-map-ops.h>
 #include <linux/export.h>
@@ -14,6 +15,7 @@
 #include <linux/of_device.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
+#include <linux/cc_platform.h>
 #include "debug.h"
 #include "direct.h"
 
@@ -894,3 +896,31 @@ unsigned long dma_get_merge_boundary(struct device *dev)
 	return ops->get_merge_boundary(dev);
 }
 EXPORT_SYMBOL_GPL(dma_get_merge_boundary);
+
+/**
+ * dma_get_memory_type - get the DMA memory type of the page supplied
+ * @page: page to check
+ * @type: memory type of that page
+ *
+ * Return the DMA memory type for the struct page. Pages with the same
+ * memory type can be combined into the same IOVA mapping. Users of the
+ * dma_iova family of functions must seperate the memory they want to map
+ * into same-memory type ranges.
+ */
+void dma_get_memory_type(struct page *page, struct dma_memory_type *type)
+{
+	/* TODO: Rewrite this check to rely on specific struct page flags */
+	if (cc_platform_has(CC_ATTR_MEM_ENCRYPT)) {
+		type->type = DMA_MEMORY_TYPE_ENCRYPTED;
+		return;
+	}
+
+	if (is_pci_p2pdma_page(page)) {
+		type->type = DMA_MEMORY_TYPE_P2P;
+		type->p2p_pgmap = page->pgmap;
+		return;
+	}
+
+	type->type = DMA_MEMORY_TYPE_NORMAL;
+}
+EXPORT_SYMBOL_GPL(dma_get_memory_type);
-- 
2.45.2


