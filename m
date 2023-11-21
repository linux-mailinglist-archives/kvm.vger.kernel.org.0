Return-Path: <kvm+bounces-2147-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C7487F2456
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 03:51:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 239F928292D
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 02:51:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D8F51804D;
	Tue, 21 Nov 2023 02:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MFLFGm4v"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DED1D8;
	Mon, 20 Nov 2023 18:50:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700535027; x=1732071027;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WtUoAVlpdEKgZFTz0tk9mfNmhk98t+A/5sj4rLyqYzM=;
  b=MFLFGm4v7vPnX+ku0mG8CH68lLIB7Ji6FGjT0MKrj0sL4qYWWN1oi2Ut
   dvTflcO2yJODKenaSs+8I03w0VKwxZJmsqSWwojLxTAnui8TQp6L8AVMU
   gpFRY7uHAcHYZXSUiWcFLgLWgiJM78kQVSFze/FPiOkAemrpz60sSNEMX
   6hdC5hjDPQ8xC1rSBa2lGOcAkzK8vCgeoj3SXBcj1a9VTBGy+Mwntjdzi
   VgYTs7W5D4hMBj8cqeh+2i1bYBAc/gSUdmLb820nZtjgOan+c9dplwU2r
   eLqRr1Kr3vmCA7ADhNqLbyHo6O3dIOcTfSCuij2hsUZbfSw6smEgT7mcR
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10900"; a="458246021"
X-IronPort-AV: E=Sophos;i="6.04,215,1695711600"; 
   d="scan'208";a="458246021"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2023 18:50:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10900"; a="832488431"
X-IronPort-AV: E=Sophos;i="6.04,215,1695711600"; 
   d="scan'208";a="832488431"
Received: from dpdk-yahui-icx1.sh.intel.com ([10.67.111.85])
  by fmsmga008.fm.intel.com with ESMTP; 20 Nov 2023 18:50:07 -0800
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
Subject: [PATCH iwl-next v4 06/12] ice: Add device state save/load function for migration
Date: Tue, 21 Nov 2023 02:51:05 +0000
Message-Id: <20231121025111.257597-7-yahui.cao@intel.com>
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

Add device state save/load function to adapter vfio migration stack
when device is in stop-copy/resume stage.

Device state saving handler is called by vfio driver in device stop copy
stage. It snapshots the device state, translates device state into device
specific data and fills the data into migration buffer.

Device state loading handler is called by vfio driver in device resume
stage. It gets device specific data from the migration buffer, translates
the data into the device state and recover the device with the state.

Currently only the virtual channel messages are handled.

Signed-off-by: Lingyu Liu <lingyu.liu@intel.com>
Signed-off-by: Yahui Cao <yahui.cao@intel.com>
---
 .../net/ethernet/intel/ice/ice_migration.c    | 226 ++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_virtchnl.c |  27 ++-
 drivers/net/ethernet/intel/ice/ice_virtchnl.h |   7 +-
 include/linux/net/intel/ice_migration.h       |  15 ++
 4 files changed, 266 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_migration.c b/drivers/net/ethernet/intel/ice/ice_migration.c
index 18ec4ec7d147..981aa92bbe86 100644
--- a/drivers/net/ethernet/intel/ice/ice_migration.c
+++ b/drivers/net/ethernet/intel/ice/ice_migration.c
@@ -3,6 +3,9 @@
 
 #include "ice.h"
 
