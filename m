Return-Path: <kvm+bounces-64599-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id B0551C8824F
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 06:27:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 09E3F35253A
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 05:27:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF09731618B;
	Wed, 26 Nov 2025 05:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BMlFj2/0"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012043.outbound.protection.outlook.com [40.93.195.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EA6A313542;
	Wed, 26 Nov 2025 05:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764134803; cv=fail; b=fh8upxy9kzC5i71VbgbUBDsJDOO848lmUM0rRpH/HgG2xmEh0ZnsLC6TR+75t464Ak2yMMJmRkboONFeBrnkFCeEsRJKX0msFci52ED7SArrk9b/8F7evaa94MNWUzYxZ9oaa9lcWRqcEd6BR6X5ZUDgIck1KVZ6NdkndLiytHg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764134803; c=relaxed/simple;
	bh=P+INW4A53zHoCdRe8sUdm0Wy7CwYSiy6kd0pWy+3Z1s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j09f7758SBCghLvKsh0i8X1GaVf9XgilKjB73Df1nZAMx5NLGaY6a7yt91sxsOMyYjH/MGAwW8fIFZwQZ9zyuHUpUWr+C5gQH7R6pN99NpbFMf3jQD+JWWUVmXseN3ETMWobqnMiVn2Vym4vDCH1mx0UfW47ExuSCi+q1LN3/UA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BMlFj2/0; arc=fail smtp.client-ip=40.93.195.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cAP0oKfS1muY5fTOkxShvrqSUX1ZJznirWlVPqsNR0XbUhNxR2LPr1e4zL+vHAN4xNVSJPo5gH/m7PL5GXjvjmq4VFuVnQA+IUuFOsJHSmPNttsqHe6A9+ySTeQKrDGK6YbMraQs2D4bMakjLEbc5SieBZCi5ZVHEiAegb8BkntVAIerQtgBt+oCUeETTNFH7rIXxk+mQFRLZ/yB/EdTFS/J9LU5fMXpRBq88F/I2a46MgUf4L6xv8LOjnOuQuDWrFeHXmt6xjBgZSnt+TTcrIeIFatO33TMd+JyR3GYhiUiymOvuN4X5CLLrHtUocus0VLdcXHmioGVoaGshVvvAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5UD7rug7GnMZuvlNO352L9JYHY57pC0cIOmc+NNNzXY=;
 b=xUJT4u7PnozLTQoFqwDDuO2O6vfAnWxor8cEAyGfyKx5RiiVU8IaqsiZjdaE6Df232oHMMMJvICTFWNv6PwLyXj5dNQ4rJzDAl3ayLEGgbIJ/r/R0Fx8Uex1Aue3vsQM50QpdU8YcyLCnY/njKnyxpa1Jw1sLw3gwy6JhSVOiMhJ2HYv8GH+k2zjGvFThFaF6ja+vOAs+RuhR2yJnPeNEkLUQEGR30gE94KNt22SqAuLZWmCGpmE7oZbpDUoF4VPUpu4DQ+vNBzkefZUWHfpTCd31+NxT6P8wDguEkZfEKbfmal0QEzBVqVwi9Zgy+7MCzmG1jyn7Nwy8o0/sFOf1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5UD7rug7GnMZuvlNO352L9JYHY57pC0cIOmc+NNNzXY=;
 b=BMlFj2/00xV1SnUxDcmIYoKAAeHmk8LqWZyClyuleU7qIPULvWVuBOvaXkFcMLx2W9bhf80lzZ93ygTmvTYQKEZPMKrYqf8k5felCwHnI7Lv6YTAwVBOM5oz5RPYvqm+pzjmbwSMYhpNaGHN53FgmaWT3fdGKOYdsQr9io+4DKq+7HlayGBHrVdzJgHk0ioi/pXnfbDRPExISxc8BdjU/+yYDPTa1dSEd4+Z5BBp/Qa/lcO2xKbga+A8Na3ZF2+/Dj0y7hr4dEq6Mu06dq/mnQbAQ80kQ/a6PZKzqKIE6x+micmXqH0vVEto8aYcJcqFo9oG/5pGNlxGboggJgIQag==
