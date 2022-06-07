Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B618353FA32
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 11:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240101AbiFGJsc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 05:48:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240026AbiFGJsT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 05:48:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A02F1DFD0D
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 02:48:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654595295;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IFV6m742eJK5fjIllJH8j+SCBmQdPpQ1B+N/I8SMuIc=;
        b=fsCHB+lvJvmuySj2batn5E2zz/9coofIfNjFTOKVsHuzQW208ZwlIqvGNauGjDZgF19suH
        qb40Gk0M/+7GYhIBu0u4k2ywPvo1jg0gHecwfQCRwNGgok2RZLq9LkjxxwSo+w4Uq5K+Vk
        WTwM1Tu9sJfHVP54c9hWGhMCquLMngI=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-379-0LADTVWPOPqt9Witr9h3XA-1; Tue, 07 Jun 2022 05:48:14 -0400
X-MC-Unique: 0LADTVWPOPqt9Witr9h3XA-1
Received: by mail-qv1-f71.google.com with SMTP id z10-20020ad4414a000000b004644d6dafe3so10481387qvp.11
        for <kvm@vger.kernel.org>; Tue, 07 Jun 2022 02:48:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=IFV6m742eJK5fjIllJH8j+SCBmQdPpQ1B+N/I8SMuIc=;
        b=UEzuuYEIR/zyK9UarWqt1j1FH3Wpx4G9dCiOZ44lbZALrIEEGVtPCCio2ClS/IM+3o
         BAtnjaBNBdSUKoQjBZAtMAbLIyeoIT3I6rJvrmwNB/TEcYVfMmlc+8AVm/8sNbyAJG1v
         kUPaI8v39jiZOwtzzfROjT1GEI4e5+pYGiV/LGYqHuKWdKX3/ku/ywaQKsOA/40UAg6A
         u/7pdznbEZWMK492RRrog7UICk5UaK/ImwMvQfq9iwX7Sl7z99pecd/mPP719UEIZ80j
         DtLvmrBpRqMmEKwpORUa/cywfpcQzZtlwpHmP1v/yyB6BbRJy6feAilEczkIPdvc1jHQ
         Uv6g==
X-Gm-Message-State: AOAM533h64XGr+1zuQ+HGwNbuvu7i2im1Ib7HtFYyZ3fOHGy4iH0Cuaf
        Rzf0BKnM5rgHTcnubat3h3MqXd1m5Xiu3h72UQwKkBWqq0P0KRerxKrLA6kS7HT94o2QJ3xp9FN
        u6i7noZ2b5JSL
X-Received: by 2002:a37:a0c1:0:b0:6a6:9647:3548 with SMTP id j184-20020a37a0c1000000b006a696473548mr14546094qke.155.1654595293851;
        Tue, 07 Jun 2022 02:48:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwvMMVQxxX5Pf8YRgVde+mcpTypTBPlxZsx8/NMqJEuNU630kVMBm8gKxAIEY9Kf36NXraa7w==
X-Received: by 2002:a37:a0c1:0:b0:6a6:9647:3548 with SMTP id j184-20020a37a0c1000000b006a696473548mr14546084qke.155.1654595293650;
        Tue, 07 Jun 2022 02:48:13 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id d19-20020a05620a241300b006a6c230f5e0sm4256533qkn.31.2022.06.07.02.48.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 02:48:13 -0700 (PDT)
Message-ID: <9df598de5072fdbc6606363f0a75f6f0bea6fd60.camel@redhat.com>
Subject: Re: [PATCH v6 18/38] KVM: x86: hyper-v: Introduce fast
 guest_hv_cpuid_has_l2_tlb_flush() check
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
Date:   Tue, 07 Jun 2022 12:48:09 +0300
In-Reply-To: <20220606083655.2014609-19-vkuznets@redhat.com>
References: <20220606083655.2014609-1-vkuznets@redhat.com>
         <20220606083655.2014609-19-vkuznets@redhat.com>
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
> Introduce a helper to quickly check if KVM needs to handle VMCALL/VMMCALL
> from L2 in L0 to process L2 TLB flush requests.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 1 +
>  arch/x86/kvm/hyperv.c           | 6 ++++++
>  arch/x86/kvm/hyperv.h           | 7 +++++++
>  3 files changed, 14 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 5d60c66ee0de..f9a34af0a5cc 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -642,6 +642,7 @@ struct kvm_vcpu_hv {
>                 u32 enlightenments_eax; /* HYPERV_CPUID_ENLIGHTMENT_INFO.EAX */
>                 u32 enlightenments_ebx; /* HYPERV_CPUID_ENLIGHTMENT_INFO.EBX */
>                 u32 syndbg_cap_eax; /* HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES.EAX */
> +               u32 nested_features_eax; /* HYPERV_CPUID_NESTED_FEATURES.EAX */
>         } cpuid_cache;
>  
>         struct kvm_vcpu_hv_tlb_flush_fifo tlb_flush_fifo[HV_NR_TLB_FLUSH_FIFOS];
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 740190917c1c..4396d75588d8 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -2229,6 +2229,12 @@ void kvm_hv_set_cpuid(struct kvm_vcpu *vcpu)
>                 hv_vcpu->cpuid_cache.syndbg_cap_eax = entry->eax;
>         else
>                 hv_vcpu->cpuid_cache.syndbg_cap_eax = 0;
> +
> +       entry = kvm_find_cpuid_entry(vcpu, HYPERV_CPUID_NESTED_FEATURES, 0);
> +       if (entry)
> +               hv_vcpu->cpuid_cache.nested_features_eax = entry->eax;
> +       else
> +               hv_vcpu->cpuid_cache.nested_features_eax = 0;
>  }
>  
>  int kvm_hv_set_enforce_cpuid(struct kvm_vcpu *vcpu, bool enforce)
> diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
> index 7778b3a5913c..2aa6fb7fc599 100644
> --- a/arch/x86/kvm/hyperv.h
> +++ b/arch/x86/kvm/hyperv.h
> @@ -170,6 +170,13 @@ static inline void kvm_hv_vcpu_empty_flush_tlb(struct kvm_vcpu *vcpu, bool is_gu
>         kfifo_reset_out(&tlb_flush_fifo->entries);
>  }
>  
> +static inline bool guest_hv_cpuid_has_l2_tlb_flush(struct kvm_vcpu *vcpu)
> +{
> +       struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
> +
> +       return hv_vcpu && (hv_vcpu->cpuid_cache.nested_features_eax & HV_X64_NESTED_DIRECT_FLUSH);
> +}
> +
>  static inline bool kvm_hv_is_tlb_flush_hcall(struct kvm_vcpu *vcpu)
>  {
>         struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

