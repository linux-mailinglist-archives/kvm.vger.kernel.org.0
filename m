Return-Path: <kvm+bounces-63510-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8741BC68092
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 08:46:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sea.lore.kernel.org (Postfix) with ESMTPS id 332B92A356
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 07:46:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4BB33064A7;
	Tue, 18 Nov 2025 07:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YVKO+iXq"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012009.outbound.protection.outlook.com [40.93.195.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ADB2305E2E;
	Tue, 18 Nov 2025 07:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763451890; cv=fail; b=obmj+kJKX/Hux1wk7Z7fFyKI7MJTGmFsqmGeFMwoYwxBS3wXcEcBR380S//zmv+gQqbSwqh+sRlK5gAjhVltp+vpv8pDAtdrxHnKrwvfJpzW7DZhPWtMl5i9hCs3cxcz6rEeS1xeDluHPxyroMfMEdXIwAJDTwCBKAy1FXlK8v0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763451890; c=relaxed/simple;
	bh=QhXm5e1k0/7NMoIh8aIZ1M4rtYPvrqtcA/swbOqqQMQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gq0RqinSXiffmZTmNqMY3tG8MNUfmT+KxtR01bB9CZzQ30HMfMFcdb1MiQIqHPpkwOF0xV5g4lvGnrP7GBHYiFf331UwhtVzXeZ9alN2FUg1VMAp0SBi4IvgmSDO7drsULKgKpSlLllfXrAi3tkBgFC3TaFVnPpHZ6byIKLLV8Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YVKO+iXq; arc=fail smtp.client-ip=40.93.195.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S5sZ7T43JAdL32ppu0cFrIxHYF4H19nV0jSucPeKloWengbYwrMu9Z4kYr50qtPLmoMgloRjvqG9RMMPojMm2jZyJzsKBvH6kpnrDgPtyj3+cbDa1ihD/YE6SxenVH8xBXfTEBOTmzeSSgKA5rb52XHaWFdWLt3qlUXOW8BVqliI17KfoM9ARJ7UoWugieil10p6lTaYrlY/CBp5a9ylNFEr9v53sHf72AQXIJTpjOif+4kCT/i5foIccBgbLSs8PFMVjX4Fg+mSIOOdkgqW3j/UFB2P3G+w11eL6SlfYASv8skHayQ9a1NuK0sxqTlKK1xondzeE3krSGnHw8YXfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TDOu9Iq34WkH/5oFljARSAIrj2XxcNmUFrm+hF03KSQ=;
 b=ltSV1NQslJ0xsvDlAoqlvKl2KTXT3dlKPVs4vLMmE7kqsDmLJpvbtRaMyULGf/AqcJgY7DHPKmO/9UoxLNbNCTemNImK5y8wTHqNHQV9HQDuxw8ZsAs/LPQd1iX/jrdFVxi5zPczjHN/f1QVs+/iJ8Pc/bpxM5gsFT1nh7ZE37rFqh58kv8fE6f/5FTADQxaXuL2kJObp9RTmuzq7aYC5jsyBtOKjrPfnfuzYuENBILnpf1oXmS0Ke/7cGEcJ5V4QkmUNlsFhFsvJFj44Pgi7MgWzKybvljZugymQuWk1NKKHD38IeMgsiuIDZlBI30FogkMVxsQpngv3/OSinYidA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TDOu9Iq34WkH/5oFljARSAIrj2XxcNmUFrm+hF03KSQ=;
 b=YVKO+iXqNVR9KGDgngi9S8xQRfFSwlMn2Ccgm+xsMt32DNyaJHQpH7hu0+Eoo+zjAHXPXNBHJ8BLf+vUdwzu8W42zjW2M/KD7L0lYLpPgM0fISFdCCg/w5/2OCDpUw5zV0MoJjhcYdgDuOo/yZdFmAOXA/iGAEh+3Q2faQR+sXHGtarJE8lfFa3+Oflng9Fv/yOM8I17F9XdACmqf8HS67mFt0qaZEPJyabq9W4BiW8iOzKhsQ8vMUIbRwmS1bppgqeZy8xA/Ed1L9eRW9nk39vlAvOGjF6RxZVRNoBpZa1HBBTALSE6OU5f3/HBnMaH4I2tCjqh7Q3lA+yG8TDWlA==
