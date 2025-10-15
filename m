Return-Path: <kvm+bounces-60097-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 23DDBBE03F6
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 20:49:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 61EAB1A23251
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 18:49:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC26E301491;
	Wed, 15 Oct 2025 18:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qeelexNl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E4D29BDAD
	for <kvm@vger.kernel.org>; Wed, 15 Oct 2025 18:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760554137; cv=none; b=GkqsVewUcKq1DcgzGg6i0I1zUHZhNlQiXiCYmbNYRfrXNwcmLY4Pt32B8Z0dHrlZs7sR00MAiWATofdPGbofmgBNqAPbuRwWKyV6qhDcWIbGHH+FfEoKuFEGpBFYm0xpR5dvr2OVd04kpMHIvI1u+HU/RlPnM4fYr5aJyYs0J2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760554137; c=relaxed/simple;
	bh=HqqF4x0s/r1hw3Xsgl35/OvKCY5LGibQ5keQMlJM4gM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=k5KY3W6nAareoHC18biIVuenUMvCUVlrhdSBRwCPZVKhefHPtDppVrU91Fy2nGL6NfGBlit2MDWDgvZ++oY0Ymz55jKTLWWuwgTw5oAE8Qm78wTluAJKc562EfDcdYcLC7l2eC3dkBWfLrOR/+h2KvPgyAmR15iuj/Y6B7yoR0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qeelexNl; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32ec67fcb88so9862167a91.3
        for <kvm@vger.kernel.org>; Wed, 15 Oct 2025 11:48:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760554135; x=1761158935; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3naOg0AXa4lxy2J7qWFZUYdZmmuSUah42Rbajn2HebA=;
        b=qeelexNlPOc96u61+Eb0yeGw64AFtOnOiRhuzlOc/ocO4dSiiqa36JnUERwy2ldzEv
         R2zg8Jzc7m89B+ncngJBub+wRAY3ezryIBdDtGfVTH3PjPzLf500oOtQ2YWvm8aE0VRN
         10uvm6TlE64Sr2lPle/uQkQQH16V8/C0QRu83Wb4Jd8dBs9arIzMC+2LjYwvyeGVIwRR
         HLFOJaq65iKanWMC/Y5s1HA9hPpmKRQqZPOA2U18vcT+zKyJbRuxXi0nbl11+2HliYRH
         x7J8wWBXH97UVgZZQG4ic9TBnDm1zLQj0MAEm55ay4/QxX512LXzE1RlsK4VjbfMIyRI
         5EiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760554135; x=1761158935;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3naOg0AXa4lxy2J7qWFZUYdZmmuSUah42Rbajn2HebA=;
        b=j3scklZBBtvIJBV4yZ4hwzGluwP9WbuX5VVHvDTy5jxNx9J0piuh8OghyslyFK/fPz
         wu/bS933S5SiWDVTTDgeRE6f3uaVLVjE9XUbUh9o2UShxeuR03sUsDNXAdsqvz/+1zMx
         y1qxzT/IZP02H7wS4+Kv4WOyLoGj/3BEbF/FGMEevZwmPtcsHm/8lKqsGMcYARkCwQd+
         Lz4byXitoixS/Rxti/AqAvyyjPQbbwQfFjE6cIq8N9mugLDTBYnp3KIwjkGHYB9zXE2q
         q3zEDrLKsD8xp2ZjWjB+NFcaddxJRs5eEieon3NaPRPhGre6CVJiM5esQpKJchU72g4w
         3/PA==
X-Forwarded-Encrypted: i=1; AJvYcCXAOC1lGO1+swm7yvH1eQgd2wCl8G5yqh5vwKkWLpAkD8F3joEJOOgt6/EhDYYtGhWxgok=@vger.kernel.org
X-Gm-Message-State: AOJu0YzZcQzVC4MkKA1tA59nFRbyjZt/9blhQoOoyfUq2DpiYGjmUTej
	oYAlTJpyLlVodOm7Kbpbk8xrR3DqVMoHQh4/Y0I0U1V9UmTejlKtmux1mXU4vtLe4O8HHxHUkyU
	6ME73Fw==
