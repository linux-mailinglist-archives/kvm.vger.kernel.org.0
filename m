Return-Path: <kvm+bounces-57155-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 04DC4B508A4
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 00:02:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BDD884E3BFB
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 22:01:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C08EA27F732;
	Tue,  9 Sep 2025 22:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nbyd3oIz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF22A265CC5;
	Tue,  9 Sep 2025 22:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757455216; cv=none; b=twmClKqCAVi+cl/kNwWqzZj27JCTTCgopyQjNfy4i/vaTqjXP3sAe5QG7qD6eBm1Pfbt6F2+W9WOBrjvbVH4+SU+r5cegDeg3w6fNu5QefEWwtIwjqQHxPyxw8Eh6G2RALObjmu0Ke6nVgu/nJYiHZlfOTPmdl0qQAUieoyD2zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757455216; c=relaxed/simple;
	bh=vD7Jqj4tEkAvBNRNkbJh/eYq0Xqv+TOhB2jpGCRhIyQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=nh3srQdzKJcH+XkCb4PJLaqbzMHQOw22iDGCpK5qZMbK3eY1a2xfuiypDUoCMcdrZT0wQSkJFv+U1mipG58ic/DFrMUvEaKUBI7kIltCUVocHxmpSr9Aku63Frd50G4AVUcCk8s44xQRbiY9wHhUxGrcPZdUjxf+BreY9j9uTSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nbyd3oIz; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757455214; x=1788991214;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=vD7Jqj4tEkAvBNRNkbJh/eYq0Xqv+TOhB2jpGCRhIyQ=;
  b=nbyd3oIzSJXpQtWxBT6NqrjadQl0sZtH8XhYwcWQl652P0lnWyy10N+q
   h/VcKEYRU/IQpEu/URJhs4Gw0wjwiv61mvRAUCd6UP78XZNV7zhUv1+Re
   p20vrRwxNOHFsxV/z0fp0eu4X+/g5isd7En632rOCMLubEmjubPhi+41I
   lX5EM8P7iMSBzKqDfcVLclfr0sMPl1XwoCxopdnbYQaTPdxDU3EN4vySV
   G+p+6g3Yu0eltu3E5EKcrIlZiVzLxtc7bDkIjEb0ublowmqiJIAISQLI+
   g+3BjVaC+VArEst0O1aggQI+Izh86cswN/eDcDCG3N03uMQPBIUi2W4f8
   w==;
X-CSE-ConnectionGUID: //3VNJTWT1SqTGhKmHgG7A==
X-CSE-MsgGUID: Iz+DImYLQz6Fsqo/3AMfhw==
X-IronPort-AV: E=McAfee;i="6800,10657,11548"; a="63584661"
X-IronPort-AV: E=Sophos;i="6.18,252,1751266800"; 
   d="scan'208";a="63584661"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 15:00:09 -0700
X-CSE-ConnectionGUID: tp1wuVL4QZaMPtHG8XGqtw==
X-CSE-MsgGUID: SZcHgABNS0ewj9+9yHwNxA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,252,1751266800"; 
   d="scan'208";a="172780964"
Received: from orcnseosdtjek.jf.intel.com (HELO [10.166.28.70]) ([10.166.28.70])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 15:00:08 -0700
From: Jacob Keller <jacob.e.keller@intel.com>
Date: Tue, 09 Sep 2025 14:57:53 -0700
Subject: [PATCH RFC net-next 4/7] ice: add migration TLVs for queue and
 interrupt state
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250909-e810-live-migration-jk-migration-tlv-v1-4-4d1dc641e31f@intel.com>
References: <20250909-e810-live-migration-jk-migration-tlv-v1-0-4d1dc641e31f@intel.com>
In-Reply-To: <20250909-e810-live-migration-jk-migration-tlv-v1-0-4d1dc641e31f@intel.com>
To: Tony Nguyen <anthony.l.nguyen@intel.com>, 
 Przemek Kitszel <przemyslaw.kitszel@intel.com>, 
 Andrew Lunn <andrew+netdev@lunn.ch>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>, 
 Alex Williamson <alex.williamson@redhat.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>, 
 Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>, 
 Kevin Tian <kevin.tian@intel.com>, Jakub Kicinski <kuba@kernel.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
 kvm@vger.kernel.org, linux-hardening@vger.kernel.org, 
 Jacob Keller <jacob.e.keller@intel.com>, 
 Aleksandr Loktionov <aleksandr.loktionov@intel.com>
X-Mailer: b4 0.15-dev-c61db
X-Developer-Signature: v=1; a=openpgp-sha256; l=31648;
 i=jacob.e.keller@intel.com; h=from:subject:message-id;
 bh=vD7Jqj4tEkAvBNRNkbJh/eYq0Xqv+TOhB2jpGCRhIyQ=;
 b=owGbwMvMwCWWNS3WLp9f4wXjabUkhowDi1OP/zGP4EyJeca+2y009GP1CbeFVYmGn94e5ol5s
 a9nmqpfRykLgxgXg6yYIouCQ8jK68YTwrTeOMvBzGFlAhnCwMUpABMJus/wP/NX1LUUsZppn9M3
 W3E+u8f+bY8Iz9VPOVMzuLYZLn60OY3hv2vrhr92k7d9bYzV3X9632ONnzGygV+WzJwnNiNutyj
 XNxYA
X-Developer-Key: i=jacob.e.keller@intel.com; a=openpgp;
 fpr=204054A9D73390562AEC431E6A965D3E6F0F28E8

Add the ICE_MIG_TLV_TX_QUEUE, ICE_MIG_TLV_RX_QUEUE, and
ICE_MIG_TLV_MSIX_REGS TLVs to the migration payload buffer.

These TLVs are included in the payload once per queue or interrupt vector,
respectively.

