Return-Path: <kvm+bounces-54395-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 93284B20446
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 11:49:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9F92A18C2023
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 09:49:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E46FF21D00E;
	Mon, 11 Aug 2025 09:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="yObn8FQU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2078.outbound.protection.outlook.com [40.107.244.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE8D20D50C;
	Mon, 11 Aug 2025 09:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754905652; cv=fail; b=ddu8PE2oAKG7LFwNN9UG7BKmpJDKgM5YwiVoalBU+fRP7p2hY/vVygyxfd0CfECNRos5wSb4NwoSbUL3Eb9lha7dpeIo7wzddDLZa+0ErtzldDG+B9M66Z5flsRfUK9ErLZtAkKA4woUWchvUubir2G5iQ9htj/hBryGV7vVG1k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754905652; c=relaxed/simple;
	bh=ldg1/F0v9zbbEE6vI0AvHAmbwhvVohCtGbAN1IZbFxs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HKUJiT4TZ1xeXaSEOCKRYFeI/9oVctzxk9lrDweiSblx98FWEjTS6TbSeh2w+uQwrqxIS4BayTi6Ndfl5SH5HbwefvPitx71lbkt678Jvb2b3UWl+Z0dAV7glsmEKjpjJPJ4nV+zvbTS8j3kSIsge9zAfPbwYuNuuLvOE6P49Lo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=yObn8FQU; arc=fail smtp.client-ip=40.107.244.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eX6cpzX4gCvcFDlu/PycYv6ZI4NLP867AUT8J89Xt0IuniMirvWsqIVl3EAZUp90xwskPreI4uEPGBkKqpmp2TRndG2quoWpSbIxwt5tv5OyNJ9wLHOEyY+jDc/38Mi0womfAgZDuqfOMcs+CwoXwerMlIYd9poF4z9wMHnvvkY8E8hQWdm0rioE8fsp6ueUejDFcBStXPeuoFDr3hc6lo0KIrBzs9+9ww2ygAfev62AqE2Bf674klSgKn5IG9738ikmZZTr8WV1Gx245bhFaz1eFIPK3eCam1JYCeRygUcEUIgTm+SBtXIN1cYBDHMttu0LW13aote/PAvt2ZvzPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r5WsYXUrFFjeeCKFlLmbK66wPd9/mxxbliew4Uv3Wug=;
 b=JR/HC7hzp66sgJZ36jWY09QMvQ97jSorrmtfEDyO1UAxW8mRx2XLqhSk6w6ksBNKzJJmWJGPkEi8P24b/0r3WN2/K9fcPeMSzeCSEVa4errRMy3ZJya50i4qWvRz2cMguYCdo8zt09YxFLL+jT4FpMAGbi9bC3mmBq2Ajgz1yxQmoMyZveWGuD/rrWXnSUnSJIfJ2nCD2XGaAdFILSb/beYMI7bcMecTW7+yFxZ9JmIgcbr0XjS23bqJ3E7uKYKpEp+4j+tjb+4GTN9dMS5ozUcp6JGzAmyMiBkSLRnBO5hc1HGA2fhDJoGeVxsMnoTWmGjmmJ1TY8PzJTXr6M+DAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r5WsYXUrFFjeeCKFlLmbK66wPd9/mxxbliew4Uv3Wug=;
 b=yObn8FQU16Ft4UOGEO93QWGbHpzZKGZ/3WJdXhk6c8xybkpTPt7w8mXrrsV5/7LJprAoYSrP0If0UBnhfmt//61+JqhAAQznDFeVz24tvJaWFJIu9te0N/lKPR3dtSvUxdciMnHH6mGPaRYJLqwcbTOdrHIG4e+h/IsRsu1YCUg=
