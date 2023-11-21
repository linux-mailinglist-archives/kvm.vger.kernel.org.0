Return-Path: <kvm+bounces-2144-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7942D7F2447
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 03:50:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 98F081C2190C
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 02:50:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E67841549B;
	Tue, 21 Nov 2023 02:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GjoMWj+B"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25114C4;
	Mon, 20 Nov 2023 18:50:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700535019; x=1732071019;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BBsmOnVexqUZSEHq9zjpJKeRotCf46aFcR8ZgegU6Gg=;
  b=GjoMWj+BZuJHP5o355X4D34ARcBwLa6sXstGAFXF+XoxYiMBLgUITiAw
   t4UwQxpLOb6vr2wQThIO1re3zNd+liR465MJVf1NvAJBStB9CQSLmP+DS
   biXSplZpjXByT1xw3afyQZ2wwktv4fGQm9YT3L2zSvUCgfzLUpXBzO2Fj
   2UvFQvl0DqrOtSJtVwF3TAdZ+4OK8HDLKnYHmPpULv9X8oB1MaBwn41nV
   K0FwvoJAZUZNzw2KbMmOU444q2oIWs9wQv88vNt9AKxFtvgHQ+NR9+1h+
   61akBLumZT4aKz6zQg8ND+EEg9JQD5fIvbmCM2Kd0e1BpAuom28oNZd7A
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10900"; a="458245899"
X-IronPort-AV: E=Sophos;i="6.04,215,1695711600"; 
   d="scan'208";a="458245899"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2023 18:49:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10900"; a="832488276"
X-IronPort-AV: E=Sophos;i="6.04,215,1695711600"; 
   d="scan'208";a="832488276"
Received: from dpdk-yahui-icx1.sh.intel.com ([10.67.111.85])
  by fmsmga008.fm.intel.com with ESMTP; 20 Nov 2023 18:49:54 -0800
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
Subject: [PATCH iwl-next v4 03/12] ice: Introduce VF state ICE_VF_STATE_REPLAYING_VC for migration
Date: Tue, 21 Nov 2023 02:51:02 +0000
Message-Id: <20231121025111.257597-4-yahui.cao@intel.com>
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

During migration device resume stage, part of device state is loaded by
replaying logged virtual channel message. By default, once virtual
channel message is processed successfully, PF will send message to VF.

In addition, PF will notify VF about link state while handling virtual
channel message GET_VF_RESOURCE and ENABLE_QUEUES. And VF driver will
print link state change info once receiving notification from PF.

However, device resume stage does not need PF to send messages to VF
for the above cases. Stop PF from sending messages to VF while VF is
in replay state.

Signed-off-by: Lingyu Liu <lingyu.liu@intel.com>
Signed-off-by: Yahui Cao <yahui.cao@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_vf_lib.h   |   1 +
 drivers/net/ethernet/intel/ice/ice_virtchnl.c | 179 +++++++++++-------
 drivers/net/ethernet/intel/ice/ice_virtchnl.h |   8 +-
 .../ethernet/intel/ice/ice_virtchnl_fdir.c    |  28 +--
 4 files changed, 127 insertions(+), 89 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.h b/drivers/net/ethernet/intel/ice/ice_vf_lib.h
index 93c774f2f437..c7e7df7baf38 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.h
@@ -37,6 +37,7 @@ enum ice_vf_states {
 	ICE_VF_STATE_DIS,
 	ICE_VF_STATE_MC_PROMISC,
 	ICE_VF_STATE_UC_PROMISC,
+	ICE_VF_STATE_REPLAYING_VC,
 	ICE_VF_STATES_NBITS
 };
 
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl.c b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
index cdf17b1e2f25..661ca86c3032 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
@@ -233,6 +233,9 @@ void ice_vc_notify_vf_link_state(struct ice_vf *vf)
 	struct virtchnl_pf_event pfe = { 0 };
 	struct ice_hw *hw = &vf->pf->hw;
 
