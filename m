Return-Path: <kvm+bounces-18034-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A354D8CD0EC
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 13:11:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 59675281A6A
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 11:11:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73051147C8B;
	Thu, 23 May 2024 11:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="d6OCJ6BT"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E284146D52;
	Thu, 23 May 2024 11:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716462636; cv=none; b=BHoW8H8+fzeJZy6Sgva92S3Od1aeXN8S1Wl1mzxoa8OX5XAJ9p9Y4dVLWuAkH+bWUzBLD8ecA7rieB/+97v0QI/RDvW2L5g4fCrnVa/Z30A/eI2t3FYD+BcEqWSrrDM5SJYXt0r4FOz+k8ZZifEfc7rpCJDCtsHLv+ElAJkVE5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716462636; c=relaxed/simple;
	bh=QXGpVmmc87GQTcdZPyB/66d2yE9od87wnEMFzrw/peg=;
	h=From:Subject:Date:Message-Id:Content-Type:To:Cc:MIME-Version; b=jsAxAwnTUmO/oTFMR4dkT2Q3g4NYRcqUvaUTOCAz8om+qUGdkkproGrfwoK4oh5yyTpogeWO+ODMAMzG3eb1r1DY6zwC5X5LF7Ynq3fZxMd2JEHlVKjcoOwaAoobCkKJDk5LQW2JuIrpGbvL9FlS/zfVnIj7l8LiSUXOBNAK3FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=d6OCJ6BT; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44NArBvw015392;
	Thu, 23 May 2024 11:10:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : subject : date :
 message-id : content-type : to : cc : content-transfer-encoding :
 mime-version; s=pp1; bh=L/1T+dGcEdjHWGsailh8UuaJJpxk3Txzg0SY1WbgxjQ=;
 b=d6OCJ6BTWJkqGpnT5772o9msWRerisG24nGVx1+N08tphEIuIPW8u6UMrJEp/rVx6Gfe
 8v35M8CMSsoT595dzAiBd06F24lsCq/rMXH+KqvvtDwxXwrR5yRs5/Yud6YMA/IP6GUu
 B9xUcAaYlE9wYR3MIGSu4f7ix9h6W7+TVzy3mKGvZbKiNUbQxtfVzX0KNMwY8akxS92M
 3h+fMZ+/a9yN3TlqjyefI6T6JPc5pyEzmrUaRQfE8WW2fhfgPeS4UOIFjSh8C7oOuJ/5
 214+EXWa3VshsIuodYHQ0GPLXDygLwI1LoU294MlFY7+89mv3afGIhLLTQJsAOydf6Wp pw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ya4edr1fm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 May 2024 11:10:32 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44NBAV8e009724;
	Thu, 23 May 2024 11:10:32 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ya4edr1fj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 May 2024 11:10:31 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 44N9vthX000893;
	Thu, 23 May 2024 11:10:31 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3y7720ht00-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 May 2024 11:10:31 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 44NBASLN7471686
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 May 2024 11:10:30 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 32E2158050;
	Thu, 23 May 2024 11:10:28 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C97185806A;
	Thu, 23 May 2024 11:10:25 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 23 May 2024 11:10:25 +0000 (GMT)
From: Niklas Schnelle <schnelle@linux.ibm.com>
Subject: [PATCH v2 0/3] vfio/pci: s390: Fix issues preventing
 VFIO_PCI_MMAP=y for s390 and enable it
Date: Thu, 23 May 2024 13:10:13 +0200
Message-Id: <20240523-vfio_pci_mmap-v2-0-0dc6c139a4f1@linux.ibm.com>
Content-Type: text/plain; charset="utf-8"
X-B4-Tracking: v=1; b=H4sIABUkT2YC/13MQQ6CMBCF4auQWVsyLVSjK+5hCMEyyCSWklYbD
 OndrcSVy/8l79sgkGcKcCk28BQ5sJtzqEMBZurnOwkecoNCVaPGSsSRXbcY7qztFyF1faZqQGX
 6E+TP4mnkdfeube6Jw9P5985H+V1/kpJ/UpQChRqPldSEqGtqHjy/1pJvtjTOQptS+gCCY714r
 gAAAA==
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2571;
 i=schnelle@linux.ibm.com; h=from:subject:message-id;
 bh=QXGpVmmc87GQTcdZPyB/66d2yE9od87wnEMFzrw/peg=;
 b=owGbwMvMwCH2Wz534YHOJ2GMp9WSGNL8VRQSfTzDm7q2MPuXn235FlT7I6UgIV5r2dJaj3yWG
 05H2IQ7SlkYxDgYZMUUWRZ1OfutK5hiuieovwNmDisTyBAGLk4BmMjxZYwML3Q1ttqd3aSrzy7O
 MW/9rwm9vvmNLnWMhf/O5z6qldTuZ/inqlpsu2xe7kK9t0v26T7x4s+L3cN+TUvrRHLnm54jk0X
 ZAQ==
X-Developer-Key: i=schnelle@linux.ibm.com; a=openpgp;
 fpr=9DB000B2D2752030A5F72DDCAFE43F15E8C26090
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Qrm_MNA7L3nwm3s0Kz2sAY7CkwonXMbu
X-Proofpoint-ORIG-GUID: TVsveBPXB2bHcP5o0w6_6JRFlF_osAsP
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
 definitions=2024-05-23_07,2024-05-23_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=601
 lowpriorityscore=0 adultscore=0 mlxscore=0 impostorscore=0 bulkscore=0
 phishscore=0 priorityscore=1501 clxscore=1015 spamscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405230075

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
For your convenience the code is also available in the tagged and signed
b4/vfio_pci_mmap branch on my git.kernel.org site below:
https: //git.kernel.org/pub/scm/linux/kernel/git/niks/linux.git/

Thanks,
Niklas

Link: https://lore.kernel.org/all/c5ba134a1d4f4465b5956027e6a4ea6f6beff969.camel@linux.ibm.com/
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
---
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
base-commit: a38297e3fb012ddfa7ce0321a7e5a8daeb1872b6
change-id: 20240503-vfio_pci_mmap-1549e3d02ca7

Best regards,
-- 
Niklas Schnelle


