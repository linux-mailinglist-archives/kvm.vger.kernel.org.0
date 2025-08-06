Return-Path: <kvm+bounces-54194-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DB82B1CE11
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 22:51:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 39D04173BEF
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 20:51:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83BA823B604;
	Wed,  6 Aug 2025 20:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="u3iKvj/q"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2066.outbound.protection.outlook.com [40.107.94.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB7BC24167B;
	Wed,  6 Aug 2025 20:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754513264; cv=fail; b=GHQkS0sYw6ilr2rLnRhu9+BQPViWsDMXyU8HHzJAeB1P5wt8BJJNEQTETPdEv2PPeNjTPm3GqiwIiFdnWJ5Y/tBcGu7i72R5y1bXL2AkqrtrDbk0xahQ4EAcMdE++SgI+7nLh761tMFGhDiqlbYBR2QbUqII5wzFj/QO1wUVV0I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754513264; c=relaxed/simple;
	bh=1qmdGbxto/txsJttarA/peIV8cF11bkVM27vsFKVcnQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WgDqkcWMMu5wzCK2iMZAmVnGEsRoMNRCB6IH2gWaNJV3DLZEpjlpJLSgYFFMn15Ep/l5mr1AkzS9EONHivVYgOxvOF2u3eNDA3N3os9dS9UC9kx8FNGSeAPMP5qSDZyTNYVbJK3ChmjNcsW7bzoWmEwzIQyMaDWQhPbS6Kye2iE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=u3iKvj/q; arc=fail smtp.client-ip=40.107.94.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=exIj1/xGOkn60igLLgTx+ofVgyPxFmx3kN4Md4IGlLMQTKrf5WXoD8dxRj9OirKDQjWJTRHDwaWzoS30VFSCCNdATd19up9hZdGl/MQubjpi5n2VrcHGKZ9R/U9CVuoL62ZcQ4Oah19RsRzMA4+4IPusBGvyL0nYiqdXP3uStty7/OEmSxDs9Ftt1GeQpcKz0VaIxI6HcUY5RmANAr05smr8b6IykfLG+hsZLY0mc53tk/FllGEMdjavTwm6NlRQHe0gLhRnNWJeycNR7xXmKigGeHKw8g7voa1guqlIFBZ9z5ApP0walBkY6Ph0vCH0iu5BxaiguD8cpDeaNVg39Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=am/uFFC3ECGhRsiYPYc5MVHk2OCLZ33dW2fM8xZt9Nc=;
 b=FyNcc6hdFBtAaLC2M/HP9k2ZK21rcx2DkliYBNZ7QHiarCnc4O83F7KmvsdIkeb0J2P6mnP72lfRFzFDSOmct3r2jyXhN3j4Wiu48KYR6TrQDq0/ImmE/ZzSm6hpyjzW4hDnSpRqrh1hZ+SFydGqlbJzeynFUS63h5LQ1/8C5WuaT1DB5MaIX0R6J7WSQnPpV6q55vGPdrZS4S8mWKH5TAbK/eaplArQ0kJ1qHceWh6PovjMNMSJ+iDDetjqx5cF0OF0uV0XTiFLoEM7r17sAy613VnPpa+V5xeqTbaulvzZj5zYYx5cqnVKiHktp7TlAZTpKJhnB6gBB0/I+U+tkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=am/uFFC3ECGhRsiYPYc5MVHk2OCLZ33dW2fM8xZt9Nc=;
 b=u3iKvj/qN0Xr8hcoz7MT2STMC4VtMSGKznuBEA8QfeK0JZK8SREJTtPLcqfpDoLcP9eSxkFfTKO9EV25fESq7u5w2sx26Bcnb4zf58Ej6f+eyRbK278MCb7cb6QJJ0FroPaS6ZRl0PQGFry0YrYV1I/yCwXjv0Li+JJQgRv3s8k=
Received: from PH7P220CA0029.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:326::21)
 by MN2PR12MB4471.namprd12.prod.outlook.com (2603:10b6:208:26f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.13; Wed, 6 Aug
 2025 20:47:39 +0000
Received: from CY4PEPF0000E9DC.namprd05.prod.outlook.com
 (2603:10b6:510:326:cafe::97) by PH7P220CA0029.outlook.office365.com
 (2603:10b6:510:326::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8989.22 via Frontend Transport; Wed,
 6 Aug 2025 20:47:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9DC.mail.protection.outlook.com (10.167.241.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9009.8 via Frontend Transport; Wed, 6 Aug 2025 20:47:38 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 6 Aug
 2025 15:47:37 -0500
From: John Allen <john.allen@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>
CC: <rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>,
	<weijiang.yang@intel.com>, <chao.gao@intel.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <mingo@redhat.com>,
	<tglx@linutronix.de>, <thomas.lendacky@amd.com>, John Allen
	<john.allen@amd.com>
Subject: [PATCH 1/2] x86/boot: Move boot_*msr helpers to asm/shared/msr.h
Date: Wed, 6 Aug 2025 20:46:58 +0000
Message-ID: <20250806204659.59099-2-john.allen@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250806204659.59099-1-john.allen@amd.com>
References: <20250806204659.59099-1-john.allen@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9DC:EE_|MN2PR12MB4471:EE_
X-MS-Office365-Filtering-Correlation-Id: bea81dcd-7507-4b01-3a06-08ddd52a7af9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sa6iI+Ne5ixSg5Nz3lNHb0duXyZTrn2K+AlN5v7CDhBAFgJhePeDdqyyLSnu?=
 =?us-ascii?Q?ZVLSprl/XYsLadPnw1OV7Eeemm6T7/dXunY+CZ+V8rNOG2zxgJPqny6L37LD?=
 =?us-ascii?Q?qkihEst5x8bn4c/tHD3ReP/volotUtlnjHnh+3BnEDycxRlvUsPN7qqXyOgR?=
 =?us-ascii?Q?1sbhwrGLVA+QvINtmdGbfdpQP0GURqKh0xiwbekJdWNbucIFLrRazm0HB+wZ?=
 =?us-ascii?Q?sPBY3AxGq288J7oxYA7m0bhPCZSGhHnYllUf4Jy+w79hgkU7Soge8ik5JkHi?=
 =?us-ascii?Q?BuxSMJ+vNYt4OrB7KOynjJK+oLI9bdfqnnTdANUYOwVu8pGeP1bOLbZZkEto?=
 =?us-ascii?Q?g9qNN2xq7485ZwqSAIXkz3ZUcGRDOoivM3668GQuwlbvknZqDLBK/FAFPS+h?=
 =?us-ascii?Q?0vOyQrZ9q329UHgndIYsgBJNp3sE/Tbyy/kYZutl2ZanswowAKg0kUCR3F2H?=
 =?us-ascii?Q?WyJP8Qqht+zL+KvTwSXeORobGVdtQdvagih6+uZfVZQVA/e/voEFeqF/WnVX?=
 =?us-ascii?Q?IeEPGhOrAKpWP5vROYzVLUhaRrGwl2aHqw5huMbtCYMg6XzOf6mTtLhHFQvm?=
 =?us-ascii?Q?ypYnp6iOvdhE/nZIH1keJIK/mg5ETp6+U+tCaryy27kLADmeaQcFfFKXrED3?=
 =?us-ascii?Q?bke/gK5fMOD8AsX8C2IagVj9LGQwtMm9x+cZrB6FjTQQ9noqdbM+3O9mPOdv?=
 =?us-ascii?Q?Hm1JJltDqFqfNlUceIB4bNuoVCMmGsIpDb84/AmU4OcLSFfIgeY6EnR2tAlz?=
 =?us-ascii?Q?S92+71TbH5/iMsW6/z+g6IQkyVYzCzlT3RMOqoR1xxgvzPHsuTofgJFByI2/?=
 =?us-ascii?Q?AE7lB9s+M48k885+QR0pY0cBcjA3Axms5eVdrfi3HzUZb0OmkmnmR9NEMji4?=
 =?us-ascii?Q?RZZxb25uwqWpgVA0xVqxz+fY4p5TnhV60KOo/6fF7B/1mxZuLJWTnp3tY5rc?=
 =?us-ascii?Q?Jk6ASqy1XERRxNu/44i5mNIuMxNdNT8z5lHFGWyjO+xsJObvoMUH82Mp60k7?=
 =?us-ascii?Q?VoJTztTQ4X+/xcTWaVooigPdlhESEFSv0Dytiau6LaHtYGIja7IdhXpuChoo?=
 =?us-ascii?Q?mWAfnOhNNd24dfJuxzTFEe1y2Pt39a/1D/TovMpeqGujVllJg5FOz0qQtQxA?=
 =?us-ascii?Q?UASuviGaU7MzUE1K0suSfxOMYChRTNypNMZyxkUEV9hxt8inzAn0rEcLg/Ep?=
 =?us-ascii?Q?FfTko1zirKToJvCTtxxojLyItaXHGnaeOpLJ2Jgt0S6E7bJ10Y53CLH4fNEN?=
 =?us-ascii?Q?q/VmfZaf9cshCzhZVIlSbWULfPN1gBSzc10B9Z5tRDwSiBPWMMSSNG0dMu2e?=
 =?us-ascii?Q?Uln0aYv1zkk7ep4oO5W6blnBSEAOdkmkIKHe7PVIU0UBiE21FYQvxwQVwAYY?=
 =?us-ascii?Q?m+E0QPr3OrTLFygNMMMISBHiO03rtqGvt3Km4vwPmvlb1mMg2HokXHyUqCsU?=
 =?us-ascii?Q?VRIDVilaJof3w0YJ+LB/JPAP625Ltsp+J4XyO2++RKsTPlrJKWvHzKXgpaI3?=
 =?us-ascii?Q?zXzIpnuugQSfQaHV7MzJTTv0hA/zut6wA5mm?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2025 20:47:38.4099
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bea81dcd-7507-4b01-3a06-08ddd52a7af9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9DC.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4471

The boot_rdmsr and boot_wrmsr helpers used to reduce the need for inline
assembly in the boot kernel can also be useful in code shared by boot
and run-time kernel code. Move these helpers to asm/shared/msr.h and
rename to raw_rdmsr and raw_wrmsr to indicate that these may also be
used outside of the boot kernel.

Signed-off-by: John Allen <john.allen@amd.com>
---
 arch/x86/boot/compressed/sev.c    |  7 ++++---
 arch/x86/boot/compressed/sev.h    |  6 +++---
 arch/x86/boot/cpucheck.c          | 16 ++++++++--------
 arch/x86/boot/msr.h               | 26 --------------------------
 arch/x86/include/asm/shared/msr.h | 15 +++++++++++++++
 5 files changed, 30 insertions(+), 40 deletions(-)
 delete mode 100644 arch/x86/boot/msr.h

diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
index fd1b67dfea22..250b7156bd0f 100644
--- a/arch/x86/boot/compressed/sev.c
+++ b/arch/x86/boot/compressed/sev.c
@@ -14,6 +14,7 @@
 
 #include <asm/bootparam.h>
 #include <asm/pgtable_types.h>
+#include <asm/shared/msr.h>
 #include <asm/sev.h>
 #include <asm/trapnr.h>
 #include <asm/trap_pf.h>
@@ -436,7 +437,7 @@ void sev_enable(struct boot_params *bp)
 	}
 
 	/* Set the SME mask if this is an SEV guest. */
-	boot_rdmsr(MSR_AMD64_SEV, &m);
+	raw_rdmsr(MSR_AMD64_SEV, &m);
 	sev_status = m.q;
 	if (!(sev_status & MSR_AMD64_SEV_ENABLED))
 		return;
@@ -499,7 +500,7 @@ u64 sev_get_status(void)
 	if (sev_check_cpu_support() < 0)
 		return 0;
 
-	boot_rdmsr(MSR_AMD64_SEV, &m);
+	raw_rdmsr(MSR_AMD64_SEV, &m);
 	return m.q;
 }
 
@@ -549,7 +550,7 @@ bool early_is_sevsnp_guest(void)
 			struct msr m;
 
 			/* Obtain the address of the calling area to use */
-			boot_rdmsr(MSR_SVSM_CAA, &m);
+			raw_rdmsr(MSR_SVSM_CAA, &m);
 			boot_svsm_caa = (void *)m.q;
 			boot_svsm_caa_pa = m.q;
 
diff --git a/arch/x86/boot/compressed/sev.h b/arch/x86/boot/compressed/sev.h
index 92f79c21939c..81766d002c0a 100644
--- a/arch/x86/boot/compressed/sev.h
+++ b/arch/x86/boot/compressed/sev.h
@@ -10,7 +10,7 @@
 
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 
-#include "../msr.h"
+#include "asm/shared/msr.h"
 
 void snp_accept_memory(phys_addr_t start, phys_addr_t end);
 u64 sev_get_status(void);
@@ -20,7 +20,7 @@ static inline u64 sev_es_rd_ghcb_msr(void)
 {
 	struct msr m;
 
-	boot_rdmsr(MSR_AMD64_SEV_ES_GHCB, &m);
+	raw_rdmsr(MSR_AMD64_SEV_ES_GHCB, &m);
 
 	return m.q;
 }
@@ -30,7 +30,7 @@ static inline void sev_es_wr_ghcb_msr(u64 val)
 	struct msr m;
 
 	m.q = val;
-	boot_wrmsr(MSR_AMD64_SEV_ES_GHCB, &m);
+	raw_wrmsr(MSR_AMD64_SEV_ES_GHCB, &m);
 }
 
 #else
