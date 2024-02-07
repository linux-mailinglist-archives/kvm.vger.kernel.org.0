Return-Path: <kvm+bounces-8280-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BDFCE84D324
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 21:48:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 00292B22A71
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 20:48:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B626127B78;
	Wed,  7 Feb 2024 20:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SyQPFKIi"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2054.outbound.protection.outlook.com [40.107.243.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EFFE127B64;
	Wed,  7 Feb 2024 20:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707338854; cv=fail; b=ZIhnx2g1vPGXNin5x6j3mxN0wvneAGtR3aUqp3BS/wu/MOebkQhcErRbhUZNDXzBzH+hLqt7i9rlUh5jvdEOdAE4l0m2Irz0q8a2a1dXkRT4+hkA2C9IGDT/mxFA/9zj82q0BJGVfIdXOupTaEylsfm+LN0wwJkgRCE2YpkfqNA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707338854; c=relaxed/simple;
	bh=i/FdiSO/Z51gVAahEivFWJtqeXAT0em2qLH8w4lXeOE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=etzuJPxg+3POK97vuOcYoMzUR2Bllwo6ofJbqF/RVu85uQzPt99qCJQfqG2jMiATmcSbtnQGBBEOMMjOVTzS9+8Qpssh2C9PuvQvy4TVYvzk8G8M65yLyxHhgqS+WCcx8sehFXmWcGFEryB27rRz6J+WUBojRSkvyi7tQqe9YGs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SyQPFKIi; arc=fail smtp.client-ip=40.107.243.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CUbR8jQUtIwlJZXKeUcMDyrHbPsdO6Y1S/+kf2C3CeLBbuk7LwKMjxpQiCoe2xzHEJc8ch172BBpc7+BRVJJQsZ/FBpg1vwcEEHDG4mP27VwHN7F4u/f7yjKJuWGCiXDDlOiVtmy5RCWsYjcn9KR6F1HZfUox/bSz5+fC32ZsaVH51fiI0JU0i/5MgpDnok63Y6SQCncI8CW7X0XXTZISWdnpcpm6Hmv7OBu0G7p2+XRS7QLTltPxrJwZfLlBdBS32DdbBLFT2Wby1et81So0Zyqrf1DkKDqkdc3vr06EE/toDz672YMKh8YQIcR5dCbCHg3QFmZTCm9TR/lvdxcag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TPLhCc5Cj4wRhe05HT5yT80oSp9bYdnVUL01XmVxPsE=;
 b=FOnsZZ+AJhvnbGkNXpvCDN8QFu0+CHAaEGrRa56XZ7JPpFC2ZDkQmxb1OFT7ONJVDIrIpUEG40ZecM/w+qvm8UeE1m2umgKSoD0Vnj9j+fNqYmSsICN5dISkhUUgKFuhTmoqHQQFa62+PqAvcbcuwAjXb/GNCnDty4D3rT28cyyq72G18MrTa9ONz5z+VTmnfQLK0QAhDa1qEwlOlg4QeqNypGYeFGi+6/SmF//JeNWH7u8RslNePtC962EXmH63hopYQvVZdazMEirgyzeMToqWdzMuXe1t3AkZEjtMYmF+L+0nnul5JP/PdhTzvhwr8usFpmSwGwWn6UUdoZbHqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kvack.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TPLhCc5Cj4wRhe05HT5yT80oSp9bYdnVUL01XmVxPsE=;
 b=SyQPFKIiM6veQ3p/e+3WsBkWIICVqh3T5H5TE06XVx5tJ48Cne4V8qw4F7+kWQmX2CVHYfhS01uNHK+MQUAPXWtd0OoR69m0UH4w4Nq4I07R2C8zlxL90iauuQtt5qK2U5rwJxPkf1xK/Rnbo6vZbOLCa20i7LJQ9FzRDtSW4h2sE9h5qZjZi0Z6Tx741Msrh02IYazYSWF7w7Cken8RNQVx2mLXhVpJkZqk/uaqBYtAAT5JKsW8l7jA9b/EJf4UT/Dubnqo9K201o6+bcTuOHNtB4kxoMzQGYkfZYqeIFKBDRLi92cmMcrjGiOHZ+n2cRh1hQryLxnF3LsSURuEtQ==
