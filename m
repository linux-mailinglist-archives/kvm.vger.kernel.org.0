Return-Path: <kvm+bounces-64383-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 853DBC805C8
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 13:08:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4EE853A9C9E
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 12:03:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87AA3304984;
	Mon, 24 Nov 2025 11:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="OMwZteUV"
X-Original-To: kvm@vger.kernel.org
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012041.outbound.protection.outlook.com [52.101.43.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3339303A07;
	Mon, 24 Nov 2025 11:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763985590; cv=fail; b=GS6cHCe+O478dFCa+jQFXN5r5f7JXYAO8L8nGOg0lmCwC3AA0/zmTYMZxPfQqznMllTvFIWe1Ld/7TpiGRgh52zx2+gBdcanttKjSWDg+I0w0da4+5jdMARovgwRlztydbuTERHBSQwxVqSblZXjW6uQGcBmY3P2gxzBgu9CBvQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763985590; c=relaxed/simple;
	bh=xP6ILGF7urCKTOZA36PMHRLHZhll0y9MnJ4hrmR5Kjk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l9562WCMLUCUwuqeWrDozzmKx6wVhOR/yWqPgzBtMgvveBUerLmhk7DHq2gbwRIRiTM8YWrxEjbQ1eppd/Fwinn8dOUITNZXxBFyycydQShgGgUW8ogE6kFMWJyvxZeIQLBSUt9ZXbidruMPmDh9DjLYa/jhs8yu9nScQ26fkJ0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=OMwZteUV; arc=fail smtp.client-ip=52.101.43.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rWds2kZI0ar29A07mNvkaO+JaioB01r8oiPlBUuCKFWev71FEFAAFcBa4rGONvtkc67PyPYnoHOOXIOMTGeJCnm4i6mMfEQ4QGIuaQHgUrHXe/ovoWJaIoAmeMqjyi0HUor/WBGoRgFVW+PVnHr9Wqnmv+wjJnK3zTsrUslAp28oyG+BhslG5HeSkcIHbKUHqFMQAEscQNp5ssFeeisZ5WWjRLSWhPvEyUcixljWUvw0LyhhZguyEiD2YhwJ+GribVN0MRKBavbcaLABaHCS5TmuTPL2vVjYCeFl/wsSRsJXYAPhN9/pX5VDZxCN2GEk7cemsqmf6HTR6oLWfWL2rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NtYfWSJ+wwbimaPsqImpTuPLi8Es28DgqYKGYT8fHuc=;
 b=oGD1xK2RQO4y9XYcpLET9EIiMrEGynz4YZzydXQkHDK06GpCJW1i/hmbjRJM6NzVLuZdJCz/hhCAfT/6WX7IShvbdRzlWEimhJL8IDfQRhejt20aJYZHmzlfKzRtShwipOMC1CgtTDBSk9Sc9emYTaoG1umv33bWx51xr1zvjcHxcdg445snowePcPRw4axpm2LCQnhMLpLwVshw56N0E2sJkRVIW43bLjmMM2hp3I8QpXW4b565NYW0EKTQRmTUmqG6xHffqMh6vc2M3N3b5hct/JgSaAxfZSVytlEPXaLc7oUFgTfDZrxv8QXE9ZBlFmB8osVYjAlXN4Srw072BA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NtYfWSJ+wwbimaPsqImpTuPLi8Es28DgqYKGYT8fHuc=;
 b=OMwZteUV+7uuNSyKawERbM3c1/0s4y+UkTU3KQcVkJkoVPJPrDtqENRrhlgp6i4nmEvcEgcKRqCiD79928KyUL4CNyE+AyfP/rOx0DJaL6reoCDL1g9Vj7nQNjOPBSjMcSgGlPGPhEcTsgKurlFgKxaR4IOuT7yZklBt4J8LtO9iuM8Qcatq3B1olhC8KFp+NDdoEHywHwDZcIyo5LaEFS0tVZBBLrImPy5w8nlEJXBB7e1208AZNnIZWOa3h3qZnd/JJsXiMvQr+UKvEUL7HC87+asTFIV2SEqOiizB/+2VM/kq4p7fzWz00kKL0M/6or/uUpC/ZRXZRltcgyYz2w==
Received: from MN2PR08CA0018.namprd08.prod.outlook.com (2603:10b6:208:239::23)
 by PH7PR12MB6935.namprd12.prod.outlook.com (2603:10b6:510:1b9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.15; Mon, 24 Nov
 2025 11:59:44 +0000
Received: from BN3PEPF0000B072.namprd04.prod.outlook.com
 (2603:10b6:208:239:cafe::e2) by MN2PR08CA0018.outlook.office365.com
 (2603:10b6:208:239::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.17 via Frontend Transport; Mon,
 24 Nov 2025 11:59:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN3PEPF0000B072.mail.protection.outlook.com (10.167.243.117) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.7 via Frontend Transport; Mon, 24 Nov 2025 11:59:44 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 24 Nov
 2025 03:59:30 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Mon, 24 Nov 2025 03:59:29 -0800
Received: from
 gb-nvl-073-compute01.l16.internal032k18.bmc032b17.internal032f11.internal032huang.bmc032l04.bmc
 (10.127.8.11) by mail.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20 via Frontend Transport; Mon, 24 Nov 2025 03:59:29 -0800
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
Subject: [PATCH v5 3/7] vfio/nvgrace-gpu: Add support for huge pfnmap
Date: Mon, 24 Nov 2025 11:59:22 +0000
Message-ID: <20251124115926.119027-4-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B072:EE_|PH7PR12MB6935:EE_
X-MS-Office365-Filtering-Correlation-Id: c537022a-6e82-405e-cd16-08de2b50f50e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|1800799024|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?B+lr+i2/Y1Z0CZfwIeXRdC3EQ13BSE6+hbK1oD1Id0NhMpIH7+kup3wm6b/s?=
 =?us-ascii?Q?3x/tAiwz27cheiOB+dCXKAeCK/9GQlZPKsNje0OGzGafoyG+1m7zl0mH9dDG?=
 =?us-ascii?Q?Re79XL7nhI8AcjECB1WEREKcvo8Apl3b3A7utJfNjhkHx37eir3U8t8Xi2Ne?=
 =?us-ascii?Q?X+1Ay2alLyAqIo1cSLsMj0H9A42B6qsjXTr2DXGLbNAHRdCDk9luesBe6+3U?=
 =?us-ascii?Q?oe+Nd0tjrl9kdBL5l9T9kQZOqYb4LhaMtveslMKzNkqCoXyHta8tzZrsvpdk?=
 =?us-ascii?Q?9+c8NJtQH4W2sWma+cb4nAtE4mZxXGWSmo1vdGUnKIc6roJAR8SOAz/WFY/P?=
 =?us-ascii?Q?0fVX5Gn88TROUq6E0W5bD3dzFoihPTxdhlw8xGo5mFx+bwi//A0aT9CRTjiv?=
 =?us-ascii?Q?Wq9vw0QQZ56rtfazpk6TvAtQL94q4IYrdiNoVbX/nDE5FuXJyALb8NblZWoR?=
 =?us-ascii?Q?Pu2qwHzhB9osAm9BRYtntjqIkafSD8Ad3wjeAl/9jzmdeUjoNKKoNkeLsMWg?=
 =?us-ascii?Q?l3KC/9+NNKXaOurZrdm0Ogjedmcqna2JMMPlAuFBqI7F2oKN+HlCq8G6f847?=
 =?us-ascii?Q?wrlMi+MdQKOEzGGaGb5WrW76iGWI1UKXRMepoXC2gLXGhAl2ZiI5kuEQVNcd?=
 =?us-ascii?Q?3TnphDnACB5ztrEhVPI9Ug30OLo0Y4BcdNd4tbkLZsMrxFQ/PSaOpjL9P5qo?=
 =?us-ascii?Q?T3v/mlAAF/9baRjw7t0SjAc8pT7x0c5cqhDgY5faeTUumGiS5+ZWrQDZgQqm?=
 =?us-ascii?Q?7gY3RFSjF/RvYpdkK5PbVU8fenEzTcCYqz4fym5UXyA+OP6qsbQv+G1Ng7RB?=
 =?us-ascii?Q?0WNj8m3Mp69liZrioepD++YmMMouV3+cTVqekL1VaQgBoUzCFYO6+M4bhCOn?=
 =?us-ascii?Q?0DjZC80i6aVwtVXDRL39pMOPD6DyHDOdrTtJAfcIMhy7kTUCcpI3DBXUg1hg?=
 =?us-ascii?Q?2cZ32uCyVYgyk3MvAcraarsNoMyvfukNhM2pwTlj0E8BpZaUgkfR2ZLMmkwj?=
 =?us-ascii?Q?KYOiUepQTcBOu+u3q7AlAB8XkiapscKfzk0QQ9G7adoBDsDpmHgYL7PaGTFm?=
 =?us-ascii?Q?nal28Pyj9g+vleel/IDD29suna8H8IgGDko4y6gIGWpvqUd0GwnbTJkwwHud?=
 =?us-ascii?Q?KbLdTqBcB6xXhOewO6wCvbufPYvA8YjlIZfAgZ9BvV/ngIoM0P4K7bcTJf0k?=
 =?us-ascii?Q?nELk+ncP1QBLghRjduOCM5geYDpHv4c4YoGPTV3WEPyeVL3UfjqdiLZajev3?=
 =?us-ascii?Q?1ggDEy2pkhjwJoYwQZrOVUxBzdf15eOuQd6UDYdxL11xu8vDP2lJJoOQWyov?=
 =?us-ascii?Q?9Y3SC26iaPSDD/9e+gUovWNI7ZiZPsMqoyWLLIGWF1FYxkmhYx915FXx8PfF?=
 =?us-ascii?Q?iE9XbUyPtTQingz13ziLWKROjj6bc5BXQi4COb9Fj9Paubv/Yn5vi2Xf+8Gm?=
 =?us-ascii?Q?ArbOwiy9fHpbocIz5PEVD4ZvECLwM0P75fJCLw/yHQdwnD5uRPxTBewUnu7p?=
 =?us-ascii?Q?rjejheSQMcUf+bBTrCFBE9WFyZssWtC42ZRlZX5RF/VlUHSWnlFuqhFejuWd?=
 =?us-ascii?Q?sL+GkZxYXOB2ZrzgOig=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(1800799024)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2025 11:59:44.0270
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c537022a-6e82-405e-cd16-08de2b50f50e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B072.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6935

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
 drivers/vfio/pci/nvgrace-gpu/main.c | 43 +++++++++++++++++++++++------
 1 file changed, 35 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index f74f3d8e1ebe..c84c01954c9e 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -130,32 +130,58 @@ static void nvgrace_gpu_close_device(struct vfio_device *core_vdev)
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
 	scoped_guard(rwsem_read, &nvdev->core_device.memory_lock)
-		ret = vmf_insert_pfn(vmf->vma, vmf->address, pfn);
+		ret = vfio_pci_vmf_insert_pfn(vmf, pfn, order);
 
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
@@ -185,10 +211,10 @@ static int nvgrace_gpu_mmap(struct vfio_device *core_vdev,
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
@@ -258,7 +284,8 @@ nvgrace_gpu_ioctl_get_region_info(struct vfio_device *core_vdev,
 
 	sparse->nr_areas = 1;
 	sparse->areas[0].offset = 0;
-	sparse->areas[0].size = memregion->memlength;
+	sparse->areas[0].size =
+		nvgrace_gpu_aligned_devmem_size(memregion->memlength);
 	sparse->header.id = VFIO_REGION_INFO_CAP_SPARSE_MMAP;
 	sparse->header.version = 1;
 
-- 
2.34.1


