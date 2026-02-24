Return-Path: <kvm+bounces-71595-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sOiaEr9gnWkDPAQAu9opvQ
	(envelope-from <kvm+bounces-71595-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 09:26:39 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A7FBF183A16
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 09:26:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 84887311DA9C
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 08:22:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65E8536657C;
	Tue, 24 Feb 2026 08:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ifs7VT1o"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012010.outbound.protection.outlook.com [40.93.195.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA59366807
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 08:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771921327; cv=fail; b=t3gNgeHtU0GYSMp4XKZJnZW2QMzXK3BDKnVCvLbt9wEhoxb/yLqnR8ZET+QIv5d+7DUo+HKTsV4muEEwBTAE9dl3pBitR8RXWGU3x6liPIBI6DFLB8OzLTkabxwm8OQLCxLHgYdurKeFWvhEn+AESIa8PVuGNQrK4/UwN1ON5V8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771921327; c=relaxed/simple;
	bh=T4TEdl+5HHL+w9des0apKoRFbjeu3Zk2+MKE34J0Q5I=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bZ5kEPLT2/JhMDAXmZLd2DI2J6MYSqbq2SzVskN1nruXBlq5nyvg2P1qUZXCUuQSA/DBYXul0yeZwqJwCF9vs8FqV19CURuXD5pEXFW/reqypUBoM66jYykvtgJoNu7odjyOWSuxn9hZT7hkmPutxH0pVDyxbrDVPzrcDCZzLhU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ifs7VT1o; arc=fail smtp.client-ip=40.93.195.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MmCrTAAGWKSGgtbpJTwyWEra/HOpj71qQGAE6Qo9QBiFlA0KkL+dt5qCh3/PF1CMm4vMR0PcxdaFzMiLzHeGJg0FZbWPUABN2Bdpy1fg63y4m8A4wC97A7/nU+KauHj0tLEjHDQT5kpHzig4owM28LmXtr/VpVySqqEmknmYmUSN9Gw+VTaXoqBUkUfLUvIeZFklQxVM5DlaV//LpyR+oMl1KpHIZHUE8iIFG6NKl1jV4rR9RhZTU0w27CUKoKmY7AsKDGlwDkISQHTDmw5GxS/tR6qtY8eHeSq37OohREiqr8khOPEF4m746qaK4ffaZXLXq0mGtyufMZY/xHRk1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zMwO5lrBCf1qSCFOr0RrOI+d2B28hJuMa6YpJcqsYiU=;
 b=wWNOSz3QJTja+K09K0FDjXmygCTm4jvj/uln1ftiQW9f4HZ4qS6Jf+IrFPidcHIP0FDYs/3RI/rffhztRZQbqjqH2xqJVzVL1NLHSbSFureuVuWquuUizQwGkceM5Q3GMUQKroOeLwrNgUJiFF7s1R0pT0wpVxq24233ucrjKqODP3zn+Ndiv53NlVdBzh8V1fokpmqp9+86BblAIp5mFz5u71f3SWQ75dXy2wvnbuXoOoIQGy/it2c+Rgy1Aqi3EtfgDpmgKndZYE/z8/FAGR4jw2VsFdjGDLTwaOv9StjzZphdUqxRea6RTuQ1Z8KmCzbdnAGr2POGTQ/oNR7qXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zMwO5lrBCf1qSCFOr0RrOI+d2B28hJuMa6YpJcqsYiU=;
 b=ifs7VT1oWrznPGmOLBJvu5xfSStMLUibwaFk6JYi1VBjdFkyzpQ6dP8xGQEuvVUiPd/9cUoE73l+oi8po7RCViH6KH8m2Vvtxp0jsW0pSCSE53n351y31mewABHBlhC606HzIj7TP+sr20rgrZrV4BYr6UWup/r7zXP0uYVXuS+n2B1UIKeuBMMlI/JaoFJOk4Q/9uPC7hvL8n6B32WtBgrK4+7Odxtn4HvtUmUyqdIHi6PsW7TvF/YzEo3tqhO0cpE7pL4CNbskGq51OHGbsKPvoe683X01Wvu/dXmixTK9xT/f7uISdmfMAwRmh6A7GmhbhVIPtW8VGilSiQw9Hw==
Received: from SJ0PR13CA0105.namprd13.prod.outlook.com (2603:10b6:a03:2c5::20)
 by IA0PR12MB8837.namprd12.prod.outlook.com (2603:10b6:208:491::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Tue, 24 Feb
 2026 08:22:02 +0000
Received: from CO1PEPF000075F0.namprd03.prod.outlook.com
 (2603:10b6:a03:2c5:cafe::99) by SJ0PR13CA0105.outlook.office365.com
 (2603:10b6:a03:2c5::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.22 via Frontend Transport; Tue,
 24 Feb 2026 08:21:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1PEPF000075F0.mail.protection.outlook.com (10.167.249.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Tue, 24 Feb 2026 08:22:01 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 24 Feb
 2026 00:21:43 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 24 Feb
 2026 00:21:42 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Tue, 24
 Feb 2026 00:21:40 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
	<maorg@nvidia.com>, <avihaih@nvidia.com>, <liulongfang@huawei.com>,
	<giovanni.cabiddu@intel.com>, <kwankhede@nvidia.com>
Subject: [PATCH vfio 5/6] vfio/mlx5: consider inflight SAVE during PRE_COPY
Date: Tue, 24 Feb 2026 10:20:18 +0200
Message-ID: <20260224082019.25772-6-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20260224082019.25772-1-yishaih@nvidia.com>
References: <20260224082019.25772-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000075F0:EE_|IA0PR12MB8837:EE_
X-MS-Office365-Filtering-Correlation-Id: 971f4313-0771-4677-2947-08de737dc968
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GNhLjK7wx/iFYmad1CMzkfhp07AXnu6wgSroPFQ7VUaFk8KriNq1qzBp09Ro?=
 =?us-ascii?Q?aM90uusNi0z0fjaW+LDH0KFE8iwu3knR2HrxbFQWASNG3sF/WDWBfygr1oLD?=
 =?us-ascii?Q?oa9LgVyAjTilw8hYEN4JZUDTl0S6pg0fhYhH+4dobh33pCG6lxOLAIYj69J1?=
 =?us-ascii?Q?s70s5Qj9UlMVWErZeKJjdzCL2psQ5TMgUr/lQcSkuqtdWGqp5CyEhV7aMYcI?=
 =?us-ascii?Q?nkUcqsxD+XoVdrz57qcgBB3fQnzCndzPtcK8E8Ro3JejdDFYw9RtvU3cCWab?=
 =?us-ascii?Q?7in7FeVTaq5LZKk+5Lr/eSVMyLcBRD/rfXsj2rUWYmKxGDeK/76pfRe3jtQT?=
 =?us-ascii?Q?Ok1NIkuGAzv3IPBv8L6HUuAa+VqIwsvES6Mk8pjLYiBkkmVNZOr775bd4gS7?=
 =?us-ascii?Q?5fMkBhh9x76XDa1Xv+eXRKoc19EUkvpufWDV9/+2mmVKGZkhQ8Ynpethooz8?=
 =?us-ascii?Q?AEus8j2z6ggFdlGbtwqn1JFZNBimtazoDfFLWFavmGkidK0sAaWpHE2oxzZt?=
 =?us-ascii?Q?awJwD3yG3wXkFUXygLYgB/2ph7yGbEuJ3VX8PWCjVxqAJnEPOGbzoDKXgVho?=
 =?us-ascii?Q?3H070Hrpkwl1uUIXG6g/SlaXPYQpZUyHoJ0KdQiRT3SGwb7frJ6Igp0dqsLU?=
 =?us-ascii?Q?MC0TdNH4GeKluq7lsrChA8Wx/3knuo6T4zZIZ3DAd1EPHAwiVHg5nwA4dRkQ?=
 =?us-ascii?Q?HrrpeqHgTZITyoodjrEj+PcZUhgvllRlAE9GFkw7j+YnShSZQKbk97qVNbJ+?=
 =?us-ascii?Q?CVF7/K/4A0juOr/vAUMgFXJmMylrlVtCC8sMPOGi1dvPnmFWQuzv8raC5qMj?=
 =?us-ascii?Q?idImfFB+G+WLDHXpPXRWfB0i+TA9hAJql4qlWWv2QU+5yPtnqv6vvjr/2f65?=
 =?us-ascii?Q?5qY6+ecQgtO1KNg/OZ8+8i0rTFAc+PM3HjzRjKxkIofargRTCIK4MPX5FsB5?=
 =?us-ascii?Q?At3P2rANPT8KQRLVvAdcs/C0Qw2KU9yXxckmrkW3OX7waCzoytj5ppA2LzfY?=
 =?us-ascii?Q?AtGmkhmPjXNPfau4poo5l+x0ckQkhzIaLzs3warCJtmY2E6jgI3iwutz+0G3?=
 =?us-ascii?Q?p7Dra0KHKRn7UdV5brUrxwFcRhfxu+m1c5922jL+yj8GXx36UbTp7cGJM/rr?=
 =?us-ascii?Q?vyC1Vdx4eGDQvna34mIhFzfTLzFKCRv2yIxghP4psKQ5wWh9/+QJYSqY82jz?=
 =?us-ascii?Q?V+QlQPQV4XAGjGGDYktp/ixqEPDh4R7GLZS91INC1pw2IgLrUu/5Et6vd+Pc?=
 =?us-ascii?Q?lsrs3OpD4uQwDxhhIIFhF+Tvp1ZP5EvZaiOk41m9TSwYii+Znh7mm9pysuzv?=
 =?us-ascii?Q?00deEcUBazt+PPVcwzfu2k8/5u9r5v2WnAVaFcBFvZc5SGQc7c8gmSyXzbm+?=
 =?us-ascii?Q?EKY1l8wuO0mRowMjC4wjQIx1cdIhg3KWIo76hIzpSFTfQ1heyE9DjU+fOVP9?=
 =?us-ascii?Q?gSfwE2vVAkCjJBL6OAjljA8Ke9f19Wa1mT5m8lV1yCjGJr4xiwUucCYzr8MR?=
 =?us-ascii?Q?Qed4e0KPJxa5usSoOfbO6Lv7q+ltwMf8mF6mC0EQViN3e9BFeiSp97cmsdkP?=
 =?us-ascii?Q?Q8DfJiW1JHpK9rG48k6znDOt/A3pAy0BVBa/4FTgW0kUdj2bWFX4FUK9sP30?=
 =?us-ascii?Q?NqEPSJ404oxENud8yTYzNfhSN+djfgQrU7ygRNZPJFgvg6wA+GBF9p3ujBLR?=
 =?us-ascii?Q?+PJn3A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	rl81MHcr/5bmjJeap687G5snkqO07te4ThDDDrBoyzzEN7ThQPiiwgxDyPtoujddm+UW+vBTV/4MI2oL8uULAYPTcNvUEiDWDPdeh3x82zAdkwytIqPcmIWUbSp0uOfL3XBYh9+GWeNh7Om5iqShHePAOlRlY7rm/eVJYpYB1KT+A/LcIyQH3054LSZoMrIgmnRoJ5WKwn85G32jjMFx8rXl1tId/2gLw+TbbwasWIwWhvSY5GILmKYqP5pnXjiuXzxrihFizh0cTDSCnoot4Ctl4aPXTF8VBPnQ/V+J//YrJwOGDlMd8kc+nmmqVwRhFrc7P4nx8YHUuwofYXBPVpcFUREH6PduJLz4kiQvXiTfpivPuhDbQF8tT8TjHC5uwzpINO4SeA19iOrm4QxjvbIosH0w6eMIwUDit85cRflJEM5cm4qjbTBXOv66dfI/
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2026 08:22:01.8910
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 971f4313-0771-4677-2947-08de737dc968
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075F0.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8837
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71595-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_TWELVE(0.00)[12];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yishaih@nvidia.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_NONE(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	DBL_BLOCKED_OPENRESOLVER(0.00)[nvidia.com:mid,nvidia.com:email,Nvidia.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[9]
X-Rspamd-Queue-Id: A7FBF183A16
X-Rspamd-Action: no action

Consider an inflight SAVE operation during the PRE_COPY phase, so the
caller will wait when no data is currently available but is expected
to arrive.

This enables a follow-up patch to avoid returning -ENOMSG while a new
*initial_bytes* chunk is still pending from an asynchronous SAVE command
issued by the VFIO_MIG_GET_PRECOPY_INFO ioctl.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c  | 5 +++++
 drivers/vfio/pci/mlx5/cmd.h  | 1 +
 drivers/vfio/pci/mlx5/main.c | 3 ++-
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index ca6d95f293cd..18b8d8594070 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -606,6 +606,8 @@ static void
 mlx5vf_save_callback_complete(struct mlx5_vf_migration_file *migf,
 			      struct mlx5vf_async_data *async_data)
 {
+	migf->inflight_save = 0;
+	wake_up_interruptible(&migf->poll_wait);
 	kvfree(async_data->out);
 	complete(&migf->save_comp);
 	fput(migf->filp);
@@ -809,6 +811,7 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 
 	async_data->header_buf = header_buf;
 	get_file(migf->filp);
+	migf->inflight_save = 1;
 	err = mlx5_cmd_exec_cb(&migf->async_ctx, in, sizeof(in),
 			       async_data->out,
 			       out_size, mlx5vf_save_callback,
@@ -819,6 +822,8 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 	return 0;
 
 err_exec:
+	migf->inflight_save = 0;
+	wake_up_interruptible(&migf->poll_wait);
 	if (header_buf)
 		mlx5vf_put_data_buffer(header_buf);
 	fput(migf->filp);
diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
index d7821b5ca772..7d2c10be2e60 100644
--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -111,6 +111,7 @@ struct mlx5_vf_migration_file {
 	struct completion save_comp;
 	struct mlx5_async_ctx async_ctx;
 	struct mlx5vf_async_data async_data;
+	u8 inflight_save:1;
 };
 
 struct mlx5_vhca_cq_buf {
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index fb541c17c712..68e051c48d40 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -179,7 +179,8 @@ static ssize_t mlx5vf_save_read(struct file *filp, char __user *buf, size_t len,
 				!list_empty(&migf->buf_list) ||
 				migf->state == MLX5_MIGF_STATE_ERROR ||
 				migf->state == MLX5_MIGF_STATE_PRE_COPY_ERROR ||
-				migf->state == MLX5_MIGF_STATE_PRE_COPY ||
+				(migf->state == MLX5_MIGF_STATE_PRE_COPY &&
+				 !migf->inflight_save) ||
 				migf->state == MLX5_MIGF_STATE_COMPLETE))
 			return -ERESTARTSYS;
 	}
-- 
2.18.1


