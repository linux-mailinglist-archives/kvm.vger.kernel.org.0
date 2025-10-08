Return-Path: <kvm+bounces-59625-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 41E5CBC346F
	for <lists+kvm@lfdr.de>; Wed, 08 Oct 2025 06:10:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id BC12C34DA5E
	for <lists+kvm@lfdr.de>; Wed,  8 Oct 2025 04:10:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25AFF2BE7C2;
	Wed,  8 Oct 2025 04:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b="Z00LVryI"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA852BE65E
	for <kvm@vger.kernel.org>; Wed,  8 Oct 2025 04:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759896577; cv=none; b=ek+YrH+q5yw6kGNtu9gx8wgA5rMiJTbdR3yO5IHW2MEZpUtlcmX6bXiK/ZLDNDyvyxhBr1WQQ7UiHfWzM5yFaZxhiVF+kXy+Uwoka8k2+CdiME15hSudabKnyf45gF5S9MkIVOmQRFg1Az4gNAiYUZ3ldznMDlpnAS91/weTV64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759896577; c=relaxed/simple;
	bh=+2r3aolF8oHS3ozQGgTTzrAvpqn+VbWDh4dAMQglIgE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=GDnsQPJauBc/W4ED9GOIhLNQWTq6oIvQPufOO8rJf7NIyXE9pgMXpdZ7DonUuNe3k5SZ2kmznydVIwnZJfzudBR4frDK0PbMxVU5yfNwS2iVoNXh3Uf5AAHfhTt28uJ32m+p6zz5o7XgbJn5wS2bkAq+s/m1N9taO+PdypIVC3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b=Z00LVryI; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5982rAJR2065805
	for <kvm@vger.kernel.org>; Tue, 7 Oct 2025 21:09:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=rZ+bhDDbOAqkVzre+Zt7TEGFheBx2O8g8tJrdNoweQ0=; b=Z00LVryIE1qM
	EXwR1YULXezuO+uQXY1JISsmAYLzsJzS0alOKf4LCvXvVKq9H8e90MlQf5HAIfov
	kKKkF3cB77RSV6rM4qUojBdGI8upfIZwl9zNaGZ5Lnf0jLfxytjca9vzmzG1Y8G+
	NzxXSm77oI91fqarMmO69tPebI6GMsI04riOYlMWgPjkZe3sgda3d5yS5RHWKkGc
	4vnLAeBIZkNjPI00S4VsMfSGevTCn7HcW3qXPz/5g4+wI2VCo+26p4xMJwWJkeF0
	GX13/2ZxkZpITogSOe+p7UA7DDqIZTZnXSzCmBTVEt5tdg4c1BZbRBhKKPiR4VRV
	17btT4nUkw==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 49n7jxuhyy-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Tue, 07 Oct 2025 21:09:34 -0700 (PDT)
Received: from twshared23637.05.prn5.facebook.com (2620:10d:c0a8:1b::8e35) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Wed, 8 Oct 2025 04:09:31 +0000
Received: by devgpu015.cco6.facebook.com (Postfix, from userid 199522)
	id B1BF6D26CD0; Tue,  7 Oct 2025 21:09:19 -0700 (PDT)
From: Alex Mastro <amastro@fb.com>
Date: Tue, 7 Oct 2025 21:08:48 -0700
Subject: [PATCH v2 3/3] vfio/type1: handle DMA map/unmap up to the
 addressable limit
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20251007-fix-unmap-v2-3-759bceb9792e@fb.com>
References: <20251007-fix-unmap-v2-0-759bceb9792e@fb.com>
In-Reply-To: <20251007-fix-unmap-v2-0-759bceb9792e@fb.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: Jason Gunthorpe <jgg@ziepe.ca>,
        Alejandro Jimenez
	<alejandro.j.jimenez@oracle.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Alex Mastro <amastro@fb.com>
X-Mailer: b4 0.13.0
X-FB-Internal: Safe
X-Proofpoint-GUID: kRpEG-gQZdBUZpsVbwDcFGDb_XdRwqjs
X-Proofpoint-ORIG-GUID: kRpEG-gQZdBUZpsVbwDcFGDb_XdRwqjs
X-Authority-Analysis: v=2.4 cv=LJdrgZW9 c=1 sm=1 tr=0 ts=68e5e3fe cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=FOH2dFAWAAAA:8 a=P34euavMcYKjluB8mAYA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA4MDAyNCBTYWx0ZWRfX9VmKOjuFc80r
 vimJE5qzt7awcZZ7Lyp2/Jrr6jqJR7tFLRBQQFTwfPFYJWpt9noe/g6dCq62IyciIetDWJIxT8x
 uVLs/hjl6vjcXgikafqAJe8EZdQwQLKQGiHVg2GCI8fpkTN/puhgBN8HEMbbANI4tncZ5aRLTRx
 uO7dpwh8vtjRYUZaR6zpBiRT8NyZLOsjluuebRM47OcWeOvX68AB8USWbg5maYThlKumEtPrwTS
 3NjDUH909A4gln2LwQHVtUxW6Gh+F8m6XL03doAcU2v5po0+7+LAoV+kJQ+UwVJYM4XjZnoxAA6
 LpV+iBBvJteMCWVRoRZWXUihK0n/19jJZW59kveghoN9YUHmfNta7FUfMjfz92kjCbxRTmRuD8p
 LfXavlh37n3Ir0bKdvDFdVGfCXdvAw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-07_02,2025-10-06_01,2025-03-28_01

Handle DMA map/unmap operations up to the addressable limit by comparing
against inclusive end-of-range limits, and changing iteration to
perform relative traversals across range sizes, rather than absolute
traversals across addresses.

vfio_link_dma inserts a zero-sized vfio_dma into the rb-tree, and is
only used for that purpose, so discard the size from consideration for
the insertion point.

Signed-off-by: Alex Mastro <amastro@fb.com>
---
 drivers/vfio/vfio_iommu_type1.c | 75 ++++++++++++++++++++++-------------------
 1 file changed, 41 insertions(+), 34 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index f6ba2f8b1dd8..d0eec4b39d40 100644
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
@@ -1401,17 +1409,17 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
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
@@ -1740,12 +1748,12 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
 
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
 
@@ -1761,14 +1769,14 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
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
@@ -1776,9 +1784,8 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
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
@@ -1809,7 +1816,7 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
 				goto unwind;
 			}
 
-			iova += size;
+			pos += size;
 		}
 	}
 
@@ -1826,29 +1833,29 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
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
@@ -2981,7 +2988,7 @@ static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
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


