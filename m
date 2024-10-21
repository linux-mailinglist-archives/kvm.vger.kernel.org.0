Return-Path: <kvm+bounces-29229-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C0CC9A59FF
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 07:57:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D52EA1F21268
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 05:57:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07C501CF5FF;
	Mon, 21 Oct 2024 05:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ttMSEz7m"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2048.outbound.protection.outlook.com [40.107.243.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F736194A60;
	Mon, 21 Oct 2024 05:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729490261; cv=fail; b=kwRMmIwpHLx1XgCS0Iy+mWPV69my+j1MdDbTgUBKqENr4G3DGtICbzSYb78Y4enswZehamro/vIz3Bjz8xKR6G9LzOXwpB3NoNTDDngORsApif4Lppgs+9VA0re1WGbBdT1M6kg3nqwMi3rbUgBuGhJV9zFTqJ2RpPOwI+Oypks=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729490261; c=relaxed/simple;
	bh=1tb/N/XYA2QDM6jWNRO5sgY6TP6MK3MiI+Q4wCE5ylE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DoTGsEcLHLtjBTYQFyITo/2uANpxrSHHOb3eYVbj2sCVcjCycOOoz4X1t2psjKF7uaIETwQhI2Vcrc5PPn/ywgFtBUwK6P9NsvlMoOe1qKS6X67QbSlyFSr19eEow77HFFnDvXMSmmfNWbQg+0Fta6hCtvFjI3Z0Nm1jGYF8eCI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ttMSEz7m; arc=fail smtp.client-ip=40.107.243.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hHHJhroJ47Ek4brxHyWsChB8vDMXVlk7Fn4dolX+KbOthdIGK+rO5ppntCI7Uyo80ZBJOiskcN6eu8dgVc3jdnuxifY++JADxS4Pxt8vAevVlWwTUE0rLQyus+3eOXQlHTuMwPtt1nGgO+Qhvb4NhYOJsnV2T6RxMnsfBUKqwRQ3Ku8h9YQcsce7cq21AOCen1+DDLeaCXvJso0U+hf416q8vNsAy8twRbxl4g4XVEAR6oiB+svgC1M83tq+aiRuWJUorSm2KNddJndRU2B6uM/EuqlRlA6UBtDUq+gofv4PRnR73f3TFmxpQFvUURbVClzA6SZALsBsL0LOyxYYYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9W27qD0UL+Ikfqbc4gMZqtUfFE1PGrG06JCyIX3HKL0=;
 b=nhn5AURCD2oocecHkyFQ6ZQy0DUKa2CUb1+iun0q3cxhwDtEk63/F45VuJFS/pUREqvwUPVLE90KDMxG9mN9Sfn4ep5huHRKRf57PUnobZfi58/moH84Q5j8CCkvQK6K7CoOVMWTxfqhI0X50RVLFq0bJ+JM7Vo2Z8Qwze03oENdW169ykeCdmKMGx85vw4VXgIkzs/oxReqyCBQuZ7bVJzDSAwyAFF1OTLn22vqK/1gLg1SQS1Jfb9k2BueIszEYDm6h5pRyZMn4wNq+WzYRm3Azw4/Sj7L4wxJToerm1y54lPrgOObgGPQ7mhzaX3KgmFe49MTB6V+KL0OPIkuJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9W27qD0UL+Ikfqbc4gMZqtUfFE1PGrG06JCyIX3HKL0=;
 b=ttMSEz7mMQqyBAmZvGEW/LC8YHVdmZE8r0hyKArbNX+805yCYcs9rUoSj5ibh3J3f3yIehu+M/geJ1lYRA6xV6vQ/eg9b9KHVocF7xpTuXEwL3u9Axe2gBagwGKIB/jd8tg4G8r5ix6czB/xvcxXlfbhoAHEtfF87/4OkTGs4XI=
