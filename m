Return-Path: <kvm+bounces-16137-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D64EC8B50FD
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 08:08:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4B2AA1F22B74
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 06:08:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7371171A2;
	Mon, 29 Apr 2024 06:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="TR1SE67U"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2056.outbound.protection.outlook.com [40.107.220.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 580BD1118C;
	Mon, 29 Apr 2024 06:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714370850; cv=fail; b=k/4dMovw147m9P7GC1qZxhdSScdP5xSYpGjXtzLT47I+SbfClAbBWRR1eMbiP54vGdcUxaNSsPON0SbmK3fTokY5ewWnPnTpRwbMWvu0qNU3kc79p/15bdv31wurZoiXFFgcY146yuPoqfBk9mud4w84ph6KhGve+yF5hrbcyoA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714370850; c=relaxed/simple;
	bh=ras1VaHYuFIRJVzQ3MENYbDFOqRJGYwed4/QZ3uXv50=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NRtlucYuroBAkgfPJKK10WnooFEqYSn5czEzHkBQXQPMNdS087TIx1vMn0Skt70IZdHpX1yRvTeSBWtmMLx6JuUdQIJQpaRKA2b7OD3w6yhFevM7msKeoxhmY5O66oeKNBRiiNiFruQ3obKXKh1FdbNoOq+vYjCB0agN/7HdWrM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=TR1SE67U; arc=fail smtp.client-ip=40.107.220.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YbRXegXVPfRqciQ+UszqBb3+dxFc6vC4Y2l0nfVFhDHC7F0u6NVsUjAC/1a/YmZ4fMFiFBJuJSuvV8oP7vn9LuYwX5dspsMKEqTBCw3GA0e4/qrcX8IyhvfX3DVjQ9oA8pj18BZwnJiBEcLGKbztLEVPaHi4Grfeng9oCcPLKDZLMVfB+uKaE3QjAUpS0din1kywH02GqnRzQkBX7nmRf7aBXV3n+DxE7WrAbx8T8SxkkgQepX18Pesp/NA/kSGkgHB9HokTilo75ti1H1TOqv8UG87+8F0hxHN0esLCUOsQMLmcaifeCQTMZnWO6uVglcY/b5h26vdlChVPRrAcYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ORCB7Jc6JmFLEp5ZunXEUWD032QU3Pl/PHuz5Tlqxo0=;
 b=DquTRWW3HEHi2AL2t7vTj6gfWXzFxraxiIL2gcDNIde3vLTxlCZaiR3fYYjhvKweGNNfhFimtK09dlN1gvlYAHrgRSW/sz7ASMOncx9tYA4VwsYjuS8Sxmm7oSNimX2tTjR+/dHWQyvnF2IAoAht3MxmyyX2nnJ2z4r7QPobYyuFUxo1Qi4Z8yx4nDK8djOxnmBpa52znYnId6pwGphbWs0OTsinSczLaPCZ/gBl4H6i7LKm2Iif85KSO8eKPM8NDemdKprdIuFzUAHn8D3cQ55Zqrj4qfxGs2utGhVFfv+RblGsrB1gvszefeq9/9Z8f1WrYFD5vQ/ErTBxhzzHJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linutronix.de smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ORCB7Jc6JmFLEp5ZunXEUWD032QU3Pl/PHuz5Tlqxo0=;
 b=TR1SE67U/7RL+hXozLGxPXc07xErDsdZfkat3ZAk0FrgR8qONlsNfMbKAi2ZrwveYVQ4IlCCZUsc4tUDUqMSPSysGEyN+jUg5EKjUkiCDEtG3DfLijblLG/pzAsNNsb8HZH77b+5QuB3HG/v47WPP/GSxkvLxFLxpUL33TE/AQ4=
Received: from CH5P221CA0008.NAMP221.PROD.OUTLOOK.COM (2603:10b6:610:1f2::24)
 by CH3PR12MB8581.namprd12.prod.outlook.com (2603:10b6:610:15d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.34; Mon, 29 Apr
 2024 06:07:26 +0000
Received: from CH2PEPF0000014A.namprd02.prod.outlook.com
 (2603:10b6:610:1f2:cafe::33) by CH5P221CA0008.outlook.office365.com
 (2603:10b6:610:1f2::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.35 via Frontend
 Transport; Mon, 29 Apr 2024 06:07:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH2PEPF0000014A.mail.protection.outlook.com (10.167.244.107) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7544.18 via Frontend Transport; Mon, 29 Apr 2024 06:07:26 +0000
Received: from BLR-5CG113396H.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Mon, 29 Apr
 2024 01:07:17 -0500
From: Ravi Bangoria <ravi.bangoria@amd.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<thomas.lendacky@amd.com>
CC: <ravi.bangoria@amd.com>, <hpa@zytor.com>, <rmk+kernel@armlinux.org.uk>,
	<peterz@infradead.org>, <james.morse@arm.com>, <lukas.bulwahn@gmail.com>,
	<arjan@linux.intel.com>, <j.granados@samsung.com>, <sibs@chinatelecom.cn>,
	<nik.borisov@suse.com>, <michael.roth@amd.com>, <nikunj.dadhania@amd.com>,
	<babu.moger@amd.com>, <x86@kernel.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <santosh.shukla@amd.com>,
	<ananth.narayan@amd.com>, <sandipan.das@amd.com>
Subject: [PATCH 2/3] x86/bus_lock: Add support for AMD
Date: Mon, 29 Apr 2024 11:36:42 +0530
Message-ID: <20240429060643.211-3-ravi.bangoria@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240429060643.211-1-ravi.bangoria@amd.com>
References: <20240429060643.211-1-ravi.bangoria@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF0000014A:EE_|CH3PR12MB8581:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a9530dc-3624-4a4f-64c3-08dc6812a503
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|1800799015|7416005|82310400014|376005|36860700004;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pb+AqvPlYVq3kAZ7bubZkZxHU8KhW/68EdBnQYfQGXfmhgNTvTzACYkJ+9ft?=
 =?us-ascii?Q?CtUlBCPgCUP2UXrYghtj8bWyawQSvz6rSNwbDIFbsh4kTnEP34rY7tYR/1+V?=
 =?us-ascii?Q?LJ4CxrDheq27reX0hxE99tK2N64Sr2gpr4uE18vbHtZ7LTJKIMiyou7AHdHG?=
 =?us-ascii?Q?zRwNdvye0fW+oHN8vi/Dykb4qu2TaaVS6XUqEb/24b+/WUUp/PYO4bgcqYbl?=
 =?us-ascii?Q?pG4Dvkow8k35P7PHbZ0oOyUrLGFELqe8INAHwzagJ6vMcYwCfmFr1/NwxVE+?=
 =?us-ascii?Q?hwPdy4zjMNB7qraYGemTfq4HFwRZ+KSocqCsut58D48uJ8snEhTwDEbgRAWI?=
 =?us-ascii?Q?iB7YBKOdpchQrLIyenNQSxmifKxEKpJVgUuefCZLWaLtyidB1xSw8DC1HFpM?=
 =?us-ascii?Q?DlqBi6gLDVoGN64zR4lro3XCqfvr9ADOLwx6zecycJXjuC0euoSy3sjZx9RB?=
 =?us-ascii?Q?v1xARQMr5xYx768jvDVb7qKr09Up9nT31GPLoUxA8zGGcTlDjwzNmMirKtHR?=
 =?us-ascii?Q?GvAS9xO249+Nz06zphGESXXJ9sRNHOdFIelix7LU3kvq+qMQZlIA2bt6FNGF?=
 =?us-ascii?Q?oQmLh/DU5zmn40kzAZbJr2lUzEy4d33Qc79Tvfxk2pPSdIONLAiaN0ppD5LS?=
 =?us-ascii?Q?MbyD0Lib+SsO3hyrBvgd8Y3CvOofo8FlqEoCQVnUUBY6MM+qusAeBTprxilw?=
 =?us-ascii?Q?mhQx/dkC15m8A2nTMs7WbcYv6qeN200JUQq05OTPQqvWb8dlBembKO/aoQck?=
 =?us-ascii?Q?ptG4QJUZfV30PV+Fu0fV2hFrdbvqrVtPFcmhMvvvIZrloYx5DmuDd7EN3XRC?=
 =?us-ascii?Q?LXlc4iCd0Q26I4i69qblg5uMZkyj2xOBEdR2h+Vgn9fO32bmMXeMkiF4F6lv?=
 =?us-ascii?Q?X1WgpdOt50DFT4zjpZwgm4MFddi9vXJk5UeyfP+9Rz2jJnfegCmg6EShuCVj?=
 =?us-ascii?Q?ttcs4+eUry4VVQfdyYGP0qTbLk0c9zWWXkoYm6ZfHTrheHkgTeUyYl4IuUjd?=
 =?us-ascii?Q?cJ5TYbv+YicveoeMIr7R6TEKpsA74w/ch4rdPxwmTszrylR6IdvwD9fxnKa/?=
 =?us-ascii?Q?KK8j443Ydh35LTqXxW9Okom//gmBYEto3+rAy4r0p23dCIhrEPSkA6wwUcJh?=
 =?us-ascii?Q?qiO9noIndXUZi2WFj0Bhqagkg6CLsG3kQzdtQI7jPDg9/aOEdUnpLzPr/AaX?=
 =?us-ascii?Q?c43KphtaBpG1ithObFY2EEgPv5tseIcaYok503izFUE7Hcoq9zx+8/+H7eKY?=
 =?us-ascii?Q?PktB+URIIxhjdcq+UbXzdXDPkb6BObmyNF1g9NmX9euk9jpDL78LqDCgJ5UU?=
 =?us-ascii?Q?44zTJv1btkPIcAqf9kQxbESd?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(82310400014)(376005)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2024 06:07:26.1774
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a9530dc-3624-4a4f-64c3-08dc6812a503
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000014A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8581

Upcoming AMD uarch will support Bus Lock Detect (called Bus Lock Trap
in AMD docs). Add support for the same in Linux. Bus Lock Detect is
enumerated with cpuid CPUID Fn0000_0007_ECX_x0 bit [24 / BUSLOCKTRAP].
It can be enabled through MSR_IA32_DEBUGCTLMSR. When enabled, hardware
clears DR6[11] and raises a #DB exception on occurrence of Bus Lock if
CPL > 0. More detail about the feature can be found in AMD APM[1].

[1]: AMD64 Architecture Programmer's Manual Pub. 40332, Rev. 4.07 - June
     2023, Vol 2, 13.1.3.6 Bus Lock Trap
     https://bugzilla.kernel.org/attachment.cgi?id=304653

Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
---
 arch/x86/kernel/cpu/amd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 39f316d50ae4..013d16479a24 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -1058,6 +1058,8 @@ static void init_amd(struct cpuinfo_x86 *c)
 
 	/* AMD CPUs don't need fencing after x2APIC/TSC_DEADLINE MSR writes. */
 	clear_cpu_cap(c, X86_FEATURE_APIC_MSRS_FENCE);
+
+	bus_lock_init();
 }
 
 #ifdef CONFIG_X86_32
-- 
2.44.0


