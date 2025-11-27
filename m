Return-Path: <kvm+bounces-64900-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id BFCBAC8F989
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 18:08:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 02D8E34DB65
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 17:08:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E14B2DF122;
	Thu, 27 Nov 2025 17:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bllXJrjA"
X-Original-To: kvm@vger.kernel.org
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013005.outbound.protection.outlook.com [40.93.196.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1EC2DFA4A;
	Thu, 27 Nov 2025 17:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764263218; cv=fail; b=RhMiTzuCNCpK2kkPhFjutJRX1pw5oXfTT+t1o2PRhcAGwu6wnoWf3149MUzrs8i1h6mfugXpuc5G3wmBY7rAvhWl8Uv1YaP8L0LlLukcWtKWrAmCJVeIMBUfsbIisOBAwYmfaOkwhEugIkpgaf5zBxG0Tl9bFxyBWPeCLlzN/xs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764263218; c=relaxed/simple;
	bh=f12lu7twiuNN3Fezu5gWZERPt5ETMUH1++wMYlwLh6w=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NLE9VaWYD/y3A6LnIjJxbbGOv2w2rulr5Elb4AwYydnXbgzyh/PAfr8BesRfs8SeenQ601KIdgCjufvlZEqCyuK0mE0rKUlXZWuwKNaxwQMtAgWJjgJbIDoNa2f5ItFqLgOswUZ0MBQjP3SFY4pyW5zWyGhIH7aoFah6vNEScsc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=bllXJrjA; arc=fail smtp.client-ip=40.93.196.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g34TSM1670riOTRY8Fg0fKx+Edzzytwo5ijjsAlyhBdYoWQMvJUXGq04sIfPmicH3l4zxr4QWKalFrcxZgx2wLEi4GSZkXBxcPdYMG0qza+8oAb+i7zkO3bcA+8k4Z0xSq1TJFmoAm9L8oFpQ/uU4dySKx6U/Scsz+kLST0ZOv96SrToRHP9KC8a4/kGzw3IUE/DyMO0WcRFNHyDKcHf56S+J72piprloWKo7Dch9eswH7HNec81DRTVNjsBOmMKXoz8Y+oF8wO+4ivyt7yhmpSoFlDPVAollsnsao/332/6BDR4oTPpkLtCec4UFt0OOlCMx5Dw+yFDTeMhzqyHHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5xRXpfwLFBHzgFIEYqVGqcU0z3cHh7tKTU8tqAh/LAE=;
 b=E/Jzv2i3/sSw9Ci4ZNUICK9yXstgGM0zVz91kDQhLACiBkUCtQgLxfDlC9wLrjCKiuXgDQB1sSOxMrB0JNapgJZgG3zY9auAwbUw5pGPdgQ8dIeELM2RQeY4jrCPnyPzp+3vxUBtH/WE7QvKj1CgZh54aOoJpconxy7L4MhXsZm8GEap9YQB9fK7NXUsurV/kqy8OLhzqDKFe1kET062TSoMhmZWGAGe8AFZb2rm2jvekS3qI8d5tKGxfLS/10dwXZs9rCsdTwpipaWQqMSbhlBpk6DTfeFBk4aR8fxq/olTbNrQdrGplDuu2tXY0zZjapL4gWHZY09yuOWYEq5CCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5xRXpfwLFBHzgFIEYqVGqcU0z3cHh7tKTU8tqAh/LAE=;
 b=bllXJrjAkaKQA6EpYuF8PC/sxJ11BYH41YZzGOIDl5rGKbTfB0jehM2YpMM0wBe4Yao0sT5QDLy58KGShBT98xsTV4+9C546N4HlrMWVBFskG62C5kevl5is9puUoz/eMfn1/T7/JHhW/sweqqu02n34qnfdeFrfhUSpJ8lihhfVi/PeEG5ZxK7y+PI/Sah8b8YR/hl0EPtVgkEy9h1x6x514gpty0TeqNlbIFCmAgnJhpFSEKRjAsySHvGv50zt1ko20z8CTNpfrbU/70MSu5wbbr/BjQS7IwW9XG8IfEdrjKiOT/jeTtCqLfvmSRfMkcAyvfSHlF5HX93i2TEKqQ==
Received: from DM6PR14CA0058.namprd14.prod.outlook.com (2603:10b6:5:18f::35)
 by CH1PPF73CDB1C12.namprd12.prod.outlook.com (2603:10b6:61f:fc00::615) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.13; Thu, 27 Nov
 2025 17:06:52 +0000
Received: from DS3PEPF000099D9.namprd04.prod.outlook.com
 (2603:10b6:5:18f:cafe::9) by DM6PR14CA0058.outlook.office365.com
 (2603:10b6:5:18f::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9366.14 via Frontend Transport; Thu,
 27 Nov 2025 17:06:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS3PEPF000099D9.mail.protection.outlook.com (10.167.17.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.7 via Frontend Transport; Thu, 27 Nov 2025 17:06:52 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 27 Nov
 2025 09:06:35 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 27 Nov
 2025 09:06:34 -0800
Received: from
 gb-nvl-073-compute01.l16.internal032k18.bmc032b17.internal032f11.internal032huang.bmc032l04.bmc
 (10.127.8.11) by mail.nvidia.com (10.129.68.7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20 via Frontend Transport; Thu, 27 Nov 2025 09:06:34 -0800
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
Subject: [PATCH v9 2/6] vfio/nvgrace-gpu: Add support for huge pfnmap
Date: Thu, 27 Nov 2025 17:06:28 +0000
Message-ID: <20251127170632.3477-3-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D9:EE_|CH1PPF73CDB1C12:EE_
X-MS-Office365-Filtering-Correlation-Id: d6b8b85e-63a5-4e6a-632e-08de2dd75c38
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|7416014|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ff1GlfabECURx7bRkAvh5P1za9uzjnn0UwsqxG8WSgH7usPQBZLiZG7g0dmJ?=
 =?us-ascii?Q?hHbJs73KYMUEK7pYpY+f1D6Q3tz/B+kh63tj+w4JOY/QaD2Cq+auqEBPvEjy?=
 =?us-ascii?Q?BaTQuHk/hAYH01tLh4iYdmCaJ68N4S96oN9Or+msQOYUAOTSJlDWcAvQyvIU?=
 =?us-ascii?Q?zcXQhbzLRqq+EyuHDPUD/sNl0/RxixEgrTfZEusdArdg3pfEb6SYwP6AbZHO?=
 =?us-ascii?Q?CMRXM+lcMCIg414IXiKUHXmmeoTdRA4M2H8PsPfJYg6yHO0n5JbLd5QTT+kY?=
 =?us-ascii?Q?LOZKx+K7+v6FiJShJalFjxvCT2mvunOrFRsNqjn6m06mSvbDt1tc0yfsm63T?=
 =?us-ascii?Q?2rZ5TJhg7oF760RisaiM0KsSZmimFrYMh1z3GrZZoCX4vyUtPZGMLvY3TgCW?=
 =?us-ascii?Q?ALcCtj7bLiXIj7gdjIx1txmwPKusiwqx5Olp/YjyIyFmrjks+ugg2H0U7Ksc?=
 =?us-ascii?Q?+wjYshgmii+isZbx1I8dZhqrrwv8SxEAzMoDw5cZaysLslubna0pR/5fUU5m?=
 =?us-ascii?Q?/ZOGSGPE2fAJmgx3k0Z2bhTXe/mZc0+T9KCwG1du0m1adxaCP88wGdXw9UKY?=
 =?us-ascii?Q?e8LERUWMhYJ+xtgx8AKj+mxIrufP/7gktMgFGapNag7zJd2FguvA0VPYrR55?=
 =?us-ascii?Q?PSRJYrEVh26DZWK4bjFKLmdotMlgAvliKXexzmENrYPZjl7EKe1guxD9uzmf?=
 =?us-ascii?Q?nRI5rpMgOtVYly1FhzM4edp4hL/R5bbrwa7XhR60+vDsr8f3acgSMPgktipS?=
 =?us-ascii?Q?WiK2tJ0XtNorhQoHL7lmtfyV9IUD+ub2MmravRagvpHorAP9lcq0RNdlPe1n?=
 =?us-ascii?Q?hh251fIo3Hz2O8WXmwXiOIsESyR1bqWngEFu0Wa4GfU4qm07zzpEfg8Zo3y9?=
 =?us-ascii?Q?RJY2d5AZWicHzEjnhrm8vnFGO9tZXuODHqoFXyyzpGiam/NdiiZMn2/wzZfJ?=
 =?us-ascii?Q?I4sM6Ekf4jHYIudMj0hb30LrNQwSFcdltjdL0kK0HVHGDmYFSmapHwTHQc52?=
 =?us-ascii?Q?CDxo45+K3LuwKo48vpfJIRhmFE/PBbBm5byQuhvGLM7QwDJzLJwS7YTn86PI?=
 =?us-ascii?Q?FqCKRTT0CpDEn3vxAYagIm23HysyMt+0zgq+5ZDEr+lbm1s4jJYz6AIIKpy+?=
 =?us-ascii?Q?GAqc2ZgyMTJeprEnLdvSqxwnhjI/9R4ziV49gPQ5Bvgepn+4PIPUzypOWozg?=
 =?us-ascii?Q?5fXj05osfwOjEB6KlXAV2N+Eqt99JPR6Q9jv78QwFoPqvBMyY3LP1+EL2aG2?=
 =?us-ascii?Q?fDtwDaDZqDO2eJwPMlGv+pQOenKYlhPkiZrczG0aLkWmaJIrNYyctqWMvBLU?=
 =?us-ascii?Q?pqcENfa7fjS/TOLJg1y6ADLOoI+wX0XB72r3RCutp78cEx5yMDRgIprWRJKw?=
 =?us-ascii?Q?gR9ieC2m1xoRfdh+qrz01MVoaxE0YXMemu95EYVCgda5I1jYf+k6IxP9EHfI?=
 =?us-ascii?Q?HmkTphZZkD/TmqXScOZUqmjg6TIArwDCzn2vLuGdTbDxM9Z460mXO57ZBKgG?=
 =?us-ascii?Q?NBICfnVEHsIvl5Qw/AM/xBV2TrnC4Ha55vXQYXY/48PTyZzWvro4M5H7Kv8I?=
 =?us-ascii?Q?CCIxvvlXMnha/rIfWPw=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(7416014)(376014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2025 17:06:52.0155
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d6b8b85e-63a5-4e6a-632e-08de2dd75c38
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D9.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PPF73CDB1C12

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


