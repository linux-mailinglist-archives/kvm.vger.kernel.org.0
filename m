Return-Path: <kvm+bounces-26347-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0ED0097442F
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 22:41:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 903951F27243
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 20:41:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 046861AAE08;
	Tue, 10 Sep 2024 20:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZLD+uxaR"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9353B1F951
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 20:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726000895; cv=none; b=EBZiCU7PedYnQ2N3Pf2ZT9p01e288kwTHVfucPZqB6x1FkJdGjA2FU6eHO3BodNYWKl0xU+TnWlxsl1xQ8wRt9AV+Akp2/1zXJVZZPujjZB/PZFS5ix39T90ZJFafZLNSCYEUkFcSq4NilG2hQwDLR7eCK1LXOsOECXHBsP7pDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726000895; c=relaxed/simple;
	bh=2sp5Ceevd3RsJh1X8w4Eu6e3eaSOzRRQf0NX0F2qFUg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=X046z9jpuwXBdXijjIjk3wEDT+Y1sfDfFqqBAiBpAmAUCvfge4xX3OtcmOFcDoN8Z50h8jhhoXC4hzymLSh/zZqJgPjfps/auiTuxoarqHU0qmPlCTZU0WQz77Jzs6+vprr/UeOK1P2V/XrtvCW1c4IN+Q8cosVhR0s8O9heAu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZLD+uxaR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726000892;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Dc63thatwjdxjZmwHcaT2+8eX/cZ2kUZYb9K2YMC2R8=;
	b=ZLD+uxaRrjO/S52ymu7E0gMvvdqXpGiqJYFLki7+0hmpisxGiUw9G9iRzYj/eTgStervql
	UuJeR1ZQl56MX+2SKL8PmvGFF4oBHrIK5RjLRq5ECVRB2McXpO1Zj3bGlY595g5jV+P8AY
	8az2IKE3Lr+VmCYldmEHRnFRLDOPsTc=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-332-HpIPQBbdNoeLVUXXdhMMHA-1; Tue, 10 Sep 2024 16:41:31 -0400
X-MC-Unique: HpIPQBbdNoeLVUXXdhMMHA-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-6c354323ec2so22996046d6.1
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 13:41:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726000891; x=1726605691;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Dc63thatwjdxjZmwHcaT2+8eX/cZ2kUZYb9K2YMC2R8=;
        b=XqFU/7UfR65OwUaQkt7La9/xcGmfwMB1UnK/yUD36O74yUV86nsdUCfuunYzOSJlYL
         dck764as7h/Wk6kUKqwriFU2Oy5/pn3ksyqhewpxJsAYWseYZJe4H77rhs+OLmkFz7fh
         ZDTNiHiuIKbfJoHZuLaJDKQBWIkVMv+9mVdUG9kNDJM9m88Cl2ZeVG1Qr91/MM8Nv3th
         Ddhw7kkrb1ED8Dr+exl/Kzlr/RQMunVf7xoseWbPVXsvjME25AFyjPSqYn0JK70sw0Yg
         OigUA2opls+Ak1JnJJCcmUHx6pO0hfpKqpzw1yEIe0lSET7UppWdE9ElVQsba85fai4V
         HidQ==
X-Forwarded-Encrypted: i=1; AJvYcCVh6vXp15AgofqHqpPKD6dAYcx7XoldSHrrLws0GMth8T6197/AWXGlF21NwqQmvdI4nTI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyjHL0v47wlew8ji6De3RpnZ6/1Ig6ca3aqoMN5pmj8hN1Tz1e3
	e08qxkWXmY74utrXD8o2Uajx7c3mFjVj+sgKslrJB006VcorWplfhl1bMN/59khaTQ1zNHbATjo
	rAgq+xjpGrGbApFrvF4fnapDUL0TL+Pyx6B/3eGHkPFmc7o4bXA==
