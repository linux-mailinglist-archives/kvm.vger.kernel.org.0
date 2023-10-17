Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03DBC7CC4F8
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 15:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343950AbjJQNnP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 09:43:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343839AbjJQNnN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 09:43:13 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2058.outbound.protection.outlook.com [40.107.220.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 928DEF2
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 06:43:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nmXRWhSOo8xC6lMRX31n759o8mSfXqqQuRvtd+vaaG2t7Pbb1kalGCI6Y7PtPO+3Mj9CgWMW9JtleR5JXiHDD+j1K2Wto8ZC7xX+auqXg/ydtwGBK5axkEw7jqlZi9IxXWGGrauBn5+Y8wZJUhHN393gJ/HAogwt/TvbMt5QfES8dQvwUjFLunDFXtmL7m0VDWIarf5TwncUXjzYluKlzlxtZinTLJzMHa1x+3vsREucu+P6223c5t2WzVRBFo40hrxH2Ye6hAcjl3vxDecUjZYCQ2ahSLSSFUOtLWzicmG//VAcoDVsmx0xF5pZJZF3Mb5gV8fiJAtUVavTgP6mJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F3TmeCZouup/mdxqBPtO8EKG/rC6K6Kpbqo587Uue6o=;
 b=DkW8Vx5WXpVh7MB9OO1PtwawrhR06ElhdykaFUJhu+4YFPTcU2aFEQ5tWPvTGJF32oqkHdsC222v9Y3BdgbTbmu+F5D+K3jUUJa99nFhY6nN3DZVbv2NDHHUNd8gVbf0V9STUpwUu/JQgbUIHagICRzAq8x3m4lJzet1RCWjdivl9MJKqKEP22Vq4OPwg/cKTsdH6UWm6UInLwnEDuv7Gha6fabrUsVbjOtiCZP9FOfkwUl+DttnzlBvHFBonBu4gLd4shYzRs6bf6KJVoo23IsB6mnx/yGiffudm11vXZkht6QXWUc+jUzqFp/bneyjKUUzsDdyZIZ7E/4dBohNTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F3TmeCZouup/mdxqBPtO8EKG/rC6K6Kpbqo587Uue6o=;
 b=pDGFoDbEC0sZJK+Iw/nQc2xUmP43R9UDLjlsdGx39AC5GRF0AMTXUZE4IkN8sRfeDQST/O5BWZTVw5Xt+cbXV0Oyk1qYsOFKZFBx7uaxvSbOWJ2vn9mLRtBxyUPKpzi4x0g1Fn78bfNUZqzE21LXRibzY3OwlRBeoLpK+5Dfy+6l2rCkoBQ0IIJ2LEKUMuUjMA3QzCTENEAVFMnXKPFCrMye4xgVd3m9jon64e+o4VROLryfydxtRnY6S/zKTWbYPlrQ2uiUwY/fC30MyYxracEdJb8eSWQrN+F+LG785YngAOsilTddUBzENRVJqLYsMN2vWPlYSXEVG6WvgKmBlQ==
Received: from MN2PR20CA0061.namprd20.prod.outlook.com (2603:10b6:208:235::30)
 by IA0PR12MB8207.namprd12.prod.outlook.com (2603:10b6:208:401::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35; Tue, 17 Oct
 2023 13:43:09 +0000
Received: from BL02EPF0001A108.namprd05.prod.outlook.com
 (2603:10b6:208:235:cafe::ce) by MN2PR20CA0061.outlook.office365.com
 (2603:10b6:208:235::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.37 via Frontend
 Transport; Tue, 17 Oct 2023 13:43:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL02EPF0001A108.mail.protection.outlook.com (10.167.241.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6907.20 via Frontend Transport; Tue, 17 Oct 2023 13:43:08 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 17 Oct
 2023 06:42:54 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 17 Oct
 2023 06:42:53 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.41 via Frontend Transport; Tue, 17 Oct
 2023 06:42:50 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <mst@redhat.com>,
        <jasowang@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <si-wei.liu@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
        <maorg@nvidia.com>
Subject: [PATCH V1 vfio 3/9] virtio-pci: Introduce admin virtqueue
Date:   Tue, 17 Oct 2023 16:42:11 +0300
Message-ID: <20231017134217.82497-4-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20231017134217.82497-1-yishaih@nvidia.com>
References: <20231017134217.82497-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A108:EE_|IA0PR12MB8207:EE_
X-MS-Office365-Filtering-Correlation-Id: b7ba8629-9765-4445-c698-08dbcf16ffc7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rtQ4oWz1e0Y3lksEXm+Tohs1t64UaikLD6wsz6dw28pTMWSpNF3RUPUm4q7d+coyjdLR49M6RDfMlHJMMEOO4tNs3B0/9bXRVIRO8YVsmpLSfv5PrHFGOhthwHINa9TW43aFvNwTthBBS0ev05YNP8wdKJOOYcvnrsCaxGgybaa4uLx9DjKomTb7BRpoWI3WCDpXCSJEpG+dI9EopickhNnau8heSLwvw6RUTpKzI6iHxGOzjmBoA96JzUmH0OL4b6dcHGNz1D0Z0z1NFI2lx29jotBqdY3Xw84VjQb7UO7TJ5M1YbvYbGNwvZoADkAFNboSurWykVmb35wOv5SFfb7bpX9pg0wQFAvLo3ZSVwHAueb6xRvBpV3jxP7ytKmu08+tFyvV64DO8ZTUtU+n/jrpaaWHkyFZ32prQ3IcMZ3NrXrv1rF9d7SOV3HcwRZDgIGOl0uyxwGqYa8FIUpa3IeG4kQqtCEad0nlLgK9g8Yf5ZHX+ylPErjjiF7VnH5GtZEr3y9Qp9lLuM5AZJobJ1KG6Gg20sPWXZrG/LL8sLAIQTTY/xus6cVfu8XNjieebdGtoRPFrFfSsZAj7eeu3n/Z7pMcMCiPp1NcZJ1QDp7++eziA1Th6VkA3Vz3rFExqo6bu8jag+RxftNmk7yZe1igabEhvFzoPPczzPLaoXYEPtjn7HcKirdaFi5GPktX8IhMcWPYYYJEZwfo+L8zp7O9wMF5wWPQ0UNMLn32vRsWoCNxfOrceJvXwHMucrok
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(346002)(39860400002)(396003)(376002)(136003)(230922051799003)(451199024)(64100799003)(82310400011)(1800799009)(186009)(36840700001)(40470700004)(46966006)(336012)(40460700003)(40480700001)(82740400003)(36756003)(356005)(47076005)(83380400001)(36860700001)(6666004)(7636003)(26005)(7696005)(2906002)(54906003)(316002)(6636002)(70206006)(1076003)(426003)(2616005)(70586007)(478600001)(107886003)(110136005)(86362001)(41300700001)(8936002)(30864003)(8676002)(4326008)(5660300002)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2023 13:43:08.8538
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b7ba8629-9765-4445-c698-08dbcf16ffc7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF0001A108.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8207
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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
 drivers/virtio/virtio.c                | 37 ++++++++++++++--
 drivers/virtio/virtio_pci_common.c     |  3 ++
 drivers/virtio/virtio_pci_common.h     | 15 ++++++-
 drivers/virtio/virtio_pci_modern.c     | 61 +++++++++++++++++++++++++-
 drivers/virtio/virtio_pci_modern_dev.c | 18 ++++++++
 include/linux/virtio_config.h          |  4 ++
 include/linux/virtio_pci_modern.h      |  5 +++
 7 files changed, 137 insertions(+), 6 deletions(-)

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
diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
index c2524a7207cf..6b4766d5abe6 100644
--- a/drivers/virtio/virtio_pci_common.c
+++ b/drivers/virtio/virtio_pci_common.c
@@ -236,6 +236,9 @@ void vp_del_vqs(struct virtio_device *vdev)
 	int i;
 
 	list_for_each_entry_safe(vq, n, &vdev->vqs, list) {
+		if (vp_dev->is_avq(vdev, vq->index))
+			continue;
+
 		if (vp_dev->per_vq_vectors) {
 			int v = vp_dev->vqs[vq->index]->msix_vector;
 
diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virtio_pci_common.h
index 4b773bd7c58c..e03af0966a4b 100644
--- a/drivers/virtio/virtio_pci_common.h
+++ b/drivers/virtio/virtio_pci_common.h
@@ -41,6 +41,14 @@ struct virtio_pci_vq_info {
 	unsigned int msix_vector;
 };
 
+struct virtio_pci_admin_vq {
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
@@ -58,9 +66,13 @@ struct virtio_pci_device {
 	spinlock_t lock;
 	struct list_head virtqueues;
 
-	/* array of all queues for house-keeping */
+	/* Array of all virtqueues reported in the
+	 * PCI common config num_queues field
+	 */
 	struct virtio_pci_vq_info **vqs;
 
+	struct virtio_pci_admin_vq admin_vq;
+
 	/* MSI-X support */
 	int msix_enabled;
 	int intx_enabled;
@@ -86,6 +98,7 @@ struct virtio_pci_device {
 	void (*del_vq)(struct virtio_pci_vq_info *info);
 
 	u16 (*config_vector)(struct virtio_pci_device *vp_dev, u16 vector);
+	bool (*is_avq)(struct virtio_device *vdev, unsigned int index);
 };
 
 /* Constants for MSI-X */
diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index d6bb68ba84e5..01c5ba346471 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -26,6 +26,16 @@ static u64 vp_get_features(struct virtio_device *vdev)
 	return vp_modern_get_features(&vp_dev->mdev);
 }
 
+static bool vp_is_avq(struct virtio_device *vdev, unsigned int index)
+{
+	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
+
+	if (!virtio_has_feature(vdev, VIRTIO_F_ADMIN_VQ))
+		return false;
+
+	return index == vp_dev->admin_vq.vq_index;
+}
+
 static void vp_transport_features(struct virtio_device *vdev, u64 features)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
@@ -37,6 +47,9 @@ static void vp_transport_features(struct virtio_device *vdev, u64 features)
 
 	if (features & BIT_ULL(VIRTIO_F_RING_RESET))
 		__virtio_set_bit(vdev, VIRTIO_F_RING_RESET);
+
+	if (features & BIT_ULL(VIRTIO_F_ADMIN_VQ))
+		__virtio_set_bit(vdev, VIRTIO_F_ADMIN_VQ);
 }
 
 /* virtio config->finalize_features() implementation */
@@ -317,7 +330,8 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
 	else
 		notify = vp_notify;
 
-	if (index >= vp_modern_get_num_queues(mdev))
+	if (index >= vp_modern_get_num_queues(mdev) &&
+	    !vp_is_avq(&vp_dev->vdev, index))
 		return ERR_PTR(-EINVAL);
 
 	/* Check if queue is either not available or already active. */
@@ -491,6 +505,46 @@ static bool vp_get_shm_region(struct virtio_device *vdev,
 	return true;
 }
 
+static int vp_modern_create_avq(struct virtio_device *vdev)
+{
+	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
+	struct virtio_pci_admin_vq *avq;
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
+	avq = &vp_dev->admin_vq;
+	avq->vq_index = vp_modern_avq_index(&vp_dev->mdev);
+	sprintf(avq->name, "avq.%u", avq->vq_index);
+	vq = vp_dev->setup_vq(vp_dev, &vp_dev->admin_vq.info, avq->vq_index, NULL,
+			      avq->name, NULL, VIRTIO_MSI_NO_VECTOR);
+	if (IS_ERR(vq)) {
+		dev_err(&vdev->dev, "failed to setup admin virtqueue, err=%ld",
+			PTR_ERR(vq));
+		return PTR_ERR(vq);
+	}
+
+	vp_dev->admin_vq.info.vq = vq;
+	vp_modern_set_queue_enable(&vp_dev->mdev, avq->info.vq->index, true);
+	return 0;
+}
+
+static void vp_modern_destroy_avq(struct virtio_device *vdev)
+{
+	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
+
+	if (!virtio_has_feature(vdev, VIRTIO_F_ADMIN_VQ))
+		return;
+
+	vp_dev->del_vq(&vp_dev->admin_vq.info);
+}
+
 static const struct virtio_config_ops virtio_pci_config_nodev_ops = {
 	.get		= NULL,
 	.set		= NULL,
@@ -509,6 +563,8 @@ static const struct virtio_config_ops virtio_pci_config_nodev_ops = {
 	.get_shm_region  = vp_get_shm_region,
 	.disable_vq_and_reset = vp_modern_disable_vq_and_reset,
 	.enable_vq_after_reset = vp_modern_enable_vq_after_reset,
+	.create_avq = vp_modern_create_avq,
+	.destroy_avq = vp_modern_destroy_avq,
 };
 
 static const struct virtio_config_ops virtio_pci_config_ops = {
@@ -529,6 +585,8 @@ static const struct virtio_config_ops virtio_pci_config_ops = {
 	.get_shm_region  = vp_get_shm_region,
 	.disable_vq_and_reset = vp_modern_disable_vq_and_reset,
 	.enable_vq_after_reset = vp_modern_enable_vq_after_reset,
+	.create_avq = vp_modern_create_avq,
+	.destroy_avq = vp_modern_destroy_avq,
 };
 
 /* the PCI probing function */
@@ -552,6 +610,7 @@ int virtio_pci_modern_probe(struct virtio_pci_device *vp_dev)
 	vp_dev->config_vector = vp_config_vector;
 	vp_dev->setup_vq = setup_vq;
 	vp_dev->del_vq = del_vq;
+	vp_dev->is_avq = vp_is_avq;
 	vp_dev->isr = mdev->isr;
 	vp_dev->vdev.id = mdev->id;
 
diff --git a/drivers/virtio/virtio_pci_modern_dev.c b/drivers/virtio/virtio_pci_modern_dev.c
index 7fa70d7c8146..229a32a4cb68 100644
--- a/drivers/virtio/virtio_pci_modern_dev.c
+++ b/drivers/virtio/virtio_pci_modern_dev.c
@@ -714,6 +714,24 @@ void __iomem *vp_modern_map_vq_notify(struct virtio_pci_modern_device *mdev,
 }
 EXPORT_SYMBOL_GPL(vp_modern_map_vq_notify);
 
+u16 vp_modern_avq_num(struct virtio_pci_modern_device *mdev)
+{
+	struct virtio_pci_modern_common_cfg __iomem *cfg;
+
+	cfg = (struct virtio_pci_modern_common_cfg __iomem *)mdev->common;
+	return vp_ioread16(&cfg->admin_queue_num);
+}
+EXPORT_SYMBOL_GPL(vp_modern_avq_num);
+
+u16 vp_modern_avq_index(struct virtio_pci_modern_device *mdev)
+{
+	struct virtio_pci_modern_common_cfg __iomem *cfg;
+
+	cfg = (struct virtio_pci_modern_common_cfg __iomem *)mdev->common;
+	return vp_ioread16(&cfg->admin_queue_index);
+}
+EXPORT_SYMBOL_GPL(vp_modern_avq_index);
+
 MODULE_VERSION("0.1");
 MODULE_DESCRIPTION("Modern Virtio PCI Device");
 MODULE_AUTHOR("Jason Wang <jasowang@redhat.com>");
diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index 2b3438de2c4d..da9b271b54db 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -93,6 +93,8 @@ typedef void vq_callback_t(struct virtqueue *);
  *	Returns 0 on success or error status
  *	If disable_vq_and_reset is set, then enable_vq_after_reset must also be
  *	set.
+ * @create_avq: create admin virtqueue resource.
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
index 067ac1d789bc..0f8737c9ae7d 100644
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
@@ -121,4 +124,6 @@ int vp_modern_probe(struct virtio_pci_modern_device *mdev);
 void vp_modern_remove(struct virtio_pci_modern_device *mdev);
 int vp_modern_get_queue_reset(struct virtio_pci_modern_device *mdev, u16 index);
 void vp_modern_set_queue_reset(struct virtio_pci_modern_device *mdev, u16 index);
+u16 vp_modern_avq_num(struct virtio_pci_modern_device *mdev);
+u16 vp_modern_avq_index(struct virtio_pci_modern_device *mdev);
 #endif
-- 
2.27.0

