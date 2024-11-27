Return-Path: <kvm+bounces-32567-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 98B099DA9FD
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 15:39:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 39B43164D86
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 14:39:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 660CF1FF7BB;
	Wed, 27 Nov 2024 14:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oHjNr/E7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 016921FF7B5
	for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 14:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732718324; cv=none; b=EZId/lxnQ/trzb/ktRQtn4km/btOjS4Hfcze5Nkupgl8DbLo+blOM2Ww0Dm5lC+/NaP5HNfc7eGPTZVf0MtMimlJCf2C++s+r2D2ujTnzAeIylIkN/pOH+nAj1ya53sxJJ3cG5s8juy26/5W0B4Fdqeaes44kQhq5Ho+KCICJIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732718324; c=relaxed/simple;
	bh=xT97KYgdluN7ebir3nQvf+4Hgac1dq5jbrG4z+OLnsc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=knGISypSdwQedYACVM5HeFNDcZW7qBfALRz2b4BUJz59SEXOdNEakZpXAwbTW9qfA9lvojcXRB9EhX9iHvWJf+AYSoLnYP52ut+8t3Z2dE/2WNE1CL/KDddqaqKommJzAgtqWfcvlcbbD0ht079cbJD0kcuNzORSx/gSrPygwQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oHjNr/E7; arc=none smtp.client-ip=209.85.166.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-il1-f201.google.com with SMTP id e9e14a558f8ab-3a7776959fdso74046385ab.1
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 06:38:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732718322; x=1733323122; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RcW151oQ5hondKtplla/DkVWCP6XFqg+OnT+IGOy13o=;
        b=oHjNr/E7Gqu5IU/mx96kzhrk3/6fzB+qcYaWvWCcpANsuzVAfDCK2vKdlVmG1ei+/q
         KYWM9uzyjkOJOiXoNiHz86igzgp69psGE2Sxm+QjpB4Y51iyqyiyxojxIfQU28EkaEpT
         3CdXjCDxvjsRneJcfDf95BeEyb79g9kVThMFaAfGbIKsedXLwCANS1WVfJPQP+cNekDU
         f36aNtSxyXGNq296Lze/ihooLmE75K5OMmL5ISIDi0VQ43GkwE5/f5F2F+hVekV3jS3F
         5wABWAkIoTSjrwocQAE6EeKMHmPtOV6eFl8O6EbFZYF80agVTXizR78vXR9D1z5saZ85
         /asQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732718322; x=1733323122;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RcW151oQ5hondKtplla/DkVWCP6XFqg+OnT+IGOy13o=;
        b=gTTnD/Nbn/cbDH1D3dcjPIAaBM63fTh9TqOpGZmifOT5B7sNcRNvIihZVpeYGOlwHc
         flTMr1Pimi3fBlhhp7GrHSNNSQHlCyllOc1Cye7TxritD8QRQMdt0KKTctJDR0nmb+ZZ
         emLBRsqjYy92BC5jVxFTTtw9Yg65LpeMdupBDEDIK9gOo5r7Im4m9za2Uo3pZimkx2fE
         TIM9M9csNMiMFwk2V979Cvlk0h3i4HFpthaK5BIO8FTokRosSgWgGYnOfFFrWm47e8QZ
         17T3t+10SwzGnZYZSm9p3HXLjOGqOxlBveOvctUDHj7dBYQ52fUdIk7qIU3odO8pcA4h
         tXaA==
X-Forwarded-Encrypted: i=1; AJvYcCUG7uPe/lMwHMIcJaf+Ok/IV35qVD1FcxIVzTtLhgaCqMCKABMTyofBLHdzLox5gy/WnGo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzqG+v6AI/cXDh97gw8nCZz9byBf5OeIFhiLO9V8FuUCrMuA0XR
	fxcXS6U6oHe1m+1oIfnJj0eitP1hWszyndFvFk8oYCFGNjJrN6utdqgjROqTZWmcZuZxr/akSDy
	jyw==
X-Google-Smtp-Source: AGHT+IG7Clebz5+ikhZk/p3e2lBnUMggo0Vrm0EMc7kyDhz6gWIVGZ5y2tr41LsMOLzWgPahBG28XOb331w=
X-Received: from pgg13.prod.google.com ([2002:a05:6a02:4d8d:b0:7fb:db54:f065])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6e02:1e01:b0:3a7:7ee3:108d
 with SMTP id e9e14a558f8ab-3a7c55f2783mr35486615ab.23.1732718322166; Wed, 27
 Nov 2024 06:38:42 -0800 (PST)
Date: Wed, 27 Nov 2024 06:38:41 -0800
In-Reply-To: <cbcb80ee5be13d78390ff6f4a1a3c58fc849e311.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-23-seanjc@google.com> <43ef06aca700528d956c8f51101715df86f32a91.camel@redhat.com>
 <ZoxVa55MIbAz-WnM@google.com> <3da2be9507058a15578b5f736bc179dc3b5e970f.camel@redhat.com>
 <ZqKb_JJlUED5JUHP@google.com> <8f35b524cda53aff29a9389c79742fc14f77ec68.camel@redhat.com>
 <ZrFLlxvUs86nqDqG@google.com> <44e7f9cba483bda99f8ddc0a2ad41d69687e1dbe.camel@redhat.com>
 <ZuG5ULBjfQ3hv_Jb@google.com> <cbcb80ee5be13d78390ff6f4a1a3c58fc849e311.camel@redhat.com>
