Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1553561EF55
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 10:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231802AbiKGJmf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 04:42:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231516AbiKGJm1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 04:42:27 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1FC313D65
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 01:42:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667814146; x=1699350146;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pR1VEKR3beIDko3ztwVjofr9M7Am2nSVtgh3ICsiXhY=;
  b=dF8+irPMVotFmYXfXpXHce6/IdK8mbrFxGJFHe2xFgET4AVbjiUTzhul
   4zqHMnIniZba23/lTRdFmakAt02ooOrqMNoMBzAnO/yt8NjwzO8UcYVpS
   A7aGVaU6lsoPRcHSowpm/k3e9C343R+pJ4Wp2mgqLSRTxzoVEzw7AHaxK
   94HHo80XaAWORuZ2z6ozUl+lvcU2SVAya2KO2BAk+kfmeBpB7aPP1R+Uw
   2CK089mZkjC3CHclM7Jn8SQ24M8FbRhAnHg6zrjX0FW9zmjBK2HhN0smP
   nFof6j/Y5u27JfCd0WlfvwIM3dXH9xFpdbCEo/4yMLwm/pEM1OypFAhgW
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10523"; a="310370529"
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="310370529"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 01:42:26 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10523"; a="704810815"
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="704810815"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 01:42:24 -0800
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        hang.yuan@intel.com, piotr.uminski@intel.com,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH 4/4] vDPA/ifcvf: implement features provisioning
Date:   Mon,  7 Nov 2022 17:33:45 +0800
Message-Id: <20221107093345.121648-5-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221107093345.121648-1-lingshan.zhu@intel.com>
References: <20221107093345.121648-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This commit implements features provisioning for ifcvf, that means:
1)checkk whether the provisioned features are supported by
the management device
2)vDPA device only presents selected feature bits

Examples:
a)The management device supported features:
$ vdpa mgmtdev show pci/0000:01:00.5
pci/0000:01:00.5:
  supported_classes net
  max_supported_vqs 9
  dev_features MTU MAC MRG_RXBUF CTRL_VQ MQ ANY_LAYOUT VERSION_1 ACCESS_PLATFORM

b)Provision a vDPA device with all supported features:
$ vdpa dev add name vdpa0 mgmtdev pci/0000:01:00.5
$ vdpa/vdpa dev config show vdpa0
vdpa0: mac 00:e8:ca:11:be:05 link up link_announce false max_vq_pairs 4 mtu 1500
  negotiated_features MRG_RXBUF CTRL_VQ MQ VERSION_1 ACCESS_PLATFORM

c)Provision a vDPA device with a subset of the supported features:
$ vdpa dev add name vdpa0 mgmtdev pci/0000:01:00.5 device_features 0x300020020
$ vdpa dev config show vdpa0
mac 00:e8:ca:11:be:05 link up link_announce false
  negotiated_features CTRL_VQ VERSION_1 ACCESS_PLATFORM

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/ifcvf/ifcvf_base.c |  2 +-
 drivers/vdpa/ifcvf/ifcvf_base.h |  3 +++
 drivers/vdpa/ifcvf/ifcvf_main.c | 13 +++++++++++++
 3 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c b/drivers/vdpa/ifcvf/ifcvf_base.c
index 3ec5ca3aefe1..5563b3a773c7 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.c
+++ b/drivers/vdpa/ifcvf/ifcvf_base.c
@@ -206,7 +206,7 @@ u64 ifcvf_get_hw_features(struct ifcvf_hw *hw)
 
 u64 ifcvf_get_features(struct ifcvf_hw *hw)
 {
-	return hw->hw_features;
+	return hw->dev_features;
 }
 
 int ifcvf_verify_min_features(struct ifcvf_hw *hw, u64 features)
diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
index 15d5badc7dbd..e2dff9a46388 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.h
+++ b/drivers/vdpa/ifcvf/ifcvf_base.h
@@ -19,6 +19,7 @@
 #include <uapi/linux/virtio_blk.h>
 #include <uapi/linux/virtio_config.h>
 #include <uapi/linux/virtio_pci.h>
+#include <uapi/linux/vdpa.h>
 
 #define N3000_DEVICE_ID		0x1041
 #define N3000_SUBSYS_DEVICE_ID	0x001A
@@ -75,6 +76,8 @@ struct ifcvf_hw {
 	u32 dev_type;
 	u64 req_features;
 	u64 hw_features;
+	/* provisioned device features */
+	u64 dev_features;
 	struct virtio_pci_common_cfg __iomem *common_cfg;
 	void __iomem *dev_cfg;
 	struct vring_info vring[IFCVF_MAX_QUEUES];
diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index 76ac324c271b..22bf7029399e 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -745,6 +745,7 @@ static int ifcvf_vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name,
 	struct vdpa_device *vdpa_dev;
 	struct pci_dev *pdev;
 	struct ifcvf_hw *vf;
+	u64 device_features;
 	int ret;
 
 	ifcvf_mgmt_dev = container_of(mdev, struct ifcvf_vdpa_mgmt_dev, mdev);
@@ -764,6 +765,17 @@ static int ifcvf_vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name,
 	adapter->vf = vf;
 	vdpa_dev = &adapter->vdpa;
 
+	device_features = vf->hw_features;
+	if (config->mask & BIT_ULL(VDPA_ATTR_DEV_FEATURES)) {
+		if (config->device_features & ~device_features) {
+			IFCVF_ERR(pdev, "The provisioned features 0x%llx are not supported by this device with features 0x%llx\n",
+				  config->device_features, device_features);
+			return -EINVAL;
+		}
+		device_features &= config->device_features;
+	}
+	vf->dev_features = device_features;
+
 	if (name)
 		ret = dev_set_name(&vdpa_dev->dev, "%s", name);
 	else
@@ -868,6 +880,7 @@ static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	ifcvf_mgmt_dev->mdev.max_supported_vqs = vf->nr_vring;
 	ifcvf_mgmt_dev->mdev.supported_features = vf->hw_features;
+	ifcvf_mgmt_dev->mdev.config_attr_mask = (1 << VDPA_ATTR_DEV_FEATURES);
 
 	ret = vdpa_mgmtdev_register(&ifcvf_mgmt_dev->mdev);
 	if (ret) {
-- 
2.31.1

