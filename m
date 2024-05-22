Return-Path: <kvm+bounces-17964-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CA368CC3CB
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 17:07:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A014F1C22DE2
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 15:07:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B00D2EAF9;
	Wed, 22 May 2024 15:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="TKtO51m2"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9E422F0D;
	Wed, 22 May 2024 15:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716390439; cv=none; b=bX02BONuSxnKxOHV02JqkXR15/JCFiFq7QguWX3xa3JHH7KtWbpWlHM+eaMhCOBJcI57i2gbT/+lOo1E30fsi7qCcVSYliO/33ITxoaEXTwGvgCnPVv1pD/XgPGHq9ycyq+s6Iz1fWVqr9Pepwb47W1wlksq7whfDkrn0d1tMEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716390439; c=relaxed/simple;
	bh=laHnFTQIKbL65jMwozRynkC4o8GH8XYBxUiKSdkvmnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZqhXskBpg/pO+6R1IcteuRN4HWdLdO7vQvcr9AD/1fZGaqQr8P7Gh9F/e8kFMXVEEgbiq5TxXLRXAB1pCKaVlBPAyf+OALRRjZrsV1C+3cEjo94XSusY1qVSoME3gpeBUundM90KIn05wmUaR4txppE9gZaD86PYW+FF3noXUes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=TKtO51m2; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44MF4SRo030703;
	Wed, 22 May 2024 15:07:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=A0mEbv6AfCj92khCzq5gp4F0ljpDqbLkIHM9IdxeUBY=;
 b=TKtO51m2sAKakQZif3rs8RnSuEULslhanSIcj1Jxr1kO3SVb6NLliKZB5MsfPPkXgJg3
 5kp41xOOK1d+2Z9BZFZQCc09NJkgCCS/B3RMamCQGHFoHE43ilhaEGrDvvda6Pnoer6z
 ubJpoOF9bRlgoo7erBWaomloch0+6YOF4ErEBxZGhOikNL/UgaiWHUJjmsEK4p1OpSwa
 af2oDEXR/lizVfK7LFYkpElB7u9YpIiqQEcJVc8t8Xx92AMHUwzpZte8tqlydVX0Bnv1
 NQCoRJafqFc20ffrDVezSGijcEckul2wUrKsE6ZnQ9FogxFr+tDih2RiCqffwDSvFnVQ Lg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3y9k0ug08u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 May 2024 15:07:07 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44MF76bw002249;
	Wed, 22 May 2024 15:07:06 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3y9k0ug08r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 May 2024 15:07:06 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 44MC7JZk008226;
	Wed, 22 May 2024 15:07:06 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3y78vm464q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 May 2024 15:07:05 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 44MF70pa52101448
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 May 2024 15:07:02 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4D4D92004B;
	Wed, 22 May 2024 15:07:00 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E4FA220067;
	Wed, 22 May 2024 15:06:59 +0000 (GMT)
Received: from dilbert5.boeblingen.de.ibm.com (unknown [9.155.208.153])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 22 May 2024 15:06:59 +0000 (GMT)
From: Gerd Bayer <gbayer@linux.ibm.com>
To: Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Ramesh Thomas <ramesh.thomas@intel.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Ankit Agrawal <ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Julian Ruess <julianr@linux.ibm.com>, Ben Segal <bpsegal@us.ibm.com>,
        Gerd Bayer <gbayer@linux.ibm.com>
Subject: [PATCH v4 2/3] vfio/pci: Support 8-byte PCI loads and stores
Date: Wed, 22 May 2024 17:06:50 +0200
Message-ID: <20240522150651.1999584-3-gbayer@linux.ibm.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240522150651.1999584-1-gbayer@linux.ibm.com>
References: <20240522150651.1999584-1-gbayer@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: PgL5pYU9Q-UNW5JDY0_8686sGxsQ24wB
X-Proofpoint-ORIG-GUID: ENL1ylKRUpmOWzwIyO4nqx9MpxgD9VJF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-22_08,2024-05-22_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 adultscore=0 spamscore=0 priorityscore=1501 mlxlogscore=697
 bulkscore=0 mlxscore=0 malwarescore=0 impostorscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405220101

