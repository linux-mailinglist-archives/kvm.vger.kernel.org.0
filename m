Return-Path: <kvm+bounces-31592-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 690D69C50F5
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 09:42:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E9A011F21A69
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 08:42:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C101120CCFF;
	Tue, 12 Nov 2024 08:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Aov5opm9"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2082.outbound.protection.outlook.com [40.107.237.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4906020CCDD
	for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 08:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731400727; cv=fail; b=PhtRvDbN0EHCMI6Yn2dQU3gTkU32WNx7uK9vKU9HFHmD2aUcQv3G/fn7PbpBvsPNssxu2m37XA0M8TNPouqVOwMIO4nTbbl4P3lrUZquLCmDtUsE21+jwVvFqu2dkOY57TPL2beSATZ/mNZ7PCOkR+P9esarMTD3NQUBOeLN1HE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731400727; c=relaxed/simple;
	bh=E60yR9n+W84OfwsNUp7Ia+f9UsEC9YhP31DXQSszqEU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OFBv8UVR2YM0Qb4QcqHtLz40t+TYe5ET0yjpuYLs80oXHtn29OK8D5iv+9THN9tP+jhh598iz6XrK17HehOV6/rDgfxF8ilqkYIsjgTW+gLolJ7GrWNlAfru8uWPK1jQ+Ysu4QEuG/iSocbxSDryvpCEd5rmJw/IYXP5ybgnsXY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Aov5opm9; arc=fail smtp.client-ip=40.107.237.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VIHyaGTaXL4mUtnVhfXv/oZ5NNK7XJ/ffeU+BYi4K7Nvt5BvGWsXHDZ9Pi7WmuPAZzSM3WLLKxExECD9/p6+Vh7+SYdg9mCvjXBa8x7+eB/r1sGN7CPBNfo4Xv00deXdpRHA4f+tmschdS0wi0+v79QBgpJMaX4Hf4I22JDemltwmruTdFvNHBsFCRMWqvaWeJFhkFhong1mp+lLIrD/thYJuWJJ81y4b5ESMSYdIXE60JKypJi3136QVCqomE5jQu6yd7ypsn9Ova4ptEXDCpZKnbC2raTFH70ZqEvPHtZfRdcY03QJwnYfw1T83ZryUUaKOF+dde1aHpBYnl122A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zTMLxdx8o35fTyUbpLODHFggmpddmQFwmFYqLhdwaYQ=;
 b=fCvVdJHvj5fvNKXl7eTqCS+WQ+F91/l1UZ22QKcPM5AQbfvAlygNElypKqaiQNk8gZIWZlniw1/QUDW1ZmPqBbhUiuMEOBY8fQiNQm2rd3A8lhGMq9rhgu1N2h9LNqSYUpwWZk4IIRjPGUYp8z16Diq1iAWW8S5ngAeUx03NwlWrHi8gl2eY4X8Mt2IjcGjeZ9hJjnGdPvzL4Ajb/Qa2t9Ng+TX+S/84p3fpOtus+RCkF9KY1idDhZ86EMsgNf6HxffGqZ8dthT/udLmnsISQod5xhBm6OhTNNUEdPQgvWEpg4tRtIaVJFEHvFvEAtNkjV+02FF58+mGQ5HG3RMWgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zTMLxdx8o35fTyUbpLODHFggmpddmQFwmFYqLhdwaYQ=;
 b=Aov5opm9Z2CQPGXXNyH0AmK7CgCiiBpjW2sH6fV6RmLrbu5ki1MJA5ZxrfOxv0mGcYFBzbYC2Zy47kQ6xPoC14yf7KAmnv+DzmzczJyvPTOj3HvItUj3CxaTlkG/PTDysYLfhqIFGZsigRSvXu+AaWzDY2GNetEnkq5GzVp3oF7F0RtqqiuVZCxrUGFezGbR0B6syEhGT7TrDG09SRaVabHq/jRXAYGxJdp7rhQLurcKxnxeBIpTNqCrzPezfE3GZJNKzKkVzgMfWj+V0kictHfX24abF7WU4RKuxJx/3OI1Cy8J+PguWDUfmqJWnpLPpMdxKJSuUJOvNYa6PPuIug==
