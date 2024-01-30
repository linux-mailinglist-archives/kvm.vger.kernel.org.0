Return-Path: <kvm+bounces-7485-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 71DE1842A5A
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 18:03:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 246A128BF7B
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 17:03:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E616512839E;
	Tue, 30 Jan 2024 17:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QarO7WYP"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2085.outbound.protection.outlook.com [40.107.244.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44B7012838F
	for <kvm@vger.kernel.org>; Tue, 30 Jan 2024 17:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706634206; cv=fail; b=cFc36pIp257xeOvaLR2uNU3JFDlb1R+yFEd5tRuTsy7e0tz283hH0iAaUrLs8Da0sMupBfiPmu3YUC0KCTylNEQIkZL8jmlfgVNViDoyI0cCv/aZa5NROao3gLOpaWwQXk/C0RJVky/d9L9wx5/HmKMhDsFkY7muqTOYXPg/CyY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706634206; c=relaxed/simple;
	bh=yMNwWfAW/xkU50N7hoNnye53o5Xxn8/F1GOKB8r5XiI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=daspAewAkoxKuMSRkv/jsR8TLZql1URXea8fhGhKRW0fOb62JvLjqu4TUwGvrcNtEObdX0K0UcuDMtbL3aKcBVh20D3sD7iOejcv8lACTBkWQB6CR3vZNvZvbm3Yp7ccql30ASoQlUY0ZARRpNEzY7j7BFbU2qlnAGqwwzAjAHs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QarO7WYP; arc=fail smtp.client-ip=40.107.244.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B4a1eciaen9vO0T5m3BW0su31vRNuOrxRzibdqJV4X2sL7LtF5tx/ndQVRQWBUo2+q6DFWyFjehcPRqjPBWEjI5gHynGZrDH9OgmzRriQ96ZaEAwoqjdZ2relt4pZPxDA/KD4iAP4MrKIsJlLxmwv01bWRddiifV4b9qvlsVhUuxaXosPiF7da4Ez5pPMklPFl5STkWjGkfQzTufy85vuWRE+q297RHXBQNehPZ3KHLUC1lPpi4qq8alH1rXOeMiu5K2A8LJG0FLd+BPjg5KpOAsv8PGQOC4xCkqTla4jiWLd11Mx/Y9V4iDEwRMH40PHm5IgCl6pOb0wCK2brklxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=POUp2n4MhdH2g+sSK8Guq4G0ih3QaEMbS9ERwNXrO7g=;
 b=DpRi18XzueCcPsyILbkW9IF5tOkSqUpIKrsB6ds6xo+bG45yy82kb8mPdCoqggB2vD7AIRhuhK7kjSsVj72hkv0zTEOXvokC+z7cV6vccOpXZr54jqcSLkMUMMgpwehroYf2lnccp5dyhPuBXx/Wke//pFT9++cd1HAHmpzJ7HqihudNkYk8GYoEeTAQme0EnBJXZjNwkmXDDHRmoE1P5FgfWDK0tiqS5iYfNJfCZBEQKqFiTLiEcRxEHwf12GVShT0QDS1RoRNsvuw4qcLQI5JOiNGxQsdOABDQdvmQJLxmHmO8hCew78wdhe7uePeuZu6KFDKL2xLlcwhc1I6AVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=POUp2n4MhdH2g+sSK8Guq4G0ih3QaEMbS9ERwNXrO7g=;
 b=QarO7WYPQbmy/KlaW3Spa5yXhHqc7MiL8KJ4DbEvaYrEfluGes/9wuQdzwQ2sarP6d/nCtcFjZc5ADDkv1eXnMkms1oAE2nUZIb3KxAePypOc/URRZKWbOjgf6w/2mu60MOqkCEZLS6QhaQBjbbmDuVZN7UISXWtlPjBpI/H1kOWPSdtCzdF7y+WmY0QHRQPJ7Tu7+ot5RT4N8Xlsz62d438aKxGqVGNG6Ari2k1V1TpcBJBnFeHqKSAr4VcQuLglyD9+4bde2h/qVL3z4gFgqpLhloDRCvJzxlo6u62rFSEmqNFcmFT6hVc9ZcCGJdTk2oKJXir3w1pCcMQjABiyQ==
