Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB12F743C83
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 15:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232502AbjF3NSV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 09:18:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232479AbjF3NSR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 09:18:17 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1B483A8B;
        Fri, 30 Jun 2023 06:18:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688131093; x=1719667093;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=vjeJXK141w66ziTCTqGoDPkw/VIkiGjRukXZEVld2Js=;
  b=ECcHu/hNmEKjE0ngielJRHpDAVbJYRfHeW22pUyKt8S3oyzRpdKbXpiP
   vvx28PExZ0c9FvLofzEMbMuA9hge3g2mke1tkWtbYQVkYIsj6Fkb8f6Lv
   KqDPVZsHj0W+PqyxeJVxAVUccrUUjEtIrCoL80lWDu7bkTHFTJtz5FLCf
   8XJ3tBwNKRc7UcXjOR3vvxj6BAzCskqBzafw67gdrEFhmEJLXek3JWD6a
   LWdS/ykKbnClTF8GMtf8mya++PbVP/BOITxgCCGbUWj58p5CAVQb/e5R6
   jGCsiBFjeSUNEWRevJyeh83FRDPOWiwVznBpB+YBh8qALRErx01IyKfhZ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10756"; a="362433123"
X-IronPort-AV: E=Sophos;i="6.01,170,1684825200"; 
   d="scan'208";a="362433123"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2023 06:18:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10756"; a="783077927"
X-IronPort-AV: E=Sophos;i="6.01,170,1684825200"; 
   d="scan'208";a="783077927"
Received: from qat-server-archercity1.sh.intel.com ([10.67.111.115])
  by fmsmga008.fm.intel.com with ESMTP; 30 Jun 2023 06:18:08 -0700
From:   Xin Zeng <xin.zeng@intel.com>
To:     linux-crypto@vger.kernel.org, kvm@vger.kernel.org
Cc:     giovanni.cabiddu@intel.com, andriy.shevchenko@linux.intel.com,
        Siming Wan <siming.wan@intel.com>,
        Svyatoslav Pankratov <svyatoslav.pankratov@intel.com>,
        Xin Zeng <xin.zeng@intel.com>
Subject: [RFC 1/5] crypto: qat - add bank save/restore and RP drain
Date:   Fri, 30 Jun 2023 21:13:00 +0800
Message-Id: <20230630131304.64243-2-xin.zeng@intel.com>
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

From: Siming Wan <siming.wan@intel.com>

Extend CSR ops and add logic to save and restore banks and drain the
ring pairs. This will be used to implement live migration.

This is implemented only for QAT GEN4 devices.

Co-developed-by: Svyatoslav Pankratov <svyatoslav.pankratov@intel.com>
Signed-off-by: Svyatoslav Pankratov <svyatoslav.pankratov@intel.com>
Signed-off-by: Siming Wan <siming.wan@intel.com>
Signed-off-by: Xin Zeng <xin.zeng@intel.com>
---
 .../intel/qat/qat_4xxx/adf_4xxx_hw_data.c     |   5 +-
 .../intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c   |   2 +-
 .../qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c     |   2 +-
 .../intel/qat/qat_c62x/adf_c62x_hw_data.c     |   2 +-
 .../intel/qat/qat_c62xvf/adf_c62xvf_hw_data.c |   2 +-
 .../intel/qat/qat_common/adf_accel_devices.h  |  60 ++-
 .../intel/qat/qat_common/adf_gen2_hw_data.c   |  17 +-
 .../intel/qat/qat_common/adf_gen2_hw_data.h   |  10 +-
 .../intel/qat/qat_common/adf_gen4_hw_data.c   | 362 +++++++++++++++++-
 .../intel/qat/qat_common/adf_gen4_hw_data.h   | 131 ++++++-
 .../intel/qat/qat_common/adf_transport.c      |  11 +-
 .../crypto/intel/qat/qat_common/adf_vf_isr.c  |   2 +-
 .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.c   |   2 +-
 .../qat_dh895xccvf/adf_dh895xccvf_hw_data.c   |   2 +-
 14 files changed, 584 insertions(+), 26 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
index e543a9e24a06..22fe4e6834c1 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -505,11 +505,14 @@ void adf_init_hw_data_4xxx(struct adf_hw_device_data *hw_data, u32 dev_id)
 	hw_data->set_ssm_wdtimer = adf_gen4_set_ssm_wdtimer;
 	hw_data->disable_iov = adf_disable_sriov;
 	hw_data->ring_pair_reset = adf_gen4_ring_pair_reset;
+	hw_data->ring_pair_drain = adf_gen4_ring_pair_drain;
+	hw_data->bank_state_save = adf_gen4_bank_state_save;
+	hw_data->bank_state_restore = adf_gen4_bank_state_restore;
 	hw_data->enable_pm = adf_gen4_enable_pm;
 	hw_data->handle_pm_interrupt = adf_gen4_handle_pm_interrupt;
 	hw_data->dev_config = adf_gen4_dev_config;
 
-	adf_gen4_init_hw_csr_ops(&hw_data->csr_ops);
+	adf_gen4_init_hw_csr_ops(&hw_data->csr_info);
 	adf_gen4_init_pf_pfvf_ops(&hw_data->pfvf_ops);
 	adf_gen4_init_dc_ops(&hw_data->dc_ops);
 }
diff --git a/drivers/crypto/intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c b/drivers/crypto/intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c
index 475643654e64..04a833affb29 100644
--- a/drivers/crypto/intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c
@@ -129,7 +129,7 @@ void adf_init_hw_data_c3xxx(struct adf_hw_device_data *hw_data)
 	hw_data->dev_config = adf_gen2_dev_config;
 
 	adf_gen2_init_pf_pfvf_ops(&hw_data->pfvf_ops);
-	adf_gen2_init_hw_csr_ops(&hw_data->csr_ops);
+	adf_gen2_init_hw_csr_ops(&hw_data->csr_info);
 	adf_gen2_init_dc_ops(&hw_data->dc_ops);
 }
 
diff --git a/drivers/crypto/intel/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c b/drivers/crypto/intel/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c
index 84d9486e04de..5cb46b2cd278 100644
--- a/drivers/crypto/intel/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c
@@ -91,7 +91,7 @@ void adf_init_hw_data_c3xxxiov(struct adf_hw_device_data *hw_data)
 	hw_data->dev_config = adf_gen2_dev_config;
 	adf_devmgr_update_class_index(hw_data);
 	adf_gen2_init_vf_pfvf_ops(&hw_data->pfvf_ops);
-	adf_gen2_init_hw_csr_ops(&hw_data->csr_ops);
+	adf_gen2_init_hw_csr_ops(&hw_data->csr_info);
 	adf_gen2_init_dc_ops(&hw_data->dc_ops);
 }
 
diff --git a/drivers/crypto/intel/qat/qat_c62x/adf_c62x_hw_data.c b/drivers/crypto/intel/qat/qat_c62x/adf_c62x_hw_data.c
index e14270703670..fd6f18c5f8e2 100644
--- a/drivers/crypto/intel/qat/qat_c62x/adf_c62x_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_c62x/adf_c62x_hw_data.c
@@ -131,7 +131,7 @@ void adf_init_hw_data_c62x(struct adf_hw_device_data *hw_data)
 	hw_data->dev_config = adf_gen2_dev_config;
 
 	adf_gen2_init_pf_pfvf_ops(&hw_data->pfvf_ops);
