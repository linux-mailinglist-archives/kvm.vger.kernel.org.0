Return-Path: <kvm+bounces-57015-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C1057B49AF9
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 22:22:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B42F24E120D
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 20:21:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC6092DCC1A;
	Mon,  8 Sep 2025 20:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="rvKO7cCU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2048.outbound.protection.outlook.com [40.107.223.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 622CE2DC338;
	Mon,  8 Sep 2025 20:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757362863; cv=fail; b=X7a6vressDS3QSlv5u+LjP1fWqhWHAPV6afO01xqMGkbsB6Di1d/v94HDy6iNLBe6OE8vZkh0nfKH/yzSHpc74x1ngJ/ZCwygN4C1I6mfRBONYfCwEXPXTKBwNOgX44VxcSesVYKFhOKPfYmJN0sj6d3EGnMuGoqEDXb5rwKChA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757362863; c=relaxed/simple;
	bh=c7ANBRbyIwhJjHbI9kEQb+RA0bw5xw9WfzCDY8OX7IQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FkTFb1TnGZ+Ks9PZHTaHoIeHGX7hfjZger0431yS11yyRNDRu3r8IB05/2ovUk7WU+SL04zjkBilBlNQmuzOWNcEbGnngdeuAmR/VhdcXsc2+YSVkniJfq2y/CWQ6S6odZTqGoPXBG/MRVKdrIv4hBjQMC+NlMOV1gpb3Qru6go=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=rvKO7cCU; arc=fail smtp.client-ip=40.107.223.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NgoITV4JjfzvHpwGCifCfJ/HEDEm1BWS0l1TjiyY7kHTAehTgBQ++u+MaHttg8gp+zf2sBKp12VXesi5T1Pq4Lm8VhgDl2KBMLzkcAOjsPiMMCUfGFgBtcIKg8cNtTdSZNtPlPSPr5r7fkQm1PrpauUpRNZIuYz8xcysSB1mQEq0O+xM6V+ugX8i1jlgzQ4tqdQj3vHaLYM5W1r0mvMvbkKopA46FxT2jXR1aPzfYxp9Jxy7dMV+wP33CTEI6mXIbm/bwcdbGDHwMstjx3oCrpjjDOS6shrGAIxvFg74PrqE3Q6zRZkiI3iQGv88nN4qvVTJJZj5PCVZbsgooZkbmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RejvX3AHkxRzPkZUmmG3ZU199Lv1Xz8NcT5KEHlfTFU=;
 b=uY9/XEeqg+Qd9vByUpcapLxzaE5c/Zry1KFyYWettcHNKE0g840XkMd0kCxCFw+BKb24jGT0XQttCQLgEE+aJTMiCd603fnze9xamH+GRdFBzF8R1w9eI9vfnV/k9TODU1dyjmrHDa92BRqpP97OG7bgbbfe6ksO2F6TuTyKJZ8ZfvVvepuieHcsF17OwUPNICm1nN7LfpdzCeRF7PsiQGQhsjAcV//Fa0bjCqsfImf/E8MD2h60IYe00paf0EiSXm33rYZnTA52rGKc/lb+ADqmiV24GFVFnAihn+y+F3KJaw5l6pU0DLlKE7ytoGtQGxBQEWLhLEf62KVBaEczFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RejvX3AHkxRzPkZUmmG3ZU199Lv1Xz8NcT5KEHlfTFU=;
 b=rvKO7cCUr/naA0qq6SgPlMPzjQpySsTt4cG1Z7FCNaMhPTMxwrmr2r/R3XD3dgPue1ksSZ4fAo0NtjhxROUpC1clOSyIex4N1MELejnkSWMtm3Jv0bjHNCGBPYXAwBKiw+OQtFk+xesnJqeMpS+JZbYH83fto85Ea4+cLXN5JAA=