+	if (test_bit(ICE_VF_STATE_REPLAYING_VC, vf->vf_states))
+		return;
+
 	pfe.event = VIRTCHNL_EVENT_LINK_CHANGE;
 	pfe.severity = PF_EVENT_SEVERITY_INFO;
 
@@ -282,7 +285,7 @@ void ice_vc_notify_reset(struct ice_pf *pf)
 }
 
 /**
- * ice_vc_send_msg_to_vf - Send message to VF
+ * ice_vc_send_response_to_vf - Send response message to VF
  * @vf: pointer to the VF info
  * @v_opcode: virtual channel opcode
  * @v_retval: virtual channel return value
@@ -291,9 +294,10 @@ void ice_vc_notify_reset(struct ice_pf *pf)
  *
  * send msg to VF
  */
-int
-ice_vc_send_msg_to_vf(struct ice_vf *vf, u32 v_opcode,
-		      enum virtchnl_status_code v_retval, u8 *msg, u16 msglen)
+static int
+ice_vc_send_response_to_vf(struct ice_vf *vf, u32 v_opcode,
+			   enum virtchnl_status_code v_retval,
+			   u8 *msg, u16 msglen)
 {
 	struct device *dev;
 	struct ice_pf *pf;
@@ -314,6 +318,39 @@ ice_vc_send_msg_to_vf(struct ice_vf *vf, u32 v_opcode,
 	return 0;
 }
 
+/**
+ * ice_vc_respond_to_vf - Respond to VF
+ * @vf: pointer to the VF info
+ * @v_opcode: virtual channel opcode
+ * @v_retval: virtual channel return value
+ * @msg: pointer to the msg buffer
+ * @msglen: msg length
+ *
+ * Respond to VF. If it is replaying, return directly.
+ *
+ * Return 0 for success, negative for error.
+ */
+int
+ice_vc_respond_to_vf(struct ice_vf *vf, u32 v_opcode,
+		     enum virtchnl_status_code v_retval, u8 *msg, u16 msglen)
+{
+	struct device *dev;
+	struct ice_pf *pf = vf->pf;
+
+	dev = ice_pf_to_dev(pf);
+
+	if (test_bit(ICE_VF_STATE_REPLAYING_VC, vf->vf_states)) {
+		if (v_retval == VIRTCHNL_STATUS_SUCCESS)
+			return 0;
+
+		dev_dbg(dev, "Unable to replay virt channel command, VF ID %d, virtchnl status code %d. op code %d, len %d.\n",
+			vf->vf_id, v_retval, v_opcode, msglen);
+		return -EIO;
+	}
+
+	return ice_vc_send_response_to_vf(vf, v_opcode, v_retval, msg, msglen);
+}
+
 /**
  * ice_vc_get_ver_msg
  * @vf: pointer to the VF info
@@ -332,9 +369,9 @@ static int ice_vc_get_ver_msg(struct ice_vf *vf, u8 *msg)
 	if (VF_IS_V10(&vf->vf_ver))
 		info.minor = VIRTCHNL_VERSION_MINOR_NO_VF_CAPS;
 
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_VERSION,
-				     VIRTCHNL_STATUS_SUCCESS, (u8 *)&info,
-				     sizeof(struct virtchnl_version_info));
+	return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_VERSION,
+				    VIRTCHNL_STATUS_SUCCESS, (u8 *)&info,
+				    sizeof(struct virtchnl_version_info));
 }
 
 /**
@@ -522,8 +559,8 @@ static int ice_vc_get_vf_res_msg(struct ice_vf *vf, u8 *msg)
 
 err:
 	/* send the response back to the VF */
-	ret = ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_GET_VF_RESOURCES, v_ret,
-				    (u8 *)vfres, len);
+	ret = ice_vc_respond_to_vf(vf, VIRTCHNL_OP_GET_VF_RESOURCES, v_ret,
+				   (u8 *)vfres, len);
 
 	kfree(vfres);
 	return ret;
@@ -892,7 +929,7 @@ static int ice_vc_handle_rss_cfg(struct ice_vf *vf, u8 *msg, bool add)
 	}
 
 error_param:
