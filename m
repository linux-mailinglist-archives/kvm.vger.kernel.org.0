Return-Path: <kvm+bounces-39279-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E8D89A45E8A
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 13:20:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 13CAB1885C5E
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 12:16:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0395227EB0;
	Wed, 26 Feb 2025 12:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="p9Jx7vee"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3054E227E83;
	Wed, 26 Feb 2025 12:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740571698; cv=none; b=sTH3Byi6dCj3Mktp2Nz00K6i241eHlbL2khtlzWB8GhbSg5Nqtgsp50FYxLqmxhREowZO2hblxdeRdpS9TzghaOOjATawxSUqu3m3z0BLoy7ApBXqSu6gJXVFn7i+52buwHC5Tkm9iNMhKdNVv9alAL7fIR7iKdgZdJZdM5x05o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740571698; c=relaxed/simple;
	bh=QGK2vUhS+8IONxPKVPO4lVznrTPkEKoWBljFOzS5apg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=RdMV31+e3TcZHjaqtrIulZ/CyRgqhiDtN0vjngQFFDiqMi/NDQJqAryGFGiJi2RwXkEOoYZppouesGsgyAnIPlIhNUcmThf0IV6RwK8CWAExmwxSG+BL0nG82BN/664r2QK8jbhWkeN3ox/J/wzdkIMhASr9LMloOT3VDx7Ym5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=p9Jx7vee; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51Q1kr3E011664;
	Wed, 26 Feb 2025 12:08:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=WaCUfI
	2FGsGXNbTYyUnQ0b9toH9ncuXlNGWAKUR9CWs=; b=p9Jx7veeuoWBvzm5YGCVJ7
	RCK/uX1hrK0SHnsVYOmxsYL5TCUSPGZfB9siMJOm13637SpYKCfXTAdfjt/h1ZKr
	IVD3n1nO0hzQSo3pM5An+DV9CvFjhb7FAyZ3H0DuTsiToSvzZOrdIFUWUKGg2Ky7
	ZCi/9UYPjG0kWuXPhRmveTMmuwd4pIamBEREHpWlglgZf9fn/htY009SEUrBPiye
	km4305X+jTHf5AtHGgM2D+sOvd9qwCjBNg5PadS8DTL3rxSDECJuE3jkG1Mf3eju
	7Yp7LebC80hwJyUqKgNOUM3EAfqr+Epg3gMZwA0d6Vv3TTnElVHgCPmK62f2c8Cg
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 451s19ahyh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Feb 2025 12:08:09 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 51QC1qBP023509;
	Wed, 26 Feb 2025 12:08:08 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 451s19ahyc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Feb 2025 12:08:08 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51QBGAbw012597;
	Wed, 26 Feb 2025 12:08:07 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44ys9yjq0p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Feb 2025 12:08:07 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51QC86q357868796
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Feb 2025 12:08:06 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2DF1E5803F;
	Wed, 26 Feb 2025 12:08:06 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5493D5805A;
	Wed, 26 Feb 2025 12:08:03 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 26 Feb 2025 12:08:03 +0000 (GMT)
From: Niklas Schnelle <schnelle@linux.ibm.com>
Date: Wed, 26 Feb 2025 13:07:47 +0100
Subject: [PATCH v7 3/3] PCI: s390: Support mmap() of PCI resources except
 for ISM devices
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250226-vfio_pci_mmap-v7-3-c5c0f1d26efd@linux.ibm.com>
References: <20250226-vfio_pci_mmap-v7-0-c5c0f1d26efd@linux.ibm.com>
In-Reply-To: <20250226-vfio_pci_mmap-v7-0-c5c0f1d26efd@linux.ibm.com>
To: Bjorn Helgaas <helgaas@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Gerd Bayer <gbayer@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Thorsten Winkler <twinkler@linux.ibm.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc: Julian Ruess <julianr@linux.ibm.com>, Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pci@vger.kernel.org, Niklas Schnelle <schnelle@linux.ibm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=5940;
 i=schnelle@linux.ibm.com; h=from:subject:message-id;
 bh=QGK2vUhS+8IONxPKVPO4lVznrTPkEKoWBljFOzS5apg=;
 b=owGbwMvMwCX2Wz534YHOJ2GMp9WSGNL3s0hOSQq5U7sn++xhSS92f8mpQjcW6sx48aundVPtu
 k2+IdcEO0pZGMS4GGTFFFkWdTn7rSuYYronqL8DZg4rE8gQBi5OAZhI+xWG/z57Aw0vBZ9U7OAV
 4YmZtjnledyDS3KZITsWfHzi4fPt6RNGhiP+EadnBdyXM38jU33sdp/wjqjzS2zmh3rcubVx4cw
 3hzgB
