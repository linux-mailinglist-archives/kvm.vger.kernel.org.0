Return-Path: <kvm+bounces-22183-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1168B93B620
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 19:47:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 34AEF1C235B2
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 17:47:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF2D616848C;
	Wed, 24 Jul 2024 17:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eCxdA8qp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6478715AADE
	for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 17:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721843215; cv=none; b=tkuDMESnQfFCGMjQWYqWtykAKS3uhyjw6Wsjy1hdKupuG3MxFFbNRtXJ7GiT1yicEVhJLQpWjzWVlOqwmHwrf4Qvg/EjvrxSiDza6AUdLM2hbaaov+jA+foGd8vba/DSH2ADzFUWvMJhgtzY3awmEWHSozPfcL0cdyy1QdP0lLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721843215; c=relaxed/simple;
	bh=ulNWOnLiv50nMKjhMkMk+venKV6OZ28//9WcJKrrfVQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gN5I9b6DXIiuT36bVReCUNWHeSV/BIp4i0aqapedtnvQq02eaEA97qkePlwnMKSP3CyBWvqWXxiKpYLJVU6nKWzJZuNDYlmoYOBgHO8yE5PNrbsH1OCadcDytjEbpcyOrtogIDghOan+ZWKLq/02ES6fniMlh08PKdhaAmYgtmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eCxdA8qp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721843211;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4Re5dIvgoFLdT/hHe5IuIdb0ThWII2+4/cHcQWp4sio=;
	b=eCxdA8qpkSDbHujHCH9emgidCw42gdTArePNIqEN+KNyQnhAoTp7A1rCf5wwC1VYGNwi+D
	V7i23d1l515Gq0T1nSIevjAEJ9WA3LVbtYZWMZvNB1L2ej2RjzWeJppt+zwjcoWMkUUwN+
	ISyhrQj4u1o+x5o2245Zl14ORfmXFkU=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-61-tzXEK8atM7qWTKE0kLF4yA-1; Wed, 24 Jul 2024 13:46:49 -0400
X-MC-Unique: tzXEK8atM7qWTKE0kLF4yA-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7a1d690cef9so3764785a.0
        for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 10:46:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721843209; x=1722448009;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4Re5dIvgoFLdT/hHe5IuIdb0ThWII2+4/cHcQWp4sio=;
        b=loduDuIjKw6aRoP7b5A1yy8ckLg/NcdfwNClNNGhOM6ddrRXyu8+8e/Re4Oz8MTs8l
         QoTIil4dw9MRz2IZK7wPlVayOXJ0dszhKeT9zH6Vy4z6I1zKcBkY2cYH568qxJPC66VG
         Eiym1R7a495FzpoVv7temcEQnP3DasQ9XDdMxHOYE9d4QFjAzoB5M1nOVjaaYhT+liVN
         QDKWYAvYFBEoyQPBdV2wqmwCtWtdIdUFhWqEE4Ouifi0FpwDkeHhFdkVvDsN2L+JzWRv
         u+BWbeLAzZKMMjOKq8V0prAQVP0IlTShyZVaUSvibYLX0iGDR7dx05lS79gMjUwCx2w5
         gwRg==
X-Forwarded-Encrypted: i=1; AJvYcCX8ZHn32/kdO1Xp1zRFy3md34CXEFWYwYCkOBZisRUoLJ/VcEcuxmKUAhsvyPb0HDvsPCjRAKel8QiGzeLOxCyE1szj
X-Gm-Message-State: AOJu0YxLXtoZuAGzeag2bLUC3xVHHfUgUkvvw2Vf3l8g0XYji2g6OaCk
	oKtDbyCzGqkF7qEQBm50Dy18Kilu2IJOgzI4MOzGPOqAqYObrbsYkAnWnuINPljLpwTc/m9dRDz
	K8KW9OXahI9AMIQcFYTg2bebwIThRl5c7ThFAemHfOg3QViKnHA==
X-Received: by 2002:a05:620a:bd4:b0:795:60ba:76e9 with SMTP id af79cd13be357-7a1ccb212cdmr465238085a.4.1721843208907;
        Wed, 24 Jul 2024 10:46:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHXoyxQ5z7Tq4wMx8piiqqsyWbjcnyunZDeSZ1ya2ebyrpzwXbrdpnPaAmPpPszFVSa8FgYsg==
X-Received: by 2002:a05:620a:bd4:b0:795:60ba:76e9 with SMTP id af79cd13be357-7a1ccb212cdmr465234585a.4.1721843208474;
        Wed, 24 Jul 2024 10:46:48 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:7b7f:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a19909b4b8sm594621685a.132.2024.07.24.10.46.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jul 2024 10:46:47 -0700 (PDT)
Message-ID: <3da2be9507058a15578b5f736bc179dc3b5e970f.camel@redhat.com>
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
Date: Wed, 24 Jul 2024 13:46:46 -0400
In-Reply-To: <ZoxVa55MIbAz-WnM@google.com>
References: <20240517173926.965351-1-seanjc@google.com>
	 <20240517173926.965351-23-seanjc@google.com>
	 <43ef06aca700528d956c8f51101715df86f32a91.camel@redhat.com>
	 <ZoxVa55MIbAz-WnM@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Mon, 2024-07-08 at 14:08 -0700, Sean Christopherson wrote:
