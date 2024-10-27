Return-Path: <kvm+bounces-29775-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A32699B1E58
	for <lists+kvm@lfdr.de>; Sun, 27 Oct 2024 15:26:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0A654B22140
	for <lists+kvm@lfdr.de>; Sun, 27 Oct 2024 14:26:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F36C818D65E;
	Sun, 27 Oct 2024 14:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b7l02Pni"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10D201779A4;
	Sun, 27 Oct 2024 14:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730038933; cv=none; b=MdyEBMhTJnTisHLqb+drCprvgrqFybeYV1+Sssuf5YOqRHYXF3QrNI1bW6xzguGSX8ylA+LmCLvVdaS8X+0maRZqgV+IMJxvtdPLz9N/wGlLr1TLB+KTgDPQaeyDddCM0egRmjUi0ronJI2+1cPOJK+fb0xSdXpubWT84/8DZbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730038933; c=relaxed/simple;
	bh=evzyHAPqYyUnLaT3iQjwydmJ5tMcKT9praApMXMc55E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kQ4RSTIXB9H5a1kpoPXcsC2Xa5r89kZFgBk4ARAA3GSuawCn8zUrQoCqMvCj8XweXl2Z+jnITMmv4FWxjJyWLSDyltCeYrh6F1Mb5BPCutYB8eyiIfN4dztSGURy7vyiC9zt4Oj4sb9x6XeX/lL1jJXHznZ8tF6Sl2SnO7hxNaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b7l02Pni; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D29EAC4CEC3;
	Sun, 27 Oct 2024 14:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730038932;
	bh=evzyHAPqYyUnLaT3iQjwydmJ5tMcKT9praApMXMc55E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b7l02PniEWSFRqY/0/7iovO8qTlI6NrvEizVq3tbrFR55i9XgyDxqpALSjeUlsPU/
	 EcexJQe46XOJyyybAEAneKjPfeVEbVRKSk+ueBWim8imKq0EL9W8Zxxx8Ag/Y+dQjI
	 484WsFeAaV/l/UqoOTlrEAkrSoMavbb4aJPz3i08UJ31OLJClDDOaCd0hJydQQGZZ5
	 QU1zw09zD+xbg8XjW6id0xLiDIdxjiEkrauEhHo0IHyLfwxnatQaLj81pXo9c9lP0X
	 mULqUtOUjHkcyZawF2rvXZnsPWzAYJows4zddbbiIYiCBUPd5Zfw1F8fD4d2KopfFx
	 PllSIyesHoGwA==
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
	linux-mm@kvack.org
Subject: [PATCH 11/18] mm/hmm: provide generic DMA managing logic
Date: Sun, 27 Oct 2024 16:21:11 +0200
Message-ID: <505c3956e0101f3e4f180e67319ff33c789f83b5.1730037276.git.leon@kernel.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <cover.1730037276.git.leon@kernel.org>
References: <cover.1730037276.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

HMM callers use PFN list to populate range while calling
to hmm_range_fault(), the conversion from PFN to DMA address
is done by the callers with help of another DMA list. However,
it is wasteful on any modern platform and by doing the right
logic, that DMA list can be avoided.

Provide generic logic to manage these lists and gave an interface
to map/unmap PFNs to DMA addresses, without requiring from the callers
to be an experts in DMA core API.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/linux/hmm-dma.h |  32 +++++++
 include/linux/hmm.h     |   2 +
 mm/hmm.c                | 195 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 229 insertions(+)
 create mode 100644 include/linux/hmm-dma.h

