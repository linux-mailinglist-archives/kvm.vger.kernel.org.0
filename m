Return-Path: <kvm+bounces-56638-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 20F2DB41021
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 00:42:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7C0D21B25B15
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 22:42:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47FF927814A;
	Tue,  2 Sep 2025 22:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Ix+4Kdld"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2077.outbound.protection.outlook.com [40.107.102.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E8B32765D1;
	Tue,  2 Sep 2025 22:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756852916; cv=fail; b=gdnZwrFTnJ1RmyL1a8TtA+MOrdYUVveh64qlk76wpiqghoDlyJHOKK/E1u2cR6ksJj3BlY8ATj2rnqEMLjoMccB6LZ5B/McQMOhiFiyHb7s3ivyluJExZ1YTju2A6yvHXLchH3UzJPhPxIbayLC9c+uAsNWl7BvuKM0ru4SDfv4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756852916; c=relaxed/simple;
	bh=9WeQ0PEdz3OG63Co9ZfgEWYfT6/RRfCqu88OGvd2SQM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RZo/T4J1ZEvH+OxUNVwFWxA3Nd7EnXSFEMQ1V5m1dPBWE432hXnxzJt5tIoYi15DnFOgTZrCK80vCPelWWpEFvvBj79E+zJ/qWpYKxErDHJt9xLfXJZ58Ujjar0P3HE4EZFJi/OP1N0P9CmQ4Ld5qNTht0Q29KEPlVT+4gZPrBU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Ix+4Kdld; arc=fail smtp.client-ip=40.107.102.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WEd9A0vPnC79EwZrIylFx137ypXbkIrR7ggy52uWXVWqS6QBWBnYlw0aEg4vxN69if3Pt68pqq2DLPrmvVsGKqkAr0SOXkAsO7n3ACPULHxnmdnYvlfZQu68vD9bnngWJYJ2ygDszUrFpQ0T9EVe2xcLVPIotgy1fPkf7tEKm+R6NWoF3tVUeY+8w938crloonkYw00p0dEhwNNceKXiGJojBl+V8u0naN9sDY8h0UmdDsPJiW9rtKvMEV7V/97SoTGCreiSwLBG64PdYM8IxUda+HU1j8PcqpIeX8/S/Dt+vYO48IQlOkXcrOYQ0cXeXVNzgtcVTqWO9aZa779SFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nOXm419cQhJR+FuqjBZIM6UY3zvsfsOYSKPjuBcBt2w=;
 b=ZTxwXRmAtixQ+c8w6S/vDJhG5pqxDb5z9mSbw2Xl67+Xs93J0BfGB3G+soyP8fFgsEmODevA5BXzb2ZwpE6QunQGpew4Qo6CqHjxDSG6XYPNVR4uFoD6Q6lkTUqtRohczj61Zhf/73W+B7JJaeuG/JF5QquDqcUXyghQn9QAVKdvUbOa4WvC7zMKKdsJSoNcMEeZA4ldPln4XXpxysEYMc5HVy+DaPLZ+Xbh5ToOkcu3afqecxkPDgvHmN2NTteduzfmLyk0BW/j873bqoboCjyBzqrkvVOJnunDjQV13jTuyUuj5F6pQX6mMFJtvNKW4fjAweN30bRqBq85o/tFpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nOXm419cQhJR+FuqjBZIM6UY3zvsfsOYSKPjuBcBt2w=;
 b=Ix+4KdldIyIbTpnYKx74MBAIlWwAMN1ZAVrF+iSSDw6bufa7w4AwjhixI/KQrf0gONq3r590gwE+sNpdW3qnPDiMYhEJoVG0GVX+9sPcjLwkX+MwOvQpH5FdZFSmjDAva2YxztxsK0i/Pjfu2wX1H7ydYM+Jc65yuTvY5xd72gg=
