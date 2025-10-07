Return-Path: <kvm+bounces-59557-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C5F4BC026A
	for <lists+kvm@lfdr.de>; Tue, 07 Oct 2025 06:25:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B55AF4EAF47
	for <lists+kvm@lfdr.de>; Tue,  7 Oct 2025 04:24:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CF4421A94F;
	Tue,  7 Oct 2025 04:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b="pLwQ3jkk"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B311F4615
	for <kvm@vger.kernel.org>; Tue,  7 Oct 2025 04:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759811092; cv=none; b=OQlMXGIltRh65tYq2jDcSBCNveEa2X7gM1PFQvNYC5Cwo+NH2XUgNTgQUxVKd2D/A6gdCPtPfYYEVHTLnjuKNPInywoiB4nHXO2vZk+BSeRCsgDuC1Dw/Ub5sDQ8bSySd1KDQutnvsq97WHunvFHWQW/rHiJZpxYD9vuZaIFxp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759811092; c=relaxed/simple;
	bh=lzvsY1xoArVCw8tXrta4vNdFVJ0XiZtdMtKSbCiq6gg=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sRfaDZ1Qy+mISAnrBEg72K/nkrnT+zMZtq/kX7g7tbawXpNoXXpwyTn2qAQeAFLKIFPRImjTYS6QQNVy8dA+E/Q4HS2h/EjUaTHvbWJxcBcdpGKRWTjdwihqUUXAT4b5WdlfVi0ZQuwdvldXfK9FPj3ejcz9SSe4oB89xLkiIso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b=pLwQ3jkk; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59742E1M2919762
	for <kvm@vger.kernel.org>; Mon, 6 Oct 2025 21:24:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=s2048-2025-q2; bh=cngsvZSdIP+RydwswOVA
	ihfuG3IRHAmtCy4CkPJRjmI=; b=pLwQ3jkkWqH7eMufS/LspaxSu84A5NvqHtg/
	5iWt9RtN9fXclRWrEuNnfnB5k6VnjVMAYLn5QG7OV8SKlgvg0e/RcYwnFTIIXdyj
	/30CzYTAnjzG3pHoZSTuaE977i+wXhotf4PrZ/xp3A76swX3rEGftZUJ4RH3Povv
	BF4pUZdT351wsvzxGUCLWb5btJ0Av634GYagrIldLiO4dl8q+LRiNYtDG7L25gl1
	6QbRfDO0kT4+6/fl+BLGTVK86wThEigtvlWm1KC+BHNDMHl6m3eR08zguV0Sll9K
	QAH0UJiBGyb5H7rMjcCmZ/YZZrMZc7cWlMYXjQw7tlfAjR3PlA==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 49mufv8328-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Mon, 06 Oct 2025 21:24:48 -0700 (PDT)
Received: from twshared30833.05.prn5.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Tue, 7 Oct 2025 04:24:46 +0000
Received: by devgpu015.cco6.facebook.com (Postfix, from userid 199522)
	id 96EC3C6C6F1; Mon,  6 Oct 2025 21:24:35 -0700 (PDT)
Date: Mon, 6 Oct 2025 21:24:35 -0700
From: Alex Mastro <amastro@fb.com>
To: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
CC: Jason Gunthorpe <jgg@ziepe.ca>,
        Alex Williamson
	<alex.williamson@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vfio: fix VFIO_IOMMU_UNMAP_DMA when end of range would
 overflow u64
Message-ID: <aOSWA46X1XsH7pwP@devgpu015.cco6.facebook.com>
References: <20251005-fix-unmap-v1-1-6687732ed44e@fb.com>
 <20251006121618.GA3365647@ziepe.ca>
 <aOPuU0O6PlOjd/Xs@devgpu015.cco6.facebook.com>
 <20251006225039.GA3441843@ziepe.ca>
 <aORhMMOU5p3j69ld@devgpu015.cco6.facebook.com>
 <68e18f2c-79ad-45ec-99b9-99ff68ba5438@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <68e18f2c-79ad-45ec-99b9-99ff68ba5438@oracle.com>
