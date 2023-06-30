Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE19743C81
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 15:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232489AbjF3NST (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 09:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbjF3NSQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 09:18:16 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AAA83A98;
        Fri, 30 Jun 2023 06:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688131095; x=1719667095;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=IIEzl2tUVV0YR005Rqh3p9QDKnnXWwlFug01Qzej7Qk=;
  b=UP+jvDrt88qm1GQ39jLt/+UlkUUTNTzSulzghSVaJrUXqDC7vQFejVAE
   nj+8E6Mlgy4iVSBv83EIHHC/2hvKQyj8A9l8OUlhUi7TEIHTmGWENzGhZ
   u3X/q1Y0DN8BlamcgOaKKOe/jBGa38dQGTA7GJdDQDe2R94Ne3ISECavW
   gbRragu6t0fncMKR1GMF27U6cwREC7sr1jRNWGL+vJeXS8AA5ndbKjym+
   nNj4JWB7Q4Mm4E2lLzPRcXeQjfWmuSXUB2sgMAEk5rqTlIIE3fifjotE4
   K699h8V71RO77yWL1sC9qPOQ4bhFheLktTxntVWbmOaoDnFgBbp7qf+ND
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10756"; a="362433149"
X-IronPort-AV: E=Sophos;i="6.01,170,1684825200"; 
   d="scan'208";a="362433149"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2023 06:18:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10756"; a="783077944"
X-IronPort-AV: E=Sophos;i="6.01,170,1684825200"; 
   d="scan'208";a="783077944"
Received: from qat-server-archercity1.sh.intel.com ([10.67.111.115])
  by fmsmga008.fm.intel.com with ESMTP; 30 Jun 2023 06:18:11 -0700
From:   Xin Zeng <xin.zeng@intel.com>
To:     linux-crypto@vger.kernel.org, kvm@vger.kernel.org
Cc:     giovanni.cabiddu@intel.com, andriy.shevchenko@linux.intel.com,
        Xin Zeng <xin.zeng@intel.com>, Yahui Cao <yahui.cao@intel.com>
Subject: [RFC 2/5] crypto: qat - add interface for live migration
Date:   Fri, 30 Jun 2023 21:13:01 +0800
Message-Id: <20230630131304.64243-3-xin.zeng@intel.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20230630131304.64243-1-xin.zeng@intel.com>
References: <20230630131304.64243-1-xin.zeng@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Extend the driver with a new interface to be used for VF live migration.
This will be called by the QAT extension in vfio-pci.

Co-developed-by: Yahui Cao <yahui.cao@intel.com>
Signed-off-by: Yahui Cao <yahui.cao@intel.com>
Signed-off-by: Xin Zeng <xin.zeng@intel.com>
---
 drivers/crypto/intel/qat/qat_common/Makefile  |   2 +-
 .../intel/qat/qat_common/adf_accel_devices.h  |  13 +++
 .../crypto/intel/qat/qat_common/qat_vf_mig.c  | 106 ++++++++++++++++++
 include/linux/qat/qat_vf_mig.h                |  15 +++
 4 files changed, 135 insertions(+), 1 deletion(-)
 create mode 100644 drivers/crypto/intel/qat/qat_common/qat_vf_mig.c
 create mode 100644 include/linux/qat/qat_vf_mig.h

diff --git a/drivers/crypto/intel/qat/qat_common/Makefile b/drivers/crypto/intel/qat/qat_common/Makefile
index 38de3aba6e8c..3855f2fa5733 100644
--- a/drivers/crypto/intel/qat/qat_common/Makefile
+++ b/drivers/crypto/intel/qat/qat_common/Makefile
@@ -33,4 +33,4 @@ intel_qat-$(CONFIG_DEBUG_FS) += adf_transport_debug.o \
 intel_qat-$(CONFIG_PCI_IOV) += adf_sriov.o adf_vf_isr.o adf_pfvf_utils.o \
 			       adf_pfvf_pf_msg.o adf_pfvf_pf_proto.o \
 			       adf_pfvf_vf_msg.o adf_pfvf_vf_proto.o \
-			       adf_gen2_pfvf.o adf_gen4_pfvf.o
+			       adf_gen2_pfvf.o adf_gen4_pfvf.o qat_vf_mig.o
diff --git a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
index 7fc2fd042916..adda2cac6af1 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
@@ -217,6 +217,17 @@ struct adf_dc_ops {
 	void (*build_deflate_ctx)(void *ctx);
 };
 
+struct adf_vfmig_ops {
+	int (*init_device)(struct adf_accel_dev *accel_dev, u32 vf_nr);
+	void (*shutdown_device)(struct adf_accel_dev *accel_dev, u32 vf_nr);
+	int (*save_state)(struct adf_accel_dev *accel_dev, u32 vf_nr,
+			  u8 *buf, u64 buf_sz);
+	int (*load_state)(struct adf_accel_dev *accel_dev, u32 vf_nr,
+			  u8 *buf, u64 buf_sz);
+	int (*suspend_device)(struct adf_accel_dev *accel_dev, u32 vf_nr);
+	int (*resume_device)(struct adf_accel_dev *accel_dev, u32 vf_nr);
+};
+
 struct adf_hw_device_data {
 	struct adf_hw_device_class *dev_class;
 	u32 (*get_accel_mask)(struct adf_hw_device_data *self);
@@ -263,6 +274,7 @@ struct adf_hw_device_data {
 	struct adf_hw_csr_info csr_info;
 	struct adf_pfvf_ops pfvf_ops;
 	struct adf_dc_ops dc_ops;
+	struct adf_vfmig_ops vfmig_ops;
 	const char *fw_name;
 	const char *fw_mmp_name;
 	u32 fuses;
@@ -309,6 +321,7 @@ struct adf_hw_device_data {
 #define GET_CSR_OPS(accel_dev) (&(accel_dev)->hw_device->csr_info.csr_ops)
 #define GET_PFVF_OPS(accel_dev) (&(accel_dev)->hw_device->pfvf_ops)
 #define GET_DC_OPS(accel_dev) (&(accel_dev)->hw_device->dc_ops)
+#define GET_VFMIG_OPS(accel_dev) (&(accel_dev)->hw_device->vfmig_ops)
 #define accel_to_pci_dev(accel_ptr) accel_ptr->accel_pci_dev.pci_dev
 
 struct adf_admin_comms;
diff --git a/drivers/crypto/intel/qat/qat_common/qat_vf_mig.c b/drivers/crypto/intel/qat/qat_common/qat_vf_mig.c
new file mode 100644
index 000000000000..1fb86952c9ac
--- /dev/null
+++ b/drivers/crypto/intel/qat/qat_common/qat_vf_mig.c
@@ -0,0 +1,106 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(c) 2023 Intel Corporation */
+
+#include <linux/bug.h>
+#include <linux/dev_printk.h>
+#include <linux/export.h>
+#include <linux/pci.h>
+#include <linux/types.h>
+#include <linux/qat/qat_vf_mig.h>
+#include "adf_common_drv.h"
+
+int qat_vfmig_init_device(struct pci_dev *pdev, u32 vf_nr)
+{
+	struct adf_accel_dev *accel_dev = adf_devmgr_pci_to_accel_dev(pdev);
+
+	if (!accel_dev) {
+		dev_err(&pdev->dev, "Failed to find accel_dev\n");
+		return -ENODEV;
+	}
+
+	if (WARN_ON(!GET_VFMIG_OPS(accel_dev)->init_device))
+		return -EINVAL;
+
+	return GET_VFMIG_OPS(accel_dev)->init_device(accel_dev, vf_nr);
+}
+EXPORT_SYMBOL_GPL(qat_vfmig_init_device);
+
+void qat_vfmig_shutdown_device(struct pci_dev *pdev, u32 vf_nr)
+{
+	struct adf_accel_dev *accel_dev = adf_devmgr_pci_to_accel_dev(pdev);
+
+	if (!accel_dev) {
+		dev_err(&pdev->dev, "Failed to find accel_dev\n");
+		return;
+	}
+
+	if (WARN_ON(!GET_VFMIG_OPS(accel_dev)->shutdown_device))
+		return;
+
+	GET_VFMIG_OPS(accel_dev)->shutdown_device(accel_dev, vf_nr);
+}
+EXPORT_SYMBOL_GPL(qat_vfmig_shutdown_device);
+
+int qat_vfmig_suspend_device(struct pci_dev *pdev, u32 vf_nr)
+{
+	struct adf_accel_dev *accel_dev = adf_devmgr_pci_to_accel_dev(pdev);
+
+	if (!accel_dev) {
+		dev_err(&pdev->dev, "Failed to find accel_dev\n");
+		return -ENODEV;
+	}
+
+	if (WARN_ON(!GET_VFMIG_OPS(accel_dev)->suspend_device))
+		return -EINVAL;
+
+	return GET_VFMIG_OPS(accel_dev)->suspend_device(accel_dev, vf_nr);
+}
+EXPORT_SYMBOL_GPL(qat_vfmig_suspend_device);
+
+int qat_vfmig_resume_device(struct pci_dev *pdev, u32 vf_nr)
+{
+	struct adf_accel_dev *accel_dev = adf_devmgr_pci_to_accel_dev(pdev);
+
+	if (!accel_dev) {
+		dev_err(&pdev->dev, "Failed to find accel_dev\n");
+		return -ENODEV;
+	}
+
+	if (WARN_ON(!GET_VFMIG_OPS(accel_dev)->resume_device))
+		return -EINVAL;
+
+	return GET_VFMIG_OPS(accel_dev)->resume_device(accel_dev, vf_nr);
+}
+EXPORT_SYMBOL_GPL(qat_vfmig_resume_device);
+
+int qat_vfmig_save_state(struct pci_dev *pdev, u32 vf_nr, u8 *buf, u64 buf_sz)
+{
+	struct adf_accel_dev *accel_dev = adf_devmgr_pci_to_accel_dev(pdev);
+
+	if (!accel_dev) {
+		dev_err(&pdev->dev, "Failed to find accel_dev\n");
+		return -ENODEV;
+	}
+
+	if (WARN_ON(!GET_VFMIG_OPS(accel_dev)->save_state))
+		return -EINVAL;
+
+	return GET_VFMIG_OPS(accel_dev)->save_state(accel_dev, vf_nr, buf, buf_sz);
+}
+EXPORT_SYMBOL_GPL(qat_vfmig_save_state);
+
+int qat_vfmig_load_state(struct pci_dev *pdev, u32 vf_nr, u8 *buf, u64 buf_sz)
+{
+	struct adf_accel_dev *accel_dev = adf_devmgr_pci_to_accel_dev(pdev);
+
+	if (!accel_dev) {
+		dev_err(&pdev->dev, "Failed to find accel_dev\n");
+		return -ENODEV;
+	}
+
+	if (WARN_ON(!GET_VFMIG_OPS(accel_dev)->load_state))
+		return -EINVAL;
+
+	return GET_VFMIG_OPS(accel_dev)->load_state(accel_dev, vf_nr, buf, buf_sz);
+}
+EXPORT_SYMBOL_GPL(qat_vfmig_load_state);
diff --git a/include/linux/qat/qat_vf_mig.h b/include/linux/qat/qat_vf_mig.h
new file mode 100644
index 000000000000..09101be800ce
--- /dev/null
+++ b/include/linux/qat/qat_vf_mig.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright(c) 2023 Intel Corporation */
+
+#ifndef QAT_VF_MIG_H_
+#define QAT_VF_MIG_H_
+
+struct pci_dev;
+
+int qat_vfmig_init_device(struct pci_dev *pdev, u32 vf_nr);
+void qat_vfmig_shutdown_device(struct pci_dev *pdev, u32 vf_nr);
+int qat_vfmig_save_state(struct pci_dev *pdev, u32 vf_nr, u8 *buf, u64 buf_sz);
+int qat_vfmig_load_state(struct pci_dev *pdev, u32 vf_nr, u8 *buf, u64 buf_sz);
+int qat_vfmig_suspend_device(struct pci_dev *pdev, u32 vf_nr);
+int qat_vfmig_resume_device(struct pci_dev *pdev, u32 vf_nr);
+#endif /*QAT_VF_MIG_H_*/
-- 
2.18.2

