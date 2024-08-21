Return-Path: <kvm+bounces-24714-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 350AA959ACD
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 13:54:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ADC1C1F22313
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 11:54:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DE641AD5F8;
	Wed, 21 Aug 2024 11:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kUJU3281"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2057.outbound.protection.outlook.com [40.107.236.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A20A11AD5E0;
	Wed, 21 Aug 2024 11:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724240512; cv=fail; b=JUu+TVEJKm2D+RRaoD+RdeKX1CN0ih1uOCBEfnvAD0fYkCTQC5u4JmpL9ziUflyTEjQU+cxvjWKjvDps1P4ZPNuxFdOOGYEqeweH8gl7o2p+4N0cD/BlUaq39Vvk4cu877qWey4pJRYpDLv0t3QgLs5F5tWI3AG7VQuWQWMBPQg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724240512; c=relaxed/simple;
	bh=vW10WZF5MYGMs0QCG6/61hYkcEo15kU1sq/jtACT8I8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lHt9HRF+ZnsdxssFCorIGtrZRzHMCfehrnQaURFb7iedjJf8yRxBW4CDmSktBhxYFW2MixSb/AOCjit8E8Ws13YSpG55qRPOW9oCXduWqyIaO9o81SWUKx9n5oDEkD+ObSJAWTEMXdy0GlF3YgUXNjN1ozgLnY61r72221fUHdI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kUJU3281; arc=fail smtp.client-ip=40.107.236.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WO1Jk9DwycZyBieLjzjcQJO6qZ4nvCF8/6tH/8L4zynpdjI7GDk9p2H+HMc2e8AMoxoYaNyQAk4wJXdrOvtX0zpdI2NDaCt3/mLrvf9lSmp4KmQVDfnzFoKSqqyOddX0qzGqj9kP4dXOGpdEkuIFY2TaeUr1pqRhzed4HOQVD5mCKtRB+0/R2u8jYP+zQf+V0lw1Rgv4wpkbGJ8hNYbwmAHstGCw8j7p7Ac5/jpDkYWxKlHChlgzUO8bb4oSXHFnke5eBvZz6E8HSUGUwvoNsNmtNUJX8EwxQjA+O+TPH3YQj+of2poLRIydn3naMmh6UHagIQhlOSVHNZanNhm3Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NUmxljcY0nXbocmKXhfYEAF1cC/flvePS47w5mj4bkU=;
 b=mIid6YJMPyg2xfQ6/vbQ8Bq5wr9MswfCrxEXPSlVAZKboDvcOwI14ymVE/sTTiR5T5elPmi8bh2EExdTsmE2+r0Ymikcg7G/gpxBFTCA6L9teAibZwi87yLtsr2AyQDk3L5/w55fyVeRQlw2ZVNfM+Hf/4K7iz+Av2w4YWw64dw6R0F3Fg7UQXNHO+gGvV4LGnnWS8FBrrp0Ho3iC6YUPafB67TrjBNNuZqv7yhEZ1ohRO4wD31oAeQiewTla+SgEHkrG9M4CLMWIaOckUnRtfKgcen58GETTWcKhy/mEv4X8yqWAdEUU9i6ibHGJB+owWhwfl8FFFW4jgZ2e0H8Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NUmxljcY0nXbocmKXhfYEAF1cC/flvePS47w5mj4bkU=;
 b=kUJU3281c2SXBtTBVqzJ9abEPMKCOOFi7Rdmb5hcAFf1iO5EMz/RlhWvH8yaYfxh5pT0EFz76nvw7mUAB5JsvlGhVqL3HIEgnK3j1Rjg60gtLtL61AHynaX5VEIFZtK14Zpan0vRPHa0tMIiTl7MZiDXtsxZww6Xg68QPhqZAJGrhjAHwuSGC/17eeJOMbqJzCNzahGNm97UX/qFmNfF1FFzrigzmUjA64B5KYxFf6pqttArh1beDyAPFVTfGnskjQzbVlYaqxIvM/Onv7W/85ZbvOZ52InihCocKYKGSA5QrfmrpksS86PdmNStPd5xHzfM3ffcic/jXXW2/tdIiQ==
