Return-Path: <kvm+bounces-43548-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CE523A917B4
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 11:23:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DB6DD5A5D9A
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 09:21:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89B6E22A802;
	Thu, 17 Apr 2025 09:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NOSTyeRY"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2058.outbound.protection.outlook.com [40.107.237.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D68422A4E7;
	Thu, 17 Apr 2025 09:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744881705; cv=fail; b=KDgdt+wjCCKn4aUxF/Uv0YOh3ylLx4rzNmK6Ekxl7AK9z2vk7xlFvZ7Dn5NB8SvuchPp/Hgawhmc23M9UzFIQxE7N7wGApxTNYDQ1x+Ld51WmhBQ23GVFp3IVyKQU7ozbIPfkxWG3I5E5X34tv4UQmlC83obma77hTVt9e4qstE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744881705; c=relaxed/simple;
	bh=fw9ycN7xdX3YmvK4F7PfW5fTkMXJTyvQhn7VU4MTQ9U=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jZ1hs1Gcc1o+h6ZUxVsOIBHnH+FnkWungSIZTijeGrZ4C/OQcfnAjf+MPZ+WIt/3WmK4yEq7YCU/hiKOk99c2PvsTC0JG4u7mniGXvKIKjCnYhYGKo1RmYoJk4ERV4DOsSzc93wf0AU/KX9xGTzlmSwG2w8e/h2whxiVlEIuNEA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=NOSTyeRY; arc=fail smtp.client-ip=40.107.237.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PeXHAYIwliTnIDxlnsv0HWwfvczJGSMhrJ+INOGU8VTF93ZvVbq3B6F4n7VOEZA68Un1l+jz8VCWkXT4L6Eltq2gho0USqEgcMhLd0FIKEzwK49rfPZmuYKwZBHlRMhbFnjOAwEEQY1IfYorNkZbMriIXO0Uh9MyWGBYVXX8c7mmLlAeribZJ6ksSrmgUjPaXSzFW0ICFQ2bIqXPAJFfzs6h5UD1nl4h7QSIbbCsI53qgBQZctri53iFdgfG9BbkN2JJk+Tz0t9eKxgAyhBH2JEixkBiyJg9Qb3QMHyNicpc6km3OXc/C41KpxiR8R4UHTqUoOdkZunNW4G9VfeLTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f7oHUGFEeAAC3CgTO6eOYU7tdNrve33ha1cWck4McTw=;
 b=TN/Nh2QxfQJ+dSY/ZmhKZVG8rY0KNUTPfSNlQAJ0nitdB6T8K4GfFPXcz+XfPKwCrO+kPgfF7/Wa6OtUEi3yzIeDYM40WrWDefT0FpBUcURWD8oMW93ZNZm1Y2Q0BDGdSMjbw4Q+XFf9ekzdLIMw3MyXSAKPR/OsIEo437748Rdo4M2xR0XkQvXkVHvn8H9h9xMNFZc1NLyNXkDsmDAX0fkb65nBe1dFsZd0yfCcXlo60/Uo3/9lw1mFoRiDn7xHpTv7vKm6VXWvxusf8wIlk0p2XdaVa8NLdSw7RBtu632z+A8wOqcevMaX4fwvHg/81cvkheVuurlzXVW9ioQ4Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f7oHUGFEeAAC3CgTO6eOYU7tdNrve33ha1cWck4McTw=;
 b=NOSTyeRYxRAUPwFeeFYsnVYwRZU6pLSHH7U8poWaxd7rzWdUUXnUb2OLwfW4VgWrEsTGTMHA3tLw4Lfid0WY+DS5Sb8Yk0qcbDmhaFu83sekN2bZ5jK9jCij3Qcih/bh1hBAI9UloiS30bu0Tmpk09H6bz+hAScK4y3ac7JO6gU=
