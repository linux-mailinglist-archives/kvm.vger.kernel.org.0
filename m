Return-Path: <kvm+bounces-55653-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F5B8B3484B
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 19:12:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9883E16F00C
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 17:12:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57A993019A0;
	Mon, 25 Aug 2025 17:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="LSqoodb6"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8851B3002BD;
	Mon, 25 Aug 2025 17:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756141957; cv=none; b=U22El4tQuDmo1hZUijGgb5/hPdpwXcsAT3MnZsX6f7FcaR4FlVuLSZ/ZZVhQOoO+vEC3Msz2MHYl1AQMDHLV38JoThd7gH/xERrmnrPADDkRyPdOzawATiZXyVKR7emUWXomkwYwMUhpA9LUIGDDqQtaBlZPyj77/3Tk3vuZ1p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756141957; c=relaxed/simple;
	bh=WFbiVgIPllr6rNUI+ki5v8f7WQiy4J84dKxytwedS68=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=X91gt9/TtI8IncqJn95yHs1yViUI1Ue2rF/dlbJ3FHzX805DAevI1y7ePOmu7/In2GbJDa3BPW61k93LIYJoM2Oo/MgLfJ5W5Uki3giDGROFNi+43HiKDXugwgqRwltm2UquDDIG1xN6boYzIfVlbGlC9j9x3Y19wrKK/HblBfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=LSqoodb6; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57PBmAQA012068;
	Mon, 25 Aug 2025 17:12:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=j0s/pWAmzTlQoh5WGz/t7sKT9R0wwbZ9hw86imT/E
	oE=; b=LSqoodb60Gio3iJwGUa5jxomsy2M+e4AMcTm1ezpO2oIpNn77gmXR5pXQ
	Hz/+sX2Iew8jLOdPX1PCbvyZsfoZXE0zqyhFwu+piljW2bP2ET5Pc0Le8GD2YzBI
	0TRWyWjLoCQFh91gqd+LVSlNC/8ZiNT/EyaszsZ7Pmb/nnyTKhsCRYFkTq+f0D18
	xGXUCpAoQTSGMUcsNh7cS1WRv4AaZbUnbAZfqSEUEtMnesedoWWqNJh5iDOgOIV0
	9PEol2SYJXD/m2g+T0+jvSWblyb2uTXTeHyQ8XpS+xm2j76o8n27mP3bOXB9oMI1
	SZ+FfX06Mh77GHdup597C/5rBUDdQ==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48q42htaph-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Aug 2025 17:12:30 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57PGcNsW007514;
	Mon, 25 Aug 2025 17:12:30 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 48qqyu74qd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Aug 2025 17:12:30 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57PHCSOJ55116158
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Aug 2025 17:12:28 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6D76A58055;
	Mon, 25 Aug 2025 17:12:28 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 30AE05804E;
	Mon, 25 Aug 2025 17:12:27 +0000 (GMT)
Received: from IBM-D32RQW3.ibm.com (unknown [9.61.255.253])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 25 Aug 2025 17:12:27 +0000 (GMT)
From: Farhan Ali <alifm@linux.ibm.com>
To: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: alex.williamson@redhat.com, helgaas@kernel.org, alifm@linux.ibm.com,
        schnelle@linux.ibm.com, mjrosato@linux.ibm.com
Subject: [PATCH v2 0/9] Error recovery for vfio-pci devices on s390x
Date: Mon, 25 Aug 2025 10:12:17 -0700
Message-ID: <20250825171226.1602-1-alifm@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxMCBTYWx0ZWRfX9UBgZFk9x4EC
 EzdSLj/PunWEK/itqZiXqUC+htbd5okfm9Ax+relZ+rAgC9r/VOFBRTxjmiaP7W5YSUS8tnPnBw
 JBb/pjh501eRMHek0s8LVzogVdVx3wNTM/4or43WEhKtBya9SDvTExEZh21/+UQEhUGb4DwikY4
 SvrC4vzb9HSqpWGy2KFuMxhlaeFve4QaUa+iiMYCf2oksv+tJku6NoMka6CDCt2U6a6O0ecWMq5
 oeZ4eAdtMN8E9JdZ9O6BoUqMlAmqAY7ZLwCLadNZJmxm4k53lMTQFTulD8MCD3Y0jW6yV8JQ2oT
 mc2FNJJPpTVLXtjpt3eXW0+KZiu6f8pwWqq6Qd5Rl7cxpYo6TFjVc+3quqaongUjVAZo6k2HGTL
 1j86LRGU
