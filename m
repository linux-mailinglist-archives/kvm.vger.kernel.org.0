Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C911923E557
	for <lists+kvm@lfdr.de>; Fri,  7 Aug 2020 02:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726862AbgHGAr0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Aug 2020 20:47:26 -0400
Received: from mail-dm6nam12on2083.outbound.protection.outlook.com ([40.107.243.83]:11136
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726066AbgHGAr0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Aug 2020 20:47:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xt4CtOFKmDQh6FFaHWnbmrAvysif7zwvSfGBneaKFd+LrrEoKUJtS5YLTcphqQMvoh0mzuwh+uiphKG0p2KPPYO+4Z5Bb0YIKdtpWlUAgHTWX+bqJvYtYzOxoDmZbgQkSCC9mCBAjqRcFihHhjB9qCSHxpc+AJs4BhO4n/Aa6ohVQRF0HQ80CQ7rtOrjwHRJ9sd2lcmjN5Kg0Lt1bqO6hUnanQTSP/ilyK0C4rMDY/doGEhQCZTsuQoOI8W0Zq1CeLW/tvOit6wf8s2kTKXAFzS2TIiIpxHh7/XfDB/A+PRSSXZ9HAw7zjrhiuYjYFM/GQXetZh4DutBdBRGO3Dnbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GWkruwpGWx0iXEsbTAy7FsBZna5e6rAFluE3Xj0qMm4=;
 b=dBeug/suh93ZIYA0jUCPAEwib5Yk9H+aYO1v1gKsDJ/4bsUBXWeDgCqoR7DlSCejGYvGx0rLvIC3PRCp3lk/+/Cy0aO220Ai+C0x9CB7y2hGRhDhXVF0KExW/7nHIwsyx9KVGmuEq6ZF2mQsvkKX0QQYCfMoXGMHUyD9YpJra2MMNTxX/3UT8cvRL+DRY9aygMRCxJGqWzeeh7XzKvaZmO/vW7ftZF/GOSH01Qe/DUJSbaUvqp8MlFDVtkFjlsIVEUaiMzZGQMYgROwfadz4OZT/DehOGDlrNYMr7t6RoVDoCQQhoiCIOqDtv0fS/RtV4q5oAyR8Xr0/QbaIwYRL7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GWkruwpGWx0iXEsbTAy7FsBZna5e6rAFluE3Xj0qMm4=;
 b=oBOeDrQzWOJX0GvAddTZEzkvXDOF8MSd0tRSzPZxFkJv3vcO9CBFrCQbmLPU+KEuhRaC9APeyWqIUptb2eTLiE2kc9qpLMzn/EjNzIlBbfwDGS3A+HviD5/85FWNSnJf8ymEHWzQ46d8zSNA+qCwyEQAnvzmLswPAUixfHZ6OWs=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SA0PR12MB4479.namprd12.prod.outlook.com (2603:10b6:806:95::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19; Fri, 7 Aug
 2020 00:47:22 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c%6]) with mapi id 15.20.3239.023; Fri, 7 Aug 2020
 00:47:22 +0000
Subject: [PATCH v4 09/12] KVM: SVM: Remove set_exception_intercept and
 clr_exception_intercept
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        sean.j.christopherson@intel.com, jmattson@google.com
Cc:     kvm@vger.kernel.org, joro@8bytes.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com, bp@alien8.de,
        hpa@zytor.com, tglx@linutronix.de