Received: from CH2PR11CA0003.namprd11.prod.outlook.com (2603:10b6:610:54::13)
 by MW6PR12MB7071.namprd12.prod.outlook.com (2603:10b6:303:238::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.29; Mon, 21 Oct
 2024 05:57:35 +0000
Received: from CH2PEPF0000009B.namprd02.prod.outlook.com
 (2603:10b6:610:54:cafe::ec) by CH2PR11CA0003.outlook.office365.com
 (2603:10b6:610:54::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.28 via Frontend
 Transport; Mon, 21 Oct 2024 05:57:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH2PEPF0000009B.mail.protection.outlook.com (10.167.244.23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8093.14 via Frontend Transport; Mon, 21 Oct 2024 05:57:34 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 21 Oct
 2024 00:56:23 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v13 04/13] x86/sev: Change TSC MSR behavior for Secure TSC enabled guests
Date: Mon, 21 Oct 2024 11:21:47 +0530
Message-ID: <20241021055156.2342564-5-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241021055156.2342564-1-nikunj@amd.com>
References: <20241021055156.2342564-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF0000009B:EE_|MW6PR12MB7071:EE_
X-MS-Office365-Filtering-Correlation-Id: 5624998f-8cfb-4cee-cd0f-08dcf1954293
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZOUO/+2QBpkgNi4NRrqQsaAK8COr0ZWG8gmw2edOw3nDE48aqWlBwINbjT3z?=
 =?us-ascii?Q?C5HwdgaGY1Dx/jSyP8jVrMSqYN0M0XwjDhOC8ksM8xuJi2Q0I4wr/vj4pCe6?=
 =?us-ascii?Q?ePcfZ6ytQJ5Utqv/cbyiZwXQSe8yC+9LJeOedYTsNn0h3AlQ8fkq2cX7lce6?=
 =?us-ascii?Q?Qh1lrlhfy4CsaXTOukTKYAgZdTy4VY5CS3P9M1J0wvnEcWIxf+Snp3s5B/sH?=
 =?us-ascii?Q?vkdjCu++h00sHqecdCGG3VtBuU+b2OeuBsrNufLqYqxqPlt8GY9royA6dBtr?=
 =?us-ascii?Q?UUE9o48PtBA230yJzbGv6BPNuwXm/hrAvTDLRdvWcSDzTbFvxfwjdQMyn7JG?=
 =?us-ascii?Q?ynBQxG67F8f8ytc9OFYEdlJV0yc+LB1vwYup+PRjNAFbRxW89fZwfGvSkY8r?=
 =?us-ascii?Q?wtYDKxWT9hZHrCT16W0r6bZuiWmCWoGJOT77CSJBIqqSgbeHuMUO5/gYLSt2?=
 =?us-ascii?Q?dKSupzWsW5yPO7GMf5NpU92jAT9HckYgV0sCbih82QsbuIn2RqKn/9Lh5cpY?=
 =?us-ascii?Q?/9jDetBS8V0Tcjb6m5+ADvQ3YWGxG79MQ6q4aoCccT9B9F43XUdTsOpGCk1E?=
 =?us-ascii?Q?AgeRmFAkDmUIZFXki6bxLIayKR9FF9Aq2MsJO7hcalfTOJ9FAZm45nMtEv0E?=
 =?us-ascii?Q?Mw5FvFFGlmIfO89Nq6G9h5BBtXciaGcWhcpZjFda1FresM5l272qe3VHgWsq?=
 =?us-ascii?Q?OnN9SGd90+WJLMRMlh3L9G1IDgDOcHSW4lv2THWQx3FfqXEg/LRlQiw+G7BP?=
 =?us-ascii?Q?7S17GgPDiVnnvsIMd9s5oYxyrcfc1SEF0mqi4KeOhUrHQv47xmbmxD5JP4ds?=
 =?us-ascii?Q?xi6fE7cWSNdhx9TSkg7EgDy61reP+HiaJcRd716Srtrexs/p698Fgvdp8lTy?=
 =?us-ascii?Q?ymlskW0yqQo6+cLnpzJZwxuoEP0cyWlDIbXSrXAPaEpVPDQN2HORIGZXmP1V?=
 =?us-ascii?Q?WQ8u+fPYLU6L8VvbIMf1k/ZVuIvo6y2R6b65yGVhwfY0h7fNtpPVuQOQRkXn?=
 =?us-ascii?Q?O841WcenDBmiukcV44N9XmIvqZNatMNWSNgINj2tOeDmA+LZzNTqJexcnaCj?=
 =?us-ascii?Q?t8mL5NV93El4aTRR7iuBKKNY4ODAZlN8BecoCcqtjSXKIqoCWHHiLH6QztDj?=
 =?us-ascii?Q?bjnn074MXlpvdg9ByvQO2qQuJ+Bkmqbvrl66qPeXJP8xR2xyqk1UYuRFVi4a?=
 =?us-ascii?Q?waxC6fix5eZ4fWfViP2btN8QOUwUBGhPo6YKCpjE5BzNal15Cd+Pn5j5NSMO?=
 =?us-ascii?Q?T8ywX5fjO+3xCpxqF3ZJtp6IcJT+vHysL/kVkJ4lDH6lKQGeDox314VXRCsf?=
 =?us-ascii?Q?PHxv8wE4V6PBthW/+RrYH330nNV7z0wnKyO7SpUxTIn6ml3rJWX9KEm/QJ08?=
 =?us-ascii?Q?Kkjjuhaj6VGssLI6BB1IRjPw4Ks0idS2d//sSkbP1eOC1D0Wmw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2024 05:57:34.8390
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5624998f-8cfb-4cee-cd0f-08dcf1954293
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000009B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB7071

Secure TSC enabled guests should not write to MSR_IA32_TSC(10H) register as
the subsequent TSC value reads are undefined. MSR_IA32_TSC read/write
accesses should not exit to the hypervisor for such guests.

Accesses to MSR_IA32_TSC needs special handling in the #VC handler for the
guests with Secure TSC enabled. Writes to MSR_IA32_TSC should be ignored,
and reads of MSR_IA32_TSC should return the result of the RDTSC
instruction.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
---
 arch/x86/coco/sev/core.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 965209067f03..2ad7773458c0 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1308,6 +1308,30 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 		return ES_OK;
 	}
 
+	/*
+	 * TSC related accesses should not exit to the hypervisor when a
+	 * guest is executing with SecureTSC enabled, so special handling
+	 * is required for accesses of MSR_IA32_TSC:
+	 *
+	 * Writes: Writing to MSR_IA32_TSC can cause subsequent reads
+	 *         of the TSC to return undefined values, so ignore all
+	 *         writes.
+	 * Reads:  Reads of MSR_IA32_TSC should return the current TSC
+	 *         value, use the value returned by RDTSC.
+	 */
+	if (regs->cx == MSR_IA32_TSC && cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC)) {
+		u64 tsc;
+
+		if (exit_info_1)
+			return ES_OK;
+
+		tsc = rdtsc();
+		regs->ax = UINT_MAX & tsc;
+		regs->dx = UINT_MAX & (tsc >> 32);
+
+		return ES_OK;
+	}
+
 	ghcb_set_rcx(ghcb, regs->cx);
 	if (exit_info_1) {
 		ghcb_set_rax(ghcb, regs->ax);
-- 
2.34.1


