Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2D7B3BD851
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 16:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232198AbhGFOhV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 10:37:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43300 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231937AbhGFOhU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 10:37:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625582081;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G/gssxW/mbIhY3PmRppDUAwsg3OaI9WCT71TjUjACeA=;
        b=fGV5nQt+jG4lfliGdO5oXqzy686K3xlWrtU7PvrFWMm/S+M/xKsJ+6SUtfN2cpfTHaY+qL
        i6uW9U2yIT2F61Q79NTi52Zb04lfTtoqUU1eTuyBoWUedq8czIA6Q5k683RBOaaKue1c/S
        eN5MfPn0pm39zEJGlSW7Ezyu9Hi/R7M=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-559-BAqmqvFJMV67V1wDPw8_kg-1; Tue, 06 Jul 2021 10:34:40 -0400
X-MC-Unique: BAqmqvFJMV67V1wDPw8_kg-1
Received: by mail-wm1-f70.google.com with SMTP id v25-20020a1cf7190000b0290197a4be97b7so1005279wmh.9
        for <kvm@vger.kernel.org>; Tue, 06 Jul 2021 07:34:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=G/gssxW/mbIhY3PmRppDUAwsg3OaI9WCT71TjUjACeA=;
        b=EoeBNUWMnfW+VzoCrsa5eiXECE/SnugXjRbEo9i6Etr61+QuGtrtJR/mS38SBj4WMB
         h0+fln+CbLcUObgDjzYWVDTkHX67K8xuR+FJHQBAgq9aMEFl/7rL/Nsn5O7MwOFXUo+M
         EAohSuowzDXnXLTqgsizIQxQPdasbdu5rHPgENo4wknh9XC9aD8hiw8q98p8Nmfq09rJ
         +4Yz/u3+lQR5iVJag5E9ZKDeGY09jGMxj6K6Bj04aFAsl8O/MtaR6BP1Z0C7CXlmWuXb
         MfQsBrlZRiD5PPLV0kg/Wetde2Nu0YdRZoHl6rksE3rzMs1uMMwrsLwQ44YQYupbmBAr
         9jeg==
X-Gm-Message-State: AOAM533zke/NKqueWDPzphzOaf/9QWSF6kP3DVtECDu1riJbaO2oQHgq
        SKyZCncuvlPkX26+5c94qwJ9wcp8T3o2+mA3SGLW9pHiJxngm9hZW2QgL7m+XWbWs8f/1S5JWLD
        hPLmI0ZQxC47Q
X-Received: by 2002:a05:6000:1787:: with SMTP id e7mr21954383wrg.167.1625582079466;
        Tue, 06 Jul 2021 07:34:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyta9Y16G3a+VI4XCXTFQBPTRZDYBxdBee0/p86BqoXT5KemnytIPbM4B6FvK7NsjZAlgpykw==
X-Received: by 2002:a05:6000:1787:: with SMTP id e7mr21954354wrg.167.1625582079256;
        Tue, 06 Jul 2021 07:34:39 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id w1sm15936566wmi.13.2021.07.06.07.34.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jul 2021 07:34:38 -0700 (PDT)
To:     isaku.yamahata@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <ac17ee5e713b83ce64626b7b39c40515d98db09f.1625186503.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH v2 35/69] KVM: x86: Introduce vm_teardown() hook in
 kvm_arch_vm_destroy()
Message-ID: <98e17bdc-cc91-f225-b24a-d64e052e1b3d@redhat.com>
Date:   Tue, 6 Jul 2021 16:34:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <ac17ee5e713b83ce64626b7b39c40515d98db09f.1625186503.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/07/21 00:04, isaku.yamahata@intel.com wrote:
> -static void svm_vm_destroy(struct kvm *kvm)
> +static void svm_vm_teardown(struct kvm *kvm)
>   {
>   	avic_vm_destroy(kvm);
>   	sev_vm_destroy(kvm);
>   }

Please keep "destroy" as is and use "free" from the final step.

> +static void svm_vm_destroy(struct kvm *kvm)
> +{
> +

Please remove the empty lines.

Paolo

> +}
> +
>   static bool svm_is_vm_type_supported(unsigned long type)
>   {
>   	return type == KVM_X86_LEGACY_VM;
> @@ -4456,6 +4461,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>   	.is_vm_type_supported = svm_is_vm_type_supported,
>   	.vm_size = sizeof(struct kvm_svm),
>   	.vm_init = svm_vm_init,
> +	.vm_teardown = svm_vm_teardown,
>   	.vm_destroy = svm_vm_destroy,
>   
>   	.prepare_guest_switch = svm_prepare_guest_switch,
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 84c2df824ecc..36756a356704 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6995,6 +6995,16 @@ static int vmx_vm_init(struct kvm *kvm)
>   	return 0;
>   }
>   
> +static void vmx_vm_teardown(struct kvm *kvm)
> +{
> +
> +}
> +
> +static void vmx_vm_destroy(struct kvm *kvm)
> +{
> +
> +}
> +
>   static int __init vmx_check_processor_compat(void)
>   {
>   	struct vmcs_config vmcs_conf;
> @@ -7613,6 +7623,8 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
>   	.is_vm_type_supported = vmx_is_vm_type_supported,
>   	.vm_size = sizeof(struct kvm_vmx),
>   	.vm_init = vmx_vm_init,
> +	.vm_teardown = vmx_vm_teardown,
> +	.vm_destroy = vmx_vm_destroy,
>   
>   	.vcpu_create = vmx_create_vcpu,
>   	.vcpu_free = vmx_free_vcpu,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index da9f1081cb03..4b436cae1732 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11043,7 +11043,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>   		__x86_set_memory_region(kvm, TSS_PRIVATE_MEMSLOT, 0, 0);
>   		mutex_unlock(&kvm->slots_lock);
>   	}
> -	static_call_cond(kvm_x86_vm_destroy)(kvm);
> +	static_call(kvm_x86_vm_teardown)(kvm);
>   	kvm_free_msr_filter(srcu_dereference_check(kvm->arch.msr_filter, &kvm->srcu, 1));
>   	kvm_pic_destroy(kvm);
>   	kvm_ioapic_destroy(kvm);
> @@ -11054,6 +11054,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>   	kvm_page_track_cleanup(kvm);
>   	kvm_xen_destroy_vm(kvm);
>   	kvm_hv_destroy_vm(kvm);
> +	static_call_cond(kvm_x86_vm_destroy)(kvm);
>   }
>   
>   void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
> 