-	return ice_vc_send_msg_to_vf(vf, v_opcode, v_ret, NULL, 0);
+	return ice_vc_respond_to_vf(vf, v_opcode, v_ret, NULL, 0);
 }
 
 /**
@@ -938,8 +975,8 @@ static int ice_vc_config_rss_key(struct ice_vf *vf, u8 *msg)
 	if (ice_set_rss_key(vsi, vrk->key))
 		v_ret = VIRTCHNL_STATUS_ERR_ADMIN_QUEUE_ERROR;
 error_param:
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_CONFIG_RSS_KEY, v_ret,
-				     NULL, 0);
+	return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_CONFIG_RSS_KEY, v_ret,
+				    NULL, 0);
 }
 
 /**
@@ -984,7 +1021,7 @@ static int ice_vc_config_rss_lut(struct ice_vf *vf, u8 *msg)
 	if (ice_set_rss_lut(vsi, vrl->lut, ICE_LUT_VSI_SIZE))
 		v_ret = VIRTCHNL_STATUS_ERR_ADMIN_QUEUE_ERROR;
 error_param:
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_CONFIG_RSS_LUT, v_ret,
+	return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_CONFIG_RSS_LUT, v_ret,
 				     NULL, 0);
 }
 
@@ -1124,8 +1161,8 @@ static int ice_vc_cfg_promiscuous_mode_msg(struct ice_vf *vf, u8 *msg)
 	}
 
 error_param:
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_CONFIG_PROMISCUOUS_MODE,
-				     v_ret, NULL, 0);
+	return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_CONFIG_PROMISCUOUS_MODE,
+				    v_ret, NULL, 0);
 }
 
 /**
@@ -1165,8 +1202,8 @@ static int ice_vc_get_stats_msg(struct ice_vf *vf, u8 *msg)
 
 error_param:
 	/* send the response to the VF */
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_GET_STATS, v_ret,
-				     (u8 *)&stats, sizeof(stats));
+	return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_GET_STATS, v_ret,
+				    (u8 *)&stats, sizeof(stats));
 }
 
 /**
@@ -1315,8 +1352,8 @@ static int ice_vc_ena_qs_msg(struct ice_vf *vf, u8 *msg)
 
 error_param:
 	/* send the response to the VF */
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ENABLE_QUEUES, v_ret,
-				     NULL, 0);
+	return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_ENABLE_QUEUES, v_ret,
+				    NULL, 0);
 }
 
 /**
@@ -1455,8 +1492,8 @@ static int ice_vc_dis_qs_msg(struct ice_vf *vf, u8 *msg)
 
 error_param:
 	/* send the response to the VF */
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DISABLE_QUEUES, v_ret,
-				     NULL, 0);
+	return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_DISABLE_QUEUES, v_ret,
+				    NULL, 0);
 }
 
 /**
@@ -1586,8 +1623,8 @@ static int ice_vc_cfg_irq_map_msg(struct ice_vf *vf, u8 *msg)
 
 error_param:
 	/* send the response to the VF */
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_CONFIG_IRQ_MAP, v_ret,
-				     NULL, 0);
+	return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_CONFIG_IRQ_MAP, v_ret,
+				    NULL, 0);
 }
 
 /**
@@ -1730,8 +1767,8 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 	}
 
 	/* send the response to the VF */
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_CONFIG_VSI_QUEUES,
-				     VIRTCHNL_STATUS_SUCCESS, NULL, 0);
+	return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_CONFIG_VSI_QUEUES,
+				    VIRTCHNL_STATUS_SUCCESS, NULL, 0);
 error_param:
 	/* disable whatever we can */
 	for (; i >= 0; i--) {
@@ -1746,8 +1783,8 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 	ice_lag_move_new_vf_nodes(vf);
 
 	/* send the response to the VF */
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_CONFIG_VSI_QUEUES,
-				     VIRTCHNL_STATUS_ERR_PARAM, NULL, 0);
+	return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_CONFIG_VSI_QUEUES,
+				    VIRTCHNL_STATUS_ERR_PARAM, NULL, 0);
 }
 
 /**
@@ -2049,7 +2086,7 @@ ice_vc_handle_mac_addr_msg(struct ice_vf *vf, u8 *msg, bool set)
 
 handle_mac_exit:
 	/* send the response to the VF */
