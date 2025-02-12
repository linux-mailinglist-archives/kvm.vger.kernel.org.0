Return-Path: <kvm+bounces-37968-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 71A8CA32A24
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 16:33:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E1847188E02E
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 15:30:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3203212F89;
	Wed, 12 Feb 2025 15:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="RWpt4B6B"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD76211719;
	Wed, 12 Feb 2025 15:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739374184; cv=none; b=L+BtbkyMkHaffW59ZTeqh7eG4LT+r6UP8NVvim2zJa1XmlyvE9qEPCpGAbYWSKtqWZXqF8Mu9sm3eTXQ39XtDJfbzywBpLqLIjlL7eM85tZyXBi0/mgl2WCmEPCoQaw9qmyXqRHPJrK/FFzcQOekPkyNtChTwg67aKnAuyZTqqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739374184; c=relaxed/simple;
	bh=gWVsYqLuwJ7CAqCt36J55nN9VU6WmafeE6UVdUgCLf0=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=WIU+pLDwGJNBtwAeW1wqLKkgom61QrMfw+VuN+i0D2OQ1PBOIaLHZK/zRWWBd5BCRjIkDbjbr3IpKaAa9aIQqP6aEWDuOgAUuswYovBdbL4eQk+iGR2CCvPdiIs56xK7MJluDMKEptI/bOI2lkkxps1N/DiMnCWG+MTzsgOqSl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=RWpt4B6B; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51CCWCEZ008086;
	Wed, 12 Feb 2025 15:29:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=ZbeqsoMJOh1MCHbiET31piLClnAv
	GVOWiGlykHUGYek=; b=RWpt4B6BxWTrQx2fEDRhVTxMTqvMO4b1/zwmZ+ybuHb7
	owk0Wh6c1KIwBAYS66Z1We43knetP8WZEbhay5C3Dsw6xbHZ7hYzhBHneyb2LKcZ
	ncnzOyDoa7I6I7ggLRqO2Ai7ZXxqWoYp9KWU0VHMmoBi9zJPt/95QAnw7K9fsxDd
	IoJ0gEJ36D4HL4kwPSrc1/18ALAe8JY94Ve0hc+n/fP0E6TkK77SAGM0d17UDIPk
	0kS9Tv2qozsHJ8PKYRBc27hx2N9Iqd7zxWDtwdqPM+9NdRS4z6dl0Tc93cyC5jQd
	ZLfBJQqqbw7zjFUj7bDT2sAbsFPiaxFCiV0f2VN7rQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44rhqaby98-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 12 Feb 2025 15:29:33 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 51CFNmvH026517;
	Wed, 12 Feb 2025 15:29:32 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44rhqaby73-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 12 Feb 2025 15:29:32 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51CDgdl2028667;
	Wed, 12 Feb 2025 15:28:54 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 44pma1s4ar-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 12 Feb 2025 15:28:54 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51CFSrh128967672
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 12 Feb 2025 15:28:53 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7A37C5805C;
	Wed, 12 Feb 2025 15:28:53 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D3E8958058;
	Wed, 12 Feb 2025 15:28:49 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 12 Feb 2025 15:28:49 +0000 (GMT)
From: Niklas Schnelle <schnelle@linux.ibm.com>
Subject: [PATCH v5 0/2] vfio/pci: s390: Fix issues preventing
 VFIO_PCI_MMAP=y for s390 and enable it
Date: Wed, 12 Feb 2025 16:28:30 +0100
Message-Id: <20250212-vfio_pci_mmap-v5-0-633ca5e056da@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAB6+rGcC/23OSQoCMRCF4atI1kaqKkkPrryHiLQZtMAe6NagS
 N/dKIISXP4P6qMeYvIj+0msFw8x+sgT910Ks1wIe2q6o5fsUgsC0mBAyRi43w+W923bDBKNrr1
 yQLYpRboZRh/49va2u9Qnni79eH/zEV/rRyLMpIgSJIVCofEARvvNmbvrbcWHdmX7Vry0SL9C/
 kukJICzhUVVNzrgP0H9CnUuqCRYR1g6wJqw+ifor1BQkQs6CWUAVVUlBCDKhXmenxjxvq10AQA
 A
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4437;
 i=schnelle@linux.ibm.com; h=from:subject:message-id;
 bh=gWVsYqLuwJ7CAqCt36J55nN9VU6WmafeE6UVdUgCLf0=;
 b=owGbwMvMwCX2Wz534YHOJ2GMp9WSGNLX7JM35u1pCZjKP7089It9TWav15ojS8IWdYgsvbM37
 9XCPfqyHaUsDGJcDLJiiiyLupz91hVMMd0T1N8BM4eVCWQIAxenAEzkXAzDXxnNPR4FAkLTwp86
 fP6su/f6i1mXb5y7ee9uQ6LZG8ezr1wYGd7k/VOy6zQ/kq1ockrh31RXLbfO2+Kegb+2CddwzKn
 pYQAA
X-Developer-Key: i=schnelle@linux.ibm.com; a=openpgp;
 fpr=9DB000B2D2752030A5F72DDCAFE43F15E8C26090
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: xqdRDPfqog7RsALN5g2-rBBveKUMttUI
X-Proofpoint-GUID: h6TbmHHmPemMU8ojdshYN4mfAqv5Or1T
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-12_05,2025-02-11_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 mlxscore=0
 spamscore=0 lowpriorityscore=0 phishscore=0 suspectscore=0 adultscore=0
 impostorscore=0 bulkscore=0 mlxlogscore=658 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2501170000 definitions=main-2502120117

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

Note:
For your convenience the code is also available in the tagged
b4/vfio_pci_mmap branch on my git.kernel.org site below:
https://git.kernel.org/pub/scm/linux/kernel/git/niks/linux.git/

Thanks,
Niklas

Link: https://lore.kernel.org/all/c5ba134a1d4f4465b5956027e6a4ea6f6beff969.camel@linux.ibm.com/
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
---
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
Niklas Schnelle (2):
      s390/pci: Fix s390_mmio_read/write syscall page fault handling
      PCI: s390: Support mmap() of BARs and replace VFIO_PCI_MMAP by a device flag

 arch/s390/Kconfig                |  4 +---
 arch/s390/pci/Makefile           |  2 +-
 arch/s390/pci/pci_fixup.c        | 23 +++++++++++++++++++++++
 arch/s390/pci/pci_mmio.c         | 18 +++++++++++++-----
 drivers/s390/net/ism_drv.c       |  1 -
 drivers/vfio/pci/Kconfig         |  4 ----
 drivers/vfio/pci/vfio_pci_core.c |  2 +-
 include/linux/pci.h              |  1 +
 include/linux/pci_ids.h          |  1 +
 9 files changed, 41 insertions(+), 15 deletions(-)
---
base-commit: a64dcfb451e254085a7daee5fe51bf22959d52d3
change-id: 20240503-vfio_pci_mmap-1549e3d02ca7

Best regards,
-- 
Niklas Schnelle


