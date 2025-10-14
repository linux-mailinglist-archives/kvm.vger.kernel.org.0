Return-Path: <kvm+bounces-60026-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 00ED2BDB1A4
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 21:44:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D6AB95806B4
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 19:44:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2167A2D3212;
	Tue, 14 Oct 2025 19:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="lQ9mxuz9"
X-Original-To: kvm@vger.kernel.org
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011044.outbound.protection.outlook.com [52.101.52.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48B3A2D3A6F;
	Tue, 14 Oct 2025 19:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760471070; cv=fail; b=Lit57ZX/SYhZHTHpq+8jdtNS3FAQvYg7LyLP/zSGHtBqzUqD1H20L04qWgkI76lXLKaqCmH2pxyFIsebXrMOPKoP71AlyJc7bbqrASSCzf4+03bDfsMBF3qqzu1wpgnUnvpgsip48HqqroKYmCO308biFD45ueb7fvZEefKmY1A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760471070; c=relaxed/simple;
	bh=hmDLmPXOSGQYc1wO8+j8pAk9ClBOKU1z2IRY8yUxq74=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uGiUj9AL9Z3CIPHQlYC9R5kr65X3iVQsrPXYOD4MYeREgMQh4gKtXUzmeSrcJdvFuc3XPHxSIv4VWtnSIj7ajFstKH8ENkAdPuWIGe57KdNYADqwKy8ago+s3j+Ui44rCNZZeoz8tXIrgPSlFq3JwIcWhIR9fazc+uYQ3Kkr1pg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=lQ9mxuz9; arc=fail smtp.client-ip=52.101.52.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ivyHwqPGtmLbKfokkf2H6vLyGdEIudAIZ6JeETfbuYUviTlvWuYWJxtV31lzQ/4q12PZAbveQ0S2cBzO1QAW/alo8qIsJeVYLFMrwHLaKZtpeTjumia2BciFtRVWpd0yITDifsQmGFq362B0dQqOdqTjv760ufARW357hhlN1AlWQAGlJZH4VR+OifL7kElma49SWPBa4L7NZmwQ2IWtE1zF5dUOqiVaTIGCuSiDDa01oanRbqTWdTSTXeYCyGKTv3nAml8/s6lozy2ot7nex4fDqBoVz2vCn5ZPn10XqX7E02/5QESxHcosXFHZ+nGC4eL2V9CJdXMcUH+rabyf5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HLXOGOejHf8pOA4OxtQIOcZOe2kCRY33wwbszWDoiK4=;
 b=XiloGwcLFTJ0TMLfk5NrrXmGSay3hMJ8UlzMT+CL3/FSYcheqi/A8gBM5Buqcjsrzquj/bBQ//fgCqK1+ABP8JfP57LwHHcGU7b9VxDc6WdQL+4w3JUgF5TrGZDKYjBhLPjKj4sSjjz9AYZnWZzBEHi6XHHU43IfvqOXtPUAehFUcEU93KhkSqVTn/DjMY11a4VHIfWNew2LBpk2KnAPWSmRhEYFQaatP0e6v2I+xEgMH28TjVUQHW4+MXSALQe2bF87LkkmeyifDiAetbgcPoFKjAI9fyxJ2QzAXFpl7Rj2c4lFcrIBhSDrhr/HKkRsnLUc4LMaqovaIrb75HVkZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HLXOGOejHf8pOA4OxtQIOcZOe2kCRY33wwbszWDoiK4=;
 b=lQ9mxuz94qhTm/xjh5WuJsKCipTiJGoEkzkTOIjenpxzY5r5fHAz+4qaPaRPqrQJ+fthYMZPZowmXeGcZWNJtVSUZ8TXY+rbxHwCOFgciA1Qh0RALA8OBGuboIUGu48+QgenLIdVyVWawHmdvR4njtvHAP1/DPuDCtLfPFr9DVM=
Received: from SN6PR04CA0083.namprd04.prod.outlook.com (2603:10b6:805:f2::24)
 by SJ2PR12MB7917.namprd12.prod.outlook.com (2603:10b6:a03:4c7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.10; Tue, 14 Oct
 2025 19:44:20 +0000
Received: from SN1PEPF0002636C.namprd02.prod.outlook.com
 (2603:10b6:805:f2:cafe::61) by SN6PR04CA0083.outlook.office365.com
 (2603:10b6:805:f2::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9228.10 via Frontend Transport; Tue,
 14 Oct 2025 19:44:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF0002636C.mail.protection.outlook.com (10.167.241.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9228.7 via Frontend Transport; Tue, 14 Oct 2025 19:44:20 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 14 Oct
 2025 12:44:19 -0700
From: John Allen <john.allen@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>
CC: <rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>,
	<weijiang.yang@intel.com>, <chao.gao@intel.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <mingo@redhat.com>,
	<tglx@linutronix.de>, <thomas.lendacky@amd.com>, John Allen
	<john.allen@amd.com>
Subject: [PATCH v4 1/2] x86/boot: Move boot_*msr helpers to asm/shared/msr.h
Date: Tue, 14 Oct 2025 19:43:46 +0000
Message-ID: <20251014194347.2374-2-john.allen@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251014194347.2374-1-john.allen@amd.com>
References: <20251014194347.2374-1-john.allen@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002636C:EE_|SJ2PR12MB7917:EE_
X-MS-Office365-Filtering-Correlation-Id: bd96631f-93ad-49d4-89c8-08de0b5a116f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?co6TNlcrwf4o7s1YRtJEttxmVnlw36ApuT9G/c9p/+6gvfBUQQS+o/HmtFfL?=
 =?us-ascii?Q?mY2tFynxnnW9XDJNGT+L7Ud11g3eqnJLcQeLH33aQX1a3y8yJPeCcyaVwQxS?=
 =?us-ascii?Q?0njlKXjfpSkUs2HEPyWIxuSWk9Dm3j/Azdc+qvPhD2xo9T/n/XYyFsqne0/X?=
 =?us-ascii?Q?D08NfBDaXivwf6t8Af+Be2JG7ckajIDCZEcA8MVZp26o3PNe9IPx5SiRHO6B?=
 =?us-ascii?Q?nc0b0u5xcoLQwMNa9wUdB3dQaOismtIaVJy0RxyqTCMH10lQkNT40a6r4Y5I?=
 =?us-ascii?Q?PcPrkbrpc9evddHVgMubekn+uo4jT8cRqYW580hRmeL1JJxyZ8XbhNyEWnqU?=
 =?us-ascii?Q?7R/VdZ1Ze0fDrs7B+BVDGrPs/QlHi2aWO6JNSpE+ewGgZok+yRQHEaAk8IFe?=
 =?us-ascii?Q?lbueN4vvoFOQpx5fL7quL/eZApQDGkEfV6zuXhdLstDmt91u/RCKQR3H4Xv6?=
 =?us-ascii?Q?qAhDiU/wwKN8XLFnusV78VPmIP/PFbnEqeqbzu93ARKKKmu/YxzUS4cy5K3r?=
 =?us-ascii?Q?h4qwM99yf0kzLFFbMrNSYXytjBeeEYIq6eRws5ZeDnoxD8zrib48WTi2dP0D?=
 =?us-ascii?Q?3FParwup5frvK/IH5LrO7NTnqrMfeejqQs1sQ/urz2rqjaKuR0BaWCLZvmOm?=
 =?us-ascii?Q?6tMGjXFdBUVheNYt2fF5Hh5DFckkvfupVpMMk5q4nexiUwhegSOAwy5E8AOf?=
 =?us-ascii?Q?7b3usm7mzoQ1ONQ1h6t36AFYYG8qGjXK9HUE1+xJHUWKZzKYw+oXxs/nbZ6n?=
 =?us-ascii?Q?8S4/A/dpIEAwd0QwsSEngvYWW3TyIptKD4lmbJdY6QHEZKMnSzrmVPxRSiLo?=
 =?us-ascii?Q?GGhecyPmdncYJmmLGJDah3E5njlNosxz3zEu60BK+d1PnwzG3xKtjO+U/ceP?=
 =?us-ascii?Q?ubrXoVW9PJ1DSTXVZb99F7DKquks5f6pbJp3craEcU71wvCh/IrCz/yEmaqo?=
 =?us-ascii?Q?4T/vW8o2m6I+9m2QP1vLnZG8bvJrJBEwuzzRxmW5+i/ZLa5gNozY6jAAZ869?=
 =?us-ascii?Q?uXwBQFqUo8DlUd8VZx086ygPzIZ7iWFuw479LTOR9AXc1lEKcwE6EAgfXZdM?=
 =?us-ascii?Q?3oS0D/+fwwGaOYSK+myCI8WKcQOj2epO3cLhAHmEEnaTXPcriMcyXKtYdlpK?=
 =?us-ascii?Q?SN5yZY43iapacrtzzYYgsUUDaRmTrP4XXewqrd5gciY/N8IUMKlxkwyLSSIy?=
 =?us-ascii?Q?Hoebc3w24/wP5LyNSicwO3w0ZufM9UEeIwPh9xg2Lyvl6aijl6NMbOrds3Fn?=
 =?us-ascii?Q?0ifSjPMFz09aN6YiEdKrZ0ZIHAASOpdeFwPKi6pOdbuGyFWtGwDWK/0OAswl?=
 =?us-ascii?Q?Bj96AB7QPjP4NdOL5/Pm+fyFKeNaHhW9GVdRUjHGnukh+3Ddk/YVuxgTxNxP?=
 =?us-ascii?Q?E/GkJXVAJfhNXrnlxJ8WsgZ1PaEXahfkaexx5rGJtD9NmDptZGv+3BeWe5pd?=
 =?us-ascii?Q?Ts8txv5nU3BCQRFDX4G33hOeLJnMBSHBmYImX3cvtsF4+NkSJOAOC+qo93Ec?=
 =?us-ascii?Q?dYD6wUSBRuqKg8+ZjPQz7NrOWmQD9KvnJchkvaZRA39lLzdf5Oc+D653T5dS?=
 =?us-ascii?Q?9DNeYMig3zRoDMKu81U=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2025 19:44:20.0061
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bd96631f-93ad-49d4-89c8-08de0b5a116f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002636C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7917

The boot_rdmsr and boot_wrmsr helpers used to reduce the need for inline
assembly in the boot kernel can also be useful in code shared by boot
and run-time kernel code. Move these helpers to asm/shared/msr.h and
rename to raw_rdmsr and raw_wrmsr to indicate that these may also be
used outside of the boot kernel.

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
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
index 6e5c32a53d03..c8c1464b3a56 100644
--- a/arch/x86/boot/compressed/sev.c
+++ b/arch/x86/boot/compressed/sev.c
@@ -14,6 +14,7 @@
 
 #include <asm/bootparam.h>
 #include <asm/pgtable_types.h>
+#include <asm/shared/msr.h>
 #include <asm/sev.h>
 #include <asm/trapnr.h>
 #include <asm/trap_pf.h>
@@ -397,7 +398,7 @@ void sev_enable(struct boot_params *bp)
 	}
 
 	/* Set the SME mask if this is an SEV guest. */
-	boot_rdmsr(MSR_AMD64_SEV, &m);
+	raw_rdmsr(MSR_AMD64_SEV, &m);
 	sev_status = m.q;
 	if (!(sev_status & MSR_AMD64_SEV_ENABLED))
 		return;
@@ -446,7 +447,7 @@ u64 sev_get_status(void)
 	if (sev_check_cpu_support() < 0)
 		return 0;
 
-	boot_rdmsr(MSR_AMD64_SEV, &m);
+	raw_rdmsr(MSR_AMD64_SEV, &m);
 	return m.q;
 }
 
@@ -496,7 +497,7 @@ bool early_is_sevsnp_guest(void)
 			struct msr m;
 
 			/* Obtain the address of the calling area to use */
-			boot_rdmsr(MSR_SVSM_CAA, &m);
+			raw_rdmsr(MSR_SVSM_CAA, &m);
 			boot_svsm_caa_pa = m.q;
 
 			/*
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
2.47.3