X-FB-Internal: Safe
X-Proofpoint-ORIG-GUID: E3IbH5e8I2NNmlsWHD1n2fX15rDd4LcL
X-Proofpoint-GUID: E3IbH5e8I2NNmlsWHD1n2fX15rDd4LcL
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA3MDAzMiBTYWx0ZWRfX3ba6JaA7vjFs
 tqGdTeHESFpgHb4PDUsjRcye2osOXSXvWnWMau8Qk52dFoeatfe0xVAy1i1NQEqHoyqLcMs+QaF
 Y13EGUImmoZUVW1NxG3QLlCoo5ImuxdiHAGiHr2EwZyIFNJJoijB+kR6khRvvr0qEPgdhEwVBmI
 XiZ6ckij91JAR+k3q3Phle4IAwJyzWtTnt4XrSq6tdc9kQst2Dh/HJXJETjTB7ViGaRSlyzRqx+
 G5onAtt9zqyKDoHGqeD14eGDUj9ikFxCytk3nlgSl0+8SE+MpezvpLFYfpCj8iRd3FoiSaW7iV4
 OWhM8Dhd2tiVeZH6l+oTZPdkN+pRB23xv8GSfgjRb2e0qKO15ZNXJpqlfbrYWwdbRqKE7ujjBOv
 5v9CmbothM3hmG2I0gf5x/Yh88Jb3g==
X-Authority-Analysis: v=2.4 cv=BsaQAIX5 c=1 sm=1 tr=0 ts=68e49610 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=kj9zAlcOel0A:10 a=x6icFKpwvdMA:10 a=ZjcyzfyPlXKTUgq5GIwA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-06_07,2025-10-06_01,2025-03-28_01

On Mon, Oct 06, 2025 at 09:23:56PM -0400, Alejandro Jimenez wrote:
> If going this way, we'd also have to deny the MAP requests. Right now we

Agree.

> > I have doubts that anyone actually relies on MAP_DMA-ing such
> > end-of-u64-mappings in practice, so perhaps it's OK?
> > 
> 
> The AMD IOMMU supports a 64-bit IOVA, so when using the AMD vIOMMU with DMA
> remapping enabled + VF passthrough + a Linux guest with iommu.forcedac=1 we
> hit this issue since the driver (mlx5) starts requesting mappings for IOVAs
> right at the top of the address space.

Interesting!

> The reason why I hadn't send it to the list yet is because I noticed the
> additional locations Jason mentioned earlier in the thread (e.g.
> vfio_find_dma(), vfio_iommu_replay()) and wanted to put together a
> reproducer that also triggered those paths.

I am not well equipped to test some of these paths, so if you have a recipe, I'd
be interested.
 
> I mentioned in the notes for the patch above why I chose a slightly more
> complex method than the '- 1' approach, since there is a chance that
> iova+size could also go beyond the end of the address space and actually
> wrap around.

I think certain invariants have broken if that is possible. The current checks
in the unmap path should prevent that (iova + size - 1 < iova).

