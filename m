Return-Path: <kvm+bounces-64378-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B8A4EC805A1
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 13:06:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C98893AB6F2
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 12:02:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B3423019A9;
	Mon, 24 Nov 2025 11:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="AvF29sB8"
X-Original-To: kvm@vger.kernel.org
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013004.outbound.protection.outlook.com [40.93.201.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BBBD2FFF9C;
	Mon, 24 Nov 2025 11:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.4
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763985582; cv=fail; b=unJN0K/aOaFezlgS2Y8r9qn0ket9oX28pID9pN+XbhH6i3z/nJg9K7YEP5ff5UG5kD/moZJN8vr2HdOJf+PlctbvXQwZdii3D5snXtMGBovKEsktKzjaUPAxNrX9o+/1q650OnaWirVh+O0DWUxCjQR1A89rvASD7pVJYYaB6Mc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763985582; c=relaxed/simple;
	bh=95Qv+EkeG/AY6SPaQl/+VQnz2b1lVwS4301cxU6kTzc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Lc2RgOi8Zw0Moj3nxfi7/DOsG1Ese0mxGPIsLRAPRZwC7HkUIf8NMhzoBfDtkEE3227PTE9m0YQ1vPBQobJ7qo0/AofmluoPuHabI+VHTYZl2vPZpTmlT0woG8LJnu5qzWwzyZ/MDkQaqnL3HJTd/3VyEXFXHGswFzaN2VcOWwU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=AvF29sB8; arc=fail smtp.client-ip=40.93.201.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PTi/+SbskaB4+6vXApjO8kjwzV3e20jBQbdgIrXb+107TzRgSw9BU8/gZS8RbuXe6iD1Bqbuu7aR32KC5e7IRMqcO7WWbPyJMPT/nIAKIduW84o2J9+liBhgwMTvYBbks/PeI6DhlvWyCAYjW4AIp+eJhwbZGgH42hr5Yp11GIfEgSVj1/U/YOPaqtp0tYkstVbJe/otCFjxoc9V+vFfOQqH4Lm+jd6BbWUcdCcgFgk93H+ylEojqGxIt/W8jwuBZBlOQDLb/HPQ19kkOIvhOkzB3t70vhiw7aB8wMr3Qx2SSIfdLYyVHriixFWpBwiyUpNntK9JhSsEVe00z77GXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a5v3zp0gPekzrmmR9dFwH36IYdB62anj8+hQVyA1kBA=;
 b=C9AI9sFY0ARF6dLpjc41TXFuGpXfKfsqWw2qmvbj9l6cM/dVmYgAKOKzaKf/bTLqqpU4BxBDA9RsMorwbBTHgXYW6DtDVYw8gTvskbqN3Q5f2zcT7NjIQHUI24/kW/ocy/prMkxOJQwg+cZOB96lBOEMV+4++CrnyHJEEvG8TZaGHxmrLV2MOnrpkbDO9mqR/BvgsdfXAsYJhgZxTziuPPeUz/krNdOelMWWxNxbnrhRuk49Ag+HxK5vNJoovwvkCYrhPMOLbuK6enzfh7HhGWMTOZbmpiEIO1d+sgNCh9CRHpcc8PhWj+Gca2dmI4mBue7S61rQXyW6kvku8eKc7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a5v3zp0gPekzrmmR9dFwH36IYdB62anj8+hQVyA1kBA=;
 b=AvF29sB8cFLy7udziwsglOGaenZn70it+XYD6xOeVaoQGzlv2RJje4n7wx9Y5B7++lxT5/+2bpIHrxZrrBM7+myOfM9Qe13ES0aa+FjM6KHG4sOOay1K2H8j5ejhKdJHC6To3B0H04cXeBgohfqQSSW8mtErPQBOaJRTbJlURwQm1CpCqV2MhQxWBoeyKGNiuJUUIVrTBo8V4XQJEU7d0NvxKX8c6w2HbXxiljsJYkXw9jwr9Uz+XMsbTe7Q6Bhh3oTiFq5GxlZJQOAJX1ABTgz5UR6Xi89uB5cKMHTCz1xfMPxVOa1xckCSb+kIlgSl2FZoMMo4D5LBjuqVi1qigQ==
Received: from SJ0PR13CA0047.namprd13.prod.outlook.com (2603:10b6:a03:2c2::22)
 by SJ0PR12MB5634.namprd12.prod.outlook.com (2603:10b6:a03:429::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.11; Mon, 24 Nov
 2025 11:59:36 +0000
Received: from SJ5PEPF000001C9.namprd05.prod.outlook.com
 (2603:10b6:a03:2c2:cafe::9e) by SJ0PR13CA0047.outlook.office365.com
 (2603:10b6:a03:2c2::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9366.6 via Frontend Transport; Mon,
 24 Nov 2025 11:59:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SJ5PEPF000001C9.mail.protection.outlook.com (10.167.242.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.7 via Frontend Transport; Mon, 24 Nov 2025 11:59:36 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 24 Nov
 2025 03:59:28 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Mon, 24 Nov 2025 03:59:27 -0800
Received: from
 gb-nvl-073-compute01.l16.internal032k18.bmc032b17.internal032f11.internal032huang.bmc032l04.bmc
 (10.127.8.11) by mail.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20 via Frontend Transport; Mon, 24 Nov 2025 03:59:27 -0800
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
Subject: [PATCH v5 1/7] vfio/nvgrace-gpu: Use faults to map device memory
Date: Mon, 24 Nov 2025 11:59:20 +0000
Message-ID: <20251124115926.119027-2-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001C9:EE_|SJ0PR12MB5634:EE_
X-MS-Office365-Filtering-Correlation-Id: 81e433ee-6b73-4b59-6b51-08de2b50f084
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JbeGtYOU5r8npFVXwZb9KFtxdvnq7ClNO+gKIeUUOtPBKpsQiJ+Mcp7wMHsc?=
 =?us-ascii?Q?NRxHK1YssBUOIkktgo5u0X9opd2kABgouNns8oh7gKO+q0u4LptQUNBKfO3e?=
 =?us-ascii?Q?IBVUnq5i/fNnDXYUhnjurN2DxUOWCwpBCgrgtGp/9kwfjOsnOSfVvtB0tc/5?=
 =?us-ascii?Q?xqcKnBV5GaPIR28KGH7VfPZntGNo4g3rCktBjX+tYNNtFz3MbeaJSRj2kkys?=
 =?us-ascii?Q?q9KgyMDLOt+lvfNX/B4KmLWa/Xqn+Ck0as0qY0FG8EJfLreNYCbyF/K0sUBB?=
 =?us-ascii?Q?WPw15Of6ByTfd3BE9J5Zoba99eM5uECAlEDi7qp2bIBF2JZn0UsvZTpTC57r?=
 =?us-ascii?Q?9nvMqoIXvcc7vvoQbp1fGIiny7kvAsJKlAUSP4OnoSXavNhRVDYCkc+6PbTt?=
 =?us-ascii?Q?LabYdm+r/iS6PCE17sdBg07yJ+/KPWFUFiQiaPoi15ZwleYbTTbegDZ+3SvS?=
 =?us-ascii?Q?TADc5suYCGtzh6nUtVCUDNs1t9crwPQBlUFtzxnHBF6uwHFdAnr8Y0/H+C/A?=
 =?us-ascii?Q?LWdOwk/XqACn0z0/u3zXiVNlqksUCrR0Xbz0MdQUbfrX+h/8qAF4nSb6BSbJ?=
 =?us-ascii?Q?4TUNRAbddlqM7F7umQ0Z5yTnPGuHVoE461JyorXP90+4wjF0LJTCWsZaOPzS?=
 =?us-ascii?Q?Kfbblu/qSkWWDh0mHFpMMxWrn1cqVmkJ3d4ZoATpnaUTfxBJnAbyXc1Lz01B?=
 =?us-ascii?Q?PWG0jRlHf6axBiNLNn02FPpjeEBcL1l1tRGPwXVjAZicNF1WRlkktpih9VBg?=
 =?us-ascii?Q?J7NE7YzoyE2JFxGphqee0KQJw/a0BnnqayyqDjjdyWRGsMmzHxpl/YV+lN+Y?=
 =?us-ascii?Q?YVr3PHJ7D+n7yqLAZXbhvO8PknVYuXgFmL3oCj0rqRtnxAa5MBZFdu6AB5xd?=
 =?us-ascii?Q?uP2pm04Pj33KQq+ndEhI52CImoJpS7yTTo3jJJpK1krziKsVld6Ha6r9ANWK?=
 =?us-ascii?Q?5vo1iiwlgyznYF9N6EIhtiAE/9P12dF1t5rXPDvg0yLGMyxuwagjaRgv3JC3?=
 =?us-ascii?Q?efk3TUOAYx7LrMlbZpai14tnO1pnIX8fl7xtNbvKETYclKI5PKjZzxt3Yawq?=
 =?us-ascii?Q?vN7DTnCjEkOrfJnIu1NXDLXG/PZp8hbjBRJg5YBqYEYcoPpe1L5cI5v5TXxa?=
 =?us-ascii?Q?ZCRCP4trLmNYzHQqGafqtC6JA1M47FW0xYFOIuNZNxxcMZXQcSc1tUeDPPuu?=
 =?us-ascii?Q?lT2VhF9+BWAD+cfG67tO/p9QNISFvjbgM5YsfJDh7yUUGPfAXDTbgKFhHRkn?=
 =?us-ascii?Q?dKh9fNqW9G818U6ofTMg2XE9X1BqdbN3RcIbFUSmcNKXBJm4zR/rpkbBf2Qq?=
 =?us-ascii?Q?jesCiyOqQWPPexSwkKGoKKecXRtSUGPYHZH20yXQQw1ApY85A4mcXeGVkalg?=
 =?us-ascii?Q?n9GXTlMrCoiXaQXqB1pWwz8YdnH4DCACLeWG7Tvk0OsEGPt81GQ+Cm6Cf+6+?=
 =?us-ascii?Q?y+Za7jqPh5nBJ7+qoThua93FPHHOoXymKm1Ck4IW7l4Y2m8ctYsTnW/dhrqz?=
 =?us-ascii?Q?IT6gUQmBEF2MNP4tjjPUJU2jxzpSzl2WYL+5DdWYi6WGO66hkCMOgJKqnjS9?=
 =?us-ascii?Q?ABSIrF54A3b4lfBLT3g=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2025 11:59:36.5562
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 81e433ee-6b73-4b59-6b51-08de2b50f084
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001C9.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5634

From: Ankit Agrawal <ankita@nvidia.com>

To make use of the huge pfnmap support and to support zap/remap
sequence, fault/huge_fault ops based mapping mechanism needs to
be implemented.

Currently nvgrace-gpu module relies on remap_pfn_range to do
the mapping during VM bootup. Replace it to instead rely on fault
and use vmf_insert_pfn to setup the mapping.

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/main.c | 50 +++++++++++++++++------------
 1 file changed, 30 insertions(+), 20 deletions(-)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index e346392b72f6..f74f3d8e1ebe 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -130,6 +130,32 @@ static void nvgrace_gpu_close_device(struct vfio_device *core_vdev)
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
+	scoped_guard(rwsem_read, &nvdev->core_device.memory_lock)
+		ret = vmf_insert_pfn(vmf->vma, vmf->address, pfn);
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
@@ -137,10 +163,8 @@ static int nvgrace_gpu_mmap(struct vfio_device *core_vdev,
 		container_of(core_vdev, struct nvgrace_gpu_pci_core_device,
 			     core_device.vdev);
 	struct mem_region *memregion;
-	unsigned long start_pfn;
 	u64 req_len, pgoff, end;
 	unsigned int index;
-	int ret = 0;
 
 	index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
 
@@ -157,7 +181,6 @@ static int nvgrace_gpu_mmap(struct vfio_device *core_vdev,
 		((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
 
 	if (check_sub_overflow(vma->vm_end, vma->vm_start, &req_len) ||
-	    check_add_overflow(PHYS_PFN(memregion->memphys), pgoff, &start_pfn) ||
 	    check_add_overflow(PFN_PHYS(pgoff), req_len, &end))
 		return -EOVERFLOW;
 
@@ -168,6 +191,8 @@ static int nvgrace_gpu_mmap(struct vfio_device *core_vdev,
 	if (end > memregion->memlength)
 		return -EINVAL;
 
+	vm_flags_set(vma, VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
+
 	/*
 	 * The carved out region of the device memory needs the NORMAL_NC
 	 * property. Communicate as such to the hypervisor.
@@ -184,23 +209,8 @@ static int nvgrace_gpu_mmap(struct vfio_device *core_vdev,
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


