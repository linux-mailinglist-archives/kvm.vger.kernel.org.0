Return-Path: <kvm+bounces-61205-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id B5A2AC0FAF3
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 18:34:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id AF0FE4ED835
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 17:34:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66813319843;
	Mon, 27 Oct 2025 17:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b="7Pzu/Moe"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC5F31815D
	for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 17:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761586447; cv=none; b=d0Ypxc9DUz2Hoe3gDB0ZQdcw6Vmjm2UKEAKqih7ftVxIe9HdS+zL/5M4b+z9FMCKCf3fZrdEIwTJJuLQ2tDPasXbsx7/qLlQ2zJ5kZ7nYsc78PePybqTzlh9e6wNiETV1eHS04sNSblgD41wAMEH/ZgMoVWQtYIvsnKwExdvfWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761586447; c=relaxed/simple;
	bh=fsUficWSSEw++WUiZPDFihQGx2cEpjBhzsmEvpxHOpY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=Cc5YVRIurlgjAIUk5QIeFCv4urPyURXK0esZbK1KYem7QHZWanhR0vDgKcW91l0qgUeaHbEBUcEo17RuT4ScyU9VRSOxujK7Z0Vk+HkhnZD0cdyVSaaghoA7wKhQtd4JgLn3CT0oVMS/Zkrt0YtotiTPZeZCa2N/gpv5J188/Vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b=7Pzu/Moe; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59RF6vYu975897
	for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 10:34:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=17DrIKvHY+S2FDBbrn4h28hnqtK9RN4gXAhW5actuwA=; b=7Pzu/MoeiXGS
	yCt2LxAVBFstfR4JIJQmKCnHhSqyO2M6F3+P+l9kspcA03pE42L2wppbtw3rKf3v
	tKKodZE+Id7mZA5JU2Xd0gl3ck0v/V3dqvd4zsuMTeowhrL+LFoBFsw6OqQDodCC
	KC7OmGpewUNSyERbBW6ICu7HUbMZXM3RIxXYzRkTjBOfiSsQ8lXU7u/CtERSuNAb
	iCne7g2+NTHQrPr/K4ACXsZos2KUVaJ8159W2oNL4cqjfaj4/+CFfkDnZrrnNG8U
	AT3URQ/b6Ymj3rcvsxLNHtKwlNNRwG/2vNW0UnRea3KgUSp4MSgRwRbu3HsVllVR
	7vrWMxRXvQ==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4a2b3j9dfc-11
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 10:34:04 -0700 (PDT)
Received: from twshared28390.17.frc2.facebook.com (2620:10d:c0a8:1b::8e35) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Mon, 27 Oct 2025 17:34:03 +0000
Received: by devgpu012.nha5.facebook.com (Postfix, from userid 28580)
	id 7E05743E098; Mon, 27 Oct 2025 10:33:57 -0700 (PDT)
From: Alex Mastro <amastro@fb.com>
Date: Mon, 27 Oct 2025 10:33:43 -0700
Subject: [PATCH v5 3/5] vfio/type1: handle DMA map/unmap up to the
 addressable limit
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20251027-fix-unmap-v5-3-4f0fcf8ffb7d@fb.com>
References: <20251027-fix-unmap-v5-0-4f0fcf8ffb7d@fb.com>
In-Reply-To: <20251027-fix-unmap-v5-0-4f0fcf8ffb7d@fb.com>
To: Alex Williamson <alex@shazbot.org>
CC: Jason Gunthorpe <jgg@ziepe.ca>,
        Alejandro Jimenez
	<alejandro.j.jimenez@oracle.com>,
        David Matlack <dmatlack@google.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Alex Mastro
	<amastro@fb.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
X-Mailer: b4 0.13.0
X-FB-Internal: Safe
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI3MDE2MyBTYWx0ZWRfX+AoJ/ZuwhS7O
 Tt2n+Potjsnc0sV6SKZwWRlo4PPzN1uTy4PIOmniiH4sDqtJPn1TEJG5/mm7caGLh3xX8XOWZrK
 7DBirEdbfKA5orUqWn545xpP2rLJssgOZB7poCC0B8u3LOyGSimSDdNKTbLxh6NUxyLcvRmBU+C
 u/w7NvuuxIdKwAqkIE6+iY4oqy5RkGYH4bkl2r0YXL7jFLxMXQVubqKBaKV7z04VJ5gssB06q8g
 TE7what0EF3dk109vzGjz73FR2koBFg/VN7bP22L1LAMUX6JX9CyFQQ9GWELHX7nCqj6GLV+5fh
 KuVPHnn+EyDVdxohuu91/rDeUB6kxJGY1kpV5w7SyeoArlhFeCv9aa6vo4x7tj3Llg8hG8bLwVi
 0Y4b0mziW+IA2nMPfEr9TpYoihAIug==
