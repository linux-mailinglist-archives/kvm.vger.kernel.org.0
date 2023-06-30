Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC21D743C86
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 15:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232516AbjF3NSf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 09:18:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232515AbjF3NSc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 09:18:32 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E1E23AB6;
        Fri, 30 Jun 2023 06:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688131105; x=1719667105;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=StEvO1xYS5kHG9q1Lkn0Rhnrs37qqoTChdPdQ4ZD6BQ=;
  b=GE4OL1GXePlfvhtQLsPN30q0noWVWQTqtyzVcxbiR6+e/sNEAKdyw/08
   Jmbh+UIW8nq9QSVJdq69qFAX6a/DVJa8mtX7cZmXqf2OPxtzrOKdT98Jm
   ODN3V2Uz8ulR2UgMuV+n5rDkzRXvXoGTWTgV3drBD0TMMBx9iIbAAjsuv
   /aW80HGwuHNvp6c0ijMmOImNo83kVZYuEmMgGFL0Izd0zPtPepAs9zpW0
   PG9RpJNtEhoE1FaAXJB0bmMExy3wfCBjohPUQSCLD6VZwPh11KxQyEVnD
   BtPsYcuNrMKs77qLzUYqCZ7D/myN+BSuWAm5S9mzXKbCsPZbpQGlIF0pA
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10756"; a="362433167"
X-IronPort-AV: E=Sophos;i="6.01,170,1684825200"; 
   d="scan'208";a="362433167"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2023 06:18:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10756"; a="783077988"
X-IronPort-AV: E=Sophos;i="6.01,170,1684825200"; 
   d="scan'208";a="783077988"
Received: from qat-server-archercity1.sh.intel.com ([10.67.111.115])
  by fmsmga008.fm.intel.com with ESMTP; 30 Jun 2023 06:18:15 -0700
From:   Xin Zeng <xin.zeng@intel.com>
To:     linux-crypto@vger.kernel.org, kvm@vger.kernel.org
Cc:     giovanni.cabiddu@intel.com, andriy.shevchenko@linux.intel.com,
        Xin Zeng <xin.zeng@intel.com>,
        Siming Wan <siming.wan@intel.com>
Subject: [RFC 4/5] crypto: qat - implement interface for live migration
Date:   Fri, 30 Jun 2023 21:13:03 +0800
Message-Id: <20230630131304.64243-5-xin.zeng@intel.com>
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

Add logic to implement interface for live migration for QAT GEN4 Virtual
Functions (VFs).
This introduces a migration data manager which is used to hold the
device state during migration.

The VF state is organized in a section hierarchy, as reported below:
    preamble | general state section | leaf state
             | MISC bar state section| leaf state
             | ETR bar state section | bank0 state section | leaf state
                                     | bank1 state section | leaf state
                                     | bank2 state section | leaf state
                                     | bank3 state section | leaf state

Co-developed-by: Siming Wan <siming.wan@intel.com>
Signed-off-by: Siming Wan <siming.wan@intel.com>
Signed-off-by: Xin Zeng <xin.zeng@intel.com>
---
 .../intel/qat/qat_4xxx/adf_4xxx_hw_data.c     |   4 +-
 .../intel/qat/qat_4xxx/adf_4xxx_hw_data.h     |   3 +-
 drivers/crypto/intel/qat/qat_common/Makefile  |   2 +
 .../intel/qat/qat_common/adf_accel_devices.h  |   5 +
 .../intel/qat/qat_common/adf_gen4_hw_data.c   |  53 ++
 .../intel/qat/qat_common/adf_gen4_hw_data.h   |  21 +
 .../intel/qat/qat_common/adf_gen4_pfvf.c      |   7 +-
 .../intel/qat/qat_common/adf_gen4_pfvf.h      |   7 +
 .../intel/qat/qat_common/adf_gen4_vf_mig.c    | 609 ++++++++++++++++++
 .../intel/qat/qat_common/adf_mstate_mgr.c     | 267 ++++++++
 .../intel/qat/qat_common/adf_mstate_mgr.h     |  99 +++
 11 files changed, 1070 insertions(+), 7 deletions(-)
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen4_vf_mig.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_mstate_mgr.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_mstate_mgr.h

diff --git a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
index 22fe4e6834c1..e859350bdfb0 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -455,7 +455,7 @@ void adf_init_hw_data_4xxx(struct adf_hw_device_data *hw_data, u32 dev_id)
 	hw_data->dev_class = &adf_4xxx_class;
 	hw_data->instance_id = adf_4xxx_class.instances++;
 	hw_data->num_banks = ADF_4XXX_ETR_MAX_BANKS;
-	hw_data->num_banks_per_vf = ADF_4XXX_NUM_BANKS_PER_VF;
+	hw_data->num_banks_per_vf = ADF_GEN4_NUM_BANKS_PER_VF;
 	hw_data->num_rings_per_bank = ADF_4XXX_NUM_RINGS_PER_BANK;
 	hw_data->num_accel = ADF_4XXX_MAX_ACCELERATORS;
 	hw_data->num_engines = ADF_4XXX_MAX_ACCELENGINES;
@@ -487,6 +487,7 @@ void adf_init_hw_data_4xxx(struct adf_hw_device_data *hw_data, u32 dev_id)
 	hw_data->init_device = adf_init_device;
 	hw_data->reset_device = adf_reset_flr;
 	hw_data->admin_ae_mask = ADF_4XXX_ADMIN_AE_MASK;
+	hw_data->clock_frequency = ADF_4XXX_AE_FREQ;
 	switch (dev_id) {
 	case ADF_402XX_PCI_DEVICE_ID:
 		hw_data->fw_name = ADF_402XX_FW;
@@ -515,6 +516,7 @@ void adf_init_hw_data_4xxx(struct adf_hw_device_data *hw_data, u32 dev_id)
 	adf_gen4_init_hw_csr_ops(&hw_data->csr_info);
 	adf_gen4_init_pf_pfvf_ops(&hw_data->pfvf_ops);
 	adf_gen4_init_dc_ops(&hw_data->dc_ops);
+	adf_gen4_init_vf_mig_ops(&hw_data->vfmig_ops);
 }
 
 void adf_clean_hw_data_4xxx(struct adf_hw_device_data *hw_data)
diff --git a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.h b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.h
index e5b314d2b60e..1f96c7f8ca6f 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.h
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.h
@@ -3,6 +3,7 @@
 #ifndef ADF_4XXX_HW_DATA_H_
 #define ADF_4XXX_HW_DATA_H_
 
+#include <linux/units.h>
 #include <adf_accel_devices.h>
 
 /* PCIe configuration space */
@@ -26,6 +27,7 @@
 #define ADF_4XXX_ACCELERATORS_MASK	(0x1)
 #define ADF_4XXX_ACCELENGINES_MASK	(0x1FF)
 #define ADF_4XXX_ADMIN_AE_MASK		(0x100)
+#define ADF_4XXX_AE_FREQ		(1 * HZ_PER_GHZ)
 
 #define ADF_4XXX_ETR_MAX_BANKS		64
 
@@ -37,7 +39,6 @@
 
 /* Bank and ring configuration */
 #define ADF_4XXX_NUM_RINGS_PER_BANK	2
-#define ADF_4XXX_NUM_BANKS_PER_VF	4
 
 /* Arbiter configuration */
 #define ADF_4XXX_ARB_CONFIG			(BIT(31) | BIT(6) | BIT(0))
diff --git a/drivers/crypto/intel/qat/qat_common/Makefile b/drivers/crypto/intel/qat/qat_common/Makefile
index 3855f2fa5733..e0de2d0901f9 100644
--- a/drivers/crypto/intel/qat/qat_common/Makefile
+++ b/drivers/crypto/intel/qat/qat_common/Makefile
@@ -14,9 +14,11 @@ intel_qat-objs := adf_cfg.o \
 	adf_gen2_hw_data.o \
 	adf_gen2_config.o \
 	adf_gen4_hw_data.o \
