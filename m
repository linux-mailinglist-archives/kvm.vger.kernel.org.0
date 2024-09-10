Return-Path: <kvm+bounces-26345-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BACE997441C
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 22:37:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7D4B7287273
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 20:37:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FA411A707B;
	Tue, 10 Sep 2024 20:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hkPyvjGx"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C94FB1741E8
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 20:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726000629; cv=none; b=oTyIPo2Lf3c/MBh7Xgs09PfJiZWJbaHdQtcLfPOcjbdBiiYU/TG31ZHnoMtisWpYOedg7E9R/6fdLdKdzcYNYqmotD+d9JjDwH6B73xL3u1w3sm70BKRfpJPYjbv9T5cYA4zlHwV0yzHEHnkL7KDRvTjqGFNhUXu7lX4y9zm5dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726000629; c=relaxed/simple;
	bh=aVHEeNzFOm4LF+kU6BEHYMwFBnWzH9T9ec3sbI1wGzw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PSwJKF7cl9FTsWE60feI8Hyc56T1t+VRJKt2MVYfwfcxhg5vkpg7Vo/dBcCUtBuwhoniGAdPxx3/qjed1jpNX9p6KvSSSUvy3BL9f96RO5CXw3k9zN2hWx+OK/LeNszmQbsiGB64UqhcP0HwexXPHMnNhp/SLjeB9ZXMhMQxEiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hkPyvjGx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726000626;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q9/XnTNN38MUq9u6fZgBkjo42UTNP+Y6Vu/qqdocpo0=;
	b=hkPyvjGx64MhPSjW8psMkR63MetIs4Uhq3nfCL6W6DHh3ko5jIWm1bzWbch9lh1+DaEXFf
	af3Id0cLO3Xe4AnGO9+cMuSIcwugrVVwVXjjlhi36EpSN7ywr/snQsn+Q/oKPvOtlJUMoI
	xz7N1joBxkvc2VXFznOugmy8NWeMxjk=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-159-MvaKb5PuPiuH0uaKHLyHGA-1; Tue, 10 Sep 2024 16:37:05 -0400
X-MC-Unique: MvaKb5PuPiuH0uaKHLyHGA-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-6c35b3a220aso4772876d6.0
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 13:37:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726000625; x=1726605425;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Q9/XnTNN38MUq9u6fZgBkjo42UTNP+Y6Vu/qqdocpo0=;
        b=EmKTEE4KuKClKu/rsdwiEO067+siccutHxWv3+Oc5tpqmZQc5Tsom0cefwyzN/Y/yk
         c8kiO9CjXX6OyNEqHTF40k5bpwVOYOYJcf4d4fc533nfAOabk6bqiFN8/hdmHNhLr30y
         HHTChq6my2JKXZvrkIjXGQAEFpwjHEaxYf1rPbbKDsYxR2HKkqs0d2ZyI7c+bFiyRiMr
         OtFYt9eDAKbktn+Q4RraGHyDsvfUTuNBMHzLpc2BveUu7tVebx4vP/yuEFkH6QTaUD0M
         ykJMiT2HyyDXYs8cs6jQu3XxSZZjRcZgktSDX5sSt5VXHd7LgDq5xTXC2KyDZAePKRod
         V6Fg==
X-Forwarded-Encrypted: i=1; AJvYcCXK2cW7GXqJJl6MYHtXpWXFyar0xTG8cvmrJ4MQL8f3o+g6fvbgILk1hNdCfWelxHrd3Xw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyEwnSTDQjtjRAsmwBGE0RSK23NQpLCjqm766HIwSBun3lMx551
	qV4NZHPwu+CNHNzgpI4hljVwW6fU8zKsv2MufM2ESpAGVaGT5Z2A2XIyFi1skEYmSVjcteu4lDf
	wdbK2nFHYwwla2ciMUiMXs0/whdpxtE3ux8EkQlr5cmzRJidhtw==
X-Received: by 2002:ad4:5dc6:0:b0:6c4:d2f9:644e with SMTP id 6a1803df08f44-6c554d43f77mr72921616d6.12.1726000624836;
        Tue, 10 Sep 2024 13:37:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGrqSLKSPDJj3hMABilp0LfLhiMlrqFtNDvhizWXrMFBxm/Irv+MVixW3x//LDXGfBMevPJ6Q==
