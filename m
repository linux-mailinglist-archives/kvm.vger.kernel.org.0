Return-Path: <kvm+bounces-2151-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B1217F2460
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 03:51:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E57E3B21C68
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 02:51:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65C8520313;
	Tue, 21 Nov 2023 02:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ce/n7FJN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E7CFC4;
	Mon, 20 Nov 2023 18:50:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700535034; x=1732071034;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Pq73yuf6JeL2kdbR+BSOiKELUA3aE1vbhSDePzfws90=;
  b=ce/n7FJN45FYMPVMgFIp1i+ZH2YWJa1aUNcTULp7wIY468kzICRFUHep
   q9Uzwp9FB9KBJ+EyfndJxeMuGQUUNMWIGD8BqNotaa9Eq9VQpU8NWMZSw
   ilApDrCTQeRT0ERLEeEdc0HZ2cEIefn2YyGTj3Lx/UWoV1ufg6F0e+n4h
   9mNGPt4Z1Az3nhv7YYq40aFbLJ5hswi+mB1d20cA/uaJk+38FlqOkXH+K
   91c/dqNl8AJgft+j9LcRtTLo+SXsTQsD9+cLjh8aG5BuBuDQ1CsmyA0Ny
   ScDeHjNtBI0qX+igi1E8WzzRUNSv/VCcHSXZECeNl2tyfYe4s0U3V7n/W
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10900"; a="458246112"
X-IronPort-AV: E=Sophos;i="6.04,215,1695711600"; 
   d="scan'208";a="458246112"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2023 18:50:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10900"; a="832488539"
X-IronPort-AV: E=Sophos;i="6.04,215,1695711600"; 
   d="scan'208";a="832488539"
Received: from dpdk-yahui-icx1.sh.intel.com ([10.67.111.85])
  by fmsmga008.fm.intel.com with ESMTP; 20 Nov 2023 18:50:20 -0800
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
Subject: [PATCH iwl-next v4 09/12] ice: Save and load TX Queue head
Date: Tue, 21 Nov 2023 02:51:08 +0000
Message-Id: <20231121025111.257597-10-yahui.cao@intel.com>
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

From: Lingyu Liu <lingyu.liu@intel.com>

TX Queue head is a fundamental DMA ring context which determines the
next TX descriptor to be fetched. However, TX Queue head is not visible
to VF while it is only visible in PF. As a result, PF needs to save and
load TX Queue head explicitly.

Unfortunately, due to HW limitation, TX Queue head can't be recovered
through writing mmio registers.

Since sending one packet will make TX head advanced by 1 index, TX Queue
head can be advanced by N index through sending N packets. Filling in
DMA ring with NOP descriptors and bumping doorbell can be used to change
TX Queue head indirectly. And this method has no side effects except
changing TX head value.

To advance TX Head queue, HW needs to touch memory by DMA. But directly
touching VM's memory to advance TX Queue head does not follow vfio
migration protocol design, because vIOMMU state is not defined by the
protocol. Even this may introduce functional and security issue under
hostile guest circumstances.

In order not to touch any VF memory or IO page table, TX Queue head
loading is using PF managed memory and PF isolation domain. This will
also introduce another dependency that while switching TX Queue between
PF space and VF space, TX Queue head value is not changed. HW provides
an indirect context access so that head value can be kept while
switching context.

In virtual channel model, VF driver only send TX queue ring base and
length info to PF, while rest of the TX queue context are managed by PF.
TX queue length must be verified by PF during virtual channel message
processing. When PF uses dummy descriptors to advance TX head, it will
configure the TX ring base as the new address managed by PF itself. As a
result, all of the TX queue context is taken control of by PF and this
method won't generate any attacking vulnerability

The overall steps for TX head loading handler are:
1. Backup TX context, switch TX queue context as PF space and PF
   DMA ring base with interrupt disabled
2. Fill the DMA ring with dummy descriptors and bump doorbell to
   advance TX head. Once kicking doorbell, HW will issue DMA and
   send PCI upstream memory transaction tagged by PF BDF. Since
   ring base is PF's managed DMA buffer, DMA can work successfully
   and TX Head is advanced as expected.
3. Overwrite TX context by the backup context in step 1. Since TX
   queue head value is not changed while context switch, TX queue
   head is successfully loaded.

