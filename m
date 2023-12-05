Return-Path: <kvm+bounces-3448-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A58938046B8
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 04:30:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C8DD81C20D35
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 03:30:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4ECF48F5B;
	Tue,  5 Dec 2023 03:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="X384cqG8"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6B04FA;
	Mon,  4 Dec 2023 19:30:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OOx5NOB1JreL6KpZJ3sdcihs5tDpzNFdQ8fPP6oDMAncn6KJql97lYfrxLfilt60MCiDnVuOt6slbs5jWJZavDCP90oWZxDob3BpkVLiNTO+GlEpV2+sFLu/nKGpWmpVqOUFLT7RF0EImLwBSRmJ6wu9aaz6dg3LM2H2ndOA//h46dq73lxjwtQGADIHykq8rRTwPyuXgk2vIfGsTZENHte9QfK5SItnj4ld5pOE+n9iUa8iV6DzRd0WUKzTPPpVBJ245C8GXV8qZ9dnrhKKpFGkQkgH55CrjPyoQ7nLL0f9p+rRARTbtGpAP1zoJs8pjPZrZPbUsDlZ7Haan+UiOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7cAuxF8Kn9+pvGSZ6X8netnO3Qu+fHNWvoXtngfV3Tw=;
 b=amvdcvewLugT53a9rttI9u10/Fa2pgTp+2o4luUGTTTHYaE8gurKGcEFVR8Y75DWYjSU7y0Q+zg9ZfaqL0YMbXIRCQUaXusiPTDZjgorWiuU4jai+r4PWItR3KEpRAYJ3vD8mx9I6iw1VMc1DyR8+kaYF24lYraezjhib69Xhqec2pK5iREBwEBEKsPtgGmXevXBJkYknmva1ZO548t15iX59KmRl+X68TwaYlb44DppWrjxPqiGPSPVK+tX3BPYxvXdS1oDtUuI7da68k3mv41L/l6T+GOxl4dCCGbryvxxuJnpkYbp9zVqE+TqP/mHSGyZhliMNara8eiHIrsG8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7cAuxF8Kn9+pvGSZ6X8netnO3Qu+fHNWvoXtngfV3Tw=;
 b=X384cqG8i2EK5XsUQ7ey/zhsJYxkskF0Gc7CuOOo+54Jd5IuzvWc9KxspMPV5ujMPLR1GD/4tEE+pitmGy53B3oNz8tyC0BBMdZJsIVOQU6//EEqBuaDhl3mC2z2Noe69LID7nFgxx9JD5vnB40mbmt0W7mREpDDDJmFlor6a/U+7C3o7sqOb5xxvTEz7kTvLMlT560TOStEDn0n+ezOlFBZ7P8MqOyhEyqhNmP2sBQqnb6Tnt4Y2rOtfdT0sgpaDRtOiwO/kp1d5v6SRGmTjE7fuo+TsHvZVW/3FpHgDPTR7LzkjOHJQLUgD6FwhIKVePFeLPHvEGdSm0xAWXpn/A==
