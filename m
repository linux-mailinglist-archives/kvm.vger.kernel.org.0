Return-Path: <kvm+bounces-3673-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 19B288069E4
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 09:40:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 99FFD1F21698
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 08:40:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B74F199B6;
	Wed,  6 Dec 2023 08:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Zi3WB4od"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2053.outbound.protection.outlook.com [40.107.95.53])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B9EBD62
	for <kvm@vger.kernel.org>; Wed,  6 Dec 2023 00:40:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HEsoRA5RUDmQz5EgZrk72QzNpGl0O/gyiO5pvFUPnCrLwwHm9QPcxHZfsQl8SabrcohCk9m5PZKpzgEBtb1DCQ5f8jAdzFwEBNs+VjdLJNtLhMW8oPKG9mHePsBmlUyiizWQdWcohTSa2KsbmFHNiTHKIZIQbyXF94RGInxtgibGNRfXIEHNNYW+xZyyoVog33IIlR8VtUGnk9Ca2jukZ0xr961cjsjiw8qYSB9mlbVRRIs6y+7UcdQGNuDHpnQN64bwxm/sGLuyzGaBnfqWhxyy4ThujmYjlmZRvxU33nKSavMqIIfj3jadYtmocwllTwqxLXWXXBHlg4N+S58yTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3RORiFDPc00uy25Ez83+myQNpfqwcW4zHUp/bpHu5L8=;
 b=AbYgCAGtfOg6cRiOU9tH2fzLjYH9UimODG/eQdLS85V7tjSTCS3qxWa/xg776Z9KRLkqeZH3QF6a9+6Z8agCQEjfCP/x6FVCWvVu0ErB01+JunabXPBROjDhvx90I0bErLbj++Fj2RMEbmWK5nwxhhl2dRHkFvgaYECkqk8vmSMI2SYfHGMS3iZWMRyTtWDeWqj0CXbj/h+cpYZ3VLTua9XskVzqOwL3wjdBfSDchMJ1Ldg097AWGjKXVAp9sPBCrNVwqCmOIoiFoahBl7ISZkxzKUpRLV/QzXqgntWl4h9ZzA+wBSHW3qXVI1u7GWYk/u3C7ir46v9IwKOnmHbmtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3RORiFDPc00uy25Ez83+myQNpfqwcW4zHUp/bpHu5L8=;
 b=Zi3WB4odhkHAMz25wHXdsOH+U1FRJHluDKM2MATj1jNDeTpK5PXgiIoqEIHrkFbtLBI5p2MZUefOKwjP4YM/y/Hy8Xqg8uJDzQ/OVzT5rmH5t0pL+Lx7de5pqBpaHCevzrV3Yt7/yvULl+eOs545DA+JTashiaGxrsmXXWKUUKGFt9AD86cCKaMsa5TfXZdW6xYiliwgfJxXyQCO3kjQktkx4Z5wPkNfz2dAFpe3PHS+30BiSU55Rf17Uii1j5P61hFW+kdkrtDYaHka/vMo/K0cGrf6mfHqYa0ryknqTngEXQV4oRwEzBgfjALs0qsa1Z5EShlQFp0Pu4YsPtn1wg==
