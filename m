Return-Path: <kvm+bounces-63374-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id D6A2DC6434C
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 13:55:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 94C234EDE2E
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 12:49:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DA313375B9;
	Mon, 17 Nov 2025 12:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Sle6qN+X"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012064.outbound.protection.outlook.com [40.93.195.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A2D3375A0;
	Mon, 17 Nov 2025 12:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763383342; cv=fail; b=QU+wjVAUz+6t1KrwuJb9O4q70Y2b7IUaNclnCmIMIaEdtlSqaECuDgNZjuuzPIx9TCQYLkJVhn4hx/2YATtnsCxhGcmonG4nFBDntlRZoo7otWQeRIn41r2wDpje6HX5an1lp4q7b/+yOKv03F6s3RctnkwmoOxYRKJ5BEf77xI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763383342; c=relaxed/simple;
	bh=s4HOoPpw+F+uz/UUWetkyfr/GLjgmA2Hy6U7sCP17qM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m0vXqEI1DD37yc7/1q1pdfk6OPyg0nnGtXHiGuIAp7g+ueFsirNJdkA5TYwbBEWBo5/hioPLJrw2gWFZX0r9ita+FhFTTJwMX93atxruKht8wwtLxQ004bbQmmUyhygmTIW+cw0kFuYcus+XY6GhRvKJZLLCqmZlfEZ+fNymkUE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Sle6qN+X; arc=fail smtp.client-ip=40.93.195.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iIu7mryTfngQNatfZIyK9HVYOtOJbIoCtcr4Pyx3LSuoW497Xhuqx3i7T2dr772roxlmn7uEmHr84evlUvxo2LUiPUA8l0E0vTgU8CIBPY2ynCgEcyeP4k0E8n8zxcZUwQeHK0ojmuPFBreBqCdk1bluLyyq5btXKkquhCDuoOlqnNiZb6esnDNubWs55vdHyQ6EiADOUiOCc7ZHnPcFzwr5+G2GyWlEKWExW40hm1IFKwJfZTK6N+kZIf5/5JI63sOkj+sJUVczonePPHA8sFEMbmxzozi/+svFwUSK6RYmfLdR2q52at0Jv2UYL9/L/qXv6YkNmzyh2B3DJ5BUNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r+jXZfFaj/mBZfU6QapQukJMNEemAubukfYwvP8TYRI=;
 b=inLbAo/TTZJ+iJY2dkje/75+ZGFdGg1zKfMMuVWWpqQhQrNKTlJVCQG8075SX5SfT6bBfxK3NHrTpJ6vGLOdic5Krlj5ZFAeo4+jxZLmHq9BwbcUybpj6FLCDPsHvLXfVlWOXXYB6QmbiIQgGhgKeRL7SlMPgir0sU4JKheptLbOqPPP3CJ68IGEBBAgKeldK0joAwkorkZtr1m0CgEhOPCl3H30CvNLrKKaejELVlXUuViKye/MHKZnpn+o3wCPvpjL6KEA0u9HWfZG5WUJQxqW+7hmo37vPICBkqWGuMnKOXeel9QrUF/lKipNpOF0I/Q3gngDdjF12wYilqOJHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r+jXZfFaj/mBZfU6QapQukJMNEemAubukfYwvP8TYRI=;
 b=Sle6qN+XVkA3UxvGYWKFQYg/F1ySTgpDKVywG9k4FgdNwl0YlX1UUurHt+YNvPguMQDhoMyUm1Vz+xcZHywA+BYQ+MLQcHYr9AKkWFythNPwvcf1u4SkCkHhyauiQ7+HTG87p7gvn8V+dWIhpyYz+JbQbLCXCl7ZzqmpqgkJi0b0mM1AGLS6DbQEKtfP87TqGUyPwUuhd6Iqq3A2yn4QButBYArpnjuemop+xZmdhRrlCi9K7nKJvgLkne/ybKJ3FVvr3JJTP06Qi0y/Jz2fodtKn7rnTVaAnatR6PrxesTXVJlIEjUnLwlEMJu2kv3Y+3xHKoDAA/7mW2AKwaMfVQ==
