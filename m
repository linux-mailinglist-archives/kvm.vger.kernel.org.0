Return-Path: <kvm+bounces-31415-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DA55E9C39E1
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 09:43:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9A971282435
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 08:43:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F99A17836B;
	Mon, 11 Nov 2024 08:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DJ4PIF91"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2055.outbound.protection.outlook.com [40.107.92.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAAE31714B2
	for <kvm@vger.kernel.org>; Mon, 11 Nov 2024 08:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731314580; cv=fail; b=bzea9A6ib7gGPzA1qqpMnUvY/07k6ILfWaLRdAqxNlkdAaGqZ5EulMrT9wynZPaw6NFR8zY7QySOUJVcygJovd18U9eXVviDlF5B8220F4KaVQhPmn444yUDrjEjCRZBywO4ffZFE6C54LDVvS5DGQeA7Qk7CbOGJkAxlpXgF2c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731314580; c=relaxed/simple;
	bh=E60yR9n+W84OfwsNUp7Ia+f9UsEC9YhP31DXQSszqEU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AoKwnNc2lb/zXHbIVbQWFQWHdBTVg645cjSevmTgO8G+PQZwEwY6ykkp6x7hOdcgFasWv8ZM+9xXPWE5TFW3ue6JW/1ak8EHG1q4kjg1BumJkJ9nHxtKgwYDH92PSWCIwSJTOrU/s76ghlU9Wos7l7Tje2LyVMcbPz6Yl73apdw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DJ4PIF91; arc=fail smtp.client-ip=40.107.92.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=slwrdRXY3+Uf2j3/DXSPabd2IkjW7WoIjeYZwD86a7n/BceSbdvQ6QUoKNOFI3AoV2O6jwp6Wrm8rzB/RB5e7e5Lwobfvj7VlAS2CKp/MzRJvlrNf3MugSXEI+h0ZOP9/swLBiHr/nLw4vEGR+7jKDim4JStXGZpGpK7KDQuJ0KTQTXJGU0rDs5qfWIRTrhtcOVWog7PDSMfu4yY6p9XMRir4gosEosK3QJsELZNST0ZZz4L13THBWXFLB1h8sGO8Nl08vkAFkBFMqn184VLJd8AsqnnJl3j7nKZGj7M5vOfpd3dBNekz165boykUIaEe5IZ0BMwxwJuwVHurY60Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zTMLxdx8o35fTyUbpLODHFggmpddmQFwmFYqLhdwaYQ=;
 b=KvbgH+bA97CMg6jeOvXYq33HHXJQf127xPdN+w1T2z59D+rghz3iSG5Vc7IMH6sLGoHsM55PatvfG758Y1XXpmk4M1dJ2iZJ3G5bMMKjrY7113vpvMqMPu/4yeibpFfePhTsBB1umktOdl3o32o+kh7IP8mKWM7PPZzzb1ZLB72oUz9XJ2BsS/6gd7GkfuO0xD/gkNtWtFdeQCFHW/0fsc+tIyzpcuzvDbnJ5K0Q1RzZ/vOq36ykNBRe+4VwUxnu2tNnbI06D6FS6w0K/v7mjgfzKwTFyH7onvQvMue8OnUP2gF8c0j3D2S0I2Jidi0EBNdGCoL1ccIetiZ8nw3CMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zTMLxdx8o35fTyUbpLODHFggmpddmQFwmFYqLhdwaYQ=;
 b=DJ4PIF91Qj7pZZ98a/GBEc0lmktopYIKDKDGWgMwVET9esd77AIxul9508Rz/plkRPCzQsqmNXgR+wWocg8sGTplUMo9SJNUMFiT+E2lC+Q98nqTdUgpEuG7GnAR70xZV+PoON7AIreuPvc4YlDxoPndQrp2AEzeCex3QtO1Q+O2VN9NViI8LHnXAnoxhNYN1Q8/qHEa0ledyZmqovOCs039Qr9I6W08jqFQtJN+22v4mPtJkCvCb1TBWZmco4z0BsgUWLWZsTt0SOUpz84PIw8l0kfhUOzSbFVWGb0g9LLYNJZQ7T4F5Yx3Nu7zYwJ3kmc+dmIyfKX6T+8UjRqLrg==
