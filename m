Return-Path: <kvm+bounces-20539-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 50D68917F61
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 13:16:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 084E52841EA
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 11:16:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 217D717E91F;
	Wed, 26 Jun 2024 11:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="OEKWQBcL"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D21148FE3;
	Wed, 26 Jun 2024 11:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719400600; cv=none; b=rbnJJperLbp8FUGwgLVqCiCXJfj5lxBWBl8zP03GlNuDY0mTJan4HEJJlWih0nSKtCnObl3Q5DQ/+plYph2zriT+3A0mn/RvY70aWgkaCkpPwYK9GHAJK5JbvngrVrnxbHVkrQ9cMDB9UMZLkNZpY3RlUoHUz8Vy4hLjF7augJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719400600; c=relaxed/simple;
	bh=kmttkYcl7RaIqBVfs1vIdHpH/R3f9A14cvLyhdB1rck=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=rDp7leBcv49HcQE8esbbCM+IdLD0Fc1vH4KNB2xBJ8gfGIBOnKccxIJSMSrHfjI0OiCsV/wr6mpEolwsy6/8G2CiWTWh80fEpL8VDn7N9AsYCLaBK+T7yLNkrqHZ4Mko6qi8935pUgfhGxNgXcSBcvEWhjocn89q2QdLEhEWK+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=OEKWQBcL; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45QAQoYD023768;
	Wed, 26 Jun 2024 11:16:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:date:subject:mime-version:content-type
	:content-transfer-encoding:message-id:references:in-reply-to:to
	:cc; s=pp1; bh=LTrthfU6+VvQnNM7AhQqXcpa/YUXxL1CYEpRBlk6l6E=; b=O
	EKWQBcLNuX0DAcZuh73Q789AmQK9/Ienszwx+omqKbrnEECO8mrCl/51/jFycsGD
	s4a58w9GtlHdDfWTKPyXBnxz6SOrdy3JDAawEiaFufusWYcdIbRmWdk2n3n+Od0b
	6/K81e0TTAbLyNT5/GrwjeXHKbjjfN1BOzYxFql/c8qyaRjfDUuyAg4fO90KTNJQ
	Z/Sgks64qsKWubaxdEWpFEd65s+Edj+oLd/LUNCHcCtkZbfTIKEEdoH403ZLPELt
	sw2rrejg2kk5vcHmxxaW3YspbzBT9vXnA0bGotB2MtkEx/ncpxdwlfjSbalLogL8
	SRPqxkNI0UTvO3lKRC6nQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 400gcr8922-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Jun 2024 11:16:32 +0000 (GMT)
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45QBGWKd007055;
	Wed, 26 Jun 2024 11:16:32 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 400gcr8920-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Jun 2024 11:16:32 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45Q90k98019625;
	Wed, 26 Jun 2024 11:16:31 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3yx9xq4469-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Jun 2024 11:16:31 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45QBGRTM62587380
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Jun 2024 11:16:29 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8EF195805F;
	Wed, 26 Jun 2024 11:16:27 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D3CE058067;
	Wed, 26 Jun 2024 11:16:24 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 26 Jun 2024 11:16:24 +0000 (GMT)
From: Niklas Schnelle <schnelle@linux.ibm.com>
Date: Wed, 26 Jun 2024 13:15:48 +0200
Subject: [PATCH v4 1/4] s390/pci: Fix s390_mmio_read/write syscall page
 fault handling
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240626-vfio_pci_mmap-v4-1-7f038870f022@linux.ibm.com>
References: <20240626-vfio_pci_mmap-v4-0-7f038870f022@linux.ibm.com>
In-Reply-To: <20240626-vfio_pci_mmap-v4-0-7f038870f022@linux.ibm.com>
To: Bjorn Helgaas <helgaas@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Gerd Bayer <gbayer@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Niklas Schnelle <schnelle@linux.ibm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
X-Mailer: b4 0.12.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1957;
 i=schnelle@linux.ibm.com; h=from:subject:message-id;
 bh=kmttkYcl7RaIqBVfs1vIdHpH/R3f9A14cvLyhdB1rck=;
 b=owGbwMvMwCH2Wz534YHOJ2GMp9WSGNKqf+TadMicifwhL3B7RYsfo3DcI5mN3DpqCr99jrL5/
 jHa80q/o5SFQYyDQVZMkWVRl7PfuoIppnuC+jtg5rAygQxh4OIUgIkovmP4X6+ndrP6138JgwsM
 IX0y56rK9/FesnoR4DJxC+u1Hy4PWhgZ1h6/8LI795GCPtvNm/bXdn74EZ73vqq/36lH7cGtqbK
 uTAA=
X-Developer-Key: i=schnelle@linux.ibm.com; a=openpgp;
 fpr=9DB000B2D2752030A5F72DDCAFE43F15E8C26090
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7XxvmvvyIO5taVuYVVj84sYjLGeEanp6
X-Proofpoint-ORIG-GUID: ZNdf76wXQ_Bmd1EXEhx57NrQHmzS9Jl_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-26_04,2024-06-25_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 mlxscore=0 adultscore=0 clxscore=1015 mlxlogscore=953 bulkscore=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 impostorscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2406260078

The s390 MMIO syscalls when using the classic PCI instructions do not
cause a page fault when follow_pte() fails due to the page not being
present. Besides being a general deficiency this breaks vfio-pci's mmap()
handling once VFIO_PCI_MMAP gets enabled as this lazily maps on first
access. Fix this by following a failed follow_pte() with
fixup_user_page() and retrying the follow_pte().

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
---
 arch/s390/pci/pci_mmio.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/s390/pci/pci_mmio.c b/arch/s390/pci/pci_mmio.c
index 5398729bfe1b..80c21b1a101c 100644
--- a/arch/s390/pci/pci_mmio.c
+++ b/arch/s390/pci/pci_mmio.c
@@ -170,8 +170,12 @@ SYSCALL_DEFINE3(s390_pci_mmio_write, unsigned long, mmio_addr,
 		goto out_unlock_mmap;
 
 	ret = follow_pte(vma, mmio_addr, &ptep, &ptl);
-	if (ret)
-		goto out_unlock_mmap;
+	if (ret) {
+		fixup_user_fault(current->mm, mmio_addr, FAULT_FLAG_WRITE, NULL);
+		ret = follow_pte(vma, mmio_addr, &ptep, &ptl);
+		if (ret)
+			goto out_unlock_mmap;
+	}
 
 	io_addr = (void __iomem *)((pte_pfn(*ptep) << PAGE_SHIFT) |
 			(mmio_addr & ~PAGE_MASK));
@@ -305,12 +309,16 @@ SYSCALL_DEFINE3(s390_pci_mmio_read, unsigned long, mmio_addr,
 	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
 		goto out_unlock_mmap;
 	ret = -EACCES;
-	if (!(vma->vm_flags & VM_WRITE))
+	if (!(vma->vm_flags & VM_READ))
 		goto out_unlock_mmap;
 
 	ret = follow_pte(vma, mmio_addr, &ptep, &ptl);
-	if (ret)
-		goto out_unlock_mmap;
+	if (ret) {
+		fixup_user_fault(current->mm, mmio_addr, 0, NULL);
+		ret = follow_pte(vma, mmio_addr, &ptep, &ptl);
+		if (ret)
+			goto out_unlock_mmap;
+	}
 
 	io_addr = (void __iomem *)((pte_pfn(*ptep) << PAGE_SHIFT) |
 			(mmio_addr & ~PAGE_MASK));

-- 
2.40.1


