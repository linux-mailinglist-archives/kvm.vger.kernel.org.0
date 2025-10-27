Return-Path: <kvm+bounces-61203-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A1F9AC0FAEA
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 18:34:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 21740428473
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 17:34:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 290B0317712;
	Mon, 27 Oct 2025 17:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b="u2e13J/1"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9765D2E1F08
	for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 17:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761586444; cv=none; b=RBHODYCpI7KuRmZwVZinSDcIo1OlOHjcqknAgxXpY257OpKLPVAy8WyAu88GtWDe7CokSw/WMMcazIDHydcZI3tdAuQ/IEIsf/kQYcXNGkFzAOEfV+Xvtj74xF1jlH3LX6Xa9wwoWVf2stscrUnkrhnvDa3HiDLyOZjtTxiMWfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761586444; c=relaxed/simple;
	bh=Vc/SsYshYgWtGiWBSl00U/cMRy3jFTCaFrXnvpawQLA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=GDfgp5E+/EzX4vEgFHjBzZjotCJw1oip80ylqRVAPb1rbOaL6KyLjh276t3yaM4Fuz4HbnJ8p9LXrL/Du9XpKUiEilyrn3ENIap+RPVo6/kdYeFmfwMYPF4Kfd9MwxJhpj+17ljFHIQ4pZ10bi/YUD8jpie+TuY59hpxYDTHr1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b=u2e13J/1; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59RF6vYm975897
	for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 10:34:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=OzYCMuVBq+ZQIkmYYGsKvAwvz51TdK3SjEwPx+hEItc=; b=u2e13J/17QEg
	aN6a6/gpIHsiTEC+QcqjSkdHyF2NfGTdRTb62cM8KrgGTcXBmTfK7hHKrMjxDcfq
	TG42INUWqeSOUtzfmDXwTsldt0kwKyQYU4O5bClr2mp1pWhwrgTdf4ZmsMEh6K3m
	ev7vJ5V/9AxME5ii+urT3cAdn7bzZP8VtMUYkyQMk7k0wcQtJXDqnJyIsVokBVx2
	DkVVTWJ66aNhUd+brRFtWv7pUbhlNDb0PPEqMiHF7r/zanzqFqy6cmkTCGQNpbg5
	geYf/LrSDgWvL5QrrDXXujZ0sc/s/sO2MJp13FYw1eOU2ni17v+VNOP2moJlKGlG
	8fzNNAzSzA==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4a2b3j9dfc-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 10:34:01 -0700 (PDT)
Received: from twshared13080.31.frc3.facebook.com (2620:10d:c0a8:1c::1b) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Mon, 27 Oct 2025 17:33:59 +0000
Received: by devgpu012.nha5.facebook.com (Postfix, from userid 28580)
	id 7A56343E094; Mon, 27 Oct 2025 10:33:57 -0700 (PDT)
From: Alex Mastro <amastro@fb.com>
Date: Mon, 27 Oct 2025 10:33:41 -0700
Subject: [PATCH v5 1/5] vfio/type1: sanitize for overflow using
 check_*_overflow
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20251027-fix-unmap-v5-1-4f0fcf8ffb7d@fb.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI3MDE2MyBTYWx0ZWRfX2OYg3l+CjuSl
 vAh201c7evX/Tb7DCiNvIQvmQYHcyJdmTZ157xutzo6HL1wS9MK4xuFxTI9+0Y+gD/uhQ3GQGV3
 br2rtsJpQgP8cjaA1CDrtj3f7RfNQNuA1Q/+EX7b8cCtfQVUVGoOskJKb04h8i+sdbacVN3fD/X
 P0eXViDxxrU2Tkn3fDA3BEpgL2GZ+yWU2Dt2wmUoe7BMFPKbSLA5PaTwQjpFBqLB4aC5R8tRP7m
 zkW6AxfIn/1CUw8/GPJ7MTdSSJuse9dqo2VPGz59OtZo3DgjdNjJ5EZb/CYjr6yTfDmigx4hz+3
 hxRMa0ofWvLyBRLY3mn6szYn9hN1DPO/rEZK1UjhcRtsxzceLouwq0OzPZsbkAqowUi4TF+qyw1
 LRZhjW640M0hEmr2U9ue31NYPycf5Q==
