Return-Path: <kvm+bounces-2152-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F70A7F2461
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 03:52:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BA9EEB21EB0
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 02:51:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6AEA2D604;
	Tue, 21 Nov 2023 02:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R8UW+tGi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F15ACFA;
	Mon, 20 Nov 2023 18:50:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700535036; x=1732071036;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=i8LrPqnDw7KutM9dMmDrGpORGJHz+x3QGV0jkRtM6zs=;
  b=R8UW+tGi2VQc2Jvnx2u9uolYwnsz7e4bnn+DeJDrJtxXx64ChTp5i/tw
   DTdQSCTfTdFsAUf4Or+HQfEykHsCfYNrRgYM5Vlupj/UghspaoUK8xvhA
   AP18aPANKGWSXtxoz7A8LFzFgnIUCbIdgbpehJKcKppcgrQBsTWeGxiqu
   QB/mKRqlpLk5KRC7tjB5d86KFTMIRV9VyDWqcGp7Y7gq1zlOoRo567h+p
   ex/uefj6hQAVWPc05C2Og+pX+To0D91xMhGypq+tRvZi7e8/PR3t4YFph
   ur4ErSzF2WH5WoMa1VnLxyD7d7H6a0XGDz+PM7VPuQmTEq9PT2lIouqJ0
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10900"; a="458246155"
X-IronPort-AV: E=Sophos;i="6.04,215,1695711600"; 
   d="scan'208";a="458246155"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2023 18:50:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10900"; a="832488615"
X-IronPort-AV: E=Sophos;i="6.04,215,1695711600"; 
   d="scan'208";a="832488615"
Received: from dpdk-yahui-icx1.sh.intel.com ([10.67.111.85])
  by fmsmga008.fm.intel.com with ESMTP; 20 Nov 2023 18:50:29 -0800
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
Subject: [PATCH iwl-next v4 11/12] ice: Save and load mmio registers
Date: Tue, 21 Nov 2023 02:51:10 +0000
Message-Id: <20231121025111.257597-12-yahui.cao@intel.com>
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

In E800 device model, VF takes direct control over the context of
AdminQ, irq ctrl, TX tail and RX tail by accessing VF pci mmio. Rest of
all the state can only be setup by PF and the procedure is that VF sends
all these configuration to PF through virtual channel messages to setup
the rest of the state.

To migrate AdminQ/irq context successfully, only AdminQ/irq register
needs to be loaded, rest of the part like generic msix is handled by
migration stack.

To migrate RX dma ring successfully, RX ring base, length(setup via
virtual channel messages) and tail register (setup via VF pci mmio)
must be loaded before RX queue is enabled.

To migrate TX dma ring successfully, TX ring base and length(setup via
virtual channel messages) must be loaded before TX queue is enabled,
and TX tail(setup via VF pci mmio) doesn't need to be loaded since TX
queue is drained before migration and TX tail is stateless.

For simplicity, just load all the VF pci mmio before virtual channel
messages are replayed so that all the TX/RX ring context are loaded
before queue is enabled.

However, there are 2 corner cases which need to be taken care of:
- During device suspenion, irq register may be dirtied when stopping
  queue. Hence save irq register into internal pre-saved area before
  queue is stopped and fetch the pre-saved irq register value at device
  saving stage.
- When PF processes virtual channel VIRTCHNL_OP_CONFIG_VSI_QUEUES, irq
  register may be dirtied. Hence load the affacted irq register after
  virtual channel messages are replayed.

Signed-off-by: Yahui Cao <yahui.cao@intel.com>
---
 .../net/ethernet/intel/ice/ice_hw_autogen.h   |   8 +
 .../net/ethernet/intel/ice/ice_migration.c    | 308 ++++++++++++++++++
 .../intel/ice/ice_migration_private.h         |   7 +
 drivers/net/ethernet/intel/ice/ice_vf_lib.h   |   2 +
 4 files changed, 325 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
index 7410da715ad4..389bf00411ff 100644
--- a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
+++ b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
@@ -31,8 +31,16 @@
 #define PF_FW_ATQLEN_ATQVFE_M			BIT(28)
 #define PF_FW_ATQLEN_ATQOVFL_M			BIT(29)
 #define PF_FW_ATQLEN_ATQCRIT_M			BIT(30)
