Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D094270EF9
	for <lists+kvm@lfdr.de>; Sat, 19 Sep 2020 17:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbgISP3B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Sep 2020 11:29:01 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:13670 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726609AbgISP2x (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 19 Sep 2020 11:28:53 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08JF1i5w016758;
        Sat, 19 Sep 2020 11:28:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=5kdqs7Ly86dfKgI6wh7OU0A1GEXMYvgp2EoCOx/rw10=;
 b=Bv9O0fzp0zk8xt5mtus47bSJ20oF1bowLg2HbcsHmrteVLGngTUITrKLAxdpU2+MWDMO
 VngppRQwotHZM3eJIz4dSYIr6g97N6Zq8bIvQefNHgkEI6APbHX69YH5sVANLFbzJkKk
 /1xY1UIh/+PTeC4yec3bTZiBDQGMM9wiGsT2Ekomem9m7rC+hMfHPi9G+5kH6DbyV8sh
 vX8tAcivxGq24Wq/x8dbDpoiaulVZzg0SumBbSQo+C7SxJVUbrsWWojl6Hxugg7rtnAv
 o8YBSRAL/MBSBSwARWB4UPGrCmXgXZqBpF8mN8Z4CE1w41NddhWE59+Clom7C+Vs67zq fA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33nkyx0qn7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 19 Sep 2020 11:28:51 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08JFS4im072643;
        Sat, 19 Sep 2020 11:28:51 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33nkyx0qmy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 19 Sep 2020 11:28:51 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08JFR3bm003396;
        Sat, 19 Sep 2020 15:28:50 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma02dal.us.ibm.com with ESMTP id 33n9m8c0cy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 19 Sep 2020 15:28:50 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08JFSkEd37355808
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Sep 2020 15:28:46 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BD59DBE054;
        Sat, 19 Sep 2020 15:28:46 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A9015BE04F;
        Sat, 19 Sep 2020 15:28:45 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.211.74.107])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Sat, 19 Sep 2020 15:28:45 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com
Cc:     pmorel@linux.ibm.com, borntraeger@de.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] vfio-pci/zdev: use a device region to retrieve zPCI information
Date:   Sat, 19 Sep 2020 11:28:38 -0400
Message-Id: <1600529318-8996-5-git-send-email-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1600529318-8996-1-git-send-email-mjrosato@linux.ibm.com>
References: <1600529318-8996-1-git-send-email-mjrosato@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-19_05:2020-09-16,2020-09-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 phishscore=0
 adultscore=0 mlxscore=0 lowpriorityscore=0 clxscore=1015 spamscore=0
 bulkscore=0 suspectscore=0 impostorscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009190126
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Define a new configuration entry VFIO_PCI_ZDEV for VFIO/PCI.

When this s390-only feature is configured we initialize a new device
region, VFIO_REGION_SUBTYPE_IBM_ZPCI_CLP, to hold information provided
by the underlying hardware.

This patch is based on work previously done by Pierre Morel.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 drivers/vfio/pci/Kconfig            |  13 ++
 drivers/vfio/pci/Makefile           |   1 +
 drivers/vfio/pci/vfio_pci.c         |   8 ++
 drivers/vfio/pci/vfio_pci_private.h |  10 ++
 drivers/vfio/pci/vfio_pci_zdev.c    | 242 ++++++++++++++++++++++++++++++++++++
 5 files changed, 274 insertions(+)
 create mode 100644 drivers/vfio/pci/vfio_pci_zdev.c

diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index ac3c1dd..07b4a35 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -45,3 +45,16 @@ config VFIO_PCI_NVLINK2
 	depends on VFIO_PCI && PPC_POWERNV
 	help
 	  VFIO PCI support for P9 Witherspoon machine with NVIDIA V100 GPUs
+
+config VFIO_PCI_ZDEV
+	bool "VFIO PCI ZPCI device CLP support"
+	depends on VFIO_PCI && S390
+	default y
+	help
+	  Enabling this options exposes a region containing hardware
+	  configuration for zPCI devices. This enables userspace (e.g. QEMU)
+	  to supply proper configuration values instead of hard-coded defaults
+	  for zPCI devices passed through via VFIO on s390.
+
+	  Say Y here.
+
diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index f027f8a..781e080 100644
--- a/drivers/vfio/pci/Makefile
+++ b/drivers/vfio/pci/Makefile
@@ -3,5 +3,6 @@
 vfio-pci-y := vfio_pci.o vfio_pci_intrs.o vfio_pci_rdwr.o vfio_pci_config.o
 vfio-pci-$(CONFIG_VFIO_PCI_IGD) += vfio_pci_igd.o
 vfio-pci-$(CONFIG_VFIO_PCI_NVLINK2) += vfio_pci_nvlink2.o
+vfio-pci-$(CONFIG_VFIO_PCI_ZDEV) += vfio_pci_zdev.o
 
 obj-$(CONFIG_VFIO_PCI) += vfio-pci.o
diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 1ab1f5c..cfb04d9 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -409,6 +409,14 @@ static int vfio_pci_enable(struct vfio_pci_device *vdev)
 		}
 	}
 