Received: from BL1PR13CA0405.namprd13.prod.outlook.com (2603:10b6:208:2c2::20)
 by DM4PR12MB5961.namprd12.prod.outlook.com (2603:10b6:8:68::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.33; Thu, 17 Apr
 2025 09:21:39 +0000
Received: from BN2PEPF000055DA.namprd21.prod.outlook.com
 (2603:10b6:208:2c2:cafe::4a) by BL1PR13CA0405.outlook.office365.com
 (2603:10b6:208:2c2::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.12 via Frontend Transport; Thu,
 17 Apr 2025 09:21:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF000055DA.mail.protection.outlook.com (10.167.245.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8678.4 via Frontend Transport; Thu, 17 Apr 2025 09:21:38 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 17 Apr 2025 04:21:30 -0500
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
Subject: [PATCH v4 10/18] x86/apic: Add support to send NMI IPI for Secure AVIC
Date: Thu, 17 Apr 2025 14:47:00 +0530
Message-ID: <20250417091708.215826-11-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250417091708.215826-1-Neeraj.Upadhyay@amd.com>
References: <20250417091708.215826-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000055DA:EE_|DM4PR12MB5961:EE_
X-MS-Office365-Filtering-Correlation-Id: 78af5559-2407-4054-d04a-08dd7d914225
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NLshjzIBD2jbGSS89Oq2DPsXKXRyxQTZdOeIhXzALji3n0Xi35yu/jXJKHlw?=
 =?us-ascii?Q?HljidvilqLazsUsazwS2o9ORd22itHR4MHcLLDsuELCMIkUxRzQzxgnxnMRS?=
 =?us-ascii?Q?k9cdXjQAbooSNMBWQ3RPd3vD8ErjZjFBfNHi1o6vYSQYOiULd9EkaMJLErsP?=
 =?us-ascii?Q?wSuvtcyCKh8XG0g7Y0l7JpAyYFIl0O6rwtPstoqPGLbOiuZtM4PGtR1n2v5S?=
 =?us-ascii?Q?hvUhYL2B61lROykzz9bWwctRtSD2b+y+KkV6NVaISW8Z4hFrkYdUbjt7Idgn?=
 =?us-ascii?Q?qjvAVabKujxnj0wcSnEvscgj9a4bdECC+TztFnpbQuovCyxy2QYzTbMigWaK?=
 =?us-ascii?Q?iGaGGv5I6kSYJIjqbYb2V5Ljwi6FnX0qSdNEqMtQ7UzUKak31g2Stq2ck60U?=
 =?us-ascii?Q?gg5csAUEkdNWPf8dhiS6lXAj+Wwvo6ac5bobxGmSbpJ6fYK35QSa2CZWlMvL?=
 =?us-ascii?Q?SPubO2lujRe8W307WZ77uz2NB3NBdhHYO+TIHWK81BjvEAtY2KVhSsGFUlhB?=
 =?us-ascii?Q?cgq1siIH6OoWvCuttGDKDStgErfUegOUCS4svUjVAiOtcc+Xj5P6uRmC6d8o?=
 =?us-ascii?Q?wxdbO6WpjBbk4IasS8eREMyBEal8VM8iI8mfUd6gyNGFwuz7GisisFXfK/M7?=
 =?us-ascii?Q?S7E8AXnhv5Zxpm4Stg6nMzXFhZxezzFPGVWjqdK1CDbWvcFdc5aYa6qrnj67?=
 =?us-ascii?Q?Ga2o+GVSBbKj85ESi1vYbo3gF3tqEy6GiubvQ+Gx6z487LH92PERlEZRjdjS?=
 =?us-ascii?Q?41JnFqEgHLiUiyjqZfg3VJEnryfdrVZIpLTM1H0TPH4NaO1Pace88y8C7T3X?=
 =?us-ascii?Q?iY2OydoILL1Zc9rH6OfRZeGMt1waAa3P8SIltpjek04Bc3uYh+KMbU9wdPLo?=
 =?us-ascii?Q?PTyrXzPF3q4DCvFst9CD3kRUF+JBOtD6dbOu8LtrR9lke+05mt3FO8QEN4kB?=
 =?us-ascii?Q?PtypZCvEX2HEmXf8rTf6pnfQ8aNIMiDFYrDi1RFuGWHAr0UdhXPCtxaNacuU?=
 =?us-ascii?Q?CHQj5h2kxIjTIdA3qEBobfZEoL0w1TsKWWBGD5eUQ/oEtLwO/W/3qVePATxV?=
 =?us-ascii?Q?CPG2+vTWhlQis0ECFY15GJl36ZCb838tFl6rqAcu5QPj3rZLE7LEEw+KLhOL?=
 =?us-ascii?Q?0U/KcD75tINlj3D8qRQ7FpnlRHMDmlmGMfLxbluudJmpi8Eg9rY5UwmJIVGJ?=
 =?us-ascii?Q?KmzLJJ2Uq9Q9xK4OV2ODTjRiRMkQCJ2ouz3tvPyGGPBYtvgZCCaYvyzjKiNt?=
 =?us-ascii?Q?a2XjM40TqplvahQiTk6OPOQLxGSabgYLzgPoNKomEXeTVhA3CA9ExTT4EUbw?=
 =?us-ascii?Q?n4BGlFsOZ3EYIEEf1eKbLi50W3pXU79PNGVvaAWbjrlgw9k5QFLnql55M++D?=
 =?us-ascii?Q?C6CIi90ilr7ibpxD+GeSxqFZVpIpMBzjuTsrWQsiGfGxpjtonAdW7s7PdeR8?=
 =?us-ascii?Q?KOuyFQBSjwTRZnzHlWfBswdgXfuF80m6lVvQ5PruG/eoc+rUx08upf5PyQK9?=
 =?us-ascii?Q?YOVBejzJeyKvjOcnMf02ra+YF09YmZomwZKg?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2025 09:21:38.9284
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 78af5559-2407-4054-d04a-08dd7d914225
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055DA.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5961

Secure AVIC has introduced a new field in the APIC backing page
"NmiReq" that has to be set by the guest to request a NMI IPI
through APIC_ICR write.

Add support to set NmiReq appropriately to send NMI IPI.

This also requires Virtual NMI feature to be enabled in VINTRL_CTRL
field in the VMSA. However this would be added by a later commit
after adding support for injecting NMI from the hypervisor.

Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v3:

 - No change.

 arch/x86/kernel/apic/x2apic_savic.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 69605e14ab75..c95a61109183 100644
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