X-Developer-Key: i=schnelle@linux.ibm.com; a=openpgp;
 fpr=9DB000B2D2752030A5F72DDCAFE43F15E8C26090
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: zNECHJPwibH6SOc2uqfL53qEgt3B_IcS
X-Proofpoint-ORIG-GUID: bhZo-dJxYqXlKcGe9Bj6PyRpvVsNIMHq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-26_02,2025-02-26_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 phishscore=0 adultscore=0 impostorscore=0 lowpriorityscore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 clxscore=1015 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502100000 definitions=main-2502260096

So far s390 does not allow mmap() of PCI resources to user-space via the
usual mechanisms, though it does use it for RDMA. For the PCI sysfs
resource files and /proc/bus/pci it defines neither HAVE_PCI_MMAP nor
ARCH_GENERIC_PCI_MMAP_RESOURCE. For vfio-pci s390 previously relied on
disabled VFIO_PCI_MMAP and now relies on setting pdev->non_mappable_bars
for all devices.

This is partly because access to mapped PCI resources from user-space
requires special PCI load/store memory-I/O (MIO) instructions, or the
special MMIO syscalls when these are not available. Still, such access
is possible and useful not just for RDMA, in fact not being able to
mmap() PCI resources has previously caused extra work when testing
devices.

One thing that doesn't work with PCI resources mapped to user-space
though is the s390 specific virtual ISM device. Not only because the BAR
size of 256 TiB prevents mapping the whole BAR but also because access
requires use of the legacy PCI instructions which are not accessible to
user-space on systems with the newer MIO PCI instructions.

Now with the pdev->non_mappable_bars flag ISM can be excluded from
mapping its resources while making this functionality available for all
other PCI devices. To this end introduce a minimal implementation of
PCI_QUIRKS and use that to set pdev->non_mappable_bars for ISM devices
only. Then also set ARCH_GENERIC_PCI_MMAP_RESOURCE to take advantage of
the generic implementation of pci_mmap_resource_range() enabling only
the newer sysfs mmap() interface. This follows the recommendation in
Documentation/PCI/sysfs-pci.rst.

Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
---
 arch/s390/Kconfig           |  4 +---
 arch/s390/include/asm/pci.h |  3 +++
 arch/s390/pci/Makefile      |  2 +-
 arch/s390/pci/pci.c         |  1 -
 arch/s390/pci/pci_fixup.c   | 23 +++++++++++++++++++++++
 drivers/s390/net/ism_drv.c  |  1 -
 include/linux/pci_ids.h     |  1 +
 7 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 9c9ec08d78c71b4d227beeafab1b82d6434cb5c7..e48741e001476f765e8aba0037a1b386df393683 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -41,9 +41,6 @@ config AUDIT_ARCH
 config NO_IOPORT_MAP
 	def_bool y
 
-config PCI_QUIRKS
-	def_bool n
-
 config ARCH_SUPPORTS_UPROBES
 	def_bool y
 
@@ -258,6 +255,7 @@ config S390
 	select PCI_DOMAINS		if PCI
 	select PCI_MSI			if PCI
 	select PCI_MSI_ARCH_FALLBACKS	if PCI_MSI
+	select PCI_QUIRKS		if PCI
 	select SPARSE_IRQ
 	select SWIOTLB
 	select SYSCTL_EXCEPTION_TRACE
diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
index 474e1f8d1d3c2fc5685b459cc68b67ac651ea3e9..d2086af3434c0206fe306089fb17b778f8d17bbe 100644
--- a/arch/s390/include/asm/pci.h
+++ b/arch/s390/include/asm/pci.h
@@ -11,6 +11,9 @@
 #include <asm/pci_insn.h>
 #include <asm/sclp.h>
 
