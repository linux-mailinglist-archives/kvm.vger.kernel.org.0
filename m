Return-Path: <kvm+bounces-17962-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E4EB88CC3C7
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 17:07:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5D64E1F24513
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 15:07:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E9BA2374C;
	Wed, 22 May 2024 15:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bfeJNQnT"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA3F481B7;
	Wed, 22 May 2024 15:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716390434; cv=none; b=GHX6HSDMUglTfnH2UVSvx6R2wgTeZbt6/kroOr17sDYhS2GPGnPvubB/SF8qgXizBbo5kqfS2YxFIOyeg6YC+bMUkQ4zlQ3eXoUMIku5wTPYyGW1OGgQ4sI02nTHNa1CQAUD4LccrxVGZWb21EIkn3N/+P0Xvzwke7rEnF75XKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716390434; c=relaxed/simple;
	bh=r3kTZCbGs4JU1AznRev6WdhmO6YEmAk2Jhe2TSrrsAw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mF4yGjMoZgLGdOkiFADAGlUdX7O2JS/hO4aL6wPGjprJu8/DtSBdkrZEaD0Dy1Q7mo0337J66lfiedlOwbQ3u5/mFjE/z0WtghJqxbH/bE5iJhCCfBCicS1Xcy6JDWWDzRT2k29ApLqb1PJlqNCBlAnO9VCHWOJ3IF9V9nDz8fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=bfeJNQnT; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44MELIOX006977;
	Wed, 22 May 2024 15:07:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=yz1EgG6NeL+f3+ngHPscrAr1wLvmY0O4KGWj1QKS9N8=;
 b=bfeJNQnT5dxN4wQU2oS3l/HXzA6lrYjXcp4veGt8xO+AvFVXDfxzO1tDZgUhhwZ630qV
 6u8Wf/A/Mn8yaw+nCuO/MaA4y5MrRyNPUE+FaEZ0AsBh92H7DxTF3G41ugksb6Q/DeOE
 DDccvj4qIoOs+TYElPYltPO3gzeG7vTNklqLuWZ4nFIgjMOxZ4kudBmkZjByjZTo8010
 iodBIhUu4uAvVjTHpm7zLMXFHmztY4CxApMykPiHhJPYaBCZSUp5Atx7Od7VdbRkZ7OS
 cTr67/SR4I8Ns85PmrJpcajlPYIQwK2uf5NWM2+YEVYJy2Ob1Ludc9m08ubXhkBgW1VD xQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3y9h100cj6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 May 2024 15:07:06 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44MF76gi012919;
	Wed, 22 May 2024 15:07:06 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3y9h100cj4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 May 2024 15:07:06 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 44MDDS2x022144;
	Wed, 22 May 2024 15:07:05 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3y76ntvtyn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 May 2024 15:07:05 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 44MF6xO648365976
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 May 2024 15:07:01 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 745C12004E;
	Wed, 22 May 2024 15:06:59 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 232BA20040;
	Wed, 22 May 2024 15:06:59 +0000 (GMT)
Received: from dilbert5.boeblingen.de.ibm.com (unknown [9.155.208.153])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 22 May 2024 15:06:59 +0000 (GMT)
From: Gerd Bayer <gbayer@linux.ibm.com>
To: Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Ramesh Thomas <ramesh.thomas@intel.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Ankit Agrawal <ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Julian Ruess <julianr@linux.ibm.com>,
        Gerd Bayer <gbayer@linux.ibm.com>
Subject: [PATCH v4 0/3] vfio/pci: Support 8-byte PCI loads and stores
Date: Wed, 22 May 2024 17:06:48 +0200
Message-ID: <20240522150651.1999584-1-gbayer@linux.ibm.com>
X-Mailer: git-send-email 2.45.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: bvR9c1YkJi5G9rHPde6o7LJxCylXnLwu
X-Proofpoint-ORIG-GUID: 9DR0EsY_iVVxey5gGZ-40u2f4ukyKkiR
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-22_08,2024-05-22_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 clxscore=1015 priorityscore=1501 bulkscore=0 adultscore=0 malwarescore=0
 mlxscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405220102

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
declaration macros that was suggested by Ramesh Thomas [2].

This version was tested with a pass-through PCI device in a KVM guest
and with explicit test reads of size 8, 16, 32, and 64 bit on
s390. For 32bit architectures this has only been compile tested for the
32bit ARM architecture.

Thank you,
Gerd Bayer

[1] https://lore.kernel.org/all/20240422153508.2355844-1-gbayer@linux.ibm.com/
[2] https://lore.kernel.org/kvm/20240425165604.899447-1-gbayer@linux.ibm.com/T/#m1b51fe155c60d04313695fbee11a2ccea856a98c

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

 drivers/vfio/pci/vfio_pci_rdwr.c | 124 ++++++++++++++++---------------
 include/linux/vfio_pci_core.h    |  27 ++++---
 2 files changed, 78 insertions(+), 73 deletions(-)

-- 
2.45.0


