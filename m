Return-Path: <kvm+bounces-9126-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CFEAF85B172
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 04:31:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5AFA41F21B8C
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 03:31:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5933956B86;
	Tue, 20 Feb 2024 03:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g9emBxKh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F00535C4;
	Tue, 20 Feb 2024 03:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708399793; cv=none; b=ua4GjhTU+qBadsZlCv9+VkHiAycUeukMcp7xffFKLEvMKROGnXTvEJhnuErj54CMIR5u/WbNvQkM1vpLDZFwOHXPXTDtApkTo5JGG8d7SR7QGB96CAhJmxUO+uvNBZ+QRjCCum6TP8MFfIeyTKfGC0NtHiqiq3xJliDhMhIsq1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708399793; c=relaxed/simple;
	bh=JyQGY2fS+hn+3+WxGLZvpZMP3hUKRcU0ymez1in287o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=Hdfs/F5vkG0O83KFW/Gn2Gk9xszM/A9l0Cl19UKiWKWPlAeEu2j0XWqWoVvtAZzi3Jo3zoo1QV6JuYdRcWwiWMrLQiA3HbDhz+my/eSa1UmJlQCw7RqTzhX5bq7UmQWNIy7WFPbI1Fkup1+OGVky5FX/gK5yXeH8CZhKC2HuteI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g9emBxKh; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708399792; x=1739935792;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=JyQGY2fS+hn+3+WxGLZvpZMP3hUKRcU0ymez1in287o=;
  b=g9emBxKhoC4IBfn3tCMZ2IG+vsLgIV0fpez0S+IZ6DlzQlAyhXtIkiQM
   sHKxfqVDkk5r+P58DtlM6H9tADAAfiK0ceTSu/91QDtKtjdJ3u7copZXi
   hyQt+jbj0W5KE2SgnI2TOM7BzhWxB0pj46vF6XrQNff8bj5FPtE6zxNxL
   1tLO0cp7YmAT8e/2DpVidzesK3hA8U80Q9pjgmt2FdjI4xYyexXH2rPFM
   Cs/+fDusbnhSCRkzvRYtUWM86U41Sdee3+Rg75SxOAWUIBK7zPCN4oFym
   OgDnSe6tC4Op7Frf4srSXVA5S04lmbZijN91fWdtWv2BiR+o/3RMnpQpt
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10989"; a="2354122"
X-IronPort-AV: E=Sophos;i="6.06,171,1705392000"; 
   d="scan'208";a="2354122"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2024 19:29:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,171,1705392000"; 
   d="scan'208";a="9302096"
Received: from qat-server-archercity1.sh.intel.com ([10.67.111.115])
  by orviesa003.jf.intel.com with ESMTP; 19 Feb 2024 19:29:49 -0800
From: Xin Zeng <xin.zeng@intel.com>
To: herbert@gondor.apana.org.au,
	alex.williamson@redhat.com,
	jgg@nvidia.com,
	yishaih@nvidia.com,
	shameerali.kolothum.thodi@huawei.com,
	kevin.tian@intel.com
Cc: linux-crypto@vger.kernel.org,
	kvm@vger.kernel.org,
	qat-linux@intel.com,
	Xin Zeng <xin.zeng@intel.com>
Subject: [PATCH v2 08/10] crypto: qat - add interface for live migration
Date: Tue, 20 Feb 2024 11:20:50 +0800
Message-Id: <20240220032052.66834-9-xin.zeng@intel.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20240220032052.66834-1-xin.zeng@intel.com>
References: <20240220032052.66834-1-xin.zeng@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Extend the driver with a new interface to be used for VF live migration.
This allows to create and destroy a qat_mig_dev object that contains
a set of methods to allow to save and restore the state of QAT VF.
This interface will be used by the qat-vfio-pci module.

