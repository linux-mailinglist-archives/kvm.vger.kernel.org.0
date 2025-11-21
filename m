Return-Path: <kvm+bounces-64135-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A260C7A0A1
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 15:12:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sea.lore.kernel.org (Postfix) with ESMTPS id E49812DF43
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 14:12:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E18B34B19A;
	Fri, 21 Nov 2025 14:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="oo8qWLjp"
X-Original-To: kvm@vger.kernel.org
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012047.outbound.protection.outlook.com [52.101.43.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8291733508F;
	Fri, 21 Nov 2025 14:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763734335; cv=fail; b=snjLohfUSRNHGlvrzVXn9RwyC1anrF79UXdDRgdvHx1wvydm1ic2r5RitAJzzG2pkQDklRt5sTtc437C/zqKnsUTwchh4FAbOqLbvwNJAmG5ZMoK3gRaTAaLUD/k0CjcbkVxb0bGFl7rNxDdVTgUa5n6rlQf5XopB/5ThYAacG0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763734335; c=relaxed/simple;
	bh=QhXm5e1k0/7NMoIh8aIZ1M4rtYPvrqtcA/swbOqqQMQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZvFO7D7rRkT1HxpgWC7SeNnzF1C9np1Ry+uPa6dzzBPGdjwp0mZAV2sG/9Zh/xtxBlZSLN5+nQz2CHLIwU60c7dEymiFuUBuseknAHQOThNvI3HbDU39ijL3h05GtyGmnhaBtsEuxJbSY8TegrgJqbblTiZtquwicvYyxcKiTu0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=oo8qWLjp; arc=fail smtp.client-ip=52.101.43.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IF0re8WMBS9yD0bzEL9kM7D8ZWvbYVbqaIMBc/br0oXcEIwyleZEai76WAOJ2lDC3ciiJMX2Ya5j41umfYg8XVCV0gprbPs6MoVpd9mPf3h/OckalpLUOW7Oeq7snj/9zTRtzV72npNrSyK1gDmYr2648cIJmmuWqI9UlPFeUHeAErcXqNNjxJyK96HxSaR9mE9Jvc3KVboyB5vZwc0RskiV2Nrg9WZD8yRuDCbMVAfP0F2RO+Bk7J+VEMAAIdilL7n9Z5eCa9o41zFIr424Nr9w4WcgFlw1as3/5nM4eLnzBiqlU88CLMOW6bs56ElDgngI/fHsY0eaVPZBTullTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TDOu9Iq34WkH/5oFljARSAIrj2XxcNmUFrm+hF03KSQ=;
 b=Tv8duNruVuqFXTcSnGDFIg5NoTdwDZ9vBFHDYS8Ytx6LoT8bFJ0RJjHZY+oLtC4oyhYecUpwuTRzPO8YXzwahLtThvcHkoYlAPFAE6Qu/dLIWxx0eofz9VurkbL9dUEgu3zMLDbBTawbrZ8hGk5oRRCxUNcTDQiZ6aqD1E2/tCFrZAnLyOrsBrukBTAwL4lPMVIkomBETjP+JnJ0nA3rtsSvWk80afUabelaBfQbRbCA+n654yukuaumgFWzWNTpnq3FDKocYfLVSmDp4AC0vHaJA5q+vZUC3KTjYmmwc1txxK3MO6zL7EY/486XGgY/hZIvkpgXpUR79GZLDhoKXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TDOu9Iq34WkH/5oFljARSAIrj2XxcNmUFrm+hF03KSQ=;
 b=oo8qWLjpoAoC7bGNNU60WBZmGESpUUNjHJtUKrsKDBo5Iy71WId+DsFcxI8WvJ68rhCDFmJGmvuHA/IbVyBcL6XQLVJIGtLtXt9pyo3cbmmc1ydDrhzwoXFBOeNrI+IpCsQUmiVmZWy7d+RIPgqWCPQLretVEY4hnkg2gKY80gBYxejfotbOxUo24pth4ZX7U4E7s5HWr/ZvGiFuisMkIHdJgDuIR8ilNjyvLwmLbUN/OKVyPG70yWBWZnKOVu/XWOa8TSoiYc0Q1UMfoWMZyKKBrx5FJ1xEbtreTuV8jGlKpR40YcUKWPfLdNiF/GAobHp5klCTCTLTJuySmn+WWw==
Received: from MW4PR04CA0248.namprd04.prod.outlook.com (2603:10b6:303:88::13)
 by MW4PR12MB6975.namprd12.prod.outlook.com (2603:10b6:303:20a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.16; Fri, 21 Nov
 2025 14:12:09 +0000
Received: from SJ5PEPF000001CD.namprd05.prod.outlook.com
 (2603:10b6:303:88:cafe::28) by MW4PR04CA0248.outlook.office365.com
 (2603:10b6:303:88::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.12 via Frontend Transport; Fri,
 21 Nov 2025 14:12:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ5PEPF000001CD.mail.protection.outlook.com (10.167.242.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.9 via Frontend Transport; Fri, 21 Nov 2025 14:12:08 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 21 Nov
 2025 06:11:44 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 21 Nov
 2025 06:11:43 -0800
Received: from
 gb-nvl-073-compute01.l16.internal032k18.bmc032b17.internal032f11.internal032huang.bmc032l04.bmc
 (10.127.8.11) by mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20 via Frontend Transport; Fri, 21 Nov 2025 06:11:43 -0800
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
Subject: [PATCH v3 3/7] vfio/nvgrace-gpu: Add support for huge pfnmap
Date: Fri, 21 Nov 2025 14:11:37 +0000
Message-ID: <20251121141141.3175-4-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CD:EE_|MW4PR12MB6975:EE_
X-MS-Office365-Filtering-Correlation-Id: 861b8e3a-6901-4de4-f3ed-08de2907f534
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+d/FtsPtZ28pXzrgiA+NgLeUfo+n3uOkmV1E59aFqjS6nYGZHfIOd3O9j7ai?=
 =?us-ascii?Q?6hRZoIgHGYBB1VALXnuzbAbxvC3xQkcdqFi+etA3laUoLqfRN4Qg6YqzIob4?=
 =?us-ascii?Q?19BzSkgegfq0EsM5l/iLDR7w+nvJ7oH6L1xIYuXPbfsKaMjuy9MymlCktO6C?=
 =?us-ascii?Q?hkTmaVMKWKX6YK+VhOiOa29qf28/jy6TG++b7zj9xDWaoUDZUMwCCLEGbD4H?=
 =?us-ascii?Q?oeMqZ2y3vv6FijWZzu7EUcIOBwtXP7MywbgfiYKgpIIXm7C3AKg3+706wmRh?=
 =?us-ascii?Q?zu/TLCdrL5VQSWoS41Q+PCdBXpmmLHQZbbBKpHNXBCCvFoN8ZwukyhCy08l4?=
 =?us-ascii?Q?EqsFOepfoh+fKtOENxSliWBd+sC1OZjbVVB9x20RaEYjpxqxlo6IJJ3GcpLU?=
 =?us-ascii?Q?S8YGHglyh05SpPXhlDdDZ15WpF1KgJOxML2CFQKYz0XTo0YQqcjvLPIKoql/?=
 =?us-ascii?Q?oCVtE6aZV1Tylg5DpxzWwntC7phR6wW4toD8GuxJlUt8U4NDOzxA5k9vDDVr?=
 =?us-ascii?Q?gvH3dGwVTXSASdMpxBCZChjCwUPemwF8cRcAgpH74O8b+ckMSByjYNPcqvBL?=
 =?us-ascii?Q?Yyyt8+IjKK7pUj3YPJrFELo3LBvKc0tQ/ZV9pAYoueeDQQIAF82t33pf78gF?=
 =?us-ascii?Q?x+EHFEFU3187l+ossHezhtOxXraAIPujFYjxnphHVAPp7/MxU6PgvtSusGh8?=
 =?us-ascii?Q?jb929bHV8lpno5S37Zmx/dAwgv3ioTG6PXqXd4ajQYxw1J5toR3EMMrlEkEo?=
 =?us-ascii?Q?TF2oblkF8riMrHAKmbIs1SQoI3IpxR/OwvikOKwhI6yXZIA9N/pNs3mNmSfe?=
 =?us-ascii?Q?2n38Hiu0xzKXJi0x9VWLDR7Oo3C/6gNI34jhvz7NYLJa+t2o2tHMfSQWFjlp?=
 =?us-ascii?Q?zHaA4kLSrbf+FGHy3/fKxudqWoWb7MW2Tga5a1yHgbqg3dD8KPlXJdSAAX9V?=
 =?us-ascii?Q?5DFIbyk6deQGKNpmhHMXgFDM53S32UaX+ybRHcuYOfe3BcBcIia7e5AQR0p4?=
 =?us-ascii?Q?vi++s1YST/SO28XdD3EEIBMEn/zfQ2U5HLn4t51xkjApDDw5ZXLsJ4b4p+Au?=
 =?us-ascii?Q?YnYuzxv6Yi6zsS3Tj9U/3VE+oInObvr3wuWjLLQCQDBQ2t7l/oUH5NqdRN6C?=
 =?us-ascii?Q?AxdwxCdvPKTKW7Lel8hpJRl6RZ9jdsLlMbWk9FivEXjho/nPbWoNdZSRIEPn?=
 =?us-ascii?Q?7hzfapnLcMLvB07DWlpGoK5IzVqA+08a+T0cHrqAhCib03mjv5LYBBnY1WTg?=
 =?us-ascii?Q?KlvFYzNe+OaqVAkDSad6SlnXYo1hIeeKQlzHWecWR3xFjHqak0xE1wyHu3Fj?=
 =?us-ascii?Q?hyMPwfpvtETfT5wGa5EQtgoE7NX7kD0iblvQtLvHwOTGMlWMkWgncpVDKSOo?=
 =?us-ascii?Q?roceW7Aax6+dl24UEsBAJOPgLB+Qz/8JvaZ+8AC9708GB4O/FFRLSDgPVRhm?=
 =?us-ascii?Q?BNhdlqddKaFMIH3KjrlPH4ZU7Juc1f3oFt1a/7vwupN37lnuOpyZ+/sgiPp9?=
 =?us-ascii?Q?/s1JjgVw+RS/4W12ZPzu4Qk123pY54vXRSk2ZcewaMd3TXBkTrtNCDs8HqeE?=
 =?us-ascii?Q?TeHX2h1VUAZia1aw/y4=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2025 14:12:08.7232
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 861b8e3a-6901-4de4-f3ed-08de2907f534
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CD.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6975

From: Ankit Agrawal <ankita@nvidia.com>

NVIDIA's Grace based systems have large device memory. The device
memory is mapped as VM_PFNMAP in the VMM VMA. The nvgrace-gpu
module could make use of the huge PFNMAP support added in mm [1].

To achieve this, nvgrace-gpu module is updated to implement huge_fault ops.
The implementation establishes mapping according to the order request.
Note that if the PFN or the VMA address is unaligned to the order, the
mapping fallbacks to the PTE level.

Link: https://lore.kernel.org/all/20240826204353.2228736-1-peterx@redhat.com/ [1]

cc: Alex Williamson <alex@shazbot.org>
cc: Jason Gunthorpe <jgg@ziepe.ca>
cc: Vikram Sethi <vsethi@nvidia.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/main.c | 44 +++++++++++++++++++++++------
 1 file changed, 35 insertions(+), 9 deletions(-)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index ecfecd0916c9..3883a9de170f 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -130,33 +130,59 @@ static void nvgrace_gpu_close_device(struct vfio_device *core_vdev)
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
+#endif
+#ifdef CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
+	return ALIGN(memlength, PUD_SIZE);
+#endif
+	return memlength;
+}
+
 static int nvgrace_gpu_mmap(struct vfio_device *core_vdev,
 			    struct vm_area_struct *vma)
 {
@@ -186,10 +212,10 @@ static int nvgrace_gpu_mmap(struct vfio_device *core_vdev,
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
@@ -210,7 +236,6 @@ static int nvgrace_gpu_mmap(struct vfio_device *core_vdev,
 		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
 	}
 
-
 	vma->vm_ops = &nvgrace_gpu_vfio_pci_mmap_ops;
 	vma->vm_private_data = nvdev;
 
@@ -260,7 +285,8 @@ nvgrace_gpu_ioctl_get_region_info(struct vfio_device *core_vdev,
 
 	sparse->nr_areas = 1;
 	sparse->areas[0].offset = 0;
-	sparse->areas[0].size = memregion->memlength;
+	sparse->areas[0].size =
+		nvgrace_gpu_aligned_devmem_size(memregion->memlength);
 	sparse->header.id = VFIO_REGION_INFO_CAP_SPARSE_MMAP;
 	sparse->header.version = 1;
 
-- 
2.34.1


