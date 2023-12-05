Return-Path: <kvm+bounces-3508-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 912AB80510B
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 11:47:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B3D491C20B5C
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 10:47:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6591656B6F;
	Tue,  5 Dec 2023 10:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Uh99H4uW"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2080.outbound.protection.outlook.com [40.107.223.80])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6816D135;
	Tue,  5 Dec 2023 02:46:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HJuR5Uvh7dWkL4X9t8luywoDmCl5CEI5rxgA7lwfZEvLmQ8hYWDqmbonYpAS3nFz/f9IKeKdhpzKhyX31sU3QKh6oFZQXkiSCE3C/rc7w2GgsQiBakEFIqbzbYnMAYQXnNeHtRRBOD5amTthDDWB4mrStuQxazznhN7XsWr++9Pakv6PA8favfPGaiaSk7xTK8WcuMVyyWDu5VhXF3nP5fL9NbMzziYhZJSCrPkb+3u5dtD33YW9EcbOI+acaR6ddaRZpgkV4e0GtyIwF66QsgNfcFV0PO5r+Zs1hg9pzM5YRHm4rJyIe7LhGXN4ws4gDtvnfeKg1/ZqkGRWZ/ggqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DOLe22Cwu8VjfCRuEQma2mo/tC+HslROt3JYWL8C5OI=;
 b=dvwEwpBKV66pqE6/3nWj1n1B7ROE79lUJBw0FRq5kUf+u/I1O1p8htrTkzVZmH/QuYRqEUTaGQVK0jVn0Grik6s3Uci6LPEPKCmlqRQrqlljmmjWTuK7CLL72dj+5qhBdbbbl8YA+Fmf1U/TYj6fq+AGhar4afKZ5y74tfLbdTSnEc/UINz3fb7TCM2cvURr5MBLIEHNYn7l6T7t1dKWQkLueFEcv/YQ0OMDFUjtdO3tm/d3UK9Lz40OvrQCRf5tT2C64NpZluIgzD0BjgdehDgSjC4tEIlpQ6HHMNr+Yx18d+e0JSIF6u/L3WyKtZiLrRmyQrBYOWVjCWAdGT7rCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DOLe22Cwu8VjfCRuEQma2mo/tC+HslROt3JYWL8C5OI=;
 b=Uh99H4uWhyQuPocAiIlGD7vmJQbJ2s7MmMJaCxj297QqEebic0kD6z6RK8mykfgnvuwmvJ+kObiMyAzKp5cEhOtR5RJBbv1d23bFubNUg92QacBwFK7iiegUXWvUmKKMEjTOXJM9F9KsO9JiJM+a0dzGEIStbBDtZ+siHD2eV4jOVdqTDfYpcpD68MItFp8habx4guwKzLXN9/ijqpRJU07v5Jqut4etBBUcUZAXgCqa5FKqXh5OJ47UW1E7mmLsNmuUbZ5IeSPph70Wn9bvbmXv2U2Tjt0TbAThaUFPKY5w0MDqrP1JUfSkLpXdjx9nepXyGePNUIVVBoi8EUO0nQ==
