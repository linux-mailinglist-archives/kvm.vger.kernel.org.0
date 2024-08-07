Return-Path: <kvm+bounces-23465-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CD321949D33
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 03:00:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5565A1F21AF3
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 01:00:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C611A2209B;
	Wed,  7 Aug 2024 01:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="xs69/3tF"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2075.outbound.protection.outlook.com [40.107.220.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD52C8E0;
	Wed,  7 Aug 2024 01:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722992414; cv=fail; b=JVtmoWhElRv8i07pdv1mPJZLgfQn/J6aahp1y5GNQV7+50F/zOQAF+/5yNZUZdEVu0fBK0ghBnD9hYi9Iw7WiserZDOo2PRpdXeE9Ssz39avM7h/tzHBrSQ0Jnewrron63DJF87D3pSXVbira/brdALm9NoaNaal9HPymXnPePY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722992414; c=relaxed/simple;
	bh=7bhshxWFNpR2PwW9Q6i7bI0Elvjt/SCUTedmuU3bK4k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q878zicNsRXHIuPD8ZqdjBNcDN94aph/0jKe/82vi3bQSJ+rtQCYzz86N7uSNxCgAxdv7SbpgfCSCU9tkdSlqrW9Ild64+fJw7KLVEJjpZCYTKcUB3quwP7x2cQU/EurvhmRTTkMoWQ2T99/KUHtihcNiqmbNa6puLipPubjsPI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=xs69/3tF; arc=fail smtp.client-ip=40.107.220.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g4jVRYZO5XwRAKxNYRYmdyFemS9NMisFwdmBzJ1UKy6vGy2ZiobrIDvj9eXuUL6bfiHWg1SasRu8YEMjF3V5ziByHZ0S5X8d7twPgB/z46Vs9r2U3WgmqLBfHNBeyH5ruTPBWsUQElJZDqhxyeD3Qaar0QvfrgY45kS2wIgnsPCUwW5hvXoFnOg74OD3nK2q+xfKXX0XCV/kA/qF9wofystX2BsF17fhPb2fsIp1x4l47FZMt6HLMca+JNuUju796ZUH6xXWfJs2UHTm5mRuvj167eyJNgpEqDiVCTv+yMHso4UmcyNbaXyug8hx4KBpkCyaTXnEUC1fq+0QEzc3ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QlKOGx/T+4cVHorcuam8p/rvMhh4Yh1OFWpeUkY5WSg=;
 b=aicR+WeOoty2q/9KH0BjdycPR1Aq3phbmN+Cai3P6PtQ4ItLTkDLw47/eHuCi2+QxuF+ZR+xMjW/o+B+VoDHgBuTQlEkFIwg8AxcXgM5IEiQq38UOQySLt0qs6/dHkf7Xn1gf5V76YiCd1NIbEg43AiTHFmUlvsyYaI4l26XcaKOzXj4dH1yvOBFjnMZI0/dYmD/2ScVqIEjIDDkc6wkd492uCPnNZvWUOLT4AANLc3yd7AHGb9FfjC4W83UHfE4GxGI/1KSb6mWX7/73j1tSdC7U+rIrqBC8aJfmVpF9c6CiNHn9dLlNprZ+TmfluKfRdeCVl0zqZirO5XbjDteHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QlKOGx/T+4cVHorcuam8p/rvMhh4Yh1OFWpeUkY5WSg=;
 b=xs69/3tFuQjJrNF0Rc4VJV61ba8RE52fsMA1ZNdz+aXJznRDHV83HixHofuJuLTQQYNRKLIsdmNDLEXbZBUBc9ufpF9B1vyMohetX8kKxLTKnh67QgJR5bO3NbzpanclrhVNmFSnhMoJaoC+EAFQ6AdCXSMExaA+O0+So24nMzA=
Received: from BN0PR04CA0050.namprd04.prod.outlook.com (2603:10b6:408:e8::25)
 by PH7PR12MB6465.namprd12.prod.outlook.com (2603:10b6:510:1f7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.26; Wed, 7 Aug
 2024 01:00:09 +0000
Received: from BN3PEPF0000B077.namprd04.prod.outlook.com
 (2603:10b6:408:e8:cafe::80) by BN0PR04CA0050.outlook.office365.com
 (2603:10b6:408:e8::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.11 via Frontend
 Transport; Wed, 7 Aug 2024 01:00:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B077.mail.protection.outlook.com (10.167.243.122) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7849.8 via Frontend Transport; Wed, 7 Aug 2024 01:00:09 +0000
Received: from ruby-9130host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 6 Aug
 2024 20:00:06 -0500
From: Melody Wang <huibo.wang@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Tom Lendacky <thomas.lendacky@amd.com>,
	"Ashish Kalra" <ashish.kalra@amd.com>, Michael Roth <michael.roth@amd.com>,
	"Melody Wang" <huibo.wang@amd.com>
Subject: [PATCH 4/6] KVM: SVM: Inject NMIs when restricted injection is active
Date: Wed, 7 Aug 2024 00:57:58 +0000
Message-ID: <6d39d187147f9c98863fd5123bb044dafe54a916.1722989996.git.huibo.wang@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B077:EE_|PH7PR12MB6465:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c1892a9-062d-42ac-4aa8-08dcb67c48ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Hu7H3ls+mplG2KqsQOPGogyERuEUZFWuQIc4yVz2t+C2dJkOho+wD7lBS8ko?=
 =?us-ascii?Q?dhhfvKHEbRDlevCVJX2nF1x+gojbJG2Ye9sM2UbOC0RpJPFmcRKjq6zAsQK1?=
 =?us-ascii?Q?DcAKlBYvMyu8OneI+B/eFwwDvOIdq+iDic8YBacQUYJuibzAGwykHmcCNKwX?=
 =?us-ascii?Q?Jr5+30lwEClbVwqFyizJd3jfi2FJ1luxLQNyyf4HgAiQB6jElwqBWr6+1tjz?=
 =?us-ascii?Q?F1hq9/oGC3grbJf8ZVA1/csQMrUv6JEFwJ5lPs9m67lrs0C74F5F5vaStEAg?=
 =?us-ascii?Q?57P8+pIGPSlQaeZujU/bq4YQG4NDSai+rRST/qQlYAMpGtCUO+1ceFkrUAe/?=
 =?us-ascii?Q?WJFXjcR2PjP10aDUjYxY9ik4yyY1hN8CoSmTGvfo//U/2EbUOt3olxd+pY4H?=
 =?us-ascii?Q?FzOlMm3y4yvM42xL0BDw8VdPttwZWd+SR8V/ysqkHxxtOGrqYZmv1jZdvUkV?=
 =?us-ascii?Q?onc/2XqzO13tNR9sAFl5m+q/XQa9njucOXOul3sfF7q/p6G9+8i5MkDn8es/?=
 =?us-ascii?Q?6IzUGrN5X/1qKy6BI8DM3H1plusTor1Yjxm6py2OfAOT7I4Tdp93hxJE0lOg?=
 =?us-ascii?Q?cIRrBuVFrXFLD0biC1hVyg0JYnmWqgj6mNKMbUSShXPXNaIFQVpIDuBe7uPk?=
 =?us-ascii?Q?txU0ce40ZFvVy6tvEyk6KhZvvr/zvnZ9OaWKxs91EePBeDaRLTX+p8aysDxj?=
 =?us-ascii?Q?XwHRcx2SHFcYLuV6UJp3WrYtDfYoxABkxJ6nYhCL/WV4Kw2bcH25hmcXmZM+?=
 =?us-ascii?Q?gSPfY1etFy2B4D1krkdPD2WU8ljRh30fq1DYiLeknn0ATWU7cUYvQVoUIi+G?=
 =?us-ascii?Q?fvBrbwIBCmSB2fP5leo0f3S1+bkRMJ426BMk13eYu/CZ6DVsngHftn+ToLgc?=
 =?us-ascii?Q?nMR5NLA9gSBRRrJt2oXa7Wd91effOfEClnlBOS5eamt+/AMs1QTBpH0EM7NN?=
 =?us-ascii?Q?hFvNEiqPtrBjnMWqV8G4GFBhb7SnWvMcjzOqrjOktFQU8vwRPvQhlmVTR902?=
 =?us-ascii?Q?5V0dqPTqnw9x2iXH0CHbxqo/VsPxV94h4b5+FP4K6pUWKwtc54ZSkxFVGGai?=
 =?us-ascii?Q?GdGOnqYklkrL0GSAGeZgn5pqDSEBnaFIckOQS8VswoLo4DZMhgzB+hA61Nix?=
 =?us-ascii?Q?1c+x5HrdBjz6Nh4WkfDql8kYiq8IKxcBplaKaWic+TfW0Sh+4l/E4zHdg5Eo?=
 =?us-ascii?Q?Jphe/ksCGEKZPhl1MSSRwEwV6hizZlc+7J6fHZrNVbh7VHA0AEMM+OC6NK2C?=
 =?us-ascii?Q?CeoYAhmXRGIpDIot6PPPhBr2eGWuBwjj2LNQykLBrfLoGEjkhR0I6O5TTqqB?=
 =?us-ascii?Q?dho6puUKoot7hNgoAbqg6HKTJQsLknoE4HFXwzQph5c3oDgLiEAC3EXlyzVs?=
 =?us-ascii?Q?+WzgQ2y+Ei3O90ssKVXRFCPnYZdUJPRAOKGxdEwc/HFpSnNxdHSpRl9lcq9C?=
 =?us-ascii?Q?kg/AEK/CLPxvIn9qBEcs59A/NCaM6Snh?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2024 01:00:09.0346
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c1892a9-062d-42ac-4aa8-08dcb67c48ad
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B077.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6465

When restricted injection is active, only #HV exceptions can be injected into
the SEV-SNP guest.

Detect that restricted injection feature is active for the guest, and then
follow the #HV doorbell communication from the GHCB specification to inject
NMIs.

Co-developed-by: Thomas Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Thomas Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Melody Wang <huibo.wang@amd.com>
---
 arch/x86/kvm/svm/sev.c | 19 ++++++++++++++++---
 arch/x86/kvm/svm/svm.c |  8 ++++++++
 arch/x86/kvm/svm/svm.h |  1 +
 3 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 0d330b3357bc..7f9f35e0e092 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -5069,7 +5069,10 @@ static bool __sev_snp_inject(enum inject_type type, struct kvm_vcpu *vcpu)
 	if (!hvdb)
 		return false;
 
-	hvdb->events.vector = vcpu->arch.interrupt.nr;
+	if (type == INJECT_NMI)
+		hvdb->events.nmi = 1;
+	else
+		hvdb->events.vector = vcpu->arch.interrupt.nr;
 
 	prepare_hv_injection(svm, hvdb);
 
@@ -5147,10 +5150,17 @@ void sev_snp_cancel_injection(struct kvm_vcpu *vcpu)
 	/* Copy info back into event_inj field (replaces #HV) */
 	svm->vmcb->control.event_inj = SVM_EVTINJ_VALID;
 
+	/*
+	 * KVM only injects a single event each time (prepare_hv_injection),
+	 * so when events.nmi is true, the vector will be zero
+	 */
 	if (hvdb->events.vector)
 		svm->vmcb->control.event_inj |= hvdb->events.vector |
 						SVM_EVTINJ_TYPE_INTR;
 
+	if (hvdb->events.nmi)
+		svm->vmcb->control.event_inj |= SVM_EVTINJ_TYPE_NMI;
+
 	hvdb->events.pending_events = 0;
 
 out:
@@ -5168,8 +5178,11 @@ bool sev_snp_blocked(enum inject_type type, struct kvm_vcpu *vcpu)
 	if (!hvdb)
 		return true;
 
-	/* Indicate interrupts blocked based on guest acknowledgment */
-	blocked = !!hvdb->events.vector;
+	/* Indicate NMIs and interrupts blocked based on guest acknowledgment */
+	if (type == INJECT_NMI)
+		blocked = hvdb->events.nmi;
+	else
+		blocked = !!hvdb->events.vector;
 
 	unmap_hvdb(vcpu, &hvdb_map);
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index a48388d99c97..d9c572344f0c 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3602,6 +3602,9 @@ static void svm_inject_nmi(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	if (sev_snp_inject(INJECT_NMI, vcpu))
+		goto status;
+
 	svm->vmcb->control.event_inj = SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_NMI;
 
 	if (svm->nmi_l1_to_l2)
@@ -3616,6 +3619,8 @@ static void svm_inject_nmi(struct kvm_vcpu *vcpu)
 		svm->nmi_masked = true;
 		svm_set_iret_intercept(svm);
 	}
+
+status:
 	++vcpu->stat.nmi_injections;
 }
 
@@ -3786,6 +3791,9 @@ bool svm_nmi_blocked(struct kvm_vcpu *vcpu)
 	if (!gif_set(svm))
 		return true;
 
+	if (sev_snp_is_rinj_active(vcpu))
+		return sev_snp_blocked(INJECT_NMI, vcpu);
+
 	if (is_guest_mode(vcpu) && nested_exit_on_nmi(svm))
 		return false;
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 95c0a7070bd1..f60ff6229ff4 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -43,6 +43,7 @@ extern int lbrv;
 
 enum inject_type {
 	INJECT_IRQ,
+	INJECT_NMI,
 };
 
 /*
-- 
2.34.1