Received: from SN6PR16CA0044.namprd16.prod.outlook.com (2603:10b6:805:ca::21)
 by SN7PR12MB8170.namprd12.prod.outlook.com (2603:10b6:806:32c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.22; Tue, 18 Nov
 2025 07:44:42 +0000
Received: from SA2PEPF00001509.namprd04.prod.outlook.com
 (2603:10b6:805:ca:cafe::18) by SN6PR16CA0044.outlook.office365.com
 (2603:10b6:805:ca::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9320.22 via Frontend Transport; Tue,
 18 Nov 2025 07:44:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SA2PEPF00001509.mail.protection.outlook.com (10.167.242.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.9 via Frontend Transport; Tue, 18 Nov 2025 07:44:42 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 17 Nov
 2025 23:44:25 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 17 Nov
 2025 23:44:25 -0800
Received: from
 gb-nvl-073-compute01.l16.internal032k18.bmc032b17.internal032f11.internal032huang.bmc032l04.bmc
 (10.127.8.11) by mail.nvidia.com (10.129.68.7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20 via Frontend Transport; Mon, 17 Nov 2025 23:44:25 -0800
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
Subject: [PATCH v2 3/6] vfio/nvgrace-gpu: Add support for huge pfnmap
Date: Tue, 18 Nov 2025 07:44:19 +0000
Message-ID: <20251118074422.58081-4-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251118074422.58081-1-ankita@nvidia.com>
References: <20251118074422.58081-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00001509:EE_|SN7PR12MB8170:EE_
X-MS-Office365-Filtering-Correlation-Id: a7500aef-ceca-4fe8-cf38-08de267655f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014|7416014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KKzepdNyUdjU2tPZkzTpheVQ6Hqwl2xqi5sHa+6r9Zldaz24dtTC0cpnB7Zy?=
 =?us-ascii?Q?+XoFcmWHSrXM+caDQeMPzU/pw9U0MHRMOc3NgP8TR8fTzWWQLrQ0boQHgSn7?=
 =?us-ascii?Q?L9fzC+YYfgz8S66SxjsBwASMZQMd8/UX1fNrSMNzeIgGnvr8R9EGdYqAW5/i?=
 =?us-ascii?Q?awhL1mH/g43vZLKIVM5BIuGqOIpCPmXBmeei4ce5IF8I1Wdafs9uDR9eiWWO?=
 =?us-ascii?Q?Bm97qivkHLIwuFyt5NUAxf/QrcALuqj7wRo8GhlynLhPbRJlQYqjIcKB6zFF?=
 =?us-ascii?Q?pLRwFB79rsKDDQ0pfBAIzrVHsdc2rDagKcBoDMovm8S+3FqQRNXhLvnJ/Rbd?=
 =?us-ascii?Q?w6GFI4QOUO1bdcrTfCc5mq0OnDjE9LHfFj3F3v8yf8X0wCPhtPawqHCHanaB?=
 =?us-ascii?Q?ELjFdeXb4oVK+0W7Wm/Lfv7bQOeKJVphw12/ECWYz708bFjTAhWmPgYNlSgr?=
 =?us-ascii?Q?H2u5DR/8w1uM+j75nPhLmkuKWCAZeLuey6BLjOq6B3YpUByO1NpFBEOodeVP?=
 =?us-ascii?Q?EKsHu+m71ebfUjGnEHolhOPskf6xnHwhqEEAtI68lnxQNRBIN6j2x2zFYuUP?=
 =?us-ascii?Q?9o2RsGCPDpu/eRzrbS3U+O+6BxtoZrvDWGzNakOq4amCVbmpN4XRVz3kEly4?=
 =?us-ascii?Q?PM/zoDlqxlK5VlArSZKFxNlb0TmhdF1+mKHSO8zofgp1+N704MYZ66fHo+mK?=
 =?us-ascii?Q?yEj6SDAESOK2gS0XVyVt548d65NlrUIgMez17fi2F5qzBC+wy6JQDQugL2KV?=
 =?us-ascii?Q?K+l1CG1eaiO/92yS5kBE/PIt+akF4a5kIM0Sc8ftkDd8BvbkrIBsV6G0TqKi?=
 =?us-ascii?Q?EKMuiZzfwYS0q8fbz0RBhPMZpFr+RaL70r9wl0PPmTvx3FVnDjvwzEVf2h1E?=
 =?us-ascii?Q?SIurgMqTQ5inZlXUO+Da+KRV2OeJPCpE0/K2ztC9l0Y4F4fhajFpvifExBkl?=
 =?us-ascii?Q?6IA3Zcex1RHCvgqKN90WM8+rLR/v3UDgu25w84uwxQMx9qOdXPHPCKFdKR3F?=
 =?us-ascii?Q?XJuG9cf/PzEDgtNG2l87WNMqpiBTuc5do5ob/BFj+wNBOuUX7i+vJWGn5L2K?=
 =?us-ascii?Q?FOUYzN5gzCSj+zHJMJh9xOpg2iZRlrvalw8vZPt6o0CLE4/glgJF94637TAd?=
 =?us-ascii?Q?BDk7LNm61isoACrMo0yO9kLOSRYrDmaQ/Rdpo9RjPKXTqkEKDweN6yh6bBvq?=
 =?us-ascii?Q?svC3lVFESOCLz/ZjSewYqWVFw3L2VM6eahU75mPnD2bdqMAkFwPTc8XHK2MY?=
 =?us-ascii?Q?TP5Di7TfJkgPW1iRRsibb9bRRMlSB/eQq0yGy0PA+zcbOe4nh2LjWR5ZCqUF?=
 =?us-ascii?Q?X87OJLOZVISWfD/fkUMIw8CpYuWgcmaDx3ET0vXv1/iV4MdeKMz11+fbSpoR?=
 =?us-ascii?Q?KvYgQovEUKTeo+0+L0MIh+B0V+wnlqzTXr+s2L00ryHyfmXEq7WpFPRaJML2?=
 =?us-ascii?Q?k8kg0Nx0FtY5pqoPSAtIkHcFgL3jVXVy7fQ73NszX8wUl3PD60q+h7M7TeZ4?=
 =?us-ascii?Q?jtbwNnA9u/vGHF9nKg61GbJj8Uuu105SY48TizHs/87LuLDrM8cb6K7CLRST?=
 =?us-ascii?Q?aU0h3hqxl/yHzvNJP7A=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014)(7416014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2025 07:44:42.2009
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a7500aef-ceca-4fe8-cf38-08de267655f8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00001509.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8170

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


