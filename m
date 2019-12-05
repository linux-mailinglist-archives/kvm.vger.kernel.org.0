Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8594E113A78
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2019 04:35:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729029AbfLEDfq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Dec 2019 22:35:46 -0500
Received: from mga05.intel.com ([192.55.52.43]:19480 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728374AbfLEDfq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Dec 2019 22:35:46 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Dec 2019 19:35:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,279,1571727600"; 
   d="scan'208";a="243095260"
Received: from joy-optiplex-7040.sh.intel.com ([10.239.13.9])
  by fmsmga002.fm.intel.com with ESMTP; 04 Dec 2019 19:35:43 -0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        libvir-list@redhat.com, qemu-devel@nongnu.org, cohuck@redhat.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        kevin.tian@intel.com, shaopeng.he@intel.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH 7/9] i40e/vf_migration: register mediate_ops to vfio-pci
Date:   Wed,  4 Dec 2019 22:27:29 -0500
Message-Id: <20191205032729.29936-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191205032419.29606-1-yan.y.zhao@intel.com>
References: <20191205032419.29606-1-yan.y.zhao@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

register to vfio-pci vfio_pci_mediate_ops when i40e binds to PF to
support mediating of VF's vfio-pci ops.
unregister vfio_pci_mediate_ops when i40e unbinds from PF.

vfio_pci_mediate_ops->open will return success if the device passed in
equals to devfn of its VFs

Cc: Shaopeng He <shaopeng.he@intel.com>

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 drivers/net/ethernet/intel/Kconfig            |   2 +-
 drivers/net/ethernet/intel/i40e/Makefile      |   3 +-
 drivers/net/ethernet/intel/i40e/i40e.h        |   2 +
 drivers/net/ethernet/intel/i40e/i40e_main.c   |   3 +
 .../ethernet/intel/i40e/i40e_vf_migration.c   | 169 ++++++++++++++++++
 .../ethernet/intel/i40e/i40e_vf_migration.h   |  52 ++++++
 6 files changed, 229 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/i40e/i40e_vf_migration.c
 create mode 100644 drivers/net/ethernet/intel/i40e/i40e_vf_migration.h

diff --git a/drivers/net/ethernet/intel/Kconfig b/drivers/net/ethernet/intel/Kconfig
index 154e2e818ec6..b5c7fdf55380 100644
--- a/drivers/net/ethernet/intel/Kconfig
+++ b/drivers/net/ethernet/intel/Kconfig
@@ -240,7 +240,7 @@ config IXGBEVF_IPSEC
 config I40E
 	tristate "Intel(R) Ethernet Controller XL710 Family support"
 	imply PTP_1588_CLOCK
-	depends on PCI
+	depends on PCI && VFIO_PCI
 	---help---
 	  This driver supports Intel(R) Ethernet Controller XL710 Family of
 	  devices.  For more information on how to identify your adapter, go
diff --git a/drivers/net/ethernet/intel/i40e/Makefile b/drivers/net/ethernet/intel/i40e/Makefile
index 2f21b3e89fd0..ae7a6a23dba9 100644
--- a/drivers/net/ethernet/intel/i40e/Makefile
+++ b/drivers/net/ethernet/intel/i40e/Makefile
@@ -24,6 +24,7 @@ i40e-objs := i40e_main.o \
 	i40e_ddp.o \
 	i40e_client.o   \
 	i40e_virtchnl_pf.o \
-	i40e_xsk.o
+	i40e_xsk.o	\
+	i40e_vf_migration.o
 
 i40e-$(CONFIG_I40E_DCB) += i40e_dcb.o i40e_dcb_nl.o
diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index 2af9f6308f84..0141c94b835f 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -1162,4 +1162,6 @@ int i40e_add_del_cloud_filter(struct i40e_vsi *vsi,
 int i40e_add_del_cloud_filter_big_buf(struct i40e_vsi *vsi,
 				      struct i40e_cloud_filter *filter,
 				      bool add);
+int i40e_vf_migration_register(void);
+void i40e_vf_migration_unregister(void);
 #endif /* _I40E_H_ */
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 6031223eafab..92d1c3fdc808 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -15274,6 +15274,7 @@ static int i40e_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* print a string summarizing features */
 	i40e_print_features(pf);
 
+	i40e_vf_migration_register();
 	return 0;
 
 	/* Unwind what we've done if something failed in the setup */
@@ -15320,6 +15321,8 @@ static void i40e_remove(struct pci_dev *pdev)
 	i40e_status ret_code;
 	int i;
 
+	i40e_vf_migration_unregister();
+
 	i40e_dbg_pf_exit(pf);
 
 	i40e_ptp_stop(pf);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_vf_migration.c b/drivers/net/ethernet/intel/i40e/i40e_vf_migration.c
new file mode 100644
index 000000000000..b2d913459600
--- /dev/null
+++ b/drivers/net/ethernet/intel/i40e/i40e_vf_migration.c
@@ -0,0 +1,169 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2013 - 2019 Intel Corporation. */
+
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/vfio.h>
+#include <linux/pci.h>
+#include <linux/eventfd.h>
+
+#include "i40e.h"
+#include "i40e_vf_migration.h"
+
+static long open_device_bits[MAX_OPEN_DEVICE / BITS_PER_LONG + 1];
+static DEFINE_MUTEX(device_bit_lock);
+static struct i40e_vf_migration *i40e_vf_dev_array[MAX_OPEN_DEVICE];
+
+int i40e_vf_migration_open(struct pci_dev *pdev, u64 *caps, u32 *dm_handle)
+{
+	int i, ret = 0;
+	struct i40e_vf_migration *i40e_vf_dev = NULL;
+	int handle;
+	struct pci_dev *pf_dev, *vf_dev;
+	struct i40e_pf *pf;
+	struct i40e_vf *vf;
+	unsigned int vf_devfn, devfn;
+	int vf_id = -1;
+
+	if (!try_module_get(THIS_MODULE))
+		return -ENODEV;
+
+	pf_dev = pdev->physfn;
+	pf = pci_get_drvdata(pf_dev);
+	vf_dev = pdev;
+	vf_devfn = vf_dev->devfn;
+
+	for (i = 0; i < pci_num_vf(pf_dev); i++) {
+		devfn = (pf_dev->devfn + pf_dev->sriov->offset +
+			 pf_dev->sriov->stride * i) & 0xff;
+		if (devfn == vf_devfn) {
+			vf_id = i;
+			break;
+		}
+	}
+
+	if (vf_id == -1) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	mutex_lock(&device_bit_lock);
+	handle = find_next_zero_bit(open_device_bits, MAX_OPEN_DEVICE, 0);
+	if (handle >= MAX_OPEN_DEVICE) {
+		ret = -EBUSY;
+		goto error;
+	}
+
+	i40e_vf_dev = kzalloc(sizeof(*i40e_vf_dev), GFP_KERNEL);
+
+	if (!i40e_vf_dev) {
+		ret = -ENOMEM;
+		goto error;
+	}
+
+	i40e_vf_dev->vf_id = vf_id;
+	i40e_vf_dev->vf_vendor = pdev->vendor;
+	i40e_vf_dev->vf_device = pdev->device;
+	i40e_vf_dev->pf_dev = pf_dev;
+	i40e_vf_dev->vf_dev = vf_dev;
+	i40e_vf_dev->handle = handle;
+
+	pr_info("%s: device %x %x, vf id %d, handle=%x\n",
+		__func__, pdev->vendor, pdev->device, vf_id, handle);
+
+	i40e_vf_dev_array[handle] = i40e_vf_dev;
+	set_bit(handle, open_device_bits);
+	vf = &pf->vf[vf_id];
+	*dm_handle = handle;
+error:
+	mutex_unlock(&device_bit_lock);
+
+	if (ret < 0) {
+		module_put(THIS_MODULE);
+		kfree(i40e_vf_dev);
+	}
+
+out:
+	return ret;
+}
+
+void i40e_vf_migration_release(int handle)
+{
+	struct i40e_vf_migration *i40e_vf_dev;
+
+	mutex_lock(&device_bit_lock);
+
+	if (handle >= MAX_OPEN_DEVICE ||
+	    !i40e_vf_dev_array[handle] ||
+	    !test_bit(handle, open_device_bits)) {
+		pr_err("handle mismatch, please check interaction with vfio-pci module\n");
+		mutex_unlock(&device_bit_lock);
+		return;
+	}
+
+	i40e_vf_dev = i40e_vf_dev_array[handle];
+	i40e_vf_dev_array[handle] = NULL;
+
+	clear_bit(handle, open_device_bits);
+	mutex_unlock(&device_bit_lock);
+
+	pr_info("%s: handle=%d, i40e_vf_dev VID DID =%x %x, vf id=%d\n",
+		__func__, handle,
+		i40e_vf_dev->vf_vendor, i40e_vf_dev->vf_device,
+		i40e_vf_dev->vf_id);
+
+	kfree(i40e_vf_dev);
+	module_put(THIS_MODULE);
+}
+
+static void
+i40e_vf_migration_get_region_info(int handle,
+				  struct vfio_region_info *info,
+				  struct vfio_info_cap *caps,
+				  struct vfio_region_info_cap_type *cap_type)
+{
+}
+
+static ssize_t i40e_vf_migration_rw(int handle, char __user *buf,
+				    size_t count, loff_t *ppos,
+				    bool iswrite, bool *pt)
+{
+	*pt = true;
+
+	return 0;
+}
+
+static int i40e_vf_migration_mmap(int handle, struct vm_area_struct *vma,
+				  bool *pt)
+{
+	*pt = true;
+	return 0;
+}
+
+static struct vfio_pci_mediate_ops i40e_vf_migration_ops = {
+	.name = "i40e_vf",
+	.open = i40e_vf_migration_open,
+	.release = i40e_vf_migration_release,
+	.get_region_info = i40e_vf_migration_get_region_info,
+	.rw = i40e_vf_migration_rw,
+	.mmap = i40e_vf_migration_mmap,
+};
+
+int i40e_vf_migration_register(void)
+{
+	int ret = 0;
+
+	pr_info("%s\n", __func__);
+
+	memset(open_device_bits, 0, sizeof(open_device_bits));
+	memset(i40e_vf_dev_array, 0, sizeof(i40e_vf_dev_array));
+	vfio_pci_register_mediate_ops(&i40e_vf_migration_ops);
+
+	return ret;
+}
+
+void i40e_vf_migration_unregister(void)
+{
+	pr_info("%s\n", __func__);
+	vfio_pci_unregister_mediate_ops(&i40e_vf_migration_ops);
+}
diff --git a/drivers/net/ethernet/intel/i40e/i40e_vf_migration.h b/drivers/net/ethernet/intel/i40e/i40e_vf_migration.h
new file mode 100644
index 000000000000..b195399b6788
--- /dev/null
+++ b/drivers/net/ethernet/intel/i40e/i40e_vf_migration.h
@@ -0,0 +1,52 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2013 - 2019 Intel Corporation. */
+
+#ifndef I40E_MIG_H
+#define I40E_MIG_H
+
+#include <linux/pci.h>
+#include <linux/vfio.h>
+#include <linux/mdev.h>
+
+#include "i40e.h"
+#include "i40e_txrx.h"
+
+#define MAX_OPEN_DEVICE 1024
+
+/* Single Root I/O Virtualization */
+struct pci_sriov {
+	int		pos;		/* Capability position */
+	int		nres;		/* Number of resources */
+	u32		cap;		/* SR-IOV Capabilities */
+	u16		ctrl;		/* SR-IOV Control */
+	u16		total_VFs;	/* Total VFs associated with the PF */
+	u16		initial_VFs;	/* Initial VFs associated with the PF */
+	u16		num_VFs;	/* Number of VFs available */
+	u16		offset;		/* First VF Routing ID offset */
+	u16		stride;		/* Following VF stride */
+	u16		vf_device;	/* VF device ID */
+	u32		pgsz;		/* Page size for BAR alignment */
+	u8		link;		/* Function Dependency Link */
+	u8		max_VF_buses;	/* Max buses consumed by VFs */
+	u16		driver_max_VFs;	/* Max num VFs driver supports */
+	struct pci_dev	*dev;		/* Lowest numbered PF */
+	struct pci_dev	*self;		/* This PF */
+	u32		cfg_size;	/* VF config space size */
+	u32		class;		/* VF device */
+	u8		hdr_type;	/* VF header type */
+	u16		subsystem_vendor; /* VF subsystem vendor */
+	u16		subsystem_device; /* VF subsystem device */
+	resource_size_t	barsz[PCI_SRIOV_NUM_BARS];	/* VF BAR size */
+	bool		drivers_autoprobe; /* Auto probing of VFs by driver */
+};
+
+struct i40e_vf_migration {
+	__u32 vf_vendor;
+	__u32 vf_device;
+	__u32 handle;
+	struct pci_dev *pf_dev;
+	struct pci_dev *vf_dev;
+	int vf_id;
+};
+#endif /* I40E_MIG_H */
+
-- 
2.17.1

