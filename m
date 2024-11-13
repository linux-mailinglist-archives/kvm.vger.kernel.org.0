Return-Path: <kvm+bounces-31729-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B008B9C6E4D
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 12:55:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4C57F1F21272
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 11:55:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8D1E202630;
	Wed, 13 Nov 2024 11:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RKJVnf0B"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2088.outbound.protection.outlook.com [40.107.92.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B9682022EF
	for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 11:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731498786; cv=fail; b=FCLAtdPHPZdORjKiLfyfozsUpN0ge938Y4m9E5alprAH2T/vr2fJaZaoPbzWZa6dN0OsfltR6RnJi59gp4Xp7MyDzqgErdmwTPPRpv4GA2LeWhCnwVTz5fShxze8G7NjmQmwiIoFj8QvsXZl16POuuKkZ3BAgQeVIrIdZ5v9k0o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731498786; c=relaxed/simple;
	bh=E60yR9n+W84OfwsNUp7Ia+f9UsEC9YhP31DXQSszqEU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P6LennE6pfiRjP4enDuGXl4ddZPm2KpU00ffnJWdzEVMroK1Mveuho2qGwoshYXIcmYdrkqkO4oSHNNCLTVhGIa1VvtS1iFxotxblqlys2X/jUgFVV9AEtJI8l7h9FRKejJ+iplYtJ3dJ9PhzidAQnt0r8nqWn9SFdGbQqfmMbQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RKJVnf0B; arc=fail smtp.client-ip=40.107.92.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y7sdfo2Ke0BuzlZmt2CXijrvbiz24T/XQcepFLICfJuBkaHtOdF8j8SxBTxI53KCJdrPgY54XhFEg1n5tZCXTLb5VzCSKWxZqL9pw7gNC6aHU8yovTAFawQD0j0Ckk3cAsHUxx1nu4kPxfq4Z7zr56lsWEHqRrwEzRaw5Hh817IjnG+ALHnD9C9ktVVb1MRrWEj9ka20oMcVDaxWiTSLPxM1QZnbai1fyIZpVeY+GIO5PriEe9b/LcmkkVWBQ2LchDYyolIz2Hz+or5gAdWVlU5yDpxNQkoWLW73F0Njm0o69tdfqJHZvM5X9IZnFTuPiPUVHf0xOcsV4iRURFyz9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zTMLxdx8o35fTyUbpLODHFggmpddmQFwmFYqLhdwaYQ=;
 b=cY9buZLW4MFayn9JoAp97ighGsMefU1LxTASAXXcYr7FDgRDLhmkhoy+w3ES3UkPOWWCWUicaQgd3l4y2FePcV1HMo+tAs9Ady24BlfdELIXzwXlwHxmSWVtmmILHagkriGutUxptE/nS5fF0siQq/mjr/xsGHFK+0mEj5VsPZEhSv2z0bljJPTf+i7c9gUOQopy7iFhB/M3aCT2JTvqAVWL423OJLrjH3FrP+N3rgPL5EmeKHcSvZLbUXQYnt6yCWcKPxPEQCJugjUDIZ9jom9SYoR19JlINm59cJTr9/MugwBctqRmS/iKmcZV3t3YF250v4LuqimXmIhfEVnDxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zTMLxdx8o35fTyUbpLODHFggmpddmQFwmFYqLhdwaYQ=;
 b=RKJVnf0Bez7h+J+ynI2BaOjZoC8kehRvU6+Co10r3hBP3lrcT6ML4GwQIIY4bJWtg8rfJPhudgSUthexqURVnAMD6GOkkJMwazHBB4gUuRP+nvq6nB3+3acXvV3/qwv4Rqa3vxRqwGDuMrWjzg1tYFYvToGhnDZko7tzA45rNcESUCa8hOfD3RU0p7FTOIhoWGoG4MnTCqAuPTLFiUAWrl+VF4g+I1hY71EmPCIlER4w/Ri4VKvDEt00tbBeds7OwpO794GR2cQIEZ0Ypx6RX4ygggt+WNyGiT8H9A65ublarpmTW4itBNXsT98pWWudPEX9Xm1Zy7O//x62qYYCNw==
