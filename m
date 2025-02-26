Return-Path: <kvm+bounces-39278-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7021FA45E65
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 13:16:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 56F457AA29C
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 12:15:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5988B227BA4;
	Wed, 26 Feb 2025 12:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="QXQmiHT1"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1091225A39;
	Wed, 26 Feb 2025 12:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740571695; cv=none; b=fYN2aLy7HNEWHY94oz+FJ1MUYgKcbJ2tQ9Xqv0Oz7XHqZmSyNKPGQZfvR5cu+FSTVPa0lPVgTqHjQjFd1WLhlwyYpngenacnttiQBL9LBC8KVwOZ/dSWn335SiEWYm9BbsLXG8dGc71hTBkZbyB2KjuLXgBq9Kpy8CrF4DpEvMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740571695; c=relaxed/simple;
	bh=vw7XyHSJWOJFbsWuUfr52bP2c8WBL2xfAjSJ2MvKC8I=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=IH8Ts6JF/UYMqkl8Oq76iuyIBj1ByGvFQ9N40MhZIl9PjHO6Z0lAXevwrZ43BCPCrTp+JxEban6+9V+mUyV/x2kkVMk3GBT1B9H2Xca1/QNY+6z4DHqBC7qJ/07vN6QXz4InNCMlThtHwiMZ2m+Wg9bacbt2EyyTKZawTC3ZJcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=QXQmiHT1; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51Q1ksar027799;
	Wed, 26 Feb 2025 12:08:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=sCt0lw
	BrqKj2L6Mit1pF2RNKRIKZPwItgFf8wxX2IWY=; b=QXQmiHT1TUn2qVOtQeNY7e
	jX1Ntmoghh4ZnmYR7YrXa+l7SnRyFhUXiBAubmZPLJJcSUW2CFcXnSzkemsMoYWy
	ahJV3vBQSLVHBEPukpysBxsYzmUK1FDIqahG+yVtvZd828t/Zb4BcsE/W8xIRZEn
	XgzE2FGOVSmBxil81YvdelLgeCMj0LdGx/zwDSFAxyJ7KCsA5wrUMVgmSe+zmFRs
	T2548eJ/lhHSyusUoXzDadws+sA47GUc619XLDD0OYtPFATr7d2Ne9c6cccLCVHZ
	Ypw12qN4bhNyg8WbWEVqM07RjR4EaBkAaCO9wusKTKKCMxFmgC0CKkwyj69O4UIg
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 451q5jayxn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Feb 2025 12:08:06 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 51QC5rH1015266;
	Wed, 26 Feb 2025 12:08:06 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 451q5jayxj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Feb 2025 12:08:05 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51QBGAbt012597;
	Wed, 26 Feb 2025 12:08:04 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44ys9yjq0e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Feb 2025 12:08:04 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51QC83SI28377658
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Feb 2025 12:08:03 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 19BFC58056;
	Wed, 26 Feb 2025 12:08:03 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 42D245803F;
	Wed, 26 Feb 2025 12:08:00 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 26 Feb 2025 12:08:00 +0000 (GMT)
From: Niklas Schnelle <schnelle@linux.ibm.com>
Date: Wed, 26 Feb 2025 13:07:46 +0100
Subject: [PATCH v7 2/3] PCI: s390: Introduce pdev->non_mappable_bars and
 replace VFIO_PCI_MMAP
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250226-vfio_pci_mmap-v7-2-c5c0f1d26efd@linux.ibm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5161;
 i=schnelle@linux.ibm.com; h=from:subject:message-id;
 bh=vw7XyHSJWOJFbsWuUfr52bP2c8WBL2xfAjSJ2MvKC8I=;
 b=owGbwMvMwCX2Wz534YHOJ2GMp9WSGNL3s0icdZ1pdW7TXM4sR7n1esVehTtKe8/zPpI//G3+5
 c/C9rZfO0pZGMS4GGTFFFkWdTn7rSuYYronqL8DZg4rE8gQBi5OAZhI7HuG36w/TP/sy1Kcwv8p
 e+lJpj1Vh69c5Kpl//HcbpnA0rkNTWmMDPcP7uKcFaZ5+/4qn1fNy/qPp3v1NLRfXanSb7v48NL
 iPg4A
