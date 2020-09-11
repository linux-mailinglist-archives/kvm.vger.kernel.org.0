Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD4D2668E0
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 21:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725860AbgIKT30 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 15:29:26 -0400
Received: from mail-dm6nam12on2052.outbound.protection.outlook.com ([40.107.243.52]:48352
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725932AbgIKT24 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Sep 2020 15:28:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aG2Tll2pzNN+ENNmFpwX6AC19H/r0ee+shEZldZnAlsYBxzRnIlQOBv7NGT8LYI1M3J/yt+xXRaW3xUYBfrKzndZxwVaVvd+p4YDacoafcP8Rb3jbyNFNZz7Vf5BxCPCNDyxp5WXXR0EOYAiN3IPERhaOjA49D0MamKC5wgj0YCgOlUV/hcRNLVc6kdal+ddn7ztqElw5qwpnjb068vR9Pzku1GtU+ykG7iePy9RlDdoSw+SbD990T9EjF+aVQlJsQGK8wHD89Ow17E1BpKxCwNbEPn5WY9kBvcSXBZ0wXf8lMdceCdlJwPFjxzKezjrMCZujSNGCg/sVLYAEPoQ7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AL+2BO66nGX6+M1cLiCu3XKZ7Z3ha+Wor8cAKP1WRVQ=;
 b=nBdzrEnjkWb97MvUzDxXdH+H/e3raU4v/6BnOowNFeQDytea5j+PKKks7BIgGAn4DUSP75fE4N4ayuTZOqNDFz62iaqucB6aiiHuReXSRtABO4pUZEw7XmQBcHkfHEe7QmgVLe1JEnD8kqb/i4CDYAF0Bxpivo5KHycaIVlNLdwz9LcbJ389itT9E36PH1wMP3dRjKk0+0UwCcvouzkVCb2vCy6csmndVXdnC+6hOav8f/JEOeMapd21J4xfL6SZez0OTzwJglWMVCpt2sYO/l1SN/SEKQemqqLaYoyg6ppoISCbVnwcgkB5a9wCph6IaaCzq4tkeTj3BFa7hRO9FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AL+2BO66nGX6+M1cLiCu3XKZ7Z3ha+Wor8cAKP1WRVQ=;
 b=PeMFZ3ETDNsjReAFbg8sqeQPPhZbarVcodMgvg9COme3FCF9x9zDWavhs/k2XlqfC2BjcCZ0BTD3UFMZAvqUgXSnGVpXkPnj01Iiq9yfYPg/S2tkndfaB0QVsWVQizxyDBgvf+doZu2mEkSwtUOyNuV1qzT+zMaULY/s40aeNNo=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SA0PR12MB4543.namprd12.prod.outlook.com (2603:10b6:806:9d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Fri, 11 Sep
 2020 19:28:23 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d%4]) with mapi id 15.20.3370.017; Fri, 11 Sep 2020
 19:28:22 +0000
