Return-Path: <kvm+bounces-38908-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F3203A402FC
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 23:47:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 94B9A3BB7D7
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 22:46:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19948253B66;
	Fri, 21 Feb 2025 22:46:57 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2745E1D5166;
	Fri, 21 Feb 2025 22:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740178016; cv=none; b=m52SUBHOvKo7ODtR6vzpx1qhPaDAzXbUqKmeAfm7nBNRLWqWE3yrLkcofSCJWAwBzLtdMSGgEp8MhU8kzqU9tN5bASmjvuOblUimFESyO0cdmHXOOUh7A0/fjvuMObVVdkeGAQeJv5GIokmdhTrD1MxRvbTycJl3VkH55Ydwk7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740178016; c=relaxed/simple;
	bh=h4AhTDsIETUbnkS5fG0gPKt7CYxmwPg4xcQsnkYOrkY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=cua3AzYmgM/FXQ0BN95fpYGCPb8iJGuGpdNioAaPvFhou5D3+XPYa7G8kBq7fXkN7CYjPau+Jy5JhM7gWvE2W95XOkEABdrdAYxpzB5Nry9iGrPyhOZX35rZ2as3kepjCA9oBgTn/u8PzKKaGxPeGv2KRTSwkXz8bx29u1jSfMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9F89A150C;
	Fri, 21 Feb 2025 14:47:09 -0800 (PST)
Received: from ampere-altra-2-1.usa.arm.com (ampere-altra-2-1.usa.arm.com [10.118.91.158])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A040B3F6A8;
	Fri, 21 Feb 2025 14:46:51 -0800 (PST)
From: Wathsala Vithanage <wathsala.vithanage@arm.com>
To: linux-kernel@vger.kernel.org
Cc: nd@arm.com,
	Wathsala Vithanage <wathsala.vithanage@arm.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Kevin Tian <kevin.tian@intel.com>,
	Philipp Stanner <pstanner@redhat.com>,
	Yunxiang Li <Yunxiang.Li@amd.com>,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	kvm@vger.kernel.org (open list:VFIO DRIVER)
Subject: [RFC PATCH] vfio/pci: add PCIe TPH to device feature ioctl
Date: Fri, 21 Feb 2025 22:46:33 +0000
Message-ID: <20250221224638.1836909-1-wathsala.vithanage@arm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Linux v6.13 introduced the PCIe TLP Processing Hints (TPH) feature for
direct cache injection. As described in the relevant patch set [1],
direct cache injection in supported hardware allows optimal platform
resource utilization for specific requests on the PCIe bus. This feature
is currently available only for kernel device drivers. However,
user space applications, especially those whose performance is sensitive
to the latency of inbound writes as seen by a CPU core, may benefit from
using this information (E.g., DPDK cache stashing RFC [2] or an HPC
application running in a VM).

This patch enables configuring of TPH from the user space via
VFIO_DEVICE_FEATURE IOCLT. It provides an interface to user space
drivers and VMMs to enable/disable the TPH feature on PCIe devices and
set steering tags in MSI-X or steering-tag table entries using
VFIO_DEVICE_FEATURE_SET flag or read steering tags from the kernel using
VFIO_DEVICE_FEATURE_GET to operate in device-specific mode.

[1] lore.kernel.org/linux-pci/20241002165954.128085-1-wei.huang2@amd.com
[2] inbox.dpdk.org/dev/20241021015246.304431-2-wathsala.vithanage@arm.com

Signed-off-by: Wathsala Vithanage <wathsala.vithanage@arm.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 163 +++++++++++++++++++++++++++++++
 include/uapi/linux/vfio.h        |  68 +++++++++++++
 2 files changed, 231 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 586e49efb81b..d6dd0495b08b 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -29,6 +29,7 @@
 #include <linux/nospec.h>
 #include <linux/sched/mm.h>
 #include <linux/iommufd.h>
+#include <linux/pci-tph.h>
 #if IS_ENABLED(CONFIG_EEH)
 #include <asm/eeh.h>
 #endif
