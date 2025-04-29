Return-Path: <kvm+bounces-44693-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C4C46AA02AB
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 08:13:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EECCE7B14CE
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 06:11:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C86252749E1;
	Tue, 29 Apr 2025 06:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0Y4LFr74"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2079.outbound.protection.outlook.com [40.107.102.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD7A1DB366;
	Tue, 29 Apr 2025 06:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745907145; cv=fail; b=ZsgvfKzJdgQ5ZqwhQnOa4PcW1zo+vc0muTgtypDabA6/1uxQQLxaBJNiC5kMUJa+nc/msIcCEtXMcqZ/ah/K+yBkigBGvFeHZJkHtfZxg4iRZx7kOaD93nT09PmV7JU4icw5i3cOaMCncyvwWFZLpgF7Ng3ZqN5oHcGDOpW+6ng=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745907145; c=relaxed/simple;
	bh=4k0dJ+qV6NGzq9vZDCe/1A9a3Qk2simLHn5vj7BRkws=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QppwgESTyEilaHeR1pgviPO2xqutpI6CCAs5n9gqmHXiuo4aWWz24Lyga/0lHKxbammzvXDdfA2+o2TGSMWiUk44mUIwLZBFwW3TB50GaRWWQlECAL2n3rj5aqopOPz1UN+Sgr4cOxQTA8ZiG01hEoA7H6ZpVGpRR1yIc+iTK40=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0Y4LFr74; arc=fail smtp.client-ip=40.107.102.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dsrS0nK72S1fH8qpVL191tQgxZlmZqRqaNHbuJX2l092BzzoNyZwDJ8pY+ffPWwST5/7thMHLMye1b2PurYczURcuzZLnEg5tIhtyuofwoxL8Mb6z+CG5297QhI6b9mNoGDV5BJIHhf8qYK4G89x9BQXeG048F55QJ0xcN80htbGWk7ZAPlZCs9jjWfgfOloNcjuqx9d71UxpcXim6MCBsV2hVx9kyJJm9pQJIGRr1v5z3KRde/iUq3L2WUr33ibEoQ6yc+rfZOBuXaAACF4YwcZjJk8CeYAWRpgUHg4DIBR+AnrFjGPmRP4fX1GFH+d2ERlingHSKCi4KYWnu6sjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1dOA9IaDU8aHJj0Zo2MhX6c2yQ2Se0n9W/kFEFT91e4=;
 b=WHmlDvdaC/P5DkF24irmL/i0ckImoaZ9FrgT6/KKa9c/g3ESiS2Du2Yt9u/JMPTXBDMbFbSHDphukaLQlEFvFzTxTT9bt0+mifLkLNQNQZLoWVVhP6eY/o0XXWv9LgNlzWucao1pP8avtZuwPVlOEa+xPragktg2WCcsokVZL8o2C2IUjv3uopJoaBcuzNXCR472Fql8n4t29ezz1gwZWPQ9eE8KABjVqFZ+nKEqzrneSVqkSn1LuJtK7nGP9MNo5pOf1KZIN6eJ6zKFqqtAr6fv8X/wCLHQIMBCyhw/rQ8zQxG6rR7QP2RjgZGEkdZtuFkNgZXdNp2pBD0Ta0aPCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1dOA9IaDU8aHJj0Zo2MhX6c2yQ2Se0n9W/kFEFT91e4=;
 b=0Y4LFr749snx52F7ceST22C2IkG6uBP+YhhzD8WBIfOMM3JRsvYT0fzjxrvKgXf6XqibR3bN9YWHHIZdZ+VZpLQtbOpFuryvP5jR9lJaX6l8ECP63mfRsGpVELCX4fd10qORdX91Oy/ynh2kx5ZT+YyFSW7XjQjRXPSeFZ6kleA=
