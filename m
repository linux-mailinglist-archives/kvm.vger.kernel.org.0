Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C43187AA4E3
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 00:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232383AbjIUWZg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 18:25:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233065AbjIUWZ0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 18:25:26 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2089.outbound.protection.outlook.com [40.107.95.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F8C87ED9
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:10:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E+1UZzgEmwdCfBRz13Xtucxt2yUOT7xswz1fkF+KqAg1ZK7vzFl49xKmd1koPgjuA0Ccz5qpMd7jqEMQyQzW/8MHUmbbFIQCKf43ZeNtCYJiB17AqFTEFRMUG97pu4JEa/AzHY1BV40iNsX9EEe2X6pPFNrM+Gbo0cnu6jfee4s2pKPG84yGYxCjJnf5bRjpKUv7KY6z6mv7lRLdbYn6n1s/cSNJtq/eq8Fa8jg1EzpFsQOhqpDdgOs1eQ1/zSJ4lMEEy8+7QuUI3Moz3+CZhUeFEzYoFtgbb6/eu1FNUKycqrZvEWrPyz5GZfwT3KWtfGyloIAHQ5SoYM6McFJlcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JK2zh36R8kbTFn+NXcxUpq2M2SXdLc9/Z6K659NDZ8s=;
 b=jctt/o2gs/RjDTkcc/DwbuXkDjAwVSo2BzQWHJs92upUBFyqN92VTxNFxQ+E7Ug0wfFL2Qd1JxiNF8evoaaGhfyNq0kGejUMxVmKbK5Q+e/J0KA7iP2KrXi9vYmFfCgkw08L/zFXDi9ZP9ojUPzqLU0bLrMJKyZOh+XrnciYof9ooZ3WVONVkl/IKA1EPMUhjbFy80reSCQUol5fIDFqNC2bmknS6QuZgH0GYMXX9JEzG73Q3Tojohbpe3i6kRTJGfgRkv3iaim9drYbMDdCcLJgCMeGU64CpDe5Zfqp0qssil0wU0dQUwhmF4McwYfV2bSSDOLutpif6VYGEeGOOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JK2zh36R8kbTFn+NXcxUpq2M2SXdLc9/Z6K659NDZ8s=;
 b=eFDQ75uEfRnLNXG5f3wzGtNHKSTNY/JANb3BnChuru71oK/Rgpr51dF7aXmghYedkP5afO1SFmzEUi6mYHpQdC8rpqJFogNamIIZNJqP7ZUGNaxsiFQT0R8slssGpx9osTAZjOMXBTPIF6owaES9GnUcZeCTGgBXXz6HJ5HIMFA28adekUwKnmNDlJxXGDSlZ5sueB1TGh/XOVB+wnzg90vWiYSUqc1+K+brLMS7ksEr/6EKt8CrTnBGAzbbpI1jV5lXv4efkbFuf1YroPb4AKvU7ZXCpVyUZeuouCQ/3L1SR+zKKCgvBXG79XTqnwvetNUFkdEalC+RTEgmPy0VAw==
Received: from CH0PR03CA0295.namprd03.prod.outlook.com (2603:10b6:610:e6::30)
 by LV8PR12MB9406.namprd12.prod.outlook.com (2603:10b6:408:20b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.28; Thu, 21 Sep
 2023 12:41:47 +0000
Received: from DS3PEPF000099D8.namprd04.prod.outlook.com
 (2603:10b6:610:e6:cafe::a6) by CH0PR03CA0295.outlook.office365.com
 (2603:10b6:610:e6::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.30 via Frontend
 Transport; Thu, 21 Sep 2023 12:41:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS3PEPF000099D8.mail.protection.outlook.com (10.167.17.9) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6792.20 via Frontend Transport; Thu, 21 Sep 2023 12:41:47 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 21 Sep
 2023 05:41:35 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 21 Sep
 2023 05:41:35 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.41 via Frontend Transport; Thu, 21 Sep
 2023 05:41:31 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <mst@redhat.com>,
        <jasowang@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH vfio 03/11] virtio-pci: Introduce admin virtqueue
Date:   Thu, 21 Sep 2023 15:40:32 +0300
Message-ID: <20230921124040.145386-4-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20230921124040.145386-1-yishaih@nvidia.com>
References: <20230921124040.145386-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D8:EE_|LV8PR12MB9406:EE_
X-MS-Office365-Filtering-Correlation-Id: 13a745e0-97d3-400b-960e-08dbbaa01e7e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VONSuuVb6yccA92UtoSfoc2Sh0v+8QsEKD3ednqGgHyFlLn08RPSX2CYgw1UbSrPPbMHWPDEf72oS2HALsbHbQldxlX/gS5MbNOetd1MUiXrHbrq6Lfyj1p52pMt3GxlKBi6Hr1/t0uQaARhmkADB2gehJoWyuAwXMU65+6ZB5qISAJVjnFzAm9aFtnuRW0pWyoPCrxmqAFtZdVrxBMNegUq9HgNaK/w4sgnZZVWbkraMRcAT/EeepZrlszG3IdpAWHOgxA93m/Wz/czoetQACGDRx8UHuJ6njL1QWjdZ4g1QmVf32vETBwXJtGrQsJTL1oVHNlS0NOR23isHUxkejVTEAw9yc3+bgNcGuKe/GtVVck2l8GKLudFjmUWXj7DR2wfj4y4tE8WBJvLt9eEadC7mhLoJDYUkgABYtPC3xXEZvZVR3Ii/3gBT4GUrfq96CY8UG96eDig/jRdoeMyFjyX+/8vPux5M0FBA350GCN0i48fjB+gxzLaTcXBnyWILjZ5BeogoJsPaZeebO4mmEc7ZK4F7QLpWty9IvRcAywAqfmwsnEL7ykM+LLdTy5QX3OKl703uXf79Y0ru51TUW1kQ6yp2il4fIi++XSZPVYsYaum9aEi6lu2stKxu5q2fP2VasK29FFUK4YxXgf4ss8+QLRnF28zTaXStyulE6Ou2QhP57mvfSWy84lds2ZNSu/CWMmTeQTuMW4e4PqeZTc3odBxlEjvbb9v8B8r+BE2ninwd6SC9ZJ2DZKECWCeWHZZAQenCeg/3nX/OHsoXA==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(376002)(396003)(39860400002)(346002)(82310400011)(186009)(1800799009)(451199024)(46966006)(36840700001)(40470700004)(70206006)(7696005)(36860700001)(82740400003)(86362001)(70586007)(41300700001)(356005)(110136005)(54906003)(6636002)(478600001)(316002)(7636003)(107886003)(1076003)(8936002)(4326008)(8676002)(36756003)(40460700003)(26005)(47076005)(30864003)(336012)(426003)(5660300002)(40480700001)(2906002)(2616005)(83380400001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2023 12:41:47.0484
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 13a745e0-97d3-400b-960e-08dbbaa01e7e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS3PEPF000099D8.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9406
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Feng Liu <feliu@nvidia.com>

Introduce support for the admin virtqueue. By negotiating
VIRTIO_F_ADMIN_VQ feature, driver detects capability and creates one
administration virtqueue. Administration virtqueue implementation in
virtio pci generic layer, enables multiple types of upper layer
drivers such as vfio, net, blk to utilize it.

Signed-off-by: Feng Liu <feliu@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/virtio/Makefile                |  2 +-
 drivers/virtio/virtio.c                | 37 +++++++++++++--
 drivers/virtio/virtio_pci_common.h     | 15 +++++-
 drivers/virtio/virtio_pci_modern.c     | 10 +++-
 drivers/virtio/virtio_pci_modern_avq.c | 65 ++++++++++++++++++++++++++
 include/linux/virtio_config.h          |  4 ++
 include/linux/virtio_pci_modern.h      |  3 ++
 7 files changed, 129 insertions(+), 7 deletions(-)
 create mode 100644 drivers/virtio/virtio_pci_modern_avq.c

diff --git a/drivers/virtio/Makefile b/drivers/virtio/Makefile
index 8e98d24917cc..dcc535b5b4d9 100644
--- a/drivers/virtio/Makefile
+++ b/drivers/virtio/Makefile
@@ -5,7 +5,7 @@ obj-$(CONFIG_VIRTIO_PCI_LIB) += virtio_pci_modern_dev.o
 obj-$(CONFIG_VIRTIO_PCI_LIB_LEGACY) += virtio_pci_legacy_dev.o
 obj-$(CONFIG_VIRTIO_MMIO) += virtio_mmio.o
 obj-$(CONFIG_VIRTIO_PCI) += virtio_pci.o
-virtio_pci-y := virtio_pci_modern.o virtio_pci_common.o
+virtio_pci-y := virtio_pci_modern.o virtio_pci_common.o virtio_pci_modern_avq.o
 virtio_pci-$(CONFIG_VIRTIO_PCI_LEGACY) += virtio_pci_legacy.o
 obj-$(CONFIG_VIRTIO_BALLOON) += virtio_balloon.o
 obj-$(CONFIG_VIRTIO_INPUT) += virtio_input.o
diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index 3893dc29eb26..f4080692b351 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -302,9 +302,15 @@ static int virtio_dev_probe(struct device *_d)
 	if (err)
 		goto err;
 
+	if (dev->config->create_avq) {
+		err = dev->config->create_avq(dev);
+		if (err)
+			goto err;
+	}
+
 	err = drv->probe(dev);
 	if (err)
-		goto err;
+		goto err_probe;
 
 	/* If probe didn't do it, mark device DRIVER_OK ourselves. */
 	if (!(dev->config->get_status(dev) & VIRTIO_CONFIG_S_DRIVER_OK))
@@ -316,6 +322,10 @@ static int virtio_dev_probe(struct device *_d)
 	virtio_config_enable(dev);
 
 	return 0;
+
+err_probe:
+	if (dev->config->destroy_avq)
+		dev->config->destroy_avq(dev);
 err:
 	virtio_add_status(dev, VIRTIO_CONFIG_S_FAILED);
 	return err;
@@ -331,6 +341,9 @@ static void virtio_dev_remove(struct device *_d)
 
 	drv->remove(dev);
 
+	if (dev->config->destroy_avq)
+		dev->config->destroy_avq(dev);
+
 	/* Driver should have reset device. */
 	WARN_ON_ONCE(dev->config->get_status(dev));
 
@@ -489,13 +502,20 @@ EXPORT_SYMBOL_GPL(unregister_virtio_device);
 int virtio_device_freeze(struct virtio_device *dev)
 {
 	struct virtio_driver *drv = drv_to_virtio(dev->dev.driver);
+	int ret;
 
 	virtio_config_disable(dev);
 
 	dev->failed = dev->config->get_status(dev) & VIRTIO_CONFIG_S_FAILED;
 
-	if (drv && drv->freeze)
-		return drv->freeze(dev);
+	if (drv && drv->freeze) {
+		ret = drv->freeze(dev);
+		if (ret)
+			return ret;
+	}
+
+	if (dev->config->destroy_avq)
+		dev->config->destroy_avq(dev);
 
 	return 0;
 }
@@ -532,10 +552,16 @@ int virtio_device_restore(struct virtio_device *dev)
 	if (ret)
 		goto err;
 
+	if (dev->config->create_avq) {
+		ret = dev->config->create_avq(dev);
+		if (ret)
+			goto err;
+	}
+
 	if (drv->restore) {
 		ret = drv->restore(dev);
 		if (ret)
-			goto err;
+			goto err_restore;
 	}
 
 	/* If restore didn't do it, mark device DRIVER_OK ourselves. */
@@ -546,6 +572,9 @@ int virtio_device_restore(struct virtio_device *dev)
 
 	return 0;
 
+err_restore:
+	if (dev->config->destroy_avq)
+		dev->config->destroy_avq(dev);
 err:
 	virtio_add_status(dev, VIRTIO_CONFIG_S_FAILED);
 	return ret;
diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virtio_pci_common.h
index 602021967aaa..9bffa95274b6 100644
--- a/drivers/virtio/virtio_pci_common.h
+++ b/drivers/virtio/virtio_pci_common.h
@@ -41,6 +41,14 @@ struct virtio_pci_vq_info {
 	unsigned int msix_vector;
 };
 
+struct virtio_avq {
+	/* Virtqueue info associated with this admin queue. */
+	struct virtio_pci_vq_info info;
+	/* Name of the admin queue: avq.$index. */
+	char name[10];
+	u16 vq_index;
+};
+
 /* Our device structure */
 struct virtio_pci_device {
 	struct virtio_device vdev;
@@ -58,10 +66,13 @@ struct virtio_pci_device {
 	spinlock_t lock;
 	struct list_head virtqueues;
 
-	/* array of all queues for house-keeping */
+	/* Array of all virtqueues reported in the
+	 * PCI common config num_queues field
+	 */
 	struct virtio_pci_vq_info **vqs;
 	u32 nvqs;
 
+	struct virtio_avq *admin;
 	/* MSI-X support */
 	int msix_enabled;
 	int intx_enabled;
@@ -115,6 +126,8 @@ int vp_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
 		const char * const names[], const bool *ctx,
 		struct irq_affinity *desc);
 const char *vp_bus_name(struct virtio_device *vdev);
+void vp_destroy_avq(struct virtio_device *vdev);
+int vp_create_avq(struct virtio_device *vdev);
 
 /* Setup the affinity for a virtqueue:
  * - force the affinity for per vq vector
diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index d6bb68ba84e5..a72c87687196 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -37,6 +37,9 @@ static void vp_transport_features(struct virtio_device *vdev, u64 features)
 
 	if (features & BIT_ULL(VIRTIO_F_RING_RESET))
 		__virtio_set_bit(vdev, VIRTIO_F_RING_RESET);
+
+	if (features & BIT_ULL(VIRTIO_F_ADMIN_VQ))
+		__virtio_set_bit(vdev, VIRTIO_F_ADMIN_VQ);
 }
 
 /* virtio config->finalize_features() implementation */
@@ -317,7 +320,8 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
 	else
 		notify = vp_notify;
 
-	if (index >= vp_modern_get_num_queues(mdev))
+	if (!((index < vp_modern_get_num_queues(mdev) ||
+	      (vp_dev->admin && vp_dev->admin->vq_index == index))))
 		return ERR_PTR(-EINVAL);
 
 	/* Check if queue is either not available or already active. */
@@ -509,6 +513,8 @@ static const struct virtio_config_ops virtio_pci_config_nodev_ops = {
 	.get_shm_region  = vp_get_shm_region,
 	.disable_vq_and_reset = vp_modern_disable_vq_and_reset,
 	.enable_vq_after_reset = vp_modern_enable_vq_after_reset,
+	.create_avq = vp_create_avq,
+	.destroy_avq = vp_destroy_avq,
 };
 
 static const struct virtio_config_ops virtio_pci_config_ops = {
@@ -529,6 +535,8 @@ static const struct virtio_config_ops virtio_pci_config_ops = {
 	.get_shm_region  = vp_get_shm_region,
 	.disable_vq_and_reset = vp_modern_disable_vq_and_reset,
 	.enable_vq_after_reset = vp_modern_enable_vq_after_reset,
+	.create_avq = vp_create_avq,
+	.destroy_avq = vp_destroy_avq,
 };
 
 /* the PCI probing function */
diff --git a/drivers/virtio/virtio_pci_modern_avq.c b/drivers/virtio/virtio_pci_modern_avq.c
new file mode 100644
index 000000000000..114579ad788f
--- /dev/null
+++ b/drivers/virtio/virtio_pci_modern_avq.c
@@ -0,0 +1,65 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include <linux/virtio.h>
+#include "virtio_pci_common.h"
+
+static u16 vp_modern_avq_num(struct virtio_pci_modern_device *mdev)
+{
+	struct virtio_pci_modern_common_cfg __iomem *cfg;
+
+	cfg = (struct virtio_pci_modern_common_cfg __iomem *)mdev->common;
+	return vp_ioread16(&cfg->admin_queue_num);
+}
+
+static u16 vp_modern_avq_index(struct virtio_pci_modern_device *mdev)
+{
+	struct virtio_pci_modern_common_cfg __iomem *cfg;
+
+	cfg = (struct virtio_pci_modern_common_cfg __iomem *)mdev->common;
+	return vp_ioread16(&cfg->admin_queue_index);
+}
+
+int vp_create_avq(struct virtio_device *vdev)
+{
+	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
+	struct virtio_avq *avq;
+	struct virtqueue *vq;
+	u16 admin_q_num;
+
+	if (!virtio_has_feature(vdev, VIRTIO_F_ADMIN_VQ))
+		return 0;
+
+	admin_q_num = vp_modern_avq_num(&vp_dev->mdev);
+	if (!admin_q_num)
+		return -EINVAL;
+
+	vp_dev->admin = kzalloc(sizeof(*vp_dev->admin), GFP_KERNEL);
+	if (!vp_dev->admin)
+		return -ENOMEM;
+
+	avq = vp_dev->admin;
+	avq->vq_index = vp_modern_avq_index(&vp_dev->mdev);
+	sprintf(avq->name, "avq.%u", avq->vq_index);
+	vq = vp_dev->setup_vq(vp_dev, &vp_dev->admin->info, avq->vq_index, NULL,
+			      avq->name, NULL, VIRTIO_MSI_NO_VECTOR);
+	if (IS_ERR(vq)) {
+		dev_err(&vdev->dev, "failed to setup admin virtqueue");
+		kfree(vp_dev->admin);
+		return PTR_ERR(vq);
+	}
+
+	vp_dev->admin->info.vq = vq;
+	vp_modern_set_queue_enable(&vp_dev->mdev, avq->info.vq->index, true);
+	return 0;
+}
+
+void vp_destroy_avq(struct virtio_device *vdev)
+{
+	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
+
+	if (!vp_dev->admin)
+		return;
+
+	vp_dev->del_vq(&vp_dev->admin->info);
+	kfree(vp_dev->admin);
+}
diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index 2b3438de2c4d..028c51ea90ee 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -93,6 +93,8 @@ typedef void vq_callback_t(struct virtqueue *);
  *	Returns 0 on success or error status
  *	If disable_vq_and_reset is set, then enable_vq_after_reset must also be
  *	set.
+ * @create_avq: initialize admin virtqueue resource.
+ * @destroy_avq: destroy admin virtqueue resource.
  */
 struct virtio_config_ops {
 	void (*get)(struct virtio_device *vdev, unsigned offset,
@@ -120,6 +122,8 @@ struct virtio_config_ops {
 			       struct virtio_shm_region *region, u8 id);
 	int (*disable_vq_and_reset)(struct virtqueue *vq);
 	int (*enable_vq_after_reset)(struct virtqueue *vq);
+	int (*create_avq)(struct virtio_device *vdev);
+	void (*destroy_avq)(struct virtio_device *vdev);
 };
 
 /* If driver didn't advertise the feature, it will never appear. */
diff --git a/include/linux/virtio_pci_modern.h b/include/linux/virtio_pci_modern.h
index 067ac1d789bc..f6cb13d858fd 100644
--- a/include/linux/virtio_pci_modern.h
+++ b/include/linux/virtio_pci_modern.h
@@ -10,6 +10,9 @@ struct virtio_pci_modern_common_cfg {
 
 	__le16 queue_notify_data;	/* read-write */
 	__le16 queue_reset;		/* read-write */
+
+	__le16 admin_queue_index;	/* read-only */
+	__le16 admin_queue_num;		/* read-only */
 };
 
 struct virtio_pci_modern_device {
-- 
2.27.0

