Return-Path: <kvm+bounces-28079-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E69199352B
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2024 19:38:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AF9F61C23359
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2024 17:38:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F27EE1DD9D4;
	Mon,  7 Oct 2024 17:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ePNugoc1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB7141DD9BE
	for <kvm@vger.kernel.org>; Mon,  7 Oct 2024 17:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728322696; cv=none; b=uXxqdLG84LHpjNP8bw2nY9OuxrZjw6/Eo9EkIM7wKtZbIKOGV4NLWEy9qfXRpua6pO43VyAL2GC0Q/UE2FoUcas9ZIZXqQcvILDYOz3JK5s+/GNIgycalyrU/H8QOCUhj2oY9ef420Lz3Uc581ojiduET18af8uWbK0nuLd7UPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728322696; c=relaxed/simple;
	bh=/k6vljXwBlgCjmZ3+FeBxgnPubYqyHVa/VgKHxklvOc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QonQNblc7zTKrRM9hN4txCFKObuc7oGPOrCaCnUFcludVSCOlFYkXQiR0Ks+XLgVn5nnDiCf64ALaIOyNJorzB57C9b7OOyJm0ZHs+o1jHnKkf/vac2AGYu1te3E3gMjwWlqquMPDmGN+ejwRk709xRwr0GSoTNHMxeJTEG1zpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ePNugoc1; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4581cec6079so24071cf.0
        for <kvm@vger.kernel.org>; Mon, 07 Oct 2024 10:38:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728322693; x=1728927493; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QS16seDgTrfXYQ3DhtlLPe9kHa0/3e1Rh1j402yuupk=;
        b=ePNugoc1yj/dc9bPt5kWLsVHYYr4CaEq4WDTr4Vx9VDqVy9yPxKm5MBCZY9ADm7c8t
         Q7VCumDOy9AQJhdo5HDV0h3VNz/qlL3jGxRTVwnjEAMuIyLgW90XSClV5md4JIMMLs7S
         ueYgf4HN/mMBMe9ic+75yTs1QdGi5pxO3rJJa0K73FLpJu1htrYobEFRGZDanHMDDShX
         2RrneFS/5l4HY+Rn9rhMq014zn61Q0QD91lTr0MLhEr0NheX+ZFTEdK5iipOE767V9rN
         mfKnzMneVe3YCBq4bmzBNLqrDqFhXHD16z+OaZx04leybCbSfvXvS9Mhd2eg0D5ZYkC9
         NvzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728322693; x=1728927493;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QS16seDgTrfXYQ3DhtlLPe9kHa0/3e1Rh1j402yuupk=;
        b=KJjAUTKwV0r/QjSA9bsgFe4NCxr1A5txrvjQl4+kd3n8OG9+MTIXbFOmPBGB7gsbPO
         Pb7bPEZ7sb19ahJ7YJML9Q3lmtfXq5qvqtOBMqjp437QjarnQ3Lwnl+fdocBqP6r+rVX
         nlogDFqbWQXoOazPPudlm1KF9NuKXpe+Og61xG5bGtO4Qs/n/SFH28BLCpbdpyecncBv
         ayPaxqOELCQoOVmKtvM75t677d/H8tO1Wz4EaPs8xzKviQ4NUR08qEFbMtiMwebn7aL2
         HZcTq/vSs37B6SvhFie04/yzgaF8eok+3VXTuATdvKTK3lzeVNMDPkVUJLzvIIGlKbsL
         IRNQ==
X-Forwarded-Encrypted: i=1; AJvYcCVUQ+X65qw8ongQvOI9WawkCDgPkoUCkleGHEXD0/Ayak8WsquCItv36PSZwHKy55AttXc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyd7zfcgCa74ZcniZtPn9vDjAA9aG8gDmrB6fRXntq1yKWTssND
	U8h1R+bFVh0Uvq8HoRJW/C7PcMBGyoyyk8TKgSwz6Lb09TjK4KsDer8eB9wyPrC0P2fG3qElbVc
	If4I9mPW38L/b8Fp3hxb6eln8Kl1dYavYOpiV
X-Google-Smtp-Source: AGHT+IEpqvxvf+zPWcZiQ0lIWhuFlOh+jjsrdaovB5Fk7Ch8SA+B6A3r9V3OzIKYc/kDyDbDW9nioC5hsWFKF7dDsdQ=
X-Received: by 2002:a05:622a:8611:b0:45c:9b41:248f with SMTP id
 d75a77b69052e-45da98514dbmr6843251cf.25.1728322693424; Mon, 07 Oct 2024
 10:38:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240913173242.3271406-1-jmattson@google.com> <20240913173242.3271406-2-jmattson@google.com>
 <20241007143019.GAZwPwe286itXE2Wj2@fat_crate.local>
In-Reply-To: <20241007143019.GAZwPwe286itXE2Wj2@fat_crate.local>
From: Jim Mattson <jmattson@google.com>
Date: Mon, 7 Oct 2024 10:38:01 -0700
Message-ID: <CALMp9eSZX_fEy6=wWr=HY_6kDULE6-8_16cRGgfjoVhGguF7AQ@mail.gmail.com>
Subject: Re: [PATCH v4 1/3] x86/cpufeatures: Define X86_FEATURE_AMD_IBPB_RET
To: Borislav Petkov <bp@alien8.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Sandipan Das <sandipan.das@amd.com>, Kai Huang <kai.huang@intel.com>, x86@kernel.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Venkatesh Srinivas <venkateshs@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 7, 2024 at 7:30=E2=80=AFAM Borislav Petkov <bp@alien8.de> wrote=
:
>
> On Fri, Sep 13, 2024 at 10:32:27AM -0700, Jim Mattson wrote:
> > AMD's initial implementation of IBPB did not clear the return address
> > predictor. Beginning with Zen4, AMD's IBPB *does* clear the return
> > address predictor. This behavior is enumerated by
> > CPUID.80000008H:EBX.IBPB_RET[bit 30].
> >
> > Define X86_FEATURE_AMD_IBPB_RET for use in KVM_GET_SUPPORTED_CPUID,
> > when determining cross-vendor capabilities.
> >
> > Suggested-by: Venkatesh Srinivas <venkateshs@chromium.org>
> > Signed-off-by: Jim Mattson <jmattson@google.com>
> > ---
> >  arch/x86/include/asm/cpufeatures.h | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/=
cpufeatures.h
> > index cabd6b58e8ec..a222a24677d7 100644
> > --- a/arch/x86/include/asm/cpufeatures.h
> > +++ b/arch/x86/include/asm/cpufeatures.h
> > @@ -215,7 +215,7 @@
> >  #define X86_FEATURE_SPEC_STORE_BYPASS_DISABLE        ( 7*32+23) /* Dis=
able Speculative Store Bypass. */
> >  #define X86_FEATURE_LS_CFG_SSBD              ( 7*32+24)  /* AMD SSBD i=
mplementation via LS_CFG MSR */
> >  #define X86_FEATURE_IBRS             ( 7*32+25) /* "ibrs" Indirect Bra=
nch Restricted Speculation */
> > -#define X86_FEATURE_IBPB             ( 7*32+26) /* "ibpb" Indirect Bra=
nch Prediction Barrier without RSB flush */
>
> I see upstream
>
> #define X86_FEATURE_IBPB                ( 7*32+26) /* "ibpb" Indirect Bra=
nch Prediction Barrier */
>
> Where does "without RSB flush" come from?

Bad git hygiene. This should have been a 4 patch set, not a 3 patch
set. Sigh. I'll send out v5.

