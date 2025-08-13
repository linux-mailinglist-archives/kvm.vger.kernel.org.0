Return-Path: <kvm+bounces-54595-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DDCEB251CB
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 19:16:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4116D9A461E
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 17:10:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6AC02BD03F;
	Wed, 13 Aug 2025 17:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="KuAo151s"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 345AC303C84;
	Wed, 13 Aug 2025 17:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755104908; cv=none; b=VF3YvRLvwigAEzIXRcVbbV2VKxdvSXQ4wNsoVYAed7w2d14w20FYx+lvRCq62ke0/SEFuWrbwrjBO8Kh1FWbQzG7PyjS6aCBo/LDFQPHls4vFl8dBaEwx8SETTPn/8z5BxwViJNhsSCdxSmorK1tsc94S6LiLWEzFtvysybPFYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755104908; c=relaxed/simple;
	bh=I5e8mnJ/49JC8VrfWPv+CxjSD5d8HPt8cMuWfqWA36o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IrJsnWO77ZWOimH2JnCHqWKVBRgOaVCx4osMXHnXAVYBhrbZCrD/xrNjfv4yk86OtWXN17sv/q/y3ygrWS3BuI5KdumjTBEcos8wuWEWelA7FZ1Vlqfl8qokBNUC6TkwHH5RUZ/vjrAZRUohuToHxLPXL2b2NhBcK8vyqpMWB4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=KuAo151s; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57DBrY8H015979;
	Wed, 13 Aug 2025 17:08:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=bWdZKZaD8nPGvleZj/ENN8RWCyP7zC5YaSnfHOoTL
	TE=; b=KuAo151sYHzTETm9Q+NGWwCgx9gNKY07dL8ASjPW52zVfG5vNm8HGL+Uh
	yUkfsrvc8r5YAWT5iDN8Ag0yqkp30hJEfjCf6/6y2wil7NQPfphv06241cMzLuKr
	LpwSWKxxdb9yeu8P9N/FXKECqfq03/Kf076ey1VClnEhIu9TQzdr7B/ozNfE8sXz
	O2vvQ7Q8eiIDGbZmDscZ6X79nzJdv0nEmmFAX05/q7FywjIO1wxfAamGCEYb0dWz
	3wE4UeUYkN+wVS7/5KSLizMuENjSxhDHA/IwdMA3RQ6OFL0RQXMjLDXF9f1y2kYl
	Jv0N8xFU9nUvdtUula0lg/YC5Qj/A==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48dvrp5hpj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Aug 2025 17:08:24 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57DFhZnI026275;
	Wed, 13 Aug 2025 17:08:24 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 48eh218ehm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Aug 2025 17:08:24 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57DH8MJH21758542
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Aug 2025 17:08:22 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CC17C5805A;
	Wed, 13 Aug 2025 17:08:22 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F261358054;
	Wed, 13 Aug 2025 17:08:21 +0000 (GMT)
Received: from IBM-D32RQW3.ibm.com (unknown [9.61.255.61])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 13 Aug 2025 17:08:21 +0000 (GMT)
From: Farhan Ali <alifm@linux.ibm.com>
To: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: schnelle@linux.ibm.com, mjrosato@linux.ibm.com, alifm@linux.ibm.com,
        alex.williamson@redhat.com
Subject: [PATCH v1 0/6] Error recovery for vfio-pci devices on s390x
Date: Wed, 13 Aug 2025 10:08:14 -0700
Message-ID: <20250813170821.1115-1-alifm@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODEyMDIxOSBTYWx0ZWRfXz++irHcUMBIU
 /uOhY6QbJ+bkfsFhDGE5Xq+HU6C7MpGKtIKgjnPypPMMYuMU2nRnBPuRxpviX4eGdX4ig7m0amR
 vw+SUXFJZz0plcPaGubJp4TaDVvkszGF2rPA8QFN/eXHctPMk6F5BvLeKinswv0op9iHieBN/K9
 BCGff5BVOQZjMig1O914+Cpq+cWEuXMfi3mVo0klH/mlIfR/mave0z/pTgkNe156w96eswXlYKe
 DIqBXqdVlUuFw8YAwW1niN4VUrdBY2ZSKA4idYJhJ0CHb70NJCs/57rRrIQvCwLGb9qpgAGRnX5
 ibcbCDgyZPit98yIa2zRyGtQ0Tj6S/JQOLEFH2FAtWib3Wb0A0Vz5yPiB+7pDnjPs7f8jgecpdM
 g8u44qnp
X-Authority-Analysis: v=2.4 cv=GrpC+l1C c=1 sm=1 tr=0 ts=689cc688 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=2OwXVqhp2XgA:10 a=R0k15JvzdXSlHq7qNfMA:9
X-Proofpoint-GUID: bukwS5M2EuzSM2V187ddcKjJ3WM3yo-w
X-Proofpoint-ORIG-GUID: bukwS5M2EuzSM2V187ddcKjJ3WM3yo-w
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-13_01,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 adultscore=0 spamscore=0 impostorscore=0 suspectscore=0
 phishscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2508120219

Hi,

This Linux kernel patch series introduces support for error recovery for
passthrough PCI devices on System Z (s390x). 

Background
----------
For PCI devices on s390x an operating system receives platform specific 
error events from firmware rather than through AER.Today for
passthrough/userspace devices, we don't attempt any error recovery
and ignore any error events for the devices. The passthrough/userspace devices are 
managed by the vfio-pci driver. The driver does register error handling 
callbacks (error_detected), and on an error trigger an eventfd to userspace. 
But we need a mechanism to notify userspace (QEMU/guest/userspace drivers) about
the error event. 

Proposal
--------
We can expose this error information (currently only the PCI Error Code) via a 
device specific memory region for s390 vfio pci devices. Userspace can then read 
the memory region to obtain the error information and take appropriate actions
such as driving a device reset. The memory region provides some flexibility in 
providing more information in the future if required.

I would appreciate some feedback on this approach.

Thanks
Farhan

Farhan Ali (6):
  s390/pci: Restore airq unconditionally for the zPCI device
  s390/pci: Update the logic for detecting passthrough device
  s390/pci: Store PCI error information for passthrough devices
  vfio-pci/zdev: Setup a zpci memory region for error information
  vfio-pci/zdev: Perform platform specific function reset for zPCI
  vfio: Allow error notification and recovery for ISM device

 arch/s390/include/asm/pci.h       |  29 +++++++
 arch/s390/pci/pci.c               |   2 +
 arch/s390/pci/pci_event.c         | 107 ++++++++++++++-----------
 arch/s390/pci/pci_irq.c           |   3 +-
 drivers/vfio/pci/vfio_pci_core.c  |  22 +++++-
 drivers/vfio/pci/vfio_pci_intrs.c |   2 +-
 drivers/vfio/pci/vfio_pci_priv.h  |   8 ++
 drivers/vfio/pci/vfio_pci_zdev.c  | 126 +++++++++++++++++++++++++++++-
 include/uapi/linux/vfio.h         |   2 +
 include/uapi/linux/vfio_zdev.h    |   5 ++
 10 files changed, 253 insertions(+), 53 deletions(-)

-- 
2.43.0


