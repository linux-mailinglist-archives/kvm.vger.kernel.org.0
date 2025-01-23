Return-Path: <kvm+bounces-36416-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 13D4CA1A938
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 18:50:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 487EA1668C7
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 17:50:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0292E1ADC9E;
	Thu, 23 Jan 2025 17:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lAtic+6O"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2050.outbound.protection.outlook.com [40.107.92.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2860C1ADC77;
	Thu, 23 Jan 2025 17:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737654569; cv=fail; b=LZmk/hK8M+rw89tQlp7HPI+XteO1/P6nGSxx5L7vN+TGBV0Kt7rweG1hwyleeO/DWExuv0TnLgHes9DxXR7X3gDi5QbIJEZcuEfDFZPW2TOjybEd8hsih1WciAMNHCE6f8eM7Jlh5RMhGvpZjnpcaGmQjxbE46x3RsSQRy/USac=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737654569; c=relaxed/simple;
	bh=/5dvNqLiAS9+yvvAwWidrdiPu0TiqHgk4dXJm7fMhRo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X7BTQ4NWde0Bi+0ZZIRXxcCNWMKhyJxkW26afbjwv6frELj4dYZZ1yEL1qG7n7MCrZLF+rHNWdzRt+OOtogMgeRpUJj3AGH1drRpgppCCKM8zfh1vLwC72/JC08ZSHIlPa5/rMgC2DaWfUWtuoNk6DnnFubuCjHqaeNQZ5cntWg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lAtic+6O; arc=fail smtp.client-ip=40.107.92.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JHwyhgPA0Q1H9uF87+Tg/v0um5b5+SbTL4dYNdC/HP05hsulhSDKJ7oswJ8D3H9mTSmSmTl87uezyqkY8plm8z/FK2CFRaJqDYhQJnXnj3ZZ3iNCS9Mk2kF5Oa5lZLixtyTQHSDx3wEHIQwSJL+QUQDbCF3J0bkb+1UJ49MMh7KoUF6tc+QBYSVUvLgxi/X9rplIuV639drhzpYRdn2xxLq5E86oZHHcHEj609O6C/DEOTXW5Kwcd7TQ5qaJlG3uzWDpR7Qrj4Ic+ue0JpEhUDTo73MEovFSQYYc81SbpaHNBuqRg030wwBTDfNbvV61jJfjXUJBFurbbGskL0zuzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OG30gkDqR25bUVZQuhBKDtsckfAi/joSoHKi8pbKrDs=;
 b=Ft/BAfPdsDXBbjYjW+2lFSr6rlrIZ5pHJz1dSQcDKLiy/rtCnidkD/iwHj0Rmo8OAe4YcBtYuGmJOGJQVnDEX7NYT2NHHVLbNI4VOIVr3eSOxdZ9rlnEJlm8RGS6hLXbb2uoEMOsTucPtPGHESVClxtV9Enkr3o2l8+3QntaBIACZP5ulfVzNYr9KP/lwD1JViWquxoDVK7GpvCP+1MH5Gbn1pyfnAX4kbAabXqWMJSybFE/R8gqSDnTGRa1hCBhdntc77PTxolD9zVxJpcdpVBM+RgXIQENn4AUS2GaXf6Vqvm5gAbRCubwOE5aI25MndBv2Pl5GSKn0f76xldr1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OG30gkDqR25bUVZQuhBKDtsckfAi/joSoHKi8pbKrDs=;
 b=lAtic+6OySg305zCb22ARCzN+KZETPSpgq0dbHvWlZq9MznVRQxggNY9VlLWuihWPK4MTfRKoncZbEgSuuCSbp/Nuxi9ttX3DuFMW5eCCwDUHWyoPZ1xlOp1/jAgYhQXvOvGvBVkGrjH8cz4q9uru+FKfDXSYfsCo0a+v0MPECyI+o2Ekt6/6RockIBUEjN2nOflgL17ui94teBfYWZfVSLhcYyTbxDZq9DUP4ygEU5qkKtorF2qsiCBo4Kn0NVULpZMxo2spGIhT4xH/WVAQV6qUB+Aw3s3o5QclSZ7gKJb5nHE6Hnf5WS6mLT5+xJXm5ItNew9HN4Uh2TbN5cEBA==
