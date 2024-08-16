Return-Path: <kvm+bounces-24371-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0708E954521
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 11:06:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2B9941C234A8
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 09:06:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDE17154C08;
	Fri, 16 Aug 2024 09:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dDBqIn6K"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2068.outbound.protection.outlook.com [40.107.236.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86D5A1547D8;
	Fri, 16 Aug 2024 09:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723798994; cv=fail; b=TWTYbNVwwhm/fsFlh6zD+OzXS7calcSaFcofpnNXaNtTXka9W2AxNim49lqAOPjB5WsgszvWzB+xTnY6vBIHT+ExGidR2C1MSlGQofwhtHOn35R31hR5/tF17yaxYDRMJ5EbFyiflGiNTXauCQqkp/+bZdRiGfsLcutoHhMwsy0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723798994; c=relaxed/simple;
	bh=8iNr6oETCoFicQJnO591lyH/KynVecehV6m4rBREg9s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BhZ9RDyKQySn/0zK2omkcmSD3sSoxnbtJXVCOx7xirbz413padzcsG7JhkV7Is1CB2rEV8Av4/rXdx87gajL+yB+cOFeSLgMsg9Y2hUEzy6SYD0Peq/kBs/bqPJ/jECYE5WL1fNS5fzr6dI9eh2wMK1fNgftWyqHxSWcSRWg+/0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=dDBqIn6K; arc=fail smtp.client-ip=40.107.236.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WHGxoH6pzI4wC8SGbZa3nyV5urILfO0rW3/YOpFdjMlP7g247Nrnb1IZ26dSbUKaYQNlZut6guIURHsE9L9yxGDfALm1lUBpuCfNdqImSrqk6XjaR19LorH6XHjcGV2xYpZVYwcjr+Bb0480eMQzjA9CT+i8BsUoJNQNXg+xa2yuYHAIO4/sR1DnQBJ0mvrflckwLyEm/P5qYKXLh5GDPfjdWgTK+FAsys1qVAWVqAmnlShk2P8B+ZA1IySC7srNzyTL7GjytgjCguY+jilWk03Cgj/yvCIfG76mihzYDgaHzP1oJsaJ0rVMPBTiRBdUW8Zg2Bc4bPuMlJ8h2m+O4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jLQqQe/ew4Mtp/vETYeLoEGOjYQPOrzAWqP+IY3P30Y=;
 b=mYZhAdrKmhbxNnAF64ooME5jpnQCzLho7XN4ntpYSGgaTDzAcKFRrL1/OsfCjVCnJRhh3OUctqWAohU14Fgzj6jLwZmYYQEmK7Y/GqALzCD/ueCErYv+484np9GTS90L4oKyVOTGwjrYocgIwJjMwu8OXj84CgNPjEGQ9GBQf42N+S+ZvafHK9lcpEGXmAulUAHJMkuiJvQI8T7RGn/LvHWcNhoAGA1bs48rhD/aaVHEQ6CbwtI7IxfzI29ixUEdRH9bzQZB9trMvlbJXje48rkxJseZn0WbtNolarPajJH2cAdLbvg0x1rQWlsNQRAfBcW/wdM4VfNNLg4/CHXymQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jLQqQe/ew4Mtp/vETYeLoEGOjYQPOrzAWqP+IY3P30Y=;
 b=dDBqIn6KqQlzAm5j4KN5R+HhU/XiRtikDseFxAYyr8JzXOwyW87zMwyaJEUDZo0XTn3ZnhReIioUAJFm/2Dg38F5wS8S1/gkjBZb2I1nUEOfp4j1yfL2WhWnyvfNJmenFib/WQ3K5F46g1x8Yk3CDLNbeE6FOZnR2gDCJm8zvOJWUvdqh8PM/DCV6y5ZZ/kWPMQO4lDsV3mS+6GXfuDkaJEmioMsJdMw0FS3EB7hcaCpJjqcDIMQOG0DOsdDWT5ABFcYFgJmGW1cghwLhmLL8xDIEDAKEknAhsRNMp43ztGuxhXWJLXavUE3vWY9CuzzwvQ6x+DbUYjPyHwnVBO8Rw==
