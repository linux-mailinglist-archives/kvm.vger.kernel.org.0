Return-Path: <kvm+bounces-34501-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A5B69FFED7
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 19:51:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2DDEE18836E9
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 18:51:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB29E1B4120;
	Thu,  2 Jan 2025 18:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="slU6Hq8m"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2057.outbound.protection.outlook.com [40.107.244.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B38314F9F7
	for <kvm@vger.kernel.org>; Thu,  2 Jan 2025 18:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735843847; cv=fail; b=YdoDHkrLFwyXSYmzjpXvFCCWn/OANUmTWH7pF/myWBdwn+5WqTnfuyoWtktLJvCF4V5jGvbGrfdOcFIZWh2kxz23ERa13DsudukuYHbGYinpBlw+i9CaZg3GHNHexYveHaNzjbScyjRle+GckeM/vsdtxLHf9qXabmKuMowT8WY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735843847; c=relaxed/simple;
	bh=QNFvJsPrc5/qnwUWBf3fT/1MQ9orq4MoLLcWiraByiA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Vg8yuzfgmCPT1ofAAiT66MV/2QrkCPvmJZvVqnSeP/pJgxqW96i4jUjGE955EpVI6+OMBkFHhUkwPhRPLHItcvLTbhwZWsvpA5bb9nCS8bEXN7vXn5L3S1IYFyitJtEBR68ChPWfyegcC6mmdkatOQ7bLeBVqGHuoryAFCIt958=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=slU6Hq8m; arc=fail smtp.client-ip=40.107.244.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n6oNdYsxQFheyVXpi9pCcWtLZ0jTetiSKyCWkLeNsuttJrH4QfQitJV7RxYsjUvfywtQhMLwr1c/HkrOird6Mr4M0uGqxtM+rYGhNMKQvOQ6tS9PTha3U1EdCUAjF8dZPiOHCwGe2Az3nAnWMyj8wQ015Tleq6Qkqs4KQo4M+R4J4zrCuTAfJYJz70glQlBJce3dQ1QdXXCYCRIXdKDY+iDoPPrznwlhqfzTePKWkn3WpKq/xzbMDKJv4fFfERhf+kdLlfQ/UgGJ2+/2Nn8KS4VQ7CFIE6MA89q01qgbZxfK6HEimgxcnUQkm9X3bxW8BO4w8i5Sg0F9UukSIDUnKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SqklaIDthcJZN/22AR9WdB4gqzltUvuNoOkGrhewfzU=;
 b=SPuZElOOKbwrFhv96SdFftVAv19S4jfzpNu3KAAeNouFsOv5ZuvQIaWz/vBgYSZ0C4m6PMFsYm/PSWFu11YC9tLUyLX69zmz7cxHAEceMcy2G8jhhK+MXOaH1EWQlUfGflaEi6BXwq2Urz/QfE3KsPntiLYqw+0xE4wLGWw4xqD6tghBqAJlWL60U3zPwqcVJGo6QuHPEka2empVeM/HceNns/to7KBPtsHOohKJ694kBjLq8H0cFFf/vpDbDGcp9B7nH8ggTuTsSPI6ZDsbOWrGFsY4JXGtMjkq6IB4XN1/XmqF1EuqP9wftpS8hTwzA7Gw8/KsO24KZQbOi0nCKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SqklaIDthcJZN/22AR9WdB4gqzltUvuNoOkGrhewfzU=;
 b=slU6Hq8mck9I1wxvlmTmDNTJQ21AC3l2VKD0oqzgH/BtqV0XZgtyUSJWMeWtVWo7ruSU0WBS7Tgop0sXgHNHOfk+BCRqn6PVXUSolmSxv8dxMODIwCHymip4lZOwdTtEBoYfuS5TVFavLK/NVL4pCt8TgrgcwX9Af6V/X4DFaQQ=
Received: from CH0PR03CA0315.namprd03.prod.outlook.com (2603:10b6:610:118::15)
 by LV2PR12MB5871.namprd12.prod.outlook.com (2603:10b6:408:174::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8293.20; Thu, 2 Jan
 2025 18:50:37 +0000
Received: from CH2PEPF00000146.namprd02.prod.outlook.com
 (2603:10b6:610:118:cafe::81) by CH0PR03CA0315.outlook.office365.com
 (2603:10b6:610:118::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8314.13 via Frontend Transport; Thu,
 2 Jan 2025 18:50:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH2PEPF00000146.mail.protection.outlook.com (10.167.244.103) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8314.11 via Frontend Transport; Thu, 2 Jan 2025 18:50:36 +0000
Received: from MKM-L10-YUNXIA9.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 2 Jan
 2025 12:50:35 -0600
From: Yunxiang Li <Yunxiang.Li@amd.com>
To: <kvm@vger.kernel.org>, <alex.williamson@redhat.com>
CC: <kevin.tian@intel.com>, <yishaih@nvidia.com>, <ankita@nvidia.com>,
	<jgg@ziepe.ca>, Yunxiang Li <Yunxiang.Li@amd.com>
Subject: [PATCH v2 2/2] vfio/pci: Expose setup ROM at ROM bar when needed
Date: Thu, 2 Jan 2025 13:50:13 -0500
Message-ID: <20250102185013.15082-3-Yunxiang.Li@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF00000146:EE_|LV2PR12MB5871:EE_
X-MS-Office365-Filtering-Correlation-Id: 5734104d-b722-48ef-e41a-08dd2b5e5871
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dWmvl7FRCEz+SjfDiCLpJvI7Hu7tbLaoxwc/5mMgrI1Vua22bLIA/k53/3M0?=
 =?us-ascii?Q?6/5k4WFBARBbax2AuNO76swW9JVJV8a3zsK4VZpfMu0tso9PuNLfApdXP3Aw?=
 =?us-ascii?Q?xBf18Wp0TTo9hhuumdgMGaahkIcLCkdZkseynpJsJNIFX7+V25njVoFzUSuv?=
 =?us-ascii?Q?hYKbuaFJm6fDME3Px6T1EuQq9ptAQox91F5o1eYRQdBoAMbX0jcMgnpai5sw?=
 =?us-ascii?Q?Bkslq3FrUenZWAnSgXZNuGBZ8T4U3jjtG0TXHcYQAIWjHM8hVrBx9Uq1Lkq1?=
 =?us-ascii?Q?G0kFG+iAnCN13eH3hUUbSP5KOeRC7hwrZPhtOh+i3bmiLzbQkrn8SI0qPYMr?=
 =?us-ascii?Q?QGenYxg668j3wqksgLa2w9PNC/3mdmhsfqvRqC/M1l+e7zaUex2CnJk+TRs0?=
 =?us-ascii?Q?bFY6ZFdB2MCD78S5MWGwr/bbfCVE6NXkUjLJFW+AK8SpnVHTNyk9AVkXPJYB?=
 =?us-ascii?Q?Y6ghGKlRwt5f2Fh/FIB4VK39Y2vUj9Kt9o0SjdYbA1xFnjz4JfmyasyVRt8X?=
 =?us-ascii?Q?keOm92ZSyWQLaiVXD13CawXUXIwvxO+M6Um/G49HzG10wOY2eVpZaxp2R+A+?=
 =?us-ascii?Q?Q1DNw4h9qi481DgnKUnJI8GlLAlEGOmCyMsS5YeV7Ly2AO1tfOlcHfSWNYxs?=
 =?us-ascii?Q?TNFYCx+j/8xBn8kCZe4HgpahBAX3ibXPtJFap+ehWPJb2pxGpsWY3G0oQ1Hm?=
 =?us-ascii?Q?7VjhcudjkCajXEE+zg/eALA8q3NPuyMRt0vKd0xNvgDGvj/ZoeIDXd27grWB?=
 =?us-ascii?Q?Vo232n2RML3nFCTGBcaW6GV57l5+qEQGg6x0PJQZ9yxLP2l1ORvHxWefD3km?=
 =?us-ascii?Q?cVmYO2njYd7cDEeiDlpG4Vgza/MGiH/nirxeagarRVV5qJOuH3SwDAvzA+TQ?=
 =?us-ascii?Q?G3i0KZEV7oBNkTP38dYng3vh8S4atGUPJgMLFBQAwhWmoDFi4qvgfwU9akHM?=
 =?us-ascii?Q?17JVIwWJhX6pFGskcU0aYBBBmJg12CTjE7Rk8k/nNSjuIeZtKncX8d1AEYni?=
 =?us-ascii?Q?jchXtNnoucNG5uK46gmFPkNdzvhpCUgJuHC6d7Xp92ubGcI6NXJSXQQxb0lZ?=
 =?us-ascii?Q?/zoQ6VHycK93+81RGfu45v7H7ri+ocJbWLAS0vi4yNbKmSuDm1fVKBjguI3C?=
 =?us-ascii?Q?3nQGYwrxhpBvQvqZIBRgIpCvVCVIIsu2jxAVOgEz5X4UEtL0Ltx2ii8mTYI6?=
 =?us-ascii?Q?8R17O5PW9xhuw7ec6yXVR6VeAm6ZsdzHsmt/00cFnFJVtKZgmzzaaTKDdA6A?=
 =?us-ascii?Q?6n5akAnn+aA9rhVtXf7dIIzzjoROE5N3+6r48tAhLn+K8/SXBKKcISnKccYY?=
 =?us-ascii?Q?+2dV70UkpY3KfHcDyU41WF/2qA4pghJTrp3Mc1jwTo6OO/Fz54ERpzpzHmVF?=
 =?us-ascii?Q?TZ7dlgs7rWf/GGkogtwf/aZp9vUUD1MzJJkxoQU4Xxslc/sVcqaXhSk0mZGp?=
 =?us-ascii?Q?BZQwqINfIsyGCfABN6ohkC4CwYspMCZuENbx9wsT1ar/Yt+TeRwHpXWTt+FF?=
 =?us-ascii?Q?pObVfjpXFPLsZg4=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2025 18:50:36.6320
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5734104d-b722-48ef-e41a-08dd2b5e5871
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000146.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5871

If ROM bar is missing for any reason, we can fallback to using pdev->rom
to expose the ROM content to the guest. This fixes some passthrough use
cases where the upstream bridge does not have enough address window.

Signed-off-by: Yunxiang Li <Yunxiang.Li@amd.com>
---
 drivers/vfio/pci/vfio_pci_config.c |  4 ++++
 drivers/vfio/pci/vfio_pci_core.c   | 34 ++++++++++++++++--------------
 drivers/vfio/pci/vfio_pci_rdwr.c   | 22 +++++++++++++------
 3 files changed, 38 insertions(+), 22 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index e41c3a965663e..4c673d842fb35 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -511,6 +511,10 @@ static void vfio_bar_fixup(struct vfio_pci_core_device *vdev)
 		mask = ~(pci_resource_len(pdev, PCI_ROM_RESOURCE) - 1);
 		mask |= PCI_ROM_ADDRESS_ENABLE;
 		*vbar &= cpu_to_le32((u32)mask);
+	} else if (pdev->rom && pdev->romlen) {
+		mask = ~(roundup_pow_of_two(pdev->romlen) - 1);
+		mask |= PCI_ROM_ADDRESS_ENABLE;
+		*vbar &= cpu_to_le32((u32)mask);
 	} else {
 		*vbar = 0;
 	}
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index b49dd9cdc072a..30fb657b25333 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1054,25 +1054,27 @@ static int vfio_pci_ioctl_get_region_info(struct vfio_pci_core_device *vdev,
 
 		info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
 		info.flags = 0;
+		info.size = 0;
 
-		/* Report the BAR size, not the ROM size */
-		info.size = pci_resource_len(pdev, info.index);
-		if (!info.size)
-			break;
-
-		/*
-		 * Is it really there?  Enable memory decode for implicit access
-		 * in pci_map_rom().
-		 */
-		cmd = vfio_pci_memory_lock_and_enable(vdev);
-		io = pci_map_rom(pdev, &size);
-		if (io) {
+		if (pci_resource_start(pdev, PCI_ROM_RESOURCE)) {
+			/*
+			 * Check ROM content is valid. Need to enable memory
+			 * decode for ROM access in pci_map_rom().
+			 */
+			cmd = vfio_pci_memory_lock_and_enable(vdev);
+			io = pci_map_rom(pdev, &size);
+			if (io) {
+				info.flags = VFIO_REGION_INFO_FLAG_READ;
+				/* Report the BAR size, not the ROM size. */
+				info.size = pci_resource_len(pdev, PCI_ROM_RESOURCE);
+				pci_unmap_rom(pdev, io);
+			}
+			vfio_pci_memory_unlock_and_restore(vdev, cmd);
+		} else if (pdev->rom && pdev->romlen) {
 			info.flags = VFIO_REGION_INFO_FLAG_READ;
-			pci_unmap_rom(pdev, io);
-		} else {
-			info.size = 0;
+			/* Report BAR size as power of two. */
+			info.size = roundup_pow_of_two(pdev->romlen);
 		}
-		vfio_pci_memory_unlock_and_restore(vdev, cmd);
 
 		break;
 	}
diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index a1eeacad82120..7458e9e0d75dc 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -244,6 +244,8 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 
 	if (pci_resource_start(pdev, bar))
 		end = pci_resource_len(pdev, bar);
+	else if (bar == PCI_ROM_RESOURCE && pdev->rom && pdev->romlen)
+		end = roundup_pow_of_two(pdev->romlen);
 	else
 		return -EINVAL;
 
@@ -258,11 +260,14 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 		 * excluded range at the end of the actual ROM.  This makes
 		 * filling large ROM BARs much faster.
 		 */
-		io = pci_map_rom(pdev, &x_start);
-		if (!io) {
-			done = -ENOMEM;
-			goto out;
+		if (pci_resource_start(pdev, bar)) {
+			io = pci_map_rom(pdev, &x_start);
+		} else {
+			io = ioremap(pdev->rom, pdev->romlen);
+			x_start = pdev->romlen;
 		}
+		if (!io)
+			return -ENOMEM;
 		x_end = end;
 	} else {
 		int ret = vfio_pci_core_setup_barmap(vdev, bar);
@@ -285,8 +290,13 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 	if (done >= 0)
 		*ppos += done;
 
-	if (bar == PCI_ROM_RESOURCE)
-		pci_unmap_rom(pdev, io);
+	if (bar == PCI_ROM_RESOURCE) {
+		if (pci_resource_start(pdev, bar))
+			pci_unmap_rom(pdev, io);
+		else
+			iounmap(io);
+	}
+
 out:
 	return done;
 }
-- 
2.47.0


