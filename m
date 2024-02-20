Return-Path: <kvm+bounces-9125-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EDD2285B16E
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 04:30:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1DA761C22DA3
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 03:30:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC891535B4;
	Tue, 20 Feb 2024 03:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dnDDC9IB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A6759141;
	Tue, 20 Feb 2024 03:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708399790; cv=none; b=uclcxw3Iw7rSPPoxmz1fnvyYiKcygThE+56/4Qt6kZ0xGcf8SzukUrupxB3zVcoV7Xs9QICAfFJ/FYCoqkqlasFD9z29oC5DGSqc82Zkitr9eOIaZlh+WXCaR68/8mwdqoGAjyrxO+wI6r3TGCMb09wS6rJQOLroanoBHkYcwAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708399790; c=relaxed/simple;
	bh=tXm2AUnRIeOiFPqvc10RMVAIitrxexXPi1ajm/TZ1ws=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=AryGUo22JGYSxwDij6sS31YUCVHQ0S/qF/TeDSqFknX4WmqynQ26Ln/Lm2SpyGfRhOzFsVNBBnnRADMdGu5kNzczlNYcRRemc6KCdeTco4SnefOryvYKyKSyTxpwpVnrKcZwZdsXOu7f2iXcaEKUJecjv40lR/ij3pbZcUj2qIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dnDDC9IB; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708399789; x=1739935789;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=tXm2AUnRIeOiFPqvc10RMVAIitrxexXPi1ajm/TZ1ws=;
  b=dnDDC9IBAdrTBurjIU6LjzTKaAuMb9KlKSK8B5NjpLScaRYp/1Qt3Wfk
   8s6eEvmDatwn7NS1KDo9yv1bkwLTtUCxgKhoLU8UWmm61VxP2QfeCwrLX
   NCe2GvSt7Xb4/VRI3HLPnAsucq312PvYM8jJsmMLeF032TSJsJCHsHxlQ
   WFjtDze7qFBVeGH6klmK8QdHJrCy6Uqg7udqpihjul3PTcndnDkwhYDD7
   U9KvGISnHAuie9LRmIcODPa5C6/XDO7jzv6nJAIhrw1C8gLV6R1vja0Et
   wlJ1atqQLzZkt4eGFEjmL4ggRx4rSZoUTKPycZU+newsBuDgTR2xjNAit
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10989"; a="2354114"
X-IronPort-AV: E=Sophos;i="6.06,171,1705392000"; 
   d="scan'208";a="2354114"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2024 19:29:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,171,1705392000"; 
   d="scan'208";a="9302092"
Received: from qat-server-archercity1.sh.intel.com ([10.67.111.115])
  by orviesa003.jf.intel.com with ESMTP; 19 Feb 2024 19:29:46 -0800
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
	Siming Wan <siming.wan@intel.com>,
	Xin Zeng <xin.zeng@intel.com>
Subject: [PATCH v2 07/10] crypto: qat - add bank save and restore flows
Date: Tue, 20 Feb 2024 11:20:49 +0800
Message-Id: <20240220032052.66834-8-xin.zeng@intel.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20240220032052.66834-1-xin.zeng@intel.com>
References: <20240220032052.66834-1-xin.zeng@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

From: Siming Wan <siming.wan@intel.com>

Add logic to save, restore, quiesce and drain a ring bank for QAT GEN4
devices.
This allows to save and restore the state of a Virtual Function (VF) and
will be used to implement VM live migration.

Signed-off-by: Siming Wan <siming.wan@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Xin Zeng <xin.zeng@intel.com>
Signed-off-by: Xin Zeng <xin.zeng@intel.com>
---
 .../intel/qat/qat_4xxx/adf_4xxx_hw_data.c     |   2 +
 .../intel/qat/qat_common/adf_accel_devices.h  |  38 +++
 .../intel/qat/qat_common/adf_gen4_hw_data.c   | 279 ++++++++++++++++++
 .../intel/qat/qat_common/adf_gen4_hw_data.h   |  19 ++
 4 files changed, 338 insertions(+)

diff --git a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
index ef4b0aa36603..eaf055e6f938 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -455,6 +455,8 @@ void adf_init_hw_data_4xxx(struct adf_hw_device_data *hw_data, u32 dev_id)
 	hw_data->get_ring_to_svc_map = adf_gen4_get_ring_to_svc_map;
 	hw_data->disable_iov = adf_disable_sriov;
 	hw_data->ring_pair_reset = adf_gen4_ring_pair_reset;
