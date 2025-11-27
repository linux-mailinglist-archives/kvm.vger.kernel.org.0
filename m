Return-Path: <kvm+bounces-64896-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id AB094C8F96B
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 18:07:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 61D584E28B4
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 17:07:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DB372DF714;
	Thu, 27 Nov 2025 17:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="npoCaVJG"
X-Original-To: kvm@vger.kernel.org
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010013.outbound.protection.outlook.com [52.101.61.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 824252DF133;
	Thu, 27 Nov 2025 17:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764263215; cv=fail; b=BkSP0rV8IydXTr3+RtHhEdcrnbbH/Sfb2OL60hiaLk3RnAGwnjn7q7QNo4n+/4QrG0N6kgICYog4gIUWtePUZdH1qmh5UTbfmmvQMB+AY/nOD7pHgsWhEbbOLxfpPlSci5V4gNg5Mb+e2Byb2GeBWii4j1d/pl6oduweBp4PK+o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764263215; c=relaxed/simple;
	bh=NtMsuIiM8kqiPGp8Vygxu2T1ZwHJTKO1NFBMU6kqAX8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZJq9UKE/jNCrugL4IjEOplE6PPlQfYSchTj0BGPVcBzAS2Ea5G/T3mvayD0R7vXa9yBJ97S+D3/uQ9qlIyF8XPFWtz9h3X7qN72ZWzD5bbqDViNh+oxt/6KuHXCRlVyPthXObEzMwlbtdsWl4hb2Ht9re/qe51G/Aw1fEoCLOf8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=npoCaVJG; arc=fail smtp.client-ip=52.101.61.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vsltoL9AqYHDHUdEWhb8cBQftvi2yQGdW6D3HhacC/oVZFiu31I50npAOr063keNdcqhrKllOa676i96pdIaRJkwmo/nC/ObmP3WDBADnMGE+2bDWDx0d1uOnxjJ50ZoyaQn556Dp34/gmcrmYwXJIPPNcMQGHBsii2aSTYL2KA/aADXWaDWoVQpiH24g0VJf7XZponueAjicusKxtS3p8iZVEZEfCROpGGzDGVI0auR6PWsovGf+xAeVEa1Jw7BAprZsSx7qrOsaUeiepZXN04bGbekNpzk9qhCToKAw9e8fIvHpZp/QVgX6gom8ac3hkN9VSnSS+uSYJhXx7XozA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gGaeENjNlXOV+TGhPkmZmF5Yv8c8BnTqUs0AgpOIu68=;
 b=Dw4U8ta+AHjfJeOYZZRP69DfEGi2ngjqLntnMU6pntBJnAnmPXdjFZWEME3J5yqPGmxXGBxpmyWbH1LNkgTV/xQ+HAPtUILGC33mALUg33GEPZKwdoOX1OeHuo7hjwLltXCxeg6yIGgg5vybTd4fH7OMts4q5iQXkM0C0PR04ds3GVbnaUXYjplpcZY0R0LfiqX20LIkGaaxcWMQLtXdgr8qRAxBAv8+b3OAWjAYWodc0F9mPZmO1NQ5jrqfkXIA91nbC7adxODlvPQW7wtb2KwEdFvUagZYQGlsKYiHtiV/KCM7tyhOltBMtm+lGQZhkwbwBdXOKGbwoFynX7z7Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gGaeENjNlXOV+TGhPkmZmF5Yv8c8BnTqUs0AgpOIu68=;
 b=npoCaVJG6a+4hf9APTUf8G9hqeEoDwKLJ78QldiG6pUCsNzG6+83jkOszICMJZ2tKgA0kUqfrvg8axoRyGYR2+pSQVxnQEsUPIkz9y2ITDc8gijO7nI3UQY3DCkuP27Citot90wUM87RucAXtKSFGH6UuuCfpIxczJOXvoWsv/1Ar7nQ6/4Vz0PuMN1OxIYrFeGq29Lf3U9/AclgnoGqy4iEmYii90lA+dF10UTUt40y7gklbxYKOfa1K6dBc7348JqnvGDsDlMEDMRhl5PN+xLP9kgXX1nH1bBIJyGbGiOF8g+OGbXBgrfhQh4nmxakXgts1IbbfAtgxVWAuiE7bA==
Received: from SN6PR2101CA0026.namprd21.prod.outlook.com
 (2603:10b6:805:106::36) by SJ0PR12MB6967.namprd12.prod.outlook.com
 (2603:10b6:a03:44b::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.16; Thu, 27 Nov
 2025 17:06:48 +0000
Received: from SA2PEPF00003F63.namprd04.prod.outlook.com
 (2603:10b6:805:106:cafe::99) by SN6PR2101CA0026.outlook.office365.com
 (2603:10b6:805:106::36) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9388.5 via Frontend Transport; Thu,
 27 Nov 2025 17:06:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SA2PEPF00003F63.mail.protection.outlook.com (10.167.248.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.7 via Frontend Transport; Thu, 27 Nov 2025 17:06:47 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 27 Nov
 2025 09:06:33 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 27 Nov
 2025 09:06:32 -0800
Received: from
 gb-nvl-073-compute01.l16.internal032k18.bmc032b17.internal032f11.internal032huang.bmc032l04.bmc
 (10.127.8.11) by mail.nvidia.com (10.129.68.7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20 via Frontend Transport; Thu, 27 Nov 2025 09:06:32 -0800
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
Subject: [PATCH v9 0/6] vfio/nvgrace-gpu: Support huge PFNMAP and wait for GPU ready post reset
Date: Thu, 27 Nov 2025 17:06:26 +0000
Message-ID: <20251127170632.3477-1-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F63:EE_|SJ0PR12MB6967:EE_
X-MS-Office365-Filtering-Correlation-Id: 333329d2-8965-40ab-9d6e-08de2dd759af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700013|1800799024|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pLE8cJAStgvO9bXo/mahgvjhAWZBnuQzWwpRptJ9SReAQYBzafFre3r8ZGT/?=
 =?us-ascii?Q?+X9avZfjL8GxiRSZSvffX3IZs4rPUlHBeaQaFFieH5HhF6hKKCR2yGls8c3z?=
 =?us-ascii?Q?YzUEAuQSLDh7wdye31jCEcrv0C2ozRF9I8XcX3r1zZuAhTAGCyiyU0EUEtE0?=
 =?us-ascii?Q?4uugZ3sD0Iiu6pWT5nzNSN/dirujgBbiSrZFttWfy9/jtzNxHAiweiHyy1Y+?=
 =?us-ascii?Q?s8lmCp0cBMbwGoLPdJTNNHDxk+GSta+FpBdk2UXCPIMc2oUqB+0+p1dlV826?=
 =?us-ascii?Q?9lF0YGkh2O/sJ1HqELu2S4kOCDrUadtbZ+NDMhIuw7OEGdmiFv7QFEGwS3jX?=
 =?us-ascii?Q?MQhoGfMOzHEQxqiIPKlyh/Ki8VawXWkPouFi1yrqXqLX9ssXlPoxjFCivjLi?=
 =?us-ascii?Q?hEd5+YwP3j0UJIMPy5AEvx3fs+KWahfhozvNfGboqb72BPf9bM77DLipVlSV?=
 =?us-ascii?Q?ROUTnhLkyHqNpfM9p21D9npTiyCWIbsJ5KaoHRBrqX2fBVVJvmkmQ2uEWHoU?=
 =?us-ascii?Q?Lekj4ZJ/0LKNdcmz7Yw+DF0rlsQ0xuIFcJS1LW8P7nYpjeGjyqSZ2oYfbGFh?=
 =?us-ascii?Q?FTc/DSsAOT3zYg1FJ5jXgfMP0fz/OI43fGmRgnACurg5zFij+MMaxa2z5aWR?=
 =?us-ascii?Q?fs8TLdhTAS5yKzRGxHFLUbZbMVht3ixE8kZIPDyj8l4fH3EOc90j0kvNOwv2?=
 =?us-ascii?Q?drsoXFLLvOwbEzHFQx6umz5c0KcdYBNH72QlP4VVMI2wuEFwycJLNpy79/mp?=
 =?us-ascii?Q?eSLiAVblHlekGYmj3J8dWZeGcS6mG8x5kLbDCaex56ik2p1fT/EB5A1MLvb2?=
 =?us-ascii?Q?c8y+BymQdVv9aEo/bbYtbZVnmY3d1BcrTT4jDPqWHxc3CrnWwIc/NL17NiX5?=
 =?us-ascii?Q?FXXEHPOOLlw1RFSwmdONiJem7sBC1JGfqvGyBsfOOaqITQZ1KPeAhbNOJubU?=
 =?us-ascii?Q?oUvT1cRAOXfwwMxGTyWgLUjT4IfXLs64/zyq24QcazEnfvskRm5DA0D78WHk?=
 =?us-ascii?Q?FDOETJzOVJupXlq6df3SLcBEyRfoybKyjpGgVXiT2KceCe3c++XN962QY6Vi?=
 =?us-ascii?Q?z6k1C9Gg5YyJjEh0vJ4wQn0hscboSdP2oovV3MYksUk5dOyx83VZHuTR3y8R?=
 =?us-ascii?Q?Z8Zyvz3HM0F+bum0kssVxjT/yEDqKR76pka9zwyVE4aY+j5GoMZLAM89CiAL?=
 =?us-ascii?Q?57QnkQQXT3KLnxTtjali6NAERqGRMEyDylQe0qTD44msAlRAFyfvElrFp1l+?=
 =?us-ascii?Q?ctTNs8MLrsIr798dF/BIp9cAnVhhYZgqXstCa2OF1s29J5phCvPt0v7msfSE?=
 =?us-ascii?Q?pR88Pf+YSLgX+DOfDZaAS4bpb62c5p0mWfYX6HQsXb2+S8CBcqHt2/8SByCq?=
 =?us-ascii?Q?zRjR27FL/ZenWIpFEjYsYb3OCB2uSMSXBEn0vRJF30o/1eh2NW4Mc59n4wxm?=
 =?us-ascii?Q?pVectzUMs8nX4pSp5LyraFeDcPdnUbFHmTAGT7Vppn33j6jJ/8OkS7OErLIR?=
 =?us-ascii?Q?ON/etsYSYImaiCCnIN/kzxJNslUrw1mMEYXx2HGlmDfJIsQLpzfh7DGrjNDz?=
 =?us-ascii?Q?iDJrnKzwGKxRYR4C+xQ=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700013)(1800799024)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2025 17:06:47.7667
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 333329d2-8965-40ab-9d6e-08de2dd759af
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F63.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6967

From: Ankit Agrawal <ankita@nvidia.com>

NVIDIA's Grace based system have large GPU device memory. The device
memory is mapped as VM_PFNMAP in the VMM VMA. The nvgrace-gpu
module could make use of the huge PFNMAP support added in mm [1].

To achieve this, nvgrace-gpu module is updated to implement huge_fault ops.
The implementation establishes mapping according to the order request.
Note that if the PFN or the VMA address is unaligned to the order, the
mapping fallbacks to the PTE level.

Secondly, it is expected that the mapping not be re-established until
the GPU is ready post reset. Presence of the mappings during that time
could potentially leads to harmless corrected RAS events to be logged if
the CPU attempts to do speculative reads on the GPU memory on the Grace
systems.

It can take several seconds for the GPU to be ready. So it is desirable
that the time overlaps as much of the VM startup as possible to reduce
impact on the VM bootup time. The GPU readiness state is thus checked
on the first fault/huge_fault request which amortizes the GPU readiness
time. The GPU readiness is checked through BAR0 registers as is done
at the device probe.

Patch 1 Refactor vfio_pci_mmap_huge_fault and export the code to map
at the various levels.

Patch 2 implements support for huge pfnmap.

Patch 3 vfio_pci_core_mmap cleanup.

Patch 4 split the code to check the device readiness.

Patch 5 reset_done handler implementation

Patch 6 Ensures that the GPU is ready before re-establishing the mapping
after reset.

Applied over 6.18-rc6.

Link: https://lore.kernel.org/all/20240826204353.2228736-1-peterx@redhat.com/ [1]

Changelog:
[v9]
- Check if the memory is enabled before waiting for GPU to be ready in 6/6.
  (Thanks Alex Williamson)
- Added power management handling in 6/6.
  (Thanks Alex Williamson)
otherwise the readiness check would block for 30s.
Link: https://lore.kernel.org/all/20251126192846.43253-1-ankita@nvidia.com/ [v8]
- Fix bug to vfio_pci_core_disable on error path in 6/6
  (Thanks Shameer Kolothum)
- Code cleanup the huge_fault functions in 1/6, 2/6, 4/6, 6/6
  (Thanks Alex Williamson)
- Commit message fix in 5/6, 6/6 (Thanks Alex Williamson)
- Collected Reviewed-by. (Thanks Shameer Kolothum)
Link: https://lore.kernel.org/all/20251126052627.43335-1-ankita@nvidia.com/ [v7]
- Code cleanup to use ALIGN functions and move the mapping sanity check
  to the vfio header file. (Thanks Alex Williamson, Zhi Wang)
- Added comments for reset_done implementation. (Thanks Alex Williamson)
- Collected Reviewed-by. (Thanks Zhi Wang)
- Miscellaneous cleanup (Thanks Alex Williamson, Zhi Wang)
Link: https://lore.kernel.org/all/20251125173013.39511-1-ankita@nvidia.com/ [v6]
- Updated the vfio_pci_vmf_insert_pfn function to add more common code.
  (Thanks Shameer Kolothum)
- Added missing userspace offset for pgoff calculation for huge pfnmap.
  (Thanks Shameer Kolothum)
- Removed alignment for GPU memory. (Thanks Jason Gunthorpe)
- Collected Reviewed-by. (Thanks Shameer Kolothum)
- Miscellaneous cleanup, log messages fixup
  (Thanks Alex Williamson, Jason Gunthorpe, Shameer Kolothum)
Link: https://lore.kernel.org/all/20251124115926.119027-1-ankita@nvidia.com/ [v5]
- Updated gpu_mem_mapped with reset_done flag for clearer semantics. (6/7)
  (Thanks Alex Williamson)
- Renamed vfio_pci_map_pfn to vfio_pci_vmf_insert_pfn. (2/7)
  (Thanks Alex Williamson)
- Updated to hold memory_lock across the vmf_insert_pfn and the
  read/write access of the device. (7/7) (Thanks Alex Williamson)
- Used scoped_guard to simplify critical region. (1/7, 7/7)
[v4]
- Implemented reset_done handler to set gpu_mem_mapped flag. Cleaned up
  FLR detection path (Thanks Alex Williamson)
- Moved the premap check of the device readiness to a new function.
  Added locking to avoid races. (Thanks Alex Williamson)
- vfio_pci_core_mmap cleanup.
- Added ioremap to BAR0 during open.
Link: https://lore.kernel.org/all/20251121141141.3175-1-ankita@nvidia.com/ [v3]
- Moved the code for BAR mapping to a separate function.
- Added BAR0 mapping during open. Ensures BAR0 is mapped when registers
  are checked. (Thanks Alex Williamson, Jason Gunthorpe for suggestion)
- Added check for GPU readiness on nvgrace_gpu_map_device_mem. (Thanks
  Alex Williamson for the suggestion.
Link: https://lore.kernel.org/all/20251118074422.58081-1-ankita@nvidia.com/ [v2]
- Fixed build kernel warning
- subject text changes
- Rebased to 6.18-rc6.
Link: https://lore.kernel.org/all/20251117124159.3560-1-ankita@nvidia.com/ [v1]

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>

Ankit Agrawal (6):
  vfio: refactor vfio_pci_mmap_huge_fault function
  vfio/nvgrace-gpu: Add support for huge pfnmap
  vfio: use vfio_pci_core_setup_barmap to map bar in mmap
  vfio/nvgrace-gpu: split the code to wait for GPU ready
  vfio/nvgrace-gpu: Inform devmem unmapped after reset
  vfio/nvgrace-gpu: wait for the GPU mem to be ready

 drivers/vfio/pci/nvgrace-gpu/main.c | 237 ++++++++++++++++++++++------
 drivers/vfio/pci/vfio_pci_config.c  |   1 +
 drivers/vfio/pci/vfio_pci_core.c    |  69 ++++----
 drivers/vfio/pci/vfio_pci_priv.h    |   1 -
 include/linux/vfio_pci_core.h       |  14 ++
 5 files changed, 236 insertions(+), 86 deletions(-)

-- 
2.34.1


