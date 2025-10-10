Return-Path: <kvm+bounces-59763-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 4ED4FBCBF38
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 09:40:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 05B0C4FD0B2
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 07:39:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35A90278753;
	Fri, 10 Oct 2025 07:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b="iE3YKsRb"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5845F275870
	for <kvm@vger.kernel.org>; Fri, 10 Oct 2025 07:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760081928; cv=none; b=W6ApOzRhvqGSQkw0qPwXszM2VwobBpufLKaKQUR+GgAOwPlJudMG6o80oaWQdACsmuXuvpG8qM6oBFPTLf7vXuI/CisBtdV56S8/N2t6ZxelQwC+VChzLYqnOsojWjGQfVYT7Msq1ukY/UytOd+nDaZJugFhcvtbcJmg/0ZBeR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760081928; c=relaxed/simple;
	bh=S+pHiYIHaGw+CvQLU0K5VOk+9NWEeMXMFCmBxYIMrCQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=JNiRLJjsTzXtvdVJZr9EQSeak4QKg7S/I3laXtSZOOvnZKacUNX//wZp1McpjrgVJyPfKGSOIxUvwZ6vP5tuhsBGIRUjI4S3L8z2YIFgU2/NYKtRgrsKEogUpjtssYMHoS8je0gNqlvNqzGMWNozlnng9p2kIJEruMsPK81qH1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b=iE3YKsRb; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 599KUNpp1851787
	for <kvm@vger.kernel.org>; Fri, 10 Oct 2025 00:38:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=IOSbF+UJ+T1DnDZXSj4ONs9KyACoP34rO8u6Ro8Ak0g=; b=iE3YKsRbz09J
	FP3Wuv+DATzNiHpm/M6kOgICPOIehcFCqY1GcYKekIbPWgBJvRA7CP4/GjLRWls6
	PQZVeoe6jNEwplVYNL2f7Ghdcbo8qPZLQwaAU53LWbdVdot1WUPLuBIUggPcPP3B
	ivpv5ImaogEs9sXm3bHv6x3aIY1xH6DDxE3Yuhgi8lFt24QsUmFu7JJfY9RsTBoT
	9fnRh7nTticdwBQHE+hsTnzsyOZzUQBhNf1BwJklvhIhZ9zJkkkwZiipO7vBBjSk
	08fMugkhDye3hu0tT/PpxhoGFOJo+tonSkDXZBLMgw5WzhHM5DT/pimNxlsAH1fC
	t38mIzmPzA==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 49pkcqwfnp-12
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Fri, 10 Oct 2025 00:38:44 -0700 (PDT)
Received: from twshared23637.05.prn5.facebook.com (2620:10d:c085:108::150d) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Fri, 10 Oct 2025 07:38:41 +0000
Received: by devgpu015.cco6.facebook.com (Postfix, from userid 199522)
	id 45172E937D8; Fri, 10 Oct 2025 00:38:40 -0700 (PDT)
From: Alex Mastro <amastro@fb.com>
Date: Fri, 10 Oct 2025 00:38:41 -0700
Subject: [PATCH v3 3/3] vfio/type1: handle DMA map/unmap up to the
 addressable limit
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20251010-fix-unmap-v3-3-306c724d6998@fb.com>
References: <20251010-fix-unmap-v3-0-306c724d6998@fb.com>
In-Reply-To: <20251010-fix-unmap-v3-0-306c724d6998@fb.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: Jason Gunthorpe <jgg@ziepe.ca>,
        Alejandro Jimenez
	<alejandro.j.jimenez@oracle.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Alex Mastro <amastro@fb.com>
X-Mailer: b4 0.13.0
X-FB-Internal: Safe
X-Authority-Analysis: v=2.4 cv=KNBXzVFo c=1 sm=1 tr=0 ts=68e8b804 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=FOH2dFAWAAAA:8 a=P34euavMcYKjluB8mAYA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: rF11EwlUxZZWNNTvJQ9pvlm8duAIWIwF
X-Proofpoint-ORIG-GUID: rF11EwlUxZZWNNTvJQ9pvlm8duAIWIwF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDEwMDA0MyBTYWx0ZWRfX8OSWJByx3KCT
 wlj5dJ2uPubdlTWciE3nKztv/erOQ3uWs/236HJFPaHmsDLvOjGwDurZkJzL6KjMHAm7kJOGMxv
 hNO9+4CcmS9JoHSmO0G7L9NZ+mJabBwRETTeJJ4QnHKD83G9LT+BTJT7KeWDrYmlzeIL+Kx/Lty
 SP8NtUT+US7jQ4GsOiNLBsbG99O7wRcVKsJ/Qk8Un9pKmP7cAjt/Etpxth5SPXH1G/vEPuhl1vJ
 8+HZSt6eu51p6V4LHwFtr59c52iU6JY7LeVsNovsEW5Uw3rjJm7u2vIuskz7tvaRTif5SCFoc9i
 +tghMT63s2oowK9GpVpE3gU0QnqbHtSxUqyCVCdy3okb9Szb7dq6AL3FFCxrwXoQCuBBD3bO8eG
 UOn8LfilmPV5vB8k4pegVmkYukcsFQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-10_01,2025-10-06_01,2025-03-28_01

