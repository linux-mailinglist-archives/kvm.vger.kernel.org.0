Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0C7E436B6F
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 21:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231611AbhJUTp6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 15:45:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35673 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230020AbhJUTp5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Oct 2021 15:45:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634845421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jA5+/YLOXXotQtGi2/7M4WZlbe47Qp+2MvjCtlJSlO4=;
        b=HUd0db9oSj/oWgVrz+Ao2NrrQyWHg+B9vzV1B+4gZiCASwBmeNxnn0AclVRZT9DgV6eTDp
        PKF+u/G19YWQ12VB/R1ffYW3eO9HWSmIxiLG14Uc449uGTU332XQn2763HC/P87lPUzPWD
        w26tduhXiNIOA07EbaMLYDktgxBvv9I=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-388-1Vyd3eqvPA-aBLYktbpaRw-1; Thu, 21 Oct 2021 15:43:39 -0400
X-MC-Unique: 1Vyd3eqvPA-aBLYktbpaRw-1
Received: by mail-ed1-f70.google.com with SMTP id t18-20020a056402021200b003db9e6b0e57so1444013edv.10
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 12:43:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=jA5+/YLOXXotQtGi2/7M4WZlbe47Qp+2MvjCtlJSlO4=;
        b=McmPXjHsnpMFUmEwWIB+4UYVBQWypmAGEyrJp5MSoXwwRTM0lEHW592yC7m1gtnWks
         3RN4C25R3WjA8cA+nRT2OV7vIqziZ5v3OW2yKzqUauZs337Eu0lEsa+hV4jWczrPeI0B
         5F9EyM7tE0b4LCfEuU5s5/iImT0jnLLfDouBCN5sN8HZk8I6ZHVRSj3c60iLHEFeD26Q
         GLY8BoTLZzl0ne8z85TLI5afRnF40s2cswRvw0ze+0eDglDow8gYSnWvmcWXhE6oVlaY
         oi4xxGVXiCDrD0ndx1jY6sBkGSrNSTPTJV/3uLVnTtaOJvNUrCVaXW7ZDm+q1uRibH4b
         cngA==
X-Gm-Message-State: AOAM533Ny/Ca5YlTPZ6VLImTsmBe2oMjpHUFIBtJRkY5M2i+GV2fiS6r
        yZ35LTGX5fq69Y4ZfFQI1ri90tbGaLh2L3h8TZ3tuKKOvgQXl9Odrml36hKaWbS3lcMHB5IVDW5
        6RXd7yrjWMK1l
X-Received: by 2002:a17:906:3842:: with SMTP id w2mr9951013ejc.28.1634845418710;
        Thu, 21 Oct 2021 12:43:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy2Pc0sZLEakmIY7IoYcyNraQH6cmIu6PwtuSJfu97RkCshSRmWBynXFw9s+hWcrXu92f78pw==
X-Received: by 2002:a17:906:3842:: with SMTP id w2mr9950993ejc.28.1634845418483;
        Thu, 21 Oct 2021 12:43:38 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id j1sm3264483edk.53.2021.10.21.12.43.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Oct 2021 12:43:37 -0700 (PDT)
Message-ID: <4b81af0a-559e-b8f5-ab8a-167c88fec2d5@redhat.com>
Date:   Thu, 21 Oct 2021 21:43:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH 4/4] KVM: VMX: Register posted interrupt wakeup handler
 iff APICv is enabled
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20211009001107.3936588-1-seanjc@google.com>
 <20211009001107.3936588-5-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211009001107.3936588-5-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/10/21 02:11, Sean Christopherson wrote:
> Don't bother registering a posted interrupt wakeup handler if APICv is
> disabled, KVM utilizes the wakeup vector if and only if APICv is enabled.
> Practically speaking, there's no meaningful functional change as KVM's
> wakeup handler is a glorified nop if there are no vCPUs using posted
> interrupts, not to mention that nothing in the system should be sending
> wakeup interrupts when APICv is disabled.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/vmx/vmx.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 9164f1870d49..df9ad4675215 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7553,7 +7553,8 @@ static void vmx_migrate_timers(struct kvm_vcpu *vcpu)
>   
>   static void hardware_unsetup(void)
>   {
> -	kvm_unregister_posted_intr_wakeup_handler(pi_wakeup_handler);
> +	if (enable_apicv)
> +		kvm_unregister_posted_intr_wakeup_handler(pi_wakeup_handler);
>   
>   	if (nested)
>   		nested_vmx_hardware_unsetup();
> @@ -7907,7 +7908,8 @@ static __init int hardware_setup(void)
>   	if (r)
>   		nested_vmx_hardware_unsetup();
>   
> -	kvm_register_posted_intr_wakeup_handler(pi_wakeup_handler);
> +	if (enable_apicv)
> +		kvm_register_posted_intr_wakeup_handler(pi_wakeup_handler);
>   
>   	return r;
>   }

Also adds unnecessary complexity (you have to ensure the condition 
cannot change from one call to the other), so I am only queuing patches 
1 and 2.

Paolo

