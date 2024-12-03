Return-Path: <kvm+bounces-32904-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 612AA9E1694
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 10:03:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 20A1D286974
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 09:03:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AC321E04A2;
	Tue,  3 Dec 2024 09:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="PYjwMPd6"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2041.outbound.protection.outlook.com [40.107.101.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC69E1DFE2A;
	Tue,  3 Dec 2024 09:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733216495; cv=fail; b=RV4XQvTpdaNSAtTjXxIrowTJtSCc200kOgNIxs8cQyXGeAo5MJF3BEI/D4BmMefocxuzf0bIxalYGR1IJKQHQ50yxSwKSXXREVDF1rAoucRwI2cJ+9HawkO6RlZPlhwcGt2CNdua6ud7pOaeUA6Hp2mP0o809wC+WJsTMArKicI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733216495; c=relaxed/simple;
	bh=QCM9U1F4ZFnANebZbS2eTDfs1zWxRA26l6GKwbr9O94=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pHK0NaMfeTEVkqLee8fk/j95JHFvoNIVeo4tpKSeM9hh1LDMzeOpu9Z0e+47XJANZ+GuwyXkeGRsKJcYcc/sWhR7YQWyFjDsZLyS7CN8ybs0c9czdAYGMU7wiYkjyixhksGXkbzsST5lKUCGafdCFdyUW8iDgblKW1PjFVgQ854=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=PYjwMPd6; arc=fail smtp.client-ip=40.107.101.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GpOhPJXPaPu03CQ12cj1jtsHGiQbeaBioWNXooQA5XwKwAi2swJXfRM2L1sWtTqwk/Fj8GXKTNxRsk2oNnudQxs3F3FQFBpxGgX/XyYDiaQK8wGqqGx/szFYEfI5ps4Crw4HzR692q2xrbg0UtiyXVJ5PImAgxhn+7k5wdWdlKEE3yvCDUSwU4sAo+p2NCP5O3NTnckjBEwizhjn21UoCRK6V1EAayxAFQj1yifkbVyGR/9qaZOIlV3bwmy8K9NzJj2gLFrrnK7Fov/rSvTqAGjR1p392mPQZ3jWWP5zL6AUg50GlrnPXvTsZ+Rpe5RrOrx7Uda3s+hIiPjLgQlHLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JfFSubw7wupOReCs6a+4PGtnwt2udDILBgj4QoHT2k8=;
 b=S1+oArrLWAdPi/NMQcfNLgzl0t9pj1J0AwEGTjJiis2a7F0NXtrGg5jbDAJH01za0HkzpW+/khsX+bkgrrTy+IQOz8GtxeGCTI9YwyafHI4M3M12jb3iWAHOOsuDIYfevFLG24rF9OiEfKVRCaM2SGjiGFZNQ0/PgRDPVH0nUcX8/03+w8EJngaq6RwB9HW5o4f+3u7A9l0faCPTSR+8dfqD96qwPBqu0x0Mz6cf3bdQ/UDX1JhRpqz+XEGG2UMtPp/jEr7GwMijWb5zSNGXFv5bO3NiSxLB7ktg3GNBBIJkW4ovfg4s0po4BldZj6TfpvmZGH9Vrwh9HjYCvkuqgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JfFSubw7wupOReCs6a+4PGtnwt2udDILBgj4QoHT2k8=;
 b=PYjwMPd69pnGeVkNdxVUTWMcgAMo78EEjAhoGt6O7I7xMOcIfxTXwAyp4IIWq6I1xm12QYsGNfFYqNU8UIALb/0hHKKIr8UnXFvBF0zsXMmnlEnayxnCAtmc/UfjYON2P3UNn9w38cpMphbJfsK50fe8VHOrK9i/6jzbe4OLsmo=
Received: from CH5P223CA0018.NAMP223.PROD.OUTLOOK.COM (2603:10b6:610:1f3::25)
 by PH7PR12MB7968.namprd12.prod.outlook.com (2603:10b6:510:272::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.18; Tue, 3 Dec
 2024 09:01:30 +0000
Received: from CH1PEPF0000A34B.namprd04.prod.outlook.com
 (2603:10b6:610:1f3:cafe::53) by CH5P223CA0018.outlook.office365.com
 (2603:10b6:610:1f3::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8207.18 via Frontend Transport; Tue,
 3 Dec 2024 09:01:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000A34B.mail.protection.outlook.com (10.167.244.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8230.7 via Frontend Transport; Tue, 3 Dec 2024 09:01:30 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 3 Dec
 2024 03:01:26 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v15 06/13] x86/sev: Prevent GUEST_TSC_FREQ MSR interception for Secure TSC enabled guests
Date: Tue, 3 Dec 2024 14:30:38 +0530
Message-ID: <20241203090045.942078-7-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241203090045.942078-1-nikunj@amd.com>
References: <20241203090045.942078-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000A34B:EE_|PH7PR12MB7968:EE_
X-MS-Office365-Filtering-Correlation-Id: f72db9c6-6609-4ec0-8f14-08dd13791416
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xuv+y/iTBiMfuIzUBdyRZ8dOT5IysP5C/YkJpSCzw4hwFsifsUw5fnG9d0jT?=
 =?us-ascii?Q?jtnpqTGrtT5G4KWTyV2WVFEGcQmUR35dgxcdCip+mCu5jPmE8ElwbFOGoD6T?=
 =?us-ascii?Q?ju5UACBiQcruuNMwFDszmOlxmptkCgMUMGOGL8+8SIvEJILfBnh+gbpWFYZE?=
 =?us-ascii?Q?s8o55ej4hjb3GG5CuLOFFLrgsJdpaZJ3OXi7PmnKIg5tfS2KU7HtrWU6y4Pg?=
 =?us-ascii?Q?AKOXOmk9y1aaTelzNhrfaWRieHi7M/SQVzhQSxQ6M8r51exS+n8ft0x1O4Ic?=
 =?us-ascii?Q?/yXtVQYzJREGZoBQfUni2OCf9K3AQ/XvEH7SyqrNDimyCnvc70d1acnXRTi7?=
 =?us-ascii?Q?tBUZUWwbAN41Tah68o4hTwgDNOBd1ULVdpYk5JcpBSwv41kEUVkwBL26wrIP?=
 =?us-ascii?Q?hd4qHi3kSkE0C/Q2IFAvPeZaBLsjc0r6yzTtArjuhzGUe9zsvrSkCdkZBq7a?=
 =?us-ascii?Q?gKHWhVkXm7aA31lKvYTf8Ksl5bXdwl/xekmDmvX02rzr1GjtsC5bhHkFWEOY?=
 =?us-ascii?Q?cU4tmbWu5uh0d+i8DArSk2aeyUNk/Nh6XCFYOZl6agSwfzYk54vPrNB6EIQ7?=
 =?us-ascii?Q?ILCSy5q11H9nmCGUTYtz1ViWs6E8Pcu64p4lQdGBQJVdJT9nlDmYntm98uuA?=
 =?us-ascii?Q?+U1PInytETub1tvbo+omPl/sLJYu378kIVSX7I4znizxvlSoPylNnehKo1ZT?=
 =?us-ascii?Q?qiuMUV79YrWeVkkfKk47j8Pmc4rP0Utfy8hdQbzRixf5LBFl3a2DfiOSlquI?=
 =?us-ascii?Q?TpXY8o8w+UeI/zROvsh0Ei4dtUnZq1uFx0lIrZcNSuOqDOmfyqjIkVhc6wlA?=
 =?us-ascii?Q?HFEfqMt1TKJxkcGH7j5nqobW4SoL9/XJwQnkzxW+hdWUulH7WWyiURlIBhLv?=
 =?us-ascii?Q?bpwRJJ697tAr1jHiXBcaesR/i/IfwM7SRLMVdN5nIkh/ygguM/VWBpIIfKAi?=
 =?us-ascii?Q?BWQxoSz0VBZxIuoTIVCDdnWWIrFxhJgBoUvKwrw3QyfhONOOE2DUpuMf4LSQ?=
 =?us-ascii?Q?0W18wmWaPj5YDAaPt5otHKmJiY7clx1X3Be8CT3IHhyA1ltg9B9GwQeyRlIP?=
 =?us-ascii?Q?Rw/6l4a5TOzSsiUUC7CXTudo8SrYJnblzhNEWxwgk0xZR8iUV0Szq9T2C/aP?=
 =?us-ascii?Q?yx5hbPHOVjde5aCKY9gg9iAE3jwqxRnVmRbqvze7ebxPv0S+12HIAukA154n?=
 =?us-ascii?Q?80s94OfWALYSp+F9/macahrU9oxsGMcIUeEcECK/iIqPbqMxKLKCPolH1epS?=
 =?us-ascii?Q?zaPdrFjCr9wAEdaQJ7n51Fv50Yy4cG0pzq0hPWDGmCA4FLgj9FBrxp+yZ6pk?=
 =?us-ascii?Q?rGFGq0Qx5L9XEcdh7wXvq5qie7lEfxsgd/4DgESu4dkIHG4OnVxP9PXlJb+E?=
 =?us-ascii?Q?uV7O2Cq90cetwVynK8UQYD5ff8QLP5/5S3pmswkr8hy9cw31PAU9Dtz53VZi?=
 =?us-ascii?Q?b13eIT6mz2af9AcpiY/Axo1ttv68oXav?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2024 09:01:30.4534
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f72db9c6-6609-4ec0-8f14-08dd13791416
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000A34B.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7968

The hypervisor should not be intercepting GUEST_TSC_FREQ MSR(0xcOO10134)
when Secure TSC is enabled. A #VC exception will be generated if the
GUEST_TSC_FREQ MSR is being intercepted. If this should occur and SecureTSC
is enabled, terminate guest execution.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/msr-index.h | 1 +
 arch/x86/coco/sev/core.c         | 8 ++++++++
 2 files changed, 9 insertions(+)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 3ae84c3b8e6d..233be13cc21f 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -608,6 +608,7 @@
 #define MSR_AMD_PERF_CTL		0xc0010062
 #define MSR_AMD_PERF_STATUS		0xc0010063
 #define MSR_AMD_PSTATE_DEF_BASE		0xc0010064
+#define MSR_AMD64_GUEST_TSC_FREQ	0xc0010134
 #define MSR_AMD64_OSVW_ID_LENGTH	0xc0010140
 #define MSR_AMD64_OSVW_STATUS		0xc0010141
 #define MSR_AMD_PPIN_CTL		0xc00102f0
diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index af28fb962309..59c5e716fdd1 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1473,6 +1473,14 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 	if (regs->cx == MSR_IA32_TSC && (sev_status & MSR_AMD64_SNP_SECURE_TSC))
 		return __vc_handle_msr_tsc(regs, write);
 
+	/*
+	 * GUEST_TSC_FREQ should not be intercepted when Secure TSC is
+	 * enabled. Terminate the SNP guest when the interception is enabled.
+	 */
+	if (regs->cx == MSR_AMD64_GUEST_TSC_FREQ && (sev_status & MSR_AMD64_SNP_SECURE_TSC))
+		return ES_VMM_ERROR;
+
+
 	ghcb_set_rcx(ghcb, regs->cx);
 	if (write) {
 		ghcb_set_rax(ghcb, regs->ax);
-- 
2.34.1


