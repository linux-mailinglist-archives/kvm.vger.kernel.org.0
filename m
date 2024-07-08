Return-Path: <kvm+bounces-21130-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7341692AAC5
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 22:53:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DA055B21590
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 20:53:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2330C14D6FF;
	Mon,  8 Jul 2024 20:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1NbJ7Sjr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7591640849
	for <kvm@vger.kernel.org>; Mon,  8 Jul 2024 20:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720471988; cv=none; b=GOjD/B5Vh/I5NnWoNaYbUn9vEF53atuU/GT7RyjJMOzJ5CMre8wCszUp8Sd0d//sgIV3gFjWIyRhdOdntZReDOxdypm8f/adxx5mWwuSYl6sDmhMOttapRZxSfwfxLtAC2Hn+oydgVHXIGf3oneBY8hBdUTqINx9rrb03ZIgWc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720471988; c=relaxed/simple;
	bh=w1eGUfmQukYrQ1cZQTzQcmd1BC6BzYFQ+hgv8a6ff2s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AuqfeNHMwtTcBtwfeJBtOkhRDN9GXMd+UZjDZwtwVwek7b51nC321blJVTILDBC1zHTwDyMPXii5NxKel/woFp7QIaWtTK+/rbv/zGrhonL8slUHDy+3DkXladwCdalAJxnRso/j30hIdz0Mu52oVVbeEcONhFkB+xr2ScvNVm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1NbJ7Sjr; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1fb298a75ccso25561675ad.2
        for <kvm@vger.kernel.org>; Mon, 08 Jul 2024 13:53:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720471985; x=1721076785; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aWSLYXxu+J9SS0caWJhnx/Ez21q/MXAxgdHC6l0lFnE=;
        b=1NbJ7SjrzeiVh8byFBEuzjH9V82gqhTkuulKakKaOZeXUEkVBI0T6/LmleEslIut31
         V86F3JFduMK8A2nXoGk9fQqs/CaRILebpDlOyL3lbse2mRC9NU/IhSg1S200fsUOzMaX
         YodceaXNi5Y7WIuiGRN619Z6aZBbXPUr7qTgFHG6+S+1Xe3L5LpO7kEaJQ+8/thmn7YA
         Z8zrgifzlwPWAU73ZNJOqHi8iwKieMpvDhCEil8j5Cd9IJRdLgDdsSsDu4fRpDtmurhM
         WArSB0Nys/ysTdFWFszWbsYowLR1hkNx81zj/+RiyHoYK/U4OJsnWL5LlDlrJyjKaEEQ
         Miqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720471985; x=1721076785;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aWSLYXxu+J9SS0caWJhnx/Ez21q/MXAxgdHC6l0lFnE=;
        b=tv86mH/kKju/9kSda6hIRIz3eko+eVz9yeYewPZp2ZSgqPWejxw5ja/6zKL3sxyGcm
         6bKv8HTcrWvqawqxqkdZj1ZygV9RuJU1jwdOJC9ZAi9zfI7atl1TB0J59dlA7VWxO71s
         wQ2IdWpWB7kDZSJqtwXq/vRU4Ouz61gIS2qlGl2vY7zqFDOx6n6NoI7B/iY9o7/5HJGl
         noju0EZweARtgkn8MhqXeaq/OSOrl+a8afnz2I5xn0jdx/n0Oqk9YAcmAQSYY3EtNCdI
         7/4/5JPoLf+rwo73d8PtKqvkrjrEMyKqH1bOGUzHyIvKom1bfo1aY+wFOjaYNFVVOq/i
         h4pw==
X-Forwarded-Encrypted: i=1; AJvYcCWrPjlJu+pyAV3EzOMqZ5rzyNXUnv/lHV9e5D3Gjfy95//v7mKNDVNOKRe0gptg1nnPxbw03Ud78HFq4GXoVGyQ63eJ
X-Gm-Message-State: AOJu0YyccHTl7m6xxjPWCMu0TnIEHRJSw/OuUKns4oF+PuZoehE1kFzp
	48H1NcVcKw9PmamQVi2fUm1Ql3LirlbVr/pTIjJ33WfRrhAeuKtB6aWkYKISofMS5sysfGWaph3
	oow==
X-Google-Smtp-Source: AGHT+IFBEPudpxzXPGD3b7GHY/rlOfg3GHBadGfCs8OKmROTsv++oDFCm4MUUoarwdiwvag8YzR3rF++haQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f546:b0:1fa:2b89:f550 with SMTP id
 d9443c01a7336-1fbb6d0f6a5mr629255ad.1.1720471984746; Mon, 08 Jul 2024
 13:53:04 -0700 (PDT)
Date: Mon, 8 Jul 2024 13:53:03 -0700
In-Reply-To: <2a4052ba67970ce41e79deb0a0931bb54e2c2a86.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com> <20240517173926.965351-20-seanjc@google.com>
 <2a4052ba67970ce41e79deb0a0931bb54e2c2a86.camel@redhat.com>
