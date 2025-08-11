Return-Path: <kvm+bounces-54394-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E8753B20447
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 11:49:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3F6802A02A1
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 09:48:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02E53212F89;
	Mon, 11 Aug 2025 09:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wfwvT+jS"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2071.outbound.protection.outlook.com [40.107.244.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF691A5B86;
	Mon, 11 Aug 2025 09:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754905632; cv=fail; b=O1YoGRv+igZTEmJXb7O1TSNKZi0HKLSDkpT3ww7H/aV+duJo+NYFVyQmraMShK8A1b0oi1vByd/84Uzm3zLDdO0iz2zAjMlmLTjJIzbrxmTk+XofvvE0hEtnMhcK3r27aEvUbq3ssd+MHlrNM4BgrlEKucevxPueAMYI7wa0a8g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754905632; c=relaxed/simple;
	bh=LDxN8+qMG0DM/UzQJkZ2HOEjyVp2ahWiqxY+AQWD8x0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Nfbut5MeCfeoO4FpLzT2PZ6XW/C+9XeOEtWvgU5BBhHt8YPWdkVCGMUjuFEpcNxiaDwm/cPLiTkH4uvg09JArqsxqGZjE1i8JmaCN6El162X3mEZwSrlndsHAzeNAl37LTnjJICHlZSSksicjUO2oZOwfe3mvVqtX4Q4Jdd8p1U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=wfwvT+jS; arc=fail smtp.client-ip=40.107.244.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hcNPMltxa2MGcGSBCmr0L8DO2psOwIq3pbkIDALcrwXMm5vWQ3ebdSfh77ZvoppY62a6ehs+BtJkd3RxiAed/7J9w8cAr8/Y7nHIsV/o+hM9BELYJsb1gnH207J5SO2+OOlBHzqAbrIwZ6C02/g53pVBCMLVXUSpZ9Gl2DvkySA0ygEvF17S8mxldjG0khWHenZFyHP+jxJ46CgPNvaOTxmKXy4lSszwdxHUSmO12BrzHBehIArFanADy7oDp+Ob9thvK4EQ5ZozjNYZVCakND06rhgM3XZpB5QTs327JpCaQAA/UY9GrF82X2E4gwgDUzvmWCoi+kINen0o+sXJgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Q1nAniE/KVslEmbW4azLjwl2kmdRXH3jEuJBf6ZoNM=;
 b=nsS7qlvPwPR+ZT8O+HKuWxQV2wHW05HObYjC4PBNymtHKEDOHr6QtCsckRu9+NJ9FhWACeTL2nY6khUKiDkKp+tzrUYShJx4cI0kYNcpHzNjb0epwRVdP7x6iSU425hqiB1uJc+xIyBmKsDOela+aiJ9ywOBg9opL4TSgfogXTB0FQVIZ9X/nTqeYN8sMmtuC95LkR/MoRFYALXcM2gpr6p0mWoR+fP7Gin+o7sGkyW4c7gCnY3AZp7Pjzm3HJ2BAlM0clkFyWtO8GAi5/LMOMxTy0m9cP7YaapeeYeM7k8svg5AYX8Tbogepuy0LpexHVP0TuDMzEYhrJHB8tEB3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Q1nAniE/KVslEmbW4azLjwl2kmdRXH3jEuJBf6ZoNM=;
 b=wfwvT+jSQlS2A8otfKcX8CMD50HVDusA5DDwzedajKiNXvhotYu5xqGflNlnOFodwVPlXFYgsEUvHL7tXa3X03IKRJkf8TK0h0Q2ezj/SumoGfN9qslie4dOCottQ7es16aLm1Ig7/QO9fQ+rRuy3rpdPE8VxK3z5JM7lY6Px3c=
