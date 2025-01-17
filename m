Return-Path: <kvm+bounces-35789-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF8BEA152C9
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 16:23:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 29E133AAB1B
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 15:23:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCFAE18B463;
	Fri, 17 Jan 2025 15:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="s7IJLzqu"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2042.outbound.protection.outlook.com [40.107.220.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA7214884C;
	Fri, 17 Jan 2025 15:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737127424; cv=fail; b=DCRgD3gcsGJ9eThhAo/kEpgZHFp53oFq+IsuSaW4atMnVS92G8Ks+xBA3nQrDUcWuBMFMWybO5jaU9ARQbhY0GIQMeYJDvycmGcR6YXAGwzvrDCbrYkDrYBHZhMlYdpCtX43OCIfP82bnx7BlOfmJRCrt+oUrCbZUsgWv50R+j8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737127424; c=relaxed/simple;
	bh=oTqSjUNPKc2hWTkiifi1QHku6/ovyCfN9jTtUcrAKwI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JK3QL+L1m/it6tV+6JtGNWYLMzTIq3qefvNbktHN13ptze9VBrs9Ab7/+/VExKbUOig3n7pd/W17lNyC4fqfXpDiSCoT0Bu6jATAvozkv5HK/EB2PrBaJJSXq17qHek5mP05QBbntga0xDbL66ZclIdDJ75ZRdk2QRg9Ghl8pVE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=s7IJLzqu; arc=fail smtp.client-ip=40.107.220.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=db3EAsoaS4ShezDR+vbfAPWEgwOn4igcWi3OZa5WdMok3Aft+E3sPGc93vAxNvE9aE0ES7BTllCnTXXT9JUevP9kLEmLadRk7Yl3gBPUXsQZ/dqni9q66ovqtRKHaG3JFstQVsYspIVMAEBoe7rJ1qUz+hZjiV6Pne1QDj6dBECtyNkegvFBU5epAsXxUE3Pikhv8D6c6w/WtZHZVwdF9yldmeOUcyI41AbG/lJp+wPuTr/LpPx2vuI+R4XcE9MnsY7aPMeAAj2aFxDWlQuzuDpOmNz4aRN+Gb435RqwFck7gac5vhaetslssyzkvGjimEKDkIVdnFHGxowZs823Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qffwY23EfEyp7g+papOhQngDJxXhecSORntnnXFKwXw=;
 b=psDEYuaJCUoApDuoYh5pZ2kaE04eTKeUK7JH/E28X5lIbhF4GzVN6+bt7P+tTM00EAFZG7jw07tTcMriT98WkhSrMlBhah1IzWpc7F5VQVAlJQw8cFKaiTqOG0RQSWq+0yN0XJ8YZdQXBpdmyGvOsbKqXh7fjJXakRtdNIIdLcpZpNUYdL7yUuVOtlvq6IznzNaYywxcB5a+WTaVDNU2PlO4lzRFj4XouP2lFZ/4iEZpRxYWv3S21CQRA+2iMmvghSaEQ67Rk9NcUbUQpEzyuUrScuzNN0foRpb+ih0W1RH2vqaBolakXpTD0eVTLIh4tPhRD02G5k/nVWW0C5Lgaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qffwY23EfEyp7g+papOhQngDJxXhecSORntnnXFKwXw=;
 b=s7IJLzqulAT6Ql+n8m2hAUKWn56Lf5ldjFQ1Y/XvcIIUkDlHFl1bip4PnOlMw0kuduFj+EctD2oYmHN69XQmEZgNTBQQ1atDu4I+h8jJty/uh03qxiJYlUb1j8rDcz7sXdh6hubAEX43hxqOPH9eKwmsD/2DMZHQH9Punbhbq/XP5T1d/JBJ72IvPUfX81VrRkFPL9heBYLl22Vjp8ritcqwlHnSVzs1XlLWuj+TR02vlqA7oD+pDAXoWteftMNYkLpNQL9fe5l7qIHE5KazOfWCrsPJ3Bm7eC/IyTvWmhZLIC/POlVNfXN17RrzKg6hJ8Y3GCa4YajO4vx/r6speA==
Received: from BL1P222CA0024.NAMP222.PROD.OUTLOOK.COM (2603:10b6:208:2c7::29)
 by DS0PR12MB7608.namprd12.prod.outlook.com (2603:10b6:8:13b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.17; Fri, 17 Jan
 2025 15:23:39 +0000
Received: from BN2PEPF000055DE.namprd21.prod.outlook.com
 (2603:10b6:208:2c7:cafe::e7) by BL1P222CA0024.outlook.office365.com
 (2603:10b6:208:2c7::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8356.16 via Frontend Transport; Fri,
 17 Jan 2025 15:23:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN2PEPF000055DE.mail.protection.outlook.com (10.167.245.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8377.0 via Frontend Transport; Fri, 17 Jan 2025 15:23:39 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 17 Jan
 2025 07:23:38 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 17 Jan 2025 07:23:37 -0800
Received: from localhost.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 17 Jan 2025 07:23:37 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>,
	<yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
	<kevin.tian@intel.com>, <zhiw@nvidia.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<anuaggarwal@nvidia.com>, <mochs@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v3 2/3] vfio/nvgrace-gpu: Expose the blackwell device PF BAR1 to the VM
Date: Fri, 17 Jan 2025 15:23:33 +0000
Message-ID: <20250117152334.2786-3-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250117152334.2786-1-ankita@nvidia.com>
References: <20250117152334.2786-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000055DE:EE_|DS0PR12MB7608:EE_
X-MS-Office365-Filtering-Correlation-Id: c40e014d-8203-4cc7-e439-08dd370aeb42
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KEaaohj+2jwqs3XgjwxxP5MGnJiSzHvxw5jScKEpixcamTUSTnKY9FmOgE2X?=
 =?us-ascii?Q?FbpZ633Pqb/eFAJmf+SL4O74jyr7UNE7a5Dj+p8k3HsYyRodGzQr61RQpRSh?=
 =?us-ascii?Q?Qp4FmcXR8dcKFsdb1r+ciavnx6HvaqS1D4kFmGJiZHORoOjL7QDSRN2txXfz?=
 =?us-ascii?Q?HAwytVdgd4Q7Ox/MmLKZhlab73Yg43FSx9BJKKaZ4jt6XKelQ1qxyGW5XugW?=
 =?us-ascii?Q?9I25DsHSlufn+izhx9TUflmZcNYyCfLKA2utUvEAk+lsb58Ub1vzBWSmhiI2?=
 =?us-ascii?Q?wHWuLpb0nnp0rfRR6h9Af1vAzeHv93aiHbCojWdQeBrMjMynyVbWCNoyEJeg?=
 =?us-ascii?Q?vaPnjWGNbepMBTZjJ4MZRNceXl9ji+UoVoPAObqxzIeFgOfJhylIO5xgV8mC?=
 =?us-ascii?Q?jwU5YBaqPvIVFtPaH1k77LkMjK9uGWZKQvz3qhTDDeP+1JNYvY3PEB0QY7lO?=
 =?us-ascii?Q?BKKX2pB+twRfxkPvC5piGqwFtyM5vnd1djFQsmbf1UF8LpstGv2C2dE/MEkv?=
 =?us-ascii?Q?7l7Kep08TbrWkPg1xxAuszHR+dF5VlEqNkiWKd/ZZnFF1wVSOS0cJ89b4fT7?=
 =?us-ascii?Q?AUGFRz2BHWRvjUGiv/A+QOcRFye0uQ7S+kkANgL0mMm0MuFv3wfQ5G4b4F1j?=
 =?us-ascii?Q?u/V90xn/dXGG1Wh8HvQhVVYtZ8WzhuXj3tfG08gJs5RcMSEJFnxHBVDBWzeU?=
 =?us-ascii?Q?hHoFGDf6wvSWdqf2UuoryIyY7FfcPmlWzugMMFWBmHMI+YyRiuhanuTnC51b?=
 =?us-ascii?Q?Mj80uB6kfh/KteCiHgGprNG2aASq9xeFUVUDLFRjOizdXFrApOY5pSebOqyE?=
 =?us-ascii?Q?gJsopFCfYAIHNaQdhKZjfQGt4nnZ3mURK9ALuIpKNKnaUTCCGIK5VTYRKdJ9?=
 =?us-ascii?Q?7VkkQZ5vHfTGU1f7U6cCXE68sJ9BKKkEnUnjyVx6gMyfrb6CSdhsCxyKzYhC?=
 =?us-ascii?Q?a67pYg0J/2XmSSEc0iP3zqphl8fbFKegjO7oknxmCG9HNhKmTeWwIMvdp9JA?=
 =?us-ascii?Q?qUxSF3TAmiVL1MfgZZmDD3gR8MepQcEFK4QMCR8osnMEMjv7LyJggz35HtyL?=
 =?us-ascii?Q?OXaCPOxDlNTxq3hgHWDSMbT/zHWTDugdQ3+i7HxREHa915JOe9TTncsYGR3P?=
 =?us-ascii?Q?PY43C9TBCgu9igfTVozXEhQU4Orr2S0ys9ypZMwgcn/5iRoXQYKnD5Vij8qs?=
 =?us-ascii?Q?EyjsvHSdLm0wPDKf9WF5u0wGFc2W6byy7Ygnv9LwLpz8ywrrlIwKA8LfgaQa?=
 =?us-ascii?Q?pArJmHmukXfLRRML5UepoJS8fEo+Bz9n/N4g7jlJsjaq+s0Z1RooWtWv/MPF?=
 =?us-ascii?Q?E6+dRWPqJuatdJjwPqdnkJc0t6rhdXbqj+9hDgvWhqb9TA7pqFiq3vuvbDO0?=
 =?us-ascii?Q?TifZr9ce/L1hiICQpFDemXAsgFVQQTpfjxFPUSG0+nFY8bhTFIhUw17pBqTv?=
 =?us-ascii?Q?fyNwgy2LoreN+lWACb4TsmYTbQVOo9ro7DyUgcD9vUxHUpMdHYo0TVNO9sYc?=
 =?us-ascii?Q?7n9OPFPsPpAeJpE=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2025 15:23:39.0833
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c40e014d-8203-4cc7-e439-08dd370aeb42
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055DE.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7608

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

Suggested-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/main.c | 65 ++++++++++++++++++-----------
 1 file changed, 41 insertions(+), 24 deletions(-)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index 85eacafaffdf..89d38e3c0261 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -17,9 +17,6 @@
 #define RESMEM_REGION_INDEX VFIO_PCI_BAR2_REGION_INDEX
 #define USEMEM_REGION_INDEX VFIO_PCI_BAR4_REGION_INDEX
 
-/* Memory size expected as non cached and reserved by the VM driver */
-#define RESMEM_SIZE SZ_1G
-
 /* A hardwired and constant ABI value between the GPU FW and VFIO driver. */
 #define MEMBLK_SIZE SZ_512M
 
@@ -72,7 +69,7 @@ nvgrace_gpu_memregion(int index,
 	if (index == USEMEM_REGION_INDEX)
 		return &nvdev->usemem;
 
-	if (index == RESMEM_REGION_INDEX)
+	if (nvdev->resmem.memlength && index == RESMEM_REGION_INDEX)
 		return &nvdev->resmem;
 
 	return NULL;
@@ -757,21 +754,31 @@ nvgrace_gpu_init_nvdev_struct(struct pci_dev *pdev,
 			      u64 memphys, u64 memlength)
 {
 	int ret = 0;
+	u64 resmem_size = 0;
 
 	/*
-	 * The VM GPU device driver needs a non-cacheable region to support
-	 * the MIG feature. Since the device memory is mapped as NORMAL cached,
-	 * carve out a region from the end with a different NORMAL_NC
-	 * property (called as reserved memory and represented as resmem). This
-	 * region then is exposed as a 64b BAR (region 2 and 3) to the VM, while
-	 * exposing the rest (termed as usable memory and represented using usemem)
-	 * as cacheable 64b BAR (region 4 and 5).
+	 * On Grace Hopper systems, the VM GPU device driver needs a non-cacheable
+	 * region to support the MIG feature owing to a hardware bug. Since the
+	 * device memory is mapped as NORMAL cached, carve out a region from the end
+	 * with a different NORMAL_NC property (called as reserved memory and
+	 * represented as resmem). This region then is exposed as a 64b BAR
+	 * (region 2 and 3) to the VM, while exposing the rest (termed as usable
+	 * memory and represented using usemem) as cacheable 64b BAR (region 4 and 5).
 	 *
 	 *               devmem (memlength)
 	 * |-------------------------------------------------|
 	 * |                                           |
 	 * usemem.memphys                              resmem.memphys
+	 *
+	 * This hardware bug is fixed on the Grace Blackwell platforms and the
+	 * presence of fix can be determined through nvdev->has_mig_hw_bug_fix.
+	 * Thus on systems with the hardware fix, there is no need to partition
+	 * the GPU device memory and the entire memory is usable and mapped as
+	 * NORMAL cached.
 	 */
+	if (!nvdev->has_mig_hw_bug_fix)
+		resmem_size = SZ_1G;
+
 	nvdev->usemem.memphys = memphys;
 
 	/*
@@ -780,23 +787,30 @@ nvgrace_gpu_init_nvdev_struct(struct pci_dev *pdev,
 	 * memory (usemem) is added to the kernel for usage by the VM
 	 * workloads. Make the usable memory size memblock aligned.
 	 */
-	if (check_sub_overflow(memlength, RESMEM_SIZE,
+	if (check_sub_overflow(memlength, resmem_size,
 			       &nvdev->usemem.memlength)) {
 		ret = -EOVERFLOW;
 		goto done;
 	}
 
-	/*
-	 * The USEMEM part of the device memory has to be MEMBLK_SIZE
-	 * aligned. This is a hardwired ABI value between the GPU FW and
-	 * VFIO driver. The VM device driver is also aware of it and make
-	 * use of the value for its calculation to determine USEMEM size.
-	 */
-	nvdev->usemem.memlength = round_down(nvdev->usemem.memlength,
-					     MEMBLK_SIZE);
-	if (nvdev->usemem.memlength == 0) {
-		ret = -EINVAL;
-		goto done;
+	if (!nvdev->has_mig_hw_bug_fix) {
+		/*
+		 * If the device memory is split to workaround the MIG bug,
+		 * the USEMEM part of the device memory has to be MEMBLK_SIZE
+		 * aligned. This is a hardwired ABI value between the GPU FW and
+		 * VFIO driver. The VM device driver is also aware of it and make
+		 * use of the value for its calculation to determine USEMEM size.
+		 *
+		 * If the hardware has the fix for MIG, there is no requirement
+		 * for splitting the device memory to create RESMEM. The entire
+		 * device memory is usable and will be USEMEM.
+		 */
+		nvdev->usemem.memlength = round_down(nvdev->usemem.memlength,
+						     MEMBLK_SIZE);
+		if (nvdev->usemem.memlength == 0) {
+			ret = -EINVAL;
+			goto done;
+		}
 	}
 
 	if ((check_add_overflow(nvdev->usemem.memphys,
@@ -813,7 +827,10 @@ nvgrace_gpu_init_nvdev_struct(struct pci_dev *pdev,
 	 * the BAR size for them.
 	 */
 	nvdev->usemem.bar_size = roundup_pow_of_two(nvdev->usemem.memlength);
-	nvdev->resmem.bar_size = roundup_pow_of_two(nvdev->resmem.memlength);
+
+	if (nvdev->resmem.memlength)
+		nvdev->resmem.bar_size =
+			roundup_pow_of_two(nvdev->resmem.memlength);
 done:
 	return ret;
 }
-- 
2.34.1


