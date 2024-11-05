Return-Path: <kvm+bounces-30789-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E5CFC9BD569
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 19:53:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 74DA81F23B48
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 18:53:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EF381E9094;
	Tue,  5 Nov 2024 18:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ta2vZ1wN"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2085.outbound.protection.outlook.com [40.107.220.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797F917BEB7;
	Tue,  5 Nov 2024 18:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730832716; cv=fail; b=HpYb9HhT5l6LzeL39NuufcpG2ErHAhOjIVtVCia9loB+FrmE2BA1X93Caq+XgdEycbPCuxmShI8wTNL2ZqStkQ8NUBA6zoTyKmTYF2zeNtozXa0yXDla1m1yXkN+Im5sALof8ltWiG9uCs7dTTkjpkL0f/GG5ECzkkq0UHxwgFw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730832716; c=relaxed/simple;
	bh=AG+1xZB1GtNa6tVrin6WpMqS2/KxPsPLq4e9wtjAKbw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=kg/UeEN8u7vjQVvHO/Y6vlHCi40VLtMyT3vuowhDuplK1iNZ6ExsW1XgM5vYBrsqBm/Tq4eUtGhPH2cDgnBQnRni4Ed/LttBcg26GMtLtFpEyB0PlGfe8GxB0sIeK8ovRrTavN3eWhkcIKL0oSjSWB6XoGzfDPGWHCgM5h37uJc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ta2vZ1wN; arc=fail smtp.client-ip=40.107.220.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ANXvxDfzUgEL54H4NN7UD3zMwAQtg4jQCKPJkjpDmUeEkci4aLnMvEOxtPcIDqp3vqI8wG759ysuCYvVEynViNMLoVh2vSf6Z6q3JdUfg5rCZMDY621aGOVkOfmcMOKyg7TVv8orgxBkKBKa48P2fjuLTedzejGPdMQyy8nsw3HyeA2YQcujArKoE2a7QEkHIPZQR6gIZ0TJN/jJyZW5n9AyP63k3mSpLTzsHlfwJfXggT07/sgjDIzv8+5eYuz3lqCp0KXoMmrhf9wB/rrxbGehuw0gAyEuslKAkyHGm2LkTCJiMY9OtjdjADvag8zn+tWgxtWWZSGariwaWJ3MKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L8gevuR6e2Ve8enyppuIZiMox6SodEdl8Chvb65uEzk=;
 b=saN9Vs1S9u6sAHKU6qbxqN87jp8dB2nM2y5Dj0inu7aWi5iPA1QkcvzmAfF/48hdn5JA3A/1/OlfvTQIGT6wEKlxNBdNPXpAtCzm6tnaohRSY2GQ3T9BSG4UxjrOYcJkDmBXgUNji5zzdb7/sStrjDrwCi1SgWAivfuKfQv1oLWqp2lM5Ovrj5n6EmmdDXO3UAKgfrLhoEaggHkSmYfEh3gxS2gTzxXqOblmn48omB1dMSBqUdX0t2TFcQBIGysCs8WXyLFZuup8GX6F83fzD9lJTlGO3zacMDrOf2dJuHhlC4EQAO4zENHwutnsvsWQRRI1gtYQon//l1oKygFhGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L8gevuR6e2Ve8enyppuIZiMox6SodEdl8Chvb65uEzk=;
 b=ta2vZ1wNt4096cqZAjPhR611Oad9LrGiSU2RAsOmcROOHnSeOpc41y+M56Cs4puF4JimTZVNk/BmA1ppu2RTacbWGx2kGA/Y/9Y5Bl56dVLf4W98otTzVE3aU91Mn2ihfh4eebHmcd6VE0uaRmxyOis8gsmTUDUuqqcdbq5Vdm1F2nx9rQprDZqRNtechdf8HDlrngjSrL8FZ9QnZ5QBdW7vUkd+j/drrZ+z31b8am1uslyk9FArV6X2JU+ZCF8bH7PX5H/p77+L72zZQhpBESfvO3I3zdHM1HGH/uuRrxGEvKjkNAEV/K6484ZmA+7okErUncV/5pXdKtRiN5S9Ng==
