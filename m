Return-Path: <kvm+bounces-64525-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id C997EC86360
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 18:31:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B112A4E04F3
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 17:31:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 813BD32B9B5;
	Tue, 25 Nov 2025 17:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nO2V9g5H"
X-Original-To: kvm@vger.kernel.org
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010038.outbound.protection.outlook.com [52.101.61.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53A4132AAC5;
	Tue, 25 Nov 2025 17:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764091846; cv=fail; b=M7MzQsD32F6BVEP8rO3cKw4t68Iefz5bJIO/OsA3TOqeUT2Oui5BHOgaATRh9NIypEQWmVoSBcddbmEKA+LzmdYh23HXfRsg/I+GcUS5PyvIeFutIQJKbzUKCcGq/tX9ykGF2dvnqLpLRZIKEypKcobXWL/LuDh3oK1aYz0dsI0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764091846; c=relaxed/simple;
	bh=AL0vu4yhrn8muOzSQ2G9PsZVNruFuHhM0WkGGHO296k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wa7O+1XAwG7Bettw35onQWj5fyOuQWLtKGh2wSkrYd6pgC2RyORG43uX9Hxqnb5y0GQ2JHmoi2/0/Apa2ONTh/3r9HDZCZJNSIH7WTVTrqGhfCzsHaolt40fal8LpPUVbs8scxU6Li8WngNATUVy8SqoMHOGjT3RSMXd7sZdeAs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nO2V9g5H; arc=fail smtp.client-ip=52.101.61.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gniuVcaxn0jU2G+1dgBKtmsYlJWiiWoG6b5QaNDex0d5PI/e7YIFUQJ4oJjwaub4veMHn8v29Q6a4AqqHxi50hG+SXfSrx5TAJafxpepoHLABq2shvYux/P2pQ6zzpImGZ3Ti0Be+ElLt1dSn2yUENf+0/WUT5s97CW6ufI2Ayh3Yhxrdx4nN5kvP7EfGhBNtAfRpajgA+HjtsTW2f/XgCZJpXPL9/iZuNdFyrDeoCSkVgoPwBUEdXJKQyZsoX80o0/OXRLmmljFD87AhVH1obbjmkl7PJXMY1105xP/8l3kfwFrCiGXO+3IwUU1/nfPD3jBOkoLcRpdoma8lNyyKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YLcPAydBFLf19oRUuqdfZPbnw8Pm5HeasNbLnCoS0+s=;
 b=xL+Oqdl2M7gvCM0EszS0BED66KZgdxwvG77FkdakP9ILyoGQuAG4bvuTtV60lF8WzuVVoMDtI9cjWWJdny8CDEbCXOq/EkGAB3koc7yMb07rBwXkWT1zRjzUPt8GLnPfbcNsNvp/ITDbs9+8OKENUglUf1kPtyU/fOi+4Mamh9wc1phxbuGRT3Uw1jSGkKdEpZ8q26chASPza8p2XgnMTNIsSbH3LxtvzqiIot1M4mMu3+DglbN6PN+p2RrZvJD7r/oJ0Tvv0tmZh/HCvcjTeGv+2jyJBGaQO/ORqGRzxmex8OEkQZOKxF/YJRNjfZ41QM70Lj/D+WSXcVBUM4PCCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YLcPAydBFLf19oRUuqdfZPbnw8Pm5HeasNbLnCoS0+s=;
 b=nO2V9g5HwirK36cDnIQsHAfqZ6MlCxlgoBjTW3i1qXgiLUBdMQKafSlGQbzY6FJ4w2wB6lDd0hD7Kgtng3fbjeozpw1pCQu6fJNLCE5pwLJ0/1vatuiGoeW/HfaNngiQJg6mXNF2QNx7goScF8vwGVOfxGImCRUDuEiCZ7/4vdvcAIGjhNgE3If/ZLVtFz4IYaWiM7fH3uHkMmvSW0sTmNNf60e85l8AlYc+So97WD1yjRjCwaULdDMpwCvwWzD8a7dNNwk//reVbXUgvdrlv/8qIuMf5Pubc/F/x+/Gjm0N9NeXfTV5DE4VbiIfzuhJ7usLrJh1BPPLu/lsSuzuaA==
Received: from BN9PR03CA0948.namprd03.prod.outlook.com (2603:10b6:408:108::23)
 by DS0PR12MB9422.namprd12.prod.outlook.com (2603:10b6:8:1bb::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.12; Tue, 25 Nov
 2025 17:30:39 +0000
Received: from BN3PEPF0000B074.namprd04.prod.outlook.com
 (2603:10b6:408:108:cafe::41) by BN9PR03CA0948.outlook.office365.com
 (2603:10b6:408:108::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9320.15 via Frontend Transport; Tue,
 25 Nov 2025 17:30:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN3PEPF0000B074.mail.protection.outlook.com (10.167.243.119) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.7 via Frontend Transport; Tue, 25 Nov 2025 17:30:38 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
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
Subject: [PATCH v6 1/6] vfio: export function to map the VMA
Date: Tue, 25 Nov 2025 17:30:08 +0000
Message-ID: <20251125173013.39511-2-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B074:EE_|DS0PR12MB9422:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d43bd22-7b82-4466-d18f-08de2c4859c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?r0mzEdwsgpBYi8OeDhkaGHciN94tR5XNUeGmahRvfb07nd8QfXIksjciw18q?=
 =?us-ascii?Q?+zAxGQ0rCoQTo9xMSyVTE9J6nlMZB1HIqSTHBG0sL+mG77iQIcww6bY9XAdV?=
 =?us-ascii?Q?cnu4vpH3gcqdTTMyRWVGz4wcmbfziy9BnOeiO2CkdzP5b957Rjf7inKZ6Bx1?=
 =?us-ascii?Q?B3b3udIaYuDiWG5a0a2WiWSAwA3I7o32NJu1VamLqc66Sk0PpYppuHBUwEOy?=
 =?us-ascii?Q?6t0lUoJj9ULkoFmb/PwV5d0Nq2JL/tjhphv8WcDPPTIgKPwjdVrf0DKL355n?=
 =?us-ascii?Q?VZ8JX0RKcwmgAmm5k1cnP11qOykf005FLWItNHnmujcikTMxsBux35HQ0n2J?=
 =?us-ascii?Q?CHGJnrpr3nuBFEji8DFwXjo0DBm7HDMEOJs9ROarSHSdezKKQMTE3zx7aW2C?=
 =?us-ascii?Q?IX/Zeho7WB4GPMYlFahd9uwgTofnKGaElFB9lH9Bu18e0i9tyRRQUDJgz20P?=
 =?us-ascii?Q?ivejfNiGLIMygVQESh/k75mkmwWw8a1f3j/e4XrPCfaXi8X8aw//j3L46AAv?=
 =?us-ascii?Q?LSjrauVzSSmuTFS1C4C2bL44Hq003WRF2dRMvKEns9bY5XuHrjiMUmXAJDkc?=
 =?us-ascii?Q?fvlljdZ2DZzEbNelx2SWk/rsOYl1DHS2HsvlPcpy//iyQwp+qT3AIccRF5ck?=
 =?us-ascii?Q?SDBVysT4jHSiKp8PdZKPbeBu3emOpifGPHKdh1kKXlwc/Yajz8z53DKRj1Wf?=
 =?us-ascii?Q?3xnQGapq5967G+j3v/WNHdiglGFGA9k/ndGMO5M4fTu2k0btwiw1XoYZwcHn?=
 =?us-ascii?Q?OJK96Nc2NC03rLjLgCFbYatsL9vtJXmeW8rUUAK9YfZ6k9Ru1n0mrUjx08FZ?=
 =?us-ascii?Q?lFIxsgJiXVt18MPLOnDDRqMbS7Z4Qq5O5O5CDOJi2URlZRTHzgt8SpDPcbAK?=
 =?us-ascii?Q?sNBxpJ5XQTI5oypFNFYlTrLztgX5N8WFghsRk1pL0OYtQxfPqSdsrYlhGNPn?=
 =?us-ascii?Q?E80La2N6VJwcr5w3ty+Bu1n354mcT7d9lGhc1E42xw4pRcCn7lfa97hJaZQV?=
 =?us-ascii?Q?RtP0ET9ReDac5UkPxIdmwH6S9Cad1cU3MrpBFAIdQMrLxrs8H1nl1/RCIciI?=
 =?us-ascii?Q?HkxnNmswvb12CtBpU+bs7MBLPgOwBmWyxwW0BvjM7Ui4OFdcMkPJFg4P9SL1?=
 =?us-ascii?Q?DHYxrd23UOi1+Z1KPX0A24x5n8OJM9t0Ewg4fzEsvGVx/rfZ0gcXTEHLTBpr?=
 =?us-ascii?Q?fbCydQNRGPcRBirtjnEcjJOQmiXu+xjvOVjrIvq0Dyuj2Jgmf/gYZsEIsYrO?=
 =?us-ascii?Q?6XK/q7A3LPCBPVWwy46FKNRc9ejlL4CoIHSe7A4KdFLzacFY0PneTK68eF4j?=
 =?us-ascii?Q?HP5ej9lasfgRQ4/cMVoMDh4Ql3kJ6yKgGza/x5LXxY2ipBolU1GDUr+a1WZV?=
 =?us-ascii?Q?wzGVn8BcQf3JWLDHgBuBy+vDv8Y7J2FYw/31d1amNLdKV22mCNykwnV5S5GR?=
 =?us-ascii?Q?cc7jE9hvruuv4jo9AM8nTBqXUmbb/aqGpPvV4+wjSBK+R+mehRPkwHpKtTKW?=
 =?us-ascii?Q?0LxcZo3/TEIbHS2Ngviz4r7wqHg5ExBmFyndL1olRxRsMcYdVKd1U68tG43j?=
 =?us-ascii?Q?XH5T0TozjwyowNsH/0Q=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2025 17:30:38.6727
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d43bd22-7b82-4466-d18f-08de2c4859c2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B074.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9422

From: Ankit Agrawal <ankita@nvidia.com>

Take out the implementation to map the VMA to the PTE/PMD/PUD
as a separate function.

Export the function to be used by nvgrace-gpu module.

cc: Shameer Kolothum <skolothumtho@nvidia.com>
cc: Alex Williamson <alex@shazbot.org>
cc: Jason Gunthorpe <jgg@ziepe.ca>
Reviewed-by: Shameer Kolothum <skolothumtho@nvidia.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 50 ++++++++++++++++++++------------
 include/linux/vfio_pci_core.h    |  3 ++
 2 files changed, 34 insertions(+), 19 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 7dcf5439dedc..c445a53ee12e 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1640,31 +1640,21 @@ static unsigned long vma_to_pfn(struct vm_area_struct *vma)
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
+	vm_fault_t ret;
 
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
+		ret = vmf_insert_pfn(vmf->vma, vmf->address, pfn);
 		break;
 #ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
 	case PMD_ORDER:
@@ -1680,7 +1670,29 @@ static vm_fault_t vfio_pci_mmap_huge_fault(struct vm_fault *vmf,
 		ret = VM_FAULT_FALLBACK;
 	}
 
-out_unlock:
+	return ret;
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
+	vm_fault_t ret = VM_FAULT_SIGBUS;
+
+	if (order && (addr < vma->vm_start ||
+		      addr + (PAGE_SIZE << order) > vma->vm_end ||
+		      pfn & ((1 << order) - 1))) {
+		ret = VM_FAULT_FALLBACK;
+		goto out;
+	}
+
+	down_read(&vdev->memory_lock);
+	ret = vfio_pci_vmf_insert_pfn(vdev, vmf, pfn, order);
 	up_read(&vdev->memory_lock);
 out:
 	dev_dbg_ratelimited(&vdev->pdev->dev,
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index f541044e42a2..6f7c6c0d4278 100644
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
-- 
2.34.1


