Return-Path: <kvm+bounces-2445-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D67EE7F78AE
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 17:11:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 14C691C20BED
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 16:11:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85D6E33CD9;
	Fri, 24 Nov 2023 16:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZI+Umvxd"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBBB21998
	for <kvm@vger.kernel.org>; Fri, 24 Nov 2023 08:11:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700842303;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=gVnyc+iJ+KiZKpFBiD0j4BpZFWXYn4m5bglNqialQuQ=;
	b=ZI+UmvxdNYSVt40L6awqf4XbVCwTR/ILyIqxES7h//XadsNlU78DYvf+klBeoqXw7dwHZB
	w06+XYH2Ab5zL6JAT6RWVSzcDdx/VoQDeLshXG2ejGmEjDuggSbyiuZ7MCIhHAVA3eGxa5
	a5Rfaj+XKF59xf93+QtYfDReyeZeFX0=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-172-BeBNjs7qOmmXx0ObdPi6SQ-1; Fri, 24 Nov 2023 11:11:40 -0500
X-MC-Unique: BeBNjs7qOmmXx0ObdPi6SQ-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-77d7a92f883so109820085a.0
        for <kvm@vger.kernel.org>; Fri, 24 Nov 2023 08:11:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700842300; x=1701447100;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gVnyc+iJ+KiZKpFBiD0j4BpZFWXYn4m5bglNqialQuQ=;
        b=pE3Woc5B/vC5lKQ+54B3HfOim2640isTTbrO2g6BMhLXOjSl2IQNxoRRtE/t1W3um8
         +V/kv3A2j8oo6CpkGH58iv7UMGyccEKev0eeadMttxHBgEaADc5DA9DtwzLMFwScWfQU
         9zgeaSLjSoaaxbREGBQUEHTJ36pRWkIxbSXnd1saflpReXzz+Ughq70nqT+ACc4HvqWS
         zLHD1PXBiA0V2mX1DTRe2IaErz7Mxu+SLGUp3LR28HI8KsnYIng5ghQwMW0zpIlLhoG7
         ap9La8icgyIwpjKKJQtHW8ZMFjE2w3lu6N1mrhwwvFaAroZSdQj/SiCIgKi7G49e/0a9
         FEQQ==
X-Gm-Message-State: AOJu0YzMuzS/Fbxt4IFY9pxAwc2MyE3PUIZX7qslBekJLNdXYZDehvHq
	r6OSYodxH83vn8TisN6yYk/nL2ZN7kqA6MgkQykKAotRlZkPiUSlrcIUIRGYxW8Q6ICYiL/VBX3
	LYjzFxmuUV+HE8Jx6RLYB
X-Received: by 2002:a05:620a:3792:b0:778:af06:640e with SMTP id pi18-20020a05620a379200b00778af06640emr3428402qkn.16.1700842300041;
        Fri, 24 Nov 2023 08:11:40 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE4C0MFSdgRbt6SFbCLc2O4yqi2ZPuleRbYexSgR4VNJn+tjFGhceDh116YyF+ElQAT7ogDUg==
X-Received: by 2002:a05:620a:3792:b0:778:af06:640e with SMTP id pi18-20020a05620a379200b00778af06640emr3428379qkn.16.1700842299748;
        Fri, 24 Nov 2023 08:11:39 -0800 (PST)
Received: from [10.32.181.74] (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.googlemail.com with ESMTPSA id u21-20020ae9c015000000b0076efaec147csm1318135qkk.45.2023.11.24.08.11.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Nov 2023 08:11:39 -0800 (PST)
Message-ID: <a10d3a01-939c-493c-b93c-b3821735e062@redhat.com>
Date: Fri, 24 Nov 2023 17:11:36 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/4] KVM: x86: add new nested vmexit tracepoints
Content-Language: en-US
To: Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
 Sean Christopherson <seanjc@google.com>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
 x86@kernel.org, Dave Hansen <dave.hansen@linux.intel.com>
References: <20230928103640.78453-1-mlevitsk@redhat.com>
 <20230928103640.78453-5-mlevitsk@redhat.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20230928103640.78453-5-mlevitsk@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/28/23 12:36, Maxim Levitsky wrote:
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

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

with just one question below that can be fixed when applying:

> @@ -1139,6 +1145,22 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
>   				       vmcb12->control.exit_int_info_err,
>   				       KVM_ISA_SVM);
>   
> +	/* Collect some info about nested VM exits */
> +	switch (vmcb12->control.exit_code) {
> +	case SVM_EXIT_MSR:
> +		trace_kvm_nested_msr(vmcb12->control.exit_info_1 == 1,
> +				     kvm_rcx_read(vcpu),
> +				     (vmcb12->save.rax & -1u) |
> +				     (((u64)(kvm_rdx_read(vcpu) & -1u) << 32)));

Why the second "& -1u"?  (And I also prefer 0xFFFFFFFFull

Paolo


