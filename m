Return-Path: <kvm+bounces-57773-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 29793B59FD7
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 19:57:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 938591C05315
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 17:57:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EC712C2353;
	Tue, 16 Sep 2025 17:56:39 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 968EB26A1CF
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 17:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758045399; cv=none; b=tujrHzwKrTP4qESaxi/ZjG4SoC55bOuPXp88/4hHVyqANhG53/5q1J99Lyd5fPQBuOsHU1Z4NQPDvvSHgrGYtO+9TulwN/THVzbs07tgh93RO7a2Dj3JU3jG4p+a6CVgr9NVf+8+/oIlnN1lMfxjKGPR73+2pB7mfbTQNHDhuug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758045399; c=relaxed/simple;
	bh=aBxLoFgtwWxdDCPRz4eLkDMzZPHU7iSbIBLxiGnSocE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qWS02wlc8Nr0zrvJp2CiH2vi4CPSYGdJISLJGEK8OXEAG/L1azagIh0syqBOk6dN8898isHV+8uBZmuxiic+RAKl9eSPzKgex/uWslPI0NXN9K09tGSML1OgUGc1gCSGk3iSUrmxJN5aWPjg16mikCIk23Hn6f7RCEawt44PWtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5860D12FC;
	Tue, 16 Sep 2025 10:56:27 -0700 (PDT)
Received: from ampere-altra-2-1.usa.arm.com (ampere-altra-2-1.usa.arm.com [10.118.91.158])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id DF1373F673;
	Tue, 16 Sep 2025 10:56:34 -0700 (PDT)
From: Wathsala Vithanage <wathsala.vithanage@arm.com>
To: jgg@ziepe.ca,
	alex.williamson@redhat.com,
	pstanner@redhat.com,
	jeremy.linton@arm.com
Cc: kvm@vger.kernel.org,
	Wathsala Vithanage <wathsala.vithanage@arm.com>
Subject: [RFC PATCH v3 1/1] vfio/pci: add PCIe TPH device ioctl
Date: Tue, 16 Sep 2025 17:56:26 +0000
Message-ID: <20250916175626.698384-1-wathsala.vithanage@arm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch introduces VFIO_DEVICE_PCI_TPH IOCTL to enable configuring of
TPH from the user space. It provides an interface to user space drivers
and VMMs to enable/disable TPH capability on PCIe devices and set
steering tags in MSI-X or steering-tag table entries or read steering
tags from the kernel to use them in device-specific mode.

Signed-off-by: Wathsala Vithanage <wathsala.vithanage@arm.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 153 +++++++++++++++++++++++++++++++
 include/uapi/linux/vfio.h        |  83 +++++++++++++++++
 2 files changed, 236 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 7dcf5439dedc..cc9ba6760862 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -28,6 +28,7 @@
 #include <linux/nospec.h>
 #include <linux/sched/mm.h>
 #include <linux/iommufd.h>
+#include <linux/pci-tph.h>
 #if IS_ENABLED(CONFIG_EEH)
 #include <asm/eeh.h>
 #endif
@@ -1443,6 +1444,156 @@ static int vfio_pci_ioctl_ioeventfd(struct vfio_pci_core_device *vdev,
 				  ioeventfd.fd);
 }
 
