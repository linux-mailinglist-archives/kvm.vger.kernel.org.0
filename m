Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52969231656
	for <lists+kvm@lfdr.de>; Wed, 29 Jul 2020 01:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730203AbgG1Xiw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 19:38:52 -0400
Received: from mail-bn8nam11on2078.outbound.protection.outlook.com ([40.107.236.78]:7034
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730748AbgG1Xiu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jul 2020 19:38:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GpmU5s7L5oP5Az69UM0lDnBZztJfY6q5a2LDTxkk04urBLl5la4C03dp2rdcF2JiCxgBjAOZXiUOLvCvF41qF3HYH6Oh9K4CUkEm5b7JDOPpYjyk6Lc4PyNzLZV+LGQvq+W5HCvkGILPZTBswo6rmPh58KcGYb0ATbQbqsdzQp0xHti746ORuqff3GhwRZXwtc+4Z9ATpdq+Chg+1ythl0ZReXxEgzFnd4xCY3NVYLe5ZY2hvlLxxrLNemF3h5QyMs4c7s3wGRMKdBo5FvViX2TG4RGly24E/MscnFD73KlVyJqya42DU6Sd/JHvRQiyzzOBKK/5Uf1a97QuBhHBUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xgkz277XLWxLoAmDsemcxHPHgvQ3m+V9MLzNAEL4qls=;
 b=lXThPORw7lxXg7Shl38gKyFm4nOaC0kYBDpKLUYDMEjQebDx9Yu+8WXCNiBhY9PNF/mj7uegtAf0bN/PUA03BOaRonSHhHDdjeE8QJbSNuiiaNBiuSZYK2u1OGqZZVzjZ2wd8bEwUcQfa3CR5Ar2p2O9Oc640nBiAT6Yza0gHvYNFOCqkF+SFS9a7o+PzYOmSZi4LdVTm84a06VReTzPletJx46//NMrkMdDnwli0nF7bVausUuwVzqHZ2GLbQgodT3X79KMqvbvIV4NalcgNK/j6ueUW6DoNt3dSr5RBVX8NVRD6YdbT6czcAPJ9kmrIPDuq2yBmZnopaZfcwbTPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xgkz277XLWxLoAmDsemcxHPHgvQ3m+V9MLzNAEL4qls=;
 b=1e5XCGXTXSeCy1yuXsvbBIzV5mdPs5FWwT/wadsKuh7lWTVx/yrI4oV34i9wX1m9+abYN+g6w1NLcEV5w1O7zxkr8gVJPeXK7GkoMYTn5XRR4izvGG2INO3vrgAFxZ4SLWZA5LIkKN5pqKl6/YglIEHVbPi2stP5fmfhs0OYlII=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2559.namprd12.prod.outlook.com (2603:10b6:802:29::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16; Tue, 28 Jul
 2020 23:38:47 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c%6]) with mapi id 15.20.3216.033; Tue, 28 Jul 2020
 23:38:47 +0000
Subject: [PATCH v3 09/11] KVM: SVM: Remove set_exception_intercept and
 clr_exception_intercept
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        sean.j.christopherson@intel.com, jmattson@google.com
Cc:     kvm@vger.kernel.org, joro@8bytes.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com, bp@alien8.de,
        hpa@zytor.com, tglx@linutronix.de
