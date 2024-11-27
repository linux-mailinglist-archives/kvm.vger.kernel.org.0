Return-Path: <kvm+bounces-32616-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C92E9DAF6C
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 23:58:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 04C0AB226C1
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 22:58:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 856D520408B;
	Wed, 27 Nov 2024 22:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="LmfFXDQ/"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2049.outbound.protection.outlook.com [40.107.220.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05719203719;
	Wed, 27 Nov 2024 22:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732748286; cv=fail; b=U/WmXCYmE+j8lwiDWRdphBt5S8VzXaVtHajXZLxPWJh1Z+R4M1d0NyQMJKPrq+eLRValJc4JUYLbwvT36Mnfzgd0qU402jMmSVryTDbkub0LVZH1jxKRNy+FvfSA3HnljbaRsr0yLo+YLsmNv/5A5nwR5Mzmilac8PRHkyaqovw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732748286; c=relaxed/simple;
	bh=WdFpuSTP1DKP83gnf5AbkV5PdOIFQXK1T/NUmEGh+9w=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=meccym7v6qPygdgC+U7+4s54CEg466hmlkDFhs2FGD490pB8+l5oBTVjHmdfyeQmbCicES/KmOxPltsObewF1hinBRBHLnbrI1LYv834GbplQ38bJDa4NIg93ZmuuSKUO9VrgWFnDwickssXDhCaKGbBxQUF8UTIIWPUWerQIes=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=LmfFXDQ/; arc=fail smtp.client-ip=40.107.220.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PrTBNFadKhzT43GwD3Lpvbve3ayh9m+BPprICy7bahsMs+cQV8/maED+MLzooGQup7yZ9ABVU87s0gwnqDSy9qDx4lf1f1yfrOGArBVKzZ0AQExVOyMVcF1ico50LoNH3AfNaHp4bMjLY52dyoHIZl4Zl9+BLKm30XzVV1fcs/lzY/hjznPrDZXTkr82n+KEsyVeJWoxqR0UWrfTYBiVogjlCpgwaYze93L9jjMaWDm7RvUx7AAfi9u/qwlAIfP5BAJfr1JEreSCCmphTO/UhZsZt6r8rM100yj15xsv9MGA3EPW+m7WCo6Tc2KMv96yWTaB/AoQjngh7wdLIGcAVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qvqg7PyITE+1JiitYiwoDkp34LN0+a0PWcsztV/wUdw=;
 b=dpDsGIg/JsMcj5tYwizczxGxYZ/fEKJObZW0mpiHIcd5o8jzKKoup0WbKXSS70CZcb5YzuVmZdljiauSWuiJf0y4VsejU1TbWIXYIP630pKEod/8E3QH3+rIHgLZs0gsK5mzFNF27rh5TaruPhclZqbcgNo1hsQIRevxLUKLAZ1xPp2QURDWx/WToW10vHuBSwfLTz+EI2k01rgoT0DqqyFk0kmbHuYW4k7ZfvzUJfmnI1QntvOQjg8QRhlo2kJOyb0uiRg2nRJJ+3qLIvLPfzgySFhWrHw3Dtbkficea3+7z2USAWkS6xPNwYxZZ/UFHdt+vuf8zqL1krO0lH9Cow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qvqg7PyITE+1JiitYiwoDkp34LN0+a0PWcsztV/wUdw=;
 b=LmfFXDQ/1bVZ9tsyAxqwvTzQDkAaO4G1WetrS1ESIk5T8SfduOtm7Je1iKO4NwJCEDRpwOrugNUuyvIVVcjhSzbBRIjcbGNiHto/7Nrt74c/w4ytXcUrfwol3bkxthouUnLRUkLPU91ZOBV0HKl2XBR0EK6Vl/Yqcd0fMj6Y0Fw=
Received: from BN9PR03CA0630.namprd03.prod.outlook.com (2603:10b6:408:106::35)
 by PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.13; Wed, 27 Nov
 2024 22:58:01 +0000
Received: from BN2PEPF000055E1.namprd21.prod.outlook.com
 (2603:10b6:408:106:cafe::4f) by BN9PR03CA0630.outlook.office365.com
 (2603:10b6:408:106::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8207.12 via Frontend Transport; Wed,
 27 Nov 2024 22:58:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF000055E1.mail.protection.outlook.com (10.167.245.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8230.0 via Frontend Transport; Wed, 27 Nov 2024 22:58:00 +0000
Received: from ruby-9130host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 27 Nov
 2024 16:57:59 -0600
From: Melody Wang <huibo.wang@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Tom Lendacky <thomas.lendacky@amd.com>, "Neeraj
 Upadhyay" <neeraj.upadhyay@amd.com>, Ashish Kalra <ashish.kalra@amd.com>,
	Michael Roth <michael.roth@amd.com>, Pankaj Gupta <pankaj.gupta@amd.com>,
	Melody Wang <huibo.wang@amd.com>
Subject: [PATCH v3 5/7] KVM: SVM: Inject MCEs when restricted injection is active
Date: Wed, 27 Nov 2024 22:55:37 +0000
Message-ID: <20241127225539.5567-6-huibo.wang@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241127225539.5567-1-huibo.wang@amd.com>
References: <20241127225539.5567-1-huibo.wang@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000055E1:EE_|PH0PR12MB7982:EE_
X-MS-Office365-Filtering-Correlation-Id: 52576278-38ba-4949-93f1-08dd0f36f13b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4lGnbFZgBkr90XOQ1XK98l/zlfH+TYuTORHU8mu6kmlo15le4PEgftfVb8MH?=
 =?us-ascii?Q?edKgP9UzvDnKlS4VpW3Ib++9dLg6sIa1zsxngTNUTXlnyDvPGc/MUuT64m85?=
 =?us-ascii?Q?r00tGa+C+wqFJUn1QA+yM/1mSiZBqdBUTTDN82GeJ8TJfg1qR5CURLDNUp2R?=
 =?us-ascii?Q?bWxJMV7ToG5XzCdaW2HeZ3CNyG8UzTnt7V764RfsujP6upjjBhq3FIjMzbRG?=
 =?us-ascii?Q?mC7kidNOuMN+tNoQDUJE6W6Sr1kSpxlhn2/SnYP/zi+SwD3bDbfYt4rFxQma?=
 =?us-ascii?Q?ZZ+yLn/1bAirSZmSNj+zzz6xjhQpgEby9N+x6h0kkqfxMy11NniCu8XYQIAY?=
 =?us-ascii?Q?11x3aY4UM3RQeNXDf8lglndwPyj/JjU/di7hKPIFJtrUgTKLlHp9kNUuQb2U?=
 =?us-ascii?Q?vMzXVOcA+vndqAxU4b6/LG+eBZGZtcFQyzG3TkeXXTCC3kUMKNVPmYVoyYPo?=
 =?us-ascii?Q?+0zv8EZbBJpr/GAAkkilgTV4SoMpfhSPTwrH7NiSqvrNrEVRpVhb0E3AVyNm?=
 =?us-ascii?Q?MFd7DaOTwBlGQOhM7pfE2IOWleyQ665fLcUdhOX9S/K4nakT4cgiZBBc1S7V?=
 =?us-ascii?Q?DbWYLznW0bw3rlxvPQAQsVJ1jhBIyoSft4tac8RfPKG3uX1mStMWe22km7wh?=
 =?us-ascii?Q?4DqEs/UDYijRcSpcCrLIq58TEgzCoW0bGj1aXXqidcdCsLDpHKrk6YrtENq8?=
 =?us-ascii?Q?Z7aIf8DFOscTJgbYUjOaAPFH3junX1d/tkwE6w4ETnz75wtDutI4gDDImA/w?=
 =?us-ascii?Q?lV5f1cCH5QlgOZrK6lJWQP+GQlvg7d3deWDth3npi3C9mMXEtkjT0m/djzNp?=
 =?us-ascii?Q?DFEwUO0MeK21vMgwdrUUI+V7ixDZ4oB1aZCm1yRhSz/zQsO302pRWxiDj482?=
 =?us-ascii?Q?RRHjRYGtqL9MZU6M5kYGyJSoeJz+StqUCB4bIEshKBZud+ZjRlnjqnLlH+4s?=
 =?us-ascii?Q?C9HYhsF5v86myXhwdcee4PVsgFMQpv0UlHvw6fqpsBtYahFo4cXROq6Ytg/n?=
 =?us-ascii?Q?Min3AwDy+6EWdlorcpORApZR4y9Lnx63waLQGhHrgijIUvgQBEw/OW0M78g1?=
 =?us-ascii?Q?s69CFZaagP+lZIlv4cn7SWmF0WHUwbKKAibrFMfhfKTtQtrw640sinGO4SmM?=
 =?us-ascii?Q?D8z2b26LtlX0aRwLuh3c/F5LLBal0iKm81Xnv8JdGWe51Eu+szB/YcsaWMzQ?=
 =?us-ascii?Q?0PZNNdt29zLzjS8C3WvjLKoXzjzXUVNSW/g7CQfEdphiUxJv0d/I7awM3DB8?=
 =?us-ascii?Q?14uYZdJoDQYX7QjlG3R7LO4GeUx5M4HGjzLi74Sz7Bww6Crd1Y5l0Tab5jf6?=
 =?us-ascii?Q?xPbtRVmrlyiAeOTgDMnBqWT4uaXGMbJTHkSpWmvVmIAb1Qp5wujjXaonHikf?=
 =?us-ascii?Q?5tBxesFhtnegH0+stq3BKiBwSS5k4/k/J8YzYjI/242JS36o6QvEabp8tLu0?=
 =?us-ascii?Q?VShQkQKA/wXmW6V8q4T4c9xUI3veeWqf?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2024 22:58:00.5561
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 52576278-38ba-4949-93f1-08dd0f36f13b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055E1.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7982

When restricted injection is active, only #HV exceptions can be injected into
the SEV-SNP guest.

Detect that restricted injection feature is active for the guest, and then
follow the #HV doorbell communication from the GHCB specification to inject the
MCEs.

Co-developed-by: Thomas Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Thomas Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Melody Wang <huibo.wang@amd.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/kvm/svm/sev.c             | 16 ++++++++++++++--
 arch/x86/kvm/svm/svm.c             | 17 +++++++++++++++++
 arch/x86/kvm/svm/svm.h             |  2 ++
 arch/x86/kvm/vmx/main.c            |  1 +
 arch/x86/kvm/vmx/vmx.c             |  5 +++++
 arch/x86/kvm/vmx/x86_ops.h         |  1 +
 arch/x86/kvm/x86.c                 |  7 +++++++
 9 files changed, 49 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 5aff7222e40f..07fb1e2f59cb 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -77,6 +77,7 @@ KVM_X86_OP(inject_exception)
 KVM_X86_OP(cancel_injection)
 KVM_X86_OP(interrupt_allowed)
 KVM_X86_OP(nmi_allowed)
+KVM_X86_OP_OPTIONAL(mce_allowed)
 KVM_X86_OP(get_nmi_mask)
 KVM_X86_OP(set_nmi_mask)
 KVM_X86_OP(enable_nmi_window)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e159e44a6a1b..288b826e384c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1717,6 +1717,7 @@ struct kvm_x86_ops {
 	void (*cancel_injection)(struct kvm_vcpu *vcpu);
 	int (*interrupt_allowed)(struct kvm_vcpu *vcpu, bool for_injection);
 	int (*nmi_allowed)(struct kvm_vcpu *vcpu, bool for_injection);
+	int (*mce_allowed)(struct kvm_vcpu *vcpu);
 	bool (*get_nmi_mask)(struct kvm_vcpu *vcpu);
 	void (*set_nmi_mask)(struct kvm_vcpu *vcpu, bool masked);
 	/* Whether or not a virtual NMI is pending in hardware. */
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 00d1f620d14a..19fcb0ddcff0 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -5079,6 +5079,8 @@ static void __sev_snp_inject(enum inject_type type, struct kvm_vcpu *vcpu)
 
 	if (type == INJECT_NMI)
 		hvdb->events.nmi = 1;
+	else if (type == INJECT_MCE)
+		hvdb->events.mce = 1;
 	else
 		hvdb->events.vector = vcpu->arch.interrupt.nr;
 
@@ -5094,6 +5096,11 @@ bool sev_snp_queue_exception(struct kvm_vcpu *vcpu)
 	if (!sev_snp_is_rinj_active(vcpu))
 		return false;
 
+	if (vcpu->arch.exception.vector == MC_VECTOR) {
+		__sev_snp_inject(INJECT_MCE, vcpu);
+		return true;
+	}
+
 	/*
 	 * Restricted injection is enabled, only #HV is supported.
 	 * If the vector is not HV_VECTOR, do not inject the exception,
@@ -5162,7 +5169,7 @@ void sev_snp_cancel_injection(struct kvm_vcpu *vcpu)
 
 	/*
 	 * KVM only injects a single event each time (prepare_hv_injection),
-	 * so when events.nmi is true, the vector will be zero
+	 * so when events.nmi is true, the mce and vector will be zero
 	 */
 	if (hvdb->events.vector)
 		svm->vmcb->control.event_inj |= hvdb->events.vector |
@@ -5171,6 +5178,9 @@ void sev_snp_cancel_injection(struct kvm_vcpu *vcpu)
 	if (hvdb->events.nmi)
 		svm->vmcb->control.event_inj |= SVM_EVTINJ_TYPE_NMI;
 
+	if (hvdb->events.mce)
+		svm->vmcb->control.event_inj |= MC_VECTOR | SVM_EVTINJ_TYPE_EXEPT;
+
 	hvdb->events.pending_events = 0;
 
 out:
@@ -5196,9 +5206,11 @@ bool sev_snp_blocked(enum inject_type type, struct kvm_vcpu *vcpu)
 	if (!hvdb)
 		return true;
 
-	/* Indicate NMIs and interrupts blocked based on guest acknowledgment */
+	/* Indicate NMIs, MCEs and interrupts blocked based on guest acknowledgment */
 	if (type == INJECT_NMI)
 		blocked = hvdb->events.nmi;
+	else if (type == INJECT_MCE)
+		blocked = hvdb->events.mce;
 	else
 		blocked = !!hvdb->events.vector;
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 91bf17684bc8..696653269c55 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3881,6 +3881,22 @@ static int svm_interrupt_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 	return 1;
 }
 
+bool svm_mce_blocked(struct kvm_vcpu *vcpu)
+{
+	if (sev_snp_is_rinj_active(vcpu))
+		return sev_snp_blocked(INJECT_MCE, vcpu);
+
+	return false;
+}
+
+static int svm_mce_allowed(struct kvm_vcpu *vcpu)
+{
+	if (svm_mce_blocked(vcpu))
+		return 0;
+
+	return 1;
+}
+
 static void svm_enable_irq_window(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -5091,6 +5107,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.cancel_injection = svm_cancel_injection,
 	.interrupt_allowed = svm_interrupt_allowed,
 	.nmi_allowed = svm_nmi_allowed,
+	.mce_allowed = svm_mce_allowed,
 	.get_nmi_mask = svm_get_nmi_mask,
 	.set_nmi_mask = svm_set_nmi_mask,
 	.enable_nmi_window = svm_enable_nmi_window,
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index b6e833f455ae..9c71bf01729b 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -58,6 +58,7 @@ extern int lbrv;
 enum inject_type {
 	INJECT_IRQ,
 	INJECT_NMI,
+	INJECT_MCE,
 };
 
 /*
@@ -616,6 +617,7 @@ void svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
 void disable_nmi_singlestep(struct vcpu_svm *svm);
 bool svm_smi_blocked(struct kvm_vcpu *vcpu);
 bool svm_nmi_blocked(struct kvm_vcpu *vcpu);
+bool svm_mce_blocked(struct kvm_vcpu *vcpu);
 bool svm_interrupt_blocked(struct kvm_vcpu *vcpu);
 void svm_set_gif(struct vcpu_svm *svm, bool value);
 int svm_invoke_exit_handler(struct kvm_vcpu *vcpu, u64 exit_code);
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 92d35cc6cd15..036f750c53c5 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -87,6 +87,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.cancel_injection = vmx_cancel_injection,
 	.interrupt_allowed = vmx_interrupt_allowed,
 	.nmi_allowed = vmx_nmi_allowed,
+	.mce_allowed = vmx_mce_allowed,
 	.get_nmi_mask = vmx_get_nmi_mask,
 	.set_nmi_mask = vmx_set_nmi_mask,
 	.enable_nmi_window = vmx_enable_nmi_window,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 893366e53732..afa6d126324c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5103,6 +5103,11 @@ int vmx_interrupt_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 	return !vmx_interrupt_blocked(vcpu);
 }
 
+int vmx_mce_allowed(struct kvm_vcpu *vcpu)
+{
+	return 1;
+}
+
 int vmx_set_tss_addr(struct kvm *kvm, unsigned int addr)
 {
 	void __user *ret;
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index a55981c5216e..8607ef20897d 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -93,6 +93,7 @@ void vmx_inject_exception(struct kvm_vcpu *vcpu);
 void vmx_cancel_injection(struct kvm_vcpu *vcpu);
 int vmx_interrupt_allowed(struct kvm_vcpu *vcpu, bool for_injection);
 int vmx_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection);
+int vmx_mce_allowed(struct kvm_vcpu *vcpu);
 bool vmx_get_nmi_mask(struct kvm_vcpu *vcpu);
 void vmx_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked);
 void vmx_enable_nmi_window(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2e713480933a..a76ce35c5b93 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10357,12 +10357,19 @@ static int kvm_check_and_inject_events(struct kvm_vcpu *vcpu,
 			}
 		}
 
+		if (vcpu->arch.exception.vector == MC_VECTOR) {
+			r = static_call(kvm_x86_mce_allowed)(vcpu);
+			if (!r)
+				goto out_except;
+		}
+
 		kvm_inject_exception(vcpu);
 
 		vcpu->arch.exception.pending = false;
 		vcpu->arch.exception.injected = true;
 
 		can_inject = false;
+out_except:
 	}
 
 	/* Don't inject interrupts if the user asked to avoid doing so */
-- 
2.34.1


