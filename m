Return-Path: <kvm+bounces-42972-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D82BA81913
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 00:57:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 09E141B82F64
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 22:57:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68D1C2561B9;
	Tue,  8 Apr 2025 22:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Ag7ZPnZL"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2062.outbound.protection.outlook.com [40.107.237.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED9FA1990CD;
	Tue,  8 Apr 2025 22:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744153048; cv=fail; b=Cc2gvAA3KSXb5yAdBYG5Pl0Al8zZQFI8KTOjaCi4NfxW3hjyp1mFFNvVIfh4nRasy3oIdckWtEi+KYdKGfuueHF+dTdeR5VlJIp3mgr8KOBU+cbSgupj9N/5qKzbzsNpAo7szhzUjcS3GjIZKiPJLMkyTTd0Al3wswaZ39qy/Vg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744153048; c=relaxed/simple;
	bh=BjKM6P9xk+XMqczgiMFEywTeNqeI/Y70rTLLBqIDmNo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=r2FFPgHXiqEhlLgQuXCD9KClRHCJIgFnegfKtKSbEK1Vj6vQumF0kKE5jmChEACIZMFMy7C0mW0KmHENPtV8JMGfhABv23i8RXG3nUvmnP1gfxKil0HosmW2bObt8ED5OV5QXS7KU2Ql9owTfXsi/hxNKxJLAeXiTs2pFZe6IpI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Ag7ZPnZL; arc=fail smtp.client-ip=40.107.237.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w/9CdL4k3otNmThvJ9lMuFl7CDASQelKSQt6zJqUEwnvUHRlR6w+OhB0zUrL/Qi3rmMQMimGNjpxp1nwsmDKdQ8YH2dAInY/Er1dwdlWj/MSQXO4IYy30Fv07jEhhJ8oNX8Z0zNNdXbTIQX1yrcE6H/QKDFMpKCktSoyK8LSFL16j6mP3lT5ea86tPuRN5ed7yiHtwZB/VX6Qi/vJp9iQ8P2Uj62uOj7a21FCGqwirFFJWtqT9llLR2R7hgBYhlCLM7L7wc8MFCrCya+9rmsUz8sHT6iMxxWGTdFTqDkgurYWgcK0nbOdO2ftq4oFYeX7E50G2G3F84s05IpPCmabA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=esmMgPwekb3CdOfYKArgV2NEMfNseuNIL4+mqIpMPSA=;
 b=vNJNeMqPM2durwwnrYdE8u6O5nXZvrT/PyFojpq36NqaM3uFQqHM+wI0vsenzcpiVXQjCJ60rDkPB/JKVfMWYU8XhAa8AObw/leqzCL23Tr5WqFUeUcDElxIGuBRCSqtKlKstGyTDzviVJSXobsonVwcTxsny6vI6tW2nhWCmVNRCWP+C09bOT92iE3F3jOK2l30GredGZSuowRrkT4Fd/JnagY/CSKCE5Jb6Zd4N7eDf7GlkmERjt2gnjg0WxanyGgl1xGxaijq8aQ8GkdA1zlcqLEI3n2G/VGJ3VreRf+cvkmigR1cXaxEHbqCPfEdnGefRsjkXV93aXxaCRUuog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linutronix.de smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=esmMgPwekb3CdOfYKArgV2NEMfNseuNIL4+mqIpMPSA=;
 b=Ag7ZPnZLIhSb4fJyo9bv1S20QbfCcT3EomYYUs3ule0aoqlGhvmE8wccWtI3nF517clBLfHQjbdqDD+VRtoA3YMpW4hR8bhx+cAVQ/78leyM8aXfAntOVKgJZ7fMUraONz5xjDizaXLIXq3TPTTXEGOp2sa22+uLPRfduHk31GU=
