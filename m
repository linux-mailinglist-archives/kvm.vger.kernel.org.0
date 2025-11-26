Return-Path: <kvm+bounces-64718-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C6F3C8B941
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 20:30:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 93D234E7EB3
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 19:29:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10A79341069;
	Wed, 26 Nov 2025 19:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="m55e9lpO"
X-Original-To: kvm@vger.kernel.org
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010018.outbound.protection.outlook.com [52.101.201.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D34326D6E;
	Wed, 26 Nov 2025 19:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764185352; cv=fail; b=YN+SAQpqLguhtXHHUL1BzC8aYV0VnYV+Q9jLPUEEcl4ktip3CSr1Yz+6wwhq5viVZ8rvPH8DJiBTZB+KeP1nbcxPMFfhB/dbj6rUuTj3nd31C1drfsWsOtvf8ShmpZzipwemSJ6kmMvFCLyjNXpwoCCQuCSYQC1RiTMgDrgnXK8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764185352; c=relaxed/simple;
	bh=nn0n+n/hnS9VpGsJ3RErEx4B0+f0G9fOjiNtPDIl9do=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X3It8hlzUWJFzsk00uzcWQsBP3YBa21689EFjdrl5qYCmCRmtnpKsBiP+kW7HPUiAuUOGk3f87/4tsethThiZ0kK/sUyNgTa99OS9+EiwfHD7cLF61vKWcL3SA0o0AOft5SptJlTXORqdemQrgWQiDlMTs5dK5G+q6orD/CXhwM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=m55e9lpO; arc=fail smtp.client-ip=52.101.201.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yoLdr7TYbTGevhxzWiu/YhS8eXylVh0OnWOpyktYBu5BQhQ0M2U/7uI3G7my1Jd4+fzzROIvzedTLhMxq/RInnetu8fEwwRqdB5zBeo8hTdf6CSmC2Ap7xkrQPz/7/0uaDHRjGwPhZAXIZBoblD1ijaT4WodUFm1m9NpaZsSsasaskRyUP8eHxLsSqrc4GpUxWkDogn5noOngCZr7wj1c+bArCfHZQDw2x3AK0EaIrepUlo9K9e5SATCktuZ/uEvvfFxblt6XLmsstWoJKoJfdVfCsotyMBzzPlkO4kr55SvVYk0ZpXUuTtLIubdZ7fo+afspzG1y/xE4zYCE5DP9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K1Sr137aLYYLLYLH/I78lfSMqcDUFxgV2CyDrBb/RRk=;
 b=TU4Br8ka9YynTI52wMT9khLVAQIPM5j+KEu04Qx26snl8p2SDYUFAtKum/gddKXbr+q2yJYiEJUU2je044PyVFdqYWtkYvXrtX8GBBrsa1HDVUeujVZtmIf+T75d+p2hP6xJorNf5TQx4nVCZPJQGwI52stpKM/gHB0p+TYdMirk+dTipQy1qZ/fXXuN2FywzR70eHSaEz3y/Nj3RoCX6hA0kHpLzkTgc+VoMkDyAEgO31GhEUEygpWAkULBgUU5leAY2ZM9MUcm5DBaaV1FtAHUkTv0aLUEBlf5ZfFladKo5GYAK5tw31aPLlMr6XPf9QwKKjn4muB3AQAeygIQDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K1Sr137aLYYLLYLH/I78lfSMqcDUFxgV2CyDrBb/RRk=;
 b=m55e9lpOJZLWS16XEvN75EpFYrzBX1RKgPegxwxNAIlu92oDX23qxkZ+29QhPxRzxddnE2QRRLRhWmSQt8rpZzwtLPtwwAUAUI5OZR243P86E4Hwt6J9II8Jdu4iw9Q+fgpZPx50fUkNpAfN2FfZKBeykD0kI0+FoYg6wudK11asXXcttYcU4ZGvuMrKw/17ZTigKK7pi1VMyZqZcmnB7vm/UA704cUdhqAiynDMMFp0UEwk7qMPxntK7HF1mgbjVwBqM9ei8u7ZLRKVXDQMFCOCMnyzNU+S9k0OqCIBJEWbAU81JdUAAzvENmFU6FQyiyesfeHZ57eXZKA6qK2TBA==
Received: from BN9PR03CA0493.namprd03.prod.outlook.com (2603:10b6:408:130::18)
 by SJ5PPF75EAF8F39.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::999) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.11; Wed, 26 Nov
 2025 19:29:00 +0000
