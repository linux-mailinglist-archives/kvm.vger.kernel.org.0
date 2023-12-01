Return-Path: <kvm+bounces-3097-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0647480090A
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 11:50:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 26A491C21015
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 10:50:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55E6921A15;
	Fri,  1 Dec 2023 10:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hrU2cjWN"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2056.outbound.protection.outlook.com [40.107.94.56])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B15FD19B9;
	Fri,  1 Dec 2023 02:50:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kVgVl/8bxgtTRh/JNNMtm860s3UpzYQncEPNEJ5yogX6z3hfK7D8oVrc89BYGb0KNMuQaPHvVEUT4KuWc9N5d0QWn3c5ubZY0qpbm8I6QKSdJbF5KiE6yheCBphQaRUj22dWXfI57klViMiGpdrpQiPQQ5vp3yqzUIWjNUvK0Isd/ykh9mPh1Ur0g/b6GqEfS0cdsrwJFA9cm1voOpvIytZ45V6jQXc7nF5Pby5Bn52gZ5JlBT0VqEN7gv8t0F2F3vJMGc3o44MLbRjh3/Pa+/970RpnbQEQqr/zfrkcp+2fcbrTQR0IjlpAAA4SWUWhRtD2XFtNf/ONByNteOWXYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C9Jspx+SLwQ9ATSuVOd0UT8zDB4SlGNgjSwZ95Ao924=;
 b=LIQUsMWMdq7XRqdEcMJ4qac9psotUy6TT+BSGys4zCwLeXtJcQ9GyMbn7bjNLjCjHC6QlGChkLL+WyPlEV75ZvOIs3i6HQAGnMTv5Zg4HAC3Nza9Zv2d3dpKa/D4gklFdi+5Rns8kps9e3vu5EImWbMH+E5KUlMBOgZ62vX3mB2Ot3OG1k8XD5kcwO11XHF5g1wOWZFI6Ug94wjSbxORR4KHTiQtoyJaezWspU/SyJuuAChLY+lW9XvetYUXfxd/aWVelQGmCAasLd7msUp7L7UqDQP3yono5Vw717vf4Lqa8Gr5xfki2jCOmYqIIoq80S1U+vgzzYhpS9oMoviNaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C9Jspx+SLwQ9ATSuVOd0UT8zDB4SlGNgjSwZ95Ao924=;
 b=hrU2cjWNT+MmvzkBYduT0vd4+p29uT49FvTfmpEx2db6avlh2epeNf4L+VlUcWrAbtsbPL9IqWKXHeEQf5ujc5ZqT4VT3onZvU1ml89O7a7zsGNk8UHqonF+aSRswNR3wV3Ud1c+xwLyqRU2xcnnqY1ky/KKosxVIHe84VadRivXIrnfIsMQkPlbmATIJL2MJD8HxGf/IgU1qQ76zxzGsgyDBNT2vHZUQFd8uOMr2filzIP3faMH5Scu+D5rL8/5+HD2xQoTTq+6jLTV0Nhq+MWdbIZPV1hoJIoMUnQIMQ7bexaqjZ2A85UCXzm0pa7P4tuBaTNFZppdU6XPO06+2A==