+#define VF_MBX_ARQBAH(_VF)			(0x0022B800 + ((_VF) * 4))
+#define VF_MBX_ARQBAL(_VF)			(0x0022B400 + ((_VF) * 4))
+#define VF_MBX_ARQH(_VF)			(0x0022C000 + ((_VF) * 4))
 #define VF_MBX_ARQLEN(_VF)			(0x0022BC00 + ((_VF) * 4))
+#define VF_MBX_ARQT(_VF)			(0x0022C400 + ((_VF) * 4))
+#define VF_MBX_ATQBAH(_VF)			(0x0022A400 + ((_VF) * 4))
+#define VF_MBX_ATQBAL(_VF)			(0x0022A000 + ((_VF) * 4))
+#define VF_MBX_ATQH(_VF)			(0x0022AC00 + ((_VF) * 4))
 #define VF_MBX_ATQLEN(_VF)			(0x0022A800 + ((_VF) * 4))
+#define VF_MBX_ATQT(_VF)			(0x0022B000 + ((_VF) * 4))
 #define PF_FW_ATQLEN_ATQENABLE_M		BIT(31)
 #define PF_FW_ATQT				0x00080400
 #define PF_MBX_ARQBAH				0x0022E400
diff --git a/drivers/net/ethernet/intel/ice/ice_migration.c b/drivers/net/ethernet/intel/ice/ice_migration.c
index a11cd0d3ad3d..127d45be6767 100644
--- a/drivers/net/ethernet/intel/ice/ice_migration.c
+++ b/drivers/net/ethernet/intel/ice/ice_migration.c
@@ -25,6 +25,27 @@ struct ice_migration_virtchnl_msg_listnode {
 	struct ice_migration_virtchnl_msg_slot msg_slot;
 };
 
