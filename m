Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 440BB53FAB9
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 12:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240579AbiFGKDA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 06:03:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240606AbiFGKCu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 06:02:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4468D167C9
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 03:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654596165;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Rlv4Alm+cT0A3ogupq9M3TCiEAF1n3lAydUxVZu1ORg=;
        b=Fri75EiFjntZIgV3SXVd3HYCCZk5FtutysrZqpg4yIqu5BAwq3SUty89hrzb12611dE9Qs
        ym4Ffqi2Fjv3v13eYDovSCO9Oyp5XavyVzPLYqNBQIR50Qr3kbBnrtJGRavQs2MGBVowAI
        9fXkpLndWhjuTuVMeXRy5CFvzyQ9D4E=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-588-26b0J28rMwunEfl9b31KWw-1; Tue, 07 Jun 2022 06:02:42 -0400
X-MC-Unique: 26b0J28rMwunEfl9b31KWw-1
Received: by mail-qv1-f71.google.com with SMTP id v15-20020ad4554f000000b004646455c054so10516713qvy.10
        for <kvm@vger.kernel.org>; Tue, 07 Jun 2022 03:02:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Rlv4Alm+cT0A3ogupq9M3TCiEAF1n3lAydUxVZu1ORg=;
        b=ZpSPtj/6krsP0EQwQHvRK6pRQzZCWH2iu+moqWiR1vQ+60bHh25A/dobbmJ7Quhaeh
         rV9+w3R+J/FIojnfLsyKyWii62IjLOR8JJ2Mjc/1gARRfMRa791TNleHm6HTFeoT0BF7
         obluoOu8ugevK9trs97vvqwGsi9w+vES/ElbvOA5lnJjodotMtA6rfC18OkRLpNJPEWN
         9GMxR3XMZpheNKsQF6bPYuYwcho3T5uCB/wJHeUjO+appd6yEB/5UEBbRSWL5DrEEyjV
         Rz0sTHW7bbuw995ejczZoAq5InN0fDQI8i2uF4A/+TRdxySHj84+pUaip4W+ZDl0ZHzy
         gP1A==
X-Gm-Message-State: AOAM530kv/Zc38jL5hkbCOR/hem27T+ODn4Hfy+zqujqZUKN0qFS9dQR
        ku7SE8f9O2DqOLSoNKMXCnGubd59pNMsycMdfeNapVuHqk6eL+qga4wAksPmTXyN3vUdPPpUKnI
        9HrPbEJ/CpEZC
X-Received: by 2002:a37:8741:0:b0:6a6:2a43:ec8e with SMTP id j62-20020a378741000000b006a62a43ec8emr18140454qkd.398.1654596162351;
        Tue, 07 Jun 2022 03:02:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwJUTa1X4k9NyxPeAPG3vxia72+H61nxiRk2p5C0zJ+qktw4pirv4Lmfc/DbOet2ckCin2Rrw==
X-Received: by 2002:a37:8741:0:b0:6a6:2a43:ec8e with SMTP id j62-20020a378741000000b006a62a43ec8emr18140434qkd.398.1654596162041;
        Tue, 07 Jun 2022 03:02:42 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id t25-20020a05622a181900b00304c2c3d598sm12055788qtc.19.2022.06.07.03.02.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 03:02:40 -0700 (PDT)
Message-ID: <407ebb250e93f586d7a91e46ba562b325a51854d.camel@redhat.com>
Subject: Re: [PATCH v6 22/38] KVM: nSVM: hyper-v: Enable L2 TLB flush
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 07 Jun 2022 13:02:37 +0300
In-Reply-To: <20220606083655.2014609-23-vkuznets@redhat.com>
References: <20220606083655.2014609-1-vkuznets@redhat.com>
         <20220606083655.2014609-23-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-2.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-06-06 at 10:36 +0200, Vitaly Kuznetsov wrote:
