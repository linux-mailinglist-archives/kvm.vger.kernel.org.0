Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16F1A7CE447
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 19:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235423AbjJRRRt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 13:17:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235013AbjJRRRO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 13:17:14 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2083.outbound.protection.outlook.com [40.107.92.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A64011709;
        Wed, 18 Oct 2023 10:16:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=go8LIE97kvUwdpbCQzE2tu2OWThNOG82qgbuK2LINxN6WxVypXIjOgg5pCTvS+0goRL+FdWfIqShVAjf7URtZq+CAiW5whbQFPBepOQ11Y0ISsiix/TtbzPbgE9D4oI5OcCmwsF9xIP0fmyug/d7bzldKymVWq9QtwEmn5+oKvR6NLmZW4DRsNTbfPRXaKDBa/ivlWv0TKLG7WWJj5iDHuFQ8sxXo5k1GIRjLvCskDMy+jphB6mSm49edYVkN+Q3c4uqatyqEB7FktGyWrqH3LCjuZmIQ5VadXCjNjqZm8UvCC3DRa9cIIwNnZe8DqHxd8l8SgiFedU12IcvLnjIaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fxAFjgl71dKtPW1VP7nvgdxX96LoRPCBaqis2IoV/TE=;
 b=T8ZLkHdQHxVxUt8sAY28oSlLqPotiti0woS8nj4k3Kcrh3W/amWDW2Ult6bFlLmZyRIr34f9FoJD9siBf4wwKOIU4ayET08KAm9Zgg4uvqNZuC3Ggc31UkRy7BW09nHtGxHnoVA9ZQ+XmmcAtu3mX1guivJDrS2SJVsIJtG76H+Alpn7ZJHYjSW6K9BwLZ43Aj7IpSweZQ9zKGmnSEo11rk5JroGTcu+vdTbux73uXgRknXoQmt+Bx1MNCOzqBPqV0DWLgj6ov7ZwwkILDzN/QPcj0lspMwJSkuHIzY0A9uT3CLNSoR+V/nMdpYYtoF+WKS/ZleWOMCg6PlfOglDrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fxAFjgl71dKtPW1VP7nvgdxX96LoRPCBaqis2IoV/TE=;
 b=V4B6YJGPSSpxc63GyVPcGP643CcmZbcsaigDp7PSlbPFi3ImjiYG8DHQ9Bprc8R2VlbKDAUbNBxDfR/RZ8Q1HfKP002sHKfPP5eMkkYNXIDgsYGOyNb1eNxbddRXzU2bo6uTYtfQ2y9otABLJ7dFMEHYJ3gccPSMneNmDuODzErMuSkK2dg6y+y1FaLXMP2/ssGeSM3v1lQybH6/f0FpDU1mUEhTeHM3dDuNjiihZj5alLV7eCQAKMOLNgBv1TBXwqrJjN3g4SPM0DXn5fwfG72XFO3cpuQ+uV5x0QwIcgPNPc4MiwifHuO3W0Jvdf8B0wx/frZsfVhm8gpvAxtO8A==
Received: from CH0P220CA0001.NAMP220.PROD.OUTLOOK.COM (2603:10b6:610:ef::19)
 by DS0PR12MB7969.namprd12.prod.outlook.com (2603:10b6:8:146::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.21; Wed, 18 Oct
 2023 17:16:30 +0000
Received: from DS2PEPF00003446.namprd04.prod.outlook.com
 (2603:10b6:610:ef:cafe::f0) by CH0P220CA0001.outlook.office365.com
 (2603:10b6:610:ef::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.21 via Frontend
 Transport; Wed, 18 Oct 2023 17:16:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS2PEPF00003446.mail.protection.outlook.com (10.167.17.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6907.20 via Frontend Transport; Wed, 18 Oct 2023 17:16:30 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 18 Oct
 2023 10:16:16 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 18 Oct
 2023 10:16:15 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.8) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Wed, 18 Oct 2023 10:16:12 -0700
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
Subject: [PATCH vhost v4 14/16] vdpa/mlx5: Enable hw support for vq descriptor mapping
Date:   Wed, 18 Oct 2023 20:14:53 +0300
Message-ID: <20231018171456.1624030-16-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231018171456.1624030-2-dtatulea@nvidia.com>
References: <20231018171456.1624030-2-dtatulea@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF00003446:EE_|DS0PR12MB7969:EE_
X-MS-Office365-Filtering-Correlation-Id: e15a2f69-5892-41f1-b374-08dbcffdf897
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wZb4Ys7Mevhp9YBrGMgNOq/74H36lZyg0Cos9NozfBK3IEbXZa56x6fwd6bIkaDu1wK/MQy84qVUr7TTo+0U2dfAhgegeAgedHez0nhtmQYOcz92I+114CP5nTLA1Glh/AApAOwpW6wJCB6p2KkG6xtZLsFGYVjVWtdNZdr8phuRUqB/ZksybwvDqpLqD46Z+Od+aBaipPdXxJFRfFwpu5TsBZTrS56THtUr17CPaPQvPEDzesOaTU5zqdKw0cY3j8YjLRck5qLGySjcqyAZo29Z2HD+zN2eR2jxwf0DAgdB0rWFPhRKb7cSk9pP9KiO+yZq/QsoiaqVlvn/XUxopycAUsIi0JdAEsDOQHYDJSxifdj35/seggZkVA9RN56jHZYSAd5nXa16CPhgDKeplMvAScNcLiftgCzr3OjweXg8asWOESO51jdCtcQ1bP/hOFk+BxnaGfwyM+hlBihmnMhU9OXLlnWeb4Gqh7WT0qUW9UvmMFD98ArCyRzUrsoHAlydxvG8lMwHD+0pjYf2d98j4tidDxJK0zErSo4PDMZDnstOVM/k0508ikQ5qQMriBJaPzwRX+d4xf7VP3awuJlJ9grniD9orFdvQjo5G6OQxPZ60T9aF0DlGXqsfkt5zcGoEvhBHUdHZDFFMpYragjmCUR2d/vtfljtxC/vVqGA1wD2MZtzu2eZxNIR/5iGmolIOaFqFqNA8sWNeezme7xjo9i8T0dvISItNKRbgPpdA1OMfRTPs834Tqak9kW1
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(136003)(346002)(39860400002)(396003)(230922051799003)(82310400011)(1800799009)(186009)(64100799003)(451199024)(40470700004)(46966006)(36840700001)(86362001)(36756003)(40460700003)(8936002)(40480700001)(2616005)(54906003)(70206006)(82740400003)(7636003)(26005)(316002)(356005)(110136005)(83380400001)(336012)(426003)(36860700001)(47076005)(66574015)(1076003)(6666004)(2906002)(41300700001)(70586007)(4326008)(478600001)(8676002)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2023 17:16:30.5861
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e15a2f69-5892-41f1-b374-08dbcffdf897
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS2PEPF00003446.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7969
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
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

Acked-by: Jason Wang <jasowang@redhat.com>
Acked-by: Eugenio Pérez <eperezma@redhat.com>
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c  | 24 +++++++++++++++++++++++-
 include/linux/mlx5/mlx5_ifc_vdpa.h |  7 ++++++-
 2 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index ea76c0b4b78e..87dd0ba76899 100644
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
+	if (vq_desc_mr && MLX5_CAP_DEV_VDPA_EMULATION(mvdev->mdev, desc_group_mkey_supported))
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
@@ -3165,6 +3181,7 @@ static const struct vdpa_config_ops mlx5_vdpa_ops = {
 	.get_vq_irq = mlx5_get_vq_irq,
 	.get_vq_align = mlx5_vdpa_get_vq_align,
 	.get_vq_group = mlx5_vdpa_get_vq_group,
+	.get_vq_desc_group = mlx5_vdpa_get_vq_desc_group, /* Op disabled if not supported. */
 	.get_device_features = mlx5_vdpa_get_device_features,
 	.set_driver_features = mlx5_vdpa_set_driver_features,
 	.get_driver_features = mlx5_vdpa_get_driver_features,
@@ -3263,6 +3280,7 @@ struct mlx5_vdpa_mgmtdev {
 	struct vdpa_mgmt_dev mgtdev;
 	struct mlx5_adev *madev;
 	struct mlx5_vdpa_net *ndev;
+	struct vdpa_config_ops vdpa_ops;
 };
 
 static int config_func_mtu(struct mlx5_core_dev *mdev, u16 mtu)
@@ -3376,7 +3394,7 @@ static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *v_mdev, const char *name,
 		max_vqs = 2;
 	}
 
-	ndev = vdpa_alloc_device(struct mlx5_vdpa_net, mvdev.vdev, mdev->device, &mlx5_vdpa_ops,
+	ndev = vdpa_alloc_device(struct mlx5_vdpa_net, mvdev.vdev, mdev->device, &mgtdev->vdpa_ops,
 				 MLX5_VDPA_NUMVQ_GROUPS, MLX5_VDPA_NUM_AS, name, false);
 	if (IS_ERR(ndev))
 		return PTR_ERR(ndev);
@@ -3551,6 +3569,10 @@ static int mlx5v_probe(struct auxiliary_device *adev,
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

