Return-Path: <kvm+bounces-4124-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E7FF280E168
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 03:26:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 16D301C21708
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 02:26:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA8A21FC5;
	Tue, 12 Dec 2023 02:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eRsxF40+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E009BF
	for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 18:26:49 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id 4fb4d7f45d1cf-54f4a933ddcso6837a12.0
        for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 18:26:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702348007; x=1702952807; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EzA0bmnLNN5+Qodgbz5WO7F/i6bv5hMfoc1y8dMESAw=;
        b=eRsxF40+lf/8cBAh7rTtXQtsCYfF1n3WtqAx93/k7XVEeFFwN7rjmh6pSo1HCcGdrp
         Jf6bdMO54rKSieeO33K15Ogb+bu8irXtqLV7qzxUMaXdtCfsNfVN9FbJ0pSbCTdDP7mW
         sTbgltOdxFiz/M++/XL8mwANBESNJwc9MKQ2WQQV0IYzl9i3zA51j9PsI0ZYcNfs8dG3
         lh9MBew38+BffiFYOUiqLtELq1FIanYJ7YqPseHjAcbsrP9TVgMKIdl7C1/D744mF5WP
         Zoe7SX+iRf66xmvrJhWwj9sv35wvhTt7zPioxAquQjJMuuPsF0YiA+bmcXxx1TnPrAa1
         YFfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702348007; x=1702952807;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EzA0bmnLNN5+Qodgbz5WO7F/i6bv5hMfoc1y8dMESAw=;
        b=pn3O3iUqyJQOzI9rgFLkh33N5TMC3AzR+VTG2t9q0/+B0U3+D2F3nutDOk+2qugdCt
         n6bx6Drp7su2KGFeF9meI4Ze9E57/D8ibVAY7uGjmb3FnQJbtJtD8AbfKZuSk9C44pJp
         DSiOr2XunENC9mCTWAZvfu+DOFexz0axi1wCBVpHLNwOk8AwZd0Vw/73wUU6sKrpd2AK
         NMUe7i5SEZ7xlxguyyK0IVSEHdGVluCc4asNiGcVR3+Q+D0ZxdZQ8JH3XnTJuELLivhf
         4WWm5ofktt+rQ/NWoFmTjyYJ+UkjGFSolYnzBLyONb3i7pndrXbKyXAs/WmCmJXvIiGD
         GHxA==
X-Gm-Message-State: AOJu0YxPSfMv2FKzsy/ab1mLWcpcOcN2CU2HU06/97yjI5R1DVPcA2/g
	jzv76p7SM+Tt54KYzeeLwBrfDyYH5XRK6ZEipXiEFQ==
X-Google-Smtp-Source: AGHT+IF8Kl076PEmz1lvyIqAEMULaFGkAGpnnn4jJ9tm0WMWTidEnn4AhSzNS5zIJuA8HnyiySjoidvlG5GciVtcof8=
X-Received: by 2002:a50:d643:0:b0:54b:321:ef1a with SMTP id
 c3-20020a50d643000000b0054b0321ef1amr299004edj.6.1702348007339; Mon, 11 Dec
 2023 18:26:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231202000417.922113-1-seanjc@google.com> <20231202000417.922113-11-seanjc@google.com>
 <b45efe2f-1b99-4596-b33f-d491726ed34d@linux.intel.com> <CALMp9eSp_9J9t3ByfHfnirXf=uxvWVWVtLWO5KPoO0nDFJ-gtw@mail.gmail.com>
 <ZXeenJ6DAugGCaSN@google.com>
In-Reply-To: <ZXeenJ6DAugGCaSN@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Mon, 11 Dec 2023 18:26:32 -0800
Message-ID: <CALMp9eSZdPyZChd1PwFy+PqFAM2Eg4zQS97LG1s2DOov5e_mUQ@mail.gmail.com>
Subject: Re: [PATCH v9 10/28] KVM: x86/pmu: Explicitly check for RDPMC of
 unsupported Intel PMC types
