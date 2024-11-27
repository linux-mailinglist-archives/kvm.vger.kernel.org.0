Return-Path: <kvm+bounces-32556-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 90ADF9DA290
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 07:58:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2EA1516778F
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 06:58:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34939149E13;
	Wed, 27 Nov 2024 06:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kB6uw8U9"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2087.outbound.protection.outlook.com [40.107.100.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D35AD13BAE4;
	Wed, 27 Nov 2024 06:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732690692; cv=fail; b=oI3eERab0OVVitOE7qxd2wGllPzFEEQ9gYpIBo997qm8SEHmhG0mSBo2dTlTFR14lQ0iuxQOh782jcxWMgUtXvbAhMTg1tbTzptBLtdEAVdynGjGrl/yZ5pX9hClzmD/lhLFCV11Q4/xQ6UE0fDCvLRGD09VGqnetj2cDRXTIEw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732690692; c=relaxed/simple;
	bh=wzxZDe+zI465W2fzP3+4FzGureVXw3fXylzPc55FzjA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JGOSdSDWaag5SrPM7P5vdu9au1229G9m14+Ajr609R9YEg/d1JDbQO8DJjXVq+cC9TpWrgB+fBm+SP7d+sIaQiSuzgvvEj1UmC2FaA3Djtn6hun5968VKT0+j2d4MWvgiO4Hnx8sbmj7FDZlsWlXOQwHwoFekSAzysX484JLZgc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kB6uw8U9; arc=fail smtp.client-ip=40.107.100.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FgivVYK7Bq1iN8yHY6iWFZ82WyhyutA9C/20wA+SjUZhjDzLueA1RQxke6isdhWd69WjZaSX2WGPupUHPSIjNZyUmHgOpU9xQqPRlJ41aiQXEFTwBrk8gn46sLAfXtua1twEmRFA/oUIX85NSAJ7SCxikT4FhJdHtryMtn9fqQLxdMWpe/w8xJagy3V1zngjP1k6308vSR7eH6UbgVnmAi6zTPjRZjQ+Zh/pyxnNrnSR1/vMW8GZF+T78G6goEMN7d+SA+xWd81r3P/yh6/fkL1cVtajTeZ7Ul3pM/v9JdjZynCe/0bNrjP/YIGHfDpa4Q1Lg6f6FtlFI3BaxEe1Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q7dQWmQOjRujgZ7Au6bkJ/LChGdiBPSJIi+snuzt+KA=;
 b=K32oQuOM5RHQbeqIB65PckJzBC5CpQlCdcLmlAy7YPPEFDlhUkiKX7zTcYzsfi3LRvCxj7ActylIMgJW6Zg/8WWfjKvmFyHdbACD3X4y7HwIqcQQW0ClTsz1rONw2s6kHHggD1mCE68K/54fdkAayH5Jwco7BslhMYHbHV6/pvL4ew7A8FgLkks6L9f5BITSMKhxGquKz3ebYpyVVzD/pDOwJgAGCw8t2EBhBrahkCTGdQJG/RX6FP1t0aSLVVS11b00HrfUMU0iVg0hezR0+uzUaxB5diJQB6tEEE1LKfEqtTicxgFDRiSb0FxW7zFiK6csOONgJl5Ey99KVr2E/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q7dQWmQOjRujgZ7Au6bkJ/LChGdiBPSJIi+snuzt+KA=;
 b=kB6uw8U95m6zOcmER5V0X3jCvxhwaUyL+dGBbs5/BNE1F8ivZ/d3eWcO/NG9/l0J+dpCrdMEKTmKVNWp4x1/K9+VGl9KSQZJxphKd4BYItxTYa+PhjOwMmU6ngxnMlqlsUWFiL+MKcBT4ip+yffmdSne6FyjyqUQ++LB00PdPlr2r2fELk1ltBtFfJv8RFTPoQIGop/y8wvr6bSjIVJa7u4FBpodqXNg2hpCY6HUU0c0OzPLLdwmjS8whQvQ+icwz0Spx937QKn27ws3FIjlR9iea4oLliOd7jnMUoizLbGqsVN4BG+wUS1gcw9347R3E+BvJnGLL1E7ePIq3BRZaQ==