Received: from SJ0PR05CA0168.namprd05.prod.outlook.com (2603:10b6:a03:339::23)
 by CH3PR12MB9314.namprd12.prod.outlook.com (2603:10b6:610:1c5::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28; Mon, 11 Nov
 2024 08:42:54 +0000
Received: from MWH0EPF000971E2.namprd02.prod.outlook.com
 (2603:10b6:a03:339:cafe::16) by SJ0PR05CA0168.outlook.office365.com
 (2603:10b6:a03:339::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.11 via Frontend
 Transport; Mon, 11 Nov 2024 08:42:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MWH0EPF000971E2.mail.protection.outlook.com (10.167.243.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8158.14 via Frontend Transport; Mon, 11 Nov 2024 08:42:53 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 11 Nov
 2024 00:42:39 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 11 Nov
 2024 00:42:38 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.1544.4 via Frontend Transport; Mon, 11 Nov
 2024 00:42:35 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
	<maorg@nvidia.com>
Subject: [PATCH V2 vfio 2/7] virtio: Extend the admin command to include the result size
Date: Mon, 11 Nov 2024 10:41:52 +0200
Message-ID: <20241111084157.88044-3-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20241111084157.88044-1-yishaih@nvidia.com>
References: <20241111084157.88044-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E2:EE_|CH3PR12MB9314:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a3cb6cd-baf9-465b-5214-08dd022cd558
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OeTHmbLUUnYzuztsj7Ut/v7/Aa0ovnRYh6Y9Gv4RK4sCKyHU97wOvm1LWnRD?=
 =?us-ascii?Q?ReTcAcQtT8pAojy5nsmFWACwUduCv6QWpCBHMtxmYgpcP5uU8hojWcjjX9S0?=
 =?us-ascii?Q?88Cplk72FHfGviSd2fErw57uctmWtiebA6TfGoU7SjfQIdtBdss3Ip5jZf7s?=
 =?us-ascii?Q?WY5LXM3+OeaZl9JbO/YfXOgmAKu/CFHUWMENMhkEldOe/jteqKTbrYLJsE9Z?=
 =?us-ascii?Q?P/pqdhhQEb0aYJn6o6nPLnTQkYH+/bOzVs7PItk30+Hh+t2RXVMK5pbytYet?=
 =?us-ascii?Q?o4JjFS1jytHYjfqGCV6xDjc8T0G3YA+uqqpaaKfDxaP8vRWZTwdTxCQMKyUo?=
 =?us-ascii?Q?H6PTR+hNJsIwl1XDgjx615aLHhPGXK0IdomdLCcD+wa5uTZ34AQOJhL6oq7c?=
 =?us-ascii?Q?QM/Uw1/EhLir1UkWnwiSFXRh2vqt0OZNU3HUc+7RAo9wp1Tpwi+Dwvnz+2W8?=
 =?us-ascii?Q?fSH2ZBnmumLFaarRIYkN8tJXzynssRnzuPLbAKdPsvs8xPIvmBcozuTwBk7b?=
 =?us-ascii?Q?Vsutu0vMRow7tjWJDy7Oo8z3hJhg4JdD/gECv0geIIrF9+MeNo2fZlRG/mdj?=
 =?us-ascii?Q?NrLB10aNDacMuk4W/FSuwLZHxlJOV4DUsyTuHnxD6NydmE9afOZ7N7ZGjzAy?=
 =?us-ascii?Q?bybIC3ZkMZEkp3+O3g2XZJuBJjxjRwHDV9rkZ1SZhH6dlX+eyYdAuIIJNHvE?=
 =?us-ascii?Q?d7OohJpgDVJVcYD+50MqckPgngl7L7LPIC7ClBdDikjWeImva1iJJeW2iGHE?=
 =?us-ascii?Q?Bxery0odSTFBgVbAPLv1Fsh4s6Zujr1giIF6p8SEp1bhRZDPgg710SdiOLyi?=
 =?us-ascii?Q?ySc5UpcQipiTD4JZ5fn+fnrwI2gTazlQQY1jjkd3rllE0qjefe6RdseBswIC?=
 =?us-ascii?Q?z62MrJSzbYkMMsu1Y6XAHu7tGLyiijkg9Op9QJT9XGqtv74hw7z/+ye9cwOj?=
 =?us-ascii?Q?886FR861ahktJqiOeQBrPs7nIqXeiLlxC82fllZd8LrUUNv4s4tN8l94avQm?=
 =?us-ascii?Q?bzPLwRaDtgu0nvB89oREsmiSBuq2FaZ2FS/DKx0TtMDgiy0Rk/PeYS0sAsMM?=
 =?us-ascii?Q?F80jqoczeXM2JREas47DIkZ61WiWk82ZfxXI+jJBQON15+Ei9yd/Vh177n/3?=
 =?us-ascii?Q?GFVOpGEFw3oHPREs7MSNsOxkNqXaZOVOMcLiiV0ZERBEiO4lReP2pYjF7w36?=
 =?us-ascii?Q?kvLhsRDvXRTcUWxrg5Un0UUuwOlJ/FWy+IDr9hHnB885PMZ1pX8HrCzgEKu+?=
 =?us-ascii?Q?HmEj76UHCDm5QHKhxwbfzlz8xe6mMmgMnTp9tWxFWXV+SQPQgYkEqv0B/Gg8?=
 =?us-ascii?Q?c/1/siu+wgfs+oBrxo43MMvC92sjxpew1s7dCskjaS9Jk9E5A4qHSCju5m7b?=
 =?us-ascii?Q?LwZcZQz57j0LdeyOWAZXekHP9TnhxlYlwvmylkTdPaxBcoV+CQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2024 08:42:53.6067
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a3cb6cd-baf9-465b-5214-08dd022cd558
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E2.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9314

Extend the admin command by incorporating a result size field.

This allows higher layers to determine the actual result size from the
backend when this information is not included in the result_sg.

The additional information introduced here will be used in subsequent
patches of this series.

Acked-by: Michael S. Tsirkin <mst@redhat.com>
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


