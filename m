Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4219D3B22D0
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 23:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbhFWV4K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 17:56:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20440 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229688AbhFWV4K (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Jun 2021 17:56:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624485231;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kBBzsr+ZYLTbIgPBN9G6o8mL6wPVlZyxFWIvteb0X/A=;
        b=X4HuUUCYvgUv7hjlBeX/ijDMh+OQe15XjF0c6codfaMx01fJVcIAruwU7172nJ4jFK5hzp
        GgjRiQDlhLou0hmcaJzwFw7O2pgUDNwKCDrE73hY3OVXwSH+tU/S9fD+DSfS0jSm3v/nGr
        cKGpyRMkwqvJJ94LGQWhPWy8AYsgNkU=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-354-Z9f1oCnpMyaNs9V2kkc0Xg-1; Wed, 23 Jun 2021 17:53:50 -0400
X-MC-Unique: Z9f1oCnpMyaNs9V2kkc0Xg-1
Received: by mail-ej1-f69.google.com with SMTP id f1-20020a1709064941b02903f6b5ef17bfso1416085ejt.20
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 14:53:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kBBzsr+ZYLTbIgPBN9G6o8mL6wPVlZyxFWIvteb0X/A=;
        b=MlCRx0LjObbDl4gMbsuT3vWUMarf45KRdW7kpP6aH0FDZPz8Tx/Vc9UqLWTqsq3h+g
         m6mHf7eM7WBHI5r4kktY5k2cit03MM7+zC225RIh1R34lC/Nln6K23WtmYMdNezVvXL+
         acn2D5QB5axsO0evlsWUT9+0jIZwnGIVcQxQeGB2lRk4kOKgeFSMT26Qo0NsIRGqpXUa
         cjHgLtPol6sGSXWagpKpjcivec0703hlB3te9lShGUo5Mrd6RMok5N7H167NJmcO9WJD
         FumTZBp7lqo6PXe8MrENa72k59Wq/z1B6qp1XrT7RXmkvF4MQ9QOkPncp+P1UefFmFPJ
         3/Zg==
X-Gm-Message-State: AOAM53125ezbPPCOp8VMAQ7L/rj7UiRt8DnPtIlCtlTFToIk90OQPlSa
        YYvYfdY0urqSuqeLF5NNpj/41HSYG+jtV59gydATp1JcxudU8nCCCGcSDWXn8/C2C2/eTZOw7/8
        JOGD9nYDqBNCZ
X-Received: by 2002:a17:907:264c:: with SMTP id ar12mr2007525ejc.391.1624485229121;
        Wed, 23 Jun 2021 14:53:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwJxPYaKsnGl8LmvyIJ1VWsmrmW42CoD80D/qn82+ZpwNUFI0DVRsZ3EpyESryxresI8lb57g==
X-Received: by 2002:a17:907:264c:: with SMTP id ar12mr2007520ejc.391.1624485228979;
        Wed, 23 Jun 2021 14:53:48 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id b25sm715289edv.9.2021.06.23.14.53.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 14:53:48 -0700 (PDT)
Subject: Re: [PATCH 04/10] KVM: SVM: add warning for mistmatch between AVIC
 state and AVIC access page state
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Jim Mattson <jmattson@google.com>
References: <20210623113002.111448-1-mlevitsk@redhat.com>
 <20210623113002.111448-5-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6617e1f2-23dd-9132-d866-7780663533c3@redhat.com>
Date:   Wed, 23 Jun 2021 23:53:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210623113002.111448-5-mlevitsk@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/06/21 13:29, Maxim Levitsky wrote:
> It is never a good idea to enter a guest when the AVIC state doesn't match
> the state of the AVIC MMIO memory slot.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>   arch/x86/kvm/svm/svm.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 12c06ea28f5c..50405c561394 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3780,6 +3780,9 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
>   
>   	pre_svm_run(vcpu);
>   
> +	WARN_ON_ONCE(vcpu->kvm->arch.apic_access_memslot_enabled !=
> +		     kvm_vcpu_apicv_active(vcpu));
> +
>   	sync_lapic_to_cr8(vcpu);
>   
>   	if (unlikely(svm->asid != svm->vmcb->control.asid)) {
> 

For patches 4-6, can the warnings actually fire without the fix in patch 2?

Paolo