X-Proofpoint-ORIG-GUID: v5SaA1pcWCB4qIvFCn0vRiUyid3BDwuB
X-Proofpoint-GUID: v5SaA1pcWCB4qIvFCn0vRiUyid3BDwuB
X-Authority-Analysis: v=2.4 cv=evffzppX c=1 sm=1 tr=0 ts=68ac997f cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=cgD0z4qYwaRGm_JpYW0A:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-25_08,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 malwarescore=0 spamscore=0 bulkscore=0
 impostorscore=0 clxscore=1015 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2508230010

Hi,

This Linux kernel patch series introduces support for error recovery for
passthrough PCI devices on System Z (s390x). 

Background
----------
For PCI devices on s390x an operating system receives platform specific
error events from firmware rather than through AER.Today for
passthrough/userspace devices, we don't attempt any error recovery and
ignore any error events for the devices. The passthrough/userspace devices
are managed by the vfio-pci driver. The driver does register error handling
callbacks (error_detected), and on an error trigger an eventfd to
userspace.  But we need a mechanism to notify userspace
(QEMU/guest/userspace drivers) about the error event. 

Proposal
--------
We can expose this error information (currently only the PCI Error Code)
via a device feature. Userspace can then obtain the error information 
via VFIO_DEVICE_FEATURE ioctl and take appropriate actions such as driving 
a device reset.

I would appreciate some feedback on this series.

Thanks
Farhan

ChangeLog
---------
v1 series https://lore.kernel.org/all/20250813170821.1115-1-alifm@linux.ibm.com/
v1 - > v2
   - Patches 1 and 2 adds some additional checks for FLR/PM reset to 
     try other function reset method (suggested by Alex).

   - Patch 3 fixes a bug in s390 for resetting PCI devices with multiple
     functions.

   - Patch 7 adds a new device feature for zPCI devices for the VFIO_DEVICE_FEATURE 
     ioctl. The ioctl is used by userspace to retriece any PCI error
     information for the device (suggested by Alex).

   - Patch 8 adds a reset_done() callback for the vfio-pci driver, to
     restore the state of the device after a reset.

   - Patch 9 removes the pcie check for triggering VFIO_PCI_ERR_IRQ_INDEX.

Farhan Ali (9):
  PCI: Avoid restoring error values in config space
  PCI: Add additional checks for flr and pm reset
  PCI: Allow per function PCI slots for hypervisor isolated functions
  s390/pci: Restore airq unconditionally for the zPCI device
  s390/pci: Update the logic for detecting passthrough device
  s390/pci: Store PCI error information for passthrough devices
  vfio-pci/zdev: Add a device feature for error information
  vfio: Add a reset_done callback for vfio-pci driver
  vfio: Remove the pcie check for VFIO_PCI_ERR_IRQ_INDEX

 arch/s390/include/asm/pci.h       |  30 ++++++++-
 arch/s390/pci/pci.c               |   1 +
 arch/s390/pci/pci_event.c         | 107 +++++++++++++++++-------------
 arch/s390/pci/pci_irq.c           |   9 +--
 drivers/pci/pci.c                 |  10 +++
 drivers/pci/slot.c                |  19 +++++-
 drivers/vfio/pci/vfio_pci_core.c  |  20 ++++--
 drivers/vfio/pci/vfio_pci_intrs.c |   3 +-
 drivers/vfio/pci/vfio_pci_priv.h  |   8 +++
 drivers/vfio/pci/vfio_pci_zdev.c  |  45 ++++++++++++-
 include/uapi/linux/vfio.h         |  14 ++++
 11 files changed, 200 insertions(+), 66 deletions(-)

-- 
2.43.0


