Return-Path: <kvm+bounces-39276-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 31FEDA45E8E
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 13:20:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 347593B7430
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 12:15:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B00321A425;
	Wed, 26 Feb 2025 12:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="hr3udzsg"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9511222171E;
	Wed, 26 Feb 2025 12:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740571690; cv=none; b=sAjjNEdmW38RMFJZPCSEAO2lxHX2uWEH1rK4KdvEfmFaxFki5RcVYPSrUWYrbsETdCNkLWyCfFRkCIoF/D5pbao6g8kq3uzePxZC75GmTv01ZhOPu2BtlRii7dmaIjSbMRwhcvFQa3SeR/SFTKq9Lo9ZhJHrnMPkRjmd339v+YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740571690; c=relaxed/simple;
	bh=3u0K2JG/HNw0dRW/XSkrMcs7WQVrmrT6Ae9Xqa5j2/Y=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=avhlucK9FL7YnlGWXaG34Oceo49G954BFIjgn1zrXRpVxnWPF89GrNi8e+LwfL6YwULViPZNWEUnZmRu6B8qfARO7N0ALM90rKwozfH7fWt62EZzW7zpgQsgDs2qYpKeyRr9afQX5Hy4pTV5NRioVaUZsqcV8LPDpBvjEncMxuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=hr3udzsg; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51Q6PdXe028521;
	Wed, 26 Feb 2025 12:07:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=u41wp8eT8G1duWWZqU/lYgqgj2by
	hD5/C5psxHGfpWk=; b=hr3udzsgNQbrQl5brbOhibnYHjeqiN0lSaB6aceLkwXq
	GRGwoyOFxmZwcjirHAzRN3V9I5vtawMdHlp8rvV/m/U6AVqq4o6SDEpfK+pYG38E
	WaxOPAVjib6nIXSjpijTOJp1lodLGFvc1kKWX8uaKd/M0VZpTcWi0TMEBOa0toM8
	dS1we9t+borB0phfPOuLD7I2JUTQ6bESHwTaC4+xWIoqq7M1nlFvCCw2UbaA1hlt
	29tpUtQJX0Xu09oaEBWI5Ocasul7gyMLK9p5buXYpJ6kEc2W+fwtD+oAL5ksSIye
	B2vLyHRKJdFYmoodCrgYGYwgplzp7NP0KgbTWOK2dA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 451wp69dvm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Feb 2025 12:07:59 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 51QC41Vk016140;
	Wed, 26 Feb 2025 12:07:58 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 451wp69dvj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Feb 2025 12:07:58 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51QASJBC012465;
	Wed, 26 Feb 2025 12:07:57 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 44yrwstr3q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Feb 2025 12:07:57 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51QC7vLd19595930
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Feb 2025 12:07:57 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E9F6C58056;
	Wed, 26 Feb 2025 12:07:56 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1EA7B5803F;
	Wed, 26 Feb 2025 12:07:54 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 26 Feb 2025 12:07:53 +0000 (GMT)
From: Niklas Schnelle <schnelle@linux.ibm.com>
Subject: [PATCH v7 0/3] vfio/pci: s390: Fix issues preventing
 VFIO_PCI_MMAP=y for s390 and enable it
Date: Wed, 26 Feb 2025 13:07:44 +0100
Message-Id: <20250226-vfio_pci_mmap-v7-0-c5c0f1d26efd@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIABAEv2cC/23Q2WrDMBAF0F8Jeq7CzGiz89T/KCUoWhpBvWC3I
 iX43yuHlhrVj3dgDpd7Z3OYUpjZ6XBnU8hpTkNfgnk6MHe1/VvgyZfMCEiCAsFzTMN5dOncdXb
 kqGQbhAdy1rDyM04hptvDe3kt+Zrmj2H6evAZ1+uPRFhJGTlwilqgCgBKhuf31H/ejunSHd3Qs
 VXLtBXqLpmKAN5ph6K1MuKeILZCWwuiCM4TGg/YEjZ7gvwTNOlakEUwEUTTGIhAtCeoX0EBIdW
 CKoIWwtmyg9Le7gl6K8ha0KsQBYC7aGHNvyWXZfkGTZ9SzPgBAAA=
X-Change-ID: 20240503-vfio_pci_mmap-1549e3d02ca7
To: Bjorn Helgaas <helgaas@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Gerd Bayer <gbayer@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Thorsten Winkler <twinkler@linux.ibm.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc: Julian Ruess <julianr@linux.ibm.com>, Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pci@vger.kernel.org, Niklas Schnelle <schnelle@linux.ibm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=5671;
 i=schnelle@linux.ibm.com; h=from:subject:message-id;
 bh=3u0K2JG/HNw0dRW/XSkrMcs7WQVrmrT6Ae9Xqa5j2/Y=;
 b=owGbwMvMwCX2Wz534YHOJ2GMp9WSGNL3s4j5v7c8OV9H1Nz60Gbr2MsdFkn2f1OaGhaa77dcL
 PLEvU2xo5SFQYyLQVZMkWVRl7PfuoIppnuC+jtg5rAygQxh4OIUgIlwmzD8lfA0SLX7877YMlbg
 u6ioPoug4cNmkYUKnkdOxm+X11RLYfjNLlG1afE0ecOGzYsD9UtOf5fdassv9pNH4L5P4M4L8+K
 5AQ==