+#define ICE_MIG_DEVSTAT_MAGIC			0xE8000001
+#define ICE_MIG_DEVSTAT_VERSION			0x1
+
 struct ice_migration_virtchnl_msg_slot {
 	u32 opcode;
 	u16 msg_len;
@@ -14,6 +17,17 @@ struct ice_migration_virtchnl_msg_listnode {
 	struct ice_migration_virtchnl_msg_slot msg_slot;
 };
 
+struct ice_migration_dev_state {
+	u32 magic;
+	u32 version;
+	u64 total_size;
+	u32 vf_caps;
+	u16 num_txq;
+	u16 num_rxq;
+
+	u8 virtchnl_msgs[];
+} __aligned(8);
+
 /**
  * ice_migration_get_pf - Get ice PF structure pointer by pdev
  * @pdev: pointer to ice vfio pci VF pdev structure
@@ -247,3 +261,215 @@ u32 ice_migration_supported_caps(void)
 {
 	return VIRTCHNL_VF_MIGRATION_SUPPORT_FEATURE;
 }
+
+/**
+ * ice_migration_save_devstate - save device state to migration buffer
+ * @pf: pointer to PF of migration device
+ * @vf_id: VF index of migration device
+ * @buf: pointer to VF msg in migration buffer
+ * @buf_sz: size of migration buffer
+ *
+ * Return 0 for success, negative for error
+ */
+int
+ice_migration_save_devstate(struct ice_pf *pf, int vf_id, u8 *buf, u64 buf_sz)
+{
+	struct ice_migration_virtchnl_msg_listnode *msg_listnode;
+	struct ice_migration_virtchnl_msg_slot *dummy_op;
+	struct ice_migration_dev_state *devstate;
+	struct device *dev = ice_pf_to_dev(pf);
+	struct ice_vsi *vsi;
+	struct ice_vf *vf;
+	u64 total_sz;
+	int ret = 0;
+
+	vf = ice_get_vf_by_id(pf, vf_id);
+	if (!vf) {
+		dev_err(dev, "Unable to locate VF from VF ID%d\n", vf_id);
+		return -EINVAL;
+	}
+
+	vsi = ice_get_vf_vsi(vf);
+	if (!vsi) {
+		dev_err(dev, "VF %d VSI is NULL\n", vf->vf_id);
+		ret = -EINVAL;
+		goto out_put_vf;
+	}
+
+	/* Reserve space to store device state */
+	total_sz = sizeof(struct ice_migration_dev_state) +
+			vf->virtchnl_msg_size + sizeof(*dummy_op);
+	if (total_sz > buf_sz) {
+		dev_err(dev, "Insufficient buffer to store device state for VF %d\n",
+			vf->vf_id);
+		ret = -ENOBUFS;
+		goto out_put_vf;
+	}
+
+	devstate = (struct ice_migration_dev_state *)buf;
+	devstate->magic = ICE_MIG_DEVSTAT_MAGIC;
+	devstate->version = ICE_MIG_DEVSTAT_VERSION;
+	devstate->total_size = total_sz;
+	devstate->vf_caps = ice_migration_supported_caps();
+	devstate->num_txq = vsi->num_txq;
+	devstate->num_rxq = vsi->num_rxq;
+	buf = devstate->virtchnl_msgs;
+
+	list_for_each_entry(msg_listnode, &vf->virtchnl_msg_list, node) {
+		struct ice_migration_virtchnl_msg_slot *msg_slot;
+		u64 slot_size;
+
+		msg_slot = &msg_listnode->msg_slot;
+		slot_size = struct_size(msg_slot, msg_buffer,
+					msg_slot->msg_len);
+		dev_dbg(dev, "VF %d copy virtchnl message to migration buffer op: %d, len: %d\n",
+			vf->vf_id, msg_slot->opcode, msg_slot->msg_len);
+		memcpy(buf, msg_slot, slot_size);
+		buf += slot_size;
+	}
+
+	/* Use op code unknown to mark end of vc messages */
+	dummy_op = (struct ice_migration_virtchnl_msg_slot *)buf;
+	dummy_op->opcode = VIRTCHNL_OP_UNKNOWN;
+
+out_put_vf:
+	ice_put_vf(vf);
+	return ret;
+}
+EXPORT_SYMBOL(ice_migration_save_devstate);
+
+/**
+ * ice_migration_check_match - check if configuration is matched or not
+ * @vf: pointer to VF
+ * @buf: pointer to device state buffer
+ * @buf_sz: size of buffer
+ *
+ * Return 0 for success, negative for error
+ */
+static int
+ice_migration_check_match(struct ice_vf *vf, const u8 *buf, u64 buf_sz)
+{
+	u32 supported_caps = ice_migration_supported_caps();
+	struct device *dev = ice_pf_to_dev(vf->pf);
+	struct ice_migration_dev_state *devstate;
+	struct ice_vsi *vsi;
+
+	vsi = ice_get_vf_vsi(vf);
+	if (!vsi) {
+		dev_err(dev, "VF %d VSI is NULL\n", vf->vf_id);
+		return -EINVAL;
+	}
+
+	if (sizeof(struct ice_migration_dev_state) > buf_sz) {
+		dev_err(dev, "VF %d devstate header exceeds buffer size\n",
+			vf->vf_id);
+		return -EINVAL;
+	}
+
+	devstate = (struct ice_migration_dev_state *)buf;
+	if (devstate->magic != ICE_MIG_DEVSTAT_MAGIC) {
+		dev_err(dev, "VF %d devstate has invalid magic 0x%x\n",
+			vf->vf_id, devstate->magic);
+		return -EINVAL;
+	}
+
+	if (devstate->version != ICE_MIG_DEVSTAT_VERSION) {
+		dev_err(dev, "VF %d devstate has invalid version 0x%x\n",
+			vf->vf_id, devstate->version);
+		return -EINVAL;
+	}
+
+	if (devstate->num_txq != vsi->num_txq) {
+		dev_err(dev, "Failed to match VF %d tx queue number, request %d, support %d\n",
+			vf->vf_id, devstate->num_txq, vsi->num_txq);
+		return -EINVAL;
+	}
+
+	if (devstate->num_rxq != vsi->num_rxq) {
+		dev_err(dev, "Failed to match VF %d rx queue number, request %d, support %d\n",
+			vf->vf_id, devstate->num_rxq, vsi->num_rxq);
+		return -EINVAL;
+	}
+
+	if ((devstate->vf_caps & supported_caps) != devstate->vf_caps) {
+		dev_err(dev, "Failed to match VF %d caps, request 0x%x, support 0x%x\n",
+			vf->vf_id, devstate->vf_caps, supported_caps);
+		return -EINVAL;
+	}
+
+	if (devstate->total_size > buf_sz) {
+		dev_err(dev, "VF %d devstate exceeds buffer size\n",
+			vf->vf_id);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/**
+ * ice_migration_load_devstate - load device state at destination
+ * @pf: pointer to PF of migration device
+ * @vf_id: VF index of migration device
+ * @buf: pointer to device state buf in migration buffer
+ * @buf_sz: size of migration buffer
+ *
+ * This function uses the device state saved in migration buffer
+ * to load device state at destination VM
+ *
+ * Return 0 for success, negative for error
+ */
+int ice_migration_load_devstate(struct ice_pf *pf, int vf_id,
+				const u8 *buf, u64 buf_sz)
+{
+	struct ice_migration_virtchnl_msg_slot *msg_slot;
+	struct ice_migration_dev_state *devstate;
+	struct device *dev = ice_pf_to_dev(pf);
+	struct ice_vf *vf;
+	int ret = 0;
+
+	if (!buf)
+		return -EINVAL;
+
+	vf = ice_get_vf_by_id(pf, vf_id);
+	if (!vf) {
+		dev_err(dev, "Unable to locate VF from VF ID%d\n", vf_id);
+		return -EINVAL;
+	}
+
+	ret = ice_migration_check_match(vf, buf, buf_sz);
+	if (ret)
+		goto out_put_vf;
+
+	devstate = (struct ice_migration_dev_state *)buf;
+	msg_slot = (struct ice_migration_virtchnl_msg_slot *)
+			devstate->virtchnl_msgs;
+	set_bit(ICE_VF_STATE_REPLAYING_VC, vf->vf_states);
+
+	while (msg_slot->opcode != VIRTCHNL_OP_UNKNOWN) {
+		struct ice_rq_event_info event;
+		u64 slot_sz;
+
+		slot_sz = struct_size(msg_slot, msg_buffer, msg_slot->msg_len);
+		dev_dbg(dev, "VF %d replay virtchnl message op code: %d, msg len: %d\n",
+			vf->vf_id, msg_slot->opcode, msg_slot->msg_len);
+		event.desc.cookie_high = cpu_to_le32(msg_slot->opcode);
+		event.msg_len = msg_slot->msg_len;
+		event.desc.retval = cpu_to_le16(vf->vf_id);
+		event.msg_buf = (unsigned char *)msg_slot->msg_buffer;
+		ret = ice_vc_process_vf_msg(vf->pf, &event, NULL);
+		if (ret) {
+			dev_err(dev, "VF %d failed to replay virtchnl message op code: %d\n",
+				vf->vf_id, msg_slot->opcode);
+			goto out_clear_replay;
+		}
+		event.msg_buf = NULL;
+		msg_slot = (struct ice_migration_virtchnl_msg_slot *)
+					((char *)msg_slot + slot_sz);
+	}
+out_clear_replay:
+	clear_bit(ICE_VF_STATE_REPLAYING_VC, vf->vf_states);
+out_put_vf:
+	ice_put_vf(vf);
+	return ret;
+}
+EXPORT_SYMBOL(ice_migration_load_devstate);
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl.c b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
index 730eeaea8c89..54f441daa87e 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
@@ -3982,11 +3982,24 @@ ice_is_malicious_vf(struct ice_vf *vf, struct ice_mbx_data *mbxdata)
  * @event: pointer to the AQ event
  * @mbxdata: information used to detect VF attempting mailbox overflow
  *
- * called from the common asq/arq handler to
- * process request from VF
+ * This function will be called from:
+ * 1. the common asq/arq handler to process request from VF
+ *
+ *    The return value is ignored, as the command handler will send the status
+ *    of the request as a response to the VF. This flow sets the mbxdata to
+ *    a non-NULL value and must call ice_is_malicious_vf to determine if this
+ *    VF might be attempting to overflow the PF message queue.
+ *
+ * 2. replay virtual channel commamds during live migration
+ *
+ *    The return value is used to indicate failure to replay vc commands and
+ *    that the migration failed. This flow sets mbxdata to NULL and skips the
+ *    ice_is_malicious_vf checks which are unnecessary during replay.
+ *
+ * Return 0 if success, negative for failure.
  */
-void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event,
-			   struct ice_mbx_data *mbxdata)
+int ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event,
+			  struct ice_mbx_data *mbxdata)
 {
 	u32 v_opcode = le32_to_cpu(event->desc.cookie_high);
 	s16 vf_id = le16_to_cpu(event->desc.retval);
@@ -4003,13 +4016,14 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event,
 	if (!vf) {
 		dev_err(dev, "Unable to locate VF for message from VF ID %d, opcode %d, len %d\n",
 			vf_id, v_opcode, msglen);
-		return;
+		return -EINVAL;
 	}
 
 	mutex_lock(&vf->cfg_lock);
 
 	/* Check if the VF is trying to overflow the mailbox */
-	if (ice_is_malicious_vf(vf, mbxdata))
+	if (!test_bit(ICE_VF_STATE_REPLAYING_VC, vf->vf_states) &&
+	    ice_is_malicious_vf(vf, mbxdata))
 		goto finish;
 
 	/* Check if VF is disabled. */
@@ -4190,4 +4204,5 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event,
 finish:
 	mutex_unlock(&vf->cfg_lock);
 	ice_put_vf(vf);
+	return err;
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl.h b/drivers/net/ethernet/intel/ice/ice_virtchnl.h
index a2b6094e2f2f..4b151a228c52 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl.h
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.h
@@ -63,8 +63,8 @@ int
 ice_vc_respond_to_vf(struct ice_vf *vf, u32 v_opcode,
 		     enum virtchnl_status_code v_retval, u8 *msg, u16 msglen);
 bool ice_vc_isvalid_vsi_id(struct ice_vf *vf, u16 vsi_id);
-void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event,
-			   struct ice_mbx_data *mbxdata);
+int ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event,
+			  struct ice_mbx_data *mbxdata);
 #else /* CONFIG_PCI_IOV */
 static inline void ice_virtchnl_set_dflt_ops(struct ice_vf *vf) { }
 static inline void ice_virtchnl_set_repr_ops(struct ice_vf *vf) { }
