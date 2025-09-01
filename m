Return-Path: <kvm+bounces-56519-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 33815B3ECF4
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 19:06:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 08A7F17DDBE
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 17:06:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DE38320A1A;
	Mon,  1 Sep 2025 17:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="BKKTnubh"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2049.outbound.protection.outlook.com [40.107.94.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C0730649C;
	Mon,  1 Sep 2025 17:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756746397; cv=fail; b=Mmj8nTtt6/Ldd0D+xL0BLiRcYanwgAOsP97l4EF4tgU/flBS8BFe+qoMY43Y9LTDmY1ihM1tvh9tzB0bmW/Bgn24toMeyvAUYDHukLYySsGHHPMr3U2BGD9qQrzzdzSHvzOig4aqgZuPhkuOHb6ClHTbFirpaNd+4CtLrqvveHw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756746397; c=relaxed/simple;
	bh=fQfw16+iDvMiTL90yO1Yn2b/QlRodwKiVGY0xDZAKQg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i/3Yjeq1a4zHShL4WAWcE10hhVBBvAxYDZhFBQY+cNFs2zLKQkeamYyRxtdrNqQH7O4uFOEGf3sZE2DFAfE8EvrCGd8wGVpF8jmKS0agctRSz+q94AkMdw0BDf28AK9TjXoUqDr11Z0qs6LB09bu0IhefSMDUUn9CBVILAvGBlE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=BKKTnubh; arc=fail smtp.client-ip=40.107.94.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oNo+QFDDbokOuPJvwLfeG4Ly0IF4O4NKpOS5j6VmwG7ESPACotrQ8k1tXigNv3ke/koprAxSrAwDsM7h6Y1hrIonBZOttw2ArfxjTbs2CmTZgQhS95WHInYdzAYgrG9dx2Sxb9fePXojdXJyImhTBNfwclpI334L6P1JIccOBgmv9WVLUebGio6m+d8nndye+pTbWVKevkNAbTfE+4F3rmjdffkEBu90Dmu2RaN8PX6XCn8NIqZDEKcWzJ7ZesEfBVn6X9pp/bQ5eMJl2UqJdhF2A4AUb6zosVeISenp3EQpyQ6C4E4sk4JUzW8i3SColdd6hGuW6TO6tAErd0u9cQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QbxyyBoHNnb4eO8wQZ+PB9+1Ovqh1h6VgEkEX4e++SE=;
 b=ncd+Um1M+QRdUv8/iaY4DN5lX2SR7Qaod2pe9n136heiqrTE/6apW6vohuJCBKqXLygvxHdNWe4geT8a/NtlFlO3q106OowEzROZDWU1R7TOFg+fiHVbtK3sm/xglC4jdPXOHXCJ6XDfyTmCj8BUvF+uwT+H5NRan0XBTxcWJycU/aq3H1p9rdDzz30u/j2N/ONwCXLMzF1QeeONjQbbGU2AO2oIKAdX6Igv8JRyMYfbrRP9Wy9JkkaDcN0Z8OqAUaNW44XAJBFvyoEjWL4NxqMhETzbjVnW2yqqvqIxqZTQTR7K3Acpab0Pabvn9ntyyiIP89NDxxsZnitDF9jELA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linutronix.de smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QbxyyBoHNnb4eO8wQZ+PB9+1Ovqh1h6VgEkEX4e++SE=;
 b=BKKTnubhtAZ6AFi3GDpSfDDcZ3s125Pr93OfzT3z1/PLfKnlmaeRP1RDnoRpcw7yJDpFo535unOeK7GICSmi1mHaCiHl80gQS0S48VcVLZCmb8scYRqkqWSa5+3LWh7gwPV2iYQZszzAeT8rn2rl+69DgCXE0YdbdMPHZHlDxvs=
Received: from PH1PEPF000132EA.NAMP220.PROD.OUTLOOK.COM (2603:10b6:518:1::2e)
 by IA1PR12MB6211.namprd12.prod.outlook.com (2603:10b6:208:3e5::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.28; Mon, 1 Sep
 2025 17:06:29 +0000
Received: from CO1PEPF000044F9.namprd21.prod.outlook.com
 (2a01:111:f403:c91d::4) by PH1PEPF000132EA.outlook.office365.com
 (2603:1036:903:47::3) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.27 via Frontend Transport; Mon,
 1 Sep 2025 17:06:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044F9.mail.protection.outlook.com (10.167.241.199) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9115.0 via Frontend Transport; Mon, 1 Sep 2025 17:06:28 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 1 Sep
 2025 12:06:27 -0500
Received: from BLRKPRNAYAK.amd.com (10.180.168.240) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Mon, 1 Sep
 2025 10:06:19 -0700
From: K Prateek Nayak <kprateek.nayak@amd.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, <x86@kernel.org>
CC: Naveen rao <naveen.rao@amd.com>, Sairaj Kodilkar <sarunkod@amd.com>, "H.
 Peter Anvin" <hpa@zytor.com>, "Peter Zijlstra (Intel)"
	<peterz@infradead.org>, "Xin Li (Intel)" <xin@zytor.com>, Pawan Gupta
	<pawan.kumar.gupta@linux.intel.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, Mario Limonciello <mario.limonciello@amd.com>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>, Babu Moger
	<babu.moger@amd.com>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>
Subject: [RFC PATCH v5 4/4] Documentation/x86/topology: Detail CPUID leaves used for topology enumeration
Date: Mon, 1 Sep 2025 17:04:18 +0000
Message-ID: <20250901170418.4314-5-kprateek.nayak@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250901170418.4314-1-kprateek.nayak@amd.com>
References: <20250901170418.4314-1-kprateek.nayak@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F9:EE_|IA1PR12MB6211:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c1235a8-6e98-4e50-c0ad-08dde979e431
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?A1MCHn5vQlLJ3oZNRYgRc9ypw0f2VZDe0jzv5xQSWijxdpUjxccE5JK8nCTH?=
 =?us-ascii?Q?dz41fTxpn9L5ncwRkso4Hye93UOAVicB9FRMT6ELJ0R6nnZKwmgrzGppM17w?=
 =?us-ascii?Q?4LDSXookY8QpRNGyL9rbxO/SN1+zeAoeg9HcKSWi0ROlvdld/nNI92uoaj7c?=
 =?us-ascii?Q?+UoV6LtpXinyRc1aLx6JISbHytSjkP6KBXKAK2YdxmdcG9XLThbtvOynEZZR?=
 =?us-ascii?Q?0suzMGfkHl3uK5VfYlwlcqF5xwdAdK4EnhMeq5HZTXvCiaMiWWs0c0d7j9ek?=
 =?us-ascii?Q?1bGR2D2fSGTC4I76KQ5SJ6AlYXZwe5es22H3nHWYWBt0Js8+TUxHRkN6pYJX?=
 =?us-ascii?Q?BZpd4q4Mo7+gfN3I3+AFglCuqTANyYYCrRwbmFHn8zqQinOpLaBktXlxqPpz?=
 =?us-ascii?Q?oyZ82GADhqklZ774j8EB6hE2mU0Hi7kR/MIqLWn1D2h3nAbnR3cPZlrLxpNs?=
 =?us-ascii?Q?y70a+1W6dTNQ39vyZWkog0zIh1WspejWk6m2QJlddW945IVSRAOKNW90kVtV?=
 =?us-ascii?Q?OPuVtZM7wb1R9IIhYA13e5FEgY/WbWEx+7ELgGrnFzjR3Ws+wpqEu/MrSgpl?=
 =?us-ascii?Q?rX5MV4aEtsv+f4msC1MjaDXCuRcKbpvLon+RXXkeiXZaBTQkgVss+AUUb2YP?=
 =?us-ascii?Q?0dlzFMKTIx4dQUwS83Ua/eU88yxNngpkrdfYBw5MbJYt56vk3Sd7jutOvzQ4?=
 =?us-ascii?Q?0yz9E6pAenKQBvrXyyh94jOkgWw7FvAnxaqWfYFOdC24flf0kZA48Bgn+7r8?=
 =?us-ascii?Q?U7N5uqoJk+h/E+hNf9YXyQWpuCDw2/nmiWCrwf9IDtkmE2EpHVy/my2u9bgi?=
 =?us-ascii?Q?QONfsGWaDbeYbXJt0aJuBfAEIKOUwngCkDOTpe9SFhci9h7UZrazAAIy8pUD?=
 =?us-ascii?Q?x28PzOSnMoZrY+/DO6P8SfbO4g3C6sj3YhsrDySXLIuuxAyDCLbcJ9Zox8/2?=
 =?us-ascii?Q?bSOjahBexpTWYIZJ9tj+ZchkuugSyQqCJyNCoPBpFnY6yCTPVoqXT5rfEK1D?=
 =?us-ascii?Q?WwygXSAjn16iXuTnyxeGAdT1X7drhTkAUKpFA0tA8g0qWX+6LTIfaW1GWPUh?=
 =?us-ascii?Q?nRe3LwMhMv/84BaWORznVqKrbdWLBvAc31hCYy9iCcHfKrc6DQ28ZcqLbTNx?=
 =?us-ascii?Q?D3wq0QWVaPrhsnzQy7ssr8MMumBtKzjfIVzHypFE1mp9BlKH9WwQO4h6LTxd?=
 =?us-ascii?Q?ZAWcLC0unHpiLNBJPNMMkMcinenabbhViC0KFNiHjM737mt1bAT+hW7lraG3?=
 =?us-ascii?Q?PMxZIzbblVvBv3KIXYASLQEY3IDrXsxEXhwycx+pJRIAg7vK4tmJsYisMtfV?=
 =?us-ascii?Q?FcX7YQjrMQNowpCGZuL0eRawacG67IJ9PUFbDm5BMKuRHJV/LTj0nKjOiAaX?=
 =?us-ascii?Q?dHTtrJ/hQssqrI/BFJdXPgb/7kcKEtucxQs6lHJgR1wIpDbZDZquobIWs1Mn?=
 =?us-ascii?Q?szlg+rAPXCeMgtYMrLJ3eWcW+1utQrrpOLRxJcY8//2YhOMb6c4z9FSQ5Nx1?=
 =?us-ascii?Q?cyqYCz5tu1/GbEYJ3CbBADHPjO4I3bSAP+73?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2025 17:06:28.3915
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c1235a8-6e98-4e50-c0ad-08dde979e431
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F9.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6211

Add a new section describing the different CPUID leaves and fields used
to parse topology on x86 systems.

Suggested-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: K Prateek Nayak <kprateek.nayak@amd.com>
---
Changelog v4..v5:

o Added a nte about the NODE_ID_MSR on AMD platforms.
---
 Documentation/arch/x86/topology.rst | 198 ++++++++++++++++++++++++++++
 1 file changed, 198 insertions(+)

diff --git a/Documentation/arch/x86/topology.rst b/Documentation/arch/x86/topology.rst
index c12837e61bda..4227eba65957 100644
--- a/Documentation/arch/x86/topology.rst
+++ b/Documentation/arch/x86/topology.rst
@@ -141,6 +141,204 @@ Thread-related topology information in the kernel:
 
 
 
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
+      presence of `TopologyExtensions` in `ECX[22]` of CPUID leaf 0x80000001
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
+   (Core::X86::Cpuid::NodeId) as the per-CPU `node_id`. On older processors,
+   the `node_id` was discovered using MSR_FAM10H_NODE_ID MSR (MSR
+   0x0xc001_100c). The presence of the NODE_ID MSR was detected by checking
+   `ECX[19]` of CPUID leaf 0x80000001 [Feature Identifiers]
+   (Core::X86::Cpuid::FeatureExtIdEcx).
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


