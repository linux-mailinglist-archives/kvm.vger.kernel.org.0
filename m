Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 977736A3D98
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 09:56:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbjB0I4h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 03:56:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230320AbjB0I4D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 03:56:03 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on20611.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8a::611])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0716B46C;
        Mon, 27 Feb 2023 00:47:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LKWqdnVAmHqV/niBcG+TsgwEn1A3bfRHmA1ijd/TyM4KMVSaCACayayWpnBanKiFlHm/gpPUFluk6NjcEgYUzio8ghNhPquQ1B4loONoaGE+pnaN/RqmfeVhWfpOpRvSjZ4nMB8vdZoxa9+PoZvLx0fMHRkvWVJKRFpxxE4A0Glv53WQJQlWCVPz9BYMKpRNXC9p9b9TzotLULcKcC6Z2wyRZjG2VswLKjpI+ZlBdMEXj/P4tBhKB3C3OVXl5Q8mzJBupJqB8mmGIAzwtO3r1yIDso59aZb0wosExhlJr0KRfHWtbDuf4Eqe5Jm7x7avYYsh8MevZYdqq+DbalfbBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LaKperpv4+VdYCfjXKCZB8VJU+3gIjLgyl6XPPUmZVc=;
 b=ew+ojDOmDXfzqs7XrZB8RToSxcIGs3C8jBIcdaRrekeXoAHtemuyWn3fPoRwRBJs0XnIdZMa2c9mfHuHsDkT5NM52fo/d85wrV0p97yAhdHo2x7mdIQH004iZekGUSOkMUW7EMX7BBqP1JIzS2dkcRYkC0+ZwdhJTnqd7zkkQ0FUIAGvo9RotwzvK75vLW687xG3g8yMcaDWJ1QdTeYIPfWqnUE7wU1ArJHdOy8kckO7ro+U/2EkPbcX4zdAEyxV34+HtwuocGOyHe5pcrMhf09RA3zA5gnNOxJF96PTgW1eIxPstZaiSV+YaM8VNzxTMFn2BWLcmF4w+3+PQWzqQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LaKperpv4+VdYCfjXKCZB8VJU+3gIjLgyl6XPPUmZVc=;
 b=nkAL0/izMsDVn477/1XctXTcUWZNV8S4jfhqnRShfymAnvEhkwoB/cJ12Ur3BsFy6jGAY4K93sgNrWv0sXdV6l2XRFaKOMkUipfLSzJSZtOadqhJj03UtcnqNlLjmUDM4Y/9FewiYBEUEZS5zTx8OcnOTR4GMKK2oKuFHH5lDfg=
