Return-Path: <kvm+bounces-56096-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EC8FB39B31
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 13:13:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6D7221C28195
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 11:13:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52F8730E0F7;
	Thu, 28 Aug 2025 11:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="akELmtR9"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2051.outbound.protection.outlook.com [40.107.236.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DAD830DD19;
	Thu, 28 Aug 2025 11:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756379560; cv=fail; b=kWhv0Gu3eG7pCmg7xScZRgos0TeURoqFNm9Y8yjj1Ip3JQJ/PHcMpKiAxOfOc91vqjKsYJCTWkkzvyCxj9o2KyxPTCN8tiVbaSlt7xxAZ5r2lJZ7D4E3AlwWlffDrwWnQyMqrb89OCjxmI1EzO4k0R66TmtZxAl1MzEu4cj0PYY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756379560; c=relaxed/simple;
	bh=glQFhu8W0ftb/8hMexSwqnLwt5ySpKwRB1EK5hPMVp0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aSW2ofzaanhl9wLMN7H20RLhDO4S44RK4QHWb+d2JV6mKf5UEYxRg43OzN9CnONxMrJrKR3+CuP+CPng/SZdZj/+UEdpW5f1M9gGIP9Rg2gazq+Zs0JQAiv7su01cMRwe7/4rlKtWK2MpB+Bq8QsgipTvK10o0EF5AoHStY62b0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=akELmtR9; arc=fail smtp.client-ip=40.107.236.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uTqK1vX0KjmaG/HgzPd0r0mqMV0kI7R3WuDrIPAh00jgCf0a08Djlqp+hXwS2HaWlatc9U4A7YnlGFDA9UI7MTF0qPEH4vd3j6B0UfsqBmiAquzStKyHjytIr2vhaVM1CFYUYGGov25eKnZjVDLu0ZdQ5rwkIg7kgY2SgTNfAh4vB2bCh46ExHAqS1O2F6uOJwX95oCRULJc4i4Vlrmjwx9GwpMhjN9v/c9QtQc9sYocLNlv1jZqhtdJvkCbUND5vd1ojQ7laRr99lL4XBj3poFY4hcZvVSY/01n5fSxCxwpMQ/PjrhHl5bc1wwAyOcrmTBdYHjdLBN1BqxbIl/j6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+HNn8+IU37B/b93j6PK00PVtsIeZYV0ttzMzZcdnOG8=;
 b=N90AuS5vcJNh3EDr7bC9+Or1ydX180AKmlf0QDmsBz4Arz/0ek5VUmIdMRcRloVRjNmaHmG2vweBQr4LvDTNjpA/vc7QfP1JigrtGK5qFALDmREASjwhGCq9TyPzQ8y7Kys+kF45LUVA0wIJlTGl1x82anCT/JC0jWqG1AZKbSelW0eRiryvrhUO6ecYWpZ+Xfk1Ic8UgUWxy5jrNJYmqEKVIuS9iC2udyCfQM1DJgxGatL/EKZ/EBAd4E92qqovSBKTPSrnFxDWshgyGJt9OKkJrywpCO7awVhzT3n/xuo7LL9gTrbanw4uo1ufXipNOW+4ZsHZiDycAYjln5W0Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+HNn8+IU37B/b93j6PK00PVtsIeZYV0ttzMzZcdnOG8=;
 b=akELmtR9A/y9Hzy55qwV8NnKgboOoh8JfSph0pWe62X2DKHBkh0xWNeVg5yGlp7CCyha9BKh6OxnKKZ2qoTux1d9jNOarkv6o9tNM6dAeSQ48FCJj8K0C70qbUx5k4qJgTxQnyl2Gqn1h5TXSSZmdyi8fKzoPX2wMrAmcyroF7c=
Received: from CH0PR03CA0185.namprd03.prod.outlook.com (2603:10b6:610:e4::10)
 by CH3PR12MB7523.namprd12.prod.outlook.com (2603:10b6:610:148::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.13; Thu, 28 Aug
 2025 11:12:29 +0000
Received: from CH2PEPF00000141.namprd02.prod.outlook.com
 (2603:10b6:610:e4:cafe::be) by CH0PR03CA0185.outlook.office365.com
 (2603:10b6:610:e4::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.18 via Frontend Transport; Thu,
 28 Aug 2025 11:12:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH2PEPF00000141.mail.protection.outlook.com (10.167.244.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Thu, 28 Aug 2025 11:12:29 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 28 Aug
 2025 06:12:29 -0500
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 satlexmb09.amd.com (10.181.42.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1748.10; Thu, 28 Aug 2025 04:12:21 -0700
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <francescolavra.fl@gmail.com>, <tiala@microsoft.com>
Subject: [PATCH v10 10/18] x86/apic: Add support to send NMI IPI for Secure AVIC
Date: Thu, 28 Aug 2025 16:42:13 +0530
Message-ID: <20250828111213.208933-1-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250828070334.208401-1-Neeraj.Upadhyay@amd.com>
References: <20250828070334.208401-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF00000141:EE_|CH3PR12MB7523:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ef6027a-f18e-4580-d1be-08dde623c71a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|82310400026|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?X95514H5uOOjtljjz2PZM35HwkZNPdz8JzD0fE+PGwHr4MHfCf7ISh4mMfsq?=
 =?us-ascii?Q?hpuACwl0Tu/N71Avvm56XESrhWLlFnR4wU6BYe2+yRjypRyjifneEf8qoDXQ?=
 =?us-ascii?Q?XAic/Z04enBuG3+92isLn7Y83xv34fQ3E/EEtAWBmIsHo8diSRTfU1bF5C0X?=
 =?us-ascii?Q?qxM2dZNJRbMj3/3Hq/e4UwGWuaLakOwI7XhrpXthextyLg+JFrWAi7O6Sbkg?=
 =?us-ascii?Q?zjncu5wGs8bbDP3ZER1ycuLV110i1SyUswP2QvfCXfqhUK4b1eNc1dLgmpX8?=
 =?us-ascii?Q?Ifa8mj6SrOicunu7DUdKUs1sJuf0yoCFEPjV4lOc76AK8QJgqKPhDi9jwy3K?=
 =?us-ascii?Q?ZQxMIl0O1zOvKNyIXhQcBI+pxug8iz16oLj2uqwB7w8XiMHGFZhpD1u0/mWh?=
 =?us-ascii?Q?dSteq7YCMZ9r/Xp6mm7G0zVfDCXk49HX+3EQ9OHvj8PMfWV5aXyD+WM5E2VW?=
 =?us-ascii?Q?z4jE92Ts6vtup1RUnN8Owrq20Iv1Nb3sLZh6YSKANgf0Bv6p+Qo+jYGhiK0/?=
 =?us-ascii?Q?mygRhAH2Dc4GhSNy1SD90Sg6hg+MeRflaWgMinQ3gOj0TkO1nwEC161LnKT8?=
 =?us-ascii?Q?874bfG7LK6gjJU4CCK3qo+1mBGF81r6MReXzLLqc+mnPIuU8PmzCLyz6PQP0?=
 =?us-ascii?Q?Ku+dI/Q6gXe71zJYbKNZmjsymsLxXIKb7m0gCAPRTBG6x4iN4/5AiLYVNWaf?=
 =?us-ascii?Q?hgSYgZoozOI3a9SFnQGzRY+T2u87UX25ItkatMTwtJv31fXP2JUS0cG2HMDg?=
 =?us-ascii?Q?tV3c39bF9NlvJVGoxH3+XffUN19uEnoJ+0VxpQKchfpxKop1vC+y6j9DjoCd?=
 =?us-ascii?Q?iD5UofazBzlvLU1Iuvm0WpeneSiW1HSUwNgzTZLlA3qoG1d9vICsPw6DoD+j?=
 =?us-ascii?Q?dqKD0Izhe1Dw+2Sb9dFV8WeagcMsDD3S3wWDuWLZkSd/9zbd8yvH7HygRkl0?=
 =?us-ascii?Q?/5AE1kdW467NCtK/YcUnvAdPLBQB0UQugBwRFZ2yZJVkZLwyy9i+rJuIfFil?=
 =?us-ascii?Q?4BWumv/q2APq5e+iwQYJalMjTJHGePCWfd8H2RzTEw/w4o6k9nUwD4oBeREr?=
 =?us-ascii?Q?QYShFDn+SiCyFUQ6q3SR4Q40+98iUctazbleSEKQitW4UY4UnSfojhp8M2qC?=
 =?us-ascii?Q?fHDrSq8XFXuCjoIIZnpgWosW7xx7y+JXszvnSUtLE5ulOd9bf4Sl5bTfvNGx?=
 =?us-ascii?Q?ty/IcjcM5A9hlLagHXOtWm/HHYN46ClSuGaYZQhrZ2xFOnXFKAvdNBchgE0S?=
 =?us-ascii?Q?XGnrUw2S7AOTEEuLkpp/LbaokjhIAO4yuNeCbXs5pXtPX33lIVwYtgJVeexd?=
 =?us-ascii?Q?cEmTHPXT+wY14XAN2GPksRtBfdi8aJOJ2X8+8LPm3l94uRHCzyBKkhTW6T/w?=
 =?us-ascii?Q?L9rq/rioaiAbbdHKwcLufQaUk1y58vPp6D2u0U/9unmdHtYwpLuNUyW0+P8G?=
 =?us-ascii?Q?kf3roz1OFAGJIHC/Cg/sUT60o/Tjet3CTb1wXi3Z3v7pWd4jJXFh0MbBt2Wl?=
 =?us-ascii?Q?NkNeMO+bnTjAXXueeF36G+Mf23EJAdvDBbr9?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(82310400026)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 11:12:29.4586
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ef6027a-f18e-4580-d1be-08dde623c71a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000141.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7523

Secure AVIC has introduced a new field in the APIC backing page
"NmiReq" that has to be set by the guest to request a NMI IPI
through APIC_ICR write.

Add support to set NmiReq appropriately to send NMI IPI.

Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Reviewed-by: Tianyu Lan <tiala@microsoft.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v9:
 - Commit log update.

 arch/x86/kernel/apic/x2apic_savic.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index bdefe4cd4e29..8ed56e87c32f 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -133,12 +133,15 @@ static inline void self_ipi_reg_write(unsigned int vector)
 	native_apic_msr_write(APIC_SELF_IPI, vector);
 }
 
-static void send_ipi_dest(unsigned int cpu, unsigned int vector)
+static void send_ipi_dest(unsigned int cpu, unsigned int vector, bool nmi)
 {
-	update_vector(cpu, APIC_IRR, vector, true);
+	if (nmi)
+		apic_set_reg(per_cpu_ptr(savic_page, cpu), SAVIC_NMI_REQ, 1);
+	else
+		update_vector(cpu, APIC_IRR, vector, true);
 }
 
-static void send_ipi_allbut(unsigned int vector)
+static void send_ipi_allbut(unsigned int vector, bool nmi)
 {
 	unsigned int cpu, src_cpu;
 
@@ -149,14 +152,17 @@ static void send_ipi_allbut(unsigned int vector)
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
 
@@ -164,22 +170,24 @@ static void savic_icr_write(u32 icr_low, u32 icr_high)
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


