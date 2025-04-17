Return-Path: <kvm+bounces-43542-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DBCCA9178C
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 11:19:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8F00C1908041
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 09:19:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DD41226CFB;
	Thu, 17 Apr 2025 09:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="5YAQzRDx"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2072.outbound.protection.outlook.com [40.107.237.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87131226165;
	Thu, 17 Apr 2025 09:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744881551; cv=fail; b=NQGXalTZ6BtMi3i4ADQTbEqUuu9KlnIQv6ewhAADhxxX9vF6pqR0RQcEnibO74uvldzyhEq2CVy/NmCuXoK+DyCbXrbqe/qua2KEpAhckVud8AAHrA7FadPGio0AoLmz6PWp1yA/5oywZCCFnM75C2W1WeSlSP18PN0rEfw3RTE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744881551; c=relaxed/simple;
	bh=cTCmuX0OyDV9hwAMWR+gHDUscpihgKiRNKdAjjJhB70=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GliLlYo2atbf+znBIGJkvMlXlFGxsX6Agw0o7y2GtceBnsnfD0dUazXaPUlQbHaXRrXR6Q8LT+VASwM+iOHmzr6cInQ958LPr1DaWWsA/sAjt0+qrRYhpdlo8RzKuQ0GxjE2hHqEikN73hi/C/WzjAwTn8TTGK0wQZIKS36+Z4Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=5YAQzRDx; arc=fail smtp.client-ip=40.107.237.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SPvfhUYnmBEONCOsZBDaYCWAWgKlT1MhSgVZtFTT0rDqP9nGTgdzqTC+iFvcHs7rz3Qm0sPbCVKFAkO3hKeLztQlmVaGutNCkrWjf18CBMq/FUPCGbtSuxJLSNBXkXHzLABr7zRgxguOkoXBeq3X+wgPr27n2WQ1i0LTH+u2aE/f6uRJupvxa7NciKpRxjZmD4ucY/J5G2eTVDTr/7CE385O9582NW4Zduyncw/1/D0PBrGvXGJTbBVv0pqEIRxbC1AXNtA4fiZxTXJFyLnH+aU6cuytATEavEVIDP3l2Sqs1ha+NFFcfbbarzuMZKfmlblsFHVtcewjH6hSQtpK5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mne2i8DZUuiNpzYapTqn4JRlks/rxlh9+K+gh5eoXYM=;
 b=JVXYgAAcSrQ8qOZImyOGFo+Tgl2bo/z4x8ly83uOGEHpq+ohsf/dI8u/1VB0a4UffYG//tAL4A6vFXMFvcMJTFCsQqgX0+pPD5Ch3LoaGipdGTpBQmFzUW8tEdk1wsm6xboG/C+axdLqLh4+ciHQHYImgIID59LewZmTXm0EN1FZxj7h/eFVwCrsdb3vN4HHWoxpHchu1TACkQfZsqZIaAhA2uWAmykon98ckW8mMJO6HUCxGit6pvxoVxc8cahf8pQyzAg6FhogJUt3bBvCvZYUkWJ/eIU2mXIvpNdXdOfsQcqExBdhmjDeTx9zU1VzecPV1nYAUpaOhvXxOe37JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mne2i8DZUuiNpzYapTqn4JRlks/rxlh9+K+gh5eoXYM=;
 b=5YAQzRDxiIa74ZzRVsFqL0bXO31cpl4gW7GD20S6piCwZqSwldyGBsg49BO7/UiLy/aUkkDOHnndH5UJBvQevNWMxAnmgtrrJ7TufGk/bJf+BHe0L5sKb5CoPlN93RkCvlf+I2qEoKuk8KqMt1LoRgkXTon4XnVY2/qzn63nwOY=
Received: from MN0P221CA0018.NAMP221.PROD.OUTLOOK.COM (2603:10b6:208:52a::29)
 by SA3PR12MB7974.namprd12.prod.outlook.com (2603:10b6:806:307::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.34; Thu, 17 Apr
 2025 09:19:04 +0000
Received: from BN2PEPF000055DF.namprd21.prod.outlook.com
 (2603:10b6:208:52a:cafe::7b) by MN0P221CA0018.outlook.office365.com
 (2603:10b6:208:52a::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.15 via Frontend Transport; Thu,
 17 Apr 2025 09:19:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF000055DF.mail.protection.outlook.com (10.167.245.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8678.4 via Frontend Transport; Thu, 17 Apr 2025 09:19:04 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 17 Apr 2025 04:18:56 -0500
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
Subject: [PATCH v4 04/18] x86/apic: Populate .read()/.write() callbacks of Secure AVIC driver
Date: Thu, 17 Apr 2025 14:46:54 +0530
Message-ID: <20250417091708.215826-5-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000055DF:EE_|SA3PR12MB7974:EE_
X-MS-Office365-Filtering-Correlation-Id: 005d6c41-c855-4364-c317-08dd7d90e611
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gk9TFFUxshb3KT64QTHzZ11atBy8u92orJNeggsC41NaxsCZLvj+HPSbC+LV?=
 =?us-ascii?Q?p2b6srdoim1kKsoqCnec9hK++jfD/QZy9aBGO8+l/81er3KCoR+Dvf0bIn89?=
 =?us-ascii?Q?xjxQ8NznrFv2LpV40h2QCTk+2GHq3uxVmXjVpy0mgMkfQazyyLiItTUYSZFA?=
 =?us-ascii?Q?pBEYbdmiGMuwDKg6w7wylnFFMawYZsbyl904oFG6LbmAazURb74gF39oDC1+?=
 =?us-ascii?Q?Xbsjw79h8/BaILYRZu5TBolNJomUl3LFZuhyUodubzmCFe686rhDop6+40TU?=
 =?us-ascii?Q?XxQGozQUuffOllpHSTuNQ49Py7j8gkkwU3YyO+10cin8w/SFsvrsxg0vskTD?=
 =?us-ascii?Q?T3DhYswVY7TUDid/chseijCn73d/Hm1Zmn4jgkU0afXDGpEJ2YlPGvsFNJgT?=
 =?us-ascii?Q?CT8hdMcX8exBZ2ciP5cmx3vx7KJC3o33JE/c8K8Jnw7hQxuWzgdY4LPlg1eR?=
 =?us-ascii?Q?liDYKCEMIU32OavHkrhmHOhhnZfm7l1iww/IUjndxbCl/GIwpNBoyr8lzQ46?=
 =?us-ascii?Q?VdFUc0hOGNnG44yz0jzcTiuaZgsDpNRB5oK8ZvsMv9wfrG/WTreseqLONzRl?=
 =?us-ascii?Q?92edybZ20bUD/4NvKrnXmgRF1bDoQ5K4sFI2SM84SOHAOjKN5UQLeRYjsAf8?=
 =?us-ascii?Q?XlJ31wE+SCEa3sgOdwg+P8ajz3s0VpNnMj2g6rkdDqz+gD19BZIBgJcSSihO?=
 =?us-ascii?Q?56xfjTqoMrsrFtBMn5ZbvRO2DIYNbUVGLpdciOadgY17pqiO7pwM9bxvRn3o?=
 =?us-ascii?Q?5i8ZaH/fWpPyVplOC2zjffMnTuMFsiJQir9Vs2kgtQ51Fzobruom8pqHKHMm?=
 =?us-ascii?Q?xrMYeTak3HWlF2yWXH1+VXudlpcyp66MZna78pHqUZNRaVmzokJ8lGXhD0VA?=
 =?us-ascii?Q?pL0DF6fJJdbvFKb6tPmTe767iiiPeSZjdz2/fZ2a9tSvkossQl5bW9x7q42q?=
 =?us-ascii?Q?C8CF6YX11j7xaTfJCULAnrYsbzUA2pmhPbTKQcRFO3XiSP62QUjIeOoY//r3?=
 =?us-ascii?Q?jYddRCWlIXYx+laYi4/gPBILEY0Au7z1vCp7WkB9QbHe505GXyZi5m7c8vRy?=
 =?us-ascii?Q?Kn/h3cAnAmTCe6M2X7YC8l621Bk1EEviE1ziUedFCegSczvJi7AhyYaH/Pdk?=
 =?us-ascii?Q?cOEW0IhfIPNBO/2Zzbu3hHfVt4Y/mleGSh3Dy5Y+f3aBQ+yVntnb/s1cyh10?=
 =?us-ascii?Q?InNPHEBc9hlNBr/dXlY7ZSaNhirKFXDCcNugE2Fi2cvxJRKFowzi/dO7W4WI?=
 =?us-ascii?Q?JRVYAvF9rqAImA9DExk/O8Q7NhhkdrWtB/jF9F5yOXSJ+cFPTN5R9D/wpdZi?=
 =?us-ascii?Q?7Xz+dG9mNbKLNGBUsKufYepsO3vRxY5580Aiy9tbMuwL+BYOy/e+dPy7uHUi?=
 =?us-ascii?Q?xCT1BiQx5HYfctmV3ESJRQTom1im3i1qyiJ0EFAaXIk57MUXQR2qxuLYetV9?=
 =?us-ascii?Q?AXUWSaS+eNAbcWcn3H5CPIxjJVdY6YiP7NROD+8pu/SlT1EAa8oL8KDiALxG?=
 =?us-ascii?Q?BxvtA1o9dgvSTUz8k+kZJH8BOP5Kngql27tu?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2025 09:19:04.4739
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 005d6c41-c855-4364-c317-08dd7d90e611
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055DF.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7974

Add read() and write() APIC callback functions to read and write x2APIC
registers directly from the guest APIC backing page of a vCPU.

The x2APIC registers are mapped at an offset within the guest APIC
backing page which is same as their x2APIC MMIO offset. Secure AVIC
adds new registers such as ALLOWED_IRRs (which are at 4-byte offset
within the IRR register offset range) and NMI_REQ to the APIC register
space.

When Secure AVIC is enabled, guest's rdmsr/wrmsr of APIC registers
result in VC exception (for non-accelerated register accesses) with
error code VMEXIT_AVIC_NOACCEL. The VC exception handler can read/write
the x2APIC register in the guest APIC backing page to complete the
rdmsr/wrmsr. Since doing this would increase the latency of accessing
x2APIC registers, instead of doing rdmsr/wrmsr based reg accesses
and handling reads/writes in VC exception, directly read/write APIC
registers from/to the guest APIC backing page of the vCPU in read()
and write() callbacks of the Secure AVIC APIC driver.

Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v3:

 - Removed "x2apic_" from savic's apic cbs func names.

 arch/x86/include/asm/apicdef.h      |   2 +
 arch/x86/kernel/apic/x2apic_savic.c | 116 +++++++++++++++++++++++++++-
 2 files changed, 116 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/apicdef.h b/arch/x86/include/asm/apicdef.h
index 094106b6a538..be39a543fbe5 100644
--- a/arch/x86/include/asm/apicdef.h
+++ b/arch/x86/include/asm/apicdef.h
@@ -135,6 +135,8 @@
 #define		APIC_TDR_DIV_128	0xA
 #define	APIC_EFEAT	0x400
 #define	APIC_ECTRL	0x410
+#define APIC_SEOI	0x420
+#define APIC_IER	0x480
 #define APIC_EILVTn(n)	(0x500 + 0x10 * n)
 #define		APIC_EILVT_NR_AMD_K8	1	/* # of extended interrupts */
 #define		APIC_EILVT_NR_AMD_10H	4
diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 0a2cb1c03d08..4761afc7527d 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -9,6 +9,7 @@
 
 #include <linux/cc_platform.h>
 #include <linux/percpu-defs.h>
+#include <linux/align.h>
 
 #include <asm/apic.h>
 #include <asm/sev.h>
@@ -32,6 +33,117 @@ static int savic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 	return x2apic_enabled() && cc_platform_has(CC_ATTR_SNP_SECURE_AVIC);
 }
 
+static __always_inline u32 get_reg(unsigned int offset)
+{
+	return READ_ONCE(this_cpu_ptr(apic_page)->regs[offset >> 2]);
+}
+
+static __always_inline void set_reg(unsigned int offset, u32 val)
+{
+	WRITE_ONCE(this_cpu_ptr(apic_page)->regs[offset >> 2], val);
+}
+
+#define SAVIC_ALLOWED_IRR	0x204
+
+static u32 savic_read(u32 reg)
+{
+	/*
+	 * When Secure AVIC is enabled, rdmsr/wrmsr of APIC registers
+	 * result in VC exception (for non-accelerated register accesses)
+	 * with VMEXIT_AVIC_NOACCEL error code. The VC exception handler
+	 * can read/write the x2APIC register in the guest APIC backing page.
+	 * Since doing this would increase the latency of accessing x2APIC
+	 * registers, instead of doing rdmsr/wrmsr based accesses and
+	 * handling apic register reads/writes in VC exception, the read()
+	 * and write() callbacks directly read/write APIC register from/to
+	 * the vCPU APIC backing page.
+	 */
+	switch (reg) {
+	case APIC_LVTT:
+	case APIC_TMICT:
+	case APIC_TMCCT:
+	case APIC_TDCR:
+	case APIC_ID:
+	case APIC_LVR:
+	case APIC_TASKPRI:
+	case APIC_ARBPRI:
+	case APIC_PROCPRI:
+	case APIC_LDR:
+	case APIC_SPIV:
+	case APIC_ESR:
+	case APIC_ICR:
+	case APIC_LVTTHMR:
+	case APIC_LVTPC:
+	case APIC_LVT0:
+	case APIC_LVT1:
+	case APIC_LVTERR:
+	case APIC_EFEAT:
+	case APIC_ECTRL:
+	case APIC_SEOI:
+	case APIC_IER:
+	case APIC_EILVTn(0) ... APIC_EILVTn(3):
+		return get_reg(reg);
+	case APIC_ISR ... APIC_ISR + 0x70:
+	case APIC_TMR ... APIC_TMR + 0x70:
+		if (WARN_ONCE(!IS_ALIGNED(reg, 16),
+			      "APIC reg read offset 0x%x not aligned at 16 bytes", reg))
+			return 0;
+		return get_reg(reg);
+	/* IRR and ALLOWED_IRR offset range */
+	case APIC_IRR ... APIC_IRR + 0x74:
+		/*
+		 * Either aligned at 16 bytes for valid IRR reg offset or a
+		 * valid Secure AVIC ALLOWED_IRR offset.
+		 */
+		if (WARN_ONCE(!(IS_ALIGNED(reg, 16) ||
+				IS_ALIGNED(reg - SAVIC_ALLOWED_IRR, 16)),
+			      "Misaligned IRR/ALLOWED_IRR APIC reg read offset 0x%x", reg))
+			return 0;
+		return get_reg(reg);
+	default:
+		pr_err("Permission denied: read of Secure AVIC reg offset 0x%x\n", reg);
+		return 0;
+	}
+}
+
+#define SAVIC_NMI_REQ		0x278
+
+static void savic_write(u32 reg, u32 data)
+{
+	switch (reg) {
+	case APIC_LVTT:
+	case APIC_LVT0:
+	case APIC_LVT1:
+	case APIC_TMICT:
+	case APIC_TDCR:
+	case APIC_SELF_IPI:
+	case APIC_TASKPRI:
+	case APIC_EOI:
+	case APIC_SPIV:
+	case SAVIC_NMI_REQ:
+	case APIC_ESR:
+	case APIC_ICR:
+	case APIC_LVTTHMR:
+	case APIC_LVTPC:
+	case APIC_LVTERR:
+	case APIC_ECTRL:
+	case APIC_SEOI:
+	case APIC_IER:
+	case APIC_EILVTn(0) ... APIC_EILVTn(3):
+		set_reg(reg, data);
+		break;
+	/* ALLOWED_IRR offsets are writable */
+	case SAVIC_ALLOWED_IRR ... SAVIC_ALLOWED_IRR + 0x70:
+		if (IS_ALIGNED(reg - SAVIC_ALLOWED_IRR, 16)) {
+			set_reg(reg, data);
+			break;
+		}
+		fallthrough;
+	default:
+		pr_err("Permission denied: write to Secure AVIC reg offset 0x%x\n", reg);
+	}
+}
+
 static void savic_setup(void)
 {
 	void *backing_page;
@@ -95,8 +207,8 @@ static struct apic apic_x2apic_savic __ro_after_init = {
 
 	.nmi_to_offline_cpu		= true,
 
-	.read				= native_apic_msr_read,
-	.write				= native_apic_msr_write,
+	.read				= savic_read,
+	.write				= savic_write,
 	.eoi				= native_apic_msr_eoi,
 	.icr_read			= native_x2apic_icr_read,
 	.icr_write			= native_x2apic_icr_write,
-- 
2.34.1


