Return-Path: <kvm+bounces-35886-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AA72FA159F5
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2025 00:37:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BD9697A304F
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 23:37:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBF521DDC02;
	Fri, 17 Jan 2025 23:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jaQl1XPc"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2078.outbound.protection.outlook.com [40.107.102.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1545F1DAC8D;
	Fri, 17 Jan 2025 23:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737157046; cv=fail; b=DUz24K3+qsIuBhJEpikkw8uR+A73f0tXKVXOpRQ5rX87VyDVTuS/maygoCYauchHk0uZI5lRkzPJ+HbnXHUvY0wvWOl6J+UXlHYXZ6bdgdqAmOflNlhVFvGAVw2Of7gwH2dlrnwQ0M2iO6NKrLKYJdyKsOJHbOpoHUKn6Hl0+m0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737157046; c=relaxed/simple;
	bh=WQQfwOPmu4PVOS38AtA7u3a50ZisA0X2hNQZ2lJejWM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J9+daR7mxEgLemj2/q7G+c89TuxAd4IqTPfqkATx7vGvFuXV2Xpk5JXwunbzBE9KWsL6S478woleUxhR1gPsUzXLQ8KhybitLZqtXlhSPRkVKRDndEDc/oELGgxikjBZbsWjLpNBJD3nof/YsPrfZr0kACSAyvzgR5bsWXwRsAM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jaQl1XPc; arc=fail smtp.client-ip=40.107.102.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ystLzxWD44CH+JV5QkzcXgnUgm/WmBuIYD16f9+8U1lJ/rRd+TXfrqqM5ECbjl6jjmcMwu3fGyPSD/vn1IR1u5qtFkCqoEBETOauJA5axyx893FXkX7XWfW0E/9K22PXHMpwCEwWTrJ/rXWwIG/QKP7sSXsXsykBBa5lDmFsDxNaabtSTA7P0G3HBYcnjB/20pShreZDePcZtpOBIA0dZ9A1H/zVQYw1VtH1JWMHnjnWe7/irSaW4mtstp4qlKQ6Lq8128WtEVpq4evTZA7wG4ymTIfCu8X6L7oLeIB3WKEPrhyQuzC++lvE44i2PNSekP2el0eXoJuM0aLgRz7VsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BV9zgrJcYeyvk84XP6bdFUT9KYLv4MjwISeccGNd4+I=;
 b=CTr6EL6/GWp8SJq1AYJE5QiIaK6sOHgQgeh4FlG2jXKlzdtjWewW1jzFDKIE2+VhZPKoWxYFvw7chZ0WN6reDg4Ga3k39jlbscvccOw018/0E56hNQwoPxCL5A/ZhX3kUu0vsb75gg9DZa6yWNvcyg40okbeSWbIpT9jKmczgJXqT+TF5Y5zw5oVNmqRw+i3qaggTB9iAM0e05hD+IpDtcjqCD+j6iX4ZZYFwRCSMgUHGUgalUR6T04RaFprm+NcWgksVTn0MYCfSkoW70D6PL5BzdEU3x6aajxqNQqJ/CKdujlK8lZg+bo8QQTxvLOzuDtEpzwc0j84jtxng/arLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BV9zgrJcYeyvk84XP6bdFUT9KYLv4MjwISeccGNd4+I=;
 b=jaQl1XPce5bLnJYIBk0gSsI09pMtE2+atA7+ctyJwmBhFkyveMYP3pcdPNZE1MO7NFyPKGBHTsKJDt2vjXH9wjzRS3KFlrvCqxmEeSiPBAwRYB6Fa2btZXqH98EyNlwg/InYECC2Rnu9Vo1eUQ0EPyKd/YR5F8PAZZD6EERXqzrT/t4aEx/7dgAUJA9VdTuCWxm+iYRjVyhKnzFdT+gzSp21FhwyHDVBcI7ZeOiqXGUx+F1+6rmbL+OOK4ETE9fMuCVhV6eWogCK7tQ8t/781hQhtyc8rbMZD8tQCeYSVWtNl6vSFKwM7kJr9lT93/4ugA6VZZXdeZtu8GkOsx9Zmw==