X-Developer-Key: i=schnelle@linux.ibm.com; a=openpgp;
 fpr=9DB000B2D2752030A5F72DDCAFE43F15E8C26090
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: PETnbiF1u1S3KoE-AOLaQWBjGhaqNIyw
X-Proofpoint-ORIG-GUID: QwiF8Qhebkm9GCYDAFFyIRaaTEd88yf9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-26_02,2025-02-26_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 mlxlogscore=779 phishscore=0 adultscore=0 clxscore=1015 bulkscore=0
 priorityscore=1501 mlxscore=0 spamscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502100000 definitions=main-2502260096

The ability to map PCI resources to user-space is controlled by global
defines. For vfio there is VFIO_PCI_MMAP which is only disabled on s390
and controls mapping of PCI resources using vfio-pci with a fallback
option via the pread()/pwrite() interface.

For the PCI core there is ARCH_GENERIC_PCI_MMAP_RESOURCE which enables
a generic implementation for mapping PCI resources plus the newer sysfs
interface. Then there is HAVE_PCI_MMAP which can be used with custom
definitions of pci_mmap_resource_range() and the historical
/proc/bus/pci interface. Both mechanisms are all or nothing.

For s390 mapping PCI resources is possible and useful for testing and
certain applications such as QEMU's vfio-pci based user-space NVMe
driver. For certain devices, however access to PCI resources via
mappings to user-space is not possible and these must be excluded from
the general PCI resource mapping mechanisms.

Introduce pdev->non_mappable_bars to indicate that a PCI device's BARs
can not be accessed via mappings to user-space. In the future this
enables per-device restrictions of PCI resource mapping.

For now, set this flag for all PCI devices on s390 in line with the
existing, general disable of PCI resource mapping. As s390 is the only
user of the VFI_PCI_MMAP Kconfig options this can already be replaced
with a check of this new flag. Also add similar checks in the other code
protected by HAVE_PCI_MMAP respectively ARCH_GENERIC_PCI_MMAP in
preparation for enabling these for supported devices.

Link: https://lore.kernel.org/lkml/20250212132808.08dcf03c.alex.williamson@redhat.com/
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
---
 arch/s390/pci/pci.c              | 1 +
 drivers/pci/pci-sysfs.c          | 4 ++++
 drivers/pci/proc.c               | 4 ++++
 drivers/vfio/pci/Kconfig         | 4 ----
 drivers/vfio/pci/vfio_pci_core.c | 2 +-
 include/linux/pci.h              | 1 +
 6 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
index 88f72745fa59e16df26b1563de27594aac954a78..d14b8605a32ce1bc132dff225ac433cf3aae9265 100644
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -590,6 +590,7 @@ int pcibios_device_add(struct pci_dev *pdev)
 	zpci_zdev_get(zdev);
 	if (pdev->is_physfn)
 		pdev->no_vf_scan = 1;
+	pdev->non_mappable_bars = 1;
 
 	zpci_map_resources(pdev);
 
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index b46ce1a2c5542cdea0a3f9df324434fdb7e8a4d2..7373eca0a4943bf896b4a177124e0d4572baec2b 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -1257,6 +1257,10 @@ static int pci_create_resource_files(struct pci_dev *pdev)
 	int i;
 	int retval;
 
+	/* Skip devices with non-mappable BARs */
+	if (pdev->non_mappable_bars)
+		return 0;
+
 	/* Expose the PCI resources from this device as files */
 	for (i = 0; i < PCI_STD_NUM_BARS; i++) {
 
diff --git a/drivers/pci/proc.c b/drivers/pci/proc.c
index f967709082d654a101039091b5493b2dec5f57b4..9348a0fb808477ca9be80a8b88bbc036565bc411 100644
--- a/drivers/pci/proc.c
+++ b/drivers/pci/proc.c
@@ -251,6 +251,10 @@ static int proc_bus_pci_mmap(struct file *file, struct vm_area_struct *vma)
 	    security_locked_down(LOCKDOWN_PCI_ACCESS))
 		return -EPERM;
 
+	/* Skip devices with non-mappable BARs */
+	if (dev->non_mappable_bars)
+		return -EINVAL;
+
 	if (fpriv->mmap_state == pci_mmap_io) {
 		if (!arch_can_pci_mmap_io())
 			return -EINVAL;
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
 

-- 
2.45.2