From: Ben Segal <bpsegal@us.ibm.com>

Many PCI adapters can benefit or even require full 64bit read
and write access to their registers. In order to enable work on
user-space drivers for these devices add two new variations
vfio_pci_core_io{read|write}64 of the existing access methods
when the architecture supports 64-bit ioreads and iowrites.

Signed-off-by: Ben Segal <bpsegal@us.ibm.com>
Co-developed-by: Gerd Bayer <gbayer@linux.ibm.com>
Signed-off-by: Gerd Bayer <gbayer@linux.ibm.com>
---
 drivers/vfio/pci/vfio_pci_rdwr.c | 18 +++++++++++++++++-
 include/linux/vfio_pci_core.h    |  5 ++++-
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index d07bfb0ab892..07351ea76604 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -61,7 +61,7 @@ EXPORT_SYMBOL_GPL(vfio_pci_core_iowrite##size);
 VFIO_IOWRITE(8)
 VFIO_IOWRITE(16)
 VFIO_IOWRITE(32)
-#ifdef iowrite64
+#ifdef CONFIG_64BIT
 VFIO_IOWRITE(64)
 #endif
 
@@ -89,6 +89,9 @@ EXPORT_SYMBOL_GPL(vfio_pci_core_ioread##size);
 VFIO_IOREAD(8)
 VFIO_IOREAD(16)
 VFIO_IOREAD(32)
+#ifdef CONFIG_64BIT
+VFIO_IOREAD(64)
+#endif
 
 #define VFIO_IORDWR(size)						\
 static int vfio_pci_iordwr##size(struct vfio_pci_core_device *vdev,\
@@ -124,6 +127,10 @@ static int vfio_pci_iordwr##size(struct vfio_pci_core_device *vdev,\
 VFIO_IORDWR(8)
 VFIO_IORDWR(16)
 VFIO_IORDWR(32)
+#if CONFIG_64BIT
+VFIO_IORDWR(64)
+#endif
+
 /*
  * Read or write from an __iomem region (MMIO or I/O port) with an excluded
  * range which is inaccessible.  The excluded range drops writes and fills
@@ -148,6 +155,15 @@ ssize_t vfio_pci_core_do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
 		else
 			fillable = 0;
 
+#if CONFIG_64BIT
+		if (fillable >= 8 && !(off % 8)) {
+			ret = vfio_pci_iordwr64(vdev, iswrite, test_mem,
+						io, buf, off, &filled);
+			if (ret)
+				return ret;
+
+		} else
+#endif
 		if (fillable >= 4 && !(off % 4)) {
 			ret = vfio_pci_iordwr32(vdev, iswrite, test_mem,
 						io, buf, off, &filled);
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index a2c8b8bba711..5f9b02d4a3e9 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -146,7 +146,7 @@ int vfio_pci_core_iowrite##size(struct vfio_pci_core_device *vdev,	\
 VFIO_IOWRITE_DECLATION(8)
 VFIO_IOWRITE_DECLATION(16)
 VFIO_IOWRITE_DECLATION(32)
-#ifdef iowrite64
+#ifdef CONFIG_64BIT
 VFIO_IOWRITE_DECLATION(64)
 #endif
 
@@ -157,5 +157,8 @@ int vfio_pci_core_ioread##size(struct vfio_pci_core_device *vdev,	\
 VFIO_IOREAD_DECLATION(8)
 VFIO_IOREAD_DECLATION(16)
 VFIO_IOREAD_DECLATION(32)
+#ifdef CONFIG_64BIT
+VFIO_IOREAD_DECLATION(64)
+#endif
 
 #endif /* VFIO_PCI_CORE_H */
-- 
2.45.0


