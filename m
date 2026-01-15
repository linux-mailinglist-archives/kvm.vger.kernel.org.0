Return-Path: <kvm+bounces-68245-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 21E6FD286B9
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 21:30:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BE27230CBA50
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 20:29:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDFCB23909F;
	Thu, 15 Jan 2026 20:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="npkulAg4"
X-Original-To: kvm@vger.kernel.org
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010017.outbound.protection.outlook.com [52.101.61.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC6831D371;
	Thu, 15 Jan 2026 20:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768508964; cv=fail; b=gxuXFlZuedvXimzmprpwt78bDCz6ghMJ0SWwwM8/VGphCm5aw4lX0hpMn0bCpHtv//QcrTHambzw30PHra8WvT7GMNDiRPp8loT4T+RrqDxTZNP+WFYVpRzITWEzwFKDi8aqXnH8rUdobkUIvEHnZtp2CZQfyJ6FrCMZshtJD40=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768508964; c=relaxed/simple;
	bh=OVrweBcd1kmI+CTYp59ryEZlLfp1wLFS2w87kVUVUnU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bY5pXprNRCP5Fh+6+A5luuA2RBVeFy9JPGAislZ1RC+yQX+jY+FOOVOPOSo6vYFBJ0Sdfo0cz1JnlO6hokebCObAw/5fBqL2GkVjqyFOUltyUeUG2HHN5oaawdm5P5d2jCBt2OtcHJVI0a6afiPL3KFRsgF39W56rFbyy2IkA0o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=npkulAg4; arc=fail smtp.client-ip=52.101.61.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tz9q2lKWuo53NIvKQp+iuYABLXCH9lG/lbDJIDOBYR+rE5iw9hUq/lgkDT/14AoXmZMx9Ww/OKTNKUreSE7Ai7RVuufhJGad+0z/ToMkuzCWnq2uMmEBXJcUwC39cvaw1kXGP5lAdkOUKYSPy4bNO8RtfPpmG5jSj7G6cPzf2Ii7zKUehlRupHkMVxIhVLNaZfKqHg0OWQ1EP4oMjZmB2BHRVV+dh6y30MH1Hx7XCt4z20Ub+0WywTMYoPK9vN3kbJSkdJBAxt69+mUI6G56MOM1wtuY7WWuKAYWwQIHLoTIJqp2KoR8dXd657we2PS+DUlDSjFXkhMEQ9F+A0Mn7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VzaBxgmdKPprH9HRxViFX3tlN0XwRsTQvMcrCas6Hk8=;
 b=fh3Ilc0MHKqRGFsEpjwzX6VTbtMkzaV1reYt6KUW3JL1qwbDLzFLiF6BYfY5xytW7cU6zs5jLqySiSwXU3zURsJ8bXYnpvcOc6r/mN3j8ByAbHrPmf1aNOcs8j6dR28gjREwN4ra8bEhyyXXrmPm6U6I2gieuZC/cvNDSv6gTy2RiJXfcA8Fje16LFHjbq2BkXSUVLhThScoSqk3IajANycIVE61wo8D0izlPld+KnbKMP0HR6CBmCVKNB/IWIlkgKbJcgoc4Y4nJNEE+LlcC9KjujNiLB9UMIvRPLdbSFuZVKRoPcUr/6BIJ81LhZeG54JtnB19+60XzpjPt0cxLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VzaBxgmdKPprH9HRxViFX3tlN0XwRsTQvMcrCas6Hk8=;
 b=npkulAg4UVaNhHDtKrZ+fWKDHYpX9+p+s/aIP3xJ9lGGVPwiG9S8jkVKmFyJZLNmAxVierUJr9NU2ELp6hI6EsZA2vdmyzaq501WAFI92plaRk3zA964V8e6+hM0DO42zQU79se1PaVZAacEp4TXiSXsgwEWfxtHQqxNZ2pU7uZx3QIspd0urzPFaGM8LsyZO2hxKu/om666XDvE5235WKpebfEMOz9LKTFx+3W818Dmk5YVbvV1vOsPyG6jtwQ2C3ux48QzV6FStpsA5wI3Uk2R5AeuDf+jT1SvrLdG2dhkC69CQup2jWsA5taxdCTKD36xN2jfSZHBD/U7jb3A6w==
Received: from MN2PR03CA0027.namprd03.prod.outlook.com (2603:10b6:208:23a::32)
 by DS7PR12MB5885.namprd12.prod.outlook.com (2603:10b6:8:78::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.4; Thu, 15 Jan
 2026 20:29:15 +0000
Received: from BL6PEPF0001AB71.namprd02.prod.outlook.com
 (2603:10b6:208:23a:cafe::63) by MN2PR03CA0027.outlook.office365.com
 (2603:10b6:208:23a::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.4 via Frontend Transport; Thu,
 15 Jan 2026 20:29:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL6PEPF0001AB71.mail.protection.outlook.com (10.167.242.164) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.4 via Frontend Transport; Thu, 15 Jan 2026 20:29:14 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 15 Jan
 2026 12:28:53 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 15 Jan
 2026 12:28:52 -0800
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Thu, 15 Jan 2026 12:28:51 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <vsethi@nvidia.com>, <jgg@nvidia.com>,
	<mochs@nvidia.com>, <jgg@ziepe.ca>, <skolothumtho@nvidia.com>,
	<alex@shazbot.org>, <linmiaohe@huawei.com>, <nao.horiguchi@gmail.com>
CC: <cjia@nvidia.com>, <zhiw@nvidia.com>, <kjaju@nvidia.com>,
	<yishaih@nvidia.com>, <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH v2 2/2] vfio/nvgrace-gpu: register device memory for poison handling
Date: Thu, 15 Jan 2026 20:28:49 +0000
Message-ID: <20260115202849.2921-3-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260115202849.2921-1-ankita@nvidia.com>
References: <20260115202849.2921-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB71:EE_|DS7PR12MB5885:EE_
X-MS-Office365-Filtering-Correlation-Id: cc5c2658-de69-417c-4865-08de5474bff6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|1800799024|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zEVXECftJrVvnQYVOJb5gy/WjyRqMcb7JurnuWRax3Sk+EoqUCnHiSXUwijS?=
 =?us-ascii?Q?O3+tjSnvmV5k6f6W0zogpmtHsUS6WpiJMLfzb4dKqzYZtAzFUio/HwWMtltN?=
 =?us-ascii?Q?uiYCj5TLZhntQVRzaJ2UMbxjTEaVCLAfuIpB6xztUiMv81bvjo4SsbCE4O6c?=
 =?us-ascii?Q?7lrmt1iKT4umANLVEoEjZWQYmROxQMgqaNgT0lc6QkQ5nTwyIiF5gGGcBSZ3?=
 =?us-ascii?Q?f8cmsbvslXPVF8UgMpnB1zjUYCBAcDYQFKVnMqCH3X1PRcs6Xa4qWd9LflVc?=
 =?us-ascii?Q?R+Dx32sLbvoWlGDpM0Kfg/+D0QZR73InpdSRrsMWmj+sMLiyBIQhtr6wd/o/?=
 =?us-ascii?Q?TkfPdVlpzE+IJ1QVmN7wPR5w9iyxbjJ+wPjjWrD5puNN57daKhl+0/6Pl75n?=
 =?us-ascii?Q?l2nlKCpgoKi2tyH2aQAExHfIq81DbaEJm1QvcbuTTK9oJqM2qVK/wZsWJkxj?=
 =?us-ascii?Q?0LWBk2Kpz0th5NSzby7atNcB2wlrGCyjea/8B8BSRigCjUyM03eUJfxzT/RJ?=
 =?us-ascii?Q?EQ5tyjb+3ZgeqTRFi15/Dzz1M5DJrFyj5foUQOmGNHhqPIaFlCACaUKM+R2z?=
 =?us-ascii?Q?E7BT6Qx7HgFNT9ss+rRm2p1xUrxdTM+WqluvRRA36qiC+EBqcWA1ldC1i9nI?=
 =?us-ascii?Q?1EfDh0cgmrkcouBPH8uhs+57JVClVbpvzheFzQSJ+P57yDfWLC6Z7FR11HS7?=
 =?us-ascii?Q?uQKO/wo31Y6fvHCM8DFuW3cI9zHyaoO5m89D7B08PnIhvW1c18sPVBbMwZPi?=
 =?us-ascii?Q?7vCUG/Pub2OkZahIioBbqQiHslAz+67VW4kcQYYGkkrfeK5dh7nLIjsyviwG?=
 =?us-ascii?Q?6VWlABOSnfUkvoxLJzv3LKGfNy7gI5Z6TpOU2bwOE8pMqbxSYE/MMzrnNCgV?=
 =?us-ascii?Q?FsISi4g2nAwGjJk3zdmv9mI/y7cxrLJeePAeSzPzuslqACRtOxgjQszqUes5?=
 =?us-ascii?Q?el8gKGz1PZpZFBDoNfu6K2hf2k7tBRczpUAE/mTUP5WrwV0fo1rcxcOw3wI2?=
 =?us-ascii?Q?hQW86V0Idn9i89ks1R1DQb/XYqwiUMBoz0B5q4DEXcXV+atONNJRAVA1Wse9?=
 =?us-ascii?Q?M+aoHaQBdhVCMR4C/otOLuKIjUo4pzoFZeoROd/uqhK492aerdKcF9G5BdSV?=
 =?us-ascii?Q?gcbKA91Sw6mNZ5nDDmTIfyPMsSntX2Z9ElC0V/vYLxyywnz52VhFVtJrBJq3?=
 =?us-ascii?Q?kgk/ggP6HTQoNHj/HLaByySFatTgLD00vaVNdwwkibdwl4uiKbyMPzO8eFvY?=
 =?us-ascii?Q?QQqJ945gRC46er1SjgXueNk8NnAWH6d66GnHrwJVKc0Dd/tUvRXadxM+lghB?=
 =?us-ascii?Q?P0de2+IpH/mzaPPlIksgGGLkDjaWumqDEP9MQ6RuwQev+FkarywLApbc1ZSV?=
 =?us-ascii?Q?D0vMNo1drHxyE9AvEyHJgm5YyF/y+dxWP/Cbtx6lWidawGVa2zyKmkPfToFx?=
 =?us-ascii?Q?PLtIhUysn1pi1ZQ8AUAZ1gOwRU4FDb1cFocVmOAkG1dfQYR9/zvuQZszaafk?=
 =?us-ascii?Q?sV6eUB4pnci6EixnOjOWfw1zjXU28Ttzj2OVN5XjU2bMAAogGgw44mBGosGV?=
 =?us-ascii?Q?5uyjOHCAo5aRBMXri1z+fzbeH1HfnVzhSHt7AvYgmpiZhuK9S8QNslrKyf7g?=
 =?us-ascii?Q?3uZK0f1z5euE9argUop8yQ6UGrUHqsAnHt/MNhNIfCAaCuBZV6IBDR0pNzLl?=
 =?us-ascii?Q?MGVxWw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(36860700013)(1800799024)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 20:29:14.4801
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cc5c2658-de69-417c-4865-08de5474bff6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB71.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5885

From: Ankit Agrawal <ankita@nvidia.com>

The nvgrace-gpu module [1] maps the device memory to the user VA (Qemu)
without adding the memory to the kernel. The device memory pages are PFNMAP
and not backed by struct page. The module can thus utilize the MM's PFNMAP
memory_failure mechanism that handles ECC/poison on regions with no struct
pages.

The kernel MM code exposes register/unregister APIs allowing modules to
register the device memory for memory_failure handling. Make nvgrace-gpu
register the GPU memory with the MM on open.

The module registers its memory region, the address_space with the
kernel MM for ECC handling and implements a callback function to convert
the PFN to the file page offset. The callback functions checks if the
PFN belongs to the device memory region and is also contained in the
VMA range, an error is returned otherwise.

Link: https://lore.kernel.org/all/20240220115055.23546-1-ankita@nvidia.com/ [1]

Suggested-by: Alex Williamson <alex@shazbot.org>
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/main.c | 113 +++++++++++++++++++++++++++-
 1 file changed, 109 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index b45a24d00387..3be5d0d97aad 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -9,6 +9,7 @@
 #include <linux/jiffies.h>
 #include <linux/pci-p2pdma.h>
 #include <linux/pm_runtime.h>
+#include <linux/memory-failure.h>
 
 /*
  * The device memory usable to the workloads running in the VM is cached
@@ -49,6 +50,7 @@ struct mem_region {
 		void *memaddr;
 		void __iomem *ioaddr;
 	};                      /* Base virtual address of the region */
+	struct pfn_address_space pfn_address_space;
 };
 
 struct nvgrace_gpu_pci_core_device {
@@ -88,6 +90,80 @@ nvgrace_gpu_memregion(int index,
 	return NULL;
 }
 
+static int pfn_memregion_offset(struct nvgrace_gpu_pci_core_device *nvdev,
+				unsigned int index,
+				unsigned long pfn,
+				pgoff_t *pfn_offset_in_region)
+{
+	struct mem_region *region;
+	unsigned long start_pfn, num_pages;
+
+	region = nvgrace_gpu_memregion(index, nvdev);
+	if (!region)
+		return -EINVAL;
+
+	start_pfn = PHYS_PFN(region->memphys);
+	num_pages = region->memlength >> PAGE_SHIFT;
+
+	if (pfn < start_pfn || pfn >= start_pfn + num_pages)
+		return -EFAULT;
+
+	*pfn_offset_in_region = pfn - start_pfn;
+
+	return 0;
+}
+
+static inline
+struct nvgrace_gpu_pci_core_device *vma_to_nvdev(struct vm_area_struct *vma);
+
+static int nvgrace_gpu_pfn_to_vma_pgoff(struct vm_area_struct *vma,
+					unsigned long pfn,
+					pgoff_t *pgoff)
+{
+	struct nvgrace_gpu_pci_core_device *nvdev;
+	unsigned int index =
+		vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
+	pgoff_t vma_offset_in_region = vma->vm_pgoff &
+		((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
+	pgoff_t pfn_offset_in_region;
+	int ret;
+
+	nvdev = vma_to_nvdev(vma);
+	if (!nvdev)
+		return -ENOENT;
+
+	ret = pfn_memregion_offset(nvdev, index, pfn, &pfn_offset_in_region);
+	if (ret)
+		return ret;
+
+	/* Ensure PFN is not before VMA's start within the region */
+	if (pfn_offset_in_region < vma_offset_in_region)
+		return -EFAULT;
+
+	/* Calculate offset from VMA start */
+	*pgoff = vma->vm_pgoff +
+		 (pfn_offset_in_region - vma_offset_in_region);
+
+	return 0;
+}
+
+static int
+nvgrace_gpu_vfio_pci_register_pfn_range(struct vfio_device *core_vdev,
+					struct mem_region *region)
+{
+	unsigned long pfn, nr_pages;
+
+	pfn = PHYS_PFN(region->memphys);
+	nr_pages = region->memlength >> PAGE_SHIFT;
+
+	region->pfn_address_space.node.start = pfn;
+	region->pfn_address_space.node.last = pfn + nr_pages - 1;
+	region->pfn_address_space.mapping = core_vdev->inode->i_mapping;
+	region->pfn_address_space.pfn_to_vma_pgoff = nvgrace_gpu_pfn_to_vma_pgoff;
+
+	return register_pfn_address_space(&region->pfn_address_space);
+}
+
 static int nvgrace_gpu_open_device(struct vfio_device *core_vdev)
 {
 	struct vfio_pci_core_device *vdev =
@@ -114,14 +190,28 @@ static int nvgrace_gpu_open_device(struct vfio_device *core_vdev)
 	 * memory mapping.
 	 */
 	ret = vfio_pci_core_setup_barmap(vdev, 0);
-	if (ret) {
-		vfio_pci_core_disable(vdev);
-		return ret;
+	if (ret)
+		goto error_exit;
+
+	if (nvdev->resmem.memlength) {
+		ret = nvgrace_gpu_vfio_pci_register_pfn_range(core_vdev, &nvdev->resmem);
+		if (ret && ret != -EOPNOTSUPP)
+			goto error_exit;
 	}
 
-	vfio_pci_core_finish_enable(vdev);
+	ret = nvgrace_gpu_vfio_pci_register_pfn_range(core_vdev, &nvdev->usemem);
+	if (ret && ret != -EOPNOTSUPP)
+		goto register_mem_failed;
 
+	vfio_pci_core_finish_enable(vdev);
 	return 0;
+
+register_mem_failed:
+	if (nvdev->resmem.memlength)
+		unregister_pfn_address_space(&nvdev->resmem.pfn_address_space);
+error_exit:
+	vfio_pci_core_disable(vdev);
+	return ret;
 }
 
 static void nvgrace_gpu_close_device(struct vfio_device *core_vdev)
@@ -130,6 +220,11 @@ static void nvgrace_gpu_close_device(struct vfio_device *core_vdev)
 		container_of(core_vdev, struct nvgrace_gpu_pci_core_device,
 			     core_device.vdev);
 
+	if (nvdev->resmem.memlength)
+		unregister_pfn_address_space(&nvdev->resmem.pfn_address_space);
+
+	unregister_pfn_address_space(&nvdev->usemem.pfn_address_space);
+
 	/* Unmap the mapping to the device memory cached region */
 	if (nvdev->usemem.memaddr) {
 		memunmap(nvdev->usemem.memaddr);
@@ -247,6 +342,16 @@ static const struct vm_operations_struct nvgrace_gpu_vfio_pci_mmap_ops = {
 #endif
 };
 
+static inline
+struct nvgrace_gpu_pci_core_device *vma_to_nvdev(struct vm_area_struct *vma)
+{
+	/* Check if this VMA belongs to us */
+	if (vma->vm_ops != &nvgrace_gpu_vfio_pci_mmap_ops)
+		return NULL;
+
+	return vma->vm_private_data;
+}
+
 static int nvgrace_gpu_mmap(struct vfio_device *core_vdev,
 			    struct vm_area_struct *vma)
 {
-- 
2.34.1


