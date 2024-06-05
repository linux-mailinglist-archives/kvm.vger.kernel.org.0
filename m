Return-Path: <kvm+bounces-18929-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D5F5D8FD257
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 18:02:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 75A411F27F39
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 16:02:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B76DA188CA8;
	Wed,  5 Jun 2024 16:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Z12pQLmg"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 705F33B298;
	Wed,  5 Jun 2024 16:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717603294; cv=none; b=WR5hF5vVNdWyfosncKxXEMNl8n+6mJwdSFhLHuOdsD89uay/z9wXihrP8ZHlxUKAfzyyQZAdUeS9a21wnIYi+hw/EUSUn23h0/sqE0M10Gj603kGnFTbsjeUu4GCaeu1LZvfHL0d7bO/iG2qAdZUX3xBidOkwIChQsvWgmREuCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717603294; c=relaxed/simple;
	bh=PmNaWFyFray7Wl3+96SLkleigPswqIgTDxdTHsaT8OM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eO2Vk7WFFOuV6u7YiOtEhF8s5+bbAvBtgYUOitlRPKCgAzwPS2VoJ9Q2p6ZLJBXUOQzKigsHXePuqe6+iJE+QF8Tel9PRFNEoPNUVTDx1PIi9EelsgesYFVpcd+aIONDi8NiIEZfaOIEB6o5D6FU020M3wIMKPL8qLRwrIqyEYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Z12pQLmg; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 455EpRHo017176;
	Wed, 5 Jun 2024 16:01:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc :
 content-transfer-encoding : date : from : in-reply-to : message-id :
 mime-version : references : subject : to; s=pp1;
 bh=hewLUgmhRLbS2klCbdVoQL9iAu0KMPFwqoaODD3kuPI=;
 b=Z12pQLmgHNcHzRHYMjLbBtyV4YsQWiaWiSqe3g923ziGAInlcmj69H5WziLWdbA5amiA
 jAwl53E3kXff/VGfx56fGcywNXCJPixePcEPMfFYmGyW1yepN4ZXiuVD5fXdeRmnob8K
 b8/mUvyVXS3y48BDggBrNCF8nAGwzaJBFxftQq2pm5gMLsSbsYIQa+o4UjNzsISt/BGy
 MIyB96jNt+hrln9LEDkh1atNRngQNmeUkPuclRSCkIAM2d6E+b1W0ZcDhNIx76Sn0JTG
 ik8Zmw29IgbROVmeQkQdilGNzC3nUDdyAK/qRYhIeb8Wyb5dI9NVopNJWWEPva2u8Mjr Vg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yjrv10fve-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 16:01:29 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 455G1TTR002059;
	Wed, 5 Jun 2024 16:01:29 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yjrv10fvb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 16:01:29 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 455D3tmD031204;
	Wed, 5 Jun 2024 16:01:28 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3ygeypn2x2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 16:01:28 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 455G1MAH53018994
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 5 Jun 2024 16:01:24 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 154FD20040;
	Wed,  5 Jun 2024 16:01:22 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DE0B220065;
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
Subject: [PATCH v5 3/3] vfio/pci: Fix typo in macro to declare accessors
Date: Wed,  5 Jun 2024 18:01:12 +0200
Message-ID: <20240605160112.925957-4-gbayer@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: 6PwqF7hnv-yHgaPd_c80ySLnYdqYu5SR
X-Proofpoint-GUID: hdqXTTCfzXmOVUg1AbEK5vN168eCCLZf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-05_02,2024-06-05_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=900
 lowpriorityscore=0 suspectscore=0 malwarescore=0 phishscore=0
 clxscore=1015 spamscore=0 bulkscore=0 adultscore=0 mlxscore=0
 priorityscore=1501 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2405010000 definitions=main-2406050121

Correct spelling of DECLA[RA]TION

Suggested-by: Ramesh Thomas <ramesh.thomas@intel.com>
Signed-off-by: Gerd Bayer <gbayer@linux.ibm.com>
---
 include/linux/vfio_pci_core.h | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index f4cf5fd2350c..fa59d40573f1 100644
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
 #ifdef iowrite64
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
 #ifdef ioread64
-VFIO_IOREAD_DECLATION(64)
+VFIO_IOREAD_DECLARATION(64);
 #endif
 
 #endif /* VFIO_PCI_CORE_H */
-- 
2.45.1


