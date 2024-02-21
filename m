Return-Path: <kvm+bounces-9327-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E4DAD85E258
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 17:02:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EC010B27439
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 16:02:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D381883CBB;
	Wed, 21 Feb 2024 15:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FmPxpGTR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17A46839EF;
	Wed, 21 Feb 2024 15:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708531168; cv=none; b=SYcs/+ZCUboh02UtWT5lg0CXfCK2JQHQRKZIq2ryD6KCO6ODikBHhGkfg9VM/GfEt19q2AbfxtCklcrJOVBN5JQHRDUpUhJP9QOsHKEFvuiiEQFwsQRyVO9WAy+3MrC18tPrIKBRg199U8+quLm4abXEtjpT/67x3teYqj/P+D4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708531168; c=relaxed/simple;
	bh=JyQGY2fS+hn+3+WxGLZvpZMP3hUKRcU0ymez1in287o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=EYn1dihoY46P/D863hC1f705XWT+NQ2rDPnXitZUO7Fn6WTY5jmVSwPBnOJVeXGJ1HkntP2Q5O4X6TXOPwfyyKLIco/xTeqjM9qDFBa6eq3D961IVXrEZU3zBmDholiMSonqTmLXwh9alpsOyehaF2LBImWgZHLSd2lh8xtpt0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FmPxpGTR; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708531166; x=1740067166;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=JyQGY2fS+hn+3+WxGLZvpZMP3hUKRcU0ymez1in287o=;
  b=FmPxpGTR+yOJA2dLDjY3Zs6DGxHNXBkRoRmOcBFTI0XG+raiUuzXkdTD
   q6JkiA0noqYcQk9xVEQQmE2rLPVYjMITLjGx4KYrXYWEillt2BciTgpl4
   pmylnIUPIRUmvf3BtP6DKFPAI4nY1fcy4ZMNz0YH6Ta/Pz2sJqB5fQynj
   Cbjiy8WrV5EN9eS+eQ9F8llI11cSK9R47QBDOtl7XDAFfrKWK0h20cgmK
   k2QoDouarfsgYvUIoRXRPA8Ydb7pHCpOZlgRbXEeztGsjeAy7W3cTLu0s
   gplTRbsp3f4qeqtxzAMO1akXdTfQBa6yft1JRDfbWFIS7BIilDQlvym3S
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10991"; a="2568883"
X-IronPort-AV: E=Sophos;i="6.06,175,1705392000"; 
   d="scan'208";a="2568883"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2024 07:59:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,175,1705392000"; 
   d="scan'208";a="9760964"
Received: from qat-server-archercity1.sh.intel.com ([10.67.111.115])
  by fmviesa004.fm.intel.com with ESMTP; 21 Feb 2024 07:59:05 -0800
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
Subject: [PATCH v3 08/10] crypto: qat - add interface for live migration
Date: Wed, 21 Feb 2024 23:50:06 +0800
Message-Id: <20240221155008.960369-9-xin.zeng@intel.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20240221155008.960369-1-xin.zeng@intel.com>
References: <20240221155008.960369-1-xin.zeng@intel.com>
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