Signed-off-by: Xin Zeng <xin.zeng@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_common/Makefile  |   2 +-
 .../intel/qat/qat_common/adf_accel_devices.h  |  17 +++
 .../intel/qat/qat_common/adf_gen4_vf_mig.h    |  10 ++
 .../crypto/intel/qat/qat_common/qat_mig_dev.c | 130 ++++++++++++++++++
 include/linux/qat/qat_mig_dev.h               |  31 +++++
 5 files changed, 189 insertions(+), 1 deletion(-)
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen4_vf_mig.h
 create mode 100644 drivers/crypto/intel/qat/qat_common/qat_mig_dev.c
 create mode 100644 include/linux/qat/qat_mig_dev.h

diff --git a/drivers/crypto/intel/qat/qat_common/Makefile b/drivers/crypto/intel/qat/qat_common/Makefile
index ceaa685352ed..9fba31d4ac7f 100644
--- a/drivers/crypto/intel/qat/qat_common/Makefile
+++ b/drivers/crypto/intel/qat/qat_common/Makefile
@@ -54,6 +54,6 @@ intel_qat-$(CONFIG_DEBUG_FS) += adf_transport_debug.o \
 intel_qat-$(CONFIG_PCI_IOV) += adf_sriov.o adf_vf_isr.o adf_pfvf_utils.o \
 			       adf_pfvf_pf_msg.o adf_pfvf_pf_proto.o \
 			       adf_pfvf_vf_msg.o adf_pfvf_vf_proto.o \
-			       adf_gen2_pfvf.o adf_gen4_pfvf.o
+			       adf_gen2_pfvf.o adf_gen4_pfvf.o qat_mig_dev.o
 
 intel_qat-$(CONFIG_CRYPTO_DEV_QAT_ERROR_INJECTION) += adf_heartbeat_inject.o
diff --git a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
index 986e63ec702d..b08fea10121e 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
@@ -9,6 +9,7 @@
 #include <linux/pci.h>
 #include <linux/ratelimit.h>
 #include <linux/types.h>
+#include <linux/qat/qat_mig_dev.h>
 #include "adf_cfg_common.h"
 #include "adf_rl.h"
 #include "adf_telemetry.h"
@@ -258,6 +259,20 @@ struct adf_dc_ops {
 	void (*build_deflate_ctx)(void *ctx);
 };
 