+	adf_gen4_vf_mig.o \
 	adf_gen4_pm.o \
 	adf_gen2_dc.o \
 	adf_gen4_dc.o \
+	adf_mstate_mgr.o \
 	qat_crypto.o \
 	qat_compression.o \
 	qat_comp_algs.o \
diff --git a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
index adda2cac6af1..b21a38e776a7 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
@@ -339,6 +339,11 @@ struct adf_accel_vf_info {
 	u32 vf_nr;
 	bool init;
 	u8 vf_compat_ver;
+	/*
+	 * Private area used for device migration.
+	 * Memory allocation and free is managed by migration driver.
+	 */
+	void *mig_priv;
 };
 
 struct adf_dc_data {
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c
index 924d51ebd3c3..8b4d17d8b178 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: (BSD-3-Clause OR GPL-2.0-only)
 /* Copyright(c) 2020 Intel Corporation */
 #include <linux/iopoll.h>
+#include <asm/div64.h>
 #include "adf_accel_devices.h"
 #include "adf_common_drv.h"
 #include "adf_gen4_hw_data.h"
@@ -310,6 +311,58 @@ int adf_gen4_ring_pair_reset(struct adf_accel_dev *accel_dev, u32 bank_number)
 }
 EXPORT_SYMBOL_GPL(adf_gen4_ring_pair_reset);
 