diff --git a/arch/x86/boot/cpucheck.c b/arch/x86/boot/cpucheck.c
index f82de8de5dc6..2e1bb936cba2 100644
--- a/arch/x86/boot/cpucheck.c
+++ b/arch/x86/boot/cpucheck.c
@@ -26,9 +26,9 @@
 #include <asm/intel-family.h>
 #include <asm/processor-flags.h>
 #include <asm/msr-index.h>
+#include <asm/shared/msr.h>
 
 #include "string.h"
-#include "msr.h"
 
 static u32 err_flags[NCAPINTS];
 
@@ -134,9 +134,9 @@ int check_cpu(int *cpu_level_ptr, int *req_level_ptr, u32 **err_flags_ptr)
 
 		struct msr m;
 
-		boot_rdmsr(MSR_K7_HWCR, &m);
+		raw_rdmsr(MSR_K7_HWCR, &m);
 		m.l &= ~(1 << 15);
-		boot_wrmsr(MSR_K7_HWCR, &m);
+		raw_wrmsr(MSR_K7_HWCR, &m);
 
 		get_cpuflags();	/* Make sure it really did something */
 		err = check_cpuflags();
@@ -148,9 +148,9 @@ int check_cpu(int *cpu_level_ptr, int *req_level_ptr, u32 **err_flags_ptr)
 
 		struct msr m;
 
