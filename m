Return-Path: <kvm+bounces-26687-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 23CBD976763
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 13:18:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 47D7A1C20A26
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 11:18:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5B401A42C1;
	Thu, 12 Sep 2024 11:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DW0EiOBL"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED1581A0BF9;
	Thu, 12 Sep 2024 11:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726139781; cv=none; b=UAs98Be6dK8DcpXTaTd8qkYNw8W87i/O+bzFPyHrL2NbqhIMEpnNTNty3BGh6AS4qqW3lxg5zQcaPut7ZA8Xc0j0aUd2oGF/3ocJzAyX5/3aw67yhUe0GtIhtpUymCUKd1cTz451C0g21jdNcHgCg8hFyB+KiFCJT9RWvLAs5bY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726139781; c=relaxed/simple;
	bh=li4T+ci0miq/Ck6TZvJSh35TTfQLVZ3ez/sogkVEAqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ezlwl840+NjJGGArhzx8Lvs+Y/EQ6Q86dNOMZcGizcqWZsPZuEvizDMpFqUp3mnFn5kK1cuywxO1t+m7kuuIdIKmzs+ZPhrlgBMYklX+VLaIJaamKnuRJopS0jLw+KTQ5PRrDG1t4pjjuxBF90pH/+Gltjvg99Zx32s66B+K9Rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DW0EiOBL; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADF5FC4CED2;
	Thu, 12 Sep 2024 11:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726139780;
	bh=li4T+ci0miq/Ck6TZvJSh35TTfQLVZ3ez/sogkVEAqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DW0EiOBLWTdXdcYL7iQeO1KEagJUzhnYtnawH9XAOccSvNYhDqCr0kKYfQM7BvY7U
	 Z/wF8BB04Og3VC/8rARWoLu32FUWjBo1rIeCC7O48BCmC1v7BqOLzPGtwScbzU+jh5
	 yM16QVL6oJS9fqiYwrvdfeNXuOWuirfNAINa2A9ynEvi8yQyOZcl7Q5AiJF1Psq1wq
	 BlV0gczTOznpsch1Z/NwAxSedcftaMBui/NE1/LqZ1tIhEFQpGA/yfhVm5TfMyPZyn
	 iwopoujIQGMD6QhZFyOHnnS0zH8X4MT/j6CzTSHEFKa//fWWK8/8tzQhXDftpbBb7j
	 3hFBAtVG640fQ==
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
Subject: [RFC v2 05/21] dma-mapping: provide an interface to allocate IOVA
Date: Thu, 12 Sep 2024 14:15:40 +0300
Message-ID: <dd5ac6c0fdf89ee0e0eb4580309253dcb225e726.1726138681.git.leon@kernel.org>
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
 include/linux/dma-mapping.h | 18 ++++++++++++++++++
 kernel/dma/mapping.c        | 35 +++++++++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+)

diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 285075873077..6a51d8e96a9d 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -78,6 +78,8 @@
 
 struct dma_iova_state {
 	struct device *dev;
+	dma_addr_t addr;
+	size_t size;
 	enum dma_data_direction dir;
 };
 
@@ -115,6 +117,10 @@ static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 	return 0;
 }
 
+int dma_alloc_iova_unaligned(struct dma_iova_state *state, phys_addr_t phys,
+			     size_t size);
+void dma_free_iova(struct dma_iova_state *state);
+
 dma_addr_t dma_map_page_attrs(struct device *dev, struct page *page,
 		size_t offset, size_t size, enum dma_data_direction dir,
 		unsigned long attrs);
@@ -164,6 +170,14 @@ void dma_vunmap_noncontiguous(struct device *dev, void *vaddr);
 int dma_mmap_noncontiguous(struct device *dev, struct vm_area_struct *vma,
 		size_t size, struct sg_table *sgt);
 #else /* CONFIG_HAS_DMA */
+static inline int dma_alloc_iova_unaligned(struct dma_iova_state *state,
+					   phys_addr_t phys, size_t size)
+{
+	return -EOPNOTSUPP;
+}
+static inline void dma_free_iova(struct dma_iova_state *state)
+{
+}
 static inline dma_addr_t dma_map_page_attrs(struct device *dev,
 		struct page *page, size_t offset, size_t size,
 		enum dma_data_direction dir, unsigned long attrs)
@@ -370,6 +384,10 @@ static inline bool dma_need_sync(struct device *dev, dma_addr_t dma_addr)
 	return false;
 }
 #endif /* !CONFIG_HAS_DMA || !CONFIG_DMA_NEED_SYNC */
+static inline int dma_alloc_iova(struct dma_iova_state *state, size_t size)
+{
+	return dma_alloc_iova_unaligned(state, 0, size);
+}
 
 struct page *dma_alloc_pages(struct device *dev, size_t size,
 		dma_addr_t *dma_handle, enum dma_data_direction dir, gfp_t gfp);
diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index fd9ecff8beee..4cd910f27dee 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -951,3 +951,38 @@ unsigned long dma_get_merge_boundary(struct device *dev)
 	return ops->get_merge_boundary(dev);
 }
 EXPORT_SYMBOL_GPL(dma_get_merge_boundary);
+
+/**
+ * dma_alloc_iova_unaligned - Allocate an IOVA space
+ * @state: IOVA state
+ * @phys: physical address
+ * @size: IOVA size
+ *
+ * Allocate an IOVA space for the given IOVA state and size. The IOVA space
+ * is allocated to the worst case when whole range is going to be used.
+ */
+int dma_alloc_iova_unaligned(struct dma_iova_state *state, phys_addr_t phys,
+			     size_t size)
+{
+	if (!use_dma_iommu(state->dev))
+		return 0;
+
+	WARN_ON_ONCE(!size);
+	return iommu_dma_alloc_iova(state, phys, size);
+}
+EXPORT_SYMBOL_GPL(dma_alloc_iova_unaligned);
+
+/**
+ * dma_free_iova - Free an IOVA space
+ * @state: IOVA state
+ *
+ * Free an IOVA space for the given IOVA attributes.
+ */
+void dma_free_iova(struct dma_iova_state *state)
+{
+	if (!use_dma_iommu(state->dev))
+		return;
+
+	iommu_dma_free_iova(state);
+}
+EXPORT_SYMBOL_GPL(dma_free_iova);
-- 
2.46.0


