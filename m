Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 442F5231653
	for <lists+kvm@lfdr.de>; Wed, 29 Jul 2020 01:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730766AbgG1Xiq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 19:38:46 -0400
Received: from mail-bn7nam10on2084.outbound.protection.outlook.com ([40.107.92.84]:14177
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730203AbgG1Xio (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jul 2020 19:38:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cax/pvwQf/sxGD73o4moN9hvPA0V97SJkaYrrENbfPk5olG++UQO/A8iiHsdyreDYubRMSfD//H6Jc0m41u8fABF9bnhNChygBhpps9bDwIIfkxXXOmpY4WgsoOHhSBD10SlhDTRXrAet+Te0Z5u8MfmTKNSphvfiSphdMYdq13KFW5GIZXyCtGbrIkeSy+LQlH/NtHxPTPUys3+yqrhyzi27lKLCu1MWD3FKKo1DqP+TIK2CHBYp6DJTssJQFOjBOQlKLyaWKLn6f6ekAxZNKF3zEsHi4aAHuz5rxrKHxhY4MtMVs71Z9HQsh4xWs0a9fkA7dIbWK67mBV6cAj9BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/uMDb1cg7aOH3HdsCiMzYnxVqQigNFSY34Oj49xV4Gc=;
 b=j0kBWvFGzBX+HwATNZ0fJwzV63i1mLqqaaKxLY/+lo01pQ6cT5bwj7hl7RJus64RMhyLnZ/thyJd7wvFCK4BnDUj3ckBB8HVMX+AeFjslS+xX6dQqmCTFzk3mFeyCGLs5ARUcpS6bwVEXxE9JqjDkVvMNDtdtHT6UQqNuen3YiVjWduTUHThqMUsrjC9uEfe+c8ZgObQkspvFvO7Hot37SV/doH/l3g4D85B5YwkjN/tPTyksXgxBLhkIgNyg7xHtktw49EIkmWhdbmSKmJaweRW3+jyaKmXYeddtYg4w89dJmmFQq9CosU+fULPYv0fs+TGblLK2WVHgX0sHsQXFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/uMDb1cg7aOH3HdsCiMzYnxVqQigNFSY34Oj49xV4Gc=;
 b=YEtFUGzruJsTSUWmB+LFBRe8/jX13ol0m7g5l7R9aktRd+UAqFgyaZIdqBZuTTZw+JOTm8ihW7Al8fkZt2iAg2tAnMw8pJYoZBBxznrsq/nyNFJDH6vMWLjYhlq9eJZO00vxyNAS4swF53eF07Rp53pz99m20XPJJ+ZFWfgbY18=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2559.namprd12.prod.outlook.com (2603:10b6:802:29::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16; Tue, 28 Jul
 2020 23:38:41 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c%6]) with mapi id 15.20.3216.033; Tue, 28 Jul 2020
 23:38:41 +0000
Subject: [PATCH v3 08/11] KVM: SVM: Remove set_cr_intercept,
 clr_cr_intercept and is_cr_intercept
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        sean.j.christopherson@intel.com, jmattson@google.com
Cc:     kvm@vger.kernel.org, joro@8bytes.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com, bp@alien8.de,
        hpa@zytor.com, tglx@linutronix.de
Date:   Tue, 28 Jul 2020 18:38:40 -0500
Message-ID: <159597952011.12744.5966486013997025592.stgit@bmoger-ubuntu>
In-Reply-To: <159597929496.12744.14654593948763926416.stgit@bmoger-ubuntu>
References: <159597929496.12744.14654593948763926416.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0016.namprd11.prod.outlook.com
 (2603:10b6:806:d3::21) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by SA0PR11CA0016.namprd11.prod.outlook.com (2603:10b6:806:d3::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.21 via Frontend Transport; Tue, 28 Jul 2020 23:38:40 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: be421c5a-81b1-4f95-8823-08d8334f5bf5
X-MS-TrafficTypeDiagnostic: SN1PR12MB2559:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB255946A063D257B37B6B102195730@SN1PR12MB2559.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:106;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TpY26jba19ytImbjFXUeewPTyAflTc19aI5Reo+Z3rkEDFfvSjJDmYnSMoEsfQsvRDzqpCzP6aMsqUf2pe9gSuYpahWTtB4zPi4LTl5Tysj51xkQX5ugRG1qGT0YfJybPOy+Z4n8Vlv/+Gk2do3xUYqroSohVkGHGmqC3lUyirSC8DDce7qxEUub55esazru7MnguTXKv2wJZ/Eg01vuz34g26wBY/tMWVKb7/B75sSJoSTGvpz142N55BC7buY+BBlk1y8mdmdKgqCLVoMu8HHZW86Rk4Gpm6C5nt8P+9OHA4YlfEnWxczRm0KqKwDWbKRajXD2kOPhkQlwHA4ESQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(7916004)(4636009)(136003)(346002)(376002)(396003)(366004)(39860400002)(66946007)(66476007)(5660300002)(7416002)(316002)(478600001)(6486002)(16576012)(66556008)(2906002)(103116003)(83380400001)(86362001)(9686003)(8936002)(16526019)(8676002)(26005)(186003)(956004)(52116002)(44832011)(33716001)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: GgZvqC/P9LrM1Jcox3UuD715H8mfw0e/lWRAEhc88V+wCXbiQfrtypi1l68vkqWH1E8oCahRg7+vg8bL+/Yk6em6bOOFgjw2k6/BBT+xu5BSyarsqVwEacOT/4FXVZNhD2Wqfks6nDhmvDUS4qK0CAvc86jxAR1ulRjqrJLKDDNprLrDP9qIIS6ark0lwg6gaosML9wT+f4n5PClIaD+qqPhv3+hFTRN/sOJ93a3CQ7E5n4xC0W1aX06RqwecWu1khmOS4bI+3OvZhpa/ZJL6BSyk0VYEcZbJD5B67cjwwtfru29C8TZNy+vMRz2X/AwpDgzJxCayzGFWlzOQioE44n3JIV+rL07hp0uoB0rXuDRLozhSSLkNzKNa6dLxCQvaQxWj1qGmLGu7Zk1ote3kPc9mCY+WV+8jJSqzbz2NrCzpXuFiKzdwcGA+G8bqJT/Yei6AwxOMrbAdfBvUbBq1PvMCuZVz8AeM6X3bzAp77Qe3byLIIzNfzIH3CkMmPjaeRoz5pNmvBaTcd9/9SoUIGkM0vI8E9jLKwKTlByfIzWI5z42Y07btvA4P7jyDQBpuXIyPRdnDqUcK62yCfYYsJ4jOp9C34/iheclFZUQkVd/wlxaMb+llc/t+ccmUl/QHSdtnJkbVU4+3mZ/LW4aUQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be421c5a-81b1-4f95-8823-08d8334f5bf5
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 23:38:41.3584
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XeyupCF6rRoqAkv13FU7X69NUE6yFh9M7s1yJmVSbMzXstG07SHWQkt3uYMyxpA2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2559
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove set_cr_intercept, clr_cr_intercept and is_cr_intercept. Instead
call generic set_intercept, clr_intercept and is_intercept for all
cr intercepts.

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 arch/x86/kvm/svm/svm.c |   34 +++++++++++++++++-----------------
 arch/x86/kvm/svm/svm.h |   25 -------------------------
 2 files changed, 17 insertions(+), 42 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 1db783435a8a..32037ed622a7 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -977,14 +977,14 @@ static void init_vmcb(struct vcpu_svm *svm)
 
 	svm->vcpu.arch.hflags = 0;
 
-	set_cr_intercept(svm, INTERCEPT_CR0_READ);
-	set_cr_intercept(svm, INTERCEPT_CR3_READ);
-	set_cr_intercept(svm, INTERCEPT_CR4_READ);
-	set_cr_intercept(svm, INTERCEPT_CR0_WRITE);
-	set_cr_intercept(svm, INTERCEPT_CR3_WRITE);
-	set_cr_intercept(svm, INTERCEPT_CR4_WRITE);
+	set_intercept(svm, INTERCEPT_CR0_READ);
+	set_intercept(svm, INTERCEPT_CR3_READ);
+	set_intercept(svm, INTERCEPT_CR4_READ);
+	set_intercept(svm, INTERCEPT_CR0_WRITE);
+	set_intercept(svm, INTERCEPT_CR3_WRITE);
+	set_intercept(svm, INTERCEPT_CR4_WRITE);
 	if (!kvm_vcpu_apicv_active(&svm->vcpu))
-		set_cr_intercept(svm, INTERCEPT_CR8_WRITE);
+		set_intercept(svm, INTERCEPT_CR8_WRITE);
 
 	set_dr_intercepts(svm);
 
@@ -1079,8 +1079,8 @@ static void init_vmcb(struct vcpu_svm *svm)
 		control->nested_ctl |= SVM_NESTED_CTL_NP_ENABLE;
 		clr_intercept(svm, INTERCEPT_INVLPG);
 		clr_exception_intercept(svm, INTERCEPT_PF_VECTOR);
-		clr_cr_intercept(svm, INTERCEPT_CR3_READ);
-		clr_cr_intercept(svm, INTERCEPT_CR3_WRITE);
+		clr_intercept(svm, INTERCEPT_CR3_READ);
+		clr_intercept(svm, INTERCEPT_CR3_WRITE);
 		save->g_pat = svm->vcpu.arch.pat;
 		save->cr3 = 0;
 		save->cr4 = 0;
@@ -1534,11 +1534,11 @@ static void update_cr0_intercept(struct vcpu_svm *svm)
 	mark_dirty(svm->vmcb, VMCB_CR);
 
 	if (gcr0 == *hcr0) {
-		clr_cr_intercept(svm, INTERCEPT_CR0_READ);
-		clr_cr_intercept(svm, INTERCEPT_CR0_WRITE);
+		clr_intercept(svm, INTERCEPT_CR0_READ);
+		clr_intercept(svm, INTERCEPT_CR0_WRITE);
 	} else {
-		set_cr_intercept(svm, INTERCEPT_CR0_READ);
-		set_cr_intercept(svm, INTERCEPT_CR0_WRITE);
+		set_intercept(svm, INTERCEPT_CR0_READ);
+		set_intercept(svm, INTERCEPT_CR0_WRITE);
 	}
 }
 
@@ -2916,7 +2916,7 @@ static int handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 
 	trace_kvm_exit(exit_code, vcpu, KVM_ISA_SVM);
 
-	if (!is_cr_intercept(svm, INTERCEPT_CR0_WRITE))
+	if (!is_intercept(svm, INTERCEPT_CR0_WRITE))
 		vcpu->arch.cr0 = svm->vmcb->save.cr0;
 	if (npt_enabled)
 		vcpu->arch.cr3 = svm->vmcb->save.cr3;
@@ -3042,13 +3042,13 @@ static void update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
 	if (svm_nested_virtualize_tpr(vcpu))
 		return;
 
-	clr_cr_intercept(svm, INTERCEPT_CR8_WRITE);
+	clr_intercept(svm, INTERCEPT_CR8_WRITE);
 
 	if (irr == -1)
 		return;
 
 	if (tpr >= irr)
-		set_cr_intercept(svm, INTERCEPT_CR8_WRITE);
+		set_intercept(svm, INTERCEPT_CR8_WRITE);
 }
 
 bool svm_nmi_blocked(struct kvm_vcpu *vcpu)
