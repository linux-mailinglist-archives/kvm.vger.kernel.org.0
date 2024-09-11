Return-Path: <kvm+bounces-26557-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A5039757E7
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 18:04:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0692E28ADBE
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 16:04:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C2F81AD3F6;
	Wed, 11 Sep 2024 16:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zHeny3xr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091042B9A2
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 16:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726070619; cv=none; b=FDPehL59D55JrLcKlKZcGIk60QiZeSt3IL6JKBL7N+taSPjpCyD0yPDYE8xbGT6ZgPN5SnRc+tOHZac1pDkjv50og8OAbz8ghhX1vAy4l3cL6Axkj91aZ9rkkKSzOo5csKIaNkfvCuu5B422u7DTBlG80vpE5Ah6GiDODGy7ouU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726070619; c=relaxed/simple;
	bh=Sqm+BH1SNhGvp71DxcucSIKpift17cguAvvmLi/mmdA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HzwOItcHYynxFWPzpgvvR92ZhJI08XhEfyiWZXjGSZyQP56LKrNsrSHtIrEhoFT8Fc4ngqG7fDcwfOzRImHHiUgrfokxRMB022+AiNcyXeda6YOtrTeHczH1tynWlkxR1Yh09Va8zqiql8e9KMk9bn9IwPs8ip2GKJDXhs/yBzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zHeny3xr; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6db7a8c6831so103750037b3.3
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 09:03:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726070617; x=1726675417; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2fsU6mKaWhb029bzTkMtAVltWrXCR6se7VysAYyqUYI=;
        b=zHeny3xrwVgCrYgyTTsrv+cFnyrcVqebh8Woqet7ubIlpemv75wTSI0HtcLlRdW4oQ
         c1dSNjYzhO06Y2FM8lL8IplQG2jdBpXS0evHzhGRY4NEmKPAkABOge4GI2LRKd1ChgXd
         DFPh20Oz2cOlRhHv4rN1s7NSL3WsTT+mxJvMBdOmM441oiWFWuxnOyhA8Svg6Rf/RIuw
         Tgl7jCcCAQ9dI4en0gZyiFagNbW+sw/0KtvpOckTwyqrL/kNg9MkUqM3vD7hbvMyaxHa
         CKpACnXILSbNrXlJ0o47AqZwSrBTKg39bjTMSc5vr5iPQwAD2qlEObuVx8nHEt197o/Q
         dMvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726070617; x=1726675417;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2fsU6mKaWhb029bzTkMtAVltWrXCR6se7VysAYyqUYI=;
        b=Q67g8a0kQDX/51Y2Mr8n3WZr06r0twYD62gVVaJBgUo4TH3gYTdveiivu1slgtYzoD
         1IgPTvE5jQtY+3ttX1JKOnnTe4daBnBvbdqoPcNxxMgs8z0ZwKu5aMTyKWuKgNi6lazN
         Ne/rLmCBB5tRBDGb8tUBycCQXhN6Le0rUtaleBHaN/3/myfAwW6w8woFlhxPcIuBXWzO
         p+rhz16cDjDrTz26JqffvtAt5zN94xJi6X3UvTQRCgN2M6l5HsN+qsQraYnAJ4BE1oVC
         6fL7NUtXlppe/3Jpm1aLfSd0ZaVx+QoEtBVAVD4wfz6JE2vTD90bJVtLyQUX9Bl0FxEz
         K/JQ==
X-Forwarded-Encrypted: i=1; AJvYcCWYbM/fY1nn2vANEp6Dxz3xyzWwQOmgvh1c7szUFjy1EXx6ACxsleO9DaY1rkmpYprWug4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKFSoIPUzHOl3zPvdvhcyl4cGn+0yiSviojDJ5chIbF8Q1A49j
	ANPkINZRJ83t1jALCyEQPjyzMYzkyUvGhw7Umx/oSH+J1+s+vftDu6ttR2oPj1anXu80L537iyA
	TbQ==
X-Google-Smtp-Source: AGHT+IEYbBIjUHZHAzuiNIFVLNDkp0NrBNgU39tv+i/fHwdAPRddCvm1mDfZ2WUf973+kXGxTs82VlGfag0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:25c1:b0:6ad:feb0:d01c with SMTP id
 00721157ae682-6db4515dc01mr7951917b3.3.1726070617071; Wed, 11 Sep 2024
 09:03:37 -0700 (PDT)
Date: Wed, 11 Sep 2024 09:03:35 -0700
In-Reply-To: <96b32724ad1ce9ac88abb209d196b01116536a61.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com> <20240517173926.965351-27-seanjc@google.com>
 <2e0f3fb63c810dd924907bccf9256f6f193b02ec.camel@redhat.com>
 <ZoxooTvO5vIEnS5V@google.com> <2e531204c32c05c96e852748d490424a6f69a018.camel@redhat.com>
 <ZqQ6DWUou8hvu0qE@google.com> <2d77b69729354b016eb76537523c9e32e7c011c5.camel@redhat.com>
 <ZrEvCc6yYdT-cHxD@google.com> <96b32724ad1ce9ac88abb209d196b01116536a61.camel@redhat.com>
Message-ID: <ZuG_V9k8fbh8bKc5@google.com>
Subject: Re: [PATCH v2 26/49] KVM: x86: Add a macro to init CPUID features
 that KVM emulates in software
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Hou Wenlong <houwenlong.hwl@antgroup.com>, 
	Kechen Lu <kechenl@nvidia.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Sep 10, 2024, Maxim Levitsky wrote:
> On Mon, 2024-08-05 at 12:59 -0700, Sean Christopherson wrote:
> > > And now we have:
> > > 
> > > kvm_cpu_cap_init_begin(CPUID_12_EAX);
> > >  feature_scattered(SGX1);
> > >  feature_scattered(SGX2);
> > >  feature_scattered(SGX_EDECCSSA);
> > > kvm_cpu_cap_init_end();
> > 
> > I don't love the syntax (mainly the need for a begin()+end()), but I'm a-ok
> > getting rid of the @mask param/input.
> > 
> > What about making kvm_cpu_cap_init() a variadic macro, with the relevant features
> > "unpacked" in the context of the macro?  That would avoid the need for a trailing
> > macro, and would provide a clear indication of when/where the set of features is
> > "initialized".
> > 
> > The biggest downside I see is that the last entry can't have a trailing comma,
> > i.e. adding a new feature would require updating the previous feature too.
> > 
> > #define kvm_cpu_cap_init(leaf, init_features...)			\
> > do {									\
> > 	const struct cpuid_reg cpuid = x86_feature_cpuid(leaf * 32);	\
> > 	const u32 __maybe_unused kvm_cpu_cap_init_in_progress = leaf;	\
> > 	u32 kvm_cpu_cap_virtualized= 0;					\
> > 	u32 kvm_cpu_cap_emulated = 0;					\
> > 	u32 kvm_cpu_cap_synthesized = 0;				\
> > 									\
> > 	init_features;							\
> > 									\
> > 	kvm_cpu_caps[leaf] = kvm_cpu_cap_virtualized;			\
> > 	kvm_cpu_caps[leaf] &= (raw_cpuid_get(cpuid) |			\
> > 			       kvm_cpu_cap_synthesized);		\
> > 	kvm_cpu_caps[leaf] |= kvm_cpu_cap_emulated;			\
> > } while (0)
> > 
> > 	kvm_cpu_cap_init(CPUID_1_ECX,
> > 		VIRTUALIZED_F(XMM3),
> > 		VIRTUALIZED_F(PCLMULQDQ),
> > 		VIRTUALIZED_F(SSSE3),
> > 		VIRTUALIZED_F(FMA),
> > 		VIRTUALIZED_F(CX16),
> > 		VIRTUALIZED_F(PDCM),
> > 		VIRTUALIZED_F(PCID),
> > 		VIRTUALIZED_F(XMM4_1),
> > 		VIRTUALIZED_F(XMM4_2),
> > 		EMULATED_F(X2APIC),
> > 		VIRTUALIZED_F(MOVBE),
> > 		VIRTUALIZED_F(POPCNT),
> > 		EMULATED_F(TSC_DEADLINE_TIMER),
> > 		VIRTUALIZED_F(AES),
> > 		VIRTUALIZED_F(XSAVE),
> > 		// DYNAMIC_F(OSXSAVE),
> > 		VIRTUALIZED_F(AVX),
> > 		VIRTUALIZED_F(F16C),
> > 		VIRTUALIZED_F(RDRAND),
> > 		EMULATED_F(HYPERVISOR)
> > 	);
> 
> Hi,
> 
> This is no doubt better than using '|'.
> 
> I still strongly prefer my version, because I don't really like the fact that
> _F macros have side effects, and yet passed as parameters to the
> kvm_cpu_cap_init function/macro.
> 
> Basically an unwritten rule, which I consider very important and because of which
> I raised my concerns over this patch series is that if a function has side effects,
> it should not be used as a parameter to another function, instead, it should be 
> called explicitly on its own.

Splitting hairs to some degree, but the above suggestion is distinctly different
than passing the _result_ of a function call as a parameter to another function.
The actual "call" happens within the body of kvm_cpu_cap_init().  

This is effectively the same as passing a function pointer to a helper, and that
function pointer implementation having side effects, which is quite common in the
kernel and KVM, e.g. msr_access_t, rmap_handler_t, tdp_handler_t, gfn_handler_t,
on_lock_fn_t, etc.

I 100% agree that it's unusual and subtle to essentially have a variable number
of function pointers, but I don't see it as being an inherently bad pattern,
especially since it is practically impossible to misuse _because_ the macro
unpacks the "calls" at compile time.

IMO, the part that is most gross is the macros operating on local variables, but
that behavior exists in all ideas we've discussed, probably because I'm pretty
sure it's unavoidable unless we do something even worse (way, waaaaay worse).

E.g. we could add 32 versions of kvm_cpu_cap_init() that invoke pairs of parameters
and pass in the variables

  fn1(f1, virtualized, emulated, synthesized)
  fn2(f2, virtualized, emulated, synthesized)
  fn3(f3, virtualized, emulated, synthesized)
  ...
  fnN(fN, virtualized, emulated, synthesized)

and

  kvm_cpu_cap_init19(CPUID_1_ECX,
	F, XMM3,
	F, PCLMULQDQ,
	F, SSE3,
	...
	EMULATED_F, HYPERVISOR
  );

But that's beyond horrific :-)

> If you strongly prefer the variadic macro over my begin/end API, I can live with
> that though, it is still better than '|'ing a mask with functions that have side
> effects.

