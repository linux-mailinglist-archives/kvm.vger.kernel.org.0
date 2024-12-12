Return-Path: <kvm+bounces-33661-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B03B99EFDA9
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 21:51:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 17234188CCF0
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 20:51:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F04431C07E2;
	Thu, 12 Dec 2024 20:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NlOrB7eQ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E5C1B6D1C
	for <kvm@vger.kernel.org>; Thu, 12 Dec 2024 20:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734036671; cv=fail; b=VL5LbX1fByColbicMMWURfp0yrvAZ0WSPKz52UxSL6anRLRQAChxS3HmS3QEMEGvUQm8hbeCUDKE+qwKwDbWLwtDR/ZsF9Zrny+UoABGPA9dYuf9Er8fr7oJs1/y3hpVl3UOjINvNlYHx8atbEfZf5EXocJSOW/w5Pbg/yP1xag=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734036671; c=relaxed/simple;
	bh=EQ0YiJ3H/3Va8S1GFSV4wCN8reyqhMEZpJvCKNI831Q=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y2Ttip6jph+rBTU1bdMDDjnvURUwOTm3ODgpgbyJnEsUdnkzpJ9XujVCnVmcfmTS9F6qRw3eEClM5Z+ghzkCbzk1FGpVWTih4wDBCppUZPR2kIY9v9offaJ0mZr6fdhLVe93Asl6m8TRYGRMzADfCG1qByodFpQGxKj93H/zM1E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=NlOrB7eQ; arc=fail smtp.client-ip=40.107.236.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hRp5+kGyj20lYodtrWdZloB0OI3Xcmp+zgfcfbKbO2bzwcIwZGzCvj81BOqTeOQC1OF4wee/M/QcRPx4LkDQtWToRHZ8SJX7BsBpXv0qfd1T7Fu7A6nVtcyILGPpEhbqF4FaF+B7JMwmkP/K6U+rIUK5DAynwgIk9QbWVbpHYQgzSM0Mtld6yghVf0k7t7uiSkYqt0bN9w5h3E31mynDfWyKveUummVPz8L9PjHkOKCWBzsx+GDeOtB1wA5bD2JjvzJM8D2petXrZZmLyQRHtnb483ZIu0+VnII7PPzvJRaEE7+FMlBpoViRxj1An7VfOY5Q1OdjYf2kFYtfnA0Jjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CXFFdQNIDQ1FPepVo37eJqeAiXy1C+UHLtG2IEzcobk=;
 b=U0EEtkJInbXbT1D6TSk+hpFi1/SiPPRBJQXRo3b1jOKHQSmQX52Tj4+Y1dM8uiDmAh0W+CcWvoo0laWN9P6aTOaR/ZcrRg13ykrxDizLCMDTy7rU5308T7amlpUzSHM9jrF0CcHCycmevqVrbLw8WLWtAglOO3uhoBebFKLNkp2dqBS5acMA+yWXTa1CEOrGVstNPJEj1N2UfMBBElSeLvwRogBgyyokGxZ/waMrGAhAh0UBbS/TLRcO+Yo6f3CvXQimtvFSi50kySbhpadP6luDcrUc11q8DLXV+5wSbv49sHlhVuSRVGwyZjnZbvKdw+5s2X+gUxpI3kZ2ijJsrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CXFFdQNIDQ1FPepVo37eJqeAiXy1C+UHLtG2IEzcobk=;
 b=NlOrB7eQF5DQSuVeJjFT+Ce05CW2sjjTQJB/4yQZ3ApMCO/UM2SdFynVtKjDJ04z2uLCm0P0091y6HWH8inUBT1SwSUCD1AryqSLW/1do1zIk1n7quK+wnl2Rwv7YgAGnaF5dHbe7+6Vi+9OkIlRJo+pd1qp19BRcUQ+yneLuaU=
