Return-Path: <kvm+bounces-64898-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C93DBC8F977
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 18:07:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5ED4D3AAC6A
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 17:07:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 366D82E5407;
	Thu, 27 Nov 2025 17:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rpVTOnFj"
X-Original-To: kvm@vger.kernel.org
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011028.outbound.protection.outlook.com [52.101.52.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E3C12DF14B;
	Thu, 27 Nov 2025 17:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764263217; cv=fail; b=ry6dNQoscHmy51BbBgZAvLj89pLHUF7Yrp9MUa70ESCzE7TAEqhHFcnTseJepKc088dpxj/qZmTgrJN1DQV0A0NNAkI3wqSo7O/6DHReTYwua044tQ26A4XniNyTS6Z6FURYmxGUeZuYBqKJ8JwnL1USKlGY4IwCn3jYcV6faP8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764263217; c=relaxed/simple;
	bh=eJt8NUEds5qUc+y9+0cSrdyvVlocxTLU72Ewhoi9Ov4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TPTNpRVbCrwMVPVx0IYELvDk/N2pvYHl8HOmgFwuIA2HJVvXGwYrrLWizNjzGwyhlfD0XN5D5mvCWJExVK2MD8Xs2OR//ceBp83bmi/9ii2eKXWH94C/MAl88d61lIMsWKRC5iZUtCWHzS5Q2tVGmjuRBuSevYs2GnxaEWIJhm8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rpVTOnFj; arc=fail smtp.client-ip=52.101.52.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n799MdOIZTy1Iv9PEJuKHHtxkPdFIQMCvnnYJBfdZ6CJTAmgfoAT4jLp2qQBWHDVwejqjdeCJ04KMWQWGoJh6vyseNKjBAQZxQNEQ8RZwXG7ZtFVijmCRQEwrJKNNtNtbx3rENeG4hYPSSsi2M8ACzZbCyk1ua2Le1fQWAucxrBmfsttp0mFP90qWJsjS1FSRYPoaAFC+FYxVSQmVy0Rg9LRuxWiNF28fnsD9pBlIoBNPzRGCrg4H1O8a8dlPuzzp0efaI8FrHFQG1IvcGmK8v24Qz26LiOLn0iessT/wiogQIL3c3oiNKrAFI5aOxUWQwsdASBenXc8L8CH3omPSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DUW813+kUFJ8TT2NhWJy9JDchyAxQhc6eQg6PHaf4mE=;
 b=Ld4OJXO12XXHARUREbM2CXZCl2+HgWQyC5pHoj8yK8B+jtnlbkF4HJ4lNjsndHcKtbJ/ixG0DxlRakA+/Wx+ilxCVbyViZZ6PLsrzoGuA5pdoXv7s1mu97s9yyWsm2ZCbzRusZMr7PMSnwYircsncbS59XovgHw2WkRbgBBsZGvK3yilbsSF/nB5PSomrvgmnJ8PFpboN0x8paZpAsU+SMqapHOauD5L2ePLVIyPqQJ0G8n7YGfVt/KYXY2WhVjBWgs6o7bzGoGVsCSMUVVtIj1aH38seCDy87WfOsv5LrRyRY4a/jIwdkhseJlkXD+JZjcyTUzWuwWnMcEPkzIJXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DUW813+kUFJ8TT2NhWJy9JDchyAxQhc6eQg6PHaf4mE=;
 b=rpVTOnFj39lacWyma1O6kdsVTr2u5DFru7WXaW2pSZ3adLW/4Z4wG3AOq25v5McbTZJ4bKI9Nc3gFJYy9XqZN1SyMVukuZ7o8dv9Hc9P3asDbs7PWNUvjl8JAhwyClapTbMFUrOAeQvcwsIvrDKDi2DcUjHjlYppqpKgMFAszhWPqyovVay3oavIhILsqaFfGqVpTbly94hljNj5hFi87jA8I9Zdu4i3uUgyLlymR3oG37kueY182xPIo/wVmq8JSdu3lnFxpLWt9TyyozUYIVHS0uvj4yA9x75sN3gG5zr+x0vWX89jtb7bkP2S0SToJMzM10W5tkFyCLt388LPVA==
Received: from SA1P222CA0096.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:35e::23)
 by DM4PR12MB8474.namprd12.prod.outlook.com (2603:10b6:8:181::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.13; Thu, 27 Nov
 2025 17:06:51 +0000
Received: from SA2PEPF00003F62.namprd04.prod.outlook.com
 (2603:10b6:806:35e:cafe::f7) by SA1P222CA0096.outlook.office365.com
 (2603:10b6:806:35e::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9366.14 via Frontend Transport; Thu,
 27 Nov 2025 17:06:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SA2PEPF00003F62.mail.protection.outlook.com (10.167.248.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.7 via Frontend Transport; Thu, 27 Nov 2025 17:06:51 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 27 Nov
 2025 09:06:37 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 27 Nov
 2025 09:06:36 -0800
Received: from
 gb-nvl-073-compute01.l16.internal032k18.bmc032b17.internal032f11.internal032huang.bmc032l04.bmc
 (10.127.8.11) by mail.nvidia.com (10.129.68.7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20 via Frontend Transport; Thu, 27 Nov 2025 09:06:36 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@ziepe.ca>, <yishaih@nvidia.com>,
	<skolothumtho@nvidia.com>, <kevin.tian@intel.com>, <alex@shazbot.org>,
	<aniketa@nvidia.com>, <vsethi@nvidia.com>, <mochs@nvidia.com>
CC: <Yunxiang.Li@amd.com>, <yi.l.liu@intel.com>,
	<zhangdongdong@eswincomputing.com>, <avihaih@nvidia.com>,
	<bhelgaas@google.com>, <peterx@redhat.com>, <pstanner@redhat.com>,
	<apopple@nvidia.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<cjia@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
	<zhiw@nvidia.com>, <danw@nvidia.com>, <dnigam@nvidia.com>, <kjaju@nvidia.com>
Subject: [PATCH v9 4/6] vfio/nvgrace-gpu: split the code to wait for GPU ready
Date: Thu, 27 Nov 2025 17:06:30 +0000
Message-ID: <20251127170632.3477-5-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251127170632.3477-1-ankita@nvidia.com>
References: <20251127170632.3477-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F62:EE_|DM4PR12MB8474:EE_
X-MS-Office365-Filtering-Correlation-Id: 5928370d-d7db-4ece-c9f1-08de2dd75be9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?okmXalkLRAbuqnX+39rcGwomYH6KY5uD/xhp5gI+lTYvlxe6dVkkMsD2cwWB?=
 =?us-ascii?Q?Ys99XYYWJNInuCZ20XRS2Gh8494VFRfHBhUMEAvZrcdadB9r2IpXccGeKHn0?=
 =?us-ascii?Q?zw0tfahqlZVLXU+Jwd4+/q96Dd5vc02vmUhXrCIVw5dy3BcWYbCaVx3y/laq?=
 =?us-ascii?Q?h1fl+235HxUuYquqoQZs3u9GvFKYTzZEHUDdl5LMgiD9eTYti4qfJMd3qfFz?=
 =?us-ascii?Q?CVL7fmHWP5zT4grhj+xeoAcAN8t1KLKblJ9a9jW/VnZ4IcfQfUrLhQBhyvV2?=
 =?us-ascii?Q?VZi0C9Hm4LMKZkPIA5w5erkPiTII1Xt5jJtrvhVIFFtWcVyaxaKDy3/6WbjO?=
 =?us-ascii?Q?viwl9xGVX/ekSzrf6Rh6PHh1dZdQCEjU6KSN46/MMkp1n2GIdkFLn05e+qnO?=
 =?us-ascii?Q?IROuzj+JcpLcjjlTP3YSF3olc645EMocsuT4ceXCLFoaP+wOZhiX50qa+z+O?=
 =?us-ascii?Q?SmYVSTH5Y3eeXPyh5hx5J8e5gSMobeiY0mcL09gheyOfQtoLeYxYzPkFvv8m?=
 =?us-ascii?Q?/P1giRmdoVZw72YYPhiutsv7kc4Lk5Zx266Yf8bxrFc20HK+ck+KNBXeqSgF?=
 =?us-ascii?Q?TElRPPBbULGq868kIWDfmv/cetc7p2LfEnw0pQjCTX4jtjoTBq3gVznyVtAZ?=
 =?us-ascii?Q?XGawriyK6nx00FjUgT5yg+gxyix0N/ciTY5L+p4Pwu13rMlPjQ1/zqQ9BRZU?=
 =?us-ascii?Q?z1+r+u+Bl5zcLHGGYfMxcMWAGkrGQFy46NqVNdIc/Q5q3Ntbe5PXaTumReKl?=
 =?us-ascii?Q?dnD4WNTc8mF1GK9MyDGucBTbgrBUVAP8i9ZMpQtFKOsCwIbmEmr7n3uDeyEQ?=
 =?us-ascii?Q?X7KVWt5ae/3VHyWQEN9JU8B4NZrwZ5CX0Htig+0D9h5qNLe/2i+2RWCd/JM3?=
 =?us-ascii?Q?JVEovaqJLWUUXj6DZGGwhVc7yMph2/mh8z+zHYqkjDueNu1l1sPj7YbbZr7p?=
 =?us-ascii?Q?EeDfs9VTaz5/JUhhC5/P2fSfuVqQ77adJRgZtYLjUD1jJP+89H+HpdIbPU0v?=
 =?us-ascii?Q?1UejzFDo7xkaqRaxzRIiyCLLWY0dJRm8mg6RLwKima1QUMUxKbr53hOztjyN?=
 =?us-ascii?Q?rKdGVkxI/5DaEu3tRuzx2SejMfqDBgjs8tZ6eg3axGz+PpZIV+9syFDDQmj+?=
 =?us-ascii?Q?BxWPIB/jhR5f1RqyekZCHNMF+FLLEOuVvzTfg+cUxcCU7+/q5qOW7rgXwnZd?=
 =?us-ascii?Q?HOz+3MJH8T/1+OIHB2rM8J2TRLRQAzovIa2ppWsHlQq3qc0essGtdZCph7YS?=
 =?us-ascii?Q?Wtmjh2YWFmk2/+s9nXHpsHGbQVX8VCH7WumCs4fuNXbP27wF/ShpDN4mdWI4?=
 =?us-ascii?Q?cjYN7HQNvUhqlzYTpagstiz3o8deK945S53MYmUHo+iB2dkMMLP/s/nLPiS1?=
 =?us-ascii?Q?E2WpSsYEgxu17xNWsGOs6T3w6VmRT2ntDvufnnuE0EpdnjA9/SyKI2rLqFR+?=
 =?us-ascii?Q?AG0dwlKNhzIyNr//0kuAwaZaLCDSzbp4Tyvz1chvaq21TQEU91vg3OYoOlsa?=
 =?us-ascii?Q?ptvE+za19cFtDu2++KHXaVbRM/oUZw0kN3VE/1gPi3fRldSL9zbW8nRsSw2M?=
 =?us-ascii?Q?4aygaQisJZnu//HGsQI=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2025 17:06:51.4505
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5928370d-d7db-4ece-c9f1-08de2dd75be9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F62.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8474

From: Ankit Agrawal <ankita@nvidia.com>

Split the function that check for the GPU device being ready on
the probe.

Move the code to wait for the GPU to be ready through BAR0 register
reads to a separate function. This would help reuse the code.

This also fixes a bug where the return status in case of timeout
gets overridden by return from pci_enable_device. With the fix,
a timeout generate an error as initially intended.

Fixes: d85f69d520e6 ("vfio/nvgrace-gpu: Check the HBM training and C2C link status")

Reviewed-by: Zhi Wang <zhiw@nvidia.com>
Reviewed-by: Shameer Kolothum <skolothumtho@nvidia.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/main.c | 31 +++++++++++++++++------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index 232dc2df58c7..059ac599dc71 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -130,6 +130,20 @@ static void nvgrace_gpu_close_device(struct vfio_device *core_vdev)
 	vfio_pci_core_close_device(core_vdev);
 }
 
+static int nvgrace_gpu_wait_device_ready(void __iomem *io)
+{
+	unsigned long timeout = jiffies + msecs_to_jiffies(POLL_TIMEOUT_MS);
+
+	do {
+		if ((ioread32(io + C2C_LINK_BAR0_OFFSET) == STATUS_READY) &&
+		    (ioread32(io + HBM_TRAINING_BAR0_OFFSET) == STATUS_READY))
+			return 0;
+		msleep(POLL_QUANTUM_MS);
+	} while (!time_after(jiffies, timeout));
+
+	return -ETIME;
+}
+
 static unsigned long addr_to_pgoff(struct vm_area_struct *vma,
 				   unsigned long addr)
 {
@@ -930,11 +944,10 @@ static bool nvgrace_gpu_has_mig_hw_bug(struct pci_dev *pdev)
  * Ensure that the BAR0 region is enabled before accessing the
  * registers.
  */
-static int nvgrace_gpu_wait_device_ready(struct pci_dev *pdev)
+static int nvgrace_gpu_probe_check_device_ready(struct pci_dev *pdev)
 {
-	unsigned long timeout = jiffies + msecs_to_jiffies(POLL_TIMEOUT_MS);
 	void __iomem *io;
-	int ret = -ETIME;
+	int ret;
 
 	ret = pci_enable_device(pdev);
 	if (ret)
@@ -950,16 +963,8 @@ static int nvgrace_gpu_wait_device_ready(struct pci_dev *pdev)
 		goto iomap_exit;
 	}
 
-	do {
-		if ((ioread32(io + C2C_LINK_BAR0_OFFSET) == STATUS_READY) &&
-		    (ioread32(io + HBM_TRAINING_BAR0_OFFSET) == STATUS_READY)) {
-			ret = 0;
-			goto reg_check_exit;
-		}
-		msleep(POLL_QUANTUM_MS);
-	} while (!time_after(jiffies, timeout));
+	ret = nvgrace_gpu_wait_device_ready(io);
 
-reg_check_exit:
 	pci_iounmap(pdev, io);
 iomap_exit:
 	pci_release_selected_regions(pdev, 1 << 0);
@@ -976,7 +981,7 @@ static int nvgrace_gpu_probe(struct pci_dev *pdev,
 	u64 memphys, memlength;
 	int ret;
 
-	ret = nvgrace_gpu_wait_device_ready(pdev);
+	ret = nvgrace_gpu_probe_check_device_ready(pdev);
 	if (ret)
 		return ret;
 
-- 
2.34.1


