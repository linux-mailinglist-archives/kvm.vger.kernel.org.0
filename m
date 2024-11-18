Return-Path: <kvm+bounces-32012-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 16AA49D11B0
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2024 14:20:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8F28F1F218FC
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2024 13:20:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90E6619DF5B;
	Mon, 18 Nov 2024 13:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jht5zdJJ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2060.outbound.protection.outlook.com [40.107.96.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C4E21E885;
	Mon, 18 Nov 2024 13:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731936009; cv=fail; b=G834dG2tsv1jdMKCehWF7XwGkrhRIWsQOir1bItUCbfS8DhRoyL8DhrHAgGlMdveJovMJ/Vkc/B8D0w/u06MmxVqg9Wqq+lMVDYmbUeG5xtmdMD7SrMna1BDdGmJZP5L38WjwODhXMgQh81SOyULSXphTmUKleIhqe74zL+8INU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731936009; c=relaxed/simple;
	bh=ACZ89P+VIy//eZQHYtKUYM2JOEtMw8pMeVojzwPEAH8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MqOhiuT5InplI1JSYCakb2PYPlvoWTNrzXpLJ9i6Naimy8+VlbS05NqHRZbFTIZKxc4pC+nCiuRTf4GoT0FbgaC4DDjV/hzjnE5FFodMmJKLGVt8tGiziKoAewpkZ2eQL7uNlQ83jXdoT8MLRO+DlpxKuGuy7C2n10uGJ7+XnHc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jht5zdJJ; arc=fail smtp.client-ip=40.107.96.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Uv+FDZUsDtVfBYzu9B/zGbPQCRbCXZHI8GUNN0Wxvfo4dktQmCpX8goEQHjNJRl9oDKo8rSxzkiWyJIb3HmgvrWlcauViP44c1aS9xTBMDVliHC39hkR5vY0OTicXvc1udnNPyBtglBwbakoOPL8DziMpI5/na/38BPkO2MLTzTu5lj9k/A2yyp/o4cJ0MKUxrLAHf6sTcoZReCWnmKAKHiNWsrCrYjYuH4v3LIL1S+lgQJjMLmctOiZH++JxLHq3qcBWYS7GvOfgkFrghaVHih1pWfPj6KHGxtFIzHmgrn90UZXQUASS2Ws+NP7nH4hOdnAmhkND9weoalcLgXGEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9QgLFINH0WaQ+jKbNekXdJaCZ1BUV1PbrEzl10aoHoA=;
 b=pmwjwmCa7X+105bM15yBGVvRTx7DYlqGHyrSG1hSb2oG8XpUJ8FontDe1IIpauBKAV8ETF2Ktr/dQxpGzTz+bOB/KZvArGmiq4UcRF4VEU+vyKY9Iz4pu/S8YtEiiO5Cw06yCW8Gm/sKJbo6hjj5cxo69BO69mGdkUHpmtew9LDfdhmb5Fb3sybFZtsiLkWyuZQx6QP3PkW2Ovx52qPMktimvK2G+yQ29hTyBgrDBw93Ei/x6maLmub+i/zclRkxGGqmWvd0BW+T8vmwxLqNmigfv260vNiYamA+2O4oeHhX4TI6s1l/hLqKqNJslCrp9BIgJCazJRXrf4jRoVP54A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9QgLFINH0WaQ+jKbNekXdJaCZ1BUV1PbrEzl10aoHoA=;
 b=jht5zdJJ0WJspuwbsvzR+qe45EhhIGbj5yGQKXqbUiIReV/naMPOGKonDBEH0Grg2xy7JW0zg1YxCsAbOzSk9uJ+2U08OjbiC4Ki/5C7bCgP20O3KN7q7IzDlCHM7E9IZP8ouNaEMGrIsvk+IE/6ifS57nTY1K9tBmdcQ/QbwTiMdUxqiyLdhQ47F4RtNxt0brpntXnDKM+S/fTXqvoOPYxokpvxywbPPsogf3GFmXz+AMWk6hX/wN7bDQTDobomNFzzlbM+DnosJfzmJV60Whk914Ukln7XyQjIHncHp+qhqcH9nfV56OqSvL8fyBqE/twt6/Zj/dBNT3bppkY/6Q==
Received: from PH7P220CA0113.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:32d::31)
 by PH7PR12MB8056.namprd12.prod.outlook.com (2603:10b6:510:269::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.23; Mon, 18 Nov
 2024 13:20:04 +0000
Received: from CY4PEPF0000EDD3.namprd03.prod.outlook.com
 (2603:10b6:510:32d:cafe::77) by PH7P220CA0113.outlook.office365.com
 (2603:10b6:510:32d::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.23 via Frontend
 Transport; Mon, 18 Nov 2024 13:20:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CY4PEPF0000EDD3.mail.protection.outlook.com (10.167.241.199) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8158.14 via Frontend Transport; Mon, 18 Nov 2024 13:20:04 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 18 Nov
 2024 05:20:00 -0800
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
Subject: [PATCH v2 1/1] KVM: arm64: Allow cacheable stage 2 mapping using VMA flags
Date: Mon, 18 Nov 2024 13:19:58 +0000
Message-ID: <20241118131958.4609-2-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241118131958.4609-1-ankita@nvidia.com>
References: <20241118131958.4609-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD3:EE_|PH7PR12MB8056:EE_
X-MS-Office365-Filtering-Correlation-Id: dab0a518-1e21-4297-2681-08dd07d3b6b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|7416014|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Y15fBtImFYBEvzyINfz8n2qWAPESP90uDrSK9nfTPgX88R6BG82lmRzJKTHI?=
 =?us-ascii?Q?2M/IFdyKg2bhXkXfwPPOYTOdyxzuUPhHfb5MmxJ9nhq3tIuj3kAjOMJ+K1Ch?=
 =?us-ascii?Q?+pDxrNHQm+99MHjqTiNCnvgiVOt0iSIQ3DwlKlx7CK3asbdY3EkfvcBuCCEY?=
 =?us-ascii?Q?1lhPYjRyvC/GcMT6KxGArf62XHlYC2R/uWqz4Lx1oVIeSFHgYAm/ZSGJKpXW?=
 =?us-ascii?Q?ROkGUEuZiw/mRkm44o4lxna09TUM7RXP3yO9qZXKW8z1grgJfQKYmiKAYMcf?=
 =?us-ascii?Q?TJXQu3RP7mtqIb6zoHQcLQ23IDokPne/8q7VCx8t2rWXntYIUlfzoti8pORa?=
 =?us-ascii?Q?XyS4SUhacqstAI/85ZV8HgS7vgjebNaKgYEqOuQMVj/49q1sSK3Mrv5Uu+X2?=
 =?us-ascii?Q?o4O3XoNLhRLsiH2Q26qU/KyN6pJyEnha8JggBTRY8v3dKX7Lk22BFlUkoMmr?=
 =?us-ascii?Q?hNxfkfL/J6xkKJ/tQUMjLVl1RmLr3K1Coa1SnJlIcsM4IJR9scigBSIdfUVG?=
 =?us-ascii?Q?+6Btc4vViTMtGDc18zTOzNiuI8+F7Zga4iZYIvC/l0uTDG1C0/HHJ4KA0AjA?=
 =?us-ascii?Q?X3x5EPFOW4iaEPxbtdrVqLhH2KJhsjdy0k3vT9Yr8ZaoCgy4yY3BNpOleWnK?=
 =?us-ascii?Q?jneaXdQjELzOcVBxvJtO0iLvBI6crOQS4Da/uwqZ4BVgibiYnasocURKvo54?=
 =?us-ascii?Q?weVfzf5IkUPRaaKlOLttJIFHAZFV0WEc9uDwZy2n4AGh3BECGg2ZWK41L/kh?=
 =?us-ascii?Q?RViA8CjVQtKGb3dQSkM20J7P1r0bmoGQapKXqQFBqCJt9rSr2DDF0eAfGpxk?=
 =?us-ascii?Q?bu+2C3G6Vm5UoR6W/kVMGsnKF2IJhAvzFTh7n4lpUaGn4pLj4CsewkcKAUkW?=
 =?us-ascii?Q?U7lWAdOEkXTfPAcw/wgf8qw/ZmoJ4kFjIb4zgALLtpuQ66gbcIz3QlKgUUAg?=
 =?us-ascii?Q?dnvhXtEUcOcUfz7nUmZ9fpKq+9FySP3UiS4bJalO/v+PN8awxtODybZL+nQQ?=
 =?us-ascii?Q?qm7iQIyznifJTv4S9g0g4gFSGWlpdqTFMYblrNL88AhU6Zj1WTXxUA2U7PjZ?=
 =?us-ascii?Q?iFfUFCU1iI2NNvsYjTKGYEzJ7E0oJcFOOKwmcdmjJ/QG5Z1/CLfcGRLwd3AB?=
 =?us-ascii?Q?I891wCxMQ+TXo/7J527j4GraHjjxdPbPN3SwdFT/tdHQqlBRGnH8GVabod6D?=
 =?us-ascii?Q?8f9keZLXcMsjnkf131EKzdjfEUOAqhKjU/DYviqlbc9hUVg/Cl+1FyqUkSw/?=
 =?us-ascii?Q?NOibNDuE0Yog+K0+5NqYDyIoQJltZBNf892VAGDgvD1UFJCPiuNFA2DktZ3f?=
 =?us-ascii?Q?hgX9m/6IsfmUCTqZ1WAvaBes6TTd/Mt27YtDvmTinr/sJgd5pQRO2XDe+hYL?=
 =?us-ascii?Q?+MV97favyZeR/v3YmjICYW+cygUQwhwGyaahNUdLbZsmpSttkFAObmKHFib/?=
 =?us-ascii?Q?OOmQTzEF448=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(7416014)(82310400026)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2024 13:20:04.0491
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dab0a518-1e21-4297-2681-08dd07d3b6b7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD3.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8056

From: Ankit Agrawal <ankita@nvidia.com>

Currently KVM determines if a VMA is pointing at IO memory by checking
pfn_is_map_memory(). However, the MM already gives us a way to tell what
kind of memory it is by inspecting the VMA.

This patch solves the problems where it is possible for the kernel to
have VMAs pointing at cachable memory without causing
pfn_is_map_memory() to be true, eg DAX memremap cases and CXL/pre-CXL
devices. This memory is now properly marked as cachable in KVM.

The pfn_is_map_memory() is restrictive and allows only for the memory
that is added to the kernel to be marked as cacheable. In most cases
the code needs to know if there is a struct page, or if the memory is
in the kernel map and pfn_valid() is an appropriate API for this.
Extend the umbrella with pfn_valid() to include memory with no struct
pages for consideration to be mapped cacheable in stage 2. A !pfn_valid()
implies that the memory is unsafe to be mapped as cacheable.

Moreover take account of the mapping type in the VMA to make a decision
on the mapping. The VMA's pgprot is tested to determine the memory type
with the following mapping:
 pgprot_noncached    MT_DEVICE_nGnRnE   device (or Normal_NC)
 pgprot_writecombine MT_NORMAL_NC       device (or Normal_NC)
 pgprot_device       MT_DEVICE_nGnRE    device (or Normal_NC)
 pgprot_tagged       MT_NORMAL_TAGGED   RAM / Normal
 -                   MT_NORMAL          RAM / Normal

Also take care of the following two cases that prevents the memory to
be safely mapped as cacheable:
1. The VMA pgprot have VM_IO set alongwith MT_NORMAL or
   MT_NORMAL_TAGGED. Although unexpected and wrong, presence of such
   configuration cannot be ruled out.
2. Configurations where VM_MTE_ALLOWED is not set and KVM_CAP_ARM_MTE
   is enabled. Otherwise a malicious guest can enable MTE at stage 1
   without the hypervisor being able to tell. This could cause external
   aborts.

Introduce a new variable noncacheable to represent whether the memory
should not be mapped as cacheable. The noncacheable as false implies
the memory is safe to be mapped cacheable. Use this to handle the
aforementioned potentially unsafe cases for cacheable mapping.

Note when FWB is not enabled, the kernel expects to trivially do
cache management by flushing the memory by linearly converting a
kvm_pte to phys_addr to a KVA, see kvm_flush_dcache_to_poc(). This is
only possibile for struct page backed memory. Do not allow non-struct
page memory to be cachable without FWB.

The device memory such as on the Grace Hopper systems is interchangeable
with DDR memory and retains its properties. Allow executable faults
on the memory determined as Normal cacheable.

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
---
 arch/arm64/include/asm/kvm_pgtable.h |   8 +++
 arch/arm64/kvm/hyp/pgtable.c         |   2 +-
 arch/arm64/kvm/mmu.c                 | 101 +++++++++++++++++++++------
 3 files changed, 87 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index aab04097b505..c41ba415c5e4 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -502,6 +502,14 @@ u64 kvm_pgtable_hyp_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size);
  */
 u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift);
 
