Return-Path: <kvm+bounces-63506-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 4013DC680C8
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 08:47:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 0601B4EE056
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 07:45:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D91C23002C5;
	Tue, 18 Nov 2025 07:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FJM21Gx/"
X-Original-To: kvm@vger.kernel.org
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010061.outbound.protection.outlook.com [52.101.201.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4409A3019BD;
	Tue, 18 Nov 2025 07:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763451883; cv=fail; b=gysSn2u8N6rtNQ0cDAn/mED6AkQk4+rHwgcuwKNYGyWc2ijSHDVhzTFPRHfM6J9qVzb0EdEZBTLlKHZD13R/NlSdgUA4EPgZb3KKDMZquXud3QA5V0JiEQBH25nq3i9VrHv+eFCp7aury38IdUgGAsorm15WY1GvIud5P06YDKE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763451883; c=relaxed/simple;
	bh=g6AMwCLfc5a7zci494G1NRGy9JIzS0WNKYLoOLKUp1Q=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p0UlUg6B4PQrJiEAB0Al96yavolQ5N1SMdmmtyPC8CQZ1jHeB+k5i+lpPdokV05O6uIkPKlubTvIpnW+wnMl3KTDHyGxqRiX5KVS2q+R9S7/d+/i8APGoT/k75XROBjyfym9/s1Xzpj4m89RwdH9Lm0dKUjLtnThNt5k/GqF4YY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=FJM21Gx/; arc=fail smtp.client-ip=52.101.201.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PBcTcNily5LKo6w7ddu65lmqfRZBuOYSQFqUOo41A+UVHUzn9mn3cP6jka6f/fOj5mQuwCoEcn7Eytw5gxduF35v4YY99rAyFUATlzH/R07JdSaCAtITsRmoO0v9LfFvWcdGD811Sjm/Ok99wslb6VwfYymXC9RRug1Wuq9+EnT1G29TzrOxRoRhBNt9t+Riw759qYDX8+KkwIXAXIpdEHdnXrKQ7qQPqAWv47+iPXbgV44Do26l9IcqvLAbmHu4iH+HLqlCtCWCSi/oiq5CdLKnCeB1cNf8O++wdF0VRzmmJv+ak7M9bR4emoOgZkPcaKVJDiJ4p8mxSndp1nvhnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UX+yDiEszkqqKiQpnoloD7v6MJNEffQxbLbhM6vRI/U=;
 b=WSfyP1Lpf8CxYozjTnFjl1Gh8LkVOHfu8ozRd2SXNjfLGZSHQpMo+O7jAfA7oPnD9FWRKCSQ8dpWuMqvNLTKKybFsEHZhxub1HG4T6i32ao1Ta76AXvpljR5aqX8ycKCVaG7zr+GO9XvIQcj77vA1pXlNU+GVx/1Yix42KgcatYfa+dPOg3ts0wqgzRDWBPgMl66G6Q0IQ5NNCO54biZgpc7hjrM82WLAdDQfQuXOqdwe3jzd1VCoMFvbo3jS+Uwn3tNNVaK6lpckYr+czncTj32NEKQjxuHF9Ruurf5Bt9IPYx6vToc7eqkXdLqKMDTNIzy1GNCwqhEzrvYOhxEcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UX+yDiEszkqqKiQpnoloD7v6MJNEffQxbLbhM6vRI/U=;
 b=FJM21Gx/vzHQlQNW/Y5WncSPCkS/FhlADXpPGsIvuN1NppgJgOr7iZgqZa6K2zDJjj4FwIUbq7QsIupZhBnkHx2sUYP7gMcfSZ3LWAWRR2lpTA1FBVpUD9nGTuwnMB02RzFJo68s8SKkuNi+Lm/mzoEJbzRGtyKqczNuiK5wrgzuNHEyjHEX5XZYl95mK1G8DZLgRFJBVDCkcU6qlI0hPqCNO+A8i61kNIodKhOGZQzEnyo7Vvk/k6Qw3DSw/qE/vO78C8e0JWzoxD9872AjA43uoULgfXp8s2HBJst/cwX7ab1D2JLJ+xWTgCLPX2YOR9XAP5P/WdKeXEHY8r1sTg==
Received: from CH0P221CA0025.NAMP221.PROD.OUTLOOK.COM (2603:10b6:610:11d::9)
 by DS0PR12MB7654.namprd12.prod.outlook.com (2603:10b6:8:11d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.22; Tue, 18 Nov
 2025 07:44:38 +0000
Received: from CH1PEPF0000AD7A.namprd04.prod.outlook.com
 (2603:10b6:610:11d:cafe::f9) by CH0P221CA0025.outlook.office365.com
 (2603:10b6:610:11d::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.10 via Frontend Transport; Tue,
 18 Nov 2025 07:44:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH1PEPF0000AD7A.mail.protection.outlook.com (10.167.244.59) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.9 via Frontend Transport; Tue, 18 Nov 2025 07:44:38 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 17 Nov
 2025 23:44:24 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 17 Nov
 2025 23:44:23 -0800
Received: from
 gb-nvl-073-compute01.l16.internal032k18.bmc032b17.internal032f11.internal032huang.bmc032l04.bmc
 (10.127.8.11) by mail.nvidia.com (10.129.68.7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20 via Frontend Transport; Mon, 17 Nov 2025 23:44:23 -0800
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
Subject: [PATCH v2 1/6] vfio/nvgrace-gpu: Use faults to map device memory
Date: Tue, 18 Nov 2025 07:44:17 +0000
Message-ID: <20251118074422.58081-2-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251118074422.58081-1-ankita@nvidia.com>
References: <20251118074422.58081-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD7A:EE_|DS0PR12MB7654:EE_
X-MS-Office365-Filtering-Correlation-Id: f4d95be2-efd7-49fb-21cd-08de2676539f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?AvhwPtHqz5TMBv/OjrjG4WgFmR1S0aAaUEAhlZlUXG9mA6o2Sd957zf4exN9?=
 =?us-ascii?Q?7EOyY6xHdWh/JstqfpKwY2ldEUAZbfUbttcKJVvVoeyt67JiXs8Z/Zemsbht?=
 =?us-ascii?Q?Pf5LjKzV2JJrxv5WnsMy55sxzEWKUWdSgRb0EwyxUMI+x83p8eJlBWSjgzN2?=
 =?us-ascii?Q?XsgDwG7wUL7/iV1YdEUlfdZXHihEF3WmKAVzNGgLPMywHZC/3qN2GOWS6UQf?=
 =?us-ascii?Q?7+o22ZfYeX4fcjrkMf1ulNVRH1dKvHj4eiO3QLBtRNqXCcGqqYzNk5IZvvQa?=
 =?us-ascii?Q?i/XZ+XfcUGfQC+L7GTtjkpOlHkBcZXpziSBXUPz4jjgjajp6bniEFmB9kaGj?=
 =?us-ascii?Q?6Aq8e7OULdnq82UGXgH0StREQ+l5mK59qczdtrdLuPfUUr5CZhsyzoLps4oi?=
 =?us-ascii?Q?9TuEIwtRQq1MJD4Ck+Su2JOx4JfG03FXjPMPXFz/m3dhHwITYWYc1a5GOwnV?=
 =?us-ascii?Q?ApvTzbhZjlgeLBUS2TO7JW6LTkTR82XRpEL4r/Dkl2OL7N/aIszEyWPfh4ri?=
 =?us-ascii?Q?skaoAsQxRz8cfM6XJUFHVqfNJTDXdzQIR4aZOoznvfcYpEJs8EdhxHI9GDJm?=
 =?us-ascii?Q?/Ij8rbPpGHnk1Rip3r6tIys0KH3HhGKkOEP25ppn8bC0SkSvkKJErblhM5qN?=
 =?us-ascii?Q?JEtzIMkmDxHyHQeBpQ521PIQS+51Quo/6f04E81P1xViwQllaYRmSHTIhPsg?=
 =?us-ascii?Q?hbgjNSZtjwkME5Gh0kqfWTlpfozdtgmpvBEVQgfj1dlaQeagSfzMgHQu01On?=
 =?us-ascii?Q?1Xr0dsGSpzVmbLVGGFSS0fw+wrNYGDDMoPX37sq7z68b60lQa+bKDSfik1Mh?=
 =?us-ascii?Q?o5+48diw0hzCenKINZw23+11ZLVllPM8hLee32ZaJ8fwSgmGDHeg+Gy8CPTX?=
 =?us-ascii?Q?hZMXVuw0yWKnOrZOUpiJfEKjXdt+s3irxoGWsMefbMBSJaO+91lgn8TRkqKs?=
 =?us-ascii?Q?tA3dLZmDKjfJw/OLsOlypJu1x2AJdaM9pLJuemIW9ZyKYNgVER9Q4FoObUKe?=
 =?us-ascii?Q?FnC2L/Nc/RF6A34vul9zO2c0VTtgY2DWNLtwlHlVOvqwD/3tovA42j6ng9gr?=
 =?us-ascii?Q?RzZVS+6ymbiFQzZhg3r8FPtJQSyoNoQndos2AguY8NuFBiPqOiD3OypcQpbT?=
 =?us-ascii?Q?U2dBAP31R+cqa6PkP39JBn1AZBY/HVV8NlO/r8Fy1qMbOwTqFJGUZpWVB5p2?=
 =?us-ascii?Q?2tgjHLCq6WWQ5mEqstREk7po9VsXvjkh8p56BeOM4jk2nReHlpFYLES93mE4?=
 =?us-ascii?Q?t/X1ZO0F+yuMO92fu+oLEZEIopON9RxOpBGZpSWXoCxXD5FAlw4Wyd3LXPrZ?=
 =?us-ascii?Q?YL3rHKvBchHCJAym5ZpAnhELHOwxUUUYk6oOlk1y3en79mXOmfoRPH6YjW5J?=
 =?us-ascii?Q?O6aLb08eR+n9LmAFyLyVDHvhAekrKW02Njr2Lztlb7o4cJg+MbVVaTYu49qi?=
 =?us-ascii?Q?BU+3JjmxIfMdAeXf+7CuA8cRl50rCWp3RebNpk2CeRQ3Lgtdrx3EsLfxrnSC?=
 =?us-ascii?Q?n7HdcCKA0BQ9OXoGeYOLI51LZx3GqJKlY/eDN+mhpPmk+JQn6eXXrieX6ggA?=
 =?us-ascii?Q?ipNnFCHOk9GViPHgu84=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2025 07:44:38.2576
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f4d95be2-efd7-49fb-21cd-08de2676539f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD7A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7654

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


