Return-Path: <kvm+bounces-10262-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EF3CC86B211
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 15:43:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3C262B27BE8
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 14:43:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23EE115B986;
	Wed, 28 Feb 2024 14:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XopBVXE4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E8215B967;
	Wed, 28 Feb 2024 14:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709131380; cv=none; b=OLmppVTcCJzlyj6kow/Jm3/Z115knsCdXd+t2pxwmX5Hvdw/tg2KGWdaSV1gsUVyyQWb+angqR8rcwrxEWExsJ+mlNj1Ek2AIu06SGjwQYklM8VYvSJaMO7dm26XQvSqHPHmHika1rn7HlNWfMm7vQieVctdUM0lSwghUHELQqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709131380; c=relaxed/simple;
	bh=Dq50jBV/cJWnyIx2pRibTqefwuL+uikgvzDKmQq3hwQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=Qu9DG7K3xrOBRrcd8X2v4jdx61hwlmocrF67v26PWO1MN8pTjTjcXOCtqVTRKTRRgUbncjYk8TH6ZVqIN420Evcy97dALv1pO3Qi+t8iv5MgYWRfG8PwKQYSc5szK8ywUbAKDpqoTITKZlrDp/tFpvkwIh91QP0hd8QXAe4JPDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XopBVXE4; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709131378; x=1740667378;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=Dq50jBV/cJWnyIx2pRibTqefwuL+uikgvzDKmQq3hwQ=;
  b=XopBVXE4YXZV+LH1ZmrHuiVnRr7tDdDZuOYIwQUqRdX2KKd0euferQmj
   MRMwe01XrB1c/c/xuHvQnBK8Cbe1gG2abFy1eRzosRb8xR8VU3+LJbXwd
   ZrSCkvD+FzIUD2xRpsmy6rSR709xxV9L3MHMGN7DIPUliB5weDsCrWf0V
   fE6EnuRlxvRCKY1TBzmeSbGL89HAveXl+JwdlEVkwRPqg6fjsdVpzQ5k7
   Od69PD0BcZsx6yTZqYXiDDiucKEmCjioUc2N2WviZYZcpGeTxijGCPrGB
   5WLhSQvI5qqTh+5sk4TrOYh+quE4uQOGrtYG9+mx1nWuiS7iSBdm1kj4d
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="14950982"
X-IronPort-AV: E=Sophos;i="6.06,190,1705392000"; 
   d="scan'208";a="14950982"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2024 06:42:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,190,1705392000"; 
   d="scan'208";a="11994679"
Received: from qat-server-archercity1.sh.intel.com ([10.67.111.115])
  by fmviesa005.fm.intel.com with ESMTP; 28 Feb 2024 06:42:54 -0800
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
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Xin Zeng <xin.zeng@intel.com>
Subject: [PATCH v4 04/10] crypto: qat - relocate CSR access code
Date: Wed, 28 Feb 2024 22:33:56 +0800
Message-Id: <20240228143402.89219-5-xin.zeng@intel.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20240228143402.89219-1-xin.zeng@intel.com>
References: <20240228143402.89219-1-xin.zeng@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

As the common hw_data files are growing and the adf_hw_csr_ops is going
to be extended with new operations, move all logic related to ring CSRs
to the newly created adf_gen[2|4]_hw_csr_data.[c|h] files.

This does not introduce any functional change.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Xin Zeng <xin.zeng@intel.com>
Signed-off-by: Xin Zeng <xin.zeng@intel.com>
---
 .../intel/qat/qat_420xx/adf_420xx_hw_data.c   |   1 +
 .../intel/qat/qat_4xxx/adf_4xxx_hw_data.c     |   1 +
 .../intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c   |   1 +
 .../qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c     |   1 +
 .../intel/qat/qat_c62x/adf_c62x_hw_data.c     |   1 +
 .../intel/qat/qat_c62xvf/adf_c62xvf_hw_data.c |   1 +
 drivers/crypto/intel/qat/qat_common/Makefile  |   2 +
 .../qat/qat_common/adf_gen2_hw_csr_data.c     | 101 ++++++++++++++++++
 .../qat/qat_common/adf_gen2_hw_csr_data.h     |  86 +++++++++++++++
 .../intel/qat/qat_common/adf_gen2_hw_data.c   |  97 -----------------
 .../intel/qat/qat_common/adf_gen2_hw_data.h   |  76 -------------
 .../qat/qat_common/adf_gen4_hw_csr_data.c     | 101 ++++++++++++++++++
 .../qat/qat_common/adf_gen4_hw_csr_data.h     |  97 +++++++++++++++++
 .../intel/qat/qat_common/adf_gen4_hw_data.c   |  97 -----------------
 .../intel/qat/qat_common/adf_gen4_hw_data.h   |  94 +---------------
 .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.c   |   1 +
 .../qat_dh895xccvf/adf_dh895xccvf_hw_data.c   |   1 +
 17 files changed, 397 insertions(+), 362 deletions(-)
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen2_hw_csr_data.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen2_hw_csr_data.h
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen4_hw_csr_data.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen4_hw_csr_data.h

diff --git a/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c b/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
index 1102c47f8293..9ccbf5998d5c 100644
--- a/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
@@ -10,6 +10,7 @@
 #include <adf_fw_config.h>
 #include <adf_gen4_config.h>
 #include <adf_gen4_dc.h>
+#include <adf_gen4_hw_csr_data.h>
 #include <adf_gen4_hw_data.h>
 #include <adf_gen4_pfvf.h>
 #include <adf_gen4_pm.h>
diff --git a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
index 927506cf271d..ef4b0aa36603 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -10,6 +10,7 @@
 #include <adf_fw_config.h>
 #include <adf_gen4_config.h>
 #include <adf_gen4_dc.h>
+#include <adf_gen4_hw_csr_data.h>
 #include <adf_gen4_hw_data.h>
 #include <adf_gen4_pfvf.h>
 #include <adf_gen4_pm.h>
diff --git a/drivers/crypto/intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c b/drivers/crypto/intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c
index a882e0ea2279..201f9412c582 100644
--- a/drivers/crypto/intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c
@@ -6,6 +6,7 @@
 #include <adf_common_drv.h>
 #include <adf_gen2_config.h>
 #include <adf_gen2_dc.h>
+#include <adf_gen2_hw_csr_data.h>
 #include <adf_gen2_hw_data.h>
 #include <adf_gen2_pfvf.h>
 #include "adf_c3xxx_hw_data.h"
diff --git a/drivers/crypto/intel/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c b/drivers/crypto/intel/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c
index 84d9486e04de..a512ca4efd3f 100644
--- a/drivers/crypto/intel/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c
@@ -4,6 +4,7 @@
 #include <adf_common_drv.h>
 #include <adf_gen2_config.h>
 #include <adf_gen2_dc.h>
+#include <adf_gen2_hw_csr_data.h>
 #include <adf_gen2_hw_data.h>
 #include <adf_gen2_pfvf.h>
 #include <adf_pfvf_vf_msg.h>