+#define ARCH_GENERIC_PCI_MMAP_RESOURCE	1
+#define arch_can_pci_mmap_wc()		1
+
 #define PCIBIOS_MIN_IO		0x1000
 #define PCIBIOS_MIN_MEM		0x10000000
 
diff --git a/arch/s390/pci/Makefile b/arch/s390/pci/Makefile
index df73c5182990ad3ae4ed5a785953011feb9a093c..1810e0944a4ed9d31261788f0f6eb341e5316546 100644
--- a/arch/s390/pci/Makefile
+++ b/arch/s390/pci/Makefile
@@ -5,6 +5,6 @@
 
 obj-$(CONFIG_PCI)	+= pci.o pci_irq.o pci_clp.o \
 			   pci_event.o pci_debug.o pci_insn.o pci_mmio.o \
-			   pci_bus.o pci_kvm_hook.o pci_report.o
+			   pci_bus.o pci_kvm_hook.o pci_report.o pci_fixup.o
 obj-$(CONFIG_PCI_IOV)	+= pci_iov.o
 obj-$(CONFIG_SYSFS)	+= pci_sysfs.o
diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
index d14b8605a32ce1bc132dff225ac433cf3aae9265..88f72745fa59e16df26b1563de27594aac954a78 100644
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -590,7 +590,6 @@ int pcibios_device_add(struct pci_dev *pdev)
 	zpci_zdev_get(zdev);
 	if (pdev->is_physfn)
 		pdev->no_vf_scan = 1;
-	pdev->non_mappable_bars = 1;
 
 	zpci_map_resources(pdev);
 
diff --git a/arch/s390/pci/pci_fixup.c b/arch/s390/pci/pci_fixup.c
new file mode 100644
index 0000000000000000000000000000000000000000..35688b645098329f082d0c40cc8c59231c390eaa
--- /dev/null
+++ b/arch/s390/pci/pci_fixup.c
@@ -0,0 +1,23 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Exceptions for specific devices,
+ *
+ * Copyright IBM Corp. 2025
+ *
+ * Author(s):
+ *   Niklas Schnelle <schnelle@linux.ibm.com>
+ */
+#include <linux/pci.h>
+
+static void zpci_ism_bar_no_mmap(struct pci_dev *pdev)
+{
+	/*
+	 * ISM's BAR is special. Drivers written for ISM know
+	 * how to handle this but others need to be aware of their
+	 * special nature e.g. to prevent attempts to mmap() it.
+	 */
+	pdev->non_mappable_bars = 1;
+}
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_IBM,
+			PCI_DEVICE_ID_IBM_ISM,
+			zpci_ism_bar_no_mmap);
diff --git a/drivers/s390/net/ism_drv.c b/drivers/s390/net/ism_drv.c
index 2f34761e64135c154b5193f870c27753481feed0..60ed70a39d2ccade0dcd73207a30551f4bd1203a 100644
--- a/drivers/s390/net/ism_drv.c
+++ b/drivers/s390/net/ism_drv.c
@@ -20,7 +20,6 @@
 MODULE_DESCRIPTION("ISM driver for s390");
 MODULE_LICENSE("GPL");
 
-#define PCI_DEVICE_ID_IBM_ISM 0x04ED
 #define DRV_NAME "ism"
 
 static const struct pci_device_id ism_device_table[] = {
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 1a2594a38199fe77cbcabcfa57dc407fc66ddb44..3efb45beabf8ad46d1c28053fedb776b5027ddef 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -518,6 +518,7 @@
 #define PCI_DEVICE_ID_IBM_ICOM_V2_ONE_PORT_RVX_ONE_PORT_MDM	0x0251
 #define PCI_DEVICE_ID_IBM_ICOM_V2_ONE_PORT_RVX_ONE_PORT_MDM_PCIE 0x0361
 #define PCI_DEVICE_ID_IBM_ICOM_FOUR_PORT_MODEL	0x252
+#define PCI_DEVICE_ID_IBM_ISM		0x04ed
 
 #define PCI_SUBVENDOR_ID_IBM		0x1014
 #define PCI_SUBDEVICE_ID_IBM_SATURN_SERIAL_ONE_PORT	0x03d4

-- 
2.45.2


