Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5BF25380A
	for <lists+kvm@lfdr.de>; Wed, 26 Aug 2020 21:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbgHZTPX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Aug 2020 15:15:23 -0400
Received: from mail-bn7nam10on2042.outbound.protection.outlook.com ([40.107.92.42]:11707
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727926AbgHZTPF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Aug 2020 15:15:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f6cOnFj95mK2T0e3Xx+D3rKH2XX2/AAIbG/WWWqYgyffzNX4EnuWYolk534DpioqRLE1vvjLRGjo6cHEgk3jsD+Zn58s4atlw9P8/VlNIMtlJJZEREtW47U8lP6uQ3jEQdLh+oCC6sK6js9eAMxyxaneJA9DK3KKeK0bq56Sf2/Jd/LxfZ4FyWscM/eJWu5M90lra/If81c4Z2sTRV9Er/8LVQW+0I4RztOlgD2ZCzI+sN1hzxN+4Af7J2sD9sAnCvYCx2GtanrDdVvtaiDXWdC4LdV1o9mzN4NgdaDMXQhglGHgNeXFN3BH1zWEY/ULFDZFAOvDOj6g+vu/YYKpIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aUE9LovJnl2mai/pRtM6NHspDACFry7Dmota7pTHAcA=;
 b=TvcbFXbQHaJZCPw+TcYzl548pJmDX9+umczAPt25o5q2FulgHd2OgbRRzOO2c3WQlwhhviBERU1Ze4iPSbLZnY9d8n8G0przz0dJHkdOfx2jbSBLIMNWpyBUd8trV58TuKJ8P1aIDqX0DbrNelINYF6O+2TRmEP5yIDfGuyG8BwSmM49A2y+yqBl0FsWOIl807nxDO5RDd8aMrI/g6G41DHssvvMYZXcgaPgRhXy5U0YRCJ/s225qdP9hMMyDpiG0OLJAL95S4BgKNY6u2P7Q7z8oIgh4BOHvXMKAeJzLcCbIkNxXN79bCWpVg6HvzStNElP5DjU8ROQabvxYO7+fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aUE9LovJnl2mai/pRtM6NHspDACFry7Dmota7pTHAcA=;
 b=YAZc+znH71xlrWaDuC7IsQIdEKrITAwLiMEbFfO6k1LqWKw8v0B0d1GEil9MkxFkbJ35xnggH7mQXG2/hwmUpgkXMGyhe0SI7PFujbV+Qnb1DvVJJyLaTGg4iPKxLYsJdGsyiYj+EEfLAKcGhA2Wd8z3hob65M+XH32J5JN4T3w=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2461.namprd12.prod.outlook.com (2603:10b6:802:27::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19; Wed, 26 Aug
 2020 19:14:56 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d%4]) with mapi id 15.20.3305.026; Wed, 26 Aug 2020
 19:14:56 +0000
Subject: [PATCH v5 09/12] KVM: SVM: Remove set_exception_intercept and
 clr_exception_intercept
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, jmattson@google.com
Cc:     wanpengli@tencent.com, kvm@vger.kernel.org, joro@8bytes.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, babu.moger@amd.com,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, tglx@linutronix.de
Date:   Wed, 26 Aug 2020 14:14:52 -0500
Message-ID: <159846929287.18873.881746433536011970.stgit@bmoger-ubuntu>
In-Reply-To: <159846887637.18873.14677728679411578606.stgit@bmoger-ubuntu>
References: <159846887637.18873.14677728679411578606.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR03CA0007.namprd03.prod.outlook.com
 (2603:10b6:5:40::20) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by DM6PR03CA0007.namprd03.prod.outlook.com (2603:10b6:5:40::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Wed, 26 Aug 2020 19:14:54 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 09be53a0-5427-40e2-26d4-08d849f45156
X-MS-TrafficTypeDiagnostic: SN1PR12MB2461:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2461680ECDE5C5B83A30820695540@SN1PR12MB2461.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:224;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 92Gt4SMksu/mETBovjwDXrlXS36B+WwIP+Z6xR1Q/jsDPO90xtITihgGjRXaih4xFnJk2JnDxARIKeakW/aEUns4t6kKUjuUSLV2DdcPNkHhN6MA1h5ys1qFzH5Q3D2CTDjhPN4bc5WJ7mdmLXFHI260Ml7T1wSb/nQFlRhrbvjbH9omPJHGuYc6nKTJG36helgDiHrirsYFJliq+Eezfqo9X7bN+gN1Iv25qxmHmuIrvoTHn2xxms4HSNF7eGzXg4F4BV3nkK6LixNcJ1fI3Xir1yyZH6A5aji+WdEGqRBp0l9NYqm4HNbBETYXsedA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(346002)(376002)(136003)(39860400002)(396003)(366004)(956004)(44832011)(66556008)(8936002)(66946007)(66476007)(16576012)(9686003)(7416002)(26005)(478600001)(6486002)(186003)(86362001)(52116002)(8676002)(316002)(5660300002)(4326008)(83380400001)(2906002)(33716001)(103116003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: rvLTm60XuqW/52DOvf2V+8jKNzrtvdHxutFYc5AJ4etJGap5HPyxKK6oP2SlvznClD73xIqxMFYeg3lRZrpWEHiELU3jJPz4yzsLkuUMp5LMNHhQZrPt4YZdbjkrKy2ee67una8v74PD9C5BRahCCCW0suhDmWCD7uwXTqn3UssS11DlCSUeQ5v0NhSR9klbrNUZT/Ng7TViTNAM4lNjR4GoS20/T+95rubPcPLDJMq8Kxl78iftgX1pHDxCWLtLUjp5x5GqH8UIm73JHjLJSah+P70JWBTMXYUwaBSmARljaKuN8F3wgQ8azbginF2Px4PMC7T68EsMAwNxWh+GYWfHi5OEC1int0CdLbwM4w+2Kkd1e06iTWbuBMEPikHEMrk1r1hv4I8ziRk8npD2m6qZobtsAV2psEaQkjLGIUOJ7lI3XTdNnZJ700y79Hrn4JTdRghD5qELgJo90YTaE/XFlismUkzhp3cjIn5ZR8pDAz4apCRtyMc2dQBjS6NMcYpdtCetcp1OAxr1eT2x+zFXEt4dLZCWwNLhJi1S9Ay9tbBujZnWIie9wkeAWcn3Uu2copasZC+3HJdNc2nT59nB2/MFQsrrFDwSv92B+hxDE3et1YGX8X/6ayafq8i8GkzBkofP5qS3VvCpWD+dVg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09be53a0-5427-40e2-26d4-08d849f45156
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2020 19:14:55.9602
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: twgQ2e1H2+d95GC3XGzNXRxIPCaAgTkeKARKCT6SSobfepL1tpPn/oTW1XW8JERH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2461
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

