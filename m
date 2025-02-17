Return-Path: <kvm+bounces-38385-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B5F4A38CA9
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 20:45:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 744643A3AD2
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 19:45:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2F121552FD;
	Mon, 17 Feb 2025 19:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YOAXb50L"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2087.outbound.protection.outlook.com [40.107.94.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 538DA372;
	Mon, 17 Feb 2025 19:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739821514; cv=fail; b=fvCb4s/a34/gcfGKIdT+z6JU+iGcxrcttCLqx/rnW1d/Y0MG3DklcXu2o1rl0y4ZObtkaqZu3c4PzSBIkQhQ38x0Z0aqLC6MmoYmZEUOK1FnaElQiznrmWPNmPSzJVceOQ2Aaro4HhVuI8TxR9x6v010GBSqQSYtfX3+I2SyUGo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739821514; c=relaxed/simple;
	bh=AJik8rY/aMlNbZPCp9DJwveZEOQHrYxtoHpFn5Q+aOk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=vBQq6KgP2+WUuxO3+RSjgWaI6q0MghAgW0PAAftYqt+adke6mO0JJnU7sF0okwrFAEFKy9epj05zExRvYFELzhSf0B35E3jqXiQGeECe2E2r3fYadYm/RuMCag3+BmYQJUkbkPP20ynQPJ7m02KP/yUOqr31mTR3K2QqokyP6qY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YOAXb50L; arc=fail smtp.client-ip=40.107.94.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=stjAx0/4WhzEx3/sGCDbWgdQaHgvaELMObFVUmCyeDFdtsoUsXRzhcm9F51G9QvoefzvCRHOxeoiZ4h+9uedUHh+m/F28jzHstCQJ8JOgkX+1WS8EueH6VUi0T0gYdXzF6kHQm4JTPSBVtJODTkJGao91N8Ic1mckk2MxYWj3ueq05TnLik0jcRxg92KkVMMIC0BpB9qanC9ozuqV1YPIVq9oRfy5qo9ExJZTVsRoGhnguMqljiTgrL0iyzV9T+ixndCK3HEaLAurFSd37IGmtTwaVClixhEzvs3DAhS8Za4yK7OA1tvOUUZJgobC1v/EU0XURlUceGgoB3Q6Ik2fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5dMux0PVRp6CcD9vwX61E0cMURaXaeRNgllS1ZJILqE=;
 b=kHFO9xvM2fwT84RqFCMMqJIdGWxwU2LByhzVkLN1irHm+gQo8Z6rzalozkIwczdOKDMH34Sit9nOeeCDMnSMz/35QbLVwJIgKnLg4x+1tE8pgQLqgNTUB45hjmBfg9nin0H80IkkAxmCf7zelis2si7wCc9Gk4N0rUrQT9d3vVTIit91nrnsbGZSSkaTtvu3fFKXZR5iUA4BoX9GsdIj2TYQuBM45b4aY8kisLVSA9vUQ0hMeJAh1euu82otgNFuBRDRavtdKPE+WgaxhBT7+dS6IUZSgQJ/96T2+rt8fjIgfwQH+Ialu2Mm6AetmU2bRpQj/tGD9g386HJslbFy1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5dMux0PVRp6CcD9vwX61E0cMURaXaeRNgllS1ZJILqE=;
 b=YOAXb50LIuoNppxKwFf7Nkf1X6+MG0DBVVXjRhVXU8XLnWIfjRJZY8BMjRyLqS7xflaY9jX7/GHrdo5bRaG3ji6MRSN8P/C6J1BM4DZl48aUCsvy8J6j0Z9kPvNdF3t7BxE7EqITUgoJu2mkCia7WkhDETj7JuD2541+Gy1LJPVhAzxBre7tMRYmc6cW9SumwX0Bd521YdoSKya7n3dIOuCVFrVdz9NGV+TuipemP5ZD0H1tqnesAJzp25DNMKinuPQnTjyOqdDonAgWcsDcaqsLiufsFGUeN92dgMbLOWAo8KR4NJbxs2HhSy6M5WDKQiyBnL4lCqhuGu0+RhJdpg==
