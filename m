Return-Path: <kvm+bounces-36566-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 68732A1BC26
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 19:32:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E0DCD3AD218
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 18:32:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64D4A21C9E8;
	Fri, 24 Jan 2025 18:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tt714fY7"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2082.outbound.protection.outlook.com [40.107.102.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF78021B90B;
	Fri, 24 Jan 2025 18:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737743499; cv=fail; b=Hutqfs9dQHfZqH3TWgw+AWFmx3v+89THx0grYUtTZtHI95s/zyiTZ9GQy0YNP6JndjM0wf5pUE3yTCFl73bqHJ7w0G4xsV9vi1ghzIGexlZd9hV0jiDZsiVC7TjeK0XxyVRw18NH57nkx38wmp2pnHtwhxBtzNwiqvF+0T3/0do=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737743499; c=relaxed/simple;
	bh=+se5AY3kqkj4HP/fRSBua7ksbVwVSZnq8Ak+5V0e/TM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GdPLf+nKFuOoSzH1i2uSepECI4JYV7zu/kvk+PvwCt/Mzjd0HvVA+3nmZTG0nlQqI9tdpBw3kp29G+9o0At5E40hJsmQFTBUis5KCU1Mr5PNdvORwFJDLvMrYnDHfL/Db8Tkp5SqDiOkroI1veen3O5pFcWWkfN+DzS7ACt0DdY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=tt714fY7; arc=fail smtp.client-ip=40.107.102.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dNZWWREjY/DQNyMppeQNR0f2webjOOMRNsL3krcGO7W+f9hz1kJVJpqTrXyxSgRpj/TfnBwkTcU7qkaWas1Zuvpoft9iGiXL9fXrFW0Fjztj5hYwp36q9kED0pSpoGnLFf0vTTeqe9mo6/DDE+s62DHNlPYhx0PkncOitwxBXuFLvYNMeOW42Au7Ofm0DZBJr+GjgqYyA9WbLmeFO+FdZWEl+wjW253RulM8qZ36suXKcSLcO+Cy90Y821SdS8zeofKzQC4xdf12w/m4O2Dd2YSlgRoaoCEJ5y3tO4t7O+GnhXbUaHH3axC9gWZVlTwAwzHrg2MlrGA1uXttiMeL0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wtoicHvCWCrwGsqWNInU7GT5fDffHIGfOumosWXmQHM=;
 b=t1mEQf8X3IuudHjTcLHNWlzEQ1RrvD5s2OjwczVQUEutxlKZMOOb47PDq3e/h4XNvoWfAgGO34Za8Fp9z7yWzIn7WJX/D5v9IgTARFIikPuL832pCDPEHnd+pT6zEKtYSqpndqv+pWxARj94PaSd3eEXmN2AKO3WEmShtLgcODVCeAecjh7bSuhfasSKIaslO28muqSJF1TmK1BsBMj2/CHrKA2oTjGWE0cr3sdM0FLW+vJrB89KQzA7R/I0ZFGRYt/uxiBb9MvrDAFgX93cZu80MPChpyi428bGQOqsGAHQ0BDr6s6r19RiMjghIZKvs8jlXb3yN+PlkpAWf2GpeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wtoicHvCWCrwGsqWNInU7GT5fDffHIGfOumosWXmQHM=;
 b=tt714fY7K9zoJtocV99KQ/xp934EU54XnTT0Hp/GU13Uj0AKqvKhNj7eGhgRgMVzmTxIwJ3Xx3aIKSCISXfqHXJDhT9LDtxjuub9WhqrpKjdkiG4o/XWRBMsV8pNhOU9QncccnN3mxqYKjP8yb5sbC2rbhr1dJb41IILaif0Lhc51fX1yazdud/8tEBpyUmzc3z2haQ2J46yzyKyc0NxwgXSJOq7BjjFk5Xch8YXYTz9O+bzJgsg3DpabuOZgQ0+huZMhjoTorNvPq2EvZdCxKEZMtrOYXfAMYKYMrOlCzQ2wY+QxYybOcEKqtj+RadvqJ/AXgzJSwGLQcGAas8FBg==
