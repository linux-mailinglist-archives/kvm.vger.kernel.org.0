Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0F2A2FC0F8
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 21:27:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390547AbhASU1a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 15:27:30 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32792 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390223AbhASUYf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Jan 2021 15:24:35 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10JK2K9D178309;
        Tue, 19 Jan 2021 15:23:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=IQMgiGhUZZdFvXz8BaA2KHszZfRA+WzBAJ9mKgLnEmI=;
 b=DFsYynOchPiPyu0+jZDW6h+RAqjFIP1vN1A5vcWiG3TRX0pewXaRAW1/x1rx3RNr8+8v
 Gb3Xbog8eQnN31UeI1AcFR7eSAsoFwtmNN8qTo1YRGh+B35B1iI5KUvOsfu3rIVcVxpu
 L1Pj8FpnUsll9JRyG6Mur5bW5O2fq7VmA99CzRoMtQqP7Shl1xmt6zTfNSDZl5c19RHk
 lNPq/2Kv+B+iiffMV4R+MynSzq/Mz+kCWn8nIUjpXK6d0T7k9iA8lkEOvpzRwViVRhl8
 p/rb1cIYfGp/GxqMSuAqwhyTH8CtPd17l3bqoCWY5I15mXKoQhlHQ0j+aGQULPJbq73X Vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36643wku3w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 15:23:53 -0500
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10JK2Ofe178627;
        Tue, 19 Jan 2021 15:23:53 -0500
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36643wku3e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 15:23:53 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10JJpTbq030018;
        Tue, 19 Jan 2021 20:02:46 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma03wdc.us.ibm.com with ESMTP id 363qs90peb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 20:02:46 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10JK2ill28115438
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jan 2021 20:02:44 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9469BAC059;
        Tue, 19 Jan 2021 20:02:44 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6C808AC05F;
        Tue, 19 Jan 2021 20:02:42 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.211.56.144])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 19 Jan 2021 20:02:42 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com
Cc:     pmorel@linux.ibm.com, borntraeger@de.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] vfio-pci/zdev: Introduce the zPCI I/O vfio region
Date:   Tue, 19 Jan 2021 15:02:30 -0500
Message-Id: <1611086550-32765-5-git-send-email-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1611086550-32765-1-git-send-email-mjrosato@linux.ibm.com>
References: <1611086550-32765-1-git-send-email-mjrosato@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-19_09:2021-01-18,2021-01-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 clxscore=1015 impostorscore=0 phishscore=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 suspectscore=0 adultscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101190106
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some s390 PCI devices (e.g. ISM) perform I/O operations that have very
specific requirements in terms of alignment as well as the patterns in
which the data is read/written. Allowing these to proceed through the
typical vfio_pci_bar_rw path will cause them to be broken in up in such a
way that these requirements can't be guaranteed. In addition, ISM devices
do not support the MIO codepaths that might be triggered on vfio I/O coming
from userspace; we must be able to ensure that these devices use the
non-MIO instructions.  To facilitate this, provide a new vfio region by
which non-MIO instructions can be passed directly to the host kernel s390
PCI layer, to be reliably issued as non-MIO instructions.

This patch introduces the new vfio VFIO_REGION_SUBTYPE_IBM_ZPCI_IO region
and implements the ability to pass PCISTB and PCILG instructions over it,
as these are what is required for ISM devices.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 drivers/vfio/pci/vfio_pci.c         |   8 ++
 drivers/vfio/pci/vfio_pci_private.h |   6 ++
 drivers/vfio/pci/vfio_pci_zdev.c    | 158 ++++++++++++++++++++++++++++++++++++
 include/uapi/linux/vfio.h           |   4 +
 include/uapi/linux/vfio_zdev.h      |  33 ++++++++
 5 files changed, 209 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 706de3e..e1c156e 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -407,6 +407,14 @@ static int vfio_pci_enable(struct vfio_pci_device *vdev)
 		}
 	}
 
+	if (IS_ENABLED(CONFIG_VFIO_PCI_ZDEV)) {
+		ret = vfio_pci_zdev_io_init(vdev);
+		if (ret && ret != -ENODEV) {
+			pci_warn(pdev, "Failed to setup zPCI I/O region\n");
+			return ret;
+		}
+	}
+
 	vfio_pci_probe_mmaps(vdev);
 
 	return 0;
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index 5c90e56..bc49980 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -217,12 +217,18 @@ static inline int vfio_pci_ibm_npu2_init(struct vfio_pci_device *vdev)
 #ifdef CONFIG_VFIO_PCI_ZDEV
 extern int vfio_pci_info_zdev_add_caps(struct vfio_pci_device *vdev,
 				       struct vfio_info_cap *caps);
