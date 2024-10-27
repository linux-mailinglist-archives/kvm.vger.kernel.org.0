Return-Path: <kvm+bounces-29756-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 96EC19B1D15
	for <lists+kvm@lfdr.de>; Sun, 27 Oct 2024 11:09:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 56137281DD2
	for <lists+kvm@lfdr.de>; Sun, 27 Oct 2024 10:09:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C604613B59B;
	Sun, 27 Oct 2024 10:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="B+zEzDT6"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2041.outbound.protection.outlook.com [40.107.243.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B4A78C9D
	for <kvm@vger.kernel.org>; Sun, 27 Oct 2024 10:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730023728; cv=fail; b=FG51TEFXMpxNTehOTL2GftfdCaQ9svgQvU/Gbxxw1vzH8Jt08y1GHNV92N4Ed2YRMpc04fZtFISqDwtQeKBNukImkw55hSOBjLPJU8CD6+fPHLZTHlMAtf3erdudJ4uzhkb2o0CzAHdytrzvXKlPuYindnW3qPRDWja3DW2tdxk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730023728; c=relaxed/simple;
	bh=FA06RX5dTr6PR1CdZngUAc2Qh39jk7rfkPoQpHfrec4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=elhTKBts/n9zJaiwL7sN3jvzWzKOo9GdGa+ihQsOd3Z2bDShR4qlgL0gcqKclPUOT3Ma8PULseu33E7tyfA4PokcinuNHBgAmQjQp5fXW4F6A5TDREg+M53aP6omBlHzKm2hvKCXn3gMkCHI2TCkZR2cxIiZXIBvhuZmolD8Fj4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=B+zEzDT6; arc=fail smtp.client-ip=40.107.243.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MvTlR/MIHCs4POWi07wd/d4VKVfah0rf5X0SdPmFTLRY5YgurWXdH5YtRDTxuCuo7FQ+rTCI9hCwHezbImvAGZROIftrL2R8MWLTfz3Zf+AGedO+uJhtzRProxmJY7jHQoLPBfHd9xDrpGz3PnT6JVfoE/mY50MrygNjPBUHEJb+vTunodZoX1B/LOjR91ywU4T7bHx1LjjrKG7WIbCVPhYDFbmcJCvsqupRepEJGV5OPW6QRoMKGZMNoHrKyHwUwASxZtskrW4L0WOEHyADu4DxekwfptPXbLaj7POJUCvoTEHsZYueeAOTg6uOXWbltoD2chgR6jfik6zuRo7AFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/Vo8wn7Egee49oMlo4DcNxn7WcPFtkU2J/snBXpTo38=;
 b=ps7pdEhEmk79zp4+GK8FN2g5mYmMFY/fbylxBztI36+UEse7Qqu4B9uiXfTOX1OdU/hcKjDBIAw4CVilA+DsE7iwBnpAKYQoG1Peu1g8947AL0dIQvzy1JHxGxcsyxceQ1nHiunrsbmbcElJKBUH8mHfkZbTr+hTo4kkxsuMdtoc5S3LbJ4+bjmR9+L4U7Cs9m4QZPzQ9Gji9rhLg+4HovuZuvN2FgY0WaTCaqEzDSbTEm09SxaoLIpG6bKpkeJ/Ve5BTcVuAvKOrywmWpnUP02XELoLbSUEkkn9Bifq142Uzr9uo9fJnWgWzroZH7tJsLUjG2J0MMh3sSoTsxU4aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Vo8wn7Egee49oMlo4DcNxn7WcPFtkU2J/snBXpTo38=;
 b=B+zEzDT6KecWp26U6+pcf4NhoI10jG0E+EIloQ4DJjlUzOMXNSbXoGcPSmBAhOU7tviY4ti7II1me9ANAy68zP0WBmSQdb4yU6EqtQBYt3qjrL1X12poeQVn2ea63rhp6kVpLvfuHTl8a88+G6B2Sf5iAMvkV+UiD2rZseaojKEXTeitJfzsP2wthSbjsM7U/91raWL39h6upIXjXVEgwN3nMZNA7KjBTuSrr5N7PDjbjvGXTcdLXSJi8u2JevTzrM/8y6QnQbaChnZzHA+hHnp8nqpn8LSn9N/BJsH5WNUh8yFpvx5jEGaouduQB+B2u59tQasHb5xI1QtC+v/UaQ==
Received: from SA9P223CA0022.NAMP223.PROD.OUTLOOK.COM (2603:10b6:806:26::27)
 by IA1PR12MB6282.namprd12.prod.outlook.com (2603:10b6:208:3e6::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.25; Sun, 27 Oct
 2024 10:08:42 +0000
Received: from SN1PEPF0002529E.namprd05.prod.outlook.com
 (2603:10b6:806:26:cafe::62) by SA9P223CA0022.outlook.office365.com
 (2603:10b6:806:26::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.21 via Frontend
 Transport; Sun, 27 Oct 2024 10:08:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SN1PEPF0002529E.mail.protection.outlook.com (10.167.242.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8093.14 via Frontend Transport; Sun, 27 Oct 2024 10:08:41 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 27 Oct
 2024 03:08:27 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 27 Oct
 2024 03:08:26 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.1544.4 via Frontend Transport; Sun, 27 Oct
 2024 03:08:23 -0700
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
	<maorg@nvidia.com>
Subject: [PATCH vfio 2/7] virtio: Extend the admin command to include the result size
Date: Sun, 27 Oct 2024 12:07:46 +0200
Message-ID: <20241027100751.219214-3-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20241027100751.219214-1-yishaih@nvidia.com>
References: <20241027100751.219214-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002529E:EE_|IA1PR12MB6282:EE_
X-MS-Office365-Filtering-Correlation-Id: 33fb674b-2033-4809-9dfe-08dcf66f55b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ix8lG98qw6u5LgaYjG76La8guDwGOx8cKGvjbM9//Gl7HeH5tETnzhIfMCm3?=
 =?us-ascii?Q?wALN5bre5S07uikEO8SBk/frDhGH7D5idZlQqN8YifD85h/8QrpT7xBZQL5y?=
 =?us-ascii?Q?bi2BlO+faVE77C2BViEhkMW+LY108Iou1hVyjoGHmULjIj1lDifEl0cruPN+?=
 =?us-ascii?Q?AsT93CnXuMdrQDKj7IDFeL02zJgVcobVRGQcrM0vEUfLBSJerfJYp5pm1um8?=
 =?us-ascii?Q?qCQGAi8IcGYoy7r/mjUIPonoKom+qyYrdh4f5/26UEecxjQ3Kk5sDWHKx1WI?=
 =?us-ascii?Q?mxhDxOr7t+H16fgFcP9UhBrrGWW0AJRPS17HKZHE7cegV5VYAvCk/+ksT/PK?=
 =?us-ascii?Q?/AyadeMaSZAPfHKn54H1rh831siVulDFOITiWKzAru7YTlr70O/J9Dso5lle?=
 =?us-ascii?Q?atVyYlqY3NgYO0ioad7pWZm7QgB5zu6Udn2fSN0P38fRC4Q28yXTWXUmwPGF?=
 =?us-ascii?Q?7HcIAfCxUxfife8oBP43BtKbjMiteB6za33DDZ8/sk1Q5zPEfPF251K27t9S?=
 =?us-ascii?Q?W2Lz+A2OcPkoTcH4FNO1lDeP9ol74trguuJqADKHCeAUXmz+YGzeq7PnzNAw?=
 =?us-ascii?Q?32y53Qjg6x+iqe2IesEkEsssP7kolNv86usUEKsLJWPA27ruT7lhyurSFgsn?=
 =?us-ascii?Q?vodGNK23JF8a1RpehcbGlFlwWqXHrq8DlLCrxFQZES45nfYFHTH+Mpt2eHiW?=
 =?us-ascii?Q?+TVpGJwrOmrqZhiqhPZUm6Q9ZRDKf+ya+5b6RGuYUZ7XTrR0uBB2U0uhzfwt?=
 =?us-ascii?Q?TDU6s8HXnryg6g9hdBtGeOLgvlgdINZDdrkZJN1+hWKc9Vb0FYoiJ6/Rb7qK?=
 =?us-ascii?Q?5k5LO5KvSjaSChlx06NzOW1ImalhKLVw2bfeyqRLAf1wsSy+/jjvM7FyhMC1?=
 =?us-ascii?Q?50TIAkhAysqZ8bz6AnT35RcPJs5gNBcu07PxJffGrfvOt6xV38/kPyqqTj+a?=
 =?us-ascii?Q?v3ccfBpUGFbUt8zw4GehB7aW+FoGncJTUcWp27ZvuIeE96gZYa5YNgVoL+4l?=
 =?us-ascii?Q?50WJukHpuuTXzKfglMS/0r+Sa4iRjNtPpmN42k/z+MPikGo387q+MVjw9BCR?=
 =?us-ascii?Q?QDZftUbotziRG73Bc9im/ZZwrOp4eP5c5MXQ1PQoVkoDYFExpqkxsRjNdHlO?=
 =?us-ascii?Q?JYv/7WqQMvxWV9CegLCZIU+kUDoSM1GNeKpHXImv9HGpABtW3mu6LVEDsaw5?=
 =?us-ascii?Q?N8MDg0H+vUqUQYd59jYC7V0ZH1Gx8qcolXSmPF7q6UEM8p85PDtwHdUZL07q?=
 =?us-ascii?Q?wUHKt6OQhEg46d0+2wYxyRfPL65a9nHEjbTMJsNXUrb3twOUVWsBBGTFH4f/?=
 =?us-ascii?Q?eQ+GBi/89jsI8O+fUvCy7hbc4TqM1IM1EiRnW6tVBR9HyUPOib94+vd79yo6?=
 =?us-ascii?Q?MtLWBMesSBGai9XmXFmxU6WVzJakoMhbAw34pRU0kIj//slKzQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2024 10:08:41.8195
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 33fb674b-2033-4809-9dfe-08dcf66f55b6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002529E.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6282

Extend the admin command by incorporating a result size field.

This allows higher layers to determine the actual result size from the
backend when this information is not included in the result_sg.

The additional information introduced here will be used in subsequent
patches of this series.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/virtio/virtio_pci_modern.c | 4 +++-
 include/linux/virtio.h             | 1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index 9193c30d640a..487d04610ecb 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -64,8 +64,10 @@ void vp_modern_avq_done(struct virtqueue *vq)
 	spin_lock_irqsave(&admin_vq->lock, flags);
 	do {
 		virtqueue_disable_cb(vq);
-		while ((cmd = virtqueue_get_buf(vq, &len)))
+		while ((cmd = virtqueue_get_buf(vq, &len))) {
+			cmd->result_sg_size = len;
 			complete(&cmd->completion);
+		}
 	} while (!virtqueue_enable_cb(vq));
 	spin_unlock_irqrestore(&admin_vq->lock, flags);
 }
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index 306137a15d07..b5f7a611715a 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -111,6 +111,7 @@ struct virtio_admin_cmd {
 	struct scatterlist *data_sg;
 	struct scatterlist *result_sg;
 	struct completion completion;
+	u32 result_sg_size;
 	int ret;
 };
 
-- 
2.27.0


