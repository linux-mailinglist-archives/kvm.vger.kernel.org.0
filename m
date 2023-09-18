Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0468A7A411E
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 08:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239832AbjIRG2u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 02:28:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239835AbjIRG2T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 02:28:19 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BA9710F;
        Sun, 17 Sep 2023 23:28:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695018492; x=1726554492;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PvhEam7jMyPniZYHXz11nuOCnPlK2kB8jEpEfoNSjzU=;
  b=VQQvya8cwWfuaUxQBDuruVeH4qy7QYhJ/YcbDIS8VvPRaUtKh+Y3nxQ5
   cyIgQm5mvNIn9zxnniU7sJdFdnL3TWM2FYV0XI1yrMW5ebmD17qRFdQX+
   i6TwU1Hd3l9GQeJ6EEKJEq7t91d7txKk4smfQTF0iDN5jQFOMHqgTQePg
   s6O4XgqMKRueNQk1DFe0CWzx2Crit0jgaYGvf+6+rkZUvAnBdAcmO6pE7
   XUk/4MwjzQNnW2m1S/+7Tm6s88reI8ZS0kWZ6nS2p8QpN3KK02r35BtVZ
   gZxL/hFPSs0Pa58liITzGXc3r3kxBc6F4s4izu8Qm82Ops5WRQbXU2EAe
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10836"; a="378488524"
X-IronPort-AV: E=Sophos;i="6.02,155,1688454000"; 
   d="scan'208";a="378488524"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2023 23:28:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10836"; a="815893443"
X-IronPort-AV: E=Sophos;i="6.02,155,1688454000"; 
   d="scan'208";a="815893443"
Received: from dpdk-yahui-icx1.sh.intel.com ([10.67.111.186])
  by fmsmga004.fm.intel.com with ESMTP; 17 Sep 2023 23:28:05 -0700
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
Subject: [PATCH iwl-next v3 04/13] ice: Introduce VF state ICE_VF_STATE_REPLAYING_VC for migration
Date:   Mon, 18 Sep 2023 06:25:37 +0000
Message-Id: <20230918062546.40419-5-yahui.cao@intel.com>
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

During migration device resume stage, part of device state is loaded by
replaying logged virtual channel message. By default, once virtual
channel message is processed successfully, PF will send message to VF.

In addition, PF will notify VF about link state while handling virtual
channel message GET_VF_RESOURCE and ENABLE_QUEUES. And VF driver will
print link state change info once receiving notification from PF.

However, device resume stage does not need PF to send messages to VF
for the above cases. So stop PF from sending messages to VF while VF is
in replay state.

Signed-off-by: Lingyu Liu <lingyu.liu@intel.com>
Signed-off-by: Yahui Cao <yahui.cao@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_vf_lib.h   |   1 +
 drivers/net/ethernet/intel/ice/ice_virtchnl.c | 185 ++++++++++--------
 drivers/net/ethernet/intel/ice/ice_virtchnl.h |   8 +-
 .../ethernet/intel/ice/ice_virtchnl_fdir.c    |  28 +--
 4 files changed, 124 insertions(+), 98 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.h b/drivers/net/ethernet/intel/ice/ice_vf_lib.h
index 31a082e8a827..ff1438373f69 100644
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
index 3bf95d3c50d3..6be796ed70a8 100644
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
 
@@ -281,19 +284,10 @@ void ice_vc_notify_reset(struct ice_pf *pf)
 			    (u8 *)&pfe, sizeof(struct virtchnl_pf_event));
 }
 
-/**
- * ice_vc_send_msg_to_vf - Send message to VF
- * @vf: pointer to the VF info
- * @v_opcode: virtual channel opcode
- * @v_retval: virtual channel return value
- * @msg: pointer to the msg buffer
- * @msglen: msg length
- *
- * send msg to VF
- */
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
@@ -314,6 +308,39 @@ ice_vc_send_msg_to_vf(struct ice_vf *vf, u32 v_opcode,
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
@@ -332,9 +359,9 @@ static int ice_vc_get_ver_msg(struct ice_vf *vf, u8 *msg)
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
@@ -522,8 +549,8 @@ static int ice_vc_get_vf_res_msg(struct ice_vf *vf, u8 *msg)
 
 err:
 	/* send the response back to the VF */
-	ret = ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_GET_VF_RESOURCES, v_ret,
-				    (u8 *)vfres, len);
+	ret = ice_vc_respond_to_vf(vf, VIRTCHNL_OP_GET_VF_RESOURCES, v_ret,
+				   (u8 *)vfres, len);
 
 	kfree(vfres);
 	return ret;
