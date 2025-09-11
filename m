Return-Path: <kvm+bounces-57344-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 018BBB53B7A
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 20:33:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 76CBDAC072E
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 18:33:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26F5B36C07E;
	Thu, 11 Sep 2025 18:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ScsAs25f"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E6E27FD5B;
	Thu, 11 Sep 2025 18:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757615596; cv=none; b=Rf3ZLS60m3b4aOmAjsnHmyaD104X8kUVuG6LTCO9/ZUNrZdCz1grzkYaFYoLmpj+wvfYaYs+KZgLUXcqK040/mkyzG6wmfB64clSBeKkkitPnM0+LFZFVRZrYKNIsYdcXQjMmtlzM/qLnCKeSFN/lEPoq9NzlMQ/1b75W2V33fM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757615596; c=relaxed/simple;
	bh=ck5UhhM7ahmNVtuybHiqx1PE1IHgAdJHgJZx+XtttAA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=D8Zk/KekYn/mosF5h3bns00AIYQjLigKqI2iBKRUeApS4AZgwufg+3Dy+V/ZooQKowNnT7uSCSiCc4HEQOqyw25XnjG7+wm/GuFJE46X5TASn6M5LrEmxPk2UUBf2YU0rnyf7sy2e4ZzBRFKwx1uFRNuC5xLIxvPpngTvDG3s4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ScsAs25f; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58B9u5Ka026934;
	Thu, 11 Sep 2025 18:33:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=QWix6YwOudrids1O38gaCCzCkdi4dxsLUSL/w46KJ
	Zk=; b=ScsAs25fLQPd3+Mddi6UBaeuDanD8nEmS3DbqvGaWA7Ikkkt8MW+M3FLB
	GL7OITRvYNu21DO5ouMAW19PgUerfPca0nGbnGxSmVkGVs+wZzibpxJKgV8hkU+a
	JSYqc4D9MIJ8981ZoCWwo0x+h/qgdkYx8v1LkVS0ZBREOLw0JtBFy6oHf0dGQYHD
	jzbdrASPXUnSQBRbW6W2io6dqdC+IUT1JZuUCJjxqFcEF5RFW8wPrLitDBt8g762
	lkD8TuAcJ5+WwCl80dCNkUWTDwU3dGue+6airUUwQ9mf6nttbBW0jeecMdPoBnA7
	TORRcO6crVNN0p9TyvvMc+NeBUJKw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490cmx6n8t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Sep 2025 18:33:10 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58BI0u8s017172;
	Thu, 11 Sep 2025 18:33:09 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4911gmq2c3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Sep 2025 18:33:09 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58BIX82e32310010
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 18:33:08 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6466858059;
	Thu, 11 Sep 2025 18:33:08 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B03A058058;
	Thu, 11 Sep 2025 18:33:07 +0000 (GMT)
Received: from IBM-D32RQW3.ibm.com (unknown [9.61.249.32])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 11 Sep 2025 18:33:07 +0000 (GMT)
From: Farhan Ali <alifm@linux.ibm.com>
To: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Cc: alex.williamson@redhat.com, helgaas@kernel.org, alifm@linux.ibm.com,
        schnelle@linux.ibm.com, mjrosato@linux.ibm.com
Subject: [PATCH v3 00/10] Error recovery for vfio-pci devices on s390x
Date: Thu, 11 Sep 2025 11:32:57 -0700
Message-ID: <20250911183307.1910-1-alifm@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ncZO6VLDxwHY4cwuEFFdKqBAD1ApAOpq
X-Proofpoint-ORIG-GUID: ncZO6VLDxwHY4cwuEFFdKqBAD1ApAOpq
X-Authority-Analysis: v=2.4 cv=J52q7BnS c=1 sm=1 tr=0 ts=68c315e6 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=pxXGJ1xoj55wCGANvjsA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDAyNSBTYWx0ZWRfX1zHPwCY/WLna
 6T4ZOT5K7jlD0WX3MYWiZY07QVnmL4ZgDgQrK73NKHJloUIcghLZ9+7KgpYY3HMmwDEgumVIVz1
 v/UMGYKqr/RFiHOROPwcRdN1malMxkKFXA4ialCzjWzj8W4UL8T9joI2pOPXp9CqwGppB/TbUHG
 zo1lw4qEgdwz9/eqcYFxvBalmQF1mhFGJ5a3+Wl2K35WNM54LLAPUuqj984w5Izkuwpt9vefCZb
 UqgIafsyFChRV7hOogJHQsTO8A5Ky+/hBXcDbm79P/0H3BBveJGjh6Gx8jbQlCjZTOp+SOCQscv
 wLLkm71TmBk/HiyMvmEYYaK1352dJ56rg7oh3duHzGNzjqYkZf67v+aACyzZxKchdAcHWW1KSV5
 PjLBC0w1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-11_03,2025-09-11_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1011 suspectscore=0 spamscore=0 phishscore=0
 bulkscore=0 adultscore=0 malwarescore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060025

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
 arch/s390/pci/pci.c                |  74 ++++++++++++++++++++
 arch/s390/pci/pci_event.c          | 107 ++++++++++++++++-------------
 arch/s390/pci/pci_irq.c            |   9 +--
 drivers/pci/host-bridge.c          |   4 +-
 drivers/pci/hotplug/s390_pci_hpc.c |  10 ++-
 drivers/pci/pci.c                  |  40 +++++++++--
 drivers/pci/pcie/aer.c             |   5 ++
 drivers/pci/pcie/dpc.c             |   5 ++
 drivers/pci/pcie/ptm.c             |   5 ++
 drivers/pci/slot.c                 |  14 +++-
 drivers/pci/tph.c                  |   5 ++
 drivers/pci/vc.c                   |   5 ++
 drivers/vfio/pci/vfio_pci_core.c   |  20 ++++--
 drivers/vfio/pci/vfio_pci_intrs.c  |   3 +-
 drivers/vfio/pci/vfio_pci_priv.h   |   8 +++
 drivers/vfio/pci/vfio_pci_zdev.c   |  45 +++++++++++-
 include/linux/pci.h                |   1 +
 include/uapi/linux/vfio.h          |  14 ++++
 19 files changed, 330 insertions(+), 74 deletions(-)

-- 
2.43.0


