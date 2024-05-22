Return-Path: <kvm+bounces-17965-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D97E98CC3CD
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 17:07:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 08F921C2317D
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 15:07:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F1D528DBF;
	Wed, 22 May 2024 15:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="tGgP6d7+"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98F91C6A8;
	Wed, 22 May 2024 15:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716390459; cv=none; b=lMdqJU7Z1XWmoLdQm1DLuJt+Kq1xmxx424QYhs7Jz7zTuq65/w+5Su7vsdMzXHVFYr4jnKXQMMjrDdSz1x8v+LrdZjgVIwQ1yBqrrTfQAwdMu642bcyo7MW4rLFJ5QSQWwWCYR35IflfGf/J7yPH1mR3muUgG66uCizl3x4qDW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716390459; c=relaxed/simple;
	bh=WEpREqMhPkNihuBv6hEliRokd16yJnh08KjCemuD5qM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k6UXft7vEIzLoUqY4hV7yZlV4oEcqizWYpycp1Z/2Z76RXw44x+nxrYTn0cki4lQ8mwqD/XyV+KM0InmMlKNbuywDBUNN6Ad7gO24XnQwO/ex48wTNlA2IydAw5MGzyI8luXJbLb5R43CNhQ4I/lfLDV4ygM5XC4ngLqFAx5NHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=tGgP6d7+; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44MEIfuS015709;
	Wed, 22 May 2024 15:07:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=otNFM9ZTgsXb8Ki7sw1G+IqMVuLkxn34jwHxXLoqCpQ=;
 b=tGgP6d7+LtYJZEWdA8jrEJYCBZHaBEt5o5hmhU5jhZR9BVS4r7BNVbmp3pUgiyqnA+IF
 o/vtwWiZNA/BWXdFV9VGY4QJdIhqMPCuz7iCfTwiATIox7EGQ2hb+cEDykrUd5Q8dsHQ
 M1gwGZen4pN4b/f++iOEYKB/d6XeRdHhbkaJfDIhtQEQuuhNyOT6ZeGX+rM5gtgCVdEt
 CbL8mvHEqp60T5A1DNy/WH5fs6Ro/EKGyq6Q5dVk2LDL7xKcOmhekPOh1XoLPxDOHpQn
 HFjfq1jctHWUVubrq9z1fyjTGFfjOPf6CMq+2/zhS0AGId11Hby+9HqNIHC27U4KatzC Xg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3y9jbr83re-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 May 2024 15:07:07 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44MF778u026428;
	Wed, 22 May 2024 15:07:07 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3y9jbr83rc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 May 2024 15:07:07 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 44MCFfcS008100;
	Wed, 22 May 2024 15:07:06 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3y79c3452w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 May 2024 15:07:06 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 44MF70lR51773902
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 May 2024 15:07:02 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AB4C82005A;
	Wed, 22 May 2024 15:07:00 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5899E2004F;
	Wed, 22 May 2024 15:07:00 +0000 (GMT)
Received: from dilbert5.boeblingen.de.ibm.com (unknown [9.155.208.153])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 22 May 2024 15:07:00 +0000 (GMT)
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
Subject: [PATCH v4 3/3] vfio/pci: Fix typo in macro to declare accessors
Date: Wed, 22 May 2024 17:06:51 +0200
Message-ID: <20240522150651.1999584-4-gbayer@linux.ibm.com>
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
X-Proofpoint-GUID: Fzf6qxkIoti9WBbOigfF1ETSm6QYhEs7
X-Proofpoint-ORIG-GUID: ZBRaPksNMD3CZrqLnyqy_zJVml1WPwd6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-22_08,2024-05-22_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 mlxlogscore=934 clxscore=1015 impostorscore=0 bulkscore=0 spamscore=0
 adultscore=0 malwarescore=0 lowpriorityscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405220102

Correct spelling of DECLA[RA]TION

Suggested-by: Ramesh Thomas <ramesh.thomas@intel.com>
Signed-off-by: Gerd Bayer <gbayer@linux.ibm.com>
---
 include/linux/vfio_pci_core.h | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 5f9b02d4a3e9..15d6d6da6e78 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -139,26 +139,26 @@ bool vfio_pci_core_range_intersect_range(loff_t buf_start, size_t buf_cnt,
 					 loff_t *buf_offset,
 					 size_t *intersect_count,
 					 size_t *register_offset);
-#define VFIO_IOWRITE_DECLATION(size) \
+#define VFIO_IOWRITE_DECLARATION(size) \
 int vfio_pci_core_iowrite##size(struct vfio_pci_core_device *vdev,	\
-			bool test_mem, u##size val, void __iomem *io);
+			bool test_mem, u##size val, void __iomem *io)
 
-VFIO_IOWRITE_DECLATION(8)
-VFIO_IOWRITE_DECLATION(16)
-VFIO_IOWRITE_DECLATION(32)
+VFIO_IOWRITE_DECLARATION(8);
+VFIO_IOWRITE_DECLARATION(16);
+VFIO_IOWRITE_DECLARATION(32);
 #ifdef CONFIG_64BIT
-VFIO_IOWRITE_DECLATION(64)
+VFIO_IOWRITE_DECLARATION(64);
 #endif
 
-#define VFIO_IOREAD_DECLATION(size) \
+#define VFIO_IOREAD_DECLARATION(size) \
 int vfio_pci_core_ioread##size(struct vfio_pci_core_device *vdev,	\
-			bool test_mem, u##size *val, void __iomem *io);
+			bool test_mem, u##size *val, void __iomem *io)
 
-VFIO_IOREAD_DECLATION(8)
-VFIO_IOREAD_DECLATION(16)
-VFIO_IOREAD_DECLATION(32)
+VFIO_IOREAD_DECLARATION(8);
+VFIO_IOREAD_DECLARATION(16);
+VFIO_IOREAD_DECLARATION(32);
 #ifdef CONFIG_64BIT
-VFIO_IOREAD_DECLATION(64)
+VFIO_IOREAD_DECLARATION(64);
 #endif
 
 #endif /* VFIO_PCI_CORE_H */
-- 
2.45.0