X-Received: by 2002:ad4:5dc6:0:b0:6c4:d2f9:644e with SMTP id 6a1803df08f44-6c554d43f77mr72920956d6.12.1726000624143;
        Tue, 10 Sep 2024 13:37:04 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:760d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6c5343397f7sm33307116d6.49.2024.09.10.13.37.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2024 13:37:03 -0700 (PDT)
Message-ID: <44e7f9cba483bda99f8ddc0a2ad41d69687e1dbe.camel@redhat.com>
Subject: Re: [PATCH v2 22/49] KVM: x86: Add a macro to precisely handle
 aliased 0x1.EDX CPUID features
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov
 <vkuznets@redhat.com>,  kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>,
 Oliver Upton <oliver.upton@linux.dev>, Binbin Wu
 <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>,
 Robert Hoo <robert.hoo.linux@gmail.com>
Date: Tue, 10 Sep 2024 16:37:02 -0400
In-Reply-To: <ZrFLlxvUs86nqDqG@google.com>
References: <20240517173926.965351-1-seanjc@google.com>
	 <20240517173926.965351-23-seanjc@google.com>
	 <43ef06aca700528d956c8f51101715df86f32a91.camel@redhat.com>
	 <ZoxVa55MIbAz-WnM@google.com>
	 <3da2be9507058a15578b5f736bc179dc3b5e970f.camel@redhat.com>
	 <ZqKb_JJlUED5JUHP@google.com>
	 <8f35b524cda53aff29a9389c79742fc14f77ec68.camel@redhat.com>
	 <ZrFLlxvUs86nqDqG@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 2024-08-05 at 15:00 -0700, Sean Christopherson wrote:
> On Mon, Aug 05, 2024, mlevitsk@redhat.com wrote:
> > У чт, 2024-07-25 у 11:39 -0700, Sean Christopherson пише:
> > > > On Wed, Jul 24, 2024, Maxim Levitsky wrote:
> > > > > > On Mon, 2024-07-08 at 14:08 -0700, Sean Christopherson wrote:
> > > > > > > > On Thu, Jul 04, 2024, Maxim Levitsky wrote:
> > > > > > > > > > What if we defined the aliased features instead.
> > > > > > > > > > Something like this:
> > > > > > > > > > 
> > > > > > > > > > #define __X86_FEATURE_8000_0001_ALIAS(feature) \
> > > > > > > > > >         (feature + (CPUID_8000_0001_EDX - CPUID_1_EDX) * 32)
> > > > > > > > > > 
> > > > > > > > > > #define KVM_X86_FEATURE_FPU_ALIAS       __X86_FEATURE_8000_0001_ALIAS(KVM_X86_FEATURE_FPU)
> > > > > > > > > > #define KVM_X86_FEATURE_VME_ALIAS       __X86_FEATURE_8000_0001_ALIAS(KVM_X86_FEATURE_VME)
> > > > > > > > > > 
> > > > > > > > > > And then just use for example the 'F(FPU_ALIAS)' in the CPUID_8000_0001_EDX
> > > > > > > > 
> > > > > > > > At first glance, I really liked this idea, but after working through the
> > > > > > > > ramifications, I think I prefer "converting" the flag when passing it to
> > > > > > > > kvm_cpu_cap_init().  In-place conversion makes it all but impossible for KVM to
> > > > > > > > check the alias, e.g. via guest_cpu_cap_has(), especially since the AF() macro
> > > > > > > > doesn't set the bits in kvm_known_cpu_caps (if/when a non-hacky validation of
> > > > > > > > usage becomes reality).
> > > > > > 
> > > > > > Could you elaborate on this as well?
> > > > > > 
> > > > > > My suggestion was that we can just treat aliases as completely independent
> > > > > > and dummy features, say KVM_X86_FEATURE_FPU_ALIAS, and pass them as is to the
> > > > > > guest, which means that if an alias is present in host cpuid, it appears in
> > > > > > kvm caps, and thus qemu can then set it in guest cpuid.
> > > > > > 
> > > > > > I don't think that we need any special treatment for them if you look at it
> > > > > > this way.  If you don't agree, can you give me an example?
> > > > 
> > > > KVM doesn't honor the aliases beyond telling userspace they can be set (see below
> > > > for all the aliased features that KVM _should_ be checking).  The APM clearly
> > > > states that the features are the same as their CPUID.0x1 counterparts, but Intel
> > > > CPUs don't support the aliases.  So, as you also note below, I think we could
> > > > unequivocally say that enumerating the aliases but not the "real" features is a
> > > > bogus CPUID model, but we can't say the opposite, i.e. the real features can
> > > > exists without the aliases.
> > > > 
> > > > And that means that KVM must never query the aliases, e.g. should never do
> > > > guest_cpu_cap_has(KVM_X86_FEATURE_FPU_ALIAS), because the result is essentially
> > > > meaningless.  It's a small thing, but if KVM_X86_FEATURE_FPU_ALIAS simply doesn't
> > > > exist, i.e. we do in-place conversion, then it's impossible to feed the aliases
> > > > into things like guest_cpu_cap_has().
> > 
> > This only makes my case stronger - treating the aliases as just features will
> > allow us to avoid adding more logic to code which is already too complex IMHO.
> > 
> > If your concern is that features could be queried by guest_cpu_cap_has()
> > that is easy to fix, we can (and should) put them into a separate file and
> > #include them only in cpuid.c.
> > 
> > We can even #undef the __X86_FEATURE_8000_0001_ALIAS macro after the kvm_set_cpu_caps,
> > then if I understand the macro pre-processor correctly, any use of feature alias
> > macros will not fully evaluate and cause a compile error.
> 
> I don't see how that's less code.  Either way, KVM needs a macro to handle aliases,
> e.g. either we end up with ALIAS_F() or __X86_FEATURE_8000_0001_ALIAS().  For the
> macros themselves, IMO they carry the same amount of complexity.
> 
> If we go with ALIASED_F() (or ALIASED_8000_0001_F()), then that macro is all that
> is needed, and it's bulletproof.  E.g. there is no KVM_X86_FEATURE_FPU_ALIAS that
> can be queried, and thus no need to be ensure it's defined in cpuid.c and #undef'd
> after its use.
> 
> Hmm, I supposed we could harden the aliased feature usage in the same way as the
> ALIASED_F(), e.g.
> 
>   #define __X86_FEATURE_8000_0001_ALIAS(feature)				\
>   ({										\
> 	BUILD_BUG_ON(__feature_leaf(X86_FEATURE_##name) != CPUID_1_EDX);	\
> 	BUILD_BUG_ON(kvm_cpu_cap_init_in_progress != CPUID_8000_0001_EDX);	\
> 	(feature + (CPUID_8000_0001_EDX - CPUID_1_EDX) * 32);			\
>   })
> 
> If something tries to use an X86_FEATURE_*_ALIAS outside if kvm_cpu_cap_init(),
> it would need to define and set kvm_cpu_cap_init_in_progress, i.e. would really
> have to try to mess up.
> 
> Effectively the only differences are that KVM would have ~10 or so more lines of
> code to define the X86_FEATURE_*_ALIAS macros, and that the usage would look like:
> 
> 	VIRTUALIZED_F(FPU_ALIAS)
> 
> versus
> 
> 	ALIASED_F(FPU)


This is exactly my point. I want to avoid profiliation of the _F macros, because
later, we will need to figure out what each of them (e.g ALIASED_F) does.

A whole leaf alias, is once in x86 arch life misfeature, and it is very likely that
Intel/AMD won't add more such aliases.

Why VIRTUALIZED_F though, it wasn't in the patch series? Normal F() should be enough
IMHO.


> 
> At that point, I'm ok with defining each alias, though I honestly still don't
> understand the motivation for defining single-use macros.
> 

The idea is that nobody will need to look at these macros (e.g__X86_FEATURE_8000_0001_ALIAS() and its usages), 
because it's clear what they do, they just define few extra CPUID features 
that nobody really cares about.

ALIASED_F() on the other hand is yet another _F macro() and we will need,
once again and again to figure out why it is there, what it does, etc.

Best regards,
	Maxim Levitsky




