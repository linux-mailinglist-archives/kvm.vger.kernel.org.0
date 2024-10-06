Return-Path: <kvm+bounces-28032-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D54D991DCF
	for <lists+kvm@lfdr.de>; Sun,  6 Oct 2024 12:28:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4C8701C2130A
	for <lists+kvm@lfdr.de>; Sun,  6 Oct 2024 10:28:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B292F175D54;
	Sun,  6 Oct 2024 10:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ei1IO+el"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2067.outbound.protection.outlook.com [40.107.236.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D2416EB5D;
	Sun,  6 Oct 2024 10:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728210469; cv=fail; b=sI8Rkewj1TQqKekWlzt80L3NedBDfiqjrJ6w+b89kiGAGsjDTFl7ZHHXP5lawY+8NH3BUVDCDOvR2MhOCpsEGcK5CBzHl8Xs91Tt3F1QAP/HxmH2Z+ppetxy2yi9HUSEAM/DWa5jOkubPmeBaeQN2GyAc5GS4okGt0tC6xJiXog=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728210469; c=relaxed/simple;
	bh=8l9bMb+ZaqTAYNwmZK/0UButZ1yNPiE1HVdgIhOuvYQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ABVXGrHnN81nPkfdmAXl+bIb25BD8mzAoY+pf+wleS1qJYvg+AIyzJrgaQFIsve6LuTqKKNxTiaP0esqGrvI6U/RLctFjhFKt/QM4T1xyfaIukoMyGjgommxp8w91qsCEQiV9YsOe9WVro91qEgqh3ai0ucboYGUmTbRb7G3Noc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ei1IO+el; arc=fail smtp.client-ip=40.107.236.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oURZuD4BOGPnUjSJpmIqaBB8K6aOFRbvrhxwMQsJryoGNWeSRM5uii9YU3cykGdzgHmdXi6AKTTCnx+kvSGxpNDyGpZdmFqjxwlHo4NkjyTmRYZUSFrhv7ZKFjDbzwWJqgeO2k6XZNvRsAhFN20FuFC5MFIagkoxoDo59EcMnvo6+Cjzen26nmvcpTcSG6YVUfJ8vbdskFqBKfyGgDgKIK9etPZxQ7w3Uryns2F61nQENNB1tipbiYdyRCBV9TmyP3QCm95GfCMe3u+VjXi53xE6eiEluy1ARHSyj4RNwfGPegn63+VDlOFsiWYbfIAIrojRlW0Vh+loKa1yD0NCmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/4NHjFxo4NHjN1iioXvOlLG6qZsThEK9b4DV/Jv8adE=;
 b=huoOHyQWuzy3CALYDBA9m81GsVBmfblyU6sIKkRhY+f5fV03EfmkE1qFMtrD706AS0G/fxMG+jG0UuTyPoPJXGfEuAT9FrbkjT69/im4HK2mSN3/0ryPkBIKTxBJBYy71xE5IBgdSVTfblJjMmuBetOGETYRs3b33UM9CYwahEckVU4LGhmmUP00Uiy3uy+TIf/K3qyfUq//iep5ufBFl4i+TKLdoPMDY7J0y6tqOt60eRLEIAFoUiS+qhpB6piCe54OL5BPAaJFfp8Pxp4YdNWd+yHKK59SweDmYx7JfmRRYu/Ykdt36dDRzz2MsVk5t6jFYKKUaFTDIJO6WPzUxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/4NHjFxo4NHjN1iioXvOlLG6qZsThEK9b4DV/Jv8adE=;
 b=ei1IO+elPOgrVD9olkP50nK00gR4zp8BzrnmtqbgKVAZY2iTZrjBhznEk443CJh9+r8n7s5yOf6X+Ay7uy3ejomHGnNdPseG54BVp1zqBOLkRoXpUKcyVGUUV0jOKMJ7wxnpO7kfh7+TNb6smsB6YqEMkwrC+xLenFg+Yiy039oeAxJXhLHwMhCHhVpDgisHbvRtC1Q8w8hS6ISiOU9LOuS/JJFqonixUxR7V+UtgCbSaog9eRMhKjyDT7zBnMt8LqxGs8DSdwxac/ELOHgjj8ru6yiNlvsBFEGRQnv2TnpKoeseRfN8+jkBK4aHtRXT0xzt0Jksq+jFD07ptMlfzA==
