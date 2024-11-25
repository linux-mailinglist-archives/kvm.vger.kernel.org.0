Return-Path: <kvm+bounces-32417-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 018469D848B
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 12:34:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B5E38284844
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 11:34:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28BC01A01BE;
	Mon, 25 Nov 2024 11:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ACVSgU+c"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2068.outbound.protection.outlook.com [40.107.94.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 589AC1A01C3
	for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 11:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732534442; cv=fail; b=SVIDG8cGkrYfjB30rvyQe0vN/qOFZo1/8a2R5de+WkXnSRerdMbVIsOfWnKSyJqsG3Of1DyZoKA6Dvd1MSgWVCWEkhXIedyPjBr4A8s3nvqsmuNMe5qmoat6G+FvWdjdhgzvGkfjuCbmCOvZw0NXUA21ai5iezmNpT4Bh/AG8Pc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732534442; c=relaxed/simple;
	bh=giZLPJqc6enD7HRuHVsOLnDE8Y2/iv7ugiq40nx9l1s=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=DmvMhkTxTr+bali3YZ2r1gR0OFIdIYtgwZsHTOL2iW/w9eohJ07KvlNxQXkFkWH3cDoxYE7+LBZUKJcN1OcVllrf6v4CagJvrVMFLN+zJWcvqSRBwz2V6pt+IKF1k5yrEpBJLeX5o8IEkW9eZLi4NnP6KpgrZ0kvxq1pIg6H6EY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ACVSgU+c; arc=fail smtp.client-ip=40.107.94.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e4QwM0chkemVQjpmo4yf1uGxtPAS4osQ+Zr2f8AP9UTJPOSt53EGeFCAIZxh0LJRqe5fmFmlaJInaZfX7IgsOGNkVSs35z5nLi90KhWUG8damezvY59l7wE4+oCxC1p8Jk6lY2igyI5uT7Kp1ddoMiX+XqUR6Me4q1X8qv0dQplungXwGYNE/bQ8yo2RlWWCvZ/+KR6s/EFORFXDqu8RfJO3Nnlo5D8cjHYNTNZ+sWaqKj2q+0BkI1EHY/Uf2TbN0xNX4WSpwAw2aW4wtXWU1CsvDDmjMfr8TeqZDANADQhHc4U/FuxZaXTcOdeuy0/vUqTSYQA5+sP1uapaYwh39g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vS7kuI5jtuQcAoJOC+Rc0SjzEgLqpZd54Sjfvs2LTrQ=;
 b=GhMfZT9bzRNn15pADHAyEfdkAC1mbyV7T4j71GmoaVN3DAfJnzUb+uDjkG+MHQGySW+ufZ2iorXl2UBwtcxyRDfIKM7x5Lpqo/KW4B7muNgfvR7OhYUQHVRlhY2aCzgABSTLnnCbDUcLt+LrmDOHAPic0vn4ADDA3a92VDNBV9bRlLnbT+WqM/05gBRPQc+2g0Z9do5ZZVACova+b0s/d9H6SNBifwduD9V4yNS4snhlY8d5+RROH6FQ/kQv2u6GPz/nO8aZREe+T0M1/rc+kMWRAMfdRqjDkbYzmQ9kBpoo928tVwqAwOlOZKwWU/6UuBbn0/yqeTgIW/sIBahgdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vS7kuI5jtuQcAoJOC+Rc0SjzEgLqpZd54Sjfvs2LTrQ=;
 b=ACVSgU+cYT8K4+YX/muefkUsFufxPuWnMjySe3TJVnKFU/hXltzp6e3iYOiTBEv18L80ipl+GzUhuMxe15CiIw4Hc5zyep0i9bGO4pr1VnG7zukKVUIHZRnzvWNcO9VqpLWQE9qD1QU102TVYB8loexzK+6iu6pbqzpoeec0HSyZg7PqRkJXjT5Skem6NJyYmis/UaqmAz2YDvkVOfVutliQSNHW9bfL29+y2+ilo1x9Bvpv8ngpSvolhsE2IZZoSWCpUluF5md+AlbeQ0NVfmTVV7e/6KeAhgDNX7d7xazk8Yo/ULdSMM0XO2hmZD6PfXHQWoQQEWT5zB5AJJCcyA==