+struct ice_migration_mmio_regs {
+	/* VF Interrupts */
+	u32 int_dyn_ctl[ICE_MIG_VF_MSIX_MAX];
+	u32 int_intr[ICE_MIG_VF_ITR_NUM][ICE_MIG_VF_MSIX_MAX];
+
+	/* VF Control Queues */
+	u32 asq_bal;
+	u32 asq_bah;
+	u32 asq_len;
+	u32 asq_head;
+	u32 asq_tail;
+	u32 arq_bal;
+	u32 arq_bah;
+	u32 arq_len;
+	u32 arq_head;
+	u32 arq_tail;
+
+	/* VF LAN RX */
+	u32 rx_tail[ICE_MIG_VF_QRX_TAIL_MAX];
+};
+
 struct ice_migration_dev_state {
 	u32 magic;
 	u32 version;
@@ -33,6 +54,7 @@ struct ice_migration_dev_state {
 	u16 num_txq;
 	u16 num_rxq;
 
+	struct ice_migration_mmio_regs regs;
 	u16 vsi_id;
 	/* next RX desc index to be processed by the device */
 	u16 rx_head[ICE_MIG_VF_QRX_TAIL_MAX];
@@ -276,6 +298,57 @@ u32 ice_migration_supported_caps(void)
 	return VIRTCHNL_VF_MIGRATION_SUPPORT_FEATURE;
 }
 
+/**
+ * ice_migration_save_dirty_regs - save registers which may be dirtied
+ * @vf: pointer to VF structure
+ *
+ * Return 0 for success, negative for error
+ */
+static int ice_migration_save_dirty_regs(struct ice_vf *vf)
+{
+	struct ice_migration_dirty_regs *dirty_regs = &vf->dirty_regs;
+	struct device *dev = ice_pf_to_dev(vf->pf);
+	struct ice_hw *hw = &vf->pf->hw;
+	struct ice_vsi *vsi;
+	int itr, v_id;
+
+	vsi = ice_get_vf_vsi(vf);
+	if (!vsi) {
+		dev_err(dev, "VF %d VSI is NULL\n", vf->vf_id);
+		return -EINVAL;
+	}
+
+	if (WARN_ON_ONCE(vsi->num_q_vectors + ICE_NONQ_VECS_VF >
+			 ICE_MIG_VF_MSIX_MAX))
+		return -EINVAL;
+
+	/* Save Mailbox Q vectors */
+	dirty_regs->int_dyn_ctl[0] =
+		rd32(hw, GLINT_DYN_CTL(vf->first_vector_idx));
+	for (itr = 0; itr < ICE_MIG_VF_ITR_NUM; itr++)
+		dirty_regs->int_intr[itr][0] =
+			rd32(hw, GLINT_ITR(itr, vf->first_vector_idx));
+
+	/* Save Data Q vectors */
+	for (v_id = 0; v_id < vsi->num_q_vectors; v_id++) {
+		int irq = v_id + ICE_NONQ_VECS_VF;
+		struct ice_q_vector *q_vector;
+
+		q_vector = vsi->q_vectors[v_id];
+		if (!q_vector) {
+			dev_err(dev, "VF %d invalid q vectors\n", vf->vf_id);
+			return -EINVAL;
+		}
+		dirty_regs->int_dyn_ctl[irq] =
+				rd32(hw, GLINT_DYN_CTL(q_vector->reg_idx));
+		for (itr = 0; itr < ICE_MIG_VF_ITR_NUM; itr++)
+			dirty_regs->int_intr[itr][irq] =
+				rd32(hw, GLINT_ITR(itr, q_vector->reg_idx));
+	}
+
+	return 0;
+}
+
 /**
  * ice_migration_suspend_dev - suspend device
  * @pf: pointer to PF of migration device
@@ -324,6 +397,15 @@ int ice_migration_suspend_dev(struct ice_pf *pf, int vf_id)
 	eth_zero_addr(vf->hw_lan_addr);
 	eth_zero_addr(vf->dev_lan_addr);
 
+	/* Irq register may be dirtied when stopping queue. Hence save irq
+	 * register into pre-saved area before queue is stopped.
+	 */
+	ret = ice_migration_save_dirty_regs(vf);
+	if (ret) {
+		dev_err(dev, "VF %d failed to save dirty register copy\n",
+			vf->vf_id);
+		goto out_put_vf;
+	}
 	ret = ice_vsi_stop_lan_tx_rings(vsi, ICE_NO_RESET, vf->vf_id);
 	if (ret) {
 		dev_err(dev, "VF %d failed to stop tx rings\n", vf->vf_id);
@@ -447,6 +529,84 @@ ice_migration_save_tx_head(struct ice_vf *vf,
 	return 0;
 }
 
+/**
+ * ice_migration_save_regs - save mmio registers in migration region
+ * @vf: pointer to VF structure
+ * @devstate: pointer to migration device state
+ *
+ * Return 0 for success, negative for error
+ */
+static int
+ice_migration_save_regs(struct ice_vf *vf,
+			struct ice_migration_dev_state *devstate)
+{
+	struct ice_migration_dirty_regs *dirty_regs = &vf->dirty_regs;
+	struct ice_migration_mmio_regs *regs = &devstate->regs;
+	struct device *dev = ice_pf_to_dev(vf->pf);
+	struct ice_hw *hw = &vf->pf->hw;
+	struct ice_vsi *vsi;
+	int i, itr, v_id;
+
+	vsi = ice_get_vf_vsi(vf);
+	if (!vsi) {
+		dev_err(dev, "VF %d VSI is NULL\n", vf->vf_id);
+		return -EINVAL;
+	}
+
+	if (WARN_ON_ONCE(vsi->num_q_vectors + ICE_NONQ_VECS_VF >
+			 ICE_MIG_VF_MSIX_MAX))
+		return -EINVAL;
+
+	/* For irq registers which may be dirtied when virtual channel message
+	 * VIRTCHNL_OP_CONFIG_VSI_QUEUES is processed, load values from
+	 * pre-saved area.
+	 */
+
+	/* Save Mailbox Q vectors */
+	regs->int_dyn_ctl[0] = dirty_regs->int_dyn_ctl[0];
+	for (itr = 0; itr < ICE_MIG_VF_ITR_NUM; itr++)
+		regs->int_intr[itr][0] = dirty_regs->int_intr[itr][0];
+
+	/* Save Data Q vectors */
+	for (v_id = 0; v_id < vsi->num_q_vectors; v_id++) {
+		int irq = v_id + ICE_NONQ_VECS_VF;
+		struct ice_q_vector *q_vector;
+
+		q_vector = vsi->q_vectors[v_id];
+		if (!q_vector) {
+			dev_err(dev, "VF %d invalid q vectors\n", vf->vf_id);
+			return -EINVAL;
+		}
+		regs->int_dyn_ctl[irq] = dirty_regs->int_dyn_ctl[irq];
+		for (itr = 0; itr < ICE_MIG_VF_ITR_NUM; itr++)
+			regs->int_intr[itr][irq] =
+				dirty_regs->int_intr[itr][irq];
+	}
+
+	regs->asq_bal = rd32(hw, VF_MBX_ATQBAL(vf->vf_id));
+	regs->asq_bah = rd32(hw, VF_MBX_ATQBAH(vf->vf_id));
+	regs->asq_len = rd32(hw, VF_MBX_ATQLEN(vf->vf_id));
+	regs->asq_head = rd32(hw, VF_MBX_ATQH(vf->vf_id));
+	regs->asq_tail = rd32(hw, VF_MBX_ATQT(vf->vf_id));
+	regs->arq_bal = rd32(hw, VF_MBX_ARQBAL(vf->vf_id));
+	regs->arq_bah = rd32(hw, VF_MBX_ARQBAH(vf->vf_id));
+	regs->arq_len = rd32(hw,  VF_MBX_ARQLEN(vf->vf_id));
+	regs->arq_head = rd32(hw, VF_MBX_ARQH(vf->vf_id));
+	regs->arq_tail = rd32(hw, VF_MBX_ARQT(vf->vf_id));
+
+	ice_for_each_rxq(vsi, i) {
+		struct ice_rx_ring *rx_ring = vsi->rx_rings[i];
+
+		regs->rx_tail[i] = 0;
+		if (!test_bit(i, vf->rxq_ena))
+			continue;
+
+		regs->rx_tail[i] = rd32(hw, QRX_TAIL(rx_ring->reg_idx));
+	}
+
+	return 0;
+}
+
 /**
  * ice_migration_save_devstate - save device state to migration buffer
  * @pf: pointer to PF of migration device
@@ -501,6 +661,12 @@ ice_migration_save_devstate(struct ice_pf *pf, int vf_id, u8 *buf, u64 buf_sz)
 	buf = devstate->virtchnl_msgs;
 	devstate->vsi_id = vf->vm_vsi_num;
 
+	ret = ice_migration_save_regs(vf, devstate);
+	if (ret) {
+		dev_err(dev, "VF %d failed to save mmio register\n", vf->vf_id);
+		goto out_put_vf;
+	}
+
 	ret = ice_migration_save_rx_head(vf, devstate);
 	if (ret) {
 		dev_err(dev, "VF %d failed to save rxq head\n", vf->vf_id);
@@ -883,6 +1049,125 @@ ice_migration_load_tx_head(struct ice_vf *vf,
 	return ret;
 }
 
+/**
+ * ice_migration_load_regs - load mmio registers from device state buffer
+ * @vf: pointer to VF structure
+ * @devstate: pointer to migration device state
+ *
+ * Return 0 for success, negative for error
+ */
+static int
+ice_migration_load_regs(struct ice_vf *vf,
+			struct ice_migration_dev_state *devstate)
+{
+	struct ice_migration_mmio_regs *regs = &devstate->regs;
+	struct device *dev = ice_pf_to_dev(vf->pf);
+	struct ice_hw *hw = &vf->pf->hw;
+	struct ice_vsi *vsi;
+	int i, itr, v_id;
+
+	vsi = ice_get_vf_vsi(vf);
+	if (!vsi) {
+		dev_err(dev, "VF %d VSI is NULL\n", vf->vf_id);
+		return -EINVAL;
+	}
+
+	if (WARN_ON_ONCE(vsi->num_q_vectors + ICE_NONQ_VECS_VF >
+			 ICE_MIG_VF_MSIX_MAX))
+		return -EINVAL;
+
+	/* Restore Mailbox Q vectors */
+	wr32(hw, GLINT_DYN_CTL(vf->first_vector_idx), regs->int_dyn_ctl[0]);
+	for (itr = 0; itr < ICE_MIG_VF_ITR_NUM; itr++)
+		wr32(hw, GLINT_ITR(itr, vf->first_vector_idx),
+		     regs->int_intr[itr][0]);
+
+	/* Restore Data Q vectors */
+	for (v_id = 0; v_id < vsi->num_q_vectors; v_id++) {
+		int irq = v_id + ICE_NONQ_VECS_VF;
+		struct ice_q_vector *q_vector;
+
+		q_vector = vsi->q_vectors[v_id];
+		if (!q_vector) {
+			dev_err(dev, "VF %d invalid q vectors\n", vf->vf_id);
+			return -EINVAL;
+		}
+		wr32(hw, GLINT_DYN_CTL(q_vector->reg_idx),
+		     regs->int_dyn_ctl[irq]);
+		for (itr = 0; itr < ICE_MIG_VF_ITR_NUM; itr++)
+			wr32(hw, GLINT_ITR(itr, q_vector->reg_idx),
+			     regs->int_intr[itr][irq]);
+	}
+
+	wr32(hw, VF_MBX_ATQBAL(vf->vf_id), regs->asq_bal);
+	wr32(hw, VF_MBX_ATQBAH(vf->vf_id), regs->asq_bah);
+	wr32(hw, VF_MBX_ATQLEN(vf->vf_id), regs->asq_len);
+	wr32(hw, VF_MBX_ATQH(vf->vf_id), regs->asq_head);
+	/* Since Mailbox ctrl tx queue tail is bumped by VF driver to notify
+	 * HW to send pks, VF_MBX_ATQT is not necessry to be loaded here.
+	 */
+	wr32(hw, VF_MBX_ARQBAL(vf->vf_id), regs->arq_bal);
+	wr32(hw, VF_MBX_ARQBAH(vf->vf_id), regs->arq_bah);
+	wr32(hw, VF_MBX_ARQLEN(vf->vf_id), regs->arq_len);
+	wr32(hw, VF_MBX_ARQH(vf->vf_id), regs->arq_head);
+	wr32(hw, VF_MBX_ARQT(vf->vf_id), regs->arq_tail);
+
+	ice_for_each_rxq(vsi, i) {
+		struct ice_rx_ring *rx_ring = vsi->rx_rings[i];
+
+		wr32(hw, QRX_TAIL(rx_ring->reg_idx), regs->rx_tail[i]);
+	}
+
+	return 0;
+}
+
+/**
+ * ice_migration_load_dirty_regs - load registers which may be dirtied
+ * @vf: pointer to VF structure
+ * @devstate: pointer to migration device state
+ *
+ * Return 0 for success, negative for error
+ */
+static int
+ice_migration_load_dirty_regs(struct ice_vf *vf,
+			      struct ice_migration_dev_state *devstate)
+{
+	struct ice_migration_mmio_regs *regs = &devstate->regs;
+	struct device *dev = ice_pf_to_dev(vf->pf);
+	struct ice_hw *hw = &vf->pf->hw;
+	struct ice_vsi *vsi;
+	int itr, v_id;
+
+	vsi = ice_get_vf_vsi(vf);
+	if (!vsi) {
+		dev_err(dev, "VF %d VSI is NULL\n", vf->vf_id);
+		return -EINVAL;
+	}
+
+	if (WARN_ON_ONCE(vsi->num_q_vectors + ICE_NONQ_VECS_VF >
+			 ICE_MIG_VF_MSIX_MAX))
+		return -EINVAL;
+
+	/* Restore Data Q vectors */
+	for (v_id = 0; v_id < vsi->num_q_vectors; v_id++) {
+		int irq = v_id + ICE_NONQ_VECS_VF;
+		struct ice_q_vector *q_vector;
+
+		q_vector = vsi->q_vectors[v_id];
+		if (!q_vector) {
+			dev_err(dev, "VF %d invalid q vectors\n", vf->vf_id);
+			return -EINVAL;
+		}
+		wr32(hw, GLINT_DYN_CTL(q_vector->reg_idx),
+		     regs->int_dyn_ctl[irq]);
+		for (itr = 0; itr < ICE_MIG_VF_ITR_NUM; itr++)
+			wr32(hw, GLINT_ITR(itr, q_vector->reg_idx),
+			     regs->int_intr[itr][irq]);
+	}
+
+	return 0;
+}
+
 /**
  * ice_migration_load_devstate - load device state at destination
  * @pf: pointer to PF of migration device
@@ -920,6 +1205,18 @@ int ice_migration_load_devstate(struct ice_pf *pf, int vf_id,
 	devstate = (struct ice_migration_dev_state *)buf;
 	vf->vm_vsi_num = devstate->vsi_id;
 	dev_dbg(dev, "VF %d vm vsi num is:%d\n", vf->vf_id, vf->vm_vsi_num);
+
+	/* RX tail register must be loaded before queue is enabled. For
+	 * simplicity, just load all the mmio before virtual channel messages
+	 * are replayed.
+	 */
+	ret = ice_migration_load_regs(vf, devstate);
+	if (ret) {
+		dev_err(dev, "VF %d failed to load mmio registers\n",
+			vf->vf_id);
+		goto out_put_vf;
+	}
+
 	msg_slot = (struct ice_migration_virtchnl_msg_slot *)
 			devstate->virtchnl_msgs;
 	set_bit(ICE_VF_STATE_REPLAYING_VC, vf->vf_states);
@@ -971,6 +1268,17 @@ int ice_migration_load_devstate(struct ice_pf *pf, int vf_id,
 		goto out_clear_replay;
 	}
 
+	/* When PF processes virtual channel VIRTCHNL_OP_CONFIG_VSI_QUEUES, irq
+	 * register may be dirtied. Hence load the affacted irq register again
+	 * after virtual channel messages are replayed.
+	 */
+	ret = ice_migration_load_dirty_regs(vf, devstate);
+	if (ret) {
+		dev_err(dev, "VF %d failed to load dirty registers\n",
+			vf->vf_id);
+		goto out_clear_replay;
+	}
+
 out_clear_replay:
 	clear_bit(ICE_VF_STATE_REPLAYING_VC, vf->vf_states);
 out_put_vf:
diff --git a/drivers/net/ethernet/intel/ice/ice_migration_private.h b/drivers/net/ethernet/intel/ice/ice_migration_private.h
index f72a488d9002..b76eb05747c8 100644
--- a/drivers/net/ethernet/intel/ice/ice_migration_private.h
+++ b/drivers/net/ethernet/intel/ice/ice_migration_private.h
@@ -10,6 +10,13 @@
  * in ice-vfio-pic.ko should be exposed as part of ice_migration.h.
  */
 
+#define ICE_MIG_VF_MSIX_MAX		65
+#define ICE_MIG_VF_ITR_NUM		4
+struct ice_migration_dirty_regs {
+	u32 int_dyn_ctl[ICE_MIG_VF_MSIX_MAX];
+	u32 int_intr[ICE_MIG_VF_ITR_NUM][ICE_MIG_VF_MSIX_MAX];
+};
+
 #if IS_ENABLED(CONFIG_ICE_VFIO_PCI)
 void ice_migration_init_vf(struct ice_vf *vf);
 void ice_migration_uninit_vf(struct ice_vf *vf);
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.h b/drivers/net/ethernet/intel/ice/ice_vf_lib.h
index 49d99694e91f..c971fb47c2ff 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.h
@@ -14,6 +14,7 @@
 #include "ice_type.h"
 #include "ice_virtchnl_fdir.h"
 #include "ice_vsi_vlan_ops.h"
+#include "ice_migration_private.h"
 
 #define ICE_MAX_SRIOV_VFS		256
 
@@ -147,6 +148,7 @@ struct ice_vf {
 	u64 virtchnl_msg_size;
 	u32 virtchnl_retval;
 	u16 vm_vsi_num;
+	struct ice_migration_dirty_regs dirty_regs;
 };
 
 /* Flags for controlling behavior of ice_reset_vf */
-- 
2.34.1