diff --git a/drivers/crypto/intel/qat/qat_c62x/adf_c62x_hw_data.c b/drivers/crypto/intel/qat/qat_c62x/adf_c62x_hw_data.c
index 48cf3eb7c734..6b5b0cf9c7c7 100644
--- a/drivers/crypto/intel/qat/qat_c62x/adf_c62x_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_c62x/adf_c62x_hw_data.c
@@ -6,6 +6,7 @@
 #include <adf_common_drv.h>
 #include <adf_gen2_config.h>
 #include <adf_gen2_dc.h>
+#include <adf_gen2_hw_csr_data.h>
 #include <adf_gen2_hw_data.h>
 #include <adf_gen2_pfvf.h>
 #include "adf_c62x_hw_data.h"
diff --git a/drivers/crypto/intel/qat/qat_c62xvf/adf_c62xvf_hw_data.c b/drivers/crypto/intel/qat/qat_c62xvf/adf_c62xvf_hw_data.c
index 751d7aa57fc7..4aaaaf921734 100644
--- a/drivers/crypto/intel/qat/qat_c62xvf/adf_c62xvf_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_c62xvf/adf_c62xvf_hw_data.c
@@ -4,6 +4,7 @@
 #include <adf_common_drv.h>
 #include <adf_gen2_config.h>
 #include <adf_gen2_dc.h>
+#include <adf_gen2_hw_csr_data.h>
 #include <adf_gen2_hw_data.h>
 #include <adf_gen2_pfvf.h>
 #include <adf_pfvf_vf_msg.h>
diff --git a/drivers/crypto/intel/qat/qat_common/Makefile b/drivers/crypto/intel/qat/qat_common/Makefile
index 5915cde8a7aa..ceaa685352ed 100644
--- a/drivers/crypto/intel/qat/qat_common/Makefile
+++ b/drivers/crypto/intel/qat/qat_common/Makefile
@@ -14,9 +14,11 @@ intel_qat-objs := adf_cfg.o \
 	adf_hw_arbiter.o \
 	adf_sysfs.o \
 	adf_sysfs_ras_counters.o \
+	adf_gen2_hw_csr_data.o \
 	adf_gen2_hw_data.o \
 	adf_gen2_config.o \
 	adf_gen4_config.o \