Received: from CH3P220CA0017.NAMP220.PROD.OUTLOOK.COM (2603:10b6:610:1e8::22)
 by DS0PR12MB7701.namprd12.prod.outlook.com (2603:10b6:8:133::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.16; Fri, 17 Jan
 2025 23:37:21 +0000
Received: from CH3PEPF0000000D.namprd04.prod.outlook.com
 (2603:10b6:610:1e8:cafe::87) by CH3P220CA0017.outlook.office365.com
 (2603:10b6:610:1e8::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8356.16 via Frontend Transport; Fri,
 17 Jan 2025 23:37:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH3PEPF0000000D.mail.protection.outlook.com (10.167.244.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8377.8 via Frontend Transport; Fri, 17 Jan 2025 23:37:21 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 17 Jan
 2025 15:37:10 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 17 Jan
 2025 15:37:10 -0800
Received: from localhost.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 17 Jan 2025 15:37:09 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>,
	<yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
	<kevin.tian@intel.com>, <zhiw@nvidia.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<anuaggarwal@nvidia.com>, <mochs@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v4 2/3] vfio/nvgrace-gpu: Expose the blackwell device PF BAR1 to the VM
Date: Fri, 17 Jan 2025 23:37:03 +0000
Message-ID: <20250117233704.3374-3-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250117233704.3374-1-ankita@nvidia.com>
References: <20250117233704.3374-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF0000000D:EE_|DS0PR12MB7701:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c4d0d71-b7c6-462b-b922-08dd374fe375
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5VcsKy7jdbBjeD8WZTXjt5kzZllypgpuEiHRMqTzx02OPhxJolrf9X4TXSsx?=
 =?us-ascii?Q?YmnuvtRSPWRwvRZPHg2XrymxhDp5SkN+hcD1Yw5L+5Tg9YyLxn57Mn8MJFqU?=
 =?us-ascii?Q?gUIWiNKfHyO5pk0utFJjIfUTQT7brWlziCd688dtXn3oo1MzTq9SjmYZWlwO?=
 =?us-ascii?Q?A1eoG+lo19jMZk7g5dho5HPO1XDo9iEz4dAaSRlfhsgKbN2ocMZQTCNZeOdA?=
 =?us-ascii?Q?ZjI/dRpM6al+qUcNrR1mRvUHyfEYRsJWgVDWTc39h6q5eopKzcsaJUx5+2Fa?=
 =?us-ascii?Q?F7hyy/Vqrpe5YBa3tABxKnJGFMfU5k8Mb17ATOiNV4R1Zhrj41k++mIIAzYB?=
 =?us-ascii?Q?G1G2WwzM+viBvkbsmc9LAOz51T0WeemtK0FSeIKpcmOO3iTu4CrNRx1d47w3?=
 =?us-ascii?Q?s9fSMWbjwD+dP7/kPXECm2v0x2sTh/Mz+wikkcqo3/4KRd7wwoTZ5/55bUnp?=
 =?us-ascii?Q?ugGtD1jtFFSsuHjiSHuPQj1lVmoFANQ0B1CmIlmUYu8ndAVkZMdjFmf4fbZL?=
 =?us-ascii?Q?Iu37OPH5wRFinj0KyQvzEuqwyiDrXciQlczIOoU2xzoK2l3MSAuhvSRiUYyS?=
 =?us-ascii?Q?mTEJ/p3N65uXnP0+AOjyS52NQ3HaViI75rTQX50SRE21aL3UqGSbMG9AbmnE?=
 =?us-ascii?Q?+E8zUZKzWrpkV0qqYMi5FpPqTJ8vGQysO4Teis25Hp7DHSRtglvBqNA1M66/?=
 =?us-ascii?Q?86gEiN2SNKhaKYSadzhGC09v3n0bKJaJ8h6dOENzy/QSy74BUXhshvNWZx+h?=
 =?us-ascii?Q?D78j6uuvOZP7g+sJxZLShXmkvrTE2sqZEl9fJPjgIzEGxNor3txbBWLjk31l?=
 =?us-ascii?Q?dOuR4b5bTARCXwB95RIcmgr7MfnE2FdciMcyxS3pH6P4/6BrykUGmsvUj+g4?=
 =?us-ascii?Q?IcYGYWqBcrOW4BKSsZj3c7HjoJZE98qASQzbI57VnpzpgXCOtm1XuQtYmKap?=
 =?us-ascii?Q?d38QjgelEfeXt2RcRHO5035m3i8VWiO21qLXLG6Vi3JpaxJtY9Q1iguwI6wI?=
 =?us-ascii?Q?hcVngGViZ1YBejrgak5aFDWmDBbiN5Kh47QsSVqSf4YWhDl/uIHYtg8mB34d?=
 =?us-ascii?Q?RucVSr3lweIeNNFvlJ90xH6f9Hkbr2Dof53VsDTN69VCj86huneWri43QTIU?=
 =?us-ascii?Q?zafVmxWUjB8neHQuHXwDfnlnQiqxv8dD+Ou1kiLXusel4hdSjvntfmw9ciJ+?=
 =?us-ascii?Q?mLNzizopA+yEd/WAY+fPupI8gGklKv/K5yzAq5jc3KflJxPOgF6gADELTSEN?=
 =?us-ascii?Q?J1H6ICEqob+tEAGx2eRU1U4TnIxyN9fl4+L38oK2V7WGKXedif1xmfy6coT0?=
 =?us-ascii?Q?NUOu62BLX2u43jKUQPc+x4LQz18wvgAxz9zxWKC+WHsp34TCAt/8vIlzG67t?=
 =?us-ascii?Q?ekzgMdMrUU0L87zyxbjo48Jm2hEX/R3c+ZbtP/HjF1NRdys4sVDfX8dvUnhJ?=
 =?us-ascii?Q?HLfj6g/9J3mOojhHgTe5+zb7UX3kZevsbdFoIdBs7bbakQdGkjFzBogorTPR?=
 =?us-ascii?Q?71qsXs1hVNoAtyLP5zJRCz1e5cfuRdffrGMt?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(36860700013)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2025 23:37:21.2846
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c4d0d71-b7c6-462b-b922-08dd374fe375
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0000000D.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7701

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
 drivers/vfio/pci/nvgrace-gpu/main.c | 66 ++++++++++++++++++-----------
 1 file changed, 42 insertions(+), 24 deletions(-)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index 85eacafaffdf..e6fe5bc8940f 100644
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
@@ -780,23 +787,31 @@ nvgrace_gpu_init_nvdev_struct(struct pci_dev *pdev,
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
+		 * Note that the device memory may not be 512M aligned.
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
@@ -813,7 +828,10 @@ nvgrace_gpu_init_nvdev_struct(struct pci_dev *pdev,
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


