Return-Path: <kvm+bounces-1572-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E2DC97E9738
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 09:03:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 97E50280D16
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 08:03:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AA1018623;
	Mon, 13 Nov 2023 08:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="LAfMC0SF"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E611775F
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 08:03:20 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2062.outbound.protection.outlook.com [40.107.92.62])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0D5D10F3
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 00:03:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VSmMknl0ytmrvt2zre6bsNlk8YsFaEk7RCPAc28CVcWYEmMa117tKf0Ndbtp2hJND1qta8fdgydsChDH7qVqXfXl2SVdrksiMmHjF+nTYclV5GQWdCDuerdQpX6dkXLnLjq0Eov8FW7CWsFqzCyO85+zNmWK2tBqykpxT5q+3JQYWKdG8qLSH24+krT9My1vAHWP5MERFrMD9Xjg521iQ0NY7+DCvq6GhdJ0cPOb8N8nu/obLz+yu5Z1w9XpMaZ9+fb4hQhFV37xau2ZJaDKirjOAyr3QreIc4ay00MlsvDa3JzdQliW9TelNggqDOTEIv/QTrzoqpFMYQ9tqj0adA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rJ1J2+c7jjEPyaJ1pwAAKXK43XxU6O41CNvn77IRFlY=;
 b=YuDPF9D4SsBo3acu7P7azesFN1i8XiyboPTgcC+P8TKQeRUvx34cgEqrhucIs+dvZqZARZWHk0o9zsJlhDVghjYovtU9Nz8YRnixzcy5uSE/5oxF9yYOrbdw46nwLLTXYEhiGptQWSPPLGst/3X/kVt9NNXwxCwWgGID7NYZg5G5zcBS6iFNI17kzc82siZKcWMTbS02QTmMV72vZTIA33sKUGd8n4FM9F+whbHtyVFkT/P6X2AZg8V/MpFduXAaWpsW0mD3aBU9+EE4xedxzNp68hPxQb6i0sYoh+dUnFInO9Bpn0rKCD3G48fqeevfN29MT3IM1qPLZeR/t68UcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rJ1J2+c7jjEPyaJ1pwAAKXK43XxU6O41CNvn77IRFlY=;
 b=LAfMC0SFwjYAXwSRGQ7ddVGeMDw059q+BAfD+aQtX2SUBByXRyofeFTKMyRw2xOaXaInC2nwKte/gwxsc1pcUWYYU7CwxiJ1zgNSJR8CpmwkyXOtod2MN18OYtLQeGxbVMLl5KffzgvGn6XC97tEd74PPxJhtSKcXXj3zZurSPxeVUa9mipTnDzpc25X6pxeauDQipguxI7vmfHjNYgJEIr6EtrNKjiyH8GB6Mb1grbcTrDQvD8lBywZMiiITgNAlXdGlveW3K/KcYWlK1qVJENXoe8EawvAoIP4dWXlsQkaMsn8TGcjVX4Pkh6m73z35m0wGnCI/EB1WGY9yzhWWw==
