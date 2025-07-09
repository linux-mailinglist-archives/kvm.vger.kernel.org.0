Return-Path: <kvm+bounces-51857-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CEB4BAFDE64
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 05:42:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 42FFB3B6C71
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 03:41:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D29122333D;
	Wed,  9 Jul 2025 03:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ICYY3H0t"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2058.outbound.protection.outlook.com [40.107.102.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42A3C21B918;
	Wed,  9 Jul 2025 03:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752032416; cv=fail; b=Xc78Ikkn4EFT+hb7uGditwsoNSYoGuFlJTh2OQPkpv9YN6JtkbDgaPsaytVTPMxsVV7UTkiszWvGFI7gTR2BRJsXDtcXQSTacnK5WzAICy+zce6DjwbRSxe7jhnL79wOKgF7MEoUma74CVs/GRAlTKlxICMfPyN6N+kd0XN4r50=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752032416; c=relaxed/simple;
	bh=m/vhV0EOiWohwzjxuIdtOx2PW6dBI/fC6Q6+hCK6Dd4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gpi4EU23AagVwHUpA9TeMZ3lbjZCau3vQ+LnQbsm5IS9C0h4UeWsbtsE9LaRxrN3IRgISdmIJhQDLo2CrWEjZKEioidBpqnOmo1xd3s1JyfInqSUWG3GBoLRZwc+bbwxjPQtby+LgbCJgJdu51fFdWRc49Eh821EjSYA6bp6dPI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ICYY3H0t; arc=fail smtp.client-ip=40.107.102.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z9FPvMeJwftZrFdyzsar9GL4uOr1ujLU/1mpmRQfoYtELvhyILrJnp8E49HCZTUeQpRb1t8I+bbeh401hJhuYOn82keKDkyggZv1fMtYq+C8PrQVJA8W0aH3m5nCSyy+LBrbcWfJx8ZnsAINOurqkjfxtH89RQ+Jes7YUIL5o9yu60NjfYpecUYf/SkcL8PgGv2LflqLVhh/L+zbpAv1LCOgQ/vVlsCRhlHaC2S8wDgGSDlysTUvESk2wMKFamwnLmVwZLAjLcS7YazRCQupRJbpTBEC7A/QRn21W9O+j7N34RLPj4PFMbbH6m0Dfb/q4vxE589xTWIBVg59q2HEqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=crKeAeysfVOnBd+iX00DHFpDv0CZi43XYUfWfxJk/DU=;
 b=A3LC1KeXbNRpY5Lu9lXcTUmC5UCjNePqunPOzeGGc3l1LMSercqDaTLv4tLRVQHBSPZW7fjF8+q5KQMeeBM9AAdX2LTpwP9epYg8BHbjLZkFSOKannBhAoCECHQ+sEaur2oCXMi9hsQOuXkiG6v2MwbIOEvlwch/DYDmxWm6gnSKgf8Qqs/MfI0hS9dI6olsx+SUDScLDVsZXAfoZB79QTH+1DX9viw9iNvPLtgpBEDGYQb0vmq9Op1xfcrO0AZ7Wd77BUKtG63U2TBH0zNOeLPdNDFYLo1Pp/bd+tlwqJtbje/YzUKoIX6DXKDhHHUM1vS5kcX55QQJGQxBydz6OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=crKeAeysfVOnBd+iX00DHFpDv0CZi43XYUfWfxJk/DU=;
 b=ICYY3H0t3Hav9WTB7gGhOvW+AQGIUlhzrZ9Vf5ow+dkCqgCFKlo0Zes5lxKKGI4U+LF4GJVCP+dlqSpEMLyXkZY2p1zhRMcwjV2beQL3ePUp8+69woRNDZozQ0ooGZLCtJbfKzRKhM1AdaYOc6cs416f49sJaUEzR4L2/dTii/4=
