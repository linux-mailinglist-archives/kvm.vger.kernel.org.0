Return-Path: <kvm+bounces-64604-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 65C58C88267
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 06:28:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 6E2CC352D91
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 05:28:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E75C31A55B;
	Wed, 26 Nov 2025 05:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="B45V8xAZ"
X-Original-To: kvm@vger.kernel.org
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011007.outbound.protection.outlook.com [52.101.52.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D21D3191D4;
	Wed, 26 Nov 2025 05:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764134810; cv=fail; b=bGM+wHe/ou1kBJxl9iKYihPKXvXYHYIDI1o/KuE14zakXHq4hyGlfWSy2MZAvTz1HeuNaU8ImxhrYOaVK7lRD5un0ONBwFCAFYDhzKzaNOYrVXtpgcXhURHtm80o9n+W0kiNxoZKm89S6XWGfOQZIh/6J+56bUwzGZmqe2os6s0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764134810; c=relaxed/simple;
	bh=XCdoaUzYjYSyr3389H8ZdQR2wG7GK/6V/9Cn6h6CZ2E=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UbjVISyDNohhRP3kmWLuaHVuV2db53QtsJdBRd/XqgFWkfgC5yBRpcv/8cC7+I8jKTf7VweTx20hv4N0TssDDMBoRK4qVcWEgvj0+nvG0C+KqJgZ0iWH3z6pn9HNrQE1bVGu//WxdzjJDh8xRH8CaHxRLOV9sVYiiZjnHtqMqDs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=B45V8xAZ; arc=fail smtp.client-ip=52.101.52.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bgtlRogPn2XoOTXwmD0PLmtIWHbAb6eK/eCUuyF6dMSUmPI3hjf0YRX7rxVZb0e38k0tmY6wOttwZpfIxUZXpwRc7NTPSjbHglRqrxUlKmokSESwqgi80c4HvA1vHGGooWWbDCq0M35LXOyHAG0O76mJjjg9JT/pZoMhO0KaV5clmDn9VMhJ2kivDIzoMubbVVh6Etv8SoliTdGNR1K7Ie5IIl/hScIhypi4vtqKeuNZNDuy8dKRKG7gAiNJSYJtrRfvKeNLJ6SmjKmZNDpZASdYGGii0d/QqY/ahQY1g56yEyFaUB+QmfeUa/l/UZImYViFcmDk9UWTgveC/PJJug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gqbjvAXQhuvsJ3DrV+oSMMzZIY0AUMYu7FtsyzJ1CwY=;
 b=ntBBRjAb3MeQ7FEs/M6gyjdHNO+hXRBNIOVdlyjUujw49MSPDBNc4vpAS6i5jqEidoeSi9ItKZkOsKbueWGw3lKDol4nfKiQPK35xqJzldGSfHxosV22Hx5EfqRelo5I2WDPpHDG/lf/GSDgqQFe37Cq65Bgzi3QGZFc/1/N9zZBWJV7lIR3Eg2MO/KYMuoH+gN0zFXhf7lrge2P5xMWcu8fWqgcOJuKazUdxTsUFhNUiCRx4hVSrBp8jJkPSFx1IkfNLdLmb4irm5JxtW2FKZs69PXjbpQy/1a6iBdtU0ABrqq28pybp1mGlk994pbkSzQxTKeZhOjzYlmXrOh6fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gqbjvAXQhuvsJ3DrV+oSMMzZIY0AUMYu7FtsyzJ1CwY=;
 b=B45V8xAZAb0yHE0Iel0wvjZqp6JbIKLqInovlr5+RPXg9ebAEXHUOulZ9swECf98+24lXNg6UA1DNgNONVcmPVn4T9sOyHybJ+prirdYDSLBlyOGmVcKZJYrcjk5D5fA8N6Nj6FhEbO2rpZ3nhQofqHqGW0suxX+FS4PNebao8FFcPa/KIzNR0Gxmld/dwJuD+GPLL0ODhhhcpPStBBBQ+e63TNP0faSTrGLsVReZPNRSC80CrNTLRIfuheV6qoA0A2ogAHEnFezxAx4/XZcENJ+ALSOFWSAEOpvHp5J1zph4Y4kjsay4D3mt7p7ReFesFlVA1XEc4vLkjCZcISsvA==
Received: from SN6PR08CA0016.namprd08.prod.outlook.com (2603:10b6:805:66::29)
 by CH1PR12MB9720.namprd12.prod.outlook.com (2603:10b6:610:2b2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.11; Wed, 26 Nov
 2025 05:26:44 +0000
Received: from SA2PEPF000015C9.namprd03.prod.outlook.com
 (2603:10b6:805:66:cafe::ad) by SN6PR08CA0016.outlook.office365.com
 (2603:10b6:805:66::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9366.13 via Frontend Transport; Wed,
 26 Nov 2025 05:26:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SA2PEPF000015C9.mail.protection.outlook.com (10.167.241.199) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.7 via Frontend Transport; Wed, 26 Nov 2025 05:26:44 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 25 Nov
 2025 21:26:30 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Tue, 25 Nov 2025 21:26:29 -0800
Received: from
 gb-nvl-073-compute01.l16.internal032k18.bmc032b17.internal032f11.internal032huang.bmc032l04.bmc
 (10.127.8.11) by mail.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20 via Frontend Transport; Tue, 25 Nov 2025 21:26:29 -0800
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
Subject: [PATCH v7 6/6] vfio/nvgrace-gpu: wait for the GPU mem to be ready
Date: Wed, 26 Nov 2025 05:26:27 +0000
Message-ID: <20251126052627.43335-7-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF000015C9:EE_|CH1PR12MB9720:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e1a5e45-48eb-4d1f-0a0f-08de2cac6323
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|7416014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZoN0ThS5UYhwtQj1PeOf0sGpQFtsqpFpRPpj+dmA5Sm++nlY9uy0xUPvnLos?=
 =?us-ascii?Q?QGxE+oSurhAsRYlwrKPt/VVyo1ihjwLjXb+4/1vnW1+XCF7Ued5TToPbkOWT?=
 =?us-ascii?Q?7MzLpdnxT6N0LtURzyLJ5uWyjMmOrn30wAqk7yWMA0jlLxSA4SHw6WNQUzVd?=
 =?us-ascii?Q?22ArJFm7mEvtwV/BTXG6wbOr1E7ZV/THWAzRBkfSc/ctQRgWIIeYhEzau0/w?=
 =?us-ascii?Q?DEqKbCGjRZItK3KWwysSJ6HJXlWUmxl3M7Oc0SdwIp7/QDT9ZM9FxdIE+YNU?=
 =?us-ascii?Q?WOg6mD0aF2T0Y61fQajmfXpAlr3l19bnLBFw4PJO7QrZaeZPiwt9SI1Yx4dI?=
 =?us-ascii?Q?2j/k8mqMnBeeQpNRNd/x6wnlfh0PkMQAme7/qWIGv4fSCTmwsDNDhpZX0vsf?=
 =?us-ascii?Q?FVXtdh2i1EARupHgh9CC7soKzlZNfMc1m/vpBy0heMwYfD7kc6a2Jg4vBYys?=
 =?us-ascii?Q?XyOjymufbjBcVmFupZMFxwaF5Sz7w7JaRisQJrOZuZyac64hBR10sETVPTD5?=
 =?us-ascii?Q?um3ZngLTgj6eorEfMwmLscBWFHj3YwJvMlhpN8lV0N9STOt/pvrkRtvZZxtR?=
 =?us-ascii?Q?41cuE9/b/Nt5FLDW2SYuYP1JaR1y0S1prFuxL/f8a459UUVr2TzIa+4DXc19?=
 =?us-ascii?Q?55ngqT8bD/K3m6IKrMUfogs6DWMwLq618c8+5Ux99AcFttEaL/b9rK2GE2Vd?=
 =?us-ascii?Q?4mkJ89/MJYrbW/txcIUfECg291Nqib4geG1z2ij6jlLusx4ezjPOR/x/phE0?=
 =?us-ascii?Q?zj41wd8f8RqYAwBQjbSn2Adrhx8QO0vs9Ev0YOYqfSwlE1vB2HXs6WiLun/W?=
 =?us-ascii?Q?/bSYJuYnA3SyndM5UlMP+BoUeEYG9VHlYgsPB9jlan01pF2MMlDtmDKSlHqm?=
 =?us-ascii?Q?LFj1AxH9Y58GcGgQgRzefp532V5Fn12n0csrQZc3YiwVaigY7ianFWciyTut?=
 =?us-ascii?Q?L241m56Wri6niS4Jfc63cMSSccDAVPVI9QSOftYc9XbAM5fdA5kNnNKcKL/+?=
 =?us-ascii?Q?APha6PTrI9rKpU75BgaRu1GGNTxC5DsO7OMUZY2TLV69nBcOZEI9lXjXu07/?=
 =?us-ascii?Q?485349tvqfYYcUBntMQsHdx8EcmQUhCSWvuHUuLksy/WfXfG7sndh9p8HyRy?=
 =?us-ascii?Q?14RD28TT8nV8OSF9Y186FcGrqmZHIoh+ZGBeKzwIbUNrjK5ZewibNKAX4sVB?=
 =?us-ascii?Q?+dG8ZxYGOyvgEKKE7p38przu0QtM3iM4UFHGjSpQ7ucIb6g50ZwHrXsICBxG?=
 =?us-ascii?Q?f+258cuofyVR2GxVkgS3MuHPjFd9PhCRGOGs8WWDH2mQxfJVLYz8alz4m0v3?=
 =?us-ascii?Q?k8MH0/zpQ/vujNdiahtIpP772gVP+ToOfXQhFBYOVjSBP7Zi5kmMetEIReUA?=
 =?us-ascii?Q?Y09KLqiXQwj9RGYmIQLH32RWrkifPYlH/sxweQCq4I/wJwaTsf4EW+M0aZEU?=
 =?us-ascii?Q?TVZyUCs8GdTfyaHjdYZSWDAKszpNsa7u9N/nWRrwx8QV95JOgNBvtlRyPojl?=
 =?us-ascii?Q?q0QQzHcO6LOxDHSbtUlIyAGwvhYvOI/3yf+i5rAi2UpwHMGGJlqaXGyeEumc?=
 =?us-ascii?Q?+6L/yWS9mPU/BjNQfeM=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(7416014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2025 05:26:44.0857
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e1a5e45-48eb-4d1f-0a0f-08de2cac6323
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF000015C9.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9720

From: Ankit Agrawal <ankita@nvidia.com>

Speculative prefetches from CPU to GPU memory until the GPU is
ready after reset can cause harmless corrected RAS events to
be logged on Grace systems. It is thus preferred that the
mapping not be re-established until the GPU is ready post reset.

The GPU readiness can be checked through BAR0 registers similar
to the checking at the time of device probe.

It can take several seconds for the GPU to be ready. So it is
desirable that the time overlaps as much of the VM startup as
possible to reduce impact on the VM bootup time. The GPU
readiness state is thus checked on the first fault/huge_fault
request or read/write access which amortizes the GPU readiness
time.

The first fault and read/write checks the GPU state when the
reset_done flag - which denotes whether the GPU has just been
reset. The memory_lock is taken across map/access to avoid
races with GPU reset.

Cc: Shameer Kolothum <skolothumtho@nvidia.com>
Cc: Alex Williamson <alex@shazbot.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Vikram Sethi <vsethi@nvidia.com>
Suggested-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/main.c | 81 +++++++++++++++++++++++++----
 1 file changed, 72 insertions(+), 9 deletions(-)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index b46984e76be7..3064f8aca858 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -104,6 +104,17 @@ static int nvgrace_gpu_open_device(struct vfio_device *core_vdev)
 		mutex_init(&nvdev->remap_lock);
 	}
 
+	/*
+	 * GPU readiness is checked by reading the BAR0 registers.
+	 *
+	 * ioremap BAR0 to ensure that the BAR0 mapping is present before
+	 * register reads on first fault before establishing any GPU
+	 * memory mapping.
+	 */
+	ret = vfio_pci_core_setup_barmap(vdev, 0);
+	if (ret)
+		return ret;
+
 	vfio_pci_core_finish_enable(vdev);
 
 	return 0;
@@ -146,6 +157,31 @@ static int nvgrace_gpu_wait_device_ready(void __iomem *io)
 	return -ETIME;
 }
 
+/*
+ * If the GPU memory is accessed by the CPU while the GPU is not ready
+ * after reset, it can cause harmless corrected RAS events to be logged.
+ * Make sure the GPU is ready before establishing the mappings.
+ */
+static int
+nvgrace_gpu_check_device_ready(struct nvgrace_gpu_pci_core_device *nvdev)
+{
+	struct vfio_pci_core_device *vdev = &nvdev->core_device;
+	int ret;
+
+	lockdep_assert_held_read(&vdev->memory_lock);
+
+	if (!nvdev->reset_done)
+		return 0;
+
+	ret = nvgrace_gpu_wait_device_ready(vdev->barmap[0]);
+	if (ret)
+		return ret;
+
+	nvdev->reset_done = false;
+
+	return 0;
+}
+
 static unsigned long addr_to_pgoff(struct vm_area_struct *vma,
 				   unsigned long addr)
 {
@@ -163,13 +199,13 @@ static vm_fault_t nvgrace_gpu_vfio_pci_huge_fault(struct vm_fault *vmf,
 	struct vfio_pci_core_device *vdev = &nvdev->core_device;
 	unsigned int index =
 		vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
-	vm_fault_t ret = VM_FAULT_SIGBUS;
+	vm_fault_t ret;
 	struct mem_region *memregion;
 	unsigned long pfn, addr;
 
 	memregion = nvgrace_gpu_memregion(index, nvdev);
 	if (!memregion)
-		return ret;
+		return VM_FAULT_SIGBUS;
 
 	addr = ALIGN_DOWN(vmf->address, PAGE_SIZE << order);
 	pfn = PHYS_PFN(memregion->memphys) + addr_to_pgoff(vma, addr);
@@ -179,8 +215,14 @@ static vm_fault_t nvgrace_gpu_vfio_pci_huge_fault(struct vm_fault *vmf,
 		goto out;
 	}
 
-	scoped_guard(rwsem_read, &vdev->memory_lock)
+	scoped_guard(rwsem_read, &vdev->memory_lock) {
+		if (nvgrace_gpu_check_device_ready(nvdev)) {
+			ret = VM_FAULT_SIGBUS;
+			goto out;
+		}
+
 		ret = vfio_pci_vmf_insert_pfn(vdev, vmf, pfn, order);
+	}
 
 out:
 	dev_dbg_ratelimited(&vdev->pdev->dev,
@@ -593,9 +635,15 @@ nvgrace_gpu_read_mem(struct nvgrace_gpu_pci_core_device *nvdev,
 	else
 		mem_count = min(count, memregion->memlength - (size_t)offset);
 
-	ret = nvgrace_gpu_map_and_read(nvdev, buf, mem_count, ppos);
-	if (ret)
-		return ret;
+	scoped_guard(rwsem_read, &nvdev->core_device.memory_lock) {
+		ret = nvgrace_gpu_check_device_ready(nvdev);
+		if (ret)
+			return ret;
+
+		ret = nvgrace_gpu_map_and_read(nvdev, buf, mem_count, ppos);
+		if (ret)
+			return ret;
+	}
 
 	/*
 	 * Only the device memory present on the hardware is mapped, which may
@@ -713,9 +761,15 @@ nvgrace_gpu_write_mem(struct nvgrace_gpu_pci_core_device *nvdev,
 	 */
 	mem_count = min(count, memregion->memlength - (size_t)offset);
 
-	ret = nvgrace_gpu_map_and_write(nvdev, buf, mem_count, ppos);
-	if (ret)
-		return ret;
+	scoped_guard(rwsem_read, &nvdev->core_device.memory_lock) {
+		ret = nvgrace_gpu_check_device_ready(nvdev);
+		if (ret)
+			return ret;
+
+		ret = nvgrace_gpu_map_and_write(nvdev, buf, mem_count, ppos);
+		if (ret)
+			return ret;
+	}
 
 exitfn:
 	*ppos += count;
@@ -1056,6 +1110,15 @@ MODULE_DEVICE_TABLE(pci, nvgrace_gpu_vfio_pci_table);
  *
  * The reset_done implementation is triggered on every reset and is used
  * set the reset_done variable that assists in achieving the serialization.
+ *
+ * The writer memory_lock is held during reset through ioctl and FLR, while
+ * the reader is held in the fault and access code.
+ *
+ * The lock is however not taken during reset called through
+ * vfio_pci_core_enable during open. Whilst a serialization is not
+ * required at that early stage, it still prevents from putting
+ * lockdep_assert_held_write in this function.
+ *
  */
 static void nvgrace_gpu_vfio_pci_reset_done(struct pci_dev *pdev)
 {
-- 
2.34.1


