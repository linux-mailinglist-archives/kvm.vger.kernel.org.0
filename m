Return-Path: <kvm+bounces-10251-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D076986B011
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 14:13:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5BAC41F277BA
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 13:13:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DE9F14AD3A;
	Wed, 28 Feb 2024 13:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WX78PGCu"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 358453BBEE
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 13:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709126022; cv=none; b=MeQjkvEV+7eGv87K0eQ6F604NC8Eb8Wnox1+ae09OlWqzd4xRWCMzBqWWB6dsYXWZxaf5LyWlfwj58q7QwBVmywzKMHMDXrKTaf3wKLbs/tBWzyZLLR05mrjq+mA7XmWcCF9bfM2RGIKX/56uknU4NTfY9iMapxA3g8/X5FhKrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709126022; c=relaxed/simple;
	bh=QxAH73vFsZy8xBmiuW4xaEhL4RumSMNKoe6Y+H1gQSE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jlJ6aGUjokLIlwMcvG2IEU3ZJbjHetTrWa/xhZkJ8KOIIZa34/nvMUJZvXHh9M1AkAUCNX7lDB4I+PV1WEi1Lmrhmajz2k0Qcvf0/yTqCUiSfVGWejRo/26G4RI439tcr/icYqV/0/dp7BjFAVdEcyI/A4GpINS+CWs91VOWNik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WX78PGCu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709126020;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tKNEybmPHBTkIVCB4kT9DFXVsL5tcw4ENy7Enaez3g0=;
	b=WX78PGCu/QvXZCuklJ2iBR/I3BC9Fv4Le6pOMI0Fz1fG58IetRwLCKS8nlIx4S0Eo3dxtE
	zpIWlrWBhhbqPb2CElWnA1bqHq1y43R7bZ/Qj3VF0HNpCXWMSuoQwr2IeNZF553/5jNzDu
	RNQDckzuFNjJhZlkEzHK1MR2VSU6EfU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-678-3zs9BDdbMcazmnbyY16Ggw-1; Wed, 28 Feb 2024 08:13:38 -0500
X-MC-Unique: 3zs9BDdbMcazmnbyY16Ggw-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-33d51bb9353so2894234f8f.2
        for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 05:13:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709126017; x=1709730817;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tKNEybmPHBTkIVCB4kT9DFXVsL5tcw4ENy7Enaez3g0=;
        b=LPCCnHkGVSLIMdV5THFWtL2U1jIplJE9sTq+HUduy9E8R65it+6M/bb/2XLdxK7XQM
         Ze/Mh8Dy+0PUPEnLKnBZ9YxTFCrM4mhBk3wcgtOpQJ9+3kTWDDlOzG4Lwe2hCG3G/3SL
         zDwuvsqW+sBx2spaECqc43tZAQDVFVvb7fUKCMUmXcF6MAUZ+SmWwH/wQGgt7ZSgN2mi
         D00Rp8Vk4GarpqJJU67BhT3SlzEX90BZERFI9IYO+p25Te1Dos7fGVYyn1XwVaUlvFNL
         y2nW7PK7I7I5Ya0S8tDYtyYm0DjZLPYz/m+IXmBVcQ1Kn8v5kVTtjRU3je/MAM1Yl6D0
         9hXg==
X-Forwarded-Encrypted: i=1; AJvYcCVmJsZdU9+fvqaCeMDf+xES0FuGneWI8GnakuiuZ6jFupFVcYsZdmc9FmMZy+cUfCNkceLzaKtCAPy2ryUPjNxAaHUt
X-Gm-Message-State: AOJu0Yx1U1sXPSwTKLzb+U6IdFfPtwSaEjSMULILC289jdw08HvP0eDh
	2U+EP0i0cgRLPyt4SOBu99b7YWWhsYnVXJ7KsjSnao5lDRp5v3OnIijKWCd6GF1VG41NKUI1fVn
	aMaLXa0uy3nq1DoFOREXE8cRN1/q5l9MNl08P6ZqZUOqTO6bwOcxoK3RFPvfzgH5z3hMddcfB9G
	OFazN3qEaGJ//sGjyjepYsuEZF
X-Received: by 2002:a5d:56cc:0:b0:33d:c3e6:109d with SMTP id m12-20020a5d56cc000000b0033dc3e6109dmr9927210wrw.61.1709126017587;
        Wed, 28 Feb 2024 05:13:37 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFXKghreVkHqVL2PPq89apnL2dK9C6ka/v8xFhCabiGtrxngaSs3ooESvQVP5kXQvsDOnFWubm2ZL/CZqhMRPY=
X-Received: by 2002:a5d:56cc:0:b0:33d:c3e6:109d with SMTP id
 m12-20020a5d56cc000000b0033dc3e6109dmr9927194wrw.61.1709126017255; Wed, 28
 Feb 2024 05:13:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240227232100.478238-1-pbonzini@redhat.com> <20240227232100.478238-15-pbonzini@redhat.com>
 <Zd6UVfhzdMp8z2O2@google.com>