Received: from BN1PEPF00004687.namprd05.prod.outlook.com
 (2603:10b6:408:130:cafe::8a) by BN9PR03CA0493.outlook.office365.com
 (2603:10b6:408:130::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.17 via Frontend Transport; Wed,
 26 Nov 2025 19:29:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN1PEPF00004687.mail.protection.outlook.com (10.167.243.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.7 via Frontend Transport; Wed, 26 Nov 2025 19:29:00 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 26 Nov
 2025 11:28:47 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Wed, 26 Nov 2025 11:28:47 -0800
Received: from
 gb-nvl-073-compute01.l16.internal032k18.bmc032b17.internal032f11.internal032huang.bmc032l04.bmc
 (10.127.8.11) by mail.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20 via Frontend Transport; Wed, 26 Nov 2025 11:28:47 -0800
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
Subject: [PATCH v8 1/6] vfio: refactor vfio_pci_mmap_huge_fault function
Date: Wed, 26 Nov 2025 19:28:41 +0000
Message-ID: <20251126192846.43253-2-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251126192846.43253-1-ankita@nvidia.com>
References: <20251126192846.43253-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00004687:EE_|SJ5PPF75EAF8F39:EE_
X-MS-Office365-Filtering-Correlation-Id: 8288ecad-3a38-4610-8ad5-08de2d220cfc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?y/zvqpTcuL5L/szY4qMcpl5fFHH+Rn5cLFroU1gi0R7VS1G5DhB8RDTG+7Mx?=
 =?us-ascii?Q?7QGpPsihv1EHM4+CyvfeVSyOnTIhAkpOhnSPKYQI8gN0eKcc7+d5FMxo0v91?=
 =?us-ascii?Q?vatc8cjkNDDq27Y9duCwas+Jw19tyKuXyKJAyRfE8+JSuntb659BNb2YG3Yv?=
 =?us-ascii?Q?S9eKKM51xFM441wuVKDn5JNuG/0Uds48ulhvB3vvgtZv1OUusm5s4BMCrtr6?=
 =?us-ascii?Q?EqtXhyZHyKodX9UCms8CnVUNndSoBrA8Fafj9kbXtFF8clOnoFyqWHHzWFre?=
 =?us-ascii?Q?UcO2TD6Vkyo3MaPs265u9P5ccw8iA/ZJSVh/Zhj9siU+xt4TSg8C7SLwaR+d?=
 =?us-ascii?Q?swWvBOAqUhCaPNt8teTNfiUKre6qWwvrBPu++RnLwU8o+TM5VP9/cShAbkr+?=
 =?us-ascii?Q?Z0k+ONAqM6F/dIiikSBBDCxwwxT5wh8EhyKn92O2nUh22RXLrJTnjL6yjvPM?=
 =?us-ascii?Q?IC41cFXAxm4IQUScj3UQO5lP3bDVRaRX1M3G/Bv/rUAny1EcDQ/ysujIJS6L?=
 =?us-ascii?Q?iQA7OYIvgSwY3x/+6xNc6iMsxFsLyqhMduPXwyKAHGjw2bINIj6R+V3RZeRl?=
 =?us-ascii?Q?S+2z7nWQyQQUa1FzZ0LUWduMYEGKnrjRcEjPKbwdVFjHllC9yHHjZ2R+5Nv6?=
 =?us-ascii?Q?FlmDiQTpLwl2UIMDZO4CQKkrVmgTuCcSUXunodicY9ZxERYJmmziPQca8z+s?=
 =?us-ascii?Q?pnooYb7yzmcDnEYUB1y0oOeQoXAXI/lV+R+ktdp5m0+3kPs7suOfk+dCdky3?=
 =?us-ascii?Q?JBY/Y925N5AH1fVQd6xvhEEe2fWrbz8ehuyTbnZi2I2lds03s0z4kH7qY8vG?=
 =?us-ascii?Q?HsLycB+KRvlfUVh4Vx7jgVSuGBE/+Nm0/fk0HM0QMG/M9v17Ki4fgUW+kmei?=
 =?us-ascii?Q?bZYRvpIxmmW9OQnwImU0fiI3yq8/GiASKUyuYwCwNXr3aT4rjL1hdOKf5Z6Q?=
 =?us-ascii?Q?K/UB4/MX/lSsY3aozzFEcsUBME4jhkJiJqYsHs38PkFoF+s9uhid9urpI+bp?=
 =?us-ascii?Q?xglfxPcaFfe/72Z3VvIPNVWDLZ93dtz+QatWxEpyAXNxTFqfuPurxUaCndPl?=
 =?us-ascii?Q?w3Zb3HukB+4hO2J+1JfARLKmCKaCo5h9g85MWwYsboc3tmupYeeZRnh9yo3E?=
 =?us-ascii?Q?G0F8GeMr3+H/UtFtGxdqQeyo2w1fhPO/2nPAEIlGo568j8OE2n/PXLRZxENd?=
 =?us-ascii?Q?rVSMjjy9wNPyJ34WIXPaFnoHNQaujCFgaV1XVNWNZ096Jo7xEjFqSvO5O1Zb?=
 =?us-ascii?Q?jZHTqcgHsEaDIqjGDENBehzt9SHDaGy4CS/I1j2tFRj6FZAs3yIft0W047RD?=
 =?us-ascii?Q?wgqjQRVHUkiGbClQqWxhPBdHj9AD+DsSp1E68QTCpVEq0eZj+r+bXYFMxO+P?=
 =?us-ascii?Q?AGtNPFJ2rB69/6kYZufZ4zDrAt+clKcS0O05ribfudDrjU18VBvigH5hTwAa?=
 =?us-ascii?Q?BpnYSsE085tQky9TJbS1oQgiJl6QLSgO2tUgVse2B/JUV/REk/wrCo6NZvdS?=
 =?us-ascii?Q?gl9Q1iawYRa0d/TKGGKe9zEuJDYAtPYfZ2Fbw5+4cGCGvkw46MUYn1peLgos?=
 =?us-ascii?Q?hpVL3Lm0GA3ui+D2Vyc=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2025 19:29:00.1386
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8288ecad-3a38-4610-8ad5-08de2d220cfc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004687.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF75EAF8F39

From: Ankit Agrawal <ankita@nvidia.com>

Refactor vfio_pci_mmap_huge_fault to take out the implementation
to map the VMA to the PTE/PMD/PUD as a separate function.

Export the new function to be used by nvgrace-gpu module.

Move the alignment check code to verify that pfn and VMA VA is
aligned to the page order to the header file and make it inline.

No functional change is intended.

Cc: Shameer Kolothum <skolothumtho@nvidia.com>
Cc: Alex Williamson <alex@shazbot.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Reviewed-by: Shameer Kolothum <skolothumtho@nvidia.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 54 ++++++++++++++++----------------
 include/linux/vfio_pci_core.h    | 13 ++++++++
 2 files changed, 40 insertions(+), 27 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 7dcf5439dedc..a1b8ddea1011 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1640,49 +1640,49 @@ static unsigned long vma_to_pfn(struct vm_area_struct *vma)
 	return (pci_resource_start(vdev->pdev, index) >> PAGE_SHIFT) + pgoff;
 }
 
-static vm_fault_t vfio_pci_mmap_huge_fault(struct vm_fault *vmf,
-					   unsigned int order)
+vm_fault_t vfio_pci_vmf_insert_pfn(struct vfio_pci_core_device *vdev,
+				   struct vm_fault *vmf,
+				   unsigned long pfn,
+				   unsigned int order)
 {
-	struct vm_area_struct *vma = vmf->vma;
-	struct vfio_pci_core_device *vdev = vma->vm_private_data;
-	unsigned long addr = vmf->address & ~((PAGE_SIZE << order) - 1);
-	unsigned long pgoff = (addr - vma->vm_start) >> PAGE_SHIFT;
-	unsigned long pfn = vma_to_pfn(vma) + pgoff;
-	vm_fault_t ret = VM_FAULT_SIGBUS;
-
-	if (order && (addr < vma->vm_start ||
-		      addr + (PAGE_SIZE << order) > vma->vm_end ||
-		      pfn & ((1 << order) - 1))) {
-		ret = VM_FAULT_FALLBACK;
-		goto out;
-	}
-
-	down_read(&vdev->memory_lock);
+	lockdep_assert_held_read(&vdev->memory_lock);
 
 	if (vdev->pm_runtime_engaged || !__vfio_pci_memory_enabled(vdev))
-		goto out_unlock;
+		return VM_FAULT_SIGBUS;
 
 	switch (order) {
 	case 0:
-		ret = vmf_insert_pfn(vma, vmf->address, pfn);
-		break;
+		return vmf_insert_pfn(vmf->vma, vmf->address, pfn);
 #ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
 	case PMD_ORDER:
-		ret = vmf_insert_pfn_pmd(vmf, pfn, false);
-		break;
+		return vmf_insert_pfn_pmd(vmf, pfn, false);
 #endif
 #ifdef CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
 	case PUD_ORDER:
-		ret = vmf_insert_pfn_pud(vmf, pfn, false);
+		return vmf_insert_pfn_pud(vmf, pfn, false);
 		break;
 #endif
 	default:
-		ret = VM_FAULT_FALLBACK;
+		return VM_FAULT_FALLBACK;
+	}
+}
+EXPORT_SYMBOL_GPL(vfio_pci_vmf_insert_pfn);
+
+static vm_fault_t vfio_pci_mmap_huge_fault(struct vm_fault *vmf,
+					   unsigned int order)
+{
+	struct vm_area_struct *vma = vmf->vma;
+	struct vfio_pci_core_device *vdev = vma->vm_private_data;
+	unsigned long addr = vmf->address & ~((PAGE_SIZE << order) - 1);
+	unsigned long pgoff = (addr - vma->vm_start) >> PAGE_SHIFT;
+	unsigned long pfn = vma_to_pfn(vma) + pgoff;
+	vm_fault_t ret = VM_FAULT_FALLBACK;
+
+	if (is_aligned_for_order(vma, addr, pfn, order)) {
+		scoped_guard(rwsem_read, &vdev->memory_lock)
+			ret = vfio_pci_vmf_insert_pfn(vdev, vmf, pfn, order);
 	}
 
-out_unlock:
-	up_read(&vdev->memory_lock);
-out:
 	dev_dbg_ratelimited(&vdev->pdev->dev,
 			   "%s(,order = %d) BAR %ld page offset 0x%lx: 0x%x\n",
 			    __func__, order,
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index f541044e42a2..3117a390c4eb 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -119,6 +119,9 @@ ssize_t vfio_pci_core_read(struct vfio_device *core_vdev, char __user *buf,
 		size_t count, loff_t *ppos);
 ssize_t vfio_pci_core_write(struct vfio_device *core_vdev, const char __user *buf,
 		size_t count, loff_t *ppos);
+vm_fault_t vfio_pci_vmf_insert_pfn(struct vfio_pci_core_device *vdev,
+				   struct vm_fault *vmf, unsigned long pfn,
+				   unsigned int order);
 int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma);
 void vfio_pci_core_request(struct vfio_device *core_vdev, unsigned int count);
 int vfio_pci_core_match(struct vfio_device *core_vdev, char *buf);
@@ -161,4 +164,14 @@ VFIO_IOREAD_DECLARATION(32)
 VFIO_IOREAD_DECLARATION(64)
 #endif
 
+static inline bool is_aligned_for_order(struct vm_area_struct *vma,
+					unsigned long addr,
+					unsigned long pfn,
+					unsigned int order)
+{
+	return !(order && (addr < vma->vm_start ||
+			   addr + (PAGE_SIZE << order) > vma->vm_end ||
+			   !IS_ALIGNED(pfn, 1 << order)));
+}
+
 #endif /* VFIO_PCI_CORE_H */
-- 
2.34.1


