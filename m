Return-Path: <kvm+bounces-54865-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E5196B2994D
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 08:05:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7EC593BBB8B
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 06:05:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AB4C271450;
	Mon, 18 Aug 2025 06:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="UiUvQ6SO"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2061.outbound.protection.outlook.com [40.107.223.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DD0217A300;
	Mon, 18 Aug 2025 06:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755497109; cv=fail; b=O+8ff+DGOje2kMKei0zGcRI8qAdwSc9guhg5xfM5dvVtjXwWj9pRCbxOF2nBKszRrjp3D8xmF+i8MRn/S4yBGGsfR7lUMxHyh/Zt02f3fRs8RgPMYqJ6608XhZAZbY9CvGw1ATy9NaiUSyEBCJaftpNdzuXpxi/bWcQZ9IZ5/vc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755497109; c=relaxed/simple;
	bh=0Tjb8efHyZZeaTWGiZv25AsYWEe20wKcUKqkYzn0qNM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=mZjb7KIi4sRRSULQzc2AqVfql4dqCrqbPXFb0GcuQj6M9WYwnzq4uuy/qNLATt95MLkkwUd4R5MIh8tVFqdF0b/j9wJVGvYzEJkCBrGaH92ry5Z5JMoHWiuxzp7dy2RcuD+/Ubk6ipG059QIHgjexG3GOOneaDjWNlR7K4G/e5c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=UiUvQ6SO; arc=fail smtp.client-ip=40.107.223.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KvuyanrvMd0R1OUs4P/kiAloGs8jhXX0MuHAxerf306Q71WVqcQ8JyOcRRjZcaobFPPJTs8Ky8Adm26lnhUiqwZQk5SlJwv/VbqYYeDbpES2A/ubsV7u0FCULppNwmN3G/hFuXuaD86SFWycvAlJJgjTYTqSSIiLE+YZLJOPuZtafIHU52qAEWVwp6GaueFCO4ARX0j7GCI0Yy8+lSdBfeKvu20Nqq+E8Ngq8c/ffVV7D1+bmrukneb6ZDHQlDDR+wrG37sYQ6gJld4CfIpJEzMNygYzTdFKmQpNJ+6JwXHLxliihosBt6npUpx3bgd075USvydoZ38ZvJuaraujpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hy22IJYtF/YnPB5mNE1wLojeF8JsCgbcIyyxOvbfM+U=;
 b=ZzoDMxr3+t4ZvytIg/88fCisFDj0cDE3MHap6eOCpv+sKkaTA2Yl6qsR/0p2PhXeLobukc1iI3Nja/04K5R1MWgTbuoMFpU9/0texK83EtlQgtlOxXlOgBhDigP5aqfnqQdt/owGRPBQfvic1iwR0yt5F9uVpzZJWuj9VkCih70z2K+7dufe1Io+ubsqozD51+PfcmQZe0Aiug63OUrz0edGcROnGCsSkww/wBwtHmalMjFM7HL7DrJjHKIVYb2e2Yl2mTW/Fu8hfd4DcIGb70RBKO6f81MDwHlvHKbmN6hsEsE+q3U3S90znGpp2SIEHDRN6A+gHYkUzKGcuxJgeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linutronix.de smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hy22IJYtF/YnPB5mNE1wLojeF8JsCgbcIyyxOvbfM+U=;
 b=UiUvQ6SO1scGzN6fVB1T1RXegz/ROWd/TDsfa858VRMPZGtDPZ5IjbPzYZKwlnt8kXlKcMpBFGacy/u0jsDy/i7p3ux2tmRirZ2K46A+wtAfEW/fAwgVD/z7ZgEkF3KVIfqU13DxfhdWQBvCsK4MCXxS3BZAhD7rzLfNt96ShL8=
Received: from BYAPR05CA0072.namprd05.prod.outlook.com (2603:10b6:a03:74::49)
 by DM4PR12MB8499.namprd12.prod.outlook.com (2603:10b6:8:181::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Mon, 18 Aug
 2025 06:04:59 +0000
Received: from SN1PEPF0002529D.namprd05.prod.outlook.com
 (2603:10b6:a03:74:cafe::10) by BYAPR05CA0072.outlook.office365.com
 (2603:10b6:a03:74::49) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.12 via Frontend Transport; Mon,
 18 Aug 2025 06:04:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002529D.mail.protection.outlook.com (10.167.242.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Mon, 18 Aug 2025 06:04:58 +0000
Received: from BLRKPRNAYAK.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 18 Aug
 2025 01:04:49 -0500
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
	K Prateek Nayak <kprateek.nayak@amd.com>
Subject: [PATCH v3 0/4] x86/cpu/topology: Work around the nuances of virtualization on AMD/Hygon
Date: Mon, 18 Aug 2025 06:04:31 +0000
Message-ID: <20250818060435.2452-1-kprateek.nayak@amd.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002529D:EE_|DM4PR12MB8499:EE_
X-MS-Office365-Filtering-Correlation-Id: 86fd8813-57a6-417f-6a64-08ddde1d2933
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014|7416014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2GbOlcs8sIC+zL+Pq3g+fLJuom+Qb9coClrUB6rkDF0fW7uRgW1/oaBdysxx?=
 =?us-ascii?Q?UCWTyUIyDGBMbqusP+SVOrp3sKGSy+Q/dj3TMTEJlwfMLxrvncxJzS5pEhNC?=
 =?us-ascii?Q?qkYhgD+x3wovOwrsMn0JUQXT/EqCzLQIkI6ymcO1cgrzbhKWIIUv0rd5vUdT?=
 =?us-ascii?Q?fVhhlKnWHtvd2kBIQZxAJF8ReexRtc+VyjXN7yEwhr0B/B64/chh3QSEmi3B?=
 =?us-ascii?Q?7a/Dr3/udc3ZAeuMaS8hvpCuWQ8jJ9HlGn/gWSgEwHCFw58HiE3CH0f/0Kqs?=
 =?us-ascii?Q?4/ryQ6EMp2Hnodc5i8lOA/SdfMRu3cjC6usPFUvrl8K9cUGihKDwP4tDhTwx?=
 =?us-ascii?Q?GNVAVGQ5oXuhFactu/2fwhKlNEux85Va75LzU8XFlucvDGVJvYy9DYwKVpsz?=
 =?us-ascii?Q?EIqGXo0Y0NrWwMrKScBUsdYaEhyqF9jIq4+tN2v38IPJPi9ImtJPnAwzlO69?=
 =?us-ascii?Q?cyJjVgU1EWwCDYRbKy6aR1yJhjU7SR1JvIaq0XnxAGXeRMJ9MzA83IqqFXKc?=
 =?us-ascii?Q?/s20cd5cd0e7X0AcyPJ8OU7I5lv8A4GrkzgVQP4+I+QZ21v6C1xY6qoq/kF5?=
 =?us-ascii?Q?9s+wMvzLbFaaryhPI65X3HdX8mb2WYJ2TsCpdqbzzGpEv9MwKI/5gptTJHRb?=
 =?us-ascii?Q?qJfSzxf5pQ7CIep5/9cSIy5wh3ttsA9WfiHm4qucFrGxK1NMWdElVV/RR7+i?=
 =?us-ascii?Q?vaZ5jirw7CW7xD6NpdkcQb0Gt+b/5W7virhdj0ki1ttPYzf6ndmnSwpfROvH?=
 =?us-ascii?Q?gLLp3Unp0l3l41jh5Y6mNzY7hniLbQUzKqiMRN2h3oD6ru6KG+CZYcvq3Ace?=
 =?us-ascii?Q?0pgfv+3P+8YIk7PL7z00M8hCVOd//Y1wuC9skwTXsCy6o3s3j8ozA2nO2jFe?=
 =?us-ascii?Q?w2drWGzDHS2Sm6Dgc0eimubmS9p9sIZHWSnyJGxGCdbLpWjqlTb2LtV2KM9E?=
 =?us-ascii?Q?FRNbosIhpr4aQ/+vtveJnpX2X1yZLBDxIA+X2WxTN+aIjyTTj/KGC76AQxgc?=
 =?us-ascii?Q?XsAmElwygUiHy9UtaKPBWOJsZgwXMZCSgC1AOkXX3Z0HYVZjZ/MO0T4/b5qI?=
 =?us-ascii?Q?HCBWBdJC+DNzjegx7CdjskOuyQbLrf95KBUgJ+9zKm4stBr0YpQrd115DuBq?=
 =?us-ascii?Q?AJVpoSfEsgQQz+2JXRaUOOK9g10jCeV0h4E6EYUcc2BlGImzONBzcn28p3YS?=
 =?us-ascii?Q?t4I+Kxn8BXUgV57OnkFQzhykzeVzBwjPUuUbxpf+cmjAjtwOG7QVpKpL3Zcp?=
 =?us-ascii?Q?2C4ziUdfXVVI3Jgrs/Oc/ctiyJl1YZiXkwL4urm21PIhnV6bbQRIrxK2vC3j?=
 =?us-ascii?Q?GtgFzi7v78AIEG0z9wDZ4sE6I8e04DhvDo8OG6mpV7EeVmfNj6QMKycFjtLa?=
 =?us-ascii?Q?/L1EokxMwfl43eKAV2SPHYLWBuL6in4dJ88Urc6AsFfMhGHmz/gBqIaAYiTh?=
 =?us-ascii?Q?O79CHEnzVzYMM6uExTaCI7d4AoZzmWBry7xSENfSQEiPxIemNVaoBc5mQBAR?=
 =?us-ascii?Q?nPE2KeVR8jGSrEo=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014)(7416014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2025 06:04:58.2490
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 86fd8813-57a6-417f-6a64-08ddde1d2933
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002529D.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8499

When running an AMD guest on QEMU with > 255 cores, the following FW_BUG
was noticed with recent kernels:

    [Firmware Bug]: CPU 512: APIC ID mismatch. CPUID: 0x0000 APIC: 0x0200

Naveen, Sairaj debugged the cause to commit c749ce393b8f ("x86/cpu: Use
common topology code for AMD") where, after the rework, the initial
APICID was set using the CPUID leaf 0x8000001e EAX[31:0] as opposed to
the value from CPUID leaf 0xb EDX[31:0] previously.

This led us down a rabbit hole of XTOPOEXT vs TOPOEXT support, preferred
order of their parsing, and QEMU nuances like [1] where QEMU 0's out the
CPUID leaf 0x8000001e on CPUs where Core ID crosses 255 fearing a
Core ID collision in the 8 bit field which leads to the reported FW_BUG.

Following were major observations during the debug which the two
patches address respectively:

1. The support for CPUID leaf 0xb is independent of the TOPOEXT feature
   and is rather linked to the x2APIC enablement. On baremetal, this has
   not been a problem since TOPOEXT support (Fam 0x15 and above)
   predates the support for CPUID leaf 0xb (Fam 0x17[Zen2] and above)
   however, in virtualized environment, the support for x2APIC can be
   enabled independent of topoext where QEMU expects the guest to parse
   the topology and the APICID from CPUID leaf 0xb.

2. Since CPUID leaf 0x8000001e cannot represent Core ID without
   collision for guests with > 255 cores, and QEMU 0's out the entire
   leaf when Core ID crosses 255. Prefer initial APIC read from the
   XTOPOEXT leaf before falling back to the APICID from 0x8000001e
   which is still better than 8-bit APICID from leaf 0x1 EBX[31:24].

More details are enclosed in the commit logs.

Ideally, these changes should not affect baremetal AMD/Hygon platforms
as they have supported TOPOEXT long before the support for CPUID leaf
0xb and the extended CPUID leaf 0x80000026 (famous last words).

Patch 1 and 4 is yak shaving to explicitly define a raw MSR value used
in the topology parsing bits and simplify the flow around "has_topoext"
when the same can be discovered using X86_FEATURE_XTOPOLOGY.

This series has been tested on baremetal Zen1 (contains topoext but not
0xb leaf), Zen3 (contains both topoext and 0xb leaf), and Zen4 (contains
topoext, 0xb leaf, and 0x80000026 leaf) servers with no changes
observed in "/sys/kernel/debug/x86/topo/" directory.

The series was also tested on 255 and 512 vCPU (each vCPU is an
individual core from QEMU topology being passed) EPYC-Genoa guest with
and without x2apic and topoext enabled and this series solves the FW_BUG
seen on guest with > 255 VCPUs. No changes observed in
"/sys/kernel/debug/x86/topo/" for all other cases without warning.
0xb leaf is provided unconditionally on these guests (with or without
topoext, even with x2apic disabled on guests with <= 255 vCPU).

In all the cases initial_apicid matched the apicid in
"/sys/kernel/debug/x86/topo/" after applying this series.

Relevant bits of QEMU cmdline used during testing are as follows:

    qemu-system-x86_64 \
    -enable-kvm -m 32G -smp cpus=512,cores=512 \
    -cpu EPYC-Genoa,x2apic=on,kvm-msi-ext-dest-id=on,+kvm-pv-unhalt,kvm-pv-tlb-flush,kvm-pv-ipi,kvm-pv-sched-yield,[-topoext]  \
    -machine q35,kernel_irqchip=split \
    -global kvm-pit.lost_tick_policy=discard
    ...

References:

[1] https://github.com/qemu/qemu/commit/35ac5dfbcaa4b

Series is based on tip:x86/cpu at commit 65f55a301766 ("x86/CPU/AMD: Add
CPUID faulting support")
---
Changelog v2..v3:

o Patch 1 was added to the series.
o Use cpu_feature_enabled() in Patch 3.
o Rebased on top of tip:x86/cpu.

v2: https://lore.kernel.org/lkml/20250725110622.59743-1-kprateek.nayak@amd.com/

Changelog v1..v2:

o Collected tags from Naveen. (Thank you for testing!)
o Rebased the series on tip:x86/cpu.
o Swapped Patch 1 and Patch 2 from v1.
o Merged the body of two if blocks in Patch 1 to allow for cleanup in
  Patch 3.

v1: https://lore.kernel.org/lkml/20250612072921.15107-1-kprateek.nayak@amd.com/
---
K Prateek Nayak (4):
  x86/msr-index: Define AMD64_CPUID_FN_EXT MSR
  x86/cpu/topology: Use initial APICID from XTOPOEXT on AMD/HYGON
  x86/cpu/topology: Always try cpu_parse_topology_ext() on AMD/Hygon
  x86/cpu/topology: Check for X86_FEATURE_XTOPOLOGY instead of passing
    has_topoext

 arch/x86/include/asm/msr-index.h   |  5 +++
 arch/x86/kernel/cpu/topology_amd.c | 55 ++++++++++++++++--------------
 2 files changed, 34 insertions(+), 26 deletions(-)


base-commit: 5bf2f5119b9e957f773a22f226974166b58cff32
-- 
2.34.1