Received: from DS7PR03CA0213.namprd03.prod.outlook.com (2603:10b6:5:3ba::8) by
 PH7PR12MB9256.namprd12.prod.outlook.com (2603:10b6:510:2fe::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.15; Wed, 7 Feb
 2024 20:47:26 +0000
Received: from DS1PEPF00017091.namprd03.prod.outlook.com
 (2603:10b6:5:3ba:cafe::61) by DS7PR03CA0213.outlook.office365.com
 (2603:10b6:5:3ba::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.38 via Frontend
 Transport; Wed, 7 Feb 2024 20:47:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS1PEPF00017091.mail.protection.outlook.com (10.167.17.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7249.19 via Frontend Transport; Wed, 7 Feb 2024 20:47:26 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 7 Feb 2024
 12:47:16 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 7 Feb 2024
 12:47:16 -0800
Received: from sgarnayak-dt.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12 via Frontend
 Transport; Wed, 7 Feb 2024 12:47:05 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <maz@kernel.org>,
	<oliver.upton@linux.dev>, <james.morse@arm.com>, <suzuki.poulose@arm.com>,
	<yuzenghui@huawei.com>, <reinette.chatre@intel.com>, <surenb@google.com>,
	<stefanha@redhat.com>, <brauner@kernel.org>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <mark.rutland@arm.com>, <alex.williamson@redhat.com>,
	<kevin.tian@intel.com>, <yi.l.liu@intel.com>, <ardb@kernel.org>,
	<akpm@linux-foundation.org>, <andreyknvl@gmail.com>,
	<wangjinchao@xfusion.com>, <gshan@redhat.com>, <ricarkol@google.com>,
	<linux-mm@kvack.org>, <lpieralisi@kernel.org>, <rananta@google.com>,
	<ryan.roberts@arm.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<kvmarm@lists.linux.dev>, <mochs@nvidia.com>, <zhiw@nvidia.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v6 1/4] kvm: arm64: introduce new flag for non-cacheable IO memory
Date: Thu, 8 Feb 2024 02:16:49 +0530
Message-ID: <20240207204652.22954-2-ankita@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20240207204652.22954-1-ankita@nvidia.com>
References: <20240207204652.22954-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF00017091:EE_|PH7PR12MB9256:EE_
X-MS-Office365-Filtering-Correlation-Id: df2f776e-8ac7-453d-fae9-08dc281dfe38
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	QQ2fOOV/s5c+GtFfGGRxgpS2FoYjFLarIgyGahbEKEsHvQU2/p/IeJcbUvzNRFtO107iyekwmDGNLt06sqA24y943589gACxqFb1+SBZ7Hs+qm2daNhdsOGtZd9CZgnBN9J8KCTR2lClsE/Mg9ZfXkjXJtJnJowX8Ok/xfUp2uLRj8fTRtXXTG1EpMzfhvMkkadAHXYuvGVcfuFuyNaAmefYSpl4Fi7YZhAvonAJz0wdree1rBuxIaPWJcbCrG4E2RIHZ2pI1sCp+tnKMi975tEbX2/xcY6RBa9KrkT8AVTQlMnoyPsCDx2CO9Yb722CS3XyViQXn8JicacGq3C+LOyMrY9f7AYBcWRzrzs9qU6SzYxveuAhpGyCluQEr6a3At1z32JA2ICH/sDkbwHeLeZo9SbEp00cS6408kNOPk5reLXAAclW20FORdIBGy+4yBELN6EQFTAopdwjBJdT802pPZQ5J3KaCNaedlOnFLU+NDimN6PvJ4j2jdToh7Nhutl+KOb0QmCVItkp/nbsjkuu/15DetVPji8VRzFWghqQ2qNhpHPUYl8CQMY5tvj5JA7F8jNT5eanHoarHH9pwQ3b6iEv31EDhLio9nmyJa9dzjVcLngb0ELIlRsb2W4chXSyOI5CEF5Lrd6Dfo+Atg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(136003)(39860400002)(396003)(346002)(230922051799003)(186009)(451199024)(1800799012)(82310400011)(64100799003)(36840700001)(40470700004)(46966006)(41300700001)(26005)(1076003)(426003)(6666004)(70206006)(7696005)(8676002)(8936002)(2906002)(19627235002)(7416002)(70586007)(5660300002)(7636003)(54906003)(110136005)(83380400001)(4326008)(336012)(316002)(356005)(2616005)(82740400003)(921011)(2876002)(86362001)(36756003)(478600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2024 20:47:26.2671
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: df2f776e-8ac7-453d-fae9-08dc281dfe38
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017091.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9256

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

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/include/asm/kvm_pgtable.h |  2 ++
 arch/arm64/include/asm/memory.h      |  2 ++
 arch/arm64/kvm/hyp/pgtable.c         | 23 ++++++++++++++++++-----
 3 files changed, 22 insertions(+), 5 deletions(-)

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
index c651df904fe3..2a893724ee9b 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -717,15 +717,28 @@ void kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
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
+	case 0:
+		attr = KVM_S2_MEMATTR(pgt, NORMAL);
+		break;
+	case KVM_PGTABLE_PROT_DEVICE:
+		if (prot & KVM_PGTABLE_PROT_X)
+			return -EINVAL;
+		attr = KVM_S2_MEMATTR(pgt, DEVICE_nGnRE);
+		break;
+	case KVM_PGTABLE_PROT_NORMAL_NC:
+		attr = KVM_S2_MEMATTR(pgt, NORMAL_NC);
+		break;
+	default:
+		WARN_ON_ONCE(1);
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