+/**
+ * stage2_has_fwb() - Determine whether FWB is supported
+ * @pgt:    Page-table structure initialised by kvm_pgtable_stage2_init*()
+ *
+ * Return: True if FWB is supported.
+ */
+bool stage2_has_fwb(struct kvm_pgtable *pgt);
+
 /**
  * kvm_pgtable_stage2_pgd_size() - Helper to compute size of a stage-2 PGD
  * @vtcr:	Content of the VTCR register.
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 40bd55966540..4417651e2b1c 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -642,7 +642,7 @@ u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift)
 	return vtcr;
 }
 
-static bool stage2_has_fwb(struct kvm_pgtable *pgt)
+bool stage2_has_fwb(struct kvm_pgtable *pgt)
 {
 	if (!cpus_have_final_cap(ARM64_HAS_STAGE2_FWB))
 		return false;
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index c9d46ad57e52..9bf5c3e89d6d 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -180,11 +180,6 @@ int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm,
 	return 0;
 }
 
-static bool kvm_is_device_pfn(unsigned long pfn)
-{
-	return !pfn_is_map_memory(pfn);
-}
-
 static void *stage2_memcache_zalloc_page(void *arg)
 {
 	struct kvm_mmu_memory_cache *mc = arg;
@@ -1430,6 +1425,23 @@ static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
 	return vma->vm_flags & VM_MTE_ALLOWED;
 }
 
+/*
+ * Determine the memory region cacheability from VMA's pgprot. This
+ * is used to set the stage 2 PTEs.
+ */
+static unsigned long mapping_type(pgprot_t page_prot)
+{
+	return FIELD_GET(PTE_ATTRINDX_MASK, pgprot_val(page_prot));
+}
+
+/*
+ * Determine if the mapping type is normal cacheable.
+ */
+static bool mapping_type_normal_cacheable(unsigned long mt)
+{
+	return (mt == MT_NORMAL || mt == MT_NORMAL_TAGGED);
+}
+
 static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  struct kvm_s2_trans *nested,
 			  struct kvm_memory_slot *memslot, unsigned long hva,