@@ -84,10 +84,11 @@ static inline bool ice_vc_isvalid_vsi_id(struct ice_vf *vf, u16 vsi_id)
 	return false;
 }
 
-static inline void
+static inline int
 ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event,
 		      struct ice_mbx_data *mbxdata)
 {
+	return -EOPNOTSUPP;
 }
 #endif /* !CONFIG_PCI_IOV */
 
diff --git a/include/linux/net/intel/ice_migration.h b/include/linux/net/intel/ice_migration.h
index 7ea11a8714d6..a142b78283a8 100644
--- a/include/linux/net/intel/ice_migration.h
+++ b/include/linux/net/intel/ice_migration.h
@@ -10,6 +10,10 @@ struct ice_pf;
 struct ice_pf *ice_migration_get_pf(struct pci_dev *pdev);
 int ice_migration_init_dev(struct ice_pf *pf, int vf_id);
 void ice_migration_uninit_dev(struct ice_pf *pf, int vf_id);
+int ice_migration_save_devstate(struct ice_pf *pf, int vf_id,
+				u8 *buf, u64 buf_sz);
+int ice_migration_load_devstate(struct ice_pf *pf, int vf_id,
+				const u8 *buf, u64 buf_sz);
 #else
 static inline struct ice_pf *ice_migration_get_pf(struct pci_dev *pdev)
 {
@@ -22,6 +26,17 @@ static inline int ice_migration_init_dev(struct ice_pf *pf, int vf_id)
 }
 
 static inline void ice_migration_uninit_dev(struct ice_pf *pf, int vf_id) { }
+static inline int
+ice_migration_save_devstate(struct ice_pf *pf, int vf_id, u8 *buf, u64 buf_sz)
+{
+	return 0;
+}
+
+static inline int ice_migration_load_devstate(struct ice_pf *pf, int vf_id,
+					      const u8 *buf, u64 buf_sz)
+{
+	return 0;
+}
 #endif /* CONFIG_ICE_VFIO_PCI */
 
 #endif /* _ICE_MIGRATION_H_ */
-- 
2.34.1


