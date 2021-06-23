Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDFAD3B22D3
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 23:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbhFWV4p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 17:56:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48678 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229759AbhFWV4o (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Jun 2021 17:56:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624485266;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q2oczT/WFO/JvI+sqLC25ZI6Paw6nUoV8jwB+hFflSQ=;
        b=Ta24a2cpjYLa2EC9tQhcHBhqoZYfuGt/ZEDZKraPbhrFR2PoI69g9uQHjbLVaEiUD73Y5S
        KZQGB9A1sRZUF9t9HcpJAiHc7Irdhqv3kHzY4VAJuYXlxVi0jKSWmfemtVx1advENIcowi
        IPbrgVt9+lxcQpFS+4T0t/evpjSobD4=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-292-aUL4vWyGPdGZbTus3qgzNQ-1; Wed, 23 Jun 2021 17:54:25 -0400
X-MC-Unique: aUL4vWyGPdGZbTus3qgzNQ-1
Received: by mail-ed1-f69.google.com with SMTP id g13-20020a056402090db02903935a4cb74fso2098025edz.1
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 14:54:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=q2oczT/WFO/JvI+sqLC25ZI6Paw6nUoV8jwB+hFflSQ=;
        b=JF9e1gS1IptR/DrPhy1+owaH/JpKr5kBXQzrQlV/qsMUAXRt+EpEsGeylasA3uqQRE
         RXMluipHOaJhxXEGywTu4p3fd8T3iK6Ryn1t0ntT9SWh3VHbj7ddXkPX4Tw9R7bbDMGo
         T6pkR9svhAALvDNaoWZrJt6by5vN7M1Na8Ilnj2U2WnxDI/3hWm0tQf7e11lVXZwcADJ
         nlYztWv/UB6U/BPTNTIT4vQcBV+yU+DQs7aNguhKMuERRZuF1hgZyQ3msXo30q3DtAax
         s8qqSkSKNwfegjW6yedUoxLEwpTRAP1/gO59uF2zWPgilRzCVqmwIdVEGWgvEnjitbP6
         jrWw==
X-Gm-Message-State: AOAM530kLsolkEnEp2VaC0WoZVnbwWBbXEpFHCWJR/29RAOkUv+jl0UH
        GYC6IPWelSFQg89KgFSs0L7xGvzmF4fssscwAxYpzGbpA5YTQVE4joN/rsnjlE7iRFDYeoAVQrB
        UYO0/ygkgwMTp
X-Received: by 2002:a17:906:585a:: with SMTP id h26mr2060450ejs.31.1624485263926;
        Wed, 23 Jun 2021 14:54:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy6wF2IKkIuTm+iUZD3A7ksdCISq2WDa6KzhKMO2dYCj9ZXXGf/bICQzlY4TiYgoOCsQKAQag==
X-Received: by 2002:a17:906:585a:: with SMTP id h26mr2060440ejs.31.1624485263793;
        Wed, 23 Jun 2021 14:54:23 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id j1sm722179edl.80.2021.06.23.14.54.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 14:54:23 -0700 (PDT)
Subject: Re: [PATCH 07/10] KVM: SVM: use vmcb01 in svm_refresh_apicv_exec_ctrl
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
 <20210623113002.111448-8-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <bd20da0f-eb20-48f7-3258-cd5949f12227@redhat.com>
Date:   Wed, 23 Jun 2021 23:54:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210623113002.111448-8-mlevitsk@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/06/21 13:29, Maxim Levitsky wrote:
> AVIC is not supported for nesting but in some corner
> cases it is possible to have it still be enabled,
> after we entered nesting, and use vmcb02.
> 
> Fix this by always using vmcb01 in svm_refresh_apicv_exec_ctrl

Please be more verbose about the corner case (and then the second 
paragraph should not be necessary anymore).

Paolo

> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>   arch/x86/kvm/svm/avic.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 1d01da64c333..a8ad78a2faa1 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -646,7 +646,7 @@ static int svm_set_pi_irte_mode(struct kvm_vcpu *vcpu, bool activate)
>   void svm_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
>   {
>   	struct vcpu_svm *svm = to_svm(vcpu);
> -	struct vmcb *vmcb = svm->vmcb;
> +	struct vmcb *vmcb = svm->vmcb01.ptr;
>   	bool activated = kvm_vcpu_apicv_active(vcpu);
>   
>   	if (!enable_apicv)
> 