Received: from SA0PR11CA0128.namprd11.prod.outlook.com (2603:10b6:806:131::13)
 by DS0PR12MB8293.namprd12.prod.outlook.com (2603:10b6:8:f3::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.19; Mon, 8 Sep 2025 20:20:59 +0000
Received: from SN1PEPF0002529F.namprd05.prod.outlook.com
 (2603:10b6:806:131:cafe::fa) by SA0PR11CA0128.outlook.office365.com
 (2603:10b6:806:131::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.22 via Frontend Transport; Mon,
 8 Sep 2025 20:20:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF0002529F.mail.protection.outlook.com (10.167.242.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9115.13 via Frontend Transport; Mon, 8 Sep 2025 20:20:57 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 8 Sep
 2025 13:20:56 -0700
From: John Allen <john.allen@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>
CC: <rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>,
	<weijiang.yang@intel.com>, <chao.gao@intel.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <mingo@redhat.com>,
	<tglx@linutronix.de>, <thomas.lendacky@amd.com>, John Allen
	<john.allen@amd.com>
Subject: [PATCH v2 1/2] x86/boot: Move boot_*msr helpers to asm/shared/msr.h
Date: Mon, 8 Sep 2025 20:20:33 +0000
Message-ID: <20250908202034.98854-2-john.allen@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250908202034.98854-1-john.allen@amd.com>
References: <20250908202034.98854-1-john.allen@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002529F:EE_|DS0PR12MB8293:EE_
X-MS-Office365-Filtering-Correlation-Id: 04d8530d-e0d9-47d8-8494-08ddef153887
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?t2wFtt2VfVOrDA2Dxoq8tg2XrSICzizLsvNV00tcKqiTpX/dVj+mwJYdSzQf?=
 =?us-ascii?Q?b7QqRubx4cXfiERGVQr40xdE5moynPZ0d1ea7ZdUpp+8Rmms8Vfu6lZ9c53H?=
 =?us-ascii?Q?4dTLk+Nnre3BL0eukyE1+DvPKrHpZ3N3dKsO1DJR8apVUHg72tDYYIrd5+5C?=
 =?us-ascii?Q?KcRBMqXQmYdWeowJ3ey/HP7mMD3AP7NinYQuExfGTInZmt69GnO0GF949UDr?=
 =?us-ascii?Q?S2vcL5tSIHVB4MIMurE0mWSs9q03/MwBK1B3VdxWdtvdOSGPhVoVljbCiJ8I?=
 =?us-ascii?Q?1V0J2X+rQ9SASIgoNjqxtknfSeI7I17oBzZsOavRy/i/k/ovXB0rFSbGEiAt?=
 =?us-ascii?Q?dVd45cBu8xhRsUBS/DjDgsf0L0xiffn8cmlGfr0GSkaZphVmT7ShmHqucsMU?=
 =?us-ascii?Q?4lfAaRVaouAun0Dr0fFjvKfYesHI2pEcDiKBvMMeTRznjYKxNO9OUptdID4U?=
 =?us-ascii?Q?76BmmacgO8aFh6cMZIWLlRGZmnkLu1LXOndp8H31QRsPvib/Tth6C1AIF2/5?=
 =?us-ascii?Q?IC/TAGuFTXJMRXOkeexzVu6iSDblvdfAk0nhLU/b4TCLpm8RtBLGAdQf4F0J?=
 =?us-ascii?Q?v3jEQ+yxo8rCHoOfl2qBGyrlE3Ti5/7Se3SsskpdK6SfxLbAL1hxP5XA96RH?=
 =?us-ascii?Q?QGAFhRQYF5RfX/MPLpS77ym9lECQOaBbvXpt7V4Q8u4oXTN3Q6IECU6tGyzX?=
 =?us-ascii?Q?Kaf6C8N3+cpB/wEDd5FC096SQ+ZiDsPBQ9wEmm8fnccXmKLUJndUsA6jKrxl?=
 =?us-ascii?Q?q/e3KxsbKACg7rMoou35OYh6OgAtSbVcAvq/1oy8Mh1j4YkIeJtKbsFCyP2N?=
 =?us-ascii?Q?dS9sxBtPxbet2+MTORy3ift6ku5pXtHeJG0Kj9XqrdyxVI3MP2hZx9PXj5no?=
 =?us-ascii?Q?vB+o0ctVawNLxfnxyAcSKcchDlYHrznsU9yEostzCjmlAVDDQwz2f44XOwwb?=
 =?us-ascii?Q?X1tw7+v3GznDRvdG14or5Cyiww9MX5PkeqX+mNvy8qbHFM3sfhKFQHql4vAy?=
 =?us-ascii?Q?xHR1T6dQhCNLUrMrQPwMFFBhj8FzI8VqS4j2TabwO4fqNiEvRid0EUf9xZjm?=
 =?us-ascii?Q?pEH94t9gC9+E73DUJ0sa8ZirXpEPJ7lXrhmq829WSd2giRGEoKob0+4Ky80/?=
 =?us-ascii?Q?2I8ejXmAv1Gi+rerchSniR7QOC2iNYILuXg4c0FDYQUBHalYUgYSRZCf4y26?=
 =?us-ascii?Q?KHov7eD9MlFCDo6RAOw3sxVgrY/nosThnr8KDXq2foIcL3hBoUq3JO9ekNWR?=
 =?us-ascii?Q?dKIk9vI3hcrn2KtLDZtDQq6FYld9cAg4CsyUG/vnnWB/3EhAs0Gy2a4WQoVT?=
 =?us-ascii?Q?mf1ZRoeluwTzVcv9jj1O/2vwoUNI2lxNH9p/clUf6p2cpghj5SwQzyF3J4m+?=
 =?us-ascii?Q?2pXGRroex+oCB28CJKcdHhgM/IA21zELx4o+ulaEkTzShRW/aEt5+ThS1cq0?=
 =?us-ascii?Q?6YTsKGc69WwpKpGm9sW/2GcoXn3cZqQajUywhqRylSifB7LmU6NbCqf5yKYU?=
 =?us-ascii?Q?YzkuCmZw5pDAlfFa+eJdKOQLYVCOVTYoBPR0?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 20:20:57.7581
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 04d8530d-e0d9-47d8-8494-08ddef153887
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002529F.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8293

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
2.47.3


