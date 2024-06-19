Return-Path: <kvm+bounces-19977-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5817790EA3C
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 13:59:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5CEC51C219B7
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 11:59:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDEDD13212E;
	Wed, 19 Jun 2024 11:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="A09O+GRM"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0D9132101;
	Wed, 19 Jun 2024 11:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718798356; cv=none; b=qBBDWt1zXvXp3iHeiza7BgUp5dqDlQsOPJBsbxJz5H/7STnrqz9DxW14leVjsx6+T81C9aPgCXFo89gKPeQswgmHbLdOxdjV7RjvnSlf5akbM8P/vF93cvgNUcRMkGb6YeWJxpyvff65W8ptbvLq1QdLakz4fezyRWnBwIhjVDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718798356; c=relaxed/simple;
	bh=YyEcWVBeOGi4MYquWyDLAUKLPG8vMzvIS8Ap2qQPLTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HM27NsTTos/EryG0xWCV6jV6aexCKUvTMdWWIsEZXfLOARmYUcerefiOwHP6kL46j/N7XSMTamax0YINv069B/Y5tBrHLBZpgOArl+ERRAonPmkHrpsSxxJwGBMf5332m6TdR3PsGa2obVzWQFQlPy3X8i3vq9QkLztsqYsL80g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=A09O+GRM; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45JBxAfV024043;
	Wed, 19 Jun 2024 11:59:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=pp1; bh=sT04IboydSSml
	Pnv+7Uj2w68/y1h0FfLRXqjFEVHhTM=; b=A09O+GRMlp9EmdN3lz7Y+Co5jecfA
	GyojLc+kWzwWlxX5K/hVwe0HdU2Iz/ezxuMKpFooAglLu7BYZBF1iE6PFL0yNnvY
	/dsztxFenAZh6+W5dYIV7Zcpg9FgkPAOtCi5T5G7+i0x20VOfV97TvWS9uP6jGsW
	JZNvwmaiu2s0UjTqoZpqE6HiHXIJwBdTju/p78NJFjuDzeVDfzk02NCK/+3VXkCk
	5xf9OfMNq1IsAZhhtpAS+Ef6ORqNdAyM7GbC3D1SlUVOPKDgEz/tHF+s+CUYqlDN
	iPxDWdIS7nVkesvLIxbGaCwai94iwonTyrXwkatThsJpAOPZ1nQ8H/1/A==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yuxx3801d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Jun 2024 11:59:10 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45JBx9bE024026;
	Wed, 19 Jun 2024 11:59:09 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yuxx3801a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Jun 2024 11:59:09 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45JA3QOm006216;
	Wed, 19 Jun 2024 11:59:08 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3ysn9uvb7x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Jun 2024 11:59:08 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45JBx34g52101516
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Jun 2024 11:59:05 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 052AC20040;
	Wed, 19 Jun 2024 11:59:03 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ACF8C2004F;
	Wed, 19 Jun 2024 11:59:02 +0000 (GMT)
Received: from dilbert5.boeblingen.de.ibm.com (unknown [9.152.212.201])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 19 Jun 2024 11:59:02 +0000 (GMT)
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
Subject: [PATCH v6 1/3] vfio/pci: Extract duplicated code into macro
Date: Wed, 19 Jun 2024 13:58:45 +0200
Message-ID: <20240619115847.1344875-2-gbayer@linux.ibm.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619115847.1344875-1-gbayer@linux.ibm.com>
References: <20240619115847.1344875-1-gbayer@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: pkA6DGAbuZZykhK9IbiOIPiH4qliaILH
X-Proofpoint-GUID: hNCjMwzRPqrDP3AwD3QBa3IpN__ugmEJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-19_02,2024-06-19_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 malwarescore=0
 clxscore=1015 spamscore=0 priorityscore=1501 impostorscore=0 bulkscore=0
 phishscore=0 mlxscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2405170001
 definitions=main-2406190088

vfio_pci_core_do_io_rw() repeats the same code for multiple access
widths. Factor this out into a macro