Received: from MW4PR03CA0287.namprd03.prod.outlook.com (2603:10b6:303:b5::22)
 by PH0PR12MB7813.namprd12.prod.outlook.com (2603:10b6:510:286::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.16; Mon, 17 Feb
 2025 19:45:07 +0000
Received: from SJ1PEPF0000231A.namprd03.prod.outlook.com
 (2603:10b6:303:b5:cafe::aa) by MW4PR03CA0287.outlook.office365.com
 (2603:10b6:303:b5::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8445.19 via Frontend Transport; Mon,
 17 Feb 2025 19:45:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ1PEPF0000231A.mail.protection.outlook.com (10.167.242.231) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8466.11 via Frontend Transport; Mon, 17 Feb 2025 19:45:07 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 17 Feb
 2025 11:44:59 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Mon, 17 Feb
 2025 11:44:59 -0800
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server id 15.2.1544.14 via
 Frontend Transport; Mon, 17 Feb 2025 11:44:56 -0800
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, <virtualization@lists.linux.dev>
CC: Dragos Tatulea <dtatulea@nvidia.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Gal Pressman <gal@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>, <stable@vger.kernel.org>
Subject: [PATCH vhost] vdpa/mlx5: Fix oversized null mkey longer than 32bit
Date: Mon, 17 Feb 2025 21:44:43 +0200
Message-ID: <20250217194443.145601-1-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF0000231A:EE_|PH0PR12MB7813:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c8781e2-d117-4030-37bc-08dd4f8b94ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?o282xY0jv0B1+H7GyMWmxGyPJgufv42YtlaAYfsm4ADWo3J5PPa8RR/Q47Qz?=
 =?us-ascii?Q?SrR++E9AWanCyh+2x7imPTjUFEaCGfOJVXlUzp2zXizZ6EEtkIHhm78FGuPn?=
 =?us-ascii?Q?ZQVrA4V5W+22nGetcxot59FOzsh4E5c+pAY5GkePRBWec70EetM168Vj1yEz?=
 =?us-ascii?Q?rhE0TQm2RjsouR4TSqOTFIrz6Y9Uqk/QY9+lbCC8K1cUkoLMc5giI7FrMs/W?=
 =?us-ascii?Q?P6YYpYx4L0QxABq3XNd60ad0AFkG3vLVyKRM4sdnBpamHzvi66zF62q3en2n?=
 =?us-ascii?Q?xXgMjqz4N/aE4TEfSONUCqUsV/QoA9Gc6fkIlV68XqyGKMo0lidxA2FhgYQT?=
 =?us-ascii?Q?6EAw8gw6N7QwitH9AXXO37aUrhrLf6LAD9J9iesQoa89udt+pv8s8uWIuY9G?=
 =?us-ascii?Q?VhB7zwbwJom8TbkwYd/970kbcfvJXoV767zJwdtk3hGaCopqNDWVLRfCwUdb?=
 =?us-ascii?Q?sXT/356tUXxNNXJjNLSQABHycbVIAy7TWjooD2qehzl1eVw3nGwIpYeC3QC4?=
 =?us-ascii?Q?AFlW7xwutp2blaSPyO1PZpWKb0nydL87cJnkaIW06WVVknMgeuuMq8zU7+fv?=
 =?us-ascii?Q?sbp/i2F9kSPvuBHhStcjKQXCHnyjXrDPd1WtDmsyyC6ECbs3fWONpN1MV5x1?=
 =?us-ascii?Q?c1j0Q7/PkslFy3wwfPs6Hcn8C9iCpkzLCL2KmDVpTH2Zz604U487C9NwOKku?=
 =?us-ascii?Q?Hc/SBH5xjJR2MGdct9ASEHIV8DBDdeqwZjP5+XVZ64WM4zrUxugxoHrLp8xN?=
 =?us-ascii?Q?X0sL4KJBqWNFYn4015Rn7b4Op8d0CanoX4QtpcjiQbhqGmr6d/HkN7yVjfWN?=
 =?us-ascii?Q?WPB2Aq9cHUDQFcgalhdFgo4njTqZCuvtg7FhZhBi4N66Qac/BMaY12puhulZ?=
 =?us-ascii?Q?JQ2ivNNIsBpwiH3UrEfl9xWeocoJvdTKCGJPHx8Imv+mMRl1EPCr3FtG1d0Y?=
 =?us-ascii?Q?uJI8Urx2qgmpbGK+kUcYzxyZdaraYB9w3Q/UcdBpHjI2CtGIpIfFXiIXd5OP?=
 =?us-ascii?Q?/02YrbbcFHUo4bux7IMpqbC5qtnEjuZnE1cdCmBEGoeFvIFj7n5w4nurM9sT?=
 =?us-ascii?Q?j00tFtMpb5IsDLJUIn8WXYZggJk4vREPP9t7bZX7kFfaqs4Nyc0545/6r1E8?=
 =?us-ascii?Q?GTZGWSt4Oyjg/dlAzqBqhJJ7/LSw7mj4ogfqoq6ih1NXhpR+nDSlBCDjUk9G?=
 =?us-ascii?Q?bqxwf7ryIYXqW50hJmi3e2+5D3OW8eBE4bfHeh4dibGXo0bnZd7TbogW7U8i?=
 =?us-ascii?Q?wXgk8OYgQ0vthDoFdzJqqjy4HxjIYVFuX0b6Tzr2vfUJjnISwXmcUaKk8Li6?=
 =?us-ascii?Q?5wyYruyJqTSYMhdovV7nO0OlmxKZSRGjkexiC/F7BONDTscTeRHcZWskXkJg?=
 =?us-ascii?Q?htPwgM5iZI7kkWrXhw8cGSNfo7FmE8nn4zpocUZ0QfeYF+dB8K2x18T3/jvR?=
 =?us-ascii?Q?lgbcOzxO8+mRnUjYiCArMZ9Wj3+9tUMk9rhwgaxmhVZstb4U59O8Qw0mo4mL?=
 =?us-ascii?Q?tm2k+qRmiqzZS1s=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2025 19:45:07.3566
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c8781e2-d117-4030-37bc-08dd4f8b94ec
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF0000231A.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7813

From: Si-Wei Liu <si-wei.liu@oracle.com>

create_user_mr() has correct code to count the number of null keys
used to fill in a hole for the memory map. However, fill_indir()
does not follow the same to cap the range up to the 1GB limit
correspondinly. Fill in more null keys for the gaps in between,
so that null keys are correctly populated.

Fixes: 94abbccdf291 ("vdpa/mlx5: Add shared memory registration code")
Cc: stable@vger.kernel.org
Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
---
 drivers/vdpa/mlx5/core/mr.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
index 8455f08f5d40..61424342c096 100644
--- a/drivers/vdpa/mlx5/core/mr.c
+++ b/drivers/vdpa/mlx5/core/mr.c
@@ -190,9 +190,12 @@ static void fill_indir(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_mr *mkey, v
 			klm->bcount = cpu_to_be32(klm_bcount(dmr->end - dmr->start));
 			preve = dmr->end;
 		} else {
+			u64 bcount = min_t(u64, dmr->start - preve, MAX_KLM_SIZE);
+
 			klm->key = cpu_to_be32(mvdev->res.null_mkey);
-			klm->bcount = cpu_to_be32(klm_bcount(dmr->start - preve));
-			preve = dmr->start;
+			klm->bcount = cpu_to_be32(klm_bcount(bcount));
+			preve += bcount;
+
 			goto again;
 		}
 	}
-- 
2.43.0


