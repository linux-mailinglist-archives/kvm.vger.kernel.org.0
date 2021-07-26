Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7158D3D682C
	for <lists+kvm@lfdr.de>; Mon, 26 Jul 2021 22:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232750AbhGZTxA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 15:53:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50958 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231650AbhGZTw7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Jul 2021 15:52:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627331607;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R5y5iIzB/XJicNUoEyIMufLhZEfNA3WcOGOUF/t0F00=;
        b=YVNz/FgLlSnLvE5RRDD8vZu3M9sh1XVu6iGjoOW1ZHZC2J2NtYYTn7MxKO0JtxrmhqhJ7r
        3li0P6b94vws9dyNzPm2x74hHnnxuhzHTpU7qAAkqG2duQ+/9dsjm32TCNKuaX2G/gbiw4
        5YWzGjY9XlJ6i5YSj8WDQkPCI2tiCm0=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-430-mC1HTIEsN6ata2OXGq0D5w-1; Mon, 26 Jul 2021 16:33:26 -0400
X-MC-Unique: mC1HTIEsN6ata2OXGq0D5w-1
Received: by mail-ej1-f70.google.com with SMTP id c18-20020a1709067632b02905478dfedcafso2395534ejn.21
        for <kvm@vger.kernel.org>; Mon, 26 Jul 2021 13:33:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=R5y5iIzB/XJicNUoEyIMufLhZEfNA3WcOGOUF/t0F00=;
        b=C6ksFez7GO1pf/3gFyKys8i5zekeQlmq+L3vBG6S61W/YEg2D+JUQjMOOv1CdbSsh3
         DjUTLSsodpCbGcHjZBmuq5e2ht/NL0FG0WqmdYC+EQfaWtzD7CDFdoEXwpx9bpURGATF
         u3adpTekRmJgN16vGrLA+B3PwfdoWzVCkiwYe+yupPRj/p8ev0UlwsygsW6WmsmD5xJf
         AniCmuwBvHQgeZ6XEe+RusqJU0UvpdgGxC9gSjKloC2oCbs3grt9Gigb0Gfhx39defXf
         zJzvAYOnwIM5Bm3hQAeFYurwGxY5dDtC5JK7RKvuSecZK03bU8TmqjJx82KaQlGpfwJS
         ri1w==
X-Gm-Message-State: AOAM531Re0XvqY6nDTJ6SzY1bIO8Zoz6q5LINHZAw3oo1yoRt4KArpUB
        J1MezNXOkHK4D+FCH0VRiOfF1f988jbLFaZaXDbkiePYLUDAI6J30J335AAIH2AQEy1PuMn1Lix
        iusLMobQQaGQ/
X-Received: by 2002:a17:906:4d94:: with SMTP id s20mr7661762eju.152.1627331604739;
        Mon, 26 Jul 2021 13:33:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw/CjjMGAATqLBcCyBccrOgLostjm2vjSWe8JNBhnSnyDpdYSlfsbMLLLeEN00kYPzHYJ4QZA==
X-Received: by 2002:a17:906:4d94:: with SMTP id s20mr7661753eju.152.1627331604595;
        Mon, 26 Jul 2021 13:33:24 -0700 (PDT)
Received: from [192.168.10.118] ([93.56.169.140])
        by smtp.gmail.com with ESMTPSA id e7sm212218ejt.80.2021.07.26.13.33.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jul 2021 13:33:23 -0700 (PDT)
Subject: Re: [PATCH v2 09/46] KVM: SVM: Drop a redundant init_vmcb() from
 svm_create_vcpu()
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reiji Watanabe <reijiw@google.com>
References: <20210713163324.627647-1-seanjc@google.com>
 <20210713163324.627647-10-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <77b78927-77ca-39b8-8882-458fc3ec9ba8@redhat.com>
Date:   Mon, 26 Jul 2021 22:33:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210713163324.627647-10-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/07/21 18:32, Sean Christopherson wrote:
> Drop an extra init_vmcb() from svm_create_vcpu(), svm_vcpu_reset() is
> guaranteed to call init_vmcb() and there are no consumers of the VMCB
> data between ->vcpu_create() and ->vcpu_reset().  Keep the call to
> svm_switch_vmcb() as sev_es_create_vcpu() touches the current VMCB, but
> hoist it up a few lines to associate the switch with the allocation of
> vmcb01.
> 
> Reviewed-by: Reiji Watanabe <reijiw@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/svm/svm.c | 4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 44248548be7d..cef9520fe77f 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1431,15 +1431,13 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
>   
>   	svm->vmcb01.ptr = page_address(vmcb01_page);
>   	svm->vmcb01.pa = __sme_set(page_to_pfn(vmcb01_page) << PAGE_SHIFT);
> +	svm_switch_vmcb(svm, &svm->vmcb01);
>   
>   	if (vmsa_page)
>   		svm->vmsa = page_address(vmsa_page);
>   
>   	svm->guest_state_loaded = false;
>   
> -	svm_switch_vmcb(svm, &svm->vmcb01);
> -	init_vmcb(vcpu);
> -
>   	svm_init_osvw(vcpu);
>   	vcpu->arch.microcode_version = 0x01000065;

While this patch makes sense, I'd rather not include it to reduce the 
part of the code in which svm->vmcb is NULL.   See for example the issue 
reported by the static analyzer in which 
svm_hv_vmcb_dirty_nested_enlightenments (called by svm_vcpu_init_msrpm) 
dereferences svm->vmcb.

Paolo

