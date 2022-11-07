Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7E6461EF54
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 10:42:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231741AbiKGJmb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 04:42:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231688AbiKGJmZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 04:42:25 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 812761759E
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 01:42:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667814144; x=1699350144;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iWBhprov2eHzoMWfyrwD7Am+cr+ihPXqIxoeY5yYvHI=;
  b=LhATqqKla1JG/S+aJ7mcruLUojXzFW48ANb0NM78DHRJgxn1zeGMJ6TB
   Y30JmiAaabJBxDNWndz0vsQjKs4NGYvS2Ek8B+w0rVTXEeZLioaj3y4ms
   Fk/kCLKxQTBDnzDV8yFH3mRGD3Kb3ygvQpzJ0SiUFv9wEdfPw5KR9WfWq
   rDKq1rdGIL7GKneU80Z09vY/r+rfkEwlNLt0/tOipjDW1SFjzHVgz6pG8
   xNaOa7f/4D/U7WCw8n37EQ9rA2YN4Tdo2lzrWUujyZR6jGLmtJXRm90df
   j++gvPx7V1XTUYi+ELCvMUQbsJ+REZ47zJunVn4XXI/r+BdmK/X4SUGc8
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10523"; a="310370516"
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="310370516"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 01:42:24 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10523"; a="704810811"
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="704810811"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 01:42:22 -0800
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        hang.yuan@intel.com, piotr.uminski@intel.com,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH 3/4] vDPA/ifcvf: allocate ifcvf_adapter in dev_add()
Date:   Mon,  7 Nov 2022 17:33:44 +0800
Message-Id: <20221107093345.121648-4-lingshan.zhu@intel.com>
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