Handle DMA map/unmap operations up to the addressable limit by comparing
against inclusive end-of-range limits, and changing iteration to
perform relative traversals across range sizes, rather than absolute
traversals across addresses.

vfio_link_dma inserts a zero-sized vfio_dma into the rb-tree, and is
only used for that purpose, so discard the size from consideration for
the insertion point.

Signed-off-by: Alex Mastro <amastro@fb.com>
---
 drivers/vfio/vfio_iommu_type1.c | 77 ++++++++++++++++++++++-------------------
 1 file changed, 42 insertions(+), 35 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 15aab95d9b8d..567cbab8dfd3 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -166,12 +166,14 @@ static struct vfio_dma *vfio_find_dma(struct vfio_iommu *iommu,
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
@@ -181,16 +183,19 @@ static struct vfio_dma *vfio_find_dma(struct vfio_iommu *iommu,
 }
 
 static struct rb_node *vfio_find_dma_first_node(struct vfio_iommu *iommu,
-						dma_addr_t start, u64 size)
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
@@ -200,7 +205,7 @@ static struct rb_node *vfio_find_dma_first_node(struct vfio_iommu *iommu,
 			node = node->rb_right;
 		}
 	}
-	if (res && size && dma_res->iova >= start + size)
+	if (res && dma_res->iova > end)
 		res = NULL;
 	return res;
 }
@@ -210,11 +215,13 @@ static void vfio_link_dma(struct vfio_iommu *iommu, struct vfio_dma *new)
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
@@ -1078,12 +1085,12 @@ static size_t unmap_unpin_slow(struct vfio_domain *domain,
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
@@ -1107,13 +1114,14 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
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
 
@@ -1122,7 +1130,7 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
 		 * may require hardware cache flushing, try to find the
 		 * largest contiguous physical memory chunk to unmap.
 		 */
-		for (len = PAGE_SIZE; iova + len < end; len += PAGE_SIZE) {
+		for (len = PAGE_SIZE; pos + len < dma->size; len += PAGE_SIZE) {
 			next = iommu_iova_to_phys(domain->domain, iova + len);
 			if (next != phys + len)
 				break;
@@ -1143,7 +1151,7 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
 				break;
 		}
 
-		iova += unmapped;
+		pos += unmapped;
 	}
 
 	dma->iommu_mapped = false;
@@ -1235,7 +1243,7 @@ static int update_user_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
 }
 
 static int vfio_iova_dirty_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
-				  dma_addr_t iova, size_t size, size_t pgsize)
+				  dma_addr_t iova, dma_addr_t iova_end, size_t pgsize)
 {
 	struct vfio_dma *dma;
 	struct rb_node *n;
@@ -1252,8 +1260,8 @@ static int vfio_iova_dirty_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
 	if (dma && dma->iova != iova)
 		return -EINVAL;
 
-	dma = vfio_find_dma(iommu, iova + size - 1, 0);
-	if (dma && dma->iova + dma->size != iova + size)
+	dma = vfio_find_dma(iommu, iova_end, 1);
+	if (dma && dma->iova + dma->size - 1 != iova_end)
 		return -EINVAL;
 
 	for (n = rb_first(&iommu->dma_list); n; n = rb_next(n)) {
@@ -1262,7 +1270,7 @@ static int vfio_iova_dirty_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
 		if (dma->iova < iova)
 			continue;
 
-		if (dma->iova > iova + size - 1)
+		if (dma->iova > iova_end)
 			break;
 
 		ret = update_user_bitmap(bitmap, iommu, dma, iova, pgsize);
@@ -1350,7 +1358,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 	if (unmap_all) {
 		if (iova || size)
 			goto unlock;
-		size = U64_MAX;
+		iova_end = U64_MAX;
 	} else {
 		if (!size || size & (pgsize - 1) || size > SIZE_MAX)
 			goto unlock;
@@ -1405,17 +1413,17 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
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
@@ -1747,12 +1755,12 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
 
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
 
@@ -1768,14 +1776,14 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
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
@@ -1783,9 +1791,8 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
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
@@ -1816,7 +1823,7 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
 				goto unwind;
 			}
 
-			iova += size;
+			pos += size;
 		}
 	}
 
@@ -1833,29 +1840,29 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
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
@@ -2988,7 +2995,7 @@ static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
 		if (iommu->dirty_page_tracking)
 			ret = vfio_iova_dirty_bitmap(range.bitmap.data,
 						     iommu, range.iova,
-						     range.size,
+						     range_end,
 						     range.bitmap.pgsize);
 		else
 			ret = -EINVAL;

-- 
2.47.3