+	adf_gen4_hw_csr_data.o \
 	adf_gen4_hw_data.o \
 	adf_gen4_pm.o \
 	adf_gen2_dc.o \
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen2_hw_csr_data.c b/drivers/crypto/intel/qat/qat_common/adf_gen2_hw_csr_data.c
new file mode 100644
index 000000000000..650c9edd8a66
--- /dev/null
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen2_hw_csr_data.c
@@ -0,0 +1,101 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(c) 2024 Intel Corporation */
+#include <linux/types.h>
+#include "adf_gen2_hw_csr_data.h"
+
+static u64 build_csr_ring_base_addr(dma_addr_t addr, u32 size)
+{
+	return BUILD_RING_BASE_ADDR(addr, size);
+}
+
+static u32 read_csr_ring_head(void __iomem *csr_base_addr, u32 bank, u32 ring)
+{
+	return READ_CSR_RING_HEAD(csr_base_addr, bank, ring);
+}
+
+static void write_csr_ring_head(void __iomem *csr_base_addr, u32 bank, u32 ring,
+				u32 value)
+{
+	WRITE_CSR_RING_HEAD(csr_base_addr, bank, ring, value);
+}
+
+static u32 read_csr_ring_tail(void __iomem *csr_base_addr, u32 bank, u32 ring)
+{
+	return READ_CSR_RING_TAIL(csr_base_addr, bank, ring);
+}
+
+static void write_csr_ring_tail(void __iomem *csr_base_addr, u32 bank, u32 ring,
+				u32 value)
+{
+	WRITE_CSR_RING_TAIL(csr_base_addr, bank, ring, value);
+}
+
+static u32 read_csr_e_stat(void __iomem *csr_base_addr, u32 bank)
+{
+	return READ_CSR_E_STAT(csr_base_addr, bank);
+}
+
+static void write_csr_ring_config(void __iomem *csr_base_addr, u32 bank,
+				  u32 ring, u32 value)
+{
+	WRITE_CSR_RING_CONFIG(csr_base_addr, bank, ring, value);
+}
+
+static void write_csr_ring_base(void __iomem *csr_base_addr, u32 bank, u32 ring,
+				dma_addr_t addr)
+{
+	WRITE_CSR_RING_BASE(csr_base_addr, bank, ring, addr);
+}
+
+static void write_csr_int_flag(void __iomem *csr_base_addr, u32 bank, u32 value)
+{
+	WRITE_CSR_INT_FLAG(csr_base_addr, bank, value);
+}
+
+static void write_csr_int_srcsel(void __iomem *csr_base_addr, u32 bank)
+{
+	WRITE_CSR_INT_SRCSEL(csr_base_addr, bank);
+}
+
+static void write_csr_int_col_en(void __iomem *csr_base_addr, u32 bank,
+				 u32 value)
+{
+	WRITE_CSR_INT_COL_EN(csr_base_addr, bank, value);
+}
+
+static void write_csr_int_col_ctl(void __iomem *csr_base_addr, u32 bank,
+				  u32 value)
+{
+	WRITE_CSR_INT_COL_CTL(csr_base_addr, bank, value);
+}
+
+static void write_csr_int_flag_and_col(void __iomem *csr_base_addr, u32 bank,
+				       u32 value)
+{
+	WRITE_CSR_INT_FLAG_AND_COL(csr_base_addr, bank, value);
+}
+
+static void write_csr_ring_srv_arb_en(void __iomem *csr_base_addr, u32 bank,
+				      u32 value)
+{
+	WRITE_CSR_RING_SRV_ARB_EN(csr_base_addr, bank, value);
+}
+
+void adf_gen2_init_hw_csr_ops(struct adf_hw_csr_ops *csr_ops)
+{
+	csr_ops->build_csr_ring_base_addr = build_csr_ring_base_addr;
+	csr_ops->read_csr_ring_head = read_csr_ring_head;
+	csr_ops->write_csr_ring_head = write_csr_ring_head;
+	csr_ops->read_csr_ring_tail = read_csr_ring_tail;
+	csr_ops->write_csr_ring_tail = write_csr_ring_tail;
+	csr_ops->read_csr_e_stat = read_csr_e_stat;
+	csr_ops->write_csr_ring_config = write_csr_ring_config;
+	csr_ops->write_csr_ring_base = write_csr_ring_base;
+	csr_ops->write_csr_int_flag = write_csr_int_flag;
+	csr_ops->write_csr_int_srcsel = write_csr_int_srcsel;
+	csr_ops->write_csr_int_col_en = write_csr_int_col_en;
+	csr_ops->write_csr_int_col_ctl = write_csr_int_col_ctl;
+	csr_ops->write_csr_int_flag_and_col = write_csr_int_flag_and_col;
+	csr_ops->write_csr_ring_srv_arb_en = write_csr_ring_srv_arb_en;
+}
+EXPORT_SYMBOL_GPL(adf_gen2_init_hw_csr_ops);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen2_hw_csr_data.h b/drivers/crypto/intel/qat/qat_common/adf_gen2_hw_csr_data.h
new file mode 100644
index 000000000000..55058b0f9e52
--- /dev/null
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen2_hw_csr_data.h
@@ -0,0 +1,86 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright(c) 2024 Intel Corporation */
+#ifndef ADF_GEN2_HW_CSR_DATA_H_
+#define ADF_GEN2_HW_CSR_DATA_H_
+
+#include <linux/bitops.h>
+#include "adf_accel_devices.h"
+
+#define ADF_BANK_INT_SRC_SEL_MASK_0	0x4444444CUL
+#define ADF_BANK_INT_SRC_SEL_MASK_X	0x44444444UL
+#define ADF_RING_CSR_RING_CONFIG	0x000
+#define ADF_RING_CSR_RING_LBASE		0x040
+#define ADF_RING_CSR_RING_UBASE		0x080
+#define ADF_RING_CSR_RING_HEAD		0x0C0
+#define ADF_RING_CSR_RING_TAIL		0x100
+#define ADF_RING_CSR_E_STAT		0x14C
+#define ADF_RING_CSR_INT_FLAG		0x170
+#define ADF_RING_CSR_INT_SRCSEL		0x174
+#define ADF_RING_CSR_INT_SRCSEL_2	0x178
+#define ADF_RING_CSR_INT_COL_EN		0x17C
+#define ADF_RING_CSR_INT_COL_CTL	0x180
+#define ADF_RING_CSR_INT_FLAG_AND_COL	0x184
+#define ADF_RING_CSR_INT_COL_CTL_ENABLE	0x80000000
+#define ADF_RING_BUNDLE_SIZE		0x1000
+#define ADF_ARB_REG_SLOT		0x1000
+#define ADF_ARB_RINGSRVARBEN_OFFSET	0x19C
+
+#define BUILD_RING_BASE_ADDR(addr, size) \
+	(((addr) >> 6) & (GENMASK_ULL(63, 0) << (size)))
+#define READ_CSR_RING_HEAD(csr_base_addr, bank, ring) \
+	ADF_CSR_RD(csr_base_addr, (ADF_RING_BUNDLE_SIZE * (bank)) + \
+		   ADF_RING_CSR_RING_HEAD + ((ring) << 2))
+#define READ_CSR_RING_TAIL(csr_base_addr, bank, ring) \
+	ADF_CSR_RD(csr_base_addr, (ADF_RING_BUNDLE_SIZE * (bank)) + \
+		   ADF_RING_CSR_RING_TAIL + ((ring) << 2))
+#define READ_CSR_E_STAT(csr_base_addr, bank) \
+	ADF_CSR_RD(csr_base_addr, (ADF_RING_BUNDLE_SIZE * (bank)) + \
+		   ADF_RING_CSR_E_STAT)
+#define WRITE_CSR_RING_CONFIG(csr_base_addr, bank, ring, value) \
+	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * (bank)) + \
+		   ADF_RING_CSR_RING_CONFIG + ((ring) << 2), value)
+#define WRITE_CSR_RING_BASE(csr_base_addr, bank, ring, value) \
+do { \
+	u32 l_base = 0, u_base = 0; \
+	l_base = (u32)((value) & 0xFFFFFFFF); \
+	u_base = (u32)(((value) & 0xFFFFFFFF00000000ULL) >> 32); \
+	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * (bank)) + \
+		   ADF_RING_CSR_RING_LBASE + ((ring) << 2), l_base); \
+	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * (bank)) + \
+		   ADF_RING_CSR_RING_UBASE + ((ring) << 2), u_base); \
+} while (0)
+
+#define WRITE_CSR_RING_HEAD(csr_base_addr, bank, ring, value) \
+	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * (bank)) + \
+		   ADF_RING_CSR_RING_HEAD + ((ring) << 2), value)
+#define WRITE_CSR_RING_TAIL(csr_base_addr, bank, ring, value) \
+	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * (bank)) + \
+		   ADF_RING_CSR_RING_TAIL + ((ring) << 2), value)
+#define WRITE_CSR_INT_FLAG(csr_base_addr, bank, value) \
+	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * (bank)) + \
+		   ADF_RING_CSR_INT_FLAG, value)
+#define WRITE_CSR_INT_SRCSEL(csr_base_addr, bank) \
+do { \
+	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * (bank)) + \
+	ADF_RING_CSR_INT_SRCSEL, ADF_BANK_INT_SRC_SEL_MASK_0); \
+	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * (bank)) + \
+	ADF_RING_CSR_INT_SRCSEL_2, ADF_BANK_INT_SRC_SEL_MASK_X); \
+} while (0)
+#define WRITE_CSR_INT_COL_EN(csr_base_addr, bank, value) \
+	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * (bank)) + \
+		   ADF_RING_CSR_INT_COL_EN, value)
+#define WRITE_CSR_INT_COL_CTL(csr_base_addr, bank, value) \
+	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * (bank)) + \
+		   ADF_RING_CSR_INT_COL_CTL, \
+		   ADF_RING_CSR_INT_COL_CTL_ENABLE | (value))
+#define WRITE_CSR_INT_FLAG_AND_COL(csr_base_addr, bank, value) \
+	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * (bank)) + \
+		   ADF_RING_CSR_INT_FLAG_AND_COL, value)
+
+#define WRITE_CSR_RING_SRV_ARB_EN(csr_addr, index, value) \
+	ADF_CSR_WR(csr_addr, ADF_ARB_RINGSRVARBEN_OFFSET + \
+	(ADF_ARB_REG_SLOT * (index)), value)
+
+void adf_gen2_init_hw_csr_ops(struct adf_hw_csr_ops *csr_ops);
+
+#endif
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen2_hw_data.c b/drivers/crypto/intel/qat/qat_common/adf_gen2_hw_data.c
index d1884547b5a1..1f64bf49b221 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen2_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen2_hw_data.c
@@ -111,103 +111,6 @@ void adf_gen2_enable_ints(struct adf_accel_dev *accel_dev)
 }
 EXPORT_SYMBOL_GPL(adf_gen2_enable_ints);
 