Received: from CH0PR03CA0221.namprd03.prod.outlook.com (2603:10b6:610:e7::16)
 by PH7PR12MB8106.namprd12.prod.outlook.com (2603:10b6:510:2ba::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.21; Mon, 11 Aug
 2025 09:47:26 +0000
Received: from CH2PEPF0000013D.namprd02.prod.outlook.com
 (2603:10b6:610:e7:cafe::7b) by CH0PR03CA0221.outlook.office365.com
 (2603:10b6:610:e7::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9009.21 via Frontend Transport; Mon,
 11 Aug 2025 09:47:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH2PEPF0000013D.mail.protection.outlook.com (10.167.244.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9031.11 via Frontend Transport; Mon, 11 Aug 2025 09:47:26 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 11 Aug
 2025 04:47:18 -0500
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
Subject: [PATCH v9 07/18] x86/apic: Add support to send IPI for Secure AVIC
Date: Mon, 11 Aug 2025 15:14:33 +0530
Message-ID: <20250811094444.203161-8-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250811094444.203161-1-Neeraj.Upadhyay@amd.com>
References: <20250811094444.203161-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF0000013D:EE_|PH7PR12MB8106:EE_
X-MS-Office365-Filtering-Correlation-Id: 520f0bea-e645-4b3d-bfed-08ddd8bc1451
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?i88LsNbRw+sGZSJWf0k+VsEnqt2YvpDj7U+uOUWcEIFbiVeLSuZJMFc3fJme?=
 =?us-ascii?Q?6IGj8xU0YUS0LoaZ2KuRxKR2rKxn2/47VhloammTHeuV11ueIDR3uNCqrH6t?=
 =?us-ascii?Q?wA7wefWbeJLfwk0HPlZs+KhNNjLb0+LOmNy4qikzR6zd+vx2Cf/fbTMbIQo/?=
 =?us-ascii?Q?AAqALBropQ6eDwUB8M0lpT5fnX4AHLchApl89nNnNfmS4Z9QpvjeW5d4hRM4?=
 =?us-ascii?Q?xUyUhj8bi+DYRLrBiZTlPLWIshv+6GjamqlTg95fWyiMXMoyDQkFMVvKQ5Cq?=
 =?us-ascii?Q?WoKnucVcYJEGI4EppdvxrEttR25uu32KmuJ2ABRU1lY+uspPtkdwK6aGICgx?=
 =?us-ascii?Q?I/KKRAWHVdaXcBHL5jH3Kh2g66oEQ5FaShrhtrmDXYPTe0cfkjz9J2PJJvoU?=
 =?us-ascii?Q?iVayJn+lgbZfafR9RUbqf8ZS9rbGN/lYlGZ1f54Xq+tZsJGMLg2qixdvCqp3?=
 =?us-ascii?Q?taGHqEJ4vQGxXXH9LP7g32M/6BYifMeFKBzZ9RVNFaQ91FOi4BKDhwG+Wh3k?=
 =?us-ascii?Q?mamZcj88HlEc+SbMx/JhCAYzVCm0uu3iHBn5eMYorMt3JmAkfWBptQC3G7kk?=
 =?us-ascii?Q?M4b+QBM6xxVjzNq1zOOLr74vVRwvgGLqUBL4PYRf1dozLPbVgAKwIQC3j5Bl?=
 =?us-ascii?Q?5rL3kQigj79Q1+R/WCDEAK6+TTu1CVFX0aWaZgsxTeBZYUE4w28R4qdZrnbO?=
 =?us-ascii?Q?hCrXs9etuvLc251yletkWh0Zs39PxFd0zGJ0QoAibUo2Y1YmPUP/8A4itPw7?=
 =?us-ascii?Q?rs8dk8WV0hkGRA5zbYGn8p0x0BNijv+SPV8m9QmzxBqN8Qq/B1PO01CTYi4f?=
 =?us-ascii?Q?/t70d0jP0Ij7VYNuRZBay8rTvRrJNVUJIGthN0kB8JaCXrWqKhdpKKbUtRiX?=
 =?us-ascii?Q?FYagDAXxQvlST7/XKV3W2ZNPIrbVu5j5pZRGYOqiQRwH53Tjr+plYYWpr9Da?=
 =?us-ascii?Q?PXxwyifEmuETee3WuvukSALRDBw65+LTl2pihuIO/u6VW0Qvd+uYeNoKk3wo?=
 =?us-ascii?Q?wdq6CnsP0FouNrYuqezIuc1pJCLVEBFha1xIVc42PzhEW+6OlVFdefXhIVtC?=
 =?us-ascii?Q?h5bvpV8qMMtmSdUDiJ99UMZWqVoTP/dV6lh2iBi3NZZcPkAfegnN+jHvyG4h?=
 =?us-ascii?Q?K0UtSphL5+mt1M2BcT+KzlBpbdMdyn2z68+RyUet+8URjeptzad9nsI92y3v?=
 =?us-ascii?Q?49JeuS4YG4XW2KaxN4XwKjG19+bPX+dfi4pyd0PN0klGCNPoc7jIl81Y0JzP?=
 =?us-ascii?Q?qIGA1y5yfTe41Kx/+B256d9ccSpC3no5BR1aXPtmu97f+gCL6W06vgGVNBz3?=
 =?us-ascii?Q?5foX7sHWPgP/Iv9jK2ig9ZL/xX7r4uaRsw2V8Lrn0UZN79cpPxHFvsYPgTrm?=
 =?us-ascii?Q?AQNplUY3FLZ/oiBs8kmJUWJScJrUDwRBq3cAjQsR5PtFDRhqqZln7PA1IOrX?=
 =?us-ascii?Q?t3so70Poh9ib1J59wovF6P79cVeFoGfVs8MoxGaJ/yaQc2ofc+f1IhJQKHp2?=
 =?us-ascii?Q?iA8VAQ9SPd+w6gKO38WhJxzUI/FqzGA7V3i2?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2025 09:47:26.2275
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 520f0bea-e645-4b3d-bfed-08ddd8bc1451
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000013D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8106

With Secure AVIC only Self-IPI is accelerated. To handle all the
other IPIs, add new callbacks for sending IPI. These callbacks write
to the IRR of the target guest vCPU's APIC backing page and issue
GHCB protocol MSR write event for the hypervisor to notify the
target vCPU about the new interrupt request.

For Secure AVIC GHCB APIC MSR writes, reuse GHCB msr handling code in
vc_handle_msr() by exposing a sev-internal sev_es_ghcb_handle_msr().

Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Reviewed-by: Tianyu Lan <tiala@microsoft.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v8:
 - Added Tianyu's Reviewed-by.
 - Use struct secure_avic_page.
 
 arch/x86/coco/sev/core.c            |  28 ++++++
 arch/x86/coco/sev/vc-handle.c       |  11 ++-
 arch/x86/include/asm/sev-internal.h |   2 +
 arch/x86/include/asm/sev.h          |   2 +
 arch/x86/kernel/apic/x2apic_savic.c | 138 +++++++++++++++++++++++++++-
 5 files changed, 173 insertions(+), 8 deletions(-)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 0c59ea82fa99..221a0fc0c387 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1085,6 +1085,34 @@ int __init sev_es_efi_map_ghcbs_cas(pgd_t *pgd)
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
index faf1fce89ed4..fc770cc9117d 100644
--- a/arch/x86/coco/sev/vc-handle.c
+++ b/arch/x86/coco/sev/vc-handle.c
@@ -401,14 +401,10 @@ static enum es_result __vc_handle_secure_tsc_msrs(struct pt_regs *regs, bool wri
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
@@ -438,6 +434,11 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
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
index 8e5083b46607..e849e616dd24 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -534,6 +534,7 @@ int snp_svsm_vtpm_send_command(u8 *buffer);
 void __init snp_secure_tsc_prepare(void);
 void __init snp_secure_tsc_init(void);
 enum es_result savic_register_gpa(u64 gpa);
+void savic_ghcb_msr_write(u32 reg, u64 value);
 
 static __always_inline void vc_ghcb_invalidate(struct ghcb *ghcb)
 {
@@ -607,6 +608,7 @@ static inline int snp_svsm_vtpm_send_command(u8 *buffer) { return -ENODEV; }
 static inline void __init snp_secure_tsc_prepare(void) { }
 static inline void __init snp_secure_tsc_init(void) { }
 static inline enum es_result savic_register_gpa(u64 gpa) { return ES_UNSUPPORTED; }
+static inline void savic_ghcb_msr_write(u32 reg, u64 value) { }
 
 #endif	/* CONFIG_AMD_MEM_ENCRYPT */
 
diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index cfe72473f843..dbd488191a16 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/cc_platform.h>
+#include <linux/cpumask.h>
 #include <linux/percpu-defs.h>
 #include <linux/align.h>
 
@@ -111,6 +112,73 @@ static u32 savic_read(u32 reg)
 
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
+	apic_set_reg64(this_cpu_ptr(secure_avic_page), APIC_ICR, icr_data);
+}
+
 static void savic_write(u32 reg, u32 data)
 {
 	void *ap = this_cpu_ptr(secure_avic_page);
@@ -121,7 +189,6 @@ static void savic_write(u32 reg, u32 data)
 	case APIC_LVT1:
 	case APIC_TMICT:
 	case APIC_TDCR:
-	case APIC_SELF_IPI:
 	case APIC_TASKPRI:
 	case APIC_EOI:
 	case APIC_SPIV:
@@ -137,7 +204,10 @@ static void savic_write(u32 reg, u32 data)
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
@@ -151,6 +221,61 @@ static void savic_write(u32 reg, u32 data)
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
@@ -222,13 +347,20 @@ static struct apic apic_x2apic_savic __ro_after_init = {
 
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