1330          } else if (!size || size & (pgsize - 1) ||
1331                     iova + size - 1 < iova || size > SIZE_MAX) {
1332                  goto unlock;

> My goal was not to trust the inputs at all if possible. We could also use
> check_add_overflow() if we want to add explicit error reporting in
> vfio_iommu_type1 when an overflow is detected. i.e. catch bad callers that

I do like the explicitness of the check_* functions over the older style wrap
checks.

Below is my partially validated attempt at a more comprehensive fix if we were
to try and make end of address space mappings work, rather than blanking out
the last page.

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 08242d8ce2ca..66a25de35446 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -28,6 +28,7 @@
 #include <linux/iommu.h>
 #include <linux/module.h>
 #include <linux/mm.h>
+#include <linux/overflow.h>
 #include <linux/kthread.h>
 #include <linux/rbtree.h>
 #include <linux/sched/signal.h>
@@ -165,12 +166,14 @@ static struct vfio_dma *vfio_find_dma(struct vfio_iommu *iommu,
 {
 	struct rb_node *node = iommu->dma_list.rb_node;
 
+	BUG_ON(size == 0);
+
 	while (node) {
 		struct vfio_dma *dma = rb_entry(node, struct vfio_dma, node);
 
-		if (start + size <= dma->iova)
+		if (start + size - 1 < dma->iova)
 			node = node->rb_left;
-		else if (start >= dma->iova + dma->size)
+		else if (start > dma->iova + dma->size - 1)
 			node = node->rb_right;
 		else
 			return dma;
@@ -186,10 +189,12 @@ static struct rb_node *vfio_find_dma_first_node(struct vfio_iommu *iommu,
 	struct rb_node *node = iommu->dma_list.rb_node;
 	struct vfio_dma *dma_res = NULL;
 
+	BUG_ON(size == 0);
+
 	while (node) {
 		struct vfio_dma *dma = rb_entry(node, struct vfio_dma, node);
 
-		if (start < dma->iova + dma->size) {
+		if (start <= dma->iova + dma->size - 1) {
 			res = node;
 			dma_res = dma;
 			if (start >= dma->iova)
@@ -199,7 +204,7 @@ static struct rb_node *vfio_find_dma_first_node(struct vfio_iommu *iommu,
 			node = node->rb_right;
 		}
 	}
-	if (res && size && dma_res->iova > start + size - 1)
+	if (res && dma_res->iova > start + size - 1)
 		res = NULL;
 	return res;
 }
@@ -213,7 +218,7 @@ static void vfio_link_dma(struct vfio_iommu *iommu, struct vfio_dma *new)
 		parent = *link;
 		dma = rb_entry(parent, struct vfio_dma, node);
 
-		if (new->iova + new->size <= dma->iova)
+		if (new->iova + new->size - 1 < dma->iova)
 			link = &(*link)->rb_left;
 		else
 			link = &(*link)->rb_right;
@@ -825,14 +830,24 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 	unsigned long remote_vaddr;
 	struct vfio_dma *dma;
 	bool do_accounting;
+	u64 end, to_pin;
 
-	if (!iommu || !pages)
+	if (!iommu || !pages || npage < 0)
 		return -EINVAL;
 
 	/* Supported for v2 version only */
 	if (!iommu->v2)
 		return -EACCES;
 
+	if (npage == 0)
+		return 0;
+
+	if (check_mul_overflow(npage, PAGE_SIZE, &to_pin))
+		return -EINVAL;
+
+	if (check_add_overflow(user_iova, to_pin - 1, &end))
+		return -EINVAL;
+
 	mutex_lock(&iommu->lock);
 
 	if (WARN_ONCE(iommu->vaddr_invalid_count,
@@ -997,7 +1012,7 @@ static long vfio_sync_unpin(struct vfio_dma *dma, struct vfio_domain *domain,
 #define VFIO_IOMMU_TLB_SYNC_MAX		512
 
 static size_t unmap_unpin_fast(struct vfio_domain *domain,
-			       struct vfio_dma *dma, dma_addr_t *iova,
+			       struct vfio_dma *dma, dma_addr_t iova,
 			       size_t len, phys_addr_t phys, long *unlocked,
 			       struct list_head *unmapped_list,
 			       int *unmapped_cnt,
@@ -1007,18 +1022,16 @@ static size_t unmap_unpin_fast(struct vfio_domain *domain,
 	struct vfio_regions *entry = kzalloc(sizeof(*entry), GFP_KERNEL);
 
 	if (entry) {
-		unmapped = iommu_unmap_fast(domain->domain, *iova, len,
+		unmapped = iommu_unmap_fast(domain->domain, iova, len,
 					    iotlb_gather);
 
 		if (!unmapped) {
 			kfree(entry);
 		} else {
-			entry->iova = *iova;
+			entry->iova = iova;
 			entry->phys = phys;
 			entry->len  = unmapped;
 			list_add_tail(&entry->list, unmapped_list);
-
-			*iova += unmapped;
 			(*unmapped_cnt)++;
 		}
 	}
@@ -1037,18 +1050,17 @@ static size_t unmap_unpin_fast(struct vfio_domain *domain,
 }
 
 static size_t unmap_unpin_slow(struct vfio_domain *domain,
-			       struct vfio_dma *dma, dma_addr_t *iova,
+			       struct vfio_dma *dma, dma_addr_t iova,
 			       size_t len, phys_addr_t phys,
 			       long *unlocked)
 {
-	size_t unmapped = iommu_unmap(domain->domain, *iova, len);
+	size_t unmapped = iommu_unmap(domain->domain, iova, len);
 
 	if (unmapped) {
-		*unlocked += vfio_unpin_pages_remote(dma, *iova,
+		*unlocked += vfio_unpin_pages_remote(dma, iova,
 						     phys >> PAGE_SHIFT,
 						     unmapped >> PAGE_SHIFT,
 						     false);
-		*iova += unmapped;
 		cond_resched();
 	}
 	return unmapped;
@@ -1057,12 +1069,12 @@ static size_t unmap_unpin_slow(struct vfio_domain *domain,
 static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
 			     bool do_accounting)
 {
-	dma_addr_t iova = dma->iova, end = dma->iova + dma->size;
 	struct vfio_domain *domain, *d;
 	LIST_HEAD(unmapped_region_list);
 	struct iommu_iotlb_gather iotlb_gather;
 	int unmapped_region_cnt = 0;
 	long unlocked = 0;
+	size_t pos = 0;
 
 	if (!dma->size)
 		return 0;
@@ -1086,13 +1098,14 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
 	}
 
 	iommu_iotlb_gather_init(&iotlb_gather);
-	while (iova < end) {
+	while (pos < dma->size) {
 		size_t unmapped, len;
 		phys_addr_t phys, next;
+		dma_addr_t iova = dma->iova + pos;
 
 		phys = iommu_iova_to_phys(domain->domain, iova);
 		if (WARN_ON(!phys)) {
-			iova += PAGE_SIZE;
+			pos += PAGE_SIZE;
 			continue;
 		}
 
@@ -1101,7 +1114,7 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
 		 * may require hardware cache flushing, try to find the
 		 * largest contiguous physical memory chunk to unmap.
 		 */
-		for (len = PAGE_SIZE; iova + len < end; len += PAGE_SIZE) {
+		for (len = PAGE_SIZE; len + pos < dma->size; len += PAGE_SIZE) {
 			next = iommu_iova_to_phys(domain->domain, iova + len);
 			if (next != phys + len)
 				break;
@@ -1111,16 +1124,18 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
 		 * First, try to use fast unmap/unpin. In case of failure,
 		 * switch to slow unmap/unpin path.
 		 */
-		unmapped = unmap_unpin_fast(domain, dma, &iova, len, phys,
+		unmapped = unmap_unpin_fast(domain, dma, iova, len, phys,
 					    &unlocked, &unmapped_region_list,
 					    &unmapped_region_cnt,
 					    &iotlb_gather);
 		if (!unmapped) {
-			unmapped = unmap_unpin_slow(domain, dma, &iova, len,
+			unmapped = unmap_unpin_slow(domain, dma, iova, len,
 						    phys, &unlocked);
 			if (WARN_ON(!unmapped))
 				break;
 		}
+
+		pos += unmapped;
 	}
 
 	dma->iommu_mapped = false;
@@ -1212,7 +1227,7 @@ static int update_user_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
 }
 
 static int vfio_iova_dirty_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
-				  dma_addr_t iova, size_t size, size_t pgsize)
+				  dma_addr_t iova, u64 end, size_t pgsize)
 {
 	struct vfio_dma *dma;
 	struct rb_node *n;
@@ -1229,8 +1244,8 @@ static int vfio_iova_dirty_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
 	if (dma && dma->iova != iova)
 		return -EINVAL;
 
-	dma = vfio_find_dma(iommu, iova + size - 1, 0);
-	if (dma && dma->iova + dma->size != iova + size)
+	dma = vfio_find_dma(iommu, end, 1);
+	if (dma && dma->iova + dma->size - 1 != end)
 		return -EINVAL;
 
 	for (n = rb_first(&iommu->dma_list); n; n = rb_next(n)) {
@@ -1239,7 +1254,7 @@ static int vfio_iova_dirty_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
 		if (dma->iova < iova)
 			continue;
 
-		if (dma->iova > iova + size - 1)
+		if (dma->iova > end)
 			break;
 
 		ret = update_user_bitmap(bitmap, iommu, dma, iova, pgsize);
@@ -1305,6 +1320,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 	unsigned long pgshift;
 	dma_addr_t iova = unmap->iova;
 	u64 size = unmap->size;
+	u64 unmap_end;
 	bool unmap_all = unmap->flags & VFIO_DMA_UNMAP_FLAG_ALL;
 	bool invalidate_vaddr = unmap->flags & VFIO_DMA_UNMAP_FLAG_VADDR;
 	struct rb_node *n, *first_n;
@@ -1327,11 +1343,13 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 		if (iova || size)
 			goto unlock;
 		size = U64_MAX;
-	} else if (!size || size & (pgsize - 1) ||
-		   iova + size - 1 < iova || size > SIZE_MAX) {
+	} else if (!size || size & (pgsize - 1) || size > SIZE_MAX) {
 		goto unlock;
 	}
 
+	if (check_add_overflow(iova, size - 1, &unmap_end))
+		goto unlock;
+
 	/* When dirty tracking is enabled, allow only min supported pgsize */
 	if ((unmap->flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) &&
 	    (!iommu->dirty_page_tracking || (bitmap->pgsize != pgsize))) {
@@ -1376,8 +1394,8 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 		if (dma && dma->iova != iova)
 			goto unlock;
 
-		dma = vfio_find_dma(iommu, iova + size - 1, 0);
-		if (dma && dma->iova + dma->size != iova + size)
+		dma = vfio_find_dma(iommu, unmap_end, 1);
+		if (dma && dma->iova + dma->size - 1 != unmap_end)
 			goto unlock;
 	}
 
@@ -1386,7 +1404,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 
 	while (n) {
 		dma = rb_entry(n, struct vfio_dma, node);
-		if (dma->iova > iova + size - 1)
+		if (dma->iova > unmap_end)
 			break;
 
 		if (!iommu->v2 && iova > dma->iova)
@@ -1713,12 +1731,12 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
 
 	for (; n; n = rb_next(n)) {
 		struct vfio_dma *dma;
-		dma_addr_t iova;
+		size_t pos = 0;
 
 		dma = rb_entry(n, struct vfio_dma, node);
-		iova = dma->iova;
 
-		while (iova < dma->iova + dma->size) {
+		while (pos < dma->size) {
+			dma_addr_t iova = dma->iova + pos;
 			phys_addr_t phys;
 			size_t size;
 
@@ -1734,14 +1752,15 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
 				phys = iommu_iova_to_phys(d->domain, iova);
 
 				if (WARN_ON(!phys)) {
-					iova += PAGE_SIZE;
+					pos += PAGE_SIZE;
 					continue;
 				}
 
+
 				size = PAGE_SIZE;
 				p = phys + size;
 				i = iova + size;
-				while (i < dma->iova + dma->size &&
+				while (size + pos < dma->size &&
 				       p == iommu_iova_to_phys(d->domain, i)) {
 					size += PAGE_SIZE;
 					p += PAGE_SIZE;
@@ -1782,7 +1801,7 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
 				goto unwind;
 			}
 
-			iova += size;
+			pos += size;
 		}
 	}
 
@@ -1799,29 +1818,29 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
 unwind:
 	for (; n; n = rb_prev(n)) {
 		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
-		dma_addr_t iova;
+		size_t pos = 0;
 
 		if (dma->iommu_mapped) {
 			iommu_unmap(domain->domain, dma->iova, dma->size);
 			continue;
 		}
 
-		iova = dma->iova;
-		while (iova < dma->iova + dma->size) {
+		while (pos < dma->size) {
+			dma_addr_t iova = dma->iova + pos;
 			phys_addr_t phys, p;
 			size_t size;
 			dma_addr_t i;
 
 			phys = iommu_iova_to_phys(domain->domain, iova);
 			if (!phys) {
-				iova += PAGE_SIZE;
+				pos += PAGE_SIZE;
 				continue;
 			}
 
 			size = PAGE_SIZE;
 			p = phys + size;
 			i = iova + size;
-			while (i < dma->iova + dma->size &&
+			while (pos + size < dma->size &&
 			       p == iommu_iova_to_phys(domain->domain, i)) {
 				size += PAGE_SIZE;
 				p += PAGE_SIZE;
@@ -2908,6 +2927,7 @@ static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
 		unsigned long pgshift;
 		size_t data_size = dirty.argsz - minsz;
 		size_t iommu_pgsize;
+		u64 end;
 
 		if (!data_size || data_size < sizeof(range))
 			return -EINVAL;
@@ -2916,8 +2936,12 @@ static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
 				   sizeof(range)))
 			return -EFAULT;
 
-		if (range.iova + range.size < range.iova)
+		if (range.size == 0)
+			return 0;
+
+		if (check_add_overflow(range.iova, range.size - 1, &end))
 			return -EINVAL;
+
 		if (!access_ok((void __user *)range.bitmap.data,
 			       range.bitmap.size))
 			return -EINVAL;
@@ -2949,7 +2973,7 @@ static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
 		if (iommu->dirty_page_tracking)
 			ret = vfio_iova_dirty_bitmap(range.bitmap.data,
 						     iommu, range.iova,
-						     range.size,
+						     end,
 						     range.bitmap.pgsize);
 		else
 			ret = -EINVAL;

