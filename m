Return-Path: <kvm+bounces-42313-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DDFD0A779C3
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 13:41:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8A910166FA2
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 11:41:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA0111FBCB1;
	Tue,  1 Apr 2025 11:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="U0J+MBZi"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2086.outbound.protection.outlook.com [40.107.92.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C181F03EC;
	Tue,  1 Apr 2025 11:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743507648; cv=fail; b=QIWE8bJ85MwQx9HSZBNuk8cB5SyuNZXLqaMZ6eDlZN1K4LQ2pHkCr0b2JWTGyy09SOsMiHkyU4SLrps8Evj8cHBGe6SG44r8C2qZt1/TT8Dyq9rqGKHIXr8mFEE2eXeSW72bxc+t2EDxpghzXHi1x+gphX43DDiDLMeVbs7vFH4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743507648; c=relaxed/simple;
	bh=j45KukHnrCXDwEqZwIHp0LT592etLkeFjJo1Cv23Uss=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B9NxEWws26QjGegcnZ7HLQlUqrUXPklYVi9gTyE7iXnvX0e5hXrSDukv3sM596sO2oB65+r27EcUqMA1P56k4//cYuaU2sk4ReTuPtigDhgWWmmdhL4cr5oeOmglvRb1BGQTs4/HZ5lArjf5OfXeoe21ksOW4eGxKowI47jDLlE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=U0J+MBZi; arc=fail smtp.client-ip=40.107.92.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IlhByEGqRBrFJxnJA8lOmubGIH0TvBJJnuvyMRC1+Ay0hi+SsFjfsmihRFD6BKA0YVeX8i3bkBhYMgJrPeQXhQEyL6+VwBj91Fn5HA9bf5CuBLcUlKzA5OVZdDDFoTZuAzoztbvZ5D67Gpj8+WquotaQry4SS9skq3N0FsaCkNxJZUX3e4MtWeJo4kT4szUa873YIjKDpVnWQn25US9AY7WIqG4XJIU3vkD9cc449aUKIMlRsYMwW9UnKYm/wrQBRH1G2Q3+5Lvs5R6zpS1YkKByIpxvDrdJOdvACWCGwaGcZN3jmaa0DHMgWcZKAr4koE0p+MsrBX+FmCScdYI1EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OqYeoKzXKpg0THxeVdKhgK0yotvM5Eyjv4tZOKTQ9to=;
 b=CrAmITfy8BBZJfCNB2A/PnzI0+w42lWkdILzKwMTTKompTgyEeBUhHrST/J2obwLGYDWEIA9cs9k75v4XY+NIq/04OHsztV20M5+m/4KIw/q0yIlGbwYbr7Qa48yypw0NrCKG7dPynMy7QNag872zFEwguK5FRLS7KG1cDqHjMppmb07YE+fgIa/MdMO0ulqgluMWnpLc5bmr0XXNVd+CONRMxVpiEnnkTTwbpRERKextt9pLjgnUcjbF+1TrmaTvpmv57uCmRL/+CeqmzZ/TQePxM5z0IsvgLvd4S0X+rdcNGpXgluXleX8RGt8RxktWvVljRAmWABwe6oRhZp8ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OqYeoKzXKpg0THxeVdKhgK0yotvM5Eyjv4tZOKTQ9to=;
 b=U0J+MBZiwJuwGw6d7/vlEHLm0tegETIDzLE3VtFJrAsLMz3ezhJBLzvNc9i9vntr7XSUmhoLKW6mm+9lUHgi09yHQC+VC6qO9Y7HCNdVMN47VNxabdAQae3K/9Wd2n0jGdFnlVeIY9/4oJAPtB8y1MAdBIKPaUMFoju0QwS1N+Q=
Received: from MW4P220CA0022.NAMP220.PROD.OUTLOOK.COM (2603:10b6:303:115::27)
 by PH7PR12MB6417.namprd12.prod.outlook.com (2603:10b6:510:1ff::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Tue, 1 Apr
 2025 11:40:38 +0000
Received: from CO1PEPF000044FB.namprd21.prod.outlook.com
 (2603:10b6:303:115:cafe::d9) by MW4P220CA0022.outlook.office365.com
 (2603:10b6:303:115::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8583.37 via Frontend Transport; Tue,
 1 Apr 2025 11:40:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044FB.mail.protection.outlook.com (10.167.241.201) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8632.2 via Frontend Transport; Tue, 1 Apr 2025 11:40:38 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 1 Apr
 2025 06:40:32 -0500
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
Subject: [PATCH v3 13/17] x86/apic: Handle EOI writes for SAVIC guests
Date: Tue, 1 Apr 2025 17:06:12 +0530
Message-ID: <20250401113616.204203-14-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044FB:EE_|PH7PR12MB6417:EE_
X-MS-Office365-Filtering-Correlation-Id: 739254bd-ccba-4a5f-b81c-08dd71120674
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?MhbJEm0DCQb6jQTWH0bzGp8izchTDFbjMs99TGlaNB//LXMBYpAhiabGBFvL?=
 =?us-ascii?Q?AiIlZUWQJuCuk5Ey9dEbQi7D3n9F+Lu9JWwY1QeOs3T3ADYvvLmOWFCyliCh?=
 =?us-ascii?Q?iKzgNDpIZVqmGSBDDUOqqDgOad7bnmfYjjEsx+JuzX8/EoO2OQ4v0bwP+GOT?=
 =?us-ascii?Q?W/w1HpcjnN4+iM7/L93H57LIHmgpyOYNS8q3P0uWoCuURpGbE5WrTFC7Ywto?=
 =?us-ascii?Q?T2jZoP45DOYSveKsNaGFYOJw1TmQM21zmqB159TsDO3u4IGuK9WbcTUWJJwO?=
 =?us-ascii?Q?CheZFHKPltSHZB4DC4VsZ0LSsnylLwSCDEqOc5/m6qslkkVV+dvn9QBvZ5rE?=
 =?us-ascii?Q?bOf/ITXK3YTcGlevml1KchYiyrVx2IwG7pa61edsMsKJrqKmbqPYd+zdVxo8?=
 =?us-ascii?Q?8Kj6mjktNA72I91LpPzipNBemEYYgYLvhA+YoOTeOcnreQO5av/zVPFdjFEa?=
 =?us-ascii?Q?P64G9/8rPL9UFQHq6d5dSNnPDBuo9cBa4JywLG2YKziq9RkDarLxHKiHM34H?=
 =?us-ascii?Q?VnI/czreygo5mEUrvLsUe8O+8bGDv0tq+Rnhk8ychLG2CQVDMc6dBHnAJqfy?=
 =?us-ascii?Q?8IoYXqmxwBqZKlfgvOF43NK3yZzMUE8Wz6tjZHMpc+9+5iGEjsMuYRPbnKLq?=
 =?us-ascii?Q?km3bWCI/Hij24JQZXe+GlIQlArM52yPmsDoNF4HAysWDJKWNyGFbD5TRu/OF?=
 =?us-ascii?Q?FO9Xtcrm2e6KCStSomjkoT83yGsJN1Z2F7H1wktyTdtSuxGX3cx2B6UgUdBM?=
 =?us-ascii?Q?L2y/y83MgMgUcbp/J6knLKFFRD8Ep+ae8mqeZ3jKUkTJSF/slAmMbXyJbSXL?=
 =?us-ascii?Q?fGvi0NF11tX3IbsvcqLLS6ZMuaROXJQWU3fqasjOmf2VNy96D749M58v/bKS?=
 =?us-ascii?Q?F9tF4FlC/fa0dKU0+LBoWxR8HDBkgc18haYoBpMR24SXZFlgdXz14BCak1jz?=
 =?us-ascii?Q?23S5VmtWgYj3QlP3wQZvYdaskIKMdeRzxZwVhrtTI5p7kYqBoQ+9CeeyXeca?=
 =?us-ascii?Q?yGlPTxbLRGEWZiRPUx8VRWfJgSquzDU/maU56CTDkuvdCEPPBDr7+lzq+BOh?=
 =?us-ascii?Q?cDEFL+98kszUnWq56wlf4BGE2wHB9GE3fJmrEcyuLeDI4yjQbvGvpV0sYlO0?=
 =?us-ascii?Q?oIKB8MNnc0aPM1PmZ4VRW3QHz2DgBiwiC+RsZC0uV9YSVpyw6qylRXXy0aMD?=
 =?us-ascii?Q?zu4ndNWZJbdYhRLet2DmX242bpdH9srL59mLzqLVyj+5ljIpeEjXdMh3YcIE?=
 =?us-ascii?Q?+7AaNEKUolhBLMGpwJtUwYnPQOAAwTj+DU+lG9FdGBDvr6lPWw9Y08PrB3Zb?=
 =?us-ascii?Q?KcZn/U6q5RvvJR0Rf+P9SahejgUcDwOxxK1EIZATqbzRwGNBdA5/vmGGCndR?=
 =?us-ascii?Q?QQnObCXwtfq14mxt5dA77n9yDN3g0fz439fFO6yXAPv0xUiFC8UUl6Q6cXFp?=
 =?us-ascii?Q?wHz5YmBQxaZs/D5NopTwqx5ObAojUKrvvhn5kWwnmaj8h0UIS9X6El4PK4Ci?=
 =?us-ascii?Q?ztB2cC23r3SqhSo=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2025 11:40:38.6569
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 739254bd-ccba-4a5f-b81c-08dd71120674
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044FB.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6417

Secure AVIC accelerates guest's EOI msr writes for edge-triggered
interrupts. For level-triggered interrupts, EOI msr writes trigger
VC exception with SVM_EXIT_AVIC_UNACCELERATED_ACCESS error code. The
VC handler would need to trigger a GHCB protocol MSR write event to
to notify the Hypervisor about completion of the level-triggered
interrupt. This is required for cases like emulated IOAPIC. VC exception
handling adds extra performance overhead for APIC register write. In
addition, some unaccelerated APIC register msr writes are trapped,
whereas others are faulted. This results in additional complexity in
VC exception handling for unacclerated accesses. So, directly do a GHCB
protocol based EOI write from apic->eoi() callback for level-triggered
interrupts. Use wrmsr for edge-triggered interrupts, so that hardware
re-evaluates any pending interrupt which can be delivered to guest vCPU.
For level-triggered interrupts, re-evaluation happens on return from
VMGEXIT corresponding to the GHCB event for EOI msr write.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v2:
 - Reuse find_highest_vector() from kvm/lapic.c
 - Misc cleanups.

 arch/x86/include/asm/apic-emul.h    | 28 +++++++++++++
 arch/x86/kernel/apic/x2apic_savic.c | 62 +++++++++++++++++++++++++----
 arch/x86/kvm/lapic.c                | 23 ++---------
 3 files changed, 85 insertions(+), 28 deletions(-)
 create mode 100644 arch/x86/include/asm/apic-emul.h

diff --git a/arch/x86/include/asm/apic-emul.h b/arch/x86/include/asm/apic-emul.h
new file mode 100644
index 000000000000..60d9e88fefc6
--- /dev/null
+++ b/arch/x86/include/asm/apic-emul.h
@@ -0,0 +1,28 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _ASM_X86_APIC_EMUL_H
+#define _ASM_X86_APIC_EMUL_H
+
+#define MAX_APIC_VECTOR			256
+#define APIC_VECTORS_PER_REG		32
+
+static inline int apic_find_highest_vector(void *bitmap)
+{
+	unsigned int regno;
+	unsigned int vec;
+	u32 *reg;
+
+	/*
+	 * The registers int the bitmap are 32-bit wide and 16-byte
+	 * aligned. State of a vector is stored in a single bit.
+	 */
+	for (regno = MAX_APIC_VECTOR / APIC_VECTORS_PER_REG - 1; regno >= 0; regno--) {
+		vec = regno * APIC_VECTORS_PER_REG;
+		reg = bitmap + regno * 16;
+		if (*reg)
+			return __fls(*reg) + vec;
+	}
+
+	return -1;
+}
+
+#endif /* _ASM_X86_APIC_EMUL_H */
diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 4adb9cad0a0c..9e2a9bdb0762 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -13,6 +13,7 @@
 #include <linux/align.h>
 
 #include <asm/apic.h>
+#include <asm/apic-emul.h>
 #include <asm/sev.h>
 
 #include "local.h"
@@ -49,20 +50,27 @@ static __always_inline void set_reg(unsigned int offset, u32 val)
 	WRITE_ONCE(this_cpu_ptr(apic_page)->regs[offset >> 2], val);
 }
 
-#define SAVIC_ALLOWED_IRR	0x204
-
-static inline void update_vector(unsigned int cpu, unsigned int offset,
-				 unsigned int vector, bool set)
+static inline unsigned long *get_reg_bitmap(unsigned int cpu, unsigned int offset)
 {
 	struct apic_page *ap = per_cpu_ptr(apic_page, cpu);
-	unsigned long *reg = (unsigned long *) &ap->bytes[offset];
-	unsigned int bit;
 
+	return (unsigned long *) &ap->bytes[offset];
+}
+
+static inline unsigned int get_vec_bit(unsigned int vector)
+{
 	/*
 	 * The registers are 32-bit wide and 16-byte aligned.
 	 * Compensate for the resulting bit number spacing.
 	 */
-	bit = vector + 96 * (vector / 32);
+	return vector + 96 * (vector / 32);
+}
+
+static inline void update_vector(unsigned int cpu, unsigned int offset,
+				 unsigned int vector, bool set)
+{
+	unsigned long *reg = get_reg_bitmap(cpu, offset);
+	unsigned int bit = get_vec_bit(vector);
 
 	if (set)
 		set_bit(bit, reg);
@@ -70,6 +78,16 @@ static inline void update_vector(unsigned int cpu, unsigned int offset,
 		clear_bit(bit, reg);
 }
 
+static inline bool test_vector(unsigned int cpu, unsigned int offset, unsigned int vector)
+{
+	unsigned long *reg = get_reg_bitmap(cpu, offset);
+	unsigned int bit = get_vec_bit(vector);
+
+	return test_bit(bit, reg);
+}
+
+#define SAVIC_ALLOWED_IRR	0x204
+
 static u32 x2apic_savic_read(u32 reg)
 {
 	/*
@@ -374,6 +392,34 @@ static int x2apic_savic_probe(void)
 	return 1;
 }
 
+static void x2apic_savic_eoi(void)
+{
+	unsigned int cpu;
+	int vec;
+
+	cpu = raw_smp_processor_id();
+	vec = apic_find_highest_vector(get_reg_bitmap(cpu, APIC_ISR));
+	if (WARN_ONCE(vec == -1, "EOI write while no active interrupt in APIC_ISR"))
+		return;
+
+	if (test_vector(cpu, APIC_TMR, vec)) {
+		update_vector(cpu, APIC_ISR, vec, false);
+		/*
+		 * Propagate the EOI write to hv for level-triggered interrupts.
+		 * Return to guest from GHCB protocol event takes care of
+		 * re-evaluating interrupt state.
+		 */
+		savic_ghcb_msr_write(APIC_EOI, 0);
+	} else {
+		/*
+		 * Hardware clears APIC_ISR and re-evaluates the interrupt state
+		 * to determine if there is any pending interrupt which can be
+		 * delivered to CPU.
+		 */
+		native_apic_msr_eoi();
+	}
+}
+
 static struct apic apic_x2apic_savic __ro_after_init = {
 
 	.name				= "secure avic x2apic",
@@ -403,7 +449,7 @@ static struct apic apic_x2apic_savic __ro_after_init = {
 
 	.read				= x2apic_savic_read,
 	.write				= x2apic_savic_write,
-	.eoi				= native_apic_msr_eoi,
+	.eoi				= x2apic_savic_eoi,
 	.icr_read			= native_x2apic_icr_read,
 	.icr_write			= x2apic_savic_icr_write,
 
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 28e3317124fd..8269af8666b8 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -27,6 +27,7 @@
 #include <linux/export.h>
 #include <linux/math64.h>
 #include <linux/slab.h>
+#include <asm/apic-emul.h>
 #include <asm/processor.h>
 #include <asm/mce.h>
 #include <asm/msr.h>
@@ -55,9 +56,6 @@
 /* 14 is the version for Xeon and Pentium 8.4.8*/
 #define APIC_VERSION			0x14UL
 #define LAPIC_MMIO_LENGTH		(1 << 12)
-/* followed define is not in apicdef.h */
-#define MAX_APIC_VECTOR			256
-#define APIC_VECTORS_PER_REG		32
 
 /*
  * Enable local APIC timer advancement (tscdeadline mode only) with adaptive
@@ -626,21 +624,6 @@ static const unsigned int apic_lvt_mask[KVM_APIC_MAX_NR_LVT_ENTRIES] = {
 	[LVT_CMCI] = LVT_MASK | APIC_MODE_MASK
 };
 
-static int find_highest_vector(void *bitmap)
-{
-	int vec;
-	u32 *reg;
-
-	for (vec = MAX_APIC_VECTOR - APIC_VECTORS_PER_REG;
-	     vec >= 0; vec -= APIC_VECTORS_PER_REG) {
-		reg = bitmap + REG_POS(vec);
-		if (*reg)
-			return __fls(*reg) + vec;
-	}
-
-	return -1;
-}
-
 static u8 count_vectors(void *bitmap)
 {
 	int vec;
@@ -704,7 +687,7 @@ EXPORT_SYMBOL_GPL(kvm_apic_update_irr);
 
 static inline int apic_search_irr(struct kvm_lapic *apic)
 {
-	return find_highest_vector(apic->regs + APIC_IRR);
+	return apic_find_highest_vector(apic->regs + APIC_IRR);
 }
 
 static inline int apic_find_highest_irr(struct kvm_lapic *apic)
@@ -779,7 +762,7 @@ static inline int apic_find_highest_isr(struct kvm_lapic *apic)
 	if (likely(apic->highest_isr_cache != -1))
 		return apic->highest_isr_cache;
 
-	result = find_highest_vector(apic->regs + APIC_ISR);
+	result = apic_find_highest_vector(apic->regs + APIC_ISR);
 	ASSERT(result == -1 || result >= 16);
 
 	return result;
-- 
2.34.1