Received: from PH0PR07CA0088.namprd07.prod.outlook.com (2603:10b6:510:f::33)
 by CH2PR12MB4312.namprd12.prod.outlook.com (2603:10b6:610:af::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.31; Mon, 13 Nov
 2023 08:03:14 +0000
Received: from SA2PEPF000015C9.namprd03.prod.outlook.com
 (2603:10b6:510:f:cafe::62) by PH0PR07CA0088.outlook.office365.com
 (2603:10b6:510:f::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.29 via Frontend
 Transport; Mon, 13 Nov 2023 08:03:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SA2PEPF000015C9.mail.protection.outlook.com (10.167.241.199) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7002.13 via Frontend Transport; Mon, 13 Nov 2023 08:03:14 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 13 Nov
 2023 00:03:04 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.41; Mon, 13 Nov 2023 00:03:03 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.41 via Frontend
 Transport; Mon, 13 Nov 2023 00:03:00 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V3 vfio 2/9] virtio-pci: Introduce admin virtqueue
Date: Mon, 13 Nov 2023 10:02:15 +0200
Message-ID: <20231113080222.91795-3-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20231113080222.91795-1-yishaih@nvidia.com>
References: <20231113080222.91795-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF000015C9:EE_|CH2PR12MB4312:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b16a39e-ecaf-42ff-4b93-08dbe41efc9f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	8pR4wR4gEQpA0doewZ5b+kAjCVm4Yj/ropf4fY3x8L2XqMewLOe1yw3OKLV5PdsED/X4O4RvbhTgdkReUaGCCC4CqFapg2rNlySD95GxPcNdCaAbJlWyVR+6+OHWti2ReI4K44ZLwWCpYvQpJTCzattj9U5e+ldQl3KrgIO/Ubf3jrGjiH1cS3hjTNQankdpbzVsU8P/XxTfCUIXug5ZBPuK9Ag7g6tyBUEfhHVmlIP8d2DPgobPC7ZCb7itJ5+V2uiSsr7XvuAM6NJkInzq5FluY+YlpJDrzxaKZ5NKolHwZlIAQOeHbakwkVfCpSdG+jQ86GN4FxcyGnNEYsXTf69cggvHHcE11d2FSoEQPNdeJEoBJLcemf8PQayWV90TU9VHyqFDZ7VguS02q/H5hC521MaZ32tHUo+5w6idsFsQD7Nl0vKLWCvcPzzTFfRUVDZBdjI0iod7JQvG7rslgdt6wFPE15rDAETvDD1QT8IBzYuzNR6cEsRSeZJeKyBjFvJUQqitTFEYMuVmFB0RLAVzi7WEjqzoY2xRAHbkF5ssd7FZnxtGY3T+OYl9LxL/DYjaxBGtyGh4oLApkAm+l6DFD/ugj+fWP2mTUMKSqDqtIaIfcD3aCwHfohArz2G3wti5skCQLx6DH9t6k3nHInxDqt3e5HrigMk3UQiJ6tKaQImwiGZHKMkJChLdcSb9Ei3d+yTLyucUG/ICCgI1amV2acsulvccMJRtwqI6AT9wtPwsQSKkutvxuzTOG05t
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(346002)(376002)(39860400002)(396003)(230922051799003)(64100799003)(186009)(1800799009)(82310400011)(451199024)(36840700001)(46966006)(40470700004)(2906002)(40460700003)(30864003)(7636003)(356005)(8936002)(8676002)(4326008)(5660300002)(82740400003)(83380400001)(41300700001)(86362001)(478600001)(7696005)(36860700001)(6666004)(36756003)(26005)(426003)(336012)(47076005)(1076003)(107886003)(2616005)(316002)(40480700001)(6636002)(110136005)(70206006)(70586007)(54906003)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2023 08:03:14.0413
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b16a39e-ecaf-42ff-4b93-08dbe41efc9f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF000015C9.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4312

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
 drivers/virtio/virtio.c                | 37 +++++++++++--
 drivers/virtio/virtio_pci_common.c     |  3 ++
 drivers/virtio/virtio_pci_common.h     | 15 +++++-
 drivers/virtio/virtio_pci_modern.c     | 75 +++++++++++++++++++++++++-
 drivers/virtio/virtio_pci_modern_dev.c | 22 ++++++++
 include/linux/virtio_config.h          |  4 ++
 include/linux/virtio_pci_modern.h      |  5 ++
 include/uapi/linux/virtio_pci.h        |  2 +
 8 files changed, 156 insertions(+), 7 deletions(-)

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
index e2a1fe7bb66c..ab7db8019f81 100644
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
@@ -718,6 +722,24 @@ void __iomem *vp_modern_map_vq_notify(struct virtio_pci_modern_device *mdev,
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
index d0f2797420f7..a374224992e4 100644
--- a/include/linux/virtio_pci_modern.h
+++ b/include/linux/virtio_pci_modern.h
@@ -10,6 +10,9 @@ struct virtio_pci_modern_common_cfg {
 
 	__le16 queue_notify_data;	/* read-write */
 	__le16 queue_reset;		/* read-write */
+
+	__le16 admin_queue_index;	/* read-only */
+	__le16 admin_queue_num;		/* read-only */
 };
 
 /**
@@ -132,4 +135,6 @@ int vp_modern_probe(struct virtio_pci_modern_device *mdev);
 void vp_modern_remove(struct virtio_pci_modern_device *mdev);
 int vp_modern_get_queue_reset(struct virtio_pci_modern_device *mdev, u16 index);
 void vp_modern_set_queue_reset(struct virtio_pci_modern_device *mdev, u16 index);
+u16 vp_modern_avq_num(struct virtio_pci_modern_device *mdev);
+u16 vp_modern_avq_index(struct virtio_pci_modern_device *mdev);
 #endif
diff --git a/include/uapi/linux/virtio_pci.h b/include/uapi/linux/virtio_pci.h
index f703afc7ad31..d50f080cf621 100644
--- a/include/uapi/linux/virtio_pci.h
+++ b/include/uapi/linux/virtio_pci.h
@@ -204,6 +204,8 @@ struct virtio_pci_cfg_cap {
 #define VIRTIO_PCI_COMMON_Q_USEDHI	52
 #define VIRTIO_PCI_COMMON_Q_NDATA	56
 #define VIRTIO_PCI_COMMON_Q_RESET	58
+#define VIRTIO_PCI_COMMON_ADM_Q_IDX	60
+#define VIRTIO_PCI_COMMON_ADM_Q_NUM	62
 
 #endif /* VIRTIO_PCI_NO_MODERN */
 
-- 
2.27.0


