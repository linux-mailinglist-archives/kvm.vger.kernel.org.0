Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC75446F29E
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 18:57:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242941AbhLISA4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 13:00:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237713AbhLISA4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 13:00:56 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BF5AC061746;
        Thu,  9 Dec 2021 09:57:22 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id t5so21799062edd.0;
        Thu, 09 Dec 2021 09:57:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vqYJs8ulCPYB6TV0uKw95U9Qt8mnj6uUyMoCrLDmeno=;
        b=Y55T6pHryCo6jBHye2ztoPCjeRsE5RiCzDMV8dRa0nx+MQOx7nWHx8RV9xFvh+zsGP
         OqkQmM1I5YBgGoevUcszC4o3DBJrXQimSzQm7wGkLObHXsMLZR3G1lZ61wvcVnUrqq+3
         mw+d+5Gzp6RYIMae0GQgiJkMK4r5D0Op34/tTe59+w0UhJ8M/UeFuQEiNmZNm//hA3yc
         us5xvHahEEsueud1DUpU946wRIGZ0wAGpyG+iBITENKzMHbbg9qDXUd/BlqVbC3sA4vk
         988SciurOMCQWQmCF/NT5ViaDRKFl43XLipUpSeXJCQaV9ThaQ8qSi+Dxn6t5dV6YH/f
         4ulQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vqYJs8ulCPYB6TV0uKw95U9Qt8mnj6uUyMoCrLDmeno=;
        b=RL6j6mJAN9DFR6j/hEj2O+EhwYDSanjg+MhtFi2khRuiNJo8d8yRN2DChnwGLzlL4S
         j37jgFJqlT3LWf3sBo2sJtd7kB8iuqDl6d7eO5MwMXil+ODh4XVGvqXhIhK5R+uQnzAO
         7bFNUDPFIA1UEersa8Jy39w6o6FYqO/5IuTyiytvYmbskcKek1Pob3nGCHhZfrC8e1HJ
         SXpohF0w+20SR5ZCNc9s0JX7PbAHghge4tFr7smKBfbU3IQMo3QVe3IVsXH6bWTb+b25
         askE/Yr5kDgl4NhudxMCSnaKDplnGZ0kIXRLd+L6xSYynC8eStWvud87GpUJFg4y73Vm
         HKRQ==
X-Gm-Message-State: AOAM533+8s28rlkubsAr/j9/YB8jU+b0RmeA34sY4brXduFNC6+VqqZm
        0CKnWmJ0rEqNxzhq7MAGcUE=
X-Google-Smtp-Source: ABdhPJyKTSLZGm8P+5u/1t09ws9SyWIvKZ/EiazfBaOngsVJioYhDnEGXuuObeyYEdUAs8uVj8UlLA==
X-Received: by 2002:aa7:d941:: with SMTP id l1mr31320710eds.85.1639072507252;
        Thu, 09 Dec 2021 09:55:07 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id g15sm275736ejt.10.2021.12.09.09.55.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Dec 2021 09:55:06 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <51bb6e75-4f0a-e544-d2e4-ff23c5aa2f49@redhat.com>
Date:   Thu, 9 Dec 2021 18:55:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] KVM: X86: Raise #GP when clearing CR0_PG in 64 bit mode
Content-Language: en-US
To:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20211207095230.53437-1-jiangshanlai@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211207095230.53437-1-jiangshanlai@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/7/21 10:52, Lai Jiangshan wrote:
> From: Lai Jiangshan <laijs@linux.alibaba.com>
> 
> In the SDM:
> If the logical processor is in 64-bit mode or if CR4.PCIDE = 1, an
> attempt to clear CR0.PG causes a general-protection exception (#GP).
> Software should transition to compatibility mode and clear CR4.PCIDE
> before attempting to disable paging.
> 
> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> ---
>   arch/x86/kvm/x86.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 00f5b2b82909..78c40ac3b197 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -906,7 +906,8 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
>   	    !load_pdptrs(vcpu, kvm_read_cr3(vcpu)))
>   		return 1;
>   
> -	if (!(cr0 & X86_CR0_PG) && kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE))
> +	if (!(cr0 & X86_CR0_PG) &&
> +	    (is_64_bit_mode(vcpu) || kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE)))
>   		return 1;
>   
>   	static_call(kvm_x86_set_cr0)(vcpu, cr0);
> 

Queued, thanks.

Paolo
