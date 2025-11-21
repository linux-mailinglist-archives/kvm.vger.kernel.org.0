Return-Path: <kvm+bounces-64134-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BCF0C7A177
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 15:17:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 36603348193
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 14:12:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 010D1347BD7;
	Fri, 21 Nov 2025 14:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YXbj2CTT"
X-Original-To: kvm@vger.kernel.org
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010010.outbound.protection.outlook.com [40.93.198.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F18B332EA3;
	Fri, 21 Nov 2025 14:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763734335; cv=fail; b=rfZCs+lYtBXV00Y1+cN0OfG5II/aA/OiGIU3TkZi6xz5tPGOGw42XBgXXrmeu/wR+dafKFYQ+qi0pGBd0gojFyrxRVUVH0wpqO3D8YtDsbMAQmEbV67Jx1hgvv8EFMlM/2Cyvzigm4MNj2ZwFTP5njrGA0S3PtyzYPwadYn2uU8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763734335; c=relaxed/simple;
	bh=g6AMwCLfc5a7zci494G1NRGy9JIzS0WNKYLoOLKUp1Q=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DuSQ7/zhUQeWpD6wJ7wTyjxIOiY8gP0ui91WUUa2vVbvfX2F+lXOkwJC9ryodkrR1SxjFLlVv1+jXuxxPGOD/MPe9QaAh0PKXkK/3HIwGgFP4LBAn1VoZT33vuAHoH8fqZH2DQdE0CqpTWinxAKGt8rerUGtfstODCocYurQAa8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YXbj2CTT; arc=fail smtp.client-ip=40.93.198.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ahhkXkHwbIyerOZ1gwHbeb7DOcTK93Ow8/gX1GTZCUfG3V8JW5SJX+HMTN7oRNwUNBfLf9791KuxrQZ92itBDh9fXq/7qmDzqZGXBW/ifNYvCD01GdZ8Y8Ko4U+jtM3xz0w33QvNdMgPz+XcvS9qOhFq5BnLXjiji3sK479H71cq63K6HZxQ2rvJ2fOVF0LK0AUJOua0/1VYM6ciNEhzdHNtQgzh2JltJBSG7XZKC3HxMk4raNOzbDHHOG1k4zaXwNIcv+BQ/SPuOQfMRHpgxadIgpTwaDgaQ/zkCd5UrYds5uwvpTExcAgvk7zMfq+eFW9xr2NvB/ZfheDfQokq2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UX+yDiEszkqqKiQpnoloD7v6MJNEffQxbLbhM6vRI/U=;
 b=WVAy36Jd3LJ6cQ9+l+dYTCIVN7Gwpk6XdpZNnRLX5gH1m9fNGC9ox26sZ7D8YCjUlWrrV6XEdRBy5vSq8rcSWJYF8G7VwTPs4qufHKEyfqzQ2tCH02xdVoo+vnKmuJSWScyesiCFPKtbbu/h4JWtVJiyr+Y5MSP1v9iMN1jTRP6SI7sNl+UMLZ2K4CXL4gyJp5TygCCJ3OAZ+UVJDWNnegXmXSg3lGSsNoG8GLm7cpbMG5GsBei/TfpZfUKJcOHldhNQ7pnmfHjXgvFlf2rYc73R6HJnWnGrMe9CYJevTVmo9eoxlUwmGjZTVzKX2K4lRfY3WZ3Z06Xpa7boWygXGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UX+yDiEszkqqKiQpnoloD7v6MJNEffQxbLbhM6vRI/U=;
 b=YXbj2CTTIbdYDKaskgVyMxYdWqNhpg7jqULKI0udKKlhw3c3WIEXHHdi36JmomzDvi9P9tG4ttP1ICdnDugDN6+lKZOYlAJHtD3bB8Ak5fQ8n9QSzhaj35xGHXhL3PirJn5RFNs/8Faebwg4DjHUocYPR3BmkZauj9BpC5TD0NUH3gO+V5S+e1hr+tOycT0BdP+k+fipe+QEAZnp5XlFuyhazETJewIPwMPK+i2aiwCjc6zTc8zzBJLxHj0E9mDiKc/6n6v1V8H0FoCs1wrVvtISfT8rnxJK/jzBSvuNUwyGy55HeBD9Zg1e5182fNzWvcsEGEAn2pt5ekmEK+O0Aw==
Received: from SJ0PR13CA0009.namprd13.prod.outlook.com (2603:10b6:a03:2c0::14)
 by BL3PR12MB6620.namprd12.prod.outlook.com (2603:10b6:208:38f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.14; Fri, 21 Nov
 2025 14:12:07 +0000
Received: from SJ5PEPF000001C8.namprd05.prod.outlook.com
 (2603:10b6:a03:2c0:cafe::bb) by SJ0PR13CA0009.outlook.office365.com
 (2603:10b6:a03:2c0::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.10 via Frontend Transport; Fri,
 21 Nov 2025 14:12:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ5PEPF000001C8.mail.protection.outlook.com (10.167.242.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.9 via Frontend Transport; Fri, 21 Nov 2025 14:12:07 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 21 Nov
 2025 06:11:43 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 21 Nov
 2025 06:11:42 -0800
Received: from
 gb-nvl-073-compute01.l16.internal032k18.bmc032b17.internal032f11.internal032huang.bmc032l04.bmc
 (10.127.8.11) by mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20 via Frontend Transport; Fri, 21 Nov 2025 06:11:42 -0800
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
Subject: [PATCH v3 1/7] vfio/nvgrace-gpu: Use faults to map device memory
Date: Fri, 21 Nov 2025 14:11:35 +0000
Message-ID: <20251121141141.3175-2-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001C8:EE_|BL3PR12MB6620:EE_
X-MS-Office365-Filtering-Correlation-Id: d2a95c01-1388-4205-f362-08de2907f454
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6Z8bTYFqmOhUN81p3vPiNwTreZaIEl3MYSzL7CQJzpveQzJdayFpgfKw3DJM?=
 =?us-ascii?Q?pPqz1MDc+0xstqScPqjVCx7E+WDkuZVeL5AY29XuWQvXXruZtYZFFlNxICUP?=
 =?us-ascii?Q?WGrfdpsDTbJyVQojqeuP5omIF8QbS9NK8VXvyQ8ymHVMx2cHpoul2KtUODaL?=
 =?us-ascii?Q?4lJSQqA5PC5P2DDknIo4oWhgoAH57YVkxEvMGSHHpRPgf+2KBqHy3vybWgdZ?=
 =?us-ascii?Q?0rTHJKsJZ//1CjSLauYoX9Zo/5jqTYFvLNovmWf3i7VZN4EjeXvyZKOwfv/D?=
 =?us-ascii?Q?mx6ILVZbxfm4Ck6NUaVLMdbBG2O06e11wonON4GQFQunGfdYKEE/ot/rU9Bn?=
 =?us-ascii?Q?m+RrXphX7fptGPrb3jh4cNs3m9+t0GdCRo2Jqav6ir24kscWsBDlTbUNHeBE?=
 =?us-ascii?Q?v8lTpfzxnc2xcJkUI1OqVXNduki5WkkHilOlWuWIKHWbrKjteEKOOQc3/tMV?=
 =?us-ascii?Q?l4IRU/WuT1hmydIs7AMayn8IaUnoBXEsI24g3hCV14sdmNp7prcyDkPZCoNi?=
 =?us-ascii?Q?bKXL+MUmlYhb1Sf++PwF0P04X+6rn4u6WQIbs7sXu3TrFXAG1UjOgAu48GuD?=
 =?us-ascii?Q?myEG65XgM3rnxDRz8Gn0iG1H5ZPqbipBecvwEYAPx+Pvr2mhlKV25RGrMlMJ?=
 =?us-ascii?Q?s2+g2+9E3jTg/crbChSSdloA/YXCFWQ12pXioUgoXhFUzEbKamSx7NbzfQ5b?=
 =?us-ascii?Q?y7nZbdOhbOSUhN5q+/IlT6DbkCQJAr4UUoL/ceE6cA/VQAR6gA+CR/e7GTZ/?=
 =?us-ascii?Q?OaDKCX1PxfUbytYVdLorr8kKsclsY7pnhJXd/ssPmv8mSmsomO7lJXV6Pn9D?=
 =?us-ascii?Q?ZNUfkXM6RTTegnJGNf8Kxna2HrO//U9WO4LYPo5PFv7oHg3MBefs0z/IYE+b?=
 =?us-ascii?Q?W8dj/wD0aMCakf+hLNn8BRHrPcF80oVVoUcmIB834G3PYWSIaAuaXCiM3A86?=
 =?us-ascii?Q?7AYlJCQMwZ7Jug2H+SPd5vsxvLpXYEDMMn7prrsbfoJEA9sQ+AEWNgsgUD/J?=
 =?us-ascii?Q?cBJu2Q3J0yM0ccoHs8LT+p1Y4HOp5D2Wk5ZRXBo5pjDmzXcoHxv7UqOloxFg?=
 =?us-ascii?Q?YdaFAV16oJzwhy/oDclXcv/tI2jeKffivuQLOk0sTBN3LqjyfMMDvVujqhKZ?=
 =?us-ascii?Q?DJDOms8E3f47BHqJ1+TCv/1J9bDHo7L2oYNoSzT5Ykl8jyyOmasY3+Fk0GTk?=
 =?us-ascii?Q?JCpJox7em6YHy02eFqbX/xQ4cDkpQMxE4tlWCYzOcjmyf6ielavfeJt7Tpf6?=
 =?us-ascii?Q?fEq8IrxKFByrX0V+LQ1EJurk4SxJ8d/dV7ILjMle2rWIgF/T+I/mplpqR+QT?=
 =?us-ascii?Q?y0tctGL6Df52h710p6xYO0VMrjX0E7fPrbZH3DrcZl2jOUt6eFCXX/7Zl+To?=
 =?us-ascii?Q?q6BfIUtE+5PEXvu7cNJBQL+5+HEgnyBVcY5T4QRmqVVS4oGjxt0eehgg3QIG?=
 =?us-ascii?Q?Go2vexYZ1eMGiUrNXtg11El1wVHjPxHPFHiakkMBdg/w82vPk/MrQ65R6Uzs?=
 =?us-ascii?Q?zVwGbHomSxXOmei8qK84fPq77UYTHue0JME3UHRP3WUSnX9TtZfMaaH2UsV9?=
 =?us-ascii?Q?KCIKL5rJ7KP6mY9B+sM=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2025 14:12:07.2561
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d2a95c01-1388-4205-f362-08de2907f454
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001C8.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6620

From: Ankit Agrawal <ankita@nvidia.com>

To make use of the huge pfnmap support and to support zap/remap
sequence, fault/huge_fault ops based mapping mechanism needs to
be implemented.

Currently nvgrace-gpu module relies on remap_pfn_range to do
the mapping during VM bootup. Replace it to instead rely on fault
and use vmf_insert_pfn to setup the mapping.

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/main.c | 50 ++++++++++++++++++-----------
 1 file changed, 31 insertions(+), 19 deletions(-)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index e346392b72f6..ecfecd0916c9 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -130,6 +130,33 @@ static void nvgrace_gpu_close_device(struct vfio_device *core_vdev)
 	vfio_pci_core_close_device(core_vdev);
 }
 
+static vm_fault_t nvgrace_gpu_vfio_pci_fault(struct vm_fault *vmf)
+{
+	struct vm_area_struct *vma = vmf->vma;
+	struct nvgrace_gpu_pci_core_device *nvdev = vma->vm_private_data;
+	int index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
+	vm_fault_t ret = VM_FAULT_SIGBUS;
+	struct mem_region *memregion;
+	unsigned long pgoff, pfn;
+
+	memregion = nvgrace_gpu_memregion(index, nvdev);
+	if (!memregion)
+		return ret;
+
+	pgoff = (vmf->address - vma->vm_start) >> PAGE_SHIFT;
+	pfn = PHYS_PFN(memregion->memphys) + pgoff;
+
+	down_read(&nvdev->core_device.memory_lock);
+	ret = vmf_insert_pfn(vmf->vma, vmf->address, pfn);
+	up_read(&nvdev->core_device.memory_lock);
+
+	return ret;
+}
+
+static const struct vm_operations_struct nvgrace_gpu_vfio_pci_mmap_ops = {
+	.fault = nvgrace_gpu_vfio_pci_fault,
+};
+
 static int nvgrace_gpu_mmap(struct vfio_device *core_vdev,
 			    struct vm_area_struct *vma)
 {
@@ -137,10 +164,8 @@ static int nvgrace_gpu_mmap(struct vfio_device *core_vdev,
 		container_of(core_vdev, struct nvgrace_gpu_pci_core_device,
 			     core_device.vdev);
 	struct mem_region *memregion;
-	unsigned long start_pfn;
 	u64 req_len, pgoff, end;
 	unsigned int index;
-	int ret = 0;
 
 	index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
 
@@ -157,7 +182,6 @@ static int nvgrace_gpu_mmap(struct vfio_device *core_vdev,
 		((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
 
 	if (check_sub_overflow(vma->vm_end, vma->vm_start, &req_len) ||
-	    check_add_overflow(PHYS_PFN(memregion->memphys), pgoff, &start_pfn) ||
 	    check_add_overflow(PFN_PHYS(pgoff), req_len, &end))
 		return -EOVERFLOW;
 
@@ -168,6 +192,8 @@ static int nvgrace_gpu_mmap(struct vfio_device *core_vdev,
 	if (end > memregion->memlength)
 		return -EINVAL;
 
+	vm_flags_set(vma, VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
+
 	/*
 	 * The carved out region of the device memory needs the NORMAL_NC
 	 * property. Communicate as such to the hypervisor.
@@ -184,23 +210,9 @@ static int nvgrace_gpu_mmap(struct vfio_device *core_vdev,
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
 
-	vma->vm_pgoff = start_pfn;
+	vma->vm_ops = &nvgrace_gpu_vfio_pci_mmap_ops;
+	vma->vm_private_data = nvdev;
 
 	return 0;
 }
-- 
2.34.1


