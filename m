Return-Path: <kvm+bounces-18036-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EC558CD0F5
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 13:12:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 514C61C2106E
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 11:12:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF092148FF1;
	Thu, 23 May 2024 11:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="iQ0zFqkT"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E6FF148851;
	Thu, 23 May 2024 11:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716462644; cv=none; b=he67MBCvejrkj83+aelGZqHblPDMpEQE6w64iOQV5I12aYGqvqkMFaR7jRuhMmnDSpQ/5x7ybLAnxSa3qHPAq4CKY5sBF1KIvesvTE2rV9Xkf+aX8WZEoxZkAxDfZDGav5H/zQrhy0sqCp9+IFAThmZsq+/q4YwGFJkYOBlOjH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716462644; c=relaxed/simple;
	bh=xFDYkQ31agauxEnb+RJfu3aRPWfDgM3XvcsjfdaOPYI=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=N6TTNOskwZCcydeGWSh2+nL2wK6YF9PqIGkCeMwonGrx9wSiPr6i/wkII8CNsyFXeI8VCrenZPKWQdymXU5ZvZ98bPOeq4Yk3O6asq9iYg4qLFud4Bh0dMehEHXeF6fe/eJI7bRoJpeLjKF5hyX98ij+zJOP2vSYxs+Ur4QcM6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=iQ0zFqkT; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44NAcFgL016159;
	Thu, 23 May 2024 11:10:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : date : subject :
 content-type : message-id : references : in-reply-to : to : cc :
 content-transfer-encoding : mime-version; s=pp1;
 bh=Y8onIuiYoME4KQUFK1+RysiIFUJ20afFaE21ZSfAPXQ=;
 b=iQ0zFqkTpjg3kZh26q2+GutGvMCreBdAfZ7MJUxydkce12P8QjWykkpAWYxVCmdBDnn3
 JKtSojL7+YI40G17gE2+Yz+Hdnaf2QlcuO/EVRxH/ML+8OpQM/nV+7xU2VrfG080GNMm
 72jMkayrhShtjKVhv2kFAUdEK4t6n6S59bTIKsPRUFT7jFXax+z3tnwj/qNLnoZx9ERZ
 QNd8miTEYFfpAm/X+bWblGww4IXqKP4qxJVndnn97ktWF7k7tMGaAzuiRm247KSFonzF
 Okz8yvB4fLmdWz8jahyYDTmSAZ8mrItKaGVYy6Jd3b3pTmGyIGD2ZG2Kzr2nTFv1eYdS qQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ya47hg2gx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 May 2024 11:10:40 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44NBAe1D031822;
	Thu, 23 May 2024 11:10:40 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ya47hg2gu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 May 2024 11:10:40 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 44NAu9nF023498;
	Thu, 23 May 2024 11:10:39 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3y77nphng5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 May 2024 11:10:39 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 44NBAabg34341310
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 May 2024 11:10:38 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3FA9A58056;
	Thu, 23 May 2024 11:10:36 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D819358064;
	Thu, 23 May 2024 11:10:33 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 23 May 2024 11:10:33 +0000 (GMT)
From: Niklas Schnelle <schnelle@linux.ibm.com>
Date: Thu, 23 May 2024 13:10:16 +0200
Subject: [PATCH v2 3/3] vfio/pci: Enable PCI resource mmap() on s390 and
 remove VFIO_PCI_MMAP
Content-Type: text/plain; charset="utf-8"
Message-Id: <20240523-vfio_pci_mmap-v2-3-0dc6c139a4f1@linux.ibm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1747;
 i=schnelle@linux.ibm.com; h=from:subject:message-id;
 bh=xFDYkQ31agauxEnb+RJfu3aRPWfDgM3XvcsjfdaOPYI=;
 b=owGbwMvMwCH2Wz534YHOJ2GMp9WSGNL8VRQFt/wQ+WVylOOgePOTsB+r9jnujUnsMFrmZneOY
 xVDxFHljlIWBjEOBlkxRZZFXc5+6wqmmO4J6u+AmcPKBDKEgYtTACayYi8jw1T2WVX/t2xM6Nrg
 xr7np8ySOdy8L86Fpa46/Ssl2uiY7FJGhltHy+8eEglw9mU/lS2tcC5PKKJaV7H3tRqH8P1Zrts
 ncgIA
X-Developer-Key: i=schnelle@linux.ibm.com; a=openpgp;
 fpr=9DB000B2D2752030A5F72DDCAFE43F15E8C26090
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: P_BSAzHhTWNgdymQtQERI6gc8iQGG_aM
X-Proofpoint-GUID: n5WkyoZqob1aPPrHcsBhKTzwqkEbfWGk
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-23_07,2024-05-23_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 impostorscore=0 adultscore=0 mlxlogscore=782 malwarescore=0
 spamscore=0 phishscore=0 suspectscore=0 clxscore=1015 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405230075

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
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
---
 drivers/vfio/pci/Kconfig         | 4 ----
 drivers/vfio/pci/vfio_pci_core.c | 3 ---
 2 files changed, 7 deletions(-)

diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index 15821a2d77d2..9c88e3a6d06b 100644
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
index 23961299b695..35b8e8f214af 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -121,9 +121,6 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_core_device *vdev)
 
 		res = &vdev->pdev->resource[bar];
 
-		if (!IS_ENABLED(CONFIG_VFIO_PCI_MMAP))
-			goto no_mmap;
-
 		if (!(res->flags & IORESOURCE_MEM))
 			goto no_mmap;
 

-- 
2.40.1


