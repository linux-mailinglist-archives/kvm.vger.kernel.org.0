Return-Path: <kvm+bounces-28214-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 33B74996579
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 11:34:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D9C5128417D
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 09:34:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC44D192B81;
	Wed,  9 Oct 2024 09:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="kuYGEtAx"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2051.outbound.protection.outlook.com [40.107.95.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC4FE18DF73;
	Wed,  9 Oct 2024 09:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728466209; cv=fail; b=P3r1qwq93C0AmGL1OKxhuqdZrmFQCfkuHd868DtMH2Zd+NoWRWam2+sJOPVRCdp/otgYdFPT+JCjkMh/ASVlXcYLfOogJAldsZHr6G57knvZVRmCHlW93bOQU0azNFrpi/WO5mVEThwagDgaBMtRn6ZoSrYZeO+MOM7iDqKawXY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728466209; c=relaxed/simple;
	bh=yFEZa87ePkT0GVks5aURlM8AiHyAN4jc7iqBmsLDGpQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qx0wk/arsn8EtV/u981Aw36XTnM5Ne+GBlzJA9zexwKyDloQMtyCXIoKchK6/WxcxWBYUxTRDHwl/ssmKIVFYxoqIsSFnbG+ECckpFxkzWMmK99pKOEgkDPp2TqX+Z0xBW7KVnAcqz7E0MjutUO8+9RnoZAxSP1EiaSUa4VCECk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=kuYGEtAx; arc=fail smtp.client-ip=40.107.95.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h6j5GvphpjJSooV+HmARnLZysUZjSLnDVcFYF285unTfeUjfK+F7kuif/ghCx8RKEVv6PaH7ppy5db+XJZAyh5O/dcF9v1aL19me4xQhdU+JVOBxNZLz9wpN9t3sEdbMVpuBFgZCJ9VrTfPRXJcYIQtfjAUQBQEYJo6iV4I0zzIphRtIZ0gghNV/abCAOE6/TpcgAUscR8MvcomO89f0vHDV/vd37I4KQ7+XR18XTYXyiD/hGM7uh/ljR3wWYIjICk6mJzOBMcR5qH3gyE/sGRJ3zvKJOwD3haR+6qJfvWgCsU4TiFxUmCxcPAsb2loZ0geVlitbCXG5kOgKMYunuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vG3XlH6X8br1SqyWUNJJtNwI0wjzLZKOOQCiMEdkNZ8=;
 b=dWR+ENC+ldiju8eRTURVhgdtyVEHvpdY9h4zUItOUrjZPBiE+c17+vWUH/A9D3+EqB+Hj0dAxDu7K5xE0caVmWFY6OVeXVJM8w32ANLbUULQC7PGu+S5apknUazOVar6ZUpO+GOfIk2h2tTI+xtFbTaiP3sGVmV7zguyqyIH1l3+jkUL4VjKRpBu83S8Ymin3z/x2lvcpX7kbreQ3Q1Z1u6RhBuXKJ1CWAgOEx2mrRzekpHlD1UzZ9sdxMBes6s1Yd+e7ZhhbOQCxtCNeJM5FIy/20aL7enuqmPfuhftiQU8naX2r4gPgp21sJWFiYOt4CU12GHHOvPJZDu/0I+HLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vG3XlH6X8br1SqyWUNJJtNwI0wjzLZKOOQCiMEdkNZ8=;
 b=kuYGEtAxKlim246Fc3RIyd8H2tvW9JgRjx2v6S6A11X+/PWrunYv/Co7ZrEHejac789OlJZCG6J92kzdSXz7BtYR4kSJEyRFUdats9h6BKlJgpFFC++VABjQPiCZQpQPjnmXQlGK55DdVh9GOBDDSy4Huel+XMZOTfLV6LnX7SU=
Received: from BN0PR04CA0094.namprd04.prod.outlook.com (2603:10b6:408:ec::9)
 by PH7PR12MB5617.namprd12.prod.outlook.com (2603:10b6:510:133::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.16; Wed, 9 Oct
 2024 09:30:03 +0000
Received: from BL02EPF00021F6C.namprd02.prod.outlook.com
 (2603:10b6:408:ec:cafe::67) by BN0PR04CA0094.outlook.office365.com
 (2603:10b6:408:ec::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.24 via Frontend
 Transport; Wed, 9 Oct 2024 09:30:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF00021F6C.mail.protection.outlook.com (10.167.249.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8048.13 via Frontend Transport; Wed, 9 Oct 2024 09:30:02 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 9 Oct
 2024 04:29:58 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v12 14/19] tsc: Use the GUEST_TSC_FREQ MSR for discovering TSC frequency
Date: Wed, 9 Oct 2024 14:58:45 +0530
Message-ID: <20241009092850.197575-15-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241009092850.197575-1-nikunj@amd.com>
References: <20241009092850.197575-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF00021F6C:EE_|PH7PR12MB5617:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b13cfb7-f455-4cae-9e2e-08dce844f41a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ldQkFkknabsdKJaLCDmmKhZSRBbU2x6NqLOqxz138Fapt6v07+Xm34Iwe62h?=
 =?us-ascii?Q?qY+YxJ3ZIuGgdlVlTWjHmnf97MI4MDUerbK7UA3skeS1xmrrxgcrgLVhuHCh?=
 =?us-ascii?Q?jkFYdT2JNwrPhc8wz1ACAHr1ErMGuiINmAZq5yEPMmM0qk6natHbCUTVJLA3?=
 =?us-ascii?Q?hPjS6DBM/niWnBElEcnQ9pzyLN9+Gf9LIwKaqP2qp9pdDZ+kDflfJ2yeKF20?=
 =?us-ascii?Q?pC2KnfShe/1ea9/8tGhk49S8RLt1vUyfkU874WkyF+5Lv/yJ3zR3ixfbDHtp?=
 =?us-ascii?Q?RBQy8RoMZ/p+vEnRNutd6fS+rt4VkDCdIcz8cxFJQ09t/ZsyX6qfAbQRZzZI?=
 =?us-ascii?Q?lKRXySBjzHKXWbq9ShYUrWIKjvLEhdm5/Xmcv61jCN6DhRJgr0PRY8/5pao7?=
 =?us-ascii?Q?nH3k6jej0Pqsw/OlkpEERYyI6G+EakOymDw2XPpCQYCvp/9E+12NKwUZHcGl?=
 =?us-ascii?Q?Eu0BYbE3WaM7NxiU79vcsP1DbLdcdlDaa3qkRKL8guCWOTtl0Gj2L0EJE0xI?=
 =?us-ascii?Q?W2tHr8u7SzDE1CCQPPMaka1arO9agQ0TaBfk9lvstfv9L3tY1t5ajfhmW0Af?=
 =?us-ascii?Q?44u+zHe20f34wNTzg3YRBB/JmVdHxFNzntlu3HnEfeVtDgO0od47mTLrD5Yt?=
 =?us-ascii?Q?Md/6GFGfftZLh6NgDl+WUu0IX21m8F7631DNsDhL5No2PCH9ST3xxNwLcKTz?=
 =?us-ascii?Q?YQo2bOGElqJn5fzyTZ/Pk82TAo3XqpHgyv8KMLTKZxyQkGT5cLGGhLuV+Bb0?=
 =?us-ascii?Q?vLbw8jblMUnFcYBw7kfA6i15iaOHmXXuOVvtxXrG36F39/PpEthxwxyREbsT?=
 =?us-ascii?Q?5z16Xd2WeQG2hOU2HFGCYOYnZnxiNSEKo3j11qa2rHsVl0yCaLRshZSX0Rek?=
 =?us-ascii?Q?FKICJ4Fmthh44J8hgIcGCB5/JEf3+wswFtAEcnlPpS/4TpVI91yiWim8ZWNi?=
 =?us-ascii?Q?CbvnW/RztS3sEFCbeV5geccU0k6u686jBLx0KEaPyHHFUbpnw8DsgJKvDT7i?=
 =?us-ascii?Q?xXL48+Vz32hEXt5zuVo6pybPZ3HBbdjSGk6HvxQZcs+esUobBTp7dIkfOVdS?=
 =?us-ascii?Q?MGXwvU3ejWhR0nNL8JEahrHgaoLf+br2Rf2gwX9QnvEsU4ZZtNHqobSjY1dN?=
 =?us-ascii?Q?Kv6JOCU13QAAZfjR/ORlQa7+jvvGz/jhJ42CixM7WggrydlIHZkOEM/9fvyC?=
 =?us-ascii?Q?T5PEsPBPLP0vR/ldx0zlfqgcGXMrOmR/VXjbSSVfBqkvlDepsnZqJArY+9K7?=
 =?us-ascii?Q?xdGQ4wTW7c6IigGoa5fk5apVz3Hkk34pi3Wk7k48S8kXnLtOXAq6F5cUeW9+?=
 =?us-ascii?Q?JJ45KzPxet0ALmNjaiL6D26rG5TbiBxiddQQ8pmBK1cEZgIwWtGSO0OCiGqn?=
 =?us-ascii?Q?wQ8KHAYKkGCf1bLkeQrp11rl3LQa?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2024 09:30:02.9791
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b13cfb7-f455-4cae-9e2e-08dce844f41a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F6C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5617

Calibrating the TSC frequency using the kvmclock is not correct for
SecureTSC enabled guests. Use the platform provided TSC frequency via the
GUEST_TSC_FREQ MSR (C001_0134h).

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/include/asm/msr-index.h |  1 +
 arch/x86/include/asm/sev.h       |  2 ++
 arch/x86/coco/sev/core.c         | 16 ++++++++++++++++
 arch/x86/kernel/tsc.c            |  5 +++++
 4 files changed, 24 insertions(+)

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
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 9169b18eeb78..34f7b9fc363b 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -536,6 +536,7 @@ static inline int handle_guest_request(struct snp_msg_desc *mdesc, u64 exit_code
 }
 
 void __init snp_secure_tsc_prepare(void);
+void __init securetsc_init(void);
 
 #else	/* !CONFIG_AMD_MEM_ENCRYPT */
 
@@ -584,6 +585,7 @@ static inline int handle_guest_request(struct snp_msg_desc *mdesc, u64 exit_code
 				       u32 resp_sz) { return -ENODEV; }
 
 static inline void __init snp_secure_tsc_prepare(void) { }
+static inline void __init securetsc_init(void) { }
 
 #endif	/* CONFIG_AMD_MEM_ENCRYPT */
 
diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 5f555f905fad..ef0def203b3f 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -3100,3 +3100,19 @@ void __init snp_secure_tsc_prepare(void)
 
 	pr_debug("SecureTSC enabled");
 }
+
+static unsigned long securetsc_get_tsc_khz(void)
+{
+	unsigned long long tsc_freq_mhz;
+
+	setup_force_cpu_cap(X86_FEATURE_TSC_KNOWN_FREQ);
+	rdmsrl(MSR_AMD64_GUEST_TSC_FREQ, tsc_freq_mhz);
+
+	return (unsigned long)(tsc_freq_mhz * 1000);
+}
+
+void __init securetsc_init(void)
+{
+	x86_platform.calibrate_cpu = securetsc_get_tsc_khz;
+	x86_platform.calibrate_tsc = securetsc_get_tsc_khz;
+}
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index dfe6847fd99e..c83f1091bb4f 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -30,6 +30,7 @@
 #include <asm/i8259.h>
 #include <asm/topology.h>
 #include <asm/uv/uv.h>
+#include <asm/sev.h>
 
 unsigned int __read_mostly cpu_khz;	/* TSC clocks / usec, not used here */
 EXPORT_SYMBOL(cpu_khz);
@@ -1514,6 +1515,10 @@ void __init tsc_early_init(void)
 	/* Don't change UV TSC multi-chassis synchronization */
 	if (is_early_uv_system())
 		return;
+
+	if (cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC))
+		securetsc_init();
+
 	if (!determine_cpu_tsc_frequencies(true))
 		return;
 	tsc_enable_sched_clock();
-- 
2.34.1