Message-ID: <Z0cu8aLX7VkwmtSk@google.com>
Subject: Re: [PATCH v2 22/49] KVM: x86: Add a macro to precisely handle
 aliased 0x1.EDX CPUID features
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Hou Wenlong <houwenlong.hwl@antgroup.com>, 
	Kechen Lu <kechenl@nvidia.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 21, 2024, Maxim Levitsky wrote:
> On Wed, 2024-09-11 at 08:37 -0700, Sean Christopherson wrote:
> > On Tue, Sep 10, 2024, Maxim Levitsky wrote:
> > > On Mon, 2024-08-05 at 15:00 -0700, Sean Christopherson wrote:
> > > > At that point, I'm ok with defining each alias, though I honestly still don't
> > > > understand the motivation for defining single-use macros.
> > > > 
> > > 
> > > The idea is that nobody will need to look at these macros
> > > (e.g__X86_FEATURE_8000_0001_ALIAS() and its usages), because it's clear what
> > > they do, they just define few extra CPUID features that nobody really cares
> > > about.
> > > 
> > > ALIASED_F() on the other hand is yet another _F macro() and we will need,
> > > once again and again to figure out why it is there, what it does, etc.
> > 
> > That seems easily solved by naming the macro ALIASED_8000_0001_F().  I don't see
> > how that's any less clear than __X86_FEATURE_8000_0001_ALIAS(), and as above,
> > there are several advantages to defining the alias in the context of the leaf
> > builder.
> > 
> 
> Hi!
> 
> I am stating my point again: Treating 8000_0001 leaf aliases as regular CPUID
> features means that we don't need common code to deal with this, and thus
> when someone reads the common code (and this is the thing I care about the
> most) that someone won't need to dig up the info about what these aliases
> are. 

Ah, this is where we disagree, I think.  I feel quite strongly that oddities such
as aliased/duplicate CPUID feature bits need to be made as visible as possible,
and well documented.  Hiding architectural quirks might save some readers a few
seconds of their time, but it can also confuse others, and more importantly, makes
it more difficult for new readers/developers to learn about the quirks.

This code _looks_ wrong, as there's no indication that CPUID_8000_0001_EDX is
unique.  I too wasn't aware of the aliases until this series, and I was very
confused by KVM's code.  The only clue that I was given was the "Don't duplicate
feature flags which are redundant with Intel!" comment in cpufeatures.h; I still
ended up digging through the APM to understand what was going on.

	kvm_cpu_cap_mask(CPUID_1_EDX,
		F(FPU) | F(VME) | F(DE) | F(PSE) |
		F(TSC) | F(MSR) | F(PAE) | F(MCE) |
		F(CX8) | F(APIC) | 0 /* Reserved */ | F(SEP) |
		F(MTRR) | F(PGE) | F(MCA) | F(CMOV) |
		F(PAT) | F(PSE36) | 0 /* PSN */ | F(CLFLUSH) |
		0 /* Reserved, DS, ACPI */ | F(MMX) |
		F(FXSR) | F(XMM) | F(XMM2) | F(SELFSNOOP) |
		0 /* HTT, TM, Reserved, PBE */
	);

	kvm_cpu_cap_mask(CPUID_8000_0001_EDX,
		F(FPU) | F(VME) | F(DE) | F(PSE) |
		F(TSC) | F(MSR) | F(PAE) | F(MCE) |
		F(CX8) | F(APIC) | 0 /* Reserved */ | F(SYSCALL) |
		F(MTRR) | F(PGE) | F(MCA) | F(CMOV) |
		F(PAT) | F(PSE36) | 0 /* Reserved */ |
		F(NX) | 0 /* Reserved */ | F(MMXEXT) | F(MMX) |
		F(FXSR) | F(FXSR_OPT) | f_gbpages | F(RDTSCP) |
		0 /* Reserved */ | f_lm | F(3DNOWEXT) | F(3DNOW)
	);

Versus this code, which hopefully elicits a "huh!?" and prompts curious readers
to go look at the definition of ALIASED_1_EDX_F() to understand why KVM is being
weird.  And if readers can't figure things out purely from ALIASED_1_EDX_F()'s
comment, then that's effectively a KVM documentation issue and should be fixed.

In other words, I want to make things like this stick out so that more developers
are aware of such quirks, i.e. to to minimize the probability of such knowledge
being lost.  I don't want the next generation of KVM developers to have to
re-discover things that can be solved by a moderately verbose comment.

	kvm_cpu_cap_init(CPUID_1_EDX,
		F(FPU),
		F(VME),
		F(DE),
		F(PSE),
		F(TSC),
		F(MSR),
		F(PAE),
		F(MCE),
		F(CX8),
		F(APIC),
		...
	);

	kvm_cpu_cap_init(CPUID_8000_0001_EDX,
		ALIASED_1_EDX_F(FPU),
		ALIASED_1_EDX_F(VME),
		ALIASED_1_EDX_F(DE),
		ALIASED_1_EDX_F(PSE),
		ALIASED_1_EDX_F(TSC),
		ALIASED_1_EDX_F(MSR),
		ALIASED_1_EDX_F(PAE),
		ALIASED_1_EDX_F(MCE),
		ALIASED_1_EDX_F(CX8),
		ALIASED_1_EDX_F(APIC),
		...
	);

> I for example didn't knew about them because these aliases are basically a
> result of AMD redoing some things in the spec their way when they just
> released first 64-bit extensions.  I didn't follow the x86 ISA closely back
> then (I only had 32 bit systems to play with).
> 
> Best regards,
> 	Maxim Levitsky
> 
> 