-		boot_rdmsr(MSR_VIA_FCR, &m);
+		raw_rdmsr(MSR_VIA_FCR, &m);
 		m.l |= (1 << 1) | (1 << 7);
-		boot_wrmsr(MSR_VIA_FCR, &m);
+		raw_wrmsr(MSR_VIA_FCR, &m);
 
 		set_bit(X86_FEATURE_CX8, cpu.flags);
 		err = check_cpuflags();
@@ -160,14 +160,14 @@ int check_cpu(int *cpu_level_ptr, int *req_level_ptr, u32 **err_flags_ptr)
 		struct msr m, m_tmp;
 		u32 level = 1;
 
-		boot_rdmsr(0x80860004, &m);
+		raw_rdmsr(0x80860004, &m);
 		m_tmp = m;
 		m_tmp.l = ~0;
-		boot_wrmsr(0x80860004, &m_tmp);
+		raw_wrmsr(0x80860004, &m_tmp);
 		asm("cpuid"
 		    : "+a" (level), "=d" (cpu.flags[0])
 		    : : "ecx", "ebx");
-		boot_wrmsr(0x80860004, &m);
+		raw_wrmsr(0x80860004, &m);
 
 		err = check_cpuflags();
 	} else if (err == 0x01 &&
diff --git a/arch/x86/boot/msr.h b/arch/x86/boot/msr.h
deleted file mode 100644
index aed66f7ae199..000000000000
--- a/arch/x86/boot/msr.h
+++ /dev/null
@@ -1,26 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * Helpers/definitions related to MSR access.
- */
-
-#ifndef BOOT_MSR_H
-#define BOOT_MSR_H
-
-#include <asm/shared/msr.h>
-
-/*
- * The kernel proper already defines rdmsr()/wrmsr(), but they are not for the
- * boot kernel since they rely on tracepoint/exception handling infrastructure
- * that's not available here.
- */
-static inline void boot_rdmsr(unsigned int reg, struct msr *m)
-{
-	asm volatile("rdmsr" : "=a" (m->l), "=d" (m->h) : "c" (reg));
-}
-
-static inline void boot_wrmsr(unsigned int reg, const struct msr *m)
-{
-	asm volatile("wrmsr" : : "c" (reg), "a"(m->l), "d" (m->h) : "memory");
-}
-
-#endif /* BOOT_MSR_H */
diff --git a/arch/x86/include/asm/shared/msr.h b/arch/x86/include/asm/shared/msr.h
index 1e6ec10b3a15..a20b1c08c99f 100644
--- a/arch/x86/include/asm/shared/msr.h
+++ b/arch/x86/include/asm/shared/msr.h
@@ -12,4 +12,19 @@ struct msr {
 	};
 };
 
+/*
+ * The kernel proper already defines rdmsr()/wrmsr(), but they are not for the
+ * boot kernel since they rely on tracepoint/exception handling infrastructure
+ * that's not available here.
+ */
+static inline void raw_rdmsr(unsigned int reg, struct msr *m)
+{
+	asm volatile("rdmsr" : "=a" (m->l), "=d" (m->h) : "c" (reg));
+}
+
+static inline void raw_wrmsr(unsigned int reg, const struct msr *m)
+{
+	asm volatile("wrmsr" : : "c" (reg), "a"(m->l), "d" (m->h) : "memory");
+}
+
 #endif /* _ASM_X86_SHARED_MSR_H */
-- 
2.34.1


