Return-Path: <kvm+bounces-19978-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BE09890EA3D
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 13:59:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B3D071C20C37
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 11:59:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15CAF13F43B;
	Wed, 19 Jun 2024 11:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="E6Csb5iI"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 721D176035;
	Wed, 19 Jun 2024 11:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718798356; cv=none; b=MSWs2lEdkmz2BN8Qarwtwa+6+h3xLhEkkzUdkGhSzMxy1aw8xdqdyZvgZ4EAqpImvXzceliygTMrB4uFH7asj8Cfo91bMcRQGP9XZ/8YPj03Er8UdANffmMvyf8PZo7KB2A/O1v+P6eLDGmY8GKQbsNMAPB9wPasFgDyvHq/B50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718798356; c=relaxed/simple;
	bh=r7w9J1f7wvEEPaqUbu9SnQ4b3toRTEJ/ioPhPOIqKc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oIo0e+pRNTOOwLO4IfHorauH9pIcmWFjJCHov/fdGTGbI9StS0r15gSZofzhKH5dGDYZB1wksqSOD2iJx6fZSPaDfRQb03uuQmJwKxdSgN2T3ZV0diOKoaQwFY/SpHFwqNB8iiN5zpPZIW1y5ahVDqyAHzjAK0nkWnsZE2ZPiVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=E6Csb5iI; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45JARLKK002193;
	Wed, 19 Jun 2024 11:59:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=pp1; bh=FbN91OPxkcTw3
	BduqHzdwSSJl4jNaz3xd0vIZJLCR9U=; b=E6Csb5iI0vtPe5VonW3FFCM4pCRUD
	MoJ0cCAmDsP3Co5vNw6uSTk6nMouUw7+eOzgLhMlXdgV8rvO0anh7nvG+LSpk/gR
	hHYSKCahDVg3LAqPevRspt/TlKU6p7lnp+eTPhiKBlUg2PJ0rDn39aKdhOm9dkVO
	3UhKRrdRDnnjlbEbKhSMSyjf07LnVH9G0enYgWd6Hg+OipoTB8wsC6IR2jM4L/LG
	6ZFTW0UONCoXmvSQ0BmiVfxQ+2eYAUEq9fX6EEPDW8h36mccfHXkU+oHCixU9x4f
	dYl71PReMAu4tPLFAPrZS9gDneIcCk2SYcMYDhxZkycp4Xkh9fNFG12dg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yuw5sr9qk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Jun 2024 11:59:10 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45JBs2S4000692;
	Wed, 19 Jun 2024 11:59:10 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yuw5sr9qg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Jun 2024 11:59:09 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45JAx25t009425;
	Wed, 19 Jun 2024 11:59:09 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3ysqgmuq62-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Jun 2024 11:59:08 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45JBx3xh41222510
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Jun 2024 11:59:05 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5B2162004D;
	Wed, 19 Jun 2024 11:59:03 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0EB782005A;
	Wed, 19 Jun 2024 11:59:03 +0000 (GMT)
Received: from dilbert5.boeblingen.de.ibm.com (unknown [9.152.212.201])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 19 Jun 2024 11:59:03 +0000 (GMT)
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
Subject: [PATCH v6 2/3] vfio/pci: Support 8-byte PCI loads and stores
Date: Wed, 19 Jun 2024 13:58:46 +0200
Message-ID: <20240619115847.1344875-3-gbayer@linux.ibm.com>
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
X-Proofpoint-GUID: 7JXR0-pJ53-w7saJnmFfI_fos280wl-s
X-Proofpoint-ORIG-GUID: wwdirJOfjekc6I4TYGOYR6z0fSmOZhJK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-19_02,2024-06-19_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=621 suspectscore=0 adultscore=0 priorityscore=1501
 clxscore=1015 phishscore=0 spamscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2405170001 definitions=main-2406190088

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
index f87067438ed4..7b45f70f84c3 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -155,5 +155,8 @@ int vfio_pci_core_ioread##size(struct vfio_pci_core_device *vdev,	\
 VFIO_IOREAD_DECLATION(8)
 VFIO_IOREAD_DECLATION(16)
 VFIO_IOREAD_DECLATION(32)
+#ifdef ioread64
+VFIO_IOREAD_DECLATION(64)
+#endif
 
 #endif /* VFIO_PCI_CORE_H */
-- 
2.45.2


