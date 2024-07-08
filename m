Return-Path: <kvm+bounces-21131-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EF5892AAE7
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 23:09:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DC0071F227B0
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 21:09:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4458114EC64;
	Mon,  8 Jul 2024 21:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qhlytQDo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0B8714E2E2
	for <kvm@vger.kernel.org>; Mon,  8 Jul 2024 21:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720472944; cv=none; b=eyo6iitv0qOIlgX6K3HpfUFS9cMkl4piAaY4ccaNyJ3mNquGief/mwzSIkfSVhmq1RhcGCNAEx9i7cqDyGfmeWmLV2uuE6YVFz5Ly4AFxUYNQaVHs9ojIebso2Bzn77+lkwUeHh2ny3G4HbCNp8qt46VlvlryBw+ieuKrdsC2h4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720472944; c=relaxed/simple;
	bh=UCY0oMT12cXbYGxiUb0whNTnVhKRKyO8T7T985QBy3g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fzpcPEVXobaTH4gjXiYhL1flnBIN4levniTO4V2cbwaf0JvMeVNZL90ftYpBQ5Z6cPMpRQEqfUs5S81d1GXJeexCtw3bgZn9jkyTCkQu+kahIkcTvwk6DvEsBcdKPgZyakuFdDPy0uR7sABiT+KIYV1pZQKK2ArErK7xYdjTYFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qhlytQDo; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7400bdb4d7fso2791063a12.0
        for <kvm@vger.kernel.org>; Mon, 08 Jul 2024 14:09:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720472941; x=1721077741; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kJc8hSvDaUDWo9RUDcvqIuOmjAm4LLBeUNho1Hv2CCU=;
        b=qhlytQDo4yLTixTHN86gLToH8o14kiN9Xs/RhFWsu9MUVcUGa9NgmbL7p9J5L5PkxZ
         P35hzZfyoieaYshkmDbie6XTY1Ol6ipmrFsCwCHc98nTC72x7jJKuAMG4hW0P+XDS8f3
         8SFNIPPhKahfgvpa+F8a0Ud09RB6LyBQV9HYnedkFpTLaaJ+xGdNVHuROJBokip1j/fH
         WmWZ3dk31bRQK1yWt3pLowjiQ3mqqMRLkBnvQ+VP2ODS1JfXp0TPl3ZXJI63FnmVDL1e
         1fFfrYifoX8iXPb4vosJr2nI3mCV/t6K2osDQQVk6hWtNPIN5xPq9eh49o04o8ubil9c
         ITUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720472941; x=1721077741;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kJc8hSvDaUDWo9RUDcvqIuOmjAm4LLBeUNho1Hv2CCU=;
        b=AsGU7GHUEfFzPFYZdyhE25+1tNwEJ65mHLbw2C4OVz4NS1zfMliZeNK2hdg497jQWl
         Z1RzukN15gg1vNYQk3oJqMcvB35p1himxWaL8JVJhsTSY+Zq+rnToib95Rkp2Oj22N8S
         1E9580EvDvsjjJ7A8N5ezFc21NOrbyfjFzqF7Q7cir1Ax7bN25jmn5ua+zJEAQRXUHQO
         rURfTp34QlYWbhxc4feaALU/k9qZbt7VBW2kA+k2CwMoXjd+LoWEneuJgSxJH0yupQfc
         wIBa4d/7erIRIhM4n5Tk/ywmtZiXBMYa4bCbuacs37QhYEol0zv73Hf/8KNxMCKqww69
         XNHg==
X-Forwarded-Encrypted: i=1; AJvYcCXBuLsBDnLZsu+Xc4PmRgAuUqZ05d9x9us+PSvY1rMCRD1n0wjUUAa6GOC2t5ByPWpO4NE9JPE/TEXNrr5NTTEvMNLu
X-Gm-Message-State: AOJu0Yxeo1nWPqUrtlhsYnvZUjKw1RXeax75mWKAKEtADCB1snkX89Ja
	5+9uAo3Xv98xHRQqXvSUUmHSJSFZ7bxCFOgAJqfCCt8OQ6SzIfViFiOmN7ubfXSKi5UAZerWOHP
	ooA==
X-Google-Smtp-Source: AGHT+IGsVKL0cdx/QPl63vLzqZ+LYLCok44hWrS2+8LTAOBodGDenIuqrC8nG2+j+jaKbmFY7lnYYFb5VmQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:50a:b0:6e4:d411:7c64 with SMTP id
 41be03b00d2f7-77db501c382mr1344a12.3.1720472940832; Mon, 08 Jul 2024 14:09:00
 -0700 (PDT)
Date: Mon, 8 Jul 2024 14:08:59 -0700
In-Reply-To: <43ef06aca700528d956c8f51101715df86f32a91.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com> <20240517173926.965351-23-seanjc@google.com>
 <43ef06aca700528d956c8f51101715df86f32a91.camel@redhat.com>