+	hw_data->bank_state_save = adf_gen4_bank_state_save;
+	hw_data->bank_state_restore = adf_gen4_bank_state_restore;
 	hw_data->enable_pm = adf_gen4_enable_pm;
 	hw_data->handle_pm_interrupt = adf_gen4_handle_pm_interrupt;
 	hw_data->dev_config = adf_gen4_dev_config;
diff --git a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
index d1f3f5a822ff..986e63ec702d 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
@@ -140,6 +140,40 @@ struct admin_info {
 	u32 mailbox_offset;
 };
 
+struct ring_config {
+	u64 base;
+	u32 config;
+	u32 head;
+	u32 tail;
+	u32 reserved0;
+};
+
+struct bank_state {
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
+	u32 reserved0;
+	struct ring_config rings[ADF_ETR_MAX_RINGS_PER_BANK];
+};
+
 struct adf_hw_csr_ops {
 	u64 (*build_csr_ring_base_addr)(dma_addr_t addr, u32 size);
 	u32 (*read_csr_ring_head)(void __iomem *csr_base_addr, u32 bank,
@@ -271,6 +305,10 @@ struct adf_hw_device_data {
 	void (*enable_ints)(struct adf_accel_dev *accel_dev);
 	void (*set_ssm_wdtimer)(struct adf_accel_dev *accel_dev);
 	int (*ring_pair_reset)(struct adf_accel_dev *accel_dev, u32 bank_nr);
+	int (*bank_state_save)(struct adf_accel_dev *accel_dev, u32 bank_number,
+			       struct bank_state *state);
+	int (*bank_state_restore)(struct adf_accel_dev *accel_dev,
+				  u32 bank_number, struct bank_state *state);
 	void (*reset_device)(struct adf_accel_dev *accel_dev);
 	void (*set_msix_rttable)(struct adf_accel_dev *accel_dev);
 	const char *(*uof_get_name)(struct adf_accel_dev *accel_dev, u32 obj_num);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c
index 12269e309fbf..41a0979e68c1 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: (BSD-3-Clause OR GPL-2.0-only)
 /* Copyright(c) 2020 Intel Corporation */
 #include <linux/iopoll.h>
+#include <asm/div64.h>
 #include "adf_accel_devices.h"
 #include "adf_cfg_services.h"
 #include "adf_common_drv.h"
@@ -390,3 +391,281 @@ u16 adf_gen4_get_ring_to_svc_map(struct adf_accel_dev *accel_dev)
 	return ring_to_svc_map;
 }
 EXPORT_SYMBOL_GPL(adf_gen4_get_ring_to_svc_map);
+
+/*
+ * adf_gen4_bank_quiesce_coal_timer() - quiesce bank coalesced interrupt timer
+ * @accel_dev: Pointer to the device structure
+ * @bank_idx: Offset to the bank within this device
+ * @timeout_ms: Timeout in milliseconds for the operation
+ *
+ * This function tries to quiesce the coalesced interrupt timer of a bank if
+ * it has been enabled and triggered.
+ *
+ * Returns 0 on success, error code otherwise
+ *
+ */
+int adf_gen4_bank_quiesce_coal_timer(struct adf_accel_dev *accel_dev,
+				     u32 bank_idx, int timeout_ms)
+{
+	struct adf_hw_device_data *hw_data = GET_HW_DATA(accel_dev);
+	struct adf_hw_csr_ops *csr_ops = GET_CSR_OPS(accel_dev);
+	void __iomem *csr_misc = adf_get_pmisc_base(accel_dev);
+	void __iomem *csr_etr = adf_get_etr_base(accel_dev);
+	u32 int_col_ctl, int_col_mask, int_col_en;
+	u32 e_stat, intsrc;
+	u64 wait_us;
+	int ret;
+
+	if (timeout_ms < 0)
+		return -EINVAL;
+
+	int_col_ctl = csr_ops->read_csr_int_col_ctl(csr_etr, bank_idx);
+	int_col_mask = csr_ops->get_int_col_ctl_enable_mask();
+	if (!(int_col_ctl & int_col_mask))
+		return 0;
+
+	int_col_en = csr_ops->read_csr_int_col_en(csr_etr, bank_idx);
+	int_col_en &= BIT(ADF_WQM_CSR_RP_IDX_RX);
+
+	e_stat = csr_ops->read_csr_e_stat(csr_etr, bank_idx);
+	if (!(~e_stat & int_col_en))
+		return 0;
+
+	wait_us = 2 * ((int_col_ctl & ~int_col_mask) << 8) * USEC_PER_SEC;
+	do_div(wait_us, hw_data->clock_frequency);
+	wait_us = min(wait_us, (u64)timeout_ms * USEC_PER_MSEC);
+	dev_dbg(&GET_DEV(accel_dev),
+		"wait for bank %d - coalesced timer expires in %llu us (max=%u ms estat=0x%x intcolen=0x%x)\n",
+		bank_idx, wait_us, timeout_ms, e_stat, int_col_en);
+
+	ret = read_poll_timeout(ADF_CSR_RD, intsrc, intsrc,
+				ADF_COALESCED_POLL_DELAY_US, wait_us, true,
+				csr_misc, ADF_WQM_CSR_RPINTSOU(bank_idx));
+	if (ret)
+		dev_warn(&GET_DEV(accel_dev),
+			 "coalesced timer for bank %d expired (%llu us)\n",
+			 bank_idx, wait_us);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(adf_gen4_bank_quiesce_coal_timer);
+
+static int drain_bank(void __iomem *csr, u32 bank_number, int timeout_us)
+{
+	u32 status;
+
+	ADF_CSR_WR(csr, ADF_WQM_CSR_RPRESETCTL(bank_number),
+		   ADF_WQM_CSR_RPRESETCTL_DRAIN);
+
+	return read_poll_timeout(ADF_CSR_RD, status,
+				status & ADF_WQM_CSR_RPRESETSTS_STATUS,
+				ADF_RPRESET_POLL_DELAY_US, timeout_us, true,
+				csr, ADF_WQM_CSR_RPRESETSTS(bank_number));
+}
+
+void adf_gen4_bank_drain_finish(struct adf_accel_dev *accel_dev,
+				u32 bank_number)
+{
+	void __iomem *csr = adf_get_etr_base(accel_dev);
+
+	ADF_CSR_WR(csr, ADF_WQM_CSR_RPRESETSTS(bank_number),
+		   ADF_WQM_CSR_RPRESETSTS_STATUS);
+}
+
+int adf_gen4_bank_drain_start(struct adf_accel_dev *accel_dev,
+			      u32 bank_number, int timeout_us)
+{
+	void __iomem *csr = adf_get_etr_base(accel_dev);
+	int ret;
+
+	dev_dbg(&GET_DEV(accel_dev), "Drain bank %d\n", bank_number);
+
+	ret = drain_bank(csr, bank_number, timeout_us);
+	if (ret)
+		dev_err(&GET_DEV(accel_dev), "Bank drain failed (timeout)\n");
+	else
+		dev_dbg(&GET_DEV(accel_dev), "Bank drain successful\n");
+
+	return ret;
+}
+
+static void bank_state_save(struct adf_hw_csr_ops *ops, void __iomem *base,
+			    u32 bank, struct bank_state *state, u32 num_rings)
+{
+	u32 i;
+
+	state->ringstat0 = ops->read_csr_stat(base, bank);
+	state->ringuostat = ops->read_csr_uo_stat(base, bank);
+	state->ringestat = ops->read_csr_e_stat(base, bank);
+	state->ringnestat = ops->read_csr_ne_stat(base, bank);
+	state->ringnfstat = ops->read_csr_nf_stat(base, bank);
+	state->ringfstat = ops->read_csr_f_stat(base, bank);
+	state->ringcstat0 = ops->read_csr_c_stat(base, bank);
+	state->iaintflagen = ops->read_csr_int_en(base, bank);
+	state->iaintflagreg = ops->read_csr_int_flag(base, bank);
+	state->iaintflagsrcsel0 = ops->read_csr_int_srcsel(base, bank);
+	state->iaintcolen = ops->read_csr_int_col_en(base, bank);
+	state->iaintcolctl = ops->read_csr_int_col_ctl(base, bank);
+	state->iaintflagandcolen = ops->read_csr_int_flag_and_col(base, bank);
+	state->ringexpstat = ops->read_csr_exp_stat(base, bank);
+	state->ringexpintenable = ops->read_csr_exp_int_en(base, bank);
+	state->ringsrvarben = ops->read_csr_ring_srv_arb_en(base, bank);
+
+	for (i = 0; i < num_rings; i++) {
+		state->rings[i].head = ops->read_csr_ring_head(base, bank, i);
+		state->rings[i].tail = ops->read_csr_ring_tail(base, bank, i);
+		state->rings[i].config = ops->read_csr_ring_config(base, bank, i);
+		state->rings[i].base = ops->read_csr_ring_base(base, bank, i);
+	}
+}
+
+#define CHECK_STAT(op, expect_val, name, args...) \
+({ \
+	u32 __expect_val = (expect_val); \
+	u32 actual_val = op(args); \
+	(__expect_val == actual_val) ? 0 : \
+		(pr_err("QAT: Fail to restore %s register. Expected 0x%x, actual 0x%x\n", \
+			name, __expect_val, actual_val), -EINVAL); \
+})
+
+static int bank_state_restore(struct adf_hw_csr_ops *ops, void __iomem *base,
+			      u32 bank, struct bank_state *state, u32 num_rings,
+			      int tx_rx_gap)
+{
+	u32 val, tmp_val, i;
+	int ret;
+
+	for (i = 0; i < num_rings; i++)
+		ops->write_csr_ring_base(base, bank, i, state->rings[i].base);
+
+	for (i = 0; i < num_rings; i++)
+		ops->write_csr_ring_config(base, bank, i, state->rings[i].config);
+
+	for (i = 0; i < num_rings / 2; i++) {
+		int tx = i * (tx_rx_gap + 1);
+		int rx = tx + tx_rx_gap;
+
+		ops->write_csr_ring_head(base, bank, tx, state->rings[tx].head);
+		ops->write_csr_ring_tail(base, bank, tx, state->rings[tx].tail);
+
+		/*
+		 * The TX ring head needs to be updated again to make sure that
+		 * the HW will not consider the ring as full when it is empty
+		 * and the correct state flags are set to match the recovered state.
+		 */
+		if (state->ringestat & BIT(tx)) {
+			val = ops->read_csr_int_srcsel(base, bank);
+			val |= ADF_RP_INT_SRC_SEL_F_RISE_MASK;
+			ops->write_csr_int_srcsel_w_val(base, bank, val);
+			ops->write_csr_ring_head(base, bank, tx, state->rings[tx].head);
+		}
+
+		ops->write_csr_ring_tail(base, bank, rx, state->rings[rx].tail);
+		val = ops->read_csr_int_srcsel(base, bank);
+		val |= ADF_RP_INT_SRC_SEL_F_RISE_MASK << ADF_RP_INT_SRC_SEL_RANGE_WIDTH;
+		ops->write_csr_int_srcsel_w_val(base, bank, val);
+
+		ops->write_csr_ring_head(base, bank, rx, state->rings[rx].head);
+		val = ops->read_csr_int_srcsel(base, bank);
+		val |= ADF_RP_INT_SRC_SEL_F_FALL_MASK << ADF_RP_INT_SRC_SEL_RANGE_WIDTH;
+		ops->write_csr_int_srcsel_w_val(base, bank, val);
+
+		/*
+		 * The RX ring tail needs to be updated again to make sure that
+		 * the HW will not consider the ring as empty when it is full
+		 * and the correct state flags are set to match the recovered state.
+		 */
+		if (state->ringfstat & BIT(rx))
+			ops->write_csr_ring_tail(base, bank, rx, state->rings[rx].tail);
+	}
+
+	ops->write_csr_int_flag_and_col(base, bank, state->iaintflagandcolen);
+	ops->write_csr_int_en(base, bank, state->iaintflagen);
+	ops->write_csr_int_col_en(base, bank, state->iaintcolen);
+	ops->write_csr_int_srcsel_w_val(base, bank, state->iaintflagsrcsel0);
+	ops->write_csr_exp_int_en(base, bank, state->ringexpintenable);
+	ops->write_csr_int_col_ctl(base, bank, state->iaintcolctl);
+	ops->write_csr_ring_srv_arb_en(base, bank, state->ringsrvarben);
+
+	/* Check that all ring statuses match the saved state. */
+	ret = CHECK_STAT(ops->read_csr_stat, state->ringstat0, "ringstat",
+			 base, bank);
+	if (ret)
+		return ret;
+
+	ret = CHECK_STAT(ops->read_csr_e_stat, state->ringestat, "ringestat",
+			 base, bank);
+	if (ret)
+		return ret;
+
+	ret = CHECK_STAT(ops->read_csr_ne_stat, state->ringnestat, "ringnestat",
+			 base, bank);
+	if (ret)
+		return ret;
+
+	ret = CHECK_STAT(ops->read_csr_nf_stat, state->ringnfstat, "ringnfstat",
+			 base, bank);
+	if (ret)
+		return ret;
+
+	ret = CHECK_STAT(ops->read_csr_f_stat, state->ringfstat, "ringfstat",
+			 base, bank);
+	if (ret)
+		return ret;
+
+	ret = CHECK_STAT(ops->read_csr_c_stat, state->ringcstat0, "ringcstat",
+			 base, bank);
+	if (ret)
+		return ret;
+
+	tmp_val = ops->read_csr_exp_stat(base, bank);
+	val = state->ringexpstat;
+	if (tmp_val && !val) {
+		pr_err("QAT: Bank was restored with exception: 0x%x\n", val);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+int adf_gen4_bank_state_save(struct adf_accel_dev *accel_dev, u32 bank_number,
+			     struct bank_state *state)
+{
+	struct adf_hw_device_data *hw_data = GET_HW_DATA(accel_dev);
+	struct adf_hw_csr_ops *csr_ops = GET_CSR_OPS(accel_dev);
+	void __iomem *csr_base = adf_get_etr_base(accel_dev);
+
+	if (bank_number >= hw_data->num_banks || !state)
+		return -EINVAL;
+
+	dev_dbg(&GET_DEV(accel_dev), "Saving state of bank %d\n", bank_number);
+
+	bank_state_save(csr_ops, csr_base, bank_number, state,
+			hw_data->num_rings_per_bank);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(adf_gen4_bank_state_save);
+
+int adf_gen4_bank_state_restore(struct adf_accel_dev *accel_dev, u32 bank_number,
+				struct bank_state *state)
+{
+	struct adf_hw_device_data *hw_data = GET_HW_DATA(accel_dev);
+	struct adf_hw_csr_ops *csr_ops = GET_CSR_OPS(accel_dev);
+	void __iomem *csr_base = adf_get_etr_base(accel_dev);
+	int ret;
+
+	if (bank_number >= hw_data->num_banks  || !state)
+		return -EINVAL;
+
+	dev_dbg(&GET_DEV(accel_dev), "Restoring state of bank %d\n", bank_number);
+
+	ret = bank_state_restore(csr_ops, csr_base, bank_number, state,
+				 hw_data->num_rings_per_bank, hw_data->tx_rx_gap);
+	if (ret)
+		dev_err(&GET_DEV(accel_dev),
+			"Unable to restore state of bank %d\n", bank_number);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(adf_gen4_bank_state_restore);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.h b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.h
index 719f7757e587..e8cb930e80c9 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.h
@@ -77,10 +77,19 @@
 #define ADF_RPRESET_POLL_TIMEOUT_US	(5 * USEC_PER_SEC)
 #define ADF_RPRESET_POLL_DELAY_US	20
 #define ADF_WQM_CSR_RPRESETCTL_RESET	BIT(0)
+#define ADF_WQM_CSR_RPRESETCTL_DRAIN	BIT(2)
 #define ADF_WQM_CSR_RPRESETCTL(bank)	(0x6000 + ((bank) << 3))
 #define ADF_WQM_CSR_RPRESETSTS_STATUS	BIT(0)
 #define ADF_WQM_CSR_RPRESETSTS(bank)	(ADF_WQM_CSR_RPRESETCTL(bank) + 4)
 
+/* Ring interrupt */
+#define ADF_RP_INT_SRC_SEL_F_RISE_MASK	BIT(2)
+#define ADF_RP_INT_SRC_SEL_F_FALL_MASK	GENMASK(2, 0)
+#define ADF_RP_INT_SRC_SEL_RANGE_WIDTH	4
+#define ADF_COALESCED_POLL_DELAY_US	1000
+#define ADF_WQM_CSR_RPINTSOU(bank)	(0x200000 + ((bank) << 12))
+#define ADF_WQM_CSR_RP_IDX_RX		1
+
 /* Error source registers */
 #define ADF_GEN4_ERRSOU0	(0x41A200)
 #define ADF_GEN4_ERRSOU1	(0x41A204)
@@ -150,5 +159,15 @@ void adf_gen4_set_msix_default_rttable(struct adf_accel_dev *accel_dev);
 void adf_gen4_set_ssm_wdtimer(struct adf_accel_dev *accel_dev);
 int adf_gen4_init_thd2arb_map(struct adf_accel_dev *accel_dev);
 u16 adf_gen4_get_ring_to_svc_map(struct adf_accel_dev *accel_dev);
+int adf_gen4_bank_quiesce_coal_timer(struct adf_accel_dev *accel_dev,
+				     u32 bank_idx, int timeout_ms);
+int adf_gen4_bank_drain_start(struct adf_accel_dev *accel_dev,
+			      u32 bank_number, int timeout_us);
+void adf_gen4_bank_drain_finish(struct adf_accel_dev *accel_dev,
+				u32 bank_number);
+int adf_gen4_bank_state_save(struct adf_accel_dev *accel_dev, u32 bank_number,
+			     struct bank_state *state);
+int adf_gen4_bank_state_restore(struct adf_accel_dev *accel_dev,
+				u32 bank_number, struct bank_state *state);
 
 #endif
-- 
2.18.2