@@ -892,7 +919,7 @@ static int ice_vc_handle_rss_cfg(struct ice_vf *vf, u8 *msg, bool add)
 	}
 
 error_param:
-	return ice_vc_send_msg_to_vf(vf, v_opcode, v_ret, NULL, 0);
+	return ice_vc_respond_to_vf(vf, v_opcode, v_ret, NULL, 0);
 }
 
 /**
@@ -938,8 +965,8 @@ static int ice_vc_config_rss_key(struct ice_vf *vf, u8 *msg)
 	if (ice_set_rss_key(vsi, vrk->key))
 		v_ret = VIRTCHNL_STATUS_ERR_ADMIN_QUEUE_ERROR;
 error_param:
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_CONFIG_RSS_KEY, v_ret,
-				     NULL, 0);
+	return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_CONFIG_RSS_KEY, v_ret,
+				    NULL, 0);
 }
 
 /**
@@ -984,7 +1011,7 @@ static int ice_vc_config_rss_lut(struct ice_vf *vf, u8 *msg)
 	if (ice_set_rss_lut(vsi, vrl->lut, ICE_LUT_VSI_SIZE))
 		v_ret = VIRTCHNL_STATUS_ERR_ADMIN_QUEUE_ERROR;
 error_param:
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_CONFIG_RSS_LUT, v_ret,
+	return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_CONFIG_RSS_LUT, v_ret,
 				     NULL, 0);
 }
 
@@ -1124,8 +1151,8 @@ static int ice_vc_cfg_promiscuous_mode_msg(struct ice_vf *vf, u8 *msg)
 	}
 
 error_param:
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_CONFIG_PROMISCUOUS_MODE,
-				     v_ret, NULL, 0);
+	return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_CONFIG_PROMISCUOUS_MODE,
+				    v_ret, NULL, 0);
 }
 
 /**
@@ -1165,8 +1192,8 @@ static int ice_vc_get_stats_msg(struct ice_vf *vf, u8 *msg)
 
 error_param:
 	/* send the response to the VF */
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_GET_STATS, v_ret,
-				     (u8 *)&stats, sizeof(stats));
+	return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_GET_STATS, v_ret,
+				    (u8 *)&stats, sizeof(stats));
 }
 
 /**
@@ -1315,8 +1342,8 @@ static int ice_vc_ena_qs_msg(struct ice_vf *vf, u8 *msg)
 
 error_param:
 	/* send the response to the VF */
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ENABLE_QUEUES, v_ret,
-				     NULL, 0);
+	return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_ENABLE_QUEUES, v_ret,
+				    NULL, 0);
 }
 
 /**
@@ -1455,8 +1482,8 @@ static int ice_vc_dis_qs_msg(struct ice_vf *vf, u8 *msg)
 
 error_param:
 	/* send the response to the VF */
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DISABLE_QUEUES, v_ret,
-				     NULL, 0);
+	return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_DISABLE_QUEUES, v_ret,
+				    NULL, 0);
 }
 
 /**
@@ -1586,8 +1613,8 @@ static int ice_vc_cfg_irq_map_msg(struct ice_vf *vf, u8 *msg)
 
 error_param:
 	/* send the response to the VF */
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_CONFIG_IRQ_MAP, v_ret,
-				     NULL, 0);
+	return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_CONFIG_IRQ_MAP, v_ret,
+				    NULL, 0);
 }
 
 /**
@@ -1730,8 +1757,8 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 	}
 
 	/* send the response to the VF */
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_CONFIG_VSI_QUEUES,
-				     VIRTCHNL_STATUS_SUCCESS, NULL, 0);
+	return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_CONFIG_VSI_QUEUES,
+				    VIRTCHNL_STATUS_SUCCESS, NULL, 0);
 error_param:
 	/* disable whatever we can */
 	for (; i >= 0; i--) {
@@ -1746,8 +1773,8 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 	ice_lag_move_new_vf_nodes(vf);
 
 	/* send the response to the VF */
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_CONFIG_VSI_QUEUES,
-				     VIRTCHNL_STATUS_ERR_PARAM, NULL, 0);
+	return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_CONFIG_VSI_QUEUES,
+				    VIRTCHNL_STATUS_ERR_PARAM, NULL, 0);
 }
 
 /**
@@ -2049,7 +2076,7 @@ ice_vc_handle_mac_addr_msg(struct ice_vf *vf, u8 *msg, bool set)
 
 handle_mac_exit:
 	/* send the response to the VF */