@@ -1510,6 +1511,165 @@ static int vfio_pci_core_feature_token(struct vfio_device *device, u32 flags,
 	return 0;
 }
 
+static ssize_t vfio_pci_tph_uinfo_dup(struct vfio_pci_tph *tph,
+				      void __user *arg, size_t argsz,
+				      struct vfio_pci_tph_info **info)
+{
+	size_t minsz;
+
+	if (tph->count > VFIO_TPH_INFO_MAX)
+		return -EINVAL;
+	if (!tph->count)
+		return 0;
+
+	minsz = tph->count * sizeof(struct vfio_pci_tph_info);
+	if (minsz < argsz)
+		return -EINVAL;
+
+	*info = memdup_user(arg, minsz);
+	if (IS_ERR(info))
+		return PTR_ERR(info);
+
+	return minsz;
+}
+
+static int vfio_pci_feature_tph_st_op(struct vfio_pci_core_device *vdev,
+				      struct vfio_pci_tph *tph,
+				      void __user *arg, size_t argsz)
+{
+	int i, mtype, err = 0;
+	u32 cpu_uid;
+	struct vfio_pci_tph_info *info = NULL;
+	ssize_t data_size = vfio_pci_tph_uinfo_dup(tph, arg, argsz, &info);
+
+	if (data_size <= 0)
+		return data_size;
+
+	for (i = 0; i < tph->count; i++) {
+		if (!(info[i].cpu_id < nr_cpu_ids && cpu_present(info[i].cpu_id))) {
+			info[i].err = -EINVAL;
+			continue;
+		}
+		cpu_uid = topology_core_id(info[i].cpu_id);
+		mtype = (info[i].flags & VFIO_TPH_MEM_TYPE_MASK) >>
+			VFIO_TPH_MEM_TYPE_SHIFT;
+
+		/* processing hints are always ignored */
+		info[i].ph_ignore = 1;
+
+		info[i].err = pcie_tph_get_cpu_st(vdev->pdev, mtype, cpu_uid,
+						  &info[i].st);
+		if (info[i].err)
+			continue;
+
+		if (tph->flags & VFIO_DEVICE_FEATURE_TPH_SET_ST) {
+			info[i].err = pcie_tph_set_st_entry(vdev->pdev,
+							    info[i].index,
+							    info[i].st);
+		}
+	}
+
+	if (copy_to_user(arg, info, data_size))
+		err = -EFAULT;
+
+	kfree(info);
+	return err;
+}
+
+
+static int vfio_pci_feature_tph_enable(struct vfio_pci_core_device *vdev,
+				       struct vfio_pci_tph *arg)
+{
+	int mode = arg->flags & VFIO_TPH_ST_MODE_MASK;
+
+	switch (mode) {
+	case VFIO_TPH_ST_NS_MODE:
+		return pcie_enable_tph(vdev->pdev, PCI_TPH_ST_NS_MODE);
+
+	case VFIO_TPH_ST_IV_MODE:
+		return pcie_enable_tph(vdev->pdev, PCI_TPH_ST_IV_MODE);
+
+	case VFIO_TPH_ST_DS_MODE:
+		return pcie_enable_tph(vdev->pdev, PCI_TPH_ST_DS_MODE);
+
+	default:
+		return -EINVAL;
+	}
+
+}
+
+static int vfio_pci_feature_tph_disable(struct vfio_pci_core_device *vdev)
+{
+	pcie_disable_tph(vdev->pdev);
+	return 0;
+}
+
+static int vfio_pci_feature_tph_prepare(struct vfio_pci_tph __user *arg,
+					size_t argsz, u32 flags,
+					struct vfio_pci_tph *tph)
+{
+	u32 op;
+	int err = vfio_check_feature(flags, argsz,
+				 VFIO_DEVICE_FEATURE_SET |
+				 VFIO_DEVICE_FEATURE_GET,
+				 sizeof(struct vfio_pci_tph));
+	if (err != 1)
+		return err;
+
+	if (copy_from_user(tph, arg, sizeof(struct vfio_pci_tph)))
+		return -EFAULT;
+
+	op = tph->flags & VFIO_DEVICE_FEATURE_TPH_OP_MASK;
+
+	switch (op) {
+	case VFIO_DEVICE_FEATURE_TPH_ENABLE:
+	case VFIO_DEVICE_FEATURE_TPH_DISABLE:
+	case VFIO_DEVICE_FEATURE_TPH_SET_ST:
+		return (flags & VFIO_DEVICE_FEATURE_SET) ? 0 : -EINVAL;
+
+	case VFIO_DEVICE_FEATURE_TPH_GET_ST:
+		return (flags & VFIO_DEVICE_FEATURE_GET) ? 0 : -EINVAL;
+
+	default:
+		return -EINVAL;
+	}
+}
+
+static int vfio_pci_core_feature_tph(struct vfio_device *device, u32 flags,
+				     struct vfio_pci_tph __user *arg,
+				     size_t argsz)
+{
+	u32 op;
+	struct vfio_pci_tph tph;
+	void __user *uinfo;
+	size_t infosz;
+	struct vfio_pci_core_device *vdev =
+		container_of(device, struct vfio_pci_core_device, vdev);
+	int err = vfio_pci_feature_tph_prepare(arg, argsz, flags, &tph);
+
+	if (err)
+		return err;
+
+	op = tph.flags & VFIO_DEVICE_FEATURE_TPH_OP_MASK;
+
+	switch (op) {
+	case VFIO_DEVICE_FEATURE_TPH_ENABLE:
+		return vfio_pci_feature_tph_enable(vdev, &tph);
+
+	case VFIO_DEVICE_FEATURE_TPH_DISABLE:
+		return vfio_pci_feature_tph_disable(vdev);
+
+	case VFIO_DEVICE_FEATURE_TPH_GET_ST:
+	case VFIO_DEVICE_FEATURE_TPH_SET_ST:
+		uinfo = (u8 *)(arg) + offsetof(struct vfio_pci_tph, info);
+		infosz = argsz - sizeof(struct vfio_pci_tph);
+		return vfio_pci_feature_tph_st_op(vdev, &tph, uinfo, infosz);
+
+	default:
+		return -EINVAL;
+	}
+}
+
 int vfio_pci_core_ioctl_feature(struct vfio_device *device, u32 flags,
 				void __user *arg, size_t argsz)
 {
@@ -1523,6 +1683,9 @@ int vfio_pci_core_ioctl_feature(struct vfio_device *device, u32 flags,
 		return vfio_pci_core_pm_exit(device, flags, arg, argsz);
 	case VFIO_DEVICE_FEATURE_PCI_VF_TOKEN:
 		return vfio_pci_core_feature_token(device, flags, arg, argsz);
+	case VFIO_DEVICE_FEATURE_PCI_TPH:
+		return vfio_pci_core_feature_tph(device, flags,
+						 arg, argsz);
 	default:
 		return -ENOTTY;
 	}
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index c8dbf8219c4f..608d57dfe279 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -1458,6 +1458,74 @@ struct vfio_device_feature_bus_master {
 };
 #define VFIO_DEVICE_FEATURE_BUS_MASTER 10
 
+/*
+ * Upon VFIO_DEVICE_FEATURE_SET, enable or disable PCIe TPH or set steering tags
+ * on the device. Data provided when setting this feature is a __u32 with the
+ * following flags. VFIO_DEVICE_FEATURE_TPH_ENABLE enables PCIe TPH in
+ * no-steering-tag, interrupt-vector, or device-specific mode when feature flags
+ * VFIO_TPH_ST_NS_MODE, VFIO_TPH_ST_IV_MODE, and VFIO_TPH_ST_DS_MODE are set
+ * respectively.
+ * VFIO_DEVICE_FEATURE_TPH_DISABLE disables PCIe TPH on the device.
+ * VFIO_DEVICE_FEATURE_TPH_SET_ST set steering tags on a device at an index in
+ * MSI-X or ST-table depending on the VFIO_TPH_ST_x_MODE flag used and device
+ * capabilities. The caller can set multiple steering tags by passing an array
+ * of vfio_pci_tph_info objects containing cpu_id, cache_level, and
+ * MSI-X/ST-table index. The caller can also set the intended memory type and
+ * the processing hint by setting VFIO_TPH_MEM_TYPE_x and VFIO_TPH_HINT_x flags,
+ * respectively. The return value for each vfio_pci_tph_info object is stored in
+ * err, with the steering-tag set on the device and the ph_ignore status bit
+ * resulting from the steering-tag lookup operation. If err < 0, the values
+ * stored in the st and ph_ignore fields should be considered invalid.
+ *
+ * Upon VFIO_DEVICE_FEATURE_GET,  return steering tags to the caller.
+ * VFIO_DEVICE_FEATURE_TPH_GET_ST returns steering tags to the caller.
+ * The return values per vfio_pci_tph_info object are stored in the st,
+ * ph_ignore, and err fields.
+ */
+struct vfio_pci_tph_info {
+	/* in */
+	__u32 cpu_id;
+	__u32 cache_level;
+	__u8  flags;
+#define VFIO_TPH_MEM_TYPE_MASK		0x1
+#define VFIO_TPH_MEM_TYPE_SHIFT		0
+#define VFIO_TPH_MEM_TYPE_VMEM		0	/* Request volatile memory ST */
+#define VFIO_TPH_MEM_TYPE_PMEM		1	/* Request persistent memory ST */
+
+#define VFIO_TPH_HINT_MASK		0x3
+#define VFIO_TPH_HINT_SHIFT		1
+#define VFIO_TPH_HINT_BIDIR		0
+#define VFIO_TPH_HINT_REQSTR		(1 << VFIO_TPH_HINT_SHIFT)
+#define VFIO_TPH_HINT_TARGET		(2 << VFIO_TPH_HINT_SHIFT)
+#define VFIO_TPH_HINT_TARGET_PRIO	(3 << VFIO_TPH_HINT_SHIFT)
+	__u16 index;			/* MSI-X/ST-table index to set ST */
+	/* out */
+	__u16 st;			/* Steering-Tag */
+	__u8  ph_ignore;		/* Processing hint was ignored by */
+	__s32 err;			/* Error on getting/setting Steering-Tag*/
+};
+
+struct vfio_pci_tph {
+	__u32 argsz;			/* Size of vfio_pci_tph and info[] */
+	__u32 flags;
+#define VFIO_DEVICE_FEATURE_TPH_OP_MASK		0x7
+#define VFIO_DEVICE_FEATURE_TPH_OP_SHIFT	3
+#define VFIO_DEVICE_FEATURE_TPH_ENABLE		0	/* Enable TPH on device */
+#define VFIO_DEVICE_FEATURE_TPH_DISABLE	1	/* Disable TPH on device */
+#define VFIO_DEVICE_FEATURE_TPH_GET_ST		2	/* Get steering-tags */
+#define VFIO_DEVICE_FEATURE_TPH_SET_ST		4	/* Set steering-rags */
+
+#define	VFIO_TPH_ST_MODE_MASK	(0x3 << VFIO_DEVICE_FEATURE_TPH_OP_SHIFT)
+#define	VFIO_TPH_ST_NS_MODE	(0 << VFIO_DEVICE_FEATURE_TPH_OP_SHIFT)
+#define	VFIO_TPH_ST_IV_MODE	(1 << VFIO_DEVICE_FEATURE_TPH_OP_SHIFT)
+#define	VFIO_TPH_ST_DS_MODE	(2 << VFIO_DEVICE_FEATURE_TPH_OP_SHIFT)
+	__u32 count;				/* Number of entries in info[] */
+	struct vfio_pci_tph_info info[];
+#define VFIO_TPH_INFO_MAX	64		/* Max entries allowed in info[] */
+};
+
+#define VFIO_DEVICE_FEATURE_PCI_TPH 11
+
 /* -------- API for Type1 VFIO IOMMU -------- */
 
 /**
-- 
2.43.0


