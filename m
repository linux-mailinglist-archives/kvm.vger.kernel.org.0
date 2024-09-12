Return-Path: <kvm+bounces-26684-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8ADAC976753
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 13:16:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DFCC1B220C4
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 11:16:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A162176FCF;
	Thu, 12 Sep 2024 11:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EmLlNz91"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DCF5145B14;
	Thu, 12 Sep 2024 11:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726139768; cv=none; b=U0Z/jsajQA1WoLO9CAFhLumbUYkDCpCpTTvsHSi+Nbs0VinIx0jaFt/5n87BIagnhG/sK32tMmBUhy1Hm+6mqYVk+b9lRirBD6eUiKZgxOvXKDJmp/DESCax2KrzX5ie10WNaPCOvaLS4D1Yc2QNNTomDNfwiwkDbRM32i1YQvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726139768; c=relaxed/simple;
	bh=VWjabdNWVPsGz8JpMutT65B9uF9Uo/BpJGgpfDUTVak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o2PdtgZBGun+51GiavOvSJh/0J6cTGXwgIawR4WgBESqlSYbuTbxlYfSvFLoHshDCHpQGKITnXNPM9GKhL6KMq0oSNi33Wevb4P50zyDaU45QmZTBWB975M8tci80UKOJ3yivdPfkOH0gTnJreu7COsp8M70FI8+x5UaFH7XMSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EmLlNz91; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D77C3C4CEC3;
	Thu, 12 Sep 2024 11:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726139767;
	bh=VWjabdNWVPsGz8JpMutT65B9uF9Uo/BpJGgpfDUTVak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EmLlNz91vs6SxK07DPB0FeRsNdYraG/8/aqHCC+3yK4unyOBTigWl3dgYpL2FkZvP
	 G00341+DXFortwi5A0DRM0oHHJqqoS7g8LSRwclecTKFOR6jCplrCR/SZdrKvwQrep
	 5phR03LaxkxKfznDtpK311Npqk+LqTE1hfaGrQzheteDVBW+0npQPavVlKK53ZaCZV
	 jUwtCJrepSK/qZzM0l46iOZh5zC7lj4U1Ro+C1FrUtN0yi1ZAX+AUZ4QhVVi/LHgnS
	 9a/vmDOidRNoehzzXg/ZzBt24/4beQiO6/rnc2z0BUmysAh3pMoMNwdyfrAPJ0MonP
	 a9CIwLBnLrSxw==
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
Subject: [RFC v2 02/21] iommu/dma: Implement link/unlink ranges callbacks
Date: Thu, 12 Sep 2024 14:15:37 +0300
Message-ID: <e3a8350baeaad544010c65dc62db53cf92ff2be1.1726138681.git.leon@kernel.org>
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

Add an implementation of link/unlink interface to perform in map/unmap
pages in fast patch for pre-allocated IOVA.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/iommu/dma-iommu.c | 86 +++++++++++++++++++++++++++++++++++++++
 include/linux/iommu-dma.h | 25 ++++++++++++
 2 files changed, 111 insertions(+)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 09deea2fc86b..72763f76b712 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -1743,6 +1743,92 @@ void iommu_dma_free_iova(struct dma_iova_state *state)
 			      &iotlb_gather);
 }
 