Received: from BN0PR04CA0154.namprd04.prod.outlook.com (2603:10b6:408:eb::9)
 by MW5PR12MB5597.namprd12.prod.outlook.com (2603:10b6:303:192::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21; Wed, 21 Aug
 2024 11:41:45 +0000
Received: from BN3PEPF0000B372.namprd21.prod.outlook.com
 (2603:10b6:408:eb:cafe::79) by BN0PR04CA0154.outlook.office365.com
 (2603:10b6:408:eb::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21 via Frontend
 Transport; Wed, 21 Aug 2024 11:41:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN3PEPF0000B372.mail.protection.outlook.com (10.167.243.169) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7897.4 via Frontend Transport; Wed, 21 Aug 2024 11:41:45 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 21 Aug
 2024 04:41:31 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 21 Aug
 2024 04:41:31 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.8) with Microsoft SMTP Server id 15.2.1544.4 via
 Frontend Transport; Wed, 21 Aug 2024 04:41:28 -0700
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, <virtualization@lists.linux-foundation.org>, "Gal
 Pressman" <gal@nvidia.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>, Cosmin Ratiu <cratiu@nvidia.com>
Subject: [PATCH vhost 1/7] vdpa/mlx5: Create direct MKEYs in parallel
Date: Wed, 21 Aug 2024 14:40:55 +0300
Message-ID: <20240821114100.2261167-3-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240821114100.2261167-2-dtatulea@nvidia.com>
References: <20240821114100.2261167-2-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B372:EE_|MW5PR12MB5597:EE_
X-MS-Office365-Filtering-Correlation-Id: a8047278-16c4-4aff-6b62-08dcc1d63c34
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jogTeoIDMRUvOayuGyqRY3KD48oF6C07EKpWnaO+0hMe0U4T9Fl10E19it3y?=
 =?us-ascii?Q?13lIjEl1nBZAAYoQxiFUQKoGH3RTVbNX96k1TbeEmQntv1HSjuDQKKCXt+77?=
 =?us-ascii?Q?CcPAAPaTpI5ZOv+kyoBd6vHphfqrGYSDUWszAS2G8LEFxkBUtuv9G5MHZgCa?=
 =?us-ascii?Q?F1ZpHQU7T6yTW4BTCzXLVr7AyKs4NuIES3EhjGhP9mhZnmi0C1ZLT3H/7x8J?=
 =?us-ascii?Q?T2B+pYofwFzx2+wG7NXJh7UoEaeNmqBLcEK0+6Nkzwt/V5j6S6ibzAy6S5Z9?=
 =?us-ascii?Q?O0vG5utTPN+kxRqAyH/AgF6ppNnBNi14e/EFQSkt4qS/HBIUeEp4Sh+Ge+w5?=
 =?us-ascii?Q?Qu6/PAr4W5RK6CihZ45XjJ3Xp75pREXqsoJMVeGI10xQEH+BZRppkIALWb9s?=
 =?us-ascii?Q?xIGpi8A36dKFKGPnzcBQH4jrGK92joAYypr9c8YSN8kF7RrQtE7HXhKGE7JG?=
 =?us-ascii?Q?uPY1Jk/IZ5DlfopexBWhW3BKa9tXg1rqs5RdOG3dcdj9QqJ5z5Pqjzfvqo7Z?=
 =?us-ascii?Q?gWy7x7z3Uu2eqHQfbSvFr5HX9GtI6fQL09J/jIyzPjvfMk0yRGjB1A2J4QcF?=
 =?us-ascii?Q?DhmjHw9ms852D0nox+1+L/wrTDlCQI3/X6C4uRIAcW1gs57gWhy1ciWBM9Vs?=
 =?us-ascii?Q?buxDAXIFKljJFH8D+3jBCj1MB0n5Q8Ohqeb0nkX9QO+Vvc8jmfSsFovwgRFn?=
 =?us-ascii?Q?ynu7Gpq76dALg6OivUVleqE8DkAhmp5crylVYQKQpZRftT7yIJ9nMTpee05Z?=
 =?us-ascii?Q?ThidZBV1lQe6VEH2byyrBNsFIAVbeIfZTxxfoMms9YpJbB8fklZkR6mEFIKD?=
 =?us-ascii?Q?HxUsO1gJ1Cly8VmS1IciRzOq0z/TLp0eBwCytwbOorf8wea5IjxPXitz+Oub?=
 =?us-ascii?Q?8nowd8ToTTotzaJNa/x5a/6Cd+XuKvDporlEARlen1Tvm1KM2eBzq4445kwj?=
 =?us-ascii?Q?U7K3FuemV6wYnjuPbsw2ajkZFqs7ZdFSaO2cWXttMTV68zyNMBbFOcKMVA5x?=
 =?us-ascii?Q?didmkqpvCUJC2bYtHoWuMbTcBX0+wNhkzVRyEtNtw1f7xVIBwDMn/9RKZLjy?=
 =?us-ascii?Q?r3T49uxy39W1NQYMWsPLzxmqZFOJWgFp8Ujmey7/DSe6qmcIWJ+HEGk3c4ZC?=
 =?us-ascii?Q?43Fp/twMDKxsovU8y/bzdUfCGD/PExCitcW183SpsBy29kQ+JfVY3mG7wtwj?=
 =?us-ascii?Q?NnF3IdQ3MAI2N6cbsa9PudH+A4XHuwRN9Ry7v0vBt1zz+UNDgjY53b/+Rcjx?=
 =?us-ascii?Q?m9X+ynfOseIu3nZhUk5cB7/X3t5y+u6JhdlMGMSk49RSxoYtJWPv5Zkxn0xK?=
 =?us-ascii?Q?KpQupp7+98Grw/AzMrkDayVVsqWMvtd7DntIKTV786QESPKE9oj0AI+ZYCJ1?=
 =?us-ascii?Q?C9XONOjwWZrmVpds/ooU7Eg8iATfHAAFTfRP9RdxkN9vzFTa/HpF9aOP/icR?=
 =?us-ascii?Q?JF/IY1NjsHCUb3CpxIIBKGvsgUswuuhb?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2024 11:41:45.4967
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a8047278-16c4-4aff-6b62-08dcc1d63c34
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B372.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5597

Use the async interface to issue MTT MKEY creation.
Extra care is taken at the allocation of FW input commands
due to the MTT tables having variable sizes depending on
MR.

The indirect MKEY is still created synchronously at the
end as the direct MKEYs need to be filled in.

This makes create_user_mr() 3-5x faster, depending on
the size of the MR.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
---
 drivers/vdpa/mlx5/core/mr.c | 118 +++++++++++++++++++++++++++++-------
 1 file changed, 96 insertions(+), 22 deletions(-)

diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
index 4758914ccf86..66e6a15f823f 100644
--- a/drivers/vdpa/mlx5/core/mr.c
+++ b/drivers/vdpa/mlx5/core/mr.c
@@ -49,17 +49,18 @@ static void populate_mtts(struct mlx5_vdpa_direct_mr *mr, __be64 *mtt)
 	}
 }
 
