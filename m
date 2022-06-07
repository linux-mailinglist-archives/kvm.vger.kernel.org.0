Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0776F53F889
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 10:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238545AbiFGIrY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 04:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238599AbiFGIqs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 04:46:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6085DE528A
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 01:46:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654591577;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xI1BfmQ1tmnR7pC5S7JA4VoggSPGIGxH2wHdSDEj2eY=;
        b=X55jLBkgeKgFdioPCSOW+I5e1aurDHHGvHSSb/Tnc/QpMCCQM/hpuQEbTZREQU+OWeSTdC
        VCPEotsmnHxQxDG3Mw1b1qPAphQakjF32eWd74YwIT39JM1qcVOa7nURIE+nTL32N9pfF5
        c3/tKDtgZlARaqrJ1OSRE5uMp/GDs5U=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-495-6OTKPFheMoedAgOyeho-Sg-1; Tue, 07 Jun 2022 04:46:16 -0400
X-MC-Unique: 6OTKPFheMoedAgOyeho-Sg-1
Received: by mail-qk1-f198.google.com with SMTP id ay36-20020a05620a17a400b006a692ef8221so9994122qkb.21
        for <kvm@vger.kernel.org>; Tue, 07 Jun 2022 01:46:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=xI1BfmQ1tmnR7pC5S7JA4VoggSPGIGxH2wHdSDEj2eY=;
        b=gkZG4A4iwD6bC3OCpu9tqWT3Qre70aUrI8DEjoYxEftQRjqEPE+/xNgexjm6qmK6Uv
         nm2xidTwSIP00zkXFWIePOwpbREKlOwbb6K9bi0T1MhG/pmFIGFXBumvHsa+gMnoBVv5
         cm7B1QuLAxiy23qGIbXwh73zVXD+uazJ7le6oWgyu+hsKwfB0dUaJqrAmhZbUBVD28Pb
         p/P3W3v98KDoXCiYwLAQPtXukkpQoV75EDuKyeGcaY9ILiEs3Hl8hZw6fWHU7daSpxkP
         VpmVrB2sjf+AM1CqUfZtzigi7Ehaoku3Llf5dbi6MLedLcKgguTGXOoBKKNzAUIsLMWf
         iE4g==
X-Gm-Message-State: AOAM530yWJI5njbS5fWIVR5G1ZrsMmgRzBAoNz9RpMJNz0U2xY+rNmum
        gKp3TrMSMUueoE5D8r7CsAmqJo5ALdENM58boCdxNddS9U0NJZHb3V5pVvF1tvQasz3ywFdd3AL
        HXogVZnnCppNc
X-Received: by 2002:ac8:578d:0:b0:2f3:e61d:df9e with SMTP id v13-20020ac8578d000000b002f3e61ddf9emr21797460qta.181.1654591575258;
        Tue, 07 Jun 2022 01:46:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz7za2/FDRtffmJ1CIimVYvMn+o4/Op1dXsBZwSHG55CAOEduxCodQmfpxNLBNuQ7GdVOdjWw==
X-Received: by 2002:ac8:578d:0:b0:2f3:e61d:df9e with SMTP id v13-20020ac8578d000000b002f3e61ddf9emr21797445qta.181.1654591575018;
        Tue, 07 Jun 2022 01:46:15 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id u22-20020ac87516000000b002f92b74ba99sm11416797qtq.13.2022.06.07.01.46.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 01:46:14 -0700 (PDT)
Message-ID: <420b6cfdeab348f93c0de20ef07b66663fe5030c.camel@redhat.com>
Subject: Re: [PATCH v6 02/38] KVM: x86: hyper-v: Resurrect dedicated
 KVM_REQ_HV_TLB_FLUSH flag
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
Date:   Tue, 07 Jun 2022 11:46:10 +0300
In-Reply-To: <20220606083655.2014609-3-vkuznets@redhat.com>
References: <20220606083655.2014609-1-vkuznets@redhat.com>
         <20220606083655.2014609-3-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-2.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-06-06 at 10:36 +0200, Vitaly Kuznetsov wrote:
> In preparation to implementing fine-grained Hyper-V TLB flush and
> L2 TLB flush, resurrect dedicated KVM_REQ_HV_TLB_FLUSH request bit.
> As
> KVM_REQ_TLB_FLUSH_GUEST/KVM_REQ_TLB_FLUSH_CURRENT are stronger
> operations,
> clear KVM_REQ_HV_TLB_FLUSH request in
> kvm_service_local_tlb_flush_requests()
> when any of these were also requested.
> 
> No (real) functional change intended.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 ++
>  arch/x86/kvm/hyperv.c           |  4 ++--
>  arch/x86/kvm/x86.c              | 10 ++++++++--
>  3 files changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h
> b/arch/x86/include/asm/kvm_host.h
> index 8699f715d867..7a6a6f47b603 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -108,6 +108,8 @@
>         KVM_ARCH_REQ_FLAGS(30, KVM_REQUEST_WAIT |
> KVM_REQUEST_NO_WAKEUP)
>  #define KVM_REQ_MMU_FREE_OBSOLETE_ROOTS \
>         KVM_ARCH_REQ_FLAGS(31, KVM_REQUEST_WAIT |
> KVM_REQUEST_NO_WAKEUP)
> +#define KVM_REQ_HV_TLB_FLUSH \
> +       KVM_ARCH_REQ_FLAGS(32, KVM_REQUEST_WAIT |
> KVM_REQUEST_NO_WAKEUP)
>  
>  #define
> CR0_RESERVED_BITS                                               \
>         (~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM |
> X86_CR0_TS \
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 46f9dfb60469..b402ad059eb9 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -1876,11 +1876,11 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu
> *vcpu, struct kvm_hv_hcall *hc)
>          * analyze it here, flush TLB regardless of the specified
> address space.
>          */
>         if (all_cpus) {
> -               kvm_make_all_cpus_request(kvm,
> KVM_REQ_TLB_FLUSH_GUEST);
> +               kvm_make_all_cpus_request(kvm, KVM_REQ_HV_TLB_FLUSH);
>         } else {
>                 sparse_set_to_vcpu_mask(kvm, sparse_banks,
> valid_bank_mask, vcpu_mask);
>  
> -               kvm_make_vcpus_request_mask(kvm,
> KVM_REQ_TLB_FLUSH_GUEST, vcpu_mask);
> +               kvm_make_vcpus_request_mask(kvm,
> KVM_REQ_HV_TLB_FLUSH, vcpu_mask);
>         }
>  
>  ret_success:
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 67732e658e76..80cd3eb5e7de 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3353,11 +3353,17 @@ static inline void
> kvm_vcpu_flush_tlb_current(struct kvm_vcpu *vcpu)
>   */
>  void kvm_service_local_tlb_flush_requests(struct kvm_vcpu *vcpu)
>  {
> -       if (kvm_check_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu))
> +       if (kvm_check_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu)) {
>                 kvm_vcpu_flush_tlb_current(vcpu);
> +               kvm_clear_request(KVM_REQ_HV_TLB_FLUSH, vcpu);
> +       }
>  
> -       if (kvm_check_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu))
> +       if (kvm_check_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu)) {
> +               kvm_vcpu_flush_tlb_guest(vcpu);
> +               kvm_clear_request(KVM_REQ_HV_TLB_FLUSH, vcpu);
> +       } else if (kvm_check_request(KVM_REQ_HV_TLB_FLUSH, vcpu)) {
>                 kvm_vcpu_flush_tlb_guest(vcpu);
> +       }
>  }
>  EXPORT_SYMBOL_GPL(kvm_service_local_tlb_flush_requests);
>  

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

