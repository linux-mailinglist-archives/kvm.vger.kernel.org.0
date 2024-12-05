Return-Path: <kvm+bounces-33143-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 024B19E56C3
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 14:25:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 534B41884B64
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 13:25:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4562E22147E;
	Thu,  5 Dec 2024 13:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O4Mi6PlM"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558D9222561;
	Thu,  5 Dec 2024 13:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733404925; cv=none; b=fj1SinhNMbSvq8GDJV5J2o6plvZfLvXxDJ4/2EQCWPbckRWZpfzkn5tEi7e/zd6+hxuZV8TVgzTw1rLpJEhvTE7GoSthY5bQZmyU80X4OehoyBNyQYIx28giugQvM/ktf189Sni7Csxr6T1h4+hHu39W29O9/46/aRtbwD7Bjiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733404925; c=relaxed/simple;
	bh=c7G0IPK1mqvX8tD+gZt9wA9o0XSfmNwzbfc+aT5KHkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dEMCGeMj2ou0UPf2Q9D1t3jWxg8MyQtVmUb+EQ4GHrYlCZyiuvOhyHdrL6i+5A1OjJvWO8lxVSFX7LywQmjeS5NBZ8+Dz7e85eY0Jj/8ud+q3E7c6r7QK2B/Mo8fw5k8ngqNIJcxqjFSJMj17P4O0V4BVSgttnj1OBLrjKkzosw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O4Mi6PlM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20D91C4CED1;
	Thu,  5 Dec 2024 13:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733404923;
	bh=c7G0IPK1mqvX8tD+gZt9wA9o0XSfmNwzbfc+aT5KHkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O4Mi6PlMc5Kk5ONaki5WsllSppTqpgAa328x+Stl1A9wYBWAFD8nbJXEZENsWBe5a
	 Ox/ODlM7KuZ2PJkCwJ6rb6QzK1So9RSL/tJ6cGOtyUsMiWfwuKrO5m8V9TF3AhQAv5
	 Xi4Z5qhRN/Q+ze5bwYUQYkblhXXN8iF+xHXhL+/qycoVOEVV6zBshynwV90neUbwrq
	 vHCjJ091bFqflzXkFftJ1Gc0N5DSMs4yefOFG2Jrpct8bsXYFWwHCqi2OWod1I6vOy
	 SSOUaxGpz1rvG8uSvOefAqbKaOoCpt+zyiA8qYixIGrcKtaJ8VsUy1/z2EniKDUQjO
	 x6BWHFHmlr3oQ==
From: Leon Romanovsky <leon@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Robin Murphy <robin.murphy@arm.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>
Cc: Leon Romanovsky <leonro@nvidia.com>,
	Keith Busch <kbusch@kernel.org>,
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
Subject: [PATCH v4 05/18] dma-mapping: Add check if IOVA can be used
Date: Thu,  5 Dec 2024 15:21:04 +0200
Message-ID: <b23a1e29f00f31f31641479c90f2471aee27fac5.1733398913.git.leon@kernel.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <cover.1733398913.git.leon@kernel.org>
References: <cover.1733398913.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

This patch adds a check if IOVA can be used for the specific
transaction.

In the new API a DMA mapping transaction is identified by a
struct dma_iova_state, which holds some recomputed information
for the transaction which does not change for each page being
mapped.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/linux/dma-mapping.h | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index b79925b1c433..0d1fc0a2fc0f 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -72,6 +72,20 @@
 
 #define DMA_BIT_MASK(n)	(((n) == 64) ? ~0ULL : ((1ULL<<(n))-1))
 
+struct dma_iova_state {
+	size_t __size;
+};
+
+/*
+ * Use the high bit to mark if we used swiotlb for one or more ranges.
+ */
+#define DMA_IOVA_USE_SWIOTLB		(1ULL << 63)
+
+static inline size_t dma_iova_size(struct dma_iova_state *state)
+{
+	return state->__size & ~DMA_IOVA_USE_SWIOTLB;
+}
+
 #ifdef CONFIG_DMA_API_DEBUG
 void debug_dma_mapping_error(struct device *dev, dma_addr_t dma_addr);
 void debug_dma_map_single(struct device *dev, const void *addr,
@@ -277,6 +291,25 @@ static inline int dma_mmap_noncontiguous(struct device *dev,
 }
 #endif /* CONFIG_HAS_DMA */
 
+#ifdef CONFIG_IOMMU_DMA
+/**
+ * dma_use_iova - check if the IOVA API is used for this state
+ * @state: IOVA state
+ *
+ * Return %true if the DMA transfers uses the dma_iova_*() calls or %false if
+ * they can't be used.
+ */
+static inline bool dma_use_iova(struct dma_iova_state *state)
+{
+	return state->__size != 0;
+}
+#else /* CONFIG_IOMMU_DMA */
+static inline bool dma_use_iova(struct dma_iova_state *state)
+{
+	return false;
+}
+#endif /* CONFIG_IOMMU_DMA */
+
 #if defined(CONFIG_HAS_DMA) && defined(CONFIG_DMA_NEED_SYNC)
 void __dma_sync_single_for_cpu(struct device *dev, dma_addr_t addr, size_t size,
 		enum dma_data_direction dir);
-- 
2.47.0