+int adf_gen4_rp_quiesce_coal_timer(struct adf_accel_dev *accel_dev,
+				   u32 bank_idx, int timeout_ms)
+{
+	u32 int_col_ctl, int_col_mask, int_col_en;
+	struct adf_hw_device_data *hw_data;
+	struct adf_bar *etr_bar, *misc_bar;
+	void __iomem *csr_etr, *csr_misc;
+	struct adf_hw_csr_ops *csr_ops;
+	u32 e_stat, intsrc;
+	u64 wait_us;
+	int ret;
+
+	if (timeout_ms < 0)
+		return -EINVAL;
+
+	hw_data = GET_HW_DATA(accel_dev);
+	csr_ops = GET_CSR_OPS(accel_dev);
+	etr_bar = &GET_BARS(accel_dev)[hw_data->get_etr_bar_id(hw_data)];
+	misc_bar = &GET_BARS(accel_dev)[hw_data->get_misc_bar_id(hw_data)];
+	csr_etr = etr_bar->virt_addr;
+	csr_misc = misc_bar->virt_addr;
+
+	int_col_ctl = csr_ops->read_csr_int_col_ctl(csr_etr, bank_idx);
+	int_col_mask = csr_ops->get_int_col_ctl_enable_mask();
+	if (!(int_col_ctl & int_col_mask))
+		return 0;
+
+	int_col_en = csr_ops->read_csr_int_col_en(csr_etr, bank_idx);
+	int_col_en &= BIT(ADF_WQM_CSR_RP_IDX_RX);
+	e_stat = csr_ops->read_csr_e_stat(csr_etr, bank_idx);
+	if (!(~e_stat & int_col_en))
+		return 0;
+
+	wait_us = 2 * ((int_col_ctl & ~int_col_mask) << 8) * USEC_PER_SEC;
+	do_div(wait_us, hw_data->clock_frequency);
+	wait_us = min(wait_us, (u64)timeout_ms * USEC_PER_MSEC);
+	dev_dbg(&GET_DEV(accel_dev),
+		"wait for bank %d coalesced timer expiration in %llu us. (max=%u ms estat=0x%x intcolen=0x%x)\n",
+		bank_idx, wait_us, timeout_ms, e_stat, int_col_en);
+
+	ret = read_poll_timeout(ADF_CSR_RD, intsrc, intsrc,
+				ADF_COALESCED_POLL_DELAY_US, wait_us, true,
+				csr_misc, ADF_WQM_CSR_RPINTSTS(bank_idx));
+	if (ret)
+		dev_warn(&GET_DEV(accel_dev),
+			 "waits(%llu us) for bank %d coalesced timer ran out\n",
+			 wait_us, bank_idx);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(adf_gen4_rp_quiesce_coal_timer);
+
 static int drain_ring_pair(void __iomem *csr, u32 bank_number, int timeout_us)
 {
 	u32 status;
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.h b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.h
index d2a4192aaa6d..29774841af39 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.h
@@ -7,6 +7,9 @@
 #include "adf_accel_devices.h"
 #include "adf_cfg_common.h"
 
+/* Bank configuration */
+#define ADF_GEN4_NUM_BANKS_PER_VF	4
+
 /* Transport access */
 #define ADF_RINGS_PER_INT_SRCSEL	BIT(1)
 #define ADF_BANK_INT_SRC_SEL_MASK	0x44UL
@@ -237,6 +240,13 @@ static inline u64 read_base(void __iomem *csr_base_addr,
 /* Ring drain */
 #define ADF_WQM_CSR_RPRESETCTL_DRAIN	BIT(2)
 
+/* Ring interrupt*/
+#define ADF_COALESCED_POLL_TIMEOUT_US	(1 * USEC_PER_SEC)
+#define ADF_COALESCED_POLL_DELAY_US	1000
+#define ADF_WQM_CSR_RPINTSTS(bank)	(0x200000 + ((bank) << 12))
+
+#define ADF_WQM_CSR_RP_IDX_RX		1
+
 /* Error source registers */
 #define ADF_GEN4_ERRSOU0	(0x41A200)
 #define ADF_GEN4_ERRSOU1	(0x41A204)
@@ -251,13 +261,24 @@ static inline u64 read_base(void __iomem *csr_base_addr,
 
 #define ADF_GEN4_VFLNOTIFY	BIT(7)
 
+/* Number of heartbeat counter pairs */
+#define ADF_NUM_HB_CNT_PER_AE ADF_NUM_THREADS_PER_AE
+
+struct adf_gen4_vfmig {
+	u32 ringsrvarben[ADF_GEN4_NUM_BANKS_PER_VF];
+	void *mstate_mgr;
+};
+
 void adf_gen4_set_ssm_wdtimer(struct adf_accel_dev *accel_dev);
 void adf_gen4_init_hw_csr_ops(struct adf_hw_csr_info *csr_info);
 int adf_gen4_ring_pair_reset(struct adf_accel_dev *accel_dev, u32 bank_number);
 int adf_gen4_ring_pair_drain(struct adf_accel_dev *accel_dev, u32 bank_number,
 			     int timeout_us);
+int adf_gen4_rp_quiesce_coal_timer(struct adf_accel_dev *accel_dev,
+				   u32 bank_idx, int timeout_ms);
 int adf_gen4_bank_state_save(struct adf_accel_dev *accel_dev, u32 bank_number,
 			     struct bank_state *state);
 int adf_gen4_bank_state_restore(struct adf_accel_dev *accel_dev,
 				u32 bank_number, struct bank_state *state);
+void adf_gen4_init_vf_mig_ops(struct adf_vfmig_ops *vfmig_ops);
 #endif
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_pfvf.c b/drivers/crypto/intel/qat/qat_common/adf_gen4_pfvf.c
index 8e8efe93f3ee..fe202ab3bc9d 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_pfvf.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_pfvf.c
@@ -9,9 +9,6 @@
 #include "adf_pfvf_pf_proto.h"
 #include "adf_pfvf_utils.h"
 
-#define ADF_4XXX_PF2VM_OFFSET(i)	(0x40B010 + ((i) * 0x20))
-#define ADF_4XXX_VM2PF_OFFSET(i)	(0x40B014 + ((i) * 0x20))
-
 /* VF2PF interrupt source registers */
 #define ADF_4XXX_VM2PF_SOU		0x41A180
 #define ADF_4XXX_VM2PF_MSK		0x41A1C0
@@ -29,12 +26,12 @@ static const struct pfvf_csr_format csr_gen4_fmt = {
 
 static u32 adf_gen4_pf_get_pf2vf_offset(u32 i)
 {
-	return ADF_4XXX_PF2VM_OFFSET(i);
+	return ADF_GEN4_PF2VM_OFFSET(i);
 }
 
 static u32 adf_gen4_pf_get_vf2pf_offset(u32 i)
 {
-	return ADF_4XXX_VM2PF_OFFSET(i);
+	return ADF_GEN4_VM2PF_OFFSET(i);
 }
 
 static void adf_gen4_enable_vf2pf_interrupts(void __iomem *pmisc_addr, u32 vf_mask)
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_pfvf.h b/drivers/crypto/intel/qat/qat_common/adf_gen4_pfvf.h
index 17d1b774d4a8..38edf02dbf8d 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_pfvf.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_pfvf.h
@@ -5,6 +5,13 @@
 
 #include "adf_accel_devices.h"
 
+#define ADF_GEN4_PF2VM_OFFSET(i)	(0x40B010 + (i) * 0x20)
+#define ADF_GEN4_VM2PF_OFFSET(i)	(0x40B014 + (i) * 0x20)
+#define ADF_GEN4_VINTMSKPF2VM_OFFSET(i)	(0x40B00C + (i) * 0x20)
+#define ADF_GEN4_VINTSOUPF2VM_OFFSET(i)	(0x40B008 + (i) * 0x20)
+#define ADF_GEN4_VINTMSK_OFFSET(i)	(0x40B004 + (i) * 0x20)
+#define ADF_GEN4_VINTSOU_OFFSET(i)	(0x40B000 + (i) * 0x20)
+
 #ifdef CONFIG_PCI_IOV
 void adf_gen4_init_pf_pfvf_ops(struct adf_pfvf_ops *pfvf_ops);
 #else
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_vf_mig.c b/drivers/crypto/intel/qat/qat_common/adf_gen4_vf_mig.c
new file mode 100644
index 000000000000..48ac192d3b53
--- /dev/null
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_vf_mig.c
@@ -0,0 +1,609 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(c) 2023 Intel Corporation */
+#include <linux/dev_printk.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/types.h>
+#include <asm/errno.h>
+#include "adf_accel_devices.h"
+#include "adf_common_drv.h"
+#include "adf_gen4_hw_data.h"
+#include "adf_gen4_pfvf.h"
+#include "adf_mstate_mgr.h"
+
+static int adf_gen4_vfmig_init_device(struct adf_accel_dev *accel_dev, u32 vf_nr)
+{
+	struct adf_accel_vf_info *vf_info = &accel_dev->pf.vf_info[vf_nr];
+	struct adf_gen4_vfmig *vfmig;
+
+	vfmig = kzalloc(sizeof(*vfmig), GFP_KERNEL);
+	if (!vfmig)
+		return -ENOMEM;
+
+	vfmig->mstate_mgr = adf_mstate_mgr_new(NULL, 0);
+	if (!vfmig->mstate_mgr)
+		return -ENOMEM;
+
+	vf_info->mig_priv = vfmig;
+
+	return 0;
+}
+
+static void adf_gen4_vfmig_shutdown_device(struct adf_accel_dev *accel_dev, u32 vf_nr)
+{
+	struct adf_accel_vf_info *vf_info = &accel_dev->pf.vf_info[vf_nr];
+	struct adf_gen4_vfmig *vfmig;
+
+	if (vf_info->mig_priv) {
+		vfmig = vf_info->mig_priv;
+		adf_mstate_mgr_destroy(vfmig->mstate_mgr);
+		kfree(vfmig);
+		vf_info->mig_priv = NULL;
+	}
+}
+
+static int adf_gen4_vfmig_suspend_device(struct adf_accel_dev *accel_dev, u32 vf_nr)
+{
+	struct adf_accel_vf_info *vf_info = &accel_dev->pf.vf_info[vf_nr];
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	struct adf_gen4_vfmig *vfmig = vf_info->mig_priv;
+	int ret, i;
+
+	/* Drain all inflight jobs */
+	for (i = 0; i < hw_data->num_banks_per_vf; i++) {
+		struct adf_hw_csr_ops *csr_ops = &hw_data->csr_info.csr_ops;
+		u32 etr_bar_id = hw_data->get_etr_bar_id(hw_data);
+		void __iomem *csr = (&GET_BARS(accel_dev)[etr_bar_id])->virt_addr;
+		u32 pf_bank_number = i + vf_nr * hw_data->num_banks_per_vf;
+		u32 arben;
+
+		arben = csr_ops->read_csr_ring_srv_arb_en(csr, pf_bank_number) &
+			hw_data->csr_info.arb_enable_mask;
+		if (arben)
+			csr_ops->write_csr_ring_srv_arb_en(csr, pf_bank_number, 0);
+
+		vfmig->ringsrvarben[i] = arben;
+
+		ret = hw_data->ring_pair_drain(accel_dev, pf_bank_number,
+					       ADF_RPRESET_POLL_TIMEOUT_US);
+		if (ret) {
+			dev_err(&GET_DEV(accel_dev), "Ring pair drain for VF%d failure\n",
+				vf_nr);
+			return ret;
+		}
+
+		adf_gen4_rp_quiesce_coal_timer(accel_dev, pf_bank_number,
+					       ADF_COALESCED_POLL_TIMEOUT_US);
+	}
+
+	return 0;
+}
+
+static int adf_gen4_vfmig_resume_device(struct adf_accel_dev *accel_dev, u32 vf_nr)
+{
+	struct adf_accel_vf_info *vf_info = &accel_dev->pf.vf_info[vf_nr];
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	struct adf_gen4_vfmig *vfmig = vf_info->mig_priv;
+	int i;
+
+	/* Restore ringsrvarben to resume device */
+	for (i = 0; i < hw_data->num_banks_per_vf; i++) {
+		u32 etr_bar_id = hw_data->get_etr_bar_id(hw_data);
+		void __iomem *csr = (&GET_BARS(accel_dev)[etr_bar_id])->virt_addr;
+		struct adf_hw_csr_ops *csr_ops = &hw_data->csr_info.csr_ops;
+		u32 pf_bank_number = i + vf_nr * hw_data->num_banks_per_vf;
+
+		csr_ops->write_csr_ring_srv_arb_en(csr, pf_bank_number,
+						   vfmig->ringsrvarben[i]);
+	}
+
+	return 0;
+}
+
+struct adf_vf_bank_info {
+	struct adf_accel_dev *accel_dev;
+	u32 vf_nr;
+	u32 bank_nr;
+};
+
+static inline int adf_mstate_cap_check_size(u32 src_size, u32 dst_size, u32 max_size)
+{
+	if (src_size > max_size || dst_size > max_size)
+		return -EINVAL;
+
+	if (src_size != dst_size) {
+		/*
+		 * If the length of target capability mask is greater than the
+		 * source one, it impliclitly means the target capability mask
+		 * is possible to represent all the capabilities the source
+		 * capability mask represents, we will allow this but further check
+		 * is needed.
+		 */
+		pr_warn("Mismatched state size: %u vs. %u\n", src_size, dst_size);
+		if (src_size > dst_size)
+			return -EINVAL;
+	}
+
+	return 0;
+}
+
+/*
+ * adf_mstate_capmask_compare() - compare QAT device capability mask
+ * @sinfo:	Pointer to source capability info
+ * @dinfo:	Pointer to target capability info
+ *
+ * This function compares the capability mask betwee source VF and target VF
+ *
+ * Return: 0 if target capability mask is identical to source capability mask,
+ * 1 if target mask can represent all the capabilities represented by source mask,
+ * -1 if target mask can't represent all the capabilities represented by source
+ * mask.
+ */
+static int adf_mstate_capmask_compare(struct adf_mstate_vreginfo *sinfo,
+				      struct adf_mstate_vreginfo *dinfo)
+{
+	u64 src = 0, dst = 0;
+
+	if (adf_mstate_cap_check_size(sinfo->size, dinfo->size, sizeof(u64)) < 0) {
+		pr_err("Mismatched length of cap %u %u %lu\n",
+		       sinfo->size, dinfo->size, sizeof(u64));
+		return -1;
+	}
+	memcpy(&src, sinfo->addr, sinfo->size);
+	memcpy(&dst, dinfo->addr, dinfo->size);
+	pr_debug("Check cap compatibility of cap %llu %llu\n", src, dst);
+
+	if (src == dst)
+		return 0;
+	if ((src | dst) == dst)
+		return 1;
+	return -1;
+}
+
+static int adf_mstate_capmask_superset(void *sub_mgr, u8 *buf, u32 size, void *opa)
+{
+	struct adf_mstate_vreginfo sinfo = {buf, size};
+
+	if (adf_mstate_capmask_compare(&sinfo, opa) >= 0)
+		return 0;
+	return -EINVAL;
+}
+
+static int adf_mstate_capmask_equal(void *sub_mgr, u8 *buf, u32 size, void *opa)
+{
+	struct adf_mstate_vreginfo sinfo = {buf, size};
+
+	if (adf_mstate_capmask_compare(&sinfo, opa) == 0)
+		return 0;
+	return -EINVAL;
+}
+
+static int adf_gen4_vfmig_load_etr_regs(void *subs, u8 *state, u32 size, void *opa)
+{
+	struct adf_vf_bank_info *vf_bank_info = opa;
+	struct adf_accel_dev *accel_dev = vf_bank_info->accel_dev;
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	u32 pf_bank_nr;
+	int ret;
+
+	pf_bank_nr = vf_bank_info->bank_nr + vf_bank_info->vf_nr * hw_data->num_banks_per_vf;
+	ret = hw_data->bank_state_restore(accel_dev, pf_bank_nr, (struct bank_state *)state);
+	if (ret) {
+		dev_err(&GET_DEV(accel_dev), "Failed to load regs for vf%d bank%d\n",
+			vf_bank_info->vf_nr, vf_bank_info->bank_nr);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int adf_gen4_vfmig_load_etr_bank(struct adf_accel_dev *accel_dev, u32 vf_nr,
+					u32 bank_nr, void *mstate_mgr)
+{
+	struct adf_accel_vf_info *vf_info = &accel_dev->pf.vf_info[vf_nr];
+	struct adf_gen4_vfmig *vfmig = vf_info->mig_priv;
+	struct adf_mstate_mgr sub_sects_mgr;
+	void *subsec, *l2_subsec;
+	struct adf_mstate_vreginfo info;
+	struct adf_vf_bank_info vf_bank_info = {accel_dev, vf_nr, bank_nr};
+	char bank_ids[8];
+
+	snprintf(bank_ids, sizeof(bank_ids), ADF_MSTATE_BANK_IDX_IDS "%d", bank_nr);
+	subsec = adf_mstate_sect_lookup(mstate_mgr, bank_ids, NULL, NULL);
+	if (!subsec) {
+		dev_err(&GET_DEV(accel_dev), "Failed to lookup sec %s for vf%d bank%d\n",
+			ADF_MSTATE_BANK_IDX_IDS, vf_nr, bank_nr);
+		return -EINVAL;
+	}
+
+	adf_mstate_mgr_init_by_psect(&sub_sects_mgr, subsec);
+
+	info.addr = &vfmig->ringsrvarben[bank_nr];
+	info.size = sizeof(vfmig->ringsrvarben[bank_nr]);
+	l2_subsec = adf_mstate_sect_lookup(&sub_sects_mgr, ADF_MSTATE_ARBITER_IDS, NULL, &info);
+	if (!l2_subsec) {
+		dev_err(&GET_DEV(accel_dev), "Failed to lookupd sec %s for vf%d bank%d\n",
+			ADF_MSTATE_ARBITER_IDS, vf_nr, bank_nr);
+		return -EINVAL;
+	}
+
+	l2_subsec = adf_mstate_sect_lookup(&sub_sects_mgr, ADF_MSTATE_ETR_REGS_IDS,
+					   adf_gen4_vfmig_load_etr_regs, &vf_bank_info);
+	if (!l2_subsec) {
+		dev_err(&GET_DEV(accel_dev), "Failed to add sec %s for vf%d bank%d\n",
+			ADF_MSTATE_ETR_REGS_IDS, vf_nr, bank_nr);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int adf_gen4_vfmig_load_etr(struct adf_accel_dev *accel_dev, u32 vf_nr)
+{
+	struct adf_accel_vf_info *vf_info = &accel_dev->pf.vf_info[vf_nr];
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	struct adf_gen4_vfmig *vfmig = vf_info->mig_priv;
+	int ret, i;
+	void *mstate_mgr = vfmig->mstate_mgr;
+	struct adf_mstate_mgr sub_sects_mgr;
+	void *subsec;
+
+	subsec = adf_mstate_sect_lookup(mstate_mgr, ADF_MSTATE_ETRB_IDS, NULL, NULL);
+	if (!subsec) {
+		dev_err(&GET_DEV(accel_dev), "Failed to load sec %s\n", ADF_MSTATE_ETRB_IDS);
+		return -EINVAL;
+	}
+
+	adf_mstate_mgr_init_by_psect(&sub_sects_mgr, subsec);
+	for (i = 0; i < hw_data->num_banks_per_vf; i++) {
+		ret = adf_gen4_vfmig_load_etr_bank(accel_dev, vf_nr, i, &sub_sects_mgr);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int adf_gen4_vfmig_load_misc(struct adf_accel_dev *accel_dev, u32 vf_nr)
+{
+	struct adf_accel_vf_info *vf_info = &accel_dev->pf.vf_info[vf_nr];
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	struct adf_gen4_vfmig *vfmig = vf_info->mig_priv;
+	u32 misc_bar_id = hw_data->get_misc_bar_id(hw_data);
+	void __iomem *csr = (&GET_BARS(accel_dev)[misc_bar_id])->virt_addr;
+	int i;
+	void *mstate_mgr = vfmig->mstate_mgr;
+	struct adf_mstate_mgr sub_sects_mgr;
+	void *subsec, *l2_subsec;
+	struct {
+		char *id;
+		u64 ofs;
+	} misc_states[] = {
+		{ADF_MSTATE_VINTMSK_IDS, ADF_GEN4_VINTMSK_OFFSET(vf_nr)},
+		{ADF_MSTATE_VINTMSK_PF2VM_IDS, ADF_GEN4_VINTMSKPF2VM_OFFSET(vf_nr)},
+		{ADF_MSTATE_PF2VM_IDS, ADF_GEN4_PF2VM_OFFSET(vf_nr)},
+		{ADF_MSTATE_VM2PF_IDS, ADF_GEN4_VM2PF_OFFSET(vf_nr)},
+	};
+
+	subsec = adf_mstate_sect_lookup(mstate_mgr, ADF_MSTATE_MISCB_IDS, NULL, NULL);
+	if (!subsec) {
+		dev_err(&GET_DEV(accel_dev), "Failed to load sec %s\n", ADF_MSTATE_MISCB_IDS);
+		return -EINVAL;
+	}
+
+	adf_mstate_mgr_init_by_psect(&sub_sects_mgr, subsec);
+	for (i = 0; i < ARRAY_SIZE(misc_states); i++) {
+		struct adf_mstate_vreginfo info;
+		u32 regv;
+
+		info.addr = &regv;
+		info.size = sizeof(regv);
+		l2_subsec = adf_mstate_sect_lookup(&sub_sects_mgr, misc_states[i].id,
+						   NULL, &info);
+		if (!l2_subsec) {
+			dev_err(&GET_DEV(accel_dev), "Failed to load sec %s\n", misc_states[i].id);
+			return -EINVAL;
+		}
+		ADF_CSR_WR(csr, misc_states[i].ofs, regv);
+	}
+
+	return 0;
+}
+
+static int adf_gen4_vfmig_load_generic(struct adf_accel_dev *accel_dev, u32 vf_nr)
+{
+	struct adf_accel_vf_info *vf_info = &accel_dev->pf.vf_info[vf_nr];
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	struct adf_gen4_vfmig *vfmig = vf_info->mig_priv;
+	int i;
+	void *mstate_mgr = vfmig->mstate_mgr;
+	struct adf_mstate_mgr sub_sects_mgr;
+	void *subsec, *l2_subsec;
+	struct {
+		char *id;
+		int (*action)(void *sub_mgr, u8 *buf, u32 size, void *opa);
+		struct adf_mstate_vreginfo info;
+	} gen_states[] = {
+		{ADF_MSTATE_GEN_CAP_IDS, adf_mstate_capmask_superset,
+		{&hw_data->accel_capabilities_mask, sizeof(hw_data->accel_capabilities_mask)}},
+		{ADF_MSTATE_GEN_SVCMAP_IDS, adf_mstate_capmask_equal,
+		{&hw_data->ring_to_svc_map, sizeof(hw_data->ring_to_svc_map)}},
+		{ADF_MSTATE_GEN_EXTDC_IDS, adf_mstate_capmask_superset,
+		{&hw_data->extended_dc_capabilities, sizeof(hw_data->extended_dc_capabilities)}},
+	};
+
+	subsec = adf_mstate_sect_lookup(mstate_mgr, ADF_MSTATE_GEN_IDS, NULL, NULL);
+	if (!subsec) {
+		dev_err(&GET_DEV(accel_dev), "Failed to load sec %s\n", ADF_MSTATE_GEN_IDS);
+		return -EINVAL;
+	}
+
+	adf_mstate_mgr_init_by_psect(&sub_sects_mgr, subsec);
+	for (i = 0; i < ARRAY_SIZE(gen_states); i++) {
+		l2_subsec = adf_mstate_sect_lookup(&sub_sects_mgr, gen_states[i].id,
+						   gen_states[i].action, &gen_states[i].info);
+		if (!l2_subsec) {
+			dev_err(&GET_DEV(accel_dev), "Failed to load sec %s\n", gen_states[i].id);
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+static int adf_gen4_vfmig_save_etr_regs(void *subs, u8 *state, u32 size, void *opa)
+{
+	struct adf_vf_bank_info *vf_bank_info = opa;
+	struct adf_accel_dev *accel_dev = vf_bank_info->accel_dev;
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	u32 pf_bank_nr;
+	int ret;
+
+	pf_bank_nr = vf_bank_info->bank_nr + vf_bank_info->vf_nr * hw_data->num_banks_per_vf;
+	ret = hw_data->bank_state_save(accel_dev, pf_bank_nr, (struct bank_state *)state);
+	if (ret) {
+		dev_err(&GET_DEV(accel_dev), "Failed to save regs for vf%d bank%d\n",
+			vf_bank_info->vf_nr, vf_bank_info->bank_nr);
+		return ret;
+	}
+
+	return sizeof(struct bank_state);
+}
+
+static int adf_gen4_vfmig_save_etr_bank(struct adf_accel_dev *accel_dev, u32 vf_nr,
+					u32 bank_nr, void *mstate_mgr)
+{
+	struct adf_accel_vf_info *vf_info = &accel_dev->pf.vf_info[vf_nr];
+	struct adf_gen4_vfmig *vfmig = vf_info->mig_priv;
+	struct adf_mstate_mgr sub_sects_mgr;
+	void *subsec, *l2_subsec;
+	struct adf_mstate_vreginfo info;
+	struct adf_vf_bank_info vf_bank_info;
+	char bank_ids[8];
+
+	snprintf(bank_ids, sizeof(bank_ids), ADF_MSTATE_BANK_IDX_IDS "%d", bank_nr);
+	subsec = adf_mstate_sect_add(mstate_mgr, bank_ids, NULL, NULL);
+	if (!subsec) {
+		dev_err(&GET_DEV(accel_dev), "Failed to add sec %s for vf%d bank%d\n",
+			ADF_MSTATE_BANK_IDX_IDS, vf_nr, bank_nr);
+		return -EINVAL;
+	}
+	adf_mstate_mgr_init_by_parent(&sub_sects_mgr, mstate_mgr);
+
+	info.addr = &vfmig->ringsrvarben[bank_nr];
+	info.size = sizeof(vfmig->ringsrvarben[bank_nr]);
+	l2_subsec = adf_mstate_sect_add(&sub_sects_mgr, ADF_MSTATE_ARBITER_IDS,
+					NULL, &info);
+	if (!l2_subsec) {
+		dev_err(&GET_DEV(accel_dev), "Failed to add sec %s for vf%d bank%d\n",
+			ADF_MSTATE_ARBITER_IDS, vf_nr, bank_nr);
+		return -EINVAL;
+	}
+
+	vf_bank_info.accel_dev = accel_dev;
+	vf_bank_info.vf_nr = vf_nr;
+	vf_bank_info.bank_nr = bank_nr;
+	l2_subsec = adf_mstate_sect_add(&sub_sects_mgr, ADF_MSTATE_ETR_REGS_IDS,
+					adf_gen4_vfmig_save_etr_regs, &vf_bank_info);
+	if (!l2_subsec) {
+		dev_err(&GET_DEV(accel_dev), "Failed to add sec %s for vf%d bank%d\n",
+			ADF_MSTATE_ETR_REGS_IDS, vf_nr, bank_nr);
+		return -EINVAL;
+	}
+	adf_mstate_sect_update(mstate_mgr, &sub_sects_mgr, subsec);
+
+	return 0;
+}
+
+static int adf_gen4_vfmig_save_etr(struct adf_accel_dev *accel_dev, u32 vf_nr)
+{
+	struct adf_accel_vf_info *vf_info = &accel_dev->pf.vf_info[vf_nr];
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	struct adf_gen4_vfmig *vfmig = vf_info->mig_priv;
+	int i;
+	void *mstate_mgr = vfmig->mstate_mgr;
+	struct adf_mstate_mgr sub_sects_mgr;
+	void *subsec;
+
+	subsec = adf_mstate_sect_add(mstate_mgr, ADF_MSTATE_ETRB_IDS, NULL, NULL);
+	if (!subsec) {
+		dev_err(&GET_DEV(accel_dev), "Failed to add sec %s\n", ADF_MSTATE_GEN_IDS);
+		return -EINVAL;
+	}
+
+	adf_mstate_mgr_init_by_parent(&sub_sects_mgr, mstate_mgr);
+	for (i = 0; i < hw_data->num_banks_per_vf; i++) {
+		if (adf_gen4_vfmig_save_etr_bank(accel_dev, vf_nr, i, &sub_sects_mgr) < 0)
+			return -EINVAL;
+	}
+	adf_mstate_sect_update(mstate_mgr, &sub_sects_mgr, subsec);
+
+	return 0;
+}
+
+static int adf_gen4_vfmig_save_misc(struct adf_accel_dev *accel_dev, u32 vf_nr)
+{
+	struct adf_accel_vf_info *vf_info = &accel_dev->pf.vf_info[vf_nr];
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	struct adf_gen4_vfmig *vfmig = vf_info->mig_priv;
+	int i;
+	void *mstate_mgr = vfmig->mstate_mgr;
+	struct adf_mstate_mgr sub_sects_mgr;
+	void *subsec, *l2_subsec;
+	u32 regv;
+	u32 misc_bar_id = hw_data->get_misc_bar_id(hw_data);
+	void __iomem *csr = (&GET_BARS(accel_dev)[misc_bar_id])->virt_addr;
+	struct {
+		char *id;
+		u64 ofs;
+	} misc_states[] = {
+		{ADF_MSTATE_VINTSRC_IDS, ADF_GEN4_VINTSOU_OFFSET(vf_nr)},
+		{ADF_MSTATE_VINTMSK_IDS, ADF_GEN4_VINTMSK_OFFSET(vf_nr)},
+		{ADF_MSTATE_VINTSRC_PF2VM_IDS, ADF_GEN4_VINTSOUPF2VM_OFFSET(vf_nr)},
+		{ADF_MSTATE_VINTMSK_PF2VM_IDS, ADF_GEN4_VINTMSKPF2VM_OFFSET(vf_nr)},
+		{ADF_MSTATE_PF2VM_IDS, ADF_GEN4_PF2VM_OFFSET(vf_nr)},
+		{ADF_MSTATE_VM2PF_IDS, ADF_GEN4_VM2PF_OFFSET(vf_nr)},
+	};
+
+	subsec = adf_mstate_sect_add(mstate_mgr, ADF_MSTATE_MISCB_IDS, NULL, NULL);
+	if (!subsec) {
+		dev_err(&GET_DEV(accel_dev), "Failed to add sec %s\n", ADF_MSTATE_GEN_IDS);
+		return -EINVAL;
+	}
+
+	adf_mstate_mgr_init_by_parent(&sub_sects_mgr, mstate_mgr);
+	for (i = 0; i < ARRAY_SIZE(misc_states); i++) {
+		struct adf_mstate_vreginfo info;
+
+		info.addr = &regv;
+		info.size = sizeof(regv);
+		regv = ADF_CSR_RD(csr, misc_states[i].ofs);
+		l2_subsec = adf_mstate_sect_add(&sub_sects_mgr, misc_states[i].id,
+						NULL, &info);
+		if (!l2_subsec) {
+			dev_err(&GET_DEV(accel_dev), "Failed to add sec %s\n", misc_states[i].id);
+			return -EINVAL;
+		}
+	}
+	adf_mstate_sect_update(mstate_mgr, &sub_sects_mgr, subsec);
+
+	return 0;
+}
+
+static int adf_gen4_vfmig_save_generic(struct adf_accel_dev *accel_dev, u32 vf_nr)
+{
+	struct adf_accel_vf_info *vf_info = &accel_dev->pf.vf_info[vf_nr];
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	struct adf_gen4_vfmig *vfmig = vf_info->mig_priv;
+	int i;
+	void *mstate_mgr = vfmig->mstate_mgr;
+	struct adf_mstate_mgr sub_sects_mgr;
+	void *subsec, *l2_subsec;
+	struct {
+		char *id;
+		struct adf_mstate_vreginfo info;
+	} gen_states[] = {
+		{ADF_MSTATE_GEN_CAP_IDS,
+		{&hw_data->accel_capabilities_mask, sizeof(hw_data->accel_capabilities_mask)}},
+		{ADF_MSTATE_GEN_SVCMAP_IDS,
+		{&hw_data->ring_to_svc_map, sizeof(hw_data->ring_to_svc_map)}},
+		{ADF_MSTATE_GEN_EXTDC_IDS,
+		{&hw_data->extended_dc_capabilities, sizeof(hw_data->extended_dc_capabilities)}},
+	};
+
+	subsec = adf_mstate_sect_add(mstate_mgr, ADF_MSTATE_GEN_IDS, NULL, NULL);
+	if (!subsec) {
+		dev_err(&GET_DEV(accel_dev), "Failed to add sec %s\n", ADF_MSTATE_GEN_IDS);
+		return -EINVAL;
+	}
+
+	adf_mstate_mgr_init_by_parent(&sub_sects_mgr, mstate_mgr);
+	for (i = 0; i < ARRAY_SIZE(gen_states); i++) {
+		l2_subsec = adf_mstate_sect_add(&sub_sects_mgr, gen_states[i].id,
+						NULL, &gen_states[i].info);
+		if (!l2_subsec) {
+			dev_err(&GET_DEV(accel_dev), "Failed to add sec %s\n", gen_states[i].id);
+			return -EINVAL;
+		}
+	}
+	adf_mstate_sect_update(mstate_mgr, &sub_sects_mgr, subsec);
+
+	return 0;
+}
+
+static int adf_gen4_vfmig_save_state(struct adf_accel_dev *accel_dev, u32 vf_nr,
+				     u8 *buf, u64 buf_sz)
+{
+	struct adf_accel_vf_info *vf_info = &accel_dev->pf.vf_info[vf_nr];
+	struct adf_gen4_vfmig *vfmig = vf_info->mig_priv;
+	struct adf_mstate_preh *pre;
+	int ret;
+
+	adf_mstate_mgr_init(vfmig->mstate_mgr, buf, buf_sz);
+	pre = adf_mstate_preamble_add(vfmig->mstate_mgr);
+	ret = adf_gen4_vfmig_save_generic(accel_dev, vf_nr);
+	if (ret	< 0) {
+		dev_err(&GET_DEV(accel_dev), "Failed to save generic state for vf_nr:%d\n", vf_nr);
+		return ret;
+	}
+
+	ret = adf_gen4_vfmig_save_misc(accel_dev, vf_nr);
+	if (ret	< 0) {
+		dev_err(&GET_DEV(accel_dev), "Failed to save misc bar state for vf_nr:%d\n", vf_nr);
+		return ret;
+	}
+
+	ret = adf_gen4_vfmig_save_etr(accel_dev, vf_nr);
+	if (ret < 0) {
+		dev_err(&GET_DEV(accel_dev), "Failed to save etr bar state for vf_nr:%d\n", vf_nr);
+		return ret;
+	}
+
+	adf_mstate_preamble_update(vfmig->mstate_mgr, pre);
+
+	return 0;
+}
+
+static int adf_gen4_vfmig_load_state(struct adf_accel_dev *accel_dev, u32 vf_nr,
+				     u8 *buf, u64 buf_sz)
+{
+	struct adf_accel_vf_info *vf_info = &accel_dev->pf.vf_info[vf_nr];
+	struct adf_gen4_vfmig *vfmig = vf_info->mig_priv;
+	int ret;
+
+	adf_mstate_mgr_init(vfmig->mstate_mgr, buf, buf_sz);
+	ret = adf_mstate_mgr_scan(vfmig->mstate_mgr, adf_mstate_preamble_checker, NULL);
+	if (ret < 0) {
+		dev_err(&GET_DEV(accel_dev), "Invalid state for vf_nr:%d\n", vf_nr);
+		return ret;
+	}
+	ret = adf_gen4_vfmig_load_generic(accel_dev, vf_nr);
+	if (ret	< 0) {
+		dev_err(&GET_DEV(accel_dev), "Failed to load gerneal state for vf_nr:%d\n", vf_nr);
+		return ret;
+	}
+	ret = adf_gen4_vfmig_load_misc(accel_dev, vf_nr);
+	if (ret	< 0) {
+		dev_err(&GET_DEV(accel_dev), "Failed to load misc bar state for vf_nr:%d\n", vf_nr);
+		return ret;
+	}
+	ret = adf_gen4_vfmig_load_etr(accel_dev, vf_nr);
+	if (ret	< 0) {
+		dev_err(&GET_DEV(accel_dev), "Failed to load etr bar state for vf_nr:%d\n", vf_nr);
+		return ret;
+	}
+
+	return 0;
+}
+
+void adf_gen4_init_vf_mig_ops(struct adf_vfmig_ops *vfmig_ops)
+{
+	vfmig_ops->init_device = adf_gen4_vfmig_init_device;
+	vfmig_ops->shutdown_device = adf_gen4_vfmig_shutdown_device;
+	vfmig_ops->suspend_device = adf_gen4_vfmig_suspend_device;
+	vfmig_ops->resume_device = adf_gen4_vfmig_resume_device;
+	vfmig_ops->save_state = adf_gen4_vfmig_save_state;
+	vfmig_ops->load_state = adf_gen4_vfmig_load_state;
+}
+EXPORT_SYMBOL_GPL(adf_gen4_init_vf_mig_ops);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_mstate_mgr.c b/drivers/crypto/intel/qat/qat_common/adf_mstate_mgr.c
new file mode 100644
index 000000000000..8bafff229929
--- /dev/null
+++ b/drivers/crypto/intel/qat/qat_common/adf_mstate_mgr.c
@@ -0,0 +1,267 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(c) 2023 Intel Corporation */
+
+#include <linux/slab.h>
+#include <linux/types.h>
+#include "adf_mstate_mgr.h"
+
+struct adf_mstate_sect_h {
+	u8 id[8];
+	u32 size;
+	u32 sub_sects;
+	u8 state[];
+};
+
+void adf_mstate_mgr_reset(void *m)
+{
+	struct adf_mstate_mgr *mgr = m;
+
+	mgr->state = mgr->buf;
+	mgr->n_sects = 0;
+}
+
+static void __adf_mstate_mgr_reinit(void *m, void *buf, u32 size)
+{
+	struct adf_mstate_mgr *mgr = m;
+
+	mgr->buf = buf;
+	mgr->state = buf;
+	mgr->size = size;
+	mgr->n_sects = 0;
+};
+
+void *adf_mstate_mgr_new(u8 *buf, u32 size)
+{
+	struct adf_mstate_mgr *mgr;
+
+	mgr = kzalloc(sizeof(*mgr), GFP_KERNEL);
+	if (!mgr)
+		return NULL;
+	__adf_mstate_mgr_reinit(mgr, buf, size);
+
+	return mgr;
+}
+
+void adf_mstate_mgr_destroy(void *mgr)
+{
+	kfree(mgr);
+}
+
+static inline
+u32 _adf_mstate_state_size(struct adf_mstate_mgr *mgr)
+{
+	return mgr->state - mgr->buf;
+}
+
+int adf_mstate_state_size(void *mgr)
+{
+	return _adf_mstate_state_size(mgr);
+}
+
+void adf_mstate_mgr_init_by_parent(void *mgr, void *p_mgr_)
+{
+	struct adf_mstate_mgr *p_mgr = p_mgr_;
+
+	__adf_mstate_mgr_reinit(mgr, p_mgr->state, p_mgr->size - _adf_mstate_state_size(p_mgr));
+}
+
+void adf_mstate_mgr_init_by_psect(void *mgr_, void *p_sect_)
+{
+	struct adf_mstate_sect_h *p_sect = p_sect_;
+	struct adf_mstate_mgr *mgr = mgr_;
+
+	__adf_mstate_mgr_reinit(mgr, p_sect->state, p_sect->size);
+	mgr->n_sects = p_sect->sub_sects;
+}
+
+void adf_mstate_mgr_init(void *mgr, u8 *buf, u32 size)
+{
+	return __adf_mstate_mgr_reinit(mgr, buf, size);
+}
+
+struct adf_mstate_preh *adf_mstate_preamble_add(void *mgr_)
+{
+	struct adf_mstate_mgr *mgr = mgr_;
+	struct adf_mstate_preh *pre = (struct adf_mstate_preh *)(mgr->buf);
+
+	adf_mstate_preamble_init(pre);
+	mgr->state += pre->preh_len;
+
+	return pre;
+}
+
+int adf_mstate_preamble_update(void *mgr_, struct adf_mstate_preh *preamble)
+{
+	struct adf_mstate_mgr *mgr = mgr_;
+
+	preamble->size = _adf_mstate_state_size(mgr) - preamble->preh_len;
+	preamble->n_sects = mgr->n_sects;
+
+	return 0;
+}
+
+static void adf_mstate_dump_sect(struct adf_mstate_sect_h *sect, const char *prefix)
+{
+	pr_debug("%s QAT state section %s\n", prefix, sect->id);
+	print_hex_dump_debug("h-", DUMP_PREFIX_OFFSET, 16, 2,
+			     sect, sizeof(*sect), true);
+	print_hex_dump_debug("s-", DUMP_PREFIX_OFFSET, 16, 2,
+			     sect->state, sect->size, true);
+}
+
+int adf_mstate_sect_update(void *p_mgr_, void *curr_mgr_, void *sect_)
+{
+	struct adf_mstate_sect_h *sect = sect_;
+	struct adf_mstate_mgr *curr_mgr = curr_mgr_;
+	struct adf_mstate_mgr *p_mgr = p_mgr_;
+
+	sect->size += _adf_mstate_state_size(curr_mgr);
+	sect->sub_sects += curr_mgr->n_sects;
+	p_mgr->state += sect->size;
+
+	adf_mstate_dump_sect(sect, "Update");
+
+	return 0;
+}
+
+void *adf_mstate_sect_add(void *mgr_,
+			  const char *id,
+			  int (*populate)(void *sub_mgr, u8 *state, u32 size, void *opaque),
+			  void *opaque)
+{
+	struct adf_mstate_mgr *mgr = mgr_;
+	u8 *end = mgr->buf + mgr->size;
+	struct adf_mstate_sect_h *sect;
+	int remaining;
+	int ret;
+
+	if ((u64)mgr->state + sizeof(*sect) < (u64)mgr->state ||
+	    ((u64)mgr->state + sizeof(*sect) > (u64)end)) {
+		pr_err("Not enough space to hold QAT state header of sect %s! 0x%lx bytes left\n",
+		       id, end - mgr->state);
+		return NULL;
+	}
+
+	sect = (struct adf_mstate_sect_h *)(mgr->state);
+	remaining = mgr->size - _adf_mstate_state_size(mgr) - sizeof(*sect);
+	if (populate) {
+		struct adf_mstate_mgr sub_sects_mgr;
+
+		__adf_mstate_mgr_reinit(&sub_sects_mgr, sect->state, remaining);
+		ret = (*populate)(&sub_sects_mgr, sect->state, remaining, opaque);
+		if (ret < 0)
+			return NULL;
+		ret += _adf_mstate_state_size(&sub_sects_mgr);
+		sect->sub_sects = sub_sects_mgr.n_sects;
+	} else if (opaque) {
+		/* Use default function */
+		struct adf_mstate_vreginfo *info = opaque;
+
+		if (info->size > remaining) {
+			pr_err("Not enough space for QAT state sect %s! has %u, need %u\n",
+			       id, remaining, info->size);
+			return NULL;
+		}
+		memcpy(sect->state, info->addr, info->size);
+		ret = info->size;
+		sect->sub_sects = 0;
+	} else {
+		ret = 0;
+	}
+
+	strncpy(sect->id, id, sizeof(sect->id));
+	sect->id[sizeof(sect->id) - 1] = 0;
+	sect->size = ret;
+	ret += sizeof(*sect);
+	mgr->state += ret;
+	mgr->n_sects++;
+
+	adf_mstate_dump_sect(sect, "Add");
+
+	return sect;
+}
+
+static int adf_mstate_sect_scan(struct adf_mstate_mgr *mgr, int n_sects)
+{
+	struct adf_mstate_sect_h *start = (struct adf_mstate_sect_h *)(mgr->state);
+	struct adf_mstate_sect_h *sect = start;
+	int i;
+	u64 end;
+
+	end = (u64)mgr->buf + mgr->size;
+	for (i = 0; i < n_sects; i++) {
+		u64 s_start = (u64)sect->state;
+		u64 s_end = s_start + sect->size;
+
+		if (s_end < s_start || s_end > end) {
+			pr_err("Corrupted state section(index=%u,max size %u,got size %u)\n",
+			       i, mgr->size, sect->size);
+			return -EINVAL;
+		}
+		sect = (struct adf_mstate_sect_h *)s_end;
+	}
+	mgr->n_sects = n_sects;
+	pr_debug("Scanned section (eldest child is %s), calculated size=%lu, mgr_size=%u sub_secs=%u\n",
+		 start->id, sizeof(struct adf_mstate_sect_h) * (sect - start),
+		 mgr->size, mgr->n_sects);
+
+	return 0;
+}
+
+int adf_mstate_mgr_scan(void *mgr_,
+			int (*pre_checker)(struct adf_mstate_preh *, void *),
+			void *opaque)
+{
+	struct adf_mstate_mgr *mgr = mgr_;
+	struct adf_mstate_preh *pre = (struct adf_mstate_preh *)(mgr->buf);
+
+	pr_debug("Found QAT state preambles\n");
+	print_hex_dump_debug("", DUMP_PREFIX_OFFSET, 16, 2, pre, pre->preh_len, 0);
+
+	if (*pre_checker && (*pre_checker)(pre, opaque) < 0)
+		return -EINVAL;
+	mgr->state =  mgr->buf + pre->preh_len;
+
+	return adf_mstate_sect_scan(mgr, pre->n_sects);
+}
+
+void *adf_mstate_sect_lookup(void *mgr_,
+			     const char *id,
+			     int (*action)(void *, u8 *, u32, void *),
+			     void *opaque)
+{
+	struct adf_mstate_mgr *mgr = mgr_, sub_sects_mgr;
+	struct adf_mstate_sect_h *sect = (struct adf_mstate_sect_h *)(mgr->state);
+	int i, ret;
+
+	for (i = 0; i < mgr->n_sects; i++) {
+		if (!strncmp(sect->id, id, sizeof(sect->id)))
+			goto found;
+		sect = (struct adf_mstate_sect_h *)(sect->state + sect->size);
+	}
+
+	return NULL;
+found:
+	adf_mstate_dump_sect(sect, "Found");
+	__adf_mstate_mgr_reinit(&sub_sects_mgr, sect->state, sect->size);
+	if (sect->sub_sects > 0 &&
+	    adf_mstate_sect_scan(&sub_sects_mgr, sect->sub_sects) < 0)
+		return NULL;
+	if (action) {
+		ret = (*action)(&sub_sects_mgr, sect->state, sect->size, opaque);
+		if (ret < 0)
+			return NULL;
+	} else if (opaque) {
+		/* Use default function */
+		struct adf_mstate_vreginfo *info = opaque;
+
+		if (sect->size != info->size) {
+			pr_err("Mismatched QAT state sect %s, has %u, need %u\n",
+			       id, sect->size, info->size);
+			return NULL;
+		}
+		memcpy(info->addr, sect->state, info->size);
+	}
+
+	return sect;
+}
diff --git a/drivers/crypto/intel/qat/qat_common/adf_mstate_mgr.h b/drivers/crypto/intel/qat/qat_common/adf_mstate_mgr.h
new file mode 100644
index 000000000000..7489428331fa
--- /dev/null
+++ b/drivers/crypto/intel/qat/qat_common/adf_mstate_mgr.h
@@ -0,0 +1,99 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright(c) 2023 Intel Corporation */
+
+#ifndef ADF_MSTATE_MGR_H
+#define ADF_MSTATE_MGR_H
+
+#define ADF_MSTATE_MAGIC		0xADF5CAEA
+#define ADF_MSTATE_VERSION		0x1
+
+#define ADF_MSTATE_ETRB_IDS		"ETRBAR"
+#define ADF_MSTATE_MISCB_IDS		"MISCBAR"
+#define ADF_MSTATE_EXTB_IDS		"EXTBAR"
+#define ADF_MSTATE_GEN_IDS		"general"
+#define ADF_MSTATE_SECTION_NUM		4
+
+#define ADF_MSTATE_BANK_IDX_IDS		"bnk"
+
+#define ADF_MSTATE_ETR_REGS_IDS		"m_regs"
+#define ADF_MSTATE_ARBITER_IDS		"arb_en"
+#define ADF_MSTATE_VINTSRC_IDS		"vintsrc"
+#define ADF_MSTATE_VINTMSK_IDS		"vintmsk"
+#define ADF_MSTATE_IOV_INIT_IDS		"iovinit"
+#define ADF_MSTATE_COMPAT_VER_IDS	"compver"
+#define ADF_MSTATE_SVM_CAP_IDS		"svmcap"
+#define ADF_MSTATE_GEN_CAP_IDS		"gencap"
+#define ADF_MSTATE_GEN_SVCMAP_IDS	"svcmap"
+#define ADF_MSTATE_GEN_EXTDC_IDS	"extdc"
+#define ADF_MSTATE_VINTSRC_PF2VM_IDS	"vintsvm"
+#define ADF_MSTATE_VINTMSK_PF2VM_IDS	"vintmvm"
+#define ADF_MSTATE_VM2PF_IDS		"vm2pf"
+#define ADF_MSTATE_PF2VM_IDS		"pf2vm"
+
+struct adf_mstate_mgr {
+	u8 *buf;
+	u8 *state;
+	u32 size;
+	u32 n_sects;
+};
+
+struct adf_mstate_preh {
+	u32 magic;
+	u32 version;
+	u16 preh_len;
+	u16 n_sects;
+	u32 size;
+};
+
+struct adf_mstate_vreginfo {
+	void *addr;
+	u32 size;
+};
+
+static inline void adf_mstate_preamble_init(struct adf_mstate_preh *preamble)
+{
+	preamble->magic = ADF_MSTATE_MAGIC;
+	preamble->version = ADF_MSTATE_VERSION;
+	preamble->preh_len = sizeof(*preamble);
+	preamble->size = 0;
+	preamble->n_sects = 0;
+}
+
+/* default preambles checker */
+static inline int adf_mstate_preamble_checker(struct adf_mstate_preh *preamble, void *opaque)
+{
+	if (preamble->magic != ADF_MSTATE_MAGIC ||
+	    preamble->version > ADF_MSTATE_VERSION) {
+		pr_err("unrecognized vqat state, magic=0x%x,version=0x%x, hlen=%u\n",
+		       preamble->magic, preamble->version, preamble->preh_len);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+void *adf_mstate_mgr_new(u8 *buf, u32 size);
+void adf_mstate_mgr_reset(void *m);
+void adf_mstate_mgr_destroy(void *mgr);
+void adf_mstate_mgr_init(void *mgr, u8 *buf, u32 size);
+void adf_mstate_mgr_init_by_parent(void *mgr, void *p_mgr);
+void adf_mstate_mgr_init_by_psect(void *mgr, void *p_sect);
+struct adf_mstate_preh *adf_mstate_preamble_add(void *mgr);
+int adf_mstate_preamble_update(void *mgr, struct adf_mstate_preh *preamble);
+struct adf_mstate_preh *adf_mstate_preamble_get(void *mgr);
+int adf_mstate_sect_update(void *p_mgr, void *sub_mgr, void *sect);
+void *adf_mstate_sect_add(void *mgr,
+			  const char *id,
+			  int (*populate)(void *sub_sects_mgr, u8 *buf,
+					  u32 size, void *opaque),
+			  void *opaque);
+int adf_mstate_mgr_scan(void *mgr,
+			int (*pre_checker)(struct adf_mstate_preh *, void *),
+			void *opaque);
+void *adf_mstate_sect_lookup(void *mgr,
+			     const char *id,
+			     int (*action)(void *sub_sects_mgr, u8 *buf,
+					   u32 size, void *opaque),
+			     void *opaque);
+int adf_mstate_state_size(void *mgr);
+#endif
-- 
2.18.2

