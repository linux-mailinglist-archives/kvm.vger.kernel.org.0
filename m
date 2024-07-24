Return-Path: <kvm+bounces-22181-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 35D5C93B611
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 19:39:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 95D48B243C8
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 17:39:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFD4C15FD13;
	Wed, 24 Jul 2024 17:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Lfim2WLP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59E1D1BF38
	for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 17:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721842761; cv=none; b=hfcrSW9xl5r6vBGwLBKQMyEN6Sh8xR4qPjxsOClSNMBbQkhflipPWdUR0rek4LV0HROKAdxNFs3pFJHoyKvDS1L58GHfdwYMhB+GeEaJPp6ykC+xSIQqROf13o2wWepZNs7b9/4e3GOWlqEhkQ2KxEVTUMsGpPKi7jLjsDDb62M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721842761; c=relaxed/simple;
	bh=GRdjAc3VsILw9XDHYkEiVLhYXXXCzAg/tHf7whVGWX8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mHJIJK1ezuw8GBW5xTXN5Xp+AcpjsIyd9aYstErhbWtn3LQlvGDjFpm6R6hWWBKexljoq4HZvQKvdB4KBC7Swe/CiVjl0ZQaWj6ZQLkFL1hN2HJOO6s2tAMxWYibw+rJLuaatioMvjNKtwXZMcppXCkPla3HtPHSeLjeVfFHw6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Lfim2WLP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721842758;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+eFTD9RxFljRpcjf1JSYJIwvkQ/3f7UzqFNR7mCwEKo=;
	b=Lfim2WLPl2XwfbtFeoeJxYQnPnQYi04HMMSpbdrDhiDAvRWoca63erd6af6rAf0051kqDr
	BkZSwaPd+QKlDxadRm3EI74RFIeojKlwqFrYy+AFVU41lclZft7she0etLABMxT6EJN6lm
	AhY2CIkyW2Z3CzP7DvwwR/T4D6lEjdk=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-606-evH5DC3xNq--zTYVQIaMJg-1; Wed, 24 Jul 2024 13:39:16 -0400
X-MC-Unique: evH5DC3xNq--zTYVQIaMJg-1
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-650ab31aabdso671047b3.3
        for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 10:39:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721842756; x=1722447556;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+eFTD9RxFljRpcjf1JSYJIwvkQ/3f7UzqFNR7mCwEKo=;
        b=GGX9FBvzltwhPA7l7Id9HXRWuKKkrV4rJfSLU9QhQ3bal5Xrd1TcOYq1gp4XLWWfTk
         ir8DI5rSk54UsJ1sBW9POp/RdM3XDEAjmrM4wLDNaH4gqSL4i9rBJFU8WZbh3gq9LUQi
         Xkxd1FCszLNh3p5DV35YKbHZ808DBfIxrYbDF7Wj+1cA9QTJdT/OGj4mUCqGHrbj+D1m
         9ODsl8j8SDSiu1iOkE6XS71ctBPasNmAnqJniZsN5C4iMfyN1pEfVxyzl8U9djeLWoFM
         AHjrGDCT4HN3vshqBx4IKS3iRrIHrnE4MilnDp6ZeKfg5sn+Glbe5NokgLHjy3te9a/1
         Ff+w==
X-Forwarded-Encrypted: i=1; AJvYcCUvTmYiMozrGf0pQYX2mq9X6e/zjR+cTo9DH1VJjT9MKAsQJkI79CWcvGzr3iwWaLePPILcrNVTNjY+hgWls2z/9Y+W
X-Gm-Message-State: AOJu0YwG6JaQHCVZJOae9Ep8U58WgR6p/gg/3tUYfCoR/3WDnfU8ljZe
	QYsrUe9dC9LSTKUJF0oLRK9FquaPb8pTxMledZDveLvgvXEhI9jFNBGga2fdkxo2Sg9eFiETRaQ
	kmoTMfsdb4fxh886sOgIYll2rB14PhPkF+uHCPUWFrFi+UHKR5A==
X-Received: by 2002:a05:690c:dcb:b0:63b:c16e:a457 with SMTP id 00721157ae682-675113b3311mr1952777b3.13.1721842756220;
        Wed, 24 Jul 2024 10:39:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHf+YzBmxpv4LrWZ1vF+zwvrLn4UI6L34Ko6NUj4uCkLt6ppq1BwXMyVp0k79eiiNx9VZTncw==
