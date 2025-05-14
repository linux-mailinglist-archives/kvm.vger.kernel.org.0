Return-Path: <kvm+bounces-46431-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B264AB63F9
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 09:19:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 73E5A7ADC68
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 07:18:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A21D207DEF;
	Wed, 14 May 2025 07:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="PlOtPZCc"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2051.outbound.protection.outlook.com [40.107.95.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9266420298A;
	Wed, 14 May 2025 07:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747207175; cv=fail; b=Sy9OJ/L++sfVyotX6oHPoWhKBbVafLJ+KCOlwcx1uzBBfeze+YAwwvcwsHCJgl9cPDPYL4lOCHQtKONhjLk32XzEQsvfsYIjmMPnbe518TGBNNxUxZ03Igd4QD/bEBERDUgSg0L8C24N4J2kQQsed2fVShH9c6f3UzIeNrSIn9U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747207175; c=relaxed/simple;
	bh=Se40evQCyUtHsdBxBnEE33ObLvUOHNEJXB+MLInRLtg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AQyuSNAb449kEcGBXiWmFt/hlUbFIxaefq//3XlHbNAyZnLgYZIDIXXhl65rht+snMSvXon8qsjhBDPsEVcSbv0WBjJy4QtVgRBfOXJv/NOV9OcKV2Syw576IsAR7wPEQ6BuKnf0kt3RJmPuqT0DXpuUUrS8XC0KnzwvK6YInUk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=PlOtPZCc; arc=fail smtp.client-ip=40.107.95.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ht8O//lhLpPO6vg5T3u+zrPMXZ3WhzuO+tQCPLbwCsEzSnpXDc+/Zxm3xVhXc4Bull5R59Ua6DPqulaDaQBbc+1K4xw//wHkqh9x7WUOGzzUiySLcvXjzcTM0qp+OkMRuKaFOHjLBE6DiiSPm5aPV/zLlSUZWDYBeiMc1qb636fQhQvghtXMEWcx3eaGiRWzNGr5ONISZ+oOnSwoHHM+/3b3fa+XBUkFP/Dd4fZaW347/VlLXHuC39HzUct55AT6TAYpWqJZKN/62q20DELLy+Uab1nKUAXT1POHoGRExoQAF0aKF5Sil1qsHgqXxc8EvN1vzBlMlONDMou9v+ZC5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zjBJioZ/Dop/vuTd0+os90k18UZBviF8ZhbL87yWSZ0=;
 b=quSFhXcgGb3S6OZGGKH10ipe0zEk6+U+pcQbXNEzU9FQZ4YwfaLmAdsL9jvs4YWnEU8vQF0qETbf3k9/gPQexv2cC4k90ZcZsZu0IDRlgWxweO6HpXrnKrihJ6WaL5m6oBAOaz1o1CCRB7iBtWXKHe3nao+kwgvDLye6mKlEATiZ7rn0E/hg/2v7WfswyxQ0TiRFCrF/A972HgdsEJQF6kSd+oUovGmXVi2fUIrWDpRl8/4HfgIXLW2M71q/cZSSiCBK8CLczBmBYjO5xeWBUucCvAxQXv5VTxoorzIZuhUwRCboy6s0TVKDJwgE1/i4J0UH63olnRsOphYTVATVIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zjBJioZ/Dop/vuTd0+os90k18UZBviF8ZhbL87yWSZ0=;
 b=PlOtPZCcCOmZ/T+vxX/uWIVZHh6+k+vTxNya4TGj0mYoEPDKgX6Lx2MIFWM0Q7JeMkv2uCCOWXPyrm/Y+pTG33zGMCyLVm6srfwG9ZKuLSPvKlZ5Qu6QejYxFhpbK4qz74gKDnS63ev8eply4tg3jrVRZjq8mr4qoq7SA4kXZm4=
Received: from SN4PR0501CA0018.namprd05.prod.outlook.com
 (2603:10b6:803:40::31) by PH0PR12MB7789.namprd12.prod.outlook.com
 (2603:10b6:510:283::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.31; Wed, 14 May
 2025 07:19:30 +0000
Received: from SN1PEPF00036F3F.namprd05.prod.outlook.com
 (2603:10b6:803:40:cafe::b) by SN4PR0501CA0018.outlook.office365.com
 (2603:10b6:803:40::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8746.16 via Frontend Transport; Wed,
 14 May 2025 07:19:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF00036F3F.mail.protection.outlook.com (10.167.248.23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8722.18 via Frontend Transport; Wed, 14 May 2025 07:19:30 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 14 May 2025 02:19:20 -0500
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
Subject: [RFC PATCH v6 03/32] KVM: x86: Move lapic get/set_reg() helpers to common code
Date: Wed, 14 May 2025 12:47:34 +0530
Message-ID: <20250514071803.209166-4-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F3F:EE_|PH0PR12MB7789:EE_
X-MS-Office365-Filtering-Correlation-Id: 62569931-9a09-4264-7950-08dd92b7ab04
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?B25qqYRj78Gf5LP4dvLYIvD8gt70DTCxdvOt4JBjL8kzmgmZXSIZJ1exGhb/?=
 =?us-ascii?Q?3iEGyK+RZ81StkSH+7kvjG1wqszb6O3rO4T+VbxiiGP9xMtq95XOvGrleb/P?=
 =?us-ascii?Q?pfWwIcIkasyeKdrjGeIckxD88/Th+CUkqtSyG9Yj11KGn7OArTEzF2ZteyMY?=
 =?us-ascii?Q?IOABgrLQmJEDKAnILX6CCybL3uF2TRFA4TBiZKxziF6q48/4hg6/5bib3eC2?=
 =?us-ascii?Q?jRZj2dYnrz7VOhoLyou/pYLSUC/f1jXnL5C7dtaKHkEb6aS8VwNa2FYCNe+W?=
 =?us-ascii?Q?7NJnvaVK8kOs81QPSfvd1HgJunY8S9vdQ+J3hr5K1e6+X8Czze9fgO1y7Jzl?=
 =?us-ascii?Q?H0uDu4bD+qCyXD95vcSTHo8KVHOnPZTMGJl36gcwZPxBtW8QoxyG1ITXqBpf?=
 =?us-ascii?Q?Xx3EldEnHn1TPY8a6mSjsRUWQFCxESqbRavuhTkzkneLDG+acNNsv+K8JJqj?=
 =?us-ascii?Q?UIYTGrJ1RvRRtxv1ObUU93BA3U0YvIfJxWz96zHQ98s9mCXW9yRV4wnDMxhh?=
 =?us-ascii?Q?KM9zb3u5kguHteN+ZtHLD9RJZXu4MtnOn2wPIiP01r3yCIbLxUrgL6kdPBTT?=
 =?us-ascii?Q?MlzBHiLIT2LMfsJYnr8BgyFYDQsKVQldbCIPr+xOUc893vPY0NlX7/qMczjB?=
 =?us-ascii?Q?9yClMrJFiE/75huZcfNBJuVfycvF2uTl92vnAFUaulcjjmkNs/Nu3zJBn3YV?=
 =?us-ascii?Q?VC/y5lT9GFB0Apxft58/CssY9e3NbX6u1YGnDEhA/xPUJZIgxorPbSRpT3aq?=
 =?us-ascii?Q?WUQTM3206zDa6gYG6Hw3PCiymt/8UTfi6aVRI5iK26CT7L5l1Xg8EJ9l7D5c?=
 =?us-ascii?Q?eSgTS4F2ZkPCL2R7I6i8JDqI2XRkBKVhAZTdUco78/ow7TE4U48YC6pmT/0c?=
 =?us-ascii?Q?RCwh0AAam8E4woEnu4coAdSzfwNGnD9AI7uF6523PDhvKGB+ftOosfWMEE2r?=
 =?us-ascii?Q?bmohAZ+8+LwCRrZgD/Jfxc6pK+mMu8ATpbqT1r07YFJSvy3xC+KXnv0tbmaU?=
 =?us-ascii?Q?8g3YIepmnio/x22EUfjEI/Oq1fPgqsMDUDqiRR43cgRa8SBs/P4rfoN/N0Yk?=
 =?us-ascii?Q?25KXvsj4LiZAlrx1uv8TmhU5bgFMruy1r6M62vPszhzxzIZvFlOV3zaSAV63?=
 =?us-ascii?Q?zFG8XQ5D9g+W/AyQqnvEXMp4PeOSyI2m9Hj/QMJIsguN5GeJQ7tqBSmXaYqC?=
 =?us-ascii?Q?nM5XqG5iY0EBt7pDYvVsRY1vSp5GTXH+T9UDg5BwK6PNib+ESIoKcTuSOCL9?=
 =?us-ascii?Q?gcD7mVAnY0/u9EBIq30j9A29+rWHLw5BprPdnw0OjV9lRy8/GDJqCTfzIhh/?=
 =?us-ascii?Q?cGb355wa8JHancZ9zJ1f+ZPkYfz3aeHkXS8Xt3JUlOEIdzb2Wmb1JZZBWq4p?=
 =?us-ascii?Q?Icnzbs0r7Okn9njqA3I8TePOEXSRBOX6nM3NYHzt+nLlqdi5BCyS/h2j5vD6?=
 =?us-ascii?Q?kgBzxQsbwSNCd7B2ra/l4T0Se4wf/m/w1ctRxGsljb6MnVJ0L5k1yk7dHnbp?=
 =?us-ascii?Q?slpzNsTdg/k4Kig57jkMThsodMlTvw1SgQXO?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 07:19:30.1638
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 62569931-9a09-4264-7950-08dd92b7ab04
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F3F.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7789

Move the __kvm_lapic_get_reg() and __kvm_lapic_set_reg() helper
functions to apic.h in order to reuse them in the Secure AVIC guest
APIC driver in later patches to read/write 32-bit registers from/to
the APIC backing page.

No functional changes intended.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v5:

 - New change.

 arch/x86/include/asm/apic.h | 10 ++++++++++
 arch/x86/kvm/lapic.c        | 16 +++++-----------
 arch/x86/kvm/lapic.h        |  9 +++------
 3 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index bfdca72c8361..4851fb9e23a6 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -525,6 +525,16 @@ static inline int apic_find_highest_vector(void *bitmap)
 	return -1;
 }
 
+static inline u32 apic_get_reg(char *regs, int reg_off)
+{
+	return *((u32 *) (regs + reg_off));
+}
+
+static inline void apic_set_reg(char *regs, int reg_off, u32 val)
+{
+	*((u32 *) (regs + reg_off)) = val;
+}
+
 /*
  * Warm reset vector position:
  */
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 775eb742d110..b9f9ccedafe3 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -77,14 +77,9 @@ module_param(lapic_timer_advance, bool, 0444);
 static int kvm_lapic_msr_read(struct kvm_lapic *apic, u32 reg, u64 *data);
 static int kvm_lapic_msr_write(struct kvm_lapic *apic, u32 reg, u64 data);
 
-static inline void __kvm_lapic_set_reg(char *regs, int reg_off, u32 val)
-{
-	*((u32 *) (regs + reg_off)) = val;
-}
-
 static inline void kvm_lapic_set_reg(struct kvm_lapic *apic, int reg_off, u32 val)
 {
-	__kvm_lapic_set_reg(apic->regs, reg_off, val);
+	apic_set_reg(apic->regs, reg_off, val);
 }
 
 static __always_inline u64 __kvm_lapic_get_reg64(char *regs, int reg)
@@ -3044,12 +3039,12 @@ static int kvm_apic_state_fixup(struct kvm_vcpu *vcpu,
 
 		if (!kvm_x86_ops.x2apic_icr_is_split) {
 			if (set) {
-				icr = __kvm_lapic_get_reg(s->regs, APIC_ICR) |
-				      (u64)__kvm_lapic_get_reg(s->regs, APIC_ICR2) << 32;
+				icr = apic_get_reg(s->regs, APIC_ICR) |
+				      (u64)apic_get_reg(s->regs, APIC_ICR2) << 32;
 				__kvm_lapic_set_reg64(s->regs, APIC_ICR, icr);
 			} else {
 				icr = __kvm_lapic_get_reg64(s->regs, APIC_ICR);
-				__kvm_lapic_set_reg(s->regs, APIC_ICR2, icr >> 32);
+				apic_set_reg(s->regs, APIC_ICR2, icr >> 32);
 			}
 		}
 	}
@@ -3065,8 +3060,7 @@ int kvm_apic_get_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
 	 * Get calculated timer current count for remaining timer period (if
 	 * any) and store it in the returned register set.
 	 */
-	__kvm_lapic_set_reg(s->regs, APIC_TMCCT,
-			    __apic_read(vcpu->arch.apic, APIC_TMCCT));
+	apic_set_reg(s->regs, APIC_TMCCT, __apic_read(vcpu->arch.apic, APIC_TMCCT));
 
 	return kvm_apic_state_fixup(vcpu, s, false);
 }
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 05fdf88ef55a..36c67692ba28 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -4,6 +4,8 @@
 
 #include <kvm/iodev.h>
 
+#include <asm/apic.h>
+
 #include <linux/kvm_host.h>
 
 #include "hyperv.h"
@@ -166,14 +168,9 @@ static inline void kvm_lapic_set_irr(int vec, struct kvm_lapic *apic)
 	apic->irr_pending = true;
 }
 
-static inline u32 __kvm_lapic_get_reg(char *regs, int reg_off)
-{
-	return *((u32 *) (regs + reg_off));
-}
-
 static inline u32 kvm_lapic_get_reg(struct kvm_lapic *apic, int reg_off)
 {
-	return __kvm_lapic_get_reg(apic->regs, reg_off);
+	return apic_get_reg(apic->regs, reg_off);
 }
 
 DECLARE_STATIC_KEY_FALSE(kvm_has_noapic_vcpu);
-- 
2.34.1