diff --git a/include/linux/hmm-dma.h b/include/linux/hmm-dma.h
new file mode 100644
index 000000000000..f6ce2a00d74d
--- /dev/null
+++ b/include/linux/hmm-dma.h
@@ -0,0 +1,32 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/* Copyright (c) 2024 NVIDIA Corporation & Affiliates */
+#ifndef LINUX_HMM_DMA_H
+#define LINUX_HMM_DMA_H
+
+#include <linux/dma-mapping.h>
+
+struct dma_iova_state;
+struct pci_p2pdma_map_state;
+
+/*
+ * struct hmm_dma_map - array of PFNs and DMA addresses
+ *
+ * @state: DMA IOVA state
+ * @pfns: array of PFNs
+ * @dma_list: array of DMA addresses
+ * @dma_entry_size: size of each DMA entry in the array
+ */
+struct hmm_dma_map {
+	struct dma_iova_state state;
+	unsigned long *pfn_list;
+	dma_addr_t *dma_list;
+	size_t dma_entry_size;
+};
+
+int hmm_dma_map_alloc(struct device *dev, struct hmm_dma_map *map,
+		      size_t nr_entries, size_t dma_entry_size);
+void hmm_dma_map_free(struct device *dev, struct hmm_dma_map *map);
+dma_addr_t hmm_dma_map_pfn(struct device *dev, struct hmm_dma_map *map,
+			   size_t idx, struct pci_p2pdma_map_state *p2pdma_state);
+bool hmm_dma_unmap_pfn(struct device *dev, struct hmm_dma_map *map, size_t idx);
+#endif /* LINUX_HMM_DMA_H */
diff --git a/include/linux/hmm.h b/include/linux/hmm.h
index 5dd655f6766b..62980ca8f3c5 100644
--- a/include/linux/hmm.h
+++ b/include/linux/hmm.h
@@ -23,6 +23,7 @@ struct mmu_interval_notifier;
  * HMM_PFN_WRITE - if the page memory can be written to (requires HMM_PFN_VALID)
  * HMM_PFN_ERROR - accessing the pfn is impossible and the device should
  *                 fail. ie poisoned memory, special pages, no vma, etc
+ * HMM_PFN_P2PDMA_BUS - Bus mapped P2P transfer
  * HMM_PFN_DMA_MAPPED - Flag preserved on input-to-output transformation
  *                      to mark that page is already DMA mapped
  *
@@ -40,6 +41,7 @@ enum hmm_pfn_flags {
 	HMM_PFN_ERROR = 1UL << (BITS_PER_LONG - 3),
 
 	/* Sticky flag, carried from Input to Output */
+	HMM_PFN_P2PDMA_BUS = 1UL << (BITS_PER_LONG - 6),
 	HMM_PFN_DMA_MAPPED = 1UL << (BITS_PER_LONG - 7),
 
 	HMM_PFN_ORDER_SHIFT = (BITS_PER_LONG - 8),
diff --git a/mm/hmm.c b/mm/hmm.c
index 2a0c34d7cb2b..85cd6f20303c 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -10,6 +10,7 @@
  */
 #include <linux/pagewalk.h>
 #include <linux/hmm.h>
+#include <linux/hmm-dma.h>
 #include <linux/init.h>
 #include <linux/rmap.h>
 #include <linux/swap.h>
@@ -23,6 +24,7 @@
 #include <linux/sched/mm.h>
 #include <linux/jump_label.h>
 #include <linux/dma-mapping.h>
+#include <linux/pci-p2pdma.h>
 #include <linux/mmu_notifier.h>
 #include <linux/memory_hotplug.h>
 
@@ -615,3 +617,196 @@ int hmm_range_fault(struct hmm_range *range)
 	return ret;
 }
 EXPORT_SYMBOL(hmm_range_fault);
