Return-Path: <kvm+bounces-29610-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 35F6F9AE0F6
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 11:36:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DC76128451A
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 09:36:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 987291CBA09;
	Thu, 24 Oct 2024 09:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="k+b5ggKt"
X-Original-To: kvm@vger.kernel.org
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD291C4A3F;
	Thu, 24 Oct 2024 09:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729762502; cv=none; b=hahjiuHi8Ab8n4d7bANMhMMMKI9cFOr68OykO8dzrcBiIzfzhQJTDoWMIBbszLLOhXIuIKrKEn9khHPU2yeHSalGTVhwWaFtDHNFCzLxXerZ5+91KUIlDpI1jpQdsTcI5kQSK/D1AXTOWj9gw1qk+cV2zQmxHz+gnWzZs03eh3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729762502; c=relaxed/simple;
	bh=kyeizXTxkvwKS9yvrQoTQ1IlbCXK85+J+THjR+vsZ8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L7t/uXrP0ioPh7FhO+hso/RHEvyhr4nGFtPs8OsmQBGp0bRY2tXcBJ77vDhlJ7NWDHuiyPJ8zuXST9devTWIw8dpINhhryevpxF9Wxd+yDZjjV+ilyHcdXRKunDvieXhl+3Qk3F5uex5WRTbW+bKaaoFKGjqc+MGV3XhidYyvDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=k+b5ggKt; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1729762490; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=U2nq3lUV0/BjAICa8iDKpSHbCXIbE/HxIiv56DO1T7Y=;
	b=k+b5ggKtLrEdQbAZpGI+EGNZ9sGfB9IJwTHHu5KjagzhGq477CL5+1dDHTrluGTDHqI9o4NyhPe2HduFJlLr6MryJSQ6YO57G6AEm6o+F/RGW3oC93jDIGpMLIvvLQw8xbf1ccoAqTTo7Txv9FHPRL9F3A82JzLHC7O9qP1cjuQ=