Received: from SN6PR04CA0098.namprd04.prod.outlook.com (2603:10b6:805:f2::39)
 by DS0PR12MB9275.namprd12.prod.outlook.com (2603:10b6:8:1be::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.18; Mon, 25 Nov
 2024 11:33:55 +0000
Received: from SA2PEPF00001505.namprd04.prod.outlook.com
 (2603:10b6:805:f2:cafe::c4) by SN6PR04CA0098.outlook.office365.com
 (2603:10b6:805:f2::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.19 via Frontend
 Transport; Mon, 25 Nov 2024 11:33:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SA2PEPF00001505.mail.protection.outlook.com (10.167.242.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8182.16 via Frontend Transport; Mon, 25 Nov 2024 11:33:54 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 25 Nov
 2024 03:33:52 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Mon, 25 Nov 2024 03:33:51 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Mon, 25 Nov 2024 03:33:49 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
	<galshalom@nvidia.com>
Subject: [PATCH] vfio/mlx5: Align the page tracking max message size with the device capability
Date: Mon, 25 Nov 2024 13:32:49 +0200
Message-ID: <20241125113249.155127-1-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00001505:EE_|DS0PR12MB9275:EE_
X-MS-Office365-Filtering-Correlation-Id: b72048f4-6c9b-4d1b-1c66-08dd0d450b4a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IP3MRkV2CJ+xuucPTpLq0kHDLxXicHDWn5jgwnpslfq3fwQdlaGP9JtRVVNl?=
 =?us-ascii?Q?m/L2GR3jc6yjjTT/qitCXL9TCs8/QFT14bTrIa+ZSE3ckqUksgARPl8CQeay?=
 =?us-ascii?Q?hn4lSDnnDi0NRrOQvzqqnWEls7GQaAaEdRNxh5J7EomeSIojJ9ZeQTriQA4k?=
 =?us-ascii?Q?Er2S9WiapGPAWKxqJ8zMuSo/7qkSzztUzz5TRaLZp2eArJuYAFcJ98Bv9uwl?=
 =?us-ascii?Q?6oG0ncY5mskTgd6OExRF5/EMwR+1X5hXUOvytz7O4Dx0iekC5EhyCEWuCczd?=
 =?us-ascii?Q?1RvN96n04giKTGIiSntagMlVQNAk5yw3oszh3WNPmT9yjhHh/ycJf7OLKoSF?=
 =?us-ascii?Q?AVjPxfobYxdUKCz+BrHn5sjzJtbKunBviKm7CJVcQPbeS6e4hHRAxV9yscAY?=
 =?us-ascii?Q?u9f10zGpJCYnSqfwGtEZlma4bLYiRWLl2n5lfRUU9Dnws0wAkYgSDuvtcKDL?=
 =?us-ascii?Q?dd69zKWFcXWwiEFhCvsbqpb0328FQiXcV3sIFKRhqHQd21DsvQO+e+qoSh/t?=
 =?us-ascii?Q?rBPskMWK3vc5fBT5AA+ydfyBWj2arr+V9qs1tSLytsqlmfEwV9v/iyxI3eqy?=
 =?us-ascii?Q?CZfHcdnUR/o0h6qTsjj8ov776S9BneG19L4TYjnQpBxv78/mVApeIyakwipY?=
 =?us-ascii?Q?uRRjQ8BLXWRwvM3rowoHHKR8giD5YW1XCOkNxP930XWYMbi2DSGgUYoQkhmV?=
 =?us-ascii?Q?03VOfwPc6F5xXxa2kidCNTchXOi94u729HEx0mJBjT16i4R7HT6htBCHp8O1?=
 =?us-ascii?Q?ClTvFOcGlPzKYAP/LrMKjk89B/r+z+HC3ZdQIApsl9tWIJmrtRBd0bKfRlcg?=
 =?us-ascii?Q?jY5q17ghgFRe0bGmThleLuCV3ygOIPyVMvVbUoft7Hxnjxz/DZX39mu+1T0C?=
 =?us-ascii?Q?Q5bLUxbq8C8EwQvUh1fcQoaBM7Jua6hAzUiPLmdRu7DG7SWuoOZzwUnsmF92?=
 =?us-ascii?Q?CHaPT1wqIlY0heSAJLS/uoCFDa1PAzZ3jnR3NMVlHldSUp/kIS29Jt0GzteX?=
 =?us-ascii?Q?SToja3bSwfmYpXVK+pczjszn64HQhdNr4+K2Dh05yAR95ZxxZSGMOEFnqhi2?=
 =?us-ascii?Q?Ddr5EM4sbWPh5jBBZj7TLUMXzxErWTpYwEVFQEUViqyfCjv4xUyHKDxqtBjl?=
 =?us-ascii?Q?KbM8q4Ax2wA5JS/fOwDz1Wy2cCHdQtganZUPvLpkrtad0C/jRoDzuSQIKR8O?=
 =?us-ascii?Q?xkxqBTqahT+mWaIlfXqLShYjfP63y77VbBvKdjpfgfK5CvwMm8IzVc8LGvz9?=
 =?us-ascii?Q?SrIjMvDGixNpBXCtzWqrA9d0qgiHkmkiUh+ltZ+xabRPFgfD9y8n9+h+UeIV?=
 =?us-ascii?Q?vfS7RBYDOsM135c2B0GI7LnI0+heAdanahQIgVODeMasFDLCwEdIBoogQM/F?=
 =?us-ascii?Q?qTylw0kv8xXALlDOSJ312KLHGvylcXr79GOtOyg6A0bWohPSBfcRG7dPALcM?=
 =?us-ascii?Q?ucBlnU20gpNOVGYxxrasv3CBBTmxUX28?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2024 11:33:54.8383
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b72048f4-6c9b-4d1b-1c66-08dd0d450b4a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00001505.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9275

Align the page tracking maximum message size with the device's
capability instead of relying on PAGE_SIZE.

This adjustment resolves a mismatch on systems where PAGE_SIZE is 64K,
but the firmware only supports a maximum message size of 4K.

Now that we rely on the device's capability for max_message_size, we
must account for potential future increases in its value.

Key considerations include:
- Supporting message sizes that exceed a single system page (e.g., an 8K
  message on a 4K system).
- Ensuring the RQ size is adjusted to accommodate at least 4
  WQEs/messages, in line with the device specification.

The above has been addressed as part of the patch.

Fixes: 79c3cf279926 ("vfio/mlx5: Init QP based resources for dirty tracking")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c | 47 +++++++++++++++++++++++++++----------
 1 file changed, 35 insertions(+), 12 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index 7527e277c898..a61d303d9b6a 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -1517,7 +1517,8 @@ int mlx5vf_start_page_tracker(struct vfio_device *vdev,
 	struct mlx5_vhca_qp *host_qp;
 	struct mlx5_vhca_qp *fw_qp;
 	struct mlx5_core_dev *mdev;
-	u32 max_msg_size = PAGE_SIZE;
+	u32 log_max_msg_size;
+	u32 max_msg_size;
 	u64 rq_size = SZ_2M;
 	u32 max_recv_wr;
 	int err;
@@ -1534,6 +1535,12 @@ int mlx5vf_start_page_tracker(struct vfio_device *vdev,
 	}
 
 	mdev = mvdev->mdev;
+	log_max_msg_size = MLX5_CAP_ADV_VIRTUALIZATION(mdev, pg_track_log_max_msg_size);
+	max_msg_size = (1ULL << log_max_msg_size);
+	/* The RQ must hold at least 4 WQEs/messages for successful QP creation */
+	if (rq_size < 4 * max_msg_size)
+		rq_size = 4 * max_msg_size;
+
 	memset(tracker, 0, sizeof(*tracker));
 	tracker->uar = mlx5_get_uars_page(mdev);
 	if (IS_ERR(tracker->uar)) {
@@ -1623,25 +1630,41 @@ set_report_output(u32 size, int index, struct mlx5_vhca_qp *qp,
 {
 	u32 entry_size = MLX5_ST_SZ_BYTES(page_track_report_entry);
 	u32 nent = size / entry_size;
+	u32 nent_in_page;
+	u32 nent_to_set;
 	struct page *page;
+	void *page_start;
+	u32 page_offset;
+	u32 page_index;
+	u32 buf_offset;
 	u64 addr;
 	u64 *buf;
 	int i;
 
-	if (WARN_ON(index >= qp->recv_buf.npages ||
+	buf_offset = index * qp->max_msg_size;
+	if (WARN_ON(buf_offset + size >= qp->recv_buf.npages * PAGE_SIZE ||
 		    (nent > qp->max_msg_size / entry_size)))
 		return;
 
-	page = qp->recv_buf.page_list[index];
-	buf = kmap_local_page(page);
-	for (i = 0; i < nent; i++) {
-		addr = MLX5_GET(page_track_report_entry, buf + i,
-				dirty_address_low);
-		addr |= (u64)MLX5_GET(page_track_report_entry, buf + i,
-				      dirty_address_high) << 32;
-		iova_bitmap_set(dirty, addr, qp->tracked_page_size);
-	}
-	kunmap_local(buf);
+	do {
+		page_index = buf_offset / PAGE_SIZE;
+		page_offset = buf_offset % PAGE_SIZE;
+		nent_in_page = (PAGE_SIZE - page_offset) / entry_size;
+		page = qp->recv_buf.page_list[page_index];
+		page_start = kmap_local_page(page);
+		buf = page_start + page_offset;
+		nent_to_set = min(nent, nent_in_page);
+		for (i = 0; i < nent_to_set; i++) {
+			addr = MLX5_GET(page_track_report_entry, buf + i,
+					dirty_address_low);
+			addr |= (u64)MLX5_GET(page_track_report_entry, buf + i,
+					      dirty_address_high) << 32;
+			iova_bitmap_set(dirty, addr, qp->tracked_page_size);
+		}
+		kunmap_local(page_start);
+		buf_offset += (nent_to_set * entry_size);
+		nent -= nent_to_set;
+	} while (nent);
 }
 
 static void
-- 
2.18.1