Update the PF driver to ensure that the QTX_COMM_HEAD register is
initialized to a dummy QTX_COMM_HEAD_HEAD_M value, which is necessary to
allow identifying the correct Tx head value.

Replay of the Tx queue data is tricky, as we need to get the Tx queue of
the target state to have the correct head. This is necessary as we must
ensure the real Tx queue head matches the resident head value in the VM
driver memory. Prior to migration start, the VF is reset which has the
queue set to a head and tail of zero.

To correct the head position, the queues are re-assigned to the PF, then
dummy packets are inserted into the queue until the positions are correct.
Finally, the queues are assigned back to the VF. This gets the head
positions correct without invalid DMA access.

DMA for these temporary dummy descriptors is allocated once in the
ice_migration_load_devstate, in order to avoid needless re-allocation of
DMA for each queue.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
---
 .../net/ethernet/intel/ice/virt/migration_tlv.h    |  85 +++
 drivers/net/ethernet/intel/ice/virt/migration.c    | 729 +++++++++++++++++++++
 drivers/net/ethernet/intel/ice/virt/queues.c       |  21 +
 3 files changed, 835 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/virt/migration_tlv.h b/drivers/net/ethernet/intel/ice/virt/migration_tlv.h
index f941a6ccfe77..3e10e53868b2 100644
--- a/drivers/net/ethernet/intel/ice/virt/migration_tlv.h
+++ b/drivers/net/ethernet/intel/ice/virt/migration_tlv.h
@@ -73,6 +73,15 @@ struct ice_migration_tlv {
  * @ICE_MIG_TLV_VF_INFO: General configuration of the VF, including data
  * exchanged over virtchnl as well as PF host configuration.
  *
+ * @ICE_MIG_TLV_TX_QUEUE: Configuration for a Tx queue. Appears once per Tx
+ * queue.
+ *
+ * @ICE_MIG_TLV_RX_QUEUE: Configuration for an Rx queue. Appears once per Rx
+ * queue.
+ *
+ * @ICE_MIG_TLV_MSIX_REGS: MSI-X register data for the VF. Appears once per
+ * MSI-X interrupt, including the miscellaneous interrupt for the mailbox.
+ *
  * @NUM_ICE_MIG_TLV: Number of known TLV types. Any type equal to or larger
  * than this value is unrecognized by this version.
  *
@@ -85,6 +94,9 @@ enum ice_migration_tlvs {
 	ICE_MIG_TLV_END = 0,
 	ICE_MIG_TLV_HEADER,
 	ICE_MIG_TLV_VF_INFO,
+	ICE_MIG_TLV_TX_QUEUE,
+	ICE_MIG_TLV_RX_QUEUE,
+	ICE_MIG_TLV_MSIX_REGS,
 
 	/* Add new types above here */
 	NUM_ICE_MIG_TLV
@@ -176,6 +188,76 @@ struct ice_mig_vf_info {
 	u32 opcodes_allowlist[]; /* __counted_by(virtchnl_op_max), in bits */
 } __packed;
 
+/**
+ * struct ice_mig_tx_queue - Data to migrate a VF Tx queue
+ * @dma: the base DMA address for the queue
+ * @count: size of the Tx ring
+ * @head: the current head position of the Tx ring
+ * @queue_id: the VF relative Tx queue ID
+ * @vector_id: the VF relative MSI-X vector associated with this queue
+ * @vector_valid: if true, an MSI-X vector is associated with this queue
+ * @ena: if true, the Tx queue is currently enabled, false otherwise
+ * @reserved: reservied bitfield which must be zero
+ */
+struct ice_mig_tx_queue {
+	u64 dma;
+	u16 count;
+	u16 head;
+	u16 queue_id;
+	u16 vector_id;
+	u8 vector_valid:1;
+	u8 ena:1;
+	u8 reserved:6;
+} __packed;
+
+/**
+ * struct ice_mig_rx_queue - Data to migrate a VF Rx queue
+ * @dma: the base DMA address for the queue
+ * @max_frame: the maximum frame size of the queue
+ * @rx_buf_len: the length of the Rx buffers associated with the ring
+ * @rxdid: the Rx descriptor format of the ring
+ * @count: the size of the Rx ring
+ * @head: the current head position of the ring
+ * @tail: the current tail position of the ring
+ * @queue_id: the VF relative Rx queue ID
+ * @vector_id: the VF relative MSI-X vector associated with this queue
+ * @vector_valid: if true, an MSI-X vector is associated with this queue
+ * @crc_strip: if true, CRC stripping is enabled, false otherwise
+ * @ena: if true, the Rx queue is currently enabled, false otherwise
+ * @reserved: reserved bitfield which must be zero
+ */
+struct ice_mig_rx_queue {
+	u64 dma;
+	u16 max_frame;
+	u16 rx_buf_len;
+	u32 rxdid;
+	u16 count;
+	u16 head;
+	u16 tail;
+	u16 queue_id;
+	u16 vector_id;
+	u8 vector_valid:1;
+	u8 crc_strip:1;
+	u8 ena:1;
+	u8 reserved:5;
+} __packed;
+
+/**
+ * struct ice_mig_msix_regs - MSI-X register data for migrating VF
+ * @int_dyn_ctl: Contents GLINT_DYN_CTL for this vector
+ * @int_intr: Contents of GLINT_ITR for all ITRs of this vector
+ * @tx_itr_idx: The ITR index used for transmit
+ * @rx_itr_idx: The ITR index used for receive
+ * @vector_id: The MSI-X vector, *including* the miscellaneous non-queue vector
+ */
+struct ice_mig_msix_regs {
+	u32 int_dyn_ctl;
+	u32 int_intr[ICE_MIG_VF_ITR_NUM];
+	u16 tx_itr_idx;
+	u16 rx_itr_idx;
+	u16 vector_id;
+} __packed;
+
 /**
  * ice_mig_tlv_type - Convert a TLV type to its number
  * @p: the TLV structure type
@@ -188,6 +270,9 @@ struct ice_mig_vf_info {
 	_Generic(*(p),							\
 		 struct ice_mig_tlv_header : ICE_MIG_TLV_HEADER,	\
 		 struct ice_mig_vf_info : ICE_MIG_TLV_VF_INFO,		\
+		 struct ice_mig_tx_queue : ICE_MIG_TLV_TX_QUEUE,	\
+		 struct ice_mig_rx_queue : ICE_MIG_TLV_RX_QUEUE,	\
+		 struct ice_mig_msix_regs : ICE_MIG_TLV_MSIX_REGS,	\
 		 default : ICE_MIG_TLV_END)
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/virt/migration.c b/drivers/net/ethernet/intel/ice/virt/migration.c
index 67ce5b73a9ce..e59eb99b20da 100644
--- a/drivers/net/ethernet/intel/ice/virt/migration.c
+++ b/drivers/net/ethernet/intel/ice/virt/migration.c
@@ -138,6 +138,269 @@ static int ice_migration_save_vf_info(struct ice_vf *vf, struct ice_vsi *vsi)
 	return 0;
 }
 
+/**
+ * ice_migration_save_tx_queues - Save Tx queue state
+ * @vf: pointer to the VF being migrated
+ * @vsi: the VSI for this VF
+ *
+ * Save Tx queue state in preparation for live migration.
+ *
+ * Return: 0 for success, negative for error
+ */
+static int ice_migration_save_tx_queues(struct ice_vf *vf, struct ice_vsi *vsi)
+{
+	struct device *dev = ice_pf_to_dev(vf->pf);
+	struct ice_mig_tlv_entry *entry, *tmp;
+	struct list_head queue_tlvs;
+	int err, i;
+
+	lockdep_assert_held(&vf->cfg_lock);
+	INIT_LIST_HEAD(&queue_tlvs);
+
+	dev_dbg(dev, "Saving Tx queue config for VF %u\n",
+		vf->vf_id);
+
+	ice_for_each_txq(vsi, i) {
+		struct ice_tx_ring *tx_ring = vsi->tx_rings[i];
+		struct ice_mig_tx_queue *tx_queue;
+		struct ice_tlan_ctx tlan_ctx = {};
+		struct ice_hw *hw = &vf->pf->hw;
+		u32 qtx_comm_head;
+		u16 tx_head;
+		int err;
+
+		if (!tx_ring)
+			continue;
+
+		/* Ignore queues which were never configured by the VF */
+		if (!tx_ring->dma) {
+			dev_dbg(dev, "Ignoring unconfigured Tx queue %d on VF %d with NULL DMA address\n",
+				i, vf->vf_id);
+			continue;
+		}
+
+		tx_queue = ice_mig_alloc_tlv(tx_queue);
+		if (!tx_queue) {
+			err = -ENOMEM;
+			goto err_free_tlv_entries;
+		}
+
+		err = ice_read_txq_ctx(hw, &tlan_ctx, tx_ring->reg_idx);
+		if (err) {
+			dev_err(dev, "Failed to read TXQ[%d] context, err=%d\n",
+				tx_ring->q_index, err);
+			goto err_free_tlv_entries;
+		}
+
+		qtx_comm_head = rd32(hw, QTX_COMM_HEAD(tx_ring->reg_idx));
+		tx_head = FIELD_GET(QTX_COMM_HEAD_HEAD_M, qtx_comm_head);
+
+		/* Determine the Tx head from the QTX_COMM_HEAD register.
+		 *
+		 * If no write back has happened since the queue was enabled,
+		 * the register will read as QTX_COMM_HEAD_HEAD_M.
+		 *
+		 * Otherwise, the value from QTX_COMM_HEAD will be precisely
+		 * one behind the real Tx head value.
+		 */
+		if (tx_head == QTX_COMM_HEAD_HEAD_M ||
+		    tx_head == tx_ring->count - 1)
+			tx_head = 0;
+		else
+			tx_head++;
+
+		tx_queue->queue_id = i;
+		tx_queue->dma = tx_ring->dma;
+		tx_queue->count = tx_ring->count;
+		tx_queue->head = tx_head;
+		if (tx_ring->q_vector) {
+			/* we don't need to account for ICE_NONQ_VECS_VF here,
+			 * as the deserializing end won't expect it.
+			 */
+			tx_queue->vector_id = tx_ring->q_vector->v_idx;
+			tx_queue->vector_valid = 1;
+		}
+		tx_queue->ena = test_bit(i, vf->txq_ena);
+
+		ice_mig_tlv_add_tail(tx_queue, &queue_tlvs);
+	}
+
+	list_splice_tail(&queue_tlvs, &vf->mig_tlvs);
+
+	return 0;
+
+err_free_tlv_entries:
+	list_for_each_entry_safe(entry, tmp, &queue_tlvs, list_entry) {
+		list_del(&entry->list_entry);
+		kfree(entry);
+	}
+
+	return err;
+}
+
+/**
+ * ice_migration_save_rx_queues - Save Rx queue state
+ * @vf: pointer to the VF being migrated
+ * @vsi: the VSI for this VF
+ *
+ * Save Rx queue state in preparation for live migration.
+ *
+ * Return: 0 for success, negative for error
+ */
+static int ice_migration_save_rx_queues(struct ice_vf *vf, struct ice_vsi *vsi)
+{
+	struct device *dev = ice_pf_to_dev(vf->pf);
+	struct ice_mig_tlv_entry *entry, *tmp;
+	struct list_head queue_tlvs;
+	int err, i;
+
+	lockdep_assert_held(&vf->cfg_lock);
+	INIT_LIST_HEAD(&queue_tlvs);
+
+	dev_dbg(dev, "Saving Rx queue config for VF %u\n",
+		vf->vf_id);
+
+	ice_for_each_rxq(vsi, i) {
+		struct ice_rx_ring *rx_ring = vsi->rx_rings[i];
+		struct ice_mig_rx_queue *rx_queue;
+		struct ice_rlan_ctx rlan_ctx = {};
+		struct ice_hw *hw = &vf->pf->hw;
+		u32 rxflxp;
+		int err;
+
+		if (!rx_ring)
+			continue;
+
+		/* Ignore queues which were never configured by the VF */
+		if (!rx_ring->dma) {
+			dev_dbg(dev, "Ignoring unconfigured Rx queue %d on VF %d with NULL DMA address\n",
+				i, vf->vf_id);
+			continue;
+		}
+
+		rx_queue = ice_mig_alloc_tlv(rx_queue);
+		if (!rx_queue) {
+			err = -ENOMEM;
+			goto err_free_tlv_entries;
+		}
+
+		err = ice_read_rxq_ctx(hw, &rlan_ctx, rx_ring->reg_idx);
+		if (err) {
+			dev_err(dev, "Failed to read RXQ[%d] context, err=%d\n",
+				rx_ring->q_index, err);
+			goto err_free_tlv_entries;
+		}
+
+		rxflxp = rd32(hw, QRXFLXP_CNTXT(rx_ring->reg_idx));
+
+		rx_queue->queue_id = i;
+		rx_queue->head = rlan_ctx.head;
+		rx_queue->tail = QRX_TAIL(rx_ring->reg_idx);
+		rx_queue->dma = rx_ring->dma;
+		rx_queue->max_frame = rlan_ctx.rxmax;
+		rx_queue->rx_buf_len = rx_ring->rx_buf_len;
+		rx_queue->rxdid = FIELD_GET(QRXFLXP_CNTXT_RXDID_IDX_M, rxflxp);
+		rx_queue->count = rx_ring->count;
+		if (rx_ring->q_vector) {
+			/* we don't need to account for ICE_NONQ_VECS_VF here,
+			 * as the deserializing end won't expect it.
+			 */
+			rx_queue->vector_id = rx_ring->q_vector->v_idx;
+			rx_queue->vector_valid = 1;
+		}
+		rx_queue->crc_strip = rlan_ctx.crcstrip;
+		rx_queue->ena = test_bit(i, vf->rxq_ena);
+
+		ice_mig_tlv_add_tail(rx_queue, &queue_tlvs);
+	}
+
+	list_splice_tail(&queue_tlvs, &vf->mig_tlvs);
+
+	return 0;
+
+err_free_tlv_entries:
+	list_for_each_entry_safe(entry, tmp, &queue_tlvs, list_entry) {
+		list_del(&entry->list_entry);
+		kfree(entry);
+	}
+
+	return err;
+}
+
+/**
+ * ice_migration_save_msix_regs - Save MSI-X registers during suspend
+ * @vf: pointer to the VF being migrated
+ * @vsi: the VSI for this VF
+ *
+ * Save the MMIO registers associated with MSI-X interrupts, including the
+ * miscellaneous interrupt used for the mailbox. Called during suspend to save
+ * the values prior to queue shutdown, to ensure they match the VF suspended
+ * state accurately.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+static int ice_migration_save_msix_regs(struct ice_vf *vf,
+					struct ice_vsi *vsi)
+{
+	struct ice_mig_tlv_entry *entry, *tmp;
+	struct ice_hw *hw = &vf->pf->hw;
+	struct list_head msix_tlvs;
+	int err;
+
+	lockdep_assert_held(&vf->cfg_lock);
+	INIT_LIST_HEAD(&msix_tlvs);
+
+	/* Copy the IRQ registers, starting with the non-queue vectors */
+	for (int idx = 0; idx < vsi->num_q_vectors + ICE_NONQ_VECS_VF; idx++) {
+		struct ice_mig_msix_regs *msix_regs;
+		u16 reg_idx, tx_itr_idx, rx_itr_idx;
+
+		if (idx < ICE_NONQ_VECS_VF) {
+			reg_idx = vf->first_vector_idx + idx;
+			tx_itr_idx = 0;
+			rx_itr_idx = 0;
+		} else {
+			struct ice_q_vector *q_vector;
+			int v_id;
+
+			v_id = idx - ICE_NONQ_VECS_VF;
+			q_vector = vsi->q_vectors[v_id];
+			reg_idx = q_vector->reg_idx;
+			tx_itr_idx = q_vector->tx.itr_idx;
+			rx_itr_idx = q_vector->rx.itr_idx;
+		}
+
+		msix_regs = ice_mig_alloc_tlv(msix_regs);
+		if (!msix_regs) {
+			err = -ENOMEM;
+			goto err_free_tlv_entries;
+		}
+
+		msix_regs->vector_id = idx;
+		msix_regs->tx_itr_idx = tx_itr_idx;
+		msix_regs->rx_itr_idx = rx_itr_idx;
+
+		msix_regs->int_dyn_ctl = rd32(hw, GLINT_DYN_CTL(reg_idx));
+		for (int itr = 0; itr < ICE_MIG_VF_ITR_NUM; itr++)
+			msix_regs->int_intr[itr] =
+				rd32(hw, GLINT_ITR(itr, reg_idx));
+
+		ice_mig_tlv_add_tail(msix_regs, &msix_tlvs);
+	}
+
+	list_splice_tail(&msix_tlvs, &vf->mig_tlvs);
+
+	return 0;
+
+err_free_tlv_entries:
+	list_for_each_entry_safe(entry, tmp, &msix_tlvs, list_entry) {
+		list_del(&entry->list_entry);
+		kfree(entry);
+	}
+
+	return err;
+}
+
 /**
  * ice_migration_suspend_dev - suspend device
  * @vf_dev: pointer to the VF PCI device
@@ -195,6 +458,11 @@ int ice_migration_suspend_dev(struct pci_dev *vf_dev, bool save_state)
 		err = ice_migration_save_vf_info(vf, vsi);
 		if (err)
 			goto err_free_mig_tlvs;
+
+		err = ice_migration_save_msix_regs(vf, vsi);
+		if (err)
+			goto err_free_mig_tlvs;
+
 	}
 
 	/* Prevent VSI from queuing incoming packets by removing all filters */
@@ -221,6 +489,17 @@ int ice_migration_suspend_dev(struct pci_dev *vf_dev, bool save_state)
 		dev_warn(dev, "VF %d failed to stop Rx rings. Continuing live migration regardless.\n",
 			 vf->vf_id);
 
+	if (save_state) {
+		/* Save queue state after stopping the queues */
+		err = ice_migration_save_rx_queues(vf, vsi);
+		if (err)
+			goto err_free_mig_tlvs;
+
+		err = ice_migration_save_tx_queues(vf, vsi);
+		if (err)
+			goto err_free_mig_tlvs;
+	}
+
 	mutex_unlock(&vf->cfg_lock);
 	ice_put_vf(vf);
 
@@ -700,6 +979,424 @@ static int ice_migration_load_vf_info(struct ice_vf *vf, struct ice_vsi *vsi,
 	return 0;
 }
 
+/**
+ * ice_migration_init_dummy_desc - Initialize DMA for the dummy descriptors
+ * @tx_desc: Tx ring descriptor array
+ * @len: length of the descriptor array
+ * @tx_pkt_dma: dummy packet DMA memory
+ *
+ * Initialize the dummy ring data descriptors using the provided DMA for
+ * packet data memory.
+ */
+static void ice_migration_init_dummy_desc(struct ice_tx_desc *tx_desc,
+					  u16 len, dma_addr_t tx_pkt_dma)
+{
+	for (int i = 0; i < len; i++) {
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
+ * ice_migration_wait_for_tx_completion - Wait for Tx transmission completion
+ * @hw: pointer to the device HW structure
+ * @tx_ring: Tx ring structure
+ * @head: target Tx head position
+ *
+ * Wait for hardware to complete updating the Tx ring head. We read this value
+ * from QTX_COMM_HEAD. This will either be the initially programmed
+ * QTX_COMM_HEAD_HEAD_M marker value, or one before the actual head of the Tx
+ * ring.
+ *
+ * Since we only inject packets when the head needs to move from zero, the
+ * target head position will always be non-zero.
+ *
+ * Return: 0 for success, negative for error.
+ */
+static int
+ice_migration_wait_for_tx_completion(struct ice_hw *hw,
+				     struct ice_tx_ring *tx_ring, u16 head)
+{
+	u32 tx_head;
+	int err;
+
+	err = rd32_poll_timeout(hw, QTX_COMM_HEAD(tx_ring->reg_idx),
+				tx_head,
+				FIELD_GET(QTX_COMM_HEAD_HEAD_M, tx_head) == head - 1,
+				10, 500);
+	if (err) {
+		dev_dbg(ice_hw_to_dev(hw), "Timed out waiting for Tx ring completion, target head %u, qtx_comm_head %u, err %d\n",
+			head, tx_head, err);
+		return err;
+	}
+
+	return 0;
+}
+
+/**
+ * ice_migration_inject_dummy_desc - Inject dummy descriptors to move Tx head
+ * @vf: pointer to the VF being migrated to
+ * @tx_ring: Tx ring instance
+ * @head: Tx head to be loaded
+ * @tx_desc_dma: Tx descriptor ring base DMG address
+ *
+ * Load the Tx head for the given Tx ring using the following steps:
+ *
+ * 1. Initialize QTX_COMM_HEAD to marker value.
+ * 2. Backup the current Tx context.
+ * 3. Temporarily update the Tx context to point to the PF space, using the
+ *    provided PF Tx descriptor DMA, filled with dummy descriptors and packet
+ *    data.
+ * 4. Disable the Tx queue interrupt.
+ * 5. Bump the Tx ring doorbell to the desired Tx head position.
+ * 6. Wait for hardware to DMA and update Tx head.
+ *    and update the Tx head.
+ * 7. Restore the backed up Tx queue context.
+ * 8. Re-enable the Tx queue interrupt.
+ *
+ * By updating the queue context to point to the PF space with the PF-managed
+ * DMA address, the HW will issue PCI upstream memory transactions tagged by
+ * the PF BDF. This will work successfully to update the Tx head without
+ * needing to interact with the VF DMA.
+ *
+ * Return: 0 for success, negative for error.
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
+	int err;
+
+	/* 1. Initialize head after re-programming the queue */
+	wr32(hw, QTX_COMM_HEAD(tx_ring->reg_idx), QTX_COMM_HEAD_HEAD_M);
+
+	/* 2. Backup Tx Queue context */
+	err = ice_read_txq_ctx(hw, &tlan_ctx, tx_ring->reg_idx);
+	if (err) {
+		dev_err(dev, "Failed to read TXQ[%d] context, err=%d\n",
+			tx_ring->q_index, err);
+		return -EIO;
+	}
+	memcpy(&tlan_ctx_orig, &tlan_ctx, sizeof(tlan_ctx));
+	tqctl = rd32(hw, QINT_TQCTL(tx_ring->reg_idx));
+	if (tx_ring->q_vector)
+		dynctl = rd32(hw, GLINT_DYN_CTL(tx_ring->q_vector->reg_idx));
+
+	/* 3. Switch Tx queue context as PF space and PF DMA ring base. */
+	tlan_ctx.vmvf_type = ICE_TLAN_CTX_VMVF_TYPE_PF;
+	tlan_ctx.vmvf_num = 0;
+	tlan_ctx.base = tx_desc_dma >> ICE_TLAN_CTX_BASE_S;
+	err = ice_write_txq_ctx(hw, &tlan_ctx, tx_ring->reg_idx);
+	if (err) {
+		dev_err(dev, "Failed to write TXQ[%d] context, err=%d\n",
+			tx_ring->q_index, err);
+		return -EIO;
+	}
+
+	/* 4. Disable Tx queue interrupt. */
+	wr32(hw, QINT_TQCTL(tx_ring->reg_idx), QINT_TQCTL_ITR_INDX_M);
+
+	/* To disable Tx queue interrupt during run time, software should
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
+	/* 5. Bump doorbell to advance Tx Queue head */
+	writel(head, tx_ring->tail);
+
+	/* 6. Wait until Tx Queue head move to expected place */
+	err = ice_migration_wait_for_tx_completion(hw, tx_ring, head);
+	if (err) {
+		dev_err(dev, "VF %d txq[%d] head loading timeout\n",
+			vf->vf_id, tx_ring->q_index);
+		return err;
+	}
+
+	/* 7. Overwrite Tx Queue context with backup context */
+	err = ice_write_txq_ctx(hw, &tlan_ctx_orig, tx_ring->reg_idx);
+	if (err) {
+		dev_err(dev, "Failed to write TXQ[%d] context, err=%d\n",
+			tx_ring->q_index, err);
+		return -EIO;
+	}
+
+	/* 8. Re-enable Tx queue interrupt */
+	wr32(hw, QINT_TQCTL(tx_ring->reg_idx), tqctl);
+	if (tx_ring->q_vector)
+		wr32(hw, GLINT_DYN_CTL(tx_ring->q_vector->reg_idx), dynctl);
+
+	return 0;
+}
+
+/**
+ * ice_migration_load_tx_queue - Load Tx queue data from migration payload
+ * @vf: pointer to the VF being migrated to
+ * @vsi: the VSI for this VF
+ * @tx_queue: Tx queue data from migration payload
+ * @tx_desc: temporary descriptor for moving Tx head
+ * @tx_desc_dma: temporary descriptor DMA for moving Tx head
+ * @tx_pkt_dma: temporary packet DMA for moving Tx head
+ *
+ * Load the Tx queue information from the migration buffer into the target VF.
+ *
+ * Return: 0 for success, negative for error
+ */
+static int ice_migration_load_tx_queue(struct ice_vf *vf, struct ice_vsi *vsi,
+				       const struct ice_mig_tx_queue *tx_queue,
+				       struct ice_tx_desc *tx_desc,
+				       dma_addr_t tx_desc_dma,
+				       dma_addr_t tx_pkt_dma)
+{
+	struct device *dev = ice_pf_to_dev(vf->pf);
+	struct ice_q_vector *q_vector;
+	struct ice_tx_ring *tx_ring;
+	int err;
+
+	lockdep_assert_held(&vf->cfg_lock);
+
+	if (tx_queue->queue_id >= vsi->num_txq) {
+		dev_dbg(dev, "Got data for queue %d but the VF is only configured with %d Tx queues\n",
+			tx_queue->queue_id, vsi->num_txq);
+		return -EINVAL;
+	}
+
+	dev_dbg(dev, "Loading Tx VF queue %d (PF queue %d) on VF %d\n",
+		tx_queue->queue_id, vsi->txq_map[tx_queue->queue_id],
+		vf->vf_id);
+
+	tx_ring = vsi->tx_rings[tx_queue->queue_id];
+
+	if (WARN_ON_ONCE(!tx_ring))
+		return -EINVAL;
+
+	tx_ring->dma = tx_queue->dma;
+	tx_ring->count = tx_queue->count;
+
+	/* Disable any existing queue first */
+	err = ice_vf_vsi_dis_single_txq(vf, vsi, tx_queue->queue_id);
+	if (err) {
+		dev_dbg(dev, "Failed to disable existing queue, err %d\n",
+			err);
+		return err;
+	}
+
+	err = ice_vsi_cfg_single_txq(vsi, vsi->tx_rings, tx_queue->queue_id);
+	if (err) {
+		dev_dbg(dev, "Failed to configure Tx queue %u, err %d\n",
+			tx_queue->queue_id, err);
+		return err;
+	}
+
+	if (tx_queue->head >= tx_ring->count) {
+		dev_err(dev, "VF %d: invalid tx ring length to load\n",
+			vf->vf_id);
+		return -EINVAL;
+	}
+
+	/* After the initial reset and Tx queue re-programming, the Tx head
+	 * and tail state will be zero. If the desired state for the head is
+	 * non-zero, we need to inject some dummy packets into the queue to
+	 * move the head of the ring to the desired value.
+	 */
+	if (tx_queue->head) {
+		ice_migration_init_dummy_desc(tx_desc, ICE_MAX_NUM_DESC,
+					      tx_pkt_dma);
+		err = ice_migration_inject_dummy_desc(vf, tx_ring,
+						      tx_queue->head,
+						      tx_desc_dma);
+		if (err)
+			return err;
+	}
+
+	if (tx_queue->vector_valid) {
+		q_vector = vsi->q_vectors[tx_queue->vector_id];
+		ice_cfg_txq_interrupt(vsi, tx_queue->queue_id,
+				      q_vector->vf_reg_idx,
+				      q_vector->tx.itr_idx);
+	}
+
+	if (tx_queue->ena) {
+		ice_vf_ena_txq_interrupt(vsi, tx_queue->queue_id);
+		set_bit(tx_queue->queue_id, vf->txq_ena);
+	}
+
+	return 0;
+}
+
+/**
+ * ice_migration_load_rx_queue - Load Rx queue data from migration buffer
+ * @vf: pointer to the VF being migrated to
+ * @vsi: pointer to the VSI for the VF
+ * @rx_queue: pointer to Rx queue migration data
+ *
+ * Load the Rx queue data from the migration payload into the target VF.
+ *
+ * Return: 0 for success, negative for error
+ */
+static int ice_migration_load_rx_queue(struct ice_vf *vf, struct ice_vsi *vsi,
+				       const struct ice_mig_rx_queue *rx_queue)
+{
+	struct device *dev = ice_pf_to_dev(vf->pf);
+	struct ice_rlan_ctx rlan_ctx = {};
+	struct ice_hw *hw = &vf->pf->hw;
+	struct ice_q_vector *q_vector;
+	struct ice_rx_ring *rx_ring;
+	int err;
+
+	lockdep_assert_held(&vf->cfg_lock);
+
+	if (rx_queue->queue_id >= vsi->num_rxq) {
+		dev_dbg(dev, "Got data for queue %d but the VF is only configured with %d Rx queues\n",
+			rx_queue->queue_id, vsi->num_rxq);
+		return -EINVAL;
+	}
+
+	dev_dbg(dev, "Loading Rx queue %d on VF %d\n",
+		rx_queue->queue_id, vf->vf_id);
+
+	if (!(BIT(rx_queue->rxdid) & vf->pf->supported_rxdids)) {
+		dev_dbg(dev, "Got unsupported Rx descriptor ID %u\n",
+			rx_queue->rxdid);
+		return -EINVAL;
+	}
+
+	rx_ring = vsi->rx_rings[rx_queue->queue_id];
+
+	if (WARN_ON_ONCE(!rx_ring))
+		return -EINVAL;
+
+	rx_ring->dma = rx_queue->dma;
+	rx_ring->count = rx_queue->count;
+
+	if (rx_queue->crc_strip)
+		rx_ring->flags &= ~ICE_RX_FLAGS_CRC_STRIP_DIS;
+	else
+		rx_ring->flags |= ICE_RX_FLAGS_CRC_STRIP_DIS;
+
+	rx_ring->rx_buf_len = rx_queue->rx_buf_len;
+	rx_ring->max_frame = rx_queue->max_frame;
+
+	err = ice_vsi_cfg_single_rxq(vsi, rx_queue->queue_id);
+	if (err) {
+		dev_dbg(dev, "Failed to configure Rx queue %u for VF %u, err %d\n",
+			rx_queue->queue_id, vf->vf_id, err);
+		return err;
+	}
+
+	ice_write_qrxflxp_cntxt(hw, rx_ring->reg_idx,
+				rx_queue->rxdid, 0x03, false);
+
+	err = ice_read_rxq_ctx(hw, &rlan_ctx, rx_ring->reg_idx);
+	if (err) {
+		dev_err(dev, "Failed to read RXQ[%d] context, err=%d\n",
+			rx_ring->q_index, err);
+		return -EIO;
+	}
+
+	rlan_ctx.head = rx_queue->head;
+	err = ice_write_rxq_ctx(hw, &rlan_ctx, rx_ring->reg_idx);
+	if (err) {
+		dev_err(dev, "Failed to set LAN RXQ[%d] context, err=%d\n",
+			rx_ring->q_index, err);
+		return -EIO;
+	}
+
+	wr32(hw, QRX_TAIL(rx_ring->reg_idx), rx_queue->tail);
+
+	if (rx_queue->vector_valid) {
+		q_vector = vsi->q_vectors[rx_queue->vector_id];
+		ice_cfg_rxq_interrupt(vsi, rx_queue->queue_id,
+				      q_vector->vf_reg_idx,
+				      q_vector->rx.itr_idx);
+	}
+
+	if (rx_queue->ena) {
+		err = ice_vsi_ctrl_one_rx_ring(vsi, true, rx_queue->queue_id,
+					       true);
+		if (err) {
+			dev_err(dev, "Failed to enable Rx ring %d on VSI %d, err %d\n",
+				rx_queue->queue_id, vsi->vsi_num, err);
+			return -EIO;
+		}
+
+		ice_vf_ena_rxq_interrupt(vsi, rx_queue->queue_id);
+		set_bit(rx_queue->queue_id, vf->rxq_ena);
+	}
+
+	return 0;
+}
+
+/**
+ * ice_migration_load_msix_regs - Load MSI-X vector registers
+ * @vf: pointer to the VF being migrated to
+ * @vsi: the VSI of the target VF
+ * @msix_regs: MSI-X register data from migration payload
+ *
+ * Load the MSI-X vector register data from the migration payload into the
+ * target VF.
+ *
+ * Return: 0 for success, negative for error
+ */
+static int
+ice_migration_load_msix_regs(struct ice_vf *vf, struct ice_vsi *vsi,
+			     const struct ice_mig_msix_regs *msix_regs)
+{
+	struct device *dev = ice_pf_to_dev(vf->pf);
+	struct ice_hw *hw = &vf->pf->hw;
+	u16 reg_idx;
+	int itr;
+
+	lockdep_assert_held(&vf->cfg_lock);
+
+	if (msix_regs->vector_id > vsi->num_q_vectors + ICE_NONQ_VECS_VF) {
+		dev_dbg(dev, "Got data for MSI-X vector %d, but the VF is only configured with %d vectors\n",
+			msix_regs->vector_id,
+			vsi->num_q_vectors + ICE_NONQ_VECS_VF);
+		return -EINVAL;
+	}
+
+	dev_dbg(dev, "Loading MSI-X register configuration for VF %u\n",
+		vf->vf_id);
+
+	if (msix_regs->vector_id < ICE_NONQ_VECS_VF) {
+		reg_idx = vf->first_vector_idx + msix_regs->vector_id;
+	} else {
+		struct ice_q_vector *q_vector;
+		int v_id;
+
+		v_id = msix_regs->vector_id - ICE_NONQ_VECS_VF;
+		q_vector = vsi->q_vectors[v_id];
+		reg_idx = q_vector->reg_idx;
+
+		q_vector->tx.itr_idx = msix_regs->tx_itr_idx;
+		q_vector->rx.itr_idx = msix_regs->rx_itr_idx;
+	}
+
+	wr32(hw, GLINT_DYN_CTL(reg_idx), msix_regs->int_dyn_ctl);
+	for (itr = 0; itr < ICE_MIG_VF_ITR_NUM; itr++)
+		wr32(hw, GLINT_ITR(itr, reg_idx), msix_regs->int_intr[itr]);
+
+	return 0;
+}
+
 /**
  * ice_migration_load_devstate - Load device state into the target VF
  * @vf_dev: pointer to the VF PCI device
@@ -714,9 +1411,12 @@ static int ice_migration_load_vf_info(struct ice_vf *vf, struct ice_vsi *vsi,
 int ice_migration_load_devstate(struct pci_dev *vf_dev, const void *buf,
 				size_t buf_sz)
 {
+	const size_t dma_size = ICE_MAX_NUM_DESC * sizeof(struct ice_tx_desc);
 	struct ice_pf *pf = ice_vf_dev_to_pf(vf_dev);
 	const struct ice_mig_vf_info *vf_info;
 	const struct ice_migration_tlv *tlv;
+	dma_addr_t tx_desc_dma, tx_pkt_dma;
+	void *tx_desc, *tx_pkt;
 	struct ice_vsi *vsi;
 	struct device *dev;
 	struct ice_vf *vf;
@@ -743,6 +1443,15 @@ int ice_migration_load_devstate(struct pci_dev *vf_dev, const void *buf,
 		return -EINVAL;
 	}
 
+	/* Allocate DMA ring and descriptor by PF */
+	tx_desc = dma_alloc_coherent(dev, dma_size, &tx_desc_dma, GFP_KERNEL);
+	if (!tx_desc)
+		return -ENOMEM;
+
+	tx_pkt = dma_alloc_coherent(dev, SZ_4K, &tx_pkt_dma, GFP_KERNEL);
+	if (!tx_pkt)
+		goto err_free_tx_desc_dma;
+
 	mutex_lock(&vf->cfg_lock);
 
 	vsi = ice_get_vf_vsi(vf);
@@ -763,6 +1472,7 @@ int ice_migration_load_devstate(struct pci_dev *vf_dev, const void *buf,
 	tlv = buf;
 
 	do {
+		const void *data = tlv->data;
 		size_t tlv_size;
 
 		switch (tlv->type) {
@@ -771,6 +1481,18 @@ int ice_migration_load_devstate(struct pci_dev *vf_dev, const void *buf,
 		case ICE_MIG_TLV_VF_INFO:
 			/* These are already handled above */
 			break;
+		case ICE_MIG_TLV_TX_QUEUE:
+			err = ice_migration_load_tx_queue(vf, vsi, data,
+							  tx_desc,
+							  tx_desc_dma,
+							  tx_pkt_dma);
+			break;
+		case ICE_MIG_TLV_RX_QUEUE:
+			err = ice_migration_load_rx_queue(vf, vsi, data);
+			break;
+		case ICE_MIG_TLV_MSIX_REGS:
+			err = ice_migration_load_msix_regs(vf, vsi, data);
+			break;
 		default:
 			dev_dbg(dev, "Unexpected TLV %d in payload?\n",
 				tlv->type);
@@ -791,12 +1513,19 @@ int ice_migration_load_devstate(struct pci_dev *vf_dev, const void *buf,
 
 	ice_put_vf(vf);
 
+	dma_free_coherent(dev, SZ_4K, tx_pkt, tx_pkt_dma);
+	dma_free_coherent(dev, dma_size, tx_desc, tx_desc_dma);
+
 	return 0;
 
 err_release_cfg_lock:
 	mutex_unlock(&vf->cfg_lock);
 	ice_put_vf(vf);
 
+	dma_free_coherent(dev, SZ_4K, tx_pkt, tx_pkt_dma);
+err_free_tx_desc_dma:
+	dma_free_coherent(dev, dma_size, tx_desc, tx_desc_dma);
+
 	return err;
 }
 EXPORT_SYMBOL(ice_migration_load_devstate);
diff --git a/drivers/net/ethernet/intel/ice/virt/queues.c b/drivers/net/ethernet/intel/ice/virt/queues.c
index 40575cfe6dd4..65ba0a1d8c1f 100644
--- a/drivers/net/ethernet/intel/ice/virt/queues.c
+++ b/drivers/net/ethernet/intel/ice/virt/queues.c
@@ -299,6 +299,27 @@ int ice_vc_ena_qs_msg(struct ice_vf *vf, u8 *msg)
 			continue;
 
 		ice_vf_ena_txq_interrupt(vsi, vf_q_id);
+
+		/* The Tx head register is a shadow copy of on-die Tx head
+		 * which maintains the accurate location. The Tx head register
+		 * is only updated after a packet is sent, and is updated to
+		 * the value one behind the actual on-die Tx head value.
+		 *
+		 * Even after queue enable, until a packet is sent the Tx head
+		 * remains whatever value it had before.
+		 *
+		 * QTX_COMM_HEAD.HEAD values from 0x1fe0 to 0x1fff are
+		 * reserved and will never be used by HW. Manually write a
+		 * reserved value into Tx head and use this as a marker to
+		 * indicate that no packets have been sent since the queue was
+		 * enabled.
+		 *
+		 * This marker is used by the live migration logic to
+		 * accurately determine the Tx queue head.
+		 */
+		wr32(&vsi->back->hw, QTX_COMM_HEAD(vsi->txq_map[vf_q_id]),
+		     QTX_COMM_HEAD_HEAD_M);
+
 		set_bit(vf_q_id, vf->txq_ena);
 	}
 

-- 
2.51.0.rc1.197.g6d975e95c9d7


