Return-Path: <kvm+bounces-58461-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 85A6EB94497
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 07:07:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4113F3A5A30
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 05:07:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9E3230E825;
	Tue, 23 Sep 2025 05:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Ykt2bH8I"
X-Original-To: kvm@vger.kernel.org
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013017.outbound.protection.outlook.com [40.93.196.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AFB12E92B7;
	Tue, 23 Sep 2025 05:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758604004; cv=fail; b=dMkm4CxtWC3BRhrXu4NM1ZGQ+oMCJEziB8sqHDoWyuYwdleJDjq1IQD/wHoLv2Z+dYgXiK138FKgl6Ixu/9VTkBUGfY57tPfvPpqQVwyJJndoy/2oDVM5z75MACirNsTTHop3QPmxDH/WCmqdIoKDhbaUQq7OciCe7r5A30oa60=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758604004; c=relaxed/simple;
	bh=TeWPuk0TUJut70gAkOurJIzmitTXMMGLc05Z+yGtsW0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VvNwsmUqx/TUNXGxSmg83egwO+l0+X/KgCZHKj/1BFc+KFIgqpKtrQ1ticIwVqleoQkCGF4gLMQVMwc7AhotRY4rfAdCi5Y6qKT0aK8PyvDFaCoYOv9vVz9sCO0hs9EoguJtTVz5ApNvvi53ZXG5qemc2pv4zZjU3FiT26tWanQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Ykt2bH8I; arc=fail smtp.client-ip=40.93.196.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dTZAtfaQ5yq9lCg/qbwYwxDa/VDcmtBYPYejdnH3ozD9/hTsxprxWkmCd1VE2eJwwOoCFPUcO45A6K1rYebt5mi8B2r/UIm4RLDmRqVFXDp4h8HCovWlC6H3HigQx1xpatl4+5JEaKa4ptmvtrxe+b0qoxwxL8jRDUk73LSBB1njnU8YkuMB6rnOffdKSmzVAlvqNFIIwkj5AiOlohzoFyK2ktbmBvME4N30QwToodB6Iy8SVoX09vQvrg2z3rYzRfLKds76C14dh+U0+e7MGZNsOl84j246pDszCxYNo0Xw5A0wKVrnjyonvmqywwxudIMJ/y1dAzGtk5DLHr4OkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FIYbWGfhksNgEuvETdaP1VgCmzc8I+cAQqfxmFT1HoQ=;
 b=vQIacIotWFVxFJR/WdK9D+kBFFzc9GDprK/9HxqXzll2xI3z/RfpmHQR0Y9tVoJndGl+JzDOmriTxInC5HOYlfUFLWMW3FLTz5hAPsZfu/YVRNkpz8mL12gNij3i+Veawxl1VMjGF3pth2GnyGInAbEqSEC5l968xkcW2C7GaxPJ+MTrBynuIoAUl5wUWaSvQBlC9ipatP71xCgoLJZcZnuwuB/WCOL/hXzLrLTe7KAHclx2NtrJtCTj07fqhQAeLLdyKy8wRNDcEtpqXWMatYH2FLmE79DWVrZsvl3I8HFouB4SAJxRpZtq1rDFxpNggOlSP78leRNBknO7jQV3pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FIYbWGfhksNgEuvETdaP1VgCmzc8I+cAQqfxmFT1HoQ=;
 b=Ykt2bH8I7PXKHBKcUehqoy/ihVI67jpXfTqxLiUoUTSJOtTaOqGqg05CacsWrK2SogfJJ5CZDWY2UbR5KbfACTvCaB2wvcKyG216RvilL6LF1I63bzwfY+vAAevfzw57ecuHJ1sYKCXLYQllbH9dYmTr0oO0iC0M3OyGzBEbBZY=
Received: from SJ0P220CA0010.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:41b::14)
 by DM3PR12MB9434.namprd12.prod.outlook.com (2603:10b6:0:4b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.20; Tue, 23 Sep
 2025 05:06:37 +0000
Received: from MWH0EPF000971E9.namprd02.prod.outlook.com
 (2603:10b6:a03:41b:cafe::fb) by SJ0P220CA0010.outlook.office365.com
 (2603:10b6:a03:41b::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.20 via Frontend Transport; Tue,
 23 Sep 2025 05:06:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MWH0EPF000971E9.mail.protection.outlook.com (10.167.243.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.12 via Frontend Transport; Tue, 23 Sep 2025 05:06:36 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 satlexmb07.amd.com (10.181.42.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 22 Sep 2025 22:06:32 -0700
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <kvm@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <Thomas.Lendacky@amd.com>,
	<nikunj@amd.com>, <Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <bp@alien8.de>, <David.Kaplan@amd.com>,
	<huibo.wang@amd.com>, <naveen.rao@amd.com>, <tiala@microsoft.com>
Subject: [RFC PATCH v2 11/17] KVM: SVM: Enable NMI support for Secure AVIC guests
Date: Tue, 23 Sep 2025 10:33:11 +0530
Message-ID: <20250923050317.205482-12-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E9:EE_|DM3PR12MB9434:EE_
X-MS-Office365-Filtering-Correlation-Id: e59d6341-6f80-4958-46b5-08ddfa5ef92d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IUsyz/KaMuiWZiT+e0ylMVBFSWXRGTkcaoKMw4QIOm9dnX6tiNClzV5wPkkv?=
 =?us-ascii?Q?Mfuppcr4LWlrzjo88iY8fMujUvyBTTJOSvl/Ye74rc6cQUa14L4aalJrZf/P?=
 =?us-ascii?Q?c1lsFhtq3stBhFgCyFq7nwpgCIwmZvehBHcyLci/HkRXSotHF2IrjUnA2JOq?=
 =?us-ascii?Q?DVvegFSNjkKYiQU2Q4u+5HLIKYp6eTW3D5qYdPENKfsM4m2aSzOR4u1OFiL/?=
 =?us-ascii?Q?JDpz5ROS7lDtUVhx79jNOjp2TcgsYFvftCCRhFucaY580kueIu5qNG07mn8l?=
 =?us-ascii?Q?1OR67qLxhT3hx0Jer2pgUFwxlutwAceRKPY9bK+jhbRLgHD7Ws7xFF82KOQu?=
 =?us-ascii?Q?0ZL2KH2yt2agSa66K77BrN/UQETftA30ZqpJ70K/XtVKoAKuwkVWQiuugrc0?=
 =?us-ascii?Q?ksOzugZu/DC8JrNnHJIJDuNkAcP4JRYDrDmOjJp8W/ygtccnwQa8SC26HgCw?=
 =?us-ascii?Q?RaVC8m/ZwcJY8CLIo6AftOiLF0UX1vRV1vf/rODYYWBW4O9gJSUAvDBkDaLz?=
 =?us-ascii?Q?vRYgC1LRZOjm2RZ1X2342H1DrRMOFbtMYroErR/c3z/oORFBK2TI4NmG+Oxq?=
 =?us-ascii?Q?TTWLXJXkp4+Dh8mv2O0uVoyhry+cqjtG/v3vX59Z2cCrtxO5JVLBvwafceiF?=
 =?us-ascii?Q?+eFJS9YWiR/yUlaBellg44Wv6sGt6Pa9oxwXYh4RXXDlun/IuuSAkpvdgaDb?=
 =?us-ascii?Q?3GcmHiarwedtJbyWI+T0Gri/h1rLSTmyRIECBXVphID9v6OkyMPHd9dAFB32?=
 =?us-ascii?Q?sbO8DclFtRzjq0+Mm7Km0SLrJz9u0w/UIpG9FoPKkJNMM7NLcbpHLvaSFOSA?=
 =?us-ascii?Q?CcejNDoWtyBWZN0o2/Nb7LFr38X9ll4uxryHJRWYmb3s0JHTUtLC78bwl0Ni?=
 =?us-ascii?Q?ruwyj8WDNkk/vMnqrF4EO+7+5KbcEJp5hrX6Fm1SZdzoNjX9gUDTiLUm4UWK?=
 =?us-ascii?Q?oPEcPjbGiQiFNJeea4NGbmeD/MI8Zdxvo929KsDic94QGT/Zf6IemfKou1Lp?=
 =?us-ascii?Q?nR05iIqBM1Oy+4x/aH+4Opv4IQdToJBOICuUtGH872DyYP8kT10mLHUSrsAC?=
 =?us-ascii?Q?VTxBOVMGYHGBLy567rbxg9lx3C3+TkDWNFZH9Io6sPXg80QOTzArCIY3dIwF?=
 =?us-ascii?Q?qYB7AHJpn8wVt8/+q8yX2ih21+1MygbgOc+S3808Jqay1NULLANGDlUoIDHO?=
 =?us-ascii?Q?eW4hEZEy9gFoLznRZ6S8PKL7yAQv4qHZ/emEtBkGFNBORrHl+gGqfaihmR1a?=
 =?us-ascii?Q?KPwKNIKXql67NYy6lQyeYM13HVfJhh0H9+Qyq6t65pt+oMvf/OPuZy7+KyDs?=
 =?us-ascii?Q?+MSPNikxLWD3FBSPdrS4JxdSe7Qr1uinavpAqiSplLMgL0PxsNANYUjjc4aC?=
 =?us-ascii?Q?mAaMaeAbENrdMda1pkq56QoOSp6OhmbrGQUvo1aRSxH2mk4Xfb/aLn1FanvF?=
 =?us-ascii?Q?pcYMgyoZXUZaLtY/dQaKuchvOqzuyNjftSRV7ea665nIPKl5ACubS6npa7qd?=
 =?us-ascii?Q?Eim48TNeJUZqkyrmFWpOSVFOKjFXYmn9fvTf?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 05:06:36.9475
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e59d6341-6f80-4958-46b5-08ddfa5ef92d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E9.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9434

The Secure AVIC hardware introduces a new model for handling Non-Maskable
Interrupts (NMIs). This model differs significantly from standard SVM, as
guest NMI state is managed by the hardware and is not visible to KVM.

Consequently, KVM can no longer use the generic EVENT_INJ mechanism and
must not track NMI masking state in software. Instead, it must adopt the
vNMI (Virtual NMI) flow, which is the only mechanism supported by
Secure AVIC.

Enable NMI support by making three key changes:

1.  Enable NMI in VMSA: Set the V_NMI_ENABLE_MASK bit in the VMSA's
    vintr_ctr field. This is a hardware prerequisite to enable the
    vNMI feature for the guest.

2.  Use vNMI for Injection: Modify svm_inject_nmi() to use the vNMI
    flow for Secure AVIC guests. When an NMI is requested, set the
    V_NMI_PENDING_MASK in the VMCB instead of using EVENT_INJ.

3.  Update NMI Windowing: Modify svm_nmi_allowed() to reflect that
    hardware now manages NMI blocking. KVM's only responsibility is to
    avoid queuing a new vNMI if one is already pending. The check is
    now simplified to whether V_NMI_PENDING_MASK is already set.

Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
 arch/x86/kvm/svm/sev.c |  2 +-
 arch/x86/kvm/svm/svm.c | 56 ++++++++++++++++++++++++++----------------
 2 files changed, 36 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 2dee210efb37..7c66aefe428a 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -885,7 +885,7 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 	save->sev_features = sev->vmsa_features;
 
 	if (sev_savic_active(vcpu->kvm))
-		save->vintr_ctrl |= V_GIF_MASK;
+		save->vintr_ctrl |= V_GIF_MASK | V_NMI_ENABLE_MASK;
 
 	/*
 	 * Skip FPU and AVX setup with KVM_SEV_ES_INIT to avoid
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index fdd612c975ae..a945bc094c1a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3635,27 +3635,6 @@ static int pre_svm_run(struct kvm_vcpu *vcpu)
 	return 0;
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
@@ -3689,6 +3668,33 @@ static bool svm_set_vnmi_pending(struct kvm_vcpu *vcpu)
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
@@ -3836,6 +3842,14 @@ bool svm_nmi_blocked(struct kvm_vcpu *vcpu)
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


