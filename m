Return-Path: <kvm+bounces-26688-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F39A9976768
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 13:18:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7357DB23E44
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 11:18:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E68F1A2561;
	Thu, 12 Sep 2024 11:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aLB45VxS"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32C281A0BF9;
	Thu, 12 Sep 2024 11:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726139785; cv=none; b=lNLmUZ8NncYya2p7ZYfAZM0KcR+UXCEFCV0xYvMd5tuuQxod4gauySNj+DYoqBmZbMR+0+JW7m2yRSppmmd3PVNmkwcyGP3B/VLeCHnTqgqgoheNQ3ybxJ68UeuILL5AJ4GvqKlZMW4oO7hJm6069dQLMcZ0GTg1NT5Sr8KpePg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726139785; c=relaxed/simple;
	bh=VvpomHjn0PXFDu7e/jW7/gfUbs21DN2RjkYJAyY9I0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XyN7rdcTKaJCMSu9/EoJMU1DB848dt/h273H61x7oAUT4V9naf2INHRkcXPM0nQFyBWH7wt4ilaPk9C7WxmEDXonJcU3Y93UkopXFKfShDmra0afvcsqCZbcyk+o21wLfP6ttJ+3f5EP7AhGHkiUB3u6b2yJezZP00TiY+HaNJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aLB45VxS; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 499D0C4CECF;
	Thu, 12 Sep 2024 11:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726139785;
	bh=VvpomHjn0PXFDu7e/jW7/gfUbs21DN2RjkYJAyY9I0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aLB45VxSAnSX1Omnd4tNbgxYwGvlO0vlHzxS5XRXs3Jf+H6Sv4g2apXm3/BjzYZcU
	 jJat8T1BsFMxKIbvmMGDI3d2Wav68reJ0E3LN7sVO+ms1PwvbS5VCjz/Zp+6dn0u38
	 Hjyfj6EN+qrGYfmm8UXj6bzSoYbXvDIEBCuKATHLVp+eKVznmpDYlgEn6mEfIV25ac
	 CluAye/X57cQXU1+3AFoTAvO2BnVfHu3mTsIsvPd7Y8II6FIRfLqDJj5jqYb3qQCuB
	 HoFkBLlicit7oilmLRe8VOlKBnHex2vD837rA3akUkz25QskU2jzMySkDTK/0QW30m
	 CBd4EkuZoW2Aw==
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
Subject: [RFC v2 06/21] dma-mapping: set and query DMA IOVA state
Date: Thu, 12 Sep 2024 14:15:41 +0300
Message-ID: <818f2fbdb80f07297ca2abe5d04443d3b665f445.1726138681.git.leon@kernel.org>
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

Provide an option to query and set if IOMMU path can be taken.
Callers who supply range of pages can perform it only once as
the whole range is supposed to have same memory type.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/linux/dma-mapping.h | 12 ++++++++++++
 kernel/dma/mapping.c        | 38 +++++++++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+)

diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 6a51d8e96a9d..2c74e68b0567 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -81,6 +81,7 @@ struct dma_iova_state {
 	dma_addr_t addr;
 	size_t size;
 	enum dma_data_direction dir;
+	u8 use_iova : 1;
 };
 
 static inline void dma_init_iova_state(struct dma_iova_state *state,
@@ -169,6 +170,9 @@ void *dma_vmap_noncontiguous(struct device *dev, size_t size,
 void dma_vunmap_noncontiguous(struct device *dev, void *vaddr);
 int dma_mmap_noncontiguous(struct device *dev, struct vm_area_struct *vma,
 		size_t size, struct sg_table *sgt);
+void dma_set_iova_state(struct dma_iova_state *state, struct page *page,
+			size_t size);
+bool dma_can_use_iova(struct dma_iova_state *state);
 #else /* CONFIG_HAS_DMA */
 static inline int dma_alloc_iova_unaligned(struct dma_iova_state *state,
 					   phys_addr_t phys, size_t size)
@@ -307,6 +311,14 @@ static inline int dma_mmap_noncontiguous(struct device *dev,
 {
 	return -EINVAL;
 }
+static inline void dma_set_iova_state(struct dma_iova_state *state,
+				      struct page *page, size_t size)
+{
+}
+static inline bool dma_can_use_iova(struct dma_iova_state *state)
+{
+	return false;
+}
 #endif /* CONFIG_HAS_DMA */
 
 #if defined(CONFIG_HAS_DMA) && defined(CONFIG_DMA_NEED_SYNC)
diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index 4cd910f27dee..16cb03d5d87d 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -6,6 +6,7 @@
  * Copyright (c) 2006  Tejun Heo <teheo@suse.de>
  */
 #include <linux/memblock.h> /* for max_pfn */
+#include <linux/memremap.h>
 #include <linux/acpi.h>
 #include <linux/dma-map-ops.h>
 #include <linux/iommu-dma.h>
@@ -15,6 +16,7 @@
 #include <linux/of_device.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
+#include <linux/cc_platform.h>
 #include "debug.h"
 #include "direct.h"
 
@@ -986,3 +988,39 @@ void dma_free_iova(struct dma_iova_state *state)
 	iommu_dma_free_iova(state);
 }
 EXPORT_SYMBOL_GPL(dma_free_iova);
+
+/**
+ * dma_set_iova_state - Set the IOVA state for the given page and size
+ * @state: IOVA state
+ * @page: page to check
+ * @size: size of the page
+ *
+ * Set the IOVA state for the given page and size. The IOVA state is set
+ * based on the device and the page.
+ */
+void dma_set_iova_state(struct dma_iova_state *state, struct page *page,
+			size_t size)
+{
+	if (!use_dma_iommu(state->dev))
+		return;
+
+	state->use_iova = iommu_can_use_iova(state->dev, page, size, state->dir);
+}
+EXPORT_SYMBOL_GPL(dma_set_iova_state);
+
+/**
+ * dma_can_use_iova - check if the device type is valid
+ *                    and won't take SWIOTLB path
+ * @state: IOVA state
+ *
+ * Return %true if the device should use swiotlb for the given buffer, else
+ * %false.
+ */
+bool dma_can_use_iova(struct dma_iova_state *state)
+{
+	if (!use_dma_iommu(state->dev))
+		return false;
+
+	return state->use_iova;
+}
+EXPORT_SYMBOL_GPL(dma_can_use_iova);
-- 
2.46.0


