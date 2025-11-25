Return-Path: <kvm+bounces-64523-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 23217C86351
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 18:30:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id DAB3D4E1D16
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 17:30:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC935329E7A;
	Tue, 25 Nov 2025 17:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="noqIMp7m"
X-Original-To: kvm@vger.kernel.org
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011069.outbound.protection.outlook.com [40.107.208.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36AF22C181;
	Tue, 25 Nov 2025 17:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764091842; cv=fail; b=fcq4HmESnd7ho0b730WL8R18wRujinXLEWdTNsxfx8Kuo7XduUh4TomTcFTxX2f3ZOm8bxNt6RnLoi70fQNOwBGZBC0ireMsT/s1Cyzspc18/DJ3I9ULKIMRK6pHTXHcv9uMainAukLSapVyithkkWS1kdNLkaiJzFZd+896MXw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764091842; c=relaxed/simple;
	bh=D3trObincoQ6lvbH6A9SDjqeQe06sgwaN70iYvhfqm4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=bq8NaY4+Gde0nFihKqdA6Yl5nVvhd9XDp5CVM1yGNf1LyAI+SybLPTVg9mx0N4ok6ckzF5JrL8AcpkTqg9geXnNvUGpzHlHFz95dnTZ0tW8gZvdMUzB08PNmcvjmSy/NkcfKR9AuIalyoU/Hs/oXH3iBVORHuTAxQefrAUGhboY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=noqIMp7m; arc=fail smtp.client-ip=40.107.208.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nL4SDFHNHihwDI85OT6dYT6n8rdKZyjweJF47Qg53/4k39Cj5NGGl4HmktUIpiI7VNeU63sS+3ztli8TlLrILBHsQ1PxMkv6sNdHC9KgsGobg604cnvhp6vjvUjh1JdSMFITGeKZHoyEtB2f3Dz7d6KgnmTY9V5BtmXTaJexFn8R0FTZ9jlxSoEjXipa4FCaPH4vwfscNG0gGDSsQayscgQG+TPCuUlQw174DqjUA4lSlfB29cf3ueAOM3aCqLiXqRCZSQh09G6BwCVXDRKlGMulsHMkuPvkOu4QHbHVReoPCeyNI/Rej6aTeL/yHuoQG4fgqGspcf2yN1cpAvcPZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NCQT4W3ODkLhUgdn/JAkOzItW99geH/9l6MkwMBKljc=;
 b=AdIxIXnUAO1iVyOVZa90WlDvSfZgyOOogAzQRpXtQoP3f4y2ZcUWuUX34Fg7OyVcZVgfv5BeC9wf4IE6DjahwdmwnfnG22mcmVpTq6kRqzpcQwvWnpVpglMiEu7lb2ZCvL6OeebYwBaQzGheJhpkJ2z6NwmLg5KVvTXM5rO4Zix2s2Kq8eeWHQ+QtKrX8EP0XMDY8+BscSmY5K9C1leiUcXW36u2EH1OdmOct9APNn1XsVRDGK3vsh7NkdsDv4QoZ5/5viCgSqGrzwrHHDWQVDOB/qifYnsBdIUoPdeRlpuvDyUoukqN8jCCKJcODvDTp42rwCtbD8rZjG4GxuppLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NCQT4W3ODkLhUgdn/JAkOzItW99geH/9l6MkwMBKljc=;
 b=noqIMp7m9UywqkF80+qASfOYhoQ6S9Ld1ApNSttpTtdvVGJbjuf1nE7BOff6DYk6vWF9hK5dMHDYhrwVzG6M7Z2eNnUm2s0cq1meNrrRhT3r5FArtzy7ACZvips4Y0xfOp6+mzqkaj75m3mXy3sGEgv4CY62JlcK3vsaNh010XrK0irkr28BPR3VwvQT3QstgnH5iV5L3npyygteluKF4Q9MIRxvOHfhf+4iRAER1oELupxwvYj8QSLfOj0fTxmlFvVJIsYn6LEhvp3dHs9XH5tyO4m5LJOWISylPgCDngqszQu5uY8f3QE6wtcWoPtzkIHsRUPiymoN+szL7XuNcw==
Received: from BN9PR03CA0954.namprd03.prod.outlook.com (2603:10b6:408:108::29)
 by PH7PR12MB8039.namprd12.prod.outlook.com (2603:10b6:510:26a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.11; Tue, 25 Nov
 2025 17:30:38 +0000
Received: from BN3PEPF0000B074.namprd04.prod.outlook.com
 (2603:10b6:408:108:cafe::79) by BN9PR03CA0954.outlook.office365.com
 (2603:10b6:408:108::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9320.18 via Frontend Transport; Tue,
 25 Nov 2025 17:30:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN3PEPF0000B074.mail.protection.outlook.com (10.167.243.119) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.7 via Frontend Transport; Tue, 25 Nov 2025 17:30:37 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 25 Nov
 2025 09:30:13 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Tue, 25 Nov 2025 09:30:13 -0800
Received: from
 gb-nvl-073-compute01.l16.internal032k18.bmc032b17.internal032f11.internal032huang.bmc032l04.bmc
 (10.127.8.11) by mail.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20 via Frontend Transport; Tue, 25 Nov 2025 09:30:13 -0800
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
Subject: [PATCH v6 0/6] vfio/nvgrace-gpu: Support huge PFNMAP and wait for GPU ready post reset
Date: Tue, 25 Nov 2025 17:30:07 +0000
Message-ID: <20251125173013.39511-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B074:EE_|PH7PR12MB8039:EE_
X-MS-Office365-Filtering-Correlation-Id: 35139ed2-733e-4a0d-9163-08de2c485926
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?iL16Q9oEd1+7LOWMrn6IG9y+F2xuQ2XeBhHEYfCN8Iy+lbL3d3udNMMKnVTB?=
 =?us-ascii?Q?DJBZ5QFX7OImsYh7jaTT32hgPhQa5wGMP/HsuHyGNkWRg2Mo8Pcl+Xr0kGmJ?=
 =?us-ascii?Q?vCHO/B9sqlPQh+dxTcJBqYbcK1rQABapD8/ca7WQDe98MV4Ec9G/7j81ayQW?=
 =?us-ascii?Q?8FZFvWfzECCm0cpp6E8S9gm3GmgpqvtzOjXbKpTQfo5UFhWHef8fUE/hFoFf?=
 =?us-ascii?Q?h/VDzvRoELoozwZR9xUtkPALj7c2xZ7UnNEbYfy2eGAj8PHqNX3d6z9mKQ79?=
 =?us-ascii?Q?lnK0mToHEa7PRxjc3d2o8ktaFGKPN8WHFlurKFXYMaNgGteRpaSPDpz6LGVl?=
 =?us-ascii?Q?WjZM5vDaPRfwon3rXhcCp7gFAqHMIQFaw5YvPgH3KjM0P2RBvdOIzejkIc5F?=
 =?us-ascii?Q?QZXEqLnfqjCRmtsNWUAqb/wTpJvAwUw6seSEKmm91OM6Z9Xy2S4eRWI46xO/?=
 =?us-ascii?Q?Vf4cURYq9MDfUxWOlTD7CH1DULVjg2GiZj+ydR52hGqEZSb9KEZbA6JNpXE9?=
 =?us-ascii?Q?klJy0bQEv7Uk/irjI0nB6poHyyiXtzq5uyBQrpeEFYx5nPi/U+pUSmfPWPqn?=
 =?us-ascii?Q?+c99e4GK0NW9lcMlQMjElS0HtrH4XpH8r0KfzbwbYFE1I/6hKIvr50IlRLbF?=
 =?us-ascii?Q?EXE6WJNasz4rik0p2kbg/4L3j8NbFvT+d35r88HsoCcirbl3Nz9HmxZQfOs9?=
 =?us-ascii?Q?RSrgxML4htxqzdE2tc3V0gzaOt3q+49huXQrwgEhi2lCCTtRlrotGp/tnw+v?=
 =?us-ascii?Q?k6wj9kAzosLQH8Xmd8/XwygK7k5qpk6Wqv4+RI0lL06LYiDIO0sz67M9dULa?=
 =?us-ascii?Q?fgbhp5CWJ1oCnfUqyaY6KBd20jFYDPMssgFdrnRYIjlwCG10lTWDG5sHvvor?=
 =?us-ascii?Q?Wf+tjOEA8KIpzgjP8IStDhDOHlzf4BI+UnlC28E4rIpJX4boG8KqRTjPaunQ?=
 =?us-ascii?Q?xVyLPjOeezfBp3z1jXS7etjggtxl5g/po0wPilhOSxE2j56RA1Ic/8lKRXlO?=
 =?us-ascii?Q?hAZ/4rMhvesW9JkvZeOtxZgRaBWb4djO14i8U1crAmi5d/lltCJve0gL3ktf?=
 =?us-ascii?Q?/fxingVEydsbmRG+wwEviD0bkY+De55RYNjK++WjbTVf6NZT6rMqvatB7SVH?=
 =?us-ascii?Q?O+5bdKuR5OuK0zmdSI4/UnEQUTBzsdIUQ6OAJZcnppu0j82Z5mcp6QDn+fF5?=
 =?us-ascii?Q?os/wao8h2CcwMT9ph8CO+fGcit+znXz0y9iKaxpILPeysNq6DMgjEZTUFw38?=
 =?us-ascii?Q?QJe6UCDTns5JcICwM//arCaaXysCtTUhUM7wMrsuVI0oSki3x8nMmJ3tVEMv?=
 =?us-ascii?Q?XGLSAr5saCax+/e3n6RYCt9YfPs7pGM3qdc8sAmsxxSc/Dob3lkfb3x1OVEX?=
 =?us-ascii?Q?LlpoSCqN41MrK0kByIL4wYOyWy5U4EVl0fPqmjLLzXqfyAA4TiBb1w7K3XbQ?=
 =?us-ascii?Q?KJb7BV8tNIu1WtUOaU905KhqX17LFbCqFY52bdMSDyoCI8lZJGAfU1Tf8IUz?=
 =?us-ascii?Q?hAM3wvO+I0eQIBlatuMJGLAnaCHmHwxxtjHzOQygZlSMafQEzoqIsZmB7eyF?=
 =?us-ascii?Q?yAyXulVHpBDPsTk6PcQXVWwM0DgJNE4eSk4qgq9q?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2025 17:30:37.6486
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 35139ed2-733e-4a0d-9163-08de2c485926
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B074.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8039

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

Patch 1 splits the code to map at the various levels.

Patch 2 implements support for huge pfnmap.

Patch 3 vfio_pci_core_mmap cleanup.

Patch 4 split the code to check the device readiness.

Patch 5 reset_done handler implementation

Patch 6 Ensures that the GPU is ready before re-establishing the mapping
after reset.

Applied over 6.18-rc6.

Link: https://lore.kernel.org/all/20240826204353.2228736-1-peterx@redhat.com/ [1]

Changelog:
v6:
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
  vfio: export function to map the VMA
  vfio/nvgrace-gpu: Add support for huge pfnmap
  vfio: use vfio_pci_core_setup_barmap to map bar in mmap
  vfio/nvgrace-gpu: split the code to wait for GPU ready
  vfio/nvgrace-gpu: Inform devmem unmapped after reset
  vfio/nvgrace-gpu: wait for the GPU mem to be ready

 drivers/vfio/pci/nvgrace-gpu/main.c | 196 ++++++++++++++++++++++------
 drivers/vfio/pci/vfio_pci_core.c    |  65 ++++-----
 include/linux/vfio_pci_core.h       |   3 +
 3 files changed, 192 insertions(+), 72 deletions(-)

-- 
2.34.1


