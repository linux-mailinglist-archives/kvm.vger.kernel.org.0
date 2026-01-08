Return-Path: <kvm+bounces-67403-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A13A2D04270
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 17:05:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 20A4A350447A
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 15:45:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A662734AB03;
	Thu,  8 Jan 2026 15:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="GNkrecWW"
X-Original-To: kvm@vger.kernel.org
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013053.outbound.protection.outlook.com [40.93.196.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684B32E7F11;
	Thu,  8 Jan 2026 15:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767886579; cv=fail; b=J/GUy3+pLCMUIRFfaKxFDA9FzTCUV+cOcTawrqDvhfl/tRo0Xh4od0ICcU1IlJ6KeCu3z2JCOjggHCnOmnxFpktIjkQhNYO7+9SadGihNrA6fELqc6a4Cx4rpmKBQ2qdCD9a4XkmWMai8kwzslVV4uVlr6S513GpFKA9jS30CMk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767886579; c=relaxed/simple;
	bh=lsULakZobHz6e7fboPO4KLvirMI/Xsd/X/5i0dOvrqc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lyNt6uWeed62fNr7Vg0wZHmEr/K1Fsygg4De/Kn5yVYCkh13QT0y8i+e4gfBF2JirPiLX3iQuhHOeYVufq+VMxcMYZmxpAN7O1VeG5YNeK37db1RhE2NqlXEIm87jeBgwgntafLfD45jvSmu0sLLOeICom8KY8TV4FWOZIknLYw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=GNkrecWW; arc=fail smtp.client-ip=40.93.196.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c9bMehck9u/ErUZT9D48F/dC0sdHjjSc8t0vsj8n9peWbTOPCHsQ3/piG7Lm7YNoeIV5nGxRfeWZkLD8mk6lnNPErwkBAMwyvTsDQ3D5AQFUAD29os+vyy4l+wFYtzppqhp1w7z1hlqgz8mOr1njfhHsxwBjVjG7Oi1gAuho5kajRlYV0dK4Tp2SVDm60NXakDZdwbL+KvC86reZO1o0uAiX763OcZtpTmmRb87wb29z6n4/Q5fVNubNieMYoaLTDzRcm0HCPY18S7ucD7bUc8j0FZDtrBne9sIM9iWQLxMDS+Q4Cb1MDJpZNlFhzjdQh9Qm+wIL2ppjW9RlV18mTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8wLQ8itRV0WsO429DKQa4d4kMJNfeYLz4/csqT8ePag=;
 b=OvqK2mYnYo/iHtyS1vfrWQ8HPbFNr4DmGwo+3j2KVwaqdS3vva9W+du3eeyspHyYA7k56trC/+DyYppyCFRlKI/6GxL145pedRmx8JZHG6OtfIAiEsGQpQ94qf9aneW4SbejJSm33ODIpgmgyHVITfJhGp1Df3+vuhUtOvcYMfdcbAv0kV5DS7UPBEag0CKaoEnNDk9Qv3GV5n4J4LeRHvPzsqLeltn0NvbgjugyNNtSADBwb3QAzUEWuAyUd8seAJthKFIbgoM2rYpzSbbdIaqKM3ufRC/n7wowPDTl4oClMdp+XyqPkp+x5AQIICAb5vcG87ZVRndu/bcSPmcBcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8wLQ8itRV0WsO429DKQa4d4kMJNfeYLz4/csqT8ePag=;
 b=GNkrecWWV80gTLyYRFS5sh5ok/3ZRFRARywHgJDj+hAzMnB0ayeUM0CmsMV8AwaYV8j+VHA+MNQvYGptMyVR2/i72GtRVjVXZyJVKnUj4N+TnF6xtEfXg/R6ZmCbBcjbze8N7MKDcO+d+4DrDmjkh4+7lfa1y/TEM3zPUTtXxJiT4/9aKroj0ngafmFn1KnNYyMkUfOSl3WuuYnufLWB1FUkdgk96X/C48qbQZi32tEklZtCf/i0QlxH64BgXQRUrE4hE6dkbsLgDjjglOqfFdHp+WsQ0ngF78DzDolYi4aV1vVUclIA89qiIbkg56nZNWU9MKMSEb29r/0OxMLz0Q==
Received: from SN7PR04CA0206.namprd04.prod.outlook.com (2603:10b6:806:126::31)
 by MW6PR12MB8760.namprd12.prod.outlook.com (2603:10b6:303:23a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Thu, 8 Jan
 2026 15:36:11 +0000
Received: from SN1PEPF0002BA4C.namprd03.prod.outlook.com
 (2603:10b6:806:126:cafe::f8) by SN7PR04CA0206.outlook.office365.com
 (2603:10b6:806:126::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.3 via Frontend Transport; Thu, 8
 Jan 2026 15:36:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SN1PEPF0002BA4C.mail.protection.outlook.com (10.167.242.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.1 via Frontend Transport; Thu, 8 Jan 2026 15:36:11 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 8 Jan
 2026 07:35:51 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 8 Jan
 2026 07:35:50 -0800
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Thu, 8 Jan 2026 07:35:50 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <vsethi@nvidia.com>, <jgg@nvidia.com>,
	<mochs@nvidia.com>, <jgg@ziepe.ca>, <skolothumtho@nvidia.com>,
	<alex@shazbot.org>, <linmiaohe@huawei.com>, <nao.horiguchi@gmail.com>
CC: <cjia@nvidia.com>, <zhiw@nvidia.com>, <kjaju@nvidia.com>,
	<yishaih@nvidia.com>, <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH v1 2/2] vfio/nvgrace-gpu: register device memory for poison handling
Date: Thu, 8 Jan 2026 15:35:48 +0000
Message-ID: <20260108153548.7386-3-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260108153548.7386-1-ankita@nvidia.com>
References: <20260108153548.7386-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA4C:EE_|MW6PR12MB8760:EE_
X-MS-Office365-Filtering-Correlation-Id: a5d0128d-3dc3-4183-9aa2-08de4ecba6a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FVdJIvYqjixGzA7Hqy5nAMkBG8xt+QjxgcqgVWpbw4e6Tah/7wsbYweIfZan?=
 =?us-ascii?Q?AgCK+XMnaWxoSQbtWXFIi8MLUSwrzYA6C4SuAq0dbj1hR+ng475aJ3k8uh5b?=
 =?us-ascii?Q?eUIoNSm7gbbk5W4WUgl7N3RBkJ+Jyytgr2LDUlBI/EfTAglO6bokgoDyPX+Z?=
 =?us-ascii?Q?t5mvJMJtGfNAJsuIdwdTFnumpNSrbVWVeKvt+JrCsqfI9RgllM6rfGhqjdRb?=
 =?us-ascii?Q?x4ksPyWpcOGX1r7CHm8C2cNlZP3d2X8YJl6+rcGx3mmcAdd3k6wtCQKO3KVw?=
 =?us-ascii?Q?tuFv9r3JqYbSRl1Y8dRagxuPMRQ5YlTySR8YWi0+FzFnFS7KuZtZ0nMR9W2W?=
 =?us-ascii?Q?h9sy8YLcQsRIEUHzY/VjvHGfiL/PBhxD4DUHlDd45ABH2bjv+TBLIG0yjlHW?=
 =?us-ascii?Q?lf06SHJoxm8LzyvqXMqWe4vKgBwItZEFVrn65IXV4UvctpSBDJZ7Cj1GPP0k?=
 =?us-ascii?Q?5vTnu8biEQWB1QobVcveH/oaxvs0sTZtuadGPU5rhnqi6PmVOJ05FoG//xbS?=
 =?us-ascii?Q?ge8V3iIdF2tHTSvUvrJHtPk0341IU6SAAfZNqY+SqeWyA+NinIrd6ytza8In?=
 =?us-ascii?Q?MssW7VbWfEUWIleVhPjkz4yNess7FuUUIfpN7/kEm+861XpHnfeZgWhA+WYR?=
 =?us-ascii?Q?f94itfZGeqJkh8GrrZ2ApgaAF/fA8UJtMSht+2BAAkcuzft1cdrYSprzzKZc?=
 =?us-ascii?Q?vBOOLKcJky/4gWMVMUsP8dsp8NOPNdIpcftDFPcvnfL3mlUeOwKmtnrE6o6K?=
 =?us-ascii?Q?dsRvKNrLNqGztQJ7tTIAUJrF+us5fF9WK5bnP6XHEmzi4YH/z2RNzhESdxeT?=
 =?us-ascii?Q?ftPnWPYa9VEIguMgtG8tLrZ+glmqE/nXPuJjL2oezuyOervOfSQuYvTFJmqP?=
 =?us-ascii?Q?D1h8cHscRZGr3gE1XnKMGXiR8XLJ7lLdauhu+lCkvK2802QqhSsIkgqqXLmb?=
 =?us-ascii?Q?Nd6R1YTNVNtr32+ewSLgXcncpWX9MnqQlIXs2t+RTAfnKh4JxZhWw5ZRaCaq?=
 =?us-ascii?Q?pe9/EI6HSV0isXT0mQxVRefzbbLq2Y+LaHpLBgoPQCTWoyxOQ/VgNap9wmfv?=
 =?us-ascii?Q?o3GwJ0ZWtBSPqYk268L15EXozm9D/amMQ2voGAUXCrXgtfblubq1v/fWx1LE?=
 =?us-ascii?Q?S63LC/cG7jMGQFkmUEM4x9UAz9O7HPF9jed0rFuVMEvge7459dIh1Ae0NCdO?=
 =?us-ascii?Q?J5SRhbnKtOuDhJrMHoIghg8soJlcV8NX0wM3SuAPqtItfA9PZRxA+1OEPKv1?=
 =?us-ascii?Q?UyrVklcRFqw6QOLNUM/gRNT6OcN80W2P1tAGygA6Qil/G/bHjcsCe/NhvDbs?=
 =?us-ascii?Q?foyiQKMwUv98pwHw/EiwVs/t2r3SL5xJqOl2qkUMx9d593Ur5dRiX30j8zd7?=
 =?us-ascii?Q?4T+j4y5I78gtzxf/JW55uTmaD3YwFty9ubObSrD7Mj21OeU/sxoFwG06AYqz?=
 =?us-ascii?Q?SZ1asbuJydnRsPlFEPffOQFxSz7umLq+356/NbwefNY/gKQIdlQ5FOADeU1T?=
 =?us-ascii?Q?vP3cR+CUVcThFsLJ2TakbSP2pN9BZm9vtO+ZwwAfo3/WPmiVk760SxjuuZEw?=
 =?us-ascii?Q?vO4KnMbq2K3u3W4gd5Q=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 15:36:11.2480
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a5d0128d-3dc3-4183-9aa2-08de4ecba6a1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA4C.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8760

From: Ankit Agrawal <ankita@nvidia.com>

The nvgrace-gpu module [1] maps the device memory to the user VA (Qemu)
without adding the memory to the kernel. The device memory pages are PFNMAP
and not backed by struct page. The module can thus utilize the MM's PFNMAP
memory_failure mechanism that handles ECC/poison on regions with no struct
pages.

The kernel MM code exposes register/unregister APIs allowing modules to
register the device memory for memory_failure handling. Make nvgrace-gpu
register the GPU memory with the MM on open.

The module registers its memory region, the address_space with the
kernel MM for ECC handling and implements a callback function to convert
the PFN to the file page offset. The callback functions checks if the
PFN belongs to the device memory region and is also contained in the
VMA range, an error is returned otherwise.

Link: https://lore.kernel.org/all/20240220115055.23546-1-ankita@nvidia.com/ [1]

Suggested-by: Alex Williamson <alex@shazbot.org>
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/main.c | 116 +++++++++++++++++++++++++++-
 1 file changed, 112 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index b45a24d00387..d3e5fee29180 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -9,6 +9,7 @@
 #include <linux/jiffies.h>
 #include <linux/pci-p2pdma.h>
 #include <linux/pm_runtime.h>
+#include <linux/memory-failure.h>
 
 /*
  * The device memory usable to the workloads running in the VM is cached
@@ -49,6 +50,7 @@ struct mem_region {
 		void *memaddr;
 		void __iomem *ioaddr;
 	};                      /* Base virtual address of the region */
+	struct pfn_address_space pfn_address_space;
 };
 
 struct nvgrace_gpu_pci_core_device {
@@ -88,6 +90,83 @@ nvgrace_gpu_memregion(int index,
 	return NULL;
 }
 
+static int pfn_memregion_offset(struct nvgrace_gpu_pci_core_device *nvdev,
+				unsigned int index,
+				unsigned long pfn,
+				pgoff_t *pfn_offset_in_region)
+{
+	struct mem_region *region;
+	unsigned long start_pfn, num_pages;
+
+	region = nvgrace_gpu_memregion(index, nvdev);
+	if (!region)
+		return -EINVAL;
+
+	start_pfn = PHYS_PFN(region->memphys);
+	num_pages = region->memlength >> PAGE_SHIFT;
+
+	if (pfn < start_pfn || pfn >= start_pfn + num_pages)
+		return -EFAULT;
+
+	*pfn_offset_in_region = pfn - start_pfn;
+
+	return 0;
+}
+
+static inline
+struct nvgrace_gpu_pci_core_device *vma_to_nvdev(struct vm_area_struct *vma);
+
+static int nvgrace_gpu_pfn_to_vma_pgoff(struct vm_area_struct *vma,
+					unsigned long pfn,
+					pgoff_t *pgoff)
+{
+	struct nvgrace_gpu_pci_core_device *nvdev;
+	unsigned int index =
+		vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
+	pgoff_t vma_offset_in_region = vma->vm_pgoff &
+		((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
+	pgoff_t pfn_offset_in_region;
+	int ret;
+
+	nvdev = vma_to_nvdev(vma);
+	if (!nvdev)
+		return -ENOENT;
+
+	ret = pfn_memregion_offset(nvdev, index, pfn, &pfn_offset_in_region);
+	if (ret)
+		return ret;
+
+	/* Ensure PFN is not before VMA's start within the region */
+	if (pfn_offset_in_region < vma_offset_in_region)
+		return -EFAULT;
+
+	/* Calculate offset from VMA start */
+	*pgoff = vma->vm_pgoff +
+		 (pfn_offset_in_region - vma_offset_in_region);
+
+	return 0;
+}
+
+static int
+nvgrace_gpu_vfio_pci_register_pfn_range(struct vfio_device *core_vdev,
+					struct mem_region *region)
+{
+	int ret;
+	unsigned long pfn, nr_pages;
+
+	pfn = PHYS_PFN(region->memphys);
+	nr_pages = region->memlength >> PAGE_SHIFT;
+
+	region->pfn_address_space.node.start = pfn;
+	region->pfn_address_space.node.last = pfn + nr_pages - 1;
+	region->pfn_address_space.mapping = core_vdev->inode->i_mapping;
+	region->pfn_address_space.pfn_to_vma_pgoff = nvgrace_gpu_pfn_to_vma_pgoff;
+
+	ret = register_pfn_address_space(&region->pfn_address_space);
+
+	return ret;
+}
+
 static int nvgrace_gpu_open_device(struct vfio_device *core_vdev)
 {
 	struct vfio_pci_core_device *vdev =
@@ -114,14 +193,28 @@ static int nvgrace_gpu_open_device(struct vfio_device *core_vdev)
 	 * memory mapping.
 	 */
 	ret = vfio_pci_core_setup_barmap(vdev, 0);
-	if (ret) {
-		vfio_pci_core_disable(vdev);
-		return ret;
+	if (ret)
+		goto error_exit;
+
+	if (nvdev->resmem.memlength) {
+		ret = nvgrace_gpu_vfio_pci_register_pfn_range(core_vdev, &nvdev->resmem);
+		if (ret && ret != -EOPNOTSUPP)
+			goto error_exit;
 	}
 
-	vfio_pci_core_finish_enable(vdev);
+	ret = nvgrace_gpu_vfio_pci_register_pfn_range(core_vdev, &nvdev->usemem);
+	if (ret && ret != -EOPNOTSUPP)
+		goto register_mem_failed;
 
+	vfio_pci_core_finish_enable(vdev);
 	return 0;
+
+register_mem_failed:
+	if (nvdev->resmem.memlength)
+		unregister_pfn_address_space(&nvdev->resmem.pfn_address_space);
+error_exit:
+	vfio_pci_core_disable(vdev);
+	return ret;
 }
 
 static void nvgrace_gpu_close_device(struct vfio_device *core_vdev)
@@ -130,6 +223,11 @@ static void nvgrace_gpu_close_device(struct vfio_device *core_vdev)
 		container_of(core_vdev, struct nvgrace_gpu_pci_core_device,
 			     core_device.vdev);
 
+	if (nvdev->resmem.memlength)
+		unregister_pfn_address_space(&nvdev->resmem.pfn_address_space);
+
+	unregister_pfn_address_space(&nvdev->usemem.pfn_address_space);
+
 	/* Unmap the mapping to the device memory cached region */
 	if (nvdev->usemem.memaddr) {
 		memunmap(nvdev->usemem.memaddr);
@@ -247,6 +345,16 @@ static const struct vm_operations_struct nvgrace_gpu_vfio_pci_mmap_ops = {
 #endif
 };
 
+static inline
+struct nvgrace_gpu_pci_core_device *vma_to_nvdev(struct vm_area_struct *vma)
+{
+	/* Check if this VMA belongs to us */
+	if (vma->vm_ops != &nvgrace_gpu_vfio_pci_mmap_ops)
+		return NULL;
+
+	return vma->vm_private_data;
+}
+
 static int nvgrace_gpu_mmap(struct vfio_device *core_vdev,
 			    struct vm_area_struct *vma)
 {
-- 
2.34.1