Date:   Tue, 28 Jul 2020 18:38:46 -0500
Message-ID: <159597952647.12744.15718760666138643079.stgit@bmoger-ubuntu>
In-Reply-To: <159597929496.12744.14654593948763926416.stgit@bmoger-ubuntu>
References: <159597929496.12744.14654593948763926416.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR16CA0052.namprd16.prod.outlook.com
 (2603:10b6:805:ca::29) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by SN6PR16CA0052.namprd16.prod.outlook.com (2603:10b6:805:ca::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.22 via Frontend Transport; Tue, 28 Jul 2020 23:38:47 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9ac1423b-0ace-4bb4-2e07-08d8334f5fb5
X-MS-TrafficTypeDiagnostic: SN1PR12MB2559:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB255929402E0B4DEBE48C9F3F95730@SN1PR12MB2559.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:224;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mse95OnE2q36C9ytqHeweIPQbuCHTFdun8ruwMQJjJSk3C2QUS+Ubqv1FuLfN1TOM27RY8MHS/G50ms3IIS9Tzw5AsgBXe118OSHsYgWEk2Dlvtv2NdnIy3VTgLUWtm4GQWEpHG1YzYvYUBfQuXmaSfb/8y34BJumbC6T0/un74hcAr4fTWp5DVUqBtez4n1YAanphiurF4IwGOWQvM19HVWFkzl+7m2MNjHqE4xbB2QFNGSajIorbRezFuWu5VQMJxxPMHJczG/2vzF+z9exUdWAA4wdawK5HRiM3nXDwIZ/VV0zjwUAwLzUorCnGUk2p5JboAw1KfGnBHRgswxDw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(7916004)(4636009)(136003)(346002)(376002)(396003)(366004)(39860400002)(66946007)(66476007)(5660300002)(7416002)(316002)(478600001)(6486002)(16576012)(66556008)(2906002)(103116003)(83380400001)(86362001)(9686003)(8936002)(16526019)(8676002)(26005)(186003)(956004)(52116002)(44832011)(33716001)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: WQT6xBc0x71asisr90aqe5182XRDvIS4eApreuX8rNZWBTaFY3XtWLoT1K3UriJgkFL8S26ydG7NbewSRN+ZeGfivmitpzvvbRJL84fd/L15qua49FSQo6DiUB1NsQaQrIYIqecqUwljEs7m1+wO4rh0xycFX5vPui+Z4TQWYchgWs2LjJLmD8ebCO18oD56/vuDU1s2Gsp0G+G1r7oc3tKCAU1rUv3cbF1rjl580NcmU6sJC3xZwKsUHY4iyItReYtpNtQqjogGCB32ea0dNUPHVJD8m8TAVz8wq51TsmyvzogxKV+MFlH2lDKCX703SRjYSQEfgffZPlO4lNZGSM/j3v5EpaU/K26xwAtu3r2POCWwNfAZnwdaDRVNKVGmzld9hEBqXSxaF2rmxJYavQzje766bwNmVIA0A/bIpUeuOYohPli7nIlrOecEcrW5Q16f4Ye9jXQUWiYiV32EcM36V6YL9NWMKnpl971UQSf5XfLJZhGTcp9/uOdiA8G3NUfqW0Gi8eAAcywlZ/g7gFOU0egM6ZCtLk1l7C5nHj902zgmIyXdUVMvFM4GIMAfBTU4DsN5SESRrmkJDkNZyJv6HqdN6cmAVAGOtkY1YuHmvyf8lU+Yk5ZBuOYhUYnupYYcMgCOT0wKcE3Xqn20ow==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ac1423b-0ace-4bb4-2e07-08d8334f5fb5
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 23:38:47.6745
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vx6erTE8ImhG9lY8yL4CH4zqyPSMalufdsBBzrgLQcJ+Mc5pYHC+nbQt9e/4y/vQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2559
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove set_exception_intercept and clr_exception_intercept.
Replace with generic set_intercept and clr_intercept for these calls.

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 arch/x86/kvm/svm/svm.c |   20 ++++++++++----------
 arch/x86/kvm/svm/svm.h |   18 ------------------
 2 files changed, 10 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 32037ed622a7..99cc9c285fe6 100644
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
index c7fbce738337..b95074971ea1 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -264,24 +264,6 @@ static inline void clr_dr_intercepts(struct vcpu_svm *svm)
 	recalc_intercepts(svm);
 }
 
-static inline void set_exception_intercept(struct vcpu_svm *svm, int bit)
-{
-	struct vmcb *vmcb = get_host_vmcb(svm);
-
-	__set_intercept(&vmcb->control.intercepts, bit);
-
-	recalc_intercepts(svm);
-}
-
-static inline void clr_exception_intercept(struct vcpu_svm *svm, int bit)
-{
-	struct vmcb *vmcb = get_host_vmcb(svm);
-
-	__clr_intercept(&vmcb->control.intercepts, bit);
-
-	recalc_intercepts(svm);
-}
-
 static inline void set_intercept(struct vcpu_svm *svm, int bit)
 {
 	struct vmcb *vmcb = get_host_vmcb(svm);

