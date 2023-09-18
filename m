Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3513A7A412B
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 08:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239922AbjIRG23 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 02:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239871AbjIRG2L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 02:28:11 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 189A5E6;
        Sun, 17 Sep 2023 23:28:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695018486; x=1726554486;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=umOFRQhC/QKZXyjspALq4K5Uu2DMOzTHqghxUg2G6jM=;
  b=R+KU8oPzIKAiB/mwBOk6fI/1PlMFLxUpEA3MA1+BnH7JR84btgWRwUt8
   QrV/oFPjD6BQt549FXbGyP0KR2NntkE/5v4ZioYWqCep6cZxwlFH94hkQ
   j+9oz26JASyVyq91ymXk4/ZNLTMIm9LbqL/tnvl2eH6esheiLtOmXXNN+
   F6+UEkj/LGFwWwnVE6u+TfdcRoWpGvY99du6ww0HWRmuvneDkmbtuYqSM
   KxtAy7EwxQe8AgwMAetKvauVpN2cdzJWnn7ntTcnD4n+hI5O5FUODy2UP
   WcOFZgXA4GWWYOnuGaclk9gtlna4DUE+oH6vhh6WN4+Roep5TQ9JAV/Yt
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10836"; a="378488503"
X-IronPort-AV: E=Sophos;i="6.02,155,1688454000"; 
   d="scan'208";a="378488503"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2023 23:28:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10836"; a="815893419"
X-IronPort-AV: E=Sophos;i="6.02,155,1688454000"; 
   d="scan'208";a="815893419"
Received: from dpdk-yahui-icx1.sh.intel.com ([10.67.111.186])
  by fmsmga004.fm.intel.com with ESMTP; 17 Sep 2023 23:28:00 -0700
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
Subject: [PATCH iwl-next v3 03/13] ice: Add function to get and set TX queue context
Date:   Mon, 18 Sep 2023 06:25:36 +0000
Message-Id: <20230918062546.40419-4-yahui.cao@intel.com>
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

Export TX queue context get and set function which is consumed by linux
live migration driver to save and load device state.

TX queue context contains static fields which does not change during TX
traffic and dynamic fields which may change during TX traffic.

Signed-off-by: Yahui Cao <yahui.cao@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c   | 216 +++++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_common.h   |   6 +
 .../net/ethernet/intel/ice/ice_hw_autogen.h   |  15 ++
 .../net/ethernet/intel/ice/ice_lan_tx_rx.h    |   3 +
 4 files changed, 239 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 5892d5a22323..63ccd631a5d5 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -1322,7 +1322,10 @@ ice_read_rxq_ctx(struct ice_hw *hw, struct ice_rlan_ctx *rlan_ctx,
 	return ice_get_ctx(ctx_buf, (u8 *)rlan_ctx, ice_rlan_ctx_info);
 }
 
