Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67EB9455A06
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 12:21:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343800AbhKRLYZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 06:24:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36318 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343639AbhKRLWC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Nov 2021 06:22:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637234341;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PJitnqPLBSkM+mYouKpFhG+7JBnN4rgOMnx+Y3fh6Vc=;
        b=aWnpLcT5B+a1Cksk74HvvhotGp3eq9e14hypj5PhITw4hjlU6JlgZgILNL45/cqTQhVr+P
        +7C1zI5HkhkhoIFj66J5bay1KLCEXzl5Uagmen/cvkQZGBw/6KmwrrXIc9tnj5wa26/khE
        NvT3MT1St14x73nemiiG6ON0fn7Y/J0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-406-ifnd4lH9NTG_rEHC7c_tCg-1; Thu, 18 Nov 2021 06:18:58 -0500
X-MC-Unique: ifnd4lH9NTG_rEHC7c_tCg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D1AEE180831C;
        Thu, 18 Nov 2021 11:18:56 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5FA0660240;
        Thu, 18 Nov 2021 11:18:40 +0000 (UTC)
Message-ID: <94d4b7d8-1e56-69e9-dd52-d154bee6c461@redhat.com>
Date:   Thu, 18 Nov 2021 12:18:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 02/15] KVM: VMX: Avoid to rdmsrl(MSR_IA32_SYSENTER_ESP)
Content-Language: en-US
To:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, Lai Jiangshan <laijs@linux.alibaba.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20211118110814.2568-1-jiangshanlai@gmail.com>
 <20211118110814.2568-3-jiangshanlai@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211118110814.2568-3-jiangshanlai@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/18/21 12:08, Lai Jiangshan wrote:
> From: Lai Jiangshan <laijs@linux.alibaba.com>
> 
> The value of host MSR_IA32_SYSENTER_ESP is known to be constant for
> each CPU: (cpu_entry_stack(cpu) + 1) when 32 bit syscall is enabled or
> NULL is 32 bit syscall is not enabled.
> 
> So rdmsrl() can be avoided for the first case and both rdmsrl() and
> vmcs_writel() can be avoided for the second case.
> 
> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>

Then it's not constant host state, isn't?  The hunk in 
vmx_set_constant_host_state seems wrong.

Paolo

> ---
>   arch/x86/kvm/vmx/vmx.c | 10 +++++++---
>   1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 48a34d1a2989..4e4a33226edb 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1271,7 +1271,6 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
>   
>   	if (!already_loaded) {
>   		void *gdt = get_current_gdt_ro();
> -		unsigned long sysenter_esp;
>   
>   		/*
>   		 * Flush all EPTP/VPID contexts, the new pCPU may have stale
> @@ -1287,8 +1286,11 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
>   			    (unsigned long)&get_cpu_entry_area(cpu)->tss.x86_tss);
>   		vmcs_writel(HOST_GDTR_BASE, (unsigned long)gdt);   /* 22.2.4 */
>   
> -		rdmsrl(MSR_IA32_SYSENTER_ESP, sysenter_esp);
> -		vmcs_writel(HOST_IA32_SYSENTER_ESP, sysenter_esp); /* 22.2.3 */
> +		if (IS_ENABLED(CONFIG_IA32_EMULATION) || IS_ENABLED(CONFIG_X86_32)) {
> +			/* 22.2.3 */
> +			vmcs_writel(HOST_IA32_SYSENTER_ESP,
> +				    (unsigned long)(cpu_entry_stack(cpu) + 1));
> +		}
>   
>   		vmx->loaded_vmcs->cpu = cpu;
>   	}
> @@ -4021,6 +4023,8 @@ void vmx_set_constant_host_state(struct vcpu_vmx *vmx)
>   
>   	rdmsr(MSR_IA32_SYSENTER_CS, low32, high32);
>   	vmcs_write32(HOST_IA32_SYSENTER_CS, low32);
> +	rdmsrl(MSR_IA32_SYSENTER_ESP, tmpl);
> +	vmcs_writel(HOST_IA32_SYSENTER_ESP, tmpl);
>   	rdmsrl(MSR_IA32_SYSENTER_EIP, tmpl);
>   	vmcs_writel(HOST_IA32_SYSENTER_EIP, tmpl);   /* 22.2.3 */


