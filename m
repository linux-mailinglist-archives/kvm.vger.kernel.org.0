Return-Path: <kvm+bounces-59863-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 46CA4BD1777
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 07:33:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id BFD1B3450BC
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 05:33:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C3142DC346;
	Mon, 13 Oct 2025 05:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b="GgqCHrje"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D68A2DA750
	for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 05:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760333567; cv=none; b=euikDJ0T+pThw/B+nph750eNM8j0xcIO/Gv7tpmqVCs5dtYR6J7EmEqkYJEnDQFD591Hxp9Aw/kwqNaWMRVwYeFxbO7uep05lUb5Ix8gEJEkCO2v1EwBEMfzYUCDfzGZraLRSUE29rtaOAdjcUpYxk3J10c50kEGJisuxkpgW9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760333567; c=relaxed/simple;
	bh=4hYhb+EPmlaOc3bN+TTQRMFugJwG6oxY36pVB85jVgQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=bR8xVOfDy19MDv4+tceBGim7x24Li0w5OcSzdkrGTf8b9mHPyUd130CutaEPOX0T6icH+ijM7rz1mOsTZABbhb6A1a8lkEEK3e+n0/j3bnMhyyzPpUUK779ss6tEATBSsZJeNt1oGgeLnzM/F6P5BA6gV/54raWHnh29kl/OWv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b=GgqCHrje; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59CMgNrH1450873
	for <kvm@vger.kernel.org>; Sun, 12 Oct 2025 22:32:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=5W/oWlGSgrgcpquGT5WzQZk6fkYCHamp032I6BK5EHA=; b=GgqCHrjeo6Dd
	Cxuia4OULEpPoPjM39fFVIHZaA/PW8whz1mKEqQhh7awmMa0tGvsIhuKPruYJYia
	i1EwkH3FFSUijxwIYgL6/txAJxcdeetzbO0BoI6cJQblQvGlRgOMHUD8YCXkKLS3
	/4oYCtIpoI4cYLuVwt/pl8D4mf53WHTbBdxasTVIx//R9XL9af1+mcmO3rWddRVb
	RkWePLcePeDHGduBLPDqtqN0nRD66MsOGq0E9HFxOOm6oB+yd3NOrp5vmzbS08uq
	IX2TH4aFXP93mDDJPTm+6Lz1J0LiaXwNzfjRGMonOvG84A922+mJLdhQ8hVIcgMG
	faFolgT3Mg==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 49rnbm172b-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Sun, 12 Oct 2025 22:32:44 -0700 (PDT)
Received: from twshared28243.32.prn2.facebook.com (2620:10d:c085:208::7cb7) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Mon, 13 Oct 2025 05:32:44 +0000
Received: by devgpu015.cco6.facebook.com (Postfix, from userid 199522)
	id 9E654102FE49; Sun, 12 Oct 2025 22:32:30 -0700 (PDT)
