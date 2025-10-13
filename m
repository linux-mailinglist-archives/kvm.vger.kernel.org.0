Return-Path: <kvm+bounces-59864-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 04C05BD1780
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 07:33:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 32F364EB447
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 05:33:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64F522DE1E5;
	Mon, 13 Oct 2025 05:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b="sgaXgrnB"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0411E2DA750
	for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 05:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760333570; cv=none; b=KJ9DupiyUkQoc9ptsbYdJIQeW5XU1bOw2GggfUgvPUNXIDyJ9cFeMHOwMF0PbR/lIDEyQ95YdPqbiYvRZ5HTzCRZFTLh2hVf5iXukFla26jtk6skAmenS7+XXWVRCY9fi00LGP94MC3hHYujpMOIWaf+lyj/M28krQi5Pf0YnzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760333570; c=relaxed/simple;
	bh=bL2Lm2n4e9930GjnhR9kYIAZMluDFF1rbD3fEq8ntKM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=FuHEGAFTDYI7y0mKZf4ufcO9awOjqNur349z47CDKLDTKZAJ+U3ZXNc9Qhv7Xd4YSBxliyisvvPziwKoi1kUZAq4SmdLGcHEGFuTHvKmzbQ7YCwZpvQSYGWGg9It/e0ukTthKs0lHsJiBTH5uJrX+JWKfz9NDke/AVKLwRWnYGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b=sgaXgrnB; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59D3DWhq536898
	for <kvm@vger.kernel.org>; Sun, 12 Oct 2025 22:32:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=9P0Pku55fBiFAorYlOSjBsBGriWgJG02HANwpST4hjY=; b=sgaXgrnBRCJI
	yNXHOkA9WIDcYkpxODIHQAAEyZsxODY65tUKsGSpE3SAJF3QqAA7skBhzdL6FX+E
	e2awIN1Hu3iBOe7y8zNjyPMHWOoysCh9B2AX+JXqI5YVSuJ7veg/8xbgMwb1QuGf
	xUi5PC5DQO1taLPDY4XZZzsDgCo0Vf2dxP6442FO0BwiEQKTc6uw3M/4hSukE+bU
	c2FonPCywb9nh6VkSxLrSUSlkm0XYmcOj0r981vU3es/dw4KUO2ZGNNgxzG/1lR4
	/FfkXhDnyf2rEMeXiujYZ5XDsO4eNXHMSrIcNpkOkEwY52+yrHBDAZLfQQ/bSW6n
	D3+oN5S4iQ==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 49rsb6gdyw-6
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Sun, 12 Oct 2025 22:32:47 -0700 (PDT)
Received: from twshared38445.28.prn2.facebook.com (2620:10d:c0a8:fe::f072) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Mon, 13 Oct 2025 05:32:44 +0000
Received: by devgpu015.cco6.facebook.com (Postfix, from userid 199522)
	id 9E4A4102FE48; Sun, 12 Oct 2025 22:32:30 -0700 (PDT)
From: Alex Mastro <amastro@fb.com>
Date: Sun, 12 Oct 2025 22:32:25 -0700
Subject: [PATCH v4 2/3] vfio/type1: move iova increment to unmap_unpin_*
 caller
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20251012-fix-unmap-v4-2-9eefc90ed14c@fb.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDEzMDAyNiBTYWx0ZWRfX5DtOlvJsy79J
 pMa3rLQtwu5HLfT/2cfMMbfA/TkFTIexJGk2LxMsxlKhacmyswZKkIDpe1HnWpRDl2vvWD0iRO4
 lswLe7yIiIDkdr1Sfxy32oaP71G2eo8Ly9BAAE0r9YuuXqThYc/aD1SdXhppliE5MVTSkA5Wocb
 Chsr0KL6kTxfdwd22ccNmVXBg85qbPYeQRPCVK3qz/AZMy8VRwffrA798LD/jaTsnoV222Jy1Of
 hQTF9/UwEmFAvI6Fg9RBakVmsOYxmv2aGxH6oIljTPE/Yg7DTdxef7qx2Yd5UfbZVArFeG3t26d
 s0StiAGTbxlg7yfWbuU91T+jpmIpZeBz6bpozj46pA6MmWwDexgkJRHI+pq/aEoOo9cVSIZwy0n
 5qbejsrhAC3leAdD75Ff5LJloGu/4g==
X-Proofpoint-ORIG-GUID: WHPZwHtBdJyn1FGD-Y8gBXuM6ylAYCHD
X-Authority-Analysis: v=2.4 cv=BarVE7t2 c=1 sm=1 tr=0 ts=68ec8eff cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=FOH2dFAWAAAA:8 a=Bkl4-CcWoNymJLHaMFkA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: WHPZwHtBdJyn1FGD-Y8gBXuM6ylAYCHD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-13_02,2025-10-06_01,2025-03-28_01

Move incrementing iova to the caller of these functions as part of
preparing to handle end of address space map/unmap.

Signed-off-by: Alex Mastro <amastro@fb.com>
---
 drivers/vfio/vfio_iommu_type1.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 1ac056b27f27..48b84a7af2e1 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -1013,7 +1013,7 @@ static long vfio_sync_unpin(struct vfio_dma *dma, struct vfio_domain *domain,
 #define VFIO_IOMMU_TLB_SYNC_MAX		512
 
 static size_t unmap_unpin_fast(struct vfio_domain *domain,
-			       struct vfio_dma *dma, dma_addr_t *iova,
+			       struct vfio_dma *dma, dma_addr_t iova,
 			       size_t len, phys_addr_t phys, long *unlocked,
 			       struct list_head *unmapped_list,
 			       int *unmapped_cnt,
@@ -1023,18 +1023,17 @@ static size_t unmap_unpin_fast(struct vfio_domain *domain,
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
@@ -1053,18 +1052,17 @@ static size_t unmap_unpin_fast(struct vfio_domain *domain,
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
@@ -1127,16 +1125,18 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
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