Received: from MW4P220CA0011.NAMP220.PROD.OUTLOOK.COM (2603:10b6:303:115::16)
 by SA1PR12MB7344.namprd12.prod.outlook.com (2603:10b6:806:2b7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8377.19; Thu, 23 Jan
 2025 17:49:20 +0000
Received: from CO1PEPF000042AE.namprd03.prod.outlook.com
 (2603:10b6:303:115:cafe::5d) by MW4P220CA0011.outlook.office365.com
 (2603:10b6:303:115::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.14 via Frontend Transport; Thu,
 23 Jan 2025 17:49:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1PEPF000042AE.mail.protection.outlook.com (10.167.243.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8377.8 via Frontend Transport; Thu, 23 Jan 2025 17:49:20 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 23 Jan
 2025 09:49:04 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 23 Jan
 2025 09:49:04 -0800
Received: from localhost.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Thu, 23 Jan 2025 09:49:03 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>,
	<yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
	<kevin.tian@intel.com>, <zhiw@nvidia.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<kjaju@nvidia.com>, <anuaggarwal@nvidia.com>, <mochs@nvidia.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v5 2/3] vfio/nvgrace-gpu: Expose the blackwell device PF BAR1 to the VM
Date: Thu, 23 Jan 2025 17:48:53 +0000
Message-ID: <20250123174854.3338-3-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250123174854.3338-1-ankita@nvidia.com>
References: <20250123174854.3338-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000042AE:EE_|SA1PR12MB7344:EE_
X-MS-Office365-Filtering-Correlation-Id: 44b0ae97-d71e-4623-f5b7-08dd3bd643fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NbHPo00UjRMYvOpvIWvFygildN/HnEMEVFj2KjY8PsUqBaI9oNrOJDYpBPkl?=
 =?us-ascii?Q?DnSTbjjNeKOZxwotclJqJsaiWZ1u2Yar5EYtR/FLCvcKh9c/S9LnIMrXHOo/?=
 =?us-ascii?Q?g2gmQxIlv+uwR61xTTURQKDSjaPOfcayX8qIUGn8CgNZZZ3K+TswoCQYY4jn?=
 =?us-ascii?Q?FPv6REl0Xu8JhctEOLEGV8rvesl2w/6CGqyahakeyHJQEZ0n7vF7R60oe7yl?=
 =?us-ascii?Q?o8S6BJDWVVZX+BV0SBhwzgHune+c2vgE+x8ZCqJ+1oiks9hMvYDu077L5Kyz?=
 =?us-ascii?Q?/VjwCSuz6N3KgvRM8pII90YFTld8g2uMncDFgVOEH+88kJkkJIvR8m8CM1u0?=
 =?us-ascii?Q?bOkT+h5s3H/HxQgyrk7sXCLgg4PX7lOcgkIodfB+3a9NI6i24D8vV7X0gtUm?=
 =?us-ascii?Q?3gHjCEc0eg7BIwPD37hX/lhXKVsAA5vs2VKOVa20GRusC8eV12twAKlONq5v?=
 =?us-ascii?Q?5X+0CjqGKQV1FelR3iWC1Fa85P0rkw0IVUV9Ep6mGNZuSU6hphyepuHOCwS9?=
 =?us-ascii?Q?IuQog3E6DAo1X5n3PV6SuNfJrcJEL0k2v94jUl/IJMNFDILlzGcxGnrF88Ab?=
 =?us-ascii?Q?EdxGPtBxXKonDQsYHooZ7aGJY0Cqlw+nY3NlFJky4EKEeiaZCZP8zemXybZ2?=
 =?us-ascii?Q?ZeFCivMR5oBvPoXTxckoUur1KYTHOvE0ZOZDBhL7T+Tr2QVxNeF8qZZwzHmz?=
 =?us-ascii?Q?NXoYEFdzZ0hcy3UpOtMSHe4oYOIfSf/rn8rvBI/AmwzQUH+4uCmuEKNpC254?=
 =?us-ascii?Q?rYsJ4gy/CgHrI6FY09ZIs4KmlR8GdXg9WJCE+VUlSaofB0otX5otsaOcTy3V?=
 =?us-ascii?Q?8ADbNyBN8K84Rz1waXYVJED2bZSmliEnaPKd5jxi7H0I9KlACirmKsV1QGeA?=
 =?us-ascii?Q?ic5hEau0WH1I6z/OYP1s4GlmRuf1Zw7djwnR7Oh5OBsRN4XuDarry1EUhqdt?=
 =?us-ascii?Q?whnEKiWwrk6trr5yGYPtJOw2XoSQFVwCTFUgNAnJVSBmADSEIjJ0MgyE09zK?=
 =?us-ascii?Q?12L9vwIid4jm+yOTkEAD/UbmGd2aLCKYRUCGt/bMl4JNbLc6Ldq+ppkATmLh?=
 =?us-ascii?Q?QbqoPxmagX85sRVqL6/m3SZQKbplKEMcsQZedzq8vQmIjVLgi/HpH72fsxjg?=
 =?us-ascii?Q?w59dFiPONkHjEGhWO5LyrUMCMjp/xUd+dTVeav/ZJw7BO+6YFUsU8/EvUc41?=
 =?us-ascii?Q?4YsUtH59VOKXwhlA5c8WgWC/gQVANcmUM+LOFFpqqjH26EAfyZIxAHUiCHYj?=
 =?us-ascii?Q?4pLaeCFYC3RsDuxHvRSSlfJ+hbMXMFEkIqgEBndCtTJXxDYppFVjq1vRdZBO?=
 =?us-ascii?Q?lPKmDOd9f4xfuULMhIm3YLpBk0PjpMWEFdZVooei3O+q17C8nN4Ulx/3SW45?=
 =?us-ascii?Q?LK/ZDkUNIySASpmDQ7YAKU1wokaBWX//1GQZsWUQsZ14SySblUs9bqsnudgw?=
 =?us-ascii?Q?ifI12712UpdDA53jmFxmjbcXPs7x/0FsVdRBue5HEYpAHWobPIPQdJs04azy?=
 =?us-ascii?Q?fuEbAPhvzp37GgX/puZBzWXqnHGuf4c0YiDS?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2025 17:49:20.5363
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 44b0ae97-d71e-4623-f5b7-08dd3bd643fe
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000042AE.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7344

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
index dde2daa597f8..f4f23c0c95c7 100644
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


