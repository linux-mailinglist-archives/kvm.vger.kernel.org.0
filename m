Return-Path: <kvm+bounces-37969-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DBA56A32A0D
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 16:30:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E7270167D50
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 15:30:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F23C724C674;
	Wed, 12 Feb 2025 15:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="dOh8NnoA"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A25A821323D;
	Wed, 12 Feb 2025 15:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739374188; cv=none; b=HOm16G5fhFQ7JbP+cUMmpGGLEloFJru7LmLXWxPPw+kliCQF2sazc7LEAB1bKjtJ57diRvO2azYZWtPKdfe18fGICpxFvGhtYIZ+JU3nbBKJQIi1ce6oUBm1+qam0sEC1/zwBft4T64l/Aq+sHF+SHDBAGDg/iTjVCempSBoLp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739374188; c=relaxed/simple;
	bh=QnE3MWbyEccydmUgWLoslOgDk1WgUiqPUae/4stuq/o=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=WmDQhOvXvyBfz3hq2GDyxJlBpdjpxUpCW3kDOYxyg7kgpBG0DZrmX3Wup42CLi6MC86Dtcv8iWIN3CL6/mS4NOIGyIOgvQaaIgyuqVIhWnudyvWQrdC7B54MhYFvYLbN0g2M7rJf8upkeAglx4fdSWBs9O+QsuRjWjQgK1Y6K2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=dOh8NnoA; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51CEUEWl003123;
	Wed, 12 Feb 2025 15:29:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=nv+m3o
	J4hLmiasN4bXS5CzCbQltOL5gRuC2PqhirWos=; b=dOh8NnoAFpMI78KtdoRHL1
	V5NY91aLmN3z34XqAO4pKsBkW5h/TCGr6ql3qm7EYB/nqMvFo/2t/ZZqQfkRfyTF
	FeyL75uTghQGmfM+2LP28QmT0TP0bQw4XDvuK69wWjSWs4FEO1ozeNYXj3aPkoIh
	3gI6+p0yaCAF8Eqs6OAdzk1CBXIKPu2TFwm04m3JXvtjUiIDC3HLKYHe7djK2TU4
	19GglOSWs4TMUX3UfU1bwnEhtaEUnpU5LiJidBUHA3LIzRidXachknEjoFVXULdh
	1gQf8eI6ASgcRxdHYrzZ0SiUK/hMEYfIylTF237GMnfMDu0jM6dNYOh3nKiyPKOg
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44rnf8b2xg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 12 Feb 2025 15:29:39 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 51CFShO4004327;
	Wed, 12 Feb 2025 15:29:30 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44rnf8b2vp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 12 Feb 2025 15:28:59 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51CD2ans000978;
	Wed, 12 Feb 2025 15:28:58 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44pjkn9h1n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 12 Feb 2025 15:28:58 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51CFSvHK60490028
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 12 Feb 2025 15:28:57 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 62E0B5805C;
	Wed, 12 Feb 2025 15:28:57 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C53F258059;
	Wed, 12 Feb 2025 15:28:53 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 12 Feb 2025 15:28:53 +0000 (GMT)
From: Niklas Schnelle <schnelle@linux.ibm.com>
Date: Wed, 12 Feb 2025 16:28:31 +0100
Subject: [PATCH v5 1/2] s390/pci: Fix s390_mmio_read/write syscall page
 fault handling
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250212-vfio_pci_mmap-v5-1-633ca5e056da@linux.ibm.com>
References: <20250212-vfio_pci_mmap-v5-0-633ca5e056da@linux.ibm.com>
In-Reply-To: <20250212-vfio_pci_mmap-v5-0-633ca5e056da@linux.ibm.com>
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
 b=owGbwMvMwCX2Wz534YHOJ2GMp9WSGNLX7FPNyX8wd8k1zz6fr5rmK88EbzF2O/f6rZfz5rM/O
 iKz97y53lHKwiDGxSArpsiyqMvZb13BFNM9Qf0dMHNYmUCGMHBxCsBEnnAxMjwybXDjCV0lYvH2
 54c3j69O635hbNb+/6DTQdvsat9dP+cxMmxafG93f08gr4Pd/gmLU4WvX57ieb/18eUGJuUpa87
 v28oIAA==
X-Developer-Key: i=schnelle@linux.ibm.com; a=openpgp;
 fpr=9DB000B2D2752030A5F72DDCAFE43F15E8C26090
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: MBfOb8dmJI0O8VsDPTYH6wZAKeSX9Vd1
X-Proofpoint-GUID: k-YFLZocP8KEp3IJEcIje9AzeBpu0EXE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-12_05,2025-02-11_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 mlxscore=0 adultscore=0 mlxlogscore=948 priorityscore=1501
 bulkscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0 phishscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2501170000 definitions=main-2502120117

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


