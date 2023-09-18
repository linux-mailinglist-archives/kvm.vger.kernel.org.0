Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6117A4125
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 08:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239963AbjIRG3G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 02:29:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239982AbjIRG2p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 02:28:45 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1201124;
        Sun, 17 Sep 2023 23:28:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695018516; x=1726554516;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MNy2PcBWRzbTHueI2ijmsawCjISW9Er1KUb7rCXIUh4=;
  b=nufCblSpV6F9XwAIb96kLwB3p98M09iAE9wNrSB4DRLg/IO6GNJVqANt
   97YXN89Ft932N1O+gOakunTB9jL4FpfGOlq/YLOQPyR5pJJnUuyzcN9B/
   8XlnlXfXn3gcVfXJk62iNhqTzjTK8Ertj+F4bRUXVh4ksZV8BYq4mZ3tp
   B0cNwd/pw8ZV2n145n7CJP7Pd8+x9zgXKWInZ+IxFtdyBs532rpdEg2oY
   923fBgXLl+D3gOrPo1BWObrDCzftqe8NSYYgaXpWsn5QcAofoeoDF3POj
   Gu6pyzO5GYxigCYXMDWD1jNX5InwW66OLe3GHLjuPlMoRT4/ZMA3oleEa
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10836"; a="378488618"
X-IronPort-AV: E=Sophos;i="6.02,155,1688454000"; 
   d="scan'208";a="378488618"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2023 23:28:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10836"; a="815893586"
X-IronPort-AV: E=Sophos;i="6.02,155,1688454000"; 
   d="scan'208";a="815893586"
Received: from dpdk-yahui-icx1.sh.intel.com ([10.67.111.186])
  by fmsmga004.fm.intel.com with ESMTP; 17 Sep 2023 23:28:31 -0700
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
Subject: [PATCH iwl-next v3 09/13] ice: Save and restore RX Queue head
Date:   Mon, 18 Sep 2023 06:25:42 +0000
Message-Id: <20230918062546.40419-10-yahui.cao@intel.com>
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

RX Queue head is a fundamental dma ring context which determines the
next RX descriptor to be fetched. However, RX Queue head is not visible
to VF while it is only visible in PF. As a result, PF needs to save and
restore RX Queue Head explicitly.

Since network packets may come in at any time once RX Queue is enabled,
RX Queue head needs to be restored before Queue is enabled.

RX Queue head restoring handler is implemented by reading and then
overwriting queue context with specific HEAD value.

Signed-off-by: Lingyu Liu <lingyu.liu@intel.com>
Signed-off-by: Yahui Cao <yahui.cao@intel.com>
---
 .../net/ethernet/intel/ice/ice_migration.c    | 125 ++++++++++++++++++
 1 file changed, 125 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_migration.c b/drivers/net/ethernet/intel/ice/ice_migration.c
index 99faf9acff13..34cfc58ed525 100644
--- a/drivers/net/ethernet/intel/ice/ice_migration.c
+++ b/drivers/net/ethernet/intel/ice/ice_migration.c
@@ -2,9 +2,11 @@
 /* Copyright (C) 2018-2023 Intel Corporation */
 
 #include "ice.h"
+#include "ice_base.h"
 
 #define ICE_MIG_DEVSTAT_MAGIC			0xE8000001
 #define ICE_MIG_DEVSTAT_VERSION			0x1
+#define ICE_MIG_VF_QRX_TAIL_MAX			256
 
 struct ice_migration_virtchnl_msg_slot {
 	u32 opcode;
@@ -26,6 +28,8 @@ struct ice_migration_dev_state {
 	u16 num_rxq;
 
 	u16 vsi_id;
+	/* next RX desc index to be processed by the device */
+	u16 rx_head[ICE_MIG_VF_QRX_TAIL_MAX];
 	u8 virtchnl_msgs[];
 } __aligned(8);
 
@@ -265,6 +269,54 @@ u32 ice_migration_supported_caps(void)
 	return VIRTCHNL_VF_MIGRATION_SUPPORT_FEATURE;
 }
 
