Return-Path: <kvm+bounces-9999-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E3A3A868326
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 22:34:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9A40028EB62
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 21:34:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FE1E132C26;
	Mon, 26 Feb 2024 21:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="KpPw6VOf"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2046.outbound.protection.outlook.com [40.107.101.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C87132C1D;
	Mon, 26 Feb 2024 21:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708983195; cv=fail; b=gCcHCi7UCFSkez4bmhpw7Rvkr3I3xqvGFuZEQ1IwwC19LccyGiTQbk4FSdhH9IIB3XGWPDxkXaCWDrue22Yi2xhoS5X9h59UolebID/1INColBLYNXC1Rfrnfry/UmqD8pcD4BVRWw0p0CBW6HPq7HqtsJeRvC7Hkk0OsQPf9qs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708983195; c=relaxed/simple;
	bh=rtnGlq6gRg1XcX3RYtBqfd2Z0nbKvriH2QWs29XCtKY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tjzyz2gJgCmTFMBnTmIr2AAJa3Ow+bMPNYgSWPbA/DwOA4sncFZVhO3E2KYZeVk6s+r/poKHEcMvHEjF4BbBRWNUlLJ8FCAtbT4JcF6sOS8QTuFdeO0DmTuR5Q9gXQSoluFOZXuU5ljgjHutfmFfV4LVWlNPhxnYipPVDyvoBgw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=KpPw6VOf; arc=fail smtp.client-ip=40.107.101.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cNpB8A4WCQ9BiS5oYbFTrEy2gqY3D5GZV+Ft515pzHr546wsSVvJhFDMTRdQ3JlBl7ihH1/8qkRx+ymGNbRrFaxTiVyXRRlJcMTkUouWGO+CjlifsGJLSQlvx77Op7dCPW+nJ4yyS3Jg8FA8vpAyiuH2AzvSYpPI5H/0A5NlV+dIBAN2gdbfrL2ffx23hTW9yIZeChzTSUe1J2DGyZqX6iTwLLCZrwLuTPY0eUGwW41E57McF9OPbo9wiAeid1gGyvhj9ou7wfGLbFGpTOw+Q6GlsNLTx7824CWYu9VmaRglWuGeVH/HEYmyYExNb63kBRpoh39FQJjIt3TQxcgSjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PTY+shWmlpmyP7U4tVn/xNTUAY1T9x5k0xnVmDBdqug=;
 b=GMAxnwGwkwsGEpI8h1c7ekdp9P8+vDVNA9cO+3RzI3Mjm39ri6wxM2uAI05hLnWRZf22rKnHm1viYrfvznjY4Lq1pWaEW2BJuExH1TmyC0jUJiSijrnVVpVnt+Bzwz6lpGzwPZK5ylGX8w94AHi6/pY7DLwifY6ChzQmfGXoLMALci76BMNdsktWMM292XxuMCaQ4JGbqQ2VXW3x5MKZVVzoTPC7VCf9BWRaNQ+9Up/B1RCn9rTPEhXPDaHnJS+4yQfRmy1e+nEJYBM80kt+tlXFbiyHzvcNw8weI8GQUmWvZpAHbu5xUmp2Nqig8zzfQ1dB2bNbbnC/QNVC34nPkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PTY+shWmlpmyP7U4tVn/xNTUAY1T9x5k0xnVmDBdqug=;
 b=KpPw6VOfmjr0zllNQ2IkFW6Qom+qdpll+yRrpbCu86s72yz57tLV2QSO1/NPIIll8XvHBFewDNUYRGwkhrHwKva9+F646Da+Jyc2VsJoAq7PgRwhCH5M/1v/kSHFh6cfZNvQs2WIzjiKepdYzTYw5Xpun++lR7ywB/gNT0/CVx8=
Received: from CH5P223CA0017.NAMP223.PROD.OUTLOOK.COM (2603:10b6:610:1f3::13)
 by MW4PR12MB7382.namprd12.prod.outlook.com (2603:10b6:303:222::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.34; Mon, 26 Feb
 2024 21:33:10 +0000
Received: from CH3PEPF0000000A.namprd04.prod.outlook.com
 (2603:10b6:610:1f3:cafe::9f) by CH5P223CA0017.outlook.office365.com
 (2603:10b6:610:1f3::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.49 via Frontend
 Transport; Mon, 26 Feb 2024 21:33:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH3PEPF0000000A.mail.protection.outlook.com (10.167.244.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7292.25 via Frontend Transport; Mon, 26 Feb 2024 21:33:10 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Mon, 26 Feb
 2024 15:33:10 -0600
From: John Allen <john.allen@amd.com>
To: <kvm@vger.kernel.org>
CC: <weijiang.yang@intel.com>, <rick.p.edgecombe@intel.com>,
	<seanjc@google.com>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<pbonzini@redhat.com>, <mlevitsk@redhat.com>, <linux-kernel@vger.kernel.org>,
	<x86@kernel.org>, John Allen <john.allen@amd.com>
Subject: [PATCH v2 1/9] x86/boot: Move boot_*msr helpers to asm/shared/msr.h
Date: Mon, 26 Feb 2024 21:32:36 +0000
Message-ID: <20240226213244.18441-2-john.allen@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240226213244.18441-1-john.allen@amd.com>
References: <20240226213244.18441-1-john.allen@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF0000000A:EE_|MW4PR12MB7382:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ee56327-547d-406b-8ab8-08dc371287c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	O+LKNTD0rTvj29NC+JnmR5WGxz+uDDjfKQHf+x8Y4Cs9sinm1tTwRQon6DhRDWUeHUuJxrr9AnR+03bTm1uEzFjoplZ3xYTec0K4Z8z2F6+ylu4aV0N3pNC4neojgfP9tT4XNDd6kTDTCpc8uQw5nn+fpzEAuz0VorCdrADsTfffHORaQxv4/0urGaBCkZ4WLmJfP1XxWLTVeSI77kofE9eMm5REe2tfC46y9Vx/RCWji6zMHoQvskjWX3mOycUX6wLRlMfODrklAk0/RXgwVYEXtRVipg3yqF4HFXoYd9sFEi2cVur9Y+nBzJRCgNIkcsumiyC7aDXtwDR25NsBkgxZInvBVjs9FNoM0hYD//ZHE30K5MBz8w2ruaTq0pktIY0WFPuSqgzMaSe3oiuNCY1dJihXSp+hPGlZq9Gtzyt3OK8u+nQR8cMqYV73siXRukuQ+g47a55iu8ObHkuqxPR9ShI4uFmnol+C+EdPjNwaQFjpS0s+QRnSDrF3eVjc7U9BCihIE9u6MDhqgF7aYemn08xm2/046O7YjEI0hJfv42qZ2HDCjvYPtBh3Hn6CCL+XRFaYscwID6Ai7gamS7eqFKa9Lbjiw2WU3jQa70HzffMUm253GhCW48ybQGE20q0z6rwniJ6KPNe2LDaBbnXVVtfwRz7b9FOZIEbzFNIhq2h4PtsigttpLkGvC72ntvrXzMTyTIJgvVWb8giIfSI0yuvGtAbDZFUkFp6kMUqE5PscicwUu/wXZzvyMHUv
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2024 21:33:10.5819
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ee56327-547d-406b-8ab8-08dc371287c3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0000000A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7382

The boot_rdmsr and boot_wrmsr helpers used to reduce the need for inline
assembly in the boot kernel can also be useful in code shared by boot
and run-time kernel code. Move these helpers to asm/shared/msr.h and
rename to raw_rdmsr and raw_wrmsr to indicate that these may also be
used outside of the boot kernel.

Signed-off-by: John Allen <john.allen@amd.com>
---
v2:
  - New in v2
---
 arch/x86/boot/compressed/sev.c    | 10 +++++-----
 arch/x86/boot/cpucheck.c          | 16 ++++++++--------
 arch/x86/boot/msr.h               | 26 --------------------------
 arch/x86/include/asm/shared/msr.h | 15 +++++++++++++++
 4 files changed, 28 insertions(+), 39 deletions(-)
 delete mode 100644 arch/x86/boot/msr.h

diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
index 454acd7a2daf..743b9eb8b7c3 100644
--- a/arch/x86/boot/compressed/sev.c
+++ b/arch/x86/boot/compressed/sev.c
@@ -13,6 +13,7 @@
 #include "misc.h"
 
 #include <asm/pgtable_types.h>
+#include <asm/shared/msr.h>
 #include <asm/sev.h>
 #include <asm/trapnr.h>
 #include <asm/trap_pf.h>
@@ -23,7 +24,6 @@
 #include <asm/cpuid.h>
 
 #include "error.h"
-#include "../msr.h"
 
 static struct ghcb boot_ghcb_page __aligned(PAGE_SIZE);
 struct ghcb *boot_ghcb;
@@ -60,7 +60,7 @@ static inline u64 sev_es_rd_ghcb_msr(void)
 {
 	struct msr m;
 
-	boot_rdmsr(MSR_AMD64_SEV_ES_GHCB, &m);
+	raw_rdmsr(MSR_AMD64_SEV_ES_GHCB, &m);
 
 	return m.q;
 }
@@ -70,7 +70,7 @@ static inline void sev_es_wr_ghcb_msr(u64 val)
 	struct msr m;
 
 	m.q = val;
-	boot_wrmsr(MSR_AMD64_SEV_ES_GHCB, &m);
+	raw_wrmsr(MSR_AMD64_SEV_ES_GHCB, &m);
 }
 
 static enum es_result vc_decode_insn(struct es_em_ctxt *ctxt)
@@ -482,7 +482,7 @@ void sev_enable(struct boot_params *bp)
 	}
 
 	/* Set the SME mask if this is an SEV guest. */
-	boot_rdmsr(MSR_AMD64_SEV, &m);
+	raw_rdmsr(MSR_AMD64_SEV, &m);
 	sev_status = m.q;
 	if (!(sev_status & MSR_AMD64_SEV_ENABLED))
 		return;
@@ -523,7 +523,7 @@ u64 sev_get_status(void)
 	if (sev_check_cpu_support() < 0)
 		return 0;
 
-	boot_rdmsr(MSR_AMD64_SEV, &m);
+	raw_rdmsr(MSR_AMD64_SEV, &m);
 	return m.q;
 }
 
diff --git a/arch/x86/boot/cpucheck.c b/arch/x86/boot/cpucheck.c
index fed8d13ce252..bb5c28d0a1f1 100644
--- a/arch/x86/boot/cpucheck.c
+++ b/arch/x86/boot/cpucheck.c
@@ -25,9 +25,9 @@
 #include <asm/intel-family.h>
 #include <asm/processor-flags.h>
 #include <asm/required-features.h>
+#include <asm/shared/msr.h>
 #include <asm/msr-index.h>
 #include "string.h"
-#include "msr.h"
 
 static u32 err_flags[NCAPINTS];
 
@@ -133,9 +133,9 @@ int check_cpu(int *cpu_level_ptr, int *req_level_ptr, u32 **err_flags_ptr)
 
 		struct msr m;
 
-		boot_rdmsr(MSR_K7_HWCR, &m);
+		raw_rdmsr(MSR_K7_HWCR, &m);
 		m.l &= ~(1 << 15);
-		boot_wrmsr(MSR_K7_HWCR, &m);
+		raw_wrmsr(MSR_K7_HWCR, &m);
 
 		get_cpuflags();	/* Make sure it really did something */
 		err = check_cpuflags();
@@ -147,9 +147,9 @@ int check_cpu(int *cpu_level_ptr, int *req_level_ptr, u32 **err_flags_ptr)
 
 		struct msr m;
 
-		boot_rdmsr(MSR_VIA_FCR, &m);
+		raw_rdmsr(MSR_VIA_FCR, &m);
 		m.l |= (1 << 1) | (1 << 7);
-		boot_wrmsr(MSR_VIA_FCR, &m);
+		raw_wrmsr(MSR_VIA_FCR, &m);
 
 		set_bit(X86_FEATURE_CX8, cpu.flags);
 		err = check_cpuflags();
@@ -159,14 +159,14 @@ int check_cpu(int *cpu_level_ptr, int *req_level_ptr, u32 **err_flags_ptr)
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
2.40.1