Received: from BL0PR05CA0016.namprd05.prod.outlook.com (2603:10b6:208:91::26)
 by PH7PR12MB9125.namprd12.prod.outlook.com (2603:10b6:510:2f4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.17; Wed, 9 Jul
 2025 03:40:12 +0000
Received: from BL6PEPF0001AB4F.namprd04.prod.outlook.com
 (2603:10b6:208:91:cafe::7d) by BL0PR05CA0016.outlook.office365.com
 (2603:10b6:208:91::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8922.21 via Frontend Transport; Wed,
 9 Jul 2025 03:40:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB4F.mail.protection.outlook.com (10.167.242.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8922.22 via Frontend Transport; Wed, 9 Jul 2025 03:40:11 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 8 Jul
 2025 22:39:58 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <kai.huang@intel.com>
Subject: [RFC PATCH v8 23/35] x86/apic: Add update_vector() callback for Secure AVIC
Date: Wed, 9 Jul 2025 09:02:30 +0530
Message-ID: <20250709033242.267892-24-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com>
References: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB4F:EE_|PH7PR12MB9125:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e993252-2ee7-4e4e-7dbd-08ddbe9a4f39
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?aBSaUdamn87AMBOh2PzVdN6Q3L+eHfr5djG1bVrm4zMFS6l09pv6F7fGgb/E?=
 =?us-ascii?Q?c0M3hbjaWKvF8IIyaHRryLTYKykdB4UmEanQ0xqy0kpxnK+fyCQfccINHM74?=
 =?us-ascii?Q?Hps17BRpEjRx0lQXDH//yUreQB1N3L3+gLlhDp+pU2L6FRUR/wIlp39P2aaY?=
 =?us-ascii?Q?k7xLgNkhXW2IZqgR2BtIghKqGfuglJykjLDAuHbHsBALtZnx886/grp38hb2?=
 =?us-ascii?Q?NR8I+s3f3JKzSpUu+TXTplRZpZmSuePY8G5xVz4eYpOB/Ke6WtXNX0otGG+T?=
 =?us-ascii?Q?QERlatWWXqF88oTnuV8bMm6QfgI6FKX0UAqnpL4dvp1zd0jZQBz+ei0Yd1Jq?=
 =?us-ascii?Q?foRL3P/pqhRk5AumYFjg253a5pGnUL6zdWN8umaM6fwWNLmNZKLIK2c/bW93?=
 =?us-ascii?Q?xzeU4wjn8ShnwmOWLz7UrhQPIiIlseA4oJc5bgcfM5sAjB4nTYtRDb5beQbC?=
 =?us-ascii?Q?W6aVw5x9qiFiEHwSU17dspGuRFn38I065R5z/jVPD4r8GFBBp+nfQje4lxRB?=
 =?us-ascii?Q?kimk7rtY+0Hzt3/1aGUGKF1EuMZA6m45kq0mkRMKLKy7DAs//cMghDy2laha?=
 =?us-ascii?Q?t9oMcFw4LqotiCuL3EnGg/p1yYe42aHzn8sEqGXBvx6EGSIZyHMZeizkMxY5?=
 =?us-ascii?Q?/r5aipheEHXmNFOV9mDWvHQzCvJt5YaeQ+/yHV1HRTCG0hDIimZ0ydkqPHyK?=
 =?us-ascii?Q?kQlKbMneNjxM8ASct9MQMInrycSZKiDpp9nWxljixrAFIkFK9KF9Wq86MsDR?=
 =?us-ascii?Q?PeVrx77gdEc/jqMWwpldHWGt8RGiX/d9ThWj/B7BcjoejwuRxrvnL3s3v0Hv?=
 =?us-ascii?Q?4XmtAb1OlxojzPuJ62n3RYA++49A2P7SFwxQoqdzIB3/4T0xLhdceMML6tJD?=
 =?us-ascii?Q?XSVvk79n6muJLi7AgPhU84x8vvj9kYbfSo04Oranzz/MOdWT9r/phOQvojB7?=
 =?us-ascii?Q?qJVlw0bkvJVAubU0roJXCNwNqDdslg3bp2YTO8q/390wTelxHJdZHCmc4gWc?=
 =?us-ascii?Q?3NBLX26o+sr/AcpWxnl2b3Gqb3j3HpY2AAKMfR8bW+Q3J8vRVPSk2DknJ2wE?=
 =?us-ascii?Q?/M0Knu5o22DpaWc5BEUFu/Rq0p/DHfvTL0sW5KejLvqBB6ingW+EMaczVgSf?=
 =?us-ascii?Q?QHVA0cUHbGHHZp+M4qQghod0t5Qh7dXqHZXb4S0KD4Nara/sl5ywIkwOmYm+?=
 =?us-ascii?Q?aH69ZwOwgAyLvx3RLPzjeEe0KCtsSeXraNW0NRBcnHg99ZZ3hNZQq7z1keZJ?=
 =?us-ascii?Q?oOSlYM4XLBk/DEuryHQKGX8LoiUfscWZKnWBlgGxRowtX47dZCzt3ZimRZjP?=
 =?us-ascii?Q?FWNC3BJ0406dk0AXTGRbDpkd6udmzIbrUvAdxuLC3YBvMOyhPBFmnm87AtGD?=
 =?us-ascii?Q?b5YqCOKlU0ViGJstuwN5482eiQLpJSnlLRViJu0jkPKCXEaW1vm5q8G9LdcG?=
 =?us-ascii?Q?BLQg1+hgINFLWi9rbr0Fj8niTVUfLsM8TcNPMTloDaeFN3+1/fBggMVjfT3O?=
 =?us-ascii?Q?xIn7j1okvhW0fKidZme/Ul7puB2+jyDHo3ej?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 03:40:11.9460
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e993252-2ee7-4e4e-7dbd-08ddbe9a4f39
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB4F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9125

Add update_vector() callback to set/clear ALLOWED_IRR field in
a vCPU's APIC backing page for vectors which are emulated by the
hypervisor.

The ALLOWED_IRR field indicates the interrupt vectors which the
guest allows the hypervisor to inject (typically for emulated devices).
Interrupt vectors used exclusively by the guest itself and the vectors
which are not emulated by the hypervisor, such as IPI vectors, should
not be set by the guest in the ALLOWED_IRR fields.

As clearing/setting state of a vector will also be used in subsequent
commits for other APIC regs (such as APIC_IRR update for sending IPI),
add a common update_vector() in Secure AVIC driver.

Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v7:
 - No change.

 arch/x86/kernel/apic/x2apic_savic.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 618643e7242f..2e6b62041968 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -23,6 +23,24 @@ static int savic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 	return x2apic_enabled() && cc_platform_has(CC_ATTR_SNP_SECURE_AVIC);
 }
 
+static inline void *get_reg_bitmap(unsigned int cpu, unsigned int offset)
+{
+	struct apic_page *ap = per_cpu_ptr(apic_page, cpu);
+
+	return &ap->bytes[offset];
+}
+
+static inline void update_vector(unsigned int cpu, unsigned int offset,
+				 unsigned int vector, bool set)
+{
+	void *bitmap = get_reg_bitmap(cpu, offset);
+
+	if (set)
+		apic_set_vector(vector, bitmap);
+	else
+		apic_clear_vector(vector, bitmap);
+}
+
 #define SAVIC_ALLOWED_IRR	0x204
 
 static u32 savic_read(u32 reg)
@@ -131,6 +149,11 @@ static void savic_write(u32 reg, u32 data)
 	}
 }
 
+static void savic_update_vector(unsigned int cpu, unsigned int vector, bool set)
+{
+	update_vector(cpu, SAVIC_ALLOWED_IRR, vector, set);
+}
+
 static void init_apic_page(struct apic_page *ap)
 {
 	u32 apic_id;
@@ -212,6 +235,8 @@ static struct apic apic_x2apic_savic __ro_after_init = {
 	.eoi				= native_apic_msr_eoi,
 	.icr_read			= native_x2apic_icr_read,
 	.icr_write			= native_x2apic_icr_write,
+
+	.update_vector			= savic_update_vector,
 };
 
 apic_driver(apic_x2apic_savic);
-- 
2.34.1


