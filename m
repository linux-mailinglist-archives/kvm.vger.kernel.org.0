Return-Path: <kvm+bounces-46433-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AC35AB63FD
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 09:20:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A64671656BA
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 07:20:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51DFC20766C;
	Wed, 14 May 2025 07:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="TZM2Q4HO"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2047.outbound.protection.outlook.com [40.107.101.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A1B1FCFFC;
	Wed, 14 May 2025 07:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747207221; cv=fail; b=DQ0NMrheVY45ZP/y8sFGfpUS+hMGMIM10fg/oz884WKE0KZ1J7PgERUJ6u+9kWjfHJKA9mM2FU9QIHmNMi9rb3kqpYXqLWry459B4J8wLgV6gazQCmi2v7CMUlrnqK9qbb1J89hNHkwQRs0yEwiPAYoZBduHsCFW2glSQk5LxoY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747207221; c=relaxed/simple;
	bh=y96FVQgLI9gwNvEuxQ4HLPZ4X6Qq+XB5sDNE8Ed8SVw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s5GU11t6L8ZIqf7p0il42hDrKIYErYHFSVNwnAkwT89wuFYcWwyMRr6npQ3ps+I088n7udsUcZ5zWiQT3zhsJGQqO2atVbOfVkQbrXtl4ory1heypWS2TyOXGhguHEijmksoMrpAv0EC4UBGUIMyWiNS13qcQVlsUp+NP4f04aM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=TZM2Q4HO; arc=fail smtp.client-ip=40.107.101.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DSMoyW5bfDZwizX6kPs3OetxzmbY3LVb06WSor39EkDM4KHHppFcVJan354LnLzh48xuNrECi01OjaYHtdf6sZKIhVLRvMnWefb76IZ1xs8f+zqzRJOlj6n4Bp8Ymmk1m40vmnTkGAqFay+9SSkdku9PccttxGhnNPkAh7oD56/Ltjox4xxx22rCCFGWx8AvwS5tBtQMXCKkbGuNJkf/mejrwDfz9WcPPdAAf29wVdB5ZmCuaKlWFKRzREnANy3jfoZpFdXly0t+sHKnOVWulJZtyyUQVTojPldPPXVGnkOEjmKBLRErmAtYB4e7XcsExihWnqlljuGsxIPrtM9QfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wFz/nG5rn1SbAa1E04j88G//A4kESD7znw4ZWvD4ABI=;
 b=Z3w21dbYp9aiyFiLeE0ErJLIPFcVG3bNENE31CGYs3F2zxgWYAvo/3+/Iv6VJMN3Hbj+/KpSnMg22pGidbNd0KcxLD4GucgoBQg1Yx7HAWxyPKniIHq8dgX8SeFAeJj0ocjmJbKV8x/4++RF0LCyqSOyTIbMEE20DoXdggZ0fjRAs6rxF1T1t/5BmA7axqq+vImBdY1lXvm3ld68mEYrWujNi3vUiUOAGyl7wwxUC0AtqnwS5yTqK31lAbjwtZh4AJRHouT92aXJDEJfI1mcHJRIJ106fLK7Hhm1oRsPjHmq4QJetssGihBA6pOvR+4fRXDM8KsqdwpTkIQps9yXUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wFz/nG5rn1SbAa1E04j88G//A4kESD7znw4ZWvD4ABI=;
 b=TZM2Q4HOpoTDRuCklkGInrvIPX2Vl/22LDE0ojcS8wc35XxmuwK/UuMEN6OMaDFTxHiXVhxnzHpxRF/c3vTYyC5W2rUWTgYBfPWp1K7bs7KPP1edKX3aAvNHQuRrlweiNlWdTConA7FLXejNV+Kxir+cI9j+0o+H4UuhZkavGrE=
Received: from SA1P222CA0044.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:2d0::9)
 by MW6PR12MB8865.namprd12.prod.outlook.com (2603:10b6:303:23b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.30; Wed, 14 May
 2025 07:20:16 +0000
Received: from SN1PEPF00036F41.namprd05.prod.outlook.com
 (2603:10b6:806:2d0:cafe::56) by SA1P222CA0044.outlook.office365.com
 (2603:10b6:806:2d0::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8722.28 via Frontend Transport; Wed,
 14 May 2025 07:20:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF00036F41.mail.protection.outlook.com (10.167.248.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8722.18 via Frontend Transport; Wed, 14 May 2025 07:20:16 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 14 May 2025 02:20:06 -0500
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
Subject: [RFC PATCH v6 05/32] KVM: x86: Move lapic set/clear_vector() helpers to common code
Date: Wed, 14 May 2025 12:47:36 +0530
Message-ID: <20250514071803.209166-6-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F41:EE_|MW6PR12MB8865:EE_
X-MS-Office365-Filtering-Correlation-Id: ea82ec1a-5f53-46d7-0f6a-08dd92b7c6a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|36860700013|1800799024|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CKQbLSdhb5vS+MFVoQKU69N/NmOxG3M2PgHigDCaRE+Z8O5j5gRL3Db3R5vc?=
 =?us-ascii?Q?T+VxWxYEWQ398nx6HwaDtjwPVqYmHY4hOuGWG91qS+xtkvnt7qWiwRCQ4JY+?=
 =?us-ascii?Q?sCM+1TpK9WFjQXqPCHDrJYQn6XKf0/kZQSbkoBejeukiiP72xLJF5LhdU2SO?=
 =?us-ascii?Q?9/B5Y3uhHw6RrySpJjxVYUg6rtJBO6wGN64p7HyOKsup28DJF10no6f34MM3?=
 =?us-ascii?Q?skiAa1hce9w/4RsANecSVhIabWMjXzu5flOXLwqSKACMVw9XAvTfoAZZDdLv?=
 =?us-ascii?Q?Ja8h7+5H57rwmhkx/U2+aeJhYHCRC8MCDUvvNW0oF5idsHAnYJ3JnmbyJdqn?=
 =?us-ascii?Q?zyX3zOsBAOkTnQJR7ZudZFeyY4YSXgiLuGtu3u40PNINP+o1xsQmIDn6+dHU?=
 =?us-ascii?Q?sthONyliLEgCJkAhcozG+GaLZ/mEcwJRlclOvpr/iAW4dyrB6lYfaFeOKLu6?=
 =?us-ascii?Q?1gg8f+Gttp72wv+8e2a/ZPSaN5STuya5+wqJz6hR+b0pDEAnIIXHWIKa9R4V?=
 =?us-ascii?Q?EEmL45nuOcMY9ap6BNioqsyOqIsmox25Ezv1iK7dMsXrWFIxoiiHr5I2jC9D?=
 =?us-ascii?Q?1x4ZeAGbhV5K2+AWNj2s/IVuVfWMMLJ4b6PQZPIk2Utg4kA8KyfypmVR1+Rw?=
 =?us-ascii?Q?LJOuInGrnzyV3Ea/AXqYcta/602spMMPGYoVW2SMitH2fT2ubuQ2zGuTBLnZ?=
 =?us-ascii?Q?M4a6oyJlyRS3aBZZg82lRSZ7k0t1rZqX8Q6+A7d7HG3KoJpQ3NE4bCAJ7z56?=
 =?us-ascii?Q?KDYovDm1Wc3sAuwxa0HVPzgtJhERrltIqu0DXgWjzATEVvyk0WZNnQSly1GY?=
 =?us-ascii?Q?dfaBf4qwQg7wKAWJcXPUmFUSawdFr3erUAhcqOZh/h50oUzYGZY5m9i0J44L?=
 =?us-ascii?Q?YXph0bpEwB1IEok2YsWJaX90zt1EJ4oAcTRmRS2W/PyTJjaTwosnnK5brv/G?=
 =?us-ascii?Q?QCxXmavJ+0N/7v2TCDE4T8I+nRMkCyg6TjBkCLAvVJoIlKDFKPtF6An6KYY8?=
 =?us-ascii?Q?Uq7U9+qRWpeu3e5oDJrpu94By/P6bdPnvSOKnPJRMbWu8ZyJFtOSew/JsFZz?=
 =?us-ascii?Q?rd+KBvOa3KM01iBa7quRdnziVt2i6wJWEUbucLq31c7z+wuAi3aWYacCJWar?=
 =?us-ascii?Q?u16cm1caMT4j6bWpBMMqwMjRkcqfOItSUM4xY0Ju/A8ZUd5I3hM7qCzkhknq?=
 =?us-ascii?Q?Ji1+CFckYyM5SHgU9gyk8OMNuApsmDkhyUNyEOjZbvIPcZrUqLx1OV43tN7y?=
 =?us-ascii?Q?shLED4mmfjuBQxL8R+ikYusw8H2nyXqQX09vZx1gLupPsNdiOSr9hN3P9npB?=
 =?us-ascii?Q?yD+vsPy/tTcb8D/xMAs2knEtdRTnbKLtED4d/Ei4up5c+rYJpuFAR2FbJkwy?=
 =?us-ascii?Q?MsZWs9u6ZYmpuBVXjdgQ5j2JoUWNfCMGtddwp11yRVQnzh+S6iFCOhKJUvcU?=
 =?us-ascii?Q?wQvRieuSR8KDKBAAtMlRpTaI3gq3zLj2H+SzfV0BaKrrOe3hfILDoqwQRVRM?=
 =?us-ascii?Q?4NNJlHtwD1mNyHujo/2sxQaJjYm646gL59Y7?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(36860700013)(1800799024)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 07:20:16.5391
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ea82ec1a-5f53-46d7-0f6a-08dd92b7c6a4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F41.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8865

Move the kvm_lapic_clear_vector() and kvm_lapic_set_vector() helper
functions to apic.h in order to reuse them in the Secure AVIC guest
APIC driver in later patches to atomically set/clear vectors in the
APIC backing page.

No functional changes intended.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v5:

 - New change.

 arch/x86/include/asm/apic.h | 10 ++++++++++
 arch/x86/kvm/lapic.c        | 10 ++++------
 arch/x86/kvm/lapic.h        | 12 +-----------
 3 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 5b4926b405aa..ef5b1be5eeab 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -547,6 +547,16 @@ static __always_inline void apic_set_reg64(char *regs, int reg, u64 val)
 	*((u64 *) (regs + reg)) = val;
 }
 
+static inline void apic_clear_vector(int vec, void *bitmap)
+{
+	clear_bit(APIC_VECTOR_TO_BIT_NUMBER(vec), (bitmap) + APIC_VECTOR_TO_REG_OFFSET(vec));
+}
+
+static inline void apic_set_vector(int vec, void *bitmap)
+{
+	set_bit(APIC_VECTOR_TO_BIT_NUMBER(vec), (bitmap) + APIC_VECTOR_TO_REG_OFFSET(vec));
+}
+
 /*
  * Warm reset vector position:
  */
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 457cbe3fa402..23d0a2f585bd 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -693,10 +693,10 @@ static inline int apic_find_highest_irr(struct kvm_lapic *apic)
 static inline void apic_clear_irr(int vec, struct kvm_lapic *apic)
 {
 	if (unlikely(apic->apicv_active)) {
-		kvm_lapic_clear_vector(vec, apic->regs + APIC_IRR);
+		apic_clear_vector(vec, apic->regs + APIC_IRR);
 	} else {
 		apic->irr_pending = false;
-		kvm_lapic_clear_vector(vec, apic->regs + APIC_IRR);
+		apic_clear_vector(vec, apic->regs + APIC_IRR);
 		if (apic_search_irr(apic) != -1)
 			apic->irr_pending = true;
 	}
@@ -1296,11 +1296,9 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 
 		if (apic_test_vector(vector, apic->regs + APIC_TMR) != !!trig_mode) {
 			if (trig_mode)
-				kvm_lapic_set_vector(vector,
-						     apic->regs + APIC_TMR);
+				apic_set_vector(vector, apic->regs + APIC_TMR);
 			else
-				kvm_lapic_clear_vector(vector,
-						       apic->regs + APIC_TMR);
+				apic_clear_vector(vector, apic->regs + APIC_TMR);
 		}
 
 		kvm_x86_call(deliver_interrupt)(apic, delivery_mode,
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 36c67692ba28..50f22f12a1ad 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -148,19 +148,9 @@ u64 kvm_lapic_readable_reg_mask(struct kvm_lapic *apic);
 #define VEC_POS(v) APIC_VECTOR_TO_BIT_NUMBER(v)
 #define REG_POS(v) APIC_VECTOR_TO_REG_OFFSET(v)
 
-static inline void kvm_lapic_clear_vector(int vec, void *bitmap)
-{
-	clear_bit(VEC_POS(vec), (bitmap) + REG_POS(vec));
-}
-
-static inline void kvm_lapic_set_vector(int vec, void *bitmap)
-{
-	set_bit(VEC_POS(vec), (bitmap) + REG_POS(vec));
-}
-
 static inline void kvm_lapic_set_irr(int vec, struct kvm_lapic *apic)
 {
-	kvm_lapic_set_vector(vec, apic->regs + APIC_IRR);
+	apic_set_vector(vec, apic->regs + APIC_IRR);
 	/*
 	 * irr_pending must be true if any interrupt is pending; set it after
 	 * APIC_IRR to avoid race with apic_clear_irr
-- 
2.34.1


