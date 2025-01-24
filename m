Return-Path: <kvm+bounces-36568-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BDFCEA1BC2A
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 19:32:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2A12F7A48AC
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 18:32:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEE3C21C9F3;
	Fri, 24 Jan 2025 18:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="a859ZExG"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2051.outbound.protection.outlook.com [40.107.223.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F13C223B0;
	Fri, 24 Jan 2025 18:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737743499; cv=fail; b=W2vEkB8MwA3vhQQVx1NNEq0dPHOLsr+kGn8cWo8snLMX+Qsn/8pnxfpJucDj1FSz5Q0HMRjkF1uKfF98PJHc5pGR6N+btBziGAaY5ErGZ7eUdgJyFcuJb5AlL/ZZK0+wU5yuzKXs/O1Co33GktuFwpnAQVww1BTZhEXHW6ji1Lo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737743499; c=relaxed/simple;
	bh=mVDhl8gc8G/p75pwk3uy78Ni3VAWxdg7CSj8F5h7y5Y=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=izLV+4pnPjQ0fcM6/yihC021hDXg0OY1kMt9obs+hrrisBR5f1tMlI0GfGMX9UD+dqvxSC5CLuE828L7WRGrGlQFc3uEy9LThsTi513o678WCEdtDX6Oa9raYlHNJH7c8w9ffKmWa8XZJGqSfhRYakHItBYdpnafmfiEjpobo6A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=a859ZExG; arc=fail smtp.client-ip=40.107.223.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hyWpZ1YrgqXE/craAYkKDevF1e9T1spThPRLE/+uNlL9x8dWmGgVDmWpUn9OLzq0bmx1L0oA6YkjSo+kBlH/uJOu/lh9AG1WUdL4/V2wbycNFdEk4+U6y7Gof0MPXHthliuBKaTTEmHVBBaV5t5saQn91+7epeNtKccyMVIR7nbZ0rggyj6FXBX7PaAsjXfZsFlCpxVysTdtQWKcQaty1Sgx2tJr5+7PQG8MzFZ2SPD5QVU0d8fQXl7biCaszJ0zK54SSat1j/trHltdwIfYO3owmB6Eg40fjNdl6ov+E9n63aUwu0VVw59mhFZgBnJrcHVwhri020zWSeEiYPPPug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hG2nK1PYoccYYsNyeHvpOdr1J8TvGa6Kd981LFx3fU0=;
 b=IerDI357KAulBfPb4ZChOxy2FwRwsGhgC/B2THPeAogzTr0PnEY9hMzk3phHPfp51XqQ2xFRySxV7+fkyKUpTIpu/icqqdvNTGNH4RRUsgUZpmE53DP4nm7FPLQxmo/Y0JoY6qUtIR7UuOIp4oYN7jgs3S8jXbmMmOZuwdu9dXDMCG5JPMpXoPHHFVDiQoXreWKSUpDr7PIg4efSSg0xA2gclcQubulzOd93t08FqLbkTDtsASYMlz4qACfYAauBMppXTkkEh/SWQDnG6TqUynu2ObK9Xi9s5vokGfmDUUqdPJQu5JahPSxWx+uI/wCzmVl+4JEcmNBIgEys6DclIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hG2nK1PYoccYYsNyeHvpOdr1J8TvGa6Kd981LFx3fU0=;
 b=a859ZExGTkuKU9E0PGykTuZXQLQzQU81tHaO89lZA3xwn6d7Bdeqyt1OkCsw0H8VXdetoO6uiHr4oORuhUR8Eceq7qGNaDWS3R4KgK8AoAxT6j8RvnQ/SYq40HEqvNX/7Ua6ELUyA7rWRa8M02dqB47IdacTVzZ/emUGGzqI6H+vVfaPPasH+LQ9RrQVNhZ1TkmhQ0IU/TKmeCz4jmXb5STKSjv/Udt7CeTZ12H49s8xoHQXuYQJRzZrXXJ6IJPYO9Zn0Rdu0l0MLG2aH+9HXrKAf/PysU/5RsZHG7AMZRsBEe08I+OiWA2tN9037P38soAloBSWUd0UQUQlAhHTPg==
Received: from SA0PR12CA0011.namprd12.prod.outlook.com (2603:10b6:806:6f::16)
 by IA1PR12MB6602.namprd12.prod.outlook.com (2603:10b6:208:3a2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.21; Fri, 24 Jan
 2025 18:31:32 +0000
Received: from SN1PEPF00026369.namprd02.prod.outlook.com
 (2603:10b6:806:6f:cafe::2e) by SA0PR12CA0011.outlook.office365.com
 (2603:10b6:806:6f::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.19 via Frontend Transport; Fri,
 24 Jan 2025 18:31:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SN1PEPF00026369.mail.protection.outlook.com (10.167.241.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8377.8 via Frontend Transport; Fri, 24 Jan 2025 18:31:32 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 24 Jan
 2025 10:31:15 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 24 Jan 2025 10:31:15 -0800
Received: from localhost.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Fri, 24 Jan 2025 10:31:15 -0800
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
Subject: [PATCH v6 2/4] vfio/nvgrace-gpu: Expose the blackwell device PF BAR1 to the VM
Date: Fri, 24 Jan 2025 18:31:00 +0000
Message-ID: <20250124183102.3976-3-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF00026369:EE_|IA1PR12MB6602:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f5934af-697b-4f2a-bd5f-08dd3ca5537e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014|13003099007|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QSPxtzz+1wvXm5jmfmvZgKQVipfO3BB9JrR9bqJ8AilGtL7Tu4DssmIs2yio?=
 =?us-ascii?Q?8AzywcjvJc7tTTIP7RNdYt0UrCwR3xyKb6OQ11tOaEAyzpsGlBpXBfh47JIg?=
 =?us-ascii?Q?K+9+OeN1WgIM3S4frrHwE4B37jIbBIZIY0ym1g53Ihe7QwwqjdEBbD5RyMcy?=
 =?us-ascii?Q?w7ZbOkCNgUuR3TfaOrSLGUta0yJd+3sjXeALGcYrGA597jckyN1jXA9FhhYu?=
 =?us-ascii?Q?vX3Go3pAFlwlI9gVTiXsWIQnofeasYE2MNEzE2BQx+qAdYeZeRATprJdGxsf?=
 =?us-ascii?Q?BzncYRjnVzZgAS5DoTcDpy1daYVfItd2ErQ28y1zDXOB51o46Tc73MPJ3+K8?=
 =?us-ascii?Q?xpqbU7Pvl66irWiV6s39bzd/G4Ej5UT9TmP8ywvywnYLeJliTvVwmhOwwJcB?=
 =?us-ascii?Q?IWow2BlKnM+hIir/BqdBFJo17/kGsHGa6sPlco6XR8hsc5E62O+VhPRHm0r5?=
 =?us-ascii?Q?6Zf5h6Icfo/8dPFCOrEh71aepglSM6N0XjXUyFdbcMhCNKB5e0ItJy2ef7yV?=
 =?us-ascii?Q?pWTnjTNf66/gq8MGOFGJf9EjCqiP0rpMkEud52I3kBp9CNveA/sXCJMU+6Qw?=
 =?us-ascii?Q?q0M/wZgWKJx/1I5gWh/lnwNWistE8TAUnE4HJyEPgWETMmb3mzO8RwUq7nn/?=
 =?us-ascii?Q?1w7oKnM2+QhbAs6UKyXEbwk2JdykMFLRkt9wg5kQ04b+ztUyjL43BZ7pWZMo?=
 =?us-ascii?Q?SLoVoLZhD5vLHSv08POS1tfrSf22dIt7QWZvzNQa37kkrkYQWSx/h8MBIAX0?=
 =?us-ascii?Q?XKHZT+8NiD1XAsEhwa6rNM4m41wH3yxM/pmqas6rbynlCbX6Fx9aWpyPjEga?=
 =?us-ascii?Q?qCOa83u0kNkDT1EuX4VD6+edQehpwdpt12zxkwvwLG0qIqi9P4pGujRSB4Xt?=
 =?us-ascii?Q?95t9eYKw3+oPnxNAFYVPunWyMICHVH5wGew1Krkobl9zysKMVzx5zrFjyC6o?=
 =?us-ascii?Q?SWRTF+g+mrNMCu71FUTVwD6lB1GL5pfpyciUojd7Jbbl5LIhQOkkJ1NA0bOL?=
 =?us-ascii?Q?J0xD7uihT/KR8Hn61SLcv09FHY3lWq7p/TTFVvjT2gktCQGbdaybfNjsnKXs?=
 =?us-ascii?Q?HzNGiiujBMcfuVikKfgpiLW/GYzXSQoXWXN95jakxJ441bBHVTfbeGWsRhus?=
 =?us-ascii?Q?jN1MOj2cU4/txkIfPmw62X5V3Dk39TIe/GvRIs26JA5he5kG2vyg3tve805t?=
 =?us-ascii?Q?KFaSiGOTrhWSHOnZAVPx8tBHen5DQFFzwRzsLGnB7mMxIK4vwZUmi7aA5dR+?=
 =?us-ascii?Q?YYTOkkB9djvhpK6eMBEO6I+WEiraI6nfJZJR3wTNUDE/zdFGPoP50mqFJSs/?=
 =?us-ascii?Q?q6HY/plJWS4VeAXzW1f5cK5ioEksgS+iYgZDMje5pWz5JgO31OnCQsOzsIyz?=
 =?us-ascii?Q?jIO8eyB9ETrTs5h2G7i2jN+j8YDjHYcgqcExSI7SE+kSYt6n5qncc1eaBuc7?=
 =?us-ascii?Q?uDf2RkK5N6cQOM3r891yHRin5f+DsVbtbmKlq2qI+wUA+0JaxT6DW52adZw4?=
 =?us-ascii?Q?sjYMnbuv0gS1Kus=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014)(13003099007)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2025 18:31:32.3313
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f5934af-697b-4f2a-bd5f-08dd3ca5537e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00026369.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6602

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

Cc: Kevin Tian <kevin.tian@intel.com>
CC: Jason Gunthorpe <jgg@nvidia.com>
Suggested-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/main.c | 67 +++++++++++++++++++----------
 1 file changed, 45 insertions(+), 22 deletions(-)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index b76368958d1c..778bfd0655de 100644
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
@@ -757,40 +754,67 @@ nvgrace_gpu_init_nvdev_struct(struct pci_dev *pdev,
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
+	 * presence of the bug can be determined through nvdev->has_mig_hw_bug.
+	 * Thus on systems with the hardware fix, there is no need to partition
+	 * the GPU device memory and the entire memory is usable and mapped as
+	 * NORMAL cached (i.e. resmem size is 0).
 	 */
+	if (nvdev->has_mig_hw_bug)
+		resmem_size = SZ_1G;
+
 	nvdev->usemem.memphys = memphys;
 
 	/*
 	 * The device memory exposed to the VM is added to the kernel by the
-	 * VM driver module in chunks of memory block size. Only the usable
-	 * memory (usemem) is added to the kernel for usage by the VM
-	 * workloads. Make the usable memory size memblock aligned.
+	 * VM driver module in chunks of memory block size. Note that only the
+	 * usable memory (usemem) is added to the kernel for usage by the VM
+	 * workloads.
 	 */
-	if (check_sub_overflow(memlength, RESMEM_SIZE,
+	if (check_sub_overflow(memlength, resmem_size,
 			       &nvdev->usemem.memlength)) {
 		ret = -EOVERFLOW;
 		goto done;
 	}
 
 	/*
-	 * The USEMEM part of the device memory has to be MEMBLK_SIZE
-	 * aligned. This is a hardwired ABI value between the GPU FW and
-	 * VFIO driver. The VM device driver is also aware of it and make
-	 * use of the value for its calculation to determine USEMEM size.
+	 * The usemem region is exposed as a 64B Bar composed of region 4 and 5.
+	 * Calculate and save the BAR size for the region.
+	 */
+	nvdev->usemem.bar_size = roundup_pow_of_two(nvdev->usemem.memlength);
+
+	/*
+	 * If the hardware has the fix for MIG, there is no requirement
+	 * for splitting the device memory to create RESMEM. The entire
+	 * device memory is usable and will be USEMEM. Return here for
+	 * such case.
+	 */
+	if (!nvdev->has_mig_hw_bug)
+		goto done;
+
+	/*
+	 * When the device memory is split to workaround the MIG bug on
+	 * Grace Hopper, the USEMEM part of the device memory has to be
+	 * MEMBLK_SIZE aligned. This is a hardwired ABI value between the
+	 * GPU FW and VFIO driver. The VM device driver is also aware of it
+	 * and make use of the value for its calculation to determine USEMEM
+	 * size. Note that the device memory may not be 512M aligned.
 	 */
 	nvdev->usemem.memlength = round_down(nvdev->usemem.memlength,
 					     MEMBLK_SIZE);
@@ -809,10 +833,9 @@ nvgrace_gpu_init_nvdev_struct(struct pci_dev *pdev,
 	}
 
 	/*
-	 * The memory regions are exposed as BARs. Calculate and save
-	 * the BAR size for them.
+	 * The resmem region is exposed as a 64b BAR composed of region 2 and 3
+	 * for Grace Hopper. Calculate and save the BAR size for the region.
 	 */
-	nvdev->usemem.bar_size = roundup_pow_of_two(nvdev->usemem.memlength);
 	nvdev->resmem.bar_size = roundup_pow_of_two(nvdev->resmem.memlength);
 done:
 	return ret;
-- 
2.34.1


