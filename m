Return-Path: <kvm+bounces-56106-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F144CB39B9F
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 13:33:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D9CBA7B82EB
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 11:31:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12ED230E0DA;
	Thu, 28 Aug 2025 11:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="n8o/vqmj"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2063.outbound.protection.outlook.com [40.107.94.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D72CE17B425;
	Thu, 28 Aug 2025 11:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756380784; cv=fail; b=ncyqUvxHyNF5ZGsjCP9cSGUaEbAMtPz3naa39oGrmh5pKqdgrVkxyLlFFcHStIeRsb3ddAIaMQFeGrRKOeYYtvddOZ/nqjcfza+17paNg4dCIUVgJlVJJVkDv/yfrk1NZ/rbigb7gm5xlHd5LsG1dLDy9qulgTtTmLUdamu7KRg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756380784; c=relaxed/simple;
	bh=kEFGo6UkEVJ8J39eb7Pc+sEY0HS1spHZSXMpTg4JOAg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DFCYqv9SRRBo1adUIGDh7cYU4oY7OL3ugGdRMrbOE1JqEXrjqj/+N5x6Su3TD3JiWBKL6HesXdrWEF2YyHia+CMtlQ0xy/qXaSEWUJrG5+oVixtRasCvHNeTrqJOyn0ElFJ5lI0wH9I2HznDnSO7oOsrqUscmvj5t/Ft5tk0koY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=n8o/vqmj; arc=fail smtp.client-ip=40.107.94.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HFl3dgbTXOmv4QUEJfFuSj47M3tjASc77c1cgsa7yrwhzFDipFneTc/ZIgFYKNQ4b1OfbqolD4QEOVcabMqrYy4wnj7mSNiregXB7pV32qyOrIRQx/gkYzEDNE6NNlFz6jfL6Ndm2SOd9EZeaG8RJaHNwfBaQpFq/3I/NmrvQm1m6q7GLhfIeBQYQriSYWT0eZUwQQrzibTtqFF74iHF8zyApkqAt3GQzHvQOu0dJ1d2T46G/Thu7HImUPUBiU5kW6vuL1O9plp7ORsABtGfVESqeeL7ZdcM1xgQ+3IthfB1VbPtHCcOoRNgNI7UJkFCZHVV17yyKluJxjoTK0TV5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+wTEez2USC4uHvgMcy84vr/TZjQpc9h0pejcq/wtQHs=;
 b=OmVsZxZr1uYCQIYxArp887lBrKRv9nJBRWtsjtH33ZKG1aONdACkOwJSUh0ln3js12L1aUdaFqw3x9sQHoEu8nbBxOUXCqaCe7bxKBeqtTrYSVweXyIZ5VFzbFubU9QxGRtxURaGymPOq6wW0HP6jDnwHabtJ0rRj1Rf7rhCfBp+j4j8B61bys2LupqzngoJnzHdsVduRC53lJa8kAqff/oyAWJk4JJiXD+mxrYt8abjL1/FM8Hi3uO0c4oDPUm6O+2trYIcxp3v/+OtcpoCa7eBSlupIbRhXKPZjHHxQIK8SO/umti+MWKBd9ODQm2YlIk2RsRBUhpHZDT/u4p4Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+wTEez2USC4uHvgMcy84vr/TZjQpc9h0pejcq/wtQHs=;
 b=n8o/vqmjgnUmdfUD3vU7EXYpJTt3tBE6LEOpoQ/cTwDeDgi9iSY51K1wE9Vs74bPyfk5Jj2FXhoWbjHPzFYocRq3nWbRFyzBuZjA+Fa3EIUuAJOhrqyIfj8/wx+8vAoZb9z3bkM6E7MU56huRZdL6SONxgDLPEB41KMe9xCVl8Y=
Received: from BY3PR10CA0007.namprd10.prod.outlook.com (2603:10b6:a03:255::12)
 by SJ5PPF5D591B24D.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::994) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.16; Thu, 28 Aug
 2025 11:32:52 +0000