Received: from SA9PR13CA0086.namprd13.prod.outlook.com (2603:10b6:806:23::31)
 by DM6PR12MB4468.namprd12.prod.outlook.com (2603:10b6:5:2ac::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.21; Tue, 8 Apr
 2025 22:57:24 +0000
Received: from SN1PEPF00036F3F.namprd05.prod.outlook.com
 (2603:10b6:806:23:cafe::6c) by SA9PR13CA0086.outlook.office365.com
 (2603:10b6:806:23::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8632.10 via Frontend Transport; Tue,
 8 Apr 2025 22:57:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF00036F3F.mail.protection.outlook.com (10.167.248.23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8632.13 via Frontend Transport; Tue, 8 Apr 2025 22:57:23 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 8 Apr
 2025 17:57:21 -0500
From: Babu Moger <babu.moger@amd.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <seanjc@google.com>, <pbonzini@redhat.com>
CC: <x86@kernel.org>, <hpa@zytor.com>, <daniel.sneddon@linux.intel.com>,
	<jpoimboe@kernel.org>, <pawan.kumar.gupta@linux.intel.com>,
	<thomas.lendacky@amd.com>, <perry.yuan@amd.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: [PATCH] x86/cpufeatures: Define X86_FEATURE_PREFETCHI (AMD)
Date: Tue, 8 Apr 2025 17:57:09 -0500
Message-ID: <ee1c08fc400bb574a2b8f2c6a0bd9def10a29d35.1744130533.git.babu.moger@amd.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F3F:EE_|DM6PR12MB4468:EE_
X-MS-Office365-Filtering-Correlation-Id: 6257e5d0-7c82-4df7-3747-08dd76f0b97e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Vb9aZlFLtlhOI0FZfXPB1iZBcFudA3l4UbtKid+DXhlf0zOl5lxdcqsPyXVT?=
 =?us-ascii?Q?FMLcUolbQBv65BG7x8y5ZZZHshggXLTSJ0wm57S6Ba6pIv2qHUkhb8R6Eq3i?=
 =?us-ascii?Q?4KykCAqLOYwK3klT5v08NeiMTblNL111o4GF3P+WXbvyovITDsaB2IqPGw2e?=
 =?us-ascii?Q?CP1C0nBsazMskFwroENbqApSJDMJwvEry6u+a/D0h+yx5nxvDULKlLwkHp+H?=
 =?us-ascii?Q?zmOgcAuS9otWsFzzlEzFy4W+e6Qf1VK0N/yh1tY6Zz/v3wsQiwZ3bsBV6+iz?=
 =?us-ascii?Q?TgxWcSEIwATwYxAN22yU6XlfOzODYfUpT6pX4/wZsO+lvm6Y60Lmsthr8xJz?=
 =?us-ascii?Q?Rd2XoracVdvsevH6JqP6bO4ZK6Mrmg5L2l/uko73qYhnomYc0aMW3GsKcyUI?=
 =?us-ascii?Q?I9Yh5yuPkOaENGWJ4qnSe8FFhM5q9oNWK5E6CJsreVd0QJ4+Wh8CSkXaMYMX?=
 =?us-ascii?Q?cJa50xVU6W0R5hKKf1VAiaotVMsdZKjSsVeI8d07YEO1iq/hfeYy0yRLJuii?=
 =?us-ascii?Q?kzGilff7MD4oX2/0WLKJ7Gc5ZVl3J/Ph655Mv48gGIsyXQWlCtm6/Zy/VAqO?=
 =?us-ascii?Q?bO5TCRJFAgoartAaZW3v2mey0fuVnSlpvsfAOj1H5kfoCYxffteMzi4VXopY?=
 =?us-ascii?Q?ZbchTM5DIqO2coIkH3/RAF748skCJzXWXgmPTXB+HRqVcNbxzCA6zFhxVjUp?=
 =?us-ascii?Q?Ad9hKbHBpUHggNbOgMvGPp0Zhg0+FZn0DLlYmylWCLz3TNYAvNb5XboQuZLd?=
 =?us-ascii?Q?joONnRpJazBNulPe+r8qw+oYwqcYZwkrJizxdJVduXARESdWOgiIk0tCHm10?=
 =?us-ascii?Q?5sfmBe9cF3gOY/nq6NXK8e0B54HY+SrcQAhQsSFyerkZDcokk0KeLPW53vDx?=
 =?us-ascii?Q?4/gkexhIx/3Y4eOFxj3KrbSqTsFJrreJqlbD1vZUgBTp5rKD3FTbcZ8MYkPF?=
 =?us-ascii?Q?VtrPdz/2aa8w2r7QX1rKhIISjW5UBhKwCUuSIH9foN/JSNeCaC8mk1MwCrj+?=
 =?us-ascii?Q?jKQdnCQrVQ/ELYfm7T21cgaAMhtijktMt/t4IYuHh9nNq1qk42ACs7BY2Oa9?=
 =?us-ascii?Q?8oZfVSxpIBQ0R8ZniyvusxPSB6WDbACSVm3HwMhv0Fp3T41jInzk6iuMuziO?=
 =?us-ascii?Q?vKBFGUr1ZCuBrJx/LbDyYOeAqcK3F975lg660Rdtowmk+6jlnpUkKqEvsDHJ?=
 =?us-ascii?Q?LIs0zvCSTaC/dkV7GWBzshy7GMEduHirYNOeJwLXYlVVoe/RDWLc/n1xBOfS?=
 =?us-ascii?Q?snq7y/mH2WGyvU/YU9OC/c1+/bDhdGYnQ9eW3MeR3VKNFHK3fq5FPNk0U6qG?=
 =?us-ascii?Q?+rxnq9PZLx4FC+o0oO4JiQKAjQRXU+jKUeWGAlHhLHP10lxMCfYw5I1XmhmW?=
 =?us-ascii?Q?BOY/2s/pTBECThOmT8DA1qXwf88ih6m6Nc4yEAfTg1ZsZrfxTR+CFFuRDSde?=
 =?us-ascii?Q?HmAvcoQsjwpVYANpSY/h+TQpQS7gFvF0tyPc5S81gG3rXcnNsKE3N8n0ug/o?=
 =?us-ascii?Q?wC1cZMHwK4qxMXzwBhs2P/Lkn52XZOOsJGsF?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2025 22:57:23.2138
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6257e5d0-7c82-4df7-3747-08dd76f0b97e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F3F.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4468

The latest AMD platform has introduced a new instruction called PREFETCHI.
This instruction loads a cache line from a specified memory address into
the indicated data or instruction cache level, based on locality reference
hints.

Feature bit definition:
CPUID_Fn80000021_EAX [bit 20] - Indicates support for IC prefetch.

This feature is analogous to Intel's PREFETCHITI (CPUID.(EAX=7,ECX=1):EDX),
though the CPUID bit definitions differ between AMD and Intel.

Expose the feature to KVM guests.

The feature is documented in Processor Programming Reference (PPR)
for AMD Family 1Ah Model 02h, Revision C1 (Link below).

Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537
Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/kvm/cpuid.c               | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 6c2c152d8a67..7d7507b3eefd 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -457,6 +457,7 @@
 #define X86_FEATURE_AUTOIBRS		(20*32+ 8) /* Automatic IBRS */
 #define X86_FEATURE_NO_SMM_CTL_MSR	(20*32+ 9) /* SMM_CTL MSR is not present */
 
+#define X86_FEATURE_PREFETCHI		(20*32+20) /* Prefetch Data/Instruction to Cache Level */
 #define X86_FEATURE_SBPB		(20*32+27) /* Selective Branch Prediction Barrier */
 #define X86_FEATURE_IBPB_BRTYPE		(20*32+28) /* MSR_PRED_CMD[IBPB] flushes all branch type predictions */
 #define X86_FEATURE_SRSO_NO		(20*32+29) /* CPU is not affected by SRSO */
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 5e4d4934c0d3..fba018a730ab 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1178,6 +1178,7 @@ void kvm_set_cpu_caps(void)
 		/* SmmPgCfgLock */
 		F(NULL_SEL_CLR_BASE),
 		F(AUTOIBRS),
+		F(PREFETCHI),
 		EMULATED_F(NO_SMM_CTL_MSR),
 		/* PrefetchCtlMsr */
 		F(WRMSR_XX_BASE_NS),
-- 
2.34.1