Received: from CH2PR14CA0048.namprd14.prod.outlook.com (2603:10b6:610:56::28)
 by DS0PR12MB8295.namprd12.prod.outlook.com (2603:10b6:8:f6::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.19; Fri, 16 Aug
 2024 09:03:08 +0000
Received: from CH3PEPF00000012.namprd21.prod.outlook.com
 (2603:10b6:610:56:cafe::9) by CH2PR14CA0048.outlook.office365.com
 (2603:10b6:610:56::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.23 via Frontend
 Transport; Fri, 16 Aug 2024 09:03:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH3PEPF00000012.mail.protection.outlook.com (10.167.244.117) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7897.4 via Frontend Transport; Fri, 16 Aug 2024 09:03:06 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 16 Aug
 2024 02:02:54 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 16 Aug
 2024 02:02:53 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.8) with Microsoft SMTP Server id 15.2.1544.4 via
 Frontend Transport; Fri, 16 Aug 2024 02:02:50 -0700
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>,
	<virtualization@lists.linux-foundation.org>
CC: Dragos Tatulea <dtatulea@nvidia.com>, Si-Wei Liu <si-wei.liu@oracle.com>,
	Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Gal Pressman
	<gal@nvidia.com>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH vhost v2 10/10] vdpa/mlx5: Parallelize VQ suspend/resume for CVQ MQ command
Date: Fri, 16 Aug 2024 12:01:59 +0300
Message-ID: <20240816090159.1967650-11-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240816090159.1967650-1-dtatulea@nvidia.com>
References: <20240816090159.1967650-1-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF00000012:EE_|DS0PR12MB8295:EE_
X-MS-Office365-Filtering-Correlation-Id: a348103c-3942-4fd2-031c-08dcbdd23e3c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XqVRv7zUllih83v5uLhCfvPYa5epcKaFAb1Bv19ELOWZhfMIqiGh9+ZMTfEZ?=
 =?us-ascii?Q?wcpKFTlPaiXkbCHNnzywyxsy0GsDuzUDzu3gPDYYu75bZJC/Ah0SkJQ1+jOw?=
 =?us-ascii?Q?vRd18g4rdALZvPTG7ZLLfQ4NYG0de7nrshXWv387piA0Hq4pGKS/ihGpE9wC?=
 =?us-ascii?Q?8ZDoteqMSotMuClVkJRvo4nHzg6e9U3mSccTdE8P/Ultf/WATEZCWDUFQe+M?=
 =?us-ascii?Q?wZ0BuzRlOiODShbCRuD2bsbz61c4TaWYvUDLRAYYha1He3AwnazZ/lY+K4Ug?=
 =?us-ascii?Q?4oB3DYHxuQJG2IcyLugJMEv/xsVuvpm174QK13o9zHepNFA41D730Ho3zUDy?=
 =?us-ascii?Q?y4bFDL9oK67KBvMmljpYfjQnyxr8Jjhtdy/mcy3qA28eIVvDrcVCt9BBInLz?=
 =?us-ascii?Q?2t7GewalmNlzikiexpEx1eY0i/a1InwbXov2iMh3IGBkhj90agWu0R89bffz?=
 =?us-ascii?Q?/XHvffdIWnnDaWSZra0f6gijMsbP8olC3ZRh1NghqArpwGaGlwP54E5Ca2HT?=
 =?us-ascii?Q?FDsV3WQFFQsesHSNAWhh40OEOn+0VqLkgt25JEmfvKaM7IJk1oh6HU+5Biw4?=
 =?us-ascii?Q?0zm0NemKqBwS13qbeh8GFM2b68sIIA8CqSrPDy1f9n8c4iGg6l9AcSfn66nV?=
 =?us-ascii?Q?KsfQQCAIXTkIklceAPQNBMcoPS3P4VcUD8YP0TgknqKrsaUgBIg/xEjd/MWx?=
 =?us-ascii?Q?3afddit3Sg2w3qIYstuf0RApjRIk583/gdYubCT+559ZRbD4Wvh/onWr3WRo?=
 =?us-ascii?Q?POzU8KUUkIQM5N/Bbkay5l4VzAuwZvuKn1g2pvlum/Vhe8g+JzXDzxnUmSmz?=
 =?us-ascii?Q?DOWJFJCp0V1+UgobNkyxR2ZyimqQnz2OBP4oLfzvJG+wl/fu+yMggrFudVFE?=
 =?us-ascii?Q?KR13NPZxEac++TuGYd028GlWoGDoXqjLQjFOMN+VJuZRoR0MQpM1gFVNM8l+?=
 =?us-ascii?Q?65Qwz4VfCukZVDPYb8oSjbpEoflQOJSrE3VgpMGOxahqcAiPks+N1bmmxjgk?=
 =?us-ascii?Q?UyKvvWdK2QguDELRjn2eTGXycmSgvc3KdwcgE+J5er5VszrfaOW+97es5Pc9?=
 =?us-ascii?Q?5mJMQYqPElyD7IIsL70+uZwr7t4M0qi8juIiaV22g6g96Qo7w7/CMSmPFE8C?=
 =?us-ascii?Q?2jkmLNnEZ8cnqpELZ6bFT56jFZPUHDkhiA6ZoFLksLgXoL3GqbN8t/7BYVN5?=
 =?us-ascii?Q?WdNF8HvHdao7MwilaQSjaAPEXNaSJnXwE3920P1Q6nNVAxPMypUxKd++wz8U?=
 =?us-ascii?Q?fTdZYwzO56KVK421SwBJUujsDHfVZMqTe9nrAB6o4v7c3tbFls7C9gHigCOV?=
 =?us-ascii?Q?pJpanBoXT94/PoPEMtPd3Z3O51CqtWLHa0X/j73gRrNoexSbMbWw+5d6ZUET?=
 =?us-ascii?Q?kp3rA2MVxHpzmgRMIvZeVc5gMZZEwsezDjwK/BNyCSLWnn5/SJFwLCN6kMOU?=
 =?us-ascii?Q?/LRUDqy1V1WVM6SXNplgA3n9ixwyPDda?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2024 09:03:06.3107
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a348103c-3942-4fd2-031c-08dcbdd23e3c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000012.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8295

