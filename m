Return-Path: <kvm+bounces-17832-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D7A768CADF8
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 14:15:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1E2A9B234AB
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 12:15:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDFE0763F0;
	Tue, 21 May 2024 12:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Jq+CAtzQ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F78F4F613;
	Tue, 21 May 2024 12:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716293735; cv=none; b=j2yD+KRQvm5SDgFQAbfqj3P/5jh+I42ZcmVmDTANtj+vk3ZVe9eer54Qea9yTL6UmgkSDuDX/IQOlSVmNNs2OKkxuzbBsDFyNWuyX0wTmLkguiME9bXYZPFsSw+x7lVi6xLFPtKEXXwmzS/Mj365WxTSgVWumSV9GSRrGg58Y70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716293735; c=relaxed/simple;
	bh=FGMBhZF5fI9phy6STe357dhlmqhZWSl8UcKnEapLMTM=;
	h=From:Subject:Date:Message-Id:Content-Type:To:Cc:MIME-Version; b=CUYoApbVS4prmTl8iDIK5eNH0Jyep0Z75yg82qMhYI3ZJz3IP67y8alSPiUU+qJYMK1GtjEeeDnuLhvW/JfIbFa4MPPTumt5jZuq1xihbwuIYvx0P63cgMMG2MppuI2FHSxSd642H9lNPpPWmBaZfZ2Aoj64sNCnE1+y/PWbMQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Jq+CAtzQ; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44LC6wZV016281;
	Tue, 21 May 2024 12:15:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : subject : date :
 message-id : content-type : to : cc : content-transfer-encoding :
 mime-version; s=pp1; bh=XE4ITXTQvw4tJmOT+42F6T48htuW2dEA28E8xztL1M0=;
 b=Jq+CAtzQcg6FVKAaj3XpxWzhQ7GJ35VJyZTYJ8iWnmPJZoLLiBdewAUOCj1l0+dgvmI7
 SheDDVInajqymL/I9dYaNX57qKKekwqxShrra/XzxgxIyz4OmBffwybwyOm6jOl1/M59
 Zejjob1dpWtLhPn79zuAcTDbQS2vIeQyPjAhuY0cay1PlZl96sVlDjOhFP+g81EwmkhB
 ZgVbZnh5kkW0dHvxy4uuaaUnV/n7vxyuelwuH6DWRnJfm/iypO/6yokHW9AjnGEplBGf
 Ea0qOsoEKkxkvQuVzRiohn76/RGAmsg0yEVONq/5H9IjKOPl9NvMvvWqLjk9oVKNuVxe yg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3y8ub3r0v7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 May 2024 12:15:32 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44LCELgi027805;
	Tue, 21 May 2024 12:15:31 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3y8ub3r0v3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 May 2024 12:15:31 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 44L8Y6at007817;
	Tue, 21 May 2024 12:15:30 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3y78vkw5f9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 May 2024 12:15:30 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 44LCFRFc31982224
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 May 2024 12:15:30 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CC8A45805F;
	Tue, 21 May 2024 12:15:27 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 07B6D58043;
	Tue, 21 May 2024 12:15:26 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 21 May 2024 12:15:25 +0000 (GMT)
From: Niklas Schnelle <schnelle@linux.ibm.com>
Subject: [PATCH 0/3] vfio/pci: s390: Fix issues preventing VFIO_PCI_MMAP=y
 for s390 and enable it
Date: Tue, 21 May 2024 14:14:56 +0200
Message-Id: <20240521-vfio_pci_mmap-v1-0-2f6315e0054e@linux.ibm.com>
Content-Type: text/plain; charset="utf-8"
X-B4-Tracking: v=1; b=H4sIAECQTGYC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIxMDUwNj3bK0zPz4guTM+NzcxAJdQ1MTy1TjFAOj5ERzJaCegqLUtMwKsHn
 RsbW1AIKc92lfAAAA
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2222;
 i=schnelle@linux.ibm.com; h=from:subject:message-id;
 bh=FGMBhZF5fI9phy6STe357dhlmqhZWSl8UcKnEapLMTM=;
 b=owGbwMvMwCH2Wz534YHOJ2GMp9WSGNJ8JkQrTZ4q6tmyPvg1Q7QAd3Ft9NwvW04nTFsc/HFZ0
 6M7Jpw6HaUsDGIcDLJiiiyLupz91hVMMd0T1N8BM4eVCWQIAxenAExkw3pGhp/C3mEvFijG5379
 onPpqfTZxsjJ++/qW95m/JAgoGIZH8jIcDFXumGJQ3FQcYvcLfE473+tM1g8NRqqTz4IsPZlK+/
 lAwA=
X-Developer-Key: i=schnelle@linux.ibm.com; a=openpgp;
 fpr=9DB000B2D2752030A5F72DDCAFE43F15E8C26090
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 4qO4Pjv2r9eKKQ2G7KGeSCOHhPe-1MmU
X-Proofpoint-GUID: uj0223dM56aVXRX1otLl6it3bqbPHPRv
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
 definitions=2024-05-21_08,2024-05-21_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 impostorscore=0 clxscore=1011 phishscore=0 lowpriorityscore=0
 malwarescore=0 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=760
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405210092

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
Niklas Schnelle (3):
      s390/pci: Fix s390_mmio_read/write syscall page fault handling
      vfio/pci: Tolerate oversized BARs by disallowing mmap
      vfio/pci: Enable VFIO_PCI_MMAP for s390

 arch/s390/pci/pci_mmio.c         | 18 +++++++++++++-----
 drivers/vfio/pci/Kconfig         |  2 +-
 drivers/vfio/pci/vfio_pci_core.c |  8 ++++++--
 3 files changed, 20 insertions(+), 8 deletions(-)
---
base-commit: a38297e3fb012ddfa7ce0321a7e5a8daeb1872b6
change-id: 20240503-vfio_pci_mmap-1549e3d02ca7

Best regards,
-- 
Niklas Schnelle


