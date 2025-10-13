Return-Path: <kvm+bounces-59861-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 88AA7BD176E
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 07:32:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 498814E9981
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 05:32:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F32152DAFAE;
	Mon, 13 Oct 2025 05:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b="fKBli/z2"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A542C11EA
	for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 05:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760333566; cv=none; b=g5wlV/9M4/eAzdLwufxjjk0iUkHCGA09wQ5BXBhnelpZucEv7ZOiYRbouj5vifXV5nXf3m4CWWUf9UorPlxWb8Tw/vIQHnMtG6HGIruxnM7PC94GKViNOHnJy2MkPSpTYnF/uItKskFOGdW/nJU5zkidJrGiN0thy+Hm9Y20UH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760333566; c=relaxed/simple;
	bh=6XcZ9MVYEQvbzX0ab/p/XqkK7vVjmvZOH+HTZVqz2Bw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=kBCR0xrHQCPObUfNm0DfNm2NlVj0cHEAKBNmnedhrF+VOOs//VzvMLadFw7mbvljsPUqyZ+uJHSn7Dn9Q2fWPBg9Bnxm8ftKobTAsnhCAHw0h/gsdXF2svnaSFxu7mzBBKlC3yiA8FbbY2hFH0+3Eap6wiyZE9GW7JtYlkkVW5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b=fKBli/z2; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59CMgNrE1450873
	for <kvm@vger.kernel.org>; Sun, 12 Oct 2025 22:32:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=R8mY5ErWJ0OEynwU1tO7R/gc5Tv7LC/H9b+NJx7lPuQ=; b=fKBli/z2Ufxm
	BbRF8srZ8PJHqPga6Yg7pPTmdQAtvDuPgNZtIhOVHRbQHdvMxu5WYfjFOUaUCotS
	849etk12tRJfSaMplwlm6XiYN8WETQDs58NvUE1c8EmLzslmQ2qlavAdZDp966qB
	vjsQrWTHQZTw4foIp3FiAFYKaUNyRB4bFPqSbXrXs7v63/UsO2EL6sxNDbvCMVOR
	EV9+YC0aOF7lulUK0fywsmG1qiiR/36/IHu+MitZYCwfCEcZM/S0xMKp+G+9/ETv
	PZq1uOjf9KisEYDg/gr1MUjU1gH3DMC3/38Jd/eHQa95uu/3gIqIgoD4ltFPcV1v
	kLFOl03KfQ==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 49rnbm172b-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Sun, 12 Oct 2025 22:32:43 -0700 (PDT)
Received: from twshared18070.28.prn2.facebook.com (2620:10d:c085:208::7cb7) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Mon, 13 Oct 2025 05:32:42 +0000
Received: by devgpu015.cco6.facebook.com (Postfix, from userid 199522)
	id 9E257102FE47; Sun, 12 Oct 2025 22:32:30 -0700 (PDT)
From: Alex Mastro <amastro@fb.com>
Date: Sun, 12 Oct 2025 22:32:24 -0700
Subject: [PATCH v4 1/3] vfio/type1: sanitize for overflow using
 check_*_overflow
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20251012-fix-unmap-v4-1-9eefc90ed14c@fb.com>
References: <20251012-fix-unmap-v4-0-9eefc90ed14c@fb.com>
In-Reply-To: <20251012-fix-unmap-v4-0-9eefc90ed14c@fb.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: Jason Gunthorpe <jgg@ziepe.ca>,
        Alejandro Jimenez
	<alejandro.j.jimenez@oracle.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Alex Mastro <amastro@fb.com>
X-Mailer: b4 0.13.0
X-FB-Internal: Safe
X-Proofpoint-GUID: 3M_CrCbWu0Enn6k5A8EYEbbs3bHY6m1M
X-Authority-Analysis: v=2.4 cv=NfjrFmD4 c=1 sm=1 tr=0 ts=68ec8efb cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=FOH2dFAWAAAA:8 a=kr0RIOuGBwfI36ecCNoA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 3M_CrCbWu0Enn6k5A8EYEbbs3bHY6m1M
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDEzMDAyNiBTYWx0ZWRfX6oH+OFIv2sTK
 Ss9wycilEHb0svL5ZCU+3smUSKX6LNFkbSFO66zfdDR1Taru0LxAKKbiW/gF1soDMoQEaTdr4ks
 LnglARlTwBiZQA45zIC3LgfPdcrqbTeAJ7Srn01meaUdH8ztw9BOApog6uOJ07XyhkEy98KVk8D
 INW8LNuJ4LiN1iycbUpDjETg1taQfl4PKJuxnNEnKqJAcMJmRqGAu6vaUxPzydSV9On5GuEdxjo
 9hGabA/MXZFkUEdiTh5R2S1LAjf5M/W2b6h3EyRl0qBoSZbf7e6pO7WsPXn8KW4e7slnRULRiS3
 cbc5VwBxo4TZe4O6SZAbFb9BCI8EpALdb6jtYijifEvgQdg4z2b/89STdq7dSb0pjlczd2l87iw
 HbWRJv7OJpFj686i6a4QyNvmjJCjKw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-13_02,2025-10-06_01,2025-03-28_01

