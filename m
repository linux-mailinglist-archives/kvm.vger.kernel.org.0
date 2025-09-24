Return-Path: <kvm+bounces-58681-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BB6F5B9B044
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 19:18:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 71DAA326A1D
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 17:18:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 422EB31B83D;
	Wed, 24 Sep 2025 17:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="IhacpZRd"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B0FA31A54C;
	Wed, 24 Sep 2025 17:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758734207; cv=none; b=qpnz/opuUkdldhNApDNE2dUJsUWA8y+1KYt+CPBFuEbS4LU0k4z+c4TdmYcW9UINx/2xYPxOq+Eh076HaEYCbdhRM+6uKzRiZRGqn6YSq+D0+v5/xSLbdOEACE4RdlqKnOHWB4aDAfk1JK8zpnQ7iyOdVu4xKYrgwIQKPCZRqyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758734207; c=relaxed/simple;
	bh=7BsFpPoAD9bYmcifCn7GMUkssy9BTWjgueFIRUBcovI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EbZgYVp6p0+hIpsbFzQdq4Wx5Q4UkYZ3fN6wjpVFGbIvv6qaDcTu6qANugrnNSgK9bNtiaUqK2g6w03IhJ8R0MEoTvaZk87NzQB3/SEE82N/ctlTy70G6kE6Rv2O9R3Lu9OELyF/wBuGmOR26xX4F88ssYWR8nZux/dsz0A114k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=IhacpZRd; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58O9mQDa006772;
	Wed, 24 Sep 2025 17:16:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=+WIxBLRAqRqMY8m8jQ11BatcRHy0t0JoDxU9+bNFJ
	F0=; b=IhacpZRdIe3c8qaTSlJorBozBpYkETqGA4Wlh/6+4S/W79Uz0zX/4VDOp
	zWOF5+sSiinV4DaVlN2/58P6PRdd+8H2wxwwjaI90FaKt12HXYcYWn37F+HAt/mw
	s9MtmejvOSmsRTf5MJ8rsbmkqi5YgIVuQY/sL3g0GAu+wKlxUmsRh1T1arzR1HaT
	4l1DdCjfZduWdfntSTZPDB0HLNuRn4abTbvJ/cmix57RdhV/4YdBU1jK5DqN5EoR
	lD4DmXbVHXfhEcN56mUy0jGIXTqGfmwey6gX/Ca7l2TsDzccRMWuCbsxBrZ9wFck
	O78cvCCPkMHN/yAMtUNpRujm8M2oQ==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 499jpkgb3a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Sep 2025 17:16:34 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58OE45UY013329;
	Wed, 24 Sep 2025 17:16:34 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49cj348u4v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Sep 2025 17:16:34 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58OHGXSa31064710
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Sep 2025 17:16:33 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0077C58063;
	Wed, 24 Sep 2025 17:16:33 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 417495805A;
	Wed, 24 Sep 2025 17:16:32 +0000 (GMT)
Received: from IBM-D32RQW3.ibm.com (unknown [9.61.252.148])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 24 Sep 2025 17:16:32 +0000 (GMT)
From: Farhan Ali <alifm@linux.ibm.com>
To: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Cc: alex.williamson@redhat.com, helgaas@kernel.org, clg@redhat.com,
        alifm@linux.ibm.com, schnelle@linux.ibm.com, mjrosato@linux.ibm.com
Subject: [PATCH v4 00/10] Error recovery for vfio-pci devices on s390x
Date: Wed, 24 Sep 2025 10:16:18 -0700
Message-ID: <20250924171628.826-1-alifm@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=L50dQ/T8 c=1 sm=1 tr=0 ts=68d42772 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=KfgF-uyYEtRdSbNldRsA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDAxMCBTYWx0ZWRfX083S8Yda7W0N
 o+EoMJPRhLzloMjx4gaFuti8adomrfCbJ1nqLP3Ek4cReFgy3Zf1CVa6nnhraTVGqFdmWai/4/0
 TaC/RzgaWlGQdfnVahbG+zFCKLHeM4K8EcaVySd88j9kaGD1P42YAkdXg60F086cecBkz6eqPNd
 PWqFRsc/j2Jryg422hT8iSDkaHUAoo8fG2OuBtVxPG7EnQvpjqVWov3JgGI/CR8CAKuFCCoy5FO
 7bcX2Iy71wk/mylb4UZ9AIWEofqp3TCKmL4Ggzs861OQgkQ2QPumTZAy4ifdhM5ZbbDaTX5vfNF
 g6aWfYsisy7I/scsQSO5B8r3W2dFFjlww6YXWIKlGxQI7Bsv9O09RNXYbEjVnJIRm7B3sjf6A3L
 X8oseDlH