-	adf_gen2_init_hw_csr_ops(&hw_data->csr_ops);
+	adf_gen2_init_hw_csr_ops(&hw_data->csr_info);
 	adf_gen2_init_dc_ops(&hw_data->dc_ops);
 }
 
diff --git a/drivers/crypto/intel/qat/qat_c62xvf/adf_c62xvf_hw_data.c b/drivers/crypto/intel/qat/qat_c62xvf/adf_c62xvf_hw_data.c
index 751d7aa57fc7..ca3e0cea056f 100644
--- a/drivers/crypto/intel/qat/qat_c62xvf/adf_c62xvf_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_c62xvf/adf_c62xvf_hw_data.c
@@ -91,7 +91,7 @@ void adf_init_hw_data_c62xiov(struct adf_hw_device_data *hw_data)
 	hw_data->dev_config = adf_gen2_dev_config;
 	adf_devmgr_update_class_index(hw_data);
 	adf_gen2_init_vf_pfvf_ops(&hw_data->pfvf_ops);
-	adf_gen2_init_hw_csr_ops(&hw_data->csr_ops);
+	adf_gen2_init_hw_csr_ops(&hw_data->csr_info);
 	adf_gen2_init_dc_ops(&hw_data->dc_ops);
 }
 
diff --git a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
index 0399417b91fc..7fc2fd042916 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
@@ -119,6 +119,41 @@ struct admin_info {
 	u32 mailbox_offset;
 };
 
