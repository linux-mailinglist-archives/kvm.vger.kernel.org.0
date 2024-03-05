Return-Path: <kvm+bounces-10896-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FD9C871A87
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 11:17:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4442D1C215BA
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 10:17:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3F0259B62;
	Tue,  5 Mar 2024 10:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XCEvQ40z"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C9E58211;
	Tue,  5 Mar 2024 10:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709633744; cv=none; b=sI34DH6GulE8ArljcAzqfBA+/S/eiyBONTMH4sOe5tgBo2sFuGtLvm0WPdofiDBvBXGJrBpqmRxY655Mrnqe/4v14Ca15fH5VsbGYCHRdl5t8MaOk7FQvtxoarIx9Bh7WvtAcuJFFF1mCiL4mJCn1mCZPQ0krhEbVgR4JR8xeVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709633744; c=relaxed/simple;
	bh=XGhek5Egl9EZN5GDA4K/P4lgi/cIEFOzTc1LzkqAZ+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pr905HwYB7MuRcT8S49FEm5U1msAMOWE21S1MTaADUY8AKNuHiWyap8RocTIYjKdtbBiSSeIj3ndSXG2+8O4BnqVz2AGmmyvMxxBXMM++/9sNLqHPNiyRcNfSw8JOaNEQ436h8AFjbKISkhyvH/E+uGgSmO2QuNyVza7ZyMLmGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XCEvQ40z; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2152C43399;
	Tue,  5 Mar 2024 10:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709633743;
	bh=XGhek5Egl9EZN5GDA4K/P4lgi/cIEFOzTc1LzkqAZ+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XCEvQ40zftA5CzahxVADDhIsF5HF2PFIaFCKJl08PAjcb8phQRdD1LDvHI07G+6PZ
	 CvBdJkiMC9pln2pklakFZdq+NgxiSqfQtDr0p0vm+4uPAZzhgnykkeCD4vUFgHznRW
	 ZOBma0N0c7UfO8tz8sA3pTWlv0aFd55k7B11BsajPMqaNfTE2HFLWk/aE5awQigsm3
	 8YGZDR4iQoO0Eh3bVsL7tCcIfm91jjBwAWwMtpH2xHx88UXEnRem5M/qO+QvY/fybd
	 zRSV/V3Bo/1pG1mbTkyZbbDGE1jDM3WdTIBsJpv95ElPKrvNelIborsyuhPgbCuKH7
	 DHXrXaxWh7khg==
From: Leon Romanovsky <leon@kernel.org>
To: Christoph Hellwig <hch@lst.de>,
	Robin Murphy <robin.murphy@arm.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Chaitanya Kulkarni <chaitanyak@nvidia.com>
Cc: Leon Romanovsky <leonro@nvidia.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
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
	kvm@vger.kernel.org,
	linux-mm@kvack.org,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Amir Goldstein <amir73il@gmail.com>,
	"josef@toxicpanda.com" <josef@toxicpanda.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"daniel@iogearbox.net" <daniel@iogearbox.net>,
	Dan Williams <dan.j.williams@intel.com>,
	"jack@suse.com" <jack@suse.com>,
	Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: [RFC 02/16] dma-mapping: provide an interface to allocate IOVA
Date: Tue,  5 Mar 2024 12:15:12 +0200
Message-ID: <54a3554639bfb963c9919c5d7c1f449021bebdb3.1709631413.git.leon@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <a77609c9c9a09214e38b04133e44eee67fe50ab0.1709631413.git.leon@kernel.org>
References: <a77609c9c9a09214e38b04133e44eee67fe50ab0.1709631413.git.leon@kernel.org>
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
 include/linux/dma-mapping.h | 20 ++++++++++++++++++++
 kernel/dma/mapping.c        | 30 ++++++++++++++++++++++++++++++
 3 files changed, 53 insertions(+)

diff --git a/include/linux/dma-map-ops.h b/include/linux/dma-map-ops.h
index 4abc60f04209..bd605b44bb57 100644
--- a/include/linux/dma-map-ops.h
+++ b/include/linux/dma-map-ops.h
@@ -83,6 +83,9 @@ struct dma_map_ops {
 	size_t (*max_mapping_size)(struct device *dev);
 	size_t (*opt_mapping_size)(void);
 	unsigned long (*get_merge_boundary)(struct device *dev);
+
+	dma_addr_t (*alloc_iova)(struct device *dev, size_t size);
+	void (*free_iova)(struct device *dev, dma_addr_t dma_addr, size_t size);
 };
 
 #ifdef CONFIG_DMA_OPS
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 4a658de44ee9..176fb8a86d63 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -91,6 +91,16 @@ static inline void debug_dma_map_single(struct device *dev, const void *addr,
 }
 #endif /* CONFIG_DMA_API_DEBUG */
 
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
 #ifdef CONFIG_HAS_DMA
 static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
@@ -101,6 +111,9 @@ static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 	return 0;
 }
 
+int dma_alloc_iova(struct dma_iova_attrs *iova);
+void dma_free_iova(struct dma_iova_attrs *iova);
+
 dma_addr_t dma_map_page_attrs(struct device *dev, struct page *page,
 		size_t offset, size_t size, enum dma_data_direction dir,
 		unsigned long attrs);
@@ -159,6 +172,13 @@ void dma_vunmap_noncontiguous(struct device *dev, void *vaddr);
 int dma_mmap_noncontiguous(struct device *dev, struct vm_area_struct *vma,
 		size_t size, struct sg_table *sgt);
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
index 58db8fd70471..b6b27bab90f3 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -183,6 +183,36 @@ void dma_unmap_page_attrs(struct device *dev, dma_addr_t addr, size_t size,
 }
 EXPORT_SYMBOL(dma_unmap_page_attrs);
 
+int dma_alloc_iova(struct dma_iova_attrs *iova)
+{
+	struct device *dev = iova->dev;
+	const struct dma_map_ops *ops = get_dma_ops(dev);
+
+	if (dma_map_direct(dev, ops) || !ops->alloc_iova) {
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
+EXPORT_SYMBOL(dma_alloc_iova);
+
+void dma_free_iova(struct dma_iova_attrs *iova)
+{
+	struct device *dev = iova->dev;
+	const struct dma_map_ops *ops = get_dma_ops(dev);
+
+	if (dma_map_direct(dev, ops) || !ops->free_iova)
+		return;
+
+	ops->free_iova(dev, iova->addr, iova->size);
+}
+EXPORT_SYMBOL(dma_free_iova);
+
 static int __dma_map_sg_attrs(struct device *dev, struct scatterlist *sg,
 	 int nents, enum dma_data_direction dir, unsigned long attrs)
 {
-- 
2.44.0