Adopt check_*_overflow functions to clearly express overflow check
intent.

Signed-off-by: Alex Mastro <amastro@fb.com>
---
 drivers/vfio/vfio_iommu_type1.c | 86 ++++++++++++++++++++++++++++++-----------
 1 file changed, 63 insertions(+), 23 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index f8d68fe77b41..1ac056b27f27 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -37,6 +37,7 @@
 #include <linux/vfio.h>
 #include <linux/workqueue.h>
 #include <linux/notifier.h>
+#include <linux/overflow.h>
 #include "vfio.h"
 
 #define DRIVER_VERSION  "0.2"
@@ -180,7 +181,7 @@ static struct vfio_dma *vfio_find_dma(struct vfio_iommu *iommu,
 }
 
 static struct rb_node *vfio_find_dma_first_node(struct vfio_iommu *iommu,
-						dma_addr_t start, u64 size)
+						dma_addr_t start, size_t size)
 {
 	struct rb_node *res = NULL;
 	struct rb_node *node = iommu->dma_list.rb_node;
@@ -825,14 +826,20 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 	unsigned long remote_vaddr;
 	struct vfio_dma *dma;
 	bool do_accounting;
+	dma_addr_t iova_end;
+	size_t iova_size;
 
-	if (!iommu || !pages)
+	if (!iommu || !pages || npage <= 0)
 		return -EINVAL;
 
 	/* Supported for v2 version only */
 	if (!iommu->v2)
 		return -EACCES;
 
+	if (check_mul_overflow(npage, PAGE_SIZE, &iova_size) ||
+	    check_add_overflow(user_iova, iova_size - 1, &iova_end))
+		return -EOVERFLOW;
+
 	mutex_lock(&iommu->lock);
 
 	if (WARN_ONCE(iommu->vaddr_invalid_count,
@@ -938,12 +945,21 @@ static void vfio_iommu_type1_unpin_pages(void *iommu_data,
 {
 	struct vfio_iommu *iommu = iommu_data;
 	bool do_accounting;
+	dma_addr_t iova_end;
+	size_t iova_size;
 	int i;
 
 	/* Supported for v2 version only */
 	if (WARN_ON(!iommu->v2))
 		return;
 
+	if (WARN_ON(npage <= 0))
+		return;
+
+	if (WARN_ON(check_mul_overflow(npage, PAGE_SIZE, &iova_size) ||
+		    check_add_overflow(user_iova, iova_size - 1, &iova_end)))
+		return;
+
 	mutex_lock(&iommu->lock);
 
 	do_accounting = list_empty(&iommu->domain_list);
@@ -1304,7 +1320,8 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 	int ret = -EINVAL, retries = 0;
 	unsigned long pgshift;
 	dma_addr_t iova = unmap->iova;
-	u64 size = unmap->size;
+	dma_addr_t iova_end;
+	size_t size = unmap->size;
 	bool unmap_all = unmap->flags & VFIO_DMA_UNMAP_FLAG_ALL;
 	bool invalidate_vaddr = unmap->flags & VFIO_DMA_UNMAP_FLAG_VADDR;
 	struct rb_node *n, *first_n;
@@ -1317,6 +1334,11 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 		goto unlock;
 	}
 
+	if (iova != unmap->iova || size != unmap->size) {
+		ret = -EOVERFLOW;
+		goto unlock;
+	}
+
 	pgshift = __ffs(iommu->pgsize_bitmap);
 	pgsize = (size_t)1 << pgshift;
 
@@ -1326,10 +1348,15 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 	if (unmap_all) {
 		if (iova || size)
 			goto unlock;
-		size = U64_MAX;
-	} else if (!size || size & (pgsize - 1) ||
-		   iova + size - 1 < iova || size > SIZE_MAX) {
-		goto unlock;
+		size = SIZE_MAX;
+	} else {
+		if (!size || size & (pgsize - 1))
+			goto unlock;
+
+		if (check_add_overflow(iova, size - 1, &iova_end)) {
+			ret = -EOVERFLOW;
+			goto unlock;
+		}
 	}
 
 	/* When dirty tracking is enabled, allow only min supported pgsize */
@@ -1376,7 +1403,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 		if (dma && dma->iova != iova)
 			goto unlock;
 
-		dma = vfio_find_dma(iommu, iova + size - 1, 0);
+		dma = vfio_find_dma(iommu, iova_end, 0);
 		if (dma && dma->iova + dma->size != iova + size)
 			goto unlock;
 	}
@@ -1578,7 +1605,9 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 {
 	bool set_vaddr = map->flags & VFIO_DMA_MAP_FLAG_VADDR;
 	dma_addr_t iova = map->iova;
+	dma_addr_t iova_end;
 	unsigned long vaddr = map->vaddr;
+	unsigned long vaddr_end;
 	size_t size = map->size;
 	int ret = 0, prot = 0;
 	size_t pgsize;
@@ -1586,8 +1615,15 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 
 	/* Verify that none of our __u64 fields overflow */
 	if (map->size != size || map->vaddr != vaddr || map->iova != iova)
+		return -EOVERFLOW;
+
+	if (!size)
 		return -EINVAL;
 
+	if (check_add_overflow(iova, size - 1, &iova_end) ||
+	    check_add_overflow(vaddr, size - 1, &vaddr_end))
+		return -EOVERFLOW;
+
 	/* READ/WRITE from device perspective */
 	if (map->flags & VFIO_DMA_MAP_FLAG_WRITE)
 		prot |= IOMMU_WRITE;
@@ -1603,13 +1639,7 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 
 	WARN_ON((pgsize - 1) & PAGE_MASK);
 
-	if (!size || (size | iova | vaddr) & (pgsize - 1)) {
-		ret = -EINVAL;
-		goto out_unlock;
-	}
-
-	/* Don't allow IOVA or virtual address wrap */
-	if (iova + size - 1 < iova || vaddr + size - 1 < vaddr) {
+	if ((size | iova | vaddr) & (pgsize - 1)) {
 		ret = -EINVAL;
 		goto out_unlock;
 	}
@@ -1640,7 +1670,7 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 		goto out_unlock;
 	}
 
-	if (!vfio_iommu_iova_dma_valid(iommu, iova, iova + size - 1)) {
+	if (!vfio_iommu_iova_dma_valid(iommu, iova, iova_end)) {
 		ret = -EINVAL;
 		goto out_unlock;
 	}
@@ -2907,7 +2937,8 @@ static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
 		struct vfio_iommu_type1_dirty_bitmap_get range;
 		unsigned long pgshift;
 		size_t data_size = dirty.argsz - minsz;
-		size_t iommu_pgsize;
+		size_t size, iommu_pgsize;
+		dma_addr_t iova, iova_end;
 
 		if (!data_size || data_size < sizeof(range))
 			return -EINVAL;
@@ -2916,14 +2947,24 @@ static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
 				   sizeof(range)))
 			return -EFAULT;
 
-		if (range.iova + range.size < range.iova)
+		iova = range.iova;
+		size = range.size;
+
+		if (iova != range.iova || size != range.size)
+			return -EOVERFLOW;
+
+		if (!size)
 			return -EINVAL;
+
+		if (check_add_overflow(iova, size - 1, &iova_end))
+			return -EOVERFLOW;
+
 		if (!access_ok((void __user *)range.bitmap.data,
 			       range.bitmap.size))
 			return -EINVAL;
 
 		pgshift = __ffs(range.bitmap.pgsize);
-		ret = verify_bitmap_size(range.size >> pgshift,
+		ret = verify_bitmap_size(size >> pgshift,
 					 range.bitmap.size);
 		if (ret)
 			return ret;
@@ -2937,19 +2978,18 @@ static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
 			ret = -EINVAL;
 			goto out_unlock;
 		}
-		if (range.iova & (iommu_pgsize - 1)) {
+		if (iova & (iommu_pgsize - 1)) {
 			ret = -EINVAL;
 			goto out_unlock;
 		}
-		if (!range.size || range.size & (iommu_pgsize - 1)) {
+		if (size & (iommu_pgsize - 1)) {
 			ret = -EINVAL;
 			goto out_unlock;
 		}
 
 		if (iommu->dirty_page_tracking)
 			ret = vfio_iova_dirty_bitmap(range.bitmap.data,
-						     iommu, range.iova,
-						     range.size,
+						     iommu, iova, size,
 						     range.bitmap.pgsize);
 		else
 			ret = -EINVAL;

-- 
2.47.3


