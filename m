Return-Path: <kvm+bounces-58704-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DBAE3B9BCFD
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 22:09:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 904A3420FD9
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 20:09:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7E9E3233F8;
	Wed, 24 Sep 2025 20:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="mOy80gog"
X-Original-To: kvm@vger.kernel.org
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011050.outbound.protection.outlook.com [52.101.52.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67212322A2D;
	Wed, 24 Sep 2025 20:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758744563; cv=fail; b=MFysskZ5/ESeTLESfi5GYpyyIyPk/ZaNNucwze4//Np8oiaQKE2n/PMhTU3vKjNzzqUCQU+ZAeyLeicBJFeTMsTAeA7LAp28r8TUrUJXr9ot6LJFBL9d4yuSYWUlV75kbco+98uTov2lGh5PhwvXJcifB1weKW6tOQoTc33Fkd8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758744563; c=relaxed/simple;
	bh=c7ANBRbyIwhJjHbI9kEQb+RA0bw5xw9WfzCDY8OX7IQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MeYLBP6KYTU9QGjGcOFdUAXUXnifSOQH4JHInzNSwOgcfUwvAKFyJFIC9/K2VA5fZ6rYzX84f/RcqhUEfNlvMLbueOI1u7f7Zj7ORIlJ25Tp5BL40fKaIsHlhN3puT7sDiLVtmhmkYfZLcHRk9VPoqbOtUKmI9GAcHv+bIlHYwY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=mOy80gog; arc=fail smtp.client-ip=52.101.52.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OnnmZFAfbdBfnUBfvi2FP1SMS5Lb+MqEYBUZcf066ZKu/m4jCUB7fLOQe1kdfiRYV5QRJqnebFlitwDlc/Gdri858PUGMPHXrJokNQ/RC4ymFEngIAPNBteBY1ZGg72UToI/jUOYtx3R6gguMv1PqLa5/4sALhl6FwH6+fe8dYQohcYBNotATSHyBJqKfyFOP4GLl8Qd1wj1MYSbOhB4AV6xqOoVM2GWaGK78yLFch69bG30xiwxv8mCZq6qpBMzWWMZatroyw7OBu4WkjCeCYxYdGiZhcAGWyWVlHO/tcUpoSfOO93D2DUvfuxHz1j7eZBKL/n8UnofYfberPUn3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RejvX3AHkxRzPkZUmmG3ZU199Lv1Xz8NcT5KEHlfTFU=;
 b=KpXAQa6e+1513ey47YhRNfgK4EVgY42uF44Of6F+LuDAZm73LbBDJmGCK5u00wySYFcTRk9jqU37L+ten1OmHKl0cSolSkvVn5O0AYWPyBMm6npoN6nAZOzn7gXikjkStT39ZUAAvqp3DbYmGrX4lFktdCq83T+eHzgR+Xqleus2rIF4sRS8CGCeDKNFXAknKReIews4bl3kF4bqg2P2/Q7fhC0MZ/pueBG1/rmJvAkkS20uvqGuIkOQ/5EcpvhQ5ixDh2gN0IOHt6dH0eB78YjU5YN1UxcXZT+qBkv557GNCVtY5KzDBFkl7brTEHrYoWV7ebijYqhNbIWSAIC3lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RejvX3AHkxRzPkZUmmG3ZU199Lv1Xz8NcT5KEHlfTFU=;
 b=mOy80gogFKTV34ZpUWdMm06Eps5v7apbX2P673SNq3tVJV6LWXZazC7PcATnFZq0RpkClmO4sIGpFQ4qA7kam4FOFIQMbKQxaQI1JdOK7MZ04pdHxoBBjgI9om7F7dyZRKm7vF2fkxBAv99ZLXdp9IJqBieO/IQ4U3ANySlC6II=
Received: from CH2PR03CA0025.namprd03.prod.outlook.com (2603:10b6:610:59::35)
 by DS7PR12MB8276.namprd12.prod.outlook.com (2603:10b6:8:da::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.9; Wed, 24 Sep
 2025 20:09:15 +0000
Received: from CH3PEPF0000000F.namprd04.prod.outlook.com
 (2603:10b6:610:59:cafe::d) by CH2PR03CA0025.outlook.office365.com
 (2603:10b6:610:59::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.21 via Frontend Transport; Wed,
 24 Sep 2025 20:09:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH3PEPF0000000F.mail.protection.outlook.com (10.167.244.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9160.9 via Frontend Transport; Wed, 24 Sep 2025 20:09:15 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 24 Sep
 2025 13:09:14 -0700
From: John Allen <john.allen@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>
CC: <rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>,
	<weijiang.yang@intel.com>, <chao.gao@intel.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <mingo@redhat.com>,
	<tglx@linutronix.de>, <thomas.lendacky@amd.com>, John Allen
	<john.allen@amd.com>
Subject: [PATCH v3 1/2] x86/boot: Move boot_*msr helpers to asm/shared/msr.h
Date: Wed, 24 Sep 2025 20:08:51 +0000
Message-ID: <20250924200852.4452-2-john.allen@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250924200852.4452-1-john.allen@amd.com>
References: <20250924200852.4452-1-john.allen@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF0000000F:EE_|DS7PR12MB8276:EE_
X-MS-Office365-Filtering-Correlation-Id: c77d976e-7f88-46e7-111d-08ddfba63c99
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|36860700013|376014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5VSAaTpy4QydCt5Oo0lcDGEqOYh4OS+AzaC5J12lh5MmMG3smDpXn/f1V5dl?=
 =?us-ascii?Q?3LcsSqmaR5Mkvy/nyilI11csrNX2Gz+0yWKcD9M/MQ7/rweFC9dGN3FM8P53?=
 =?us-ascii?Q?z4U/VijeNgIS3DNTg5rThlYXhZemekxFw4fkOTQBK8LvgGMNz98cCfVH+QvR?=
 =?us-ascii?Q?YI8A5svJu1asJVs3IUbg7Lama1fK1sENTmBMhlLbHSQLzjl7idhhsNncviAl?=
 =?us-ascii?Q?pNhuy1S1THBW7oyJDM9bpUKO7Y6/LY732J/yYLGf3SEHi/Jp1W61JdG+45Hf?=
 =?us-ascii?Q?mHgQNjHbPrgoWxbma2N5Qv9viKnOT+n9vciI7EjZCw6zn/0/ll1F/Zl1jcy7?=
 =?us-ascii?Q?wGsodW7KNUdKNsaDFIQJq5BZe0VH7KR/nFLJgL4ux0tCNUv3aGLO5fsJWh6D?=
 =?us-ascii?Q?OjAF3UqOUJBCOUFpz/HX2u65SAHo7tVMiVjBQ4sxmKTHIgZWbdG8NPASfyC/?=
 =?us-ascii?Q?9gzuLIGBW3E3zYlaZeF0+bIWB46TMI9jJduWKZTXL4PWI3QCw3gkm3ScN56h?=
 =?us-ascii?Q?FnPCkFqZTlBb3ikIppzX7hgFjLzX0ObHi80qGH7ZE/BA0Ro4JKz76HFVOHHT?=
 =?us-ascii?Q?W9+alVwea2ASVZrCibt95+UdhGRBcVvYPaKepO/FdzSW/ddpx7CpTz3Co676?=
 =?us-ascii?Q?h5CFbLjVHvWtojaNkt0KmZzrI6pD2U5NamF1M1rFOBOPP5VgGYCdHodhn/J/?=
 =?us-ascii?Q?cHFA9Q5FrIJksyS/jG/bRmPQZex/yhNOEkW0sZkoFn1EVn4BGxMxzwoBrmYa?=
 =?us-ascii?Q?N3w/GPd9OMpOtCTadp/PpLza4sighvPt3DI6ekQmCKilVrW7b9ba1dtuH2/7?=
 =?us-ascii?Q?rBQCG2n/RUUGdc8VcAa10L0qE/XikipEouC/4yr3BljMc7Y8ldzMZT086G3R?=
 =?us-ascii?Q?FKR8N6eSB2HiLL19AS+3q503sEJwqo1+FJGik06INGupCMvr6ooRCLwViO/M?=
 =?us-ascii?Q?oviDdbInhYSR9srZvyTjpT8BHN9Ip5Tx1aAFdnZ9y2z2/gATi8ZIsOW8Ulxq?=
 =?us-ascii?Q?qk7iO6zvXiMtkuyjUzYIfEsLmDYqwpzisZZ1ehJRxMwLhK9qI8RzagM9c8g0?=
 =?us-ascii?Q?yzd3N10QRPq1HMtkl/QhffaMJKgMBPC110fal7uCsFp1/gpgnsCFkiMb/271?=
 =?us-ascii?Q?jIwIusw6c8kl7weuHw7fU+T5ZArR/LbWNxuT86rQQfQYg8PSTVEWCKtMClsW?=
 =?us-ascii?Q?Zd0Xy0Qv4s66V0CunldLqiaVaHRbFmNXAZQEaUufOggHkEMkYUrIOYlxj6WW?=
 =?us-ascii?Q?YDM2ohmRYw+BvHqpsoez68v3/gsKmLbq7i8ZegeyQ3OeMYO9nLYIB/i6TuH2?=
 =?us-ascii?Q?x7oe/720zaxNCSs+9mS/loZcKSb1whouqJ0mmapBn54nuXc1dUZR7DDgpf7A?=
 =?us-ascii?Q?7FaqgI3PN+SOOxpUTQ9S3wrLAOtQR0hUuwMB0q3nCqQSzpmq0Mf9CvtfjC3w?=
 =?us-ascii?Q?X9FphH8dA1lmcUcRvNKfapOSn5Yp63ZslUikKA+vTJj8NKSTAKngkYIgugKy?=
 =?us-ascii?Q?HdDg8F4wn+zVKXYsgPBtyYzd/aaniBlp9u1Q?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(36860700013)(376014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2025 20:09:15.5747
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c77d976e-7f88-46e7-111d-08ddfba63c99
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0000000F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8276

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


