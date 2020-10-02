Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE56281C76
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 22:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725828AbgJBUBK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 16:01:10 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:11786 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725536AbgJBUBA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 2 Oct 2020 16:01:00 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 092JXGRV080826;
        Fri, 2 Oct 2020 16:00:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=BLFOKbivALR+Csqil63DWbKhd0Vviz4d2t2qpTQHpHE=;
 b=SAIbpw68Pzyd9hwIjPtVqIMbp3/8kNPw8C+XC5RNieSz2evcDWYkKrTX/z58cYNWWk+f
 0U6O/ntNdLPJITRfGLAa99sVJVIQCP/3AEF/OOxPRRgLwaHbZ3ztT88ArT8nmE8ZMUd3
 F14rX8TzG0Z3nWqzK59NCbIplEiCLDVqxx1yPaUin6Z+w2o61SvcpbbEGeVugOuJGIlg
 O0lEMLUxEbHWpR/DIPeLrJMrpkih/4IFQpK6bF2+oiBBltjb4qXhLGWfq7VLug40cL85
 rXEF0jbtDW0USIFb9QyllgpZX/jfCx8TK0Esja8VqJFmkx69pleTXF//NQ8i4vOmctY2 5g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33xa670yap-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Oct 2020 16:00:58 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 092JYOfB087952;
        Fri, 2 Oct 2020 16:00:58 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33xa670y9t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Oct 2020 16:00:58 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 092JmO6i008020;
        Fri, 2 Oct 2020 20:00:56 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma01wdc.us.ibm.com with ESMTP id 33sw9a0832-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Oct 2020 20:00:56 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 092K0raH23134610
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 2 Oct 2020 20:00:53 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 97F8C6E053;
        Fri,  2 Oct 2020 20:00:53 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7BD796E050;
        Fri,  2 Oct 2020 20:00:52 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.163.4.25])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  2 Oct 2020 20:00:52 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com
Cc:     pmorel@linux.ibm.com, borntraeger@de.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/5] vfio-pci/zdev: use a device region to retrieve zPCI information
Date:   Fri,  2 Oct 2020 16:00:43 -0400
Message-Id: <1601668844-5798-5-git-send-email-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1601668844-5798-1-git-send-email-mjrosato@linux.ibm.com>
References: <1601668844-5798-1-git-send-email-mjrosato@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-02_14:2020-10-02,2020-10-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 impostorscore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 phishscore=0 malwarescore=0 priorityscore=1501 bulkscore=0 clxscore=1015
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010020141
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
index 0000000..33324f0
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
+ * Add the Base PCI Function information to the device region.
+ *
+ * zdev - the zPCI device to get information from
+ * region - start of the vfio device region
+ * offset - location within region to place the data
+ *
+ * On return, provide the offset of the end of this CLP feature.
+ */
+static size_t vfio_pci_zdev_add_base(struct zpci_dev *zdev, void *region,
+				     size_t offset)
+{
+	struct vfio_region_zpci_info_base *clp;
+
+	/* Jump to the CLP region via the offset */
+	clp = (struct vfio_region_zpci_info_base *) (region + offset);
+
+	/* Fill in the clp header */
+	vfio_pci_zdev_fill_hdr(&clp->hdr, VFIO_REGION_ZPCI_INFO_BASE, 1,
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
+ * Add the Base PCI Function Group information to the device region.
+ *
+ * zdev - the zPCI device to get information from
+ * region - start of the vfio device region
+ * offset - location within region to place the data
+ *
+ * On return, provide the offset of the end of this CLP feature.
+ */
+static size_t vfio_pci_zdev_add_group(struct zpci_dev *zdev, void *region,
+				      size_t offset)
+{
+	struct vfio_region_zpci_info_group *clp;
+
+	/* Jump to the CLP region via the offset */
+	clp = (struct vfio_region_zpci_info_group *) (region + offset);
+
+	/* Fill in the clp header */
+	vfio_pci_zdev_fill_hdr(&clp->hdr, VFIO_REGION_ZPCI_INFO_GROUP, 1,
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
+	if (!zdev->util_str_avail)
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
+	       sizeof(struct vfio_region_zpci_info_base) +
+	       sizeof(struct vfio_region_zpci_info_group) +
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
+	clp_offset = vfio_pci_zdev_add_base(zdev, region, clp_offset);
+	clp_offset = vfio_pci_zdev_add_group(zdev, region, clp_offset);
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

