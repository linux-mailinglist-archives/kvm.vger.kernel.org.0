Return-Path: <kvm+bounces-46450-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D9559AB644D
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 09:28:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5BFD24A2A07
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 07:28:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 021C621B195;
	Wed, 14 May 2025 07:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="aKEcUDk/"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2079.outbound.protection.outlook.com [40.107.244.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 389A21FCFFC;
	Wed, 14 May 2025 07:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747207627; cv=fail; b=HnaILsQWN5j2/FvtYwsK0T4jYGm+jjiebXLhmUOrDf2TiGqH2mur6jyR1MzyvmTlXu7HqxYR/PjT/CNrMj9bV5pdqkgKBTGDvAquiOgRhfUA6H22ofwe30/Pt6fp4R/zwyegOEf/G+617Q1zuDFi7A04Ir9vZI7iyO5WL5/M6Mw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747207627; c=relaxed/simple;
	bh=1bI7pT2Gh6rZ6Ou72WCkd7TLGc7Ez89ESHvGPr3YEDQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TTfGahikLj884n0bf1DHsNrKa5T/V4udjWxnNK14LfPyDGetBwjEJK9YaEgXKTUvUjdjzvh6v/m64rW+70OJ0UNG7lKCys9ZVfFTRuVTnq2kMq+7JFHg81nXYmTTwvB4Eo9DmO6Ar4z5RVYFBcRe95+nGdQPfY7obyWMOgFjjwY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=aKEcUDk/; arc=fail smtp.client-ip=40.107.244.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N6Zxq4v/C/02f8h6IrlX2vsb4LoUUui5hJ6kclD9ZJu0fmfxFC+tKj9EksAKax9NbGZQokvNWLeJLyGTT5wfGU5/u1ZKjQF/XXieRmvoSL4K2Ox7OxfYHchkEnSLu1DRUG63p09vu2tvdelGXKhGvSVf/jpbpq976kAY9PS8f10xBrmbHZiZVdIvnGVS2KGf5AP1YcZoFmmRkYd7grev614pBBIcxgsMX7OV3HAVr/UI87ZEK37/HSIQgyuQ6eUlJxMBf3ppBlOGt3HG8dH7tEV9uAtl1MxM+SnH038MYawIiNiOl7orTNBtWMxTRmhm0F6VRAiyWZRClBhQGkMiZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lRYb58Q8M9jGjwAkT/oYH84aUCTuJvBy9MOhUqqHvOs=;
 b=qgusBD0vGkdjbW1kzNSX5BroJcgiQPmrPzbVH7Qh8k/zDS1e7Z3UacAWvQUJzYJpBoygx0RqRjWALerrBYmUGNVy/I8hHiHOjNUuoR/6PhuZMQh51TZOfqtrLKDgBw2Yyk2xHVk4QPM5ao/xJMCaeTk7O8XMmDXLXbaygDf4Dsrw1xYYJh+76jgEKT5MfP/LhXfi7yStrw23E3khpavuNQMTExQNj5LCgvL2f54+7dyeLdhLOCCAUNyjy4jV1hYNizVDk6+uEO2GHcOGB8ZwfTnRh9+Coh4k2AgMbwSo56TS02PLCxR+vLioma5Z+CMRB+JG4s3OlJJbTW/55Fskdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lRYb58Q8M9jGjwAkT/oYH84aUCTuJvBy9MOhUqqHvOs=;
 b=aKEcUDk/KPpS+xoY8hNlTzj1+IwcgeF1RDPQwWJCrajI3zNjyE1JfoUlO7MpsiZVEy3VlO0Fg6LTwApaPciM4tN6tqA/k9gjSXArl7xRBG8Ir5QiKTODCRnUWeeqZRTNdGqKQQPGnSzs9pZ5w5okPS3OiYc0px7PePoPKijG2Uk=
Received: from BL0PR0102CA0071.prod.exchangelabs.com (2603:10b6:208:25::48) by
 IA1PR12MB6067.namprd12.prod.outlook.com (2603:10b6:208:3ed::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.23; Wed, 14 May
 2025 07:27:00 +0000
Received: from BN3PEPF0000B072.namprd04.prod.outlook.com
 (2603:10b6:208:25:cafe::e0) by BL0PR0102CA0071.outlook.office365.com
 (2603:10b6:208:25::48) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8746.16 via Frontend Transport; Wed,
 14 May 2025 07:27:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B072.mail.protection.outlook.com (10.167.243.117) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8722.18 via Frontend Transport; Wed, 14 May 2025 07:27:00 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 14 May 2025 02:26:50 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <francescolavra.fl@gmail.com>, <tiala@microsoft.com>
Subject: [RFC PATCH v6 21/32] x86/apic: Add support to send IPI for Secure AVIC
Date: Wed, 14 May 2025 12:47:52 +0530
Message-ID: <20250514071803.209166-22-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250514071803.209166-1-Neeraj.Upadhyay@amd.com>
References: <20250514071803.209166-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B072:EE_|IA1PR12MB6067:EE_
X-MS-Office365-Filtering-Correlation-Id: 82552de3-f22d-4075-4e7e-08dd92b8b771
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NTBXPLGKtD0yD4NZVpNBn8jOx9c3fGCtxaAC7vXxLi/WJ6Jy0ziQTmFT2Unt?=
 =?us-ascii?Q?k/9iIASTFlyMaLN7+EaQAJa1xCgnnDyiSE7Ktf0FdnmAh3DyBxN0jOrggYQC?=
 =?us-ascii?Q?XEyhF9Y4TlRSNBezRDHM7LUzPuVC8Wkyawe4gQzPkqmxr6SuFTUJKJhaabyz?=
 =?us-ascii?Q?HiT9GoSVsVKLH4GzwpIlOqXjhqdW2/DFnNM21L1uVGuTMlGkJa4+BxbbmuLq?=
 =?us-ascii?Q?bvMfydH3i7veN0brKrmM1GnAKwxttXbRcntxJTTIR1pghWntu4XEZSFF0fVQ?=
 =?us-ascii?Q?geEB+rOT0tdl4R0YgtnL8HXyO8nVBKSSTmruCaEw2iFFsbTT7knzGZrxoOrX?=
 =?us-ascii?Q?q5ResApOR/8LSJMDa8a+AhC4KyNsf+f9Q4ybISNTUS13V1446M2rNCwggAuw?=
 =?us-ascii?Q?cxI1XOUeWI4uncr4iV1IR8We8FfA/ClQljWyFTfZFDS8Ti6Z+3HnrK4cgJlK?=
 =?us-ascii?Q?HLpBHmBtDBWXy4zIlTuLisf+K/y4Ut9uiowuk4BiOpl/JIgMHgso4moK8hjd?=
 =?us-ascii?Q?lzcaK3QE7h4C2OhXHT0+TgEHk3ILXNkdMG+aZVSzbUvSxeLWv1qbsb30EmGo?=
 =?us-ascii?Q?rJBTa3sRM2V+cY+n8Xm6w0GJmjGK34zU5+BeLmlHxMbmfFNU8IKfug2/kmyy?=
 =?us-ascii?Q?2mmeMeKr0xkZLXhCKVn/qdYha5b1DFgKN4UJNSpFFDCCtyfu3gFs7S/ouVwR?=
 =?us-ascii?Q?fyj2XQK5gyWQwZycHWF1L+jCg7EVNUhlagh/v2fI+zE6JP9JahsHfZRMXrMR?=
 =?us-ascii?Q?ozDNn7bgae0WooGdPnUYeV4Bch42mGUg7bg+fatJmdVb9z0IsPVeTCl219Tc?=
 =?us-ascii?Q?o/2hzct8+kxFMsBpQ8dJziiyVd4Cfup5+4s/+3YL6nCPZ4u1678IeYd4S1SI?=
 =?us-ascii?Q?B+IFXjFepxiiKzWYS++IxnyRImHZJLfugnq886khNI/b+ygONsOlJBm1kwu3?=
 =?us-ascii?Q?4sJhhe4PF540d65Ht3G6UlWnarItHEqqMINinLqZwVoAh9cO3zPym+OAhKbl?=
 =?us-ascii?Q?xXAuDjept0yDBbqSR7SLyxKQbP/E0v1R+Ycjfk9bBKpxfeQ76aGsuLFtaHB2?=
 =?us-ascii?Q?CjDO1+XFswBDQctMnWB9jWJrdP9oxnvz+ouk6e9WBzbx1Pq8nTcR0pUiFMDx?=
 =?us-ascii?Q?skmsZWZ0qhygjole8b7UKpCz4aknblZSgFZOujVCbadahSKwV7SjvT3uM8px?=
 =?us-ascii?Q?fI2PvXNYiTWNwDBmlCnvG20+uucVEa/XvbESROUQfuzHKR8u5TuRoIUy4+cA?=
 =?us-ascii?Q?EHaccSJmPo8C+sUrE001VqGDdTlnNmtj+iKoyvvsAVT0PkciWa8nUGGfh3A7?=
 =?us-ascii?Q?sOhhTYWsA4lVsFcuQ7tceQDOEVjNiXd5ZogzhNOFS963UpcQqhxiDFIA6Lsp?=
 =?us-ascii?Q?M43gLDGOYyCJv73hc4H1s02OsZrun/EJmZGvAVWmnYeaHTdq9ty2Xpb76UfV?=
 =?us-ascii?Q?FzceCuG7uAnefdlNsAbF5gbDRbdegs6LfM6juHSGSDryF5rYn0Uh99u0/r4G?=
 =?us-ascii?Q?E7x1iDceFv51zno7TGhvHOYwUs1lj75VTxXB?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 07:27:00.5357
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 82552de3-f22d-4075-4e7e-08dd92b8b771
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B072.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6067

With Secure AVIC only Self-IPI is accelerated. To handle all the
other IPIs, add new callbacks for sending IPI. These callbacks write
to the IRR of the target guest vCPU's APIC backing page and issue
GHCB protocol MSR write event for the hypervisor to notify the
target vCPU about the new interrupt request.

For Secure AVIC GHCB APIC MSR writes, reuse GHCB msr handling code in
vc_handle_msr() by exposing a sev-internal sev_es_ghcb_handle_msr().

Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v5:

 - Fix merge conflicts due to addition of new file vc-handle.c at new base
   commit.

 - Fix savic_icr_write() to update the APIC_ICR value in backing page.

 - Call savic_icr_write() APIC_ICR reg in savic_write().
 
 arch/x86/coco/sev/core.c            |  28 ++++++
 arch/x86/coco/sev/vc-handle.c       |  11 ++-
 arch/x86/include/asm/sev-internal.h |   2 +
 arch/x86/include/asm/sev.h          |   2 +
 arch/x86/kernel/apic/x2apic_savic.c | 139 +++++++++++++++++++++++++++-
 5 files changed, 174 insertions(+), 8 deletions(-)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index c8093a47296d..e3aafa095067 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1006,6 +1006,34 @@ int __init sev_es_efi_map_ghcbs(pgd_t *pgd)
 	return 0;
 }
 
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
+	res = sev_es_ghcb_handle_msr(ghcb, &ctxt, true);
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
diff --git a/arch/x86/coco/sev/vc-handle.c b/arch/x86/coco/sev/vc-handle.c
index b4895c648024..b6cfa18939d8 100644
--- a/arch/x86/coco/sev/vc-handle.c
+++ b/arch/x86/coco/sev/vc-handle.c
@@ -394,14 +394,10 @@ static enum es_result __vc_handle_secure_tsc_msrs(struct pt_regs *regs, bool wri
 	return ES_OK;
 }
 
-static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
+enum es_result sev_es_ghcb_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt, bool write)
 {
 	struct pt_regs *regs = ctxt->regs;
 	enum es_result ret;
-	bool write;
-
-	/* Is it a WRMSR? */
-	write = ctxt->insn.opcode.bytes[1] == 0x30;
 
 	switch (regs->cx) {
 	case MSR_SVSM_CAA:
@@ -431,6 +427,11 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 	return ret;
 }
 
+static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
+{
+	return sev_es_ghcb_handle_msr(ghcb, ctxt, ctxt->insn.opcode.bytes[1] == 0x30);
+}
+
 static void __init vc_early_forward_exception(struct es_em_ctxt *ctxt)
 {
 	int trapnr = ctxt->fi.vector;
diff --git a/arch/x86/include/asm/sev-internal.h b/arch/x86/include/asm/sev-internal.h
index 3dfd306d1c9e..6876655183a6 100644
--- a/arch/x86/include/asm/sev-internal.h
+++ b/arch/x86/include/asm/sev-internal.h
@@ -97,6 +97,8 @@ static __always_inline void sev_es_wr_ghcb_msr(u64 val)
 	native_wrmsr(MSR_AMD64_SEV_ES_GHCB, low, high);
 }
 
+enum es_result sev_es_ghcb_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt, bool write);
+
 void snp_register_ghcb_early(unsigned long paddr);
 bool sev_es_negotiate_protocol(void);
 bool sev_es_check_cpu_features(void);
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 12bf2988ea19..f08a025c4232 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -521,6 +521,7 @@ int snp_svsm_vtpm_send_command(u8 *buffer);
 void __init snp_secure_tsc_prepare(void);
 void __init snp_secure_tsc_init(void);
 enum es_result savic_register_gpa(u64 gpa);