+struct qat_migdev_ops {
+	int (*init)(struct qat_mig_dev *mdev);
+	void (*cleanup)(struct qat_mig_dev *mdev);
+	void (*reset)(struct qat_mig_dev *mdev);
+	int (*open)(struct qat_mig_dev *mdev);
+	void (*close)(struct qat_mig_dev *mdev);
+	int (*suspend)(struct qat_mig_dev *mdev);
+	int (*resume)(struct qat_mig_dev *mdev);
+	int (*save_state)(struct qat_mig_dev *mdev);
+	int (*save_setup)(struct qat_mig_dev *mdev);
+	int (*load_state)(struct qat_mig_dev *mdev);
+	int (*load_setup)(struct qat_mig_dev *mdev, int size);
+};
+
 struct adf_dev_err_mask {
 	u32 cppagentcmdpar_mask;
 	u32 parerr_ath_cph_mask;
@@ -325,6 +340,7 @@ struct adf_hw_device_data {
 	struct adf_dev_err_mask dev_err_mask;
 	struct adf_rl_hw_data rl_data;
 	struct adf_tl_hw_data tl_data;
+	struct qat_migdev_ops vfmig_ops;
 	const char *fw_name;
 	const char *fw_mmp_name;
 	u32 fuses;
@@ -381,6 +397,7 @@ struct adf_hw_device_data {
 #define GET_CSR_OPS(accel_dev) (&(accel_dev)->hw_device->csr_ops)
 #define GET_PFVF_OPS(accel_dev) (&(accel_dev)->hw_device->pfvf_ops)
 #define GET_DC_OPS(accel_dev) (&(accel_dev)->hw_device->dc_ops)
+#define GET_VFMIG_OPS(accel_dev) (&(accel_dev)->hw_device->vfmig_ops)
 #define GET_TL_DATA(accel_dev) GET_HW_DATA(accel_dev)->tl_data
 #define accel_to_pci_dev(accel_ptr) accel_ptr->accel_pci_dev.pci_dev
 
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_vf_mig.h b/drivers/crypto/intel/qat/qat_common/adf_gen4_vf_mig.h
new file mode 100644
index 000000000000..72216d078ee1
--- /dev/null
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_vf_mig.h
@@ -0,0 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright(c) 2024 Intel Corporation */
+#ifndef ADF_GEN4_VF_MIG_H_
+#define ADF_GEN4_VF_MIG_H_
+
+#include "adf_accel_devices.h"
+
+void adf_gen4_init_vf_mig_ops(struct qat_migdev_ops *vfmig_ops);
+
+#endif
diff --git a/drivers/crypto/intel/qat/qat_common/qat_mig_dev.c b/drivers/crypto/intel/qat/qat_common/qat_mig_dev.c
new file mode 100644
index 000000000000..892c2283a50e
--- /dev/null
+++ b/drivers/crypto/intel/qat/qat_common/qat_mig_dev.c
@@ -0,0 +1,130 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(c) 2024 Intel Corporation */
+#include <linux/dev_printk.h>
+#include <linux/export.h>
+#include <linux/pci.h>
+#include <linux/types.h>
+#include <linux/qat/qat_mig_dev.h>
+#include "adf_accel_devices.h"
+#include "adf_common_drv.h"
+
+struct qat_mig_dev *qat_vfmig_create(struct pci_dev *pdev, int vf_id)
+{
+	struct adf_accel_dev *accel_dev;
+	struct qat_migdev_ops *ops;
+	struct qat_mig_dev *mdev;
+
+	accel_dev = adf_devmgr_pci_to_accel_dev(pdev);
+	if (!accel_dev)
+		return ERR_PTR(-ENODEV);
+
+	ops = GET_VFMIG_OPS(accel_dev);
+	if (!ops || !ops->init || !ops->cleanup || !ops->reset || !ops->open ||
+	    !ops->close || !ops->suspend || !ops->resume || !ops->save_state ||
+	    !ops->load_state || !ops->save_setup || !ops->load_setup)
+		return ERR_PTR(-EINVAL);
+
+	mdev = kmalloc(sizeof(*mdev), GFP_KERNEL);
+	if (!mdev)
+		return ERR_PTR(-ENOMEM);
+
+	mdev->vf_id = vf_id;
+	mdev->parent_accel_dev = accel_dev;
+
+	return mdev;
+}
+EXPORT_SYMBOL_GPL(qat_vfmig_create);
+
+int qat_vfmig_init(struct qat_mig_dev *mdev)
+{
+	struct adf_accel_dev *accel_dev = mdev->parent_accel_dev;
+
+	return GET_VFMIG_OPS(accel_dev)->init(mdev);
+}
+EXPORT_SYMBOL_GPL(qat_vfmig_init);
+
+void qat_vfmig_cleanup(struct qat_mig_dev *mdev)
+{
+	struct adf_accel_dev *accel_dev = mdev->parent_accel_dev;
+
+	return GET_VFMIG_OPS(accel_dev)->cleanup(mdev);
+}
+EXPORT_SYMBOL_GPL(qat_vfmig_cleanup);
+
+void qat_vfmig_reset(struct qat_mig_dev *mdev)
+{
+	struct adf_accel_dev *accel_dev = mdev->parent_accel_dev;
+
+	return GET_VFMIG_OPS(accel_dev)->reset(mdev);
+}
+EXPORT_SYMBOL_GPL(qat_vfmig_reset);
+
+int qat_vfmig_open(struct qat_mig_dev *mdev)
+{
+	struct adf_accel_dev *accel_dev = mdev->parent_accel_dev;
+
+	return GET_VFMIG_OPS(accel_dev)->open(mdev);
+}
+EXPORT_SYMBOL_GPL(qat_vfmig_open);
+
+void qat_vfmig_close(struct qat_mig_dev *mdev)
+{
+	struct adf_accel_dev *accel_dev = mdev->parent_accel_dev;
+
+	GET_VFMIG_OPS(accel_dev)->close(mdev);
+}
+EXPORT_SYMBOL_GPL(qat_vfmig_close);
+
+int qat_vfmig_suspend(struct qat_mig_dev *mdev)
+{
+	struct adf_accel_dev *accel_dev = mdev->parent_accel_dev;
+
+	return GET_VFMIG_OPS(accel_dev)->suspend(mdev);
+}
+EXPORT_SYMBOL_GPL(qat_vfmig_suspend);
+
+int qat_vfmig_resume(struct qat_mig_dev *mdev)
+{
+	struct adf_accel_dev *accel_dev = mdev->parent_accel_dev;
+
+	return GET_VFMIG_OPS(accel_dev)->resume(mdev);
+}
+EXPORT_SYMBOL_GPL(qat_vfmig_resume);
+
+int qat_vfmig_save_state(struct qat_mig_dev *mdev)
+{
+	struct adf_accel_dev *accel_dev = mdev->parent_accel_dev;
+
+	return GET_VFMIG_OPS(accel_dev)->save_state(mdev);
+}
+EXPORT_SYMBOL_GPL(qat_vfmig_save_state);
+
+int qat_vfmig_save_setup(struct qat_mig_dev *mdev)
+{
+	struct adf_accel_dev *accel_dev = mdev->parent_accel_dev;
+
+	return GET_VFMIG_OPS(accel_dev)->save_setup(mdev);
+}
+EXPORT_SYMBOL_GPL(qat_vfmig_save_setup);
+
+int qat_vfmig_load_state(struct qat_mig_dev *mdev)
+{
+	struct adf_accel_dev *accel_dev = mdev->parent_accel_dev;
+
+	return GET_VFMIG_OPS(accel_dev)->load_state(mdev);
+}
+EXPORT_SYMBOL_GPL(qat_vfmig_load_state);
+
+int qat_vfmig_load_setup(struct qat_mig_dev *mdev, int size)
+{
+	struct adf_accel_dev *accel_dev = mdev->parent_accel_dev;
+
+	return GET_VFMIG_OPS(accel_dev)->load_setup(mdev, size);
+}
+EXPORT_SYMBOL_GPL(qat_vfmig_load_setup);
+
+void qat_vfmig_destroy(struct qat_mig_dev *mdev)
+{
+	kfree(mdev);
+}
+EXPORT_SYMBOL_GPL(qat_vfmig_destroy);
diff --git a/include/linux/qat/qat_mig_dev.h b/include/linux/qat/qat_mig_dev.h
new file mode 100644
index 000000000000..dbbb6a063dd2
--- /dev/null
+++ b/include/linux/qat/qat_mig_dev.h
@@ -0,0 +1,31 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright(c) 2024 Intel Corporation */
+#ifndef QAT_MIG_DEV_H_
+#define QAT_MIG_DEV_H_
+
+struct pci_dev;
+
+struct qat_mig_dev {
+	void *parent_accel_dev;
+	u8 *state;
+	u32 setup_size;
+	u32 remote_setup_size;
+	u32 state_size;
+	s32 vf_id;
+};
+
+struct qat_mig_dev *qat_vfmig_create(struct pci_dev *pdev, int vf_id);
+int qat_vfmig_init(struct qat_mig_dev *mdev);
+void qat_vfmig_cleanup(struct qat_mig_dev *mdev);
+void qat_vfmig_reset(struct qat_mig_dev *mdev);
+int qat_vfmig_open(struct qat_mig_dev *mdev);
+void qat_vfmig_close(struct qat_mig_dev *mdev);
+int qat_vfmig_suspend(struct qat_mig_dev *mdev);
+int qat_vfmig_resume(struct qat_mig_dev *mdev);
+int qat_vfmig_save_state(struct qat_mig_dev *mdev);
+int qat_vfmig_save_setup(struct qat_mig_dev *mdev);
+int qat_vfmig_load_state(struct qat_mig_dev *mdev);
+int qat_vfmig_load_setup(struct qat_mig_dev *mdev, int size);
+void qat_vfmig_destroy(struct qat_mig_dev *mdev);
+
+#endif /*QAT_MIG_DEV_H_*/
-- 
2.18.2