-static int create_direct_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_direct_mr *mr)
+struct mlx5_create_mkey_mem {
+	u8 out[MLX5_ST_SZ_BYTES(create_mkey_out)];
+	u8 in[MLX5_ST_SZ_BYTES(create_mkey_in)];
+	DECLARE_FLEX_ARRAY(__be64, mtt);
+};
+
+static void fill_create_direct_mr(struct mlx5_vdpa_dev *mvdev,
+				  struct mlx5_vdpa_direct_mr *mr,
+				  struct mlx5_create_mkey_mem *mem)
 {
-	int inlen;
+	void *in = &mem->in;
 	void *mkc;
-	void *in;
-	int err;
-
-	inlen = MLX5_ST_SZ_BYTES(create_mkey_in) + roundup(MLX5_ST_SZ_BYTES(mtt) * mr->nsg, 16);
-	in = kvzalloc(inlen, GFP_KERNEL);
-	if (!in)
-		return -ENOMEM;
 
 	MLX5_SET(create_mkey_in, in, uid, mvdev->res.uid);
 	mkc = MLX5_ADDR_OF(create_mkey_in, in, memory_key_mkey_entry);
@@ -76,18 +77,25 @@ static int create_direct_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_direct
 	MLX5_SET(create_mkey_in, in, translations_octword_actual_size,
 		 get_octo_len(mr->end - mr->start, mr->log_size));
 	populate_mtts(mr, MLX5_ADDR_OF(create_mkey_in, in, klm_pas_mtt));
-	err = mlx5_vdpa_create_mkey(mvdev, &mr->mr, in, inlen);
-	kvfree(in);
-	if (err) {
-		mlx5_vdpa_warn(mvdev, "Failed to create direct MR\n");
-		return err;
-	}
 
-	return 0;
+	MLX5_SET(create_mkey_in, in, opcode, MLX5_CMD_OP_CREATE_MKEY);
+	MLX5_SET(create_mkey_in, in, uid, mvdev->res.uid);
+}
+
+static void create_direct_mr_end(struct mlx5_vdpa_dev *mvdev,
+				 struct mlx5_vdpa_direct_mr *mr,
+				 struct mlx5_create_mkey_mem *mem)
+{
+	u32 mkey_index = MLX5_GET(create_mkey_out, mem->out, mkey_index);
+
+	mr->mr = mlx5_idx_to_mkey(mkey_index);
 }
 
 static void destroy_direct_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_direct_mr *mr)
 {
+	if (!mr->mr)
+		return;
+
 	mlx5_vdpa_destroy_mkey(mvdev, mr->mr);
 }
 