Received: from SN6PR08CA0009.namprd08.prod.outlook.com (2603:10b6:805:66::22)
 by IA0PR12MB8645.namprd12.prod.outlook.com (2603:10b6:208:48f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.18; Mon, 17 Nov
 2025 12:42:15 +0000
Received: from SN1PEPF0002636C.namprd02.prod.outlook.com
 (2603:10b6:805:66:cafe::8b) by SN6PR08CA0009.outlook.office365.com
 (2603:10b6:805:66::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9320.20 via Frontend Transport; Mon,
 17 Nov 2025 12:42:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SN1PEPF0002636C.mail.protection.outlook.com (10.167.241.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.9 via Frontend Transport; Mon, 17 Nov 2025 12:42:15 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 17 Nov
 2025 04:42:03 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 17 Nov
 2025 04:42:02 -0800
Received: from
 gb-nvl-073-compute01.l16.internal032k18.bmc032b17.internal032f11.internal032huang.bmc032l04.bmc
 (10.127.8.11) by mail.nvidia.com (10.129.68.7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20 via Frontend Transport; Mon, 17 Nov 2025 04:42:02 -0800
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
Subject: [PATCH v1 2/6] vfio: export function to map the VMA
Date: Mon, 17 Nov 2025 12:41:55 +0000
Message-ID: <20251117124159.3560-3-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002636C:EE_|IA0PR12MB8645:EE_
X-MS-Office365-Filtering-Correlation-Id: c617dd2e-b96e-4aa9-f951-08de25d6bcad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BYHRvTuCw3cuqCQiORb8u54LdAXoNrvruewxm2vzBbTCuAx5WDT/kNHHWoeG?=
 =?us-ascii?Q?ALguFCBhN6huIwAzlcRds4OH99b65XlvLTICGXuKnaQU5fXq7fzmoPDxI690?=
 =?us-ascii?Q?uH1iMQCvSLYgWr3UoI4exzPSSNuvOO9D+2a5sDZGZBNdJAZuz9SagOhupYe5?=
 =?us-ascii?Q?q1rAbaD07cHpzbburrG6bfvNKL6jAXx+IMBgmaxfZAa0ccZhRW6RyQWaAgD6?=
 =?us-ascii?Q?/kUz5chbUX//Tt3yIHaluWrN3NnTfuIe2LGhQnXoCuslvVEOYtiCvDhPrDt3?=
 =?us-ascii?Q?/ckvbGSNSxsR9iNQaLzoFi09kt131JnShlxd292qy7re/Xb0KiO8NcNklzlx?=
 =?us-ascii?Q?Qox3PX1nCouUSw2NjaMd14/8GU6dU2hxqDXlxJ/BqANRqsk640cGawXvhtWq?=
 =?us-ascii?Q?wJRi/yW4qpVk7qhIyQtzIf0+cs8NP588+5Q21wLOT/2oSDVLgArEh7DC9M8r?=
 =?us-ascii?Q?NEee6b7zi7oUOLtxuCueycTFACZGyb0oly1ubeHv/8m2u51+ITsj0XwlSRcH?=
 =?us-ascii?Q?Ub0QJY7QqiTshcpX/15R7UJsOZIN0KNtfOEKZ+ESQrdtqOhadtkUlJxEW7q2?=
 =?us-ascii?Q?oz8jxSIVuAiR4wClgil6uVYynTgEFmchQS8NdSzHgNssW/u+OfnZ70dBzN2q?=
 =?us-ascii?Q?KsYbuYSjuJev24KAeYOKLojc8ZMIdjQlFdiAG8Pg2Y3g/iBRLjNKvrzOh2/G?=
 =?us-ascii?Q?LDXb3RpH9obixrBO1LUa63+LP9ePeGSUSIeev9Q9E1OCjV3OoQp84LPxQtl7?=
 =?us-ascii?Q?e+TKkqnfhw7DzCHhjFwexQBrh83JES0vW12dGNxe0we5XLTK8Zde8LAtvJTI?=
 =?us-ascii?Q?VZ9hmk5PAG5iuyC/vVxu65bZouSVWpPrQz9zsA5TL+vWhRWd3++JGZNV0tPg?=
 =?us-ascii?Q?yRN+L6BZhiNFbvnXbyJRDTtNdS8p9fRf3dWxvW9CIiWjeXREiBF5zNXQDINP?=
 =?us-ascii?Q?LO4TmpCEc6Vp3bi0R//AOnX9ayPh9aBsCwRndx3V9Q82Ca4RDkGRR8dsuoRN?=
 =?us-ascii?Q?LMV9PPiMZPnOrl/Qjybhw5L65FQYMBh06E4Tu+NHixFQ2Hm0KqG4h1gR6VPG?=
 =?us-ascii?Q?NMwFavZU37uG3k18avNB+R7SLwEunrmzQ3nTeQZjN+AMfPlx3xtZtUkXV6qz?=
 =?us-ascii?Q?ufxQTJDuXiRYl0ovFly1pVRLiqWdqPkMHXjIWUFLQu4F6Si8s82wrSZDaS4d?=
 =?us-ascii?Q?7pyQueZgaHHyMp2f1mbFIPUU8Z4CXKI4Dcq4FCbrtSvIFRPEVnVrYNGrK4oy?=
 =?us-ascii?Q?PcMc5rhW15i03Sh8a0XFwHZZNG8RjOBFWzCgFdHMG9MAmdPdvxEs5Smv6VGE?=
 =?us-ascii?Q?RNcInmwIqj/RYC+E4scunJat2p8QJFHHkdKoXblqVYZEGzgcRvdRPuft9LpP?=
 =?us-ascii?Q?DXW2jlbPxwbATgiDKcOT797mPPKo18kSB63XWch5cwl2A5/RTCcCoDHd1ysz?=
 =?us-ascii?Q?1VaN3kA7zf5dERyJHUILnhIFCIZdzW3lv++Lj1o0ZtT1yMJwdrMbm06L/eoF?=
 =?us-ascii?Q?1A12vv8cDykvuLAYDwAS0a2QyM0dTohxksjABraRXbJZWv/E+I+WT11lI+bz?=
 =?us-ascii?Q?troVTVdHKTtPGYLlRmU=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2025 12:42:15.0615
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c617dd2e-b96e-4aa9-f951-08de25d6bcad
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002636C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8645

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
index 7dcf5439dedc..29dcf78905a6 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1640,6 +1640,34 @@ static unsigned long vma_to_pfn(struct vm_area_struct *vma)
 	return (pci_resource_start(vdev->pdev, index) >> PAGE_SHIFT) + pgoff;
 }
 
+vm_fault_t vfio_pci_map_pfn(struct vm_fault *vmf,
+			    unsigned long pfn,
+			    unsigned int order)
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
+EXPORT_SYMBOL_GPL(vfio_pci_map_pfn);
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
+	ret = vfio_pci_map_pfn(vmf, pfn, order);
 
 out_unlock:
 	up_read(&vdev->memory_lock);
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index f541044e42a2..058acded858b 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -119,6 +119,8 @@ ssize_t vfio_pci_core_read(struct vfio_device *core_vdev, char __user *buf,
 		size_t count, loff_t *ppos);
 ssize_t vfio_pci_core_write(struct vfio_device *core_vdev, const char __user *buf,
 		size_t count, loff_t *ppos);
+vm_fault_t vfio_pci_map_pfn(struct vm_fault *vmf, unsigned long pfn,
+			    unsigned int order);
 int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma);
 void vfio_pci_core_request(struct vfio_device *core_vdev, unsigned int count);
 int vfio_pci_core_match(struct vfio_device *core_vdev, char *buf);
-- 
2.34.1


