Return-Path: <kvm+bounces-42306-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1185FA779B5
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 13:39:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C8D2216BE62
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 11:38:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 933601FAC5A;
	Tue,  1 Apr 2025 11:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4hMj2vvv"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2044.outbound.protection.outlook.com [40.107.220.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCECD1E766E;
	Tue,  1 Apr 2025 11:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743507514; cv=fail; b=IyDqvJOK6DZ//6f560zwHiqgrLYoCXI2rsh1PgF1Zp9YuS3iKNXCha+VGo0efYSW5jhNVIFE3O4OGbkvSPCdllk2lx7OpApsFqvjNhlxTwwJm0rBeeIqisxHMdJvSHXkmoNZpAuGSZqmsaKVKtkwpMq3lkjATafHcQUNE/MiEl4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743507514; c=relaxed/simple;
	bh=WnzMDg2ZaFvKiN/JiuMw8cG/zWrczoZOnaf+9SSIi1U=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Mt8DGPeBcujK1w2kZNLp0gwn8KR2QeGbQC9t+3+It+EDgtzhUFO7ydaD5FohokkcVHFK/XMEG2eIYE8YR3Md6S3H+DoiKbV/SVvtDG2HSryxvF7nzMkiFfAFKcv/Tu5FlqYqLDnLymsRxJNE1R6uAiy89Fn2wRjPJyaOraBvrLk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4hMj2vvv; arc=fail smtp.client-ip=40.107.220.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VQab0t5J9urDqzetZ8Eh+a2QNHV16vnXls/IwIfIV9l6SsXjjidWYcsUICcaxa7EHnnOZrv/238leUrVUCL4pNKrw0p7Mdphl7XZuYojMexf0zRfmIRnWn+HDRspc61ZMxTULtO1DDgmX6rARcCdFVTNuKqXHyC1zTN1LdWedJMem36xVHFSnwG1MGSY89WP1GitBUPSiIGXNbyTsoLZ4wynSloglFHjZNAxmraSTuG7u54yicxi2X+LPjaZep+T+UE1f0zZHliG1R7H7D5lSHHk29GGZvkrZTtZ8BONeVuIkedvstuueSAc2Ea6+4DN8ZUBI2hnmUzujRU6VQ7CkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aIz2UHWXgcSm1AU0rtiPp18/2WQXK1VZUvxsQmA+0uc=;
 b=FDmcyLXhBl966fXYMv1e2kj+dJyLts3Ei1LaY8s4g0LM+SgV92x5+07baAeYrCr05UUrM25C8iRKr63hg2IRyg9XuYAaDTSk0FcqLMTI4FufCxLBSoxaRe+8KYvvRC00jzHgSyRBsJ9XJJn0PB97CSzrGnw+on4RSVcP9jqHxNliIvn+GzAvVhvjUIdEIO/CXbyhFfclTNGM/KYUw2u4B/442L9HTwLPCMGwMIAnt9sTcwUrz82gCoCx3TefPkgnC0KZJTd2ya1G7b4pfg7W2nrOBL/Hd7k3ZPvY1Orflcry7iY+/RGFhjDnXR/f8ctdefnMOQs51/CetM/8hcpyYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aIz2UHWXgcSm1AU0rtiPp18/2WQXK1VZUvxsQmA+0uc=;
 b=4hMj2vvvNBAySLHkx6yMBkH1p9Zgo2gZW/1XNBgVTQCx+iHGwvU4/1Qyw9l4Yc0HQmQQ/iTAKWMYWb+6j6z0ziQhTEk0+1fPwxMhdipw6WGfTBHFkqdyy82nKxy/odKZ9duuTE3aujRoJdJfkeRijUltO/NBB9QPczyS2ly4wFo=