+struct ring_config {
+	u32 config;
+	u64 base;
+	u32 head;
+	u32 tail;
+};
+
+struct bank_state {
+	u32 reservd0;
+	u32 reservd1;
+	u32 num_rings;
+	u32 ringstat0;
+	u32 ringstat1;
+	u32 ringuostat;
+	u32 ringestat;
+	u32 ringnestat;
+	u32 ringnfstat;
+	u32 ringfstat;
+	u32 ringcstat0;
+	u32 ringcstat1;
+	u32 ringcstat2;
+	u32 ringcstat3;
+	u32 iaintflagen;
+	u32 iaintflagreg;
+	u32 iaintflagsrcsel0;
+	u32 iaintflagsrcsel1;
+	u32 iaintcolen;
+	u32 iaintcolctl;
+	u32 iaintflagandcolen;
+	u32 ringexpstat;
+	u32 ringexpintenable;
+	u32 ringsrvarben;
+	struct ring_config rings[ADF_ETR_MAX_RINGS_PER_BANK];
+};
+
 struct adf_hw_csr_ops {
 	u64 (*build_csr_ring_base_addr)(dma_addr_t addr, u32 size);
 	u32 (*read_csr_ring_head)(void __iomem *csr_base_addr, u32 bank,
@@ -136,15 +171,28 @@ struct adf_hw_csr_ops {
 				    u32 ring, dma_addr_t addr);
 	void (*write_csr_int_flag)(void __iomem *csr_base_addr, u32 bank,
 				   u32 value);
-	void (*write_csr_int_srcsel)(void __iomem *csr_base_addr, u32 bank);
+	u32 (*read_csr_int_srcsel)(void __iomem *csr_base_addr, u32 bank, u32 idx);
+	void (*write_csr_int_srcsel)(void __iomem *csr_base_addr, u32 bank,
+				     u32 idx, u32 value);
+	u32 (*read_csr_int_col_en)(void __iomem *csr_base_addr, u32 bank);
 	void (*write_csr_int_col_en)(void __iomem *csr_base_addr, u32 bank,
 				     u32 value);
+	u32 (*read_csr_int_col_ctl)(void __iomem *csr_base_addr, u32 bank);
 	void (*write_csr_int_col_ctl)(void __iomem *csr_base_addr, u32 bank,
 				      u32 value);
 	void (*write_csr_int_flag_and_col)(void __iomem *csr_base_addr,
 					   u32 bank, u32 value);
+	u32 (*read_csr_ring_srv_arb_en)(void __iomem *csr_base_addr, u32 bank);
 	void (*write_csr_ring_srv_arb_en)(void __iomem *csr_base_addr, u32 bank,
 					  u32 value);
+	u32 (*get_src_sel_mask)(void);
+	u32 (*get_int_col_ctl_enable_mask)(void);
+};
+
+struct adf_hw_csr_info {
+	struct adf_hw_csr_ops csr_ops;
+	u32 num_rings_per_int_srcsel;
+	u32 arb_enable_mask;
 };
 
 struct adf_cfg_device_data;
@@ -200,14 +248,20 @@ struct adf_hw_device_data {
 	void (*enable_ints)(struct adf_accel_dev *accel_dev);
 	void (*set_ssm_wdtimer)(struct adf_accel_dev *accel_dev);
 	int (*ring_pair_reset)(struct adf_accel_dev *accel_dev, u32 bank_nr);
+	int (*ring_pair_drain)(struct adf_accel_dev *accel_dev, u32 bank_nr,
+			       int timeout_us);
+	int (*bank_state_save)(struct adf_accel_dev *accel_dev, u32 bank_number,
+			       struct bank_state *state);
+	int (*bank_state_restore)(struct adf_accel_dev *accel_dev,
+				  u32 bank_number, struct bank_state *state);
 	void (*reset_device)(struct adf_accel_dev *accel_dev);
 	void (*set_msix_rttable)(struct adf_accel_dev *accel_dev);
 	const char *(*uof_get_name)(struct adf_accel_dev *accel_dev, u32 obj_num);
 	u32 (*uof_get_num_objs)(void);
 	u32 (*uof_get_ae_mask)(struct adf_accel_dev *accel_dev, u32 obj_num);
 	int (*dev_config)(struct adf_accel_dev *accel_dev);
+	struct adf_hw_csr_info csr_info;
 	struct adf_pfvf_ops pfvf_ops;
-	struct adf_hw_csr_ops csr_ops;
 	struct adf_dc_ops dc_ops;
 	const char *fw_name;
 	const char *fw_mmp_name;
@@ -252,7 +306,7 @@ struct adf_hw_device_data {
 	(((GET_HW_DATA(accel_dev)->ring_to_svc_map) >> (ADF_SRV_TYPE_BIT_LEN * (idx))) \
 	& ADF_SRV_TYPE_MASK)
 #define GET_MAX_ACCELENGINES(accel_dev) (GET_HW_DATA(accel_dev)->num_engines)
-#define GET_CSR_OPS(accel_dev) (&(accel_dev)->hw_device->csr_ops)
+#define GET_CSR_OPS(accel_dev) (&(accel_dev)->hw_device->csr_info.csr_ops)
 #define GET_PFVF_OPS(accel_dev) (&(accel_dev)->hw_device->pfvf_ops)
 #define GET_DC_OPS(accel_dev) (&(accel_dev)->hw_device->dc_ops)
 #define accel_to_pci_dev(accel_ptr) accel_ptr->accel_pci_dev.pci_dev
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen2_hw_data.c b/drivers/crypto/intel/qat/qat_common/adf_gen2_hw_data.c
index d1884547b5a1..d956910f3228 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen2_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen2_hw_data.c
@@ -160,9 +160,10 @@ static void write_csr_int_flag(void __iomem *csr_base_addr, u32 bank, u32 value)
 	WRITE_CSR_INT_FLAG(csr_base_addr, bank, value);
 }
 
-static void write_csr_int_srcsel(void __iomem *csr_base_addr, u32 bank)
+static void write_csr_int_srcsel(void __iomem *csr_base_addr, u32 bank,
+				 u32 idx, u32 value)
 {
-	WRITE_CSR_INT_SRCSEL(csr_base_addr, bank);
+	WRITE_CSR_INT_SRCSEL(csr_base_addr, bank, idx, value);
 }
 
 static void write_csr_int_col_en(void __iomem *csr_base_addr, u32 bank,
@@ -189,8 +190,17 @@ static void write_csr_ring_srv_arb_en(void __iomem *csr_base_addr, u32 bank,
 	WRITE_CSR_RING_SRV_ARB_EN(csr_base_addr, bank, value);
 }
 
-void adf_gen2_init_hw_csr_ops(struct adf_hw_csr_ops *csr_ops)
+static u32 get_src_sel_mask(void)
 {
+	return ADF_BANK_INT_SRC_SEL_MASK_X;
+}
+
+void adf_gen2_init_hw_csr_ops(struct adf_hw_csr_info *csr_info)
+{
+	struct adf_hw_csr_ops *csr_ops = &csr_info->csr_ops;
+
+	csr_info->num_rings_per_int_srcsel = ADF_RINGS_PER_INT_SRCSEL;
+
 	csr_ops->build_csr_ring_base_addr = build_csr_ring_base_addr;
 	csr_ops->read_csr_ring_head = read_csr_ring_head;
 	csr_ops->write_csr_ring_head = write_csr_ring_head;
@@ -205,6 +215,7 @@ void adf_gen2_init_hw_csr_ops(struct adf_hw_csr_ops *csr_ops)
 	csr_ops->write_csr_int_col_ctl = write_csr_int_col_ctl;
 	csr_ops->write_csr_int_flag_and_col = write_csr_int_flag_and_col;
 	csr_ops->write_csr_ring_srv_arb_en = write_csr_ring_srv_arb_en;
+	csr_ops->get_src_sel_mask = get_src_sel_mask;
 }
 EXPORT_SYMBOL_GPL(adf_gen2_init_hw_csr_ops);
 
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen2_hw_data.h b/drivers/crypto/intel/qat/qat_common/adf_gen2_hw_data.h
index e4bc07529be4..631eb2e2f334 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen2_hw_data.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen2_hw_data.h
@@ -7,8 +7,10 @@
 #include "adf_cfg_common.h"
 
 /* Transport access */
+#define ADF_RINGS_PER_INT_SRCSEL	BIT(3)
 #define ADF_BANK_INT_SRC_SEL_MASK_0	0x4444444CUL
 #define ADF_BANK_INT_SRC_SEL_MASK_X	0x44444444UL
+#define ADF_RING_SRV_ARB_EN_MASK	GENMASK(7, 0)
 #define ADF_RING_CSR_RING_CONFIG	0x000
 #define ADF_RING_CSR_RING_LBASE		0x040
 #define ADF_RING_CSR_RING_UBASE		0x080
@@ -25,6 +27,7 @@
 #define ADF_RING_BUNDLE_SIZE		0x1000
 #define ADF_GEN2_RX_RINGS_OFFSET	8
 #define ADF_GEN2_TX_RINGS_MASK		0xFF
+#define ADF_RING_CSR_NEXT_INT_SRCSEL	BIT(2)
 
 #define BUILD_RING_BASE_ADDR(addr, size) \
 	(((addr) >> 6) & (GENMASK_ULL(63, 0) << (size)))
@@ -60,7 +63,10 @@ do { \
 #define WRITE_CSR_INT_FLAG(csr_base_addr, bank, value) \
 	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * (bank)) + \
 		   ADF_RING_CSR_INT_FLAG, value)
-#define WRITE_CSR_INT_SRCSEL(csr_base_addr, bank) \
+#define READ_CSR_INT_SRCSEL(csr_base_addr, bank, idx) \
+	ADF_CSR_RD(csr_base_addr, ADF_RING_BUNDLE_SIZE * (bank) + \
+	ADF_RING_CSR_INT_SRCSEL + (idx) * ADF_RING_CSR_NEXT_INT_SRCSEL)
+#define WRITE_CSR_INT_SRCSEL(csr_base_addr, bank, idx, value) \
 do { \
 	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * (bank)) + \
 	ADF_RING_CSR_INT_SRCSEL, ADF_BANK_INT_SRC_SEL_MASK_0); \
@@ -155,7 +161,7 @@ u32 adf_gen2_get_num_aes(struct adf_hw_device_data *self);
 void adf_gen2_enable_error_correction(struct adf_accel_dev *accel_dev);
 void adf_gen2_cfg_iov_thds(struct adf_accel_dev *accel_dev, bool enable,
 			   int num_a_regs, int num_b_regs);
-void adf_gen2_init_hw_csr_ops(struct adf_hw_csr_ops *csr_ops);
+void adf_gen2_init_hw_csr_ops(struct adf_hw_csr_info *csr_info);
 void adf_gen2_get_admin_info(struct admin_info *admin_csrs_info);
 void adf_gen2_get_arb_info(struct arb_info *arb_info);
 void adf_gen2_enable_ints(struct adf_accel_dev *accel_dev);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c
index 3148a62938fd..924d51ebd3c3 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c
@@ -32,32 +32,113 @@ static void write_csr_ring_tail(void __iomem *csr_base_addr, u32 bank, u32 ring,
 	WRITE_CSR_RING_TAIL(csr_base_addr, bank, ring, value);
 }
 
+static u32 read_csr_stat(void __iomem *csr_base_addr, u32 bank)
+{
+	return READ_CSR_STAT(csr_base_addr, bank);
+}
+
+static u32 read_csr_uo_stat(void __iomem *csr_base_addr, u32 bank)
+{
+	return READ_CSR_UO_STAT(csr_base_addr, bank);
+}
+
 static u32 read_csr_e_stat(void __iomem *csr_base_addr, u32 bank)
 {
 	return READ_CSR_E_STAT(csr_base_addr, bank);
 }
 
+static u32 read_csr_ne_stat(void __iomem *csr_base_addr, u32 bank)
+{
+	return READ_CSR_NE_STAT(csr_base_addr, bank);
+}
+
+static u32 read_csr_nf_stat(void __iomem *csr_base_addr, u32 bank)
+{
+	return READ_CSR_NF_STAT(csr_base_addr, bank);
+}
+
+static u32 read_csr_f_stat(void __iomem *csr_base_addr, u32 bank)
+{
+	return READ_CSR_F_STAT(csr_base_addr, bank);
+}
+
+static u32 read_csr_c_stat(void __iomem *csr_base_addr, u32 bank)
+{
+	return READ_CSR_C_STAT(csr_base_addr, bank);
+}
+
+static u32 read_csr_exp_stat(void __iomem *csr_base_addr, u32 bank)
+{
+	return READ_CSR_EXP_STAT(csr_base_addr, bank);
+}
+
+static u32 read_csr_exp_int_en(void __iomem *csr_base_addr, u32 bank)
+{
+	return READ_CSR_EXP_INT_EN(csr_base_addr, bank);
+}
+
+static void write_csr_exp_int_en(void __iomem *csr_base_addr, u32 bank, u32 value)
+{
+	WRITE_CSR_EXP_INT_EN(csr_base_addr, bank, value);
+}
+
+static u32 read_csr_ring_config(void __iomem *csr_base_addr, u32 bank, u32 ring)
+{
+	return READ_CSR_RING_CONFIG(csr_base_addr, bank, ring);
+}
+
 static void write_csr_ring_config(void __iomem *csr_base_addr, u32 bank, u32 ring,
 				  u32 value)
 {
 	WRITE_CSR_RING_CONFIG(csr_base_addr, bank, ring, value);
 }
 
+static dma_addr_t read_csr_ring_base(void __iomem *csr_base_addr, u32 bank, u32 ring)
+{
+	return READ_CSR_RING_BASE(csr_base_addr, bank, ring);
+}
+
 static void write_csr_ring_base(void __iomem *csr_base_addr, u32 bank, u32 ring,
 				dma_addr_t addr)
 {
 	WRITE_CSR_RING_BASE(csr_base_addr, bank, ring, addr);
 }
 
+static u32 read_csr_int_en(void __iomem *csr_base_addr, u32 bank)
+{
+	return READ_CSR_INT_EN(csr_base_addr, bank);
+}
+
+static void write_csr_int_en(void __iomem *csr_base_addr, u32 bank, u32 value)
+{
+	WRITE_CSR_INT_EN(csr_base_addr, bank, value);
+}
+
+static u32 read_csr_int_flag(void __iomem *csr_base_addr, u32 bank)
+{
+	return READ_CSR_INT_FLAG(csr_base_addr, bank);
+}
+
 static void write_csr_int_flag(void __iomem *csr_base_addr, u32 bank,
 			       u32 value)
 {
 	WRITE_CSR_INT_FLAG(csr_base_addr, bank, value);
 }
 
-static void write_csr_int_srcsel(void __iomem *csr_base_addr, u32 bank)
+static u32 read_csr_int_srcsel(void __iomem *csr_base_addr, u32 bank, u32 idx)
 {
-	WRITE_CSR_INT_SRCSEL(csr_base_addr, bank);
+	return READ_CSR_INT_SRCSEL(csr_base_addr, bank, idx);
+}
+
+static void write_csr_int_srcsel(void __iomem *csr_base_addr, u32 bank,
+				 u32 idx, u32 value)
+{
+	WRITE_CSR_INT_SRCSEL(csr_base_addr, bank, idx, value);
+}
+
+static u32 read_csr_int_col_en(void __iomem *csr_base_addr, u32 bank)
+{
+	return READ_CSR_INT_COL_EN(csr_base_addr, bank);
 }
 
 static void write_csr_int_col_en(void __iomem *csr_base_addr, u32 bank, u32 value)
@@ -65,26 +146,56 @@ static void write_csr_int_col_en(void __iomem *csr_base_addr, u32 bank, u32 valu
 	WRITE_CSR_INT_COL_EN(csr_base_addr, bank, value);
 }
 
+static u32 read_csr_int_col_ctl(void __iomem *csr_base_addr, u32 bank)
+{
+	return READ_CSR_INT_COL_CTL(csr_base_addr, bank);
+}
+
 static void write_csr_int_col_ctl(void __iomem *csr_base_addr, u32 bank,
 				  u32 value)
 {
 	WRITE_CSR_INT_COL_CTL(csr_base_addr, bank, value);
 }
 
+static u32 read_csr_int_flag_and_col(void __iomem *csr_base_addr, u32 bank)
+{
+	return READ_CSR_INT_FLAG_AND_COL(csr_base_addr, bank);
+}
+
 static void write_csr_int_flag_and_col(void __iomem *csr_base_addr, u32 bank,
 				       u32 value)
 {
 	WRITE_CSR_INT_FLAG_AND_COL(csr_base_addr, bank, value);
 }
 
+static u32 read_csr_ring_srv_arb_en(void __iomem *csr_base_addr, u32 bank)
+{
+	return READ_CSR_RING_SRV_ARB_EN(csr_base_addr, bank);
+}
+
 static void write_csr_ring_srv_arb_en(void __iomem *csr_base_addr, u32 bank,
 				      u32 value)
 {
 	WRITE_CSR_RING_SRV_ARB_EN(csr_base_addr, bank, value);
 }
 
-void adf_gen4_init_hw_csr_ops(struct adf_hw_csr_ops *csr_ops)
+static u32 get_src_sel_mask(void)
+{
+	return ADF_BANK_INT_SRC_SEL_MASK;
+}
+
+static u32 get_int_col_ctl_enable_mask(void)
+{
+	return ADF_RING_CSR_INT_COL_CTL_ENABLE;
+}
+
+void adf_gen4_init_hw_csr_ops(struct adf_hw_csr_info *csr_info)
 {
+	struct adf_hw_csr_ops *csr_ops = &csr_info->csr_ops;
+
+	csr_info->num_rings_per_int_srcsel = ADF_RINGS_PER_INT_SRCSEL;
+	csr_info->arb_enable_mask = ADF_RING_SRV_ARB_EN_MASK;
+
 	csr_ops->build_csr_ring_base_addr = build_csr_ring_base_addr;
 	csr_ops->read_csr_ring_head = read_csr_ring_head;
 	csr_ops->write_csr_ring_head = write_csr_ring_head;
@@ -94,11 +205,17 @@ void adf_gen4_init_hw_csr_ops(struct adf_hw_csr_ops *csr_ops)
 	csr_ops->write_csr_ring_config = write_csr_ring_config;
 	csr_ops->write_csr_ring_base = write_csr_ring_base;
 	csr_ops->write_csr_int_flag = write_csr_int_flag;
+	csr_ops->read_csr_int_srcsel = read_csr_int_srcsel;
 	csr_ops->write_csr_int_srcsel = write_csr_int_srcsel;
+	csr_ops->read_csr_int_col_en = read_csr_int_col_en;
 	csr_ops->write_csr_int_col_en = write_csr_int_col_en;
+	csr_ops->read_csr_int_col_ctl = read_csr_int_col_ctl;
 	csr_ops->write_csr_int_col_ctl = write_csr_int_col_ctl;
 	csr_ops->write_csr_int_flag_and_col = write_csr_int_flag_and_col;
+	csr_ops->read_csr_ring_srv_arb_en = read_csr_ring_srv_arb_en;
 	csr_ops->write_csr_ring_srv_arb_en = write_csr_ring_srv_arb_en;
+	csr_ops->get_src_sel_mask = get_src_sel_mask;
+	csr_ops->get_int_col_ctl_enable_mask = get_int_col_ctl_enable_mask;
 }
 EXPORT_SYMBOL_GPL(adf_gen4_init_hw_csr_ops);
 
@@ -192,3 +309,242 @@ int adf_gen4_ring_pair_reset(struct adf_accel_dev *accel_dev, u32 bank_number)
 	return ret;
 }
 EXPORT_SYMBOL_GPL(adf_gen4_ring_pair_reset);