Received: from BN9PR03CA0774.namprd03.prod.outlook.com (2603:10b6:408:13a::29)
 by DM4PR12MB7574.namprd12.prod.outlook.com (2603:10b6:8:10e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28; Tue, 12 Nov
 2024 08:38:42 +0000
Received: from MN1PEPF0000F0E3.namprd04.prod.outlook.com
 (2603:10b6:408:13a:cafe::33) by BN9PR03CA0774.outlook.office365.com
 (2603:10b6:408:13a::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.16 via Frontend
 Transport; Tue, 12 Nov 2024 08:38:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 MN1PEPF0000F0E3.mail.protection.outlook.com (10.167.242.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8158.14 via Frontend Transport; Tue, 12 Nov 2024 08:38:41 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 12 Nov
 2024 00:38:25 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 12 Nov
 2024 00:38:24 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.1544.4 via Frontend Transport; Tue, 12 Nov
 2024 00:38:21 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
	<maorg@nvidia.com>
Subject: [PATCH V3 vfio 2/7] virtio: Extend the admin command to include the result size
Date: Tue, 12 Nov 2024 10:37:24 +0200
Message-ID: <20241112083729.145005-3-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20241112083729.145005-1-yishaih@nvidia.com>
References: <20241112083729.145005-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E3:EE_|DM4PR12MB7574:EE_
X-MS-Office365-Filtering-Correlation-Id: 84a64bb1-507a-4f57-778a-08dd02f5697a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GjSqTqGNCVT2a2H2LZrjy2WG+rIGMyDFV2g6zH3aDlb8ee4jhfz+/nYJrl3s?=
 =?us-ascii?Q?HErKT5qiLhHlo0dlu8+XYcJL+JUPwa9wVvCxmA8QH8ICHwgHOotWJkSh6g1Q?=
 =?us-ascii?Q?sX3NyyZ9P2bEaO0tVYOKx9sRXUnjr8cmRuEonLkWyp/IiFpzBvRbLpzY+ZmX?=
 =?us-ascii?Q?ck/sjoEJYSiH3xC7VSm7DN5sDSuQGuTSHTyU6P5/NrDCQu2VhgjE+Yk3cLy3?=
 =?us-ascii?Q?jwX5X9zToHpKBeqrUHjzYnwE9G2NwGqKnJbbfOIi8nXZ62LXuHIPvQh+8oXX?=
 =?us-ascii?Q?7Ac2FWZB5tfH7G0pdjEytZJwmxg4Rw6j4nWY90eFceAuOlA5zAt3XcPVslXS?=
 =?us-ascii?Q?w8iDtdLEEKLQr1CzaiJvmb870fDWjgjLL0cKNCJVUDbHMH6EkIm5tff/vQyX?=
 =?us-ascii?Q?aenG5AYyxh9Z2NqdMlNFgZ4LVkVjUU+B8RMkg276Y4lChdG5WBsWkLVkT4CS?=
 =?us-ascii?Q?5Sl7Ae2I298k9JOwxTATos/tWURdPnp2ZecN0uPoevYR7JQ3ua0iOacDEwSf?=
 =?us-ascii?Q?b2Qf+RFBOABb17/6qLGGoUs1sxmMxGCmcfVmskGPasYQrYWklIgq8v0VmJ19?=
 =?us-ascii?Q?4AS8elwTgI4pKGrAyVmf9DSgd8gAdB7qXrBGy4D5aZZleo5ElCunKqPeEWV4?=
 =?us-ascii?Q?3t3B6GtjLyqERZabP5A235YTFbrTbezr0yZ158nHwksipHhJtjigaCs14fWJ?=
 =?us-ascii?Q?4Zf//rvK+PKzgnlruwzv5aX6RLssDNiR9cO368ZwnVpCaitGrvmgsYC5Tzot?=
 =?us-ascii?Q?sASPIVDOM/3ZeI2fhpue4JemydwUcBY3QT0yubAuU5Puiq1afKRyLa9h8jiU?=
 =?us-ascii?Q?xT5Yf9bqOM92zqFTHsp/s9BL88Yx+9vJaHGEN7ZfoN8KquXUXaXlqRzgHvOJ?=
 =?us-ascii?Q?jl1NGLCmFDSzJ94v5/bLNXjHOfyTsjhwjsSdbcGH777YLM13+LLTS/b4y7QK?=
 =?us-ascii?Q?xers6bZOxx18jqZN+U13hTJasFFgZR6jmy6UDL1mzrQWNI7FmgflOZO1qt4v?=
 =?us-ascii?Q?aKZTHGGlVwRoA/T994aDtz17OCRU8wSshL/Vddmr7HWZtChaKMSz8NIc9M5P?=
 =?us-ascii?Q?Ok1FPFN1mOoxCJM2Zsf+1iNS/4ZxY/uq5c0EFWwumspTP7kjCTGLIXb02p49?=
 =?us-ascii?Q?+qpeHisK7gnVku0jdy6G86jrWhv1CgTspIM20/pI8t3lxKOXwCqDbSpMubsU?=
 =?us-ascii?Q?hN95NkoVSmAx/Ztp6cccIPIfHZQ0ZIwBFdXhFUI5tBErVlcamjT8hY/7sXw8?=
 =?us-ascii?Q?9n4NTXNARMIyVz4Ie/EwOoubclzWJ9PDxoBcYRv2c89rSoq81LDeOtlAyWj5?=
 =?us-ascii?Q?PfzSWAL3PDDpXlS1WBlpHACrKatBuRbfqBKIbpXZY2jw2oAJ8fPA9/te+Ffo?=
 =?us-ascii?Q?A3Stp6ZjntDVQadZR7etn/OPkTYjdogsJsBQ9aUeh3i5L78OaA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2024 08:38:41.4167
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 84a64bb1-507a-4f57-778a-08dd02f5697a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E3.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7574

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


