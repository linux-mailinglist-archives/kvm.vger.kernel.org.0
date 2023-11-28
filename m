Return-Path: <kvm+bounces-2543-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B9FA37FAF7F
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 02:24:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DDBD81C20D87
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 01:24:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E64F0186B;
	Tue, 28 Nov 2023 01:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OzMAYvxf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C8B3137
	for <kvm@vger.kernel.org>; Mon, 27 Nov 2023 17:24:18 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1cfb5471cd4so25965885ad.3
        for <kvm@vger.kernel.org>; Mon, 27 Nov 2023 17:24:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701134658; x=1701739458; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ccfuuY9Lz/COE9I6k14m7srCwypVDjwLLZgJ5DupFSA=;
        b=OzMAYvxfy4t5tQroSUPHGiip+9tnKC82tO4jUuxNfDoJb27HQap7nRF0hVH7Rzr3Qq
         zLSXvuGcrqr5X7UWPKosBY9NwenTXWMAb2imAq75bhsy+NsxcYRS4JJycLybcpOsuiiZ
         tnZAKJU9QvpAh6dI95BFQeyb6foIIxkPvsOekspPdn5keGdS3FTDKgkGPpAsMziiw0FT
         xA5tsvPwGKnjdZF7uh+WGj6DCRAJ2tphFkKcT1OxjplqtS0/iI729MYN9Nybk4uEaEAO
         WVKLTylI7to+is7qDsB3J/crim961eUFnAYzjSrOutNQbMAZ0F+N3DEuYiqCoxBQvASr
         d1Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701134658; x=1701739458;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ccfuuY9Lz/COE9I6k14m7srCwypVDjwLLZgJ5DupFSA=;
        b=DBk0HI8nDswEJ2+SM32gKgnVtTzd0/xx06dXwed0rOr4jWghO5kEcPbxXlaASzLOIm
         bf2H/728dO3HtOBHCEIfUMOWn0BdnHOpm1v1WV82dd23IGycUcbxxU+sYlnnFRYm5eKd
         K2azp8Y4iJ8j6hZ7H8vfuUk00LAC2VhpmNTOIhbSYsELDT7O36Q3IF6Zv6u/6DXwIrMA
         GW6ei8g0aeUYgIDJ4WVPIw/3VOHLyqrSmpY/KKlyQxY+k0q5uhikOJdGLMhxQV6tuVAx
         p8yYvSmo6HLTCqAda9EXw+7hrnLCS9kf32xn1io9vM0r3n5HVeK8ZTFbgYv9fpcrcZNK
         0uhA==
X-Gm-Message-State: AOJu0Yyp2/PGPh+GJafN/hvhAToIHERDMDgxz1k185Y5ruqxTvY75piR
	DRPn6b3DGcacNaNkj20LfhUoSBszBAA=
X-Google-Smtp-Source: AGHT+IGgTsSqDSRzspJot6Wq5LGYVHgmFwA+F770d+kNJgqhCjlA/9XgQZuTMJuYkXuMnbM/7RL4uRFRX9U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:8341:b0:1cf:de4e:f8de with SMTP id
 z1-20020a170902834100b001cfde4ef8demr513394pln.12.1701134658042; Mon, 27 Nov
 2023 17:24:18 -0800 (PST)
Date: Mon, 27 Nov 2023 17:24:16 -0800
In-Reply-To: <c38adc1dc0a7df1c902b8ffbc82076d6da527e2a.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231110235528.1561679-1-seanjc@google.com> <20231110235528.1561679-3-seanjc@google.com>
 <c38adc1dc0a7df1c902b8ffbc82076d6da527e2a.camel@redhat.com>
Message-ID: <ZWVBQPjwG7gOcA66@google.com>
Subject: Re: [PATCH 2/9] KVM: x86: Replace guts of "goverened" features with
 comprehensive cpu_caps
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Sun, Nov 19, 2023, Maxim Levitsky wrote:
> On Fri, 2023-11-10 at 15:55 -0800, Sean Christopherson wrote:
> > @@ -840,23 +856,15 @@ struct kvm_vcpu_arch {
> >  	struct kvm_hypervisor_cpuid kvm_cpuid;
> >  
> >  	/*
> > -	 * FIXME: Drop this macro and use KVM_NR_GOVERNED_FEATURES directly
> > -	 * when "struct kvm_vcpu_arch" is no longer defined in an
> > -	 * arch/x86/include/asm header.  The max is mostly arbitrary, i.e.
> > -	 * can be increased as necessary.
> > +	 * Track the effective guest capabilities, i.e. the features the vCPU
> > +	 * is allowed to use.  Typically, but not always, features can be used
> > +	 * by the guest if and only if both KVM and userspace want to expose
> > +	 * the feature to the guest.  A common exception is for virtualization
> > +	 * holes, i.e. when KVM can't prevent the guest from using a feature,
> > +	 * in which case the vCPU "has" the feature regardless of what KVM or
> > +	 * userspace desires.
> >  	 */
> > -#define KVM_MAX_NR_GOVERNED_FEATURES BITS_PER_LONG
> > -
> > -	/*
> > -	 * Track whether or not the guest is allowed to use features that are
> > -	 * governed by KVM, where "governed" means KVM needs to manage state
> > -	 * and/or explicitly enable the feature in hardware.  Typically, but
> > -	 * not always, governed features can be used by the guest if and only
> > -	 * if both KVM and userspace want to expose the feature to the guest.
> > -	 */
> > -	struct {
> > -		DECLARE_BITMAP(enabled, KVM_MAX_NR_GOVERNED_FEATURES);
> > -	} governed_features;
> > +	u32 cpu_caps[NR_KVM_CPU_CAPS];
> 
> Won't it be better to call this 'effective_cpu_caps' or something like that,
> to put emphasis on the fact that these are not exactly the cpu caps that
> userspace wants.  Although probably any name will still be somewhat
> confusing.

I'd prefer to keep 'cpu_caps' so that the name is aligned with the APIs, e.g. I
think having "effective" in the field but not e.g. guest_cpu_cap_set() would be
even more confusing.

Also, looking at this again, "effective" isn't strictly correct (my comment about
is also wrong), as virtualization holes that neither userspace nor KVM cares about
aren't reflected in CPUID caps.  E.g. things like MOVBE and POPCNT have a CPUID
flag but no way to prevent the guest from using them.

