Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB4E4253808
	for <lists+kvm@lfdr.de>; Wed, 26 Aug 2020 21:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727944AbgHZTPG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Aug 2020 15:15:06 -0400
Received: from mail-bn7nam10on2042.outbound.protection.outlook.com ([40.107.92.42]:11707
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727909AbgHZTO7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Aug 2020 15:14:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VHF24SsS6jw0i6Ch9Vmf/O64Th3tiFC2qtKl6NfOu+phbUyULCzvJLornsCN6u55RLGC66tyE3Z5hBMBcZ+Br65Ct0f9DCLc/dXyiqcYzLpFDMZxf/DaX355C1iYt+R1pl2vHYTwpVfSbMXW54cpUuftDhnRZU5llqQF++Ppyk6J0N3I1lw+ORk8S8Xfv5+U9wqD9GhaGnO7rMONjuphk2t0jpPWy9Jle1j02bHNv1KuMXveujtdwmNcuDyBf/HDFmIp0Dck7YOvEy+kNud72UgHjuKGdVqtKNxI8i+t+BktTDnKQWTEu8UYsZjolo+K6RKSCvmaPUwjxQqCOiQ0Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ig/6wsw048VE9ZPJm9cY0oj5dbpCDYIjCRHQNAwOgaY=;
 b=DS4I770TwmPZKIz/JLUIAcc7C9K8F1SVc7wf8oRcA66gsCLuLHS+HtRRoNFbBb8v9YaHSFrde3nqNNbXRr/L31pZMv5GDQlw1KNoypTP7xAvY6yXsgci7y6crIQuUfDuvZTvec5jzRu9+jOY9aMVhbY2DdhA3Nc4sxsf/ihDR4aypuX1TZnu9x5fn11LHgEZtqteyRIWc/1ND2wgxcp02J3HHV3A3XwdZwkzseGPpcbw6QwnallJIOtoZFejUpqJLAvzQms7uqn6TYcNQRJB3yPCo7HV68VWFmdO7fuTEt5nwlQCwU55H32LNauK1JM5dZbvxaqUaCjKbzsprSJfJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ig/6wsw048VE9ZPJm9cY0oj5dbpCDYIjCRHQNAwOgaY=;
 b=fkMFJuUAOZAf3Og0CJy48YJD2p7KUG2aK6fK78TCd+J7XfygCm73FWWa5OEp1vOo3dNYts1nZuTzfSVN/dwB5hha/mECphuVIr+VfTxtbKTK2hzIVgzJPCCmcJknqMRLfs6K5cUdExjSwuh/ktpvP6P3x3sqdy94LCxfNdD1iXs=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2461.namprd12.prod.outlook.com (2603:10b6:802:27::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19; Wed, 26 Aug
 2020 19:14:47 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d%4]) with mapi id 15.20.3305.026; Wed, 26 Aug 2020
 19:14:47 +0000