-	return ice_vc_send_msg_to_vf(vf, vc_op, v_ret, NULL, 0);
+	return ice_vc_respond_to_vf(vf, vc_op, v_ret, NULL, 0);
 }
 
 /**
@@ -2132,8 +2169,8 @@ static int ice_vc_request_qs_msg(struct ice_vf *vf, u8 *msg)
 
 error_param:
 	/* send the response to the VF */
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_REQUEST_QUEUES,
-				     v_ret, (u8 *)vfres, sizeof(*vfres));
+	return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_REQUEST_QUEUES,
+				    v_ret, (u8 *)vfres, sizeof(*vfres));
 }
 
 /**
@@ -2398,11 +2435,11 @@ static int ice_vc_process_vlan_msg(struct ice_vf *vf, u8 *msg, bool add_v)
 error_param:
 	/* send the response to the VF */
 	if (add_v)
-		return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ADD_VLAN, v_ret,
-					     NULL, 0);
+		return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_ADD_VLAN, v_ret,
+					    NULL, 0);
 	else
-		return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DEL_VLAN, v_ret,
-					     NULL, 0);
+		return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_DEL_VLAN, v_ret,
+					    NULL, 0);
 }
 
 /**
@@ -2477,8 +2514,8 @@ static int ice_vc_ena_vlan_stripping(struct ice_vf *vf)
 		vf->vlan_strip_ena |= ICE_INNER_VLAN_STRIP_ENA;
 
 error_param:
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ENABLE_VLAN_STRIPPING,
-				     v_ret, NULL, 0);
+	return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_ENABLE_VLAN_STRIPPING,
+				    v_ret, NULL, 0);
 }
 
 /**
@@ -2514,8 +2551,8 @@ static int ice_vc_dis_vlan_stripping(struct ice_vf *vf)
 		vf->vlan_strip_ena &= ~ICE_INNER_VLAN_STRIP_ENA;
 
 error_param:
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DISABLE_VLAN_STRIPPING,
-				     v_ret, NULL, 0);
+	return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_DISABLE_VLAN_STRIPPING,
+				    v_ret, NULL, 0);
 }
 
 /**
@@ -2550,8 +2587,8 @@ static int ice_vc_get_rss_hena(struct ice_vf *vf)
 	vrh->hena = ICE_DEFAULT_RSS_HENA;
 err:
 	/* send the response back to the VF */
-	ret = ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_GET_RSS_HENA_CAPS, v_ret,
-				    (u8 *)vrh, len);
+	ret = ice_vc_respond_to_vf(vf, VIRTCHNL_OP_GET_RSS_HENA_CAPS, v_ret,
+				   (u8 *)vrh, len);
 	kfree(vrh);
 	return ret;
 }
