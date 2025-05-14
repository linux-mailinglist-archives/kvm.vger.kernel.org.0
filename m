Return-Path: <kvm+bounces-46543-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E8A56AB7728
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 22:34:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 982D116BEBA
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 20:34:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20ABD296173;
	Wed, 14 May 2025 20:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Czm4sIlj"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2073.outbound.protection.outlook.com [40.107.220.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0F929372F;
	Wed, 14 May 2025 20:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747254821; cv=fail; b=bZB4AUdK6cVSlq97hCoxfg0i0YHV0ezEzUdNjS7QzN0ZkMK1tJAyQvp3kMa7iQbdq+W6gbAHx3zQgAJnSlbYL4KyDduHYNtFTZJDXBcNVcMMi5T4htqwRCbWVzWKyXsF5Be6hRt0Z4cMTy/inGku9GkS3JagrmJwKkJf/Hsz1Ew=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747254821; c=relaxed/simple;
	bh=lDlZ8XgYya0+ySeAr2ZX+k6Q+mxS9uq/Mzq3sTr+oFw=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Kx5zMovbXX8gscWNdRy+oYb6ZupE255hMjtZeK0Vt3qAV6m/Cmunt2PNGgVFJWE/plqkLTYAa6ZqRRvpYPYMHCEVFpVcDtA3XbciBZP6RiNerJ3FSaeiKgmQRVFia+km5BelhvLAJlykXoE/TiWkRqUdw+YY9l9Q0nWpNowPFvU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Czm4sIlj; arc=fail smtp.client-ip=40.107.220.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JJBhwyVyrVT2Pq7LNNNCLizS53KnluUiFIlUFpebPOufB3x7uDocHSMJ26yTWeBfUew60DObaSqFWTKRyJTwxtAYBYvyZNeuBxgRe6C3/m1Z9oA4ZrNvRZz0pYR4bMYgdVo8O1/R9EL4EWj8X0zSLldy2ib2s7JInhFY7uEm7pIieyhHfs/gUqJSJcXnWNWiqLTtgbgQ7f15vkVez1TAUgTWZq5X+hvw96nGD3v0cUUBWqkDqD2/rrfHCxEnEBFiKLFFQ8HdHHldwbkgohC61Qp1IVC8rDGYR76DCcQpTFo/Un7HQDXsZytR5SFxFMCit7Rscof3mIy99RwIymkskw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mTFNCqf9NgukDeTYUwhGd4FbwbIv+S++rtIwEOapBb0=;
 b=o81bUWPpCJQt2+7xekdor6PCz5Kz0YBJBgwHxq+8zHPYxWdFyj/etWO9pwI9W+WNGyR5xciQCg5EAxxD34YXj0RmO1//kc+TRyBqA4xKfQr3JuKBmdg+POQ5HUhWVcvNx0RuX2Nz1qvzcDx7X4R1OFaAIwPxe6MBTGd3iQyMKl//Tdr/Ao9CFAAaDw1eoJMK/5PkhDncvGeLYTtRXZln7gYyBWhcLIPPnFQOMegbTiEAJ9+foD5DDqTiWJjeoIKFhTi8bWlik68rQzBetpJ/IIETxJt4aMV9oIkffoWHQPPwMYREQbKF7gMBrE7xXDoZV4KZDjrGxBI0Zil5+JtWiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linux.intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mTFNCqf9NgukDeTYUwhGd4FbwbIv+S++rtIwEOapBb0=;
 b=Czm4sIlj3vVP2p3rUH2XTPgY6maAP++mqoWJf/MXchNxcmUfaUNypaHp4q30K1maA/nInqP7ZkT1Esyf7QEP4MsIkMudCHlScUlf33UUO799fFwnzESoEzrchUNxzkwk0lkwgo7blU9rxXOkRzsuWi21kploAcHm5Z0RjMmF6HEX9WCqnHJNdRbAkMAqBQJ3WCVFhrRJtyby3ect5ijXHkey5uHMLNqpR5aSaqfyKXN+uFIKBGYSORhSX0noATiKo/XQGQLucyyElgOL+X3Fy1GREGXzpf2oibKF4dI/1HKqdV4R/OACmEQuuvRneK7lFMN7CpC8C8ANGwhxq39Zjw==
