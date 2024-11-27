Return-Path: <kvm+bounces-32614-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C68769DAF67
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 23:57:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6A7D61658AF
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 22:57:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF10A204088;
	Wed, 27 Nov 2024 22:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="emx8wPen"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2052.outbound.protection.outlook.com [40.107.95.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A79B203700;
	Wed, 27 Nov 2024 22:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732748270; cv=fail; b=d4C3GYLXT1LsC8qeybOPbHyjFD120MmOLfrdh1bgMmWywU9n9XMCShvO4fMGlg10RuERWyaAGAXIgkC7Vs19guxr3Z251LCx8fulSYEYwzRUKHogRx0ZY//wMp7zeQs2OUEGUZ18BDU6mP2j1XkwDRTmYtI46u47Ac8PY1H9Tg0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732748270; c=relaxed/simple;
	bh=Y/9eQjOU5dMKQ7vZmXycvpKETvdAx/g//U2KNfpXaI0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uQYgWCAWxoJSwuZjoyNtGrMWjwrNXnZYwhSykuPNIl06tSwYNa5JyjEiK8MEreSuwTC/l5FCL6UqAFmo3NQ7Z4pEYlrNYhmshAmNluJJ546YsamOV1fUEevkfQi/0UjAZIb74sLTfQEpTsWcvCcyrI3grUOMj2K1DYOWh3pWums=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=emx8wPen; arc=fail smtp.client-ip=40.107.95.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S0fOnxFoB+dIyNl7bMuhKoZ5yzJo4QQqq0FSdkTO74PSvVQGtfR+ys/8dcEOcIMiW7mh5m3J29y55L0KQOBIGXRSHc4K8Bgu/HoEZGScq3Aj6aPkWDIunxGNw/pfRJbcq6NR0xFNYGPtFLoaba0LFv8Gbay8fQq7/cLBaZN5WvmpZY4eN4x9kNEaMfS3UWsI9HQrV+zUHz5Scp7vLIjLYjW3vKCHooXc3axAxKWMsbcxo95iYmtGHQvQ7Fq90Fs8EAByILfRub8HIo0zJVp6wuXnBpy0T40cS8pegEazYT5I5ATQvP8BqwDfHFtIbksN1Hw/rbteT1hAD4pe24UkcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g8YuRrwVkvuTsVH22qQw+nA2hfm2QMcLjWyNqIGXfyM=;
 b=FPrW8gj5rCch9Df2Q6R3WfzRjyYafR2iLYKIxZyAL+doDDj8qepMJqQ9tSkH934mS9H6w6Nmd2eSmMk5IQHZU/g4KZRnA+GxAIXqY9Mb8QCzrPJyn6cxJiWVfzemxNdaPkj7Gb0b65VjnBwIfHyG41MHM/jWfe6nXGzmVBj+PSQ2AILQneN6+dSVrD+Gb9cRn802qWZtd0M69X0ruNI8z8Fmk1oUV0IFE/uSh/Ym4Nhl5tOXSR3HbJ2G0raio3MFTgGXn9qvwW9kbWFleax1X+R3YuJNKpf3HlPoXDUkn1UlUhMddTH6iCc4D1CxOR94UhBjUlKhQ3HUzwEkvrxpmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g8YuRrwVkvuTsVH22qQw+nA2hfm2QMcLjWyNqIGXfyM=;
 b=emx8wPen/vXeNyzC65MGf2XEA5VVuarTIWTpXNLOjzpEeiP0HWpY20o6DLh4505/ig8y9yE+Ikj4WOEwvcYFYUT5KcSSvrpv5ne5cGNaMH9+maCEY2qhj6oCHtVvv8BkxqX7vFyjFp00LhNUl4bgkGxrgia/UziCMtK4Flwok0c=
Received: from BN9P223CA0012.NAMP223.PROD.OUTLOOK.COM (2603:10b6:408:10b::17)
 by SA3PR12MB7784.namprd12.prod.outlook.com (2603:10b6:806:317::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.13; Wed, 27 Nov
 2024 22:57:44 +0000
Received: from BN2PEPF000055DD.namprd21.prod.outlook.com
 (2603:10b6:408:10b:cafe::10) by BN9P223CA0012.outlook.office365.com
 (2603:10b6:408:10b::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8182.20 via Frontend Transport; Wed,
 27 Nov 2024 22:57:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF000055DD.mail.protection.outlook.com (10.167.245.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8230.0 via Frontend Transport; Wed, 27 Nov 2024 22:57:43 +0000
Received: from ruby-9130host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 27 Nov
 2024 16:57:42 -0600
From: Melody Wang <huibo.wang@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Tom Lendacky <thomas.lendacky@amd.com>, "Neeraj
 Upadhyay" <neeraj.upadhyay@amd.com>, Ashish Kalra <ashish.kalra@amd.com>,
	Michael Roth <michael.roth@amd.com>, Pankaj Gupta <pankaj.gupta@amd.com>,
	Melody Wang <huibo.wang@amd.com>
Subject: [PATCH v3 4/7] KVM: SVM: Inject NMIs when restricted injection is active
Date: Wed, 27 Nov 2024 22:55:36 +0000
Message-ID: <20241127225539.5567-5-huibo.wang@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000055DD:EE_|SA3PR12MB7784:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ae5c23b-3747-433a-1026-08dd0f36e74d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ev6Bhqqia2JYE2yjtKuh7FmXAX0Visss5D/GTX+MXBW5yM+lbJnZa7sBUose?=
 =?us-ascii?Q?8561TLDC/BukK5RyOt3Oa+KAXRNpVqYZx2IptiWB9Iu/8iC6ZKn5oY4SKTLH?=
 =?us-ascii?Q?9lNAp00yQP9Fz4WrAT8o/n+w6VimNyxHZsRzNPtv0JktLGiC6lOWWpswoxIT?=
 =?us-ascii?Q?Qd1WiOrr38TaZoqRSDWsfZhjAbHSqfWc7V+n4/OpoEpUBUbj/yYs19lNBEts?=
 =?us-ascii?Q?4s5nVBbAkntU7n6H5J5Mc9weOPiuX5y1RHYbYOy5sHyf/6zN6rqZkCmbFYlZ?=
 =?us-ascii?Q?mwWmhQGsMMZa4PDaqg0+GoChhxFvJ+iYPKANNATWp4itu7oGAO/uavFaSxgs?=
 =?us-ascii?Q?JOOuaWtEs82XzK+5vnU9SjcI6tiIk31+YqT06MavGDOhh3a6m3Z4RNkrI1q+?=
 =?us-ascii?Q?NZ2ZpIDAAj4o8btqBd/3bjZWawf4YTg8aBcYqoyYnjXhBOKI5v4/Ui5wMmHa?=
 =?us-ascii?Q?RiC1wE7FJNzoedvfgG6aQaDHlN5VKUejowxRevGgz1wSo3P5MHIAJWgHUfAC?=
 =?us-ascii?Q?cKGMqWQW3YdL/My+FGApII/h/Yr19ApEB8/RhJtfZMvGllSsYq4AGz7vxi/9?=
 =?us-ascii?Q?xP4mxZa7Vn/1700gdi6dy+82Ws4ikNTpdefTnBatiS7/IsEloheEcj6DRFAZ?=
 =?us-ascii?Q?4AZIzSpZG+oRS/dOaYoImP9YT4YlUyejxfqortzAtdTLDJBg4FHEtkpWOm5f?=
 =?us-ascii?Q?LA69dnEuJG8GHqYUbJil2tFDNBefO8TvtklaxUlMktItqMuI/Xk1qcpm4LOr?=
 =?us-ascii?Q?WZTLzBD2Tdf/P20TI8YmVy3fopwGTLbFQiQYORRnUefVxNXxp2Zz26J+Hgzs?=
 =?us-ascii?Q?gOos6NxO72eaYeba4AgWjdxIZIYzxcy4cH/cJBuBzTH5Kw2stwfnIsHmoesr?=
 =?us-ascii?Q?9UnJgukWXoWXGcRDVAX8KBiztjLoLBlVvLt9RmTO7+pHl1gy1TOBXhysKiPn?=
 =?us-ascii?Q?jElOOz821nGPll+q5yWJaqwIzKx4aqf+DhwNU2KnScEkjh9uEW8Z1ZRDsfB6?=
 =?us-ascii?Q?Tetkw/fTpxWmYSX2EMfaWnldXMoqrXjn3IW0rO8BrF1n8LY9CNdXB6nApVJ1?=
 =?us-ascii?Q?wg1n0AhTraNnaLozMvdFcCwDO1mvBVojdlOAnSv+Nnqwz9+vCpryE3zWzP6H?=
 =?us-ascii?Q?+cM/fGFPioBZXdDT52IqgFwHL7/plcAq648QEhRZ1J3UGhV2vPyVTgLuYMHU?=
 =?us-ascii?Q?sIpyl63QMY8UlmkEYmiz6fTFsRRko/l4obsoXyNDFQvgLj6DbVrLPYzJlqpA?=
 =?us-ascii?Q?clUI94mrMsroj080FJp6mwmIZpebsUwG2JXayy2EzPflXXIvw8oc377d4FHP?=
 =?us-ascii?Q?LMBaf7o07Ri6s5mRG0Mv/E07hN6+coudnp91Anb2omh9/lA9BT54rpKwORxK?=
 =?us-ascii?Q?NGAPGz5ZOb611L9G6laaUsS/WrNOnSDnOA06Rk+85t9lUcmR6IFMRRMmlE/U?=
 =?us-ascii?Q?Uia3NmXX4l4A5/Z95c4CVCwcLB8NoDIW?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2024 22:57:43.9091
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ae5c23b-3747-433a-1026-08dd0f36e74d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055DD.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7784

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
index 77dbc7dea974..00d1f620d14a 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -5077,7 +5077,10 @@ static void __sev_snp_inject(enum inject_type type, struct kvm_vcpu *vcpu)
 		return;
 	}
 
-	hvdb->events.vector = vcpu->arch.interrupt.nr;
+	if (type == INJECT_NMI)
+		hvdb->events.nmi = 1;
+	else
+		hvdb->events.vector = vcpu->arch.interrupt.nr;
 
 	prepare_hv_injection(svm, hvdb);
 
@@ -5157,10 +5160,17 @@ void sev_snp_cancel_injection(struct kvm_vcpu *vcpu)
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
@@ -5186,8 +5196,11 @@ bool sev_snp_blocked(enum inject_type type, struct kvm_vcpu *vcpu)
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
index 99f35a54b6ad..91bf17684bc8 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3616,6 +3616,9 @@ static void svm_inject_nmi(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	if (sev_snp_inject(INJECT_NMI, vcpu))
+		goto status;
+
 	svm->vmcb->control.event_inj = SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_NMI;
 
 	if (svm->nmi_l1_to_l2)
@@ -3630,6 +3633,8 @@ static void svm_inject_nmi(struct kvm_vcpu *vcpu)
 		svm->nmi_masked = true;
 		svm_set_iret_intercept(svm);
 	}
+
+status:
 	++vcpu->stat.nmi_injections;
 }
 
@@ -3800,6 +3805,9 @@ bool svm_nmi_blocked(struct kvm_vcpu *vcpu)
 	if (!gif_set(svm))
 		return true;
 
+	if (sev_snp_is_rinj_active(vcpu))
+		return sev_snp_blocked(INJECT_NMI, vcpu);
+
 	if (is_guest_mode(vcpu) && nested_exit_on_nmi(svm))
 		return false;
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 724e0b197b2c..b6e833f455ae 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -57,6 +57,7 @@ extern int lbrv;
 
 enum inject_type {
 	INJECT_IRQ,
+	INJECT_NMI,
 };
 
 /*
-- 
2.34.1


