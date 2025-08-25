Return-Path: <kvm+bounces-55631-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 247D7B3459F
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 17:21:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ABB9D164271
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 15:21:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8F092FD7CF;
	Mon, 25 Aug 2025 15:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="uK0cvicb"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2072.outbound.protection.outlook.com [40.107.223.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8C72F99BC
	for <kvm@vger.kernel.org>; Mon, 25 Aug 2025 15:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756135240; cv=fail; b=e8VG8ggVCNY6XvDEhEVd3RzItbr7mZ3ljrCWbD4FnOchFEk1CzwLEL/6tJfsCyqA9HUPuF2Yg6oZRlsWWd6s5f5M2WvL/0/tsnkluuDo5AMKFpy2ihkWYtemSImpuEtQ6kFVJXLCwbtOR/6ILQOp2Z0ePHsFqTWy4DIw5Ovu810=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756135240; c=relaxed/simple;
	bh=G+IkfwNEj92QJytDyCcIYSpU5s77iOqzTeO0B89vn74=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YyvSx+fRJkyu+6p1hXoHmsnZvnqQ37dM7yIGmRT5GZkP3zJNA4LeciOSKWWdEgTfCfHneSkUs/6ocnJFFX/w5bt0FOEV80314CdbM2mOIMcnOaMmUwt0baRH8pIQz6PU/bwj/hEsPwq+wXWP/pN6ddmc3/O6xtMWjgXs40sang8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=uK0cvicb; arc=fail smtp.client-ip=40.107.223.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C/tdd6bUkOR09Yz3fRbUOBmTh6hpO2e0rd8fUEPydtBgoWlgWVuc7mIa0XLyot1WX53WiFQxn5d9ZdpMrtVgfdnvxIb2OCtN5G2vuwHxZM25mSKNccbztGrdfwV2HdID1e8o85hI1sTj+myTF4tQG6eJhTfGOJPu0aCZ6TJ4QHIdvi81FXLunfceFa1y4cdkDeUVh3SEdPIV+bCASemeF5/tkoiSiZQ9fQPjkuI3r0+FnNcfWeN7A7x9/vf/1ZyMtLUtiQuCQ4exKB6f5gCwN86qlZQd9MYsJppZ5z+EoGrbXGC7BiPkOukfy/WzIVNn77VhasmKNdIsPg9clJ4vfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hIQwAB+dfPOdLyeaqLvaQlmyYOjkv+qPOk9Iom20WEA=;
 b=xe+eOllKovva2rJ/LzJHq13WI9U5DyvEb6CPb9K/2eO+zkYKyD6txwOkuA58asUHLVzj6UrQCrVtjx6TI5RFyY36DcnV2B924+8tn+roIw8m8m3UvJCFeBhXr2igdx7KO0baFWQXYrlScoQHvtTN4RXclmRyZK2ISPEkwVGf9w2/xkxrBFS1QrugX8hS3m9cgEuQhrhu57hid0wO1C4zzF7UK6NrPIkqROU3H8AiDRzxtqxNJ97d/DY0zJCRQ9dVKt+aLm4wlMAf0QhDqseDG7MI7F1FPZH6pc6EEm9t54HzF8LsyvzlZTsuATuwCCWS/bDMjV4PVScW4ljnyfXnEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hIQwAB+dfPOdLyeaqLvaQlmyYOjkv+qPOk9Iom20WEA=;
 b=uK0cvicb9U7HNErbK1winB+9DWGntW3qxj2tES51H4W4G63AC6zKX9G0/gBZhzK7hP9dHM6KFPS+bcTuwdMVNzCCCDjlhKrDlKdHG8juerIapQ5JZhE/msdUQuQP3ax0VTkKboYe4bQRyrcN8rGT2Tu3APVPmzyTVjOVZTID46o=
Received: from MN2PR15CA0053.namprd15.prod.outlook.com (2603:10b6:208:237::22)
 by IA1PR12MB8537.namprd12.prod.outlook.com (2603:10b6:208:453::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Mon, 25 Aug
 2025 15:20:34 +0000
Received: from BN3PEPF0000B06D.namprd21.prod.outlook.com
 (2603:10b6:208:237:cafe::56) by MN2PR15CA0053.outlook.office365.com
 (2603:10b6:208:237::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.20 via Frontend Transport; Mon,
 25 Aug 2025 15:20:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B06D.mail.protection.outlook.com (10.167.243.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.0 via Frontend Transport; Mon, 25 Aug 2025 15:20:34 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 25 Aug
 2025 10:20:31 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<santosh.shukla@amd.com>, <bp@alien8.de>, <joao.m.martins@oracle.com>,
	<nikunj@amd.com>
Subject: [RFC PATCH 3/4] x86/cpufeatures: Add Page modification logging
Date: Mon, 25 Aug 2025 15:20:08 +0000
Message-ID: <20250825152009.3512-4-nikunj@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250825152009.3512-1-nikunj@amd.com>
References: <20250825152009.3512-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B06D:EE_|IA1PR12MB8537:EE_
X-MS-Office365-Filtering-Correlation-Id: ccd40d74-9eab-4e56-c6e9-08dde3eaf002
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jLLOLgGawev8hmodk+Ic3/9gi+fLQg+ZStX1MHnmi6f7GE2JVFngZACNwvF5?=
 =?us-ascii?Q?tzfbdjSeC1idPknB2jM0j9Um5vz2DdejFwAnhjzqn0K07JAlxCXhYaR5sa3M?=
 =?us-ascii?Q?n+sbAFq9BX2IbLy+2hVZdW/P7T5jzBgbdxxrTM6Zt+673aV7Jw+X7thOK3u2?=
 =?us-ascii?Q?MBNhqQN4AhINi2E1t2eYtY+nz8NmQu/AFg4C80M1cTvRhaqB2srDKxqAOby6?=
 =?us-ascii?Q?bAXBHEbAW9uFk1CTepHIZFnC3efcwxPLbjp+ZboL2P33gn76RTyQjYkc5gDz?=
 =?us-ascii?Q?Y2mx7AYb3RXVOEVfeGgYdFavPZ83Lw6AD3O1AuGN4CH7fu/Y5QfJJLiqadIw?=
 =?us-ascii?Q?fqMn86XHXmDRo0MC4eOAGJD0DlpY7P24ydjApH6cX3VLDskojD6dT/3ykwly?=
 =?us-ascii?Q?owBErEJcMBKbAQccsmQEZgQNFzDZBFBgaMaD8OHpeKGQmUeZwM08cqRyv8Z2?=
 =?us-ascii?Q?QRjcLo1ifFTfohv/zeTmF+Pe53jVWlSkVR3hv0eftqokczck5rKRWRjVKLAL?=
 =?us-ascii?Q?yGDGpB9e3XcMGT0Ng055/IvKna8jFOFNNohltdC3UvrxJA5sDldQyrx/qwiF?=
 =?us-ascii?Q?08oK3bq1ToLQE50S+zVD0xxYU2E3ProL1tJIuZ1b/8DtpHrVHz3wrOCx5KTH?=
 =?us-ascii?Q?EDRXpvjSVjON8fHkE1baew3Eup21PIDfD9Qo1dzrt0WOcYGDPnwvTh2KkFMG?=
 =?us-ascii?Q?WMYW7YQPe6XaDVEs98XtTsT1mYplyWOmIDyDMSAdyu6uEv3SMGuMCs5fHQAh?=
 =?us-ascii?Q?9kbTnjkPAe8/0StUUIVetpbCOxlPtmQUsjNcw79w6SUa7/wysIoiOMD7pG/B?=
 =?us-ascii?Q?lq9i3SIy0BINBbtjW749H4QmegPX4NRvTgmedB5QyGoEi1UmH0YlAmz7hWED?=
 =?us-ascii?Q?tiAYmFcvuka0xdiCczFr8sP2ctsZaRNpFeREsKu5vHgYxsw8VNeGx1yn2TvX?=
 =?us-ascii?Q?Ozhg5aiPwPvpa/G3xhsqaQO/HM6KhIwXPN6HhOg/n4jyBV8ywfeaHsAhZNBe?=
 =?us-ascii?Q?qRQyEsRYj6m4Psq76hn/KI0CNQCRRxF4TuUdke+B0TWueE7+fIyWVvBwObQA?=
 =?us-ascii?Q?4kwPtvcBQz22Nl786miio1TfylraA5bv7WFWa4eFXYwSHPGZ3kHgXSFb2LnQ?=
 =?us-ascii?Q?9eaf4Hgl8gZHZHGYEnzEpp786IBJM0htQmwxfiTiusI4O1EI1aGDzk/mE7d8?=
 =?us-ascii?Q?+hz08FB8wkuxdMKNVVr7jSyKIxJsdF6VzsWrP8YMSi5Dk/jF8FqF+/An4hI+?=
 =?us-ascii?Q?3W8oQW6Hr720krOZYveVuFtvTdDRTM4H20C1nVae3LPT/9w83+wonSQ6ONk6?=
 =?us-ascii?Q?5z87DzedZM/X+Pmqiyhi/6exzf6iK0qX/mXKe7ia6MYGJE1Ql/FG9yL65VHg?=
 =?us-ascii?Q?hIZXaMuMNxhT0Qa4iH1uVEXg2/WKzn6aIp0+v06ix405UV8a2sfagdInXyV+?=
 =?us-ascii?Q?mnDh/onsl2bC7upPFxvPlojln1ULSChx8D0zVnwsxUAWQHb9T9pBa/bVvmKd?=
 =?us-ascii?Q?HRvzOlIuJbL9lm3IBsOeAE4Ph6GkWUC2+kTq?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2025 15:20:34.4622
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ccd40d74-9eab-4e56-c6e9-08dde3eaf002
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B06D.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8537

Page modification logging(PML) is a hardware feature designed to track
guest modified memory pages. PML enables the hypervisor to identify which
pages in a guest's memory have been changed since the last checkpoint or
during live migration.

The PML feature is advertised via CPUID leaf 0x8000000A ECX[4] bit.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/kernel/cpu/scattered.c    | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 286d509f9363..069c0e17113a 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -227,6 +227,7 @@
 #define X86_FEATURE_PVUNLOCK		( 8*32+20) /* PV unlock function */
 #define X86_FEATURE_VCPUPREEMPT		( 8*32+21) /* PV vcpu_is_preempted function */
 #define X86_FEATURE_TDX_GUEST		( 8*32+22) /* "tdx_guest" Intel Trust Domain Extensions Guest */
+#define X86_FEATURE_PML			( 8*32+23) /* AMD Page Modification logging */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:0 (EBX), word 9 */
 #define X86_FEATURE_FSGSBASE		( 9*32+ 0) /* "fsgsbase" RDFSBASE, WRFSBASE, RDGSBASE, WRGSBASE instructions*/
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index b4a1f6732a3a..02fc16b28bc9 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -48,6 +48,7 @@ static const struct cpuid_bit cpuid_bits[] = {
 	{ X86_FEATURE_PROC_FEEDBACK,		CPUID_EDX, 11, 0x80000007, 0 },
 	{ X86_FEATURE_AMD_FAST_CPPC,		CPUID_EDX, 15, 0x80000007, 0 },
 	{ X86_FEATURE_MBA,			CPUID_EBX,  6, 0x80000008, 0 },
+	{ X86_FEATURE_PML,			CPUID_ECX,  4, 0x8000000A, 0 },
 	{ X86_FEATURE_SMBA,			CPUID_EBX,  2, 0x80000020, 0 },
 	{ X86_FEATURE_BMEC,			CPUID_EBX,  3, 0x80000020, 0 },
 	{ X86_FEATURE_TSA_SQ_NO,		CPUID_ECX,  1, 0x80000021, 0 },
-- 
2.43.0


