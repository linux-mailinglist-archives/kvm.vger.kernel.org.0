Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 967A1EFAE6
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 11:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388411AbfKEKWu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 05:22:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56702 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388387AbfKEKWt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Nov 2019 05:22:49 -0500
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 59B4481F01
        for <kvm@vger.kernel.org>; Tue,  5 Nov 2019 10:22:48 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id k10so12078714wrl.22
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2019 02:22:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YBVh0Q0FQpGu1wxG4fQf09T3nf67n77DWG5mfPvNWJI=;
        b=QlK7ah8XinfTSqdkPb2i8a9TQwMh0bMxFK9SkvUNACmpWxmUYikKNTRKBerUlVlyln
         Bo86neEdbdbH4rBMLyDChfnWknPAl+Z/dfgQX9Ecbehn3FvP8Ax2GTuGk+q39Q7tHF5Q
         q07oKfNB3kT0E+zsABxV5Sn1TCD7y5V5jEAOlCsO12oYDQz2P+s1NsEQSg4L/iahzfne
         +i2nQ6tx1zmvUMv+Cd9xRtNImoQdwUeQ0+gko4dShvtgG3VYiTBEo8sKqbZ2Y9wyF41J
         jItsjNtUdAiq/RLbNnOLs2AlW8G8SL8XlhG7pVdbpwFLCUV2duNFa0bPAg0q/pzPagrm
         TsCw==
X-Gm-Message-State: APjAAAW9RtoCGBlQ2rfd31ApHi+OCaV0OeHjdyuCDcwZtLjTbb0xQIv4
        3NAcybF8DkYmCjKgWQYfRRHYaJSB8RyUGAnDtpLi8VWOsk7zuWI6SbKtAs3oMoPnaLGLhMSyUe5
        DGRl6763u68K3
X-Received: by 2002:adf:f44e:: with SMTP id f14mr26168414wrp.56.1572949366906;
        Tue, 05 Nov 2019 02:22:46 -0800 (PST)
X-Google-Smtp-Source: APXvYqy9SYxmOaejXMxfGfmZ/5V1utDQAFfW554v2shot8/5xTWsThuesqZvWtP731Z0rsryf0sqmA==
X-Received: by 2002:adf:f44e:: with SMTP id f14mr26168388wrp.56.1572949366567;
        Tue, 05 Nov 2019 02:22:46 -0800 (PST)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id w17sm20505631wra.34.2019.11.05.02.22.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Nov 2019 02:22:46 -0800 (PST)
Subject: Re: [PATCH 10/13] KVM: x86: optimize more exit handlers in vmx.c
To:     Andrea Arcangeli <aarcange@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20191104230001.27774-1-aarcange@redhat.com>
 <20191104230001.27774-11-aarcange@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <5f512823-531b-6c17-f8f4-f11870e2e4a2@redhat.com>
Date:   Tue, 5 Nov 2019 11:20:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191104230001.27774-11-aarcange@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/11/19 23:59, Andrea Arcangeli wrote:
> Eliminate wasteful call/ret non RETPOLINE case and unnecessary fentry
> dynamic tracing hooking points.
> 
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 30 +++++-------------------------
>  1 file changed, 5 insertions(+), 25 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 222467b2040e..a6afa5f4a01c 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4694,7 +4694,7 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
>  	return 0;
>  }
>  
> -static int handle_external_interrupt(struct kvm_vcpu *vcpu)
> +static __always_inline int handle_external_interrupt(struct kvm_vcpu *vcpu)
>  {
>  	++vcpu->stat.irq_exits;
>  	return 1;
> @@ -4965,21 +4965,6 @@ void kvm_x86_set_dr7(struct kvm_vcpu *vcpu, unsigned long val)
>  	vmcs_writel(GUEST_DR7, val);
>  }
>  
> -static int handle_cpuid(struct kvm_vcpu *vcpu)
> -{
> -	return kvm_emulate_cpuid(vcpu);
> -}
> -
> -static int handle_rdmsr(struct kvm_vcpu *vcpu)
> -{
> -	return kvm_emulate_rdmsr(vcpu);
> -}
> -
> -static int handle_wrmsr(struct kvm_vcpu *vcpu)
> -{
> -	return kvm_emulate_wrmsr(vcpu);
> -}
> -
>  static int handle_tpr_below_threshold(struct kvm_vcpu *vcpu)
>  {
>  	kvm_apic_update_ppr(vcpu);
> @@ -4996,11 +4981,6 @@ static int handle_interrupt_window(struct kvm_vcpu *vcpu)
>  	return 1;
>  }
>  
> -static int handle_halt(struct kvm_vcpu *vcpu)
> -{
> -	return kvm_emulate_halt(vcpu);
> -}
> -
>  static int handle_vmcall(struct kvm_vcpu *vcpu)
>  {
>  	return kvm_emulate_hypercall(vcpu);
> @@ -5548,11 +5528,11 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
>  	[EXIT_REASON_IO_INSTRUCTION]          = handle_io,
>  	[EXIT_REASON_CR_ACCESS]               = handle_cr,
>  	[EXIT_REASON_DR_ACCESS]               = handle_dr,
> -	[EXIT_REASON_CPUID]                   = handle_cpuid,
> -	[EXIT_REASON_MSR_READ]                = handle_rdmsr,
> -	[EXIT_REASON_MSR_WRITE]               = handle_wrmsr,
> +	[EXIT_REASON_CPUID]                   = kvm_emulate_cpuid,
> +	[EXIT_REASON_MSR_READ]                = kvm_emulate_rdmsr,
> +	[EXIT_REASON_MSR_WRITE]               = kvm_emulate_wrmsr,
>  	[EXIT_REASON_PENDING_INTERRUPT]       = handle_interrupt_window,
> -	[EXIT_REASON_HLT]                     = handle_halt,
> +	[EXIT_REASON_HLT]                     = kvm_emulate_halt,
>  	[EXIT_REASON_INVD]		      = handle_invd,
>  	[EXIT_REASON_INVLPG]		      = handle_invlpg,
>  	[EXIT_REASON_RDPMC]                   = handle_rdpmc,
> 

Queued, thanks.

Paolo