From: Alex Mastro <amastro@fb.com>
Date: Sun, 12 Oct 2025 22:32:26 -0700
Subject: [PATCH v4 3/3] vfio/type1: handle DMA map/unmap up to the
 addressable limit
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20251012-fix-unmap-v4-3-9eefc90ed14c@fb.com>
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
X-Proofpoint-GUID: 2mUXEKl0dVUIfSfC1uwp41yHa8XndtXt
X-Authority-Analysis: v=2.4 cv=NfjrFmD4 c=1 sm=1 tr=0 ts=68ec8efc cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=FOH2dFAWAAAA:8 a=P34euavMcYKjluB8mAYA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 2mUXEKl0dVUIfSfC1uwp41yHa8XndtXt
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDEzMDAyNiBTYWx0ZWRfX0Hiu6U68LwRm
 N4XkWa0WzxlsViXpzjKFU8RPrJqJr5ziEqeW1901eltWsM4K1o0SWOsdEzB5mc8W0lYIMhZOI4x
 rat+wIlSHTrjo0S1x/kjMuzwNZCXytvGR6ElHfEd/z5rozHtI2RmxJo18F0I9k3lzi0+qy6ij7p
 jaO+DlXTGKYYBrFMwsHl2aUWWbFK0+Zct/0YRdA+iBdHc7kKzUpVNqfoiqzU9xWfFKSdczeiRak
 twKtknAh/NL6S9lI2pInLaxAdGtNBjGkMsRF2wXphH+leja1j7pVh2Jv2r0ye69Yu1D+Fm3rk2A
 g0GT6aLxUVqpNtsboccVGYKjk8ii6XCpYCP0npkGaZSnQFJZm5X7QwVJHJ4Jr5Vqm6YCpr/Rrn0
 tzXxYL6DHd9Fv6YdTcbeQrqNov3T2A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-13_02,2025-10-06_01,2025-03-28_01

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
index 48b84a7af2e1..a65625dcf708 100644
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
@@ -1071,12 +1078,12 @@ static size_t unmap_unpin_slow(struct vfio_domain *domain,
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
@@ -1100,13 +1107,14 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
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
 
@@ -1115,7 +1123,7 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
 		 * may require hardware cache flushing, try to find the
 		 * largest contiguous physical memory chunk to unmap.
 		 */
-		for (len = PAGE_SIZE; iova + len < end; len += PAGE_SIZE) {
+		for (len = PAGE_SIZE; pos + len < dma->size; len += PAGE_SIZE) {
 			next = iommu_iova_to_phys(domain->domain, iova + len);
 			if (next != phys + len)
 				break;
@@ -1136,7 +1144,7 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
 				break;
 		}
 
-		iova += unmapped;
+		pos += unmapped;
 	}
 
 	dma->iommu_mapped = false;
@@ -1228,7 +1236,7 @@ static int update_user_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
 }
 
 static int vfio_iova_dirty_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
-				  dma_addr_t iova, size_t size, size_t pgsize)
+				  dma_addr_t iova, dma_addr_t iova_end, size_t pgsize)
 {
 	struct vfio_dma *dma;
 	struct rb_node *n;
@@ -1245,8 +1253,8 @@ static int vfio_iova_dirty_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
 	if (dma && dma->iova != iova)
 		return -EINVAL;
 
-	dma = vfio_find_dma(iommu, iova + size - 1, 0);
-	if (dma && dma->iova + dma->size != iova + size)
+	dma = vfio_find_dma(iommu, iova_end, 1);
+	if (dma && dma->iova + dma->size - 1 != iova_end)
 		return -EINVAL;
 
 	for (n = rb_first(&iommu->dma_list); n; n = rb_next(n)) {
@@ -1255,7 +1263,7 @@ static int vfio_iova_dirty_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
 		if (dma->iova < iova)
 			continue;
 
-		if (dma->iova > iova + size - 1)
+		if (dma->iova > iova_end)
 			break;
 
 		ret = update_user_bitmap(bitmap, iommu, dma, iova, pgsize);
@@ -1348,7 +1356,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 	if (unmap_all) {
 		if (iova || size)
 			goto unlock;
-		size = SIZE_MAX;
+		iova_end = ~(dma_addr_t)0;
 	} else {
 		if (!size || size & (pgsize - 1))
 			goto unlock;
@@ -1403,17 +1411,17 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
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
@@ -1743,12 +1751,12 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
 
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
 
@@ -1764,14 +1772,14 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
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
@@ -1779,9 +1787,8 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
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
@@ -1812,7 +1819,7 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
 				goto unwind;
 			}
 
-			iova += size;
+			pos += size;
 		}
 	}
 
@@ -1829,29 +1836,29 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
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
@@ -2989,7 +2996,7 @@ static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
 
 		if (iommu->dirty_page_tracking)
 			ret = vfio_iova_dirty_bitmap(range.bitmap.data,
-						     iommu, iova, size,
+						     iommu, iova, iova_end,
 						     range.bitmap.pgsize);
 		else
 			ret = -EINVAL;

-- 
2.47.3


