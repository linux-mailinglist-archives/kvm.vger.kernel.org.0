Return-Path: <kvm+bounces-22195-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EDEE393B66A
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 20:05:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1D2C11C20D25
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 18:05:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7872A16A396;
	Wed, 24 Jul 2024 18:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TBepTpeO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED349155A24
	for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 18:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721844304; cv=none; b=V/xyGpM76Gdw8hpucVc7X90QnDy82d6TcNgcxTbuhOhtrwZ0GboW9T64TotSubR0BvvZ1YjOaiWB1wnp7FPuhLQ1EFRRQuH3yjaHtgMmIyxKeo3WMa0oViJJeSHYAO+a1pKst5iWzwvqiYQmY6LxVo0tPTq6T3fLygj6WbWrEEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721844304; c=relaxed/simple;
	bh=2BLgOA35mk7k8IszDMOe6673pqC+RwrYD4ldwJUPDA4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pxIVtIPEGR/vhN5o1Q5Qkgh6L/YiJJG1sC5ucDmH2ZzijgKm8Niu9PeiechZ09y36BjlhsYJDDQCQ+HnZ/Nxj6VArZaJCPeO5Wy4mMpGXhDiSepDzhqb41TnVx93L09uVHbZV223bv88aFrL866pbjCVohPf0fOkRoMe0Itq49c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TBepTpeO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721844301;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O/S0o4/FexsmiUpHS5rZUegymR3Z4ylp/4grcZIweTk=;
	b=TBepTpeOuN6tj5bk6c+Syc5hC7WH++UlKjyQNzNzg3uYonTanvwwYgihqT2HB8vOD5KEDr
	iYFgj3nVg8pgfuczPU0HDdSFonWK0cWXBqQX4MwifFaQI2Uh9I17o7UL6GKbdh5yBioCij
	yafIVTYgecu97dvgghiR+UHb2fVSaEI=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-448-BxPLhnl6O7ix0Tdn8o5LNA-1; Wed, 24 Jul 2024 14:04:59 -0400
X-MC-Unique: BxPLhnl6O7ix0Tdn8o5LNA-1
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-79f08294f35so164085a.2
        for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 11:04:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721844299; x=1722449099;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=O/S0o4/FexsmiUpHS5rZUegymR3Z4ylp/4grcZIweTk=;
        b=if1iF7gVmB/mBwr9kdF8QkxjJ7WXUevuSjhyuOBz+LftAmHDRUO3MKozJwAvVDyQHp
         EzWek3gAe37PydNFfnPpq2SDopULLobSJCE4tHtRCcXIW4tv7s9o5AeFtfsOCV1pKVC0
         xJtngnkL8onl5FUWl4nsQkS860xz93ry/69QkxbRXBR0ckrK3/LxuzjHdnrk7cW4Mtaj
         dT8rXPJUfXv1tLyP7JuGgkJaikT1fA0HW027PWMJoNdZr4d2sK0QUBvzOlXrNXJz/3LU
         YgCYWZQT1edXrpJNM7sBp/d7mOsDMbyWuqWJAA0deDHE3UGPIPwqsi1lhVQF681hcW1U
         kxLg==
X-Forwarded-Encrypted: i=1; AJvYcCWmtU07ef4jEC/BftbNcCv/xROYYk3LiUQyw5a2/t9ylstIMWMqmwRYJscia6IsFcZPKxp9SP+QwHkh+gNvTnXWzhU9
X-Gm-Message-State: AOJu0YyvQ1E8WBNrPUGFg36SVyBmPfvpsJgzwFWjezrkhSHOZVnuzAJF
	KcYB6YJA4Qeki/xoWQgVyUDgX2ju0AjUseiqTzP/LIn+vSkX+QlG17ULvNFOHHVdPdYNpuKM4h1
	/yuGm7vwHyIt4XerdfIMztGs0R6Ri1FUof5L5XzymSLwfb+coig==
X-Received: by 2002:a05:620a:1a89:b0:79f:1860:563b with SMTP id af79cd13be357-7a1d4535d64mr69106185a.60.1721844298831;
        Wed, 24 Jul 2024 11:04:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IECfaCybkI9n3E9HnNmuEOg1q57NCdiYj+xpYMmUUXFmfBxM5u+SsEm33ENnkgKp/Hxyvs+7A==
X-Received: by 2002:a05:620a:1a89:b0:79f:1860:563b with SMTP id af79cd13be357-7a1d4535d64mr69102085a.60.1721844298337;
        Wed, 24 Jul 2024 11:04:58 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:7b7f:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a199078855sm598315085a.104.2024.07.24.11.04.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jul 2024 11:04:57 -0700 (PDT)
Message-ID: <5d4d3eb81170ccf31f41a672121670ae4194b80a.camel@redhat.com>
Subject: Re: [PATCH v2 48/49] KVM: x86: Add a macro for features that are
 synthesized into boot_cpu_data
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov
 <vkuznets@redhat.com>,  kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>,
 Oliver Upton <oliver.upton@linux.dev>, Binbin Wu
 <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>,
 Robert Hoo <robert.hoo.linux@gmail.com>
Date: Wed, 24 Jul 2024 14:04:56 -0400
In-Reply-To: <Zo2n9VQ3nBuf1d3F@google.com>
References: <20240517173926.965351-1-seanjc@google.com>
	 <20240517173926.965351-49-seanjc@google.com>
	 <16658367af25852e4bb6abb0caf7c3bc58538db0.camel@redhat.com>
	 <Zo2n9VQ3nBuf1d3F@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Tue, 2024-07-09 at 14:13 -0700, Sean Christopherson wrote:
> On Thu, Jul 04, 2024, Maxim Levitsky wrote:
> > On Fri, 2024-05-17 at 10:39 -0700, Sean Christopherson wrote:
> > > Add yet another CPUID macro, this time for features that the host kernel
> > > synthesizes into boot_cpu_data, i.e. that the kernel force sets even in
> > > situations where the feature isn't reported by CPUID.  Thanks to the
> > > macro shenanigans of kvm_cpu_cap_init(), such features can now be handled
> > > in the core CPUID framework, i.e. don't need to be handled out-of-band and
> > > thus without as many guardrails.
> > > 
> > > Adding a dedicated macro also helps document what's going on, e.g. the
> > > calls to kvm_cpu_cap_check_and_set() are very confusing unless the reader
> > > knows exactly how kvm_cpu_cap_init() generates kvm_cpu_caps (and even
> > > then, it's far from obvious).
> > > 
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > ---
> 
> ...
> 
> > Now that you added the final F_* macro, let's list all of them:
> > 
> > #define F(name)							\
> > 
> > /* Scattered Flag - For features that are scattered by cpufeatures.h. */
> > #define SF(name)						\
> > 
> > /* Features that KVM supports only on 64-bit kernels. */
> > #define X86_64_F(name)						\
> > 
> > /*
> >  * Raw Feature - For features that KVM supports based purely on raw host CPUID,
> >  * i.e. that KVM virtualizes even if the host kernel doesn't use the feature.
> >  * Simply force set the feature in KVM's capabilities, raw CPUID support will
> >  * be factored in by __kvm_cpu_cap_mask().
> >  */
> > #define RAW_F(name)						\
> > 
> > /*
> >  * Emulated Feature - For features that KVM emulates in software irrespective
> >  * of host CPU/kernel support.
> >  */
> > #define EMUL_F(name)						\
> > 
> > /*
> >  * Synthesized Feature - For features that are synthesized into boot_cpu_data,
> >  * i.e. may not be present in the raw CPUID, but can still be advertised to
> >  * userspace.  Primarily used for mitigation related feature flags.
> >  */
> > #define SYN_F(name)						\
> > 
> > /*
> >  * Aliased Features - For features in 0x8000_0001.EDX that are duplicates of
> >  * identical 0x1.EDX features, and thus are aliased from 0x1 to 0x8000_0001.
> >  */
> > #define AF(name)								\
> > 
> > /*
> >  * VMM Features - For features that KVM "supports" in some capacity, i.e. that
> >  * KVM may query, but that are never advertised to userspace.  E.g. KVM allows
> >  * userspace to enumerate MONITOR+MWAIT support to the guest, but the MWAIT
> >  * feature flag is never advertised to userspace because MONITOR+MWAIT aren't
> >  * virtualized by hardware, can't be faithfully emulated in software (KVM
> >  * emulates them as NOPs), and allowing the guest to execute them natively
> >  * requires enabling a per-VM capability.
> >  */
> > #define VMM_F(name)								\
> > 
> > 
> > Honestly, I already somewhat lost in what each of those macros means even
> > when reading the comments, which might indicate that a future reader might
> > also have a hard time understanding those.
> > 
> > I now support even more the case of setting each feature bit in a separate
> > statement as I explained in an earlier patch.
> > 
> > What do you think?
> 
> I completely agree that there are an absurd number of flavors of features, but
> I don't see how using separate statement eliminates any of that complexity.  The
> complexity comes from the fact that KVM actually has that many different ways and
> combinations for advertising and enumerating CPUID-based features.
> 
> Ignoring for the moment that "vmm" and "aliased" could be avoided for any approach,
> if we go with statements, we'll still have
> 
>   kvm_cpu_cap_init{,passthrough,emulated,synthesized,aliased,vmm,only64}()
> 
> or if the flavor is an input/enum,
> 
>   enum kvm_cpuid_feature_type {
>   	NORMAL,
> 	PASSTHROUGH,
> 	EMULATED,
> 	SYNTHESIZED,
> 	ALIASED,
> 	VMM,
> 	ONLY_64,
>   }

It doesn't have to be like that - something more compact can be done,
plus bitmask of various flags can be used.

> 
> I.e. we'll still need the same functionality and comments, it would simply be
> dressed up differently.

> 
> If the underlying concern is that the macro names are too terse, and/or getting
> one feature per line is desirable, 

I indeed have these concerns and more:

These are my concerns

1. Macro names are indeed too terse, and hard to figure out, even after looking
at the macro source.
This wasn't a problem before this patch series.

2. One feature per line would be very nice, it is much more readable, especially
when features have various 'modifiers'.
This wasn't such a problem before this patch series, because we just had features 'or'ed,
but having one feature per line would be a good thing to have even before this patch series.

3. Feature bitmap 'or'ing of macro's output after this patch series became very confusing, 
now that macros do various side things.

In fact VMM_F confuses the user even more, because it doesn't even contribute to the
feature mask at all.

It was OK before the patch series.

Technically of course I am not opposed to have the 'kvm_cpu_cap_init' or whatever we name
it, to remain a macro, it is probably even desirable to have it as a macro, but it is OK,
as long as it is just a macro which doesn't evaluate to anything and thus looks
like a function call.

Best regards,
	Maxim Levitsky


> then I'm definitely open to exploring alternative
> formatting options.  But that's largely orthogonal to using macros instead of
> individual function calls.
> 



