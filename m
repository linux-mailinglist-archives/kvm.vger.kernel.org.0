Return-Path: <kvm+bounces-38166-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E9CF8A35EA2
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 14:18:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4D5DD16FFDA
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 13:11:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65CA3264A86;
	Fri, 14 Feb 2025 13:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Q6pUdF5K"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B96423A992;
	Fri, 14 Feb 2025 13:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739538685; cv=none; b=NwOlyPyt4P09/8utpaBuuEP68gwEzcZ9p9eLHAgvOppskyfMtTluXyOgfiE9pABtz3Wjei5+baCdHDvuN+ebBnWzOkaHccLI/LRPPRTTXOWheCI1wCTnQ7YC6tBTzaSRp2MIsg6JgOe81XEDTnTDwRZon05guhgz5FIYyfM/CWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739538685; c=relaxed/simple;
	bh=QnE3MWbyEccydmUgWLoslOgDk1WgUiqPUae/4stuq/o=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=E3aQ4s4cS/EuPFWqfyKWCBjlCZyyZeSah8RoBZfIiJgktwjJCqUtbjsMedEJbJqNyZfecrLDjsw9wtMYehnzuAAp6b7Z++ox+qrn8fuONff3bJttbv1FCIsWIyxSnpU1dP9cfaTjUR2uHMmYERyqMXfv7cyUa5chil2AE3bCUoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Q6pUdF5K; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51EAtB3K000524;
	Fri, 14 Feb 2025 13:11:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=nv+m3o
	J4hLmiasN4bXS5CzCbQltOL5gRuC2PqhirWos=; b=Q6pUdF5KSobwOAEE309b7+
	5GXTa2zQMLDPa/osPRqpDgPxuclJcxQsY/rQxT3yb753mPxlryH+i3Qu+mUTdI16
	h+5/7G60j1YjE53fm1wsEprvAqbvDD/1ypNcUteIAs93CLhsTJ7T61AC9UAY7Ec2
	tPEdKN02Re8cztg3osCUcYNR3TqQTN6jaQgNpLV1fCVDHa5eUROp3LNUtFgIViT4
	GH69PNTUbHuvOANp3C336uS44ySRLRPkDdjDa3f68iusC7AZWuH0QzwRGlmLuHDt
	Xd/zslrU7YDd04trtbZ852GtUlgjghjBzMzJph6euMltP0CPC1rc6/LtuL8I4MPQ
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44ssvabbxy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Feb 2025 13:11:07 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 51ED9QCo027604;
	Fri, 14 Feb 2025 13:11:06 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44ssvabbxw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Feb 2025 13:11:06 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51EBHjpw000924;
	Fri, 14 Feb 2025 13:11:05 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44pjknkphc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Feb 2025 13:11:05 +0000
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51EDB4SA26608160
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Feb 2025 13:11:04 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1D3E85806B;
	Fri, 14 Feb 2025 13:11:04 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4EC4A58067;
	Fri, 14 Feb 2025 13:11:01 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 14 Feb 2025 13:11:01 +0000 (GMT)
From: Niklas Schnelle <schnelle@linux.ibm.com>
Date: Fri, 14 Feb 2025 14:10:52 +0100
Subject: [PATCH v6 1/3] s390/pci: Fix s390_mmio_read/write syscall page
 fault handling
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250214-vfio_pci_mmap-v6-1-6f300cb63a7e@linux.ibm.com>
References: <20250214-vfio_pci_mmap-v6-0-6f300cb63a7e@linux.ibm.com>
In-Reply-To: <20250214-vfio_pci_mmap-v6-0-6f300cb63a7e@linux.ibm.com>
To: Bjorn Helgaas <helgaas@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Gerd Bayer <gbayer@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Thorsten Winkler <twinkler@linux.ibm.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc: Julian Ruess <julianr@linux.ibm.com>, Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pci@vger.kernel.org, Niklas Schnelle <schnelle@linux.ibm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2001;
 i=schnelle@linux.ibm.com; h=from:subject:message-id;
 bh=QnE3MWbyEccydmUgWLoslOgDk1WgUiqPUae/4stuq/o=;
 b=owGbwMvMwCX2Wz534YHOJ2GMp9WSGNLXO9zfKNCZ3LWfy6qHd7uM77EjCm1e0/qmeMk+1Hw42
 eHukvv/O0pZGMS4GGTFFFkWdTn7rSuYYronqL8DZg4rE8gQBi5OAZiIjiUjwwTXwtapG86ujD0o
 /3RKWTbP08DbDD+kHtycIjF7aqyZVSkjw8/ipbHCcas5Ns0+XcE6d63YspzXH50afY1YC3d9eNj
 WwgoA
