Return-Path: <kvm+bounces-18282-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B42EF8D35F6
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 14:04:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 29528B22F78
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 12:04:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D265B181313;
	Wed, 29 May 2024 12:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="g4aEtzaF"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99567180A99;
	Wed, 29 May 2024 12:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716984264; cv=none; b=j87wmULoyujkPKo0BSJtM5xuNB6j0KboL0InGEAFbhcaeRWp38RP4mVfq7m5kBur+TFafQIBJFqCmEBqvZKI8VePyX3YZATfo9U62u/9dr1hRsIcPxi9J24UX4a44PRMve1md94rLk36fzWqdgybR779vgGorlMji/VI4dj8ddE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716984264; c=relaxed/simple;
	bh=i0eyyMMvW9e10XOJrVNQwFpRIiJqX7RCrvmSyLcYF0E=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=EthIQQFC4ESP2+jP2Z1e+LrT0wT32Ud9fHzBWAICHiu+hzgOhbn3wDKFXeHvbPfWm+BP7YIAp7lkDwlxZ6M8GrajtWC8hCNp7lGg/PrH7KputuSsueZMFWk85VYTaQMtnfvAWTG45X/P2xYQOhc93Sb2YwbJs871lijMzNJCrtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=g4aEtzaF; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44TBqhZ4025455;
	Wed, 29 May 2024 12:04:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc :
 content-transfer-encoding : content-type : date : from : in-reply-to :
 message-id : mime-version : references : subject : to; s=pp1;
 bh=euCN2rq9Y/cy5muRfHlpyotcwKgvKirkbyMUy28OLQA=;
 b=g4aEtzaFtpRx72LF0nZGm0y65VC6L8h3QP0099dVQOX32J781MS3cDL9H3RKNk+GQna1
 NQ6JjMpSmTmd+CCIjplYkyM9VyzcpUuu0KV+CdsRvKmso+M/qwY+8tEkf7HHk0mxc5WD
 D1OLV2wwb/BH9l4zsU5xnCjTBoILeXCj+vqxDWaq9X6RXhn4FnqO2VYjv3dVg8nq8fnj
 k/fJQg/AqJVa8vyZBGhGkO7GfuxDble7+sfnHqHWK7u+IERXAbLhAqW20ZQiIc2AinZX
 InF4GKIvZHLIQAOy4QVkT5OEq4hX9MS2xnVqHu9VaPMFuh/mqnRlke60aKAQGu2NmDzI 2Q== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ye3v8g17e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 May 2024 12:04:21 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44TC4LDZ014072;
	Wed, 29 May 2024 12:04:21 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ye3v8g16w-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 May 2024 12:04:20 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 44TBZKTh002438;
	Wed, 29 May 2024 11:37:03 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3ydpb0kh7e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 May 2024 11:37:03 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 44TBb0jJ23527948
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 May 2024 11:37:02 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0DC9F58061;
	Wed, 29 May 2024 11:37:00 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BD55F58060;
	Wed, 29 May 2024 11:36:57 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 29 May 2024 11:36:57 +0000 (GMT)
From: Niklas Schnelle <schnelle@linux.ibm.com>
Date: Wed, 29 May 2024 13:36:26 +0200
Subject: [PATCH v3 3/3] vfio/pci: Enable PCI resource mmap() on s390 and
 remove VFIO_PCI_MMAP
Content-Type: text/plain; charset="utf-8"
Message-Id: <20240529-vfio_pci_mmap-v3-3-cd217d019218@linux.ibm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1848;
 i=schnelle@linux.ibm.com; h=from:subject:message-id;
 bh=i0eyyMMvW9e10XOJrVNQwFpRIiJqX7RCrvmSyLcYF0E=;
 b=owGbwMvMwCH2Wz534YHOJ2GMp9WSGNLChb0dK2azP9mb82/+rsOiGTefsmrGf1vJsk1AZpNm3
 Nw3z02tO0pZGMQ4GGTFFFkWdTn7rSuYYronqL8DZg4rE8gQBi5OAZiI83OGP5zSbOoz2VfLX93h
 tfVdjr7OhivrFQormlYpnGFivp/ensnIsEj60JuYPouDoo0VP1b6Mgf2H3p1Zv4jpmeCS9lXuwf
 fYAYA
X-Developer-Key: i=schnelle@linux.ibm.com; a=openpgp;
 fpr=9DB000B2D2752030A5F72DDCAFE43F15E8C26090
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: bBOaEOB85zer_lprQlDf1bKQfNs-SOWp
X-Proofpoint-GUID: -cqccsE2RxQO8XA0zLgu-4xcrbm-Gj50
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
 definitions=2024-05-29_07,2024-05-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 impostorscore=0 mlxscore=0 mlxlogscore=825 spamscore=0 lowpriorityscore=0
 adultscore=0 bulkscore=0 phishscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405290082

With the introduction of memory I/O (MIO) instructions enbaled in commit
71ba41c9b1d9 ("s390/pci: provide support for MIO instructions") s390
gained support for direct user-space access to mapped PCI resources.
Even without those however user-space can access mapped PCI resources
via the s390 specific MMIO syscalls. Thus mmap() can and should be
supported on all s390 systems with native PCI. Since VFIO_PCI_MMAP
enablement for s390 would make it unconditionally true and thus
pointless just remove it entirely.

Link: https://lore.kernel.org/all/c5ba134a1d4f4465b5956027e6a4ea6f6beff969.camel@linux.ibm.com/
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
---
 drivers/vfio/pci/Kconfig         | 4 ----
 drivers/vfio/pci/vfio_pci_core.c | 3 ---
 2 files changed, 7 deletions(-)

diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index bf50ffa10bde..c3bcb6911c53 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -7,10 +7,6 @@ config VFIO_PCI_CORE
 	select VFIO_VIRQFD
 	select IRQ_BYPASS_MANAGER
 
-config VFIO_PCI_MMAP
-	def_bool y if !S390
-	depends on VFIO_PCI_CORE
-
 config VFIO_PCI_INTX
 	def_bool y if !S390
 	depends on VFIO_PCI_CORE
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 0f1ddf2d3ef2..a0e2e2a806d1 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -121,9 +121,6 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_core_device *vdev)
 
 		res = &vdev->pdev->resource[bar];
 
-		if (!IS_ENABLED(CONFIG_VFIO_PCI_MMAP))
-			goto no_mmap;
-
 		if (!(res->flags & IORESOURCE_MEM))
 			goto no_mmap;
 

-- 
2.40.1


