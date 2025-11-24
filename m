Return-Path: <kvm+bounces-64379-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id CAB64C805A7
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 13:07:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 83E8B4E6BAB
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 12:02:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BF5F302142;
	Mon, 24 Nov 2025 11:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HVl6RzCF"
X-Original-To: kvm@vger.kernel.org
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011035.outbound.protection.outlook.com [52.101.52.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D0A53002C1;
	Mon, 24 Nov 2025 11:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763985584; cv=fail; b=I7cMkfvw6SwkXYEcQokEhFIRrBNSA32xnECfskC8UJNFzVP1tbFRVhH0m6mTsSH50graQECujj+mr6H/DMMjvgNUCvDVHG5jJ5WMHOiEg0VyaEF45W1FsaADkXB904dgJ0HuAVafwOf0vosoNZF33k78Nb05ct6t8jrzFK94n5k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763985584; c=relaxed/simple;
	bh=D8BFgiLYDvSGI/GkdCLLePGy3RIWkAJphrGhVBpRJ8w=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sEAyaB9sbRNvmPU+iWL/8W2lJlOp15KGDoQmQ+WJShne7Jcxq/qE6dIIE+0kjoOZRgJkPr8huTiO1hspl4kjWFu7ZMVAeLJtggWnO5aXCbC/+RJEBNkZTszPQhz4/nsRhbWUWFRbOp5aafaBwU0AQzTh+rktAINWwoxJFpDLKUM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HVl6RzCF; arc=fail smtp.client-ip=52.101.52.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G4+/kOH7JGt+BhuRqzpMN8tm6jTTUSYeTRF0gQ7bskv3mmlb7RbKbpdNkfl34JaHQMgzJiZBtbRWeauvgO6ho9XJD9dNBpN+zXX7ZUhYA6DQaX9krp9dDwxMTY2XZXvhwpg18wI/DGNetiGExf7GsBGAjeXtApLEYK7LW5n4RjuQKPJOo/VPzimKkleoeSOeJBYrHHNe+e7/IxLuAY8rQuQkvDV8ne3kXZtKh33ct4Q81Z8nIX4X8mTgmjyjjrTfsOZvfFJG3hzqZFaerkS4EC6kwuMP8n4fszNB0Na30PoI7bBnTEDGyBgRH4YGonlbZyT0HOWc/da4c4xYO3c0xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JM9dGDDE5UoYXoyJs4RNmZe3Vew5IfPR1TQllmAxxkw=;
 b=IGwro0MyrowthgLo1zniq5L9w1+12W28py4DUwWVeumGeVA7bd3HOBLerI8Ut4gTDbHFI32OUxOdz5BMXkO1D6D1Nf4Xazjs7g9NEjobRQzK39ce12tzmhMjhUBeYwovRbMMn9n2yASu7sYcj84bKisqnAkB9iWnyZSEz7eK4Qs5kXumExkV7NTuqBGOqEbntyz3AUItmHzNRbARgbXmQNyUU7Wjex77YCKYRrNm3iM43VNFotvMQonPJA/eFGnD3Wgj9eiOFLPqwEXkfH1q3IU67cJNI7dB10XrKDAtbuX1BZCTl2emB077AHw7PvjCYjfLvC5Z9JDaPnmE/rhTiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JM9dGDDE5UoYXoyJs4RNmZe3Vew5IfPR1TQllmAxxkw=;
 b=HVl6RzCFca1rAY3N8i8UkADQzOiSDEaVLn/39k5K82e1qPD8GToyhI/jhhUz7Y9GE8qCGahB8CkRB6ou9cEkiJVwVwKNxK725QmXdtQooddGH3GaEyVN8x6HNVtvTpp9PHNVimZ3ISMc3oh2ZyxR9tDn9o3G94UWUuSVlDjSNX9DkpZyeopkfoHfYEMhUEky7U6sApGO2EtuRXNsUNLQ+B6/ViTQy4BaKi8Q1xE5DIgqNw40Zjr/F0ftGJ37SMn90vKNjo6SiBJXWBoGgb8hM8/C/vq0bbkxghtIPSMce3SeF89cBfTcrnY+EjQyiXCHSoOpxwn6G4WoSg6IXC/Z+A==
Received: from SJ0PR13CA0141.namprd13.prod.outlook.com (2603:10b6:a03:2c6::26)
 by CY8PR12MB8410.namprd12.prod.outlook.com (2603:10b6:930:6d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Mon, 24 Nov
 2025 11:59:38 +0000
Received: from SJ5PEPF000001CF.namprd05.prod.outlook.com
 (2603:10b6:a03:2c6:cafe::82) by SJ0PR13CA0141.outlook.office365.com
 (2603:10b6:a03:2c6::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9366.10 via Frontend Transport; Mon,
 24 Nov 2025 11:59:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SJ5PEPF000001CF.mail.protection.outlook.com (10.167.242.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.7 via Frontend Transport; Mon, 24 Nov 2025 11:59:38 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 24 Nov
 2025 03:59:29 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Mon, 24 Nov 2025 03:59:27 -0800
Received: from
 gb-nvl-073-compute01.l16.internal032k18.bmc032b17.internal032f11.internal032huang.bmc032l04.bmc
 (10.127.8.11) by mail.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20 via Frontend Transport; Mon, 24 Nov 2025 03:59:27 -0800
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
Subject: [PATCH v5 2/7] vfio: export function to map the VMA
Date: Mon, 24 Nov 2025 11:59:21 +0000
Message-ID: <20251124115926.119027-3-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251124115926.119027-1-ankita@nvidia.com>
References: <20251124115926.119027-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CF:EE_|CY8PR12MB8410:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b6d657c-40fe-4d87-8241-08de2b50f189
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0dpCgU9CFYGcn9oRitMOTa9ruFvmu4UPbdG3njzSSM2hV07xKJdKBjjAQQ2Z?=
 =?us-ascii?Q?LznbxU6Umr03UNx2U20uSLYm20h67v5jiz58ciVGQ8NpznRqRVpl5ZeipyQX?=
 =?us-ascii?Q?eDcVDwO2CjFpAGazrIQqAaTbKWHYOA7ES4uqGF+tLgHpMYi0+F7gkDMXzMjJ?=
 =?us-ascii?Q?cNmx9BZ7dcUxSwS1clExVrDnuPKWhBrtkpSIQQi0qSI+AT5UL82VYBioobGk?=
 =?us-ascii?Q?5x8j/56TDQhGFBEL4vWeyIS6/lTcQ8GpEZkcu6zmVNHT567nufvGpfqdULVW?=
 =?us-ascii?Q?Q59Oucvv2H2iBxenPhULW5Nh1iduXz6tiTcrUJZKCPFX8kWvZLcudBoE/VXT?=
 =?us-ascii?Q?1O52BgfmKYlZ2FRE5qdcFnbYpls/MbpiDDPc/yvsg+wmSNsril5xxdBHCm6V?=
 =?us-ascii?Q?z9KLmd0ECFqgyHrU8RTsRioZqOVsqUAhTG0OMPyINQaxUW96EP9Zrk9mjRO/?=
 =?us-ascii?Q?hJ35d0Xuiu/RGnMgE4xvPG4gY1m6JSnANiomuQ9NjphCjClZlwE1KhSf0u8C?=
 =?us-ascii?Q?XhcIugrQ53g2oRfCraE3UQmLUN7B3T8gu51OV5q2IX4lTrjZu6/Vo5SHUHJk?=
 =?us-ascii?Q?wnkSuDav70uuNi8XSpCR6I0tsafNjkMgf9aWO6PqSWPhRYpFEj3D3me3BOr0?=
 =?us-ascii?Q?F+4RqinQj8lqSxCpBKySgZek+aotX5NFEYPKafoZ4VV2rXS83WszekZRNnJE?=
 =?us-ascii?Q?j/h32CfHAvceN0Xw/0e0euhXsUH/CdBC+zY+6RTho1NOg5rIk22Km//pQG1B?=
 =?us-ascii?Q?g6nSWGtgcjgh5rp0yhEw9y5Q4JJXyq0GT2e+60DOaImq6kFX61H3lsmdkYMA?=
 =?us-ascii?Q?Kg+UH1PJRQ/LegvWcu4o/gnB4uma407PxtD2lMtG+YI7QjDdQuHW9DH8b28m?=
 =?us-ascii?Q?61gD9v4QbEWluKs6uyk+mkqrohGcmutY2fp7kouvGJDiOwGZw3ANIfCwRtrq?=
 =?us-ascii?Q?pl3dpPF2g66on1Qu0zAC3Js1fpGxeJTwoxyCvshHsEBnnhwIwBuN5FWl9hl6?=
 =?us-ascii?Q?Wju0LPrM4cjIgV0tR3R6+GQGo1SIjbFTo+xdWR4IHsMlNB2eOrhN1YrSX6Yh?=
 =?us-ascii?Q?Pg5hzZSMkAucaocDyCPOzFcJeWKyW+gX2ikvwnYbMZRnqqd7kM1qjmq9BNyW?=
 =?us-ascii?Q?N87Ia/8NqTbDVvfHDqU8epllTJDD3Ewdg4ZYTRnqdy7i8+nA5SY9wg4mvNej?=
 =?us-ascii?Q?BpXmRurwJxgNYS8r81DRATQWSADZSe4SeStPKF6aidpDR1CsJg0Hoc8DKM8X?=
 =?us-ascii?Q?JwEutO6BOZMXAFHQrTNRc9LIPdd/+bvlRtkeBp8g0YuXDJWLA72fNU9lSvJo?=
 =?us-ascii?Q?T2Xa9e8eWJ3kuZtHxbdrXZyOhhaukSQ79uX6FXRQSARBeJXPIpWQ+7OKbgkm?=
 =?us-ascii?Q?yF2Vo0hbHVl08N0wsHObbnsICiahkKI3WHiXw6JUzERS4YGluavukg5I0KyR?=
 =?us-ascii?Q?pu0VXB7UXio4/iYr6RdmuY0suUGfZO0IKFNv96AtMaPB7m4yCprUcS02B2Vi?=
 =?us-ascii?Q?yIxRpqFiqpOst69nXWz9ZFY73AicQEA18VwuxRDXaJnfiHvlCjlZGVmFiN0E?=
 =?us-ascii?Q?gQ8lqqTGz8AwTl1d6zM=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2025 11:59:38.2729
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b6d657c-40fe-4d87-8241-08de2b50f189
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8410

From: Ankit Agrawal <ankita@nvidia.com>

Take out the implementation to map the VMA to the PTE/PMD/PUD
as a separate function.

Export the function to be used by nvgrace-gpu module.

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 46 ++++++++++++++++++++------------
 include/linux/vfio_pci_core.h    |  2 ++
 2 files changed, 31 insertions(+), 17 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 7dcf5439dedc..ede410e0ae1c 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1640,6 +1640,34 @@ static unsigned long vma_to_pfn(struct vm_area_struct *vma)
 	return (pci_resource_start(vdev->pdev, index) >> PAGE_SHIFT) + pgoff;
 }
 
+vm_fault_t vfio_pci_vmf_insert_pfn(struct vm_fault *vmf,
+				   unsigned long pfn,
+				   unsigned int order)
+{
+	vm_fault_t ret;
+
+	switch (order) {
+	case 0:
+		ret = vmf_insert_pfn(vmf->vma, vmf->address, pfn);
+		break;
+#ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
+	case PMD_ORDER:
+		ret = vmf_insert_pfn_pmd(vmf, pfn, false);
+		break;
+#endif
+#ifdef CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
+	case PUD_ORDER:
+		ret = vmf_insert_pfn_pud(vmf, pfn, false);
+		break;
+#endif
+	default:
+		ret = VM_FAULT_FALLBACK;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(vfio_pci_vmf_insert_pfn);
+
 static vm_fault_t vfio_pci_mmap_huge_fault(struct vm_fault *vmf,
 					   unsigned int order)
 {
@@ -1662,23 +1690,7 @@ static vm_fault_t vfio_pci_mmap_huge_fault(struct vm_fault *vmf,
 	if (vdev->pm_runtime_engaged || !__vfio_pci_memory_enabled(vdev))
 		goto out_unlock;
 
-	switch (order) {
-	case 0:
-		ret = vmf_insert_pfn(vma, vmf->address, pfn);
-		break;
-#ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
-	case PMD_ORDER:
-		ret = vmf_insert_pfn_pmd(vmf, pfn, false);
-		break;
-#endif
-#ifdef CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
-	case PUD_ORDER:
-		ret = vmf_insert_pfn_pud(vmf, pfn, false);
-		break;
-#endif
-	default:
-		ret = VM_FAULT_FALLBACK;
-	}
+	ret = vfio_pci_vmf_insert_pfn(vmf, pfn, order);
 
 out_unlock:
 	up_read(&vdev->memory_lock);
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index f541044e42a2..970b3775505e 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -119,6 +119,8 @@ ssize_t vfio_pci_core_read(struct vfio_device *core_vdev, char __user *buf,
 		size_t count, loff_t *ppos);
 ssize_t vfio_pci_core_write(struct vfio_device *core_vdev, const char __user *buf,
 		size_t count, loff_t *ppos);
+vm_fault_t vfio_pci_vmf_insert_pfn(struct vm_fault *vmf, unsigned long pfn,
+				   unsigned int order);
 int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma);
 void vfio_pci_core_request(struct vfio_device *core_vdev, unsigned int count);
 int vfio_pci_core_match(struct vfio_device *core_vdev, char *buf);
-- 
2.34.1


