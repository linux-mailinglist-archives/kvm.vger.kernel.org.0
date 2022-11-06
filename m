Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6317A61E500
	for <lists+kvm@lfdr.de>; Sun,  6 Nov 2022 18:47:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230345AbiKFRrR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Nov 2022 12:47:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbiKFRrO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Nov 2022 12:47:14 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2083.outbound.protection.outlook.com [40.107.237.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1CF5643A
        for <kvm@vger.kernel.org>; Sun,  6 Nov 2022 09:47:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mYVXu5CeSh0YpemIsQzVUE1gA5g7nwFB5sxCGIwwLJo5DSS5xzF5tIUcoBQCZc6yR9C2xewgJKtPBdS84RubkDmpKdkcH6kVgxaoZ7f9Sul8fj9rz0aF9StDS5KIaK43H6nKrZdpBjQXVY7QLZ6DnSCy1WtYvnf+N5ERFwOJuQURLzgnRYxie1vfzTDJr9WUUwHrvqtztoGgO8d6d8pmShwlp/cDPxw8+97Dzko0XR4tQNloI6IbGGyZZO45j3jPjivHjAsaiGE1IIFRcdOUZ84dURC+1bvX7xtUZxFnPI7h6q2wbZOQ7dX3HPZwyUKVcb6pZd0/nDDsitlobGTOEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7dzhG0/JcTEqGmUu8NC5P8WaUdJwbPRopjg1xRBDAPA=;
 b=JS1by11ogiHOR4QrCV5VJyesVOG8Lg3a9/Rp1nq2HfeJXkaPfVQ9Vwnvc0kmGrDskiN715Kqd83RHfgZ+bKYBKZn05oRKvKH9Y+H+BzTFyGgWmN5FD84/+57GMxRBSgs2+1YeD5CNm50qnazwoi0IYZNQFlPbp2X368M5dyY1zsOAwgeQrXFeQwDPkbeHZ9JERahalfKwlGytn3ZFTNwbCQp3te5/OUbVmwpd6PB5xAUUeZFUAHAYJoaaRBdF4WZdZRU14VAYB/y5AI1CPIUK6fQ2ekEman1QK+T+zPHFhZ3b88geFN2qZvesp8eufiWKUuGHIOGLPfhfMc7JeMIhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7dzhG0/JcTEqGmUu8NC5P8WaUdJwbPRopjg1xRBDAPA=;
 b=dkofhbkMDAxlAOqg8kzChw9ffPXvjiEne4e4ha7AOJrZXbjT1QNIO0MUNZrztODuJ7ZhvKHE7uyoDFS6phIv0kVrLPkjgrLayuK9UqLUmDJfxNT5TY7x0zm+WcScii7QodhZk2Ptmv40nnYUQyL36rVULJ69477A+6HN+TO3eR3/sS9w5K2tcsuqbLCZxeL8Gmz/9uz7vsVUjD6n1w6Tl7JR7RmxcIBkzLGBENuanTtSp7+s+7R/o8NV5tUazM08fD0/Vzj0zF4kktcrFQDvGtOa72liPfBkZd6Lc1Y4sMlSb7wB0CpgIJFUk68nEf1ezw7NpFOealSdEDivHbGdEQ==
Received: from BN6PR17CA0046.namprd17.prod.outlook.com (2603:10b6:405:75::35)
 by LV2PR12MB5797.namprd12.prod.outlook.com (2603:10b6:408:17b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Sun, 6 Nov
 2022 17:47:10 +0000
Received: from BN8NAM11FT034.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:75:cafe::6b) by BN6PR17CA0046.outlook.office365.com
 (2603:10b6:405:75::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22 via Frontend
 Transport; Sun, 6 Nov 2022 17:47:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN8NAM11FT034.mail.protection.outlook.com (10.13.176.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.20 via Frontend Transport; Sun, 6 Nov 2022 17:47:10 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Sun, 6 Nov 2022
 09:47:09 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Sun, 6 Nov 2022 09:47:09 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Sun, 6 Nov 2022 09:47:06 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>
Subject: [PATCH vfio 01/13] vfio: Add an option to get migration data size
Date:   Sun, 6 Nov 2022 19:46:18 +0200
Message-ID: <20221106174630.25909-2-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221106174630.25909-1-yishaih@nvidia.com>
References: <20221106174630.25909-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT034:EE_|LV2PR12MB5797:EE_
X-MS-Office365-Filtering-Correlation-Id: 6796d641-7697-458e-c4a2-08dac01eee63
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OFaEoqX3hefs8dakyuPKxB5F2hj+uGIwl5AmJA2XwzxiqznWup7fZSENKaGHNwxY5M6cWabPM4Z7TvVapYysQ0hTwovAMJ4fBnuCYSI/VWCtyBqdBzBWl4LzoYZJdI1k1GeVCzbw/RSViM9vdP2mee5y41XErJGHEVW16cPwcVh7N2cFFaFLzqq6wJiZjwNikALrNHdXpAT1JWeYzhuYFyXkO763BP3grYK4tUwLhtaBic2UW7/cvTPlrLetZIjqe5Z59dSMgX8Xtlqfh+gWi8yfvHsA6nfwMFIdhin58zrojHe8hmTXNtN8yETPiqElH1HONGxzchw/wSBWjJWLyWmafuWddwwhrIrTOoszTr66muJkHTlZ5RsIb4MMO/xLl/1lFwjYFxadvHt0SqWpWsXclYsw8G1JJuTJdtcakxSfi7bz7U8HqFxWDOW+KDTM1gzEFkh2ak1iFfMqcvHk8bGiPItPVif5o13YsAcS1CvKIc/hOXX0VVnW4/eCt4G1I7ksY+bHoA2qdslqs5jdL2BokXUUqWCbr6JOkZ5a7Iwxqq+nh9J8L5e9k74Pq8a/ts3OosTZeO+5Q+Qs/1VC2r+x9r/KTd+JOZtto4sn7iYQq+zurMyq+/+sSlWIYK5nMgDdJGJpjdenpJTlALFBO+gAXSpXR3O2pdwIhDJAYWHeuLLUCrmVzrIvSSu5vaERhiAa79fLei68LlJkANj77AQ8ePlUolrFa+EW+uJNENVIW7buK9FiVk7JMz5CPNZgUdwHliaHpbw5+xZt72X1ZQ==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(396003)(39860400002)(136003)(451199015)(46966006)(40470700004)(36840700001)(8936002)(478600001)(4326008)(41300700001)(26005)(5660300002)(2616005)(186003)(336012)(1076003)(83380400001)(6636002)(40480700001)(70586007)(426003)(47076005)(8676002)(70206006)(6666004)(36756003)(2906002)(356005)(82310400005)(316002)(36860700001)(7636003)(7696005)(40460700003)(82740400003)(54906003)(86362001)(110136005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2022 17:47:10.5539
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6796d641-7697-458e-c4a2-08dac01eee63
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT034.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5797
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add an option to get migration data size by introducing a new migration
feature named VFIO_DEVICE_FEATURE_MIG_DATA_SIZE.

Upon VFIO_DEVICE_FEATURE_GET the estimated data length that will be
required to complete STOP_COPY is returned.

This option may better enable user space to consider before moving to
STOP_COPY whether it can meet the downtime SLA based on the returned
data.

The patch also includes the implementation for mlx5 and hisi for this
new option to make it feature complete for the existing drivers in this
area.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    |  9 ++++++
 drivers/vfio/pci/mlx5/main.c                  | 18 +++++++++++
 drivers/vfio/pci/vfio_pci_core.c              |  3 +-
 drivers/vfio/vfio_main.c                      | 32 +++++++++++++++++++
 include/linux/vfio.h                          |  5 +++
 include/uapi/linux/vfio.h                     | 13 ++++++++
 6 files changed, 79 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index 39eeca18a0f7..0c0c0c7f0521 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -957,6 +957,14 @@ hisi_acc_vfio_pci_set_device_state(struct vfio_device *vdev,
 	return res;
 }
 
+static int
+hisi_acc_vfio_pci_get_data_size(struct vfio_device *vdev,
+				unsigned long *stop_copy_length)
+{
+	*stop_copy_length = sizeof(struct acc_vf_data);
+	return 0;
+}
+
 static int
 hisi_acc_vfio_pci_get_device_state(struct vfio_device *vdev,
 				   enum vfio_device_mig_state *curr_state)
@@ -1213,6 +1221,7 @@ static void hisi_acc_vfio_pci_close_device(struct vfio_device *core_vdev)
 static const struct vfio_migration_ops hisi_acc_vfio_pci_migrn_state_ops = {
 	.migration_set_state = hisi_acc_vfio_pci_set_device_state,
 	.migration_get_state = hisi_acc_vfio_pci_get_device_state,
+	.migration_get_data_size = hisi_acc_vfio_pci_get_data_size,
 };
 
 static int hisi_acc_vfio_pci_migrn_init_dev(struct vfio_device *core_vdev)
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index fd6ccb8454a2..4c7a39ffd247 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -512,6 +512,23 @@ mlx5vf_pci_set_device_state(struct vfio_device *vdev,
 	return res;
 }
 
+static int mlx5vf_pci_get_data_size(struct vfio_device *vdev,
+				    unsigned long *stop_copy_length)
+{
+	struct mlx5vf_pci_core_device *mvdev = container_of(
+		vdev, struct mlx5vf_pci_core_device, core_device.vdev);
+	size_t state_size;
+	int ret;
+
+	mutex_lock(&mvdev->state_mutex);
+	ret = mlx5vf_cmd_query_vhca_migration_state(mvdev,
+						    &state_size);
+	if (!ret)
+		*stop_copy_length = state_size;
+	mlx5vf_state_mutex_unlock(mvdev);
+	return ret;
+}
+
 static int mlx5vf_pci_get_device_state(struct vfio_device *vdev,
 				       enum vfio_device_mig_state *curr_state)
 {
@@ -577,6 +594,7 @@ static void mlx5vf_pci_close_device(struct vfio_device *core_vdev)
 static const struct vfio_migration_ops mlx5vf_pci_mig_ops = {
 	.migration_set_state = mlx5vf_pci_set_device_state,
 	.migration_get_state = mlx5vf_pci_get_device_state,
+	.migration_get_data_size = mlx5vf_pci_get_data_size,
 };
 
 static const struct vfio_log_ops mlx5vf_pci_log_ops = {
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index badc9d828cac..4d97ca66ba6c 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -2128,7 +2128,8 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
 
 	if (vdev->vdev.mig_ops) {
 		if (!(vdev->vdev.mig_ops->migration_get_state &&
-		      vdev->vdev.mig_ops->migration_set_state) ||
+		      vdev->vdev.mig_ops->migration_set_state &&
+		      vdev->vdev.mig_ops->migration_get_data_size) ||
 		    !(vdev->vdev.migration_flags & VFIO_MIGRATION_STOP_COPY))
 			return -EINVAL;
 	}
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 2d168793d4e1..b118e7b1bc59 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1256,6 +1256,34 @@ vfio_ioctl_device_feature_mig_device_state(struct vfio_device *device,
 	return 0;
 }
 
+static int
+vfio_ioctl_device_feature_migration_data_size(struct vfio_device *device,
+					      u32 flags, void __user *arg,
+					      size_t argsz)
+{
+	struct vfio_device_feature_mig_data_size data_size = {};
+	unsigned long stop_copy_length;
+	int ret;
+
+	if (!device->mig_ops)
+		return -ENOTTY;
+
+	ret = vfio_check_feature(flags, argsz, VFIO_DEVICE_FEATURE_GET,
+				 sizeof(data_size));
+	if (ret != 1)
+		return ret;
+
+	ret = device->mig_ops->migration_get_data_size(device, &stop_copy_length);
+	if (ret)
+		return ret;
+
+	data_size.stop_copy_length = stop_copy_length;
+	if (copy_to_user(arg, &data_size, sizeof(data_size)))
+		return -EFAULT;
+
+	return 0;
+}
+
 static int vfio_ioctl_device_feature_migration(struct vfio_device *device,
 					       u32 flags, void __user *arg,
 					       size_t argsz)
@@ -1483,6 +1511,10 @@ static int vfio_ioctl_device_feature(struct vfio_device *device,
 		return vfio_ioctl_device_feature_logging_report(
 			device, feature.flags, arg->data,
 			feature.argsz - minsz);
+	case VFIO_DEVICE_FEATURE_MIG_DATA_SIZE:
+		return vfio_ioctl_device_feature_migration_data_size(
+			device, feature.flags, arg->data,
+			feature.argsz - minsz);
 	default:
 		if (unlikely(!device->ops->device_feature))
 			return -EINVAL;
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index e7cebeb875dd..5509451ae709 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -107,6 +107,9 @@ struct vfio_device_ops {
  * @migration_get_state: Optional callback to get the migration state for
  *         devices that support migration. It's mandatory for
  *         VFIO_DEVICE_FEATURE_MIGRATION migration support.
+ * @migration_get_data_size: Optional callback to get the estimated data
+ *          length that will be required to complete stop copy. It's mandatory for
+ *          VFIO_DEVICE_FEATURE_MIGRATION migration support.
  */
 struct vfio_migration_ops {
 	struct file *(*migration_set_state)(
@@ -114,6 +117,8 @@ struct vfio_migration_ops {
 		enum vfio_device_mig_state new_state);
 	int (*migration_get_state)(struct vfio_device *device,
 				   enum vfio_device_mig_state *curr_state);
+	int (*migration_get_data_size)(struct vfio_device *device,
+				       unsigned long *stop_copy_length);
 };
 
 /**
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index d7d8e0922376..3e45dbaf190e 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -1128,6 +1128,19 @@ struct vfio_device_feature_dma_logging_report {
 
 #define VFIO_DEVICE_FEATURE_DMA_LOGGING_REPORT 8
 
+/*
+ * Upon VFIO_DEVICE_FEATURE_GET read back the estimated data length that will
+ * be required to complete stop copy.
+ *
+ * Note: Can be called on each device state.
+ */
+
+struct vfio_device_feature_mig_data_size {
+	__aligned_u64 stop_copy_length;
+};
+
+#define VFIO_DEVICE_FEATURE_MIG_DATA_SIZE 9
+
 /* -------- API for Type1 VFIO IOMMU -------- */
 
 /**
-- 
2.18.1

