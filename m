Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63CD42AD7E0
	for <lists+kvm@lfdr.de>; Tue, 10 Nov 2020 14:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731018AbgKJNmi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Nov 2020 08:42:38 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:2492 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729832AbgKJNmh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Nov 2020 08:42:37 -0500
Received: from dggeme753-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4CVpvR6PX3zQppv;
        Tue, 10 Nov 2020 21:42:27 +0800 (CST)
Received: from [10.174.184.120] (10.174.184.120) by
 dggeme753-chm.china.huawei.com (10.3.19.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Tue, 10 Nov 2020 21:42:33 +0800
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <alex.williamson@redhat.com>
CC:     <kwankhede@nvidia.com>, <wu.wubin@huawei.com>,
        <maoming.maoming@huawei.com>, <xieyingtai@huawei.com>,
        <lizhengui@huawei.com>, <wubinfeng@huawei.com>,
        <xuxiaoyang2@huawei.com>
From:   "xuxiaoyang (C)" <xuxiaoyang2@huawei.com>
Subject: [PATCH] vfio iommu type1: Improve vfio_iommu_type1_pin_pages
 performance
Message-ID: <2553f102-de17-b23b-4cd8-fefaf2a04f24@huawei.com>
Date:   Tue, 10 Nov 2020 21:42:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.184.120]
X-ClientProxiedBy: dggeme710-chm.china.huawei.com (10.1.199.106) To
 dggeme753-chm.china.huawei.com (10.3.19.99)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vfio_iommu_type1_pin_pages is very inefficient because
it is processed page by page when calling vfio_pin_page_external.
Added contiguous_vaddr_get_pfn to process continuous pages
to reduce the number of loops, thereby improving performance.

Signed-off-by: Xiaoyang Xu <xuxiaoyang2@huawei.com>
---
 drivers/vfio/vfio_iommu_type1.c | 241 ++++++++++++++++++++++++++++----
 1 file changed, 214 insertions(+), 27 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 67e827638995..935f80807527 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -628,6 +628,206 @@ static int vfio_unpin_page_external(struct vfio_dma *dma, dma_addr_t iova,
 	return unlocked;
 }

