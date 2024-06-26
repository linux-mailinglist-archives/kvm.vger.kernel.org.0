Return-Path: <kvm+bounces-20541-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D10ED917F68
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 13:17:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 00FA51C237F3
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 11:17:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FD6618130A;
	Wed, 26 Jun 2024 11:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="XlxZuhxT"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 608E217FAD7;
	Wed, 26 Jun 2024 11:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719400604; cv=none; b=PfN5mcRy/Hfr9hmofASleVtFEExE4UeAFUu0TyS//iiQAYYVfxEptXT9eYMPSUrRTUniOs9QWHEaEPjdXr6oVUr8NURI1TzDEi+7Ir/U6NPJ8lXtj2RQpROFE1tfdTke3ll3shhHZ8kr0fGjzwht/1cLxVpEk1AtBhzdNrexDGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719400604; c=relaxed/simple;
	bh=CYzstYaaXSrnMozeJlgiNEPXqNaJBsBlSJh01euI9Zs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=h3gK1NPJ1YQ/NbNk37p6QYPuhAbQ/9scAc7+rjvOEHpY0IIoP+S1nEhN+fht5JJ/NYX9spUH4MJj9oESXn7EAoF64szdC5TjtBAvJiCNcGKst03bcQLEJx2entfZTIsrtSPrBdwaKJXVeoNRGi+a3tKKKoTGZaEHUTYhIIJto2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=XlxZuhxT; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45QAPuZt014840;
	Wed, 26 Jun 2024 11:16:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:date:subject:mime-version:content-type
	:content-transfer-encoding:message-id:references:in-reply-to:to
	:cc; s=pp1; bh=H5AK9apvNg9/u4BFixoBzh3CCHMZysGgdrjaBm/PYyw=; b=X
	lxZuhxTkmsxm5pN0H0vOQPxivi6swB/0GtynDcfTo5vY2/zNFvD2qK72XKKOTVmq
	pJO8NRw4DJgbkTHdys0e4ONSmS3UjnMCah9Zbe5iERnr/D/JESXV8y+/6ECautk7
	hD7ogYAvUSfchfqpXqKzQZDUtWRVSd6F7BsAcsrnzrfA0BmKCYAyEyr09EIiEnI7
	xsQ7huhkakn01PuOiIicvKr60fp7SoyQYR2/T72THMTvupXRwE49cGgaGv6fuByi
	TpvjxV2aJtzwvhMdjeNCYLbzaG0IZZF81/CKPr/w9XClGRlf9GHx7QMuSOcEM44e
	FTjlqaRk0rEVORjyXaxZg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 400fgngcmy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Jun 2024 11:16:35 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45QBGR5B027105;
	Wed, 26 Jun 2024 11:16:34 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 400fgngcmw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Jun 2024 11:16:34 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45QB3QFL018096;
	Wed, 26 Jun 2024 11:16:33 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3yx8xucb6f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Jun 2024 11:16:33 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45QBGU0P36897260
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Jun 2024 11:16:32 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8EDD758043;
	Wed, 26 Jun 2024 11:16:30 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DAA065805D;
	Wed, 26 Jun 2024 11:16:27 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 26 Jun 2024 11:16:27 +0000 (GMT)
From: Niklas Schnelle <schnelle@linux.ibm.com>
Date: Wed, 26 Jun 2024 13:15:49 +0200
Subject: [PATCH v4 2/4] s390/pci: Add quirk support and set
 pdev-non_compliant_bars for ISM devices
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240626-vfio_pci_mmap-v4-2-7f038870f022@linux.ibm.com>
References: <20240626-vfio_pci_mmap-v4-0-7f038870f022@linux.ibm.com>
In-Reply-To: <20240626-vfio_pci_mmap-v4-0-7f038870f022@linux.ibm.com>
To: Bjorn Helgaas <helgaas@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Gerd Bayer <gbayer@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Niklas Schnelle <schnelle@linux.ibm.com>
X-Mailer: b4 0.12.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=4182;
 i=schnelle@linux.ibm.com; h=from:subject:message-id;
 bh=CYzstYaaXSrnMozeJlgiNEPXqNaJBsBlSJh01euI9Zs=;
 b=owGbwMvMwCH2Wz534YHOJ2GMp9WSGNKqfxTrb5y5aVvb4u1OAkrvZP/tnM3dlbowJE+GaUKXS
 YuFfGBcRykLgxgHg6yYIsuiLme/dQVTTPcE9XfAzGFlAhnCwMUpABPJucbIsJFTwEPjSML3fDeX
 LT8KfQN1XLZub+Yxmiu1SyPza3+TOMP/wJ36PY+sDfIfyMy3yOf49k3O8fZ+/pbsiU3GZbny6uu
 4AA==
