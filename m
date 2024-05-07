Return-Path: <kvm+bounces-16925-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AE5608BEE26
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 22:32:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4C8CAB210E0
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 20:32:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48C25B663;
	Tue,  7 May 2024 20:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eEP2QfXK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9C8B65F
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 20:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715113960; cv=none; b=XIQcNIhzslHqLBWS/0PMftsZjxobY5L9XVD6KwpWYbRFKFFyudHtmOJCtVkCf0+b/rho0kxHQ+UmH5sATWQDIElcHMDGQS4f1LcKiUfPP35u0cGv0yzyRbbtPs7nwISpR0UG2kqHS8FfnnbSsOu4xpXeFU8gtpGZotsyBdIZbz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715113960; c=relaxed/simple;
	bh=+BQuwIW4IGbFtPPJWnc0fsANNpbiLUtZt7sGynOM88Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=X+yU3LYgrs3CGuXc4HtNMFDTXUopn5dlFyXAzI6OhCqOFLjC9eicEsTf0Ce5fhfuu/e8e1QkWBIzOhujuN78fQqiAaz72aZuu38qmJ+IM/jlPpyXpFbiZ2K5hPk1u7AySlC4k3PUg1UIZE/ESPFIbyR4LdVXVoZHz2JYszK/lCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eEP2QfXK; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5724736770cso824a12.1
        for <kvm@vger.kernel.org>; Tue, 07 May 2024 13:32:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715113957; x=1715718757; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QQSFcQfNg22MPklpRC5LaBQSlxJMsDqnPWYKVVgXXnk=;
        b=eEP2QfXKiJxMGXwqjYAQuC0lVVrs4SYYPX/UTZei/vbAOKnyugllPMCIvbp26aevq1
         RVIBjxTQEd+VEUYDl636ZGTW80eOSDrUUX3CNJ8VVYje3GiId9HhH9OG5LaLSLI1ho7B
         b67Cm60kNeOOsZ+KJMt0VwDJ6ZqlJhBJB3rtstFmzkuO+umhK5mf2d3CR3hCniAkO83z
         cs+YTAI21RgkhOIXZKf5opvHfppzpx51hpBZIFViyI/yEWkRgzZnMifVjx+Hy2OT8hWc
         5786IuEmprbDkWcTNccicxMnHVP7hExi8VkoGfYh0RPNHA7/ECdVjwdVT/TArKHCDUQ6
         QTUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715113957; x=1715718757;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QQSFcQfNg22MPklpRC5LaBQSlxJMsDqnPWYKVVgXXnk=;
        b=oSWUqSL6p6Lod5U+o4A4W391OQV2DX138JJqL0wVOXFkhUe4AF68OF2AS7NqeaqpFI
         2TgFptYm87AwQu0G7CkP2gxvMyNmGwwX+ynoqu2Nzffb/l7P1ujQDd/7v1GT1Ys2D0yS
         KMME4DfrGIWW0PWw0k20qi5l8s49/RwdQU+KYZlAjeDRYsEq2kdkBbtgGdOQCNrl+hYm
         9qfvbFodFIpUlxReUYDAq6gA/HsHPlCFfWVYPLlRMyPX+Jm1O13BE5987toweBiHbVFN
         RnP8CONatx5xCTqOjGy2m2PoqO6+8mFr5tPvTOfQ/HKAhbBmEwQEg13UdDcX1aZ+rZII
         lKpg==
X-Gm-Message-State: AOJu0Yz/d/lODdA+NRtjYJs3WnTaoAJtqFTYdWDKLn6FVj3UngTme3j8
	0hJwTT5G3pKrXSmO+D2uaDI1lVqGJ6woIkLJsJUeOyeI/DgsULrJ6nA4V528VtTWS/iEvMsmf27
	uGDPYE2hnj1RkjQdQFaYMvPf1UlyH7SZThdPX
