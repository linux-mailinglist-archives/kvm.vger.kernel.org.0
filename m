Return-Path: <kvm+bounces-56515-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 91719B3ECE8
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 19:05:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4FF4E3A6F93
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 17:05:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B77F0312827;
	Mon,  1 Sep 2025 17:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="UvkDRROn"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2088.outbound.protection.outlook.com [40.107.94.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4011F302CB4;
	Mon,  1 Sep 2025 17:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756746302; cv=fail; b=ilgqrqV/3+8UwgSayzGB8gDW2lRzT2vGp+tocnJbxviI5pmQvTSvz9D3lUfxMk+iFbNvoUD9ddm5Ql+8h/r2Am0odc9YrGaPlO+2Byg9t7oRXqpbww5KUmjagRr7Tee1ETsRbeCZ2S92xHBt8juJLUfmHCAUNOmBW1tTIYz6PMU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756746302; c=relaxed/simple;
	bh=a7GsrEdvBvRuHRfUI/oHWsCwNHN1PYQ5LE/Ht7s/gws=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=r34zbIY3NoXU6dNanDlVxNACJ8NmG+CMMu4kt61gsAUH8Z3whZBNrVSoc7d08VnGshQkd+SV8DE+H9hCRBsAN6iA5SHj6lnBlz4linMIlmM9/JIN7k8kDqnyTkdcQ0xuEWCDENVUZYJGMf40kfFP//d33cmZVFkowbRelULdWbM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=UvkDRROn; arc=fail smtp.client-ip=40.107.94.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s6otLlZGGam9GZRuPWXIfIttYYWDLRfhH3iHm8UGB0u7QdaUgVuHRDipDOxs2OKwZF6M+Mm4Jc0IHLCkvycqoD4PxRJBRXo/3zZxSJzQLlpLI1IEKPiE9+Rbpzkl/ckVVTOlRKQqFN8fXevazPWHyATiKf2h7m/JcqCfhjHKPq2OndfqtrHyxS1kY8mJeP+IFOGri/ZU1WRkXfq0GElEkYxxeXnGWx1AxBJzEPU0VE2Wsm5UrZ6jZyPgbmEF4d7l8uczUHDRnUsM1Tdi6o9TfgMczW40HkfVXi8d24c3S43VON4idYIKic2be2Oce3qQUYsBwmOzeXQ9bFEu2bfzZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=52KCVDTbnwMuECYVUtFr6Hgf3Khb36s+7gvVU2u9RS8=;
 b=Tgl+ag61d6/GDrTUFJhO5/NaJPDprySznzrsvgjavzGOJZz+mSJpLDACDzWF4Ij82CothPbsEKuDLshldxbct+KhXYqMkGoCHRXU4i02dPzarVlsdZAkerlPT+J6iMIuxZwBWq2dRJ3L+xATkTVPFBurJHAtCZU7YXw4xPwUpzuxRksFdWKMnI8hfyy0gqa9O073hqUxiwaHIVhmgp3NUMIU7yMAUgPad1DyPvKbQ4/wVaarwXuTFevMAUPpNse8S1rRTFQYSMBHJlcDmUfQ+4+Llc1UQfubBPJBu2euqDwPpSwtg/D9cmGFdkxS1zjQ/OTsN47sQueEJ44aeCgv9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linutronix.de smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=52KCVDTbnwMuECYVUtFr6Hgf3Khb36s+7gvVU2u9RS8=;
 b=UvkDRROn+ldRxprQkw/8zjdR8UcQ1wSDCHbvpRDDudLk+29xh08A8ImnSI+tWXn+CNX36bWp9Cbv/UU7ImT6SYQFh+RQGwTj7V1rc1k5EAumqQV8cwOImbm9Jzh6pOq6zWIw58wusukCFRJTWPTPT/SJQpA6JX7fqyVOXGjv/zI=
Received: from BLAPR03CA0003.namprd03.prod.outlook.com (2603:10b6:208:32b::8)
 by BN3PR12MB9595.namprd12.prod.outlook.com (2603:10b6:408:2cb::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.25; Mon, 1 Sep
 2025 17:04:55 +0000
Received: from BL6PEPF0001AB75.namprd02.prod.outlook.com
 (2603:10b6:208:32b:cafe::56) by BLAPR03CA0003.outlook.office365.com
 (2603:10b6:208:32b::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.27 via Frontend Transport; Mon,
 1 Sep 2025 17:04:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB75.mail.protection.outlook.com (10.167.242.168) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.14 via Frontend Transport; Mon, 1 Sep 2025 17:04:54 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 1 Sep
 2025 12:04:53 -0500
Received: from BLRKPRNAYAK.amd.com (10.180.168.240) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Mon, 1 Sep
 2025 10:04:46 -0700
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
Subject: [PATCH v5 0/4]  x86/cpu/topology: Fix the preferred order of initial APIC ID parsing on AMD/Hygon
Date: Mon, 1 Sep 2025 17:04:14 +0000
Message-ID: <20250901170418.4314-1-kprateek.nayak@amd.com>
X-Mailer: git-send-email 2.43.0
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB75:EE_|BN3PR12MB9595:EE_
X-MS-Office365-Filtering-Correlation-Id: 01b53110-9b4b-4777-559e-08dde979ac10
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|1800799024|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VhQ51EGkniHk717txwY/quLPVy1F3ln4sUODbwwXRlPT9fM5M7IUhEYLlfYN?=
 =?us-ascii?Q?xcWonew9eAMOBbZHxW+hlDhfJmIG4ImrQkeMe6Z28l/r0wNASkM1bjd+ehh/?=
 =?us-ascii?Q?p3te+vExDEE9AQ0RX8pBdQeFB9zgc0p5kPuJDzfEM4koc7bWmz0v3GwgDHca?=
 =?us-ascii?Q?YNxi9CchoI4wDKNvwb9GUM8SkmTiBArsLi7XEC02neuyiprpMMvFaW6He9kA?=
 =?us-ascii?Q?f/QyW/ddf0DprKYHED/cWI95c0tQZnyRhK9g+rJftf0vX4OLM5mMKJCUy4mC?=
 =?us-ascii?Q?/YGZsa9gARz74RoJ181kfPZ54/3lM1r4dnJPYwTa+K+/uiBN5ROoC/BPliH2?=
 =?us-ascii?Q?vLZkLpu6UTN3wdAReKCleRPt9bSjpeB/3v0u3+UTKM9dPbBuqUggBNoKrz/M?=
 =?us-ascii?Q?GzCdT2ENRWEGTpomf6CSsFDkWw16Ab5VNn3QpjTwo2GLQ1XMLmgTAz8Y6CCL?=
 =?us-ascii?Q?aAIMVui+PDvu8uN0t4xKZIHjHXUaxhOg4c1HUjQLO/1xiJ7kwgSw4x0aOA80?=
 =?us-ascii?Q?xEwR8diTdw3R9swSLS43EgkAjcuG+EHwXgXXNLY/DPDaNYdQ/usn5pUWd44p?=
 =?us-ascii?Q?/EaCCMRlWsilV98RvlDdfpXzUEWrqEKOQk+g9aoyvpI+LlqL+xbusbvxDiEM?=
 =?us-ascii?Q?xC4tCY7Xp2a2YoPKbQ0Rx7IP4tyqrZnat/HGy6h9ga5vUP/VZQsKQoeFoRco?=
 =?us-ascii?Q?9J999eni/YbKQIGU2ThRydU70wQpy9gfNSP1ENIXyuyO35V4xW015JUTo6/I?=
 =?us-ascii?Q?MNUlcQlMtKPCPdpDL3p0yraNCLUF2FJM8gN0NDoc0xA40gGztawaBxuF6/u+?=
 =?us-ascii?Q?ZyOh6Ry+cGyHyZoGtDVOa3rKDaKsAG9dJz3fMXALT7aSxxE27Gv3m49U++7X?=
 =?us-ascii?Q?7kvmhHBS0CGoXUSngXC3cIk1cgEcaBUsKrBRSTG0VChI1A1/26SOYd6RRVSF?=
 =?us-ascii?Q?GnWJW6l74nxtrKWL7zIqrmsYVnJx/HKFqIbPDckLth02EPrHtL5UMX5+WD0Y?=
 =?us-ascii?Q?zO46FxdfcEN9un+wh9Cudth77zgJWIVfgjBfM6+EW5pfPmR7tAUSXtkZgQYQ?=
 =?us-ascii?Q?0/1QTGT2gxRcMLPnammhG3ZA34iMMfXjpmaqSk0rg/0UM2pnPReB1UtUwhWg?=
 =?us-ascii?Q?oIQS5F88LdbHA1oB0WKu5grDJw297sUa5GaTW5CnxDd4uP5+Jvm07HpTGpaz?=
 =?us-ascii?Q?ne1wsTyELFXFtrARdXOsnL/52/hKnUyhIIXfTfMQYmte6pcpVMdvdf9amiZo?=
 =?us-ascii?Q?z1+zq3UckJBxOoo+B5gTgyPHS+MM8hrGKQjHzfHL6luakaUktQrJVCTRthxa?=
 =?us-ascii?Q?l6GU6nHTq2SLd3l9YtvCbHI7rPLICUQ+5lNq22cjUnk/0GnSVHPBeJReWA/W?=
 =?us-ascii?Q?vxU5mF2KyakIdRA5a4GWncnl5E9joMYIe7XWvDJVjtBIQVC3Fu/x09JPEUW9?=
 =?us-ascii?Q?lzVZxltn2LcCvSlg7okFkLcm3NsGruUvZO40171i0Qtst532UoSG5yqs5oEJ?=
 =?us-ascii?Q?N2scseQbKwf9udSNHLP3VIvcL5eYpadatI6aunpfp6mt68NeFbpuedAlGg?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(1800799024)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2025 17:04:54.3116
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 01b53110-9b4b-4777-559e-08dde979ac10
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB75.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR12MB9595

When running an AMD guest on QEMU with > 255 cores, the following FW_BUG
was noticed with recent kernels when topoext feature wasn't explicitly
enabled:

    [Firmware Bug]: CPU 512: APIC ID mismatch. CPUID: 0x0000 APIC: 0x0200

QEMU provides the extended topology leaf 0xb for these guests but in an
effort to keep all the topology parsing bits together during the
enablement of the 0xb leaf for AMD, a pseudo dependency on
X86_FETURE_TOPOEXT was created which prevents these guests from parsing
the topology from the 0xb leaf.

The support for CPUID leaf 0xb is independent of the TOPOEXT feature and
is rather linked to the x2APIC enablement. The support for the extended
topology leaves is expected to be confirmed by ensuring:

1. "leaf <= {extended_}cpuid_level" and then
2. Parsing the level 0 of the respective leaf to confirm EBX[15:0]
   (LogProcAtThisLevel) is non-zero

as stated in the definition of "CPUID_Fn0000000B_EAX_x00 [Extended
Topology Enumeration] (Core::X86::Cpuid::ExtTopEnumEax0)" in Processor
Programming Reference (PPR) for AMD Family 19h Model 01h Rev B1 Vol1 [1]
Sec. 2.1.15.1 "CPUID Instruction Functions".

On baremetal, this has not been a problem since TOPOEXT support (Fam
0x15 and above) predates the support for CPUID leaf 0xb (Fam 0x17[Zen2]
and above) however, in virtualized environment, the support for x2APIC
can be enabled independent of topoext where QEMU expects the guest to
parse the topology and the APICID from CPUID leaf 0xb.

Boris asked why QEMU doesn't force enable TOPOEXT feature with x2APIC
[2] and Naveen discovered there were historic reasons to not enable
TOPOEXT by default when using "-cpu host" on AMD systems [3].

The same behavior continues unless an EPYC cpu model is explicitly
passed to QEMU. More details are enclosed in the commit logs.

Ideally, these changes should not affect baremetal AMD/Hygon platforms
as they have supported TOPOEXT long before the support for CPUID leaf
0xb and the extended CPUID leaf 0x80000026 (famous last words).

Patch 2 and 3 are yak shaving to explicitly define a raw MSR value used
in the topology parsing bits and simplify the flow around "has_topoext"
when the same can be discovered using X86_FEATURE_XTOPOLOGY.

Patch 4 is the documentation patch that outlines the preferred parsing
order of CPUID leaves during topology enumeration on x86 platforms.

Previous version of this series has been tested on baremetal Zen1
(contains topoext but not 0xb leaf), Zen3 (contains both topoext and 0xb
leaf), and Zen4 (contains topoext, 0xb leaf, and 0x80000026 leaf)
servers with no changes observed in "/sys/kernel/debug/x86/topo/"
directory.

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

[1] https://bugzilla.kernel.org/show_bug.cgi?id=206537
[2] https://lore.kernel.org/lkml/20250819113447.GJaKRhVx6lBPUc6NMz@fat_crate.local/
[3] https://lore.kernel.org/qemu-devel/20180809221852.15285-1-ehabkost@redhat.com/

Series is based on tip:master at commit 4f0d2af9e565 ("Merge branch into
tip/master: 'x86/tdx'")

---
Changelog v4..v5:

o Dropped the patch that was merged.

o Addressed review comments by Boris on Patch 1.

o Included the documentation patch formally.

v4: https://lore.kernel.org/lkml/20250825075732.10694-1-kprateek.nayak@amd.com/

Changelog v3..v4:

o Renamed the series title to better capture the purpose. Based on the
  readout of the APM and PPR, this problem was only exposed by QEMU
  and QEMU is not doing anything wrong considering the spec.

o Fixed references to X86_FEATURE_XTOPOLOGY (XTOPOLOGY) which was
  mistakenly referred to as XTOPOEXT. (Boris)

o Reordered the patches to have the fixes before cleanups. (Thomas)

o Refreshed the diff of Patch 1 with the one Thomas suggested in
  https://lore.kernel.org/lkml/87ms7o3kn6.ffs@tglx/. (Thomas)

o Quoted the relevant sections of the APM and the PPR to support the
  changes. (Mentioned on v3 by Naveen and Boris)

Note: The debate on "CoreId" from CPUID 0x8000001e EBX has not been
addressed yet. I'll check internally and follow up on the QEMU bits once
H/W folks confirm what their strategy is with the 8-bit field in future
processors.

The updates in this series ensures the usage of the topology information
from the XTOPOLOGY leaves (0x80000026 / 0xb)  when they are present and
systems that support more than 256 CPUs need x2APIC enabled to address
all the CPUs present thus removing the dependency on CPUID leaf
0x8000001e for Core ID.

v3: https://lore.kernel.org/lkml/20250818060435.2452-1-kprateek.nayak@amd.com/

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
  x86/cpu/topology: Always try cpu_parse_topology_ext() on AMD/Hygon
  x86/cpu/topology: Check for X86_FEATURE_XTOPOLOGY instead of passing
    has_xtopology
  x86/msr-index: Define AMD64_CPUID_FN_EXT MSR
  Documentation/x86/topology: Detail CPUID leaves used for topology
    enumeration

 Documentation/arch/x86/topology.rst | 198 ++++++++++++++++++++++++++++
 arch/x86/include/asm/msr-index.h    |   5 +
 arch/x86/kernel/cpu/topology_amd.c  |  39 +++---
 3 files changed, 223 insertions(+), 19 deletions(-)


base-commit: 4f0d2af9e56558e125b321b176b25cd6ad5fdac7
-- 
2.34.1