So a truly accurate name would have to be something like
effective_cpu_caps_that_kvm_cares_about.  :-)

> >  	u64 reserved_gpa_bits;
> >  	int maxphyaddr;
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index 4f464187b063..4bf3c2d4dc7c 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -327,9 +327,7 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> >  	struct kvm_cpuid_entry2 *best;
> >  	bool allow_gbpages;
> >  
> > -	BUILD_BUG_ON(KVM_NR_GOVERNED_FEATURES > KVM_MAX_NR_GOVERNED_FEATURES);
> > -	bitmap_zero(vcpu->arch.governed_features.enabled,
> > -		    KVM_MAX_NR_GOVERNED_FEATURES);
> > +	memset(vcpu->arch.cpu_caps, 0, sizeof(vcpu->arch.cpu_caps));
> >  
> >  	/*
> >  	 * If TDP is enabled, let the guest use GBPAGES if they're supported in
> > diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> > index 245416ffa34c..9f18c4395b71 100644
> > --- a/arch/x86/kvm/cpuid.h
> > +++ b/arch/x86/kvm/cpuid.h
> > @@ -255,12 +255,12 @@ static __always_inline bool kvm_is_governed_feature(unsigned int x86_feature)
> >  }
> >  
> >  static __always_inline void guest_cpu_cap_set(struct kvm_vcpu *vcpu,
> > -						     unsigned int x86_feature)
> > +					      unsigned int x86_feature)
> >  {
> > -	BUILD_BUG_ON(!kvm_is_governed_feature(x86_feature));
> > +	unsigned int x86_leaf = __feature_leaf(x86_feature);
> >  
> > -	__set_bit(kvm_governed_feature_index(x86_feature),
> > -		  vcpu->arch.governed_features.enabled);
> > +	reverse_cpuid_check(x86_leaf);
> > +	vcpu->arch.cpu_caps[x86_leaf] |= __feature_bit(x86_feature);
> >  }
> >  
> >  static __always_inline void guest_cpu_cap_check_and_set(struct kvm_vcpu *vcpu,
> > @@ -273,10 +273,10 @@ static __always_inline void guest_cpu_cap_check_and_set(struct kvm_vcpu *vcpu,
> >  static __always_inline bool guest_cpu_cap_has(struct kvm_vcpu *vcpu,
> >  					      unsigned int x86_feature)
> >  {
> > -	BUILD_BUG_ON(!kvm_is_governed_feature(x86_feature));
> > +	unsigned int x86_leaf = __feature_leaf(x86_feature);
> >  
> > -	return test_bit(kvm_governed_feature_index(x86_feature),
> > -			vcpu->arch.governed_features.enabled);
> > +	reverse_cpuid_check(x86_leaf);
> > +	return vcpu->arch.cpu_caps[x86_leaf] & __feature_bit(x86_feature);
> >  }
> 
> It might make sense to think about extracting the common code between
> kvm_cpu_cap* and guest_cpu_cap*.
> 
> The whole notion of reverse cpuid, KVM only leaves, and other nice things
> that it has is already very confusing, but as I understand there is
> no better way of doing it.
> But there must be a way to avoid at least duplicating this logic.

Yeah, that thought crossed my mind too, but de-duplicating the interesting bits
would require macros, which I think would be a net negative for this code.  I
could definitely be convinced otherwise though, I do love me some macros :-)

Something easy I can, should, and will do regardless is to move reverse_cpuid_check()
into __feature_leaf().  It's already in __feature_bit(), and that would cut down
the copy+paste at least a little bit even if we do/don't use macros.

> Also speaking of this logic, it would be nice to document it.
> E.g for 'kvm_only_cpuid_leafs' it would be nice to have an explanation
> for each entry on why it is needed.

As in, which bits KVM cares about?  That's guaranteed to become stale, and the
high level answer is always "because KVM needs it, but the kernel does not".  The
actual bits are kinda sorta documented by KVM_X86_FEATURE() usage, and any
conflicts with the kernel's cpufeatures.h should result in a build error due to
KVM trying to redefined a macro.

> Just curious: I wonder why Intel called them leaves?
> CPUID leaves are just table entries, I don't see any tree there.

LOL, I suppose a tree without branches can still have leaves?
 
> Finally isn't plural of "leaf" is "leaves"?

Heh, yes, "leaves" is the more standar plural form of "leaf".  And looking at the
SDM, "leafs" is used mostly for GETSEC and ENCL{S,U} "leafs".  I spent a lot of
my formative x86 years doing SMX stuff, and then way to much time on SGX, so I
guess "leafs" just stuck with me.

