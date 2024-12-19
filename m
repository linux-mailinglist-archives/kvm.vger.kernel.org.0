Return-Path: <kvm+bounces-34171-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C7CED9F8212
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 18:39:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0AE2A189520E
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 17:35:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30A081A08D1;
	Thu, 19 Dec 2024 17:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JNFlvWO6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9E31AAA13
	for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 17:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734629587; cv=none; b=OnvbPC1Wk8p0szWpefAPXXeotyePWDOtSQdEtM8xtXAZUAB7hGp3NCxrd4G1MTnRgrgtnMqj0l5mMdtsukiGkW830QQkL2btg7aMWikHBnHMSxvzlQlYACH/FuedxSYNt5NNSAfeFHibpBdvoVFagTT/g+h5QVQv8qexUB04yDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734629587; c=relaxed/simple;
	bh=xshHVC4s/TNmKqJUqxrmFSpX+XumEE2PkS/dmMcxrGU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pBqg0PevCzLfdrkyMngqQ/yDK/Of+R9jHBBf2/Afas69ZzY09L1fMWIwZOVOaYxnsDzzOrXlHsWyAsimDYwcpr/fhUEXifTHxnhEBpJB3T1fW/hHl7QkP9Z4OsSRhkECGPHHj8h6Ip9XE9O9HJi2LHuhwcwi6/QS3wwR/Io8p3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JNFlvWO6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734629584;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=FAZ5xHWGimMYl7KE3kF/TKKw1OUqG9wY4EtwRJWNGR8=;
	b=JNFlvWO6X7u0phKqTNGKSozIiw8ka+NELThZgJ6JVYIeWpw0niXJogN1D/TeVcK5/aVAK3
	N9ie9Yq0sL43C0NA0tOBB7gJELZz7qd5QRxMvCs87vtxFQZFJVInZT3U3QT5Q/r/uVAOH7
	v71oPV5frQucSEPyaQoRbyFh+j/hx3M=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-634-7taccfYHMe-QEbWd8VFc3w-1; Thu, 19 Dec 2024 12:33:03 -0500
X-MC-Unique: 7taccfYHMe-QEbWd8VFc3w-1
X-Mimecast-MFC-AGG-ID: 7taccfYHMe-QEbWd8VFc3w
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43624b08181so6334455e9.0
        for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 09:33:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734629582; x=1735234382;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FAZ5xHWGimMYl7KE3kF/TKKw1OUqG9wY4EtwRJWNGR8=;
        b=p9HB4FxqHR+GTTdG+Xak6iPYQq4CDGx73Q3dDqk32Q1pX/vAql+YI9sHGZKZgKivRH
         jGeGnfdcpT6IDTkweN1Bi5FdbvIjYg++4czQwoGV/ZlNBV5uUxqYsJe8P67G3HxlGuaS
         zyLi0McUL9GMgJAk3TuUDHEGqr+bB2FokJcZeIOZDbksaXZ9+DArJKKT87iYmSHJqsiQ
         PMjdIWShO+pLOs+lzIP4gGDbxTaSf9WQSNrqGxMthO7Dra8lf03ivzSCfXXn58shFgOq
         xd5IXwuM8loKSX4TNE58i/QzBoeV3AzVY4MR8QMPEB7IIA22J+fwZSBT2czCJcCrk3kz
         QG6g==
X-Forwarded-Encrypted: i=1; AJvYcCXlCSqo8PzhrweHQAPAI7SVQ0BEwowxtzmpoRCw5/Wo15J1MW3d+pDEJu3iedSmsqtI6lA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2/NVnOESMF/zNQ4qkBNm72Nf40VZFNibuBDstsCew1Ie0tsgx
	4r0aCOIl92FDOVXj579Vbw1wyTe+DaHjoW0KaxAE66En16JFrA06MXS+0lYqJUjXpEr3kzFTCHk
	kdFg7YNDzj1zt/obdabBAi7AhMy/JWiulaazXOroSp4X38C+pvQ==
X-Gm-Gg: ASbGncse2/XfcltOH38P2rMiOCRdNBn4Slq2MKWhqqnIyByUPofxLu0zoBT9ieVcBvf
	OzAJU8Wo5Xzd409px//ZmQbXA1RqGFFeCprdXqTp35mImNL2XvsIhC2XcU/+tKoYSAVaWC6T8lQ
	TLlboEYbbWsRcUqMH31OagLSvo8M+42fUPfvW5WgxIzhPsWeVmKZQ5j3MX+REe8uIcAQNGy2pR8
	2Onv0JYKqut5k3FSBYvNnpVSXs6Uurc1cPUOBm41DPwC05vwAx27kJ935s=
X-Received: by 2002:a05:600c:4302:b0:435:edb0:5d27 with SMTP id 5b1f17b1804b1-4365c775131mr36784355e9.9.1734629582142;
        Thu, 19 Dec 2024 09:33:02 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHDhWPk5NquZCFc8ici3TtWRL10EJUEBD7cwlMDdiHiO+vTqp4HxfbdaH2FEJ4LeEcClsDMmA==