Message-ID: <ZoxRr9P85f03w0vk@google.com>
Subject: Re: [PATCH v2 19/49] KVM: x86: Add a macro to init CPUID features
 that ignore host kernel support
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Hou Wenlong <houwenlong.hwl@antgroup.com>, 
	Kechen Lu <kechenl@nvidia.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Jul 04, 2024, Maxim Levitsky wrote:
> On Fri, 2024-05-17 at 10:38 -0700, Sean Christopherson wrote:
> > Add a macro for use in kvm_set_cpu_caps() to automagically initialize
> > features that KVM wants to support based solely on the CPU's capabilities,
> > e.g. KVM advertises LA57 support if it's available in hardware, even if
> > the host kernel isn't utilizing 57-bit virtual addresses.
> > 
> > Take advantage of the fact that kvm_cpu_cap_mask() adjusts kvm_cpu_caps
> > based on raw CPUID, i.e. will clear features bits that aren't supported in
> > hardware, and simply force-set the capability before applying the mask.
> > 
> > Abusing kvm_cpu_cap_set() is a borderline evil shenanigan, but doing so
> > avoid extra CPUID lookups, and a future commit will harden the entire
> > family of *F() macros to assert (at compile time) that every feature being
> > allowed is part of the capability word being processed, i.e. using a macro
> > will bring more advantages in the future.
> 
> Could you explain what do you mean by "extra CPUID lookups"?

cpuid_ecx(7) incurs a CPUID to read the raw info, on top of the CPUID that is
executed by kvm_cpu_cap_init() (kvm_cpu_cap_mask() as of this patch).  Obviously
not a big deal, but it's an extra VM-Exit when running as a VM.

> > +/*
> > + * Raw Feature - For features that KVM supports based purely on raw host CPUID,
> > + * i.e. that KVM virtualizes even if the host kernel doesn't use the feature.
> > + * Simply force set the feature in KVM's capabilities, raw CPUID support will
> > + * be factored in by kvm_cpu_cap_mask().
> > + */
> > +#define RAW_F(name)						\
> > +({								\
> > +	kvm_cpu_cap_set(X86_FEATURE_##name);			\
> > +	F(name);						\
> > +})
> > +
> >  /*
> >   * Magic value used by KVM when querying userspace-provided CPUID entries and
> >   * doesn't care about the CPIUD index because the index of the function in
> > @@ -682,15 +694,12 @@ void kvm_set_cpu_caps(void)
> >  		F(AVX512VL));
> >  
> >  	kvm_cpu_cap_mask(CPUID_7_ECX,
> > -		F(AVX512VBMI) | F(LA57) | F(PKU) | 0 /*OSPKE*/ | F(RDPID) |
> > +		F(AVX512VBMI) | RAW_F(LA57) | F(PKU) | 0 /*OSPKE*/ | F(RDPID) |
> >  		F(AVX512_VPOPCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
> >  		F(VAES) | F(VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
> >  		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/ |
> >  		F(SGX_LC) | F(BUS_LOCK_DETECT)
> >  	);
> > -	/* Set LA57 based on hardware capability. */
> > -	if (cpuid_ecx(7) & F(LA57))
> > -		kvm_cpu_cap_set(X86_FEATURE_LA57);
> >  
> >  	/*
> >  	 * PKU not yet implemented for shadow paging and requires OSPKE
> 
> Putting a function call into a macro which evaluates into a bitmask is
> somewhat misleading, but let it be...
> 
> IMHO in long term, it might be better to rip the whole huge 'or'ed mess, and replace
> it with a list of statements, along with comments for all unusual cases.

As in something like this?

	kvm_cpu_cap_init(AVX512VBMI);
	kvm_cpu_cap_init_raw(LA57);
	kvm_cpu_cap_init(PKU);
	...
	kvm_cpu_cap_init(BUS_LOCK_DETECT);

	kvm_cpu_cap_init_aliased(CPUID_8000_0001_EDX, FPU);

	...

	kvm_cpu_cap_init_scattered(CPUID_12_EAX, SGX1);
	kvm_cpu_cap_init_scattered(CPUID_12_EAX, SGX2);
	kvm_cpu_cap_init_scattered(CPUID_12_EAX, SGX_EDECCSSA);

The tricky parts are incorporating raw CPUID into the masking and handling features
that KVM _doesn't_ support.  For raw CPUID, we could simply do CPUID every time, or
pre-fill an array to avoid hundreds of CPUIDs that are largely redudant.

But I don't see a way to mask off unsupported features without losing the
compile-time protections that the current code provides.  And even if we took a
big hammer approach, e.g. finalized masking for all words at the very end, we'd
still need to carry state across each statement, i.e. we'd still need the bitwise-OR
and mask  behavior, it would just be buried in helpers/macros.

I suspect the generated code will be larger, but I doubt that will actually be
problematic.  The written code will also be more verbose (roughly 4x since we
tend to squeeze 4 features per line), and it will be harder to ensure initialization
of features in a given word are all co-located.

I definitely don't hate the idea, but I don't think it will be a clear "win" either.
Unless someone feels strongly about pursuing this approach, I'll add to the "things
to explore later" list.

