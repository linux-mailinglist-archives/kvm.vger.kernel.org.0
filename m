Return-Path: <kvm+bounces-59623-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D3625BC3463
	for <lists+kvm@lfdr.de>; Wed, 08 Oct 2025 06:09:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D6A4E19E032C
	for <lists+kvm@lfdr.de>; Wed,  8 Oct 2025 04:10:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82BD82BE7CC;
	Wed,  8 Oct 2025 04:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b="Q8bzn0rg"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D76332BE63A
	for <kvm@vger.kernel.org>; Wed,  8 Oct 2025 04:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759896567; cv=none; b=Y/VT194CdzfLhk9sjFNNHU4pWUphht5eMcPXZPntQ22nmpXleaRDlP55ne0joULTC5vPGwXHRWnT90hxB8Z9Nx9GSFBQZ66ljquVr32nsLq3PpUYCYT0HJQysFtrGyhq2q8lRdPAcpv4YhQz0MJPrjKdNLmiiVCjAi0AMTQtkw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759896567; c=relaxed/simple;
	bh=Sc7RyZvHVnsiWmJJsfqHgDMcvPy6kEMQ+FShuIOWcvI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=n/kb3PGmXZexPZsXComyk0w19QPQDn7K0RtbjrEYbwxsRtLrKw7Cy0XRSg2iDDLy9t4dKSNNvpkIuhKZpY+Y7F6RlR6+s2b0s01OgeXdQ2yHYEA4g9TxpsClVlH1r/duuaeT1upMBPSSPLSQc8VuLQApiOFMjRoGRbOAiMqlYs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b=Q8bzn0rg; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5982K18w2067384
	for <kvm@vger.kernel.org>; Tue, 7 Oct 2025 21:09:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=/DPR3MVV9m01+QHNDlVKZ/bjjUFkh+IA4QwkKhO8QSE=; b=Q8bzn0rgeH4O
	n55ohN99Df8Hk5AwINotNnYHCnOJu8v/J7QTglLi8KyvpQ7N2SsLVirQRoRvJQ0w
	KzCF8u2RnmY/yWAsXQiUHcDlrit3ooYs99t3etE4hm52yoOXl/zllThzk1npoNTz
	LFO51MzvMf8dIFRZ5f0d18oDjK17X/yKu8i/gfagEXwBbQW+Wy8DbnIe/I+ofFy1
	7y1qZ88ZFoobu0VU03d2mImtFL0VpWdWrGJPP5x1BREZC6aOD38AmCp9MSz2UPTL
	aukNecOBSOtf/VMfJJVG8NapCi8yH+qotRcMuo/uDoEpmUacQQRmFsVStqskzD+a
	9zWpLk5Ndw==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 49n7jxuhyg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Tue, 07 Oct 2025 21:09:24 -0700 (PDT)
Received: from twshared28243.32.prn2.facebook.com (2620:10d:c0a8:1b::8e35) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Wed, 8 Oct 2025 04:09:23 +0000
Received: by devgpu015.cco6.facebook.com (Postfix, from userid 199522)
	id B1A19D26CCF; Tue,  7 Oct 2025 21:09:19 -0700 (PDT)
From: Alex Mastro <amastro@fb.com>
Date: Tue, 7 Oct 2025 21:08:47 -0700
Subject: [PATCH v2 2/3] vfio/type1: move iova increment to unmap_unpin_*
 caller
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20251007-fix-unmap-v2-2-759bceb9792e@fb.com>
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
X-Proofpoint-GUID: x4PXJWuJSf3GOql9ZU5o3jkGTnL6kbTC
X-Proofpoint-ORIG-GUID: x4PXJWuJSf3GOql9ZU5o3jkGTnL6kbTC
X-Authority-Analysis: v=2.4 cv=LJdrgZW9 c=1 sm=1 tr=0 ts=68e5e3f4 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=FOH2dFAWAAAA:8 a=Bkl4-CcWoNymJLHaMFkA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA4MDAyNCBTYWx0ZWRfX6PfSMV9c40ku
 V8APM8Ih6FmqLyFVEqRWyQuOmlcR/ymwppumaY6p2w2dC/hHOGvafFCyMftL6jJ7648fwdIJuYS
 aX/4TgZM5pCrv1c7bzY7KwZ1PAvkioFSNnIwZpQeck6fGcaIzQiHHO5CfAqEnRsj4v/9ChaEAmS
 TX3HIFskpwS72gZBHEoNJYOi7NsWMqyFOxH3T4ABWpJ8bi4XJn4YR2Tz3JDApnnyRC4lc/cn0af
 weCId5vGo3NNSYP8gfIyQ7K6a+xnkl+/M22q15kkwwNz//fvYMdpcQ1QTloUD5tfQYO1zOr13ac
 uONI6gdF0yV3U6HfgCUWnxVVXi5SAYzJhZ9XRQ4aefGDiFVRH8MOoVA3Li8LM4ml+RmnZOK8haA
 5G0hqCdIoKDiuRGVED/7YVyn4Jsb5w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-07_02,2025-10-06_01,2025-03-28_01

Move incrementing iova to the caller of these functions as part of
preparing to handle end of address space map/unmap.

Signed-off-by: Alex Mastro <amastro@fb.com>
---
 drivers/vfio/vfio_iommu_type1.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index b510ef3f397b..f6ba2f8b1dd8 100644
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