Received: from BN0PR04CA0030.namprd04.prod.outlook.com (2603:10b6:408:ee::35)
 by MN0PR12MB6200.namprd12.prod.outlook.com (2603:10b6:208:3c3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.17; Tue, 2 Sep
 2025 22:41:49 +0000
Received: from BN2PEPF00004FBC.namprd04.prod.outlook.com
 (2603:10b6:408:ee:cafe::b3) by BN0PR04CA0030.outlook.office365.com
 (2603:10b6:408:ee::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.16 via Frontend Transport; Tue,
 2 Sep 2025 22:41:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF00004FBC.mail.protection.outlook.com (10.167.243.182) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.14 via Frontend Transport; Tue, 2 Sep 2025 22:41:49 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 2 Sep
 2025 17:41:48 -0500
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Tue, 2 Sep
 2025 15:41:46 -0700
From: Babu Moger <babu.moger@amd.com>
To: <corbet@lwn.net>, <tony.luck@intel.com>, <reinette.chatre@intel.com>,
	<Dave.Martin@arm.com>, <james.morse@arm.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>
CC: <x86@kernel.org>, <hpa@zytor.com>, <kas@kernel.org>,
	<rick.p.edgecombe@intel.com>, <akpm@linux-foundation.org>,
	<paulmck@kernel.org>, <pmladek@suse.com>,
	<pawan.kumar.gupta@linux.intel.com>, <rostedt@goodmis.org>,
	<kees@kernel.org>, <arnd@arndb.de>, <fvdl@google.com>, <seanjc@google.com>,
	<thomas.lendacky@amd.com>, <manali.shukla@amd.com>, <perry.yuan@amd.com>,
	<sohil.mehta@intel.com>, <xin@zytor.com>, <peterz@infradead.org>,
	<mario.limonciello@amd.com>, <gautham.shenoy@amd.com>, <nikunj@amd.com>,
	<babu.moger@amd.com>, <dapeng1.mi@linux.intel.com>, <ak@linux.intel.com>,
	<chang.seok.bae@intel.com>, <ebiggers@google.com>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>
Subject: [PATCH v9 01/10] x86/cpufeatures: Add support for L3 Smart Data Cache Injection Allocation Enforcement
Date: Tue, 2 Sep 2025 17:41:23 -0500
Message-ID: <b799fb844e3d2add2143f6f9af6735368b546b3a.1756851697.git.babu.moger@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1756851697.git.babu.moger@amd.com>
References: <cover.1756851697.git.babu.moger@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To satlexmb09.amd.com
 (10.181.42.218)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FBC:EE_|MN0PR12MB6200:EE_
X-MS-Office365-Filtering-Correlation-Id: 01d4e8e4-e2c0-459f-14b7-08ddea71e760
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|36860700013|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mAmd5a9tELUw8PITEpfbd8DU4npR2UmIyb/jcmpNusiex+HVxx9xR6LEG4f1?=
 =?us-ascii?Q?77OwsetB8rG0+jwlkdXroMeFtMgcWCOwFd0lOiQxDd6AZKs2UqJ7NHIWI0SD?=
 =?us-ascii?Q?LMDFj2LZqKqcNqUUAhRPEE4c6+OfugeBLMRy12pEGhwiqrdkkb5aOywRtHrZ?=
 =?us-ascii?Q?EUFutKmU1amNdijER6a8mwsZLldjEQkq6/5zJpLuabZuUO+2X21vU+BAzg05?=
 =?us-ascii?Q?+apR3EU+msbndb22gZ+0zPyf638M/7EK8Q80m6ViM5I01R+JFrirY3rnesxC?=
 =?us-ascii?Q?XSszM1phoKLQAYr/0JQ/U/+f94t0Rr2CgL6ntP+v8cyNVyrb5vc33SVzqANo?=
 =?us-ascii?Q?b4/fiZyEVC7S8PRanHYS4mjaCcDMm8wsv4goXy3i6pyMwmrKZkYQQMyBlmQU?=
 =?us-ascii?Q?xjPCg+F9qQEtnvX/AuTZXmpr/S0RwNxElqO/QLvDSCxedMD1PCNJjhCrFx57?=
 =?us-ascii?Q?ehnMBiXq08gxmzgIQRHhzuzV/SO+cB26ptQk5AqOj+jAxanaDAsR9Vav5tuZ?=
 =?us-ascii?Q?EvX/BhvuinnghhH9vJ6T16N4Pazot7FYaPCO4mmwxqggIWJHy5vkmB3I2HD1?=
 =?us-ascii?Q?AsVYzqk5MHb3KyUokVz7Dd2+mA4LUEjOjcMkNz7guY6CP8AnJP+XBgl2V0tZ?=
 =?us-ascii?Q?6ypfVChbh9k1fdOTlX3I4tx1e/gDGQr3kUDHKWu/3ZvTr2NfLcf4OKcJwwIu?=
 =?us-ascii?Q?mo3EnIWFYv4eFmOMvMPRSLP4kXs8sHKMDFfXgCJlsiKgZ4oYXatO/H0YZrjb?=
 =?us-ascii?Q?7nnychc0B8M7JPyuwVvR3ul2B+71gDxE2Nhbjj2xFGQ8vVAWfV8W68qlR3UP?=
 =?us-ascii?Q?y4+dKjL5F/Hb0fPyso7nvt92yBgWBvQKbMc/cKoble+eiVwjxCAjHJEhg1p4?=
 =?us-ascii?Q?FQ61/MWSsipoZNl3nm9xkPiolazt2DUagoL4IwbM9Qt1M1WDPrqbAfhG1rcq?=
 =?us-ascii?Q?yUIScUdDIHUpkpPc+CWb50UxZZswwQfMRI23icUDcC/9m4l+L0uiAzwNC83K?=
 =?us-ascii?Q?ttJoTe0zmjL3LqxYK9MboGqNLH1e9RyxrHJRURRS1TO5uzex6AKPFVNyGuZa?=
 =?us-ascii?Q?R9cVNqYqnvanitDDAcWjecql3RdICO+B5oR+cs5dnVF3VD1T+m8KRv0md91k?=
 =?us-ascii?Q?6wNRfMhW2FuYzoFp6RPJ8zHX3qtOtPF98oX/H0ZCARZSYhUVRawTaqU5c6Du?=
 =?us-ascii?Q?Kqq0TyiRbcnnfnQGzkTnYXAi093Py/Zyfkm1FLCfzPG+HxDUXE48aY1p6jJz?=
 =?us-ascii?Q?+TOiKmI25VQTP8eYgDUDgKRrbTkbQabiWXgmsKBHmu1pngxlEOq/7laWpyLc?=
 =?us-ascii?Q?a6UzlQe4xMC+r/LKXJG9Tn5HOmJyE21mYJMXuYQefrPKcWklkAQsC6CRiDOf?=
 =?us-ascii?Q?puO+XTumrPhao2feeH9frfIOvQVBji9+fiKS7i8CFQH1+BW4pEPwx0625mxG?=
 =?us-ascii?Q?ydSHQ16n5Q059DiCnDO3MZnz9MaSWf3zXo2K5vbg3H/1YeW3lItc4A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(36860700013)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2025 22:41:49.0075
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 01d4e8e4-e2c0-459f-14b7-08ddea71e760
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FBC.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6200

Smart Data Cache Injection (SDCI) is a mechanism that enables direct
insertion of data from I/O devices into the L3 cache. By directly caching
data from I/O devices rather than first storing the I/O data in DRAM,
SDCI reduces demands on DRAM bandwidth and reduces latency to the processor
consuming the I/O data.

The SDCIAE (SDCI Allocation Enforcement) PQE feature allows system software
to control the portion of the L3 cache used for SDCI.

When enabled, SDCIAE forces all SDCI lines to be placed into the L3 cache
partitions identified by the highest-supported L3_MASK_n register, where n
is the maximum supported CLOSID.

Add CPUID feature bit that can be used to configure SDCIAE.

The SDCIAE feature details are documented in APM [1] available from [2].
[1] AMD64 Architecture Programmer's Manual Volume 2: System Programming
Publication # 24593 Revision 3.41 section 19.4.7 L3 Smart Data Cache
Injection Allocation Enforcement (SDCIAE)

Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537 # [2]
Signed-off-by: Babu Moger <babu.moger@amd.com>
Acked-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
v9: No changes.

v8: Added Acked-by, Reviewed-by tags.

v7: No changes. Fixed few conflicts in
   arch/x86/include/asm/cpufeatures.h
   arch/x86/kernel/cpu/scattered.c

v6: Resolved conflicts in cpufeatures.h.

v5: No changes.

v4: Resolved a minor conflict in cpufeatures.h.

v3: No changes.

v2: Added dependancy on X86_FEATURE_CAT_L3
    Removed the "" in CPU feature definition.
    Minor text changes.
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/kernel/cpu/cpuid-deps.c   | 1 +
 arch/x86/kernel/cpu/scattered.c    | 1 +
 3 files changed, 3 insertions(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 06fc0479a23f..7a6afd605643 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -495,6 +495,7 @@
 #define X86_FEATURE_TSA_SQ_NO		(21*32+11) /* AMD CPU not vulnerable to TSA-SQ */
 #define X86_FEATURE_TSA_L1_NO		(21*32+12) /* AMD CPU not vulnerable to TSA-L1 */
 #define X86_FEATURE_CLEAR_CPU_BUF_VM	(21*32+13) /* Clear CPU buffers using VERW before VMRUN */
+#define X86_FEATURE_SDCIAE		(21*32+14) /* L3 Smart Data Cache Injection Allocation Enforcement */
 
 /*
  * BUG word(s)
diff --git a/arch/x86/kernel/cpu/cpuid-deps.c b/arch/x86/kernel/cpu/cpuid-deps.c
index 46efcbd6afa4..87e78586395b 100644
--- a/arch/x86/kernel/cpu/cpuid-deps.c
+++ b/arch/x86/kernel/cpu/cpuid-deps.c
@@ -72,6 +72,7 @@ static const struct cpuid_dep cpuid_deps[] = {
 	{ X86_FEATURE_CQM_MBM_LOCAL,		X86_FEATURE_CQM_LLC   },
 	{ X86_FEATURE_BMEC,			X86_FEATURE_CQM_MBM_TOTAL   },
 	{ X86_FEATURE_BMEC,			X86_FEATURE_CQM_MBM_LOCAL   },
+	{ X86_FEATURE_SDCIAE,			X86_FEATURE_CAT_L3    },
 	{ X86_FEATURE_AVX512_BF16,		X86_FEATURE_AVX512VL  },
 	{ X86_FEATURE_AVX512_FP16,		X86_FEATURE_AVX512BW  },
 	{ X86_FEATURE_ENQCMD,			X86_FEATURE_XSAVES    },
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index 6b868afb26c3..84fd8c04d328 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -51,6 +51,7 @@ static const struct cpuid_bit cpuid_bits[] = {
 	{ X86_FEATURE_COHERENCY_SFW_NO,		CPUID_EBX, 31, 0x8000001f, 0 },
 	{ X86_FEATURE_SMBA,			CPUID_EBX,  2, 0x80000020, 0 },
 	{ X86_FEATURE_BMEC,			CPUID_EBX,  3, 0x80000020, 0 },
+	{ X86_FEATURE_SDCIAE,			CPUID_EBX,  6, 0x80000020, 0 },
 	{ X86_FEATURE_TSA_SQ_NO,		CPUID_ECX,  1, 0x80000021, 0 },
 	{ X86_FEATURE_TSA_L1_NO,		CPUID_ECX,  2, 0x80000021, 0 },
 	{ X86_FEATURE_AMD_WORKLOAD_CLASS,	CPUID_EAX, 22, 0x80000021, 0 },
-- 
2.34.1


