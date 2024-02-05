Return-Path: <kvm+bounces-8015-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 46057849B19
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 13:56:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BFF761F26BF7
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 12:56:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C8AC3A1BF;
	Mon,  5 Feb 2024 12:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DkkFr+Nt"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2078.outbound.protection.outlook.com [40.107.220.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC0539877
	for <kvm@vger.kernel.org>; Mon,  5 Feb 2024 12:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707137353; cv=fail; b=FwbPcKPIwjiwpHE16XpSGVoIo9aZ2+EcilHJPY2p30E8L9KfR70ILEBzGXaYluy+Y0JFmwRc1/XfR0pXXcVZ0PV0r8aBoB+/WX9abU3ocJZ1k8RwQMy7W/ALjXR2sgo+BZOt5oxXZ/LWEOw9baOvmyKSzA9ZiT2w0za2lz0inmg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707137353; c=relaxed/simple;
	bh=Iu0Mkwkk/Zz+xDPN41cOqoKOrvRqWJ1Q7xFwp0QzU38=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cdmNhW0JDFbWLMzrYPLE5Lp5Mw43oAciGZhP23+/jyU0PqQdp8hLA+2lU1UmvjqaSFq/bTgoL+1AEaHpdemgdeHyiSpPIfOyU/POCoTD7FsjY4dnEZCbzIuR6wYw9xddB2bW09gUco2r7BcnA9jKTYveT0df7fH2KURJ2TrVHq0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DkkFr+Nt; arc=fail smtp.client-ip=40.107.220.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LJiDus3BDeTEz9VdJeUQWAZEZNev6/ewraNcgnHpyNR/jMnaQLqbbj8dNuQgEgjL9pCm66DUj0mkxgF1OrkXjzvk2+J3+6Ag5bz5MkliQE6O/LoSGO9x1O6iQqrUOldvRgCQOc7So84CKJ6GmBxZMpC7RMalkqyld3N27egQvgToVlkY2RgbaLW41PnwnfDnc9reNGe/94b1yEhmrF+MUY6JAB6zILeBuVJCwysw984PVJ5EFBG2jVpM/7cRtCncuuS4r0y6Z17DpoP+4W0zqGMo+AhUFmMu/vMYOruNIkQ6AAxFKZ6bNo4vRIQIP659HKzqV87Byjtejck0G/GBGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bMWup6zJaSYCTJHNN7iOeX7R8nq0/cq9ivmLnVgMpg0=;
 b=oY0wUkWroDyXbFZg4/66tj2Kt25pi1LjFFGTaERxBOnd57wLGPHisHL/y3pR19w8Un00rhZf+wJ1UtkkOc7xGcI6MwRmOZHgbkX2nEp+SXV55GGK8JSYT/dl/a4Ulz4dxmEdPr7Nxdl9CEMUCfQZW49+SDALaYx91hRBsTBeSSb8iOypmcnW6+dtivs3WWVIufXr2p/qp4n88WlRRQZNC7F6bEIFo0s6LkOJsYa14smNNHhmWxoNLmTmK9osPfxXMerjxVpgu9oXmzS7O5LmU1o3zE67sL+0f98yI0jQIKMUYpB4TMKpdj4ZJsLdBTES3DYoUGOuaae3E3h6c5w0LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bMWup6zJaSYCTJHNN7iOeX7R8nq0/cq9ivmLnVgMpg0=;
 b=DkkFr+Ntsyq/IoDcx8on1V1JAujqJ/YANNO47Hr9XRIj+bSEv5sZVT7f4iTfpTcWW9PISM/R7QGoZqbSA9CFbaU1pef86rj3NghmSyQdYi2Fa0dWMRa7dkRaAVGmyHnV6hsJtNyEciKf81PB5Qo0WkBqk/fKMrZMBMf0NE08ccDFXBSsVt4MEzXUfi9B6anDJEkV+DcrWTKjtXOVpHgjHpkVtEi9ZiAO8lcnXA2mrIwyPiga3xeuP+JjgFPeCQHQ2y3auRmIEo6bIdPGScaGBXPD0KtRdOwn2oLFWvHKWuwLIvaBZuwQ+5RL3xj7rM1FoR9f82DQWk4Oz9VAoiI7Fw==
