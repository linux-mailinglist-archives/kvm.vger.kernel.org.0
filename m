Return-Path: <kvm+bounces-15290-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A73148AAFCA
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 15:53:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 258111F22627
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 13:53:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 674C012C819;
	Fri, 19 Apr 2024 13:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="EmKPcGhZ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FB8312C534;
	Fri, 19 Apr 2024 13:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713534818; cv=none; b=arVBADXYMbmFmngM/qd5sT9tCZS7TRCAHfPu8oxjGpvCFCtCbYeybpSk/od2adN9CQRVWHaUKAV9erGUmLs3hCFE8vK3zkkOMqkanPw9QdhOxBfnQ/aavCaVxas3qkQPWnVxQRs6Fw+62onICuBh2euWE64C0QUl2P1J1sPNzhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713534818; c=relaxed/simple;
	bh=iDYeJLnLcgO40R6gEmIE6Jo/vKhEDL5cey5xmLIJnN8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=f1mzGyKTWq6TbjiZyb/ovB8QVeiVZJjJzLII0Ijz4kz6bZ2DvL2rODhedEHk/nczAS7p2rYxc/e+yb7+VwpEQVZ6/gPsvY2fqMKMQltob+6wTdqCUOh6NHj140UO9zz+82W/szca5SEX88MRHJYdUuu4oZsx5fuFYjjfbrS8gRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=EmKPcGhZ; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43JDllSc017688;
	Fri, 19 Apr 2024 13:53:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=5OD2gteKqsKmUUPyL9EwUUlgJQzDAzMpVdrUU7VCHn4=;
 b=EmKPcGhZGVjfg2+qfA3Udsfhuru9euAKy0JrIndmOaXZRZkQjX7J3u8xCEnUVy5CCXUH
 AAFGXqdY1jBVrmiZpEY2D1PBkmMq0vg+F4b2C5YliK/vPGhAJaoW5z6W0tUpur/UlJfZ
 MoxhAmbOLT6dhP6uWLavsxrhpo51aW9obzp5aFu/YuhuDIjr3tlE+61v+RO/sgBH8atn
 qQNUa6Z3bbMRykKMsoaga61mSstJr5d2b3PG5L151wFQBoZ0Wnao0wryxHAoBccmadfI
 1pQN58Rkgd/z31AZG6KLLh5gd+5xZm5drxNFHcCnGMiUWT4RCKVSS+rwdn/3bPLcbubw uQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xkske01er-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 19 Apr 2024 13:53:33 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43JDrW0f026661;
	Fri, 19 Apr 2024 13:53:32 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xkske01en-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 19 Apr 2024 13:53:32 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43JCOGvc010653;
	Fri, 19 Apr 2024 13:53:32 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xkbmm3x2d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 19 Apr 2024 13:53:31 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43JDrQ8647382864
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Apr 2024 13:53:28 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4C9832004B;
	Fri, 19 Apr 2024 13:53:26 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ECA1A20043;
	Fri, 19 Apr 2024 13:53:25 +0000 (GMT)
Received: from dilbert5.boeblingen.de.ibm.com (unknown [9.155.208.153])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 19 Apr 2024 13:53:25 +0000 (GMT)
From: Gerd Bayer <gbayer@linux.ibm.com>
To: Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, Ankit Agrawal <ankita@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Halil Pasic <pasic@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Ben Segal <bpsegal@us.ibm.com>, Gerd Bayer <gbayer@linux.ibm.com>
Subject: [PATCH] vfio/pci: Support 8-byte PCI loads and stores
Date: Fri, 19 Apr 2024 15:53:23 +0200
Message-ID: <20240419135323.1282064-1-gbayer@linux.ibm.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 11fIw2jmKjLm80pLk7Ud5m8_8ifjlVet
X-Proofpoint-ORIG-GUID: hHIEC9zBqar6UtHTzqN-0FxwS8rQaZuc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-19_09,2024-04-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 phishscore=0 clxscore=1011 lowpriorityscore=0 adultscore=0 bulkscore=0
 mlxlogscore=665 mlxscore=0 impostorscore=0 priorityscore=1501 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2404190104

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

Hi all,

we've successfully used this patch with a user-mode driver for a PCI
device that requires 64bit register read/writes on s390. A quick grep
showed that there are several other drivers for PCI devices in the kernel
that use readq/writeq and eventually could use this too.
So we decided to propose this for general inclusion.

We've added conditional compiles for non-64bit architectures that
produce graceful run-time errors. However, that path is just
compile-tested.

Thank you,
Gerd Bayer

 drivers/vfio/pci/vfio_pci_rdwr.c | 39 +++++++++++++++++++++++++++++++-
 include/linux/vfio_pci_core.h    |  3 +++
 2 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index 03b8f7ada1ac..3f91945ea3ff 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -89,6 +89,9 @@ EXPORT_SYMBOL_GPL(vfio_pci_core_ioread##size);
 VFIO_IOREAD(8)
 VFIO_IOREAD(16)
 VFIO_IOREAD(32)
+#ifdef ioread64
+VFIO_IOREAD(64)
+#endif
 
 /*
  * Read or write from an __iomem region (MMIO or I/O port) with an excluded
@@ -114,7 +117,41 @@ ssize_t vfio_pci_core_do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
 		else
 			fillable = 0;
 
-		if (fillable >= 4 && !(off % 4)) {
+		if (fillable >= 8 && !(off % 8)) {
+#if defined(ioread64) || defined(iowrite64)
+			u64 val;
+#endif
+
+			if (iswrite) {
+#ifndef iowrite64
+				pr_err_once("vfio does not support iowrite64 on this arch");
+				return -EIO;
+#else
+				if (copy_from_user(&val, buf, 8))
+					return -EFAULT;
+
+				ret = vfio_pci_core_iowrite64(vdev, test_mem,
+							 val, io + off);
+				if (ret)
+					return ret;
+#endif
+			} else {
+#ifndef ioread64
+				pr_err_once("vfio does not support ioread64 on this arch");
+				return -EIO;
+#else
+				ret = vfio_pci_core_ioread64(vdev, test_mem,
+							&val, io + off);
+				if (ret)
+					return ret;
+
+				if (copy_to_user(buf, &val, 8))
+					return -EFAULT;
+#endif
+			}
+
+			filled = 8;
+		} else if (fillable >= 4 && !(off % 4)) {
 			u32 val;
 
 			if (iswrite) {
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
2.44.0


