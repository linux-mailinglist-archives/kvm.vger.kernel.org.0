Return-Path: <kvm+bounces-61207-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DCC3BC0FAFF
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 18:36:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 71B134291BE
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 17:34:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B139C31A549;
	Mon, 27 Oct 2025 17:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b="nfR6F9ty"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75835318157
	for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 17:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761586460; cv=none; b=fCF4ZCteSEdUyU3PtWEtMx3OVgNjz+Cgk0lz5utba4Glycf5C5K5Qe+ivIKfulYTh/vNWCprWFlxvHmMjwgmIN00uy4NrLji+hlzPTHlqruXDfeamzeblOUFF5rSWZoc73EfcyXRXYhKBwBv2UuMywyoaN6Jpl19HAx/ouVO3VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761586460; c=relaxed/simple;
	bh=zH2bltp5SnxsRbXoUh5UiyX6fJZxfu9t7+eKTgtNKhw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=i4sQLUbEIHB31tBTggytoqQi3Sv5OZxC8E9NZ12qX49dLdPuQTK5AnOIGOwF3C4n629z5F6N7s0MgaslpaspC2jx+0LSl57squ+mmLbc+fq8gu9yhRrJFmDQMgMKH2UsHJFCqSBOQ7P4LgFoCAvD7tgxXPkI1XaF5ynrQ8HEvhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b=nfR6F9ty; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59RFrudC1234687
	for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 10:34:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=5Xtgh45PqrJXrHbQeeYqpMNjm28cym0+HxoQQ807OaM=; b=nfR6F9tyru1+
	v0scJppepDG4pIwNDWL08E8LJkbMvaPDn6tQKh3Puu7R6rgYltOAsuhS0wyUYiTg
	5kDfs7ERzouc9DsZp1pHEENRApUsPMyMgNS0LKJ4eY1zjsOI3efvcSYgqFjKrw2D
	tPMrJ5OgdYSOFjKMgW0eFfORBzLdEYxZxHgW0UaQmOz4fdNANL7a4cOdmcm75XiW
	yYIq8tPeAye8gGc3bIeCUJdhMJiDXmuNWzaZYhQaFqt+Q0sH+MTKTT7g0ERhjZyf
	QkPGTs6nyW8nBM3hXxyrcoKMqh99NcbCFx4Lednhut76hdmwmzReLQRNr7kZnwiH
	rcZYhndjZA==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4a2bsd11em-12
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 10:34:18 -0700 (PDT)
Received: from twshared28390.17.frc2.facebook.com (2620:10d:c0a8:1b::30) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Mon, 27 Oct 2025 17:34:03 +0000
Received: by devgpu012.nha5.facebook.com (Postfix, from userid 28580)
	id 7C38743E096; Mon, 27 Oct 2025 10:33:57 -0700 (PDT)
From: Alex Mastro <amastro@fb.com>
Date: Mon, 27 Oct 2025 10:33:42 -0700
Subject: [PATCH v5 2/5] vfio/type1: move iova increment to unmap_unpin_*
 caller
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20251027-fix-unmap-v5-2-4f0fcf8ffb7d@fb.com>
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
X-Authority-Analysis: v=2.4 cv=LrifC3dc c=1 sm=1 tr=0 ts=68ffad1a cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=Ikd4Dj_1AAAA:8 a=FOH2dFAWAAAA:8 a=PelP7hj50Gaxf9uocr0A:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: fk6IAvBDYgLJZTOXOIVNNzFXMWL8EO0P
X-Proofpoint-GUID: fk6IAvBDYgLJZTOXOIVNNzFXMWL8EO0P
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI3MDE2MyBTYWx0ZWRfX2yn2rg1H57ct
 i559WpMQ4E3OzHTUo4pzmCZHqAyhMQLI8sCs4GQ99vAQLPyNVCpyeiE6lWsFQhX2GHUReWrhlur
 Q8tWSin6ZXJNJt0hlr+ry5z2bcTbEzxoYm+kLLO7vLBkWaVxZ802KoaQTPuNakEdH849IvDn2bu
 6un6dSj1ang/mV+EKGrdr+m9Iq50mpk5eevv0F7B90j5gGQiXpE1DGtFSwDp/l/T5TU2PODPT5b
 7dDc98TbZjNyYJlZ+fGwjnqRAh3zIntWs0dYpoARSYZHwgRCX8ijzZg8un53FFWtOsnVjBhMmhr
 QhdAPADxYD+uzSzLsFR5Uionah6PC7ZC/8w37h7ZO6DtZGcF7LKhx70kS08ov97kodGvz8GyYVl
 FPn0BunEJBLheVpQcMkLEHLYyIa4+w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-27_07,2025-10-22_01,2025-03-28_01

Move incrementing iova to the caller of these functions as part of
preparing to handle end of address space map/unmap.

Tested-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Fixes: 73fa0d10d077 ("vfio: Type1 IOMMU implementation")
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Signed-off-by: Alex Mastro <amastro@fb.com>
---
 drivers/vfio/vfio_iommu_type1.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 91b1480b7a37..48bcc0633d44 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -1083,7 +1083,7 @@ static long vfio_sync_unpin(struct vfio_dma *dma, struct vfio_domain *domain,
 #define VFIO_IOMMU_TLB_SYNC_MAX		512
 
 static size_t unmap_unpin_fast(struct vfio_domain *domain,
-			       struct vfio_dma *dma, dma_addr_t *iova,
+			       struct vfio_dma *dma, dma_addr_t iova,
 			       size_t len, phys_addr_t phys, long *unlocked,
 			       struct list_head *unmapped_list,
 			       int *unmapped_cnt,
@@ -1093,18 +1093,17 @@ static size_t unmap_unpin_fast(struct vfio_domain *domain,
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
@@ -1123,18 +1122,17 @@ static size_t unmap_unpin_fast(struct vfio_domain *domain,
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
@@ -1197,16 +1195,18 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
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


