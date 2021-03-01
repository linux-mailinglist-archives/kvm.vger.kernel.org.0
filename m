Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0843E32888B
	for <lists+kvm@lfdr.de>; Mon,  1 Mar 2021 18:45:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238391AbhCARm1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Mar 2021 12:42:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234518AbhCARkg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Mar 2021 12:40:36 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF648C06178A
        for <kvm@vger.kernel.org>; Mon,  1 Mar 2021 09:39:52 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id d12so9441902pfo.7
        for <kvm@vger.kernel.org>; Mon, 01 Mar 2021 09:39:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VIEVnYfBURNQaEk7q+gL1sk168GjsFz+wyAEY3Zaj6Y=;
        b=LzapItJfq2azam+0YDJzUf2208kzzrWmIIkwteaTmAPiBPHksFPFpeeTUDkasfW7Fp
         5g6NCG5TnFQ2USBk2DUEjDtPXjVLVGWp+V6QRzwwvgC3ScsUObjYYbd/uW0ODsOiXwou
         YQ03goXSEkW3FTfGB8SBZvjHj2fqYZ4aXWmqz1Df91bJt3qOZG1z67w/IbqQkhM6Ame6
         yPyIzm0byUxbjuPQi9Okr6PISi9IrFjzSJs3EsYj8C9AbyQrE5acErzEBs9SEw8Kz1M9
         vZ5a5sgamoGr7yNoUBibH6sPUJeY02KShPQYSvDO0Omcf+gNYgSXp4K9fucd5yP0mup/
         pfIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VIEVnYfBURNQaEk7q+gL1sk168GjsFz+wyAEY3Zaj6Y=;
        b=ZLLXqVT++F56vkybUQhQo9vZ3RJ6USTrfhp+EhJ4xD9H55eDo5ZfoARpsfKV2NjLd9
         APMjg/6mRVizdqOWuUBo4kquOnbevTo6OLl6mkOvKSMndjJtZZlTUYV1sbpukNxNSQiX
         yih5hLPYI3QwmXrOTR1O0AM1VYY7j3tJmkVQWR9HOoTjpms8C1KxYFAUhb8C6IFIVQAE
         VBDR3jt12qDgJos84GKQ81QH27s9NIc8o0ayUjucAG/8VWFQU4iKZwIuwROO4Sl0gIK8
         FGLjwzRSlDTBFYijcCf6a4aKJUqw+GxdNn5SXzB+Z3FcTej1sgABXjf08ylhz7RuH21a
         f5dw==
X-Gm-Message-State: AOAM532GnltA08sOKtK7n4xAJyY5GDk/lKEJjW3AR+I2Jwj/moeuZJcf
        GipIpFP8MWS2vYVmQ9iulexpZQ==
X-Google-Smtp-Source: ABdhPJw47eR96CR8PofpQISJ7ZeuuR2MHmvxNh2DN/a0kX+iFy2LxhpWypfYtOqIiE84wmXqqEDwDw==
X-Received: by 2002:a63:e911:: with SMTP id i17mr4202297pgh.255.1614620392312;
        Mon, 01 Mar 2021 09:39:52 -0800 (PST)
Received: from google.com ([2620:15c:f:10:5d06:6d3c:7b9:20c9])
        by smtp.gmail.com with ESMTPSA id z16sm16503070pgj.51.2021.03.01.09.39.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 09:39:51 -0800 (PST)
Date:   Mon, 1 Mar 2021 09:39:45 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Set X86_CR4_CET in cr4_fixed1_bits if CET IBT
 is enabled
Message-ID: <YD0m4cALoArLO4ek@google.com>
References: <20210225030951.17099-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210225030951.17099-1-weijiang.yang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 25, 2021, Yang Weijiang wrote:
> CET SHSTK and IBT are independently controlled by kernel, set X86_CR4_CET
> bit in cr4_fixed1_bits if either of them is enabled so that nested guest
> can enjoy the feature.
> 
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 5856c5b81084..e92134ee081c 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7258,6 +7258,7 @@ static void nested_vmx_cr_fixed1_bits_update(struct kvm_vcpu *vcpu)
>  	cr4_fixed1_update(X86_CR4_UMIP,       ecx, feature_bit(UMIP));
>  	cr4_fixed1_update(X86_CR4_LA57,       ecx, feature_bit(LA57));
>  	cr4_fixed1_update(X86_CR4_CET,	      ecx, feature_bit(SHSTK));
> +	cr4_fixed1_update(X86_CR4_CET,	      edx, feature_bit(IBT));

Ugh, what sadist put SHSTK and IBT in separate output registers.

Reviewed-by: Sean Christopherson <seanjc@google.com>

>  
>  #undef cr4_fixed1_update
>  }
> -- 
> 2.26.2
> 
