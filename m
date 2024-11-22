Return-Path: <kvm+bounces-32336-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9599E9D588F
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 04:28:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1E4851F23679
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 03:28:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA7AD1509B6;
	Fri, 22 Nov 2024 03:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VxzrlFXJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4905F70838
	for <kvm@vger.kernel.org>; Fri, 22 Nov 2024 03:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732246113; cv=none; b=VE5OhYzmnMj7dN+wugsLZtSGfm3sCCcP9opHH3HCOKz9T9QgEbIROOwmSe6McxQg+sJgnh7RRYo4Mc8uMTcm5FKr4TKuZ09tOiJoo5iCnMBGQjlTIe4tmm7yVxHQvX62X+4k5rTSR5Vx6Mk+BlELKpBRVqCKLVYL34ccMNHQ9UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732246113; c=relaxed/simple;
	bh=VoZ3XbDcUjiDA6+KfP8pTMVWN0li18P2qwtVRE6AK5A=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=B05TKYzIjZ5Jh2FIjgePBuvXBnGA0LNDcBR44mDtdtnlE1cmgbTzY0K1s/+/q+axYAOJOu/kVBP/ivQSuWrmNVBEhTLAzO8dSY9FuRsNsbgRdBJyLBTYVYzfCAJzHJVzdNBh+bCKInIBDhDeCYjpaiivMC1WXoZcJpBGP7m1WKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VxzrlFXJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732246110;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9NDRt3UW8rxHwZI0hypnIESBBnJNuw4yVb/N9fJds3E=;
	b=VxzrlFXJASlMsfPZRSqDnBWVZI5mssttCRZn46NBy9UWJRqhYJO18OBSufDrlBfaPStgR5
	kn5B8Q8z8P6PWRFFnrsTNSNviQ6rRjry++EHDWJ7rln64od19yRMBMtuaxaFE/y0fgfRyH
	saNvDQdbILIQnhX6lhxNbNOaUfsnKtY=