Subject: [PATCH v6 04/12] KVM: SVM: Modify intercept_exceptions to generic
 intercepts
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, jmattson@google.com
Cc:     wanpengli@tencent.com, kvm@vger.kernel.org, joro@8bytes.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, babu.moger@amd.com,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, tglx@linutronix.de
Date:   Fri, 11 Sep 2020 14:28:20 -0500
Message-ID: <159985250037.11252.1361972528657052410.stgit@bmoger-ubuntu>
In-Reply-To: <159985237526.11252.1516487214307300610.stgit@bmoger-ubuntu>
References: <159985237526.11252.1516487214307300610.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR21CA0002.namprd21.prod.outlook.com
 (2603:10b6:3:ac::12) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by DM5PR21CA0002.namprd21.prod.outlook.com (2603:10b6:3:ac::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.3 via Frontend Transport; Fri, 11 Sep 2020 19:28:21 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2f3c5257-7ce8-4398-12c8-08d85688d8e9
X-MS-TrafficTypeDiagnostic: SA0PR12MB4543:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB45434EA77CCAFBB11248C30D95240@SA0PR12MB4543.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yEIFpCZeinqkYtYtortozdt5uBBA5tcNWdHf9ivIMEmh550KXyffJkmWi24SpYtl8D28eYn/PpDFJGrjjfliupbDzd35CxcN5k8blOwBM3DxywWIk6gFnMzZTmaegDwHxEoC8q0pPzSmY8UKcdcLeX6QU9NFHxWF9JRL7CK3UeF4FKJxMz5GPyCntv/nidV8ZIZMbK0gFJRp7/37kxLL2bhtbrg58mtjJrhhuAYhozIAirdd7Tlkc1insf9565XNqmKXurOK547A6+2vcQ0hu8HPLNfnt1oNOeiPPyJ5ypESB2ik8T8WRobS0veYlAjnNiaC2nF77X/CoC2quRCQECMk1Z2bStS0/TDTM6mb3M5VpxSJOp/rPv96yCsmCDwd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(376002)(136003)(346002)(366004)(39860400002)(396003)(2906002)(956004)(66946007)(66476007)(103116003)(8676002)(66556008)(52116002)(5660300002)(7416002)(9686003)(4326008)(8936002)(44832011)(186003)(16526019)(86362001)(33716001)(16576012)(6486002)(316002)(478600001)(26005)(83380400001)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 4xtVsTswC3Iwp3mfSTjWS7J812DuJGwVqWsilaWqQvjhS1nzEJim6VemQ6LtxeQWu63gWY/RMB8Gt1y0v1/xIw9DQ2RdtbyU9eCQZ1bg8hFP8eEGvY+c9Von4eVq6jYjMA0kt97zMAKurithVM9W7gvwqLdNe42Z5Csdc9TbjaARAlBnduvUEkA/XjPlEre1PIVIZCtyLSxcGJgcC6pyGmzuHbjgiP3wbVWkccMN+9a/wKPoLB6RFAyrQNyw+QwB+VTeClp8KZDkyzumel7ncFbHrrLzkKUeklDDjsMhCAbbEontdhU9bV2z9jYF8CoSqjFMwLZqNNIuaJ89H2r0JBUWaPxqVXZlaELaeyfjy1TCZ7h12CVZFN6+irREOQj+BnOc7WW7GPZcilVho4/bWRMiAjoayKtzJai9AyA5eFTXFzOPpFuL76nce69pqcfN3QigTZ0rKW/8YJzuAUJpKiin+hbeWCe3NhIbmbcqsIJTAGSeS4xXnbqEK+fQvKatNuaKGKaF0JctKSBFQSfFp3rWFJmmJ9TT8zt2zEj9VGjyTyFwSZWHbpb5/+oyF6vQNsYgOGbwcJWFNtz6yMgeb0HbDFClN51udDDmE6+mwMrh3Zx5a14+b/e45zIaTc5Ju1UPVVVv7FDCNeluF0CGGg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f3c5257-7ce8-4398-12c8-08d85688d8e9
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2020 19:28:22.8978
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZxvxJYxIig4UmT8fxKWOj1a+OWl4xcYQ2Hv0yf13jR87n4KVCjz1N+bb0sb2rASh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4543
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Modify intercept_exceptions to generic intercepts in vmcb_control_area. Use
the generic vmcb_set_intercept, vmcb_clr_intercept and vmcb_is_intercept to
set/clear/test the intercept_exceptions bits.

Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/include/asm/svm.h |   22 +++++++++++++++++++++-
 arch/x86/kvm/svm/nested.c  |   12 +++++-------
 arch/x86/kvm/svm/svm.c     |   22 +++++++++++-----------
 arch/x86/kvm/svm/svm.h     |    4 ++--
 4 files changed, 39 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index ffc89d8e4fcb..51833a611eba 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -3,6 +3,7 @@
 #define __SVM_H
 
 #include <uapi/asm/svm.h>
+#include <uapi/asm/kvm.h>
 
 /*
  * VMCB Control Area intercept bits starting
@@ -12,6 +13,7 @@
 enum vector_offset {
 	CR_VECTOR = 0,
 	DR_VECTOR,
+	EXCEPTION_VECTOR,
 	MAX_VECTORS,
 };
 
@@ -52,6 +54,25 @@ enum {
 	INTERCEPT_DR5_WRITE,
 	INTERCEPT_DR6_WRITE,
 	INTERCEPT_DR7_WRITE,
+	/* Byte offset 008h (Vector 2) */
+	INTERCEPT_DE_VECTOR = 64 + DE_VECTOR,
+	INTERCEPT_DB_VECTOR = 64 + DB_VECTOR,
+	INTERCEPT_BP_VECTOR = 64 + BP_VECTOR,
+	INTERCEPT_OF_VECTOR = 64 + OF_VECTOR,
+	INTERCEPT_BR_VECTOR = 64 + BR_VECTOR,
+	INTERCEPT_UD_VECTOR = 64 + UD_VECTOR,
+	INTERCEPT_NM_VECTOR = 64 + NM_VECTOR,
+	INTERCEPT_DF_VECTOR = 64 + DF_VECTOR,
+	INTERCEPT_TS_VECTOR = 64 + TS_VECTOR,
+	INTERCEPT_NP_VECTOR = 64 + NP_VECTOR,
+	INTERCEPT_SS_VECTOR = 64 + SS_VECTOR,
+	INTERCEPT_GP_VECTOR = 64 + GP_VECTOR,
+	INTERCEPT_PF_VECTOR = 64 + PF_VECTOR,
+	INTERCEPT_MF_VECTOR = 64 + MF_VECTOR,
+	INTERCEPT_AC_VECTOR = 64 + AC_VECTOR,
+	INTERCEPT_MC_VECTOR = 64 + MC_VECTOR,
+	INTERCEPT_XM_VECTOR = 64 + XM_VECTOR,
+	INTERCEPT_VE_VECTOR = 64 + VE_VECTOR,
 };
 
 enum {
@@ -107,7 +128,6 @@ enum {
 
 struct __attribute__ ((__packed__)) vmcb_control_area {
 	u32 intercepts[MAX_VECTORS];
-	u32 intercept_exceptions;
 	u64 intercept;
 	u8 reserved_1[40];
 	u16 pause_filter_thresh;
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index ba11fc3bf843..c161bd38f401 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -109,12 +109,11 @@ void recalc_intercepts(struct vcpu_svm *svm)
 	h = &svm->nested.hsave->control;
 	g = &svm->nested.ctl;
 
-	svm->nested.host_intercept_exceptions = h->intercept_exceptions;
+	svm->nested.host_intercept_exceptions = h->intercepts[EXCEPTION_VECTOR];
 
 	for (i = 0; i < MAX_VECTORS; i++)
 		c->intercepts[i] = h->intercepts[i];
 
-	c->intercept_exceptions = h->intercept_exceptions;
 	c->intercept = h->intercept;
 
 	if (g->int_ctl & V_INTR_MASKING_MASK) {
@@ -136,7 +135,6 @@ void recalc_intercepts(struct vcpu_svm *svm)
 	for (i = 0; i < MAX_VECTORS; i++)
 		c->intercepts[i] |= g->intercepts[i];
 
-	c->intercept_exceptions |= g->intercept_exceptions;
 	c->intercept |= g->intercept;
 }
 
@@ -148,7 +146,6 @@ static void copy_vmcb_control_area(struct vmcb_control_area *dst,
 	for (i = 0; i < MAX_VECTORS; i++)
 		dst->intercepts[i] = from->intercepts[i];
 
-	dst->intercept_exceptions = from->intercept_exceptions;
 	dst->intercept            = from->intercept;
 	dst->iopm_base_pa         = from->iopm_base_pa;
 	dst->msrpm_base_pa        = from->msrpm_base_pa;
@@ -495,7 +492,7 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
 
 	trace_kvm_nested_intercepts(nested_vmcb->control.intercepts[CR_VECTOR] & 0xffff,
 				    nested_vmcb->control.intercepts[CR_VECTOR] >> 16,
-				    nested_vmcb->control.intercept_exceptions,
+				    nested_vmcb->control.intercepts[EXCEPTION_VECTOR],
 				    nested_vmcb->control.intercept);
 
 	/* Clear internal status */
@@ -835,7 +832,7 @@ static bool nested_exit_on_exception(struct vcpu_svm *svm)
 {
 	unsigned int nr = svm->vcpu.arch.exception.nr;
 
-	return (svm->nested.ctl.intercept_exceptions & (1 << nr));
+	return (svm->nested.ctl.intercepts[EXCEPTION_VECTOR] & BIT(nr));
 }
 
 static void nested_svm_inject_exception_vmexit(struct vcpu_svm *svm)
@@ -984,7 +981,8 @@ int nested_svm_exit_special(struct vcpu_svm *svm)
 	case SVM_EXIT_EXCP_BASE ... SVM_EXIT_EXCP_BASE + 0x1f: {
 		u32 excp_bits = 1 << (exit_code - SVM_EXIT_EXCP_BASE);
 
-		if (get_host_vmcb(svm)->control.intercept_exceptions & excp_bits)
+		if (get_host_vmcb(svm)->control.intercepts[EXCEPTION_VECTOR] &
+				excp_bits)
 			return NESTED_EXIT_HOST;
 		else if (exit_code == SVM_EXIT_EXCP_BASE + PF_VECTOR &&
 			 svm->vcpu.arch.apf.host_apf_flags)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 1a5f3908b388..11892e86cb39 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1003,11 +1003,11 @@ static void init_vmcb(struct vcpu_svm *svm)
 
 	set_dr_intercepts(svm);
 
-	set_exception_intercept(svm, PF_VECTOR);
-	set_exception_intercept(svm, UD_VECTOR);
-	set_exception_intercept(svm, MC_VECTOR);
-	set_exception_intercept(svm, AC_VECTOR);
-	set_exception_intercept(svm, DB_VECTOR);
+	set_exception_intercept(svm, INTERCEPT_PF_VECTOR);
+	set_exception_intercept(svm, INTERCEPT_UD_VECTOR);
+	set_exception_intercept(svm, INTERCEPT_MC_VECTOR);
+	set_exception_intercept(svm, INTERCEPT_AC_VECTOR);
+	set_exception_intercept(svm, INTERCEPT_DB_VECTOR);
 	/*
 	 * Guest access to VMware backdoor ports could legitimately
 	 * trigger #GP because of TSS I/O permission bitmap.
@@ -1015,7 +1015,7 @@ static void init_vmcb(struct vcpu_svm *svm)
 	 * as VMware does.
 	 */
 	if (enable_vmware_backdoor)
-		set_exception_intercept(svm, GP_VECTOR);
+		set_exception_intercept(svm, INTERCEPT_GP_VECTOR);
 
 	svm_set_intercept(svm, INTERCEPT_INTR);
 	svm_set_intercept(svm, INTERCEPT_NMI);
@@ -1093,7 +1093,7 @@ static void init_vmcb(struct vcpu_svm *svm)
 		/* Setup VMCB for Nested Paging */
 		control->nested_ctl |= SVM_NESTED_CTL_NP_ENABLE;
 		svm_clr_intercept(svm, INTERCEPT_INVLPG);
-		clr_exception_intercept(svm, PF_VECTOR);
+		clr_exception_intercept(svm, INTERCEPT_PF_VECTOR);
 		clr_cr_intercept(svm, INTERCEPT_CR3_READ);
 		clr_cr_intercept(svm, INTERCEPT_CR3_WRITE);
 		save->g_pat = svm->vcpu.arch.pat;
@@ -1135,7 +1135,7 @@ static void init_vmcb(struct vcpu_svm *svm)
 
 	if (sev_guest(svm->vcpu.kvm)) {
 		svm->vmcb->control.nested_ctl |= SVM_NESTED_CTL_SEV_ENABLE;
-		clr_exception_intercept(svm, UD_VECTOR);
+		clr_exception_intercept(svm, INTERCEPT_UD_VECTOR);
 	}
 
 	vmcb_mark_all_dirty(svm->vmcb);
@@ -1646,11 +1646,11 @@ static void update_exception_bitmap(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	clr_exception_intercept(svm, BP_VECTOR);
+	clr_exception_intercept(svm, INTERCEPT_BP_VECTOR);
 
 	if (vcpu->guest_debug & KVM_GUESTDBG_ENABLE) {
 		if (vcpu->guest_debug & KVM_GUESTDBG_USE_SW_BP)
-			set_exception_intercept(svm, BP_VECTOR);
+			set_exception_intercept(svm, INTERCEPT_BP_VECTOR);
 	}
 }
 
@@ -2817,7 +2817,7 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 	pr_err("%-20s%04x\n", "cr_write:", control->intercepts[CR_VECTOR] >> 16);
 	pr_err("%-20s%04x\n", "dr_read:", control->intercepts[DR_VECTOR] & 0xffff);
 	pr_err("%-20s%04x\n", "dr_write:", control->intercepts[DR_VECTOR] >> 16);
-	pr_err("%-20s%08x\n", "exceptions:", control->intercept_exceptions);
+	pr_err("%-20s%08x\n", "exceptions:", control->intercepts[EXCEPTION_VECTOR]);
 	pr_err("%-20s%016llx\n", "intercepts:", control->intercept);
 	pr_err("%-20s%d\n", "pause filter count:", control->pause_filter_count);
 	pr_err("%-20s%d\n", "pause filter threshold:",
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index d3b34e0276c5..2fc305f647a3 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -291,7 +291,7 @@ static inline void set_exception_intercept(struct vcpu_svm *svm, int bit)
 {
 	struct vmcb *vmcb = get_host_vmcb(svm);
 
-	vmcb->control.intercept_exceptions |= (1U << bit);
+	vmcb_set_intercept(&vmcb->control, bit);
 
 	recalc_intercepts(svm);
 }
@@ -300,7 +300,7 @@ static inline void clr_exception_intercept(struct vcpu_svm *svm, int bit)
 {
 	struct vmcb *vmcb = get_host_vmcb(svm);
 
-	vmcb->control.intercept_exceptions &= ~(1U << bit);
+	vmcb_clr_intercept(&vmcb->control, bit);
 
 	recalc_intercepts(svm);
 }

