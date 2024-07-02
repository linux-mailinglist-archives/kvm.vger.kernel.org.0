Return-Path: <kvm+bounces-20827-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 65875923939
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 11:11:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 70E671C21632
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 09:11:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE3A4157A61;
	Tue,  2 Jul 2024 09:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jZsLMwcx"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9DBA15216E;
	Tue,  2 Jul 2024 09:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719911412; cv=none; b=NEb8NAZ2OrkYI9Ne+2FQa8KFJIiW5uzZ0UpvTaC+M1aKj82ElzjfGkEJuTBzIsaXc1LPVRp1B1BTj1zkgXtRkVOxz+/Wnt49XULSH/9t5DDQRTbYc3vORZUfmsMPUbYfE/HBOQxpcav/OslmwbYy4T02eA28ONH9bOc42FFdnDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719911412; c=relaxed/simple;
	bh=GdqxFreVifTUH7yLunaT0Kp4VH1OcNBKz7jklxCA7IE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YohiMKedg5IqO9IeGx9efMcKnGkKrRHB2C7qHB5EBxb+/WTecbP/aSNLWsbBiLm+WSNN3+Cn1S/fTS0ZZG0XhvGFXmHX6xQlKuRfOP8APMiroqhinSYwT9VMGp7Y3oAfEy24kcNeZoDkbgNxMSUs9r+JrMUKTNnGRXRM5zlgHXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jZsLMwcx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB762C116B1;
	Tue,  2 Jul 2024 09:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719911412;
	bh=GdqxFreVifTUH7yLunaT0Kp4VH1OcNBKz7jklxCA7IE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jZsLMwcxfIhbNdXAH7Erajavnd9zt8wZwqJVAhbFF8wuHrgj9ZFLnS0M824YeY1WI
	 lsBBR7Huv75yN3CNdjq3wGOj6d6XRdgf43l4OFc9s6OcECQ4HjS13MEjvrsvp/qDtC
	 V9bMyC4eCtQlzz7bAocuoWalQBZeKMuoUk0+t2JOvKUiwHjZ7NOHkhxRQ2bfGbsofJ
	 9EiPqR5DPCSASk+2Ji+dPRehAt5lU8Xk41chq5PYN3dkl0zeRpGP7rNQIh7zxcQ/Ux
	 TOXwMCzKrQG/bRPwo4SyChwOnWE10AWLJZqnWPQAFqWJhu2cqfYHV+DULsrE24NbAI
	 pEN9z2lU0w7oA==
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
Subject: [RFC PATCH v1 02/18] dma-mapping: provide an interface to allocate IOVA
Date: Tue,  2 Jul 2024 12:09:32 +0300
Message-ID: <f6c74db6cec987ce6e30bfadf0f092a57a5b533f.1719909395.git.leon@kernel.org>
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

Existing .map_page() callback provides two things at the same time:
allocates IOVA and links DMA pages. That combination works great for
most of the callers who use it in control paths, but less effective
in fast paths.

These advanced callers already manage their data in some sort of
database and can perform IOVA allocation in advance, leaving range
linkage operation to be in fast path.

Provide an interface to allocate/deallocate IOVA and next patch
link/unlink DMA ranges to that specific IOVA.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/linux/dma-map-ops.h |  3 +++
 include/linux/dma-mapping.h | 20 +++++++++++++++++
 kernel/dma/mapping.c        | 44 +++++++++++++++++++++++++++++++++++++
 3 files changed, 67 insertions(+)

