Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 473037A4122
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 08:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239921AbjIRG3C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 02:29:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239932AbjIRG2b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 02:28:31 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C661121;
        Sun, 17 Sep 2023 23:28:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695018502; x=1726554502;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gHkw4vGUJtBw/7w1jzwy2EEnGCfkD2i3C5CgZi2TvcI=;
  b=C/bx5V4UzqtiNXYqxiLrBuFckqQklpezeaiKCrD9vEtyY1WXrM1A20jM
   JxihWROgc9SVRDzS5Na4oGLBXT6hFlCNpi2dRc5ysUHSZAOZZVR6cJkWl
   mVWZkFdq+biWoBPcGy3tKQc21h5kM4f6qMVgg3CdXZloV7r/Sp1TCm7Fk
   MfEp/RK9TG4XDxT2ZGFUvtDhB55XPcnsNhyJ8tnnkDQh+IDycChHwynY4
   F9rnMDnLYS0BB4eBqOD1DEKjhyRER/0lDGPcK7ZPESkv8qMtr6knfLslV
   iVX+qysXeTIPKXSGwxWwcEaQ0XTwnBCszpP340yKmzTsLpRChrGMUb1/e
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10836"; a="378488565"
X-IronPort-AV: E=Sophos;i="6.02,155,1688454000"; 
   d="scan'208";a="378488565"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2023 23:28:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10836"; a="815893505"
X-IronPort-AV: E=Sophos;i="6.02,155,1688454000"; 
   d="scan'208";a="815893505"
Received: from dpdk-yahui-icx1.sh.intel.com ([10.67.111.186])
  by fmsmga004.fm.intel.com with ESMTP; 17 Sep 2023 23:28:16 -0700
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
Subject: [PATCH iwl-next v3 06/13] ice: Log virtual channel messages in PF
Date:   Mon, 18 Sep 2023 06:25:39 +0000
Message-Id: <20230918062546.40419-7-yahui.cao@intel.com>
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

From: Lingyu Liu <lingyu.liu@intel.com>

Save the virtual channel messages sent by VF on the source side during
runtime. The logged virtchnl messages will be transferred and loaded
into the device on the destination side during the device resume stage.

For the feature which can not be migrated yet, it must be disabled or
blocked to prevent from being abused by VF. Otherwise, it may introduce
functional and security issue. Mask unsupported VF capability flags in
the VF-PF negotiaion stage.

Signed-off-by: Lingyu Liu <lingyu.liu@intel.com>
Signed-off-by: Yahui Cao <yahui.cao@intel.com>
---
 .../net/ethernet/intel/ice/ice_migration.c    | 167 ++++++++++++++++++
 .../intel/ice/ice_migration_private.h         |  12 ++
 drivers/net/ethernet/intel/ice/ice_vf_lib.h   |   5 +
 drivers/net/ethernet/intel/ice/ice_virtchnl.c |  29 +++
 4 files changed, 213 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_migration.c b/drivers/net/ethernet/intel/ice/ice_migration.c
index bd2248765750..88ec0653a1ce 100644
--- a/drivers/net/ethernet/intel/ice/ice_migration.c
+++ b/drivers/net/ethernet/intel/ice/ice_migration.c
@@ -3,6 +3,17 @@
 
 #include "ice.h"
 
