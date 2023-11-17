Return-Path: <kvm+bounces-1905-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 14EF77EEAB1
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 02:28:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4564B1C20849
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 01:28:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C5521383;
	Fri, 17 Nov 2023 01:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DSTVcNxC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71928129;
	Thu, 16 Nov 2023 17:28:20 -0800 (PST)
Received: by mail-ot1-x331.google.com with SMTP id 46e09a7af769-6ce532451c7so827998a34.2;
        Thu, 16 Nov 2023 17:28:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700184499; x=1700789299; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lYDCHTeKA1F33R/86cvSFZKdG5hmQV+VfLbjpN+enJ0=;
        b=DSTVcNxC4243zfiSCo9VMtESOWUngsFbQfMyJIgK2MUgDTqxT2mUT0OBtflDVq9oF8
         Jt18vGBGbPio0dHym0yf4b2auqHBoZP4aRtxQAtHPre52MGjOB7KfAFR8DFM6GNPaqri
         hCJRsvc4CkSkOEu2QtA3w2qnZG+d1cS4YHJvTFG+WJ/hUv0shLG4xwAd+gG3fSrCZdvh
         M/0Tw8GtPHZR2v0xan3mYuUDl14kid6UmHozKGRds6o3YeUopye6iOYVXs4jRpW1ej20
         UPKmspRaKHIJVZcTSHK9BcTFKUWFKpPWzemRao0onfZIXv9UNKY0H8aGAAvPJCZRZUHi
         GcYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700184499; x=1700789299;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lYDCHTeKA1F33R/86cvSFZKdG5hmQV+VfLbjpN+enJ0=;
        b=hqVJMZmrP21vv3LIPR3ZHzBpSHYDxfnbfHDPJqpfyrcgpOupA7aPSXWiUx0fOb+7wH
         NZdkZmezpgwJgow+YMUXk4FSK9ttohb7P7NrJJJ0NKDbNOep6TwuF34I+atiJntoGCTv
         5mf9sUt7lwRWsqpo02q9h8FosIftjFjXpvdm6tLlQF4BYdWhRsORLTPueTqOrZYWZg91
         hQrKn630x3cwR4KVEfO+hNBmGKeFvlw9xtLC0ZTModRJQePnWUD6GovIS5PY/z6Tpnep
         EoFpwTq3rUwh8rQ5Bth35MBkcEYRMwv5qQ73pZFWbU1Z2fiP2128fpSHof8jfm3q3QTR
         8jKA==
X-Gm-Message-State: AOJu0YzQf3mm7WqVJDFHYnJjzijyEGG+dl5Dj0kMb4zoxgwEk4Cs8XUy
	/20RJ0uyOIh3i414FiKaADo=
X-Google-Smtp-Source: AGHT+IEsgixXfLg6kIFkjRgBidHel0mzOuGYjARnZw3eDm7uZ/q6eqjl74h+UiOeVAcH2M8w9R8LtQ==
X-Received: by 2002:a05:6830:13cb:b0:6c6:4843:2abb with SMTP id e11-20020a05683013cb00b006c648432abbmr10553632otq.12.1700184499688;
        Thu, 16 Nov 2023 17:28:19 -0800 (PST)
Received: from [172.27.233.123] (ec2-16-163-40-128.ap-east-1.compute.amazonaws.com. [16.163.40.128])
        by smtp.gmail.com with ESMTPSA id 204-20020a6301d5000000b005897bfc2ed3sm332193pgb.93.2023.11.16.17.28.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Nov 2023 17:28:19 -0800 (PST)
Message-ID: <965bf6a9-97f7-4e20-bcb8-658e5cf459e5@gmail.com>
Date: Fri, 17 Nov 2023 09:28:14 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/9] KVM: x86: Update guest cpu_caps at runtime for
 dynamic CPUID-based features
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
References: <20231110235528.1561679-1-seanjc@google.com>
 <20231110235528.1561679-7-seanjc@google.com>
 <ffec2e93-cdb1-25e2-06ec-deccf8727ce4@gmail.com>
 <ZVN6w2Kc2AUmIiJO@google.com>
 <9395d416-cc5c-536d-641e-ffd971b682d1@gmail.com>
 <ZVTfG6mARiyttuKj@google.com>