Received: from BN8PR07CA0002.namprd07.prod.outlook.com (2603:10b6:408:ac::15)
 by CH3PR12MB7524.namprd12.prod.outlook.com (2603:10b6:610:146::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.29; Mon, 27 Feb
 2023 08:44:35 +0000
Received: from BN8NAM11FT073.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ac:cafe::bc) by BN8PR07CA0002.outlook.office365.com
 (2603:10b6:408:ac::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.29 via Frontend
 Transport; Mon, 27 Feb 2023 08:44:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT073.mail.protection.outlook.com (10.13.177.231) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6156.12 via Frontend Transport; Mon, 27 Feb 2023 08:44:35 +0000
Received: from BLR-L-SASHUKLA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 27 Feb
 2023 02:44:30 -0600
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     <kvm@vger.kernel.org>, <seanjc@google.com>
CC:     <pbonzini@redhat.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <linux-kernel@vger.kernel.org>, <mail@maciej.szmigiero.name>,
        <mlevitsk@redhat.com>, <thomas.lendacky@amd.com>,
        <vkuznets@redhat.com>
Subject: [PATCHv4 10/11] KVM: x86: add support for delayed virtual NMI injection interface
Date:   Mon, 27 Feb 2023 14:10:15 +0530
Message-ID: <20230227084016.3368-11-santosh.shukla@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230227084016.3368-1-santosh.shukla@amd.com>
References: <20230227084016.3368-1-santosh.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT073:EE_|CH3PR12MB7524:EE_
X-MS-Office365-Filtering-Correlation-Id: d4f7ff13-1758-4259-bc83-08db189eda78
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CLy/Aqv8yVPtnCI7RB6OIwH9SjB652R5H+KHlP73AkMdtgDNCyf3PYx+f/nh+HpjLE+y1OEFNavbBxb+Tw56hp9h0dUWzvZRQOHXvC0g7jOuKXMHOBRSQosc53m59QQkD4y50TWMaVpugAAMf+rIRcmeVzc/byUyGv83394hCtU1gqbkGkf0cWiMKxb2N914SaYim/9H7g8oeQ5Zdx8mIaUUus1iB8NiePikarKwbeF1AxzXW79oKxa8sNWcyaMzPOXmRJu7Tc45M/6US2ZyR6bOwxLrTf0T0GTpR7DOW0L4khv1SKCWgnWfOAeWUgIw65NkwORGPQoQfl8E70rY/hMlD8afQLZohSOZhGCzt7fnjKgbq4/E4SFPVPxCKkHPfGUw/96xAZKUIxoJc/cxANkUSRX2/rRb4Dxuj2jENravMHWjoLndX/KxRHA7RgDnE0tHyJqkny18FUIPlKwDeqadJxuag3RZ9qYaQADhOAm8wtETmZ90b4Om/36pW4vIiZMi5Z+vcqXX5ABMbH0MD/1JGdc4U5YsxvJXCFkV9Y+0ZCqbAfLyXULkfbGjnVf14OMTem9z8t4/WY4mCuMekxWAm57EDb0Tz06XeqIWfd6/f8oI+SG6ibOoUEaltPot86ITHXT2DrMT3R8WClsOYkZQghlqX+QAfA1kZaTDnNtlaqh2YMlOqKgN6HzBVNB5TipJxbL7/8Rk+BFh6yoQ5TdmfzRGTuOUR93lfpwZ5Cs=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(346002)(136003)(39860400002)(451199018)(46966006)(36840700001)(40470700004)(26005)(186003)(16526019)(1076003)(6666004)(82310400005)(36860700001)(426003)(47076005)(83380400001)(356005)(40460700003)(86362001)(40480700001)(82740400003)(36756003)(81166007)(2616005)(336012)(41300700001)(70206006)(70586007)(4326008)(8676002)(44832011)(2906002)(8936002)(30864003)(5660300002)(966005)(7696005)(110136005)(316002)(54906003)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2023 08:44:35.1833
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d4f7ff13-1758-4259-bc83-08db189eda78
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT073.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7524
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introducing two new vendor callbacks so to support virtual NMI
injection example vNMI feature for SVM.

- kvm_x86_is_vnmi_pending()
- kvm_x86_set_vnmi_pending()

Using those callbacks the KVM can take advantage of the
hardware's accelerated delayed NMI delivery (currently vNMI on SVM).

Once NMI is set to pending via this interface, it is assumed that
the hardware will deliver the NMI on its own to the guest once
all the x86 conditions for the NMI delivery are met.

Note that the 'kvm_x86_set_vnmi_pending()' callback is allowed
to fail, in which case a normal NMI injection will be attempted
when NMI can be delivered (possibly by using a NMI window).

With vNMI that can happen either if vNMI is already pending or
if a nested guest is running.

When the vNMI injection fails due to the 'vNMI is already pending'
condition, the new NMI will be dropped unless the new NMI can be
injected immediately, so no NMI window will be requested.

Use '.kvm_x86_set_hw_nmi_pending' method to inject the
pending NMIs for AMD's VNMI feature.

Note that vNMI doesn't need nmi_window_existing feature to
pend the new virtual NMI and that KVM will now be able to
detect with flag (KVM_VCPUEVENT_VALID_NMI_PENDING) and pend
the new NMI by raising KVM_REQ_NMI event.

Signed-off-by: Santosh Shukla <Santosh.Shukla@amd.com>
Co-developed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
v3:
 - Fixed SOB
 - Merged V_NMI implementation with x86_ops delayed NMI
   API proposal for better readablity.
 - Added early WARN_ON for VNMI case in svm_enable_nmi_window.
 - Indentation and style fixes per v2 comment.
 - Removed `svm->nmi_masked` check from svm_enable_nmi_window
   and replaced with svm_get_nmi_mask().
 - Note that I am keeping kvm_get_total_nmi_pending() logic
   like v2.. since `events->nmi.pending` is u8 not a boolean.
https://lore.kernel.org/all/Y9mwz%2FG6+G8NSX3+@google.com/

 arch/x86/include/asm/kvm-x86-ops.h |   2 +
 arch/x86/include/asm/kvm_host.h    |  11 ++-
 arch/x86/kvm/svm/svm.c             | 113 +++++++++++++++++++++++------
 arch/x86/kvm/svm/svm.h             |  22 ++++++
 arch/x86/kvm/x86.c                 |  26 ++++++-
 5 files changed, 147 insertions(+), 27 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 8dc345cc6318..092ef2398857 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -68,6 +68,8 @@ KVM_X86_OP(get_interrupt_shadow)
 KVM_X86_OP(patch_hypercall)
 KVM_X86_OP(inject_irq)
 KVM_X86_OP(inject_nmi)
+KVM_X86_OP_OPTIONAL_RET0(is_vnmi_pending)
+KVM_X86_OP_OPTIONAL_RET0(set_vnmi_pending)
 KVM_X86_OP(inject_exception)
 KVM_X86_OP(cancel_injection)
 KVM_X86_OP(interrupt_allowed)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 792a6037047a..f8a44c6c8633 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -878,7 +878,11 @@ struct kvm_vcpu_arch {
 	u64 tsc_scaling_ratio; /* current scaling ratio */
 
 	atomic_t nmi_queued;  /* unprocessed asynchronous NMIs */
-	unsigned nmi_pending; /* NMI queued after currently running handler */
+	/*
+	 * NMI queued after currently running handler
+	 * (not including a hardware pending NMI (e.g vNMI))
+	 */
+	unsigned int nmi_pending;
 	bool nmi_injected;    /* Trying to inject an NMI this entry */
 	bool smi_pending;    /* SMI queued after currently running handler */
 	u8 handling_intr_from_guest;
@@ -1640,6 +1644,10 @@ struct kvm_x86_ops {
 	int (*nmi_allowed)(struct kvm_vcpu *vcpu, bool for_injection);
 	bool (*get_nmi_mask)(struct kvm_vcpu *vcpu);
 	void (*set_nmi_mask)(struct kvm_vcpu *vcpu, bool masked);
+	/* returns true, if a NMI is pending injection on hardware level (e.g vNMI) */
+	bool (*is_vnmi_pending)(struct kvm_vcpu *vcpu);
+	/* attempts make a NMI pending via hardware interface (e.g vNMI) */
+	bool (*set_vnmi_pending)(struct kvm_vcpu *vcpu);
 	void (*enable_nmi_window)(struct kvm_vcpu *vcpu);
 	void (*enable_irq_window)(struct kvm_vcpu *vcpu);
 	void (*update_cr8_intercept)(struct kvm_vcpu *vcpu, int tpr, int irr);
@@ -2004,6 +2012,7 @@ int kvm_pic_set_irq(struct kvm_pic *pic, int irq, int irq_source_id, int level);
 void kvm_pic_clear_all(struct kvm_pic *pic, int irq_source_id);
 
 void kvm_inject_nmi(struct kvm_vcpu *vcpu);
+int kvm_get_total_nmi_pending(struct kvm_vcpu *vcpu);
 
 void kvm_update_dr7(struct kvm_vcpu *vcpu);
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index da936723e8ca..84d9d2566629 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -230,6 +230,8 @@ module_param(dump_invalid_vmcb, bool, 0644);
 bool intercept_smi = true;
 module_param(intercept_smi, bool, 0444);
 
+bool vnmi = true;
+module_param(vnmi, bool, 0444);
 
 static bool svm_gp_erratum_intercept = true;
 
@@ -1311,6 +1313,9 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 	if (kvm_vcpu_apicv_active(vcpu))
 		avic_init_vmcb(svm, vmcb);
 
+	if (vnmi)
+		svm->vmcb->control.int_ctl |= V_NMI_ENABLE_MASK;
+
 	if (vgif) {
 		svm_clr_intercept(svm, INTERCEPT_STGI);
 		svm_clr_intercept(svm, INTERCEPT_CLGI);
@@ -3508,6 +3513,38 @@ static void svm_inject_nmi(struct kvm_vcpu *vcpu)
 	++vcpu->stat.nmi_injections;
 }
 
+static bool svm_is_vnmi_pending(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	if (!is_vnmi_enabled(svm))
+		return false;
+
+	return !!(svm->vmcb->control.int_ctl & V_NMI_BLOCKING_MASK);
+}
+
+static bool svm_set_vnmi_pending(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	if (!is_vnmi_enabled(svm))
+		return false;
+
+	if (svm->vmcb->control.int_ctl & V_NMI_PENDING_MASK)
+		return false;
+
+	svm->vmcb->control.int_ctl |= V_NMI_PENDING_MASK;
+	vmcb_mark_dirty(svm->vmcb, VMCB_INTR);
+
+	/*
+	 * NMI isn't yet technically injected but
+	 * this rough estimation should be good enough
+	 */
+	++vcpu->stat.nmi_injections;
+
+	return true;
+}
+
 static void svm_inject_irq(struct kvm_vcpu *vcpu, bool reinjected)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -3603,6 +3640,35 @@ static void svm_update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
 		svm_set_intercept(svm, INTERCEPT_CR8_WRITE);
 }
 
+static bool svm_get_nmi_mask(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	if (is_vnmi_enabled(svm))
+		return svm->vmcb->control.int_ctl & V_NMI_BLOCKING_MASK;
+	else
+		return svm->nmi_masked;
+}
+
+static void svm_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	if (is_vnmi_enabled(svm)) {
+		if (masked)
+			svm->vmcb->control.int_ctl |= V_NMI_BLOCKING_MASK;
+		else
+			svm->vmcb->control.int_ctl &= ~V_NMI_BLOCKING_MASK;
+
+	} else {
+		svm->nmi_masked = masked;
+		if (masked)
+			svm_set_iret_intercept(svm);
+		else
+			svm_clr_iret_intercept(svm);
+	}
+}
+
 bool svm_nmi_blocked(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -3614,8 +3680,10 @@ bool svm_nmi_blocked(struct kvm_vcpu *vcpu)
 	if (is_guest_mode(vcpu) && nested_exit_on_nmi(svm))
 		return false;
 
-	return (vmcb->control.int_state & SVM_INTERRUPT_SHADOW_MASK) ||
-	       svm->nmi_masked;
+	if (svm_get_nmi_mask(vcpu))
+		return true;
+
+	return vmcb->control.int_state & SVM_INTERRUPT_SHADOW_MASK;
 }
 
 static int svm_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
@@ -3633,24 +3701,6 @@ static int svm_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 	return 1;
 }
 