Suggested-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Gerd Bayer <gbayer@linux.ibm.com>
---
 drivers/vfio/pci/vfio_pci_rdwr.c | 106 ++++++++++++++-----------------
 1 file changed, 46 insertions(+), 60 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index 03b8f7ada1ac..d07bfb0ab892 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -90,6 +90,40 @@ VFIO_IOREAD(8)
 VFIO_IOREAD(16)
 VFIO_IOREAD(32)
 
+#define VFIO_IORDWR(size)						\
+static int vfio_pci_iordwr##size(struct vfio_pci_core_device *vdev,\
+				bool iswrite, bool test_mem,		\
+				void __iomem *io, char __user *buf,	\
+				loff_t off, size_t *filled)		\
+{									\
+	u##size val;							\
+	int ret;							\
+									\
+	if (iswrite) {							\
+		if (copy_from_user(&val, buf, sizeof(val)))		\
+			return -EFAULT;					\
+									\
+		ret = vfio_pci_core_iowrite##size(vdev, test_mem,	\
+						  val, io + off);	\
+		if (ret)						\
+			return ret;					\
+	} else {							\
+		ret = vfio_pci_core_ioread##size(vdev, test_mem,	\
+						 &val, io + off);	\
+		if (ret)						\
+			return ret;					\
+									\
+		if (copy_to_user(buf, &val, sizeof(val)))		\
+			return -EFAULT;					\
+	}								\
+									\
+	*filled = sizeof(val);						\
+	return 0;							\
+}									\
+
+VFIO_IORDWR(8)
+VFIO_IORDWR(16)
+VFIO_IORDWR(32)
 /*
  * Read or write from an __iomem region (MMIO or I/O port) with an excluded
  * range which is inaccessible.  The excluded range drops writes and fills
@@ -115,71 +149,23 @@ ssize_t vfio_pci_core_do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
 			fillable = 0;
 
 		if (fillable >= 4 && !(off % 4)) {
-			u32 val;
-
-			if (iswrite) {
-				if (copy_from_user(&val, buf, 4))
-					return -EFAULT;
-
-				ret = vfio_pci_core_iowrite32(vdev, test_mem,
-							      val, io + off);
-				if (ret)
-					return ret;
-			} else {
-				ret = vfio_pci_core_ioread32(vdev, test_mem,
-							     &val, io + off);
-				if (ret)
-					return ret;
-
-				if (copy_to_user(buf, &val, 4))
-					return -EFAULT;
-			}
+			ret = vfio_pci_iordwr32(vdev, iswrite, test_mem,
+						io, buf, off, &filled);
+			if (ret)
+				return ret;
 
-			filled = 4;
 		} else if (fillable >= 2 && !(off % 2)) {
-			u16 val;
-
-			if (iswrite) {
-				if (copy_from_user(&val, buf, 2))
-					return -EFAULT;
-
-				ret = vfio_pci_core_iowrite16(vdev, test_mem,
-							      val, io + off);
-				if (ret)
-					return ret;
-			} else {
-				ret = vfio_pci_core_ioread16(vdev, test_mem,
-							     &val, io + off);
-				if (ret)
-					return ret;
-
-				if (copy_to_user(buf, &val, 2))
-					return -EFAULT;
-			}
+			ret = vfio_pci_iordwr16(vdev, iswrite, test_mem,
+						io, buf, off, &filled);
+			if (ret)
+				return ret;
 
-			filled = 2;
 		} else if (fillable) {
-			u8 val;
-
-			if (iswrite) {
-				if (copy_from_user(&val, buf, 1))
-					return -EFAULT;
-
-				ret = vfio_pci_core_iowrite8(vdev, test_mem,
-							     val, io + off);
-				if (ret)
-					return ret;
-			} else {
-				ret = vfio_pci_core_ioread8(vdev, test_mem,
-							    &val, io + off);
-				if (ret)
-					return ret;
-
-				if (copy_to_user(buf, &val, 1))
-					return -EFAULT;
-			}
+			ret = vfio_pci_iordwr8(vdev, iswrite, test_mem,
+					       io, buf, off, &filled);
+			if (ret)
+				return ret;
 
-			filled = 1;
 		} else {
 			/* Fill reads with -1, drop writes */
 			filled = min(count, (size_t)(x_end - off));
-- 
2.45.2


