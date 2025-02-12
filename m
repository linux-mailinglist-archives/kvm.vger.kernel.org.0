Return-Path: <kvm+bounces-37967-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 33413A32A1E
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 16:32:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D656E188D48E
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 15:29:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88C78212B31;
	Wed, 12 Feb 2025 15:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="gpx57zOI"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D615920ADF0;
	Wed, 12 Feb 2025 15:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739374160; cv=none; b=Yv6+H6HjPj5+qjt3Q0/7QhD3/MrdzrWKURv6+sjFhLq5oirvAhF4NEc66F5csspJMM4Fci0SPgPC54uFafoAsH7UYjU2JdnPpmoh3JPX4qInVoqiXL/LjrGIM5+j/ibf17qAT14iEJXMVT+0zGXtH0NNf9Bpi5S0bW4DI/q6uXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739374160; c=relaxed/simple;
	bh=A4oHbJb5jJdSpuXGv/aDAAcnboxGoMy0VXy/ohzGM/Q=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=CS2xNcFed8D8vbjDmiEElKYuPiaGaNSKzG90is4+XKEX7OK5J+hSVY5AbK9fEcSesWhXsjzI4i/vu0FU4B4wcdgwj62NWQ+ruHEoplN1dxwy5gvciKNLreu9aeavvjaMMFeApmZfIPoteE1DoAEi8RIIaxkldhSTF6vYvDxDltE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=gpx57zOI; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51CDVSx7020778;
	Wed, 12 Feb 2025 15:29:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=ER5GUA
	jqTUhAGd6FMvKojsj6c77div0TKQXOpHhRqok=; b=gpx57zOIRBx+ejjDncBSxJ
	JK887MVpm5J+4Psj1Jz8S4BAREDBc5ztepiZzwl4CYyjRAXQ39Q1wqEzKRA3dHRl
	LoNTcNv9S0M0CDNhz7VteAxUdPlScvI8fXC8tawLSwND16DbVtBjS139hijzcQQj
	s8NAMH2f6wMovQrMEd+aCg9jnwx0RaYV4OF7EJP+yez4Cp0jnnNwLJir+ekoBVGc
	VA37S3V3yNNYHQQ5XTGPVsPGIviQUwiLNbGFWL+3nJfJDU7oPy+CCi+wg6Eem8im
	71B5pF8+nx7wdyYTclRezMDGQpzjCNDpCrPg0qlv1myLwlx8mlpJTFwjfWzlbxPA
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44r9cuefs5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 12 Feb 2025 15:29:04 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 51CF72Mk022243;
	Wed, 12 Feb 2025 15:29:03 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44r9cuefs3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 12 Feb 2025 15:29:03 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51CFQCOU021722;
	Wed, 12 Feb 2025 15:29:02 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 44phkssnx6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 12 Feb 2025 15:29:02 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51CFT1CA18744012
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 12 Feb 2025 15:29:01 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4975E5805B;
	Wed, 12 Feb 2025 15:29:01 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AD82358058;
	Wed, 12 Feb 2025 15:28:57 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 12 Feb 2025 15:28:57 +0000 (GMT)
From: Niklas Schnelle <schnelle@linux.ibm.com>
Date: Wed, 12 Feb 2025 16:28:32 +0100
Subject: [PATCH v5 2/2] PCI: s390: Support mmap() of BARs and replace
 VFIO_PCI_MMAP by a device flag
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250212-vfio_pci_mmap-v5-2-633ca5e056da@linux.ibm.com>
References: <20250212-vfio_pci_mmap-v5-0-633ca5e056da@linux.ibm.com>
In-Reply-To: <20250212-vfio_pci_mmap-v5-0-633ca5e056da@linux.ibm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=6677;
 i=schnelle@linux.ibm.com; h=from:subject:message-id;
 bh=A4oHbJb5jJdSpuXGv/aDAAcnboxGoMy0VXy/ohzGM/Q=;
 b=owGbwMvMwCX2Wz534YHOJ2GMp9WSGNLX7NN+mT33qD7nPe2dse+42SUL7duMfPdd2pS6ImKf4
 +0PuV28HaUsDGJcDLJiiiyLupz91hVMMd0T1N8BM4eVCWQIAxenAEykwYqRYXdG7KnFm0x69q8S
 E60R2+MQ/tzyxL/ZcVeVFHLX1rC58jEyrA7bf2lPwq798+JWXGrqeJB7P9hJtXzR41fBM0UVwwu
 OMwIA
X-Developer-Key: i=schnelle@linux.ibm.com; a=openpgp;
 fpr=9DB000B2D2752030A5F72DDCAFE43F15E8C26090
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: bRKSy-jtQSrVTKPBckP1qIdDRbBFu3V-
X-Proofpoint-GUID: JjJ4qJNR7NBmZHJDktAKHqPG-DsCLoHg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-12_04,2025-02-11_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 suspectscore=0 adultscore=0 impostorscore=0 phishscore=0
 bulkscore=0 mlxlogscore=999 mlxscore=0 clxscore=1011 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2501170000 definitions=main-2502120114

