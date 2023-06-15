Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 214BE730FA2
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 08:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244315AbjFOGr6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 02:47:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233683AbjFOGrV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 02:47:21 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2061.outbound.protection.outlook.com [40.107.237.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 621813586;
        Wed, 14 Jun 2023 23:45:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cFCt5uxmwH+hy/y4xDleHLM0bzCTP8pEcrXVhwt1v8dDueLDr3zHg1f6Cmm1yldOT1W98FCgRxgTCwRKCe3+0k+rVry+ce623zHuVvX8n0LVcuUSalZ+o1/i2beHRXj4S2cyglP/gc/Qqy4CbB3VWop1MyUQ+nNunrilosHYe6AWTlokeSsDGOVme3E4TBkKyjzs7oZMy9OWE59TI9TEOuLC0w84wWeeOj3W9oivbKBxo+DHasf/frhRPSWxpdmuPP4geRGCxHCFyE5X9ZH9jYHpJp5kYu65r5nPDeIsHoLGaLj9l67SX52dha6nlQ07tuzfheHFpnub4pmvPfPUag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i4zg+ofpMEtJgEGUq76EAOBBnknuQ1bMrmJV59o9070=;
 b=JSj59LnHbcYGeL5LMu7WiDJgI+kCDYpELWbjlW7oS1nrn30HVHCWbQVQvjzCrUgtXaUgDY+7FSp4G4yFY/LmfnNEI7c7eWsvFR/DHkPBFDUwsPOeCbJWr1cF78FIEhA26HBAur+hRelvAonCZAIi0aW/b7Dm2+q1n9yjgcAjC8vGS8kuMUPoQIbTuN5iw9K3TDPLHrbygchBM0KD2MEjFqu2hGy5mlmkPzb1NAMjn4n03lZwZJKDqCOgvZYLeGSk7Juv/CeyOAfLTh/123gqsNlSWPYHKn0NNr2YTAtQpqOQNHbiQjZE2zZRzsgrrbE6VgAaE1bgM7xCyJSi6XuObg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i4zg+ofpMEtJgEGUq76EAOBBnknuQ1bMrmJV59o9070=;
 b=xysldIrKj7FsYQ7dAb8oZwdpCo7GdwkCq65Y4R1HZc20AER73DWTRB0R+yOtze+I5P/mc7cJxYCxtuReTpWJbbKNtsZ8nYNJnp8rt5+9g48NZAldaTKQdBjqSeyIiW8i3dyI8sjEf7Psyi+gMAoJ97pc/VBRnxuODCHQaKGqT0A=
Received: from PH8PR07CA0009.namprd07.prod.outlook.com (2603:10b6:510:2cd::27)
 by BL1PR12MB5269.namprd12.prod.outlook.com (2603:10b6:208:30b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.25; Thu, 15 Jun
 2023 06:45:40 +0000
Received: from SN1PEPF000252A1.namprd05.prod.outlook.com
 (2603:10b6:510:2cd:cafe::69) by PH8PR07CA0009.outlook.office365.com
 (2603:10b6:510:2cd::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.25 via Frontend
 Transport; Thu, 15 Jun 2023 06:45:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF000252A1.mail.protection.outlook.com (10.167.242.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6500.27 via Frontend Transport; Thu, 15 Jun 2023 06:45:40 +0000
Received: from aiemdeew.1.ozlabs.ru (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Thu, 15 Jun
 2023 01:45:00 -0500
From:   Alexey Kardashevskiy <aik@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        "Alexey Kardashevskiy" <aik@amd.com>
Subject: [PATCH kernel 8/9] KVM: SVM: Don't defer NMI unblocking until next exit for SEV-ES guests
Date:   Thu, 15 Jun 2023 16:37:56 +1000
Message-ID: <20230615063757.3039121-9-aik@amd.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230615063757.3039121-1-aik@amd.com>
References: <20230615063757.3039121-1-aik@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000252A1:EE_|BL1PR12MB5269:EE_
X-MS-Office365-Filtering-Correlation-Id: d8b97acf-352a-407d-a2f2-08db6d6c223d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6GO6PmghcDAHvt2d1u+rUMziAVVinZUSNylMiQBlI8OEdMaeX6KpLoGQbR0+FmjaOBXrS2ffHGaiccsAt148cFgn8wwRSNqi90QlRUGrZ6np7mpBUlk04HIpUGcsSwDqTEVYImzSWdD71uCRIrJR6zn5/ca8JZwto43ont4a92yXfKhLWn+OaKmncgo4pY/7kA0LgnDVsPhHuFXxQNWfC1RbEftPmREfvpSYunJ753Qq8AiIm7rU3HbiEFj4z826WbOv8kgpesRLC6/NT58Mt/gKeneeyJO07oEzR5gywu4YrdC4m300DZufw97oD7KHtHw7eEOWGoxFe0BeBngFt3Bl5h75pvQEFmcIZjccZVrUy4V5QZYFD0dWOF+8CRxlSbzqy1tSbkHTXlvVz87T29Hw6N5LKwsDu0hBKZBM+EgosXplYHxBGh+gyyqWr0S280EqGDevvGIyuOtYk3H+ZTfppeh0PMSdQ0UIWYY+6Oeo6yWMlVc+Kt2k4xBfniuq9c30EPHSNvJTbLdfhHkH+4JQNtCjt3bN8IqhW7CT4tvX9slxwPRoBvE4xvJsAxTr9vEOMf7LWUmrnjbOHt7JT2cNGb0/97fWCpLoO6jDL1XfqNSku+/wdPniGnyUEiu4k1v7k6NO3plY32Wt4rzDhHK3qEi0WkFC7pi0iOyfXyHf9o0ZQx0EbsnUOR6mLI2VZHVKDcox5irY6X86Il1zb0cSEL7q1ELvRIl0CcFAA12cJ9ftr8lHXmlTnSBgv9MD2lEk4miRikYjkBO5D784uA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(346002)(396003)(376002)(451199021)(36840700001)(46966006)(40470700004)(40460700003)(5660300002)(82740400003)(81166007)(356005)(336012)(2616005)(83380400001)(426003)(1076003)(186003)(16526019)(2906002)(26005)(36860700001)(47076005)(478600001)(40480700001)(6666004)(6916009)(70206006)(316002)(8936002)(8676002)(41300700001)(82310400005)(70586007)(36756003)(4326008)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 06:45:40.0792
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d8b97acf-352a-407d-a2f2-08db6d6c223d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1PEPF000252A1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5269
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Immediately mark NMIs as unmasked in response to #VMGEXIT(NMI complete)
instead of setting awaiting_iret_completion and waiting until the *next*
VM-Exit to unmask NMIs.  The whole point of "NMI complete" is that the
guest is responsible for telling the hypervisor when it's safe to inject
an NMI, i.e. there's no need to wait.  And because there's no IRET to
single-step, the next VM-Exit could be a long time coming, i.e. KVM could
incorrectly hold an NMI pending for far longer than what is required and
expected.

Opportunistically fix a stale reference to HF_IRET_MASK.

Fixes: 916b54a7688b ("KVM: x86: Move HF_NMI_MASK and HF_IRET_MASK into "struct vcpu_svm"")
Fixes: 4444dfe4050b ("KVM: SVM: Add NMI support for an SEV-ES guest")
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

May be 916b54a7688b is not really necessary to mention to avoid triggering
the stable kernel backporting bot?

---
Changes:
v6:
* new to the series
---
 arch/x86/kvm/svm/sev.c |  5 ++++-
 arch/x86/kvm/svm/svm.c | 10 +++++-----
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 9c43cbdab022..4a426feab1b8 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2897,7 +2897,10 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 					    svm->sev_es.ghcb_sa);
 		break;
 	case SVM_VMGEXIT_NMI_COMPLETE:
-		ret = svm_invoke_exit_handler(vcpu, SVM_EXIT_IRET);
+		++vcpu->stat.nmi_window_exits;
+		svm->nmi_masked = false;
+		kvm_make_request(KVM_REQ_EVENT, vcpu);
+		ret = 1;
 		break;
 	case SVM_VMGEXIT_AP_HLT_LOOP:
 		ret = kvm_emulate_ap_reset_hold(vcpu);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 1df99e9f8655..52f1d88e82a0 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2548,12 +2548,13 @@ static int iret_interception(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	WARN_ON_ONCE(sev_es_guest(vcpu->kvm));
+
 	++vcpu->stat.nmi_window_exits;
 	svm->awaiting_iret_completion = true;
 
 	svm_clr_iret_intercept(svm);
-	if (!sev_es_guest(vcpu->kvm))
-		svm->nmi_iret_rip = kvm_rip_read(vcpu);
+	svm->nmi_iret_rip = kvm_rip_read(vcpu);
 
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 	return 1;
@@ -3972,12 +3973,11 @@ static void svm_complete_interrupts(struct kvm_vcpu *vcpu)
 	svm->soft_int_injected = false;
 
 	/*
-	 * If we've made progress since setting HF_IRET_MASK, we've
+	 * If we've made progress since setting awaiting_iret_completion, we've
 	 * executed an IRET and can allow NMI injection.
 	 */
 	if (svm->awaiting_iret_completion &&
-	    (sev_es_guest(vcpu->kvm) ||
-	     kvm_rip_read(vcpu) != svm->nmi_iret_rip)) {
+	    kvm_rip_read(vcpu) != svm->nmi_iret_rip) {
 		svm->awaiting_iret_completion = false;
 		svm->nmi_masked = false;
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
-- 
2.40.1