-static u64 build_csr_ring_base_addr(dma_addr_t addr, u32 size)
-{
-	return BUILD_RING_BASE_ADDR(addr, size);
-}
-
-static u32 read_csr_ring_head(void __iomem *csr_base_addr, u32 bank, u32 ring)
-{
-	return READ_CSR_RING_HEAD(csr_base_addr, bank, ring);
-}
-
-static void write_csr_ring_head(void __iomem *csr_base_addr, u32 bank, u32 ring,
-				u32 value)
-{
-	WRITE_CSR_RING_HEAD(csr_base_addr, bank, ring, value);
-}
-
-static u32 read_csr_ring_tail(void __iomem *csr_base_addr, u32 bank, u32 ring)
-{
-	return READ_CSR_RING_TAIL(csr_base_addr, bank, ring);
-}
-
-static void write_csr_ring_tail(void __iomem *csr_base_addr, u32 bank, u32 ring,
-				u32 value)
-{
-	WRITE_CSR_RING_TAIL(csr_base_addr, bank, ring, value);
-}
-
-static u32 read_csr_e_stat(void __iomem *csr_base_addr, u32 bank)
-{
-	return READ_CSR_E_STAT(csr_base_addr, bank);
-}
-
-static void write_csr_ring_config(void __iomem *csr_base_addr, u32 bank,
-				  u32 ring, u32 value)
-{
-	WRITE_CSR_RING_CONFIG(csr_base_addr, bank, ring, value);
-}
-
-static void write_csr_ring_base(void __iomem *csr_base_addr, u32 bank, u32 ring,
-				dma_addr_t addr)
-{
-	WRITE_CSR_RING_BASE(csr_base_addr, bank, ring, addr);
-}
-
-static void write_csr_int_flag(void __iomem *csr_base_addr, u32 bank, u32 value)
-{
-	WRITE_CSR_INT_FLAG(csr_base_addr, bank, value);
-}
-
-static void write_csr_int_srcsel(void __iomem *csr_base_addr, u32 bank)
-{
-	WRITE_CSR_INT_SRCSEL(csr_base_addr, bank);
-}
-
-static void write_csr_int_col_en(void __iomem *csr_base_addr, u32 bank,
-				 u32 value)
-{
-	WRITE_CSR_INT_COL_EN(csr_base_addr, bank, value);
-}
-
-static void write_csr_int_col_ctl(void __iomem *csr_base_addr, u32 bank,
-				  u32 value)
-{
-	WRITE_CSR_INT_COL_CTL(csr_base_addr, bank, value);
-}
-
-static void write_csr_int_flag_and_col(void __iomem *csr_base_addr, u32 bank,
-				       u32 value)
-{
-	WRITE_CSR_INT_FLAG_AND_COL(csr_base_addr, bank, value);
-}
-
-static void write_csr_ring_srv_arb_en(void __iomem *csr_base_addr, u32 bank,
-				      u32 value)
-{
-	WRITE_CSR_RING_SRV_ARB_EN(csr_base_addr, bank, value);
-}
-
-void adf_gen2_init_hw_csr_ops(struct adf_hw_csr_ops *csr_ops)
-{
-	csr_ops->build_csr_ring_base_addr = build_csr_ring_base_addr;
-	csr_ops->read_csr_ring_head = read_csr_ring_head;
-	csr_ops->write_csr_ring_head = write_csr_ring_head;
-	csr_ops->read_csr_ring_tail = read_csr_ring_tail;
-	csr_ops->write_csr_ring_tail = write_csr_ring_tail;
-	csr_ops->read_csr_e_stat = read_csr_e_stat;
-	csr_ops->write_csr_ring_config = write_csr_ring_config;
-	csr_ops->write_csr_ring_base = write_csr_ring_base;
-	csr_ops->write_csr_int_flag = write_csr_int_flag;
-	csr_ops->write_csr_int_srcsel = write_csr_int_srcsel;
-	csr_ops->write_csr_int_col_en = write_csr_int_col_en;
-	csr_ops->write_csr_int_col_ctl = write_csr_int_col_ctl;
-	csr_ops->write_csr_int_flag_and_col = write_csr_int_flag_and_col;
-	csr_ops->write_csr_ring_srv_arb_en = write_csr_ring_srv_arb_en;
-}
-EXPORT_SYMBOL_GPL(adf_gen2_init_hw_csr_ops);
-
 u32 adf_gen2_get_accel_cap(struct adf_accel_dev *accel_dev)
 {
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen2_hw_data.h b/drivers/crypto/intel/qat/qat_common/adf_gen2_hw_data.h
index 6bd341061de4..708e9186127b 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen2_hw_data.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen2_hw_data.h
@@ -6,78 +6,9 @@
 #include "adf_accel_devices.h"
 #include "adf_cfg_common.h"
 
-/* Transport access */
-#define ADF_BANK_INT_SRC_SEL_MASK_0	0x4444444CUL
-#define ADF_BANK_INT_SRC_SEL_MASK_X	0x44444444UL
-#define ADF_RING_CSR_RING_CONFIG	0x000
-#define ADF_RING_CSR_RING_LBASE		0x040
-#define ADF_RING_CSR_RING_UBASE		0x080
-#define ADF_RING_CSR_RING_HEAD		0x0C0
-#define ADF_RING_CSR_RING_TAIL		0x100
-#define ADF_RING_CSR_E_STAT		0x14C
-#define ADF_RING_CSR_INT_FLAG		0x170
-#define ADF_RING_CSR_INT_SRCSEL		0x174
-#define ADF_RING_CSR_INT_SRCSEL_2	0x178
-#define ADF_RING_CSR_INT_COL_EN		0x17C
-#define ADF_RING_CSR_INT_COL_CTL	0x180
-#define ADF_RING_CSR_INT_FLAG_AND_COL	0x184
-#define ADF_RING_CSR_INT_COL_CTL_ENABLE	0x80000000
-#define ADF_RING_BUNDLE_SIZE		0x1000
 #define ADF_GEN2_RX_RINGS_OFFSET	8
 #define ADF_GEN2_TX_RINGS_MASK		0xFF
 
-#define BUILD_RING_BASE_ADDR(addr, size) \
-	(((addr) >> 6) & (GENMASK_ULL(63, 0) << (size)))
-#define READ_CSR_RING_HEAD(csr_base_addr, bank, ring) \
-	ADF_CSR_RD(csr_base_addr, (ADF_RING_BUNDLE_SIZE * (bank)) + \
-		   ADF_RING_CSR_RING_HEAD + ((ring) << 2))
-#define READ_CSR_RING_TAIL(csr_base_addr, bank, ring) \
-	ADF_CSR_RD(csr_base_addr, (ADF_RING_BUNDLE_SIZE * (bank)) + \
-		   ADF_RING_CSR_RING_TAIL + ((ring) << 2))
-#define READ_CSR_E_STAT(csr_base_addr, bank) \
-	ADF_CSR_RD(csr_base_addr, (ADF_RING_BUNDLE_SIZE * (bank)) + \
-		   ADF_RING_CSR_E_STAT)
-#define WRITE_CSR_RING_CONFIG(csr_base_addr, bank, ring, value) \
-	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * (bank)) + \
-		   ADF_RING_CSR_RING_CONFIG + ((ring) << 2), value)
-#define WRITE_CSR_RING_BASE(csr_base_addr, bank, ring, value) \
-do { \
-	u32 l_base = 0, u_base = 0; \
-	l_base = (u32)((value) & 0xFFFFFFFF); \
-	u_base = (u32)(((value) & 0xFFFFFFFF00000000ULL) >> 32); \
-	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * (bank)) + \
-		   ADF_RING_CSR_RING_LBASE + ((ring) << 2), l_base); \
-	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * (bank)) + \
-		   ADF_RING_CSR_RING_UBASE + ((ring) << 2), u_base); \
-} while (0)
-
-#define WRITE_CSR_RING_HEAD(csr_base_addr, bank, ring, value) \
-	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * (bank)) + \
-		   ADF_RING_CSR_RING_HEAD + ((ring) << 2), value)
-#define WRITE_CSR_RING_TAIL(csr_base_addr, bank, ring, value) \
-	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * (bank)) + \
-		   ADF_RING_CSR_RING_TAIL + ((ring) << 2), value)
-#define WRITE_CSR_INT_FLAG(csr_base_addr, bank, value) \
-	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * (bank)) + \
-		   ADF_RING_CSR_INT_FLAG, value)
-#define WRITE_CSR_INT_SRCSEL(csr_base_addr, bank) \
-do { \
-	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * (bank)) + \
-	ADF_RING_CSR_INT_SRCSEL, ADF_BANK_INT_SRC_SEL_MASK_0); \
-	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * (bank)) + \
-	ADF_RING_CSR_INT_SRCSEL_2, ADF_BANK_INT_SRC_SEL_MASK_X); \
-} while (0)
-#define WRITE_CSR_INT_COL_EN(csr_base_addr, bank, value) \
-	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * (bank)) + \
-		   ADF_RING_CSR_INT_COL_EN, value)
-#define WRITE_CSR_INT_COL_CTL(csr_base_addr, bank, value) \
-	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * (bank)) + \
-		   ADF_RING_CSR_INT_COL_CTL, \
-		   ADF_RING_CSR_INT_COL_CTL_ENABLE | (value))
-#define WRITE_CSR_INT_FLAG_AND_COL(csr_base_addr, bank, value) \
-	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * (bank)) + \
-		   ADF_RING_CSR_INT_FLAG_AND_COL, value)
-
 /* AE to function map */
 #define AE2FUNCTION_MAP_A_OFFSET	(0x3A400 + 0x190)
 #define AE2FUNCTION_MAP_B_OFFSET	(0x3A400 + 0x310)
