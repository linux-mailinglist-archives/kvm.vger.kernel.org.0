Return-Path: <kvm+bounces-15951-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C335C8B26E9
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 18:56:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 58B802843E2
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 16:56:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 994A114D6F5;
	Thu, 25 Apr 2024 16:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="szd5d+mg"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C49DB14A4C3;
	Thu, 25 Apr 2024 16:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714064178; cv=none; b=aKMLARMs8Hfs0BkVwvCh5BGMPA32ArwDBYGIHfbISTJZ52jhrVWynSJDaMUmtW7RHIpU7bxPToGY+LL7hdsdgs3aLdNJeuWMt5TjxpTDc3Tj5YTor38GXC+QdgQXQTpaFUkBuIpTgWpOV/HFb8pvIJWqzW67DzVjn2k1rjsn7oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714064178; c=relaxed/simple;
	bh=SvrpHqI1DnG3aJ3+OcGl75uJHq6QmTYrqB7GtIKLGtg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uufXZnelUnUVQ5EMhLO5fEBEW6plkgF/VZhZBf4nooxajVHIME5OJJPpw0sFToAzYy6StlCVIUtj/97cbG6sMUdRmEz9QpANtJKYmFDuKKJEpYBdM4LKHnQNhvZU128E7ygPQFigYoYZVY8kMho2J5UiO99z14tPjUGPnbzUto4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=szd5d+mg; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43PGO7ko022295;
	Thu, 25 Apr 2024 16:56:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=1UCMjC3/IVQO59ik+cJ7oVBC7N6KYgWfS6RWdsN+QIk=;
 b=szd5d+mgDFux+ZnT4xR5UUzbA9l8adVzHmvBRPwInkIRWWbcM5M81Cafez7RVfSg/pLL
 4O11kVe4+aTMU6TK48kN8y09L7JgqT9XZydEjb9XiXRdrPD0Yg0KTUIB8vNE9W9YmC5P
 moGLrTQJMO5rZQg7O3mIJQBnCqmpgGQLT60nalc0iEvvvYriTSrxTg69Lhz6xLsp5VzW
 umKwjwAtzkB4YpelbhMCQhZWYHRZws6OiIaSAGyWttOA8BDx4pVK7NJYSCu/6ZE4kR+d
 z3i2rbH2w/B7RlkMD1i/LIi0r8P2v4Y6Dda6BUjgpPUW9f2h99AuzoUgV8716POWnCv7 xQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xqtjf836g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Apr 2024 16:56:14 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43PGuDwT010095;
	Thu, 25 Apr 2024 16:56:13 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xqtjf836a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Apr 2024 16:56:13 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43PF8emj020907;
	Thu, 25 Apr 2024 16:56:12 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xmre0aywc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Apr 2024 16:56:12 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43PGu63q29426400
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Apr 2024 16:56:08 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C77A42004F;
	Thu, 25 Apr 2024 16:56:06 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A0D7A20043;
	Thu, 25 Apr 2024 16:56:06 +0000 (GMT)
Received: from dilbert5.boeblingen.de.ibm.com (unknown [9.152.212.201])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 25 Apr 2024 16:56:06 +0000 (GMT)
From: Gerd Bayer <gbayer@linux.ibm.com>
To: Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Niklas Schnelle <schnelle@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Ankit Agrawal <ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Julian Ruess <julianr@linux.ibm.com>,
        Gerd Bayer <gbayer@linux.ibm.com>
Subject: [PATCH v3 0/3] vfio/pci: Support 8-byte PCI loads and stores
Date: Thu, 25 Apr 2024 18:56:01 +0200
Message-ID: <20240425165604.899447-1-gbayer@linux.ibm.com>
X-Mailer: git-send-email 2.44.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: mKS8hLn5GkthhVUk2tuGNwJDUaryPs6m
X-Proofpoint-ORIG-GUID: ZPsBip09l2wGaI_T_gcmzHBhH1Jgtwec
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-25_16,2024-04-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 clxscore=1015 suspectscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2404250123

Hi all,

this all started with a single patch by Ben to enable writing a user-mode
driver for a PCI device that requires 64bit register read/writes on s390.
A quick grep showed that there are several other drivers for PCI devices
in the kernel that use readq/writeq and eventually could use this, too.
So we decided to propose this for general inclusion.

A couple of suggestions for refactorizations by Jason Gunthorpe and Alex
Williamson later [1], I arrived at this little series that avoids some
code duplication and structures the different-size accesses in
vfio_pci_core_do_io_rw() in a way that the conditional compile of
8-byte accesses no longer creates an odd split of "else-if".

The initial version was tested with a PCI device on s390. This version
has only been tested for reads of 1..8 byte sizes and only been compile
tested for a 32bit architecture (arm).

Thank you,
Gerd Bayer

[1] https://lore.kernel.org/all/20240422153508.2355844-1-gbayer@linux.ibm.com/

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
  vfio/pci: Continue to refactor vfio_pci_core_do_io_rw

 drivers/vfio/pci/vfio_pci_rdwr.c | 154 +++++++++++++++++--------------
 include/linux/vfio_pci_core.h    |   3 +
 2 files changed, 90 insertions(+), 67 deletions(-)

-- 
2.44.0


