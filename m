Return-Path: <kvm+bounces-63379-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 54442C64376
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 13:57:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 52B904F58AE
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 12:51:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E995B33B6D9;
	Mon, 17 Nov 2025 12:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MVmgCfkp"
X-Original-To: kvm@vger.kernel.org
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010040.outbound.protection.outlook.com [52.101.56.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32F0032ED31;
	Mon, 17 Nov 2025 12:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763383354; cv=fail; b=kYMfoXnkCcrc7G+X4fHKvJdxgEWaXU9r4MBbCA1XyChoMOqPEPgxKz4+bUf6AKOfZqVQ608jFUyqIxHCR80HH4vFnGLn5HM8N5h1ZRLFohHi1oMf6T5VhWKKSiJgD4t71rGdb21G+i4+aFMMtfdzWZ1py2T0m02UxjhHi+QtdpU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763383354; c=relaxed/simple;
	bh=EC/fPtzeP04i2pa40B3ek0oeNLdplAoLnIfv+xkx/8I=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LgmtqrlePZ/cM8Mebz/yPyREkrY7exBBpuCQluYnw+trippzAXeAgEjO+AA78/Op2wgl78Gi4sfWFOsUEQ3Yba4JiI9n9AucPJMKx8FiiYESizB1C8qbJviaUsEJLYtjYLWm//RRn21TOuBLYWFasD/SpL9jvKpRbHZjJH5UFUE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=MVmgCfkp; arc=fail smtp.client-ip=52.101.56.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ctfZgTYmHqOvGh//byun8zhN39tdyjxZ3q4L8O09IbQL/ZyZHPEzhbpmbuGeIWZrAkxXIreCn44G+/XNBaN8OmpSs1O5Pf/+lR8pG6BIAt9AIeLd7Ju4Zsm/2w500n957huAYn4Q/qwQCstjN9DuNSHAOrxS25peRAZ9WOks0ygfP127u7CyXJZY6lN9j3eI7NJsS60i9ZqRbEZ77v8lGsdBEKSCAvrIh/K07faVCK7aoMiVZ8SzJjJPLaJu44kzZZGFGIn+atQHKWRm/ngI1rGGkMf0CaQPiJPGDkoOxmLquzz75OfsfbUPDBg5QZS4Vr6nNdv5Rim7llYUeIuTfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nmgBvpFxtkxPTG6dUdC9jyqn1JBHiMyONQDrGATg7co=;
 b=NCzARJc1KxrwWB5swvwlpe5hbYSdDoimN4UDGMNRLkQLUynVvODC8NhAnN+kgMQEKrhJnLTkqn8XFAxkaIZ7WxALS4f9kMKyTXkyQNAGakggfmiexByBObsvz1ppp1oyQeb1MD0fv1qdw8lVLCenvOdlnnyNc3xUEZGl+uC3ilEYL0FxqGTqEIpZ9Csajw9sbKIg/B9ov3It4FyXOQRPtZJl8IIDZy0LvPfFn73UjdaaO5pARG47iMGQSfhWqvob5WH0/X8BMdf+5l8+HCumnuhlml9Fep0Hx8aGirydXuzUyRdM9O2BjrLsn64E7TAJYUkp3qGryz/sHcSCevdk+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nmgBvpFxtkxPTG6dUdC9jyqn1JBHiMyONQDrGATg7co=;
 b=MVmgCfkp9Bsekm+MjkpqKVJQvIs1zMqJTQTsog7K4i4BtEVffgDWiaXEIuRYcEWyhKCoF9Gu4/bhX9sfihE2qcnkZRk1fbwKr/H3emASzlITff4XxCTu48Whf/8NyLCb3RaJft1VYfA49eTQ77/LFMwQgMxu8xu/Kys1rrAIHSvuvCWbHeTlazmuAqQJ9ziN9sDxdN2vBQ9OJNZlmMbk3NtsE8xB5qen5U0LpA/asNt4cd+qDD2sHeFykLNMzSZ6fizHVYSLDMLV7SM2/y8d7u9yXYFuccYzOESPMIWIBWAoaG6q4UkDz+FlblRbiJqY5cUWlrxmnA9NqBCslcFygg==
Received: from BLAP220CA0017.NAMP220.PROD.OUTLOOK.COM (2603:10b6:208:32c::22)
 by PH0PR12MB7837.namprd12.prod.outlook.com (2603:10b6:510:282::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.19; Mon, 17 Nov
 2025 12:42:27 +0000
Received: from MN1PEPF0000ECD7.namprd02.prod.outlook.com
 (2603:10b6:208:32c:cafe::c7) by BLAP220CA0017.outlook.office365.com
 (2603:10b6:208:32c::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9320.22 via Frontend Transport; Mon,
 17 Nov 2025 12:42:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 MN1PEPF0000ECD7.mail.protection.outlook.com (10.167.242.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.9 via Frontend Transport; Mon, 17 Nov 2025 12:42:26 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 17 Nov
 2025 04:42:06 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 17 Nov
 2025 04:42:03 -0800
Received: from
 gb-nvl-073-compute01.l16.internal032k18.bmc032b17.internal032f11.internal032huang.bmc032l04.bmc
 (10.127.8.11) by mail.nvidia.com (10.129.68.7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20 via Frontend Transport; Mon, 17 Nov 2025 04:42:03 -0800
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
Subject: [PATCH v1 3/6] vfio/nvgrace-gpu: Add support for huge pfnmap
Date: Mon, 17 Nov 2025 12:41:56 +0000
Message-ID: <20251117124159.3560-4-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECD7:EE_|PH0PR12MB7837:EE_
X-MS-Office365-Filtering-Correlation-Id: b885e69e-8a3d-4486-d497-08de25d6c387
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700013|82310400026|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KIkqcTf40K9LxCfeW+Kf/cdUcrndTsr1ZDKSo69BnaOfffoBVNpGimRjMQ4Q?=
 =?us-ascii?Q?1/UBl3SOHfEiT3sxDIl/aUlfNPPIcnpbLiM8a1qq2HPtQ2L5pSULx86C1tWD?=
 =?us-ascii?Q?DNfjOC9yOBddHN0G4RHa0btS7gvffk986pq5CJZeWOP/eZFNllCPOoaxG9as?=
 =?us-ascii?Q?ZB9uo6ZvGnyYKnDXc8zCoHAH8ja9SB9invwXX/wDwpaaluy+ldmn/2UdsyqS?=
 =?us-ascii?Q?Wfg7TkSh4RYvlwfRIU5wcNLExmDuhQ60QCeDBRysk2TE3wK/hvoJ+1pi3uI6?=
 =?us-ascii?Q?7syqUpc8JtqIYFN3nrsbe1Iz/5IUdV5WCXKga2WzXBeTk7V7aY0cnnahxJfV?=
 =?us-ascii?Q?1IWWCdYjHbAss5SE5wAsSawuJfeA1C9DlFv5xyjCR7Xk+F5egUkXvcAOt13R?=
 =?us-ascii?Q?2cGKaQmeXJI+VLFw0mt0EdsGXhKOh0EvIb8v1n52+dhf1EsMjKzR/mo+9Sro?=
 =?us-ascii?Q?L73jW/IRaoOI9fEpmWaFziwB8rTZ617OU4ZFEwxJdUdR/g0dNe+mJAcbsz1f?=
 =?us-ascii?Q?t2xHTps87lUfABksDHVY0yyoObTX0e77m/bDrlijqD8nwdbTZhRnegNn6Vfv?=
 =?us-ascii?Q?0Ac6FQR2nJTSntO/f9IgNg2vNorUPWhVvXbKyvWgnD1FDH2M9XoKdF7CXpVs?=
 =?us-ascii?Q?h9tophtxEHDdq3bDMvmVP33qvrNB4u21gupdJJzg2sA3CIe9vr9cszUcwaR9?=
 =?us-ascii?Q?oXccTxGl42shsH4oNrckF/PdO3Y+l9nXVNrrVjePlLHikx2SgfcPr95sDw1x?=
 =?us-ascii?Q?9wfnJffsWBCjHJCnQdiI8t/SBWzpZFcxUZypiUAqt7w42bsWdPpFjTOhKIQy?=
 =?us-ascii?Q?cq4p6uqmzfPPe/BenzSapzBmsGu5wtCvnr2VwkirkrzIWtdoODAzxitLj0tC?=
 =?us-ascii?Q?RB8na30WQocXqlbdq01Flotp3gTfmdGZLh+4nuIWpr8CSzHw492ei6o9WCF+?=
 =?us-ascii?Q?UKdhs+RZ17O7np3diMdIdvPlodITvhr3/+PqTgZ8zF5FhMVrHqLQvOf0O0uH?=
 =?us-ascii?Q?vTgpx33SldjUqSRJfd90VwPR9yiHg04JI5047e6qaM3RUC7fuplhR2+OlSnD?=
 =?us-ascii?Q?S2tJeo3Gt2iUrxjPLUtRokRDkH8uBuDzx0JBTzfKlqbkL1UIVhC/PBwtgcpa?=
 =?us-ascii?Q?l3cu27fm36AWor0TG6a6Pvyt+qODp7q86BSu9KilYng6mCnlf/tUoEwp/Yuf?=
 =?us-ascii?Q?xEWWONJQxjNt9tD4UlbYozkexffdHD/80JTQtIXpvcp5+CHOwtKsOiIgrPEB?=
 =?us-ascii?Q?2uR95cmqgbEox0jY/ZjIyGNhW7O6PE+Bbk6YJvkikMZwpj5w/vO42WF/NOMQ?=
 =?us-ascii?Q?scqkNVsouzya1E34ziErr5okuqJu5MVy8LU7srfzbGsyPegvvia0j7uKUD83?=
 =?us-ascii?Q?vRv60+6YCeFMfhrXPPAb4lRi6WwWUgB4z0kaZ3lz3PsVFfU7Jf9eBmDmQ3F2?=
 =?us-ascii?Q?lst4m2eYo4Kkeiet0jSm9NgO3jEixGRYrZjztuoqc8Qc7A3vojUJSLzqmxMn?=
 =?us-ascii?Q?16Udezzj0di5C8faq0B4oYtu3UMMNx0kPdVcHBMkexZatGToqgjFKuvPdRKv?=
 =?us-ascii?Q?ezE1yePyPpMwo/ib0Z4=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700013)(82310400026)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2025 12:42:26.4906
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b885e69e-8a3d-4486-d497-08de25d6c387
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECD7.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7837

From: Ankit Agrawal <ankita@nvidia.com>

NVIDIA's Grace based systems have large device memory. The device
memory is mapped as VM_PFNMAP in the VMM VMA. The nvgrace-gpu
module could make use of the huge PFNMAP support added in mm [1].

To achieve this, nvgrace-gpu module is updated to implement huge_fault ops.
The implementation establishes mapping according to the order request.
Note that if the PFN or the VMA address is unaligned to the order, the
mapping fallbacks to the PTE level.

Link: https://lore.kernel.org/all/20240826204353.2228736-1-peterx@redhat.com/ [1]

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/main.c | 43 +++++++++++++++++++++++------
 1 file changed, 34 insertions(+), 9 deletions(-)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index ecfecd0916c9..25b0663f350d 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -130,33 +130,58 @@ static void nvgrace_gpu_close_device(struct vfio_device *core_vdev)
 	vfio_pci_core_close_device(core_vdev);
 }
 
-static vm_fault_t nvgrace_gpu_vfio_pci_fault(struct vm_fault *vmf)
+static vm_fault_t nvgrace_gpu_vfio_pci_huge_fault(struct vm_fault *vmf,
+						  unsigned int order)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct nvgrace_gpu_pci_core_device *nvdev = vma->vm_private_data;
 	int index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
 	vm_fault_t ret = VM_FAULT_SIGBUS;
 	struct mem_region *memregion;
-	unsigned long pgoff, pfn;
+	unsigned long pgoff, pfn, addr;
 
 	memregion = nvgrace_gpu_memregion(index, nvdev);
 	if (!memregion)
 		return ret;
 
-	pgoff = (vmf->address - vma->vm_start) >> PAGE_SHIFT;
+	addr = vmf->address & ~((PAGE_SIZE << order) - 1);
+	pgoff = (addr - vma->vm_start) >> PAGE_SHIFT;
 	pfn = PHYS_PFN(memregion->memphys) + pgoff;
 
+	if (order && (addr < vma->vm_start ||
+		      addr + (PAGE_SIZE << order) > vma->vm_end ||
+		      pfn & ((1 << order) - 1)))
+		return VM_FAULT_FALLBACK;
+
 	down_read(&nvdev->core_device.memory_lock);
-	ret = vmf_insert_pfn(vmf->vma, vmf->address, pfn);
+	ret = vfio_pci_map_pfn(vmf, pfn, order);
 	up_read(&nvdev->core_device.memory_lock);
 
 	return ret;
 }
 
+static vm_fault_t nvgrace_gpu_vfio_pci_fault(struct vm_fault *vmf)
+{
+	return nvgrace_gpu_vfio_pci_huge_fault(vmf, 0);
+}
+
 static const struct vm_operations_struct nvgrace_gpu_vfio_pci_mmap_ops = {
 	.fault = nvgrace_gpu_vfio_pci_fault,
+#ifdef CONFIG_ARCH_SUPPORTS_HUGE_PFNMAP
+	.huge_fault = nvgrace_gpu_vfio_pci_huge_fault,
+#endif
 };
 
+static size_t nvgrace_gpu_aligned_devmem_size(size_t memlength)
+{
+#ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
+	return ALIGN(memlength, PMD_SIZE);
+#elif CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
+	return ALIGN(memlength, PUD_SIZE);
+#endif
+	return memlength;
+}
+
 static int nvgrace_gpu_mmap(struct vfio_device *core_vdev,
 			    struct vm_area_struct *vma)
 {
@@ -186,10 +211,10 @@ static int nvgrace_gpu_mmap(struct vfio_device *core_vdev,
 		return -EOVERFLOW;
 
 	/*
-	 * Check that the mapping request does not go beyond available device
-	 * memory size
+	 * Check that the mapping request does not go beyond the exposed
+	 * device memory size.
 	 */
-	if (end > memregion->memlength)
+	if (end > nvgrace_gpu_aligned_devmem_size(memregion->memlength))
 		return -EINVAL;
 
 	vm_flags_set(vma, VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
@@ -210,7 +235,6 @@ static int nvgrace_gpu_mmap(struct vfio_device *core_vdev,
 		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
 	}
 
-
 	vma->vm_ops = &nvgrace_gpu_vfio_pci_mmap_ops;
 	vma->vm_private_data = nvdev;
 
@@ -260,7 +284,8 @@ nvgrace_gpu_ioctl_get_region_info(struct vfio_device *core_vdev,
 
 	sparse->nr_areas = 1;
 	sparse->areas[0].offset = 0;
-	sparse->areas[0].size = memregion->memlength;
+	sparse->areas[0].size =
+		nvgrace_gpu_aligned_devmem_size(memregion->memlength);
 	sparse->header.id = VFIO_REGION_INFO_CAP_SPARSE_MMAP;
 	sparse->header.version = 1;
 
-- 
2.34.1


