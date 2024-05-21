Return-Path: <kvm+bounces-17833-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AF1C78CADFB
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 14:16:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 233301F23880
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 12:16:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F39F77101;
	Tue, 21 May 2024 12:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="CZEqcH/E"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FF7476410;
	Tue, 21 May 2024 12:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716293737; cv=none; b=m0uPGH6QjaTcFYUWAgMgZoNITM7A/2SY8s39HEAwShqQVhgB+QOCQc7InZsxZ6I9XD1IkmxvcGOCOXkpnmsMroq8JrllAS+qGGm+napvRGiFXPDNy2h1MwZnQ9osAqKK33MC2zE6+speKO3cZXwspZ40eGTTNhIcma1p9blitqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716293737; c=relaxed/simple;
	bh=dAABayEDOSfEypk9NTThYmbaf19C4af1A3Lunw+eFII=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=HxIqEX0pcZ5ebfsFWgpsM6HH+BDSaClzrgso/DcEqWiEu2PWz3JrDjojkwgldasNJpZ0GEu2ZMyiRlmZgaW/RYo6fwiKsX+wo7l5LQLhfxjq1/NyPOr3hpi3BwtyPD3auKRpBwo73majqb+XpmkACixI+VAhh63q3JvCqQfir9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=CZEqcH/E; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44LCCg1B012068;
	Tue, 21 May 2024 12:15:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : date : subject :
 mime-version : content-type : content-transfer-encoding : message-id :
 references : in-reply-to : to : cc; s=pp1;
 bh=0xh5DBvKXFg7KZScVHo4DoheXvv3/yC0K5O0DOCG9Aw=;
 b=CZEqcH/EUZ9mnj0rAgEwUYGIgej49SZkWgf+YKKe0YHZui0yEyhy8Rvu0AP4WJ/Lq3zQ
 SUYx+L8WbR9tOKxIaFQncEEBVXNg5C/8E52/8ZfWuzczqEhqhJW0b/vEoFxA4VMGEhBD
 b5SibtQl/GakTDEXzUXd3eZniJF7nmfps9wpxJT1UOkHr4Pu83SAvucbo8qTduJIfijL
 oZVyMkb3KDF8bBL8/DYranK4DcF/wF2Y4PZpZ/D+bx1klfDExFNgqMiQ8hW0shlNLYWS
 LxRW20x2qQV9VkvFAkOFcrJSaKNjm2jAZl5duqsbIV0/f7WFFQCbc6n9H1CylXzVSAlS MQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3y8udsr0cy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 May 2024 12:15:34 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44LCFYac017446;
	Tue, 21 May 2024 12:15:34 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3y8udsr0ct-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 May 2024 12:15:34 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 44LAHaTG000887;
	Tue, 21 May 2024 12:15:33 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3y77205pj3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 May 2024 12:15:33 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 44LCFToo50201236
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 May 2024 12:15:32 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D53695805E;
	Tue, 21 May 2024 12:15:29 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 11D9858043;
	Tue, 21 May 2024 12:15:28 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 21 May 2024 12:15:27 +0000 (GMT)
From: Niklas Schnelle <schnelle@linux.ibm.com>
Date: Tue, 21 May 2024 14:14:57 +0200
Subject: [PATCH 1/3] s390/pci: Fix s390_mmio_read/write syscall page fault
 handling
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240521-vfio_pci_mmap-v1-1-2f6315e0054e@linux.ibm.com>
References: <20240521-vfio_pci_mmap-v1-0-2f6315e0054e@linux.ibm.com>
In-Reply-To: <20240521-vfio_pci_mmap-v1-0-2f6315e0054e@linux.ibm.com>
To: Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Gerd Bayer <gbayer@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Niklas Schnelle <schnelle@linux.ibm.com>
X-Mailer: b4 0.12.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1882;
 i=schnelle@linux.ibm.com; h=from:subject:message-id;
 bh=dAABayEDOSfEypk9NTThYmbaf19C4af1A3Lunw+eFII=;
 b=owGbwMvMwCH2Wz534YHOJ2GMp9WSGNJ8JkS7cflp7L3LErOJ8ULm7tiGrYtO7JrwtulZYPWpJ
 zs+10Zu6ChlYRDjYJAVU2RZ1OXst65giumeoP4OmDmsTCBDGLg4BWAi5XKMDDcWe/xI3aTxtm3y
 tSyZd3seCb3+u05pfU/jzS0vp6wprmZlZFgz+VX+AamY9PBE163XPPa2LZ16xOmJQJt+Z3Hrpxe
 FvGwA
X-Developer-Key: i=schnelle@linux.ibm.com; a=openpgp;
 fpr=9DB000B2D2752030A5F72DDCAFE43F15E8C26090
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: mKSek11CftSv1bSJDKmIIgkbryhBnIFl
X-Proofpoint-GUID: b6UkesWe_d7WXLuxNf71rkWASCJrfMBb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-21_08,2024-05-21_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 mlxlogscore=931 mlxscore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 adultscore=0 malwarescore=0 clxscore=1015 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405210092

The s390 MMIO syscalls when using the classic PCI instructions do not
cause a page fault when follow_pte() fails due to the page not being
present. Besides being a general deficiency this breaks vfio-pci's mmap()
handling once VFIO_PCI_MMAP gets enabled as this lazily maps on first
access. Fix this by following a failed follow_pte() with
fixup_user_page() and retrying the follow_pte().

Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
---
 arch/s390/pci/pci_mmio.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/s390/pci/pci_mmio.c b/arch/s390/pci/pci_mmio.c
index a90499c087f0..217defbcb4f1 100644
--- a/arch/s390/pci/pci_mmio.c
+++ b/arch/s390/pci/pci_mmio.c
@@ -170,8 +170,12 @@ SYSCALL_DEFINE3(s390_pci_mmio_write, unsigned long, mmio_addr,
 		goto out_unlock_mmap;
 
 	ret = follow_pte(vma->vm_mm, mmio_addr, &ptep, &ptl);
-	if (ret)
-		goto out_unlock_mmap;
+	if (ret) {
+		fixup_user_fault(vma->vm_mm, mmio_addr, FAULT_FLAG_WRITE, NULL);
+		ret = follow_pte(vma->vm_mm, mmio_addr, &ptep, &ptl);
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
 
 	ret = follow_pte(vma->vm_mm, mmio_addr, &ptep, &ptl);
-	if (ret)
-		goto out_unlock_mmap;
+	if (ret) {
+		fixup_user_fault(vma->vm_mm, mmio_addr, 0, NULL);
+		ret = follow_pte(vma->vm_mm, mmio_addr, &ptep, &ptl);
+		if (ret)
+			goto out_unlock_mmap;
+	}
 
 	io_addr = (void __iomem *)((pte_pfn(*ptep) << PAGE_SHIFT) |
 			(mmio_addr & ~PAGE_MASK));

-- 
2.40.1


