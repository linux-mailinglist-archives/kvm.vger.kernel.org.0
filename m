Return-Path: <kvm+bounces-31129-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 200559C09E7
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 16:18:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 21FE21F24588
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 15:18:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FAAD213EC7;
	Thu,  7 Nov 2024 15:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pPIb8jiG"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2053.outbound.protection.outlook.com [40.107.236.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4EAF21018A;
	Thu,  7 Nov 2024 15:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730992660; cv=fail; b=kgZTWZpeIr1Wis0iJ4imzt8/gEzH6FILbAFGeZ4mH561GnZdvNbnnbh7kyyq5xxX8eOQjagVPbyNcSKhRTJsxNJAM70d5jGXvMjUA+NMYRAkQNQqVviTP4Llo8fuZJJsVRt3IOihsjuT9pS1NT3M5XmAEGNwzlE0YNQfsJDA4L0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730992660; c=relaxed/simple;
	bh=6S7cZ68JZWcjnr9LadAxaejYvfBuJGytnWMz3T6foL0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FW54AHlX2diPeveIH2VSjLNCO3HUgX30yWo1/QJzdnpixkwhSUHyX16PS7LTRz1BpxPUmNHk1VCroozyF300y0KzlMFwsynKI4XZwrkck+M6xmBanpYWQ6QMS2GmTvqyFfP6mQaeFgOR68ZL7MLD28FIgMsYHYng/Gprv0bYBfo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pPIb8jiG; arc=fail smtp.client-ip=40.107.236.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CSRpG/K1eZsuUaf2qrTDqJze1qYQfKNdRrxPnvDPEzPufVd3HOj6+eTa6HqJ2Fi25HQb+ppC6Goa9w4voddg+1IEZsWhSsxnXB+vNebvHESvDJeJqB6feH3q3Zzl0/k0vj/vePc7tYslzarsiLO4dgOtCKEuZPH7fwPf4+5JZnZ8S9Y06rGLv0RxwYFU5Lrc4tAtmedwXVYOuVlDFdhjjdoH0Q3c91Wcmn6paouWvbg0UBwhLC7CqDwpYxRz4rpzgwmmbOxO02sFujc/G8CPQodXaKul0/aoG+eqteELV484j5/JRGy0xEiAxSp6b2BvAdn0oXiLyc4Pgm0F7tqyNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4nLlvH8zGminewn1ZdqNgtHvIvsqhpNug+kDkfYGJyI=;
 b=A1Wl/goZKHFrblClfWa4+/y77Ctyk84y2UyCpL5RvGXdgHVze56LhDm6GGQwoobB37bGZLtvbxZrFo2pouGiKa1i0ROPOeBT15ne15dz9tbrnq7r0s/ZsXhgvMnI2+BPjJHTACuFuAvC4IRUu2XjYNjhhUblGYrnXVhKba7yNnnYg5YTug6Yy5uA66Y4ng0mMvviegX+Hu0+A+5qX0zokR+46StMG1HOmbYXP4zgwkoKaafdNdK4GpNbMcn84ksrK0l5OQMB4b60Pq8w2E6+aQENSaixfUJnP8vA07mnCKMdrd0gh0GjBqUB+yulNoWLX5T+vyG5lLmC72m8vdgVEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4nLlvH8zGminewn1ZdqNgtHvIvsqhpNug+kDkfYGJyI=;
 b=pPIb8jiGLw+E/aCNniztZW7fqp5eRrQuzGLqGvIrHr66/rC6Gm5PCS/SC355c8Jfjfo/dtq/5YV6UfRSO9TJDqS97EQrbQAPo/oWnrgWMyTX0ScvdJtc7Z6/cPzVqIyMm32jGERUaaG0BOaJbJYoOdB3OuRedEivbxWa4lmwSBF2CWAhni/z2EZwXES7a0xjfrbDmiRLYz9aJswysGctLyGYDDiOc5pyAr7lhCGqXIkiASbpZUsywYj3Wf0qZ0Ph6qr3Bc/YA4DpiL7/rnKOqxYs7mAlck+5W7TCG+Bmn6jMEuqeZzgSlmUBGl6Rg3K+LHZd5sFJ8uVQpKuXoMtUbw==