Received: from SN6PR2101CA0024.namprd21.prod.outlook.com
 (2603:10b6:805:106::34) by CH0PR12MB5267.namprd12.prod.outlook.com
 (2603:10b6:610:d2::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.33; Tue, 5 Dec
 2023 03:30:39 +0000
Received: from SN1PEPF0002BA4B.namprd03.prod.outlook.com
 (2603:10b6:805:106:cafe::74) by SN6PR2101CA0024.outlook.office365.com
 (2603:10b6:805:106::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.4 via Frontend
 Transport; Tue, 5 Dec 2023 03:30:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SN1PEPF0002BA4B.mail.protection.outlook.com (10.167.242.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7068.20 via Frontend Transport; Tue, 5 Dec 2023 03:30:39 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 4 Dec 2023
 19:30:24 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 4 Dec 2023
 19:30:24 -0800
Received: from sgarnayak-dt.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41 via Frontend
 Transport; Mon, 4 Dec 2023 19:30:17 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <maz@kernel.org>,
	<oliver.upton@linux.dev>, <suzuki.poulose@arm.com>, <yuzenghui@huawei.com>,
	<catalin.marinas@arm.com>, <will@kernel.org>, <ardb@kernel.org>,
	<akpm@linux-foundation.org>, <gshan@redhat.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<mochs@nvidia.com>, <kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v2 1/1] KVM: arm64: allow the VM to select DEVICE_* and NORMAL_NC for IO memory
Date: Tue, 5 Dec 2023 09:00:15 +0530
Message-ID: <20231205033015.10044-1-ankita@nvidia.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA4B:EE_|CH0PR12MB5267:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ba8b90a-e5e6-40ea-cc06-08dbf5428d8e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	4JXN16TdIvZ8Y8Rsfqilo28R1DG5hoy7MJZg9qaupDMgPf63BLliycvYizaetoKVmvDDdYU2Y29OmPOMFR2nI02umzgbgJC3ar+cAFrOarpLNEOI+jDgv79MDTskAiGLOymQOivqJnTkG80TkCYYJ4Y3cBMAHwoeKp0KUl3Kmd0E0SU0+ftrISBzKmgdua93JzXjGeQmDs0s68GWxN09n5AQfuDJ4KhY0X40oisJKkjYZO2CJdq0WjwvbhhooYQvamOi09nFqfvRfPN430eIKHy3Ln2UrmFuCqHBcaar6z5nGSOXCeAkvVhbZ4mVBl4nTEjQ9ydK580AhS3n32cZe14l82JL3ykzAhKYiQOerv3KzsWmOe3jfNirtldodQqWYCJCdfUnGALE2yQsk4o0UVn9y67E+A7YbWmHXB50zpJ7vysP+1CJOogHCsVcShdVyW0MBKa4/vaULOYZvSzwUhe4Q3NdSCQWqKvTyEhdIEevuAbHhhvdvYUoxOAHHtbVp+95HLKdNriffpTyB3fHo1S4eIalqXpKBjThHsXGTIg9jqgqGxCKVZUKHZc+H5kj4J733+Ku1HekFRpqH9trsEHPwdt0G7gaKxhe/s81BnLk44gZjoy5si51PLTgvb3SX4sOEIr3W0WLyqRq+W5MW61YIDqbInnyMPnU7CA9D/we0PD5C+VY2eegsT8KlHfBTnvYkVgI90WTaNU8WemcwENdJbCzSFJPIQQd2FT00CzxWI3/q8KHOCQOhoH4X+Yr84svNe2EQCjAO0T8/EHy0IjPM+7vGpvzrhzdmT2RTR3ofqprzk1ik4Hdm6w69ntL3GiKYfk2KaKvrrrxBLhNlJTxxao6o6A5x7pJmvxB5FdsRaAqzelU9NP4ma0+AUtz
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(39860400002)(136003)(346002)(376002)(230922051799003)(186009)(451199024)(64100799003)(82310400011)(1800799012)(36840700001)(40470700004)(46966006)(316002)(54906003)(110136005)(70206006)(70586007)(40460700003)(966005)(478600001)(5660300002)(7416002)(921008)(41300700001)(36756003)(19627235002)(2906002)(2876002)(4326008)(8676002)(8936002)(86362001)(83380400001)(2616005)(47076005)(36860700001)(356005)(7636003)(82740400003)(426003)(336012)(26005)(1076003)(40480700001)(7696005)(21314003)(83996005)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2023 03:30:39.3243
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ba8b90a-e5e6-40ea-cc06-08dbf5428d8e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA4B.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5267

From: Ankit Agrawal <ankita@nvidia.com>

Currently, KVM for ARM64 maps at stage 2 memory that is considered device
(i.e. it is not RAM) with DEVICE_nGnRE memory attributes; this setting
overrides (as per the ARM architecture [1]) any device MMIO mapping
present at stage 1, resulting in a set-up whereby a guest operating
system cannot determine device MMIO mapping memory attributes on its
own but it is always overridden by the KVM stage 2 default.

This set-up does not allow guest operating systems to select device
memory attributes independently from KVM stage-2 mappings
(refer to [1], "Combining stage 1 and stage 2 memory type attributes"),
which turns out to be an issue in that guest operating systems
(e.g. Linux) may request to map devices MMIO regions with memory
attributes that guarantee better performance (e.g. gathering
attribute - that for some devices can generate larger PCIe memory
writes TLPs) and specific operations (e.g. unaligned transactions)
such as the NormalNC memory type.

The default device stage 2 mapping was chosen in KVM for ARM64 since
it was considered safer (i.e. it would not allow guests to trigger
uncontained failures ultimately crashing the machine) but this
turned out to be asynchronous (SError) defeating the purpose.

Failures containability is a property of the platform and is independent
from the memory type used for MMIO device memory mappings.

Actually, DEVICE_nGnRE memory type is even more problematic than
Normal-NC memory type in terms of faults containability in that e.g.
aborts triggered on DEVICE_nGnRE loads cannot be made, architecturally,
synchronous (i.e. that would imply that the processor should issue at
most 1 load transaction at a time - it cannot pipeline them - otherwise
the synchronous abort semantics would break the no-speculation attribute
attached to DEVICE_XXX memory).

This means that regardless of the combined stage1+stage2 mappings a
platform is safe if and only if device transactions cannot trigger
uncontained failures and that in turn relies on platform capabilities
and the device type being assigned (i.e. PCIe AER/DPC error containment
and RAS architecture[3]); therefore the default KVM device stage 2
memory attributes play no role in making device assignment safer
for a given platform (if the platform design adheres to design
guidelines outlined in [3]) and therefore can be relaxed.

For all these reasons, relax the KVM stage 2 device memory attributes
from DEVICE_nGnRE to Normal-NC. Add a new kvm_pgtable_prot flag for
Normal-NC.

The Normal-NC was chosen over a different Normal memory type default
at stage-2 (e.g. Normal Write-through) to avoid cache allocation/snooping.

Relaxing S2 KVM device MMIO mappings to Normal-NC is not expected to
trigger any issue on guest device reclaim use cases either (i.e. device
MMIO unmap followed by a device reset) at least for PCIe devices, in that
in PCIe a device reset is architected and carried out through PCI config
space transactions that are naturally ordered with respect to MMIO
transactions according to the PCI ordering rules.

Having Normal-NC S2 default puts guests in control (thanks to
stage1+stage2 combined memory attributes rules [1]) of device MMIO
regions memory mappings, according to the rules described in [1]
and summarized here ([(S1) - stage1], [(S2) - stage 2]):

S1           |  S2           | Result
NORMAL-WB    |  NORMAL-NC    | NORMAL-NC
NORMAL-WT    |  NORMAL-NC    | NORMAL-NC
NORMAL-NC    |  NORMAL-NC    | NORMAL-NC
DEVICE<attr> |  NORMAL-NC    | DEVICE<attr>

It is worth noting that currently, to map devices MMIO space to user
space in a device pass-through use case the VFIO framework applies memory
attributes derived from pgprot_noncached() settings applied to VMAs, which
result in device-nGnRnE memory attributes for the stage-1 VMM mappings.

This means that a userspace mapping for device MMIO space carried
out with the current VFIO framework and a guest OS mapping for the same
MMIO space may result in a mismatched alias as described in [2].

Defaulting KVM device stage-2 mappings to Normal-NC attributes does not
change anything in this respect, in that the mismatched aliases would
only affect (refer to [2] for a detailed explanation) ordering between
the userspace and GuestOS mappings resulting stream of transactions
(i.e. it does not cause loss of property for either stream of
transactions on its own), which is harmless given that the userspace
and GuestOS access to the device is carried out through independent
transactions streams.

[1] section D8.5 - DDI0487_I_a_a-profile_architecture_reference_manual.pdf
[2] section B2.8 - DDI0487_I_a_a-profile_architecture_reference_manual.pdf
[3] sections 1.7.7.3/1.8.5.2/appendix C - DEN0029H_SBSA_7.1.pdf

Applied over next-20231201

History
=======
v1 -> v2
- Updated commit log to the one posted by
  Lorenzo Pieralisi <lpieralisi@kernel.org> (Thanks!)
- Added new flag to represent the NORMAL_NC setting. Updated
  stage2_set_prot_attr() to handle new flag.

v1 Link:
https://lore.kernel.org/all/20230907181459.18145-3-ankita@nvidia.com/

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Tested-by: Ankit Agrawal <ankita@nvidia.com>

---
 arch/arm64/include/asm/kvm_pgtable.h |  2 ++
 arch/arm64/include/asm/memory.h      |  2 ++
 arch/arm64/kvm/hyp/pgtable.c         | 11 +++++++++--
 arch/arm64/kvm/mmu.c                 |  4 ++--
 4 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index cfdf40f734b1..19278dfe7978 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -197,6 +197,7 @@ enum kvm_pgtable_stage2_flags {
  * @KVM_PGTABLE_PROT_W:		Write permission.
  * @KVM_PGTABLE_PROT_R:		Read permission.
  * @KVM_PGTABLE_PROT_DEVICE:	Device attributes.
+ * @KVM_PGTABLE_PROT_NORMAL_NC:	Normal noncacheable attributes.
  * @KVM_PGTABLE_PROT_SW0:	Software bit 0.
  * @KVM_PGTABLE_PROT_SW1:	Software bit 1.
  * @KVM_PGTABLE_PROT_SW2:	Software bit 2.
@@ -208,6 +209,7 @@ enum kvm_pgtable_prot {
 	KVM_PGTABLE_PROT_R			= BIT(2),
 
 	KVM_PGTABLE_PROT_DEVICE			= BIT(3),
+	KVM_PGTABLE_PROT_NORMAL_NC		= BIT(4),
 
 	KVM_PGTABLE_PROT_SW0			= BIT(55),
 	KVM_PGTABLE_PROT_SW1			= BIT(56),
diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index fde4186cc387..c247e5f29d5a 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -147,6 +147,7 @@
  * Memory types for Stage-2 translation
  */
 #define MT_S2_NORMAL		0xf
+#define MT_S2_NORMAL_NC		0x5
 #define MT_S2_DEVICE_nGnRE	0x1
 
 /*
@@ -154,6 +155,7 @@
  * Stage-2 enforces Normal-WB and Device-nGnRE
  */
 #define MT_S2_FWB_NORMAL	6
+#define MT_S2_FWB_NORMAL_NC	5
 #define MT_S2_FWB_DEVICE_nGnRE	1
 
 #ifdef CONFIG_ARM64_4K_PAGES
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index c651df904fe3..d4835d553c61 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -718,10 +718,17 @@ static int stage2_set_prot_attr(struct kvm_pgtable *pgt, enum kvm_pgtable_prot p
 				kvm_pte_t *ptep)
 {
 	bool device = prot & KVM_PGTABLE_PROT_DEVICE;
-	kvm_pte_t attr = device ? KVM_S2_MEMATTR(pgt, DEVICE_nGnRE) :
-			    KVM_S2_MEMATTR(pgt, NORMAL);
+	bool normal_nc = prot & KVM_PGTABLE_PROT_NORMAL_NC;
+	kvm_pte_t attr;
 	u32 sh = KVM_PTE_LEAF_ATTR_LO_S2_SH_IS;
 
+	if (device)
+		attr = KVM_S2_MEMATTR(pgt, DEVICE_nGnRE);
+	else if (normal_nc)
+		attr = KVM_S2_MEMATTR(pgt, NORMAL_NC);
+	else
+		attr = KVM_S2_MEMATTR(pgt, NORMAL);
+
 	if (!(prot & KVM_PGTABLE_PROT_X))
 		attr |= KVM_PTE_LEAF_ATTR_HI_S2_XN;
 	else if (device)
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index d14504821b79..1cb302457d3f 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1071,7 +1071,7 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 	struct kvm_mmu_memory_cache cache = { .gfp_zero = __GFP_ZERO };
 	struct kvm_s2_mmu *mmu = &kvm->arch.mmu;
 	struct kvm_pgtable *pgt = mmu->pgt;
-	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_DEVICE |
+	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_NORMAL_NC |
 				     KVM_PGTABLE_PROT_R |
 				     (writable ? KVM_PGTABLE_PROT_W : 0);
 
@@ -1558,7 +1558,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		prot |= KVM_PGTABLE_PROT_X;
 
 	if (device)
-		prot |= KVM_PGTABLE_PROT_DEVICE;
+		prot |= KVM_PGTABLE_PROT_NORMAL_NC;
 	else if (cpus_have_final_cap(ARM64_HAS_CACHE_DIC))
 		prot |= KVM_PGTABLE_PROT_X;
 
-- 
2.17.1


