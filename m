Return-Path: <kvm+bounces-64899-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E8CA8C8F97D
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 18:07:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id E01DA34D667
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 17:07:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 610522E54D3;
	Thu, 27 Nov 2025 17:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="R3fgYdyX"
X-Original-To: kvm@vger.kernel.org
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011057.outbound.protection.outlook.com [40.107.208.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA3E2DF151;
	Thu, 27 Nov 2025 17:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764263217; cv=fail; b=KUs2cU1v2I2nZYDCnDR+ogeuUxO4h5vyzuiMforVLfZoYEhOBOumK7MYiy4w9zOpKaa7lzXdFcs05SYHKLqggJPhQf7fqYsUbe14ULNhGEVT4C1h6yCvvfSvkrCx7H9Jbti0QTX6b3kkafmChvfZTiupNsewIJtKEN6vfzw+1ak=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764263217; c=relaxed/simple;
	bh=nn0n+n/hnS9VpGsJ3RErEx4B0+f0G9fOjiNtPDIl9do=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kmpT/a2WQpFL6N7r6cIKKHhDXBGDYtf77kxq8usyXYzxgXsT887l+R+0MmVs0VVu2Sy2ea+6Zijby9tjLpEoE6HheVL84hEpbHHd2goXGgbJAwaG8Da6JEEXtFgcT8wH6DrnzrEsnH6QZbm0hRMS1B7OF/o6Yl1v4YB/2bh0ZSI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=R3fgYdyX; arc=fail smtp.client-ip=40.107.208.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ONPMGZ29fNv10M8GHjHDhigJgKegUF6MTow9IfhzzdoMhm/LVjZXjH5QJpjhROroh3oGm+iKwHy1sbQNUMCrWdDeZggGs9LlxKa1CH5Ti/isXeUV2ulSZN//xVehvoMHUVt1GsW/ybAZY7aJKlSxWb+sY1DEzn/5b7xsYQDq7T5ndL5XFQxdikHEHKsixzGRbYgvs4m8L0JckJOvy0qJkcZu8thaXeH/+2ei4OzbJdNXHDNnAUbBuihL5v4Bbd/eFSnkXgn4nR/bcZw3EzgLuKS8Cf4KM3R0KVom1qTkhx4wWsv6uaH4kGIoujr93dWHPGT3k55hFyM3IGNfMHnwCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K1Sr137aLYYLLYLH/I78lfSMqcDUFxgV2CyDrBb/RRk=;
 b=wZi2C3L/IJPqiHHVnAnveSNGp9yQZlxOcLFy4l0HOkX0qeQi8CYhxUU6A7FLTauymMlJlvxfZIkxpBIDdH74r1pG3alY9l0CIfcd3VeatwFEGZ0vIaOXfZ3D1leer6ElrIFSBh8l3h0+necnjHMDUKtn1TwMU7B0T1oCgRietjGEBpOvYx0T4mF3RpaLnhXuZr2qrHrmblI3QVDfRwApE0eU5s3YnNI/ex8jHeNb1FLu6faGu/9fu1kGf7KkqEmg/g+MHmc4dOfyBN3v4z4Cazze3Vv07KpHlwBriOp3F1ODHwliiNMMAF+Tn6tDTm6skW9OH9C0g1WjHMd+EiWDGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K1Sr137aLYYLLYLH/I78lfSMqcDUFxgV2CyDrBb/RRk=;
 b=R3fgYdyX/bCgQagiQbGn7PG8UcVK9fZ26wDq3WPKoqYhOVLmSRgSZQA2D5KK47Ph/HEkEkH0WjehRIVaV/ntxhQW7oV/uloXvO5OKHw1HNRB9vE3nuAGIk63UJhlKU2Bzi6ELCvC6491Q77e7NLi/ulC0DR8NVrda2W5U9mpI4pRRrJD3I3EYQvZQ5DaMo/OjuDaXW1g4ssDbIp/7YbRPEgQn7DLDAc8HTpmAkNejZrKqqVuMmAJ2agCstGJLOr8fZnMOqD3Xjr8a2px+6T7SBH0+xSAiy4asTEUzKFIYXW74TEjsM1XKwi4DWjGE29ZBJItgxrBidk0iIwUt30VYQ==
Received: from CH5P223CA0002.NAMP223.PROD.OUTLOOK.COM (2603:10b6:610:1f3::10)
 by MN2PR12MB4440.namprd12.prod.outlook.com (2603:10b6:208:26e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.14; Thu, 27 Nov
 2025 17:06:51 +0000
Received: from DS3PEPF000099D4.namprd04.prod.outlook.com
 (2603:10b6:610:1f3:cafe::75) by CH5P223CA0002.outlook.office365.com
 (2603:10b6:610:1f3::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9366.15 via Frontend Transport; Thu,
 27 Nov 2025 17:06:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS3PEPF000099D4.mail.protection.outlook.com (10.167.17.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.7 via Frontend Transport; Thu, 27 Nov 2025 17:06:51 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 27 Nov
 2025 09:06:34 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 27 Nov
 2025 09:06:33 -0800
Received: from
 gb-nvl-073-compute01.l16.internal032k18.bmc032b17.internal032f11.internal032huang.bmc032l04.bmc
 (10.127.8.11) by mail.nvidia.com (10.129.68.7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20 via Frontend Transport; Thu, 27 Nov 2025 09:06:33 -0800
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
Subject: [PATCH v9 1/6] vfio: refactor vfio_pci_mmap_huge_fault function
Date: Thu, 27 Nov 2025 17:06:27 +0000
Message-ID: <20251127170632.3477-2-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251127170632.3477-1-ankita@nvidia.com>
References: <20251127170632.3477-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D4:EE_|MN2PR12MB4440:EE_
X-MS-Office365-Filtering-Correlation-Id: dcd56bc0-4042-4436-75bd-08de2dd75bd4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|7416014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cLMzFHkppRiUB28uocksoSfee6jpQKyZyu4wihIJpOxCqLvH/EyvfFvL4sED?=
 =?us-ascii?Q?143wohv6zCy93lmLY1GGJbkf/o7zGmdmnojRr2gDu0GOCriro24SN/d6yFil?=
 =?us-ascii?Q?XABb0iRYVyKxOoaChNKVRlsRPZVH+3XNQT9m8GrK90H7rdtylXlkit+WgdTk?=
 =?us-ascii?Q?HGOieFTtoEybBpvzu3wnxb4jR69lY/tovw0S4So7AeAIKRG3xPiYtV9YHDIU?=
 =?us-ascii?Q?Km2CTmAA24Kf+oY9VQsTvi1BD3BnngEhFzid1QG82n6t9pcSYIQAJ/84iUMk?=
 =?us-ascii?Q?fx6KTXE8hODAbVKS0/k3QjNSgWb8ic37GTru+dXaGvvcEogZHTkfVL/ebcD1?=
 =?us-ascii?Q?kfagVh1TikFZ0MgvNTc5YmYdUVLv8xv4eSKwGUI4x/punzjpPBolin380pBP?=
 =?us-ascii?Q?pn2oZoxE2TIWDZ8tpztESNAJ6XP1Fv7EhKdEMxTeMg31w0VG/RGT7N0oiJT0?=
 =?us-ascii?Q?aC6ukzX9mTvewJCIKhwIDVAv6j+xfNZJhZXM8uzjbtMU9tuIZsqHQWW5NUgf?=
 =?us-ascii?Q?q6Coj+zo0QfPwLv1Jdj1aFZXSDrDrunhjq0gJmBN2PMcS/Hd12KWrB2MmsxO?=
 =?us-ascii?Q?OVdyF0JanxxX9+PLAQZhPqUgppL8w59h/qHmdEaoZeiF2t8sBnZqGbCyFisL?=
 =?us-ascii?Q?A7vrlgBzAYfogsgSFtm6RM67LbVCKU6sbmSNnXvdKeTrN2ZWaJQnRAlwzTtD?=
 =?us-ascii?Q?z4i5FhWEoVlGeLz7UqyO8qCTGaRLh+pA0jF/LkvRAc+7fo09MuPp993hWsYB?=
 =?us-ascii?Q?Upwd9E0NRWAuA+MZKAL8eswBELDzFyKf7R9UAUIrukYcKein0KBcFbZT9xO8?=
 =?us-ascii?Q?g1/ASgUEiugXO8TkHgfv7LPTuxcOe+Y3eyPyZZIRPpZon74fdnAcWAPzjNR5?=
 =?us-ascii?Q?XGP29jp5Hb5HyFMZJ3JUh2wh4Im7htpcpn7DbiQxoB1ALxqnH6P7zwvuwJom?=
 =?us-ascii?Q?b7BoErZENg4MhYRtvdRWb9xg8w8gWPplR17r5cZhkFjUIBsX0ZlekfxIbTCz?=
 =?us-ascii?Q?e0h98/DKpLE6YGdnBHBv6BIq47IpDPSxM6qjdrFSdHFJ4aeCr+ZVQBNkjenP?=
 =?us-ascii?Q?a/NhNimaeZiMiz/cn9qOw5e5IZfEeQounFqw3yY5aMwyXqToKFAWggVD1IeY?=
 =?us-ascii?Q?wv1dlMBiLuf3wmOZuJLusBx01MPmXVCpjV257nWF1ZNW4wVMAr7zsooKRVTo?=
 =?us-ascii?Q?N1ayQ+hpnNMOsPBD0q4rAQNqiAd0tOeVzOEIROp//OOkvZxLZ40P7S2RGKHy?=
 =?us-ascii?Q?KVoQhqwSwPUTRlvUKyaSCXuOzP9UslXLthkDTEQELJ01d8aiKWMbOgoOxFtF?=
 =?us-ascii?Q?uun7rDz0UZVUyVSq5+OBur9DrTquoaRFTOhmVWHF6M8aDNhlXfU/LrxB+Hfd?=
 =?us-ascii?Q?Fl6veNB4e/dYRboP2u6Zyu4xlHNcPw+8CzzWlislrvo9mp/tWkUtrAo3HWvQ?=
 =?us-ascii?Q?INRc+QYrjhdg9Zgj2EtVs1fVB3we5FPvGjqQATmsQ5Je2izVHD98dVjkq5UZ?=
 =?us-ascii?Q?F/xs3CIw80z8ajpxLU9RAr7lD5eTzMdG9puN4HjU3GwXNsvEM3+4lJjnn3zL?=
 =?us-ascii?Q?OfIdyT9J4+HHAmkYuHs=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(7416014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2025 17:06:51.3918
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dcd56bc0-4042-4436-75bd-08de2dd75bd4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D4.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4440

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


