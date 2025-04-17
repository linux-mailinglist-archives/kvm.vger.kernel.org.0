Return-Path: <kvm+bounces-43545-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A65FA9179A
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 11:21:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1ECE917711B
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 09:20:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15EC8227599;
	Thu, 17 Apr 2025 09:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="W2UL2kBd"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2082.outbound.protection.outlook.com [40.107.223.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779BE207E0C;
	Thu, 17 Apr 2025 09:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744881628; cv=fail; b=uEwzvRKY3kARR6dQE9IQxfsT1jK1j1MFi1ih75lZF5FPdqtEeAocnDX3dhGoDNAjkO4gQeNMk+BPkHKfB2tpcwR3xZcBizgHj4tjlvwEUVISmnAv5/QKGp+DONuBjsIWp6k72SZf8zjhjrgrzDX4lOl9fxaNRt2/7so/kPJHQNI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744881628; c=relaxed/simple;
	bh=R5y5IssbXHrnWiiBNNK0AaRxQrGAEvQJmqnO5slT5zc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A5+Y8w0hZIZCrz76i7dYlhTy8NO8NpKR6awIKtok8jvk1ug1KkP2Ej/ygul9RM5d9mRAwal5R4E85wir77xgSnrdVS89hdSEjw+nUknPe7FUOp3VSW54sZt0HuNrJFrqcCeMqiS15lcmArf/3jQviCyt58fNdGrLjQe6wglQRfA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=W2UL2kBd; arc=fail smtp.client-ip=40.107.223.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PiJctMoru+nRIlp1sh17hXriE0Kkw/P9PR4omR0UETiuMyK4QevukUDSwD4g3jZ/kybeVMZrgSetkq6WwuGLPI+hqqMlGt5piqmQkbyUypnAl9NSKSQwN7AUvbWfQ13rUw8Aq0CBS+xS5gWC+u5VNQwBiIfqKBs5bJ0+o4eW/keIz2Jyz25YSC9ITtnn2v0OB+iX6RdmMO5yXBHlJl3VJxjoFTr1lD8q1uYNzchmzgGzy2QNJygTPKviZYZMW5skldOj8Ds+/AulPQJJzah59JeHCkExcsMrx+8f0tdmCy3IPM7bQdFWpsWAigZ5Q2D3aWjyurv3v8gUZffu3iRWMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=03+R6ZXFVJeY+h4BXv9xA+UHA8abuabJ/EK8+Edm++k=;
 b=ECTFLY7P3v9Mc55vtWJiKoW9U+Id1Zyce0konZfWzUfstZCe9ajiCs/J61dE9fS85CLa8PRXaUbNmjveNv4lx+3dEsVPiIsIOoAd8Sbe9EDIP7nk3c8+pcXxT5oGY9Y2UHFH+8Ta/pAWGjVNKmq80JM+rbEd1onBUfI/3JS5NLnCZmnW6yQ1OJ7AUMRZnk2iuG4IAztoEhisWHe2PYpTqc1MQTFZdJg2troamNfZn4Fg03KDrud+WF8/TGK0Yxr/s+hk8clNyXFzz84X0NCsLVA4DzQNC8L8CIAxaHyfhSMTP2qGWMzuWUboxhrmgLoCUEuYbNgeVykeTSEOkiNO0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=03+R6ZXFVJeY+h4BXv9xA+UHA8abuabJ/EK8+Edm++k=;
 b=W2UL2kBde6J2HYoCLt65FNxDqAz834rp0vOMcHeienpdEFIZjiAhO7eWJxVAnDW1mEW8jUcGbgQbgxLK6WYoismMpeIgSxu0S5cggF7LAtk8/2jJjCLL/06WYKaPAooRnle72gd7PWdDuLhqyE9Fv0/A1ztFCW5v3NH47IyZ45E=
Received: from BL1PR13CA0317.namprd13.prod.outlook.com (2603:10b6:208:2c1::22)
 by PH7PR12MB6810.namprd12.prod.outlook.com (2603:10b6:510:1b4::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.34; Thu, 17 Apr
 2025 09:20:20 +0000
Received: from BN2PEPF000055E0.namprd21.prod.outlook.com
 (2603:10b6:208:2c1:cafe::5b) by BL1PR13CA0317.outlook.office365.com
 (2603:10b6:208:2c1::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.12 via Frontend Transport; Thu,
 17 Apr 2025 09:20:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF000055E0.mail.protection.outlook.com (10.167.245.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8678.4 via Frontend Transport; Thu, 17 Apr 2025 09:20:19 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 17 Apr 2025 04:20:08 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <francescolavra.fl@gmail.com>
Subject: [PATCH v4 07/18] x86/apic: Add support to send IPI for Secure AVIC
Date: Thu, 17 Apr 2025 14:46:57 +0530
Message-ID: <20250417091708.215826-8-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250417091708.215826-1-Neeraj.Upadhyay@amd.com>
References: <20250417091708.215826-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000055E0:EE_|PH7PR12MB6810:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ed01ee4-2619-4331-b074-08dd7d911304
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|36860700013|1800799024|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9Rfj4Th0EjTatv3yIfTYB5FyK3p6J1OYxFuF6fYcfkLlNHad2L4uba9q4mex?=
 =?us-ascii?Q?CAwA98CaYZVGlAw/qIJsy2ohYU0llc/Hr5LUay00u2DsISUoXXJfBoL3gZvv?=
 =?us-ascii?Q?c873Cc04kAGFZmmSHQer060GJ/AhmzpqagjAZOkbteHrRu8iMbxt01ZECOoS?=
 =?us-ascii?Q?WE8nlZ8Ly2+Ew2+3mitRnUYIYGzEFtvoSHcbFjFpGLanahJpuxAsGPjwaYwW?=
 =?us-ascii?Q?yEnb2siBixp7lx93giqq7kWo1j21Bn4wgtPq0jt5iXNLWA2rJB6gtzilituf?=
 =?us-ascii?Q?gsR706Z5LmOLap399lbBg2g86s5GVgMgHJQaeHNx8QxcicxDZFfqVMTZb5LU?=
 =?us-ascii?Q?+psca0emsTr4VehE8iIjzWM5TXAk4LnZB8hmQmrys5C5UWNjX5VtDUC/LcFm?=
 =?us-ascii?Q?7cpTlrTYw3ROXPE3ffaTLyviJ3Y2lhSoFKKwjnoFsY/sgL/2Sq2sSm9Uh951?=
 =?us-ascii?Q?ymKy7bRvyB+LTDzvGnnxBwPD/FKP/ekMtN0RTCsqvxEwzzE78v3tfrsg5sBC?=
 =?us-ascii?Q?6P/ZDtcjDVeq5UEPHNaUUwzs3oWT2xxykbFuulPHGzJnovwIwqw1fUfE0spH?=
 =?us-ascii?Q?ABZlc8TUrIMt4J+r+aoKszmDIkd188P/FdxbDhUhC/y/eUaPWScJfBR2/+is?=
 =?us-ascii?Q?RffeY9iugdeXv/5i4W0D9kz0BXdwN+4FUaEwODjATvjFB64NxPx2zdA87+Ny?=
 =?us-ascii?Q?xk6j9b73SsuvN5bkI60Elfg7CTvEN/B9FTLZqRyZXqGS7+TpSDi4d4n2LNLW?=
 =?us-ascii?Q?u37RnqwFYJuvK6OMzv1dZ/WmvaPQKiFZ7ZALi/Iysue4+Foeku+IppPjfya/?=
 =?us-ascii?Q?yapSxcSr74Q0ob5l8Ceoux+O6jK5xraRWoxmNVzqdkwOYWbeMQTHjIN35tS6?=
 =?us-ascii?Q?hs0/dohvoZpllgw9sckNs6xCfNE/QgAbD8UtkhnfSnmD0BIgCZkk39ku2J09?=
 =?us-ascii?Q?Wie8BEj+AETpBHU/py+uPC3zDOVX9NQ9lvRaYVXP/9ebdav1VNaGSEQEROXm?=
 =?us-ascii?Q?T4Ye1MDIXf4PWvdF4nq6ooaU9zMNJN1/3pZxAOfNohOWtlg9yWLRpcXzSGqu?=
 =?us-ascii?Q?arB3v16ZEIEjayZeswk9uMkwRIhQL/oGQ3QLrZBxCQasYglCwWeZNfmoS+Dy?=
 =?us-ascii?Q?tDE9WleZqe0t6fVUu5F+rs998lMUKshmL0/TP0oD4ianZ7fyGF0717aCck0O?=
 =?us-ascii?Q?doAKBjy+TuWpYaW6fb4Ak2jzXO0Pdvg96D815jtKDtaFxGdGnSk3f1gNuR4L?=
 =?us-ascii?Q?ZE0hkVqNL6PfCHTuAEAKi1+xXvLF47iEEtmjTumfwmnXJtXCgKqloXfe1AEH?=
 =?us-ascii?Q?woe6g9I1tVij209j4sWg69woKrDn2OcMrHzKvhIzrgLnQWe6dWj+n1nXgCKK?=
 =?us-ascii?Q?qXC89VycAngqpO/rdZD35k6MoeEZwNIJ4siGZ+UXWe69CFrM7nf/4jW8yS7U?=
 =?us-ascii?Q?HhlIFLA080uKm1H0+JOTLqEDDV2Tuls2m2MIsk/JTPThlLB5HPURtfks7t2t?=
 =?us-ascii?Q?xS5IXUgfX8PUAqpmGyQKk6rZh2Q+uWV8gmCs?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(36860700013)(1800799024)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2025 09:20:19.8736
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ed01ee4-2619-4331-b074-08dd7d911304
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055E0.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6810

With Secure AVIC only Self-IPI is accelerated. To handle all the
other IPIs, add new callbacks for sending IPI, which write to the
IRR of the target guest vCPU's APIC backing page and then issue
GHCB protocol MSR write event for the hypervisor to notify the
target vCPU.

Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v3:

 - Use guard(irqsave)() in savic_ghcb_msr_write().
 - Remove "x2apic_" from savic's apic callback names.
 - Misc cleanups.

 arch/x86/coco/sev/core.c            |  39 ++++++--
 arch/x86/include/asm/sev.h          |   2 +
 arch/x86/kernel/apic/x2apic_savic.c | 135 +++++++++++++++++++++++++++-
 3 files changed, 169 insertions(+), 7 deletions(-)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 6046a325abd6..603110703605 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1382,14 +1382,10 @@ static enum es_result __vc_handle_secure_tsc_msrs(struct pt_regs *regs, bool wri
 	return ES_OK;
 }
 
-static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
+static enum es_result __vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt, bool write)
 {
 	struct pt_regs *regs = ctxt->regs;
 	enum es_result ret;
-	bool write;
-
-	/* Is it a WRMSR? */
-	write = ctxt->insn.opcode.bytes[1] == 0x30;
 
 	switch (regs->cx) {
 	case MSR_SVSM_CAA:
@@ -1419,6 +1415,39 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 	return ret;
 }
 
+static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
+{
+	return __vc_handle_msr(ghcb, ctxt, ctxt->insn.opcode.bytes[1] == 0x30);
+}
+
+void savic_ghcb_msr_write(u32 reg, u64 value)
+{
+	u64 msr = APIC_BASE_MSR + (reg >> 4);
+	struct pt_regs regs = {
+		.cx = msr,
+		.ax = lower_32_bits(value),
+		.dx = upper_32_bits(value)
+	};
+	struct es_em_ctxt ctxt = { .regs = &regs };
+	struct ghcb_state state;
+	enum es_result res;
+	struct ghcb *ghcb;
+
+	guard(irqsave)();
+
+	ghcb = __sev_get_ghcb(&state);
+	vc_ghcb_invalidate(ghcb);
+
+	res = __vc_handle_msr(ghcb, &ctxt, true);
+	if (res != ES_OK) {
+		pr_err("Secure AVIC msr (0x%llx) write returned error (%d)\n", msr, res);
+		/* MSR writes should never fail. Any failure is fatal error for SNP guest */
+		snp_abort();
+	}
+
+	__sev_put_ghcb(&state);
+}
+
 enum es_result savic_register_gpa(u64 gpa)
 {
 	struct ghcb_state state;
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 4246fdc31afa..2056e7be41d0 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -521,6 +521,7 @@ int snp_svsm_vtpm_send_command(u8 *buffer);
 void __init snp_secure_tsc_prepare(void);
 void __init snp_secure_tsc_init(void);
 enum es_result savic_register_gpa(u64 gpa);
+void savic_ghcb_msr_write(u32 reg, u64 value);
 
 static __always_inline void vc_ghcb_invalidate(struct ghcb *ghcb)
 {
@@ -572,6 +573,7 @@ static inline int snp_svsm_vtpm_send_command(u8 *buffer) { return -ENODEV; }
 static inline void __init snp_secure_tsc_prepare(void) { }
 static inline void __init snp_secure_tsc_init(void) { }
 static inline enum es_result savic_register_gpa(u64 gpa) { return ES_UNSUPPORTED; }
+static inline void savic_ghcb_msr_write(u32 reg, u64 value) { }
 
 #endif	/* CONFIG_AMD_MEM_ENCRYPT */
 
diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 9d2e93656037..d3e585881c5c 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -7,6 +7,7 @@
  * Author: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
  */
 
+#include <linux/cpumask.h>
 #include <linux/cc_platform.h>
 #include <linux/percpu-defs.h>
 #include <linux/align.h>
@@ -136,6 +137,17 @@ static u32 savic_read(u32 reg)
 
 #define SAVIC_NMI_REQ		0x278
 
+static inline void self_ipi_reg_write(unsigned int vector)
+{
+	/*
+	 * Secure AVIC hardware accelerates guest's MSR write to SELF_IPI
+	 * register. It updates the IRR in the APIC backing page, evaluates
+	 * the new IRR for interrupt injection and continues with guest
+	 * code execution.
+	 */
+	native_apic_msr_write(APIC_SELF_IPI, vector);
+}
+
 static void savic_write(u32 reg, u32 data)
 {
 	switch (reg) {
@@ -144,7 +156,6 @@ static void savic_write(u32 reg, u32 data)
 	case APIC_LVT1:
 	case APIC_TMICT:
 	case APIC_TDCR:
-	case APIC_SELF_IPI:
 	case APIC_TASKPRI:
 	case APIC_EOI:
 	case APIC_SPIV:
@@ -160,6 +171,9 @@ static void savic_write(u32 reg, u32 data)
 	case APIC_EILVTn(0) ... APIC_EILVTn(3):
 		set_reg(reg, data);
 		break;
+	case APIC_SELF_IPI:
+		self_ipi_reg_write(data);
+		break;
 	/* ALLOWED_IRR offsets are writable */
 	case SAVIC_ALLOWED_IRR ... SAVIC_ALLOWED_IRR + 0x70:
 		if (IS_ALIGNED(reg - SAVIC_ALLOWED_IRR, 16)) {
@@ -172,6 +186,116 @@ static void savic_write(u32 reg, u32 data)
 	}
 }
 
+static void send_ipi_dest(unsigned int cpu, unsigned int vector)
+{
+	update_vector(cpu, APIC_IRR, vector, true);
+}
+
+static void send_ipi_allbut(unsigned int vector)
+{
+	unsigned int cpu, src_cpu;
+
+	guard(irqsave)();
+
+	src_cpu = raw_smp_processor_id();
+
+	for_each_cpu(cpu, cpu_online_mask) {
+		if (cpu == src_cpu)
+			continue;
+		send_ipi_dest(cpu, vector);
+	}
+}
+
+static inline void self_ipi(unsigned int vector)
+{
+	u32 icr_low = APIC_SELF_IPI | vector;
+
+	native_x2apic_icr_write(icr_low, 0);
+}
+
+static void savic_icr_write(u32 icr_low, u32 icr_high)
+{
+	unsigned int dsh, vector;
+	u64 icr_data;
+
+	dsh = icr_low & APIC_DEST_ALLBUT;
+	vector = icr_low & APIC_VECTOR_MASK;
+
+	switch (dsh) {
+	case APIC_DEST_SELF:
+		self_ipi(vector);
+		break;
+	case APIC_DEST_ALLINC:
+		self_ipi(vector);
+		fallthrough;
+	case APIC_DEST_ALLBUT:
+		send_ipi_allbut(vector);
+		break;
+	default:
+		send_ipi_dest(icr_high, vector);
+		break;
+	}
+
+	icr_data = ((u64)icr_high) << 32 | icr_low;
+	if (dsh != APIC_DEST_SELF)
+		savic_ghcb_msr_write(APIC_ICR, icr_data);
+}
+
+static void send_ipi(u32 dest, unsigned int vector, unsigned int dsh)
+{
+	unsigned int icr_low;
+
+	icr_low = __prepare_ICR(dsh, vector, APIC_DEST_PHYSICAL);
+	savic_icr_write(icr_low, dest);
+}
+
+static void savic_send_ipi(int cpu, int vector)
+{
+	u32 dest = per_cpu(x86_cpu_to_apicid, cpu);
+
+	send_ipi(dest, vector, 0);
+}
+
+static void send_ipi_mask(const struct cpumask *mask, unsigned int vector, bool excl_self)
+{
+	unsigned int cpu, this_cpu;
+
+	guard(irqsave)();
+
+	this_cpu = raw_smp_processor_id();
+
+	for_each_cpu(cpu, mask) {
+		if (excl_self && cpu == this_cpu)
+			continue;
+		send_ipi(per_cpu(x86_cpu_to_apicid, cpu), vector, 0);
+	}
+}
+
+static void savic_send_ipi_mask(const struct cpumask *mask, int vector)
+{
+	send_ipi_mask(mask, vector, false);
+}
+
+static void savic_send_ipi_mask_allbutself(const struct cpumask *mask, int vector)
+{
+	send_ipi_mask(mask, vector, true);
+}
+
+static void savic_send_ipi_allbutself(int vector)
+{
+	send_ipi(0, vector, APIC_DEST_ALLBUT);
+}
+
+static void savic_send_ipi_all(int vector)
+{
+	send_ipi(0, vector, APIC_DEST_ALLINC);
+}
+
+static void savic_send_ipi_self(int vector)
+{
+	self_ipi_reg_write(vector);
+}
+
 static void savic_update_vector(unsigned int cpu, unsigned int vector, bool set)
 {
 	update_vector(cpu, SAVIC_ALLOWED_IRR, vector, set);
@@ -251,13 +375,20 @@ static struct apic apic_x2apic_savic __ro_after_init = {
 
 	.calc_dest_apicid		= apic_default_calc_apicid,
 
+	.send_IPI			= savic_send_ipi,
+	.send_IPI_mask			= savic_send_ipi_mask,
+	.send_IPI_mask_allbutself	= savic_send_ipi_mask_allbutself,
+	.send_IPI_allbutself		= savic_send_ipi_allbutself,
+	.send_IPI_all			= savic_send_ipi_all,
+	.send_IPI_self			= savic_send_ipi_self,
+
 	.nmi_to_offline_cpu		= true,
 
 	.read				= savic_read,
 	.write				= savic_write,
 	.eoi				= native_apic_msr_eoi,
 	.icr_read			= native_x2apic_icr_read,
-	.icr_write			= native_x2apic_icr_write,
+	.icr_write			= savic_icr_write,
 
 	.update_vector			= savic_update_vector,
 };
-- 
2.34.1


