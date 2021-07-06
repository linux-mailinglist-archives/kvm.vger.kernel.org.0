Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7696F3BD848
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 16:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232297AbhGFOgG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 10:36:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39832 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232225AbhGFOgE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 10:36:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625582005;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+TFQQRr4n0iTcvgZJfJSvRK8tc2ECNv5rYzqu0pkJ5A=;
        b=NxJvDVwcxLzCmpjxm6F8L4eKIW2KFfW46HX8b110437LrQPCDjPea+/3ZsEXOLw3JdUmV9
        qis35E/Qwxu1LOCiqHyAYCQYykx7IqjcZY7ShyUV+7etnvJEH721o6hxUvWfN3i2oehi6S
        VYTlYPoPEH06lnh9yWLLiFz0244kowE=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-229-ORQz7ZOpPPGoqSh_Ue1d4g-1; Tue, 06 Jul 2021 10:03:13 -0400
X-MC-Unique: ORQz7ZOpPPGoqSh_Ue1d4g-1
Received: by mail-ed1-f72.google.com with SMTP id w1-20020a0564022681b0290394cedd8a6aso10827634edd.14
        for <kvm@vger.kernel.org>; Tue, 06 Jul 2021 07:03:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+TFQQRr4n0iTcvgZJfJSvRK8tc2ECNv5rYzqu0pkJ5A=;
        b=dMb+lSvZ3o1zRnKwmVOtQp42CTWz3q7vLVcp/pkyup/Ka2tMIwu0aZSvitomkik6vF
         GGdZiwNM5RdFr8WEo14e+vTCapLLQabUSPFkOkCV/673GPRF03rOTIWN1AdkIvySCmnE
         l7UUIMc+EOEEtW76W0cSdoAiNBGMJ7Uv3skroOR9JMfNpL91Yta01N98X0BtB1HWIn7t
         KK43ZDD2aUoZRrUOubwjnDrV9Wt34ukHil/KBuXrCl/yGhC31FDLVx8QbOrp/LVomGy2
         d+MEyF+EjzOxnZqrM8EJVtdCeGYrDVnGxlt80nRTUXl67n4KVPuboBZ4oU0ppBgxVdhD
         0qOQ==
X-Gm-Message-State: AOAM530BnQpMctClMKeUdXSLalckKqI38EHEbvbQRy7csSXgHPewbdxZ
        lr7ZfN3Fru0863gSobCdjTIZBDZYP78AfUl8OpPGl469x2Uv/6ijMwTgKKEr/1s8y7q958PEFVA
        Ohom4Kq0R8/AP
X-Received: by 2002:a17:906:6047:: with SMTP id p7mr18568830ejj.206.1625580191630;
        Tue, 06 Jul 2021 07:03:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzundaRNXGNxnhRDhaYJpqcazvdtwjIQgZqHVgRq8AvEcPWbLzzoTG7559L3pCBjZpMZPNGUQ==
X-Received: by 2002:a17:906:6047:: with SMTP id p7mr18568797ejj.206.1625580191361;
        Tue, 06 Jul 2021 07:03:11 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id b5sm3300742ejz.122.2021.07.06.07.03.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jul 2021 07:03:10 -0700 (PDT)
Subject: Re: [RFC PATCH v2 28/69] KVM: Add per-VM flag to mark read-only
 memory as unsupported
To:     isaku.yamahata@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Brijesh Singh <brijesh.singh@amd.com>
Cc:     isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <1eb584469b41775380ab0a5a5d31a64e344b1b95.1625186503.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8c57204e-385e-1f54-cb15-760e174d122e@redhat.com>
Date:   Tue, 6 Jul 2021 16:03:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1eb584469b41775380ab0a5a5d31a64e344b1b95.1625186503.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/07/21 00:04, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Add a flag for TDX to flag RO memory as unsupported and propagate it to
> KVM_MEM_READONLY to allow reporting RO memory as unsupported on a per-VM
> basis.  TDX1 doesn't expose permission bits to the VMM in the SEPT
> tables, i.e. doesn't support read-only private memory.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>   arch/x86/kvm/x86.c       | 4 +++-
>   include/linux/kvm_host.h | 4 ++++
>   virt/kvm/kvm_main.c      | 8 +++++---
>   3 files changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index cd9407982366..87212d7563ae 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3897,7 +3897,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   	case KVM_CAP_ASYNC_PF_INT:
>   	case KVM_CAP_GET_TSC_KHZ:
>   	case KVM_CAP_KVMCLOCK_CTRL:
> -	case KVM_CAP_READONLY_MEM:
>   	case KVM_CAP_HYPERV_TIME:
>   	case KVM_CAP_IOAPIC_POLARITY_IGNORED:
>   	case KVM_CAP_TSC_DEADLINE_TIMER:
> @@ -4009,6 +4008,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   		if (static_call(kvm_x86_is_vm_type_supported)(KVM_X86_TDX_VM))
>   			r |= BIT(KVM_X86_TDX_VM);
>   		break;
> +	case KVM_CAP_READONLY_MEM:
> +		r = kvm && kvm->readonly_mem_unsupported ? 0 : 1;
> +		break;
>   	default:
>   		break;
>   	}
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index ddd4d0f68cdf..7ee7104b4b59 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -597,6 +597,10 @@ struct kvm {
>   	unsigned int max_halt_poll_ns;
>   	u32 dirty_ring_size;
>   
> +#ifdef __KVM_HAVE_READONLY_MEM
> +	bool readonly_mem_unsupported;
> +#endif
> +
>   	bool vm_bugged;
>   };
>   
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 52d40ea75749..63d0c2833913 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1258,12 +1258,14 @@ static void update_memslots(struct kvm_memslots *slots,
>   	}
>   }
>   
> -static int check_memory_region_flags(const struct kvm_userspace_memory_region *mem)
> +static int check_memory_region_flags(struct kvm *kvm,
> +				     const struct kvm_userspace_memory_region *mem)
>   {
>   	u32 valid_flags = KVM_MEM_LOG_DIRTY_PAGES;
>   
>   #ifdef __KVM_HAVE_READONLY_MEM
> -	valid_flags |= KVM_MEM_READONLY;
> +	if (!kvm->readonly_mem_unsupported)
> +		valid_flags |= KVM_MEM_READONLY;
>   #endif
>   
>   	if (mem->flags & ~valid_flags)
> @@ -1436,7 +1438,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
>   	int as_id, id;
>   	int r;
>   
> -	r = check_memory_region_flags(mem);
> +	r = check_memory_region_flags(kvm, mem);
>   	if (r)
>   		return r;
>   
> 

For all these flags, which of these limitations will be common to SEV-ES 
and SEV-SNP (ExtINT injection, MCE injection, changing TSC, read-only 
memory, dirty logging)?  Would it make sense to use vm_type instead of 
all of them?  I guess this also guides the choice of whether to use a 
single vm-type for TDX and SEV-SNP or two.  Probably two is better, and 
there can be static inline bool functions to derive the support flags 
from the vm-type.

Paolo

