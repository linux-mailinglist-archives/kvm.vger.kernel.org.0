Return-Path: <kvm+bounces-17834-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F0C628CAE00
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 14:16:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6B89F1F23945
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 12:16:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DF2C78B60;
	Tue, 21 May 2024 12:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="gD7D1JLL"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B680770FB;
	Tue, 21 May 2024 12:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716293739; cv=none; b=HHKsuEY6Ep9pld7A377Xf3War4aktw6dsiVQxrgsAmdwi8PAZuQDvMySyY58/lSIAK/+LUND1VAqfi0cui25SgahePnGvyzkfiN+Arssgel4Q19a8rt8L+3s3Kl3E3pzsHDDALxcazxucptAA4h/NUMtazZ+rGQOQaLdRBdG01c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716293739; c=relaxed/simple;
	bh=F1bkIcFhsc+WCTlsr4eJ7l4akJcC8VDnitAlvww5xFo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=JMmgA06Q64IJmCiCf+Ayu0Gyr15ESyX9ETF6OD5CH9L4YGfsmrKxNA1GL7trqYkDlOj9+4yuJ4h3OcScTL9bXGQoRiTQ4GohJR2Lk1sh+PYauzpgei4lTBWqgX0vUnpA8SsNBc9sfQLKjWzG0gAnK5cFH3AGVWs/9c3GHDvJcC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=gD7D1JLL; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44LCDs7E014160;
	Tue, 21 May 2024 12:15:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : date : subject :
 mime-version : content-type : content-transfer-encoding : message-id :
 references : in-reply-to : to : cc; s=pp1;
 bh=O14Ca6VP2DxWUHw2XmaewgHbuznspydEume4f/0C7Dw=;
 b=gD7D1JLLmAeTWEocLEWzZb8rE94j2unfOlbyjKHIejMhc4ffq5T+N/5ntZafzXsHGk76
 +VRLXQoFeNnjv1ml+pUstTWM9XgTokv82N/Fg4NleWHz14vlA4+gxIKVkWeFmcM6O1UA
 Gmz8nn9nWtFzq1Ra+F+P1P3F6AcvcqwioUCLdHkoU4j0ZWAo+Ra9ztIlO1gIytjdWDcH
 dwHqzwR96xM5j7OXBvqnb5RFd5mHqTI3azRCc7tsKTWe+Q1+O+MgSLoy/XdRf6CbcCA2
 TI+jyTFiAl70oqGUmKGuY3eL6hfyb1YSzhDd2ywrHsi6ud6AfLinkZToEYTQdlpdRNll FA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3y8udsr0d5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 May 2024 12:15:37 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44LCFa8w017538;
	Tue, 21 May 2024 12:15:37 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3y8udsr0d2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 May 2024 12:15:36 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 44LAIuA5022240;
	Tue, 21 May 2024 12:15:36 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3y76ntnsfk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 May 2024 12:15:36 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 44LCFXBT5571110
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 May 2024 12:15:35 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DD38A58043;
	Tue, 21 May 2024 12:15:31 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 19FDF5805F;
	Tue, 21 May 2024 12:15:30 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 21 May 2024 12:15:29 +0000 (GMT)
From: Niklas Schnelle <schnelle@linux.ibm.com>
Date: Tue, 21 May 2024 14:14:58 +0200
Subject: [PATCH 2/3] vfio/pci: Tolerate oversized BARs by disallowing mmap
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240521-vfio_pci_mmap-v1-2-2f6315e0054e@linux.ibm.com>
References: <20240521-vfio_pci_mmap-v1-0-2f6315e0054e@linux.ibm.com>
In-Reply-To: <20240521-vfio_pci_mmap-v1-0-2f6315e0054e@linux.ibm.com>
To: Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Gerd Bayer <gbayer@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Niklas Schnelle <schnelle@linux.ibm.com>
X-Mailer: b4 0.12.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1929;
 i=schnelle@linux.ibm.com; h=from:subject:message-id;
 bh=F1bkIcFhsc+WCTlsr4eJ7l4akJcC8VDnitAlvww5xFo=;
 b=owGbwMvMwCH2Wz534YHOJ2GMp9WSGNJ8JsRsz7t0puXG/xVKUQ9eO53uy38zJ23NA6HFL38YM
 X19/jPesKOUhUGMg0FWTJFlUZez37qCKaZ7gvo7YOawMoEMYeDiFICJcK9kZLgmHFufp+YXH8RW
 PUlj6XeuNYdrH55eWMze4vdGPeV9mjAjw6Kt/C9Od/yfI372nOaqqOwnDxef5tGfvlbtU7hl6rb
 yLi4A
X-Developer-Key: i=schnelle@linux.ibm.com; a=openpgp;
 fpr=9DB000B2D2752030A5F72DDCAFE43F15E8C26090
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: dv9Fd_7kAZzVIY9SolYITNrVsyt9CAZX
X-Proofpoint-GUID: 2k2j5Afp6oqBgKq_rssQQsCVkAAqUFz_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-21_08,2024-05-21_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 adultscore=0 malwarescore=0 clxscore=1015 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405210092

On s390 there is a virtual PCI device called ISM which has a few rather
annoying oddities. For one it claims to have a 256 TiB PCI BAR (not
a typo) which leads to any attempt to mmap() it failing during vmap.

Even if one tried to map this "BAR" only partially the mapping would not
be usable on systems with MIO support enabled however. This is because
of another oddity in that this virtual PCI device does not support the
newer memory I/O (MIO) PCI instructions and legacy PCI instructions are
not accessible by user-space when MIO is in use. If this device needs to
be accessed by user-space it will thus need a vfio-pci variant driver.
Until then work around both issues by excluding resources which don't
fit between IOREMAP_START and IOREMAP_END in vfio_pci_probe_mmaps().

Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index d94d61b92c1a..23961299b695 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -28,6 +28,7 @@
 #include <linux/nospec.h>
 #include <linux/sched/mm.h>
 #include <linux/iommufd.h>
+#include <linux/ioremap.h>
 #if IS_ENABLED(CONFIG_EEH)
 #include <asm/eeh.h>
 #endif
@@ -129,9 +130,12 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_core_device *vdev)
 		/*
 		 * The PCI core shouldn't set up a resource with a
 		 * type but zero size. But there may be bugs that
-		 * cause us to do that.
+		 * cause us to do that. There is also at least one
+		 * device which advertises a resource too large to
+		 * ioremap().
 		 */
-		if (!resource_size(res))
+		if (!resource_size(res) ||
+		    resource_size(res) > (IOREMAP_END + 1 - IOREMAP_START))
 			goto no_mmap;
 
 		if (resource_size(res) >= PAGE_SIZE) {

-- 
2.40.1


