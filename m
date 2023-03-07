Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE80E6AEB2E
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 18:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232035AbjCGRlC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 12:41:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232034AbjCGRkk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 12:40:40 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35E81A54C1
        for <kvm@vger.kernel.org>; Tue,  7 Mar 2023 09:36:51 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id la3-20020a170902fa0300b0019ca5ddecedso8004743plb.1
        for <kvm@vger.kernel.org>; Tue, 07 Mar 2023 09:36:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678210610;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PxpL9SaKPLHbA1QJI98FYZl3BCCEz9LLYkrnEJ9FjEs=;
        b=e1fzQlSnDJCAcz4K9UBRHdg0rSfo66vsFG7yP3aQFTzXqFznVEGMz8KeRdUQulyF7k
         J7jAl/bQMfOaOcqJSj/qsL16y7lrF8Qtq6dp3GRaXN7nUANPlsJDDNX8H6onGWZMLZ1Q
         ojjvxdsDy25LxoEZOifEcDtE8W/WILkWax7uM10ZO4aRo+ikeGbrH+mSDT07UcQR/SqJ
         +TMoK2tjcJ7vaK44JDVzOR5FfmqeRkFfxod7YiwpvODGttvbt4QWrlh1k029nhWxyuzV
         D+NaRtV3MH4UdBCAFjyWs6aOZAf8JPKbwerIQJcreV+HAhDiZ71sKtidlp3v/BhzD9C3
         Qe3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678210610;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PxpL9SaKPLHbA1QJI98FYZl3BCCEz9LLYkrnEJ9FjEs=;
        b=uFMjm/zHjDh1fWapufHUclxJEvVk3q9k83AbLbjPWvexi1JHZdTm/v9zOWDjiN0iRG
         hEDq0KYY/4Ens0010WQL6ftxKJMbDsm7d39/aBBWYzEfyJqY4RV1xxYR/sRMIf5J+sg6
         xjxxrU8OCa6pf/GU6lnZBObiN3Jq/qc+zDU1C459cfhKh8eYubg59DU2FkdgUIo8NQDB
         lNMyjUb3vQqrVWtYp8fq83cF3sguQ8buRlWGvQReCWCPmWi5PNJhTX6DS615GuMUJwG/
         6ejxfeFgFtPyn7dZxKtwDjY4LE1fZCDAaDqglFCAw5jkwyCww53IacWu/D7S//jur/pl
         oJHA==
X-Gm-Message-State: AO0yUKX22qC+h1fyGxw3/X829tK7pdAd4v/cLVRLDRD3GCyyhoJ7j929
        br1UZz8aIlDXDKU7IiKw2d35/AAl4Ho=
X-Google-Smtp-Source: AK7set9sNtzP9C+hlG/N8yqWacbflBWRYd1F0puMDP8ANixRXK41/z2vt1aEJdT3a0zQwl4kkns17hbDW7g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:7453:0:b0:503:bb5:4cec with SMTP id
 e19-20020a637453000000b005030bb54cecmr5528891pgn.7.1678210610636; Tue, 07 Mar
 2023 09:36:50 -0800 (PST)
Date:   Tue, 7 Mar 2023 09:36:49 -0800
In-Reply-To: <20230227171751.1211786-1-jpiotrowski@linux.microsoft.com>
Mime-Version: 1.0
References: <20230227171751.1211786-1-jpiotrowski@linux.microsoft.com>
Message-ID: <ZAd2MRNLw1JAXmOf@google.com>
Subject: Re: [PATCH] KVM: SVM: Disable TDP MMU when running on Hyper-V
From:   Sean Christopherson <seanjc@google.com>
To:     Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tianyu Lan <ltykernel@gmail.com>,
        Michael Kelley <mikelley@microsoft.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 27, 2023, Jeremi Piotrowski wrote:
> Disable TDP MMU when using SVM Hyper-V for the time being while we
> search for a better fix.

...

> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index c91ee2927dd7..5c0e28a7a3bc 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5787,14 +5787,15 @@ void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid)
>  }
>  
>  void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
> -		       int tdp_max_root_level, int tdp_huge_page_level)
> +		       int tdp_max_root_level, int tdp_huge_page_level,
> +		       bool enable_tdp_mmu)
>  {
>  	tdp_enabled = enable_tdp;
>  	tdp_root_level = tdp_forced_root_level;
>  	max_tdp_level = tdp_max_root_level;
>  
>  #ifdef CONFIG_X86_64
> -	tdp_mmu_enabled = tdp_mmu_allowed && tdp_enabled;
> +	tdp_mmu_enabled = tdp_mmu_allowed && tdp_enabled && enable_tdp_mmu;
>  #endif

Thinking about this more, I would rather revert commit 1e0c7d40758b ("KVM: SVM:
hyper-v: Remote TLB flush for SVM") or fix the thing properly straitaway.  KVM
doesn't magically handle the flushes correctly for the shadow/legacy MMU, KVM just
happens to get lucky and not run afoul of the underlying bugs.  The revert appears
to be reasonably straightforward (see bottom).

And _if_ we want to hack-a-fix it, then I would strongly prefer a very isolated,
obviously hacky fix, e.g.

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 36e4561554ca..a9ba4ae14fda 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5779,8 +5779,13 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
        tdp_root_level = tdp_forced_root_level;
        max_tdp_level = tdp_max_root_level;
 
+       /*
+        * FIXME: Remove the enlightened TLB restriction when KVM properly
+        * handles TLB flushes for said enlightenment.
+        */.
 #ifdef CONFIG_X86_64
-       tdp_mmu_enabled = tdp_mmu_allowed && tdp_enabled;
+       tdp_mmu_enabled = tdp_mmu_allowed && tdp_enabled &&
+                         !(ms_hyperv.nested_features & HV_X64_NESTED_ENLIGHTENED_TLB);
 #endif
        /*
         * max_huge_page_level reflects KVM's MMU capabilities irrespective




The revert...

---
 arch/x86/kvm/svm/svm.c          |  3 ---
 arch/x86/kvm/svm/svm_onhyperv.h | 27 ---------------------------
 2 files changed, 30 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 11068e8eb969..292650dc85a0 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1320,7 +1320,6 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 	if (sev_guest(vcpu->kvm))
 		sev_init_vmcb(svm);
 
-	svm_hv_init_vmcb(vmcb);
 	init_vmcb_after_set_cpuid(vcpu);
 
 	vmcb_mark_all_dirty(vmcb);
@@ -4075,8 +4074,6 @@ static void svm_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 		svm->vmcb->control.nested_cr3 = __sme_set(root_hpa);
 		vmcb_mark_dirty(svm->vmcb, VMCB_NPT);
 
-		hv_track_root_tdp(vcpu, root_hpa);
-
 		cr3 = vcpu->arch.cr3;
 	} else if (root_level >= PT64_ROOT_4LEVEL) {
 		cr3 = __sme_set(root_hpa) | kvm_get_active_pcid(vcpu);
diff --git a/arch/x86/kvm/svm/svm_onhyperv.h b/arch/x86/kvm/svm/svm_onhyperv.h
index 6981c1e9a809..5118fd273e73 100644
--- a/arch/x86/kvm/svm/svm_onhyperv.h
+++ b/arch/x86/kvm/svm/svm_onhyperv.h
@@ -15,31 +15,8 @@ static struct kvm_x86_ops svm_x86_ops;
 
 int svm_hv_enable_l2_tlb_flush(struct kvm_vcpu *vcpu);
 
-static inline void svm_hv_init_vmcb(struct vmcb *vmcb)
-{
-	struct hv_vmcb_enlightenments *hve = &vmcb->control.hv_enlightenments;
-
-	BUILD_BUG_ON(sizeof(vmcb->control.hv_enlightenments) !=
-		     sizeof(vmcb->control.reserved_sw));
-
-	if (npt_enabled &&
-	    ms_hyperv.nested_features & HV_X64_NESTED_ENLIGHTENED_TLB)
-		hve->hv_enlightenments_control.enlightened_npt_tlb = 1;
-
-	if (ms_hyperv.nested_features & HV_X64_NESTED_MSR_BITMAP)
-		hve->hv_enlightenments_control.msr_bitmap = 1;
-}
-
 static inline void svm_hv_hardware_setup(void)
 {
-	if (npt_enabled &&
-	    ms_hyperv.nested_features & HV_X64_NESTED_ENLIGHTENED_TLB) {
-		pr_info(KBUILD_MODNAME ": Hyper-V enlightened NPT TLB flush enabled\n");
-		svm_x86_ops.tlb_remote_flush = hv_remote_flush_tlb;
-		svm_x86_ops.tlb_remote_flush_with_range =
-				hv_remote_flush_tlb_with_range;
-	}
-
 	if (ms_hyperv.nested_features & HV_X64_NESTED_DIRECT_FLUSH) {
 		int cpu;
 
@@ -80,10 +57,6 @@ static inline void svm_hv_update_vp_id(struct vmcb *vmcb, struct kvm_vcpu *vcpu)
 }
 #else
 
-static inline void svm_hv_init_vmcb(struct vmcb *vmcb)
-{
-}
-
 static inline void svm_hv_hardware_setup(void)
 {
 }

base-commit: cb8748a781fe983e451f616ce4861a1c49ce79dd
-- 

