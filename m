Return-Path: <kvm+bounces-44697-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C1203AA02DC
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 08:16:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 97C737B09B3
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 06:14:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F0F0275878;
	Tue, 29 Apr 2025 06:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="SiaC41+k"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2071.outbound.protection.outlook.com [40.107.92.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66429274678;
	Tue, 29 Apr 2025 06:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745907242; cv=fail; b=eEpCMIFSgVg9HwvL7eEJeUEmpUfvgqETBPf+tkPYiiDoI+uVlO5or9SI0BbsxmwfztIZIbE+9QI9pSdaA+/7kIEHsYrNYJlfaulVim3qBy1vSrLLWDnwIU+wgjYBIx/oCQABb96eN6Iq3D3LF5S1YU53neL7WQKp5domyKwVK+A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745907242; c=relaxed/simple;
	bh=ywgQEYEB0V3GwpgocRz6rzElCJj4HisNKKPX2hHRFu4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DKLp/c1hE7PDIo4Z81cp9RU7YG9X9pTnhbu8TdnFYzF1S8BQRzKap6AA7Zg/la2BSe9vWDknxjnKWOdlICvY/MK11CzxC9s6Js5XLJcV7D5hN3pvCrSKzL+8sC9VK4JGeRNm7Nyi5qy2MIRM2kZymz59Q5tA/tpeOoAfW9R43RE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=SiaC41+k; arc=fail smtp.client-ip=40.107.92.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JnFDOX9mVKGEIohzPVjcqf5HntTnejvqdtCCz1WEavnTzHBkTJM1PE1Hfeq1lfQTPTMCQH7sikKQ647gmpk82CGCLfcHSqXeng0xvPRi7PbdadyPupdr1flcsTOtTFHeJf+vF9wkio3+q6djteHEWdxrj3mah5vD/+thQDH7PXQfnjMJZVfij42h9RJb0GhVDaiTQqOpFcNImPMW0gpYDuohevJOHjjzaYuTMP13vGM8mE0JQQ2KIwDW4jka1fPzNO/fPQPNWnHVZD5MkkmtfZ47VG7tme2cqM1X4zn1uuhJ/+3TgckpyRfg9eQ5H+7zMLhcNr9Ae5EfFo8kgjKG+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jFEuTrvrzuRI8l+UZ8gvROO5P7lQrSKSt2kQeAqi3YY=;
 b=H4FvsiPdTCC2R5yl8Z1A2gRkpJSBvd0h4cLeo9ShDs3JwW6fCcVwR4u+suMVF0J3rRdgym9wWAihfmPqEVbNuwauv0/7YryDN9r9rFZS55gYs/gkk069kg8VenDOwwZxl0uJdE7NEZh3efkRWpoBb+VWqZnyor94Ba3+T+W98A41e2epxlTw8P1OxbbHzVc08/YB0IaFvnALz4UQwDBsbP76Xcw6CmXNu7uVQ5ZwbWsBR7RxrPU+KcEuQkHDSLtGceEf+JPxNdjfDiwUJ/IyH4XrGOI6EGvRR0iY55+CLqnP4S4Fo2vpQEUf8++nq9A1im+d/vVIh+rcojdYDxDJKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jFEuTrvrzuRI8l+UZ8gvROO5P7lQrSKSt2kQeAqi3YY=;
 b=SiaC41+kYsW8j8r/oIGpZvdzcPt/EYZmDMzFGi4saUSfVwVPs0xt7WDVjXSDpjWrnROUvOMUvCZbiYZGjw2Afv2YQ2ldN52jhFt2cgho+iia22KJf3lc0GY5WyekgUCSO8GSDF88pTGqCbedw2WQqcGJ7GiLNiROi7NWktsYG2k=
Received: from BN9PR03CA0086.namprd03.prod.outlook.com (2603:10b6:408:fc::31)
 by SA1PR12MB7410.namprd12.prod.outlook.com (2603:10b6:806:2b4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.31; Tue, 29 Apr
 2025 06:13:54 +0000
Received: from BL6PEPF0001AB57.namprd02.prod.outlook.com
 (2603:10b6:408:fc:cafe::52) by BN9PR03CA0086.outlook.office365.com
 (2603:10b6:408:fc::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.36 via Frontend Transport; Tue,
 29 Apr 2025 06:13:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB57.mail.protection.outlook.com (10.167.241.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8678.33 via Frontend Transport; Tue, 29 Apr 2025 06:13:54 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 29 Apr 2025 01:13:46 -0500
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
Subject: [PATCH v5 09/20] x86/apic: Add support to send IPI for Secure AVIC
Date: Tue, 29 Apr 2025 11:39:53 +0530
Message-ID: <20250429061004.205839-10-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250429061004.205839-1-Neeraj.Upadhyay@amd.com>
References: <20250429061004.205839-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB57:EE_|SA1PR12MB7410:EE_
X-MS-Office365-Filtering-Correlation-Id: 399266e3-e989-43b4-dd30-08dd86e504cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700013|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?O2bHRgq6OlXyfpkFMfFtp5BsVj3v0DqahAj1cO02//i+gRW+EmlAuig4gR/w?=
 =?us-ascii?Q?HCAuCc8RatTLkKf8S5wMjY5p0R94wjE7k53VNk5X5r9oOt/Gq4+iw98v+Y55?=
 =?us-ascii?Q?2vHGGpqLVsSroeM+43EhWEkedIsXxT4cA/C9IsGxYHhlWd+xCmniAx+Nn7TE?=
 =?us-ascii?Q?NKIZYUAMdtg5DI6SGRWnNewEIQTqfg6KMC9Au+i8L4yO7opjOOLJ40XHiIN0?=
 =?us-ascii?Q?21px+MI4ne73lspvmlkVWiuDjExXaUwmIo42E3wnzp8gUj9bx4swvmLNJEEm?=
 =?us-ascii?Q?PUf/y3PRH4DA8wR+VcoIUBMbZUwYJs1VqeyBzEBEa4dtorGjJel9GJGIrwzy?=
 =?us-ascii?Q?6s5Djn4EfiIbEzYmX5WeOuHvANNnXyfNgf26hApfGoTisqwzMrhQlN4pi7+4?=
 =?us-ascii?Q?p+yExTjrsG2qc771cauu851rIumyhhPTw7aj0R+JSvEtVWxjMP8rBZly6LEJ?=
 =?us-ascii?Q?aQyq5chxYlUu3uLC9gqKHxpSpHxpy4+nC/P4FdJ+/e1JRFy+yi0WANldwtj2?=
 =?us-ascii?Q?62Zgu81Sm1KZGtWPAyK+iBOq9YbYMHuItb539Gd0krQOUEBNyVz8TTJ0BezK?=
 =?us-ascii?Q?jD7fx3gB9HPnQxCT70nPWz8RQDStsR7AVC3bx/snhn7Aexb5vPDDx2sCBEe7?=
 =?us-ascii?Q?f+A2e18ndq69XWWAnHO56DO79yPGQFZ2ur0bGP0RB2MZHOzNu6qyz4nKBNoE?=
 =?us-ascii?Q?9WJBQUiW4aEiokFxbAa2lgot6xWRwEH78K/YXNLyI/TaDPSIBM0tTx/cQmqZ?=
 =?us-ascii?Q?qNV33FnebSEGtqLDrT+pkvAwf3mfLZ3IxvxRHK8uvJ/fl4sF1DFRxKrr4EnB?=
 =?us-ascii?Q?AB6X9TwDra+0o7EzcBXnOV03aBagDrJKoHyG0UwkifozdBY/frujrm2a0C4y?=
 =?us-ascii?Q?md2G8uAvlWLuEhnZDV+qyy6Bk3DlgBQ7LOjTMkQbKRxCxjkvzg+w6qlHXnEU?=
 =?us-ascii?Q?axe+fLXyGYPpMxqpT3bmT3A0pbqFDrMeVCz3rSiNZeCCxVcgMLBIzr2Ls+wj?=
 =?us-ascii?Q?TrOWuechJKPbM+mx9nVueehpcQSzRQCui9qkXk+WmoULEGYUb6iY2u9RbWZw?=
 =?us-ascii?Q?Hrxek7MrqAW/HsrKhlQsBBG9tpW8dxAyjjaChgPvZQVSwUhUNdT7/nbw1rDO?=
 =?us-ascii?Q?QVvQ4pFsB/fkC9siBjEUrf3U4wwTHCF51CMoKaxTXHj/9IsJfZgdqYaSNxB0?=
 =?us-ascii?Q?MDb22VqBGDNwjIiCc3LKbV0zROehzcN3DoZjN9eOmemTe+Dw3rcOPyWHD66L?=
 =?us-ascii?Q?GwC8lmCZoIMxGVhV4jUVK7O1vkaoAnJP7hB8+Jnz2ojKF92IJyK3ez+CN7Mw?=
 =?us-ascii?Q?EG1Ik+1sU2GoBPKEPxIsOaFYktpCGxHZQRJBRqXOFDeCGwISef8sZ/D0S5IV?=
 =?us-ascii?Q?lgMzmT8Gtf6xNUv2mWYKR8cXINNxx5oV0Srnvo3CvVdvGgPXY+C8Ww4iNvWp?=
 =?us-ascii?Q?c7qVrKHfTj741HlrQ6WjcRwIF3K3a5c79yvhmXJFne2HhpNaibMrVX2WCY1g?=
 =?us-ascii?Q?/a30ZEV3m2v1qQ2SzcBv/xo2zLCGnAXCNqbD?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2025 06:13:54.2142
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 399266e3-e989-43b4-dd30-08dd86e504cb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB57.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7410

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
Changes since v4:
 - Resolve merge conflicts with new sev-startup.c addition in mainline.
 - Add a sev-internal sev_es_ghcb_handle_msr() to reuse GHCB msr
   handling bits for savic GHCB msr writes.

 arch/x86/boot/startup/sev-startup.c |  11 +--
 arch/x86/coco/sev/core.c            |  28 ++++++
 arch/x86/include/asm/sev-internal.h |   2 +
 arch/x86/include/asm/sev.h          |   2 +
 arch/x86/kernel/apic/x2apic_savic.c | 135 +++++++++++++++++++++++++++-
 5 files changed, 171 insertions(+), 7 deletions(-)

diff --git a/arch/x86/boot/startup/sev-startup.c b/arch/x86/boot/startup/sev-startup.c
index f901ce9680e6..af7ba9aab46d 100644
--- a/arch/x86/boot/startup/sev-startup.c
+++ b/arch/x86/boot/startup/sev-startup.c
@@ -610,14 +610,10 @@ static enum es_result __vc_handle_secure_tsc_msrs(struct pt_regs *regs, bool wri
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
@@ -647,6 +643,11 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
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
diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index bf03eaa6fd31..545d314f4a83 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1004,6 +1004,34 @@ int __init sev_es_efi_map_ghcbs(pgd_t *pgd)
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
diff --git a/arch/x86/include/asm/sev-internal.h b/arch/x86/include/asm/sev-internal.h
index a78f97208a39..7d44b1772704 100644
--- a/arch/x86/include/asm/sev-internal.h
+++ b/arch/x86/include/asm/sev-internal.h
@@ -100,6 +100,8 @@ static __always_inline void sev_es_wr_ghcb_msr(u64 val)
 	native_wrmsr(MSR_AMD64_SEV_ES_GHCB, low, high);
 }
 
+enum es_result sev_es_ghcb_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt, bool write);
+
 enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
 				   struct es_em_ctxt *ctxt,
 				   u64 exit_code, u64 exit_info_1,
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
index 9d2e93656037..9398b34a5184 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/cc_platform.h>
+#include <linux/cpumask.h>
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


