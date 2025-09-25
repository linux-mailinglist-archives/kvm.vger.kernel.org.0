Return-Path: <kvm+bounces-58724-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 31FFBB9E94A
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 12:11:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 363061BC23F5
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 10:12:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 291012EA177;
	Thu, 25 Sep 2025 10:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="gUL40IIP"
X-Original-To: kvm@vger.kernel.org
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010015.outbound.protection.outlook.com [52.101.46.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36B092EA75C
	for <kvm@vger.kernel.org>; Thu, 25 Sep 2025 10:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758795086; cv=fail; b=C1bCt9RNdH1e4EVaQP02cZkaaNW4AEiv1u6GHMqXxYBA2XlJ3kclnkbR/UeYxRP3EoaOrAC3gpiBhAmXSb4+zZWHPwBEfemILMZAUMqi5uRchKpOlZ4KETQe5XuAs8AQmB17vPIOY4HRwguSpfr7Li+WsElWLW41TWbUuF5hPcg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758795086; c=relaxed/simple;
	bh=mkUIPPAEyH4Dhs13tvfchqi8abneBgO6HmhrwU/wFhw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LwkaAhv+SFg3PVAqxoUEfaqTVCSLnvuknQkc2te+XCVom3Fd9tQhof30z1eG96gI6ySSZboPeamV4ZLf2AMvgNq1ymeo76Q3sodIjitU1cyV61MPeYohPxNxdfmgjyGKm6pWCsYwflO1YNBCfOzK2GR7sxseI20lQlbuSb5yg4E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=gUL40IIP; arc=fail smtp.client-ip=52.101.46.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eN6Qsp4g+RorMJ5+2KWlb3Kz5x4L9/hpyvL+s7winDZLV37iWLz5eQwFH84r9w5fZ+jrYsSuRlLX4aDFqMUQcBagjr48jLypl5ljfXnbtOlcvdSrr9tFaUCioYAWGtKuOuE4IgRzbnW1d9s3TWhhYnk7nm6oEVUKhuYTLCZk0Ly3JZ6hPkF7G6h+g8VLlTmfnMkX+5ZmFxAMZuJgBt7xEZWZUcUymde/cgnXmNsZpjxRKOdiAGv3qfg4I8OuQ43Ab+GhHgM/3Zv8t4dy0UoUXYrGyzCuIIlwGog3QT9u6AiEWkqHhweQwiGCH6nPYsUTjZbxP76U7PdzwA1/qtS+4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kbJOcLYqu/VViGpOWBFrUEh+P0fb+jPUB+ogXnzKyFs=;
 b=p77LpKQ0bewBpWJsbdD49+5e4mrt1124zQTnhRcgINoziMFB0ZBIB/MWpd4OVVn6kMjTAKzEjAlI/BlWCecpJ8UpOs4gCNbGOjJV3kjZEUVCKH+LOVSTwYMiFuyjipiRIrJQZYVI3gtJi1jGpPK1ioaWN4hfRNOFT1qHzZDBYOFsfsZe/DCo6VetCRlslRKWV9SCb6mSdZGj/eWipqrB87AvGKZl3Xz016ofEJh4Iduciczdu77aWFLsfQFsEN9AqjlbdyZpxXhuBRxSsKVQ53St4MU9IJ86FFf5BCigm4HitTzzWh4MkQgYIkVjwMz6UqveEGZ/2bYsVeSmwIXQOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kbJOcLYqu/VViGpOWBFrUEh+P0fb+jPUB+ogXnzKyFs=;
 b=gUL40IIPQNweTa+R27x6P6+69JFxzC7sCyQYarAuzfYvHZR8vx8+mMhk3i5h7diL/AkzN07n2519iBvXLmOrig3Ch/JmGXlHYj2jsKbEiNnX6YTbhwX/pa+66Or6Av4EYCbLsHsg0pv6L0ofYy+B0nBVYQmMyMUMWjB1luSJ9H8=
Received: from CH2PR11CA0002.namprd11.prod.outlook.com (2603:10b6:610:54::12)
 by PH7PR12MB5997.namprd12.prod.outlook.com (2603:10b6:510:1d9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.10; Thu, 25 Sep
 2025 10:11:19 +0000
Received: from CH1PEPF0000A348.namprd04.prod.outlook.com
 (2603:10b6:610:54:cafe::e5) by CH2PR11CA0002.outlook.office365.com
 (2603:10b6:610:54::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9160.10 via Frontend Transport; Thu,
 25 Sep 2025 10:11:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH1PEPF0000A348.mail.protection.outlook.com (10.167.244.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9160.9 via Frontend Transport; Thu, 25 Sep 2025 10:11:19 +0000
Received: from gomati.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 25 Sep
 2025 03:11:16 -0700
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<santosh.shukla@amd.com>, <bp@alien8.de>, <joao.m.martins@oracle.com>,
	<nikunj@amd.com>, <kai.huang@intel.com>
Subject: [PATCH v3 3/5] x86/cpufeatures: Add Page modification logging
Date: Thu, 25 Sep 2025 10:10:50 +0000
Message-ID: <20250925101052.1868431-4-nikunj@amd.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250925101052.1868431-1-nikunj@amd.com>
References: <20250925101052.1868431-1-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000A348:EE_|PH7PR12MB5997:EE_
X-MS-Office365-Filtering-Correlation-Id: 45b55ee7-6cc9-4707-3608-08ddfc1bdf19
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hUK54k73zGxor74LEqNJJMU9CwSs8NNriXVVLijGSucHLKEZul9e4AONgwDV?=
 =?us-ascii?Q?6Bc2uECjdHp4QUMs/JltJhpD9bqZsNyK2HhoHdrT0kAwiYXhFDSPRJ/oGH+t?=
 =?us-ascii?Q?TErY5uOjQey63MNOmQHWKZ6MLjyvDGP13PXZRajk7ML/JpgBSrKqe7FFFBln?=
 =?us-ascii?Q?gsKWkM2zoTxWi2xYIpzNZjSmsZfecG889W9v0P7JGP6oJK1W5M4pvO7GctAg?=
 =?us-ascii?Q?Uo5HuKTCalrvzBNsCnM2BLffeuC2F5kSQHuTPk8OKaOoWMQ9J8darUMYh2Yb?=
 =?us-ascii?Q?zZenx9OQdcTrc6wGJxc5L/C6x/P1cKau7Cr5Ag0exHg9IJkx0t8KKJUj6Dv0?=
 =?us-ascii?Q?oIHEAyVodP2dc8Dxj3oFglCaMNdqHdiuxyaCcyNCFCTOhTI/EF0FnAr6IR+2?=
 =?us-ascii?Q?Kwy9e6+AWgf4Ol7ZHYk0vb7rdP0fJkxn5Z9GC0f8Dghw7FbKKFoRH/brIKZz?=
 =?us-ascii?Q?dYkk/DBw7FbN+PI4s1E7CLNtF0y2F469FTLAIBraG8m5rAUhcZqJNkC1KGEj?=
 =?us-ascii?Q?K2y3+oAiOPPfNTBL5C4pvuIyD5M4mG9EVK7yaC6XMfBA7x+413Q4DgcFgkZq?=
 =?us-ascii?Q?23wrekl3aCbXNkv9rmrPXEyXtx0giXIjX0iGs/+6j3taU+mzxi9A0TS+SE2D?=
 =?us-ascii?Q?9ao0SJpEAyGQMtw6NvpcHkBbvkeClI+OK+1RqGKeLRn5QpDYwfFDnQzfvOwI?=
 =?us-ascii?Q?poZO/qLu4zoEkaGuIVrs+6mT7IIZBDsju9Q5Jkl6y+Qdrqy8KOavmjbre9xo?=
 =?us-ascii?Q?auzPmO3l124vrI4bGguGmMPsWTvSWwUPt8TA3l02h2wZublMKhzL1XmqgbbG?=
 =?us-ascii?Q?i1S/BFNb4l3G0vzQMdSHXLRMu/zk/wbvVM0SkuAf7VDqR8i7O9pAylq7OBC6?=
 =?us-ascii?Q?YCJrFVRJQuqvI06fXTAKJdxSIi4reEuVFXiJYJ5AUdQFi7myVNLuVIsAcJjX?=
 =?us-ascii?Q?Qnk44pcau02Tutk4KSDoWGUWstllTn/ByqaUdjAFl+N0sM7NsfNOZV4HI1l3?=
 =?us-ascii?Q?ftTwdBP0brabs7E/nY7Tx7Pj/YjDDr4fwNWS5arGdvxsSZF9WvGNlFq/g13A?=
 =?us-ascii?Q?/+Hqkrl7SD3uQSxNbt6vauAC5dyDbSCfbdOz0ywBSGK5a6ZnIFWlma8+un0y?=
 =?us-ascii?Q?LN5ys7PUTqNsSDKlaIGBtX0tWgG3dX8JiZHgCOUCkiP3IAjjlPU5BVkfX8rc?=
 =?us-ascii?Q?6sQ76rrlGaRs6xXhlvfp8mSh0Sstpe0Hz2ECISLoyg67FqqOBzOX4uWFJ/bV?=
 =?us-ascii?Q?gIuQbP/rcoBNe6ireosUbPZ0C/ewQTNyMFrLtctriqP7NiSjafiUHC8tmubY?=
 =?us-ascii?Q?p+N3guhv+NOHh1WopQFFDTm2cygEstGqpTH9LtyFNtDXpeHqDUd59rUic4fB?=
 =?us-ascii?Q?AEdkBXXUyqP2kT4tzmKiIBqfgPp3BWjKwTJHk6h0oW21RTnFaYEPgTuiaVre?=
 =?us-ascii?Q?IPI41sCEzeTIUiBt3WDMHRl0UMSEwQDP0Prv4eVerQXviwfmSCNlyzaWqMlE?=
 =?us-ascii?Q?ISYxCwd44a/w9cRmPgS8e8RudmUGeNkmvSkj?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2025 10:11:19.3237
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 45b55ee7-6cc9-4707-3608-08ddfc1bdf19
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000A348.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5997

Page modification logging(PML) is a hardware feature designed to track
guest modified memory pages. PML enables the hypervisor to identify which
pages in a guest's memory have been changed since the last checkpoint or
during live migration.

The PML feature is advertised via CPUID leaf 0x8000000A ECX[4] bit.

Acked-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/kernel/cpu/scattered.c    | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 06fc0479a23f..60e95f2bea06 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -228,6 +228,7 @@
 #define X86_FEATURE_PVUNLOCK		( 8*32+20) /* PV unlock function */
 #define X86_FEATURE_VCPUPREEMPT		( 8*32+21) /* PV vcpu_is_preempted function */
 #define X86_FEATURE_TDX_GUEST		( 8*32+22) /* "tdx_guest" Intel Trust Domain Extensions Guest */
+#define X86_FEATURE_PML			( 8*32+23) /* AMD Page Modification logging */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:0 (EBX), word 9 */
 #define X86_FEATURE_FSGSBASE		( 9*32+ 0) /* "fsgsbase" RDFSBASE, WRFSBASE, RDGSBASE, WRGSBASE instructions*/
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index 6b868afb26c3..aeca6f55d2fa 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -48,6 +48,7 @@ static const struct cpuid_bit cpuid_bits[] = {
 	{ X86_FEATURE_PROC_FEEDBACK,		CPUID_EDX, 11, 0x80000007, 0 },
 	{ X86_FEATURE_AMD_FAST_CPPC,		CPUID_EDX, 15, 0x80000007, 0 },
 	{ X86_FEATURE_MBA,			CPUID_EBX,  6, 0x80000008, 0 },
+	{ X86_FEATURE_PML,			CPUID_ECX,  4, 0x8000000A, 0 },
 	{ X86_FEATURE_COHERENCY_SFW_NO,		CPUID_EBX, 31, 0x8000001f, 0 },
 	{ X86_FEATURE_SMBA,			CPUID_EBX,  2, 0x80000020, 0 },
 	{ X86_FEATURE_BMEC,			CPUID_EBX,  3, 0x80000020, 0 },
-- 
2.48.1


