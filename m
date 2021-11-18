Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 395A3455F35
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 16:18:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231527AbhKRPVg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 10:21:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38517 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230098AbhKRPVg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Nov 2021 10:21:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637248715;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QgXkGJ688S0o/76A+gCGwt0gcqR1CpWPpL2277SJRSY=;
        b=If6AaoLPe+mdaK6A1cKBF4idLCWK+O7dj0hfEgb1abLvcGh8P0drRx+DM8HZ3VDbr2i8lK
        D98a1aJibv8YGHCfpTX0Ta+DbNtqMXZIDTKzlAMN6YuNNa9hUNC2UKINPR5EG11AFWhG1/
        yvlpGLZ8s7UrEV6GY/inlXJeval0j9Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-310-0I7riz9_OryHhLQW_5MyNg-1; Thu, 18 Nov 2021 10:18:32 -0500
X-MC-Unique: 0I7riz9_OryHhLQW_5MyNg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B2FB61006AA2;
        Thu, 18 Nov 2021 15:18:30 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0F48B60C05;
        Thu, 18 Nov 2021 15:18:22 +0000 (UTC)
Message-ID: <e7bbd644-de17-882c-34b0-507d0b806699@redhat.com>
Date:   Thu, 18 Nov 2021 16:18:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 04/15] KVM: VMX: Add and use X86_CR4_TLB_BITS when
 !enable_ept
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
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
References: <20211108124407.12187-1-jiangshanlai@gmail.com>
 <20211108124407.12187-5-jiangshanlai@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211108124407.12187-5-jiangshanlai@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/8/21 13:43, Lai Jiangshan wrote:
> From: Lai Jiangshan <laijs@linux.alibaba.com>
> 
> In set_cr4_guest_host_mask(), X86_CR4_PGE is set to be intercepted when
> !enable_ept just because X86_CR4_PGE is the only bit that is
> responsible for flushing TLB but listed in KVM_POSSIBLE_CR4_GUEST_BITS.
> 
> It is clearer and self-documented to use X86_CR4_TLB_BITS instead.

Very good idea, but I'd go with a slightly clearer X86_CR4_TLBFLUSH_BITS.

Paolo

> No functionality changed.
> 
> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> ---
>   arch/x86/kvm/kvm_cache_regs.h | 2 ++
>   arch/x86/kvm/vmx/vmx.c        | 2 +-
>   2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
> index 90e1ffdc05b7..8fe036efa654 100644
> --- a/arch/x86/kvm/kvm_cache_regs.h
> +++ b/arch/x86/kvm/kvm_cache_regs.h
> @@ -9,6 +9,8 @@
>   	(X86_CR4_PVI | X86_CR4_DE | X86_CR4_PCE | X86_CR4_OSFXSR  \
>   	 | X86_CR4_OSXMMEXCPT | X86_CR4_PGE | X86_CR4_TSD | X86_CR4_FSGSBASE)
>   
> +#define X86_CR4_TLB_BITS (X86_CR4_PGE | X86_CR4_PCIDE | X86_CR4_PAE | X86_CR4_SMEP)
> +
>   #define BUILD_KVM_GPR_ACCESSORS(lname, uname)				      \
>   static __always_inline unsigned long kvm_##lname##_read(struct kvm_vcpu *vcpu)\
>   {									      \
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 79e5df5fbb32..1795702dc6de 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4107,7 +4107,7 @@ void set_cr4_guest_host_mask(struct vcpu_vmx *vmx)
>   	vcpu->arch.cr4_guest_owned_bits = KVM_POSSIBLE_CR4_GUEST_BITS &
>   					  ~vcpu->arch.cr4_guest_rsvd_bits;
>   	if (!enable_ept)
> -		vcpu->arch.cr4_guest_owned_bits &= ~X86_CR4_PGE;
> +		vcpu->arch.cr4_guest_owned_bits &= ~X86_CR4_TLB_BITS;
>   	if (is_guest_mode(&vmx->vcpu))
>   		vcpu->arch.cr4_guest_owned_bits &=
>   			~get_vmcs12(vcpu)->cr4_guest_host_mask;
> 