+static struct vfio_pci_tph_entry *vfio_pci_tph_get_ents(struct vfio_pci_tph *tph,
+							void __user *tph_ents,
+							size_t *ents_size)
+{
+	unsigned long minsz;
+	size_t size;
+
+	if (!ents_size)
+		return ERR_PTR(-EINVAL);
+
+	minsz = offsetofend(struct vfio_pci_tph, count);
+
+	size = tph->count * sizeof(struct vfio_pci_tph_entry);
+
+	if (tph->argsz - minsz < size)
+		return ERR_PTR(-EINVAL);
+
+	*ents_size = size;
+
+	return memdup_user(tph_ents, size);
+}
+
+static int vfio_pci_tph_set_st(struct vfio_pci_core_device *vdev,
+			       struct vfio_pci_tph_entry *ents, int count)
+{
+	int i, err = 0;
+
+	for (i = 0; i < count && !err; i++)
+		err = pcie_tph_set_st_entry(vdev->pdev, ents[i].index,
+					    ents[i].st);
+
+	return err;
+}
+
+static int vfio_pci_tph_get_st(struct vfio_pci_core_device *vdev,
+			       struct vfio_pci_tph_entry *ents, int count)
+{
+	int i, mtype, err = 0;
+	u32 cpu_uid;
+
+	for (i = 0; i < count && !err; i++) {
+		if (ents[i].cpu_id >= nr_cpu_ids || !cpu_present(ents[i].cpu_id)) {
+			err = -EINVAL;
+			break;
+		}
+
+		cpu_uid = topology_core_id(ents[i].cpu_id);
+		mtype = (ents[i].flags & VFIO_TPH_MEM_TYPE_MASK) >>
+			VFIO_TPH_MEM_TYPE_SHIFT;
+
+		/*
+		 * ph_ignore is always set.
+		 * TPH implementation of the PCI subsystem forces processing
+		 * hint to bi-directional by setting PH bits to 0 when
+		 * acquiring Steering Tags from the platform firmware. It also
+		 * discards the ph_ignore bit returned by firmware.
+		 */
+		ents[i].ph_ignore = 1;
+
+		err = pcie_tph_get_cpu_st(vdev->pdev, mtype, cpu_uid,
+					  &ents[i].st);
+	}
+
+	return err;
+}
+
+static int vfio_pci_tph_st_op(struct vfio_pci_core_device *vdev,
+			      struct vfio_pci_tph *tph, void __user *tph_ents)
+{
+	int err = 0;
+	struct vfio_pci_tph_entry *ents;
+	size_t ents_size;
+
+	if (!tph->count || tph->count > VFIO_TPH_INFO_MAX) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	ents = vfio_pci_tph_get_ents(tph, tph_ents, &ents_size);
+	if (IS_ERR(ents)) {
+		err = PTR_ERR(ents);
+		goto out;
+	}
+
+	err = vfio_pci_tph_get_st(vdev, ents, tph->count);
+	if (err)
+		goto out_free_ents;
+
+	/*
+	 * Set Steering tags. TPH will be disabled on the device by the PCI
+	 * subsystem if there is an error.
+	 */
+	if (tph->flags & VFIO_DEVICE_TPH_SET_ST) {
+		err = vfio_pci_tph_set_st(vdev, ents, tph->count);
+		if (err)
+			goto out_free_ents;
+	}
+
+	if (copy_to_user(tph_ents, ents, ents_size))
+		err = -EFAULT;
+
+out_free_ents:
+	kfree(ents);
+out:
+	return err;
+}
+
+static int vfio_pci_tph_enable(struct vfio_pci_core_device *vdev,
+			       struct vfio_pci_tph *arg)
+{
+	return pcie_enable_tph(vdev->pdev, arg->flags & VFIO_TPH_ST_MODE_MASK);
+}
+
+static int vfio_pci_tph_disable(struct vfio_pci_core_device *vdev)
+{
+	pcie_disable_tph(vdev->pdev);
+	return 0;
+}
+
+static int vfio_pci_ioctl_tph(struct vfio_pci_core_device *vdev,
+			      void __user *uarg)
+{
+	u32 op;
+	struct vfio_pci_tph tph;
+	size_t minsz = offsetofend(struct vfio_pci_tph, count);
+
+	if (copy_from_user(&tph, uarg, minsz))
+		return -EFAULT;
+
+	if (tph.argsz < minsz)
+		return -EINVAL;
+
+	op = tph.flags & VFIO_DEVICE_TPH_OP_MASK;
+
+	switch (op) {
+	case VFIO_DEVICE_TPH_ENABLE:
+		return vfio_pci_tph_enable(vdev, &tph);
+
+	case VFIO_DEVICE_TPH_DISABLE:
+		return vfio_pci_tph_disable(vdev);
+
+	case VFIO_DEVICE_TPH_GET_ST:
+	case VFIO_DEVICE_TPH_SET_ST:
+		return vfio_pci_tph_st_op(vdev, &tph, (u8 *)(uarg) + minsz);
+
+	default:
+		return -EINVAL;
+	}
+}
+
 long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 			 unsigned long arg)
 {
@@ -1467,6 +1618,8 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 		return vfio_pci_ioctl_reset(vdev, uarg);
 	case VFIO_DEVICE_SET_IRQS:
 		return vfio_pci_ioctl_set_irqs(vdev, uarg);
+	case VFIO_DEVICE_PCI_TPH:
+		return vfio_pci_ioctl_tph(vdev, uarg);
 	default:
 		return -ENOTTY;
 	}
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 75100bf009ba..a642a2ff21a6 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -873,6 +873,88 @@ struct vfio_device_ioeventfd {
 
 #define VFIO_DEVICE_IOEVENTFD		_IO(VFIO_TYPE, VFIO_BASE + 16)
 
+/**
+ * VFIO_DEVICE_PCI_TPH	- _IO(VFIO_TYPE, VFIO_BASE + 22)
+ *
+ * This command is used to control PCIe TLP Processing Hints (TPH)
+ * capability in a PCIe device.
+ * It supports following operations on a PCIe device with respect to TPH
+ * capability.
+ *
+ * - Enabling/disabling TPH capability in a PCIe device.
+ *
+ *   Setting VFIO_DEVICE_TPH_ENABLE flag enables TPH in no-steering-tag,
+ *   interrupt-vector, or device-specific mode defined in the PCIe specficiation
+ *   when feature flags TPH_ST_NS_MODE, TPH_ST_IV_MODE, and TPH_ST_DS_MODE are
+ *   set respectively. TPH_ST_xx_MODE macros are defined in
+ *   uapi/linux/pci_regs.h.
+ *
+ *   VFIO_DEVICE_TPH_DISABLE disables PCIe TPH on the device.
+ *
+ * - Writing STs to MSI-X or ST table in a PCIe device.
+ *
+ *   VFIO_DEVICE_TPH_SET_ST flag set steering tags on a device at an index in
+ *   MSI-X or ST-table depending on the VFIO_TPH_ST_x_MODE flag used and
+ *   returns the programmed steering tag values. The caller can set one or more
+ *   steering tags by passing an array of vfio_pci_tph_entry objects containing
+ *   cpu_id, cache_level, and MSI-X/ST-table index. The caller can also set the
+ *   intended memory type and the processing hint by setting VFIO_TPH_MEM_TYPE_x
+ *   and VFIO_TPH_HINT_x flags, respectively.
+ *
+ * - Reading Steering Tags (ST) from the host platform.
+ *
+ *   VFIO_DEVICE_TPH_GET_ST flags returns steering tags to the caller. Caller
+ *   can request one or more steering tags by passing an array of
+ *   vfio_pci_tph_entry objects. Steering Tag for each request is returned via
+ *   the st field in vfio_pci_tph_entry.
+ */
+struct vfio_pci_tph_entry {
+	/* in */
+	__u32 cpu_id;			/* CPU logical ID */
+	__u32 cache_level;		/* Cache level. L1 D= 0, L2D = 2, ...*/
+	__u8  flags;
+#define VFIO_TPH_MEM_TYPE_MASK		0x1
+#define VFIO_TPH_MEM_TYPE_SHIFT		0
+#define VFIO_TPH_MEM_TYPE_VMEM		0   /* Request volatile memory ST */
+#define VFIO_TPH_MEM_TYPE_PMEM		1   /* Request persistent memory ST */
+
+#define VFIO_TPH_HINT_SHIFT		1
+#define VFIO_TPH_HINT_MASK		(0x3 << VFIO_TPH_HINT_SHIFT)
+#define VFIO_TPH_HINT_BIDIR		0
+#define VFIO_TPH_HINT_REQSTR		(1 << VFIO_TPH_HINT_SHIFT)
+#define VFIO_TPH_HINT_TARGET		(2 << VFIO_TPH_HINT_SHIFT)
+#define VFIO_TPH_HINT_TARGET_PRIO	(3 << VFIO_TPH_HINT_SHIFT)
+	__u8  pad0;
+	__u16 index;			/* MSI-X/ST-table index to set ST */
+	/* out */
+	__u16 st;			/* Steering-Tag */
+	__u8  ph_ignore;		/* Platform ignored the Processing */
+	__u8  pad1;
+};
+
+struct vfio_pci_tph {
+	__u32 argsz;			/* Size of vfio_pci_tph and ents[] */
+	__u32 flags;
+#define VFIO_TPH_ST_MODE_MASK		0x7
+
+#define VFIO_DEVICE_TPH_OP_SHIFT	3
+#define VFIO_DEVICE_TPH_OP_MASK		(0x7 << VFIO_DEVICE_TPH_OP_SHIFT)
+/* Enable TPH on device */
+#define VFIO_DEVICE_TPH_ENABLE		0
+/* Disable TPH on device */
+#define VFIO_DEVICE_TPH_DISABLE		(1 << VFIO_DEVICE_TPH_OP_SHIFT)
+/* Get steering-tags */
+#define VFIO_DEVICE_TPH_GET_ST		(2 << VFIO_DEVICE_TPH_OP_SHIFT)
+/* Set steering-tags */
+#define VFIO_DEVICE_TPH_SET_ST		(4 << VFIO_DEVICE_TPH_OP_SHIFT)
+	__u32 count;			/* Number of entries in ents[] */
+	struct vfio_pci_tph_entry ents[];
+#define VFIO_TPH_INFO_MAX	2048	/* Max entries in ents[] */
+};
+
+#define VFIO_DEVICE_PCI_TPH	_IO(VFIO_TYPE, VFIO_BASE + 22)
+
+
 /**
  * VFIO_DEVICE_FEATURE - _IOWR(VFIO_TYPE, VFIO_BASE + 17,
  *			       struct vfio_device_feature)
@@ -1478,6 +1560,7 @@ struct vfio_device_feature_bus_master {
 };
 #define VFIO_DEVICE_FEATURE_BUS_MASTER 10
 
+
 /* -------- API for Type1 VFIO IOMMU -------- */
 
 /**
-- 
2.43.0


