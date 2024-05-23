Return-Path: <kvm+bounces-18035-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1320C8CD0F1
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 13:11:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 366481C21435
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 11:11:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFBDF1487F5;
	Thu, 23 May 2024 11:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="FVqZfOF3"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6FCB147C63;
	Thu, 23 May 2024 11:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716462639; cv=none; b=X479UOB83W+QMjcgRIFUNkHAtuSorWDzWh0gRv8qS5YrPIq7mUG0D2Mp11/tpTAz1lHUlTN9XxMBs6DEe/MC533XO9FKhyQPELNVZTDtkzJchCoLHE9WUN0v/xQ925ydj8Z86vO+4GGOLV8U+fANbZxd4YHKuYlq2V2QROs68IM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716462639; c=relaxed/simple;
	bh=V9p54K0J4aEM5NILVOof+HaaDipCamwYqPH+otYYUpU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=b1s7y+q3N/xx3m9ozs0cpntvkcvM5ELdwcdorl8eZPNdrGCpWMpA0Zbibpz06O1bejc04+cU6WdAJ2mr6QGOC2RT35CCfC/gk+IyEh5av9X0ZKGPqft1ux2etNjiIpXoo/rNCNxWYJgJEqTW5ABJJD8BH3ZXm2w3O+fKNxgDGjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=FVqZfOF3; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44NArGvC015420;
	Thu, 23 May 2024 11:10:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : date : subject :
 mime-version : content-type : content-transfer-encoding : message-id :
 references : in-reply-to : to : cc; s=pp1;
 bh=bUFP5CycpZZ5HV22vNMvqpWdG4N/x0IfliF7CPJsewA=;
 b=FVqZfOF3nJnThkGQJrcB64nGcL2Kh0vG5+RSe5WyERbmaYx1ymox+Ar1Sb7a3UX6OJq2
 2dNfDMGlaGj5JwILk90BqXWo9ntKn9inkR/RlOCYQmqLUn1EtYqAc+43+fYOggM/HkuO
 KxxgyLDW72D2HL2DiND6KVBFEI7SSV2FFAVlpbt53JNOlaXUkVRoIsEMMSlWuVoTB/d8
 bkbSqipuDiV91bFZzbWka+BPTmcC8EcxR9mt0jflCHVQ+9WTLzpYYWjuW9yiHO1aQnLj
 3oJOYi6kP7JLkwcZ/yTKswlMqd638AimC7CH2TYuNfWtGUnSENNakGGucvjOLnZ8QrZv Qg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ya4edr1fu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 May 2024 11:10:35 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44NBAYau009744;
	Thu, 23 May 2024 11:10:34 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ya4edr1fr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 May 2024 11:10:34 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 44N7oTtG026478;
	Thu, 23 May 2024 11:10:34 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3y785msghu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 May 2024 11:10:34 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 44NBAUvd27132424
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 May 2024 11:10:33 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DADE458056;
	Thu, 23 May 2024 11:10:30 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7E7EF58045;
	Thu, 23 May 2024 11:10:28 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 23 May 2024 11:10:28 +0000 (GMT)
From: Niklas Schnelle <schnelle@linux.ibm.com>
Date: Thu, 23 May 2024 13:10:14 +0200
Subject: [PATCH v2 1/3] s390/pci: Fix s390_mmio_read/write syscall page
 fault handling
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240523-vfio_pci_mmap-v2-1-0dc6c139a4f1@linux.ibm.com>
References: <20240523-vfio_pci_mmap-v2-0-0dc6c139a4f1@linux.ibm.com>
In-Reply-To: <20240523-vfio_pci_mmap-v2-0-0dc6c139a4f1@linux.ibm.com>
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
        kvm@vger.kernel.org, Niklas Schnelle <schnelle@linux.ibm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
X-Mailer: b4 0.12.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1929;
 i=schnelle@linux.ibm.com; h=from:subject:message-id;
 bh=V9p54K0J4aEM5NILVOof+HaaDipCamwYqPH+otYYUpU=;
 b=owGbwMvMwCH2Wz534YHOJ2GMp9WSGNL8VRSVTt048ayW409BpsqFyI9GvTo1efy571dUmEv7i
 W7LWjS7o5SFQYyDQVZMkWVRl7PfuoIppnuC+jtg5rAygQxh4OIUgIlYGTMyPLf0YzE4l74tW/aL
 dLxZeDlvVr3kYbkbBzRmLOf+KOewlJFh++F9xXwaxx9e0t9U4Hj7UnGH38fnEj8NDe/JdYSrn6t
 mBAA=
X-Developer-Key: i=schnelle@linux.ibm.com; a=openpgp;
 fpr=9DB000B2D2752030A5F72DDCAFE43F15E8C26090
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: iGZWZvNzKYdq6YLi-4JCW5cmVp9v1HQP
X-Proofpoint-ORIG-GUID: k7dGvF_7I8BFoeEYrO8o0_q_BADXgR94
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-23_07,2024-05-23_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 lowpriorityscore=0 adultscore=0 mlxscore=0 impostorscore=0 bulkscore=0
 phishscore=0 priorityscore=1501 clxscore=1015 spamscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405230075

The s390 MMIO syscalls when using the classic PCI instructions do not
cause a page fault when follow_pte() fails due to the page not being
present. Besides being a general deficiency this breaks vfio-pci's mmap()
handling once VFIO_PCI_MMAP gets enabled as this lazily maps on first
access. Fix this by following a failed follow_pte() with
fixup_user_page() and retrying the follow_pte().

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
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


