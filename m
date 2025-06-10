Return-Path: <kvm+bounces-48842-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 14C66AD4197
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 20:05:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 672663A74E5
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 18:04:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 025B524633C;
	Tue, 10 Jun 2025 18:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ZcTBK9CF"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2069.outbound.protection.outlook.com [40.107.220.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55222236424;
	Tue, 10 Jun 2025 18:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749578663; cv=fail; b=e0kyiCSm/arlLgocNRg+7Cabl6tvWmnJrxx4pCY0Il9TUZmZRoLJJpJytr9henm2/V7dQAz8SGhG2ThWM0N4ez+QScbJeUe25cKr8uBaQxFyqEhbqwiXOSSMvHJaSV8I9Z048bLvL49VxGIFRf2lceV/vDRCDivxz7ZCRUyRw2E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749578663; c=relaxed/simple;
	bh=yKMix7aywR4hX2CaF1SWzDI+KPC46+G61eQpJu4rBfY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YVKRzU+2NPa6uljDT6tHYs6pTLR+n2O/fuCdM3QG7yA0gVVoHc9LiSw/wCJkyzudPuZkZXjSmP68wma0rtyvSMPy4i5g9cnIi6lIo81tVhZn829GLHOb9BHyKMr4/BZHFL2vLARU+ta9Mt3npvJtIG/MDJCmvJZD0tzHgoXDEqk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ZcTBK9CF; arc=fail smtp.client-ip=40.107.220.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v/sshBHOffw/DqSFLqg8DNpV/+CqaptBMYzc+nvQPn5fAL0D6RAcl9wn9CMUT+NPN5QzZjU7fiLR4DND0aQOSAklxsTbjRlCBWyeQJHrfq12gNCn/zqCpFk6X+4C4RRjX9ZGyPZ78HLQaQUIashkTbTZQSI+lvG89bD1ae0x5f7r/zlR2mXxp9WoPFs21vztElW4bXn4K9mpS1HIecPwf5R5Op0nyvje9ByMo04BnNc7uzQWTwcKiSZ4CnJ/Apl2TOBI7p9i5ZeYpEnU+CQoPgp83X0GvbKSYrsPNuKvV4IzSciAlM8ySWi14Cz/gSaqVrOKc8cDa/+oplkYf1P6mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NztJ+riTVyQZH2Az6e5ge0RNYtl4uELU1nmwpciw1Rs=;
 b=zWp63GO9O8SzIygDNlhmLf9O+qw1cIqKMj+tGlONEdm2gbgQmrs0z4etg+/gweAteOoT74nfBXRokLi3jvwenUON7rWwggHEMK8W3nVzhQ15q6kuhVkSXnMBZbsPbQ2C8oEVMvPHmHnhyZkTvKStNNf//0r/IL4rGRnjYrXg+k6UroIp8HSREAsx+CWBrUMVIO7/vKBXzgV8GGys5W9y+TGI5IeH/5OE+PadexOA2ZtSwUdENandXeTUCFl9Z8QX0wJ8YilIhnneR79o9dW6cUg20ygPgDCoE9plXZO3MgueDwjTKrUPk2eagIZW4Mrok2CAomxTWxRP4zfxnrM+Qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NztJ+riTVyQZH2Az6e5ge0RNYtl4uELU1nmwpciw1Rs=;
 b=ZcTBK9CFsOd4o4KBhDxzXeA3gwoRxolK2PYN9RQGZuFXDyC5Y0wPiqEKi+kpOKnWJxCXAL0jGbLBYcfBhpucUS2Qahc3mun/Z2ai1Ges7cP5UEpq0lIFeKZpCfqgGTpxbewYLDgSKL96BrQDSjJ5eeE/pG9Yo4c9+nNuleB21oM=
