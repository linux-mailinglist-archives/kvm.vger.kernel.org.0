Return-Path: <kvm+bounces-25313-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 863A09636D6
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 02:22:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AAAD41C20D9D
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 00:22:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AABABDDA6;
	Thu, 29 Aug 2024 00:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ktIgWo8O"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B138A95E
	for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 00:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724890911; cv=none; b=XWCEiIDetucAlr/7gYZvrYos4L4wcvhBLA28YjZGw2Tb+a/BRjiBueIiUXGQeyOSuVQdFYErB85lulKkjO9OpkSxn4i2kVo58+r1gCQA3faG9ZeaY204qsCguyBbWOafKDn5uidsNRfe4ZE1Y7y8m8QPghxeS3wmIspDYSss98E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724890911; c=relaxed/simple;
	bh=21S/bCKdu+L1a1e4jucVV4+euyhDyzTves8lE2iLqes=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PmW04lU2EYnpBi0X9pHdfl8wRuxa/ypEA3dxuKH0tdZul4btpAUm2Pj9dTK+cgIR4WSEyALWqR2567eID4DHDxAEaSeMrhtqkFztEDgeZ+zLV9aw9EKIVKRhkgGP1dch920iqYZbB+Q6t6XPwrr7vcbzUBE8tc728fq72EMvgUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ktIgWo8O; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6b71aa9349dso2458227b3.1
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 17:21:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724890909; x=1725495709; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vddRdTxM1kO0IQuszEDwbg9hJhp9r4VJYlqggwuFtVc=;
        b=ktIgWo8OHVsDokwJXmDeNozkNN8kFx6T7dlT9B5yGPeM/eIGX7j+qneRQPkq+7I5xl
         jpCvg4hyqzNccA+1LcrqOrCqy6lP19D+shBJj3bUEoZv8A2cVCu+g8n3SzgBMfT6WWGy
         TjTDS9xsBKech0y6VIpmbrX2fCa0Uj/HyXoMrCfw5VV4Q2qflLiDsduPAPchuWP7To4R
         rd6SdBhgw3SjKRFqc9jV5nwdXXn8zCP3tmvFfNPualvKRNqbdFrQk8rkNRD2gsJY5Bat
         qxn3iu3GPa5aT6aYxnjoXv7m+mNVqQaEGiJYkJ4CIfURmZIRYPPeP/7kbQxPkA4qcFr/
         I6Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724890909; x=1725495709;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vddRdTxM1kO0IQuszEDwbg9hJhp9r4VJYlqggwuFtVc=;
        b=ZZmHObuXDDXgGYcB9qyP9xTr+edJwC8Q6HSyexffxVCA3LXoNe+nG3dHWOHhRiiZSp
         bcN/6MfL4rUKzdodgTnPeGAvvmSQqdCUEw4kA2JX8JtZDSJcb7XH45sFru5xnk+m7IIi
         ztGd3CIEB1shpuz2UKFC5mdDPRq5Wpn5rigg75ZU7foglRQii7P9cR3ZC3ZMcaxImk7S
         2Rowsml1irnR1WmckyKVGS/V/JpOw9jqBjI12u9kHUUDn4pwaH0ek2EeG14iFgAddHBA
         ek3pVTVwj5xo5zIFFEWvbp4pl/wBe68oFS2z6K1Qt7sV5jaV51oxIjOlvUv45dRT9Dm6
         KqtQ==
X-Forwarded-Encrypted: i=1; AJvYcCW/EtSRzvb233GMV1KHiQSRoEewUBpFUCHMoD/ijC7VzTYwlDpcIX/PTKw3+37zr7PshX8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz46xVCWEHtSVZW6PsyQDcqjt3SptEnqxAgUOBZsL057C2NWI+w
	mFgfYo84gUnerEr/+4zr+aXFrhDKAtJtR35tVCYjVJHLWhdAT5/i8If+Cbpiu/WTw7cA7M+Db6Q
	L1A==
X-Google-Smtp-Source: AGHT+IH8ytk5bFF+9wvHnW8hIRHO7Vn+HRX9ilOzI3wC9gZ5IfZaiDC6f6gNM/JWn6CweO3NuzDUQp9gpsg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ab27:0:b0:e03:59e2:e82 with SMTP id
 3f1490d57ef6-e1a5ae0c182mr1342276.10.1724890908928; Wed, 28 Aug 2024 17:21:48
 -0700 (PDT)
