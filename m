Return-Path: <kvm+bounces-39248-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BA27EA45979
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 10:08:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4BB9718976F1
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 09:08:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD2A222424B;
	Wed, 26 Feb 2025 09:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="se7ZZTWA"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2066.outbound.protection.outlook.com [40.107.93.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22746226CF8;
	Wed, 26 Feb 2025 09:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740560856; cv=fail; b=clNsWELuPXqlABnGNGP+T4MByxtt5SqJPqiLMDxrpzXS+yiF7MMiBpZZlNSuTFp86eky0faKZYBvrWmAx0hA4CBBpKwUWybtmZbGSdaViP67K0TFM9cgyn1+FAzC5MyWBAIyg2LwCu9J6qGadNpomnlsofq/PFJ9H314ZlRgGqA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740560856; c=relaxed/simple;
	bh=/Fs3O8wx28JzAtrV5lV9zhwh96GFYBatJyS1oEo3p/w=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mlN7KcSp4WRgFHMpJvELHHt37UIz+z6P06yXLoUeqBEm8TkOfRnbIOer/yT+Ja2cFFR3f0RyxRnJtzbTd8BUs0fqJ0iD7IWE1ureEB46V1HkvaHocRRK22l6DuLnlSBJrvOE1WLsjWWKvSMy1lVzyc0W+vX/5Zmqu7vZ8ozgVBg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=se7ZZTWA; arc=fail smtp.client-ip=40.107.93.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dKqh5J4P6657hy5V4qT0yB7l/ryYa+B91bssdgNohRgoH/e67tzZkGWaDUyZnl2BJpMgJfdK5NgznqDpwE1Xr3nkrqOFI8e8U6Xh79Ivu1cIZBeeFZ9/Z28Hdir7gW3qD60SfB/9m5w4ZBylqzDezQDwGdtxZitoDbNQd0uXBaZBV/AtwvS2pYco6xZ/8M4JvTEugcOYaUqPWORt5ID572zmY1KdY8Z0jxzo97KK7xI6Rg5terAAQiXyebTJuqNluNAebKFHt3tmWm8302UDm6ST52KHNgd4ZKM20q4fwH6PMAOwKEDL/KYPeJ64FwW+ecPuA7iydtkhQ39qAersyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vLHSDF6erOuUFpIkZ7qvHLje0eJX7WWL8XlUb0/rCDY=;
 b=m8oHtmc9tC2+2WMhDbd2mKV3gC507tMLWKMNocbUn/rfl9gPBB6s/LLnm//hF6iMSLvcRHZSZbVi+9ofBwmWqpFbH2jeFmfxQ7pWpznpq9hble2zAYZZY/BM5UVJTutEjduerDB+9JNqenSKw1gtPLhoiKfkNPn62WYSNMhi0N322PGRqJabwUl/0oLgjNojWksXXUeGhmJGjmPYBnDPIglszwD3G9fpqNQF1RknVlrWEJoKfT6yscTW3KNKRFrgN2UbHwA+70AhAmRmPgivtEeAwx+lgLgREoNGqY59ywPG/sxv+RqHIyuRVPwXz1G1FmgqDyWx34yw7ZwKIi198w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vLHSDF6erOuUFpIkZ7qvHLje0eJX7WWL8XlUb0/rCDY=;
 b=se7ZZTWA8rAa2rqWA+ZsFnKigUsBpr7iPVvOxKdrmpNcSAItqisnOsVCfsnyASrmIV7Gf5KElTmWey03F3rte3v2hG+1iM9tJknwmziS2/dnnwtsKOCqknEQ3zir+Cr8lPNAb7FazQhbNxnq2sQkIyrey4k9BHuyxtipTFef13Q=
Received: from BYAPR05CA0044.namprd05.prod.outlook.com (2603:10b6:a03:74::21)
 by IA0PR12MB8930.namprd12.prod.outlook.com (2603:10b6:208:481::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.19; Wed, 26 Feb
 2025 09:07:32 +0000
Received: from SJ1PEPF0000231D.namprd03.prod.outlook.com
 (2603:10b6:a03:74:cafe::8) by BYAPR05CA0044.outlook.office365.com
 (2603:10b6:a03:74::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8489.16 via Frontend Transport; Wed,
 26 Feb 2025 09:07:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF0000231D.mail.protection.outlook.com (10.167.242.234) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8489.16 via Frontend Transport; Wed, 26 Feb 2025 09:07:31 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 26 Feb
 2025 03:07:25 -0600
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>, <naveen.rao@amd.com>
Subject: [RFC v2 06/17] x86/apic: Add support to send IPI for Secure AVIC
Date: Wed, 26 Feb 2025 14:35:14 +0530
Message-ID: <20250226090525.231882-7-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250226090525.231882-1-Neeraj.Upadhyay@amd.com>
References: <20250226090525.231882-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF0000231D:EE_|IA0PR12MB8930:EE_
X-MS-Office365-Filtering-Correlation-Id: 59680397-ae78-4bb4-1e26-08dd564500ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cQJjGOqHRoxp3xyRhJdFg60dHS5Xg9QHEfM2SL74xMbPXTByEvsvYYvFFmZj?=
 =?us-ascii?Q?2oMfRbeDSVzfeY98D+ca70zFWzP3kljmAXEirTMksCAJp13hrnRmsj5zxBiU?=
 =?us-ascii?Q?NYYZNYo6/7K8maui0uiqDMTGCtOFi+2Y3ScXdhCsI+QnjOpB/EJw+EWhdiql?=
 =?us-ascii?Q?7rkBJoBP9tHD83N2wHoWCdEU0oAuAHdl1MUkMflqfjCIuMOjLFh28Efx0DXw?=
 =?us-ascii?Q?22/2ZemK2hiUaU7chCCitQajZq0knD0LoFb0NqVthqC7s/UwLMuK3xwGL0Qh?=
 =?us-ascii?Q?vAXpN6/5LWGR2pVkXXg2vW9q7kUDYgbCClkLovvYs9bcfmXLrecsZ12JHiot?=
 =?us-ascii?Q?uJNCMOIKh7P55mYoCFUDmxAX4pYT/FRwAGmvRgErA8iehbN/B3uttw2zzpRs?=
 =?us-ascii?Q?NJlKIx5R3JF2x54wa4H27kvkpv83Yz68KO2dXM6Dkd+60AoUqVdR3Zkk3Nma?=
 =?us-ascii?Q?fdJI1RKM7FGFBA58tNtCat79LJy7VuYy99o0uY3axP1PRHNsqKIqeDba4uMQ?=
 =?us-ascii?Q?UFBI0KhsvSDcYIc+i8n9y4ST6dY2gKhTSR0Tqg4soneaWETKAOI+2Kwygvry?=
 =?us-ascii?Q?mYxXT4QyD/PbsWbI4IDIMkmUNpFvNSV1NK39gXRVxK2LB0QAM4FM+ATEyjMw?=
 =?us-ascii?Q?wt9awvoalpxHHg495SJwCGWrVWKioVt3mNErprpYOv7/TfttJjDzg6Z6AYi+?=
 =?us-ascii?Q?d3AgdTKhgJWZvdwDgrQdt12sq8CQ+K0WhMVrw9xETJyvWFGRORWM1Em9tnvM?=
 =?us-ascii?Q?LqW/RdNErjf6aBU3IOPeIkEPFmTA8Sk5HAgDzqwrlG3s+xibc9sD2EDTftND?=
 =?us-ascii?Q?EyduugufrWuA4ExBty8onDNsBXhaspGduCFRiKacAeHpwXQp9gXsTT8vQQQK?=
 =?us-ascii?Q?xDiTiK9oS2DGIkg7SxxEjEJeyars4mjA/B52r1vwX7YObyK/U0DwfTTyrlRc?=
 =?us-ascii?Q?rQe8g1n7X6BHJ4MAF/smJxnZKJQUL2SwnOiUYc+Yh8x8sc9i8Zvss0EwDVwJ?=
 =?us-ascii?Q?BMjIRbWyh7FUwgTKDe0Ywqy5QypOOtZJ7fxuY2trMekKQlpSxf9aLAqzAhUp?=
 =?us-ascii?Q?ylFQ+9ya9/vLEq44VNsF5aNCNfH3DXHFa0Zy05aUDBRBFOl2C8WwsIbsemcy?=
 =?us-ascii?Q?fOr8wqkutn9cLZwPPgqpb3c3EoZfu9tkLE1YQtBFmE1fGVvzmwOtOCnYiczR?=
 =?us-ascii?Q?/Kj/F0c6sttHqK8BEGBAMdoQLYPGnjROA1jr9EMf0gxgQATDetLppmntoELo?=
 =?us-ascii?Q?Pi3i8bInqoFYP3LZfIHqo3DIuFnQsk69x6K6w1yrFv+0O6mdl3a+5PY6LQro?=
 =?us-ascii?Q?JnNQJbEOfzpdp1Q/CyZbc4nK2rH7ZGM8dRzPfBBPJwpwQFVbJ1yubkFoprn3?=
 =?us-ascii?Q?mcm2auWNRsiEktLPVqluSuoDMIPl6Kq+a2reGG/Z4WG/IgUXJ9TkQJWAvk2/?=
 =?us-ascii?Q?GFG0I8N9BhZLK23Bvrb+55TpPfgSkQwIMVaWK7lkWeXuKNKKBxZ0aD18mlpQ?=
 =?us-ascii?Q?13XH4DkxbjaSzKQ=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2025 09:07:31.8771
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 59680397-ae78-4bb4-1e26-08dd564500ac
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF0000231D.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8930

With Secure AVIC only Self-IPI is accelerated. To handle all the
other IPIs, add new callbacks for sending IPI, which write to the
IRR of the target guest vCPU's APIC backing page and then issue
GHCB protocol MSR write event for the hypervisor to notify the
target vCPU.

Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Co-developed-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v1:
 - Remove write_msr_to_hv() and define savic_ghcb_msr_write() in
   sev/core.c.

 arch/x86/coco/sev/core.c            |  40 +++++++-
 arch/x86/include/asm/sev.h          |   2 +
 arch/x86/kernel/apic/x2apic_savic.c | 138 +++++++++++++++++++++++++---
 3 files changed, 162 insertions(+), 18 deletions(-)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 300bc8f6eb6f..4291cdeb5895 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1466,14 +1466,10 @@ static enum es_result __vc_handle_secure_tsc_msrs(struct pt_regs *regs, bool wri
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
@@ -1504,6 +1500,40 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
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
 /*
  * Register GPA of the Secure AVIC backing page.
  *
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 626588386cf2..1beeb0daf9e6 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -484,6 +484,7 @@ int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_req *req
 void __init snp_secure_tsc_prepare(void);
 void __init snp_secure_tsc_init(void);
 enum es_result savic_register_gpa(u64 apic_id, u64 gpa);
+void savic_ghcb_msr_write(u32 reg, u64 value);
 
 #else	/* !CONFIG_AMD_MEM_ENCRYPT */
 
@@ -529,6 +530,7 @@ static inline void __init snp_secure_tsc_prepare(void) { }
 static inline void __init snp_secure_tsc_init(void) { }
 static inline enum es_result savic_register_gpa(u64 apic_id,
 						u64 gpa) { return ES_UNSUPPORTED; }
+static void savic_ghcb_msr_write(u32 reg, u64 value) { }
 
 #endif	/* CONFIG_AMD_MEM_ENCRYPT */
 
diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index d912c53dec7a..7e3843154997 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -119,6 +119,7 @@ static u32 x2apic_savic_read(u32 reg)
 static void x2apic_savic_write(u32 reg, u32 data)
 {
 	void *backing_page = this_cpu_read(apic_backing_page);
+	unsigned int cfg;
 
 	switch (reg) {
 	case APIC_LVTT:
@@ -126,7 +127,6 @@ static void x2apic_savic_write(u32 reg, u32 data)
 	case APIC_LVT1:
 	case APIC_TMICT:
 	case APIC_TDCR:
-	case APIC_SELF_IPI:
 	case APIC_TASKPRI:
 	case APIC_EOI:
 	case APIC_SPIV:
@@ -142,6 +142,11 @@ static void x2apic_savic_write(u32 reg, u32 data)
 	case APIC_EILVTn(0) ... APIC_EILVTn(3):
 		set_reg(backing_page, reg, data);
 		break;
+	/* Self IPIs are accelerated by hardware, use wrmsr */
+	case APIC_SELF_IPI:
+		cfg = __prepare_ICR(APIC_DEST_SELF, data, 0);
+		native_x2apic_icr_write(cfg, 0);
+		break;
 	/* ALLOWED_IRR offsets are writable */
 	case SAVIC_ALLOWED_IRR_OFFSET ... SAVIC_ALLOWED_IRR_OFFSET + 0x70:
 		if (IS_ALIGNED(reg - SAVIC_ALLOWED_IRR_OFFSET, 16)) {
@@ -154,13 +159,100 @@ static void x2apic_savic_write(u32 reg, u32 data)
 	}
 }
 
+static void send_ipi(int cpu, int vector)
+{
+	void *backing_page;
+	int reg_off;
+
+	backing_page = per_cpu(apic_backing_page, cpu);
+	reg_off = APIC_IRR + REG_POS(vector);
+	/*
+	 * Use test_and_set_bit() to ensure that IRR updates are atomic w.r.t. other
+	 * IRR updates such as during VMRUN and during CPU interrupt handling flow.
+	 */
+	test_and_set_bit(VEC_POS(vector), (unsigned long *)((char *)backing_page + reg_off));
+}
+
+static void send_ipi_dest(u64 icr_data)
+{
+	int vector, cpu;
+
+	vector = icr_data & APIC_VECTOR_MASK;
+	cpu = icr_data >> 32;
+
+	send_ipi(cpu, vector);
+}
+
+static void send_ipi_target(u64 icr_data)
+{
+	if (icr_data & APIC_DEST_LOGICAL) {
+		pr_err("IPI target should be of PHYSICAL type\n");
+		return;
+	}
+
+	send_ipi_dest(icr_data);
+}
+
+static void send_ipi_allbut(u64 icr_data)
+{
+	const struct cpumask *self_cpu_mask = get_cpu_mask(smp_processor_id());
+	unsigned long flags;
+	int vector, cpu;
+
+	vector = icr_data & APIC_VECTOR_MASK;
+	local_irq_save(flags);
+	for_each_cpu_andnot(cpu, cpu_present_mask, self_cpu_mask)
+		send_ipi(cpu, vector);
+	savic_ghcb_msr_write(APIC_ICR, icr_data);
+	local_irq_restore(flags);
+}
+
+static void send_ipi_allinc(u64 icr_data)
+{
+	int vector;
+
+	send_ipi_allbut(icr_data);
+	vector = icr_data & APIC_VECTOR_MASK;
+	native_x2apic_icr_write(APIC_DEST_SELF | vector, 0);
+}
+
+static void x2apic_savic_icr_write(u32 icr_low, u32 icr_high)
+{
+	int dsh, vector;
+	u64 icr_data;
+
+	icr_data = ((u64)icr_high) << 32 | icr_low;
+	dsh = icr_low & APIC_DEST_ALLBUT;
+
+	switch (dsh) {
+	case APIC_DEST_SELF:
+		vector = icr_data & APIC_VECTOR_MASK;
+		x2apic_savic_write(APIC_SELF_IPI, vector);
+		break;
+	case APIC_DEST_ALLINC:
+		send_ipi_allinc(icr_data);
+		break;
+	case APIC_DEST_ALLBUT:
+		send_ipi_allbut(icr_data);
+		break;
+	default:
+		send_ipi_target(icr_data);
+		savic_ghcb_msr_write(APIC_ICR, icr_data);
+	}
+}
+
+static void __send_IPI_dest(unsigned int apicid, int vector, unsigned int dest)
+{
+	unsigned int cfg = __prepare_ICR(0, vector, dest);
+
+	x2apic_savic_icr_write(cfg, apicid);
+}
+
 static void x2apic_savic_send_IPI(int cpu, int vector)
 {
 	u32 dest = per_cpu(x86_cpu_to_apicid, cpu);
 
-	/* x2apic MSRs are special and need a special fence: */
-	weak_wrmsr_fence();
-	__x2apic_send_IPI_dest(dest, vector, APIC_DEST_PHYSICAL);
+	__send_IPI_dest(dest, vector, APIC_DEST_PHYSICAL);
 }
 
 static void
@@ -170,18 +262,16 @@ __send_IPI_mask(const struct cpumask *mask, int vector, int apic_dest)
 	unsigned long this_cpu;
 	unsigned long flags;
 
-	/* x2apic MSRs are special and need a special fence: */
-	weak_wrmsr_fence();
-
 	local_irq_save(flags);
 
 	this_cpu = smp_processor_id();
 	for_each_cpu(query_cpu, mask) {
 		if (apic_dest == APIC_DEST_ALLBUT && this_cpu == query_cpu)
 			continue;
-		__x2apic_send_IPI_dest(per_cpu(x86_cpu_to_apicid, query_cpu),
-				       vector, APIC_DEST_PHYSICAL);
+		__send_IPI_dest(per_cpu(x86_cpu_to_apicid, query_cpu), vector,
+				      APIC_DEST_PHYSICAL);
 	}
+
 	local_irq_restore(flags);
 }
 
@@ -195,6 +285,28 @@ static void x2apic_savic_send_IPI_mask_allbutself(const struct cpumask *mask, in
 	__send_IPI_mask(mask, vector, APIC_DEST_ALLBUT);
 }
 
+static void __send_IPI_shorthand(int vector, u32 which)
+{
+	unsigned int cfg = __prepare_ICR(which, vector, 0);
+
+	x2apic_savic_icr_write(cfg, 0);
+}
+
+static void x2apic_savic_send_IPI_allbutself(int vector)
+{
+	__send_IPI_shorthand(vector, APIC_DEST_ALLBUT);
+}
+
+static void x2apic_savic_send_IPI_all(int vector)
+{
+	__send_IPI_shorthand(vector, APIC_DEST_ALLINC);
+}
+
+static void x2apic_savic_send_IPI_self(int vector)
+{
+	__send_IPI_shorthand(vector, APIC_DEST_SELF);
+}
+
 static void x2apic_savic_update_vector(unsigned int cpu, unsigned int vector, bool set)
 {
 	void *backing_page;
@@ -325,16 +437,16 @@ static struct apic apic_x2apic_savic __ro_after_init = {
 	.send_IPI			= x2apic_savic_send_IPI,
 	.send_IPI_mask			= x2apic_savic_send_IPI_mask,
 	.send_IPI_mask_allbutself	= x2apic_savic_send_IPI_mask_allbutself,
-	.send_IPI_allbutself		= x2apic_send_IPI_allbutself,
-	.send_IPI_all			= x2apic_send_IPI_all,
-	.send_IPI_self			= x2apic_send_IPI_self,
+	.send_IPI_allbutself		= x2apic_savic_send_IPI_allbutself,
+	.send_IPI_all			= x2apic_savic_send_IPI_all,
+	.send_IPI_self			= x2apic_savic_send_IPI_self,
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