X-Developer-Key: i=schnelle@linux.ibm.com; a=openpgp;
 fpr=9DB000B2D2752030A5F72DDCAFE43F15E8C26090
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: R2DKuAR0ZnNaoG1kPepi8fNgl250LMcz
X-Proofpoint-GUID: A1LxgYlOGPctqWHp4KmZeVeD-0AiU3sG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-26_05,2024-06-25_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 suspectscore=0 lowpriorityscore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 bulkscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2406260082

On s390 there is a virtual PCI device called ISM which has a few
pecularities. For one it claims to have a 256 TiB PCI BAR which leads to
any attempt to ioremap() in its entirety failing. This is problematic
since mapping the whole BAR is the default behavior of for example QEMU
with VFIO_PCI_MMAP enabled.

Even if one tried to map this BAR only partially the mapping would not
be usable on systems with MIO support enabled unless using the function
handle based PCI instructions directly. This is because of another
oddity in that this virtual PCI device does not support the newer memory
I/O (MIO) PCI instructions and legacy PCI instructions are not
accessible through writeq()/readq() or by user-space when MIO is in use.

Indicate that ISM's BAR is special and does not conform to PCI BAR
expectations by setting pdev->non_compliant_bars such that drivers not
specifically developed for ISM can easily ignore it. To this end add
basic PCI quirks support modeled after x86's arch/x86/pci/fixup.c and
move the ISM device's PCI ID to the common header to make it accessible.
Also enable CONFIG_PCI_QUIRKS whenever CONFIG_PCI is enabled.

Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
---
 arch/s390/Kconfig          |  4 +---
 arch/s390/pci/Makefile     |  2 +-
 arch/s390/pci/pci_fixup.c  | 23 +++++++++++++++++++++++
 drivers/s390/net/ism_drv.c |  1 -
 include/linux/pci_ids.h    |  1 +
 5 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index c59d2b54df49..8332ba71465e 100644
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
 
@@ -234,6 +231,7 @@ config S390
 	select PCI_DOMAINS		if PCI
 	select PCI_MSI			if PCI
 	select PCI_MSI_ARCH_FALLBACKS	if PCI_MSI
+	select PCI_QUIRKS		if PCI
 	select SPARSE_IRQ
 	select SWIOTLB
 	select SYSCTL_EXCEPTION_TRACE
diff --git a/arch/s390/pci/Makefile b/arch/s390/pci/Makefile
index 0547a10406e7..03d96c76c21a 100644
--- a/arch/s390/pci/Makefile
+++ b/arch/s390/pci/Makefile
@@ -5,5 +5,5 @@
 
 obj-$(CONFIG_PCI)	+= pci.o pci_irq.o pci_clp.o pci_sysfs.o \
 			   pci_event.o pci_debug.o pci_insn.o pci_mmio.o \
-			   pci_bus.o pci_kvm_hook.o
+			   pci_bus.o pci_kvm_hook.o pci_fixup.o
 obj-$(CONFIG_PCI_IOV)	+= pci_iov.o
diff --git a/arch/s390/pci/pci_fixup.c b/arch/s390/pci/pci_fixup.c
new file mode 100644
index 000000000000..61045348f20a
--- /dev/null
+++ b/arch/s390/pci/pci_fixup.c
@@ -0,0 +1,23 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Exceptions for specific devices,
+ *
+ * Copyright IBM Corp. 2024
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
+	pdev->non_compliant_bars = 1;
+}
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_IBM,
+			PCI_DEVICE_ID_IBM_ISM,
+			zpci_ism_bar_no_mmap);
diff --git a/drivers/s390/net/ism_drv.c b/drivers/s390/net/ism_drv.c
index e36e3ea165d3..d32633ed9fa8 100644
--- a/drivers/s390/net/ism_drv.c
+++ b/drivers/s390/net/ism_drv.c
@@ -20,7 +20,6 @@
 MODULE_DESCRIPTION("ISM driver for s390");
 MODULE_LICENSE("GPL");
 
-#define PCI_DEVICE_ID_IBM_ISM 0x04ED
 #define DRV_NAME "ism"
 
 static const struct pci_device_id ism_device_table[] = {
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 942a587bb97e..d730fce2113f 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -517,6 +517,7 @@
 #define PCI_DEVICE_ID_IBM_ICOM_V2_ONE_PORT_RVX_ONE_PORT_MDM	0x0251
 #define PCI_DEVICE_ID_IBM_ICOM_V2_ONE_PORT_RVX_ONE_PORT_MDM_PCIE 0x0361
 #define PCI_DEVICE_ID_IBM_ICOM_FOUR_PORT_MODEL	0x252
+#define PCI_DEVICE_ID_IBM_ISM		0x04ED
 
 #define PCI_SUBVENDOR_ID_IBM		0x1014
 #define PCI_SUBDEVICE_ID_IBM_SATURN_SERIAL_ONE_PORT	0x03d4

-- 
2.40.1


