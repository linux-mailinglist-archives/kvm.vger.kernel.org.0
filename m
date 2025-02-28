Return-Path: <kvm+bounces-39678-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 675B5A49498
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 10:17:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9E2117A2F72
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 09:16:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EAA42566F1;
	Fri, 28 Feb 2025 09:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="1ZpJRbV5"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2053.outbound.protection.outlook.com [40.107.95.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB9812561B7;
	Fri, 28 Feb 2025 09:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740734224; cv=fail; b=rn4K5cK2oggqnzQm8Lm1WpfNb8nC6PhRPRNZRWNUQVmC7250xK2/aMcYCIQLHyUEyWcAW+Vve/UzmgMmdtr9rB+QY4DNQ4QnNmAkhWiA+w2BT7JD2HOx6Y8pZd8QRESB9xPSH21PfifaqYrLxXYYv1l3D4INkD8G0sZWvKNqbIA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740734224; c=relaxed/simple;
	bh=EfeGP2NKoP07mW5811JxqfTNfEDlTPYXh8Xpw9gm90U=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xnt68YwqeoUiUKllJHUErY7Hp4SUbg2Qz7QifKRi7eIZzliVEzcXbvF2Y5u8VX2VM2Daqx+cGMGWsMx8y0qY/p/G7OkjeJIf2RmEo8topWUS7967TFdG8BkpZSTYcdvYDOMeAEdDU4tbpKpY6ZnunfncxX5NrPkvyswubpFKfyk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=1ZpJRbV5; arc=fail smtp.client-ip=40.107.95.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w5Rznzo9kcrUqeA0Jo39ES2Zt/UiZEYOx6yq36iVRkhf9CuZfKTDMiJ7U/XvkqY8j+fpMD5Z4yxd8m0lPb2o3CxDPhS5BN+bLxA9pviqy72pQQhyClbY1ofrwVskUQGWXWCP/0RUuBdzVbr2SXIl6NAzfoUWRUfhCpkRb/lRC2bvGf5hh6VsGTptUzxnLBKNXlzNXk8c1nQQ0lQtx8+YEJ2PPjGhM7ZbCtr6+jlVQaIVtTp2I0N9f9e3lidjiVjUOmm1xMw4w2sgo/uSmjEl7qkEWDF/+gx6YmgrADSuqmFZ4Bluucntj6dQTcvZuBUlkgfFPuNfIQc4gCTXx1De4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LxkZxrYMaVXrGEGfXJAVue1rMTnE+YRD8CFORz1BnSo=;
 b=nESVjNytO4wknYFWE0ebW6Z4WQgcJBSjRIP+hlOrVtT1yG+g2o193oG1NouPO5zkSJ4VvlPu7bSiaFwMODL2KwsArkOhVUn7+mgmg8ImKkSsspXiq10FXouOZrVQDfPLajwFAIlJpBPMiRJhK8kDm5BAAV1XIkkr2fZpu0CMWenlkptwn6CylSp3HiszIMY4dl7XaxbTRIHhf7aN84UYyFLuCimP0rx/KhDOKBTSWjTcOQNi7vjyStf00nBNiUggOnq6nOcRxRwY/AxwFgRWAK9Dt0b6iJJJhvnBr3i63xfpOlLNWNvaXH1mDRbcLtZrtZpGWbzujgBfQcYfJ77lOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LxkZxrYMaVXrGEGfXJAVue1rMTnE+YRD8CFORz1BnSo=;
 b=1ZpJRbV5rBc3+73lMEFHxVL9mL/GCww6erkDAfUtnk6esfIpcSdb4fmR5rl6Qrfu4v2ftG04ZkHGM8lZVEdjBxerG59KRinZ4UMD5ElyrfGS7zk55YGEEWemIXDnFLIHDq/bttxXjsJW12AUzzR0u9BXnbb6zdMk0OSmU/FcanM=
Received: from MW3PR05CA0010.namprd05.prod.outlook.com (2603:10b6:303:2b::15)
 by LV8PR12MB9261.namprd12.prod.outlook.com (2603:10b6:408:1ed::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.18; Fri, 28 Feb
 2025 09:17:00 +0000
Received: from SJ1PEPF00002318.namprd03.prod.outlook.com
 (2603:10b6:303:2b:cafe::a4) by MW3PR05CA0010.outlook.office365.com
 (2603:10b6:303:2b::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8511.9 via Frontend Transport; Fri,
 28 Feb 2025 09:16:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00002318.mail.protection.outlook.com (10.167.242.228) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8489.16 via Frontend Transport; Fri, 28 Feb 2025 09:16:59 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 28 Feb
 2025 03:14:08 -0600
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <bp@alien8.de>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>,
	<nikunj@amd.com>, <Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <binbin.wu@linux.intel.com>, <isaku.yamahata@intel.com>
Subject: [RFC PATCH 13/19] KVM: SVM/SEV: Secure AVIC: Enable NMI support
Date: Fri, 28 Feb 2025 14:21:09 +0530
Message-ID: <20250228085115.105648-14-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002318:EE_|LV8PR12MB9261:EE_
X-MS-Office365-Filtering-Correlation-Id: 40364b00-90ba-4a4e-d8ec-08dd57d8a7fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?H52H6lmHYHN5ER9a7q+7Wx/76kTXBsZ6waTSqOLW63CC+Y6bWx0ryqOQ/ohb?=
 =?us-ascii?Q?h204eZpjT9MZPlS4FTgdAsKzauFpfxOn4MgTcaVdGa7BcNhK8WbIqL+pqLOH?=
 =?us-ascii?Q?m3sJKpF/Jsz+xkDAT8dGBZCJOZcdgAtk2xuQMU3feE5m1bjqrssFwARZ44pq?=
 =?us-ascii?Q?Qrb+UL2m64O7vQfZ2zg2NJP0mSlS2ub+kyD5gcoVC5u6S7itbmTCTG2tMpCK?=
 =?us-ascii?Q?tT0h3MdtPMqh7Os8pZgYU1yR9xDaGJ3RcJ1iIa8wQDvm6V1+w0wTIAxX9arl?=
 =?us-ascii?Q?7xty+dv8EQPVWKqZX8pUL78xw0/ee4JcbYOj+Pnc/WjnqVBXlS6NnDQ5ygMA?=
 =?us-ascii?Q?OIrC0pZEP3/6zOEZPFIb3otu8xOnlvPXf/r4nowyPS4v/w0y3XhBfIdY7z9x?=
 =?us-ascii?Q?u2E6JMxh9yy/wGrYp5AgYz4qdUaAJihcEqC8uq9R83Elrg/u3b/M31QSYeGI?=
 =?us-ascii?Q?9fJE4qVrJoOrM1RfKMGBHeCnaDm2an5AiUHougpemfauRfhqgH7SdchIwyvs?=
 =?us-ascii?Q?5xbEu/8jveGgR1+em8eqF6aM1ySuaKegG1hXi7x7osVJjrknRqkS29LKwYxZ?=
 =?us-ascii?Q?ssMMIzrEHhOyffJRwKqPytEHtq8F3fdLGVam955E+qIZnTcrHMLFNvPFLz/1?=
 =?us-ascii?Q?1pntHrT9kz91yiJijBHc93WdX54ZytF0Ohh94LMlCpu6Gvi+eeguMnDFJqzK?=
 =?us-ascii?Q?FIUo57TqgPXXbyj2P7sHXlA+8Pd4/DncMopQu4iXo3S2mtcg7RKRz3iKnS17?=
 =?us-ascii?Q?HHxrLWoOe5UlTnsFCPdMTqHETmwt6NyCKm2GxQSbs1q0cz+j4VB1TJK6XP/8?=
 =?us-ascii?Q?ehjtUzi31YUo7KPgo2Jf4ZQDI2k0hSslo/w8i+kkUya6/3Q1sW087uMCp2Fx?=
 =?us-ascii?Q?VNrYc1/tpf5Iq4XLmi4fI3p0AFLJQnPA0kmoijJiETFUNLNi1rgqO5/JM7qd?=
 =?us-ascii?Q?8BnhmQJiKxub6FVJW7pydZwszwXdxyR7GYF01ReHa3EmpBruRj31zskUDcy1?=
 =?us-ascii?Q?EtqhqlB0Obzkb1D2jNPfqcmRXgHbf08JD/Pvv9N29v3YNNL4aZyFhmWyv9m2?=
 =?us-ascii?Q?C73R4LvlTPghs6d/2yUWQXC1ciNjhtT4V5b8vRnzUy5idjWhWx36zFSqzh9r?=
 =?us-ascii?Q?SR0w0TF9OIot0sa5mTJg4GYVRu7cbwT71kf4IFmXFoahVXXzCnrQTb5asbkW?=
 =?us-ascii?Q?Tfu/+/xhYl4PLFyoC+yj32BGivF/hIVY/5QH7YIULGVZg86JppL/k3wJx5Nv?=
 =?us-ascii?Q?X+NCgme0yquznrAsSmxomVgM0nVTe7Id82sQq47q4Wo5B7mUUUyc4aF9fOj2?=
 =?us-ascii?Q?gSS5AkG9wNQD0dlLd+PBoaVJkx/m82G4zwwfOiwQTtrrwir1mFZ9mxbkmHBQ?=
 =?us-ascii?Q?3AvpbjiGBwzlMBQJR7dTjLfkcz8PxsoAcnN0QD0NrFmBVaYsCr3u85sPumph?=
 =?us-ascii?Q?hMxVs4FI6u6GoYsrlHRsaWgipdo/IpoLLJ15pjqSrJDTBDmSsc3e6iMn07oL?=
 =?us-ascii?Q?koftOCE2h2XEvQg=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2025 09:16:59.7546
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 40364b00-90ba-4a4e-d8ec-08dd57d8a7fa
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002318.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9261

From: Kishon Vijay Abraham I <kvijayab@amd.com>

Secure AVIC only allows vNMI flow for injecting NMI interrupts to the
guest. Also, Secure AVIC hardware manages NMI delivery to the guest and
can detect if the guest is in a state to accept NMI. So, update NMI
injection code flow for Secure AVIC to inject V_NMI and allow NMI
injection if there is no V_NMI pending. In addition, Secure AVIC
requires V_NMI_ENABLE in VINTR_CTRL field of VMSA to be set. Set
V_NMI_ENABLE in VINTR_CTRL field of VMSA.

Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Co-developed-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
 arch/x86/kvm/svm/sev.c |  2 +-
 arch/x86/kvm/svm/svm.c | 56 ++++++++++++++++++++++++++----------------
 2 files changed, 36 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 07a8a0c09382..40314c4086c2 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -855,7 +855,7 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 
 	save->sev_features = sev->vmsa_features;
 	if (sev_savic_active(vcpu->kvm))
-		save->vintr_ctrl |= V_GIF_MASK;
+		save->vintr_ctrl |= V_GIF_MASK | V_NMI_ENABLE_MASK;
 
 	/*
 	 * Skip FPU and AVX setup with KVM_SEV_ES_INIT to avoid
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 58733b63bcd7..08d5dc55e175 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3625,27 +3625,6 @@ static void pre_svm_run(struct kvm_vcpu *vcpu)
 		new_asid(svm, sd);
 }
 
-static void svm_inject_nmi(struct kvm_vcpu *vcpu)
-{
-	struct vcpu_svm *svm = to_svm(vcpu);
-
-	svm->vmcb->control.event_inj = SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_NMI;
-
-	if (svm->nmi_l1_to_l2)
-		return;
-
-	/*
-	 * No need to manually track NMI masking when vNMI is enabled, hardware
-	 * automatically sets V_NMI_BLOCKING_MASK as appropriate, including the
-	 * case where software directly injects an NMI.
-	 */
-	if (!is_vnmi_enabled(svm)) {
-		svm->nmi_masked = true;
-		svm_set_iret_intercept(svm);
-	}
-	++vcpu->stat.nmi_injections;
-}
-
 static bool svm_is_vnmi_pending(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -3679,6 +3658,33 @@ static bool svm_set_vnmi_pending(struct kvm_vcpu *vcpu)
 	return true;
 }
 
+static void svm_inject_nmi(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	if (sev_savic_active(vcpu->kvm)) {
+		svm_set_vnmi_pending(vcpu);
+		++vcpu->stat.nmi_injections;
+		return;
+	}
+
+	svm->vmcb->control.event_inj = SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_NMI;
+
+	if (svm->nmi_l1_to_l2)
+		return;
+
+	/*
+	 * No need to manually track NMI masking when vNMI is enabled, hardware
+	 * automatically sets V_NMI_BLOCKING_MASK as appropriate, including the
+	 * case where software directly injects an NMI.
+	 */
+	if (!is_vnmi_enabled(svm)) {
+		svm->nmi_masked = true;
+		svm_set_iret_intercept(svm);
+	}
+	++vcpu->stat.nmi_injections;
+}
+
 static void svm_inject_irq(struct kvm_vcpu *vcpu, bool reinjected)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -3826,6 +3832,14 @@ bool svm_nmi_blocked(struct kvm_vcpu *vcpu)
 static int svm_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
+
+	/* Secure AVIC only support V_NMI based NMI injection. */
+	if (sev_savic_active(vcpu->kvm)) {
+		if (svm->vmcb->control.int_ctl & V_NMI_PENDING_MASK)
+			return 0;
+		return 1;
+	}
+
 	if (svm->nested.nested_run_pending)
 		return -EBUSY;
 
-- 
2.34.1