+static int contiguous_vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
+				    int prot, long npage, unsigned long *phys_pfn)
+{
+	struct page **pages = NULL;
+	unsigned int flags = 0;
+	int i, ret;
+
+	pages = kvmalloc_array(npage, sizeof(struct page *), GFP_KERNEL);
+	if (!pages)
+		return -ENOMEM;
+
+	if (prot & IOMMU_WRITE)
+		flags |= FOLL_WRITE;
+
+	mmap_read_lock(mm);
+	ret = pin_user_pages_remote(mm, vaddr, npage, flags | FOLL_LONGTERM,
+				    pages, NULL, NULL);
+	mmap_read_unlock(mm);
+
+	for (i = 0; i < ret; i++)
+		*(phys_pfn + i) = page_to_pfn(pages[i]);
+
+	kvfree(pages);
+
+	return ret;
+}
+
+static int vfio_pin_contiguous_pages_external(struct vfio_iommu *iommu,
+				    struct vfio_dma *dma,
+				    unsigned long *user_pfn,
+				    int npage, unsigned long *phys_pfn,
+				    bool do_accounting)
+{
+	int ret, i, j, lock_acct = 0;
+	unsigned long remote_vaddr;
+	dma_addr_t iova;
+	struct mm_struct *mm;
+	struct vfio_pfn *vpfn;
+
+	mm = get_task_mm(dma->task);
+	if (!mm)
+		return -ENODEV;
+
+	iova = user_pfn[0] << PAGE_SHIFT;
+	remote_vaddr = dma->vaddr + iova - dma->iova;
+	ret = contiguous_vaddr_get_pfn(mm, remote_vaddr, dma->prot,
+					    npage, phys_pfn);
+	mmput(mm);
+	if (ret <= 0)
+		return ret;
+
+	npage = ret;
+	for (i = 0; i < npage; i++) {
+		iova = user_pfn[i] << PAGE_SHIFT;
+		ret = vfio_add_to_pfn_list(dma, iova, phys_pfn[i]);
+		if (ret)
+			goto unwind;
+
+		if (!is_invalid_reserved_pfn(phys_pfn[i]))
+			lock_acct++;
+
+		if (iommu->dirty_page_tracking) {
+			unsigned long pgshift = __ffs(iommu->pgsize_bitmap);
+
+			/*
+			 * Bitmap populated with the smallest supported page
+			 * size
+			 */
+			bitmap_set(dma->bitmap,
+				   (iova - dma->iova) >> pgshift, 1);
+		}
+	}
+
+	if (do_accounting) {
+		ret = vfio_lock_acct(dma, lock_acct, true);
+		if (ret) {
+			if (ret == -ENOMEM)
+				pr_warn("%s: Task %s (%d) RLIMIT_MEMLOCK (%ld) exceeded\n",
+					__func__, dma->task->comm, task_pid_nr(dma->task),
+					task_rlimit(dma->task, RLIMIT_MEMLOCK));
+			goto unwind;
+		}
+	}
+
+	return i;
+unwind:
+	for (j = 0; j < npage; j++) {
+		put_pfn(phys_pfn[j], dma->prot);
+		phys_pfn[j] = 0;
+	}
+
+	for (j = 0; j < i; j++) {
+		iova = user_pfn[j] << PAGE_SHIFT;
+		vpfn = vfio_find_vpfn(dma, iova);
+		if (vpfn)
+			vfio_remove_from_pfn_list(dma, vpfn);
+	}
+
+	return ret;
+}
+
+static int vfio_iommu_type1_pin_contiguous_pages(struct vfio_iommu *iommu,
+					    struct vfio_dma *dma,
+					    unsigned long *user_pfn,
+					    int npage, unsigned long *phys_pfn,
+					    bool do_accounting)
+{
+	int ret, i, j;
+	unsigned long remote_vaddr;
+	dma_addr_t iova;
+
+	ret = vfio_pin_contiguous_pages_external(iommu, dma, user_pfn, npage,
+				phys_pfn, do_accounting);
+	if (ret == npage)
+		return ret;
+
+	if (ret < 0)
+		ret = 0;
+
+	for (i = ret; i < npage; i++) {
+		iova = user_pfn[i] << PAGE_SHIFT;
+		remote_vaddr = dma->vaddr + iova - dma->iova;
+
+		ret = vfio_pin_page_external(dma, remote_vaddr, &phys_pfn[i],
+			    do_accounting);
+		if (ret)
+			goto pin_unwind;
+
+		ret = vfio_add_to_pfn_list(dma, iova, phys_pfn[i]);
+		if (ret) {
+			if (put_pfn(phys_pfn[i], dma->prot) && do_accounting)
+				vfio_lock_acct(dma, -1, true);
+			goto pin_unwind;
+		}
+
+		if (iommu->dirty_page_tracking) {
+			unsigned long pgshift = __ffs(iommu->pgsize_bitmap);
+
+			/*
+			 * Bitmap populated with the smallest supported page
+			 * size
+			 */
+			bitmap_set(dma->bitmap,
+					   (iova - dma->iova) >> pgshift, 1);
+		}
+	}
+
+	return i;
+
+pin_unwind:
+	phys_pfn[i] = 0;
+	for (j = 0; j < i; j++) {
+		dma_addr_t iova;
+
+		iova = user_pfn[j] << PAGE_SHIFT;
+		vfio_unpin_page_external(dma, iova, do_accounting);
+		phys_pfn[j] = 0;
+	}
+
+	return ret;
+}
+
+static int vfio_iommu_type1_get_contiguous_pages_length(struct vfio_iommu *iommu,
+				    unsigned long *user_pfn, int npage, int prot)
+{
+	struct vfio_dma *dma_base;
+	int i;
+	dma_addr_t iova;
+	struct vfio_pfn *vpfn;
+
+	if (npage <= 1)
+		return npage;
+
+	iova = user_pfn[0] << PAGE_SHIFT;
+	dma_base = vfio_find_dma(iommu, iova, PAGE_SIZE);
+	if (!dma_base)
+		return -EINVAL;
+
+	if ((dma_base->prot & prot) != prot)
+		return -EPERM;
+
+	for (i = 1; i < npage; i++) {
+		iova = user_pfn[i] << PAGE_SHIFT;
+
+		if (iova >= dma_base->iova + dma_base->size ||
+				iova + PAGE_SIZE <= dma_base->iova)
+			break;
+
+		vpfn = vfio_iova_get_vfio_pfn(dma_base, iova);
+		if (vpfn) {
+			vfio_iova_put_vfio_pfn(dma_base, vpfn);
+			break;
+		}
+
+		if (user_pfn[i] != user_pfn[0] + i)
+			break;
+	}
+	return i;
+}
+
 static int vfio_iommu_type1_pin_pages(void *iommu_data,
 				      struct iommu_group *iommu_group,
 				      unsigned long *user_pfn,
@@ -637,9 +837,9 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 	struct vfio_iommu *iommu = iommu_data;
 	struct vfio_group *group;
 	int i, j, ret;
-	unsigned long remote_vaddr;
 	struct vfio_dma *dma;
 	bool do_accounting;
+	int contiguous_npage;

 	if (!iommu || !user_pfn || !phys_pfn)
 		return -EINVAL;
@@ -663,7 +863,7 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 	 */
 	do_accounting = !IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu);

-	for (i = 0; i < npage; i++) {
+	for (i = 0; i < npage; i += contiguous_npage) {
 		dma_addr_t iova;
 		struct vfio_pfn *vpfn;

@@ -682,31 +882,18 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 		vpfn = vfio_iova_get_vfio_pfn(dma, iova);
 		if (vpfn) {
 			phys_pfn[i] = vpfn->pfn;
-			continue;
-		}
-
-		remote_vaddr = dma->vaddr + (iova - dma->iova);
-		ret = vfio_pin_page_external(dma, remote_vaddr, &phys_pfn[i],
-					     do_accounting);
-		if (ret)
-			goto pin_unwind;
-
-		ret = vfio_add_to_pfn_list(dma, iova, phys_pfn[i]);
-		if (ret) {
-			if (put_pfn(phys_pfn[i], dma->prot) && do_accounting)
-				vfio_lock_acct(dma, -1, true);
-			goto pin_unwind;
-		}
-
-		if (iommu->dirty_page_tracking) {
-			unsigned long pgshift = __ffs(iommu->pgsize_bitmap);
-
-			/*
-			 * Bitmap populated with the smallest supported page
-			 * size
-			 */
-			bitmap_set(dma->bitmap,
-				   (iova - dma->iova) >> pgshift, 1);
+			contiguous_npage = 1;
+		} else {
+			ret = vfio_iommu_type1_get_contiguous_pages_length(iommu,
+					&user_pfn[i], npage - i, prot);
+			if (ret < 0)
+				goto pin_unwind;
+
+			ret = vfio_iommu_type1_pin_contiguous_pages(iommu,
+					dma, &user_pfn[i], ret, &phys_pfn[i], do_accounting);
+			if (ret < 0)
+				goto pin_unwind;
+			contiguous_npage = ret;
 		}
 	}
 	ret = i;
--
2.19.1
