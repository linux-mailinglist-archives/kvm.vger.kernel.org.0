Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5148D79D1B5
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 15:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235616AbjILND4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Sep 2023 09:03:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235606AbjILNDc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Sep 2023 09:03:32 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2053.outbound.protection.outlook.com [40.107.93.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1D8210DC;
        Tue, 12 Sep 2023 06:02:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BnN8N3vND4uY32W3/DAgys8Jv4802nQou+sUwZDBOY9Qwmm2Gpdmld9UFnaOhOUSUQuHBHoxPOUW6hReI7csukUZ+XHj2R51Wsqbzp5R34dygAOYefXNYPBoJn7YQ9yyikcX3Y5x/YD4HitMw06+7iHXEZSZSo7qUZ9D8zMazUQ5FxajIpJxxKCKq+LHmcsJ0+KyZkzL1bBLHAgKduGJ/h7jBXiisLtCRbn/GWeRkpxYEzh/d1c1kassvmeoWX7lvQVJz7sR3gfAUFurbW/iEqAysyhjbVFyFmkkO9xr6Ukq75BaMdrGctXZ2uyFGDLWI/heaeAiMuRup1pElAU2Ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lKq9IMKqpzjQWH+OB0JFNt6n/COgZeKjh9r06JoxsOg=;
 b=SNWBnppM1eoHh3xl5erXBwE6A+7aXla5BsVdARiCN+5oiRcaOd2V3w+OVUbzfb3PbtKaRf4evzCR5fbtisqAU0MrqbYDyHbkD3tKk/L74NP+TIBasxnbakS/9Y3+Ob+I71vhFQEc2bWqSibWNHby0ATRRQsN2+u2P15oZ4SyME2n3mw16Fi2DW2RVhymlFU0k0ZfrwElwIeOZbgKIqNQAWbxZNilkW/WhpOFfIkLEWctawx1Aj5Q5AloiRq9163Nja7ELn3Xz4tkVygd8gE5zr3vj3b6cos+sz/2PJK37iZi2eZdcu5NrnkfSgs2iYzuw+CI/4wSMGwQss4Yw9FkpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lKq9IMKqpzjQWH+OB0JFNt6n/COgZeKjh9r06JoxsOg=;
 b=k3LQhIDcklkvQcnw2gTp5MNpEF00NqW5XuTT94nx0q3pcKEuz70lYGcwlyneyWJKiyJWXjeesuV8SjDCzJCuhrpfaEZy48qKN6p1KQCyt09R5zuk++v+St9m0kqv/lWDL16kFH9ULxI9uVYaWtkgOU4BxyHECnRoyDj4Cgc0NVdpFvGgTSHBMby99IBLJegU8sb3jJg6bxOtsdHGPcO12xpgB9dFpnYHOCuz9IAfc6jncy7TJ5nbKPwFe7qla38/Q6vaTzD2MkISQ/JHfPobqhSGFE80hEiyA5O8218QQ8KFRwCHt7QGmP4S8qmt+Zb85ZjEM3gSkywJxdSWGQSxWw==
Received: from DM6PR02CA0148.namprd02.prod.outlook.com (2603:10b6:5:332::15)
 by SA3PR12MB8801.namprd12.prod.outlook.com (2603:10b6:806:312::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.35; Tue, 12 Sep
 2023 13:02:46 +0000
Received: from CY4PEPF0000E9D7.namprd05.prod.outlook.com
 (2603:10b6:5:332:cafe::87) by DM6PR02CA0148.outlook.office365.com
 (2603:10b6:5:332::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.38 via Frontend
 Transport; Tue, 12 Sep 2023 13:02:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000E9D7.mail.protection.outlook.com (10.167.241.78) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6792.11 via Frontend Transport; Tue, 12 Sep 2023 13:02:45 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 12 Sep 2023
 06:02:29 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 12 Sep
 2023 06:02:28 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.10) with Microsoft SMTP Server id 15.2.986.37 via
 Frontend Transport; Tue, 12 Sep 2023 06:02:26 -0700
From:   Dragos Tatulea <dtatulea@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>,
        =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        <virtualization@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     Dragos Tatulea <dtatulea@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>, <kvm@vger.kernel.org>
Subject: [PATCH 13/16] vdpa/mlx5: Enable hw support for vq descriptor mapping
Date:   Tue, 12 Sep 2023 16:01:23 +0300
Message-ID: <20230912130132.561193-14-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230912130132.561193-1-dtatulea@nvidia.com>
References: <20230912130132.561193-1-dtatulea@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D7:EE_|SA3PR12MB8801:EE_
X-MS-Office365-Filtering-Correlation-Id: 845937fd-ef6b-4492-1956-08dbb3908f11
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jCmvyr/wjNgp0k73n4rlTtkCdJXxU5n1c82d4cme6Mf0Ahh4UB57unQLkmWal3wMnx1/ubtHd04uHADPzljOVR8fB/itUmGsqUJjkLhyK9lc4iSp57NEUx9/SAtpouRY7pogEVhnJ/AcZTQHXT5/o0d/CzEIsY7BU/RHrpKchG8+5Wkchp0w3AN56xenU43LmzQIkNo6XeQ7WTIOexzaa+c4X6j9yC1BOovNpGPx1YsatW6HZ8Q94deUaNFC+B1ghMsXkZ3YdXY+ixPEbt/JuB16svapx1LPXJrhhF7av/eIr0fhJpF+R6XSPRtZpj7chKrBsi2fNREcJdzw3/lX6uZn6YKiATLUfyMnjvDjkFk2M0l0z1WwkvT1239EyogcifSOcXTkdEIBrc64w0d0yKQEA3oLDMF7vsVyFWgNkxEmxm8oMwa4rrUckcrXATO01xj32Kbla6YD2Bd9z4UciOWBm5jf0XNRMovzNkpUkFVbTOn3CoyEJ7iLhfddkf50b8syPhybETzvAkNMWjd7Jwn1bDijcSyhJpo5oATBfCsMK+Si+fIDmu2iQQ5WMGssXXrp5Ifh2p/YzzKyTZcN22GE/neW3Ory1VbUy8CPkf/EtEezkG39TeCtE3aroXwjbBq0wiud4qvk615vhkkaLJNoetnwrAjOoQxTXox39HHIHl5vS+3HG9juEJpUyfvOVvJl3/dSmQTLT5BrYQnOx1ttFr/dtPxIHAeqXK5iSp2pzlMTqF6FoGjqngq7z+9V
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(346002)(396003)(376002)(136003)(1800799009)(186009)(451199024)(82310400011)(36840700001)(46966006)(40470700004)(36756003)(40460700003)(7636003)(40480700001)(356005)(2906002)(86362001)(4326008)(82740400003)(36860700001)(8676002)(2616005)(8936002)(47076005)(83380400001)(336012)(426003)(5660300002)(1076003)(41300700001)(26005)(6666004)(478600001)(110136005)(70206006)(70586007)(316002)(54906003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2023 13:02:45.7794
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 845937fd-ef6b-4492-1956-08dbb3908f11
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000E9D7.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8801
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

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c  | 26 ++++++++++++++++++++++++--
 include/linux/mlx5/mlx5_ifc.h      |  8 +++++++-
 include/linux/mlx5/mlx5_ifc_vdpa.h |  7 ++++++-
 3 files changed, 37 insertions(+), 4 deletions(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 5bb9a7528b08..c5e9c84988cc 100644
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
@@ -3139,7 +3155,7 @@ static int mlx5_set_group_asid(struct vdpa_device *vdev, u32 group,
 {
 	struct mlx5_vdpa_dev *mvdev = to_mvdev(vdev);
 
-	if (group >= MLX5_VDPA_NUMVQ_GROUPS)
+	if (group >= MLX5_VDPA_NUMVQ_GROUPS || asid >= MLX5_VDPA_NUM_AS)
 		return -EINVAL;
 
 	mvdev->group2asid[group] = asid;
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
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 33344a71c3e3..db21c96e5407 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1229,7 +1229,13 @@ struct mlx5_ifc_virtio_emulation_cap_bits {
 	u8         max_emulated_devices[0x8];
 	u8         max_num_virtio_queues[0x18];
 
-	u8         reserved_at_a0[0x60];
+	u8         reserved_at_a0[0x20];
+
+	u8	   reserved_at_c0[0x14];
+	u8         desc_group_mkey_supported[0x1];
+	u8         reserved_at_cf[0xb];
+
+	u8         reserved_at_e0[0x20];
 
 	u8         umem_1_buffer_param_a[0x20];
 
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