This commits allocates ifcvf_adapter which is
a container of struct vdpa_device in dev_add()
interface than in probe()

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/ifcvf/ifcvf_base.h |  5 +--
 drivers/vdpa/ifcvf/ifcvf_main.c | 58 ++++++++++++++-------------------
 2 files changed, 26 insertions(+), 37 deletions(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
index 63ce1f7f6841..15d5badc7dbd 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.h
+++ b/drivers/vdpa/ifcvf/ifcvf_base.h
@@ -38,9 +38,6 @@
 #define IFCVF_DBG(pdev, fmt, ...)	dev_dbg(&pdev->dev, fmt, ##__VA_ARGS__)
 #define IFCVF_INFO(pdev, fmt, ...)	dev_info(&pdev->dev, fmt, ##__VA_ARGS__)
 
-#define ifcvf_private_to_vf(adapter) \
-	(&((struct ifcvf_adapter *)adapter)->vf)
-
 /* all vqs and config interrupt has its own vector */
 #define MSIX_VECTOR_PER_VQ_AND_CONFIG		1
 /* all vqs share a vector, and config interrupt has a separate vector */
@@ -95,7 +92,7 @@ struct ifcvf_hw {
 struct ifcvf_adapter {
 	struct vdpa_device vdpa;
 	struct pci_dev *pdev;
-	struct ifcvf_hw vf;
+	struct ifcvf_hw *vf;
 };
 
 struct ifcvf_vring_lm_cfg {
diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index bae518ff6234..76ac324c271b 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -347,9 +347,9 @@ static int ifcvf_request_irq(struct ifcvf_hw *vf)
 	return 0;
 }
 
-static int ifcvf_start_datapath(void *private)
+static int ifcvf_start_datapath(struct ifcvf_adapter *adapter)
 {
-	struct ifcvf_hw *vf = ifcvf_private_to_vf(private);
+	struct ifcvf_hw *vf = adapter->vf;
 	u8 status;
 	int ret;
 
@@ -363,9 +363,10 @@ static int ifcvf_start_datapath(void *private)
 	return ret;
 }
 
-static int ifcvf_stop_datapath(void *private)
+static int ifcvf_stop_datapath(struct ifcvf_adapter *adapter)
 {
-	struct ifcvf_hw *vf = ifcvf_private_to_vf(private);
+
+	struct ifcvf_hw *vf = adapter->vf;
 	int i;
 
 	for (i = 0; i < vf->nr_vring; i++)
@@ -378,7 +379,7 @@ static int ifcvf_stop_datapath(void *private)
 
 static void ifcvf_reset_vring(struct ifcvf_adapter *adapter)
 {
-	struct ifcvf_hw *vf = ifcvf_private_to_vf(adapter);
+	struct ifcvf_hw *vf = adapter->vf;
 	int i;
 
 	for (i = 0; i < vf->nr_vring; i++) {
@@ -403,7 +404,7 @@ static struct ifcvf_hw *vdpa_to_vf(struct vdpa_device *vdpa_dev)
 {
 	struct ifcvf_adapter *adapter = vdpa_to_adapter(vdpa_dev);
 
-	return &adapter->vf;
+	return adapter->vf;
 }
 
 static u64 ifcvf_vdpa_get_device_features(struct vdpa_device *vdpa_dev)
@@ -747,12 +748,20 @@ static int ifcvf_vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name,
 	int ret;
 
 	ifcvf_mgmt_dev = container_of(mdev, struct ifcvf_vdpa_mgmt_dev, mdev);
-	if (!ifcvf_mgmt_dev->adapter)
-		return -EOPNOTSUPP;
+	vf = &ifcvf_mgmt_dev->vf;
+	pdev = vf->pdev;
+	adapter = vdpa_alloc_device(struct ifcvf_adapter, vdpa,
+				    &pdev->dev, &ifc_vdpa_ops, 1, 1, NULL, false);
+	if (IS_ERR(adapter)) {
+		IFCVF_ERR(pdev, "Failed to allocate vDPA structure");
+		return PTR_ERR(adapter);
+	}
 
-	adapter = ifcvf_mgmt_dev->adapter;
-	vf = &adapter->vf;
-	pdev = adapter->pdev;
+	ifcvf_mgmt_dev->adapter = adapter;
+	adapter->pdev = pdev;
+	adapter->vdpa.dma_dev = &pdev->dev;
+	adapter->vdpa.mdev = mdev;
+	adapter->vf = vf;
 	vdpa_dev = &adapter->vdpa;
 
 	if (name)
@@ -770,7 +779,6 @@ static int ifcvf_vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name,
 	return 0;
 }
 
-
 static void ifcvf_vdpa_dev_del(struct vdpa_mgmt_dev *mdev, struct vdpa_device *dev)
 {
 	struct ifcvf_vdpa_mgmt_dev *ifcvf_mgmt_dev;
@@ -789,7 +797,6 @@ static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct ifcvf_vdpa_mgmt_dev *ifcvf_mgmt_dev;
 	struct device *dev = &pdev->dev;
-	struct ifcvf_adapter *adapter;
 	struct ifcvf_hw *vf;
 	u32 dev_type;
 	int ret, i;
@@ -820,21 +827,16 @@ static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 
 	pci_set_master(pdev);
-
-	adapter = vdpa_alloc_device(struct ifcvf_adapter, vdpa,
-				    dev, &ifc_vdpa_ops, 1, 1, NULL, false);
-	if (IS_ERR(adapter)) {
-		IFCVF_ERR(pdev, "Failed to allocate vDPA structure");
-		return PTR_ERR(adapter);
+	ifcvf_mgmt_dev = kzalloc(sizeof(struct ifcvf_vdpa_mgmt_dev), GFP_KERNEL);
+	if (!ifcvf_mgmt_dev) {
+		IFCVF_ERR(pdev, "Failed to alloc memory for the vDPA management device\n");
+		return -ENOMEM;
 	}
 
-	vf = &adapter->vf;
+	vf = &ifcvf_mgmt_dev->vf;
 	vf->dev_type = get_dev_type(pdev);
 	vf->base = pcim_iomap_table(pdev);
 
-	adapter->pdev = pdev;
-	adapter->vdpa.dma_dev = &pdev->dev;
-
 	ret = ifcvf_init_hw(vf, pdev);
 	if (ret) {
 		IFCVF_ERR(pdev, "Failed to init IFCVF hw\n");
@@ -847,15 +849,8 @@ static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	vf->hw_features = ifcvf_get_hw_features(vf);
 	vf->config_size = ifcvf_get_config_size(vf);
 
-	ifcvf_mgmt_dev = kzalloc(sizeof(struct ifcvf_vdpa_mgmt_dev), GFP_KERNEL);
-	if (!ifcvf_mgmt_dev) {
-		IFCVF_ERR(pdev, "Failed to alloc memory for the vDPA management device\n");
-		return -ENOMEM;
-	}
-
 	ifcvf_mgmt_dev->mdev.ops = &ifcvf_vdpa_mgmt_dev_ops;
 	ifcvf_mgmt_dev->mdev.device = dev;
-	ifcvf_mgmt_dev->adapter = adapter;
 
 	dev_type = get_dev_type(pdev);
 	switch (dev_type) {
@@ -874,9 +869,6 @@ static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	ifcvf_mgmt_dev->mdev.max_supported_vqs = vf->nr_vring;
 	ifcvf_mgmt_dev->mdev.supported_features = vf->hw_features;
 
-	adapter->vdpa.mdev = &ifcvf_mgmt_dev->mdev;
-
-
 	ret = vdpa_mgmtdev_register(&ifcvf_mgmt_dev->mdev);
 	if (ret) {
 		IFCVF_ERR(pdev,
-- 
2.31.1

