Return-Path: <kvm+bounces-64719-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id AC88AC8B947
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 20:30:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 850124EBAC3
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 19:29:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE3F1341674;
	Wed, 26 Nov 2025 19:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qPV71PTa"
X-Original-To: kvm@vger.kernel.org
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011034.outbound.protection.outlook.com [40.107.208.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6756933C1A5;
	Wed, 26 Nov 2025 19:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.34
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764185352; cv=fail; b=jMWOtn8WXzhq6gmgyeibrhU5fNzbZ649kis35qKv3SHP1agbQGRZi0k8E2taUpyI2cIlORVtNQI4WpJG5ufwCCP67/FfvjI+NXNALypxswdQNrz4tzi0aH7Ru1krXAnZ+eBEEKaTFWwTP+FbTVnD3BKHAW08SqknKu/Cv+YjEZQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764185352; c=relaxed/simple;
	bh=eJt8NUEds5qUc+y9+0cSrdyvVlocxTLU72Ewhoi9Ov4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y8VWeWcPigN5D/o+OwmmRxAJN6JOohNSwRN5O153OwwQ0W8Wfa4oiBZ+H3nvJCdlRnhTMOdcRuIpdnuIXLG/INFQYHsq7htFFlz/NCeiupl5ZrCyRMujWlJDe0JmQXTeQ07SCZJN/JRDeqmvZQqMaTZvcbJP0lw5ftZQRAB4WVM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qPV71PTa; arc=fail smtp.client-ip=40.107.208.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L0pnoYUrlVm/4kyzzonXgHXoA9zCsavENtrX62YP5KvbCezzS+3Bf1+yUD4rhBuTcZWRQjyv3MyaeSbsstrNYGl1EYkegVamFq7rG8OLIben9s52M5sX6a0yjMe8bhQW/2Q8zYyA9OxBXkrk/tFOGxeb/XOk9Yyd/YEQ+I8ULPLqIaN22BAHlJBEjeKduixgUQ9QwJY8bIJgZZbjVkrhqmFj0CGnFu9IXDFn5OJ7XW05PkJi/wnQeB1uGq9lec9LUkDUMaRMbrbzGoGqt0H+i2k8Zs6xvAJktRn+g/2Kt+F24kjKBFh5Dpkd6blN4XVh0qkNNY28sCohN2o3XxIJZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DUW813+kUFJ8TT2NhWJy9JDchyAxQhc6eQg6PHaf4mE=;
 b=e1sxpG+Lh8pt6GU8GYPZmorjrf7STIslLwiZIYlOLsCnGrIAH/XmK+9R+mdlcBUPkkob1SWz184aJj/2vnONFHkfODNvqjUTt7aClPxmdwotXfprHLAqo8GkJM0tmbdIhUJKAZcVxjxQKmfGl//rSGg3so/mXPzRtWF1Ig5jxZRt/O3MqKkK5iFCol3x64aTqgxLL+s0Rs1O4q+mZv+RL6TRsFeB1m4kGru9LxwKSsNGocJXm9Phn6j3jm6FhJT1HXE4+pq7RJZjpv+etUf5vaQh4I6DJhcEoyucpctwUYjuVfd6KTIimDRQQWyd0EF4QWIkvg1O9lB1dbBt8pnMWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DUW813+kUFJ8TT2NhWJy9JDchyAxQhc6eQg6PHaf4mE=;
 b=qPV71PTagN2njd8deox8wLDMn1k2gEVAl+xigNmBZxWwfnBu1GiQzcwrnCt6CdWm3sN3YX469Dqvc6GpoOvJds3Y2IFwU3IYYfD2SsutMck9U6Pt1H5cszZMsdzrU25Nt0gSrdYHIh3JQrmc12hqGOtZg1mor+K631PnzaZgbj5lkVltFON8hfuQ5e+4mcTtrUlfWpWYmeoUHuNzN4zEt/+YxPlfFgu/fXqSzQwLyS3tbUN0fhP2IxfplJZ+3UM3uOZdneykSy46M9A4Y/Gn4RaRjTG/Baz8b9SBZ8tmcFCJe4JvHQfNdq9RRdO7Qz3xDm2jwSdIEslgCfLOjMD5ug==
Received: from BN9P222CA0025.NAMP222.PROD.OUTLOOK.COM (2603:10b6:408:10c::30)
 by BL4PR12MB9484.namprd12.prod.outlook.com (2603:10b6:208:58e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.12; Wed, 26 Nov
 2025 19:29:07 +0000
Received: from BN1PEPF0000468C.namprd05.prod.outlook.com
 (2603:10b6:408:10c:cafe::d0) by BN9P222CA0025.outlook.office365.com
 (2603:10b6:408:10c::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.18 via Frontend Transport; Wed,
 26 Nov 2025 19:29:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN1PEPF0000468C.mail.protection.outlook.com (10.167.243.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.7 via Frontend Transport; Wed, 26 Nov 2025 19:29:06 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 26 Nov
 2025 11:28:49 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Wed, 26 Nov 2025 11:28:48 -0800
Received: from
 gb-nvl-073-compute01.l16.internal032k18.bmc032b17.internal032f11.internal032huang.bmc032l04.bmc
 (10.127.8.11) by mail.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20 via Frontend Transport; Wed, 26 Nov 2025 11:28:48 -0800
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
Subject: [PATCH v8 4/6] vfio/nvgrace-gpu: split the code to wait for GPU ready
Date: Wed, 26 Nov 2025 19:28:44 +0000
Message-ID: <20251126192846.43253-5-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251126192846.43253-1-ankita@nvidia.com>
References: <20251126192846.43253-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF0000468C:EE_|BL4PR12MB9484:EE_
X-MS-Office365-Filtering-Correlation-Id: 464dc78a-aefe-4dc9-06f5-08de2d2210fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YeaFzogf2slD8iqb1nEGcQv0cPT+SqXbvkcR82IRJ4bedRyCJ5C/NQjYi8E4?=
 =?us-ascii?Q?HI6ioAKagLNWoD8DsNdrz2DW0K3zXJ1yfw63Zt9y7L8iwL3/aPwcUCBP+BeT?=
 =?us-ascii?Q?ZVFjvFV5LW23owwBScTQgSldZhs84J7YPgz5/gGB1a3y+7Zcc3fngCXqr2Vv?=
 =?us-ascii?Q?sAmZEFInArXtISPObBr68uuxawD2OpM2edC1AhrZglrr8ZGEZHOnP9daAaJI?=
 =?us-ascii?Q?uCEq9Gx8iOA8ghQLekZ+HFkO6CLrSWljsd9KPlEWtFF/A8UGUoxLFAAnyAA7?=
 =?us-ascii?Q?vSQs68IA6SozRZg//R9rMdrB5aKuZyMi/MAmdGFZqbX7Y6zmzJ+dX1o+2MYm?=
 =?us-ascii?Q?2txqZYdYYcZ4DaL2ODjlVxea5u1YePxZKliP5NEQH3aovI5bjEUkGTDChnCg?=
 =?us-ascii?Q?KQOFXaVg0Xip8FOnDr3U+0clyLy4nPNLm8J8R1Mb/2KHgjECVjvt6dczTvb5?=
 =?us-ascii?Q?dVQFy0AobqtwQyLC8bw7zOGT4ga+iM/0VUfqhyCCowzOP6+ZZ1p5vSpJ48N5?=
 =?us-ascii?Q?/ZkQSrigrRmcV545cBj3T5SPpaFJcIeJlp+PU1syiEBgLiej7fZDkCwy5uov?=
 =?us-ascii?Q?ItLRea9xb4f6KDC8QfN8AR0o6o8giNsej04NnssjhXOQlBmCgSnV7DhS5tRG?=
 =?us-ascii?Q?IeqWGUFF56VuC/v8ATm3vO1Id0wRWkdkDl4gWwMfruwAYtD6rLTZpPzSQo9B?=
 =?us-ascii?Q?+qdEDaQesCaOk/Iw4PbYvEZyaG6LkKgra42y5dHBbMarGGTgc2kh42u7Wwkh?=
 =?us-ascii?Q?hwN7y80bAwwalZ0rah80Dd3v8RCby5+dGIrMLACEBf7PUAIiObBQ9CbmPCwc?=
 =?us-ascii?Q?9SDe668yEDkRlE6EqRhwrMJ5d7dU/6xnRgNefSkFS5JztWtLoNAyC1+VWmBa?=
 =?us-ascii?Q?gJAYvgQj4UPyYdsThLAyhLjFddYSaAvw6PXTEeKf9e51zPHJzskAGcSlz9A5?=
 =?us-ascii?Q?H/ftzXorY6UK0+/Ui3k0Y5L3vHp0i9ZqXIgp6maZ06q3JKteif8vOUOjQBg7?=
 =?us-ascii?Q?NJiSRjEUq7pEkIUzBkhG55EenvVY6u4Va1vNzBm9cZdFdVmbYF6QesMkwCcV?=
 =?us-ascii?Q?qmtWQnSbtzreICIc9TFvC204lbaLftVtDW6CMKc+mgPFuX0H2qj8OgMbREAC?=
 =?us-ascii?Q?lfwTd9crUlod9itEgdJMoU1wpPAAH1H2RnSnn0GYVkl4zA3butwTT8nKv77w?=
 =?us-ascii?Q?sWgXyHgSsnjoPI6NX3NxZU9xX/l1lVr+PVN1nrqPoV5EpYx8++KSGP2r3G2G?=
 =?us-ascii?Q?dhctBF4pLdIr0QPQgDLs0vPdvfWNxTgd3K9InkV7LpOqr8CpoUd0rYhUJfxx?=
 =?us-ascii?Q?DlwxEMFjDFU/6DUDwivQNI/qlPrTTT5SdxNOpIkbbVU6WfPY44V9Mq7pNP2Z?=
 =?us-ascii?Q?gfe2FATWtDeEH+oil6doVoidobB/XKjJJ8eH1NPb+hpm6/ssvYLz2ncsBoSK?=
 =?us-ascii?Q?GRVm1sLHSJcRxCDFtJaptc5I3thRupqrnewih3IIWmNe6nJ5icssA3B2o4xS?=
 =?us-ascii?Q?lu9lpEENLGXnUEjSoEhBez+3PVPmyx4CrepMlOxwA63Ar6LHZ3YCp9PSV/WV?=
 =?us-ascii?Q?wr5+0tChFEY/L9l0AHs=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2025 19:29:06.8517
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 464dc78a-aefe-4dc9-06f5-08de2d2210fb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF0000468C.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR12MB9484

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


