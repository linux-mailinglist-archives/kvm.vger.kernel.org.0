Return-Path: <kvm+bounces-23467-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E0C68949D38
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 03:05:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 63BC71F22FD3
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 01:05:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05EC1339B1;
	Wed,  7 Aug 2024 01:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="zHPc2UQu"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2045.outbound.protection.outlook.com [40.107.93.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE477462;
	Wed,  7 Aug 2024 01:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722992690; cv=fail; b=ETCwfkINtvEOF0OjmMPC392nkFvq1ZszmiDY/9JZK65S33CLcbgTVSxXnWFmGuZnslGpJo38ToEyYX+gS3L97K6+PCh61DtF0uZA2NxaLuCceoUidc/OJodWAMm1R6AkTIxkAs8P32JxMV7FlfUov9pdvF02t4wZczspIHC0Nfc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722992690; c=relaxed/simple;
	bh=KMa1hnbCPxquE/3emtv4yl1bIM/L1yVcS9tsvVaFoDw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hrp+hg5qo3lX+mirfFy6C/mKIhQFqWMYchtsZBPqGSTlt1lBxiFu20lrDaLPsZAvgYa/k9D7o0OwWemw+42isVoZb+aXEYt4DZ3FtFk3UidMB4Sjf1OsYfnb2yOJB/upbMB9kcxzFNUps1sQCISf6QBMPrc76VAJFrz8wH01bVw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=zHPc2UQu; arc=fail smtp.client-ip=40.107.93.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gQxEYvFmnd8RolRrh/BJobLQrboeCMUDdAknEF6iSuAX29R41vCd0Prajddy6c0SiQNBP5hMD7vM/5qgi4FxD4vNcFlPh02uh9fJrRd3YlNNuhNHcGIYtttgjLIP4p5G5uUcWwjLJuHixJsWT+fbLFct5D6IxL8hLayMKPrJmTwG1u5TAIQGKdQcBekUZ9WWPTcNc3mxQ9Y3T5xHKaJXqarjQx0kyTthDlB6A+FobG6cSVi9tIj4E18xxoYHB5eSIgIeeLcpbXn3VlLeaVw3PXRs64wHvifRrN+zMDNAjGHNaq1MfAwKKH4VWWddYEy3aGKWbBSs5DTVMkAKk9ImOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ag/9NnQBPvavWKwZQJbNPDvdMdCVhhxswBLs7x3aZ8U=;
 b=njmtmpbZ02BHu3QH3+QBqI4EjoEkd6E7AMbwXkLg4oE2mvZ4t89ewkI6MKX4g99U20urPaEQoPRtgXmPbxYpkVu2h4RkFUy+b105ShWS4egsDSb8xII81+fxxhCAcMx4NQboKrHIn5PEfXPSq0kld69bp54RlVsDw4UfDFA0um+eRFt1cZgCN9dnnuqS9eQ/tF9z4oWw/pyMYpfmi8RKgDTWh98j2kwQFCeyR1y5uLG/y2r+fsKOdw5f3VpVUfMOUEHjhUNEB7tGGptlslNUfXCFJQtmm0zmLnQ/xMPYegoGsMTsaZWYOrKGgQ3lMwJdEW5rmSnMfxDiVRzw7Wncyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ag/9NnQBPvavWKwZQJbNPDvdMdCVhhxswBLs7x3aZ8U=;
 b=zHPc2UQu1j8acX9lhbyRsvyf6DQiDg3nlNRqujBHlCb0ePG3m47QbcUrAA1FdKRmwN3HE3yig4BCz2gkUFwBlwJkvzhPREFHNgCCQx/WfG/tN9vJ6WQ5IRr2xUiVtkvSuYVzW1Tjcc1vQLgUBVdNLyh0FVYshqk/J2+7dSkwVO0=
Received: from BLAPR03CA0048.namprd03.prod.outlook.com (2603:10b6:208:32d::23)
 by CH3PR12MB8457.namprd12.prod.outlook.com (2603:10b6:610:154::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.13; Wed, 7 Aug
 2024 01:04:38 +0000
Received: from BN3PEPF0000B072.namprd04.prod.outlook.com
 (2603:10b6:208:32d:cafe::25) by BLAPR03CA0048.outlook.office365.com
 (2603:10b6:208:32d::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.28 via Frontend
 Transport; Wed, 7 Aug 2024 01:04:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B072.mail.protection.outlook.com (10.167.243.117) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7849.8 via Frontend Transport; Wed, 7 Aug 2024 01:04:38 +0000
Received: from ruby-9130host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 6 Aug
 2024 20:04:36 -0500
From: Melody Wang <huibo.wang@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Tom Lendacky <thomas.lendacky@amd.com>,
	"Ashish Kalra" <ashish.kalra@amd.com>, Michael Roth <michael.roth@amd.com>,
	"Melody Wang" <huibo.wang@amd.com>
Subject: [PATCH 5/6] KVM: SVM: Inject MCEs when restricted injection is active
Date: Wed, 7 Aug 2024 01:00:47 +0000
Message-ID: <ec9b446fe9554effef9a9c5cec348e3f627ff581.1722989996.git.huibo.wang@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1722989996.git.huibo.wang@amd.com>
References: <cover.1722989996.git.huibo.wang@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B072:EE_|CH3PR12MB8457:EE_
X-MS-Office365-Filtering-Correlation-Id: 48edb18d-d4c4-48d0-2b4a-08dcb67ce93a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FJW4+4Z3IN5VPYTy5ziLV6wlQMxHqbGqabmlcVtzupvyJP0uwV1PYU8atWaw?=
 =?us-ascii?Q?6ACNBTPZr/zrWxaE0zIJzOwUWaMPT3kvX6lpngEWS0tcIPUo/NZpCrpwlr67?=
 =?us-ascii?Q?pmIGpVKkTjOmPP7rbzcXL0Spihblkop4CE3B1ZKVkWbbPNLjL+KVQnhTirN0?=
 =?us-ascii?Q?TBOCO3e855Cry6TsXGntsllqYRoDa5A+dkh8Fqq1VAv4Qywi5ZhhGtF01SGV?=
 =?us-ascii?Q?HWa4ldZ9i4dOnf8/Q6vviOSi5pkldigKSZvOakXriSo+to2vls2N1syl5FMf?=
 =?us-ascii?Q?ofVvkCK/+Z3HA4i78VRA8fZ1lAaiucp2YrW8na29RjiATSGIhB+0EtNUsQX1?=
 =?us-ascii?Q?6Bfs62gBwuErajHSx59j6SA/2uLHH8S2FAKGB+I/+U2ZODjZ58oigWXRw7kL?=
 =?us-ascii?Q?PUshTAgxoEBXwrCcG90gve7tk4xIQHRkOxcTw494QiJnx2GZbL4aHIn7KPmY?=
 =?us-ascii?Q?MLbvFrbtjXCEMjjKC9y0KgBK2HOtwQ4UPkcTQXq3MRVq5GpgeuMR+BJn1J6/?=
 =?us-ascii?Q?9s5FRo7sj4t4SaNWYhOInhJjkJ13wX79SFkR6E46OqTJzBLvrhEqz62ncxpU?=
 =?us-ascii?Q?zIBxuRILXHbyhhg3oNOUnJGgilg+A+4z/ugvOppj4ViEdoK/cgb5U6f8iaAP?=
 =?us-ascii?Q?hhNZAmQGlmSQ00tKaRlpIb2mLZ/D3/y5K84GO3yhGJSLSiwQT1N8LUx7UaU+?=
 =?us-ascii?Q?uUtxRoAci/jv8eQPFdlBdkkr1uemQ7OK0G2A91Fjg+8QaGyi+m+3l31Cj/Yj?=
 =?us-ascii?Q?Aa0HcUqKTZ1rD82JscVbx6jMpTE2/MMaFfO4xIJgxXOMyxXZO5I77CzL2hnq?=
 =?us-ascii?Q?yA6OMRs07x+tt1uwG+7cxP4+mS8e2/sUond8wGXRRBpZxZop0KMSrRvR8PhU?=
 =?us-ascii?Q?gIqSwDRSiCBd0VQK2JryO9IdasCMloccWj5VpmedGy1hqw6yk59/pcOzhJk3?=
 =?us-ascii?Q?Oqgn48tmZgVHJgYtIoHfZbDgWlOhExZNkUgmG085crAWEIlIKMTGJZiw9rvU?=
 =?us-ascii?Q?4Gz6haSoXTtq3Ww1JMzli7rlWvQGyQZ5AIy3tChA1FZzfV6fFRk9n1m/qRS9?=
 =?us-ascii?Q?OInhRrAEDzT3YDpljXsGcEkHM2hfzeO6amfZnJ0gbizaja/yx/q1KuKvEGs1?=
 =?us-ascii?Q?JhfjVIUDIF+GK/BF6itJZNZ4eeCb/+eJ2YnGgcGAX2PVUmAkibNIcYmPvboZ?=
 =?us-ascii?Q?cAt0JDxBH3LknRAi5ZNxBatPIMyGUWGvyRach7ca1DspAemLpUg07drcRZ5v?=
 =?us-ascii?Q?1gCvu7VFWxDAWAUVqZinclQV+GE8O3Sd8rrmYM9ih7wUL1c8RZGVUHyscHXI?=
 =?us-ascii?Q?XL5mxVRIzfZ1s+ZVs51yOOqx/XxsIM2AtNat4p1usbvuZn9XN2LcNDiZzWEo?=
 =?us-ascii?Q?x6QhECaoKsdRTnBx7hrGj6ucXyCZMC6UPQL7iIe+HZm9tyZX18zsoSnhp8L0?=
 =?us-ascii?Q?heHlbAQeXZBYLhKImsObpHz/uQnxppUM?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2024 01:04:38.4246
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 48edb18d-d4c4-48d0-2b4a-08dcb67ce93a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B072.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8457

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
index 7f9f35e0e092..87c493bad93a 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -5071,6 +5071,8 @@ static bool __sev_snp_inject(enum inject_type type, struct kvm_vcpu *vcpu)
 
 	if (type == INJECT_NMI)
 		hvdb->events.nmi = 1;
+	else if (type == INJECT_MCE)
+		hvdb->events.mce = 1;
 	else
 		hvdb->events.vector = vcpu->arch.interrupt.nr;
 
@@ -5088,6 +5090,11 @@ bool sev_snp_queue_exception(struct kvm_vcpu *vcpu)
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
@@ -5152,7 +5159,7 @@ void sev_snp_cancel_injection(struct kvm_vcpu *vcpu)
 
 	/*
 	 * KVM only injects a single event each time (prepare_hv_injection),
-	 * so when events.nmi is true, the vector will be zero
+	 * so when events.nmi is true, the mce and vector will be zero
 	 */
 	if (hvdb->events.vector)
 		svm->vmcb->control.event_inj |= hvdb->events.vector |
@@ -5161,6 +5168,9 @@ void sev_snp_cancel_injection(struct kvm_vcpu *vcpu)
 	if (hvdb->events.nmi)
 		svm->vmcb->control.event_inj |= SVM_EVTINJ_TYPE_NMI;
 
+	if (hvdb->events.mce)
+		svm->vmcb->control.event_inj |= MC_VECTOR | SVM_EVTINJ_TYPE_EXEPT;
+
 	hvdb->events.pending_events = 0;
 
 out:
@@ -5178,9 +5188,11 @@ bool sev_snp_blocked(enum inject_type type, struct kvm_vcpu *vcpu)
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
index ef3d3511e4af..e926fc9d82e6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10487,12 +10487,19 @@ static int kvm_check_and_inject_events(struct kvm_vcpu *vcpu,
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


