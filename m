Return-Path: <kvm+bounces-56403-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C557B3D899
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 07:21:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 114B63AB656
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 05:21:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94D722309B3;
	Mon,  1 Sep 2025 05:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="GfY362JX"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2060.outbound.protection.outlook.com [40.107.212.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 291AF15E90;
	Mon,  1 Sep 2025 05:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756704104; cv=fail; b=BdGhQqIqFoz2UFYbAKX0CLYWSq+t/mTc3z5Yel4NPmZ7uGD89MACWl8D6mrF1S3MhYZj0FRupL0GxIBwdfjaoRoz2r+D+j0hg1t2n5vF50hBTLPbtn1uZ16t8EMpo7HWlYXD1y1ujw94fWNGovgXkTmX+F8XZIEGVq7w3ZGznQ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756704104; c=relaxed/simple;
	bh=5UBxko9UbHibrH+Oid9Qohrclv1JZMecE5ab712qixg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qqgGZdk/0h50gxvdLjpP3TI0xy5o1WZurTcrLvqc+c9HS7IUrUTNJMOOXjt+wiBQQPVVu3wGqpLwRszWwLejbYe0M9nQWD+obBT3DIiOc9attYZ5/7kaZHiuvk6jwVdDG2vjARD4vLTlrx5WeWj6b5eBlYFF6ZLSynaT0CmKv/w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=GfY362JX; arc=fail smtp.client-ip=40.107.212.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IK7RKXFN6L3QuDccz2/lPSQLSFYaZ/4QH7JF1LXsshkoWMxvyn4qG8+9BngzmIk4gAX2ghaCyD3PO4hRH/94mKh1ch7c5qYl3/KX9WsFHdxrSFxOmfyy03YdhKkNRPjeg/WoOyTOfXM0xfQqoXa86XZJ/rEQ0X/sxlMN0Ousx9KqPN9bdZcZEf7GOwIc/Owygn9J05Qar27KTUIJjx3JZLS5pf6xSD5rbFH3Lde5NIiWIDqXbBsfx+dQmsJPx58x+MtDXCWo3MC4NJeZaQE9U1D2CJqfCV29+sSXViizXrpQxfD5MfEiwujSTNcSXf97oqwhqnV0kkdFYZTGdELblg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EZSWP+9Dtenlrp31Mc7L9/o3mC2hEA2xesxLPQxpHZQ=;
 b=Xej/SlKMnYzP8zYWwgIZXCxn4iHktBMe1lCyHGW1cbRn+kb0eLAUXBh0giKRIcZOiuVLWqN+IR/xNFSiLJiqBwaClLVLmqSMZLBIaXwQl3wW5Mr530RjoQzyH3LhGAJM4+ZNlfBrCu78nJgay34QDteFoLUdj0GGfc6nNXMiwt6/Sgtw3Uzq0V7l3rgiYxd6Wf+hOj2KqaagMvtJf9p/M7hamQ8Y7GUeVDmYlWeZdaTeaXXEw4e5Ntaxv9zJRwPSJGxb6HwmSEu0fvHZCIs1tgGR/aHDhvlKdHKxgV/lwZomX+MF5iz1/vO2WfpdsAGxk54CJkWPibYsaQUls+nxvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EZSWP+9Dtenlrp31Mc7L9/o3mC2hEA2xesxLPQxpHZQ=;
 b=GfY362JXB4Xis2AGnx/jKeXoGICq7Fm1LSexrUaqbhSwc3lR/ENGONuKLEtI1rXT8Ye+xUMZrG11gHTa6tOZ4PXerMkUovAcn7rCqqObk68XDEJDyNbsV4dVB102EPG9+7wOUAR3OVgQMKk6xVOg04KCLbq1ZXDu0aKGO7ZSRjM=
Received: from BYAPR21CA0010.namprd21.prod.outlook.com (2603:10b6:a03:114::20)
 by LV8PR12MB9420.namprd12.prod.outlook.com (2603:10b6:408:200::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.25; Mon, 1 Sep
 2025 05:21:38 +0000
Received: from SJ5PEPF000001D1.namprd05.prod.outlook.com
 (2603:10b6:a03:114:cafe::66) by BYAPR21CA0010.outlook.office365.com
 (2603:10b6:a03:114::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.4 via Frontend Transport; Mon, 1
 Sep 2025 05:21:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001D1.mail.protection.outlook.com (10.167.242.53) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.14 via Frontend Transport; Mon, 1 Sep 2025 05:21:37 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 1 Sep
 2025 00:21:36 -0500
Received: from BLR-L-MASHUKLA.amd.com (10.180.168.240) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Sun, 31 Aug
 2025 22:21:32 -0700
From: Manali Shukla <manali.shukla@amd.com>
To: <kvm@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
	<linux-doc@vger.kernel.org>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>,
	<manali.shukla@amd.com>, <bp@alien8.de>, <peterz@infradead.org>,
	<mingo@redhat.com>, <mizhang@google.com>, <thomas.lendacky@amd.com>,
	<ravi.bangoria@amd.com>, <Sandipan.Das@amd.com>
Subject: [PATCH v2 02/12] KVM: x86: Refactor APIC register mask handling to support extended APIC registers
Date: Mon, 1 Sep 2025 10:51:18 +0530
Message-ID: <20250901052118.209133-1-manali.shukla@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250901051656.209083-1-manali.shukla@amd.com>
References: <20250901051656.209083-1-manali.shukla@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D1:EE_|LV8PR12MB9420:EE_
X-MS-Office365-Filtering-Correlation-Id: 1cfdbf85-21b7-442d-a9cd-08dde9176cb5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0vBxXfEMPaA/ZgXRWsXWnCVCIl9Fz6S4D+IxnWxPL6cesafxTKZ2H66pVr1G?=
 =?us-ascii?Q?7TXLTahCDoFPQf7fqVOA1xt4QHok36mHZ7ApwgHLTXXP9YhBJtGmMzZW0Aw8?=
 =?us-ascii?Q?5Qbq7k6CmLMnvweKCfv2xkV7CJEqCHFiUK+mWLDAHuhrHwRtAc+WuDXNKBR7?=
 =?us-ascii?Q?gAozqsLcSgE4Xz0+QkEpx8ZsNHZ+3GOzQvfVV+R4+5YVM1U3jXR08DC2dL9F?=
 =?us-ascii?Q?7O4vHt0uZtJ65Xg0AHP0ITZnDrC+NLfDnaFV1dlxu3kPBVL+oQ0iFwXcx4cK?=
 =?us-ascii?Q?WrKJDJZOMYAQvDMgHE39VnxuPIwRxj+0GTyxxZJH9NZeIn3HrBnYP6DZOeli?=
 =?us-ascii?Q?nJ1ws5U7ESRco76OI+AOFdDLv8i4++FWUuJ67UNmdKdcgdb++TaqjIHnEH4g?=
 =?us-ascii?Q?MpU2yRlqHk/uyDrncasMYrRsNduqN2x2yQjivReWMjO1QnQhSyMRRzILMngt?=
 =?us-ascii?Q?oK+X/yYpv/oBd+52Q/IO+zo38Vi9VJWM02ieBTbb2HijymHjd/soDrCS3NmK?=
 =?us-ascii?Q?iCc2lRWWDFz3NWQ23XFeuPIRTsVeCei4hkzAdBMpV9HYz+WHV3xEJLhjHs0q?=
 =?us-ascii?Q?Lr0/mG48spuAe0XZRPqlTj/boKcbGJDK3phvwd8R/rWi2u7JvwBiJP0FAxhJ?=
 =?us-ascii?Q?+hT0PQ0YoWlkeo1wS/2oq4VUn+gxI2juojWB8xSCPLyc2Dqumko1Sv11Gs4M?=
 =?us-ascii?Q?rOjMrs3YSb4rL/y2uskJz+IobTUpySlsnI+19q9C5B5dy7r6NNc72O9Z8IuP?=
 =?us-ascii?Q?/smguQirhExJsNWo5C9KklzlSax2T2bLvXs/wnZq/wJfpg+4NzQYkCy5a+Wm?=
 =?us-ascii?Q?DpPiedq8iiBfeM7KSM9P0ENyJLZzlwXDnWLLXJJpKpiG9oeIxozyUedtC4/G?=
 =?us-ascii?Q?ReOADw7T51jkg8oNfHGZGjKraZ98j6H/cfN6lKwSx3TNBo5JgqrvtQHVrbkp?=
 =?us-ascii?Q?MLfecu+TLU/c9INlXouQFzSUpjdzAXyZFyA35np2QVFP1p9cRSC266abzOe8?=
 =?us-ascii?Q?ITeMmh/3+krAq6Bkl2eysMUtm1N4Ma23eu3TTHuJtJ9B6pvM7RaFnefCsDyD?=
 =?us-ascii?Q?L0tWrWjlXxGuuI7eYswyNDtb/WIXe/IXIVcJEqEAsDNDJFMXGLTONRRWkB4P?=
 =?us-ascii?Q?tGtKRJoGskmRidLDy9gjb64of22rEQp9o3udEZWCXGfZkwTQKnF8dDTG+zoj?=
 =?us-ascii?Q?4NrYUkU4GjPJwVePJ29DR3XAlZGDPPixDgQED68zLq/OggkFNLZkracxPv0X?=
 =?us-ascii?Q?Gb+L6mDRqTI/dQek8Qq6qacSXZHx8Z4AnAO2xrlUAnN2B4VVT3JMrEG2ieIP?=
 =?us-ascii?Q?i+rIRJ+XnXK0fM2Sb1snltgDJ0HmEsLAv4Kl8VCdl/apI5j3etzJBxiForM/?=
 =?us-ascii?Q?cpNmCI3VGgA8QuroijjaW6qlLKIA/yiTIbw0j7q8XLN77uaNxx0GjOfb2Jfx?=
 =?us-ascii?Q?ylCZr3WSCNzqwOQ2ebL2n5JyKiOh5jYdy6ALaIH3KT0xxAPNgqylF3pIBjm0?=
 =?us-ascii?Q?97rBoeBDYDjGtGjGZxukkAuUkVJvX3zR+Rhs?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2025 05:21:37.2502
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cfdbf85-21b7-442d-a9cd-08dde9176cb5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9420

Modify the APIC register mask infrastructure to support both standard
APIC registers (0x0-0x3f0) and extended APIC registers (0x400-0x530).

This refactoring:
- Replaces the single u64 bitmask with a u64[2] array to accommodate
  the extended register range(128 bitmask)
- Updates the APIC_REG_MASK macro to handle both standard and extended
  register spaces
- Adapts kvm_lapic_readable_reg_mask() to use the new approach
- Adds APIC_REG_TEST macro to check register validity for standard
  APIC registers and Exended APIC registers
- Updates all callers to use the new interface

This is purely an infrastructure change to support the upcoming
extended APIC register emulation.

Suggested-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 arch/x86/kvm/lapic.c   | 99 ++++++++++++++++++++++++++----------------
 arch/x86/kvm/lapic.h   |  2 +-
 arch/x86/kvm/vmx/vmx.c | 10 +++--
 3 files changed, 70 insertions(+), 41 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index e19545b8cc98..f92e3f53ee75 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1587,53 +1587,77 @@ static inline struct kvm_lapic *to_lapic(struct kvm_io_device *dev)
 	return container_of(dev, struct kvm_lapic, dev);
 }
 
-#define APIC_REG_MASK(reg)	(1ull << ((reg) >> 4))
-#define APIC_REGS_MASK(first, count) \
-	(APIC_REG_MASK(first) * ((1ull << (count)) - 1))
-
-u64 kvm_lapic_readable_reg_mask(struct kvm_lapic *apic)
-{
-	/* Leave bits '0' for reserved and write-only registers. */
-	u64 valid_reg_mask =
-		APIC_REG_MASK(APIC_ID) |
-		APIC_REG_MASK(APIC_LVR) |
-		APIC_REG_MASK(APIC_TASKPRI) |
-		APIC_REG_MASK(APIC_PROCPRI) |
-		APIC_REG_MASK(APIC_LDR) |
-		APIC_REG_MASK(APIC_SPIV) |
-		APIC_REGS_MASK(APIC_ISR, APIC_ISR_NR) |
-		APIC_REGS_MASK(APIC_TMR, APIC_ISR_NR) |
-		APIC_REGS_MASK(APIC_IRR, APIC_ISR_NR) |
-		APIC_REG_MASK(APIC_ESR) |
-		APIC_REG_MASK(APIC_ICR) |
-		APIC_REG_MASK(APIC_LVTT) |
-		APIC_REG_MASK(APIC_LVTTHMR) |
-		APIC_REG_MASK(APIC_LVTPC) |
-		APIC_REG_MASK(APIC_LVT0) |
-		APIC_REG_MASK(APIC_LVT1) |
-		APIC_REG_MASK(APIC_LVTERR) |
-		APIC_REG_MASK(APIC_TMICT) |
-		APIC_REG_MASK(APIC_TMCCT) |
-		APIC_REG_MASK(APIC_TDCR);
+/*
+ * Helper macros for APIC register bitmask handling
+ * 2 element array is being used to represent 128-bit mask, where:
+ * - mask[0] tracks standard APIC registers (0x0-0x3f0)
+ * - mask[1] tracks extended APIC registers (0x400-0x530)
+ */
+
+#define APIC_REG_INDEX(reg)	(((reg) < 0x400) ? 0 : 1)
+#define APIC_REG_BIT(reg)	(((reg) < 0x400) ? ((reg) >> 4) : (((reg) - 0x400) >> 4))
+
+/* Set a bit in the mask for a single APIC register. */
+#define APIC_REG_MASK(reg, mask) do { \
+	(mask)[APIC_REG_INDEX(reg)] |= (1ULL << APIC_REG_BIT(reg)); \
+} while (0)
+
+/* Set bits in the mask for a range of consecutive APIC registers. */
+#define APIC_REGS_MASK(first, count, mask) do { \
+	(mask)[APIC_REG_INDEX(first)] |= ((1ULL << (count)) - 1) << APIC_REG_BIT(first); \
+} while (0)
+
+/* Macro to check whether the an APIC register bit is set in the mask. */
+#define APIC_REG_TEST(reg, mask) \
+	((mask)[APIC_REG_INDEX(reg)] & (1ULL << APIC_REG_BIT(reg)))
+
+#define APIC_LAST_REG_OFFSET		0x3f0
+#define APIC_EXT_LAST_REG_OFFSET	0x530
+
+void kvm_lapic_readable_reg_mask(struct kvm_lapic *apic, u64 mask[2])
+{
+	mask[0] = 0;
+	mask[1] = 0;
+
+	APIC_REG_MASK(APIC_ID, mask);
+	APIC_REG_MASK(APIC_LVR, mask);
+	APIC_REG_MASK(APIC_TASKPRI, mask);
+	APIC_REG_MASK(APIC_PROCPRI, mask);
+	APIC_REG_MASK(APIC_LDR, mask);
+	APIC_REG_MASK(APIC_SPIV, mask);
+	APIC_REGS_MASK(APIC_ISR, APIC_ISR_NR, mask);
+	APIC_REGS_MASK(APIC_TMR, APIC_ISR_NR, mask);
+	APIC_REGS_MASK(APIC_IRR, APIC_ISR_NR, mask);
+	APIC_REG_MASK(APIC_ESR, mask);
+	APIC_REG_MASK(APIC_ICR, mask);
+	APIC_REG_MASK(APIC_LVTT, mask);
+	APIC_REG_MASK(APIC_LVTTHMR, mask);
+	APIC_REG_MASK(APIC_LVTPC, mask);
+	APIC_REG_MASK(APIC_LVT0, mask);
+	APIC_REG_MASK(APIC_LVT1, mask);
+	APIC_REG_MASK(APIC_LVTERR, mask);
+	APIC_REG_MASK(APIC_TMICT, mask);
+	APIC_REG_MASK(APIC_TMCCT, mask);
 
 	if (kvm_lapic_lvt_supported(apic, LVT_CMCI))
-		valid_reg_mask |= APIC_REG_MASK(APIC_LVTCMCI);
+		APIC_REG_MASK(APIC_LVTCMCI, mask);
 
 	/* ARBPRI, DFR, and ICR2 are not valid in x2APIC mode. */
-	if (!apic_x2apic_mode(apic))
-		valid_reg_mask |= APIC_REG_MASK(APIC_ARBPRI) |
-				  APIC_REG_MASK(APIC_DFR) |
-				  APIC_REG_MASK(APIC_ICR2);
-
-	return valid_reg_mask;
+	if (!apic_x2apic_mode(apic)) {
+		APIC_REG_MASK(APIC_ARBPRI, mask);
+		APIC_REG_MASK(APIC_DFR, mask);
+		APIC_REG_MASK(APIC_ICR2, mask);
+	}
 }
 EXPORT_SYMBOL_GPL(kvm_lapic_readable_reg_mask);
 
 static int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
 			      void *data)
 {
+	unsigned int last_reg = APIC_LAST_REG_OFFSET;
 	unsigned char alignment = offset & 0xf;
 	u32 result;
+	u64 mask[2];
 
 	/*
 	 * WARN if KVM reads ICR in x2APIC mode, as it's an 8-byte register in
@@ -1644,8 +1668,9 @@ static int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
 	if (alignment + len > 4)
 		return 1;
 
-	if (offset > 0x3f0 ||
-	    !(kvm_lapic_readable_reg_mask(apic) & APIC_REG_MASK(offset)))
+	kvm_lapic_readable_reg_mask(apic, mask);
+
+	if (offset > last_reg || !APIC_REG_TEST(offset, mask))
 		return 1;
 
 	result = __apic_read(apic, offset & ~0xf);
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 8b00e29741de..a07f8524d04a 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -147,7 +147,7 @@ int kvm_hv_vapic_msr_read(struct kvm_vcpu *vcpu, u32 msr, u64 *data);
 int kvm_lapic_set_pv_eoi(struct kvm_vcpu *vcpu, u64 data, unsigned long len);
 void kvm_lapic_exit(void);
 
-u64 kvm_lapic_readable_reg_mask(struct kvm_lapic *apic);
+void kvm_lapic_readable_reg_mask(struct kvm_lapic *apic, u64 mask[2]);
 
 static inline void kvm_lapic_set_irr(int vec, struct kvm_lapic *apic)
 {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4a4691beba55..b13a20c9787e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4032,10 +4032,14 @@ static void vmx_update_msr_bitmap_x2apic(struct kvm_vcpu *vcpu)
 	 * through reads for all valid registers by default in x2APIC+APICv
 	 * mode, only the current timer count needs on-demand emulation by KVM.
 	 */
-	if (mode & MSR_BITMAP_MODE_X2APIC_APICV)
-		msr_bitmap[read_idx] = ~kvm_lapic_readable_reg_mask(vcpu->arch.apic);
-	else
+	if (mode & MSR_BITMAP_MODE_X2APIC_APICV) {
+		u64 mask[2];
+
+		kvm_lapic_readable_reg_mask(vcpu->arch.apic, mask);
+		msr_bitmap[read_idx] = ~mask[0];
+	} else {
 		msr_bitmap[read_idx] = ~0ull;
+	}
 	msr_bitmap[write_idx] = ~0ull;
 
 	/*
-- 
2.43.0