Received: from PH8PR21CA0003.namprd21.prod.outlook.com (2603:10b6:510:2ce::14)
 by LV8PR12MB9111.namprd12.prod.outlook.com (2603:10b6:408:189::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Tue, 1 Apr
 2025 11:38:26 +0000
Received: from CO1PEPF000044F7.namprd21.prod.outlook.com
 (2603:10b6:510:2ce:cafe::12) by PH8PR21CA0003.outlook.office365.com
 (2603:10b6:510:2ce::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8632.4 via Frontend Transport; Tue, 1
 Apr 2025 11:38:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044F7.mail.protection.outlook.com (10.167.241.197) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8632.2 via Frontend Transport; Tue, 1 Apr 2025 11:38:25 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 1 Apr
 2025 06:38:18 -0500
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
Subject: [PATCH v3 06/17] x86/apic: Add support to send IPI for Secure AVIC
Date: Tue, 1 Apr 2025 17:06:05 +0530
Message-ID: <20250401113616.204203-7-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250401113616.204203-1-Neeraj.Upadhyay@amd.com>
References: <20250401113616.204203-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F7:EE_|LV8PR12MB9111:EE_
X-MS-Office365-Filtering-Correlation-Id: 33bfcd42-ff81-4e87-d839-08dd7111b6d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bTOk2UhP4xGneUhmbF26tPyQYFpM2g2fRUPMQHSBcFrr4zggojJLgPWA21Zm?=
 =?us-ascii?Q?hXpi2zfDgNjT2WhF2GDiE0SmDgdZxAOR/WmiRPRouKKaYovCMtqoy6dk7/Ia?=
 =?us-ascii?Q?jy9+nFd8PSrYGJDZzfbECbfW24M35OQqTx34XTwLxGKNn1uwxESZ6Iwbkrhh?=
 =?us-ascii?Q?UkJdgtPZkGyI3Dd6ui+jS25MXBsbxTRgvGAvYtOUjJwlQE0+4kJjpSniebiY?=
 =?us-ascii?Q?zHjTrneCPLcoovhJXD5MqORqY+I5KyNlXrcoDZ8An0zet+JgJHLEhs6OvSuE?=
 =?us-ascii?Q?uKE7e2FtLuQC4qlQ57PB9jT7/fvx5SkW33S/fogHz04jNpZdcd/i99cvzUuz?=
 =?us-ascii?Q?NVULYBmQMs01UnUUtbBl32peDsy3srvBOu1LQGTMhE4KPCNkBMpFyOtRSd/U?=
 =?us-ascii?Q?p67uFBWxxiEKht2p16OXEhCIexwsBm6iHnsSypyb0CgKohktmm/cEiBWf1zu?=
 =?us-ascii?Q?oniDk86/woWKJE97uxfO3j0mMl/rClr/trDGrQZK1Mm28BBW7c8meLNWwDCp?=
 =?us-ascii?Q?E7nWea68dspH4hjmmhBQk5TFwVIUOl4Oo3AuFodCLDBXZXwiU8+z6AC9yg1b?=
 =?us-ascii?Q?SWcg2EuHrtg5lBSbjrjGTNz1WD8p1e0LEdSTJGKZuC0FfgDi+in4sUmVkrv7?=
 =?us-ascii?Q?QUtVjMXTFjio4U0lBMMAnsHf2JybOUCsltGuJNIf7OMmZtGEIV+zrz2WtXUB?=
 =?us-ascii?Q?AiLCm9qQsyvspPgJrwY8Y71FMX0A/Ni0h9yCbndTZ/yOlYmogqWBAVCqLfBV?=
 =?us-ascii?Q?OC7PYYhGa5MEZDEJnnKX2l+d/ow7fG2w/oQODnt5Vshr9wbqVzwxS0kFhAQH?=
 =?us-ascii?Q?G4eG+6v+44vaJqDjnhm68aRYBXP8tzk4nXz8FmbNbO2TiJxMjS9n3c8R+KCH?=
 =?us-ascii?Q?pyFg7HbTQa/Mu8iRfcDKtIg+gD1/lmGSJ0werKauQQ9JZbNTWY3vY7s0jtNN?=
 =?us-ascii?Q?0soCWAFFqWCF7d6UVjfg472pwA08qeLXvjv7++HeWW/yNa4Ff2CZ3IHVQz25?=
 =?us-ascii?Q?O6ENUpj7RjKCyP1+Y4q5qc42ys0FptIuN3KxyTRF+RxZQwdbycUECs1YVEXO?=
 =?us-ascii?Q?pGQTm1O8EHcwTYhl/F9eAFQcgjlBAl0tKWZ6IhmZ17PZ1Cwaf4IOX2HkTscO?=
 =?us-ascii?Q?EPg5BGhrmBLEtEEBRJBV1DDYQQ561k88sc0Q+4rFW05gH7387qK1jM5qdpnv?=
 =?us-ascii?Q?H+GQltJAEz8Rxp2L9a7xSgbeD6wGOSTJ7MM9HDD7KwWRa0iHoprDkFd6lTrP?=
 =?us-ascii?Q?ieKDIdDbVNUUBhhFFPbB1CI0mXtWTedqErAJdeYHfswJx+j9HyJa2mcs2jYV?=
 =?us-ascii?Q?3lQF9+g7UcPQY01FROWHssar/g87CpGbUVE6n/Ld0y+bdMrX/hb26zgiOSAR?=
 =?us-ascii?Q?sd+5uOCBz5ttps7504GuzdHZu1SDM/5QCNZL4ZWdsAWvdQmoTK7dcdygRPp5?=
 =?us-ascii?Q?wUlCP5+VAKNOY9lSGwUr+iqahFU47WgX8eKblzTCSTzVNFUPVpJGC3s3d+Oh?=
 =?us-ascii?Q?t2R/7LgRyt6gMgU=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2025 11:38:25.0905
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 33bfcd42-ff81-4e87-d839-08dd7111b6d6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F7.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9111

With Secure AVIC only Self-IPI is accelerated. To handle all the
other IPIs, add new callbacks for sending IPI, which write to the
IRR of the target guest vCPU's APIC backing page and then issue
GHCB protocol MSR write event for the hypervisor to notify the
target vCPU.

Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v2:
 - Simplify vector updates in bitmap.
 - Cleanup icr_data parcelling and unparcelling.
 - Misc cleanups.
 - Fix warning reported by kernel test robot.

 arch/x86/coco/sev/core.c            |  40 ++++++-
 arch/x86/include/asm/sev.h          |   2 +
 arch/x86/kernel/apic/x2apic_savic.c | 164 ++++++++++++++++++++++------
 3 files changed, 167 insertions(+), 39 deletions(-)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 036833ac17e1..e53147a630c3 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1464,14 +1464,10 @@ static enum es_result __vc_handle_secure_tsc_msrs(struct pt_regs *regs, bool wri
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
@@ -1501,6 +1497,40 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
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
+	unsigned long flags;
+	enum es_result ret;
+	struct ghcb *ghcb;
+
+	local_irq_save(flags);
+	ghcb = __sev_get_ghcb(&state);
+	vc_ghcb_invalidate(ghcb);
+
+	ret = __vc_handle_msr(ghcb, &ctxt, true);
+	if (ret != ES_OK) {
+		pr_err("Secure AVIC msr (0x%llx) write returned error (%d)\n", msr, ret);
+		/* MSR writes should never fail. Any failure is fatal error for SNP guest */
+		snp_abort();
+	}
+
+	__sev_put_ghcb(&state);
+	local_irq_restore(flags);
+}
+
 enum es_result savic_register_gpa(u64 gpa)
 {
 	struct ghcb_state state;
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 3448032bae8c..855c705ee074 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -484,6 +484,7 @@ int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_req *req
 void __init snp_secure_tsc_prepare(void);
 void __init snp_secure_tsc_init(void);
 enum es_result savic_register_gpa(u64 gpa);
+void savic_ghcb_msr_write(u32 reg, u64 value);
 
 #else	/* !CONFIG_AMD_MEM_ENCRYPT */
 
@@ -528,6 +529,7 @@ static inline int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_
 static inline void __init snp_secure_tsc_prepare(void) { }
 static inline void __init snp_secure_tsc_init(void) { }
 static inline enum es_result savic_register_gpa(u64 gpa) { return ES_UNSUPPORTED; }
+static inline void savic_ghcb_msr_write(u32 reg, u64 value) { }
 
 #endif	/* CONFIG_AMD_MEM_ENCRYPT */
 
diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 0bb649e3527d..657e560978e7 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -46,6 +46,25 @@ static __always_inline void set_reg(unsigned int offset, u32 val)
 
 #define SAVIC_ALLOWED_IRR	0x204
 
+static inline void update_vector(unsigned int cpu, unsigned int offset,
+				 unsigned int vector, bool set)
+{
+	struct apic_page *ap = per_cpu_ptr(apic_page, cpu);
+	unsigned long *reg = (unsigned long *) &ap->bytes[offset];
+	unsigned int bit;
+
+	/*
+	 * The registers are 32-bit wide and 16-byte aligned.
+	 * Compensate for the resulting bit number spacing.
+	 */
+	bit = vector + 96 * (vector / 32);
+
+	if (set)
+		set_bit(bit, reg);
+	else
+		clear_bit(bit, reg);
+}
+
 static u32 x2apic_savic_read(u32 reg)
 {
 	/*
@@ -109,6 +128,17 @@ static u32 x2apic_savic_read(u32 reg)
 
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
 static void x2apic_savic_write(u32 reg, u32 data)
 {
 	switch (reg) {
@@ -117,7 +147,6 @@ static void x2apic_savic_write(u32 reg, u32 data)
 	case APIC_LVT1:
 	case APIC_TMICT:
 	case APIC_TDCR:
-	case APIC_SELF_IPI:
 	case APIC_TASKPRI:
 	case APIC_EOI:
 	case APIC_SPIV:
@@ -133,6 +162,9 @@ static void x2apic_savic_write(u32 reg, u32 data)
 	case APIC_EILVTn(0) ... APIC_EILVTn(3):
 		set_reg(reg, data);
 		break;
+	case APIC_SELF_IPI:
+		self_ipi_reg_write(data);
+		break;
 	/* ALLOWED_IRR offsets are writable */
 	case SAVIC_ALLOWED_IRR ... SAVIC_ALLOWED_IRR + 0x70:
 		if (IS_ALIGNED(reg - SAVIC_ALLOWED_IRR, 16)) {
@@ -145,62 +177,126 @@ static void x2apic_savic_write(u32 reg, u32 data)
 	}
 }
 
+static inline void send_ipi_dest(unsigned int cpu, unsigned int vector)
+{
+	update_vector(cpu, APIC_IRR, vector, true);
+}
+
+static void send_ipi_allbut(unsigned int vector)
+{
+	unsigned int cpu, src_cpu;
+	unsigned long flags;
+
+	local_irq_save(flags);
+
+	src_cpu = raw_smp_processor_id();
+
+	for_each_cpu(cpu, cpu_online_mask) {
+		if (cpu == src_cpu)
+			continue;
+		send_ipi_dest(cpu, vector);
+	}
+
+	local_irq_restore(flags);
+}
+
+static inline void self_ipi(unsigned int vector)
+{
+	u32 icr_low = APIC_SELF_IPI | vector;
+
+	native_x2apic_icr_write(icr_low, 0);
+}
+
+static void x2apic_savic_icr_write(u32 icr_low, u32 icr_high)
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
+	x2apic_savic_icr_write(icr_low, dest);
+}
+
 static void x2apic_savic_send_ipi(int cpu, int vector)
 {
 	u32 dest = per_cpu(x86_cpu_to_apicid, cpu);
 
-	/* x2apic MSRs are special and need a special fence: */
-	weak_wrmsr_fence();
-	__x2apic_send_IPI_dest(dest, vector, APIC_DEST_PHYSICAL);
+	send_ipi(dest, vector, 0);
 }
 
-static void __send_ipi_mask(const struct cpumask *mask, int vector, bool excl_self)
+static void send_ipi_mask(const struct cpumask *mask, unsigned int vector, bool excl_self)
 {
-	unsigned long query_cpu;
-	unsigned long this_cpu;
+	unsigned int this_cpu;
+	unsigned int cpu;
 	unsigned long flags;
 
-	/* x2apic MSRs are special and need a special fence: */
-	weak_wrmsr_fence();
-
 	local_irq_save(flags);
 
-	this_cpu = smp_processor_id();
-	for_each_cpu(query_cpu, mask) {
-		if (excl_self && this_cpu == query_cpu)
+	this_cpu = raw_smp_processor_id();
+
+	for_each_cpu(cpu, mask) {
+		if (excl_self && cpu == this_cpu)
 			continue;
-		__x2apic_send_IPI_dest(per_cpu(x86_cpu_to_apicid, query_cpu),
-				       vector, APIC_DEST_PHYSICAL);
+		send_ipi(per_cpu(x86_cpu_to_apicid, cpu), vector, 0);
 	}
+
 	local_irq_restore(flags);
 }
 
 static void x2apic_savic_send_ipi_mask(const struct cpumask *mask, int vector)
 {
-	__send_ipi_mask(mask, vector, false);
+	send_ipi_mask(mask, vector, false);
 }
 
 static void x2apic_savic_send_ipi_mask_allbutself(const struct cpumask *mask, int vector)
 {
-	__send_ipi_mask(mask, vector, true);
+	send_ipi_mask(mask, vector, true);
 }
 
-static void x2apic_savic_update_vector(unsigned int cpu, unsigned int vector, bool set)
+static void x2apic_savic_send_ipi_allbutself(int vector)
 {
-	struct apic_page *ap = per_cpu_ptr(apic_page, cpu);
-	unsigned long *sirr = (unsigned long *) &ap->bytes[SAVIC_ALLOWED_IRR];
-	unsigned int bit;
+	send_ipi(0, vector, APIC_DEST_ALLBUT);
+}
 
-	/*
-	 * The registers are 32-bit wide and 16-byte aligned.
-	 * Compensate for the resulting bit number spacing.
-	 */
-	bit = vector + 96 * (vector / 32);
+static void x2apic_savic_send_ipi_all(int vector)
+{
+	send_ipi(0, vector, APIC_DEST_ALLINC);
+}
 
-	if (set)
-		set_bit(bit, sirr);
-	else
-		clear_bit(bit, sirr);
+static void x2apic_savic_send_ipi_self(int vector)
+{
+	self_ipi_reg_write(vector);
+}
+
+static void x2apic_savic_update_vector(unsigned int cpu, unsigned int vector, bool set)
+{
+	update_vector(cpu, SAVIC_ALLOWED_IRR, vector, set);
 }
 
 static void init_apic_page(void)
@@ -279,16 +375,16 @@ static struct apic apic_x2apic_savic __ro_after_init = {
 	.send_IPI			= x2apic_savic_send_ipi,
 	.send_IPI_mask			= x2apic_savic_send_ipi_mask,
 	.send_IPI_mask_allbutself	= x2apic_savic_send_ipi_mask_allbutself,
-	.send_IPI_allbutself		= x2apic_send_IPI_allbutself,
-	.send_IPI_all			= x2apic_send_IPI_all,
-	.send_IPI_self			= x2apic_send_IPI_self,
+	.send_IPI_allbutself		= x2apic_savic_send_ipi_allbutself,
+	.send_IPI_all			= x2apic_savic_send_ipi_all,
+	.send_IPI_self			= x2apic_savic_send_ipi_self,
 	.nmi_to_offline_cpu		= true,
 
 	.read				= x2apic_savic_read,
 	.write				= x2apic_savic_write,
 	.eoi				= native_apic_msr_eoi,
 	.icr_read			= native_x2apic_icr_read,
-	.icr_write			= native_x2apic_icr_write,
+	.icr_write			= x2apic_savic_icr_write,
 
 	.update_vector			= x2apic_savic_update_vector,
 };
-- 
2.34.1


