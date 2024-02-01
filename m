Return-Path: <kvm+bounces-7731-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BDEC5845BDE
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 16:43:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E2E1B1C22E0E
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 15:43:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AE917B3E0;
	Thu,  1 Feb 2024 15:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LZ5DZjVR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA657626AC;
	Thu,  1 Feb 2024 15:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.93
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706802141; cv=none; b=CMZScYD2GVsuwYmp6rB8xQxHjjogaj+ndsa79R7UNNWLEaA9en+l2cNCpL3FhKf0fkegsiDDHeHDyQ1AYqA6mxr2ckEu4+VKZcwc/XobFRg1cyoyi+6hrI5+Ymmaslxn2LnLxIITIscJOqOX9o5hb8drPvobUagoGfkVG6fIeuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706802141; c=relaxed/simple;
	bh=qREIhdjjgmLHUZ6ryz5BY0f/GWyi04lbYKKlcFezNAk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=CuKyq9FpBcU7pjt2g1F0VcHDL1ULoPmk9oWUxObBgxZV627clf74L1D6rtto3wXS/AJa8HNfrgOIGHHoVM0lEG+vzrzJkv4xxN0SkhYF2afkEKzTrIWHuN5VexsP+5RxegQtXhiBMu89V6kV6CxXT6tyFvuFDAcnHCwf3Hl9pvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LZ5DZjVR; arc=none smtp.client-ip=192.55.52.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706802139; x=1738338139;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=qREIhdjjgmLHUZ6ryz5BY0f/GWyi04lbYKKlcFezNAk=;
  b=LZ5DZjVRvkieHiqyAYbH3dQ2RQadFl8iMafWgb9j8okDH/zNJEptfhYB
   23POQ3CQBEINge72J0pGwF55xijLGlyOOQmC6fhzHDX39rD6+mTaIhWXi
   oBdPUDNaV4UZp0iNYu7QmGoqY16GCDECIMqkxrCPJuqwXOsu00qUwebY2
   8JQXigyz1BWMAYYiMaXXfRHsKvp6AxREhNojeFFNXGinVKuKf7+lkFlhi
   SEtAaqf1Ed0CIAEZC70Om6LuVXD7aufSsnrllXZfc5JfKaWv7IK2xjknE
   TjRdzny1H8e0M8Y8dKqSXgR8I6p4jAQEQjvoeGOBGl8m4cyFd4jGWSdRm
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10969"; a="401053028"
X-IronPort-AV: E=Sophos;i="6.05,234,1701158400"; 
   d="scan'208";a="401053028"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2024 07:42:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,234,1701158400"; 
   d="scan'208";a="133359"
Received: from qat-server-archercity1.sh.intel.com ([10.67.111.115])
  by orviesa007.jf.intel.com with ESMTP; 01 Feb 2024 07:42:16 -0800
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
Subject: [PATCH 08/10] crypto: qat - add interface for live migration
Date: Thu,  1 Feb 2024 23:33:35 +0800
Message-Id: <20240201153337.4033490-9-xin.zeng@intel.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20240201153337.4033490-1-xin.zeng@intel.com>
References: <20240201153337.4033490-1-xin.zeng@intel.com>
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
 drivers/crypto/intel/qat/qat_common/Makefile  |  2 +-
 .../intel/qat/qat_common/adf_accel_devices.h  |  2 ++
 .../crypto/intel/qat/qat_common/qat_mig_dev.c | 35 +++++++++++++++++++
 include/linux/qat/qat_mig_dev.h               | 31 ++++++++++++++++
 4 files changed, 69 insertions(+), 1 deletion(-)
 create mode 100644 drivers/crypto/intel/qat/qat_common/qat_mig_dev.c
 create mode 100644 include/linux/qat/qat_mig_dev.h

diff --git a/drivers/crypto/intel/qat/qat_common/Makefile b/drivers/crypto/intel/qat/qat_common/Makefile
index da4d806a9287..05cac8a9e463 100644
--- a/drivers/crypto/intel/qat/qat_common/Makefile
+++ b/drivers/crypto/intel/qat/qat_common/Makefile
@@ -54,4 +54,4 @@ intel_qat-$(CONFIG_DEBUG_FS) += adf_transport_debug.o \
 intel_qat-$(CONFIG_PCI_IOV) += adf_sriov.o adf_vf_isr.o adf_pfvf_utils.o \
 			       adf_pfvf_pf_msg.o adf_pfvf_pf_proto.o \
 			       adf_pfvf_vf_msg.o adf_pfvf_vf_proto.o \
