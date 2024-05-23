Return-Path: <kvm+bounces-18037-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 95F518CD0F7
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 13:12:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4C73A2808BE
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 11:12:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1794B1465A0;
	Thu, 23 May 2024 11:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="N8Cmuh5t"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE0E145A11;
	Thu, 23 May 2024 11:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716462669; cv=none; b=uhMJ/zk5ZaiTgZ4zIW7cv7KgPl4mbKPwfWUPxfyrldzfEqjfx0yXfqSOo+dwpYhHZ/Kg1m8XHOHhCQnbKXkxzi1fCyhlL31d4dN1v19YaISEFiIS1fU1xu1NOEjUCK7xuHiG2uxdB9HMqRzy/drmRFLiO3MV6MH6YxWYkXSrCCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716462669; c=relaxed/simple;
	bh=9h92woMooMl3UnL2kypvfI8Bf7RkEfan6j2YoC/grP8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ef2QCGLWUlju3prtv39mEoiPSf9OfVrgpJGVjjftnc4AlyCv+jZe3GliBhtANOsvgvbEDanSlpvrw6vhaOQz/euSe3X4LHnMUIusMfhjLRIUovlTCTbzdBWaqTk5cYeawlWUOVJKtmDJd4jvcs4/rnwUK7hTipptZvcAPZ7oFXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=N8Cmuh5t; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44NAuVX4012736;
	Thu, 23 May 2024 11:11:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : date : subject :
 mime-version : content-type : content-transfer-encoding : message-id :
 references : in-reply-to : to : cc; s=pp1;
 bh=4vhUEqiabPhzigiMYomjmv/L8qT55BUby37dsyFtlO4=;
 b=N8Cmuh5tocDif4yvgGv1oFl64fCrepPJ9YTqMBVStaEbE8DCpWRJm4/gKSr7247gIj7Y
 JtEi5c4HZ5oku6Md0ZGSLh4DUrJDGjyKdeb06IMZLwsjD6nCzEQPoJWHpOCJxvu3Eyqa
 iXDXcJ18Me1NiNqPvPrLDRVWgRj6kP9mLDM+HU8xYstXMmMel6/zxwJwHLTbwx5moItC
 LhKptwRoRZavb5hLSGNpLsNT98VMmHjbvNmTrfD4kP3iFN+phXEl6kc5e6/luE6T5xGx
 fmfCzMyuknJ9gmv+7LVB0Rc/gQMNInGKUZCKpKeNmnwroxeyzIz/c9QQj95HuVuRJg8v Kg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ya20rrfh7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 May 2024 11:11:06 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44NBB5kV005709;
	Thu, 23 May 2024 11:11:05 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ya20rrfg9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 May 2024 11:10:38 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 44N8ADSP026474;
	Thu, 23 May 2024 11:10:37 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3y785msgj1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 May 2024 11:10:37 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 44NBAXFx8061468
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 May 2024 11:10:35 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8C93658052;
	Thu, 23 May 2024 11:10:33 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 324A658064;
	Thu, 23 May 2024 11:10:31 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 23 May 2024 11:10:31 +0000 (GMT)
From: Niklas Schnelle <schnelle@linux.ibm.com>
Date: Thu, 23 May 2024 13:10:15 +0200
Subject: [PATCH v2 2/3] vfio/pci: Tolerate oversized BARs by disallowing
 mmap
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240523-vfio_pci_mmap-v2-2-0dc6c139a4f1@linux.ibm.com>
References: <20240523-vfio_pci_mmap-v2-0-0dc6c139a4f1@linux.ibm.com>
In-Reply-To: <20240523-vfio_pci_mmap-v2-0-0dc6c139a4f1@linux.ibm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1976;
 i=schnelle@linux.ibm.com; h=from:subject:message-id;
 bh=9h92woMooMl3UnL2kypvfI8Bf7RkEfan6j2YoC/grP8=;
 b=owGbwMvMwCH2Wz534YHOJ2GMp9WSGNL8VRTvCRn+mx0Xeyb1W1YDF8OBwseuCkpPJmTVPhD9z
 2v80Ka8o5SFQYyDQVZMkWVRl7PfuoIppnuC+jtg5rAygQxh4OIUgImc4mb4X7Xy5ewvU85Vaz2s
 OLjdMdyExfjhxmCX2vrKe3UCPabrbBkZZt1fvSNTL+6eI7vL4ulFk6ZWR5xY/MXFSbK9PX2pjUM
 cLwA=
X-Developer-Key: i=schnelle@linux.ibm.com; a=openpgp;
 fpr=9DB000B2D2752030A5F72DDCAFE43F15E8C26090
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: n2Bhay_KVzIppJzu2WO6CADZYFHUvhnD
X-Proofpoint-ORIG-GUID: p6NNyfaFozhoYhlDfarBpulVQ2-cNG6j
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-23_07,2024-05-23_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 malwarescore=0
 spamscore=0 priorityscore=1501 mlxscore=0 bulkscore=0 impostorscore=0
 clxscore=1015 phishscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405230076

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


