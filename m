Return-Path: <kvm+bounces-15523-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B95958AD106
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 17:35:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7128528CF79
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 15:35:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED170153518;
	Mon, 22 Apr 2024 15:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="O2MQwnsz"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FEAE1514E2;
	Mon, 22 Apr 2024 15:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713800123; cv=none; b=evQ1cU1s7hP9bF7HdigN3DS35akc/EmMLQFJ058b9du9eg0TPxEk87v423XfmwJCx1GFGiO3e3tji8ivSGvOPOWCPBKMa3ndl3X07BQUv82njKkNgTWnKfuI2/pquE9fGYBEuLFqxJ/xebmNYAMmce97SrTJXTk1qgcXvELWoXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713800123; c=relaxed/simple;
	bh=OT9j+oGsCjZdFZ8us98Sja1932X6F0WY0NHiAMKCxtY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Hh5/08qV27Ykoj92USpgEmVuawG9Km6ems27x8z25+h1pB+xlZ4/dDhn6EKRyBdjWLOXh8n4k6lsgkduMuSus/QWdJ7EgbIESaOZOTok+tz+lJxfouoBH9RF/jY9gGgJVfLs9mXF8lRapvBOjDyq5quFUqw7HmjfbS67buShQw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=O2MQwnsz; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43MFY0TV015070;
	Mon, 22 Apr 2024 15:35:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=IpgcEh6xvVmvzxloEihIB40oDZ7R1Q2/tT+C3qP/rMA=;
 b=O2MQwnszRfDp/Ub0W3YDm+0jdTHSca7cVyNCbd+dQXE8HU2rBRmS0+JBZ3vrzRxrF5eu
 QfE5RuLa/cv8nAMu7gilFaCO1hyj2EqRG0V5x+nnmQwGOyqtigvyBeMAAuEQz07n8WbV
 Qmsxr3fOqcy9CLlZYgkQJH5YD4rld+UUYN8JJ/09JzG+uDJ+rL1JF7FNZDarjsUpoB0C
 ecPxNxpolBB7yCS58ddKznXR8IDBTBgN9Fj7Lc2gJ5+yxK4yfY69WY0VXzXNXne7lDYH
 9Bc1/K3W3+VKXtgzt8PS+frHoYI+KxjjXKjyrNXG3Vdhd6mgj+qVfQTISJ5TCKP1H1Br AQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xnt0503h5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Apr 2024 15:35:17 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43MFZGLl019122;
	Mon, 22 Apr 2024 15:35:16 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xnt0503h2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Apr 2024 15:35:16 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43MCIRG1029862;
	Mon, 22 Apr 2024 15:35:15 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3xmr1t8p10-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Apr 2024 15:35:15 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43MFZAUH49348948
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 22 Apr 2024 15:35:12 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6EA2920067;
	Mon, 22 Apr 2024 15:35:10 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EE4702005A;
	Mon, 22 Apr 2024 15:35:09 +0000 (GMT)
Received: from dilbert5.fritz.box (unknown [9.171.18.8])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 22 Apr 2024 15:35:09 +0000 (GMT)
From: Gerd Bayer <gbayer@linux.ibm.com>
To: Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Niklas Schnelle <schnelle@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Ankit Agrawal <ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Julian Ruess <julianr@linux.ibm.com>, Ben Segal <bpsegal@us.ibm.com>,
        Gerd Bayer <gbayer@linux.ibm.com>
Subject: [PATCH v2] vfio/pci: Support 8-byte PCI loads and stores
Date: Mon, 22 Apr 2024 17:35:08 +0200
Message-ID: <20240422153508.2355844-1-gbayer@linux.ibm.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: vqgah47FaacsI0KebgNUxsXdZ6nMf_bo
X-Proofpoint-ORIG-GUID: 718mfT8MxwHJOq861LQZog9gF4GCBRfh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-22_09,2024-04-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=895 clxscore=1015
 adultscore=0 impostorscore=0 priorityscore=1501 spamscore=0 suspectscore=0
 lowpriorityscore=0 mlxscore=0 phishscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2404220066

From: Ben Segal <bpsegal@us.ibm.com>

Many PCI adapters can benefit or even require full 64bit read
and write access to their registers. In order to enable work on
user-space drivers for these devices add two new variations
vfio_pci_core_io{read|write}64 of the existing access methods
when the architecture supports 64-bit ioreads and iowrites.

Since these access methods are instantiated on 64bit architectures,
only, their use in vfio_pci_core_do_io_rw() is restricted by conditional
compiles to these architectures.

Signed-off-by: Ben Segal <bpsegal@us.ibm.com>
Co-developed-by: Gerd Bayer <gbayer@linux.ibm.com>
Signed-off-by: Gerd Bayer <gbayer@linux.ibm.com>
---
Hi all,

we've successfully used this patch with a user-mode driver for a PCI
device that requires 64bit register read/writes on s390. A quick grep
showed that there are several other drivers for PCI devices in the kernel
that use readq/writeq and eventually could use this, too.
So we decided to propose this for general inclusion.

Thank you,
Gerd Bayer

Changes v1 -> v2:
- On non 64bit architecture use at most 32bit accesses in
  vfio_pci_core_do_io_rw and describe that in the commit message.
- Drop the run-time error on 32bit architectures.
- The #endif splitting the "else if" is not really fortunate, but I'm
  open to suggestions.

 drivers/vfio/pci/vfio_pci_rdwr.c | 28 ++++++++++++++++++++++++++++
 include/linux/vfio_pci_core.h    |  3 +++
 2 files changed, 31 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index 03b8f7ada1ac..d83cb0bb7aa5 100644
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
@@ -114,6 +117,31 @@ ssize_t vfio_pci_core_do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
 		else
 			fillable = 0;
 
+#if defined(ioread64) && defined(iowrite64)
+		if (fillable >= 8 && !(off % 8)) {
+			u64 val;
+
+			if (iswrite) {
+				if (copy_from_user(&val, buf, 8))
+					return -EFAULT;
+
+				ret = vfio_pci_core_iowrite64(vdev, test_mem,
+							 val, io + off);
+				if (ret)
+					return ret;
+			} else {
+				ret = vfio_pci_core_ioread64(vdev, test_mem,
+							&val, io + off);
+				if (ret)
+					return ret;
+
+				if (copy_to_user(buf, &val, 8))
+					return -EFAULT;
+			}
+
+			filled = 8;
+		} else
+#endif /* defined(ioread64) && defined(iowrite64) */
 		if (fillable >= 4 && !(off % 4)) {
 			u32 val;
 
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


