Return-Path: <kvm+bounces-17963-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E63948CC3C9
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 17:07:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 15ECD1C22C5E
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 15:07:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F9092C6BC;
	Wed, 22 May 2024 15:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="cUGePSDj"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99383481B4;
	Wed, 22 May 2024 15:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716390435; cv=none; b=JZ4rFUC8kxjOn0adfyLT807r2LYsUJeL86fpNaFibaXJV35TcVuN5SEIdS2dKvG9cd+Pkk7jbVsavNP0P7gCwm54Xw1uwT52Z/dhp6U6O+IiXEV4CWWm61JJqJ47NATk+VrP7WJNazbo1uqUuYADypwivCJi1j8/7yQuG7d1HWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716390435; c=relaxed/simple;
	bh=nMvR2bfer8L5W2dM5OBxXlX6uMfmzcXdxx43KeZPScs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=junRDDZYjJF2DPJxmixxaC19P2zUXLzR+ySgdWheKxkNz2cQW45F4WoVAiz4sCc9DdmjXp/4X8VY7iym/bYXE/mx69I+t22cphqGXP2iNBCYGOvLWKqBYzwu3Cf5p9hirLUQY4oYrQsuj3wkcHNmrFYnscS4mWqKY4M6E1xsfcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=cUGePSDj; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44MELQ9m015333;
	Wed, 22 May 2024 15:07:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=26a1q6SuS+s/uth9IWRzPZm9wten0hdtXazX9HyAgg8=;
 b=cUGePSDjgx4c4KfxVEqKZQ0iQCeVixANkildahbjS90Cz7YFojbYTVkxUNoloyjG6ey0
 2a2lpq8ZZLWQvfE+Nl0Dz5jTtlYhTs45VfQ+SpxOKs1uMswKqCSFPFxe9Ap3NjsEQGlk
 DOzOht5LF5GSNfvjW2kitYnrirU3ugEJ6vkqyXJeLzS8RPlLHjcjmPDDykOisDFV3Mux
 G21ocsb/Y7hXEAMxJtH0yvQ0/rir04kzDoZWMd3k0eVX+1o5RjYsx0kLd/T6KkeyKRU+
 7XNQTrASCog2ycJn6yZzLMo50kfo4cl51wer6IxxzV/tgYbfkS160MoNymr6sXkI6+26 7A== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3y9h9pra51-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 May 2024 15:07:06 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44MF76SS021145;
	Wed, 22 May 2024 15:07:06 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3y9h9pra4w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 May 2024 15:07:06 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 44MF0VBo008188;
	Wed, 22 May 2024 15:07:05 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3y78vm464p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 May 2024 15:07:05 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 44MF6xmX30015912
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 May 2024 15:07:02 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D92FF20040;
	Wed, 22 May 2024 15:06:59 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 80A2F2005A;
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
        Julian Ruess <julianr@linux.ibm.com>,
        Gerd Bayer <gbayer@linux.ibm.com>
Subject: [PATCH v4 1/3] vfio/pci: Extract duplicated code into macro
Date: Wed, 22 May 2024 17:06:49 +0200
Message-ID: <20240522150651.1999584-2-gbayer@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: Yols4Qyz1iP7v676rlapD_XcJaC63Uzb
X-Proofpoint-GUID: M3KPoevYOKoikCyyLfZai_Gy3s98n7F8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-22_08,2024-05-22_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 phishscore=0 adultscore=0 lowpriorityscore=0 mlxscore=0
 impostorscore=0 malwarescore=0 bulkscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405220101

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
2.45.0


