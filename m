Return-Path: <kvm+bounces-59626-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E579FBC3473
	for <lists+kvm@lfdr.de>; Wed, 08 Oct 2025 06:10:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 189D33A1451
	for <lists+kvm@lfdr.de>; Wed,  8 Oct 2025 04:10:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABADD2C0263;
	Wed,  8 Oct 2025 04:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b="BtfM/lav"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38ACB2BEC5A
	for <kvm@vger.kernel.org>; Wed,  8 Oct 2025 04:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759896578; cv=none; b=Geyw831hspr3H09CSmt5cg95AwXYGPmurkc3PHzwAsJuZUsOlfV/D2QN1A47aNun4oe16YxeZ85wy8AdWJv5l6rLbLKweKXp4KieodhuT4t7puVzccmRzMCXNXZemBgfwnaszEBe39YcYcORqFZ0+NDGN+ze1lAbX+xsul12Eew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759896578; c=relaxed/simple;
	bh=BFgmjXhlqUfV9g5aZf0Fpbp8t42vT5eiICIa6HmsPns=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=dN5elcuneUD7GAB7kRzAis/amDHau/RhQAZrflAGSw1iB9NcmGDfsiUDyHLkA5EZuk1KcGA5vDDgxo5IjBuoHf8lpQbBV7Nx/KkXPtUuc6YzriJ1aOkdhvCUmnMH7wmEK1b5vmOVBhXvesui+pzkCbI0WfRpjcZK9RZuqIbjXKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b=BtfM/lav; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 597NWVsH1937998
	for <kvm@vger.kernel.org>; Tue, 7 Oct 2025 21:09:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=Zp9koOgnd/LMXr9KpmioHND3MH+op8celO7bHBPPISE=; b=BtfM/lavktxy
	6ByZiGRWpmHIaO06iWfyRY6UvPGSactOPkpexKHZckBg+wgQHzwo9nXcfcqrWakG
	cTRH5oliHyzoqlycwf+DJSrpg6CDgUur0oIZ3YPcu29AT0mq+hfdD2fai8ovr3zj
	Vak1mZY4pR2+Bpr+QdKevnaJlqyB0o//JYWRS4bjHzOkbLgsgmwxrX898qanDWku
	w+priJpn16EOsj5dqz0ngln67WrxiheLxWjflVpLT69RrX3/qTabEAtPFYtyNS1+
	zEFh6QfrxOf7NJbxMXbsgZ2B+NB3Sfx0bsdQuVPS6hf3y81w+uCsRwPqyJ/vg6Bv
	FTAuyaj99A==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 49ncmk958v-6
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Tue, 07 Oct 2025 21:09:36 -0700 (PDT)
Received: from twshared76339.05.prn6.facebook.com (2620:10d:c0a8:1b::8e35) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Wed, 8 Oct 2025 04:09:33 +0000
Received: by devgpu015.cco6.facebook.com (Postfix, from userid 199522)
	id B17FAD26CCE; Tue,  7 Oct 2025 21:09:19 -0700 (PDT)
From: Alex Mastro <amastro@fb.com>
Date: Tue, 7 Oct 2025 21:08:46 -0700
Subject: [PATCH v2 1/3] vfio/type1: sanitize for overflow using
 check_*_overflow
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20251007-fix-unmap-v2-1-759bceb9792e@fb.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA4MDAyNCBTYWx0ZWRfXxWfn2NnkC2BQ
 s556ww/ONRMzHUAJi3CVac/c4VDNIaSiYjRTPbByKnul/Ekplyd9Bur0vrFsPQWeug/VXeuPe21
 8g0KeT5qtJLGVtcO35t9lEpRKBkNzZ8OfH3RjSKuevQGp+DEF8foRlWnEOhEDs3k5nn7jYONv+e
 WisWGbVn6bvQXCOYHcSK6fnONg2ve9v34RdWY7E4CBbW59IsCc7duJqr6rQ79X7Hnckxkfiqw+1
 0XKBivNoL1uDsOaAc68SgOHQd1WsQ8WtFEu1yt2d1NF4idLFAlACigtRuOTfpuU9rvaZgzvF3Bb
 A3D7KK5ua97huEtFY4wjUFXut0wWZDw6lSJhJ020Fn0wJurdF5dNkVha7ngCt/SwaTpuBDYvJeL
 gpkm26v9giPSjfARf5NmnpNhjN15xw==
X-Proofpoint-GUID: v-kNO58QbwxKoyhkPA7IniXVD4q48I85
X-Authority-Analysis: v=2.4 cv=D+hK6/Rj c=1 sm=1 tr=0 ts=68e5e400 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=FOH2dFAWAAAA:8 a=J-xk3WMZyPGmlAw7FewA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: v-kNO58QbwxKoyhkPA7IniXVD4q48I85
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-07_02,2025-10-06_01,2025-03-28_01

Adopt check_*_overflow functions to clearly express overflow check
intent.

Signed-off-by: Alex Mastro <amastro@fb.com>
---
 drivers/vfio/vfio_iommu_type1.c | 54 ++++++++++++++++++++++++++++++++---------
 1 file changed, 43 insertions(+), 11 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index f8d68fe77b41..b510ef3f397b 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -37,6 +37,7 @@
 #include <linux/vfio.h>
 #include <linux/workqueue.h>
 #include <linux/notifier.h>
