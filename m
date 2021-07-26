Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 975523D5A7A
	for <lists+kvm@lfdr.de>; Mon, 26 Jul 2021 15:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233961AbhGZNA1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 09:00:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58500 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233815AbhGZM7z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Jul 2021 08:59:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627306823;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hCZfOAl7ts2DxmB2QUu9PfkSKpATBw/UVjJQZQ4MLGY=;
        b=TQttGfI2IB7AJgKM+hx4k3foZbdof96W9QdthdKXsYEL3oHfsRlXDezVnegrwnSVdWAfLn
        jTOyBND01ybq0n7djo0SSQiZ+eHCs6rZ77aauMrOeRGISrSplP+OhX9T7fmrIyi1F54oH2
        DCkVhodJcddZH0dWcP6G8JSUL25fi1Q=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-545-bIWQWe7PN9yWzTj_qclA9w-1; Mon, 26 Jul 2021 09:40:22 -0400
X-MC-Unique: bIWQWe7PN9yWzTj_qclA9w-1
Received: by mail-ej1-f70.google.com with SMTP id hb18-20020a1709071612b029052883e9de3eso2059172ejc.19
        for <kvm@vger.kernel.org>; Mon, 26 Jul 2021 06:40:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hCZfOAl7ts2DxmB2QUu9PfkSKpATBw/UVjJQZQ4MLGY=;
        b=GN8bQGmkwj0ZKF/JFP40meY8zdU6vbe/a94dGL17iLER9cuHIxlwEQPPUpGq6rIU1Q
         sfcsWmw3t8Kb7Ft05tHaaXG0Q4IGpPvtTApO4yrWdPAaBT9gIzrZRsn2N2UIXyBq/O1F
         xrcVrB3olxy8aKI1MTRlz426sawiEfd6bYhvlPUJ2x17b+0h1SFPfC6Jn7V5CefbomTt
         zTxtsgpL9nKxiGKC6xPZ+VMqDyJK+1aOK9S0np+1MXSqmzqSxQxg/fReLJypGwWo6pf0
         TEnsNxq7L5QCYwsBHPkWdix8KC7CI4Wv0fen74BazVW5uWZ/m8bM8sbWdadiDjPAiG+j
         lneQ==
X-Gm-Message-State: AOAM532VklbbDz0zijClJQHMtEpBZLoskBmU0zZUwQi2zWarKZUo/Cuy
        PV/Ln8QZbQ8jqeraf8UxaaBFRQ0KdM0QMh96bbx5V+lnjwG3QpSONtJMqD1hPALWl9jea5Nfvb7
        l9WrpIbCBBWbF
X-Received: by 2002:a17:906:7a56:: with SMTP id i22mr16702987ejo.94.1627306821450;
        Mon, 26 Jul 2021 06:40:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzko4dcZu7JrLLGnLsOcz5h39r9ijD0U3NL4kNBCRhF6IB2UvPA+rdkEJbNblOqI4Hx/b10gw==
X-Received: by 2002:a17:906:7a56:: with SMTP id i22mr16702963ejo.94.1627306821229;
        Mon, 26 Jul 2021 06:40:21 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id r11sm14254275ejy.71.2021.07.26.06.40.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jul 2021 06:40:20 -0700 (PDT)
Subject: Re: [PATCH 5/6] kvm: allocate vcpu pointer array separately
To:     Juergen Gross <jgross@suse.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, kvmarm@lists.cs.columbia.edu
References: <20210701154105.23215-1-jgross@suse.com>
 <20210701154105.23215-6-jgross@suse.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <001b7eab-ed7b-da27-a623-057781cf1211@redhat.com>
Date:   Mon, 26 Jul 2021 15:40:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210701154105.23215-6-jgross@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/07/21 17:41, Juergen Gross wrote:
>   {
> -	if (!has_vhe())
> +	if (!has_vhe()) {
> +		kfree(kvm->vcpus);
>   		kfree(kvm);
> -	else
> +	} else {
> +		vfree(kvm->vcpus);
>   		vfree(kvm);
> +	}
>   }
>   
>   int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 79138c91f83d..39cbc4b6bffb 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1440,10 +1440,7 @@ static inline void kvm_ops_static_call_update(void)
>   }
>   
>   #define __KVM_HAVE_ARCH_VM_ALLOC
> -static inline struct kvm *kvm_arch_alloc_vm(void)
> -{
> -	return __vmalloc(kvm_x86_ops.vm_size, GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> -}
> +struct kvm *kvm_arch_alloc_vm(void);
>   void kvm_arch_free_vm(struct kvm *kvm);
>   
>   #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLB
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 3af398ef1fc9..a9b0bb2221ea 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10741,9 +10741,28 @@ void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
>   	static_call(kvm_x86_sched_in)(vcpu, cpu);
>   }
>   
> +struct kvm *kvm_arch_alloc_vm(void)
> +{
> +	struct kvm *kvm;
> +
> +	kvm = __vmalloc(kvm_x86_ops.vm_size, GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> +	if (!kvm)
> +		return NULL;
> +
> +	kvm->vcpus = __vmalloc(KVM_MAX_VCPUS * sizeof(void *),
> +			       GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> +	if (!kvm->vcpus) {
> +		vfree(kvm);
> +		kvm = NULL;
> +	}
> +

Let's keep this cleaner:

1) use kvfree in the common version of kvm_arch_free_vm

2) split __KVM_HAVE_ARCH_VM_ALLOC and __KVM_HAVE_ARCH_VM_FREE (ARM does 
not need it once kvfree is used)

3) define a __kvm_arch_free_vm version that is defined even if 
!__KVM_HAVE_ARCH_VM_FREE, and which can be used on x86.

Paolo