@@ -3236,7 +3236,7 @@ static inline void sync_cr8_to_lapic(struct kvm_vcpu *vcpu)
 	if (svm_nested_virtualize_tpr(vcpu))
 		return;
 
-	if (!is_cr_intercept(svm, INTERCEPT_CR8_WRITE)) {
+	if (!is_intercept(svm, INTERCEPT_CR8_WRITE)) {
 		int cr8 = svm->vmcb->control.int_ctl & V_TPR_MASK;
 		kvm_set_cr8(vcpu, cr8);
 	}
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 450d7b196efd..c7fbce738337 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -231,31 +231,6 @@ static inline bool __is_intercept(void *addr, int bit)
 	return test_bit(bit, (unsigned long *)addr);
 }
 
-static inline void set_cr_intercept(struct vcpu_svm *svm, int bit)
-{
-	struct vmcb *vmcb = get_host_vmcb(svm);
-
-	__set_intercept(&vmcb->control.intercepts, bit);
-
-	recalc_intercepts(svm);
-}
-
-static inline void clr_cr_intercept(struct vcpu_svm *svm, int bit)
-{
-	struct vmcb *vmcb = get_host_vmcb(svm);
-
-	__clr_intercept(&vmcb->control.intercepts, bit);
-
-	recalc_intercepts(svm);
-}
-
-static inline bool is_cr_intercept(struct vcpu_svm *svm, int bit)
-{
-	struct vmcb *vmcb = get_host_vmcb(svm);
-
-	return __is_intercept(&vmcb->control.intercepts, bit);
-}
-
 static inline void set_dr_intercepts(struct vcpu_svm *svm)
 {
 	struct vmcb *vmcb = get_host_vmcb(svm);

