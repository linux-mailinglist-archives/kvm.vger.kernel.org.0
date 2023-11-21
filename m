Return-Path: <kvm+bounces-2145-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D4EB7F244C
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 03:50:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CD26F282407
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 02:50:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 452DB168AB;
	Tue, 21 Nov 2023 02:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H1Y/EjXg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C69BE8;
	Mon, 20 Nov 2023 18:50:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700535021; x=1732071021;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GEBquv8g8svvSh4MvuUqEVBc8Cbfc2Qs0nRwb8PM+JM=;
  b=H1Y/EjXgRxu1hoWwojREr9T3vkkT/AO/hTVANqDkQz7/VaTxD0MmGuwL
   pxj9IiuJ9Gk+G5BhmnwS2M+YNZBup+fg7uEv4bfsfB5LLRPxRE+Hydz/N
   6mUJ90anZJrS9SAzRM5p4VAgqTZcB5hAApuR1KMhJqIajQsh8kQcOGe/S
   D7kYPf5EqmnxTes6vwBiUASwUI6x9kHo2u31xgLajrjFA/X/5RJC9Zk/m
   VE20JQRcRL66D3pKWRf44Byc7mbWVWGClRQrunlkogoyVmFAWvVExE1or
   iEdaskTno+Nf1pAQ/qEvl52xTbufJgs0seVX4xgpftsGbu7iPG5hSXEiw
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10900"; a="458245942"
X-IronPort-AV: E=Sophos;i="6.04,215,1695711600"; 
   d="scan'208";a="458245942"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2023 18:50:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10900"; a="832488388"
X-IronPort-AV: E=Sophos;i="6.04,215,1695711600"; 
   d="scan'208";a="832488388"
Received: from dpdk-yahui-icx1.sh.intel.com ([10.67.111.85])
  by fmsmga008.fm.intel.com with ESMTP; 20 Nov 2023 18:49:58 -0800
From: Yahui Cao <yahui.cao@intel.com>
To: intel-wired-lan@lists.osuosl.org
Cc: kvm@vger.kernel.org,
	netdev@vger.kernel.org,
	lingyu.liu@intel.com,
	kevin.tian@intel.com,
	madhu.chittim@intel.com,
	sridhar.samudrala@intel.com,
	alex.williamson@redhat.com,
	jgg@nvidia.com,
	yishaih@nvidia.com,
	shameerali.kolothum.thodi@huawei.com,
	brett.creeley@amd.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com
Subject: [PATCH iwl-next v4 04/12] ice: Add fundamental migration init and exit function
Date: Tue, 21 Nov 2023 02:51:03 +0000
Message-Id: <20231121025111.257597-5-yahui.cao@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231121025111.257597-1-yahui.cao@intel.com>
References: <20231121025111.257597-1-yahui.cao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Lingyu Liu <lingyu.liu@intel.com>

Add basic entry point for live migration functionality initialization,
uninitialization and add helper function for vfio driver to reach pf
driver data.

Signed-off-by: Lingyu Liu <lingyu.liu@intel.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Signed-off-by: Yahui Cao <yahui.cao@intel.com>
---
 drivers/net/ethernet/intel/ice/Makefile       |  1 +
 drivers/net/ethernet/intel/ice/ice.h          |  3 +
 drivers/net/ethernet/intel/ice/ice_main.c     | 15 ++++
 .../net/ethernet/intel/ice/ice_migration.c    | 82 +++++++++++++++++++
 .../intel/ice/ice_migration_private.h         | 21 +++++
 drivers/net/ethernet/intel/ice/ice_vf_lib.c   |  4 +
 drivers/net/ethernet/intel/ice/ice_vf_lib.h   |  2 +
 include/linux/net/intel/ice_migration.h       | 27 ++++++
 8 files changed, 155 insertions(+)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_migration.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_migration_private.h
 create mode 100644 include/linux/net/intel/ice_migration.h

diff --git a/drivers/net/ethernet/intel/ice/Makefile b/drivers/net/ethernet/intel/ice/Makefile
index 0679907980f7..c536a9a896c0 100644
--- a/drivers/net/ethernet/intel/ice/Makefile
+++ b/drivers/net/ethernet/intel/ice/Makefile
@@ -49,3 +49,4 @@ ice-$(CONFIG_RFS_ACCEL) += ice_arfs.o
 ice-$(CONFIG_XDP_SOCKETS) += ice_xsk.o
 ice-$(CONFIG_ICE_SWITCHDEV) += ice_eswitch.o ice_eswitch_br.o
 ice-$(CONFIG_GNSS) += ice_gnss.o
