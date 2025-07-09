Return-Path: <kvm+bounces-51864-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 24FB7AFDE70
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 05:43:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E85FC1C23B3F
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 03:44:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30BAA20F078;
	Wed,  9 Jul 2025 03:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="sWB9ogHd"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2075.outbound.protection.outlook.com [40.107.220.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0B8A1F8EFF;
	Wed,  9 Jul 2025 03:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752032549; cv=fail; b=PzGs9irkYmoLQ1P73G2lggw0Xz2Xk5gZS+3KjpEF7viBxvicy18kJUeMov7AaaWFpRM4D9gMMJSQIls8+TsiUjDvbvya2gvAa04cghqgYJkqQ3PGKIszQFVhjyvFLiPmS8a4G8WLhUy6AWLleYymLvruDseP6iEOBPABJo8ziOs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752032549; c=relaxed/simple;
	bh=lPt7O1AwJatIgr8ZGbIkNkDk+ocIJs/sxg8wHHbEu+U=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pCzh//Hav0g3pFNZUX/LNFJA/hvyvXF76t/CV/sTWRpEwYyiGjEXRREVlMyHdLgoqilptOVHqLZj8fUNXWPpKYlCUALyWzVH+Z/d4+qKVshp+u0GHvNhPZ44liZPkWU8Xn7EU26XeRRHKs+yVqz2C7kGgspkdjP0Y5WDdTpcnrM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=sWB9ogHd; arc=fail smtp.client-ip=40.107.220.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QrvMfJgIlDHWzeu2vvW58i5FUan/ynPcUuRUMqDQNUQjcVNzWInvZkqpnxQ0w5SJpUSxp31fR7pWjdtA3J13Bm4+dPl2McXDM6GlQwPTEtRFL+ml/v34xSsVqy0ROKSzeG1ybo+fe9/RiR7XGJFY4J7W/nIw9X+4IgXbNAbP3+V+9I7nIQwspV5hdaT6pc5t97WvjUzCpqY6p5WSv+rSO9xOdlDwI/6DXHsMdM1psw+G75tfBg1D8JkYLCaV04LEzP1TjX7slyvGBGDT+NrhJ+8EfOMxfDccBHxUT8bhea97UZS7ccQyyFr3wSzbpuonlDupuUgpyku2g6pCE0lHyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HL6Q3aCkl3q989LjelpdlTCSdSvoNpBFNmip3BshRis=;
 b=qwsODzVK7ZEJWKVExed5VCBfkjE1H2Z68+bBXL4EVbaEPfow/JqRGjD5dHjQ/lI1PXhOcVl8WEI42DwQRPhWZ8SZGkjsoyl1Cd98sf9y5tEl5LnoHv7UZ3P+1jv2wtvYIt/AUw4V5lbCnGB5Ds7xoLzy499RJhSp1hXpRKZNEl+KC3d6fRz9vxUMouG7ovXuoe2ts1plWUK6dztEXClSorF80U2ueqCOFqzLvWuj701rZiqb16HlFljJMVRudacN6Zy8Q/nsaWmp3cMNTPdSMvm4VKmlX36etJrU7PbhByks+iaCQIp5YYXEZgiKf1BDmD3eeKpNM69jKDmo+EEyOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HL6Q3aCkl3q989LjelpdlTCSdSvoNpBFNmip3BshRis=;
 b=sWB9ogHd7nmdlQjdR46IAgvRD/WvqNE83GnDrBtuSu2thNY1x4GHLIhfImvuDjlZnc7LQnmXLXdMw1qiBMAspyrDKbi3bEPShb+QpAp/l3XTLGtHqz9kjAGOH/9j7snpuJ9Vfa9fA2TKkRiLxpbSIUDgkXsfWklHPTm2B5QEVdo=
Received: from BL1PR13CA0222.namprd13.prod.outlook.com (2603:10b6:208:2bf::17)
 by LV3PR12MB9355.namprd12.prod.outlook.com (2603:10b6:408:216::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.25; Wed, 9 Jul
 2025 03:42:23 +0000
Received: from BL6PEPF0001AB4E.namprd04.prod.outlook.com
 (2603:10b6:208:2bf:cafe::fe) by BL1PR13CA0222.outlook.office365.com
 (2603:10b6:208:2bf::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8922.20 via Frontend Transport; Wed,
 9 Jul 2025 03:42:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB4E.mail.protection.outlook.com (10.167.242.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8901.15 via Frontend Transport; Wed, 9 Jul 2025 03:42:23 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 8 Jul
 2025 22:42:17 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <kai.huang@intel.com>
Subject: [RFC PATCH v8 30/35] x86/apic: Read and write LVT* APIC registers from HV for SAVIC guests
Date: Wed, 9 Jul 2025 09:02:37 +0530
Message-ID: <20250709033242.267892-31-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com>
References: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB4E:EE_|LV3PR12MB9355:EE_
X-MS-Office365-Filtering-Correlation-Id: 67021ec0-e05d-4eb2-3fb8-08ddbe9a9d9f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?K+/a/ANKJkxz7ujuUw2gcaJLPAQPJPZ+BlwKkby1jptJdgBHl2cbX2RpbFXB?=
 =?us-ascii?Q?ZB0Id+FNvUWxGUMfJrUpncXEtl87DK+T9vaoNwogHkw9e6BYTzxOmnFYmXRk?=
 =?us-ascii?Q?droHZNU5styFxXOcuVT1cL4vDy6o9PYiuppN3wmQvYiHbf5ikId3czkdfpFi?=
 =?us-ascii?Q?F7FyP+Gcz0RDwYedN5XVqDj7w2hhVsCy4+lvA1oMXnu5qTKiGI3/xG2wxujF?=
 =?us-ascii?Q?cDL7kkXherj8S40vEramEZnjeAVGfQJIBR/TJIzi0CMbPEZICSlvH4iCB319?=
 =?us-ascii?Q?SH6PckiNKCdG+/Qm1L66nL6Tx2faZ/H+Suh7uX3dmxG9Ap8V60UJs9rIyEdT?=
 =?us-ascii?Q?8Oc1W8/tvbl48QnKB2c2UHh9gJuA81c//Wgg7Df7YcRnl42+BaP8x8wTgKIB?=
 =?us-ascii?Q?77D8Gg+qbXp/B3bB+m2itI3OpoACrtUEhEvNFnIlQhy71dP57H/lshxraZ1n?=
 =?us-ascii?Q?ZFb86huqT1RT2i/DoyUrrrQuhwJ2njSuNJY9xwRtvagKgZXlwGs2LzpPyhv8?=
 =?us-ascii?Q?T3Xdie1BxqKvRUBEZdvnqwV1+h8cRjl4izy9uFarUIEEiWx1E/CmZ0KWa9Ed?=
 =?us-ascii?Q?c9tKK/v2ULm8GxHNlgAvzHHZIyF4/+I3ZJxQbJpz2PReIhly0ZKRszxl+beL?=
 =?us-ascii?Q?CfSR6JFEy/chlwAbe429byJj5GKaMdItoYD75EBfGEUXofnEEDUsF1RnnA+5?=
 =?us-ascii?Q?P7I5BPfzZRVqKJ7nNWUdRJcknMt3VnHLu5eqnSneiYojFxbfP1GEMsNqsgIL?=
 =?us-ascii?Q?Nqd5K6/Y39LoOrKNXgjwRZgQYVf9R0g7jMViIevYhCovY8yjdWT9K+sdPwXW?=
 =?us-ascii?Q?G0VxfjR23ZKrYu7yuDbYUO1dRh0kGkt5BGd8A3r52OzUamWNS1Wl/r1fnNhL?=
 =?us-ascii?Q?eTZkRDpuPFikszNhCFAzUcYq23lvHxerJlZ8KYQo8ZmA+JNFU8T+E4QtpqKk?=
 =?us-ascii?Q?oR2AKsePmtsmSSzrxKwu5eTPYLhYJ5I5vTltLZxxU834006CFd92PRWGBHcP?=
 =?us-ascii?Q?025l0Pkyw2ZG1FS1hg3PA5c/2zZKqvfzGbWltF01kkyU6mN7kJwQnlFCzfLZ?=
 =?us-ascii?Q?/+jVPbaVCQ0qbdyrDxX36viK6sDqTl764rHCcIH3UlsSVm47BGb/2wgtV3Ah?=
 =?us-ascii?Q?jM2RgTGne3v73BEoqm42ORZgoLs4pLQ7cTsTvyCmXni1xy2RTE+RmWzlpidn?=
 =?us-ascii?Q?EvDHQgEua5n5gF3Mu/eaRggy8orpTZAi2Nzxr4ZfQuhQ7Do0wpKY2SjawDFx?=
 =?us-ascii?Q?JAZKM4BQzAo6mLEg4Gk6uREotc5V8Mxr3aGyEyk339kLG7J72K+6JFabpocP?=
 =?us-ascii?Q?JvwZqFIOLddoCY96qIIVmkHRpeW6tdnuWV2BLxgDbU1xU//Vlzw47mXhi3WO?=
 =?us-ascii?Q?xO066vP+TQTLUC/LhZoBaTJZEyjjFw4n+XkZoeZNsW7VsWwjZCHgz5UqYZWX?=
 =?us-ascii?Q?VBNfbt/YUL+yYlYPyRyrQxh3agI3+VPMfC+4khWdP+XyXhQOwxJrxNedtO80?=
 =?us-ascii?Q?YB4VNnArh6fQT3wdGfZITdMAalOsxh3ezubw?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 03:42:23.4739
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 67021ec0-e05d-4eb2-3fb8-08ddbe9a9d9f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB4E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9355

Hypervisor need information about the current state of LVT registers
for device emulation and NMI. So, forward reads and write of these
registers to the hypervisor for Secure AVIC enabled guests.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v7:
 - No change.

 arch/x86/kernel/apic/x2apic_savic.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 583b57636f21..0fecc295874e 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -69,6 +69,11 @@ static u32 savic_read(u32 reg)
 	case APIC_TMICT:
 	case APIC_TMCCT:
 	case APIC_TDCR:
+	case APIC_LVTTHMR:
+	case APIC_LVTPC:
+	case APIC_LVT0:
+	case APIC_LVT1:
+	case APIC_LVTERR:
 		return savic_ghcb_msr_read(reg);
 	case APIC_ID:
 	case APIC_LVR:
@@ -78,11 +83,6 @@ static u32 savic_read(u32 reg)
 	case APIC_LDR:
 	case APIC_SPIV:
 	case APIC_ESR:
-	case APIC_LVTTHMR:
-	case APIC_LVTPC:
-	case APIC_LVT0:
-	case APIC_LVT1:
-	case APIC_LVTERR:
 	case APIC_EFEAT:
 	case APIC_ECTRL:
 	case APIC_SEOI:
@@ -204,18 +204,18 @@ static void savic_write(u32 reg, u32 data)
 	case APIC_LVTT:
 	case APIC_TMICT:
 	case APIC_TDCR:
-		savic_ghcb_msr_write(reg, data);
-		break;
 	case APIC_LVT0:
 	case APIC_LVT1:
+	case APIC_LVTTHMR:
+	case APIC_LVTPC:
+	case APIC_LVTERR:
+		savic_ghcb_msr_write(reg, data);
+		break;
 	case APIC_TASKPRI:
 	case APIC_EOI:
 	case APIC_SPIV:
 	case SAVIC_NMI_REQ:
 	case APIC_ESR:
-	case APIC_LVTTHMR:
-	case APIC_LVTPC:
-	case APIC_LVTERR:
 	case APIC_ECTRL:
 	case APIC_SEOI:
 	case APIC_IER:
-- 
2.34.1