Received: from SJ1PEPF00001CE2.namprd05.prod.outlook.com
 (2603:10b6:a03:255:cafe::f7) by BY3PR10CA0007.outlook.office365.com
 (2603:10b6:a03:255::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.18 via Frontend Transport; Thu,
 28 Aug 2025 11:32:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CE2.mail.protection.outlook.com (10.167.242.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9073.11 via Frontend Transport; Thu, 28 Aug 2025 11:32:52 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 28 Aug
 2025 06:32:45 -0500
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 satlexmb09.amd.com (10.181.42.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1748.10; Thu, 28 Aug 2025 04:32:38 -0700
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <francescolavra.fl@gmail.com>, <tiala@microsoft.com>
Subject: [PATCH v10 18/18] x86/sev: Indicate SEV-SNP guest supports Secure AVIC
Date: Thu, 28 Aug 2025 17:02:24 +0530
Message-ID: <20250828113225.209174-1-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250828070334.208401-1-Neeraj.Upadhyay@amd.com>
References: <20250828070334.208401-1-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To satlexmb09.amd.com
 (10.181.42.218)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE2:EE_|SJ5PPF5D591B24D:EE_
X-MS-Office365-Filtering-Correlation-Id: f92383eb-b0f3-4b9a-6e63-08dde626a042
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?U6u2A8N98aF0oj/xls0DVYCr3tUOktBImv6Z7DQyt/nf0ZkOpFOw5TnihmvU?=
 =?us-ascii?Q?oo6JqY4vrYVykMJZE73RHzbozqhrgdNtbg7RbV1fyDNHLr+8T/L0abt7vRDG?=
 =?us-ascii?Q?F/+wUdqhyu9pzXQ1QtgdYasHCJr5U56oh7ZnRFNq1Dg25/V1MM327XcvTuBS?=
 =?us-ascii?Q?tdOJ3vMSKSh+LC44CeEOSK2Fbmndtt3yy7v/pOSnJXAl2X3C0fTxvT0LloWU?=
 =?us-ascii?Q?3GPouu9JDDtH1b2f817DIxz4CD+n1vq7/8O37+V7LYpWy1SREhYCMkSrvkmw?=
 =?us-ascii?Q?IS59/2NlSvHQrPohBo9yU1mWayOF4u4OfAcUH65l/u8dxt6Gf4vP6AjRA+K/?=
 =?us-ascii?Q?uB3ia6TiP9tMZQSYBDeZYRrb3nW/sQgycKFZk8Bxhnc9Q70CMB+y/3cyAbml?=
 =?us-ascii?Q?lNQczt/Wl1eo3Ckcd3RhyuDnyIVDxjQPg6n+1/OZTLn75bMDr06Zs2qJCTY9?=
 =?us-ascii?Q?5BjFjT7S7JlttV9hfKxpzSw8RliPwZzrgGGd4kGl0goZAAlyHu4LBSr/M5tD?=
 =?us-ascii?Q?yk8t8Pj/8429s8QfLpZ0Ih7JI5c5gveRcoThXonOmuP7a1iovg6KSKZ66eJj?=
 =?us-ascii?Q?nQh/5ZLwpIFtvfN4P+PtGuO1QRuyVzFJnFyXMEgRcsyTJReepqScO+yfhwp8?=
 =?us-ascii?Q?f7EOyYrY1n+o4/Q/p+/wQHCW2d2ifl4d2w2zltKCN5frCsHKOJedmffmb8d+?=
 =?us-ascii?Q?If/RUdD70BjvLTq1LHdccl5LYTP4V12K7sfXm6VQo2NwOI7UomyCQqdL7ELK?=
 =?us-ascii?Q?KwKqBZpFy44Lj2i0OUK70egydT2zzHABdYrPDk7JNUXlyld68JfCsVfGuXrK?=
 =?us-ascii?Q?JOI/qjEbA+m3NYm63Zm7ostVLgn2XWnONn24CFGWpuQYAB1xbX8IRf6sOdR8?=
 =?us-ascii?Q?9PfYWsvMAoH7RYKrVH69SbITBxovZhODT/eqA3hsxrp1XkJJ9mpSu50iWWyB?=
 =?us-ascii?Q?oZskrG1zEU4msIB7EfYqJzYS6TwZrb2urF5b47UGpwN9JOgPvLBQ/+8sWy8b?=
 =?us-ascii?Q?FfcpmcQyAAp5XUnw8vSMbxViOKcK9rhe1zjg79FN5cYkyM3z+uT6AB/Qfq6H?=
 =?us-ascii?Q?gZdhDC93a7vjl32gKMg66qF0iUm+TBFyBAmLvAKTHZBj1oAYOJt0I6mLqDR9?=
 =?us-ascii?Q?DpEKcx1XF7WICbkaNiQWHvYRjGA8C18aGcx9oigFjeSyqiLoDa00MhZsdXEH?=
 =?us-ascii?Q?MwXFrY2QQd6o8HVL4JEDKD+uCsvP+kYDI05n7FGKRL6yI7oWvzRSQDsIFPmn?=
 =?us-ascii?Q?GnYxTzDueRC44aP5YK9KTGzqSz3QDjMGcqoOcdY+42gjyzYuLpIAjW4Oa6D9?=
 =?us-ascii?Q?IcdpAiSp0wgmTtQtZA0RLf8NmyPHUFo/UfsD4jtfz0s472OimiGpX2Md1Tc/?=
 =?us-ascii?Q?rCUGov+MtiEmaG3J74vUVBdreEJcfPbzMUOgK4Yv5BFm6kryoXGDxjckWouI?=
 =?us-ascii?Q?tIvywaCVm6rSrAJRU43SvCeENsxKmkdjDzj5PGU1H+SF84XmnmKrG4QKxEEw?=
 =?us-ascii?Q?X5Iqt/E7NCaiJgGjangMgmIntPQyhTCK0sYp?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 11:32:52.6989
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f92383eb-b0f3-4b9a-6e63-08dde626a042
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF5D591B24D

Now that Secure AVIC support is added in the guest, indicate SEV-SNP
guest supports Secure AVIC feature if AMD_SECURE_AVIC config is
enabled.

Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Reviewed-by: Tianyu Lan <tiala@microsoft.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v9:
 - No change.

 arch/x86/boot/compressed/sev.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
index 74e083feb2d9..048d3e8839c3 100644
--- a/arch/x86/boot/compressed/sev.c
+++ b/arch/x86/boot/compressed/sev.c
@@ -238,13 +238,20 @@ bool sev_es_check_ghcb_fault(unsigned long address)
 				 MSR_AMD64_SNP_SECURE_AVIC |		\
 				 MSR_AMD64_SNP_RESERVED_MASK)
 
+#ifdef CONFIG_AMD_SECURE_AVIC
+#define SNP_FEATURE_SECURE_AVIC		MSR_AMD64_SNP_SECURE_AVIC
+#else
+#define SNP_FEATURE_SECURE_AVIC		0
+#endif
+
 /*
  * SNP_FEATURES_PRESENT is the mask of SNP features that are implemented
  * by the guest kernel. As and when a new feature is implemented in the
  * guest kernel, a corresponding bit should be added to the mask.
  */
 #define SNP_FEATURES_PRESENT	(MSR_AMD64_SNP_DEBUG_SWAP |	\
-				 MSR_AMD64_SNP_SECURE_TSC)
+				 MSR_AMD64_SNP_SECURE_TSC |	\
+				 SNP_FEATURE_SECURE_AVIC)
 
 u64 snp_get_unsupported_features(u64 status)
 {
-- 
2.34.1


