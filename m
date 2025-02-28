Return-Path: <kvm+bounces-39667-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AE0F1A49426
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 09:57:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 97988189492C
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 08:57:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE188254863;
	Fri, 28 Feb 2025 08:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="c+N8vqfL"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2073.outbound.protection.outlook.com [40.107.92.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41921254878;
	Fri, 28 Feb 2025 08:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740733029; cv=fail; b=opsAo5bTl7v17QjpXZkmvLawlLccvmaMuvCLENz3oCrTd/3Y6tXULvx7XDkwl//+Tzzf1a+jb18wVoqUVZuLtPJtTZLcfoHTLpeHNgNzJ3EEiuKb+lAC36NW4QWbk+0luepA5pa49vsWKCjVdwyT4n7gqbui/C5WvpcsUwztaPg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740733029; c=relaxed/simple;
	bh=nSoFge23z38HMX+Rr8aSVIwjo/16W+Yl00nfwyc68uo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LmBOzpevJfx8GRDz1qhlzU34KLuBjHVcRr5Kxte7uY4O4GjjQxodvCLQ4b0wnC9XpiTXGjAXEuD4cYNMOs6+OOlCozDw1MvNAaUX2b30teBKW569J5oQjOLbfmz1g4tUKJNjc+QOggURbKNg9FFdm0tLzI4omxzGCV586+9j+sg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=c+N8vqfL; arc=fail smtp.client-ip=40.107.92.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g7EwiZLspJWhlh+ULmvKTClI9BO3+Sm5hSHgMy3HVMz3VapKNipqi5hz/BZaAgl+wFNpTjeIR6Pkk5tY79IiO5PJXnK0OW3MoIND5I6vpuws19pKhkJboxPiYLm+aXTAg/dxQ1f1rjp1TmX2gvujWZnjDOw3PgQ5Cj9wSRY2zaJWEcBcB9aZTeQz2N14Caz8786OnlW/Ylzi91YMcKTXRnftA5Y1jc0VwmVoRaLu+I1FQfdXftM1r9as3Gdm0K0aMN6qmIx1i2RV/fnSDBMWOY28N4sbdenJuIEVDn74q1W3QJHvVm3+quSV6BorPYaBe3pe1aP+QTXkReAoPUnadg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zQanG7MOkHGykUX2rWzAtO/excH7lXi2RltMNkHy5p0=;
 b=fQvdY9Sg25rx4Yb/E4M5YLTNy9S7zLaaR08oQ1z79kqNYUGhkgcnc7J6cmYmwu+En0W+bnrxFrPhZK9iPGNwpUY8loRrO/cxDSWcanv+fHcLFvVjAMdna3MaAvMGHJ/P+03zul+ZxW0bWFWlX6/i2T6iEoMnOURVyEweu7q8apHG2stzoGZJhniLyj5SLZ0CMaqal6AzewzR/Tf6WUC87RXUrRqVlqAjnulFZthsO8rvCTt4BrfMv8Xy0XDtZfV7Bx4PGow5a+fwbLAZrmcd5+madBL2WBf++W9zKzBqcTA3P+PTYLU3vuyC9EYYr3F6dla5rdPMliCdr7mQ2yuGdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zQanG7MOkHGykUX2rWzAtO/excH7lXi2RltMNkHy5p0=;
 b=c+N8vqfLPmxFCoG/CqOiVcMMW60YzTTOOGZcs+WJp9zH6RNSYanPHhI/WoVu+lWsL+GLJPct8MrjOUhnCsLVv2DxcaJKiNkCmNE97BZzWmGzFCXOKSgZCfaXVt9KFS57qZgy7aUscRwqeR8fKcjHTO19eqb6+Alrrzi/W9oeukk=
Received: from PH2PEPF00003850.namprd17.prod.outlook.com (2603:10b6:518:1::72)
 by IA1PR12MB7759.namprd12.prod.outlook.com (2603:10b6:208:420::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.23; Fri, 28 Feb
 2025 08:57:03 +0000
Received: from SJ1PEPF000023DA.namprd21.prod.outlook.com
 (2a01:111:f403:c902::13) by PH2PEPF00003850.outlook.office365.com
 (2603:1036:903:48::3) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8489.22 via Frontend Transport; Fri,
 28 Feb 2025 08:57:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF000023DA.mail.protection.outlook.com (10.167.244.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8511.0 via Frontend Transport; Fri, 28 Feb 2025 08:57:03 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 28 Feb
 2025 02:55:55 -0600
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <bp@alien8.de>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>,
	<nikunj@amd.com>, <Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <binbin.wu@linux.intel.com>, <isaku.yamahata@intel.com>
Subject: [RFC PATCH 02/19] KVM: x86: Assume timer IRQ was injected if APIC state is protected
Date: Fri, 28 Feb 2025 14:20:58 +0530
Message-ID: <20250228085115.105648-3-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250228085115.105648-1-Neeraj.Upadhyay@amd.com>
References: <20250228085115.105648-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023DA:EE_|IA1PR12MB7759:EE_
X-MS-Office365-Filtering-Correlation-Id: 5273ec31-9bcc-4841-1e22-08dd57d5dedf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ja+Nvyekr5ZtuHusljgQYKDxoJ/YFhml8dRASCEaN0BCK10+T/Ta35Yfh+z5?=
 =?us-ascii?Q?WrksI7FYe76k3972pgB/G/MEioP/Jcon2AiYnwjo+xus3locYSs+RMXDwyXM?=
 =?us-ascii?Q?Kc+4Phwap1LA5UlFE9LBsqTby5kYr7kt+ZzGxrZifi7sKx7/upUN+dH/j3rQ?=
 =?us-ascii?Q?9/trs+xfdA7g3wzZ3dSg2a3NpXuGuaKu4L9J1TKeAXnQFUA+E5Bgve+bdCgL?=
 =?us-ascii?Q?iaivkZfp4iTvV1x4fiJA13jDGXSt82J6xstmAzuq0M0Y3SlmR4+yvn0mp3AO?=
 =?us-ascii?Q?DyfkzOi2UBYIJcp5pRZhRr2uJopOH0pxRS7h9V18orDYXLovFG+taPWNaKZG?=
 =?us-ascii?Q?p9kBg68P7s8xKjPns/MUJipL3DEDdcqyIg6R3ekr1RRycnSP/lPYS1SNvg9N?=
 =?us-ascii?Q?4JdlTNq1sAIRZwiWWJhOkdV1lzUrPEbCzy5JnQOEptuPv0iG4RMYRK6fnxId?=
 =?us-ascii?Q?aA/3h2zXUdVIxJW9QqfxXR/23toNbspmP8M1iLI3gS1eFlWSoPI3TYqnL8Ft?=
 =?us-ascii?Q?XWH7RCIvwiLqalbohMhXO9cVbQgXLeKbMoAGCHgy0KM0Tkxl9k9GL3ohkuHH?=
 =?us-ascii?Q?Xg9F17Y42sbuqc11xxGt3/8qJPZjr6FPLoem57FoVHnkIGpB5CjI2vB0P/Qv?=
 =?us-ascii?Q?/RMwnNS7bDMSDYc6Kzgfp2DdZpwnNLnfsoD5aO2H6tCXmDmEOSKlUhWRE4RQ?=
 =?us-ascii?Q?9sxGPzUCRjvPI2du1dKDRXM+B0BeJW3kA7Pj4FLRJGXpVnMM0o6WwI5rhido?=
 =?us-ascii?Q?jNeXKxss2jVG7y21IUy5rNKzBPfL2u4USHtwkhzdlWB8QjcXt1Za+7DbG02w?=
 =?us-ascii?Q?mgZ3DPWAHP9pXTsGFVaYVAdYT4jH+Pfm6agPzP4e9Ait4in0ZEZFcrp8KiyM?=
 =?us-ascii?Q?flEJHdcvcQGeQjvb+j9zQdyfhKpcD/AM1p/ZTI9wa2n/oS6kq5k1RPGIZaVj?=
 =?us-ascii?Q?HOt+Jl7vOjHSe1TBpZHaPuu+zkMlSlhl9FvEeIvvizvFhgvQfYjKwZnYgdGa?=
 =?us-ascii?Q?Dp6J8bs7aznlVr2QhEr5dDWjlY8Pa6We20e/M/7sDpO92xsOdohakJK4lFei?=
 =?us-ascii?Q?8yD9qVD18GOQzALATYneChXkyKzzbh6fmW6hhhmhM33qimtMAZvhDPcs1g8f?=
 =?us-ascii?Q?5p32mPOrSFkPwobVOArRZ4EydmXB4HUlFe4x+JqItLMQ1J5dw8+hADP7kBAX?=
 =?us-ascii?Q?0ifdmHQoJnAkRlhhAvqBAFhgjoefbwec0RjzlxQmfNEJ/SASjArmThYSybtk?=
 =?us-ascii?Q?TARiVdFe2YvZXhgRJPPd6vPaxPAVy3+S1qu2facHDWebhyvyhUoUVEEmEtQ8?=
 =?us-ascii?Q?qDjqYQNrDxBBOTaP3wH0KqzAuptsJ8HUeGbVl+rc3OE63Mf2o3k+ZHVfiCMP?=
 =?us-ascii?Q?st7B6t/Mn6QGry8QCSyw4h0z953zDxoJi0dgQSTKDZUDduE6+mgy12kUeaRp?=
 =?us-ascii?Q?bH76TEhDWhQKXoC4gIxcd8tVHq1UOS2pygUCJ6Xa+pC/3RcCcKsby6rIJcrw?=
 =?us-ascii?Q?NTrdODuDoJH8ttg=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2025 08:57:03.3574
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5273ec31-9bcc-4841-1e22-08dd57d5dedf
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023DA.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7759

From: Sean Christopherson <seanjc@google.com>

If APIC state is protected, i.e. the vCPU is a TDX guest, assume a timer
IRQ was injected when deciding whether or not to busy wait in the "timer
advanced" path.  The "real" vIRR is not readable/writable, so trying to
query for a pending timer IRQ will return garbage.

Note, TDX can scour the PIR if it wants to be more precise and skip the
"wait" call entirely.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
- Not intended for review. Taken as a base patch for this RFC development.

 arch/x86/kvm/lapic.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 8eefbaf4a456..65f69537c105 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1797,8 +1797,17 @@ static void apic_update_lvtt(struct kvm_lapic *apic)
 static bool lapic_timer_int_injected(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
-	u32 reg = kvm_lapic_get_reg(apic, APIC_LVTT);
+	u32 reg;
 
+	/*
+	 * Assume a timer IRQ was "injected" if the APIC is protected.  KVM's
+	 * copy of the vIRR is bogus, it's the responsibility of the caller to
+	 * precisely check whether or not a timer IRQ is pending.
+	 */
+	if (apic->guest_apic_protected)
+		return true;
+
+	reg  = kvm_lapic_get_reg(apic, APIC_LVTT);
 	if (kvm_apic_hw_enabled(apic)) {
 		int vec = reg & APIC_VECTOR_MASK;
 		void *bitmap = apic->regs + APIC_ISR;
-- 
2.34.1


