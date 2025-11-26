Return-Path: <kvm+bounces-64601-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 16CD5C8825B
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 06:28:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E583F3B4F35
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 05:27:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCA4B3126D4;
	Wed, 26 Nov 2025 05:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="AfIMYZn3"
X-Original-To: kvm@vger.kernel.org
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011069.outbound.protection.outlook.com [52.101.62.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24DB43161B1;
	Wed, 26 Nov 2025 05:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764134806; cv=fail; b=oUPejaci+oIPOjsVxCPMxLYoGNErGqTuT0kafDhJZ4HB/HJ8T4XvlHG/Io8ZlJ/NkgdBSzdl4MZZwegQijcNDUvCWse5VHkFEAyxJWzYTx0pPDsqbun87mncjUwdARAeno9DgPSvgan1lgY8nkUbvoNLA32TAIRNZVg2+lisaqE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764134806; c=relaxed/simple;
	bh=naK+mAZNqrjFh07r3pfFsyHTQCpunW9SVZup8XZcA+s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nuATMlGPgoJq8IIRlHFVT2n7dLzmZt/jryPq6aGB3xmThR8DADighrgrtbKS7lBkdLIp07PJaoumssxOo20OpG+F1wEhM6x0ZM//LNA2t0xBa7uDYof6HbKUHjTr7faliuKo4HpzHgcMPfIwLGzlfv85NcljmWAT0ITLaQ47R5o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=AfIMYZn3; arc=fail smtp.client-ip=52.101.62.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CXXt6yOkIPVN179XPjX30bQ6EI+NG1oLT+lnbF+MJ+F4bAAnBlidNwXHcyWYaqkJK6jmnoVReW9U8NekdbzZ+IWf0tybKt8AvYJ+daIz2av6fHWWBT2CqAo5649kGJJSwGPzpGNRbegloiHmB3UDXjo/3K8vcf9UbzgXMOvGhbJmBP0+nBIcquH6QyWZ4PzlXzSL2+LJZHCjzJvFIepsXpgZLP93zi9z1WlbYgucxkRNxMJBzual9tJCojgwI3MrkwBwuYXnDyFTBoccEQDNg5NzG4PAMrBJo3tF6x7m//LhyJmREaZTTCfB6xU/E79e10KxwVTJka/uSs+RAcEHGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DYvrkn0VwuYoY2qnbva1bS4yAfLuFEOUKMTJu3RrXP4=;
 b=fOgjYz65JGO2bSL1weAjovY4oiNvEOftWtxeQDFZ4R39hwd38+avyVYtGhGhbz/NldwIB/fKIU/53wbmB49Rlyi/nx5cLNtYxl7rX98kuAteATGmRtHlJNJsVpfP8mr94tU1BgXn170KlPp90uLSHGNKsXsB+2UEjMJDbqKW2pnWvqo2w5FeM4cQbIgMGeQlEHTHNSGSNum8jo5OA0dlpALFLkqzs/rr0NHGFFEKratICury95Y1P75c/yw7YwPqFUieM5waoRdaPYC9TEJJREaNiGNVHQjMMxRjdNMnsVvaezTqZty3yfoMhRXwiK7AOkvB4+8p9EqDRbS66GXVpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DYvrkn0VwuYoY2qnbva1bS4yAfLuFEOUKMTJu3RrXP4=;
 b=AfIMYZn3Fc1K4UqrqTN+e/IYJ/u2wTWR9nCwc6SlPwWFwGgEuhQl2bMCuxyq9Kni8v1fpL8LqIRVrwr4Fdq+5cELBPXntcyoXQPPO3Ask+eA+azH6VCLy19RgSK/Xi3/FJ6V+6Y1NCKMkLVqBzk0jckg8fYXwIB1nXWX07zW6O/XhVhI0pc2m317zu1cbYG2BhQ5gtUPZX8t0StPqm4ipIq7jMB5/6jKkgWjKZU966dTNETZ8h52Wot8T8tlv1NNbjjfmhnAomZr8vdPnzJEcUBYK/I1oyMW4HkA04sv+VYBwuwvpynjbqA8X9FOFXbfYXJX/ZiGYULs+XMSQnPKAQ==
Received: from SN6PR08CA0009.namprd08.prod.outlook.com (2603:10b6:805:66::22)
 by MN2PR12MB4375.namprd12.prod.outlook.com (2603:10b6:208:24f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.12; Wed, 26 Nov
 2025 05:26:41 +0000
Received: from SA2PEPF000015C9.namprd03.prod.outlook.com
 (2603:10b6:805:66:cafe::5d) by SN6PR08CA0009.outlook.office365.com
 (2603:10b6:805:66::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.16 via Frontend Transport; Wed,
 26 Nov 2025 05:26:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SA2PEPF000015C9.mail.protection.outlook.com (10.167.241.199) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.7 via Frontend Transport; Wed, 26 Nov 2025 05:26:41 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
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
Subject: [PATCH v7 1/6] vfio: refactor vfio_pci_mmap_huge_fault function
Date: Wed, 26 Nov 2025 05:26:22 +0000
Message-ID: <20251126052627.43335-2-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF000015C9:EE_|MN2PR12MB4375:EE_
X-MS-Office365-Filtering-Correlation-Id: 27e99ea5-04d4-44bd-edd4-08de2cac6175
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DqwS6ydvCkTIQ01UzVKFH0zot0CvJCjPKMQYrUNiipcOdCQ9RyNBqIoaG8N3?=
 =?us-ascii?Q?nqnIDzjifEDLZDnkATu3T2yKZKm0eSo5aHfCWMWsNaeIxDuoFbx+y2Lf6xoe?=
 =?us-ascii?Q?NEmej2QcRxBUdm83NxWWEEvRgExrgm05CACN/Z0HXfVUpxClFz0y1DmGCjXi?=
 =?us-ascii?Q?VxChMj7cFn8BIxvi4dI4E+GN9m7mUdBQCMPl+tNYTjMMSoqLiYIu5BE72B/V?=
 =?us-ascii?Q?oIlelktletCQFaToHrxSXzXdLHT2O+jKEMfPoUvhv64+T91cuV97x95AZlO6?=
 =?us-ascii?Q?LAy6NdzRPg35tn5bwUxReqK4zsMYGpsZVkerUh2hOkhWH9tJHEPZNx2NH0Qj?=
 =?us-ascii?Q?/4QHZQe9eN6+21Q5bkDTLlTwFa7eZcnquhDG5Zpa/ErtE0Vawrs0wMVI/YPZ?=
 =?us-ascii?Q?Zpk+FIqUxODv6EhPDheWRxsOz9aS99SQlsROqLWnvgmZZY6gngOvAIkVbwCU?=
 =?us-ascii?Q?OqrvinYK9JCZGMggzwaFJZVdVODxlHdbOkRW1j2wR/NL/5tb+N8lzmlyaOCe?=
 =?us-ascii?Q?FvhOh4LCUAAaft2FjMQCSLcX5t+OpOokgi0305HqkkG7AXptuAq9MHuIA848?=
 =?us-ascii?Q?wjno6eHcecWHIVlVTW+oBXv0LZw9DK9m/TyIa50rO1HpU4SeaIa6zWLKKmlz?=
 =?us-ascii?Q?sOHDZt9SGYL69mUVnb4QArlpl4jJmQFpdQUh/Pr4ePVZLq3i9Oni0ORV79Vq?=
 =?us-ascii?Q?FEjYjhrgv7MKYDoPUAWN4w0UPBzK8awILnxT9sA1bT7ig81sOLqDD2jSVdF5?=
 =?us-ascii?Q?ZNWuG6Mejn8sxSZs7O+FXuTJVdvZR3PMbURNxzgE8mFEzB1FMjlkANL06dcs?=
 =?us-ascii?Q?g9IwI5lKZxZwmSPfJ+dPepCdGsTei9M3gUyZ/BqX2BToPHx6Xu+tpBl3/MHw?=
 =?us-ascii?Q?C32fZI5o555Gmx6HiHIrDJjmJuE1G37k/GVAB+FWdhdWEBzvUUKo1MmvJ5Oe?=
 =?us-ascii?Q?MRfBLvSpjAHEL9v+8VCUEVNg++utIFtl/MOjcEhsP7TfrbE/AdTAL1xcEdUn?=
 =?us-ascii?Q?x+bN3m3yi9Um5WCRAzucphkozDuWrgPoVd9jBBsCmfYdnGKEaus4Mi4fPh/j?=
 =?us-ascii?Q?fWQ0bM4xBOONu4Z/tAhOgGV2sjpivl9Elmsx9tVXTY4SoaSzXZU+eLyhnpkZ?=
 =?us-ascii?Q?si9fUqEXMahtxRVdD3Xk/2TelebWuS+s80Sex4fhFyGwwSKFYR/bOinyB05E?=
 =?us-ascii?Q?fbbHNLfUb+FTWvLSmJGHtYYeKObnbPL0JaxAPKQsf/Su0wpG5Twe7TiEcXkm?=
 =?us-ascii?Q?lQifdumsn1pXPw2bnCLF+KSTfkFsnyjMv693R7PZMZQNZiCZlO/+4fnsG9Bs?=
 =?us-ascii?Q?kWKV3XdwC66pc/2z4Bo1ntzXirlz2s2gzIxce5eh4xs6iuC5dR+LAaeXLk21?=
 =?us-ascii?Q?6SofhN7ilI1ecPUKubEclrD1icsbuAWO9bOvxBlVo787N6CwUvVzzo99od3i?=
 =?us-ascii?Q?eywePhssua2NnqF8vAwvbIRO1IVUPQB4cxr103YYCbFwOp5n9MWJwEFB2Un7?=
 =?us-ascii?Q?6EGY+xEH9Dmm99eFcH3nce8aOcrOp4WB7D3CXVem+40k+YeOadusid29aSkg?=
 =?us-ascii?Q?p7X7rnexSGa+ioHFgMU=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2025 05:26:41.3036
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 27e99ea5-04d4-44bd-edd4-08de2cac6175
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF000015C9.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4375

From: Ankit Agrawal <ankita@nvidia.com>

Refactor vfio_pci_mmap_huge_fault to take out the implementation
to map the VMA to the PTE/PMD/PUD as a separate function.

Export the new function to be used by nvgrace-gpu module.

No functional change is intended.

Cc: Shameer Kolothum <skolothumtho@nvidia.com>
Cc: Alex Williamson <alex@shazbot.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Reviewed-by: Shameer Kolothum <skolothumtho@nvidia.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 54 +++++++++++++++++---------------
 include/linux/vfio_pci_core.h    | 16 ++++++++++
 2 files changed, 45 insertions(+), 25 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 7dcf5439dedc..52e3a10d776b 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1640,48 +1640,52 @@ static unsigned long vma_to_pfn(struct vm_area_struct *vma)
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
+	vm_fault_t ret;
+
+	if (unmappable_for_order(vma, addr, pfn, order)) {
 		ret = VM_FAULT_FALLBACK;
+		goto out;
 	}
 
-out_unlock:
-	up_read(&vdev->memory_lock);
+	scoped_guard(rwsem_read, &vdev->memory_lock)
+		ret = vfio_pci_vmf_insert_pfn(vdev, vmf, pfn, order);
+
 out:
 	dev_dbg_ratelimited(&vdev->pdev->dev,
 			   "%s(,order = %d) BAR %ld page offset 0x%lx: 0x%x\n",
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index f541044e42a2..1d457216ce4d 100644
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
@@ -161,4 +164,17 @@ VFIO_IOREAD_DECLARATION(32)
 VFIO_IOREAD_DECLARATION(64)
 #endif
 
+static inline bool unmappable_for_order(struct vm_area_struct *vma,
+					unsigned long addr,
+					unsigned long pfn,
+					unsigned int order)
+{
+	if (order && (addr < vma->vm_start ||
+		      addr + (PAGE_SIZE << order) > vma->vm_end ||
+		      !IS_ALIGNED(pfn, 1 << order)))
+		return true;
+
+	return false;
+}
+
 #endif /* VFIO_PCI_CORE_H */
-- 
2.34.1