X-Received: by 2002:a05:6214:2b9c:b0:6c3:67d5:aa5 with SMTP id 6a1803df08f44-6c55fa5ed83mr10393096d6.33.1726000890942;
        Tue, 10 Sep 2024 13:41:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH4QII0bcX7sfPMmlw1xcWJovs21qBqtWWA704jF7jBu0B//LI886N3Dnc3+C3kclgnrZ/V/w==
X-Received: by 2002:a05:6214:2b9c:b0:6c3:67d5:aa5 with SMTP id 6a1803df08f44-6c55fa5ed83mr10392676d6.33.1726000890452;
        Tue, 10 Sep 2024 13:41:30 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:760d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6c5343294c0sm33505566d6.10.2024.09.10.13.41.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2024 13:41:30 -0700 (PDT)
Message-ID: <96b32724ad1ce9ac88abb209d196b01116536a61.camel@redhat.com>
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
Date: Tue, 10 Sep 2024 16:41:29 -0400
In-Reply-To: <ZrEvCc6yYdT-cHxD@google.com>
References: <20240517173926.965351-1-seanjc@google.com>
	 <20240517173926.965351-27-seanjc@google.com>
	 <2e0f3fb63c810dd924907bccf9256f6f193b02ec.camel@redhat.com>
	 <ZoxooTvO5vIEnS5V@google.com>
	 <2e531204c32c05c96e852748d490424a6f69a018.camel@redhat.com>
	 <ZqQ6DWUou8hvu0qE@google.com>
	 <2d77b69729354b016eb76537523c9e32e7c011c5.camel@redhat.com>
	 <ZrEvCc6yYdT-cHxD@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 2024-08-05 at 12:59 -0700, Sean Christopherson wrote:
> On Mon, Aug 05, 2024, mlevitsk@redhat.com wrote:
> > У пт, 2024-07-26 у 17:06 -0700, Sean Christopherson пише:
> > > > > > And kvm_cpu_cap_init_begin, can set some cap_in_progress variable.
> > > > 
> > > > Ya, but then compile-time asserts become run-time asserts.
> > 
> > Not really, it all can be done with macros, in exactly the same way IMHO,
> > we do have BUILD_BUG_ON after all.
> > 
> > I am not against using macros, I am only against collecting a bitmask
> > while applying various side effects, and then passing the bitmask to
> > the kvm_cpu_cap_init.
> 
> Gah, I wasn't grokking that, obviously.  Sorry for not catching on earlier.
> 
> > > > To provide equivalent functionality, we also would need to pass in extra
> > > > state to begin/end() (as mentioned earlier).
> > 
> > Besides the number of leaf currently initialized, I don't see which other
> > extra state we need.
> > 
> > In fact I can prove that this is possible:
> > 
> > Roughly like this:
> > 
> > #define kvm_cpu_cap_init_begin(leaf)							\
> > do {											\
> >  const u32 __maybe_unused kvm_cpu_cap_init_in_progress = leaf; 				\
> >  u32 kvm_cpu_cap_emulated = 0; 								\
> >  u32 kvm_cpu_cap_synthesized = 0; 							\
> > 	u32 kvm_cpu_cap_regular = 0;
> 
> Maybe "virtualized" instead of "regular"?
> 
> > #define feature_scattered(name) 							\
> >  BUILD_BUG_ON(X86_FEATURE_##name >= MAX_CPU_FEATURES); 					\
> >  KVM_VALIDATE_CPU_CAP_USAGE(name); 							\
> > 											\
> > 	if (boot_cpu_has(X86_FEATURE_##name) 						\
> > 		kvm_cpu_cap_regular |= feature_bit(name);
> > 
> > 
> > #define kvm_cpu_cap_init_end() 								\
> > 	const struct cpuid_reg cpuid = x86_feature_cpuid(leaf * 32);			\
> > 											\
> > 	if (kvm_cpu_cap_init_in_progress < NCAPINTS) 					\
> >  		kvm_cpu_caps[kvm_cpu_cap_init_in_progress] &= kvm_cpu_cap_regular; 	\
> >  	else 										\
> >  		kvm_cpu_caps[kvm_cpu_cap_init_in_progress] = kvm_cpu_cap_regular; 	\
> >  											\
> >  	kvm_cpu_caps[kvm_cpu_cap_init_in_progress] &= (raw_cpuid_get(cpuid) | 		\
> >  	kvm_cpu_cap_synthesized); 							\
> >  	kvm_cpu_caps[kvm_cpu_cap_init_in_progress] |= kvm_cpu_cap_emulated; 		\
> > } while(0);
> > 
> > 
> > And now we have:
> > 
> > kvm_cpu_cap_init_begin(CPUID_12_EAX);
> >  feature_scattered(SGX1);
> >  feature_scattered(SGX2);
> >  feature_scattered(SGX_EDECCSSA);
> > kvm_cpu_cap_init_end();
> 
> I don't love the syntax (mainly the need for a begin()+end()), but I'm a-ok
> getting rid of the @mask param/input.
> 
> What about making kvm_cpu_cap_init() a variadic macro, with the relevant features
> "unpacked" in the context of the macro?  That would avoid the need for a trailing
> macro, and would provide a clear indication of when/where the set of features is
> "initialized".
> 
> The biggest downside I see is that the last entry can't have a trailing comma,
> i.e. adding a new feature would require updating the previous feature too.
> 
> #define kvm_cpu_cap_init(leaf, init_features...)			\
> do {									\
> 	const struct cpuid_reg cpuid = x86_feature_cpuid(leaf * 32);	\
> 	const u32 __maybe_unused kvm_cpu_cap_init_in_progress = leaf;	\
> 	u32 kvm_cpu_cap_virtualized= 0;					\
> 	u32 kvm_cpu_cap_emulated = 0;					\
> 	u32 kvm_cpu_cap_synthesized = 0;				\
> 									\
> 	init_features;							\
> 									\
> 	kvm_cpu_caps[leaf] = kvm_cpu_cap_virtualized;			\
> 	kvm_cpu_caps[leaf] &= (raw_cpuid_get(cpuid) |			\
> 			       kvm_cpu_cap_synthesized);		\
> 	kvm_cpu_caps[leaf] |= kvm_cpu_cap_emulated;			\
> } while (0)
> 
> 	kvm_cpu_cap_init(CPUID_1_ECX,
> 		VIRTUALIZED_F(XMM3),
> 		VIRTUALIZED_F(PCLMULQDQ),
> 		VIRTUALIZED_F(SSSE3),
> 		VIRTUALIZED_F(FMA),
> 		VIRTUALIZED_F(CX16),
> 		VIRTUALIZED_F(PDCM),
> 		VIRTUALIZED_F(PCID),
> 		VIRTUALIZED_F(XMM4_1),
> 		VIRTUALIZED_F(XMM4_2),
> 		EMULATED_F(X2APIC),
> 		VIRTUALIZED_F(MOVBE),
> 		VIRTUALIZED_F(POPCNT),
> 		EMULATED_F(TSC_DEADLINE_TIMER),
> 		VIRTUALIZED_F(AES),
> 		VIRTUALIZED_F(XSAVE),
> 		// DYNAMIC_F(OSXSAVE),
> 		VIRTUALIZED_F(AVX),
> 		VIRTUALIZED_F(F16C),
> 		VIRTUALIZED_F(RDRAND),
> 		EMULATED_F(HYPERVISOR)
> 	);

Hi,

This is no doubt better than using '|'.

I still strongly prefer my version, because I don't really like the fact that _F 
macros have side effects, and yet passed as parameters to the kvm_cpu_cap_init function/macro.

Basically an unwritten rule, which I consider very important and because of which
I raised my concerns over this patch series is that if a function has side effects,
it should not be used as a parameter to another function, instead, it should be 
called explicitly on its own.

If you strongly prefer the variadic macro over my begin/end API, I can live with
that though, it is still better than '|'ing a mask with functions that have side
effects.

Best regards,
	Maxim Levitsky


> 
> 
> Alternatively, we could force a trailing comma by omitting the semicolon after
> init_features, but that looks weird for the the macro itself, and arguably a bit
> weird for the users too.
> 



