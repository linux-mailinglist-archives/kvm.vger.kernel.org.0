Return-Path: <kvm+bounces-66918-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id EC312CEDB07
	for <lists+kvm@lfdr.de>; Fri, 02 Jan 2026 07:57:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E052A3009F9B
	for <lists+kvm@lfdr.de>; Fri,  2 Jan 2026 06:57:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 843B72D0C60;
	Fri,  2 Jan 2026 06:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="cIwC8HbK"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A01D238C3A;
	Fri,  2 Jan 2026 06:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767337034; cv=none; b=HYGH9QqLt/RZKrSrTiPIPDVygQsIsEQB/ZW6zbr0ocKCS+/B58e15htSwTe+Ft6NTvNFIy9B+R9Jt9NmtCAqpYz+iLPN1UmzBHDDYuotR7DGFe+IBS+nutCt5RvhK92/zV+3ksGlPISTPQD4TiMppaIg6hctp0f+v1Ra2ujtUxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767337034; c=relaxed/simple;
	bh=Giiur8wOK75juDLaaBPPCjjZThES+dD8KEcyGXN1y1Y=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=WG8BMGlInRCnaJNiUCHq18E/+1mwzpQLYhpMx9Jc6y8n0Gg7K2+GRu/N2v5b27ID+1ltc3oQZoPSSPU7l7OfylAh8GMYjBFnHlSU65u1foJQ/m+TS2Hpyoz8s2JOvBpUa9Bt30Lxw4ctxP3Lt4A9MUHGbUpYYsI2Mxt+kzKEQGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=cIwC8HbK; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6024SIPn072128;
	Thu, 1 Jan 2026 22:57:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pfpt0220; bh=/4YYqHOfPMdRa/spETylSpX
	ytWs2YqgmMtty3S1xSSw=; b=cIwC8HbKF9S1a8Icl9l/NCcUhjiqRXyQVuxJzXK
	UDAYSuGRIOb1Ry5NoG0nD32C20TRYj95daA7yNbsVo9jpC9sj/eIxm6kS7PkZ4ou
	UsdPBqp+M37ZkDPFynXHJnHxpMOmI0dFJj9Xk5WXjJNYVqZQIxBCY8b7u+pmnnmD
	pRYEOPLIKKu2EBcPKtet53M9VqJ9t2cxdcxREeIhE0+wPIrhfCFrPIiHzMzWuCgU
	EiEm4ElGmzbnMarXbTxXOlLmZNXwT6ttoGVctAC873pb/FN8ynN+W8qI05BBneoX
	R1INwk78//dS6WtjE6accQAuiLu4yCBofaRpxspkH3f4RxQ==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4be2mb8e7a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 01 Jan 2026 22:57:08 -0800 (PST)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 1 Jan 2026 22:57:07 -0800
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Thu, 1 Jan 2026 22:57:07 -0800
Received: from 5810.marvell.com (unknown [10.29.45.105])
	by maili.marvell.com (Postfix) with ESMTP id 447605B6945;
	Thu,  1 Jan 2026 22:57:04 -0800 (PST)
From: Kommula Shiva Shankar <kshankar@marvell.com>
To: <mst@redhat.com>
CC: <jasowang@redhat.com>, <virtualization@lists.linux.dev>,
        <eperezma@redhat.com>, <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <jerinj@marvell.com>, <ndabilpuram@marvell.com>, <schalla@marvell.com>
Subject: [PATCH] vhost: fix caching attributes of MMIO regions by setting them explicitly
Date: Fri, 2 Jan 2026 12:27:03 +0530
Message-ID: <20260102065703.656255-1-kshankar@marvell.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=DqtbOW/+ c=1 sm=1 tr=0 ts=69576c44 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=M5GUcnROAAAA:8 a=20KFwNOVAAAA:8
 a=B7PU6KTNA_LlbaTfV1kA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: Jfn3uONG0LL2oWxZkExQ3gnUW7zEnwzS
X-Proofpoint-GUID: Jfn3uONG0LL2oWxZkExQ3gnUW7zEnwzS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTAyMDA2MyBTYWx0ZWRfX79SelernEzUf
 LomwbPlho60xcHzQ+pKnBQ3Z/04BYRiKIB4qJrs0ApbPgVwKZVC8H1qJYlBkyTT+f70NhKoaRSc
 BTM6wfBpGFlksgNz33bCGhsC2EUyPOBRrOTBqkV+f5Lw7bF/mdAbD9DRudtiquI1H+PLvrJgCM2
 EIWltIu2ctCX92G50uGieif/657/BEAiVfruloeNTZ81JqKVkVg3jWxIcA8MOuIYG8AQUynG2XC
 4OwGKLiWV5O+G8ZkoCOQkkMxtSsXHZK8hwR5JWrvgzbgmIqJDOoEYqrge/3MzoDQlbSl/Z3xDlz
 551AOd2Ju0xBDDCa2SK286cuNVqHwlxeJJ5kqQ+mI67PnD6z/a5M+klJgRETMVsH+EAhEdYtDp2
 DE9rbntHTDSDC0FatmzajnGPI3Yuo+YPQ4RIZrC3fem/O2UH0y10k0xYKh5TW+XtAWaeaNquXz0
 lB7GHg8jFkKe3ODgnAw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-01_07,2025-12-31_01,2025-10-01_01

Explicitly set non-cached caching attributes for MMIO regions.
Default write-back mode can cause CPU to cache device memory,
causing invalid reads and unpredictable behavior.

Invalid read and write issues were observed on ARM64 when mapping the
notification area to userspace via mmap.

Signed-off-by: Kommula Shiva Shankar <kshankar@marvell.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
Originally sent to net-next, now redirected to vhost tree
per Jason Wang's suggestion. 

 drivers/vhost/vdpa.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 05a481e4c385..b0179e8567ab 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -1527,6 +1527,7 @@ static int vhost_vdpa_mmap(struct file *file, struct vm_area_struct *vma)
 	if (vma->vm_end - vma->vm_start != notify.size)
 		return -ENOTSUPP;
 
+	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 	vm_flags_set(vma, VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
 	vma->vm_ops = &vhost_vdpa_vm_ops;
 	return 0;
-- 
2.48.1


