Return-Path: <kvm+bounces-26689-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 60ABC97676D
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 13:18:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9F124B2159F
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 11:18:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A790F1A7061;
	Thu, 12 Sep 2024 11:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fMCA+j/u"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDAC11A4E8F;
	Thu, 12 Sep 2024 11:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726139789; cv=none; b=Dxh1wt+UmeFWqiN8+Uh/n90DPlzlek6ecZi0ZZGqjGCjX2r1BuynUajDW22tZQNJXAFmg3dLXYThFYead4lg17ifv06GpoHoM69tLMMqxTd3c11P4CYdH6G46rP50IE1GPdFfcYwI1A9S9wGyAWrfwtgKM0hM/5OSICKGV4Z8zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726139789; c=relaxed/simple;
	bh=YbYR1B9oX34Xv+Cehx9/tYc07da7ONVOmPeGXmHRn1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qta8zsy87l0hJ7KQq/SyFQDFKU8kXDUExesB78iCQ0LbDZ5JfezBGIOtSEZLV1iHDNUzeRGvgdaVcaDc/L0daHyjzrpEWDJGQRM+/e4hOwLn4P2/tTb3udxBURn5AyboEV2i10bReEahc63toADl0QsIvbkHeXPT5Rr5FuI2mbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fMCA+j/u; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89AE0C4CECC;
	Thu, 12 Sep 2024 11:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726139789;
	bh=YbYR1B9oX34Xv+Cehx9/tYc07da7ONVOmPeGXmHRn1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fMCA+j/uOJoozgNYTkAQZ9i5owgnrutNMDDvBGalOj/zk/VYWCdYuZ4BwEUgbo+Ee
	 8IK3/oKPT7MWMTtxPtDL2tX4K+v6ORqHmqpoXabXDx37Z0XKm5aVZRF6/WCoJ9ITzO
	 y2gg2RxijzVwlXxmRZdMVaHnbiANFg06GCTCeNRhNlUjPZ4StdmFz7Mfcxa8G1XV1K
	 slWv9Nbw6MJs1cRNGwbW5Pi2YtCX+5q7wtccX+oU6he+cAY4vrHTPY4NBWkdGZdWz5
	 rmSAiwxnbgN6fVd3O1RZFGWZ5pQ/Skqfv2XfNFsGj0rdVOoX/QhfA/JxO+QYtRiKMd
	 e8hcOh4m/hvyg==
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
Subject: [RFC v2 07/21] dma-mapping: implement link range API
Date: Thu, 12 Sep 2024 14:15:42 +0300
Message-ID: <bf1ad045f27a8dfac9e9dafd09869ac9a6be0b51.1726138681.git.leon@kernel.org>
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

Introduce new DMA APIs to perform DMA linkage of buffers
in layers higher than DMA.

In proposed API, the callers will perform the following steps:
dma_alloc_iova()
if (dma_can_use_iova(...))
  dma_start_range(...)
  for (page in range)
     dma_link_range(...)
  dma_end_range(...)
else
  /* Fallback to legacy map pages */
  dma_map_page(...)

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/linux/dma-mapping.h | 26 ++++++++++++++++
 kernel/dma/mapping.c        | 60 +++++++++++++++++++++++++++++++++++++
 2 files changed, 86 insertions(+)

diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 2c74e68b0567..bb541f8944e5 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -11,6 +11,7 @@
 #include <linux/scatterlist.h>
 #include <linux/bug.h>
 #include <linux/mem_encrypt.h>
+#include <linux/iommu.h>
 
 /**
  * List of possible attributes associated with a DMA mapping. The semantics
@@ -82,6 +83,7 @@ struct dma_iova_state {
 	size_t size;
 	enum dma_data_direction dir;
 	u8 use_iova : 1;
+	size_t range_size;
 };
 
 static inline void dma_init_iova_state(struct dma_iova_state *state,
@@ -173,6 +175,11 @@ int dma_mmap_noncontiguous(struct device *dev, struct vm_area_struct *vma,
 void dma_set_iova_state(struct dma_iova_state *state, struct page *page,
 			size_t size);
 bool dma_can_use_iova(struct dma_iova_state *state);
+int dma_start_range(struct dma_iova_state *state);
+void dma_end_range(struct dma_iova_state *state);
+dma_addr_t dma_link_range_attrs(struct dma_iova_state *state, phys_addr_t phys,
+				size_t size, unsigned long attrs);
+void dma_unlink_range_attrs(struct dma_iova_state *state, unsigned long attrs);
 #else /* CONFIG_HAS_DMA */
 static inline int dma_alloc_iova_unaligned(struct dma_iova_state *state,
 					   phys_addr_t phys, size_t size)