X-Received: by 2002:a05:690c:dcb:b0:63b:c16e:a457 with SMTP id 00721157ae682-675113b3311mr1952537b3.13.1721842755873;
        Wed, 24 Jul 2024 10:39:15 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:7b7f:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6b7acb0f114sm58408146d6.146.2024.07.24.10.39.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jul 2024 10:39:15 -0700 (PDT)
Message-ID: <13e19a40bbf0531c92ace210b43e2cbf5056ef16.camel@redhat.com>
Subject: Re: [PATCH v2 19/49] KVM: x86: Add a macro to init CPUID features
 that ignore host kernel support
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov
 <vkuznets@redhat.com>,  kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>,
 Oliver Upton <oliver.upton@linux.dev>, Binbin Wu
 <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>,
 Robert Hoo <robert.hoo.linux@gmail.com>
Date: Wed, 24 Jul 2024 13:39:13 -0400
In-Reply-To: <ZoxRr9P85f03w0vk@google.com>
References: <20240517173926.965351-1-seanjc@google.com>
	 <20240517173926.965351-20-seanjc@google.com>
	 <2a4052ba67970ce41e79deb0a0931bb54e2c2a86.camel@redhat.com>
	 <ZoxRr9P85f03w0vk@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Mon, 2024-07-08 at 13:53 -0700, Sean Christopherson wrote:
> On Thu, Jul 04, 2024, Maxim Levitsky wrote:
> > On Fri, 2024-05-17 at 10:38 -0700, Sean Christopherson wrote:
> > > Add a macro for use in kvm_set_cpu_caps() to automagically initialize
> > > features that KVM wants to support based solely on the CPU's capabilities,
> > > e.g. KVM advertises LA57 support if it's available in hardware, even if
> > > the host kernel isn't utilizing 57-bit virtual addresses.
> > > 
> > > Take advantage of the fact that kvm_cpu_cap_mask() adjusts kvm_cpu_caps
> > > based on raw CPUID, i.e. will clear features bits that aren't supported in
> > > hardware, and simply force-set the capability before applying the mask.
> > > 
> > > Abusing kvm_cpu_cap_set() is a borderline evil shenanigan, but doing so
> > > avoid extra CPUID lookups, and a future commit will harden the entire
> > > family of *F() macros to assert (at compile time) that every feature being
> > > allowed is part of the capability word being processed, i.e. using a macro
> > > will bring more advantages in the future.
> > 
> > Could you explain what do you mean by "extra CPUID lookups"?
> 
> cpuid_ecx(7) incurs a CPUID to read the raw info, on top of the CPUID that is
> executed by kvm_cpu_cap_init() (kvm_cpu_cap_mask() as of this patch).  Obviously
> not a big deal, but it's an extra VM-Exit when running as a VM.
> 
> > > +/*
> > > + * Raw Feature - For features that KVM supports based purely on raw host CPUID,
> > > + * i.e. that KVM virtualizes even if the host kernel doesn't use the feature.
> > > + * Simply force set the feature in KVM's capabilities, raw CPUID support will
> > > + * be factored in by kvm_cpu_cap_mask().
> > > + */
> > > +#define RAW_F(name)						\
> > > +({								\
> > > +	kvm_cpu_cap_set(X86_FEATURE_##name);			\
> > > +	F(name);						\
> > > +})
> > > +
> > >  /*
> > >   * Magic value used by KVM when querying userspace-provided CPUID entries and
> > >   * doesn't care about the CPIUD index because the index of the function in
> > > @@ -682,15 +694,12 @@ void kvm_set_cpu_caps(void)
> > >  		F(AVX512VL));
> > >  
> > >  	kvm_cpu_cap_mask(CPUID_7_ECX,
> > > -		F(AVX512VBMI) | F(LA57) | F(PKU) | 0 /*OSPKE*/ | F(RDPID) |
> > > +		F(AVX512VBMI) | RAW_F(LA57) | F(PKU) | 0 /*OSPKE*/ | F(RDPID) |
> > >  		F(AVX512_VPOPCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
> > >  		F(VAES) | F(VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
> > >  		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/ |
> > >  		F(SGX_LC) | F(BUS_LOCK_DETECT)
> > >  	);
> > > -	/* Set LA57 based on hardware capability. */
> > > -	if (cpuid_ecx(7) & F(LA57))
> > > -		kvm_cpu_cap_set(X86_FEATURE_LA57);
> > >  
> > >  	/*
> > >  	 * PKU not yet implemented for shadow paging and requires OSPKE
> > 
> > Putting a function call into a macro which evaluates into a bitmask is
> > somewhat misleading, but let it be...
> > 
> > IMHO in long term, it might be better to rip the whole huge 'or'ed mess, and replace
> > it with a list of statements, along with comments for all unusual cases.
> 
> As in something like this?
> 
> 	kvm_cpu_cap_init(AVX512VBMI);
> 	kvm_cpu_cap_init_raw(LA57);
> 	kvm_cpu_cap_init(PKU);
> 	...
> 	kvm_cpu_cap_init(BUS_LOCK_DETECT);
> 
> 	kvm_cpu_cap_init_aliased(CPUID_8000_0001_EDX, FPU);
> 
> 	...
> 
> 	kvm_cpu_cap_init_scattered(CPUID_12_EAX, SGX1);
> 	kvm_cpu_cap_init_scattered(CPUID_12_EAX, SGX2);
> 	kvm_cpu_cap_init_scattered(CPUID_12_EAX, SGX_EDECCSSA);
> 
> The tricky parts are incorporating raw CPUID into the masking and handling features
> that KVM _doesn't_ support.  For raw CPUID, we could simply do CPUID every time, or
> pre-fill an array to avoid hundreds of CPUIDs that are largely redudant.

In terms of performance, again this code is run once per kvm module load, so even
if it does something truly gross performance wise, it's not a problem, even if run
nested.

> 
> But I don't see a way to mask off unsupported features without losing the
> compile-time protections that the current code provides.  And even if we took a
> big hammer approach, e.g. finalized masking for all words at the very end, we'd
> still need to carry state across each statement, i.e. we'd still need the bitwise-OR
> and mask  behavior, it would just be buried in helpers/macros.

Can you elaborate on this?

For example let's say this:


	kvm_cpu_cap_init(CPUID_7_0_EBX,
		F(FSGSBASE) | EMUL_F(TSC_ADJUST) | F(SGX) | F(BMI1) | F(HLE) |
		F(AVX2) | F(FDP_EXCPTN_ONLY) | F(SMEP) | F(BMI2) | F(ERMS) |
		F(INVPCID) | F(RTM) | F(ZERO_FCS_FDS) | 0 /*MPX*/ |
		F(AVX512F) | F(AVX512DQ) | F(RDSEED) | F(ADX) | F(SMAP) |
		F(AVX512IFMA) | F(CLFLUSHOPT) | F(CLWB) | 0 /*INTEL_PT*/ |
		F(AVX512PF) | F(AVX512ER) | F(AVX512CD) | F(SHA_NI) |
		F(AVX512BW) | F(AVX512VL));



This will be replaced with:

kvm_cpu_cap_clear_all(CPUID_7_0_EBX);

kvm_cpu_cap_init(FSGSBASE);
kvm_cpu_cap_init(TSC_ADJUST, CAP_EMULATED);
..
kvm_cpu_cap_init(AVX512VL);

Then each 'kvm_cpu_cap_init' will opt-in to set a bit if supported in host cpuid, or
always opt-in for emulated features, etc....

Host CPUID can indeed be cached, if extra host cpuid queries cause too slow (e.g 1 second) delay
when nested.



> 
> I suspect the generated code will be larger, but I doubt that will actually be
> problematic.  

Yes, 100% agree.


> The written code will also be more verbose (roughly 4x since we
> tend to squeeze 4 features per line)

It will be about as long as the list of macros in the cpufeatures.h, where
all features are nicely ordered by cpuid leaves.

In this case I consider verbose long code to be an improvement.

IMHO the OR'ed mask of macros is just too terse, hard to parse.
It was borderline OK, before this patch series because it only
contained features, but now it also contains various modifiers,
IMHO it's just hard to notice that EMUL_F at that corner...


> , and it will be harder to ensure initialization
> of features in a given word are all co-located.

Actually co-location won't be needed.

We can first copy the caps from boot_cpu_data,
then zero all the leaves that we initialize ourselves.

After that we can initialize opt-in features in any order - it will still be sorted
by CPUID leaves but even if the order is broken (e.g due to cherry-pick or something),
it won't cause any issues.


> 
> I definitely don't hate the idea, but I don't think it will be a clear "win" either.
> Unless someone feels strongly about pursuing this approach, I'll add to the "things
> to explore later" list.
> 

Please do consider this, I am almost sure that whoever will need to read this code later (could be you...),
will thank you.


Best regards,
	Maxim Levitsky




