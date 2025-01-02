Return-Path: <kvm+bounces-34500-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 617699FFED6
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 19:51:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DA1407A12BA
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 18:50:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA5FE1A2543;
	Thu,  2 Jan 2025 18:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="GqqpaRyC"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2061.outbound.protection.outlook.com [40.107.92.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B767E782
	for <kvm@vger.kernel.org>; Thu,  2 Jan 2025 18:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735843846; cv=fail; b=oi0pHXlR28d+yaYN0E4o2H6Th1f8alJNahEtzQOyD2oIl6LZVTX0Vrt9sXv3V+JXrPv/bLY008/RHHgW2Pjgnlo9zeI5t7/e0nfgQkd/yXfbuG3Dq59pZEol1As4daQR5MYCeNl+V+uCKdvg47PTGbHjkLGdNv3Wk6AjBAJ+Snk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735843846; c=relaxed/simple;
	bh=YKa3bDuLq5zkuQwoLFN3Wpx7SOp92sMdKgao+M3h9GE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YxoaH/9iCXdAVlcJa7azDsWyOH7bYtTuSpgNVmRjoHPetyX97WlYpJVMvsxo3sbWYWjv837bnkVS1xl0jGnzPpr5JmeqDLKjUnOm+9p5f5Fp9hFwBpv5vCvndligVTN6Qcy+tYbFY9Jg61CdoiSVYwtZMmAZw1Xj18/ZefC3B0E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=GqqpaRyC; arc=fail smtp.client-ip=40.107.92.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rojVWQq5lv1UI3WxbzVn9ArZrht4MO8LjAjFuuRtsVoAwaaz97yC7B8U3Fk5JjYd1ijESpQ+J957iInvmGk8iyV2UsY+UeZt19SXLHR+rxQw67PMRZio/+DRdUmY6Oss/gOW4rMaPpFF3auPFi/dnMuLEKmVjna86pVyb5+DzXk3WEe6KmJRAxltCVng52htWi5Q2twM8smHVBc/oIA3yuP7iTgOiNrYsmLhqqUpAOUUUMMNuj+VDstoYvpDWhxausGZ+ioZA6oBbmHTpAvCDSHvUb9eC3IooA7vrzj62vf2424RQeKgc7zITnBxIcf1s4aq2Nrg3FdJJ9SpuWMlZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OI5Gi4vfghd1/gKmS7o2seByHc9t9Aq9T4p2Mjn/A0A=;
 b=SbWX/Es4+JRV0fHWyFgdcdyTTrid7OrsJ2yDOJsnXcVQW6vrphavYhwuLs9Ai/M8IGsYpFM0Ge7/sr0iRxthdSM2XzC9kZQX7Ai04NYe/mnvp2dOwbzFobGYvs6Do7XvE1qGYS3Nf5G30FD6EPdlxzF640QH5UYXoYsswJfCA8NoRegBgQnMVOBtRLowhWNIekzW7U6xggKxvD0PCXeEcoT/i9ewNxGzF9IOxC7q4LZgqXaFTBd7hMIi1N4KS0uOKQ4CGwQgEn+eaTIbNyg99quHyLNluRG0C0/FqvLOVw9yA5j+7OmMpWSoxXg0FPAEbNWdnId0W3SHYDpY17/Xfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OI5Gi4vfghd1/gKmS7o2seByHc9t9Aq9T4p2Mjn/A0A=;
 b=GqqpaRyC+CW1qlDYCLitlyXEtb5oTF4M7YH4UiIx619Cdo3i26VMbqpzNs+2aqWSUchCgkolX/arR7urCGRdeXRooXpURhvfzzx8Bt+eBSqXwjSaBI9lUieZtD5j8oCK49V7QK/piZ3a+iiH0/iJ2UV3TUJV3IPPfmHRG5NdjDc=
Received: from CH0PR03CA0316.namprd03.prod.outlook.com (2603:10b6:610:118::23)
 by SJ2PR12MB7917.namprd12.prod.outlook.com (2603:10b6:a03:4c7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.12; Thu, 2 Jan
 2025 18:50:36 +0000
Received: from CH2PEPF00000146.namprd02.prod.outlook.com
 (2603:10b6:610:118:cafe::69) by CH0PR03CA0316.outlook.office365.com
 (2603:10b6:610:118::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8314.13 via Frontend Transport; Thu,
 2 Jan 2025 18:50:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH2PEPF00000146.mail.protection.outlook.com (10.167.244.103) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8314.11 via Frontend Transport; Thu, 2 Jan 2025 18:50:35 +0000
Received: from MKM-L10-YUNXIA9.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 2 Jan
 2025 12:50:34 -0600
From: Yunxiang Li <Yunxiang.Li@amd.com>
To: <kvm@vger.kernel.org>, <alex.williamson@redhat.com>
CC: <kevin.tian@intel.com>, <yishaih@nvidia.com>, <ankita@nvidia.com>,
	<jgg@ziepe.ca>, Yunxiang Li <Yunxiang.Li@amd.com>
Subject: [PATCH v2 1/2] vfio/pci: Remove shadow ROM specific code paths
Date: Thu, 2 Jan 2025 13:50:12 -0500
Message-ID: <20250102185013.15082-2-Yunxiang.Li@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250102185013.15082-1-Yunxiang.Li@amd.com>
References: <20250102185013.15082-1-Yunxiang.Li@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF00000146:EE_|SJ2PR12MB7917:EE_
X-MS-Office365-Filtering-Correlation-Id: 1688b1df-d5cc-414b-fdef-08dd2b5e57e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4BsJG0SofEWa6VFDiTH8ohjSDBwMjeblZkqyF6cMQrz55b6ABdBM4PAFSB7A?=
 =?us-ascii?Q?XVqceU9aaGaP18WGdjRlbh4a5p0GAAiaVtglqLe4gxeaIBoGJnzHemRv87DG?=
 =?us-ascii?Q?sXjwf9UmfRMG5hNKfpBB/MrYCCVEO6cu6l1/G/FQ11wyTYgt1zT1knSjiw75?=
 =?us-ascii?Q?rsMt7bQucxO4hFQHAxMM+x3r1AoHgOrAL4b3Eixx6SnGcgVJKg7FtxgrVG0f?=
 =?us-ascii?Q?F2uiBU98g21RH0xE9DdWI9dlUvhj6qER38vvVUcubjnMXbVPXqUNRT6cEFOh?=
 =?us-ascii?Q?19BtJ/jZZNBKIICuHupK7EUaPJhcPPl6mbQc7OCpIuYUQ+wkARG3Lx1s5dJJ?=
 =?us-ascii?Q?qBpv7l/DXteaIzW0UOkcN6wV2PQX1GoiT3rwFP38IFxmk8jFTe2BSyEOGCie?=
 =?us-ascii?Q?SCVh5T/OVmbcCUXJ9CPCCUvW3N7m+I1LcER6lgt2+GSE07jywe3I5y6Ch+et?=
 =?us-ascii?Q?QHdmeGsUwuL9IC7U41GYxRGDtwef0fA3EjJkADaPs44688WYd3cSCHsgP8cB?=
 =?us-ascii?Q?Z2VnsWccpmVmQvWW8j00UQCjUh0jLhYYSc+ZkpW2QKoNyRxdzxNG7jLCdDGr?=
 =?us-ascii?Q?sgE5MeLnBwA3/M9w9gZWAOFQlmVTNFqWuw7NbQVIwBwpnc1vdWe6/iv8xBdY?=
 =?us-ascii?Q?xTTDtMITlYHtvqwmHWHnXOaYFx21XPWsGfzhlgWvzagCejxb5m7NDTn1AEJO?=
 =?us-ascii?Q?8BwLm0wCLJ073zIcpMfAuylEsY27fJOpQlRy3KL11pqEc+0xeKL5tbiKO2E8?=
 =?us-ascii?Q?5JzII2q6U8IgHgYD/fV3MKV/btcmraUHZYP3v7H4q9Le5pzY0vmIxys+xcbz?=
 =?us-ascii?Q?Fw9KpjgnHNYMDdutNpBZhnwTK3nSdbwYTond9GRNrE7r6cJMEkqulnwpSCor?=
 =?us-ascii?Q?3V6P+nbY+TOGJ/gXGVYn/ApQbs67aeYEobD+XnUmZjFoA+5miq+NRJmbgu2C?=
 =?us-ascii?Q?U4WfZQWp3Ceb8/xJnYBUjj6e4mdhsn/IHU3VAePBi28DtyZ53RyK5vlsCoev?=
 =?us-ascii?Q?AV0Jmu/ReNT44iyiIt4RBW/Cc+x1qX03ZcUcTlix52lvqNjO6vb+xoyaG9DM?=
 =?us-ascii?Q?rtshkkzxtu1cjSq13T7x/NFYnq4fmCHAuKmn6DtaOsVKGPnkRDKAFAQowBlF?=
 =?us-ascii?Q?cd3HWxXbCg+vqC8EDsjp2HNdqvENYmADgkCxqo793nGjTMCozUCanchnoSET?=
 =?us-ascii?Q?Gu3+4Gr11OX6r/WH23cy0b+WZJ/GZF3aWbwcBdpDFHp4i1bqGS9lgUr7/Qz1?=
 =?us-ascii?Q?gptgS73+9LGPMM2zepK29Xot10Kq8ZPMcFxHH4KFN72SDqe/x7LieeR1/LQ8?=
 =?us-ascii?Q?HU/ukXU8HmSDQJvL248gW/JPwlD8hnhDcnV2svw2Gpqmf8IigpDYN+WlqfEC?=
 =?us-ascii?Q?2406n0iDKfXxe2I2RUrdOqzbLt7sXtt86BzJ7vw11UAxUtKB9HrqfzXl/Eg4?=
 =?us-ascii?Q?gU8lMQ7UX6SrPgfwSj7JCPQrvbEm0GI8Ug/fTqipqnrLyBgyp3a7zkrcvvoQ?=
 =?us-ascii?Q?hj5QQo8CWuAp/IY=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2025 18:50:35.7413
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1688b1df-d5cc-414b-fdef-08dd2b5e57e9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000146.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7917

After commit 0c0e0736acad ("PCI: Set ROM shadow location in arch code,
not in PCI core"), the shadow ROM works the same as regular ROM BARs so
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