+extern int vfio_pci_zdev_io_init(struct vfio_pci_device *vdev);
 #else
 static inline int vfio_pci_info_zdev_add_caps(struct vfio_pci_device *vdev,
 					      struct vfio_info_cap *caps)
 {
 	return -ENODEV;
 }
+
+static inline int vfio_pci_zdev_io_init(struct vfio_pci_device *vdev)
+{
+	return -ENODEV;
+}
 #endif
 
 #endif /* VFIO_PCI_PRIVATE_H */
diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
index 57e19ff..a962043 100644
--- a/drivers/vfio/pci/vfio_pci_zdev.c
+++ b/drivers/vfio/pci/vfio_pci_zdev.c
@@ -18,6 +18,7 @@
 #include <linux/vfio_zdev.h>
 #include <asm/pci_clp.h>
 #include <asm/pci_io.h>
+#include <asm/pci_insn.h>
 
 #include "vfio_pci_private.h"
 
@@ -143,3 +144,160 @@ int vfio_pci_info_zdev_add_caps(struct vfio_pci_device *vdev,
 
 	return ret;
 }
+
+static size_t vfio_pci_zdev_io_rw(struct vfio_pci_device *vdev,
+				  char __user *buf, size_t count,
+				  loff_t *ppos, bool iswrite)
+{
+	unsigned int i = VFIO_PCI_OFFSET_TO_INDEX(*ppos) - VFIO_PCI_NUM_REGIONS;
+	struct vfio_region_zpci_io *region = vdev->region[i].data;
+	struct zpci_dev *zdev = to_zpci(vdev->pdev);
+	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
+	void *base = region;
+	struct page *gpage;
+	void *gaddr;
+	u64 *data;
+	int ret;
+	u64 req;
+
+	if ((!vdev->pdev->bus) || (!zdev))
+		return -ENODEV;
+
+	if (pos >= vdev->region[i].size)
+		return -EINVAL;
+
+	count = min(count, (size_t)(vdev->region[i].size - pos));
+
+	if (!iswrite) {
+		/* Only allow reads to the _hdr area */
+		if (pos + count > offsetof(struct vfio_region_zpci_io, req))
+			return -EFAULT;
+		if (copy_to_user(buf, base + pos, count))
+			return -EFAULT;
+		return count;
+	}
+
+	/* Only allow writes to the _req area */
+	if (pos < offsetof(struct vfio_region_zpci_io, req))
+		return -EFAULT;
+	if (copy_from_user(base + pos, buf, count))
+		return -EFAULT;
+
+	/*
+	 * Read operations are limited to 8B
+	 */
+	if ((region->req.flags & VFIO_ZPCI_IO_FLAG_READ) &&
+		(region->req.len > 8)) {
+		return -EIO;
+	}
+
+	/*
+	 * Block write operations are limited to hardware-reported max
+	 */
+	if ((region->req.flags & VFIO_ZPCI_IO_FLAG_BLOCKW) &&
+		(region->req.len > zdev->maxstbl)) {
+		return -EIO;
+	}
+
+	/*
+	 * While some devices may allow relaxed alignment for the PCISTB
+	 * instruction, the VFIO region requires the input buffer to be on a
+	 * DWORD boundary for all operations for simplicity.
+	 */
+	if (!IS_ALIGNED(region->req.gaddr, sizeof(uint64_t)))
+		return -EIO;
+
+	/*
+	 * For now, the largest allowed block I/O is advertised as PAGE_SIZE,
+	 * and cannot exceed a page boundary - so a single page is enough.  The
+	 * guest should have validated this but let's double-check that the
+	 * request will not cross a page boundary.
+	 */
+	if (((region->req.gaddr & ~PAGE_MASK)
+			+ region->req.len - 1) & PAGE_MASK) {
+		return -EIO;
+	}
+
+	mutex_lock(&zdev->lock);
+
+	ret = get_user_pages_fast(region->req.gaddr & PAGE_MASK, 1, 0, &gpage);
+	if (ret <= 0) {
+		count = -EIO;
+		goto out;
+	}
+	gaddr = page_address(gpage);
+	gaddr += (region->req.gaddr & ~PAGE_MASK);
+	data = (u64 *)gaddr;
+
+	req = ZPCI_CREATE_REQ(zdev->fh, region->req.pcias, region->req.len);
+
+	/* Perform the requested I/O operation */
+	if (region->req.flags & VFIO_ZPCI_IO_FLAG_READ) {
+		/* PCILG */
+		ret = __zpci_load(data, req,
+				region->req.offset);
+	} else if (region->req.flags & VFIO_ZPCI_IO_FLAG_BLOCKW) {
+		/* PCISTB */
+		ret = __zpci_store_block(data, req,
+					region->req.offset);
+	} else {
+		/* Undefined Operation or none provided */
+		count = -EIO;
+	}
+	if (ret < 0)
+		count = -EIO;
+
+	put_page(gpage);
+
+out:
+	mutex_unlock(&zdev->lock);
+	return count;
+}
+
+static void vfio_pci_zdev_io_release(struct vfio_pci_device *vdev,
+				     struct vfio_pci_region *region)
+{
+	kfree(region->data);
+}
+
+static const struct vfio_pci_regops vfio_pci_zdev_io_regops = {
+	.rw		= vfio_pci_zdev_io_rw,
+	.release	= vfio_pci_zdev_io_release,
+};
+
+int vfio_pci_zdev_io_init(struct vfio_pci_device *vdev)
+{
+	struct vfio_region_zpci_io *region;
+	struct zpci_dev *zdev;
+	int ret;
+
+	if (!vdev->pdev->bus)
+		return -ENODEV;
+
+	zdev = to_zpci(vdev->pdev);
+	if (!zdev)
+		return -ENODEV;
+
+	region = kmalloc(sizeof(struct vfio_region_zpci_io), GFP_KERNEL);
+
+	ret = vfio_pci_register_dev_region(vdev,
+		PCI_VENDOR_ID_IBM | VFIO_REGION_TYPE_PCI_VENDOR_TYPE,
+		VFIO_REGION_SUBTYPE_IBM_ZPCI_IO,
+		&vfio_pci_zdev_io_regops,
+		sizeof(struct vfio_region_zpci_io),
+		VFIO_REGION_INFO_FLAG_READ | VFIO_REGION_INFO_FLAG_WRITE,
+		region);
+
+	if (ret) {
+		kfree(region);
+		return ret;
+	}
+
+	/* Setup the initial header information */
+	region->hdr.flags = 0;
+	region->hdr.max = zdev->maxstbl;
+	region->hdr.reserved = 0;
+	region->hdr.reserved2 = 0;
+
+	return ret;
+}
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index d181277..5547f9b 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -338,6 +338,10 @@ struct vfio_region_info_cap_type {
  * to do TLB invalidation on a GPU.
  */
 #define VFIO_REGION_SUBTYPE_IBM_NVLINK2_ATSD	(1)
+/*
+ * IBM zPCI I/O region
+ */
+#define VFIO_REGION_SUBTYPE_IBM_ZPCI_IO		(2)
 
 /* sub-types for VFIO_REGION_TYPE_GFX */
 #define VFIO_REGION_SUBTYPE_GFX_EDID            (1)
diff --git a/include/uapi/linux/vfio_zdev.h b/include/uapi/linux/vfio_zdev.h
index b0b6596..830acca4 100644
--- a/include/uapi/linux/vfio_zdev.h
+++ b/include/uapi/linux/vfio_zdev.h
@@ -76,4 +76,37 @@ struct vfio_device_info_cap_zpci_pfip {
 	__u8 pfip[];
 };
 
+/**
+ * VFIO_REGION_SUBTYPE_IBM_ZPCI_IO - VFIO zPCI PCI Direct I/O Region
+ *
+ * This region is used to transfer I/O operations from the guest directly
+ * to the host zPCI I/O layer.  The same instruction requested by the guest
+ * (e.g. PCISTB) will always be used, even if the MIO variant is available.
+ *
+ * The _hdr area is user-readable and is used to provide setup information.
+ * The _req area is user-writable and is used to provide the I/O operation.
+ */
+struct vfio_zpci_io_hdr {
+	__u64 flags;
+	__u16 max;		/* Max block operation size allowed */
+	__u16 reserved;
+	__u32 reserved2;
+};
+
+struct vfio_zpci_io_req {
+	__u64 flags;
+#define VFIO_ZPCI_IO_FLAG_READ (1 << 0) /* Read Operation Specified */
+#define VFIO_ZPCI_IO_FLAG_BLOCKW (1 << 1) /* Block Write Operation Specified */
+	__u64 gaddr;		/* Address of guest data */
+	__u64 offset;		/* Offset into target PCI Address Space */
+	__u32 reserved;
+	__u16 len;		/* Length of guest operation */
+	__u8 pcias;		/* Target PCI Address Space */
+	__u8 reserved2;
+};
+
+struct vfio_region_zpci_io {
+	struct vfio_zpci_io_hdr hdr;
+	struct vfio_zpci_io_req req;
+};
 #endif
-- 
1.8.3.1