Received: from BL0PR05CA0008.namprd05.prod.outlook.com (2603:10b6:208:91::18)
 by IA1PR12MB8405.namprd12.prod.outlook.com (2603:10b6:208:3d8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.29; Fri, 1 Dec
 2023 10:49:58 +0000
Received: from BL02EPF0001A0FC.namprd03.prod.outlook.com
 (2603:10b6:208:91:cafe::ad) by BL0PR05CA0008.outlook.office365.com
 (2603:10b6:208:91::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.17 via Frontend
 Transport; Fri, 1 Dec 2023 10:49:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF0001A0FC.mail.protection.outlook.com (10.167.242.103) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7046.17 via Frontend Transport; Fri, 1 Dec 2023 10:49:58 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Fri, 1 Dec 2023
 02:49:42 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Fri, 1 Dec 2023
 02:49:41 -0800
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Fri, 1 Dec 2023 02:49:38 -0800
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, <virtualization@lists.linux-foundation.org>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Gal Pressman <galp@nvidia.com>, Parav Pandit
	<parav@nvidia.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Subject: [PATCH vhost 6/7] vdpa/mlx5: Mark vq state for modification in hw vq
Date: Fri, 1 Dec 2023 12:48:56 +0200
Message-ID: <20231201104857.665737-7-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231201104857.665737-1-dtatulea@nvidia.com>
References: <20231201104857.665737-1-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0FC:EE_|IA1PR12MB8405:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b5aea7f-6dc4-4869-02e8-08dbf25b4323
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	8/ZMmQWXbsByNyNUq/tb5s3+MlTT5VWcOvWiN7bbKrun9WZTH7jJUyZ02hxdCR7AIly8fETyWjuC7P1LvbMi1IEMGoj+ZdNouqkEHEN31wWB5XksN7nJUHCL43P1uy1h1hI3KlEiwCc15JVnadOQ4hSvurI1WfHYuSIzP2rrl3oFrdJ7otTkxI+DixCucgTiUH2Yd5nUG6w+QWVIh3KWpzeZbzFUuAhZ9SQ4aK8W9nbddf0d8bDytKhwq9Yct9VIbqgSWVVXrigH/frK92Hpe1jThKRGJjuHHh8jKSVm7NICRYc8QTHC/orqIht3SJOmjYHIj1T112s6enHg3ErPNxbfK23Df0Fu+u92tliCHSFPFDfRH80c78bU7f/ZDEvA1IurMU1C9lLbbWkCOmG6nj6c9OSLOCQZmlKfuK8SReep7Ok5e5wWOm5JTTyvu+1mWsf5fvu8uGRRQyPIKxC4no//Vy7RpYZhXxHk8zEBrx9S8+dfKBY+piSRx8m41ta3USevdJPCsypNHGha48diLzZ3POpHk2Of+7xac8xg/RBK9o03GrWGNw/oTxs1c0tRHSfvsvXFMAWTtIaN5yuamwe7+rnCPOxcIRrh6mSjlAsyB7wPOmONRr7J2Jc3FB1KyRDNNFOeMWfQM7+XiluuNVUnOWVVdif7aNYC2ZNS8bAxhvW7o/7wMVOcUeOHJhZzqpeXqo+qlj5C0RpbuXU2yeSV6nalRw79uVY5u2HGRw36+rEzZZpHnGu1tgO35owm
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(376002)(136003)(39860400002)(346002)(230922051799003)(1800799012)(451199024)(64100799003)(82310400011)(186009)(36840700001)(40470700004)(46966006)(40460700003)(426003)(336012)(82740400003)(36756003)(86362001)(7636003)(356005)(47076005)(36860700001)(110136005)(70586007)(70206006)(4326008)(8676002)(8936002)(54906003)(316002)(40480700001)(5660300002)(2906002)(2616005)(1076003)(478600001)(26005)(6666004)(41300700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2023 10:49:58.3495
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b5aea7f-6dc4-4869-02e8-08dbf25b4323
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A0FC.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8405

.set_vq_state will set the indices and mark the fields to be modified in
the hw vq.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c  | 8 ++++++++
 include/linux/mlx5/mlx5_ifc_vdpa.h | 2 ++
 2 files changed, 10 insertions(+)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 2277daf4814f..6325aef045e2 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1249,6 +1249,12 @@ static int modify_virtqueue(struct mlx5_vdpa_net *ndev,
 		MLX5_SET64(virtio_q, vq_ctx, available_addr, mvq->driver_addr);
 	}
 
+	if (mvq->modified_fields & MLX5_VIRTQ_MODIFY_MASK_VIRTIO_Q_AVAIL_IDX)
+		MLX5_SET(virtio_net_q_object, obj_context, hw_available_index, mvq->avail_idx);
+
+	if (mvq->modified_fields & MLX5_VIRTQ_MODIFY_MASK_VIRTIO_Q_USED_IDX)
+		MLX5_SET(virtio_net_q_object, obj_context, hw_used_index, mvq->used_idx);
+
 	MLX5_SET64(virtio_net_q_object, obj_context, modify_field_select, mvq->modified_fields);
 	err = mlx5_cmd_exec(ndev->mvdev.mdev, in, inlen, out, sizeof(out));
 	if (err)
@@ -2328,6 +2334,8 @@ static int mlx5_vdpa_set_vq_state(struct vdpa_device *vdev, u16 idx,
 
 	mvq->used_idx = state->split.avail_index;
 	mvq->avail_idx = state->split.avail_index;
+	mvq->modified_fields |= MLX5_VIRTQ_MODIFY_MASK_VIRTIO_Q_AVAIL_IDX |
+				MLX5_VIRTQ_MODIFY_MASK_VIRTIO_Q_USED_IDX;
 	return 0;
 }
 
diff --git a/include/linux/mlx5/mlx5_ifc_vdpa.h b/include/linux/mlx5/mlx5_ifc_vdpa.h
index 9594ac405740..32e712106e68 100644
--- a/include/linux/mlx5/mlx5_ifc_vdpa.h
+++ b/include/linux/mlx5/mlx5_ifc_vdpa.h
@@ -146,6 +146,8 @@ enum {
 	MLX5_VIRTQ_MODIFY_MASK_DIRTY_BITMAP_PARAMS      = (u64)1 << 3,
 	MLX5_VIRTQ_MODIFY_MASK_DIRTY_BITMAP_DUMP_ENABLE = (u64)1 << 4,
 	MLX5_VIRTQ_MODIFY_MASK_VIRTIO_Q_ADDRS           = (u64)1 << 6,
+	MLX5_VIRTQ_MODIFY_MASK_VIRTIO_Q_AVAIL_IDX       = (u64)1 << 7,
+	MLX5_VIRTQ_MODIFY_MASK_VIRTIO_Q_USED_IDX        = (u64)1 << 8,
 	MLX5_VIRTQ_MODIFY_MASK_DESC_GROUP_MKEY          = (u64)1 << 14,
 };
 
-- 
2.42.0