Content-Language: en-US
From: Robert Hoo <robert.hoo.linux@gmail.com>
In-Reply-To: <ZVTfG6mARiyttuKj@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/15/2023 11:09 PM, Sean Christopherson wrote:
...
>>> No, because then every caller would need extra code to pass
>>> vcpu->cpu_caps,
>>
>> Emm, I don't understand this. I tried to modified and compiled, all need to
>> do is simply substitute "vcpu" with "vcpu->arch.cpu_caps" in calling. (at
>> the end is my diff based on this patch set)
> 
> Yes, and I'm saying that
> 
> 	guest_cpu_cap_restrict(vcpu, X86_FEATURE_PAUSEFILTER);
> 	guest_cpu_cap_restrict(vcpu, X86_FEATURE_PFTHRESHOLD);
> 	guest_cpu_cap_restrict(vcpu, X86_FEATURE_VGIF);
> 	guest_cpu_cap_restrict(vcpu, X86_FEATURE_VNMI);
> 
> is harder to read and write than this
> 
> 	guest_cpu_cap_restrict(vcpu->arch.cpu_caps, X86_FEATURE_PAUSEFILTER);
> 	guest_cpu_cap_restrict(vcpu->arch.cpu_caps, X86_FEATURE_PFTHRESHOLD);
> 	guest_cpu_cap_restrict(vcpu->arch.cpu_caps, X86_FEATURE_VGIF);
> 	guest_cpu_cap_restrict(vcpu->arch.cpu_caps, X86_FEATURE_VNMI);
> 
> a one-time search-replace is easy, but the extra boilerplate has a non-zero cost
> for every future developer/reader.

Hmm, I think this is trivial. And can be solved/eased by other means, e.g. 
Macro?. Rather than in the sacrifice of letting function's inside (easily) 
access those info it shouldn't.
> 
>>> and passing 'u32 *' provides less type safety than 'struct kvm_vcpu *'.
>>> That tradeoff isn't worth making this one path slightly easier to read.
>>
>> My point is also from vulnerability, long term, since as a principle, we'd
>> better pass in param/info to a function of its necessity.
> 
> Attempting to apply the principle of least privilege to low level C helpers is
> nonsensical.  E.g. the helper can trivially get at the owning vcpu via container_of()
> (well, if not for typeof assertions not playing nice with arrays, but open coding
> container_of() is also trivial and illustrates the point).
> 
> 	struct kvm_vcpu_arch *arch = (void *)caps -  offsetof(struct kvm_vcpu_arch, cpu_caps);
> 	struct kvm_vcpu *vcpu = container_of(arch, struct kvm_vcpu, arch);
> 
> 	if (!kvm_cpu_cap_has(x86_feature))
> 		guest_cpu_cap_clear(vcpu, x86_feature);
> 
> And the intent behind that principle is to improve security/robustness; what I'm
> saying is that passing in a 'u32 *" makes the overall implementation _less_ robust,
> as it opens up the possibilities of passing in an unsafe/incorrect pointer.  E.g.
> a well-intentioned, not _that_ obviously broken example is:
> 
> 	guest_cpu_cap_restrict(&vcpu->arch.cpu_caps[CPUID_1_ECX], X86_FEATURE_XSAVE);
> 
>> e.g. cpuid_entry2_find().
> 
> The main reason cpuid_entry2_find() exists is because KVM checks the incoming
> array provided by KVM_SET_CPUID2, which is also the reason why
> __kvm_update_cpuid_runtime() takes an @entries array instead of just @vcpu.

Thanks for detailed explanation, I understand your points deeper, though I would 
still prefer to honoring the principle if it was me to write the function. The 
concerns above can/should be addressed by other means. (If some really cannot be 
solved in C, i.e. more stringent type check, it's C to blame ;) but it on the 
other side offers those flexibility that other languages cannot, doesn't it?)
Another pros of the principle is that, it's also a fence, prevent (at least 
raise the bar) people in the future from doing something that shouldn't be in 
the function, e.g.  for his convenience to quickly fix a bug etc.

Anyway, it's a dilemma, and I said it's a less important point for this great 
progress of vCPUID's implementation, thanks.

Reviewed-by: Robert Hoo <robert.hoo.linux@gmail.com>


