Return-Path: <kvm+bounces-64136-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 47AA7C7A183
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 15:17:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 9924634897B
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 14:12:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEA4E34C127;
	Fri, 21 Nov 2025 14:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bsmzT3Ai"
X-Original-To: kvm@vger.kernel.org
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012070.outbound.protection.outlook.com [40.107.200.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC8CA337B90;
	Fri, 21 Nov 2025 14:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763734335; cv=fail; b=TSjGcLHdPdYKZxnuZwDxRGwNi0sA6wbtXxYNuuVPbpqrcnlSlmefszS34PNsOh4bZZBlWUWoYJlU7s/a0r2GAMCh8SVSlITfivHk7HUi1r5cPi1RtdwjRt7aO8t3MyMufFuZTdAdUc7KZY61y6/o56IR5S5ZK08+0pwAcI0PqVc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763734335; c=relaxed/simple;
	bh=VyLM6liVDQC9hlNtzFGPHAIgjHrZHTpyKsBlehu8CTc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=COMGrKgchPm6eyzvY/2YV+dw90CEZzSNX6AdA6bWl6m8zyOkmQIcQtXlRFKdZf/VStrnuInNFykIK+3VJjDMDE1CueT7xfWXm6rPfekJ7a8jwvbxErhcDd+CVarwJ9Y9ksfMryml3a5X7k7AaWSKIr+vRG0bTsFFbW2fwiL6gIU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=bsmzT3Ai; arc=fail smtp.client-ip=40.107.200.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N+Wh3zeZnmQugmEZfkul8fuc9o7VnKHHi/9ZggdnbaX0U4MPed0/RygcuXBANjXdt7vqwIijwPTd7kEFvu8UclnLU6miEWXEvwVZ72MA+2yo/h6Up/J+1AvyjoFiukrQACsNGjDuxHx8e6HqjuSGHklHEfIH3Drb9qqltMdHaf5eLX6wyGU1oENXaevY8asIOai6hnVPg36pp76aj0oLEm+ybCiID+P6cEWcDqb1fOq1w9YBtlJ+YdiCBwuZuK1JJQQsxwxR2JZflFQuOKFVntcNF+PegFY4jKJEBIqJ0edOU2OEqsRnOOutWozfrU/qAhsS+1UEz8X1nF+t9auYlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5tpAxSuayLF9nR1BoJltoWgKnaT5kvM4z8pn3GvDtJc=;
 b=aTSEwidzLe0+gTABiGnS0qnU3ECzFDEsxbhzTUxhuyDiBDnfM0honsc1YoMBYCvWSw9tyNSk8C/f5SVD4vX62kgq7Rcmp9kaHw8dTelK0GIhOE/Rrxqkv6iTWH5NPqH8Cub1j6TjoaUEUl3wRCEaSAWSIWDV6WtsmguKJxgcHFJTxCTc3XhkyZa4wWCdJ1+5iPMGX/AA8a9AUQ/6DnHv/D02Xu2NNKHiTyN9ph2+EUEI43jFKnVKxhOGv4bCT/ivybCCoZXcI0l7E1sWmY/NL7c6/ysPWt0XrUiZArWJOwuk4jDwyf/sl7NHj5YkWAEoxAEeZtf1+pIG5uoRWbLnoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5tpAxSuayLF9nR1BoJltoWgKnaT5kvM4z8pn3GvDtJc=;
 b=bsmzT3AideQWHIxP2PJk/cWfHEwTQ5uhIXeOtEnJBkspTmHdSnFYbwIwb5gR2c9+AIFG5sDGXGVWiN8917hnPegDZvV62eFM2NCqmglA5JxNL9f4oGBQjiZW062hCGpHdDnjyzUy6nrcNWeQww4lgSfxo1sBjdqDRHoKoDh9KzIRVe6ElvndLRp5CleVABlpzrrApm6+BU1exwDPL/q9jOB7lQ1q3T6XxVEepVVfYtRW5MxhnshCqZG0z807KTo4AiiywZrMY+nA80VBYp7xr8To7sgVN5AQtj8l0b4v9f8J5el/TFaDaKKjz4/bYb9IqA4fFVw6SljETr9KZgeOWA==
Received: from CH2PR14CA0056.namprd14.prod.outlook.com (2603:10b6:610:56::36)
 by DS4PR12MB9820.namprd12.prod.outlook.com (2603:10b6:8:2a7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.12; Fri, 21 Nov
 2025 14:12:07 +0000
Received: from CH1PEPF0000AD74.namprd04.prod.outlook.com
 (2603:10b6:610:56:cafe::fb) by CH2PR14CA0056.outlook.office365.com
 (2603:10b6:610:56::36) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.14 via Frontend Transport; Fri,
 21 Nov 2025 14:11:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH1PEPF0000AD74.mail.protection.outlook.com (10.167.244.52) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.9 via Frontend Transport; Fri, 21 Nov 2025 14:12:06 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 21 Nov
 2025 06:11:46 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 21 Nov
 2025 06:11:45 -0800
Received: from
 gb-nvl-073-compute01.l16.internal032k18.bmc032b17.internal032f11.internal032huang.bmc032l04.bmc
 (10.127.8.11) by mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20 via Frontend Transport; Fri, 21 Nov 2025 06:11:45 -0800
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
Subject: [PATCH v3 6/7] vfio/nvgrace-gpu: split the code to wait for GPU ready
Date: Fri, 21 Nov 2025 14:11:40 +0000
Message-ID: <20251121141141.3175-7-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251121141141.3175-1-ankita@nvidia.com>
References: <20251121141141.3175-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD74:EE_|DS4PR12MB9820:EE_
X-MS-Office365-Filtering-Correlation-Id: 66335f01-cfed-4bd8-6938-08de2907f3c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yNVIP9YUNbXR8HTkzlgOfLxV7sqeC/5Xqq7i5TZRlXunR93ka5pbMEshVnFQ?=
 =?us-ascii?Q?uOv46wNUAkzF6ulRIqDqRNEUMW2BddOiSZojlBklLWCQShqXz5ZLIqpk63sm?=
 =?us-ascii?Q?A2N97rC9v2UXe5Zc/4aRhmmR0fwW2/JQt24otKJ4xLX4zIJlU30QSC6+WYY4?=
 =?us-ascii?Q?seR2+/7LLssBw2oLoXXWcTzBVeq0hamnFUZdm3KwedvGIsQ5ZfCnbx4M574M?=
 =?us-ascii?Q?NIFlWBPIPA4kHndWL71FY9yIbqU2s6gzpOhUVmxSb4A7h3eTsQs3al/BMyyE?=
 =?us-ascii?Q?JTbyqP3F6qC7qLr5y0gKiqLSrYqi7ke3L6C4DJh5DO+LSjP8B3Ua1Dj7pFVV?=
 =?us-ascii?Q?7X4/y4kfGHBymqWNR43uBRmoc8DE2NLYEYF4EjdF9x7HH817D+3bZw5wdt3T?=
 =?us-ascii?Q?ocL1geVZ5QjH+4y6hgX/9xhYEEjTM2WvFIQAke4fZzV7dJETH8EIbFmiS3lh?=
 =?us-ascii?Q?LVS2BfhLK/txkBV54Z7sfO4Gc86Df55kBCGbI93xwLhcStQ9NW1cyzaJWGZn?=
 =?us-ascii?Q?5+zMfUp6DK+vgYDWaFDpfDzsbsMkJ22XIYDOkwsRl9433qjEgHVyunCiqYXc?=
 =?us-ascii?Q?B9mHenw5eDJA/4iokAkwiQXTbuLE2xoQvLbZ2EXLAYwptJP29PLJxDFO9QGd?=
 =?us-ascii?Q?0oQIMDPSGJbMsiB6mxH9avUBC8FmREg0rEky2nsFd+K1a3HLLoOxS1uBS6uf?=
 =?us-ascii?Q?y9bvgKuRg8FREMNRHY4D1XTYQAsELlkyb5JPdd0v0thekn9lBSmucPTcsTVK?=
 =?us-ascii?Q?bWP+KIf20n4iFTjFo3eytY+fLWKX8ZI0ZatTFsghLjWEuNPk0EP0bgfE3/sd?=
 =?us-ascii?Q?1QRod4Jm0Tcp9eqNpL0T65P8pvfkHEuZgKevr4SdghOHGk/E6Wj/53w4S4vT?=
 =?us-ascii?Q?8aF7AXAp7RatAqePwyFHhI4YGWnvgQ6cc+r5809ZIt7tPv246cftE6hQIxkl?=
 =?us-ascii?Q?syA2StqluGbytjaEXK9q2c9oEb8MLo3BcTyDJVU7WFnWyJh3ij/kH2yh3Xyc?=
 =?us-ascii?Q?IInx2RgjwR1pZGD5a8jrEVjk20vN/o1p841CB2xTwUthYvS8D2FFA10eMJQK?=
 =?us-ascii?Q?ukA13L7BdAE1swhtBF5WraXRx2yBxYKDf6uGFxhfCBMdY9M0ZBXASgnsmzMg?=
 =?us-ascii?Q?jE6791pqLUOp87YRmfdwI/UHPt2ffjsGgveUfatDSZK3tR3GnZQN6aRAte16?=
 =?us-ascii?Q?ETIeDmAFeoKZa3y6TFEn4DyEVRsb5GE8LcHd05tVRLYW3kyi2fLPoFdJ1q2K?=
 =?us-ascii?Q?dKMUchDteu65R+dDrEc0Uli0ZKh9FJqjOIhJC570K0gR2dEIa9ZB6MsO9T+S?=
 =?us-ascii?Q?hn2WRESnRN3ThIdKmRvzdizT+tFqJc3/QUmL4o7yZ37SICl89lNIEpi50ylM?=
 =?us-ascii?Q?qIhopS2mn5H3j9BXwMu150OddDEzx5Bx/HsDZTcN9qVSDTpkRwyYIt8vL5kW?=
 =?us-ascii?Q?ON53PL+hQWJ7P6Gdta4OXeyIctMpcOhTrdz4vMz47Tv9NafyFcVDFXS8VIR7?=
 =?us-ascii?Q?oYn0Rh4TpNAcMDbw2nV5djU1GD+QeqyOskR6JZgt9iI01VXAhOpx6IR8SXoA?=
 =?us-ascii?Q?9pjybJBYJIIvgaHkEtQ=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2025 14:12:06.2639
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 66335f01-cfed-4bd8-6938-08de2907f3c2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD74.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9820

From: Ankit Agrawal <ankita@nvidia.com>

Split the function that check for the GPU device being ready on
the probe.

Move the code to wait for the GPU to be ready through BAR0 register
reads to a separate function. This would help reuse the code.

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/main.c | 33 ++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index 3883a9de170f..7618c3f515cc 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -130,6 +130,24 @@ static void nvgrace_gpu_close_device(struct vfio_device *core_vdev)
 	vfio_pci_core_close_device(core_vdev);
 }
 
+static int nvgrace_gpu_wait_device_ready(void __iomem *io)
+{
+	unsigned long timeout = jiffies + msecs_to_jiffies(POLL_TIMEOUT_MS);
+	int ret = -ETIME;
+
+	do {
+		if ((ioread32(io + C2C_LINK_BAR0_OFFSET) == STATUS_READY) &&
+		    (ioread32(io + HBM_TRAINING_BAR0_OFFSET) == STATUS_READY)) {
+			ret = 0;
+			goto ready_check_exit;
+		}
+		msleep(POLL_QUANTUM_MS);
+	} while (!time_after(jiffies, timeout));
+
+ready_check_exit:
+	return ret;
+}
+
 static vm_fault_t nvgrace_gpu_vfio_pci_huge_fault(struct vm_fault *vmf,
 						  unsigned int order)
 {
@@ -931,9 +949,8 @@ static bool nvgrace_gpu_has_mig_hw_bug(struct pci_dev *pdev)
  * Ensure that the BAR0 region is enabled before accessing the
  * registers.
  */
-static int nvgrace_gpu_wait_device_ready(struct pci_dev *pdev)
+static int nvgrace_gpu_check_device_ready(struct pci_dev *pdev)
 {
-	unsigned long timeout = jiffies + msecs_to_jiffies(POLL_TIMEOUT_MS);
 	void __iomem *io;
 	int ret = -ETIME;
 
@@ -951,16 +968,8 @@ static int nvgrace_gpu_wait_device_ready(struct pci_dev *pdev)
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
@@ -977,7 +986,7 @@ static int nvgrace_gpu_probe(struct pci_dev *pdev,
 	u64 memphys, memlength;
 	int ret;
 
-	ret = nvgrace_gpu_wait_device_ready(pdev);
+	ret = nvgrace_gpu_check_device_ready(pdev);
 	if (ret)
 		return ret;
 
-- 
2.34.1


