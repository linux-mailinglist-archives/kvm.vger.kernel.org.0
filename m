Return-Path: <kvm+bounces-26809-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B116977EA4
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 13:40:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A455C1F257AF
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 11:40:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F12B1D88AA;
	Fri, 13 Sep 2024 11:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="UnpmaMC9"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2072.outbound.protection.outlook.com [40.107.93.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557C21BD4E4;
	Fri, 13 Sep 2024 11:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726227649; cv=fail; b=F0NJVyV+h88LVumReSekX8koHzq3AEnbYDwitXsQ4RrK2b0wnFz1mN0Q13CSrjARDphEWRoOOI2/XpkXrG0reA9o8/IBdKvfPO8MpOBiU2ADiEICZ5c9sy4jk+fAYd3xB7HOP6LUy4Hk7JLg/XDK0hAli554irDZkz8VRe7H0GY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726227649; c=relaxed/simple;
	bh=D0B79X5HcChX+2P2MP4NS3uAqFEbg0hh1+PxKNfi/e4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=le+0ifxAPjhzscXt2o3xgxSZGQNqg1OCLgVXHVq08fc1xayyZKWU4jrbK1fAPHCJHft3BUI+P8ebemRbLVNKBH/MavtULfFBrdeEk1FBTyfRkEBQQgkuVVmr4TSJn3HHu6WjOZByCgoHb7ivyBtaIyqfIyAwJMF7fQDBBuPSYpA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=UnpmaMC9; arc=fail smtp.client-ip=40.107.93.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cvIur5uuvhRTT5muKHfAULmxucdKAIdAtNe9oG8X5RsXxPy5sFkMLyy8DzyEORDZwRoiRkvPMDq7THVnDQNU0RouA04CDSxrbvVx58KVZzCuZEFnVF7fOaIUIABblBoxq+bBsWXdfdVqSuMXDjOwRe0p5wyh8WmY7g0pc19fDGsOoYPugctziMO9x+YxNfs9W950PwG0ztgKqdXcML7yOsq1qZyZqTLb/2LzIlHWGs2J6hs3nDLATLUZHQzAio52ad30Qk8JLlXPi/ky6/ldfasbTxiObCPSi+x4DhZE0T1pMiuBJoPLhita/h92IYBXtFKzTEgXl7pEhEqzNadqIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=67n+BTqwxp57PDdD+mi5AMGlWG9UFY7IcjDKz73TOAE=;
 b=md/69RtgeE4WGF7KSXNpqULfVde3pqQhnUlf+wGPdMv/NpJC1DynHby3lFFR//4HuhJJjL7G7YDydmZJQpROu5j0tXYUkynRumL6j98+xS0S64NKi8lLt0kGdxN6v10nGPj6g4cPddQNNpvtimBvFhmQLu/joAn/XT3yW8zFO48Rq1ZB57ECItRnQxexSnGSRXrkGS9VKw0Vm7iAR06zw5NgLf2wM0FSDSMpp6Vpwl6+MLPTV2eJ4dmWj/bxYQNwPPxEE+3nJUuJcIO8/rtKtfL+w5y4FWzuoz9OOyviwf359KSR8sS/b6RbkqidRzOyzJ1R3lx3BHJwIPfpHwuEEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=67n+BTqwxp57PDdD+mi5AMGlWG9UFY7IcjDKz73TOAE=;
 b=UnpmaMC9obmpYhTO/ymzq5KPEn5VivLCiTdMw0Lo14vF6td3q+nHKUuQ44QrM7mWFue0DmO2ZtX3u3OvgOZIjubd5KtsUHx9OtgxAWtWm3ZBP/MuAMfhNi+hl2TKymTsevr9KRBvb1JENm877F8j5YEiGgXAiQBMtvTv5oc8luA=
Received: from DS7PR03CA0192.namprd03.prod.outlook.com (2603:10b6:5:3b6::17)
 by IA0PR12MB7603.namprd12.prod.outlook.com (2603:10b6:208:439::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.17; Fri, 13 Sep
 2024 11:40:44 +0000
Received: from DS3PEPF000099DF.namprd04.prod.outlook.com
 (2603:10b6:5:3b6:cafe::d9) by DS7PR03CA0192.outlook.office365.com
 (2603:10b6:5:3b6::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.24 via Frontend
 Transport; Fri, 13 Sep 2024 11:40:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099DF.mail.protection.outlook.com (10.167.17.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7918.13 via Frontend Transport; Fri, 13 Sep 2024 11:40:44 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 13 Sep
 2024 06:40:38 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <dave.hansen@linux.intel.com>,
	<Thomas.Lendacky@amd.com>, <nikunj@amd.com>, <Santosh.Shukla@amd.com>,
	<Vasant.Hegde@amd.com>, <Suravee.Suthikulpanit@amd.com>, <bp@alien8.de>,
	<David.Kaplan@amd.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<peterz@infradead.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<kvm@vger.kernel.org>
Subject: [RFC 11/14] x86/apic: Allow NMI to be injected from hypervisor for Secure AVIC
Date: Fri, 13 Sep 2024 17:07:02 +0530
Message-ID: <20240913113705.419146-12-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099DF:EE_|IA0PR12MB7603:EE_
X-MS-Office365-Filtering-Correlation-Id: 47fc3429-54d5-4a7f-2233-08dcd3e8e74e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|7416014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qAHoYYZDBayc8O6N3Zet5+jOPdigtJmP8o6JqnglR3kzm+qa+08pHLb+tx3R?=
 =?us-ascii?Q?TJbKbsQEGF5XDWs/x+h0cMy8sZd5bcH8ELTpq4J1iApArk3becVrzCaGdJ7o?=
 =?us-ascii?Q?3gfLNcBlBDOqQEaEHjYwPvHkRzqGWwQ9mIcGxyf54Wl0dOPP36LDm53on0vL?=
 =?us-ascii?Q?dx6u83HeIuowIxekr+UHQjBbl5ONzqNDh3Nva/+n/lUK/0SlRD75/yID4457?=
 =?us-ascii?Q?LozbCJ9lDNlmcvtghsxd/8aoWABApVnCM2ZbPTTEpy2rA0GVncIiv6B3vRGq?=
 =?us-ascii?Q?7fXGPyqSazHD2UFvYnwrYPdqnpTqgn0BKg23arX1FtUE0ORlf6EBdrIuZ37J?=
 =?us-ascii?Q?J6In+l+PWJvMUOdqjWwXB3KS/TiLQFHaO4pvDW+AIzwe/3SxOdrGJBkRaMD6?=
 =?us-ascii?Q?CbtFc+qQqCaL/9dMw8jtKVo4NHOEwvMma8yyiFmhWbDQUgjGnXpMNGIj+1uZ?=
 =?us-ascii?Q?wTacsut7dxckZNFKplF8doBFPclsGlKc2nPWAOyQVrVC8r1Sf/FmaZO4C8i4?=
 =?us-ascii?Q?PtrLo3QuuJciqeO+/hRYkgMuBFKBmj1fpS7+WyITNT00ln+jG+U+V9gRO9C6?=
 =?us-ascii?Q?q2iBad8ha2WNvvQpDX6eBzTfpS+q1tFPa+ygMWCqmtS/cdrZaD5YbNZaihcp?=
 =?us-ascii?Q?eofstuXk3BwxMcyz6Q/+8BM/VOqlvRrIVX1q5WWQ510MSb4oV/xZEGExf0MN?=
 =?us-ascii?Q?WXPJYi1rdeEAUwPaQym780ITMo2bTdJDC/h1R9macHf43m6Xm8p1LvbYWqJj?=
 =?us-ascii?Q?evM1jRPR/9u3d/RoeM1tvCAZubUWUa8qpA1EZx2wbMRtfE9SvMj6/PHmY+5h?=
 =?us-ascii?Q?piy/KtUXmtoOmqbG0K3nkpeuMRynD4dmWfpBfU5Adnf8GB5SJmITKpNveHqt?=
 =?us-ascii?Q?nm23DX2j6LFteNunW6IP5moLv0MDaXbIrhBCPRlzEpbgeDZcI128M1HKT7xm?=
 =?us-ascii?Q?qbUgfsD/KylOPycozyP0SDI1+22SvWsX71lQddqmEhGSa78S8L3v0VS/seCa?=
 =?us-ascii?Q?6CQc4O+bXXiuP8JZrmaimk91V4pma5NfYuUmZF+5cOXMBWjoK/73q40fR9lc?=
 =?us-ascii?Q?EpT2BF4dYTArBahQ2cK8WZJJXEzbxdiAqXIpybaI2gn/IpNE2ep65Dkjvld6?=
 =?us-ascii?Q?AAq5yv4S2kmvVle6/sm2hHnD1y9ig0BadmTtynZkCqp+NsksvPWh9lj8A0CU?=
 =?us-ascii?Q?84EkrubTAoDffx5ROTog7HZ6ErLmFiiGQOI1ju8vre8w7kctlY0vGmaBaSXR?=
 =?us-ascii?Q?e2ROkZ3LlLux2PZCKqf2JdvuePoxBBBOJesyWLzx5Q1RmPXfJsJQITQ1SsHX?=
 =?us-ascii?Q?ok2rXl9EUGMXbQiYIGC0pApJZZRPL4MsNmjfDQvBJZD+tIypMRI3kZO4d6Sz?=
 =?us-ascii?Q?6dFLHg8MOZiuVX+s79GgPTGQrVkR6Ee7r80Cxe6HrB8zEaGTLqJI4VGHa+OV?=
 =?us-ascii?Q?HGTSoX7g7yC/tC0kkiM+ysfCGK3DAJ7m?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(7416014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 11:40:44.5204
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 47fc3429-54d5-4a7f-2233-08dcd3e8e74e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099DF.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7603

From: Kishon Vijay Abraham I <kvijayab@amd.com>

Secure AVIC requires "AllowedNmi" bit in the Secure AVIC Control MSR
to be set for NMI to be injected from hypervisor.

Set "AllowedNmi" bit in Secure AVIC Control MSR here to allow NMI
interrupts to be injected from hypervisor. While at that, also propagate
APIC_LVT0 and APIC_LVT1 register values to the hypervisor required for
injecting NMI interrupts from hypervisor.

Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
 arch/x86/include/asm/msr-index.h    |  5 +++++
 arch/x86/kernel/apic/x2apic_savic.c | 10 ++++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index d0583619c978..0b7454ed7b39 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -662,6 +662,11 @@
 #define MSR_AMD64_SNP_SECURE_AVIC_ENABLED BIT_ULL(MSR_AMD64_SNP_SECURE_AVIC_BIT)
 #define MSR_AMD64_SNP_RESV_BIT		19
 #define MSR_AMD64_SNP_RESERVED_MASK	GENMASK_ULL(63, MSR_AMD64_SNP_RESV_BIT)
+#define MSR_AMD64_SECURE_AVIC_CONTROL	0xc0010138
+#define MSR_AMD64_SECURE_AVIC_EN_BIT	0
+#define MSR_AMD64_SECURE_AVIC_EN	BIT_ULL(MSR_AMD64_SECURE_AVIC_EN_BIT)
+#define MSR_AMD64_SECURE_AVIC_ALLOWEDNMI_BIT 1
+#define MSR_AMD64_SECURE_AVIC_ALLOWEDNMI BIT_ULL(MSR_AMD64_SECURE_AVIC_ALLOWEDNMI_BIT)
 
 #define MSR_AMD64_VIRT_SPEC_CTRL	0xc001011f
 
diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 5502a828a795..321b3678e26f 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -38,6 +38,11 @@ enum lapic_lvt_entry {
 
 #define APIC_LVTx(x) (APIC_LVTT + 0x10 * (x))
 
+static inline void savic_wr_control_msr(u64 val)
+{
+	native_wrmsr(MSR_AMD64_SECURE_AVIC_CONTROL, lower_32_bits(val), upper_32_bits(val));
+}
+
 static int x2apic_savic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 	return x2apic_enabled() && cc_platform_has(CC_ATTR_SNP_SECURE_AVIC);
@@ -143,12 +148,12 @@ static void x2apic_savic_write(u32 reg, u32 data)
 
 	switch (reg) {
 	case APIC_LVTT:
+	case APIC_LVT0:
+	case APIC_LVT1:
 	case APIC_TMICT:
 	case APIC_TDCR:
 		write_msr_to_hv(reg, data);
 		break;
-	case APIC_LVT0:
-	case APIC_LVT1:
 	/* APIC_ID is writable and configured by guest for Secure AVIC */
 	case APIC_ID:
 	case APIC_TASKPRI:
@@ -401,6 +406,7 @@ static void x2apic_savic_setup(void)
 	ret = sev_notify_savic_gpa(gpa);
 	if (ret != ES_OK)
 		snp_abort();
+	savic_wr_control_msr(gpa | MSR_AMD64_SECURE_AVIC_ALLOWEDNMI);
 	this_cpu_write(savic_setup_done, true);
 }
 
-- 
2.34.1