+
+/**
+ * hmm_dma_map_alloc - Allocate HMM map structure
+ * @dev: device to allocate structure for
+ * @map: HMM map to allocate
+ * @nr_entries: number of entries in the map
+ * @dma_entry_size: size of the DMA entry in the map
+ *
+ * Allocate the HMM map structure and all the lists it contains.
+ * Return 0 on success, -ENOMEM on failure.
+ */
+int hmm_dma_map_alloc(struct device *dev, struct hmm_dma_map *map,
+		      size_t nr_entries, size_t dma_entry_size)
+{
+	bool dma_need_sync = false;
+	bool use_iova;
+
+	if (!(nr_entries * PAGE_SIZE / dma_entry_size))
+		return -EINVAL;
+
+	/*
+	 * The HMM API violates our normal DMA buffer ownership rules and can't
+	 * transfer buffer ownership.  The dma_addressing_limited() check is a
+	 * best approximation to ensure no swiotlb buffering happens.
+	 */
+	if (IS_ENABLED(CONFIG_DMA_NEED_SYNC))
+		dma_need_sync = !dev->dma_skip_sync;
+	if (dma_need_sync || dma_addressing_limited(dev))
+		return -EOPNOTSUPP;
+
+	map->dma_entry_size = dma_entry_size;
+	map->pfn_list =
+		kvcalloc(nr_entries, sizeof(*map->pfn_list), GFP_KERNEL);
+	if (!map->pfn_list)
+		return -ENOMEM;
+
+	use_iova = dma_iova_try_alloc(dev, &map->state, 0,
+			nr_entries * PAGE_SIZE);
+	if (!use_iova && dma_need_unmap(dev)) {
+		map->dma_list = kvcalloc(nr_entries, sizeof(*map->dma_list),
+					 GFP_KERNEL);
+		if (!map->dma_list)
+			goto err_dma;
+	}
+	return 0;
+
+err_dma:
+	kfree(map->pfn_list);
+	return -ENOMEM;
+}
+EXPORT_SYMBOL_GPL(hmm_dma_map_alloc);
+
+/**
+ * hmm_dma_map_free - iFree HMM map structure
+ * @dev: device to free structure from
+ * @map: HMM map containing the various lists and state
+ *
+ * Free the HMM map structure and all the lists it contains.
+ */
+void hmm_dma_map_free(struct device *dev, struct hmm_dma_map *map)
+{
+	if (dma_use_iova(&map->state))
+		dma_iova_free(dev, &map->state);
+	kfree(map->pfn_list);
+	kfree(map->dma_list);
+}
+EXPORT_SYMBOL_GPL(hmm_dma_map_free);
+
+/**
+ * hmm_dma_map_pfn - Map a physical HMM page to DMA address
+ * @dev: Device to map the page for
+ * @map: HMM map
+ * @idx: Index into the PFN and dma address arrays
+ * @pci_p2pdma_map_state: PCI P2P state.
+ *
+ * dma_alloc_iova() allocates IOVA based on the size specified by their use in
+ * iova->size. Call this function after IOVA allocation to link whole @page
+ * to get the DMA address. Note that very first call to this function
+ * will have @offset set to 0 in the IOVA space allocated from
+ * dma_alloc_iova(). For subsequent calls to this function on same @iova,
+ * @offset needs to be advanced by the caller with the size of previous
+ * page that was linked + DMA address returned for the previous page that was
+ * linked by this function.
+ */
+dma_addr_t hmm_dma_map_pfn(struct device *dev, struct hmm_dma_map *map,
+			   size_t idx, struct pci_p2pdma_map_state *p2pdma_state)
+{
+	struct dma_iova_state *state = &map->state;
+	dma_addr_t *dma_addrs = map->dma_list;
+	unsigned long *pfns = map->pfn_list;
+	struct page *page = hmm_pfn_to_page(pfns[idx]);
+	phys_addr_t paddr = hmm_pfn_to_phys(pfns[idx]);
+	size_t offset = idx * map->dma_entry_size;
+	dma_addr_t dma_addr;
+	int ret;
+
+	if ((pfns[idx] & HMM_PFN_DMA_MAPPED) &&
+	    !(pfns[idx] & HMM_PFN_P2PDMA_BUS)) {
+		/*
+		 * We are in this flow when there is a need to resync flags,
+		 * for example when page was already linked in prefetch call
+		 * with READ flag and now we need to add WRITE flag
+		 *
+		 * This page was already programmed to HW and we don't want/need
+		 * to unlink and link it again just to resync flags.
+		 */
+		if (dma_use_iova(state))
+			return state->addr + offset;
+
+		/*
+		 * Without dma_need_unmap, the dma_addrs array is NULL, thus we
+		 * need to regenerate the address below even if there already
+		 * was a mapping. But !dma_need_unmap implies that the
+		 * mapping stateless, so this is fine.
+		 */
+		if (dma_need_unmap(dev))
+			return dma_addrs[idx];
+
+		/* Continue to remapping */
+	}
+
+	switch (pci_p2pdma_state(p2pdma_state, dev, page)) {
+	case PCI_P2PDMA_MAP_THRU_HOST_BRIDGE:
+	case PCI_P2PDMA_MAP_NONE:
+		break;
+	case PCI_P2PDMA_MAP_BUS_ADDR:
+		dma_addr = pci_p2pdma_bus_addr_map(p2pdma_state, paddr);
+		pfns[idx] |= HMM_PFN_P2PDMA_BUS;
+		goto done;
+	default:
+		return DMA_MAPPING_ERROR;
+	}
+
+	if (dma_use_iova(state)) {
+		ret = dma_iova_link(dev, state, paddr, offset,
+				    map->dma_entry_size, DMA_BIDIRECTIONAL, 0);
+		ret = dma_iova_sync(dev, state, offset, map->dma_entry_size,
+			ret);
+		if (ret)
+			return DMA_MAPPING_ERROR;
+
+		dma_addr = state->addr + offset;
+	} else {
+		if (WARN_ON_ONCE(dma_need_unmap(dev) && !dma_addrs))
+			return DMA_MAPPING_ERROR;
+
+		dma_addr = dma_map_page(dev, page, 0, map->dma_entry_size,
+					DMA_BIDIRECTIONAL);
+		if (dma_mapping_error(dev, dma_addr))
+			return DMA_MAPPING_ERROR;
+
+		if (dma_need_unmap(dev))
+			dma_addrs[idx] = dma_addr;
+	}
+
+done:
+	pfns[idx] |= HMM_PFN_DMA_MAPPED;
+	return dma_addr;
+}
+EXPORT_SYMBOL_GPL(hmm_dma_map_pfn);
+
+/**
+ * hmm_dma_unmap_pfn - Unmap a physical HMM page from DMA address
+ * @dev: Device to unmap the page from
+ * @map: HMM map
+ * @idx: Index of the PFN to unmap
+ *
+ * Returns true if the PFN was mapped and has been unmapped, false otherwise.
+ */
+bool hmm_dma_unmap_pfn(struct device *dev, struct hmm_dma_map *map, size_t idx)
+{
+	struct dma_iova_state *state = &map->state;
+	dma_addr_t *dma_addrs = map->dma_list;
+	unsigned long *pfns = map->pfn_list;
+
+#define HMM_PFN_VALID_DMA (HMM_PFN_VALID | HMM_PFN_DMA_MAPPED)
+	if ((pfns[idx] & HMM_PFN_VALID_DMA) != HMM_PFN_VALID_DMA)
+		return false;
+#undef HMM_PFN_VALID_DMA
+
+	if (pfns[idx] & HMM_PFN_P2PDMA_BUS)
+		; /* no need to unmap bus address P2P mappings */
+	else if (dma_use_iova(state))
+		dma_iova_unlink(dev, state, idx * map->dma_entry_size,
+				map->dma_entry_size, DMA_BIDIRECTIONAL, 0);
+	else if (dma_need_unmap(dev))
+		dma_unmap_page(dev, dma_addrs[idx], map->dma_entry_size,
+			       DMA_BIDIRECTIONAL);
+
+	pfns[idx] &= ~(HMM_PFN_DMA_MAPPED | HMM_PFN_P2PDMA_BUS);
+	return true;
+}
+EXPORT_SYMBOL_GPL(hmm_dma_unmap_pfn);
-- 
2.46.2