@@ -319,6 +326,23 @@ static inline bool dma_can_use_iova(struct dma_iova_state *state)
 {
 	return false;
 }
+static inline int dma_start_range(struct dma_iova_state *state)
+{
+	return -EOPNOTSUPP;
+}
+static inline void dma_end_range(struct dma_iova_state *state)
+{
+}
+static inline dma_addr_t dma_link_range_attrs(struct dma_iova_state *state,
+					      phys_addr_t phys, size_t size,
+					      unsigned long attrs)
+{
+	return DMA_MAPPING_ERROR;
+}
+static inline void dma_unlink_range_attrs(struct dma_iova_state *state,
+					  unsigned long attrs)
+{
+}
 #endif /* CONFIG_HAS_DMA */
 
 #if defined(CONFIG_HAS_DMA) && defined(CONFIG_DMA_NEED_SYNC)
@@ -513,6 +537,8 @@ static inline void dma_sync_sgtable_for_device(struct device *dev,
 #define dma_unmap_page(d, a, s, r) dma_unmap_page_attrs(d, a, s, r, 0)
 #define dma_get_sgtable(d, t, v, h, s) dma_get_sgtable_attrs(d, t, v, h, s, 0)
 #define dma_mmap_coherent(d, v, c, h, s) dma_mmap_attrs(d, v, c, h, s, 0)
+#define dma_link_range(d, p, o) dma_link_range_attrs(d, p, o, 0)
+#define dma_unlink_range(d) dma_unlink_range_attrs(d, 0)
 
 bool dma_coherent_ok(struct device *dev, phys_addr_t phys, size_t size);
 
diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index 16cb03d5d87d..39fac8c21643 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -1024,3 +1024,63 @@ bool dma_can_use_iova(struct dma_iova_state *state)
 	return state->use_iova;
 }
 EXPORT_SYMBOL_GPL(dma_can_use_iova);
+
+/**
+ * dma_start_range - Start a range of IOVA space
+ * @state: IOVA state
+ *
+ * Start a range of IOVA space for the given IOVA state.
+ */
+int dma_start_range(struct dma_iova_state *state)
+{
+	if (!state->use_iova)
+		return 0;
+
+	return iommu_dma_start_range(state->dev);
+}
+EXPORT_SYMBOL_GPL(dma_start_range);
+
+/**
+ * dma_end_range - End a range of IOVA space
+ * @state: IOVA state
+ *
+ * End a range of IOVA space for the given IOVA state.
+ */
+void dma_end_range(struct dma_iova_state *state)
+{
+	if (!state->use_iova)
+		return;
+
+	iommu_dma_end_range(state->dev);
+}
+EXPORT_SYMBOL_GPL(dma_end_range);
+
+/**
+ * dma_link_range_attrs - Link a range of IOVA space
+ * @state: IOVA state
+ * @phys: physical address to link
+ * @size: size of the buffer
+ * @attrs: attributes of mapping properties
+ *
+ * Link a range of IOVA space for the given IOVA state.
+ */
+dma_addr_t dma_link_range_attrs(struct dma_iova_state *state, phys_addr_t phys,
+				size_t size, unsigned long attrs)
+{
+	return iommu_dma_link_range(state, phys, size, attrs);
+}
+EXPORT_SYMBOL_GPL(dma_link_range_attrs);
+
+/**
+ * dma_unlink_range_attrs - Unlink a range of IOVA space
+ * @state: IOVA state
+ * @attrs: attributes of mapping properties
+ *
+ * Unlink a range of IOVA space for the given IOVA state.
+ */
+void dma_unlink_range_attrs(struct dma_iova_state *state, unsigned long attrs)
+{
+	iommu_dma_unlink_range(state->dev, state->addr, state->range_size,
+			       state->dir, attrs);
+}
+EXPORT_SYMBOL_GPL(dma_unlink_range_attrs);
-- 
2.46.0


