Return-Path: <kvm+bounces-44700-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 82247AA02E8
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 08:17:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BE4887B2036
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 06:15:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16CFB277808;
	Tue, 29 Apr 2025 06:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="dXxIemZO"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2068.outbound.protection.outlook.com [40.107.94.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 571C125D548;
	Tue, 29 Apr 2025 06:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745907318; cv=fail; b=MaW8n6CPTNbvQKS+GjSb6aUxavILoKY95THhBFvVnn86ljorNaSoZCij1xWGsYF3peXHjnGQ1ZX6s679RysiO98G0GI84FPgxaxiIh9zdmhIuuXbXLKqur5dK7dvtZ/5ge1+0W9mefQtldMwXv/29WaldGo1u4OusserenMdvxc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745907318; c=relaxed/simple;
	bh=unqtASnZA8/13YGLRDqYigMYNVDsmeCNQBw0O/fW7WI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ej182cHRSlHuQaKyPHyJV1FMw7ZLv3i/O71w/PuZound5Kv5HWuwOWbVepg8+TPPzkSYAYUmSNb2X4YViGan+KXXMqhtZ3VZr26DK2JxiEtTguLq7TvfRkXN8TvubyYaCbL3bJU3sQr0mAtQBoL8E3wz615Hczncph/TsQAZUNc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=dXxIemZO; arc=fail smtp.client-ip=40.107.94.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FG1UMNtsc2OgqdvS6ElsXKoxpaFk9niIIT5I3jU1iipe2CHsDcxXV70D1ZXPUuq+1ANz56Kypd2M1rGEh7xAGZZUGAZm/Asb4QwzVhqQ3APg35zW3b71ZgMTw51aFfsR0ZW5E32Cj08JWLQux8sxV7L9k0EXAlzFQrS7fbTIIp1LSoSgvNqQIQ6tc2eja1DAIT/HXtm83OxcMYZ2iYrdIf2pFARExdNEJht4ZTwui7OfLNFID/mKQ6xAfKAG5pOkz1lL63Uz/fZTS2oMcVIi1x/TIJtGYS9gDPTMng1nrO5lJQd//147vu547iyzKZF/JaIAzbV5qasnox8jVYHKFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jZtLnEg4thBb8VH0CE8x5/LSOvpxTNfakOFkg24DTIQ=;
 b=fCh+vPrskZLpAUmI4gObQgJKpixKZxOvE7/8Uu/D2flxA713UU/EZkv4fagEQAUVohGJKvMsRwK7i1zCbXuMNohquIhFKAIaTz28rP0i8gcsE51+PhxetDSIT9FC8ZUbHNVrhxhgeWTORGYU/Fwgy6MHHfKoGRf+yZwjbIN82mGdcUsHAVnHlZ0NxGngv1VFAZfO4LvK4z+9SwWJPTvc99PLNhIOuUdyBwNV2Th9YrnUwyhG9TBQj9esqUawem3cfcYKkdYrFHou7Ovm04lyr/QutSeEIh9Bobehl6RrImgm3o/YSJa0Vo4EN750rtEQnpQVhk4atBz7Ai0D/r4oHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jZtLnEg4thBb8VH0CE8x5/LSOvpxTNfakOFkg24DTIQ=;
 b=dXxIemZOlZMTUE4Jk4M2Echs5irMeBEI8JcoOLoXyvBQ5RIl1ywCrbfYjpQ2xawFZG5LFTZSFv1omauSY3OuHZSvKZksrxD601ePSA7No7Cy+RbM+/HWCaLIEvYPueirG6Zi3Ox7syEsCTgXW1SRDZCwglwED8wJVMN0+aho/po=
Received: from DS0PR17CA0013.namprd17.prod.outlook.com (2603:10b6:8:191::11)
 by PH8PR12MB7373.namprd12.prod.outlook.com (2603:10b6:510:217::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.31; Tue, 29 Apr
 2025 06:15:12 +0000
Received: from DS2PEPF0000343E.namprd02.prod.outlook.com
 (2603:10b6:8:191:cafe::f6) by DS0PR17CA0013.outlook.office365.com
 (2603:10b6:8:191::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.41 via Frontend Transport; Tue,
 29 Apr 2025 06:15:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF0000343E.mail.protection.outlook.com (10.167.18.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8678.33 via Frontend Transport; Tue, 29 Apr 2025 06:15:12 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 29 Apr 2025 01:15:04 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <francescolavra.fl@gmail.com>
Subject: [PATCH v5 12/20] x86/apic: Add support to send NMI IPI for Secure AVIC
Date: Tue, 29 Apr 2025 11:39:56 +0530
Message-ID: <20250429061004.205839-13-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250429061004.205839-1-Neeraj.Upadhyay@amd.com>
References: <20250429061004.205839-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343E:EE_|PH8PR12MB7373:EE_
X-MS-Office365-Filtering-Correlation-Id: c0239908-a5d9-4475-9a77-08dd86e53335
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700013|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TxA/tlW3EH+2VO8VWdKjyVBux5ciznOocQjUlE8Vw5dmiS+0fQqympDhLfAj?=
 =?us-ascii?Q?NYih8tyGafOoRYHMVCvcC85hq5vW/j5DQFy//MuK/OzHIavN6xzb3A4qD5Kw?=
 =?us-ascii?Q?lZxIrLZoHq1UWjDb2DUQNiG6MUP5PNmPumO6ATXRO6A884ibQQlNDmaRpiXd?=
 =?us-ascii?Q?UOqakmCsCjaflH7LaKG+NnVUudDaquc+FNmTc+jYpLNvS7yYtrqfZHgJb8n8?=
 =?us-ascii?Q?CaIPULeJW5VZYeoYx8qTx3q9uTpdt2AlW+1GdqnxM1zqVbv11hFewtTNat9f?=
 =?us-ascii?Q?nACF7ki0SHAj6T7GyOFuHVZ4MWwIKUVaaGgrg47p9yAu3TgZzOLe7m0eKJDi?=
 =?us-ascii?Q?8gM7bw4kTyRxBStBJzZQ1ogPVKusHF7VIjpXrbq8B7TRtJH/jPRKxFSI2Yb3?=
 =?us-ascii?Q?QLUfsep8nSxCfrZ3BnGVSW/S7ecNbHrh6GINqG/u5SEL2naosBqnnoDGw0cZ?=
 =?us-ascii?Q?8wJrB3s+kIquHeEWSOtbLKlcfPE5P1wV28neTxLjQv+rBbBa7ll0c49yeMGH?=
 =?us-ascii?Q?jI0r6zXdRGxg5iFyiqJVH85OrpHl5/GykVZYummurA+VcatengMdZheIhntm?=
 =?us-ascii?Q?N3mHCm+tahImw9Haj2aUTCiZOl3jyvuvQhi6fTHyZhb53TbjrU9GCIJbF5vx?=
 =?us-ascii?Q?Clx6g5rCGww6F/sBlM9cBUF7ax9kjMSFiIRae51CD/ubSVxddTl4bTXPoNqi?=
 =?us-ascii?Q?e0Fp/X59e8KC1sbB6FS17FbQq/t2T97dQi9+sflgUkuX4ysZcKUAAEhamRhj?=
 =?us-ascii?Q?KMfC6a4icAEOhyadBy38CDaAV5+PbeC1DkfWmSYEJByA0MdANp7oae2kGpgQ?=
 =?us-ascii?Q?sUQ8ZGeTseibU+Ta/YnVnHHSSi+DmMrDUw6Btf5wY14w84OlJbHyi902mdeJ?=
 =?us-ascii?Q?+qRyBsgv+4+0hf3HvlnL8u43rPFllvEMnjqns2vUVLcaWQIPdDd/BsiXwF0A?=
 =?us-ascii?Q?HbHK3I2nhm2wRLm2tbQuSyYeOFH+NLxaDHivKBaLF11ulNiNr6tl1SYz54CY?=
 =?us-ascii?Q?CViAmi0eFAUon7NrsI6J/cff8tVUQvYIlNgR9aG4zER0JaBAr89OeQnQT1cf?=
 =?us-ascii?Q?X8oHogvV7xVLoPIyvfaKH5lLjLjQP2MBNszW6p/j76NqGT14+aUEdJIOcTCN?=
 =?us-ascii?Q?odkgt+iwfmkWbz16/YEskKQx+dtv0hjSTiJ1AtqJkwCyWKg9sfK1sUKOw4L0?=
 =?us-ascii?Q?BXRA2viVVhoXadjSWO3qBv35YAT2khLaSQeCSjz5rhLLmQuVlVsYhYI09GTk?=
 =?us-ascii?Q?quZ7Ew0Vg0GPtt61t/FRbtduRRl19OgtXeEjdutO7KOBfG/jA5dJeDa2RBpN?=
 =?us-ascii?Q?uS/+f7XwX010nle0FU0jVwPWllRR7xGR5QydBhoiMRsnpb+y4ZMtDNiYNAFX?=
 =?us-ascii?Q?qk8NNipZNzCP/K1rIyHXWl2XKwZTeYXPtx1wldkkSkikMtZXmCJorzEUADCx?=
 =?us-ascii?Q?CMNigs4bDHKazT/MKdkLX3IEm1MVumGvMDLPWF5RovQ5r36hnIHSBJZoazBb?=
 =?us-ascii?Q?9F5fnmQFBqFbttKM1mYhoFYT97y26/tje0oA?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2025 06:15:12.0479
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c0239908-a5d9-4475-9a77-08dd86e53335
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7373

Secure AVIC has introduced a new field in the APIC backing page
"NmiReq" that has to be set by the guest to request a NMI IPI
through APIC_ICR write.

Add support to set NmiReq appropriately to send NMI IPI.

Sending NMI IPI also requires Virtual NMI feature to be enabled
in VINTRL_CTRL field in the VMSA. However, this would be added by
a later commit after adding support for injecting NMI from the
hypervisor.

Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v4:
 - Commit log update.

 arch/x86/kernel/apic/x2apic_savic.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 0935a1da6d72..97abea90eed6 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -189,12 +189,19 @@ static void savic_write(u32 reg, u32 data)
 	}
 }
 
-static void send_ipi_dest(unsigned int cpu, unsigned int vector)
+static void send_ipi_dest(unsigned int cpu, unsigned int vector, bool nmi)
 {
+	if (nmi) {
+		struct apic_page *ap = per_cpu_ptr(apic_page, cpu);
+
+		WRITE_ONCE(ap->regs[SAVIC_NMI_REQ >> 2], 1);
+		return;
+	}
+
 	update_vector(cpu, APIC_IRR, vector, true);
 }
 
-static void send_ipi_allbut(unsigned int vector)
+static void send_ipi_allbut(unsigned int vector, bool nmi)
 {
 	unsigned int cpu, src_cpu;
 
@@ -205,14 +212,17 @@ static void send_ipi_allbut(unsigned int vector)
 	for_each_cpu(cpu, cpu_online_mask) {
 		if (cpu == src_cpu)
 			continue;
-		send_ipi_dest(cpu, vector);
+		send_ipi_dest(cpu, vector, nmi);
 	}
 }
 
-static inline void self_ipi(unsigned int vector)
+static inline void self_ipi(unsigned int vector, bool nmi)
 {
 	u32 icr_low = APIC_SELF_IPI | vector;
 
+	if (nmi)
+		icr_low |= APIC_DM_NMI;
+
 	native_x2apic_icr_write(icr_low, 0);
 }
 
@@ -220,22 +230,24 @@ static void savic_icr_write(u32 icr_low, u32 icr_high)
 {
 	unsigned int dsh, vector;
 	u64 icr_data;
+	bool nmi;
 
 	dsh = icr_low & APIC_DEST_ALLBUT;
 	vector = icr_low & APIC_VECTOR_MASK;
+	nmi = ((icr_low & APIC_DM_FIXED_MASK) == APIC_DM_NMI);
 
 	switch (dsh) {
 	case APIC_DEST_SELF:
-		self_ipi(vector);
+		self_ipi(vector, nmi);
 		break;
 	case APIC_DEST_ALLINC:
-		self_ipi(vector);
+		self_ipi(vector, nmi);
 		fallthrough;
 	case APIC_DEST_ALLBUT:
-		send_ipi_allbut(vector);
+		send_ipi_allbut(vector, nmi);
 		break;
 	default:
-		send_ipi_dest(icr_high, vector);
+		send_ipi_dest(icr_high, vector, nmi);
 		break;
 	}
 
-- 
2.34.1


