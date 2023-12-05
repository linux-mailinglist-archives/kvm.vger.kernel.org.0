Return-Path: <kvm+bounces-3601-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AA4FC805ABF
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 18:07:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CC8DC1C2149E
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 17:07:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E09D265ED0;
	Tue,  5 Dec 2023 17:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tuGgONbI"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2068.outbound.protection.outlook.com [40.107.243.68])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A56C1A4
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 09:07:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TD5SUt9KKsQJaNvn7F3oF7q0b52TSK7MkhDeMaA6AElXqsN5JlmJUrfbcyou82iBT3tQXpbS3b5/lqDN3doZLuppzHEQHaxQpDmKnrWdI6XZuK9D7asx6Ew4iw+zcD4mg+2OsXB/MBtqy1l0n8uQ7SbNW0Pbi5vpGdhl3ERfJH9buMpvN3BFfRhINigtIKwQUgQSM8+YMBB1qRV71OAVSZLIqZfLkh4j8y8Dg0mqYWSY5eY9p84pLVXGkt/M/pcPHobNHILTykiEdV2wtyYP5bDx0Ev7FtJb5fDF571QEGQgSN9c1h12bQT1FeteESa1gDDkkAOKnG6Lgf5qJ9rFxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3RORiFDPc00uy25Ez83+myQNpfqwcW4zHUp/bpHu5L8=;
 b=QggFlqFbOZ8b2cdzjnWfXeVTdkzYAG1ksPZj1sezDxOW/9dvTDQmo/rHpyuq8yy7vXEM+qm3C/5u8+RAVvOntMA7O2ThV2JwvwmagjTPEinJZPxrWjWxrhqO+ADQ2LwY27RRlFqC5ieC7/orEHjGPVFhkc/aQpLJJFEkQH9l+YYaw7rKTro6prl16Vu/zDXD0JevvrVxbb4NuVIfO3s0UNYaO3w9daZA2RCTBzNeu2KdxYapz4gKacDSSAEB+krh84ooCX+o+5c3yey5rCcU80JHsEAi5ItRFtn9iIGUWJXEBC8Xvm7wJ/qf3M++N5pBhvwdUvDQUW02LelI+BDQew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3RORiFDPc00uy25Ez83+myQNpfqwcW4zHUp/bpHu5L8=;
 b=tuGgONbIYhNpz4eOo5+hPLpXv1wahCXSvJrrFr78HVtmoihY1KImvx7ntrWy1Hj0ugOywBBb/dkmM4NxiYyDVb85E1RVQRjdOs5NL3JXsvr2RDXplmDLHHr5ryYlQtmPrro8PPaaHOeAt1cYOqwxS1OCy6mX9aNih/N26sla8/IcdmQgPak3LwgofVYJauRC1AFtSXSzQD8smUldF+ZuWw4nKCfbuIZmNXqu2vla9ofMMDFaNBhwmnZoxhIUNpLitpBrKcOBx5f/VAV4JBsawIaxLbQtoouUkB4XXuGuxUb7de/JbU1aUtxXhh+0V727EJSGokbySVgXSskKL1CaoA==
Received: from MW4PR03CA0067.namprd03.prod.outlook.com (2603:10b6:303:b6::12)
 by PH7PR12MB5974.namprd12.prod.outlook.com (2603:10b6:510:1d9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Tue, 5 Dec
 2023 17:07:19 +0000
Received: from CO1PEPF000044FB.namprd21.prod.outlook.com
 (2603:10b6:303:b6:cafe::5f) by MW4PR03CA0067.outlook.office365.com
 (2603:10b6:303:b6::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34 via Frontend
 Transport; Tue, 5 Dec 2023 17:07:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1PEPF000044FB.mail.protection.outlook.com (10.167.241.201) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7091.2 via Frontend Transport; Tue, 5 Dec 2023 17:07:18 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 5 Dec 2023
 09:07:02 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 5 Dec 2023
 09:07:02 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.41 via Frontend Transport; Tue, 5 Dec
 2023 09:06:58 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V5 vfio 2/9] virtio-pci: Introduce admin virtqueue
Date: Tue, 5 Dec 2023 19:06:16 +0200
Message-ID: <20231205170623.197877-3-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20231205170623.197877-1-yishaih@nvidia.com>
References: <20231205170623.197877-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044FB:EE_|PH7PR12MB5974:EE_
X-MS-Office365-Filtering-Correlation-Id: b45203bf-653e-495c-ba60-08dbf5b4a3a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ItZjwW6K+uaOJbF4tqJ7fydTwDMP7dGEH7tpxB/YMFp4c1ExWMYfpIui8HlaC2Rk8xR5wYR7NqFNxYgTZNRow8Om12UgbwWPkYJ+1gA4iT5HG6Qu0MnWmcJY3Yce2/Ont95phUuKK3pvgYASHsYEeoDtvm35TDnPQiAAKyeI3/mQrlJrPeiNxsdMpF5TdI8d07qeI+lSQKsq4rasYh5YmKmahvFPAXEAvHbJggAwCJxCrpdN30uqH9A2NaVxlqu2UtO5pbZEzQP/lH9tg/sdNuQM+728frEpm+VV00aaHxYoKP1b6GupwGK09AAtPtTqdH0rnb27s8zvAMy9hubvvcyjIe7VnLLpJzdgOtakvaox7/EVd3ApUhENh2J7g93XB8/0Ercby+w9Vr00Zgi8oJQGPe96V1d+mxRESkv4E7J30NmJIcZoHcmKLRwaSjcf029dxCdwUrcbglBxUijj6HrlCdWYTBSjn9zhMafu5iC5e0LvVoqZwEW2UaAVZcC1qV1oLGDfHbRKhrSM/b9esXv3DHiWR5qhJlgkMq11JTcFVzP6ev8QNqVnem2f5jFyHZEkCZwuuhBVP5VuRMhH1mtyYaORNYdZk2gdOpQle0m5KpaYjRzGS+ts0sa29W9D7Mj9k0zoNYRRPpXZ03O13JVttwqz1pR5OMmkoZ7UZ7mqRQO9bn1mOHhfTCWULdOPFeQmMkVcy9ArnsNV3N+ZFU/UGhg22K0x0JlCBkth0rQwlPO34bQfdIxqUA/HfpXc
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(39860400002)(346002)(136003)(396003)(230922051799003)(451199024)(64100799003)(1800799012)(186009)(82310400011)(40470700004)(46966006)(36840700001)(40480700001)(26005)(107886003)(336012)(356005)(83380400001)(426003)(36860700001)(47076005)(82740400003)(7696005)(2616005)(1076003)(7636003)(6666004)(478600001)(40460700003)(70206006)(70586007)(54906003)(6636002)(110136005)(316002)(8936002)(8676002)(4326008)(2906002)(41300700001)(36756003)(86362001)(30864003)(5660300002)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2023 17:07:18.9789
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b45203bf-653e-495c-ba60-08dbf5b4a3a0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044FB.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5974

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


