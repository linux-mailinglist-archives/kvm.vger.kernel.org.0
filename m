Return-Path: <kvm+bounces-64715-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id B049BC8B923
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 20:29:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 23E7B359E29
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 19:29:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B92C433FE2E;
	Wed, 26 Nov 2025 19:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Xt6I1kYC"
X-Original-To: kvm@vger.kernel.org
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013042.outbound.protection.outlook.com [40.93.201.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A0D331A6C;
	Wed, 26 Nov 2025 19:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764185340; cv=fail; b=msIE7ukQo6cMATJQjp76dgO3VKiYql1wNoeZ7ogNxnkGXrWwU7oFlp0DDZ/UaHzX6TxWDPYI2oWwXEX2AbkGrsJmADO6y55+AliCXIV365ugzzaaffH6oTSSVtc5+/TXsk+EWw+kq4MgYg4eHX+q5+F7Y1JdS8o25g/wJTTlECY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764185340; c=relaxed/simple;
	bh=Ppr4PBhv5mnUueOe5FgHaAKU5jnf6+XgRn2d6EYNPPI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=iaOm94H/FxY/ULLO8vOGepckrhH8tjXwPpoBJxxfFBsecaUqXEQxnzemcTgUcZtF5SOPKfIWvaD76BM4fF1TAKkEgpe/Ellgv3JwyZPbNSwrDOJ27IsMCVXKHDfXW0mI0oJlN8ppyzHm30e/AjHByjEGT6WMyCB6ccrWO66f/zk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Xt6I1kYC; arc=fail smtp.client-ip=40.93.201.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=or+yYuCmk4xwOI8nFX2pSbnkLgIM4+Ix3/o2/YniMuK3v8MNKz/7scPiduRB4PCVnKXT8Co+w2rV4nFNjh8vqAqffAeXuEY9asvMdLDgINn0Be/IluIsJ2oPAnxaGCKl0kWe11elrHUfkUxhrJlBE1Im35Q+Demv8mPU0pzF7mLA0BzfQkjtaVZ6W6z/dABgMclB4icll+WyggZIKbzT4EQXV29c0uCuHIOtn0s6mxNFWaeo7C1gps1sAH9tqJNMX9AzK4BcFeE5SZ+JJIPyqEXGdIBvBpad3YGF4z+Z9e1jachSaeRXil6rLp3ycmzd4XvKuadbklu1SV8QAH+urA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ImEO6dR/vfeXdrCAeokqEKsruQK7H7Ab9b1c994G2aI=;
 b=uBa0xeiLaqQ5LQe9Rs6oScapPq2Ekg1qFNowZ2hWYIAQQeXWb/Sqi7maRSuIeHpHxe2PQ1tMMjYEKL5jHl3buXhxJNP+XYxNIwcYaLcRw/VGoLmBwFYBFFBOIBb3t8CytjivVk9h8pzky6qthO5HyKmavhWYEyZV3INxwGeO97/epaVD4VNJ6mQzJtMeDH+TTVlpwjyMFGTVXvrbeEdnE9M71yUx2u20APRe7dN5pnT7LulNAeQeaGZny4XOx+zyb0HduiAqwZJ7o0nlRCmd42Eh+6TacXEb3DcdHBV6j/pLM9RUKn5pGRlFd1Pk5q0uKCFiEu6lMR0yi9/eMzAHLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ImEO6dR/vfeXdrCAeokqEKsruQK7H7Ab9b1c994G2aI=;
 b=Xt6I1kYCRkyMaae2a7nSCscDmT12rI3EUL+zfXM7WcuxthEtjKGdH/MPTSpDVW3T+SBVwIXti48F48JOBmINUzNcaLivKkNII5xyzgRtqGbYl32+Gz/Mv3VZLyBKTcjUz9Epb1VZ+XTWw7glkK04g8/2keTPn/UjGR2ZF+l+jrLsvyouuIj94LxLUFmPyTWcMwHrTkJDMN8AUK04hjwLasI7QDJ+aCuzk7yR/qAxtzEaMuvEdTegvX5EOiMp76veJYe26jPW4soUvKZ7OTu0NeMw7XD1HiJzFdU+XGTrkZBcesn4V+WeTnEktimWvS4gW5gfvBOndXPhaUCkZh/9GQ==
Received: from BYAPR07CA0049.namprd07.prod.outlook.com (2603:10b6:a03:60::26)
 by SA3PR12MB8047.namprd12.prod.outlook.com (2603:10b6:806:31b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.12; Wed, 26 Nov
 2025 19:28:54 +0000
Received: from SJ1PEPF000023DA.namprd21.prod.outlook.com
 (2603:10b6:a03:60:cafe::ce) by BYAPR07CA0049.outlook.office365.com
 (2603:10b6:a03:60::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9366.12 via Frontend Transport; Wed,
 26 Nov 2025 19:28:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SJ1PEPF000023DA.mail.protection.outlook.com (10.167.244.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.0 via Frontend Transport; Wed, 26 Nov 2025 19:28:54 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 26 Nov
 2025 11:28:47 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Wed, 26 Nov 2025 11:28:46 -0800
Received: from
 gb-nvl-073-compute01.l16.internal032k18.bmc032b17.internal032f11.internal032huang.bmc032l04.bmc
 (10.127.8.11) by mail.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20 via Frontend Transport; Wed, 26 Nov 2025 11:28:46 -0800
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
Subject: [PATCH v8 0/6] vfio/nvgrace-gpu: Support huge PFNMAP and wait for GPU ready post reset
Date: Wed, 26 Nov 2025 19:28:40 +0000
Message-ID: <20251126192846.43253-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023DA:EE_|SA3PR12MB8047:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ac3ae9b-8444-487b-3821-08de2d2209b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014|7416014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Gas+tZDWEM25gHLA0IT408B5yHxTK/+g4YZkATfiy9m3pmdPXMkPwNsz7pfV?=
 =?us-ascii?Q?b5zlZDIAf8Ev/eBHLSOdFGC0OWd8KydHxsnhFgTkY9z1ULLl4kGL5439ZJTM?=
 =?us-ascii?Q?PKf3C+hU40eR26pkE0lbJsbigd+eg0ivJTpSIKfsbUa0T44Q78C4BCB3mg0l?=
 =?us-ascii?Q?1v9RuHMgNbXafB3nyNFnTIdcwltDFq7Ut6PzU21hI34c5YJVbKWdC2xD5pLd?=
 =?us-ascii?Q?dqUobV4QFOiCbnaU9lnWCQgB0oETnVRK5hmpth8WyO1H28BmhM3I/Qzi8F8F?=
 =?us-ascii?Q?ftzptHtkVO02pV0VDPXcVJ6gyaAQb173OKFA/Q78A5D5Zljex3BaW34wmdMI?=
 =?us-ascii?Q?ziIzAxTtKyfVcFPeiVJoGp6CD/yqumQt1BuLHbgqsqehLywRntDiPyvzF5Xr?=
 =?us-ascii?Q?5bJsp7ScLlxDlA7B1qVy4fjIyl1b7cIpGes49AJCaIZUWb+k76ualfY5rklb?=
 =?us-ascii?Q?q6nquW/pEgsDFyjsrr2OPUTah38bjBHtIiXQG+E+JfIk44mTwX/lmUqLkjwG?=
 =?us-ascii?Q?rVHS5m2vWJr7h3hn7YLGV2iCsN3MxGmyPhUm8QV8zC8Gq2Zo0KRIVFaQD+WG?=
 =?us-ascii?Q?4gKo6NxJDeSL8gevTpaqN1aj9W51dmtaPD/rm/MBYzvJccOfYtHS6/gJP7Ub?=
 =?us-ascii?Q?I4S64jdfrHlhikkVPfcJHaIHOTJyH1sn16pluigzzXIRfla6Wp86kXXBO9Nn?=
 =?us-ascii?Q?QyhY3O+2wHnEGEAZezcwuUfl13PAbjSRf9v0OfQ9KK0Qixnv7gO+zq10yoPO?=
 =?us-ascii?Q?Cq7q8jopIBugekcuKtWLokhf/7jyBHlRQ7OS2ON1Tt/dpZ7aPsbKN/hIlzR2?=
 =?us-ascii?Q?HsZh6UeBRG2qt2ixioSz2mQgPPYl2jaAM6CTe2m7oR1dpKeLMNGQeX+YHELU?=
 =?us-ascii?Q?U1rSNbTf6U7FfCEuQdrRiU7rSOMj1oKydtX9HuHkTvpOVf2fNI7PjXsFOPGw?=
 =?us-ascii?Q?LgfD4/R1xHN1b60Hn/x4GB+7ZTs+t29mGZ7J/EGyuMDvX39haF5GwS9fotNm?=
 =?us-ascii?Q?GmoHvMq5zAtWaLe44oUY9CGL3/kCnUm0DvTxI46caZ01GlTwJOLMOFzu9Ocs?=
 =?us-ascii?Q?lfRA8zbrZ3jdqSHI1GQSnZq2cIW4rChHuex0+QsIpBeM0WrfA36/yAOeQ9Rp?=
 =?us-ascii?Q?vxM1SQq/UHz+l51sJXqADvZxPs/I4m/c5PMDwH4412x31f9dPhjBjrAyx8Xd?=
 =?us-ascii?Q?ziSeWfBXghg7hrhqjri1ELP+FrW5830xGxr+5MzlVN/dzHnmXtzi6Iet2zLa?=
 =?us-ascii?Q?EmOXaHOVvDPBzoKCiDSpWtVGQDbcthhp5iykfn9btFoFTI7pXWUSEV2RJ4Da?=
 =?us-ascii?Q?jYCf7VnK4JysPHSHqZdSYIea2tlDCtJvw33IfxyaZWZwHHyFDDq/Ha/g5unv?=
 =?us-ascii?Q?32qeLpzNHa81Q1hFuJEQf1gL/QPnHVMpVpkrAYnPvLEbPkU0Z+1qqPGj13ew?=
 =?us-ascii?Q?eaY2CLQUDLX3efk8QkXxFprKsjavpcAX2NQ8nkztcO/O3UcsVBgt51Fn/qhL?=
 =?us-ascii?Q?vqTOwQ0AJh3NlAXBVLuFjvo3F9t6cCTQyfLnuqRAXCiSQc/JIytgiwVdaUNQ?=
 =?us-ascii?Q?tLDax/XkunUpQ7eZgvk=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014)(7416014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2025 19:28:54.8173
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ac3ae9b-8444-487b-3821-08de2d2209b7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023DA.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8047

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
[v8]
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

 drivers/vfio/pci/nvgrace-gpu/main.c | 208 ++++++++++++++++++++++------
 drivers/vfio/pci/vfio_pci_core.c    |  69 ++++-----
 include/linux/vfio_pci_core.h       |  13 ++
 3 files changed, 209 insertions(+), 81 deletions(-)

-- 
2.34.1