@@ -106,12 +37,6 @@ do { \
 #define ADF_ARB_OFFSET			0x30000
 #define ADF_ARB_WRK_2_SER_MAP_OFFSET	0x180
 #define ADF_ARB_CONFIG			(BIT(31) | BIT(6) | BIT(0))
-#define ADF_ARB_REG_SLOT		0x1000
-#define ADF_ARB_RINGSRVARBEN_OFFSET	0x19C
-
-#define WRITE_CSR_RING_SRV_ARB_EN(csr_addr, index, value) \
-	ADF_CSR_WR(csr_addr, ADF_ARB_RINGSRVARBEN_OFFSET + \
-	(ADF_ARB_REG_SLOT * (index)), value)
 
 /* Power gating */
 #define ADF_POWERGATE_DC		BIT(23)
@@ -158,7 +83,6 @@ u32 adf_gen2_get_num_aes(struct adf_hw_device_data *self);
 void adf_gen2_enable_error_correction(struct adf_accel_dev *accel_dev);
 void adf_gen2_cfg_iov_thds(struct adf_accel_dev *accel_dev, bool enable,
 			   int num_a_regs, int num_b_regs);
-void adf_gen2_init_hw_csr_ops(struct adf_hw_csr_ops *csr_ops);
 void adf_gen2_get_admin_info(struct admin_info *admin_csrs_info);
 void adf_gen2_get_arb_info(struct arb_info *arb_info);
 void adf_gen2_enable_ints(struct adf_accel_dev *accel_dev);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_csr_data.c b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_csr_data.c
new file mode 100644
index 000000000000..652ef4598930
--- /dev/null
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_csr_data.c
@@ -0,0 +1,101 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(c) 2024 Intel Corporation */
+#include <linux/types.h>
+#include "adf_gen4_hw_csr_data.h"
+
+static u64 build_csr_ring_base_addr(dma_addr_t addr, u32 size)
+{
+	return BUILD_RING_BASE_ADDR(addr, size);
+}
+
+static u32 read_csr_ring_head(void __iomem *csr_base_addr, u32 bank, u32 ring)
+{
+	return READ_CSR_RING_HEAD(csr_base_addr, bank, ring);
+}
+
+static void write_csr_ring_head(void __iomem *csr_base_addr, u32 bank, u32 ring,
+				u32 value)
+{
+	WRITE_CSR_RING_HEAD(csr_base_addr, bank, ring, value);
+}
+
+static u32 read_csr_ring_tail(void __iomem *csr_base_addr, u32 bank, u32 ring)
+{
+	return READ_CSR_RING_TAIL(csr_base_addr, bank, ring);
+}
+
+static void write_csr_ring_tail(void __iomem *csr_base_addr, u32 bank, u32 ring,
+				u32 value)
+{
+	WRITE_CSR_RING_TAIL(csr_base_addr, bank, ring, value);
+}
+
+static u32 read_csr_e_stat(void __iomem *csr_base_addr, u32 bank)
+{
+	return READ_CSR_E_STAT(csr_base_addr, bank);
+}
+
+static void write_csr_ring_config(void __iomem *csr_base_addr, u32 bank, u32 ring,
+				  u32 value)
+{
+	WRITE_CSR_RING_CONFIG(csr_base_addr, bank, ring, value);
+}
+
+static void write_csr_ring_base(void __iomem *csr_base_addr, u32 bank, u32 ring,
+				dma_addr_t addr)
+{
+	WRITE_CSR_RING_BASE(csr_base_addr, bank, ring, addr);
+}
+
+static void write_csr_int_flag(void __iomem *csr_base_addr, u32 bank,
+			       u32 value)
+{
+	WRITE_CSR_INT_FLAG(csr_base_addr, bank, value);
+}
+
+static void write_csr_int_srcsel(void __iomem *csr_base_addr, u32 bank)
+{
+	WRITE_CSR_INT_SRCSEL(csr_base_addr, bank);
+}
+
+static void write_csr_int_col_en(void __iomem *csr_base_addr, u32 bank, u32 value)
+{
+	WRITE_CSR_INT_COL_EN(csr_base_addr, bank, value);
+}
+
+static void write_csr_int_col_ctl(void __iomem *csr_base_addr, u32 bank,
+				  u32 value)
+{
+	WRITE_CSR_INT_COL_CTL(csr_base_addr, bank, value);
+}
+
+static void write_csr_int_flag_and_col(void __iomem *csr_base_addr, u32 bank,
+				       u32 value)
+{
+	WRITE_CSR_INT_FLAG_AND_COL(csr_base_addr, bank, value);
+}
+
+static void write_csr_ring_srv_arb_en(void __iomem *csr_base_addr, u32 bank,
+				      u32 value)
+{
+	WRITE_CSR_RING_SRV_ARB_EN(csr_base_addr, bank, value);
+}
+
+void adf_gen4_init_hw_csr_ops(struct adf_hw_csr_ops *csr_ops)
+{
+	csr_ops->build_csr_ring_base_addr = build_csr_ring_base_addr;
+	csr_ops->read_csr_ring_head = read_csr_ring_head;
+	csr_ops->write_csr_ring_head = write_csr_ring_head;
+	csr_ops->read_csr_ring_tail = read_csr_ring_tail;
+	csr_ops->write_csr_ring_tail = write_csr_ring_tail;
+	csr_ops->read_csr_e_stat = read_csr_e_stat;
+	csr_ops->write_csr_ring_config = write_csr_ring_config;
+	csr_ops->write_csr_ring_base = write_csr_ring_base;
+	csr_ops->write_csr_int_flag = write_csr_int_flag;
+	csr_ops->write_csr_int_srcsel = write_csr_int_srcsel;
+	csr_ops->write_csr_int_col_en = write_csr_int_col_en;
+	csr_ops->write_csr_int_col_ctl = write_csr_int_col_ctl;
+	csr_ops->write_csr_int_flag_and_col = write_csr_int_flag_and_col;
+	csr_ops->write_csr_ring_srv_arb_en = write_csr_ring_srv_arb_en;
+}
+EXPORT_SYMBOL_GPL(adf_gen4_init_hw_csr_ops);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_csr_data.h b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_csr_data.h
new file mode 100644
index 000000000000..08d803432d9f
--- /dev/null
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_csr_data.h
@@ -0,0 +1,97 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright(c) 2024 Intel Corporation */
+#ifndef ADF_GEN4_HW_CSR_DATA_H_
+#define ADF_GEN4_HW_CSR_DATA_H_
+
+#include <linux/bitops.h>
+#include "adf_accel_devices.h"
+
+#define ADF_BANK_INT_SRC_SEL_MASK	0x44UL
+#define ADF_RING_CSR_RING_CONFIG	0x1000
+#define ADF_RING_CSR_RING_LBASE		0x1040
+#define ADF_RING_CSR_RING_UBASE		0x1080
+#define ADF_RING_CSR_RING_HEAD		0x0C0
+#define ADF_RING_CSR_RING_TAIL		0x100
+#define ADF_RING_CSR_E_STAT		0x14C
+#define ADF_RING_CSR_INT_FLAG		0x170
+#define ADF_RING_CSR_INT_SRCSEL		0x174
+#define ADF_RING_CSR_INT_COL_CTL	0x180
+#define ADF_RING_CSR_INT_FLAG_AND_COL	0x184
+#define ADF_RING_CSR_INT_COL_CTL_ENABLE	0x80000000
+#define ADF_RING_CSR_INT_COL_EN		0x17C
+#define ADF_RING_CSR_ADDR_OFFSET	0x100000
+#define ADF_RING_BUNDLE_SIZE		0x2000
+#define ADF_RING_CSR_RING_SRV_ARB_EN	0x19C
+
+#define BUILD_RING_BASE_ADDR(addr, size) \
+	((((addr) >> 6) & (GENMASK_ULL(63, 0) << (size))) << 6)
+#define READ_CSR_RING_HEAD(csr_base_addr, bank, ring) \
+	ADF_CSR_RD((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
+		   ADF_RING_BUNDLE_SIZE * (bank) + \
+		   ADF_RING_CSR_RING_HEAD + ((ring) << 2))
+#define READ_CSR_RING_TAIL(csr_base_addr, bank, ring) \
+	ADF_CSR_RD((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
+		   ADF_RING_BUNDLE_SIZE * (bank) + \
+		   ADF_RING_CSR_RING_TAIL + ((ring) << 2))
+#define READ_CSR_E_STAT(csr_base_addr, bank) \
+	ADF_CSR_RD((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
+		   ADF_RING_BUNDLE_SIZE * (bank) + ADF_RING_CSR_E_STAT)
+#define WRITE_CSR_RING_CONFIG(csr_base_addr, bank, ring, value) \
+	ADF_CSR_WR((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
+		   ADF_RING_BUNDLE_SIZE * (bank) + \
+		   ADF_RING_CSR_RING_CONFIG + ((ring) << 2), value)
+#define WRITE_CSR_RING_BASE(csr_base_addr, bank, ring, value)	\
+do { \
+	void __iomem *_csr_base_addr = csr_base_addr; \
+	u32 _bank = bank;						\
+	u32 _ring = ring;						\
+	dma_addr_t _value = value;					\
+	u32 l_base = 0, u_base = 0;					\
+	l_base = lower_32_bits(_value);					\
+	u_base = upper_32_bits(_value);					\
+	ADF_CSR_WR((_csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET,		\
+		   ADF_RING_BUNDLE_SIZE * (_bank) +			\
+		   ADF_RING_CSR_RING_LBASE + ((_ring) << 2), l_base);	\
+	ADF_CSR_WR((_csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET,		\
+		   ADF_RING_BUNDLE_SIZE * (_bank) +			\
+		   ADF_RING_CSR_RING_UBASE + ((_ring) << 2), u_base);	\
+} while (0)
+
+#define WRITE_CSR_RING_HEAD(csr_base_addr, bank, ring, value) \
+	ADF_CSR_WR((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
+		   ADF_RING_BUNDLE_SIZE * (bank) + \
+		   ADF_RING_CSR_RING_HEAD + ((ring) << 2), value)
+#define WRITE_CSR_RING_TAIL(csr_base_addr, bank, ring, value) \
+	ADF_CSR_WR((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
+		   ADF_RING_BUNDLE_SIZE * (bank) + \
+		   ADF_RING_CSR_RING_TAIL + ((ring) << 2), value)
+#define WRITE_CSR_INT_FLAG(csr_base_addr, bank, value) \
+	ADF_CSR_WR((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
+		   ADF_RING_BUNDLE_SIZE * (bank) + \
+		   ADF_RING_CSR_INT_FLAG, (value))
+#define WRITE_CSR_INT_SRCSEL(csr_base_addr, bank) \
+	ADF_CSR_WR((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
+		   ADF_RING_BUNDLE_SIZE * (bank) + \
+		   ADF_RING_CSR_INT_SRCSEL, ADF_BANK_INT_SRC_SEL_MASK)
+#define WRITE_CSR_INT_COL_EN(csr_base_addr, bank, value) \
+	ADF_CSR_WR((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
+		   ADF_RING_BUNDLE_SIZE * (bank) + \
+		   ADF_RING_CSR_INT_COL_EN, (value))
+#define WRITE_CSR_INT_COL_CTL(csr_base_addr, bank, value) \
+	ADF_CSR_WR((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
+		   ADF_RING_BUNDLE_SIZE * (bank) + \
+		   ADF_RING_CSR_INT_COL_CTL, \
+		   ADF_RING_CSR_INT_COL_CTL_ENABLE | (value))
+#define WRITE_CSR_INT_FLAG_AND_COL(csr_base_addr, bank, value) \
+	ADF_CSR_WR((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
+		   ADF_RING_BUNDLE_SIZE * (bank) + \
+		   ADF_RING_CSR_INT_FLAG_AND_COL, (value))
+
+#define WRITE_CSR_RING_SRV_ARB_EN(csr_base_addr, bank, value) \
+	ADF_CSR_WR((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
+		   ADF_RING_BUNDLE_SIZE * (bank) + \
+		   ADF_RING_CSR_RING_SRV_ARB_EN, (value))
+
+void adf_gen4_init_hw_csr_ops(struct adf_hw_csr_ops *csr_ops);
+
+#endif
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c
index b8a6d24f791f..12269e309fbf 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c
@@ -8,103 +8,6 @@
 #include "adf_gen4_hw_data.h"
 #include "adf_gen4_pm.h"
 
-static u64 build_csr_ring_base_addr(dma_addr_t addr, u32 size)
-{
-	return BUILD_RING_BASE_ADDR(addr, size);
-}
-
-static u32 read_csr_ring_head(void __iomem *csr_base_addr, u32 bank, u32 ring)
-{
-	return READ_CSR_RING_HEAD(csr_base_addr, bank, ring);
-}
-
-static void write_csr_ring_head(void __iomem *csr_base_addr, u32 bank, u32 ring,
-				u32 value)
-{
-	WRITE_CSR_RING_HEAD(csr_base_addr, bank, ring, value);
-}
-
-static u32 read_csr_ring_tail(void __iomem *csr_base_addr, u32 bank, u32 ring)
-{
-	return READ_CSR_RING_TAIL(csr_base_addr, bank, ring);
-}
-
-static void write_csr_ring_tail(void __iomem *csr_base_addr, u32 bank, u32 ring,
-				u32 value)
-{
-	WRITE_CSR_RING_TAIL(csr_base_addr, bank, ring, value);
-}
-
-static u32 read_csr_e_stat(void __iomem *csr_base_addr, u32 bank)
-{
-	return READ_CSR_E_STAT(csr_base_addr, bank);
-}
-
-static void write_csr_ring_config(void __iomem *csr_base_addr, u32 bank, u32 ring,
-				  u32 value)
-{
-	WRITE_CSR_RING_CONFIG(csr_base_addr, bank, ring, value);
-}
-
-static void write_csr_ring_base(void __iomem *csr_base_addr, u32 bank, u32 ring,
-				dma_addr_t addr)
-{
-	WRITE_CSR_RING_BASE(csr_base_addr, bank, ring, addr);
-}
-
-static void write_csr_int_flag(void __iomem *csr_base_addr, u32 bank,
-			       u32 value)
-{
-	WRITE_CSR_INT_FLAG(csr_base_addr, bank, value);
-}
-
-static void write_csr_int_srcsel(void __iomem *csr_base_addr, u32 bank)
-{
-	WRITE_CSR_INT_SRCSEL(csr_base_addr, bank);
-}
-
-static void write_csr_int_col_en(void __iomem *csr_base_addr, u32 bank, u32 value)
-{
-	WRITE_CSR_INT_COL_EN(csr_base_addr, bank, value);
-}
-
-static void write_csr_int_col_ctl(void __iomem *csr_base_addr, u32 bank,
-				  u32 value)
-{
-	WRITE_CSR_INT_COL_CTL(csr_base_addr, bank, value);
-}
-
-static void write_csr_int_flag_and_col(void __iomem *csr_base_addr, u32 bank,
-				       u32 value)
-{
-	WRITE_CSR_INT_FLAG_AND_COL(csr_base_addr, bank, value);
-}
-
-static void write_csr_ring_srv_arb_en(void __iomem *csr_base_addr, u32 bank,
-				      u32 value)
-{
-	WRITE_CSR_RING_SRV_ARB_EN(csr_base_addr, bank, value);
-}
-
-void adf_gen4_init_hw_csr_ops(struct adf_hw_csr_ops *csr_ops)
-{
-	csr_ops->build_csr_ring_base_addr = build_csr_ring_base_addr;
-	csr_ops->read_csr_ring_head = read_csr_ring_head;
-	csr_ops->write_csr_ring_head = write_csr_ring_head;
-	csr_ops->read_csr_ring_tail = read_csr_ring_tail;
-	csr_ops->write_csr_ring_tail = write_csr_ring_tail;
-	csr_ops->read_csr_e_stat = read_csr_e_stat;
-	csr_ops->write_csr_ring_config = write_csr_ring_config;
-	csr_ops->write_csr_ring_base = write_csr_ring_base;
-	csr_ops->write_csr_int_flag = write_csr_int_flag;
-	csr_ops->write_csr_int_srcsel = write_csr_int_srcsel;
-	csr_ops->write_csr_int_col_en = write_csr_int_col_en;
-	csr_ops->write_csr_int_col_ctl = write_csr_int_col_ctl;
-	csr_ops->write_csr_int_flag_and_col = write_csr_int_flag_and_col;
-	csr_ops->write_csr_ring_srv_arb_en = write_csr_ring_srv_arb_en;
-}
-EXPORT_SYMBOL_GPL(adf_gen4_init_hw_csr_ops);
-
 u32 adf_gen4_get_accel_mask(struct adf_hw_device_data *self)
 {
 	return ADF_GEN4_ACCELERATORS_MASK;
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.h b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.h
index c153f41162ec..719f7757e587 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: (BSD-3-Clause OR GPL-2.0-only) */
 /* Copyright(c) 2020 Intel Corporation */
-#ifndef ADF_GEN4_HW_CSR_DATA_H_
-#define ADF_GEN4_HW_CSR_DATA_H_
+#ifndef ADF_GEN4_HW_DATA_H_
+#define ADF_GEN4_HW_DATA_H_
 
 #include <linux/units.h>
 
@@ -54,95 +54,6 @@
 #define ADF_GEN4_ADMINMSGLR_OFFSET	0x500578
 #define ADF_GEN4_MAILBOX_BASE_OFFSET	0x600970
 
-/* Transport access */
-#define ADF_BANK_INT_SRC_SEL_MASK	0x44UL
-#define ADF_RING_CSR_RING_CONFIG	0x1000
-#define ADF_RING_CSR_RING_LBASE		0x1040
-#define ADF_RING_CSR_RING_UBASE		0x1080
-#define ADF_RING_CSR_RING_HEAD		0x0C0
-#define ADF_RING_CSR_RING_TAIL		0x100
-#define ADF_RING_CSR_E_STAT		0x14C
-#define ADF_RING_CSR_INT_FLAG		0x170
-#define ADF_RING_CSR_INT_SRCSEL		0x174
-#define ADF_RING_CSR_INT_COL_CTL	0x180
-#define ADF_RING_CSR_INT_FLAG_AND_COL	0x184
-#define ADF_RING_CSR_INT_COL_CTL_ENABLE	0x80000000
-#define ADF_RING_CSR_INT_COL_EN		0x17C
-#define ADF_RING_CSR_ADDR_OFFSET	0x100000
-#define ADF_RING_BUNDLE_SIZE		0x2000
-
-#define BUILD_RING_BASE_ADDR(addr, size) \
-	((((addr) >> 6) & (GENMASK_ULL(63, 0) << (size))) << 6)
-#define READ_CSR_RING_HEAD(csr_base_addr, bank, ring) \
-	ADF_CSR_RD((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
-		   ADF_RING_BUNDLE_SIZE * (bank) + \
-		   ADF_RING_CSR_RING_HEAD + ((ring) << 2))
-#define READ_CSR_RING_TAIL(csr_base_addr, bank, ring) \
-	ADF_CSR_RD((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
-		   ADF_RING_BUNDLE_SIZE * (bank) + \
-		   ADF_RING_CSR_RING_TAIL + ((ring) << 2))
-#define READ_CSR_E_STAT(csr_base_addr, bank) \
-	ADF_CSR_RD((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
-		   ADF_RING_BUNDLE_SIZE * (bank) + ADF_RING_CSR_E_STAT)
-#define WRITE_CSR_RING_CONFIG(csr_base_addr, bank, ring, value) \
-	ADF_CSR_WR((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
-		   ADF_RING_BUNDLE_SIZE * (bank) + \
-		   ADF_RING_CSR_RING_CONFIG + ((ring) << 2), value)
-#define WRITE_CSR_RING_BASE(csr_base_addr, bank, ring, value)	\
-do { \
-	void __iomem *_csr_base_addr = csr_base_addr; \
-	u32 _bank = bank;						\
-	u32 _ring = ring;						\
-	dma_addr_t _value = value;					\
-	u32 l_base = 0, u_base = 0;					\
-	l_base = lower_32_bits(_value);					\
-	u_base = upper_32_bits(_value);					\
-	ADF_CSR_WR((_csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET,		\
-		   ADF_RING_BUNDLE_SIZE * (_bank) +			\
-		   ADF_RING_CSR_RING_LBASE + ((_ring) << 2), l_base);	\
-	ADF_CSR_WR((_csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET,		\
-		   ADF_RING_BUNDLE_SIZE * (_bank) +			\
-		   ADF_RING_CSR_RING_UBASE + ((_ring) << 2), u_base);	\
-} while (0)
-
-#define WRITE_CSR_RING_HEAD(csr_base_addr, bank, ring, value) \
-	ADF_CSR_WR((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
-		   ADF_RING_BUNDLE_SIZE * (bank) + \
-		   ADF_RING_CSR_RING_HEAD + ((ring) << 2), value)
-#define WRITE_CSR_RING_TAIL(csr_base_addr, bank, ring, value) \
-	ADF_CSR_WR((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
-		   ADF_RING_BUNDLE_SIZE * (bank) + \
-		   ADF_RING_CSR_RING_TAIL + ((ring) << 2), value)
-#define WRITE_CSR_INT_FLAG(csr_base_addr, bank, value) \
-	ADF_CSR_WR((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
-		   ADF_RING_BUNDLE_SIZE * (bank) + \
-		   ADF_RING_CSR_INT_FLAG, (value))
-#define WRITE_CSR_INT_SRCSEL(csr_base_addr, bank) \
-	ADF_CSR_WR((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
-		   ADF_RING_BUNDLE_SIZE * (bank) + \
-		   ADF_RING_CSR_INT_SRCSEL, ADF_BANK_INT_SRC_SEL_MASK)
-#define WRITE_CSR_INT_COL_EN(csr_base_addr, bank, value) \
-	ADF_CSR_WR((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
-		   ADF_RING_BUNDLE_SIZE * (bank) + \
-		   ADF_RING_CSR_INT_COL_EN, (value))
-#define WRITE_CSR_INT_COL_CTL(csr_base_addr, bank, value) \
-	ADF_CSR_WR((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
-		   ADF_RING_BUNDLE_SIZE * (bank) + \
-		   ADF_RING_CSR_INT_COL_CTL, \
-		   ADF_RING_CSR_INT_COL_CTL_ENABLE | (value))
-#define WRITE_CSR_INT_FLAG_AND_COL(csr_base_addr, bank, value) \
-	ADF_CSR_WR((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
-		   ADF_RING_BUNDLE_SIZE * (bank) + \
-		   ADF_RING_CSR_INT_FLAG_AND_COL, (value))
-
-/* Arbiter configuration */
-#define ADF_RING_CSR_RING_SRV_ARB_EN 0x19C
-
-#define WRITE_CSR_RING_SRV_ARB_EN(csr_base_addr, bank, value) \
-	ADF_CSR_WR((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
-		   ADF_RING_BUNDLE_SIZE * (bank) + \
-		   ADF_RING_CSR_RING_SRV_ARB_EN, (value))
-
 /* Default ring mapping */
 #define ADF_GEN4_DEFAULT_RING_TO_SRV_MAP \
 	(ASYM << ADF_CFG_SERV_RING_PAIR_0_SHIFT | \
@@ -234,7 +145,6 @@ u32 adf_gen4_get_num_aes(struct adf_hw_device_data *self);
 enum dev_sku_info adf_gen4_get_sku(struct adf_hw_device_data *self);
 u32 adf_gen4_get_sram_bar_id(struct adf_hw_device_data *self);
 int adf_gen4_init_device(struct adf_accel_dev *accel_dev);
-void adf_gen4_init_hw_csr_ops(struct adf_hw_csr_ops *csr_ops);
 int adf_gen4_ring_pair_reset(struct adf_accel_dev *accel_dev, u32 bank_number);
 void adf_gen4_set_msix_default_rttable(struct adf_accel_dev *accel_dev);
 void adf_gen4_set_ssm_wdtimer(struct adf_accel_dev *accel_dev);
diff --git a/drivers/crypto/intel/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c b/drivers/crypto/intel/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
index af14090cc4be..6e24d57e6b98 100644
--- a/drivers/crypto/intel/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
@@ -5,6 +5,7 @@
 #include <adf_common_drv.h>
 #include <adf_gen2_config.h>
 #include <adf_gen2_dc.h>
+#include <adf_gen2_hw_csr_data.h>
 #include <adf_gen2_hw_data.h>
 #include <adf_gen2_pfvf.h>
 #include "adf_dh895xcc_hw_data.h"
diff --git a/drivers/crypto/intel/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c b/drivers/crypto/intel/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
index 70e56cc16ece..f4ee4c2e00da 100644
--- a/drivers/crypto/intel/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
@@ -4,6 +4,7 @@
 #include <adf_common_drv.h>
 #include <adf_gen2_config.h>
 #include <adf_gen2_dc.h>
+#include <adf_gen2_hw_csr_data.h>
 #include <adf_gen2_hw_data.h>
 #include <adf_gen2_pfvf.h>
 #include <adf_pfvf_vf_msg.h>
-- 
2.18.2