Received: from localhost.localdomain(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0WHoiyxU_1729762489 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 24 Oct 2024 17:34:50 +0800
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Alex Williamson <alex.williamson@redhat.com>
Cc: linux-mm@kvack.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Qinyun Tan <qinyuntan@linux.alibaba.com>,
	Guanghui Feng <guanghuifeng@linux.alibaba.com>,
	Xunlei Pang <xlpang@linux.alibaba.com>
Subject: [PATCH v1: vfio: avoid unnecessary pin memory when dma map io address space 2/2]  vfio: avoid unnecessary pin memory when dma map io address space
Date: Thu, 24 Oct 2024 17:34:44 +0800
Message-ID: <15b38c90ef1eb0825b7492d633d46d901e428f7d.1729760996.git.qinyuntan@linux.alibaba.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1729760996.git.qinyuntan@linux.alibaba.com>
References: <cover.1729760996.git.qinyuntan@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When user application call ioctl(VFIO_IOMMU_MAP_DMA) to map a dma address,
the general handler 'vfio_pin_map_dma' attempts to pin the memory and
then create the mapping in the iommu.

However, some mappings aren't backed by a struct page, for example an
mmap'd MMIO range for our own or another device. In this scenario, a vma
with flag VM_IO | VM_PFNMAP, the pin operation will fail. Moreover, the
pin operation incurs a large overhead which will result in a longer
startup time for the VM. We don't actually need a pin in this scenario.

To address this issue, we introduce a new DMA MAP flag
'VFIO_DMA_MAP_FLAG_MMIO_DONT_PIN' to skip the 'vfio_pin_pages_remote'
operation in the DMA map process for mmio memory. Additionally, we add
the 'VM_PGOFF_IS_PFN' flag for vfio_pci_mmap address, ensuring that we can
directly obtain the pfn through vma->vm_pgoff.

This approach allows us to avoid unnecessary memory pinning operations,
which would otherwise introduce additional overhead during DMA mapping.

In my tests, using vfio to pass through an 8-card AMD GPU which with a
large bar size (128GB*8), the time mapping the 192GB*8 bar was reduced
from about 50.79s to 1.57s.

Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
Signed-off-by: Guanghui Feng <guanghuifeng@linux.alibaba.com>
Reviewed-by: Xunlei Pang <xlpang@linux.alibaba.com>
---
 drivers/vfio/pci/vfio_pci_core.c |  2 +-
 drivers/vfio/vfio_iommu_type1.c  | 64 +++++++++++++++++++++++++-------
 include/uapi/linux/vfio.h        | 11 ++++++
 3 files changed, 62 insertions(+), 15 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 1ab58da9f38a6..9e8743429e490 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1802,7 +1802,7 @@ int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma
 	 * the VMA flags.
 	 */
 	vm_flags_set(vma, VM_ALLOW_ANY_UNCACHED | VM_IO | VM_PFNMAP |
-			VM_DONTEXPAND | VM_DONTDUMP);
+			VM_DONTEXPAND | VM_DONTDUMP | VM_PGOFF_IS_PFN);
 	vma->vm_ops = &vfio_pci_mmap_ops;
 
 	return 0;
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index bf391b40e576f..156e668de117d 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -1439,7 +1439,7 @@ static int vfio_iommu_map(struct vfio_iommu *iommu, dma_addr_t iova,
 }
 
 static int vfio_pin_map_dma(struct vfio_iommu *iommu, struct vfio_dma *dma,
-			    size_t map_size)
+			    size_t map_size, unsigned int map_flags)
 {
 	dma_addr_t iova = dma->iova;
 	unsigned long vaddr = dma->vaddr;
@@ -1448,27 +1448,61 @@ static int vfio_pin_map_dma(struct vfio_iommu *iommu, struct vfio_dma *dma,
 	long npage;
 	unsigned long pfn, limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
 	int ret = 0;
+	struct mm_struct *mm = current->mm;
+	bool mmio_dont_pin = map_flags & VFIO_DMA_MAP_FLAG_MMIO_DONT_PIN;
+
+	/* This code path is only user initiated */
+	if (!mm) {
+		ret = -ENODEV;
+		goto out;
+	}
 
 	vfio_batch_init(&batch);
 
 	while (size) {
-		/* Pin a contiguous chunk of memory */
-		npage = vfio_pin_pages_remote(dma, vaddr + dma->size,
-					      size >> PAGE_SHIFT, &pfn, limit,
-					      &batch);
-		if (npage <= 0) {
-			WARN_ON(!npage);
-			ret = (int)npage;
-			break;
+		struct vm_area_struct *vma;
+		unsigned long start = vaddr + dma->size;
+		bool do_pin_pages = true;
+
+		if (mmio_dont_pin) {
+			mmap_read_lock(mm);
+
+			vma = find_vma_intersection(mm, start, start+1);
+
+			/*
+			 * If this dma address rang belongs to the IO address space with VMA flags
+			 * VM_IO | VM_PFNMAP | VM_PGOFF_IS_PFN, it doesn't need to be pinned.
+			 * Simply skip the pin operation to avoid unnecessary overhead.
+			 */
+			if (vma && (vma->vm_flags & VM_PFNMAP) && (vma->vm_flags & VM_IO)
+							&& (vma->vm_flags & VM_PGOFF_IS_PFN)) {
+				pfn = vma->vm_pgoff + ((start - vma->vm_start) >> PAGE_SHIFT);
+				npage = min_t(long, (vma->vm_end - start), size) >> PAGE_SHIFT;
+				do_pin_pages = false;
+			}
+			mmap_read_unlock(mm);
+		}
+
+		if (do_pin_pages) {
+			/* Pin a contiguous chunk of memory */
+			npage = vfio_pin_pages_remote(dma, start, size >> PAGE_SHIFT, &pfn,
+							limit, &batch);
+			if (npage <= 0) {
+				WARN_ON(!npage);
+				ret = (int)npage;
+				break;
+			}
 		}
 
 		/* Map it! */
 		ret = vfio_iommu_map(iommu, iova + dma->size, pfn, npage,
 				     dma->prot);
 		if (ret) {
-			vfio_unpin_pages_remote(dma, iova + dma->size, pfn,
-						npage, true);
-			vfio_batch_unpin(&batch, dma);
+			if (do_pin_pages) {
+				vfio_unpin_pages_remote(dma, iova + dma->size, pfn,
+							npage, true);
+				vfio_batch_unpin(&batch, dma);
+			}
 			break;
 		}
 
@@ -1479,6 +1513,7 @@ static int vfio_pin_map_dma(struct vfio_iommu *iommu, struct vfio_dma *dma,
 	vfio_batch_fini(&batch);
 	dma->iommu_mapped = true;
 
+out:
 	if (ret)
 		vfio_remove_dma(iommu, dma);
 
@@ -1645,7 +1680,7 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 	if (list_empty(&iommu->domain_list))
 		dma->size = size;
 	else
-		ret = vfio_pin_map_dma(iommu, dma, size);
+		ret = vfio_pin_map_dma(iommu, dma, size, map->flags);
 
 	if (!ret && iommu->dirty_page_tracking) {
 		ret = vfio_dma_bitmap_alloc(dma, pgsize);
@@ -2639,6 +2674,7 @@ static int vfio_iommu_type1_check_extension(struct vfio_iommu *iommu,
 	case VFIO_TYPE1_IOMMU:
 	case VFIO_TYPE1v2_IOMMU:
 	case VFIO_TYPE1_NESTING_IOMMU:
+	case VFIO_DMA_MAP_MMIO_DONT_PIN:
 	case VFIO_UNMAP_ALL:
 		return 1;
 	case VFIO_UPDATE_VADDR:
@@ -2811,7 +2847,7 @@ static int vfio_iommu_type1_map_dma(struct vfio_iommu *iommu,
 	struct vfio_iommu_type1_dma_map map;
 	unsigned long minsz;
 	uint32_t mask = VFIO_DMA_MAP_FLAG_READ | VFIO_DMA_MAP_FLAG_WRITE |
-			VFIO_DMA_MAP_FLAG_VADDR;
+			VFIO_DMA_MAP_FLAG_VADDR | VFIO_DMA_MAP_FLAG_MMIO_DONT_PIN;
 
 	minsz = offsetofend(struct vfio_iommu_type1_dma_map, size);
 
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 2b68e6cdf1902..ca391ec41b3c3 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -56,6 +56,16 @@
  */
 #define VFIO_UPDATE_VADDR		10
 
+/*
+ * Support VFIO_DMA_MAP_FLAG_MMIO_DONT_PIN for DMA mapping. For MMIO addresses,
+ * we do not need to pin the pages or establish address mapping in the MMU
+ * at this stage. We only need to establish the address mapping in the IOMMU for
+ * the ioctl(VFIO_IOMMU_MAP_DMA). The page table mapping in the MMU will be
+ * dynamically established through the page fault mechanism when the page
+ * is accessed in the future.
+ */
+#define VFIO_DMA_MAP_MMIO_DONT_PIN	11
+
 /*
  * The IOCTL interface is designed for extensibility by embedding the
  * structure length (argsz) and flags into structures passed between
@@ -1560,6 +1570,7 @@ struct vfio_iommu_type1_dma_map {
 #define VFIO_DMA_MAP_FLAG_READ (1 << 0)		/* readable from device */
 #define VFIO_DMA_MAP_FLAG_WRITE (1 << 1)	/* writable from device */
 #define VFIO_DMA_MAP_FLAG_VADDR (1 << 2)
+#define VFIO_DMA_MAP_FLAG_MMIO_DONT_PIN (1 << 3)	/* MMIO doesn't need pin page */
 	__u64	vaddr;				/* Process virtual address */
 	__u64	iova;				/* IO virtual address */
 	__u64	size;				/* Size of mapping (bytes) */
-- 
2.43.5