Date: Wed, 28 Aug 2024 17:21:47 -0700
In-Reply-To: <CALMp9eQsekeoT_vm-oGTf4mja6UxsVg_WnvneT=M00rox2e+NA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240823185323.2563194-1-jmattson@google.com> <20240823185323.2563194-5-jmattson@google.com>
 <26e72673-350c-a02d-7b77-ebfd42612ae6@amd.com> <Zsj2anWub8v9kwBA@google.com>
 <59449778-ad4e-69c6-d1dc-73dacb538e02@amd.com> <CALMp9eTNX7=siC=DtBOSDLr6Aswzsq0d6UAHQpEdTd2J8xXHuQ@mail.gmail.com>
 <CALMp9eQsekeoT_vm-oGTf4mja6UxsVg_WnvneT=M00rox2e+NA@mail.gmail.com>
Message-ID: <Zs-_G0FGBbo4tyat@google.com>
Subject: Re: [PATCH v3 4/4] KVM: x86: AMD's IBPB is not equivalent to Intel's IBPB
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Sandipan Das <sandipan.das@amd.com>, 
	Kai Huang <kai.huang@intel.com>, x86@kernel.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, Venkatesh Srinivas <venkateshs@chromium.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 23, 2024, Jim Mattson wrote:
> On Fri, Aug 23, 2024 at 3:48=E2=80=AFPM Jim Mattson <jmattson@google.com>=
 wrote:
> >
> > On Fri, Aug 23, 2024 at 3:12=E2=80=AFPM Tom Lendacky <thomas.lendacky@a=
md.com> wrote:
> > >
> > > On 8/23/24 15:51, Sean Christopherson wrote:
> > > > On Fri, Aug 23, 2024, Tom Lendacky wrote:
> > > >> On 8/23/24 13:53, Jim Mattson wrote:
> > > >>> From Intel's documention [1], "CPUID.(EAX=3D07H,ECX=3D0):EDX[26]
> > > >>> enumerates support for indirect branch restricted speculation (IB=
RS)
> > > >>> and the indirect branch predictor barrier (IBPB)." Further, from =
[2],
> > > >>> "Software that executed before the IBPB command cannot control th=
e
> > > >>> predicted targets of indirect branches (4) executed after the com=
mand
> > > >>> on the same logical processor," where footnote 4 reads, "Note tha=
t
> > > >>> indirect branches include near call indirect, near jump indirect =
and
> > > >>> near return instructions. Because it includes near returns, it fo=
llows
> > > >>> that **RSB entries created before an IBPB command cannot control =
the
> > > >>> predicted targets of returns executed after the command on the sa=
me
> > > >>> logical processor.**" [emphasis mine]
> > > >>>
> > > >>> On the other hand, AMD's IBPB "may not prevent return branch
> > > >>> predictions from being specified by pre-IBPB branch targets" [3].
> > > >>>
> > > >>> However, some AMD processors have an "enhanced IBPB" [terminology
> > > >>> mine] which does clear the return address predictor. This feature=
 is