Received: from CH3P220CA0027.NAMP220.PROD.OUTLOOK.COM (2603:10b6:610:1e8::25)
 by DS2PR12MB9686.namprd12.prod.outlook.com (2603:10b6:8:27a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.21; Mon, 11 Aug
 2025 09:47:06 +0000
Received: from CH2PEPF0000013F.namprd02.prod.outlook.com
 (2603:10b6:610:1e8:cafe::a3) by CH3P220CA0027.outlook.office365.com
 (2603:10b6:610:1e8::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9009.22 via Frontend Transport; Mon,
 11 Aug 2025 09:47:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH2PEPF0000013F.mail.protection.outlook.com (10.167.244.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9031.11 via Frontend Transport; Mon, 11 Aug 2025 09:47:06 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 11 Aug
 2025 04:46:58 -0500
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
Subject: [PATCH v9 06/18] x86/apic: Add update_vector() callback for Secure AVIC
Date: Mon, 11 Aug 2025 15:14:32 +0530
Message-ID: <20250811094444.203161-7-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF0000013F:EE_|DS2PR12MB9686:EE_
X-MS-Office365-Filtering-Correlation-Id: 7abbce41-1ba1-4643-03f3-08ddd8bc0893
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JkEj7FYb8UXWuz0W+LFdNJchKNZpHt2qkbEwHS1vl7y0fU55MsqUc6lqVRbr?=
 =?us-ascii?Q?MPE6fcomNCvaF9z5GlPv3+FEeqy4mflsDKE5rt+56ktt43XMXNf9TboxrDEH?=
 =?us-ascii?Q?sh/f4VYY6Ey28+1fhUjtGJOk/+Nd9MlrpUXJTLCZPK2aTmw3zZCTj/5jKOky?=
 =?us-ascii?Q?foB3cwWbs2eo/U0KPfaVOwLNMledDaaa4wbL9yjSH3gY/6ZSZVdLCcbSG4oc?=
 =?us-ascii?Q?aIce84arNeiwMw2lx6Va2MZDckkGNJgLAxkZ0v4xSDSyrsXUbfcMsoCVIUPN?=
 =?us-ascii?Q?tgnFGRkJE5YIAjuEslJJ0ab2St4jexpEGOTpf8+mBNfAY6jqZ78nTl1Lw5HP?=
 =?us-ascii?Q?GB1l/68mh/JtmhX1OrF6i1U0EHc5Yj3ktpI9R6A28XOCt//8emm0Z8nFWWCy?=
 =?us-ascii?Q?FkQWY7+UBedNh8Kob3TXTvdJ6gemD0YrHGdQOlwhjqwWreXY7iQ19mj9rVbn?=
 =?us-ascii?Q?N5wIhIPhrmz1M+OGeLqWDc5juwDnZFN3aCupsveU1VHxmAFeOWOO5d9YuGJM?=
 =?us-ascii?Q?S2JJOWoG2gH5Nit732eUYJHsHMNkS/lTR+9cLWbIIK11TuCXwbov4ZPwQANX?=
 =?us-ascii?Q?9YnDBQ+G3IcSkQb93emr++Xt5m3ilRuXIzzSwJpbb7+ogP799UIew7BEmVWb?=
 =?us-ascii?Q?oNtbT5VcSROO3h2IZcf4SHqvBhbjqY33oXLfF9lIFH/Ngn3YUjdM+cUhSUcK?=
 =?us-ascii?Q?yExR+yIakP4NiNwXjzssMd7NB9tiV3ygfZuNaS4E43IqAH0mK6bQkyPQ+rXq?=
 =?us-ascii?Q?T5cYwDdngV70l1zGZuUFvnsHIT+rievl0EHL20jO8AUM3mD88SvqXZETZ1l3?=
 =?us-ascii?Q?Fr3ICo8TNDu4+MgHD3pAhJeAqkdgaZtI2GGP/ubCWFIXrJgCi09v6nGPCbLO?=
 =?us-ascii?Q?6E2w2a3jBmGM3ZlKWHn5e8eqTAago/xyDKfXu2QE2+QbunYck5oWeQNlattW?=
 =?us-ascii?Q?M0p8F0n7CzPosnB+q32Hg+mX8NRNB4o1fz90EMd29W+DVuwzU2+OW6bMyPKo?=
 =?us-ascii?Q?bdbd3Jm+cDNH2M/1G/3YD0B/AuN18+6epgfuvmeRfynUhi4Urs9fYvegYXii?=
 =?us-ascii?Q?DvFx4Nv6gFL17qxX3sD5xmZY5vYs+BTVt9eTXCbASeUBlXZqHsI3Ev7ljXvf?=
 =?us-ascii?Q?rPQS76k8C8vzRLbbshy8oVHKjCRCnI3EOGZGFrzMvBgArL2qAj0ycTYqqqYS?=
 =?us-ascii?Q?rkmuweH17W6qcSBsDJVZsl4wvrFEWgkya2+BQpRRmB8YsZkfVdziNXMjMmfi?=
 =?us-ascii?Q?+RU6tQWcAvUxgc8oaniQh7Oxnz1gcNVRPQs8Ax0SeJ/miWNQheVOKcL5gAYs?=
 =?us-ascii?Q?CTx5PXdg20vMWo0tnt6DhQWPQLCZ1vPGHhyuj2hr8Jv+dGIbFrUd2q1naeE0?=
 =?us-ascii?Q?yXCOzwUeVBpJG7cxVm2UDQKIayyf0hikBRRhHkH5dyX58qBeIuomSZpw3fHW?=
 =?us-ascii?Q?58HNgnQobPU1d7DOcDn0BbkG50f7pslItRsiE/F6PTp9+PK42+q7TSrpmn96?=
 =?us-ascii?Q?O/JjHi9AyUhuZEiPFcBOIOwC0bqpuZT2U4Ra?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2025 09:47:06.5245
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7abbce41-1ba1-4643-03f3-08ddd8bc0893
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000013F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9686

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
Reviewed-by: Tianyu Lan <tiala@microsoft.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v8:
 - Added Tianyu's Reviewed-by.
 - Updates to use struce secure_avic_page.
 
 arch/x86/kernel/apic/x2apic_savic.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 55edc6c30ba4..cfe72473f843 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -27,6 +27,22 @@ static int savic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 	return x2apic_enabled() && cc_platform_has(CC_ATTR_SNP_SECURE_AVIC);
 }
 
+static inline void *get_reg_bitmap(unsigned int cpu, unsigned int offset)
+{
+	return &per_cpu_ptr(secure_avic_page, cpu)->regs[offset];
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
@@ -135,6 +151,11 @@ static void savic_write(u32 reg, u32 data)
 	}
 }
 
+static void savic_update_vector(unsigned int cpu, unsigned int vector, bool set)
+{
+	update_vector(cpu, SAVIC_ALLOWED_IRR, vector, set);
+}
+
 static void savic_setup(void)
 {
 	void *ap = this_cpu_ptr(secure_avic_page);
@@ -208,6 +229,8 @@ static struct apic apic_x2apic_savic __ro_after_init = {
 	.eoi				= native_apic_msr_eoi,
 	.icr_read			= native_x2apic_icr_read,
 	.icr_write			= native_x2apic_icr_write,
+
+	.update_vector			= savic_update_vector,
 };
 
 apic_driver(apic_x2apic_savic);
-- 
2.34.1


