Return-Path: <kvm+bounces-46452-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 64A73AB6454
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 09:29:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 57C4D7A3B0B
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 07:27:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCD3A212FAA;
	Wed, 14 May 2025 07:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="5LeSew4t"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2087.outbound.protection.outlook.com [40.107.236.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF6B1E520F;
	Wed, 14 May 2025 07:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747207675; cv=fail; b=JTsyBYiM6Ls/OLeW9IUDaaOWcIWa51GxSYTuTh94DF2O2/dczpWCQF9jQ5MhVbAWYJAGhJfTaezl1fs0o0rCUlVyZ79+RNp/BjYssvL/wQxpl0f93ZEe29B9F+2ny/Xw4mYwsGZbMrxSlc5jjQhheC1qYBTc0n+jnOYFWRMyx8g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747207675; c=relaxed/simple;
	bh=Phh+n4M+bxPnaDCTNaYbcNYzp6zwQIzvdO9cS8zgvQ4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zkkf+ddP7lVQse73RppxaKColTXGccZi3H99QUKNFRe2pW4tUIYFoh69cku28dDNGcuyT3kUIEudBYLNfu+7w91WU/Hv1UrIn+PiPR22Pfki51HqcnvPDL4sSlSk4pW/7GvEm3P9VXPR9zcRHbZNLAtXROUrJATX7VCO4G3O+QY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=5LeSew4t; arc=fail smtp.client-ip=40.107.236.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VAPHNZxgm8c8B4Un0x6NDXSLN3zwvgjj1EeNGmdWyQjHv0TL7E7NC/s5ay7nnK/awOb/A1vb9qrvCJulkWRgzlUb3jBnjOPEr5Nmn9yv4OGMgOLKGfC67A1sgy5FTt9nIWPM5N3w/3r2XWlrqPjz1PWPw3pHrPbciB+dW2FxIQ/B+GTLAfI8CEIaEUmR/aKYtA9pC8hCRSlGHapqfsrODCv3l9Wa1WB1C7CPw4dLtS6PVMU0Q4YISApoK+tE9vm85LGTniivF9E/8citZPfM89cRfNIKEi8wIXDRhEstlfcDqck/y1yf7p2AwTkaq48uVv/IgXFboiB6UJyZMrAGaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ahqNepwknzmKj838Y/5M2zFWiuqzYHtG9yikbE83TrY=;
 b=UqDJmXnWBGzreSftcVYb596XA416X4ZNKbsRhHYthml2P8AwfwLG0m5pv0cs58wL2RwcMLakw7u9usbo91pLPcmzMtCPpxMweVwC6OS7ksyDitI2vuItXW339yTgzOLr5yzzUaTMZwJdjzIdap161slTeSaRWiiLbv6D13SCR4yIS8hTUEs47vu26Of98CTRH+JR7q3EX/BIrtUfwidQX50hsZrW2mFBo/8cL52UpXKyVOc3W3DjQxDCPYfr/oQSmj42WxdWvHwd6umSX3gh1d70mIqn561HjFMbWB5kLctNjHltZT50YJ4B1FIAHIzO0MZF0mAdbhjehSUodNUd/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ahqNepwknzmKj838Y/5M2zFWiuqzYHtG9yikbE83TrY=;
 b=5LeSew4tSos6EIKD34V0N0Nm89bQ027aVWXqeR5D0R72gWKPhNAGWFI/axXv00uPVVkmCeTOYPmT5VmcBejDkyhFDc3Y2WEKW7PFuyfwYmAmrf9gHSmZmQi1Udqf3GlOjIHVMM4q6xkYmySsvjhm8HVGpEMAupk+VKw0oylOiDM=
Received: from CH0PR04CA0073.namprd04.prod.outlook.com (2603:10b6:610:74::18)
 by CY5PR12MB6324.namprd12.prod.outlook.com (2603:10b6:930:f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.28; Wed, 14 May
 2025 07:27:48 +0000
Received: from CH1PEPF0000AD79.namprd04.prod.outlook.com
 (2603:10b6:610:74:cafe::7) by CH0PR04CA0073.outlook.office365.com
 (2603:10b6:610:74::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8699.33 via Frontend Transport; Wed,
 14 May 2025 07:27:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000AD79.mail.protection.outlook.com (10.167.244.57) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8722.18 via Frontend Transport; Wed, 14 May 2025 07:27:48 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 14 May 2025 02:27:38 -0500
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
Subject: [RFC PATCH v6 23/32] x86/sev: Initialize VGIF for secondary VCPUs for Secure AVIC
Date: Wed, 14 May 2025 12:47:54 +0530
Message-ID: <20250514071803.209166-24-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD79:EE_|CY5PR12MB6324:EE_
X-MS-Office365-Filtering-Correlation-Id: a7f6bc1f-8df7-4b73-73c1-08dd92b8d406
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1K2MssqmfeehNG90sRpjBIpQDtJBjjYWK+oY4trF6wuskFIytxl6B7uTlHR1?=
 =?us-ascii?Q?D+0cKbo5Gfp0efYjLtiEWW54co9IeM2jsde/neOp2YfeWnIuA6SbcZx1U48Q?=
 =?us-ascii?Q?7v3Ff4PLKEv/5R3P4J71MzfjWG2LKteMPHHG2MgNhDzLeXoEDW8+oSm5jXPC?=
 =?us-ascii?Q?MoYeM6LfQOUhgm4+Xq3b3HF8cgmxYahEltR/V0ypiyptWBBdF4axq7mrd/p9?=
 =?us-ascii?Q?JfE28wZaKTKQ/Q2+eQgZNIvdDzc/Okbz5OqbQtHHeHR3lREXGcmBWRs7tPE1?=
 =?us-ascii?Q?jEDiffz+VinF8NlYqvNFL0hv/PhKItFG099Cd5uEjk2XM60x1Wi6263deFAV?=
 =?us-ascii?Q?cnxgd6ijDuQ0B2RpgjbET9raAdGvQ9iakVQ9TutSe9SYqBrwcioa7stOXa5z?=
 =?us-ascii?Q?/jc/o4OMvXb9HNy5+uVXpq/C5knNJ3RcCqZnE92b+cT/GQM/12jeSRdB3kU2?=
 =?us-ascii?Q?ITyo0pJ0EXpEomjtHVcg2FD3H/XP7/LIzA16bDHTmvXh6qkn+SytfEaNsg+Y?=
 =?us-ascii?Q?h7b/3Zq0To/3UME3ORh1lwuzFyC+b7TVF5jrtHuBWAZfMTrI5eEFAXdZ+8w8?=
 =?us-ascii?Q?Ii5Np0KuJCP7DAj69acTxtBC0WIFhlrn+U1AhB17BjmzKQ2WYIsVx8OMlO8A?=
 =?us-ascii?Q?wPNgkaxu/XnT8E2U+6Y2/ensYwX2sRKSPGS8r99PlTS9r2duV8xhE/CI/OxJ?=
 =?us-ascii?Q?K7WZCqMLGq1IRahKd5UKP9uP62KLz+YUS83DjdZTmBN3eUxGPx47coCgsczN?=
 =?us-ascii?Q?b5C5EkqDUeK9dqv4aKL/J99T4rFEzBupTj/BKxNmqnCi/Cy05vE0Za2qrt97?=
 =?us-ascii?Q?qMInDTW1W+CdCg3Kr8GJ+cYUcf5Rw+4TmGwIkCw0a7QT/G8tcqnsN6t5lu1w?=
 =?us-ascii?Q?wfQdXGGHetuMRV0SQcpCv0JWOlpeewVAtZTeGCfCjPY7WPq0RoRTjXO11gAN?=
 =?us-ascii?Q?1m7hMOlYrLztV9kC1VNQDk7uom08zndLXRw5v9ABuY65V1XTkGYV2TZe4flv?=
 =?us-ascii?Q?FUy5uNYN4XhBH7Cvo7tzzWK7pUWJnGXmwYbr/X6s7ljKL9lZzmymC3rM+YXZ?=
 =?us-ascii?Q?j3IL1JpRXF4epKavQU+oexqc5+6JcxzGJGqKsSF4UsntYH4/ycUK19OSxay6?=
 =?us-ascii?Q?ungX8d1RO3E85P+nj5cedzzHBxVLppW2PcKa8ja/IhtRTPu/LyIggn7dfvdn?=
 =?us-ascii?Q?bi2mOIUlQGrK+rKffywb7ecs6VovIYf0yxbq4+xuFLdvegsR64O124YJxqKn?=
 =?us-ascii?Q?IcLtKFKqNqBZju5pQm7tfDuNIb+FyU9x/HTh7hslkUITXMLNBBmIgz1xaaX1?=
 =?us-ascii?Q?PppI7Q2pGUjfcZ7HADcuzlyRvwlDavSHi6ORxwp0IYf8b9NqbRjJsuWly1Ba?=
 =?us-ascii?Q?eJ7MXRnmMi4kxE9ywoSP15Q513p+Lw/s4eR7Ye/iQthNyjuIpUJfrQ9HkbS1?=
 =?us-ascii?Q?5cst0OfZLi1DQhM40Za8ba0Y7PhmFgNwjMRbsMNozQ9EGYFkmyHv1PhYq9qz?=
 =?us-ascii?Q?eVhaLi4/fs+CPt+Y5MDEYpxncFuDZSNd8+Mm?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 07:27:48.4746
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a7f6bc1f-8df7-4b73-73c1-08dd92b8d406
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD79.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6324

From: Kishon Vijay Abraham I <kvijayab@amd.com>

Secure AVIC requires VGIF to be configured in VMSA. Configure
for secondary vCPUs (the configuration for boot CPU is done by
the hypervisor).

Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v5:

 - No change.

 arch/x86/coco/sev/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index ffe1f2083927..4250337aa882 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -859,6 +859,9 @@ static int wakeup_cpu_via_vmgexit(u32 apic_id, unsigned long start_ip)
 	vmsa->x87_ftw		= AP_INIT_X87_FTW_DEFAULT;
 	vmsa->x87_fcw		= AP_INIT_X87_FCW_DEFAULT;
 
+	if (cc_platform_has(CC_ATTR_SNP_SECURE_AVIC))
+		vmsa->vintr_ctrl	|= V_GIF_MASK;
+
 	/* SVME must be set. */
 	vmsa->efer		= EFER_SVME;
 
-- 
2.34.1