+
+static int drain_ring_pair(void __iomem *csr, u32 bank_number, int timeout_us)
+{
+	u32 status;
+	int ret;
+
+	ADF_CSR_WR(csr, ADF_WQM_CSR_RPRESETCTL(bank_number),
+		   ADF_WQM_CSR_RPRESETCTL_DRAIN);
+
+	ret = read_poll_timeout(ADF_CSR_RD, status,
+				status & ADF_WQM_CSR_RPRESETSTS_STATUS,
+				ADF_RPRESET_POLL_DELAY_US, timeout_us, true, csr,
+				ADF_WQM_CSR_RPRESETSTS(bank_number));
+	if (ret)
+		return ret;
+
+	ADF_CSR_WR(csr, ADF_WQM_CSR_RPRESETSTS(bank_number),
+		   ADF_WQM_CSR_RPRESETSTS_STATUS);
+
+	return 0;
+}
+
+int adf_gen4_ring_pair_drain(struct adf_accel_dev *accel_dev, u32 bank_number,
+			     int timeout_us)
+{
+	struct adf_hw_device_data *hw_data = GET_HW_DATA(accel_dev);
+	struct adf_bar *etr_bar;
+	void __iomem *csr;
+	int ret;
+
+	if (bank_number >= hw_data->num_banks || timeout_us < 0)
+		return -EINVAL;
+
+	etr_bar = &GET_BARS(accel_dev)[hw_data->get_etr_bar_id(hw_data)];
+	csr = etr_bar->virt_addr;
+
+	dev_dbg(&GET_DEV(accel_dev), "ring pair drain for bank:%d\n", bank_number);
+
+	ret = drain_ring_pair(csr, bank_number, timeout_us);
+	if (ret)
+		dev_err(&GET_DEV(accel_dev), "ring pair drain failure (timeout)\n");
+	else
+		dev_dbg(&GET_DEV(accel_dev), "ring pair drained successfully\n");
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(adf_gen4_ring_pair_drain);
+
+static void gen4_bank_state_save(void __iomem *csr, u32 bank_number,
+				 struct bank_state *state, u32 num_rings)
+{
+	u32 i;
+
+	state->ringstat0 = read_csr_stat(csr, bank_number);
+	state->ringuostat = read_csr_uo_stat(csr, bank_number);
+	state->ringestat = read_csr_e_stat(csr, bank_number);
+	state->ringnestat = read_csr_ne_stat(csr, bank_number);
+	state->ringnfstat = read_csr_nf_stat(csr, bank_number);
+	state->ringfstat = read_csr_f_stat(csr, bank_number);
+	state->ringcstat0 = read_csr_c_stat(csr, bank_number);
+	state->iaintflagen = read_csr_int_en(csr, bank_number);
+	state->iaintflagreg = read_csr_int_flag(csr, bank_number);
+	state->iaintflagsrcsel0 = read_csr_int_srcsel(csr, bank_number, 0);
+	state->iaintcolen = read_csr_int_col_en(csr, bank_number);
+	state->iaintcolctl = read_csr_int_col_ctl(csr, bank_number);
+	state->iaintflagandcolen = read_csr_int_flag_and_col(csr, bank_number);
+	state->ringexpstat = read_csr_exp_stat(csr, bank_number);
+	state->ringexpintenable = read_csr_exp_int_en(csr, bank_number);
+	state->ringsrvarben = read_csr_ring_srv_arb_en(csr, bank_number);
+	state->num_rings = num_rings;
+
+	for (i = 0; i < num_rings; i++) {
+		state->rings[i].head = read_csr_ring_head(csr, bank_number, i);
+		state->rings[i].tail = read_csr_ring_tail(csr, bank_number, i);
+		state->rings[i].config = read_csr_ring_config(csr, bank_number, i);
+		state->rings[i].base = read_csr_ring_base(csr, bank_number, i);
+	}
+}
+
+#define ADF_RP_INT_SRC_SEL_F_RISE_MASK BIT(2)
+#define ADF_RP_INT_SRC_SEL_F_FALL_MASK GENMASK(2, 0)
+static int gen4_bank_state_restore(void __iomem *csr, u32 bank_number,
+				   struct bank_state *state, u32 num_rings,
+				   int tx_rx_gap)
+{
+	u32 val, tmp_val, i;
+
+	write_csr_ring_srv_arb_en(csr, bank_number, 0);
+
+	for (i = 0; i < num_rings; i++)
+		write_csr_ring_base(csr, bank_number, i, state->rings[i].base);
+
+	for (i = 0; i < num_rings; i++)
+		write_csr_ring_config(csr, bank_number, i, state->rings[i].config);
+
+	for (i = 0; i < num_rings / 2; i++) {
+		int tx = i * (tx_rx_gap + 1);
+		int rx = tx + tx_rx_gap;
+		u32 tx_idx = tx / ADF_RINGS_PER_INT_SRCSEL;
+		u32 rx_idx = rx / ADF_RINGS_PER_INT_SRCSEL;
+
+		write_csr_ring_head(csr, bank_number, tx, state->rings[tx].head);
+
+		write_csr_ring_tail(csr, bank_number, tx, state->rings[tx].tail);
+
+		if (state->ringestat & (BIT(tx))) {
+			val = read_csr_int_srcsel(csr, bank_number, tx_idx);
+			val |= (ADF_RP_INT_SRC_SEL_F_RISE_MASK << (8 * tx));
+			write_csr_int_srcsel(csr, bank_number, tx_idx, val);
+			write_csr_ring_head(csr, bank_number, tx, state->rings[tx].head);
+		}
+
+		write_csr_ring_tail(csr, bank_number, rx, state->rings[rx].tail);
+
+		val = read_csr_int_srcsel(csr, bank_number, rx_idx);
+		val |= (ADF_RP_INT_SRC_SEL_F_RISE_MASK << (8 * rx));
+		write_csr_int_srcsel(csr, bank_number, rx_idx, val);
+
+		write_csr_ring_head(csr, bank_number, rx, state->rings[rx].head);
+
+		val = read_csr_int_srcsel(csr, bank_number, rx_idx);
+		val |= (ADF_RP_INT_SRC_SEL_F_FALL_MASK << (8 * rx));
+		write_csr_int_srcsel(csr, bank_number, rx_idx, val);
+
+		if (state->ringfstat & BIT(rx))
+			write_csr_ring_tail(csr, bank_number, rx, state->rings[rx].tail);
+	}
+
+	write_csr_int_flag_and_col(csr, bank_number, state->iaintflagandcolen);
+	write_csr_int_en(csr, bank_number, state->iaintflagen);
+	write_csr_int_col_en(csr, bank_number, state->iaintcolen);
+	write_csr_int_srcsel(csr, bank_number, 0, state->iaintflagsrcsel0);
+	write_csr_exp_int_en(csr, bank_number, state->ringexpintenable);
+	write_csr_int_col_ctl(csr, bank_number, state->iaintcolctl);
+
+	/* Check that all ring statuses are restored into a saved state. */
+	tmp_val = read_csr_stat(csr, bank_number);
+	val = state->ringstat0;
+	if (tmp_val != val) {
+		pr_err("Fail to restore ringstat register. Expected 0x%x, but actual is 0x%x\n",
+		       tmp_val, val);
+		return -EINVAL;
+	}
+
+	tmp_val = read_csr_e_stat(csr, bank_number);
+	val = state->ringestat;
+	if (tmp_val != val) {
+		pr_err("Fail to restore ringestat register. Expected 0x%x, but actual is 0x%x\n",
+		       tmp_val, val);
+		return -EINVAL;
+	}
+
+	tmp_val = read_csr_ne_stat(csr, bank_number);
+	val = state->ringnestat;
+	if (tmp_val != val) {
+		pr_err("Fail to restore ringnestat register. Expected 0x%x, but actual is 0x%x\n",
+		       tmp_val, val);
+		return -EINVAL;
+	}
+
+	tmp_val = read_csr_nf_stat(csr, bank_number);
+	val = state->ringnfstat;
+	if (tmp_val != val) {
+		pr_err("Fail to restore ringnfstat register. Expected 0x%x, but actual is 0x%x\n",
+		       tmp_val, val);
+		return -EINVAL;
+	}
+
+	tmp_val = read_csr_f_stat(csr, bank_number);
+	val = state->ringfstat;
+	if (tmp_val != val) {
+		pr_err("Fail to restore ringfstat register. Expected 0x%x, but actual is 0x%x\n",
+		       tmp_val, val);
+		return -EINVAL;
+	}
+
+	tmp_val = read_csr_c_stat(csr, bank_number);
+	val = state->ringcstat0;
+	if (tmp_val != val) {
+		pr_err("Fail to restore ringcstat register. Expected 0x%x, but actual is 0x%x\n",
+		       tmp_val, val);
+		return -EINVAL;
+	}
+
+	tmp_val = read_csr_exp_stat(csr, bank_number);
+	val = state->ringexpstat;
+	if (tmp_val && !val) {
+		pr_err("Bank was restored with exception: 0x%x\n", val);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+int adf_gen4_bank_state_save(struct adf_accel_dev *accel_dev, u32 bank_number,
+			     struct bank_state *state)
+{
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	struct adf_bar *etr_bar;
+	void __iomem *csr;
+
+	if (bank_number >= hw_data->num_banks || !state)
+		return -EINVAL;
+
+	etr_bar = &GET_BARS(accel_dev)[hw_data->get_etr_bar_id(hw_data)];
+	csr = etr_bar->virt_addr;
+
+	dev_dbg(&GET_DEV(accel_dev), "Saving state of bank: %d\n", bank_number);
+
+	gen4_bank_state_save(csr, bank_number, state, hw_data->num_rings_per_bank);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(adf_gen4_bank_state_save);
+
+int adf_gen4_bank_state_restore(struct adf_accel_dev *accel_dev,
+				u32 bank_number, struct bank_state *state)
+{
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	struct adf_bar *etr_bar;
+	void __iomem *csr;
+	int ret;
+
+	if (bank_number >= hw_data->num_banks)
+		return -EINVAL;
+
+	etr_bar = &GET_BARS(accel_dev)[hw_data->get_etr_bar_id(hw_data)];
+	csr = etr_bar->virt_addr;
+
+	dev_dbg(&GET_DEV(accel_dev), "Restoring state of bank: %d\n", bank_number);
+
+	ret = gen4_bank_state_restore(csr, bank_number, state,
+				      hw_data->num_rings_per_bank, hw_data->tx_rx_gap);
+	if (ret)
+		dev_err(&GET_DEV(accel_dev), "Unable to restore state of bank %d\n", bank_number);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(adf_gen4_bank_state_restore);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.h b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.h
index 4fb4b3df5a18..d2a4192aaa6d 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.h
@@ -3,23 +3,36 @@
 #ifndef ADF_GEN4_HW_CSR_DATA_H_
 #define ADF_GEN4_HW_CSR_DATA_H_
 
+#include <linux/bitfield.h>
 #include "adf_accel_devices.h"
 #include "adf_cfg_common.h"
 
 /* Transport access */
+#define ADF_RINGS_PER_INT_SRCSEL	BIT(1)
 #define ADF_BANK_INT_SRC_SEL_MASK	0x44UL
+#define ADF_RING_SRV_ARB_EN_MASK	BIT(0)
 #define ADF_RING_CSR_RING_CONFIG	0x1000
 #define ADF_RING_CSR_RING_LBASE		0x1040
 #define ADF_RING_CSR_RING_UBASE		0x1080
 #define ADF_RING_CSR_RING_HEAD		0x0C0
 #define ADF_RING_CSR_RING_TAIL		0x100
+#define ADF_RING_CSR_STAT		0x140
+#define ADF_RING_CSR_UO_STAT		0x148
 #define ADF_RING_CSR_E_STAT		0x14C
+#define ADF_RING_CSR_NE_STAT		0x150
+#define ADF_RING_CSR_NF_STAT		0x154
+#define ADF_RING_CSR_F_STAT		0x158
+#define ADF_RING_CSR_C_STAT		0x15C
+#define ADF_RING_CSR_INT_FLAG_EN	0x16C
 #define ADF_RING_CSR_INT_FLAG		0x170
 #define ADF_RING_CSR_INT_SRCSEL		0x174
+#define ADF_RING_CSR_INT_COL_EN		0x17C
 #define ADF_RING_CSR_INT_COL_CTL	0x180
 #define ADF_RING_CSR_INT_FLAG_AND_COL	0x184
+#define ADF_RING_CSR_EXP_STAT		0x188
+#define ADF_RING_CSR_EXP_INT_EN		0x18C
 #define ADF_RING_CSR_INT_COL_CTL_ENABLE	0x80000000
-#define ADF_RING_CSR_INT_COL_EN		0x17C
+#define ADF_RING_CSR_NEXT_INT_SRCSEL	BIT(2)
 #define ADF_RING_CSR_ADDR_OFFSET	0x100000
 #define ADF_RING_BUNDLE_SIZE		0x2000
 
@@ -33,9 +46,49 @@
 	ADF_CSR_RD((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
 		   ADF_RING_BUNDLE_SIZE * (bank) + \
 		   ADF_RING_CSR_RING_TAIL + ((ring) << 2))
+#define READ_CSR_STAT(csr_base_addr, bank) \
+	ADF_CSR_RD((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
+		ADF_RING_BUNDLE_SIZE * (bank) + \
+		ADF_RING_CSR_STAT)
+#define READ_CSR_UO_STAT(csr_base_addr, bank) \
+	ADF_CSR_RD((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
+		ADF_RING_BUNDLE_SIZE * (bank) + \
+		ADF_RING_CSR_UO_STAT)
 #define READ_CSR_E_STAT(csr_base_addr, bank) \
 	ADF_CSR_RD((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
 		   ADF_RING_BUNDLE_SIZE * (bank) + ADF_RING_CSR_E_STAT)
+#define READ_CSR_NE_STAT(csr_base_addr, bank) \
+	ADF_CSR_RD((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
+		ADF_RING_BUNDLE_SIZE * (bank) + \
+		ADF_RING_CSR_NE_STAT)
+#define READ_CSR_NF_STAT(csr_base_addr, bank) \
+	ADF_CSR_RD((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
+		ADF_RING_BUNDLE_SIZE * (bank) + \
+		ADF_RING_CSR_NF_STAT)
+#define READ_CSR_F_STAT(csr_base_addr, bank) \
+	ADF_CSR_RD((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
+		ADF_RING_BUNDLE_SIZE * (bank) + \
+		ADF_RING_CSR_F_STAT)
+#define READ_CSR_C_STAT(csr_base_addr, bank) \
+	ADF_CSR_RD((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
+		ADF_RING_BUNDLE_SIZE * (bank) + \
+		ADF_RING_CSR_C_STAT)
+#define READ_CSR_EXP_STAT(csr_base_addr, bank) \
+	ADF_CSR_RD((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
+		ADF_RING_BUNDLE_SIZE * (bank) + \
+		ADF_RING_CSR_EXP_STAT)
+#define READ_CSR_EXP_INT_EN(csr_base_addr, bank) \
+	ADF_CSR_RD((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
+		ADF_RING_BUNDLE_SIZE * (bank) + \
+		ADF_RING_CSR_EXP_INT_EN)
+#define WRITE_CSR_EXP_INT_EN(csr_base_addr, bank, value) \
+	ADF_CSR_WR((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
+		ADF_RING_BUNDLE_SIZE * (bank) + \
+		ADF_RING_CSR_EXP_INT_EN, value)
+#define READ_CSR_RING_CONFIG(csr_base_addr, bank, ring) \
+	ADF_CSR_RD((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
+		ADF_RING_BUNDLE_SIZE * (bank) + \
+		ADF_RING_CSR_RING_CONFIG + ((ring) << 2))
 #define WRITE_CSR_RING_CONFIG(csr_base_addr, bank, ring, value) \
 	ADF_CSR_WR((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
 		   ADF_RING_BUNDLE_SIZE * (bank) + \
@@ -57,6 +110,32 @@ do { \
 		   ADF_RING_CSR_RING_UBASE + ((_ring) << 2), u_base);	\
 } while (0)
 
+static inline u64 read_base(void __iomem *csr_base_addr,
+			    u32 bank,
+			    u32 ring)
+{
+	u32 l_base, u_base;
+	u64 addr;
+
+	/*
+	 * Use special IO wrapper for ring base as LBASE and UBASE are
+	 * not physical contigious
+	 */
+	l_base = ADF_CSR_RD(csr_base_addr, (ADF_RING_BUNDLE_SIZE * bank) +
+			    ADF_RING_CSR_RING_LBASE + (ring << 2));
+	u_base = ADF_CSR_RD(csr_base_addr, (ADF_RING_BUNDLE_SIZE * bank) +
+			    ADF_RING_CSR_RING_UBASE + (ring << 2));
+
+	addr = FIELD_GET(GENMASK_ULL(31, 0), (u64)l_base);
+	addr |= FIELD_GET(GENMASK_ULL(31, 0), (u64)u_base) << 32;
+
+	return addr;
+}
+
+#define READ_CSR_RING_BASE(csr_base_addr, bank, ring) \
+	read_base(((csr_base_addr) + \
+		       ADF_RING_CSR_ADDR_OFFSET), (bank), (ring))
+
 #define WRITE_CSR_RING_HEAD(csr_base_addr, bank, ring, value) \
 	ADF_CSR_WR((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
 		   ADF_RING_BUNDLE_SIZE * (bank) + \
@@ -65,23 +144,52 @@ do { \
 	ADF_CSR_WR((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
 		   ADF_RING_BUNDLE_SIZE * (bank) + \
 		   ADF_RING_CSR_RING_TAIL + ((ring) << 2), value)
+#define READ_CSR_INT_EN(csr_base_addr, bank) \
+	ADF_CSR_RD((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
+		ADF_RING_BUNDLE_SIZE * (bank) + \
+		ADF_RING_CSR_INT_FLAG_EN)
+#define WRITE_CSR_INT_EN(csr_base_addr, bank, value) \
+	ADF_CSR_WR((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
+		ADF_RING_BUNDLE_SIZE * (bank) + \
+		ADF_RING_CSR_INT_FLAG_EN, (value))
+#define READ_CSR_INT_FLAG(csr_base_addr, bank) \
+	ADF_CSR_RD((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
+		ADF_RING_BUNDLE_SIZE * (bank) + \
+		ADF_RING_CSR_INT_FLAG)
 #define WRITE_CSR_INT_FLAG(csr_base_addr, bank, value) \
 	ADF_CSR_WR((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
 		   ADF_RING_BUNDLE_SIZE * (bank) + \
 		   ADF_RING_CSR_INT_FLAG, (value))
-#define WRITE_CSR_INT_SRCSEL(csr_base_addr, bank) \
+#define READ_CSR_INT_SRCSEL(csr_base_addr, bank, idx) \
+	ADF_CSR_RD((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
+	ADF_RING_BUNDLE_SIZE * (bank) + \
+	ADF_RING_CSR_INT_SRCSEL + (idx) * ADF_RING_CSR_NEXT_INT_SRCSEL)
+#define WRITE_CSR_INT_SRCSEL(csr_base_addr, bank, idx, value) \
 	ADF_CSR_WR((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
-		   ADF_RING_BUNDLE_SIZE * (bank) + \
-		   ADF_RING_CSR_INT_SRCSEL, ADF_BANK_INT_SRC_SEL_MASK)
+	ADF_RING_BUNDLE_SIZE * (bank) + \
+	ADF_RING_CSR_INT_SRCSEL + ((idx) * ADF_RING_CSR_NEXT_INT_SRCSEL), \
+	(value))
+#define READ_CSR_INT_COL_EN(csr_base_addr, bank) \
+	ADF_CSR_RD((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
+		ADF_RING_BUNDLE_SIZE * (bank) + \
+		ADF_RING_CSR_INT_COL_EN)
 #define WRITE_CSR_INT_COL_EN(csr_base_addr, bank, value) \
 	ADF_CSR_WR((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
 		   ADF_RING_BUNDLE_SIZE * (bank) + \
 		   ADF_RING_CSR_INT_COL_EN, (value))
+#define READ_CSR_INT_COL_CTL(csr_base_addr, bank) \
+	ADF_CSR_RD((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
+		ADF_RING_BUNDLE_SIZE * (bank) + \
+		ADF_RING_CSR_INT_COL_CTL)
 #define WRITE_CSR_INT_COL_CTL(csr_base_addr, bank, value) \
 	ADF_CSR_WR((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
 		   ADF_RING_BUNDLE_SIZE * (bank) + \
 		   ADF_RING_CSR_INT_COL_CTL, \
 		   ADF_RING_CSR_INT_COL_CTL_ENABLE | (value))
+#define READ_CSR_INT_FLAG_AND_COL(csr_base_addr, bank) \
+	ADF_CSR_RD((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
+		ADF_RING_BUNDLE_SIZE * (bank) + \
+		ADF_RING_CSR_INT_FLAG_AND_COL)
 #define WRITE_CSR_INT_FLAG_AND_COL(csr_base_addr, bank, value) \
 	ADF_CSR_WR((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
 		   ADF_RING_BUNDLE_SIZE * (bank) + \
@@ -90,6 +198,10 @@ do { \
 /* Arbiter configuration */
 #define ADF_RING_CSR_RING_SRV_ARB_EN 0x19C
 
+#define READ_CSR_RING_SRV_ARB_EN(csr_base_addr, bank) \
+	ADF_CSR_RD((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
+		ADF_RING_BUNDLE_SIZE * (bank) + \
+		ADF_RING_CSR_RING_SRV_ARB_EN)
 #define WRITE_CSR_RING_SRV_ARB_EN(csr_base_addr, bank, value) \
 	ADF_CSR_WR((csr_base_addr) + ADF_RING_CSR_ADDR_OFFSET, \
 		   ADF_RING_BUNDLE_SIZE * (bank) + \
@@ -122,6 +234,9 @@ do { \
 #define ADF_WQM_CSR_RPRESETSTS_STATUS	BIT(0)
 #define ADF_WQM_CSR_RPRESETSTS(bank)	(ADF_WQM_CSR_RPRESETCTL(bank) + 4)
 
+/* Ring drain */
+#define ADF_WQM_CSR_RPRESETCTL_DRAIN	BIT(2)
+
 /* Error source registers */
 #define ADF_GEN4_ERRSOU0	(0x41A200)
 #define ADF_GEN4_ERRSOU1	(0x41A204)
@@ -137,6 +252,12 @@ do { \
 #define ADF_GEN4_VFLNOTIFY	BIT(7)
 
 void adf_gen4_set_ssm_wdtimer(struct adf_accel_dev *accel_dev);
-void adf_gen4_init_hw_csr_ops(struct adf_hw_csr_ops *csr_ops);
+void adf_gen4_init_hw_csr_ops(struct adf_hw_csr_info *csr_info);
 int adf_gen4_ring_pair_reset(struct adf_accel_dev *accel_dev, u32 bank_number);
+int adf_gen4_ring_pair_drain(struct adf_accel_dev *accel_dev, u32 bank_number,
+			     int timeout_us);
+int adf_gen4_bank_state_save(struct adf_accel_dev *accel_dev, u32 bank_number,
+			     struct bank_state *state);
+int adf_gen4_bank_state_restore(struct adf_accel_dev *accel_dev,
+				u32 bank_number, struct bank_state *state);
 #endif
diff --git a/drivers/crypto/intel/qat/qat_common/adf_transport.c b/drivers/crypto/intel/qat/qat_common/adf_transport.c
index 630d0483c4e0..ce71ac17e617 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_transport.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_transport.c
@@ -387,10 +387,12 @@ static int adf_init_bank(struct adf_accel_dev *accel_dev,
 {
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
 	u8 num_rings_per_bank = hw_data->num_rings_per_bank;
-	struct adf_hw_csr_ops *csr_ops = &hw_data->csr_ops;
+	struct adf_hw_csr_info *csr_info = &hw_data->csr_info;
+	struct adf_hw_csr_ops *csr_ops = &csr_info->csr_ops;
 	u32 irq_mask = BIT(num_rings_per_bank) - 1;
 	struct adf_etr_ring_data *ring;
 	struct adf_etr_ring_data *tx_ring;
+	u32 num_rings_per_int_srcsel;
 	u32 i, coalesc_enabled = 0;
 	unsigned long ring_mask;
 	int size;
@@ -447,7 +449,12 @@ static int adf_init_bank(struct adf_accel_dev *accel_dev,
 	}
 
 	csr_ops->write_csr_int_flag(csr_addr, bank_num, irq_mask);
-	csr_ops->write_csr_int_srcsel(csr_addr, bank_num);
+
+	num_rings_per_int_srcsel = csr_info->num_rings_per_int_srcsel;
+
+	for (i = 0; i < num_rings_per_bank / num_rings_per_int_srcsel; i++)
+		csr_ops->write_csr_int_srcsel(csr_addr, bank_num, i,
+					      csr_ops->get_src_sel_mask());
 
 	return 0;
 err:
diff --git a/drivers/crypto/intel/qat/qat_common/adf_vf_isr.c b/drivers/crypto/intel/qat/qat_common/adf_vf_isr.c
index b05c3957a160..eab42026df8e 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_vf_isr.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_vf_isr.c
@@ -131,7 +131,7 @@ static irqreturn_t adf_isr(int irq, void *privdata)
 {
 	struct adf_accel_dev *accel_dev = privdata;
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
-	struct adf_hw_csr_ops *csr_ops = &hw_data->csr_ops;
+	struct adf_hw_csr_ops *csr_ops = GET_CSR_OPS(accel_dev);
 	struct adf_bar *pmisc =
 			&GET_BARS(accel_dev)[hw_data->get_misc_bar_id(hw_data)];
 	void __iomem *pmisc_bar_addr = pmisc->virt_addr;
diff --git a/drivers/crypto/intel/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c b/drivers/crypto/intel/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
index 1ebe0b351fae..2a01985ca7f5 100644
--- a/drivers/crypto/intel/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
@@ -242,7 +242,7 @@ void adf_init_hw_data_dh895xcc(struct adf_hw_device_data *hw_data)
 	hw_data->pfvf_ops.enable_vf2pf_interrupts = enable_vf2pf_interrupts;
 	hw_data->pfvf_ops.disable_all_vf2pf_interrupts = disable_all_vf2pf_interrupts;
 	hw_data->pfvf_ops.disable_pending_vf2pf_interrupts = disable_pending_vf2pf_interrupts;
-	adf_gen2_init_hw_csr_ops(&hw_data->csr_ops);
+	adf_gen2_init_hw_csr_ops(&hw_data->csr_info);
 	adf_gen2_init_dc_ops(&hw_data->dc_ops);
 }
 
diff --git a/drivers/crypto/intel/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c b/drivers/crypto/intel/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
index 70e56cc16ece..ac668c038fc6 100644
--- a/drivers/crypto/intel/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
@@ -91,7 +91,7 @@ void adf_init_hw_data_dh895xcciov(struct adf_hw_device_data *hw_data)
 	hw_data->dev_config = adf_gen2_dev_config;
 	adf_devmgr_update_class_index(hw_data);
 	adf_gen2_init_vf_pfvf_ops(&hw_data->pfvf_ops);
-	adf_gen2_init_hw_csr_ops(&hw_data->csr_ops);
+	adf_gen2_init_hw_csr_ops(&hw_data->csr_info);
 	adf_gen2_init_dc_ops(&hw_data->dc_ops);
 }
 
-- 
2.18.2

