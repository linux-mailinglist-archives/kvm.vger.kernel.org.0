Return-Path: <kvm+bounces-18931-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 88F658FD25B
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 18:02:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A0A9B1C23B2A
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 16:02:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 594F2188CDF;
	Wed,  5 Jun 2024 16:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="CxpqAd3Y"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C11E15EFA8;
	Wed,  5 Jun 2024 16:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717603296; cv=none; b=V8nBgE32HXwHpASQg88tNlup4h60uE23sdvkZvCxuYdIP/WyYZV5e36zBCU7O0tQsHp4Did/PjTjzPhwTl8+2Jm0GvcBfjGO40ddcWBXB7DurvljALdubbP8XrBrZMmYZYdfekI2Za94ZsvGeCor8iW9X2R4fkZFZ1HiYnPC8gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717603296; c=relaxed/simple;
	bh=iQAyIrRICCXOzYie38P/qQg31l6lN650QiMYDHbKNdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JoPPA4WhmVGGFQd1Xf4ZMyMmdpwDCtNP8gazK7N4ldOQA+LSsYVHlwWKTCylY4SgbGv2sTIXpr0WU5xAAd7JEiuBHmkCNBFFD3kNPl+WXT7IE2qMJeZiE/GAy1Md/9PslJh0IvISda0UM0h9oKW+n6QXi9G0TZQuuaCb7uWWV5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=CxpqAd3Y; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 455EIGtK008935;
	Wed, 5 Jun 2024 16:01:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc :
 content-transfer-encoding : date : from : in-reply-to : message-id :
 mime-version : references : subject : to; s=pp1;
 bh=N/MaCJbJih/E2hvyHi4Smk2YUb6GNmv53OOlkrnwC2k=;
 b=CxpqAd3YsB0atzmPWLAbFIBF+ThZar5lgGjGfVOkCRMcOapLfNaSyKxGU4bFqTcE0xRl
 1opqO1rx5Gd7gT5wFOfH5VvyGgp6r9K+6YOLoZpta4ee0s9KMDAeSl7jNXkzFXmCmVZb
 fSdt8TTehrbOqHTfhC4RFLGaoLR8foENRrCbYmvel8WDwIT6Fs5QW9sne5ltKYg6BMiO
 zcLEmtSVJBboC8fgqYTNi93FQgnIFi1Pv5sTb+sS3T0dOvs+qS9dL3aXH4X9h/PDHLSJ
 HeFk8sVh5YwpsI9ONZRiS6LTQlKZoiwH8mJYJ+wOgh/M8VtweLRXwwesuI6vdpe3m2ce ZQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yjsnj0aam-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 16:01:29 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 455G1TQr010558;
	Wed, 5 Jun 2024 16:01:29 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yjsnj0aag-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 16:01:29 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 455FKNES008501;
	Wed, 5 Jun 2024 16:01:28 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3ygec0w96a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 16:01:28 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 455G1LJh50921814
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 5 Jun 2024 16:01:24 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D81E92004B;
	Wed,  5 Jun 2024 16:01:21 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A9C9920063;
	Wed,  5 Jun 2024 16:01:21 +0000 (GMT)
Received: from dilbert5.boeblingen.de.ibm.com (unknown [9.152.224.39])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  5 Jun 2024 16:01:21 +0000 (GMT)
From: Gerd Bayer <gbayer@linux.ibm.com>
To: Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Ramesh Thomas <ramesh.thomas@intel.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Ankit Agrawal <ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
        Halil Pasic <pasic@linux.ibm.com>, Ben Segal <bpsegal@us.ibm.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Julian Ruess <julianr@linux.ibm.com>,
        Gerd Bayer <gbayer@linux.ibm.com>
Subject: [PATCH v5 2/3] vfio/pci: Support 8-byte PCI loads and stores
Date: Wed,  5 Jun 2024 18:01:11 +0200
Message-ID: <20240605160112.925957-3-gbayer@linux.ibm.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240605160112.925957-1-gbayer@linux.ibm.com>
References: <20240605160112.925957-1-gbayer@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 6iumrZRuHE8S9cJKAoMTbDD3iWaAKbHg
X-Proofpoint-GUID: 57P5KMD7DFQfbEYvSpwpEaAEksIut6pd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-05_02,2024-06-05_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 adultscore=0 mlxscore=0 lowpriorityscore=0 clxscore=1015
 priorityscore=1501 phishscore=0 spamscore=0 malwarescore=0 impostorscore=0
 mlxlogscore=648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406050121

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
 drivers/vfio/pci/vfio_pci_rdwr.c | 16 ++++++++++++++++
 include/linux/vfio_pci_core.h    |  3 +++
 2 files changed, 19 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index d07bfb0ab892..66b72c289284 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -89,6 +89,9 @@ EXPORT_SYMBOL_GPL(vfio_pci_core_ioread##size);
 VFIO_IOREAD(8)
 VFIO_IOREAD(16)
 VFIO_IOREAD(32)
+#ifdef ioread64
+VFIO_IOREAD(64)
+#endif
 
 #define VFIO_IORDWR(size)						\
 static int vfio_pci_iordwr##size(struct vfio_pci_core_device *vdev,\
@@ -124,6 +127,10 @@ static int vfio_pci_iordwr##size(struct vfio_pci_core_device *vdev,\
 VFIO_IORDWR(8)
 VFIO_IORDWR(16)
 VFIO_IORDWR(32)
+#if defined(ioread64) && defined(iowrite64)
+VFIO_IORDWR(64)
+#endif
+
 /*
  * Read or write from an __iomem region (MMIO or I/O port) with an excluded
  * range which is inaccessible.  The excluded range drops writes and fills
@@ -148,6 +155,15 @@ ssize_t vfio_pci_core_do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
 		else
 			fillable = 0;
 
+#if defined(ioread64) && defined(iowrite64)
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
index a2c8b8bba711..f4cf5fd2350c 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -157,5 +157,8 @@ int vfio_pci_core_ioread##size(struct vfio_pci_core_device *vdev,	\
 VFIO_IOREAD_DECLATION(8)
 VFIO_IOREAD_DECLATION(16)
 VFIO_IOREAD_DECLATION(32)
+#ifdef ioread64
+VFIO_IOREAD_DECLATION(64)
+#endif
 
 #endif /* VFIO_PCI_CORE_H */
-- 
2.45.1


