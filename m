Return-Path: <kvm+bounces-43539-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F320A91783
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 11:18:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1BBD619064F2
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 09:18:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FAC7229B2A;
	Thu, 17 Apr 2025 09:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="3AbsUYaL"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2052.outbound.protection.outlook.com [40.107.243.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C92B2226165;
	Thu, 17 Apr 2025 09:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744881473; cv=fail; b=eFVitQWRde5YzDqLYySeYubJRnXE5BxCqNo4LvOEeevsbqdWfcDlwMIRuAgi3JTWwNAiEfELD0HPlVvwIU34m529rQ/MDTvzOo1z93WS1h+pXL1pA/pOrOrQNC4emOQadB7B1XieK/RBAMsgUn8d9wcnnycQWGz85hqc+D65+7I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744881473; c=relaxed/simple;
	bh=B/FF9SOSYKLnMNPG/kM5VG4ycGOuDVRCmnSkkVJJ0eE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FvrDWd6PLxMKzhFoPNpMKBrzARUiz54aLSoGSTfSE19x9LXQwuyTK5TQRmmmUGrhdnUpq0YzIasEemW17EvSCDlGJUVbsx9ppIqha/vo/WiJRp0tNJiPb7fuD6iIV0jjwshpq+udP/mMCtNOE83WCrFl9WZ1ebIy81WMObySCyw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=3AbsUYaL; arc=fail smtp.client-ip=40.107.243.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dSdcdaCEgjeaOMNImAkMgyE69Bt/VgHnlScvOBbsS8dMqCc4F8D3LuaStlngLDl8PVwutqOewyWOlhZrnSdEFcK/uUujjl60URy5l9R3klqBaXHcS46/UgVmXPrAHTObWUWyvRSxWx4Yn+s1YDtVdnTSnaAWEPCrp4OIKqxUCYnpZJZwCUlWayb06QuLyzKaJp/o7j4Da6d2IEbi3K2t9pDjtcGBYCedKT0RGivOPpxJUOtmrIhO5kJ7jYChIuNuBHz/tPIuSlxtbNrQ62XeXLJFM8aVZrZZ9l2FfwFVP9Hxme3sBPOdep+mRv2Z/iJyKml+LUz4u6oUdob+rg0uDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QrUfO7hz7A7LS8F2dEmr/AeyLBaz2a/e6zzXy528mpw=;
 b=uleMF7jKovedh90GlhkkySwHwCij82HvoIicCJBuUISY0XyC4hcs5z6wKwbaqyw0pZv/O3kIZgaEFUi97Idb4MwxJ3N9Ts/Lim/tVHUkTsRIkX0/uGCtDdqZPZ+hAjb0OOtGRYynIht9wOVyGPypg55p9ddE99lsLrAjlEbgzHB9hSXtDoO69kOTrDamiK1k4n9oWfAAstshOMUGrZ1n6aDLEyHxx3zdSauxowCYeFvRHQKmZr0ZSq4nZ8ArCb58HYQUltH6q/heyf+KIiggTxMYC7u+xjDvTa78ngMcmaCX0hdH5CDlsILlU2aW67xGlSmpaHQ4rabcLmMZJrtoGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QrUfO7hz7A7LS8F2dEmr/AeyLBaz2a/e6zzXy528mpw=;
 b=3AbsUYaL1qJrI2lbEOfPIWZG44VOZDcECk/1klTTwLEaPF0spP2Ym7YafFMbA9pSenFLdDPSob32f5DXyJCZm/nJUBCbslu1TY2rrkZkhIUTBQ2+2iGf9nrCjFEKkgw80bzfEWRq1JipbT/vBJcwwMCWHIPsI8QeH+AfCCKggp8=
Received: from MN2PR14CA0005.namprd14.prod.outlook.com (2603:10b6:208:23e::10)
 by SA5PPFE3F7EF2AE.namprd12.prod.outlook.com (2603:10b6:80f:fc04::8e6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.21; Thu, 17 Apr
 2025 09:17:49 +0000
Received: from BN2PEPF000055E0.namprd21.prod.outlook.com
 (2603:10b6:208:23e:cafe::c4) by MN2PR14CA0005.outlook.office365.com
 (2603:10b6:208:23e::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.22 via Frontend Transport; Thu,
 17 Apr 2025 09:17:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF000055E0.mail.protection.outlook.com (10.167.245.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8678.4 via Frontend Transport; Thu, 17 Apr 2025 09:17:48 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 17 Apr 2025 04:17:40 -0500
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
Subject: [PATCH v4 01/18] KVM: x86: Move find_highest_vector() to a common header
Date: Thu, 17 Apr 2025 14:46:51 +0530
Message-ID: <20250417091708.215826-2-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000055E0:EE_|SA5PPFE3F7EF2AE:EE_
X-MS-Office365-Filtering-Correlation-Id: 75d4d607-1c45-4f52-1b27-08dd7d90b90d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1OV9SnQqqU+KUqGasnVRZ6fNWh2nsYsUiSbFz11mxHhxgd+rPcKcn/Rw6exB?=
 =?us-ascii?Q?BBE9CDy4d1ruJVCOqWgO5TgpIXMrSLbl+QgmtrQxfJwY/wBvmqWcQAmOil43?=
 =?us-ascii?Q?IgO/mO87x9aAYWNK50Q/pIk/6KWgg3cPIGvuhtHT68kwQG7oYzyFFlcjxHiX?=
 =?us-ascii?Q?ix+3426DKTs+K8i5JF/Fdrsx/pyoOFiy1hOXC1INz6xBvl7gwaucXbXOnv8g?=
 =?us-ascii?Q?T+/NdRF5BGTjGivWdKTCsliWVYd2L/3i9x4cAGTuc4134A6uW1JnGSYqmUZF?=
 =?us-ascii?Q?5Bhgf+AlcgDV68hasH7GbBPKAyCeLiXPP4Vc6okkHqT8sK/V+Ar2oftemZa/?=
 =?us-ascii?Q?UKjNnnI7upTNt0xuafUxMXlnDmdSCr9WPRu3clyF/W5SjZ0rWQ7vRQhzpLwL?=
 =?us-ascii?Q?8/EcnWHC5n/nv/vSyERntyz+qKM9xixnm3bWym6QQFF6/OsdQNpw1fn31eLi?=
 =?us-ascii?Q?92Sxl0mQvAsxeEoffZjQem5HfaOhlwE9AbUfu65fptv+Y6vsYppi/TrAMVuc?=
 =?us-ascii?Q?7Chjt/t1qtOYQIPn/1QSGpRYxKZYGc8l6Dqm/ecfG4UTbjf6Nfe9AK+4qQfa?=
 =?us-ascii?Q?UOGUSvVTWKrVxZL9IuXq3cCXY0gwjeqo+TRkFoF5z8/J8+04ltsWCn2VSaZj?=
 =?us-ascii?Q?ahGK8az8ILdRKUq5nuINA7TVrK7sF+hO9SxTV/L171JRm0eec5d00TPE8EH2?=
 =?us-ascii?Q?vMEyvsa6uZCgV5e6LbxSIb7Sbtv6gg6miUPTV/qVnsC7YVYhm3rKDvUkaj29?=
 =?us-ascii?Q?IHY+CR0NZEn7OrHy7Edbsx+7qiDTsegVCMJjdbjyvpAnyDS7FMOcHp6z6bEK?=
 =?us-ascii?Q?apYg+N99d2YbmaR8Q376e/TMxqU3b0bKQYEP8wnDXSLVxONKqndq8uTTk4l2?=
 =?us-ascii?Q?RQfwVrLLShO4cx5r8UduqPKcn2HjAGljCfT+LXjQHe8dRwDmQmTva9fX5qtV?=
 =?us-ascii?Q?9dIp6ZY9YpCihc75TnIpAMTZPcTG5TK9NRe7FCkTALfcstAJmflSLifPA9f7?=
 =?us-ascii?Q?iDqVT5ka2LHjthm2EAfz8gkZH3dM9p/jMM4CoIpCctZBJ7GWoVrzAnQU8JW2?=
 =?us-ascii?Q?GilfyCIuWe/XKn/DtyY6AmPQqXTbX3+zXUfqAmMAsBbUI3K2DaQ3bhMsuTIn?=
 =?us-ascii?Q?Hxk2W2SovqE/c0mXqe9avkU649121c8sQAfK5c7M0O2qsDSULoee6TAViITV?=
 =?us-ascii?Q?hxi5HrFRNZ8MKk0x4jF+2AUwk92Cb2tDi0pT26XHODwJwzX3FHtVAyZVIvHg?=
 =?us-ascii?Q?51kQFE0uMj0+2o3zCq3p2yASkX5TGpdVYCZLdj81bhCGx3hHsr5oF2zGaWF6?=
 =?us-ascii?Q?ZLeP6+KcmPq8k1F8TCenO02FKagzxvxYAhV30HhZPWGkUw5Elr6+zU5I95Jg?=
 =?us-ascii?Q?uGKg70yyQpzUZAY2RRGrKa9dj4GuYj3DOHKGiypUNRGgsj2VI91/4zFzHz2u?=
 =?us-ascii?Q?98wANvGrd0hP1soPJpMwmn2ohp5fkV/Vy05UH0wkbO+hLL1OOsOYx54vSbb2?=
 =?us-ascii?Q?+sG7FexvE55FrRhc2Lx6H5rpAoBkBVnh6iWc?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2025 09:17:48.9472
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 75d4d607-1c45-4f52-1b27-08dd7d90b90d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055E0.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPFE3F7EF2AE

In preparation for using find_highest_vector() in Secure AVIC
guest APIC driver, move (and rename) find_highest_vector() to
apic.h.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v3:

 - New patch to move KVM updates to a separate patch.

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