X-Authority-Analysis: v=2.4 cv=H87WAuYi c=1 sm=1 tr=0 ts=68ffad0c cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=Ikd4Dj_1AAAA:8 a=FOH2dFAWAAAA:8 a=8P58oYQow4jR27pd84AA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 9QDnvGqSFeYXbbLOe-DFR_hxkBsslGi3
X-Proofpoint-GUID: 9QDnvGqSFeYXbbLOe-DFR_hxkBsslGi3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-27_07,2025-10-22_01,2025-03-28_01

Before this commit, it was possible to create end of address space
mappings, but unmapping them via VFIO_IOMMU_UNMAP_DMA, replaying them
for newly added iommu domains, and querying their dirty pages via
VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP was broken due to bugs caused by
comparisons against (iova + size) expressions, which overflow to zero.

This commit handles DMA map/unmap operations up to the addressable
limit by comparing against inclusive end-of-range limits, and changing
iteration to perform relative traversals across range sizes, rather than
absolute traversals across addresses.

vfio_link_dma inserts a zero-sized vfio_dma into the rb-tree, and is
only used for that purpose, so discard the size from consideration for
the insertion point.

Tested-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Fixes: 73fa0d10d077 ("vfio: Type1 IOMMU implementation")
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Signed-off-by: Alex Mastro <amastro@fb.com>
---
 drivers/vfio/vfio_iommu_type1.c | 77 ++++++++++++++++++++++-------------------
 1 file changed, 42 insertions(+), 35 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 48bcc0633d44..5167bec14e36 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -168,12 +168,14 @@ static struct vfio_dma *vfio_find_dma(struct vfio_iommu *iommu,
 {
 	struct rb_node *node = iommu->dma_list.rb_node;
 
+	WARN_ON(!size);
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
@@ -183,16 +185,19 @@ static struct vfio_dma *vfio_find_dma(struct vfio_iommu *iommu,
 }
 
 static struct rb_node *vfio_find_dma_first_node(struct vfio_iommu *iommu,
-						dma_addr_t start, size_t size)
+						dma_addr_t start,
+						dma_addr_t end)
 {
 	struct rb_node *res = NULL;
 	struct rb_node *node = iommu->dma_list.rb_node;
 	struct vfio_dma *dma_res = NULL;
 
+	WARN_ON(end < start);
+
 	while (node) {
 		struct vfio_dma *dma = rb_entry(node, struct vfio_dma, node);
 
-		if (start < dma->iova + dma->size) {
+		if (start <= dma->iova + dma->size - 1) {
 			res = node;
 			dma_res = dma;
 			if (start >= dma->iova)
@@ -202,7 +207,7 @@ static struct rb_node *vfio_find_dma_first_node(struct vfio_iommu *iommu,
 			node = node->rb_right;
 		}
 	}
-	if (res && size && dma_res->iova >= start + size)
+	if (res && dma_res->iova > end)
 		res = NULL;
 	return res;
 }
@@ -212,11 +217,13 @@ static void vfio_link_dma(struct vfio_iommu *iommu, struct vfio_dma *new)
 	struct rb_node **link = &iommu->dma_list.rb_node, *parent = NULL;
 	struct vfio_dma *dma;
 
+	WARN_ON(new->size != 0);
+
 	while (*link) {
 		parent = *link;
 		dma = rb_entry(parent, struct vfio_dma, node);
 
-		if (new->iova + new->size <= dma->iova)
+		if (new->iova <= dma->iova)
 			link = &(*link)->rb_left;
 		else
 			link = &(*link)->rb_right;
@@ -1141,12 +1148,12 @@ static size_t unmap_unpin_slow(struct vfio_domain *domain,
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
@@ -1170,13 +1177,14 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
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
 
@@ -1185,7 +1193,7 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
 		 * may require hardware cache flushing, try to find the
 		 * largest contiguous physical memory chunk to unmap.
 		 */
-		for (len = PAGE_SIZE; iova + len < end; len += PAGE_SIZE) {
+		for (len = PAGE_SIZE; pos + len < dma->size; len += PAGE_SIZE) {
 			next = iommu_iova_to_phys(domain->domain, iova + len);
 			if (next != phys + len)
 				break;
@@ -1206,7 +1214,7 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
 				break;
 		}
 
-		iova += unmapped;
+		pos += unmapped;
 	}
 
 	dma->iommu_mapped = false;
@@ -1298,7 +1306,7 @@ static int update_user_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
 }
 
 static int vfio_iova_dirty_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
-				  dma_addr_t iova, size_t size, size_t pgsize)
+				  dma_addr_t iova, dma_addr_t iova_end, size_t pgsize)
 {
 	struct vfio_dma *dma;
 	struct rb_node *n;
@@ -1315,8 +1323,8 @@ static int vfio_iova_dirty_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
 	if (dma && dma->iova != iova)
 		return -EINVAL;
 
-	dma = vfio_find_dma(iommu, iova + size - 1, 0);
-	if (dma && dma->iova + dma->size != iova + size)
+	dma = vfio_find_dma(iommu, iova_end, 1);
+	if (dma && dma->iova + dma->size - 1 != iova_end)
 		return -EINVAL;
 
 	for (n = rb_first(&iommu->dma_list); n; n = rb_next(n)) {
@@ -1325,7 +1333,7 @@ static int vfio_iova_dirty_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
 		if (dma->iova < iova)
 			continue;
 
-		if (dma->iova > iova + size - 1)
+		if (dma->iova > iova_end)
 			break;
 
 		ret = update_user_bitmap(bitmap, iommu, dma, iova, pgsize);
@@ -1418,7 +1426,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 	if (unmap_all) {
 		if (iova || size)
 			goto unlock;
-		size = SIZE_MAX;
+		iova_end = ~(dma_addr_t)0;
 	} else {
 		if (!size || size & (pgsize - 1))
 			goto unlock;
@@ -1473,17 +1481,17 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 		if (dma && dma->iova != iova)
 			goto unlock;
 
-		dma = vfio_find_dma(iommu, iova_end, 0);
-		if (dma && dma->iova + dma->size != iova + size)
+		dma = vfio_find_dma(iommu, iova_end, 1);
+		if (dma && dma->iova + dma->size - 1 != iova_end)
 			goto unlock;
 	}
 
 	ret = 0;
-	n = first_n = vfio_find_dma_first_node(iommu, iova, size);
+	n = first_n = vfio_find_dma_first_node(iommu, iova, iova_end);
 
 	while (n) {
 		dma = rb_entry(n, struct vfio_dma, node);
-		if (dma->iova >= iova + size)
+		if (dma->iova > iova_end)
 			break;
 
 		if (!iommu->v2 && iova > dma->iova)
@@ -1813,12 +1821,12 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
 
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
 
@@ -1834,14 +1842,14 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
 				phys = iommu_iova_to_phys(d->domain, iova);
 
 				if (WARN_ON(!phys)) {
-					iova += PAGE_SIZE;
+					pos += PAGE_SIZE;
 					continue;
 				}
 
 				size = PAGE_SIZE;
 				p = phys + size;
 				i = iova + size;
-				while (i < dma->iova + dma->size &&
+				while (pos + size < dma->size &&
 				       p == iommu_iova_to_phys(d->domain, i)) {
 					size += PAGE_SIZE;
 					p += PAGE_SIZE;
@@ -1849,9 +1857,8 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
 				}
 			} else {
 				unsigned long pfn;
-				unsigned long vaddr = dma->vaddr +
-						     (iova - dma->iova);
-				size_t n = dma->iova + dma->size - iova;
+				unsigned long vaddr = dma->vaddr + pos;
+				size_t n = dma->size - pos;
 				long npage;
 
 				npage = vfio_pin_pages_remote(dma, vaddr,
@@ -1882,7 +1889,7 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
 				goto unwind;
 			}
 
-			iova += size;
+			pos += size;
 		}
 	}
 
@@ -1899,29 +1906,29 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
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
@@ -3059,7 +3066,7 @@ static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
 
 		if (iommu->dirty_page_tracking)
 			ret = vfio_iova_dirty_bitmap(range.bitmap.data,
-						     iommu, iova, size,
+						     iommu, iova, iova_end,
 						     range.bitmap.pgsize);
 		else
 			ret = -EINVAL;

-- 
2.47.3