Received: from DM6PR02CA0113.namprd02.prod.outlook.com (2603:10b6:5:1b4::15)
 by DM6PR12MB4418.namprd12.prod.outlook.com (2603:10b6:5:28e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.21; Thu, 7 Nov
 2024 15:17:30 +0000
Received: from DS1PEPF0001708F.namprd03.prod.outlook.com
 (2603:10b6:5:1b4:cafe::41) by DM6PR02CA0113.outlook.office365.com
 (2603:10b6:5:1b4::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.19 via Frontend
 Transport; Thu, 7 Nov 2024 15:17:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS1PEPF0001708F.mail.protection.outlook.com (10.167.17.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8137.17 via Frontend Transport; Thu, 7 Nov 2024 15:17:30 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 7 Nov 2024
 07:17:17 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 7 Nov 2024
 07:17:17 -0800
Received: from rsws30.mtr.labs.mlnx (10.127.8.12) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Thu, 7 Nov 2024 07:17:14 -0800
From: Israel Rukshin <israelr@nvidia.com>
To: Max Gurtovoy <mgurtovoy@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
	Parav Pandit <parav@nvidia.com>, <stefanha@redhat.com>,
	<virtualization@lists.linux.dev>, <mst@redhat.com>, Linux-block
	<linux-block@vger.kernel.org>
CC: Nitzan Carmi <nitzanc@nvidia.com>, <kvm@vger.kernel.org>, Israel Rukshin
	<israelr@nvidia.com>
Subject: [PATCH 2/2] virtio_blk: Add support for transport error recovery
Date: Thu, 7 Nov 2024 17:17:00 +0200
Message-ID: <1730992620-201192-3-git-send-email-israelr@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1730992620-201192-1-git-send-email-israelr@nvidia.com>
References: <1730992620-201192-1-git-send-email-israelr@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0001708F:EE_|DM6PR12MB4418:EE_
X-MS-Office365-Filtering-Correlation-Id: 11924f8a-a822-4743-e877-08dcff3f4c08
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gfaUtsPqiHOuMJpPtDvTT1sxGelDv4l/bQHQQeslP/nkfW+V3iv7yFVKP2E2?=
 =?us-ascii?Q?0mciyWK35Lploo0UIQpFjEqkbpe2zeyWgWKOgi2GzWaWyXhoFWU95Xv8DvH8?=
 =?us-ascii?Q?by2LQy7fu2yFDETrC7fhgvqX5Q38s07PiAJEzA3Q1kzTaCCvHgGg18Ne6bxb?=
 =?us-ascii?Q?JkpKMgDg3jD/eYG3zUKil8Elc7BOxuF/pH3RX+ind2Waw8RTSaSnCG6r/Qle?=
 =?us-ascii?Q?ZdDkGEkBbAhYOWF8xyqqrz/ownGHpSzjUc4dCOh8HPE484Soy2w5BkV/aeWX?=
 =?us-ascii?Q?khEw34BcaNX1vhs4Rj7T2gmZZPJ5N5MGE6JRIwZ69/1S+9Vh8ZFud8091W07?=
 =?us-ascii?Q?xwO+M1WQh4/EIIV2lMG5T4AOaZevE4SrDY3eLWiKHE64KxZNaBeHHJHPAHG3?=
 =?us-ascii?Q?tIcQS+Q3/NzX2beBNVYVfjwo2IK4dqjKZKgCklqChzwV2zzC92+PdgxP5HOS?=
 =?us-ascii?Q?Z743tSrSXfyZvJfBZW4uGpf+bnnUVltLK0JR79nKw13BLeHDH0qbMBaFgpat?=
 =?us-ascii?Q?InrG/0S1iTA3zxxaVDBb7hR1ELLYojcFzoY024QYEF/51BDv+SJrdBkdn+ej?=
 =?us-ascii?Q?zOw+yhr4Ei8wO0DG4Hde/loRdtdrswEXj9i360lNZJnx2wnF/6sHDvcpDNAS?=
 =?us-ascii?Q?AtgDlVcAphHck5H0vrxGmKJz7kdpPjBu1x6jtgZ8kj3R3JCz05fR2AJ86hbY?=
 =?us-ascii?Q?QpqjZtQ7zFhFJ3UA4lv/B2AtzdAtmqRDGXQT9GDQyvzRMpPQ93YOjgo8QZKD?=
 =?us-ascii?Q?mOD8ZuPedNdqxmR44W6nDPQuXKFxTKpYlI2qfUfJ+tbbIFDknp5KqEz+vxso?=
 =?us-ascii?Q?e43twpCGkp5+j3UxyL2+Wg6+83YzBUmCNeM1rdiljl14nafuDJffrNbuskHd?=
 =?us-ascii?Q?LY3jcM0vkABoGi27K4hXBJqvBPjfxxQ+wr9e3xvDmNSg/E4jdw8m+d97IrHD?=
 =?us-ascii?Q?u1fTEbwO/DL6UJVFPg/4J/6Zwd5Cd67OGBE2y0uO5KkwkZSH/zs8bh6+4wfe?=
 =?us-ascii?Q?KMQ6fDJipipOZEJuYl0jKfD9g+WEM2T3RBqqAW+Ky3VsPXjVAxeq/++kFKre?=
 =?us-ascii?Q?DKQdMDP19lU9KEEB6Ia3G7DfzZyGVF/vdyM0OG8MTN7DdDbJGz8aLxJwLSPZ?=
 =?us-ascii?Q?JeRzY59wr08/rd6Rp92kEPBTtttWDFjYBAiLKHh4M0rnUvTEspLHB5Dh1MrZ?=
 =?us-ascii?Q?E6iw+L+lmJ9quay7v+w+jLz6xl/4BlCnfr/DvCxArP8AMZTn1bh9Ol9IkFTJ?=
 =?us-ascii?Q?xeYydHXDiwL0jNdIJdtRR1f1FJJc6U0y2HsNR/c4f5CKShkED/JBpWjxM4ub?=
 =?us-ascii?Q?WPOmgwpTt5ymJ3JB7F6ZGYJO0ksikcXlpqiRscEWjNciSDozsFHjle9Y1H3z?=
 =?us-ascii?Q?/FNPQmMK7K0ijLSR0poGApwf6r8NHC97MMQb2EQJJbFhO1fC+Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2024 15:17:30.1880
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 11924f8a-a822-4743-e877-08dcff3f4c08
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF0001708F.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4418

Add support for proper cleanup and re-initialization of virtio-blk devices
during transport reset error recovery flow.
This enhancement includes:
- Pre-reset handler (reset_prepare) to perform device-specific cleanup
- Post-reset handler (reset_done) to re-initialize the device

These changes allow the device to recover from various reset scenarios,
ensuring proper functionality after a reset event occurs.
Without this implementation, the device cannot properly recover from
resets, potentially leading to undefined behavior or device malfunction.

This feature has been tested using PCI transport with Function Level
Reset (FLR) as an example reset mechanism. The reset can be triggered
manually via sysfs (echo 1 > /sys/bus/pci/devices/$PCI_ADDR/reset).

Signed-off-by: Israel Rukshin <israelr@nvidia.com>
Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>
---
 drivers/block/virtio_blk.c | 28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 194417abc105..c3c421783e2a 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -1587,8 +1587,7 @@ static void virtblk_remove(struct virtio_device *vdev)
 	put_disk(vblk->disk);
 }
 
-#ifdef CONFIG_PM_SLEEP
-static int virtblk_freeze(struct virtio_device *vdev)
+static int virtblk_freeze_priv(struct virtio_device *vdev)
 {
 	struct virtio_blk *vblk = vdev->priv;
 
@@ -1607,7 +1606,7 @@ static int virtblk_freeze(struct virtio_device *vdev)
 	return 0;
 }
 
-static int virtblk_restore(struct virtio_device *vdev)
+static int virtblk_restore_priv(struct virtio_device *vdev)
 {
 	struct virtio_blk *vblk = vdev->priv;
 	int ret;
@@ -1621,8 +1620,29 @@ static int virtblk_restore(struct virtio_device *vdev)
 	blk_mq_unfreeze_queue(vblk->disk->queue);
 	return 0;
 }
+
+#ifdef CONFIG_PM_SLEEP
+static int virtblk_freeze(struct virtio_device *vdev)
+{
+	return virtblk_freeze_priv(vdev);
+}
+
+static int virtblk_restore(struct virtio_device *vdev)
+{
+	return virtblk_restore_priv(vdev);
+}
 #endif
 
+static int virtblk_reset_prepare(struct virtio_device *vdev)
+{
+	return virtblk_freeze_priv(vdev);
+}
+
+static int virtblk_reset_done(struct virtio_device *vdev)
+{
+	return virtblk_restore_priv(vdev);
+}
+
 static const struct virtio_device_id id_table[] = {
 	{ VIRTIO_ID_BLOCK, VIRTIO_DEV_ANY_ID },
 	{ 0 },
@@ -1658,6 +1678,8 @@ static struct virtio_driver virtio_blk = {
 	.freeze				= virtblk_freeze,
 	.restore			= virtblk_restore,
 #endif
+	.reset_prepare			= virtblk_reset_prepare,
+	.reset_done			= virtblk_reset_done,
 };
 
 static int __init virtio_blk_init(void)
-- 
2.34.1


