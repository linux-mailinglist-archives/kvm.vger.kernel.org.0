Return-Path: <kvm+bounces-55596-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 715B1B33851
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 09:58:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 59B491896361
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 07:58:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 287E2299A94;
	Mon, 25 Aug 2025 07:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="e6NZaX0d"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2057.outbound.protection.outlook.com [40.107.94.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7997C28850B;
	Mon, 25 Aug 2025 07:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756108682; cv=fail; b=Fu3PhX8ViCJu3to7maM3Q2dx8icgFDdJYkgJRYFENzLILiQkrNpAkG+MULURvm5FNzxonqi9TEdj8nfRHyD+NIhNhyRGUW51a1yzVMC77D4AUNZi+dyl/tNxlbkJ8sHRsd78VSjkxwz15NWpAcNFSMidxCo+APFtoMcZC/sVViY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756108682; c=relaxed/simple;
	bh=7QrPpJ0CjhiSyex3aiBE9B/wgiX1cuKyWQE+Gzf5muc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=uibt7mCHYEudm7cOn/oNYhUet/mhAGXNk4bzQKZWh5rzFYeU44pzkZIwfAMEUBPLKM1z/ljM/yxiE9UFQtPRwaoTM9Et44RVSJy58zc+e0RoisL3u4iFNGzzUhxCbFG76N1xMeEhZfSxv5jT49UT6xGIZksDnKReRC8cWlOehuw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=e6NZaX0d; arc=fail smtp.client-ip=40.107.94.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nN4OzJPnTlbQpcF1O24LsTP94g04B98RaD0UpjpA4KXh4o1Yb0Ehn6TWWjE3pj+R7jBZfzXNU5zB4uWHCjDIFnisTfq33DRsd8vDYJZwV78jMQmv+J+TZfhUO9BlVu/57gHd6QD3Yeu83u4Q9ch1YIb/3UatncGXQdnIIDUC8f7wUOK6qk0vwkngiLJj46KTcncqYi60Tx7v43SSPNFho9UTrtf48ff3FTiC2JqqOkog2x4x7Zk3rNGKbdiIZOkICvLQ5t9oCxXX9cjP31qr/QY8ZaAV5rCP//gp8L32tJPYpxShBMlvfsl7+MmDB3VqUc7xPF1CgJ0UqjZGimYdRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7iR/WBGh6HNCQGtUl0Nud70qsfeRAJ86W9sbK+z1V+0=;
 b=dViniQQXUO8ouUJflTYuD9RbUldvkZB3XfxH7jxayAhmR22SFFchJt+opYPSjqQv7mUy0o4mVQKzhrDKCyqWwrQ1Alk6mlJfIhs2ZMqoedmtQ7aaTj5YJby2yDYq4zH6urk8KKZepChSLNV7XgeWEwk48kVLy3x749LamZM8JxkOLuhhZGydR6SquRUMggV8IedVstwqdhNEJfPatxWk1oOmCmhr55NBDxFhU2amDMtARs0LusGoyc1g1YgNyDrGGJA/stKrTGN5ULWnvBWvkc5Hz9P1Zu8AzIjyH9W4S6PJ97gvOS4m1z5KY3e5b8J8SSY3PAEjinp9EUUOeOkI+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linutronix.de smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7iR/WBGh6HNCQGtUl0Nud70qsfeRAJ86W9sbK+z1V+0=;
 b=e6NZaX0dquJXf/eIOsLF1DIPvfYWzaSxwWd/tlYNeGTNxh40exDJhRviwiTj+p2Wmk1ItTv7r2ZMhyGe0kRNqTP4dcaURasKhWYy/dC6DtyXhhnY1NBd5boBw+aATX22BpNLzrxJ1gVErkr/DmUv0G9yNXyzp9++HzwLlexpaj0=
Received: from SA1P222CA0108.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:3c5::29)
 by CH1PR12MB9621.namprd12.prod.outlook.com (2603:10b6:610:2b2::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Mon, 25 Aug
 2025 07:57:56 +0000
Received: from SA2PEPF00003AE6.namprd02.prod.outlook.com
 (2603:10b6:806:3c5:cafe::a4) by SA1P222CA0108.outlook.office365.com
 (2603:10b6:806:3c5::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.22 via Frontend Transport; Mon,
 25 Aug 2025 07:57:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SA2PEPF00003AE6.mail.protection.outlook.com (10.167.248.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Mon, 25 Aug 2025 07:57:55 +0000
Received: from BLRKPRNAYAK.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 25 Aug
 2025 02:57:47 -0500
From: K Prateek Nayak <kprateek.nayak@amd.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<x86@kernel.org>
CC: Naveen rao <naveen.rao@amd.com>, Sairaj Kodilkar <sarunkod@amd.com>, "H.
 Peter Anvin" <hpa@zytor.com>, "Peter Zijlstra (Intel)"
	<peterz@infradead.org>, "Xin Li (Intel)" <xin@zytor.com>, Pawan Gupta
	<pawan.kumar.gupta@linux.intel.com>, Tom Lendacky <thomas.lendacky@amd.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, Mario Limonciello
	<mario.limonciello@amd.com>, "Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Babu Moger <babu.moger@amd.com>, Suravee Suthikulpanit
	<suravee.suthikulpanit@amd.com>, K Prateek Nayak <kprateek.nayak@amd.com>,
	Naveen N Rao <naveen@kernel.org>
Subject: [PATCH v4 0/4] x86/cpu/topology: Fix the preferred order of initial APIC ID parsing on AMD/Hygon
Date: Mon, 25 Aug 2025 07:57:28 +0000
Message-ID: <20250825075732.10694-1-kprateek.nayak@amd.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00003AE6:EE_|CH1PR12MB9621:EE_
X-MS-Office365-Filtering-Correlation-Id: d901b8a2-2839-4eee-932e-08dde3ad19bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|7416014|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bPeFSCROWpO/vT80+qLExP7YjmIr4g/cfuoWnoHXIjAY8nECzC+TRvMSE+nl?=
 =?us-ascii?Q?6vGdaBW9eR1sVo54E7EIEJfjC2fROJyfbgbukCQvX0Yd2ValNfc8RqJXIA8O?=
 =?us-ascii?Q?lk9dGliDBrO0HWVTlFODVmOSCiwXj4t/L2hUr2cMyPHBQ+u4IrMbBSBq8x+S?=
 =?us-ascii?Q?29RNKnoBN9CIv5sBpG3Vt3yMEOnjzeMILIe2NK7RQfIHEjlfTNRhH7vCqEkW?=
 =?us-ascii?Q?wKWVRcvS2KnFwNHCSvy5TJZGA7GhkaMcb0b85V+ihTqiMXesIjOxDyyPn3UZ?=
 =?us-ascii?Q?eyl8Knl64RkXlwoNsizhMgEu24XnPwdyCD8bU4YDIE9zpCw8f1Q1xzazOWc8?=
 =?us-ascii?Q?WqyqKb3WLmfcGF4oy0TJw65ewou0rG5dD7Ph4n1CpetNvh+InXV81MJ1k/gJ?=
 =?us-ascii?Q?APWnS0Ub2CluVJW9z+d5j35xKYaf4H7cXG/O24zYcqjEdzLnnB7RPqj4BmOR?=
 =?us-ascii?Q?E/c8etwqxLjC8MVoZdMZKsPJ/NhSfLbcPYfh7wEAz5VdM39jOXN7OnQ7pzRN?=
 =?us-ascii?Q?OD9tQ0QzZiz50+khl81eGWcULjfbfK2MLo5270z3bqOd95c1/p1OvFuHGNtl?=
 =?us-ascii?Q?fuW8MfUUoi9e+mNUXf2/YiaTmOc+kLgpo03PhIwFqOy8Aoe2m2lMOKb06vbU?=
 =?us-ascii?Q?JlXPsK2E25U740KwSI3QSdwZkhX+OeQ0ChjHQzIEip90f8mB0H/vXw8mB76k?=
 =?us-ascii?Q?igYE5fTsvgcyHJMU28uKD6pXegFfFc9swsHjNJLman4Kj/UI4hnDzybGvG4l?=
 =?us-ascii?Q?RImh6Q3dIBsfuo1TJNwXc9qGk7+rSrumRScacEIML+EOnkpWNUPIcnqqi54D?=
 =?us-ascii?Q?1PzihN3dUWleFOuNi0v3XRdMmw+akcha3/7Uh19tw/ebk2dOYu51fTED9d8w?=
 =?us-ascii?Q?CKG0j/vwhjG2IyFCE1+WR6vRoKqfnWGYX4J9xCd9vP09oaNfsTsyO0OgDrwA?=
 =?us-ascii?Q?apCRVczuQjvQsBQbwHQJcVa9VMjcZUcjF/MRBpjCDGDKXeB/ArLL4LdyJtl0?=
 =?us-ascii?Q?ioB3+it31zcQTmHR/xzuUK0FtR34hekjZJhvaFk1rzU/2Dtt9eL4M9tbPVhL?=
 =?us-ascii?Q?wJ6I6DIK9SxI1lnT++UkkXoFSSESgYweBoOPs2fnsULNmU3lVPNm6oH8vVW2?=
 =?us-ascii?Q?0BhkWsA08b0H/9ogWFo+ydU1SFxQsDBjb8G4U+fQah9fuFproeK2aA13jhGl?=
 =?us-ascii?Q?LmM5imLifIc6hvwpPpAgheoKGXXl6xK9OFwPhah1YzTrMSvK0TqGv8M+7awS?=
 =?us-ascii?Q?NFs7RzpXm6rxeJJ7/sVijwWOc9DxZD0gLWOq9tgOEXidqU5GT2a/Ybv781dP?=
 =?us-ascii?Q?6gR7UAg+5EsM/3u6K2TN3bf9hQYgkXAv4PXoo+rRaveKz0WCN1QXz+qtOBDi?=
 =?us-ascii?Q?08HqdYxMwKrQmCz2Y7aTQstu4ZJVdW2Yk/WTWoAjkSD2OTvA3atj/IgGOo4Q?=
 =?us-ascii?Q?O8uWSFPZmD4H9MavuQNg5ZVXlQgyIQ7hpSlgcOY3ZrBNGgp1vJ9R3F3KNhnp?=
 =?us-ascii?Q?7BjcILoI2B5mXAgIU7hwlXmxYUCmGD58fxyDxaQ/gI2M4gJ0U1LPqeBBlQ?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(7416014)(376014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2025 07:57:55.6451
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d901b8a2-2839-4eee-932e-08dde3ad19bc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003AE6.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9621

When running an AMD guest on QEMU with > 255 cores, the following FW_BUG
was noticed with recent kernels:

    [Firmware Bug]: CPU 512: APIC ID mismatch. CPUID: 0x0000 APIC: 0x0200

Naveen, Sairaj debugged the cause to commit c749ce393b8f ("x86/cpu: Use
common topology code for AMD") where, after the rework, the initial
APICID was set using the CPUID leaf 0x8000001e EAX[31:0] as opposed to
the value from CPUID leaf 0xb EDX[31:0] previously.

This led us down a rabbit hole of XTOPOLOGY vs TOPOEXT support, preferred
order of their parsing, and QEMU nuances like [1] where QEMU 0's out the
CPUID leaf 0x8000001e on CPUs where Core ID crosses 255 fearing a
Core ID collision in the 8 bit field which leads to the reported FW_BUG.

Following were major observations during the debug which the two
patches address respectively:

1. The support for CPUID leaf 0xb is independent of the TOPOEXT feature
   and is rather linked to the x2APIC enablement. In an effort to keep
   all the topology bits together during x2APIC enablement on AMD, the
   parsing ox the extended topology leaf 0xb was incorrectly put behind
   a X86_FEATURE_TOPOEXT check.

   On baremetal, this has not been a problem since TOPOEXT support
   (Fam 0x15 and above) predates the support for CPUID leaf 0xb
   (Fam 0x17[Zen2] and above) however, in virtualized environment, the
   support for x2APIC can be enabled independent of topoext where QEMU
   expects the guest to parse the topology and the APICID from CPUID
   leaf 0xb.

   Boris asked why QEMU doesn't force enable TOPOEXT feature with x2APIC
   [2] and Naveen discovered there were historic reasons to not enable
   TOPOEXT by default when using "-cpu host" on AMD systems [3]. The
   same behavior continues unless an EPYC cpu model is explicitly passed
   to QEMU.

2. Since CPUID leaf 0x8000001e cannot represent Core ID without
   collision for guests with > 255 cores, and QEMU 0's out the entire
   leaf when Core ID crosses 255.

   Prefer initial APIC read from the XTOPOLOGY leaf (0x80000026 / 0xb)
   which can represent up to 2^16 cores, before falling back to the APIC
   ID from 0x8000001e which is still better than 8-bit APICID from leaf
   0x1 EBX[31:24].

More details are enclosed in the commit logs.

Ideally, these changes should not affect baremetal AMD/Hygon platforms
as they have supported TOPOEXT long before the support for CPUID leaf
0xb and the extended CPUID leaf 0x80000026 (famous last words).

Patch 3 and 4 is yak shaving to explicitly define a raw MSR value used
in the topology parsing bits and simplify the flow around "has_topoext"
when the same can be discovered using X86_FEATURE_XTOPOLOGY.

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

[1] https://github.com/qemu/qemu/commit/35ac5dfbcaa4b
[2] https://lore.kernel.org/lkml/20250819113447.GJaKRhVx6lBPUc6NMz@fat_crate.local/
[3] https://lore.kernel.org/qemu-devel/20180809221852.15285-1-ehabkost@redhat.com/

Series is based on tip:master at commit 7182bf4176f9 ("Merge branch into
tip/master: 'x86/tdx'") and applies cleanly on top of tip:x86/cpu at
commit f3285344a5a3 ("x86/cpu/cacheinfo: Simplify
cacheinfo_amd_init_llc_id() using _cpuid4_info")

---
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
  x86/cpu/topology: Use initial APIC ID from XTOPOLOGY leaf on AMD/HYGON
  x86/cpu/topology: Always try cpu_parse_topology_ext() on AMD/Hygon
  x86/cpu/topology: Check for X86_FEATURE_XTOPOLOGY instead of passing
    has_topoext
  x86/msr-index: Define AMD64_CPUID_FN_EXT MSR

 arch/x86/include/asm/msr-index.h   |  5 ++++
 arch/x86/kernel/cpu/topology_amd.c | 48 +++++++++++++++---------------
 2 files changed, 29 insertions(+), 24 deletions(-)


base-commit: 7182bf4176f93be42225d2ef983894febfa4a1b1
-- 
2.34.1


