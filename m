Return-Path: <kvm+bounces-56434-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B93DDB3DFD2
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 12:12:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5C8EE175E4D
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 10:12:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0535B30DD1A;
	Mon,  1 Sep 2025 10:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="AembU8x8"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2057.outbound.protection.outlook.com [40.107.101.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CBDE2AE72;
	Mon,  1 Sep 2025 10:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756721524; cv=fail; b=W1UIjtVzLvGuovXA9m6UVxvR7fR1fQeOZPUVlV4HeNzohx38Evk1f1oXpGmQ7dGVF519pZa+8ORvGciRs5GMAmpkXIPTcsddlNFPInJTQq2qfy7Id2oAHYzqobvPlQnp4FWveRFPX36nvE2qQ9CrLBYXAfjXXdXBgTrsCjhqrAc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756721524; c=relaxed/simple;
	bh=41cgz/fVIC0vO6SFEamh6mIrLQ1h8ci/N/RicvI+6cA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oLybKwf/UE6k72PeNzt8fI2RyOtVCpWb+h8zgkWkWt/cpzJnErBY6tEX/qmHrLWjOEUDAtYGakfUpF8SbB6UsMdqJsqpjuQ0Mzd0Xb5LfB/tAwL3eJRtk0j0tOjqJ7Kcv8DW4mOl8xP4u8dl0U7XBRty6oBg3+5BgqpeDbQBYGo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=AembU8x8; arc=fail smtp.client-ip=40.107.101.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lzcVOUOxwC6jciG+hNK35YNnA5Y6BlmgssrFjHSJd+UedxhqXMQf0J0dnoWqm6tjYWLWV6a7i1Sk06qiX+Jq4m43sA47Wlkuv2HgZtsXa4cmPCNNtH9iw3iRPJQzrRLWpSMyvsRT3/XRk+k5TqUe/7yOh5qeoxe2vh+Dyi4HZcvBD323nijDmtFcUmCPsbC270Aa6OIFIrDomj53aw54t0+DqY77iMGsJONiyuEa9weSoDvZ3nm/OukaVYy4N/EG1k8OUa0i5gbs13ovmd6AEYrT/Mjsp/ht1OMuRV5UFdwH5OPRbNoA1O17jT9V0ceeTmQCpYQfitcI3/o+uJGUug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A4XRs6K2nVAH81o/pump2x1agvKwSzvs3eZSCQeYLaw=;
 b=l6B73MeqZkYWYvSWmIdIKl2IA0SyRjzaEl5S8NKIiw+YXt3Cs+t49vWwjrxqxJEpcfw41fV2cPmoIRfnWNy/8algKiYURmrYly2TBstmSAA554MLJMZcqFWlYW+ckiCZ8XjBDErzCScFT5u/74QVpXxZX3Ci6i4PvYfNLYBH19GKhf2CiqmjOPP+t4I6MObQiAyWbk3jAqY69Dsiz4ah+LOb3jXbCophD65EHWRRwUduiALFMAzIbjYd0MDR0R6ESw0Wja6Ql6oSK+KCTZ0qG+fWrWOq3j6rczBBULY6p5WMr89qXHlvKKyHlWBMqbnEKq7iB91uXjEaL8+6nCYsOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linutronix.de smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A4XRs6K2nVAH81o/pump2x1agvKwSzvs3eZSCQeYLaw=;
 b=AembU8x8Y4f09q2fn3KJ40uYW76bDc8V37oQXydkORMtb2DY527Q5t8qrB6dZ1Fdycmsqq16q+AfhAcC2jSaXL12oo1hgLxSDGLVpCJbcHrNNlti7dIP4u7rrmylGta5pYf7w/jJahksRHI95jZpzbwHDfPQG164VsmyyfMbNR8=
Received: from DM6PR02CA0071.namprd02.prod.outlook.com (2603:10b6:5:177::48)
 by SJ0PR12MB7036.namprd12.prod.outlook.com (2603:10b6:a03:483::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Mon, 1 Sep
 2025 10:11:57 +0000
Received: from DS2PEPF00003441.namprd04.prod.outlook.com
 (2603:10b6:5:177:cafe::3d) by DM6PR02CA0071.outlook.office365.com
 (2603:10b6:5:177::48) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.28 via Frontend Transport; Mon,
 1 Sep 2025 10:11:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DS2PEPF00003441.mail.protection.outlook.com (10.167.17.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.14 via Frontend Transport; Mon, 1 Sep 2025 10:11:56 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 1 Sep
 2025 05:11:56 -0500
Received: from BLRKPRNAYAK.amd.com (10.180.168.240) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Mon, 1 Sep
 2025 03:11:50 -0700
From: K Prateek Nayak <kprateek.nayak@amd.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<x86@kernel.org>
CC: Naveen rao <naveen.rao@amd.com>, Sairaj Kodilkar <sarunkod@amd.com>, "H.
 Peter Anvin" <hpa@zytor.com>, "Peter Zijlstra (Intel)"
	<peterz@infradead.org>, "Xin Li (Intel)" <xin@zytor.com>, Pawan Gupta
	<pawan.kumar.gupta@linux.intel.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, Mario Limonciello <mario.limonciello@amd.com>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>, Babu Moger
	<babu.moger@amd.com>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Naveen N Rao <naveen@kernel.org>, K Prateek Nayak <kprateek.nayak@amd.com>
Subject: [RFC PATCH v4 5/4] Documentation/x86/topology: Detail CPUID leaves used for topology enumeration
Date: Mon, 1 Sep 2025 10:11:30 +0000
Message-ID: <20250901101130.3661-1-kprateek.nayak@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250825075732.10694-1-kprateek.nayak@amd.com>
References: <20250825075732.10694-1-kprateek.nayak@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To satlexmb09.amd.com
 (10.181.42.218)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF00003441:EE_|SJ0PR12MB7036:EE_
X-MS-Office365-Filtering-Correlation-Id: 40cca47c-fbb5-4c88-e85a-08dde93ffb96
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|7416014|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?EFKBcY5l0vEkuzHE9Yn15z/gV3wh9m2CQWIDNCahH9lgWKEGKXqbhXdGTbn3?=
 =?us-ascii?Q?hvgKzjo+Fva1hfTZhfaFfd7mgvUq03ouphZgsV8f4lhcarQeIt0r9xIeVFcT?=
 =?us-ascii?Q?V2yfK4vNWZ3I5DGmV5kqR1xS2SXsffd09sKbXkAvfIlY9xwf6x6aOsOJfgBY?=
 =?us-ascii?Q?8dBy3FpJiprm54uNT67CieWRcH58gQEwSoe1WTP+CJvUH8ug6bSBrJlPCCq1?=
 =?us-ascii?Q?5Z4gki5yzVjpLXbX3/GM5HCFnmIM9So67ohfYXBQACn6GorMrcXQc4QuN16g?=
 =?us-ascii?Q?YxTdZ8V2ge1CYQJwALuv+W44u12GY+b99gf/1VsDot3dplIqZ51DZZHKddi9?=
 =?us-ascii?Q?Wah+c643oIC6AqX6jd4kVHFeh0dIKENFrRVX9wp01oJb5AYOuCtBqtmwmHLl?=
 =?us-ascii?Q?m8XNJJypSOQ5kb4iuyg6JEOM308PizjzFUXtV2KnVTH5hdJ56cRMZJbgJxqZ?=
 =?us-ascii?Q?EQ2G5hoeyVcZwdSvunfbm32tB255Vg4y1OjLptsQ0BrEjCg36vlAE0UyPljZ?=
 =?us-ascii?Q?s4Xds0gMWEJfHVPubvHl2VURMXyh0lmpPvpCrJldbn1pPo+3tu1nI06AOzvc?=
 =?us-ascii?Q?6Iz9nrm4b6hZtyNQwcg3WO45bPxWtm71cZSCXMtEQWjUuFsYeyepe4hHl1+e?=
 =?us-ascii?Q?wD+v4XbTZhISFmPa78Lwu/vKnF5CibS0pzq9vNI6F+nBBocZ3eGZ5QMtWBpy?=
 =?us-ascii?Q?g014fDmKelxssGwEzm7ZyCuDIm9HUdyr7bDSGsRNtY9b2kKxohhagbGhvXn5?=
 =?us-ascii?Q?jjye09uthEIQW9Adb1pcRHXh/L2chO8Aq3hgTvOgbViIm4lDW2RaSjC7MmCk?=
 =?us-ascii?Q?EfqiYSsLSwoYuO/HFyJ0E7MKaPRAVVLskJVb1HZUSo4pqS0p+5lPMoyrXE/b?=
 =?us-ascii?Q?GWMlyV6gFKoB69vEBznje2XHTSNrw4mhtJwYUL+ZW5sKp7tkebr8PWaXbwSm?=
 =?us-ascii?Q?F8RzUrzWt7y0DbhaZBKDIy9TiMC5gGRKI6ciY5jPRaVMAEem49hUeqa9N4Br?=
 =?us-ascii?Q?6uvgT1fznRVy7bh+udHYbt3ogWygCH0GDwb/chaDWuBv7L1Hq0b/0ONv6k5N?=
 =?us-ascii?Q?W+HYhGYFFXdcOjdsV5cWZxEU+P7uG1wxurHtAyJIIF3rdgjS/ltFEmXrtWWd?=
 =?us-ascii?Q?nTBzhgLfs7jnwieBXHS5qhGqpzUvG94TAWKPVc+Et2wv3DecalMfyrPkEOh7?=
 =?us-ascii?Q?GrJkESUStYyJtAC2WzXsL+ZZ7pSwhdx1YwH2kR4DtHxm1kjXo1aF4Vs87ZwH?=
 =?us-ascii?Q?xJWKnZKY50B/segmw9mAuo1YfFkjNCNggrH1Bj0Hb+Q0BXBvJAiVwkeemkeh?=
 =?us-ascii?Q?WOH6E2O+hO18zD7605tf+K94lWG3/pM8hRywnk00OedS+7cdHMTNwd49UKjH?=
 =?us-ascii?Q?BW7Nd+wyNFXmQgWBG3e5o/OqOIDCL1CrUU5XloZh3E8Y+ppUMVkHQMOx0QEu?=
 =?us-ascii?Q?d3tOYpD81g3UpEba53gC0g50bCxf+w8zq23H1iwBoRmx6YQoS1kCdxBWgBNJ?=
 =?us-ascii?Q?a5gFFjBTu9Tx8L8yLFxegJ0QDPyvJ8FTAFhZ?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(7416014)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2025 10:11:56.8854
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 40cca47c-fbb5-4c88-e85a-08dde93ffb96
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00003441.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7036

Add a new section describing the different CPUID leaves and fields used
to parse topology on x86 systems.

Suggested-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: K Prateek Nayak <kprateek.nayak@amd.com>
---
Sending this as an RFC patch first to squash out the amount of details
required in topology.rst. Once clarified, I'll include this formally in
v5.
---
 Documentation/arch/x86/topology.rst | 194 ++++++++++++++++++++++++++++
 1 file changed, 194 insertions(+)

diff --git a/Documentation/arch/x86/topology.rst b/Documentation/arch/x86/topology.rst
index c12837e61bda..fd9903aab6b5 100644
--- a/Documentation/arch/x86/topology.rst
+++ b/Documentation/arch/x86/topology.rst
@@ -141,6 +141,200 @@ Thread-related topology information in the kernel:
 
 
 
+System topology enumeration
+===========================
+The topology on x86 systems can be discovered using a combination of vendor
+specific CPUID leaves introduced specifically to enumerate the processor
+topology and the cache hierarchy.
+
+The CPUID leaves in their preferred order of parsing for each x86 vendor is as
+follows:
+
+1) AMD and Hygon
+
+   On AMD and Hygon platforms, the CPUID leaves that enumerate the processor
+   topology are as follows:
+
+   1) CPUID leaf 0x80000026 [Extended CPU Topology] (Core::X86::Cpuid::ExCpuTopology)
+
+      The extended CPUID leaf 0x80000026 is the extension of the CPUID leaf 0xB
+      and provides the topology information of Core, Complex, CCD(Die), and
+      Socket in each level.
+
+      The support for the leaf is expected to be discovered by checking if the
+      supported extended CPUID level is >= 0x80000026 and then checking if
+      `LogProcAtThisLevel` in `EBX[15:0]` at a particular level (starting from
+      0) is non-zero.
+
+      The `LevelType` in `ECX[15:8]` at the level provides the detail of the
+      topology domain that the level describes - Core, Complex, CCD(Die), or
+      the Socket.
+
+      The kernel uses the `CoreMaskWidth` from `EAX[4:0]` to discover the
+      number of bits that need to be right shifted from the
+      `ExtendedLocalApicId` in `EDX[31:0]` to get a unique Topology ID for
+      the topology level. CPUs with the same Topology ID share the resources
+      at that level.
+
+      CPUID leaf 0x80000026 also provides more information regarding the
+      power and efficiency rankings, and about the core type on AMD
+      processors with heterogeneous characteristics.
+
+      If CPUID leaf 0x80000026 is supported, further parsing is not required.
+
+
+   2) CPUID leaf 0x0000000B [Extended Topology Enumeration] (Core::X86::Cpuid::ExtTopEnum)
+
+      The extended CPUID leaf 0x0000000B is the predecessor on the extended
+      CPUID leaf 0x80000026 and only describes the core, and the socket domains
+      of the processor topology.
+
+      The support for the leaf is expected to be discovered by checking if the
+      supported CPUID level is >= 0xB and then checking if `EBX[31:0]` at a
+      particular level (starting from 0) is non-zero.
+
+      The `LevelType` in `ECX[15:8]` at the level provides the detail of the
+      topology domain that the level describes - Thread, or Processor (Socket).
+
+      The kernel uses the `CoreMaskWidth` from `EAX[4:0]` to discover the
+      number of bits that need to be right shifted from the
+      `ExtendedLocalApicId` in `EDX[31:0]` to get a unique Topology ID for
+      that topology level. CPUs sharing the Topology ID share the resources
+      at that level.
+
+      If CPUID leaf 0xB is supported, further parsing is not required.
+
+
+   3) CPUID leaf 0x80000008 ECX [Size Identifiers] (Core::X86::Cpuid::SizeId)
+
+      If neither the CPUID leaf 0x80000026 or CPUID leaf 0xB is supported, the
+      number of CPUs on the package is detected using the Size Identifier leaf
+      0x80000008 ECX.
+
+      The support for the leaf is expected to be discovered by checking if the
+      supported extended CPUID level is >= 0x80000008.
+
+      The shifts from the APIC ID for the Socket ID is calculated from the
+      `ApicIdSize` field in `ECX[15:12]` if it is non-zero.
+
+      If `ApicIdSize` is reported to be zero, the shift is calculated as the
+      order of the `number of threads` calculated from `NC` field in
+      `ECX[7:0]` which describes the `number of threads - 1` on the package.
+
+      Unless Extended APIC ID is supported, the APIC ID used to find the
+      Socket ID is from the `LocalApicId` field of CPUID leaf 0x00000001
+      `EBX[31:24]`.
+
+      The topology parsing continues to detect if Extended APIC ID is
+      supported or not.
+
+
+   4) CPUID leaf 0x8000001E [Extended APIC ID, Core Identifiers, Node Identifiers]
+      (Core::X86::Cpuid::{ExtApicId,CoreId,NodeId})
+
+      The support for Extended APIC ID can be detected by checking for the
+      presence of `TopologyExtensions` in `EXC[22]` of CPUID leaf 0x80000001
+      [Feature Identifiers] (Core::X86::Cpuid::FeatureExtIdEcx).
+
+      If Topology Extensions is supported, the APIC ID from `ExtendedApicId`
+      from CPUID leaf 0x8000001E `EAX[31:0]` should be preferred over that from
+      `LocalApicId` field of CPUID leaf 0x00000001 `EBX[31:24]` for topology
+      enumeration.
+
+      On processors of Family 0x17 and above that do not support CPUID leaf
+      0x80000026 or CPUID leaf 0xB, the shifts from the APIC ID for the Core
+      ID is calculated using the order of `number of threads per core`
+      calculated using the `ThreadsPerCore` field in `EBX[15:8]` which
+      describes `number of threads per core - 1`.
+
+      On Processors of Family 0x15, the Core ID from `EBX[7:0]` is used as the
+      `cu_id` (Compute Unit ID) to detect CPUs that share the compute units.
+
+
+   All AMD and Hygon processors that support the `TopologyExtensions` feature
+   stores the `NodeId` from the `ECX[7:0]` of CPUID leaf 0x8000001E
+   (Core::X86::Cpuid::NodeId) as the per-CPU `node_id`.
+
+
+2) Intel
+
+   On Intel platforms, the CPUID leaves that enumerate the processor
+   topology are as follows:
+
+   1) CPUID leaf 0x1F (V2 Extended Topology Enumeration Leaf)
+
+      The CPUID leaf 0x1F is the extension of the CPUID leaf 0xB and provides
+      the topology information of Core, Module, Tile, Die, DieGrp, and Socket
+      in each level.
+
+      The support for the leaf is expected to be discovered by checking if
+      the supported CPUID level is >= 0x1F and then `EBX[31:0]` at a
+      particular level (starting from 0) is non-zero.
+
+      The `Domain Type` in `ECX[15:8]` of the sub-leaf provides the detail of
+      the topology domain that the level describes - Core, Module, Tile, Die,
+      DieGrp, and Socket.
+
+      The kernel uses the value from `EAX[4:0]` to discover the number of
+      bits that need to be right shifted from the `x2APIC ID` in `EDX[31:0]`
+      to get a unique Topology ID for the topology level. CPUs with the same
+      Topology ID share the resources at that level.
+
+      If CPUID leaf 0x1F is supported, further parsing is not required.
+
+
+   2) CPUID leaf 0x0000000B (Extended Topology Enumeration Leaf)
+
+      The extended CPUID leaf 0x0000000B is the predecessor of the V2 Extended
+      Topology Enumeration Leaf 0x1F and only describes the core, and the
+      socket domains of the processor topology.
+
+      The support for the leaf is expected to be discovered by checking if the
+      supported CPUID level is >= 0xB and then checking if `EBX[31:0]` at a
+      particular level (starting from 0) is non-zero.
+
+      CPUID leaf 0x0000000B shares the same layout as CPUID leaf 0x1F and
+      should be enumerated in a similar manner.
+
+      If CPUID leaf 0xB is supported, further parsing is not required.
+
+
+   3) CPUID leaf 0x00000004 (Deterministic Cache Parameters Leaf)
+
+      On Intel processors that support neither CPUID leaf 0x1F, nor CPUID leaf
+      0xB, the shifts for the SMT domains is calculated using the number of
+      CPUs sharing the L1 cache.
+
+      Processors that feature Hyper-Threading is detected using `EDX[28]` of
+      CPUID leaf 0x1 (Basic CPUID Information).
+
+      The order of `Maximum number of addressable IDs for logical processors
+      sharing this cache` from `EAX[25:14]` of level-0 of CPUID 0x4 provides
+      the shifts from the APIC ID required to compute the Core ID.
+
+      The APIC ID and Package information is computed using the data from
+      CPUID leaf 0x1.
+
+
+   4) CPUID leaf 0x00000001 (Basic CPUID Information)
+
+      The mask and shifts to derive the Physical Package (socket) ID is
+      computed using the `Maximum number of addressable IDs for logical
+      processors in this physical package` from `EBX[23:16]` of CPUID leaf
+      0x1.
+
+     The APIC ID on the legacy platforms is derived from the `Initial APIC
+     ID` field from `EBX[31:24]` of CPUID leaf 0x1.
+
+
+3) Centaur and Zhaoxin
+
+   Similar to Intel, Centaur and Zhaoxin use a combination of CPUID leaf
+   0x00000004 (Deterministic Cache Parameters Leaf) and CPUID leaf 0x00000001
+   (Basic CPUID Information) to derive the topology information.
+
+
+
 System topology examples
 ========================
 
-- 
2.34.1


