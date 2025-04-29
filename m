Return-Path: <kvm+bounces-44689-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 29A65AA029C
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 08:11:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 70E5D1B63804
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 06:11:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54726274FD2;
	Tue, 29 Apr 2025 06:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="YJX2vMjr"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2043.outbound.protection.outlook.com [40.107.94.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF2B12749E7;
	Tue, 29 Apr 2025 06:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745907048; cv=fail; b=mcdCOv2Di9+vdzW/etot9lHmWdYQz+e2gRfECQc8Ttpj6r6sOjeGepD4Jp3mKMB6wKKoSEpkOcLtht9EtYgcI/dEQzys5cyIM4cDme3O9z8zOtevqDZ2MZ1W/Hm3EXqVOYjuYqKGHXPGHIRuC86S6qR5A0PWel2Q1bjl9I1GsYg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745907048; c=relaxed/simple;
	bh=fUS6a3X/O4o5ZlFFjDZfEXjtWLGIOOxEIiyN25dgaPs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=szTQu90dnPh1YJARMFSA5E7sm1AnlYI2dvlxF0fxLER0CWy+aqeo4JbaQynqHamDJ/AsvJk35EKXj+NkCxytlYD98FRp+dc5Z27f4iMPGJpPNQUefV+kBgZ7n9yakAm5mza5xD80qWqLxkjamOW/M3RIVbjUdDPJzOD5wLr3ToA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=YJX2vMjr; arc=fail smtp.client-ip=40.107.94.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HdFUe4+/LkpS2ujru/ojV8aafP2dRBVdoKafjWC10P7DgvILBj0yx9nrJ/odi0txSp7/Axy0qI3YoXIiYFiVxUng99bZb/QJRhnej5Ex3x4IbSpt/UIwR3VgpoqyZm1DvZQTIjNKShl6HHgEChnlpnonZgdCdbD13GwfpB5LgvB93mlYJ7uZmVeLJUafTx5bwuIhV7HEvveYVbmluXdhs8Q8nW91V+FtosIDW+K9hvJsAJSlVTrJ6icuTb8k1GKaMhPJ0PdU1JAo4jQl7kVQfgUESjGKmfYXzka/+7YOvjhUJPiIEcD6lJNh7IEDX4DADdBmczl+0G8Bf5O/r6mb5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/F4DJwp0V3reNt+0W7E+AjNDtBMP5ONLkcUvx/YuZSA=;
 b=xSp0Dri7I9vnQgnM4COFBweIzTFK4PHaUKgC6oiyFl6pYv+CKs6HwOnfsPkGrnrZc0QkBNwzKFF0T0+PcAc2mQsWs1DDdmme7Ti7oE4BD5KCmWxThPtVgtKmV3ZWkhwhmEQCqwKeeg1PMiu9CNNZig0QFWOFWAug+9qWbNAZHlp9QRyW3KJ2g5qqH6DW0SNN4F0IR7OI78u5C7uUGdXTNcMWFUVxxZVah+YxECo3Pt6wEuLqgAbeQQiVWARTlPwI1YRZkOTBwgi15uUTnMymqZOxUTAkivCj0Lk20sVj9mWQ6/Rbo2uBC18IK8VGWCcDCKx6IPcDgFLUseVGevjgkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/F4DJwp0V3reNt+0W7E+AjNDtBMP5ONLkcUvx/YuZSA=;
 b=YJX2vMjrWpiZc4yesJvXj/mIwwYgj6BgzveeX/eroVqeAm3bQ/7ETwgFbCcCAt2JYdYxdH6OsVMSV6tgLLvkysm8QXZKkzYfrm4m99Rw8QG+dOfl7FBFkYLDF93Jtt4dj5iuRwzUe939hXRsgOoO401+pwyrxptWrJTGzE8yL+8=
Received: from MN2PR12CA0019.namprd12.prod.outlook.com (2603:10b6:208:a8::32)
 by SN7PR12MB8102.namprd12.prod.outlook.com (2603:10b6:806:359::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.32; Tue, 29 Apr
 2025 06:10:44 +0000
Received: from BL6PEPF0001AB54.namprd02.prod.outlook.com
 (2603:10b6:208:a8:cafe::2d) by MN2PR12CA0019.outlook.office365.com
 (2603:10b6:208:a8::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.37 via Frontend Transport; Tue,
 29 Apr 2025 06:10:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB54.mail.protection.outlook.com (10.167.241.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8678.33 via Frontend Transport; Tue, 29 Apr 2025 06:10:43 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 29 Apr 2025 01:10:34 -0500
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
Subject: [PATCH v5 01/20] KVM: x86: Move find_highest_vector() to a common header
Date: Tue, 29 Apr 2025 11:39:45 +0530
Message-ID: <20250429061004.205839-2-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB54:EE_|SN7PR12MB8102:EE_
X-MS-Office365-Filtering-Correlation-Id: 929a1c69-9d25-4dd6-217d-08dd86e49340
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+uG1tZLM2PkpFm0zb1VelAm0nhTjbgwZTpELiAD17aR9l/Cf/eWRo9puqbfj?=
 =?us-ascii?Q?bQ5XYsxNEfSYpfCrzhYFst6qWkPjPGNPC/RPx1ATspABBB3xAnRuGuwhl6pz?=
 =?us-ascii?Q?KLOJFVyAEYyH6CRi7nGi4iYXHHYda1QnUjX/yH692uudZexCEOsq3BqTv5ni?=
 =?us-ascii?Q?MrAjS9pH0gFXJr6d6Icskh17fv7+ZBFQKyKYw2JMPcv1GR5N3CdC0GLz2nYd?=
 =?us-ascii?Q?75tgOEicMP4Apg54U4lxAvgBCwe3j83RHCMnSop0OENAnBWqBhGq7mhoL8vP?=
 =?us-ascii?Q?0vdN4KJRWmIWVG90OVZkgVQIqv9FF1jqqOEs1ZCfNApNO1Dgdma8Zsh2V4Dq?=
 =?us-ascii?Q?pNPfQmr0N/hivcowSi03Ktmpuu6kQxfFWeM/NMBKIr9PEfcDFb58Ac/JlcWq?=
 =?us-ascii?Q?Rqc2sZiRAzQKkeu/qd1PdnUQ+SoERGdnkWd2zpXcldUyeEaiRjSEVfqahkY1?=
 =?us-ascii?Q?u9zP3lt6YYcaExSDlxq+aBXO0SHRbFggaNZBukwku2XL/0gTPcHuveqQKty0?=
 =?us-ascii?Q?2O/qrV4hruq4bYjw1Qr1Mg4YQHkQD7HPUQX3qydclQx7ljsy8ra5GoJA+3xz?=
 =?us-ascii?Q?MgaD9DzEwE0OwYI1//VtmJGLzBOk0FBBWjH+kdB7d2AbUrxTdXPix2dlRtkt?=
 =?us-ascii?Q?qb3T5bAY69tCITSgpwkuJOC0iz3YqxUDAdt2N9elBD6oy+AJZ4lLt8MMxP2V?=
 =?us-ascii?Q?ztjznTjsRHeKhbBJPUgurL4A9w7SyOz99GCw1QY0z4yLtPbbwRkKt0OWrtYz?=
 =?us-ascii?Q?n05UAaYCf0Epvk8pIIVX869+sBqG/os2a/bR7FZ5M4aeTDyWN55o0aGYlvNw?=
 =?us-ascii?Q?UewOhzqQHC8Rxs+r22Zb9OGBOyP2nYrkDylEAtUuKRvux1t8VgZmE29kAZh6?=
 =?us-ascii?Q?bSC+5qyCKagZo6iBZtSXTIoSQQY8ykaBg2hoNtRaNba7BwIrr0jRgEJkpS/G?=
 =?us-ascii?Q?eOul6JrkwQt26ppvyimDVhu0JHeLWVN6VUFArlR1UXM1Mj0N335+nQ91Xjdr?=
 =?us-ascii?Q?wzO9sYDODhM10/V94AFcGNTf6hr55CnfsXckgy71q/aD3o37hYFawv1yewVB?=
 =?us-ascii?Q?zrBRHYEFQx4juwN+s4aJOa00P2dBHgYJyFZP62+VzHyb8ZTjMlLm6MRKJuUE?=
 =?us-ascii?Q?ZpKFdfQ1pTU2P/ve16+cWkRxzXzEWY4ZFTs17ul97ro2ieMDcStNKjihfTlz?=
 =?us-ascii?Q?1eaz+xRJwgQk6EtTYyPmSc1Fg98nBVn4SoZTWM09weDuLpaF1yGhIUNCllpQ?=
 =?us-ascii?Q?wCWG8tzNw7juVnu0TceyO0xDqYrzcg7jOcTF+fLljhjI4NYoF41uL/pSScHn?=
 =?us-ascii?Q?Mzs45jduM7/0hoaGQOyPmJDhYK1HBOYfO5qSYU8SxJHWVHnX7/ylyGIUxQUg?=
 =?us-ascii?Q?dGe7wuB2HDGvoAX3jP5uipctEKD7pUqNH7eHBj4w83vsatMIc89N15vH7Kza?=
 =?us-ascii?Q?N2hPprcSrEkEoHFwoTDEtZwAPLntJJDLUQqLuYpiQ76TtZUnFG7Q5Uy5MTqb?=
 =?us-ascii?Q?FeKv0VykXMzYTKAh3ALCqVH/55S2kqDnemZy?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2025 06:10:43.7158
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 929a1c69-9d25-4dd6-217d-08dd86e49340
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB54.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8102

In preparation for using find_highest_vector() in Secure AVIC
guest APIC driver, move (and rename) find_highest_vector() to
apic.h.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v4:
 - No change

 arch/x86/include/asm/apic.h | 23 +++++++++++++++++++++++
 arch/x86/kvm/lapic.c        | 23 +++--------------------
 2 files changed, 26 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 1c136f54651c..c63c2fe8ad13 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -500,6 +500,29 @@ static inline bool is_vector_pending(unsigned int vector)
 	return lapic_vector_set_in_irr(vector) || pi_pending_this_cpu(vector);
 }
 
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
+	 * The registers in the bitmap are 32-bit wide and 16-byte
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
 /*
  * Warm reset vector position:
  */
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 28e3317124fd..775eb742d110 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -27,6 +27,7 @@
 #include <linux/export.h>
 #include <linux/math64.h>
 #include <linux/slab.h>
+#include <asm/apic.h>
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