-	return ice_vc_send_msg_to_vf(vf, vc_op, v_ret, NULL, 0);
+	return ice_vc_respond_to_vf(vf, vc_op, v_ret, NULL, 0);
 }
 
 /**
@@ -2132,8 +2159,8 @@ static int ice_vc_request_qs_msg(struct ice_vf *vf, u8 *msg)
 
 error_param:
 	/* send the response to the VF */
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_REQUEST_QUEUES,
-				     v_ret, (u8 *)vfres, sizeof(*vfres));
+	return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_REQUEST_QUEUES,
+				    v_ret, (u8 *)vfres, sizeof(*vfres));
 }
 
 /**
@@ -2398,11 +2425,11 @@ static int ice_vc_process_vlan_msg(struct ice_vf *vf, u8 *msg, bool add_v)
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
@@ -2477,8 +2504,8 @@ static int ice_vc_ena_vlan_stripping(struct ice_vf *vf)
 		vf->vlan_strip_ena |= ICE_INNER_VLAN_STRIP_ENA;
 
 error_param:
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ENABLE_VLAN_STRIPPING,
-				     v_ret, NULL, 0);
+	return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_ENABLE_VLAN_STRIPPING,
+				    v_ret, NULL, 0);
 }
 
 /**
@@ -2514,8 +2541,8 @@ static int ice_vc_dis_vlan_stripping(struct ice_vf *vf)
 		vf->vlan_strip_ena &= ~ICE_INNER_VLAN_STRIP_ENA;
 
 error_param:
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DISABLE_VLAN_STRIPPING,
-				     v_ret, NULL, 0);
+	return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_DISABLE_VLAN_STRIPPING,
+				    v_ret, NULL, 0);
 }
 
 /**
@@ -2550,8 +2577,8 @@ static int ice_vc_get_rss_hena(struct ice_vf *vf)
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
@@ -2616,8 +2643,8 @@ static int ice_vc_set_rss_hena(struct ice_vf *vf, u8 *msg)
 
 	/* send the response to the VF */
 err:
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_SET_RSS_HENA, v_ret,
-				     NULL, 0);
+	return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_SET_RSS_HENA, v_ret,
+				    NULL, 0);
 }
 
 /**
@@ -2673,8 +2700,8 @@ static int ice_vc_query_rxdid(struct ice_vf *vf)
 	pf->supported_rxdids = rxdid->supported_rxdids;
 
 err:
-	ret = ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_GET_SUPPORTED_RXDIDS,
-				    v_ret, (u8 *)rxdid, len);
+	ret = ice_vc_respond_to_vf(vf, VIRTCHNL_OP_GET_SUPPORTED_RXDIDS,
+				   v_ret, (u8 *)rxdid, len);
 	kfree(rxdid);
 	return ret;
 }
@@ -2910,8 +2937,8 @@ static int ice_vc_get_offload_vlan_v2_caps(struct ice_vf *vf)
 	memcpy(&vf->vlan_v2_caps, caps, sizeof(*caps));
 
 out:
-	err = ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_GET_OFFLOAD_VLAN_V2_CAPS,
-				    v_ret, (u8 *)caps, len);
+	err = ice_vc_respond_to_vf(vf, VIRTCHNL_OP_GET_OFFLOAD_VLAN_V2_CAPS,
+				   v_ret, (u8 *)caps, len);
 	kfree(caps);
 	return err;
 }
@@ -3152,8 +3179,7 @@ static int ice_vc_remove_vlan_v2_msg(struct ice_vf *vf, u8 *msg)
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 
 out:
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DEL_VLAN_V2, v_ret, NULL,
-				     0);
+	return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_DEL_VLAN_V2, v_ret, NULL, 0);
 }
 
 /**
@@ -3294,8 +3320,7 @@ static int ice_vc_add_vlan_v2_msg(struct ice_vf *vf, u8 *msg)
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 
 out:
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ADD_VLAN_V2, v_ret, NULL,
-				     0);
+	return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_ADD_VLAN_V2, v_ret, NULL, 0);
 }
 
 /**
@@ -3526,8 +3551,8 @@ static int ice_vc_ena_vlan_stripping_v2_msg(struct ice_vf *vf, u8 *msg)
 		vf->vlan_strip_ena |= ICE_INNER_VLAN_STRIP_ENA;
 
 out:
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ENABLE_VLAN_STRIPPING_V2,
-				     v_ret, NULL, 0);
+	return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_ENABLE_VLAN_STRIPPING_V2,
+				    v_ret, NULL, 0);
 }
 
 /**
@@ -3601,8 +3626,8 @@ static int ice_vc_dis_vlan_stripping_v2_msg(struct ice_vf *vf, u8 *msg)
 		vf->vlan_strip_ena &= ~ICE_INNER_VLAN_STRIP_ENA;
 
 out:
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DISABLE_VLAN_STRIPPING_V2,
-				     v_ret, NULL, 0);
+	return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_DISABLE_VLAN_STRIPPING_V2,
+				    v_ret, NULL, 0);
 }
 
 /**
@@ -3660,8 +3685,8 @@ static int ice_vc_ena_vlan_insertion_v2_msg(struct ice_vf *vf, u8 *msg)
 	}
 
 out:
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ENABLE_VLAN_INSERTION_V2,
-				     v_ret, NULL, 0);
+	return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_ENABLE_VLAN_INSERTION_V2,
+				    v_ret, NULL, 0);
 }
 
 /**
@@ -3715,8 +3740,8 @@ static int ice_vc_dis_vlan_insertion_v2_msg(struct ice_vf *vf, u8 *msg)
 	}
 
 out:
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DISABLE_VLAN_INSERTION_V2,
-				     v_ret, NULL, 0);
+	return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_DISABLE_VLAN_INSERTION_V2,
+				    v_ret, NULL, 0);
 }
 
 static const struct ice_virtchnl_ops ice_virtchnl_dflt_ops = {
@@ -3813,8 +3838,8 @@ static int ice_vc_repr_add_mac(struct ice_vf *vf, u8 *msg)
 	}
 
 handle_mac_exit:
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ADD_ETH_ADDR,
-				     v_ret, NULL, 0);
+	return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_ADD_ETH_ADDR,
+				    v_ret, NULL, 0);
 }
 
 /**
@@ -3833,8 +3858,8 @@ ice_vc_repr_del_mac(struct ice_vf __always_unused *vf, u8 __always_unused *msg)
 
 	ice_update_legacy_cached_mac(vf, &al->list[0]);
 
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DEL_ETH_ADDR,
-				     VIRTCHNL_STATUS_SUCCESS, NULL, 0);
+	return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_DEL_ETH_ADDR,
+				    VIRTCHNL_STATUS_SUCCESS, NULL, 0);
 }
 
 static int
@@ -3843,8 +3868,8 @@ ice_vc_repr_cfg_promiscuous_mode(struct ice_vf *vf, u8 __always_unused *msg)
 	dev_dbg(ice_pf_to_dev(vf->pf),
 		"Can't config promiscuous mode in switchdev mode for VF %d\n",
 		vf->vf_id);
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_CONFIG_PROMISCUOUS_MODE,
-				     VIRTCHNL_STATUS_ERR_NOT_SUPPORTED,
+	return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_CONFIG_PROMISCUOUS_MODE,
+				    VIRTCHNL_STATUS_ERR_NOT_SUPPORTED,
 				     NULL, 0);
 }
 
@@ -3987,16 +4012,16 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event,
 
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
@@ -4107,9 +4132,9 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event,
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
index daa6a1e894cf..bf6c24901cb0 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
@@ -1571,8 +1571,8 @@ ice_vc_add_fdir_fltr_post(struct ice_vf *vf, struct ice_vf_fdir_ctx *ctx,
 	resp->flow_id = conf->flow_id;
 	vf->fdir.fdir_fltr_cnt[conf->input.flow_type][is_tun]++;
 
-	ret = ice_vc_send_msg_to_vf(vf, ctx->v_opcode, v_ret,
-				    (u8 *)resp, len);
+	ret = ice_vc_respond_to_vf(vf, ctx->v_opcode, v_ret,
+				   (u8 *)resp, len);
 	kfree(resp);
 
 	dev_dbg(dev, "VF %d: flow_id:0x%X, FDIR %s success!\n",
@@ -1587,8 +1587,8 @@ ice_vc_add_fdir_fltr_post(struct ice_vf *vf, struct ice_vf_fdir_ctx *ctx,
 	ice_vc_fdir_remove_entry(vf, conf, conf->flow_id);
 	devm_kfree(dev, conf);
 
-	ret = ice_vc_send_msg_to_vf(vf, ctx->v_opcode, v_ret,
-				    (u8 *)resp, len);
+	ret = ice_vc_respond_to_vf(vf, ctx->v_opcode, v_ret,
+				   (u8 *)resp, len);
 	kfree(resp);
 	return ret;
 }
@@ -1635,8 +1635,8 @@ ice_vc_del_fdir_fltr_post(struct ice_vf *vf, struct ice_vf_fdir_ctx *ctx,
 	ice_vc_fdir_remove_entry(vf, conf, conf->flow_id);
 	vf->fdir.fdir_fltr_cnt[conf->input.flow_type][is_tun]--;
 
-	ret = ice_vc_send_msg_to_vf(vf, ctx->v_opcode, v_ret,
-				    (u8 *)resp, len);
+	ret = ice_vc_respond_to_vf(vf, ctx->v_opcode, v_ret,
+				   (u8 *)resp, len);
 	kfree(resp);
 
 	dev_dbg(dev, "VF %d: flow_id:0x%X, FDIR %s success!\n",
@@ -1652,8 +1652,8 @@ ice_vc_del_fdir_fltr_post(struct ice_vf *vf, struct ice_vf_fdir_ctx *ctx,
 	if (success)
 		devm_kfree(dev, conf);
 
-	ret = ice_vc_send_msg_to_vf(vf, ctx->v_opcode, v_ret,
-				    (u8 *)resp, len);
+	ret = ice_vc_respond_to_vf(vf, ctx->v_opcode, v_ret,
+				   (u8 *)resp, len);
 	kfree(resp);
 	return ret;
 }
@@ -1850,8 +1850,8 @@ int ice_vc_add_fdir_fltr(struct ice_vf *vf, u8 *msg)
 		v_ret = VIRTCHNL_STATUS_SUCCESS;
 		stat->status = VIRTCHNL_FDIR_SUCCESS;
 		devm_kfree(dev, conf);
-		ret = ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ADD_FDIR_FILTER,
-					    v_ret, (u8 *)stat, len);
+		ret = ice_vc_respond_to_vf(vf, VIRTCHNL_OP_ADD_FDIR_FILTER,
+					   v_ret, (u8 *)stat, len);
 		goto exit;
 	}
 
@@ -1909,8 +1909,8 @@ int ice_vc_add_fdir_fltr(struct ice_vf *vf, u8 *msg)
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
@@ -1993,8 +1993,8 @@ int ice_vc_del_fdir_fltr(struct ice_vf *vf, u8 *msg)
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

