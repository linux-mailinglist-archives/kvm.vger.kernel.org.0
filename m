Return-Path: <kvm+bounces-9600-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AE3C98625BD
	for <lists+kvm@lfdr.de>; Sat, 24 Feb 2024 16:07:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 400CE1F21293
	for <lists+kvm@lfdr.de>; Sat, 24 Feb 2024 15:07:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AF3347F45;
	Sat, 24 Feb 2024 15:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SXgkrcyg"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1102845028;
	Sat, 24 Feb 2024 15:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708787208; cv=fail; b=lBsR/UMOkt9WYBrpQK5L2KpYGyKiy6YyyfT2zP9EPMvLzaRu8xeYvhkbBTxIdAVwlqvgH56kERPj9diDmh/F4KX3SyArlgUrISKBFrfoetHIOQ00hAs+XqYTTuuhGTSIfVFsJj24JqRM/d4OUFxFjs2VSnbPP8Mr11I5VWM5XVY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708787208; c=relaxed/simple;
	bh=tL7r2pYgaagNi2wFb+1R/MLMAvs9Ts73KeVLjlQyQ2M=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AavaQ3GwVBJuHWdeoQc0fo2RvHQPu1s/KXre6VcNiGl7OqiZTouTDutA7mu/QyXyy0zWLtVQkji1AzavlO1JHRxxUD3H7fUzVqNW/ZTA8M35EriIYxdyNGFMQMOg/AU869oGMSqwGglYIbcPRpuVgy2WIDMaHXdffhR5/dI12ic=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SXgkrcyg; arc=fail smtp.client-ip=40.107.236.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=drlMwsPgMfPZfLwtt8UTVsNDEbJP0+HNrYED83tXrc+yHCoK8Da0AcPxDUZwMILLZ80IedscILEb1cvsjAZMzW2yjiCzkGWaltOHcJ8Xlv9OAttB8V/eBYpJ8ZpFPAAI72+GMCPPiKfQJvtxZu0V++Bf9U1XYTKSLT2vDDxFnwKbVbJSQOjNouu3yYWqZcQsUHzNH8KcrCEFGjqfLnOd8evn2MGecuoEnMQTULevhAxuWcCLqGa1vRj84ibaYnaQpsD5Dr1stlcFquFYc2S1f3M+nCV7XrnbK8R4eeO1zrLI8s/6vwq6xJ/Z/HnR8cDijLJ5uEmQqYtn63ljwPETGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h+ywp5UkykNQ3aMvxMGYYpq4jSVqAUBUPb6JArHzsYQ=;
 b=iN/MOTlYwwEDYhe9VkMh+gi2EZylXBETaoOz9okFLYTioopFJ2t4kXbg6WyeWybMVigEEcR1hPoB7WAUUUjwRxl/GofD4I1scvwrvkJ8dMSfgnfUi0/i360Bv2CJnSm3VoXDVG0VdsamEg1YMsJ6yOOKCJl7oxn1YyayANAnuJVUMQ20FTQAsI7r4t3zDIYtGzH7Aj/6wZ9g+SruEuXQMwFeUVne48ZzA+2GecYaP5VB4gpVbcoSqcmeWN6xJb8u0LgfZQ1IN/oVBYAg/lhG3/bG3H9oSmeADn4LBORz8bENUcIvH8XE0/8rW0LWoyg8zCgFxmr5HVnkmq6js2xkDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h+ywp5UkykNQ3aMvxMGYYpq4jSVqAUBUPb6JArHzsYQ=;
 b=SXgkrcygcSTHP8wbjQ7+oBvd/hdvVS6iW88wK0z+SrrHjSXX8AOKkvlqsjEpU+kwSAjuaollMjGTENEcXy6/3QPZCpisyLYjweDRYLoBmh19+xffQQbHqm1tQtHCq7jIPKrD+o9QyJwuqvY6p7BPQciizTDwLggBi1jKU9BtrbtxNm6whkMWCFBkJuZ8xiz9oCsd/NJddPkMVT+VgNGaiND/1p9LZCj9r8GySJWoRBnwdvGuFOWZJxOW9R08hCPw46XtRZi2yYs4lDsjrhB1W9rMW6y1yamDyG0x+SUwQ5wWPqVi6eAR8ZheqMDhim2ti0aa+Z2PY/ErvtpflsdSpA==
