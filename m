Return-Path: <kvm+bounces-42303-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DDF60A779B1
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 13:38:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 84E233A6F85
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 11:37:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BFFC1FBC8B;
	Tue,  1 Apr 2025 11:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="um3vIW2z"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2078.outbound.protection.outlook.com [40.107.220.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 422031FAC4B;
	Tue,  1 Apr 2025 11:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743507450; cv=fail; b=L7AYBqYQYj8VOyr3i0t3n50Z/G1EjAMOkJ1rnAUqYa8I+Q8uV6Gn7LOulVzGKIuKEeQ1cSJNlhhBcBjI7D+sNb8OPx2EcSkEcjlY/xqdA14UgwZKG3wIX1BU4JK0594GEEyF2gVURgBqGcaqHh6YXV4voWoeNi4VNI0xEKon2ts=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743507450; c=relaxed/simple;
	bh=buAPPxnR5ltY4moHHmzFJdL3RlP7VfG6PimeMB9F5b4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hUkugvKvtlRme4Q3qJ3ZQ7LfYmt3emoz5fMQzt/u4lStFeYKcAtySjDB7GUWMrOX3rRebNA2SxZ/jOOBOg1g7iX3KxE3cH5RagE4Sr0fDa8/I8DMBRB9M2aA97XYa8gX+RSFs/E2dgvrMkhKDI+94Y8bn+g+QyjYUVYNgljxzDQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=um3vIW2z; arc=fail smtp.client-ip=40.107.220.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OK45RC6/u6DFldDIWWryMeaETmph8l3fKbUPz6ZW53XMMKteqb2mQND4AJYpQDgf89uhkAdBp4tkLRxYO/R25ka/RxeAGd9vddZ/1SOZb18m9AhkrLXARVXLXNqovOfLvy60udoQPoGNPwqqbIj9sNpUTduNA7asy/RQDZ/LePaC0hNJ99FyUG8LHgnWGmwGzIP/gOvSq4WWXW22Mxkt/8gVJYDxnj1FXJ3Hi33vu6Ha9AT2DUwviNviQ2TSVtY6gV0FztGF1nsiDhzzf5oDTzGE39NH9czE2SX9fEFdBvOr5LeReVRUD6e8FRjL8Gza0u9yCCZlZBRf8/+l7S0N8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dniIq7l5ASxMpqaOqFnXHj0AvOZ2M9HmXy7NiqVxLzw=;
 b=UNozzfHCFnRaVCQy6Fbv4GY3Rz+94aGP0XZ9EPsrgrVWQdKKQW+zTkFGWRyHLiczJZUaaPH2SyjEXiHeOinVd1NRltS1iPRCfAe0YLWRiQ6CB2P7CRw8CAK2hDVAGxZ45NhXIRVpuyx4xtRsQ9CdV+8d4omr8Lny/745M7ao4vJ6aMw1ZjW8ddxZExx0BC8G8ij8zb7qkpKmUdhz65/VNZ1vvg2FfjV2fTO1Y0yREDBJTgxW6Uyu/BCqMZyJkpnIrFRE4L7Qx+fz0jGpfz1PQhuxS3EGrrkQFPNdCNsOk4Az54GCfYM1pJE9/f9Ec5BGujseQq1M98fLZGCmiricCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dniIq7l5ASxMpqaOqFnXHj0AvOZ2M9HmXy7NiqVxLzw=;
 b=um3vIW2zJVSGRW6lhLh7mMemroAchR4XWu2pEAn+9Q/9dYZotvdn/YA9heNlICjA4m1VfZlHFIaKjxpjg9UwRUCRArs9fOETr8RNFmy83ZLtOzflpHk46RthE7txsyuA6alOJtbBk0Rbq9YDrA+/qVVyn9quO8OhW1tH6Skt7gQ=
Received: from SJ0PR13CA0074.namprd13.prod.outlook.com (2603:10b6:a03:2c4::19)
 by DM4PR12MB6183.namprd12.prod.outlook.com (2603:10b6:8:a7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Tue, 1 Apr
 2025 11:37:25 +0000
Received: from CO1PEPF000044FD.namprd21.prod.outlook.com
 (2603:10b6:a03:2c4:cafe::91) by SJ0PR13CA0074.outlook.office365.com
 (2603:10b6:a03:2c4::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8606.20 via Frontend Transport; Tue,
 1 Apr 2025 11:37:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044FD.mail.protection.outlook.com (10.167.241.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8632.2 via Frontend Transport; Tue, 1 Apr 2025 11:37:25 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 1 Apr
 2025 06:37:19 -0500
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
Subject: [PATCH v3 03/17] x86/apic: Populate .read()/.write() callbacks of Secure AVIC driver
Date: Tue, 1 Apr 2025 17:06:02 +0530
Message-ID: <20250401113616.204203-4-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250401113616.204203-1-Neeraj.Upadhyay@amd.com>
References: <20250401113616.204203-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044FD:EE_|DM4PR12MB6183:EE_
X-MS-Office365-Filtering-Correlation-Id: dbddda17-e6f2-4bee-4270-08dd71119309
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|1800799024|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JYN1sb6n5hB08LVhtNby1vq+R245GtkpqgTEyZq807GV20TDgkrgRDEy19f2?=
 =?us-ascii?Q?KF4T0xDX5TriiMfXk+N7a/e+HFZvlt7YamYlCkgBJmBOol6dQ6Xx1FGWvN6P?=
 =?us-ascii?Q?LmfmCERgMRv1/4L5pBmZ9J1NW+1LwWC20QRoyF91QP1hT2Cvq+ax6PJtRSGk?=
 =?us-ascii?Q?bmaf9tNFR3c7ZWNIoCHGUFQlFbYZ7QzIz2vIfKTzo6QNI2nggQ4fbpDnFVPg?=
 =?us-ascii?Q?1TJXEozrE3cBSL7nofbOFgn+cH6fq3ab/o2uI+PMCpFmk8R7Kl78fywnMgS5?=
 =?us-ascii?Q?+Mefx4ShrpaRM3yUMaHblv0RZJDPyE5IHFRRJ7hrzrE8XAoE+xRdCKBcqdL2?=
 =?us-ascii?Q?Ud3H9PIaksoYv4lH1hYpPCT7qSRh27NiAmvfBeD7C8v6wpAXQ1Che/+58aj2?=
 =?us-ascii?Q?VxBNUwuJ2NJxzOU7hEAFVDm9enk2SVWIihva3wkspbCF2UUMdYyKmeYpSsVv?=
 =?us-ascii?Q?BONW3nEsHxbCoJ/wla63rDBgfOfpSbbViMM6CUkXvZO0JCeF9H5/3oqGCI2J?=
 =?us-ascii?Q?wE0IAI7S7isdKDwnlbAzzLVlwX5EmEii4t2EKLgUouPUvYA/i8kcYQKCxkzz?=
 =?us-ascii?Q?HT0V3c3YEWNQqrxXtulGpo1i4nDYVo7O6byoPZYF2cgnrMLm12gg4YTgIEkx?=
 =?us-ascii?Q?e9e99jOofmUWboY/0KfVRNf3jvjKiXLcJdh8/IfFzK57i/4aG+sN0Kss9hw4?=
 =?us-ascii?Q?SFUB4+lnX4SjnmaRUePa7O/cZKgu0VJQWMOjiyVZRIp0EucD+54u+XHyBFfC?=
 =?us-ascii?Q?OjjG7cC/bIPIU6LtcRGE8B2RJ4R3OsPYciXzVXjb1w98QdkpEf0cst7AGbSz?=
 =?us-ascii?Q?3kw5MCoDTijuU2+0Wf6hXVnLKKdbUPDyPovazHWoqecAPIMRFfncUbGqDrMC?=
 =?us-ascii?Q?sjNWrBcm7NJCp6VgM913RDO1RqNaKIVAwqXp7aH+ZDgjE9xBQB4jMLBl7UAE?=
 =?us-ascii?Q?oszhBn7T6PzjhmjmmG6kxQfO3uBgc/99A2MyzkPe75TM0zyurZE+BpEDuriz?=
 =?us-ascii?Q?P6JOTVuBs7siuwjzfci8JHsoUPTUZwdnlwPX0C5bkZ0YnjB4Rc4fuMtx7GW8?=
 =?us-ascii?Q?W8DoCQgeUrkOgoJNJ0qWmf7jrNcsyIXigvwTuLhJxuvmnQnis5aWIao5ZNu8?=
 =?us-ascii?Q?ErFyCMm2eACEw+J7cBJEYDGmSD8scRwDTUY4bkZWxd4SSwoPNNYBOHDOENPc?=
 =?us-ascii?Q?HRJE7XN1/Djn9C5eqvbmChUL3s1e08Uup7ozcZEqbdRZYoOR3Kb3dCGMFo4W?=
 =?us-ascii?Q?tIZYKQzkXlmXHDEgEq+L1YtU6cb32BW9DIMqlh9G15QK+BLY0Au6kIBqZQ4K?=
 =?us-ascii?Q?vsh6X9g07KCHpwEvEUNe4ZCYrmho5pnbqU7F6DFgCaYnRukTKaKu0R+qs/VE?=
 =?us-ascii?Q?3CF3EE/YMczvwyhBqzM0B5aiMFFDp2GfK61weRrUR6TEdAc1Jmzn/AnNPiYc?=
 =?us-ascii?Q?STskGJ1NUdpt4dgPRZvKLfsY/KBCryj8alxiGv5F3YTjCuTJCije2uwVLaj4?=
 =?us-ascii?Q?+JO0/MCHvZ8/tG8=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(1800799024)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2025 11:37:25.0163
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dbddda17-e6f2-4bee-4270-08dd71119309
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044FD.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6183

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
Changes since v2:
 - Use this_cpu_ptr() instead of type casting in get_reg() and
   set_reg().

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
index 44a44fe242bf..f1dd74724769 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -10,6 +10,7 @@
 #include <linux/cpumask.h>
 #include <linux/cc_platform.h>
 #include <linux/percpu-defs.h>
+#include <linux/align.h>
 
 #include <asm/apic.h>
 #include <asm/sev.h>
@@ -33,6 +34,117 @@ static int x2apic_savic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
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
+static u32 x2apic_savic_read(u32 reg)
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
+static void x2apic_savic_write(u32 reg, u32 data)
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
 static void x2apic_savic_send_ipi(int cpu, int vector)
 {
 	u32 dest = per_cpu(x86_cpu_to_apicid, cpu);
@@ -141,8 +253,8 @@ static struct apic apic_x2apic_savic __ro_after_init = {
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


