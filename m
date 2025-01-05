Return-Path: <kvm+bounces-34566-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 93AF7A01B00
	for <lists+kvm@lfdr.de>; Sun,  5 Jan 2025 18:37:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C132A1883224
	for <lists+kvm@lfdr.de>; Sun,  5 Jan 2025 17:37:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADCB71D2B34;
	Sun,  5 Jan 2025 17:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="N9emWpnX"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2049.outbound.protection.outlook.com [40.107.93.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4307B1B78E7;
	Sun,  5 Jan 2025 17:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736098608; cv=fail; b=GxkyPKBDmNPBrpPsf5cvJvQW9542U+/BvdSdfO2eIRZel1722sqfGf0zoDrzAETw6P0FixhfsiqFY298AqrBPYN65fNf48y1+kSrpdBr7dymYg2nsbzePTXbJEzLbPkLmXC1c9av+c7UTe80nTaa+UmottfmPz7PizEvq6/Jw6o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736098608; c=relaxed/simple;
	bh=cgXiWrFhQLuSLkfFaNXPRFts8ycg791H6KbZdSA/iX8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PcJUl4BWLdkwpq2uSH7m3rQeso3h4hG3ycBQfISndL/C7Jz5FRxgveqGnQcHQBh4TmY0Yy1RvazayAxaDiLwuxPJDKTCpGNsR62AOvqL/u8MtCbUmiuLIuvDp3mPaz9UHOSv2vc8cxMDIfIy3B8UDPo8t0dqnXgUv277419nUCo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=N9emWpnX; arc=fail smtp.client-ip=40.107.93.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y3N7QdwH6XlLJV8dsUgStnfB/j4KagDfLJE0vwBP3Drl8j7n86eVYqLaXrD+TLOLpBRW98Pb9GtVDcUNyAJaKzv8NXxcpzae8DTYn3VVJX06IEhOtqbQLuxrvM1wexHigPuWQzt0+v+O4Qhd44mogbbtpM/nhfWctev/euL4xCGeRhfRt1QFS/PmZ5u+q5uBsHeM2z9H9hkZdBxc8EeCZTGKhqwEuU9kBRGmNhNhcwB2X28uxjX1HY6YMgjx7ZJnssvuHahvt2kW37Hs2g2hAeqDkDPG58l+du/vahow7dsS60blZJEODUDzRDuwjrW2N7TnOMXZfymsscB2BiW43A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fjagFNjikymqQEyVxrxsGo4yS7eFhK2gXlYC0Zt2ci4=;
 b=kjbzgl5x6auON39/sK3yZ7V5h63PQ53E0WzMTDeXeRyPscyOd+8r6ZljzalZmslN7vQyZXgyKQJQE3uEPmmEnXyw+BeiJ0fsJL6yEjw+OqkZY85DLIFo8lla7qXmxvBRDu5vInAe8s07F+OWjPjar3fJ6/68bdEnItTxMzomyiFAx1qJeb4TCwAgjrLT3CPcq/te7QTwsdA7Npu5kwol/m5g80bTUrbbxGw6N0SinTnZJSwBGenaGRzZkjmIM5Wb0iVbiqgqGjcUiwhMBqZ37El9K/V+Kl4+0brQiOePnxydpX6+Mss+NgghrictnPKLj/P3k0GewWJuPgq5I0aEng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fjagFNjikymqQEyVxrxsGo4yS7eFhK2gXlYC0Zt2ci4=;
 b=N9emWpnX9OL6O+8uW263SR3iJalBL7JivL6rmAwMseUpheo3Kgzlt0GVPNQkEO9OH6Q2v3N606g/sI1xk0WAJK1q9I0aCfeCWkDjFuSBmIv4PC5vDphJklGVRT9aHqQdOF7GGJQ56N2tVgSVtA181NgLJYEZqU86RALVqsz6ZiFXTjktuKMQ12Ar+0qiv3qBLOuq1ZkfQ34ajZygUruKOsNtg4KNj/j+TysNj86N1mMwq9q4oeSiUOtCk1WW0KVBLPX+0xTcDcExwhiCUE3MjZaxkJ25O+r6UhWm/m358ii3LF7Ur93pnFBLHU+9W9X7WOo03BHicYwqIZb86qyz7Q==
Received: from BN9P221CA0011.NAMP221.PROD.OUTLOOK.COM (2603:10b6:408:10a::31)
 by SA1PR12MB7294.namprd12.prod.outlook.com (2603:10b6:806:2b8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.16; Sun, 5 Jan
 2025 17:36:35 +0000
Received: from MN1PEPF0000ECDB.namprd02.prod.outlook.com
 (2603:10b6:408:10a:cafe::42) by BN9P221CA0011.outlook.office365.com
 (2603:10b6:408:10a::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8314.17 via Frontend Transport; Sun,
 5 Jan 2025 17:36:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 MN1PEPF0000ECDB.mail.protection.outlook.com (10.167.242.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8335.7 via Frontend Transport; Sun, 5 Jan 2025 17:36:35 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 5 Jan 2025
 09:36:19 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 5 Jan 2025
 09:36:18 -0800
Received: from localhost.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Sun, 5 Jan 2025 09:36:18 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>,
	<yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
	<kevin.tian@intel.com>, <zhiw@nvidia.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<anuaggarwal@nvidia.com>, <mochs@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v2 2/3] vfio/nvgrace-gpu: Expose the blackwell device PF BAR1 to the VM
Date: Sun, 5 Jan 2025 17:36:14 +0000
Message-ID: <20250105173615.28481-3-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250105173615.28481-1-ankita@nvidia.com>
References: <20250105173615.28481-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECDB:EE_|SA1PR12MB7294:EE_
X-MS-Office365-Filtering-Correlation-Id: cf57a8bb-c8ed-4530-66d5-08dd2daf80b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PNNC2uozmtImBLV8fyTDvRVkHbqLbn2daF3MPC3wv185aUObqkT+Y6I+FdqQ?=
 =?us-ascii?Q?cdE6OMKExPWd+CVXq9YKqKJdmWcV2kwMfBMU3UTCPowKzYPBWeUdp3XPc+zq?=
 =?us-ascii?Q?Im4NdL8S0RvjA9UwDtLsGcmuYJZyW7GV/e/zKedBBXdbwaeZcF+O1hi7T69k?=
 =?us-ascii?Q?61j3s29qqlTt1ZIOH3ZiUX8l4MbMOr5KPiO4ba1aAib8MwMDwFHozaQ7WcyH?=
 =?us-ascii?Q?xrDv0U+BRtqOzcxiDuBneCqFH2FIGc9JC0Duxpu3GX0G00z2TNTa0lWMsDqi?=
 =?us-ascii?Q?GI4+AWzEqFMaF48Fz/FebN6uRiMlyUWxfeOuqEbShrii2pnRYQBKYwttkDs7?=
 =?us-ascii?Q?gaIkRmtgajuF9IwxyQfT2Wo7Z9sVi5mV1vn3na1cb46g8E3t9SQvgsy1mF1a?=
 =?us-ascii?Q?iN+dhpu0tKU5tfeUhHBt2Xu57Mt4v1WcCU1HsMDCrgIlOhyfCTT92W2SsU+a?=
 =?us-ascii?Q?bygUVczN+98VIzomKrfCRCp/zuRRdfF9JR2iAWPzc/EKNSjn8HfFCWC78oa7?=
 =?us-ascii?Q?48VY73XiLJQ2TE31xQ1pc/yzW1lK0EX7fufJlRnZ9KW4lkAXDPHnp3+Xm7qy?=
 =?us-ascii?Q?LMffiPoH5X2MFt1av3hSOhpB7FcGngO1o9X3jf8WcxJ6EVePLC0cRI0P93qc?=
 =?us-ascii?Q?dTICi8KOm9YKd9AXlqwHFfj4jl72NNk68tQTJHUpOzygtSOmE2/Y16t53x+f?=
 =?us-ascii?Q?Yeh67JM6npAcxzErR+PF+SjJJwliM4G7cco4lLPCVTHYRwt6vI+NLsKz5VOp?=
 =?us-ascii?Q?kXZ2a4YVL5LcWcDCuyh3Gp3gKXPwU3rOFsUFO4ZDLyIBNa7leNAHLfBt+GlG?=
 =?us-ascii?Q?td4KoEwIxbJGu3S5owzkjrb6TkDu4n1xfkKh/NvQmXWvsNp6hxAQsN00Ub3B?=
 =?us-ascii?Q?b3HkXes6F0/cTQGsDz+HHo/lMsVb3TByDrkzU0PFblvKDjeD6hZgJB88jeNQ?=
 =?us-ascii?Q?zSbE+HNF9XQrdsk4nUBsNsae2cVBAL80lDMe0IZKiVO2OGfWttxWrsNxCF06?=
 =?us-ascii?Q?bEwSqBdYmpFLYriTFb6qE9RpnF1mEjgKKk2NsBtXK548DcJVqO6aJZfaMR2Y?=
 =?us-ascii?Q?fIy/DFabIF3xF0RBWgo/Ps6CYs5U3zIW2wRtpsS05TtIS+iymWHL5kBgoTUv?=
 =?us-ascii?Q?A3+zzqUbD98DFevvaxZVVRJsZMIwOMfasj/dmdzBTVe7EWTWufKIzZnG94me?=
 =?us-ascii?Q?bbtFk0jt4aGzRKddlRoWCnVHQvM919qvkN9rBHnHJaC5sNKRIDzxIE9R8xT9?=
 =?us-ascii?Q?p9xaKNYwKNmUwA1TyMqHa9MItc0Xkgwe0fH2IcBAeVrMCBQ1IdP5tvAwDkco?=
 =?us-ascii?Q?bIgfqmGrhzCt3nF4kzSbHEUl1QBxY1i5+NCYKtdnV4isDms3OSXg1didkq4+?=
 =?us-ascii?Q?zD6OGHlGfVySh+JML6JVNyJqUldu3cpA6YbmJYzKlJzmOHPOwqlBOytUXYqX?=
 =?us-ascii?Q?UXT1AzAR59Zu+OxBYncLFZsGBceyGw3MC48mKJZLYpMnjrQX1HOOhiEQ5d7z?=
 =?us-ascii?Q?imB56vJP1wjN5p8=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2025 17:36:35.5861
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cf57a8bb-c8ed-4530-66d5-08dd2daf80b0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECDB.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7294

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
index 85eacafaffdf..44a276c886e1 100644
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