X-Developer-Key: i=schnelle@linux.ibm.com; a=openpgp;
 fpr=9DB000B2D2752030A5F72DDCAFE43F15E8C26090
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: WFaV4Qu094bww62jFQbPfuU1rdkxorfX
X-Proofpoint-ORIG-GUID: a4BLbTqTnfySI6XOyiNN32nHh0Ng0Ziq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-14_05,2025-02-13_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 mlxscore=0 spamscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 lowpriorityscore=0 phishscore=0 clxscore=1015
 impostorscore=0 mlxlogscore=890 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2501170000 definitions=main-2502140096

The s390 MMIO syscalls when using the classic PCI instructions do not
cause a page fault when follow_pfnmap_start() fails due to the page not
being present. Besides being a general deficiency this breaks vfio-pci's
mmap() handling once VFIO_PCI_MMAP gets enabled as this lazily maps on
first access. Fix this by following a failed follow_pfnmap_start() with
fixup_user_page() and retrying the follow_pfnmap_start(). Also fix
a VM_READ vs VM_WRITE mixup in the read syscall.

Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
---
 arch/s390/pci/pci_mmio.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/s390/pci/pci_mmio.c b/arch/s390/pci/pci_mmio.c
index 46f99dc164ade4ca10f170cd66bdb648f92aa904..1997d9b7965df3b9b6019c7537028cd29d52fc13 100644
--- a/arch/s390/pci/pci_mmio.c
+++ b/arch/s390/pci/pci_mmio.c
@@ -175,8 +175,12 @@ SYSCALL_DEFINE3(s390_pci_mmio_write, unsigned long, mmio_addr,
 	args.address = mmio_addr;
 	args.vma = vma;
 	ret = follow_pfnmap_start(&args);
-	if (ret)
-		goto out_unlock_mmap;
+	if (ret) {
+		fixup_user_fault(current->mm, mmio_addr, FAULT_FLAG_WRITE, NULL);
+		ret = follow_pfnmap_start(&args);
+		if (ret)
+			goto out_unlock_mmap;
+	}
 
 	io_addr = (void __iomem *)((args.pfn << PAGE_SHIFT) |
 			(mmio_addr & ~PAGE_MASK));
@@ -315,14 +319,18 @@ SYSCALL_DEFINE3(s390_pci_mmio_read, unsigned long, mmio_addr,
 	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
 		goto out_unlock_mmap;
 	ret = -EACCES;
-	if (!(vma->vm_flags & VM_WRITE))
+	if (!(vma->vm_flags & VM_READ))
 		goto out_unlock_mmap;
 
 	args.vma = vma;
 	args.address = mmio_addr;
 	ret = follow_pfnmap_start(&args);
-	if (ret)
-		goto out_unlock_mmap;
+	if (ret) {
+		fixup_user_fault(current->mm, mmio_addr, 0, NULL);
+		ret = follow_pfnmap_start(&args);
+		if (ret)
+			goto out_unlock_mmap;
+	}
 
 	io_addr = (void __iomem *)((args.pfn << PAGE_SHIFT) |
 			(mmio_addr & ~PAGE_MASK));

-- 
2.45.2


