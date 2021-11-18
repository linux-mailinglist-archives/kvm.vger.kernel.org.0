Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AADE45601B
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 17:06:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232882AbhKRQI6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 11:08:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49068 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231167AbhKRQI6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Nov 2021 11:08:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637251557;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CP4HVUwyCXLglaJMn5giAMMYbfCEGfvRmGXa6Q3B3Ls=;
        b=KQ9qUsKDUwUIZm1Cl0hwHVRdk71KJpr6pY2srjasQzjjhjXr7vG5kLZcpjfcFVRpzWaz+Q
        WbmA3osmuo2eryvf58ZtPbFgaYV257KjRvsfWdwLdyFpBSS+Ox8mFs8gd04B6lQGduguv4
        YB+niKIFfozRbxGNb7EVKRyBinV+QCU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-322-Hn9QUDsfONG2GXwobF2uXw-1; Thu, 18 Nov 2021 11:05:54 -0500
X-MC-Unique: Hn9QUDsfONG2GXwobF2uXw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 328CA101F7A5;
        Thu, 18 Nov 2021 16:05:52 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3D3E114104;
        Thu, 18 Nov 2021 16:05:48 +0000 (UTC)
Message-ID: <4f40ed93-eca0-7a19-5ad6-b48fcf8e281f@redhat.com>
Date:   Thu, 18 Nov 2021 17:05:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 01/15] KVM: VMX: Use x86 core API to access to fs_base and
 inactive gs_base
Content-Language: en-US
To:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, Lai Jiangshan <laijs@linux.alibaba.com>,
        x86@kernel.org, Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>
References: <20211118110814.2568-1-jiangshanlai@gmail.com>
 <20211118110814.2568-2-jiangshanlai@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211118110814.2568-2-jiangshanlai@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/18/21 12:08, Lai Jiangshan wrote:
> From: Lai Jiangshan <laijs@linux.alibaba.com>
> 
> And they use FSGSBASE instructions when enabled.
> 
> Cc: x86@kernel.org
> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>

This needs ACK from x86 maintainers.

I queued 2-4 and 6-14.

Paolo

> ---
>   arch/x86/include/asm/kvm_host.h | 10 ----------
>   arch/x86/kernel/process_64.c    |  2 ++
>   arch/x86/kvm/vmx/vmx.c          | 14 +++++++-------
>   3 files changed, 9 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 1fcb345bc107..4cbb402f5636 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1808,16 +1808,6 @@ static inline void kvm_load_ldt(u16 sel)
>   	asm("lldt %0" : : "rm"(sel));
>   }
>   
> -#ifdef CONFIG_X86_64
> -static inline unsigned long read_msr(unsigned long msr)
> -{
> -	u64 value;
> -
> -	rdmsrl(msr, value);
> -	return value;
> -}
> -#endif
> -
>   static inline void kvm_inject_gp(struct kvm_vcpu *vcpu, u32 error_code)
>   {
>   	kvm_queue_exception_e(vcpu, GP_VECTOR, error_code);
> diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
> index 3402edec236c..296bd5c2e38b 100644
> --- a/arch/x86/kernel/process_64.c
> +++ b/arch/x86/kernel/process_64.c
> @@ -443,6 +443,7 @@ unsigned long x86_gsbase_read_cpu_inactive(void)
>   
>   	return gsbase;
>   }
> +EXPORT_SYMBOL_GPL(x86_gsbase_read_cpu_inactive);
>   
>   void x86_gsbase_write_cpu_inactive(unsigned long gsbase)
>   {
> @@ -456,6 +457,7 @@ void x86_gsbase_write_cpu_inactive(unsigned long gsbase)
>   		wrmsrl(MSR_KERNEL_GS_BASE, gsbase);
>   	}
>   }
> +EXPORT_SYMBOL_GPL(x86_gsbase_write_cpu_inactive);
>   
>   unsigned long x86_fsbase_read_task(struct task_struct *task)
>   {
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 3127c66a1651..48a34d1a2989 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1156,11 +1156,11 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
>   	} else {
>   		savesegment(fs, fs_sel);
>   		savesegment(gs, gs_sel);
> -		fs_base = read_msr(MSR_FS_BASE);
> -		vmx->msr_host_kernel_gs_base = read_msr(MSR_KERNEL_GS_BASE);
> +		fs_base = x86_fsbase_read_cpu();
> +		vmx->msr_host_kernel_gs_base = x86_gsbase_read_cpu_inactive();
>   	}
>   
> -	wrmsrl(MSR_KERNEL_GS_BASE, vmx->msr_guest_kernel_gs_base);
> +	x86_gsbase_write_cpu_inactive(vmx->msr_guest_kernel_gs_base);
>   #else
>   	savesegment(fs, fs_sel);
>   	savesegment(gs, gs_sel);
> @@ -1184,7 +1184,7 @@ static void vmx_prepare_switch_to_host(struct vcpu_vmx *vmx)
>   	++vmx->vcpu.stat.host_state_reload;
>   
>   #ifdef CONFIG_X86_64
> -	rdmsrl(MSR_KERNEL_GS_BASE, vmx->msr_guest_kernel_gs_base);
> +	vmx->msr_guest_kernel_gs_base = x86_gsbase_read_cpu_inactive();
>   #endif
>   	if (host_state->ldt_sel || (host_state->gs_sel & 7)) {
>   		kvm_load_ldt(host_state->ldt_sel);
> @@ -1204,7 +1204,7 @@ static void vmx_prepare_switch_to_host(struct vcpu_vmx *vmx)
>   #endif
>   	invalidate_tss_limit();
>   #ifdef CONFIG_X86_64
> -	wrmsrl(MSR_KERNEL_GS_BASE, vmx->msr_host_kernel_gs_base);
> +	x86_gsbase_write_cpu_inactive(vmx->msr_host_kernel_gs_base);
>   #endif
>   	load_fixmap_gdt(raw_smp_processor_id());
>   	vmx->guest_state_loaded = false;
> @@ -1216,7 +1216,7 @@ static u64 vmx_read_guest_kernel_gs_base(struct vcpu_vmx *vmx)
>   {
>   	preempt_disable();
>   	if (vmx->guest_state_loaded)
> -		rdmsrl(MSR_KERNEL_GS_BASE, vmx->msr_guest_kernel_gs_base);
> +		vmx->msr_guest_kernel_gs_base = x86_gsbase_read_cpu_inactive();
>   	preempt_enable();
>   	return vmx->msr_guest_kernel_gs_base;
>   }
> @@ -1225,7 +1225,7 @@ static void vmx_write_guest_kernel_gs_base(struct vcpu_vmx *vmx, u64 data)
>   {
>   	preempt_disable();
>   	if (vmx->guest_state_loaded)
> -		wrmsrl(MSR_KERNEL_GS_BASE, data);
> +		x86_gsbase_write_cpu_inactive(data);
>   	preempt_enable();
>   	vmx->msr_guest_kernel_gs_base = data;
>   }
> 