Date:   Thu, 06 Aug 2020 19:47:21 -0500
Message-ID: <159676124143.12805.14542564267316476190.stgit@bmoger-ubuntu>
In-Reply-To: <159676101387.12805.18038347880482984693.stgit@bmoger-ubuntu>
References: <159676101387.12805.18038347880482984693.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR04CA0089.namprd04.prod.outlook.com
 (2603:10b6:805:f2::30) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by SN6PR04CA0089.namprd04.prod.outlook.com (2603:10b6:805:f2::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19 via Frontend Transport; Fri, 7 Aug 2020 00:47:22 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: afbe4503-7278-4822-1d18-08d83a6b7242
X-MS-TrafficTypeDiagnostic: SA0PR12MB4479:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB44791C1A258FA88E2DB2510595490@SA0PR12MB4479.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:224;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oJzU+kKrjl4k9YdfCnrv81kVw3CrXboRK60CHjCTGS518hMenD2FBiaJxXqH6vFSvle6JaLk/VRNrF3XwlDKVZu5QVA3rX1EqhRY3Z2whmjKKmiRUHCuUj7RAk18V49KwQsqSQFJLj1sMVzgLO9ZOuIzrhNlOtQTNgC6lA9izE0gcNITTE51k6s+6pEW6pwH/E+X84ZUdJ4COcNFsGcYqokp+2/3D9vJaS1CqvgmlCCKn5NdTlYlPTxtj1AHLVbY+ZMTRFNAIVz+ANWP8QEz2GG9vLCgrusqe7aijWE4b8U0RVZPboYB5jydxKfYiPtp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(7916004)(39860400002)(396003)(376002)(346002)(136003)(366004)(5660300002)(6486002)(52116002)(2906002)(16576012)(4326008)(83380400001)(7416002)(956004)(44832011)(33716001)(26005)(9686003)(8676002)(66476007)(66556008)(103116003)(66946007)(8936002)(86362001)(16526019)(186003)(478600001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: B/BurHhAnbxup1D7nPd6L2l/n/CJwaag8mxp5IsTY9Z7Mk3R+b4uBLJmpS//KM8HRBwVFqRuu0f7ih8lvGc4WAfCPoHhqoxKs42whUGcRP7B1ph1cZWn1rhaohy3q9IxCtqNiBK8WEvJ7SbQA7QOPWNszz+DoHYvnWCw2oH646LEigZ3ACHEH6Uex9qz8QaSRzmegzH6E/XA3iXaz6toSmPr+wJVY10S8que+r3tvxLGLk47zV6L/Rit1alZcF8abRQojd4914MNx3hQZknPi8jwiMwhrcSzH3dxnQBsqJ5n1xTkr5xy1mWiTNF3TH2iuVXCtHljNFMTQ9TliaeMc1tLpAjC0lP9iHtAodZteLSf6f1XJjn50v/coqCSGCmER5fkiTBDZyFT2lGi/RxLzes+NPE5ydtWyVqmDWpSM332NgXdW1Dr6TuCE9xYyML0zOGT2Lh+jBh1oR9zpLlh292hUQIEprGX3f9ellbp5lr27cPU7+JFvKpAF2sg+BiBt7jr9I6gD5G+c/ewFqTqabQaQYLQ0wI5bSb/MN6SlAOo8TgQ1sNxY4X5hOf4RXdtj64EC6aFDRGh68/NkKF0pXB3x6TATjfWTmhJpfZofuXyb4DCrvgidsO7XjYj935Stbw2IinC+WisRsA+aN8aog==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afbe4503-7278-4822-1d18-08d83a6b7242
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2020 00:47:22.6921
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wzPw/rKHJKES+kHDAChxqOHFYrpK3rGqjbJzaFDuYpzn749mxiZRBYgzKq4vM1oC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4479
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove set_exception_intercept and clr_exception_intercept.
Replace with generic set_intercept and clr_intercept for these calls.

Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/svm/svm.c |   20 ++++++++++----------
 arch/x86/kvm/svm/svm.h |   18 ------------------
 2 files changed, 10 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b40ed18cb5c2..3c718caa3b99 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -988,11 +988,11 @@ static void init_vmcb(struct vcpu_svm *svm)
 
 	set_dr_intercepts(svm);
 
-	set_exception_intercept(svm, INTERCEPT_PF_VECTOR);
-	set_exception_intercept(svm, INTERCEPT_UD_VECTOR);
-	set_exception_intercept(svm, INTERCEPT_MC_VECTOR);
-	set_exception_intercept(svm, INTERCEPT_AC_VECTOR);
-	set_exception_intercept(svm, INTERCEPT_DB_VECTOR);
+	set_intercept(svm, INTERCEPT_PF_VECTOR);
+	set_intercept(svm, INTERCEPT_UD_VECTOR);
+	set_intercept(svm, INTERCEPT_MC_VECTOR);
+	set_intercept(svm, INTERCEPT_AC_VECTOR);
+	set_intercept(svm, INTERCEPT_DB_VECTOR);
 	/*
 	 * Guest access to VMware backdoor ports could legitimately
 	 * trigger #GP because of TSS I/O permission bitmap.
@@ -1000,7 +1000,7 @@ static void init_vmcb(struct vcpu_svm *svm)
 	 * as VMware does.
 	 */
 	if (enable_vmware_backdoor)
-		set_exception_intercept(svm, INTERCEPT_GP_VECTOR);
+		set_intercept(svm, INTERCEPT_GP_VECTOR);
 
 	set_intercept(svm, INTERCEPT_INTR);
 	set_intercept(svm, INTERCEPT_NMI);
@@ -1078,7 +1078,7 @@ static void init_vmcb(struct vcpu_svm *svm)
 		/* Setup VMCB for Nested Paging */
 		control->nested_ctl |= SVM_NESTED_CTL_NP_ENABLE;
 		clr_intercept(svm, INTERCEPT_INVLPG);
-		clr_exception_intercept(svm, INTERCEPT_PF_VECTOR);
+		clr_intercept(svm, INTERCEPT_PF_VECTOR);
 		clr_intercept(svm, INTERCEPT_CR3_READ);
 		clr_intercept(svm, INTERCEPT_CR3_WRITE);
 		save->g_pat = svm->vcpu.arch.pat;
@@ -1120,7 +1120,7 @@ static void init_vmcb(struct vcpu_svm *svm)
 
 	if (sev_guest(svm->vcpu.kvm)) {
 		svm->vmcb->control.nested_ctl |= SVM_NESTED_CTL_SEV_ENABLE;
-		clr_exception_intercept(svm, INTERCEPT_UD_VECTOR);
+		clr_intercept(svm, INTERCEPT_UD_VECTOR);
 	}
 
 	mark_all_dirty(svm->vmcb);
@@ -1631,11 +1631,11 @@ static void update_bp_intercept(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	clr_exception_intercept(svm, INTERCEPT_BP_VECTOR);
+	clr_intercept(svm, INTERCEPT_BP_VECTOR);
 
 	if (vcpu->guest_debug & KVM_GUESTDBG_ENABLE) {
 		if (vcpu->guest_debug & KVM_GUESTDBG_USE_SW_BP)
-			set_exception_intercept(svm, INTERCEPT_BP_VECTOR);
+			set_intercept(svm, INTERCEPT_BP_VECTOR);
 	} else
 		vcpu->guest_debug = 0;
 }
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 6c3f0e1c4555..c89ebaaa3be3 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -264,24 +264,6 @@ static inline void clr_dr_intercepts(struct vcpu_svm *svm)
 	recalc_intercepts(svm);
 }
 
-static inline void set_exception_intercept(struct vcpu_svm *svm, int bit)
-{
-	struct vmcb *vmcb = get_host_vmcb(svm);
-
-	vmcb_set_intercept(&vmcb->control, bit);
-
-	recalc_intercepts(svm);
-}
-
-static inline void clr_exception_intercept(struct vcpu_svm *svm, int bit)
-{
-	struct vmcb *vmcb = get_host_vmcb(svm);
-
-	vmcb_clr_intercept(&vmcb->control, bit);
-
-	recalc_intercepts(svm);
-}
-
 static inline void set_intercept(struct vcpu_svm *svm, int bit)
 {
 	struct vmcb *vmcb = get_host_vmcb(svm);

