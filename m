Return-Path: <kvm+bounces-18930-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 992568FD25A
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 18:02:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8C2381C23A94
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 16:02:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB662188CBE;
	Wed,  5 Jun 2024 16:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="rKRVv+TM"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59A7A14D28E;
	Wed,  5 Jun 2024 16:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717603296; cv=none; b=ur6ga5Gj51/9++CZ9jx9CZnJ63CfkRBq4MWR9/AlG1zHWF1W4O4uw26saRLNKoKDu31Oj6Mj3MoNtkhmFQMXTzG2RZEr8fdb8KQqvHK9HZh3D0Zw68vO24l86nLd8NKsxlLd+7yxs6YIrIS/0UYZxbxcZt2XvAzWrQdSsUrXGtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717603296; c=relaxed/simple;
	bh=qgquWmW88InRZp+88MfComVaVbb76pWs/ks8q8RIsVs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZQB+B9RKs4l4WkWg8Ku+uSiiEf5/cdiNGd0v/fm0wqfUsfOucXCWFGXvWiTVK+/sHfWfDbCuRLbJUYdzA7qxdFxqRXVNSRzalpeTLfnPCREpJl1FGGcT2ferUszIlU2b9lioScMkvRz68aiZGtgLafZBPv94HKE3atKpMvg8UGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=rKRVv+TM; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 455FokWv012651;
	Wed, 5 Jun 2024 16:01:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc :
 content-transfer-encoding : date : from : message-id : mime-version :
 subject : to; s=pp1; bh=RPeIs1rN4Q6sK47KjLH5UiF1fBCw4RcwAljrmlP/Ytw=;
 b=rKRVv+TMTNoVky4OVoPMYeisYZ17coXnymJbpzpDpvqIUqw+Gw5STGH3KRAM+wKvl6al
 xupC/guWf6Ap3shJ2K7e/DNoTc8SXWNW/EO+4dJ4C3tZ4C6lCDY5+UHIqM7B4HY8AW+V
 4z89alzPcxr/2Tj2sYJMTaDZn/J6yey/K4vcZDXvC8+p40B4mrXirJLQ6wgpiTRyoL7K
 BhHzXhSOKYr86Sg7EZJ+p78esP2h7pGtb8FVr9j3bVysyeS8NYUWt9gLNgg1/HONoHrC
 rWXxXYxyDLu4E1oleJJ84kgpv89Y/lJdBPH3L6MxjWAOpL2lVONthJNeY4ceMVkHlj+Y Iw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yjrdw8ktn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 16:01:28 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 455G1SJs001765;
	Wed, 5 Jun 2024 16:01:28 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yjrdw8ktj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 16:01:28 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 455E2IPO026671;
	Wed, 5 Jun 2024 16:01:27 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3ygffn4xqy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 16:01:27 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 455G1L1D45089206
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 5 Jun 2024 16:01:23 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 70D312004D;
	Wed,  5 Jun 2024 16:01:21 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 42C5320040;
	Wed,  5 Jun 2024 16:01:21 +0000 (GMT)
Received: from dilbert5.boeblingen.de.ibm.com (unknown [9.152.224.39])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  5 Jun 2024 16:01:21 +0000 (GMT)
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
Subject: [PATCH v5 0/3] vfio/pci: Support 8-byte PCI loads and stores
Date: Wed,  5 Jun 2024 18:01:09 +0200
Message-ID: <20240605160112.925957-1-gbayer@linux.ibm.com>
X-Mailer: git-send-email 2.45.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Q4tcIlc74_wKgOIqwbH6K9mEc5wXicDv
X-Proofpoint-ORIG-GUID: bHIjQIr2MfMR0yWuKQF54ceD7T97rTEO
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
 definitions=2024-06-05_02,2024-06-05_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 mlxlogscore=999 spamscore=0 mlxscore=0 bulkscore=0
 adultscore=0 suspectscore=0 clxscore=1015 lowpriorityscore=0
 impostorscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2405010000 definitions=main-2406050121

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
 include/linux/vfio_pci_core.h    |  25 ++++---
 2 files changed, 76 insertions(+), 71 deletions(-)

-- 
2.45.1