diff --git a/include/linux/dma-map-ops.h b/include/linux/dma-map-ops.h
index 02a1c825896b..23e5e2f63a1c 100644
--- a/include/linux/dma-map-ops.h
+++ b/include/linux/dma-map-ops.h
@@ -86,6 +86,9 @@ struct dma_map_ops {
 	size_t (*max_mapping_size)(struct device *dev);
 	size_t (*opt_mapping_size)(void);
 	unsigned long (*get_merge_boundary)(struct device *dev);
+
+	dma_addr_t (*alloc_iova)(struct device *dev, size_t size);
+	void (*free_iova)(struct device *dev, dma_addr_t dma_addr, size_t size);
 };
 
 #ifdef CONFIG_DMA_OPS
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 49b99c6e7ec5..673ddcf140ff 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -90,6 +90,16 @@ struct dma_memory_type {
 	struct dev_pagemap *p2p_pgmap;
 };
 
+struct dma_iova_attrs {
+	/* OUT field */
+	dma_addr_t addr;
+	/* IN fields */
+	struct device *dev;
+	size_t size;
+	enum dma_data_direction dir;
+	unsigned long attrs;
+};
+
 #ifdef CONFIG_DMA_API_DEBUG
 void debug_dma_mapping_error(struct device *dev, dma_addr_t dma_addr);
 void debug_dma_map_single(struct device *dev, const void *addr,
@@ -115,6 +125,9 @@ static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 	return 0;
 }
 
+int dma_alloc_iova(struct dma_iova_attrs *iova);
+void dma_free_iova(struct dma_iova_attrs *iova);
+
 dma_addr_t dma_map_page_attrs(struct device *dev, struct page *page,
 		size_t offset, size_t size, enum dma_data_direction dir,
 		unsigned long attrs);
@@ -166,6 +179,13 @@ int dma_mmap_noncontiguous(struct device *dev, struct vm_area_struct *vma,
 
 void dma_get_memory_type(struct page *page, struct dma_memory_type *type);
 #else /* CONFIG_HAS_DMA */
+static inline int dma_alloc_iova(struct dma_iova_attrs *iova)
+{
+	return -EOPNOTSUPP;
+}
+static inline void dma_free_iova(struct dma_iova_attrs *iova)
+{
+}
 static inline dma_addr_t dma_map_page_attrs(struct device *dev,
 		struct page *page, size_t offset, size_t size,
 		enum dma_data_direction dir, unsigned long attrs)
diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index 877e43b39c06..0c8f51010d08 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -924,3 +924,47 @@ void dma_get_memory_type(struct page *page, struct dma_memory_type *type)
 	type->type = DMA_MEMORY_TYPE_NORMAL;
 }
 EXPORT_SYMBOL_GPL(dma_get_memory_type);
+
+/**
+ * dma_alloc_iova - Allocate an IOVA space
+ * @iova: IOVA attributes
+ *
+ * Allocate an IOVA space for the given IOVA attributes. The IOVA space
+ * is allocated to the worst case when whole range is going to be used.
+ */
+int dma_alloc_iova(struct dma_iova_attrs *iova)
+{
+	struct device *dev = iova->dev;
+	const struct dma_map_ops *ops = get_dma_ops(dev);
+
+	if (dma_map_direct(dev, ops) || !ops->alloc_iova) {
+		/* dma_map_direct(..) check is for HMM range fault callers */
+		iova->addr = 0;
+		return 0;
+	}
+
+	iova->addr = ops->alloc_iova(dev, iova->size);
+	if (dma_mapping_error(dev, iova->addr))
+		return -ENOMEM;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dma_alloc_iova);
+
+/**
+ * dma_free_iova - Free an IOVA space
+ * @iova: IOVA attributes
+ *
+ * Free an IOVA space for the given IOVA attributes.
+ */
+void dma_free_iova(struct dma_iova_attrs *iova)
+{
+	struct device *dev = iova->dev;
+	const struct dma_map_ops *ops = get_dma_ops(dev);
+
+	if (dma_map_direct(dev, ops) || !ops->free_iova || !iova->addr)
+		return;
+
+	ops->free_iova(dev, iova->addr, iova->size);
+}
+EXPORT_SYMBOL_GPL(dma_free_iova);
-- 
2.45.2