> > > >>> enumerated by CPUID.80000008:EDX.IBPB_RET[bit 30] [4].
> > > >>>
> > > >>> Adjust the cross-vendor features enumerated by KVM_GET_SUPPORTED_=
CPUID
> > > >>> accordingly.
> > > >>>
> > > >>> [1] https://www.intel.com/content/www/us/en/developer/articles/te=
chnical/software-security-guidance/technical-documentation/cpuid-enumeratio=
n-and-architectural-msrs.html
> > > >>> [2] https://www.intel.com/content/www/us/en/developer/articles/te=
chnical/software-security-guidance/technical-documentation/speculative-exec=
ution-side-channel-mitigations.html#Footnotes
> > > >>> [3] https://www.amd.com/en/resources/product-security/bulletin/am=
d-sb-1040.html
> > > >>> [4] https://www.amd.com/content/dam/amd/en/documents/processor-te=
ch-docs/programmer-references/24594.pdf
> > > >>>
> > > >>> Fixes: 0c54914d0c52 ("KVM: x86: use Intel speculation bugs and fe=
atures as derived in generic x86 code")
> > > >>> Suggested-by: Venkatesh Srinivas <venkateshs@chromium.org>
> > > >>> Signed-off-by: Jim Mattson <jmattson@google.com>
> > > >>> ---
> > > >>>  arch/x86/kvm/cpuid.c | 6 +++++-
> > > >>>  1 file changed, 5 insertions(+), 1 deletion(-)
> > > >>>
> > > >>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > > >>> index ec7b2ca3b4d3..c8d7d928ffc7 100644
> > > >>> --- a/arch/x86/kvm/cpuid.c
> > > >>> +++ b/arch/x86/kvm/cpuid.c
> > > >>> @@ -690,7 +690,9 @@ void kvm_set_cpu_caps(void)
> > > >>>     kvm_cpu_cap_set(X86_FEATURE_TSC_ADJUST);
> > > >>>     kvm_cpu_cap_set(X86_FEATURE_ARCH_CAPABILITIES);
> > > >>>
> > > >>> -   if (boot_cpu_has(X86_FEATURE_IBPB) && boot_cpu_has(X86_FEATUR=
E_IBRS))
> > > >>> +   if (boot_cpu_has(X86_FEATURE_AMD_IBPB_RET) &&
> > > >>> +       boot_cpu_has(X86_FEATURE_AMD_IBPB) &&
> > > >>> +       boot_cpu_has(X86_FEATURE_AMD_IBRS))
> > > >>>             kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL);
> > > >>>     if (boot_cpu_has(X86_FEATURE_STIBP))
> > > >>>             kvm_cpu_cap_set(X86_FEATURE_INTEL_STIBP);
> > > >>> @@ -759,6 +761,8 @@ void kvm_set_cpu_caps(void)
> > > >>>      * arch/x86/kernel/cpu/bugs.c is kind enough to
> > > >>>      * record that in cpufeatures so use them.
> > > >>>      */
> > > >>> +   if (boot_cpu_has(X86_FEATURE_SPEC_CTRL))
> > > >>> +           kvm_cpu_cap_set(X86_FEATURE_AMD_IBPB_RET);
> > > >>
> > > >> If SPEC_CTRL is set, then IBPB is set, so you can't have AMD_IBPB_=
RET
> > > >> without AMD_IBPB, but it just looks odd seeing them set with separ=
ate
> > > >> checks with no relationship dependency for AMD_IBPB_RET on AMD_IBP=
B.
> > > >> That's just me, though, not worth a v4 unless others feel the same=
.
> > > >
> > > > You thinking something like this (at the end, after the dust settle=
s)?
> > > >
> > > >       if (WARN_ON_ONCE(kvm_cpu_cap_has(X86_FEATURE_AMD_IBPB_RET) &&
> > > >                        !kvm_cpu_cap_has(X86_FEATURE_AMD_IBPB)))
> > > >               kvm_cpu_cap_clear(X86_FEATURE_AMD_IBPB_RET);
> > >
> > > I was just thinking more along the lines of:
> > >
> > >         if (boot_cpu_has(X86_FEATURE_IBPB)) {
> > >                 kvm_cpu_cap_set(X86_FEATURE_AMD_IBPB);
> > >                 if (boot_cpu_has(X86_FEATURE_SPEC_CTRL))
> > >                         kvm_cpu_cap_set(X86_FEATURE_AMD_IBPB_RET);
> > >         }
> >
> > AFAICT, there are just two reasons that X86_FEATURE_IBPB gets set:
> > 1. The CPU reports CPUID.(EAX=3D7,ECX=3D0):EDX[bit 26] (aka X86_FEATURE=
_SPEC_CTRL)
> > 2. The CPU reports CPUID Fn8000_0008_EBX[IBPB] (aka X86_FEATURE_AMD_IBP=
B)
> >
> > Clearly, in the second case, the KVM cpu capability for AMD_IBPB will
> > already be set, since it's specified in the mask for
> > CPUID_8000_0008_EBX.
> >
> > If this block of code is just trying to populate CPUID Fn8000_0008_EBX
> > on Intel processors, I'd rather change all of the predicates to test
> > for Intel features, rather than vendor-neutral features, so that the
> > derivation is clear. But maybe this block of code is also trying to
> > populate CPUID Fn8000_0008_EBX on AMD processors that may have some of
> > these features, but don't enumerate them via CPUID?
>=20
> There's another argument for just nuking these cross-vendor
> derivations. How do we factor in CVE-2022-26373 (Post-barrier Return
> Stack Buffer Predictions)?
> Intel CPUs without IA32_ARCH_CAPABILITIES.PBRSB_NO[bit 24] have a
> weaker IBPB than AMD CPUs with CPUID Fn8000_0008_EBX[IBPB_RET], and
> probably should not be enumerating that CPUID bit.
>=20
> Trying to derive cross-vendor mitigation equivalence is just going to
> end in tears.

Agreed, but I also don't want to break existing setups.  Is there a bare mi=
nimum
of sorts that we can advertise to userspace?  E.g. something that might be
imperfect, but has acceptable tradeoffs/risks for the existing code?

And then put a stake in the ground saying no more of these shenanigans.