-			       adf_gen2_pfvf.o adf_gen4_pfvf.o
+			       adf_gen2_pfvf.o adf_gen4_pfvf.o qat_mig_dev.o
diff --git a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
index bdb026155f64..0fa52d20c131 100644
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
@@ -325,6 +326,7 @@ struct adf_hw_device_data {
 	struct adf_dev_err_mask dev_err_mask;
 	struct adf_rl_hw_data rl_data;
 	struct adf_tl_hw_data tl_data;
+	struct qat_migdev_ops vfmig_ops;
 	const char *fw_name;
 	const char *fw_mmp_name;
 	u32 fuses;
diff --git a/drivers/crypto/intel/qat/qat_common/qat_mig_dev.c b/drivers/crypto/intel/qat/qat_common/qat_mig_dev.c
new file mode 100644
index 000000000000..45520a715544
--- /dev/null
+++ b/drivers/crypto/intel/qat/qat_common/qat_mig_dev.c
@@ -0,0 +1,35 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(c) 2024 Intel Corporation */
+#include <linux/dev_printk.h>
+#include <linux/export.h>
+#include <linux/pci.h>
+#include <linux/types.h>
+#include <linux/qat/qat_mig_dev.h>
+#include "adf_common_drv.h"
+
+struct qat_mig_dev *qat_vfmig_create(struct pci_dev *pdev, int vf_id)
+{
+	struct adf_accel_dev *accel_dev;
+	struct qat_mig_dev *mdev;
+
+	accel_dev = adf_devmgr_pci_to_accel_dev(pdev);
+	if (!accel_dev)
+		return ERR_PTR(-ENODEV);
+
+	mdev = kmalloc(sizeof(*mdev), GFP_KERNEL);
+	if (!mdev)
+		return ERR_PTR(-ENOMEM);
+
+	mdev->vf_id = vf_id;
+	mdev->parent_accel_dev = accel_dev;
+	mdev->ops = &accel_dev->hw_device->vfmig_ops;
+
+	return mdev;
+}
+EXPORT_SYMBOL_GPL(qat_vfmig_create);
+
+void qat_vfmig_destroy(struct qat_mig_dev *mdev)
+{
+	kfree(mdev);
+}
+EXPORT_SYMBOL_GPL(qat_vfmig_destroy);
diff --git a/include/linux/qat/qat_mig_dev.h b/include/linux/qat/qat_mig_dev.h
new file mode 100644
index 000000000000..229454efe3ba
--- /dev/null
+++ b/include/linux/qat/qat_mig_dev.h
@@ -0,0 +1,31 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright(c) 2024 Intel Corporation */
+#ifndef QAT_MIG_DEV_H_
+#define QAT_MIG_DEV_H_
+
+struct pci_dev;
+struct qat_migdev_ops;
+
+struct qat_mig_dev {
+	void *parent_accel_dev;
+	struct qat_migdev_ops *ops;
+	u8 *state;
+	u32 state_size;
+	s32 vf_id;
+};
+
+struct qat_migdev_ops {
+	int (*init)(struct qat_mig_dev *mdev);
+	void (*cleanup)(struct qat_mig_dev *mdev);
+	int (*open)(struct qat_mig_dev *mdev);
+	void (*close)(struct qat_mig_dev *mdev);
+	int (*suspend)(struct qat_mig_dev *mdev);
+	int (*resume)(struct qat_mig_dev *mdev);
+	int (*save_state)(struct qat_mig_dev *mdev);
+	int (*load_state)(struct qat_mig_dev *mdev);
+};
+
+struct qat_mig_dev *qat_vfmig_create(struct pci_dev *pdev, int vf_id);
+void qat_vfmig_destroy(struct qat_mig_dev *mdev);
+
+#endif /*QAT_MIG_DEV_H_*/
-- 
2.18.2


