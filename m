Return-Path: <kvm+bounces-54399-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 70BF1B20459
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 11:50:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AD3032A06C2
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 09:50:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3562212B05;
	Mon, 11 Aug 2025 09:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="tfTHhqEe"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2067.outbound.protection.outlook.com [40.107.236.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7708319D082;
	Mon, 11 Aug 2025 09:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754905741; cv=fail; b=PWyUOqZqbJdtTFMjyJbPCMtuVOq1DzF+JYmugqTX99zr5g1eGdlNGtSu7GsEHH7BiWWgTCo24ilih1OOcF+M284qnWoZkCouGbC6CaRrHuKDxy0jtxG9cWMHQorDun/dkNbK+thZOgvYFS3QV20+O2Pe3/ohiYz5qQ5EjESD/+w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754905741; c=relaxed/simple;
	bh=7RJjBSDqZNwHP++GR2RO9WmruLECrpbdKHk3fax29hI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lrsQuY4n/jhHy5efCaB/P97Id2sA/LDLaRXxjcR44jeAJTuWkusBtsZWtPRlKxONN7DCusAyJ9Ny2CdpwAcb/EXmvHCq8rMSxlMYwajaw+nKVvOznv+cCM/v6qaSb56uc+dMEbyZ8G//Q2w037czx0qZFoV7RheX8vcF30SdzXA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=tfTHhqEe; arc=fail smtp.client-ip=40.107.236.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P8499xzGk1tulIrdQP6XK69Uw4RIl5wZ/BeIgT0wq84qROEialCjImYPJ82n/4nuQ/oRx1D3jAbw9gK0cPjG2LEVtJl3IcR5UiwJdkTENHBPGerqCiALPHFZoaj+oKpTksvlJldGdjnm6ldupPmyBcHEdGVlOvXrInDw1KE0/O7NYLmNgh9AlLpINr37YrZf7L9T2gA01rFughciKr7x2/mqfjlZdb3m5ElP6Gt2L05PhMWP4z4HrJ+9mLHWM7kjhm9ohxXOHDkZPUPuSNf1Z1UYpk/UA9TnjWI8f5rygTbqqi2E6K0nO5g913NJYcgSSS1xGTIQx6Ud10a7dPRiZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RuYogog6JbpIVPp6V49ZigfOMDYWz8c5LkiZWN4rReU=;
 b=hYdmocpGcJLaNtp+fhNu72r1aABYUr/y1zG+mckJ50Qnwh1099t45r+FBU8W/qYhYWnZjje23Rqf9HX4e6Gub63j4VpjAn2LeOxmSNcsb50z0lD1STa5zAfKzEapREhueZjZaHqiMDLlymzAbfMgOYGJP/mtrsTaL28GlwnBYDJDaAHSxlqFLNk+oegMc8Zpg+XwJhEui/qXHnMECOy6z7Z8YEzVnjddefkV1kot1NSYnK00W272/AKcBFfHSfM+5KrWk68YgP+Ar68zf8vRXRgJy8x6K331KPJ5M66FuORo5C+PM8R1GVL4fhDCc7CfdFoEkIrkonYTGBoSN77vlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RuYogog6JbpIVPp6V49ZigfOMDYWz8c5LkiZWN4rReU=;
 b=tfTHhqEe3FArfLV8fE8cEcHwR03Os2j0a/p2LlZPHrJS8p1i3RVYqKN09FGtEHMRfOM/E/jcG3AOqZuK3+fr+ZbMaE63OngH5BUAF+XEsXI+u4QfH+6Fsgi44K0k5w8Kx4d+MTOsHvlHG41sGqVU6NS9cikl5H3lY7FzBU7CaGc=
Received: from CH3P220CA0023.NAMP220.PROD.OUTLOOK.COM (2603:10b6:610:1e8::29)
 by SA0PR12MB4431.namprd12.prod.outlook.com (2603:10b6:806:95::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.21; Mon, 11 Aug
 2025 09:48:56 +0000
Received: from CH2PEPF0000013F.namprd02.prod.outlook.com
 (2603:10b6:610:1e8:cafe::db) by CH3P220CA0023.outlook.office365.com
 (2603:10b6:610:1e8::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9009.21 via Frontend Transport; Mon,
 11 Aug 2025 09:48:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH2PEPF0000013F.mail.protection.outlook.com (10.167.244.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9031.11 via Frontend Transport; Mon, 11 Aug 2025 09:48:56 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 11 Aug
 2025 04:48:49 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <francescolavra.fl@gmail.com>, <tiala@microsoft.com>
Subject: [PATCH v9 11/18] x86/apic: Allow NMI to be injected from hypervisor for Secure AVIC
Date: Mon, 11 Aug 2025 15:14:37 +0530
Message-ID: <20250811094444.203161-12-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250811094444.203161-1-Neeraj.Upadhyay@amd.com>
References: <20250811094444.203161-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF0000013F:EE_|SA0PR12MB4431:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c2efa8e-0f22-4201-df57-08ddd8bc4a0a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700013|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gDguzmn5tmfWdCRFSi3y1tJeP1Cb6yO1kTMC6u/nUFCqs+8YEiBIPp9aYjMj?=
 =?us-ascii?Q?5oWfANON8QN2nlFIsXh3fIzbiX6CHgXP7nsysdcL1loMzZ4qTOQk6SrnJ5tl?=
 =?us-ascii?Q?UVu3LzNRc+/mwlRCbCxnX04GzlWz+GCe5AQUiaap/U4i9RNo+nbMrCtTnlr+?=
 =?us-ascii?Q?En4W3BRKwTqUOCXbRjDqLc6PJeko8qUvp5Bm/knUpZCoXbsH5F2/nH06vIPa?=
 =?us-ascii?Q?7Gy48FLIH4UrPliBnF3DxQA+UaiOwWF8OPP1f01LjEXi8BWj9/QnSaVxXjr7?=
 =?us-ascii?Q?GdHTbV3eHwpgK1dHBTs9s2Y0vlt1RN47mwwCX3RpjFDeJbSKDgp5A4rUdLkd?=
 =?us-ascii?Q?ZRtBO2jZrlQC7LMXUjNZI9+30uzXmnQJ9wdTUMnRceTDPHN+fHcL7K9GU4sB?=
 =?us-ascii?Q?/wnAFOgnylAH62JCcfzqMrKXCS1p9gP8ot3eOE0Hv+qZQq1ZWjux1Ltqoir8?=
 =?us-ascii?Q?BK/8fcccuMNedTo6XnBFUsHQZyts9Jjl8xpUBbxpQ16cJ5vfEqyh0OXkwGpg?=
 =?us-ascii?Q?hS8PAUiR9eRPx8YvUJDtAIE+07ZDqkZraqxTHtbrmBAFiXpzuUck8PyGjwGK?=
 =?us-ascii?Q?N+Q6PfYkINFBdAxhNItcWd6RVVlxGN+K0PkcPnBiCuvvB1ZkLJbyIDYHjUja?=
 =?us-ascii?Q?H6TcVuVuTgz1rP18vtMJ8JTqYr+GmAV+3c2hTFTZq/A8ra8XX19h9RzqR0EK?=
 =?us-ascii?Q?OcUqk97BpEVJ8I3z4xSA2CudT56/eyxXXpJ/PYO7AEWBwLxeTkYmKr5fd+9M?=
 =?us-ascii?Q?AJBrHlOQQYJSWeL02c12YfTP2Z/Ga0c3aplXUzbNVTzx99/nqIII/GOs38G6?=
 =?us-ascii?Q?DCixWGuWdEc8ZAL+iEd6UzMKUwTAw4/XNFwQjjxc302ia3UtibKCMDcAGbz3?=
 =?us-ascii?Q?ShehxEr2eUCtW3i8pShZmYIf7V8HC1AZo71SxwRkk6PPTSWknfx+eqE3XbOe?=
 =?us-ascii?Q?cJRoEBuGxQpLzTp06wsTYIXfsbH26thuz0K7ePt3X7PUva+A4sc/iIxerrtc?=
 =?us-ascii?Q?R1LvVo9QU//QqR1OHqeBNLZNuVZgXgcZz0xVayp8Qg/7f6Jb/vDUVvSHoOZC?=
 =?us-ascii?Q?+A8SeLs2CYyE2FQkwBro83NBKk/i3MfX49YbRrnTTMCmQGfjB97+/0w54FBs?=
 =?us-ascii?Q?yEPkSk6Np+L+NtBnqUDnlBn4kQha7Z40egRcLcDOwwpb4VeyUtJ33DO3LxGJ?=
 =?us-ascii?Q?E/RPKaGuGTexcUQvPWtIEb7uG9aFQn3EI8JjNNzheq7EDoITsn4CS6Yp52ob?=
 =?us-ascii?Q?pEkCm1NaiEWGEmlPoAfyREFEP4H9xdj/WthNEiDUTED0omd/i5XS78j+inrk?=
 =?us-ascii?Q?pU9Zlz4/4LyzAYR3/dc2+pXVyT0jLPn7XkcDf2uuogfrBAan2dg/99rIwbPh?=
 =?us-ascii?Q?w/ydsuQbYCU58NsTOCP/VU4ZYA6USMKOdvqDyVsWFu9d9rFxO1qjk6lKhQ37?=
 =?us-ascii?Q?y9DFa6rxtrh2aY+dknGZinWPVR8zAovy4TFmhj3Da7FpDkoUnKgz7/G2wyzf?=
 =?us-ascii?Q?f4tXoA2Mk7veP6KNemFLpyOkSBGql8CKaoAm?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700013)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2025 09:48:56.3608
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c2efa8e-0f22-4201-df57-08ddd8bc4a0a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000013F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4431

Secure AVIC requires "AllowedNmi" bit in the Secure AVIC Control MSR
to be set for NMI to be injected from hypervisor. Set "AllowedNmi"
bit in Secure AVIC Control MSR to allow NMI interrupts to be injected
from hypervisor.

Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Reviewed-by: Tianyu Lan <tiala@microsoft.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v8:
 - Added Tianyu's Reviewed-by.

 arch/x86/include/asm/msr-index.h    | 3 +++
 arch/x86/kernel/apic/x2apic_savic.c | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 2a6d4fd8659a..2efc03d324c0 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -703,6 +703,9 @@
 #define MSR_AMD64_SNP_SECURE_AVIC	BIT_ULL(MSR_AMD64_SNP_SECURE_AVIC_BIT)
 #define MSR_AMD64_SNP_RESV_BIT		19
 #define MSR_AMD64_SNP_RESERVED_MASK	GENMASK_ULL(63, MSR_AMD64_SNP_RESV_BIT)
+#define MSR_AMD64_SECURE_AVIC_CONTROL	0xc0010138
+#define MSR_AMD64_SECURE_AVIC_ALLOWEDNMI_BIT 1
+#define MSR_AMD64_SECURE_AVIC_ALLOWEDNMI BIT_ULL(MSR_AMD64_SECURE_AVIC_ALLOWEDNMI_BIT)
 #define MSR_AMD64_RMP_BASE		0xc0010132
 #define MSR_AMD64_RMP_END		0xc0010133
 #define MSR_AMD64_RMP_CFG		0xc0010136
diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 62681fa4f1a5..2bae2f711959 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -23,6 +23,11 @@ struct secure_avic_page {
 
 static struct secure_avic_page __percpu *secure_avic_page __ro_after_init;
 
+static inline void savic_wr_control_msr(u64 val)
+{
+	native_wrmsr(MSR_AMD64_SECURE_AVIC_CONTROL, lower_32_bits(val), upper_32_bits(val));
+}
+
 static int savic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 	return x2apic_enabled() && cc_platform_has(CC_ATTR_SNP_SECURE_AVIC);
@@ -319,6 +324,7 @@ static void savic_setup(void)
 	res = savic_register_gpa(gpa);
 	if (res != ES_OK)
 		snp_abort();
+	savic_wr_control_msr(gpa | MSR_AMD64_SECURE_AVIC_ALLOWEDNMI);
 }
 
 static int savic_probe(void)
-- 
2.34.1


