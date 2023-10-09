Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0DB7BD9AD
	for <lists+kvm@lfdr.de>; Mon,  9 Oct 2023 13:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346269AbjJIL0S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 07:26:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346416AbjJILZr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 07:25:47 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2071.outbound.protection.outlook.com [40.107.93.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C39CB1AE;
        Mon,  9 Oct 2023 04:25:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XD0EeCwCGvFWVhY4sSZ/tAJapwKaN9oRiG7jPQ24Dm2ryhzrBZcgg7+KB44ldeUFk501T2TciyH6csMk6Jpm5dMe3wdOUnyQeMjCg9fKqnuRv/d4m/Prwav5UHN28Ez8p0COXOlEu6PYNq3za79sCW1zxggE8fm64jxEwwy9cxNnkhL2zjZeK0B0S0XRpGvSUgRwz1GTq5ORGbLR1iP/VRCXAQw7cdsjJnHbEwab89Le76637DLdhtJlPiHle5PCr4rSgVYpwnoftUbgrVR25hgDOdeGQ5+XC9istwkvyqIlZ1/voHgokS98RuQIs/NF2WoTXc8H0qPyhrNg+BJ+mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QovrclrVp/hpPM4yCvipuO0xAMnuUXtRKEW8YwyUiFM=;
 b=W8BNjdBSEx9LlIXX64xWIeHJybyueUD/WiB1ov1EvwBC2KtRGlfZ8yRn5W1Dt5Hsdgu/WKOrrbS2UD6IGnZoJsJWZx68xmyDexmWIg4r2V3WWUxcuRGVlStAZKXDi4ucEy0uJBjBAR81HvNwGXksMElZ3XNr5yq5Q2oG6doAhC9cuEgoQ8dIlpVfsBsyc/S04FYKagCpJ/18BziYPQ4ucDGrRDYstIXBwB8jTSzYHKqDIqHUUX1zHZ82sqICvpr7vQ3J5FvhfkDYh2Xl8X9RXMXmjsHp0KQItiI6RvQ4jVX+UCpxTZm86nVYMJrF7h6j1EHMUCDMvwS3sd9Pr7vgPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QovrclrVp/hpPM4yCvipuO0xAMnuUXtRKEW8YwyUiFM=;
 b=OgI1um3mZyGSrL9ztrdTPVGUtvAaoWl8FFIcx1bgsxQ6nJT82YlAhLj8uurbwzxVYnW2AXG2xLdU16yKS+55NO70AGdYh/5+/s2yeeukMP6i+zS+PEoiQj1s9F4uKtZIh0T6LzSOBPtHNv+FyUG66EAhqadgPReBxdu94Tjg170lx401P6YGlgHqZXFfyc55Rx7J9gHnIDy+Q+fTvFs3BNDmtMMBeai4fBLbWZRwSDVgU7I96O/MrKTsX4YLMqIEpRWgTfYNEDGc4SGrPRh9xkIL0XW4/GBHqsGCXqPJRH6jbRMnpu2Co3hHDsg8/fYmvPHbVNrC/DAFb9vL8phm5w==
Received: from SA1P222CA0097.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:35e::24)
 by SJ0PR12MB5635.namprd12.prod.outlook.com (2603:10b6:a03:42a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.36; Mon, 9 Oct
 2023 11:25:24 +0000
Received: from SN1PEPF0002BA50.namprd03.prod.outlook.com
 (2603:10b6:806:35e:cafe::5f) by SA1P222CA0097.outlook.office365.com
 (2603:10b6:806:35e::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.36 via Frontend
 Transport; Mon, 9 Oct 2023 11:25:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SN1PEPF0002BA50.mail.protection.outlook.com (10.167.242.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6838.14 via Frontend Transport; Mon, 9 Oct 2023 11:25:24 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 9 Oct 2023
 04:25:09 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 9 Oct 2023
 04:25:08 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Mon, 9 Oct 2023 04:25:05 -0700
From:   Dragos Tatulea <dtatulea@nvidia.com>
To:     "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Eugenio Perez Martin <eperezma@redhat.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        <virtualization@lists.linux-foundation.org>
CC:     Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Subject: [PATCH vhost v3 14/16] vdpa/mlx5: Enable hw support for vq descriptor mapping
Date:   Mon, 9 Oct 2023 14:23:59 +0300
Message-ID: <20231009112401.1060447-15-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231009112401.1060447-1-dtatulea@nvidia.com>
References: <20231009112401.1060447-1-dtatulea@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA50:EE_|SJ0PR12MB5635:EE_
X-MS-Office365-Filtering-Correlation-Id: d01de39d-8987-474f-330e-08dbc8ba6e56
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wfwS0H83RW+IgOwrIuMsijPquvm7BNM0MTqv8SNOyQk+rtrDCbdaB6xFosY48C7cFZ8FdDibMEICBKHCbP9DHXw1g5M6/W8Ir5m0guZrrnqnBKdb5Tp2OISRIPEXJ7fIWBFzwJjzZyXcn2O9VCD6fWtOd1AIp1cwayils8jtAEcZuO8UaWjOspwAnJW1o/we4EmgOv+K1T+eF6kLJKlHWSub4cRUwQuL6S/HYIr7SVRQjDHoGUfnTk7mF53V6vQRWM6SfVLJ0brvSLJFhG+MW3DR93Z35bXnxhZUJRcvsGelaeijgzxnKJUJ71g7FSbHQR7MZH2XcLQ1/9+IZolgz0AHy84x0HxVOYUBTYQ3zbTfVjUbUhT+k12Umj1xjSi/dhchNySYTzCAICZMoOfe9liE4ShCRbdU/9o8iiVe4x84sErT0zy48lMNYQZV4rZkpxdViyd6/1qlAnO4VyNJzfnCkzjVTvxB143C+TikRzxxAgc4ovacoXqp8yHn+dE99iZMdt7/XyBkGkwpR4Ah918SRfl4ntUV6hZilxsSU0DJj2SSMMU/9nbQra9y2t/cl1ZEkuadbDd66OoQ349cXN2RKfrHuxa12PDbY8TgkFCqKkNSrlneHlEX9HK9Znu41sztMKzyCZIXtzV0zdQnPpCBuktNQYlEymzzKDj8KkKW+VbZK+z2B/iqBYp3iCOdHYGmo1gTU0f4cpOIJjDWufzRBWLoaGjxIUVkosSUts0gCCnaAn8S+ShkDHzHXrTtJaB3cwuDsWvWus7WMiIq3Eo5JZgt8sop1ViS7aL8CI0=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(39860400002)(396003)(346002)(136003)(230922051799003)(186009)(82310400011)(451199024)(1800799009)(64100799003)(40470700004)(36840700001)(46966006)(2906002)(40460700003)(426003)(336012)(26005)(2616005)(86362001)(1076003)(6666004)(36756003)(478600001)(66574015)(36860700001)(47076005)(83380400001)(7636003)(82740400003)(356005)(40480700001)(54906003)(70586007)(70206006)(316002)(110136005)(4326008)(41300700001)(5660300002)(8936002)(8676002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2023 11:25:24.2266
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d01de39d-8987-474f-330e-08dbc8ba6e56
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1PEPF0002BA50.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5635
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vq descriptor mappings are supported in hardware by filling in an
additional mkey which contains the descriptor mappings to the hw vq.

A previous patch in this series added support for hw mkey (mr) creation
for ASID 1.

This patch fills in both the vq data and vq descriptor mkeys based on
group ASID mapping.

The feature is signaled to the vdpa core through the presence of the
.get_vq_desc_group op.

Acked-by: Eugenio Pérez <eperezma@redhat.com>
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c  | 24 +++++++++++++++++++++++-
 include/linux/mlx5/mlx5_ifc_vdpa.h |  7 ++++++-
 2 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 25bd2c324f5b..2e0a3ce1c0cf 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -823,6 +823,7 @@ static int create_virtqueue(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtque
 	u32 out[MLX5_ST_SZ_DW(create_virtio_net_q_out)] = {};
 	struct mlx5_vdpa_dev *mvdev = &ndev->mvdev;
 	struct mlx5_vdpa_mr *vq_mr;
+	struct mlx5_vdpa_mr *vq_desc_mr;
 	void *obj_context;
 	u16 mlx_features;
 	void *cmd_hdr;
@@ -878,6 +879,11 @@ static int create_virtqueue(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtque
 	vq_mr = mvdev->mr[mvdev->group2asid[MLX5_VDPA_DATAVQ_GROUP]];
 	if (vq_mr)
 		MLX5_SET(virtio_q, vq_ctx, virtio_q_mkey, vq_mr->mkey);
+
+	vq_desc_mr = mvdev->mr[mvdev->group2asid[MLX5_VDPA_DATAVQ_DESC_GROUP]];
+	if (vq_desc_mr)
+		MLX5_SET(virtio_q, vq_ctx, desc_group_mkey, vq_desc_mr->mkey);
+
 	MLX5_SET(virtio_q, vq_ctx, umem_1_id, mvq->umem1.id);
 	MLX5_SET(virtio_q, vq_ctx, umem_1_size, mvq->umem1.size);
 	MLX5_SET(virtio_q, vq_ctx, umem_2_id, mvq->umem2.id);
@@ -2265,6 +2271,16 @@ static u32 mlx5_vdpa_get_vq_group(struct vdpa_device *vdev, u16 idx)
 	return MLX5_VDPA_DATAVQ_GROUP;
 }
 
+static u32 mlx5_vdpa_get_vq_desc_group(struct vdpa_device *vdev, u16 idx)
+{
+	struct mlx5_vdpa_dev *mvdev = to_mvdev(vdev);
+
+	if (is_ctrl_vq_idx(mvdev, idx))
+		return MLX5_VDPA_CVQ_GROUP;
+
+	return MLX5_VDPA_DATAVQ_DESC_GROUP;
+}
+
 static u64 mlx_to_vritio_features(u16 dev_features)
 {
 	u64 result = 0;
@@ -3160,6 +3176,7 @@ static const struct vdpa_config_ops mlx5_vdpa_ops = {
 	.get_vq_irq = mlx5_get_vq_irq,
 	.get_vq_align = mlx5_vdpa_get_vq_align,
 	.get_vq_group = mlx5_vdpa_get_vq_group,
+	.get_vq_desc_group = mlx5_vdpa_get_vq_desc_group, /* Op disabled if not supported. */
 	.get_device_features = mlx5_vdpa_get_device_features,
 	.set_driver_features = mlx5_vdpa_set_driver_features,
 	.get_driver_features = mlx5_vdpa_get_driver_features,
@@ -3258,6 +3275,7 @@ struct mlx5_vdpa_mgmtdev {
 	struct vdpa_mgmt_dev mgtdev;
 	struct mlx5_adev *madev;
 	struct mlx5_vdpa_net *ndev;
+	struct vdpa_config_ops vdpa_ops;
 };
 
 static int config_func_mtu(struct mlx5_core_dev *mdev, u16 mtu)
@@ -3371,7 +3389,7 @@ static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *v_mdev, const char *name,
 		max_vqs = 2;
 	}
 
-	ndev = vdpa_alloc_device(struct mlx5_vdpa_net, mvdev.vdev, mdev->device, &mlx5_vdpa_ops,
+	ndev = vdpa_alloc_device(struct mlx5_vdpa_net, mvdev.vdev, mdev->device, &mgtdev->vdpa_ops,
 				 MLX5_VDPA_NUMVQ_GROUPS, MLX5_VDPA_NUM_AS, name, false);
 	if (IS_ERR(ndev))
 		return PTR_ERR(ndev);
@@ -3546,6 +3564,10 @@ static int mlx5v_probe(struct auxiliary_device *adev,
 		MLX5_CAP_DEV_VDPA_EMULATION(mdev, max_num_virtio_queues) + 1;
 	mgtdev->mgtdev.supported_features = get_supported_features(mdev);
 	mgtdev->madev = madev;
+	mgtdev->vdpa_ops = mlx5_vdpa_ops;
+
+	if (!MLX5_CAP_DEV_VDPA_EMULATION(mdev, desc_group_mkey_supported))
+		mgtdev->vdpa_ops.get_vq_desc_group = NULL;
 
 	err = vdpa_mgmtdev_register(&mgtdev->mgtdev);
 	if (err)
diff --git a/include/linux/mlx5/mlx5_ifc_vdpa.h b/include/linux/mlx5/mlx5_ifc_vdpa.h
index 9becdc3fa503..b86d51a855f6 100644
--- a/include/linux/mlx5/mlx5_ifc_vdpa.h
+++ b/include/linux/mlx5/mlx5_ifc_vdpa.h
@@ -74,7 +74,11 @@ struct mlx5_ifc_virtio_q_bits {
 	u8    reserved_at_320[0x8];
 	u8    pd[0x18];
 
-	u8    reserved_at_340[0xc0];
+	u8    reserved_at_340[0x20];
+
+	u8    desc_group_mkey[0x20];
+
+	u8    reserved_at_380[0x80];
 };
 
 struct mlx5_ifc_virtio_net_q_object_bits {
@@ -141,6 +145,7 @@ enum {
 	MLX5_VIRTQ_MODIFY_MASK_STATE                    = (u64)1 << 0,
 	MLX5_VIRTQ_MODIFY_MASK_DIRTY_BITMAP_PARAMS      = (u64)1 << 3,
 	MLX5_VIRTQ_MODIFY_MASK_DIRTY_BITMAP_DUMP_ENABLE = (u64)1 << 4,
+	MLX5_VIRTQ_MODIFY_MASK_DESC_GROUP_MKEY          = (u64)1 << 14,
 };
 
 enum {
-- 
2.41.0

