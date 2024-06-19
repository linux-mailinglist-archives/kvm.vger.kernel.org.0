Return-Path: <kvm+bounces-19979-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 50F6090EA3F
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 13:59:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A0FE3B21D3E
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 11:59:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EFBE140368;
	Wed, 19 Jun 2024 11:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="foet4RCG"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3348D13E3EC;
	Wed, 19 Jun 2024 11:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718798357; cv=none; b=dTHyN3zW2uj1QptzpARLDHxYK+vdkGcnm9ZBIYPlAeQ6z2oAPg2nz8/0rr9FGAwwThWEJtCf11jqJbm/CqYLtMI9lCeFjydidQWqiq0pdmhMDngBA3aYFjMsFv0/vBbSYIeKj+m0XTIlHt+lYw3wUAfOoQPmN3blrnbIQyazkbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718798357; c=relaxed/simple;
	bh=F1uhSdwia5cH7VBRR65j9l3C1Mp6SwSVCJMMzszeeRY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ODv8x3tdwy9fxcmwljVbVHcaFgv85Vi7Sg2VfYGVhsPoLfXSjfqhbecdAh/DaDF/clFul6UcA9TOHYbLWRufWtLvQgxF9ayiWr6VId91MHWTpUlFUaM9h8axCIDrZjnlF0NU3zkqgolkmnKU5EH4U53BmYd585ib5aTnbd8f2vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=foet4RCG; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45JAqpdU006002;
	Wed, 19 Jun 2024 11:59:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:content-transfer-encoding
	:mime-version; s=pp1; bh=n/rtEfykQUwQ06nmzKO/HIVQVcNqdjQquLcerst
	2NXI=; b=foet4RCGOt03PqfnBSXizNNMIWtYLYXzyLs1xmq0o2bTAE9D8yD+Xdm
	6edMuKhXkkpfWO2ozPXjuLtTW7Imkfu8zdhkgja+RhuXnd+sGTecf8z01k7raM1T
	LmT0Q864RCgfxDDBaBFciYhAB0c2NPoBPZ7DFNAJX7P4eg6gxPyYoBsyUyE9PBFD
	0HgTeBMtVuqHOe0MM+tpTTla9DTQZlXvhlOPHDX8s5khFP74lFy1cI0evAGloAJt
	3X/Z5h4+tmD+GBmQPiLV40zmMOlvsJmZYMnMNm3x+g+XJjITEAdAJRUH4gLS99Lu
	AYkUX/2NVuW9WvDJyc6i2gjwy+t4jrQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yuwy0r6k0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Jun 2024 11:59:13 +0000 (GMT)
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45JBxCTh014601;
	Wed, 19 Jun 2024 11:59:12 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yuwy0r6jx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Jun 2024 11:59:12 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45JBpiiV019545;
	Wed, 19 Jun 2024 11:59:11 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3ysnp1c7aa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Jun 2024 11:59:10 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45JBx29E34472520
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Jun 2024 11:59:04 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A2AB22004B;
	Wed, 19 Jun 2024 11:59:02 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5456A20043;
	Wed, 19 Jun 2024 11:59:02 +0000 (GMT)
Received: from dilbert5.boeblingen.de.ibm.com (unknown [9.152.212.201])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 19 Jun 2024 11:59:02 +0000 (GMT)
From: Gerd Bayer <gbayer@linux.ibm.com>
To: Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Ramesh Thomas <ramesh.thomas@intel.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Ankit Agrawal <ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
        Halil Pasic <pasic@linux.ibm.com>, Ben Segal <bpsegal@us.ibm.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Julian Ruess <julianr@linux.ibm.com>,
        Gerd Bayer <gbayer@linux.ibm.com>
Subject: [PATCH v6 0/3] vfio/pci: Support 8-byte PCI loads and stores
Date: Wed, 19 Jun 2024 13:58:44 +0200
Message-ID: <20240619115847.1344875-1-gbayer@linux.ibm.com>
X-Mailer: git-send-email 2.45.2
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 9qW1w7B4c8GmFCHsYWCk4EKNetn4g8r0
X-Proofpoint-ORIG-GUID: 7thnJioFGcpZ3viCbijDvRI79LcriHZ_
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-19_02,2024-06-19_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 clxscore=1015 priorityscore=1501
 suspectscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2405170001
 definitions=main-2406190088

Hi all,

this all started with a single patch by Ben to enable writing a user-mode
driver for a PCI device that requires 64bit register read/writes on s390.
A quick grep showed that there are several other drivers for PCI devices
in the kernel that use readq/writeq and eventually could use this, too.
So we decided to propose this for general inclusion.

A couple of suggestions for refactorizations by Jason Gunthorpe and Alex
Williamson later [1], I arrived at this little series that avoids some
code duplication in vfio_pci_core_do_io_rw().
Also, I've added a small patch to correct the spelling in one of the
declaration macros that was suggested by Ramesh Thomas [2]. However,
after some discussions about making 8-byte accesses available for x86,
Ramesh and I decided to do this in a separate patch [3].

This version was tested with a pass-through PCI device in a KVM guest
and with explicit test reads of size 8, 16, 32, and 64 bit on s390.
For 32bit architectures this has only been compile tested for the
32bit ARM architecture.

Thank you,
Gerd Bayer


[1] https://lore.kernel.org/all/20240422153508.2355844-1-gbayer@linux.ibm.com/
[2] https://lore.kernel.org/kvm/20240425165604.899447-1-gbayer@linux.ibm.com/T/#m1b51fe155c60d04313695fbee11a2ccea856a98c
[3] https://lore.kernel.org/all/20240522232125.548643-1-ramesh.thomas@intel.com/

Changes v5 -> v6:
- restrict patch 3/3 to just the typo fix - no move of semicolons

Changes v4 -> v5:
- Make 8-byte accessors depend on the definitions of ioread64 and
  iowrite64, again. Ramesh agreed to sort these out for x86 separately.

Changes v3 -> v4:
- Make 64-bit accessors depend on CONFIG_64BIT (for x86, too).
- Drop conversion of if-else if chain to switch-case.
- Add patch to fix spelling of declaration macro.

Changes v2 -> v3:
- Introduce macro to generate body of different-size accesses in
  vfio_pci_core_do_io_rw (courtesy Alex Williamson).
- Convert if-else if chain to a switch-case construct to better
  accommodate conditional compiles.

Changes v1 -> v2:
- On non 64bit architecture use at most 32bit accesses in
  vfio_pci_core_do_io_rw and describe that in the commit message.
- Drop the run-time error on 32bit architectures.
- The #endif splitting the "else if" is not really fortunate, but I'm
  open to suggestions.


Ben Segal (1):
  vfio/pci: Support 8-byte PCI loads and stores

Gerd Bayer (2):
  vfio/pci: Extract duplicated code into macro
  vfio/pci: Fix typo in macro to declare accessors

 drivers/vfio/pci/vfio_pci_rdwr.c | 122 ++++++++++++++++---------------
 include/linux/vfio_pci_core.h    |  21 +++---
 2 files changed, 74 insertions(+), 69 deletions(-)

-- 
2.45.2