X-Proofpoint-ORIG-GUID: r0CmJPbnkYnL9GLY8VrKOX4w89L6LVyo
X-Proofpoint-GUID: r0CmJPbnkYnL9GLY8VrKOX4w89L6LVyo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-24_04,2025-09-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 phishscore=0 impostorscore=0 spamscore=0
 priorityscore=1501 suspectscore=0 clxscore=1015 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509200010

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

I would appreciate some feedback on this series. Part of the series touches
PCI common code, so would like to get some feedback on those patches.

Thanks
Farhan

ChangeLog
---------
v3 series https://lore.kernel.org/all/20250911183307.1910-1-alifm@linux.ibm.com/
v3 -> v4
    - Remove warn messages for each PCI capability not restored (patch 1)

    - Check PCI_COMMAND and PCI_STATUS register for error value instead of device id 
    (patch 1)

    - Fix kernel crash in patch 3

    - Added reviewed by tags

    - Address comments from Niklas's (patches 4, 5, 7)

    - Fix compilation error non s390x system (patch 8)

    - Explicitly align struct vfio_device_feature_zpci_err (patch 8)


v2 series https://lore.kernel.org/all/20250825171226.1602-1-alifm@linux.ibm.com/
v2 -> v3
   - Patch 1 avoids saving any config space state if the device is in error
   (suggested by Alex)

   - Patch 2 adds additional check only for FLR reset to try other function 
     reset method (suggested by Alex).

   - Patch 3 fixes a bug in s390 for resetting PCI devices with multiple
     functions. Creates a new flag pci_slot to allow per function slot.

   - Patch 4 fixes a bug in s390 for resource to bus address translation.

   - Rebase on 6.17-rc5


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


Farhan Ali (10):
  PCI: Avoid saving error values for config space
  PCI: Add additional checks for flr reset
  PCI: Allow per function PCI slots
  s390/pci: Add architecture specific resource/bus address translation
  s390/pci: Restore IRQ unconditionally for the zPCI device
  s390/pci: Update the logic for detecting passthrough device
  s390/pci: Store PCI error information for passthrough devices
  vfio-pci/zdev: Add a device feature for error information
  vfio: Add a reset_done callback for vfio-pci driver
  vfio: Remove the pcie check for VFIO_PCI_ERR_IRQ_INDEX

 arch/s390/include/asm/pci.h        |  30 +++++++-
 arch/s390/pci/pci.c                |  75 ++++++++++++++++++++
 arch/s390/pci/pci_event.c          | 107 ++++++++++++++++-------------
 arch/s390/pci/pci_irq.c            |   9 +--
 drivers/pci/host-bridge.c          |   4 +-
 drivers/pci/hotplug/s390_pci_hpc.c |  10 ++-
 drivers/pci/pci.c                  |  37 ++++++++--
 drivers/pci/pcie/aer.c             |   3 +
 drivers/pci/pcie/dpc.c             |   3 +
 drivers/pci/pcie/ptm.c             |   3 +
 drivers/pci/slot.c                 |  14 +++-
 drivers/pci/tph.c                  |   3 +
 drivers/pci/vc.c                   |   3 +
 drivers/vfio/pci/vfio_pci_core.c   |  20 ++++--
 drivers/vfio/pci/vfio_pci_intrs.c  |   3 +-
 drivers/vfio/pci/vfio_pci_priv.h   |   8 +++
 drivers/vfio/pci/vfio_pci_zdev.c   |  45 +++++++++++-
 include/linux/pci.h                |   1 +
 include/uapi/linux/vfio.h          |  15 ++++
 19 files changed, 318 insertions(+), 75 deletions(-)

-- 
2.43.0