@@ -1438,8 +1450,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	int ret = 0;
 	bool write_fault, writable, force_pte = false;
 	bool exec_fault, mte_allowed;
-	bool device = false, vfio_allow_any_uc = false;
+	bool noncacheable = false, vfio_allow_any_uc = false;
 	unsigned long mmu_seq;
+	unsigned long mt;
 	phys_addr_t ipa = fault_ipa;
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
@@ -1568,6 +1581,17 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 	vfio_allow_any_uc = vma->vm_flags & VM_ALLOW_ANY_UNCACHED;
 
+	mt = mapping_type(vma->vm_page_prot);
+
+	/*
+	 * Check for potentially ineligible or unsafe conditions for
+	 * cacheable mappings.
+	 */
+	if (vma->vm_flags & VM_IO)
+		noncacheable = true;
+	else if (!mte_allowed && kvm_has_mte(kvm))
+		noncacheable = true;
+
 	/* Don't use the VMA after the unlock -- it may have vanished */
 	vma = NULL;
 
@@ -1591,19 +1615,15 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (is_error_noslot_pfn(pfn))
 		return -EFAULT;
 
-	if (kvm_is_device_pfn(pfn)) {
-		/*
-		 * If the page was identified as device early by looking at
-		 * the VMA flags, vma_pagesize is already representing the
-		 * largest quantity we can map.  If instead it was mapped
-		 * via __kvm_faultin_pfn(), vma_pagesize is set to PAGE_SIZE
-		 * and must not be upgraded.
-		 *
-		 * In both cases, we don't let transparent_hugepage_adjust()
-		 * change things at the last minute.
-		 */
-		device = true;
-	} else if (logging_active && !write_fault) {
+	/*
+	 * pfn_valid() indicates to the code if there is a struct page, or
+	 * if the memory is in the kernel map. Any memory region otherwise
+	 * is unsafe to be cacheable.
+	 */
+	if (!pfn_valid(pfn))
+		noncacheable = true;
+
+	if (!noncacheable && logging_active && !write_fault) {
 		/*
 		 * Only actually map the page as writable if this was a write
 		 * fault.
@@ -1611,7 +1631,11 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		writable = false;
 	}
 
-	if (exec_fault && device)
+	/*
+	 * Do not allow exec fault; unless the memory is determined safely
+	 * to be Normal cacheable.
+	 */
+	if (exec_fault && (noncacheable || !mapping_type_normal_cacheable(mt)))
 		return -ENOEXEC;
 
 	/*
@@ -1641,10 +1665,19 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	}
 
 	/*
+	 * If the page was identified as device early by looking at
+	 * the VMA flags, vma_pagesize is already representing the
+	 * largest quantity we can map.  If instead it was mapped
+	 * via gfn_to_pfn_prot(), vma_pagesize is set to PAGE_SIZE
+	 * and must not be upgraded.
+	 *
+	 * In both cases, we don't let transparent_hugepage_adjust()
+	 * change things at the last minute.
+	 *
 	 * If we are not forced to use page mapping, check if we are
 	 * backed by a THP and thus use block mapping if possible.
 	 */
-	if (vma_pagesize == PAGE_SIZE && !(force_pte || device)) {
+	if (vma_pagesize == PAGE_SIZE && !(force_pte || noncacheable)) {
 		if (fault_is_perm && fault_granule > PAGE_SIZE)
 			vma_pagesize = fault_granule;
 		else
@@ -1658,7 +1691,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		}
 	}
 
-	if (!fault_is_perm && !device && kvm_has_mte(kvm)) {
+	if (!fault_is_perm && !noncacheable && kvm_has_mte(kvm)) {
 		/* Check the VMM hasn't introduced a new disallowed VMA */
 		if (mte_allowed) {
 			sanitise_mte_tags(kvm, pfn, vma_pagesize);
@@ -1674,7 +1707,15 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (exec_fault)
 		prot |= KVM_PGTABLE_PROT_X;
 
-	if (device) {
+	/*
+	 * If any of the following pgprot modifiers are applied on the pgprot,
+	 * consider as device memory and map in Stage 2 as device or
+	 * Normal noncached:
+	 * pgprot_noncached
+	 * pgprot_writecombine
+	 * pgprot_device
+	 */
+	if (!mapping_type_normal_cacheable(mt)) {
 		if (vfio_allow_any_uc)
 			prot |= KVM_PGTABLE_PROT_NORMAL_NC;
 		else
@@ -1684,6 +1725,20 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		prot |= KVM_PGTABLE_PROT_X;
 	}
 
+	/*
+	 *  When FWB is unsupported KVM needs to do cache flushes
+	 *  (via dcache_clean_inval_poc()) of the underlying memory. This is
+	 *  only possible if the memory is already mapped into the kernel map
+	 *  at the usual spot.
+	 *
+	 *  Validate that there is a struct page for the PFN which maps
+	 *  to the KVA that the flushing code expects.
+	 */
+	if (!stage2_has_fwb(pgt) && !(pfn_valid(pfn))) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
 	/*
 	 * Under the premise of getting a FSC_PERM fault, we just need to relax
 	 * permissions only if vma_pagesize equals fault_granule. Otherwise,
-- 
2.34.1


