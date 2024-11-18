Return-Path: <kvm+bounces-32013-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4317A9D11B2
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2024 14:20:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0401C283D8A
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2024 13:20:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AED901A00EE;
	Mon, 18 Nov 2024 13:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="UMHJbYkm"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2072.outbound.protection.outlook.com [40.107.237.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0134E199243;
	Mon, 18 Nov 2024 13:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731936011; cv=fail; b=b2LykjBQIqyzS8geKBKQSUZbxmORBp5MbkgZwvhgO0rN1GbaKuCMgSR/WsF+c25mSlyJxVQWqj38mjoJcgAiVSX+fTuaxNyUBYwVZ91akm9B6Dof3U906VpawD63ZQrbMHeQEcLZBJORGV7YStCmM5iOSokQuMFfsSpORx8ksmo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731936011; c=relaxed/simple;
	bh=anUIq0A9g5NYGbW1byNAWJikzk/WyWukYrJfuLVJYiA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=nk3DVXAkfj77wLJmuramYTi5oC0Ne09SLpfAFehWnnogptqYh3oZVhfOjzE+rCDASchtJbb0xAffs7/zIO9tvXBUgDjR4hDi/A/ycXtIdnPb2bz+HihuYaBT9VCYPBHuQt7hV96V47A6HMfe9YMANyIzyO949re3qH/EIPYqr5Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=UMHJbYkm; arc=fail smtp.client-ip=40.107.237.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Dk/+48df8rTBfakT/UJClXx/t6//VzZHB8JFPAB/wmIKJy0pBJEQPEIQwZAD/JgMnGtGXxrNnd4/6pHNvzPRehbIWZeH2if7ON/Zn9r3Fq+rkC7tULpSF760ZyJ8j+AhAl6xU8aPpqhNmXTKYeEtVB6PjThCacKmaxwAwWkttnrHk7BzC8PG7IXWMXE8oSeCpyjiRbIC0tPTDGCk3rtQbIF5P3FW25gletaNx3khqgrc4DWVJAWLFS1yyceVm9c9JgslZ6AAPho7eh8md2CyrPq+6ZJpErsqiVjj1U8qnLevvGmFVo8EWi/iOE1pSczU6xo3ChlAdkpVKHs0B+38/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=up6TV1Z4d9ApdNX5ynnV/z3Fv3l2Ncb8vspmY/523/A=;
 b=sgLfvBVlH3CPdQn4HIP+DDwdKvh2ROw7KZXdDd6u4DWuIcXZOGDUW/ipgKx+Gb56SyM3lXiVBXGpzgS89bsmsmtKFbfC7f+LykwVg0qKIsb+SGkmpMDo9aIu+8XEeBs7gSg/8gl7c8CMmTtMG7agiwBX7rSpOCkcZegph2mBNHtTc28h2pkPjkikI89dpcNpgfd3b7knUeB1n6q0WG0C8Cdo/pykIsDDz9YUpqjAR5RsesHxZtbGao7hXYn0DoyAppkRILpem3BfF72AGhRHEXVRDgbHy+ey7n+uPS2yh77fg1nuZXcZLeofC4LyjsGCaZmNAkEIpqoq8KcEKidmeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=up6TV1Z4d9ApdNX5ynnV/z3Fv3l2Ncb8vspmY/523/A=;
 b=UMHJbYkmlXAyo+7Mm6i/PzC5R0g425P7m9zUYPUyn6oq41cv6nsiqV8tvpN5ukDODL7+biokpjzdZKkGDqu/vbMqTifNN2NUaDyviEvPXhmpJpVZVIz5CyY9NfAv2GFxRN5KDgaqsy0hTvoX14LFiYZUJJK/Ca+8rU0kuQfVZhy77FRidukNl69HCB1v2taDnwfrUTsMAAqdIhr7Vi7uRMy1JWO6M0SCmRh5TXCFxyxJQ6fCHvzaTGEJGepVZe/BZ2t/bpbe4NEsN6cKh8BdAiBXNuJrDKI7h3W6EqOFGAjzxaWBIAY3RmrvUA6FzmgRHRIiSmnBdKtGP5SXFKJ8zw==
Received: from MN0PR03CA0028.namprd03.prod.outlook.com (2603:10b6:208:52f::16)
 by DS7PR12MB8203.namprd12.prod.outlook.com (2603:10b6:8:e1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.23; Mon, 18 Nov
 2024 13:20:04 +0000
Received: from BL6PEPF0001AB54.namprd02.prod.outlook.com
 (2603:10b6:208:52f:cafe::31) by MN0PR03CA0028.outlook.office365.com
 (2603:10b6:208:52f::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.23 via Frontend
 Transport; Mon, 18 Nov 2024 13:20:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL6PEPF0001AB54.mail.protection.outlook.com (10.167.241.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8158.14 via Frontend Transport; Mon, 18 Nov 2024 13:20:04 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 18 Nov
 2024 05:19:59 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Mon, 18 Nov 2024 05:19:59 -0800
Received: from bianca-c03-0014-ts3.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Mon, 18 Nov 2024 05:19:59 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <maz@kernel.org>,
	<oliver.upton@linux.dev>, <joey.gouly@arm.com>, <suzuki.poulose@arm.com>,
	<yuzenghui@huawei.com>, <catalin.marinas@arm.com>, <will@kernel.org>,
	<ryan.roberts@arm.com>, <shahuang@redhat.com>, <lpieralisi@kernel.org>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<zhiw@nvidia.com>, <mochs@nvidia.com>, <udhoke@nvidia.com>,
	<dnigam@nvidia.com>, <alex.williamson@redhat.com>, <sebastianene@google.com>,
	<coltonlewis@google.com>, <kevin.tian@intel.com>, <yi.l.liu@intel.com>,
	<ardb@kernel.org>, <akpm@linux-foundation.org>, <gshan@redhat.com>,
	<linux-mm@kvack.org>, <kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v2 0/1] KVM: arm64: Map GPU memory with no struct pages
Date: Mon, 18 Nov 2024 13:19:57 +0000
Message-ID: <20241118131958.4609-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB54:EE_|DS7PR12MB8203:EE_
X-MS-Office365-Filtering-Correlation-Id: 66632651-9c33-45c6-09fa-08dd07d3b707
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|36860700013|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZOozVKOFFHvmc1g4SVFje3AnJvb7pziCaws0q01UdCMBxga2MDBeFfdGlHwu?=
 =?us-ascii?Q?oVyqGDrqtZg+ZAIrvlosfggdN0wjQ/WyCyNnhQzoqDpzEufLLO4LOdR1zIw/?=
 =?us-ascii?Q?Ov6nI578xObAiIgXTELKH5plje3ZCOd+mkX+djj6lGiI4U0gKgXOYeR4wyz5?=
 =?us-ascii?Q?NhUmukyX4CS31M4DgjFAXj0xiL+PFcQb9hbPXf2Uvu93vzSGMUCRPa4uLpka?=
 =?us-ascii?Q?Tp7z3Jr9+bphvbQ+KTkNwkdNGQfuQI/8so45zNwjiWdRTr5BQtiTt1rs6HCo?=
 =?us-ascii?Q?axc7ymrlJA1dSYeB3Ez6hq5gm0wF6K0EoJVjQ5odngr2hS3/XtMxuxwPrkyJ?=
 =?us-ascii?Q?2whBPt8NRg7zJb+bvhV5NSy0X3U9t4OHRk42Hx2EsdtUobJbM0W1rChCIjn5?=
 =?us-ascii?Q?Li4qfTMUyJW1Ga2qbEwpPIBFX6Vqmhmf8dVNwdARFdGvGNMTcBlDth6o9LsP?=
 =?us-ascii?Q?bvhpbO9FltognOBdoK610vfI8gD5052h2i/3fXeTIXtV2AxhKT6VX6B2MYzo?=
 =?us-ascii?Q?yZfCMnd58SwDq0SsMU6PStCo67jwVke3pNyNu9nVYnQZbm+XsxZTSwUIcLhk?=
 =?us-ascii?Q?2ryQajg7fJE8A6fRUtfPNIvKVMQWGZD4Vwfy34o/TK/o68yXXXOqmdXcohIy?=
 =?us-ascii?Q?JjsAZxGtb4I7qdS0MOdrKbY3Rfs1Sx8RfafCuPZW0oHuA6T4pP8HYk/iZE3E?=
 =?us-ascii?Q?CO47/i//Lu+vrEOnX0SFw4VGRgKQSFxs+dGGXfAzGn8za/EJedkTU9/Mb+yP?=
 =?us-ascii?Q?0r6zkQoNojW3ZPusToeC8lvhhWX8VcEQoQemKH1WeQJIK2mgUzqa5v93m9Uo?=
 =?us-ascii?Q?ALVzzPKvs/o5As+Bmzp5zn1DgXIs9JtUikFN2y4pB/ceHqa3D7HOHYM9UObg?=
 =?us-ascii?Q?Uej1IgMN1zQ2rTX6rj5mysHhh8mEa55g6J14P27juCJ4p2upvM1IPlZezkgD?=
 =?us-ascii?Q?s57IbkfNZ0YiIyXeTQpnAreilFgj+dKnP5aRMmxtIq22pe+EnsxniOSoyNUx?=
 =?us-ascii?Q?XKE4T2nSJFn4eG4VHBPU+r29ioChDEXujlKXfmcs85pROnDZ00ZE3GstGlPG?=
 =?us-ascii?Q?Mv734+GMcrgFVQRXpvJfIiI8fYuuDl4fCAKGlbAMAX1NPiyc9gq+qhBWV4bP?=
 =?us-ascii?Q?jJMDF+5aeDjSmhAReuYOqQCAvFH1ztPLJGc4ljLQLHNP7SkBLLKkleGbPhCS?=
 =?us-ascii?Q?s0weylrhWivAwxRMnOEFwH+n1OLGbyotmwDjGDhVJxrnt86nQnSSojJhq+QT?=
 =?us-ascii?Q?j3mWdhSxDsJ1K1Z3lkDTvnhPuRwV0gAfOAIRN3CxPv4mVl4wB7zq6w1K0Qiz?=
 =?us-ascii?Q?lDuv6BwH/Isa9V2pR3dv/W9dcdkJV1AcI7frXDtK346dYcMnBCHF5B0trZWJ?=
 =?us-ascii?Q?NMz8Rn/MFPbqRvNLn293NVOjF6mXAdoXycB3LZKiYaQon/up9o71szMkXQ9m?=
 =?us-ascii?Q?UF9r4sMJy5Q=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(36860700013)(82310400026)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2024 13:20:04.4789
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 66632651-9c33-45c6-09fa-08dd07d3b707
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB54.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8203

From: Ankit Agrawal <ankita@nvidia.com>

Grace based platforms such as Grace Hopper/Blackwell Superchips have
CPU accessible cache coherent GPU memory. The current KVM code
prevents such memory to be mapped Normal cacheable and the patch aims
to solve this use case.

Today KVM forces the memory to either NORMAL or DEVICE_nGnRE
based on pfn_is_map_memory() and ignores the per-VMA flags that
indicates the memory attributes. This means there is no way for
a VM to get cachable IO memory (like from a CXL or pre-CXL device).
In both cases the memory will be forced to be DEVICE_nGnRE and the
VM's memory attributes will be ignored.

The pfn_is_map_memory() is thus restrictive and allows only for
the memory that is added to the kernel to be marked as cacheable.
In most cases the code needs to know if there is a struct page, or
if the memory is in the kernel map and pfn_valid() is an appropriate
API for this. Extend the umbrella with pfn_valid() to include memory
with no struct pages for consideration to be mapped cacheable in
stage 2. A !pfn_valid() implies that the memory is unsafe to be mapped
as cacheable.

Also take care of the following two cases that are unsafe to be mapped
as cacheable:
1. The VMA pgprot may have VM_IO set alongwith MT_NORMAL or MT_NORMAL_TAGGED.
   Although unexpected and wrong, presence of such configuration cannot
   be ruled out.
2. Configurations where VM_MTE_ALLOWED is not set and KVM_CAP_ARM_MTE
   is enabled. Otherwise a malicious guest can enable MTE at stage 1
   without the hypervisor being able to tell. This could cause external
   aborts.

The GPU memory such as on the Grace Hopper systems is interchangeable
with DDR memory and retains its properties. Executable faults should thus
be allowed on the memory determined as Normal cacheable.

Note when FWB is not enabled, the kernel expects to trivially do
cache management by flushing the memory by linearly converting a
kvm_pte to phys_addr to a KVA, see kvm_flush_dcache_to_poc(). This is
only possibile for struct page backed memory. Do not allow non-struct
page memory to be cachable without FWB.

The changes are heavily influenced by the insightful discussions between
Catalin Marinas and Jason Gunthorpe [1] on v1. Many thanks for their
valuable suggestions.

Applied over next-20241117 and tested on the Grace Hopper and
Grace Blackwell platforms by booting up VM and running several CUDA
workloads. This has not been tested on MTE enabled hardware. If
someone can give it a try, it will be very helpful.

v1 -> v2
1. Removed kvm_is_device_pfn() as a determiner for device type memory
   determination. Instead using pfn_valid()
2. Added handling for MTE.
3. Minor cleanup.

Link: https://lore.kernel.org/lkml/20230907181459.18145-2-ankita@nvidia.com [1]

Ankit Agrawal (1):
  KVM: arm64: Allow cacheable stage 2 mapping using VMA flags

 arch/arm64/include/asm/kvm_pgtable.h |   8 +++
 arch/arm64/kvm/hyp/pgtable.c         |   2 +-
 arch/arm64/kvm/mmu.c                 | 101 +++++++++++++++++++++------
 3 files changed, 87 insertions(+), 24 deletions(-)

-- 
2.34.1


