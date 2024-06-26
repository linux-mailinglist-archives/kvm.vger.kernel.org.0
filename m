Return-Path: <kvm+bounces-20543-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BA28917F6F
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 13:18:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7F72A1F2406D
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 11:18:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A3B1181D11;
	Wed, 26 Jun 2024 11:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="jr2pO+dv"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02778181B87;
	Wed, 26 Jun 2024 11:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719400608; cv=none; b=i8NzdKih6z9PY1Sw8n0C8JxLSlyesrjzPxJJpORrFZnDcpAXVXNL/ClcqYLk3ex/G+3b2+OR/rY6yBJF7mhC5jag7xlLM4U1CNnGaYUtnDdEBcjPO04BRrK5YQ5r7ixlFoWG4TPeO6dfXBYeF4GxBnwNotfhNYDgsAS5BfId8Zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719400608; c=relaxed/simple;
	bh=+mwCt0KjL/HCJrkvf+Tt2TRp3JF3pn6sfN6Ag8jhg2g=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=r2OcBKDTBQRaUNrUikPk7CXMEDZj7gyHxmJdTi3XXuLobfUwrxMob9O3r9iUqw+yWCJFuLZEzEx0yB+5GgHP1yS2rN35vIoXXB8rI93vDxK1mrc5oWCID67d+ZECNIKokcYU6lb0boQGx1lrrcqzO4MfkowKeJ4ZbspgHSsDhxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=jr2pO+dv; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45QB0ARH008665;
	Wed, 26 Jun 2024 11:16:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:date:subject:content-type:message-id:references:in-reply-to:to
	:cc:content-transfer-encoding:mime-version; s=pp1; bh=3xZ/9RZVyZ
	OhI74Mwtm9Euz5t7EvcqdCMJRHM/H3PGE=; b=jr2pO+dvPgwi4YfgP+6ZXlORgX
	FN+1R6hwBqkjyDCqQLzCFrfMPN6zf7oJskv8ZuaroV/Ql7itA53/4qewFlmp8hIi
	50sIqSFmeGGBJuplYIe3iVMcNPXe9XyLooC4sMEwaoZRyLP1izucaYBcVYR7WJRV
	/9mDm0GPPCarZc9vMwbo7GnygnCZPrHkxRpqyNC5RunfTNmB3vCt03i575lRHoMt
	b3b5Op1fdBrVNBpir+allfK0xkf9Y1VvFbJd47QAVUwHmwa9BJQXIrj6EkfwpX2/
	QfV9F2zNqCSFb+fwkvsI8fF3pAeoZrdNHUuVDIOiyUmvMKfFoVXaoZT0auXA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 400hq681h5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Jun 2024 11:16:41 +0000 (GMT)
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45QBGek8000714;
	Wed, 26 Jun 2024 11:16:40 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 400hq681h2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Jun 2024 11:16:40 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45QB09jh018103;
	Wed, 26 Jun 2024 11:16:40 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3yx8xucb71-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Jun 2024 11:16:40 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45QBGadw19923570
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Jun 2024 11:16:38 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8CEFD58053;
	Wed, 26 Jun 2024 11:16:36 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D8C5958059;
	Wed, 26 Jun 2024 11:16:33 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 26 Jun 2024 11:16:33 +0000 (GMT)
From: Niklas Schnelle <schnelle@linux.ibm.com>
Date: Wed, 26 Jun 2024 13:15:51 +0200
Subject: [PATCH v4 4/4] vfio/pci: Enable PCI resource mmap() on s390 and
 remove VFIO_PCI_MMAP
Content-Type: text/plain; charset="utf-8"
Message-Id: <20240626-vfio_pci_mmap-v4-4-7f038870f022@linux.ibm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1848;
 i=schnelle@linux.ibm.com; h=from:subject:message-id;
 bh=+mwCt0KjL/HCJrkvf+Tt2TRp3JF3pn6sfN6Ag8jhg2g=;
 b=owGbwMvMwCH2Wz534YHOJ2GMp9WSGNKqfzTE27dlhUz80nRM6ljXoarZr5fPTi8+4Dd/9qnG4
 Ljq4vP3O0pZGMQ4GGTFFFkWdTn7rSuYYronqL8DZg4rE8gQBi5OAZjIt5WMDD/XL03vlmIt6vJ4
 VZFx9IGB3U8Js4m3F7xNXiMcdSpm/3RGhj8izAdjZVr1VRm551sqdmi+Mes6/pJN02rJy1XSaw7
 85wQA
X-Developer-Key: i=schnelle@linux.ibm.com; a=openpgp;
 fpr=9DB000B2D2752030A5F72DDCAFE43F15E8C26090
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: leImJWFe1E6NHv27ByZKgxfFYxT7_oZU
X-Proofpoint-ORIG-GUID: Sv4DQYDvfHDxVbJu8Ms9huLczwKsS2rQ
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-26_05,2024-06-25_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 spamscore=0 priorityscore=1501 lowpriorityscore=0 impostorscore=0
 mlxlogscore=739 suspectscore=0 adultscore=0 phishscore=0 bulkscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2406260082

With the introduction of memory I/O (MIO) instructions enbaled in commit
71ba41c9b1d9 ("s390/pci: provide support for MIO instructions") s390
gained support for direct user-space access to mapped PCI resources.
Even without those however user-space can access mapped PCI resources
via the s390 specific MMIO syscalls. Thus mmap() can and should be
supported on all s390 systems with native PCI. Since VFIO_PCI_MMAP
enablement for s390 would make it unconditionally true and thus
pointless just remove it entirely.

Link: https://lore.kernel.org/all/c5ba134a1d4f4465b5956027e6a4ea6f6beff969.camel@linux.ibm.com/
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
---
 drivers/vfio/pci/Kconfig         | 4 ----
 drivers/vfio/pci/vfio_pci_core.c | 3 ---
 2 files changed, 7 deletions(-)

diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index bf50ffa10bde..c3bcb6911c53 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -7,10 +7,6 @@ config VFIO_PCI_CORE
 	select VFIO_VIRQFD
 	select IRQ_BYPASS_MANAGER
 
-config VFIO_PCI_MMAP
-	def_bool y if !S390
-	depends on VFIO_PCI_CORE
-
 config VFIO_PCI_INTX
 	def_bool y if !S390
 	depends on VFIO_PCI_CORE
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 0e9d46575776..c08d0f7bb500 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -120,9 +120,6 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_core_device *vdev)
 
 		res = &vdev->pdev->resource[bar];
 
-		if (!IS_ENABLED(CONFIG_VFIO_PCI_MMAP))
-			goto no_mmap;
-
 		if (!(res->flags & IORESOURCE_MEM))
 			goto no_mmap;
 

-- 
2.40.1