Received: from DS7P222CA0016.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::8) by
 IA1PR12MB7709.namprd12.prod.outlook.com (2603:10b6:208:423::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.32; Tue, 30 Jan
 2024 17:03:21 +0000
Received: from DS3PEPF000099D4.namprd04.prod.outlook.com
 (2603:10b6:8:2e:cafe::8) by DS7P222CA0016.outlook.office365.com
 (2603:10b6:8:2e::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.34 via Frontend
 Transport; Tue, 30 Jan 2024 17:03:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DS3PEPF000099D4.mail.protection.outlook.com (10.167.17.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7249.19 via Frontend Transport; Tue, 30 Jan 2024 17:03:20 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 30 Jan
 2024 09:03:09 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.41; Tue, 30 Jan 2024 09:03:09 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.41 via Frontend
 Transport; Tue, 30 Jan 2024 09:03:07 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
	<maorg@nvidia.com>
Subject: [PATCH vfio 2/5] vfio/mlx5: Add support for tracker object events
Date: Tue, 30 Jan 2024 19:02:24 +0200
Message-ID: <20240130170227.153464-3-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20240130170227.153464-1-yishaih@nvidia.com>
References: <20240130170227.153464-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D4:EE_|IA1PR12MB7709:EE_
X-MS-Office365-Filtering-Correlation-Id: dbc4fb85-6f61-4c9c-28f9-08dc21b55cac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	OFXuTjOwsU+4sjEq9Xv+ilTTHwuVb4x/4RmmJpT74dvARI+HnDTuD9fVA7p3loq52rpMLoSEmAE35zCjZaqMpu3/GoxU7Ohd7kFekXsoqQWPKrVfBnTZgdM7I9OJ/86UB4GfMYA8xnRyeS5dMSNKYQTuGPR9NOiUwRYOMyWDBMmAtr1j+gJZoITk28YfmzOBeIv7j0AmSGgRV3qDA85MVVAi2Wn+d8ABita9F/lNeXvrjyiWLthqKkVGLLqC0UMCLDfq1kn1j4m+yOcVXhx28CUqwHaJ6k8Fd0jdByDMgTWvK3Vx1xW7wXS+IIJEV+9svOCxsvJ0k6stYozcXYgQNA4cqdc3d23oZo/uq+Wj1TR+TMU4WEAt8emAEpSmLEQa4fTx3rVOddw8+sK1uR+xjSye1i3oax/Hru+q+pe4iYwhOQoeOvNjkbtyZNTlZ9NvZlkjfFOIK+pHkTyvYkXYEcbzPn0sblOGoFXZKnJWflFASUAd/a/YZKRV/jUaM43YDc43umcSocKjELnpQznMw+7hAFiOYZRw6+UwioMcHJL0dAf7EQJWiW4iDOVGjQcnRnanQYIlBGDP630ZFNjbCWdhnTzI7r2HgKXX17EupirM4hWFysuncsr6vc0AWq1SBgiuF4E808yrL8hrE2VRazPLGV/kxyAm9QBwHfBywneWAUv89OoPtXwsexBWHd9iQ7qKPF51eT7RzN99pVVV5HBOZqoZcL8AZ+YDhbEC6XbPPvEUlJVerNOQkGQwlLUT
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(396003)(136003)(39860400002)(346002)(230922051799003)(451199024)(1800799012)(186009)(82310400011)(64100799003)(40470700004)(46966006)(36840700001)(83380400001)(426003)(1076003)(6666004)(7696005)(336012)(478600001)(36860700001)(8936002)(47076005)(316002)(107886003)(2616005)(41300700001)(5660300002)(4326008)(2906002)(8676002)(70586007)(6636002)(54906003)(110136005)(70206006)(82740400003)(26005)(36756003)(86362001)(356005)(7636003)(40480700001)(40460700003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2024 17:03:20.5945
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dbc4fb85-6f61-4c9c-28f9-08dc21b55cac
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D4.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7709

Add support for tracker object events by referring to its
MLX5_EVENT_TYPE_OBJECT_CHANGE event when occurs.

This lets the driver recognize whether the firmware moved the tracker
object to an error state.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c | 48 +++++++++++++++++++++++++++++++++++++
 drivers/vfio/pci/mlx5/cmd.h |  1 +
 2 files changed, 49 insertions(+)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index efd1d252cdc9..55ba02c70093 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -149,6 +149,12 @@ int mlx5vf_cmd_query_vhca_migration_state(struct mlx5vf_pci_core_device *mvdev,
 	return 0;
 }
 
+static void set_tracker_event(struct mlx5vf_pci_core_device *mvdev)
+{
+	mvdev->tracker.event_occur = true;
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
+			set_tracker_event(mvdev);
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
+				if (tracker->event_occur) {
+					tracker->event_occur = false;
+					err = mlx5vf_cmd_query_tracker(mdev, tracker);
+					if (err)
+						goto end;
+				}
 				continue;
 			}
 		}
diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
index f2c7227fa683..09d0ed6e2345 100644
--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -162,6 +162,7 @@ struct mlx5_vhca_page_tracker {
 	u32 id;
 	u32 pdn;
 	u8 is_err:1;
+	u8 event_occur:1;
 	struct mlx5_uars_page *uar;
 	struct mlx5_vhca_cq cq;
 	struct mlx5_vhca_qp *host_qp;
-- 
2.18.1


