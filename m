Return-Path: <kvm+bounces-2142-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 393C37F2440
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 03:50:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B494E281C8D
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 02:50:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82C34156D2;
	Tue, 21 Nov 2023 02:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ll4ySK7p"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35A4BCB;
	Mon, 20 Nov 2023 18:49:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700534995; x=1732070995;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Vsbg5WYpgIdaFM7kidb5HJYGh+XfqpqCp0zWMK3Lung=;
  b=ll4ySK7p3tEGIehaIYtQ+FRVV67Gbf46sLjEcsfI3nfMTX0k9j0kGPOl
   gYp29Hb/6DWN9+tUb61rfUW0VkkOR1HwCSAsOog/3/s5RZFtjdyYTHS2e
   MzXjOgf2YsQ1WqrHr8tupgSn+H/yBiPQ7ez3ElW6tGxJhGmREnSdMX2a1
   wBi/cCNW8LiPSN6FXKt+fspWhCG3XlGLzcUm46Me+mQJ3s+eHLsVXOxK9
   tSw3k3bckGOslW+2lRnN9SlLN1nVWqBDZBeooxWXU8uhGDDrCQuwIzbjY
   IWN3L6moSb3W4MMwecnpK6fW11m3L75S4u58xfyd7nhBjAx8/iYZnAqrY
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10900"; a="458245861"
X-IronPort-AV: E=Sophos;i="6.04,215,1695711600"; 
   d="scan'208";a="458245861"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2023 18:49:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10900"; a="832488229"
X-IronPort-AV: E=Sophos;i="6.04,215,1695711600"; 
   d="scan'208";a="832488229"
Received: from dpdk-yahui-icx1.sh.intel.com ([10.67.111.85])
  by fmsmga008.fm.intel.com with ESMTP; 20 Nov 2023 18:49:49 -0800
From: Yahui Cao <yahui.cao@intel.com>
To: intel-wired-lan@lists.osuosl.org
Cc: kvm@vger.kernel.org,
	netdev@vger.kernel.org,
	lingyu.liu@intel.com,
	kevin.tian@intel.com,
	madhu.chittim@intel.com,
	sridhar.samudrala@intel.com,
	alex.williamson@redhat.com,
	jgg@nvidia.com,
	yishaih@nvidia.com,
	shameerali.kolothum.thodi@huawei.com,
	brett.creeley@amd.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com
Subject: [PATCH iwl-next v4 02/12] ice: Add function to get and set TX queue context
Date: Tue, 21 Nov 2023 02:51:01 +0000
Message-Id: <20231121025111.257597-3-yahui.cao@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231121025111.257597-1-yahui.cao@intel.com>
References: <20231121025111.257597-1-yahui.cao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
index d0a3bed00921..8577a5ef423e 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -1645,7 +1645,10 @@ ice_read_rxq_ctx(struct ice_hw *hw, struct ice_rlan_ctx *rlan_ctx,
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
@@ -1679,6 +1682,217 @@ const struct ice_ctx_ele ice_tlan_ctx_info[] = {
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
+ * are shared by all the PFs with single PCI card. Hence multiplied PF may
+ * access there registers simultaneously, causing access conflicts. Then
+ * card-level grained locking is required to protect these registers from
+ * being competed by PF devices within the same card. However, there is no
+ * such kind of card-level locking supported. Introduce a coarse grained
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
+ * Read txq context from HW register space and then convert it from dense
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
+ * Convert txq context from sparse to dense structure and then write
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
index df9c7f30592a..40fbb9088475 100644
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
index 86936b758ade..7410da715ad4 100644
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
@@ -362,6 +366,17 @@
 #define GLNVM_ULD_POR_DONE_1_M			BIT(8)
 #define GLNVM_ULD_PCIER_DONE_2_M		BIT(9)
 #define GLNVM_ULD_PE_DONE_M			BIT(10)
+#define GLCOMM_QTX_CNTX_CTL			0x002D2DC8
+#define GLCOMM_QTX_CNTX_CTL_QUEUE_ID_S		0
+#define GLCOMM_QTX_CNTX_CTL_QUEUE_ID_M		ICE_M(0x3FFF, 0)
+#define GLCOMM_QTX_CNTX_CTL_CMD_S		16
+#define GLCOMM_QTX_CNTX_CTL_CMD_M		ICE_M(0x7, 16)
+#define GLCOMM_QTX_CNTX_CTL_CMD_READ		0
+#define GLCOMM_QTX_CNTX_CTL_CMD_WRITE		1
+#define GLCOMM_QTX_CNTX_CTL_CMD_RESET		3
+#define GLCOMM_QTX_CNTX_CTL_CMD_WRITE_NO_DYN	4
+#define GLCOMM_QTX_CNTX_CTL_CMD_EXEC_M		BIT(19)
+#define GLCOMM_QTX_CNTX_DATA(_i)		(0x002D2D40 + ((_i) * 4))
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


