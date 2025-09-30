Return-Path: <kvm+bounces-59173-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D7F9BADFFB
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 18:03:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B91F73AD692
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 16:03:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA67E308F0B;
	Tue, 30 Sep 2025 16:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GH0GHCLo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AAF5296BD0
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 16:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759248181; cv=none; b=syR4C2yAdXgYR/Ph+6BHcHxKKBk67t32J8c8ExMOe5FfDzbayObxaKOoLJibueWDOiTkDQoRcHvpdGfOhzo7p8muaIsFTRxjKInAPAE+tHiTevj9t2BSsaf8u3+/JBdebI6lyOCotcJY3UvvDBt3YUazoxI7cFMdbnQf5zITf14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759248181; c=relaxed/simple;
	bh=4H5ivC42iGboDlNRg/jHLDzngsG9MUAp1XZj1FGUAa8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZSV8Yey6Gt2BAizIoQQl1bBuOJu/K2dh+sNXrG9wxa4/Lux3j0qJZfDcECtRf3lWLLZUgEVtkHTARXR0hGlxTWW9Gc/KurYOWqWh2rYbx9saIaS43qzxGAig/Dj3xGrHWZeYxSiI2WooAz0FLGaOqrHSjPBjiAazJ6oXoI07UCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GH0GHCLo; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-634cc96ccaeso10392a12.1
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 09:02:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759248178; x=1759852978; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wR5yab+3mAkkpNkpm+p0JIJ5oTzrX6iWyN4NvUKvqJQ=;
        b=GH0GHCLoXMFKsxIAkxuZO6FOnTDrL/IK5jLXL/Gi2yPnrmpXSBTRE8TzKnwAmEJWM3
         ZIWlnbokXlHlPyJsPyPA966kM8RkKGp+fqNHo0dl/J+UX6TZaVTitdPuRZysfl1YwvCL
         hUbXa6Fc7PK8dlBS65Tfh3JDF2Xt0I41ZDNE4EqYG5ZKGSQY9JihcZjsyea5Cwr8x1AO
         q2faBgImRG42eHiHaUMVk/zn/n+PYcQwrmq6wPPiSPDIx8//OGqe2VcMi7WtBSongK7p
         ojbtAoI/IZGhNZa8R3Tz8hczM/Zdtjtg+zdtsubZIfCFXetTma5cwdAHURVUc4KfJlCk
         Fovg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759248178; x=1759852978;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wR5yab+3mAkkpNkpm+p0JIJ5oTzrX6iWyN4NvUKvqJQ=;
        b=FTm1X0AAUT3Z7QGKCG+tvsqcQDmD2mmVi7AVDOt34zkUyMJ8JG8PxEDuyulTDJci1P
         uMvLgWZanmndSehVvkLLRup6z0T8HsYtmPhbaJ+3slIP3F6NnGH5OEPbW5z84Y83JBPP
         husyl1Ebb8ToKW+H3NRSTZzSmrkqhddti7PBWoJY0CB7tfcyxhV2jOny1LYbNi7LYBa7
         9WFNqOndzfZNLBt4zW/fLDNg2HrUAWtZEpTnbhM6/khLgdMMjsuIMwK4EReolSx/X8Cu
         c8+9/PPOBVlWDQFLpbBFlITqqM6IsijIjzcg0zZLP1VW/FL76AofAdlkpmLEmxfZEHtd
         qHyA==
X-Forwarded-Encrypted: i=1; AJvYcCWAMV49GwUQ0+icOXTWA3AQr7nO27ttEMLZgxshtjxIn0Q9inwdogDkuZZw4CdqMehMjDg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy56imH81f9TqOHFB4cBQO0BMzI4MaleHbZKL9dwSeG4nJ5No4V
	tOrYHRB9jmOJe+LlnHglCQZI1l2u7znOwLJ0fg01JC0QlmghfhQ35+LMO++aKBSoJFFGp/rh0dh
	D8MEXmEtN76vq3+ROU/MPoEuhXl56hPD444KqNFGk
X-Gm-Gg: ASbGncvqLaDde4azHd0DC5zE8KYBgGrYJLF4bFK3kdDf+tsBRxSGHzwfAx01Y78uAb7
	M75eK+EqGYAXDWXqQceIPW3NIlRc3chLvnivQ8kStJjAK4fZkOOq8YWBZoo5cHI5Z9MYkNkW8CZ
	bSts7bOHloP0aGi+X5K6ub6oY3kcmwy6Py1nJymYUweWBzntW8NrQa94+/k8OzoN4RY3sCNRUYi
	BTyeY2a0uayq1zByHV6mbloJNwx2vXmj3gIqA==
X-Google-Smtp-Source: AGHT+IEZWtOBTyXxKQjDwzpjK2LyMs7bA8jlsXe9Xl8JwVi3T41PbSt+fNwdwvHnDfT8He10nUD1XufbqjenFQKFYl4=
X-Received: by 2002:a50:9ee6:0:b0:624:45d0:4b33 with SMTP id
 4fb4d7f45d1cf-6366271cc53mr107133a12.7.1759248178006; Tue, 30 Sep 2025
 09:02:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250925202937.2734175-1-jmattson@google.com> <byqww7zx55qgtbauqmrqzyz4vwcwojhxguqskv4oezmish6vub@iwe62secbobm>
