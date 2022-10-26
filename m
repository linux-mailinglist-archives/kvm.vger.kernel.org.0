Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA71560DC0C
	for <lists+kvm@lfdr.de>; Wed, 26 Oct 2022 09:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233022AbiJZHZc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Oct 2022 03:25:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231706AbiJZHZa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Oct 2022 03:25:30 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2088.outbound.protection.outlook.com [40.107.93.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F225F205C9
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 00:25:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AXZMrT/XUs7DEEi1mDXbKdlV1id/ATzDscOYUDTAwVS74d0HnCION8ajGLSuYdoK9uHkko+tgPTJhxFRFjVVp0yELyswdM34ExOh3dabO+aRlLCuphfOS6N9ImF3HI4wwu8ckVBA/AgWSBRjxhGf5TqwrAPgdEGvvJTAOtOoK4ysvLuwPRfOwqEusd7VItIIu8GxvhFFcoG4AVTURdmzruwdEK7JceEUv2dmVMswF+5em1oszfG2zcSijPc3Jk0sFjEbG3BlbvUIuphEJEtpzPTxh3QPo9nir3y2o8A0bwKylxp2eplWp01SQoXos+JS6BDNakhwRmIprKakm+etYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c+dGd4hYrtab0XVk/dEeg5PQcWvnqPn9m3mQPEyv6Yk=;
 b=FgjhnnXUzJMBzDmkoyABigTK/zr3bs8Mqr4QFUuNZJVXXXmoI9PkpcUlkw1SmZJD78QNFV1RqYIfAUWa9HmzFAX2WR94r9U2MXUM7ozMwvMUj1uQLuf22AXriT24DazTUqp3e8DKTH9RtZqpdu/DiV9iZcfqNJivnnsIU9GDFnv2/3oh8GiyEWVctb2aiSKpBc/Gvph5GrsI8mKrXjSkMRulAsxvyXLMjA0o1qZ1PSckg2s/ueRCMdWwksEeox/wMd6kGenis3DsaubLQ0riLqu/uwpW5rJJmo+022ocKqIVq1W6OdVOqpQTM4JGh6VT9sJ0ZHpmWMZu1iRQTxIhUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c+dGd4hYrtab0XVk/dEeg5PQcWvnqPn9m3mQPEyv6Yk=;
 b=iIoQD/vN2gJL5e2NxLquy3499gkJ8J5IEeB8U6AJyKUMc7fkIawKRjMYt0GG/A5zzIPilXhLwTIVnG7fmT7qxssMVcescvQJig9Qd+iFlHkZENA/v+ahuRO24nK9mTX5PSOyXtdcy67xumq8LqcIP3wa3aJxptQ9l8qYwODggaugQZEMLotfxJ3KvMAd8hmXHxgjUVzCw/6n/W9XuGX4UeXZDknxcqWAYON7sogDS1H/8gwP6JmDPs7NM2k2/Khogsur1FTLOmHBWYyZ8kxhaCTbMt8T3Idk0pyJmGgyP+Jsf04LtKmNAyRpSfpFlBOozGINPa+N7kFv6wypNDqqmA==
Received: from DM6PR02CA0078.namprd02.prod.outlook.com (2603:10b6:5:1f4::19)
 by CH2PR12MB4103.namprd12.prod.outlook.com (2603:10b6:610:7e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.25; Wed, 26 Oct
 2022 07:25:23 +0000
Received: from DM6NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1f4:cafe::44) by DM6PR02CA0078.outlook.office365.com
 (2603:10b6:5:1f4::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28 via Frontend
 Transport; Wed, 26 Oct 2022 07:25:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT051.mail.protection.outlook.com (10.13.172.243) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.16 via Frontend Transport; Wed, 26 Oct 2022 07:25:23 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 26 Oct
 2022 00:25:12 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 26 Oct
 2022 00:25:12 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.29 via Frontend Transport; Wed, 26 Oct
 2022 00:25:08 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <quintela@redhat.com>, <kvm@vger.kernel.org>,
        <liulongfang@huawei.com>, <shameerali.kolothum.thodi@huawei.com>,
        <kuba@kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <yishaih@nvidia.com>,
        <maorg@nvidia.com>, <cohuck@redhat.com>
Subject: [PATCH V1] vfio: Add an option to get migration data size
Date:   Wed, 26 Oct 2022 10:24:38 +0300
Message-ID: <20221026072438.166707-1-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT051:EE_|CH2PR12MB4103:EE_
X-MS-Office365-Filtering-Correlation-Id: 23c0e9f2-cbc8-4418-75d8-08dab7233ee9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NgFIl4hullX8LXlRlkckaGt59rdsrJzGR2N2G/N4TeGFJa3fUN6hKczLiE2gUpynfW3RrKW39R638A8MZPTjPdjALWmdw8Q8nuQiMe30fxlID0OYRBxnPN+P7FLJ0A9ZfRNmwWlmWhyeHDW6nfN6aaGFXPA296i0fMhaAo6hjyFxsJuOg/Rob7+RBYzc7kSY5O0OfS/AYyQ0FPKf/7Yb5Xijujc7L+h/D9FIUqRerC2Y2DZwulOZn8baf6qkHEM8HRr6VVUj32wrCOETPJAOHBG0OT8v/vdKVgNg1+MXFeCg4tmRL2InoiyS4GHCVq9+u7is5RycijHFDHPiJ9ooCH4vC/HSRHTMtNHFducnW5JAl7wane6COewqqyhWAfRQJ5z/Gvj7pzuVkpD/BNfeNlbD0dyFnBrGWyK+c7NaBQoJ5IXHOMgr2SnuLViWf2E8AeImMQkhYKkNYfipof3SMygjDLXDId3gSempnXfqxZw2LurZagfRtXVGwoofaqoFwEyJlNwZJTg5J+x0zyYvL9Ct6iV3PHFTefQB2BYBRQgzUIsKMvfx7EDR1losWuHeISg3uCIRDo4l782JKlXBj+Cn0rTkeoMUAdifgYDQoDo+usmbaMNpl5H4zwsAMmEIfSKiKMj10MF2cQa7q6jExCq7yEoX0hENLLEMud9e9KXJJaOVBcC5s0F7ECdDtOlkpY0/q3Ovtyxml2BbckICVoGpoDktA7l6+8En++sJfKK//TRvs7GpvmM8dnoteI2XPzX0f4nK8m7AEn24T2XDHom/KSpxoQjYjB9MfxsYQw/d6CcRhdSxI107IDkguRclZ2IzpeLf5oNEYA3f6FS2hTJaIm/hx/pQ5xyofcgfMH4=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(396003)(346002)(39860400002)(451199015)(36840700001)(40470700004)(46966006)(2616005)(36756003)(40480700001)(2906002)(6636002)(54906003)(336012)(36860700001)(41300700001)(8936002)(316002)(110136005)(6666004)(70586007)(70206006)(1076003)(966005)(82740400003)(86362001)(8676002)(5660300002)(4326008)(186003)(40460700003)(426003)(82310400005)(478600001)(26005)(7696005)(7636003)(83380400001)(47076005)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 07:25:23.1853
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 23c0e9f2-cbc8-4418-75d8-08dab7233ee9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4103
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
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
Changelog:
v1:
 * Added a missing check as part of vfio_pci_core_register_device()
v0: https://patchwork.kernel.org/project/kvm/patch/20221020132109.112708-1-yishaih@nvidia.com/

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