-static bool svm_get_nmi_mask(struct kvm_vcpu *vcpu)
-{
-	return to_svm(vcpu)->nmi_masked;
-}
-
-static void svm_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
-{
-	struct vcpu_svm *svm = to_svm(vcpu);
-
-	if (masked) {
-		svm->nmi_masked = true;
-		svm_set_iret_intercept(svm);
-	} else {
-		svm->nmi_masked = false;
-		svm_clr_iret_intercept(svm);
-	}
-}
-
 bool svm_interrupt_blocked(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -3731,7 +3781,14 @@ static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	if (svm->nmi_masked && !svm->awaiting_iret_completion)
+	/*
+	 * NMI window not needed with vNMI enabled
+	 * and if reached here then better WARN and
+	 * continue to single step.
+	 */
+	WARN_ON_ONCE(is_vnmi_enabled(svm));
+
+	if (svm_get_nmi_mask(vcpu) && !svm->awaiting_iret_completion)
 		return; /* IRET will cause a vm exit */
 
 	if (!gif_set(svm)) {
@@ -3745,8 +3802,8 @@ static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
 	 * problem (IRET or exception injection or interrupt shadow)
 	 */
 	svm->nmi_singlestep_guest_rflags = svm_get_rflags(vcpu);
-	svm->nmi_singlestep = true;
 	svm->vmcb->save.rflags |= (X86_EFLAGS_TF | X86_EFLAGS_RF);
+	svm->nmi_singlestep = true;
 }
 
 static void svm_flush_tlb_current(struct kvm_vcpu *vcpu)
@@ -4780,6 +4837,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.patch_hypercall = svm_patch_hypercall,
 	.inject_irq = svm_inject_irq,
 	.inject_nmi = svm_inject_nmi,
+	.is_vnmi_pending = svm_is_vnmi_pending,
+	.set_vnmi_pending = svm_set_vnmi_pending,
 	.inject_exception = svm_inject_exception,
 	.cancel_injection = svm_cancel_injection,
 	.interrupt_allowed = svm_interrupt_allowed,
@@ -5070,6 +5129,16 @@ static __init int svm_hardware_setup(void)
 			pr_info("Virtual GIF supported\n");
 	}
 