Received: from BLAPR03CA0079.namprd03.prod.outlook.com (2603:10b6:208:329::24)
 by SA1PR12MB7271.namprd12.prod.outlook.com (2603:10b6:806:2b8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.26; Tue, 29 Apr
 2025 06:12:18 +0000
Received: from BL6PEPF0001AB56.namprd02.prod.outlook.com
 (2603:10b6:208:329:cafe::c) by BLAPR03CA0079.outlook.office365.com
 (2603:10b6:208:329::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.36 via Frontend Transport; Tue,
 29 Apr 2025 06:12:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB56.mail.protection.outlook.com (10.167.241.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8678.33 via Frontend Transport; Tue, 29 Apr 2025 06:12:18 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 29 Apr 2025 01:12:05 -0500
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
Subject: [PATCH v5 05/20] x86/apic: Populate .read()/.write() callbacks of Secure AVIC driver
Date: Tue, 29 Apr 2025 11:39:49 +0530
Message-ID: <20250429061004.205839-6-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB56:EE_|SA1PR12MB7271:EE_
X-MS-Office365-Filtering-Correlation-Id: 405a6434-36b4-4411-9222-08dd86e4cb98
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?I2nMVoRMvB5AZpGyrH3NiD52AC+Pg9phjhC3e7vh798LdeFOKghA/mEVEcCS?=
 =?us-ascii?Q?8Vv+NIeSjscVgQBJ5bHQya0iIPj6wg3vMFomYgt32Aa0OgsayvXZx4xguBt1?=
 =?us-ascii?Q?PP9NY8WQCYc7Y4RVXVFtsw+6TWsheyrdLNwEIrTrKPTKoQWpQ+r0ecup7JG4?=
 =?us-ascii?Q?kRKl5r3cUaDh1ueyy4zRRi/Gloi05yMFhbU6hYuyytjjouGn4wHPulvPo86M?=
 =?us-ascii?Q?CG5LxK4BVEFVzEXBc4arEiRQScZ2iFXzLRdHXOkZ/obo2Bc0vUd1UFWKjfEt?=
 =?us-ascii?Q?GNtA6NoheIkPfQRq0VqKYxYWnDB6bqzKKhkiBLa53PMCiucW5KNUSNI0RhNq?=
 =?us-ascii?Q?nvcrTeLqboGiuPI6hG/RNGveJVYkU2cBg+ERRCR8S7wuV/UJMFRIRnI5DIx1?=
 =?us-ascii?Q?qsiSQiT5IBy5RGIhos2U4MEn4n/W6sNdhaPrA8Nz4ApJZC0iUuRRhbzkgvqE?=
 =?us-ascii?Q?CelVqP6asdzUMxfzM6YpejQIW49tS/Ftc+aot3pn1b6Rgh3v6YRdSZI21Wo7?=
 =?us-ascii?Q?0FhfV3VfZtHWERNWjiS7bt+bJV0QRAPiYdiUXOVJ9jpzYl27S4eCZNIpmlCn?=
 =?us-ascii?Q?BCNAO9hPzqvXLgcC2tOl7KVzytDw4NHv2Cc0l+xEKZwLcKdynnFNZ53dBIW7?=
 =?us-ascii?Q?PUyjwaruj4/oRw1fQcXf/FqQjAU6zDczxrP/drlFRO2hff8O9SQetsdbkEg8?=
 =?us-ascii?Q?uOfkHOvAFABgZ5u5fU5lkQLtOrPE2H9v4cqkxRK10JPWhTYmszzSnSZCfC+j?=
 =?us-ascii?Q?P9CaBlNb+ict6lPY4hn2B2omZ46vc6TRWQRL5BPdlO2aLk4eEf+GiWkYtDNk?=
 =?us-ascii?Q?xBFXJ6iq3NCTY4nNIw42Tky4NsVUpK6A2mUS8VFI4WYJaKGiaHj1GGtRNneO?=
 =?us-ascii?Q?oGzQ9L8VqWfeWym5GGW2J0qGwZXeoJqcTsKzyORfiMNrU6svfP8WmQIYNCVn?=
 =?us-ascii?Q?+znmmTcFasriC7kh9FYAz2hLJMbFcNniuMwiGpYLooq6f+NznCWz1I09AWTW?=
 =?us-ascii?Q?Sdk48jRutSe7C2fTXMV0fovKL2iECpO9jOcw3Szh5dUDqneuJhvJ1SeeWcG2?=
 =?us-ascii?Q?N1lEh5dhBoU3D9OROINkey3nXStjIJn+zcGHh7RxjCW5Q43iqCE626j2/eXb?=
 =?us-ascii?Q?pQ3ml9k2VxXUgtihdGyEiREnr7ahR0SZsZlJWgFNdyhs3ecuimM7ITVDcBGR?=
 =?us-ascii?Q?6NGjnlzJ894/RukSjInkV56vA+WVYrrC+3ZvEei0yj/ZzsAPBBy+/3Q3DNkS?=
 =?us-ascii?Q?eqwgnyr3fbM7OIurKJh8O3I7o4CBmSXrF9pXTQ/QJ1WDPMlioEJdWUk48Cqp?=
 =?us-ascii?Q?HPMFQqP76swznn1JKYvkMoRhDqgnxzqKsZW17GmIU7spjfrO9OB2ht8AckD3?=
 =?us-ascii?Q?xqbIjOeKO1a69/CrPhzmSxIfLsmAsWwsI6IlAUWI66lD2eRSs2uARrs/AScM?=
 =?us-ascii?Q?TSbVRODGQi+hV2axDHgU0xSEqiG5WFCFVDv3rSt+Ad1ASwCnJrt8xRsFTqZp?=
 =?us-ascii?Q?jjbGFyPdRRhhhNNA6w8lDpmQImUUyHqVQIwS?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2025 06:12:18.2501
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 405a6434-36b4-4411-9222-08dd86e4cb98
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB56.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7271

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
Changes since v4:
 - No change.

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


