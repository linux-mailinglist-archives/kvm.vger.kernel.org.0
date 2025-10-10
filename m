Return-Path: <kvm+bounces-59764-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AB8FBBCBF29
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 09:39:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 922E0403C8B
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 07:39:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EFF427B320;
	Fri, 10 Oct 2025 07:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b="LiJXMnn8"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B9B52773D2
	for <kvm@vger.kernel.org>; Fri, 10 Oct 2025 07:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760081929; cv=none; b=Sds99o5D/ahkZ3ji3FfF75YTrRoBsDzpNNOgIW/N60epX9qz/Rm5eIPXHZOAEZWAq+zU/D4TdRvi9m+5biJ7BgtU5xGn2wSnYSUmG3AW4nwfA1AvP/7DUUrOtkLCDRP/q4viX4JSktsBFJz4WmsH6JGn2g2CkKQVemUI39LLNTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760081929; c=relaxed/simple;
	bh=AQjCcrCywL7PRjtRctmh+tj0DkerN2p5Ox6LZgV+tS8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=Wur6anzuPR06So3THi1iwsxh2jTmY3PQkXFEPVE7h1wItG7vvmlPsZMWAFqtBD18WWWR6F1gRZXyOJpzutltlZ1AMgt33ouCBYWSnVf3NBoRNFlCAegu/EBAf+zboQ3vdNuT1Bt6QVGdgrNqHBmoz60b2eOCy9eKtqD+xnHuwpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b=LiJXMnn8; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 599KUNpr1851787
	for <kvm@vger.kernel.org>; Fri, 10 Oct 2025 00:38:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=lzPzeOIXu+kRWnu1d9i24XaGblJ9xe9UyAOaLR89QPM=; b=LiJXMnn8T2SV
	foOtPjfC9VeRkv9zZMhJxEmynitRREClUuh7TOLmsYSlXR56vc/Af0//AehHhHua
	9hopQYiUWSa6tS5W5OFPin2iQq0i52hQpRRc4KBYH6hBGRp1F/qYTOkZvS//DrhE
	1cmsYkopD/mHTvrehS/3s3gofmu19GfLiBF237cfmV2SUahIE5zkK0FUZ5THiPLu
	1PWJcVHclE6jmnokf9st4JhqkGAlBLlhWTgI5AHVs4P6z1Xw/5Ftnxw8zKgRNJ0D
	zFxhWlRFxFD6ciseLGr6KCVC4dCbiRlWYgDfPqpB02SQPDkkuV+RR/MGLN0yjm3M
	zjOdXoQYSg==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 49pkcqwfnp-14
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Fri, 10 Oct 2025 00:38:45 -0700 (PDT)
Received: from twshared30833.05.prn5.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Fri, 10 Oct 2025 07:38:43 +0000
Received: by devgpu015.cco6.facebook.com (Postfix, from userid 199522)
	id 43A0DE937D6; Fri, 10 Oct 2025 00:38:40 -0700 (PDT)
From: Alex Mastro <amastro@fb.com>
Date: Fri, 10 Oct 2025 00:38:40 -0700
Subject: [PATCH v3 2/3] vfio/type1: move iova increment to unmap_unpin_*
 caller
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20251010-fix-unmap-v3-2-306c724d6998@fb.com>
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
X-Authority-Analysis: v=2.4 cv=KNBXzVFo c=1 sm=1 tr=0 ts=68e8b806 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=FOH2dFAWAAAA:8 a=Bkl4-CcWoNymJLHaMFkA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 183kze0LeJpDK_b36VpNcg1LLGJo1RlX
X-Proofpoint-ORIG-GUID: 183kze0LeJpDK_b36VpNcg1LLGJo1RlX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDEwMDA0MyBTYWx0ZWRfX8Dfvcn+vA8PC
 4+ehPSBVYtnzwoWUGr1acC/12jurXncxPpeYdKMbFMEp+fMuYn+/30QLX5cM/T3BJ07cnz3to4L
 6Db8elxXnDxTP+jtLju46IxryES5P/cIgkuxdpsGejXckay980UOqwfll+izPTU1kVjB9fob7D3
 aAzZgvcKApbIUZyQkKhC59Fq4Kc55GSSc4dkG9RqAZyTUGaiq1K1LWzKyGs94WeRmV+i9wnJuAT
 JwGjR8emWCDuhzVyXoJqebunxr02RyGW0c0EID5N6Kae155ZAsPndS2+A1Xl+J/76LrTvZNtRvh
 7g/uKK/PuZbteCQpiQTg1oFyPG2g8XGGvNQ1fgRhZosPNsxYPtWzjKOEIN/JiUXqcv+zA2h9/OJ
 p+0/wQAXvnJOcetnKLNARxD/vLfCoQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-10_01,2025-10-06_01,2025-03-28_01

Move incrementing iova to the caller of these functions as part of
preparing to handle end of address space map/unmap.

Signed-off-by: Alex Mastro <amastro@fb.com>
---
 drivers/vfio/vfio_iommu_type1.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 70f4aa9c9aa6..15aab95d9b8d 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -1020,7 +1020,7 @@ static long vfio_sync_unpin(struct vfio_dma *dma, struct vfio_domain *domain,
 #define VFIO_IOMMU_TLB_SYNC_MAX		512
 
 static size_t unmap_unpin_fast(struct vfio_domain *domain,
-			       struct vfio_dma *dma, dma_addr_t *iova,
+			       struct vfio_dma *dma, dma_addr_t iova,
 			       size_t len, phys_addr_t phys, long *unlocked,
 			       struct list_head *unmapped_list,
 			       int *unmapped_cnt,
@@ -1030,18 +1030,17 @@ static size_t unmap_unpin_fast(struct vfio_domain *domain,
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
 
-			*iova += unmapped;
 			(*unmapped_cnt)++;
 		}
 	}
@@ -1060,18 +1059,17 @@ static size_t unmap_unpin_fast(struct vfio_domain *domain,
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
@@ -1134,16 +1132,18 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
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
+		iova += unmapped;
 	}
 
 	dma->iommu_mapped = false;

-- 
2.47.3


