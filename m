Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02D0A57521A
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 17:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240411AbiGNPnQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 11:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240094AbiGNPnP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 11:43:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 516F45508D
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 08:43:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657813392;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z7W6YU0Nb2M09QTorgpdGUCXAXIfeENdniIao9kV1cw=;
        b=fAOR9lx/l/V2EgnB8/ifVW32qNRPV+iOFbjOH1sYRZ50kfwX7x8gGSrxIevHpHqrIccy0c
        xxA7sTSs4u1QB6ZB+9rpPsaWIZb8MEAW9R8vywGyS1ydThpgYxQwWn5jGRrw3EX4I7q8VQ
        8VkrJ2v+NwBVlKnxQt/C3YKBB1FyPs4=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-610-DCHhurcMNt2ZHUQ_csYLZQ-1; Thu, 14 Jul 2022 11:43:11 -0400
X-MC-Unique: DCHhurcMNt2ZHUQ_csYLZQ-1
Received: by mail-ed1-f71.google.com with SMTP id h17-20020a056402281100b0043aa5c0493dso1728475ede.16
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 08:43:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=z7W6YU0Nb2M09QTorgpdGUCXAXIfeENdniIao9kV1cw=;
        b=iqayqRoEO7kWh4u5NhTUHeJqL1kDTBISla/vjmvLh4aZ39qpplKFuQNyZ0qmOzclou
         njeq2d7h6bRdvAJj2a7brttncdBv3TZhhikLtOJm3y+QMTO5ckx/d0z861qwCyo2r+NG
         I5BIl9VMMpp5nizIbudexnvvPB9D9ZLo2Z/o1HsgBeU6bjLZVfp6CfTKoUQWDoZTCNTo
         Ke/XMGZI+3NElvt5oWDz75rTTpA+K//BxUUFR2EcGZVnBXhD5NuY1sSKls//1no6p5vm
         RUnTB8LgqlL0P9sGHGQU4NfgDTp39Dg7t5NBMbZ///67eVHtsel2vJnKxCLhQWnMtFh6
         s4vQ==
X-Gm-Message-State: AJIora+kpDFWjPfQQ9vrtw6iI2yiuK71RQxDMG2UFQssfxpVtFbGrf/x
        yXZnKO3g0kVI3cK2Z/OZUbAmNUZw/VifRB2KRn3IqZVKUzSp0E25hhyAjSL9lCswltQWSB3C68o
        SEkiVhtncXap/
X-Received: by 2002:a05:6402:27cf:b0:43a:de0b:9a82 with SMTP id c15-20020a05640227cf00b0043ade0b9a82mr12999088ede.427.1657813390004;
        Thu, 14 Jul 2022 08:43:10 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sHi6lrpW1J6cgagkq6CrQc4KL2oMqOpxrMUFHeM0Ogknu3QviU02RZ1dI7cYioGxaZh6C1yw==
X-Received: by 2002:a05:6402:27cf:b0:43a:de0b:9a82 with SMTP id c15-20020a05640227cf00b0043ade0b9a82mr12999074ede.427.1657813389810;
        Thu, 14 Jul 2022 08:43:09 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id fq37-20020a1709069da500b0072b55713daesm827057ejc.56.2022.07.14.08.43.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Jul 2022 08:43:09 -0700 (PDT)
Message-ID: <aa86054b-91ac-b321-37d6-88d483758be4@redhat.com>
Date:   Thu, 14 Jul 2022 17:43:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] KVM: x86: Restrict get_mt_mask() to a u8, use
 KVM_X86_OP_OPTIONAL_RET0
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220714153707.3239119-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220714153707.3239119-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/14/22 17:37, Sean Christopherson wrote:
> Restrict get_mt_mask() to a u8 and reintroduce using a RET0 static_call
> for the SVM implementation.  EPT stores the memtype information in the
> lower 8 bits (bits 6:3 to be precise), and even returns a shifted u8
> without an explicit cast to a larger type; there's no need to return a
> full u64.
> 
> Note, RET0 doesn't play nice with a u64 return on 32-bit kernels, see
> commit bf07be36cd88 ("KVM: x86: do not use KVM_X86_OP_OPTIONAL_RET0 for
> get_mt_mask").
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Doh, that's obvious.  Queued, thanks.

Paolo

> ---
>   arch/x86/include/asm/kvm-x86-ops.h | 2 +-
>   arch/x86/include/asm/kvm_host.h    | 2 +-
>   arch/x86/kvm/svm/svm.c             | 6 ------
>   arch/x86/kvm/vmx/vmx.c             | 2 +-
>   4 files changed, 3 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 6f2f1affbb78..51f777071584 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -88,7 +88,7 @@ KVM_X86_OP(deliver_interrupt)
>   KVM_X86_OP_OPTIONAL(sync_pir_to_irr)
>   KVM_X86_OP_OPTIONAL_RET0(set_tss_addr)
>   KVM_X86_OP_OPTIONAL_RET0(set_identity_map_addr)
> -KVM_X86_OP(get_mt_mask)
> +KVM_X86_OP_OPTIONAL_RET0(get_mt_mask)
>   KVM_X86_OP(load_mmu_pgd)
>   KVM_X86_OP(has_wbinvd_exit)
>   KVM_X86_OP(get_l2_tsc_offset)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index de5a149d0971..fa4b2392fba0 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1546,7 +1546,7 @@ struct kvm_x86_ops {
>   	int (*sync_pir_to_irr)(struct kvm_vcpu *vcpu);
>   	int (*set_tss_addr)(struct kvm *kvm, unsigned int addr);
>   	int (*set_identity_map_addr)(struct kvm *kvm, u64 ident_addr);
> -	u64 (*get_mt_mask)(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
> +	u8 (*get_mt_mask)(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
>   
>   	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, hpa_t root_hpa,
>   			     int root_level);
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 37ce061dfc76..19af6dacfc5b 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4158,11 +4158,6 @@ static bool svm_has_emulated_msr(struct kvm *kvm, u32 index)
>   	return true;
>   }
>   
> -static u64 svm_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
> -{
> -	return 0;
> -}
> -
>   static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>   {
>   	struct vcpu_svm *svm = to_svm(vcpu);
> @@ -4814,7 +4809,6 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>   	.check_apicv_inhibit_reasons = avic_check_apicv_inhibit_reasons,
>   	.apicv_post_state_restore = avic_apicv_post_state_restore,
>   
> -	.get_mt_mask = svm_get_mt_mask,
>   	.get_exit_info = svm_get_exit_info,
>   
>   	.vcpu_after_set_cpuid = svm_vcpu_after_set_cpuid,
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index c30115b9cb33..c895a3b6824d 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7352,7 +7352,7 @@ static int __init vmx_check_processor_compat(void)
>   	return 0;
>   }
>   
> -static u64 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
> +static u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
>   {
>   	u8 cache;
>   
> 
> base-commit: b9b71f43683ae9d76b0989249607bbe8c9eb6c5c