+void savic_ghcb_msr_write(u32 reg, u64 value);
 
 static __always_inline void vc_ghcb_invalidate(struct ghcb *ghcb)
 {
@@ -594,6 +595,7 @@ static inline int snp_svsm_vtpm_send_command(u8 *buffer) { return -ENODEV; }
 static inline void __init snp_secure_tsc_prepare(void) { }
 static inline void __init snp_secure_tsc_init(void) { }
 static inline enum es_result savic_register_gpa(u64 gpa) { return ES_UNSUPPORTED; }
+static inline void savic_ghcb_msr_write(u32 reg, u64 value) { }
 
 #endif	/* CONFIG_AMD_MEM_ENCRYPT */
 
diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 2e6b62041968..2a95e549ff68 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/cc_platform.h>
+#include <linux/cpumask.h>
 #include <linux/percpu-defs.h>
 #include <linux/align.h>
 
@@ -109,6 +110,74 @@ static u32 savic_read(u32 reg)
 
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
+	struct apic_page *ap = this_cpu_ptr(apic_page);
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
+	apic_set_reg64(ap, APIC_ICR, icr_data);
+}
+
 static void savic_write(u32 reg, u32 data)
 {
 	struct apic_page *ap = this_cpu_ptr(apic_page);
@@ -119,7 +188,6 @@ static void savic_write(u32 reg, u32 data)
 	case APIC_LVT1:
 	case APIC_TMICT:
 	case APIC_TDCR:
-	case APIC_SELF_IPI:
 	case APIC_TASKPRI:
 	case APIC_EOI:
 	case APIC_SPIV:
@@ -135,7 +203,10 @@ static void savic_write(u32 reg, u32 data)
 		apic_set_reg(ap, reg, data);
 		break;
 	case APIC_ICR:
-		apic_set_reg64(ap, reg, (u64) data);
+		savic_icr_write(data, 0);
+		break;
+	case APIC_SELF_IPI:
+		self_ipi_reg_write(data);
 		break;
 	/* ALLOWED_IRR offsets are writable */
 	case SAVIC_ALLOWED_IRR ... SAVIC_ALLOWED_IRR + 0x70:
@@ -149,6 +220,61 @@ static void savic_write(u32 reg, u32 data)
 	}
 }
 
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
@@ -228,13 +354,20 @@ static struct apic apic_x2apic_savic __ro_after_init = {
 
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


