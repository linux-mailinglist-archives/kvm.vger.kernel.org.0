Return-Path: <kvm+bounces-28697-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B60C99B8C2
	for <lists+kvm@lfdr.de>; Sun, 13 Oct 2024 09:52:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D04571F21B2C
	for <lists+kvm@lfdr.de>; Sun, 13 Oct 2024 07:52:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A516713A86A;
	Sun, 13 Oct 2024 07:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Minycx4A"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2085.outbound.protection.outlook.com [40.107.237.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BF4628FD;
	Sun, 13 Oct 2024 07:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728805964; cv=fail; b=UGL39siXKcbBQEOcQL1jNLTn/CW7B3cQPrfXQd5OwgQusINsncY5KCgaw9y/S/85cTsm2ebU8hCi2WngO+ZIym6AGjU9lBRb3UTkF5OPUQ7zSVZ8c/us3fk84iQZZpaAxOBHrBJFYdacxb2jroKOvDGUwMRYD8XRx+ue30jOHng=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728805964; c=relaxed/simple;
	bh=5WcdAzwFeMljvMFTEJIOSg7dgsZzcPCNMhBfqyTeMMc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=EPTUE5ZtKbNYFduyD//Ii5tyxnqB8iJOE81F9Ro4WcyqHTN3AlNGDUVmPbgBmzoKk00NKg7oq5ZiDv+wEEXHWiskeYa2IORH4k5F5uAzi/oQGD7hJ33KSN8l5C+hqGUT5p0ZSqH8dfby38TIgmoMY3wPuPy7dKXDaddAePNjyGI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Minycx4A; arc=fail smtp.client-ip=40.107.237.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Eze/ClyGaACnUKXTuQJXqYtKACwTcK8HJPx5VqZpQ6Im7il05MrZkhJZ6WcN+J6ZeOgN8fL0FChYvkyIV3u2V5XDlKZoyX4dqa9KgwNPJv5iAam25/Q+GAyzK4/tWxN+qVwPKpVfKFnSSocKZiGhZIHZxloj13sZ9IheM7GJZ3/4038/mJWIJmsTl9xx+1A/MZLNuVaydUkZhIWlEGjbOH3ZLFAtE0mPbru3VwhsjgKdChbgRPio8Z19u/kJoAXE8suzL8gJFxCrBx+GRP9hGLDBqC8PMUxbgPI3bf+Ew4rtuQXG2ZDm1ukE6Tykxpe2v84ha/BvF5uhdX81a/bRzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tL2tz/DmAHGn5CT9wHUysn+fOtKuURaDn3KZ0YtQ+IU=;
 b=kgGJDqAIMVL+B8K2bsBXfz2IZqwuiQk24sJtbRDW7uzkX4hbRx1s/i0URS1U5NKlieA7+mJvtz7F84/yZjljr8JDzaeIsgZYIPdovrYhKz+QCvHoEVPgiYbSMnAhVw8Bkmgm2qn4TySV3TvMzES9KwnJihbyZ7q8qKAtqih6mJF5phUQ3rxkRtRmwA8cx3qUuHPyWpT9UbG7MnuYaR/HvvdJ3XpQ4Q83DtEE2hB46JYYBZVtgMFGKwcGSHvL2prrqQ4OQThkhz91B4kY55XvEfeB+3bxTQ4nMshlSXF81vmELMz1NMTssQWiYEu0ziGojOPWS/c2z9C+Y5jeo1dLhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tL2tz/DmAHGn5CT9wHUysn+fOtKuURaDn3KZ0YtQ+IU=;
 b=Minycx4An0airT272+dGNcMyOaDRYu1UimPatluk/NmlBBLtuZZkXKh4ocmBF297+kjG/r0tK5geYw0YsrL1PE2x6dJbbg/rVCrYfZOdGtNUPKLQ4MHbMsapoMmXn3c00+XGx4HNjswW2DfbQ7uohHaGw+kQcTKg4Ao9eo6/gYs0Y5OSXszCGSE+HORoBo0BmS2uqeSgcWZj85uh6EonjOZKD/nVPb/wUhUqYI9Cg9Y+bZWAhPu11Q6sAXsQ98bJTL0VI7rNwqQx4zSirzr4mQTV+wcX6EK3ooIJVQoh3scs5BqDtMZTgmFWu6kb5oNos1mwMvVjDnHddJaup6f4Dw==
