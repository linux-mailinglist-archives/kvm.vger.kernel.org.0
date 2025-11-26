Return-Path: <kvm+bounces-64720-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 282FFC8B93B
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 20:30:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CB1EA3A9774
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 19:30:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82BFB342526;
	Wed, 26 Nov 2025 19:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="j0WZvdb1"
X-Original-To: kvm@vger.kernel.org
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010067.outbound.protection.outlook.com [52.101.61.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D819F341666;
	Wed, 26 Nov 2025 19:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764185355; cv=fail; b=eGapTX3+YEE66Cz5Tg+7gLwgqLbIpPfTSKEt5QNWjpbHJtVDFTEzabVFgSyWmeYthYNlxDXaavRMf/rrfCBVacqAmxA96xPccozzhikFNzBNos/GRXNzFAHXjTglsAawKtJWfT/fcS2dFXduPLvQ502yy3ElTzbCf55aZzH2Oe4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764185355; c=relaxed/simple;
	bh=f12lu7twiuNN3Fezu5gWZERPt5ETMUH1++wMYlwLh6w=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u6pISXKrEUZF9cquKkjoJ/WF3xb4n2jeN3Hu53eR4O/NAUIEDzE+5LvhCHLIbNZPoFn+/KDHcNHY4aUJmZ5DEUW8vM9xTRq4+OB92Y/F54oy42uqiZGGckM7mdMxZW1mfAmR9pY30adEPw8rbLDDfi0HMLkgaZa+qlehIJgKOeY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=j0WZvdb1; arc=fail smtp.client-ip=52.101.61.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YsLBbyfqCiF7UAnAlP4BTGc6d5B1JC/HirYlcjFYngXcgul3TWFv1yqaZUqRT/4f2C694Soi6daePITgiC0vuFkHi8m1vo50mHJuD4TmmMIgUkNzerkvAxc3fIgDhs4IJD7zNtBuJj3bNCtF4OV6okxjz5aYU9u2cPR3qXm840srM2KZHBTpQAq2LTiG21YAlmNAje4uiYeTO9eAHRwGUfMOh3jp6t/vZb+ES1vqVYI1yoceq7huAt4eHszUXGwNEwx297wyoeGsGIvWX/dwgrElNWYuvIfpPB2IRyif9vqjr84Tz3yA/YkZdtrES3Tp1+GRsxgF/WHEdiRQB03p4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5xRXpfwLFBHzgFIEYqVGqcU0z3cHh7tKTU8tqAh/LAE=;
 b=T+Rerjc90+1Qvn46tqm9ybJ4yI5kZMSJnXK5kCClSn78l33KgidG4ScMObzAseSHjw1KY4vESx6b9ZPtg6E/WcrLix89U9T7/N75l1zEVzmOsimSsg6EVsZmhSK1iaJrhB0rJQ+AbObdmP+TXFkdxQe+CX+v8loIoSboqJH7sDJUjI4/++pCcC9qBUaPXV+pdFVjTAg0av2ifMTDYiFS2tcaFBxJt7nvQJ7lzq0RYTjHMp5NUMBFyTcC9ni+9LBBeXf9nLx10XwjEXrw7k8ndeM+IchhZfmGHWSvntt/X0pTbn2LfsihMc4Q15VF6qBzB8xWj04Y/ApwP6SLPo1Vqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5xRXpfwLFBHzgFIEYqVGqcU0z3cHh7tKTU8tqAh/LAE=;
 b=j0WZvdb1f1mG9tgThfxSaH6FqUYlUtUsxwADvyqZ/zcAH29t+jZEUvPUYl5hhnhjAr7c6mBkSLf14BFu5IT+z6WzMIRB8LdDSU6gRPzJyF3zvm7UcesOgYObAZPx90z/DRUATcNi4Sk1fkgnW7NfgHdgutC5ekFDeF+ZZh05X0ADOwBfs36pokwO8fKqYw+0IrtXbrKaHTS8FshUldKi7Pew9KBQjKDuDodMX2it0Nyg6MgQbguu8IizAEaN/mMoaHTSqbtcVdVAh/BYYS1fU+d1ZpXFmiohFYdithMrNHD/b1geGa/Wc/Qo4QykfCdiCjMmBCalhteXfmv/46C1vg==
Received: from BN9PR03CA0487.namprd03.prod.outlook.com (2603:10b6:408:130::12)
 by CH3PR12MB8970.namprd12.prod.outlook.com (2603:10b6:610:176::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.11; Wed, 26 Nov
 2025 19:29:05 +0000
Received: from BN1PEPF00004687.namprd05.prod.outlook.com
 (2603:10b6:408:130:cafe::2f) by BN9PR03CA0487.outlook.office365.com
 (2603:10b6:408:130::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.17 via Frontend Transport; Wed,
 26 Nov 2025 19:29:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN1PEPF00004687.mail.protection.outlook.com (10.167.243.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.7 via Frontend Transport; Wed, 26 Nov 2025 19:29:04 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 26 Nov
 2025 11:28:48 -0800
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
Subject: [PATCH v8 2/6] vfio/nvgrace-gpu: Add support for huge pfnmap
Date: Wed, 26 Nov 2025 19:28:42 +0000
Message-ID: <20251126192846.43253-3-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00004687:EE_|CH3PR12MB8970:EE_
X-MS-Office365-Filtering-Correlation-Id: 2905bf96-9a7c-45b6-17f2-08de2d220fc7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|82310400026|376014|1800799024|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CtuvNvASU2u5r1XR6kaniiudortcZ64oLl8OhfTGQiP0lwp3gZ8zDVa9lf8S?=
 =?us-ascii?Q?a2TyaW3wHQn5D7Kn9vPzZQoKemwEX8+Em+pXx0gUpMMbpLF8BgPcusUHL7gu?=
 =?us-ascii?Q?FZMk4RLKx61GXKWLKwyMULEHy1lC/hTumlwyuKBnf7F/ZPmRvJjKEnuhSE6B?=
 =?us-ascii?Q?HWqR4K8l78iBp4XfkoiJ3oD0egOIvAnbDB40JHao/VFvhlxjpiCTVCzdy0UG?=
 =?us-ascii?Q?GIRJxkiqvkHxLCL0v9r8kWhMV7SfGu2ObzHOIRDowc5MjjZ2KQOY/Zb5MXC/?=
 =?us-ascii?Q?fjiuQ5pQot2OkuJT4XOJ4jtYNYbiSQRgZGjUglDaAf1EIkWuRfBRvGPgMTmE?=
 =?us-ascii?Q?D5GT88y/h4wjP36VxX9aaQWNLvwRE1xktopLyhV23fWDfZP3o4Zb8ixkz3nL?=
 =?us-ascii?Q?jFcdqfYyMmUzTW3QKu5gMd/p5dtgJYyti/3VYcbS9B6a6X1jWndpPx49Fp55?=
 =?us-ascii?Q?S1HwsLCeT6nelfhsbvigOmNfnxiRp7ju//s415HnaKJnhcUFwtw/nNSwp2nw?=
 =?us-ascii?Q?SOcParuBhGb1bDPJDmhBwF3XoXBcucA9UmLIaPtM3rUrp9AbK0dhhufWzFw4?=
 =?us-ascii?Q?/i2RsEzEDjD5rlKlJMy0YRmoFFn4a8rtLKEInLXOaI8F2nhIzEq+3qc8T9nD?=
 =?us-ascii?Q?zEEByqV28u7IfgUDcjeidbg9uwFOgFINTHDf+cV0HCYYxyZqvByZOdBey8ul?=
 =?us-ascii?Q?1PP21VmIE9/4OztagNOWFO5IXAs6cmk78w8DEPXfO511WW7mq6A+WMLFoJ42?=
 =?us-ascii?Q?TJJaTffs7FKJlH45QvNtnJxdqfvErfvxdh71oULsEkKi848nfM/2OnbRIvUM?=
 =?us-ascii?Q?aU/FODzTiwLQmOabhkeJBHhq3MyGWj2waOCIBWLInbwzAJ0GejDDOukaK6FN?=
 =?us-ascii?Q?9rV26Qb1lfrhJXTJea62bMcq4+mhG8n1eTSrU6Z0xvWiXp6k4JgplytHBj0Z?=
 =?us-ascii?Q?6QOgyuSbsYZTRhzSoYAivtGJi3HZRYfFed82FM6oQ6JV0BYy+fQ2k6ov1rPY?=
 =?us-ascii?Q?7ROUN+Dbu6iylLCy4eLM2Wd4KU/lP6Ni1xMeNrhDMHkOY2t2BfUkhtVUb3y3?=
 =?us-ascii?Q?Lo1m2IXO7nvVLJ7YndgH2Dmv4osd7O/8LcRSrY855ohd3PlS76V+SUtWm5Fg?=
 =?us-ascii?Q?4CzOuA7ZfChzuwfeSTYmxgvyqu3VAmmin/FQW//+FJBT52gEGa8q/gcSG/HZ?=
 =?us-ascii?Q?sAmNhuzuDiWxDgWI6xmlRjBaf2v9leJ/1jXi0OogXVPO2t4Wt1B3AIGcddf7?=
 =?us-ascii?Q?0Avg6Qjks41LRQqn+T4PRutmqU3FLiBbfUcqUhxHbC1+i9OE9R6U1OqomFkw?=
 =?us-ascii?Q?yV/92cz+23Qivos5kjAudDdRZlKgPaij9dVx1pxmquuRdgeVFXPIEE4pKH8A?=
 =?us-ascii?Q?QySGZ1AoNkwS7mWYOfhmXhea+FgiOdhxUPTeWzzpx8Qv4XJos/izEhl+uhI4?=
 =?us-ascii?Q?CXG3SKy3icYna8tnIp9Csy6fOfl2jR0CN4aLY2QldUAELyoZkgJEsOwSzMDU?=
 =?us-ascii?Q?sDwZtQsgP/JdMNfWi3aQjgB4AT5MyY3kDyCRo6k8+vCKw81Pm4ICGiIMZKw+?=
 =?us-ascii?Q?zVeRg+jMu24cbtuusuw=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(82310400026)(376014)(1800799024)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2025 19:29:04.8359
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2905bf96-9a7c-45b6-17f2-08de2d220fc7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004687.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8970

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
Reviewed-by: Shameer Kolothum <skolothumtho@nvidia.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/main.c | 81 +++++++++++++++++++++--------
 1 file changed, 59 insertions(+), 22 deletions(-)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index e346392b72f6..232dc2df58c7 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -130,6 +130,59 @@ static void nvgrace_gpu_close_device(struct vfio_device *core_vdev)
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
+	vm_fault_t ret = VM_FAULT_FALLBACK;
+	struct mem_region *memregion;
+	unsigned long pfn, addr;
+
+	memregion = nvgrace_gpu_memregion(index, nvdev);
+	if (!memregion)
+		return VM_FAULT_SIGBUS;
+
+	addr = ALIGN_DOWN(vmf->address, PAGE_SIZE << order);
+	pfn = PHYS_PFN(memregion->memphys) + addr_to_pgoff(vma, addr);
+
+	if (is_aligned_for_order(vma, addr, pfn, order)) {
+		scoped_guard(rwsem_read, &vdev->memory_lock)
+			ret = vfio_pci_vmf_insert_pfn(vdev, vmf, pfn, order);
+	}
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
@@ -137,10 +190,8 @@ static int nvgrace_gpu_mmap(struct vfio_device *core_vdev,
 		container_of(core_vdev, struct nvgrace_gpu_pci_core_device,
 			     core_device.vdev);
 	struct mem_region *memregion;
-	unsigned long start_pfn;
 	u64 req_len, pgoff, end;
 	unsigned int index;
-	int ret = 0;
 
 	index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
 
@@ -157,17 +208,18 @@ static int nvgrace_gpu_mmap(struct vfio_device *core_vdev,
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
@@ -184,23 +236,8 @@ static int nvgrace_gpu_mmap(struct vfio_device *core_vdev,
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