X-Developer-Key: i=schnelle@linux.ibm.com; a=openpgp;
 fpr=9DB000B2D2752030A5F72DDCAFE43F15E8C26090
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: VdZ9KsQiCYDpPATs-stLjJnYIfJmmzO7
X-Proofpoint-ORIG-GUID: _pKwfZL4VTKK31iVPqfzOXNfGZGBwVck
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-26_02,2025-02-26_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 impostorscore=0 mlxlogscore=800 clxscore=1015
 adultscore=0 spamscore=0 bulkscore=0 priorityscore=1501 phishscore=0
 suspectscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502100000 definitions=main-2502260096

With the introduction of memory I/O (MIO) instructions enbaled in commit
71ba41c9b1d9 ("s390/pci: provide support for MIO instructions") s390
gained support for direct user-space access to mapped PCI resources.
Even without those however user-space can access mapped PCI resources
via the s390 specific MMIO syscalls. There is thus nothing fundamentally
preventing s390 from supporting VFIO_PCI_MMAP, allowing user-space
drivers to access PCI resources without going through the pread()
interface. To actually enable VFIO_PCI_MMAP a few issues need fixing
however.

Firstly the s390 MMIO syscalls do not cause a page fault when
follow_pte() fails due to the page not being present. This breaks
vfio-pci's mmap() handling which lazily maps on first access.

Secondly on s390 there is a virtual PCI device called ISM which has
a few oddities. For one it claims to have a 256 TiB PCI BAR (not a typo)
which leads to any attempt to mmap() it fail with the following message:

    vmap allocation for size 281474976714752 failed: use vmalloc=<size> to increase size

Even if one tried to map this BAR only partially the mapping would not
be usable on systems with MIO support enabled. So just block mapping
BARs which don't fit between IOREMAP_START and IOREMAP_END. Solve this
by keeping the vfio-pci mmap() blocking behavior around for this
specific device via a PCI quirk and new pdev->non_mappable_bars
flag.

As noted by Alex Williamson With mmap() enabled in vfio-pci it makes
sense to also enable HAVE_PCI_MMAP with the same restriction for pdev->
non_mappable_bars. So this is added in patch 3 and I tested this with
another small test program.

Note:
For your convenience the code is also available in the tagged
b4/vfio_pci_mmap branch on my git.kernel.org site below:
https://git.kernel.org/pub/scm/linux/kernel/git/niks/linux.git/

Thanks,
Niklas

Link: https://lore.kernel.org/all/c5ba134a1d4f4465b5956027e6a4ea6f6beff969.camel@linux.ibm.com/
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
---
Changes in v7:
- Move all s390 changes, except for a one-lineer to set pdev->
  non_mappable_bars for all devices, to the third patch (Bjorn)
- Move checks in pci-sysfs.c and proc.c to the second patch (Bjorn)
- Only set ARCH_GENERIC_PCI_MMAP_RESOURCES not HAVE_PCI_MMAP following
  the recommendation for new architectures in
  Documentation/PCI/sysfs-pci.rst. This only enables the sysfs but not
  the proc interface.
- Link to v6: https://lore.kernel.org/r/20250214-vfio_pci_mmap-v6-0-6f300cb63a7e@linux.ibm.com

Changes in v6:
- Add a patch to also enable PCI resource mmap() via sysfs and proc
  exlcluding pdev->non_mappable_bars devices (Alex Williamson)
- Added Acks
- Link to v5: https://lore.kernel.org/r/20250212-vfio_pci_mmap-v5-0-633ca5e056da@linux.ibm.com

Changes in v5:
- Instead of relying on the existing pdev->non_compliant_bars introduce
  a new pdev->non_mappable_bars flag. This replaces the VFIO_PCI_MMAP
  Kconfig option and makes it per-device. This is necessary to not break
  upcoming vfio-pci use of ISM devices (Julian Ruess)
- Squash the removal of VFIO_PCI_MMAP into the second commit as this
  is now where its only use goes away.
- Switch to using follow_pfnmap_start() in MMIO syscall page fault
  handling to match upstream changes
- Dropped R-b's because the changes are significant
- Link to v4: https://lore.kernel.org/r/20240626-vfio_pci_mmap-v4-0-7f038870f022@linux.ibm.com

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
Niklas Schnelle (3):
      s390/pci: Fix s390_mmio_read/write syscall page fault handling
      PCI: s390: Introduce pdev->non_mappable_bars and replace VFIO_PCI_MMAP
      PCI: s390: Support mmap() of PCI resources except for ISM devices

 arch/s390/Kconfig                |  4 +---
 arch/s390/include/asm/pci.h      |  3 +++
 arch/s390/pci/Makefile           |  2 +-
 arch/s390/pci/pci_fixup.c        | 23 +++++++++++++++++++++++
 arch/s390/pci/pci_mmio.c         | 18 +++++++++++++-----
 drivers/pci/pci-sysfs.c          |  4 ++++
 drivers/pci/proc.c               |  4 ++++
 drivers/s390/net/ism_drv.c       |  1 -
 drivers/vfio/pci/Kconfig         |  4 ----
 drivers/vfio/pci/vfio_pci_core.c |  2 +-
 include/linux/pci.h              |  1 +
 include/linux/pci_ids.h          |  1 +
 12 files changed, 52 insertions(+), 15 deletions(-)
---
base-commit: d082ecbc71e9e0bf49883ee4afd435a77a5101b6
change-id: 20240503-vfio_pci_mmap-1549e3d02ca7

Best regards,
-- 
Niklas Schnelle