X-Authority-Analysis: v=2.4 cv=H87WAuYi c=1 sm=1 tr=0 ts=68ffad09 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=Ikd4Dj_1AAAA:8 a=FOH2dFAWAAAA:8 a=kyqc8lFLhbGN_ZoCeBMA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: IIht5etzLH6SVz3QDZcq8d_WyBKgXVGh
X-Proofpoint-GUID: IIht5etzLH6SVz3QDZcq8d_WyBKgXVGh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-27_07,2025-10-22_01,2025-03-28_01

Adopt check_*_overflow functions to clearly express overflow check
intent.

Tested-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Fixes: 73fa0d10d077 ("vfio: Type1 IOMMU implementation")
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Signed-off-by: Alex Mastro <amastro@fb.com>
---
 drivers/vfio/vfio_iommu_type1.c | 86 ++++++++++++++++++++++++++++++-----------
 1 file changed, 63 insertions(+), 23 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 916cad80941c..91b1480b7a37 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -38,6 +38,7 @@
 #include <linux/workqueue.h>
 #include <linux/notifier.h>
 #include <linux/mm_inline.h>
+#include <linux/overflow.h>
 #include "vfio.h"
 
 #define DRIVER_VERSION  "0.2"
@@ -182,7 +183,7 @@ static struct vfio_dma *vfio_find_dma(struct vfio_iommu *iommu,
 }
 
 static struct rb_node *vfio_find_dma_first_node(struct vfio_iommu *iommu,
-						dma_addr_t start, u64 size)
+						dma_addr_t start, size_t size)
 {
 	struct rb_node *res = NULL;
 	struct rb_node *node = iommu->dma_list.rb_node;
@@ -895,14 +896,20 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
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
@@ -1008,12 +1015,21 @@ static void vfio_iommu_type1_unpin_pages(void *iommu_data,
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
@@ -1374,7 +1390,8 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 	int ret = -EINVAL, retries = 0;
 	unsigned long pgshift;
 	dma_addr_t iova = unmap->iova;
-	u64 size = unmap->size;
+	dma_addr_t iova_end;
+	size_t size = unmap->size;
 	bool unmap_all = unmap->flags & VFIO_DMA_UNMAP_FLAG_ALL;
 	bool invalidate_vaddr = unmap->flags & VFIO_DMA_UNMAP_FLAG_VADDR;
 	struct rb_node *n, *first_n;
@@ -1387,6 +1404,11 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 		goto unlock;
 	}
 
+	if (iova != unmap->iova || size != unmap->size) {
+		ret = -EOVERFLOW;
+		goto unlock;
+	}
+
 	pgshift = __ffs(iommu->pgsize_bitmap);
 	pgsize = (size_t)1 << pgshift;
 
@@ -1396,10 +1418,15 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
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
@@ -1446,7 +1473,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 		if (dma && dma->iova != iova)
 			goto unlock;
 
-		dma = vfio_find_dma(iommu, iova + size - 1, 0);
+		dma = vfio_find_dma(iommu, iova_end, 0);
 		if (dma && dma->iova + dma->size != iova + size)
 			goto unlock;
 	}
@@ -1648,7 +1675,9 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 {
 	bool set_vaddr = map->flags & VFIO_DMA_MAP_FLAG_VADDR;
 	dma_addr_t iova = map->iova;
+	dma_addr_t iova_end;
 	unsigned long vaddr = map->vaddr;
+	unsigned long vaddr_end;
 	size_t size = map->size;
 	int ret = 0, prot = 0;
 	size_t pgsize;
@@ -1656,8 +1685,15 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 
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
@@ -1673,13 +1709,7 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 
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
@@ -1710,7 +1740,7 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 		goto out_unlock;
 	}
 
-	if (!vfio_iommu_iova_dma_valid(iommu, iova, iova + size - 1)) {
+	if (!vfio_iommu_iova_dma_valid(iommu, iova, iova_end)) {
 		ret = -EINVAL;
 		goto out_unlock;
 	}
@@ -2977,7 +3007,8 @@ static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
 		struct vfio_iommu_type1_dirty_bitmap_get range;
 		unsigned long pgshift;
 		size_t data_size = dirty.argsz - minsz;
-		size_t iommu_pgsize;
+		size_t size, iommu_pgsize;
+		dma_addr_t iova, iova_end;
 
 		if (!data_size || data_size < sizeof(range))
 			return -EINVAL;
@@ -2986,14 +3017,24 @@ static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
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
@@ -3007,19 +3048,18 @@ static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
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


