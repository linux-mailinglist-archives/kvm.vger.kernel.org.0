Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87ADA2D6341
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 18:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404143AbgLJRQN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 12:16:13 -0500
Received: from mail-bn7nam10on2081.outbound.protection.outlook.com ([40.107.92.81]:2432
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404128AbgLJRP6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 12:15:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RXrBVS6RuvkmtxVN/Z8Ogs4s8n7Z0DnOWzTGEOy35vUz4/f9UPO47hZ1EJNr0YZ5K3mOKFGRGjSiRN05g1v423JpvjhRBCUerz8u9p4PnMNz6Jn0mUCltVujYQlfdsUMIWciquu7t40wqpF5LEogL8nHjZZC50UEcC7Lj63dmAuRjugI2NtwjoN7dWAz65aBKBT7nXXwOAh4BZYXq/hgXq2bzeZ+PVaNkUX+RuL//1rXenVHWXujtI088hSL6udGGaQChKYqGJhKJRC4qeSn59sYitGITNwXCR8bj4+xOpz9tN6kdpxTulTpT49Qc9E0GLJ6eRard8fE9/2FtLlVhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xXzQoFSOQMpQvKvzC90bc8sGkyAdEthpRNS3+UsXO60=;
 b=TG3nARHiJDKdjjZI7v0W3MciCqYpkLRFBJ4OF3YOgJQjKbKDiP93YUWiU809llVHNDIrJpzVz8qzY0kh2ln3+tU6L14TcSjexk525ydVv1Jr/yqAcn+cQQFBRm2DZ3sG9JjFpsZFkqeguJzi6zhWcHn9NRUr4zN4a5CZBorfS45eVTWot4Lz2AdXdxsN8KT20kUOMZGO0QsvHM27dazV0WbAzQAl83q2WeQmOcT1UcL0N3yHpoAEMZpoi22nvZBZOKTfISgAc/8d58DGH9r34r7a89bfArEyu4ZTXz3MOwd+8apozh1+WH3rYVWirNs0lQYCZhSJd7qGnP3ViFUFJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xXzQoFSOQMpQvKvzC90bc8sGkyAdEthpRNS3+UsXO60=;
 b=cuN3t8boccR3G9CZcKl1Kw2dCh08ez7aQhflWJqpgi4Cmk0fpyN7UvwSYMZFBSUjaLMkckgY0RWmI7Hh6UezPpistsN0UtfA/jbfg+ztv3lWMN/xCn+719P7tqsLe4tCOgSW0Zid2mE9T486YmaoBPBecmKY2JbxMlSuHYZ963w=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR12MB1350.namprd12.prod.outlook.com (2603:10b6:903:41::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.20; Thu, 10 Dec
 2020 17:14:31 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d%8]) with mapi id 15.20.3632.021; Thu, 10 Dec 2020
 17:14:31 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v5 28/34] KVM: SVM: Add NMI support for an SEV-ES guest
