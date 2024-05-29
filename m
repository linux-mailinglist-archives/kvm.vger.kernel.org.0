Return-Path: <kvm+bounces-18280-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A4BA18D35A6
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 13:37:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C7D8D1C234EE
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 11:37:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7119181310;
	Wed, 29 May 2024 11:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="c6HLm12J"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E7C180A81;
	Wed, 29 May 2024 11:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716982625; cv=none; b=ttZm7OeNB5qKchjERkjtj+Ee4QhfBhxRm5CWO7bYedlUQWwdqGLuazCvg1MLxkbY9C+LxpL5WGOmSsb31zqct3mxTvDxTKAdUss4j6EtGOCLUJb/SIrKpPgMMJBbpkG+9iRQFOksFoxqt9rTetwLZ23ju23bAs1RU7Z6o7ZRF5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716982625; c=relaxed/simple;
	bh=nKUHkHvEphYKnVTYi7g6h0+bJI4W2Di7aoc14RiURco=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=W0bijgGdPRdErFjQhKna9iuKHMYezSQHJ7fouWRhpwgWh9aIB37pTJuKTFhD/lD1QJADwfjM89RtfghWQN0HcbP8BJf4o41DSZa9LZylRHFLZhyjNiuFK6ZFelxGrfUn+VyKWXuMG4phya4NPWByjIjysTl4s7OsZha+HwIYBSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=c6HLm12J; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44TBZqLq027567;
	Wed, 29 May 2024 11:37:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc :
 content-transfer-encoding : content-type : date : from : in-reply-to :
 message-id : mime-version : references : subject : to; s=pp1;
 bh=hcqHB+gMcNVZF+txZ6zeAs89VpV+YbZ8B7LKeOBq1gY=;
 b=c6HLm12JsCbsuzii956swjB+fzHqzicZpfuyM9f3qqHGbGocVLJkCtssgCrP4/r4h3Rw
 L9uONmT4nJ2iOkUmm/IHRF4I54i/FKMNVbNNTtiSldtaPUoAgIJTlsNlF+TYQqEFRFsz
 lnn4n6gxnzFkcraJYH9qeCTcH8kC7fyXalbf6guEAyjpDU8Dyy5pfJ4HmYUAsdjBAL/V
 ecsD6EMOXD44scnn+DwC6gW/Lvm4aSQB3FJAkzsXiUycMImqvNC3/K0kVU7oecxQy9LD
 u/tFw3/X0wgeCp1u7bo5iiem2BA/eqhJgp1Mlr1fvc/klY1YHHYspNr0mOTKAhb09Euw 9w== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ye32nr2ta-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 May 2024 11:37:01 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44TBb1HS029920;
	Wed, 29 May 2024 11:37:01 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ye32nr2t8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 May 2024 11:37:01 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 44T8HZpm024784;
	Wed, 29 May 2024 11:37:00 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3ydphqkekm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 May 2024 11:37:00 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 44TBavEp27001288
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 May 2024 11:36:59 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 74F4B5805E;
	Wed, 29 May 2024 11:36:57 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2E90E5805B;
	Wed, 29 May 2024 11:36:55 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 29 May 2024 11:36:54 +0000 (GMT)
From: Niklas Schnelle <schnelle@linux.ibm.com>
Date: Wed, 29 May 2024 13:36:25 +0200
Subject: [PATCH v3 2/3] vfio/pci: Tolerate oversized BARs by disallowing
 mmap
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240529-vfio_pci_mmap-v3-2-cd217d019218@linux.ibm.com>
References: <20240529-vfio_pci_mmap-v3-0-cd217d019218@linux.ibm.com>
In-Reply-To: <20240529-vfio_pci_mmap-v3-0-cd217d019218@linux.ibm.com>
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
        kvm@vger.kernel.org, Niklas Schnelle <schnelle@linux.ibm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
X-Mailer: b4 0.12.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2030;
 i=schnelle@linux.ibm.com; h=from:subject:message-id;
 bh=nKUHkHvEphYKnVTYi7g6h0+bJI4W2Di7aoc14RiURco=;
 b=owGbwMvMwCH2Wz534YHOJ2GMp9WSGNLChd0sq++osLgeCOjgVEx35nrqyHhDojzwt96nfT+ev
 uuZcca1o5SFQYyDQVZMkWVRl7PfuoIppnuC+jtg5rAygQxh4OIUgIn8fM3wP5792n+fn5Z887Nn
 Vi2Z8HLFG4dtL9b8XvZ5SbNb6pTPVU4M/5QrZry4XHwp92j329i5zNO2aogVbmv3m/tc9/qi2ic
 ql/gA
X-Developer-Key: i=schnelle@linux.ibm.com; a=openpgp;
 fpr=9DB000B2D2752030A5F72DDCAFE43F15E8C26090
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ewZ8vlQMt6KnEhUKPnWKfIOpqJaMVtML
X-Proofpoint-GUID: aXQ0qthgY3w9QWRSEhruPgT6rC002qBH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-29_07,2024-05-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 malwarescore=0 clxscore=1015 phishscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 suspectscore=0 adultscore=0 impostorscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405290079

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

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 80cae87fff36..0f1ddf2d3ef2 100644
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