+struct ice_migration_virtchnl_msg_slot {
+	u32 opcode;
+	u16 msg_len;
+	char msg_buffer[];
+};
+
+struct ice_migration_virtchnl_msg_listnode {
+	struct list_head node;
+	struct ice_migration_virtchnl_msg_slot msg_slot;
+};
+
 /**
  * ice_migration_get_pf - Get ice PF structure pointer by pdev
  * @pdev: pointer to ice vfio pci VF pdev structure
@@ -22,6 +33,9 @@ EXPORT_SYMBOL(ice_migration_get_pf);
 void ice_migration_init_vf(struct ice_vf *vf)
 {
 	vf->migration_enabled = true;
+	INIT_LIST_HEAD(&vf->virtchnl_msg_list);
+	vf->virtchnl_msg_num = 0;
+	vf->virtchnl_msg_size = 0;
 }
 
 /**
@@ -30,10 +44,24 @@ void ice_migration_init_vf(struct ice_vf *vf)
  */
 void ice_migration_uninit_vf(struct ice_vf *vf)
 {
+	struct ice_migration_virtchnl_msg_listnode *msg_listnode;
+	struct ice_migration_virtchnl_msg_listnode *dtmp;
+
 	if (!vf->migration_enabled)
 		return;
 
 	vf->migration_enabled = false;
+
+	if (list_empty(&vf->virtchnl_msg_list))
+		return;
+	list_for_each_entry_safe(msg_listnode, dtmp,
+				 &vf->virtchnl_msg_list,
+				 node) {
+		list_del(&msg_listnode->node);
+		kfree(msg_listnode);
+	}
+	vf->virtchnl_msg_num = 0;
+	vf->virtchnl_msg_size = 0;
 }
 
 /**
@@ -81,3 +109,142 @@ void ice_migration_uninit_dev(struct ice_pf *pf, int vf_id)
 	ice_put_vf(vf);
 }
 EXPORT_SYMBOL(ice_migration_uninit_dev);
+
+/**
+ * ice_migration_is_loggable_msg - is this message loggable or not
+ * @v_opcode: virtchnl message operation code
+ *
+ * Return 1 for true, return 0 for false
+ */
+static inline int ice_migration_is_loggable_msg(u32 v_opcode)
+{
+	switch (v_opcode) {
+	case VIRTCHNL_OP_VERSION:
+	case VIRTCHNL_OP_GET_VF_RESOURCES:
+	case VIRTCHNL_OP_CONFIG_VSI_QUEUES:
+	case VIRTCHNL_OP_CONFIG_IRQ_MAP:
+	case VIRTCHNL_OP_ADD_ETH_ADDR:
+	case VIRTCHNL_OP_DEL_ETH_ADDR:
+	case VIRTCHNL_OP_CONFIG_PROMISCUOUS_MODE:
+	case VIRTCHNL_OP_ENABLE_QUEUES:
+	case VIRTCHNL_OP_DISABLE_QUEUES:
+	case VIRTCHNL_OP_ADD_VLAN:
+	case VIRTCHNL_OP_DEL_VLAN:
+	case VIRTCHNL_OP_ENABLE_VLAN_STRIPPING:
+	case VIRTCHNL_OP_DISABLE_VLAN_STRIPPING:
+	case VIRTCHNL_OP_CONFIG_RSS_KEY:
+	case VIRTCHNL_OP_CONFIG_RSS_LUT:
+	case VIRTCHNL_OP_GET_SUPPORTED_RXDIDS:
+		return 1;
+	default:
+		return 0;
+	}
+}
+
+/**
+ * ice_migration_log_vf_msg - Log request message from VF
+ * @vf: pointer to the VF structure
+ * @event: pointer to the AQ event
+ *
+ * Log VF message for later restore during live migration
+ *
+ * Return 0 for success, negative for error
+ */
+int ice_migration_log_vf_msg(struct ice_vf *vf,
+			     struct ice_rq_event_info *event)
+{
+	struct ice_migration_virtchnl_msg_listnode *msg_listnode;
+	u32 v_opcode = le32_to_cpu(event->desc.cookie_high);
+	struct device *dev = ice_pf_to_dev(vf->pf);
+	u16 msglen = event->msg_len;
+	u8 *msg = event->msg_buf;
+
+	if (!ice_migration_is_loggable_msg(v_opcode))
+		return 0;
+
+	if (vf->virtchnl_msg_num >= VIRTCHNL_MSG_MAX) {
+		dev_warn(dev, "VF %d has maximum number virtual channel commands\n",
+			 vf->vf_id);
+		return -ENOMEM;
+	}
+
+	msg_listnode = (struct ice_migration_virtchnl_msg_listnode *)
+			kzalloc(struct_size(msg_listnode,
+					    msg_slot.msg_buffer,
+					    msglen),
+				GFP_KERNEL);
+	if (!msg_listnode) {
+		dev_err(dev, "VF %d failed to allocate memory for msg listnode\n",
+			vf->vf_id);
+		return -ENOMEM;
+	}
+	dev_dbg(dev, "VF %d save virtual channel command, op code: %d, len: %d\n",
+		vf->vf_id, v_opcode, msglen);
+	msg_listnode->msg_slot.opcode = v_opcode;
+	msg_listnode->msg_slot.msg_len = msglen;
+	memcpy(msg_listnode->msg_slot.msg_buffer, msg, msglen);
+	list_add_tail(&msg_listnode->node, &vf->virtchnl_msg_list);
+	vf->virtchnl_msg_num++;
+	vf->virtchnl_msg_size += struct_size(&msg_listnode->msg_slot,
+					     msg_buffer,
+					     msglen);
+	return 0;
+}
+
+/**
+ * ice_migration_unlog_vf_msg - revert logged message
+ * @vf: pointer to the VF structure
+ * @v_opcode: virtchnl message operation code
+ *
+ * Remove the virtual channel message logged by ice_migration_log_vf_msg()
+ * before.
+ */
+void ice_migration_unlog_vf_msg(struct ice_vf *vf, u32 v_opcode)
+{
+	struct ice_migration_virtchnl_msg_listnode *msg_listnode;
+
+	if (!ice_migration_is_loggable_msg(v_opcode))
+		return;
+
+	if (WARN_ON_ONCE(list_empty(&vf->virtchnl_msg_list)))
+		return;
+
+	msg_listnode = list_last_entry(&vf->virtchnl_msg_list,
+				       struct ice_migration_virtchnl_msg_listnode,
+				       node);
+	if (WARN_ON_ONCE(msg_listnode->msg_slot.opcode != v_opcode))
+		return;
+
+	list_del(&msg_listnode->node);
+	kfree(msg_listnode);
+	vf->virtchnl_msg_num--;
+	vf->virtchnl_msg_size -= struct_size(&msg_listnode->msg_slot,
+					     msg_buffer,
+					     msg_listnode->msg_slot.msg_len);
+}
+
+#define VIRTCHNL_VF_MIGRATION_SUPPORT_FEATURE \
+				(VIRTCHNL_VF_OFFLOAD_L2 | \
+				 VIRTCHNL_VF_OFFLOAD_RSS_PF | \
+				 VIRTCHNL_VF_OFFLOAD_RSS_AQ | \
+				 VIRTCHNL_VF_OFFLOAD_RSS_REG | \
+				 VIRTCHNL_VF_OFFLOAD_RSS_PCTYPE_V2 | \
+				 VIRTCHNL_VF_OFFLOAD_ENCAP | \
+				 VIRTCHNL_VF_OFFLOAD_ENCAP_CSUM | \
+				 VIRTCHNL_VF_OFFLOAD_RX_POLLING | \
+				 VIRTCHNL_VF_OFFLOAD_WB_ON_ITR | \
+				 VIRTCHNL_VF_CAP_ADV_LINK_SPEED | \
+				 VIRTCHNL_VF_OFFLOAD_VLAN | \
+				 VIRTCHNL_VF_OFFLOAD_RX_FLEX_DESC | \
+				 VIRTCHNL_VF_OFFLOAD_USO)
+
+/**
+ * ice_migration_supported_caps - get migration supported VF capabilities
+ *
+ * When migration is activated, some VF capabilities are not supported.
+ * So unmask those capability flags for VF resources.
+ */
+u32 ice_migration_supported_caps(void)
+{
+	return VIRTCHNL_VF_MIGRATION_SUPPORT_FEATURE;
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_migration_private.h b/drivers/net/ethernet/intel/ice/ice_migration_private.h
index 2cc2f515fc5e..678ae361cf0c 100644
--- a/drivers/net/ethernet/intel/ice/ice_migration_private.h
+++ b/drivers/net/ethernet/intel/ice/ice_migration_private.h
@@ -13,9 +13,21 @@
 #if IS_ENABLED(CONFIG_ICE_VFIO_PCI)
 void ice_migration_init_vf(struct ice_vf *vf);
 void ice_migration_uninit_vf(struct ice_vf *vf);
+int ice_migration_log_vf_msg(struct ice_vf *vf,
+			     struct ice_rq_event_info *event);
+void ice_migration_unlog_vf_msg(struct ice_vf *vf, u32 v_opcode);
+u32 ice_migration_supported_caps(void);
 #else
 static inline void ice_migration_init_vf(struct ice_vf *vf) { }
 static inline void ice_migration_uninit_vf(struct ice_vf *vf) { }
+static inline void
+ice_migration_save_vf_msg(struct ice_vf *vf,
+			  struct ice_rq_event_info *event) { }
+static inline u32
+ice_migration_supported_caps(void)
+{
+	return 0xFFFFFFFF;
+}
 #endif /* CONFIG_ICE_VFIO_PCI */
 
 #endif /* _ICE_MIGRATION_PRIVATE_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.h b/drivers/net/ethernet/intel/ice/ice_vf_lib.h
index 351568d786a2..011398655739 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.h
@@ -77,6 +77,7 @@ struct ice_vfs {
 	unsigned long last_printed_mdd_jiffies;	/* MDD message rate limit */
 };
 
+#define VIRTCHNL_MSG_MAX 1000
 /* VF information structure */
 struct ice_vf {
 	struct hlist_node entry;
@@ -138,6 +139,10 @@ struct ice_vf {
 	/* devlink port data */
 	struct devlink_port devlink_port;
 	bool migration_enabled;
+	struct list_head virtchnl_msg_list;
+	u64 virtchnl_msg_num;
+	u64 virtchnl_msg_size;
+	u32 virtchnl_retval;
 };
 
 /* Flags for controlling behavior of ice_reset_vf */
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl.c b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
index 6be796ed70a8..b40e91958f0d 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
@@ -338,6 +338,12 @@ ice_vc_respond_to_vf(struct ice_vf *vf, u32 v_opcode,
 		return -EIO;
 	}
 
+	/* v_retval will not be returned in this function, store it in the
+	 * per VF field to be used by migration logging logic later.
+	 */
+	if (vf->migration_enabled)
+		vf->virtchnl_retval = v_retval;
+
 	return ice_vc_send_response_to_vf(vf, v_opcode, v_retval, msg, msglen);
 }
 
@@ -470,6 +476,8 @@ static int ice_vc_get_vf_res_msg(struct ice_vf *vf, u8 *msg)
 				  VIRTCHNL_VF_OFFLOAD_RSS_REG |
 				  VIRTCHNL_VF_OFFLOAD_VLAN;
 
+	if (vf->migration_enabled)
+		vf->driver_caps &= ice_migration_supported_caps();
 	vfres->vf_cap_flags = VIRTCHNL_VF_OFFLOAD_L2;
 	vsi = ice_get_vf_vsi(vf);
 	if (!vsi) {
@@ -4026,6 +4034,15 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event,
 		goto finish;
 	}
 
+	if (vf->migration_enabled) {
+		if (ice_migration_log_vf_msg(vf, event)) {
+			err = ice_vc_respond_to_vf(vf, v_opcode,
+						   VIRTCHNL_STATUS_ERR_NO_MEMORY,
+						   NULL, 0);
+			goto finish;
+		}
+	}
+
 	switch (v_opcode) {
 	case VIRTCHNL_OP_VERSION:
 		err = ops->get_ver_msg(vf, msg);
@@ -4145,6 +4162,18 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event,
 			 vf_id, v_opcode, err);
 	}
 
+	/* All of the loggable virtual channel messages are logged by
+	 * ice_migration_unlog_vf_msg() before they are processed.
+	 *
+	 * Two kinds of error may happen, virtual channel message's result
+	 * is failure after processed by PF or message is not sent to VF
+	 * successfully. If error happened, fallback here by reverting logged
+	 * messages.
+	 */
+	if (vf->migration_enabled &&
+	    (vf->virtchnl_retval != VIRTCHNL_STATUS_SUCCESS || err))
+		ice_migration_unlog_vf_msg(vf, v_opcode);
+
 finish:
 	mutex_unlock(&vf->cfg_lock);
 	ice_put_vf(vf);
-- 
2.34.1