+int iommu_dma_start_range(struct device *dev)
+{
+	struct iommu_domain *domain = iommu_get_dma_domain(dev);
+
+	if (static_branch_unlikely(&iommu_deferred_attach_enabled))
+		return iommu_deferred_attach(dev, domain);
+
+	return 0;
+}
+
+void iommu_dma_end_range(struct device *dev)
+{
+	/* TODO: Factor out ops->iotlb_sync_map(..) call from iommu_map()
+	 * and put it here to provide batched iotlb sync for the range.
+	 */
+}
+
+dma_addr_t iommu_dma_link_range(struct dma_iova_state *state, phys_addr_t phys,
+				size_t size, unsigned long attrs)
+{
+	struct iommu_domain *domain = iommu_get_dma_domain(state->dev);
+	struct iommu_dma_cookie *cookie = domain->iova_cookie;
+	struct iova_domain *iovad = &cookie->iovad;
+	size_t iova_off = iova_offset(iovad, phys);
+	bool coherent = dev_is_dma_coherent(state->dev);
+	int prot = dma_info_to_prot(state->dir, coherent, attrs);
+	dma_addr_t addr = state->addr + state->range_size;
+	int ret;
+
+	WARN_ON_ONCE(iova_off && state->range_size > 0);
+
+	if (!coherent && !(attrs & DMA_ATTR_SKIP_CPU_SYNC))
+		arch_sync_dma_for_device(phys, size, state->dir);
+
+	size = iova_align(iovad, size + iova_off);
+	ret = iommu_map(domain, addr, phys - iova_off, size, prot, GFP_ATOMIC);
+	if (ret)
+		return ret;
+
+	state->range_size += size;
+	return addr + iova_off;
+}
+
+static void iommu_sync_dma_for_cpu(struct iommu_domain *domain,
+				   dma_addr_t start, size_t size,
+				   enum dma_data_direction dir)
+{
+	size_t sync_size, unmapped = 0;
+	phys_addr_t phys;
+
+	do {
+		phys = iommu_iova_to_phys(domain, start + unmapped);
+		if (WARN_ON(!phys))
+			continue;
+
+		sync_size = (unmapped + PAGE_SIZE > size) ? size % PAGE_SIZE :
+							    PAGE_SIZE;
+		arch_sync_dma_for_cpu(phys, sync_size, dir);
+		unmapped += sync_size;
+	} while (unmapped < size);
+}
+
+void iommu_dma_unlink_range(struct device *dev, dma_addr_t start, size_t size,
+			    enum dma_data_direction dir, unsigned long attrs)
+{
+	struct iommu_domain *domain = iommu_get_dma_domain(dev);
+	struct iommu_dma_cookie *cookie = domain->iova_cookie;
+	struct iova_domain *iovad = &cookie->iovad;
+	struct iommu_iotlb_gather iotlb_gather;
+	bool coherent = dev_is_dma_coherent(dev);
+	size_t unmapped;
+
+	iommu_iotlb_gather_init(&iotlb_gather);
+	iotlb_gather.queued = READ_ONCE(cookie->fq_domain);
+
+	if (!(attrs & DMA_ATTR_SKIP_CPU_SYNC) && !coherent)
+		iommu_sync_dma_for_cpu(domain, start, size, dir);
+
+	size = iova_align(iovad, size);
+	unmapped = iommu_unmap_fast(domain, start, size, &iotlb_gather);
+	WARN_ON(unmapped != size);
+
+	if (!iotlb_gather.queued)
+		iommu_iotlb_sync(domain, &iotlb_gather);
+}
+
 void iommu_setup_dma_ops(struct device *dev)
 {
 	struct iommu_domain *domain = iommu_get_domain_for_dev(dev);
diff --git a/include/linux/iommu-dma.h b/include/linux/iommu-dma.h
index 698df67b152a..21b0341f52b8 100644
--- a/include/linux/iommu-dma.h
+++ b/include/linux/iommu-dma.h
@@ -60,6 +60,12 @@ void iommu_dma_sync_sg_for_device(struct device *dev, struct scatterlist *sgl,
 int iommu_dma_alloc_iova(struct dma_iova_state *state, phys_addr_t phys,
 			 size_t size);
 void iommu_dma_free_iova(struct dma_iova_state *state);
+int iommu_dma_start_range(struct device *dev);
+void iommu_dma_end_range(struct device *dev);
+dma_addr_t iommu_dma_link_range(struct dma_iova_state *state, phys_addr_t phys,
+				size_t size, unsigned long attrs);
+void iommu_dma_unlink_range(struct device *dev, dma_addr_t start, size_t size,
+			    enum dma_data_direction dir, unsigned long attrs);
 #else
 static inline bool use_dma_iommu(struct device *dev)
 {
@@ -184,5 +190,24 @@ static inline int iommu_dma_alloc_iova(struct dma_iova_state *state,
 static inline void iommu_dma_free_iova(struct dma_iova_state *state)
 {
 }
+static inline int iommu_dma_start_range(struct device *dev)
+{
+	return -EOPNOTSUPP;
+}
+static inline void iommu_dma_end_range(struct device *dev)
+{
+}
+static inline dma_addr_t iommu_dma_link_range(struct dma_iova_state *state,
+					      phys_addr_t phys, size_t size,
+					      unsigned long attrs)
+{
+	return DMA_MAPPING_ERROR;
+}
+static inline void iommu_dma_unlink_range(struct device *dev, dma_addr_t start,
+					  size_t size,
+					  enum dma_data_direction dir,
+					  unsigned long attrs)
+{
+}
 #endif /* CONFIG_IOMMU_DMA */
 #endif /* _LINUX_IOMMU_DMA_H */
-- 
2.46.0


