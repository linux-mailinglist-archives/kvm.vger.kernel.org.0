Return-Path: <kvm+bounces-64524-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 7414EC8635A
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 18:31:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 598BB4E2663
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 17:31:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86F4632AAD1;
	Tue, 25 Nov 2025 17:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SajkYf96"
X-Original-To: kvm@vger.kernel.org
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011018.outbound.protection.outlook.com [52.101.62.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B6DD3C38;
	Tue, 25 Nov 2025 17:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764091843; cv=fail; b=agKxV/YZbpMhgl/E7kmRIye0jb6R4KZ8qvzQBU7oo83zY8n83Evt8Ydr58zMNQtFYxSPaDTP+X3IqE5qdqgj3qgFbVDAlXEIv5SO/k1rhs85Z5nulrGjxVPPsTC8wgZHNJMogaBdBYk9j236wY4eXjPeLVL6JGoV0wpgvKIqLbg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764091843; c=relaxed/simple;
	bh=73wuU2vAM2cuHt5y+dT3+jFBeuDx6rXmt89Sf+fSjRg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uZPiSrq65bXSO4P0P9shzsEdsKjFtAKSLKVnYmYMhTTq0Qan6l4XmONEz8E4/uqoY7Zu65DMHlLdUH589p9z3uLgyCDK4aIxccC29csqlUYPXHo0yGs629JZ/7AgUslCmpx9UFXuozjZsHuJgRzkz9Y7jqI5p8dAOtiXH5damoM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SajkYf96; arc=fail smtp.client-ip=52.101.62.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JN4+7mxKrN+Ku8Pvr1ZcJ9H4lsLCkjo8HR4Dv/ho7eAPMi7URM4L7SrA49TZ6Ey6bLnn2PZXPKVaaXMitLdsDc/BmkB7bi9FG23CgaK7ZNi3uu87c6vMa1LqPm5WnKgpzaJOVPFxCOFflgXMeQz290tde1xP6L85vAkLiSnH/9hxcTZ0T+CWmrrveTmhq5a1u4hJerPGLMxv42qwVCesheOEhS+PkIbeVU0ig4wwT0mIctT+lL2vyG32h0QHYcy3mjUoXvh8J/7Jh1yzKhueqKtSoI/rt5jwpqIvUmAXI5/1v2BLIZSOJ98gIjP0stcxthm6yvlzzCn9wWvc0cvuog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r+I/O8/a0glByNDf/ul5DYnZgDqWXJdRhn/u+lqZTI4=;
 b=lwWAGEaRxNr3NyOhvpRBBOT9vNh7inOX7zPc28LlJNQZlc9nnyS/NCEIvn9KfnZ8SnMBPDxkBO+GSN01aT2694iwz2Y1fyqJvfFWJgfmTndNB4Ik0phuLpCR3SXCgo2lhESEFOnpO2A6Tp8Df7C7VtAOHE2gxnKPzdcWq6IJlBE0ivx5LMcbeGCkioQjMlhAiuxbq6/G7CTzPFR35bfroX9i7ePdIq6K1L2QynH48MaBashBSVVDYOzkp+t4nsmk22jC/UMt4/Ir17EraEBfrHg+0dcWFHum0yYQxWHjdxKh3VW25fw9FCXdXvsMfOCwb10i9lYUXgkrEzpziAVYQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r+I/O8/a0glByNDf/ul5DYnZgDqWXJdRhn/u+lqZTI4=;
 b=SajkYf96q38ohf7vYcG3XsufCaL/Y2ztGo46taQnYn/DXK6yXiBYQFkHbjdTHuJNHWRL4x4lLCjZQsmycEVMcfo0Qga/FU84xCNoZrfR9G2jDybxZOAX5ttdc/KNA9wJS9H9cfBryEMJPkdADx4HaeRWYysep/5lACVRf3wEkuMBAlp8mvvLWuUGNknls5Qpuizp27HWIE1q5EH51GqOtq1WgErP3nuaEaWrL4oxwkvceoCQ/n6tk/6e5W3BPepPWzGS5SaxvIJM2jtRjVfdYqo+vsvSp6FRMbr/SwMpZ3gwDjyjTb5eJG8fNqwA+cLxgi+HJg7F9poRaRRk19N52A==
Received: from MN2PR12CA0036.namprd12.prod.outlook.com (2603:10b6:208:a8::49)
 by MN0PR12MB6293.namprd12.prod.outlook.com (2603:10b6:208:3c2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Tue, 25 Nov
 2025 17:30:35 +0000
Received: from BL02EPF0001A0F9.namprd03.prod.outlook.com
 (2603:10b6:208:a8:cafe::dd) by MN2PR12CA0036.outlook.office365.com
 (2603:10b6:208:a8::49) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9366.11 via Frontend Transport; Tue,
 25 Nov 2025 17:30:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BL02EPF0001A0F9.mail.protection.outlook.com (10.167.242.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.7 via Frontend Transport; Tue, 25 Nov 2025 17:30:35 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 25 Nov
 2025 09:30:14 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Tue, 25 Nov 2025 09:30:13 -0800
Received: from
 gb-nvl-073-compute01.l16.internal032k18.bmc032b17.internal032f11.internal032huang.bmc032l04.bmc
 (10.127.8.11) by mail.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20 via Frontend Transport; Tue, 25 Nov 2025 09:30:13 -0800
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
Subject: [PATCH v6 2/6] vfio/nvgrace-gpu: Add support for huge pfnmap
Date: Tue, 25 Nov 2025 17:30:09 +0000
Message-ID: <20251125173013.39511-3-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251125173013.39511-1-ankita@nvidia.com>
References: <20251125173013.39511-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0F9:EE_|MN0PR12MB6293:EE_
X-MS-Office365-Filtering-Correlation-Id: b0622f0d-47eb-4c87-7941-08de2c4857bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|7416014|376014|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6OGkqcyatpEMRTfk07GMfQbjtJ6oIoHKa6ci1z09WT/UMyKxKv9tCtJU8dbl?=
 =?us-ascii?Q?AF4IAijlcYogWR4GvtY33hzNYPVhhre4hX1sGwe6MRxkID07c7lp9lth0lkE?=
 =?us-ascii?Q?m13eLL5ISOS/EpnMNySE8RuV1Wz0cNLnkVlKY5PI3ZCr1ohKhAUhoFIepRaw?=
 =?us-ascii?Q?sXvByvh9W/KEqqWbdxn2m/02HyYHPo7x7KlFa54AsiIuCYL0ckJ9jnLY8jSd?=
 =?us-ascii?Q?SZ2A0Jtnw3vAAOdJUJAbo9UYERnt0GKiZ0TWjyYXuDOraF5BCfAAOwWYccPe?=
 =?us-ascii?Q?W84YGbrOaRaZJ91LxwtX2ReKTUjbRUZOojLj5yKH7kXk+ZHAgFzhBDwLtu2o?=
 =?us-ascii?Q?QlZbOs0iSF/XI7CxftxFaUdLqiYf4/laDq2REQsWL5C5kShR35IpF9K2h99t?=
 =?us-ascii?Q?otSCaGETb5mCXhYbaJnWIhhCkK1rq+FHUJHmci01+bw7WhJ2bNHCAbG9CGPc?=
 =?us-ascii?Q?tMJtz6omSb8P2xHnIX5D6KQStDsijXmZ27jYU65kuyUCx39k9K5VxQRtTN0b?=
 =?us-ascii?Q?c1V/pNUa0JTQSG1YxC9zC2zSt7ydvJb2SihVpWzAK3+Nrr5p2uTftp5VDi1z?=
 =?us-ascii?Q?bcup04+7gLNKCqAIT8oKwrdWRU9lw/XHM8N+cSqWA8jxnqBGy5AFM8kZPL25?=
 =?us-ascii?Q?PznG4KMjgZGA4TEqbSj6kzoCqpwGRxRq9tRIOxUF1rvx12dCIY63c6sEpUoE?=
 =?us-ascii?Q?PbaiLpXkrTZXnE62fanl442+GpIQtlNaqiSpMrG/Qm3wTko97+wcncgIepWg?=
 =?us-ascii?Q?OgXLlJ0L4fDk7U/cgi7prlPjT/23gSRL9XrtKmQAZRKUG2gu/awZ+zJ4VN0T?=
 =?us-ascii?Q?t8OvYxI9TC7zXNJqmOlj5FOeiSVHA56sNV25BwZklhUGqA7Ejbd/7p0taXy9?=
 =?us-ascii?Q?m/AHOfb5/UKd9OvMizreaygVeJdIs8uStGXwHmOHhiOMvQGwN6EMMJ1wlu8Z?=
 =?us-ascii?Q?mqmYBxg4E4oiX9fDQDz6uw0CF33XPDyPCYf2soxzBmSU6sraOM+AXgQxQajc?=
 =?us-ascii?Q?PcUwlQ/jEhFrlmYI4Co/LlaSopWZ+cLEbeYCtlUcnlLVtszwqUS4HXFSHacP?=
 =?us-ascii?Q?ybwLFht66mNQZvAhHJyxCybf9PLyWbMzHJ7yNsO5Q2oRKAlzKFqGL94CkDws?=
 =?us-ascii?Q?y3Ap+nTCW+w9NPSRULN7z0Mc7sRGPph42nmbCCpsH+Mgd7tDsIzsYgYsvPKI?=
 =?us-ascii?Q?ZHXDoUU9oHIbeV/B49kk+tmax8rx+EQEt+dFvkfdYNMZqtYZeyFV0QiXWlht?=
 =?us-ascii?Q?ud6SnUzsaz25RuSk8HSCoeNnnvn5KQj4rwdSI0Sj9M3+AMWh90es7inOxXyY?=
 =?us-ascii?Q?wjTwpEa7Xha50+xhqdTHMxNisS06LY93QmLnOKGY/rMvb8owW2bRAi1Gdsc2?=
 =?us-ascii?Q?piZHifXhKrW6mL8nKys32QIl/l1zUKoQAOrV4UhC9QJONGoRmL/r1T+BIW6C?=
 =?us-ascii?Q?Jhq3FgtxN1+Mn6lNU7hr9wCqJntUhLuinf9/DSecofeh8lnTpLe7yFpOp7Bp?=
 =?us-ascii?Q?zl/0xQ/3pLr+KBdSmDbl+0Q2+E4l/kNiQYh9YToTz3vrFTTXd7gS8C64g3R4?=
 =?us-ascii?Q?5X65lWuefOjdQR3t4YQ=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(7416014)(376014)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2025 17:30:35.3335
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b0622f0d-47eb-4c87-7941-08de2c4857bc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A0F9.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6293

From: Ankit Agrawal <ankita@nvidia.com>

NVIDIA's Grace based systems have large device memory. The device
memory is mapped as VM_PFNMAP in the VMM VMA. The nvgrace-gpu
module could make use of the huge PFNMAP support added in mm [1].

To make use of the huge pfnmap support, fault/huge_fault ops
based mapping mechanism needs to be implemented. Currently nvgrace-gpu
module relies on remap_pfn_range to do the mapping during VM bootup.
Replace it to instead rely on fault and use vfio_pci_vmf_insert_pfn
to setup the mapping.

Moreover to enable huge pfnmap, nvgrace-gpu module is updated by
adding huge_fault ops implementation. The implementation establishes
mapping according to the order request. Note that if the PFN or the
VMA address is unaligned to the order, the mapping fallbacks to
the PTE level.

Link: https://lore.kernel.org/all/20240826204353.2228736-1-peterx@redhat.com/ [1]

cc: Shameer Kolothum <skolothumtho@nvidia.com>
cc: Alex Williamson <alex@shazbot.org>
cc: Jason Gunthorpe <jgg@ziepe.ca>
cc: Vikram Sethi <vsethi@nvidia.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/main.c | 84 +++++++++++++++++++++--------
 1 file changed, 62 insertions(+), 22 deletions(-)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index e346392b72f6..8a982310b188 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -130,6 +130,62 @@ static void nvgrace_gpu_close_device(struct vfio_device *core_vdev)
 	vfio_pci_core_close_device(core_vdev);
 }
 
+static unsigned long addr_to_pgoff(struct vm_area_struct *vma,
+				   unsigned long addr)
+{
+	u64 pgoff = vma->vm_pgoff &
+		((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
+
+	return ((addr - vma->vm_start) >> PAGE_SHIFT) + pgoff;
+}
+
+static vm_fault_t nvgrace_gpu_vfio_pci_huge_fault(struct vm_fault *vmf,
+						  unsigned int order)
+{
+	struct vm_area_struct *vma = vmf->vma;
+	struct nvgrace_gpu_pci_core_device *nvdev = vma->vm_private_data;
+	struct vfio_pci_core_device *vdev = &nvdev->core_device;
+	unsigned int index =
+		vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
+	vm_fault_t ret = VM_FAULT_SIGBUS;
+	struct mem_region *memregion;
+	unsigned long pfn, addr;
+
+	memregion = nvgrace_gpu_memregion(index, nvdev);
+	if (!memregion)
+		return ret;
+
+	addr = vmf->address & ~((PAGE_SIZE << order) - 1);
+	pfn = PHYS_PFN(memregion->memphys) + addr_to_pgoff(vma, addr);
+
+	if (order && (addr < vma->vm_start ||
+		      addr + (PAGE_SIZE << order) > vma->vm_end ||
+		      pfn & ((1 << order) - 1)))
+		return VM_FAULT_FALLBACK;
+
+	scoped_guard(rwsem_read, &vdev->memory_lock)
+		ret = vfio_pci_vmf_insert_pfn(vdev, vmf, pfn, order);
+
+	dev_dbg_ratelimited(&vdev->pdev->dev,
+			    "%s order = %d pfn 0x%lx: 0x%x\n",
+			    __func__, order, pfn,
+			    (unsigned int)ret);
+
+	return ret;
+}
+
+static vm_fault_t nvgrace_gpu_vfio_pci_fault(struct vm_fault *vmf)
+{
+	return nvgrace_gpu_vfio_pci_huge_fault(vmf, 0);
+}
+
+static const struct vm_operations_struct nvgrace_gpu_vfio_pci_mmap_ops = {
+	.fault = nvgrace_gpu_vfio_pci_fault,
+#ifdef CONFIG_ARCH_SUPPORTS_HUGE_PFNMAP
+	.huge_fault = nvgrace_gpu_vfio_pci_huge_fault,
+#endif
+};
+
 static int nvgrace_gpu_mmap(struct vfio_device *core_vdev,
 			    struct vm_area_struct *vma)
 {
@@ -137,10 +193,8 @@ static int nvgrace_gpu_mmap(struct vfio_device *core_vdev,
 		container_of(core_vdev, struct nvgrace_gpu_pci_core_device,
 			     core_device.vdev);
 	struct mem_region *memregion;
-	unsigned long start_pfn;
 	u64 req_len, pgoff, end;
 	unsigned int index;
-	int ret = 0;
 
 	index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
 
@@ -157,17 +211,18 @@ static int nvgrace_gpu_mmap(struct vfio_device *core_vdev,
 		((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
 
 	if (check_sub_overflow(vma->vm_end, vma->vm_start, &req_len) ||
-	    check_add_overflow(PHYS_PFN(memregion->memphys), pgoff, &start_pfn) ||
 	    check_add_overflow(PFN_PHYS(pgoff), req_len, &end))
 		return -EOVERFLOW;
 
 	/*
-	 * Check that the mapping request does not go beyond available device
-	 * memory size
+	 * Check that the mapping request does not go beyond the exposed
+	 * device memory size.
 	 */
 	if (end > memregion->memlength)
 		return -EINVAL;
 
+	vm_flags_set(vma, VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
+
 	/*
 	 * The carved out region of the device memory needs the NORMAL_NC
 	 * property. Communicate as such to the hypervisor.
@@ -184,23 +239,8 @@ static int nvgrace_gpu_mmap(struct vfio_device *core_vdev,
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
-
-	vma->vm_pgoff = start_pfn;
+	vma->vm_ops = &nvgrace_gpu_vfio_pci_mmap_ops;
+	vma->vm_private_data = nvdev;
 
 	return 0;
 }
-- 
2.34.1


