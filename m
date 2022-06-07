Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0894D53FA81
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 11:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240307AbiFGJ4N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 05:56:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240182AbiFGJ4L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 05:56:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D80F2E731A
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 02:56:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654595769;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hPcrVbGSfC2d9bGnlJDvNet18sRYkg2g/ox43s88aXY=;
        b=KJDxhWLv9LesYR6dgar5CgDkULrbejMC4MB1enSdX7fr/oxZlCGChUAx8i2TqNsJ/+WR0/
        cGdnu4Rg7A7h/0lGtxTuxG7mtHzxXTMb5b1jwPNskGy/4dLBnR7X5LQnq079S1ox70Jgjq
        yy+pFJtoZfMf3aSjIzR/CLfPw6CQxH8=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-49-jcaghEbNPTSDI8rfkcCg0w-1; Tue, 07 Jun 2022 05:56:08 -0400
X-MC-Unique: jcaghEbNPTSDI8rfkcCg0w-1
Received: by mail-qk1-f197.google.com with SMTP id c8-20020a05620a268800b0069c0f1b3206so13698099qkp.18
        for <kvm@vger.kernel.org>; Tue, 07 Jun 2022 02:56:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=hPcrVbGSfC2d9bGnlJDvNet18sRYkg2g/ox43s88aXY=;
        b=ufgnUF0C1HixyWGsisAUfRR9jS/AGzrPRD64rmNbnmW+6aVyW2P+rBBi9dN0EHoETC
         P9qnPaeM1g257pRmZ1Xrg9c5ntnetKnSioxTeuWJtDjRx9t29NmdshGiTQJq8gkC3rop
         NtPcAoWI1TVzKl6U5GOtEI7ZDJROmI3csEfKHl6+m/+oVHSe/EBQlVOficPy01e5wYn/
         UHQDQ9ZpY2fvl8K2Egom9/H0YlyWhexjgp174ZSmAp+V/1Zjx2zymAUZ7/fFYM4CPzLt
         mIeycNnnmlx4lVIbyVwoxf9da0hNrXfE4dJaNEwleuE6aCm5NSiwKDCo1+BrUy+eWimk
         MMIA==
X-Gm-Message-State: AOAM5323kjOih/8UICaaxhNfZJ/SWs2vPkwUJtSOq1tv41o9GPtGZYDB
        lF9WBhNaOIkOUCl1XaNsKJafNtEyU9hn6MtUNw3Pb1mK7lW/p4MsYc+Ba14d5x8EzdrQLUKWHzJ
        Ef1+WcqQ6l5yf
X-Received: by 2002:a37:917:0:b0:6a6:9a14:b542 with SMTP id 23-20020a370917000000b006a69a14b542mr14626089qkj.562.1654595767102;
        Tue, 07 Jun 2022 02:56:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxGn1pnO3L/l5/swG8TZlg+GJyHc7lm8NxVbWhcbgeMs61jMxFKA3z/PBHvttTea5vJ/1bMlQ==
X-Received: by 2002:a37:917:0:b0:6a6:9a14:b542 with SMTP id 23-20020a370917000000b006a69a14b542mr14626069qkj.562.1654595766859;
        Tue, 07 Jun 2022 02:56:06 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id d127-20020a37b485000000b0069fc13ce257sm12793643qkf.136.2022.06.07.02.56.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 02:56:06 -0700 (PDT)