In-Reply-To: <Zd6UVfhzdMp8z2O2@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 28 Feb 2024 14:13:25 +0100
Message-ID: <CABgObfb=5L7p7RDJMtxaGpCVgNfogWuOFCN7W5DBFdP+LAUhFA@mail.gmail.com>
Subject: Re: [PATCH 14/21] KVM: x86/mmu: pass error code back to MMU when
 async pf is ready
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, michael.roth@amd.com, 
	isaku.yamahata@intel.com, thomas.lendacky@amd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 28, 2024 at 3:03=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Tue, Feb 27, 2024, Paolo Bonzini wrote:
> > Right now the error code is not used when an async page fault is comple=
ted.
> > This is not a problem in the current code, but it is untidy.  For prote=
cted
> > VMs we need to check that the page attributes match the current state o=
f the
> > page.  Async page faults can only occur on shared pages (because
> > private pages go through kvm_faultin_pfn_private() instead of
> > __gfn_to_pfn_memslot()), but it is risky to rely on the polarity of
> > PFERR_GUEST_ENC_MASK and the high 32 bits of the error code being zero.
> > So, for clarity and future-proofing of the code, pipe the error code
> > from kvm_arch_setup_async_pf() to kvm_arch_async_page_ready() via the
> > architecture-specific async page fault data.
> >
> > Extracted from a patch by Isaku Yamahata.
> >
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h |  1 +
> >  arch/x86/kvm/mmu/mmu.c          | 14 +++++++-------
> >  2 files changed, 8 insertions(+), 7 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm=
_host.h
> > index a4514c2ef0ec..24e30ca2ca8f 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1839,6 +1839,7 @@ struct kvm_arch_async_pf {
> >       gfn_t gfn;
> >       unsigned long cr3;
> >       bool direct_map;
> > +     u64 error_code;
> >  };
> >
> >  extern u32 __read_mostly kvm_nr_uret_msrs;
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index f58ca6cb789a..c9890e5b6e4c 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -4260,18 +4260,18 @@ static u32 alloc_apf_token(struct kvm_vcpu *vcp=
u)
> >       return (vcpu->arch.apf.id++ << 12) | vcpu->vcpu_id;
> >  }
> >
> > -static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_o=
r_gpa,
> > -                                 gfn_t gfn)
> > +static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu,
> > +                                 struct kvm_page_fault *fault)
> >  {
> >       struct kvm_arch_async_pf arch;
> >
> >       arch.token =3D alloc_apf_token(vcpu);
> > -     arch.gfn =3D gfn;
> > +     arch.gfn =3D fault->gfn;
> >       arch.direct_map =3D vcpu->arch.mmu->root_role.direct;
> >       arch.cr3 =3D kvm_mmu_get_guest_pgd(vcpu, vcpu->arch.mmu);
> >
> > -     return kvm_setup_async_pf(vcpu, cr2_or_gpa,
> > -                               kvm_vcpu_gfn_to_hva(vcpu, gfn), &arch);
> > +     return kvm_setup_async_pf(vcpu, fault->addr,
> > +                               kvm_vcpu_gfn_to_hva(vcpu, fault->gfn), =
&arch);
> >  }
> >
> >  void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async=
_pf *work)
> > @@ -4290,7 +4290,7 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *v=
cpu, struct kvm_async_pf *work)
> >             work->arch.cr3 !=3D kvm_mmu_get_guest_pgd(vcpu, vcpu->arch.=
mmu))
> >               return;
> >
> > -     kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, 0, true, NULL);
> > +     kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, work->arch.error_co=
de, true, NULL);
>
> This is silly.  If we're going to bother plumbing in the error code, then=
 we
> should use it to do sanity checks.  Things have gone off the rails if end=
 up with
> an async #PF on private memory.

Sure, I split this part out not just because it makes sense to do so,
but also because it's not strictly necessary. I'll add the check and
tweak the changelog.

Paolo

>
> >  }
> >
> >  static inline u8 kvm_max_level_for_order(int order)
> > @@ -4395,7 +4395,7 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcp=
u, struct kvm_page_fault *fault
> >                       trace_kvm_async_pf_repeated_fault(fault->addr, fa=
ult->gfn);
> >                       kvm_make_request(KVM_REQ_APF_HALT, vcpu);
> >                       return RET_PF_RETRY;
> > -             } else if (kvm_arch_setup_async_pf(vcpu, fault->addr, fau=
lt->gfn)) {
> > +             } else if (kvm_arch_setup_async_pf(vcpu, fault)) {
> >                       return RET_PF_RETRY;
> >               }
> >       }
> > --
> > 2.39.0
> >
> >
>


