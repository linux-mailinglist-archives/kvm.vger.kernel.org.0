Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB1733B22CD
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 23:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbhFWVzR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 17:55:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51554 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229755AbhFWVzQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Jun 2021 17:55:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624485178;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ACXvqcTUp2VEtZUNNrQgxrgIuroJ2VQXJ3O6aUtKlgU=;
        b=F78Cc5VZFou942qSWQvfm56iJ0y/fczdYwBSR8nONCzv3+F1/rwadmqCXhGtWLkRygk1wf
        wUKOcrrlE9PGDynKh1F23pcC8sq+z7LN0PdJL8mzWu+wABoE6Fz9IzxpNDEOPAkutBSaV2
        nrPuor9ybZCGmDOEo2Z03jS4CbHfyms=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-547-NncImxC8M5SOwAqhwGYycw-1; Wed, 23 Jun 2021 17:52:56 -0400
X-MC-Unique: NncImxC8M5SOwAqhwGYycw-1
Received: by mail-ed1-f72.google.com with SMTP id j15-20020a05640211cfb0290394f9de5750so1506305edw.16
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 14:52:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ACXvqcTUp2VEtZUNNrQgxrgIuroJ2VQXJ3O6aUtKlgU=;
        b=XnD5nuQYlB8vKGPL7Y0CIZpvf6cQNo+8gjXDax2TP1mozp1zdLa5WZITqa+45icfn9
         In3XU1QywGg8kFNcLY4ziHe3H+erFKahzCN6Tcb1YbyXNmcNYqDdv34ObDEWoDwItlhh
         MmGr9npV1wN5um9i9negEUoKJXhHwRWIuLMH6WygoKUpDuvj9WLx6Eq6UOxkO1Fhd2YY
         64L5u6kpgS5ccexhuT9DOusf4OUflAJ7sRAj+ut6VGKvoUXfs6L4C8mzQDhk3wyywkZB
         xrXTa3ggD489QgBrGrbMNLDoQKHfol4uhUQonaR0Tge1vWEdK1uZ8tEAkfzK7YW3r0/Y
         IL+g==
X-Gm-Message-State: AOAM532gbncv5ieZjf02wUrY105ZGnkZqoDG9Rcbtlf3sGIi71Ql0nfn
        o71JqibRdLlOZsILr7/akMzxUPYPLyESz6l+ZljNLNL1w2zhtErQB0ZNI7Pjz3lkitMD8hwHOHV
        hT+hKtovQwgTa
X-Received: by 2002:a05:6402:1510:: with SMTP id f16mr2429319edw.377.1624485175447;
        Wed, 23 Jun 2021 14:52:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyhxr240/C1q6g952wJj7Uq9npWIdFVmvprVIKXPcuEUAEomJqmW+y8uav6RIN3m1STWgJQnw==
X-Received: by 2002:a05:6402:1510:: with SMTP id f16mr2429299edw.377.1624485175324;
        Wed, 23 Jun 2021 14:52:55 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id d22sm391752ejj.47.2021.06.23.14.52.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 14:52:54 -0700 (PDT)
Subject: Re: [PATCH 06/10] KVM: SVM: tweak warning about enabled AVIC on
 nested entry
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
 <20210623113002.111448-7-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <30c057c7-3c42-90cd-0beb-a4c7fdff39ea@redhat.com>
Date:   Wed, 23 Jun 2021 23:52:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210623113002.111448-7-mlevitsk@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/06/21 13:29, Maxim Levitsky wrote:
> It is possible that AVIC was requested to be disabled but
> not yet disabled, e.g if the nested entry is done right
> after svm_vcpu_after_set_cpuid.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>   arch/x86/kvm/svm/nested.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index dca20f949b63..253847f7d9aa 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -505,7 +505,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
>   	 * Also covers avic_vapic_bar, avic_backing_page, avic_logical_id,
>   	 * avic_physical_id.
>   	 */
> -	WARN_ON(svm->vmcb01.ptr->control.int_ctl & AVIC_ENABLE_MASK);
> +	WARN_ON(kvm_apicv_activated(svm->vcpu.kvm));
>   
>   	/* Copied from vmcb01.  msrpm_base can be overwritten later.  */
>   	svm->vmcb->control.nested_ctl = svm->vmcb01.ptr->control.nested_ctl;
> 

Queued, thanks.

Paolo