On s390 there is a virtual PCI device called ISM which has a few
peculiarities. For one, it presents a 256 TiB PCI BAR whose size leads
to any attempt to ioremap() the whole BAR failing. This is problematic
since mapping the whole BAR is the default behavior of for example
vfio-pci in combination with QEMU and VFIO_PCI_MMAP enabled.

Even if one tried to map this BAR only partially, the mapping would not
be usable without extra precautions on systems with MIO support enabled.
This is because of another oddity, in that this virtual PCI device does
not support the newer memory I/O (MIO) PCI instructions and legacy PCI
instructions are not accessible through writeq()/readq() when MIO is in
use.

In short the ISM device's BAR is not accessible through memory mappings.
Indicate this by introducing a new non_mappable_bars flag for the ISM
device and set it using a PCI quirk. Use this flag instead of the
VFIO_PCI_MMAP Kconfig option to block mapping with vfio-pci. This was
the only use of the Kconfig option so remove it. Note that there are no
PCI resource sysfs files on s390x already as HAVE_PCI_MMAP is currently
not set. If this were to be set in the future pdev->non_mappable_bars
can be used to prevent unusable resource files for ISM from being
created.

As s390x has no PCI quirk handling add basic support modeled after x86's
arch/x86/pci/fixup.c and move the ISM device's PCI ID to the common
header to make it accessible. Also enable CONFIG_PCI_QUIRKS whenever
CONFIG_PCI is enabled.

Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
---
 arch/s390/Kconfig                |  4 +---
 arch/s390/pci/Makefile           |  2 +-
 arch/s390/pci/pci_fixup.c        | 23 +++++++++++++++++++++++
 drivers/s390/net/ism_drv.c       |  1 -
 drivers/vfio/pci/Kconfig         |  4 ----
 drivers/vfio/pci/vfio_pci_core.c |  2 +-
 include/linux/pci.h              |  1 +
 include/linux/pci_ids.h          |  1 +
 8 files changed, 28 insertions(+), 10 deletions(-)

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
index e36e3ea165d3b2b01d68e53634676cb8c2c40220..d32633ed9fa80c1764724f493b363bfd6cb4f9cf 100644
--- a/drivers/s390/net/ism_drv.c
+++ b/drivers/s390/net/ism_drv.c
@@ -20,7 +20,6 @@
 MODULE_DESCRIPTION("ISM driver for s390");
 MODULE_LICENSE("GPL");
 
-#define PCI_DEVICE_ID_IBM_ISM 0x04ED
 #define DRV_NAME "ism"
 
 static const struct pci_device_id ism_device_table[] = {
diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index bf50ffa10bdea9e52a9d01cc3d6ee4cade39a08c..c3bcb6911c538286f7985f9c5e938d587fc04b56 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -7,10 +7,6 @@ config VFIO_PCI_CORE
 	select VFIO_VIRQFD
 	select IRQ_BYPASS_MANAGER
 
-config VFIO_PCI_MMAP
-	def_bool y if !S390
-	depends on VFIO_PCI_CORE
-
 config VFIO_PCI_INTX
 	def_bool y if !S390
 	depends on VFIO_PCI_CORE
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 586e49efb81be32ccb50ca554a60cec684c37402..c8586d47704c74cf9a5256d65bbf888db72b2f91 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -116,7 +116,7 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_core_device *vdev)
 
 		res = &vdev->pdev->resource[bar];
 
-		if (!IS_ENABLED(CONFIG_VFIO_PCI_MMAP))
+		if (vdev->pdev->non_mappable_bars)
 			goto no_mmap;
 
 		if (!(res->flags & IORESOURCE_MEM))
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 47b31ad724fa5bf7abd7c3dc572947551b0f2148..7192b9d78d7e337ce6144190325458fe3c0f1696 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -476,6 +476,7 @@ struct pci_dev {
 	unsigned int	no_command_memory:1;	/* No PCI_COMMAND_MEMORY */
 	unsigned int	rom_bar_overlap:1;	/* ROM BAR disable broken */
 	unsigned int	rom_attr_enabled:1;	/* Display of ROM attribute enabled? */
+	unsigned int	non_mappable_bars:1;	/* BARs can't be mapped to user-space  */
 	pci_dev_flags_t dev_flags;
 	atomic_t	enable_cnt;	/* pci_enable_device has been called */
 
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index de5deb1a0118fcf56570d461cbe7a501d4bd0da3..ec6d311ed12e174dc0bad2ce8c92454bed668fee 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -518,6 +518,7 @@
 #define PCI_DEVICE_ID_IBM_ICOM_V2_ONE_PORT_RVX_ONE_PORT_MDM	0x0251
 #define PCI_DEVICE_ID_IBM_ICOM_V2_ONE_PORT_RVX_ONE_PORT_MDM_PCIE 0x0361
 #define PCI_DEVICE_ID_IBM_ICOM_FOUR_PORT_MODEL	0x252
+#define PCI_DEVICE_ID_IBM_ISM		0x04ED
 
 #define PCI_SUBVENDOR_ID_IBM		0x1014
 #define PCI_SUBDEVICE_ID_IBM_SATURN_SERIAL_ONE_PORT	0x03d4

-- 
2.45.2


