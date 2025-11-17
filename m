Return-Path: <kvm+bounces-63377-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BE61C6438E
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 13:58:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 080F936416B
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 12:51:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43C44339B20;
	Mon, 17 Nov 2025 12:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bXk1LGbD"
X-Original-To: kvm@vger.kernel.org
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013021.outbound.protection.outlook.com [40.93.201.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA743375D1;
	Mon, 17 Nov 2025 12:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763383350; cv=fail; b=URMG23gyS+Skxpc2UJjpQm6Y0kQ9BmviZE2ijqfLiQvOJBAgABGRgMVi23GufvWe2GJ5hiVSUx5ZNyDPWzmEkYTAW9eiWbHsROJtdkWi0ukrBqXWswsdnrJfVIXNAR64/nXtT2IwQBxst5EvTBX5rgHuTgJHNK5AscIEsiejWBM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763383350; c=relaxed/simple;
	bh=g6AMwCLfc5a7zci494G1NRGy9JIzS0WNKYLoOLKUp1Q=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cfNf8Sk8hbGw+OrPBs7jeAR/KGOb9QM3LVi9VqUclrCK5Mk4HhKqDJfvoupzYjPRYvpt+Yyh/tC53l4w9WDZXeVR28vQesBjXHrsdlZS4zb+8gxx3jhrGAH0CB60aGkj8UreKqMFNpGznKG/XwGsO68owp9aHgdqflShs22J6Sg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=bXk1LGbD; arc=fail smtp.client-ip=40.93.201.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vf0gbFAAbmcl2OhkPIa9A7nAr61tYpQzrp1pbqO8oSxXZJhvvBUnZBsVV4G4I1l0tZKLD1Rrxzcc1qxrO7XJn4J0wxN55uYyhz3Q8QM3GSuN465nhm9O+icSA1kLOu303qwqFGWJTxowQr+WQR3IgD2+rPkg/KY9FHCCKwYZOLSmquK96jMep6DG3sAcfxH/jE17z6O0Xm1sZ9FwlVWxZTmHXmHOUv/zuNabeLyh7thPU++UloT7n4qMu6Mpkr5pBTUhI9ZDiaudbdmQgHSvrSA1gzLBHPUiPj+ikCPUTKjrTJP6Ne/npHChvup3q2DXN4tI7hjRzWuVa3k2Bi2sGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UX+yDiEszkqqKiQpnoloD7v6MJNEffQxbLbhM6vRI/U=;
 b=mnB5seMXxXky4J406paZBueKTfsLm148DhpOmA5TmeQ352DaCcIacw0r/lEM4LX72TTjEZS7hXWhUJ9wxZteqUWngqunSW5AhOG1K0qaMlVHoKA7YFj4EqX2ZRqjjsET/nqx5jtYRrful/TLibj/LJRwO2ZZI8qyoqRNtRBWvSbmztP9Vi0MvnM+azbQdmDHaQaSoKdeJi6AhFTLMp+kvL3AwICRBlAYRTSEC15zrvu/RHcZPqH4EcTEyc1NQT5J5e6CAXqQKS7NqG5VsHU3lPHkfDPyF4Hvmtb2Muc0u9xZhVzy9PmreOgmiyFJc1w8/nQIOrb2qqmvq2I5WTaatw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UX+yDiEszkqqKiQpnoloD7v6MJNEffQxbLbhM6vRI/U=;
 b=bXk1LGbDELowQUdHCKzXMNmuSAXLWCHHXULMAlrH7KNAD7YjFdH4Tema7elGrjuNTLyjqHHtig0EbOBxB9kfCAJnd4FLPCws/KPlfkREWOst9hSAjdpUZueKuZmpd3I5TUj0d8AE+bA40vl42asTaNMLisSWk4ZX7O6jRN6cf2EZMcNg+phNiJeqeBw3mgE5Wa7cReC+6/Zi63ZpjofS0BVoi0WY+r2WTu9id6FFvBlqcf8tE3xsKYDXeWnzTcVk2meaWzF5d3n+J9hVTEBTAD3hjrRWYVU9+F+6S3993SbNfJ8cv/Oe0SfXwDw+ax2+mHtePtubAqNL2ZIqm086EA==
Received: from MN2PR05CA0062.namprd05.prod.outlook.com (2603:10b6:208:236::31)
 by PH0PR12MB5632.namprd12.prod.outlook.com (2603:10b6:510:14c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.21; Mon, 17 Nov
 2025 12:42:23 +0000
Received: from MN1PEPF0000ECD8.namprd02.prod.outlook.com
 (2603:10b6:208:236:cafe::46) by MN2PR05CA0062.outlook.office365.com
 (2603:10b6:208:236::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.10 via Frontend Transport; Mon,
 17 Nov 2025 12:42:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 MN1PEPF0000ECD8.mail.protection.outlook.com (10.167.242.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.9 via Frontend Transport; Mon, 17 Nov 2025 12:42:22 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 17 Nov
 2025 04:42:04 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 17 Nov
 2025 04:42:01 -0800
Received: from
 gb-nvl-073-compute01.l16.internal032k18.bmc032b17.internal032f11.internal032huang.bmc032l04.bmc
 (10.127.8.11) by mail.nvidia.com (10.129.68.7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20 via Frontend Transport; Mon, 17 Nov 2025 04:42:00 -0800
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
Subject: [PATCH v1 1/6] vfio/nvgrace-gpu: Use faults to map device memory
Date: Mon, 17 Nov 2025 12:41:54 +0000
Message-ID: <20251117124159.3560-2-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251117124159.3560-1-ankita@nvidia.com>
References: <20251117124159.3560-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECD8:EE_|PH0PR12MB5632:EE_
X-MS-Office365-Filtering-Correlation-Id: 94a6c11c-6ac1-4345-ecc0-08de25d6c16c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dRBmo6p1aUdPmV7eRLOnHnkFc8t2r/rIMJNqdXsZBWuyUw2YXeMKQ01yKksI?=
 =?us-ascii?Q?vVm4vbRDJZXGWcASE2Qym4uiHwhdr2UjiuRAn5RHynPRhI3XMOXCWO2VigQh?=
 =?us-ascii?Q?HxwT1bnQFLj09DHfSyTqk7JV74a9rethIScQXgLNpO3uSSq302VEqDQaxGvd?=
 =?us-ascii?Q?yLCvYCG8ywuSv+49yMXg2z2JENlWZQx1wwT7hGexK2hlzZHPs66BEqNfj+qc?=
 =?us-ascii?Q?yeaUmccRD3Jn9VASdMZlHKi0zO5L5/Md29wTYx/ZbpXuuU4LrD/Txnp5NGrZ?=
 =?us-ascii?Q?jgQzPS9M5O5CHtVnPY0CcuJh1t7tiTql2tf7mFXigL5Eu1K1Ar+foCJmKhTO?=
 =?us-ascii?Q?mF8jrT2lG9t5Iv40oiw35YLTn7c3Eudhpmxl/sM8OmpkmSrFrL38fsLp2DZ+?=
 =?us-ascii?Q?7fMyw2iOgkQmUuEK/vij2qWL8l7NIwpbEMqDLzBAtmgm48XCTX6KJpflHNMd?=
 =?us-ascii?Q?gbvsJvGdureHQ9GUDXjW1O2hy+pCTBfeflgXL0snc2XHb49HjXujMVn5PeYd?=
 =?us-ascii?Q?hEA9bbWsFEAyLNZw1HVrLUNR5YqDzKjQ73nnbuVz8xsZI0bmD/w5HMdHp/tI?=
 =?us-ascii?Q?f/TzTTd8RYon5csDGJHHwSyQlrCnDDGwxot5A6bzXqCGZydd43eU93e5GgRz?=
 =?us-ascii?Q?eKnlu4A7zV0XFPfwER61SLEVxseEpX69c1nonl8X3IRB7R0OTYj11w8YZBto?=
 =?us-ascii?Q?XuW9lSS1yo0k+T1/n1QmXPoH6MhQMJNjw2iBFpWEiVL1oYL45UJWNNrmXrS5?=
 =?us-ascii?Q?AjYUB553bCW73iebeUZnsxxgCrLiWeyeWoG60f7RUSV6G7yE1yOL9H3Q+IVk?=
 =?us-ascii?Q?POyg5UQZ8BKUOvUk6dIwXgNDXPdIdVgG8hmoLuN3xOxVoCfKz9ReY9oVq9uV?=
 =?us-ascii?Q?SE2E6X1tsvy6Xlk9HNcWXnwQO0qXf1Ani5Q1WVCe0pJLC3ONtdzS8B6wEssz?=
 =?us-ascii?Q?PEecLNU4G4aQgvP/Lh4I1bGxRf5uiJzYZkRRM6li6z7mnD/gOUQn/9IqBQxf?=
 =?us-ascii?Q?KsnX5jfkM+r81rmOJCkggWYuJxaV/gBJi3xmufO8nc7hHQ43KQ2JC0C7zxDc?=
 =?us-ascii?Q?t51scV5Eb/IbbJ0FLmnxD/3oKsLtbsne6zDdC96fsynSK0JEhXfcXTEK0Chn?=
 =?us-ascii?Q?bhUHjuO/cRc95+nFKRQVwRvj5vCBb7vKzFApylQp7BKvF1e16br52T372RaD?=
 =?us-ascii?Q?5NMS2fYpxtiLcJAt2UVLSAIUBUgRFVCNd+CKg14gZcEQHras7CtaTn+v3hXg?=
 =?us-ascii?Q?biQVRBKOxw7jq2KIHPO8v/eUmYYQKuQENGJYRoHM6GRxAx641HasohcSs7+b?=
 =?us-ascii?Q?taMzNj/hSalxOs/1Cm+PkD1M1HrLTRHYmlCaTqACCuEn/DKqa7738n28lbK+?=
 =?us-ascii?Q?v4Q3S9P8WF3eL8q+LbonvKSpqIgN6QMzhKvJ2d+DntkNbqvzOHvTo2UH3YQl?=
 =?us-ascii?Q?pUCcca/94kvpZJjmXobchFv8sBeynwEzScUP3dTPNLt883CyVVLMWi0UqRPL?=
 =?us-ascii?Q?yHa9VgbAaQh9BNDEISF7Wb80hcUm/00k3+ZGmBVE6LMGHhKEz/OChTMOE54b?=
 =?us-ascii?Q?mro6VhkQrbwl4p/H9AQ=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2025 12:42:22.9729
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 94a6c11c-6ac1-4345-ecc0-08de25d6c16c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECD8.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5632

From: Ankit Agrawal <ankita@nvidia.com>

To make use of the huge pfnmap support and to support zap/remap
sequence, fault/huge_fault ops based mapping mechanism needs to
be implemented.

Currently nvgrace-gpu module relies on remap_pfn_range to do
the mapping during VM bootup. Replace it to instead rely on fault
and use vmf_insert_pfn to setup the mapping.

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/main.c | 50 ++++++++++++++++++-----------
 1 file changed, 31 insertions(+), 19 deletions(-)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index e346392b72f6..ecfecd0916c9 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -130,6 +130,33 @@ static void nvgrace_gpu_close_device(struct vfio_device *core_vdev)
 	vfio_pci_core_close_device(core_vdev);
 }
 
+static vm_fault_t nvgrace_gpu_vfio_pci_fault(struct vm_fault *vmf)
+{
+	struct vm_area_struct *vma = vmf->vma;
+	struct nvgrace_gpu_pci_core_device *nvdev = vma->vm_private_data;
+	int index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
+	vm_fault_t ret = VM_FAULT_SIGBUS;
+	struct mem_region *memregion;
+	unsigned long pgoff, pfn;
+
+	memregion = nvgrace_gpu_memregion(index, nvdev);
+	if (!memregion)
+		return ret;
+
+	pgoff = (vmf->address - vma->vm_start) >> PAGE_SHIFT;
+	pfn = PHYS_PFN(memregion->memphys) + pgoff;
+
+	down_read(&nvdev->core_device.memory_lock);
+	ret = vmf_insert_pfn(vmf->vma, vmf->address, pfn);
+	up_read(&nvdev->core_device.memory_lock);
+
+	return ret;
+}
+
+static const struct vm_operations_struct nvgrace_gpu_vfio_pci_mmap_ops = {
+	.fault = nvgrace_gpu_vfio_pci_fault,
+};
+
 static int nvgrace_gpu_mmap(struct vfio_device *core_vdev,
 			    struct vm_area_struct *vma)
 {
@@ -137,10 +164,8 @@ static int nvgrace_gpu_mmap(struct vfio_device *core_vdev,
 		container_of(core_vdev, struct nvgrace_gpu_pci_core_device,
 			     core_device.vdev);
 	struct mem_region *memregion;
-	unsigned long start_pfn;
 	u64 req_len, pgoff, end;
 	unsigned int index;
-	int ret = 0;
 
 	index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
 
@@ -157,7 +182,6 @@ static int nvgrace_gpu_mmap(struct vfio_device *core_vdev,
 		((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
 
 	if (check_sub_overflow(vma->vm_end, vma->vm_start, &req_len) ||
-	    check_add_overflow(PHYS_PFN(memregion->memphys), pgoff, &start_pfn) ||
 	    check_add_overflow(PFN_PHYS(pgoff), req_len, &end))
 		return -EOVERFLOW;
 
@@ -168,6 +192,8 @@ static int nvgrace_gpu_mmap(struct vfio_device *core_vdev,
 	if (end > memregion->memlength)
 		return -EINVAL;
 
+	vm_flags_set(vma, VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
+
 	/*
 	 * The carved out region of the device memory needs the NORMAL_NC
 	 * property. Communicate as such to the hypervisor.
@@ -184,23 +210,9 @@ static int nvgrace_gpu_mmap(struct vfio_device *core_vdev,
 		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
 	}
 
-	/*
-	 * Perform a PFN map to the memory and back the device BAR by the
-	 * GPU memory.
-	 *
-	 * The available GPU memory size may not be power-of-2 aligned. The
-	 * remainder is only backed by vfio_device_ops read/write handlers.
-	 *
-	 * During device reset, the GPU is safely disconnected to the CPU
-	 * and access to the BAR will be immediately returned preventing
-	 * machine check.
-	 */
-	ret = remap_pfn_range(vma, vma->vm_start, start_pfn,
-			      req_len, vma->vm_page_prot);
-	if (ret)
-		return ret;
 
-	vma->vm_pgoff = start_pfn;
+	vma->vm_ops = &nvgrace_gpu_vfio_pci_mmap_ops;
+	vma->vm_private_data = nvdev;
 
 	return 0;
 }
-- 
2.34.1