Subject: [PATCH v5 08/12] KVM: SVM: Remove set_cr_intercept,
 clr_cr_intercept and is_cr_intercept
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, jmattson@google.com
Cc:     wanpengli@tencent.com, kvm@vger.kernel.org, joro@8bytes.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, babu.moger@amd.com,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, tglx@linutronix.de
Date:   Wed, 26 Aug 2020 14:14:45 -0500
Message-ID: <159846928555.18873.13387843427538792883.stgit@bmoger-ubuntu>
In-Reply-To: <159846887637.18873.14677728679411578606.stgit@bmoger-ubuntu>
References: <159846887637.18873.14677728679411578606.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR18CA0026.namprd18.prod.outlook.com
 (2603:10b6:5:15b::39) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by DM6PR18CA0026.namprd18.prod.outlook.com (2603:10b6:5:15b::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Wed, 26 Aug 2020 19:14:46 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 587ccd52-562c-43ac-ae12-08d849f44c56
X-MS-TrafficTypeDiagnostic: SN1PR12MB2461:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2461D91BEE58E371796E12A195540@SN1PR12MB2461.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:40;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MCCok5emPjuZ4y8uO7GlwVkWLQ6o5I7Un6i4qG9AE28r1gHWHPDofHyhmICRruZWml8aBdzxfBJSShRIgzyS0hJl1SYDWxAbToBzFvMPotm6E3I5PtNy8oyeynAXcEwbpJYqQPxX+NHIOkca/a6e0rf8fDQQXqJMtnOrqcv0p1/ro7TuM0bwIjHkekoLA/zDE/C7J6r934h4T9GJLL7zYc6W/kUoQ/zqOsM00ErbSWX/h+osqhIlm5fR283YOHlAr18fFM8hy303EXqny6mL9FgRgRjtudKMMoU53E0OFX8kjjg569SYQ0k7EDDVdUE2k6NGsRHb+TwDtgSZiy8gKA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(346002)(376002)(136003)(39860400002)(396003)(366004)(956004)(44832011)(66556008)(8936002)(66946007)(66476007)(16576012)(9686003)(7416002)(26005)(478600001)(6486002)(186003)(86362001)(52116002)(8676002)(316002)(5660300002)(4326008)(83380400001)(2906002)(33716001)(103116003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: x77CqYzSXFINFbX7CKY4vw5D+8Uvw5ifReIeq6eD94ZrrV+LciluS0Is0X7EF7l4Eq/1zfLrGMsC7BDD1pkoQUaZxg0BGBmohUjps944n7993tL2r6q11AOUovST3H+CMOC4cRStGowdJ/5zhNKokBsnPHWvbPw7PColA2Rob/i12j3+lkSA2zffKyE+iCMIx25zU77IA7NB0ZLDx+4ivaeTfbV3HwVFXqU6NVJEofBzz9DRAOcbEy7Yludt2X91zhd4sYE49by0NxDYXn+DqSqtg/hcIQ5OXSoFypgmiKsYcPz2LTOWEdvpxyYPFH1a8lBgUJPjRJe7IzVJkojP4oYFE7ej8ola67vrgMtO9mNVHiNpq5BZMJ59faOX3rayGekZOI/ajuzLHeILjE2u3gOSZR9JD+Mo0cQSNapQBR+NL7bFe9ggJGzX99xrNGD/YaqIT1YGklbtIka1XjNnO2naQ2muoJt+9hVlxVMS9iG9saKuNgAMPIYJJ6LiWT5G4ZeWdE0SowQZt87i7CmGDbOM9WeZ8WL/9CishVFYVMQLrTNKSpyNt0Nh4R6rFobs93nU5om/oi1yE/W0HZ9IkhoXiEXKuGXcpLtK83d03+PFcFA4pd7egq/fdHEEBDYVPs5ceTlHBhIhIaz4lXKb/w==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 587ccd52-562c-43ac-ae12-08d849f44c56
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2020 19:14:47.6061
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xTFR2b3a1BWWxzAmuYOeJxd+Lj82HkT3hs8gBug3ilUDFlVyO5kBkeoCub3c1SiK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2461
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove set_cr_intercept, clr_cr_intercept and is_cr_intercept. Instead
call generic svm_set_intercept, svm_clr_intercept an dsvm_is_intercep
tfor all cr intercepts.

Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/svm/svm.c |   34 +++++++++++++++++-----------------
 arch/x86/kvm/svm/svm.h |   25 -------------------------
 2 files changed, 17 insertions(+), 42 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 17bfa34033ac..0d7397f4a4f7 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -992,14 +992,14 @@ static void init_vmcb(struct vcpu_svm *svm)
 
 	svm->vcpu.arch.hflags = 0;
 
-	set_cr_intercept(svm, INTERCEPT_CR0_READ);
-	set_cr_intercept(svm, INTERCEPT_CR3_READ);
-	set_cr_intercept(svm, INTERCEPT_CR4_READ);
-	set_cr_intercept(svm, INTERCEPT_CR0_WRITE);
-	set_cr_intercept(svm, INTERCEPT_CR3_WRITE);
-	set_cr_intercept(svm, INTERCEPT_CR4_WRITE);
+	svm_set_intercept(svm, INTERCEPT_CR0_READ);
+	svm_set_intercept(svm, INTERCEPT_CR3_READ);
+	svm_set_intercept(svm, INTERCEPT_CR4_READ);
+	svm_set_intercept(svm, INTERCEPT_CR0_WRITE);
+	svm_set_intercept(svm, INTERCEPT_CR3_WRITE);
+	svm_set_intercept(svm, INTERCEPT_CR4_WRITE);
 	if (!kvm_vcpu_apicv_active(&svm->vcpu))
-		set_cr_intercept(svm, INTERCEPT_CR8_WRITE);
+		svm_set_intercept(svm, INTERCEPT_CR8_WRITE);
 
 	set_dr_intercepts(svm);
 
@@ -1094,8 +1094,8 @@ static void init_vmcb(struct vcpu_svm *svm)
 		control->nested_ctl |= SVM_NESTED_CTL_NP_ENABLE;
 		svm_clr_intercept(svm, INTERCEPT_INVLPG);
 		clr_exception_intercept(svm, INTERCEPT_PF_VECTOR);
-		clr_cr_intercept(svm, INTERCEPT_CR3_READ);
-		clr_cr_intercept(svm, INTERCEPT_CR3_WRITE);
+		svm_clr_intercept(svm, INTERCEPT_CR3_READ);
+		svm_clr_intercept(svm, INTERCEPT_CR3_WRITE);
 		save->g_pat = svm->vcpu.arch.pat;
 		save->cr3 = 0;
 		save->cr4 = 0;
@@ -1549,11 +1549,11 @@ static void update_cr0_intercept(struct vcpu_svm *svm)
 	vmcb_mark_dirty(svm->vmcb, VMCB_CR);
 
 	if (gcr0 == *hcr0) {
-		clr_cr_intercept(svm, INTERCEPT_CR0_READ);
-		clr_cr_intercept(svm, INTERCEPT_CR0_WRITE);
+		svm_clr_intercept(svm, INTERCEPT_CR0_READ);
+		svm_clr_intercept(svm, INTERCEPT_CR0_WRITE);
 	} else {
-		set_cr_intercept(svm, INTERCEPT_CR0_READ);
-		set_cr_intercept(svm, INTERCEPT_CR0_WRITE);
+		svm_set_intercept(svm, INTERCEPT_CR0_READ);
+		svm_set_intercept(svm, INTERCEPT_CR0_WRITE);
 	}
 }
 
@@ -2931,7 +2931,7 @@ static int handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 
 	trace_kvm_exit(exit_code, vcpu, KVM_ISA_SVM);
 
-	if (!is_cr_intercept(svm, INTERCEPT_CR0_WRITE))
+	if (!svm_is_intercept(svm, INTERCEPT_CR0_WRITE))
 		vcpu->arch.cr0 = svm->vmcb->save.cr0;
 	if (npt_enabled)
 		vcpu->arch.cr3 = svm->vmcb->save.cr3;
@@ -3056,13 +3056,13 @@ static void update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
 	if (nested_svm_virtualize_tpr(vcpu))
 		return;
 
-	clr_cr_intercept(svm, INTERCEPT_CR8_WRITE);
+	svm_clr_intercept(svm, INTERCEPT_CR8_WRITE);
 
 	if (irr == -1)
 		return;
 
 	if (tpr >= irr)
-		set_cr_intercept(svm, INTERCEPT_CR8_WRITE);
+		svm_set_intercept(svm, INTERCEPT_CR8_WRITE);
 }
 
 bool svm_nmi_blocked(struct kvm_vcpu *vcpu)