@@ -2616,8 +2653,8 @@ static int ice_vc_set_rss_hena(struct ice_vf *vf, u8 *msg)
 
 	/* send the response to the VF */
 err:
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_SET_RSS_HENA, v_ret,
-				     NULL, 0);
+	return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_SET_RSS_HENA, v_ret,
+				    NULL, 0);
 }
 
 /**
@@ -2672,8 +2709,8 @@ static int ice_vc_query_rxdid(struct ice_vf *vf)
 	pf->supported_rxdids = rxdid->supported_rxdids;
 
 err:
-	ret = ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_GET_SUPPORTED_RXDIDS,
-				    v_ret, (u8 *)rxdid, len);
+	ret = ice_vc_respond_to_vf(vf, VIRTCHNL_OP_GET_SUPPORTED_RXDIDS,
+				   v_ret, (u8 *)rxdid, len);
 	kfree(rxdid);
 	return ret;
 }
@@ -2909,8 +2946,8 @@ static int ice_vc_get_offload_vlan_v2_caps(struct ice_vf *vf)
 	memcpy(&vf->vlan_v2_caps, caps, sizeof(*caps));
 
 out:
-	err = ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_GET_OFFLOAD_VLAN_V2_CAPS,
-				    v_ret, (u8 *)caps, len);
+	err = ice_vc_respond_to_vf(vf, VIRTCHNL_OP_GET_OFFLOAD_VLAN_V2_CAPS,
+				   v_ret, (u8 *)caps, len);
 	kfree(caps);
 	return err;
 }
@@ -3151,8 +3188,8 @@ static int ice_vc_remove_vlan_v2_msg(struct ice_vf *vf, u8 *msg)
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 
 out:
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DEL_VLAN_V2, v_ret, NULL,
-				     0);
+	return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_DEL_VLAN_V2,
+				    v_ret, NULL, 0);
 }
 
 /**
@@ -3293,8 +3330,8 @@ static int ice_vc_add_vlan_v2_msg(struct ice_vf *vf, u8 *msg)
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 
 out:
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ADD_VLAN_V2, v_ret, NULL,
-				     0);
+	return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_ADD_VLAN_V2,
+				    v_ret, NULL, 0);
 }
 
 /**
@@ -3525,8 +3562,8 @@ static int ice_vc_ena_vlan_stripping_v2_msg(struct ice_vf *vf, u8 *msg)
 		vf->vlan_strip_ena |= ICE_INNER_VLAN_STRIP_ENA;
 
 out:
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ENABLE_VLAN_STRIPPING_V2,
-				     v_ret, NULL, 0);
+	return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_ENABLE_VLAN_STRIPPING_V2,
+				    v_ret, NULL, 0);
 }
 
 /**
@@ -3600,8 +3637,8 @@ static int ice_vc_dis_vlan_stripping_v2_msg(struct ice_vf *vf, u8 *msg)
 		vf->vlan_strip_ena &= ~ICE_INNER_VLAN_STRIP_ENA;
 
 out:
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DISABLE_VLAN_STRIPPING_V2,
-				     v_ret, NULL, 0);
+	return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_DISABLE_VLAN_STRIPPING_V2,
+				    v_ret, NULL, 0);
 }
 
 /**
@@ -3659,8 +3696,8 @@ static int ice_vc_ena_vlan_insertion_v2_msg(struct ice_vf *vf, u8 *msg)
 	}
 
 out:
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ENABLE_VLAN_INSERTION_V2,
-				     v_ret, NULL, 0);
+	return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_ENABLE_VLAN_INSERTION_V2,
+				    v_ret, NULL, 0);
 }
 
 /**
@@ -3714,8 +3751,8 @@ static int ice_vc_dis_vlan_insertion_v2_msg(struct ice_vf *vf, u8 *msg)
 	}
 
 out:
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DISABLE_VLAN_INSERTION_V2,
-				     v_ret, NULL, 0);
+	return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_DISABLE_VLAN_INSERTION_V2,
+				    v_ret, NULL, 0);
 }
 
 static const struct ice_virtchnl_ops ice_virtchnl_dflt_ops = {
@@ -3812,8 +3849,8 @@ static int ice_vc_repr_add_mac(struct ice_vf *vf, u8 *msg)
 	}
 
 handle_mac_exit:
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ADD_ETH_ADDR,
-				     v_ret, NULL, 0);
+	return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_ADD_ETH_ADDR,
+				    v_ret, NULL, 0);
 }
 
 /**
@@ -3832,8 +3869,8 @@ ice_vc_repr_del_mac(struct ice_vf __always_unused *vf, u8 __always_unused *msg)
 
 	ice_update_legacy_cached_mac(vf, &al->list[0]);
 
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DEL_ETH_ADDR,
-				     VIRTCHNL_STATUS_SUCCESS, NULL, 0);
+	return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_DEL_ETH_ADDR,
+				    VIRTCHNL_STATUS_SUCCESS, NULL, 0);
 }
 
 static int
@@ -3842,8 +3879,8 @@ ice_vc_repr_cfg_promiscuous_mode(struct ice_vf *vf, u8 __always_unused *msg)
 	dev_dbg(ice_pf_to_dev(vf->pf),
 		"Can't config promiscuous mode in switchdev mode for VF %d\n",
 		vf->vf_id);
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_CONFIG_PROMISCUOUS_MODE,
-				     VIRTCHNL_STATUS_ERR_NOT_SUPPORTED,
+	return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_CONFIG_PROMISCUOUS_MODE,
+				    VIRTCHNL_STATUS_ERR_NOT_SUPPORTED,
 				     NULL, 0);
 }
 
@@ -3986,16 +4023,16 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event,
 
 error_handler:
 	if (err) {
-		ice_vc_send_msg_to_vf(vf, v_opcode, VIRTCHNL_STATUS_ERR_PARAM,
-				      NULL, 0);
+		ice_vc_respond_to_vf(vf, v_opcode, VIRTCHNL_STATUS_ERR_PARAM,
+				     NULL, 0);
 		dev_err(dev, "Invalid message from VF %d, opcode %d, len %d, error %d\n",
 			vf_id, v_opcode, msglen, err);
 		goto finish;
 	}
 
 	if (!ice_vc_is_opcode_allowed(vf, v_opcode)) {
-		ice_vc_send_msg_to_vf(vf, v_opcode,
-				      VIRTCHNL_STATUS_ERR_NOT_SUPPORTED, NULL,
+		ice_vc_respond_to_vf(vf, v_opcode,
+				     VIRTCHNL_STATUS_ERR_NOT_SUPPORTED, NULL,
 				      0);
 		goto finish;
 	}
@@ -4106,9 +4143,9 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event,
 	default:
 		dev_err(dev, "Unsupported opcode %d from VF %d\n", v_opcode,
 			vf_id);
-		err = ice_vc_send_msg_to_vf(vf, v_opcode,
-					    VIRTCHNL_STATUS_ERR_NOT_SUPPORTED,
-					    NULL, 0);
+		err = ice_vc_respond_to_vf(vf, v_opcode,
+					   VIRTCHNL_STATUS_ERR_NOT_SUPPORTED,
+					   NULL, 0);
 		break;
 	}
 	if (err) {
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl.h b/drivers/net/ethernet/intel/ice/ice_virtchnl.h
index cd747718de73..a2b6094e2f2f 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl.h
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.h
@@ -60,8 +60,8 @@ void ice_vc_notify_vf_link_state(struct ice_vf *vf);
 void ice_vc_notify_link_state(struct ice_pf *pf);
 void ice_vc_notify_reset(struct ice_pf *pf);
 int
-ice_vc_send_msg_to_vf(struct ice_vf *vf, u32 v_opcode,
-		      enum virtchnl_status_code v_retval, u8 *msg, u16 msglen);
+ice_vc_respond_to_vf(struct ice_vf *vf, u32 v_opcode,
+		     enum virtchnl_status_code v_retval, u8 *msg, u16 msglen);
 bool ice_vc_isvalid_vsi_id(struct ice_vf *vf, u16 vsi_id);
 void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event,
 			   struct ice_mbx_data *mbxdata);
@@ -73,8 +73,8 @@ static inline void ice_vc_notify_link_state(struct ice_pf *pf) { }
 static inline void ice_vc_notify_reset(struct ice_pf *pf) { }
 
 static inline int
-ice_vc_send_msg_to_vf(struct ice_vf *vf, u32 v_opcode,
-		      enum virtchnl_status_code v_retval, u8 *msg, u16 msglen)
+ice_vc_respond_to_vf(struct ice_vf *vf, u32 v_opcode,
+		     enum virtchnl_status_code v_retval, u8 *msg, u16 msglen)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
index 24b23b7ef04a..816d8bf8bec4 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
@@ -1584,8 +1584,8 @@ ice_vc_add_fdir_fltr_post(struct ice_vf *vf, struct ice_vf_fdir_ctx *ctx,
 	resp->flow_id = conf->flow_id;
 	vf->fdir.fdir_fltr_cnt[conf->input.flow_type][is_tun]++;
 
-	ret = ice_vc_send_msg_to_vf(vf, ctx->v_opcode, v_ret,
-				    (u8 *)resp, len);
+	ret = ice_vc_respond_to_vf(vf, ctx->v_opcode, v_ret,
+				   (u8 *)resp, len);
 	kfree(resp);
 
 	dev_dbg(dev, "VF %d: flow_id:0x%X, FDIR %s success!\n",
@@ -1600,8 +1600,8 @@ ice_vc_add_fdir_fltr_post(struct ice_vf *vf, struct ice_vf_fdir_ctx *ctx,
 	ice_vc_fdir_remove_entry(vf, conf, conf->flow_id);
 	devm_kfree(dev, conf);
 
-	ret = ice_vc_send_msg_to_vf(vf, ctx->v_opcode, v_ret,
-				    (u8 *)resp, len);
+	ret = ice_vc_respond_to_vf(vf, ctx->v_opcode, v_ret,
+				   (u8 *)resp, len);
 	kfree(resp);
 	return ret;
 }
@@ -1648,8 +1648,8 @@ ice_vc_del_fdir_fltr_post(struct ice_vf *vf, struct ice_vf_fdir_ctx *ctx,
 	ice_vc_fdir_remove_entry(vf, conf, conf->flow_id);
 	vf->fdir.fdir_fltr_cnt[conf->input.flow_type][is_tun]--;
 
-	ret = ice_vc_send_msg_to_vf(vf, ctx->v_opcode, v_ret,
-				    (u8 *)resp, len);
+	ret = ice_vc_respond_to_vf(vf, ctx->v_opcode, v_ret,
+				   (u8 *)resp, len);
 	kfree(resp);
 
 	dev_dbg(dev, "VF %d: flow_id:0x%X, FDIR %s success!\n",
@@ -1665,8 +1665,8 @@ ice_vc_del_fdir_fltr_post(struct ice_vf *vf, struct ice_vf_fdir_ctx *ctx,
 	if (success)
 		devm_kfree(dev, conf);
 
-	ret = ice_vc_send_msg_to_vf(vf, ctx->v_opcode, v_ret,
-				    (u8 *)resp, len);
+	ret = ice_vc_respond_to_vf(vf, ctx->v_opcode, v_ret,
+				   (u8 *)resp, len);
 	kfree(resp);
 	return ret;
 }
@@ -1863,8 +1863,8 @@ int ice_vc_add_fdir_fltr(struct ice_vf *vf, u8 *msg)
 		v_ret = VIRTCHNL_STATUS_SUCCESS;
 		stat->status = VIRTCHNL_FDIR_SUCCESS;
 		devm_kfree(dev, conf);
-		ret = ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ADD_FDIR_FILTER,
-					    v_ret, (u8 *)stat, len);
+		ret = ice_vc_respond_to_vf(vf, VIRTCHNL_OP_ADD_FDIR_FILTER,
+					   v_ret, (u8 *)stat, len);
 		goto exit;
 	}
 
@@ -1922,8 +1922,8 @@ int ice_vc_add_fdir_fltr(struct ice_vf *vf, u8 *msg)
 err_free_conf:
 	devm_kfree(dev, conf);
 err_exit:
-	ret = ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ADD_FDIR_FILTER, v_ret,
-				    (u8 *)stat, len);
+	ret = ice_vc_respond_to_vf(vf, VIRTCHNL_OP_ADD_FDIR_FILTER, v_ret,
+				   (u8 *)stat, len);
 	kfree(stat);
 	return ret;
 }
@@ -2006,8 +2006,8 @@ int ice_vc_del_fdir_fltr(struct ice_vf *vf, u8 *msg)
 err_del_tmr:
 	ice_vc_fdir_clear_irq_ctx(vf);
 err_exit:
-	ret = ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DEL_FDIR_FILTER, v_ret,
-				    (u8 *)stat, len);
+	ret = ice_vc_respond_to_vf(vf, VIRTCHNL_OP_DEL_FDIR_FILTER, v_ret,
+				   (u8 *)stat, len);
 	kfree(stat);
 	return ret;
 }
-- 
2.34.1


