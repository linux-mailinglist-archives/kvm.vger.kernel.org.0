Return-Path: <kvm+bounces-33659-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 21CEC9EFDA7
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 21:51:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 51284188D049
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 20:51:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 516FA1B0F14;
	Thu, 12 Dec 2024 20:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="mvxPvr/b"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2060.outbound.protection.outlook.com [40.107.236.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A281917D6
	for <kvm@vger.kernel.org>; Thu, 12 Dec 2024 20:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734036667; cv=fail; b=YD4iSQuH0X5aAP5NARP8gy95G23vGC4yAYl1Z8QNZ3J+NAmfel+M4lmAfLczzPJkuMYf4vMSJ6IYnSa8BAmxP5sNY/lCNAtovC2aZD4QAg1Afoati8uuE1ulcqqt0oty67ps/Ra7caRYMBj3h2OqGuZOINXoRS26cO5C19mkVU8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734036667; c=relaxed/simple;
	bh=S5y3h7Xth/igR+yzour97KJxr+0kGnGO/Z26uSm+Y9c=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=RXZ5U3D7dnODdYx7WRsC71ntS+/Vh7+z7G+OyX9dcQxy/nvy/jcYkxsV9mL/8BXVJTaMdEMcSlKGuz+IHw9ctXbTVODpA0DVoQeysAwgRP4huKhj+NNDECFzY5ZVeuVmjM2PY1eW16Xy0WVHTAu/174Zcz4lKy8OA4WfUm9S2Vk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=mvxPvr/b; arc=fail smtp.client-ip=40.107.236.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zTza53URFa2551fPf3XlhqbumrADZhG8iBs73UjALcdSWDvDRqrleBdBFxlxWh43v/4O046tk/Ve0a18sHYJmhA0UYKDU7Rsct/3M4YiJ8uVCodf1I08x75aS3ORJlWkhYh3vCXwYHr3pYbBLdnFjopwgMMhlP/eLo1H56H14KpyVQhvk6TBCSzMsTCNKMDt//ZLle5I20u1mwv8GKh1umCQoVc37zdB+0Ex2OdhjNO12BOOSGctfqbm7Z3KP82h3AA47viaZCRnjXor8WyDIhVFPuaX3JeIfkWctNIekBTPbs7GCSIG8DLRMU7cSqW0HRwehMKBgSN97caO8OvL/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qtq/SYlUFbPDM/NMoKnQjKeup2NGg83meYOE7SHbmf4=;
 b=bd/hJzXk+NHnafY2EFOLb8N9hl2cIhfxfNnvbflybzZvde95FjElEn2vxev8mAq+BJYOq1Cs0pYlbR7ZONVBwjFNP9UqGlciy4BklFRgzh12m6EVV4vOuKqjHdPf8Wcyw19h/wJ8zr57eQFR4pgJhUxbdg3DIJEMHbmwqkVYBtfR/AawfMBdRyF4w+TuEI12tDCgg6wynXKh0j8hMDmP6M/thYnknkT4szrMHsLun/XcDj0FA736PGd+dDPAeP6vMBeBwqmjhak50jdeahwHPCs3q704Z/KBcqkaiVwUX1LrQpXD+ntjLoPrlMPyJt0Z6mbaZWkZ8BIloeJslQK6LQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qtq/SYlUFbPDM/NMoKnQjKeup2NGg83meYOE7SHbmf4=;
 b=mvxPvr/bzkdqPnMCzAIGjborH0lEKlCqj2IrCV3Ex1BvTeCxZ+x9BPVEfgIDdFe2Ky/GKuRU4ZlPIVytIiMl2NUa6dA0g7Vi4bg88YjibazYZ2N6Las4s2DJagCkhEsVGq/TCMfnrxtW8IxN/vU2RSzGU1WLS5zWieg/JHgJKTs=
Received: from BN9PR03CA0368.namprd03.prod.outlook.com (2603:10b6:408:f7::13)
 by CY8PR12MB8339.namprd12.prod.outlook.com (2603:10b6:930:7e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.17; Thu, 12 Dec
 2024 20:51:01 +0000
Received: from BN1PEPF00004682.namprd03.prod.outlook.com
 (2603:10b6:408:f7:cafe::fd) by BN9PR03CA0368.outlook.office365.com
 (2603:10b6:408:f7::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8251.14 via Frontend Transport; Thu,
 12 Dec 2024 20:51:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF00004682.mail.protection.outlook.com (10.167.243.88) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8251.15 via Frontend Transport; Thu, 12 Dec 2024 20:51:00 +0000
Received: from MKM-L10-YUNXIA9.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 12 Dec
 2024 14:50:59 -0600
From: Yunxiang Li <Yunxiang.Li@amd.com>
To: <kvm@vger.kernel.org>, <alex.williamson@redhat.com>
CC: <kevin.tian@intel.com>, <yishaih@nvidia.com>, <ankita@nvidia.com>,
	<jgg@ziepe.ca>, Yunxiang Li <Yunxiang.Li@amd.com>
Subject: [PATCH 1/3] vfio/pci: Remove shadow rom specific code paths
Date: Thu, 12 Dec 2024 15:50:48 -0500
Message-ID: <20241212205050.5737-1-Yunxiang.Li@amd.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00004682:EE_|CY8PR12MB8339:EE_
X-MS-Office365-Filtering-Correlation-Id: 27328764-81cd-4d21-c079-08dd1aeeaf6e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?d+b5EdBvaypOYXw+NALNehKpGSVuLNAcmALBhf/ep0zDnQzciUFTBl9Xfd2w?=
 =?us-ascii?Q?HX2QmmoxC76EZ8HLMJYX4PH888uByz7FLv2NlsaY8JW3SBp91KyZ7gkyC2el?=
 =?us-ascii?Q?BgVGYGDabHPRwE4xsTIggK759dEdt1Prs36iAAFj3eqwf+2nEC+VsZYfX7jl?=
 =?us-ascii?Q?p9N6VdLgYfCt+IAC0WVktO12yTGF/3DEOZ7ADWaiJFMFyBq3gBCbjnUfBl5s?=
 =?us-ascii?Q?HdBXhu5lx8vB1dK3RQEgOJlm2VcGpOEWmamY1f115jLOk1lzHgtSG8MRfCYi?=
 =?us-ascii?Q?WeyEf7K4AzPXtoiMwFLNBjO0hNLPTRWlo22HmPCy4HKDaoMfMcSbBp/cXPnJ?=
 =?us-ascii?Q?Pj07F0TGAtlaaFBzBBxbfaz7T+D3CewvrtskkQabPy476nLJ7Cf92U8Ha/0c?=
 =?us-ascii?Q?iqjemX7lsrzYQBFqAPcmfCUD4lR80TZwKXnARcR/m1e5V6ulpvYDij4/Enkz?=
 =?us-ascii?Q?MNCK9rMtjFdLh1Kv9D8pyYY9a5ThIBzo2YU5k8hmGYlxW8mcAGKxtEvtXhEg?=
 =?us-ascii?Q?pZO1e0Qq26SFvn0f6AL1I6QUVHKqZEgpYw0krAC/djs/qm45MzyVXOopwTyZ?=
 =?us-ascii?Q?j9CSkukqoyWeuYHKyn2G0gOfrMXJk4ecI59oez4td602sON2pKgmwA5++515?=
 =?us-ascii?Q?0r/N5Nx+YLlZ39ZepEC0eUJShwcsXwvjCmqml/I3QyVAP7EG4CdAhGP4Jdz1?=
 =?us-ascii?Q?lQZxZWG6qP/yA1pFfS7OKg0w1m6P4dU8iFcdHoIjyyvfokWdCgs/G1NFtiVx?=
 =?us-ascii?Q?YMZTFkvAvTTu2/WSTuH5JzXQFrLF6AIhShSIpuJDKPZoQYRTkSyTTOCCy1F5?=
 =?us-ascii?Q?rulyDYaShu+0UiNunuUZSDafAfsQ2h9F6J9XN63z5wvm+0Z9uk8olR3k4FtA?=
 =?us-ascii?Q?LelFTTPgFz0kFODrm1icsIa9w9GyMZnMnUfu5fqFYgCTyz5/2R/nQcnmmkMs?=
 =?us-ascii?Q?e8uuZ/A2sL9tIdz20cuYIqw3cESM3E181gaH4rtSiJWEzOvtkfYPWUgnSeMt?=
 =?us-ascii?Q?geadmcDCqD0ThOq9/LGRT8VTyC62wH5g5h8YngYLSVEWWuMhctm2Gp+Be1Q5?=
 =?us-ascii?Q?XJOiPdehPzPz9hwSlrLHqMHPWv3sgKd1qLfsBBmfIdSs1ulow8ljggJYlURO?=
 =?us-ascii?Q?p/IUgHFzrhf61jrizV50wZkwwrdANvAyPtyG5vmqwXigP9n01C3OFs/4BlH2?=
 =?us-ascii?Q?CwjFaGRbbcJ1djhx4Mhx+XXC4ZaWPwL+8k4lIHspEeCCm8vwPYnYDozC64Dj?=
 =?us-ascii?Q?G1Y8YH4m87p1N452S5uSLUrrQaGoXWoURxspzdq/+A/Hsz9Qhxz2PCro1VCM?=
 =?us-ascii?Q?9gS6iEoEoi3Lshrfy0Dax8Pu7rMg+MYNyqBthh6J7AIm7D9DOhBin9Y5p47G?=
 =?us-ascii?Q?A+/HCdyAJR8PPCd0moDYQVHCUfkGWl4FXUK3HHNlNIB1vh7bDiBhPmzGMjIr?=
 =?us-ascii?Q?0DDwyg+DMiv/G5tA8IKTmg37mISEBKwg?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2024 20:51:00.3663
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 27328764-81cd-4d21-c079-08dd1aeeaf6e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004682.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8339

After 0c0e0736acad, the shadow rom works the same as regular ROM BARs so
these code paths are no longer needed.

Signed-off-by: Yunxiang Li <Yunxiang.Li@amd.com>
---
 drivers/vfio/pci/vfio_pci_config.c |  8 ++------
 drivers/vfio/pci/vfio_pci_core.c   | 10 ++--------
 drivers/vfio/pci/vfio_pci_rdwr.c   |  3 ---
 3 files changed, 4 insertions(+), 17 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index ea2745c1ac5e6..e41c3a965663e 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -511,13 +511,9 @@ static void vfio_bar_fixup(struct vfio_pci_core_device *vdev)
 		mask = ~(pci_resource_len(pdev, PCI_ROM_RESOURCE) - 1);
 		mask |= PCI_ROM_ADDRESS_ENABLE;
 		*vbar &= cpu_to_le32((u32)mask);
-	} else if (pdev->resource[PCI_ROM_RESOURCE].flags &
-					IORESOURCE_ROM_SHADOW) {
-		mask = ~(0x20000 - 1);
-		mask |= PCI_ROM_ADDRESS_ENABLE;
-		*vbar &= cpu_to_le32((u32)mask);
-	} else
+	} else {
 		*vbar = 0;
+	}
 
 	vdev->bardirty = false;
 }
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 1ab58da9f38a6..b49dd9cdc072a 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1057,14 +1057,8 @@ static int vfio_pci_ioctl_get_region_info(struct vfio_pci_core_device *vdev,
 
 		/* Report the BAR size, not the ROM size */
 		info.size = pci_resource_len(pdev, info.index);
-		if (!info.size) {
-			/* Shadow ROMs appear as PCI option ROMs */
-			if (pdev->resource[PCI_ROM_RESOURCE].flags &
-			    IORESOURCE_ROM_SHADOW)
-				info.size = 0x20000;
-			else
-				break;
-		}
+		if (!info.size)
+			break;
 
 		/*
 		 * Is it really there?  Enable memory decode for implicit access
diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index 66b72c2892841..a1eeacad82120 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -244,9 +244,6 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 
 	if (pci_resource_start(pdev, bar))
 		end = pci_resource_len(pdev, bar);
-	else if (bar == PCI_ROM_RESOURCE &&
-		 pdev->resource[bar].flags & IORESOURCE_ROM_SHADOW)
-		end = 0x20000;
 	else
 		return -EINVAL;
 
-- 
2.47.0