Message-ID: <e249bd60cef49706e39cc619876e26c90d88ecb0.camel@redhat.com>
Subject: Re: [PATCH v6 20/38] KVM: nVMX: hyper-v: Cache VP assist page in
 'struct kvm_vcpu_hv'
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
Date:   Tue, 07 Jun 2022 12:56:02 +0300
In-Reply-To: <20220606083655.2014609-21-vkuznets@redhat.com>
References: <20220606083655.2014609-1-vkuznets@redhat.com>
         <20220606083655.2014609-21-vkuznets@redhat.com>
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
> In preparation to enabling L2 TLB flush, cache VP assist page in
> 'struct kvm_vcpu_hv'. While on it, rename nested_enlightened_vmentry()
> to nested_get_evmptr() and make it return eVMCS GPA directly.
> 
> No functional change intended.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 ++
>  arch/x86/kvm/hyperv.c           | 10 ++++++----
>  arch/x86/kvm/hyperv.h           |  3 +--
>  arch/x86/kvm/vmx/evmcs.c        | 21 +++++++--------------
>  arch/x86/kvm/vmx/evmcs.h        |  2 +-
>  arch/x86/kvm/vmx/nested.c       |  6 +++---
>  6 files changed, 20 insertions(+), 24 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index f9a34af0a5cc..e62db76c8d37 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -650,6 +650,8 @@ struct kvm_vcpu_hv {
>         /* Preallocated buffer for handling hypercalls passing sparse vCPU set */
>         u64 sparse_banks[HV_MAX_SPARSE_VCPU_BANKS];
>  
> +       struct hv_vp_assist_page vp_assist_page;
> +
>         struct {
>                 u64 pa_page_gpa;
>                 u64 vm_id;
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 4396d75588d8..91310774c0b9 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -903,13 +903,15 @@ bool kvm_hv_assist_page_enabled(struct kvm_vcpu *vcpu)
>  }
>  EXPORT_SYMBOL_GPL(kvm_hv_assist_page_enabled);
>  
> -bool kvm_hv_get_assist_page(struct kvm_vcpu *vcpu,
> -                           struct hv_vp_assist_page *assist_page)
> +bool kvm_hv_get_assist_page(struct kvm_vcpu *vcpu)
>  {
> -       if (!kvm_hv_assist_page_enabled(vcpu))
> +       struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
> +
> +       if (!hv_vcpu || !kvm_hv_assist_page_enabled(vcpu))
>                 return false;
> +
>         return !kvm_read_guest_cached(vcpu->kvm, &vcpu->arch.pv_eoi.data,
> -                                     assist_page, sizeof(*assist_page));
> +                                     &hv_vcpu->vp_assist_page, sizeof(struct hv_vp_assist_page));
>  }
>  EXPORT_SYMBOL_GPL(kvm_hv_get_assist_page);
>  
> diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
> index 2aa6fb7fc599..139beb55b781 100644
> --- a/arch/x86/kvm/hyperv.h
> +++ b/arch/x86/kvm/hyperv.h
> @@ -105,8 +105,7 @@ int kvm_hv_activate_synic(struct kvm_vcpu *vcpu, bool dont_zero_synic_pages);
>  void kvm_hv_vcpu_uninit(struct kvm_vcpu *vcpu);
>  
>  bool kvm_hv_assist_page_enabled(struct kvm_vcpu *vcpu);
> -bool kvm_hv_get_assist_page(struct kvm_vcpu *vcpu,
> -                           struct hv_vp_assist_page *assist_page);
> +bool kvm_hv_get_assist_page(struct kvm_vcpu *vcpu);
>  
>  static inline struct kvm_vcpu_hv_stimer *to_hv_stimer(struct kvm_vcpu *vcpu,
>                                                       int timer_index)
> diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
> index 805afc170b5b..7cd7b16942c6 100644
> --- a/arch/x86/kvm/vmx/evmcs.c
> +++ b/arch/x86/kvm/vmx/evmcs.c
> @@ -307,24 +307,17 @@ __init void evmcs_sanitize_exec_ctrls(struct vmcs_config *vmcs_conf)
>  }
>  #endif
>  
> -bool nested_enlightened_vmentry(struct kvm_vcpu *vcpu, u64 *evmcs_gpa)
> +u64 nested_get_evmptr(struct kvm_vcpu *vcpu)
>  {
> -       struct hv_vp_assist_page assist_page;
> +       struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
>  
> -       *evmcs_gpa = -1ull;
> +       if (unlikely(!kvm_hv_get_assist_page(vcpu)))
> +               return EVMPTR_INVALID;
>  
> -       if (unlikely(!kvm_hv_get_assist_page(vcpu, &assist_page)))
> -               return false;
> +       if (unlikely(!hv_vcpu->vp_assist_page.enlighten_vmentry))
> +               return EVMPTR_INVALID;
>  
> -       if (unlikely(!assist_page.enlighten_vmentry))
> -               return false;
> -
> -       if (unlikely(!evmptr_is_valid(assist_page.current_nested_vmcs)))
> -               return false;
> -
> -       *evmcs_gpa = assist_page.current_nested_vmcs;
> -
> -       return true;
> +       return hv_vcpu->vp_assist_page.current_nested_vmcs;
>  }
>  
>  uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu)
> diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
> index 584741b85eb6..22d238b36238 100644
> --- a/arch/x86/kvm/vmx/evmcs.h
> +++ b/arch/x86/kvm/vmx/evmcs.h
> @@ -239,7 +239,7 @@ enum nested_evmptrld_status {
>         EVMPTRLD_ERROR,
>  };
>  
> -bool nested_enlightened_vmentry(struct kvm_vcpu *vcpu, u64 *evmcs_gpa);
> +u64 nested_get_evmptr(struct kvm_vcpu *vcpu);
>  uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu);
>  int nested_enable_evmcs(struct kvm_vcpu *vcpu,
>                         uint16_t *vmcs_version);
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 4a827b3d929a..87bff81f7f3e 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -1995,7 +1995,8 @@ static enum nested_evmptrld_status nested_vmx_handle_enlightened_vmptrld(
>         if (likely(!vmx->nested.enlightened_vmcs_enabled))
>                 return EVMPTRLD_DISABLED;
>  
> -       if (!nested_enlightened_vmentry(vcpu, &evmcs_gpa)) {
> +       evmcs_gpa = nested_get_evmptr(vcpu);
> +       if (!evmptr_is_valid(evmcs_gpa)) {
>                 nested_release_evmcs(vcpu);
>                 return EVMPTRLD_DISABLED;
>         }
> @@ -5084,7 +5085,6 @@ static int handle_vmclear(struct kvm_vcpu *vcpu)
>         struct vcpu_vmx *vmx = to_vmx(vcpu);
>         u32 zero = 0;
>         gpa_t vmptr;
> -       u64 evmcs_gpa;
>         int r;
>  
>         if (!nested_vmx_check_permission(vcpu))
> @@ -5110,7 +5110,7 @@ static int handle_vmclear(struct kvm_vcpu *vcpu)
>          * vmx->nested.hv_evmcs but this shouldn't be a problem.
>          */
>         if (likely(!vmx->nested.enlightened_vmcs_enabled ||
> -                  !nested_enlightened_vmentry(vcpu, &evmcs_gpa))) {
> +                  !evmptr_is_valid(nested_get_evmptr(vcpu)))) {
>                 if (vmptr == vmx->nested.current_vmptr)
>                         nested_release_vmcs12(vcpu);
>  


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