@@ -179,6 +187,74 @@ static int klm_byte_size(int nklms)
 	return 16 * ALIGN(nklms, 4);
 }
 
+static int create_direct_keys(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_mr *mr)
+{
+	struct mlx5_vdpa_async_cmd *cmds = NULL;
+	struct mlx5_vdpa_direct_mr *dmr;
+	int err = 0;
+	int i = 0;
+
+	cmds = kvcalloc(mr->num_directs, sizeof(*cmds), GFP_KERNEL);
+	if (!cmds)
+		return -ENOMEM;
+
+	list_for_each_entry(dmr, &mr->head, list) {
+		struct mlx5_create_mkey_mem *cmd_mem;
+		int mttlen, mttcount;
+
+		mttlen = roundup(MLX5_ST_SZ_BYTES(mtt) * dmr->nsg, 16);
+		mttcount = mttlen / sizeof(cmd_mem->mtt[0]);
+		cmd_mem = kvcalloc(1, struct_size(cmd_mem, mtt, mttcount), GFP_KERNEL);
+		if (!cmd_mem) {
+			err = -ENOMEM;
+			goto done;
+		}
+
+		cmds[i].out = cmd_mem->out;
+		cmds[i].outlen = sizeof(cmd_mem->out);
+		cmds[i].in = cmd_mem->in;
+		cmds[i].inlen = struct_size(cmd_mem, mtt, mttcount);
+
+		fill_create_direct_mr(mvdev, dmr, cmd_mem);
+
+		i++;
+	}
+
+	err = mlx5_vdpa_exec_async_cmds(mvdev, cmds, mr->num_directs);
+	if (err) {
+
+		mlx5_vdpa_err(mvdev, "error issuing MTT mkey creation for direct mrs: %d\n", err);
+		goto done;
+	}
+
+	i = 0;
+	list_for_each_entry(dmr, &mr->head, list) {
+		struct mlx5_vdpa_async_cmd *cmd = &cmds[i++];
+		struct mlx5_create_mkey_mem *cmd_mem;
+
+		cmd_mem = container_of(cmd->out, struct mlx5_create_mkey_mem, out);
+
+		if (!cmd->err) {
+			create_direct_mr_end(mvdev, dmr, cmd_mem);
+		} else {
+			err = err ? err : cmd->err;
+			mlx5_vdpa_err(mvdev, "error creating MTT mkey [0x%llx, 0x%llx]: %d\n",
+				dmr->start, dmr->end, cmd->err);
+		}
+	}
+
+done:
+	for (i = i-1; i >= 0; i--) {
+		struct mlx5_create_mkey_mem *cmd_mem;
+
+		cmd_mem = container_of(cmds[i].out, struct mlx5_create_mkey_mem, out);
+		kvfree(cmd_mem);
+	}
+
+	kvfree(cmds);
+	return err;
+}
+
 static int create_indirect_key(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_mr *mr)
 {
 	int inlen;
@@ -279,14 +355,8 @@ static int map_direct_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_direct_mr
 		goto err_map;
 	}
 
-	err = create_direct_mr(mvdev, mr);
-	if (err)
-		goto err_direct;
-
 	return 0;
 
-err_direct:
-	dma_unmap_sg_attrs(dma, mr->sg_head.sgl, mr->nsg, DMA_BIDIRECTIONAL, 0);
 err_map:
 	sg_free_table(&mr->sg_head);
 	return err;
@@ -401,6 +471,10 @@ static int create_user_mr(struct mlx5_vdpa_dev *mvdev,
 	if (err)
 		goto err_chain;
 
+	err = create_direct_keys(mvdev, mr);
+	if (err)
+		goto err_chain;
+
 	/* Create the memory key that defines the guests's address space. This
 	 * memory key refers to the direct keys that contain the MTT
 	 * translations
-- 
2.45.1


