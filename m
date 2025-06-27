Return-Path: <kvm+bounces-51018-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D911AEBD3E
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 18:27:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 34B7F560101
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 16:27:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 686572EAD11;
	Fri, 27 Jun 2025 16:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="BaymXTxx"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2074.outbound.protection.outlook.com [40.107.92.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1071A2EA722;
	Fri, 27 Jun 2025 16:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751041606; cv=fail; b=IRG8ZSTwhhkGtDSvMbLJRoQLAJZpEyBNb08PgsdlYtIao3lbfJj8uDw3LMMRNCECw8DiyR4Bsr9QoKRhZGtk/EwIjDEOUDRi/qU8NeIA7nYbhH25oAJAa4PTzNVwhN5TfZmHwmgb9E96SXT2Hcw6aY7p10KKSzsHfcfedpnum8M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751041606; c=relaxed/simple;
	bh=IYlNQQGhT8rP7MwMCoFhB5L8u1Cwkego76r5TnxXcd8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qzclnMwdUhZVvmajuqEpr6+yPmcCgcD8Szp27bsdQFad4bIRf2cijNZxqgFZz+b3eEBaJm1jNUCq2o3OB+yRuzX1phz1jBrYPJOOjD0YlYeI7UmJhZ5HjVFOCHhyn2Y32SjF83Egpep6WVuP8Xf51v8fZj0ITd5LQPvFCbFc+VE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=BaymXTxx; arc=fail smtp.client-ip=40.107.92.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i/khiIlK8Svm0BJ2Jrfk9rFW1W25oN5INTdEx3ry9UwRPKEDtA+EIrvC7Llfcn+GjBrPRi8Mod++5/sRlRgm3FEnr1DPyYOl3LA+fZQfo9xdevZbkSTlkHZWQnZktI+f6qhRIJZ1CnFMCiT5u4OEMr+81pwDgShPOQ8Wz9QkPmFAi/A+FBAKATdyS+5paRaOeEqAUW7Q+8IC+bcoJeg/tEwFjQkdKYX+FwGhiaTdBHHhmG7txVIFngnGRBU0YX6DjApExhaxxVQrclK2/f+8ImyfduEPMv4u5KZPtL6X6EIwZe0PdaAFZUZxuy/JRllKuyNl36WVh9ber9croSoOqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EWJAkGDL1Z1xZXD0s3bSWebnfP7TWGA6q3DK5XhqxrQ=;
 b=q5EBa8WkcDxdJVlaSve6gmCMDhmLEoaT2VdoTmpoQs32b14EQbEVaTzsQg3OtAwnZKCg837VG0QEkFJdjqmVvOAo4W85kLPaNjHfkRS3/YVEBGwSmEYHYcwpqfq/sBE2GGilwwgBQ1ms+CGGJaqdwWiKwEIOKU6u/AhIDFCT+QrisroCawv9KryC1qeajHOMFdq1GsZH+x+lagDx3LRD8/Yi5jyvkoTt846jA2W5Mi9nUIkV1XIfg0qRSFOWwcM2evGDRBDY1tOkffp6oAxi9U0bnxoENz8nWBdkYukqQ+22RBy3bYXJxE6HsdC4qmpY4OQNNij+zFEiZGJM0LsNFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EWJAkGDL1Z1xZXD0s3bSWebnfP7TWGA6q3DK5XhqxrQ=;
 b=BaymXTxxVH0DZxlPJIN5ld4Dh9yhjYNvxuZXP6pN7M3ccyzQYRCiNaIXCi8fu6R0k0qmIyxZWZZXss4EJRSQz4uqApO2dn+PRwE3CPqRs1sRSensnf8dMyPCTjax/hAaDXFYUk98AASQN4WkEcAYTX+AxvMgqMsZe0DGxIG1N5I=
Received: from PH5P222CA0009.NAMP222.PROD.OUTLOOK.COM (2603:10b6:510:34b::14)
 by IA0PR12MB8745.namprd12.prod.outlook.com (2603:10b6:208:48d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.31; Fri, 27 Jun
 2025 16:26:40 +0000
Received: from SN1PEPF000397B0.namprd05.prod.outlook.com
 (2603:10b6:510:34b:cafe::9c) by PH5P222CA0009.outlook.office365.com
 (2603:10b6:510:34b::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8880.23 via Frontend Transport; Fri,
 27 Jun 2025 16:26:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF000397B0.mail.protection.outlook.com (10.167.248.54) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8880.14 via Frontend Transport; Fri, 27 Jun 2025 16:26:39 +0000
Received: from brahmaputra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 27 Jun
 2025 11:26:35 -0500
From: Manali Shukla <manali.shukla@amd.com>
To: <kvm@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
	<linux-doc@vger.kernel.org>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>,
	<manali.shukla@amd.com>, <bp@alien8.de>, <peterz@infradead.org>,
	<mingo@redhat.com>, <mizhang@google.com>, <thomas.lendacky@amd.com>,
	<ravi.bangoria@amd.com>, <Sandipan.Das@amd.com>
Subject: [PATCH v1 06/11] KVM: x86/cpuid: Add a KVM-only leaf for IBS capabilities
Date: Fri, 27 Jun 2025 16:25:34 +0000
Message-ID: <20250627162550.14197-7-manali.shukla@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250627162550.14197-1-manali.shukla@amd.com>
References: <20250627162550.14197-1-manali.shukla@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF000397B0:EE_|IA0PR12MB8745:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c31b435-cb1d-47a3-2d7f-08ddb5976541
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xtkDo0l01PagVgmZab8XbO3kuak3WTnzqsqsAtxFz0nHzfLIjeHI/s31hdiV?=
 =?us-ascii?Q?jbOAVS/LMpnb7o0QgDut7OqKwkp2oKVSJQnvg6Ar7FOUFP/PhDpuWoWU1NLC?=
 =?us-ascii?Q?Pik6QIdllf/r0NS2Lv3KKk+FdrzpKnJO5nk1zAfy31XSGoxG3S+uvEPZNouz?=
 =?us-ascii?Q?2gngIdnvr01iorTYALPTeA+kgx9BPNdCuKuY5WOaOjzq/l2h4wk/o+vaqYKX?=
 =?us-ascii?Q?6kWu1UBiuwbssmytaXy/L7CXbwWIl7/IRjgAJ3jTnGdVSRgVz76+yefLbcp/?=
 =?us-ascii?Q?GSX/vmk9m2by0PKJCngLu3f9/mpZ/hHXBrpfAGLx8bPet9nDoVVm22LKNKNf?=
 =?us-ascii?Q?RSZlzmW2kBmrKF86TqL/Wtp557vCzC2bHOwbkkwViAqUP6umjJwdLQMLxn3J?=
 =?us-ascii?Q?fhk7nrcOwRGUoVvk1aFSND6x4yd8/bSXqTY/hNRYCoHb4v1Q4kI9Uj6G4n5m?=
 =?us-ascii?Q?hHS8/iWd1qHZPG4/Z37cTKY+rxRGRWh9TVWoTUBW06gWXMkFWtgVGuzxrkif?=
 =?us-ascii?Q?aEa/jmvD5S2zjo6aRW08bbwwZjKv3N3KtbNFLSoYgw784yGG6fqc9oNtr+9K?=
 =?us-ascii?Q?2/AQEfB/TL5RDZazBrUw69lwnc8D1tj2YhPkMOeVugDgMVddGqRYPSX7/PYG?=
 =?us-ascii?Q?WQUyU14caYQmGl+A2Y+rHFwwyjg8tnRa3pRwyOkLVxUgrJSNl4u1IQ6i7ni2?=
 =?us-ascii?Q?FZ9m4R80HUlO+Nh/oMYna50S/Iow3LLUx7DRTniffsKX0b9IxWuZPB/d+1vB?=
 =?us-ascii?Q?5swNl4TtFWq5hAfhWjzFd0b11/AVYqGPFupBLpR2x2ca01hvOqeZx4e7SLOH?=
 =?us-ascii?Q?uPEqZ8gKxnUGkofkisWhsc/RyN7rNkzukL+G7lAh5yu5o2nM+B+1nFI2oGay?=
 =?us-ascii?Q?mMqNYK7gLlwmpnzxOYwEMz6kMKID7mUrCiVP8fQa3R8R4QjLPeta2z10ZGG/?=
 =?us-ascii?Q?3bmrGUe+jwPIX80GBiBRilfdOBkP72na78eLRCdlagaws1vb/4xuLwTJWefE?=
 =?us-ascii?Q?psN20gRjQJzjgRTyxMuNOwrZfJ9ocILlxNJzllZUvlb8L8TCS6GkUoZcL7si?=
 =?us-ascii?Q?s3bBaL2+FRKBZkfzfg6bRhkYU46/cI/fDWAWgHnEZtHqeMLImvtbULHnoxcf?=
 =?us-ascii?Q?56y81jer4zMAnCnKiUqnkZkpP3Tvy8YVu43z0tFIWaQGacvGnoe8BSfZvOwt?=
 =?us-ascii?Q?MvOkLfAjKFsEbVVWyMqcNWCs3cguUi0mSbk7IsS/fYgc1uy5PNRw4o1HW+yJ?=
 =?us-ascii?Q?iRLAbbgnXPQK5yM/xo7fWn3l8tWAhdJ6tgi+wnGYxvKCdU02DdhzFBYgH23A?=
 =?us-ascii?Q?XWpRH6cDRdCKjk1uYmu/P1pDjSuzijmsG8amgqrasc+GKwm2sa++1M73WdMO?=
 =?us-ascii?Q?JNClrRV7wFxioghof19he6eJOIWHg6zSIF8OSMFgLkkOYeW4zk+rjwZR3rxL?=
 =?us-ascii?Q?gbd/1ZTpTLCXedHPNrrLpPERrM+3iW2MHQIJ4349kLTR5ycCNkpGqU8EIFrc?=
 =?us-ascii?Q?ApQCZPGklGR1OI+IHhpwdWdnioSQ8yNBjH1/?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2025 16:26:39.9243
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c31b435-cb1d-47a3-2d7f-08ddb5976541
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397B0.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8745

Add a KVM-only leaf for AMD's Instruction Based Sampling capabilities.
There are 12 capabilities which are added to KVM-only leaf, so that KVM
can set these capabilities for the guest, when IBS feature bit is
enabled on the guest.

Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/reverse_cpuid.h    | 16 ++++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 732bac9403b1..8e3d96b6166b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -770,6 +770,7 @@ enum kvm_only_cpuid_leafs {
 	CPUID_12_EAX	 = NCAPINTS,
 	CPUID_7_1_EDX,
 	CPUID_8000_0007_EDX,
+	CPUID_8000_001B_EAX,
 	CPUID_8000_0022_EAX,
 	CPUID_7_2_EDX,
 	CPUID_24_0_EBX,
diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
index fde0ae986003..7f685361faa9 100644
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -52,6 +52,21 @@
 /* CPUID level 0x80000022 (EAX) */
 #define KVM_X86_FEATURE_PERFMON_V2	KVM_X86_FEATURE(CPUID_8000_0022_EAX, 0)
 
+/* AMD defined Instruction-base Sampling capabilities. CPUID level 0x8000001B (EAX). */
+#define X86_FEATURE_IBS_AVAIL		KVM_X86_FEATURE(CPUID_8000_001B_EAX, 0)
+#define X86_FEATURE_IBS_FETCHSAM	KVM_X86_FEATURE(CPUID_8000_001B_EAX, 1)
+#define X86_FEATURE_IBS_OPSAM		KVM_X86_FEATURE(CPUID_8000_001B_EAX, 2)
+#define X86_FEATURE_IBS_RDWROPCNT	KVM_X86_FEATURE(CPUID_8000_001B_EAX, 3)
+#define X86_FEATURE_IBS_OPCNT		KVM_X86_FEATURE(CPUID_8000_001B_EAX, 4)
+#define X86_FEATURE_IBS_BRNTRGT		KVM_X86_FEATURE(CPUID_8000_001B_EAX, 5)
+#define X86_FEATURE_IBS_OPCNTEXT	KVM_X86_FEATURE(CPUID_8000_001B_EAX, 6)
+#define X86_FEATURE_IBS_RIPINVALIDCHK	KVM_X86_FEATURE(CPUID_8000_001B_EAX, 7)
+#define X86_FEATURE_IBS_OPBRNFUSE	KVM_X86_FEATURE(CPUID_8000_001B_EAX, 8)
+#define X86_FEATURE_IBS_FETCHCTLEXTD	KVM_X86_FEATURE(CPUID_8000_001B_EAX, 9)
+#define X86_FEATURE_IBS_ZEN4_EXT	KVM_X86_FEATURE(CPUID_8000_001B_EAX, 11)
+#define X86_FEATURE_IBS_LOADLATFIL	KVM_X86_FEATURE(CPUID_8000_001B_EAX, 12)
+#define X86_FEATURE_IBS_DTLBSTAT	KVM_X86_FEATURE(CPUID_8000_001B_EAX, 19)
+
 struct cpuid_reg {
 	u32 function;
 	u32 index;
@@ -82,6 +97,7 @@ static const struct cpuid_reg reverse_cpuid[] = {
 	[CPUID_8000_0022_EAX] = {0x80000022, 0, CPUID_EAX},
 	[CPUID_7_2_EDX]       = {         7, 2, CPUID_EDX},
 	[CPUID_24_0_EBX]      = {      0x24, 0, CPUID_EBX},
+	[CPUID_8000_001B_EAX] = {0x8000001b, 0, CPUID_EAX},
 };
 
 /*
-- 
2.43.0


