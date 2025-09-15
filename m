Return-Path: <kvm+bounces-57529-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 336F8B57405
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 11:05:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DBAA83ABDF8
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 09:05:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0D4A28468E;
	Mon, 15 Sep 2025 09:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="oTrLSGwS"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2052.outbound.protection.outlook.com [40.107.102.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B1FADDD2
	for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 09:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757926830; cv=fail; b=TeGGqW65X9yJKUrzzp6Xc96KiBJJfHIelNOQjgcAtiCXrKlZ8T4XwmEelK66huCinYZ4IUr1FQBA8vql99MC4dcFLosLszMqqz/i7QZa2bQ3kvgdd0GcZzoOR/YQ17BnqF7HZu2ZihEHeM5YTWNBMyl8YMAJvRLhNHoKhPihkSQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757926830; c=relaxed/simple;
	bh=mkUIPPAEyH4Dhs13tvfchqi8abneBgO6HmhrwU/wFhw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qZLfr5Ue8j/0OYg2Hy/nlrlnj246DN84OV+InPX42l7W4xDXUw0Ww3/u8/jvoXhqN8SxlvhvbwAzpbOqn3rDgbfQ3zClHFxfjL807dlGxGWXA/19UZYfY95/u49OU4o1Vovw19lVO8zJaAdR8uaCYKoRRblczLvEohssy2YqPi4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=oTrLSGwS; arc=fail smtp.client-ip=40.107.102.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OmGbwwDlmVdcj2jGJ48Hv59ct3Ic8/q+OEP9Yg7MNfRFXOxpNHCW2/yqsm0rv9ZY1YG4gTb/9b3B5BoILsQ9WZr0oz67AIS5y5EkgIwA7YHheQQjjyaZN3ZzRl3zoHfUL22GSRymnlQ60MGdO0mwoXlFYHrmpDrins+az8MpyFt6+bg1uB5NBx2fUlfp6/R1ELwV8iWFLpTh7R4A+DUSmyfA9BGf3J49gzOWJe1KZBjB4R0+ZZ4ThGyVT6slVXZjf0wAb+TJdihxYWtd5PAUaAFg+Kqd7J+jUIuf95Ma/sc5WVa479QgaBJPN/XoFk/9DIP+qS3rGFIqo8YvUAKh6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kbJOcLYqu/VViGpOWBFrUEh+P0fb+jPUB+ogXnzKyFs=;
 b=UZo6EYKp3+Ql2b0K2bZjZo5tuuRq0C2JEJbpp0QYUf6UVnUhtcTyROICq2wqhaxTzJKGAv7sIGTcecRhL91ZV3LTSoCBgowO9BHOX5nzAE3lvoMx9XXF+47YOFCJ4Y+F1hCHMCirCFmzS9XTjzP2ESB2mfq2HAyjxqVVZGqVYypi7wjppJsK5c8Uw5KLzWhouU95n7JXaIGLq53CJu+4icNpBCPSa6NK0c7c7U17fmfbxrb8YsPy2jjz8rAikw0AGEgbu7J23v1V/GFvRqnGBK/7kj8S4iA4GtUu6ZTFZTdhAFZ6/3bcSXYZq6vQySA4+JZkC/2XRYDly6l075bMoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kbJOcLYqu/VViGpOWBFrUEh+P0fb+jPUB+ogXnzKyFs=;
 b=oTrLSGwStLbI49FHdlAgnY+Gqzt3ZsAq4fCG50EmFl8n3r+JILJ8uIlS84jfPojnJizxK87QpJ+hbO/s18/tz3kckNtnQxZcZw8Sw2SX9auX/+X0QOoCc8tjVgpaSQxWVZsRVSXvZZr9tEII7gHsH1I2EN+Hh39HF25VcOidTpk=
Received: from BYAPR04CA0008.namprd04.prod.outlook.com (2603:10b6:a03:40::21)
 by SJ5PPFDDE56F72B.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::9a5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.19; Mon, 15 Sep
 2025 09:00:25 +0000
Received: from CO1PEPF000075F1.namprd03.prod.outlook.com
 (2603:10b6:a03:40:cafe::f3) by BYAPR04CA0008.outlook.office365.com
 (2603:10b6:a03:40::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.22 via Frontend Transport; Mon,
 15 Sep 2025 09:00:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CO1PEPF000075F1.mail.protection.outlook.com (10.167.249.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9115.13 via Frontend Transport; Mon, 15 Sep 2025 09:00:25 +0000
Received: from gomati.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 15 Sep
 2025 02:00:04 -0700
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<santosh.shukla@amd.com>, <bp@alien8.de>, <joao.m.martins@oracle.com>,
	<nikunj@amd.com>, <kai.huang@intel.com>
Subject: [PATCH v2 3/4] x86/cpufeatures: Add Page modification logging
Date: Mon, 15 Sep 2025 08:59:37 +0000
Message-ID: <20250915085938.639049-4-nikunj@amd.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250915085938.639049-1-nikunj@amd.com>
References: <20250915085938.639049-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000075F1:EE_|SJ5PPFDDE56F72B:EE_
X-MS-Office365-Filtering-Correlation-Id: f25459aa-3391-45b8-3efa-08ddf4364f50
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?e8JF4SpkrVs7RGmjc3igZByz+SqZ6f8RQuNWaelkYP+jzKH/16wTzhAjp0E5?=
 =?us-ascii?Q?hG4EClfIXJfcvOw9okEr5SoAThkF3kKxzlWGlTtW710PkCHJnj6SlOVlMWOJ?=
 =?us-ascii?Q?k84at2BkTEaAf17hJrZXFMNAKGW2oDguwuQjkdmpLlSCNIfOkWcbf2a/jqGa?=
 =?us-ascii?Q?cwRqFn9HNI13qF5imkT+tt49EYMvAxM3CTtfbYq341y12qx/Y7iuyI/K35k+?=
 =?us-ascii?Q?10IrEHhRmUWe7JmXG6MkK7KmsskRnVfkiAhQBgbiw+kJ53U3JNP+WQPRdGTD?=
 =?us-ascii?Q?4O6/iGqCP/mpKGKbgESUoYRJPtZRh0WHe6WrQ4sNpwLJL47WU2ZZvuc2abO+?=
 =?us-ascii?Q?uzMAtSkihKBfzPMg2bJh//+dAnTP56pjf0NP8Utz4lfJ4x32gcJ7n7bOvt+G?=
 =?us-ascii?Q?MuINEgOjxslvumWfhRbF5pAt+HC0L9T9JMPBEu5hC1dHHs3C/3IHxoREQIfe?=
 =?us-ascii?Q?9psOcLSp/04YZDoaElb3Ik0kAbgykVC4/gm65LN0iJa5ZxYrMAX3ISywtcY8?=
 =?us-ascii?Q?JUpDvMUJSZc/k+yYXkUfmknPxgWW1ohJBvGkCGPLqfPFtdzMtmMk/h6OTnwt?=
 =?us-ascii?Q?C5ts2qaXhqvr+VocwzYNFUqyzmnVzkv3GS6sIsFlLE3yWbuKxyCGSw0WnNmn?=
 =?us-ascii?Q?i/BAb85poMcpXjNeSg3ofR8VOc0/a+/riJlCsBUOWVReALDtdHGCvxAsfF7u?=
 =?us-ascii?Q?7NIO9F0biNh9FhT/AmPQoTeQ9wnmiYnU6rf3/pfdigWpulQ3N5GTWsBF7xST?=
 =?us-ascii?Q?oYm/PKzWBW7CSoxcRQHofnBr+mVsFesX5Ci21UGUyKcm8EazJ4dl0ctdkjNK?=
 =?us-ascii?Q?SD4LK6dQXM3v3EsouRHRheDOlnqXNK4Kz80ODwd9Z1gHQjk/H1y8EElEI+4t?=
 =?us-ascii?Q?sg07+zp01meR1OFgFA5YMPDDdWG9jBDUhzvGoWkx2q6F/j+9ZjipjYol1Vgy?=
 =?us-ascii?Q?D++nhu+8Mzj416znYR9qgaTLXVVHa0wS06nAvKBD7gUi4ji0T/FdcYOfD0+Q?=
 =?us-ascii?Q?6I7ZLi3gBCb5WuFIZqZxNstHimjlYh+gajNbT+0hifOy6RZMF/COeOL8LTaL?=
 =?us-ascii?Q?351M/LkNs0/cw0i8fItx+nfCeMnfHnDnaD+q5PBYDfZY2ONlxIIlf0iDi1Jg?=
 =?us-ascii?Q?LcRrKUOnrqyO4hj3dVv8oYzLX8hoABJJxpmkbHcduAyiqV4V40jlAMbFcVKd?=
 =?us-ascii?Q?Sh0AAl7UORrg/rxolTpVYwRsU9FKCXhrkE+zYIlct34E/vTua73Shayjd+dn?=
 =?us-ascii?Q?q3spGZ6Q9DRZAIP4N80xecQ+QRQTFhWbnc9+LlU5VpXCkXDNNfA1L79cIRGl?=
 =?us-ascii?Q?Y0DoGDzJQ9T4t2mZiVO6co/ZPwMzmtfEivj1satHl23Q3J+lrL0zRbU+VdQ6?=
 =?us-ascii?Q?yUnWyOAAoZ5oC/M86Fp6ncYOSRHYIxjtdSlLUuk6CrWDMezXJCYMqnrIh7aq?=
 =?us-ascii?Q?LCFSiQLw9ClQBBkh3AX/euMhktZ5JlIqWU9s/4jMyMmtoMdBBSHmQWYfRKPy?=
 =?us-ascii?Q?9HMXTOf0a+cXva1Yb/4ZR70YL9iJt1/luBpF?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 09:00:25.1213
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f25459aa-3391-45b8-3efa-08ddf4364f50
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075F1.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFDDE56F72B

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