Received: from SA0PR12CA0016.namprd12.prod.outlook.com (2603:10b6:806:6f::21)
 by PH7PR12MB9224.namprd12.prod.outlook.com (2603:10b6:510:2e7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8377.18; Fri, 24 Jan
 2025 18:31:33 +0000
Received: from SN1PEPF00026369.namprd02.prod.outlook.com
 (2603:10b6:806:6f:cafe::4e) by SA0PR12CA0016.outlook.office365.com
 (2603:10b6:806:6f::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.14 via Frontend Transport; Fri,
 24 Jan 2025 18:31:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SN1PEPF00026369.mail.protection.outlook.com (10.167.241.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8377.8 via Frontend Transport; Fri, 24 Jan 2025 18:31:33 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 24 Jan
 2025 10:31:16 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 24 Jan 2025 10:31:16 -0800
Received: from localhost.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Fri, 24 Jan 2025 10:31:16 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>,
	<yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
	<kevin.tian@intel.com>, <zhiw@nvidia.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<kjaju@nvidia.com>, <udhoke@nvidia.com>, <dnigam@nvidia.com>,
	<nandinid@nvidia.com>, <anuaggarwal@nvidia.com>, <mochs@nvidia.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v6 3/4] vfio/nvgrace-gpu: Check the HBM training and C2C link status
Date: Fri, 24 Jan 2025 18:31:01 +0000
Message-ID: <20250124183102.3976-4-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250124183102.3976-1-ankita@nvidia.com>
References: <20250124183102.3976-1-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00026369:EE_|PH7PR12MB9224:EE_
X-MS-Office365-Filtering-Correlation-Id: 13221090-ac8d-4a90-906b-08dd3ca553f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cCQRg94QcmCvowDEc6z5H8zrymUVlBrvrunrF3t4VPtakkKf0H8io+g8GZg9?=
 =?us-ascii?Q?/xnVlqdwETdUixP2X4Yb/VZmjBndoBSd8N5gcnUE4DRC3SnLdFKMTMjtLm57?=
 =?us-ascii?Q?9h2sh6jd3UR7g9XfBMuK6WT/O58JvaiJr694thHg19GjDPC0O8KE+1qa+1RC?=
 =?us-ascii?Q?lEHdHOZS8jU2TbksNFGZpPw5f3UZXGlMidjFgptvwMxgOTUa/ga7g6zk4N/9?=
 =?us-ascii?Q?KqclYNEZxTU+5Tt+yoMhTgmBGkby21pSfAhfUxIiJZPcd9+HYWgHWp18G7EM?=
 =?us-ascii?Q?WPBjnXgHOllPNNg8Ec+hF25Z5rm9UF5CgyuFw9kOIEyxMkHC5+FA8bM9sGzd?=
 =?us-ascii?Q?dm7f48Qa/X/0HFL1Qt8P8CGFG8dnNfPdqNpp8MoPHqRKE3qRKIh6nI5pjXWh?=
 =?us-ascii?Q?gSR6wmyE3E9qGZM4GG32Oh32rKIa8azoBnnuk+qBotLjg95Z4O2E27VmQu5b?=
 =?us-ascii?Q?1xy4FzKKBvB4OyTZzi+XOY8dexndg3nQ79x4yD8Or3M+C+5Kb0Gl+hgAU/zT?=
 =?us-ascii?Q?QL+92WC6LpJvJvk4ibx0+RjA1t4yf229UmOUpVxJt/z29ZjEJ5ErRmW6tBd+?=
 =?us-ascii?Q?DlUMuF2Rs7ceUyje1aK2/DkkkVvEAiSgD/Xi5PaVDWnLwUaMcigUYkdrzUE7?=
 =?us-ascii?Q?TCdagkB+fkJ02IqJ5nEI+JyvltWkhGyF53qu4oSJimSgT+t+wCsq26I3dHsa?=
 =?us-ascii?Q?nOSyUaFgBECZ6UGxf3DvIRQTLlwrchrE0v4/BmgpK6TZm0VOT3Z3fnLFYR07?=
 =?us-ascii?Q?63Xt34g9/CWlx2mhPyMP14UDbuUKFwLeD0LPVIMaTS/haYg/ArYX1ke3Bivf?=
 =?us-ascii?Q?dF6c6aPBSHFFf8S5mAZt6LrJNdceveBuucxGjEy2P1qzOZRKg1aHGAIGvVN0?=
 =?us-ascii?Q?936B7L1I2owdvIfPhV7cKVoU4CfUFpS2AEFhRABYQzYJuyNOLmKywCNyxw6Y?=
 =?us-ascii?Q?THAvkt9VvUOXkVdhV3g8jRi9iDZvYZ9VIN1N/YyeW6jAkOt/5Kt24rr1//XJ?=
 =?us-ascii?Q?iYrmG6itM4fUk51ps7745bet3rgHfOgUjjIWHkA9TkVBOBTgeryTV/mA1qDr?=
 =?us-ascii?Q?YmQPSVnYVk82H0FHHxAIRljK+2Cf8qxEKC2PlLrCCzv+NWIR6hHKnmbxKP4i?=
 =?us-ascii?Q?gMt/wfe71nenELVd1jXOUR3OOJGbASLF5NS75pNFxa0oR+10uTC85r+dMZTb?=
 =?us-ascii?Q?4uYwbbxqrxxCK7XYrNNBEkHhH8IUDk+CVG8kKR16C+Fu3IrzwuJs1YvBaiAz?=
 =?us-ascii?Q?GQply0kvXCNTG33dYZFGzOBT8txt7CUPmtejVN5z/ilMlbg0VYNT9TZaBV2J?=
 =?us-ascii?Q?ppV5J79/mT6cyK1fgjIyLtBGH1aF0ofiFe8/zylKP8wpkimQkl44bywGEiHc?=
 =?us-ascii?Q?bJSmbtTJ1FEm8CqrvwKZW/kwo6a0ON4WbMMb3HGbzys3YCvC6jxC7xi/ChOd?=
 =?us-ascii?Q?yvcEYQEzlBOufEYadMISDiRxzd5CYauPdmY+cFrxgaZasAfZat+kiyL9WGw8?=
 =?us-ascii?Q?kgNh1fTT0e09Op4=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2025 18:31:33.0813
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 13221090-ac8d-4a90-906b-08dd3ca553f3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00026369.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9224

From: Ankit Agrawal <ankita@nvidia.com>

In contrast to Grace Hopper systems, the HBM training has been moved
out of the UEFI on the Grace Blackwell systems. This reduces the system
bootup time significantly.

The onus of checking whether the HBM training has completed thus falls
on the module.

The HBM training status can be determined from a BAR0 register.
Similarly, another BAR0 register exposes the status of the CPU-GPU
chip-to-chip (C2C) cache coherent interconnect.

Based on testing, 30s is determined to be sufficient to ensure
initialization completion on all the Grace based systems. Thus poll
these register and check for 30s. If the HBM training is not complete
or if the C2C link is not ready, fail the probe.

While the time is not required on Grace Hopper systems, it is
beneficial to make the check to ensure the device is in an
expected state. Hence keeping it generalized to both the generations.

Ensure that the BAR0 is enabled before accessing the registers.

CC: Alex Williamson <alex.williamson@redhat.com>
CC: Kevin Tian <kevin.tian@intel.com>
CC: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/main.c | 72 +++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index 778bfd0655de..655a624134cc 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -5,6 +5,8 @@
 
 #include <linux/sizes.h>
 #include <linux/vfio_pci_core.h>
+#include <linux/delay.h>
+#include <linux/jiffies.h>
 
 /*
  * The device memory usable to the workloads running in the VM is cached
@@ -25,6 +27,13 @@
 
 #define GPU_CAP_DVSEC_REGISTER 3
 
+#define C2C_LINK_BAR0_OFFSET 0x1498
+#define HBM_TRAINING_BAR0_OFFSET 0x200BC
+#define STATUS_READY 0xFF
+
+#define POLL_QUANTUM_MS 1000
+#define POLL_TIMEOUT_MS (30 * 1000)
+
 /*
  * The state of the two device memory region - resmem and usemem - is
  * saved as struct mem_region.
@@ -861,6 +870,65 @@ static bool nvgrace_gpu_has_mig_hw_bug(struct pci_dev *pdev)
 	return true;
 }
 
+/*
+ * To reduce the system bootup time, the HBM training has
+ * been moved out of the UEFI on the Grace-Blackwell systems.
+ *
+ * The onus of checking whether the HBM training has completed
+ * thus falls on the module. The HBM training status can be
+ * determined from a BAR0 register.
+ *
+ * Similarly, another BAR0 register exposes the status of the
+ * CPU-GPU chip-to-chip (C2C) cache coherent interconnect.
+ *
+ * Poll these register and check for 30s. If the HBM training is
+ * not complete or if the C2C link is not ready, fail the probe.
+ *
+ * While the wait is not required on Grace Hopper systems, it
+ * is beneficial to make the check to ensure the device is in an
+ * expected state.
+ *
+ * Ensure that the BAR0 region is enabled before accessing the
+ * registers.
+ */
+static int nvgrace_gpu_wait_device_ready(struct pci_dev *pdev)
+{
+	unsigned long timeout = jiffies + msecs_to_jiffies(POLL_TIMEOUT_MS);
+	void __iomem *io;
+	int ret = -ETIME;
+
+	ret = pci_enable_device(pdev);
+	if (ret)
+		return ret;
+
+	ret = pci_request_selected_regions(pdev, 1 << 0, KBUILD_MODNAME);
+	if (ret)
+		goto request_region_exit;
+
+	io = pci_iomap(pdev, 0, 0);
+	if (!io) {
+		ret = -ENOMEM;
+		goto iomap_exit;
+	}
+
+	do {
+		if ((ioread32(io + C2C_LINK_BAR0_OFFSET) == STATUS_READY) &&
+		    (ioread32(io + HBM_TRAINING_BAR0_OFFSET) == STATUS_READY)) {
+			ret = 0;
+			goto reg_check_exit;
+		}
+		msleep(POLL_QUANTUM_MS);
+	} while (!time_after(jiffies, timeout));
+
+reg_check_exit:
+	pci_iounmap(pdev, io);
+iomap_exit:
+	pci_release_selected_regions(pdev, 1 << 0);
+request_region_exit:
+	pci_disable_device(pdev);
+	return ret;
+}
+
 static int nvgrace_gpu_probe(struct pci_dev *pdev,
 			     const struct pci_device_id *id)
 {
@@ -869,6 +937,10 @@ static int nvgrace_gpu_probe(struct pci_dev *pdev,
 	u64 memphys, memlength;
 	int ret;
 
+	ret = nvgrace_gpu_wait_device_ready(pdev);
+	if (ret)
+		return ret;
+
 	ret = nvgrace_gpu_fetch_memory_property(pdev, &memphys, &memlength);
 	if (!ret)
 		ops = &nvgrace_gpu_pci_ops;
-- 
2.34.1


