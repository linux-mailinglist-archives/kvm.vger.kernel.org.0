Return-Path: <kvm+bounces-17835-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A81608CAE03
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 14:16:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 641B4284467
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 12:16:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15D1878C86;
	Tue, 21 May 2024 12:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="rrBAZyoz"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC7477118;
	Tue, 21 May 2024 12:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716293741; cv=none; b=GwBwajtrtetFCS2uCQwWf1oZYqGbMI6YhPxm7ZERCqoBLlHUamqcUSEDtmqOqLE/x0i0+c+ChSD+jhfrI3u2IMrAzfGvs8Vt8dOBBf7Vp/Mqlh4KwS6FVljh+aTD7sXnnctZIpH1SBq+9q9miyWcF16XTQKXZyNKy+CToC6WZSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716293741; c=relaxed/simple;
	bh=r6NUAZTvpLRwycDnLcFtYRyW2y8FYnVfEO5UQERDHKw=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=dVw6ZBgLVceZB/Hhsmq+fx4vTox43d5M0E+faIyOxA6KPGlrVuUVQleQyR1cOhTeAgYNvBcwRM5MnZJebljH8bWd/LnGce30mhq740ji1+IP9/9eBkxXibOWubhY1xN6zs/D5S2Vnl7KnXjg+KveNxygoMP/3m+o0haIb0kZu7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=rrBAZyoz; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44LC3Fhg025469;
	Tue, 21 May 2024 12:15:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : date : subject :
 content-type : message-id : references : in-reply-to : to : cc :
 content-transfer-encoding : mime-version; s=pp1;
 bh=Buw4eF8ZL2S9x7Ww4CLjvGShtmwTm3IYHiPIwey83ws=;
 b=rrBAZyoztA4t5GokwFz3tfE8lkXPoI+SdvtT6BhBG67A+L6T4L5DNryveAH1PDXYWuWx
 wnB3q+85QghQxCNFqDE3B1VsdFsvNz34ClB+B8HGHHC1iylLbWbBETKEEfqGM5qplBUj
 OWcToXGC0kEtYt/WVcq1KSXFiIbYisVzZwrewgln1VpCxjDKAl7UraStiZ00bZOToUYQ
 pRnEdQnlQmgXBx3qvyIm9Ux1h6zc3hja9h7kw++y24w0OPXAPGcrap0bPcInPckwP3Ck
 r3yayo7y4P8H6HYdbdGFXIWVbCDKkfWldwYRLmtxIb5mETZaXt44W7DDexSR48oI3m7+ cQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3y8u92g1a1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 May 2024 12:15:38 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44LCFbgB011685;
	Tue, 21 May 2024 12:15:37 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3y8u92g19x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 May 2024 12:15:37 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 44LBHFfV026447;
	Tue, 21 May 2024 12:15:37 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3y785mddjb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 May 2024 12:15:37 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 44LCFXRF31851198
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 May 2024 12:15:36 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E44C158069;
	Tue, 21 May 2024 12:15:33 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 21F555805D;
	Tue, 21 May 2024 12:15:32 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 21 May 2024 12:15:31 +0000 (GMT)
From: Niklas Schnelle <schnelle@linux.ibm.com>
Date: Tue, 21 May 2024 14:14:59 +0200
Subject: [PATCH 3/3] vfio/pci: Enable VFIO_PCI_MMAP for s390
Content-Type: text/plain; charset="utf-8"
Message-Id: <20240521-vfio_pci_mmap-v1-3-2f6315e0054e@linux.ibm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1087;
 i=schnelle@linux.ibm.com; h=from:subject:message-id;
 bh=r6NUAZTvpLRwycDnLcFtYRyW2y8FYnVfEO5UQERDHKw=;
 b=owGbwMvMwCH2Wz534YHOJ2GMp9WSGNJ8JsROmrSjg9v4Vc2fCiYpgwT/nr21IveULA/+ZuoUb
 bYJWzyjo5SFQYyDQVZMkWVRl7PfuoIppnuC+jtg5rAygQxh4OIUgInEujAynN380stzYUT9gVh+
 5TkMzkcmp/OlVHXcVb8q729qorhkLiPDoQ9G2aE7uvRiW3le35z4//UUg6nZdiYLTf5uW2WanLO
 LFwA=
X-Developer-Key: i=schnelle@linux.ibm.com; a=openpgp;
 fpr=9DB000B2D2752030A5F72DDCAFE43F15E8C26090
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: wWG7Pd-2LYWqFNMnvba9PHpu2T7OhGcg
X-Proofpoint-GUID: H6MTPEmJ4HJTX3Ccmqq9R31R2j9QU6SO
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-21_07,2024-05-21_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 suspectscore=0 mlxlogscore=629 priorityscore=1501 mlxscore=0
 lowpriorityscore=0 bulkscore=0 impostorscore=0 clxscore=1015 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405210091

With the introduction of memory I/O (MIO) instructions enbaled in commit
71ba41c9b1d9 ("s390/pci: provide support for MIO instructions") s390
gained support for direct user-space access to mapped PCI resources.
Even without those however user-space can access mapped PCI resources
via the s390 specific MMIO syscalls. Thus VFIO_PCI_MMAP can be enabled
on all s390 systems with native PCI allowing vfio-pci user-space
applications direct access to mapped resources.

Link: https://lore.kernel.org/all/c5ba134a1d4f4465b5956027e6a4ea6f6beff969.camel@linux.ibm.com/
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
---
 drivers/vfio/pci/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index 15821a2d77d2..814aa0941d61 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -8,7 +8,7 @@ config VFIO_PCI_CORE
 	select IRQ_BYPASS_MANAGER
 
 config VFIO_PCI_MMAP
-	def_bool y if !S390
+	def_bool y
 	depends on VFIO_PCI_CORE
 
 config VFIO_PCI_INTX

-- 
2.40.1