Date:   Thu, 10 Dec 2020 11:10:03 -0600
Message-Id: <5ea3dd69b8d4396cefdc9048ebc1ab7caa70a847.1607620209.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1607620209.git.thomas.lendacky@amd.com>
References: <cover.1607620209.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH2PR05CA0050.namprd05.prod.outlook.com
 (2603:10b6:610:38::27) To CY4PR12MB1352.namprd12.prod.outlook.com
 (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by CH2PR05CA0050.namprd05.prod.outlook.com (2603:10b6:610:38::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.7 via Frontend Transport; Thu, 10 Dec 2020 17:14:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 452879d0-2e22-4365-4fab-08d89d2f0f30
X-MS-TrafficTypeDiagnostic: CY4PR12MB1350:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB1350D164B3EF2E7C95CE92B6ECCB0@CY4PR12MB1350.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sGvzZ9MyI+Gje0mDEbSPqSKfCJujOY7X0rLrfSZ90DXcfgDgW25n3qlT30Ot2w+VoqBLgHj2rOhN41elpkIIT8nSSBGi9bDtMEd+dPmgLkCDULhMvxsKVP1kv8Prbs6gYE+Okk1V4E4gnqnx9+o7qau0J0wEj6u6h0Vm6qoNHEOPjKPKqTb3TloFUyQsgFdGTqrbzj4ejg8WC3TEEgzB4PX234O2PirQ2SPiMOokAmH8hFLG0lQK1W0maCWIUlkrAM8GejUetQcakM/LLFWo4hbwGHIb5PYGlwdkYGOzIyQJJRaqBCT3eqNKr6ZIQ8u7GTha0CLmMvA5OWOCR55Si/Hwg/xNEL3mWgx8egRkJ3Qk5k20nD7eG9FuVOmAMS9Y
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(346002)(136003)(6486002)(8936002)(16526019)(2906002)(2616005)(54906003)(508600001)(86362001)(52116002)(66946007)(36756003)(6666004)(8676002)(7696005)(83380400001)(4326008)(34490700003)(956004)(26005)(66556008)(66476007)(7416002)(5660300002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?GUPnFtLU4n8Ucdxk/PoGg1tC3vhnEpUFVAurFGEIIQkuZO8j3GWKUV70quCp?=
 =?us-ascii?Q?BkVjiXSI2wSimwHXib+84vbzmZRi5w0akJ70LBGxtRj0tMm8sqdGuNiTN4NR?=
 =?us-ascii?Q?wdTECy0pwk+3VE/CMW7Q5lP58Q6DjNcofvdVKjbjqdnIlXwQ679LFJUfr9Dl?=
 =?us-ascii?Q?T5MB+61O+VVIfP8vFY1pbnOvxJNZEwIy+SoAk7YJPHoMMHMfskLfo8gYIMQ3?=
 =?us-ascii?Q?WChsqpP19ckH+bA2+R4MUmlWtlXAWkyAIq36wNB6mqo8X66qN7Qfn/BDbbU1?=
 =?us-ascii?Q?g4J6wnSYJMTr72WkbGytVfCd+/GqNythkTLO2cACXhE9LlgiyuwgZwtTTkCP?=
 =?us-ascii?Q?PXWQ1SDjBJppgOY6U59DXX564KA4wllPaZecSaRmU5tyRY7T9dUYYrxTpWGE?=
 =?us-ascii?Q?fISBAdVHGgtPlBa0XajSrtH8DEYhhh8OvXb91mvEflRE9NNno9n63c7rKoG/?=
 =?us-ascii?Q?gHM/r1ENuvOCGFzt61WoefpJ/K0DsMDVk3156RZk41aewDohAtyzJ+pKOOFr?=
 =?us-ascii?Q?wXIzxAx6OzUoC73X7L5/zAhTJ59RWCayiKAeb6NpFEnBCMmZWhiqARGucKeI?=
 =?us-ascii?Q?9/tGKdpq8ZRJA123Ll2PkltDe25T8sFWl0mjZR6c0LBGjoWk6rDIgJBMvfKX?=
 =?us-ascii?Q?tpY5ZOG/UHtKHjSa9Rxt6uljFb1ukxUjDC+4qmB75xWU76PRoH4kNxkMRoP+?=
 =?us-ascii?Q?lE3HuP6iKgutFGXjNIKq82BgtPZhMBWyFQGfa9sZcfYtsSftH8tL+KfN2bug?=
 =?us-ascii?Q?jhxXZAt0DBPYycjcubtTQU4T886n/Imejg4y0ujiRbxvhM5Mc3C66AcG72Wq?=
 =?us-ascii?Q?Ei04McG+q7OjyMAvmsP7RzmPALKgYlC8uGrsCuyvGnuWXmgl3e7pf0d0/RLk?=
 =?us-ascii?Q?xglyzu5jIb5XAki2+2/NTYqxyY4XobgFQTeksI3izcYy79v4Qhx8+3wQT7hR?=
 =?us-ascii?Q?l0zSN1wEReSsfPBdNO0rqOmsX34FD+37Kq+EUDCOedCUInjgFegc8CDkbCSK?=
 =?us-ascii?Q?J2b9?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2020 17:14:31.5214
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 452879d0-2e22-4365-4fab-08d89d2f0f30
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rgr14FFHzmMV0E8rlvpyEVgH5ouCT6E9wYZAcGfBEgVVkJl2MIM4gTE+Q6M6WjoBY3X4lVK8yzIIta1W1L0yJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1350
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

The GHCB specification defines how NMIs are to be handled for an SEV-ES
guest. To detect the completion of an NMI the hypervisor must not
intercept the IRET instruction (because a #VC while running the NMI will
issue an IRET) and, instead, must receive an NMI Complete exit event from
the guest.

Update the KVM support for detecting the completion of NMIs in the guest
to follow the GHCB specification. When an SEV-ES guest is active, the
IRET instruction will no longer be intercepted. Now, when the NMI Complete
exit event is received, the iret_interception() function will be called
to simulate the completion of the NMI.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/sev.c |  4 ++++
 arch/x86/kvm/svm/svm.c | 20 +++++++++++++-------
 2 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index b47285384b1f..486c5609fa25 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1451,6 +1451,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 		if (!ghcb_sw_scratch_is_valid(ghcb))
 			goto vmgexit_err;
 		break;
+	case SVM_VMGEXIT_NMI_COMPLETE:
 	case SVM_VMGEXIT_AP_HLT_LOOP:
 	case SVM_VMGEXIT_AP_JUMP_TABLE:
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
@@ -1774,6 +1775,9 @@ int sev_handle_vmgexit(struct vcpu_svm *svm)
 					    control->exit_info_2,
 					    svm->ghcb_sa);
 		break;
+	case SVM_VMGEXIT_NMI_COMPLETE:
+		ret = svm_invoke_exit_handler(svm, SVM_EXIT_IRET);
+		break;
 	case SVM_VMGEXIT_AP_HLT_LOOP:
 		svm->ap_hlt_loop = true;
 		ret = kvm_emulate_halt(&svm->vcpu);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 2dbc20701ef5..16746bc6a1fa 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2339,9 +2339,11 @@ static int cpuid_interception(struct vcpu_svm *svm)
 static int iret_interception(struct vcpu_svm *svm)
 {
 	++svm->vcpu.stat.nmi_window_exits;
-	svm_clr_intercept(svm, INTERCEPT_IRET);
 	svm->vcpu.arch.hflags |= HF_IRET_MASK;
-	svm->nmi_iret_rip = kvm_rip_read(&svm->vcpu);
+	if (!sev_es_guest(svm->vcpu.kvm)) {
+		svm_clr_intercept(svm, INTERCEPT_IRET);
+		svm->nmi_iret_rip = kvm_rip_read(&svm->vcpu);
+	}
 	kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
 	return 1;
 }
@@ -3358,7 +3360,8 @@ static void svm_inject_nmi(struct kvm_vcpu *vcpu)
 
 	svm->vmcb->control.event_inj = SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_NMI;
 	vcpu->arch.hflags |= HF_NMI_MASK;
-	svm_set_intercept(svm, INTERCEPT_IRET);
+	if (!sev_es_guest(svm->vcpu.kvm))
+		svm_set_intercept(svm, INTERCEPT_IRET);
 	++vcpu->stat.nmi_injections;
 }
 
@@ -3442,10 +3445,12 @@ static void svm_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
 
 	if (masked) {
 		svm->vcpu.arch.hflags |= HF_NMI_MASK;
-		svm_set_intercept(svm, INTERCEPT_IRET);
+		if (!sev_es_guest(svm->vcpu.kvm))
+			svm_set_intercept(svm, INTERCEPT_IRET);
 	} else {
 		svm->vcpu.arch.hflags &= ~HF_NMI_MASK;
-		svm_clr_intercept(svm, INTERCEPT_IRET);
+		if (!sev_es_guest(svm->vcpu.kvm))
+			svm_clr_intercept(svm, INTERCEPT_IRET);
 	}
 }
 
@@ -3623,8 +3628,9 @@ static void svm_complete_interrupts(struct vcpu_svm *svm)
 	 * If we've made progress since setting HF_IRET_MASK, we've
 	 * executed an IRET and can allow NMI injection.
 	 */
-	if ((svm->vcpu.arch.hflags & HF_IRET_MASK)
-	    && kvm_rip_read(&svm->vcpu) != svm->nmi_iret_rip) {
+	if ((svm->vcpu.arch.hflags & HF_IRET_MASK) &&
+	    (sev_es_guest(svm->vcpu.kvm) ||
+	     kvm_rip_read(&svm->vcpu) != svm->nmi_iret_rip)) {
 		svm->vcpu.arch.hflags &= ~(HF_NMI_MASK | HF_IRET_MASK);
 		kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
 	}
-- 
2.28.0

