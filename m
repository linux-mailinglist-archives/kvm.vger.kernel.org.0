Return-Path: <kvm+bounces-18279-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FE8C8D35A4
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 13:37:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2A8311F240BB
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 11:37:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F4D6180A85;
	Wed, 29 May 2024 11:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="qZbnPzFR"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA4CA14B076;
	Wed, 29 May 2024 11:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716982622; cv=none; b=dChiX5PCSb1u/xuh3XiyNL8ik4wQJt5v3ZtrdMUXyanmgY98ryZDCn81QjBhneCq/EFWqaDOU0JBiMTTiDUMGsXDzE6YoOgGh6g+dxejHQj2F6bQOZQUo2UjOCcYRXUzAfa7EmDugqJKV9rsQKOnIjqXJe3jTvXdK30VUGkOwis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716982622; c=relaxed/simple;
	bh=eHfN1A/rfIS0CapoYg53pVoeTJWVICy3iL+Eg1kCnJI=;
	h=From:Subject:Date:Message-Id:Content-Type:To:Cc:MIME-Version; b=a3PZY4527QtbQRBS2NZip0Z6nt7OTUSGhFVfhF2JxRMob+fp5ZdCSijAl8Ll0VxKPYQl5uGg5cSbnfGgjTR+YT4qrG02o95ovPHVnWA5U9+dN9bNPKDNwXRfKFxCVrSVNOOQkiY2oTF+h/rO/3gC5/3FheEq+ev1TN401F1pXAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=qZbnPzFR; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44TB7SaD027129;
	Wed, 29 May 2024 11:36:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc :
 content-transfer-encoding : content-type : date : from : message-id :
 mime-version : subject : to; s=pp1;
 bh=cPpLddstzRyWCwXzhieF/8HGcYtmMP17OOf5VpK3MLA=;
 b=qZbnPzFRAXEakitbtMdNX56C52bFhCTDzN7wia2YRD5EZjCN9qDxisuCba39PstCzfRA
 4IPL874UDQDC0BG0p7qn6YhWf66uyzsF/mbf1ryxifbA80GC2vqov9yrjPIMnB1bGpW0
 WZ8NtEEowsugbVWkjev41+alwdQG1kQ18AxDDDFMDjTriRXFCqrqMVKfeMQpMAofgg+o
 mfXVuXk9npLbk5Q/Xl04xMe/ZaZUxcAdtOzKIgB5dbJhWBkkKg/YRHA2kxBWANHH7RhF
 qAG8EiBrtZsyhY68l8oqb9mbKsfPcHb938jIh7Iz27ZfyfKgJh5rGqZ4hEV2/IwAN5jw 3w== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ye36yr2au-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 May 2024 11:36:57 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44TBavJg012975;
	Wed, 29 May 2024 11:36:57 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ye36yr2as-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 May 2024 11:36:56 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 44T82jJ1006890;
	Wed, 29 May 2024 11:36:55 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3ydpebbfxx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 May 2024 11:36:55 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 44TBaqUI13173392
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 May 2024 11:36:54 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 434F758068;
	Wed, 29 May 2024 11:36:52 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F02A85805D;
	Wed, 29 May 2024 11:36:49 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 29 May 2024 11:36:49 +0000 (GMT)
From: Niklas Schnelle <schnelle@linux.ibm.com>
Subject: [PATCH v3 0/3] vfio/pci: s390: Fix issues preventing
 VFIO_PCI_MMAP=y for s390 and enable it
Date: Wed, 29 May 2024 13:36:23 +0200
Message-Id: <20240529-vfio_pci_mmap-v3-0-cd217d019218@linux.ibm.com>
Content-Type: text/plain; charset="utf-8"
X-B4-Tracking: v=1; b=H4sIADcTV2YC/13OTQrCMBCG4atI1qZM/ip15T1ESkwTO2Cakmiol
 N7dtLiQLt8P5mFmkmxEm8j5MJNoMyYMQwlxPBDT6+FhKXalCQcuQYGg2WFoR4Ot93qkTMnGig6
 40SdSbsZoHU6bd72V7jG9QvxsfGbr+pM420mZUaDc1YIpC6CkvTxxeE8V3n1lgierlvm/sP8l8
 yJAZ2rDRKOlY3thWZYvLLWu/vAAAAA=
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2825;
 i=schnelle@linux.ibm.com; h=from:subject:message-id;
 bh=eHfN1A/rfIS0CapoYg53pVoeTJWVICy3iL+Eg1kCnJI=;
 b=owGbwMvMwCH2Wz534YHOJ2GMp9WSGNLChS13as+24500P+Txsj+nS4MMyv9N7bSSaZa7UVoWd
 D64+KRARykLgxgHg6yYIsuiLme/dQVTTPcE9XfAzGFlAhnCwMUpABPhXMHI0DS9/lBE+PS4rabL
 OoJVC85XK9bvvcuusL+8775XmoiSMSPDRSO3r5l7Ui3tRNY95E56ZDV1kor7hO5FXxR/xDZ0/5/
 MBAA=