@@ -3250,7 +3250,7 @@ static inline void sync_cr8_to_lapic(struct kvm_vcpu *vcpu)
 	if (nested_svm_virtualize_tpr(vcpu))
 		return;
 
-	if (!is_cr_intercept(svm, INTERCEPT_CR8_WRITE)) {
+	if (!svm_is_intercept(svm, INTERCEPT_CR8_WRITE)) {
 		int cr8 = svm->vmcb->control.int_ctl & V_TPR_MASK;
 		kvm_set_cr8(vcpu, cr8);
 	}
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index ffb35a83048f..8128bac75fa2 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -228,31 +228,6 @@ static inline bool vmcb_is_intercept(struct vmcb_control_area *control, int bit)
 	return test_bit(bit, (unsigned long *)&control->intercepts);
 }
 
-static inline void set_cr_intercept(struct vcpu_svm *svm, int bit)
-{
-	struct vmcb *vmcb = get_host_vmcb(svm);
-
-	vmcb_set_intercept(&vmcb->control, bit);
-
-	recalc_intercepts(svm);
-}
-
-static inline void clr_cr_intercept(struct vcpu_svm *svm, int bit)
-{
-	struct vmcb *vmcb = get_host_vmcb(svm);
-
-	vmcb_clr_intercept(&vmcb->control, bit);
-
-	recalc_intercepts(svm);
-}
-
-static inline bool is_cr_intercept(struct vcpu_svm *svm, int bit)
-{
-	struct vmcb *vmcb = get_host_vmcb(svm);
-
-	return vmcb_is_intercept(&vmcb->control, bit);
-}
-
 static inline void set_dr_intercepts(struct vcpu_svm *svm)
 {
 	struct vmcb *vmcb = get_host_vmcb(svm);