Received: from PH7PR17CA0054.namprd17.prod.outlook.com (2603:10b6:510:325::18)
 by LV3PR12MB9214.namprd12.prod.outlook.com (2603:10b6:408:1a4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.17; Wed, 13 Nov
 2024 11:53:00 +0000
Received: from SA2PEPF000015C8.namprd03.prod.outlook.com
 (2603:10b6:510:325:cafe::25) by PH7PR17CA0054.outlook.office365.com
 (2603:10b6:510:325::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.29 via Frontend
 Transport; Wed, 13 Nov 2024 11:52:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SA2PEPF000015C8.mail.protection.outlook.com (10.167.241.198) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8158.14 via Frontend Transport; Wed, 13 Nov 2024 11:52:59 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 13 Nov
 2024 03:52:47 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 13 Nov
 2024 03:52:47 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.1544.4 via Frontend Transport; Wed, 13 Nov
 2024 03:52:43 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
	<maorg@nvidia.com>
Subject: [PATCH V4 vfio 2/7] virtio: Extend the admin command to include the result size
Date: Wed, 13 Nov 2024 13:51:55 +0200
Message-ID: <20241113115200.209269-3-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20241113115200.209269-1-yishaih@nvidia.com>
References: <20241113115200.209269-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF000015C8:EE_|LV3PR12MB9214:EE_
X-MS-Office365-Filtering-Correlation-Id: 2aa91506-0d1a-473a-c059-08dd03d9b8be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yR+kwzsUGdChPOFEAXAC8dHMnfvdYx6cQfgjtZrN3YxRaCGbvVJSEO+0HHWZ?=
 =?us-ascii?Q?qmtNSNVvsHWUAlAJB98aJ36H01jFeoOQwZpRObK+FYoy7581mgy7pWUxt+OO?=
 =?us-ascii?Q?1UGCjwxNDlR08Osx/dqJJksGcuRGaDU1EKajo6+cN3J26K+h+9/eYVUy52Sh?=
 =?us-ascii?Q?o/ZVr7VJc/ifqErkPtmru1SBanYs4p8HpEC/29bALaPHCHHeVUzIQMZyCDxY?=
 =?us-ascii?Q?UxwyMY7saaO+aBN/aJKkJ5vlED4yN1Z9KDjGEuZVoW7UHVH0lgRymfaO5HPk?=
 =?us-ascii?Q?cknnMLQV7NhxYXY5pyzCAaKr5+WY8PQamtCg62E1hSEVe/vOI/hnC+bliU8M?=
 =?us-ascii?Q?hhtpF6R8XWASkhWBjBqJ8ObKQ5h1WSPs8QntH+BIRapHfbW9taSTpWtyGN5n?=
 =?us-ascii?Q?MiCOjrAhQ0Vm09P1YevGrX3jwbGo59b09c1OvoRkp11QiBu8aTPuuGT9s1WT?=
 =?us-ascii?Q?1VvPDyiY5r9yUXOtS3wtJQfo98LDI1ClRudOFUAH4OwXoeRy0hZs3XjHOos8?=
 =?us-ascii?Q?A713hXjAOW7SP8nIEQV7pyXOCxmQnC9OIGdTntAd8NMiIEZOkSCXsdWJYGmG?=
 =?us-ascii?Q?COJc3H6pRIfEgjn9nloCMQc2N8Lzl9gOYmOc7mo80r6rWaWmgvOlgB9ErGTc?=
 =?us-ascii?Q?OqZYKB221tLo8C9caqg8rY85mw8976eB5yyPaErrwiD7VmPd74iICaVDc8TN?=
 =?us-ascii?Q?ApptU1qOdX/sz8K1qZI17OM0wjhPCYvRIUg433UAoPObtwY8L5vpX9Byj5HN?=
 =?us-ascii?Q?pG2QthisI/L7qxoQDYqyP42MZujIaCF127C6ORKXdPMOxoeB5z8eshPzJ1nq?=
 =?us-ascii?Q?iWV/2UmTLHyZJ1dbN3RBTVxl+ERTXlxZ7+endrNpbGoCr0olp//UVlJgYThE?=
 =?us-ascii?Q?HK5pF01bKqWbzJG7O1/RvqPe2WYvtjBr7rLZmruPzD8oexFgP5lcmnMsTpAF?=
 =?us-ascii?Q?fTCDbUQUnB26cV1D7ODGlJE/imnalQPOXaRFgc0JbzbbQbxUbaqMbSa6WeKg?=
 =?us-ascii?Q?6Kw1JGyue9TKqgJnQYwHr2O1FENoqyLCE4bqDnAHTUW32vvN5CLa8OdgdSri?=
 =?us-ascii?Q?3NkJ4s9vfilizM88yyMngskbIaXaRld4jliy4xtSMqjcfMtxm4SzQbsGidX4?=
 =?us-ascii?Q?G43Shx6Fk71y9sj41368A+9LeFDdPeiHc1mvnopO2SLM7AfFqb+bxTQsEUJE?=
 =?us-ascii?Q?Xb8c13rXn3U/t1l8m0+eVUGCG1rAe7WClBonl84a+jLOCoGy+Sls23kza0f9?=
 =?us-ascii?Q?7EHd8IhRcQ2+2T9gh3TaHogmgZbLG+wWQFL/pWMot3bzXaDt8BXjIvfSRpaj?=
 =?us-ascii?Q?weNBW+/uZqqppYoNqlqloXWvhDT//oXTav+zEVXVhTACWD6BA1GWemkgRB1c?=
 =?us-ascii?Q?WZIhWYjVtqr4UkwRxrwKX3Bh4vPhYy3plMPnanZmCV3d75p+2g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2024 11:52:59.7367
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2aa91506-0d1a-473a-c059-08dd03d9b8be
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF000015C8.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9214

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