Received: from CH2PR19CA0016.namprd19.prod.outlook.com (2603:10b6:610:4d::26)
 by MN2PR12MB4224.namprd12.prod.outlook.com (2603:10b6:208:1dd::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.13; Wed, 27 Nov
 2024 06:58:02 +0000
Received: from CH2PEPF0000014A.namprd02.prod.outlook.com
 (2603:10b6:610:4d:cafe::8f) by CH2PR19CA0016.outlook.office365.com
 (2603:10b6:610:4d::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8207.12 via Frontend Transport; Wed,
 27 Nov 2024 06:58:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH2PEPF0000014A.mail.protection.outlook.com (10.167.244.107) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8207.12 via Frontend Transport; Wed, 27 Nov 2024 06:58:02 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 26 Nov
 2024 22:57:44 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 26 Nov
 2024 22:57:44 -0800
Received: from rsws30.mtr.labs.mlnx (10.127.8.12) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Tue, 26 Nov 2024 22:57:41 -0800
From: Israel Rukshin <israelr@nvidia.com>
To: Max Gurtovoy <mgurtovoy@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
	Parav Pandit <parav@nvidia.com>, <stefanha@redhat.com>,
	<virtualization@lists.linux.dev>, <mst@redhat.com>, Linux-block
	<linux-block@vger.kernel.org>
CC: Nitzan Carmi <nitzanc@nvidia.com>, <kvm@vger.kernel.org>, Israel Rukshin
	<israelr@nvidia.com>
Subject: [PATCH 2/2] virtio_blk: Add support for transport error recovery
Date: Wed, 27 Nov 2024 08:57:32 +0200
Message-ID: <1732690652-3065-3-git-send-email-israelr@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1732690652-3065-1-git-send-email-israelr@nvidia.com>
References: <1732690652-3065-1-git-send-email-israelr@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF0000014A:EE_|MN2PR12MB4224:EE_
X-MS-Office365-Filtering-Correlation-Id: b4c87cf3-cd60-4a36-cfee-08dd0eb0d614
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?r2HgcPyy97tdytraFNWpwqgA2fc4jqOelrLIWzOzSxOtEDQz4U+gpvlMDUAH?=
 =?us-ascii?Q?xJdQQj+slMhbZ2hqmDRb0vvAUz2z6P9+srceT4XlB5HlGk2T+WqHkdmxXXkC?=
 =?us-ascii?Q?fruq/ovmdp4b+pezD2XayL2gpkY7PRLZGfZkqsyepu947wLy2M2cVlzyMedW?=
 =?us-ascii?Q?YjOAuJcpW8p/FrJtGleN6tUSMgVMIGms9l9issQ85fuJmvvHhI7wbDai94XK?=
 =?us-ascii?Q?bJ3zeVbQSAFFnBPFZgx3+LI3L+jfrzdtDFkKAcrJfnAM32hR9aCSQHWl5oBw?=
 =?us-ascii?Q?N9M2agCPe3ImX9/dCQaEm6+LVQYvMM5TIQ1n8QvOvrdURaLkeJtBvUBWRfI7?=
 =?us-ascii?Q?Q+WNQAo9EkrkgJTYX6/YAPwQthyJsnDNFE4HRKtVqGLBS8kLgSbU+XzrK/bs?=
 =?us-ascii?Q?KsOPN/UMVxPKhvUwEjerv8a3hhKVMcWjo7j4wHv1QUvd8JnXtJGfmJr1knVh?=
 =?us-ascii?Q?UAGUTiP6iQZniu/Ttq6WCu6JSrgdkpWWhtiTQZ++TKnL7qL9s59BHaSQQSAP?=
 =?us-ascii?Q?YYhely5xH+D0SiQWQJf0qTYczjGPXY7Sw1oa9C3L396h5wEFZiwIU3axg4Tg?=
 =?us-ascii?Q?i6qogdAyYeuBWcN/xV7wi9bZTi+Fcnqi68QhCWCYpCiudsWrNSrYvYT9xovs?=
 =?us-ascii?Q?+ErwvYtHe/NuKSohHrdJVxUrMN3lPWbjARqyW3uh3irLLJ73ju+ntS1mmEVP?=
 =?us-ascii?Q?XRoWmHG0JNw2n+Q9Bp5mxawH7pG6zv1TwKunVQmWZTW3zWsyLvetfCfE/ScM?=
 =?us-ascii?Q?H9zurnj5+kg7bUKD4OtrWKEyEkS2dXJAuzU+5+VfrMVOO3ELl1BTqPUNWm/q?=
 =?us-ascii?Q?DD+Gtpdh/dGQFw6j9jnpghRn6p+Ah+i9cJddrnZxsUsqUsYGhZgGuddFXWTO?=
 =?us-ascii?Q?aezwf3V2kqlWdXakEzt1p/I1hRwC5ETZPOI/vboqnuo/olZdT9U8hchzXUKC?=
 =?us-ascii?Q?nmPfNl2/UqkkspDFpGn2d/uEFnnIi28JMPqAAxzLHLrdSv5AwEIoEZpNCvNM?=
 =?us-ascii?Q?vgUgYFfH5cTeUIj2AtIQ//qm2YDkdgUTmTeiC8lKssXzPwK+LRAgreJt2iVO?=
 =?us-ascii?Q?cK2kprDBdPnydVFVlmmt07hwZExK4As78XxRhVBrlBGkeWchIavnQRLPNPws?=
 =?us-ascii?Q?1LSCSRslBjagm+yDo5JUARy3V5fV/zeF5kpriKu5xhvliFbfwg0FKqX5RWec?=
 =?us-ascii?Q?Hv58Aq/G4FDuVO1BLefU0QERuybiQxeqwx2p2N6MW+ZO5d2Z31hQPOSmG6b5?=
 =?us-ascii?Q?TovtXHKvek4VzJ7m1VnRKMNe6vOULwqvobugYuJDgyUwNxdT3LXFzpv8lLY2?=
 =?us-ascii?Q?NsYB8xk7kCN0nWJwWYn/RkHrzFzu+1vPJHEpvdo5SUw+oF0EsRy9Hyd/RvRx?=
 =?us-ascii?Q?JkfQWftQSiXT+G2CnDPHNqf8V+ZeRfEsaaup+BvwftHIsJUBV05G2/z36acZ?=
 =?us-ascii?Q?4UMuodk77Y4jYCVTwMh35FdvYO5vHjwy?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2024 06:58:02.3637
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b4c87cf3-cd60-4a36-cfee-08dd0eb0d614
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000014A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4224

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
index c0cdba71f436..e1ab97251275 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -1582,8 +1582,7 @@ static void virtblk_remove(struct virtio_device *vdev)
 	put_disk(vblk->disk);
 }
 
-#ifdef CONFIG_PM_SLEEP
-static int virtblk_freeze(struct virtio_device *vdev)
+static int virtblk_freeze_priv(struct virtio_device *vdev)
 {
 	struct virtio_blk *vblk = vdev->priv;
 
@@ -1602,7 +1601,7 @@ static int virtblk_freeze(struct virtio_device *vdev)
 	return 0;
 }
 
-static int virtblk_restore(struct virtio_device *vdev)
+static int virtblk_restore_priv(struct virtio_device *vdev)
 {
 	struct virtio_blk *vblk = vdev->priv;
 	int ret;
@@ -1616,8 +1615,29 @@ static int virtblk_restore(struct virtio_device *vdev)
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
@@ -1653,6 +1673,8 @@ static struct virtio_driver virtio_blk = {
 	.freeze				= virtblk_freeze,
 	.restore			= virtblk_restore,
 #endif
+	.reset_prepare			= virtblk_reset_prepare,
+	.reset_done			= virtblk_reset_done,
 };
 
 static int __init virtio_blk_init(void)
-- 
2.34.1