X-Google-Smtp-Source: AGHT+IE9eJmZgE8/vrWWkRhltj63ksxMU8MKwID4HHHoGFacVC2zof2bk9aQHK5Js4MPCgK0DcLQje9LyvY=
X-Received: from pjpx13.prod.google.com ([2002:a17:90a:a38d:b0:33b:51fe:1a93])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3909:b0:336:bfcf:c50b
 with SMTP id 98e67ed59e1d1-33b513865a2mr39206696a91.20.1760554134578; Wed, 15
 Oct 2025 11:48:54 -0700 (PDT)
Date: Wed, 15 Oct 2025 11:48:52 -0700
In-Reply-To: <0276af52-c697-46c3-9db8-9284adb6beee@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250806195706.1650976-1-seanjc@google.com> <20250806195706.1650976-33-seanjc@google.com>
 <f896966e-8925-4b4f-8f0d-f1ae8aa197f7@amd.com> <aN1vfykNs8Dmv_g0@google.com> <0276af52-c697-46c3-9db8-9284adb6beee@linux.intel.com>
Message-ID: <aO_slNn8X1A84sI-@google.com>
Subject: Re: [PATCH v5 32/44] KVM: x86/pmu: Disable interception of select PMU
 MSRs for mediated vPMUs
From: Sean Christopherson <seanjc@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Sandipan Das <sandidas@amd.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, Xin Li <xin@zytor.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Yongwei Ma <yongwei.ma@intel.com>, 
	Mingwei Zhang <mizhang@google.com>, Xiong Zhang <xiong.y.zhang@linux.intel.com>, 
	Sandipan Das <sandipan.das@amd.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 09, 2025, Dapeng Mi wrote:
>=20
> On 10/2/2025 2:14 AM, Sean Christopherson wrote:
> > On Fri, Sep 26, 2025, Sandipan Das wrote:
> >> On 8/7/2025 1:26 AM, Sean Christopherson wrote:
> >>> +	return kvm_need_perf_global_ctrl_intercept(vcpu) ||
> >>>  	       pmu->counter_bitmask[KVM_PMC_GP] !=3D (BIT_ULL(kvm_host_pmu.=
bit_width_gp) - 1) ||
> >>>  	       pmu->counter_bitmask[KVM_PMC_FIXED] !=3D (BIT_ULL(kvm_host_p=
mu.bit_width_fixed) - 1);
> >>>  }
> >> There is a case for AMD processors where the global MSRs are absent in=
 the guest
> >> but the guest still uses the same number of counters as what is advert=
ised by the
> >> host capabilities. So RDPMC interception is not necessary for all case=
s where
> >> global control is unavailable.o
> > Hmm, I think Intel would be the same?  Ah, no, because the host will ha=
ve fixed
> > counters, but the guest will not.  However, that's not directly related=
 to
> > kvm_pmu_has_perf_global_ctrl(), so I think this would be correct?
> >
> > diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> > index 4414d070c4f9..4c5b2712ee4c 100644
> > --- a/arch/x86/kvm/pmu.c
> > +++ b/arch/x86/kvm/pmu.c
> > @@ -744,16 +744,13 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned=
 idx, u64 *data)
> >         return 0;
> >  }
> > =20
> > -bool kvm_need_perf_global_ctrl_intercept(struct kvm_vcpu *vcpu)
> > +static bool kvm_need_pmc_intercept(struct kvm_vcpu *vcpu)
>=20
> The function name kvm_need_pmc_intercept() seems a little bit misleading
> and make users think this function is used to check if a certain PMC is
> intercepted. Maybe we can rename the function to=C2=A0kvm_need_global_int=
ercept().

Yeah, I don't love kvm_need_pmc_intercept() either.  But kvm_need_global_in=
tercept()
feels too close to kvm_need_perf_global_ctrl_intercept().

Maybe something like kvm_need_any_pmc_intercept()?