In-Reply-To: <byqww7zx55qgtbauqmrqzyz4vwcwojhxguqskv4oezmish6vub@iwe62secbobm>
From: Jim Mattson <jmattson@google.com>
Date: Tue, 30 Sep 2025 09:02:46 -0700
X-Gm-Features: AS18NWCnJZ79ywsz3z1Wbi6tNHrDbksEtFYiwoRGwI8KWHvUE878xEuUFS3ZcU0
Message-ID: <CALMp9eRvf54jCrmWXH_WDZwB7KJcM3DLtPubvDibAUKj7-=yyg@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Advertise EferLmsleUnsupported to userspace
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Manali Shukla <manali.shukla@amd.com>, Sohil Mehta <sohil.mehta@intel.com>, 
	"Xin Li (Intel)" <xin@zytor.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 30, 2025 at 8:31=E2=80=AFAM Yosry Ahmed <yosry.ahmed@linux.dev>=
 wrote:
>
> On Thu, Sep 25, 2025 at 01:29:18PM -0700, Jim Mattson wrote:
> > CPUID.80000008H:EBX.EferLmsleUnsupported[bit 20] is a defeature
> > bit. When this bit is clear, EFER.LMSLE is supported. When this bit is
> > set, EFER.LMLSE is unsupported. KVM has never supported EFER.LMSLE, so
> > it cannot support a 0-setting of this bit.
> >
> > Set the bit in KVM_GET_SUPPORTED_CPUID to advertise the unavailability
> > of EFER.LMSLE to userspace.
>
> It seems like KVM allows setting EFER.LMSLE when nested SVM is enabled:
> https://elixir.bootlin.com/linux/v6.17/source/arch/x86/kvm/svm/svm.c#L535=
4
>
> It goes back to commit eec4b140c924 ("KVM: SVM: Allow EFER.LMSLE to be
> set with nested svm"), the commit log says it was needed for the SLES11
> version of Xen 4.0 to boot with nested SVM. Maybe that's no longer the
> case.
>
> Should KVM advertise EferLmsleUnsupported if it allows setting
> EFER.LMSLE in some cases?

I don't think KVM should allow setting the bit if it's not going to
actually implement long mode segment limits. That seems like a
security issue. The L1 hypervisor thinks that the L2 guest will not be
able to access memory above the segment limit, but if there are no
segment limit checks, then L2 will be able to access that memory.

It should be possible for KVM to implement long mode segment limits on
hardware that supports the feature, but offering the feature on
hardware that doesn't support it is infeasible.

Do we really want to implement long mode segment limits in KVM, given
that modern CPUs don't support the feature?

> >
> > Signed-off-by: Jim Mattson <jmattson@google.com>
> > ---
> >  arch/x86/include/asm/cpufeatures.h | 1 +
> >  arch/x86/kvm/cpuid.c               | 1 +
> >  2 files changed, 2 insertions(+)
> >
> > diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/=
cpufeatures.h
> > index 751ca35386b0..f9b593721917 100644
> > --- a/arch/x86/include/asm/cpufeatures.h
> > +++ b/arch/x86/include/asm/cpufeatures.h
> > @@ -338,6 +338,7 @@
> >  #define X86_FEATURE_AMD_STIBP                (13*32+15) /* Single Thre=
ad Indirect Branch Predictors */
> >  #define X86_FEATURE_AMD_STIBP_ALWAYS_ON      (13*32+17) /* Single Thre=
ad Indirect Branch Predictors always-on preferred */
> >  #define X86_FEATURE_AMD_IBRS_SAME_MODE       (13*32+19) /* Indirect Br=
anch Restricted Speculation same mode protection*/
> > +#define X86_FEATURE_EFER_LMSLE_MBZ   (13*32+20) /* EFER.LMSLE must be =
zero */
> >  #define X86_FEATURE_AMD_PPIN         (13*32+23) /* "amd_ppin" Protecte=
d Processor Inventory Number */
> >  #define X86_FEATURE_AMD_SSBD         (13*32+24) /* Speculative Store B=
ypass Disable */
> >  #define X86_FEATURE_VIRT_SSBD                (13*32+25) /* "virt_ssbd"=
 Virtualized Speculative Store Bypass Disable */
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index e2836a255b16..e0426e057774 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -1096,6 +1096,7 @@ void kvm_set_cpu_caps(void)
> >               F(AMD_STIBP),
> >               F(AMD_STIBP_ALWAYS_ON),
> >               F(AMD_IBRS_SAME_MODE),
> > +             EMULATED_F(EFER_LMSLE_MBZ),
> >               F(AMD_PSFD),
> >               F(AMD_IBPB_RET),
> >       );
> > --
> > 2.51.0.570.gb178f27e6d-goog
> >

