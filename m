Return-Path: <kvm+bounces-9133-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C681F85B401
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 08:30:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 88448B20CB9
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 07:30:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 984B45B5C5;
	Tue, 20 Feb 2024 07:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Fb1zzZyZ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2043.outbound.protection.outlook.com [40.107.92.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8D055B5B0;
	Tue, 20 Feb 2024 07:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708414212; cv=fail; b=p8MZelSTvPq5GoCylrBpKvdTJW83F//ElGPGGFPwJbyPaFvKGSsticNpcG9VxXcuOyXcy5MraNB2ya86PkMo0qwOGE+dn1G3CvDdn9YCH9Ml12CAfZRf1Sjp29hXJSl7FKUm6Z4wslKn6WCX/QCsbmeG34AUdpRJ0HOz80BHf4Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708414212; c=relaxed/simple;
	bh=780PVv8kC9j5eEJN0oLKEiHjZzS2G4qjT6ZqZyDIqcw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bzUFM+xBCF1I2UxSZl0YIvbhTCS6JN2vVu4HfF0Q3bgIq6R8LdepA9XuU6LvomdcVn4+lJswxjoJ6qlydAyVks4kNyZIDSlQwT//vrpWaJUX2c7VXmb6A3haZUyqdo/DXSx2+O92s1W0tuKK7zOsAQCGNU5nr+UBgOgfLHOHe80=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Fb1zzZyZ; arc=fail smtp.client-ip=40.107.92.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P3Nzmg+kKXSG0HqpGZLC1vvl5GkDooT1pWOIfrqfiux0QFjTPIdYyqw8iAj3KHOoCUz+EI1TiKq/x04lgPcglQj9mjryDJYAthmbvZM2/wbW22ldGqSOZpBYBcepIorwRcxtFYzPmmE5bkGPS8aR0dVPJmDlCJQjIF8TM1ErG+4XquRKpRX1eHOnBlXiAbNVJhll2NF0hogJ1hu8K3jupaTisffkSUwbDqrAtRuJropxa7AFKbgZe8y2nHJxe4PuGFFSzG5ME71DMm3UxaJ5mzNkx1578M60bw6YS863B8BqoEcNlT0xzmZFff9Z+bXmut5wvQbsaj5s9H+q6Npx9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IoPzkQBrSXGbR3QNuq0ibVfzLWAru2X7Q0eQS9NWgiA=;
 b=M+TS2XTN2hxWoVQ2RwLeumuhHyunZ/hwPmgJrzbctQINnU+i11EmrsHyYL4tHA0wUe7Vu3vFJ1dJyRbQK3h3XaJB9kx0V5ORmTMTNSQvhEzGDfBgEOraLolEvuiZS07S4oWPEi+LyNDbv4gjpoQtPfJc7UF+na9tDDdJdcL6gx0CEwK2JZMfz+PKpzm89vFCFv/FYkiy62PUlAPXrW0PEjZPtSZB96lA+SLdZbyxOvN1XVVpYzlTQmoI9JfzR+xPsxnl8eUfUj1HUWOL14V9wWnOE3g7o4y7fiX6s4kg6qMDsMEfsBPXRS79mb34l6n3+OJDMbqFrNdONG4X9LJq2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IoPzkQBrSXGbR3QNuq0ibVfzLWAru2X7Q0eQS9NWgiA=;
 b=Fb1zzZyZeZUK8dbUIo5m44qdm7uD/cgq0OyiMqcdewqjvrtPmecQHd/WahS1OEs2VdM9Ck0ErSUKD3CalC58fvNTuUoh9RPobWbsOecp0CZoNWuhZIaDFM9R9cbTRcrB10OoY/P2OzLX1NrGlB33JkR1Kelqw+/Gp6SHzjM4/CAxfSPjW0GE7j1BsBOho1J956x71AP5w19IRXT8tMZowSsyLAqPI82dfj9qofacYH7bHVozd4F3QGd+RPVREiMLEG/SB1N+s3SOUkxSeatlLwHfQSDD3nC1xR/158iwVLLEM19nqOsuPkjt4kMUrI5r/l2eHFpNxAnr3lLONCUAaw==
Received: from DS7PR07CA0012.namprd07.prod.outlook.com (2603:10b6:5:3af::20)
 by DS7PR12MB6334.namprd12.prod.outlook.com (2603:10b6:8:95::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.25; Tue, 20 Feb
 2024 07:30:07 +0000
Received: from DS1PEPF00017099.namprd05.prod.outlook.com
 (2603:10b6:5:3af:cafe::c8) by DS7PR07CA0012.outlook.office365.com
 (2603:10b6:5:3af::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.40 via Frontend
 Transport; Tue, 20 Feb 2024 07:30:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS1PEPF00017099.mail.protection.outlook.com (10.167.18.103) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7292.25 via Frontend Transport; Tue, 20 Feb 2024 07:30:07 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 19 Feb
 2024 23:29:58 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12; Mon, 19 Feb
 2024 23:29:55 -0800
Received: from sgarnayak-dt.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12 via Frontend
 Transport; Mon, 19 Feb 2024 23:29:42 -0800
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
Subject: [PATCH v8 1/4] kvm: arm64: introduce new flag for non-cacheable IO memory
Date: Tue, 20 Feb 2024 12:59:23 +0530
Message-ID: <20240220072926.6466-2-ankita@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20240220072926.6466-1-ankita@nvidia.com>
References: <20240220072926.6466-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF00017099:EE_|DS7PR12MB6334:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ff7f7bc-aa9a-4c6c-a487-08dc31e5c386
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ei9+qziGduQK+rK9wp9oU/XVY1BD6wFjPgbhkZxhgo0tlkn+jcw6DTssjjlCWGSaxKVAjFZvhhcsnilxz2sZLMmY3Qv7h0PpCtrso0vII8oywF8hI44DH022uM5xGu5QkLLWYjgmsZKoWXwIlQNDT2Gk+O1wXRSuWI2A9xrVNQyY1Ip13Wo8ZIe4ySZCYcY42AikSmooArRIZteEc7598Ho1T44If4xcEUKCMZtoUigz8bisCFBiefewQYcUdvKGbfaQF+bGDDP/bhld9Gn/YRL83ICUNV1A0kVn+DWNy9upbPxBTXamBw0pJ0Z5vQp7Ax08ynHISJH8fLVmc/2VgNVbXE8lSn3QmgEBKKkfri0rGn/Gznqc+kP0lPlKG9z1sQUqDHBeI4bvP6Z5JunrBq2OtS1b/bcklhGDic4o+cANhqW5Njh15GMp4w/ruySYw75KVmaCFOkgpNKrMXbUIBuIvbbp2V+/q4/oMnn53EoUXaQhvPpNT3wex2fagJmOZJcL51YpIbriJRH0sjk6rhYoxBraIsjPdwBjx87lZSxD5pmVROdCgiFiDrqCKT5ezc+ofexJxIo8rVrHIGONcGQk0FIxORtxpZPUBXSN/D0kV0Any7WFIVhouLkR5fl5nP3+4kFRU9t2g8KCFA++jtIs8LDcCFuWcH/wt6UB+xc=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(36860700004)(46966006)(40470700004)(921011);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2024 07:30:07.6171
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ff7f7bc-aa9a-4c6c-a487-08dc31e5c386
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017099.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6334

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

[1] section D8.5.5 - DDI0487J_a_a-profile_architecture_reference_manual.pdf
[2] section B2.8 - DDI0487J_a_a-profile_architecture_reference_manual.pdf
[3] sections 1.7.7.3/1.8.5.2/appendix C - DEN0029H_SBSA_7.1.pdf

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
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