+	vnmi = vgif && vnmi && boot_cpu_has(X86_FEATURE_AMD_VNMI);
+	if (vnmi)
+		pr_info("Virtual NMI enabled\n");
+
+	if (!vnmi) {
+		svm_x86_ops.is_vnmi_pending = NULL;
+		svm_x86_ops.set_vnmi_pending = NULL;
+	}
+
+
 	if (lbrv) {
 		if (!boot_cpu_has(X86_FEATURE_LBRV))
 			lbrv = false;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 839809972da1..fb48c347bbe0 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -36,6 +36,7 @@ extern bool npt_enabled;
 extern int vgif;
 extern bool intercept_smi;
 extern bool x2avic_enabled;
+extern bool vnmi;
 
 /*
  * Clean bits in VMCB.
@@ -548,6 +549,27 @@ static inline bool is_x2apic_msrpm_offset(u32 offset)
 	       (msr < (APIC_BASE_MSR + 0x100));
 }
 
+static inline struct vmcb *get_vnmi_vmcb_l1(struct vcpu_svm *svm)
+{
+	if (!vnmi)
+		return NULL;
+
+	if (is_guest_mode(&svm->vcpu))
+		return NULL;
+	else
+		return svm->vmcb01.ptr;
+}
+
+static inline bool is_vnmi_enabled(struct vcpu_svm *svm)
+{
+	struct vmcb *vmcb = get_vnmi_vmcb_l1(svm);
+
+	if (vmcb)
+		return !!(vmcb->control.int_ctl & V_NMI_ENABLE_MASK);
+	else
+		return false;
+}
+
 /* svm.c */
 #define MSR_INVALID				0xffffffffU
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b22074f467e0..b5354249fe00 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5113,7 +5113,7 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
 	events->interrupt.shadow = static_call(kvm_x86_get_interrupt_shadow)(vcpu);
 
 	events->nmi.injected = vcpu->arch.nmi_injected;
-	events->nmi.pending = vcpu->arch.nmi_pending;
+	events->nmi.pending = kvm_get_total_nmi_pending(vcpu);
 	events->nmi.masked = static_call(kvm_x86_get_nmi_mask)(vcpu);
 
 	/* events->sipi_vector is never valid when reporting to user space */
@@ -5201,9 +5201,9 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
 
 	vcpu->arch.nmi_injected = events->nmi.injected;
 	if (events->flags & KVM_VCPUEVENT_VALID_NMI_PENDING) {
-		vcpu->arch.nmi_pending = events->nmi.pending;
-		if (vcpu->arch.nmi_pending)
-			kvm_make_request(KVM_REQ_NMI, vcpu);
+		vcpu->arch.nmi_pending = 0;
+		atomic_set(&vcpu->arch.nmi_queued, events->nmi.pending);
+		kvm_make_request(KVM_REQ_NMI, vcpu);
 	}
 	static_call(kvm_x86_set_nmi_mask)(vcpu, events->nmi.masked);
 
@@ -10156,13 +10156,31 @@ static void process_nmi(struct kvm_vcpu *vcpu)
 	else
 		limit = 2;
 
+	/*
+	 * Adjust the limit to account for pending virtual NMIs, which aren't
+	 * tracked in vcpu->arch.nmi_pending.
+	 */
+	if (static_call(kvm_x86_is_vnmi_pending)(vcpu))
+		limit--;
+
 	vcpu->arch.nmi_pending += atomic_xchg(&vcpu->arch.nmi_queued, 0);
 	vcpu->arch.nmi_pending = min(vcpu->arch.nmi_pending, limit);
 
+	if (vcpu->arch.nmi_pending &&
+	    (static_call(kvm_x86_set_vnmi_pending)(vcpu)))
+		vcpu->arch.nmi_pending--;
+
 	if (vcpu->arch.nmi_pending)
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
 }
 
+/* Return total number of NMIs pending injection to the VM */
+int kvm_get_total_nmi_pending(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.nmi_pending + static_call(kvm_x86_is_vnmi_pending)(vcpu);
+}
+
+
 void kvm_make_scan_ioapic_request_mask(struct kvm *kvm,
 				       unsigned long *vcpu_bitmap)
 {
-- 
2.25.1