+ice-$(CONFIG_ICE_VFIO_PCI) += ice_migration.o
diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 351e0d36df44..13f6ce51985c 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -55,6 +55,7 @@
 #include <net/vxlan.h>
 #include <net/gtp.h>
 #include <linux/ppp_defs.h>
+#include <linux/net/intel/ice_migration.h>
 #include "ice_devids.h"
 #include "ice_type.h"
 #include "ice_txrx.h"
@@ -77,6 +78,7 @@
 #include "ice_gnss.h"
 #include "ice_irq.h"
 #include "ice_dpll.h"
+#include "ice_migration_private.h"
 
 #define ICE_BAR0		0
 #define ICE_REQ_DESC_MULTIPLE	32
@@ -963,6 +965,7 @@ void ice_service_task_schedule(struct ice_pf *pf);
 int ice_load(struct ice_pf *pf);
 void ice_unload(struct ice_pf *pf);
 void ice_adv_lnk_speed_maps_init(void);
+struct ice_pf *ice_get_pf_from_vf_pdev(struct pci_dev *pdev);
 
 /**
  * ice_set_rdma_cap - enable RDMA support
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 6607fa6fe556..2daa4d2b1dd1 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -9313,3 +9313,18 @@ static const struct net_device_ops ice_netdev_ops = {
 	.ndo_xdp_xmit = ice_xdp_xmit,
 	.ndo_xsk_wakeup = ice_xsk_wakeup,
 };
+
+/**
+ * ice_get_pf_from_vf_pdev - Get PF structure from PCI device
+ * @pdev: pointer to PCI device
+ *
+ * Return pointer to ice PF structure, NULL for failure
+ */
+struct ice_pf *ice_get_pf_from_vf_pdev(struct pci_dev *pdev)
+{
+	struct ice_pf *pf;
+
+	pf = pci_iov_get_pf_drvdata(pdev, &ice_driver);
+
+	return !IS_ERR(pf) ? pf : NULL;
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_migration.c b/drivers/net/ethernet/intel/ice/ice_migration.c
new file mode 100644
index 000000000000..2b9b5a2ce367
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_migration.c
@@ -0,0 +1,82 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2018-2023 Intel Corporation */
+
+#include "ice.h"
+
+/**
+ * ice_migration_get_pf - Get ice PF structure pointer by pdev
+ * @pdev: pointer to ice vfio pci VF pdev structure
+ *
+ * Return nonzero for success, NULL for failure.
+ */
+struct ice_pf *ice_migration_get_pf(struct pci_dev *pdev)
+{
+	return ice_get_pf_from_vf_pdev(pdev);
+}
+EXPORT_SYMBOL(ice_migration_get_pf);
+
+/**
+ * ice_migration_init_vf - init ice VF device state data
+ * @vf: pointer to VF
+ */
+void ice_migration_init_vf(struct ice_vf *vf)
+{
+	vf->migration_enabled = true;
+}
+
+/**
+ * ice_migration_uninit_vf - uninit VF device state data
+ * @vf: pointer to VF
+ */
+void ice_migration_uninit_vf(struct ice_vf *vf)
+{
+	if (!vf->migration_enabled)
+		return;
+
+	vf->migration_enabled = false;
+}
+
+/**
+ * ice_migration_init_dev - init ice migration device
+ * @pf: pointer to PF of migration device
+ * @vf_id: VF index of migration device
+ *
+ * Return 0 for success, negative for failure
+ */
+int ice_migration_init_dev(struct ice_pf *pf, int vf_id)
+{
+	struct device *dev = ice_pf_to_dev(pf);
+	struct ice_vf *vf;
+
+	vf = ice_get_vf_by_id(pf, vf_id);
+	if (!vf) {
+		dev_err(dev, "Unable to locate VF from VF ID%d\n", vf_id);
+		return -EINVAL;
+	}
+
+	ice_migration_init_vf(vf);
+	ice_put_vf(vf);
+	return 0;
+}
+EXPORT_SYMBOL(ice_migration_init_dev);
+
+/**
+ * ice_migration_uninit_dev - uninit ice migration device
+ * @pf: pointer to PF of migration device
+ * @vf_id: VF index of migration device
+ */
+void ice_migration_uninit_dev(struct ice_pf *pf, int vf_id)
+{
+	struct device *dev = ice_pf_to_dev(pf);
+	struct ice_vf *vf;
+
+	vf = ice_get_vf_by_id(pf, vf_id);
+	if (!vf) {
+		dev_err(dev, "Unable to locate VF from VF ID%d\n", vf_id);
+		return;
+	}
+
+	ice_migration_uninit_vf(vf);
+	ice_put_vf(vf);
+}
+EXPORT_SYMBOL(ice_migration_uninit_dev);
diff --git a/drivers/net/ethernet/intel/ice/ice_migration_private.h b/drivers/net/ethernet/intel/ice/ice_migration_private.h
new file mode 100644
index 000000000000..2cc2f515fc5e
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_migration_private.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright (C) 2018-2023 Intel Corporation */
+
+#ifndef _ICE_MIGRATION_PRIVATE_H_
+#define _ICE_MIGRATION_PRIVATE_H_
+
+/* This header file is for exposing functions in ice_migration.c to
+ * files which will be compiled in ice.ko.
+ * Functions which may be used by other files which will be compiled
+ * in ice-vfio-pic.ko should be exposed as part of ice_migration.h.
+ */
+
+#if IS_ENABLED(CONFIG_ICE_VFIO_PCI)
+void ice_migration_init_vf(struct ice_vf *vf);
+void ice_migration_uninit_vf(struct ice_vf *vf);
+#else
+static inline void ice_migration_init_vf(struct ice_vf *vf) { }
+static inline void ice_migration_uninit_vf(struct ice_vf *vf) { }
+#endif /* CONFIG_ICE_VFIO_PCI */
+
+#endif /* _ICE_MIGRATION_PRIVATE_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.c b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
index aca1f2ea5034..8e571280831e 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
@@ -243,6 +243,10 @@ static void ice_vf_pre_vsi_rebuild(struct ice_vf *vf)
 	if (vf->vf_ops->irq_close)
 		vf->vf_ops->irq_close(vf);
 
+	if (vf->migration_enabled) {
+		ice_migration_uninit_vf(vf);
+		ice_migration_init_vf(vf);
+	}
 	ice_vf_clear_counters(vf);
 	vf->vf_ops->clear_reset_trigger(vf);
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.h b/drivers/net/ethernet/intel/ice/ice_vf_lib.h
index c7e7df7baf38..431fd28787e8 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.h
@@ -139,6 +139,8 @@ struct ice_vf {
 	struct devlink_port devlink_port;
 
 	u16 num_msix;			/* num of MSI-X configured on this VF */
+
+	u8 migration_enabled:1;
 };
 
 /* Flags for controlling behavior of ice_reset_vf */
diff --git a/include/linux/net/intel/ice_migration.h b/include/linux/net/intel/ice_migration.h
new file mode 100644
index 000000000000..7ea11a8714d6
--- /dev/null
+++ b/include/linux/net/intel/ice_migration.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright (C) 2018-2023 Intel Corporation */
+
+#ifndef _ICE_MIGRATION_H_
+#define _ICE_MIGRATION_H_
+
+struct ice_pf;
+
+#if IS_ENABLED(CONFIG_ICE_VFIO_PCI)
+struct ice_pf *ice_migration_get_pf(struct pci_dev *pdev);
+int ice_migration_init_dev(struct ice_pf *pf, int vf_id);
+void ice_migration_uninit_dev(struct ice_pf *pf, int vf_id);
+#else
+static inline struct ice_pf *ice_migration_get_pf(struct pci_dev *pdev)
+{
+	return NULL;
+}
+
+static inline int ice_migration_init_dev(struct ice_pf *pf, int vf_id)
+{
+	return 0;
+}
+
+static inline void ice_migration_uninit_dev(struct ice_pf *pf, int vf_id) { }
+#endif /* CONFIG_ICE_VFIO_PCI */
+
+#endif /* _ICE_MIGRATION_H_ */
-- 
2.34.1