X-Received: by 2002:a05:600c:4302:b0:435:edb0:5d27 with SMTP id 5b1f17b1804b1-4365c775131mr36784025e9.9.1734629581747;
        Thu, 19 Dec 2024 09:33:01 -0800 (PST)
Received: from [192.168.1.84] ([93.56.163.127])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-43656b11d1dsm57919885e9.25.2024.12.19.09.33.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Dec 2024 09:33:01 -0800 (PST)
Message-ID: <9ff2be87-117a-4f96-af3b-dacb55467449@redhat.com>
Date: Thu, 19 Dec 2024 18:33:00 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/3] KVM: x86: add new nested vmexit tracepoints
To: Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc: x86@kernel.org, Dave Hansen <dave.hansen@linux.intel.com>,
 Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
 Ingo Molnar <mingo@redhat.com>, Sean Christopherson <seanjc@google.com>,
 "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
References: <20240910200350.264245-1-mlevitsk@redhat.com>
 <20240910200350.264245-4-mlevitsk@redhat.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240910200350.264245-4-mlevitsk@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/10/24 22:03, Maxim Levitsky wrote:
> Add 3 new tracepoints for nested VM exits which are intended
> to capture extra information to gain insights about the nested guest
> behavior.
> 
> The new tracepoints are:
> 
> - kvm_nested_msr
> - kvm_nested_hypercall
> 
> These tracepoints capture extra register state to be able to know
> which MSR or which hypercall was done.
> 
> - kvm_nested_page_fault
> 
> This tracepoint allows to capture extra info about which host pagefault
> error code caused the nested page fault.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>   arch/x86/kvm/svm/nested.c | 22 +++++++++++
>   arch/x86/kvm/trace.h      | 82 +++++++++++++++++++++++++++++++++++++--
>   arch/x86/kvm/vmx/nested.c | 27 +++++++++++++
>   arch/x86/kvm/x86.c        |  3 ++
>   4 files changed, 131 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 6f704c1037e51..2020307481553 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -38,6 +38,8 @@ static void nested_svm_inject_npf_exit(struct kvm_vcpu *vcpu,
>   {
>   	struct vcpu_svm *svm = to_svm(vcpu);
>   	struct vmcb *vmcb = svm->vmcb;
> +	u64 host_error_code = vmcb->control.exit_info_1;
> +
>   
>   	if (vmcb->control.exit_code != SVM_EXIT_NPF) {
>   		/*
> @@ -48,11 +50,15 @@ static void nested_svm_inject_npf_exit(struct kvm_vcpu *vcpu,
>   		vmcb->control.exit_code_hi = 0;
>   		vmcb->control.exit_info_1 = (1ULL << 32);
>   		vmcb->control.exit_info_2 = fault->address;
> +		host_error_code = 0;
>   	}
>   
>   	vmcb->control.exit_info_1 &= ~0xffffffffULL;
>   	vmcb->control.exit_info_1 |= fault->error_code;
>   
> +	trace_kvm_nested_page_fault(fault->address, host_error_code,
> +				    fault->error_code);
> +

I disagree with Sean about trace_kvm_nested_page_fault.  It's a useful 
addition and it is easier to understand what's happening with a 
dedicated tracepoint (especially on VMX).

Tracepoint are not an exact science and they aren't entirely kernel API. 
  At least they can just go away at any time (changing them is a lot 
more tricky, but their presence is not guaranteed).  The one below has 
the slight ugliness of having to do some computation in 
nested_svm_vmexit(), this one should go in.

>   	nested_svm_vmexit(svm);
>   }
>   
> @@ -1126,6 +1132,22 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
>   				       vmcb12->control.exit_int_info_err,
>   				       KVM_ISA_SVM);
>   
> +	/* Collect some info about nested VM exits */
> +	switch (vmcb12->control.exit_code) {
> +	case SVM_EXIT_MSR:
> +		trace_kvm_nested_msr(vmcb12->control.exit_info_1 == 1,
> +				     kvm_rcx_read(vcpu),
> +				     (vmcb12->save.rax & 0xFFFFFFFFull) |
> +				     (((u64)kvm_rdx_read(vcpu) << 32)));
> +		break;
> +	case SVM_EXIT_VMMCALL:
> +		trace_kvm_nested_hypercall(vmcb12->save.rax,
> +					   kvm_rbx_read(vcpu),
> +					   kvm_rcx_read(vcpu),
> +					   kvm_rdx_read(vcpu));
> +		break;

Here I probably would have preferred an unconditional tracepoint giving 
RAX/RBX/RCX/RDX after a nested vmexit.  This is not exactly what Sean 
wanted but perhaps it strikes a middle ground?  I know you wrote this 
for a debugging tool, do you really need to have everything in a single 
tracepoint, or can you correlate the existing exit tracepoint with this 
hypothetical trace_kvm_nested_exit_regs, to pick RDMSR vs. WRMSR?

Paolo