Since everything is happening inside PF context, it is transparent to
vfio driver and has no effects outside of PF.

Co-developed-by: Yahui Cao <yahui.cao@intel.com>
Signed-off-by: Yahui Cao <yahui.cao@intel.com>
Signed-off-by: Lingyu Liu <lingyu.liu@intel.com>
---
 .../net/ethernet/intel/ice/ice_migration.c    | 306 ++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_virtchnl.c |  18 ++
 2 files changed, 324 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_migration.c b/drivers/net/ethernet/intel/ice/ice_migration.c
index 473be6a83cf3..082ae2b79f60 100644
--- a/drivers/net/ethernet/intel/ice/ice_migration.c
+++ b/drivers/net/ethernet/intel/ice/ice_migration.c
@@ -3,10 +3,14 @@
 
 #include "ice.h"
 #include "ice_base.h"
+#include "ice_txrx_lib.h"
 
 #define ICE_MIG_DEVSTAT_MAGIC			0xE8000001
 #define ICE_MIG_DEVSTAT_VERSION			0x1
 #define ICE_MIG_VF_QRX_TAIL_MAX			256
+#define QTX_HEAD_RESTORE_DELAY_MAX		100
+#define QTX_HEAD_RESTORE_DELAY_SLEEP_US_MIN	10
+#define QTX_HEAD_RESTORE_DELAY_SLEEP_US_MAX	10
 
 struct ice_migration_virtchnl_msg_slot {
 	u32 opcode;
@@ -30,6 +34,8 @@ struct ice_migration_dev_state {
 	u16 vsi_id;
 	/* next RX desc index to be processed by the device */
 	u16 rx_head[ICE_MIG_VF_QRX_TAIL_MAX];
+	/* next TX desc index to be processed by the device */
+	u16 tx_head[ICE_MIG_VF_QRX_TAIL_MAX];
 	u8 virtchnl_msgs[];
 } __aligned(8);
 
@@ -316,6 +322,62 @@ ice_migration_save_rx_head(struct ice_vf *vf,
 	return 0;
 }
 
+/**
+ * ice_migration_save_tx_head - save tx head in migration region
+ * @vf: pointer to VF structure
+ * @devstate: pointer to migration device state
+ *
+ * Return 0 for success, negative for error
+ */
+static int
+ice_migration_save_tx_head(struct ice_vf *vf,
+			   struct ice_migration_dev_state *devstate)
+{
+	struct ice_vsi *vsi = ice_get_vf_vsi(vf);
+	struct ice_pf *pf = vf->pf;
+	struct device *dev;
+	int i = 0;
+
+	dev = ice_pf_to_dev(pf);
+
+	if (!vsi) {
+		dev_err(dev, "VF %d VSI is NULL\n", vf->vf_id);
+		return -EINVAL;
+	}
+
+	ice_for_each_txq(vsi, i) {
+		u16 tx_head;
+		u32 reg;
+
+		devstate->tx_head[i] = 0;
+		if (!test_bit(i, vf->txq_ena))
+			continue;
+
+		reg = rd32(&pf->hw, QTX_COMM_HEAD(vsi->txq_map[i]));
+		tx_head = (reg & QTX_COMM_HEAD_HEAD_M)
+					>> QTX_COMM_HEAD_HEAD_S;
+
+		/* 1. If TX head is QTX_COMM_HEAD_HEAD_M marker, which means
+		 *    it is the value written by software and there are no
+		 *    descriptors write back happened, then there are no
+		 *    packets sent since queue enabled.
+		 * 2. If TX head is ring length minus 1, then it just returns
+		 *    to the start of the ring.
+		 */
+		if (tx_head == QTX_COMM_HEAD_HEAD_M ||
+		    tx_head == (vsi->tx_rings[i]->count - 1))
+			tx_head = 0;
+		else
+			/* Add compensation since value read from TX Head
+			 * register is always the real TX head minus 1
+			 */
+			tx_head++;
+
+		devstate->tx_head[i] = tx_head;
+	}
+	return 0;
+}
+
 /**
  * ice_migration_save_devstate - save device state to migration buffer
  * @pf: pointer to PF of migration device
@@ -376,6 +438,12 @@ ice_migration_save_devstate(struct ice_pf *pf, int vf_id, u8 *buf, u64 buf_sz)
 		goto out_put_vf;
 	}
 
+	ret = ice_migration_save_tx_head(vf, devstate);
+	if (ret) {
+		dev_err(dev, "VF %d failed to save txq head\n", vf->vf_id);
+		goto out_put_vf;
+	}
+
 	list_for_each_entry(msg_listnode, &vf->virtchnl_msg_list, node) {
 		struct ice_migration_virtchnl_msg_slot *msg_slot;
 		u64 slot_size;
@@ -518,6 +586,234 @@ ice_migration_load_rx_head(struct ice_vf *vf,
 	return 0;
 }
 
+/**
+ * ice_migration_init_dummy_desc - init dma ring by dummy descriptor
+ * @tx_desc: tx ring descriptor array
+ * @len: array length
+ * @tx_pkt_dma: dummy packet dma address
+ */
+static inline void
+ice_migration_init_dummy_desc(struct ice_tx_desc *tx_desc,
+			      u16 len,
+			      dma_addr_t tx_pkt_dma)
+{
+	int i;
+
+	/* Init ring with dummy descriptors */
+	for (i = 0; i < len; i++) {
+		u32 td_cmd;
+
+		td_cmd = ICE_TXD_LAST_DESC_CMD | ICE_TX_DESC_CMD_DUMMY;
+		tx_desc[i].cmd_type_offset_bsz =
+				ice_build_ctob(td_cmd, 0, SZ_256, 0);
+		tx_desc[i].buf_addr = cpu_to_le64(tx_pkt_dma);
+	}
+}
+
+/**
+ * ice_migration_wait_for_tx_completion - wait for TX transmission completion
+ * @hw: pointer to the device HW structure
+ * @tx_ring: tx ring instance
+ * @head: expected tx head position when transmission completion
+ *
+ * Return 0 for success, negative for error.
+ */
+static int
+ice_migration_wait_for_tx_completion(struct ice_hw *hw,
+				     struct ice_tx_ring *tx_ring, u16 head)
+{
+	u32 tx_head;
+	int i;
+
+	tx_head = rd32(hw, QTX_COMM_HEAD(tx_ring->reg_idx));
+	tx_head = (tx_head & QTX_COMM_HEAD_HEAD_M)
+		   >> QTX_COMM_HEAD_HEAD_S;
+
+	for (i = 0; i < QTX_HEAD_RESTORE_DELAY_MAX && tx_head != (head - 1);
+				i++) {
+		usleep_range(QTX_HEAD_RESTORE_DELAY_SLEEP_US_MIN,
+			     QTX_HEAD_RESTORE_DELAY_SLEEP_US_MAX);
+
+		tx_head = rd32(hw, QTX_COMM_HEAD(tx_ring->reg_idx));
+		tx_head = (tx_head & QTX_COMM_HEAD_HEAD_M)
+			   >> QTX_COMM_HEAD_HEAD_S;
+	}
+
+	if (i == QTX_HEAD_RESTORE_DELAY_MAX)
+		return -EBUSY;
+
+	return 0;
+}
+
+/**
+ * ice_migration_inject_dummy_desc - inject dummy descriptors
+ * @vf: pointer to VF structure
+ * @tx_ring: tx ring instance
+ * @head: tx head to be loaded
+ * @tx_desc_dma:tx descriptor ring base dma address
+ *
+ * For each TX queue, load the TX head by following below steps:
+ * 1. Backup TX context, switch TX queue context as PF space and PF
+ *    DMA ring base with interrupt disabled
+ * 2. Fill the DMA ring with dummy descriptors and bump doorbell to
+ *    advance TX head. Once kicking doorbell, HW will issue DMA and
+ *    send PCI upstream memory transaction tagged by PF BDF. Since
+ *    ring base is PF's managed DMA buffer, DMA can work successfully
+ *    and TX Head is advanced as expected.
+ * 3. Overwrite TX context by the backup context in step 1. Since TX
+ *    queue head value is not changed while context switch, TX queue
+ *    head is successfully loaded.
+ *
+ * Return 0 for success, negative for error.
+ */
+static int
+ice_migration_inject_dummy_desc(struct ice_vf *vf, struct ice_tx_ring *tx_ring,
+				u16 head, dma_addr_t tx_desc_dma)
+{
+	struct ice_tlan_ctx tlan_ctx, tlan_ctx_orig;
+	struct device *dev = ice_pf_to_dev(vf->pf);
+	struct ice_hw *hw = &vf->pf->hw;
+	u32 dynctl;
+	u32 tqctl;
+	int status;
+	int ret;
+
+	/* 1.1 Backup TX Queue context */
+	status = ice_read_txq_ctx(hw, &tlan_ctx, tx_ring->reg_idx);
+	if (status) {
+		dev_err(dev, "Failed to read TXQ[%d] context, err=%d\n",
+			tx_ring->q_index, status);
+		return -EIO;
+	}
+	memcpy(&tlan_ctx_orig, &tlan_ctx, sizeof(tlan_ctx));
+	tqctl = rd32(hw, QINT_TQCTL(tx_ring->reg_idx));
+	if (tx_ring->q_vector)
+		dynctl = rd32(hw, GLINT_DYN_CTL(tx_ring->q_vector->reg_idx));
+
+	/* 1.2 switch TX queue context as PF space and PF DMA ring base */
+	tlan_ctx.vmvf_type = ICE_TLAN_CTX_VMVF_TYPE_PF;
+	tlan_ctx.vmvf_num = 0;
+	tlan_ctx.base = tx_desc_dma >> ICE_TLAN_CTX_BASE_S;
+	status = ice_write_txq_ctx(hw, &tlan_ctx, tx_ring->reg_idx);
+	if (status) {
+		dev_err(dev, "Failed to write TXQ[%d] context, err=%d\n",
+			tx_ring->q_index, status);
+		return -EIO;
+	}
+
+	/* 1.3 Disable TX queue interrupt */
+	wr32(hw, QINT_TQCTL(tx_ring->reg_idx), QINT_TQCTL_ITR_INDX_M);
+
+	/* To disable tx queue interrupt during run time, software should
+	 * write mmio to trigger a MSIX interrupt.
+	 */
+	if (tx_ring->q_vector)
+		wr32(hw, GLINT_DYN_CTL(tx_ring->q_vector->reg_idx),
+		     (ICE_ITR_NONE << GLINT_DYN_CTL_ITR_INDX_S) |
+		     GLINT_DYN_CTL_SWINT_TRIG_M |
+		     GLINT_DYN_CTL_INTENA_M);
+
+	/* Force memory writes to complete before letting h/w know there
+	 * are new descriptors to fetch.
+	 */
+	wmb();
+
+	/* 2.1 Bump doorbell to advance TX Queue head */
+	writel(head, tx_ring->tail);
+
+	/* 2.2 Wait until TX Queue head move to expected place */
+	ret = ice_migration_wait_for_tx_completion(hw, tx_ring, head);
+	if (ret) {
+		dev_err(dev, "VF %d txq[%d] head loading timeout\n",
+			vf->vf_id, tx_ring->q_index);
+		return ret;
+	}
+
+	/* 3. Overwrite TX Queue context with backup context */
+	status = ice_write_txq_ctx(hw, &tlan_ctx_orig, tx_ring->reg_idx);
+	if (status) {
+		dev_err(dev, "Failed to write TXQ[%d] context, err=%d\n",
+			tx_ring->q_index, status);
+		return -EIO;
+	}
+	wr32(hw, QINT_TQCTL(tx_ring->reg_idx), tqctl);
+	if (tx_ring->q_vector)
+		wr32(hw, GLINT_DYN_CTL(tx_ring->q_vector->reg_idx), dynctl);
+
+	return 0;
+}
+
+/**
+ * ice_migration_load_tx_head - load tx head
+ * @vf: pointer to VF structure
+ * @devstate: pointer to migration device state
+ *
+ * Return 0 for success, negative for error
+ */
+static int
+ice_migration_load_tx_head(struct ice_vf *vf,
+			   struct ice_migration_dev_state *devstate)
+{
+	struct device *dev = ice_pf_to_dev(vf->pf);
+	u16 ring_len = ICE_MAX_NUM_DESC;
+	dma_addr_t tx_desc_dma, tx_pkt_dma;
+	struct ice_tx_desc *tx_desc;
+	struct ice_vsi *vsi;
+	char *tx_pkt;
+	int ret = 0;
+	int i = 0;
+
+	vsi = ice_get_vf_vsi(vf);
+	if (!vsi) {
+		dev_err(dev, "VF %d VSI is NULL\n", vf->vf_id);
+		return -EINVAL;
+	}
+
+	/* Allocate DMA ring and descriptor by PF */
+	tx_desc = dma_alloc_coherent(dev, ring_len * sizeof(struct ice_tx_desc),
+				     &tx_desc_dma, GFP_KERNEL | __GFP_ZERO);
+	tx_pkt = dma_alloc_coherent(dev, SZ_4K, &tx_pkt_dma,
+				    GFP_KERNEL | __GFP_ZERO);
+	if (!tx_desc || !tx_pkt) {
+		dev_err(dev, "PF failed to allocate memory for VF %d\n",
+			vf->vf_id);
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	ice_for_each_txq(vsi, i) {
+		struct ice_tx_ring *tx_ring = vsi->tx_rings[i];
+		u16 *tx_heads = devstate->tx_head;
+
+		/* 1. Skip if TX Queue is not enabled */
+		if (!test_bit(i, vf->txq_ena) || tx_heads[i] == 0)
+			continue;
+
+		if (tx_heads[i] >= tx_ring->count) {
+			dev_err(dev, "VF %d: invalid tx ring length to load\n",
+				vf->vf_id);
+			ret = -EINVAL;
+			goto err;
+		}
+
+		/* Dummy descriptors must be re-initialized after use, since
+		 * it may be written back by HW
+		 */
+		ice_migration_init_dummy_desc(tx_desc, ring_len, tx_pkt_dma);
+		ret = ice_migration_inject_dummy_desc(vf, tx_ring, tx_heads[i],
+						      tx_desc_dma);
+		if (ret)
+			goto err;
+	}
+
+err:
+	dma_free_coherent(dev, ring_len * sizeof(struct ice_tx_desc),
+			  tx_desc, tx_desc_dma);
+	dma_free_coherent(dev, SZ_4K, tx_pkt, tx_pkt_dma);
+
+	return ret;
+}
+
 /**
  * ice_migration_load_devstate - load device state at destination
  * @pf: pointer to PF of migration device
@@ -596,6 +892,16 @@ int ice_migration_load_devstate(struct ice_pf *pf, int vf_id,
 		msg_slot = (struct ice_migration_virtchnl_msg_slot *)
 					((char *)msg_slot + slot_sz);
 	}
+
+	/* Only load the TX Queue head after rest of device state is loaded
+	 * successfully.
+	 */
+	ret = ice_migration_load_tx_head(vf, devstate);
+	if (ret) {
+		dev_err(dev, "VF %d failed to load tx head\n", vf->vf_id);
+		goto out_clear_replay;
+	}
+
 out_clear_replay:
 	clear_bit(ICE_VF_STATE_REPLAYING_VC, vf->vf_states);
 out_put_vf:
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl.c b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
index 8dbe558790af..e588712f585e 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
@@ -1351,6 +1351,24 @@ static int ice_vc_ena_qs_msg(struct ice_vf *vf, u8 *msg)
 			continue;
 
 		ice_vf_ena_txq_interrupt(vsi, vf_q_id);
+
+		/* TX head register is a shadow copy of on-die TX head which
+		 * maintains the accurate location. And TX head register is
+		 * updated only after a packet is sent. If nothing is sent
+		 * after the queue is enabled, then the value is the one
+		 * updated last time and out-of-date.
+		 *
+		 * QTX_COMM_HEAD.HEAD rang value from 0x1fe0 to 0x1fff is
+		 * reserved and will never be used by HW. Manually write a
+		 * reserved value into TX head and use this as a marker for
+		 * the case that there's no packets sent.
+		 *
+		 * This marker is only used in live migration use case.
+		 */
+		if (vf->migration_enabled)
+			wr32(&vsi->back->hw,
+			     QTX_COMM_HEAD(vsi->txq_map[vf_q_id]),
+			     QTX_COMM_HEAD_HEAD_M);
 		set_bit(vf_q_id, vf->txq_ena);
 	}
 
-- 
2.34.1