Received: from DS0PR17CA0006.namprd17.prod.outlook.com (2603:10b6:8:191::22)
 by MN0PR12MB6318.namprd12.prod.outlook.com (2603:10b6:208:3c1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Tue, 5 Dec
 2023 10:46:42 +0000
Received: from DS3PEPF000099D6.namprd04.prod.outlook.com
 (2603:10b6:8:191:cafe::5d) by DS0PR17CA0006.outlook.office365.com
 (2603:10b6:8:191::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34 via Frontend
 Transport; Tue, 5 Dec 2023 10:46:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS3PEPF000099D6.mail.protection.outlook.com (10.167.17.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7068.20 via Frontend Transport; Tue, 5 Dec 2023 10:46:42 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 5 Dec 2023
 02:46:31 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 5 Dec 2023
 02:46:31 -0800
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.8) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Tue, 5 Dec 2023 02:46:28 -0800
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, <virtualization@lists.linux-foundation.org>, Gal Pressman
	<gal@nvidia.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>
Subject: [PATCH vhost v2 3/8] vdpa/mlx5: Introduce per vq and device resume
Date: Tue, 5 Dec 2023 12:46:04 +0200
Message-ID: <20231205104609.876194-4-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231205104609.876194-1-dtatulea@nvidia.com>
References: <20231205104609.876194-1-dtatulea@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D6:EE_|MN0PR12MB6318:EE_
X-MS-Office365-Filtering-Correlation-Id: 32d1da99-f106-405d-eac5-08dbf57f77fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	SWNtjpexaz/8Wv341D4tK8xN+yRpVaDNDpt30PEQHW5/d46P9hqFK5JdwmlYsp9156yCF5teLnSpJW1/h6aRdjA+opDue+3ftilrwSdKU+DGZDGGv6ySfeaBXZWZjhDZyqMu4prOVwHY/LPoqViWXpgvDkSs70T8vO7WcDmN4rQpknEpUsdgNx6pBUJVlFq+kJvbrE4ANMTlz2s3l0p4O3qw7CHnOOc4G3+nOZFzgH3gq3dHhAy0+0khCEIOJ9PG1ZGOgXEZQVzpUc53iKuUY+ofUqdlbcHZTfjb1mJ2Zq1glVsYPcHPHrRFmp0+KaNdrxzg++gNp3kIf3lVlcfftH1jb1UtcTwumUuFH0SKngCdWfDp3KXCfSjJFEY0jEtotBpauTK3Dj41Ah62XWB0pvVbq6ua4bDFrXI/qUeyIubwX4xlNdJ6MR+8PU3snYTV0Z0Vo1IYdy3XUeMBe9PYLoppOjdiz745eXTU7ghPowqIBTtq3YMLmkBWsJveY3e6AMOsX4sublOj5uiCSiEobvxegIbSJubyQ0ZkYbYa9AasRblpjnHXa5k44OduX3GCoMuIRnNteciJu+MBSt8hHbz9tDt9E/LdiAThgq54HkuIcfgpPRd0FiuMA0mNVjMOYK4bWAvrlsax/3OX+kDuZMzIrqbjWwUAV+BT939YZkNymFtulN8V2S8vmPrzjxT0eoLQp6IUd666u3V/LsH5bIPLVKwdhDL6wKqRWw/2t+ysqlAUFdL3GYBLLi3Ah0FK
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(346002)(39860400002)(396003)(136003)(376002)(230922051799003)(451199024)(186009)(64100799003)(82310400011)(1800799012)(46966006)(40470700004)(36840700001)(1076003)(2616005)(41300700001)(36756003)(86362001)(66574015)(426003)(40460700003)(83380400001)(26005)(336012)(110136005)(70586007)(316002)(54906003)(6636002)(70206006)(6666004)(4326008)(8676002)(8936002)(478600001)(82740400003)(356005)(36860700001)(2906002)(7636003)(40480700001)(47076005)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2023 10:46:42.4366
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 32d1da99-f106-405d-eac5-08dbf57f77fc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D6.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6318

Implement vdpa vq and device resume if capability detected. Add support
for suspend -> ready state change.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Acked-by: Eugenio Pérez <eperezma@redhat.com>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 69 +++++++++++++++++++++++++++----
 1 file changed, 62 insertions(+), 7 deletions(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 1e08a8805640..f8f088cced50 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1170,7 +1170,12 @@ static int query_virtqueue(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueu
 	return err;
 }
 
-static bool is_valid_state_change(int oldstate, int newstate)
+static bool is_resumable(struct mlx5_vdpa_net *ndev)
+{
+	return ndev->mvdev.vdev.config->resume;
+}
+
+static bool is_valid_state_change(int oldstate, int newstate, bool resumable)
 {
 	switch (oldstate) {
 	case MLX5_VIRTIO_NET_Q_OBJECT_STATE_INIT:
@@ -1178,6 +1183,7 @@ static bool is_valid_state_change(int oldstate, int newstate)
 	case MLX5_VIRTIO_NET_Q_OBJECT_STATE_RDY:
 		return newstate == MLX5_VIRTIO_NET_Q_OBJECT_STATE_SUSPEND;
 	case MLX5_VIRTIO_NET_Q_OBJECT_STATE_SUSPEND:
+		return resumable ? newstate == MLX5_VIRTIO_NET_Q_OBJECT_STATE_RDY : false;
 	case MLX5_VIRTIO_NET_Q_OBJECT_STATE_ERR:
 	default:
 		return false;
@@ -1200,6 +1206,7 @@ static int modify_virtqueue(struct mlx5_vdpa_net *ndev,
 {
 	int inlen = MLX5_ST_SZ_BYTES(modify_virtio_net_q_in);
 	u32 out[MLX5_ST_SZ_DW(modify_virtio_net_q_out)] = {};
+	bool state_change = false;
 	void *obj_context;
 	void *cmd_hdr;
 	void *in;
@@ -1211,9 +1218,6 @@ static int modify_virtqueue(struct mlx5_vdpa_net *ndev,
 	if (!modifiable_virtqueue_fields(mvq))
 		return -EINVAL;
 
-	if (!is_valid_state_change(mvq->fw_state, state))
-		return -EINVAL;
-
 	in = kzalloc(inlen, GFP_KERNEL);
 	if (!in)
 		return -ENOMEM;
@@ -1226,17 +1230,29 @@ static int modify_virtqueue(struct mlx5_vdpa_net *ndev,
 	MLX5_SET(general_obj_in_cmd_hdr, cmd_hdr, uid, ndev->mvdev.res.uid);
 
 	obj_context = MLX5_ADDR_OF(modify_virtio_net_q_in, in, obj_context);
-	if (mvq->modified_fields & MLX5_VIRTQ_MODIFY_MASK_STATE)
+
+	if (mvq->modified_fields & MLX5_VIRTQ_MODIFY_MASK_STATE) {
+		if (!is_valid_state_change(mvq->fw_state, state, is_resumable(ndev))) {
+			err = -EINVAL;
+			goto done;
+		}
+
 		MLX5_SET(virtio_net_q_object, obj_context, state, state);
+		state_change = true;
+	}
 
 	MLX5_SET64(virtio_net_q_object, obj_context, modify_field_select, mvq->modified_fields);
 	err = mlx5_cmd_exec(ndev->mvdev.mdev, in, inlen, out, sizeof(out));
-	kfree(in);
-	if (!err)
+	if (err)
+		goto done;
+
+	if (state_change)
 		mvq->fw_state = state;
 
 	mvq->modified_fields = 0;
 
+done:
+	kfree(in);
 	return err;
 }
 
@@ -1430,6 +1446,24 @@ static void suspend_vqs(struct mlx5_vdpa_net *ndev)
 		suspend_vq(ndev, &ndev->vqs[i]);
 }
 
+static void resume_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *mvq)
+{
+	if (!mvq->initialized || !is_resumable(ndev))
+		return;
+
+	if (mvq->fw_state != MLX5_VIRTIO_NET_Q_OBJECT_STATE_SUSPEND)
+		return;
+
+	if (modify_virtqueue_state(ndev, mvq, MLX5_VIRTIO_NET_Q_OBJECT_STATE_RDY))
+		mlx5_vdpa_warn(&ndev->mvdev, "modify to resume failed for vq %u\n", mvq->index);
+}
+
+static void resume_vqs(struct mlx5_vdpa_net *ndev)
+{
+	for (int i = 0; i < ndev->mvdev.max_vqs; i++)
+		resume_vq(ndev, &ndev->vqs[i]);
+}
+
 static void teardown_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *mvq)
 {
 	if (!mvq->initialized)
@@ -3261,6 +3295,23 @@ static int mlx5_vdpa_suspend(struct vdpa_device *vdev)
 	return 0;
 }
 
+static int mlx5_vdpa_resume(struct vdpa_device *vdev)
+{
+	struct mlx5_vdpa_dev *mvdev = to_mvdev(vdev);
+	struct mlx5_vdpa_net *ndev;
+
+	ndev = to_mlx5_vdpa_ndev(mvdev);
+
+	mlx5_vdpa_info(mvdev, "resuming device\n");
+
+	down_write(&ndev->reslock);
+	mvdev->suspended = false;
+	resume_vqs(ndev);
+	register_link_notifier(ndev);
+	up_write(&ndev->reslock);
+	return 0;
+}
+
 static int mlx5_set_group_asid(struct vdpa_device *vdev, u32 group,
 			       unsigned int asid)
 {
@@ -3317,6 +3368,7 @@ static const struct vdpa_config_ops mlx5_vdpa_ops = {
 	.get_vq_dma_dev = mlx5_get_vq_dma_dev,
 	.free = mlx5_vdpa_free,
 	.suspend = mlx5_vdpa_suspend,
+	.resume = mlx5_vdpa_resume, /* Op disabled if not supported. */
 };
 
 static int query_mtu(struct mlx5_core_dev *mdev, u16 *mtu)
@@ -3688,6 +3740,9 @@ static int mlx5v_probe(struct auxiliary_device *adev,
 	if (!MLX5_CAP_DEV_VDPA_EMULATION(mdev, desc_group_mkey_supported))
 		mgtdev->vdpa_ops.get_vq_desc_group = NULL;
 
+	if (!MLX5_CAP_DEV_VDPA_EMULATION(mdev, freeze_to_rdy_supported))
+		mgtdev->vdpa_ops.resume = NULL;
+
 	err = vdpa_mgmtdev_register(&mgtdev->mgtdev);
 	if (err)
 		goto reg_err;
-- 
2.42.0