+/**
+ * ice_migration_save_rx_head - save rx head into device state buffer
+ * @vf: pointer to VF structure
+ * @devstate: pointer to migration buffer
+ *
+ * Return 0 for success, negative for error
+ */
+static int
+ice_migration_save_rx_head(struct ice_vf *vf,
+			   struct ice_migration_dev_state *devstate)
+{
+	struct device *dev = ice_pf_to_dev(vf->pf);
+	struct ice_vsi *vsi;
+	int i;
+
+	vsi = ice_get_vf_vsi(vf);
+	if (!vsi) {
+		dev_err(dev, "VF %d VSI is NULL\n", vf->vf_id);
+		return -EINVAL;
+	}
+
+	ice_for_each_rxq(vsi, i) {
+		struct ice_rx_ring *rx_ring = vsi->rx_rings[i];
+		struct ice_rlan_ctx rlan_ctx = {};
+		struct ice_hw *hw = &vf->pf->hw;
+		u16 rxq_index;
+		int status;
+
+		if (WARN_ON_ONCE(!rx_ring))
+			return -EINVAL;
+
+		devstate->rx_head[i] = 0;
+		if (!test_bit(i, vf->rxq_ena))
+			continue;
+
+		rxq_index = rx_ring->reg_idx;
+		status = ice_read_rxq_ctx(hw, &rlan_ctx, rxq_index);
+		if (status) {
+			dev_err(dev, "Failed to read RXQ[%d] context, err=%d\n",
+				rx_ring->q_index, status);
+			return -EIO;
+		}
+		devstate->rx_head[i] = rlan_ctx.head;
+	}
+
+	return 0;
+}
+
 /**
  * ice_migration_save_devstate - save device state to migration buffer
  * @pf: pointer to PF of migration device
@@ -318,6 +370,12 @@ int ice_migration_save_devstate(struct ice_pf *pf, int vf_id, u8 *buf, u64 buf_s
 	buf = devstate->virtchnl_msgs;
 	devstate->vsi_id = vf->vm_vsi_num;
 
+	ret = ice_migration_save_rx_head(vf, devstate);
+	if (ret) {
+		dev_err(dev, "VF %d failed to save rxq head\n", vf->vf_id);
+		goto out_put_vf;
+	}
+
 	list_for_each_entry(msg_listnode, &vf->virtchnl_msg_list, node) {
 		struct ice_migration_virtchnl_msg_slot *msg_slot;
 		u64 slot_size;
@@ -408,6 +466,57 @@ static int ice_migration_check_match(struct ice_vf *vf, const u8 *buf, u64 buf_s
 	return 0;
 }
 
+/**
+ * ice_migration_restore_rx_head - restore rx head from device state buffer
+ * @vf: pointer to VF structure
+ * @devstate: pointer to migration device state
+ *
+ * Return 0 for success, negative for error
+ */
+static int
+ice_migration_restore_rx_head(struct ice_vf *vf,
+			      struct ice_migration_dev_state *devstate)
+{
+	struct device *dev = ice_pf_to_dev(vf->pf);
+	struct ice_vsi *vsi;
+	int i;
+
+	vsi = ice_get_vf_vsi(vf);
+	if (!vsi) {
+		dev_err(dev, "VF %d VSI is NULL\n", vf->vf_id);
+		return -EINVAL;
+	}
+
+	ice_for_each_rxq(vsi, i) {
+		struct ice_rx_ring *rx_ring = vsi->rx_rings[i];
+		struct ice_rlan_ctx rlan_ctx = {};
+		struct ice_hw *hw = &vf->pf->hw;
+		u16 rxq_index;
+		int status;
+
+		if (WARN_ON_ONCE(!rx_ring))
+			return -EINVAL;
+
+		rxq_index = rx_ring->reg_idx;
+		status = ice_read_rxq_ctx(hw, &rlan_ctx, rxq_index);
+		if (status) {
+			dev_err(dev, "Failed to read RXQ[%d] context, err=%d\n",
+				rx_ring->q_index, status);
+			return -EIO;
+		}
+
+		rlan_ctx.head = devstate->rx_head[i];
+		status = ice_write_rxq_ctx(hw, &rlan_ctx, rxq_index);
+		if (status) {
+			dev_err(dev, "Failed to set LAN RXQ[%d] context, err=%d\n",
+				rx_ring->q_index, status);
+			return -EIO;
+		}
+	}
+
+	return 0;
+}
+
 /**
  * ice_migration_restore_devstate - restore device state at dst
  * @pf: pointer to PF of migration device
@@ -464,6 +573,22 @@ int ice_migration_restore_devstate(struct ice_pf *pf, int vf_id, const u8 *buf,
 				vf->vf_id, msg_slot->opcode);
 			goto out_clear_replay;
 		}
+
+		/* Once RX Queue is enabled, network traffic may come in at any
+		 * time. As a result, RX Queue head needs to be restored before
+		 * RX Queue is enabled.
+		 * For simplicity and integration, overwrite RX head just after
+		 * RX ring context is configured.
+		 */
+		if (msg_slot->opcode == VIRTCHNL_OP_CONFIG_VSI_QUEUES) {
+			ret = ice_migration_restore_rx_head(vf, devstate);
+			if (ret) {
+				dev_err(dev, "VF %d failed to restore rx head\n",
+					vf->vf_id);
+				goto out_clear_replay;
+			}
+		}
+
 		event.msg_buf = NULL;
 		msg_slot = (struct ice_migration_virtchnl_msg_slot *)
 					((char *)msg_slot + slot_sz);
-- 
2.34.1