> Implement Hyper-V L2 TLB flush for nSVM. The feature needs to be enabled
> both in extended 'nested controls' in VMCB and VP assist page.
> According to Hyper-V TLFS, synthetic vmexit to L1 is performed with
> - HV_SVM_EXITCODE_ENL exit_code.
> - HV_SVM_ENL_EXITCODE_TRAP_AFTER_FLUSH exit_info_1.
> 
> Note: VP assist page is cached in 'struct kvm_vcpu_hv' so
> recalc_intercepts() doesn't need to read from guest's memory. KVM
> needs to update the case upon each VMRUN and after svm_set_nested_state
> (svm_get_nested_state_pages()) to handle the case when the guest got
> migrated while L2 was running.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/svm/hyperv.c |  7 +++++++
>  arch/x86/kvm/svm/hyperv.h | 30 ++++++++++++++++++++++++++++++
>  arch/x86/kvm/svm/nested.c | 36 ++++++++++++++++++++++++++++++++++--
>  3 files changed, 71 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/hyperv.c b/arch/x86/kvm/svm/hyperv.c
> index 911f51021af1..088f6429b24c 100644
> --- a/arch/x86/kvm/svm/hyperv.c
> +++ b/arch/x86/kvm/svm/hyperv.c
> @@ -8,4 +8,11 @@
>  
>  void svm_hv_inject_synthetic_vmexit_post_tlb_flush(struct kvm_vcpu *vcpu)
>  {
> +       struct vcpu_svm *svm = to_svm(vcpu);
> +
> +       svm->vmcb->control.exit_code = HV_SVM_EXITCODE_ENL;
> +       svm->vmcb->control.exit_code_hi = 0;
> +       svm->vmcb->control.exit_info_1 = HV_SVM_ENL_EXITCODE_TRAP_AFTER_FLUSH;
> +       svm->vmcb->control.exit_info_2 = 0;
> +       nested_svm_vmexit(svm);
>  }
> diff --git a/arch/x86/kvm/svm/hyperv.h b/arch/x86/kvm/svm/hyperv.h
> index dd2e393f84a0..7b01722838bf 100644
> --- a/arch/x86/kvm/svm/hyperv.h
> +++ b/arch/x86/kvm/svm/hyperv.h
> @@ -33,6 +33,9 @@ struct hv_enlightenments {
>   */
>  #define VMCB_HV_NESTED_ENLIGHTENMENTS VMCB_SW
>  
> +#define HV_SVM_EXITCODE_ENL 0xF0000000
> +#define HV_SVM_ENL_EXITCODE_TRAP_AFTER_FLUSH   (1)
> +
>  static inline void nested_svm_hv_update_vm_vp_ids(struct kvm_vcpu *vcpu)
>  {
>         struct vcpu_svm *svm = to_svm(vcpu);
> @@ -48,6 +51,33 @@ static inline void nested_svm_hv_update_vm_vp_ids(struct kvm_vcpu *vcpu)
>         hv_vcpu->nested.vp_id = hve->hv_vp_id;
>  }
>  
> +static inline bool nested_svm_hv_update_vp_assist(struct kvm_vcpu *vcpu)
> +{
> +       if (!to_hv_vcpu(vcpu))
> +               return true;
> +
> +       if (!kvm_hv_assist_page_enabled(vcpu))
> +               return true;
> +
> +       return kvm_hv_get_assist_page(vcpu);
> +}
> +
> +static inline bool nested_svm_l2_tlb_flush_enabled(struct kvm_vcpu *vcpu)
> +{
> +       struct vcpu_svm *svm = to_svm(vcpu);
> +       struct hv_enlightenments *hve =
> +               (struct hv_enlightenments *)svm->nested.ctl.reserved_sw;
> +       struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
> +
> +       if (!hv_vcpu)
> +               return false;
> +
> +       if (!hve->hv_enlightenments_control.nested_flush_hypercall)
> +               return false;
> +
> +       return hv_vcpu->vp_assist_page.nested_control.features.directhypercall;
> +}
> +
>  void svm_hv_inject_synthetic_vmexit_post_tlb_flush(struct kvm_vcpu *vcpu);
>  
>  #endif /* __ARCH_X86_KVM_SVM_HYPERV_H__ */
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 28b63663e1d9..369b92aaf1ad 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -171,8 +171,12 @@ void recalc_intercepts(struct vcpu_svm *svm)
>                 vmcb_clr_intercept(c, INTERCEPT_VINTR);
>         }
>  
> -       /* We don't want to see VMMCALLs from a nested guest */
> -       vmcb_clr_intercept(c, INTERCEPT_VMMCALL);
> +       /*
> +        * We want to see VMMCALLs from a nested guest only when Hyper-V L2 TLB
> +        * flush feature is enabled.
> +        */
> +       if (!nested_svm_l2_tlb_flush_enabled(&svm->vcpu))
> +               vmcb_clr_intercept(c, INTERCEPT_VMMCALL);
>  
>         for (i = 0; i < MAX_INTERCEPT; i++)
>                 c->intercepts[i] |= g->intercepts[i];
> @@ -489,6 +493,17 @@ static void nested_save_pending_event_to_vmcb12(struct vcpu_svm *svm,
>  
>  static void nested_svm_transition_tlb_flush(struct kvm_vcpu *vcpu)
>  {
> +       /*
> +        * KVM_REQ_HV_TLB_FLUSH flushes entries from either L1's VP_ID or
> +        * L2's VP_ID upon request from the guest. Make sure we check for
> +        * pending entries for the case when the request got misplaced (e.g.
> +        * a transition from L2->L1 happened while processing L2 TLB flush
> +        * request or vice versa). kvm_hv_vcpu_flush_tlb() will not flush
> +        * anything if there are no requests in the corresponding buffer.
> +        */
> +       if (to_hv_vcpu(vcpu))
> +               kvm_make_request(KVM_REQ_HV_TLB_FLUSH, vcpu);
> +
>         /*
>          * TODO: optimize unconditional TLB flush/MMU sync.  A partial list of
>          * things to fix before this can be conditional:
> @@ -835,6 +850,12 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
>                 return 1;
>         }
>  
> +       /* This fails when VP assist page is enabled but the supplied GPA is bogus */
> +       if (!nested_svm_hv_update_vp_assist(vcpu)) {
> +               kvm_inject_gp(vcpu, 0);
> +               return 1;
> +       }
> +
>         vmcb12_gpa = svm->vmcb->save.rax;
>         ret = kvm_vcpu_map(vcpu, gpa_to_gfn(vmcb12_gpa), &map);
>         if (ret == -EINVAL) {
> @@ -1412,6 +1433,7 @@ static int svm_check_nested_events(struct kvm_vcpu *vcpu)
>  int nested_svm_exit_special(struct vcpu_svm *svm)
>  {
>         u32 exit_code = svm->vmcb->control.exit_code;
> +       struct kvm_vcpu *vcpu = &svm->vcpu;
>  
>         switch (exit_code) {
>         case SVM_EXIT_INTR:
> @@ -1430,6 +1452,13 @@ int nested_svm_exit_special(struct vcpu_svm *svm)
>                         return NESTED_EXIT_HOST;
>                 break;
>         }
> +       case SVM_EXIT_VMMCALL:
> +               /* Hyper-V L2 TLB flush hypercall is handled by L0 */
> +               if (guest_hv_cpuid_has_l2_tlb_flush(vcpu) &&
> +                   nested_svm_l2_tlb_flush_enabled(vcpu) &&
> +                   kvm_hv_is_tlb_flush_hcall(vcpu))
> +                       return NESTED_EXIT_HOST;
> +               break;
>         default:
>                 break;
>         }
> @@ -1710,6 +1739,9 @@ static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
>                 return false;
>         }
>  
> +       if (!nested_svm_hv_update_vp_assist(vcpu))
> +               return false;
> +
>         return true;
>  }
>  
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

