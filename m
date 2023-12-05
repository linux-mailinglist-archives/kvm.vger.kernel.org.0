Return-Path: <kvm+bounces-3509-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6792E80510F
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 11:47:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1E09328194A
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 10:47:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B68C959E3A;
	Tue,  5 Dec 2023 10:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="S5znUFSZ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2059.outbound.protection.outlook.com [40.107.100.59])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3815E116;
	Tue,  5 Dec 2023 02:46:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nd/QRdGUnQ8xPL+rTevk8YIRcku05uvXs/pA8STLkTdMdrMLPKx4YtzETSVUhxluMPOflgFcV5z/vaJaHs7ugMAJLp2LuzWJ8F/FtevMGSTPf3cysjYEiMlE5kaZL1cmpfamtJA3jitJVCqPk36oD+e0baIVusF2xz3TnRATeczkdIl+H4MEJ37EueF3kfQa3qkGH0Ipk3Z9C4vaVPh8WSXxMaiurzm5WOPkEIQ6snsQVbiXPjAoJKsXNmVOJdSfQpP2hWCz41kCtjGcJhaGBlPjbDq5lOgNQOYapnaYkPV4uyl62MDHcF0gSjqqv/JFMTzMOp6fFoVo3qksC5ivaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CGyLeP1cFq3pBUJz5P3wMAmQBwNy91SdqMFyXqiZ1nM=;
 b=gEI6R/2J8QsIeczPvJuycVTvl4R0lUNsOL+CSG6Lu2/dRGiSsXrCRLv0P4FH9fOPaRW/X3h5656+Z1KeQ8cEtW9Tfs9igTXVd/IFF1h58DfY2n28TZJs0tCufezTC320Gp34MSsT6mV3VV1x3g01mqpQUZEO3+Z86mE+FtikkmFKXg11Ti1u+Oo6QVPSyPgpgpVNLODcBT9gzIVyDLFeMUkTCQpAdyNaoYg868FNLmDg5KDOJzSfg8wbb30OtauQZbSSClc9U0ypJtcsuvUFPOBSMzmtSoBG7ise2Hf8Pg6TH86zV+ZpytasNywW2Zto6UBT+64pHhClBUmeG5zvRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CGyLeP1cFq3pBUJz5P3wMAmQBwNy91SdqMFyXqiZ1nM=;
 b=S5znUFSZ/SWyNvsvKeHgYthaBbub6BHP/9ttLGhwrMp9LX1YMfTQybApujyBfnfEpPczPXkW4NNTNts1M27Ger27da5vaoFCyDKb5L/mPQ8XPgyN5XEmkDLWXNkMPEJcQVdO//z3spb73WykVoJyufp2IHhO8ByDZwVI5bIYmxoiTlD4Gc7HwOWjaNY9xcFzXRK2Hvn+L+0ZdxXf7H2AuxsHTkluNC7mQbdAMrT0byiVRUkUKqRWKF80+y4EsIkM6/Go4VA2TEWcGsU7G9g+Jfvx2Utzst1aYQlLzLl2OOJMy7e/dynHbBJTUHkWpLfEt4sjkEpWrC3bYcNQtfC6OQ==
