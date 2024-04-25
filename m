Return-Path: <kvm+bounces-15953-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CF3678B26ED
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 18:56:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3CEF11F241DD
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 16:56:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7893214E2C0;
	Thu, 25 Apr 2024 16:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="LsRklNZe"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B54A4131746;
	Thu, 25 Apr 2024 16:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714064179; cv=none; b=qvweZ/xjIzYDVQ9WHg3QfBFnGYVigySKjjjIoAtU0AJltPdk3DVxB3YFwoJwr1gSG1D6jn+xoHADQCg5tjRc9UFfMPTQfOB9cuSNMQHyvWawmaghgf1L4NoBghzNWgAm6+tap+YNqsCLm8TRztO7S6ilyD7coARd9bmbC1+6SvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714064179; c=relaxed/simple;
	bh=wYYRpd/cMkTAj5ejeAzN2MLPibc7ge3K5fVg9p+8EpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uVI5qVIZDR7YONnIEvXm26INKfxIDQi/yFB066rYsKWBLrxWq/NMr/V0/Vu4YUWF7pdcpeaDzdtFD7AQ2tskbmfjVYaupVoHTYy0qLAEtuMgPEId1CfXwMKWXpHLhstiNUySoxt5fSVGMRvFCn0FxMcNjz7d2KBkj/VhFIdqRBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=LsRklNZe; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43PGgwC7030444;
	Thu, 25 Apr 2024 16:56:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=sluqFAkXX0/bNL/kTW0cN/G08T4ZJaLY2/JQj0PumKY=;
 b=LsRklNZeUbGUqDawfQbAqKRGp+qL9qrZrsxYp51G7WKXxSIm9+AFvu2fRoyJ/HdJ5J15
 HCzQuqhrRJyQvfVIdd41X7bd2ePda2AmZILWQthQnLeTwHA4d4Rd9q3ImBdS7eow+/Hd
 b1udpqEpdTZXSTinz0Kk/Tsv1kOPlYjFBL3dMFn34LZshhadImGU5MGOBcEyzzxlWtGR
 ecKgGBCy9VhssmtX26T70E46boBlkgHl+fejkCcXFpmniI6k+zLHoipRBr/6AFtnBj84
 JcJjMjtH6wBxY2uWQoqApM3CMgN0a+XQWXaQEuZM5N1LkveOJAphPEtlaIPodhzptyop Xg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xqtxf01g5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Apr 2024 16:56:13 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43PGuD20021039;
	Thu, 25 Apr 2024 16:56:13 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xqtxf01g1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Apr 2024 16:56:13 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43PGWGL8028319;
	Thu, 25 Apr 2024 16:56:12 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3xmtr2tcud-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Apr 2024 16:56:12 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43PGu7Dp48693532
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Apr 2024 16:56:09 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2ABF02005A;
	Thu, 25 Apr 2024 16:56:07 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 031F820063;
	Thu, 25 Apr 2024 16:56:07 +0000 (GMT)
Received: from dilbert5.boeblingen.de.ibm.com (unknown [9.152.212.201])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 25 Apr 2024 16:56:06 +0000 (GMT)
From: Gerd Bayer <gbayer@linux.ibm.com>
To: Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Niklas Schnelle <schnelle@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Ankit Agrawal <ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Julian Ruess <julianr@linux.ibm.com>, Ben Segal <bpsegal@us.ibm.com>,
        Gerd Bayer <gbayer@linux.ibm.com>
Subject: [PATCH v3 2/3] vfio/pci: Support 8-byte PCI loads and stores
Date: Thu, 25 Apr 2024 18:56:03 +0200
Message-ID: <20240425165604.899447-3-gbayer@linux.ibm.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240425165604.899447-1-gbayer@linux.ibm.com>
References: <20240425165604.899447-1-gbayer@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: QPww_oYvfx4rOKFkd0Aqhe-xrffOeGvi
X-Proofpoint-ORIG-GUID: ahoS4MJfzCzNwW1cGua9lvTr63t_G0dS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-25_16,2024-04-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 adultscore=0 clxscore=1015 mlxscore=0 impostorscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 priorityscore=1501
 mlxlogscore=748 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2404010000 definitions=main-2404250123

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
index 3335f1b868b1..8ed06edaee23 100644
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
 static int vfio_pci_core_iordwr##size(struct vfio_pci_core_device *vdev,\
@@ -124,6 +127,10 @@ static int vfio_pci_core_iordwr##size(struct vfio_pci_core_device *vdev,\
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
+			ret = vfio_pci_core_iordwr64(vdev, iswrite, test_mem,
+						     io, buf, off, &filled);
+			if (ret)
+				return ret;
+
+		} else
+#endif /* defined(ioread64) && defined(iowrite64) */
 		if (fillable >= 4 && !(off % 4)) {
 			ret = vfio_pci_core_iordwr32(vdev, iswrite, test_mem,
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
2.44.0


