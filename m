Return-Path: <kvm+bounces-35754-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F0FAAA14D0B
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 11:08:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 55F703A15E9
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 10:08:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD85D2036E3;
	Fri, 17 Jan 2025 10:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vExohzXD"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B86202C50;
	Fri, 17 Jan 2025 10:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737108279; cv=none; b=BPDxT55QUZ13Q1sKMkc/gl76spXeK90jXENmBdYUh9mGqnOo67aVyt+ujrxoB7X94pVyYIHyPn1yUgP5VdsOg2/cBW8Qcuuwi4yaS7GXy780qfBMcjleFWa3r1aCGA/Hdy/BHTnQOf6Phc/MrXJeBBCvlcqWqfYCm1WF8/JI66s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737108279; c=relaxed/simple;
	bh=FJYQ7qR9hcBLpRhiPHcPvV9HvqBheLEfsFGqvBAMLaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tYg8hfzhnjSO+hzNEeqMU4jG92iPHoTt1NirRt/tYb1Bw4AnTY25casY/DqGiLVdYpy4LaAbfgcUaLla881egN+vcZ2PvWM7eQixrFcGdMWYPwzatzRiz/Yf3/FhK6Ls1RLxCdoQmeffc2+ZlVxfytDDUHs0C/qFcWOS0KGxnqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vExohzXD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8323C4CEDD;
	Fri, 17 Jan 2025 10:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737108279;
	bh=FJYQ7qR9hcBLpRhiPHcPvV9HvqBheLEfsFGqvBAMLaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vExohzXD6Ujd7i5ylWAXIQ8r+KiHahR4ugS8NzRN12jXXWg6XpFDS0Az2kDJdGS3b
	 r2P83zACaoMN4Wm74N2ASzU3RY5SHuQvegOGleRrgJR0ewKZNF1R7rYaprTdiqfZta
	 qHAONZp/pjWD0Exsf2wMAG5W74kZ9llv+fixzaMpWuVhexQbaRl57Q96SppjOh8KaZ
	 UB7ck8uR8pWleUg587r5ORtXxR7k4/8yK6Oa7z3askZexI38iaJksqiskbye1+z2jM
	 yfRbYsVQg1Ux+DbZ9S99dgY9nJvxXEfXBrI8xyOVSpm8JiF79noUc1A75KueNPzS9U
	 QWTZ4Ku7NpBiA==
From: Leon Romanovsky <leon@kernel.org>
To: Christoph Hellwig <hch@lst.de>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Robin Murphy <robin.murphy@arm.com>
Cc: Jens Axboe <axboe@kernel.dk>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	"Keith Busch" <kbusch@kernel.org>,
	"Bjorn Helgaas" <bhelgaas@google.com>,
	"Logan Gunthorpe" <logang@deltatee.com>,
	"Yishai Hadas" <yishaih@nvidia.com>,
	"Shameer Kolothum" <shameerali.kolothum.thodi@huawei.com>,
	"Kevin Tian" <kevin.tian@intel.com>,
	"Alex Williamson" <alex.williamson@redhat.com>,
	"Marek Szyprowski" <m.szyprowski@samsung.com>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	"Jonathan Corbet" <corbet@lwn.net>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	linux-pci@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-mm@kvack.org,
	"Randy Dunlap" <rdunlap@infradead.org>
Subject: [PATCH v6 08/17] dma-mapping: add a dma_need_unmap helper
Date: Fri, 17 Jan 2025 12:03:39 +0200
Message-ID: <9458f681274f4f0e5dd3bf3959e0b8a1ac9a4e7b.1737106761.git.leon@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1737106761.git.leon@kernel.org>
References: <cover.1737106761.git.leon@kernel.org>
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
2.47.1


