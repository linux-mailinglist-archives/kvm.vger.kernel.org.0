Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 889352ED657
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 19:05:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728112AbhAGSEC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 13:04:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726326AbhAGSEC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 13:04:02 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE392C0612F4;
        Thu,  7 Jan 2021 10:03:21 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id d13so6474415wrc.13;
        Thu, 07 Jan 2021 10:03:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7HkYo3hhseG8cCptdN+osPHoMY17KY8nh1LDm978IDs=;
        b=DulLpsquGBc8SovCXMdxXZWgkOkHIf6/V0ss+Ufa4fi5FbUcukWaBZVRB5t4t52moZ
         +7nXn8hokE3BC/IY9c2J0aRyADOLPVfPlAoDPsi9WG9No/040dwJZ6n0wMSLrLz8Nv4N
         2sRwjSFTiIxVm8RNNAsEvC/jA93Rsaw24AejfneFtGkWqbpU5zZ5bWteyHmHcWBSmwYS
         I5dtvJSCFAtLYvFU6iCnm64JcaJ81/QJWIiW7haLlFWxnF67X31P9Ai5mISICg8ALWpZ
         HVy0OLg9v76nJCpWaU2KvBwOOPaWIfZ0ViWJJLs1EWpEhXhyotjIJeQYGQjjYTVUgteA
         I+ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7HkYo3hhseG8cCptdN+osPHoMY17KY8nh1LDm978IDs=;
        b=TnZjFBokX5HQCvSclGnjtjyYHSAB9DvtgN2VXn7XSDO3gimtLNQJ0DUPUEEmuLiz5X
         p7UR06uuAVpcmavaL+d/So06RW7G7/Dw6jLLi6sl8p+e2ZyI2Oq4ImUCr8rOTX6iNQa3
         dbUu+7dCbYhpmD3MywpS1OEZ+BVksLjK72ANIqen1Gf3HkCp8xrantkTNdvwiAWC++0V
         aFytqgnW4Nrzu0PBsQQc7n20Ar/0no3FRubR6+l0j47Z77NgRHRGtzNno7+YL6ldluZc
         XegXpucQxiGToLy8JkHRML8673wZ0XWCVpuxa57TVUIEdWsBjUyK1KRi6zXHQhvE0lgr
         mniQ==
X-Gm-Message-State: AOAM530oeoMikkKYffgHsBLQIUAqCm7TYbsbW8IK1C5AJrXmqoLl6kNO
        5A4ttXvV9F9L48GZcyplmXM=
X-Google-Smtp-Source: ABdhPJxnxjL0mrkLj7j/E51zcSGhgdSm9f29YImiKfNBwMKQp3mZKsa8IVaNZgUC2KhBY2dq4BCigQ==
X-Received: by 2002:adf:c387:: with SMTP id p7mr10092968wrf.95.1610042600441;
        Thu, 07 Jan 2021 10:03:20 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id m81sm8846433wmf.29.2021.01.07.10.03.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Jan 2021 10:03:19 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Subject: Re: [PATCH v2 2/4] KVM: nSVM: correctly restore nested_run_pending on
 migration
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>
References: <20210107093854.882483-1-mlevitsk@redhat.com>
 <20210107093854.882483-3-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <98f35e0a-d82b-cac0-b267-00fcba00c185@redhat.com>
Date:   Thu, 7 Jan 2021 19:03:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210107093854.882483-3-mlevitsk@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/01/21 10:38, Maxim Levitsky wrote:
> The code to store it on the migration exists, but no code was restoring it.
> 
> One of the side effects of fixing this is that L1->L2 injected events
> are no longer lost when migration happens with nested run pending.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>   arch/x86/kvm/svm/nested.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index ee4f2082ad1bd..cc3130ab612e5 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -1200,6 +1200,10 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>   	 * in the registers, the save area of the nested state instead
>   	 * contains saved L1 state.
>   	 */
> +
> +	svm->nested.nested_run_pending =
> +		!!(kvm_state->flags & KVM_STATE_NESTED_RUN_PENDING);
> +
>   	copy_vmcb_control_area(&hsave->control, &svm->vmcb->control);
>   	hsave->save = *save;
>   
> 

Nice fix and we need to do it anyway.

That said, the v1 change had some appeal to it.  In the VMX case (if 
properly implemented) it would allow removing the weird 
nested_run_pending case from prepare_vmcs02_early.  I think it's a 
valuable invariant that there are no events in the VMCS after each 
KVM_RUN iteration, and this special case is breaking the invariant.

Paolo
