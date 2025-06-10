Return-Path: <kvm+bounces-48846-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 10BFBAD419D
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 20:06:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9EDF617846D
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 18:06:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A03BE24633C;
	Tue, 10 Jun 2025 18:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="bcQSPYUp"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2040.outbound.protection.outlook.com [40.107.93.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5925C244186;
	Tue, 10 Jun 2025 18:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749578752; cv=fail; b=SJPYmJ7EEURPdZ8I1APOvJm5yuh8LZflPBltYmtlfpXMYhlI1L/4tWgaJZrdhL0VIx3N7A8ZGzIGgqIc3ZiPqelKn/KxRyt/rFV99zEXSLFdMXEZhMiddHOs2udJ2HHAZsfxV54zV82pAsTDJXpcNB59m5WRxyNu4NYR2fFhAUk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749578752; c=relaxed/simple;
	bh=Qpy7RKu3++kdx5GQI41T48LjYC7RNxcpyKDsFR3a6Nw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IsLey57j2Rgv39tEjk9jMTSVljo0YnCtxGWKhiQSLFhdktgJvhFdQMRiaLYt4dBg4IAe5ySH8yw1HbnMVREhftpZMzVSzvQVHYM10gGaCuhU2Q2SVb1MhoedzK1gtCP/F8d5VnihXAkJumISQXKhlbXCXoYCMkVoazSCrKZjVWY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=bcQSPYUp; arc=fail smtp.client-ip=40.107.93.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cyuTEwGDyAeqWyeFswPlHa4iEzMubgDL/QEWPAjPq46N4uOCikXETSqmJ7DObSE6Cm7MilY6nS9kT1cP9hDpaGwRuOQf/zk4CQ1zNyvc+YOeULS7SkvSVHbL8M4a5iKTFv88Zg0cSp8YZez4t03iEN+CuCrSk66x6w8CmkqbCR/ZOd9wJGMMFf2wKrnViu2jVIx4MBCNtMaheXcHxSE3AgdkTHdfh63Qliaw+JpAuJJ2F85TDLM1vrQ6luJ8Whe/XUikCVfZUleI0qje+tWaU+Lh0P+DSQwp2alP9RIG37TNdclRSoovrNrn+RHUrwwjvl2J4XT7fjd7sLsZ3JCQiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vENlfOPYJfmNR0KFWzxiDyyu3aO1FJp96hh9OLPSEcY=;
 b=HkhNjeo5ynyfKruuH/CgE0/dlPxju47JRuZrk1RuPuyyoURjit38hbtqBlRXJmaO8bpCNC75o4orZAjsTjpMNaXIwHMEJvLoFRZ3yhpl+3q8xRa28+Jy7e97xQKSc5XC9+R1QQdy5+fVjJMoFZqdWdOOZuW+Gy8QNQVrhx5nGqD0ae9mWXi/NEIN+a0cCTpooQBMoBojFkMvYXQtzscTYIG0BicsLbLPE3WJZtglIPS05Mr2ZwYM1cd4951wxOFVSGPmpWZeyKqjPRlLrUniBIR8D/k2x9/qiSpk5n54JrEVCQuy3LCbo5/oLKtcoiUsAoAWYPK13hwtQqpYOc3g6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vENlfOPYJfmNR0KFWzxiDyyu3aO1FJp96hh9OLPSEcY=;
 b=bcQSPYUppEDYmtChIG+GrtTuxaECWWXI0rbvd1RP0p357IJzZ4JpeMp3e2pYV9tkvxNALobTcLcM82sn7fSYWdM1MopWImomcmTtd3mh6aHbvW3i1AfJt/hguugvfMyKBwsR8DakZxQdqmb8JQAvLRIqOcHhhfTyOxZfUTp0mBE=
Received: from CH0PR13CA0040.namprd13.prod.outlook.com (2603:10b6:610:b2::15)
 by DS7PR12MB6240.namprd12.prod.outlook.com (2603:10b6:8:94::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Tue, 10 Jun
 2025 18:05:49 +0000
Received: from CH1PEPF0000AD7D.namprd04.prod.outlook.com
 (2603:10b6:610:b2:cafe::28) by CH0PR13CA0040.outlook.office365.com
 (2603:10b6:610:b2::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.12 via Frontend Transport; Tue,
 10 Jun 2025 18:05:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000AD7D.mail.protection.outlook.com (10.167.244.86) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8835.15 via Frontend Transport; Tue, 10 Jun 2025 18:05:49 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 10 Jun
 2025 13:05:41 -0500
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
Subject: [RFC PATCH v7 30/37] x86/apic: Allow NMI to be injected from hypervisor for Secure AVIC
Date: Tue, 10 Jun 2025 23:24:17 +0530
Message-ID: <20250610175424.209796-31-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250610175424.209796-1-Neeraj.Upadhyay@amd.com>
References: <20250610175424.209796-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD7D:EE_|DS7PR12MB6240:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d407a2c-9510-425f-a2b1-08dda8496e46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ilLO1mVuTl2t2JVTpbjO25LcpAHTrEmQkuIyJ2RrUE+E5p8g5f5CyKgtefgT?=
 =?us-ascii?Q?XEL825iNxWbHLt+fBwmJEbzTaNPTb3L2Q7oCVKnQChdMykzH8eUc+jOhmGBP?=
 =?us-ascii?Q?moi4rLTdzod5Y+XFMcRjOrhQl4UzKueseN6gWeUN0rsaSoAVj/PwbukMUqEC?=
 =?us-ascii?Q?CPpuLenwUdZoyw00UEGlCduHBg+tqOKpHWv+3JRKFKbv78iHnbjQvnkYPhBa?=
 =?us-ascii?Q?PwzjC1BeYui1ZjN9tc6Bx7BUuVQt3eRVWZUJAHePoIM/PLU2Cq4rgAWn2fpK?=
 =?us-ascii?Q?vbTwKXZb2J95v04pbpH4vNrMzKEjazzwsyCa4xNcCgYbh0/PQm1iKazMDK7j?=
 =?us-ascii?Q?MArecxSYURyRRz4C7RD2JZ71xqekYX3AtUXhXA5hlLnmsOVsVfFOTYOGpHe3?=
 =?us-ascii?Q?8UdzEjwuaCX2T/Es+ABkQo921R5mcYrrdKWQCHzrU4zl5fSFYtuEbZUaId6/?=
 =?us-ascii?Q?bhRAtUM9M9xq1BjhkxC5KZFaMDq4Wfp6SVSWChEIX2yXpM/cqNU++8i9v8ij?=
 =?us-ascii?Q?NNPrNhkBac+0mTfA5T8gZkmDwkK7bJtVbj+h/kE0Dkwewbr2bNC9b8ublHYy?=
 =?us-ascii?Q?UhJkxYB3EINCWPM0nNMKn4+hw2yo/3TMxD1vIUBRc5D1XYwFuFSiDTgm5B8U?=
 =?us-ascii?Q?qQEq+CoVXOhD+tC7I6uGokhpplwG3f7AA8vIGXZ2EbjDJU0Of1DlOVGu/UHE?=
 =?us-ascii?Q?iKRChLdhaf1ZT42k417NiKHJTTsyZyy/1lJ6qDYGRcfGmsVrZvd4hDfNM1O5?=
 =?us-ascii?Q?BFAYB2nzd2oSxsn4zNFqWBK/8VJo/alZRNv319TYUGZPqUQDbU+0ImivYKJ2?=
 =?us-ascii?Q?PSTgxMhCF+f3ouGCnN1B8YIjwbM9qUufZryIDB8gn4p9p5s7PrWNMa9J5m1h?=
 =?us-ascii?Q?3Yddffg06JD2i5HCPJzo2TsEU5IRAcRIxXBi5R1bIq9krLd5IaHudB/yQ2pY?=
 =?us-ascii?Q?/T5jHZJd8fa9DGam3cQj9ao+rBKnOXpLDUI0dQ9DxSoGur9NEmlD9imbuVfm?=
 =?us-ascii?Q?1HIUdkLsLdHdtfxZDDfkqs1EdTBbAu52CMb8yC0fHqiBrUq3Z8vOHPfRb+IJ?=
 =?us-ascii?Q?b/b4MYyKUBjCwui7dZIZ0nMVRZuOZTj2tYuQTaMbbLFQMQ6jaB0iLF7D1DCL?=
 =?us-ascii?Q?RKi7NAvyLLFsDpt9N0vMcQYahzYA35mMB44Co+Zxa/nnHUPpQ32FT0Y0ywaA?=
 =?us-ascii?Q?V4/RhwGiRDwqfQHb5i49KH3kSs9whRqKgywogf6A8Jfq3U7nXjzJThLxFO2r?=
 =?us-ascii?Q?5/OISmi2KPDlgdZZLrtsozoXl+emrxfU6LcFAq+CA5VoKjLKxZoAG7fbs88D?=
 =?us-ascii?Q?xzyvb/Vchh/dtWn0YQ4TjqdCsowRGPsVLvyOtsrvQBkoamZzg9qIzJIdtuYF?=
 =?us-ascii?Q?pwoJ7jfPN/KqNg14ed3qrCzXZp/LGfrs0zkCQHf1vbdDFDarwoydLZWuc7vW?=
 =?us-ascii?Q?dvwvzlobT1RWGGPawel0diwBFtlV5iPS888JOMozyRSqF3JmeD4FwbeK/7dw?=
 =?us-ascii?Q?iD90L4kGV0puVswbbQI7T1GjrLQ5pNb2RpN+?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2025 18:05:49.2136
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d407a2c-9510-425f-a2b1-08dda8496e46
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD7D.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6240

Secure AVIC requires "AllowedNmi" bit in the Secure AVIC Control MSR
to be set for NMI to be injected from hypervisor. Set "AllowedNmi"
bit in Secure AVIC Control MSR to allow NMI interrupts to be injected
from hypervisor.

Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v6:

 - No change.

 arch/x86/include/asm/msr-index.h    | 3 +++
 arch/x86/kernel/apic/x2apic_savic.c | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index f617c8365f18..7ef1173ef15e 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -701,6 +701,9 @@
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
index 66fa4b8d76ef..583b57636f21 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -19,6 +19,11 @@
 
 static struct apic_page __percpu *apic_page __ro_after_init;
 
+static inline void savic_wr_control_msr(u64 val)
+{
+	native_wrmsr(MSR_AMD64_SECURE_AVIC_CONTROL, lower_32_bits(val), upper_32_bits(val));
+}
+
 static int savic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 	return x2apic_enabled() && cc_platform_has(CC_ATTR_SNP_SECURE_AVIC);
@@ -330,6 +335,7 @@ static void savic_setup(void)
 	res = savic_register_gpa(gpa);
 	if (res != ES_OK)
 		snp_abort();
+	savic_wr_control_msr(gpa | MSR_AMD64_SECURE_AVIC_ALLOWEDNMI);
 }
 
 static int savic_probe(void)
-- 
2.34.1