+#include <linux/overflow.h>
 #include "vfio.h"
 
 #define DRIVER_VERSION  "0.2"
@@ -825,14 +826,25 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 	unsigned long remote_vaddr;
 	struct vfio_dma *dma;
 	bool do_accounting;
+	dma_addr_t iova_end;
+	size_t iova_size;
 
-	if (!iommu || !pages)
+	if (!iommu || !pages || npage < 0)
 		return -EINVAL;
 
 	/* Supported for v2 version only */
 	if (!iommu->v2)
 		return -EACCES;
 
+	if (npage == 0)
+		return 0;
+
+	if (check_mul_overflow(npage, PAGE_SIZE, &iova_size))
+		return -EINVAL;
+
+	if (check_add_overflow(user_iova, iova_size - 1, &iova_end))
+		return -EINVAL;
+
 	mutex_lock(&iommu->lock);
 
 	if (WARN_ONCE(iommu->vaddr_invalid_count,
@@ -938,12 +950,23 @@ static void vfio_iommu_type1_unpin_pages(void *iommu_data,
 {
 	struct vfio_iommu *iommu = iommu_data;
 	bool do_accounting;
+	dma_addr_t iova_end;
+	size_t iova_size;
 	int i;
 
 	/* Supported for v2 version only */
 	if (WARN_ON(!iommu->v2))
 		return;
 
+	if (WARN_ON(npage < 0) || npage == 0)
+		return;
+
+	if (WARN_ON(check_mul_overflow(npage, PAGE_SIZE, &iova_size)))
+		return;
+
+	if (WARN_ON(check_add_overflow(user_iova, iova_size - 1, &iova_end)))
+		return;
+
 	mutex_lock(&iommu->lock);
 
 	do_accounting = list_empty(&iommu->domain_list);
@@ -1304,6 +1327,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 	int ret = -EINVAL, retries = 0;
 	unsigned long pgshift;
 	dma_addr_t iova = unmap->iova;
+	dma_addr_t iova_end;
 	u64 size = unmap->size;
 	bool unmap_all = unmap->flags & VFIO_DMA_UNMAP_FLAG_ALL;
 	bool invalidate_vaddr = unmap->flags & VFIO_DMA_UNMAP_FLAG_VADDR;
@@ -1328,7 +1352,8 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 			goto unlock;
 		size = U64_MAX;
 	} else if (!size || size & (pgsize - 1) ||
-		   iova + size - 1 < iova || size > SIZE_MAX) {
+		   check_add_overflow(iova, size - 1, &iova_end) ||
+		   size > SIZE_MAX) {
 		goto unlock;
 	}
 
@@ -1376,7 +1401,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 		if (dma && dma->iova != iova)
 			goto unlock;
 
-		dma = vfio_find_dma(iommu, iova + size - 1, 0);
+		dma = vfio_find_dma(iommu, iova_end, 0);
 		if (dma && dma->iova + dma->size != iova + size)
 			goto unlock;
 	}
@@ -1578,7 +1603,9 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 {
 	bool set_vaddr = map->flags & VFIO_DMA_MAP_FLAG_VADDR;
 	dma_addr_t iova = map->iova;
+	dma_addr_t iova_end;
 	unsigned long vaddr = map->vaddr;
+	unsigned long vaddr_end;
 	size_t size = map->size;
 	int ret = 0, prot = 0;
 	size_t pgsize;
@@ -1588,6 +1615,12 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 	if (map->size != size || map->vaddr != vaddr || map->iova != iova)
 		return -EINVAL;
 
+	if (check_add_overflow(iova, size - 1, &iova_end))
+		return -EINVAL;
+
+	if (check_add_overflow(vaddr, size - 1, &vaddr_end))
+		return -EINVAL;
+
 	/* READ/WRITE from device perspective */
 	if (map->flags & VFIO_DMA_MAP_FLAG_WRITE)
 		prot |= IOMMU_WRITE;
@@ -1608,12 +1641,6 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 		goto out_unlock;
 	}
 
-	/* Don't allow IOVA or virtual address wrap */
-	if (iova + size - 1 < iova || vaddr + size - 1 < vaddr) {
-		ret = -EINVAL;
-		goto out_unlock;
-	}
-
 	dma = vfio_find_dma(iommu, iova, size);
 	if (set_vaddr) {
 		if (!dma) {
@@ -1640,7 +1667,7 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 		goto out_unlock;
 	}
 
-	if (!vfio_iommu_iova_dma_valid(iommu, iova, iova + size - 1)) {
+	if (!vfio_iommu_iova_dma_valid(iommu, iova, iova_end)) {
 		ret = -EINVAL;
 		goto out_unlock;
 	}
@@ -2908,6 +2935,7 @@ static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
 		unsigned long pgshift;
 		size_t data_size = dirty.argsz - minsz;
 		size_t iommu_pgsize;
+		dma_addr_t range_end;
 
 		if (!data_size || data_size < sizeof(range))
 			return -EINVAL;
@@ -2916,8 +2944,12 @@ static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
 				   sizeof(range)))
 			return -EFAULT;
 
-		if (range.iova + range.size < range.iova)
+		if (range.size == 0)
+			return 0;
+
+		if (check_add_overflow(range.iova, range.size - 1, &range_end))
 			return -EINVAL;
+
 		if (!access_ok((void __user *)range.bitmap.data,
 			       range.bitmap.size))
 			return -EINVAL;

-- 
2.47.3


