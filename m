Return-Path: <kvm+bounces-26801-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EC8B0977E92
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 13:38:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AD78728360D
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 11:38:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FD0B1D88CE;
	Fri, 13 Sep 2024 11:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="bUUmJE8n"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2044.outbound.protection.outlook.com [40.107.236.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5D11D86DC;
	Fri, 13 Sep 2024 11:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726227497; cv=fail; b=MEuNtTZHLCqIFxLushft0eVnTeIhilfpyVRTacSKbyL1kcH0QUT7vDk0V6ZVbsWbMLWkBAcJgDgPwSghGE8EumqNsH0eAUerSC1GTdCD+MVPAgMRoZMaIcxol4js+eYpclCRwEwHiBUP7DbrYbA8YYv/9BdMpBWIc/Q0erGEa7c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726227497; c=relaxed/simple;
	bh=q8u3We2VLkPF/lz36iDTTedNi5w4bbEGcgaDaql0+y0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=td38eR9QlpVfLNUy0j/kQ0x3Yz3QQAenZtMTeAlKYxnoAms95kwaq+aq3VOVCmcoas6cuXVvI3RPsWxOSNEFZ47HF2buDcjeqoJwJTWCHOtnzqDj2CvJDQIL+PBy/jUESuFze2FjUZ/sKh/018GgwEalZxnw0OLMh6JGm5P+QBk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=bUUmJE8n; arc=fail smtp.client-ip=40.107.236.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xvo+vwwgwBJIeIU/SyZTVIr8zDttXCR9aekpfrp0hdPCbvkAtUP5bJb0Wfg7RBU1T2J4VfdM494lU5rBSFSez/CYuN/zMoH/L/j6MWDCaL5mjTsCO8elwCLhxpWAAvCMAWM5wGtv5lshSLJw3huQobL1+d49NG92LTQimm65Usm8T/VvB1ALb0uN6+wRR8CenXLwk8zHtSM9o50me2/4v/I3qsLumJUKlsvztMfyRrdEF24B0WQpbPrRcUCLFk98v9K7y+ORXI5OGwXTvwsFug9ZbQknCbI9FRRmrZoaLoqbz0iQH3zgvuN4UtVjchAAYIEv2B4j7khbvwWf0Loi+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dI4RnNYDa8AEATzqojqiA/fNQIL6jNQN7KLJKpDRQs0=;
 b=dcCUkFi6/ht5fVdDcelojGZiLnboKklgJD/ytWN5/OGQSot1lGYj8gYjpQn5zEcPPKY5Oi5dMJ2Yg52L9Mo0lvts4qcVx3+opMHOM2S51ck0/KOJyTcoiWJk5uRKCXExOZBUppFNp1TOxwcnpc2TpqSTCqtRPAUPqQgDIk6VNretIsgLTSRsH75mDCqpclxyhI/HOOomxI7LX5UiBgKJY/JWrro3fYTAaREK4P0QjHVTe+muYkfVzNnGcBq0iQOPZcLhnMDwwfAlmcwZ03BuPknHBoLtO4Cwyuw4t1F6db2TUF3oXNc/OhiNWFnvIfhz8KWSABn3WMrCJyOWrN7W5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dI4RnNYDa8AEATzqojqiA/fNQIL6jNQN7KLJKpDRQs0=;
 b=bUUmJE8nuQttUrIyEqb4XNwFlp+7W7rExhPGnBc6M7lNxof0SlGiMNChkHRWB033zFhtPp4StyrXgxbHQ61WxdJnWHr51GyksputWV6nn/BPdUEDu9AsUqKC3Qn3j3sN34wVOQLuysrh8rMIuUWQJKvmnmMyFyrunmf5hJ4sELM=
Received: from CH0PR04CA0056.namprd04.prod.outlook.com (2603:10b6:610:77::31)
 by SJ2PR12MB8160.namprd12.prod.outlook.com (2603:10b6:a03:4af::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.25; Fri, 13 Sep
 2024 11:38:12 +0000
Received: from DS3PEPF000099E2.namprd04.prod.outlook.com
 (2603:10b6:610:77:cafe::c3) by CH0PR04CA0056.outlook.office365.com
 (2603:10b6:610:77::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.26 via Frontend
 Transport; Fri, 13 Sep 2024 11:38:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099E2.mail.protection.outlook.com (10.167.17.201) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7918.13 via Frontend Transport; Fri, 13 Sep 2024 11:38:11 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 13 Sep
 2024 06:38:06 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <dave.hansen@linux.intel.com>,
	<Thomas.Lendacky@amd.com>, <nikunj@amd.com>, <Santosh.Shukla@amd.com>,
	<Vasant.Hegde@amd.com>, <Suravee.Suthikulpanit@amd.com>, <bp@alien8.de>,
	<David.Kaplan@amd.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<peterz@infradead.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<kvm@vger.kernel.org>
Subject: [RFC 03/14] x86/apic: Populate .read()/.write() callbacks of Secure AVIC driver
Date: Fri, 13 Sep 2024 17:06:54 +0530
Message-ID: <20240913113705.419146-4-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099E2:EE_|SJ2PR12MB8160:EE_
X-MS-Office365-Filtering-Correlation-Id: e3272934-8d9f-4c34-6975-08dcd3e88c18
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|82310400026|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?juJCZDOAHjyYhUSjDbqphNFJSRl5aBAsQUK2aVyxJ9r007SI7CnjdRV71SpW?=
 =?us-ascii?Q?/5na2YOn2ElxganPBOi8bgOBzXY07imHVUjUsr5YKdms5BY86ESWvZwh0Rqk?=
 =?us-ascii?Q?YtGwF5rNDxj7KbzzotlvtGiHrd+0JZ6KXXuTflZMwRG0W/bT7TCmEq9W+mXH?=
 =?us-ascii?Q?rEB/pbPDpo4WBoBXQ3FgkXGdBBi2lfvR+/Tv0n8W+Yqu+MSQxhiGoQDGnY0+?=
 =?us-ascii?Q?Q7oI2Qo0NGJ260p84OQLYf+vQ5SYONTdPQ9aTdaTzNbb4ul0cpdlHTCB5e1i?=
 =?us-ascii?Q?jSm2zlQmz90qgDEA9NyZmHtnXeMGb04Bo7SgLq10L+BNn69vf40VxFsgB/8d?=
 =?us-ascii?Q?+hliMcuX8WKxuXxFex261G30b1pZa+g+5FyYRzduiur5BpJr0wk0GFPOZ8nJ?=
 =?us-ascii?Q?cwl6SwD0ZH7H1dKOuOkZW5eLSVuiFbpi+a007KJHcsu73gmd4nlpEkLt/K29?=
 =?us-ascii?Q?euS6Wz6Uthm5EsDUAfu/3ToP4/tIPY5b3dn4YGWoZjqbAq120hzehRdQBnlR?=
 =?us-ascii?Q?A3H05RgKt61pXlfN7g+J01UcmA+6gTxy26FOaXX/mq9E6nhmGkxymkqQ9FDI?=
 =?us-ascii?Q?DXjZvqZodaXQRg3yRs+8vgWI8/cfftdQWi6x9O9U3d/Z6LNed58v80KurdQn?=
 =?us-ascii?Q?xqievI6aQWTHKJ+BGXDE/ST65t1f+k+oOhuzeE8U/tY2r0igvHJVnzOSi7sg?=
 =?us-ascii?Q?hDrfXcGmzU6C9BVIg5+Qkufsxl1azijEnK+HJMJHCcMWn91SgLtfsZd6TAmO?=
 =?us-ascii?Q?J9RzPgbt0XdDaEsEGAptCvraCYyviIEtalApHLheyfQ7PGcCeF0QEriDVCXx?=
 =?us-ascii?Q?flN0/+uGyk4pK3nLmqmpFHjcaVdlIMKxHw21HdVHq63yaRPYXs02HOaLc7wn?=
 =?us-ascii?Q?bs4wtYwA1vByrNeZwJOe7P4dQvul0JwRCYu5EIzlljHuhQoI0NT+rshSv3i1?=
 =?us-ascii?Q?jvi1wJQoJIXIDn+WCVclD9IiaA/gJP9WRE71gtsp/ZYH24YXsn850iUSHNel?=
 =?us-ascii?Q?QLdXfcP5wflc/FoUa2jgrBP1jyjlvVEFYpZV1LngNKA2u4C4WFdYdo/GFSau?=
 =?us-ascii?Q?nMJNiO39ADgqgxfNxtLsTwgtV3aXQlXGNY0gHnpCCAD9eJjKp2ki+R4OT9x2?=
 =?us-ascii?Q?sGJKMKodcWynl5bKomw1XKuhnsGwrAJo+KdNkdKmcW5+IZCG1YTmNiCNxZST?=
 =?us-ascii?Q?Yvfd8okrdEr2VhUupO1hGoiFTlxkKzs6t8fuALai+dRHh04YS16b/nJckZfy?=
 =?us-ascii?Q?ceU+UxaXA3gT3o9CiI4JR5e49yw9b2UrK/k0OoKqohVcdbhbQsfcENGVAu5i?=
 =?us-ascii?Q?pEXMI6bKdqMn0hwB+v62xpc/5EufoAJqLiaM5Y/jAT5pEjSgXAGSTbVrcfLK?=
 =?us-ascii?Q?Yv3215nyd/nAcwY9NTaejkCfILw/7jQTLN5t0WHiHvhk0/cA6pHtSFlAWusY?=
 =?us-ascii?Q?dkD+vHa3Wzk69MV4lcgROIfEjkh2eGhv?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(82310400026)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 11:38:11.4957
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e3272934-8d9f-4c34-6975-08dcd3e88c18
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099E2.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8160

The x2APIC registers are mapped at an offset within the guest APIC
backing page which is same as their x2APIC MMIO offset. Secure AVIC
adds new registers such as ALLOWED_IRRs (which are at 4-byte offset
within the IRR register offset range) and NMI_REQ to the APIC register
space. In addition, the APIC_ID register is writable and configured by
guest.

Add read() and write() APIC callback functions to read and write x2APIC
registers directly from the guest APIC backing page.

The default .read()/.write() callbacks of x2APIC drivers perform
a rdmsr/wrmsr of the x2APIC registers. When Secure AVIC is enabled,
these would result in #VC exception (for non-accelerated register
accesses). The #VC exception handler reads/write the x2APIC register
in the guest APIC backing page. Since this would increase the latency
of accessing x2APIC registers, the read() and write() callbacks of
Secure AVIC driver directly reads/writes to the guest APIC backing page.

Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
 arch/x86/include/asm/apicdef.h      |   2 +
 arch/x86/kernel/apic/x2apic_savic.c | 107 +++++++++++++++++++++++++++-
 2 files changed, 107 insertions(+), 2 deletions(-)

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
index d903c35b8b64..6a471bbc3dba 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -10,6 +10,7 @@
 #include <linux/cpumask.h>
 #include <linux/cc_platform.h>
 #include <linux/percpu-defs.h>
+#include <linux/align.h>
 
 #include <asm/apic.h>
 #include <asm/sev.h>
@@ -24,6 +25,108 @@ static int x2apic_savic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 	return x2apic_enabled() && cc_platform_has(CC_ATTR_SNP_SECURE_AVIC);
 }
 
+static inline u32 get_reg(char *page, int reg_off)
+{
+	return READ_ONCE(*((u32 *)(page + reg_off)));
+}
+
+static inline void set_reg(char *page, int reg_off, u32 val)
+{
+	WRITE_ONCE(*((u32 *)(page + reg_off)), val);
+}
+
+#define SAVIC_ALLOWED_IRR_OFFSET	0x204
+
+static u32 x2apic_savic_read(u32 reg)
+{
+	void *backing_page = this_cpu_read(apic_backing_page);
+
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
+		return get_reg(backing_page, reg);
+	case APIC_ISR ... APIC_ISR + 0x70:
+	case APIC_TMR ... APIC_TMR + 0x70:
+		WARN_ONCE(!IS_ALIGNED(reg, 16), "Reg offset %#x not aligned at 16 bytes", reg);
+		return get_reg(backing_page, reg);
+	/* IRR and ALLOWED_IRR offset range */
+	case APIC_IRR ... APIC_IRR + 0x74:
+		/*
+		 * Either aligned at 16 bytes for valid IRR reg offset or a
+		 * valid Secure AVIC ALLOWED_IRR offset.
+		 */
+		WARN_ONCE(!(IS_ALIGNED(reg, 16) || IS_ALIGNED(reg - SAVIC_ALLOWED_IRR_OFFSET, 16)),
+			  "Misaligned IRR/ALLOWED_IRR reg offset %#x", reg);
+		return get_reg(backing_page, reg);
+	default:
+		pr_err("Permission denied: read of Secure AVIC reg offset %#x\n", reg);
+		return 0;
+	}
+}
+
+#define SAVIC_NMI_REQ_OFFSET		0x278
+
+static void x2apic_savic_write(u32 reg, u32 data)
+{
+	void *backing_page = this_cpu_read(apic_backing_page);
+
+	switch (reg) {
+	case APIC_LVTT:
+	case APIC_LVT0:
+	case APIC_LVT1:
+	case APIC_TMICT:
+	case APIC_TDCR:
+	case APIC_SELF_IPI:
+	/* APIC_ID is writable and configured by guest for Secure AVIC */
+	case APIC_ID:
+	case APIC_TASKPRI:
+	case APIC_EOI:
+	case APIC_SPIV:
+	case SAVIC_NMI_REQ_OFFSET:
+	case APIC_ESR:
+	case APIC_ICR:
+	case APIC_LVTTHMR:
+	case APIC_LVTPC:
+	case APIC_LVTERR:
+	case APIC_ECTRL:
+	case APIC_SEOI:
+	case APIC_IER:
+	case APIC_EILVTn(0) ... APIC_EILVTn(3):
+		set_reg(backing_page, reg, data);
+		break;
+	/* ALLOWED_IRR offsets are writable */
+	case SAVIC_ALLOWED_IRR_OFFSET ... SAVIC_ALLOWED_IRR_OFFSET + 0x70:
+		if (IS_ALIGNED(reg - SAVIC_ALLOWED_IRR_OFFSET, 16)) {
+			set_reg(backing_page, reg, data);
+			break;
+		}
+		fallthrough;
+	default:
+		pr_err("Permission denied: write to Secure AVIC reg offset %#x\n", reg);
+	}
+}
+
 static void x2apic_savic_send_IPI(int cpu, int vector)
 {
 	u32 dest = per_cpu(x86_cpu_to_apicid, cpu);
@@ -140,8 +243,8 @@ static struct apic apic_x2apic_savic __ro_after_init = {
 	.send_IPI_self			= x2apic_send_IPI_self,
 	.nmi_to_offline_cpu		= true,
 
-	.read				= native_apic_msr_read,
-	.write				= native_apic_msr_write,
+	.read				= x2apic_savic_read,
+	.write				= x2apic_savic_write,
 	.eoi				= native_apic_msr_eoi,
 	.icr_read			= native_x2apic_icr_read,
 	.icr_write			= native_x2apic_icr_write,
-- 
2.34.1


