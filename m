Return-Path: <kvm+bounces-20540-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BFABD917F64
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 13:17:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E31871C23814
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 11:17:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4589F17FACA;
	Wed, 26 Jun 2024 11:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="GAWJP/Qs"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23D5813AD11;
	Wed, 26 Jun 2024 11:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719400601; cv=none; b=ZKazitnJjC4RJvjrd8d9W9bFpqlqn+VatiQt3bExdCLeYZ5ffaCVWPRD386hS06OO0ytZgmhoeplMLtwB6XkXKYo+KcEIl9kg6kTJpS/eUfjR9oyXG3yGSak+f6+MNH2gG5j7C2ZU9ODkM1THtrvAFvU6eV2V+pHSUwD9lb+Z34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719400601; c=relaxed/simple;
	bh=I946q1l7FMxkyjsVQY7ZjAp1q4VUvz/02NZTBD7ZVgc=;
	h=From:Subject:Date:Message-Id:Content-Type:To:Cc:MIME-Version; b=c9BLipPK5MX9ZlEMgzvbO835YTBn8aU9TU2mKGytxce+NZezFKqnCCfKk0aAG/XLoy9TgH3Sm/oAx4zUI081BmoJDvght9l5w4UWY0NZrlD52hY4b65C+f4TJgIvsV8MzyrbQCSm3V/fi7bFzSX8b8mooM0KyL+QGnlGMuKOymc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=GAWJP/Qs; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45QAvWeP011321;
	Wed, 26 Jun 2024 11:16:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:subject:date:message-id:content-type:to:cc
	:content-transfer-encoding:mime-version; s=pp1; bh=QmcMEMjXDc91M
	Cn2m6AND+Wi69TJ9UXsdjk9WiSsZys=; b=GAWJP/QsbYYZHM0jNy8iC4+yHFYa0
	4kEytAOevQOK/5CcdSwsKJMI8dYb2feqy7kGqNb+rSPRW85/xe8CLbKHI7/n0VqI
	r31BtXoiKvllbtXGVQsKeIMF5h5dO314PLbebJaAM4tAPGN6WIsW2WWTvPtv07+9
	hNFogL6YFOGy8ipzZLVS+p5deN0rsSZlCFctgp1aYuGjEUupCF8W4iAUJe2FX1jJ
	LGZoQqASvAD0cF50UsMf2QcphfpwkJqOM/BkzeK5qD7tZNsjr+fw+q7/rDWEww11
	14+s2NJNnc2JtllD7+mjKYSzSzIMS4+QW8c2KHZz5V211zTZTJY5tSdcw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 400h8vg3uy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Jun 2024 11:16:29 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45QBGSSk011009;
	Wed, 26 Jun 2024 11:16:29 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 400h8vg3uu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Jun 2024 11:16:28 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45QACPtI019963;
	Wed, 26 Jun 2024 11:16:28 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3yxb5mktsn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Jun 2024 11:16:27 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45QBGOcO22479614
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Jun 2024 11:16:26 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 88B5558061;
	Wed, 26 Jun 2024 11:16:24 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D2CFB58053;
	Wed, 26 Jun 2024 11:16:21 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 26 Jun 2024 11:16:21 +0000 (GMT)
From: Niklas Schnelle <schnelle@linux.ibm.com>
Subject: [PATCH v4 0/4] vfio/pci: s390: Fix issues preventing
 VFIO_PCI_MMAP=y for s390 and enable it
Date: Wed, 26 Jun 2024 13:15:47 +0200
Message-Id: <20240626-vfio_pci_mmap-v4-0-7f038870f022@linux.ibm.com>
Content-Type: text/plain; charset="utf-8"
X-B4-Tracking: v=1; b=H4sIAGP4e2YC/23OTQqDMBCG4auUrBuZmUStXfUepYhNYh2oP2gbL
 OLdG6ULkS7fD+ZhJjG4nt0gzodJ9M7zwG0TQh8PwlRF83CSbWhBQBpiUNKX3Oad4byui05irDO
 nLJApUhFuut6VPK7e9Ra64uHV9p+V97isP4lwJ3mUIKlMFMYOINbu8uTmPUZ8ryPT1mLRPG2F/
 S+eggDWJAZVVugS/wlqK2R7QQXBWMLUAmaEp70wz/MX2roRBjIBAAA=
To: Bjorn Helgaas <helgaas@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3722;
 i=schnelle@linux.ibm.com; h=from:subject:message-id;
 bh=I946q1l7FMxkyjsVQY7ZjAp1q4VUvz/02NZTBD7ZVgc=;
 b=owGbwMvMwCH2Wz534YHOJ2GMp9WSGNKqf6T1Cvl58oo/OS+ms2NVDwPTxbf1c2uaIpR2qgTH7
 5u576lIRykLgxgHg6yYIsuiLme/dQVTTPcE9XfAzGFlAhnCwMUpABP5rMjI8C5sv4l8yPT/G6cU
 dpZfdRF4lZteaZ2k9tfV/zmfnHdWBsP/HAbes1Hb1+Tr6D8wMT1sc6tF+Xr7zqq5s+unXfvPa+T
 KDgA=
X-Developer-Key: i=schnelle@linux.ibm.com; a=openpgp;
 fpr=9DB000B2D2752030A5F72DDCAFE43F15E8C26090
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: KexWSTTTSYwiORvJcEHtsWOpU9oFKGgQ
X-Proofpoint-GUID: 9VtXidixh7kfXA9We0TFb6wYoGkKYMcu
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-26_05,2024-06-25_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 bulkscore=0 suspectscore=0 mlxscore=0 spamscore=0 priorityscore=1501
 impostorscore=0 mlxlogscore=406 clxscore=1011 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2406260082

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
Changes in v4:
- Overhauled and split up patch 2 which caused errors on ppc due to
  unexported __kernel_io_end. Replaced it with a minimal s390 PCI fixup
  harness to set pdev->non_compliant_bars for ISM plus ignoring devices
  with this flag in vfio-pci. Idea for using PCI quirks came from
  Christoph Hellwig, thanks. Dropped R-bs for patch 2 accordingly.
- Rebased on v6.10-rc5 which includes the vfio-pci mmap fault handler
  fix to the issue I stumbled over independently in v3
- Link to v3: https://lore.kernel.org/r/20240529-vfio_pci_mmap-v3-0-cd217d019218@linux.ibm.com

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
Niklas Schnelle (4):
      s390/pci: Fix s390_mmio_read/write syscall page fault handling
      s390/pci: Add quirk support and set pdev-non_compliant_bars for ISM devices
      vfio/pci: Disable mmap() non-compliant BARs
      vfio/pci: Enable PCI resource mmap() on s390 and remove VFIO_PCI_MMAP

 arch/s390/Kconfig                |  4 +---
 arch/s390/pci/Makefile           |  2 +-
 arch/s390/pci/pci_fixup.c        | 23 +++++++++++++++++++++++
 arch/s390/pci/pci_mmio.c         | 18 +++++++++++++-----
 drivers/s390/net/ism_drv.c       |  1 -
 drivers/vfio/pci/Kconfig         |  4 ----
 drivers/vfio/pci/vfio_pci_core.c |  8 ++------
 include/linux/pci_ids.h          |  1 +
 8 files changed, 41 insertions(+), 20 deletions(-)
---
base-commit: f2661062f16b2de5d7b6a5c42a9a5c96326b8454
change-id: 20240503-vfio_pci_mmap-1549e3d02ca7

Best regards,
-- 
Niklas Schnelle


