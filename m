Return-Path: <kvm+bounces-4110-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C0D580DD37
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 22:34:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EB16A282632
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 21:34:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDF7954FB4;
	Mon, 11 Dec 2023 21:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vOYCnctu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BFB410F
	for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 13:33:46 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id 4fb4d7f45d1cf-54c77d011acso958a12.1
        for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 13:33:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702330425; x=1702935225; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wX1Wg/mW222hGnVKsBmQT/O39fFEc/bGrsBIuqYGAfk=;
        b=vOYCnctuQc9LLVQrGdohewlBDupxI+Bq/so9cC0p/M3+ompdeyTicvMkwhg3tC8mDK
         KiucCEWOKzslulBnPb73EMu30aIE2HfeR5OeGmEKE3w+TRTWIXPNhjA2sDyN3XpIsPfn
         M3NR3pUhxsM6+VdrYEGwOpAsAVbZMSAxlMKMT8a57MmgzOXgB40wzU0Eu+Du+qsdUGJV
         Av/JwwpNCfBRZQi8dVigjARYAgeWyKbSiIqZY4NIuMnaxrEFQ64oEsm86Io5avsdn3qZ
         1riG43e5QjHCvS668RC7dvjfS6/W/a/QPYqI/l6q5oRBSqE8uuzEZFRzcrPnbUTu9yXO
         TUZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702330425; x=1702935225;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wX1Wg/mW222hGnVKsBmQT/O39fFEc/bGrsBIuqYGAfk=;
        b=uvvZVy002gDhEj42kEV3FnKDjSJJqMiftytVfgpGGKawNIMim+4e0CS8D/bXe/jBDo
         6OGXlLa4ykMaCqDCodFnO5uCVMQlwNByHjvydFIwWvi2GK2w2XH7BWKleW85A2PI241Q
         pz1m8CznRwS5wcHs3lK28s4dOJRE+qS4eKcF/TuIJS/bEWr7Yict6secLxVk+VwsuGbW
         hHxCcZ5GDXljHBVRCcnhRzSq44d9RCuKua4w8QFqhiz000dVa0TPZkhMt5LtjV8upVpg
         kgO5C0D3ZWwSi8NSa4x/WeIY2ls6l9Ifk/6tNKvS4SR4Yx6ZKU0VAu98MN1tITBQDmHT
         lvfQ==
X-Gm-Message-State: AOJu0YzHtWaCEqeGFFEPcbIDgX8c0RFJPRYzMC2dfLmNlAoCOkb/Ti2c
	LlMh8ufcRTjy8qHJxFk19ALav0lheW74zWKRVWn0qg==
X-Google-Smtp-Source: AGHT+IFxUR+AniAakqZJs6LHOZ5HHncY1lSRn0n7ycwr2O3ucSipTIDQ5WPG8MJFSZNwRcrapZec0wEMxglB9kj//s4=
X-Received: by 2002:a50:c35d:0:b0:544:466b:3b20 with SMTP id
 q29-20020a50c35d000000b00544466b3b20mr308625edb.5.1702330424693; Mon, 11 Dec
 2023 13:33:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231202000417.922113-1-seanjc@google.com> <20231202000417.922113-11-seanjc@google.com>
 <b45efe2f-1b99-4596-b33f-d491726ed34d@linux.intel.com>
In-Reply-To: <b45efe2f-1b99-4596-b33f-d491726ed34d@linux.intel.com>
From: Jim Mattson <jmattson@google.com>
Date: Mon, 11 Dec 2023 13:33:29 -0800
Message-ID: <CALMp9eSp_9J9t3ByfHfnirXf=uxvWVWVtLWO5KPoO0nDFJ-gtw@mail.gmail.com>
Subject: Re: [PATCH v9 10/28] KVM: x86/pmu: Explicitly check for RDPMC of
 unsupported Intel PMC types
To: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>, 
	Jinrong Liang <cloudliang@tencent.com>, Aaron Lewis <aaronlewis@google.com>, 
	Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 10, 2023 at 10:26=E2=80=AFPM Mi, Dapeng <dapeng1.mi@linux.intel=
.com> wrote:
>
>
> On 12/2/2023 8:03 AM, Sean Christopherson wrote:
> > Explicitly check for attempts to read unsupported PMC types instead of
> > letting the bounds check fail.  Functionally, letting the check fail is
> > ok, but it's unnecessarily subtle and does a poor job of documenting th=
e
> > architectural behavior that KVM is emulating.
> >
> > Opportunistically add macros for the type vs. index to further document
> > what is going on.
> >
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >   arch/x86/kvm/vmx/pmu_intel.c | 11 +++++++++--
> >   1 file changed, 9 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.=
c
> > index 644de27bd48a..bd4f4bdf5419 100644
> > --- a/arch/x86/kvm/vmx/pmu_intel.c
> > +++ b/arch/x86/kvm/vmx/pmu_intel.c
> > @@ -23,6 +23,9 @@
> >   /* Perf's "BASE" is wildly misleading, this is a single-bit flag, not=
 a base. */
> >   #define INTEL_RDPMC_FIXED   INTEL_PMC_FIXED_RDPMC_BASE
> >
> > +#define INTEL_RDPMC_TYPE_MASK        GENMASK(31, 16)
> > +#define INTEL_RDPMC_INDEX_MASK       GENMASK(15, 0)
> > +
> >   #define MSR_PMC_FULL_WIDTH_BIT      (MSR_IA32_PMC0 - MSR_IA32_PERFCTR=
0)
> >
> >   static void reprogram_fixed_counters(struct kvm_pmu *pmu, u64 data)
> > @@ -82,9 +85,13 @@ static struct kvm_pmc *intel_rdpmc_ecx_to_pmc(struct=
 kvm_vcpu *vcpu,
> >       /*
> >        * Fixed PMCs are supported on all architectural PMUs.  Note, KVM=
 only
> >        * emulates fixed PMCs for PMU v2+, but the flag itself is still =
valid,
> > -      * i.e. let RDPMC fail due to accessing a non-existent counter.
> > +      * i.e. let RDPMC fail due to accessing a non-existent counter.  =
Reject
> > +      * attempts to read all other types, which are unknown/unsupporte=
d.
> >        */
> > -     idx &=3D ~INTEL_RDPMC_FIXED;
> > +     if (idx & INTEL_RDPMC_TYPE_MASK & ~INTEL_RDPMC_FIXED)

You know how I hate to be pedantic (ROFL), but the SDM only says:

If the processor does support architectural performance monitoring
(CPUID.0AH:EAX[7:0] =E2=89=A0 0), ECX[31:16] specifies type of PMC while
ECX[15:0] specifies the index of the PMC to be read within that type.

It does not say that the types are bitwise-exclusive.

Yes, the types defined thus far are bitwise-exclusive, but who knows
what tomorrow may bring?

> > +             return NULL;
> > +
> > +     idx &=3D INTEL_RDPMC_INDEX_MASK;
> >       if (fixed) {
> >               counters =3D pmu->fixed_counters;
> >               num_counters =3D pmu->nr_arch_fixed_counters;
> Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>