Received: from CH2PR07CA0014.namprd07.prod.outlook.com (2603:10b6:610:20::27)
 by DM8PR12MB5446.namprd12.prod.outlook.com (2603:10b6:8:3c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.27; Sat, 24 Feb
 2024 15:06:41 +0000
Received: from DS3PEPF000099D4.namprd04.prod.outlook.com
 (2603:10b6:610:20:cafe::2) by CH2PR07CA0014.outlook.office365.com
 (2603:10b6:610:20::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.48 via Frontend
 Transport; Sat, 24 Feb 2024 15:06:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS3PEPF000099D4.mail.protection.outlook.com (10.167.17.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7292.25 via Frontend Transport; Sat, 24 Feb 2024 15:06:41 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Sat, 24 Feb
 2024 07:06:24 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12; Sat, 24 Feb
 2024 07:06:13 -0800
Received: from sgarnayak-dt.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12 via Frontend
 Transport; Sat, 24 Feb 2024 07:06:01 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <maz@kernel.org>,
	<oliver.upton@linux.dev>, <james.morse@arm.com>, <suzuki.poulose@arm.com>,
	<yuzenghui@huawei.com>, <reinette.chatre@intel.com>, <surenb@google.com>,
	<stefanha@redhat.com>, <brauner@kernel.org>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <mark.rutland@arm.com>, <alex.williamson@redhat.com>,
	<kevin.tian@intel.com>, <yi.l.liu@intel.com>, <ardb@kernel.org>,
	<akpm@linux-foundation.org>, <andreyknvl@gmail.com>,
	<wangjinchao@xfusion.com>, <gshan@redhat.com>, <shahuang@redhat.com>,
	<ricarkol@google.com>, <linux-mm@kvack.org>, <lpieralisi@kernel.org>,
	<rananta@google.com>, <ryan.roberts@arm.com>, <david@redhat.com>,
	<linus.walleij@linaro.org>, <bhe@redhat.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<kvmarm@lists.linux.dev>, <mochs@nvidia.com>, <zhiw@nvidia.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v9 1/4] KVM: arm64: Introduce new flag for non-cacheable IO memory
Date: Sat, 24 Feb 2024 20:35:43 +0530
Message-ID: <20240224150546.368-2-ankita@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20240224150546.368-1-ankita@nvidia.com>
References: <20240224150546.368-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D4:EE_|DM8PR12MB5446:EE_
X-MS-Office365-Filtering-Correlation-Id: 08e102a7-c499-4a76-2f5b-08dc354a3502
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	hJcFBXTXVG92cGb3AUrTD742IXiqCbacmyRbv9T786km35QxkxujHhp5rdWJsyf+3L+vONSO4ZBkuZu4J8GbABY+URnkgbx2BXWtwuBIBIcR5q9VqsgRVzGGrd09aNycB+/VDT8KoCdlGvN7jQLA1+urEBtl/Q52A30k5wXdLbnx2PWotd1G/VRL43/jMY1GzytyxOx9pNUT7pMFwzWQxiWsuheh1JsZu0hwE9OXP14+WFCXRidy6ZftObZ03uKqs/lNR78XvbMwlfHrg2kaAl1ntcMbEpJz3dZ/r8gWY8yFJJUN+lfqECDt4l0u/Ggora0aOOQwXJ0uKzxHAC5fTnNCwWp5FjerEb/mZEwsvoOGJluX0HiLp5lCw+yIt3l9UuRBGMGvgsY9HwskjTffvi70mu4P1JJmaAGEicFIT7vH8+4LObQsOcXgiLstfXBrRCPiiMvP5f6R685wDaiUpdNRKrbpzFHQthnPqvjad6B4zFtZGmAFQdOAbvedinhE05NMa5vnhfaArP1aMDUiXX6BuNKA3ecyyESpdRY2fYBijtpDiO3POFWa1kQO0PtVLM/vX3PaWfyyEixMB0xZyQDDrWIPEf5sQrIw55nCmh7ujbpmkm+sLomN3Mbgt+LEyfaypeKbCrSmuDF/+lJRu4IpuRDf658PipSz37IoeMnGKfEjxWT9demrYxIi5n6VQjZpEIwc9i4gjcglad8vvA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(36860700004)(40470700004)(46966006)(921011);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2024 15:06:41.0611
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 08e102a7-c499-4a76-2f5b-08dc354a3502
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D4.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5446

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
from DEVICE_nGnRE to Normal-NC.

The NormalNC was chosen over a different Normal memory type default
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

A Normal-NC flag is not present today. So add a new kvm_pgtable_prot
(KVM_PGTABLE_PROT_NORMAL_NC) flag for it, along with its
corresponding PTE value 0x5 (0b101) determined from [1].

Lastly, adapt the stage2 PTE property setter function
(stage2_set_prot_attr) to handle the NormalNC attribute.

The entire discussion leading to this patch series may be followed through
the following links.
Link: https://lore.kernel.org/all/20230907181459.18145-3-ankita@nvidia.com
Link: https://lore.kernel.org/r/20231205033015.10044-1-ankita@nvidia.com

[1] section D8.5.5 - DDI0487J_a_a-profile_architecture_reference_manual.pdf
[2] section B2.8 - DDI0487J_a_a-profile_architecture_reference_manual.pdf
[3] sections 1.7.7.3/1.8.5.2/appendix C - DEN0029H_SBSA_7.1.pdf

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Will Deacon <will@kernel.org>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 arch/arm64/include/asm/kvm_pgtable.h |  2 ++
 arch/arm64/include/asm/memory.h      |  2 ++
 arch/arm64/kvm/hyp/pgtable.c         | 24 +++++++++++++++++++-----
 3 files changed, 23 insertions(+), 5 deletions(-)

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
index d82305ab420f..449ca2ff1df6 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -173,6 +173,7 @@
  * Memory types for Stage-2 translation
  */
 #define MT_S2_NORMAL		0xf
+#define MT_S2_NORMAL_NC		0x5
 #define MT_S2_DEVICE_nGnRE	0x1
 
 /*
@@ -180,6 +181,7 @@
  * Stage-2 enforces Normal-WB and Device-nGnRE
  */
 #define MT_S2_FWB_NORMAL	6
+#define MT_S2_FWB_NORMAL_NC	5
 #define MT_S2_FWB_DEVICE_nGnRE	1
 
 #ifdef CONFIG_ARM64_4K_PAGES
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index ab9d05fcf98b..3fae5830f8d2 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -717,15 +717,29 @@ void kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
 static int stage2_set_prot_attr(struct kvm_pgtable *pgt, enum kvm_pgtable_prot prot,
 				kvm_pte_t *ptep)
 {
-	bool device = prot & KVM_PGTABLE_PROT_DEVICE;
-	kvm_pte_t attr = device ? KVM_S2_MEMATTR(pgt, DEVICE_nGnRE) :
-			    KVM_S2_MEMATTR(pgt, NORMAL);
+	kvm_pte_t attr;
 	u32 sh = KVM_PTE_LEAF_ATTR_LO_S2_SH_IS;
 
+	switch (prot & (KVM_PGTABLE_PROT_DEVICE |
+			KVM_PGTABLE_PROT_NORMAL_NC)) {
+	case KVM_PGTABLE_PROT_DEVICE | KVM_PGTABLE_PROT_NORMAL_NC:
+		return -EINVAL;
+	case KVM_PGTABLE_PROT_DEVICE:
+		if (prot & KVM_PGTABLE_PROT_X)
+			return -EINVAL;
+		attr = KVM_S2_MEMATTR(pgt, DEVICE_nGnRE);
+		break;
+	case KVM_PGTABLE_PROT_NORMAL_NC:
+		if (prot & KVM_PGTABLE_PROT_X)
+			return -EINVAL;
+		attr = KVM_S2_MEMATTR(pgt, NORMAL_NC);
+		break;
+	default:
+		attr = KVM_S2_MEMATTR(pgt, NORMAL);
+	}
+
 	if (!(prot & KVM_PGTABLE_PROT_X))
 		attr |= KVM_PTE_LEAF_ATTR_HI_S2_XN;
-	else if (device)
-		return -EINVAL;
 
 	if (prot & KVM_PGTABLE_PROT_R)
 		attr |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;
-- 
2.34.1