+	if (IS_ENABLED(CONFIG_VFIO_PCI_ZDEV)) {
+		ret = vfio_pci_zdev_init(vdev);
+		if (ret && ret != -ENODEV) {
+			pci_warn(pdev, "Failed to setup zPCI CLP region\n");
+			goto disable_exit;
+		}
+	}
+
 	vfio_pci_probe_mmaps(vdev);
 
 	return 0;
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index 61ca8ab..729af20 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -213,4 +213,14 @@ static inline int vfio_pci_ibm_npu2_init(struct vfio_pci_device *vdev)
 	return -ENODEV;
 }
 #endif
+
+#ifdef CONFIG_VFIO_PCI_ZDEV
+extern int vfio_pci_zdev_init(struct vfio_pci_device *vdev);
+#else
+static inline int vfio_pci_zdev_init(struct vfio_pci_device *vdev)
+{
+	return -ENODEV;
+}
+#endif
+
 #endif /* VFIO_PCI_PRIVATE_H */
diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
new file mode 100644
index 0000000..9c7d659
--- /dev/null
+++ b/drivers/vfio/pci/vfio_pci_zdev.c
@@ -0,0 +1,242 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * VFIO ZPCI devices support
+ *
+ * Copyright (C) IBM Corp. 2020.  All rights reserved.
+ *	Author(s): Pierre Morel <pmorel@linux.ibm.com>
+ *                 Matthew Rosato <mjrosato@linux.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+#include <linux/io.h>
+#include <linux/pci.h>
+#include <linux/uaccess.h>
+#include <linux/vfio.h>
+#include <linux/vfio_zdev.h>
+#include <asm/pci_clp.h>
+#include <asm/pci_io.h>
+
+#include "vfio_pci_private.h"
+
+static size_t vfio_pci_zdev_rw(struct vfio_pci_device *vdev,
+			       char __user *buf, size_t count, loff_t *ppos,
+			       bool iswrite)
+{
+	unsigned int i = VFIO_PCI_OFFSET_TO_INDEX(*ppos) - VFIO_PCI_NUM_REGIONS;
+	struct vfio_region_zpci_info *region = vdev->region[i].data;
+	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
+
+	if ((!vdev->pdev->bus) || (!to_zpci(vdev->pdev)))
+		return -ENODEV;
+
+	if (pos >= vdev->region[i].size || iswrite)
+		return -EINVAL;
+
+	count = min(count, (size_t)(vdev->region[i].size - pos));
+	if (copy_to_user(buf, region + pos, count))
+		return -EFAULT;
+
+	return count;
+}
+
+static void vfio_pci_zdev_release(struct vfio_pci_device *vdev,
+				  struct vfio_pci_region *region)
+{
+	kfree(region->data);
+}
+
+static const struct vfio_pci_regops vfio_pci_zdev_regops = {
+	.rw		= vfio_pci_zdev_rw,
+	.release	= vfio_pci_zdev_release,
+};
+
+static void vfio_pci_zdev_fill_hdr(struct vfio_region_zpci_info_hdr *hdr,
+				   __u16 id, __u16 version, size_t offset,
+				   size_t size)
+{
+	hdr->id = id;
+	hdr->version = version;
+	hdr->next = offset + size;
+}
+
+/*
+ * Add the Query PCI Function information to the device region.
+ *
+ * zdev - the zPCI device to get information from
+ * region - start of the vfio device region
+ * offset - location within region to place the data
+ *
+ * On return, provide the offset of the end of this CLP feature.
+ */
+static size_t vfio_pci_zdev_add_qpci(struct zpci_dev *zdev, void *region,
+				     size_t offset)
+{
+	struct vfio_region_zpci_info_qpci *clp;
+
+	/* Jump to the CLP region via the offset */
+	clp = (struct vfio_region_zpci_info_qpci *) (region + offset);
+
+	/* Fill in the clp header */
+	vfio_pci_zdev_fill_hdr(&clp->hdr, VFIO_REGION_ZPCI_INFO_QPCI, 1,
+			       offset, sizeof(*clp));
+
+	/* Fill in the CLP feature info */
+	clp->start_dma = zdev->start_dma;
+	clp->end_dma = zdev->end_dma;
+	clp->pchid = zdev->pchid;
+	clp->vfn = zdev->vfn;
+	clp->fmb_length = zdev->fmb_length;
+	clp->pft = zdev->pft;
+	clp->gid = zdev->pfgid;
+
+	/* Return offset to the end of this CLP feature */
+	return clp->hdr.next;
+}
+
+/*
+ * Add the Query PCI Function Group information to the device region.
+ *
+ * zdev - the zPCI device to get information from
+ * region - start of the vfio device region
+ * offset - location within region to place the data
+ *
+ * On return, provide the offset of the end of this CLP feature.
+ */
+static size_t vfio_pci_zdev_add_qpcifg(struct zpci_dev *zdev, void *region,
+				       size_t offset)
+{
+	struct vfio_region_zpci_info_qpcifg *clp;
+
+	/* Jump to the CLP region via the offset */
+	clp = (struct vfio_region_zpci_info_qpcifg *) (region + offset);
+
+	/* Fill in the clp header */
+	vfio_pci_zdev_fill_hdr(&clp->hdr, VFIO_REGION_ZPCI_INFO_QPCIFG, 1,
+			       offset, sizeof(*clp));
+
+	/* Fill in the CLP feature info */
+	clp->dasm = zdev->dma_mask;
+	clp->msi_addr = zdev->msi_addr;
+	clp->flags = VFIO_PCI_ZDEV_FLAGS_REFRESH;
+	clp->mui = zdev->fmb_update;
+	clp->noi = zdev->max_msi;
+	clp->maxstbl = ZPCI_MAX_WRITE_SIZE;
+	clp->version = zdev->version;
+
+	/* Return offset to the end of this CLP feature */
+	return clp->hdr.next;
+}
+
+/*
+ * Add the device utility string to the device region.
+ *
+ * zdev - the zPCI device to get information from
+ * region - start of the vfio device region
+ * offset - location within region to place the data
+ *
+ * On return, provide the offset of the end of this CLP feature.
+ */
+static size_t vfio_pci_zdev_add_util(struct zpci_dev *zdev, void *region,
+				     size_t offset)
+{
+	struct vfio_region_zpci_info_util *clp;
+	size_t size = CLP_UTIL_STR_LEN;
+
+	/* Only add a utility string if one is available */
+	if (!zdev->util_avail)
+		return offset;
+
+	/* Jump to the CLP region via the offset */
+	clp = (struct vfio_region_zpci_info_util *) (region + offset);
+
+	/* Fill in the clp header */
+	vfio_pci_zdev_fill_hdr(&clp->hdr, VFIO_REGION_ZPCI_INFO_UTIL, 1,
+			       offset, sizeof(*clp) + size);
+
+	/* Fill in the CLP feature info */
+	clp->size = size;
+	memcpy(clp->util_str, zdev->util_str, size);
+
+	/* Return offset to the end of this CLP feature */
+	return clp->hdr.next;
+}
+
+/*
+ * Add the function path string to the device region.
+ *
+ * zdev - the zPCI device to get information from
+ * region - start of the vfio device region
+ * offset - location within region to place the data
+ *
+ * On return, provide the offset of the end of this CLP feature.
+ */
+static size_t vfio_pci_zdev_add_pfip(struct zpci_dev *zdev, void *region,
+				     size_t offset)
+{
+	struct vfio_region_zpci_info_pfip *clp;
+	size_t size = CLP_PFIP_NR_SEGMENTS;
+
+	/* Jump to the CLP region via the offset */
+	clp = (struct vfio_region_zpci_info_pfip *) (region + offset);
+
+	/* Fill in the clp header */
+	vfio_pci_zdev_fill_hdr(&clp->hdr, VFIO_REGION_ZPCI_INFO_PFIP, 1,
+			       offset, sizeof(*clp) + size);
+
+	/* Fill in the CLP feature info */
+	clp->size = size;
+	memcpy(clp->pfip, zdev->pfip, size);
+
+	/* Return offset to the end of this CLP feature */
+	return clp->hdr.next;
+}
+
+int vfio_pci_zdev_init(struct vfio_pci_device *vdev)
+{
+	struct vfio_region_zpci_info *region;
+	struct zpci_dev *zdev;
+	size_t clp_offset;
+	int size;
+	int ret;
+
+	if (!vdev->pdev->bus)
+		return -ENODEV;
+
+	zdev = to_zpci(vdev->pdev);
+	if (!zdev)
+		return -ENODEV;
+
+	/* Calculate size needed for all supported CLP features  */
+	size = sizeof(*region) +
+	       sizeof(struct vfio_region_zpci_info_qpci) +
+	       sizeof(struct vfio_region_zpci_info_qpcifg) +
+	       (sizeof(struct vfio_region_zpci_info_util) + CLP_UTIL_STR_LEN) +
+	       (sizeof(struct vfio_region_zpci_info_pfip) +
+		CLP_PFIP_NR_SEGMENTS);
+
+	region = kmalloc(size, GFP_KERNEL);
+	if (!region)
+		return -ENOMEM;
+
+	/* Fill in header */
+	region->argsz = size;
+	clp_offset = region->offset = sizeof(struct vfio_region_zpci_info);
+
+	/* Fill the supported CLP features */
+	clp_offset = vfio_pci_zdev_add_qpci(zdev, region, clp_offset);
+	clp_offset = vfio_pci_zdev_add_qpcifg(zdev, region, clp_offset);
+	clp_offset = vfio_pci_zdev_add_util(zdev, region, clp_offset);
+	clp_offset = vfio_pci_zdev_add_pfip(zdev, region, clp_offset);
+
+	ret = vfio_pci_register_dev_region(vdev,
+		PCI_VENDOR_ID_IBM | VFIO_REGION_TYPE_PCI_VENDOR_TYPE,
+		VFIO_REGION_SUBTYPE_IBM_ZPCI_CLP, &vfio_pci_zdev_regops,
+		size, VFIO_REGION_INFO_FLAG_READ, region);
+	if (ret)
+		kfree(region);
+
+	return ret;
+}
-- 
1.8.3.1