Received: from BYAPR01CA0014.prod.exchangelabs.com (2603:10b6:a02:80::27) by
 SA1PR12MB6679.namprd12.prod.outlook.com (2603:10b6:806:252::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Wed, 14 May
 2025 20:33:36 +0000
Received: from SJ1PEPF000023D1.namprd02.prod.outlook.com
 (2603:10b6:a02:80:cafe::3) by BYAPR01CA0014.outlook.office365.com
 (2603:10b6:a02:80::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8699.32 via Frontend Transport; Wed,
 14 May 2025 20:33:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF000023D1.mail.protection.outlook.com (10.167.244.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8722.18 via Frontend Transport; Wed, 14 May 2025 20:33:35 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 14 May
 2025 13:33:21 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 14 May
 2025 13:33:21 -0700
Received: from inno-thin-client (10.127.8.11) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.1544.14 via Frontend Transport; Wed, 14
 May 2025 13:33:17 -0700
Date: Wed, 14 May 2025 23:33:17 +0300
From: Zhi Wang <zhiw@nvidia.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>, <rick.p.edgecombe@intel.com>,
	<isaku.yamahata@intel.com>, <kai.huang@intel.com>, <yan.y.zhao@intel.com>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC, PATCH 00/12] TDX: Enable Dynamic PAMT
Message-ID: <20250514233317.306f69f9.zhiw@nvidia.com>
In-Reply-To: <20250502130828.4071412-1-kirill.shutemov@linux.intel.com>
References: <20250502130828.4071412-1-kirill.shutemov@linux.intel.com>
Organization: NVIDIA
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023D1:EE_|SA1PR12MB6679:EE_
X-MS-Office365-Filtering-Correlation-Id: a484a758-be2f-44f9-e5f0-08dd93269a09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|1800799024|36860700013|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TymIWV9n8XvBbP2uIiInFpKSPDrOTh/3YyVHXT+T052UlIdvgFPIzajX4Nv8?=
 =?us-ascii?Q?9Rx6prY68xpJ4yqkdGfjaWvgfiVxHH+bL3GyPyjRORlk9KDBLIt9d1HRzY+m?=
 =?us-ascii?Q?T61gTVsunm4XBxusEM9Pv2RH7vx36b3qLXQJeU9MV3UpeNb27R5e9la0frQO?=
 =?us-ascii?Q?wes8FhTKWfnbFLziRZva+X1NmMAEWVZ1tii+/+TiGkjbue7vEVXES9YoTlLO?=
 =?us-ascii?Q?V1FciSiKN0WR3epEdDwFBlCmpJGrsygpKnkYxM/fOF2l6nORD1USGIO0CATy?=
 =?us-ascii?Q?4zHgQC3Vh98ki9mV7Y6u/nXg4EKLnwuFRsY8Ragxiak0mHmrak/RXA2XZmUU?=
 =?us-ascii?Q?KgpUmcaEjx/oyXvmVBUm/pYi/Np6/bH6V0lYc1C51KLaFi+A4QJe6C5+V341?=
 =?us-ascii?Q?XCxSBV/XAhWZrj+60XlOOb48CngTctojhuGMEx80ViMF74FXcgzjSxLqtuGE?=
 =?us-ascii?Q?0w+9M9I22qOSumru41MO3O4esS/04ZpvXS3MREJmt8v+9HVOGLn4SGJkqUr5?=
 =?us-ascii?Q?8HVR49xCamyFuktd24e1XWW43x926ylBoHg8nXz8jyEWgGG2UJx7u75AEcHw?=
 =?us-ascii?Q?Od1zrZw1dU4X/HsFEuJWUC4yTdNxv+wLpP+QIEEHQEcajU9j0h8mFRHbaxol?=
 =?us-ascii?Q?MfK3MEeiiTf+f2+tEpVGG9bua0hoUbSVbzuZt9loRbDG8Vx5XbKFUCl9tg/K?=
 =?us-ascii?Q?NvY0j+QdB6DEHphXa6Fmcwh/Iur3RWJ1TIMPDEThxaJ/1bYIiIoxJGishRrf?=
 =?us-ascii?Q?Aaz2cdV1AXnZ4RYhX6BniIXrdbrHAo3SK2xJUSLmqaqzbq3sUrMt+OMlnphC?=
 =?us-ascii?Q?IQS8pVKxoKshtqF4KFXiaoBjsNnGuaPP8qjslIDeAqKkh0W3zFnFylVpxM3/?=
 =?us-ascii?Q?ecZ2dQ0xWCVcfxxVXgD21bwb/3RL8OiwneqGtR3sA5nIh6PC4/IVPdIGVU1J?=
 =?us-ascii?Q?95srfYhmbNoL39iV+1/s3wLo84a01+ytseYrFJF/ZGPpgMPqd/EtHp95yhmG?=
 =?us-ascii?Q?ArEu9kJeR+w7NLsE8LaRvXBBCviYy+PelFDSpuC4bi9hYV5DJLkvW292eEbi?=
 =?us-ascii?Q?mmyltwaRNM+lrz1SAPm/8wSKOKSYOYnSvQ+kidD4ddyxsXGvaUFy9zHpq2w1?=
 =?us-ascii?Q?IstDbZ8jMK5GLS1UtwJlXw6bO9oABByV+RfJ37Uuq9tJFII99FEieKLTqQVj?=
 =?us-ascii?Q?ClVJbpYnB9NvJO2we8l5KTdwR84fDcv7QkZFp+2WVEvez+B6YigqRMM5mJ+M?=
 =?us-ascii?Q?0FbGrMUzB9/MGreHI8L27IcBJsWdrLF8PsDvy7b3Jr1DVGBatpsMeNJ8RqvS?=
 =?us-ascii?Q?x6Kcg+DazBklkSo2eVfRgqoQBvZ7URUzuoW6xzB8G1vkOKyAgwTd8XePjSrB?=
 =?us-ascii?Q?veePuAtl5ogJDzuBjq+kQ7cDu5IkXIj6MQ0fQXjWcpjvHaZzd+bzHUR2wN7f?=
 =?us-ascii?Q?7wplGoi/Di/5xweaSqrdFvXOgX2WafzKzJ26A+cPin++sqoQPtz9D4C3SsdM?=
 =?us-ascii?Q?cU12kioW0qH9+Uxa95jV1lZwV4HEgvdb6PpSkaEixUv0spqjKqn3G2Yt4A?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(1800799024)(36860700013)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 20:33:35.8483
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a484a758-be2f-44f9-e5f0-08dd93269a09
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023D1.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6679

On Fri,  2 May 2025 16:08:16 +0300
"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com> wrote:

> This RFC patchset enables Dynamic PAMT in TDX. It is not intended to
> be applied, but rather to receive early feedback on the feature
> design and enabling.
> 
> From our perspective, this feature has a lower priority compared to
> huge page support. I will rebase this patchset on top of Yan's huge
> page enabling at a later time, as it requires additional work.
> 
> Any feedback is welcome. We are open to ideas.
> 

Do we have any estimation on how much extra cost on TVM creation/destroy
when tightly couple the PAMT allocation/de-allocation to the private
page allocation/de-allocation? It has been trendy nowadays that
meta pages are required to be given to the TSM when doing stuff with
private page in many platforms. When the pool of the meta page is
extensible/shrinkable, there are always ideas about batch pre-charge the
pool and lazy batch reclaim it at a certain path for performance
considerations or VM characteristics. That might turn into a
vendor-agnostic path in KVM with tunable configurations.

Z.

> =========================================================================
> 
> The Physical Address Metadata Table (PAMT) holds TDX metadata for
> physical memory and must be allocated by the kernel during TDX module
> initialization.
> 
> The exact size of the required PAMT memory is determined by the TDX
> module and may vary between TDX module versions, but currently it is
> approximately 0.4% of the system memory. This is a significant
> commitment, especially if it is not known upfront whether the machine
> will run any TDX guests.
> 
> The Dynamic PAMT feature reduces static PAMT allocations. PAMT_1G and
> PAMT_2M levels are still allocated on TDX module initialization, but
> the PAMT_4K level is allocated dynamically, reducing static
> allocations to approximately 0.004% of the system memory.
> 
> PAMT memory is dynamically allocated as pages gain TDX protections.
> It is reclaimed when TDX protections have been removed from all
> pages in a contiguous area.
> 
> TODO:
>   - Rebase on top of Yan's huge page support series. Demotion requires
>     additional handling with Dynamic PAMT;
>   - Get better vmalloc API from core-mm and simplify patch 02/12.
> 
> Kirill A. Shutemov (12):
>   x86/virt/tdx: Allocate page bitmap for Dynamic PAMT
>   x86/virt/tdx: Allocate reference counters for PAMT memory
>   x86/virt/tdx: Add wrappers for TDH.PHYMEM.PAMT.ADD/REMOVE
>   x86/virt/tdx: Account PAMT memory and print if in /proc/meminfo
>   KVM: TDX: Add tdx_pamt_get()/put() helpers
>   KVM: TDX: Allocate PAMT memory in __tdx_td_init()
>   KVM: TDX: Allocate PAMT memory in tdx_td_vcpu_init()
>   KVM: x86/tdp_mmu: Add phys_prepare() and phys_cleanup() to
> kvm_x86_ops KVM: TDX: Preallocate PAMT pages to be used in page fault
> path KVM: TDX: Hookup phys_prepare() and phys_cleanup() kvm_x86_ops
>   KVM: TDX: Reclaim PAMT memory
>   x86/virt/tdx: Enable Dynamic PAMT
> 
>  arch/x86/include/asm/kvm-x86-ops.h          |   2 +
>  arch/x86/include/asm/kvm_host.h             |   5 +
>  arch/x86/include/asm/set_memory.h           |   2 +
>  arch/x86/include/asm/tdx.h                  |  22 ++
>  arch/x86/include/asm/tdx_global_metadata.h  |   1 +
>  arch/x86/kvm/mmu/mmu.c                      |  10 +
>  arch/x86/kvm/mmu/tdp_mmu.c                  |  47 ++++-
>  arch/x86/kvm/vmx/main.c                     |   2 +
>  arch/x86/kvm/vmx/tdx.c                      | 215
> ++++++++++++++++++-- arch/x86/kvm/vmx/tdx_errno.h                |
> 1 + arch/x86/kvm/vmx/x86_ops.h                  |   9 +
>  arch/x86/mm/Makefile                        |   2 +
>  arch/x86/mm/meminfo.c                       |  11 +
>  arch/x86/mm/pat/set_memory.c                |   2 +-
>  arch/x86/virt/vmx/tdx/tdx.c                 | 211 ++++++++++++++++++-
>  arch/x86/virt/vmx/tdx/tdx.h                 |   5 +-
>  arch/x86/virt/vmx/tdx/tdx_global_metadata.c |   3 +
>  virt/kvm/kvm_main.c                         |   1 +
>  18 files changed, 522 insertions(+), 29 deletions(-)
>  create mode 100644 arch/x86/mm/meminfo.c
> 


