Return-Path: <kvm+bounces-24445-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 82F68955251
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 23:26:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2DFE6282FEA
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 21:26:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1958E1C5791;
	Fri, 16 Aug 2024 21:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Mua+6r49"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF4581AD7
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 21:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723843597; cv=none; b=Ltpqwl11RhjFiFgFpdkN7B6HcHjeMm5+U6aUrQs19mLAefRN0l+mYmBuVSmvwhRxe9YG7nRhpoMBfDozZL3oQM+JcUP85PupHRBFBo2Dh6p9NJyWegeVaQw5N8XrHQHSe6DrbAwmNme/PgSSHcpJAbeY2yLjF7PUbKjT9NUV4UA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723843597; c=relaxed/simple;
	bh=5ppxf+Y6WsUdlQm0aUcfjn798IvlS+dy6RuGvqYcwYg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Iwnw9fHE83WbLGIxcLYsvkTPtZEztGmhrvJHD7LrKxdJDsGJohC+lEngXm3gV/k8rzSK17XDGRcCuzSiofZ0RHlTqsB/Au+O9+MTxbLynDd3hKZCmKXKa7aSbqjIPj4VXLJRH+SIPjNKUUjsXbSATAHbE85L5QkbmeUh6qb4Yac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Mua+6r49; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-70d1df50db2so1853183b3a.0
        for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 14:26:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723843595; x=1724448395; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HkahRcSIqrdLqkNeB4Y7kb7o5hmnbjiFsL1jFZGA0rY=;
        b=Mua+6r496ad2lHEtQFjCuZg6K5DNi+OmzQwG3AAk5sYz8b1HeRpkbpkWoT+f1SVPTS
         2mEyhaWC2evnjkLsDke7+acmNH0R1FMokW5bRM1DBDvLePJj/EJvgRTWMQWjQFRhw1wr
         m/V8W4sxR+uVHzdw/16qnSCd6oUWdTlI3oqin7/fbTtV9V7dbAguwa62pFU8NQurARor
         6BAMg7JSqhXLsI8U5Y1yPEtiR4MUs2MhsW9iVl/9L3m5W1aZWrIzuPTo9Eo9u31PVYZs
         X05ojViwwUb6Zb2xwxyyMWGUVncL4F6CAfw6PoViILB53aaxAqw4zJ84fa+VCroaz4mX
         KSLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723843595; x=1724448395;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=HkahRcSIqrdLqkNeB4Y7kb7o5hmnbjiFsL1jFZGA0rY=;
        b=BW/L0C+v/pTKg4b388MkC5P/0knvdcBONPDn7QpllTjqHB26A/MJ4JTYoSlfAc+8Ir
         1bOta04dugAWQmTNz+QiKdsj4XG5gC8E8LGXbeL5q9qiNk92RymPowTfDPKri5j7N2fb
         l16cRw5yDsQl52TVjQshmTVnYwb16TPELheUaOiXef8lQh1fmEVPQzMZFd99ke8LLVOA
         EyzczMtqmZKLJ7wjvJLZy09GvQFBNqxlp+Diz4K3jiXl05j4nhFMbf96kgXoe34dUKZi
         Wb2lZSOwVHarHX7F3bv0ijHp1OlEhsKm0H/m9tTRYPrELN+EMTgH90V1pmmLNt8tsy+v
         EwXg==
X-Forwarded-Encrypted: i=1; AJvYcCWWLK7b2OiWllBLN430bfdXt3QXJqqtgliSVRXDBPbKdLznm1Ruxj5EOTUt6uyCwOkTSfCRU5FSS/xxI8NimG/mWsLy
X-Gm-Message-State: AOJu0Yynb56lo6HhDX8pWsfDqV2Kvr4SrzMQ3gVyTGjuQlQKSpBUjjom
	Xms3NH+xvS+Us7q9Xe8XWZoS/rgoUay+CXx4ktN0ZnHPWXPT95wDSsH/VkNpe1e7iCLmPRlvwVQ
	TsQ==
X-Google-Smtp-Source: AGHT+IHx+1rSNLgGuYbVvHc9WkLM2RJLWwJgTCDZFwIdrojS15iwz+f8ZK6SkAzyF0XQ91a0ES9tppZqE8s=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:6f0a:b0:70d:323f:d0aa with SMTP id
 d2e1a72fcca58-71277167a25mr77643b3a.2.1723843594917; Fri, 16 Aug 2024
 14:26:34 -0700 (PDT)
