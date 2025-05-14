Return-Path: <kvm+bounces-46430-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A495EAB63F7
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 09:19:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D65D03BF7E3
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 07:19:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E66D20468E;
	Wed, 14 May 2025 07:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="3g+iluJf"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2070.outbound.protection.outlook.com [40.107.236.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7584B201000;
	Wed, 14 May 2025 07:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747207155; cv=fail; b=IMhlzHWhs7HMeJMQaC1Rf04PpdhS3tQqkj/RGvvhKEOriOJoahzS8dI0oM1nQyHv8qNk6iiMzCYd98F+v6Q42IwOxfdQBYc1katNALsmKeIRkgmXNtnvxuBbFuVw2/lTvOdFVIYEbeByHQp99H1dseNKjrtURCKUzWLQnnTgh9o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747207155; c=relaxed/simple;
	bh=wII5Zwta3wPhEFH/Ca7qemDp3QKW59LR9Wu71Z8vJtk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q2tCR1cCBoQRNJn6Cl2Qd5sEJjAj/7xHCKq6vAuND2uvcpZJEws+FgH8qVtmyncmfya3SpOIQ6zMIsZQ26iSuptmyLOi+bCcPkrPZopPEKwlGETcR6H62LoteVYXdcErjBSPivNjFPh3QopuGIqy1Zh2R6rCVMKWVblCjHaDpJA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=3g+iluJf; arc=fail smtp.client-ip=40.107.236.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qG2nor5K1W5hS0aNMZjSHPQFC/4JrLp6GQydxXD2zEZFXVOcBVF4jrptACszUbTme9xx94PV+H0IUwGibBMjgrKCtb/RrFK2lhglt3fohzys9xGEZsdE7vD5u2uuQfbe5EUuluWLOKr0MIUVLCxogjS+LvytzZjZfDJxsTnAQBUwCJr7IzDANm+xkLSmtq/EgjV9TLEEwY3o6aGtupgKaBWM2qWyt7ZWNqOWwDJSHhIHERRP7M0CZJ6LqccxQds9nf9m070qrzVPTg2LlcyblrSLxOvD1lVXvTTc9UsXfYIkOtBavaCwVl9K9As1+hH/ITm1z+xHAU5SfVC8epWSYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FDL7022bmdpdE1ObsbSMZpRL9AVHvUZSXgHu55VMvbs=;
 b=n1fJ6zlpdCRkqjy0jHYpvegNYbnANXVrQDkI38vNh9YZnJ8AIO6UnwdeLLFeVNh6hiNGdD5QqezVCnjXDkrF4l3N23ApgVC4eWBlGOTEkMPJFHKr1OrFmKGrQG+xld3N00nga4ZPcUvvqRkoQk0NEDLmxUQkiONwORxI1v3OKH4aPJDfIO8GXnW891DPlxp2YcV24wrCQ6Z+EWD2J2WdTYV2I3zCnWf78czD/3wiqVHbe6boQJVaJ4UuXAcwC9ushcOlcV2zv3Uv0eUu2jdinPoFaFTtU0yKfCJhIfNehz5QglBo9YlvhHp1y/LrgEYMqjdCM7Ip6PTIrkGX4UPEkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FDL7022bmdpdE1ObsbSMZpRL9AVHvUZSXgHu55VMvbs=;
 b=3g+iluJfmHJlDfRvXQ5qQA6Tzox0e2O6N1fRETKFD7WTBiFrADyUOMELmzLcrH6LCBPG7+n0uiTpSxQV0Xzc/txX9i/b/BitwGo1S9V66H2P0P4r8JUWF0xVOuMXiXj9tH1RyFQFLi8yU830qAiXJ61Oov0Ws9UiQm3rXegtHjU=
Received: from PH7PR02CA0028.namprd02.prod.outlook.com (2603:10b6:510:33d::32)
 by BY5PR12MB4162.namprd12.prod.outlook.com (2603:10b6:a03:201::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Wed, 14 May
 2025 07:19:08 +0000
Received: from SN1PEPF00036F42.namprd05.prod.outlook.com
 (2603:10b6:510:33d:cafe::46) by PH7PR02CA0028.outlook.office365.com
 (2603:10b6:510:33d::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8746.17 via Frontend Transport; Wed,
 14 May 2025 07:19:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF00036F42.mail.protection.outlook.com (10.167.248.26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8722.18 via Frontend Transport; Wed, 14 May 2025 07:19:07 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 14 May 2025 02:18:58 -0500
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
Subject: [RFC PATCH v6 02/32] KVM: x86: Move find_highest_vector() to a common header
Date: Wed, 14 May 2025 12:47:33 +0530
Message-ID: <20250514071803.209166-3-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250514071803.209166-1-Neeraj.Upadhyay@amd.com>
References: <20250514071803.209166-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F42:EE_|BY5PR12MB4162:EE_
X-MS-Office365-Filtering-Correlation-Id: dc0fbc86-4d17-4dd4-9ba3-08dd92b79da8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1yeuLem96oY+XVtRfx4dUS9b/QSv5jPT8wAy8+VdgQqZCgYAZDpXixjr+1lc?=
 =?us-ascii?Q?8ga+uJj9d/zvUII82HCJgS3oz8jeOD2fPfNtlgMUPBZ4u6Tc0s4aClip+39q?=
 =?us-ascii?Q?XWjZJa/JmRSt7d/cSuPTKYTrEZjSXLSPuNL+cuYGzx7Cwf+qr5Yth8hdcX6+?=
 =?us-ascii?Q?FmopWCy7G+IYA5nVXAHzIi1JqpkZ69XoUPZFLEDx1edhV7kPvS90H5ruw67P?=
 =?us-ascii?Q?D46my1tLCrl90j2gvoGunAwB3CeJp7JTDzZIX7oAAW4VoxfXvbWJGcD2RJkC?=
 =?us-ascii?Q?bMNF0M5fsch6Wat2XlLb9Lgy1CQhVs4LUuFqorWCedoCfo9Ucg+W6XEbwic0?=
 =?us-ascii?Q?4Wd85gasaHDfcBiP2UjZQOcOXMp0DbVROf9YLBO+2ZmpTsfFl/8nh7PH8uC3?=
 =?us-ascii?Q?VCVKUSBAH5Sw8VmBcFGOrPWY9wf/L0J77LAebrMEhPzx//LfTkyKpJDc1e0c?=
 =?us-ascii?Q?tD+pLJ2pCe2rXy/bAj1wl7qxTr/ylix8iijoYZyG02YBSWCCXVvQkMXEO5eS?=
 =?us-ascii?Q?rKmuuQvRXa3HgInipixUe6+67su5wsvw5BHGrp2R3FP7TNxEYj7HTsNJKWH2?=
 =?us-ascii?Q?kggPeUc3YoLPVsEFcvpg/sKAJC6KEn+nqWSeok/trwTgafeDqMUH3ajYeQ6h?=
 =?us-ascii?Q?hjuUMOLwBf89JqW63ee40wwo5ajKobPJn68tDlVs5rpgkhZWyWXInfEkWp3k?=
 =?us-ascii?Q?2lCIGO3ZsdJhOcXnb8BBDFiAF4w1M/2pW3zpdowBEfNRnJhgbk1KJXQwesrv?=
 =?us-ascii?Q?kJUdNEQFcfSr0Dhucsryg/XmGG9iu2MWpRYJ1g9UFgbTZEb2nO3Mji7zLcZj?=
 =?us-ascii?Q?vz4VAEGBtwj/jHKGIHfiT9gfrP8Io50XJSvt3yXyOwUQHXj54IWxQbM85EJ1?=
 =?us-ascii?Q?cV18JzQbGskuR1d66mzL2Yn5iGkSgulEzrlaKx8nk/sUMtkcK3u/uew+nGGG?=
 =?us-ascii?Q?eEhihoHIXM0rHZeA1DS+/EYM/uO4B2UKVljKLyfsQfhjSGYzUcqhnTyNVGkP?=
 =?us-ascii?Q?V1weAZxwI6x4D1ANWICEyQgKDcXgVYOaidouMAbE9AIiS3nmNEllf6Wq7VJ4?=
 =?us-ascii?Q?kIpZIajiL2oG65VfuhsKiFsLSHnElfbnjb65dK6UouiYNEd+4tgl+hEx8NEW?=
 =?us-ascii?Q?koI9iloyPSC20ZtV+pNBxgCAdNu7Oyjlun8fwQciwoNBkrem5Fy0HlLVchE/?=
 =?us-ascii?Q?Hoy75G60MW4gQtSm0xZJGMZMb8m07cAXua5YjAt+LOnwThnBqjXIJYgjRc4h?=
 =?us-ascii?Q?GNlaWCbUH7uezlf7N2v9QxKICEFeXBXfF0Pfi9V/MBpZ/fmvBPIxmKeRAwtS?=
 =?us-ascii?Q?L4hB7Xglol6/G6F22Uoa51JhD6LxXZllM5TTQVAWAs2bOUTHuPKfZ4XUOnCv?=
 =?us-ascii?Q?jQvMPNaDdt2+nARWfhLIqEFv86MGxXE26Jt8m7V7FRMZUl2wbA+z5xig8Do9?=
 =?us-ascii?Q?m0XsJSNKbdQjsZ4PG//S/wqOuzDhZ/5sgBYCkCWfMof+XhVQRX13GvX8CHVi?=
 =?us-ascii?Q?MtElJ/6QR8IXUouyVcDO17DC8BuaJE+pNO1R?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 07:19:07.7491
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dc0fbc86-4d17-4dd4-9ba3-08dd92b79da8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F42.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4162

In preparation for using find_highest_vector() in Secure AVIC
guest APIC driver, move (and rename) find_highest_vector() to
apic.h.

No functional changes intended.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v5:
 - Use the same implementation as lapic's find_highest_vector().

 arch/x86/include/asm/apic.h | 22 ++++++++++++++++++++++
 arch/x86/kvm/lapic.c        | 23 +++--------------------
 2 files changed, 25 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 7e0d3045e74c..bfdca72c8361 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -503,6 +503,28 @@ static inline bool is_vector_pending(unsigned int vector)
 	return lapic_vector_set_in_irr(vector) || pi_pending_this_cpu(vector);
 }
 
+#define MAX_APIC_VECTOR			256
+#define APIC_VECTORS_PER_REG		32
+
+/*
+ * Vector states are maintained by APIC in 32-bit registers that are
+ * 16 bytes aligned. The status of each vector is kept in a single
+ * bit.
+ */
+static inline int apic_find_highest_vector(void *bitmap)
+{
+	u32 *reg;
+	int vec;
+
+	for (vec = MAX_APIC_VECTOR - APIC_VECTORS_PER_REG; vec >= 0; vec -= APIC_VECTORS_PER_REG) {
+		reg = bitmap + APIC_VECTOR_TO_REG_OFFSET(vec);
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


