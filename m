Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4B0B7A4120
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 08:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239884AbjIRG2z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 02:28:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239882AbjIRG2Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 02:28:25 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A19E121;
        Sun, 17 Sep 2023 23:28:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695018496; x=1726554496;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1PbplPb+kY7NA5Ye6l58CM/AmLov4qOiDxAqUc+MDUA=;
  b=P0mBf4ka5I3GBKpyrDEnlSYaW3g4ZX92lE/0N+poOI/d4jB08syLCOd4
   mlXNBuC/LYMj9MSf0lyow9QT0rqHHIAzWciw8Oea+ARYO8QLPYxAMIvjD
   F6K5x55hd1m1+2KAiRy3xNmKLdv5Ap1d3zrHCWyqnklqvRAhP7KFyBgUv
   NYYuF33bV4Ff5II/k3VAWmfFhoj+u6eeVL08K61km1sgaNV34F4YDdbzt
   HQXEXL7ErcKyPMtNAWbmvkorurxbjYqWA2MScbwXeQ35fpvHmmbQch/K3
   jfYWk6tB5GQh3pQ5YETWcKvqTQ0YH21lPaOsSfRLbHLeFLeP+2iVzuRe2
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10836"; a="378488540"
X-IronPort-AV: E=Sophos;i="6.02,155,1688454000"; 
   d="scan'208";a="378488540"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2023 23:28:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10836"; a="815893473"
X-IronPort-AV: E=Sophos;i="6.02,155,1688454000"; 
   d="scan'208";a="815893473"
Received: from dpdk-yahui-icx1.sh.intel.com ([10.67.111.186])
  by fmsmga004.fm.intel.com with ESMTP; 17 Sep 2023 23:28:11 -0700
From:   Yahui Cao <yahui.cao@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     kvm@vger.kernel.org, netdev@vger.kernel.org, lingyu.liu@intel.com,
        kevin.tian@intel.com, madhu.chittim@intel.com,
        sridhar.samudrala@intel.com, alex.williamson@redhat.com,
        jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, brett.creeley@amd.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com
Subject: [PATCH iwl-next v3 05/13] ice: Add fundamental migration init and exit function
Date:   Mon, 18 Sep 2023 06:25:38 +0000
Message-Id: <20230918062546.40419-6-yahui.cao@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230918062546.40419-1-yahui.cao@intel.com>
References: <20230918062546.40419-1-yahui.cao@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lingyu Liu <lingyu.liu@intel.com>

Add basic entry point for live migration functionality initialization,
uninitialization and add helper function for vfio driver to reach pf
driver data.

Signed-off-by: Lingyu Liu <lingyu.liu@intel.com>
Signed-off-by: Yahui Cao <yahui.cao@intel.com>
---
 drivers/net/ethernet/intel/ice/Makefile       |  3 +-
 drivers/net/ethernet/intel/ice/ice.h          |  3 +
 drivers/net/ethernet/intel/ice/ice_main.c     | 15 ++++
 .../net/ethernet/intel/ice/ice_migration.c    | 83 +++++++++++++++++++
 .../intel/ice/ice_migration_private.h         | 21 +++++
 drivers/net/ethernet/intel/ice/ice_vf_lib.c   |  4 +
 drivers/net/ethernet/intel/ice/ice_vf_lib.h   |  1 +
 include/linux/net/intel/ice_migration.h       | 25 ++++++
 8 files changed, 154 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_migration.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_migration_private.h
 create mode 100644 include/linux/net/intel/ice_migration.h

diff --git a/drivers/net/ethernet/intel/ice/Makefile b/drivers/net/ethernet/intel/ice/Makefile
index 18985da8ec49..e3a7af06235e 100644
--- a/drivers/net/ethernet/intel/ice/Makefile
+++ b/drivers/net/ethernet/intel/ice/Makefile
@@ -50,4 +50,5 @@ ice-$(CONFIG_DCB) += ice_dcb.o ice_dcb_nl.o ice_dcb_lib.o
 ice-$(CONFIG_RFS_ACCEL) += ice_arfs.o
 ice-$(CONFIG_XDP_SOCKETS) += ice_xsk.o
 ice-$(CONFIG_ICE_SWITCHDEV) += ice_eswitch.o ice_eswitch_br.o
-ice-$(CONFIG_GNSS) += ice_gnss.o
\ No newline at end of file
+ice-$(CONFIG_GNSS) += ice_gnss.o
+ice-$(CONFIG_ICE_VFIO_PCI) += ice_migration.o
diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 051007ccab43..837a89d3541c 100644
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
@@ -76,6 +77,7 @@
 #include "ice_vsi_vlan_ops.h"
 #include "ice_gnss.h"
 #include "ice_irq.h"
+#include "ice_migration_private.h"
 
 #define ICE_BAR0		0
 #define ICE_REQ_DESC_MULTIPLE	32
@@ -962,6 +964,7 @@ int ice_stop(struct net_device *netdev);
 void ice_service_task_schedule(struct ice_pf *pf);
 int ice_load(struct ice_pf *pf);
 void ice_unload(struct ice_pf *pf);
+struct ice_pf *ice_get_pf_from_vf_pdev(struct pci_dev *pdev);
 
 /**
  * ice_set_rdma_cap - enable RDMA support
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index a5997008bb98..b2031ee7acf8 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -9327,3 +9327,18 @@ static const struct net_device_ops ice_netdev_ops = {
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
index 000000000000..bd2248765750
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_migration.c
@@ -0,0 +1,83 @@
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
+
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
index 24e4f4d897b6..53d0f37fb65c 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
@@ -241,6 +241,10 @@ static void ice_vf_pre_vsi_rebuild(struct ice_vf *vf)
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
index ff1438373f69..351568d786a2 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.h
@@ -137,6 +137,7 @@ struct ice_vf {
 
 	/* devlink port data */
 	struct devlink_port devlink_port;
+	bool migration_enabled;
 };
 
 /* Flags for controlling behavior of ice_reset_vf */
diff --git a/include/linux/net/intel/ice_migration.h b/include/linux/net/intel/ice_migration.h
new file mode 100644
index 000000000000..d7228de7b02d
--- /dev/null
+++ b/include/linux/net/intel/ice_migration.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright (C) 2018-2023 Intel Corporation */
+
+#ifndef _ICE_MIGRATION_H_
+#define _ICE_MIGRATION_H_
+
+#if IS_ENABLED(CONFIG_ICE_VFIO_PCI)
+
+struct ice_pf;
+
+struct ice_pf *ice_migration_get_pf(struct pci_dev *pdev);
+int ice_migration_init_dev(struct ice_pf *pf, int vf_id);
+void ice_migration_uninit_dev(struct ice_pf *pf, int vf_id);
+
+#else
+static inline struct ice_pf *ice_migration_get_pf(struct pci_dev *pdev)
+{
+	return NULL;
+}
+
+static inline int ice_migration_init_dev(struct ice_pf *pf, int vf_id) { }
+static inline void ice_migration_uninit_dev(struct ice_pf *pf, int vf_id) { }
+#endif /* CONFIG_ICE_VFIO_PCI */
+
+#endif /* _ICE_MIGRATION_H_ */
-- 
2.34.1