Received: from BN9PR03CA0372.namprd03.prod.outlook.com (2603:10b6:408:f7::17)
 by SJ1PR12MB6196.namprd12.prod.outlook.com (2603:10b6:a03:456::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.15; Thu, 12 Dec
 2024 20:51:03 +0000
Received: from BN1PEPF00004682.namprd03.prod.outlook.com
 (2603:10b6:408:f7:cafe::d8) by BN9PR03CA0372.outlook.office365.com
 (2603:10b6:408:f7::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8251.14 via Frontend Transport; Thu,
 12 Dec 2024 20:51:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF00004682.mail.protection.outlook.com (10.167.243.88) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8251.15 via Frontend Transport; Thu, 12 Dec 2024 20:51:02 +0000
Received: from MKM-L10-YUNXIA9.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 12 Dec
 2024 14:51:00 -0600
From: Yunxiang Li <Yunxiang.Li@amd.com>
To: <kvm@vger.kernel.org>, <alex.williamson@redhat.com>
CC: <kevin.tian@intel.com>, <yishaih@nvidia.com>, <ankita@nvidia.com>,
	<jgg@ziepe.ca>, Yunxiang Li <Yunxiang.Li@amd.com>
Subject: [PATCH 3/3] vfio/pci: Expose setup ROM at ROM bar when needed
Date: Thu, 12 Dec 2024 15:50:50 -0500
Message-ID: <20241212205050.5737-3-Yunxiang.Li@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241212205050.5737-1-Yunxiang.Li@amd.com>
References: <20241212205050.5737-1-Yunxiang.Li@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00004682:EE_|SJ1PR12MB6196:EE_
X-MS-Office365-Filtering-Correlation-Id: ea85f077-6216-490a-b41f-08dd1aeeb085
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GepXx7M1X0Gwd6cfRYTqs4jQJhUW7qJKMlZo5yrthWCFArvQujVQS2vS6qIO?=
 =?us-ascii?Q?e+s5M3uU9ozdnCWpPAArLotO6TaGl+mK3huBMwNI952TseH26C2P6xEqjcXm?=
 =?us-ascii?Q?58O54kpk8Ei8GAcjdoWO62ljeoq3n7lBPXPRmqhuyDTgnyEbtLN3sd7zQY3P?=
 =?us-ascii?Q?dI0AWAAJp2Z/oSAsjgWpQ/MR5X7RPTAgEyOOxBjNkeC1qn70+GCxDKf/WXlH?=
 =?us-ascii?Q?oceJrRh7NIgsHRGqbuIiB2ntOeq+pD7lLkUbk+iJxUN23UJQyEqwSLNOWWmU?=
 =?us-ascii?Q?FeoncvS/2j2YkWlkQh0R/peTWh9dIJI8cNnQQUOI+zUyKv+6LG2QF9YD0zXz?=
 =?us-ascii?Q?Xy+nKwg1UlhUxDiH1ySbZaXqmiZyN3VBARfAoRc+XN2V9bGXgUlnN5uP/j+o?=
 =?us-ascii?Q?GztT0LZPmwvmRBpJPaTjSzpHra3JZirWVHGpL+Pe7o8EelrdFKkmCC7a0Ak9?=
 =?us-ascii?Q?6zk1DK///eMdePtz91SqTXmMY+1bH442LY67+dz6y20CBnAt+uR0c2N7RMoZ?=
 =?us-ascii?Q?L2xQ8lRpJk9Qf8x6EUv/NmwATfnPReb0PhHc1qyfiamRXl4/I8UA3imfxtwo?=
 =?us-ascii?Q?26vZKn3niE5z5cJkgyrKihkaPwCSqXY3nAnGbck4xvaHN7tSTKZwVeT7NngO?=
 =?us-ascii?Q?lev/MF7cj2xWQikeNHWo5PTKEjxRaVcIBiS7qwHJ8gVOcBXJnUrVQmxoe5z0?=
 =?us-ascii?Q?twJvCNfdkb5yDqafSe+YLDGPHV11/ATYG2WPQNw75YTKvZHjvSlsM2MRRQi/?=
 =?us-ascii?Q?Bjnml6hoxcOOoQgZCft6tIdKlo1fdphgeeIQ7NXyp/ASFtwCwgVUdvuBNHrb?=
 =?us-ascii?Q?FABZpbWDx8ZiBy178+rWMJQdUOvifmAI2Ww5AYgBOMav+OkqG8D2StKH5P3o?=
 =?us-ascii?Q?+UkMVy+h2xFupeoTo5E+4WVtAR7PQ9+6UuZkhVFzJTZBE7BQrDwCvy7KbiwW?=
 =?us-ascii?Q?BDxOsI9nfRGdI8NXQwX0F8k3URUA4ujWUMj1s9+37Ud5Qv+6ZJ1y7+d4MEV2?=
 =?us-ascii?Q?XkT1mvFbX1v5MaYMmnYJEjfvKdrYUj4lN72KXccJpNawiiG5AKtmVqudZv/o?=
 =?us-ascii?Q?Ir+qjIwZVVg6vI+COe6Jsnja91TSr4++2xmHNXBmu8sgRDZgr8CFoQwuY3GS?=
 =?us-ascii?Q?jbPWGPAlAU1dvGzSgIHbA5/ttYNZFICK9MuBMew9dIXMhFfmnbwp4yL84u8b?=
 =?us-ascii?Q?QgGjJR3rIZCBZjaCQ5jwmVXkg3Iu8DTpgSY0F7LsZsMuk9UeYXvNNF72zItJ?=
 =?us-ascii?Q?s15WhP2YHpSRMxw5z7DVLDT4/Nh+zfde5K850hTgCRJErhax9Lo67Umtr0tB?=
 =?us-ascii?Q?m688h5fL9pVnIIhFwFyjMaE13WSH5CVwnNsAdadLeAys19W7RPBYysQiMePP?=
 =?us-ascii?Q?oCBPt8eMV8xrywOiYtX3TaCxHrJVwGquE0xYnLjw4FamTEubHjDXdpqlsQ0O?=
 =?us-ascii?Q?EHOKoqZw5W0i50iDkRsrg4uxy87eE7w5?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2024 20:51:02.1788
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ea85f077-6216-490a-b41f-08dd1aeeb085
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004682.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6196

If ROM bar is missing for any reason, we can fallback to using pdev->rom
to expose the ROM content to the guest. This fixes some passthrough use
cases where the upstream bridge does not have enough address window.

Signed-off-by: Yunxiang Li <Yunxiang.Li@amd.com>
---
 drivers/vfio/pci/vfio_pci_config.c |  4 ++++
 drivers/vfio/pci/vfio_pci_core.c   | 35 +++++++++++++++---------------
 drivers/vfio/pci/vfio_pci_rdwr.c   | 14 ++++++++++--
 3 files changed, 34 insertions(+), 19 deletions(-)

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
index b49dd9cdc072a..3120c1e9f22cb 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1049,30 +1049,31 @@ static int vfio_pci_ioctl_get_region_info(struct vfio_pci_core_device *vdev,
 		break;
 	case VFIO_PCI_ROM_REGION_INDEX: {
 		void __iomem *io;
-		size_t size;
+		size_t dont_care;
 		u16 cmd;
 
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
+			/* Check ROM content is valid. Need to enable memory
+			 * decode for ROM access in pci_map_rom().
+			 */
+			cmd = vfio_pci_memory_lock_and_enable(vdev);
+			io = pci_map_rom(pdev, &dont_care);
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
index 4bed9fd5af50f..4ea983cf499d9 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -243,6 +243,8 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 
 	if (pci_resource_start(pdev, bar))
 		end = pci_resource_len(pdev, bar);
+	else if (bar == PCI_ROM_RESOURCE && pdev->rom && pdev->romlen)
+		end = roundup_pow_of_two(pdev->romlen);
 	else
 		return -EINVAL;
 
@@ -259,7 +261,12 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 		 * excluded range at the end of the actual ROM.  This makes
 		 * filling large ROM BARs much faster.
 		 */
-		io = pci_map_rom(pdev, &x_start);
+		if (pci_resource_start(pdev, bar)) {
+			io = pci_map_rom(pdev, &x_start);
+		} else {
+			io = ioremap(pdev->rom, pdev->romlen);
+			x_start = pdev->romlen;
+		}
 		if (!io)
 			return -ENOMEM;
 		x_end = end;
@@ -267,7 +274,10 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 		done = vfio_pci_core_do_io_rw(vdev, 1, io, buf, pos,
 					      count, x_start, x_end, 0);
 
-		pci_unmap_rom(pdev, io);
+		if (pci_resource_start(pdev, bar))
+			pci_unmap_rom(pdev, io);
+		else
+			iounmap(io);
 	} else {
 		done = vfio_pci_core_setup_barmap(vdev, bar);
 		if (done)
-- 
2.47.0