Received: from BLAPR05CA0036.namprd05.prod.outlook.com (2603:10b6:208:335::17)
 by PH7PR12MB6396.namprd12.prod.outlook.com (2603:10b6:510:1fc::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Tue, 5 Nov
 2024 18:51:51 +0000
Received: from BL6PEPF0001AB75.namprd02.prod.outlook.com
 (2603:10b6:208:335:cafe::7) by BLAPR05CA0036.outlook.office365.com
 (2603:10b6:208:335::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.18 via Frontend
 Transport; Tue, 5 Nov 2024 18:51:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BL6PEPF0001AB75.mail.protection.outlook.com (10.167.242.168) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8137.17 via Frontend Transport; Tue, 5 Nov 2024 18:51:50 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 5 Nov 2024
 10:51:40 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Tue, 5 Nov 2024 10:51:40 -0800
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.126.190.181) with Microsoft SMTP Server id 15.2.1544.4
 via Frontend Transport; Tue, 5 Nov 2024 10:51:37 -0800
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, <virtualization@lists.linux.dev>, Gal Pressman
	<gal@nvidia.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>
Subject: [PATCH] vdpa/mlx5: Fix error path during device add
Date: Tue, 5 Nov 2024 20:51:02 +0200
Message-ID: <20241105185101.1323272-2-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.46.1
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB75:EE_|PH7PR12MB6396:EE_
X-MS-Office365-Filtering-Correlation-Id: 8367e0db-fcb7-4e95-c230-08dcfdcae8a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XohEWWTpeZDddQb09kNDTOuG7sqp2L5j/+fZFfXB8GwQRdxbg3yXjpM+gFVX?=
 =?us-ascii?Q?gvs8KP393S4BAotl8ooKX1F9/Q2ZdtoT3ls2tE8bCSLzja9UoSd8vySXDjLt?=
 =?us-ascii?Q?IIdHzwa6/ZuncEMgY7dP68A8XY3eMudDz/F9ISHr5hAOmWcPiO3TNlcGo//k?=
 =?us-ascii?Q?HiidDrFNfh+DqFvj+Hd2t0HTj0jYsoIlr+peLxAkigaZVEofbR4M2uD5luh3?=
 =?us-ascii?Q?4BQ8x8pT/SLMnTq8YOlVe4BPjaS5k/Ny+HN77i4YjJWkdJOJHFwswbv0r186?=
 =?us-ascii?Q?IQ8qc0TlIzWGPa9dbKCU2I2nP6T8K8Mvr3FkJvto3BRP6w9YXRFoNKBq+U8+?=
 =?us-ascii?Q?uVGSsTkhU1sHMHWXk+l6LmdkHn02WZop3h6h6MqROggGZa0eWs3GjBRKPEkK?=
 =?us-ascii?Q?PiuADRxo+HvMADzvxrbQAlOM5f/5ND6FgLSbM9gv78Rz2lDEaFe/plNFIX/B?=
 =?us-ascii?Q?jZTO0g3gvTnkW1MEB0sZ3OD6rxLJUBlCjZlSEp919K5wWJCbCMRyigRSMLOa?=
 =?us-ascii?Q?AuF2tvCwrVIdc0QX7AOvWslobMYpTAz/LWkYBZ5JYGH44wxOUqufgLvAdjWJ?=
 =?us-ascii?Q?cfScGjYjKI0pwnsl5PMyuy+LN13KIKE8/D1xHwzziC5W3fT/MLaMsXllV781?=
 =?us-ascii?Q?bjq3vHZxK8bPVU0ABPPgHRe1XTWvVlFNQ5H8/E1CFFBHqq35cgTiA/NtEJti?=
 =?us-ascii?Q?1F3S7LTec/5CsWcAbljneASSMhr/m+qQhYM5YEWc2AqZW47l/ceZ0tvlF4wE?=
 =?us-ascii?Q?aYBeNoT1Ug4XhxQuKsZS5oZLRn1pLQlDeqBongpNQFyCqV0pPc11R55xFo/e?=
 =?us-ascii?Q?ljEFSax1BE96RdqnivQPJ1lwfACusK8+CAVbjw0SrD9VBbyZWVpeE2Yjcddd?=
 =?us-ascii?Q?8M3/xY0axqs0GFmlZuATxNmUFjWszUWfQ/r5cWfNtXQQktZiNrPCpG10KVR/?=
 =?us-ascii?Q?cQfNV09Um7ixBY3DIfMOFibNG56DM9A9sFCsHSTRI/nfS5UTIcMbmR2pn+2T?=
 =?us-ascii?Q?MVjNL0o5oNuLj5MRWfcTM0/1odpfQVJY9GGL/NgLQhTdwdsTI8jrO6q7C+QY?=
 =?us-ascii?Q?eI0hDwjwht6ReUOe09m3dPBAtm1dt2KKfm79qqolshPoRObUfj9u1tVeHIGX?=
 =?us-ascii?Q?oWhh48DQ2bw3cr8xFBsnzO5ynMpBDCcca38lft9/qkcv4bnCwdBuF16/slnH?=
 =?us-ascii?Q?mUonxd+Pobw0OnAyA6hGiXWCiNbV1n7Dofr7iYUwk8YCSvN0jQpKUq349ulJ?=
 =?us-ascii?Q?IPHw/H5NrAgHQAePCujftr2+mG3GOvfWrleVqOD2ZK/WGZsihTxw84+mXF+z?=
 =?us-ascii?Q?AIGC2sfZ/OcvAOIUbTaWRK8jOXfJSn5Xe540nlUm3tv6Uzuot8stxSD/IcvR?=
 =?us-ascii?Q?IhbLTdj6uwoF4kV4gKcVMZCMqyYZ2zukKoAAsndi0Y9s/ObZtQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2024 18:51:50.6331
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8367e0db-fcb7-4e95-c230-08dcfdcae8a8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB75.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6396

In the error recovery path of mlx5_vdpa_dev_add(), the cleanup is
executed and at the end put_device() is called which ends up calling
mlx5_vdpa_free(). This function will execute the same cleanup all over
again. Most resources support being cleaned up twice, but the recent
mlx5_vdpa_destroy_mr_resources() doesn't.

This change drops the explicit cleanup from within the
mlx5_vdpa_dev_add() and lets mlx5_vdpa_free() do its work.

This issue was discovered while trying to add 2 vdpa devices with the
same name:
$> vdpa dev add name vdpa-0 mgmtdev auxiliary/mlx5_core.sf.2
$> vdpa dev add name vdpa-0 mgmtdev auxiliary/mlx5_core.sf.3

... yields the following dump:

  BUG: kernel NULL pointer dereference, address: 00000000000000b8
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 0 P4D 0
  Oops: Oops: 0000 [#1] SMP
  CPU: 4 UID: 0 PID: 2811 Comm: vdpa Not tainted 6.12.0-rc6 #1
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
  RIP: 0010:destroy_workqueue+0xe/0x2a0
  Code: ...
  RSP: 0018:ffff88814920b9a8 EFLAGS: 00010282
  RAX: 0000000000000000 RBX: ffff888105c10000 RCX: 0000000000000000
  RDX: 0000000000000001 RSI: ffff888100400168 RDI: 0000000000000000
  RBP: 0000000000000000 R08: ffff888100120c00 R09: ffffffff828578c0
  R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
  R13: ffff888131fd99a0 R14: 0000000000000000 R15: ffff888105c10580
  FS:  00007fdfa6b4f740(0000) GS:ffff88852ca00000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00000000000000b8 CR3: 000000018db09006 CR4: 0000000000372eb0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  Call Trace:
   <TASK>
   ? __die+0x20/0x60
   ? page_fault_oops+0x150/0x3e0
   ? exc_page_fault+0x74/0x130
   ? asm_exc_page_fault+0x22/0x30
   ? destroy_workqueue+0xe/0x2a0
   mlx5_vdpa_destroy_mr_resources+0x2b/0x40 [mlx5_vdpa]
   mlx5_vdpa_free+0x45/0x150 [mlx5_vdpa]
   vdpa_release_dev+0x1e/0x50 [vdpa]
   device_release+0x31/0x90
   kobject_put+0x8d/0x230
   mlx5_vdpa_dev_add+0x328/0x8b0 [mlx5_vdpa]
   vdpa_nl_cmd_dev_add_set_doit+0x2b8/0x4c0 [vdpa]
   genl_family_rcv_msg_doit+0xd0/0x120
   genl_rcv_msg+0x180/0x2b0
   ? __vdpa_alloc_device+0x1b0/0x1b0 [vdpa]
   ? genl_family_rcv_msg_dumpit+0xf0/0xf0
   netlink_rcv_skb+0x54/0x100
   genl_rcv+0x24/0x40
   netlink_unicast+0x1fc/0x2d0
   netlink_sendmsg+0x1e4/0x410
   __sock_sendmsg+0x38/0x60
   ? sockfd_lookup_light+0x12/0x60
   __sys_sendto+0x105/0x160
   ? __count_memcg_events+0x53/0xe0
   ? handle_mm_fault+0x100/0x220
   ? do_user_addr_fault+0x40d/0x620
   __x64_sys_sendto+0x20/0x30
   do_syscall_64+0x4c/0x100
   entry_SYSCALL_64_after_hwframe+0x4b/0x53
  RIP: 0033:0x7fdfa6c66b57
  Code: ...
  RSP: 002b:00007ffeace22998 EFLAGS: 00000202 ORIG_RAX: 000000000000002c
  RAX: ffffffffffffffda RBX: 000055a498608350 RCX: 00007fdfa6c66b57
  RDX: 000000000000006c RSI: 000055a498608350 RDI: 0000000000000003
  RBP: 00007ffeace229c0 R08: 00007fdfa6d35200 R09: 000000000000000c
  R10: 0000000000000000 R11: 0000000000000202 R12: 000055a4986082a0
  R13: 0000000000000000 R14: 0000000000000000 R15: 00007ffeace233f3
   </TASK>
  Modules linked in: ...
  CR2: 00000000000000b8

Fixes: 62111654481d ("vdpa/mlx5: Postpone MR deletion")
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index dee019977716..5f581e71e201 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -3963,28 +3963,28 @@ static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *v_mdev, const char *name,
 	mvdev->vdev.dma_dev = &mdev->pdev->dev;
 	err = mlx5_vdpa_alloc_resources(&ndev->mvdev);
 	if (err)
-		goto err_mpfs;
+		goto err_alloc;
 
 	err = mlx5_vdpa_init_mr_resources(mvdev);
 	if (err)
-		goto err_res;
+		goto err_alloc;
 
 	if (MLX5_CAP_GEN(mvdev->mdev, umem_uid_0)) {
 		err = mlx5_vdpa_create_dma_mr(mvdev);
 		if (err)
-			goto err_mr_res;
+			goto err_alloc;
 	}
 
 	err = alloc_fixed_resources(ndev);
 	if (err)
-		goto err_mr;
+		goto err_alloc;
 
 	ndev->cvq_ent.mvdev = mvdev;
 	INIT_WORK(&ndev->cvq_ent.work, mlx5_cvq_kick_handler);
 	mvdev->wq = create_singlethread_workqueue("mlx5_vdpa_wq");
 	if (!mvdev->wq) {
 		err = -ENOMEM;
-		goto err_res2;
+		goto err_alloc;
 	}
 
 	mvdev->vdev.mdev = &mgtdev->mgtdev;
@@ -4010,17 +4010,6 @@ static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *v_mdev, const char *name,
 	_vdpa_unregister_device(&mvdev->vdev);
 err_reg:
 	destroy_workqueue(mvdev->wq);
-err_res2:
-	free_fixed_resources(ndev);
-err_mr:
-	mlx5_vdpa_clean_mrs(mvdev);
-err_mr_res:
-	mlx5_vdpa_destroy_mr_resources(mvdev);
-err_res:
-	mlx5_vdpa_free_resources(&ndev->mvdev);
-err_mpfs:
-	if (!is_zero_ether_addr(config->mac))
-		mlx5_mpfs_del_mac(pfmdev, config->mac);
 err_alloc:
 	put_device(&mvdev->vdev.dev);
 	return err;
-- 
2.47.0