Received: from SJ0PR13CA0215.namprd13.prod.outlook.com (2603:10b6:a03:2c1::10)
 by CY8PR12MB7681.namprd12.prod.outlook.com (2603:10b6:930:84::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.11; Wed, 26 Nov
 2025 05:26:37 +0000
Received: from BY1PEPF0001AE1D.namprd04.prod.outlook.com
 (2603:10b6:a03:2c1:cafe::47) by SJ0PR13CA0215.outlook.office365.com
 (2603:10b6:a03:2c1::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9366.12 via Frontend Transport; Wed,
 26 Nov 2025 05:26:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BY1PEPF0001AE1D.mail.protection.outlook.com (10.167.242.106) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.7 via Frontend Transport; Wed, 26 Nov 2025 05:26:36 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 25 Nov
 2025 21:26:28 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Tue, 25 Nov 2025 21:26:27 -0800
Received: from
 gb-nvl-073-compute01.l16.internal032k18.bmc032b17.internal032f11.internal032huang.bmc032l04.bmc
 (10.127.8.11) by mail.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20 via Frontend Transport; Tue, 25 Nov 2025 21:26:27 -0800
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
Subject: [PATCH v7 2/6] vfio/nvgrace-gpu: Add support for huge pfnmap
Date: Wed, 26 Nov 2025 05:26:23 +0000
Message-ID: <20251126052627.43335-3-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251126052627.43335-1-ankita@nvidia.com>
References: <20251126052627.43335-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BY1PEPF0001AE1D:EE_|CY8PR12MB7681:EE_
X-MS-Office365-Filtering-Correlation-Id: b523fa02-d88b-4740-3a5f-08de2cac5ec6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|7416014|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cSqhMxWKV9kduH79C1D3FLDE4t+STyY6dAtW9RI7uMIMlJaWZdoT80zSRcqD?=
 =?us-ascii?Q?x+UTZMShbZyGRshP/0Luu91mAUDW7PAspDhbalx1wtJTcmdRtZ3gL4VQk6aQ?=
 =?us-ascii?Q?a9YYCFhm2KFihbleWDhhB4nXCZKas/RJeTIA/5Hkocw4G8bQHq5UdQftv6aD?=
 =?us-ascii?Q?hCLgdGMx24cXrRQO12GmEN+aYBfEJvuvoTCACZq38UdrBCnVdIoI99ssed18?=
 =?us-ascii?Q?uK6pvJc9Pwx6ST1dKKQzrKEmgvOuDiV04KyRJdd9oOG1XAEBizB0vI2p/u5Q?=
 =?us-ascii?Q?tOPXLTDRFhejewx+aR2A9zYsnQW5lr2r/ZZjcp7VH3J6Po+8zTfixjaXJ5CC?=
 =?us-ascii?Q?cIYUo9GfX98/ww32g7gALJ9C7KKDjZtgY9dbOjbDrOG+s7ZdKJCHQMdCt71G?=
 =?us-ascii?Q?QAkWYzRh0FXYJvHNLD3T1E8YurPBi72h0MJZVaEvY+hMSDgLvXfi4FZUORQd?=
 =?us-ascii?Q?yhdDudIL6PFVrRp1TfAdyGoSb0rt6tAJXuvDozLy7CNnVX+bM3AvoUINzD2f?=
 =?us-ascii?Q?wj/udPPbCoeEHD6ZJ/aVRTWV7Kl1xxKmrBZHaEwOs37Sj7Ld8QF1tMYVEco5?=
 =?us-ascii?Q?afooS+r0P4D+4aleSdV9c2foig2ZrOh9BEs2UJnvr5iBgo41T6SWpzU7eL1w?=
 =?us-ascii?Q?0wBVlVXWnLTknHSqQ9TNd9KF+KITZb8JOYZqFQCwo4nGIin035mUaaO1ym3c?=
 =?us-ascii?Q?hmld4oDHB5v58ks0rIYT+A1r5ORZsYkynKcw8YZQAzMz8J1GIxFZHLZ8PMf6?=
 =?us-ascii?Q?WW8pAz9GYtNNequFThuTM4DEZ/TBRN0Lh7mj/KLxF5rqAbxILFbnbVT1mhMq?=
 =?us-ascii?Q?C3sd5+cR3mVjTiR0IQZZiaOONfuTre5ebY31oNpKQDS23SPaPI9TWwB8qOD2?=
 =?us-ascii?Q?c8VG67YNv+AXziXWJiDuS0fmzZciSAyB0FOdMmMMwT2f8iQ7DmF8c4KMacdz?=
 =?us-ascii?Q?BTDzAdszVCgMvDBtSibbXvPfljeFdM1AkPbODhqX5WbyQgLlJKyb2OozPtY0?=
 =?us-ascii?Q?FE+ew/i+4EFYLyvDvu+tSqXQeAZfJIXC/oZ6yalis3DRnpSgKdSsRE4DwDXE?=
 =?us-ascii?Q?OC/47n16VY8to+1Kb2SjgfnTjK2VhDYzw70bupNCIgEivT4yxS9ZTQP8l+Q+?=
 =?us-ascii?Q?jkx81twHU8S6WbAOpCbldsoIYfeSLjaA7ZLdjSR5ig+VG7EFJWj+97Z+Szu+?=
 =?us-ascii?Q?k7zOx6QaFkzifBBLIdfBvUrMomdvG22LNf73prdmyPrBojun0kQaay5uJZhg?=
 =?us-ascii?Q?ob6S22zbvWIwHczWi8ITQuVJ1cRWvdwhSWptA1zVIxYiwVuGCluVVwVR1WyE?=
 =?us-ascii?Q?s4K39qao01gRNdDQUfHoqOmj2CZCIiCRf0KJPCXI5wwaQtbjgX5nwNyuGNE1?=
 =?us-ascii?Q?+AGhsIrFxQA/DfT4eQgskGSh9sGEGv5KTN4S1vplpDfhT2+ZHxihv5Tv8O0J?=
 =?us-ascii?Q?iz0mPR40XhCjaLJosfRvVvxvCNo0cEMEOBNSv0d3nKMxa8FtzuzcVcFMTqw8?=
 =?us-ascii?Q?gnAx4jVKlehq9QVxcWjAYk5dtCMQqjjhDdMmjIpwKMbCF1ikdqDIGmjQ9kpF?=
 =?us-ascii?Q?M979iHBr3QfruoKgc88=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(7416014)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2025 05:26:36.9027
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b523fa02-d88b-4740-3a5f-08de2cac5ec6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BY1PEPF0001AE1D.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7681

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

Cc: Shameer Kolothum <skolothumtho@nvidia.com>
Cc: Alex Williamson <alex@shazbot.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Vikram Sethi <vsethi@nvidia.com>
Reviewed-by: Zhi Wang <zhiw@nvidia.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/main.c | 85 +++++++++++++++++++++--------
 1 file changed, 63 insertions(+), 22 deletions(-)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index e346392b72f6..ac9551b9e4b6 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -130,6 +130,63 @@ static void nvgrace_gpu_close_device(struct vfio_device *core_vdev)
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
+	addr = ALIGN_DOWN(vmf->address, PAGE_SIZE << order);
+	pfn = PHYS_PFN(memregion->memphys) + addr_to_pgoff(vma, addr);
+
+	if (unmappable_for_order(vma, addr, pfn, order)) {
+		ret = VM_FAULT_FALLBACK;
+		goto out;
+	}
+
+	scoped_guard(rwsem_read, &vdev->memory_lock)
+		ret = vfio_pci_vmf_insert_pfn(vdev, vmf, pfn, order);
+
+out:
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
@@ -137,10 +194,8 @@ static int nvgrace_gpu_mmap(struct vfio_device *core_vdev,
 		container_of(core_vdev, struct nvgrace_gpu_pci_core_device,
 			     core_device.vdev);
 	struct mem_region *memregion;
-	unsigned long start_pfn;
 	u64 req_len, pgoff, end;
 	unsigned int index;
-	int ret = 0;
 
 	index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
 
@@ -157,17 +212,18 @@ static int nvgrace_gpu_mmap(struct vfio_device *core_vdev,
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
@@ -184,23 +240,8 @@ static int nvgrace_gpu_mmap(struct vfio_device *core_vdev,
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


