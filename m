Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 142322D7FBA
	for <lists+kvm@lfdr.de>; Fri, 11 Dec 2020 20:59:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392458AbgLKT6G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Dec 2020 14:58:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25479 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390134AbgLKT5c (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 11 Dec 2020 14:57:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607716560;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EI9tFe2d+x7h9xpY9irKfrLfpTmCH7FCB8q9u1x21M4=;
        b=cAaV3/Kfj2xWSL72FVESrcelT+iCiJzdNfWkQ5iFycMdo28bDedGumINVYqXBhxt5eUVVw
        ab8pbKPASV2exEfPKjoYeShGJ1lF/y/lhUxe7iarfy9so9Q7zUS5/IoXwlFezAdOvdeCm0
        K2KX0yr1lfD1+QkTAp9t0mxoli0WcP8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-352-tFNZSbZOOqC4DOX3FawWIw-1; Fri, 11 Dec 2020 14:55:58 -0500
X-MC-Unique: tFNZSbZOOqC4DOX3FawWIw-1
Received: by mail-wm1-f72.google.com with SMTP id w204so2889300wmb.1
        for <kvm@vger.kernel.org>; Fri, 11 Dec 2020 11:55:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EI9tFe2d+x7h9xpY9irKfrLfpTmCH7FCB8q9u1x21M4=;
        b=tvPKu6IYyppaHIms6j1qhX0YNAqfR/doXc78U7XNeWnjbKEYPPchfStd/DQn1TyqMf
         laVlQV0y6yYBzgaQ5E7rbGryzYIToxaOWGOli2RZvyWXK8IV9mhXeiedX5L1QIdYJyG2
         dZVsfw6i8YYayGJ7biwp/Z5WhHgtQW6Cq/McgYsoXmMZPc/8a1Nvm6t/NfY0ymcpONCT
         G6BsnJMDWqHO3KH241/m6dy0z6AgAJFO+JbxI6kTlvh/0YfB6jpoK9JRGmq9tlZC5KON
         yuH/pz1GXTur/7UgiwGukBy3z26zAJnALqBrZxnMxcuDNEW9b9niwIp0NbLUKa+cCzPS
         64xw==
X-Gm-Message-State: AOAM5331Pen1V/iOGsWsyjzCtyAelGGAwezFe33hqBTIC8gWj/ssU2Md
        TeYGQdWKoNEGAWo9bDEXnqv5qXNCSzpHuZ2nFxP582lVCN0Rnu6qg79Vr407nZzowBpIKQZMEjF
        WUK3y5vf6Bcst
X-Received: by 2002:adf:c7c4:: with SMTP id y4mr15910830wrg.344.1607716556876;
        Fri, 11 Dec 2020 11:55:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz35Db774FOFQJtNZehtgGSkkzyoc+OlRaX0BWq+XazIehY41w5XKk9/XU/lia6fg3rnZKC0A==
X-Received: by 2002:adf:c7c4:: with SMTP id y4mr15910816wrg.344.1607716556667;
        Fri, 11 Dec 2020 11:55:56 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id v1sm15636784wrr.48.2020.12.11.11.55.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Dec 2020 11:55:55 -0800 (PST)
Subject: Re: [PATCH] KVM/VMX: Use TEST %REG,%REG instead of CMP $0,%REG in
 vmenter.S
To:     Uros Bizjak <ubizjak@gmail.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>
References: <20201029140457.126965-1-ubizjak@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <99a9f224-a6aa-37ab-737f-b269381527ec@redhat.com>
Date:   Fri, 11 Dec 2020 20:55:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201029140457.126965-1-ubizjak@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/10/20 15:04, Uros Bizjak wrote:
> Saves one byte in __vmx_vcpu_run for the same functionality.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> ---
>   arch/x86/kvm/vmx/vmenter.S | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
> index 90ad7a6246e3..e85aa5faa22d 100644
> --- a/arch/x86/kvm/vmx/vmenter.S
> +++ b/arch/x86/kvm/vmx/vmenter.S
> @@ -132,7 +132,7 @@ SYM_FUNC_START(__vmx_vcpu_run)
>   	mov (%_ASM_SP), %_ASM_AX
>   
>   	/* Check if vmlaunch or vmresume is needed */
> -	cmpb $0, %bl
> +	testb %bl, %bl
>   
>   	/* Load guest registers.  Don't clobber flags. */
>   	mov VCPU_RCX(%_ASM_AX), %_ASM_CX
> 

Queued, thanks.  This was mistakenly marked as read, so I thought I had 
already applied it.

Paolo

