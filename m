Return-Path: <kvm+bounces-26203-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F0E2797293E
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 08:06:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 27E97B24060
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 06:05:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9958D16F27F;
	Tue, 10 Sep 2024 06:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="3RowBa7L"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2076.outbound.protection.outlook.com [40.107.223.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E790166F00;
	Tue, 10 Sep 2024 06:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725948344; cv=fail; b=lNNg+3BdXPaxGYRwOagsDjY9+Xru2Q6rgsMdwJyAGmzrLLBNWOllnwKn3w8P6oIsnvtVvqUGNbX8GcB08sztWzwdPsIj27esSNU3YYe9NG8qLYWAYJSRDHldRtC5XUmEKaJ4YBtnSOEjh1XJiKIzmCI8QjUp1jdU9eE+6y3KqYg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725948344; c=relaxed/simple;
	bh=1RvH64giLzsAFCBJEwnxMeF9iIP+bM0o2di3sz1EdXQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ltKZtmIBTK6MUm/qtijqJUNMtrk08nYYGK597Daq7p6MGQ//aT7yigK0xPUkeO0BNau1Ld3zd3Z/VZcJwubhxswXcc2GK5RFeJKUWMahlyXyZxZsg5+qvzkvCfItxZgZrKgWnLJ2WFQSFunHahopItkQUo3nyA73OoSjecJ0RcA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=3RowBa7L; arc=fail smtp.client-ip=40.107.223.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qLWCIXYehhnsJAl36EI+5YY61vEb8sBelCaoqKAeZSccVfQ0Zt7CN3dgRA+aFZlGIXliBYwEbmszZIQzw7UxWjjxyJL7YC0jfzwK4Ct8jneSYuNZZF8QdHdaUyKpVjTLr13N/L0BF5Q+xpd4e+vC9jMYw5hijkkfqBPh/+kQ9qTdQMKi/f0Zr6fXDczNPyvdfAnmagfI+3kQDINFzM02wZWFYY740aQ+V+y7vYhEqgF6snLkB2EUpYqIoadtbGto5ltqC+Gic0JzvOp9g2es3ibeYmj/sy9TANs3fs2AyMWXegE3Vipez+DrK+eB/grAtQ/n5Z3TuX8S2tNEvd98lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mXskL7azb5JqpARC1VesGy6K3lPsq/FoQJe8AVkcByI=;
 b=B/DX8DIX3V2jc5mSXiXeD6jPONCSrnOO4MeErn8QyF2x84Z1fwMdM54155fw2IGshlbGdBHpbAR/tPV6ehqFSVQw8RdfDWUgHdnK2TfX9uTTQhiH1PBtHI9clLV5IMMDYcO97v9X04/DS6t+BS7ZjSFw+8jqH8CDLtbQKMtTMFG7/G0GwcY8LSxfIdz7RHq44dC8PK4fely+1mgxLAmv8t29v0P56OF0ziCizOVC4abb86Kuz4C20wqJh+R2RRLIpsKa7GexajrFow0huo5y5cNwxMx3MILhGWSqpyx9d/FcgczbbHqSDiB0YujvNWlO/BIixaN9tNtkBVVMsc0bcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mXskL7azb5JqpARC1VesGy6K3lPsq/FoQJe8AVkcByI=;
 b=3RowBa7LM0Pbe9x9KFb2geAqppis2TZnrQbCM8vUZEBXw2LOgLyFnBs413KMhCA1I8kvZ+hvNsJOxzzHEmLf6u2/6RUmfXTdKWOQlqFrrfgMfgPSzYtRxrVtzBOcNYHgHs6HP9mILpOYLrmYKcN9HK1l8yj1n+ixh8n75S5TqK0=
Received: from MW3PR06CA0023.namprd06.prod.outlook.com (2603:10b6:303:2a::28)
 by CH3PR12MB8459.namprd12.prod.outlook.com (2603:10b6:610:139::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.28; Tue, 10 Sep
 2024 06:05:24 +0000
Received: from CO1PEPF000075ED.namprd03.prod.outlook.com
 (2603:10b6:303:2a:cafe::e) by MW3PR06CA0023.outlook.office365.com
 (2603:10b6:303:2a::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.25 via Frontend
 Transport; Tue, 10 Sep 2024 06:05:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1PEPF000075ED.mail.protection.outlook.com (10.167.249.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7918.13 via Frontend Transport; Tue, 10 Sep 2024 06:05:23 +0000
Received: from ruby-9130host.amd.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 10 Sep
 2024 01:05:21 -0500
From: Melody Wang <huibo.wang@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Tom Lendacky <thomas.lendacky@amd.com>, Ashish Kalra
	<ashish.kalra@amd.com>, Michael Roth <michael.roth@amd.com>, Melody Wang
	<huibo.wang@amd.com>
Subject: [PATCH v2 4/6] KVM: SVM: Inject NMIs when restricted injection is active
Date: Tue, 10 Sep 2024 06:03:34 +0000
Message-ID: <e27a542257fa03810eb2851ebcc3850e815513c1.1725945912.git.huibo.wang@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000075ED:EE_|CH3PR12MB8459:EE_
X-MS-Office365-Filtering-Correlation-Id: 9280c4e8-defd-48cd-2b0e-08dcd15e8f08
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GQ4SXD0aqoGcYckGdtczib2+hXBFBTScYbEOQGQ7zUj55tfiBUk0antegaGi?=
 =?us-ascii?Q?iBG7k05v4xdp00MYRgKW2zdbRSkTLDMJBZU530kC7gciXZvMUtDafO1/vYUH?=
 =?us-ascii?Q?u7oUhwkFtb8eHJhgtSy00DLsrVYufhdypY8yF9UG8DskJjMGHeBdWXpwfPtg?=
 =?us-ascii?Q?d7JLMHek2NG7kchGeYlKUhXa9SUth+JgRuFKPXOsS2nf964N6XOkWCxyBoLN?=
 =?us-ascii?Q?2FP9I0UOJVJeWj7viDZn1kc2gumF0qHG759m7C0aNC4HLBTo5hOhyZeaAq+Q?=
 =?us-ascii?Q?uevJ0Rxo1/3UoMEHtwuDAftnkNRTvh+fP1eytTRfse1CXkXzk/WkoRtqvry1?=
 =?us-ascii?Q?+5ECvBwm/nxMe3uEfIkaH1mlkzyhff/w43jPEIQQOJoQkJXUBHp6A8UfXYZU?=
 =?us-ascii?Q?zDbGtNsu2pTdHfx8u0ZfY1Hil8rph8TKehO9xQDhtSkvKKGUGSAoZoniF3IQ?=
 =?us-ascii?Q?iF4g+dTQ2EMG3p8lMNOgUYx3r+p1qD2y6ZOpIDDWgC8Se84gZvforBDAdTM7?=
 =?us-ascii?Q?SmUDpWPM/R44IhKEt+dLIICtfcKDfDg3sqQkki7LvL0GL9krtLjEiPkv7vHD?=
 =?us-ascii?Q?ZRbxyWdZiNkNRseL3OnJdLJ2cGk1mn1keThI0Wn7giCRQZr5q6SDeLPutOeg?=
 =?us-ascii?Q?/2mxXSwXK9Rt3l3g+nVoIq6Z6yOBudjdicI89a0iiZ10h8AlCfna8Z9d5N1a?=
 =?us-ascii?Q?FNt8BPwdo39TMUm2GuG6rQpfqvgJaD5F2l5k38tIsIL6SweMjsXXxL9AZIzO?=
 =?us-ascii?Q?qJSbmTBxgGOyo6x8rfj1gYEoUp9v/weI9S7tvZ/EKXmwIxMNzYzevD/7+Le5?=
 =?us-ascii?Q?ZPxnPZhhvccLf4UCdoXySmYNntaV3RaLv8yARJ/HVGKb7v/gX2rJ0Wwta6bs?=
 =?us-ascii?Q?QMPpJLc7J+KMfY5Y4cEcaLTZGhtwpOJ+wdEWLrtLQBqFuTgp3SSJhkP6NilO?=
 =?us-ascii?Q?Rds5hgzZjOFPRJkjVPcUSz+cRnihkFjFsGSEHqug90WMmWMQtNUpRevBrmpY?=
 =?us-ascii?Q?MWx6YTZYa3M+xLx69EYIq+9CWRuLzpBlulB759druNs0RJxmszHtQIVH1EdW?=
 =?us-ascii?Q?txbK2erAHG30sqLwzIyOOZIOr++9WXpPEjMTO2LfwX0NwzV2i6WMtRlVKNqC?=
 =?us-ascii?Q?IETJZRlOvEXa7SuRJ0ItEcnwLvKhdALmU18LptI+0EOVDJmmx3Q+HNOitk9I?=
 =?us-ascii?Q?RWIleR4ATiCRp7PMi93PT+00FGo+k89AfV49rkF36G1PD37NtOLWkXTe8hpj?=
 =?us-ascii?Q?i8kupvSYF9NXYCXohYwLWuCiV8WzWZECudDrsYrwaYFEPrl1cKWanCsR7CPJ?=
 =?us-ascii?Q?Q7tvXiDUZ7uprdFnc6d+yR9q5vPiejSp6hLVAFt8ej3snBlLV6ESCqqPuzRr?=
 =?us-ascii?Q?s4J9a7v9ebwXncNKKYv5oWXie085LVGta3mT+dh/A7Rc5S7GdXNHFiFGaAfi?=
 =?us-ascii?Q?k95citNq7JlgmDTha+IYnz5dRB92EcoI?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2024 06:05:23.4701
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9280c4e8-defd-48cd-2b0e-08dcd15e8f08
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075ED.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8459

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
index f7623fa64307..9102f7e39c52 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -5070,7 +5070,10 @@ static bool __sev_snp_inject(enum inject_type type, struct kvm_vcpu *vcpu)
 	if (!hvdb)
 		return false;
 
-	hvdb->events.vector = vcpu->arch.interrupt.nr;
+	if (type == INJECT_NMI)
+		hvdb->events.nmi = 1;
+	else
+		hvdb->events.vector = vcpu->arch.interrupt.nr;
 
 	prepare_hv_injection(svm, hvdb);
 
@@ -5148,10 +5151,17 @@ void sev_snp_cancel_injection(struct kvm_vcpu *vcpu)
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
@@ -5169,8 +5179,11 @@ bool sev_snp_blocked(enum inject_type type, struct kvm_vcpu *vcpu)
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


