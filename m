Return-Path: <kvm+bounces-58465-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6008BB944B2
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 07:08:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 13ADC16CB6E
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 05:08:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3C1930DECF;
	Tue, 23 Sep 2025 05:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="iQN00Mjy"
X-Original-To: kvm@vger.kernel.org
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011007.outbound.protection.outlook.com [40.107.208.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E41E30DEA0;
	Tue, 23 Sep 2025 05:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758604071; cv=fail; b=D3VttVvoYiRbsH2Ejz//G2F8LWXXXVqONAUoldedjR2hkqCrdmLwjiOl7om5e38rtwmo0GAvmTb1APmDkatsJvf/HfiX1YA+KllUnh8+c42diT6D6mxGxszmpbFNGj16boZUvnz4tGYwy/xNJmQTUvc2wu1QxCBPhH2Tdr5Hvr0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758604071; c=relaxed/simple;
	bh=JI/bOwD+fKHHYiz0MYmJj1x3/jcZI5D+3Z7eBRm4htU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X9wXGQ11OVEdbdtp1j/c7BFh7hpXloJO/32akeUCrZtApO+u9zMbXDLayNGVi5FI8Cn1fl67DxtEKVLKyguhabh2O3AgG2vJb6FD9uK4uQwTW9i+iTt93+41g6vb3HrzEitECzQIGfzCDQ6uFulNLZuq8wuF9/PWXdNfo5gIEEo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=iQN00Mjy; arc=fail smtp.client-ip=40.107.208.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S5elVMbDa+YHGJcAeYaAvuO2J8FGQrff76Rv6VmPUlf0enSW113dkLj0MyX1+1nz2MeUpryvCYF57ETtAiNODhlbJ7B1ZDohAx1/C1tflcJKAHdzhPRkiuQZ6/jF62xx1QGvhm8oPB8kn7fBpfHbs9APUZl3wOqW5qTWO051D/mjdwAnsC6/CY06p1LjjQvBlLbPye03M99R2rvme4cZy5aFAAtZwoZLzRY+SJMMqhyRFlNwRgJFL9k9iEHNboPq+Tv88Iq3/7Ouo5j1ym5ZgIQLEoviaKuYq5PfUrglZ74xJVUgdpgHNhGJ4T1xZgN/DoCPupnItvF9GCYjRIV70Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iZICnsgUWu3rHAzppHhpQNnMLJCrsQ5n/hHqVvrf3/c=;
 b=rYEMh707bo6uEFnQhCTPDp0EVRzKE2N89b+HhkRTwycaD1PhCEfZydqd2SUcXl9BTeeu5KgTBM+z8rteZnF5U+MAvoXZw+UGF6LSwnWYWyB+PzFocSTM7485k2D1AP3Yipk3ydt/wmfIcy632ToesFpgaFlCNxjTw6v8h0qq/dsyVCcY6D8E+wV7PjKzzgOeeUOMtQuJ4ff7wyV0vpNHKqXvU7yyf+QIVesB9bd9v3ttfzw3Nr6FBnkvK36LdLNKODVMoxtMZunCWHUzQy0JmRbgDv8TeZYFXvS5TrKcWo9uoEafG4BPXExcTt8sDk5rE926WkVKNphj5vFSZGCQMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iZICnsgUWu3rHAzppHhpQNnMLJCrsQ5n/hHqVvrf3/c=;
 b=iQN00Mjyuaq6TOH7mmWULmp2lhW2CMMnKt+RtzO2g28SlW+adpglANrVZ1IOJZJ9brmAWLZKS9CKtJilCxxhKeGZYhkCneM55a8OoTPik6cIoMJZJUeoL+4nKKe7gfc82nJXpDvDiJHR2mCbxkdKIg9FcBSgw2Rt98WL0hyjzIg=
Received: from SJ0P220CA0003.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:41b::34)
 by IA0PR12MB8894.namprd12.prod.outlook.com (2603:10b6:208:483::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.20; Tue, 23 Sep
 2025 05:07:45 +0000
Received: from MWH0EPF000971E9.namprd02.prod.outlook.com
 (2603:10b6:a03:41b:cafe::9c) by SJ0P220CA0003.outlook.office365.com
 (2603:10b6:a03:41b::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.20 via Frontend Transport; Tue,
 23 Sep 2025 05:07:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MWH0EPF000971E9.mail.protection.outlook.com (10.167.243.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.12 via Frontend Transport; Tue, 23 Sep 2025 05:07:44 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 satlexmb07.amd.com (10.181.42.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 22 Sep 2025 22:07:40 -0700
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <kvm@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <Thomas.Lendacky@amd.com>,
	<nikunj@amd.com>, <Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <bp@alien8.de>, <David.Kaplan@amd.com>,
	<huibo.wang@amd.com>, <naveen.rao@amd.com>, <tiala@microsoft.com>
Subject: [RFC PATCH v2 15/17] KVM: SVM: Check injected timers for Secure AVIC guests
Date: Tue, 23 Sep 2025 10:33:15 +0530
Message-ID: <20250923050317.205482-16-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250923050317.205482-1-Neeraj.Upadhyay@amd.com>
References: <20250923050317.205482-1-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E9:EE_|IA0PR12MB8894:EE_
X-MS-Office365-Filtering-Correlation-Id: baadc375-30fa-450d-417a-08ddfa5f21b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OAPcXCOTjug9uyiSg+tptK5vn7wu61iw8t0n8VRljfTAwd4ZSYw/htR/5tRs?=
 =?us-ascii?Q?7ofa1MDngiAtosNy614nMfRmvHP93y/vRISQ2ozPnLaCS5EeNMHYSQuFXmAN?=
 =?us-ascii?Q?CqGeN1tusbYYyWD2upcCFfdtBOxAo6ofFsvA86v/uUXGaHj0ehGy2Se7sXRG?=
 =?us-ascii?Q?3XYtx3CaMtrjWfNubgyiIxwK/UrWtFXmmN9xiIBryqWTGdIym7kpOEA4nR1v?=
 =?us-ascii?Q?d8kMmuw3bi72imZ2D4GWj7S1itZYaTFw8V49Tbpzst8zUQIAgTtPCIkUxaq5?=
 =?us-ascii?Q?lGmjueBhFmuJF5yklWVim+WmPYX2OaoIED8i2syNpHareK49Frm2BZ7jZe6H?=
 =?us-ascii?Q?tWCv/xPd+wJEKDIwEfPpS3cuSM2d3oiL1A3Mtoq9gqwbDuIH6IcTePTnSbNO?=
 =?us-ascii?Q?YQcxRl3cHWVHqXA0aUQpjOOu42rKrPgw073421wNFZ1Q8TnY4fcVotnmq9P2?=
 =?us-ascii?Q?4+O7L0hVXkvZyTUaIAOJyas45b4BOzopFoOopKiZSvgyKKuafB2/hYx6YpOk?=
 =?us-ascii?Q?cELRHFaAf9MRkTsmTsJ+uAc3X+RJ4/yPmOzWW4/xHVinqI4TVysWbfAr3qn6?=
 =?us-ascii?Q?pHb2FSMaJ8ebrP07bK+AVpr/fqY9pgFeXWRM1hYyUjU9tTlodbY+CbvGfzgs?=
 =?us-ascii?Q?VVt5RqiNayvUm4MVwZ0j/uhqgVg/r90QWWI9pfArF0jF0Uf9/f409BD8CFBu?=
 =?us-ascii?Q?ogN0FFw6Czo3SsVSTYjlk6WOyKcmqMo9eb95XDfowKOfQ2CE+VCHQICHIflb?=
 =?us-ascii?Q?Z2ZOvJZs6fgeATC5zHt3fnXpjGzvcC2w5oZAMuBR13GZftwog9m0WsQyaRlf?=
 =?us-ascii?Q?WBQ5HZfn8edaSwGDUQA9rCA1KAmL9/Vn8n8D484lu3XqlC7FJXo2v3N6yrD/?=
 =?us-ascii?Q?SByPue6nj4whY77ynAful0esSiN9VWajdlKQMTc5ms4GCraJxXcHLp3GV4wI?=
 =?us-ascii?Q?8waUFMhc3aKRfDsV1DyY/SbLgSPt63BVgvwYHWHPbBtJ7i3wF8Q3FzPD8EPG?=
 =?us-ascii?Q?fN+4BCAo8PIiwGWFm6//ubcKqtIsVV1DzIZByucHjLUrASiF8M+dN4OqH2J9?=
 =?us-ascii?Q?dtb023CuiZMCiYN92mRFrtWnMv5j2JGAdVSSNxxApvigOh2ip6+3kyT7BTFO?=
 =?us-ascii?Q?sUf58MEjCcxI+MgmJ9o3v1rNUywKojOKREByGfsmU3/do48gElsmL14N4JEJ?=
 =?us-ascii?Q?LxgjqzZyjlNTrCwTjo1/Mc2jGIWVol8baafe6sxXT66v3fGBkUqYhB6FY2lV?=
 =?us-ascii?Q?JbrEHlcug4n/YuW5cGMnKB+5sXlHwbcC3fYQ+x2Nn/tQLq/LaUSCZ9tUEgNd?=
 =?us-ascii?Q?0KUgB27stv74veUsZVaUAexZ7dlJVQ84DrH3F02K/V+qsA3wwQ7U5cG6FdFC?=
 =?us-ascii?Q?fK5/ya4v1pCImA6klcigZdeSQTBMtzvDnn8QOEhBZ5A+bl2ZKJwloU5sG1n8?=
 =?us-ascii?Q?n1CNyXX8+mmiXitpqKiOp3OuOfUcZR3ugA2GMPrDhDYixTTxsgZe76ARhJmN?=
 =?us-ascii?Q?HobaJVOUQCOmrwuZSY+PqfamalCHCl6xCt+4?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 05:07:44.9664
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: baadc375-30fa-450d-417a-08ddfa5f21b9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E9.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8894

The kvm_wait_lapic_expire() function is a pre-VMRUN optimization that
allows a vCPU to wait for an imminent LAPIC timer interrupt. However,
this function is not fully compatible with protected APIC models like
Secure AVIC because it relies on inspecting KVM's software vAPIC state.
For Secure AVIC, the true timer state is hardware-managed and opaque
to KVM. For this reason, kvm_wait_lapic_expire() does not check whether
timer interrupt is injected for the guests which have protected APIC
state.

For the protected APIC guests, the check for injected timer need to be
done by the callers of kvm_wait_lapic_expire(). So, for Secure AVIC
guests, check to be injected vectors in the requested_IRR for injected
timer interrupt before doing a kvm_wait_lapic_expire().

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
 arch/x86/kvm/svm/sev.c | 8 ++++++++
 arch/x86/kvm/svm/svm.c | 3 ++-
 arch/x86/kvm/svm/svm.h | 2 ++
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 5be2956fb812..3f6cf8d5068a 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -5405,3 +5405,11 @@ bool sev_savic_has_pending_interrupt(struct kvm_vcpu *vcpu)
 	return READ_ONCE(to_svm(vcpu)->sev_savic_has_pending_ipi) ||
 		kvm_apic_has_interrupt(vcpu) != -1;
 }
+
+bool sev_savic_timer_int_injected(struct kvm_vcpu *vcpu)
+{
+	u32 reg  = kvm_lapic_get_reg(vcpu->arch.apic, APIC_LVTT);
+	int vec = reg & APIC_VECTOR_MASK;
+
+	return to_svm(vcpu)->vmcb->control.requested_irr[vec / 32] & BIT(vec % 32);
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index a945bc094c1a..d0d972731ea7 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4335,7 +4335,8 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
 	    vcpu->arch.host_debugctl != svm->vmcb->save.dbgctl)
 		update_debugctlmsr(svm->vmcb->save.dbgctl);
 
-	kvm_wait_lapic_expire(vcpu);
+	if (!sev_savic_active(vcpu->kvm) || sev_savic_timer_int_injected(vcpu))
+		kvm_wait_lapic_expire(vcpu);
 
 	/*
 	 * If this vCPU has touched SPEC_CTRL, restore the guest's value if
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 8043833a1a8c..ecc4ea11822d 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -878,6 +878,7 @@ static inline bool sev_savic_active(struct kvm *kvm)
 }
 void sev_savic_set_requested_irr(struct vcpu_svm *svm, bool reinjected);
 bool sev_savic_has_pending_interrupt(struct kvm_vcpu *vcpu);
+bool sev_savic_timer_int_injected(struct kvm_vcpu *vcpu);
 #else
 static inline struct page *snp_safe_alloc_page_node(int node, gfp_t gfp)
 {
@@ -917,6 +918,7 @@ static inline struct vmcb_save_area *sev_decrypt_vmsa(struct kvm_vcpu *vcpu)
 static inline void sev_free_decrypted_vmsa(struct kvm_vcpu *vcpu, struct vmcb_save_area *vmsa) {}
 static inline void sev_savic_set_requested_irr(struct vcpu_svm *svm, bool reinjected) {}
 static inline bool sev_savic_has_pending_interrupt(struct kvm_vcpu *vcpu) { return false; }
+static inline bool sev_savic_timer_int_injected(struct kvm_vcpu *vcpu) { return true; }
 #endif
 
 /* vmenter.S */
-- 
2.34.1


