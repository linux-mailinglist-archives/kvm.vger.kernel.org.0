Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DDDE2668C6
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 21:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725973AbgIKTaZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 15:30:25 -0400
Received: from mail-dm6nam12on2080.outbound.protection.outlook.com ([40.107.243.80]:23168
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725961AbgIKTaG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Sep 2020 15:30:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lksgQaWKrRyadFYuftU7boTx594WFSkLkQNodurwtRdBfPO2QWHtDHUnVcX9RMmFIO27QB5BApMobM0D4lZ9jVtnghSJmtTyRjzDqVKAIzx2FnUe651dWPFievOyUWcFmb86ZFF0hdpg8yFSqrbdzc9y/IbmWPW6EZes+r0eQqqTeJe0ERx8wGLmygXoIqTo2LJjyZiMcI7WyPhjMpwQMommHPStDPBBG94taz/SJ4v8duAolxyU88Syn+5msJi5jWoR5mPij7LiIwCYdxa2qXENi+fsYBuqyhHjvAc3NrSWbmA+fXJYF+LJTlUNhWP6HRT8Kbwyk+fJE2U/tOeGFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aUE9LovJnl2mai/pRtM6NHspDACFry7Dmota7pTHAcA=;
 b=HH52FEfV8pFrfnRlFxGswbtf98yf5djSbqqeYqVAZ6Yi+PTIx9UnGtrpg8f1gmySSmusyNkplPxMY8audjcltlWQvyvqsRO88BMEP0nsKf3p4fIWq1D50FsZjpRgj8MeOnO6A7FiwiXFHOURb+lpMRgmhnr/dycA2NB72LKgP/9L6mY5EV/NNIyLRclr+/gAT4etCQuZpk8wrV2pGO6qQBAlPkprbRg/sMSqRO3vIBszbl7ysFuWlbBqg94XIypcfyO3ixir6IpdDXnSfo80OiJ4DBUKHei6VGfuVkwtNV+kyQ3Xu3Iupd22i8c89p8UbcG0PDccJCHo0VzxUY/Wrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aUE9LovJnl2mai/pRtM6NHspDACFry7Dmota7pTHAcA=;
 b=MiSJ5VfI9hqcFjMsHoJxN/FyiyWAXcBC93XQPL+EBdNIXGU0nbSk298oNQ/HfOIBKdmoRAjrwmqsga9jRHb7nSV03mHcYRvePXibKyV/B8QZSLaO9N5BHkZ0gyk7n2ZyT7KxTi8MiFDh9gBVSSZwFbLMvGQsjrVzjw2V4HM+VWg=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SA0PR12MB4543.namprd12.prod.outlook.com (2603:10b6:806:9d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Fri, 11 Sep
 2020 19:28:59 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d%4]) with mapi id 15.20.3370.017; Fri, 11 Sep 2020
 19:28:59 +0000
