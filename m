Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9A8E3BD8F1
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 16:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231979AbhGFOwv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 10:52:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20643 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231460AbhGFOwp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 10:52:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625583005;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TdTS8kT288fhAyYKqmagb6J2AHHMMCxI0DtI3y4+rk0=;
        b=OOP+bky2RWCbVBKCKzIgm2jEm/dHR1Nt0x2FW5H1Ue/yEMFckNMDs8tGoCu8Ujz210k1BP
        MxdmXthX+OstqFWcRwBbStpnifUvSg7+jigwArp+PFAbCeMwJNxkuZfVBPJkSrYH1hjzcm
        BhbWdyt8YYDjbsqHf/oh0BjGLPKIP00=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-235-EwP6vab4MNW5LJHkLA5ekw-1; Tue, 06 Jul 2021 10:50:04 -0400
X-MC-Unique: EwP6vab4MNW5LJHkLA5ekw-1
Received: by mail-wr1-f71.google.com with SMTP id y5-20020adfe6c50000b02901258bf1d760so7246820wrm.14
        for <kvm@vger.kernel.org>; Tue, 06 Jul 2021 07:50:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TdTS8kT288fhAyYKqmagb6J2AHHMMCxI0DtI3y4+rk0=;
        b=O7tfPCp4t2bgAJgJs37bf+ahs2/Gnu1Cu1USPRnEHWU/wgxgjf1SmxY9QMPb5DxyQv
         z4Wa5z0JjEhEoSHLFjFmlCPydSWRiuOPqIgFu4pkQlRFgd6bFppzkoyxTObMpIg06Ao9
         uKbJ3GCdUzAi4luMInfw2PcMy3t3ZqMZdsSmeWHi4rA4dj+x/qFKmz9w6Zt2sb9p6enn
         xRja2nzNnRLRxgoJhZ0xO4y95s6pVM08QhHlp8rtfenty9b3hUygKBN2+eY7uL4ZHXhf
         kA9cItfQo/YyQsOnsLCtRHkv2ykvuHZiW4ZLkSdPxXuvcbWhO6VFhkhXMo82UHTQkF3o
         NGNw==
X-Gm-Message-State: AOAM5327tgV9iFsX5VHX5y7KkF6TTVVOYNhpxgbrIcS3R1lmcdSthbaf
        MrIAYcTu49Kjg6JKkOfqD3JnKHGKOpr2ABzj5uWtrkoxgjaeycqyzhUZwwRPO00ZYr+kVE0/bm2
        eA0Tp3vqdt92C
X-Received: by 2002:a05:600c:19d1:: with SMTP id u17mr20881441wmq.177.1625583003531;
        Tue, 06 Jul 2021 07:50:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwcFU4w1Goi12UWvOnmDkmQSuExGESuRg8DpVmkjziNO9hSb2+42NzC5kTSrUCWvAby/xRO0w==
X-Received: by 2002:a05:600c:19d1:: with SMTP id u17mr20881409wmq.177.1625583003387;
        Tue, 06 Jul 2021 07:50:03 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id o19sm3097448wmc.12.2021.07.06.07.50.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jul 2021 07:50:02 -0700 (PDT)
Subject: Re: [RFC PATCH v2 49/69] KVM: VMX: Modify NMI and INTR handlers to
 take intr_info as param
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
 <19efa94306ba82e433602af45d122265fa39b0c4.1625186503.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d3bfe742-151f-d33c-c7c7-0ca9e64b34fa@redhat.com>
Date:   Tue, 6 Jul 2021 16:50:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <19efa94306ba82e433602af45d122265fa39b0c4.1625186503.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/07/21 00:04, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Pass intr_info to the NMI and INTR handlers instead of pulling it from
> vcpu_vmx in preparation for sharing the bulk of the handlers with TDX.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/vmx/vmx.c | 15 +++++++--------
>   1 file changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 7ce15a2c3490..e08f85c93e55 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6404,25 +6404,24 @@ static void handle_interrupt_nmi_irqoff(struct kvm_vcpu *vcpu,
>   	kvm_after_interrupt(vcpu);
>   }
>   
> -static void handle_exception_nmi_irqoff(struct vcpu_vmx *vmx)
> +static void handle_exception_nmi_irqoff(struct kvm_vcpu *vcpu, u32 intr_info)
>   {
>   	const unsigned long nmi_entry = (unsigned long)asm_exc_nmi_noist;
> -	u32 intr_info = vmx_get_intr_info(&vmx->vcpu);
>   
>   	/* if exit due to PF check for async PF */
>   	if (is_page_fault(intr_info))
> -		vmx->vcpu.arch.apf.host_apf_flags = kvm_read_and_reset_apf_flags();
> +		vcpu->arch.apf.host_apf_flags = kvm_read_and_reset_apf_flags();
>   	/* Handle machine checks before interrupts are enabled */
>   	else if (is_machine_check(intr_info))
>   		kvm_machine_check();
>   	/* We need to handle NMIs before interrupts are enabled */
>   	else if (is_nmi(intr_info))
> -		handle_interrupt_nmi_irqoff(&vmx->vcpu, nmi_entry);
> +		handle_interrupt_nmi_irqoff(vcpu, nmi_entry);
>   }
>   
> -static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
> +static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu,
> +					     u32 intr_info)
>   {
> -	u32 intr_info = vmx_get_intr_info(vcpu);
>   	unsigned int vector = intr_info & INTR_INFO_VECTOR_MASK;
>   	gate_desc *desc = (gate_desc *)host_idt_base + vector;
>   
> @@ -6438,9 +6437,9 @@ static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
>   	struct vcpu_vmx *vmx = to_vmx(vcpu);
>   
>   	if (vmx->exit_reason.basic == EXIT_REASON_EXTERNAL_INTERRUPT)
> -		handle_external_interrupt_irqoff(vcpu);
> +		handle_external_interrupt_irqoff(vcpu, vmx_get_intr_info(vcpu));
>   	else if (vmx->exit_reason.basic == EXIT_REASON_EXCEPTION_NMI)
> -		handle_exception_nmi_irqoff(vmx);
> +		handle_exception_nmi_irqoff(vcpu, vmx_get_intr_info(vcpu));
>   }
>   
>   /*
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