Received: from PR0P264CA0168.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1b::36)
 by DM4PR12MB5358.namprd12.prod.outlook.com (2603:10b6:5:39c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Tue, 5 Dec
 2023 10:46:48 +0000
Received: from SA2PEPF000015C8.namprd03.prod.outlook.com
 (2603:10a6:100:1b:cafe::86) by PR0P264CA0168.outlook.office365.com
 (2603:10a6:100:1b::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34 via Frontend
 Transport; Tue, 5 Dec 2023 10:46:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SA2PEPF000015C8.mail.protection.outlook.com (10.167.241.198) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7068.20 via Frontend Transport; Tue, 5 Dec 2023 10:46:47 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 5 Dec 2023
 02:46:35 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 5 Dec 2023
 02:46:34 -0800
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.8) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Tue, 5 Dec 2023 02:46:31 -0800
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, <virtualization@lists.linux-foundation.org>, Gal Pressman
	<gal@nvidia.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>
Subject: [PATCH vhost v2 4/8] vdpa/mlx5: Mark vq addrs for modification in hw vq
Date: Tue, 5 Dec 2023 12:46:05 +0200
Message-ID: <20231205104609.876194-5-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF000015C8:EE_|DM4PR12MB5358:EE_
X-MS-Office365-Filtering-Correlation-Id: 2308df19-1e91-44aa-fea8-08dbf57f7afc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	SIOSg1xefXfBdhNPxegUmam1vABP2JvBQiKBvdrNplFN7FYWGNgM5QCuf7HJWjXnsiEBUuAw983kaW97FWVwDNUVTs6JMUyFea4LxBLWE7gIaqb15a/Uo9/+M8iy6/HRs4xkkoksm0FmsQYPpNk1DUy1v2XnRZlK821qWDdWgYaMsEeRFZ18QsT5KcitKqGQBlKHngvrWeBgmxtHUGFnHxa11vkvHdH6Ch3Y3f3e//54qe6jAcmn72TpUqJm7ttEAqoMjde81uB+7Fii+vczywoiLF6YFHyWG780tx7EZYU7nZd7b5t8RKkyJeddsLmoGhgFn7wQOzPFFJ4ZMZjdg7EUbtv/sUKgA0Y3pG7lAGCLkich8UlIei65M9G2Uy5ox18N0xyrowtGagUfWul7XNJDBLvL3mwlD8xGdnjOCwTx0L56HEJrCGD1sd/p/SFZk1+raDw0SHCBcphMX9Pji7UBZtyXvLkiuHsGNlURYkbDDVOJ9T2KRtD1Q5uzKCtjQPeXFIIZS6zxzOENCYd/+m1l/QFwOrB40nPwNp9aukbCTKBAffmDND6ItBTShHVZ1T6k0akrmNz6By5OgU3sCiu86nIULzcN0xy50l4b42V2zH1VX0J1H2uA2mAnefhlgwXFc6k5MPIkzb8KCv8W15XAKFRMhqUJaeEB0l97yWYvRjjjWQu7AlhbcE3lBCwHCZux8YMAitKmeRsvU7U1VS0MJpBOYEYHbnjo/Y+vQNccupHsj69XECqUOAFlr2pN
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(346002)(376002)(396003)(39860400002)(230922051799003)(451199024)(82310400011)(186009)(1800799012)(64100799003)(40470700004)(46966006)(36840700001)(40460700003)(54906003)(316002)(86362001)(478600001)(8936002)(8676002)(6636002)(4326008)(70586007)(110136005)(70206006)(41300700001)(36756003)(5660300002)(2906002)(36860700001)(356005)(7636003)(47076005)(2616005)(26005)(1076003)(6666004)(82740400003)(83380400001)(336012)(426003)(40480700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2023 10:46:47.4703
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2308df19-1e91-44aa-fea8-08dbf57f7afc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF000015C8.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5358

Addresses get set by .set_vq_address. hw vq addresses will be updated on
next modify_virtqueue.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Acked-by: Eugenio Pérez <eperezma@redhat.com>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c  | 9 +++++++++
 include/linux/mlx5/mlx5_ifc_vdpa.h | 1 +
 2 files changed, 10 insertions(+)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index f8f088cced50..80e066de0866 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1209,6 +1209,7 @@ static int modify_virtqueue(struct mlx5_vdpa_net *ndev,
 	bool state_change = false;
 	void *obj_context;
 	void *cmd_hdr;
+	void *vq_ctx;
 	void *in;
 	int err;
 
@@ -1230,6 +1231,7 @@ static int modify_virtqueue(struct mlx5_vdpa_net *ndev,
 	MLX5_SET(general_obj_in_cmd_hdr, cmd_hdr, uid, ndev->mvdev.res.uid);
 
 	obj_context = MLX5_ADDR_OF(modify_virtio_net_q_in, in, obj_context);
+	vq_ctx = MLX5_ADDR_OF(virtio_net_q_object, obj_context, virtio_q_context);
 
 	if (mvq->modified_fields & MLX5_VIRTQ_MODIFY_MASK_STATE) {
 		if (!is_valid_state_change(mvq->fw_state, state, is_resumable(ndev))) {
@@ -1241,6 +1243,12 @@ static int modify_virtqueue(struct mlx5_vdpa_net *ndev,
 		state_change = true;
 	}
 
+	if (mvq->modified_fields & MLX5_VIRTQ_MODIFY_MASK_VIRTIO_Q_ADDRS) {
+		MLX5_SET64(virtio_q, vq_ctx, desc_addr, mvq->desc_addr);
+		MLX5_SET64(virtio_q, vq_ctx, used_addr, mvq->device_addr);
+		MLX5_SET64(virtio_q, vq_ctx, available_addr, mvq->driver_addr);
+	}
+
 	MLX5_SET64(virtio_net_q_object, obj_context, modify_field_select, mvq->modified_fields);
 	err = mlx5_cmd_exec(ndev->mvdev.mdev, in, inlen, out, sizeof(out));
 	if (err)
@@ -2202,6 +2210,7 @@ static int mlx5_vdpa_set_vq_address(struct vdpa_device *vdev, u16 idx, u64 desc_
 	mvq->desc_addr = desc_area;
 	mvq->device_addr = device_area;
 	mvq->driver_addr = driver_area;
+	mvq->modified_fields |= MLX5_VIRTQ_MODIFY_MASK_VIRTIO_Q_ADDRS;
 	return 0;
 }
 
diff --git a/include/linux/mlx5/mlx5_ifc_vdpa.h b/include/linux/mlx5/mlx5_ifc_vdpa.h
index b86d51a855f6..9594ac405740 100644
--- a/include/linux/mlx5/mlx5_ifc_vdpa.h
+++ b/include/linux/mlx5/mlx5_ifc_vdpa.h
@@ -145,6 +145,7 @@ enum {
 	MLX5_VIRTQ_MODIFY_MASK_STATE                    = (u64)1 << 0,
 	MLX5_VIRTQ_MODIFY_MASK_DIRTY_BITMAP_PARAMS      = (u64)1 << 3,
 	MLX5_VIRTQ_MODIFY_MASK_DIRTY_BITMAP_DUMP_ENABLE = (u64)1 << 4,
+	MLX5_VIRTQ_MODIFY_MASK_VIRTIO_Q_ADDRS           = (u64)1 << 6,
 	MLX5_VIRTQ_MODIFY_MASK_DESC_GROUP_MKEY          = (u64)1 << 14,
 };
 
-- 
2.42.0


