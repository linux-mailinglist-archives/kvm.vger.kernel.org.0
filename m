Return-Path: <kvm+bounces-18928-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 050728FD255
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 18:02:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 75C78280E14
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 16:02:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5E4F156F56;
	Wed,  5 Jun 2024 16:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="iCEkBKrY"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6864776A;
	Wed,  5 Jun 2024 16:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717603294; cv=none; b=tQqpRjp87izrIHa60kh3n9mL31LZcUILZSirYJpoD81pxhlDOaEcnD0v3FPc9sPjZn6hFR/aBIYBDQFcEXVVrRds0vlL6lBbVvXI9mJsz4oH2jjOCwECO0linBCEWgdBhGzJHTJtUbtTSlfnCe2mdnsji1kDOJC3oHgXTOZYjwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717603294; c=relaxed/simple;
	bh=F8E5qCXZsUzJj4+kRSAjsgbydKJF3GVK8ajMZne5bPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZPB+FhPBxzS9Flvke518bLCS3YjWNkfm30nbSRVvdQi4No/+iSXkGywMuuLXDcVErtyU905cRMPcMfSCaL5JQseAXbXExRQfKq5JTCFBDogUFtsbWLpEQsGnJu4vHZzp4ZK6lsKYSs45hWfD3DN4Yhd3c63YxVFstTDqhJIeTV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=iCEkBKrY; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 455FVOPh005773;
	Wed, 5 Jun 2024 16:01:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc :
 content-transfer-encoding : date : from : in-reply-to : message-id :
 mime-version : references : subject : to; s=pp1;
 bh=zGZKQo+BF+IuRlQsgDPQAPqNsv2GRr3QMxcWzaD1q4I=;
 b=iCEkBKrYBpBFV+fsC/6izs8MraakclhhCAR6lGBeS0Z6lkHhJLZqsFV7ph5mHK0Kvf0v
 /K5HSzTHQAtXM5S042q9jCLLMa7x8pYMSd/8m+v9+OtkVb2qcG7tVyezTHqFho01hoJW
 kubKL/6dUyDI2chZfmk40kbn+2DQJ4JyHxQhft29K44iTGoLvqZxaqAvKcGptClt262w
 TuoUmgoBR0RNdy10webOxQMf+5fwjXGfflsh4RhF6E7M8jOJITcD4I/eyfBW6M4XexAn
 PZdr6WHviSuv0/PbQVHA7z1lJmmWGGt+j+9FJiqW4rjpAmbuxDPymvfSS43Hr4veVtJ2 oA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yjsta08kv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 16:01:28 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 455G1ShF025284;
	Wed, 5 Jun 2024 16:01:28 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yjsta08kt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 16:01:28 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 455DQ9Io031142;
	Wed, 5 Jun 2024 16:01:27 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3ygeypn2wx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 16:01:27 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 455G1LFb51904852
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 5 Jun 2024 16:01:23 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A3E412005A;
	Wed,  5 Jun 2024 16:01:21 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 764C22004E;
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
Subject: [PATCH v5 1/3] vfio/pci: Extract duplicated code into macro
Date: Wed,  5 Jun 2024 18:01:10 +0200
Message-ID: <20240605160112.925957-2-gbayer@linux.ibm.com>
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
X-Proofpoint-GUID: Nz5Pp5l_8F8cDjTBDCa9HBQ-2Ek9sDU9
X-Proofpoint-ORIG-GUID: A_0JKbmmqIOVjc65MSz1Af9y-vK8NEkp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-05_02,2024-06-05_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 mlxlogscore=999 priorityscore=1501 malwarescore=0 phishscore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 mlxscore=0 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2406050121

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
2.45.1


