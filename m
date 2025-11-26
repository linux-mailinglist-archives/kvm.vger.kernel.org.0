Return-Path: <kvm+bounces-64598-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E5B6C88249
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 06:26:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id BE1673523A3
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 05:26:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39923314D02;
	Wed, 26 Nov 2025 05:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YVtFH3DJ"
X-Original-To: kvm@vger.kernel.org
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010034.outbound.protection.outlook.com [52.101.46.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B2084C9D;
	Wed, 26 Nov 2025 05:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.34
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764134801; cv=fail; b=iTOFXY1jvHR35rkdfSlAesm9YguzfjatSJvchHyEVZhQcj28E4nzcf9cqH0uGxUnsIz4zagDGI3BKjTNPIG/Ld/1Lw2YXDNMOXdJdPf9/dP3xGSZ6cpb7KS17xeAlP5cRwC6UHYutSXgsmPXM5JT7XcOKt79nLbSe4fS04H3z6A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764134801; c=relaxed/simple;
	bh=rzwvQN3pmkjB0bYYVBUPLQAwnKeg2eOCDZpS0Q8uDnw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZYsMljTH4hiHWovH+Mq9ZdSUGV4xBccjgSSiTqrhJXBBmYtWhMaMdEvay8m+CEOaqk2K5z4LdWz/vQKqYjKl+h5fy6F5XDrya4+LBvORENcLKuzAgiykudy/ALiPF1OcN8VTGWBFa2z4IP+U2tN+7+2cx2MT62ckVwI3tERan3A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YVtFH3DJ; arc=fail smtp.client-ip=52.101.46.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cpgquzKnm8A54s2xUKKg5m00oPzJTfwQeURBN7x90AKCxReEf0T6cbhWuTL4zsaHBIf/AWR+RrHk7XiB015hc5k2kgK3rVlJwTXkhjMQZzfCJ4Ipv4j1eKmE+IJQjgVAHiCg+pWRITQiUkAtT4RS/xuXNodyDD7O3GQc+Ju6YHH6jsq3q5pjR3bObZ8sXCEOP7AeqCNUroptipat2wL68nc3Qoa95+a+VxEmf1TMoek8ZaRcSKKlAbiuPiQEJfzaJAGF+Gmx1GG7zprUu6j32K4HB5GecEz413g63axuMYY3v4Adx1fbKedzHr7cmXSVGJWvLju66JdTLZx1+Ac0ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AWbSukDNLArOvrEN6rIeXAMx6z19BmKf2QyVbG98W5k=;
 b=QgRG2KcQU8bwlzeQIfmONOIH184hEp4bEUp2VJBR5ZBIWF4KA/vPbCOaZj2cV+fDyU1UXx5RiUX+XJf6xh3uqDOvfHW3HJ834m+Y1oAoXizYDgBzhKqJx71/q5UllcXMcBpXoCG3MgyjpSUM8ex3hOM1Z5Tjz2tGFyZ53xV+lup5xTXCIK7/GvNHDHqGVxvE5S2N0l74NHFeUM1nZrDnIoeAkaG2TTLIW1NKpaotO1lSPBqm2nrrGLtq+PPJ5bgtE6TJCTprB7SJogWQOByHXvckr8+QhA4qEqpaP+oxYB11Kt9c9zyJi5Puz+rMbKifVFZjmDl8QmioXX5jCx7jRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AWbSukDNLArOvrEN6rIeXAMx6z19BmKf2QyVbG98W5k=;
 b=YVtFH3DJDtZ+dxn4+fHT6IVQrlfse+k7nFIPTNvb2jsAe7umsj/CEMX2iwI/SWwh/upibZKLtkF+WoHCz29TwV8WjNpPoAmSGwnIv9cBqXUQd3xrphT364Q5v/QVNZPaVdfox1uG9VzMZxR0cWeCU++MqcwsNGJjabsAeo9XCRvfUa7VEGrX/Ymq/nscXItirjIpEGWFxniIzp5TnvZeznZGBDoOFKiXqSrQvuvpgJvm9+CwnwWDJgpWXZM/KreVivXp89HRD4qMDUJwCzfEdcP+s038f6lKkLsjXXv4Wt2ZbMDkJCeXan9a9z5Q/gKFVbFnAwnnhADYqWIgwzHeeA==
Received: from BY5PR16CA0006.namprd16.prod.outlook.com (2603:10b6:a03:1a0::19)
 by PH8PR12MB6889.namprd12.prod.outlook.com (2603:10b6:510:1c9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Wed, 26 Nov
 2025 05:26:35 +0000
Received: from BY1PEPF0001AE1B.namprd04.prod.outlook.com
 (2603:10b6:a03:1a0:cafe::1f) by BY5PR16CA0006.outlook.office365.com
 (2603:10b6:a03:1a0::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9366.12 via Frontend Transport; Wed,
 26 Nov 2025 05:26:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BY1PEPF0001AE1B.mail.protection.outlook.com (10.167.242.103) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.7 via Frontend Transport; Wed, 26 Nov 2025 05:26:35 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 25 Nov
 2025 21:26:27 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Tue, 25 Nov 2025 21:26:27 -0800
Received: from
 gb-nvl-073-compute01.l16.internal032k18.bmc032b17.internal032f11.internal032huang.bmc032l04.bmc
 (10.127.8.11) by mail.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20 via Frontend Transport; Tue, 25 Nov 2025 21:26:27 -0800
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
Subject: [PATCH v7 0/6] vfio/nvgrace-gpu: Support huge PFNMAP and wait for GPU ready post reset
Date: Wed, 26 Nov 2025 05:26:21 +0000
Message-ID: <20251126052627.43335-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BY1PEPF0001AE1B:EE_|PH8PR12MB6889:EE_
X-MS-Office365-Filtering-Correlation-Id: aaed18dc-de76-4879-fc2b-08de2cac5de1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|82310400026|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LU3kYMLxtg0P3eakflT1WRHXN0s4UipLz0fVNjoMoHAABofLN3SYRldV75Lk?=
 =?us-ascii?Q?uqn3xR1hDKJAuW5DLpYnkYogReu1NjxP751RhVUBYmGI0mTlyRyiq3L4uYHm?=
 =?us-ascii?Q?yXWvJbNLa9PVBrRIZfpcU51BCfp4BFCtM98ZncGfJZXWGE5pNeDMrmVZ+p6B?=
 =?us-ascii?Q?o8DUA4EiAyT3wCgW+Y103qeAB1A4I1DHykt5C2GyNis/jTm4MmPMGs5J4MYK?=
 =?us-ascii?Q?5S8ApveIYwCR7L2Hew/4DamCFYG2AyR/vy9REpe07m9ubFpCBlALBnqDJtAp?=
 =?us-ascii?Q?B5mCKDkQahixRw8Q/3eDBf5PIDhXe+NcI4l85C7b783NEg//eFrlDBR3DEu/?=
 =?us-ascii?Q?+Ch+IRcc+e1idLuN7GzPKyOsLxz3H1tQLcqOzohQHYyjCSeLmaSqhY8uSUGM?=
 =?us-ascii?Q?tP6tpjkI/cDxbtdJ0whSeZu/zmJpnszRJZlqabfjkE7zLisNmXvrC3JbylF0?=
 =?us-ascii?Q?5QWbmlff08+YmnuX3qKbN23Bpf2s5i6OXmHXPFGr982aR2D0vkZFt92QVThs?=
 =?us-ascii?Q?pNjGP1B5kb51hDMHL2zhfk1+3/LAJy5ElcK5xarH9UEOLxJL1ZP2+eqC8mX4?=
 =?us-ascii?Q?l3J8st3WzHjq6U8HTN0qZ/cE9bMbV5scLGVs2AC9GZTwUElADSBlbGLjJ84n?=
 =?us-ascii?Q?u0btH+T4FoKbM5lc2iipwlPX2FgVwTFbEhVORZ+7ahuOXHBn1BVUCkbWgGck?=
 =?us-ascii?Q?Q9AQdpJdifwhtCQZB2Ngbsf+z6+dWiy5bOGv9WL1eS4sfd8BWg5/dtzylNt0?=
 =?us-ascii?Q?lRSpnAkUJxj5j/WJI1JzoILCt71kyrvSo3eehTHP1b+6CRDv/04vpa2XQzWX?=
 =?us-ascii?Q?B8yLBZyXAQZ/5vitAyT/2OsXdDUcv/zQzUOBenZWEYDsgKKwaEKHPEtvqyoJ?=
 =?us-ascii?Q?pPNu6PC237r2uydlxsN8Y3XrGeZO4ouy6bU/XzSr02b1Gqta/hSssdtpWtFp?=
 =?us-ascii?Q?EqNMzfiGdJSJ00GctMFG9IdlkfoB91wiCsgJEBMrc5ytPDR8qX9fwC0uOyTg?=
 =?us-ascii?Q?dM92V/Ozlv/19b0y58p2Cm9IGcOaQQF7nborLopNe9fOUIEn0b052hqoWtiH?=
 =?us-ascii?Q?uvfavPTlwjoelYiA8d2l2lPRkXQ87+3I0EuaRtabvInIQ+pjOs81/6ztHk5G?=
 =?us-ascii?Q?8naf+5DN6YWDRMqhGSrBFMVGTiRWyFCPnUgdEIq6Ua918YD0J7TmxKqAY+Pk?=
 =?us-ascii?Q?Mv0NzOG+WAuJer20gg9o6dOKobVXqomieC5WuBZI42zaHNAA9yy0ryQTqbPW?=
 =?us-ascii?Q?bWxn/BlRrX21uo9m8TYxxOWxKbDQ3yOMRnn32upAYObZR/oLFfSRtk4kot2F?=
 =?us-ascii?Q?++vEtI4rudzbwKrWT/28/47Cg0oOdZRyG7MpeIcrtmsO0qQXkdZQV6shA9zp?=
 =?us-ascii?Q?ke0i32i90XdiG1rp8iMpVssbR61EdD8Mr+U+gFnhgSavaIongIbtCrzSqbDD?=
 =?us-ascii?Q?52f4Yxq+9sEFBdc7cMuZFlcW8Ut4PVRre8fXT9BnnD2sibDG9yARxb+c9re5?=
 =?us-ascii?Q?mASLwa/x89rHHMWUmGKmxeBaSKMB9NCBiKmS0vss0ApLZrg1ae1Qfy9ikTyW?=
 =?us-ascii?Q?GClcmdxBOkhbYsH4GhE=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(82310400026)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2025 05:26:35.3727
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aaed18dc-de76-4879-fc2b-08de2cac5de1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BY1PEPF0001AE1B.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6889

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
[v7]
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

 drivers/vfio/pci/nvgrace-gpu/main.c | 215 ++++++++++++++++++++++------
 drivers/vfio/pci/vfio_pci_core.c    |  69 +++++----
 include/linux/vfio_pci_core.h       |  16 +++
 3 files changed, 222 insertions(+), 78 deletions(-)

-- 
2.34.1