To: Sean Christopherson <seanjc@google.com>
Cc: Dapeng Mi <dapeng1.mi@linux.intel.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>, 
	Jinrong Liang <cloudliang@tencent.com>, Aaron Lewis <aaronlewis@google.com>, 
	Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 11, 2023 at 3:43=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Mon, Dec 11, 2023, Jim Mattson wrote:
> > On Sun, Dec 10, 2023 at 10:26=E2=80=AFPM Mi, Dapeng <dapeng1.mi@linux.i=
ntel.com> wrote:
> > >
> > >
> > > On 12/2/2023 8:03 AM, Sean Christopherson wrote:
> > > > Explicitly check for attempts to read unsupported PMC types instead=
 of
> > > > letting the bounds check fail.  Functionally, letting the check fai=
l is
> > > > ok, but it's unnecessarily subtle and does a poor job of documentin=
g the
> > > > architectural behavior that KVM is emulating.
> > > >
> > > > Opportunistically add macros for the type vs. index to further docu=
ment
> > > > what is going on.
> > > >
> > > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > > ---
> > > >   arch/x86/kvm/vmx/pmu_intel.c | 11 +++++++++--
> > > >   1 file changed, 9 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_in=
tel.c
> > > > index 644de27bd48a..bd4f4bdf5419 100644
> > > > --- a/arch/x86/kvm/vmx/pmu_intel.c
> > > > +++ b/arch/x86/kvm/vmx/pmu_intel.c
> > > > @@ -23,6 +23,9 @@
> > > >   /* Perf's "BASE" is wildly misleading, this is a single-bit flag,=
 not a base. */
> > > >   #define INTEL_RDPMC_FIXED   INTEL_PMC_FIXED_RDPMC_BASE
> > > >
> > > > +#define INTEL_RDPMC_TYPE_MASK        GENMASK(31, 16)
> > > > +#define INTEL_RDPMC_INDEX_MASK       GENMASK(15, 0)
> > > > +
> > > >   #define MSR_PMC_FULL_WIDTH_BIT      (MSR_IA32_PMC0 - MSR_IA32_PER=
FCTR0)
> > > >
> > > >   static void reprogram_fixed_counters(struct kvm_pmu *pmu, u64 dat=
a)
> > > > @@ -82,9 +85,13 @@ static struct kvm_pmc *intel_rdpmc_ecx_to_pmc(st=
ruct kvm_vcpu *vcpu,
> > > >       /*
> > > >        * Fixed PMCs are supported on all architectural PMUs.  Note,=
 KVM only
> > > >        * emulates fixed PMCs for PMU v2+, but the flag itself is st=
ill valid,
> > > > -      * i.e. let RDPMC fail due to accessing a non-existent counte=
r.
> > > > +      * i.e. let RDPMC fail due to accessing a non-existent counte=
r.  Reject
> > > > +      * attempts to read all other types, which are unknown/unsupp=
orted.
> > > >        */
> > > > -     idx &=3D ~INTEL_RDPMC_FIXED;
> > > > +     if (idx & INTEL_RDPMC_TYPE_MASK & ~INTEL_RDPMC_FIXED)
> >
> > You know how I hate to be pedantic (ROFL), but the SDM only says:
> >
> > If the processor does support architectural performance monitoring
> > (CPUID.0AH:EAX[7:0] =E2=89=A0 0), ECX[31:16] specifies type of PMC whil=
e
> > ECX[15:0] specifies the index of the PMC to be read within that type.
> >
> > It does not say that the types are bitwise-exclusive.
> >
> > Yes, the types defined thus far are bitwise-exclusive, but who knows
> > what tomorrow may bring?
>
> The goal isn't to make the types exclusive, the goal is to reject types t=
hat
> aren't supported by KVM.  The above accomplishes that, no?  I don't see h=
ow KVM
> could get a false negative or false positive, the above allows exactly FI=
XED and
> "none" types.  Or are you objecting to the comment?

You're right. The code is fine. My brain is not.

But what's wrong with something like:

type =3D idx & INTEL_RDPMC_TYPE_MASK;
if (type !=3D INTEL_RDPMC_GP && type !=3D INTEL_RDPMC_FIXED) ...

This makes it more clear what kvm accepts and what it doesn't accept,
regardless of the actual values of the macros.