> On Thu, Jul 04, 2024, Maxim Levitsky wrote:
> > On Fri, 2024-05-17 at 10:38 -0700, Sean Christopherson wrote:
> > > Add a macro to precisely handle CPUID features that AMD duplicated from
> > > CPUID.0x1.EDX into CPUID.0x8000_0001.EDX.  This will allow adding an
> > > assert that all features passed to kvm_cpu_cap_init() match the word being
> > > processed, e.g. to prevent passing a feature from CPUID 0x7 to CPUID 0x1.
> > > 
> > > Because the kernel simply reuses the X86_FEATURE_* definitions from
> > > CPUID.0x1.EDX, KVM's use of the aliased features would result in false
> > > positives from such an assert.
> > > 
> > > No functional change intended.
> > > 
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > ---
> > >  arch/x86/kvm/cpuid.c | 24 +++++++++++++++++-------
> > >  1 file changed, 17 insertions(+), 7 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > > index 5e3b97d06374..f2bd2f5c4ea3 100644
> > > --- a/arch/x86/kvm/cpuid.c
> > > +++ b/arch/x86/kvm/cpuid.c
> > > @@ -88,6 +88,16 @@ u32 xstate_required_size(u64 xstate_bv, bool compacted)
> > >  	F(name);						\
> > >  })
> > >  
> > > +/*
> > > + * Aliased Features - For features in 0x8000_0001.EDX that are duplicates of
> > > + * identical 0x1.EDX features, and thus are aliased from 0x1 to 0x8000_0001.
> > > + */
> > > +#define AF(name)								\
> > > +({										\
> > > +	BUILD_BUG_ON(__feature_leaf(X86_FEATURE_##name) != CPUID_1_EDX);	\
> > > +	feature_bit(name);							\
> > > +})
> > > +
> > >  /*
> > >   * Magic value used by KVM when querying userspace-provided CPUID entries and
> > >   * doesn't care about the CPIUD index because the index of the function in
> > > @@ -758,13 +768,13 @@ void kvm_set_cpu_caps(void)
> > >  	);
> > >  
> > >  	kvm_cpu_cap_init(CPUID_8000_0001_EDX,
> > > -		F(FPU) | F(VME) | F(DE) | F(PSE) |
> > > -		F(TSC) | F(MSR) | F(PAE) | F(MCE) |
> > > -		F(CX8) | F(APIC) | 0 /* Reserved */ | F(SYSCALL) |
> > > -		F(MTRR) | F(PGE) | F(MCA) | F(CMOV) |
> > > -		F(PAT) | F(PSE36) | 0 /* Reserved */ |
> > > -		F(NX) | 0 /* Reserved */ | F(MMXEXT) | F(MMX) |
> > > -		F(FXSR) | F(FXSR_OPT) | X86_64_F(GBPAGES) | F(RDTSCP) |
> > > +		AF(FPU) | AF(VME) | AF(DE) | AF(PSE) |
> > > +		AF(TSC) | AF(MSR) | AF(PAE) | AF(MCE) |
> > > +		AF(CX8) | AF(APIC) | 0 /* Reserved */ | F(SYSCALL) |
> > > +		AF(MTRR) | AF(PGE) | AF(MCA) | AF(CMOV) |
> > > +		AF(PAT) | AF(PSE36) | 0 /* Reserved */ |
> > > +		F(NX) | 0 /* Reserved */ | F(MMXEXT) | AF(MMX) |
> > > +		AF(FXSR) | F(FXSR_OPT) | X86_64_F(GBPAGES) | F(RDTSCP) |
> > >  		0 /* Reserved */ | X86_64_F(LM) | F(3DNOWEXT) | F(3DNOW)
> > >  	);
> > >  
> > 
> > Hi,
> > 
> > What if we defined the aliased features instead.
> > Something like this:
> > 
> > #define __X86_FEATURE_8000_0001_ALIAS(feature) \
> > 	(feature + (CPUID_8000_0001_EDX - CPUID_1_EDX) * 32)
> > 
> > #define KVM_X86_FEATURE_FPU_ALIAS	__X86_FEATURE_8000_0001_ALIAS(KVM_X86_FEATURE_FPU)
> > #define KVM_X86_FEATURE_VME_ALIAS	__X86_FEATURE_8000_0001_ALIAS(KVM_X86_FEATURE_VME)
> > 
> > And then just use for example the 'F(FPU_ALIAS)' in the CPUID_8000_0001_EDX
> 
> At first glance, I really liked this idea, but after working through the
> ramifications, I think I prefer "converting" the flag when passing it to
> kvm_cpu_cap_init().  In-place conversion makes it all but impossible for KVM to
> check the alias, e.g. via guest_cpu_cap_has(), especially since the AF() macro
> doesn't set the bits in kvm_known_cpu_caps (if/when a non-hacky validation of
> usage becomes reality).

Could you elaborate on this as well?

My suggestion was that we can just treat aliases as completely independent and dummy features,
say KVM_X86_FEATURE_FPU_ALIAS, and pass them as is to the guest, which means that
if an alias is present in host cpuid, it appears in kvm caps, and thus qemu can then
set it in guest cpuid.

I don't think that we need any special treatment for them if you look at it this way.
If you don't agree, can you give me an example?


> 
> Side topic, if it's not already documented somewhere else, kvm/x86/cpuid.rst
> should call out that KVM only honors the features in CPUID.0x1, i.e. that setting
> aliased bits in CPUID.0x8000_0001 is supported if and only if the bit(s) is also
> set in CPUID.0x1.

To be honest if KVM enforces this, such enforcement can be removed IMHO:

KVM already allows all kinds of totally invalid
CPUIDs to be set by the guest, for example a CPUID in which AVX3 is set, and AVX and/or XSAVE is not set.

So having a guest given cpuid where aliased feature is set, and regular feature is not set,
should not pose any problem to KVM itself, as long as KVM itself uses only the non-aliased
features as the ground truth.

Since such configuration is an error anyway, allowing it won't break any existing users IMHO.

What do you think about this? If you don't agree, can you provide an example of a breakage?


Best regards,
	Maxim Levitsky

> 