Received: from SA9PR10CA0011.namprd10.prod.outlook.com (2603:10b6:806:a7::16)
 by CH3PR12MB9025.namprd12.prod.outlook.com (2603:10b6:610:129::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Wed, 6 Dec
 2023 08:39:58 +0000
Received: from SN1PEPF0002BA4D.namprd03.prod.outlook.com
 (2603:10b6:806:a7:cafe::d7) by SA9PR10CA0011.outlook.office365.com
 (2603:10b6:806:a7::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34 via Frontend
 Transport; Wed, 6 Dec 2023 08:39:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SN1PEPF0002BA4D.mail.protection.outlook.com (10.167.242.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7068.26 via Frontend Transport; Wed, 6 Dec 2023 08:39:57 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 6 Dec 2023
 00:39:47 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 6 Dec 2023
 00:39:46 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.41 via Frontend Transport; Wed, 6 Dec
 2023 00:39:43 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V6 vfio 2/9] virtio-pci: Introduce admin virtqueue
Date: Wed, 6 Dec 2023 10:38:50 +0200
Message-ID: <20231206083857.241946-3-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20231206083857.241946-1-yishaih@nvidia.com>
References: <20231206083857.241946-1-yishaih@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA4D:EE_|CH3PR12MB9025:EE_
X-MS-Office365-Filtering-Correlation-Id: 7da9fc5e-dc5d-4b7c-0cf9-08dbf636edc6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	E7MlUQ1tGghQs7aXFPwK02VdvpqzNfzce70di0P3D29sAQI07ngn1ib+DH99jwWmCGJFgTeEmZvmMNs8BQwwD42EsSIHYSR1AOTGQh49S0Oi974fGhicjzu1+qgVLnAmbIjORUf2vyFsAwDaXvKJrTwlvN/dhb41WjX8FutcExgo41PCJpG/uuvLxk4XDliU2uUqv/u6agCEwZHMpRx1utBsOVodYqxB9bhL8cxQ/CD1EpyykJnIz+71DD+zVLf5mOiabHtD6Dmy37xkMK1yK0C2Ujm3yDtdLuScggdL1063dXlVnFdspUB2CGzakTH7u+4Xtm24LYfl1Rxm5K2RO11dyQZruAaxWo1pZeS/CZwZ21biz/zeDiFU5wnnBePQRGOmK2msJWvtaQkf8aqLO32Iv6ci55TpS77TQnOsn4zuv/Rq8M/tzUYGmZ42jZ75ApwvPM9uVzXZh9HNv8WBZg9urcI0MuJ7MMM8SnzAjMatNaduI2qk17tl5vdp4jerpr7+Nwoba85tbxyR0eRdTRiUbHDAWTFuq4M/w0ROBu2RwiVKylgixMcqCu7km/G5/85izC+L5HU0sdGX5SgZ0S+m5sSQQoiVP68Eiyw8XCX78BLvvIE9G/gbQ2fc5GsLANJqhlD6xVwDWh+i6fO4VJDLxORK6eu1jx/E9xXYgMJIVYkkH1pk8sw2GMl0+Hg1GT1AXcEH5jB5XmQzmTcLwee3JQsLRHO4NaH22L5CL74ZPgdri5pBmw9vl00t5+Lu
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(346002)(39860400002)(376002)(396003)(230922051799003)(186009)(82310400011)(64100799003)(1800799012)(451199024)(40470700004)(36840700001)(46966006)(30864003)(40480700001)(36860700001)(2906002)(316002)(110136005)(54906003)(6636002)(7636003)(70206006)(70586007)(4326008)(8676002)(86362001)(36756003)(8936002)(41300700001)(47076005)(5660300002)(82740400003)(356005)(83380400001)(478600001)(40460700003)(426003)(26005)(336012)(1076003)(107886003)(7696005)(6666004)(2616005)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 08:39:57.9497
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7da9fc5e-dc5d-4b7c-0cf9-08dbf636edc6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA4D.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9025

From: Feng Liu <feliu@nvidia.com>

Introduce support for the admin virtqueue. By negotiating
VIRTIO_F_ADMIN_VQ feature, driver detects capability and creates one
administration virtqueue. Administration virtqueue implementation in
virtio pci generic layer, enables multiple types of upper layer
drivers such as vfio, net, blk to utilize it.

Signed-off-by: Feng Liu <feliu@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/virtio/virtio.c                | 37 +++++++++++--
 drivers/virtio/virtio_pci_common.c     |  3 ++
 drivers/virtio/virtio_pci_common.h     | 15 +++++-
 drivers/virtio/virtio_pci_modern.c     | 75 +++++++++++++++++++++++++-
 drivers/virtio/virtio_pci_modern_dev.c | 24 ++++++++-
 include/linux/virtio_config.h          |  4 ++
 include/linux/virtio_pci_modern.h      |  2 +
 include/uapi/linux/virtio_pci.h        |  5 ++
 8 files changed, 157 insertions(+), 8 deletions(-)

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
index 7a5593997e0e..fafd13d0e4d4 100644
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
index 4b773bd7c58c..7306128e63e9 100644
--- a/drivers/virtio/virtio_pci_common.h
+++ b/drivers/virtio/virtio_pci_common.h
@@ -41,6 +41,14 @@ struct virtio_pci_vq_info {
 	unsigned int msix_vector;
 };
 
+struct virtio_pci_admin_vq {
+	/* Virtqueue info associated with this admin queue. */
+	struct virtio_pci_vq_info info;
+	/* Name of the admin queue: avq.$vq_index. */
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
index ee6a386d250b..ce915018b5b0 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -19,6 +19,8 @@
 #define VIRTIO_RING_NO_LEGACY
 #include "virtio_pci_common.h"
 
+#define VIRTIO_AVQ_SGS_MAX	4
+
 static u64 vp_get_features(struct virtio_device *vdev)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
@@ -26,6 +28,16 @@ static u64 vp_get_features(struct virtio_device *vdev)
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
@@ -37,6 +49,9 @@ static void vp_transport_features(struct virtio_device *vdev, u64 features)
 
 	if (features & BIT_ULL(VIRTIO_F_RING_RESET))
 		__virtio_set_bit(vdev, VIRTIO_F_RING_RESET);
+
+	if (features & BIT_ULL(VIRTIO_F_ADMIN_VQ))
+		__virtio_set_bit(vdev, VIRTIO_F_ADMIN_VQ);
 }
 
 static int __vp_check_common_size_one_feature(struct virtio_device *vdev, u32 fbit,
@@ -69,6 +84,9 @@ static int vp_check_common_size(struct virtio_device *vdev)
 	if (vp_check_common_size_one_feature(vdev, VIRTIO_F_RING_RESET, queue_reset))
 		return -EINVAL;
 
+	if (vp_check_common_size_one_feature(vdev, VIRTIO_F_ADMIN_VQ, admin_queue_num))
+		return -EINVAL;
+
 	return 0;
 }
 
@@ -345,6 +363,7 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
 	struct virtio_pci_modern_device *mdev = &vp_dev->mdev;
 	bool (*notify)(struct virtqueue *vq);
 	struct virtqueue *vq;
+	bool is_avq;
 	u16 num;
 	int err;
 
@@ -353,11 +372,13 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
 	else
 		notify = vp_notify;
 
-	if (index >= vp_modern_get_num_queues(mdev))
+	is_avq = vp_is_avq(&vp_dev->vdev, index);
+	if (index >= vp_modern_get_num_queues(mdev) && !is_avq)
 		return ERR_PTR(-EINVAL);
 
+	num = is_avq ?
+		VIRTIO_AVQ_SGS_MAX : vp_modern_get_queue_size(mdev, index);
 	/* Check if queue is either not available or already active. */
-	num = vp_modern_get_queue_size(mdev, index);
 	if (!num || vp_modern_get_queue_enable(mdev, index))
 		return ERR_PTR(-ENOENT);
 
@@ -383,6 +404,9 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
 		goto err;
 	}
 
+	if (is_avq)
+		vp_dev->admin_vq.info.vq = vq;
+
 	return vq;
 
 err:
@@ -418,6 +442,9 @@ static void del_vq(struct virtio_pci_vq_info *info)
 	struct virtio_pci_device *vp_dev = to_vp_device(vq->vdev);
 	struct virtio_pci_modern_device *mdev = &vp_dev->mdev;
 
+	if (vp_is_avq(&vp_dev->vdev, vq->index))
+		vp_dev->admin_vq.info.vq = NULL;
+
 	if (vp_dev->msix_enabled)
 		vp_modern_queue_vector(mdev, vq->index,
 				       VIRTIO_MSI_NO_VECTOR);
@@ -527,6 +554,45 @@ static bool vp_get_shm_region(struct virtio_device *vdev,
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
@@ -545,6 +611,8 @@ static const struct virtio_config_ops virtio_pci_config_nodev_ops = {
 	.get_shm_region  = vp_get_shm_region,
 	.disable_vq_and_reset = vp_modern_disable_vq_and_reset,
 	.enable_vq_after_reset = vp_modern_enable_vq_after_reset,
+	.create_avq = vp_modern_create_avq,
+	.destroy_avq = vp_modern_destroy_avq,
 };
 
 static const struct virtio_config_ops virtio_pci_config_ops = {
@@ -565,6 +633,8 @@ static const struct virtio_config_ops virtio_pci_config_ops = {
 	.get_shm_region  = vp_get_shm_region,
 	.disable_vq_and_reset = vp_modern_disable_vq_and_reset,
 	.enable_vq_after_reset = vp_modern_enable_vq_after_reset,
+	.create_avq = vp_modern_create_avq,
+	.destroy_avq = vp_modern_destroy_avq,
 };
 
 /* the PCI probing function */
@@ -588,6 +658,7 @@ int virtio_pci_modern_probe(struct virtio_pci_device *vp_dev)
 	vp_dev->config_vector = vp_config_vector;
 	vp_dev->setup_vq = setup_vq;
 	vp_dev->del_vq = del_vq;
+	vp_dev->is_avq = vp_is_avq;
 	vp_dev->isr = mdev->isr;
 	vp_dev->vdev.id = mdev->id;
 
diff --git a/drivers/virtio/virtio_pci_modern_dev.c b/drivers/virtio/virtio_pci_modern_dev.c
index 7de8b1ebabac..0d3dbfaf4b23 100644
--- a/drivers/virtio/virtio_pci_modern_dev.c
+++ b/drivers/virtio/virtio_pci_modern_dev.c
@@ -207,6 +207,10 @@ static inline void check_offsets(void)
 		     offsetof(struct virtio_pci_modern_common_cfg, queue_notify_data));
 	BUILD_BUG_ON(VIRTIO_PCI_COMMON_Q_RESET !=
 		     offsetof(struct virtio_pci_modern_common_cfg, queue_reset));
+	BUILD_BUG_ON(VIRTIO_PCI_COMMON_ADM_Q_IDX !=
+		     offsetof(struct virtio_pci_modern_common_cfg, admin_queue_index));
+	BUILD_BUG_ON(VIRTIO_PCI_COMMON_ADM_Q_NUM !=
+		     offsetof(struct virtio_pci_modern_common_cfg, admin_queue_num));
 }
 
 /*
@@ -296,7 +300,7 @@ int vp_modern_probe(struct virtio_pci_modern_device *mdev)
 	mdev->common = vp_modern_map_capability(mdev, common,
 			      sizeof(struct virtio_pci_common_cfg), 4, 0,
 			      offsetofend(struct virtio_pci_modern_common_cfg,
-					  queue_reset),
+					  admin_queue_num),
 			      &mdev->common_len, NULL);
 	if (!mdev->common)
 		goto err_map_common;
@@ -719,6 +723,24 @@ void __iomem *vp_modern_map_vq_notify(struct virtio_pci_modern_device *mdev,
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
index a09e13a577a9..c0b1b1ca1163 100644
--- a/include/linux/virtio_pci_modern.h
+++ b/include/linux/virtio_pci_modern.h
@@ -125,4 +125,6 @@ int vp_modern_probe(struct virtio_pci_modern_device *mdev);
 void vp_modern_remove(struct virtio_pci_modern_device *mdev);
 int vp_modern_get_queue_reset(struct virtio_pci_modern_device *mdev, u16 index);
 void vp_modern_set_queue_reset(struct virtio_pci_modern_device *mdev, u16 index);
+u16 vp_modern_avq_num(struct virtio_pci_modern_device *mdev);
+u16 vp_modern_avq_index(struct virtio_pci_modern_device *mdev);
 #endif
diff --git a/include/uapi/linux/virtio_pci.h b/include/uapi/linux/virtio_pci.h
index 44f4dd2add18..240ddeef7eae 100644
--- a/include/uapi/linux/virtio_pci.h
+++ b/include/uapi/linux/virtio_pci.h
@@ -175,6 +175,9 @@ struct virtio_pci_modern_common_cfg {
 
 	__le16 queue_notify_data;	/* read-write */
 	__le16 queue_reset;		/* read-write */
+
+	__le16 admin_queue_index;	/* read-only */
+	__le16 admin_queue_num;		/* read-only */
 };
 
 /* Fields in VIRTIO_PCI_CAP_PCI_CFG: */
@@ -215,6 +218,8 @@ struct virtio_pci_cfg_cap {
 #define VIRTIO_PCI_COMMON_Q_USEDHI	52
 #define VIRTIO_PCI_COMMON_Q_NDATA	56
 #define VIRTIO_PCI_COMMON_Q_RESET	58
+#define VIRTIO_PCI_COMMON_ADM_Q_IDX	60
+#define VIRTIO_PCI_COMMON_ADM_Q_NUM	62
 
 #endif /* VIRTIO_PCI_NO_MODERN */
 
-- 
2.27.0