Message-ID: <ZoxVa55MIbAz-WnM@google.com>
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

On Thu, Jul 04, 2024, Maxim Levitsky wrote:
> On Fri, 2024-05-17 at 10:38 -0700, Sean Christopherson wrote:
> > Add a macro to precisely handle CPUID features that AMD duplicated from
> > CPUID.0x1.EDX into CPUID.0x8000_0001.EDX.  This will allow adding an
> > assert that all features passed to kvm_cpu_cap_init() match the word being
> > processed, e.g. to prevent passing a feature from CPUID 0x7 to CPUID 0x1.
> > 
> > Because the kernel simply reuses the X86_FEATURE_* definitions from
> > CPUID.0x1.EDX, KVM's use of the aliased features would result in false
> > positives from such an assert.
> > 
> > No functional change intended.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/cpuid.c | 24 +++++++++++++++++-------
> >  1 file changed, 17 insertions(+), 7 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index 5e3b97d06374..f2bd2f5c4ea3 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -88,6 +88,16 @@ u32 xstate_required_size(u64 xstate_bv, bool compacted)
> >  	F(name);						\
> >  })
> >  
> > +/*
> > + * Aliased Features - For features in 0x8000_0001.EDX that are duplicates of
> > + * identical 0x1.EDX features, and thus are aliased from 0x1 to 0x8000_0001.
> > + */
> > +#define AF(name)								\
> > +({										\
> > +	BUILD_BUG_ON(__feature_leaf(X86_FEATURE_##name) != CPUID_1_EDX);	\
> > +	feature_bit(name);							\
> > +})
> > +
> >  /*
> >   * Magic value used by KVM when querying userspace-provided CPUID entries and
> >   * doesn't care about the CPIUD index because the index of the function in
> > @@ -758,13 +768,13 @@ void kvm_set_cpu_caps(void)
> >  	);
> >  
> >  	kvm_cpu_cap_init(CPUID_8000_0001_EDX,
> > -		F(FPU) | F(VME) | F(DE) | F(PSE) |
> > -		F(TSC) | F(MSR) | F(PAE) | F(MCE) |
> > -		F(CX8) | F(APIC) | 0 /* Reserved */ | F(SYSCALL) |
> > -		F(MTRR) | F(PGE) | F(MCA) | F(CMOV) |
> > -		F(PAT) | F(PSE36) | 0 /* Reserved */ |
> > -		F(NX) | 0 /* Reserved */ | F(MMXEXT) | F(MMX) |
> > -		F(FXSR) | F(FXSR_OPT) | X86_64_F(GBPAGES) | F(RDTSCP) |
> > +		AF(FPU) | AF(VME) | AF(DE) | AF(PSE) |
> > +		AF(TSC) | AF(MSR) | AF(PAE) | AF(MCE) |
> > +		AF(CX8) | AF(APIC) | 0 /* Reserved */ | F(SYSCALL) |
> > +		AF(MTRR) | AF(PGE) | AF(MCA) | AF(CMOV) |
> > +		AF(PAT) | AF(PSE36) | 0 /* Reserved */ |
> > +		F(NX) | 0 /* Reserved */ | F(MMXEXT) | AF(MMX) |
> > +		AF(FXSR) | F(FXSR_OPT) | X86_64_F(GBPAGES) | F(RDTSCP) |
> >  		0 /* Reserved */ | X86_64_F(LM) | F(3DNOWEXT) | F(3DNOW)
> >  	);
> >  
> 
> Hi,
> 
> What if we defined the aliased features instead.
> Something like this:
> 
> #define __X86_FEATURE_8000_0001_ALIAS(feature) \
> 	(feature + (CPUID_8000_0001_EDX - CPUID_1_EDX) * 32)
> 
> #define KVM_X86_FEATURE_FPU_ALIAS	__X86_FEATURE_8000_0001_ALIAS(KVM_X86_FEATURE_FPU)
> #define KVM_X86_FEATURE_VME_ALIAS	__X86_FEATURE_8000_0001_ALIAS(KVM_X86_FEATURE_VME)
> 
> And then just use for example the 'F(FPU_ALIAS)' in the CPUID_8000_0001_EDX

At first glance, I really liked this idea, but after working through the
ramifications, I think I prefer "converting" the flag when passing it to
kvm_cpu_cap_init().  In-place conversion makes it all but impossible for KVM to
check the alias, e.g. via guest_cpu_cap_has(), especially since the AF() macro
doesn't set the bits in kvm_known_cpu_caps (if/when a non-hacky validation of
usage becomes reality).

Side topic, if it's not already documented somewhere else, kvm/x86/cpuid.rst
should call out that KVM only honors the features in CPUID.0x1, i.e. that setting
aliased bits in CPUID.0x8000_0001 is supported if and only if the bit(s) is also
set in CPUID.0x1.