change_num_qps() is still suspending/resuming VQs one by one.
This change switches to parallel suspend/resume.

When increasing the number of queues the flow has changed a bit for
simplicity: the setup_vq() function will always be called before
resume_vqs(). If the VQ is initialized, setup_vq() will exit early. If
the VQ is not initialized, setup_vq() will create it and resume_vqs()
will resume it.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index d1a01c229110..822092eccb32 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -2229,25 +2229,27 @@ static int change_num_qps(struct mlx5_vdpa_dev *mvdev, int newqps)
 		if (err)
 			return err;
 
-		for (i = cur_vqs - 1; i >= new_vqs; i--) {
-			struct mlx5_vdpa_virtqueue *mvq = &ndev->vqs[i];
-
-			if (is_resumable(ndev))
-				suspend_vq(ndev, mvq);
-			else
-				teardown_vq(ndev, mvq);
+		if (is_resumable(ndev)) {
+			suspend_vqs(ndev, new_vqs, cur_vqs - new_vqs);
+		} else {
+			for (i = new_vqs; i < cur_vqs; i++)
+				teardown_vq(ndev, &ndev->vqs[i]);
 		}
 
 		ndev->cur_num_vqs = new_vqs;
 	} else {
 		ndev->cur_num_vqs = new_vqs;
-		for (i = cur_vqs; i < new_vqs; i++) {
-			struct mlx5_vdpa_virtqueue *mvq = &ndev->vqs[i];
 
-			err = mvq->initialized ? resume_vq(ndev, mvq) : setup_vq(ndev, mvq, true);
+		for (i = cur_vqs; i < new_vqs; i++) {
+			err = setup_vq(ndev, &ndev->vqs[i], false);
 			if (err)
 				goto clean_added;
 		}
+
+		err = resume_vqs(ndev, cur_vqs, new_vqs - cur_vqs);
+		if (err)
+			goto clean_added;
+
 		err = modify_rqt(ndev, new_vqs);
 		if (err)
 			goto clean_added;
-- 
2.45.1