-/* LAN Tx Queue Context */
+/* LAN Tx Queue Context used for set Tx config by ice_aqc_opc_add_txqs,
+ * Bit[0-175] is valid
+ */
+
 const struct ice_ctx_ele ice_tlan_ctx_info[] = {
 				    /* Field			Width	LSB */
 	ICE_CTX_STORE(ice_tlan_ctx, base,			57,	0),
@@ -1356,6 +1359,217 @@ const struct ice_ctx_ele ice_tlan_ctx_info[] = {
 	{ 0 }
 };
 
+/* LAN Tx Queue Context used for get Tx config from QTXCOMM_CNTX data,
+ * Bit[0-292] is valid, including internal queue state. Since internal
+ * queue state is dynamic field, its value will be cleared once queue
+ * is disabled
+ */
+static const struct ice_ctx_ele ice_tlan_ctx_data_info[] = {
+				    /* Field			Width	LSB */
+	ICE_CTX_STORE(ice_tlan_ctx, base,			57,	0),
+	ICE_CTX_STORE(ice_tlan_ctx, port_num,			3,	57),
+	ICE_CTX_STORE(ice_tlan_ctx, cgd_num,			5,	60),
+	ICE_CTX_STORE(ice_tlan_ctx, pf_num,			3,	65),
+	ICE_CTX_STORE(ice_tlan_ctx, vmvf_num,			10,	68),
+	ICE_CTX_STORE(ice_tlan_ctx, vmvf_type,			2,	78),
+	ICE_CTX_STORE(ice_tlan_ctx, src_vsi,			10,	80),
+	ICE_CTX_STORE(ice_tlan_ctx, tsyn_ena,			1,	90),
+	ICE_CTX_STORE(ice_tlan_ctx, internal_usage_flag,	1,	91),
+	ICE_CTX_STORE(ice_tlan_ctx, alt_vlan,			1,	92),
+	ICE_CTX_STORE(ice_tlan_ctx, cpuid,			8,	93),
+	ICE_CTX_STORE(ice_tlan_ctx, wb_mode,			1,	101),
+	ICE_CTX_STORE(ice_tlan_ctx, tphrd_desc,			1,	102),
+	ICE_CTX_STORE(ice_tlan_ctx, tphrd,			1,	103),
+	ICE_CTX_STORE(ice_tlan_ctx, tphwr_desc,			1,	104),
+	ICE_CTX_STORE(ice_tlan_ctx, cmpq_id,			9,	105),
+	ICE_CTX_STORE(ice_tlan_ctx, qnum_in_func,		14,	114),
+	ICE_CTX_STORE(ice_tlan_ctx, itr_notification_mode,	1,	128),
+	ICE_CTX_STORE(ice_tlan_ctx, adjust_prof_id,		6,	129),
+	ICE_CTX_STORE(ice_tlan_ctx, qlen,			13,	135),
+	ICE_CTX_STORE(ice_tlan_ctx, quanta_prof_idx,		4,	148),
+	ICE_CTX_STORE(ice_tlan_ctx, tso_ena,			1,	152),
+	ICE_CTX_STORE(ice_tlan_ctx, tso_qnum,			11,	153),
+	ICE_CTX_STORE(ice_tlan_ctx, legacy_int,			1,	164),
+	ICE_CTX_STORE(ice_tlan_ctx, drop_ena,			1,	165),
+	ICE_CTX_STORE(ice_tlan_ctx, cache_prof_idx,		2,	166),
+	ICE_CTX_STORE(ice_tlan_ctx, pkt_shaper_prof_idx,	3,	168),
+	ICE_CTX_STORE(ice_tlan_ctx, tail,			13,	184),
+	{ 0 }
+};
+
+/**
+ * ice_copy_txq_ctx_from_hw - Copy txq context register from HW
+ * @hw: pointer to the hardware structure
+ * @ice_txq_ctx: pointer to the txq context
+ *
+ * Copy txq context from HW register space to dense structure
+ */
+static int
+ice_copy_txq_ctx_from_hw(struct ice_hw *hw, u8 *ice_txq_ctx)
+{
+	u8 i;
+
+	if (!ice_txq_ctx)
+		return -EINVAL;
+
+	/* Copy each dword separately from HW */
+	for (i = 0; i < ICE_TXQ_CTX_SIZE_DWORDS; i++) {
+		u32 *ctx = (u32 *)(ice_txq_ctx + (i * sizeof(u32)));
+
+		*ctx = rd32(hw, GLCOMM_QTX_CNTX_DATA(i));
+
+		ice_debug(hw, ICE_DBG_QCTX, "qtxdata[%d]: %08X\n", i, *ctx);
+	}
+
+	return 0;
+}
+
+/**
+ * ice_copy_txq_ctx_to_hw - Copy txq context register into HW
+ * @hw: pointer to the hardware structure
+ * @ice_txq_ctx: pointer to the txq context
+ *
+ * Copy txq context from dense structure to HW register space
+ */
+static int
+ice_copy_txq_ctx_to_hw(struct ice_hw *hw, u8 *ice_txq_ctx)
+{
+	u8 i;
+
+	if (!ice_txq_ctx)
+		return -EINVAL;
+
+	/* Copy each dword separately to HW */
+	for (i = 0; i < ICE_TXQ_CTX_SIZE_DWORDS; i++) {
+		u32 *ctx = (u32 *)(ice_txq_ctx + (i * sizeof(u32)));
+
+		wr32(hw, GLCOMM_QTX_CNTX_DATA(i), *ctx);
+
+		ice_debug(hw, ICE_DBG_QCTX, "qtxdata[%d]: %08X\n", i, *ctx);
+	}
+
+	return 0;
+}
+
+/* Configuration access to tx ring context(from PF) is done via indirect
+ * interface, GLCOMM_QTX_CNTX_CTL/DATA registers. However, there registers
+ * are shared by all the PFs with single PCI card. So multiplied PF may
+ * access there registers simultaneously, causing access conflicts. Then
+ * card-level grained locking is required to protect these registers from
+ * being competed by PF devices within the same card. However, there is no
+ * such kind of card-level locking supported. So introduce a coarse grained
+ * global lock which is shared by all the PF driver.
+ *
+ * The overall flow is to acquire the lock, read/write TXQ context through
+ * GLCOMM_QTX_CNTX_CTL/DATA indirect interface and release the lock once
+ * access is completed. In this way, only one PF can have access to TXQ
+ * context safely.
+ */
+static DEFINE_MUTEX(ice_global_txq_ctx_lock);
+
+/**
+ * ice_read_txq_ctx - Read txq context from HW
+ * @hw: pointer to the hardware structure
+ * @tlan_ctx: pointer to the txq context
+ * @txq_index: the index of the Tx queue
+ *
+ * Read txq context from HW register space and then converts it from dense
+ * structure to sparse
+ */
+int
+ice_read_txq_ctx(struct ice_hw *hw, struct ice_tlan_ctx *tlan_ctx,
+		 u32 txq_index)
+{
+	u8 ctx_buf[ICE_TXQ_CTX_SZ] = { 0 };
+	int status;
+	u32 txq_base;
+	u32 cmd, reg;
+
+	if (!tlan_ctx)
+		return -EINVAL;
+
+	if (txq_index > QTX_COMM_HEAD_MAX_INDEX)
+		return -EINVAL;
+
+	/* Get TXQ base within card space */
+	txq_base = rd32(hw, PFLAN_TX_QALLOC(hw->pf_id));
+	txq_base = (txq_base & PFLAN_TX_QALLOC_FIRSTQ_M) >>
+		   PFLAN_TX_QALLOC_FIRSTQ_S;
+
+	cmd = (GLCOMM_QTX_CNTX_CTL_CMD_READ
+		<< GLCOMM_QTX_CNTX_CTL_CMD_S) & GLCOMM_QTX_CNTX_CTL_CMD_M;
+	reg = cmd | GLCOMM_QTX_CNTX_CTL_CMD_EXEC_M |
+	      (((txq_base + txq_index) << GLCOMM_QTX_CNTX_CTL_QUEUE_ID_S) &
+	       GLCOMM_QTX_CNTX_CTL_QUEUE_ID_M);
+
+	mutex_lock(&ice_global_txq_ctx_lock);
+
+	wr32(hw, GLCOMM_QTX_CNTX_CTL, reg);
+	ice_flush(hw);
+
+	status = ice_copy_txq_ctx_from_hw(hw, ctx_buf);
+	if (status) {
+		mutex_unlock(&ice_global_txq_ctx_lock);
+		return status;
+	}
+
+	mutex_unlock(&ice_global_txq_ctx_lock);
+
+	return ice_get_ctx(ctx_buf, (u8 *)tlan_ctx, ice_tlan_ctx_data_info);
+}
+
+/**
+ * ice_write_txq_ctx - Write txq context from HW
+ * @hw: pointer to the hardware structure
+ * @tlan_ctx: pointer to the txq context
+ * @txq_index: the index of the Tx queue
+ *
+ * Convert txq context from sparse to dense structure and then writes
+ * it to HW register space
+ */
+int
+ice_write_txq_ctx(struct ice_hw *hw, struct ice_tlan_ctx *tlan_ctx,
+		  u32 txq_index)
+{
+	u8 ctx_buf[ICE_TXQ_CTX_SZ] = { 0 };
+	int status;
+	u32 txq_base;
+	u32 cmd, reg;
+
+	if (!tlan_ctx)
+		return -EINVAL;
+
+	if (txq_index > QTX_COMM_HEAD_MAX_INDEX)
+		return -EINVAL;
+
+	ice_set_ctx(hw, (u8 *)tlan_ctx, ctx_buf, ice_tlan_ctx_info);
+
+	/* Get TXQ base within card space */
+	txq_base = rd32(hw, PFLAN_TX_QALLOC(hw->pf_id));
+	txq_base = (txq_base & PFLAN_TX_QALLOC_FIRSTQ_M) >>
+		   PFLAN_TX_QALLOC_FIRSTQ_S;
+
+	cmd = (GLCOMM_QTX_CNTX_CTL_CMD_WRITE_NO_DYN
+		<< GLCOMM_QTX_CNTX_CTL_CMD_S) & GLCOMM_QTX_CNTX_CTL_CMD_M;
+	reg = cmd | GLCOMM_QTX_CNTX_CTL_CMD_EXEC_M |
+	      (((txq_base + txq_index) << GLCOMM_QTX_CNTX_CTL_QUEUE_ID_S) &
+	       GLCOMM_QTX_CNTX_CTL_QUEUE_ID_M);
+
+	mutex_lock(&ice_global_txq_ctx_lock);
+
+	status = ice_copy_txq_ctx_to_hw(hw, ctx_buf);
+	if (status) {
+		mutex_lock(&ice_global_txq_ctx_lock);
+		return status;
+	}
+
+	wr32(hw, GLCOMM_QTX_CNTX_CTL, reg);
+	ice_flush(hw);
+
+	mutex_unlock(&ice_global_txq_ctx_lock);
+
+	return 0;
+}
 /* Sideband Queue command wrappers */
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_common.h b/drivers/net/ethernet/intel/ice/ice_common.h
index 657767c50be6..e7274721a268 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.h
+++ b/drivers/net/ethernet/intel/ice/ice_common.h
@@ -58,6 +58,12 @@ ice_write_rxq_ctx(struct ice_hw *hw, struct ice_rlan_ctx *rlan_ctx,
 int
 ice_read_rxq_ctx(struct ice_hw *hw, struct ice_rlan_ctx *rlan_ctx,
 		 u32 rxq_index);
+int
+ice_read_txq_ctx(struct ice_hw *hw, struct ice_tlan_ctx *tlan_ctx,
+		 u32 txq_index);
+int
+ice_write_txq_ctx(struct ice_hw *hw, struct ice_tlan_ctx *tlan_ctx,
+		  u32 txq_index);
 
 int
 ice_aq_get_rss_lut(struct ice_hw *hw, struct ice_aq_get_set_rss_lut_params *get_params);
diff --git a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
index 6756f3d51d14..67d8332d92f6 100644
--- a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
+++ b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
@@ -8,6 +8,7 @@
 
 #define QTX_COMM_DBELL(_DBQM)			(0x002C0000 + ((_DBQM) * 4))
 #define QTX_COMM_HEAD(_DBQM)			(0x000E0000 + ((_DBQM) * 4))
+#define QTX_COMM_HEAD_MAX_INDEX			16383
 #define QTX_COMM_HEAD_HEAD_S			0
 #define QTX_COMM_HEAD_HEAD_M			ICE_M(0x1FFF, 0)
 #define PF_FW_ARQBAH				0x00080180
@@ -258,6 +259,9 @@
 #define VPINT_ALLOC_PCI_VALID_M			BIT(31)
 #define VPINT_MBX_CTL(_VSI)			(0x0016A000 + ((_VSI) * 4))
 #define VPINT_MBX_CTL_CAUSE_ENA_M		BIT(30)
+#define PFLAN_TX_QALLOC(_PF)			(0x001D2580 + ((_PF) * 4))
+#define PFLAN_TX_QALLOC_FIRSTQ_S		0
+#define PFLAN_TX_QALLOC_FIRSTQ_M		ICE_M(0x3FFF, 0)
 #define GLLAN_RCTL_0				0x002941F8
 #define QRX_CONTEXT(_i, _QRX)			(0x00280000 + ((_i) * 8192 + (_QRX) * 4))
 #define QRX_CTRL(_QRX)				(0x00120000 + ((_QRX) * 4))
@@ -352,6 +356,17 @@
 #define GLNVM_ULD_POR_DONE_1_M			BIT(8)
 #define GLNVM_ULD_PCIER_DONE_2_M		BIT(9)
 #define GLNVM_ULD_PE_DONE_M			BIT(10)
+#define GLCOMM_QTX_CNTX_CTL			0x002D2DC8 /* Reset Source: CORER */
+#define GLCOMM_QTX_CNTX_CTL_QUEUE_ID_S		0
+#define GLCOMM_QTX_CNTX_CTL_QUEUE_ID_M		ICE_M(0x3FFF, 0)
+#define GLCOMM_QTX_CNTX_CTL_CMD_S		16
+#define GLCOMM_QTX_CNTX_CTL_CMD_M		ICE_M(0x7, 16)
+#define GLCOMM_QTX_CNTX_CTL_CMD_READ		0
+#define GLCOMM_QTX_CNTX_CTL_CMD_WRITE		1
+#define GLCOMM_QTX_CNTX_CTL_CMD_RESET		3
+#define GLCOMM_QTX_CNTX_CTL_CMD_WRITE_NO_DYN	4
+#define GLCOMM_QTX_CNTX_CTL_CMD_EXEC_M		BIT(19)
+#define GLCOMM_QTX_CNTX_DATA(_i)		(0x002D2D40 + ((_i) * 4)) /* _i=0...9 */
 #define GLPCI_CNF2				0x000BE004
 #define GLPCI_CNF2_CACHELINE_SIZE_M		BIT(1)
 #define PF_FUNC_RID				0x0009E880
diff --git a/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h b/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
index 89f986a75cc8..79e07c863ae0 100644
--- a/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
+++ b/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
@@ -431,6 +431,8 @@ enum ice_rx_flex_desc_status_error_1_bits {
 
 #define ICE_RXQ_CTX_SIZE_DWORDS		8
 #define ICE_RXQ_CTX_SZ			(ICE_RXQ_CTX_SIZE_DWORDS * sizeof(u32))
+#define ICE_TXQ_CTX_SIZE_DWORDS		10
+#define ICE_TXQ_CTX_SZ			(ICE_TXQ_CTX_SIZE_DWORDS * sizeof(u32))
 #define ICE_TX_CMPLTNQ_CTX_SIZE_DWORDS	22
 #define ICE_TX_DRBELL_Q_CTX_SIZE_DWORDS	5
 #define GLTCLAN_CQ_CNTX(i, CQ)		(GLTCLAN_CQ_CNTX0(CQ) + ((i) * 0x0800))
@@ -649,6 +651,7 @@ struct ice_tlan_ctx {
 	u8 cache_prof_idx;
 	u8 pkt_shaper_prof_idx;
 	u8 int_q_state;	/* width not needed - internal - DO NOT WRITE!!! */
+	u16 tail;
 };
 
 /* The ice_ptype_lkup table is used to convert from the 10-bit ptype in the
-- 
2.34.1