Received: from mail-ua1-f72.google.com (mail-ua1-f72.google.com
 [209.85.222.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-594-gxpwVHdsMtmHq_YwjJ2eZw-1; Thu, 21 Nov 2024 22:28:28 -0500
X-MC-Unique: gxpwVHdsMtmHq_YwjJ2eZw-1
X-Mimecast-MFC-AGG-ID: gxpwVHdsMtmHq_YwjJ2eZw
Received: by mail-ua1-f72.google.com with SMTP id a1e0cc1a2514c-856e9e7e2b4so779626241.1
        for <kvm@vger.kernel.org>; Thu, 21 Nov 2024 19:28:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732246108; x=1732850908;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9NDRt3UW8rxHwZI0hypnIESBBnJNuw4yVb/N9fJds3E=;
        b=OBG6/an3V32i8F89UAfGi9PH4XVHQkI/T8qTGfrgSL/ZlCwuDZsFflAJ6cl6bLpEzK
         Bbxqd+EGenWQXRLRBOc6JZOhuLqLwzOwloruj2H3Mip7FdajvGiwAfrNFRSxWt067Ran
         5XiP6YfQbzuGCicU6XRsS0vzf9hWyOo2sQbsZsvkeLrhVU3xOBCwqmUzVNTIxD1UZ49R
         IJwgB/DcFAAFC7B4T/MXUcP1A0FgaoukXEyzXO/bZNVMjR6bwmMx79jsFCwLSBTAysC9
         4n/j4/oXHxuQcaWftwwHLqNE+9L8ofxsMwAboERt2x76VTcVFYgONKHznYAyWNtEj1xy
         jlag==
X-Forwarded-Encrypted: i=1; AJvYcCWajAtt+s8hf4VVRgoFdv+lFdLhNpfJsypvz16gQtfP681wx9WyAIJH6dW/Nk5PW/qtLGM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2E7eV39YRaVNE0dczFTdzdxl4K2967e1Ak2ejtJIHdtxUq9X2
	2bFJINePk/BuhxRQLJUmvcxtYz3yP2683ds140+zaae1hmCgTINcYxyZGyUntwre3dUrxgXAda6
	YAXUrE5vXJXiNpDnqs5LBKGD9Ibl/14dl18GVAERY5CSEzJonxA==
X-Gm-Gg: ASbGnctN/f0+vGSQFn7dVWaw2XhHOWTPBmF6N/XdnyEXlpnZC3GOb7JrMKn6ObRKsTm
	JEc1mm6VQhKXblPm+cvOuuJKbR7PIQS79enH/oBS3unQuDINlyfHh6ImKM1ku07NErAmQAaO1gS
	9//9fKRDiiUZc+q0I4KuICI59J5WtPANzGTVL2mDqqOu4ijKBNL7AZ57F4JXJFXnIcAaZVNXBlH
	mLlwTc3/EL/zN7Yx+LNeaiAEJR87lhUl8/O3ot/qXFTYsbCow==
X-Received: by 2002:a05:6102:f13:b0:4a9:15c:ef8 with SMTP id ada2fe7eead31-4addceb83fdmr1823905137.24.1732246108230;
        Thu, 21 Nov 2024 19:28:28 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFPFL3IRj+5/xjls62/Fb+f+DaU2BI42u0JjGGMC6cm0o5iDXF3giEmCmA9QGQAGJdwBkVjlw==
X-Received: by 2002:a05:6102:f13:b0:4a9:15c:ef8 with SMTP id ada2fe7eead31-4addceb83fdmr1823894137.24.1732246107902;
        Thu, 21 Nov 2024 19:28:27 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6d451b4a59esm4727586d6.105.2024.11.21.19.28.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2024 19:28:27 -0800 (PST)
Message-ID: <0e41ed2117c5cf5c97e2052aab65e39a5fef06f7.camel@redhat.com>
Subject: Re: [PATCH v2 26/49] KVM: x86: Add a macro to init CPUID features
 that KVM emulates in software
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov
 <vkuznets@redhat.com>,  kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>,
 Oliver Upton <oliver.upton@linux.dev>, Binbin Wu
 <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>,
 Robert Hoo <robert.hoo.linux@gmail.com>
Date: Thu, 21 Nov 2024 22:28:26 -0500
In-Reply-To: <ZuG_V9k8fbh8bKc5@google.com>
References: <20240517173926.965351-1-seanjc@google.com>
	 <20240517173926.965351-27-seanjc@google.com>
	 <2e0f3fb63c810dd924907bccf9256f6f193b02ec.camel@redhat.com>
	 <ZoxooTvO5vIEnS5V@google.com>
	 <2e531204c32c05c96e852748d490424a6f69a018.camel@redhat.com>
	 <ZqQ6DWUou8hvu0qE@google.com>
	 <2d77b69729354b016eb76537523c9e32e7c011c5.camel@redhat.com>
	 <ZrEvCc6yYdT-cHxD@google.com>
	 <96b32724ad1ce9ac88abb209d196b01116536a61.camel@redhat.com>
	 <ZuG_V9k8fbh8bKc5@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2024-09-11 at 09:03 -0700, Sean Christopherson wrote:
> On Tue, Sep 10, 2024, Maxim Levitsky wrote:
> > On Mon, 2024-08-05 at 12:59 -0700, Sean Christopherson wrote:
> > > > And now we have:
> > > > 
> > > > kvm_cpu_cap_init_begin(CPUID_12_EAX);
> > > >  feature_scattered(SGX1);
> > > >  feature_scattered(SGX2);
> > > >  feature_scattered(SGX_EDECCSSA);
> > > > kvm_cpu_cap_init_end();
> > > 
> > > I don't love the syntax (mainly the need for a begin()+end()), but I'm a-ok
> > > getting rid of the @mask param/input.
> > > 
> > > What about making kvm_cpu_cap_init() a variadic macro, with the relevant features
> > > "unpacked" in the context of the macro?  That would avoid the need for a trailing
> > > macro, and would provide a clear indication of when/where the set of features is
> > > "initialized".
> > > 
> > > The biggest downside I see is that the last entry can't have a trailing comma,
> > > i.e. adding a new feature would require updating the previous feature too.
> > > 
> > > #define kvm_cpu_cap_init(leaf, init_features...)			\
> > > do {									\
> > > 	const struct cpuid_reg cpuid = x86_feature_cpuid(leaf * 32);	\
> > > 	const u32 __maybe_unused kvm_cpu_cap_init_in_progress = leaf;	\
> > > 	u32 kvm_cpu_cap_virtualized= 0;					\
> > > 	u32 kvm_cpu_cap_emulated = 0;					\
> > > 	u32 kvm_cpu_cap_synthesized = 0;				\
> > > 									\
> > > 	init_features;							\
> > > 									\
> > > 	kvm_cpu_caps[leaf] = kvm_cpu_cap_virtualized;			\
> > > 	kvm_cpu_caps[leaf] &= (raw_cpuid_get(cpuid) |			\
> > > 			       kvm_cpu_cap_synthesized);		\
> > > 	kvm_cpu_caps[leaf] |= kvm_cpu_cap_emulated;			\
> > > } while (0)
> > > 
> > > 	kvm_cpu_cap_init(CPUID_1_ECX,
> > > 		VIRTUALIZED_F(XMM3),
> > > 		VIRTUALIZED_F(PCLMULQDQ),
> > > 		VIRTUALIZED_F(SSSE3),
> > > 		VIRTUALIZED_F(FMA),
> > > 		VIRTUALIZED_F(CX16),
> > > 		VIRTUALIZED_F(PDCM),
> > > 		VIRTUALIZED_F(PCID),
> > > 		VIRTUALIZED_F(XMM4_1),
> > > 		VIRTUALIZED_F(XMM4_2),
> > > 		EMULATED_F(X2APIC),
> > > 		VIRTUALIZED_F(MOVBE),
> > > 		VIRTUALIZED_F(POPCNT),
> > > 		EMULATED_F(TSC_DEADLINE_TIMER),
> > > 		VIRTUALIZED_F(AES),
> > > 		VIRTUALIZED_F(XSAVE),
> > > 		// DYNAMIC_F(OSXSAVE),
> > > 		VIRTUALIZED_F(AVX),
> > > 		VIRTUALIZED_F(F16C),
> > > 		VIRTUALIZED_F(RDRAND),
> > > 		EMULATED_F(HYPERVISOR)
> > > 	);
> > 
> > Hi,
> > 
> > This is no doubt better than using '|'.
> > 
> > I still strongly prefer my version, because I don't really like the fact that
> > _F macros have side effects, and yet passed as parameters to the
> > kvm_cpu_cap_init function/macro.
> > 
> > Basically an unwritten rule, which I consider very important and because of which
> > I raised my concerns over this patch series is that if a function has side effects,
> > it should not be used as a parameter to another function, instead, it should be 
> > called explicitly on its own.
> 
> Splitting hairs to some degree, but the above suggestion is distinctly different
> than passing the _result_ of a function call as a parameter to another function.
> The actual "call" happens within the body of kvm_cpu_cap_init().

You are technically right but you use a wrong point of view: You know the implementation,
and I pretend that I don't know it, and try to look at this from the point of view
of someone who just looks a the code for the first time, e.g. to fix some bugs.

Someone who doesn't know anything about this, won't know if these are macros, cleverly
passed to another variadric macro (which is itself a feature that is not often used)

I just state the fact: a function or what looks like a function, result of which
is evaluated in expression or passed to another function (within a single statement)
should not have side effects. 
Only top level function/procedure calls allowed to have side effects - 
otherwise this is just confusing.

Let me explain this again with code:

When I see for the first time this:

result = foo(x) | bar(x);

I strongly expect both foo and bar to be pure functions with no side effects.

Or if I see this for the first time:

err = somefunc(foo(x), bar(x));

I also expect that foo and bar are pure functions,
but 'somefunc' might not be because it only returns an error code,
and it is a top level statement.

And I don't care if this is implemented with functions or macros, because it
looks the same.

This is just how my common sense works.

I won't argue though more about this, I don't want to bikeshed this and block this patch series.
If you insist, let it be, but please at least use the variadic macro.


> 
> This is effectively the same as passing a function pointer to a helper, and that
> function pointer implementation having side effects, which is quite common in the
> kernel and KVM, e.g. msr_access_t, rmap_handler_t, tdp_handler_t, gfn_handler_t,
> on_lock_fn_t, etc.
> 
> I 100% agree that it's unusual and subtle to essentially have a variable number
> of function pointers, but I don't see it as being an inherently bad pattern,
> especially since it is practically impossible to misuse _because_ the macro
> unpacks the "calls" at compile time.
> 
> IMO, the part that is most gross is the macros operating on local variables, but
> that behavior exists in all ideas we've discussed, probably because I'm pretty
> sure it's unavoidable unless we do something even worse (way, waaaaay worse).
> 
> E.g. we could add 32 versions of kvm_cpu_cap_init() that invoke pairs of parameters
> and pass in the variables
> 
>   fn1(f1, virtualized, emulated, synthesized)
>   fn2(f2, virtualized, emulated, synthesized)
>   fn3(f3, virtualized, emulated, synthesized)
>   ...
>   fnN(fN, virtualized, emulated, synthesized)
> 
> and
> 
>   kvm_cpu_cap_init19(CPUID_1_ECX,
> 	F, XMM3,
> 	F, PCLMULQDQ,
> 	F, SSE3,
> 	...
> 	EMULATED_F, HYPERVISOR
>   );

I don't think that this change is worth it, but this is still better in some sense,
because at least the user won't be able to make any assumptions about the above,
and instead will have to read the code and figure out what was done here.
It won't be easy though.

> 
> But that's beyond horrific :-)
> 
> > If you strongly prefer the variadic macro over my begin/end API, I can live with
> > that though, it is still better than '|'ing a mask with functions that have side
> > effects.



Best regards,
	Maxim Levitsky