Subject: [PATCH v6 09/12] KVM: SVM: Remove set_exception_intercept and
 clr_exception_intercept
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, jmattson@google.com
Cc:     wanpengli@tencent.com, kvm@vger.kernel.org, joro@8bytes.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, babu.moger@amd.com,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, tglx@linutronix.de
Date:   Fri, 11 Sep 2020 14:28:57 -0500
Message-ID: <159985253773.11252.10287556137071236912.stgit@bmoger-ubuntu>
In-Reply-To: <159985237526.11252.1516487214307300610.stgit@bmoger-ubuntu>
References: <159985237526.11252.1516487214307300610.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM3PR12CA0078.namprd12.prod.outlook.com
 (2603:10b6:0:57::22) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by DM3PR12CA0078.namprd12.prod.outlook.com (2603:10b6:0:57::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Fri, 11 Sep 2020 19:28:58 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ee797f34-03fc-44ed-2ba5-08d85688eed9
X-MS-TrafficTypeDiagnostic: SA0PR12MB4543:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4543821430EBBC476335FC8595240@SA0PR12MB4543.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:224;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IO9efR1mWtEGp8WtjW5PRb2MpwUdv/FjVmdwf6YhLUq6M3+Lao+yfPZkL3O3Z4p7pdLb7U9jWoMYKIbAWvZX4XdGBRN5RKW2kL0z7fya9VTxqUA+WtkX5pgQTdXciO6y7QAzJor5JbI4nHQg5qmX08zXT09FtMeiQINguRayEtyH+eoO4HGQM5fM8t/C7duPkYCfjeA4DNeEC4W2EBIswkl4A5z3W+4nAnmtqpxXNRG8MnHv2L0KFWH+U8RN29xPkNYAvepPhrV0P7xOOry18HL+8WrAWbfoCFezKo0XHFhYu2EV8Pmx07MPcNBS3drj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(376002)(136003)(346002)(366004)(39860400002)(396003)(2906002)(956004)(66946007)(66476007)(103116003)(8676002)(66556008)(52116002)(5660300002)(7416002)(9686003)(4326008)(8936002)(44832011)(186003)(16526019)(86362001)(33716001)(16576012)(6486002)(316002)(478600001)(26005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: AUhA1tZZp9ITDeYm1WL4m1XpL9sxVGnXXBF55V70W9fHqegvm981Fkc/ajlLWSM0GNlVQL0iuorAxKmSuSUU8oeAqLwJge/hmZNo1KQ+rw00oCJSMfr+GVdrJCd5aclzfgFxkGZtDLHbpzDpEy/rR3sBZcZdCDXVCiWCu1ycXla3xZJmzQLRU/H8kPa3auPA5x5rivu56Ar5/vWrWTsdxmyV9VwJr3kyhsXaQFIQ3PSu72wMoYnnR5+WANyP4HGLfFfDTSzhe6FRdnNt25WnQ9CNbdcfss3nb9Jg1meOa+hzlhxI1P8K9xaRzlnNOvEoqCuUZvE8x+KnT8VU3b8nd/jBChap4Hg+ndSeoDNSBbdr/YLVz9xzGU9C4eEbtIN5+30c/l2xWgPfAs5Af8w0GcjZOPbLfR90GLbM9vXPNcowmJO4Ztm2tTUsU6mh6yy7SShAMnkYl9NNkdbw9TlBmburhNWCIvkInjeUUi66Vyt7c9gGHF1p+XhQmTceuwBrPG9xKi2BQk7YAFnHf/in1GuxTREjnuFhxj5whfCXc2Ox61w1psQiFjG/YMa2w1OGb+BtpyPTQvoHBwRIdJYOZaCF5useQuRuG7FlV0R71yaXbHJ9pipuiZfW0Nt0thDTpZkhClG2VMFY16ERxE3WnQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee797f34-03fc-44ed-2ba5-08d85688eed9
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2020 19:28:59.7155
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4Jr6GRER4y7BsWOISla2FQM+uVxJI6Ec9M20mrxoLGXGIdGwu909CueuRaD+P251
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4543
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
index 0d7397f4a4f7..96617b61e531 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1003,11 +1003,11 @@ static void init_vmcb(struct vcpu_svm *svm)
 
 	set_dr_intercepts(svm);
 
-	set_exception_intercept(svm, INTERCEPT_PF_VECTOR);
-	set_exception_intercept(svm, INTERCEPT_UD_VECTOR);
-	set_exception_intercept(svm, INTERCEPT_MC_VECTOR);
-	set_exception_intercept(svm, INTERCEPT_AC_VECTOR);
-	set_exception_intercept(svm, INTERCEPT_DB_VECTOR);
+	svm_set_intercept(svm, INTERCEPT_PF_VECTOR);
+	svm_set_intercept(svm, INTERCEPT_UD_VECTOR);
+	svm_set_intercept(svm, INTERCEPT_MC_VECTOR);
+	svm_set_intercept(svm, INTERCEPT_AC_VECTOR);
+	svm_set_intercept(svm, INTERCEPT_DB_VECTOR);
 	/*
 	 * Guest access to VMware backdoor ports could legitimately
 	 * trigger #GP because of TSS I/O permission bitmap.
@@ -1015,7 +1015,7 @@ static void init_vmcb(struct vcpu_svm *svm)
 	 * as VMware does.
 	 */
 	if (enable_vmware_backdoor)
-		set_exception_intercept(svm, INTERCEPT_GP_VECTOR);
+		svm_set_intercept(svm, INTERCEPT_GP_VECTOR);
 
 	svm_set_intercept(svm, INTERCEPT_INTR);
 	svm_set_intercept(svm, INTERCEPT_NMI);
@@ -1093,7 +1093,7 @@ static void init_vmcb(struct vcpu_svm *svm)
 		/* Setup VMCB for Nested Paging */
 		control->nested_ctl |= SVM_NESTED_CTL_NP_ENABLE;
 		svm_clr_intercept(svm, INTERCEPT_INVLPG);
-		clr_exception_intercept(svm, INTERCEPT_PF_VECTOR);
+		svm_clr_intercept(svm, INTERCEPT_PF_VECTOR);
 		svm_clr_intercept(svm, INTERCEPT_CR3_READ);
 		svm_clr_intercept(svm, INTERCEPT_CR3_WRITE);
 		save->g_pat = svm->vcpu.arch.pat;
@@ -1135,7 +1135,7 @@ static void init_vmcb(struct vcpu_svm *svm)
 
 	if (sev_guest(svm->vcpu.kvm)) {
 		svm->vmcb->control.nested_ctl |= SVM_NESTED_CTL_SEV_ENABLE;
-		clr_exception_intercept(svm, INTERCEPT_UD_VECTOR);
+		svm_clr_intercept(svm, INTERCEPT_UD_VECTOR);
 	}
 
 	vmcb_mark_all_dirty(svm->vmcb);
@@ -1646,11 +1646,11 @@ static void update_exception_bitmap(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	clr_exception_intercept(svm, INTERCEPT_BP_VECTOR);
+	svm_clr_intercept(svm, INTERCEPT_BP_VECTOR);
 
 	if (vcpu->guest_debug & KVM_GUESTDBG_ENABLE) {
 		if (vcpu->guest_debug & KVM_GUESTDBG_USE_SW_BP)
-			set_exception_intercept(svm, INTERCEPT_BP_VECTOR);
+			svm_set_intercept(svm, INTERCEPT_BP_VECTOR);
 	}
 }
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 8128bac75fa2..fc4bfea3f555 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -261,24 +261,6 @@ static inline void clr_dr_intercepts(struct vcpu_svm *svm)
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
 static inline void svm_set_intercept(struct vcpu_svm *svm, int bit)
 {
 	struct vmcb *vmcb = get_host_vmcb(svm);