X-Google-Smtp-Source: AGHT+IEHTZ3Hp7zeS1GyMDSYzu1GRIhuZV2Pm9xC3kudevpWpq1hcyBBOIYR3cGs5g0Onn/jd3Olp+FgoxZvYHea0BA=
X-Received: by 2002:a50:85c4:0:b0:572:5597:8f89 with SMTP id
 4fb4d7f45d1cf-5731fea4d19mr44737a12.6.1715113956963; Tue, 07 May 2024
 13:32:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240411205911.1684763-1-jmattson@google.com> <CAA0tLEor+Sqn6YjYdJWEs5+b9uPdaqQwDPChh1YEGWBi2NAAAw@mail.gmail.com>
 <CALMp9eSBNjSXgsbhau-c68Ow_YoLvWBK6oUc1v1DqSfmDskmhg@mail.gmail.com>
In-Reply-To: <CALMp9eSBNjSXgsbhau-c68Ow_YoLvWBK6oUc1v1DqSfmDskmhg@mail.gmail.com>
From: Jim Mattson <jmattson@google.com>
Date: Tue, 7 May 2024 13:32:20 -0700
Message-ID: <CALMp9eSK-B91vdGZsbbgMitCNuBgBz=s67=PiPLCDxEzhFAb=w@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: AMD's IBPB is not equivalent to Intel's IBPB
To: Venkatesh Srinivas <venkateshs@chromium.org>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 11, 2024 at 7:57=E2=80=AFPM Jim Mattson <jmattson@google.com> w=
rote:
>
> On Thu, Apr 11, 2024 at 6:32=E2=80=AFPM Venkatesh Srinivas
> <venkateshs@chromium.org> wrote:
> >
> > On Thu, Apr 11, 2024 at 1:59=E2=80=AFPM Jim Mattson <jmattson@google.co=
m> wrote:
> > >
> > > From Intel's documention [1], "CPUID.(EAX=3D07H,ECX=3D0):EDX[26]
> > > enumerates support for indirect branch restricted speculation (IBRS)
> > > and the indirect branch predictor barrier (IBPB)." Further, from [2],
> > > "Software that executed before the IBPB command cannot control the
> > > predicted targets of indirect branches (4) executed after the command
> > > on the same logical processor," where footnote 4 reads, "Note that
> > > indirect branches include near call indirect, near jump indirect and
> > > near return instructions. Because it includes near returns, it follow=
s
> > > that **RSB entries created before an IBPB command cannot control the
> > > predicted targets of returns executed after the command on the same
> > > logical processor.**" [emphasis mine]
> > >
> > > On the other hand, AMD's "IBPB may not prevent return branch
> > > predictions from being specified by pre-IBPB branch targets" [3].
> > >
> > > Since Linux sets the synthetic feature bit, X86_FEATURE_IBPB, on AMD
> > > CPUs that implement the weaker version of IBPB, it is incorrect to
> > > infer from this and X86_FEATURE_IBRS that the CPU supports the
> > > stronger version of IBPB indicated by CPUID.(EAX=3D07H,ECX=3D0):EDX[2=
6].
> >
> > AMD's IBPB does apply to RET predictions if Fn8000_0008_EBX[IBPB_RET] =
=3D 1.
> > Spot checking, Zen4 sets that bit; and the bulletin doesn't apply there=
.
>
> So, with a definition of X86_FEATURE_AMD_IBPB_RET, this could be:
>
>        if (boot_cpu_has(X86_FEATURE_AMD_IBPB_RET) &&
> boot_cpu_has(X86_FEATURE_IBRS))
>                kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL);
>
> And, in the other direction,
>
>     if (boot_cpu_has(X86_FEATURE_SPEC_CTRL))
>         kvm_cpu_cap_set(X86_FEATURE_AMD_IBPB_RET);
>
> But, perhaps all of this cross-vendor equivalence logic belongs in user s=
pace.

In case it wasn't clear, I contend that any cross-vendor equivalence
logic *does* belong in userspace.

Thoughts?

> > (Also checking - IA32_SPEC_CTRL and IA32_PRED_CMD are both still
> > available; is there anything in KVM that keys off just X86_FEATURE_SPEC=
_CTRL?
> > I'm not seeing it...)
>
> I hope not. It looks like all of the guest_cpuid checks for SPEC_CTRL
> also check for the AMD bits (e.g. guest_has_spec_ctrl_msr()).

