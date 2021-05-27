Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99298392F25
	for <lists+kvm@lfdr.de>; Thu, 27 May 2021 15:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236379AbhE0NKG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 09:10:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52006 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236388AbhE0NKA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 May 2021 09:10:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622120906;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vni5r2RGrY6+247rlHUMyvtn3Oe0hxaKsSPvURPHeLc=;
        b=GcTc7yR0z0WwIO4Ly1SsImNoNBNz7CphYM+nruizcISExNFJjeIluQaifPkuPmjOF4OC3A
        i168FBIKC1Cjz/puXzsLs4+W/X2/R/MjGUs+bbNixRx0iLrFHwPD3E0cORj/LPhxmfIgp+
        W/a5eMYOMMzOOkPIivOK+4UZx9nnPXU=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-562-tU-n5_dWOSGOoWBnhFf6fA-1; Thu, 27 May 2021 09:08:25 -0400
X-MC-Unique: tU-n5_dWOSGOoWBnhFf6fA-1
Received: by mail-ej1-f71.google.com with SMTP id eb10-20020a170907280ab02903d65bd14481so1640763ejc.21
        for <kvm@vger.kernel.org>; Thu, 27 May 2021 06:08:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vni5r2RGrY6+247rlHUMyvtn3Oe0hxaKsSPvURPHeLc=;
        b=djk5z+zp5fmPI4qlVN5MRiZdMlRnv7yolqV9WbwKi9wlVH++iPKh7WexKRJQNjgySt
         JhwiJBwrALLQ/cc6qrNWxdDoRxfMEbePUj6In+jp7X37nZ+VUmfC1/jWpKIU/v3tZOZM
         y5uI8CWKl6heFZHjtPsS3ByQS9SO+y58fnH/6vegyDW8PI9gGcGGRh4ddR1ctbCjmHW7
         KttMkTI78ONtuxiPrEg3/KgTEfZbWrg7YjnfjQZetJOVBVXnTJg9Yk4dLKvuY81Zi4Cd
         wX2mFtXqqnZOW7wwSwiKqswJFATxx6616na+9SAD9xCGactXZpPn6hU/nGAqdcqoF2Q7
         6gzg==
X-Gm-Message-State: AOAM5338m9iPuZ0zk7eQTfy6Hzb4uRNfcxiwoyCuJf8YcEk09phfC/8Y
        8YHnh8d7+0U1sJbd8ncU6jCNfMS6xxQIzConKFOEDWrqbRGlTLJrUxIItp6g58YeZ37wCeFjxCS
        vo7agrvpcsuUz
X-Received: by 2002:a17:906:5fd1:: with SMTP id k17mr3632354ejv.78.1622120903887;
        Thu, 27 May 2021 06:08:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzNOGqQXPQP9WHdqlowsy6B9C/h7LOb8yyMFanNqozysCvXHFri3MHKMuL9VRZZYdCa2YmY9g==
X-Received: by 2002:a17:906:5fd1:: with SMTP id k17mr3632338ejv.78.1622120903721;
        Thu, 27 May 2021 06:08:23 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id r17sm1074698edt.33.2021.05.27.06.08.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 May 2021 06:08:22 -0700 (PDT)
Subject: Re: [PATCH] KVM: X86: Use kvm_get_linear_rip() in single-step and
 #DB/#BP interception
To:     Yuan Yao <yuan.yao@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org
Cc:     Yuan Yao <yuan.yao@intel.com>
References: <20210526063828.1173-1-yuan.yao@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <faadf727-dd9a-5d4f-2e6b-8e75f2dad28a@redhat.com>
Date:   Thu, 27 May 2021 15:08:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210526063828.1173-1-yuan.yao@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/05/21 08:38, Yuan Yao wrote:
> From: Yuan Yao <yuan.yao@intel.com>
> 
> The kvm_get_linear_rip() handles x86/long mode cases well and has
> better readability, __kvm_set_rflags() also use the paired
> fucntion kvm_is_linear_rip() to check the vcpu->arch.singlestep_rip
> set in kvm_arch_vcpu_ioctl_set_guest_debug(), so change the
> "CS.BASE + RIP" code in kvm_arch_vcpu_ioctl_set_guest_debug() and
> handle_exception_nmi() to this one.
> 
> Signed-off-by: Yuan Yao <yuan.yao@intel.com>
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 4bceb5ca3a89..0db05cfbe434 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4843,7 +4843,7 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
>   	struct vcpu_vmx *vmx = to_vmx(vcpu);
>   	struct kvm_run *kvm_run = vcpu->run;
>   	u32 intr_info, ex_no, error_code;
> -	unsigned long cr2, rip, dr6;
> +	unsigned long cr2, dr6;
>   	u32 vect_info;
>   
>   	vect_info = vmx->idt_vectoring_info;
> @@ -4933,8 +4933,7 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
>   		vmx->vcpu.arch.event_exit_inst_len =
>   			vmcs_read32(VM_EXIT_INSTRUCTION_LEN);
>   		kvm_run->exit_reason = KVM_EXIT_DEBUG;
> -		rip = kvm_rip_read(vcpu);
> -		kvm_run->debug.arch.pc = vmcs_readl(GUEST_CS_BASE) + rip;
> +		kvm_run->debug.arch.pc = kvm_get_linear_rip(vcpu);
>   		kvm_run->debug.arch.exception = ex_no;
>   		break;
>   	case AC_VECTOR:
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 9b6bca616929..5cac5d883710 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10115,8 +10115,7 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
>   	kvm_update_dr7(vcpu);
>   
>   	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)
> -		vcpu->arch.singlestep_rip = kvm_rip_read(vcpu) +
> -			get_segment_base(vcpu, VCPU_SREG_CS);
> +		vcpu->arch.singlestep_rip = kvm_get_linear_rip(vcpu);
>   
>   	/*
>   	 * Trigger an rflags update that will inject or remove the trace
> 

Queued, thanks.

Paolo

