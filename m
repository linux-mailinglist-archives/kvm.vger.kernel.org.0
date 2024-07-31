Return-Path: <kvm+bounces-22788-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 21A519432DE
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 17:15:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 71C26B29DB3
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 15:15:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 356161C8FC8;
	Wed, 31 Jul 2024 15:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="rKBL4Tvl"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2048.outbound.protection.outlook.com [40.107.220.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0AFA1C8FAA;
	Wed, 31 Jul 2024 15:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722438574; cv=fail; b=H0p1JHgBWzonS8Csw+F+Q87PLtZnx/El53OyEdCcDEj0mE8Dlqe3SXm0s1RE7nxvIv8V0h1R/8Tv1cXNf3MKJ9dKph+sRIq8jmAFGF1UAglKJ8pJ21HQ8oAb91x9AiA0mgL045pbzA61x9r4lOyC9xHAvDYXgABflXZIjdYnsXk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722438574; c=relaxed/simple;
	bh=ItwoiZD9LvgFRJA2ybGt2PhIvRzdO0LtcWvnUMsPZdM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N9/o2kXmH5UPnTxM1ejmStfFIuAWaTMV+Hl/VTFYkwLHxwepiFzxdxTFPSDHMG05Me5LLOpEKiMVb0AJGF4coAC+y1kwcjPz+Fe9rQTfBXsm5ULKw6Ov46FnxiLhDToIGsRLLijZBlOyBOui+AlOynamYhWRFMqqQGE02pFFUwM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=rKBL4Tvl; arc=fail smtp.client-ip=40.107.220.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TxTDZsIV3WoYjzD8+1ES8HkOoZkgJdBy1hM5mTVGA2n159xaRzhr9U3+Dyp0/oFUmsF7/w+5/E/EPAF09dYWuT693f+XmAxEDFwTtjdrzVnyqNYmIxfWIrxPUjOmtzPT4ttLBcRmNSjVRJM2kyRh27+t6uvQeTzzOZCU/iUoph1yk0ZXgEKxE3zGwdKIWIL0wPDBnCegaDfMMeFEPXynlwaF1fumQyUyhkzWT40h16Jg4PMfIKT32A1wBPcAAgFL1dqNOwrGXsakFavdLI0Ee5JJQFrJ5OroLD3QFdLC6iYvoSC1N8Q2ccIP/Tlvgg3EbPvbQ0XxTQXmljYaK+TdMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TJ2QdKOWRkpeQDBq/qhe8xRHxlc7lUFXXHL1l+Uqt/o=;
 b=ddms13Q42lSYABp50Su3j7KJpLmIkxh9Tx3tBa6dxyLAbEBM5YILDTrVqs+EHHJHQFc9VAPJTTj4S6+4qukD9ddG2iudcGtGqtnf+Tw9ZGUZ0QbP742FXHAk3+MfB03FS4Ma9Pi6Y9IyfebYSENdOrcdg6UB9d/Heh7Ik64Kggc35INK5KyQ0oU4B/A4ZuDiHfEEUXrG3YWPORc1QDO5FxT6nhAV5azOsRmxrL3VwvjALrIN8hyq8TPA1kRLztI2V5pn61FUFLAULi8RpiAG7eSmjcieX3B0JYaHmW7A7axbbTyheuJrm/E50OI6ArgjJlXqcjvTFPQ2LwpnUO1DtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TJ2QdKOWRkpeQDBq/qhe8xRHxlc7lUFXXHL1l+Uqt/o=;
 b=rKBL4Tvln4RRRau9mn+rvYe/VJuHf7G1zRFMgnsn3N+q7AWVfQmRXNsEBGyaK759Iu5FAWSellJexlTpseiZP5pM4ltHQTgj5TZLUTrpUSVxsldACZ7e0Fbqv9hoK1+396INPA40J/56YMJjnK/DEpGrSwIVVPn14P3QKR99xyE=
Received: from DM6PR13CA0009.namprd13.prod.outlook.com (2603:10b6:5:bc::22) by
 DM3PR12MB9288.namprd12.prod.outlook.com (2603:10b6:0:4a::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7828.21; Wed, 31 Jul 2024 15:09:30 +0000
Received: from DS3PEPF0000C37D.namprd04.prod.outlook.com
 (2603:10b6:5:bc:cafe::9d) by DM6PR13CA0009.outlook.office365.com
 (2603:10b6:5:bc::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.19 via Frontend
 Transport; Wed, 31 Jul 2024 15:09:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF0000C37D.mail.protection.outlook.com (10.167.23.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7828.19 via Frontend Transport; Wed, 31 Jul 2024 15:09:30 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 31 Jul
 2024 10:09:25 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v11 16/20] x86/sev: Prevent RDTSC/RDTSCP interception for Secure TSC enabled guests
Date: Wed, 31 Jul 2024 20:38:07 +0530
Message-ID: <20240731150811.156771-17-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240731150811.156771-1-nikunj@amd.com>
References: <20240731150811.156771-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37D:EE_|DM3PR12MB9288:EE_
X-MS-Office365-Filtering-Correlation-Id: 751e721d-873a-4cdf-bf99-08dcb172c70a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?R5m2LtzmGRqFgl+4G9BBNkCOo5LGGtYS4/v/NGEriyFO3CxLKgWYlWLO5inZ?=
 =?us-ascii?Q?Wjbo82aEcKC+0FbNCEqFw5hhFw3Tr8o1jzBur0q9hIi3lp6Lro6Xtsr/5Jui?=
 =?us-ascii?Q?1bvp54EKnpKZHkPnpnaC217JicSg1O/WbI6G46vHSN/ZgNTt7ZU5cKfGnua+?=
 =?us-ascii?Q?Xt78wkymoDGhvw2XEHC9gKqFAwRyUQ5qsTQ7W46q09oXlji9gQVP5mbE4wiv?=
 =?us-ascii?Q?guxo3xEIqYoksw/0QFHiLp1dP6jVG5tzggUVSFS86aBRz0nS+w/HiiRxjClg?=
 =?us-ascii?Q?/aYAwOZvMyKQPzNpkgR7OsM4KwXIi65rZQW3JiJ5Xt1ZMqQCYrtwZYrwJWA0?=
 =?us-ascii?Q?NU1dNTxT+y9Cv+si6vVKtl3RZndPsiwDT2OSuydNt04k1PBb27FUeg5o0YnC?=
 =?us-ascii?Q?UQpuAVZHK+M3yYei1UOBVUwAXyxe5F6Dv38N2c0kvNas3KDe2jTDoGN3vc/2?=
 =?us-ascii?Q?y0dgzJE1yZdSA8L52YMrvpiLKwWSiqEXsZDNrlgCn9fqT2/cGFeftMFIHWuG?=
 =?us-ascii?Q?BUoIhX8LTUfCUKUAyWEqIvNEde3nuP3Urv2AlwroVKHx2CZ5EDoeHSYUviuB?=
 =?us-ascii?Q?Oq9JLfTAOiCTEfoxTh5vdu0XhYXZvxzDBfL2IM8/mEz3KFaqyOfsarc2LjxE?=
 =?us-ascii?Q?huXgcjPZGDrffeFLtmue8jh+pzNtgXIGdfCCIOsTCP9oaoPYUsZ9JPwPH5X9?=
 =?us-ascii?Q?cq2v2msNHEsvqzigwWTEEVgRqDUgd/FGS8VcsRdFAuLXV+ArnOgBL157uRgX?=
 =?us-ascii?Q?OTEuc5pfccuItcSgxoPdbpB3bDjpe2lKC9jrbmOkGUIW/dvkWZpFztB2k9CH?=
 =?us-ascii?Q?NTrxriMwL4dv6pgc5UjT4TY2d6Pony6NhkHkWnChdpXdvlRU/w/vEVa89xbL?=
 =?us-ascii?Q?uVln3xz7z1FISSV0q2oZ70RWgdaHwFW/n5dp6ab87nDtrzauszfGdS84nq0c?=
 =?us-ascii?Q?G4oRKnrmno2Z4uvqg2ko+wq8xz9VkJq+F/H1L5MkbRU2ZeK4lWe7pwiL4T0i?=
 =?us-ascii?Q?FM72DtN4Q2BMximPzDQW3O8unm7MUWENash+1DtTLWw270qeXhdLajshlaWF?=
 =?us-ascii?Q?9o3BAxedvg7DOPVtVvvHEKwqSBODOvCS5f1bjVb+5Nhe5h1uf8qXp/WAmEND?=
 =?us-ascii?Q?2jJRs6s2a6r1Qsmd+yobUznogaN8VvI78JixVYDidq0alnEYgkMys+Mprrkn?=
 =?us-ascii?Q?us9TyXmxgGYqsvG74C+9p0oOJBTQcneYBsoXmIZ3x4BOgFNpAIdHTlKrYoi/?=
 =?us-ascii?Q?oLx5yAOXn2sYh3ht1iFkEhRbdZma7O0/fRSTFMWnneKlE+cuftZfLYOsLmBe?=
 =?us-ascii?Q?dznQYkVxpETcl9ZJXxtQp4wCOYBUliLps10tapUSPLLAufq05//G1p0qw2GR?=
 =?us-ascii?Q?gDcFT7FotnQ8bqc5LZP4uFEtxETV6hg/GlX8r1Znjea0qMzeGGNQQvT/+KZ1?=
 =?us-ascii?Q?3QREBqVMP8Q6omj09Ux1Bw2oV2sZEn3W?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2024 15:09:30.2432
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 751e721d-873a-4cdf-bf99-08dcb172c70a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37D.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9288

The hypervisor should not be intercepting RDTSC/RDTSCP when Secure TSC is
enabled. A #VC exception will be generated if the RDTSC/RDTSCP instructions
are being intercepted. If this should occur and Secure TSC is enabled,
terminate guest execution.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
---
 arch/x86/coco/sev/shared.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/coco/sev/shared.c b/arch/x86/coco/sev/shared.c
index 71de53194089..c2a9e2ada659 100644
--- a/arch/x86/coco/sev/shared.c
+++ b/arch/x86/coco/sev/shared.c
@@ -1140,6 +1140,16 @@ static enum es_result vc_handle_rdtsc(struct ghcb *ghcb,
 	bool rdtscp = (exit_code == SVM_EXIT_RDTSCP);
 	enum es_result ret;
 
+	/*
+	 * RDTSC and RDTSCP should not be intercepted when Secure TSC is
+	 * enabled. Terminate the SNP guest when the interception is enabled.
+	 * This file is included from kernel/sev.c and boot/compressed/sev.c,
+	 * use sev_status here as cc_platform_has() is not available when
+	 * compiling boot/compressed/sev.c.
+	 */
+	if (sev_status & MSR_AMD64_SNP_SECURE_TSC)
+		return ES_VMM_ERROR;
+
 	ret = sev_es_ghcb_hv_call(ghcb, ctxt, exit_code, 0, 0);
 	if (ret != ES_OK)
 		return ret;
-- 
2.34.1