Received: from BL1PR13CA0195.namprd13.prod.outlook.com (2603:10b6:208:2be::20)
 by DM4PR12MB8522.namprd12.prod.outlook.com (2603:10b6:8:18f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Tue, 10 Jun
 2025 18:04:18 +0000
Received: from BL02EPF0002992E.namprd02.prod.outlook.com
 (2603:10b6:208:2be:cafe::bb) by BL1PR13CA0195.outlook.office365.com
 (2603:10b6:208:2be::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.17 via Frontend Transport; Tue,
 10 Jun 2025 18:04:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0002992E.mail.protection.outlook.com (10.167.249.59) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8835.15 via Frontend Transport; Tue, 10 Jun 2025 18:04:18 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 10 Jun
 2025 13:04:09 -0500
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
Subject: [RFC PATCH v7 26/37] x86/apic: Add support to send IPI for Secure AVIC
Date: Tue, 10 Jun 2025 23:24:13 +0530
Message-ID: <20250610175424.209796-27-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250610175424.209796-1-Neeraj.Upadhyay@amd.com>
References: <20250610175424.209796-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0002992E:EE_|DM4PR12MB8522:EE_
X-MS-Office365-Filtering-Correlation-Id: f23d6305-4104-4641-ac99-08dda84937e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|7416014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?R2UoxrDCRcpfq52zFxxXMUTdlLrASVYn9zag+IubW2EqSucCd2Wr4dZ9x9ay?=
 =?us-ascii?Q?aS3v89xuDW5WNvrJjNnH0FemODAivLkW/T3zHxQjMMLW+RR2TKzEd2OHjS2Q?=
 =?us-ascii?Q?ix4tJUiMEF8H/5KC+FP0EV1HbWkKog6FJuBsustCMZdJuAOT7DbOlkQYyXhP?=
 =?us-ascii?Q?OMWi6sIJyGF/j1d1kFMBejIvQf6QQ/gaijRcq0nb4gyvtdB5uvrnIEYkgQuP?=
 =?us-ascii?Q?FVL9ZR89Xy33euEOnC7wgX7uDN7zqBBJVsFAI52poTBmYQbKRBsYgUJ1RUZS?=
 =?us-ascii?Q?D8i2huqu3Widc+m5ea00/nHe3uX5ZxMHdqzuOU398LrK5kttlMfSb1d8dHKm?=
 =?us-ascii?Q?Fd0ayVR7+886BYexB+qA05hfdoqodneHvzqUYVfIQCqraXRFGwWH4yev8LXj?=
 =?us-ascii?Q?2ObzJmm+iZwEasf+0+Vm3MGFJ1N76cQAQQUzo/Wa9Cn2mSkgVYj9J89xm0Np?=
 =?us-ascii?Q?Cty5fXU8cimROkAYSRPjZBsMCzCg8qCd8/HGE0ZmMkWbh4Z5BsTFuSLgdvbB?=
 =?us-ascii?Q?xJaLXT+HmC1yUIN/lui46Cm+BMLheWd1ygCuX45gxubMyyTloxPKqXouYh0p?=
 =?us-ascii?Q?gVNubudNruqNlwzw0Dgr9A01Hvjk44rUmecA83Pe/Ox91HmkcBnblnmAkz2/?=
 =?us-ascii?Q?27OKATQ+ZjS8e6RyeyjGV1rDbTTz7XPFDHq1xBd6BEX9lpoO5DfLJBMjuQPv?=
 =?us-ascii?Q?8c6GaxyPEIb8xI/PiI0FLeME5HTeB0xMUxkTPYjrNMi5x0ZM9vtgysxqWjjb?=
 =?us-ascii?Q?gDMW84oLQOc6BU0SsBcP3s8OT6qTwlbGeAPLsVK1otBivphmnXz8B4ZCfP0Y?=
 =?us-ascii?Q?lGsWjUveIdRaEyB/v29tkigBhPjJ53IFNgeFesa2BV/K+rH4UrDFRkVyKu0/?=
 =?us-ascii?Q?k0LuSlihYSOXEZ7DNfAz/jxPDXhgAKFph1Ap5wZGKvJERkrx1nT/YBOWkL12?=
 =?us-ascii?Q?KI3WEFU39FLe22DX6qgbA37ZN5LccQe1zF7EdKcxOBeqBv2tliHuIonzH+fZ?=
 =?us-ascii?Q?yPq02Vnt8/rP+OcuZ/mP8m9hjYqYyIRPgYW82/FC72EQRb4ngiWWlbOapNKq?=
 =?us-ascii?Q?zm8eSxVTrHjTN1EIvP+srAh+edoqjiwN2zBjBRfavp9LHv7S7Mi2kpelVkeq?=
 =?us-ascii?Q?OaYJJwpdAbAyT8MBvag4HS1wvXSDexAoNastQpfeMtpBonZYBWbQbgTTFyOh?=
 =?us-ascii?Q?UeMbvxItdUFONoJFB/T1+8Behlhqkro4a8b+FsUfdBTBiu00O7Fym3kTPNoO?=
 =?us-ascii?Q?FG0RwZq1uuHBBpCQUql7K3KQ1aY5tqFAe6CvE33YYdnchGA8R6qhXL6mnQXH?=
 =?us-ascii?Q?9ooOVpUzqzzvIlUizDjAN5qRU9DU25P2eBuCDKt2HwIddR9asyKtFksjsfLi?=
 =?us-ascii?Q?pFbnYN5/i5B0LwZUlmjy9GukJG/29ANa3kyo/RaWbsgQr5H3f6qYBe/6lxkj?=
 =?us-ascii?Q?vF07zIUeQxx5UIIrc36SYENeUv6JALADi6yqMEBrdnABhbz2J1OcPVf0zLW5?=
 =?us-ascii?Q?aCn1Elr2+KqEDzsmZuqaqk6bqrqqEErS+mo2?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(7416014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2025 18:04:18.0112
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f23d6305-4104-4641-ac99-08dda84937e8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8522

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
Changes since v6:

 - No change.

 arch/x86/coco/sev/core.c            |  28 ++++++
 arch/x86/coco/sev/vc-handle.c       |  11 ++-
 arch/x86/include/asm/sev-internal.h |   2 +
 arch/x86/include/asm/sev.h          |   2 +
 arch/x86/kernel/apic/x2apic_savic.c | 139 +++++++++++++++++++++++++++-
 5 files changed, 174 insertions(+), 8 deletions(-)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 32be4ab2f886..97cf9a8ebd5d 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1072,6 +1072,34 @@ int __init sev_es_efi_map_ghcbs(pgd_t *pgd)
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
index 0989d98da130..dd6dcc4960e4 100644
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


