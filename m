Return-Path: <kvm+bounces-26204-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 100F897293F
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 08:06:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E89F1B23920
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 06:06:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8530117965E;
	Tue, 10 Sep 2024 06:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="duaWbJN0"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2047.outbound.protection.outlook.com [40.107.243.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED56D175D5A;
	Tue, 10 Sep 2024 06:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725948347; cv=fail; b=i7kZKo6O4w77ggPw5UeEmAduR9d/uOSS+JOvbmeJYMeuzVym0TuKntWAMBRIKUHxCUwv7DjAkkggZio9XJczIbJQwIz8tAJ4muvvkPfJFGylI+3rmeWkDtLdwlxs3Z4zaIiCIoTel1R1jFeGjcNugPkpgA8RUuLbNusI1dzWTZc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725948347; c=relaxed/simple;
	bh=2nraB2Z3/crlRxkcbr/hMqKCOwwWC042q2JUz7F0PT8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DJn0jJnhfP0Y8rEveT/JlXSBGRYcwLJOvDu1AnGXEMIEZftylZ5A6L+luItwcmrqjI/ojORtSR+HfEsyIoEOaVlbrqPxy1fpfTChOLWNMbpOd42JxIClXPviv0d4KsMvQxeFwpZGbKCGL0ePLPVVHgUn7e8bUXA8cAg5tIyr5hw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=duaWbJN0; arc=fail smtp.client-ip=40.107.243.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qd6oGM+SGEs3BTx3c51mUTb8np6VVIEj4q7RfwmdYVdngao6/HLyJB2bTTRG1oHLLrEMVrmQGwakrOpr2Y0ss+26u1+U7MHASotJ9KJEJOKGaUlgGV3eqTjV8OeFzR4PwXOZ1Xky3+CPKNFwj8pcYtE8uNS72Gh9078gR/S8qypCSnaeF5jZZA3JvsLbH4xiNeYsY22Fueh4rbdD92g9HkanTDLAls0GXEVF56FPVFHEhseUfH9Vi1DfNkMVOcy1viviLkVfJojp3LL11VuXv8y/xWXHKq18wbAwtbMnr2ya8KNy/1hpM7zjjNl1R6PgKZifipixytXS1I4z518b3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x4m2uRvXtfBuum/oRe5e5uAr00h6qkG0CTEBwXFmvAE=;
 b=GON7zNqTd8U9516frNJYgYrl8hnMy7YYe6NbK9UxZ7UAIoi3OZrqldeGoGklveG7LK1Yw7cIFPuEelvydRaOUxqlQrNddlcmZ7OKTgoIvU6YNA7uNGjuqbjCCYJRP9XPCPIpZcUH1v6mowcDouS/UmPHaAI6cNe09oKHh4J5Yo+2Co+KORGFUDAYbI5aJzCpZ3qcWMaLLX2jRjudyZJTk1iFy5HhVcc4qeZBv1mEvAuno0GEStVgn3jhc9XbND/u0hOYEKrWz1m6ZkcHlcFsSb9xXgFsBREt/tiT4e/dpgN82RDGTM9sW3QnAJufD4IYcNbLuyqpoUpg8vuDfNEBlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x4m2uRvXtfBuum/oRe5e5uAr00h6qkG0CTEBwXFmvAE=;
 b=duaWbJN059BqnEbzLuq2G6H7w0EyI2nLNCoXo23cLASJLsN300hrF5vk7hEoMAveeBLHLAGifnkM/LsxPXJskpviFG233GgFktfpIkuo9c54kEXri8sVeTV49AIzxkqxqahmU071O9pTIHy+OBIjfR/wbVIWnMtQAKFVzcOD6aQ=
Received: from BYAPR08CA0020.namprd08.prod.outlook.com (2603:10b6:a03:100::33)
 by PH7PR12MB7259.namprd12.prod.outlook.com (2603:10b6:510:207::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.17; Tue, 10 Sep
 2024 06:05:41 +0000
Received: from CO1PEPF000075F4.namprd03.prod.outlook.com
 (2603:10b6:a03:100:cafe::2e) by BYAPR08CA0020.outlook.office365.com
 (2603:10b6:a03:100::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.24 via Frontend
 Transport; Tue, 10 Sep 2024 06:05:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1PEPF000075F4.mail.protection.outlook.com (10.167.249.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7918.13 via Frontend Transport; Tue, 10 Sep 2024 06:05:41 +0000
Received: from ruby-9130host.amd.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 10 Sep
 2024 01:05:39 -0500
From: Melody Wang <huibo.wang@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Tom Lendacky <thomas.lendacky@amd.com>, Ashish Kalra
	<ashish.kalra@amd.com>, Michael Roth <michael.roth@amd.com>, Melody Wang
	<huibo.wang@amd.com>
Subject: [PATCH v2 5/6] KVM: SVM: Inject MCEs when restricted injection is active
Date: Tue, 10 Sep 2024 06:03:35 +0000
Message-ID: <fcddd32c625acef93ac1fd74b472d26d36626ecb.1725945912.git.huibo.wang@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1725945912.git.huibo.wang@amd.com>
References: <cover.1725945912.git.huibo.wang@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB03.amd.com
 (10.181.40.144)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000075F4:EE_|PH7PR12MB7259:EE_
X-MS-Office365-Filtering-Correlation-Id: fd731b2b-6f35-439c-5c22-08dcd15e997b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1HL9QZ1HMc15uaj3sGyHhOja3gGT8lgVusY8xy6GJ6SZ9bWh1bb/O8lju8FU?=
 =?us-ascii?Q?/jLSaHGzTIovx0JTH5KCmYsDiM4eHq7EndMR+KHvrp5iFhnitrdWO7ZKpt4z?=
 =?us-ascii?Q?hX47rxYyCEKQNZmGUksmnZZ1nRdtyd4DoYL/Z8eBP+zsqjTo7SmGP2EC+a7a?=
 =?us-ascii?Q?WyGVYuo275AdVM7LuKPYi/7Bb3oc7fFdp5Aym/sXqex+FqhFp6t9o0bH6q95?=
 =?us-ascii?Q?4yDl80wTVDnIXswQaNtJqnL7yDzsZanH3w69ZCNngR2SeAg9KZbcd4ZKtrnV?=
 =?us-ascii?Q?IfNpWCS0psLrXTqhjH8m+etvw5siGOBSnl2/TkP1ur8H1W1Mchb9XrxJQkYE?=
 =?us-ascii?Q?D4vxyv2g31ZmPYJFSqnmW+b/cBv1ajZPMoRo3iB1ybJsC/vFT/hvGGuoMj8E?=
 =?us-ascii?Q?7H25ufHQpwWnU7J2LrNybUymAHtJrRnQ9t/eTpWKdwrUCDEHXjBKOfHbJz06?=
 =?us-ascii?Q?Vm02kRHODLKBCiNzpztekSVlkc3nsGUjr4u63wYyFenHtWbrNWtxzzYLpSAA?=
 =?us-ascii?Q?eZI1J+krXJ/qPzrxmIZwuh317dc9cISfQJc/epUxXU/ZmpfVJ3pb9xCFZToV?=
 =?us-ascii?Q?rmbap4dzhKMxbDao9NT8Pm+ijF8ZBrEyHW8SZ6zDit+csrLCaFTnUhJdEtui?=
 =?us-ascii?Q?5CCgx42Rk+Kv56NAM35JjXxgqFe8rGee/hE/rkBYdcKAWaweuwwMbHLAQoEI?=
 =?us-ascii?Q?R8ztOOrGvmmSDDcdSlCLhVJehZvvE229e43mAiK2TU4JptmlO+cSxdc/gyWd?=
 =?us-ascii?Q?BoHJ9PQClYRW7MCVik9PCx/ywwwTttF5a2lOnYlCHEO0K9+wrv7Hef7vjnhu?=
 =?us-ascii?Q?vgSYoqd7TNgoY7sL7lzNTR1GgHO0988DB8S+7gFOo9Hn57+PiAKxPVtPrwAr?=
 =?us-ascii?Q?84MeKpysL9vQKd1uz0Wgih5kCax6+57t5R5HBsBJIJ92JUIJNncqIDfnomjO?=
 =?us-ascii?Q?w2kF46v3IW8LaHO2+f68UqiX8q1Ydakf3oG/c+65vVM4X2BrCjHoym8nPvtE?=
 =?us-ascii?Q?xp8DSRu9pNaIsrnCAC95a496Fds64Eszk6TLkj5yHd1EpR5Pl8Hyfudy3Zem?=
 =?us-ascii?Q?0GVys1hSsep2EYAp2q7IVz89e2Hah88APvKs6aGsQSY0ZBQ2sdr3ue+bTU7B?=
 =?us-ascii?Q?dlGQRZQthtvegzY0BfrGQnGv91TOqa5ZHXFKkbj6n7EVMFRDq/GASUmuMw0F?=
 =?us-ascii?Q?V3LzGIzYrlrlmzk00G7+0nPNjDnauu3GygVhN6Gz40sBwrtNxzrLBFwHH4x7?=
 =?us-ascii?Q?wDn3vTwo+U+s5DhNekCnYcuGO8YCIjwb2XrdN3FoSxQNTtPDpDFABKfthNxg?=
 =?us-ascii?Q?0/saCe1Z67jaY07DUOXXT40N2NSK+YoqhX4lrs+SQFFmRKbTvY7zsgo0XwvN?=
 =?us-ascii?Q?xFvMeNRVWQJrAdHHO+37dtcP5nTQheEe+VIrFG7+KVrT2FXlWrQlVc46ITjx?=
 =?us-ascii?Q?sUdA/ArSxSXxcVYYzoxPRVO4+VaIvaKS?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2024 06:05:41.0334
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fd731b2b-6f35-439c-5c22-08dcd15e997b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075F4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7259

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
 arch/x86/kvm/x86.c                 |  8 ++++++++
 9 files changed, 50 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 68ad4f923664..9e5764a8e031 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -76,6 +76,7 @@ KVM_X86_OP(inject_exception)
 KVM_X86_OP(cancel_injection)
 KVM_X86_OP(interrupt_allowed)
 KVM_X86_OP(nmi_allowed)
+KVM_X86_OP_OPTIONAL(mce_allowed)
 KVM_X86_OP(get_nmi_mask)
 KVM_X86_OP(set_nmi_mask)
 KVM_X86_OP(enable_nmi_window)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 94e7b5a4fafe..cb1608a69144 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1715,6 +1715,7 @@ struct kvm_x86_ops {
 	void (*cancel_injection)(struct kvm_vcpu *vcpu);
 	int (*interrupt_allowed)(struct kvm_vcpu *vcpu, bool for_injection);
 	int (*nmi_allowed)(struct kvm_vcpu *vcpu, bool for_injection);
+	int (*mce_allowed)(struct kvm_vcpu *vcpu);
 	bool (*get_nmi_mask)(struct kvm_vcpu *vcpu);
 	void (*set_nmi_mask)(struct kvm_vcpu *vcpu, bool masked);
 	/* Whether or not a virtual NMI is pending in hardware. */
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 9102f7e39c52..0b898b16026b 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -5072,6 +5072,8 @@ static bool __sev_snp_inject(enum inject_type type, struct kvm_vcpu *vcpu)
 
 	if (type == INJECT_NMI)
 		hvdb->events.nmi = 1;
+	else if (type == INJECT_MCE)
+		hvdb->events.mce = 1;
 	else
 		hvdb->events.vector = vcpu->arch.interrupt.nr;
 
@@ -5089,6 +5091,11 @@ bool sev_snp_queue_exception(struct kvm_vcpu *vcpu)
 	if (!sev_snp_is_rinj_active(vcpu))
 		return false;
 
+	if (vcpu->arch.exception.vector == MC_VECTOR) {
+		if (__sev_snp_inject(INJECT_MCE, vcpu))
+			return true;
+	}
+
 	/*
 	 * Restricted injection is enabled, only #HV is supported.
 	 * If the vector is not HV_VECTOR, do not inject the exception,
@@ -5153,7 +5160,7 @@ void sev_snp_cancel_injection(struct kvm_vcpu *vcpu)
 
 	/*
 	 * KVM only injects a single event each time (prepare_hv_injection),
-	 * so when events.nmi is true, the vector will be zero
+	 * so when events.nmi is true, the mce and vector will be zero
 	 */
 	if (hvdb->events.vector)
 		svm->vmcb->control.event_inj |= hvdb->events.vector |
@@ -5162,6 +5169,9 @@ void sev_snp_cancel_injection(struct kvm_vcpu *vcpu)
 	if (hvdb->events.nmi)
 		svm->vmcb->control.event_inj |= SVM_EVTINJ_TYPE_NMI;
 
+	if (hvdb->events.mce)
+		svm->vmcb->control.event_inj |= MC_VECTOR | SVM_EVTINJ_TYPE_EXEPT;
+
 	hvdb->events.pending_events = 0;
 
 out:
@@ -5179,9 +5189,11 @@ bool sev_snp_blocked(enum inject_type type, struct kvm_vcpu *vcpu)
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
index d9c572344f0c..1c13c5da6eea 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3867,6 +3867,22 @@ static int svm_interrupt_allowed(struct kvm_vcpu *vcpu, bool for_injection)
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
@@ -5066,6 +5082,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.cancel_injection = svm_cancel_injection,
 	.interrupt_allowed = svm_interrupt_allowed,
 	.nmi_allowed = svm_nmi_allowed,
+	.mce_allowed = svm_mce_allowed,
 	.get_nmi_mask = svm_get_nmi_mask,
 	.set_nmi_mask = svm_set_nmi_mask,
 	.enable_nmi_window = svm_enable_nmi_window,
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index f60ff6229ff4..0cf32954589f 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -44,6 +44,7 @@ extern int lbrv;
 enum inject_type {
 	INJECT_IRQ,
 	INJECT_NMI,
+	INJECT_MCE,
 };
 
 /*
@@ -602,6 +603,7 @@ void svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
 void disable_nmi_singlestep(struct vcpu_svm *svm);
 bool svm_smi_blocked(struct kvm_vcpu *vcpu);
 bool svm_nmi_blocked(struct kvm_vcpu *vcpu);
+bool svm_mce_blocked(struct kvm_vcpu *vcpu);
 bool svm_interrupt_blocked(struct kvm_vcpu *vcpu);
 void svm_set_gif(struct vcpu_svm *svm, bool value);
 int svm_invoke_exit_handler(struct kvm_vcpu *vcpu, u64 exit_code);
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 0bf35ebe8a1b..c3a49a3b7f21 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -84,6 +84,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.cancel_injection = vmx_cancel_injection,
 	.interrupt_allowed = vmx_interrupt_allowed,
 	.nmi_allowed = vmx_nmi_allowed,
+	.mce_allowed = vmx_mce_allowed,
 	.get_nmi_mask = vmx_get_nmi_mask,
 	.set_nmi_mask = vmx_set_nmi_mask,
 	.enable_nmi_window = vmx_enable_nmi_window,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f18c2d8c7476..b3dce5d95329 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5093,6 +5093,11 @@ int vmx_interrupt_allowed(struct kvm_vcpu *vcpu, bool for_injection)
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
index ce3221cd1d01..b2b1a3bb4eb3 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -92,6 +92,7 @@ void vmx_inject_exception(struct kvm_vcpu *vcpu);
 void vmx_cancel_injection(struct kvm_vcpu *vcpu);
 int vmx_interrupt_allowed(struct kvm_vcpu *vcpu, bool for_injection);
 int vmx_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection);
+int vmx_mce_allowed(struct kvm_vcpu *vcpu);
 bool vmx_get_nmi_mask(struct kvm_vcpu *vcpu);
 void vmx_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked);
 void vmx_enable_nmi_window(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 70219e406987..2007598af873 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10485,6 +10485,12 @@ static int kvm_check_and_inject_events(struct kvm_vcpu *vcpu,
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
@@ -10493,6 +10499,8 @@ static int kvm_check_and_inject_events(struct kvm_vcpu *vcpu,
 		can_inject = false;
 	}
 
+out_except:
+
 	/* Don't inject interrupts if the user asked to avoid doing so */
 	if (vcpu->guest_debug & KVM_GUESTDBG_BLOCKIRQ)
 		return 0;
-- 
2.34.1


