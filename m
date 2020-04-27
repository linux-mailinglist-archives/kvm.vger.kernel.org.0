Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 444E81BAB34
	for <lists+kvm@lfdr.de>; Mon, 27 Apr 2020 19:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726372AbgD0R2K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 13:28:10 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44962 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726030AbgD0R2K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Apr 2020 13:28:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588008488;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AIdh8aRRTeVMDlIVe128qbh6x+vMtm/fPvnZdxCsjFc=;
        b=OUYBdPcBz41whDEAW3YRly0U+ea4oFKl2SXHUGsadCFtZ3WFkoCMwbBCelbSB8AGAoEcuu
        OJ62nniLq2bh7gYVNFEqnuSd099PCFLZzCtrysmAq57SGm1pS0mrhGRjuahmTXN817xOfd
        WJxaczEMMjJM7m09EextrrkE6H3bbtg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-243-20Ic7UlqPWqdsT5ENwH9tQ-1; Mon, 27 Apr 2020 13:28:07 -0400
X-MC-Unique: 20Ic7UlqPWqdsT5ENwH9tQ-1
Received: by mail-wm1-f72.google.com with SMTP id l21so156441wmh.2
        for <kvm@vger.kernel.org>; Mon, 27 Apr 2020 10:28:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AIdh8aRRTeVMDlIVe128qbh6x+vMtm/fPvnZdxCsjFc=;
        b=a3eu7JvBzdmrGPj4U95j2gSBAJbSNwvG00lr5CXKvzfLnTq9HiE+6UuIafOV3esZUC
         NznwnD8fNJv6aDVIOlgxJHlfE+C/I/teSxs4nL2AbuFS3v9Xx/YwE/KRdPcVMA/4ywdZ
         7zXmizHAu9cOhVM9/l2cdZPxcbabM2VHTmueUAsnZlBfvB5n36yvCt7PgXm78MleHvC8
         q6X35C3QTDamYX08cGJfHB8rVXFQiojR27U16SW3tYvwY8Cs860FB5Sa8ZGTGvZKXtGv
         g2zbjWMw+JYBIiiCZWwTcZWF+YmE6QFAmSA7fwWtS0Ke18uDcPU4RAWEQStje0O/K8iz
         K6LQ==
X-Gm-Message-State: AGi0PuZ+icXqoMq+wYcwXOjF5eEQ7GYsI8SzazD12sX/suXOgYZnMbQu
        o1tIf98ddohpRgCUX8CaGTmYg/18Xua6oY0TzvTO8P5AWmi1cs2YUBKWS4O16r6ldOH/WqFTmhC
        ScSDnOsD+mdfN
X-Received: by 2002:adf:fe51:: with SMTP id m17mr28105888wrs.414.1588008485623;
        Mon, 27 Apr 2020 10:28:05 -0700 (PDT)
X-Google-Smtp-Source: APiQypK7mAxrF469/q2T6gwPBIgiv6em6qBY0yYH5Pgcqs55CxifERpdCZbEIn1L7QLLUTzS2XWc8w==
X-Received: by 2002:adf:fe51:: with SMTP id m17mr28105867wrs.414.1588008485367;
        Mon, 27 Apr 2020 10:28:05 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id s14sm15422654wmh.18.2020.04.27.10.28.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2020 10:28:04 -0700 (PDT)
Subject: Re: [PATCH] KVM: VMX: Use accessor to read vmcs.INTR_INFO when
 handling exception
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200427171837.22613-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8123dc4b-a449-a92c-85a1-c255fa2bbbca@redhat.com>
Date:   Mon, 27 Apr 2020 19:28:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200427171837.22613-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/04/20 19:18, Sean Christopherson wrote:
> Use vmx_get_intr_info() when grabbing the cached vmcs.INTR_INFO in
> handle_exception_nmi() to ensure the cache isn't stale.  Bypassing the
> caching accessor doesn't cause any known issues as the cache is always
> refreshed by handle_exception_nmi_irqoff(), but the whole point of
> adding the proper caching mechanism was to avoid such dependencies.
> 
> Fixes: 8791585837f6 ("KVM: VMX: Cache vmcs.EXIT_INTR_INFO using arch avail_reg flags")
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 3ab6ca6062ce..7bddcb24f6f3 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4677,7 +4677,7 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
>  	u32 vect_info;
>  
>  	vect_info = vmx->idt_vectoring_info;
> -	intr_info = vmx->exit_intr_info;
> +	intr_info = vmx_get_intr_info(vcpu);
>  
>  	if (is_machine_check(intr_info) || is_nmi(intr_info))
>  		return 1; /* handled by handle_exception_nmi_irqoff() */
> 

Hasn't this been applied already?

Paolo