Received: from MW4PR03CA0280.namprd03.prod.outlook.com (2603:10b6:303:b5::15)
 by SA1PR12MB7200.namprd12.prod.outlook.com (2603:10b6:806:2bb::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.24; Sun, 13 Oct
 2024 07:52:38 +0000
Received: from SJ1PEPF00002324.namprd03.prod.outlook.com
 (2603:10b6:303:b5:cafe::52) by MW4PR03CA0280.outlook.office365.com
 (2603:10b6:303:b5::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.24 via Frontend
 Transport; Sun, 13 Oct 2024 07:52:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF00002324.mail.protection.outlook.com (10.167.242.87) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8048.13 via Frontend Transport; Sun, 13 Oct 2024 07:52:37 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 13 Oct
 2024 00:52:21 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 13 Oct
 2024 00:52:20 -0700
Received: from localhost.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Sun, 13 Oct 2024 00:52:19 -0700
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>,
	<yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
	<kevin.tian@intel.com>, <zhiw@nvidia.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<anuaggarwal@nvidia.com>, <mochs@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v1 1/1] vfio/nvgrace-gpu: Add a new GH200 SKU to the devid table
Date: Sun, 13 Oct 2024 07:52:16 +0000
Message-ID: <20241013075216.19229-1-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002324:EE_|SA1PR12MB7200:EE_
X-MS-Office365-Filtering-Correlation-Id: 96be4a37-fdc3-4be4-a7ea-08dceb5c0180
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lySbv3e1QyvSqk9ItYOxDuaamV6DDVb3m+TUbiaUXmdFBzzprRHpvyma4l86?=
 =?us-ascii?Q?BpLlVM1Esvr60Aq0C6xvL/SdzM3uvrVFdEm+YAWNRjEV+2MGjOBQr4LYaamT?=
 =?us-ascii?Q?PkfoBJ2hoMpUYYaggigStQdn7lw4+XSu0ydSW0gCotua6qPxQ265yDRxZa2X?=
 =?us-ascii?Q?uZ2Jih/s3KWYgcoP3MO2lAypHGjPwvZMY8kbEJihtoZ4gXdQUj7jQ0PV/Pqd?=
 =?us-ascii?Q?3XNUKmGuF82n492xjNtEgp4zk6FH90s3KX6t9fAI4gmE2B4xa5qROTYLRTY9?=
 =?us-ascii?Q?YsAU+GTXCDIAqTpaxmrvy/bsRWJ9Ec8CBmmflI45lyGYMn7y7ekshS6VuQku?=
 =?us-ascii?Q?kNjlf//jXhXVtTOyVnWzcT2hmD2G5dlVlPtr8ZPDn07yYIebBYpPFe4VxK8I?=
 =?us-ascii?Q?a3Q++c7ZZlwm+2/TNkqE19co3SNkHypo4XODVz3SBiN5n7wcu0fogcvMxvg+?=
 =?us-ascii?Q?mfEFxQPqJLR2BMsvxl9m5cihZgzOoTeitkm92/Vc78wZNfOusdzeY3zovlpn?=
 =?us-ascii?Q?2euPTw6QSlq9pqnJ8yX4oNQjTZmnKH4ijT4XwIcXBQEWL4Ts13VWxtpxku3x?=
 =?us-ascii?Q?Qa+XEYmrKgVO0EtERuK9wviVusTiWkH9IK0QQEO9A5Eg1Cr54FaXIdinEsFS?=
 =?us-ascii?Q?AZVYJvBA5YYXP34NBJHFyFvZELqwWRGJN3x8Iw4UnOKlI5+b0p+w0QSotr18?=
 =?us-ascii?Q?EJ4EfaYZxgF8rdLrbEQgLl7d6Wuez0jYNYtSv7W1MRbGDoPAUDpYxeDmJfJM?=
 =?us-ascii?Q?abYxQjtHujMcFg2iv3ezvfBClktOIdRE+JvpeLee/xOQeoegfxBhA/hiQM6F?=
 =?us-ascii?Q?VOJid4pIZHIWmnJwIb/k0Mi0lyAupaPOenTiWj39HLS3W5StedOoR6fQwIyb?=
 =?us-ascii?Q?JDyLudfECu0xR2Uzns9Lz15AeeJVkkLZzRSOCysUIB9g4Krx/oDt6IzwHzmA?=
 =?us-ascii?Q?eqBjmHQATkLxNckR0ZKQc3aDmalUcOvxp3mmj+WwDf6G+bbDU4BRj3UpExHg?=
 =?us-ascii?Q?t3Ec7Ax9hjTnyh/dyaBrTEm+jpJKKurYNB8oK9a8q4ks+DfjcU1Hg84C6ODc?=
 =?us-ascii?Q?cZIIT+zGvgPPKwfdQESColMIt4bdky1QITNrVLP5Qq2AJfikMMhXQPLlusDE?=
 =?us-ascii?Q?VkPAD4MJvG9WKoSLEsPU28k+PKrCqQTALubAP/LFVnrJ30QelPa4EQAwW6xt?=
 =?us-ascii?Q?5jWofLfGybwUgqlBQnHwdkCvTYnaAE+Ghr+n0IWAVYNAI+/b5l+TkXhkY0/e?=
 =?us-ascii?Q?yTlfjYLeHyeXEBWwODIMiKS8iY6k3JDVTrRJhmjgXGrrbfg5H80YOi9smGkd?=
 =?us-ascii?Q?YoXVjLRmlogVkC3vyX+xoli1qVMaJabhzdckNquu5iwHoGycjd3w3r/2RGGx?=
 =?us-ascii?Q?W8KqsmLIO/IuxI/n84bw/J9+gbg2?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2024 07:52:37.3245
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 96be4a37-fdc3-4be4-a7ea-08dceb5c0180
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002324.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7200

From: Ankit Agrawal <ankita@nvidia.com>

NVIDIA is planning to productize a new Grace Hopper superchip
SKU with device ID 0x2348.

Add the SKU devid to nvgrace_gpu_vfio_pci_table.

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index a7fd018aa548..a467085038f0 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -866,6 +866,8 @@ static const struct pci_device_id nvgrace_gpu_vfio_pci_table[] = {
 	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA, 0x2342) },
 	/* GH200 480GB */
 	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA, 0x2345) },
+	/* GH200 SKU */
+	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA, 0x2348) },
 	{}
 };
 
-- 
2.34.1