Date: Fri, 16 Aug 2024 14:26:33 -0700
In-Reply-To: <CALMp9eQ9k+SicmeEFvvyBrJH39HJa-=wP9cMhRRGy21+6ihEew@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240411205911.1684763-1-jmattson@google.com> <CAA0tLEor+Sqn6YjYdJWEs5+b9uPdaqQwDPChh1YEGWBi2NAAAw@mail.gmail.com>
 <CALMp9eSBNjSXgsbhau-c68Ow_YoLvWBK6oUc1v1DqSfmDskmhg@mail.gmail.com>
 <Zr9hRydHFvPIMfUp@google.com> <CALMp9eQ9k+SicmeEFvvyBrJH39HJa-=wP9cMhRRGy21+6ihEew@mail.gmail.com>
Message-ID: <Zr_ECXW4oKGePiem@google.com>
Subject: Re: [PATCH] KVM: x86: AMD's IBPB is not equivalent to Intel's IBPB
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: Venkatesh Srinivas <venkateshs@chromium.org>, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 16, 2024, Jim Mattson wrote:
> On Fri, Aug 16, 2024 at 7:25=E2=80=AFAM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Thu, Apr 11, 2024, Jim Mattson wrote:
> > > On Thu, Apr 11, 2024 at 6:32=E2=80=AFPM Venkatesh Srinivas
> > > <venkateshs@chromium.org> wrote:
> > > >
> > > > On Thu, Apr 11, 2024 at 1:59=E2=80=AFPM Jim Mattson <jmattson@googl=
e.com> wrote:
> > > > >
> > > > > From Intel's documention [1], "CPUID.(EAX=3D07H,ECX=3D0):EDX[26]
> > > > > enumerates support for indirect branch restricted speculation (IB=
RS)
> > > > > and the indirect branch predictor barrier (IBPB)." Further, from =
[2],
> > > > > "Software that executed before the IBPB command cannot control th=
e
> > > > > predicted targets of indirect branches (4) executed after the com=
mand
> > > > > on the same logical processor," where footnote 4 reads, "Note tha=
t
> > > > > indirect branches include near call indirect, near jump indirect =
and
> > > > > near return instructions. Because it includes near returns, it fo=
llows
> > > > > that **RSB entries created before an IBPB command cannot control =
the
> > > > > predicted targets of returns executed after the command on the sa=
me
> > > > > logical processor.**" [emphasis mine]
> > > > >
> > > > > On the other hand, AMD's "IBPB may not prevent return branch
> > > > > predictions from being specified by pre-IBPB branch targets" [3].
> > > > >
> > > > > Since Linux sets the synthetic feature bit, X86_FEATURE_IBPB, on =
AMD
> > > > > CPUs that implement the weaker version of IBPB, it is incorrect t=
o
> > > > > infer from this and X86_FEATURE_IBRS that the CPU supports the
> > > > > stronger version of IBPB indicated by CPUID.(EAX=3D07H,ECX=3D0):E=
DX[26].
> > > >
> > > > AMD's IBPB does apply to RET predictions if Fn8000_0008_EBX[IBPB_RE=
T] =3D 1.
> > > > Spot checking, Zen4 sets that bit; and the bulletin doesn't apply t=
here.
> > >
> > > So, with a definition of X86_FEATURE_AMD_IBPB_RET, this could be:
> > >
> > >        if (boot_cpu_has(X86_FEATURE_AMD_IBPB_RET) &&
> > > boot_cpu_has(X86_FEATURE_IBRS))
> > >                kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL);
> > >
> > > And, in the other direction,
> > >
> > >     if (boot_cpu_has(X86_FEATURE_SPEC_CTRL))
> > >         kvm_cpu_cap_set(X86_FEATURE_AMD_IBPB_RET);
> >
> > Jim, are you planning on sending a v2 with Venkatesh's suggested soluti=
on?
>=20
> I really like the idea of moving all of the cross-vendor capability
> settings into userspace, but if we want to keep this in the kernel,
> then I'll send V2.

Unfortunately, that ship has likely sailed for the existing code, because I
suspect userspace has come to rely on KVM's behavior.  I do think it makes =
sense
to punt all future cross-vendor stuff to userspace, with exceptions for cas=
es like
this where we're fixing existing KVM support.

