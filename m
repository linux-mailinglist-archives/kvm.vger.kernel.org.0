Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E63F8638D0A
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 16:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbiKYPHP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Nov 2022 10:07:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230271AbiKYPHM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Nov 2022 10:07:12 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF4FB31DC6
        for <kvm@vger.kernel.org>; Fri, 25 Nov 2022 07:07:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669388830; x=1700924830;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=L7+kRJxim+tXndxTiW57BfxqYjmCXRG7PwELl1gNbb4=;
  b=bu4W9MtPzisblU0b3H98lrzU/xo4ZLslvXRRTMyjUPtkJJU1zkSGAgty
   xTgu3ZX5Hlmzeor13n7e+0kZJdkNofIpPJsmBBh28jfZjeZB9QX4yA121
   mrNZFlPy1PKgLLxhtWcv3FY8pLAIjMXV7MIJssGnCZPNFK1eWsKDtUN3j
   X7sGobQHmciP2CEPWrb3bovUo5Y+C3UOQLWZPlEmo1iXqZ/4rw42qxQiq
   y6Xj2lbv8rHikxjOT0ez0D+bAekb7nXNZtrkIS/TnrEHziAY9a9vYayVy
   ApWSK6K+gnB2yjXG3UEfVcJoy6OTrhwVV7yoHd5J4DhT9O90QpgvhJRKm
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10542"; a="294881077"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="294881077"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2022 07:06:53 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10542"; a="593240306"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="593240306"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2022 07:06:51 -0800
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        hang.yuan@intel.com, piotr.uminski@intel.com,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V2 12/12] vDPA/ifcvf: implement features provisioning
Date:   Fri, 25 Nov 2022 22:57:24 +0800
Message-Id: <20221125145724.1129962-13-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221125145724.1129962-1-lingshan.zhu@intel.com>
References: <20221125145724.1129962-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
index d41e255c581b..c20d1c40214e 100644
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
index 5fb3580594d5..cc826bfd3866 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -743,6 +743,7 @@ static int ifcvf_vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name,
 	struct vdpa_device *vdpa_dev;
 	struct pci_dev *pdev;
 	struct ifcvf_hw *vf;
+	u64 device_features;
 	int ret;
 
 	ifcvf_mgmt_dev = container_of(mdev, struct ifcvf_vdpa_mgmt_dev, mdev);
@@ -762,6 +763,17 @@ static int ifcvf_vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name,
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
@@ -866,6 +878,7 @@ static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	ifcvf_mgmt_dev->mdev.device = dev;
 	ifcvf_mgmt_dev->mdev.max_supported_vqs = vf->nr_vring;
 	ifcvf_mgmt_dev->mdev.supported_features = vf->hw_features;
+	ifcvf_mgmt_dev->mdev.config_attr_mask = (1 << VDPA_ATTR_DEV_FEATURES);
 
 	ret = vdpa_mgmtdev_register(&ifcvf_mgmt_dev->mdev);
 	if (ret) {
-- 
2.31.1