Received: from MN2PR03CA0016.namprd03.prod.outlook.com (2603:10b6:208:23a::21)
 by SJ2PR12MB9240.namprd12.prod.outlook.com (2603:10b6:a03:563::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.16; Mon, 5 Feb
 2024 12:49:06 +0000
Received: from MN1PEPF0000F0DF.namprd04.prod.outlook.com
 (2603:10b6:208:23a:cafe::12) by MN2PR03CA0016.outlook.office365.com
 (2603:10b6:208:23a::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.34 via Frontend
 Transport; Mon, 5 Feb 2024 12:49:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MN1PEPF0000F0DF.mail.protection.outlook.com (10.167.242.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7249.19 via Frontend Transport; Mon, 5 Feb 2024 12:49:05 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 5 Feb 2024
 04:48:53 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 5 Feb 2024
 04:48:53 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.1258.12 via Frontend Transport; Mon, 5 Feb
 2024 04:48:50 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
	<maorg@nvidia.com>
Subject: [PATCH V1 vfio 2/5] vfio/mlx5: Add support for tracker object change event
Date: Mon, 5 Feb 2024 14:48:25 +0200
Message-ID: <20240205124828.232701-3-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20240205124828.232701-1-yishaih@nvidia.com>
References: <20240205124828.232701-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0DF:EE_|SJ2PR12MB9240:EE_
X-MS-Office365-Filtering-Correlation-Id: a008f157-b5b4-43f2-7c61-08dc2648d6b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	If7dl+LSznzsRd9rAgBYs8BsH/Vx0BIunlOyy8Odo3tHxVV9bcGh8dHTUSRhVolyA8wsRAmDACh7usyBgHH2X08P5wBEtw5m4wlvWuYTi/BXoIoFdcheBlQY4dPnxg4IPR9OPuQRymSGty7olgsDSCHuklc2cwjinNqEh47Bq94ncL9eyiX2roxGWJ3Ekd1ZUH1GpQWrRjCgW/rCGQ+ojGXVT0Dd0OV+X2KWcCVdbMDQWWm/AQAK1vPrCYrsLwGp7W6A8kXcXFkhggL7TCQpSaIBuh0Qv40mLk9pkNXELEJX8AUnzYzQ9ZkmPgOnczM/lIz93oeFl0t3/Qw42u9NfP8S8Ge0IXzs6W8jVOIKtAWLc4trJjz+4uYpVGHJQouJg3+SJ2ktkTLHi4VK/TgrT4ZU31DvgrTLPe7kEmuxrgHgS55LwY4sH5mRYrUVfvYZ31fJIyJ7vOcis9Qq/0Y0hGiBjTVByOvF4bjeUEOI16xKNi5f/Z5U+75Jl+TkP+NPQlSrkmciJA45r8V0n1MChPog8+leTUiY1VwFqMkrsJEcLCGiDDJUwgnrGCJnTd/VBYBhHRkjoWJCVSQAQkBq1YF0+fYHILiz8AUB8wQUVw/Pgp7BZurU1nS7zX1/KHhO0R0xtxYo5tHdZ+Ah5A+0Ux1TaefxKzyRObCKUeCJmIDqYJEzANA5xwOUJP4AQ9pn3TP6I/UUOBbk8C89BIjhFgM5abhSaKHCHEcyIpSmm6Y=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(376002)(396003)(136003)(346002)(230922051799003)(64100799003)(1800799012)(82310400011)(186009)(451199024)(36840700001)(40470700004)(46966006)(36860700001)(336012)(47076005)(83380400001)(1076003)(2616005)(426003)(26005)(40460700003)(86362001)(7696005)(40480700001)(478600001)(107886003)(70586007)(8676002)(4326008)(6636002)(8936002)(54906003)(316002)(110136005)(70206006)(7636003)(356005)(6666004)(82740400003)(36756003)(41300700001)(2906002)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2024 12:49:05.9193
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a008f157-b5b4-43f2-7c61-08dc2648d6b1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0DF.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9240

Add support for tracker object change event by referring to its
MLX5_EVENT_TYPE_OBJECT_CHANGE event when occurs.

This lets the driver recognize whether the firmware moved the tracker
object to an error state.

In that case, the driver will skip/block any usage of that object
including an early exit in case the object was previously marked with an
error.

This functionality also covers the case when no CQE is delivered as of
the error state.

The driver was adapted to the device specification to handle the above.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c | 48 +++++++++++++++++++++++++++++++++++++
 drivers/vfio/pci/mlx5/cmd.h |  1 +
 2 files changed, 49 insertions(+)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index efd1d252cdc9..8a39ff19da28 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -149,6 +149,12 @@ int mlx5vf_cmd_query_vhca_migration_state(struct mlx5vf_pci_core_device *mvdev,
 	return 0;
 }
 
+static void set_tracker_change_event(struct mlx5vf_pci_core_device *mvdev)
+{
+	mvdev->tracker.object_changed = true;
+	complete(&mvdev->tracker_comp);
+}
+
 static void set_tracker_error(struct mlx5vf_pci_core_device *mvdev)
 {
 	/* Mark the tracker under an error and wake it up if it's running */
@@ -900,6 +906,29 @@ static int mlx5vf_cmd_modify_tracker(struct mlx5_core_dev *mdev,
 	return mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
 }
 
+static int mlx5vf_cmd_query_tracker(struct mlx5_core_dev *mdev,
+				    struct mlx5_vhca_page_tracker *tracker)
+{
+	u32 out[MLX5_ST_SZ_DW(query_page_track_obj_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(general_obj_in_cmd_hdr)] = {};
+	void *obj_context;
+	void *cmd_hdr;
+	int err;
+
+	cmd_hdr = MLX5_ADDR_OF(modify_page_track_obj_in, in, general_obj_in_cmd_hdr);
+	MLX5_SET(general_obj_in_cmd_hdr, cmd_hdr, opcode, MLX5_CMD_OP_QUERY_GENERAL_OBJECT);
+	MLX5_SET(general_obj_in_cmd_hdr, cmd_hdr, obj_type, MLX5_OBJ_TYPE_PAGE_TRACK);
+	MLX5_SET(general_obj_in_cmd_hdr, cmd_hdr, obj_id, tracker->id);
+
+	err = mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
+	if (err)
+		return err;
+
+	obj_context = MLX5_ADDR_OF(query_page_track_obj_out, out, obj_context);
+	tracker->status = MLX5_GET(page_track, obj_context, state);
+	return 0;
+}
+
 static int alloc_cq_frag_buf(struct mlx5_core_dev *mdev,
 			     struct mlx5_vhca_cq_buf *buf, int nent,
 			     int cqe_size)
@@ -957,9 +986,11 @@ static int mlx5vf_event_notifier(struct notifier_block *nb, unsigned long type,
 		mlx5_nb_cof(nb, struct mlx5_vhca_page_tracker, nb);
 	struct mlx5vf_pci_core_device *mvdev = container_of(
 		tracker, struct mlx5vf_pci_core_device, tracker);
+	struct mlx5_eqe_obj_change *object;
 	struct mlx5_eqe *eqe = data;
 	u8 event_type = (u8)type;
 	u8 queue_type;
+	u32 obj_id;
 	int qp_num;
 
 	switch (event_type) {
@@ -975,6 +1006,12 @@ static int mlx5vf_event_notifier(struct notifier_block *nb, unsigned long type,
 			break;
 		set_tracker_error(mvdev);
 		break;
+	case MLX5_EVENT_TYPE_OBJECT_CHANGE:
+		object = &eqe->data.obj_change;
+		obj_id = be32_to_cpu(object->obj_id);
+		if (obj_id == tracker->id)
+			set_tracker_change_event(mvdev);
+		break;
 	default:
 		break;
 	}
@@ -1634,6 +1671,11 @@ int mlx5vf_tracker_read_and_clear(struct vfio_device *vdev, unsigned long iova,
 		goto end;
 	}
 
+	if (tracker->is_err) {
+		err = -EIO;
+		goto end;
+	}
+
 	mdev = mvdev->mdev;
 	err = mlx5vf_cmd_modify_tracker(mdev, tracker->id, iova, length,
 					MLX5_PAGE_TRACK_STATE_REPORTING);
@@ -1652,6 +1694,12 @@ int mlx5vf_tracker_read_and_clear(struct vfio_device *vdev, unsigned long iova,
 						      dirty, &tracker->status);
 			if (poll_err == CQ_EMPTY) {
 				wait_for_completion(&mvdev->tracker_comp);
+				if (tracker->object_changed) {
+					tracker->object_changed = false;
+					err = mlx5vf_cmd_query_tracker(mdev, tracker);
+					if (err)
+						goto end;
+				}
 				continue;
 			}
 		}
diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
index f2c7227fa683..0d6a2db3d801 100644
--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -162,6 +162,7 @@ struct mlx5_vhca_page_tracker {
 	u32 id;
 	u32 pdn;
 	u8 is_err:1;
+	u8 object_changed:1;
 	struct mlx5_uars_page *uar;
 	struct mlx5_vhca_cq cq;
 	struct mlx5_vhca_qp *host_qp;
-- 
2.18.1


