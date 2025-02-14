Return-Path: <kvm+bounces-38165-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 895BEA35E9C
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 14:17:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E04F016F720
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 13:11:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCB5B264A6B;
	Fri, 14 Feb 2025 13:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="cGhzJJTq"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F43F77102;
	Fri, 14 Feb 2025 13:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739538685; cv=none; b=ijiS5B1JgevaWzrZe6vN8/twD7p4FK3rSXMprQtkLzRg060dI84EsAAadBg9XwZyhwQjdSTCj6AL6AZZiiuECYhCRffWjHIhVByDID8/1IiOsYuZLLKyw0TfrXBVUGi05q40grNgUjC6bQMFjky7pDB/YzDN6+RqDRxDgxNPoxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739538685; c=relaxed/simple;
	bh=smHNByFzoJREm/waNx2P9aacvN9ckvaVd7KCGpG0fx4=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=baU6pRDzIUDJqSdhM2nXLo/Ip0cGzee5GW/vrlCoq4P6e1kjWl+5fvW1jqvoDDrumxK7xZfzy2Vez0MSJQCojgqL5FhBzKloMwQ1TMwPYpnEXjQz8sm7o9b220Wb71nGETg1JanyfUmTWcF4+OllMN2oDFBoyI5l/lZ2qnsTADc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=cGhzJJTq; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51E5O3lC009361;
	Fri, 14 Feb 2025 13:11:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=Fja4xVeNx/bMj1gJITjbxsrKN8e1
	oiabrP7FR6RukB4=; b=cGhzJJTqEJlUPsyKTk6Zpdo+RFB2cb+MBPbjShbqa8/n
	rp7DUEG/LZu6KTq22rjX0wUifYRl6O2BylRQwgCQaJ6oqmAviJmf+FuUggQMYFhx
	dwKv7+3lekEgYI2mRHQ9rbrIH6m2Ew73/XTVpxEuLAaY8cMD1PPxJn8pkEAJ8Kmk
	nXi3sZg/Y8clwYVsOhRkfCoP7WKVruvbt/gV9Z53PU4589NpWJjpY/DveZM/JKhi
	nMp3SyCPYyNjpSTppX15e8CgoO4LPQIXT5KTD6IgzYZW/Ymt59Nf9/tuFvef3a8c
	4ibUxCbu1V2KbPTRHSZYhqZ8vz91QXIKTaVdnBHsnw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44syn82133-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Feb 2025 13:11:04 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 51ECnl70017522;
	Fri, 14 Feb 2025 13:11:03 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44syn8212w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Feb 2025 13:11:03 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51EBA7mm016692;
	Fri, 14 Feb 2025 13:11:02 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44pk3kkn8r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Feb 2025 13:11:02 +0000
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51EDB0Cc29098678
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Feb 2025 13:11:00 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 147EA5805D;
	Fri, 14 Feb 2025 13:11:01 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4378A58052;
	Fri, 14 Feb 2025 13:10:58 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 14 Feb 2025 13:10:58 +0000 (GMT)
From: Niklas Schnelle <schnelle@linux.ibm.com>
Subject: [PATCH v6 0/3] vfio/pci: s390: Fix issues preventing
 VFIO_PCI_MMAP=y for s390 and enable it
Date: Fri, 14 Feb 2025 14:10:51 +0100
Message-Id: <20250214-vfio_pci_mmap-v6-0-6f300cb63a7e@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIANtAr2cC/23Q22rDMAyA4Vcpvp6LJB+S9GrvUUbxfFgFy4FkN
 R0l7z63bKyYXP4CfQjdxBJnjos47G5ijpkXHocS9mUn/NkNH1FyKC0ISIMBJXPi8TR5PvW9myQ
 a3UUVgLxrRNmZ5pj4+vCOb6XPvHyN8/eDz3if/kqElZRRgqRkFZoIYHR8/eThct3ze7/3Yy/uW
 qZnob4lUxEgeOtRdU4n3BLUs9DVgiqCD4RNAOwI2y1B/wuWbC3oIjQJVNs2kIBoSzB/ggFCqgV
 TBKuUd+UPxgZXC+u6/gCVOGNhtgEAAA==
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5176;
 i=schnelle@linux.ibm.com; h=from:subject:message-id;
 bh=smHNByFzoJREm/waNx2P9aacvN9ckvaVd7KCGpG0fx4=;
 b=owGbwMvMwCX2Wz534YHOJ2GMp9WSGNLXO9xfpu144+b8psYGmS2LLmXee6V71aBx6+xYZ7bGJ
 Se6K85pdJSyMIhxMciKKbIs6nL2W1cwxXRPUH8HzBxWJpAhDFycAjCR7D2MDP+rFpUfuqp/J0Vc
 qSfN8+tBh+Y3ze0LVu02n/XxQNI8XkmGf1oTpwaYMFzK43w+i0tqSfijzXK/f7/Uag6f3zpv0m8
 HTzYA
X-Developer-Key: i=schnelle@linux.ibm.com; a=openpgp;
 fpr=9DB000B2D2752030A5F72DDCAFE43F15E8C26090
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 1jQqn2ulCy_v-afykCScBXVsAZgvVu9Q
X-Proofpoint-GUID: CSF8pbJimSf5O13q-h8tTAQVcHT2zsRF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-14_05,2025-02-13_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 lowpriorityscore=0 mlxscore=0 spamscore=0 bulkscore=0
 impostorscore=0 malwarescore=0 suspectscore=0 clxscore=1015
 mlxlogscore=797 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2501170000 definitions=main-2502140096

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
      PCI: s390: Support mmap() of BARs and replace VFIO_PCI_MMAP by a device flag
      PCI: s390: Enable HAVE_PCI_MMAP on s390 and restrict mmap() of resources to mappable BARs

 arch/s390/Kconfig                |  4 +---
 arch/s390/include/asm/pci.h      |  4 ++++
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
 12 files changed, 53 insertions(+), 15 deletions(-)
---
base-commit: a64dcfb451e254085a7daee5fe51bf22959d52d3
change-id: 20240503-vfio_pci_mmap-1549e3d02ca7

Best regards,
-- 
Niklas Schnelle


