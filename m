Return-Path: <kvm+bounces-19976-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 66ECC90EA39
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 13:59:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 16681282C0A
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 11:59:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08BFE13E041;
	Wed, 19 Jun 2024 11:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="RRTJu2t0"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E11B13212E;
	Wed, 19 Jun 2024 11:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718798355; cv=none; b=UR4+OClufTqWpCoxtg3xqrij4lTH2q0PhoDcu1YaMQ4FxkYLhYrwst36m00r93mDP8BjTvQQ5yyFVJvUo4IRKZn68GMPs/lpYf3nsTzmqPswJPFRmlR/+GGTOaBfXzPKBk6hme7nP+10EmADjGaVnE5okY4kk5dRFPKR3t3iewY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718798355; c=relaxed/simple;
	bh=Tge6lc+3Uv9nGSmPICO4Y2gKi4AiqtpP5Cab+yPOd08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gXWzko0ExD0RDZTs/2y+4poXX1tix0+cogEpaa/IUr5fSK5lHs7zXLo1J/zinZLDnfUlAJulK3nU3OxvRCLtp+7eBGQJVnbyxVOlH5eXnwXWFpFUSfYWfTV78HzKhj9UtJVYGVXY3i9g2q7juu71UXF+Gq0ttjuHhM3caROs0lM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=RRTJu2t0; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45JBQalq029498;
	Wed, 19 Jun 2024 11:59:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=pp1; bh=x6P7aXzxoRWeK
	iEzojjkjPtPXR7eYYbR4fDPbFWD9lM=; b=RRTJu2t0gZRgP3z2fcauFAoglUOeR
	MzadwYS26I933wObaaq4ET2tVw6GOQwPTnOVOTdyQZMHCbisb3U3yxT5HZ3S+7GW
	81KeL8NcfJJjF7PaX/+5nYtxeqsg7ZL/pXVTnjL0pKP5Umo0jqTVB5+BN9pwN+9c
	72kp5oNW4/IGBIHfIhMMmizb9T2l4WwYqRpx17eeTVG/jKak0DVxBCF2fTa00hch
	r+NG5DTcT9zH8wLkI6IUEMmScxS4o6PsmYNeT4iPMSf7D/SL3pukgJop2+fLzBa0
	64Bycp1XZvSs5SVcK4AH16oc8nA3hjMkL0OcrZlJ3JaETTOGbyHfqWPTA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yuwy0r6jv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Jun 2024 11:59:10 +0000 (GMT)
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45JBvnl4012054;
	Wed, 19 Jun 2024 11:59:10 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yuwy0r6jt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Jun 2024 11:59:10 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45JB5OLp013440;
	Wed, 19 Jun 2024 11:59:09 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3ysr03up8d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Jun 2024 11:59:09 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45JBx3W744958046
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Jun 2024 11:59:05 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B04E92004E;
	Wed, 19 Jun 2024 11:59:03 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 64FB22004F;
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
Subject: [PATCH v6 3/3] vfio/pci: Fix typo in macro to declare accessors
Date: Wed, 19 Jun 2024 13:58:47 +0200
Message-ID: <20240619115847.1344875-4-gbayer@linux.ibm.com>
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
X-Proofpoint-GUID: UGH1znYv87LgQ2rhlQOmElIb9-BCeiZm
X-Proofpoint-ORIG-GUID: EmAmxowTE3nod-QLpwzmlxzg3gOBmVSo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-19_02,2024-06-19_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 mlxlogscore=898 mlxscore=0 malwarescore=0 clxscore=1015 priorityscore=1501
 suspectscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2405170001
 definitions=main-2406190088

Correct spelling of DECLA[RA]TION

Suggested-by: Ramesh Thomas <ramesh.thomas@intel.com>
Signed-off-by: Gerd Bayer <gbayer@linux.ibm.com>
---
 include/linux/vfio_pci_core.h | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 7b45f70f84c3..fbb472dd99b3 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -137,26 +137,26 @@ bool vfio_pci_core_range_intersect_range(loff_t buf_start, size_t buf_cnt,
 					 loff_t *buf_offset,
 					 size_t *intersect_count,
 					 size_t *register_offset);
-#define VFIO_IOWRITE_DECLATION(size) \
+#define VFIO_IOWRITE_DECLARATION(size) \
 int vfio_pci_core_iowrite##size(struct vfio_pci_core_device *vdev,	\
 			bool test_mem, u##size val, void __iomem *io);
 
-VFIO_IOWRITE_DECLATION(8)
-VFIO_IOWRITE_DECLATION(16)
-VFIO_IOWRITE_DECLATION(32)
+VFIO_IOWRITE_DECLARATION(8)
+VFIO_IOWRITE_DECLARATION(16)
+VFIO_IOWRITE_DECLARATION(32)
 #ifdef iowrite64
-VFIO_IOWRITE_DECLATION(64)
+VFIO_IOWRITE_DECLARATION(64)
 #endif
 
-#define VFIO_IOREAD_DECLATION(size) \
+#define VFIO_IOREAD_DECLARATION(size) \
 int vfio_pci_core_ioread##size(struct vfio_pci_core_device *vdev,	\
 			bool test_mem, u##size *val, void __iomem *io);
 
-VFIO_IOREAD_DECLATION(8)
-VFIO_IOREAD_DECLATION(16)
-VFIO_IOREAD_DECLATION(32)
+VFIO_IOREAD_DECLARATION(8)
+VFIO_IOREAD_DECLARATION(16)
+VFIO_IOREAD_DECLARATION(32)
 #ifdef ioread64
-VFIO_IOREAD_DECLATION(64)
+VFIO_IOREAD_DECLARATION(64)
 #endif
 
 #endif /* VFIO_PCI_CORE_H */
-- 
2.45.2