Received: from BYAPR05CA0035.namprd05.prod.outlook.com (2603:10b6:a03:c0::48)
 by IA0PR12MB8694.namprd12.prod.outlook.com (2603:10b6:208:488::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.20; Sun, 6 Oct
 2024 10:27:43 +0000
Received: from SJ1PEPF00001CE3.namprd05.prod.outlook.com
 (2603:10b6:a03:c0:cafe::6f) by BYAPR05CA0035.outlook.office365.com
 (2603:10b6:a03:c0::48) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.12 via Frontend
 Transport; Sun, 6 Oct 2024 10:27:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SJ1PEPF00001CE3.mail.protection.outlook.com (10.167.242.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8048.13 via Frontend Transport; Sun, 6 Oct 2024 10:27:43 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 6 Oct 2024
 03:27:42 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Sun, 6 Oct 2024 03:27:41 -0700
Received: from localhost.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Sun, 6 Oct 2024 03:27:41 -0700
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>,
	<yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
	<kevin.tian@intel.com>, <zhiw@nvidia.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<anuaggarwal@nvidia.com>, <mochs@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v1 2/3] vfio/nvgrace-gpu: Expose the blackwell device PF BAR1 to the VM
Date: Sun, 6 Oct 2024 10:27:21 +0000
Message-ID: <20241006102722.3991-3-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241006102722.3991-1-ankita@nvidia.com>
References: <20241006102722.3991-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE3:EE_|IA0PR12MB8694:EE_
X-MS-Office365-Filtering-Correlation-Id: ec67c07b-9e28-4594-b6ea-08dce5f1833f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cOHptfGqwol7YgZnPHv8xEtBsCC2sqBbCn/E+OLrs1yw9JDDme6llqCZRlWu?=
 =?us-ascii?Q?JySI7CN5NIE/V4IyGnHK/uLQdkHtpXIfFsbOLmk/YYT054YpgyNuUlGNz9hn?=
 =?us-ascii?Q?McjbOumGDBGCpU0/PLP8QU9WwQhV37O4aeQQUdGVNLfdg3gO/LVYWdQBsnLY?=
 =?us-ascii?Q?dSM5wK90cdt/EJxCp3ktxsJqvgJwK2Y58OP8oj/ThPbKLmzrMXQZHrgVKCYy?=
 =?us-ascii?Q?5/sDz6hEzMs9Wp78HiC2QwCqE3vuQYP3M4IpCoiuiizD5GPp8rdQ9h4dcVep?=
 =?us-ascii?Q?Aks038Uew+6ofE3UO5ZqLOXmVuMkeUMeQh9BApgXb1lMLLYu6vFCLnjbg5UP?=
 =?us-ascii?Q?F7n7FU1JYZqcqCfCD1VSAh3CMCJ06FfmuQqzeZHI1uCiuBpm9/wCVrNMi4T+?=
 =?us-ascii?Q?Tk5FcFPK1B1v5CDgZGRU7hyx9HvttDYyoVnB/46qV4IKL7AZgGiZGk1Cv0/0?=
 =?us-ascii?Q?EfUIs5YVILk5vc2HggDdokNZRrLT9aKG8Zz1M8W/+LxRbBRP8D8W7cKx3Ml0?=
 =?us-ascii?Q?os/Er2wZ7mvY3uTWdNBQg4cmY7zEfRKvWxvDX0kv2c/LQOgV6V7i0NGz9avI?=
 =?us-ascii?Q?q0JMEZznmDE0DvPS8C662kfxKmtpm415bMVbedb/s56HWW/EsXKrx2GLM9hd?=
 =?us-ascii?Q?E0Mnq5aqc3trBnLHSZkiit9S+9tFwaJsYPHzqbyojFWGi23JPjVALUs+1goJ?=
 =?us-ascii?Q?M+i/BDmjnHP1gsqIfDEBWODJ3fKlHhQ4lMW61OYEpFerJNNnTk+SxfnUS22N?=
 =?us-ascii?Q?DBCokOvqR0KacVjvEFMsfFawByQTmUvrjKacOc0Ly6GirQMoaQdw/9c57Leg?=
 =?us-ascii?Q?VbosOGu99c/xwIYpMnoCscinHFHrAMjDFMzUaUNJmjMrPZvQX9aQZDFfulxm?=
 =?us-ascii?Q?sYN2uEzLcdvMHQGbca1kYh07zW8cB5ZZkdprvXknO+qfUq1e7M6Z5rmuy4Do?=
 =?us-ascii?Q?+cF5y82is75dzi9szhREhZPoTEuJio1XzGzNf1yY6PkwaJIvxWEvIQ2c2oUH?=
 =?us-ascii?Q?5xkAT7WLTlTmHZFjGLWBAG9JpuEwH9wWg0ecGJqI4LI4XApMz58heFkgsFAH?=
 =?us-ascii?Q?eSniBFlx4oHEVnrzKlaya+R+lVx+ogHPSV3Ls2uM4yWMC0r3+BML4gfe8/UX?=
 =?us-ascii?Q?zuxTF/2hLaV4LMKKu/MyXaMuXqs12KxvggFPjsW3en56r/q8D748aUTk46U5?=
 =?us-ascii?Q?tBMm0ASZbZ7VxokvOZBKUQJVUpxuz/n6xzYZIt/1Re0XXDicLF221FzGOQW+?=
 =?us-ascii?Q?mkT0zC4p/WHNtH96PDFvRfyRdL2vbnFNyvdF/1ICCOi+C9g2VQZ07rV373IP?=
 =?us-ascii?Q?DOTqLNV8yhOS0TdcQ4Gl8kPYTikBHwchuGtgTHnJZHjooxCSPdwd8cR5BMXl?=
 =?us-ascii?Q?bgba/R4idodc2ZcoTUQVKofXx8ve?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2024 10:27:43.1012
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ec67c07b-9e28-4594-b6ea-08dce5f1833f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8694

From: Ankit Agrawal <ankita@nvidia.com>

There is a HW defect on Grace Hopper (GH) to support the
Multi-Instance GPU (MIG) feature [1] that necessiated the presence
of a 1G region carved out from the device memory and mapped as
uncached. The 1G region is shown as a fake BAR (comprising region 2 and 3)
to workaround the issue.

The Grace Blackwell systems (GB) differ from GH systems in the following
aspects:
1. The aforementioned HW defect is fixed on GB systems.
2. There is a usable BAR1 (region 2 and 3) on GB systems for the
GPUdirect RDMA feature [2].

This patch accommodate those GB changes by showing the 64b physical
device BAR1 (region2 and 3) to the VM instead of the fake one. This
takes care of both the differences.

Moreover, the entire device memory is exposed on GB as cacheable to
the VM as there is no carveout required.

Link: https://www.nvidia.com/en-in/technologies/multi-instance-gpu/ [1]
Link: https://docs.nvidia.com/cuda/gpudirect-rdma/ [2]

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/main.c | 32 +++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index c23db6eaf979..e3a7eceb6228 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -72,7 +72,7 @@ nvgrace_gpu_memregion(int index,
 	if (index == USEMEM_REGION_INDEX)
 		return &nvdev->usemem;
 
-	if (index == RESMEM_REGION_INDEX)
+	if (!nvdev->has_mig_hw_bug_fix && index == RESMEM_REGION_INDEX)
 		return &nvdev->resmem;
 
 	return NULL;
@@ -715,6 +715,16 @@ static const struct vfio_device_ops nvgrace_gpu_pci_core_ops = {
 	.detach_ioas	= vfio_iommufd_physical_detach_ioas,
 };
 
+static void
+nvgrace_gpu_init_nvdev_struct(struct pci_dev *pdev,
+			      struct nvgrace_gpu_pci_core_device *nvdev,
+			      u64 memphys, u64 memlength)
+{
+	nvdev->usemem.memphys = memphys;
+	nvdev->usemem.memlength = memlength;
+	nvdev->usemem.bar_size = roundup_pow_of_two(nvdev->usemem.memlength);
+}
+
 static int
 nvgrace_gpu_fetch_memory_property(struct pci_dev *pdev,
 				  u64 *pmemphys, u64 *pmemlength)
@@ -752,9 +762,9 @@ nvgrace_gpu_fetch_memory_property(struct pci_dev *pdev,
 }
 
 static int
-nvgrace_gpu_init_nvdev_struct(struct pci_dev *pdev,
-			      struct nvgrace_gpu_pci_core_device *nvdev,
-			      u64 memphys, u64 memlength)
+nvgrace_gpu_nvdev_struct_workaround(struct pci_dev *pdev,
+				    struct nvgrace_gpu_pci_core_device *nvdev,
+				    u64 memphys, u64 memlength)
 {
 	int ret = 0;
 
@@ -864,10 +874,16 @@ static int nvgrace_gpu_probe(struct pci_dev *pdev,
 		 * Device memory properties are identified in the host ACPI
 		 * table. Set the nvgrace_gpu_pci_core_device structure.
 		 */
-		ret = nvgrace_gpu_init_nvdev_struct(pdev, nvdev,
-						    memphys, memlength);
-		if (ret)
-			goto out_put_vdev;
+		if (nvdev->has_mig_hw_bug_fix) {
+			nvgrace_gpu_init_nvdev_struct(pdev, nvdev,
+						      memphys, memlength);
+		} else {
+			ret = nvgrace_gpu_nvdev_struct_workaround(pdev, nvdev,
+								  memphys,
+								  memlength);
+			if (ret)
+				goto out_put_vdev;
+		}
 	}
 
 	ret = vfio_pci_core_register_device(&nvdev->core_device);
-- 
2.34.1