X-Developer-Key: i=schnelle@linux.ibm.com; a=openpgp;
 fpr=9DB000B2D2752030A5F72DDCAFE43F15E8C26090
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: MziQWbUZ_XprmV72lpGDiyoMC70gs3wg
X-Proofpoint-ORIG-GUID: gu8ocwa5rTxJR_qMhFnynLJosCImq1Lu
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
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 bulkscore=0 impostorscore=0 suspectscore=0 phishscore=0
 mlxlogscore=660 priorityscore=1501 clxscore=1015 malwarescore=0
 adultscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405290079

With the introduction of memory I/O (MIO) instructions enbaled in commit
71ba41c9b1d9 ("s390/pci: provide support for MIO instructions") s390
gained support for direct user-space access to mapped PCI resources.
Even without those however user-space can access mapped PCI resources
via the s390 specific MMIO syscalls. There is thus nothing fundamentally
preventing s390 from supporting VFIO_PCI_MMAP allowing user-space drivers
to access PCI resources without going through the pread() interface.
To actually enable VFIO_PCI_MMAP a few issues need fixing however.

Firstly the s390 MMIO syscalls do not cause a page fault when
follow_pte() fails due to the page not being present. This breaks
vfio-pci's mmap() handling which lazily maps on first access.

Secondly on s390 there is a virtual PCI device called ISM which has
a few oddities. For one it claims to have a 256 TiB PCI BAR (not a typo)
which leads to any attempt to mmap() it fail with the following message:

    vmap allocation for size 281474976714752 failed: use vmalloc=<size> to increase size

Even if one tried to map this BAR only partially the mapping would not
be usable on systems with MIO support enabled. So just block mapping
BARs which don't fit between IOREMAP_START and IOREMAP_END.

Note:
For your convenience the code is also available in the tagged
b4/vfio_pci_mmap branch on my git.kernel.org site below:
https: //git.kernel.org/pub/scm/linux/kernel/git/niks/linux.git/

Thanks,
Niklas

Link: https://lore.kernel.org/all/c5ba134a1d4f4465b5956027e6a4ea6f6beff969.camel@linux.ibm.com/
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
---
Changes in v3:
- Rebased on v6.10-rc1 requiring change to follow_pte() call
- Use current->mm for fixup_user_fault() as seems more common
- Collected new trailers
- Link to v2: https://lore.kernel.org/r/20240523-vfio_pci_mmap-v2-0-0dc6c139a4f1@linux.ibm.com

Changes in v2:
- Changed last patch to remove VFIO_PCI_MMAP instead of just enabling it
  for s390 as it is unconditionally true with s390 supporting PCI resource mmap() (Jason)
- Collected R-bs from Jason
- Link to v1: https://lore.kernel.org/r/20240521-vfio_pci_mmap-v1-0-2f6315e0054e@linux.ibm.com

---
Niklas Schnelle (3):
      s390/pci: Fix s390_mmio_read/write syscall page fault handling
      vfio/pci: Tolerate oversized BARs by disallowing mmap
      vfio/pci: Enable PCI resource mmap() on s390 and remove VFIO_PCI_MMAP

 arch/s390/pci/pci_mmio.c         | 18 +++++++++++++-----
 drivers/vfio/pci/Kconfig         |  4 ----
 drivers/vfio/pci/vfio_pci_core.c | 11 ++++++-----
 3 files changed, 19 insertions(+), 14 deletions(-)
---
base-commit: 1613e604df0cd359cf2a7fbd9be7a0bcfacfabd0
change-id: 20240503-vfio_pci_mmap-1549e3d02ca7

Best regards,
-- 
Niklas Schnelle


